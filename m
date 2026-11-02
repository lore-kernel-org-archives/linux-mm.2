Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6446A606A32D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 23:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JgsOqESM
Received: by kanga.kvack.org (Postfix)
	id 41BAB6B00EF; Mon,  2 Nov 2026 18:35:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CC616B05B3; Mon,  2 Nov 2026 18:35:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BCAF6B05B4; Mon,  2 Nov 2026 18:35:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E3E946B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 18:35:43 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C8E1AA7C04
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 23:35:41 +0000 (UTC)
X-FDA: 85391788482.06.6AA3776
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf19.hostedemail.com (Postfix) with ESMTP id D14641A0007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 23:35:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=JgsOqESM;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of sidchintamaneni@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=sidchintamaneni@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793662539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fzJ7DDrA7BFfziOD+5U6zgKxvJNhVIYCuhgUNRUmPc8=;
	b=i/D0Rji/FbxEjLB9C+IxxSoL/beFFVLyQhcQgVqSFA5SNjLikchEMwLwx0i3/5edvK1ojv
	n8cvrjtZ2fpl8uj69uijWqRsKEGVfrWM7RFwudrvXa8VsBqPpzQ2VFCFzLebssEMId1Iqc
	WvvjHsf+IzcC8ywq7sSdA8BvIH9loJs=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793662539;
	b=GDy/TK5nWe4TJouBNslT+/f/go+n1RoDHIaNUFfh+hA+xPqbRngZVePEr1K/1hpsIJPIjk
	/mGu1aDIUF12C74UL2vTHaXVMw7Kl4DnBu5FgjzmNvwnPip/SE5aRPxZeB555J7KnI6nwF
	Ch6FdrEQ3dXiT/x2zVvtX5qyne06kIA=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=JgsOqESM;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of sidchintamaneni@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=sidchintamaneni@gmail.com
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-8ac525c1f05so33280667b3.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 15:35:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793662539; cv=none;
        d=google.com; s=arc-20260327;
        b=qirWqnU13lH2S9mzXLnBzw15nyEOWjWxUrKvs/16j4AezLAwH/m8wWL0gcD011WFN7
         HXv5yr11eVt3LFpDIRe4jn0WK/bZdFcuVY6gbnu5l1uff6PqjD1p1KCzklc7CwcUplK6
         1XyahF7La8Qu4XuUERWGop15E2WHX/G70QfEoDuOSGJSgyj5xUkypv5joDPYaq8MLiuI
         0YkLxu+Gj1ExzvNpF0DRcub9QutodnZZjjNFSGU8mUNE8PhhDFNyMSWHN76Ia4QzemFd
         yJJ18YmTHPEFlm2NxC2eXNKgEI9jDJcQ9wUbzVbQvkkgClyra/uJYr2uSPJ/yDgDDmts
         JILg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fzJ7DDrA7BFfziOD+5U6zgKxvJNhVIYCuhgUNRUmPc8=;
        fh=jaGYsABIVKtIkguRDwP5JQNP8OrbX01/Ku/Fd7k4k6Y=;
        b=ElBXaxB2gajRUlzd4LYOk3jTeDQVnaaUNvqcKE+BtTPFvLZAuCmAjaCKthURSxx6eL
         nTqKpw704vKjWOduY4vuB0wr2gjxQpYfg06CJjjCPe9zEInZLWAbk4P5fS0S2tZZVHaz
         azB7ECiChZtU5NVIQV6Xj8BiOLi1YrXePS/eNJgap0IEW+NaBAU0phhVlCc6Fm3wV++4
         eibHElvOJBGhPFfVvhQy0uotCzG/3NN1fhGfVdBc4fH3tE4bQzE90FytmL+BuqWIkLKK
         S3zHKNFR0eoQht/xBQUBTM8uJyVT1SruVzvv9bFiVqmcpv1oHQtQtVe2BRdS9QjsD200
         RqDQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793662539; x=1794267339; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fzJ7DDrA7BFfziOD+5U6zgKxvJNhVIYCuhgUNRUmPc8=;
        b=JgsOqESMOF8JmeFXxD3mmXeZAKSOGqmQbHaqjZpepbCEruaU8cpBou17T3HKekI3b/
         Ehrycdnzg5fVVp+FqGQaj3XKjBAWM3PcMjPBPKE+sB9dZ3TIphPtaIdndAdwhE9fnC+j
         lmdowVS3zOKvCit370CyiFO1qj0uoWJhYZL/vxMn2VblGlugJ2RYl8S9ct3O3nO1cAKO
         JVzkbr1VS+Oorn7xEFUB0xsUW2j0XiFHsvO/2JH5aOVuj+krzQc+TE62M0nPgj+AVJcT
         JL/N5egB86wEOO8i9GHI2HBcq1nW4pHOyWX5Zx8jyu8LRzBeF/Fse7hefmsfBofUngH6
         mxxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793662539; x=1794267339;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fzJ7DDrA7BFfziOD+5U6zgKxvJNhVIYCuhgUNRUmPc8=;
        b=DOApLNM7q66JtlKzNLwJD/xlnzbblHzlFqsVgukjIy/tGgabYASqqQAnA1nuZd2ISe
         X1/8N1TyMA/01fgSdESEGSBd/vjC1s5R3leAGrYeetI6nEMctcXnCD1vj2FEfuRD5YrY
         rDSS6KR6LLqQlJQR5jg/aF3R2v3ZpotTKVvtUZ+Kadkr5gX6efa7YRb3iufBMUJNorQa
         MyeIva/uQxQA3pBHwLPUlABxqj7xjW+aGhSgWC9X372HjdKiQ9aIGk1UeKh1vFo+JxYl
         5Ef7+N3oju9FXU7WqWZnF3P3B1gUz/94uJM2ravTjceryqy/XxAEXelQVvp67ZesmM44
         FzQA==
X-Forwarded-Encrypted: i=1; AKwUvBxoydmQMbl0C85NlBLP6JPdgawQpGOMufRoDlme3r7mTYpdtPKvPbI6y0ks/WXrfA6Q45meoNSRUg==@kvack.org
X-Gm-Message-State: APuU4Z8Ujrn6v2GJzoKTpu14AjApue7L6ER5PcxfGSgforhSVH/Mg42z
	xRdv0KPzs9w0PeDaG1odmWBbSoqoX6PfCBVPFqDtHYuO0GhspLKlRgPG58G/3JD5uC0LaMNS3II
	M/JO+FG5dWdCaw2wLckfsbqEzrQnzqsU=
X-Gm-Gg: AYBFou08iU3eIrPHC36tjAL2WxZaWhJVNy770SW+5K86CeQLml/IWnYPnqzGBTyRE9l
	FOpX0k7wedaT6OM1KRKHAZj2H1VpoyFW149/VnONRH0ZyyfCktLMSOXe7/IgNjG4Z1KEVyq+CHH
	NBCRsoJPta+s/mH0vSzkJoi05Fy5mOuBOxQCf6I9lLsLN6WF+/GTPS6/dz4E89/1/oW8FJAA8l0
	8SH57deOLA9QUn/OtcMfpNqyxzqtmLVRkolwzOGW6qeyGzOeq7doFaH6gRl4gbFfHRaL+NFepLW
	zXcKD09yHIo1BqNEZUjXnXWp+bKEI5uvvrw2LpWUUH1K47eaqBVm+utVIBK/F1hA9mSEWa57qf1
	upe6amyy+xGFuDqkHA2+5auOn9mnfpcY/Am7L01QVNnVal4Ea6f1xBT5aNsWpKi2Kgq/WCAtF83
	FnN7bgRU+f05TGu/EU067LV3BPdt0AkXC9zLdgbSe3cgspGzaVVD0GEa6ztiflWSS0I5xQQ5+wS
	ZvdHcc=
X-Received: by 2002:a05:690c:a046:b0:8b0:eab2:f502 with SMTP id
 00721157ae682-8b2b67992e6mr70242497b3.61.1793662538781; Mon, 02 Nov 2026
 15:35:38 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026202313.63122-1-sidchintamaneni@gmail.com>
 <20261026202313.63122-3-sidchintamaneni@gmail.com> <CAGsJ_4zGmtvOApjFH_-V9z_zNWWQnrBX9q0_iWtbqzENCetfgw@mail.gmail.com>
In-Reply-To: <CAGsJ_4zGmtvOApjFH_-V9z_zNWWQnrBX9q0_iWtbqzENCetfgw@mail.gmail.com>
From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Date: Mon, 2 Nov 2026 15:35:28 -0800
X-Gm-Features: AclHuK_XPYCmlY6syHd_CEWjIh9aCzkJuKkCbt_Y0sdvkYXztjtpge7vYJ3DEZ0
Message-ID: <CAE5sdEhVfFuiYySA0cNPTV6FjY3wnwccfLR7HA9vhVOF7DH+_g@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm: multi-gen LRU: remove get_lruvec()
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org, 
	kasong@tencent.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	yuzhao@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	apais@microsoft.com, rlmenge@gmail.com, 
	Hardik Garg <hargar@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7yedo5otbqiig4csoqhg3ggf8qzqysch
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D14641A0007
X-HE-Tag: 1793662539-99769
X-HE-Meta: U2FsdGVkX19T0KOfNF+nGRHQk9c+zQehyJd7oUvdI/XQshpGyG425WfjCYA5Hf4N+tP+BjA7WpRqOgY/c82FY53sbyl2KLo2d9f11CoZopD7GaeN/H2j8q63xzhjkGfxkveSSIX1zLWtZEa4FKfnvLcChyON9Ke4Dw/jaDwKFSk2JNatzgkjiTriO64VA4mxZEGPzqpZlbRuOvgmGWMItsSPYJRxv+I+4ZmxIaB7X5fzqKMHBPqp/+/cAXN3wjZDvCYYyuC4R7tWai+CAuEX7/nQUb6twHgO3p8eFIpqCAqUvSTa/kXWTFJ6GKKnq2+pl2dYr8teD3AgIgd31jHDl16mSKBCfq2LzCcHKk16hTAZmAksOERn5YGMuovo1I3scH8MkUvve9a3Q8EMkNM0ZdpTUCT9MnUMFVneMUCnG9UoyT+17AqTFMSTknjZsQJXBeJmnxtr9XYpfy19TbZIlF5WKZp/gy1+tfZWZEmuLDncw7JZDkU0MoAxAqdqFcWBOqtFrjCH6vBpJ6Vmb+EFqSp6Da4OziG5rbm5Uoy7qr9M/Q1G9p6cSkMKYFketQOr2VenUl41KRCKC9ZNYwXaG6oi9Bw5HSHBZ5tcksGdhUAUXmkpCLBv6sN7jlUIAF7BaVdk6S9o6mt0yTjpFWEEqUMJSc+WXFx9ncpmFp6O9vWU09f26unJyOUwh+nJOgrXMnj/sWJqAHD9pf8PJMEZeJ+krGhscI78BKyM+NthCCOLzhHANbNT+X+ymP1oyctNE4rLqh/+/a9So55lNXqeLq+X5Ybrxy0zDojJ6QcMXkdWnBM0PTQeBIY+Gov7VTq5web1n7E2L30/OsD1dDpDvO4xFvjNl7YDWnWCPgFYJIpi8nv88DgottTKclFiZ6XpllCGBQWb7+mIxyqvgpZjany+d/doXcyJOatxIBUMUyqOiEkl+C8XVH5MV3vHXlG68rADvCJj8NRrh22ush9
 VpFWvDHs
 EXhl3mzpVDYBQBEsZe8Rcb5dHgx9R3RTCHzn9BaWJcCAN1nE++LotfohugN4/BN4GIFTl/2X90B0yV0HYZANKJOnF5XlKaBs/lFcpiahofVIo49hUU/k1uA8Sp2SbRpW5twbP6PYWUpf5l2C7P2GwmdfY88bztja4LeEWBsn3NjpJ9t7BDKzn80OyFZwwPwGZbmurckymcxoJjbQ/iUHVEmYnnvFUDrACedGV4ORgHBsmmAf+Ea20Cgbpk9Qj1ex7yRInXIQVWFz7b/8CDwKWIv2Yi/lY1P5xO/43lEV1crPItc9OYXz0PmRlFewjXPX05+aMI0lnV+nBi0f7vCCbUSgVgydDpuOPe1L8ySautD9kAmwW3ciG7RhZbEnVamIlaVc2A1S7LcKFQMVBbFVZerilnq3PLioOxmP4nCOIm7tj6P22JmivSc/E4NVv/axBQ0tzE0QUwAattujB1ksYbRmG6tmT9D+b6K+KUMnEyu1kCx1f1OQWN9BcTErxfPA4CM8VYArj/FKPG9aQEgKGhcXPa0YPbJMw8zqc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2 Nov 2026 at 14:56, Barry Song <baohua@kernel.org> wrote:
>
> On Tue, Oct 27, 2026 at 4:23=E2=80=AFAM Siddharth Chintamaneni
> <sidchintamaneni@gmail.com> wrote:
> >
> > get_lruvec() was originally introduced in commit ec1c86b25f4b ("mm:
> > multi-gen LRU: groundwork") to guard against NULL NODE_DATA(nid) on
> > uninitialized NUMA nodes (`return pgdat ? &pgdat->__lruvec : NULL;`).
> > After commit 09f49dca570a ("mm: handle uninitialized numa nodes
> > gracefully") and commit 931b6a8b36a2 ("mm: multi-gen LRU: remove NULL
> > checks on NODE_DATA()"), that NULL check was removed, leaving
> > get_lruvec() as a thin wrapper around mem_cgroup_lruvec().
> >
> > Remove get_lruvec() and call mem_cgroup_lruvec() directly at all call
> > sites.
> >
> > Suggested-by: Barry Song <baohua@kernel.org>
> > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
> > Signed-off-by: Hardik Garg <hargar@linux.microsoft.com>
> > ---
>
> It's great to see the MGLRU-specific get_lruvec() gone. Thanks!
> Hopefully, we can get rid of more MGLRU-specific code,
> such as get_swappiness().
>

I just looked into removing get_swappiness() in favor of its LRU variant
(sc_swappiness()). Do you mean moving the additional conditionals
directly into the callsites?

something like this -
<AI Suggested>

diff --git a/mm/vmscan.c b/mm/vmscan.c
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2761,25 +2761,6 @@ static struct lruvec *get_lruvec(struct
mem_cgroup *memcg, int nid)
  return &pgdat->__lruvec;
 }

-static int get_swappiness(struct lruvec *lruvec, struct scan_control *sc)
-{
- struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
- struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
- int swappiness =3D sc_swappiness(sc, memcg);
-
- if (swappiness =3D=3D SWAPPINESS_ANON_ONLY)
- return swappiness;
-
- if (!sc->may_swap)
- return 0;
-
- if (!can_demote(pgdat->node_id, sc, memcg) &&
-    mem_cgroup_get_nr_swap_pages(memcg) < MIN_LRU_BATCH)
- return 0;
-
- return swappiness;
-}
-
 static int get_nr_gens(struct lruvec *lruvec, int type)
 {
  return lruvec->lrugen.max_seq - lruvec->lrugen.min_seq[type] + 1;
@@ -4173,8 +4154,13 @@ static unsigned long
lruvec_evictable_size(struct lruvec *lruvec, int swappiness
 static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *=
sc)
 {
  unsigned long total;
- int swappiness =3D get_swappiness(lruvec, sc);
  struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
+ struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
+ int swappiness =3D sc_swappiness(sc, memcg);
+
+ if (swappiness !=3D SWAPPINESS_ANON_ONLY &&
+    (!sc->may_swap || !can_reclaim_anon_pages(memcg, pgdat->node_id, sc)))
+ swappiness =3D 0;


> Reviewed-by: Barry Song <baohua@kernel.org>

