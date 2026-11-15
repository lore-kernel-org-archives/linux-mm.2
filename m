Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D365E606A323
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BApUzOSF
Received: by kanga.kvack.org (Postfix)
	id DE7596B00EF; Sun, 15 Nov 2026 15:52:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBEFB6B05B0; Sun, 15 Nov 2026 15:52:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD4D66B05B1; Sun, 15 Nov 2026 15:52:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ACC386B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:52:25 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 38DEF1C3B30
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:52:25 +0000 (UTC)
X-FDA: 85438551450.17.7E32885
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 32143100008
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:52:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BApUzOSF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794775943;
	b=ReySd/2zt9J6rk4w71S9eku59N8JPWisfuJzSZq3NB5lyx0fgDyXMInWBLb1wpbvlLmzPK
	gpBP7+/aLDey9cJWwGg5vn6zaRxRFNqu2Z184ypfvVoQ2YfzYnHYOuWB0Heeqt1bylbiyX
	aVySXTkEhBiPPFDBLPejQs4L2EZAMYA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794775943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u/AayYsTiNYt6mqT7iE2EqkKwoSn9pQdkbKI6ZILgR8=;
	b=jxz+p9QdH55CkEvtslrj035ZN/Bc/e2TGy8y6VCvBfxiC1KxeI82MB/vfCY8ilSmNuDOp5
	qaSXSPS/zZZEGsIW7NeikEp6C1QUDyHdYZqsRqZRlyFvwIAZB1x/zFivPxM0K6eijn8tEt
	KbJzs+ijfOTZue/d6G4mpA8fV9MkUBA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BApUzOSF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5FF77439F2
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:52:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438D21F000C5
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794775942;
	bh=u/AayYsTiNYt6mqT7iE2EqkKwoSn9pQdkbKI6ZILgR8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=BApUzOSFrTeB5M/BZMRwMpckJyeCRdcjwZBO7NzEQqC/50kEG/LDPNIp9vhETuJOp
	 G76eGYelS9dsexMz07LwFVcrUtpS5NLYdf/5ksciheX+nl5XJL9wJZe3lChcWnovuD
	 Q5DSKtBjKgT8vU/rCFJftXTM8inADbP5J0ieCUoVw6XhLGSGHPm8oeJFAM/ymlhn1J
	 akCHeaty4ugqIR9FIqcxQHrRZQAtcdp7A8oSeUqo5VlzskapF7g7qQliDoB4Drqqmt
	 dOaOvWaz5J14Of7/8N702ZitJp14hxNe7vL7Vai8erOm8yQ0yyp8viZQDxnRq98HgA
	 DXKlN+9ZofxLw==
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-94937a33cfbso327889885a.0
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 12:52:22 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErE4GVAnFiC7kBIVvChr2QlZRnGQIEWcMeYai4QaIQ/yKbf1H9YboCrtohoVEiMeGugLV/Zae4awpw==@kvack.org
X-Gm-Message-State: APuU4Z+LmWHJbwzG4ph7nUe7S8SrbCNmoKoNK1l37NAFqyWaVN6SG5SJ
	D2NrfsVntfegiIJqgU5KIxaoDdca3QWJURXcO6ZRL+bmRsuDqh8OG50HCH2/3aCJjbutDF++2Ha
	9WzL42sSkjZY/MMCeyiOSQFaS6OMPI9g=
X-Received: by 2002:a05:620a:4607:b0:93a:2e8:5aff with SMTP id
 af79cd13be357-9494bbdbadfmr1497787885a.21.1794775941628; Sun, 15 Nov 2026
 12:52:21 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261111000913.22943-1-shakeel.butt@linux.dev>
In-Reply-To: <20261111000913.22943-1-shakeel.butt@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Mon, 16 Nov 2026 04:52:10 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yjZAx8x64dbfSbPZ96XEWJKL5v8pHxQMiAu9i_QUnM8A@mail.gmail.com>
X-Gm-Features: AclHuK-EujoA04rdzSgJCrEu29bOyojsuZv1EugGr9GiyaZaSxW-KoiDaQwxUno
Message-ID: <CAGsJ_4yjZAx8x64dbfSbPZ96XEWJKL5v8pHxQMiAu9i_QUnM8A@mail.gmail.com>
Subject: Re: [PATCH] mm: mglru: splice all generations when reparenting a memcg
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Noah Feldt <noah@feldt.systems>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 32143100008
X-Rspamd-Server: rspam12
X-Stat-Signature: 8umjqrgjgr5jpnh87mz5j9xxkaa5wadr
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794775943-308693
X-HE-Meta: U2FsdGVkX18u6VQu1YEHz7oo0MTYZXcXv0i/3BckHOBp/mX0K1L7bdJiv7f/VUFIy4KezmxkuC/v/yNuXii8I4nFGpqS9Nlpi2Tx/kK+LDxwTvHCBhPHNGDwIDewLv8yV5hxXE07V1hZT17uHEW5jTFxNcOukI7U06MOlaA7tjj2uN/NTybCFC0NkFxDNCiPnwVEyWsvW3iUKfPXe0tibH6ctJcW7kgNZkAwQPP63szO0o0SXhigvQYOsRDd+N/F0iEGCoI+pW/QVo+LR8gECPvg8hc2k/qgN9ySUxQ7DFKGEUJ4/JMFtby16Yoq32i6TO7c8F7z0vLqgJpd4banBJyLYb45tNPZ54/P3zbUNM7+ADJr+ayMn1y7hlgP97D1/I+fPJGNQOSaW4D81iMCii/ZwIjBmA2D2bDEr/vI/TZgEIbMPmX3ghF4kjPv8NKxE9zctZpTudgXnHccX/Tffu6NJoCURP2ylGGFC0p7PS3ga27WfvdQ9NlR7yl5Kr9IzANYhjONr/9b2UYmdH5cjFrbpZNF6EA/RIB9WzkiQAyJPZ7ZWmsT5pIMWDIX8hf5UyKvC9EtWCKaWfJ9NvkZamrLdPTzss6eUt6vuOi9y2u/X4D0wYZYqEo65hL6NRflHezEik5oaUTOP56A+C6q/9ZZfkjX91KZexjXrUi3hx4wpRrYyQj/OZjqw7/mPueCdoo4GGcjJv8+CItSS5mwlJt6Mskkr5p8q6h3fmbQ9RU4Ue2z0X3PMUzc8be8bY84XDggFg/YE6XPyZMsYh2kHYXfdn0J9d13po+rCNx7+WUthBbhlich4iHM7oZw0soE3bZcXOZRyvk2Jzb98K6r5KKG2gNvDnR7joBN/GU81noFsW21t3YHxbh64DWLh2POq52ajq0dpOD2E9s6lYX+tI1ihQLnVtosf8ujmeYtp9S0Px+Mpf7AYjWRTZXtB8MGb4FooMQcnYi3/OvJkyz
 K+d7CpUM
 eGnIjVOPdnSxz/tVKeq2WOEXXBxdk3JiyuZxWUOiVcfnceg4g2d1RSffKfBDrlmhEvOtxZtM1Mh/QcsvkkmwTa84PBURH7UdEtyomkyv+DYkbPqPDWwPxGt1nkH33IqNPxouBI0xyUGn09H3VpOaJEDZ8ChDzorY98UR/EPOlFtZFZtc1OEoYWYMuZNs9gBRA37zjuxBMWGocpyDZarrnoh7S3WVIr24eV6ZViYy+g0n8ZY2YlYRDONuzchxvDjbJaZKtZGGVrSyM+l5vnN4qBG9vPekcVlllKnPsh+qFhijRehVkMXME1Ke61ujOWopLH90OYfKpBFGKBnD5Tbaknw6xjWloAXSSMw2hrkNUHuFbcgrLjVi2vx+RIQCAuAUTNlLmihDshZyW4FjCJfPeNv+lAqEW3Y+znARgxMxlnpW4V05pn+KxKdTcW9fTeYAxut4BcmFalb6fSXW0+iJHFy7St18BnCcZ/aCZjtLemOpWyGAn7maKqrvCDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 8:09=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> Noah reported list_del corruption on single-node hosts running 7.2.11,
> which already has commit bf4ade7dbd76 ("memcg: keep folio's objcg same
> as its node"). The bad pointer is an MGLRU list head in a freed
> mem_cgroup_per_node:
>
>   slab mem_cgroup_per_node start ff31bfa36a3c9e00 pointer offset 528 size=
 1920
>   list_del corruption. next->prev should be ffacf881ccc70e08, but was ff3=
1bfa36a3ca010. (next=3Dff31bfa36a3ca010)
>
> When a memcg goes offline, __lru_gen_reparent_memcg() moves its MGLRU
> lists to the parent. It moves only the generations (gens) from min_seq
> to max_seq, and it puts each list at the same index in the parent.
>
> A folio's gen in folio->flags can be ahead of the list it is on. In the
> parent, the same index can stand for an older gen, so the folio's gen
> can end up older than its list. Once the parent's min_seq passes that
> gen, sort_folio() puts the folio on the list for max_seq + 1, where it
> stays until the next aging.
>
> If the parent goes offline before that aging, the folio is not moved to
> the grandparent. It stays on the parent's list after the parent is
> freed, and the next list_del() on it touches freed memory. This needs
> two cgroups on one branch to go offline one after the other, such as a
> container and then its pod.
>
> The parent always has MAX_NR_GENS gens at this point, so every index is
> valid in it. Move all MAX_NR_GENS lists, not only the gens from min_seq
> to max_seq.
>
> A reproducer that drives these steps through the lru_gen debugfs file
> gets a KASAN use-after-free on the freed mem_cgroup_per_node without
> this patch, and no report with it.
>
> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
> Reported-by: Noah Feldt <noah@feldt.systems>
> Closes: https://lore.kernel.org/all/20261110132853.71228-1-noah@feldt.sys=
tems/
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: <stable@vger.kernel.org>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

