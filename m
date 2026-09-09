Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EE0EC79FBD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 15:26:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB3CC6B009E; Wed,  9 Sep 2026 11:26:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E64CE6B009F; Wed,  9 Sep 2026 11:26:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7C346B00A0; Wed,  9 Sep 2026 11:26:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9FEFB6B009E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:26:27 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CE9DD1C1B0E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:26:26 +0000 (UTC)
X-FDA: 85194600372.26.EF42461
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf25.hostedemail.com (Postfix) with ESMTP id CC2EBA0010
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:26:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="FtsRJ1/r";
	spf=pass (imf25.hostedemail.com: domain of jannh@google.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788967584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Br+tdrptieWuXdPTk2Nfej5S21hGodxLZ+5BSAUWog=;
	b=6LQMPNkLCSQC9TMGPbe6iu71cvpg7AdC9D3T8dn8EVhj9jMwmUevowbZm+/WelaF5Tr7vn
	9/G5ThSj94hlMBdjqkwIjRNY4jWoujHSrEhJqPjYlKp8Lwr0i2k+xUFChUvz6dB6yxZzlg
	AVYSyKwzWHmykqCbSRSv4n5s1U8LpR4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788967584;
	b=TJmiUxg3gcGPYaPa720ZrpnJCKgcA2E41ZNU8ot9lveHmwF3tRLSv6IGBJaw1t15vrkx8o
	M+3zXr5cvG/8zx9vcFBBWHNd43ZkzjzCVZkVseKQAR93eqXWodFLNljfURgrwnx12SSoHt
	dlQpWNN9oSHaYmiFY8QWt1QMcyAyeXQ=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="FtsRJ1/r";
	spf=pass (imf25.hostedemail.com: domain of jannh@google.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d6ff3aca06so117825ad.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 08:26:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788967583; cv=none;
        d=google.com; s=arc-20260327;
        b=bfjTWZyuk+OTmB5T1haato/Rj9KSvxKKntYMWrYJ304gE2bZI6bgYKQsShtiPWlg7+
         kDhen2AqDkfvl24nG9GcP2fXtw9zUQCqqqf6YDnsKPetPZFNJzLdRk23sW3HNJkZ+jmD
         t4lST5hGF/5Mh3ychymJ+VvLr0Enz9XHBA380R+17Pgivwpj59H0KA4DNCCYfGJCF1Pm
         Abd3Saaf02+nm/kIhfTfk60A3uUmLbzqk4DwgVTicbB26fULxc/m32b0pok8EBsiuZBw
         Y114XhPYmwY0Q9S1Ubd0urZw7g0zElXUi8oiSAoPaszlgplN6KxzUWF1ONZVrF9T6eJB
         mCLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0Br+tdrptieWuXdPTk2Nfej5S21hGodxLZ+5BSAUWog=;
        fh=0qv6lsAbP6Bkaz9qZJoShQMZOvL7o3ZNFIfA4NoYAho=;
        b=JxcbM2sU54K7caDns9BuUFymYsU6+/HKwoMQUXX/aLCEqc/XBWWXHTs5EWS6K6zaG7
         QbzJn/BeF1g1CAle27uro78YBQy79BrQCd5zb9nNUFGkAsRqBWFCoMDXl2IBmSZqzb49
         FziaS4+zsFeHQiy1vvvlmFlqgyqeQm4iBvd19IPIglnx8+u4VTWvoaqhObRlvjH0L8D4
         Z9BpmdR9WsB0g3ZgI9AuBHEuSbwkqhqBvCGSXSQdOmKRWGZtNBFa/GrmKLXhr5pnrEt2
         i34TFiB8c9nvOzLXpzJ6120Wr4FwM06SPsxcbQFkZKea+UOUpO5okutBVn7jPr7n/229
         Olbw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788967583; x=1789572383; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0Br+tdrptieWuXdPTk2Nfej5S21hGodxLZ+5BSAUWog=;
        b=FtsRJ1/rjaRBJjuPDQ7I3ZgUaaT0un12aQxbqLtZ06zSaUZkmeM73tvZktQxlOJVY0
         TIyzxpVsTeQC57a9x6dLjMnBzsyz4S4iZhqEy/UGVPPaboImhn/Cb8rx2hcs7e6jnZ/b
         uUDZRRlbiJsSAVWOcH1rb0LuT6ooLnD01ZgCoVuyuFFMYRykqYVaj3aXGVr7BbfOoPRw
         rEr6vKv2eQAEuifpZKuY3alV91mO+sJZUiwi2yJv2rdYiqTJeAQZ5wtpN4EWcOWUyZ52
         vo9FHaDM5d/lFfxZONwvc45TbTu2EHYUalxmK8Zi29GW0+ZN3eXIgq+WzITtUzqEM/NP
         1g2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788967583; x=1789572383;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0Br+tdrptieWuXdPTk2Nfej5S21hGodxLZ+5BSAUWog=;
        b=bE/UFXzRTYF/+JyYq3zk4kW+6mgQFT3v7pXmXahGIggg86sJvDaX5qyCNVRz8ip7Kd
         IP8SY8OTdzoEKM3nR7mGWvWP7SpcD5KA2KSkw+5H9faYPCKnU5lGhenGmuC+qy1eOO83
         8krCxF19RSFmB4qlq2ID7TqsaIFqPZvQjEdRfwBnYe/ozkkoNDzeSYOqTUIU9Mcb8fSa
         ADUE/C03c7jME0EneKp/oD45dQ7nrknKxhBatFvIUdNFWIj07DXdUOhsCCs4tC71TXOD
         jEoMhB3/uR4WmpZ3NAXuS9muwpIAWzxXRNHc2NRvPjmckBl8UVt6Xip/3LYoMOhTITe7
         XCYQ==
X-Forwarded-Encrypted: i=1; AKwUvBw/N84OOTOjqxK1icEqE5N2jpWOMgApBhxX8C9AdlrIoylghtnPhKeUjXHL9ImkwhseiJoanayG1Q==@kvack.org
X-Gm-Message-State: AFuF++kPYVScHNKKz2e2uSqG9W9h5hiso204jx435YVsx58Pd8q3LdLg
	thcufh+RKx2SZ6H2hSeRghIQH1tPv7NklktvXhIX2MK35fx9xpLFymRpKpC25ruAbx/XpS1M9F+
	5Km6/AoGL+nfq40vLDfDO0SUdrDOBw4KuTTV5hc7y
X-Gm-Gg: AYBFou1ezTfTCKpmD+6tMDy8kCYCVcxg7YH/apVyywmuPVp17iZ45If7jFy4LlZjwLE
	BiYYZ4TsFM/J1nBAH1/slU2ZmeTNUfUu188kkF+KSLDxGbQ1+XxmWII+hiS1fgM/ghawwn/Rnp3
	OzJ2Ed7GBS7LjphflBdR9cWOXo3TrnekIQ4ItfYbTQLCqedB6yrs9OVlak928UR57Ki9vvCb8kX
	iYa9HN9gIKDIyPUa3osuGqQrcmPpthGe03EJ/CGxF07V3ZVpskPuJEgeHUwkLu2Vq+eljz7FRx5
	pKPzR33zjYNVMv0QtN0juNZs/IujFEs+QPz8Q4nep08FIZGLokHofxf9ibaqY6jn32c/TpTSz7c
	YzI4ip1pD7Sowyu8IHakEkj1PUrhq399QStjEdQI=
X-Received: by 2002:a17:903:3c67:b0:2c9:d89f:fd98 with SMTP id
 d9443c01a7336-2dcfc8b4ea2mr5994885ad.1.1788967582829; Wed, 09 Sep 2026
 08:26:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260908122924.554373-1-tujinjiang@huawei.com>
In-Reply-To: <20260908122924.554373-1-tujinjiang@huawei.com>
From: Jann Horn <jannh@google.com>
Date: Wed, 9 Sep 2026 17:25:46 +0200
X-Gm-Features: AcwNN1U6pKRCcZHG_OtAcVvuu4oeGTBpNXmtE-x1WsR68kyrNbIqHnxmSXXMYEU
Message-ID: <CAG48ez29qhPAiEz2SHy2JDiOJcF2Xv8Y2prZNGxw4Q+08DyCXQ@mail.gmail.com>
Subject: Re: [PATCH v2] mm/rmap: fix missing barrier between anon_vma init and
 vma->anon_vma publish
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	lance.yang@linux.dev, riel@surriel.com, liam@infradead.org, vbabka@kernel.org, 
	harry@kernel.org, minchan.kim@gmail.com, lwoodman@redhat.com, 
	kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org, 
	wangkefeng.wang@huawei.com, sunnanyong@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: dxhwts69u56na9w9tz6usr9rjotxf3hs
X-Rspam-User: 
X-Rspamd-Queue-Id: CC2EBA0010
X-Rspamd-Server: rspam03
X-HE-Tag: 1788967584-375773
X-HE-Meta: U2FsdGVkX196BCA2d+W6Z+/y0oLeWr3TuN836SvPpwSyK31x9Nqfi82x1yRWaYE+71vkwNcsxNZrJUoV4sziNg1018j9Qcx+HAbPUN1nksyK5nUsAEWsnIEiv/MrRiO8P9OOToNuXrLJR1cLUPo9yR1OpWUKbTgE4ULySFE4hIEOYHMS6JzP8WmxkGPfQIxBntomHXd1k+BovYKjt9IoQHgl2l2xDfWVzaRXIsTFCab/m5CLqWC+/wPGFWBtDRkW34TGczssBUA8XVfPA4FCEt+D0CcG6E4FDSlhIOKxn80Uf6aXRE/HydFwKbubUgno67Pf2MZWKSF1wVPaRDaBPkhl38kznx7VPszFfT/D6a6a2+IlQPloaW6aGw+Xkbf0TyAHWixxAZDQcWjg8QQSIfLMLkQMNGqH1KUS8AqkaDFm/Lzwd+em5FVsDqtEDhzFL4U0Z8WeWz4d0fZiQVN/m2DWBeI8tHOHwCxPL3acHLqMH5VkZV1AxN+xR+E/3xNSKwlWjakic6oObbkLO5WgSOHMSWQD1SeUg+FNn5Psi/enLIlD5+QN4SWERHaG4d0nJhebA8Q1GI97VVotWIpi5b5csb4EqkktZdSaFrGWcGU1S+7st/lBpFrgRCDBgkJIgVyPgMB2s3SWLNkavPkiRd+cZqtyPvOaHfDSEYapu9JQP3RMofbQ673fInyMasE5FsD3saJ0gu2cZa/vyv+CVWgqueXm7E8N66VpYiXRCRvSDCMu8wb/ypIhHGhz5Qir7xNota/Wb8Cyq2uy9H8sW0GwVTXkmLtI+E3W1krdMEUQuc6kbP0YpEwXOgSWdrYTBWssLRlrajGr4p+86di5NIP45lLTY+xm8PznPOf+t+mTSuyz3tqH3pEL+YcdHFjBO+4kOOKFoMNLJvEvzwBjEMERz/3on+2PhHUBducsoSwu2tueLda3ePjvnGYdy+n3JQTRkR4k1jPnvp2NhGx
 cpRfLUAJ
 Qax/aNRqYL1dvID+ShHhRJrZ4ILnHCwKjS6o4dFa81XwGMY/o//PVEaTqegzbNAhduOoMGrdp3sRedCei+AZGgosJ8CJtJFurkW9W5i2lOeERj4luVJHaRJ9lM4T75bLMh35aGvPEkg/z5wo7BDU6I6x8l4kNNb/dWYW5o9Kmz7BBT3ev7u8EoHjoA7RuC2lFdyrO3ZUf1LISmF5j9CqvjtfKy4dx+NSKy+7fAL1sUyQGWWQ3GeQCFi84hHS6qDSQd5IpHVjYtzRaUgNUylDbfg0pSfQIzQvsXZZAu1BTh8y3h8guJmPjDX5gQua5UIa372a2v3AwOG9QBWplqob954FMYDf8pTSLtG4LW8INZG8IpD8vem9kBsnkCJPqga0OS8LjuS/9LQg6fb+sBh2LoUH5+RVRd7Bsg7BLcnr0vwvzlX0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 8, 2026 at 2:57=E2=80=AFPM Jinjiang Tu <tujinjiang@huawei.com> =
wrote:
> diff --git a/mm/rmap.c b/mm/rmap.c
> index d1819fd69938..f3b21aaa34ee 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -209,7 +209,11 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
>         /* page_table_lock to protect against threads */
>         spin_lock(&mm->page_table_lock);
>         if (likely(!vma->anon_vma)) {
> -               vma->anon_vma =3D anon_vma;
> +               /*
> +                * Make anon_vma fields visible before anon_vma is publis=
hed.
> +                * Paired with an address dependency in reusable_anon_vma=
().
> +                */
> +               smp_store_release(&vma->anon_vma, anon_vma);

Yes, this should go in. There are remaining theoretical issues (we
really should also be using READ_ONCE() in places like unuse_mm(), see
<https://lore.kernel.org/all/20230726214103.3261108-4-jannh@google.com/>),
but this is the important fix.

