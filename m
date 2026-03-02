Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DF10EB3629
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 17:46:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C60516B0005; Mon,  2 Mar 2026 12:46:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C38106B0088; Mon,  2 Mar 2026 12:46:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B61976B0089; Mon,  2 Mar 2026 12:46:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A23186B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:46:28 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 78292140203
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:46:28 +0000 (UTC)
X-FDA: 84501852456.07.4036C73
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8826E10000E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:46:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=i1TL2srJ;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772473586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1wDjOv/udoQ+T566I7M3UrLahi8YqhOgmwDuUguUczM=;
	b=BtrTeGaJ7pDm78KO0Se0J1OYDIjyKTMabNDKC7lRWQ7jOjFRl/eqgMU02nQC3MYYrWv7oz
	8B3IVO8vVfB2bHTsWIqaIxCsNLAjObgbmIVuj+pM6SN5vaL2cZgWE6EyTT7mrzwLgoRhqO
	+G3pTYIJCbzgAFfnVLxYN9JePXt3o4w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772473586; a=rsa-sha256;
	cv=none;
	b=oQyfZrLq9DwSkLrqHeaEX96ckjdZJ7RMTWozvvop1RG5NMfFkci1yQaPQ14OsG93TPHF4A
	EpNefq4LCOX+3+sCR03VpfbcIjhI5BN4HZbgQ87tPE2Q+a6pVXMOmwV65Io5NUtf7oh+SN
	LNnzBEkHO8JT1VpwNtXsQe3USnjwE4U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=i1TL2srJ;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-506a3400f30so42091271cf.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 09:46:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1772473585; x=1773078385; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1wDjOv/udoQ+T566I7M3UrLahi8YqhOgmwDuUguUczM=;
        b=i1TL2srJMpeL4juAkq0xXMYl1I78V5qkQ9CyyJlX6Uxq8oBc40v8DJBMu3ssnq5qn0
         wN3xWaquli3SH5Sh4wxAYP9WY7hcthHa31U559RHHCY5QP2twnEDYazwI45IyMZKldxC
         JFtLb1iehyyctuuonhm16C+tlY/1D/ZISkl9gzOLbx2nl9lqqY8cXs/55LTM5nxRwRMm
         ey/cYVCcUKSJDgxS2tdBC6MY9tg50gs9/tIQGhQhKabhjwJjIJVRdDeooDI+RpPTLDRj
         BjUjZWQFaUWtJ4yTrLplqZii3590MSZ9+NBJBx34lM2yV4fWayF9qlnATdvYca6Snp75
         E/jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772473585; x=1773078385;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1wDjOv/udoQ+T566I7M3UrLahi8YqhOgmwDuUguUczM=;
        b=f7ZnArrM5y9rsDzJKXSJZkSeLzCYh9RBomRcSe6INcVNLpN147EzH3O8ox0vsZWhjZ
         o8TrdSIfHF/AnKDGW4yfypIAOO+fb6V7qFfmqxDX4+kpE/6jNzXr7iZPv6dGZ+3Ri6xD
         Kivq9DVzWrWX/DgQ+wGZSVYwIpw78PG0eY8cyheWbRh25CgQmKWddxVIbZ2mF+p9erPf
         66ddiTG5Yz82S4CH26coBte21+BRcNDQhBSIZu14O4EdQozW8FECKJt/2AZM57gBeEPI
         xWL9eVacneTCQ9OQ45/bpNGA1ZMHniSkIFYyqkybbw2CL947CQxY2uZTpSf6t9e6d68C
         wF+w==
X-Forwarded-Encrypted: i=1; AJvYcCUWiVUsTP9wXq9BkCN0aMAXya7kDfV+JZx9II8ZhBKpZb771E/+XOFjKClzExFTxKSUC2gInBN/yw==@kvack.org
X-Gm-Message-State: AOJu0YyDxEbeMdbzJPvlerPiA6qtkeirJim2AsKdVk5IxdTmfvp/g7cA
	+Bx77oYkP9LYACUPtHmedsjMS7ZCFApWVoytgYeKayLPgC4CQ8Brt7AiVEbQOq4KQZk=
X-Gm-Gg: ATEYQzzdf/MZDa4DrgY4KOWmS/PvhaPO3fSru1IKDX31xRkqZniZ9yQjMgue3oQmrtI
	7t1265BsVJxQfgB8yC8MlRO7tMFB/m9ChkNG6inpUyXCJlqHqdueSJnJQ4QZGn3madfyV+zlj9D
	5KL76WC/5r2RxcogG+V0b62vKfIS9V1+hpGq3kkR0IU0YfEWZM+kVHxMKcPxllRcoTqNFfZ8vsV
	o4baljsLUzYY/hUA00z1lZf0soXMLQbgGUBHdID1lVBJJ4OKV+NpHROmLheoKUbUTWH0aU28K6Z
	YVYEx+dB6e9sDBR72EVprnwwh98FWNYps+4JgHuTkDdDafCStbziJftnDN6h9ANnPOX0cVwuzVk
	33s/30h784udDNjc6Di5e3+A8rT16w1kEnj1mfTQFVVQ24jZMmXbPImUSHIvCh0yPjS6E4+EQkK
	fCSFX80+SP10iRQ+KLneMt9mDXEblK5bwBrD/o78eCTSggFBkQME/B/USw2+Y4sPH1DpBpOOkhz
	8GeWS3/5Q==
X-Received: by 2002:ac8:7c4f:0:b0:4ee:1dd0:5a50 with SMTP id d75a77b69052e-507523e005bmr176761601cf.17.1772473585487;
        Mon, 02 Mar 2026 09:46:25 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50744af0731sm126681761cf.31.2026.03.02.09.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 09:46:25 -0800 (PST)
Date: Mon, 2 Mar 2026 12:46:23 -0500
From: Gregory Price <gourry@gourry.net>
To: Barry Song <21cnbao@gmail.com>
Cc: willy@infradead.org, axelrasmussen@google.com, linux-mm@kvack.org,
	lsf-pc@lists.linux-foundation.org, ryncsn@gmail.com,
	weixugc@google.com, yuanchu@google.com
Subject: Re: [LSF/MM/BPF] Improving MGLRU
Message-ID: <aaXM7xNSJaJBsety@gourry-fedora-PF4VCD3F>
References: <aaBsrrmV25FTIkVX@casper.infradead.org>
 <20260227043139.95115-1-21cnbao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260227043139.95115-1-21cnbao@gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8826E10000E
X-Stat-Signature: fyjjfgmy1jxsgtd4mikuxy14y75zf99r
X-Rspam-User: 
X-HE-Tag: 1772473586-236323
X-HE-Meta: U2FsdGVkX1+mywIFi3lJMYlts0leRVWXcI7OUdgeqF1E/YOcC2oshOf+cMA+q1y4ykCAUIE+0fluQhMe+7T2ANB+BlXzzLzovcTE85bxthjfDuAoe4VUXKp/O//iW9Jhv0BB2jB1KipqgLbKCpF1XPsptDDnBMCyr+h+zDYpMqgWf75PsidSVmIqDIYgsPl/59DLJ6/+c3dyTgn3ZNuFPlb+j3pEVFY66dzN5jpDM/1uHhW881tBDoRBAvMd3NiNXZetpj8/XrsQuS3BnnzyvAdJqIEpzStAEWpAv/ndMZ6G0BeIcGqWH8C0laxanR4vYt48uB5u2woMLvZrWKgjuzJ+ugcu5ZXKYK8xam07r1GHAWg2LALAfd97Oap0zBDFZQg6zuPzshfx5HiWsxfbBhNFr76y4t9kcZbfu3wIARxbocIeC8zuEV7ZCpvOAjvpLVyKvpB/P1/QbGAZLB5cOvT8u036PG342B6s8m6UwzUkC36E8bfa5ZriBfW/rQw8g22ET5+T7vck0sf6mAzqotKvfiDpX3m9KpIf7KeQhKihCtG2HEjasZXDoKI8YCtgx+/pAA2nplnr5gz3+WCwSpEefLNfUYrCHuNTy8F2nyqqlxk0KDQs/lG02gVuRZALXXXYFimNZLTmyGLVQimmRpL4/64l5A4gAohYmra3i2A9Gte4uZQFcqm3pWN6ss2C7jBSS75SmrLIh19xmfcOZOYv1PDXQ3bnkxFqI8g+MYFSc+oXwPbkhXNrJNx/DMDEVR2SMrc2qBTvTcFEEfZcK/14WRgDxBdY3QftczowpfQ2CTsEnSlELzeXChRsnE5Kp9OezurUgRzX7HdTB2HDNOprnhd/HyrvtficxiWXZtIHCiKmY5JdHcGOH8E9+zoYbUkfEmlQfX6XhRvVMjqSECHInGp0eAV7aLPOfzJ0CM7DgKRx71cOcws9xs4aqNnMkNh0EcZ/ytmHkdiTbX1
 w++Obxsh
 gEp4IuLZCXp0LPNvdnzYw6OGgxDJFPW1FicjEEm9ejmsofOpvU8v1+G4IcfGRTQORiUDTEUX3LY+yOoKlT3rX8e01JlCj3LWYT4UJG5TxwgLfzrv3OVA9YSdfdNuyVR8HxicAvQptsmhbK/8dDkID+aauAxE/CoPyOip6Pwn+kBj3G5n8/bQhkKHsgwakGLWReIGcTYcZoq9W9gkJu5fImR3rf5kHKYrz9kYPbe0rnefMAy/qzzKogXtGQGMmhoeC4QiNuavNze8F9lpuqi+kh+NXifXekoatmXo8H91aIqIqC4vZ4pfVCTwH5GzpDJifOSGoVeq9Z/ZGsQ66Erzc1zgVu2zXmWSzcw60
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 12:31:39PM +0800, Barry Song wrote:
> >> MGLRU has been introduced in the mainline for years, but we still have two LRUs
> >> today. There are many reasons MGLRU is still not the only LRU implementation in
> >> the kernel.
> 
> > To my mind, the biggest problem with MGLRU is that Google dumped it on us
> > and ran away.  Commit 44958000bada claimed that it was now maintained and
> > added three people as maintainers.  In the six months since that commit,
> > none of those three people have any commits in mm/!  This is a shameful
> > state of affairs.
> > 
> > I say rip it out.
> 
> Hi Matthew,  
> Can we keep it for now? Kairui, Zicheng, and I are working on it.
> 
> From what I’ve seen, it performs much better than the active/inactive  
> approach after applying a few vendor hooks on Android, such as forced  
> aging and avoiding direct activation of read-ahead folios during page  
> faults, among others. To be honest, performance was worse than  
> active/inactive without those hooks, which are still not in mainline.  
> 
> It just needs more work. MGLRU has many strong design aspects, including  
> using more generations to differentiate cold from hot, the look-around 
> mechanism to reduce scanning overhead by leveraging cache locality,  
> and data structure designs that minimize lock holding.

In presentations where the distribution of generations is shown for
different workloads, I've seen many bi-modal distributions for MGLRU
(where oldest and youngest contain the bulk of the folios).

It makes the value of multiple generations questionable - especially at
the level MGLRU emulates it right now (multiple generations PLUS multiple
tiers within those generations).

One of the issues with MGLRU is it's actually quite difficult to
determine which feature it introduces (there are 7 or 8 major features)
is responsible for producing any given effect on a workload.

In a random test over the weekend where I turned everything but
multiple generations off (no page table scan, no bloom filter, etc -
MGLRU just defaults to a multi-gen FIFO) I found that streaming
workloads did better this way.  

Makes sense, given that MGLRU is trying to protect working set,
but I didn't expect it to be that dramatic.

It seems at best problematic to argue "We just need more heuristics!",
but clearly MGLRU "works, for some definition of the word works".

~Gregory

