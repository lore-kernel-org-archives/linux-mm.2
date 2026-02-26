Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52EDFFD8FE2
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 17:23:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 912616B0189; Thu, 26 Feb 2026 12:23:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BF6A6B018A; Thu, 26 Feb 2026 12:23:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C1EB6B018B; Thu, 26 Feb 2026 12:23:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 671F06B0189
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:23:36 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0399E160318
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:23:35 +0000 (UTC)
X-FDA: 84487279632.04.8CDC4AC
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf29.hostedemail.com (Postfix) with ESMTP id 110D8120015
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:23:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lvO8ppKI;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772126614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FynKKhlWalFQKKrs3ZP5yNMAhsIr6fWHYQm9TKDGe4A=;
	b=mifoXkZOm6IAId7I4tMJpqJvCRGXAmVDmNB4wk1fixYMLuFFQeHXlg7loGMRocHztiDy12
	cUzZzRDVHMyd7sKQEYFfpETynoY6rf8/lJHCq+VbqtqmXDYvxmqO7UIUQpoC5BCNEBpyJQ
	rKofdKKZq7iKAeZznPA+Tjcl9qQz2ho=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lvO8ppKI;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772126614; a=rsa-sha256;
	cv=pass;
	b=TyYDlubZijZ7shsDdV+I3cxeZWUUYVVnPp/kESI2Qyx9fj/ph6xy0zVOCtWvAMGfgbq5rD
	lOpguLWWGpdq8JwW8M2aB2g30h41rsbs2iTiLVB9FPjeLDgGOpsxdKdT02+FerRHTZ8S6A
	28UQLdtyyIpIblP+7lRucdSjDBqk/yA=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5033b64256dso734251cf.0
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:23:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772126613; cv=none;
        d=google.com; s=arc-20240605;
        b=KCsMd9Mv6u9kftlueq83CWf1wDbV8Cr4xG87TeHjqavtGWPauasaIJMP+1dPhA8jTJ
         NhfS9H4pDvg8voihVQcO2kjvvhEV9ooqb5YhOMacHdzc9oD+rvXvbiQUtdq5Gj0PVEbA
         SErGFrFFw4CORnxSQmCLumveEcJPwjzYPINkhnYhsXrNKdiKsgUSKQYnE/goMKS41pCU
         zLAci2rZ9oWJ7iRoxAf/+6FFoHs3ysqSxwTQfvQ72YQ0gq8/YtPcsjvkShChzvbF66CN
         73F6qwN4Jxk//PosLN68w2t/AP642tYqWU1ysDIUczw/t8twpHtS0CJj2UNWplohPlQO
         FbBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FynKKhlWalFQKKrs3ZP5yNMAhsIr6fWHYQm9TKDGe4A=;
        fh=5WCRu4PJDrbt7YqlUh0OaxS8HIR8LAbNzH+vcoZmNUg=;
        b=Nx4D087yAE9bnbf2/YeCcxuYvExh5Qo/ZPCwnTKnAs15ODcw67MFg9Sn0KM0xEHp5x
         IttqtrKwMHTct6XlWuJFWpCjBYoAmnqs+hU23V2XAOpqca/IwysgcVYCglpQ5DF7IMZv
         Orz2Djw/E4BpoidJUqA0BI4PhSCpTO4kG4yLfdVvFniHOQYQNOFUeI+mHWXXkudI0Yoz
         vtLAfDywnO1LykpSfjjmtEzPk7f8wVmfZhzzOwrlobYTxXvdgwb9pNLvLY+TE60oP9m0
         s2TG18my6udgXYvT508fxFo11G+srjdZiDeeqraiOwhBTo1CCKNTfCnBi+65JUK9cqSd
         r66Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772126613; x=1772731413; darn=kvack.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FynKKhlWalFQKKrs3ZP5yNMAhsIr6fWHYQm9TKDGe4A=;
        b=lvO8ppKIsMAHrCgCK1f6TzcxxpE8+ZWzGEhrEBOKzjl29hkNRrVlj08XLfRkfq/pOT
         YV3MyMENMdO5dyZlGh0/epCbC2Z4WMjTXwDj7iq0b5vhtlPSKX1A3brYJp8QIBsal2S1
         EiYxAjT6X8V9eBh6HFsQFMWtaS6WG05Eqxtvxy8nL+ZMVTFEUDJdCMGaFQ9l+gGvMHE+
         ICGCPm/8+jTT1c9/WGH13+z99ibL/bzwTNPc9ZjJCQPbW9xG7vky7/0rG/eyRZAPTZVX
         XxAC/+dno2I017wzWGuqvFR7eqLW2fbJIkJqvOuD+wzrRInqTanqszZHb3lvMOOX4fOZ
         gAzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772126613; x=1772731413;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FynKKhlWalFQKKrs3ZP5yNMAhsIr6fWHYQm9TKDGe4A=;
        b=iMNHJ8p3intxl67ug6m9xLUv3dciLdqt87XS4obW/W7nOrbibDOy91gnSJm1PiXFE/
         tLYCg/ThIrTN1SmGNJ0/gQQccwzDNgnmzimrJ1zFz6PvQttaJp58c+UYXHicI+U8555O
         3A8fKgZcjEyYedy/YEcXzmDFuY5vh81aijC/BcH7uPeXvY9zrLYPk+dmfAJROvLfhk2Z
         lPLqgh5XsfviqFlKbdyAa+BsqVE0uATUJFo6yhsMK8JLKjd+si3VX2/KxNcBPMWzwA7c
         Ueimde1iloPdq8K1kZJt3fJJvE5uiLRtoXLukvUcxl5nr6Cfj+uHYVmYogBiu+3F+iaa
         skvA==
X-Forwarded-Encrypted: i=1; AJvYcCVNY/L9T0uk2JbtGiEB1OkGGuBlTFr6A560ip3A2Rg05R5lTx8gLqe+DM3dHjCGDHoEldpwT0qxqg==@kvack.org
X-Gm-Message-State: AOJu0YwqWbEKwfoEDDxdxnjPM0+rz/t6K/SgUZhYyPj0vWWeP3BR9h6p
	MSqbIp72TdqAORRJ62Uun/kVS9Pdiq1IwfljO4gjZ3YqhM98fGSagnxUD/p2a690+6BioQROfgj
	rJl9dM4sVTl3TSPtdIdZjNOiGNGfNeogwUZbrvI7S
X-Gm-Gg: ATEYQzyFzIvHkMyFaKIhgpOt51q0GXuL3nnVCZGooEf9pT3NMhBPCqgA/brUW4wuC4v
	u30OkuS/jgpKC6nQvGtl5wKcNm4dfPxr4H8ZfpMaAMzLI+vGy8fHF1xDhLUr7oY/SLCiy4FkvC/
	tRV/K98zQ5339aqbWBLFCRVOcPpxmaUABcmlu6WVZKWXgtIZd/qpUhHGWbTl2uKkHPVKppRG5C1
	MwLZP8Wgt6gy/y/NnmmPnPTO9D0O6s0Iuec2fSkBcCsxuhTTcvXA/GSm1YPnnf2M04nZDQRZypK
	Hr0Rz78Jo00GYaAMOJ91m9ZShg8VbOaMpP75/wWd3Pya4t33
X-Received: by 2002:ac8:7fca:0:b0:4f1:a61a:1e8 with SMTP id
 d75a77b69052e-507441ca8aamr14889431cf.10.1772126612071; Thu, 26 Feb 2026
 09:23:32 -0800 (PST)
MIME-Version: 1.0
References: <20260226070609.3072570-1-surenb@google.com> <20260226070609.3072570-2-surenb@google.com>
 <pifgesxxxcwcrarg3q7sgiybg6d6laaym2jcj2h44wqoaxopcv@idc7vavsmjsd>
In-Reply-To: <pifgesxxxcwcrarg3q7sgiybg6d6laaym2jcj2h44wqoaxopcv@idc7vavsmjsd>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 26 Feb 2026 09:23:19 -0800
X-Gm-Features: AaiRm51NlioHOecXqmKgqusOoAstD_F3nrG3Ao8qrpHVfKsEfdkgNePW1BjyYWA
Message-ID: <CAJuCfpGTNuojCXUQU0o-WrCRAuXPUAtLtSG=c8BL00JvnvNBiw@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] mm/vma: cleanup error handling path in vma_expand()
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 110D8120015
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: nh4y59pufsh5dak9kn8x6mtncwnjqjmo
X-HE-Tag: 1772126613-831079
X-HE-Meta: U2FsdGVkX1/ATNyb4MAW9KAANxuSSOcHDws2NBF7oeMQ4QhuEZiDszgA9Ms5W8h7+O3QcmXVIiysAnv5wshFfq7+22g9jVxsSjhW9oLq/bmc5f0/VgA3fNZFI1Op6MUWgMWpN1bsY+6tsFHaKtbMY0wkLGVDZ2ioO8YYD4Nthu99jakgTCDXszFiurr5A5D/zGVkGZJoxjGiIkWPYop7wqxamYt5vbqkZ0yXmryvWRg7vfNzw6y8mML2Oz2B3kzaq7kPNBhGJlc9gfY+v1kMbBPorc8Rq0OxDnTzCj94c3Nz5tkXXQEuz6MOg5AbC2RHHoSKyXcvVcF/rQq772lYsLNrx+X6l4LR66fGITT5qYsRQsXgR3x6nH1QHLrE9HUgjC8x4LOugwJ37AnmM8dCyFBbigcO9eIC64yAoSAaXfGFaxMwl6Bgg8fpqe8NGT3f3+FMI1Qwy4AXvCtv+deIWGTOO66xS0fCJ6MA+ijeJprPpQS4E2t3AQnvjKNFdRqq1ek5MOGZNteX7BvMp5FrXxnsKjOG1N6/3eFnnIItxmcN7Tu1/VwnZNvaWxzU8B0v86w1kquEbFSGE45PByrCxdY6vGhr6Hiavb3mhQDy0XhqmYW/nrBfFEj5qdXt5Lj+VEXifYDBuJFg6k0pKG96LiluUNF2MNItQzzrPo+ljAgOoyyBa+/3YWts1euAI/ahm+I/SC4crE6UsRtDXcomvbNGemSkBgM7hkQttx5mGP46Lxqd84MIV4bX6DNfIRPApMDtJWgjyI76dunefq/N9KG9uO34eMAJRC4/n7P5VeloeO+qCNTnbNOdPwcl8mtMy0Hhh1eA+pdDBfGkYRDgZe/jdWxV1174vGprOFT+p66s4i5Qom5uoNUZv+YPTCLUEBEeV6vaEOoDRa5cbvtvmEyz65kxNfJWyRkh9qGGfpQcCuxille/eJTtA7ShKfp2y84+qnHWvT+4c+6E4c8
 Fs+9WWId
 kzP+EjP30ZSgzL1n0VjXGWnMHrEQRldmxChYZ2pQVmApreMEE63hH9OLRb3CtdJ5/OzBDbunhD00PnKa3Tcwwl+fBRJkJWyXsiw2e0zqCUnvh+hEDRgl0j5Kt4pXvFiOllro9rDhlpRTJuFuyeG8JiYVReEV8VU1rG/QPtvj/6Ut1x6cEqQfE9NfL+BDGBMiDFaFqWsF3cxQzOO6TQsI9lMff+Vs8EG6We72dPBSDZ2kcg+7agx5+PCsc7TsNs2LlqqisrLRDXbw1HEOVLagC+o3PKlwHhL3c9EybKy+vxv0pMYRZouN/Kv9Bw58soe4FGcvhD1eOQOOnGG1IqAob0KDKqbj18aiNrzXeOaIjSUtlG5cOYzO1lgo5qGZMM3Oinifz6wOgjJuloiD3aSCzh8ZjTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 8:43=E2=80=AFAM Liam R. Howlett <Liam.Howlett@oracl=
e.com> wrote:
>
> * Suren Baghdasaryan <surenb@google.com> [260226 02:06]:
> > vma_expand() error handling is a bit confusing with "if (ret) return re=
t;"
> > mixed with "if (!ret && ...) ret =3D ...;". Simplify the code to check
> > for errors and return immediately after an operation that might fail.
> > This also makes later changes to this function more readable.
> >
> > No functional change intended.
> >
> > Suggested-by: Jann Horn <jannh@google.com>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>
> This looks the same as v2, so I'll try again ;)

Sorry, missed adding it. So again, thank you very much!

>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
>
> > ---
> >  mm/vma.c | 12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> >
> > diff --git a/mm/vma.c b/mm/vma.c
> > index be64f781a3aa..bb4d0326fecb 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -1186,12 +1186,16 @@ int vma_expand(struct vma_merge_struct *vmg)
> >        * Note that, by convention, callers ignore OOM for this case, so
> >        * we don't need to account for vmg->give_up_on_mm here.
> >        */
> > -     if (remove_next)
> > +     if (remove_next) {
> >               ret =3D dup_anon_vma(target, next, &anon_dup);
> > -     if (!ret && vmg->copied_from)
> > +             if (ret)
> > +                     return ret;
> > +     }
> > +     if (vmg->copied_from) {
> >               ret =3D dup_anon_vma(target, vmg->copied_from, &anon_dup)=
;
> > -     if (ret)
> > -             return ret;
> > +             if (ret)
> > +                     return ret;
> > +     }
> >
> >       if (remove_next) {
> >               vma_start_write(next);
> > --
> > 2.53.0.414.gf7e9f6c205-goog
> >
> >
>

