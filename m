Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78C8AE9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 06:49:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDBED6B0088; Wed, 18 Feb 2026 01:49:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C89C26B0089; Wed, 18 Feb 2026 01:49:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB6A66B008A; Wed, 18 Feb 2026 01:49:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A964A6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 01:49:48 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 24A65C0D76
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 06:49:48 +0000 (UTC)
X-FDA: 84456652056.12.54D9654
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf08.hostedemail.com (Postfix) with ESMTP id 63C60160004
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 06:49:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771397386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6yAPp5K0u5yljn5t7dUB/5B/5KcPWh+2lpBYwblBT0U=;
	b=cVo25YTU1IDY/Eq6GmDFFA1wKpfdnhdABfhLHYbAlLYw3R2Vaf9zVItzHGoI6vKnyB3rAE
	5+1TNPMsC8Z4MV/yEf0AqAXGxJYUG5LgPb3z6iv49cfPjXZ9eHbZBF4Qv4P0a5klBb18kB
	PsVnrQoB25dUIWQ89SXDUVLLdWdPab8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771397386; a=rsa-sha256;
	cv=none;
	b=vnJOAjys7xiqnftnY5m0CaoHd6D53bOXdRLKQD20U+hlk5ARA2RNf2/WIwzofWl/xIvsVA
	pDqMK5R9vbky7RvCAL5FqRh3RtErvQKEgHR9o+hyDMlHS1doEXJa4yg+JqigR5AgdRCP58
	EqkSpVfPyjz9xQ77ejfrGbOh6uerYdc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8ED2868BFE; Wed, 18 Feb 2026 07:49:42 +0100 (CET)
Date: Wed, 18 Feb 2026 07:49:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <dgc@kernel.org>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>, Jan Kara <jack@suse.cz>,
	Pankaj Raghav <pankaj.raghav@linux.dev>, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	lsf-pc@lists.linux-foundation.org,
	Andres Freund <andres@anarazel.de>, djwong@kernel.org,
	john.g.garry@oracle.com, willy@infradead.org, hch@lst.de,
	ritesh.list@gmail.com, Luis Chamberlain <mcgrof@kernel.org>,
	dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>,
	gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com,
	vi.shah@samsung.com
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <20260218064942.GB8881@lst.de>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev> <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com> <w3vwdaygcz3prsxwv43blo4co666mragpdwaxihbirt5stl4vr@agyz4mnaxghj> <aZS18m1eIxjDmyBa@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com> <aZUHHvNl6cQr-uwd@dread>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZUHHvNl6cQr-uwd@dread>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Queue-Id: 63C60160004
X-Stat-Signature: y7cex8t15r6dn5xr9f93amd18qg5n1b6
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771397386-179607
X-HE-Meta: U2FsdGVkX18/oC+2Wt+Md5gLn/ldbIN7qNPD2YYpAC3acnt1y8NCNHImQxYhKR56GFwnYolq30TnBmgb90f9zNGGyIz/gIU3SElkM/j5aZTv8N4ExfgYrEIQ6wws3XhzNUpWv9sZhRxojleVN/5/GeGaBez22ql2ZzzHv79hD7/E5YdE1/qkTXYTrlj/ecLtkM4Hsdj30p0puVJ8gwsj4mMayKuThQopNQwtr5KqJrGZalSms6kEKWTnEWClBmV3xaBubN/i5fEQRllPCLR0ztQnPBOBI1ppY2udHIOXcQpRQ6ogCSFbXbN150MoJP9k3Z6YHIxwLp/95v3r3BOUySkOLW73UV8AadfRouIdUfNUGU1J6iRWfP75r76wbr6FfGPiDe8nLWrNo7bQlCEdXNqBMZtukvquXwv+EO7jzu/Io2IxzZ/8X1TCi5hreCARKEeuS5F9q6zcRlvWoN0j0s6UQSBxJfFPSGWDkKVacwiwM5WyvkvvcSDnmkoStU3arxHqX6r+uMUH1Tc8yL9zOBJAPJrcF1qP6mMi3Sc8lP9skG+chS8YD3R+AOPSvl29tjQPY+uw9DQJ6SbNuSc8rYhtVXLCA/+fdQerFwRkOAu6GEzs2V442fKlk0evW8vgZBPQAy7FP6RYz0M5R+vS2kA1pZlcDqAnfBLkYC3DWdJDGJrN2H1aCBmN4X8Ly5WEIopeY5LqwX3iaBqc0wsgvzD9JDp1O/8FPZisG9uJVqr7XeQqOQvzDJR/z9Twv14u0NAovqwk1vcfaqKbzeTRtNci8GXH0Yqr3kw0KospMrfttNfY8hWbpjZwJSAeQNmSBiuBgmtRGAd4sKybENJTAQGd5QxcNajewrXdCY3K9jPp6GTW0R+eju6xHzt8hfaun9LG+7Ej9bjaj/gMdfoXksQ289PclbOcV4+CsJbMvzjm5Q/tM7j/MQvaMtsVBKXNAvquDANWAS5qPt25sOy
 x9wkT62/
 BvD8kTm6GDTsT9VtbyGi9Xk97P1jCeAmZwEaQC2Gw3ULIbVaogKQqLYFUkRvv8R7yU6ufwU4u1GZ9Ko8al8J1UzcspSNEHsrPGRqueyEB6j1MTVHzW17bs++I8h8FX2eIKEt0pz7AVTHed2aPhVDEav/fJ13Qp1q6mfQ3fRjVitHHHik=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 11:26:06AM +1100, Dave Chinner wrote:
> ISTR mentioning that we should be doing exactly this (grab page
> cache pages, fill them and submit them through the DIO path) for
> O_DSYNC buffered writethrough IO a long time again.

Yes, multiple times.  And I did a few more times since then.

> Regardless, we are here again with proposals for RWF_ATOMIC and
> RWF_WRITETHROUGH and a suggestion that maybe we should vector
> buffered writethrough via the DIO path.....
> 
> Perhaps it's time to do this?

Yes.

> FWIW, the other thing that write-through via the DIO path enables is
> true async O_DSYNC buffered IO. Right now O_DSYNC buffered writes
> block waiting on IO completion through generic_sync_write() ->
> vfs_fsync_range(), even when issued through AIO paths.  Vectoring it
> through the DIO path avoids the blocking fsync path in IO submission
> as it runs in the async DIO completion path if it is needed....

It's only true if we can do the page cache updates non-blocking, but
in many cases that should indeed be possible.


