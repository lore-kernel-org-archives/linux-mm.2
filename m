Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D63C6606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 20:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qEyiyMHR
Received: by kanga.kvack.org (Postfix)
	id CCFE76B05B5; Mon, 26 Oct 2026 16:28:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C805C6B05B6; Mon, 26 Oct 2026 16:28:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B70C06B05B7; Mon, 26 Oct 2026 16:28:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 85ABA6B05B5
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:28:48 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4704C1608C5
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:28:46 +0000 (UTC)
X-FDA: 85365915852.22.23BDD97
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4A4A680005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:28:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qEyiyMHR;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of sidchintamaneni@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=sidchintamaneni@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793046524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aZiIWIK4zs06/5JG/qnDMkk8BlPUJ9MuP9r4RH/bdYw=;
	b=y3tzrr6HOYewLo/KAW/Q07d6+pIiPxu3hH41znuzvox2w1NyWM2qCQ03xi6JkfOwV7Oky8
	qpTu6V1IkAzXzqmaunnLVf0042Rj3l7f3LBxdvPLcOD6gBEoi0HLi3Tr2QFMmawU16bzim
	ugbMAuAJfP/8MODnZ1/eLxUNEYub71k=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qEyiyMHR;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of sidchintamaneni@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=sidchintamaneni@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793046524;
	b=WVTwuj3gWNJEFBmXBgr8f8IuPxpXOPDuLs+HjLE4fxTXsM9Bk3K3Ei9sO5JqZelYx2z12v
	DsYIkWx8mcZZoXV0htq8GI1mkQ8czsIetdNq4tbt5jFY/1h1WjQUx0Ue94zuet7o2RKWkO
	psCYPVhRRSNoYGEugrDa8xRwTE8hk+4=
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-8b056d58f2aso31316057b3.2
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:28:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793046523; cv=none;
        d=google.com; s=arc-20260327;
        b=i5OVdsKaZj6a3+k25517gBGdxB2WRQWJzlmKrsOxwKdjxFsp5Q78zDn6cyOU8781Jp
         9el+k4YeGsibeqUp0bZPCJwd6fxtBkZxvWTPLbkrSuYX2rqx2lNNQvIcC5sqk+NrMBnz
         gqu7cqWImW3T80LsuSfee4MdQ2MOaziGmBMkQtxyeLo+2KKU4AFwhAKN3P5HcTJM5fB3
         tNGjAeTbGYo+Bs99KYhx8/2vc7zOkdUiSeyvDgc7ZdU5ymvhrdtGGAMFAJFekr+zgCCa
         6fo5a2qvxey/rjOeSFqSfXiBGz2rtl1Jr3sxyF2ob+YKaoCQKAeVK8bRfhP4VosOKFuR
         LG5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aZiIWIK4zs06/5JG/qnDMkk8BlPUJ9MuP9r4RH/bdYw=;
        fh=AodT1FlcnSVrMRldVTL8ayuN+nIxzaAGP1Ws3gvDffA=;
        b=owdqSRWjMwTkAom4iCct0oE7zuzYUYewCcPZZNFj4gHto98GVMXGQE8PoBvla+CnYW
         7goW0kR5uaSJIgrKsTTmGsEHUZqQUcyfgNOu8sbJDA636xYeABYUtCNaASTRk213Bjnu
         OiLmAb49X1DVwEcAzYNTxtFyYuI/lcA0VMzxRg36LbvcvScpCyUuICgkYzsna6VcB6m3
         tXRYvOR0Kufi34eqwAPqQS4286YU3PEyet7JnwKtakRLSkJSYUc8rkVi6KpJXLL/5ISf
         kkZeuq5yf/J9pronASDQRXiqzVPKHtQbP3DVBTmXadwYdSE6hdYZB7fR+h+hXirH50QW
         MbMQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793046523; x=1793651323; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aZiIWIK4zs06/5JG/qnDMkk8BlPUJ9MuP9r4RH/bdYw=;
        b=qEyiyMHREus3BZTQcPSvw+TRrSiwusvgjc5nyvpMA8IMQ/bCmix4ZVnqT/mrWAxI/e
         FJ9ypchbab/3NBqMAYxN7sD/tNC11O0EJQ1iHTbEi3KGoo98l/OppaRoCVcaEeezkr5/
         qhC294SPYKryZ6uuXKYq1m6n+JFScenP9KGNoA7XTBIdcjcz+IY3TRXrTMKyEy44+Wqt
         h85vno75jLA6pd/VL44IPV7MQBCC3gEb9XRXU5IiQObBnJtCh/O24z/XgYHf43Hor7UF
         YpT7gW9Bt9RhNi581NArguKDKsqYsQT1bW80kkZEvdcXZ0uhS7r2wCJEERccPkSNKk9q
         aHSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793046523; x=1793651323;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aZiIWIK4zs06/5JG/qnDMkk8BlPUJ9MuP9r4RH/bdYw=;
        b=IVBh+BCSVZ1cwve0sXF3sr+sj9eYXFJKbB57v9qSdDK1jahlaNExAhpdDZ8ZtIEATD
         yhxa85ESRvhvRi5syTvYRWmemmapadlZgf5DJSqZViPN84nII02GbVQJorkMJAnhe/4Z
         nq5/FFWdtDwlkiK3ptX0rMTQI8biSSQoWuj2aGJTD01xbHFx5evZfmGgaMZQmFNsJ5Y2
         cAUln8TjkxuDuc8NGPMo97dpSM/GUI+AKkrEwqbkL7z9s5i9+mzONxdKcaYfHwduED25
         n5Bp7esqWcJJMKMHRQCDW9ZAXLcGmyMGT+Zb4dUATSM0y7AKf0HwLCpKw57+VTFawOuO
         24gQ==
X-Forwarded-Encrypted: i=1; AKwUvBxeerMHl0bJ2M6WWr/ZB4yfKitlKFTiVZ4hePOJLMpucAiTtWzkJ6L7SbuL1M4sSRdiJ/ZdZOmTgA==@kvack.org
X-Gm-Message-State: AFq9FYJ2kcJ8ZTF9kOof/UAsEa/U4s4BisWlstOuSyKlAH7NivtD8CRt
	X8GaKITqVD+co5QEwhZFSXW/+dUWQRwnguybiOQI4cc7TBhrHUOXfjYhibycTOlKjXtC9tf/XG3
	PmNEaOQPJ725PeHZOCks/3Dp73kSqj+o=
X-Gm-Gg: AYBFou0DPBeC7lK69uhlPbx1LxqlAlmkE4GASx/eNxWkr0VwijiaVl6FVJu5mfCrpMi
	ip8ZaIUnXA4fWycQ8p3netvpklNc128x66oDPBbxkuYiC0Gnu55t2ZX4YjRjyDmUo1zEVeeNErT
	zeVWoyajZnXabCo8xFDSqpGrBEmFP+LxH0Q1FLiIeOG+V4B6DEs03LCYrQ3kZHiFzndUva23jVx
	tU848E6zUa+UatLvBm1cQrqnGKOrfq/G8MMbeyNFHHJrrMK1T9Q0CGvfxTQqzTktEgG3eQ91GjI
	7Zuoaz3T/hJjZ5L+OAH3r6ToNz77IJhsOrVajWaIaoZiaOSiR2Ft+fXgc/QFm+MLoNAgrzKO4ia
	/KAAeou8JADWVl3F+OhII+ei3SVw0PKZr669qMLvXU4SW2NxvK6ElT71xe+qxoV+ZY5/TOuBuvl
	aCVdxRlhFGUj6i7Rj+p71bwHfl4YDASDW0IjfyHBb4XY6+dyOeICH4W4I3xZaESgFyXAztAi8wj
	YzIdERV
X-Received: by 2002:a05:690c:e197:20b0:8b0:d9ff:4f4d with SMTP id
 00721157ae682-8b1669e46f1mr35142877b3.10.1793046523300; Mon, 26 Oct 2026
 13:28:43 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261021235606.89545-1-sidchintamaneni@gmail.com>
 <20261021235606.89545-2-sidchintamaneni@gmail.com> <CAGsJ_4y7AzEHUjj-g_FaQdodYidC26-7MSG8HPkgfRgi67TCkA@mail.gmail.com>
In-Reply-To: <CAGsJ_4y7AzEHUjj-g_FaQdodYidC26-7MSG8HPkgfRgi67TCkA@mail.gmail.com>
From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Date: Mon, 26 Oct 2026 13:28:31 -0700
X-Gm-Features: AclHuK8l-MC_C_lflMDZtzuDKg2UiJN1OPTp7TsTz1M9Ty--VeZlBUsKVihib-I
Message-ID: <CAE5sdEgE+=cnF5dSDi5rY0Sr6YqQtYnEc3+QWVDdk7vC+AWrag@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] mm: multi-gen LRU: remove get_lruvec()
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4A4A680005
X-Stat-Signature: ctoqs48xj5u1xhuwjyrtmq7ojshe7hk8
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793046524-579757
X-HE-Meta: U2FsdGVkX1+S78YQPFCKaYKPmKJNjaWM4XFox7ceijiDFHuqcxckgRPfa+ukFw4pEORTB//wOqj6FwaztOxIOGNKyv8XCJLZs8dqAyfyANcnntIPEZGKRc0PDWlmTZ6k0MGC+/83nrIl/gQ57SRzvEyv//kzwFAT19bA594W393IW+YE9UPkZjDXlAi7cpGqKtO6CqQTs8FCRBNd2nYThdmEs0xbi4kz5SsuH1yKbqUqSBLcNmYQlufHc8FTxE7Wr+7bEg2FOkHYbDgQLmcalCTF2tRUa8FTG95mhwpl3dCpbN1UHQuEVNUjEJGiGxtD5hjLtkZ9+yOvQK8F5oBDyX10Ww4GllOeyFuPMgP4/RwxQvNcYRhyLnXfh0h/GkgEqcUxlyeiM0AZYt21SkNOeWvDP+hnZ6pTn3XsWfnzn+w+k9P3XOKy0pMhfW5vZvDG9pcsfVqwEMhSad4AWvLnnJJqlUHCcs6vpzv3gVFbj649eB0qu/y58aB4Wgi8kxuICy+6jp1kw2OVLzFhss6poWfhCg0CVYlKOXWCXWI0LrAz7Dr6xwzmEDqMS+P63Q0uStuuSK62bRN0OxvbRGgXPT13w+b1dvu8yrcIoY+sQZrPszAY3Z8vkMEDYx48zLdlxqMPRN6sTDhO2wNpWgj35UvUW7BoWXhL2XwgxYguJOm65c0YuCOe2qg5j2CuEjjVgR7W+kgIW8cJwX5XwhusCuagnRXuM3PsqcEHEgoLjhaH4qc03fQurf+CSIg/LXGG+tLubzz5waM6REsvIdSu3kUwg6mQS4+iWCkAw4IlJIRDywz7L5nhpXA1XbUGjEityEs2lWFo5Id0kgg1O7TGqJK94/RnRGkc07m5JKmCNKZ54OzfG1iC5QF/QEcScZXbrF7iKgqfQPpdYJnJJc9tmy6Pl/22SQoZJZTx3Aizx5st9bj5xiMGi7rcynhvOzwTpvKelcTt7sHhDp716ce
 Ez7c234n
 g+9laPmnpYZMeVGea7ePszGukHGxn+juLs45qDH8GapK9XM7tF/nh/rlALw+sFDcL4im5FusdyhCeFvvAacDv3kESlGAflQdkMtFoNYHcDumFVLGrTqSSrpmsMx9hXFKFb7rUYDQH5YCEz4guswHPlNm6qv+YDwHdLv7XafwKGUWHeyHjWzDZ++1Qz9k27DYB8ndc6vzf7Pvh1x2dywEIgtNz4KO1mZCJESBKMzQ7ECv8CD8vm3BRckyVoYlIYp4G3mDHqZiyWH0w0lKqYVjrtS653Ta3MATRL/tzWFUCJUuyEKI3hsQqHMESEgmNTG1/RERTdO2yx/Ep+YiJGrA/oXIs7axmXuZzABaQmhvoV0AV5tmYwUeOSMplw2swFHqQ++SFAPMVvY0Mg8PsEq6tUswkQGN0PTNxW7/LwiwR8NB+yayX7ih1TpjJOemA78q+Rg/BVwwRWugpzPZqDouosayatd3zwDuxDLUlJpT0p3AFlNyeyS19jUbFcA591/93oFDN5qcdyZI1ofY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 26 Oct 2026 at 03:00, Barry Song <baohua@kernel.org> wrote:
>
> On Thu, Oct 22, 2026 at 7:56=E2=80=AFAM Siddharth Chintamaneni
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
> > Cc: Barry Song <baohua@kernel.org>
>
> I guess the correct tag should be "Suggested-by" here?
>
> > Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
> > Signed-off-by: Hardik Garg <hargar@linux.microsoft.com>
> > ---
>
> Your patchset organization is a bit unusual. Patch 2/2 is
> sent as a reply to patch 1/2. I think adding a cover letter
> would help you organize the series properly?
>

re-sent it with your suggestions, Thanks!

> Thanks
> Barry

