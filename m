Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CA82606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 23:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=FJVj8kti
Received: by kanga.kvack.org (Postfix)
	id 8F84E6B0278; Wed, 21 Oct 2026 19:55:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D01F6B027B; Wed, 21 Oct 2026 19:55:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E6246B027C; Wed, 21 Oct 2026 19:55:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55EC96B0278
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:55:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 35FD4805F4
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:55:50 +0000 (UTC)
X-FDA: 85348293660.20.65AD4DD
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6848580004
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:55:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FJVj8kti;
	spf=pass (imf02.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792626948;
	b=oMzja2j+Pezt1nzdfdm7dn2tk3BCLE2qo39qo82VDSW6Tk2rrMoxnU5rodrzzC17xLGqqW
	Eo1jzvUDt1VFqn9C3gPJTgl5U0wgnMPoMmmAL/7zQqIU3KF04Z/FL9Si7mHxQNKnvwd3xT
	v8zJU9nPxOe8TZ/QZLBPyumj8+P+j0Y=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FJVj8kti;
	spf=pass (imf02.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792626948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1fqUHRqztpFhXjrNb+RX+YalUvUHW60343cq6Q4Whxw=;
	b=KMANCEKf1Fr9B+2/q9nmJ+7bHRskOINRaPg8wrCpHMVu38KOg5uxMYTo5FX/+eFZabBCtj
	ZrOI1VKHK/adtHaOlyktlo5kuMe+2295Mo3So/0xeqpEk/U6dUyLvjJNZPHaf6bTqXBVW3
	TNYQaxUUevEhG0O187t3Eevaw3MMghM=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2dd76b1361dso8788015ad.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792626947; x=1793231747; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1fqUHRqztpFhXjrNb+RX+YalUvUHW60343cq6Q4Whxw=;
        b=FJVj8kti9+MgE1lHLKKIuxnowUFA5Z+l6iS8ra1HuU7x9LA1mRyD7wIuNuzlTIlfbQ
         mN8rWUGLhDiTGF8Qz9LU02cHlhKLdDT1o0y/1oQiaTWRsbp7fB89VIPHCz0GOhKTjkv5
         6GIj8nPm1wGi6c25i5LJODyBeZ4LvYo+FFvhg2vZD9ImKMYbpeAOcTuONnXamsSs/iW7
         q3Ghinm5+s/QSPZijSmyfp9WjMuL+wnJnisNOwUn+MlHnxutAbLDsCrhv2IeUdWu6Y3Z
         AKppGOpQEa+Iay9dPRY4ghvZvZBxiFIi/n9swezVAV0d4RmchkQSGAOAlzaUK4I/vGRq
         FVyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792626947; x=1793231747;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1fqUHRqztpFhXjrNb+RX+YalUvUHW60343cq6Q4Whxw=;
        b=oKYTi0h35n0thYKOIRxhNgBg3OqyBaqjpy+bbzKWWc6fULiQWpc3O+Hmdh/h2H7r0S
         Jl2uMFFDDSxEjiqHd5dIkuro/ZJCAuv53hhQ9enZBW4Lwf32zpCO1mDT561d5aUwHCdM
         lSFWUsnsmJg2hWdrFHSUZles9wj7Ve8f3ER2beXiVv2najJQCMMPxh3VIBEoCeq+Qn18
         qIGf2McuQLsycl4A2d8GA03dKEnXgXzAZM1b65dGUTOD8NeKxwHeQEqVG4ztfoVjotdl
         9pkNA2GULAQfc9hA4l3RIJZW2X99spS2MjdeU4SL7y4/azEPkuLtvMJLcLp8yyG1ibLw
         COxg==
X-Forwarded-Encrypted: i=1; AKwUvByQBa9Oyn1jYQ4FVX2vRboiK1H4x+Y+EWT3eJIaos/oYYL7myD/xrR2dt/ElPMX7V76ZKeOAW01Xg==@kvack.org
X-Gm-Message-State: AFq9FYKoVY6GJR5touvL7KuS89xaBvh9+6NI3JEn4Oo2Rqwp68+Y692n
	il+I+EZEekyBH0YExLonmWCJY6wgKUpHtUDr5rYEMlmmuNnvEaSQ+73BqgLcN3PJDw==
X-Gm-Gg: AYBFou2z3LErLgKCkCPmSOCrcyXQJGk2OmaWfSUotdT6Ux7Zu/iKF2rkln0D4EOvZOb
	L7A0YH0UN4DBpDXazYP66M8h+HU0yUiSUmTCiXiG59Fc0v8KhZOCJcmzJuuBuvbxzHno0R90OwN
	lxJY6RETKG79SF6yxc/2iAJOtjSDlnjqmgDLDFb1HsqHemLtO7DGUkkTeteMTzAR6E2rslG1OI2
	shCo8kRGH871EEuqkvEIstVyGEFGUBCeqdf1igQmDuavJ20DjXuTzwvtbcsDOBZ1sJ1+Y2oyPA1
	K0d6c/+u9HYmtsZW3dtJ3CUgHIu7p/p+82SLEoDzm4YEPTJdDU+DjUU+LqEjOIOcvT9nvGCJMmU
	aIvJoiOEb30FpJogqmwIhQO2jyJBL3f8z3ZqEeLMi2tTsj04uJXJWYTHsn43HjStMpgdXSbsOl4
	L7butAki6pjJDt09gb03OgUSRLU0MzSzhlqmMGQd2BIOdTNJfm6Mkaw+9HSWdEOY0kV5BosralK
	wY6L5pSm6Ehl+JLQlt2KmC5ZYydnIwinq1R2aCdVp4XtxfYR9GEKoOeTwMLpEgyR0tBDB31J3oF
	lGOwpAVv2J4kqNlh
X-Received: by 2002:a17:902:f70d:b0:2e8:3190:73a with SMTP id d9443c01a7336-2ea44075412mr31011645ad.58.1792626946744;
        Wed, 21 Oct 2026 16:55:46 -0700 (PDT)
Received: from google.com (64.75.127.34.bc.googleusercontent.com. [34.127.75.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea3b30829csm16784705ad.11.2026.10.21.16.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 16:55:44 -0700 (PDT)
Date: Wed, 21 Oct 2026 23:55:40 +0000
From: David Matlack <dmatlack@google.com>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de,
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com,
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org,
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com,
	will@kernel.org, Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com,
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev, linux-pci@vger.kernel.org,
	kexec@lists.infradead.org, skhawaja@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
Message-ID: <atlQ_Er0Ig7CCSxv@google.com>
References: <20261021152527.375070-1-tarunsahu@google.com>
 <20261021152527.375070-4-tarunsahu@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021152527.375070-4-tarunsahu@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 6848580004
X-Stat-Signature: zzo1ee7juzz73kuey9sy64rrnsxmd5dj
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792626948-396225
X-HE-Meta: U2FsdGVkX1+Pciwjq/fRwh24WFus+Z9/tH1V/Bp1ZEOLWzlq6fK/lKziKqXrNWMHgSsFYyTlX7LttG6D0v834Bmy0BenLOTkXnGZnjvgpuao915ZuNeIVCDODqaLD589EPo2r4NfHahTNNywvh3voQfqn3ZPHKL280hcitfunhY/z5+I2xNF0Xzq8kCaCby8Ump6gaItGXBViDpkFzAAveaDoD75zpbMBPqBYsGchEyTGaVA5cjYSZqdjxWyhQr9Tm6B9uBrk/KzWOrBBymyQ0XGP0HPhi7bLH5I8BYOoFiS//+vv7r4GaYgB5cDTznaMv8h8pjx6D627UNqJ6AVjE67Qbsf427X+uLuAJaZrnk5K418rrCqtFVcS09XoFDiPoYNI7iNy/hMdRwb81RQrqhftAF1Zy+V28c9DnT98/6+JI4IeXKJqLaqmI0LqgEqKxKR0Lg24KedlTZk2Y95bLHf/wF/rmEI+sDqYZiaw6zVL6zY7/94fmY+F4N6QZ/VZsqx/pqcdc6obUyx7XgayaaLrXbw9pR7AZylRFzTx48FUkuGyU3FtzIuKMoMHGeb+T/6eJiS/r4Tao2QN8UA49GDargU8GBVROOtNsDGgE8P13TY76OSshjNVerRH3IJcHGlxhBR5arzVugGmGBL3zbnxS+vabyea264a08t07jzZN/eaZErRRwy3CxicUAj9Ln7msS2D7M2WxetBOlhUVifa8jo3y1w6qJQ1TNIKj76gpnU2enHejIS4wyaDovGQKeTkPOSS5y+ZU1Xwa2v6NYXxlELaOcI31Y8F7C3JpU3mdAlBFQu58pR+ydyKk4ObHd/I8Vdc6BHpSgS/xWkcYwpfNkzHCDKrMzyDKlUSla5TAepYXCa646zRzbM5iYWXBOl4QNlcL5P053Gdcd1vf51agAqeFp6kY2mKvz9sm7k0wz0phrRpEZI1qSfRW/eaJvqkndCYJxGTjMW9n5
 wuqJVJt+
 Xm0dY/29P7MPv4gFLBYBhwtcoV99bpxrIRp7pV3EDnk4U7nVh9ODK9kV/5/oaSidHcQmKBCIjEXemJZ1ZFPPDk+dnZ7kD3+Qn9yDWKwzhiKIymj52XLgS6XzL4BrFyVx80Ny0idzM+y9j8Aj6M2fGEUbwFVfOyNCNSYhpmyG1ODjFzWVH7OG0IEi7n7lgKMUCgcBHD65/fHvsGJN4b1dIMvAdnqhfDVLu50elNQP+uzfrIMqkoI1Qq8NxkJlo2obXgktiNrWgFbNP2Urjq6EwEa4iFEXtrnTH6rguJwAGey1UGf0M35Y+9cxHPaQ5Zkaz9Qa3JVF3S8WL1q4dJqDZNPt0TW595RL7COOJwBsgsy5WFDhctkOpph83Sw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-21 03:25 PM, Tarun Sahu wrote:
> LUO and its file handlers validate handed-over state with monolithic
> compatibility strings ("luo-v5", "memfd-v2"). Any change to a serialized
> structure, even an optional additive one, must bump the string, which
> breaks live update between adjacent kernels. Replace the string in
> struct luo_ser with a feature header, so that the target kernel can
> accept or reject the source kernel state per feature.
> 
> struct luo_feature_hdr is a fixed 128-byte header: the serialized
> structure size from the source kernel followed by 15 chained u64 feature
> flags entries. The fixed size keeps payload field offsets identical in
> every kernel, regardless of how many flags entries a source kernel uses.
> 
> Each feature has a 2-bit pair (req, active) state (enum luo_feat_state:
> LUO_FEAT_DISABLED, LUO_FEAT_OPTIONAL, LUO_FEAT_REQUIRED). A flags entry
> holds 31 features, and bits [63:62] = 0b11 chain to the next entry (465
> features in total). Each subsystem defines its feature states as a
> static const u8 array indexed by its feature enum, which
> luo_feature_hdr_init() packs into 64-bit flags entries with
> LUO_FEAT_EXT_MASK chain bits. The target kernel validates the header from
> the source kernel against its own feature array via
> luo_feature_hdr_validate() according to the per-feature (req, active)
> truth table:
> 
>   Source Target Action
>   (1,0)  (x,x)  Reject -EINVAL: invalid source kernel (req without active)
>   (x,x)  (1,0)  Reject -EINVAL + WARN_ON_ONCE: invalid target kernel
>   (0,0)  (0,0)  Accept: feature absent
>   (0,0)  (0,1)  Accept: feature absent
>   (0,0)  (1,1)  Reject -EOPNOTSUPP: target kernel requires the feature
>   (0,1)  (0,0)  Accept: ignore payload data
>   (1,1)  (0,0)  Reject -EOPNOTSUPP: source kernel requires the feature
>   (x,1)  (x,1)  Accept: use payload data

I think we have different definitions of "required".

In the PCI series [1], required and optional flags describe the _data_
the previous kernel handed over, not the kernel itself. A required bit
means "this preserved state depends on feature X; a kernel that does
not understand X must not take it over". An optional bit means "the
data for X is here, but you can safely ignore it". The source kernel
only sets a bit when the preserved state actually uses the feature.

It's up to the FLB/FH retrieve how to handle the scenario where a
required bit is set that the target kernel does not understand. For the
PCI FLB we panic since failing to adopt the PCI state could lead to
memory corruption as preserved devices can be doing DMA.

The target kernel never requires anything from the source. If a
feature is absent, the target kernel must handle that, e.g. by
falling back to default behavior. If it can't, that is a compatibility
break and should be handled by the compatible string.

In this patch each kernel has a single static feature array that is used
both to generate the header and to validate the incoming header.  So if
kernel N marks a new feature X as required (so that older kernels reject
data they cannot understand), then kernel N will also reject every
kernel that does not have X, because of the (0,0) -> (1,1) row in the
truth table. That breaks forward updates from N-1 to N, and rollbacks
from N to N-1 even when **nothing being preserved uses X**. Therefore,
every new required feature becomes a compatible string bump.

I would drop the target-side required state entirely and let the source
kernel decide which flags to set for each Live Update based on what is
_actually_ preserved. Accessing a field added after the original struct
then always requires checking its flag.

At the end of the day it is up to userspace to never start using a
required feature while they can still rollback to a kernel that does not
support it. Cloud Providers know how to do this since Live Migration has
the same problem. This also means we must be very careful when adding
new required features, as they need some way for userspace to explicitly
opt-into them. I do _not_ think we should try to have some generic LUO
opt-in for required features. That is up to the File Handlers and FLBs,
as they have their own uAPI.

[1] https://lore.kernel.org/linux-pci/20261013162529.1928093-1-dmatlack@google.com/

