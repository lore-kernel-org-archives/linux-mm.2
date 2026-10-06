Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79161CA5FFC
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 06:31:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 884066B0088; Tue,  6 Oct 2026 02:31:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 834DA6B008C; Tue,  6 Oct 2026 02:31:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74A8F6B0092; Tue,  6 Oct 2026 02:31:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4895F6B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 02:31:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C0FEC1A0563
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 06:31:51 +0000 (UTC)
X-FDA: 85291230822.26.16D20EF
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf16.hostedemail.com (Postfix) with ESMTP id D3B76180002
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 06:31:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Nxfj9Qcp;
	spf=pass (imf16.hostedemail.com: domain of bgeffon@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791268309;
	b=eIlXtmcOb8YBBOsOklanNv2bOjn6VKpfE0qoMAATl3//1i+cFOIwIfENvdtmYkIbtUaq2z
	Ios5igs/5z/SGdSIcyac8yHVm+1BqaXKwYvqis9fYObccPpeRdYtoKn34K6nSkqQyDL9Xy
	7BTxeOLHbpb4W8KsEVwPOvp8Lf3S6ys=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Nxfj9Qcp;
	spf=pass (imf16.hostedemail.com: domain of bgeffon@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791268309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T/qMNv6LWR2p5Dhoh0FprqlZAOF+nV46g7vnoxCUDTw=;
	b=peXAQdDPEcF++LgYJAzGJHmZ4bBghqacWAXQfcBuRLqc5LToyID/M/ZmcXDmoIk/f//uAZ
	Ym4RfZEBzHvGeRp7R6ZLERFbfMYD4SWAG1kcUVxN5tOTN/ilhgz9jdBDYSbEbH7wrU0mMr
	78271dA4X0NOSrzqN3clkBUnhJlURsw=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5351f9dbfe0so86481cf.1
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 23:31:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791268309; cv=none;
        d=google.com; s=arc-20260327;
        b=kf+G1dwn12aQcl9fDq+4V2+f8XS0N5VwBF0hY7xO5LEFQMieFLWQh4geVs+jmJadbU
         j6QzpAKYTSyyK5owYnBVNOdY1Ywh9XKcSk+eUBKsbwaW1OufpqJxL/iPjE/Df2/7UOGc
         kmr2429o20DIWnGAcnaX7XLPZc4habL1B76pDz8tySTW9nWQFT0Hl0uG4J+2XOv2am8N
         kZzOSyey2PKupkQWJIguOL7LsWCXk6p+j0uZDvWi/GFG1VzNwHC7xBo7HStCYJammlZ/
         Kf6SbP6zWMGO43kWPKJZ0o26vHSVnQv5VKegpbPJk/vyjj7Qhbaw5qaYUqKx011CJoUI
         7K6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=T/qMNv6LWR2p5Dhoh0FprqlZAOF+nV46g7vnoxCUDTw=;
        fh=jVL/nHwBMrCbZXz3gpche4yJe0pj3njfh36DQkxdN3w=;
        b=EIF/S0gl68M+goSZPvxtENN6ucSovJs1RY/g2aZ1amxrxzkBdWFSzWzZOaNrzX/5ic
         J643XKkxbrNlB2j9jU/2rr+XsEV3RFQvRtHK4KzPOUPeMhjQ3Ej4q/s4tdb+YRT5TdTi
         7DowV+Ns89ZkUIqRr6lh4et4rtX0+YGmu/QhPoCZGXMAjjNyJNAEMlg7QrB4Xlyvf51w
         b/j2lecZFy+69akLL9650cTf0iIp70l/mtg4TOXNO4eiPoEDMICsIrNoG6XKFc2IVOmF
         5G76phROIOBTAH9lsTCzbBq2n/UkXBDXxMJe/q5N5a5kuQ0iUmNMTLFCENEXF24JxW4t
         ZWSg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791268309; x=1791873109; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=T/qMNv6LWR2p5Dhoh0FprqlZAOF+nV46g7vnoxCUDTw=;
        b=Nxfj9QcpIZD1UrdWxYMU1r0dkaqKmOe4c1zDH4wpRgAGnaVm5J+6+AOeRWStKjz+DH
         YQvhwGS2wNs2cFUfSZMvjHVJJsGb32PWiAQiBLziVqD7c0hrkFjtdicNyCHbp9M2pBdJ
         MFsGix3KcBQLfGlbNZBJX33+yKhilKlGGYfvrJkhDbQeP1tWdBqYzRg/85QRtIreJi5g
         tc9fhBAlhCqjdnnfy6Z2mzrJ53RX8oLQohgDGg5ArAPhbyZW8UfUxoTcCxGMjADBRyPe
         IIGLwGeqlCYEx6cqCi86TgdEGW02bIws24Dpz32Btjs0K3PMoTIPY5/dIapalbq6C8Tl
         bOJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791268309; x=1791873109;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T/qMNv6LWR2p5Dhoh0FprqlZAOF+nV46g7vnoxCUDTw=;
        b=vU8Y1XYGUk8SXxWeW+l1P6GXWZxBONjEoFtprLRxMZjD9GetUhs5TxLQhQrXDpUvpC
         tlSj2ZJ+sXqytyQpeM5oBLhhsjmiEhHnbGqo1ziznEZP4iGqrKOmbdcxmwtnsEvjxlPk
         /iO2SQ7X8eCoAvw33FthJSsPScPLUGj1lliWzptIdBP0ppn3Kq9PuNVHPAsQ2yOrAWcT
         w4JGIc+/j3YejVQWX5KtRg2Ia+7qSPGm67/KZUhD+pzkzGXEqMFfo43BF6hiL3ZFlOYu
         bJO5jqIZcXWqBYc/lRRL4cg+PhSNYo7IqqbCbIRRhXvkIrJVfTcRaPKE7ooJfces0DsN
         JNuA==
X-Forwarded-Encrypted: i=1; AKwUvByRd7NAawq6K8vpioGsBY6mxumODFVR4VpVGr+B6TYHKvPiQKuMIz1aFsMZrz4RmGICBwFAuZoqoA==@kvack.org
X-Gm-Message-State: AFuF++lnilLqPPLr9ZtR0V8OnLVN/MExH33X41MN+HKPwwVVsVD/x7Go
	Kf4E1UI72ntJrKeDGmLCG052FUGyc/78CNE2aP120v8v4XTDEX6B1KTpc7hh6CH0Vlc+XVHEWeI
	B5sj4tqXlEsyBHvkiTVo7+6MAHbZhC6oeNkEQhmCX7s7DJIsbuakVP7QoQBc=
X-Gm-Gg: AYBFou0M6yiQ0ewArtLHhfHgpXZr3FNJLNOQKw3hBkFzRwL9mig02odJDctUm+5gNeJ
	dU9/2ObbkBWV2mCylowV1Dc7VkjgCvlieC9YKI7I2Y6wuTBjei8P23Z6OHyZUUxXbsoHeeO5ZuB
	lrsyK1/tkWdQiboVsXB6x5jkXlvjx3QkZ+w70dgIHOydyH8YtzJzntuvx5VYmbAs+t1qxG0QM1c
	NJ7eyTT7yQn+9NV8LV89MUW1haghv6EnhNoeCfgauqHEsSV8c+oC/re1rJJ60w6EWYIcuyeLsJw
	6qaRFwmhwnCZdzbhkepWYLCtJamI+ADFhVn7lsXNEBMIuhPE+3IJUtegPfGeZEWoXnVoQ6j0Qj5
	VYgXRlGHi9yCDFv1oIh1zXB10WS6o18DfQQk4mjmihVcTxcQ30O+lPvZ9bo8sKbZJ/iQYPvl5zP
	W9qJygIYMPBDLfOl16kIdo3mnsCcw=
X-Received: by 2002:a05:622a:60c:b0:531:34b9:2532 with SMTP id
 d75a77b69052e-53540678576mr9157571cf.4.1791268308385; Mon, 05 Oct 2026
 23:31:48 -0700 (PDT)
MIME-Version: 1.0
References: <20261005122036.718976-1-senozhatsky@chromium.org> <20261005122036.718976-8-senozhatsky@chromium.org>
In-Reply-To: <20261005122036.718976-8-senozhatsky@chromium.org>
From: Brian Geffon <bgeffon@google.com>
Date: Tue, 6 Oct 2026 15:31:11 +0900
X-Gm-Features: AclHuK8GDz4mlY-X1mZLOSHDZHkzlHRRhdhy6_5gaDfAVaftmiXzawHiqYiSonY
Message-ID: <CADyq12wsysqxEy_7wms1TyHVXOvpmS88WoO2_N3_Cgnr9vF9Zw@mail.gmail.com>
Subject: Re: [PATCH 07/10] zram: zstd: do not use kvzalloc() for zstd allocations
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, 
	Richard Chang <richardycc@google.com>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D3B76180002
X-Stat-Signature: jnqpi48q9cixrn7kbbzs75ehf4n7851j
X-HE-Tag: 1791268309-244458
X-HE-Meta: U2FsdGVkX1/mK+IGwljNHetB74noTL/aAOY40JsoJO7bGoybE5AmVWycfCaMFCuuQYM63ccCgthHwBX0Kf9IGI5slf4aUqTtqreOzsJaYVzGfV4nfxVuHQoxGs4pqGG/aq+PEhy/mxFzAfnWg+JxIwFIz2UooPf0GT1AmVi5s27syaZg3Z2KUDP5VUXiRce946MW7/NnCJnW/q3hi6ThW3VfcSLonHX2dXjDIGqcF7fYuffEPmer9o9LtW8ZRWREfR48J8qj8RuPRxMyn3AA2+4Hcv0JyGrkpDI0C2GVTfyEB/AaCvnOAYbBta3Z3XCRm25DTev8nx9w+55V2EF2t6SyS8q+1p3eb8f/LKfPsGW2mAQCFSGDbVTBJDNnUWpH0r8X5iAICAZQ3QUJTkaXj+fbCEd7HUQrdNJmKzRTWMNZdteTFFCjT4730mq9l9xC+T+1jU5/isPVnLWarS1pTkLz4m0vH9cVvjpKvQ9Gd26Mhpsya0CIA/phw51v7ZEFzE8gIZg/A6VGVmu/M0r3S0dfnlH64n22d03lAdb2zC+NDcwm72cyJNwkUjnfmHPyuVd2F4jZyqjNTPn9QN501MDf6q7c7TKcp0kxtZtWwCRu2TRsYb3kHaA1o/o55XpgGmg2hCdBe8ieZOTJAdNEuPYlnq4rEHsfyIYGQQODTIaiwBMu7N5/r1B9iimrVNit8o3gNkS/67bEHBVhc52jS9AGXzkEexkgPwKFOocVjtKQuEEGNEIIthc6fEjHU1071fFdSY0kXu64oSwmo1ev6QEQ4JdbVmiJw/ujumnwhwYACRZv/ts40HzUMzNK4KfcLznFTnOavwOw2gnbRFFeUFn7YIAjqcpAOGNslfjwmfbY1RnIUkrqVOmHdHJQyeDTBW2gNfXnrTIMXDpUgB3I2EX1G1gMfDw7GbsGqmjVkwJiwZZ7rVB47FAX/jf/XYzSLda3t8aVPWwbg4j39sW
 ws1UaLSP
 zfoHAEWkX5eYT/kwu90vX4AwS3kchnheFhP6hP1anqdJS4fgDQQ4VCg9j/ndG4vWKL4puBfggx6btVsCUS3Sfg+7fTBb7jEH0b/c3HXrsffocs51F9MfyRVevmoBRf3z4onK10JsW2vMZLJ6E93lnEkgn1FhltOm4mqlxhcw6081LVUVQwxIaRdpyDtwqdOpXZoO2WHQNlnnp38eh7jwawYPUa3+43V1I/UJsaqt+GeIfe56BUwNheTYOuhTIFbYDSh4UawhrugBgqscl9JIrtTA7U8AWeqo4Rdb3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 5, 2026 at 9:21=E2=80=AFPM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> When a dictionary is configured, zstd allocates all of its memory (C/D
> dictionaries, compression and decompression contexts and compression
> workspaces) via zstd_custom_alloc().  zstd_custom_alloc() uses
> kvzalloc(), which falls back to vmalloc() only when kmalloc() fails,
> and kmalloc() rounds such sizes up to a power-of-two number of pages.
>
> For example, on x86_64 with a 110K dictionary, switching from
> kvzalloc() to __vmalloc() reduces allocations from:
> - CDict (level 3):            512 KB -> 400 KB
> - CDict (levels 12+):        2048 KB -> 1552 KB
> - DCtx (per-CPU):             128 KB -> 96 KB
> - CCtx workspace (level 3):   128 KB -> 84 KB (per-CPU)
> - CCtx workspace (level 14+): 1024 KB -> 764 KB (per-CPU)
>
> Use __vmalloc() for allocations larger than PAGE_SIZE (and kzalloc()
> for smaller ones), which is also how zram allocates zstd workspaces
> when no dictionary is configured.  zstd_custom_free() already uses
> kvfree(), which handles both.
>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

Acked-by: Brian Geffon <bgeffon@google.com>

> ---
>  drivers/block/zram/backend_zstd.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/block/zram/backend_zstd.c b/drivers/block/zram/backe=
nd_zstd.c
> index b367049f131d..7a8b5ff186f2 100644
> --- a/drivers/block/zram/backend_zstd.c
> +++ b/drivers/block/zram/backend_zstd.c
> @@ -26,10 +26,17 @@ struct zstd_params {
>  /*
>   * For C/D dictionaries we need to provide zstd with zstd_custom_mem,
>   * which zstd uses internally to allocate/free memory when needed.
> + *
> + * zstd allocations (C/D dictionaries and contexts) are large and
> + * long-lived.  Don't use kvzalloc() for them: when enough physically
> + * contiguous memory is available it serves them from kmalloc(), which
> + * rounds them up to a power-of-two number of pages.
>   */
>  static void *zstd_custom_alloc(void *opaque, size_t size)
>  {
> -       return kvzalloc(size, GFP_NOIO | __GFP_NOWARN);
> +       if (size <=3D PAGE_SIZE)
> +               return kzalloc(size, GFP_NOIO | __GFP_NOWARN);
> +       return __vmalloc(size, GFP_NOIO | __GFP_NOWARN | __GFP_ZERO);
>  }
>
>  static void zstd_custom_free(void *opaque, void *address)
> --
> 2.56.0.rc1.315.gc6ed9934b7-goog
>

