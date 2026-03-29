Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4965EF3D605
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 14:32:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B3536B0095; Sun, 29 Mar 2026 10:32:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88B046B0096; Sun, 29 Mar 2026 10:32:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C8486B0098; Sun, 29 Mar 2026 10:32:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6C2E56B0095
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 10:32:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE09D140452
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 14:32:05 +0000 (UTC)
X-FDA: 84599340210.02.36531D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1D9F340011
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 14:32:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mJATHEwg;
	spf=pass (imf27.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774794724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FncFNKz/F77bA6sXfCwdnVXgXnlVRG9GpjLF3kHXmq0=;
	b=QkD7ZVTZ0XORzFcI8AImFcj8VjPFrJgqlIG5JBZBNUG5z5hJLSgTqgIDhczkj5SJL4li2K
	HY0YBhN4OCMqD4SE2k48En0NjiAlGjRMxT+CkTummiyNKhm/RZoMvT9GW+5eAEMkWiG13A
	P2Z2oh3P6zmzEhDGuPBeV+vDhW7PCQ0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mJATHEwg;
	spf=pass (imf27.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774794724; a=rsa-sha256;
	cv=none;
	b=6p3zvVmKkDPsQjG2WF9c18UjRfTfpHl6yndJMB0NMDVqMbhV5/AWWTa70p39WvUuobLYvw
	XRWBZBOs1AnSptK29NVQfHByFPmFUHV0Tpzj7jxv9cUBUONdwExcSvQ303SfOL0LVdueDH
	vMy7mH874QW5mOt6P2j5ItdK0DLiR6c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 97EBB60103
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 14:32:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F43C2BCB4
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 14:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774794722;
	bh=B9jNQafOlH9J/Fp4ixtOwYT5niGHh6nII/fzFlJbeEw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=mJATHEwgKaADqZX4n4+KW1J4vF5AaIxeMj5SqjKRsRn0T4QsjDv/IBGRLsyDvKYN9
	 Mz3vdhqRnpQcMEgKgFeren7lJRpfx2Q+ROik+CreWD5waD7LMw9fYJxDR13aQYOY2c
	 v3zGdVf1cgP1jtgnq0AxYDJon1J9mYwgceoG711OlYIuxEU4J5S3sxEdMaFJUDSPtX
	 nv+ZAIzn7TyuOZq8MPzNWBgcLScbrMMCQdN3T7oN99CYQT9iZe8XbEbYPE3RDsrTD4
	 Dv5meadncB1O5u1MwC4wxizp7Dk1LhdrierQObnCeck6t8+ZXTazQYs3obzHWsSlwf
	 ZRV49nxqAQLtg==
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-6501c4857b2so26577d50.3
        for <linux-mm@kvack.org>; Sun, 29 Mar 2026 07:32:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUXzrkHvNbrkKK+wUaGvNTyVDPyKAGwR1CQ/0kNmJHVqftS0O9anWEqVbmkhqxwqzItPaYcz6j+bg==@kvack.org
X-Gm-Message-State: AOJu0Yx6UVVMp3vR8H7gqkQRBibQqC1lRprfaqk4VOYK6sIiCtqxLK6X
	HSOLXKhbBQh9buo88oVyxa2KCcRqkmi3wyEi7v4/CYnlfSHdjjytmB9PB/BTCLOGWv7kiuqFY0c
	zgq42MAcLqVabTdpx4Fb9EAVjZuoc9FZ0Hz1yOQtcSQ==
X-Received: by 2002:a05:690e:16a1:b0:64e:8cde:814d with SMTP id
 956f58d0204a3-64ff71edc43mr9846922d50.17.1774794721451; Sun, 29 Mar 2026
 07:32:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260328075812.11060-1-21cnbao@gmail.com> <20260328075812.11060-4-21cnbao@gmail.com>
In-Reply-To: <20260328075812.11060-4-21cnbao@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 29 Mar 2026 07:31:50 -0700
X-Gmail-Original-Message-ID: <CACePvbW7eHoSfuezWrMyL-cxCN7Yp-dAOgL-=pf1wksX2HqJqA@mail.gmail.com>
X-Gm-Features: AQROBzAlXWjS1Dh_SYJcGULTUB_PKufe_LIrKoJuO6UvPCYslbFpMkx8P35Udoo
Message-ID: <CACePvbW7eHoSfuezWrMyL-cxCN7Yp-dAOgL-=pf1wksX2HqJqA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] mm/swap_io.c: rename swap_writepage_* to swap_write_folio_*
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, bhe@redhat.com, 
	baohua@kernel.org, kasong@tencent.com, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, youngjun.park@lge.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1D9F340011
X-Stat-Signature: 8moqonfprebndakbhea5egxjstcbjbzd
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774794723-835704
X-HE-Meta: U2FsdGVkX18y6iXU1zjgFksnNbjDwjKHkVRr1FSsPSpR0iMhUqnstQFjam8lxoBl7lDfus1YP6uD/rpsOcmutF2caqQD1gEQvFaoXIAJRSy8HAQPtLx/eOpcB+xnRYbut3Ko54HEkDYDsTGIIjRKdJif+8FiQ82i1ZZRL1kH/SLBn8sY0h1p045mUse20iZJjJF41uqk5F831psJILojDL24rpl8H6D657bf4BlXnOivM3zCGsaRW5qHsW7Fhva+HHIegpG7hVgKmbH9RoyQ7eNVhvDRPmu9hXDsRJBusQUA9y+9g6Q+HVcgXkKR454bOh5djzXk8FmJehPCtEIh6PSvoKSVHcmswHeDYE2NhqsGYxL8Oxc4XCQe2hH/J120QP6DcVR7OLrHEaffWykB4wckBe4D54qWzCxbF/zt4O59TXd3x55QJN83cOpJj45oOl9xma77hUrwPmUn23r9TvIH7xgy0vo6ho8R688aM6S178bGnkqkhL5Qqkv3ibgALbaueSZwq/EJqLUnqlaERhCIz7gSTCb79MeGaPOvUv6RdE7hyI7SSbKI78V6hQe8nTcoThoOIf8rgVCdnEbWppkuY9VOXTIO04uwGsstuCBiNDr7EsX6C47qHMrTsermOkT4tna96bJgZO6Q0F4/xSV+grWZN+ofTbKzVlYqQDHH9jp+T1UhME/OBEngvAG0xF8mCv3KZo5wxlLz7xMag3vV7GzatBh3+iUoTDSd9LN0I5OG9sBaUXRY5RoP4NvnNkzXCFsL2JOxhefNDu6LOLspBIeGMUkjg94ivhkBCplvltA8PIeK3EuVmOFHnuHkah5PUyq4Uun7m0Fhb/Qgvn/BuKDICsvlTC7IeOj7NxyV7qAzQgat0ARX2vvJwYouPIQgcEmml7dYUmT0mCBCRWgS5JDL8eYeC3cLJX7i46KCV0OTs1R97p2chGFSOERfr0EaMcHe3VDDIWcCs79
 OrECBKvN
 l8pU3F6QtblSJK/ANQr/Q2aPN/PcjGEk7lBtGVF4YzNojCgGgDUYX747LoRu0KkGsBuB0Nlv9OL0U6uG9wVkmVNxrgh79mZAF+QSQf80tvwjkdW2r9WTFV8EG7MZapiXi2rdPrJ28Fa+OB31VA2v1ILGJPXjrO3qou7OWFSP1xd+moQr7bI7G9IMQQdMpjX19+rstf6uIIu/ifihmUtc/Q9bNCaDyxirFB44jk8lLaRbgxwTqvcIGWKJIR88UGUk+1J9HtfdJF2WdLeVisnffo6G1bqc7AH8qmZ4pB+3U1+olVSkGJis6jQsW9Z49bpd5GWn75vo51iIouSYaX86RoJdqLnoJyb/0Yk9QdjkFERKvn+TFxwtSKsM7vqaYqGNocw95Oeeu6/OWlWoOKVcrtygpIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

On Sat, Mar 28, 2026 at 12:58=E2=80=AFAM Barry Song <21cnbao@gmail.com> wro=
te:
>
> From: Baoquan He <bhe@redhat.com>
>
> All these swap_writepage_* functions are hanlding passed in folio, but
> not page. And this renaming make them consistent with the their
> counterpart swap_read_folio_* functions.
>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Baoquan He <bhe@redhat.com>
> Signed-off-by: Barry Song <baohua@kernel.org>
> ---
>  mm/swap_io.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/mm/swap_io.c b/mm/swap_io.c
> index ad0895af6ed8..063cd005ca0d 100644
> --- a/mm/swap_io.c
> +++ b/mm/swap_io.c
> @@ -375,7 +375,7 @@ static void sio_write_complete(struct kiocb *iocb, lo=
ng ret)
>         mempool_free(sio, sio_pool);
>  }
>
> -static void swap_writepage_fs(struct swap_info_struct *sis,
> +static void swap_write_folio_fs(struct swap_info_struct *sis,
>                               struct folio *folio,
>                               struct swap_iocb **swap_plug)
>  {
> @@ -412,7 +412,7 @@ static void swap_writepage_fs(struct swap_info_struct=
 *sis,
>                 *swap_plug =3D sio;
>  }
>
> -static void swap_writepage_bdev_sync(struct swap_info_struct *sis,
> +static void swap_write_folio_bdev_sync(struct swap_info_struct *sis,
>                                      struct folio *folio,
>                                      struct swap_iocb **plug)
>  {
> @@ -433,7 +433,7 @@ static void swap_writepage_bdev_sync(struct swap_info=
_struct *sis,
>         __end_swap_bio_write(&bio);
>  }
>
> -static void swap_writepage_bdev_async(struct swap_info_struct *sis,
> +static void swap_write_folio_bdev_async(struct swap_info_struct *sis,
>                                       struct folio *folio,
>                                       struct swap_iocb **plug)
>  {
> @@ -595,17 +595,17 @@ static void swap_read_folio_bdev_async(struct swap_=
info_struct *sis,
>
>  static const struct swap_ops bdev_fs_swap_ops =3D {
>         .read_folio =3D swap_read_folio_fs,
> -       .write_folio =3D swap_writepage_fs,
> +       .write_folio =3D swap_write_folio_fs,
>  };
>
>  static const struct swap_ops bdev_sync_swap_ops =3D {
>         .read_folio =3D swap_read_folio_bdev_sync,
> -       .write_folio =3D swap_writepage_bdev_sync,
> +       .write_folio =3D swap_write_folio_bdev_sync,
>  };
>
>  static const struct swap_ops bdev_async_swap_ops =3D {
>         .read_folio =3D swap_read_folio_bdev_async,
> -       .write_folio =3D swap_writepage_bdev_async,
> +       .write_folio =3D swap_write_folio_bdev_async,
>  };
>
>  void setup_swap_ops(struct swap_info_struct *sis)
> --
> 2.39.3 (Apple Git-146)
>

