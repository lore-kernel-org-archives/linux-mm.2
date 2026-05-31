Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 103D6CD6E57
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 21:38:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 072A56B018A; Sun, 31 May 2026 17:38:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3E696B018B; Sun, 31 May 2026 17:38:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2E346B018C; Sun, 31 May 2026 17:38:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CCD166B018A
	for <linux-mm@kvack.org>; Sun, 31 May 2026 17:38:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2E0CE1205D4
	for <linux-mm@kvack.org>; Sun, 31 May 2026 21:38:18 +0000 (UTC)
X-FDA: 84829028676.17.D95B624
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 50BDD180002
	for <linux-mm@kvack.org>; Sun, 31 May 2026 21:38:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ujsb38R3;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780263496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ChlNi3gY4pmClyTFzjJW4JTye0c8PTWwo1dt2DbBgA=;
	b=sApw1eTVSvXQUZZv0NEYrRQMGnwjUqMZxzDuEZzBx6OhWcr2Q6f0Rv0tfOV+Ywp2/pLyab
	MFNx9hAcWtiYk6w7dzbouc/mDR0Zf1ZitTY4YoXBhHERM+Oate4t89B9b60QtiKjtW/bd5
	gICoWbzIc43h+SnjA+j1J5/FTQVSNJY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ujsb38R3;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780263496; a=rsa-sha256;
	cv=none;
	b=LKBL7fGYVyd8BYm7S/WdQ1zl5baXjhbxPVO19IVh3FQQT5ZFXbtum02nfJGAXLzsU2tayA
	DcgBUSgK5Dsuq8ZkDbXWuQpTe/xBHnM8XEOg2GcRSQeGe3kZXxjlM04l6Xmq00J9+u0rsi
	cdWwm8K8NjK5QwS9QMF8gEmJR6d4tz4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A91BF601FE
	for <linux-mm@kvack.org>; Sun, 31 May 2026 21:38:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FFC31F0089A
	for <linux-mm@kvack.org>; Sun, 31 May 2026 21:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780263495;
	bh=3ChlNi3gY4pmClyTFzjJW4JTye0c8PTWwo1dt2DbBgA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Ujsb38R3V4L+gQguxzwB8Xb+Q2WVperpa4SQqvZHHDKn6GCqR51/eYLNiz7UoTaUE
	 cb7cK6dY8Opj2E5hWjo66rJS1KuH3scYI8FLzLA0bANRhyLLwai95gckI3xhizj6Oh
	 4KV9+I7Y00c8yeGbcxFjbcy9Rs2K/csucO0eD7aVmQrf2skHut/6Fpwb7QJp0pg5V6
	 a+WT5HinCfwb4RQvZUsxtjLEBNMnCveigF5G0aUtSbdNsB87fXEhSccqdC6xf88cIC
	 C8gqSQZ8eH7ZIFTyClyDxJI/9K7KM2xzfKX6730jJXzzGLKziWv2QgFFq7SXSH3hjt
	 edhpaguCEJTpg==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-91550eced6bso96719985a.1
        for <linux-mm@kvack.org>; Sun, 31 May 2026 14:38:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+Fo9QX/Ih8ntKmN+Nk5IRE4jg6In1iEnWrxUdp1R76fWfEouGa5yXLw0H4IMv+klq01flx8T3BxA==@kvack.org
X-Gm-Message-State: AOJu0YyAxDocKeT5Mo8XC3fN/ZCXiaB4uD1ak5z+o0nNOGS/86AsRR25
	lxFfWcE3Wocy1RkJry9qDCBihUnLK8CUnOpKzyma8uTfQIQ2Cbo4RvRPBZYt5ibjrdxsLoZ/k4K
	+ZG9t1iK22+LWiwdp185en5wpy64qIWk=
X-Received: by 2002:a05:620a:448d:b0:914:dbb1:1487 with SMTP id
 af79cd13be357-9153da3f0f6mr1264775885a.53.1780263494750; Sun, 31 May 2026
 14:38:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260531-zram-fix-partial-io-config-check-on-akpm-v1-1-eb085d98faea@gmail.com>
In-Reply-To: <20260531-zram-fix-partial-io-config-check-on-akpm-v1-1-eb085d98faea@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 1 Jun 2026 05:38:03 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wB5XyUrPpg1O-pkySxo91RsHxaaUkR+Kt+heP4_OeeqA@mail.gmail.com>
X-Gm-Features: AVHnY4L6_UdjcCk4-_UTU0q2GUVmZ6B69Ux11hFD72dT9usvr_K3TiSBY_9PUJM
Message-ID: <CAGsJ_4wB5XyUrPpg1O-pkySxo91RsHxaaUkR+Kt+heP4_OeeqA@mail.gmail.com>
Subject: Re: [PATCH] zram: fix partial I/O config check
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Jens Axboe <axboe@kernel.dk>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Baoquan He <baoquan.he@linux.dev>, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org, 
	Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 50BDD180002
X-Stat-Signature: baiuw973m3d7w1t5gafdce8z641smcs9
X-HE-Tag: 1780263496-464262
X-HE-Meta: U2FsdGVkX18OzRryzAJ1wk+YRGrAFHjnYebh/KCR0MWBKzp2K+cR1EfGLRSRF463YAO/AgRvjtwe4vCcutgMsojfZE0aVwnQMF3vcsYIm0oPLJt7xUtq3OSXMdCHr4F94hRI9gDgSjyJ/YFUHgoc1Cj/LH8adAV1/DuQsFVwuWLTCeUtMP9qeHlC0WWG5pT3iAfFwF7a8NlrUSs0QOcgM8dEDzIj+LlzjzCa5bOz1fmeENMVCXmf0sVVl38HlOQ7xKw5R8Ex1cb5n1T3HLhsLy5ZipvBosZ7UmsLOPHyVzw/s8X+JhZ8uySaqxT0GSp+822Kt4lwOxtrvsxDgfXg0vy5nmXSXk4Op5c+BovTXfnA8n4cq7rCeO3LkLKlbmohb+3sJywLhq2vxFY/2nqPiDZxnswkRxr3l7TCnMhYb7idP++b1lWTdOvP2QZ9oZtjMz7waprgtxqgLPB79fR3gem3biELbrIu304txXapYO+Kt1Naj4ortpPFI39ldGED2b4P+RTIlwNY+Wk28RKRYwvnfiBNodGmTJQOo+u4OI0Tz7LEYcZYBJ4Fe/HLej3zbMLfZ5EwPihaRqFX12jgg643EZhCiT/l5MXUYgyZtWaGUKV3hprAGrs4pa7ibnLzdFfhWyMFbPe/OVNwF7BmNkPpwt0EaXdO7RDK/RH+5gmE6IAuakzA3KWZVThX3LES6b2J5otMsKSntR0XPwuHz3f0G//kH7LEaSbvjQWHP32aLvKYxzi7kVZFxuLhEhXj5UoYNw6qzNT39512VB2Z9hkazBH1N5w7szGO8OI12x80QxaPXAUAWkFkBaEGa5SPASCAINcULJj2qcSQE8ODxKHH6DF7CtP43f5KYg4qGOkFiaf/W+Yj7fnNNH48yLElzPvkCE7Z4l+7sASKAkRS1UK0XYnH3NKzxHrUxgqwRgwb5lAPlySkhN14PReXJ1AzFR175qno9jskeFACneI
 kiFTa1UX
 3Pxy+vajYeIzJAZJpTq+Jb+2dd3MbPlYhkMcxjp8vENJFSoKBnm6fcdH5qkt/rE7DDJnszl7YJC6U2JAhcgIk4iWhTbahzdgU42BWc4GRaD+D9sr/T4AIX84xD349ERwm+CVkMIS2fyUtLWr/bF1OzAN+8/zTy/3Y3ZDvPTiMzWOX+3mjIEdtvBMK2UI/LTpbb8MZQp0YjBBuAwuPzOeQmpG3Jed9wJTBKfGrOZ008Z1TKu18DR1V1w2Tb9nY/PYUELhgwwTRA6AlVOWpvRQ1/OyGiIoEaE8nPQS3voX0MFJZ9/fWumdtrKJqZj32wj3L67itw3xAyC9Y4i0q6nvvOAIixw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 31, 2026 at 8:35=E2=80=AFPM Jianyue Wu <wujianyue000@gmail.com>=
 wrote:
>
> IS_ENABLED() expects a CONFIG_* symbol. Use the real Kconfig symbol so
> this warning reflects whether synchronous partial I/O is built in.
>
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
> ---
> zram: fix partial I/O config check
> ---
>  drivers/block/zram/zram_drv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.=
c
> index 6e1330ce4bc1..72f89fd5572e 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -1510,7 +1510,7 @@ static int read_from_bdev(struct zram *zram, struct=
 page *page, u32 index,
>  {
>         atomic64_inc(&zram->stats.bd_reads);
>         if (!parent) {
> -               if (WARN_ON_ONCE(!IS_ENABLED(ZRAM_PARTIAL_IO)))
> +               if (WARN_ON_ONCE(!IS_ENABLED(CONFIG_ZRAM_PARTIAL_IO)))

However, I don't see ZRAM_PARTIAL_IO defined as a Kconfig option.

#if PAGE_SIZE !=3D 4096
static inline bool is_partial_io(struct bio_vec *bvec)
{
        return bvec->bv_len !=3D PAGE_SIZE;
}
#define ZRAM_PARTIAL_IO         1
#else
static inline bool is_partial_io(struct bio_vec *bvec)
{
        return false;
}
#endif


>                         return -EIO;
>                 return read_from_bdev_sync(zram, page, index, blk_idx);
>         }
>
> ---
> base-commit: 404fb4f38e8f38469dfff4df0205c9d18eeb1f57
> change-id: 20260531-zram-fix-partial-io-config-check-on-akpm-c62b972416f8
>
> Best regards,
> --
> Jianyue Wu <wujianyue000@gmail.com>
>

