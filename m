Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9343CCD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 19:54:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 337486B0088; Thu, 28 May 2026 15:54:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E86F6B008A; Thu, 28 May 2026 15:54:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D6BE6B0092; Thu, 28 May 2026 15:54:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0BDCE6B0088
	for <linux-mm@kvack.org>; Thu, 28 May 2026 15:54:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AC0B0120949
	for <linux-mm@kvack.org>; Thu, 28 May 2026 19:54:04 +0000 (UTC)
X-FDA: 84817879608.11.58E3963
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf10.hostedemail.com (Postfix) with ESMTP id BDDECC000F
	for <linux-mm@kvack.org>; Thu, 28 May 2026 19:54:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Q6wpYPwm;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779998042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v9XIwGoHI7koXT5NUKG3hqbl2ARW9TxartU/PZHOXcY=;
	b=BfhKeTDjVHnQCUEaKNhF9G11v0jfArNqkcCepbvR4+E6rmcm3rzcZsuIcxLfQF2DgmTp35
	ajU07wcumUsEg/ucn8vbvMD8bfaVyY6LX909VXdE5HFCJ0jE9pleaiNfkteuDLhO60ao6a
	vHigGDiwcEGvJFPzGurkpruShqjzUrU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Q6wpYPwm;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779998042; a=rsa-sha256;
	cv=none;
	b=x++EYNrsDekodv55Y1XbuK/6PrH0GzuWkgJACv1LgoL78vsv+tOy7t8SUGsKQCDAU58wHs
	Rhs57tTo08m8RvvVz/YsGnMU+8m1/RElpduUIGj06pB8eukMOssXfdFUzkEyoHZl47YzbA
	BbgUTNJuT1Z8qfMTqjImrzEDrnr8pOA=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-516c96d0cdeso64558531cf.1
        for <linux-mm@kvack.org>; Thu, 28 May 2026 12:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1779998042; x=1780602842; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v9XIwGoHI7koXT5NUKG3hqbl2ARW9TxartU/PZHOXcY=;
        b=Q6wpYPwmeiD5nAt26YRfVKF4gZsPmuGPEGIuC83G9BmXQ7bnZxXVvroZaLXc3SvaCe
         ymB9egw7fHPZ4n1emavNjXgakjKgwdCGLXywVZo07dfluFYdGwtWl1K+Qd9WDtDmBMrt
         bHODEEnXDBJex60Bs6nrJPZuPXhOV7wXgu5uLNXXMpVynZSao6eQRI8Z1wzS52XhXUkR
         UpXYrq02QLONSrQ21hqXi1/qo4VqfSYPR4ZLF91GErdkOWRrpPw3yQrrPzbVMO1NYqt3
         wWKTiEdWq3Cvqe1/22rE/ka7VtNpwEhRtlKcJYqzQe6rW8rtGzER4RtbmzUHvU9JkM2R
         2JQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779998042; x=1780602842;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v9XIwGoHI7koXT5NUKG3hqbl2ARW9TxartU/PZHOXcY=;
        b=OrQfGsBjrF8TpiYKZ6f4j9gaGt/zlZerheQUlEMj7eWz/fVBanrMg7M1/zb62FFOpW
         5wg4eX/SupD/2t5rHI4kiZXaRUfj2uryhXSEfg3hL2fDz99H/wHF2x+4t90qTgasVefh
         T/Ipz87bMOB23OmcQRAkT3cjK+NjouzEeqz2OzhIiCHXTdidyvazg9VBTmZaxSudNcTo
         kkxU2lGpcSIEUV17EwMo4UiJyAPvNZhlaFVmHJizEJ2+IPZviqiZL6HKxZUM4SOUH4t1
         yFcjMs6eTGgHMsPSpcF6Bytfv8E7Sz7ndWslLrcVX27beV5Ofp9NGcR6vfJOLLSwpUxi
         b7tQ==
X-Forwarded-Encrypted: i=1; AFNElJ/GmdhUW0jBD1kdAqnSiVfKjJRXEO+F8mgJ0rzpWJPBoSaAm9YWqqlGwqUUkrIBxklaAU3/eEkMSA==@kvack.org
X-Gm-Message-State: AOJu0Yyy3IEcP1ydnKSYIsPfNlj+rUoKZzCHiaJJ+lLyE/ewkpbNidNy
	A9lXxrt1n8VU9xkOB+jF7wU4lMEu/IOpFuHzB61drUK5WcHXDid48F+el0sdEF/Iqho=
X-Gm-Gg: Acq92OE3DQTGVi4+WeXuB5kYPBG5WQR1NdYtMJoXv7oIUV/An3+RZRRK07FUnKoVW5K
	WeROHr/q+s3NKHNLrxhcfAcPD6FXXl+Q/b19U6qhrk9RAJ2hEVBoJ1Kmvnof3X/K/f2gxQGXgSu
	K9Vr6C7zaOhYCOdo4J/eX3Ov4uxGQBIUV4tcd2kx+XNL+jKsm9wp3nrt9wjW2e24R+wbg+yayWu
	H3QAD7edt8xTcg0ta8tJQZVGQZc6aDDJ6j+myKrCmFRcv1Z0mEKaHoYn0b6lwQwAD9qcKKozYV7
	m1Zig91amrl9VtIiR8PY29gBVw3droqWRGymctmgVjCZgpKzsGYsk1Zb9PCrD6RASC/8qNpQpur
	rS0Hpba+SciyBi1qtMzkT3NBXSs141jhAyhL7vKTCXVKKrtlnkpZr3OnfOZ+egHhwXigOdh+tKR
	v28eZyXVix1l0seDwAUfitWGd+WOX6BtJZlPwSM5Thu6nTXWxKmzPR6BqL/rzLCA==
X-Received: by 2002:a05:622a:6202:b0:50e:5cc3:6f42 with SMTP id d75a77b69052e-5172cca732cmr3748581cf.59.1779998041630;
        Thu, 28 May 2026 12:54:01 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51706adc63dsm85233251cf.16.2026.05.28.12.54.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 12:54:01 -0700 (PDT)
Date: Thu, 28 May 2026 19:54:00 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, akpm@linux-foundation.org, 
	linux-mm@kvack.org, skhan@linuxfoundation.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, corbet@lwn.net, dmatlack@google.com, kexec@lists.infradead.org, 
	skhawaja@google.com, graf@amazon.com
Subject: Re: [PATCH v2 01/10] liveupdate: centralize state management into
 struct luo_ser
Message-ID: <aheB1qJbwyGhQ5wj@plex>
References: <20260514222628.931312-1-pasha.tatashin@soleen.com>
 <20260514222628.931312-2-pasha.tatashin@soleen.com>
 <2vxz7bor78zw.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxz7bor78zw.fsf@kernel.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: wq4a7k9yek7tdjunpsikm31xhiwweb9k
X-Rspam-User: 
X-Rspamd-Queue-Id: BDDECC000F
X-HE-Tag: 1779998042-634760
X-HE-Meta: U2FsdGVkX1+4ppv0MVyziLP8nCLUdNURqOwXDffVk7D3UPLuGr2jKULhACLQEB5XEeflhym9VQZ5nQamtM3aynEo6n3Gvpndw9vt3nHhJFZTOkXkaPVpBU382wvH4sB7JtebPMd1i+lwPlYKL0m3mTeUOHiC5b2qinokZDy8+CQEdQEJZ3FOr9YUGHh1V8niYH5EvpUeXAwa7MMUIMbj74CqrNEdOm5QwNeYIHqKevOjkuTgs+cX1O3B1uXKCUerpFx81cgyCkEAL8n4g59j17Xb2V/bxzU8X4eWgY2xI0eNnBI9+2HRTskBGqt2n0rvKBjpezmeCgar4v8JgjtKssUrFbjq3dSyvgNAi/JUiNfr1zZsmNxbGpLmmddmpKiByRzjxBig+/FLfYZddZfweMp9Hru+ccpbMOO7ywAjQ86NH4IH5g7x7ZH8y789DNEqsbqWsrGolCzBAwsXPWZiMHXB1tAEn96TSmtCMKNNHeT8ePLOCpjfcN+JOBFUHjwAUpEwSltq7S/NzxaoF/3lmvsr96i901XhVRlGfD7osc0jjfoS1o/8B71M3WPz7mfVtUCA2HtDLobbqo/qUQORokReW2Htw7IXO30dmphNMa/jupnQ4CtCqqTM4tuwzYe9PLeY+elljNOBDRJucWVWNs5bo5Yqqlp98i70bwX4B/OwUzzMrEKh/A5k/Aq3yqhXiqhga7tzzq4bSE5cRxjN6/Hab29o3Cdh+2JkSM0avUoEdH/7Z9ljiGQsiIDLaYVkFTLtsU4l5RkAQLP2C2WqAoFnYH9vsFud+W8gnx6vllxwAmBRjI+v8mXqEziVqsKKDUCEsK3kPIR2PHfuSRfeU4q+q7pV+8aRDdT5fUzNUhEWSXi1BCMUKUlzeQEFMi7eSq56cMs804K4yGdxF885Mvoz3YbjTa6aXIag1nZcfhQN7IzHcsis4k6K6IecFOdeqfmb9U00YWE0HfB8oPE
 QrbFy/fW
 Ag/OPu/hPCnylp2DjG4DGJb3rttbGNHAVeLBcxcp1pi48WqSnaZcK979TyH3OmzkhZkgIO8jzQtEq5tg1MahSkDlkMEsYL3KaBQUaf3fDUSuaos8qCRIg22G27vDrgmmJcy4PtSBBwdrJx+d9XLq36tlsq077EsMua4J4qrX5TqrzTNuowg/bA0DVE0mMUtNnaR8ZLvfCIBPq4fCc99T0l/FBN4uUNMUHJVPR7dfYMvPm7Vc9xdBoY9skp7s5q0waxj/fwxjUeRLOg/sSiI4bKKl9O59WWPVsfT41+84BIMGtQEcopO5nErH5ZSCCkYJRViP7Sg8sd9Ig9s9qXrktCyO5Oq4yJsjupSKsYCbTbSKxxIWVcTG/tLUckLiitoNsAQGijhnFXNbGUZDSN+cipYMkUm6y2zZJI6XEiV4qUjQZhQ3xFZ6nb+C41Kk2DCQnRkGhdQkhSNXhtLDw/YgoW+OwScBw5soHgzVYuj8WZ+3mW2MOuEU2o3bnQL8exwCE74+QneP7WI1gzP6Doa046SK+oRU7nKIKeyf71CS56ovs20mN1GifAhwTX90OmQBGEVs6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-25 18:24, Pratyush Yadav wrote:
> On Thu, May 14 2026, Pasha Tatashin wrote:
> 
> > Transition the LUO to ABI v2, which centralizes state management into a
> > single struct luo_ser header.
> >
> > Previously, LUO state was spread across multiple FDT properties and
> > subnodes. ABI v2 simplifies this by placing all core state, including
> > the liveupdate number and physical addresses for sessions and FLB
> > headers into a centralized struct luo_ser.
> 
> Makes a lot of sense I think.
> 
> But nit: this brings about a semantic difference: now sessions and FLB
> serialization format is no longer independent of LUO. I think that makes
> sense but can you please spell that out in the commit message.

Added.

> 
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  include/linux/kho/abi/luo.h      | 91 +++++++++++---------------------
> >  kernel/liveupdate/luo_core.c     | 59 ++++++++++++++-------
> >  kernel/liveupdate/luo_flb.c      | 65 ++++-------------------
> >  kernel/liveupdate/luo_internal.h |  8 +--
> >  kernel/liveupdate/luo_session.c  | 57 +++-----------------
> >  5 files changed, 93 insertions(+), 187 deletions(-)
> >
> > diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
> > index 46750a0ddf88..1b2f865a771a 100644
> > --- a/include/linux/kho/abi/luo.h
> > +++ b/include/linux/kho/abi/luo.h
> > @@ -30,52 +30,25 @@
> >   *   .. code-block:: none
> >   *
> >   *     / {
> > - *         compatible = "luo-v1";
> > - *         liveupdate-number = <...>;
> > - *
> > - *         luo-session {
> > - *             compatible = "luo-session-v1";
> > - *             luo-session-header = <phys_addr_of_session_header_ser>;
> > - *         };
> > - *
> > - *         luo-flb {
> > - *             compatible = "luo-flb-v1";
> > - *             luo-flb-header = <phys_addr_of_flb_header_ser>;
> > - *         };
> > + *         compatible = "luo-v2";
> > + *         luo-abi-header = <phys_addr_of_luo_ser>;
> 
> While you are at it, perhaps also get rid of the LUO FDT entirely? With
> this change it only holds the compatible and a pointer to a blob. Might
> as well move the compatible string to the blob and use it directly. Do
> you see any benefits of sticking with the FDT here? We have already
> removed it from memfd for example (and AFAIK the upcoming PCI and VFIO
> patches also do not use it).

Good idea, let's remove it entirly, I am going to do this in a separate 
patch.

> 
> >   *     };
> >   *
> >   * Main LUO Node (/):
> >   *
> > - *   - compatible: "luo-v1"
> > + *   - compatible: "luo-v2"
> >   *     Identifies the overall LUO ABI version.
> > - *   - liveupdate-number: u64
> > - *     A counter tracking the number of successful live updates performed.
> > @@ -109,13 +82,26 @@
> >  
> >  /*
> >   * The LUO FDT hooks all LUO state for sessions, fds, etc.
> > - * In the root it also carries "liveupdate-number" 64-bit property that
> > - * corresponds to the number of live-updates performed on this machine.
> >   */
> >  #define LUO_FDT_SIZE		PAGE_SIZE
> >  #define LUO_FDT_KHO_ENTRY_NAME	"LUO"
> > -#define LUO_FDT_COMPATIBLE	"luo-v1"
> > -#define LUO_FDT_LIVEUPDATE_NUM	"liveupdate-number"
> > +#define LUO_FDT_COMPATIBLE	"luo-v2"
> > +#define LUO_FDT_ABI_HEADER	"luo-abi-header"
> 
> Nit: If we do go with FDT, I suppose "luo-ser-pa" (or "luo-ser"?) would
> be more descriptive?

I think, this is a good idea to remove FDT.

> 
> > +
> > +/**
> > + * struct luo_ser - Centralized LUO ABI header.
> > diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
> > index 8f5c5dd01cd0..7ccc59981297 100644
> > --- a/kernel/liveupdate/luo_flb.c
> > +++ b/kernel/liveupdate/luo_flb.c
> > @@ -159,8 +159,8 @@ static void luo_flb_file_unpreserve_one(struct liveupdate_flb *flb)
> >  
> >  static int luo_flb_retrieve_one(struct liveupdate_flb *flb)
> >  {
> > -	struct luo_flb_private *private = luo_flb_get_private(flb);
> >  	struct luo_flb_header *fh = &luo_flb_global.incoming;
> > +	struct luo_flb_private *private = luo_flb_get_private(flb);
> 
> Nit: this doesn't seem to do anything. Is this a stray change?

Removed

> 
> >  	struct liveupdate_flb_op_args args = {0};
> >  	bool found = false;
> >  	int err;
> 
> > -int __init luo_flb_setup_incoming(void *fdt_in)
> > +void __init luo_flb_setup_incoming(u64 flbs_pa)
> >  {
> >  	struct luo_flb_header_ser *header_ser;
> > -	int err, header_size, offset;
> > -	const void *ptr;
> > -	u64 header_ser_pa;
> > -
> > -	offset = fdt_subnode_offset(fdt_in, 0, LUO_FDT_FLB_NODE_NAME);
> > -	if (offset < 0) {
> > -		pr_err("Unable to get FLB node [%s]\n", LUO_FDT_FLB_NODE_NAME);
> >  
> > -		return -ENOENT;
> > +	if (flbs_pa) {
> > +		header_ser = phys_to_virt(flbs_pa);
> > +		luo_flb_global.incoming.header_ser = header_ser;
> > +		luo_flb_global.incoming.ser = (void *)(header_ser + 1);
> > +		luo_flb_global.incoming.active = true;
> 
> Nit: Not getting FLB data resulted in a error print. I suppose we should
> keep that here as well.

This is no longer necessary. Previously, we relied on the FDT, which 
contained its own errors, but since everything is now passed through 
LUO's own struct, there are no errors to parse through fdtlib. The 
absence of flbs_pa indicates that it was not preserved by the previous 
kernel (i.e., there is no flbs).

> 
> >  	}
> > -
> > -	err = fdt_node_check_compatible(fdt_in, offset,
> > -					LUO_FDT_FLB_COMPATIBLE);
> > -	if (err) {
> > -		pr_err("FLB node is incompatible with '%s' [%d]\n",
> > -		       LUO_FDT_FLB_COMPATIBLE, err);
> > -
> > -		return -EINVAL;
> > -	}
> > -
> > -	header_size = 0;
> > -	ptr = fdt_getprop(fdt_in, offset, LUO_FDT_FLB_HEADER, &header_size);
> > -	if (!ptr || header_size != sizeof(u64)) {
> > -		pr_err("Unable to get FLB header property '%s' [%d]\n",
> > -		       LUO_FDT_FLB_HEADER, header_size);
> > -
> > -		return -EINVAL;
> > -	}
> > -
> > -	header_ser_pa = get_unaligned((u64 *)ptr);
> > -	header_ser = phys_to_virt(header_ser_pa);
> > -
> > -	luo_flb_global.incoming.header_ser = header_ser;
> > -	luo_flb_global.incoming.ser = (void *)(header_ser + 1);
> > -	luo_flb_global.incoming.active = true;
> > -
> > -	return 0;
> >  }
> >  
> >  /**
> 
> > -int __init luo_session_setup_incoming(void *fdt_in)
> > +int __init luo_session_setup_incoming(u64 sessions_pa)
> >  {
> >  	struct luo_session_header_ser *header_ser;
> > -	int err, header_size, offset;
> > -	u64 header_ser_pa;
> > -	const void *ptr;
> > -
> > -	offset = fdt_subnode_offset(fdt_in, 0, LUO_FDT_SESSION_NODE_NAME);
> > -	if (offset < 0) {
> > -		pr_err("Unable to get session node: [%s]\n",
> > -		       LUO_FDT_SESSION_NODE_NAME);
> > -		return -EINVAL;
> > -	}
> >  
> > -	err = fdt_node_check_compatible(fdt_in, offset,
> > -					LUO_FDT_SESSION_COMPATIBLE);
> > -	if (err) {
> > -		pr_err("Session node incompatible [%s]\n",
> > -		       LUO_FDT_SESSION_COMPATIBLE);
> > -		return -EINVAL;
> > -	}
> > -
> > -	header_size = 0;
> > -	ptr = fdt_getprop(fdt_in, offset, LUO_FDT_SESSION_HEADER, &header_size);
> > -	if (!ptr || header_size != sizeof(u64)) {
> > -		pr_err("Unable to get session header '%s' [%d]\n",
> > -		       LUO_FDT_SESSION_HEADER, header_size);
> > -		return -EINVAL;
> > +	if (sessions_pa) {
> 
> Nit: same thing about the error print here.

ditto.

> 
> > +		header_ser = phys_to_virt(sessions_pa);
> > +		luo_session_global.incoming.header_ser = header_ser;
> > +		luo_session_global.incoming.ser = (void *)(header_ser + 1);
> > +		luo_session_global.incoming.active = true;
> >  	}
> >  
> > -	header_ser_pa = get_unaligned((u64 *)ptr);
> > -	header_ser = phys_to_virt(header_ser_pa);
> > -
> > -	luo_session_global.incoming.header_ser = header_ser;
> > -	luo_session_global.incoming.ser = (void *)(header_ser + 1);
> > -	luo_session_global.incoming.active = true;
> > -
> >  	return 0;
> >  }
> 
> -- 
> Regards,
> Pratyush Yadav

