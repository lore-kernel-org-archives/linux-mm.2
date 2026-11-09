Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F264606D80B
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 08:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hq0uqR6B
Received: by kanga.kvack.org (Postfix)
	id 79B476B00EF; Mon,  9 Nov 2026 03:54:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74C946B05B0; Mon,  9 Nov 2026 03:54:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63B146B05B3; Mon,  9 Nov 2026 03:54:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 41C3A6B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 03:54:12 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7E8F8C0464
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 08:54:11 +0000 (UTC)
X-FDA: 85414968702.14.E47C548
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id DC8F7A0003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 08:54:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hq0uqR6B;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794214450;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iRY0hs3t1UIJHrMY7KhRUYSSk+YxXEfybfwdTdfJ8vM=;
	b=3hDt0sTcKO9l5uW5dXnETK5i8yxuT7tjP1Xt+hUUVC4AYfHLi3owQKWdNDgBIGLRGmTZ+0
	KZt7LW7PRfz4DWkbOkzYgrZH6GC09OVmTxB4VGwtkITgerKz0XEOwXAvTSlGVbcCbD1qJQ
	o0xwP1hOZa+pPJdCL8BGY7sLoM0fh1E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hq0uqR6B;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794214450;
	b=vYW9f4hTP2jzSjwSUoe+iI3TIzxxhktZ545D62vV2QYS6zKFTrFDEPkiOdGPE/AfP+UwH0
	vSx9JpzTdqUdN/+nQ1VnnFQ6V/XI7DoR4K3dzhHpwp97eqkcwVzOAIDJON2mORj8Hm/3bM
	OIWPUyy716dheIM2lFDv3IQuBycpVl8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F3014133D;
	Mon,  9 Nov 2026 08:54:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD801F0089F;
	Mon,  9 Nov 2026 08:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794214448;
	bh=iRY0hs3t1UIJHrMY7KhRUYSSk+YxXEfybfwdTdfJ8vM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Hq0uqR6BElEaCwwSb+zjshC+xWB4fYkHuBrJhsj/MJrZYd+ijnbrh+ze9e0h6Titc
	 Py4r6UvR+e6QQzNz+TLdZ5z3hOvgGFh0QEliWHGSZAm0tKT5fcZKeLQFbjiq+lwWv2
	 /OValNsv6ATe/dw2KvU7A6U2fc3dx3wToMXYpbfc+HGdDxRULH//XsOCy9NFsSYq3A
	 VSf01Y4dG7LzTtn6mnAFUc/Q/HvkzoPbwIj0bu4bTUh4/BuiWLMmlSfC4MTfWKelzt
	 RtgXBqTOcrnnalfAUz5/NdLatUldL07jYYs+XTW7BrB0iUaIc35A0gz3Pa2zNaHA0V
	 acnnKkgguBY/w==
Message-ID: <sashiko-outbox-204633@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/5] s390/hmcdrv: Replace page allocator calls with
 k[mz]alloc()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TWlrZSBSYXBvcG9ydCAoTWljcm9zb2Z0KQ==?= <rppt@kernel.org>, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Sven Schnelle" <svens@linux.ibm.com>, "Janosch
 Frank" <frankja@linux.ibm.com>, "Claudio Imbrenda" <imbrenda@linux.ibm.com>, "David
 Hildenbrand" <david@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, linux-s390@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261108-s390-char-ready-v1-5-3db507722530@kernel.org>
References: <20261108-s390-char-ready-v1-0-3db507722530@kernel.org>
 <20261108-s390-char-ready-v1-5-3db507722530@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 08:54:07 +0000
X-Stat-Signature: nrijgohbchfozqg4rz1hnnrcueswht9f
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: DC8F7A0003
X-HE-Tag: 1794214449-332642
X-HE-Meta: U2FsdGVkX1+wAmEd68q+MXEjiUssEED8xTWjLr5s/+Dg0vtpmaptGG00vBpZ0yZHaqoJnMv8TFnKv4f4r+DPftw65VgvXCiK/+jSC69ko+wVDVhnTAzQwxXBoWuKKqnUBNSwzCUbQkvR2orvNCG2teFraMqz72cZp8iJvMY0axeZUa0Pp4n734ONqUQQ8+ll0eIvbtYFYwJOgPGrl/Cvp51RINHSUp5tcgGNKXzztfn9IVhsik2KdRFKpSXnI6Qeewmli5DLF9BO9kcJMiAwdJlpdK8KIkzWHKu/LUt6GGecIC+YOz1UsMtzDEaCXSmKRzuUdvXIFQ0vTWql4YDaFbhfHDWQqcqeoWlv24cVW0DBEor5sHp44b3KtC+fm5I6gceNUHZB7eFiLPZXLzbEnm0RZBAuHxNDjw/cSYtwJf1gAEU0fnc4c+nVt71qNayRutRMC2DrCfFVduIDM2WJ0JwOrtUPzgNYqBbMe6HNcB4zAUDdyJnnwle6IoUTERM6YTI0trKwYO2e+UWm/cJTRXxxMCte1i0kO/iyjoFCHPXZbbaFdPqQBc8Q0GopagegMFmsRkSbE/2ihuVmBweo3g0XKG7QwCIUmQ+RSTtl5ajF8s6mL06zgm3EVHqUTUK2eA9vvld008QarPOHz64MSRVVYaWPV/727+bLngg/4/NU07drYbPm1WembK6HemwrNXKDoO9Dxn7qmS9k9NFaeQZifg4XxjUvyGdzjMX8+iGc3peYt5VU+XdAWwTK3g4mXu7fysyafItSD+6kJXy3HIwDxPenChZEHggLwbvKOabSSCySJlwq/74OIPVe20fcPL8rUZgDuUgPYE5Rnvz2NJVl64iZsV/38qCs1MB+03J17EeGt+4GNivChtcph/DQWKVOVUZoViTw7k9HqJy+I589vizcxyxeHllQ7Gub0MgWTgqCbIJXFYNR3vwBBCvY3sX1+ibMX6VTgXJBRlO
 aKXerSM1
 Sss1sfJw+ruz36+0ZrDic+yxsygZPmqr7rInsVvW/VszVKfEvGnJ8RS+iWpDAlNwpIPhN8QFDXQxVIIptncEAG10fQ4QvNGK5lefwohtacoxFmgBRrEglh5W/n1+2uWNbNrt6DzUgwHMQy+naxkgXP/zZyB1/utUzCumMPFE54myebgZFQh5UZ/s5NHoomogOTZBNllRqyZXgHW1PDyBvALYSmDT9TW4gaWK3QT9gRKQmivl9ZFnB4POW4EFZfuQ0H1vUFbJlbRL/3IKjBO9CUC/DbELubdpjkKu6HfTGhjq8Y5w32SsqWpQU39+AMErT9YrrgcRpywKT6iRs/m3ykM7DQmmXN3s2Tt+8DyW0GJVw11hW9iMWt7JRMXJeVyNx8sPrvVMoN9dx9DOb8ON9o4CRfzS/5qsGl8KgOPN7cP8/OSBwL02w3ZHP0J5h+DGD1MtB/6iW8s3LUYC+4H03ybAUR3EtRgSqzPZQRrflyR1kf8Rzel/olkNTwzQZRMKRh+cNdHx3xMDjR6OpU3z9a9gtd87H0SRvUN+9JsBGqO6R6QG6KBxXjkdC3u5y0S8HTFc9qGJQLsGOhvkw05BcaQkO/ybPaLXxYy7VJtpgumN5SvJGjdMowbf/atMq+Hd0meU+GloRKnZ0stHTunfAjiye4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] s390/hmcdrv: zero-length requests rejected with -ENOMEM in
  hmcdrv_ftp_cmd()
--

commit 64ed22d8db2caf381431154b54f669d68274ef30
Author: Mike Rapoport (Microsoft) <rppt@kernel.org>

s390/hmcdrv: Replace page allocator calls with k[mz]alloc()

This commit replaces get_zeroed_page(), __get_free_pages(), and
free_page[s]() in the s390 hmcdrv driver with kzalloc(), kmalloc(), and
kfree(), rounding buffer sizes up to PAGE_SIZE.

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redh=
at.com

> diff --git a/drivers/s390/char/hmcdrv_ftp.c b/drivers/s390/char/hmcdrv_ft=
p.c
> index 3312b2ac00a9d..e22789b532de2 100644
> --- a/drivers/s390/char/hmcdrv_ftp.c
> +++ b/drivers/s390/char/hmcdrv_ftp.c

[ ... ]

> @@ -238,16 +238,16 @@ EXPORT_SYMBOL(hmcdrv_ftp_probe);
>  ssize_t hmcdrv_ftp_cmd(char __kernel *cmd, loff_t offset,
>  		       char __user *buf, size_t len)
>  {
> -	int order;
> -
>  	struct hmcdrv_ftp_cmdspec ftp =3D {.len =3D len, .ofs =3D offset};
>  	ssize_t retlen =3D hmcdrv_ftp_parse(cmd, &ftp);
> =20
>  	if (retlen)
>  		return retlen;
> =20
> -	order =3D get_order(ftp.len);
> -	ftp.buf =3D (void *) __get_free_pages(GFP_KERNEL | GFP_DMA, order);
> +	if (!ftp.len || ftp.len > KMALLOC_MAX_SIZE)
> +		return -ENOMEM;

[Severity: Medium]
Does rejecting !ftp.len here break zero-length commands such as
HMCDRV_FTP_DELETE?

Previously, get_order(0) returned 0 and __get_free_pages() allocated one
page while leaving ftp.len set to 0, allowing a 0-byte read() or write()
on /dev/hmcdrv (via hmcdrv_dev_transfer() -> hmcdrv_ftp_cmd()) to execute
commands that carry no payload.  With this check, those requests fail with
-ENOMEM.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108-s390-char-=
ready-v1-0-3db507722530@kernel.org?part=3D5

