Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAED5606A33B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 23:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=N8C2gB0w
Received: by kanga.kvack.org (Postfix)
	id DDBDE6B05B2; Wed,  4 Nov 2026 18:12:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8CCE6B05B3; Wed,  4 Nov 2026 18:12:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC9B66B05B4; Wed,  4 Nov 2026 18:12:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B168E6B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:12:53 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4B865A8624
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:12:53 +0000 (UTC)
X-FDA: 85398988626.26.0C3C8D8
Received: from mta1.migadu.com (out-77.mta1.migadu.com [95.215.58.77])
	by imf08.hostedemail.com (Postfix) with ESMTP id A44F4160005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:12:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N8C2gB0w;
	spf=pass (imf08.hostedemail.com: domain of jose.fernandez@linux.dev designates 95.215.58.77 as permitted sender) smtp.mailfrom=jose.fernandez@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793833971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S8+ywaCuxwURWPp9vITK42485CIUGSC5lym6cLndajk=;
	b=j6w9hCUPT/ycvlpjaTFhJ27y41cJjcW+5mWwwn1G1HExZS/vErDjHTiUXu1AXNMbjMMj4V
	ENbKLsOq2oVVRuQIb6/xtS+Jdo9zR31Wgb3ZQar86LHekKWyyQUyephqPRmwPzL+d7Svb/
	1mDvcXybslcRzCnso7G6AMDg7HBzGtM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793833971;
	b=4iBcOD+h5T2Nr/Gp++KArlOY08ECCQwYtoV3duuuIVAloDvnesv4ttVAN81mF+86Dh1Ue6
	1iOxQ8WdoFQbdqAzp5uSZyS32eI8gWpWUcHndR1d2wS3SywHdkp1xV+dwkyAG1JF2Inexg
	b7Jf8bZDhP9XqAYjnS3d+4Zx5OjaRXo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N8C2gB0w;
	spf=pass (imf08.hostedemail.com: domain of jose.fernandez@linux.dev designates 95.215.58.77 as permitted sender) smtp.mailfrom=jose.fernandez@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=S8+ywaCuxwURWPp9vITK42485CIUGSC5lym6cLndajk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793833965; v=1; x=1794438765;
 b=N8C2gB0wmhjMhk6mOX9K5o4dj0GnGNV8/EtSP09Ps3eASMY0aalPiV+aUMFtqwPrH4XWTwUg
 39Mi5bISSMrSbjqzS0qfu43dFhjDGis1MphF1EtDo9KYkOIisTczq4PFFRPPWXIlTiiCMbTyQ1k
 YYsvNXztVhwgcGQ6CLzbTse0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id bc1373684b9d3203;
	Wed, 04 Nov 2026 23:12:45 +0000
X-Mizu-Trace-ID: bc1373684b9d3203
X-Migadu-Flow: FLOW_OUT
Date: Wed, 4 Nov 2026 23:12:41 +0000
From: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
To: Pedro Falcato <pfalcato@suse.de>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Krystian Kaniewski <krystianmkaniewski@gmail.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/filemap: stop fault-around when the walk steps back
Message-ID: <20261104-jf-filemap-v2-pedro-reply-r2-74c87c6fbcf@linux.dev>
References: <20261031-jf-mm-filemap-map-pages-lower-bound-v2-1-21029744e589@linux.dev>
 <aunPI5eOUOAEUa8d@pedro-suse.tail5790ac.ts.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aunPI5eOUOAEUa8d@pedro-suse.tail5790ac.ts.net>
X-Stat-Signature: ad8kpfrsx5zkyaeqk7rk76y7kc6smkfg
X-Rspamd-Queue-Id: A44F4160005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793833968-391857
X-HE-Meta: U2FsdGVkX181x4HsnZNO83PLnSG28Woz89r08OgSlBR9tNm8lZuRr7NnSypnvb0IOTy9J9WkR4RP2GpWeEPIipAy0f2YwhYm/slZxBVQJLv1ZI4zCjD+f0gFs9x/F5k9GnFIgbS7KN1uI0LicCkZVCBYtouX8H4mdYF3wZbnPugHfl5lx5mVTeglJ0QiR27YGoUWlLHx3WaLfXOWYqQ681ZkzP8TaXFQaceYFK7muCY049keOFlOYaI03zqQb/sM85AKmQl2HQO4Zyh1V1YX0wUZgXOXikzi/CQRZFD4XzRCmesb85tqSwqUWeSE5Mwa3MH5yI/nDKsWhetoxpqYVPo1reJsFS7XGG8b9zawBxdVtQO/T0jXavIjpVSGMCjjK0XstW/b6pznBeXeV+zq21xtpjHlBCgRPGctBOrDCrClpbjjCJNmOfqwtShAZMEr5CqblCRDx7XeThyj72M57gy79pnJeMArwKyg2i4hu+FojZu3GfsAlt2lBwlDMsugChcjniz5uGgd8FnwdwivlI0Og8VMYySqJkyzcfO+91LxBPcbThS9vllLaRrU9FNFl3ZZ/fBOTJaxkhsJbG8m9QJL+XLQTbFwIBHWOY0gXemlHfB3Vq1X8Ib6Qs8tI62bXxnj1fLBOY/BLjQks5PKI7eR/XsPo5Jp4WZV9I8BxX1pQ3OJyYOcDj6XBPRV+jjkXwLV+GDB3FZKADwQ5nfULrrVg+U7j3VqSCuzFibqfIrqDJEprmryd3o8cLqkgxJmGbZ+F6ninDnRQDdDqVFVal3uRUixGKaytxbf2rHtOD5MOgSBU3bP0hUzxpXGqkrnP/Rs/bc5hbYYFP/BqdNSgWRLghQN5ZYHC6orJBFurOxJp5iyRVTcd715KXCFef1qYm8grXN6H4Hg5g0LR7NYpFE9Z7KDJxf+Te5RA+yB52kompeSnkSbBJjIV7boeDy9stmFBD70FjT3qXUMvir
 m+nyz4lv
 VDdfMXDZ0bMkHelfZQAIax5Qhrq93T8bAafQpHmiLQJ5zN3LNQceyZ27iS/h4OEu1+XRaKYk4F9J/ehYN7buzZSxi6NzHHc4UW3+jRppTdDx0qdMoMqAO9ycaFUCTE/wu6JT37naqu7r4D2IvMM2YCagwJt9YPXtz+rb1IJo2RfU9dflQc3tYlLu+F7ECfLAv0wYgNRjX6IAToRbe27t7iOe0+P+IX4r7N9fQaB/iiQ9eLRMFsqvPsCRgPvcqhomih/oDUnfz9nUaIZM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 12:12:58PM +0000, Pedro Falcato wrote:
> I'm not sure I understand. xas_find() was fixed. Is there any other case where
> this loop can step backwards?
>
> If not, I don't think this should be Cc: stable, and should probably be a WARN_ON().
> As it's a hardening patch and not an actual bugfix.

Yes, there is at least one more case. It triggers when a read fault
starts a lookup inside a large folio while a hole punch removes that
folio and a write puts part of it back. A stress test I wrote for the
race still made the fault-around walk step back with Krystian's
xas_find() fix applied. It happened in every run with an artificial
delay in the lookup and in 2 out of 40 runs without one. Some of those
step backs left a page mapped before the start of the mapping, and the
kernel reported it as a bad rss-counter when the process exited. With
this patch applied none did.

A WARN_ON() doesn't fit because ordinary operations racing with a fault
can reach this. So I recommend keeping the Fixes and stable tags as
David suggested on v1.

- Jose

