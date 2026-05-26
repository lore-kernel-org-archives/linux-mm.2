Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C845CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 16:15:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBF2A6B0088; Tue, 26 May 2026 12:15:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6FF16B0093; Tue, 26 May 2026 12:15:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5F486B0095; Tue, 26 May 2026 12:15:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F6CB6B0088
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:15:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 40A311A034E
	for <linux-mm@kvack.org>; Tue, 26 May 2026 16:15:04 +0000 (UTC)
X-FDA: 84810070128.13.5631CD0
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5D61C40012
	for <linux-mm@kvack.org>; Tue, 26 May 2026 16:15:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=AwiokLBm;
	dmarc=pass (policy=reject) header.from=acm.org;
	spf=pass (imf17.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.14 as permitted sender) smtp.mailfrom=bvanassche@acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779812102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Anhq5FjNw5ss6qMVPZ01kvuQc5NdyWfGRn2xYsjiF0E=;
	b=nKEtCxOLO0eXpjsrrH+ewXszIlL2R4n/ZYnuPTMu4NHG5j2NUvxoKt6zHqR/ctg0/NiZ9X
	3Htu8I/BJryFYc61Pkrncggy8tYFAdxtJzX6FJwsKdArjzVYEtGFNFF34uU49/aDQyZMSP
	2+04IjG7uBzqa5bPsw/OR+B1UtCS5HA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=AwiokLBm;
	dmarc=pass (policy=reject) header.from=acm.org;
	spf=pass (imf17.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.14 as permitted sender) smtp.mailfrom=bvanassche@acm.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779812102; a=rsa-sha256;
	cv=none;
	b=Jtw2sgcxONia41gqaJosDsP/WAc6jiXYj74PFUPe8ATEeyxCxs7ngccE5DRl/8B7tcRrt7
	W/D773T4jJ5Xcd6a/fXmglk8U6QEY01oJ93HEbTlURVYdFHCeDhLuIlA/plo54BpPo2KqV
	aaQieBVFWBdi6DSE4Pbyyb3FRfJZdto=
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gPyWn3BVxz1XM6JN;
	Tue, 26 May 2026 16:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1779812096; x=1782404097; bh=Anhq5FjNw5ss6qMVPZ01kvuQ
	c5NdyWfGRn2xYsjiF0E=; b=AwiokLBmkPXRDvxv4gU5Q8BxVUMZRQTyw3y+Qzdh
	Z784kR81SRXa82sIkwXcsNyi3LSlK1dqku6rTPoMoPVmLytdqkrK3Yk8LKaof1z5
	IUvPNNPc/Q6S7kOjZkbSrACPm7bjIjgzu1IxxbKBQSlK4tuv38BU7fvs8dD3euDA
	Tw4fggBiI1+wbtfQf2lxAk1Mu/LOduAx3pQdID/Ykhu4h1DH/J12zN1DDyjiiSdq
	XX0cpwgKDWTwyPidFJSdYB7dm+oZ0m3I2dTqtBYofc2bGINuwLNf+Ojxd6k3KQ2K
	xZpeQClWswqs2VOXACuw4RtpJCE1iU/Qha8dSaZmA5A3hg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id zKWCJmXtLFCk; Tue, 26 May 2026 16:14:56 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gPyWd3bBJz1XM5jn;
	Tue, 26 May 2026 16:14:53 +0000 (UTC)
Message-ID: <f4e521ac-2381-49ca-8dcc-3cb3cf3ffaea@acm.org>
Date: Tue, 26 May 2026 09:14:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
To: Theodore Tso <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
 Matthew Wilcox <willy@infradead.org>,
 linux-f2fs-devel@lists.sourceforge.net, Christoph Hellwig
 <hch@infradead.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 Akilesh Kailash <akailash@google.com>,
 Christian Brauner <christian@brauner.io>
References: <ad30g9xMs9wNJhFb@infradead.org> <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org> <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan> <ag_OVwPF49LSZ7rz@google.com>
 <20260522141115.GA8258@macsyma-wired.lan> <ahCNmWbcd_2lAJyk@google.com>
 <20260522224108.GA18663@macsyma-wired.lan> <ahTzHyHBL8t0iNBR@google.com>
 <ybmbjekuvzmaw4hmlxd7nxs546dqtwmxqxwyali74d6m3u7tat@b4q3japqnhrl>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ybmbjekuvzmaw4hmlxd7nxs546dqtwmxqxwyali74d6m3u7tat@b4q3japqnhrl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5D61C40012
X-Stat-Signature: p9kb87cmaufi18exjb6kayphob7hnp7i
X-Rspam-User: 
X-HE-Tag: 1779812102-21392
X-HE-Meta: U2FsdGVkX180eCc26zQq+LISkj8onanpYdScGU6chk1Xwzzevc2DUTEH9otOV/+rSn3Ob/juqz5AcE2JY61lTIyeBVLzpubQ5Gmp3QlCdjjYqYU1xhGlaKnb6EyoRtbWNQIKOy0JG0g/2nukoMyTZo7JVUxdIkLaB7956aTmhj9PY4zIwPrU2CBojsmtivh8tq0kIgtV/1zl2B1pPtvFcPu5zV9ypJkx8YKyVujvf0xqCw1X+z9VIuYTRJEFGQ6icgKy8EvtQx7VKGHLjOYnS+t5jsekW5AFPoO4srSVnNF+Iv/5RQfakZOX/Fc6bE+tCfMyK9QeNB3y0DxzhhrnS9eg8yP59RzRSpPo6Ad2XXLK2fpV2HuCAoFwGCpFN3Lo8c7MuFx/WHfsXQJMDF506Zicfd3ZN2KczZzkADbnLzd8XL3Xlvrm3M4hLqWGpyq8G355NChtWHwX3sBslCWn1atzbomLocXTQ+jlgtGC5rEeknTwgHu8qLHV99XqOtyyll5FI2hgdnbOVNyll8Vh1AmmVNa1uCmBKAb5BAksmXjLGIjDxIq7WrSUZCzLPKsFGBdniEbBJa26KgqWuOu62c0iLfniDIzwMCQSocr34QZWI2LgfzG+22YE2HeOYhD3u/Ng4+nR+gqA+XgUg2XvjyZAoaCtxO60bXv1xnigtLIzBuiJrk6ohpgXYlCBmMzQCYNrkehXWCcM0eeJG794NFg6HTg3/4ilHxhrJAUYD5AGVXI6njpNdKB2u5IN3jo1vapNaSNqkwap7stH4+OEeiVzCh3TqEwzwDIS40fX845k7uCPpFIvTtFaWjNbvN3e56AGJCUU19hi0pCcXsJ38aCDSGnumtx/Rb9zG1lFOv7wTLc4sIcABT/nk8330Y4jiFVdm72E/S6S4NnYrNWyyYrHEUIDHEEXLdClU29AhpS0mGGQ9sot1UPrnPL3JNWrmmD/GTz0c39J+bhgJIM
 cmzA8bwf
 lVPmctdRti3f82iJrcN8y2TY7ETLGUYyyFLiovpDE5N7e6K7qP21e8ow3J7ArMasGx4CX9HQW8Fk4wcj7GEwdcIawTFJGe+AskGc7v/njRGqcQ3wu0sjPtzHQsf2TitllOiSWuBEScXFr+4QJuAMGAN7phouc2INy+EdHhhTOXOkWNmNp6k6TB0qUrrvvK9kW+El01vzCtFx0oROiSDZncRRzfy3QkHbYGGWaCey6jSFUgCOk657xTJrTGUYk0uEVsMVz+1mKE0LqootTLemCaXDE6qFIGflJCjeXTd4xe8zmz35NadluaW6ZRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 6:42 AM, Theodore Tso wrote:
> It seems... surprising that the additional I/O operations are actually
> throttloing UFS device bandwidth by 2x (4GB/s vs 2GB/s).  Have you dug
> into why this is happening, and whether there is anything that can be
> optimized below the file system?
The layers below the filesystem (block, SCSI, UFS) is what I'm
responsible for in the Pixel team and I can assure you that these are
highly optimized.

Since the transfer size used in Jaegeuk's tests is much larger than 4
KiB, how many CPU cycles are used per IO by the layers below the
filesystem is not limiting the transfer bandwidth.

Bart.

