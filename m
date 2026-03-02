Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CDE4EB3624
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 17:52:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51D766B0005; Mon,  2 Mar 2026 12:52:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CBC96B0088; Mon,  2 Mar 2026 12:52:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 382FB6B0089; Mon,  2 Mar 2026 12:52:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 28CD16B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:52:10 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B49781A0143
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:52:09 +0000 (UTC)
X-FDA: 84501866778.14.0F4B43D
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf22.hostedemail.com (Postfix) with ESMTP id BE8A5C000D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:52:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=M5vfQk2I;
	spf=pass (imf22.hostedemail.com: domain of yuanchu@google.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=yuanchu@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772473927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JeAtXyC2xxcdhbnrWXYaW7SgXu8zti6cy+tsnUhW0PU=;
	b=4RVnQuIqAviw0VTfnVMjKfH759nlmg+JvUK8i48JPyAURDhYD1sMBIjMfnPToJWFpnzKyr
	83hDQ9dUUaRnEsMo9b1N52Vvl+tQySmmHU6DvmY2ARinl7pkDujlGOsANHBT4p1q6Ctb8v
	mBCJm5IOAIwAiGqXKBPGcGkLtmlYqeA=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=M5vfQk2I;
	spf=pass (imf22.hostedemail.com: domain of yuanchu@google.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=yuanchu@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772473927; a=rsa-sha256;
	cv=pass;
	b=CwJK2DmG9vxhoGf1MhjoIsPd/8GPhVuOgmS+z6MtjWGmHfmRGPuP/flUOdS4PYNw/bk25N
	p5h+JkNd1vBWMu1/rsWS8pOvhQM+WtTgMl4ck9182cZaTknaBF61FxCzbNPYgXA1VsGN6P
	qPYS1RT+PVYn1hDX9/J260BDe5/B6d8=
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-124a60cc9a1so281c88.0
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 09:52:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772473926; cv=none;
        d=google.com; s=arc-20240605;
        b=NhuFxtHb8/O/FbUp0ML5T3UoGyvt4YdcRFvypHsPpCB0JtHlsmPDRedyfNtCT3IkE6
         mEMthKbunuxYKsQ/99/vRWz+I2v5Oo7Di6oXZ8KvNg3KqGCTz39Ji+OgVA10MZY+lsUn
         G5wBei5EOG4voXnBhqerHqbigLO/CzKwsUanvSU1/+Dm6OC+P+cNFb1I1wXxIfm4OPLy
         UqfoDFH2LaZDTrCtMfk8g/JqDSjF85cnxnvHP5M3yjf2MqA/JWzmi0+NHxOX/tMsBb6t
         OMFUC4vjioZLU/Db/OsFTBOH9coNvgc1QrH7zgR5hP5rfi2W9LOmBz5sqkSdU53tNAGB
         u1Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JeAtXyC2xxcdhbnrWXYaW7SgXu8zti6cy+tsnUhW0PU=;
        fh=ZFpeBNg+w9nbM8lGHFnH903wCvIyTWi4PC6VM7oBA6c=;
        b=hTqeFFBGXoFkQXCBX9Qc5ezUZBIS1EWiljJmdjseXztoXg1GXYCDhpy75OukiS+u0Q
         80/ulELTMpA4pRzeOL5NXOrj57L2p9srqijUOz7xOxPiTU59kd8QosHJjXGRiiv9bt2V
         AOW7zEMZ9kfGI2NHh2PXbJOzyFtnlUKlnioulzDtEtv+fSqdio/IbclVMvPuVaIqP61g
         z7ZlX87OL7Ru2Bu7mu1aV0B5ToOKjC04wcs9NacbnJboKgT4dnZMXgNOIJKbkmtX7y1e
         8rVa35a5YUSmGnm3JgNgRWSQhTCQVmrvLZuiv3e9sj5yIZ8H7RnGZzSaZsWNV0808JCx
         1SLA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772473926; x=1773078726; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JeAtXyC2xxcdhbnrWXYaW7SgXu8zti6cy+tsnUhW0PU=;
        b=M5vfQk2IouQ1bZVdosYD+MG5GDS5nOMQ+ENMtVwHwQQpb9l7D3vBCCs4CCjxpvB2sQ
         Jb6RzF4I1V8NcF/WyFDjw5EInMSlXG8uRNbMx8pxUrfwFeEyO50X51FHnIFEMn9j+DMl
         8JeVqnc/d0u3kLVYJnF6vlcW7ovFKtIu7NDShJMWvJRfv5NvmdboFgA5WMc9ENOy5OTS
         BtbaBDWMIWlreW7sWGvMgeIsnOlzwd0cyF8fk03FCF6jjd8ylKvTsXdb6lZLnYusIwUZ
         KdxhQ0s7pVFofb+1yOqntTzWTIxhUM+UDlUZL1xGFxkjJRaBakQYF/I5Mmig3AGDqgQ4
         TD0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772473926; x=1773078726;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JeAtXyC2xxcdhbnrWXYaW7SgXu8zti6cy+tsnUhW0PU=;
        b=o70xFPnsiNWt1ulP1Q2TCRjtRx9AMVjI/unq+gCU5XhdFT7V9OF9thOd0jgTBmUQVW
         vHZ2H6jEeLlvV3M2iUbS/85peyaM3WdWUElwEB2jQQ8FLK8sk2J7bIfbzb6Q31IptVq1
         PRL0KPRI/mdxjyRFYg/BJcH+jnv2zyKe+sqbKOQgUL9MS4O065SJcgeB+HAq/e72LDwh
         0IwYx/5v/GN+ccuOgt/4NXsg/dBL2w/XFbv1InoxOuaBjIr48dPbFKidCCPNdxJ6OR+Z
         PnsLwvji5KGRVKn8c1rTAhhuTBhZxoeidEU8ia7ItI4BozxU+EbEtEpqdptORp2QBFbc
         1hoA==
X-Forwarded-Encrypted: i=1; AJvYcCWAtUpU8F82U8bAAOyS/EjQhgt13HlsUvke1GJYCTrDdNO3gZbS83fZtRnBIEcrTQGdNXVyOiTvoQ==@kvack.org
X-Gm-Message-State: AOJu0YwL1D1HYZ/YCZ34f2hXwyn4dOxU8quO7650Z9ra++XPe6g29bWF
	RqahSDu8qbjB0d6jiwUpWAoOA3SixAixYEn0gvit75vntA+Uaa6xT3A+Ew0znhXkLP3MJXWuYTe
	UMEpXM1NXtKLDfcC7bqOLxGmrO1q24ceikNcNsaDK
X-Gm-Gg: ATEYQzz5QoZE72OWtoM95MSsgpG1mCW1RBuz5ztK/XZGAUZbbNW+Y3l7hxWmYkGyMzW
	Nw5+MdahyAcOMkXXHo7NDGzGJ6cXkOvZ0ks1eBu2Asbsbj36Hz08F+4LyKxtyzronQTAlyaNzEM
	Swt5Ob97rLRnd9V0Y56LP4cWGuXfi4O5J6iPWvjsE+BS/Ssl6LZHtvmLIxaFgd3XcMS2COqn4pz
	7f4s3MnK5vwFMnVKEYFINEdgsx5K/rrIly4tjUYyUGLtmBVpnOarS7CzRudGpzWu/CO1rDVL17F
	U7DJu2o=
X-Received: by 2002:a05:7022:458b:b0:122:8d:4740 with SMTP id
 a92af1059eb24-1279626a0dfmr291843c88.16.1772473925637; Mon, 02 Mar 2026
 09:52:05 -0800 (PST)
MIME-Version: 1.0
References: <20260228161008.707-1-lenohou@gmail.com> <20260228212837.59661-1-21cnbao@gmail.com>
 <CALOAHbBKr5ni=Ap2ASq2hx041WAghd+CzqbXGBSFPExBMJzcUg@mail.gmail.com>
 <CAGsJ_4xA3tApXCs2S-sZh2qA9RK_1masQ7nb1NYyCHXwnP9FAQ@mail.gmail.com>
 <CALOAHbBRBot0EXmzPNb2zpgC2GV5NfnzAZuosTb-iygjaw3U=w@mail.gmail.com>
 <CAMgjq7Bqb0M4bjCeaxjAgaB-Kj_kWKVjMMNdG7528w+uTwGnjg@mail.gmail.com>
 <CALOAHbCma=SW4nu_GPv_pbuuXv1V5JPB-9cA3z1TeemWqU68tg@mail.gmail.com>
 <CAGsJ_4yAkaqqzSu7SS=_fgZ_AQCqtbv8LmuPGCb7SiFpGk4csg@mail.gmail.com>
 <CAMgjq7AkvgzW96-JQzEg5c4oW0cMsjPHcCnukCUZXgSvXL4-DQ@mail.gmail.com> <CALOAHbB3rQ2b7ABqFegt2afYRL7KjpWREucrhOYfTT=onV1+Gw@mail.gmail.com>
In-Reply-To: <CALOAHbB3rQ2b7ABqFegt2afYRL7KjpWREucrhOYfTT=onV1+Gw@mail.gmail.com>
From: Yuanchu Xie <yuanchu@google.com>
Date: Mon, 2 Mar 2026 11:51:48 -0600
X-Gm-Features: AaiRm51vwBb4l0rDcf62TpR46POKkCXUAeQ1xav_MH5AAcx--YktyDGujdzPs-w
Message-ID: <CAJj2-QEO=9Nt+HP6m=xtFD8qcXCdGCRmESmcs0haeiMdqqTA1Q@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: fix cgroup OOM during MGLRU state switching
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Kairui Song <ryncsn@gmail.com>, Barry Song <21cnbao@gmail.com>, bingfangguo@tencent.com, 
	lenohou@gmail.com, akpm@linux-foundation.org, axelrasmussen@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, weixugc@google.com, 
	wjl.linux@gmail.com, yuzhao@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BE8A5C000D
X-Rspamd-Server: rspam07
X-Stat-Signature: rk6qmkz7xc7psuih63jz1r68rb6mid48
X-Rspam-User: 
X-HE-Tag: 1772473927-329526
X-HE-Meta: U2FsdGVkX18UVT88z6Nj903djZjOcB4UESB7te+WKUJIFpLUwV3CUbn/QyMN5z8zi/roKHUJuW64OaBED/ier54sOQecdRGCpviQrAi7WDp31uobqgfclIHahFAdKTAKP78vxqvDOnRqWZ+aNdqXpMccCHWyKUqiUW+vynl/dK94M5Glok8DB600tVcuF6SpgmZHb2wETicS62cnyhGXc2QXHYAYtEgICPW8XpS0Z3PK8g4d5uCYzLa2i4MCcMKwPaQ2M32UfziL0OAPIQ05++NJYNEwJndzUn1mm0wwlyxORIJ5GjMfwqNgn5PB/6MbdaHK3hYR+nYUOLq3HU96V7oA6/Wtguf29YUQBTJ0bkb71jwURZwtlckPWgLy/YzC6awVeChsg1CozMpNs0S0ruTorgsMiFDOnx29gRZiEg3uWWLpaxDSAoWmMhE/Y44vnnDbtbJWZoIGsiymLLc+/u/5CJnz5I8hdsAH7ohp7RDbSWR8XrvDi4nVorZOJvOGOjQCKtw3GqIg7lWQBAxwGeRTJXJQxmcR+un2cOyaHay910iKFIZtKVW3yUUPkeHsglCmxEKAAzMZhUXnsNspDtOvzTuHMl5yz0TW7Phe7GsDqcP/cpqVRh3UVV+yVEFxwLkGCLtS/hngecgk8TD/h7Uf6Rr3TRpyQb66XeFwjokCCTncJ40crBIk9X5Avr8/Rd1CC4rkwnTaaP2zVyMoPkSxznlv72ixokz26nS3AnL8P72BibenVds3YO4lj+dlmSYTOwZ65B8eyr6Waw14C9QTwOPDTzup2727H+qlpZI8gn6yrewCZmotRpvg6eBRbjcRM185eci9ptM1mHkSyVjrs+wzw+uGX606uNGB8KeOiyS9Mi4ELT/m6RwSDklK2AktwD8PeK/MbT+jmaNyq1AuwlXv3uyKPmM6tM58BQ+Cqws6y3AHpqRt0HiokceFe8pPBFhpv+i0RXv5VwV
 x9udBTkj
 I8bzPfdswSHR2TaUlMJ9yJHeTAwoMaiNL2bt7iqtKxijTQ0luyFk84v0AzvJJlXx/Wmi8aXT6q2RLG1vLVVA//oI0ogcRo1FmSRU38v9Vdfhi2Sa48poka9KiIEw/TOa8Fy3WY9TqaiJ4UDiR3IzqoTKY3VXzaS2JHdkRrrC/S7OLk9fEAcvo5OcPZqhmzY6aOG5Kf2y3sbYHEcYSRbatQnG6neVyJTWR/whNgl9r2G1uQa57CPIMEK5fkqqbxqaZnq08GDtEBM7V2OyvO09Bu4bIqFfxI7XhAbYNmo/SgtFZSoG39YKZVIes4KSrhiM0rVG9/6Q1k9xsGlkXXveCOISedjQeiDOJ7DE4iEGZ1E8VarQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yafang,

On Mon, Mar 2, 2026 at 8:36=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com> w=
rote:
>
> On Mon, Mar 2, 2026 at 5:48=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wro=
te:
> >
> > On Mon, Mar 2, 2026 at 5:20=E2=80=AFPM Barry Song <21cnbao@gmail.com> w=
rote:
> > >
> > > On Mon, Mar 2, 2026 at 4:25=E2=80=AFPM Yafang Shao <laoar.shao@gmail.=
com> wrote:
> > > >
> > > > The challenge we're currently facing is that we don't yet know whic=
h
> > > > workloads would benefit from it ;)
> > > > We do want to enable mglru on our production servers, but first we
> > > > need to address the risk of OOM during the switch=E2=80=94that's ex=
actly why
> > > > we're proposing this patch.
> > >
> > > Nobody objects to your intention to fix it. I=E2=80=99m curious: to w=
hat
> > > extent do we want to fix it? Do we aim to merely reduce the probabili=
ty
> > > of OOM and other mistakes, or do we want a complete fix that makes
> > > the dynamic on/off fully safe?
> >
> > Yeah, I'm glad that more people are trying MGLRU and improving it.
> >
> > We also have an downstream fix for the OOM on switch issue, but that's
> > mostly as a fallback in case MGLRU doesn't work well, our goal is
> > still try to enable MGLRU as much as possible,
>
> Our goals are aligned.
> Before enabling mglru, we must first ensure it won't cause OOM errors
> across multiple servers. We propose fixing this because, during our
> previous mglru enablement, many instances of a single service OOM'd
> simultaneously=E2=80=94potentially leading to data loss for that service.

Would it be possible to drain the jobs away from the machine before
switching LRUs? The MGLRU kill-switch could be improved, but making
the switch more or less "hitless" would require significant work. Is
the use case a one-time switch from active/inactive to MGLRU?
I do want to note that OOMs causing data loss is not really the kernel's fa=
ult.

Thanks,
Yuanchu

