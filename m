Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 980BFCAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 22:31:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 002B88E0002; Tue, 16 Sep 2025 18:31:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFA7D8E0001; Tue, 16 Sep 2025 18:31:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE4838E0002; Tue, 16 Sep 2025 18:31:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C9ABA8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:31:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7ACA21DE2E8
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:31:14 +0000 (UTC)
X-FDA: 83896560468.03.EEF95F2
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf30.hostedemail.com (Postfix) with ESMTP id B22A680012
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:31:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eSHkxwTW;
	spf=pass (imf30.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758061872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wVu791aZ8rwgtxvUL5SlLK827bghZulSR52djuOwSHo=;
	b=zv8jLd/uI6BWCSvB3ztP3aj9wYbZNF8Mi0dN0jAYsxdauza+UpfT8sp6tzLOczArBrpkbo
	7gxI5cDeiYPCiaw+fJxYj7XJvZPcvE2kuj8qvLJpcOdzVP9CfxKXp4rIV7cRPEyj8IH1bZ
	spk6JkNPXSKeqmeC00L0cKm0J6/1X+s=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eSHkxwTW;
	spf=pass (imf30.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758061872; a=rsa-sha256;
	cv=none;
	b=u8AxHt/lhVQ5z38CShOo93Dxsc1ylJpV7cZJzxrhQww1Gnx7twv3y9fz7NL+B0T7G4uTUk
	BpM/g4n3ddA8ENiilspXEAN9vPkY0e9M7zC6TJ3mmUBS0gGp9mj8yzlm/V06imVGpFTrsH
	EwFSwuqZ8JM+W3tpNQx3tbYy6HG+ctM=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-816ac9f9507so36809285a.1
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758061872; x=1758666672; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wVu791aZ8rwgtxvUL5SlLK827bghZulSR52djuOwSHo=;
        b=eSHkxwTWPg6vRY1Ru+wY1zHc6oN9ijip2Qe+xds0gwRiX65p9jL+/ZR9mym7hGF8nC
         RBwNe0AbzraraaOhhj8tMOMmqDveT7VTTpvmwFM0+R2mbvbOpxVSy+QQ6xDjblyyc1wo
         L+L9ysdsVR7TfHGZlwpBSx3y7S4vH6TcHypKlomwyymV2eIO35uC1SuEDq9826pb0V/i
         pDfElR8ehQ7w4qVGfZa44mlpydCm3fqUINcR3vg9YU/HSNj511ugBL8ZT6IK5/VKuLdb
         7lpKZlqS1QxMv5Z/by2I7M1MO9jMPBdBwiFnZJUY41oyo3t4leglMYZaiKBLuYQhLtV4
         k+cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758061872; x=1758666672;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wVu791aZ8rwgtxvUL5SlLK827bghZulSR52djuOwSHo=;
        b=BF+X+HOzjqg7w3VAdZO6K+HuufvxZH4deN99Z6fekWMiUT8hLxKO+Ljfz1RceZXckr
         g2k4x3VtLDYozGw6aNXLsWosmebF3dl/1/Z2SbyUHxYDVU2R0ZLCSbJlswSQdWUNbvwp
         BTEzr9jSnnyP5NYi6mcab+CjzIzfzys+uaWq1xWMGBw+HTYsRYtuWoqL1KOPKoAxZtZC
         DoFaHh8wwVtsBFd4Ia+1PeOX3SItc5+GTCnGIWA1RWK3xoOG3ZNgctEG1dgot4l1Qp/W
         BSQUZBmysOXpcCGiHkQsiRPfh2RY3FF2eQkFWh/TPBqZQj1CorlPr8BmNmd2570Ts76x
         O0kA==
X-Gm-Message-State: AOJu0YyA6xyQWsKECemN4ZlAfjai32in/RU95tKWXUFds3T27++AZXZB
	mbgiLzFNI2r4sSSzLkaaDpoMrldIX4wyzuYVhC2DHoeLMzutzF6HHCs2LHwWVQoO83cyicLp1mm
	f8kRRpBMYbaI06Ts7olJIaYs0thG3BMs=
X-Gm-Gg: ASbGncv4hdEabULJFBYRMwdul3VkUcjwdhBPNsV5e/iVfa0T7ogfgFOzEf26vNEJCE8
	lHHUZOwDWJEkYus73pQHbYAjc8f/baze71UVcvhtUgp+X8HjRoqboE4YYmi0BHsfCeZxc5oSPme
	FBYgbVQvGepbxGYM8J//O8kIeZgDORy4ozv+4DnlMtmUUn+RvrmmInLdND5j9OpFo/z4ejhYOqr
	jzYfPMPiab3BbeMiCuPVAvyuODF4yMkhCeh6ZUQdw==
X-Google-Smtp-Source: AGHT+IFIRssh1dOgOKjza1bMxgt39yDVYAyE4daOrN2DtM1F7DovO/IaysRsYWeYGfTW4CsCPbmXrBVEP2SojZmKhqQ=
X-Received: by 2002:a05:620a:4624:b0:81a:bbce:6d39 with SMTP id
 af79cd13be357-82b9ed54ab3mr492130085a.40.1758061871739; Tue, 16 Sep 2025
 15:31:11 -0700 (PDT)
MIME-Version: 1.0
References: <20250916160100.31545-1-ryncsn@gmail.com> <20250916160100.31545-16-ryncsn@gmail.com>
In-Reply-To: <20250916160100.31545-16-ryncsn@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 17 Sep 2025 06:30:59 +0800
X-Gm-Features: AS18NWB7adgYb7oVzvL1zIv7CnUkXbq-89QDCv2evtv_By4LbIsvCSvGNRnSMr0
Message-ID: <CAGsJ_4yrDFAe-3sMj1K2JeWrqNXCBvYvULY06b6B3ogSYjqasg@mail.gmail.com>
Subject: Re: [PATCH v4 15/15] mm, swap: use a single page for swap table when
 the size fits
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: z1yrcpmxng9knah1gsgkupz8dbxwqqr6
X-Rspam-User: 
X-Rspamd-Queue-Id: B22A680012
X-Rspamd-Server: rspam04
X-HE-Tag: 1758061872-518534
X-HE-Meta: U2FsdGVkX1+0BCnz1UldkUpjjE5YN8IP9GHJm5OGhKl4zZtvw6YtJy7o/Fdd+Sc2MkffUbltC+4wRDdLXZStdj+ZsONlzBS/1D61rEnEHzllHK1Ca1HOZMzjWo6zSSUeS5/W+hDP0pjmw3jZCh9uhk81cIfJEZhBwm/D/5BjJUrTkEy1GJlrsVAw1xjA9vsTFT8fQWRXbd5jSho1KVTu1v0XvI4sesmBXFJfLefFKpq9/YAoYZX7R5lHdq5QP0C7St3ipaN593AZ0+Dnz2LgOMQI3uQo8D6j0+OKpj9YrgVPBkwJqa/r//6EvdDH1EfbA0pRzBwshGPuKVjD57P5ww8/9UhRNDcM2EhLKP7Xhgs5wHm+eH2z2F6DX4Q9P2R8ZxrglEgV51fk6qUo3+S5PkaIkK1cEY6sYAmXtEJsqGEEHh5NL1ZN0r0Ht5fWq/oGegIfOL/BwF5J7XhastGmz1R3phZ03xHHYFwJxj2aiqN8iYydN8fPDbRD+xmG7y+oWCwf5NUiS84/Y9tPkuD1cQiElQudpdc/uiENPIOY0i3UebImH8QzjgDYEwMPqZQJibNy2/WtlpLWd9uaLt9ymaWqoe03DCU/4emXuwS/viBMVcVGX6wPSn6Erw4bw4ZGoqc80RDlf242eDdkpeX7E1ymRRLmSN4w5B+grzwe+g4jFFHLLSTDj7UsYTdxpFfU4deX3oRSO4HY7ycX6nZOanOqdKshbiVXQWQ1qIL1KzG51MthRVaNp9aAr7rw0RM2oTP2nfZqyH97mjdpdrXt+ImZhmIrSwQ8Ji+Ce2FovXeoF80TNbgq42RlZhN4ldU11lBSgsDKglo7NQ4ph/oRjXQ80EsKoOcgIhanZgQmYOSVNrfik1hhsxCDE/YuqmtVmC9UcZZyPOA7YVFcVqTGVMM7K5TxmCS0gx8sctSyWkZwTHQ0JiD5SJsk9qwHF112ZCZAQ14xCzQSTj5/5Nd
 PtsVk9lk
 pAXFiUfExvoNw2zPWOQACyE3RMie7eL1Ns10sC9RF8uyqUdbkpdI1lXc/vsHLJXzwiJ9taVKJhQhfgvDBs9gCXDLhX8aR5GiVLWA4plkWnMD9xqa7BRgmmqgxaFYMq5+1lPUMMcV1KUI9iDBxVc6mnpjq/dVLobGh+hf/wAJVCV0q3760UPm06fuoWimzoRhgoaqW3OrtNKmg+tH2EyPd1Nd7yoQkCT5FteWcIC04z85s4hMzkoK4OMYapZ2nzyXKBSDike1g+aymTl0mEXv+QYQO5ndSMrJhPQEPK90AHr4Qe+1Cv9jqrBm8JHZ9mCi0svW8N7zxUdbpEja/D9wk7geYjx2vI6YeiEtiiSohK7Op6uJ7nHce6Pjjq+DaanL+VmuipjaJ0c5pZLylMOz1z03gIpXBAu/YhVL6q8VBJym/Y85kQDBgk8Z5QF2DlAcAvNxuOYqn1oDbwwg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 12:02=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> From: Kairui Song <kasong@tencent.com>
>
> We have a cluster size of 512 slots. Each slot consumes 8 bytes in swap
> table so the swap table size of each cluster is exactly one page (4K).
>
> If that condition is true, allocate one page direct and disable the slab
> cache to reduce the memory usage of swap table and avoid fragmentation.
>
> Co-developed-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Acked-by: Chris Li <chrisl@kernel.org>

looks good to me, with just a minor nit noted below.

Reviewed-by: Barry Song <baohua@kernel.org>

> ---
> +static void swap_table_free(struct swap_table *table)
> +{
> +       if (!SWP_TABLE_USE_PAGE) {
> +               kmem_cache_free(swap_table_cachep, table);
> +               return;
> +       }
> +
> +       call_rcu(&(folio_page(virt_to_folio(table), 0)->rcu_head),
> +                swap_table_free_folio_rcu_cb);
> +}

Can=E2=80=99t it simply be:
virt_to_page(table)->rcu_head ?

Thanks
Barry

