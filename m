Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E962CD2CE17
	for <linux-mm@archiver.kernel.org>; Sun,  7 Dec 2025 06:16:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D3726B0005; Sun,  7 Dec 2025 01:16:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 983616B0006; Sun,  7 Dec 2025 01:16:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 899946B0008; Sun,  7 Dec 2025 01:16:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 766A46B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 01:16:49 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C12AA1405E1
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 06:16:48 +0000 (UTC)
X-FDA: 84191666496.18.7C252DD
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	by imf22.hostedemail.com (Postfix) with ESMTP id E6CD9C0002
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 06:16:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fAYpsIbV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of avagin@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=avagin@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765088207; a=rsa-sha256;
	cv=none;
	b=ZHR1kqB2tzpQZmiPWAsMSJuZk9qZFAHknZAtcR0muQW1qCamX9TiyPNRNAQlyGEmN0RtAD
	aWHgmCQDy32FyHwjZrayUh3veEaWCIPCzbHQTxsSWPMpqjLJOeO5LOuGkXUM2tSmTMdJwB
	BLXzeCbPY0eQvV1wM3iUQnLMcqcAW+0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fAYpsIbV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of avagin@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=avagin@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765088207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Un5sUc5Cx47cq3O9cSCtpokOGHVUQEIffWJ4oCrfNps=;
	b=23mKxyskD8NHzSowajXYMohTahNj7vy7lTdcUcW6Ti5FgrALtArYXY+Z+3oYrud4NvYaWR
	ppKZhmgiQ6V6Tq1YEFB8fB4j0nXeC5ZNNwKOubuM+/KfZtoZmUTjzqnAZjyVnOTK6Pp7CJ
	gP7X/uPBjPdl/Cs2fSmNk/Nz88lAvkc=
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7c6cc366884so1783423a34.1
        for <linux-mm@kvack.org>; Sat, 06 Dec 2025 22:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765088206; x=1765693006; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Un5sUc5Cx47cq3O9cSCtpokOGHVUQEIffWJ4oCrfNps=;
        b=fAYpsIbVbiQM4fSA9sh2VU7D0oWqIIjyQD8VkpY+eqf13xIsHClQ3eCOwP6d1FrBbL
         uCf2fSktSgDE5UgIab5lbvFkz8zhrzB4tE8alyUFIxhSWCBfFKKP0qOwBspH56KntAVt
         HrAjaPgJ39Qo0A3EnvBZzP9Wzp9RL0cn8rT1IQk9rpA1jiKIb7G6uRYCP1zxZMJORq9R
         LVxGCDKkyRpTGDpdUBJsY7zvPB4wUwsV0pQrUMwWVOJaETqPTZjlbeQGoodwc572UvQk
         FLQ0uVwG1Gvt2KBaVwI0sH5vseWj05wPOpI0ik3xv/5I8UNEtz8DY6T14DFvI+ZBY6oj
         E4fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765088206; x=1765693006;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Un5sUc5Cx47cq3O9cSCtpokOGHVUQEIffWJ4oCrfNps=;
        b=qHjBvjfG+yh+/lXu+rsDTZeeeiQ8flxUbL/jJHoE0B5aDlRYI+WNZ+WOy3R9+HAgy7
         +zHyjOH8yoQOSyzaxqsWjSLRdq+lyCRlBH/rBrB98JbKCalUQPiu1w+iG03Mnz3H5TKT
         sjVmZUjUPUvhYAAuwOfYq/31WlrjglclWW8/p/YawAPMlfOREr0QbESQS2HyG7+9FXer
         YhePeFJbsjCau3QfzuTdDsnbz/1xUvTQLO/h0NY84RdIcWhCDPUCvKGH177IwdlyWNdE
         h/Um8ibllcInNFruTjCGz8F6rTq5PeFCEsx9LuJ44/1lA9XIYCr+utuu9i3M4xtwuMv6
         eNpw==
X-Forwarded-Encrypted: i=1; AJvYcCVWFDCj9pytHslyTscNRDYPKW1CR69z1Mf2oaz45acZeIiJAVV6PlQzPrCCMxqOggPr3hDnI/OwLA==@kvack.org
X-Gm-Message-State: AOJu0Yw3sh+EFq2nt/i6kJFCThczEb3PZ93JbCfhxn1usyuT+ebJ+a7Q
	v8xC6oBM//WpO4etd35SCp1bYKA3P/6HyFvi98RQSiwZauR5zavZdLmsXVhYFyWXwMoK6qohA9O
	SoD6lEMT8IRNMQJRht/OXlwO2+Vyt5g8=
X-Gm-Gg: ASbGnctxKD/Sa41wYJgx4EgCBOJJnm+ZVhJiFCVaDgpC3T6P0u6nZayRjd2PT7iBxbU
	BvlA6J8XgjdhiTignDNU+YE4Z8bRyJoRrXB0GVCIMZoofv04G3eSubWu8Qlfmr4yBsi83zgxvK1
	i329wguThkBFVpQAk8wowr43Or6NdXeCvmlCaoTb2ZRxLijNiD9npyhvzyH2d/iIsYRsq0qYozf
	/sxMBMbxC8ik2Jrty1XfFMB3k1o4X695Uk2Srfdbag85UjU+Lmo1cC80kCBtRHKpm+cXSt4
X-Google-Smtp-Source: AGHT+IGTU11em87jeAo6kbD6dSOQffzi00PVFHQ+kjvwjKAEFHYJNasF5rV2kwcoj4CItjdfPWuUhV4Bdq+BX91kfOI=
X-Received: by 2002:a05:6830:3153:b0:7c7:5385:9ac2 with SMTP id
 46e09a7af769-7c97078be65mr3441356a34.8.1765088205704; Sat, 06 Dec 2025
 22:16:45 -0800 (PST)
MIME-Version: 1.0
References: <20251205005841.3942668-1-avagin@google.com> <20251205005841.3942668-2-avagin@google.com>
 <25cac682-e6a5-4ab2-bae2-fb4df2d33626@huaweicloud.com>
In-Reply-To: <25cac682-e6a5-4ab2-bae2-fb4df2d33626@huaweicloud.com>
From: Andrei Vagin <avagin@gmail.com>
Date: Sat, 6 Dec 2025 22:16:34 -0800
X-Gm-Features: AQt7F2p7RekYLuKI-hKafG4DE8Ti31OsLl4BdXgEl5swhlVsRR3s_ZW5SSZKSRw
Message-ID: <CANaxB-w+j89zVRpwVErT8JdrmKZqw+D7ANZBzk2pA2WCj75XPA@mail.gmail.com>
Subject: Re: [PATCH 1/3] cgroup, binfmt_elf: Add hwcap masks to the misc controller
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: Andrei Vagin <avagin@google.com>, Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	criu@lists.linux.dev, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Vipin Sharma <vipinsh@google.com>, Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: xggbe8mnc1dwoyudje1rzid8c5ypq5jr
X-Rspam-User: 
X-Rspamd-Queue-Id: E6CD9C0002
X-Rspamd-Server: rspam01
X-HE-Tag: 1765088206-727935
X-HE-Meta: U2FsdGVkX1+A1scXJA/eJGNONdo5wIWhBoesIpzJ2e4oyVkj5Ftq9b9lBd3mxrYw2MQ01AV7/ZIu6bsH3rTnEP9H3qAs8mCDGpj7g8HBRlReHkQHvNchCbZ20vDiR60N0FPkI+e5REyScha5gTZNrfWt/tLgESba8o7AU2u6SE20AefoKiB+Wug81Uh2lmW6Lv7UAeK6qLeXxk9jgVbi5gBwCgFq19l5tdh9hS0NJSTjzpB1RgI8ObdI/j9MIwA0ot1N2gmk7+HdRlwDbDJ0SUv+N0EtDYiLhf+NDQ7Hz8pS+xamjnk6AWqlqnKoYUgTU3SK21WQxhbcIIYSsyVLTGu7WzVyhej/b+rvoCiIP3F9EeOWf6cnNkBBHn8WvEDK9yEGHqpsbnMuLfNqLxe8VcHOoYLfN1qLvodYt0TPhzP2OKmEt0ImYfD54YlsHexMuDE1UYiQloQChWK1+hwRIYo8ekOte0MYMsQ7nT30RxdqHoW3OGNJIqmOTQUu1xkEEC7JPoixAdgp9bUrFvvBR9ekNbIOJhVKFFsk2T9eqJxIBDhaChccuXz5eeC7LG0rceBim7VVfnGfh2sw5SeQF4pwzxUXb9nBVKoWPUJnd1kxsYLABK17OHz51KOZl7NBKrSdKqGSN9XMqV42bXgunjSTaz1HxF7nQAs99wRxfIkSGsPgqM/pr0DzpmJ1Dsl9nuGgHboJv1wktepA7ii/cfcgA2XT+i25V4jM5jT2AlBVE9WCk8vmt1NTpHIZHzOySgbix9XLzyd5BsRJgfOKpOWSrT0omsw57TjHAupc4qUHLWqUoYQye0xkQ7KXFKpq6NpvqGvS4wMwxjLfIYCcfe9LAUSimzoAtcBdPoUsjCEAKerQqDVzBmoU5c3wYKD3xc5P3CfXmIDfzDOaQTViV+8zKO2zHGR8P6YLcjlnRbQgTveMj2+TSnYw9a7KCXaEE3gYDFZtbiKMA1ceXVu
 VX1L5xO5
 3DBmM1EfARYMElULF6CzkpT5URfg5ygK6cRsr+dtxWFwZ0gmmN9keSDbIdGr/OGORed+GX9eGrQIh8TM949kpP+R4YuoEpa70ai7JwXO59nJcM9CMeWODLVATRoziODlXbUOWTY5+WdgEvwz2pPrLOEUGVehwL6nnl2Gakg/NQyJpZBd8OePP9ftr8sojbqsfU5p1o0/rg8W+TCpC25KsijSth2LUNChVaGakvLWb3OSX3mYW3HVnOSNoPPaSbqyuhCdyoHHEYxjI83F4Shx88Df8fhP/FIq1L59nGN/Cj0ZmArZMp/F85sIpExoXY5gA6+abhsecRksoWSpjeRX5Ig8Bp0DYJRLOFFZ15NcRgb18xHRWkMZF9A4JW4DgsEisAmV2MciVqPF6UI9BjhOQVWFi1Pr8PAyTYz8kBi9e36aHiqk4OLXY6oXWiBHm+VK308vzCrA3LNYgGNDaINWcHVtsb90OZkv+yphr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 5, 2025 at 2:11=E2=80=AFAM Chen Ridong <chenridong@huaweicloud.=
com> wrote:
>
>
>
> On 2025/12/5 8:58, Andrei Vagin wrote:
> > Add an interface to the misc cgroup controller that allows masking out
> > hardware capabilities (AT_HWCAP) reported to user-space processes. This
> > provides a mechanism to restrict the features a containerized
> > application can see.
> >
> > The new "misc.mask" cgroup file allows users to specify masks for
> > AT_HWCAP, AT_HWCAP2, AT_HWCAP3, and AT_HWCAP4.
> >
> > The output of "misc.mask" is extended to display the effective mask,
> > which is a combination of the masks from the current cgroup and all its
> > ancestors.
> >
> > Signed-off-by: Andrei Vagin <avagin@google.com>
> > ---
> >  fs/binfmt_elf.c             |  24 +++++--
> >  include/linux/misc_cgroup.h |  25 +++++++
> >  kernel/cgroup/misc.c        | 126 ++++++++++++++++++++++++++++++++++++
> >  3 files changed, 171 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> > index 3eb734c192e9..59137784e81d 100644
> > --- a/fs/binfmt_elf.c
> > +++ b/fs/binfmt_elf.c
> > @@ -47,6 +47,7 @@
> >  #include <linux/dax.h>
> >  #include <linux/uaccess.h>
> >  #include <uapi/linux/rseq.h>
> > +#include <linux/misc_cgroup.h>
> >  #include <asm/param.h>
> >  #include <asm/page.h>
> >
> > @@ -182,6 +183,21 @@ create_elf_tables(struct linux_binprm *bprm, const=
 struct elfhdr *exec,
> >       int ei_index;
> >       const struct cred *cred =3D current_cred();
> >       struct vm_area_struct *vma;
> > +     struct misc_cg *misc_cg;
> > +     u64 hwcap_mask[4] =3D {0, 0, 0, 0};
> > +
> > +     misc_cg =3D get_current_misc_cg();
> > +     misc_cg_get_mask(MISC_CG_MASK_HWCAP, misc_cg, &hwcap_mask[0]);
> > +#ifdef ELF_HWCAP2
> > +     misc_cg_get_mask(MISC_CG_MASK_HWCAP2, misc_cg, &hwcap_mask[1]);
> > +#endif
> > +#ifdef ELF_HWCAP3
> > +     misc_cg_get_mask(MISC_CG_MASK_HWCAP3, misc_cg, &hwcap_mask[2]);
> > +#endif
> > +#ifdef ELF_HWCAP4
> > +     misc_cg_get_mask(MISC_CG_MASK_HWCAP4, misc_cg, &hwcap_mask[3]);
> > +#endif
> > +     put_misc_cg(misc_cg);
> >
> >       /*
> >        * In some cases (e.g. Hyper-Threading), we want to avoid L1
> > @@ -246,7 +262,7 @@ create_elf_tables(struct linux_binprm *bprm, const =
struct elfhdr *exec,
> >        */
> >       ARCH_DLINFO;
> >  #endif
> > -     NEW_AUX_ENT(AT_HWCAP, ELF_HWCAP);
> > +     NEW_AUX_ENT(AT_HWCAP, ELF_HWCAP & ~hwcap_mask[0]);
> >       NEW_AUX_ENT(AT_PAGESZ, ELF_EXEC_PAGESIZE);
> >       NEW_AUX_ENT(AT_CLKTCK, CLOCKS_PER_SEC);
> >       NEW_AUX_ENT(AT_PHDR, phdr_addr);
> > @@ -264,13 +280,13 @@ create_elf_tables(struct linux_binprm *bprm, cons=
t struct elfhdr *exec,
> >       NEW_AUX_ENT(AT_SECURE, bprm->secureexec);
> >       NEW_AUX_ENT(AT_RANDOM, (elf_addr_t)(unsigned long)u_rand_bytes);
> >  #ifdef ELF_HWCAP2
> > -     NEW_AUX_ENT(AT_HWCAP2, ELF_HWCAP2);
> > +     NEW_AUX_ENT(AT_HWCAP2, ELF_HWCAP2 & ~hwcap_mask[1]);
> >  #endif
> >  #ifdef ELF_HWCAP3
> > -     NEW_AUX_ENT(AT_HWCAP3, ELF_HWCAP3);
> > +     NEW_AUX_ENT(AT_HWCAP3, ELF_HWCAP3 & ~hwcap_mask[2]);
> >  #endif
> >  #ifdef ELF_HWCAP4
> > -     NEW_AUX_ENT(AT_HWCAP4, ELF_HWCAP4);
> > +     NEW_AUX_ENT(AT_HWCAP4, ELF_HWCAP4 & ~hwcap_mask[3]);
> >  #endif
> >       NEW_AUX_ENT(AT_EXECFN, bprm->exec);
> >       if (k_platform) {
> > diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
> > index 0cb36a3ffc47..cff830c238fb 100644
> > --- a/include/linux/misc_cgroup.h
> > +++ b/include/linux/misc_cgroup.h
> > @@ -8,6 +8,8 @@
> >  #ifndef _MISC_CGROUP_H_
> >  #define _MISC_CGROUP_H_
> >
> > +#include <linux/elf.h>
> > +
> >  /**
> >   * enum misc_res_type - Types of misc cgroup entries supported by the =
host.
> >   */
> > @@ -26,6 +28,20 @@ enum misc_res_type {
> >       MISC_CG_RES_TYPES
> >  };
> >
> > +enum misc_mask_type {
> > +     MISC_CG_MASK_HWCAP,
> > +#ifdef ELF_HWCAP2
> > +     MISC_CG_MASK_HWCAP2,
> > +#endif
> > +#ifdef ELF_HWCAP3
> > +     MISC_CG_MASK_HWCAP3,
> > +#endif
> > +#ifdef ELF_HWCAP4
> > +     MISC_CG_MASK_HWCAP4,
> > +#endif
> > +     MISC_CG_MASK_TYPES
> > +};
> > +
> >  struct misc_cg;
> >
> >  #ifdef CONFIG_CGROUP_MISC
> > @@ -62,12 +78,15 @@ struct misc_cg {
> >       struct cgroup_file events_local_file;
> >
> >       struct misc_res res[MISC_CG_RES_TYPES];
> > +     u64 mask[MISC_CG_MASK_TYPES];
> >  };
> >
> >  int misc_cg_set_capacity(enum misc_res_type type, u64 capacity);
> >  int misc_cg_try_charge(enum misc_res_type type, struct misc_cg *cg, u6=
4 amount);
> >  void misc_cg_uncharge(enum misc_res_type type, struct misc_cg *cg, u64=
 amount);
> >
> > +int misc_cg_get_mask(enum misc_mask_type type, struct misc_cg *cg, u64=
 *pmask);
> > +
> >  /**
> >   * css_misc() - Get misc cgroup from the css.
> >   * @css: cgroup subsys state object.
> > @@ -134,5 +153,11 @@ static inline void put_misc_cg(struct misc_cg *cg)
> >  {
> >  }
> >
> > +static inline int misc_cg_get_mask(enum misc_mask_type type, struct mi=
sc_cg *cg, u64 *pmask)
> > +{
> > +     *pmask =3D 0;
> > +     return 0;
> > +}
> > +
> >  #endif /* CONFIG_CGROUP_MISC */
> >  #endif /* _MISC_CGROUP_H_ */
> > diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
> > index 6a01d91ea4cb..d1386d86060f 100644
> > --- a/kernel/cgroup/misc.c
> > +++ b/kernel/cgroup/misc.c
> > @@ -30,6 +30,19 @@ static const char *const misc_res_name[] =3D {
> >  #endif
> >  };
> >
> > +static const char *const misc_mask_name[] =3D {
> > +     "AT_HWCAP",
> > +#ifdef ELF_HWCAP2
> > +     "AT_HWCAP2",
> > +#endif
> > +#ifdef ELF_HWCAP3
> > +     "AT_HWCAP3",
> > +#endif
> > +#ifdef ELF_HWCAP4
> > +     "AT_HWCAP4",
> > +#endif
> > +};
> > +
> >  /* Root misc cgroup */
> >  static struct misc_cg root_cg;
> >
> > @@ -71,6 +84,11 @@ static inline bool valid_type(enum misc_res_type typ=
e)
> >       return type >=3D 0 && type < MISC_CG_RES_TYPES;
> >  }
> >
> > +static inline bool valid_mask_type(enum misc_mask_type type)
> > +{
> > +     return type >=3D 0 && type < MISC_CG_MASK_TYPES;
> > +}
> > +
> >  /**
> >   * misc_cg_set_capacity() - Set the capacity of the misc cgroup res.
> >   * @type: Type of the misc res.
> > @@ -391,6 +409,109 @@ static int misc_events_local_show(struct seq_file=
 *sf, void *v)
> >       return __misc_events_show(sf, true);
> >  }
> >
> > +/**
> > + * misc_cg_get_mask() - Get the mask of the specified type.
> > + * @type: The misc mask type.
> > + * @cg: The misc cgroup.
> > + * @pmask: Pointer to the resulting mask.
> > + *
> > + * This function calculates the effective mask for a given cgroup by w=
alking up
> > + * the hierarchy and ORing the masks from all parent cgroupfs. The fin=
al result
> > + * is stored in the location pointed to by @pmask.
> > + *
> > + * Context: Any context.
> > + * Return: 0 on success, -EINVAL if @type is invalid.
> > + */
> > +int misc_cg_get_mask(enum misc_mask_type type, struct misc_cg *cg, u64=
 *pmask)
> > +{
> > +     struct misc_cg *i;
> > +     u64 mask =3D 0;
> > +
> > +     if (!(valid_mask_type(type)))
> > +             return -EINVAL;
> > +
> > +     for (i =3D cg; i; i =3D parent_misc(i))
> > +             mask |=3D READ_ONCE(i->mask[type]);
> > +
> > +     *pmask =3D mask;
> > +     return 0;
> > +}
> > +
> > +/**
> > + * misc_cg_mask_show() - Show the misc cgroup masks.
> > + * @sf: Interface file
> > + * @v: Arguments passed
> > + *
> > + * Context: Any context.
> > + * Return: 0 to denote successful print.
> > + */
> > +static int misc_cg_mask_show(struct seq_file *sf, void *v)
> > +{
> > +     struct misc_cg *cg =3D css_misc(seq_css(sf));
> > +     int i;
> > +
> > +     for (i =3D 0; i < MISC_CG_MASK_TYPES; i++) {
> > +             u64 rval, val =3D READ_ONCE(cg->mask[i]);
> > +
> > +             misc_cg_get_mask(i, cg, &rval);
> > +             seq_printf(sf, "%s\t%#016llx\t%#016llx\n", misc_mask_name=
[i], val, rval);
> > +     }
> > +
> > +     return 0;
> > +}
> > +
>
> I'm concerned about the performance impact of the bottom-up traversal in =
deeply nested cgroup
> hierarchies. Could this approach introduce noticeable latency in such sce=
narios?
>

I wrote an execve benchmark to measure the impact of this change
(https://github.com/avagin/execve_vs_misccg).

The benchmark results are as follows:

depth | before (ops/sec)| after (ops/sec)| ratio %| perf
------------------------------------------------------
0     | 4813.06 =C2=B1 11.01 | 4826.78 =C2=B1 19.33| 100.28 |
2     | 4752.75 =C2=B1 11.28 | 4754.38 =C2=B1 21.93| 100.03 |
4     | 4767.41 =C2=B1 8.35  | 4729.81 =C2=B1 29.56|  99.21 |
8     | 4768.01 =C2=B1 10.42 | 4745.23 =C2=B1 27.68|  99.52 |
16    | 4749.34 =C2=B1 21.03 | 4723.63 =C2=B1 23.57|  99.45 |
32    | 4758.67 =C2=B1 10.94 | 4728.49 =C2=B1 13.9 |  99.36 |
64    | 4749.85 =C2=B1 12.33 | 4686.3  =C2=B1 13.06|  98.66 | 0.11%
128   | 4707.22 =C2=B1 12.01 | 4668.22 =C2=B1 16.9 |  99.17 | 0.33%
256   | 4725.75 =C2=B1 6.07  | 4629.09 =C2=B1 27.02|  97.95 | 1.61%

Columns:
* depth: The nesting level of the cgroup.
* before: without this patch.
* after: with this patch applied.
* ratio: performance of after relative to before.
* perf: profiling data from perf showing execution time spent in the
        misc_cg_get_mask function.

The performance impact is almost negligible for cgroup depths up to 64.
Even at a depth of 128, the overhead is less than 1%.

Thanks,
Andrei

