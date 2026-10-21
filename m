Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AC9E606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 23:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=XS2ZSrEA
Received: by kanga.kvack.org (Postfix)
	id 973CE6B07E7; Wed, 21 Oct 2026 19:18:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FDD26B07E8; Wed, 21 Oct 2026 19:18:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 777E76B07E9; Wed, 21 Oct 2026 19:18:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ECD986B07E7
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:18:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 74ACCC072D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:18:21 +0000 (UTC)
X-FDA: 85348199202.06.320EF97
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf20.hostedemail.com (Postfix) with ESMTP id 92FC51C0005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:18:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XS2ZSrEA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792624699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7nCAo4+9lz8Iyt19nkj9TmOxKkMhE+NTyi1XeRL1MPk=;
	b=FdeQZfouQjNhq+Zhs2jLqGWWRlz01u8qawHQLRrwytw6743k1cKBpDpYGfssnR03r/4M3A
	d0OlfyqreTB4enjWrA8P8jlvNL/pSf03owPMdmPJJso3GExU8N7mC7uhn3CD4uaVnxhNkE
	JOvNlKXkcbBQsdbsZKTCg55oLiiuxNY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XS2ZSrEA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792624699;
	b=aRgwrmkznuNt6uwz4wH5lPicsbU8LXo0rA4D8JVYBbIGwkhsMGi3HmBOojDiDkBTOtjl5m
	b4HENTgNx06cM+4/1JvtD9tyEV3XeJxLMv1wPv+lCfv9zHEToaNoGh9u8xH9PFHHLOZmH3
	4vZ/QFrtzAm+TdXgLhrX77N1xpU9kaw=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3a4cdc9025bso771191a91.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792624698; x=1793229498; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7nCAo4+9lz8Iyt19nkj9TmOxKkMhE+NTyi1XeRL1MPk=;
        b=XS2ZSrEAmmY0o6VeHIbPxlC0ZrmKLr+yAXbR8Tw9tiBHjRHg1veWprQWy0RfxOgpsU
         bWmqUrARWVUTHX2QXSJyzOBCvnrxpTS+crXBWvlsHwDryyGmBUN0w6JL8pTZznOlAjlX
         431aQTqfnC1bTb7TALlIXtD3I4ymusKqJK4utg2Wi8xHpm5m/K/U5q10Nrt2eAGrH85k
         anLYjbN/JsYJN4q/0Z4lTEjQCn5+gPrp2YM9qMT5j6EQt6WgRs5/KcafA7j2GLGo5Jlo
         +AX3S2geriIci0R3CN3/wLvlXfZv6pC/ceUCdOu4wN8LkDmOXziHbpE0mFGSUiSlGbtD
         DOWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792624698; x=1793229498;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=7nCAo4+9lz8Iyt19nkj9TmOxKkMhE+NTyi1XeRL1MPk=;
        b=GynzFIj3FXm++AvTw4hlFjHAhpLMJrxs1sTZ/RFSoYsHRT+UBl7fPn/vdsSywN98yF
         QCtGKWwqk7PkKaua4TXipojnJmX6BMTOZz56DQmrf2oPZ0/NS9O/Khnao2ATxyuoDId6
         mXT+xXn9hjz9WlLYuDri7MI/L0QAPem3raGGpDGzQGEDc5yWSFCwvpFDyMNAH34gNr98
         O5qx8YPtlyjnY2AHkouUuVjuCLv+erKu49lnEljnTUaHSQ34BpCogN/xKrk3Nc+n0tPE
         8wt9a/MVGboAYNYLfeBm/ElqssoPLBfaSlb/G737TtmxrwX4E+IAJlmaLh8kXUOqZi68
         WLKA==
X-Forwarded-Encrypted: i=1; AKwUvByR3DXi/TEZIIGHe9ANs1VXAP06+QnXxQ+WD9JUwwKw8EPR8eqst8J5oShtLW55TLjsADL/gdQ9rw==@kvack.org
X-Gm-Message-State: AFq9FYJqaZzPOEJqrQEAL1azweC+Ml9Kq+2mve6siMo1Hvu8YeCK81g6
	NCcAmoT/uZm+x2QEtBO1B/ctmWO3HLcIRzmbBW36jAk1rdpb7wvOwY+MxsLF22BISQ==
X-Gm-Gg: AYBFou3Y2oLQsrZD5OvXtGBT+yhrxd6L64lW/jdVyX7LewdZS+MIR4usvCnpibqfnu/
	0JZ7Zrpw+hxtuHODPYDkDNtoCEyWVPbiY1RcY5io6by6PGRN8CyNe3gKY7OvJQMiz7VBGaUcBE1
	FE5nlO1ywmTy9InMhM5ynGNf7kFBlQ8M/ulHvRILuiUWwAq09v6uajiXcp87mpSEXuU4NcShJU9
	/4SQFEYDEr4D2GiryauC0SKXH6VpO8ezLDPqAWj7y01TkKF87IRALxO6PoS0baUINjT+SoV6xjn
	opWUKpNkVtP7M26k9G1c3fEqmdchI1J3dd9cD4jC/39mbtoEIveWXQN7GmG212KgKP9/M7mOvKc
	30Ngf5XlYwObIMlpLTsyh/1HWlhwi+HvK1JGAZHnfDWUssf+PpQo0xtoRK530SxYU/EmFOWeRRb
	/zyji/mCFpRQGwpyGam0++ULI0iLzte2Jq0p0Srpu1oa7dFOA2mt+jXi02pyBAECaX9heOimHNi
	KXNBV46qPCQCmFB7iVW69PRiYG63f40u3ruHhHPc21TufHc+50RdotCCUu9tEpelsHkGh+GeXn0
	/WRZWHSq5WdN/b8pdMllkoZwLJr2Li4guz90xA==
X-Received: by 2002:a17:90b:3c8d:b0:3ac:7f4c:a690 with SMTP id 98e67ed59e1d1-3ad86eeb9e6mr2442353a91.35.1792624697709;
        Wed, 21 Oct 2026 16:18:17 -0700 (PDT)
Received: from google.com (64.75.127.34.bc.googleusercontent.com. [34.127.75.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad85f62d22sm3123694a91.4.2026.10.21.16.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 16:18:16 -0700 (PDT)
Date: Wed, 21 Oct 2026 23:18:13 +0000
From: David Matlack <dmatlack@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Tarun Sahu <tarunsahu@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de,
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com,
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org,
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com,
	will@kernel.org, Alexander Graf <graf@amazon.com>,
	Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com,
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev, linux-pci@vger.kernel.org,
	kexec@lists.infradead.org, skhawaja@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 4/4] mm: memfd_luo: Add the 2-bit pair feature
 header
Message-ID: <atlINfvlXY4wMbpO@google.com>
References: <20261021152527.375070-1-tarunsahu@google.com>
 <20261021152527.375070-5-tarunsahu@google.com>
 <CA+CK2bCWo7ixrNLKPvqETn3JSFwSNaB2UsPgy9RHVAhWroJURQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bCWo7ixrNLKPvqETn3JSFwSNaB2UsPgy9RHVAhWroJURQ@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 92FC51C0005
X-Stat-Signature: sgw4pk5b3tg15t41xp6btjikpjy9pskw
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792624699-139799
X-HE-Meta: U2FsdGVkX18FBRSgwR7gxtwOEJ5HIhWqr1NlgIDUN/rTwAKEHyZoSUNfkN7RWIpFlD3jhTLd2BKILScE8nXb/o3LTUNKD/tFMo/5gfs0LsocrQ4v7YFMlT4zByMs1b4ATYs453lkbwPa3rIFpdw9Ol+NJLM+FNS7u0YDRaDp/tpaphMGOmqd/wpdu/bl6rn+XvFmLVrNR3JT8q5zc9s6ShB6gHQTSZwTKauHFoysz6VvlEHDHaGUmwdT3oYQx1trgpm5r+E6tPY3wBGYm11sj9N48+g+bKWLXL482lIaZfPZ4z4CnRnZ18noLwB6o0G1npmgebqdCWqdTi7YpnkxV9/tGvPZNf6IUxZBdIthJQ3XOhPXuVm9ZVPM8oC/OHqI1ZgXW+E+XnkMUN9xOaKl7bZsINHrrE8YGcG+YxnL/xKCS2MSJ8jzmQmapqbKDnm1hDJBzXVIgs8C2324m6X1ZlFt6VFTeNE4i5sPH888WYZTrsjthgMRhHvxkTXnQuxuJ7tlpoAusziEqac/GprSDTfI7tfBSQaNh8QSQhfTlE0csBsStTlF4GpY/uED3ATeQZvXc7lRnkE64uWjHLyp5RYpReZYhP/HzqvUZi4lUiT+JXF4aY1aZX0EnBJnC2JAXpepha5aTn8WrhuH9sNOUaqSGdR8PtHUhOnK2mkqyBeNgTCuM9u5HwK1UMueOVnIwfu/V6jOgLSJ4/bcJrHjNJPS+Eoa6iVzofe4Klu9hq2/i3spoC454jVMnzIwyY+PSbb9QliiuhfCvonMO1igjU5aLJZigYwlyKHNfIL/plUeS2N9uiIgE3ZYd/QwM0HAaTGt6inh6DctKtZUdGmveake/z+luxrIl/J6lAzgFi6lQLGcreJohLqPSrwZUuPpzTSdwvlpyH4mpuxY2W9Xa+8ZFG7ZZEoXU5hMHgFJLjKQvI/u+LPKNverCoZKDtsntlErO+hkD765HZmG1Ry
 fZx2T7/W
 V84l637IWMHpq9bZ0LdQACuBhVM810hqGJo3D8mm8y+Q7JOBJa+yNPWfC6vqM0qrigeQL2j2bV7NFD27pPMLDACkPJsYWI80Wz6FoKGqtRLIRPwwPOfFcSW4tmkiwVRgpZDNvzput4ynlbLUb26ppKhlE/pSvp0VqKSeV5QN9VfjX3t3zfm5EGOJraxWUjg66jXlr1qbc0hutwpHoIn3td8Vl9fFMaFomoBlRq2g0m5EftL1ZtPFiaXp4hP+3WCSkz8MXfKeEASGEudtFEhGzyOqObOGOvvWi/PydnUpX6SEsD/UQns5M+e/ZSqNAMZ2sls4uw6ugAIK1sa4bjEzV8wyu/OrMGbo/J1w+dXsczYnrTaEtwVfNZIAwDgKQqMFc/2tGoZuqwj2ntq8f6tukinRUrHW+O8k6DYGSPwdLMp9y+m6WWhMiHzA4xly4QXoZuM+VE6EZpQOySjU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-21 01:38 PM, Pasha Tatashin wrote:
> On Wed, Oct 21, 2026 at 11:25 AM Tarun Sahu <tarunsahu@google.com> wrote:
> >
> > Embed the fixed-size 128-byte struct luo_feature_hdr at the start of
> > struct memfd_luo_ser and define enum memfd_luo_feature
> > (MEMFD_LUO_FEAT_CORE and MEMFD_LUO_FEAT_MAX) for memfd preservation.
> >
> > All current struct memfd_luo_ser fields (pos, size, seals, flags,
> > nr_folios, folios) and MEMFD_LUO_ALL_SEALS belong to
> > MEMFD_LUO_FEAT_CORE (LUO_FEAT_REQUIRED in memfd_luo_features). Future
> > changes add new entries to enum memfd_luo_feature before
> > MEMFD_LUO_FEAT_MAX and append any new fields to the end of struct
> > memfd_luo_ser so existing field offsets never shift.
> >
> > Signed-off-by: Logan Odell <loganodell@google.com>
> > Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> > ---
> >  include/linux/kho/abi/memfd.h | 35 ++++++++++++++++++++++++++++++-----
> >  mm/memfd_luo.c                | 14 ++++++++++++++
> >  2 files changed, 44 insertions(+), 5 deletions(-)
> >
> > diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.h
> > index 371ffd108a79..f0b5235a408d 100644
> > --- a/include/linux/kho/abi/memfd.h
> > +++ b/include/linux/kho/abi/memfd.h
> > @@ -13,6 +13,7 @@
> >
> >  #include <linux/types.h>
> >  #include <linux/kho/abi/kexec_handover.h>
> > +#include <linux/kho/abi/luo.h>
> >
> >  /**
> >   * DOC: memfd Live Update ABI
> > @@ -21,11 +22,20 @@
> >   * reboot using the LUO.
> >   *
> >   * The state is serialized into a packed structure `struct memfd_luo_ser`
> > - * which is handed over to the next kernel via the KHO mechanism.
> > + * which is handed over to the target kernel via the KHO mechanism.
> >   *
> > - * This interface is a contract. Any modification to the structure layout
> > - * constitutes a breaking change. Such changes require incrementing the
> > - * version number in the MEMFD_LUO_FH_COMPATIBLE string.
> > + * This interface is a contract. `struct memfd_luo_ser` starts with a fixed
> > + * 128-byte `struct luo_feature_hdr`. The relative order and offsets of
> > + * fields must remain unchanged as features are added or retired: new fields
> > + * are appended at the end of `struct memfd_luo_ser` under a new feature
> > + * flag in `enum memfd_luo_feature` (before `MEMFD_LUO_FEAT_MAX`), and
> > + * retired fields are kept in place so subsequent offsets never shift. In
> > + * the target kernel, fields of a `LUO_FEAT_REQUIRED` feature are guaranteed
> > + * present once `luo_feature_hdr_validate()` succeeds, whereas fields of a
> > + * `LUO_FEAT_OPTIONAL` feature should be accessed only after checking
> > + * `luo_feature_is_active()`. All current fields (`pos`, `size`, `seals`,
> > + * `flags`, `nr_folios`, `folios`) and `MEMFD_LUO_ALL_SEALS` belong to
> > + * `MEMFD_LUO_FEAT_CORE` (`LUO_FEAT_REQUIRED` in `memfd_luo_features`).
> >   */
> >
> >  /**
> > @@ -58,7 +68,7 @@ struct memfd_luo_folio_ser {
> >
> >  /*
> >   * The set of seals this version supports preserving. If support for any new
> > - * seals is needed, add it here and bump version.
> > + * seals is needed, gate them behind a new feature flag.
> >   */
> >  #define MEMFD_LUO_ALL_SEALS (F_SEAL_SEAL | \
> >                              F_SEAL_SHRINK | \
> > @@ -67,8 +77,22 @@ struct memfd_luo_folio_ser {
> >                              F_SEAL_FUTURE_WRITE | \
> >                              F_SEAL_EXEC)
> >
> > +/**
> > + * enum memfd_luo_feature - Feature indices for &struct memfd_luo_ser.
> > + * @MEMFD_LUO_FEAT_CORE: Core feature covering `pos`, `size`, `seals`, `flags`,
> > + *                       `nr_folios`, `folios`, and %MEMFD_LUO_ALL_SEALS.
> > + * @MEMFD_LUO_FEAT_MAX:  Number of defined &enum memfd_luo_feature features.
> > + */
> > +enum memfd_luo_feature {
> > +       MEMFD_LUO_FEAT_CORE = 0,
> > +       MEMFD_LUO_FEAT_MAX,
> > +};
> > +
> > +static_assert((int)MEMFD_LUO_FEAT_MAX <= LUO_FEAT_MAX);
> > +
> >  /**
> >   * struct memfd_luo_ser - Main serialization structure for a memfd.
> > + * @features:  ABI feature and size header for memfd_luo_ser.
> >   * @pos:       The file's current position (f_pos).
> >   * @size:      The total size of the file in bytes (i_size).
> >   * @seals:     The seals present on the memfd. The seals are uABI so it is safe
> > @@ -79,6 +103,7 @@ struct memfd_luo_folio_ser {
> >   *             struct memfd_luo_folio_ser.
> >   */
> >  struct memfd_luo_ser {
> > +       struct luo_feature_hdr features;
> 
> I have not looked into this yet, but I would prefer to use some kind
> of macro constructor for serialized structs. That way, they will
> automatically include the header, making it easier to search the code
> for what is actually preserved versus what exists only in this kernel.

If you want to know what is preserved don't you just look at
include/linux/kho/abi?

> 
> So, I think something like this:
> /* Base serialization header: 4 bytes total size, 4 bytes flags */
> struct luo_ser_hdr {
>     __u32 total_size;

Why do we need the size? I'm not really opposed to it I just don't
understand what problem it solves.

The luo_ser_hdr is needed for top-level file handler and FLB ser
structs. Those structs are always dynamically allocated and preserved
with KHO.

On retrieve, KHO gives you back the blob of memory. You look at the
header to determine what features are used in the struct, and then
access the fields associated with those features. At no point do you
need to check the size.

The only time you need the size is for a KHO block array. You want to
store the size of the KHO block array elements so that the retrieving
kernel can correctly initialize the iterator.

e.g. from the PCI base series:

/**
 * struct pci_ser - PCI Subsystem Live Update State
 *
 * This struct tracks state about all devices that are being preserved across
 * a Live Update for the next kernel. It contains only state owned by the PCI
 * core; the state a driver needs to resume its device is preserved separately
 * by that driver.
 *
 * @required_flags: Features that the next kernel must support to take over
 *                  the preserved devices. No flags are currently defined.
 * @optional_flags: Features that the next kernel may ignore if it does not
 *                  support them. No flags are currently defined.
 * @dev_ser_size: The size in bytes of each struct pci_dev_ser in @devices.
 * @nr_devices: The number of devices that were preserved.
 * @devices: Physical address of the first KHO block containing pci_dev_ser.
 */
struct pci_ser {
	u64 required_flags;
	u64 optional_flags;
	u32 dev_ser_size; <==========
	u32 nr_devices;
	u64 devices;
};

>     __u32 flags;
> };
> 
> #define LUO_SER_INIT_HDR(obj, _flags) do {           \
>     (obj)->hdr.total_size = sizeof(*(obj));          \
>     (obj)->hdr.flags = (_flags);                     \
> } while (0)
> 
> #define DECLARE_LUO_SER(name, expected_size, members)       \
>     struct name {                                           \
>         struct luo_ser_hdr hdr;                             \
>         members                                             \
>     };                                                      \
>     static_assert(sizeof(struct name) == (expected_size),   \
>                   "LUO struct " #name " size mismatch!")

Why?

Practically every change to a serialized struct is going to involve
appending one or more fields to the end of the struct. Asserting the
size means we have to update the hard-coded size as well every time we
do that.

Is this to protect against embedded structs accidentally changing?

> 
> Usage:
> /*
>  * Header:  8 bytes (hdr: 4 bytes total_size + 4 bytes flags)
>  * Payload: 8 (pos) + 8 (size) + 4 (seals) + 4 (_pad) = 24 bytes
>  * Total:   32 bytes
>  */
> DECLARE_LUO_SER(memfd_luo_ser, 32,
>     __u64 pos;
>     __u64 size;
>     __u32 seals;
>     __u32 _pad;
> );

IMO this makes the code harder to read. I think open coding keeps things
simpler.

struct pci_ser {
	struct luo_ser_hdr header;
	__u32 dev_ser_size;
	__u32 nr_devices;
	__u64 devices;
};
LUO_SER_ASSSERT_SIZE(pci_ser, 32);

> 
> struct memfd_luo_ser *ser;
> ...
> LUO_SER_INIT_HDR(ser, 0);
> 
> Thanks,
> Pasha
> 
> >         u64 pos;
> >         u64 size;
> >         u32 seals;
> > diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> > index 64f8b8cb75bd..ea1f4c8cd259 100644
> > --- a/mm/memfd_luo.c
> > +++ b/mm/memfd_luo.c
> > @@ -84,6 +84,10 @@
> >
> >  #include "internal.h"
> >
> > +static const u8 memfd_luo_features[MEMFD_LUO_FEAT_MAX] = {
> > +       [MEMFD_LUO_FEAT_CORE] = LUO_FEAT_REQUIRED,
> > +};
> > +
> >  static int memfd_luo_preserve_folios(struct file *file,
> >                                      struct kho_vmalloc *kho_vmalloc,
> >                                      struct memfd_luo_folio_ser **out_folios_ser,
> > @@ -284,6 +288,8 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
> >                 goto err_free_ser;
> >         }
> >
> > +       luo_feature_hdr_init(&ser->features, sizeof(*ser),
> > +                            memfd_luo_features);
> >         ser->pos = args->file->f_pos;
> >         inode_size = i_size_read(inode);
> >
> > @@ -525,6 +531,14 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
> >         if (!ser)
> >                 return -EINVAL;
> >
> > +       err = luo_feature_hdr_validate(&ser->features, memfd_luo_features);
> > +       if (err) {
> > +               pr_err("memfd_luo_ser feature header validation failed (size=%llu, flags[0]=%#llx): %pe\n",
> > +                      ser->features.size, ser->features.flags[0],
> > +                      ERR_PTR(err));
> > +               goto free_ser;
> > +       }
> > +
> >         /* Make sure the file only has seals supported by this version. */
> >         if (ser->seals & ~MEMFD_LUO_ALL_SEALS) {
> >                 err = -EOPNOTSUPP;
> > --
> > 2.56.0.212.g129ede20d9-goog
> >

