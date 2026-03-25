Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17310109C05B
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 20:03:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 562AF6B0088; Wed, 25 Mar 2026 16:03:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 513BA6B0089; Wed, 25 Mar 2026 16:03:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 429A56B008A; Wed, 25 Mar 2026 16:03:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 30CC06B0088
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:03:14 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C5EFF1B8F65
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 20:03:13 +0000 (UTC)
X-FDA: 84585659466.20.060D317
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 011E510000B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 20:03:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DGdpCU8r;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774468992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O8ZXESSTV5RUt4WrAcP0iM+B6wmFQUKA7rFrsuGoibs=;
	b=pXNczno9iJm4e3M7xGvdiEDpg/cwbkmImf3tB/925YzgD5F81b1ZmQG7cT9AIZ6jbeOjWl
	KAkMNo0PT0ULHjsMmZH5j3INA1nAAcIIDufeQiABkUUJGFPGqwp6uj2mavD/0t9nXJYu+S
	LCtkNLN1x50R8WHnEype7oH/V2IpQDc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DGdpCU8r;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774468992; a=rsa-sha256;
	cv=none;
	b=cTDPpDeu9Sbbb85uBWn1p6AMX63L6ikodS3NZFmz5nmo1XmYNwAEbfFfS8KZyK2Tzpvnwb
	WvAIdGMTs8PcqCu1fiX/Hh/Z1ZIh0k+HnQhTHXM18QvDjObXRzgDfQ2zc7RLBXqKPyT2pi
	k+FLiXUFuu5L5O/BZnHjzadweLeZoRc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3965C60053;
	Wed, 25 Mar 2026 20:03:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B5CC4CEF7;
	Wed, 25 Mar 2026 20:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774468990;
	bh=En8tZyi9hnwQ7IKZABQuYWgOMBkW+LR3M5zBnaMUqIE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DGdpCU8re+1YVySq7t+jItUGOTCRKl0Y4+a3CQ+S7yMpBChErozdK76igIF/w4Ibi
	 STQyayilvFju7lyno+/dNh7UB32OX2VrfDpz4F8bLiNXb5fNRDXxeNQCMn5uaM4bx9
	 myaRzwQ2ZDcOcTwLgontscELbVl9kcqZTnH5xYofv8kpR67ET1GCQCpQezUL/guriV
	 iUPg4bEYY0rD/slyk7rIX8LrXnc9rgWPtzR5VbMMnaUVgFVilStX0VmiUbsaQeoDAZ
	 Dnz9Ig9ugxHuzqxQhwX35T1deRSPvHHjX3FlTmbTWduZd1H8nCJ/IVrWh+l5Q5lmNj
	 6aGJaCF8Ct6HA==
Date: Wed, 25 Mar 2026 20:03:05 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Vernon Yang <vernon2gm@gmail.com>, Wei Yang <richard.weiyang@gmail.com>, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH mm-new v8 2/4] mm: khugepaged: refine scan progress number
Message-ID: <9930979b-7bab-430b-ad29-fb35f36712b6@lucifer.local>
References: <22dccc17-787c-448e-a571-23c7a9afeaff@lucifer.local>
 <20260325080930.a205fca9e7e61c4a793f5228@linux-foundation.org>
 <3cf94628-3c6a-43ed-9fc1-29bd5a911497@kernel.org>
 <8d2e809c-e4c8-4d35-a2ae-62777b6dfbcc@lucifer.local>
 <0437ad42-612e-461f-906d-6757eb19a8de@kernel.org>
 <20260325091735.bf440358cf83c5d0369e0674@linux-foundation.org>
 <06c83e1b-d7ee-48d5-a5c4-faad39db2f53@lucifer.local>
 <20260325113650.fc6997e07a0a4ad0e46278d5@linux-foundation.org>
 <bddac979-24d2-441e-9c5e-529ca2f58366@lucifer.local>
 <20260325121549.2b887a8a8c154d5bf8529ea9@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325121549.2b887a8a8c154d5bf8529ea9@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 011E510000B
X-Stat-Signature: 7nwo1w7j31ixazk4imshd7q8wnk8yhre
X-Rspamd-Server: rspam06
X-HE-Tag: 1774468991-614382
X-HE-Meta: U2FsdGVkX18j7MuxwMVmAwyRN6v5l6seyafbgmlyG3myn9MUwUG6PO8vzg5TR/hIibNPvek9J43u4dVJbiPzVvf6tNuz9CdwjridpfAoTAsjlx8paCaGXcA4oifT3kKhibVslXhw6/KDjLJI8pDNGNhv/D1CBh8VXyU3fSzCicvGJJpaJFw6BsOIDg3ftyIPtWPmk8pzg7zoqzma1QJYbpe/fT0gPDS7Rexgd5nWDGSKw+8fhKE9/0Ddw5WwCPJvIOH3HIAQSYjVE9zNBVPB3y8AzPvyEGL3J4rQ2y5bAoZOvYDvlgo0FWkavP6RmzHJeRrZVZFHitC9jZZIC49MrPeikr+Fdz0yrFeJSyQLw7ho0AxrqG/57BAwJI840kATCQbHce2X/3o8DLe+R284PpykmqCNRmuXRZaee9nyYVIIUSB1+op2COT/kob82XicrxfZFMyKWVv2DlDuqainittcWoAPftCK0bBOweJ8yuuvuhygs4PhW0wgBeeV2IWhD9ewWpevYhBCAKLXBcZdyBmumRK/w5wymflOMk4XzpApnP5KGfCBugifZLSz6ie0d23vTzGt8emW/yo4l2COqClGvRcbYtlxbkuGU9N9iUeb4ovZacpEoeljtwVN/ve+wZT+ENcjkaFxsZ91Ki/+jS8p2LLoJyhJ5BF/B06/D2dDOvKCidNnf9a0VCsqiuEBfjhmPu8ja+/1OZ+6cVQ4qaWEKwQtifXCkmmVImJPt+8q4vqfsJcv36e/HdWWURAGb0oM0Trq1eAMBmqMahckggIKARbGqHHqDuCdqK+9SZCPh1tDiBk4fC+WhvRc/a74LArkO5g4ycoZbtBllC2NknDgTGN0KIkMIgIe+nMhack9p6yNjTjuQ8hrd0LiCTYuT3oHJNxNl1wlNQ3k6cQatiJ/A+ugGqjFjP6DYcJJYVpQpdgteKAIKz7M82cO45RC8Cvhb8Pu8T+rPaUCIZP
 njTba+Ai
 xnsIudEGerehpi195ZCIGxXJ6p1xT7tB2Y9LwI77Q7yAGQZSIMv3rs//jmuXVmD8/VE2B6GbSJAJZNWP5EkYIpwJXPxouE0733FSQTyecIcxDREHNeSCkrAIrFULU+nrxQIPFKSku/nl+3zI7z6+h2L3v7b01VAdIBprHAEmlAj2Fp5dEVJw/7Bs3+/Ft/rSEdGHh0irdfvrYN45vxq4naXMDT1viJvqWzJAUun+uyER7HoJIG/FpQM+7MZrQgv+Wq6PQt0DrNiXuazldaB9rhuSUWLlIBsdbNLCXGIQJ3JMZyyYFMfUgARp4kmh6fDsOLeEHLHQgxvg+S2mn/Ww9HrV09h6Qz7vZd8CBy+Q2sN8rGTJGpb9Rzg8KuoBmR5zgIoDs9zMIvYfOS1GNkgqjEjQPdOJItLxRHC+xPxFUaH2uc4bsdiektODUEBljzalwUYZL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 12:15:49PM -0700, Andrew Morton wrote:
> On Wed, 25 Mar 2026 18:53:40 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
>
> > > [akpm@linux-foundation.org: fix spello, add comment]
> > > Link: https://lkml.kernel.org/r/20260220151500.13585-1-rioo.tsukatsukii@gmail.com
> > > Signed-off-by: Rio <rioo.tsukatsukii@gmail.com>
> > > Cc: Joel Granados <joel.granados@kernel.org>
> > > Cc: Petr Mladek <pmladek@suse.com>
> > > Cc: Wang Jinchao <wangjinchao600@gmail.com>
> > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > >
> > > But these things are usually quite minor and the precipitating
> > > discussion can be found by reading the main Link:.
> > >
> > > > Maybe just directly squash the commits?
> > >
> > > Not understanding this proposal?
> >
> > I mean instead of having a separate commit for the fix, put that fix into the
> > patch before it and denote it with a footer as you put above.
> >
> > I guess that translates to what you do when you rebase and fold the fixes into
> > commits as you do now anyway.
> >
> > I don't see any reason not to do that right away, as really it's good to see the
> > combined change in one go for all practical purposes (if I resend, I'll be
> > combining work, if I can grab it from the tree and avoid a git rebase -i all the
> > better).
>
> OK.  So what have we concluded here?
>
> Is it: if I get a -fix, I add that in the usual way, then temporarily
> fold it into the base patch and mail the result out for fyi.  Then
> after <period> I permanently fold the fix into the base and add the
> footer?
>
> If so, what's <period>?

To me it feels like that should be 0, just squash it in right away, since the
trees are being rebased constantly right?

And that means the tree contains exactly what it would if the series were
re-sent.

David, what do you think?

Thanks, Lorenzo

