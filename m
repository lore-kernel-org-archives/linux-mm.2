Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92554E6BF1B
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 15:31:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E78976B0005; Fri, 30 Jan 2026 10:31:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4FD46B0089; Fri, 30 Jan 2026 10:31:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5C026B008A; Fri, 30 Jan 2026 10:31:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C40CE6B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 10:31:15 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7CB1BD4B5F
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:31:15 +0000 (UTC)
X-FDA: 84389018910.29.2C2A252
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5E77B10000D
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:31:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zg4f90t8;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769787073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/jp1htw/IG7UbxjDHjIbmKBbWBaGSqz56m/AljuJYxs=;
	b=unw5KTMA1JeaS/GqErC1IQp/jt8ms+jIM7VBfMGH2mW3MHbH/Q5QDv1pH7AifYwIzvzvaA
	3VJNLsiPdiqEeQk6vTXMyr0gh0hdzL/QgiQhsUgI9Z3L+XJrL117mzIjw7FJb6AFOwovzY
	OgwmfUOpjZHWgd9Mb98GsCcLLbKeIAE=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zg4f90t8;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769787073; a=rsa-sha256;
	cv=pass;
	b=Nv8yanbq8zx1ug8ZWeenwgW1i9Hjr0WyntoXepeRbIJSEL4ppObDV7ST4yWIy2Lvyghy3y
	t75uo+9Z8sySPw73ObKQl+eWJWr36O9JAKGmtGp4bTrrldKUHXU4QrhVpkifZcAe+8N1nr
	MO9VGyXLQOp04f0CXztO7HB9N7DuE1M=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-64b92abe63aso4382808a12.0
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 07:31:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769787071; cv=none;
        d=google.com; s=arc-20240605;
        b=EPxkb6ghyTBfZgliMHVV88SSekwDilYpYNgUFK2mvlkk5Xupx2Zzfl2zJJR7+Ew0xT
         WLI6Lq4rMriRVmTtA8grQYlWFtX5qvaEpFMyVgLBz6e5FGwOsjW7ypN8Xz+lpEl6ch2V
         09EgIzt1K48s/4dV/wZYEeZxFIxi8jhUniJBjhJKrshOalHPBkgdNDIBv/rbsKZKNvtx
         DD7S/H9aTm3TvLog80Dy9HPncAOSO9TQZYG74bc90+Ph26opEf6R4QHQsGI8ZJ4BfhIU
         D8o2oPv12fvpPz+fF5CY6ZxQnZFB6l8wUOx35klG/DfAuO9zIayfe7L+QNW4PwQ68NTt
         Ve4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/jp1htw/IG7UbxjDHjIbmKBbWBaGSqz56m/AljuJYxs=;
        fh=93kFg1MXbW0hqR/MdQOhZfZq85DQQ5oy4J3th1gwT+Q=;
        b=Ly8+5lH9qD42O1aAEzVIszYYfV9CU+eVOKeWxrd/RrLuw7q+EPtd9lpHM1G5eNTR87
         Ln/63DMhT12So6Tt6RbtJUC6Eir5mlB0xsGGSAT8cg6I51Oa2AUtJjRl6zOQENEfUE+i
         g1roxLEIC5H6TTCSGMpDnqzvk9XenPz6EblMgl82xg1gidZd66lBcWXd/mT/erqzEGkW
         a2qsVlGfGTynpqjJ/YCk8F3FOV8vVX2G6cXxsBxnZI7uQ20jzQuGReMuQnf6GDd96CEr
         IHF/en5/Mmmn5lgVgZfeE/Pqb2aWe6VH+LZPLuM7j6Ts2iKGKgNwcl3FD+S3X9x3vy10
         tkfA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769787071; x=1770391871; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/jp1htw/IG7UbxjDHjIbmKBbWBaGSqz56m/AljuJYxs=;
        b=Zg4f90t8S0IxP05vEiE/LTAyGyM9qse2OrW45AtAJQPf75wT9ksUFS08jqNpcEM3Gb
         mv+VVhM9Kj2k4arQ7CLIz7j+484r95FeX+x2S4mn4zmW3gxKsS3szwO84O17RoOV44U8
         ngWR1pxKUl1TTc2tp+QF8OqbSIqx927hzGYHsvTx37cFF5v78Ao6ZkPin6ESUae/+hWb
         iEwYRNtZD1v9yC8sRn/DSeRTFDtq33YTErtSEVopJOqHW+TyFgxjkClj5MyhuDSypO97
         BPAJFVzZOKPcEWBy4v7XYomv99vj4BJ93dzq3ZrRov3njt5kbCEWHeQLG646YYZ42YRz
         pl4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769787071; x=1770391871;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/jp1htw/IG7UbxjDHjIbmKBbWBaGSqz56m/AljuJYxs=;
        b=UViNU2VkgBqd3RK6Iia17I7ZBx70luqrr4ZtcsIL5hI0hlWwNmvUPXG9GOQPZktuDB
         wNxVLR06MOVjyG67MEZM+xcb5zdQwVVuJJlBy/+tOWHvTed6jL4lZavdhh+iqPdHDkb0
         3hQtLIKa3V8GyfBBi3CwzjeS+xRQCYp9ichLRkxDUHrqz8q8AcdEtIVYPthm3bQ7MO9U
         Isy9iHXscyh5n30ylviF1QZ2GSsU8YK/6sT5edRHd3GXWQUW+4GuzZiQtI2/u9o8VbmE
         4c0aeX/x/DdAJcaxhJBBthO02Gl7YBjKAVRsP9ZIl4nMytSLciMb/5d36ZKH/pNyNZ56
         ATAQ==
X-Gm-Message-State: AOJu0YysmTdDNlb9dD09qGbdp/ODelrLae4sU3X4exXqFYDphz/R8n8x
	Hfv88hPFmxPYvMfkUSoPtzVKYWqb3Xl6kfsSQT2Eyw17mhC3hG7r7ZRmW+IHh/s5UwrA/mIew/X
	kG4xwgtTDJleEHfMIpy6Sf98Ne5ZI8LE=
X-Gm-Gg: AZuq6aKtPphIyPhp8tCuaKX4DXLKSDDNE35gi5LhJPphVuE0RZjA+brzbRCIFAMVbf5
	I6zKtfk1Hyga/or8mV6Et4DWLH/tB0mFLYlylVszy1L9RzTTMWzwToN7SeFwKVcSTDybT/xXIV2
	QI5ftHnmt1eiskMGotMhrtacJNRtfoXFOp0QXH7kDkGcEBzJvGcOIseZiWC3DpcB0CsUvpHQttO
	Ku7lDGjF7YMq6e9hJWvirl80ozygLQ96Lw55ZNzyuWZRdQzPU/T8uUi4eUP+RjtA748POqsanzs
	2D6/KB+b6FciNLCafSLnKSDgtssl
X-Received: by 2002:a05:6402:2742:b0:658:17fb:4890 with SMTP id
 4fb4d7f45d1cf-658de557b0dmr1730004a12.9.1769787071346; Fri, 30 Jan 2026
 07:31:11 -0800 (PST)
MIME-Version: 1.0
References: <CABXGCsNqk6pOkocJ0ctcHssCvke2kqhzoR2BGf_Hh1hWPZATuA@mail.gmail.com>
In-Reply-To: <CABXGCsNqk6pOkocJ0ctcHssCvke2kqhzoR2BGf_Hh1hWPZATuA@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 30 Jan 2026 23:30:33 +0800
X-Gm-Features: AZwV_QjZMhJBI_R2y_49oonNj5dH1wKo6ACntyZadlvml6XsHGu9IjdeEIvs-NE
Message-ID: <CAMgjq7BM0QFvk3_D4qyggjJ4W_+nHAupQnpAYehGq50CYNJV7w@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/page_alloc: fix use-after-free in swap due to
 stale page data after split_page()
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>, 
	Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@suse.cz>, chrisl@kernel.org, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ikxbjxtasyq97cjq33x7gspdabu1dj1u
X-Rspamd-Queue-Id: 5E77B10000D
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769787073-502514
X-HE-Meta: U2FsdGVkX1+yA1VinTg1y+GacigS5iG1SU7EER1JWXWgmLL/W7gyrm6H8jMxVns94owi94YiRP4i8dQ2k3eDmBnV5wqp6iuuANqGftQ/oihEla7v9Xba4+qWLgfwht9ghWsOXZmoA7abVPHp0rzly5irF+Bu/R10nbtccFctKACNNXDgCqFKShj/DkeoYV3I4E8XDdaHD1oat0GXwLKqyXC4BRTzJhyzvickXKBeABIGt6aWAsV+tqF/kEqfgUiWrZSnSWuVe6LxKaOTde+sv+6eU5tlChOhkC5WVMg9lio2MQcbm0jY5fIclMPALo4TYaqdvgV8J15Do1zhJNf9lpZ8wTeeUaAFsQRphjHwQYHtjZQAQuOxUMZTP8gTKB/PlwcRVWntpcZ/wXHB+jw2bpZWrED13DwRnruJ78Y7J94M+4fn0Om13uS3mFliWViELLylkHhmwYTku3+dTRrRrkifUSC3OOOSeClWAr84a3/hvXkS3viYgIS5/9NSAkOcbQF1SuNEh334dLr4JRfMGzK6TdrKn0UL5IR5DO0psc0qVu8P7PwPfQNr2C9d2ltW2mXWKaOPh3ItI8QJ89a1GXWgzFlQAJJCGvLiMxktJKAHre/DHfHEMD0ePAQiwPtwpb5aKWn+gYxV0g26sCYoA/6GwpFprfUuUXAMauKm5HhRrVVgyGwPvQjxDL76v23EyAB9flydk70zKzvikbsaTkXJFURnvuP5ty2jRZvfoHN+Pfn1f6Mk+0QjWhOm0T0QK2eFoJ1Hik2kSAjIJFu4n71V9RsrwFKZHIr7d0GnnVSJC3f68Um+CgGMuif8kNYkP/RBDT4DSRSamdxm8N/XslPNmK/fUHJvi7ROsOuiHs6MnYc3xh6a6UTSDrSLdULWa4naKkMFJvnnyWL2XA2tE8tCJKLFuhTPkl+hajlfo/f/5UPr8c9uPaqY3L5S3AIfvDz/OIeXDIPgTN2z66U
 L3Hjkh6Z
 HG7UDWt8+ciYLd5WrB8OjHGc7CDEiQjFcGzNd7IkugJwra5qsLfqDifI+xz/XjaEZvKU9ikhWhReTD5Y+ckmmsnaS6JB8HlPRzBALPP64uSuz8DYBPdyoOH5DLMkVBHoSr6d+Ved/iftyfQoNUAmUg5ZdOuX8Ini8SW20DToyZRyAV3xCwQQJs/AWsainZ3hSC6e/yQLWCR6EXLPCKwsWKctzNmR5RhSqzxrOIT8yGKFpQPQwoonQYpWcWuwmIWJ0Jh/F7SBZ3dxwEuC8GGBwe8WSvaGjonvkvghEIxSA2NfFaxRRIrp59BhtooPnJReqkPrC4jpXkhYCG0uqpFA1FedZKM52PBYbGnnKcLHFelHATdFJ9o1sfYSLnlTp+lfj5GmEJSsz9tNNHtC5KjWBByyLNnRIeUxdNwNt9tqGOkGb+OW9RF4np2lKgLPdbj3O9N0wyebtgxG7eWIkxFoNJfjPQUQIPwYueSPJcmf/XEyt1GWX/FVKJm+3kzFvEV4CGAmf/f7ixjyiteYdjnJnetmK2k8FWLg6PCZuIeVDbN5Pm5GbGHu9wP4dtp/1Y5Dp7C7SyblEbIXhPFpabHnKLr4EzdUvA/rUEPc0Jwa7Romz9kvBpesyygK6xg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 30, 2026 at 9:49=E2=80=AFPM Mikhail Gavrilov
<mikhail.v.gavrilov@gmail.com> wrote:
>
> Hi,
>
> I've been debugging a use-after-free bug in the swap subsystem that manif=
ests
> as a crash in free_swap_count_continuations() during swapoff on zram devi=
ces.
>
> =3D=3D Problem =3D=3D
>
> KASAN reports wild-memory-access at address 0xdead000000000100 (LIST_POIS=
ON1):
>
>   Oops: general protection fault, probably for non-canonical address
> 0xfbd59c0000000020
>   KASAN: maybe wild-memory-access in range
> [0xdead000000000100-0xdead000000000107]
>   RIP: 0010:__do_sys_swapoff+0x1151/0x1860
>
>   RBP: dead0000000000f8
>   R13: dead000000000100
>
> The crash occurs when free_swap_count_continuations() iterates over a
> list_head containing LIST_POISON values from a previous list_del().
>

Hi Mikhail,

Thanks for reporting this issue.

> =3D=3D Root Cause =3D=3D
>
> The swap subsystem uses vmalloc_to_page() to get struct page pointers for
> the swap_map array, then uses page->private and page->lru for swap count
> continuation lists.
>
> When vmalloc allocates high-order pages without __GFP_COMP and splits the=
m
> via split_page(), the resulting pages may contain stale data:

So the problem starts with `swap_map =3D vzalloc(maxpages);` right? Will
it be enough if we just pass GFP_COMP here?

And worth noting, mm/swapfile.c already have following code:

/*
* Page allocation does not initialize the page's lru field,
* but it does always reset its private field.
*/
if (!page_private(head)) {
    BUG_ON(count & COUNT_CONTINUED);
    INIT_LIST_HEAD(&head->lru);
    set_page_private(head, SWP_CONTINUED);
    si->flags |=3D SWP_CONTINUED;
}

