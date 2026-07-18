Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CC60C4451C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 08:38:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43C586B0098; Sat, 18 Jul 2026 04:38:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EE7E6B0099; Sat, 18 Jul 2026 04:38:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 304186B009D; Sat, 18 Jul 2026 04:38:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 05AD76B0098
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 04:38:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7D1DAA037E
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 08:38:21 +0000 (UTC)
X-FDA: 85001245602.19.062BFEA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 96451160006
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 08:38:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wi4iKEHM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784363899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zqwjCLw2vDrdjdn06sas2daNCihv2UCAz/kTOrnOENA=;
	b=6fH6d6R/8vdsv4UUSGd+48/qSd47PfAtsD8+9TII9DIpTwK6wU9hk7r0yu19cNCOpGS76k
	ELPraY/m2m5N6xbR6JXiJ6J1t/yg/xFL2w580eRrFwBF/JxvfI3/1BzAhQCh1F9hq1Qn/Q
	72CyGnC9MyVey0oIoJcBiqwC+p47Kho=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wi4iKEHM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784363899;
	b=MgLYk/Y9jH9eHa6yXULelGJg3Ps1WtMmGqkwJaQdBPNRVn0mMlitAriGAMM7xZjzHot6cB
	fW1TlCg5XUaXzvQdzB04/+gf5p9zImtzT91Q+nMy4QmRsc5+HuJmoimu1i4u/kDo4+paH+
	/ggmW6y/uswHkg5IZ0bEhn0MtK7nw9w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5DB54436B8
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 08:38:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418AB1F000E9
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 08:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784363898;
	bh=zqwjCLw2vDrdjdn06sas2daNCihv2UCAz/kTOrnOENA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Wi4iKEHMFc8gWoirCokKVy4m7RRYD66RpTh1yXZZM07WtpUp8GtVmEVcliijkJ/ai
	 zidAut1kgf8dPRPIcZrQGoMbJQzsb/z2to9D/82DgVdeybuy0GnaIxiF6Kxes3u7A9
	 L41uvYRRBcqVlSp5URBLdAQRQLsmg5JoNil0Kxs6b0ow/SHHL8t9Dct27gqPoe+DDL
	 085FilV2BHmJ3gJ+mCU9+Q8vP3sm/1QmN+v9wOYARwd3iYGbYBcRnmWkrb6FXBp5Dy
	 ZaVn0XxA3Pv8eMCk7TllxGTk1cKhgy8pGd/rHo0Cwvn5AaMD0PWL1cJCSLjTKzfUdL
	 No2Ua/Rzg/Pfg==
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5218927884fso17902871cf.3
        for <linux-mm@kvack.org>; Sat, 18 Jul 2026 01:38:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Ron3x2YFwi8mazXmpEP5FjRx6cK4J3dPyIYyauvoR2Bu2VQI8xs4oc7QuCW6wiUKiwVAfxW2MWpxQ==@kvack.org
X-Gm-Message-State: AOJu0YwSE+0z7+qdno601wsyuz6PM0QRI1eLAU7yybnFcCh1LH10//DN
	Ht6rywJIbPyV2BKN8xG4BQ6WoXlM81+N+l4dCJs5w6g0mgIRPEIugB2Ol3fGUmoOnjZiH7fndMg
	iBngjr4RuqPZ4RkaWXyCfkJeLl4tdf5A=
X-Received: by 2002:a05:620a:a407:10b0:92b:6805:9192 with SMTP id
 af79cd13be357-930b4336ae0mr464331685a.74.1784363897673; Sat, 18 Jul 2026
 01:38:17 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1784268206.git.baolin.wang@linux.alibaba.com> <b9ef058305d1b5d6b811114830d17dd05980cef2.1784268206.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <b9ef058305d1b5d6b811114830d17dd05980cef2.1784268206.git.baolin.wang@linux.alibaba.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 18 Jul 2026 16:38:06 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4ybpWXvpmRDVRO8zvtAQE8sdSFqOyhH0gTkykPZY+UHPA@mail.gmail.com>
X-Gm-Features: AUfX_mwiD6jyV4TQkA9ZCMlNcCpOG-WcWRrtVjBxyP0bQnPxXrukWbhGi9FT6YE
Message-ID: <CAGsJ_4ybpWXvpmRDVRO8zvtAQE8sdSFqOyhH0gTkykPZY+UHPA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] mm: vmscan: convert folio_referenced() to use vma_flags_t
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	hannes@cmpxchg.org, riel@surriel.com, liam@infradead.org, vbabka@kernel.org, 
	harry@kernel.org, jannh@google.com, lance.yang@linux.dev, kasong@tencent.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, mhocko@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 96451160006
X-Stat-Signature: 5n8b8mgfwpa8q64mi19jzqbwzucdb9ow
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784363899-254102
X-HE-Meta: U2FsdGVkX1+lipOU9iSge0tXehwyU5CYu2pgp07clQRiJekoLDUKCmaPMFvd8a5r+qZ2Ar9zTs5Q7hehauMV3uIp6W6u2WxxOb65+x3vQNeCGceUpD6HgFQf4WDCrj8Xd4/m2C/yHhSJDye20fmj/R3A4Sye2HdZ/WMcYyi4Ho5RS0urpH1QQA/pcPWxarJxvubunTlcSxIBZHodimvwWU0y4In8YZAG50fCujG4xTiqd6uDGzHGcuGOzJLgioXUxhvCrMqUcaxQsJ4AaoU/teR91P1+cHxZK7RvQQrMk6jZXJ4R9pdwlAmVRbQrzTeKsBDny+D9Rq04sDPpBqE1fxMbL2a2O4puBCiOUKTBgSYzw3f40trcKkEvw4qvN3NgPe6IJqYQpmw7zvDCJzDZpunXbfqs1rstQT/hekBBsMCs2zZ2OHiihhZnSsIlpCHyCL0kHmz4vAuwIvAly55HU7GH2qYfUR/XasxOYWb9c29xlpfX+vitCRBb9NCQwLdiDwB6bDZpjIgipIZCCOjQE+v8Er+5HsQo1ctKigrjjWvM3N0S4QaPyQlgy+4xchpnurHtMXT3i2ggh9yYaMyGGIvxzLjO0nyq8KqimLJBdc1VutATVDZAawokrLB15ssN+P+kBH2/Qv/4edZMbHc6fqhUNefyS4O7m1rvs0D9lnB1Vf5xuKph0ELBjloiq3qXym7YlJW1B3gAiUIIWLNypeP0AA/Wo+sHFhpuPPsM2pfbaOX7l2jtEEDImPYAL0N+uvjF5c4glaFDsUYyuwNzzf9wC9Tbv3/EtCnfjg1fG+IgYcOQoxTl6wQy0BPTGUP0UAfXwByCGZXEBOuC/Eq0SZdc5EN6xUIOG1DmfW60frj08cm2O+hgKS4XSuWrCyQqY95aOfjfVbXH1fqqsJGeU/92uANjj9wqMN5FPI0VxxJGBfdXvE5EmeE+Xpgd4d83HCPZgRu8m63Yl4A38rV
 jXt7pGjQ
 KlxQPrjH6TFwsxuBhjvPCPgwXOpWwXColpP4jaf55lXU0RR5j8q5rzRHmS27I8xspwhCD+RM69Q6JLCas2aVxhV2riKKp9XydKFF5dOqf++TwIKp7loHSxrcTaEq2Iv6IW4P2zxbRaO/nPeYII4jNcctY5UTrLBVU9c0PIGhUBjd7Y/HmtHWtjGoEViO89NlKPn3yXCWJ5Q84dgIPjbIx7wbVUHl0gy98T7hrzQTfH1NJc6ZQhwEK78dJnIIk7OxKh24+MfGsWt4vdelZ04zK1yys6su6XfusTzFcfQfdMBsZzedBzsN8A+h+iML8xdhSXBtYkVkRARHU99rIdpiJNWAY/bCmkqTCeNlJGVH3aJp7nG1oQtVJr4m6jV9eo57YYrKr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 6:06=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> Replace use of the legacy vm_flags_t flags with vma_flags_t values for
> folio_referenced() and related logic. This is also a preparation for the
> following changes.
>
> No functional changes.
>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM,
Reviewed-by: Barry Song <baohua@kernel.org>

[...]
> @@ -1015,8 +1015,11 @@ static bool folio_referenced_one(struct folio *fol=
io,
>                 referenced++;
>
>         if (referenced) {
> +               vma_flags_t vma_flags =3D vma->flags;
> +
>                 pra->referenced++;
> -               pra->vm_flags |=3D vma->vm_flags & ~VM_LOCKED;
> +               vma_flags_clear(&vma_flags, VMA_LOCKED_BIT);
> +               vma_flags_set_mask(&pra->vma_flags, vma_flags);

I spent a couple of minutes tracing how vma->vm_flags ends
up in pra, and it seems to be correct :-)

Best Regards
Barry

