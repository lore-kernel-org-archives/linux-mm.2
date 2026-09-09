Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2D4CC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 22:41:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB02A6B0092; Wed,  9 Sep 2026 18:41:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C613F6B0093; Wed,  9 Sep 2026 18:41:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B28E06B0095; Wed,  9 Sep 2026 18:41:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 837616B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 18:41:41 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 83696120332
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 22:41:40 +0000 (UTC)
X-FDA: 85195697160.07.ACAD7BB
Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	by imf07.hostedemail.com (Postfix) with ESMTP id 95DE04000D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 22:41:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Gx1cM+9U;
	spf=pass (imf07.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.140 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788993698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K7y90OKfcw5Kem65C7oA0LNo0uX7jIHf03YJVGFM0dg=;
	b=ZIXxwW5QKiEYH8ESDc6fyX8CkhHZ+UVaaAscW5lAD3CSwY3Pd8BN+/DT9oQHZPpk3sOYPO
	P42gSVwQCr8vFfwc+V4VDkaMe23YeYuwBTUTY4aP2McwcgzYHdABcwHhGsKUWkhWG3zgfV
	Aj52vyQ97dOkfi4HiA0q312E9drMmLk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788993698;
	b=MvhepAjA7WCc+G+MfMopkcIWD8lB9akfflRnP1zm0NQZbGQ3RK9bHnky6vcQTfbjIeU6uT
	mtESvj52vSws2x1eczREnIA2z+v813G5Med+IqDG5+bhzEO9+BCCqzO9rgAIEjCXd4fZdA
	LyDOEnx9jb2UFjzrrwXqb1S4fR1f/MA=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Gx1cM+9U;
	spf=pass (imf07.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.140 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-9106feddbdfso11167986d6.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 15:41:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788993698; cv=none;
        d=google.com; s=arc-20260327;
        b=gRkDSdoF4t3I3BKlRBt2J+crVmHEGag6H+3Hvj/gQxpJQUBFgPrm25PXqR/UXoqxti
         T5KOW1IpSKMcpN1R+IYaGXpM70ZOPHQlFQfqcufn9apIfArtI/QMWWH6tbE/8Vi/g/IV
         FjSFTePup61BrwxoHxiVIlyz7I1kMPmuc/s8AKtENOBs6pTrnvX/2GzHxbof+CdjLycm
         QFX8F0HnznDht/ZloaD2f09E7qLofMUFGpvhZsZB8Nq5nWHtzAJEewxYow9LgaDKL4EX
         wSQgHgxig3DHghsiPWMgpr3rWqg+orkHwNg3rIRWHOxTzDcxHPaqIGAGp+qYewBYh7l4
         Cl0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=K7y90OKfcw5Kem65C7oA0LNo0uX7jIHf03YJVGFM0dg=;
        fh=4tS+1KM46RWR/HoaT2yCBDba4SzluyPqhUajpUaxLtI=;
        b=eKYTQq0vrSlEiy6ENwGLR6Q7dgLQQ3w8m4RWrpI7Zc0O/oZ6MNGgucrHY886jsfhic
         cnS8Q1u3smcCf7QppPkvpgsHW99V/KoP0ervJbTBn/HUzzAcdHBGEiTnd8AoNmE270Vn
         r0Wf76QxUdq8eN/2dT1/qUb+cBuVDG3vHaoSomr3fulrUbEgMh8ISRbHzuUm9BmiD4Fu
         c0JWm1CVVQ6wzdEPI3EglRxazH/MQGAd8NtRXHA6ypPaa4JuETTBv0XyPVIUPNRPwUl5
         UBl4+IVQeDGBU6URG78Xb2PC4FiLT48yipdk6qO6c0s7Ri9VUVLG8QZ5jWg5nybgxw8G
         577A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788993698; x=1789598498; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K7y90OKfcw5Kem65C7oA0LNo0uX7jIHf03YJVGFM0dg=;
        b=Gx1cM+9Uw5RhI3f9Jhgtl+drzzBttBhkLPbYUvkJ3bICg1hMRTMjSMluyekXbeoakT
         pE+T8y+p4Wd88JC7YJ2HIdYq9zXXQ/OhgBJPmtVMMeItAZ2AYorfSuhw5BaTHbCJ0gbj
         UMq7k5obhYXM64SJNHnqZeLuAm6OI1FXhzaJdWC1IRi0+KxOv3OsHobCwN5GQrEKHc2C
         tRgERD2m6W3GkZ5bxX85uCV/SJvXFYU7U21ZaKjPUmPuRVjy7LOSLXmR/Lf9+ZBSrkhq
         AcF6zVGnPY9is97NW666pOH+GnsxFFZX4LwkQE8VrMuvc50Ci0KP/Y3wywFEBWgyW0Qs
         8oOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788993698; x=1789598498;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K7y90OKfcw5Kem65C7oA0LNo0uX7jIHf03YJVGFM0dg=;
        b=BNEIkVg3d43FlIj/NbGkeL1+pK276pme3Ifm51iJ2EDwajkyyi32CJppp75x2WaSBn
         em6wRvqSBDKVDdm/vNfwFfdA7+KjrWAMq7M8AiFbX1HKvlPfGlj886jj3/6u0WVXd1ar
         oVxCJdFMhS3U4Oxfsv2squYhulqP+Q7PQF661Wd+lpOw6NBTpWwmo4f1PuUOyoe19DL0
         MkRLVaEtDqqPrnj5460ntmD7RrwsIwx0ryRHitHOsCXYd5NgDv3or6/o/BX5csMU3P6V
         ann17Roqu6WRK+IuEUweYuJHns+Yv7uisG1puX6i9msmccepMxBLEFrKK2I6hC/m6bZu
         5HjA==
X-Forwarded-Encrypted: i=1; AKwUvBwgw5H68pVRTWLAOuaIY6e+SFKJJbFaAv6cnDa5DUrFo/B52xRxLzg9q/lCJqzFgdxUkpxCGhG6ig==@kvack.org
X-Gm-Message-State: AFuF++m5p1fd8MZyTyBGd6QEJfRCL9LuUWznPcN1wSTopDbhkZFxodFj
	l3NVTOqwA0m6VrfeIgzO63czXrSE6ddH3oICwHwYlfSVkfEoFjT5i5QYzK1IP/aDmCuow8w+qeR
	WMYA1Yfqf03YOWJ1CZ2DCfG4bOH7n6fsZ188Z991N
X-Gm-Gg: AYBFou0OCU8VzbzCbkDhnOA718U0jlWMAcGvb9vsKKggtsxF+rDt0NI+SVc+G1Xvy17
	6WkbuNbRbYgDg2sOezkvjnvxWLHEfmJxmjLkAMF9hUslu/w4acHGrxA1o/jegKTNI8EMxg4r5XM
	LbXzONApjtqxqeH1d4JRXRJN6Lvdg8tPB/HwbO8H8LMeDYfwnHGyWYb/2+CuuxYM821/1cY5rsB
	r80Jb69PlZCkcR/lKyrd5Mm1ijutlze9vuHfjLnOUODw4qt6XHZXZhYtnh7ipm7w47cKw/Ip/Vc
	DQiXbZLQyNcfzyKMzPx5tTv/GzGQoqifgfdoKESaDVok85AP4FV3Wb62G65JY8cikJKDeLLd9Gb
	LxyU/4zTY79Fx6CbI1NY7M1jqXzHd4YH5BUAf+eZb
X-Received: by 2002:a05:6214:4891:b0:910:345b:954a with SMTP id
 6a1803df08f44-9106b448140mr149416676d6.37.1788993697090; Wed, 09 Sep 2026
 15:41:37 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 9 Sep 2026 15:41:36 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 9 Sep 2026 15:41:35 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260902194657.79075-1-gourry@gourry.net>
References: <20260902194657.79075-1-gourry@gourry.net>
MIME-Version: 1.0
Date: Wed, 9 Sep 2026 15:41:35 -0700
X-Gm-Features: AcwNN1WgHJXiyXU_ZBa_1-DE36OkQO7Bg_jMLCkg3DfJNHdXNcM4XNk-5IPdjJI
Message-ID: <CAEvNRgHWyBaBpZ4Bem1Eu86b-cuEA7NkyjxTJ4D3FnpGe1B2Yg@mail.gmail.com>
Subject: Re: [PATCH 0/5] KVM: guest_memfd: bind backing memory to a NUMA node
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, pbonzini@redhat.com, 
	seanjc@google.com, akpm@linux-foundation.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, shuah@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: w6jy8woqy68daaua9b896diopao716x7
X-Rspam-User: 
X-Rspamd-Queue-Id: 95DE04000D
X-Rspamd-Server: rspam03
X-HE-Tag: 1788993698-352351
X-HE-Meta: U2FsdGVkX19x7MOuQhzTyjVODS5T6Q8fRZb/CTL6GfOY2USkN3KbqBiFJLYmPDHWM9rkZMn5IjBjpsNgZDL1q8wt4Ivhjt6B4zmo0k0vRQAK7DdUEHWGDrimFbRVlKxtECPKfKkHuwxTapQQjQuHZawwq4p3ctlhKUmF4R65udjRpurniHYRdZ3b6PST9hvMU2ZBxHrDfbUHJXf7nBGmMS6oShm/qBQeSeC6juSgHyF/j7SdIUcGOu5m8AyDFab+LXU0K6tN6EHsczU0syC2EBWy5GTcGw59vJpkgE+Y6Uo6t9AiIK1gnWjPKUD2opBZ47HX783Xc5LiWSgqE/8FWHd5n1nRf7a5F0j4HL6q/ytsiWwfEZjSdbv1f4k5+dpDqjZHXJHt9Aoe5yRE59P36vmnV7KEXMcl4IKpHEvmmUB6gm2WL3Fy34o0NT6UPN7FqnPYPg+1St2QSJlBw7QuOQeeDIUzgLFNkmjLR6QgVVhv4EMZNLbgbm2q9VfR9UKFfBzwelcYX2StK38/CAUGIBoNiSseCviMDUYaWYa5QtJRUJ6Ycl+P0cWlb5rup9DEtKbvT0ttzhB8um4e9LAdkj6nnhxO8wUkRSMClPVLyjBC1QJFanCipHAmKviC1jMP1nyvs5u7zBXa+fzDdHSd8ksHF/lJ1WN3enbKNsaYMmh7PgRVliJ4gYRMlqvJJhdUejeuE6lKvHRwsGH798XiRTwxI9h2XJy6M/41zbRRXYSvLl8Qr19a7zQJvMN+gohtCXJn5aFv7jGYacpqnZoAzjfhUsPabAOyZwFOx30mlOsAVttzViKtqYqd0uMpOQu/NqXL0o27HO9Yba98P3egPccs6Ag4GaPqlBou5P0nMmFoQy9hljZIEtmuaa4qJ6daiTWoz2/8HHGWk0TnyE9oyiBu8maAjSwkWyU+9kRHWTgfyPQNFx2Vk1aPGcRH9U1LIdScYKJGnFIgE9PvA9z
 wTj1bg2j
 lj3B6HiuWbBPiDu+Bdg4+mzn3gyeRp5ApJNmNEHEMymVZkoxetgvuYlNS8E7lFpYtBt78O6QeTO6S6tiyjNHu/UT5B2KPzcPXLmuNSrRT1eWsJCNVb2kOhp/duBxDg9U8ucqaaMxBvmehSRHdDGUqL/7M9ak6y5sJ4V4AXcy6uZNIPftNemQ3dEl5EzMI+H/CybGOl8wUa9TYdIeTOBLVAoDvLBlpnJQtGA/AdWgW+p/nQ79hKUGfZ1qhqjLtnjegwlUFDKQ+ZmHi6l/9ibWBsWhJ8Qxx/iAX/2Dk4hrj35J8CPtN54ByE9zLM/sVuzff5iOPEHMmxD+3is25AeWUtWc00I/t/9I7A4ZoSbmz8o6YGqxGJw3SOIwg0WZ+y7kqYbZzK7Atw/KSP8rhNNchg62w+X9bFWoyuAqyvkc8d9W8ns5/SutHS1/USt6tC/FQCJRdedYK0zeg1wOKH75/v2ZWx3ViXX0rrwNjvG63aetQml4GPC0XfAxbFkmZtTIfczX4wuS9wj6fdfg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gregory Price <gourry@gourry.net> writes:

> guest_memfd allocates its folios through a per-inode shared mempolicy.
>
> Today that policy can only be set after the fact, with mbind() on a host
> mmap of the fd. That requires the fd to be mappable, and it cannot reach
> folios that are only ever guest-faulted. Neither holds for a
> non-mappable (confidential) guest_memfd.
>
> Add GUEST_MEMFD_FLAG_BIND_NODE and a node field to struct
> kvm_create_guest_memfd. When set, KVM builds an MPOL_BIND policy for the
> requested node and installs it over the whole inode, so every folio is
> allocated there with no userspace mbind().
>

Instead of a custom API to ensure all guest_memfd allocations come from
a single node, how about these options?

1. Using cgroups/cpuset to constrain allocations (could be troublesome
   if the guest memory is not preallocated, unless the vCPU threads are
   running with the cpuset config)

2. Process-level NUMA policy

3. Why not request the guest_memfd to be mmap-able just to be able to
   set a memory policy?

4. How about something like fbind() that takes an fd and offset range
   instead of mbind(), which has a prerequisite on mmap()?

This doesn't exist yet, but I'm hoping to discuss this at LPC 2026:

5. What if you could pass an fd representing a mount to guest_memfd at
   creation time, so to make all the allocations come from a single node

    Step 1: Create a tmpfs mount, specify mpol for mount to MPOL_BIND
    Step 2: Get some fd representing the tmpfs mount, hand that to
            guest_memfd at creation time
    Step 3: guest_memfd allocations will always come from that tmpfs
            mount, and abide by that tmpfs mount's memory policy.

May I know more about the use case behind this new feature?

>
> [...snip...]
>

