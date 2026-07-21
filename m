Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E1DAC4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 12:24:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10C846B007B; Tue, 21 Jul 2026 08:24:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BE506B008A; Tue, 21 Jul 2026 08:24:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F15B36B008C; Tue, 21 Jul 2026 08:24:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BA1326B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:24:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 46B4BC0136
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:24:54 +0000 (UTC)
X-FDA: 85012702908.27.99D0C14
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5A75A4000B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:24:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="n36ZgD/J";
	spf=pass (imf17.hostedemail.com: domain of rafael@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rafael@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784636692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KawtIA94ik5HxyTa/hmILJYqp75zatY9AOc1LY8FQ7E=;
	b=TKpMwugr4Wazk79w5SR3XmCD2fO1Sdgd8QojKrRdso2a+E9hhmbkvnNVQddAAT4cLF2K8g
	vj4MjGjy9ocXaZoSbfNrdurQtF0QPrMpmDM9nWslLEjaEBAxyhsYdYZgFm0sKUx/vE6XBU
	3OB2w3u9i0LHGFq+y2Y+nW9YXkbzjMM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784636692;
	b=GDLMZZd33dAEE/K3D2ZTpqwDmuVDdkt6JVzxX7pFFSV+gLrJaEEk/f3ASfQP29wNEqGYZr
	oOa/OJknk6Cx0k/czv+7xqiHJmlvnIxJtlSXF3OHE28LSQkJLzBfoTZJP3nOzv9N6BiKiM
	9o7hzI1vyxoXOeLQvQF3eUBd+PKPukc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="n36ZgD/J";
	spf=pass (imf17.hostedemail.com: domain of rafael@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rafael@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 87424412C9
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:24:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8031F00A3D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784636691;
	bh=KawtIA94ik5HxyTa/hmILJYqp75zatY9AOc1LY8FQ7E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=n36ZgD/J/DJ6W4imrSHq7VXXnh2lZMIAQwqQXHWaaq4ycfq35V1kvNKmekLH1lH2M
	 6Kg54Ni1sO/GX4eqsHJtru0xmGfN++J/R8zMwwOo8lZq2uqMrvQ6Iuc9JCpVk87+Dw
	 UJmBgDGMPalQEgEKCFmZhXxxgrMIGp1Nc/K8WQThm2NZdAKvgLWw9/KzspIBOMrNyl
	 fGFm2qAQIDN7gFXBsBSDcncHP/zdrjZhXdnAo4Yglvln/dX4QpXPMSm5GsqngHfZ6W
	 f8+3MtqJVyWYM1psEJiUakQat7o5xQ7tv8H+BNy0ew0qEk5eMnzf35nbgA3udQrebB
	 uxtdfx0XelhxA==
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-39ca300db70so86024411fa.2
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:24:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoNl516K7/1RNqfDQOenDCkl9iUZETSFYx2iv83renw9in4HiK7pe7ejd+nLG+F1LM5Nhqov/6ong==@kvack.org
X-Gm-Message-State: AOJu0Yxjk6gGC/GXlvyDIoZ6PCmquPl6WkJKRNTG3k3t6EVLemjvqCAx
	XnALFqCEIPksyt5NTXFxhQTjFMbmCVvNfdZw4FFi4Ps+M5Yd9ttTPHM2XFCgFd4kQ0ZjyJeLnYI
	lQzOcFOpNb6kpflWJW4KoWEdoFxhtU5A=
X-Received: by 2002:a2e:a99b:0:b0:39a:cfe7:d224 with SMTP id
 38308e7fff4ca-39eb287f10emr35824701fa.30.1784636689854; Tue, 21 Jul 2026
 05:24:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260630-b4-acpi-v1-1-a9f59c04d221@kernel.org>
In-Reply-To: <20260630-b4-acpi-v1-1-a9f59c04d221@kernel.org>
From: "Rafael J. Wysocki (Intel)" <rafael@kernel.org>
Date: Tue, 21 Jul 2026 14:24:30 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0jaRjxMBxpjAxZiKUXqdZ9W-d7yNC=4ifwA87YUOrdxWA@mail.gmail.com>
X-Gm-Features: AUfX_mxAK7A3TH3wQk93Zll9tA8OYKnbfa0WfFqey7JRWYnrWOXL32o-SJAaR6k
Message-ID: <CAJZ5v0jaRjxMBxpjAxZiKUXqdZ9W-d7yNC=4ifwA87YUOrdxWA@mail.gmail.com>
Subject: Re: [PATCH] ACPI: NVS: replace __get_free_page() with kmalloc()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5A75A4000B
X-Stat-Signature: tqzj3sifnakzz9384hdzbsgn7tf37a9b
X-Rspam-User: 
X-HE-Tag: 1784636692-892196
X-HE-Meta: U2FsdGVkX1+jtSFdLI15rf8WrSy+R2EROv2zmNaZ7dsNrW9hIiy5mm/P+nTRP5sA5QXsCiWnKFeakdEpsNyNgmfCHowlDCmfEy1zmIxvFgeNOd0O3GvktZwuzJAd99Bsg36In2p8NyoserjkWfJSgp2bwxbD73vOfvOsq8VG2X5qhW6wj/1wN2Ty/RwHZYU8daNtVhX9jh4BYMhUMQgb+zxQvWLI+ub+DqdKicQZYNUZyL4uE9+OXqH9IxuaFYmXyCtvykQgrKLQ2Z5kRZEQBM8VweSSQECdRTKnHePfj4JHqi/vOVsu9wKtxLU9V2ijZdYrGUvY+KrHniQTQlxPJvuy0nDJdrFdOqxdfEpF6lrwmipIZbneUFnYrmB0BvXq5hzH+8ImC4q0TMXPAyxIYl8jl+1TCenYacznrNZoLrX4d8JgdwxW627unFMRJy6zCe/4FYzLYVOaHHMOpmc4qP4W+4I+iVY0Jwy4yd2P96Z+UsffmjGFy0Kk+OHsBH8I0ktdfpEm9avMDysAlelYqV76hutxfICmkdfeHbym95K24dsIinG1ka/R80hxIzKkwgEeBpzJNKw6JG3apreONI+KoT6hwLOmb4R3PbvpuDEOOttvC6UbnKUfseGfvau5zYl0vUTpaaQOfNSyVUtgZwjp9sxvCJ6eQDmBSuuOu6/TqKxLBhbOcmCFpOJA/pJxPH2BP+sDJzXWWFjrQSrUQDCNIwXqL7hhr7kTVq1UOjcK2r19ec9X5AtWMNS6Gdqx9V2di2q3XkmBxHyBoX/0tXSvdGuChObCPdBp4YQGxLR3mygb+QJKC+3QG3fHFiJfq/JzAXfPzZpk04cFBiZ+7nxhfgXNf3wUS5oJXeYHMXeSZiXUfEklwqIWRYIOB8CyEMq3yfRCT69sB+4u9B8Xz7VzxtsmUL1gQWX8x1W9Vrnkzmp3g2/0qljaIW0MixA9874RtWE8US0KFFTKNGG
 QLGfmnkw
 rIycZ4jxnrlhYy7v6LN5Dq8s1/T16EmjvpBT9ydK3o0DZbZ9yXkT86Nr1osdRiIUs4rdg4stLWdT+EqobJgykmpO7z7DbQNh3faKCgarZSBd8ArU1kvKAA9nb5M8IuiSCi4pya/uugVsZtD0ogYJOLRz4sKAvHPJVPtgOCULxgi5B103fCIhiN5vw/dJw+nv278borkTIvT4ZeeNDqHxoDYN1pD+Ivm+Tr7sekzBJ9ZYN0/ve4AmGRf21P8oPtl+bQaTW7qk4mbEu2MF90H+LWqUI7m41pNCqqh0FKW6hfhcBxS+YilaQttWASZMMTB9OGwpFNMcwUY+ni+rfb2iAjeJ46X4N8sDf7ZCiRtIDapA0W5ji5jUf6YxNDwXUBRw3/quZxLnNP+vwYkiZz1l3eWP91Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 12:56=E2=80=AFPM Mike Rapoport (Microsoft)
<rppt@kernel.org> wrote:
>
> suspend_nvs_alloc() allocates shadow pages for saving and restoring
> ACPI Non-Volatile Storage regions across suspend/resume.
>
> These buffers can be allocated with kmalloc() as there's nothing special
> about them to go directly to the page allocator.
>
> kmalloc() provides a better API that does not require ugly casts and
> kfree() does not need to know the size of the freed object.
>
> Performance difference between kmalloc() and __get_free_pages() is not
> measurable as both allocators take an object/page from a per-CPU list for
> fast path allocations.
>
> For the slow path the performance is anyway determined by the amount of
> reclaim involved rather than by what allocator is used.
>
> Replace use of __get_free_page() with kmalloc() and free_page() with
> kfree().
>
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@re=
dhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
> This is a (tiny) part of larger work of replacing page allocator calls
> with kmalloc:
>
> My initial intention a few month ago was to remove ugly casts [1], but th=
en
> willy pointed out that Linus objected to something like this [2] and it
> looks like more than a decade old technical debt.
>
> [1] https://lore.kernel.org/all/20251018093002.3660549-1-rppt@kernel.org/
> [2] https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=3DNxMVnoFeHqYa=
2j1dYOMMGqxg@mail.gmail.com/
>
> Also in git:
> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kma=
lloc/acpi
> ---
>  drivers/acpi/nvs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/acpi/nvs.c b/drivers/acpi/nvs.c
> index 6eaad7dd0241..12aee4102696 100644
> --- a/drivers/acpi/nvs.c
> +++ b/drivers/acpi/nvs.c
> @@ -133,7 +133,7 @@ void suspend_nvs_free(void)
>
>         list_for_each_entry(entry, &nvs_list, node)
>                 if (entry->data) {
> -                       free_page((unsigned long)entry->data);
> +                       kfree(entry->data);
>                         entry->data =3D NULL;
>                         if (entry->kaddr) {
>                                 if (entry->unmap) {
> @@ -156,7 +156,7 @@ int suspend_nvs_alloc(void)
>         struct nvs_page *entry;
>
>         list_for_each_entry(entry, &nvs_list, node) {
> -               entry->data =3D (void *)__get_free_page(GFP_KERNEL);
> +               entry->data =3D kmalloc(PAGE_SIZE, GFP_KERNEL);
>                 if (!entry->data) {
>                         suspend_nvs_free();
>                         return -ENOMEM;
>
> ---

Applied as 7.3 material, thanks!

