Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCA5CC55838
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 06:10:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D34AD6B007B; Thu,  6 Aug 2026 02:10:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE72A6B0088; Thu,  6 Aug 2026 02:10:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFCBD6B008A; Thu,  6 Aug 2026 02:10:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9F8B66B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 02:10:57 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 339EF120630
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 06:10:57 +0000 (UTC)
X-FDA: 85069821354.05.36E5670
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9073940008
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 06:10:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GgCpozn7;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785996655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vEDBbbtg3/PcP4ClINYTeW7ags6q/rO1HbdT1jquPMs=;
	b=tQH9Wd4ClFzB8D3B2yWt0kGF1G1FWJMTQt0A1gfDWf2/dgB5B6eNd3aSJ7LQk79NeZG1B/
	tWqnAmFfUduN5hfimm598gyc/ZG2cyoFsu7Mw9pNaeTktuIa6WjWv/YIvVoT/xlunZAMnG
	VJyHspuQ931q4XzwObFnrtmsbsni66A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785996655;
	b=Dw6HGmjEJRENLy2YniT8q+WMhbkVBJPKMIq6QxGHF//KAbokr7C1qsW68VBKYV6L0m08Mv
	wAqginTnueU0+GldLPZFoAbC/tEnlivjSvllkwMQuoYODawncZxyOmktM/XYOPik2zU7QN
	sa5ooXyFNLux/r70oi+tKsYlnZKZ194=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GgCpozn7;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C222641341;
	Thu,  6 Aug 2026 06:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1A41F000E9;
	Thu,  6 Aug 2026 06:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785996654;
	bh=vEDBbbtg3/PcP4ClINYTeW7ags6q/rO1HbdT1jquPMs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GgCpozn7dvhYOm+8WwQR+sGgrktCMAfyCcIBOreRY+ogIx8rOVgT/mtbEC21fsjll
	 1DBLOAGLdlFIJkkcE9m+cWPV/jkjcBs4TmPVa8zKaPvHYZ6fMTTSS7PFW7778Sz/Iv
	 7fpyx1VFKS9TZ2DmAqn0hc2TKhmIbugpOtkQktBtx5YoCDHDvOhGR2B2MdlKhx0/o5
	 aBH9FsssjbFkIgnklYm3IF3H9YJU3O6Jdw5EmLovqCi9h8E8iJGJaWl3gOncgdBtNT
	 W91bzD+SjL0GzDdmi8a+ZpiGiPDRswjZh6Xdzd+H4fnBKpd4faloeOEWFFrWSIupqJ
	 mkdpVqud/Jojg==
Date: Thu, 6 Aug 2026 06:10:52 +0000
From: Harry Yoo <harry@kernel.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH] slub: print just the function name in
 /sys/kernel/slab/*/ctor
Message-ID: <anQk0wg15jxzSEp7@dev>
References: <456c0a37-9074-45b5-9be2-a5f2fe345400@p183>
 <ee600151-85d5-4cd2-922c-d2d8df21878c@kernel.org>
 <73d28cff-77f5-4cd6-888e-5dce5ebae459@kernel.org>
 <am7NCCxeg3BsoYSa@dev>
 <c89d1843-e06e-4b8b-bf86-5b0debf489c9@kernel.org>
 <68e28ff5-8cfd-496a-a895-30de110b0214@p183>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68e28ff5-8cfd-496a-a895-30de110b0214@p183>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: hfs74fejx4ujcpsebbtgfakxh98eoc9i
X-Rspamd-Queue-Id: 9073940008
X-HE-Tag: 1785996655-19299
X-HE-Meta: U2FsdGVkX18ZsMYCtmjlffz3ur5mZETpB05kiKt0HmEOzbuRd8wFvSfmtoLaxnspmgF25hnDdDewkbkT0fi/Ldl4Wwt+j3c3NhRYgCTLEEHIGD7PnjKBO1OEeYOGgi8GJ02YFNY/a5+cp4QeXTNYaFm94/zsZgnFxbcEVMSbXHtwIDQOXOalrBhNpoES14uvs+fu62+qkJmY/+N6My0Ip6LD81jdjCBk6vkdUBSubaKQhiJho72eg4+SbFRkfVymIQUBjKcYKaBdiZnPr5zqur8wEUrKc15SFhY2Gsoxrlny+jRKFck7l0/XJYICzSFpGZFe9hKzUMRKBJivEIKTtdCQxsqGn57LwFGzyrDm6QgWpaU9Mxr8RRt49OfGCPlVkwWI41KVAQw0xfIyXfmN2YZQNfWEL7o3DJ1yqIUPXXXLzneWMofsKCnq2MpyI5wrBUuGmrnK4CBwiUBlnoYL5xp9B+zlAgQry6hIqDLAruplsUBG8Kl32y9hkBax+CpGoEZKyLxsDF/p5GCrR9ZaElOmz6M5g2RpKfVSJTlgo9UvKNma8kGRo1cUDn11Lk8dl1a9Nm5oVFSzs79C+8v2OOXRqmeezFGiCZPvsX32gRBV8TU/8TZv0t6bLPJCNFF1v0Ebb92rD6CzhOs1Av9EQQ+sYTUdcrO4ar5AjDnRK9ZcYjpL9mH/aiwY+QTD2hM52W6wp+jhda5QUVX4KKkMMczXX09SBepDeXpDyqGCvDsFdmqpsD7TxoshfDfIgZohTL76ObRZmt/SuQVWI1B4tbhPulcs8nTY3PInX+sIiSvLSI+EqtxGugdQIWJS3EDAvH5W8DyeFr9nNkRBPpif1LXeE4r9T6bbOdUfcBN21MjV4az7wdCGh3x/stoSbzdJSCd0B316saFFVYO5psDHFR8ni9PIbKM8iBl2sLutrMVl1P7znNMzH9PTE+XcehOTpOBMk56FGZsPjoN4JEE
 EbAWvgMG
 WZgxC/PNXw1LfzOHlmLGSed6gHbHBhYDynX3JxqLp0REW/4CZK8U6eIUcwynwvkMbH6mb3Xe0YIsbHgwRtk/Qwg7xbi+psx6gcH39u2FtX28p03v24Igkj7KbxBCzLv60MEBkY3yoG+6FB57Nq+xmaC6brv9u/kkwTZBq5+HfYMXQu4TUzmUjRY0kGpnf+dyCbCSVsdHOthqP/A9boYkC4v3goMDq2sflIeOGZdtlrmVZ6eo3mFCwkMZgLOGwG09d/UHRU0yTN5AVTiKWZjw+PFaZZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 12:22:42PM +0300, Alexey Dobriyan wrote:
> On Tue, Aug 04, 2026 at 07:25:15PM +0200, Vlastimil Babka (SUSE) wrote:
> > On 8/2/26 07:13, Harry Yoo wrote:
> > > On Thu, Jul 30, 2026 at 04:15:26PM +0200, Vlastimil Babka (SUSE) wrote:
> > >> On 7/27/26 07:27, Harry Yoo wrote:
> > >> > 
> > >> > 
> > >> > On 7/25/26 10:28 PM, Alexey Dobriyan wrote:
> > >> >> Sysfs "ctor" file prints offset/length of the cache's ctor function
> > >> >> 
> > >> >> 	$ sudo cat /sys/kernel/slab/bdev_cache/ctor
> > >> >> 	init_once+0x0/0x10
> > >> >> 
> > >> >> This is not useful:
> > >> >> 
> > >> >> Offset will always be 0 because ctor is a function.
> > >> >> 
> > >> >> I'm not sure what ctor function size is doing here, it should be in
> > >> >> /proc/kallsyms
> > >> >> 
> > >> >> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> > >> >> ---
> > >> > 
> > >> > I'm not convinced that changing this (without strong justification)
> > >> > after exposing it to sysfs for 10+ years is worth the trouble.
> > >> 
> > >> Agreed. It's a pity this was exported in the first place. I can't see a
> > >> benefit for anyone knowing what the function is called. Should have been at
> > >> most a flag whether there's ctor or not.
> > > 
> > > Agreed.
> > > 
> > >> But possibly a justification is not to leak the function size, which might
> > >> be theoretically (although unlikely) a hint to some attack.
> > > 
> > > ...but you need to be the owner (root) to read this :P 
> > > 
> > >> Well at least if somebody complains about getting broken, it's trivial to
> > >> revert and we can hear about their usecase.
> > > 
> > > If we were to experiment with this, we'll change it to print a flag
> > > rather than the ctor's name, right?
> > 
> > Yep, let's try that. Alexey?
> 
> I don't mind ctor name, it is internal implementation detail,
> but offset/size are kind of useless.

I thought Vlastimil meant ctor name is also useless and suggested
it making it a flag (0/1) to represent whether the cache has a ctor or
not.

Or do you think there's a scenario where ctor name is useful to know? 

-- 
Cheers,
Harry / Hyeonggon

