Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C48CFD38FF9
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 17:27:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 268946B0005; Wed, 14 Jan 2026 12:27:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 213306B0089; Wed, 14 Jan 2026 12:27:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13F836B008A; Wed, 14 Jan 2026 12:27:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F302A6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:27:51 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BA66F1A0595
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:27:51 +0000 (UTC)
X-FDA: 84331251942.21.D9B2B16
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf26.hostedemail.com (Postfix) with ESMTP id F214714000B
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:27:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gbJbKv5D;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768411670; a=rsa-sha256;
	cv=none;
	b=I/L+jiOi5ariYPYDqNP/VR7BT28krcSIj06OarCMSZhCQfskQ3gWrNnjzGwt0JlFo7NfrC
	ckJaav/Q1xnHWJ+afbc9R3mNUiIDXG/Y1xaHHJuCclKC7wI2tOrFpMcDCT5V0ouWjpdH3t
	tWAE40GFThhq8WhsjYm46hPJs6Fy/9M=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gbJbKv5D;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768411670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U4FdywhLVayjs/og8ka5nlrVNCvxPIqbw9riK1WrSno=;
	b=7Ws+wd6rFX6AoIciLeI0Cqi1u9/Firfqs9cHmRRWhWxQ3JwhqHWdkdJZ2zuYa/EEz8b60Z
	wV8Qm23KK1ZvMEFI8vgPGu32Q1qsPe4ip+bJ+DyCWfdousu0yNYHynUkwlaPivs0lXc1tY
	3D3xpUlVuYxnJJht0q6P50X5hP9Au14=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5013d163e2fso395061cf.0
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:27:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768411669; x=1769016469; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=U4FdywhLVayjs/og8ka5nlrVNCvxPIqbw9riK1WrSno=;
        b=gbJbKv5Dp0mQPqzbCgfmEKObDoOVT1Q0eNlfD6BXvx4W5MJKmfg5V99kyod9adardM
         RVqlyNuQhuG7cttTjFSxC42TSzEGlH+XVD4OSCjtDssLuBvjiMNY6uPvmWDgoP6UEMND
         2EPrkn0fvYvVY0v6ZB+coSbN3dR+FXVNg5Xp6hdLq1t1sEBHDLDrIR1VN3UZx3KN099b
         J8reg5HGtK9FUi70dl0toPou2Ic3flBiCl9xMsfXrtCS/4hxhs3Cef+BnaPXxuPUw/ha
         UZzS3YGEpXqI6vhpc9PgV2Abnbs6v4ACWNj+uIgKkUkJRYUf+rtfgYkOfBaLx50J2bqV
         eyiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768411669; x=1769016469;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U4FdywhLVayjs/og8ka5nlrVNCvxPIqbw9riK1WrSno=;
        b=xAQU0nhj1JfCaSwoCY+4PJILjKm53lesarE4G3vWSuiJah5r5FkpeUfvpmCm8IgmNT
         Ofi35rRH2SBWH9agHaj8P2EkWmwVKbyXfG5Uha9BHl44hU6B1kBwGdSECzC84SYRHopu
         kx8FKXN2+hvPABTLJ3asYddfcsRpfIVlvoQDp+FdX34ICMUZq5Wmh5bIBFECuez9eduv
         T1rsxvfKPy7+/HBECR1dd3ZMvokxBlcsx5TRMBWoADVD0Ath8Get+e3ItjbzG0nB1KSL
         zhxzWLehwlXVibNpV+1FM7CRMa0uToF9wz4NWShF/1ZdmxNsgGxfAuM/kLfWc3T71SKJ
         0X1Q==
X-Gm-Message-State: AOJu0YyOlDfSKHvzlM15FdLIRuMasmzhzFDZRtW3jwYnir2QQCC+5jN9
	+xjWxIuNpEJorIOe2bmfEUT87SPMjOnbNa0qaOZt1V3qReFlTG2MH5gZ8QxVUj9XDk0=
X-Gm-Gg: AY/fxX5R7HHQnegvdLSF884YSgvfynKzO/4OV8X2t1FBAmA/BCWy9aRMURFJOsmbuWE
	WwCe8ZZMHTbPFDnw6sn4y9bz2SX7bk4vOW5AkRLBIABNFirYdSrjKaRpsvEO1TrmKToXfsUZqmI
	wVY6I39vcZJpSw0FPeduoDSvFzquArRRho8dBd7F0aApJ3IrZYYCRREnkExY/666QKJ6yVPY/lS
	Ak3qKn9R5RR1HU5botJ34CF0mcJdAl3BZgNeMyYAwXAqKezpj4+n3SdVyMwFl9O8enltdzona0g
	VOGI7c4g51CgolpkAmFo7tHf17Cy2mqN4tDywiopWoOc+Ez/PXDSrogiU27ALkvjSErAzeF0dqI
	b0g5PPrlGT4JKjSUqyrjGbeXqcH6+LPIBR9ROay7Qtmv2SMmlSeLrpLe9y517XwTWdOGDmdFqJj
	qsZRntF/Gh8eUliqlSYl/i44paT33mqVDyucYAwbr/7Znm7h7o8RrrYAf0snBKJ1skCB/W7A==
X-Received: by 2002:a05:622a:14cb:b0:4ee:1f22:3615 with SMTP id d75a77b69052e-5014827ba2dmr51922171cf.51.1768411668907;
        Wed, 14 Jan 2026 09:27:48 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50148dd75d4sm18287131cf.2.2026.01.14.09.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 09:27:48 -0800 (PST)
Date: Wed, 14 Jan 2026 12:27:15 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	kernel-team@meta.com, dan.j.williams@intel.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com, mst@redhat.com,
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com, osalvador@suse.de, akpm@linux-foundation.org
Subject: Re: [PATCH 3/8] mm/memory_hotplug: add APIs for explicit online type
 control
Message-ID: <aWfR86RIKEvyZsh6@gourry-fedora-PF4VCD3F>
References: <20260114085201.3222597-1-gourry@gourry.net>
 <20260114085201.3222597-4-gourry@gourry.net>
 <b3d435d2-643f-4dad-9928-bc7fb5080181@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3d435d2-643f-4dad-9928-bc7fb5080181@kernel.org>
X-Rspamd-Queue-Id: F214714000B
X-Rspamd-Server: rspam06
X-Stat-Signature: gx3tghq45yqj3n7yw8oouai6su5po534
X-Rspam-User: 
X-HE-Tag: 1768411669-151100
X-HE-Meta: U2FsdGVkX19swqzh3jQrUdetwDoE3B+hiq6Hvnf/WSEpa18u7zdrBNxPo6YU2O/pWpwGtXv4UaqnVtQpZ5h6H7jNCMZNRbNfY7bdsLy8oGmF0zFrrev1V4Rq2SKaZQo55xDJpeBZ3p6ht9jQUFnl0jD7gpFfoaEO3exXtxwXrC57H+5eQrtITulVagyaqqPfLY16UsJjFOqeoLbonxMiZmqsYFY9KvOzmtkOfLxI1NupGHpp0IHJTXNHIgMkXffw1BAX9kU0p8YR5yal+7AOLkBX9AoF9cw8Nmi525GWi8+n5EuWSygyMHQpg2Q3ADhgLEw6vTthyLR/7TAXfSdNdbGpv1RjOWJUrt37+csp2DCefdMtYUscRO3BWo3+STDHc93RoU495rwJaOh2CWthvAZYQ2ojNGOfT1hgpArbpzLYeyJ6SOWdEEsOhUETQC0rthx1JdDf6Yqbxi/WXsQhr8zJTnmF+YGmiaCM61+EAz1ajrTlNHXECOabNjJ/8e0Y14tkD6Pwiol98zhT1W74ecn0GwwnjoiP3LEuX5wULP/hPLT1TAFb4Eo3dDmc37fLOBwJjFvKtC5g0QdRWopGCfuMLuKDHjdTXTvX+yVPuNxlVD4Lqkge0cryuWzABBDk3TtZxnpp5SKvOakfS4PnnOUSAUUYMJvOG1sCYDJ2AKW2sALhriDUaGTk3KgdQkyok1LjkJn5BNAM6IH8GqupYR0/75S61MAypSVTxydd9zdSut+VG6bNJJQgE2zU40IRd6B93DjERD9dhdmPXBLseG/i+BeyA1Vopx3zqFYkO0/7fnmmyHL/JDyD5s5zFrOtoyMy2QroVQ0rt82cQF7YnPsHbfzN1tq5/Kb77YGED2foi8uAsUZeW/JKpF7aP8YNwxD3kk9Dqyfzkl3AGMPkJxqgQ01uRSWzJDEsK/f5VpZDTTtSlhqkAUdWkuyrkC7WuNXsH7K+qAH8pI6P7TI
 xQaAVfgU
 toljU81XW2nv2snppkaLOoGnZzFAcp5fn0292Cl+i+Qn3fj98QBO1TrrA9bkQFvzQUbB0UJDwDoAQbN1/QK4EjyKYHq+XmwL+Qwd6Ih7Q7T30mCgR8ZwJXYoX5TLl7nYrXMvtCyXOiYLWgZZrqcekOb8L21fYQ0gSEPByXeT1CbLwCRph4uG4kW9DMRTxChpGcAF8qdP/4cS0oSCvNY91Ti5bIc2Ns9wJ9eMpqDzY+Kk1tS8+GowO4W6ftdE+lcVdu4L3oDBTDKZmVnbwYnvt9LzJ8CuWwOoRVNAV7wr+WKwo3VhXoBflcERnnF5b3was6RvrwIxP8M+5/yuq4bB/bmuKhWrOBIOJMg7s8l/u/Id7lfA8JNFCHCKGMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 11:21:34AM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/14/26 09:51, Gregory Price wrote:
> > Add new memory hotplug APIs that allow callers to explicitly control
> > the online type when adding or managing memory:
> > 
> >    - Extend add_memory_driver_managed() with an online_type parameter:
> >      Callers can now specify MMOP_ONLINE, MMOP_ONLINE_KERNEL, or
> >      MMOP_ONLINE_MOVABLE to online with that type, MMOP_OFFLINE to leave
> >      memory offline, or MMOP_SYSTEM_DEFAULT to use the system default
> >      policy. Update virtio_mem to pass MMOP_SYSTEM_DEFAULT to maintain
> >      existing behavior.
> 
> I wonder if we rather want to add a new interface
> (add_and_online_memory_driver_managed()) where we can restrict it to known
> kernel modules that do not violate user-space onlining policies.
> 

I originally did this, but then add_memory_driver_managed is just

__add_memory_driver_managed(..., MMOP_SYSTEM_DEFAULT)

at that point, just update all the existing callers of
add_memory_driver_managed(..., mhp_default_etc) and make it explicit in
those call spaces that this is what's happening.

> For dax we know that user space will define the policy.
> 

Actually this may not always be true.  A driver spawning a dax on probe
might also end up selecting the policy... eventually... maybe... I might
be planning to add that glue between CXL and DAX so I can add some
config similar to the system-default policy to avoid systems with
multiple memory-devices being forced into the same policy

(e.g. CXL memory device can online auto in ZONE_MOVABLE, but the other
 device can have its own policy).

There's a weird corner case for CXL auto-regions (BIOS configured
everything but left the memory EFI_MEMORY_SP - so comes up as DAX).
I'm trying to keep those systems working the same as they have been
while the userland policy stuff catches up.  Early CXL patterns are :[

> > 
> >    - online_memory_range(): online a previously-added memory range with
> >      a specified online type (MMOP_ONLINE, MMOP_ONLINE_KERNEL, or
> >      MMOP_ONLINE_MOVABLE). Validates that the type is valid for onlining.
> 
> Why not simply online_memory() and offline_memory() ?
> 

stupidly: I thought online_memory existed lol, ack.

> > 
> >    - offline_memory(): offline a memory range without removing it. This
> >      is a wrapper around the internal __offline_memory() that handles
> >      locking. Useful for drivers that want to offline memory blocks
> >      before performing other operations.
> > 
> 
> These two should be not exported to arbitrary kernel modules. Use
> EXPORT_SYMBOL_FOR_MODULES() if required, or do not export them at all.
> 

hm, not sure i understand this.  Maybe you address their usage later in
dax_kmem_do_online and dax_kmem_do_offline, i'll come back around on
this.

I did see you were asking about why we need the offline state.  I'll
come back to it there.

> > diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> > index d5407264d72a..0f98bea6da65 100644
> > --- a/include/linux/memory_hotplug.h
> > +++ b/include/linux/memory_hotplug.h
> > @@ -265,6 +265,7 @@ static inline void pgdat_resize_init(struct pglist_data *pgdat) {}
> >   extern void try_offline_node(int nid);
> >   extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
> >   			 struct zone *zone, struct memory_group *group);
> > +extern int offline_memory(u64 start, u64 size);
> 
> No new "extern" for functions.
> 

doh, habit matching surrounding code

> > index ab73c8fcc0f1..515ff9d18039 100644
> > --- a/mm/memory_hotplug.c
> > +++ b/mm/memory_hotplug.c
> > @@ -1343,6 +1343,34 @@ static int online_memory_block(struct memory_block *mem, void *arg)
> >   	return device_online(&mem->dev);
> >   }
> > +/**
> > + * online_memory_range - online memory blocks in a range
> > + * @start: physical start address of memory region
> > + * @size: size of memory region
> > + * @online_type: MMOP_ONLINE, MMOP_ONLINE_KERNEL, or MMOP_ONLINE_MOVABLE
> 
> I wonder if we instead want something that consumes all parameters like
> 
> int online_or_offline_memory(int online_type)
> 
> Then it's easier to use and we don't really have to document the
> "online_type" that much to hand-select some values.
> 
> (I'm sure there are better nameing suggestions :) )
> 

mhp_do_the_thing(int online_type) :P

I can think about this.

> Should we document what happens if the memory is already online, but was
> onlined to a different zone?
> 

Yeah i'll do that, it should just refuse, since that's what dax does.

> > + *
> > + * @online_type specifies the online behavior: MMOP_ONLINE, MMOP_ONLINE_KERNEL,
> > + * MMOP_ONLINE_MOVABLE to online with that type, MMOP_OFFLINE to leave offline,
> > + * or MMOP_SYSTEM_DEFAULT to use the system default policy.
> > + *
> 
> I think we can simplify this documentation. Especially, one
> MMOP_SYSTEM_DEFAULT is gone.
>

ack

> > +/*
> > + * Try to offline a memory range. Might take a long time to finish in case
> > + * memory is still in use. In case of failure, already offlined memory blocks
> > + * will be re-onlined.
> > + */
> 
> Proper kerneldoc? :)
>

ack

~Gregory

