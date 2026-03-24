Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3054FF54AC5
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 14:25:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AD3C6B0005; Tue, 24 Mar 2026 10:25:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 536A06B0088; Tue, 24 Mar 2026 10:25:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FE056B0089; Tue, 24 Mar 2026 10:25:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 29F576B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:25:02 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BB3C48C033
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:25:01 +0000 (UTC)
X-FDA: 84581178402.29.BADCBAF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 29C7F100005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:25:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TMC+1hX6;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774362300; a=rsa-sha256;
	cv=none;
	b=HEw4RF7fZY2/QFPdkcEKWnv8hLEw7aIruGCu0cWtg05wrkTOL0crpkSHRxLDlBK3Qcjniw
	OyXZ67TFfskBUz+V1V8ERAGNAb9t11h7s9+eKgEOv1C6Q45S8jnx5M39L095oUBFWrV34Z
	HgMHYOU3nTJKa62aNnqMf7cR5ZhQi4I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774362300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=emhJxZ9WD68TdwxfnlD7Ag13T5Ywn8rdD7k0uMH0sh4=;
	b=pMFYEoWUkBMZ3qOILDTxz2ayZw8YeGPt8XxnNpsDTz9uZDJHgssTP8QkZp2/sZ3cUDwh1T
	j+/qG/jLZerN+uBM3JWCdI+/ztHRtZDPwVsBFhx4C8RNPo7CUWYpjKvI+XJDGAcyD+YNDj
	FeQ8i01E8G0Aivyme2zCbnU6SHp8jOc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TMC+1hX6;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8DAF5600AC;
	Tue, 24 Mar 2026 14:24:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC9D8C19424;
	Tue, 24 Mar 2026 14:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774362299;
	bh=P9LxY7AGOQOGKye5faI/iTdL7c46AeioKoHZcFvNQmo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TMC+1hX65oFntko1iQvIVY/7MNekNKqgZRhcpeG74hj5ObkBTFUlcfeFuzI6d7xP5
	 t4ICCETg14pvCbrDjL4gb0FAVwmmtyRUXty6lUGpStvzshK1Pd3kaWiUcNVchWn4XS
	 cHOJVZj6VjktDAcJYpDUbt5Lx9nk7orlJEEFXOxBX7G6kThxwvo+YiJHtKU5xnCrVp
	 CqwSkKlSvleNkKjxzrPPqloKZ53KdTMplEiEveHxtP2+dk1114pEYZovHsc/u5AgA+
	 fGDgETlS80AdVCy+htfKyhFXVl9C/6Wf8wj7MD/k5KLhiRA7GMQ30R1Oi79uJqIHkh
	 nLNWmDOHq0V8g==
Date: Tue, 24 Mar 2026 14:24:50 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com, 
	mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com, 
	kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org, 
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com, 
	usamaarif642@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH 2/3] mm: memcontrol: correct the parameter type of
 __mod_memcg{_lruvec}_state()
Message-ID: <2d03e270-4dd1-4a37-b6ce-e97b1760a6e2@lucifer.local>
References: <cover.1774342371.git.zhengqi.arch@bytedance.com>
 <90524ca3806e24105ab5f2d69435f57c2ae034cb.1774342371.git.zhengqi.arch@bytedance.com>
 <98dfab09-f3c5-4503-94e4-c3f097539afd@lucifer.local>
 <acKbsF__VQjtgnKz@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acKbsF__VQjtgnKz@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 29C7F100005
X-Stat-Signature: ysjgwfi5tzrojggj1uxricfbjtp17s5p
X-HE-Tag: 1774362300-537137
X-HE-Meta: U2FsdGVkX19Y2lnX9WZzB9WLyVTy1J6gPJYRw+rHq6yCfpQ+HHQV3voH3tRL8MXckkh9+9dD36LQilYoTs5p9jEaPOOYYRC9d1ulEP1fZLgrtRjI6UP4JsxYDr2hVzpTa2yGsp0zR+mjMgMBSVfdFzAV25P3OqARenHEuHz51X+NUXnuba5KSqBMGC8e2cNcJnebSqqQ0yiDGsEmhNibd9EHOEDlqLZjN6jAfhj9KoKmxmyyvagKwiVnD+bmXoKSsYxS69/o3lSr8/Le0/T3bRWRGRuBeZUg39w2q/0VxVxWdjDycZoqqhmpgVnuEPj+HPEJCfbZ/Qq9vPIGF3BUPlLdM2nGVFBsGGYrxXXP3etUutypo6h3hc7eAQYWVoTWezJ6zPF+9T/VagqQjzLpYJYWA6F3wBctLGzIt4KXnqnsmdqbwXPOjCpBkHad3v0OFNkNbYPPcwcOeUiMNG9LUqO9BZ4XPV+9u2tP59JYuViSmzGPkagcmt0U1eXhv0JF541FJrRU5Y4um25dJ4jhab9He17o7fIpxycVm3Jqzwzzn2jM8NJYLK9cFFf8xj+5GGKH+Rz6wTnwWMaP1oeMQhy/ibAbVExQWPkiHMdPQD5ImakPaCd9Gbwl5ISt/fxd3qljecLIBM2wnvm23Lu0WjZgBMYXeJoqPPZ3LWYJS1OmIL2r3ddi3c3/FVyu2UYAbif2V74neMPrb77i/ZYp5WWQkJePr33jHZexMKCQqnGEUT70m2GeebChiujYmDM12USVZUAo3OzGW1/3JOr5g+eLmxvdKkshR0GClu4ePMi5PShPYTUKLOhEw9TRHOs5O6Xc7YZQnR+Jp4M7tWTauM+sH04Rum5XaS22pP0PUUZaboFttYGH/uTqNAeUuXBzOv8iMAT3bgU8cU615EvonUKrXsk3cFR6rwOvQvpPR4DbR0Hz2XA08oKS8oe1nFjj0bySuEaAY3+NtKuT+Aa
 MLa2OOhl
 v/Xul4WCUlag+uSaN+XSZnUXJS3M0Z0yryS/JPkGAGBwfOqATd2uAiOd0NNOrZ+tzcrM8zsw+PpEWCq7JAW8awMB4T2DgVxziU+9U55CVRILwvcz8id7dVJ4h7bkvPEBqSXVat79Z2Vf0ho9RbQt9G8jdTsAnK1UdDnxJPgDSLXR4Thr2hfVHEMufZUkKgzvnFFTMC7JJrR/214b/wUZhc1Kt+krcUSQsuXugkLyNpWJ/fAKh5zkysaCCbQOd91g6vS3FUNOa1IyLgtPzB3uk+uoPHW1GzvzoQFJs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 02:12:00PM +0000, Matthew Wilcox wrote:
> On Tue, Mar 24, 2026 at 12:21:06PM +0000, Lorenzo Stoakes (Oracle) wrote:
> > On Tue, Mar 24, 2026 at 07:31:28PM +0800, Qi Zheng wrote:
> > > From: Qi Zheng <zhengqi.arch@bytedance.com>
> > >
> > > The __mod_memcg_state() and __mod_memcg_lruvec_state() were used to
> > > reparent non-hierarchical stats, the values passed to them might exceed
> > > the upper limit of the type int, so correct the val parameter type of them
> >
> > Why might they? What precipitated this change?
> >
> > > to long.
> >
> > Why is it a signed value?
>
> Because 'mod' can both increase and decrease this counter.  It must be
> signed.

Right yeah noticed that in another patch :)

Cheers, Lorenzo

