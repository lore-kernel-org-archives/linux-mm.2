Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9A43C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 23:10:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C9536B008A; Wed,  9 Sep 2026 19:10:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8798C6B008C; Wed,  9 Sep 2026 19:10:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B7DA6B0092; Wed,  9 Sep 2026 19:10:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 453946B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 19:10:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 459C81C210C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 23:10:06 +0000 (UTC)
X-FDA: 85195768812.09.FA413D2
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf18.hostedemail.com (Postfix) with ESMTP id 782FA1C0002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 23:10:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rRlUdYpH;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rRlUdYpH;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788995404;
	b=cGQOgGhspWEsJWq8FrG7SMt2P64XKwzAv2DMedLwBaOeHpLE1Jojh3SzBKJcgrueHUjxQS
	yIexjrWH4TH1CtzvPfVdfgbH1BPm10SABiaihm5P8oFeAywf/Zuovw7JROD79AEmVVKaY4
	xAXDRfj5CRLjUtFvBuelByu32RkUMNA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788995404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OyXsyrmwPWpvNEMluPgrbmkQBcP1ZphCbVgRL1lfY6U=;
	b=eytpqJZdqZ7jAm6Atui4mwvxv21XswjtTFuyWs9vARTt2minL2f45t1FGm7bWcasjolfSc
	DpfX8YRYbwWU/pGv+B9GhCe2kY7xGdOtmV1fDCjPdLh4PwdV5RL7Q7UNO63U2yDjWurKHB
	ykFMoqJ+zcGl7CbHe6+BAJf50/kvMFg=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-90e92b99ab9so44630916d6.2
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 16:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788995404; x=1789600204; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OyXsyrmwPWpvNEMluPgrbmkQBcP1ZphCbVgRL1lfY6U=;
        b=rRlUdYpHLFbZ8tFMUxRpDciW/5Saez9w9lCp18y0L8qZ28VLxRUWrinkUcsPuR1QHT
         4g49Uwli19cow++HkR66gEtz+OpHkFsXwxbimAdslNPKxwzjoH/2nfT2YCksWwW+3SD1
         Kdur9qIEqkJXVqN3wpN8LXMWIQqxZKdbnmC+tPdVpaFCL5jIWRnt2pRHY9HyD1Sc9/Og
         xXkS3gVirbLtk+jhdV2wIm7eJ++SvtzaccPlqgZDB0PfMXpqVebev2DRt57w7HIGuhsj
         ZshLpXzRv0uMrUuvSI+UrKUaRhmZcfZOZwslRdKhqLouAj+4/tulzLw5FepFa3VYyX5P
         otNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788995404; x=1789600204;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OyXsyrmwPWpvNEMluPgrbmkQBcP1ZphCbVgRL1lfY6U=;
        b=ott31Z20eLAtjzfhGCWEdu5K+dTnthojPXNS14RC8jjTrScp/xcpZbJDg7XHNEKZS2
         OyFFY2h3lna1WK7R/psjZhE8DUFS4V713vbZlg8H2UkI1qKq0L3EXqWWmTMiiN90ZVV7
         2bYClTEqjakfT3F1Bf9rJ06qt7CR2Sstwy8b4Wy7V43a0GvjCw6VIThf/aaO0La7oeTC
         /Gm+ktdtHZ6H0WBL0nC+Lyv7bHw69zhBCRubzwswy/HpfWpnlrAKSGxP88s5EKenBRLK
         BxbHPepRZcpKs5dEx9GEEAlspk3NVK8LJE3UfxLc6QT36Bi2zukGSepFMmIauiYGdH1J
         E1OA==
X-Gm-Message-State: AFuF++mxduKJhE44zoLnT+2PG6WXu3DaLJmqYEI1iN/GCp5ZkoFokyiI
	86bAmP/pYJTzqLgIuPFbb6xwu426OanmHAqn9DDs2uYgGZcSYF7FJtR7xCZFJNayBlQ=
X-Gm-Gg: AYBFou0UAqTFFIhz8W+tkHdeE7ZPGiWWoEzBtv4t+c1/Y+LZWLczJf0+lslzvARXKe6
	tps5A9LdSpCkZU4LxEDs0lHqvuiT3chSrkLc688V31/DJ1CRYfhW+LGqG6D94TqFtEY1F00N/AI
	6/hTurGbG6O4Mjnloq06kLoozo1URe2sqYWp3lcoT7bg2wF2/v5bmSVWpuLLgz22KqKMEWPK9Ju
	WKV2L5CmSsWsedUQ/mCqUDkjMGtMnlZFs6cV+wzeKoKiMpQz5LJCFM8QlXcBRwg1xfSjn7CPeqm
	ZK0IdI+lQzd1cz75NL+pKfx+5GgTzbxTjZwOiFAG6fDxpOQTrCoQSj91trzRPk7xyfRY0SF6IjA
	4lrKxZTzmxJkPL/m05OBiPxTlqKYBDPgbx6DC4YA3WHFVp34NybiKWfsfLF42izwfhy1iNyrRhB
	rB4g33bNWQ+iHkDe0UD2A8CqvIw/ex0kivdQXrH6U1RgQLTWTd14JCVoo2aIZUTVy1CXIpqBba5
	OrP2gPoshnJ7mnXYkmQRTD4X5int4gOnKKx9e1s/X58JiFFsBCy40Q=
X-Received: by 2002:a0c:f206:0:b0:910:6432:b201 with SMTP id 6a1803df08f44-9106432b31amr201020706d6.21.1788995403591;
        Wed, 09 Sep 2026 16:10:03 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-910406af144sm155519616d6.40.2026.09.09.16.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 16:10:02 -0700 (PDT)
Date: Wed, 9 Sep 2026 19:10:00 -0400
From: Gregory Price <gourry@gourry.net>
To: Ackerley Tng <ackerleytng@google.com>
Cc: linux-mm@kvack.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	pbonzini@redhat.com, seanjc@google.com, akpm@linux-foundation.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, shuah@kernel.org
Subject: Re: [PATCH 0/5] KVM: guest_memfd: bind backing memory to a NUMA node
Message-ID: <aqHkVKvons1tBs1O@gourry-fedora-PF4VCD3F>
References: <20260902194657.79075-1-gourry@gourry.net>
 <CAEvNRgHWyBaBpZ4Bem1Eu86b-cuEA7NkyjxTJ4D3FnpGe1B2Yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEvNRgHWyBaBpZ4Bem1Eu86b-cuEA7NkyjxTJ4D3FnpGe1B2Yg@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 782FA1C0002
X-Stat-Signature: k9w7zio7iugaygdku18wp73m4wtmc4ty
X-Rspamd-Server: rspam01
X-HE-Tag: 1788995404-584114
X-HE-Meta: U2FsdGVkX1+bv976XM6mwhJw0g3n5wKvSjJBeJcuz8vp6cGK7awXWggq88e6SYfd+5rmoNRmn+p3xWIeeopdyP669LlZaaz96ogyARha7KBtNphG4wrKwMAjriv7tysS97bSpA2/AANd5u3047a/bf4UgQz7X/c88osrEq1PjgDHw8UciExJxTsdRvBjSdTvxUZrDufdNMo8DDrjy+UA3wqRzwmUg2We40ykzgkjhwbdhO+HtZ5NCX1dpYAw07ZYoxlppj005LbEyZCWE2FC1JJj5j3f9sIyn2F/K1/LL3Q4HSEZIAWlReks9PVAIyRSSj3GQi0rn9kxaPYdHrQ8m0tq0JC2JwaIdB2aLFMv52q9t9QFKxJEQMdCayChIlqfZ3KEeiMyx4hjWIrZQK8CzVVmqQ7CTwk580GfyC0XtbN5uJc0/m91st/NJkOWcTOrYq1ZW34m3UBpw4lg6Awgou5x/Hgrw1R8dFDPc5texpU0Wffz9YzgjtL5IbMI+kZhZrm9pBRBfYubwzV4bYnSe/0dNSW8Vf1iUcFYTpWETKr9ocbfsGZaIWOqEsNADdzUJiVhx7lkPo9ZCy7fJPoKle2M2B0Pcaq5UfVAU5RYWd8poMZJ2XQ7wcA7n3Pj3kFYPZvVxV50oEvGCZZrI7ZahnpAfIn1K+gxx3L1UeOcaC8tDebhcjrTJieMMJvPHeJgOqS6uPz+zsAX99NsDSKmojbbKHCSaUnwQSk0DHTjYB0eJrtvl5fPLIGHJbmHERcnTswTmbnVJsuVHsrziokkQwi/4E2ZNGfCOI5yi4Mi80XUY8LfC2s05P/+aDyWh4XjeYv/UftGY1yjo2E0PfTCkZxbTgCxDtqyw1s6h5jpC4761jdH1pn1tNp/CZX29uv3EedKLCd56/2cKpIApFREeGQxBmxD3yZqyfSC0ZkLXsiTt52Mu6/VZt4LSELniDpEuoW5Y0HwhWi0TzJM7/Z
 JbsuIIw7
 oqi6ixYoibB83wpJjYt1Rb5uuCpDMp4K02FPxdT+5VjGOZkxPX4BgSJMR7MUY2zTzr8HO2EX7uoBIx031qBpWgf1OCUobwBCBFKszFippBebI18vGYjlCj4bFn9ROzeCezR2QP0FgQpnfsKJRhYfH3Nb8TtHkCyatucBugL4IPzGEQmQ1N49AB3+SPMqE1y/JC2iA1Q4/KPvUxCR2kf6FsfkxWwTZZdmqmGj0O8WbdbeE73dOvFMnYpE0/06Hb98cW8SrF4lcwBKe/S2gQCnLEmH9ZkM5ygNjSxu+rcCIz9hLkDgC+tAVgRb6HsVvRBoo0yNyasS3sUjxKbXEVHI8e1CRWD4+0xWgox8FDr87qOqVFN/CYY1KIIpSDEihfMDNP/enKeKlZyR2xLQYRlpZTaeyJ/a4d8BGzq5buaLeEZO+NVLHFWpyEYphIWf89DqrAGYZpMxBtxBHRqUKWDS44r/UP+XCjnc8E0+iWCEex6iehTs3QfKJlqnqXg4+dGdZa2ny
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 03:41:35PM -0700, Ackerley Tng wrote:
> Gregory Price <gourry@gourry.net> writes:
> 
> > guest_memfd allocates its folios through a per-inode shared mempolicy.
> >
> > Today that policy can only be set after the fact, with mbind() on a host
> > mmap of the fd. That requires the fd to be mappable, and it cannot reach
> > folios that are only ever guest-faulted. Neither holds for a
> > non-mappable (confidential) guest_memfd.
> >
> > Add GUEST_MEMFD_FLAG_BIND_NODE and a node field to struct
> > kvm_create_guest_memfd. When set, KVM builds an MPOL_BIND policy for the
> > requested node and installs it over the whole inode, so every folio is
> > allocated there with no userspace mbind().
> >
> 
> Instead of a custom API to ensure all guest_memfd allocations come from
> a single node, how about these options?
> 
> 1. Using cgroups/cpuset to constrain allocations (could be troublesome
>    if the guest memory is not preallocated, unless the vCPU threads are
>    running with the cpuset config)
>
> 2. Process-level NUMA policy
>

for 1 and 2:

the intent is to put the guest memory on the target node, not all system
memory for a given process.  so the scope here is not the same.

in fact at that granularity, the desired node may not even have eligible
memory to host the task's memory.

> 3. Why not request the guest_memfd to be mmap-able just to be able to
>    set a memory policy?
> 

the eventual intent is to enable this for fully confidential,
host-unmapped guest, isolated to a particular memory device.

Requiring a mapping to get node-placement is quite defeating the point.

> 4. How about something like fbind() that takes an fd and offset range
>    instead of mbind(), which has a prerequisite on mmap()?
> 

This was a consideration - although it has other limitations and larger
complexities associated with it.

Where does the policy live for random fd's? (inode? address_space?) 

How is a reclaimed inode's policy handled? (lost forever?)

figured i'd start by reducing the scope to the narrowest and clearest
use-case, but I did expect to have the fbind() conversation.

I'm open to it, but it seems like over-engineering.

If you look at tmpfs / shmem, you'll see there is the option for a
default filesystem-wide mempolicy that can be plumbed, but i'm not sure
there's a real usecase for per-file mempolicies that isn't literally
guest_memfd.

> This doesn't exist yet, but I'm hoping to discuss this at LPC 2026:
> 
> 5. What if you could pass an fd representing a mount to guest_memfd at
>    creation time, so to make all the allocations come from a single node
> 
>     Step 1: Create a tmpfs mount, specify mpol for mount to MPOL_BIND
>     Step 2: Get some fd representing the tmpfs mount, hand that to
>             guest_memfd at creation time
>     Step 3: guest_memfd allocations will always come from that tmpfs
>             mount, and abide by that tmpfs mount's memory policy.
> 

This i think this is more feasible than something like fbind, but devil
is in the details.

I definitely think it's interesting and would love to chat at LPC!

> May I know more about the use case behind this new feature?
> 

see above - confidential vm whose memory is quarantined to a particular
device, without placing that same burden on the host memory.

~Gregory

