Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 796BD606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 00:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=oVAVblGb
Received: by kanga.kvack.org (Postfix)
	id 732A36B05B0; Mon, 26 Oct 2026 20:01:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E37F6B05B1; Mon, 26 Oct 2026 20:01:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D30F6B05B2; Mon, 26 Oct 2026 20:01:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 28E706B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:01:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 838A2120930
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:01:18 +0000 (UTC)
X-FDA: 85366451436.02.E74C373
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9DC5A4000C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:01:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oVAVblGb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793059276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ixKouDoUlCLHB71PytJx4w1v0AUAxSqI48/quFxSDg4=;
	b=Yw5427lfv1EWsawP7Lcxupk4bUK431Ptx5QWcAvYRPQBMSa9w9eB9c9WblIW9vdXbuOyto
	G+Qw/6+EG20tQi2nR210OeZzZT3pvZfwmfYsGa+OyB+1OVaIfcJL8hZT5DVA2pn75LOz9c
	6+WnJxZmO9fwxy8BlNQcytQU8F2D7mo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oVAVblGb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793059276;
	b=hSH2mN3tGziHQ1a7RiWUfyYi5Df56vrw73vrCm9CfqfjGaIDqo2Sq5VazG0wtx27RqEeeK
	wWo4dVr/oiZ4ZegrFLmi6X+MvRKnN62TmAl+fzSTg+0HdoYyR6wi3iuqwerA0rgiAAEds/
	C+oBM9yMIrnJbj1ewGKTyJyMASKOVKw=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3ab98332238so1969583a91.3
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793059275; x=1793664075; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ixKouDoUlCLHB71PytJx4w1v0AUAxSqI48/quFxSDg4=;
        b=oVAVblGboy6LCCd6AhD9bVjg78YSky9OVGsw1IdTJViJTBL4lXK5QvSuYqley+bgZF
         24QEVyCJPKgLLKt2UJ0jHG2CB9LenLsPfxxBhbbxshr+MdxQLhdclFVbOOtiI9nRvFgz
         hd+6wZOB/rLXqWm0KD/QMsa/Jyvz630UjZd+acqYIk+pcEbr/wCzWtMDwv/P5vXggvoj
         gokNiyLtmZCFewRfKjhMltGjMV2UuOQtBTKyToBUIsgzTbbIBJdrqfmQ/PisaJUNMQKI
         ogmo5Rr0PyqgFAIKcstYcxEc2o/iVzLaGodXSdx9BamyzA+hbn643AknGnEPYtrNFLlg
         FoFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793059275; x=1793664075;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ixKouDoUlCLHB71PytJx4w1v0AUAxSqI48/quFxSDg4=;
        b=PbRzX9SEgpfWcQCUZRUBDGakSN50mkAL0DB5YssLSy/dSuq4NBeaFV90rIwduCw/+W
         +vRg4w6Ep5OzjUD4hsmBNoezeMgMGNGa1rBIISu1RSVzJSGEY17D2oACRdDmT/rvh9oG
         OgmkSUzCSeZMEx8c1eC2bc7wtnes4GGXjdndSiTtDHtYObh4SNvdAUkmjOHmXsLrDDG/
         X3Zzu3+jNLo6cDaCLiyvCimuGAOUUX0csq3XW6Uf2Bwa8nhI+TPQT1tBzbo7tbWb3vu1
         tUODSWxll4+g2XxSIFzhQjPoMa/4x4gTU7RuWzfBySi9KvcKeb2CjIL52gRgIKQl28hq
         nZlg==
X-Forwarded-Encrypted: i=1; AKwUvBzPan8VVHK/iBDKTzZFmp6NGtmkfML21DiCurkv7gBdSAnQDkzbR7DgJpOlu4f/8bvG8hcZeZ1PRg==@kvack.org
X-Gm-Message-State: AFq9FYLxkGzsJoDmmTHoVN1XsEiPPWpA1ipHVO0e4V7hC9BkjL8eYrdI
	KkpYeo8EV3llMug5/QBxQefnnjs0XNEjlbmteUKVDk8pct+qegHjUfk3UBMqvWpbVw==
X-Gm-Gg: AYBFou38iKIXRw867pbkooqmfdef1e9i7JI8jICigUr9gfZU+q5iWPHjVpti0E8ueNs
	aWAjmDDFXSBpHxQnX1LlhGjLm4qSWk6P15TAMGp+WTs6L+hCiD22HZFc5i/uCdjXuXWGQANGlQO
	KCrEqd90W7h4T3REkB/gBSm15ssbpZRfWpB7OSmzT8pFzIPBHFT2/Hj6pQ/ruYzB9zNpBMSFIvQ
	+AB1OdaAigcswswccxIe6Vpo80+7WIEbrfEGEduJZkYX4bzp/0pMNi6BGkalUeHieiPq0YdB/uM
	BOJcdMjVwmlqn3P+VLhfkIrXjyRc+F1LnD9VGmGXYScYxKbMuxuP9RIBKGHEeTgvGs4ENoiPngs
	P3QJ12z0TvsReG7YMinxNvZG1VXaZgkvV4p7arl7UCFhhlAi8ZifE+WgfOdxUn0tY71kVOmiKTP
	PsprCY4OcjDIJHL+ORrMnbjRu0Erq3VKnPNU6Yj8GjIktsxcJlitAwJhriFcpWXva12EUSNmu+i
	MvJfBY5KJ8p3qcsNP7vqCr6Xb8i87+YLm49Y/qYOzk7VFi6Y8NQpjWFcBXOWHbFH8gmy7QSprXU
	gd9y+nxsfaukHdCF2bGRgJdpF13n2jIF3Ju/AcoQMDRnCk3vGurKM5w4NEXIkHxggmYWrow=
X-Received: by 2002:a17:90b:528c:b0:3a0:e4ce:31fd with SMTP id 98e67ed59e1d1-3adead444ecmr7102022a91.10.1793059274755;
        Mon, 26 Oct 2026 17:01:14 -0700 (PDT)
Received: from google.com (192.150.203.35.bc.googleusercontent.com. [35.203.150.192])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae4066cf2dsm1119900a91.16.2026.10.26.17.01.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 17:01:14 -0700 (PDT)
Date: Tue, 27 Oct 2026 00:01:10 +0000
From: David Matlack <dmatlack@google.com>
To: tarunsahu@google.com
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
Message-ID: <at_pxoULR1Tp5anN@google.com>
References: <20261021152527.375070-1-tarunsahu@google.com>
 <20261021152527.375070-4-tarunsahu@google.com>
 <atlQ_Er0Ig7CCSxv@google.com>
 <CALzav=f00C4yOAseNunW8GgQTDUGWT927Qy=TLm-3-J0TEDH8Q@mail.gmail.com>
 <9huzzew0el59.fsf@tarunix.c.googlers.com>
 <at_CncIPYCxOVkLo@google.com>
 <9huzecdcghxu.fsf@tarunix.c.googlers.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9huzecdcghxu.fsf@tarunix.c.googlers.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9DC5A4000C
X-Stat-Signature: r5dgz6sfm8pmdtafhu9nkmajyqpcgi6c
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793059276-969241
X-HE-Meta: U2FsdGVkX1+p4ndEFRCZCrjYQyZi4aonNFpo4jQA4C/zTlU3CZM6LA4f34ax5FrnLoBKlHhrRMoxow1PcUHjOCEwmaPX3svsRRg5iV4IxXMrDCkyEKitBeniuqA4cnKEtF3XukjHzQH0Q1jDK7wFrEKvtRIpqmZfX9JxbLWiqwz1iS+Xs11Wd46koEai/wFw0mbEi55zBRwE06uB/OzcGQhDMVCanzQaPD1sAl3QDCh0QMP5RJ08CgfxLwHJhd10gmWnpKUhubHpT8OgDGSkbNiKYZQYH5pwu9iHtCTvXXIDHSfvWe0hW65FT7ccW9bjuvDpl8gVFvoUEaSEDZR/Szy/jh+o9c+J2iKDEt1zjSBE5s9eSTtk37khws8m0rF+8/OVHY+rPQUAWuSRZ+HeWQjha0YGBtUQLcLGwHdNhKXGqYcChBmcxwvg6ZYZlvGFgNd24nOnT8gLoAFhBOBg3LPOsWv60w3E4WQOXGIDFgqx6w5qjWPiOW73cwW4gwkHxXoZ3DuYVAcuUiI5kfOhR9VKjDbO2Dbrxqd3aZDcLrBTGGD+4IE1DuGBCy15QqOg2R9tTeHYphle5eOlMoL50aSGZ72IvQ2YPDx00i84ef7r1lhqAxeHms5q6L2ikKNkXuH72ynI0xGQKXgYFPo4ege45uhxDtCtrfsF43PHCdBffDpt9Ik8IZgiQ9L4+4UZ21HC598bgoJqiCk+o1++PctSPPVyh0AcWtHWNgVyHpPgZI4hJdqDBP8jV7QV6kyHlgXUwPomTwWwk7jxPlw2mET7nJT2v6zgV2gP+c4NbPmkSk7ELiEKsuBEjW2DG8O+jFHY/c4Br5nwyhJgZJPITfeqUcjwuqt57f/obRXVTDUWr5MKuLXsMiFHSuUv7w6wHib42YFUdQfc3UVBIJ0VWgYqf/c8sfWUoY/PnG/lw3jrpXUwNb3vrnH1roEWoPi+i72OEjs9NSNdFr484nQ
 oX1q+EoS
 Gs7HlmqIcVcsSfY3RH0DPg6OsRwELtgVcvH1ksoGhUH8C7cVnkozmiCwz0zYUvt0SoLXr9CHV7jSLgc6i9t5KqVVMfGOX3syAxi7TRPvXD3RS5CTbFUw4T2xISPNNs30U+o2V/JOIULoqqS6bx6l6CMsjE5B4ZW6WaJYLSnC5WrJvP5zMlDg5VY60zdwOsdyLh0OEWmXq5wWa1maYqXe/+CrroEL8/7UTiGIdYK69Q862d9cywJ7ernURm7HtSUKKMWJ7aLCigTINBvo4fcq9eEI7IPOucN9BC5dW2ZuaEebS1zU9PCXAQ5cxjwyJBPLM3k6G+GBfyZMPeDv5KJKcZ36T/pDCIyvbfL2m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-26 11:28 PM, tarunsahu@google.com wrote:
> David Matlack <dmatlack@google.com> writes:

> > But looking at this again, I think the required bit is redundant. Whether
> > a feature can be safely ignored is a property of the feature itself, not
> > of any particular file. Every file that has a feature present will have
> > the same required bit for it. The only thing that actually varies per
> > file is whether the feature is present.
> 
> The required bit is subsystem property not the per-file. e.g. memfd_luo,
> it is set at compile time for a kernel. So every file will get that required
> bit set. It is not per file property.
> 
> struct u8 memfd_luo_feature_state {
>        [MEMFD_LUO_CORE_FEATURE] = LUO_FEATURE_REQUIRED
> }

Right, whether a feature is required is a static property of the
feature.  That's exactly why it's redundant to send it in every header.

> > The required bit still has to be conveyed to the target somehow, since
> > the kernel that needs it is the one that doesn't know about the feature.
> > But it can be conveyed by the feature's number rather than an extra bit:
> > split the flag space into required features and optional features, and
> > assign each feature to one of them when it is defined. This is similar
> > to the required_flags and optional_flags approach in struct pci_ser [1].
> >
> > Keeping the same header shape as discussed with Pasha:
> >
> > struct kho_ser_hdr {
> >     __u32 size;           /* Size of header + payload in bytes */
> >     __u16 nr_required;    /* Number of required feature bits */
> >     __u16 nr_optional;    /* Number of optional feature bits */
> >     __u64 flags[];        /* Required bits, followed by optional bits */
> > };
> >
> > Required feature N is bit N of flags[], and optional feature N is bit
> > nr_required + N (using nr_required from the incoming header). The length
> > of flags[] is DIV_ROUND_UP(nr_required + nr_optional, 64). Both spaces
> > are numbered contiguously, so there are no gaps, and up to 64 features
> > still fit in a 16-byte header.
> >
> > Each bit just means the feature is present, so the truth table becomes:
> >
> > Source bit       Target supports  Action
> > ---------------  ---------------  ------------------------------
> > Not set          -                Accept: feature absent
> > Optional set     No               Accept: ignore the feature data
> > Optional set     Yes              Accept: use the feature data
> > Required set     No               Reject: -EOPNOTSUPP
> > Required set     Yes              Accept: use the feature data
> >
> > There is no invalid encoding left to check.
> 
> 
> IIUC, I believe this will not work.
> 
> To Communicate between source and target, We are defining a protocol, A
> protocol which will be standard for all the kernel. And each bit location in
> flags must have the same meaning in both the source and target kernel.
> 
> Now in you approach, If Source kernel send feature N to target kernel,
> target kernel must understand Nth bit as the same feature. Even though
> the bit position in your approach is not fixed but they are fixed
> relative to their starting point.

I think you misunderstood the proposal. I'm not proposing to pack only
the set bits, and I'm not proposing that each feature have a bit in both
ranges.

In my proposal, there is no such thing as "feature N", there is
"required feature N" and "optional feature N".  Required feature N can
be found at bit position flags[N]. Optional feature N can be found at
flags[nr_required + N].

In more detail:

 - Each feature is defined as either required or optional, once, when
   the feature is added. That choice is permanent.

 - Each feature gets exactly one bit, in its range, and that bit is
   always at the same position whether or not it is set. Required
   feature N is bit N. Optional feature N is bit nr_required + N.

 - nr_required and nr_optional are the number of features of each kind
   the source kernel knows about, not the number of bits set. They tell
   the target where the optional range starts and how long flags[] is.

 - A set bit means the feature is present in this file's payload. A clear
   bit means it is absent.

 - There is no invalid or reserved encoding to define. Each bit just
   means "present".

 - The target doesn't need a supported table. Required features are only
   ever appended, so it rejects any required bit at or beyond its own
   MEMFD_LUO_NR_REQUIRED. Optional bits need no validation; the target
   just checks the ones it knows about.

> For the current appraoch and V3 [2]. Think the below one as msb is
> required bit and lsb is feature present in payload bit.
> 
> 00  FEATURE_ABSENT / DEPRECATED
> 01  FEATURE_OPTIONAL
> 11  FEATURE_REQUIRED
> 10  IS INVALID (analogy: required set but feature is not present) which can
> have different meaning in future if in future, a need arises to reuse this
> field.

In v3, 0b10 is reserved and not checked by the target. That means an
older kernel will silently accept it, so the only meaning it could ever
safely take on is "safe to ignore", which is what 0b01 already means.
A reserved encoding is only useful if older kernels reject it, and at
that point it's no different from adding a new required feature.

> Deserialization can happen per feature from right to left. without
> jumping back and forth.
> 
> Because of all these reasons, I believe current approach presented in
> V3 [2] is the better. It is close to your PCI series with two flags
> field for required and optional except I combined both field into one
> flags. In your above approach you do have two counts but not having gaps
> (which is wrong) and the way you proposed to parse with an offset is different.

