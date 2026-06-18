Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69C22CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 18:38:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21F776B008C; Thu, 18 Jun 2026 14:38:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D2656B0092; Thu, 18 Jun 2026 14:38:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0733A6B0093; Thu, 18 Jun 2026 14:38:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CD1F26B008C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:38:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 51A25120249
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 18:38:54 +0000 (UTC)
X-FDA: 84893894988.21.DB32AE7
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf25.hostedemail.com (Postfix) with ESMTP id D59B3A000E
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 18:38:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=dFvkzbAf;
	spf=pass (imf25.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781807932;
	b=zIep2lowGfjZTj8sUMPZsCHSNiO3i3MHY2d/yKRekBkadG2sNzssmXCSK5TSgAsTMJIsgX
	MOwGPME/bclEMl8UwQndiIDzdbiuyvDCgKjpNbBFI+wWPmsw7FVqwLrt13WM4dtWB8Xvq8
	2sTyOJTVCNBIbIesGH94zylsiOR7uyc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=dFvkzbAf;
	spf=pass (imf25.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781807932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qwqh5eZ76mKgaFMQg0L2w1CcuHyrk1cgEZhuhc/zz44=;
	b=zuH+hUfiuiWJ9sqsehwDrPpj7YrNLwJb7s+cARXY8AywWbC3tn6NMr2iDPId575bu9J6x9
	yqLQ/nj5MeS2tJ8B+I3kONeS1IvZrlh3e2JbS2ZYiVeh0rfSd6Xw5hvKXWwbIKuyHhCv70
	e3okn7hMgJgCIVRAd8Oac0AykSgL9c8=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 9056040E01D8;
	Thu, 18 Jun 2026 18:38:48 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id x9SYV-9y-Tev; Thu, 18 Jun 2026 18:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1781807918; bh=qwqh5eZ76mKgaFMQg0L2w1CcuHyrk1cgEZhuhc/zz44=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dFvkzbAfQPOK4CXNEHjOU0/pafidSIvBGVQWa+M+eVk0nK+l7FxeVB+KpiPcRjhIW
	 41/E5G1uXxBXncKFyeY0GuJxv4fxduTeEPnbP8sXNoVkzzMpqLY+PWFMFxKJbBfdZE
	 COymlUbaf9iraqt6zd+uEHCya60wgCgRLrE7mQTMyvLa+ThLTpVRTp5r0RqCGYCs7m
	 JL5pqKKRjdjpx/4cItX/ksjJEt+qiu8AvLeZ9ForEPuVDVcdLxHWYqQSE+22XdwJQ2
	 5Uhzl52TNCezG7fGgFJYxv0zH9Fdme6nHdZLrgbrU6Ay7Y4PcXVeqOPjBi70EJnzD/
	 KN5wSUyfx0g9QTmNaHbFg59WiYjJD/5XD6phynGoM/CzKcGFvvFklRwdvQvWe4C3k5
	 EvcEo21v/8LVGINHIAmhKtDpxv9AzY2tCdYHSGuc7S4Q3bSnIzvKs33BwtgbMWYTKU
	 5ofvxNiB72DNUtn4EI22pIbQwqTzDrwegGLyf1+FfNCywaUSfkn/JkQQ9/0VsY5PVf
	 kprrKdQoABzkBguZvRhGgxVN04N7vtW5q9cUV7QkBXuBdE4oREf5stC3l0xg5mrXqV
	 DCaAtrI2zNQ06uCU9QAGMF1Mask20BLMySp4Hx2fSt+9HBhCvtoATqhXTy/AuZXoM9
	 /iYROZjf2CiQojDPnBfTxhVQ=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BC3C540E01D2;
	Thu, 18 Jun 2026 18:38:18 +0000 (UTC)
Date: Thu, 18 Jun 2026 11:38:15 -0700
From: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Ihor Solodrai <ihor.solodrai@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, bpf@vger.kernel.org,
	kasan-dev@googlegroups.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrey Konovalov <andreyknvl@gmail.com>
Subject: Re: [PATCH v1] kasan: Fix false-positive wild-memory-access on x86
 under 5-level paging
Message-ID: <20260618183815.GDajQ7F-bqTHnrakoi@fat_crate.local>
References: <20260610175651.647515-1-ihor.solodrai@linux.dev>
 <326b85af-c41a-4387-90a0-60720111934d@linux.dev>
 <20260618170913.GBajQmOQyOiBLqopUl@fat_crate.local>
 <3207a706-354c-4e9d-ba53-dded1abb1842@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3207a706-354c-4e9d-ba53-dded1abb1842@intel.com>
X-Stat-Signature: cu8a5qmy1xz3mpjg3yqx53zq1u4x945s
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D59B3A000E
X-HE-Tag: 1781807931-119079
X-HE-Meta: U2FsdGVkX1/MBFWGDQuSv086sY7EWaXFO7ClkT7glDO5P2LIScG4Ffm35Jg6VSfGdQMuKy4Ur94b/cE4/zwLlQbAqHJoPbw1nZOyfIfd9PGM/2bGOY0rtUuuxI6WmJ21oy435AX9vFL1AJfFfliEMkOgiMh3gTDoVtb/UMZcjAg2ssxVFgFHTjRGrqEsnO6k7R4AcEVFC6IEFYltjZUR0DNE5cNoGMKg/ni9gOijvz1UQWWehuMPjCV+twygyibypIydKQtBrIeem4TNfi9dJvNZj/p53TXWPU1a6mAzILk1RzOA4Jhcg4Kd9/xY570b8BwGKw8jm5Kn2eLogXOiv3TZxYZpHnvIUFnV7AdcYxgCjsj5+n2DaJdCqRGImGykdHgx4S1SZngQj+OaqgBaxZhV5N1z5R+fiMQ7rNCpduIXAiM1Qst1aYvT1+BGNaJLlQYDgImtRYT5w9uwXkUq7RpKS+DxhdmVitOHUCwyZeMrGh+fv+oHz2kDRh/E83iFlUXCsj/pRRdKfusF9k2YsRLeMSl4Bs9AnUOzCRojXMKbSr2GO2ipyNn7cv2st279Ht8xd/LmPnyoHKeLky/hvhWBQB1Di5RUwe76eA8r6hhfVfthrtLNxlXF7lQEv1M2pDar31Cqw8UsGzg57QCPvSvzotYJ8ssnjoIAwFxa3zzl4wH5WT0EAV8kBTVD9aPNUHdhoUgyr2TN+P/g/ptVI0yX/PzoAKwt5U/XVrYQ23RVsiKZA1CS3o4RmFmkLgy5HHaSCjsKWxFNCHuyozWvzJ8qK3Rt48WFRAxjhgaFBEAtFCdTqf9vip1IW3caRY8FJUbA12dAgEGGjiaAj7rL9S5U7kjyWx3zwhZ7F6tylBxJvAT8zCYgoC9EfX5JUU4epPbblwZJ+Tc7+w9Ymr8U9WG3YVinWrrwcWzcv6RHsw4Bk+N3egatvoeat0kAb/+4G+cq4Ydp22Cw9dii/qN
 MJX0WQ4W
 6Wrw7H5njKWGNjYgg69v1BC1MM+DWgfe9Nnmh/mAkFFQJ8YNDbimSG3MW20rsl355Vb1c3/5ZDBr5a9XArBli/So6HF87h5G/+puFH7BJCtYILhfmctop0PMugjtv9bM00aC/FU1CIhp2SURRRiQQR+chdI4YVRtnNVE8tstQ/G3ASevkuq4ryJiud7p/j3wpPzredTQkrwJbPmywb8SimKD6pgKf8PnthCmCdkn3k/U9yNe/6abH5ufzMoVGKM66BJPgu3oykEtph+hzj6iK3t90xMt4X4emdQelCoFzg+JqxD7wKIU+6ynCKA5G5WltovqMWhT7A3lfivSpotWJuldvDXGuiSIDsyrlxZGF1AqHJE+GFCqW7u1lDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 11:12:09AM -0700, Dave Hansen wrote:
> On 6/18/26 10:09, Borislav Petkov wrote:
> > On Wed, Jun 17, 2026 at 03:13:33PM -0700, Ihor Solodrai wrote:
> >> So my question to maintainers is what approach seems best?
> > The CPUID stuff is being rewritten currently and it should address your issue
> > too. If not, then we need to rewrite it better.
> > 
> > Can you reproduce with this set applied ontop:
> > 
> > https://lore.kernel.org/r/20260528153923.403473-1-darwi@linutronix.de
> 
> Thinking about this a bit more... If Ahmed's series does fix this, I
> think it will be accidental. It still uses identify_cpu() and also does
> a memset() of the new c->cpuid structure in addition to the old
> c->x86_capability structure.
> 
> I'm not knocking Ahmed's series by any means. It just probably won't fix
> this issue.
> 
> In a perfect world early_identify_cpu() and identify_cpu() would either
> get consolidated into one thing. Or at least become two discrete things
> that initialize two completely disjoint sets of data. That way,
> identify_cpu() wouldn't memset() anything.
> 
> Isn't that the _real_ fix? Instead of trying to hide the inconsistency
> when good data is blown away, we stop blowing it away in the first place?

early_ is only on the BSP and you want to scan all CPUs.

AFAIR, the last time I was looking at how we scan the CPUID leafs, we do have
cases where there's blips in time when cap bits get disappeared to be
rescanned again. The toggling of MSR bits which control feature flags is one
thing that comes to mind.

But I'm with you on the consolidation approach. I think this is what we should
do here and then that will be converted to the new way once Ahmed's lands.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

