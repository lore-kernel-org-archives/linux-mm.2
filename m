Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 416F5CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 17:45:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DDC66B048C; Mon,  1 Jun 2026 13:45:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38F1D6B048D; Mon,  1 Jun 2026 13:45:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27D9B6B048E; Mon,  1 Jun 2026 13:45:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 157BA6B048C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:45:15 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B184E4070C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 17:45:14 +0000 (UTC)
X-FDA: 84832070148.07.E65B676
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf31.hostedemail.com (Postfix) with ESMTP id 995BA2000B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 17:45:12 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lBFvhK2m;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780335912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zdBZDiQ9N2o+gUmeLxVAthNWp/fmNi0DwM5ZWNlvs8Q=;
	b=ZisnF6iOGe03A5Q91ZEbbE9YGwNsA3KF/iwv5gqIeGix/I2nM/mqEnO3LbAVY3yFUv1Ycf
	UHoLJ187pAsozhWgL3vTT51ilmee/VF8XzthJFb5w2+0bwVhoP7RmdZ5H8DvmVnoOetx9S
	x0GK5aI5AyWvioDqCSTJWCCsrhnrvr8=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lBFvhK2m;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780335912;
	b=uXxk2VKunFSD1nNG12iKMNshZPPcjq+x+V1A2XKQIg7oEsXhfno5MSoxJrmJ4ouupEYKLf
	1o8OvVXVQaFG//Uj5ltGSDg/CH1uphMRgGBWuxCByQPC6PH0Qh/T5hwJk5V85hLcPQa4IW
	kVrAxtJwhv89yycJIldNWwvxYXUUmtw=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-68b2229b48eso7569642a12.2
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 10:45:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780335911; cv=none;
        d=google.com; s=arc-20240605;
        b=OXnVPDm31qLIGslxCprS/p87qxkS+r2Q1Lop55J6NQySfFhcmwRfF4WMnvjHT8cSP7
         HzF0w7+OwNUcmAHH93PUtEzAq/NDWoi8/FFn7xQ3iKSHa/UiuY15ur9JHtaYQaPbXfYs
         0NTEWid048lnFhYgOBev0SIg+dmkNgfMZthalgoYPXUUIQ82+ukVlnu9j5M4G4IeN3g1
         epD+VvBnl03OyQB8hgFgpybnuwiDddZDDVxdkJBzOUustzLdTp3TTslAVwMEFSmXmxvb
         87So15TIttglxOKPDEHF0XNSUtMVCS4ev9B9L859R0A3mERRXBaQvOZsQQ1xH1Tdlx0A
         3N6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zdBZDiQ9N2o+gUmeLxVAthNWp/fmNi0DwM5ZWNlvs8Q=;
        fh=Jrt1UdOtFSufpIN14nWhifDLwFrkShEKTOSpR4kskms=;
        b=H+1qz0ou0mqXUuNuzG8Cl763513gU8ITuz4i1/sy2E/ydauIKGi/4pIglWqQXmY3Kh
         Qy9bP4Tq4awKx9voucaffPjcZyo1imLsYirA6UoAysyYpvfM4NDwkj2cGYGgQ0UmtsoQ
         EBNktT3Tm3CI68dumi/GM8pXA9KMxBO/DepGdM7TECey8Qz4nm6LQyAMKXPgtDvkXGuX
         dPLAzvj3Au8oTy/PBh0yJyg9lxlFXA6c+GfrbsfyIOtcMnUVqHm6ubgsI8nvdALUrrDT
         7M2kAjJAlTIMCWGwwNChPuROfEJLCtjMnzmHfZz/ZwyhR3QGrOrEFJ1RoW45WJzNeXIp
         VxBw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780335911; x=1780940711; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zdBZDiQ9N2o+gUmeLxVAthNWp/fmNi0DwM5ZWNlvs8Q=;
        b=lBFvhK2m3QVya2ToRk9STIXL5cbfzZzBi6BGujKhfhUVYcq14bSVgV9FZOzbDWkZap
         YkbRFiEK7b4vUKT/QnPcPF91hG3o2ekSab8Q4G2gMJ2UmaAu5UPrs+pp+L9W55iA3DUj
         kSIhccuIMr5r6x/2iJ9+pugE7BRgqKop71syFpd3vo1ld6iykbQR7SwDbf+SFB3GQIqj
         hmbfyPd54G9Le82SiDz5zfGtsW5vhW7BPK/J3AnzlVUfm3Nz/rEz5EJuxXJ1eySMJqoh
         vflfYvv91w3dzEhSznR1Brd9bfv16ITGVRByX3KAiVh57sRpEl5nqsdx3VkeE5yb/vIm
         o+7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780335911; x=1780940711;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zdBZDiQ9N2o+gUmeLxVAthNWp/fmNi0DwM5ZWNlvs8Q=;
        b=phcPMvMBldzW5Suk5pP/CG3SgljN9A3HhY1g3OrhXpiaA/CL3UC5CsVWNVusbhRBmd
         Ib+r7NUVlfJeX9h/XfJU5/eAVWS5CQEQkWX0PYyqkfHhF9J5Gz4T9LdIGNY7jzmTtpkJ
         OYiD4IMeW8r1G1CQfQzHqk2AJOur6at/ua94EBtbg38zQWjIpwEm50ibexzn5rjc0ZEw
         8jOirfnd6kgmzkxT8alwzwXieMqBHYtrSd0h3me+47eBzyZvMd6aIbFH48g7uVjEh+rD
         gB+pbpJM2QVIDBeC2cimJZvx5903gAEpfTnxTAN1zmTcaxEsQ0nzAgXmWUAsjAoZozbN
         +lFA==
X-Forwarded-Encrypted: i=1; AFNElJ8/lvebNBmkX1paPVJsm40xh1UbRX67JnhYcc6WZ8PWKqF50a7h2/MHwjIaP6MpJfD+nghud5pGfg==@kvack.org
X-Gm-Message-State: AOJu0Yy7APr2euVNR/lZ4vWu5+07r2i9Cwur+TarSJqhm33ktwM6Xl8H
	rXvTdiz37zZSlhbCk5uSHkyDgEFWiYQD2WgpE4KRF/VPyxCiqIxrK4L1f5T1hzRb2w9AWQEMmXI
	QNBioOmEz9EeUA8cT3czM85nBQC/4WYA=
X-Gm-Gg: Acq92OEp6nwqw4tR64pKGC8NOmn/eMjkYwoRo3KqPIP4L/+uB3RYaY6qL30K4j9bEJG
	BlVmuJE9av6ZIDQuo3boixg/tmYtMBMPNsRBPfJwVtWZ2W1lWlPpLbam/qrJGPZwQHdDLXFhQWx
	WWwV07O3llQLxtC8gb1My3sebMPFLYFXeegl1AXyh015zCV5wur7+E4Kh95CDzJVq94vREODLwQ
	esr8HJ3GyUvwAe9Svxa93b081JsZVboA/BqWOhbBS/GljTnv/iFQECvH5dSvl1UAyerGlp4aiHi
	4jQ/1wpiuzfs/NJ9b2JJqkJ0+Nwag1LT/4vJtK1wP2B8p0ME1IM=
X-Received: by 2002:a17:907:d24:b0:bed:83ee:922a with SMTP id
 a640c23a62f3a-bed83ee9b81mr309677466b.16.1780335910507; Mon, 01 Jun 2026
 10:45:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260528212955.1912856-1-nphamcs@gmail.com> <ahz_iYG4lqWL4g-J@KASONG-MC4>
 <CAKEwX=PzMwXXgq=ULAkFD9UqMz+ewLqhKt+xdGxkV7OmA2QG6w@mail.gmail.com>
In-Reply-To: <CAKEwX=PzMwXXgq=ULAkFD9UqMz+ewLqhKt+xdGxkV7OmA2QG6w@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 2 Jun 2026 01:44:31 +0800
X-Gm-Features: AVHnY4IUw3nIoySauxI6MLfil3rr6hgOs7Yvxi0fLc_FDWPMh1u4pdIwbMn_l88
Message-ID: <CAMgjq7BhOn48xEyC=2j837R7qddfjeBVHMiRqdx8no4ZEBpBLg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] mm, swap: Virtual Swap Space (Swap Table Edition)
To: Nhat Pham <nphamcs@gmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, apopple@nvidia.com, 
	axelrasmussen@google.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	bhe@redhat.com, byungchul@sk.com, cgroups@vger.kernel.org, 
	chengming.zhou@linux.dev, chrisl@kernel.org, corbet@lwn.net, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jannh@google.com, joshua.hahnjy@gmail.com, lance.yang@linux.dev, 
	lenb@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	matthew.brost@intel.com, mhocko@suse.com, muchun.song@linux.dev, 
	npache@redhat.com, pavel@kernel.org, peterx@redhat.com, peterz@infradead.org, 
	pfalcato@suse.de, rafael@kernel.org, rakie.kim@sk.com, 
	roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com, 
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com, surenb@google.com, 
	tglx@kernel.org, vbabka@suse.cz, weixugc@google.com, 
	ying.huang@linux.alibaba.com, yosry.ahmed@linux.dev, yuanchu@google.com, 
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com, 
	riel@surriel.com, haowenchao22@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 995BA2000B
X-Stat-Signature: 9hpteezg5tawz4m7kp1xrmx3e6k6orum
X-Rspam-User: 
X-HE-Tag: 1780335912-445823
X-HE-Meta: U2FsdGVkX19AjDiVaIQmUgv1DB0SD5b7IAenUhWsjE2PLsDhKW5e5P9VAxvLLQ0NvG0dtvsfBEvbckqQF5VGvFkxp27IlHajKA4MpkLJmI6hfo0/Y+GPDgywx2JctsnR/grGMoS1whqrcOt0WofUgbVJsWvHChe58fkxC9vWCuU5T2iaZSyrDdDxkHTNSNCTmn9kZY5K0EvFKZJeOCswhhQrCmdFf7vCFRoDLtqPmsksyx5n/5xC+FPv67Iz3awVo9qkVr1x+HiaAXuErGjPM40FgV+nXFQbvdlG7p7IyHsctnESZwHxOvXEdOwf8E9aS3t0NS+7EbvqjcZwdw54E/HDGkk6f46D7zY0zBrdtgqk2bZvh/rGx9DBDegNqpaVi9vYQcnXCQrtjbDJLK0vBaG2X+RDyYCyc2Ff3eKutPkV56K3VQmOw45esQ0qmS1ZsBC6KkEX9KmugiStjAHvJ4pjEdNKQbr5ZTs543C0C4U8SREakXJn93wlQMzKJLbLrL0O7gZtYsIBbbyttOpTAmrIsEZ73yItIYVRULB7eAgU+aCFPH8h9xq5F0CcVOfPrQGchPtlapPm2auVsNE3FUw57aIdoKttRXu6rnNFYnOFV3kaV13ATBDmS05BtVB0UpIrs0+DbIZ4VnXOirg161hrhe0syt0LOq2BdL/nVEjeDGtv4OMMhEMwn63uF7OoI0JoJ2nBpwMdUievrg2Pm2Llbk8/39yD279iKdKOQyCz1LFECI86CDH83bzti2WoI/gbZS6YqhLvZkaLml7YkKrSdlhB1NhhfAIC6pwpOeFB0ioqp2+Wa2+sHZqZgbsqsXPZx4tk7GjFuS0U92i53kHg8O3c7pr7TL/skKGWoa84GiCrX2ZKcEsL7qIuHxdwLwrvxAZrgzFIoCSSKO+/FtSjLnMl66F5/yRT6l0a858VCULDQcWLSR66jjm/2pxjwv2h7ndGrmvFsdxqMBd
 WM2ikgof
 kWR3r9FLSI2Gpwtxa80UanXVaz/QN/SdznHXFYQk6ktFQkioRtT5lRiCV6+OOUJbXsUwgoHGo6M55VmJgt7XkHRm+O7sTrVCZq9T+9ogB4SZLLIzomHtyQrxB0/YXi+8L3S+fv+ClQUc2+0MbVr7CWvbE+gV2nlor5aq9rOBQh78+dcMVvsQXvAvqXSHVWD7N8IfPP0ROrDPYDsk6E8aoVnaQ1a/Q4GwXz90mOPl3qioxBsOnUnAGiaEIsKYBdNulFGAcwcfxat0AkB9qfqvaLKJsNBfvhXEshZaPkaUOrL4WsEDQklVECXRoQKPdjHiMuuSUKkVhqPzeMij3bUalnAMn4iRrJyyhdBWrT2IoGqwu2tm4Q7y/IPCYhC3V4zyoLEGyEe+m1e/sCBZKZYzzbyOqrl7V3XtNVcy5cH+UFFSadyY7kJkghAtAxun9vATttrES0Pi83HPxYaWcpk6rOOrFEtVLunzXF+7+GzBXmDep5hhODRWJBZZqsVhKM18p/zMrbYCqf6rMpWNWEHIYiTjioxzignKH9QIfeB/VnNO1BMD1/SmC6+KM8uCRrNx872j3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 11:57=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Mon, Jun 1, 2026 at 12:34=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > For the format part, PHYS don't need that much bits I think,
> > so by slightly adjust the format vswap device could be share
> > mostly the same format with ordinary device.
> >
> > For example typical modern system don't have a address space larger
> > than 52 bit. (Even with full 64 bits used for addressing, shift it
> > by 12 we get 52). Plus 5 for type, you get 57, so you can have a
> > marker that should work as long as it shorter than 1000000 for PHYS,
> > and shared for all table format since it's not in conflict with
> > anything. You have also use a few extra bits so a single swap space
> > can be 8 times larger than RAM space, and since we can help
> > multiple swap type I think that should be far than enough?
> >
> > Then you have Shadow back at 001, and zero bit in shadow. The only
> > special one is Zswap, which will be 100 now, and that's exactly the
> > reserved pointer format in current swap table format, on seeing
> > si->flags & VSWAP && is_pointer(swp_tb) you know that's zswap :)
>
> Are you suggesting we merge the virtual table with main swap table?
>
> Man, I'd love to do this. There is a problem though - we have a case
> where we occupy both backing physical swap AND swap cache. Do you
> think we can fit both the physical swap slot handle and the swap cache
> PFN into the same slot in virtual table? Maybe with some expanding...?

I don't really get why we would need to do that? If you put the PFN
info in the virtual / upper layer, then the count info, locking, and
all swap IO synchronization (via folio lock), dup (current protected
by ci lock / folio lock), and allocation (folio_alloc_swap), are all
handled in this layer.

The physical / lower layer will just hold a reverse entry on
folio_realloc_swap, or no entry at all (no physical layer used, zswap,
or after swap allocation but before IO) right?

Looking up the actual folio from the physical layer will be a bit
slower since it needs to resolve the reverse entry, but the only place
we need to do that is things like migrate, compaction (none of them
exist yet) which seems totally fine?

> > This could be imporved by per-si percpu cluster. Both YoungJun's
> > tiering and Baoquan's previous swap ops mentioned this is needed,
> > and now vswap also need that. If the vswap is also a si, then it will
> > make use of this too.
>
> Yeah I made the same recommendation when I review swap tier last week:
>
> https://lore.kernel.org/all/CAKEwX=3DN2XcMHN1jatppOk6wnmz-Shab5XMtTtzgYOz=
RvU_6YFw@mail.gmail.com/
>
> I like it, but yeah it will be complicated. That said, I think not
> fixing the fast path for tiering/vswap will seriously restrict their
> usefulness. We don't want to go back to the old swap allocator days :)

Thanks. Not too complicated, actually our internal kernel
implementation still using si->percpu cluster, and use a counter for
the rotation and each order have a counter :P, it's a bit ugly but
works fine. It still serves pretty well just like the global percpu
cluster, YoungJun's previous per ci percpu cluster also still provides
the fast path, many ways to do that.

>
> >
> > YoungJun posted this a few month before:
> > https://lore.kernel.org/linux-mm/20260131125454.3187546-5-youngjun.park=
@lge.com/
> >
> > The concern is that some locking contention could be heavier, or maybe
> > that's just a hypothetical problem though.
>
> I don't think it's hypothetical. At least with vswap, it's very easy
> to get into a state where the shared per-cpu cache gets invalidated
> constantly if phys swap and vswap allocation alternates (which is
> actually very possible under heavy memory pressure), hammering the
> slow paths...

I mean if the per-cpu cache is moved to si level, then whoever enters
the allocation path of a si will almost always get a stable percpu
cache to use, even if the last used si changes.

We might better have a more explicit per si fast path for that. The
plist rotation should better be done in a different (will be even
better if lockless) way.

>
> >
> > >
> > > - Runtime enable/disable of the vswap device. To be honest, I don't
> > >   know if there is a value in this. My preference is vswap can be
> > >   optimized to the point that any overhead is negligible. Failing tha=
t,
> > >   maybe we can come up with some simple heuristics that automatically
> > >   decides for users?
> > >
> > >   In this RFC, CONFIG_VSWAP=3Dy means the vswap device is always crea=
ted at
> > >   boot, and CONFIG_VSWAP=3Dn means the vswap device is never created.=
 This
> > >   *might* be enough just on its own.
> > >
> > >   Is a runtime knob (sysfs or sysctl) worth the complexity beyond
> > >   these heuristics? I'm not sure yet. Maintaining both cases
> >
> > I checked the code and I think it's not hard to do, patch 1 already
> > handling the meta data dynamically, everything will still just work
> > even if you remove vswap at runtime. The rest of patches need adaption
> > but might not end up being complex, it other comments here
> > are considered.
>
> Yeah, it's not terribily hard to do. I'm more wondering if it's worth
> the effort, both for the implementer and the user :)
>
> As I said here, if we want vswap, just enable it at boot time and get
> a vast (but dynamic) device. We can make it optional per-cgroup
> through Youngjun's interface, and that would be good enough?
>
> >
> > For patch 2, a few routines like vswap_can_swapin_thp seems not
> > needed or should be moved to __swap_cache_alloc? VSWAP_FOLIO is
> > same as swap cache folio check, which is already covered. Same for
> > zero checking, and VSWAP_NONE which is same as swap count check
> > I think. That way we not only save a lot of code, we also no
> > longer need to treat vswap specially.
>
> Unfortunately, I think a lot of this complexity is still needed. Vswap
> adds a new layer, which means new complications :)
>
> For instance, I think you still need vswap_can_swapin_thp. It
> basically enforces that the backend must be something
> swap_read_folio() can handle. That means:
>
> 1. No zswap.
>
> 2. No mixed backend.

If mixed backend means phys vs zero vs zswap, then we already have
part of that covered with the current swap cache except for the phys
part (zswap part seems very doable with fujunjie's work).
swap_cache_alloc_folio will ensure there is no mixed zerobit, it can
be easily extended to ensure there is no mixed zswap as well
(according to what I've learned from fujunjie's code). Similar logic
for phys detection I think.

> > For memcg table allocation, on demand seems a good idea, and actually
> > we are not far from there, I tried to generalize the
> > alloc-then-retry-sleep-alloc in swap_alloc_table but still not generic
> > enough I guess.. Good new is the allocation of the table is already
> > kind of ondemand, just need to split the detection of these two kind
> > of table.
>
> I have a prototype of this, but I have not tested, so I do not want to
> send it out. :)
>
> TLDR is - I still want to record the memcg for vswap (just not charge
> it towards the counter). So we still need memcg_table at both level,
> generally - just not allocating until needed (basically if a physical
> swap slot in the cluster is directly mapped into PTE). You can kinda
> tell, since you pass the folio into the allocation path - with some
> care you can distinguish between:
>
> 1. Virtual swap, or directly maped physical swap -> need memcg_table
>
> 2. Physical swap, backing vswap -> does not memcg_table.
>
> Another alternative is you can defer this allocation until the point
> where you have to do the charging action. But then you have to be
> careful with failure handling, and need to backoff ya di da di da.
> Funsies.
>
> I think I did a mixed of these 2 strategies. Anyway, I'll include the
> patch in v2 (if folks like this approach).
>
> >
> > Mean while I also remember we once discussed about splitting the
> > accounting for vswap / physical swap? If we went that approach we
> > don't need to treat memcg_table specially.
>
> For the charging behavior, I already have a patch for it actually in
> this series (just not the dynamic allocation of the memcg_table field
> yet).
>
> Basically:
>
> 1. For vswap entry, not backed by phys swap: record swap memcg, hold
> reference to pin the memcg, but not charging towards swap.current.

Maybe you don't need to record memcg here since folio->memcg already
have that info?

I previously had a patch:
https://lore.kernel.org/linux-mm/20260220-swap-table-p4-v1-7-104795d19815@t=
encent.com/

The defers the recording of memcg, the behavior is almost identical to
before, but charging & recording should be cleaner and you don't need
to record memcg at allocation time hence maybe reduce the possibility
of pinning a memcg. I didn't include that in P4 just to reduce LOC,
maybe can be resent or included.

> 2. For phys swap backing vswap: charging towards swap.current, but
> does not record the memcg in its memcg_table, nor does it hold
> reference to memcg (its vswap entry holds the reference already)
>
> 2. For phys swap directly mapped to PTE: charges, records, and holds refe=
rence.
>
> The motivation here is I do not want vswap entry to shares the same
> limit as phys swap counter. If we think of it as "infinite" or
> "dynamic", it should not be capped at all, but even if it is charged,
> it should be something separate.

Good to know, it's not too messy to make everything dynamic, but if
our ultimate goal is to account for them separately, maybe we can save
some effort here.

>
> >
> > > - Widen swap_info_struct->max to unsigned long. The vswap device's
> > >   max is currently clamped to ALIGN_DOWN(UINT_MAX, SWAPFILE_CLUSTER)
> > >   (~16 TiB) to fit in unsigned int. 16 TiB is small for vswap,
> > >   especially when we're getting increasingly big machines memory-wise=
.
> >
> > This should be very easy to do, just replace unsigned int with
> > unsigned long, a lot of place to touch though :)
>
> Agree. I'm just lazy, and this sounds like a simple patch as a
> follow-up. This RFC is already 2000 LoCs - I do not want to burden
> reviewers with extra useless details :)

No problem, good to see progress here :)

