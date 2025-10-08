Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F491CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 01:29:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DC058E0012; Tue,  7 Oct 2025 21:29:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38CE98E0002; Tue,  7 Oct 2025 21:29:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A2EA8E0012; Tue,  7 Oct 2025 21:29:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C08B8E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 21:29:27 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A6AFFC036A
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 01:29:26 +0000 (UTC)
X-FDA: 83973214332.22.1CFA308
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id E7057120008
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 01:29:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="pHM38j/j";
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759886965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XdAraEEXVbZJBbE+c0mDz6TIAzz/YtNxkhB0pMRxsFY=;
	b=e7KKYYXAeJgS7YTy8clCIBXC9uarWyYVt/08qFD05bJMqMtZfYe9rMnQB/KA8IAgkvGTn3
	oa9HGq3AtkebROhb5QuahjHmkuaPbYVZ5COcQNv3kFRjBIa4+VovUM/ZRXqZyCw8SNsBG/
	g/G1uYeU7mg37mlgKaJnh1yJtuK7fFI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="pHM38j/j";
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759886965; a=rsa-sha256;
	cv=none;
	b=X191/XaSx/zoMge0KwsLn0sJ7EKquE+tEyVLud0ZwRVfF0PW3Uxp+qfeRMeOH4kRO2wwcK
	etH5Osqmw3G0+Wvaj9SBGsMzgiO88W7ggo8QNDpmtqbCEuHJexZuUNgT2lrukKuzdupnFR
	pgJspa5eTJXWRUsKRFKI/c5bgtKVAyo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CDDB6434BC;
	Wed,  8 Oct 2025 01:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF06C4CEF1;
	Wed,  8 Oct 2025 01:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759886963;
	bh=wUgFM4gP09He+buYyHXxWqbq0gw7Gd5qcC5h6IdUkyY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pHM38j/jlOiQlTLAIbLCyEaRonoDYBtZg7J5alRunu6drq9vnCfEHNvyj1r5Zj15K
	 rfkn+uABWjCsr/dV2r46UPB+sE5/eINf5sCMlYjMuX83UVX1tNuqpqdldnfyDjcbn3
	 T0EXyMtqw+d7Oy1+8E8LbSL36k/a8zDCG9sfxW7o=
Date: Tue, 7 Oct 2025 18:29:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: vbabka@suse.cz, surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org,
 iamjoonsoo.kim@lge.com, linux-mm@kvack.org
Subject: Re: [PATCH 0/2] mm/compaction: some fix for the range passed to
 pageblock_pfn_to_page()
Message-Id: <20251007182922.4a254daff78633b1452bdcc3@linux-foundation.org>
In-Reply-To: <20251002033140.24462-1-richard.weiyang@gmail.com>
References: <20251002033140.24462-1-richard.weiyang@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jpy5as5bgiusffd7w4ogs18crnegocs6
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E7057120008
X-HE-Tag: 1759886964-149250
X-HE-Meta: U2FsdGVkX1+boWxfCZbCvqjGJ2Lcfymm6IvVW8fiJ1EPtAgAsCy47/L7Z0TL15apgHBgm4bUanrtuCl4bwiQz7Q404NPjdEksJVXJdzVQB8WRI3pF3HJQ8cHO101LmDjW8F7hxXxvMaF/kggPN5IfJTjof3KiAcWAEWmUwb0rZRO7b8onBTO6yjFREMphbQSNhA1gOrG74FR3xZX7qkWmSWp9Bs7ynIlTi6qk8/S7HabGxOjWXs/8sxCRhb/+LUAJG/10YToPL6/evjexbgWDRuWsshwEMFmEImWowwLl8FhpK53c9w/AF3S0dtrKjI8vfiVLSZStHmAyY7sFVvhvq19IR9JRrd+09Jy6iVmx6Jn93bV8iigVXV105QXjqlfeqf0QRHLTzE72LcMRxtdFHldu8hgQwkZ11ikKmdFLJfggG30WYeqXvkFNZhrlTiHzTa4rqYV5oUaJcDl2XtkQK7mYOb/McqLLOdgyXkyveJx5uFcc1JuEcxedX6RV95YbO7+IBlzwOnGRkjj8XRkHBzh5GbIJmALQmV6gj4+N9FaYKENrfa5doC7AMuY5odFvRr5TyHorkdyMtYlGprLsswrvntNP7VbTbLaymISsjHJlbRprdBqpF9G8q5oYJBU37HyU6OKOPuNZvma+44dbW7fVRdlm/1YIQ8D0b4OzzhyDd0o7EsSYhJ0ge7hnTu8I2rkjTjNEhQO83+RXnseqPK83tGJzzJ6fZ92QE2LyDL5osdNLIXsb4CBxmQnNd/NPe+95TFFTWft2VCDydLU6wqbw7ZlbUpqwueVCjCZHcjc8JJYeX3Nz5V0pSMCynM9ZhGmOYLmEOvKQVxkTut0qSyZYZ4v4aaKF4Gw2xlfmbA9uSEOjoL+vwk0QPetR/FWsoTcMDGnICIKJiglVJJpsJp9EjxGrv+PFYcVWQvWmVeoB8GNn94YEFZ958WhESG8VrqAcv6fJGlYjb3MzWI
 M+arVkVA
 qORSRqF8En1iSfIBFa3n1Xoco9Sz3Wm06q2p2ctE+3OQ4xb6ttXoKEUxtiPjS7j7+DXmSjOc/LgR+zv+WCa3SUlH6l1cURHWraQfru7LJHWzGigAICwCoaZaHw7qj50GvBAktnyy0DRiLhYCj3ZzGbdQoNdsyfANEt4hfMDUEJpR6owXCXsS2BZvhkOurYR2aOdZvID74OEjDf5qCVFM3IW6Ni5vGLB4UUw1G9b4t9QSejKixn+io0nJBVI8feh+zpseaR+tfV0sACIZR6iU/yuWRjZ7CIl2GwmnRMdz1+2awio9Z1uxluLDROpcRiCOAmokbvyi3uGwhYYsQiPMrKlIJ4+fSkVMj4ClYsHWQlomqxMGIGjQZku+Hej1RVASPwaCprACQqWiz33+TGh4rvFNhhyPuMFwFZR67KZQBw3Hlvp0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  2 Oct 2025 03:31:38 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:

> During the code reading of isolate_migratepages_range(), first spot the range
> passed to pageblock_pfn_to_page() is different from that to
> isolate_migratepages_block().
> 
> This implies there is a chance that pageblock_pfn_to_page() thinks the range
> is in the same zone, but isolate_migratepages_block() will isolate range in
> two different zones. This is not what we expect.
> 
> Then I found pageblock_pfn_to_page() has an optimization if zone->contiguous,
> this means even the range is across two different zones, it will think the
> range is within the same zone.
> 
> So introduce two patches to fix it:

What do you think might be the worst-case userspace-visible effects
of the bug?

Thanks.

