Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDFA9D2CE01
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 01:09:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2675F6B00BA; Thu,  4 Dec 2025 20:09:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 217FB6B00E0; Thu,  4 Dec 2025 20:09:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1076B6B00E1; Thu,  4 Dec 2025 20:09:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F0FB86B00BA
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:09:21 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A318251C13
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 01:09:21 +0000 (UTC)
X-FDA: 84183634122.28.BEE6466
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id A73D940011
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 01:09:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YzTvNEF6;
	spf=pass (imf07.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764896959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P1CMGYCKUig7gpcSJTE0d5scwAdKO9yGMHIMC90eJ0c=;
	b=GKn99LujT0Qg2X4JmAE4aYcDZBDqcf13hDlYoTYuhi5xo6BXiGuHXF9shi/ceKL2Ky6l7b
	NcrmkTDR6exFqSo9fUr1HBTr+ltuq+wnKIexTCtn2zRMP+hNgfShR8OuXMLwnqYmobbVmD
	kWaCMxvUurlfzy6mShmapDF5ZKDSrGo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YzTvNEF6;
	spf=pass (imf07.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764896959; a=rsa-sha256;
	cv=none;
	b=r9PefpqPRq2fsWlvP1qCvubG1dwf1PkZhHDkFwtTZUG3lPC19bR9tdzaDJ5gtg5+x91QJ0
	i7TiD/7h4p8kNsdkOMN1KmUQ/2V7F3Bi4k4kwwUYY+/72JB24E8z2uTqcl7MoBE7WHLkkv
	LywEkJimI2yckq1DlUP2wcc98vQ1EIU=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-42b3d7c1321so1012639f8f.3
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 17:09:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764896958; x=1765501758; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P1CMGYCKUig7gpcSJTE0d5scwAdKO9yGMHIMC90eJ0c=;
        b=YzTvNEF6/lXKR3Vc8w9d5iw+94ftkRabHcKQb1CRakaEjfeYoOij+ZK49Vt9INbRwO
         GpmAYuVwFfg2Qk+BDjDO4IhIUXnmuc0FgIW2gLsWJWrDBSXx60PB1GNkj++FEzOE9ezy
         hJXtxhSlJ4BDI4lzWPrglCaxUotDA+gaQcOxoWqc3DNVtgEccnG/IclXkAvevfxqiVwE
         sUJ56vfsePZYGuC8SxRILxi8gNnOyqVmP7AzVsvu5JZdVQwq4ZI1lQbvVqfyO32pX6UV
         wGKhm8CAnhQwQFlCN4KpRTKtUf9RsTDG4B0kuWaEFLtvSEoF3x/B2Nseo8QxkA5Dkkwq
         EAhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764896958; x=1765501758;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P1CMGYCKUig7gpcSJTE0d5scwAdKO9yGMHIMC90eJ0c=;
        b=VnxPYVYE+nd4lKAv5/4kbyvwRjxJC8vWH284F0r9bqu7HHBpzBwD5/dX9cGEPgb8B7
         wjQcDTDhe5uJsGl1Vm+1j9ljB1AFfNlxXswFJDuEYDDSCImG5A2goLTqu9Di+N2Vab85
         cbcd++GyOTik1UJ0jZBNZJ4fkONdQth3RlDvDMSrVR3xT8jeU4ZjXU/pDXpLP8MIfdHr
         6HryLN+H8E73FUAFCn14gM1quNxm7QGgCjhXwK28OccntE5kyoz/WYhU2ZaI6l0/uZrk
         I7/qevO9dQDSEa7xUP+reww56c1NQqlOiTUubP4KRpAJr0bmn7G0wnIVPP+Z6Pmid/zn
         syEg==
X-Forwarded-Encrypted: i=1; AJvYcCW49hqaSyaxhL9JnBkQxerTlHYuzV7wwbCsjKFAf8w4PAGXKcbshh80HwpOgob0FAwP+uU2T39eyA==@kvack.org
X-Gm-Message-State: AOJu0Yx8yP+sLfn3xogGvJFiHzKCa/Y9xrqo6+69YrH7dOW1GKVoSrU6
	tyXBD0tU4tdSHsGVfylRGYfnAKvb6iNsDmDnLMRQhwy6l6NSjW2Hb6c1172WUXX5sqXAP8ouJFZ
	Urg24P3Rj1U1rz68Baa3e/RgDpqS1xN0=
X-Gm-Gg: ASbGnctpBukedIDCjje6bbBYOsujmsDngkDeTCjEOpXhBxtjg5sJRVGI4yz8D8k11mf
	bjMgrIVvu53d1arQDqLgNAiDa0ajlg+7T7VY9UoMBkfjY0Zs4bNg4QPZO2YQp1JtxALQIweueDU
	yYJ/j1v8jgYOL3gUFrDrqBePuF7nqJ3UQlyqivYg4pkzQ705gLL39zCzsiAQqtUh0mFOP8jbBFI
	MVknklin75F75FacldvRY0CgMe4+na6WdqCanzUhke2Adk2/yzxD9zPJd3gtjnOVzz3f36H39JN
	vj1in7PYeRp/iech9NJCTNcsKaONcqEK+JMc2KljZu4=
X-Google-Smtp-Source: AGHT+IG7NRtC5NzLh6PjBtSNPzjlWlLqBillUgmBkpdL27TkwBaqjqvlRHVG5YbPeI/4mVrxrLB1QDd37dPHR1UMYK4=
X-Received: by 2002:a05:6000:2893:b0:42f:7601:899c with SMTP id
 ffacd0b85a97d-42f7985e948mr4707442f8f.50.1764896958124; Thu, 04 Dec 2025
 17:09:18 -0800 (PST)
MIME-Version: 1.0
References: <cover.1764874575.git.m.wieczorretman@pm.me> <873821114a9f722ffb5d6702b94782e902883fdf.1764874575.git.m.wieczorretman@pm.me>
In-Reply-To: <873821114a9f722ffb5d6702b94782e902883fdf.1764874575.git.m.wieczorretman@pm.me>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Fri, 5 Dec 2025 02:09:06 +0100
X-Gm-Features: AQt7F2pwGQslVbX98n-X35KQ99_jXpXs5BPWa6Oqbo-7MPEh__0kv49yZSFAeOY
Message-ID: <CA+fCnZeuGdKSEm11oGT6FS71_vGq1vjq-xY36kxVdFvwmag2ZQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] kasan: Unpoison vms[area] addresses with a common tag
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Marco Elver <elver@google.com>, jiayuan.chen@linux.dev, 
	stable@vger.kernel.org, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A73D940011
X-Stat-Signature: 4hxxdtdkr86dqc8jyiysz5aaj3wspea6
X-Rspam-User: 
X-HE-Tag: 1764896959-208767
X-HE-Meta: U2FsdGVkX1+BqAxX5LYWgmxuEQ7Nquh0KNTObHJG9Riyt96Dls/AIq/6nWj7R0OF8MaozY5PAF7IE67qIUs8TCIVnu8iHzkVF6T6eqH9RBqDfEIfd71iogw4N4oFMzZgcSvhrk8f1rrim5+Gcr4DTxIiKTLalFVRtvnlXrVQogV8tXsK9ko8I9w56L077kWT1QSZwNnPCTr/sEV5qX1a9a63FnmyECPjg9jXgP68VkcBBwpIwCdyY2Os/9dSXzOPNfaQrsyfgsI5MDkI0UFSjezqO7nYkPTwypOpwJfZbcN3V6/m97D5IYqsx2UPYP2bN+oJvDyl2FWGbr6BUVbdAxYSXRb4M/0hlEKUrOd+fOyasi2M1LzaZ3lpgUtZL9pTmEJhpGiiLu3r4C5VvszY7Nozu/MYh+Tzf37Qy2SmKbNvEYB8N0YmXB00bMgFVIomB7sUOZllXYRiTu0sRlPLhUeEzzOnO3pq5ic0zgxWzH1ZrGC9i1Bn8ZWvm5rpuC/4rcA1BOwq+JpCz0M6K9OVrlsRWrcW7iVsGGnbgvXDb8IJrEoVtBriRN3aXw4T7DbNfzDyT6X8FNtPBgjMn9uHQRnIfnn4egsyoXLAjZerRehkp6ne4+FTpEVJx4INR7o1/SQdgmD0jZZ0ykVKFMNX/yu4fYpxv5UHCZ7eZuf2VUeRaWbH3Xu2tLgN4YI9mJUJRuJGYnTnQel0ff0hc59lfgveNHLcnurmBlIMCyEL+AwAG0uT4y/aLvNok9R3+W/plW+Q6MSPp34okHb8j5KzpBVcFxNvxUj0NrJ5QPFhHvtv0OOSZagnLHf/UypkMbNtViITTJRCl4FHG+2c0NHQvYLWDEuIQ+QcKUdDjBQqmdfOal8ua3Ox/mTOcaeYE1cyQLpOjVu3HkZrT4DTDxsjk3gmUO+xiDMC6hv+O14zJDKXSF6udz5m/3yIFPW6rQNRbItrSidljTZX+USq+r6
 B2isc/az
 uOryv0qOIUgxjrYDaQwHitAsr0KxM/XUFyf4WhWLI6Y4HqH5dfQMFqjDraBKUB9yVe76ftAJBA9zx8kOKjo9OqBUmu/+aSCkNk6G7gEFovlEEzFwwQfIj8dn/Dtlkg+E/4wXpMDs2iXbiBVAu5t2bcZuF0nOV0Lsf6+fjk+a5PT1gnAXjba6XURvmclHmT6EGn02tpM9szh6rqKNJlbmEXgfRXjhvmgsaBahiWwtLtq6/xvFdc2mn9f1tPZtPGHvMkzIS6MSVvIx2ap6+jlyHuQ512r/tYdQEN8SUu6A6mDmV2whYdkqSxM2EXkqGr/dWIdHk00JAjXKH+zayz1KiORWBSE30BUMy1Dccwi1QTjAEBsgbhvtujHu6JUKYZhliF98BCLMmqqb09hQYbqbFKI5OrL04iughMHcJeDJqIA8kwi7vkWy/JTfKU1eUl5dS4YV1bcAnunoiRpirkbtHG+2LJ89sriRCHCv+W4p35Q52g/dvPbQBqQymNw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 4, 2025 at 8:00=E2=80=AFPM Maciej Wieczor-Retman
<m.wieczorretman@pm.me> wrote:
>
> From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>
> A KASAN tag mismatch, possibly causing a kernel panic, can be observed
> on systems with a tag-based KASAN enabled and with multiple NUMA nodes.
> It was reported on arm64 and reproduced on x86. It can be explained in
> the following points:
>
>         1. There can be more than one virtual memory chunk.
>         2. Chunk's base address has a tag.
>         3. The base address points at the first chunk and thus inherits
>            the tag of the first chunk.
>         4. The subsequent chunks will be accessed with the tag from the
>            first chunk.
>         5. Thus, the subsequent chunks need to have their tag set to
>            match that of the first chunk.
>
> Use the new vmalloc flag that disables random tag assignment in
> __kasan_unpoison_vmalloc() - pass the same random tag to all the
> vm_structs by tagging the pointers before they go inside
> __kasan_unpoison_vmalloc(). Assigning a common tag resolves the pcpu
> chunk address mismatch.
>
> Fixes: 1d96320f8d53 ("kasan, vmalloc: add vmalloc tagging for SW_TAGS")
> Cc: <stable@vger.kernel.org> # 6.1+
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> ---
> Changelog v3:
> - Redo the patch by using a flag instead of a new argument in
>   __kasan_unpoison_vmalloc() (Andrey Konovalov)
>
> Changelog v2:
> - Revise the whole patch to match the fixed refactorization from the
>   first patch.
>
> Changelog v1:
> - Rewrite the patch message to point at the user impact of the issue.
> - Move helper to common.c so it can be compiled in all KASAN modes.
>
>  mm/kasan/common.c | 23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
>
> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> index 1ed6289d471a..496bb2c56911 100644
> --- a/mm/kasan/common.c
> +++ b/mm/kasan/common.c
> @@ -591,11 +591,28 @@ void __kasan_unpoison_vmap_areas(struct vm_struct *=
*vms, int nr_vms,
>         unsigned long size;
>         void *addr;
>         int area;
> +       u8 tag;
> +
> +       /*
> +        * If KASAN_VMALLOC_KEEP_TAG was set at this point, all vms[] poi=
nters
> +        * would be unpoisoned with the KASAN_TAG_KERNEL which would disa=
ble
> +        * KASAN checks down the line.
> +        */
> +       if (flags & KASAN_VMALLOC_KEEP_TAG) {

I think we can do a WARN_ON() here: passing KASAN_VMALLOC_KEEP_TAG to
this function would be a bug in KASAN annotations and thus a kernel
bug. Therefore, printing a WARNING seems justified.

> +               pr_warn("KASAN_VMALLOC_KEEP_TAG flag shouldn't be already=
 set!\n");
> +               return;
> +       }
> +
> +       size =3D vms[0]->size;
> +       addr =3D vms[0]->addr;
> +       vms[0]->addr =3D __kasan_unpoison_vmalloc(addr, size, flags);
> +       tag =3D get_tag(vms[0]->addr);
>
> -       for (area =3D 0 ; area < nr_vms ; area++) {
> +       for (area =3D 1 ; area < nr_vms ; area++) {
>                 size =3D vms[area]->size;
> -               addr =3D vms[area]->addr;
> -               vms[area]->addr =3D __kasan_unpoison_vmalloc(addr, size, =
flags);
> +               addr =3D set_tag(vms[area]->addr, tag);
> +               vms[area]->addr =3D
> +                       __kasan_unpoison_vmalloc(addr, size, flags | KASA=
N_VMALLOC_KEEP_TAG);
>         }
>  }
>  #endif
> --
> 2.52.0
>

With WARN_ON():

Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>

Thank you!

