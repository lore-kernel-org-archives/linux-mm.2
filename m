Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A0B7E9B365
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 10:57:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84F9C6B0089; Mon,  2 Mar 2026 05:56:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F9B06B008A; Mon,  2 Mar 2026 05:56:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D27A6B008C; Mon,  2 Mar 2026 05:56:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 608F16B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 05:56:59 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0B1165C169
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:56:59 +0000 (UTC)
X-FDA: 84500820558.25.F51642F
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2A6B11C0002
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:56:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kcE7Vb0o;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf21.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772449017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Ajx9lhLo3HWwz+XGG3Q8SmphJQ44iQsGWcpJwHngMY=;
	b=BBEz2tNTHPHmTQqQV1UmTsu1R/5bxbinOLLXEtbM8zw6LDPWh5WFCOUzdPgwycTM9qk1GY
	kwx0KIuFYCbfRWii8T07kMQr36F0VO6GEpTklZeFa9xHFFjgRmTa3CYElOHYcDfAWj+c8t
	a7uXsQ2nGYjLv99hzr4x6shxQ0ZYSXk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772449017; a=rsa-sha256;
	cv=pass;
	b=ulj397dLNqGFKMtzaw3TF6N2thNbNvmNp+UjyDhbgRbVni+ZtK7Rvchi2A7sJK83MHaWn9
	ADklxbj1OcnO+X8K9MoZbhRMTzoU5p4HYdhuh8/eR5lYks/ZZC22xjjPli9iy2tE8JsiRi
	O5S4z3ihjLk7MOcRi9DoDIM1SFsN5UI=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kcE7Vb0o;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf21.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-899e85736e2so15714706d6.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 02:56:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772449016; cv=none;
        d=google.com; s=arc-20240605;
        b=VHmWUEPysl/El7DarSE70lKGu/YqEa79rQKHSClnK1Cu3XVHCBNHPEkCZIF/0LujPa
         nq3OhQlPfPESeBBu3uKSpCF3bP+ruWZrmKMh17WNUUYJWapB6mB10ojqKI4fYvCpsSef
         mGgtX1rVJDCEQRxTPD9B3tjk0wtOODMhKZ5oQsH6zUod7GprCJ+SbdHCk81t//GKIsbP
         wLWnZJh+9pyIIGSyrdlRm7nEJqmWYXl7CqS9JzkjZ2+trHf1c1nOXqJuD19E5X/E94dP
         ACyE/kip/7DFD+N8ob3t8BGYCsLjLv6/yfWDiHBW3aH0D8JJ/aLxHsm8L0n17td8FSY0
         Qqtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7Ajx9lhLo3HWwz+XGG3Q8SmphJQ44iQsGWcpJwHngMY=;
        fh=02cpICd3uJ5SYLGchF8XE0rIJ+s5rfjG8IVpQUFEOFM=;
        b=JAyDVymYUcBgGmk5X/+MNr/fwGCH9LQ4inGEC/OFUvU5pfcI54ia9CUCumNVg4FHe9
         ZcN4WKORAs2cD8K8NUDT5zySdlcDIdv/IZjTvFzd5XNGZqUlzpUTGN627l9snFK0l0nD
         pehmaHlYXCJ7ZNHl+hXNGxW/MrjbPdVGX02n6VW0F/uflHldu0dbNs1fzQK7SYPXiPB+
         MD08bwknjzXiADHitYWuj/lTKpYQjIPKW7OxFTEtjSHFODhyNrlx5rALOqx7wubeEwim
         Pf/j7//8UwRKQ2TAfV/Sk8+k18955h8loPXWmHUjFiM6u4kWodASCv3Ev96fI1JfqIfH
         i4bw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772449016; x=1773053816; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Ajx9lhLo3HWwz+XGG3Q8SmphJQ44iQsGWcpJwHngMY=;
        b=kcE7Vb0o84faRGzk4VImFrrJfZnSfsRMi/uvZMymjtNHIOQiOqhj4FURbmUMr3+6PM
         siE7CfkHsA9P6XhpmVOjBVo4980cFLj+2fESPUh0VtlkSi+NIxlzWc8w7QWoSEzNGcon
         Q7EG22fF2csuXerJA7mZOgMt3rE69S50A47Z9f80RGKNQEUsjJUST7Vxpl2Tdc3yL0AI
         uZQQOUHqMkNJsNkYr8bLEmWoyNf6zhz1bPKcFqqzI9T9gfrpYjGLMYCUPaHHmn/vkN+X
         j3jLMwUosS90nmRzF5QeJYxI4dW/vl+8VXH0ExspunYdD/t1VaNx1QPStgLIElAU0mY0
         HeLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772449016; x=1773053816;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7Ajx9lhLo3HWwz+XGG3Q8SmphJQ44iQsGWcpJwHngMY=;
        b=A3RXXshFlonxtyPAxQUXW/apXWtYxrIAkpN+p0oqYOAK9OjXtJe5BoV+3DSzhaCmWn
         p+uQ/1onnCNR4pLQA5Ft43U5qqAN3QaW2z3S7nTdxSWqa2D4zfHzaIgWDmy6nKXXdoOe
         tf1p7daxjVsSQOysEXjNWLtU/l+Oc9kVHSQ860WIodLTa4uTbYnrnzL7DHdrgb15Xfjd
         aNdgRuvID974NR9k7Ibux53Ad7Uw8V7USnihY9c4hWe0PxvMuQY0s+n7fFpLGGUbmTTt
         zMqby0xSpcKjI2/n5g0eP2lCktgEklYmPZD/mlBHv9s5hC0ZAP7qd//5HUEel1NF2JRv
         FO2w==
X-Gm-Message-State: AOJu0YyUCxQiKy7o8O/gPHDNNmoiDbZaXt7tSeKX9oX2NcXtZUiKtfPY
	GZsGZMrP6LV34hdCdqVmUvwM6bND4QMhi9+j/w5U+jEXEev5PpNrI6MsSTDrgiNT1ljpR3dh3W5
	qjJ3lVhWHbBfni0XZsmMigQm4DsyehWo=
X-Gm-Gg: ATEYQzyX9HTuKvRDobnbFO9O+kHqbil369EKfbuss6YQDHv0jyscTtA7a7LWMtFWh9w
	QqtQQp/UZ5DVqQdb/cjavRqxAyE5F91Grgdi3aaVUnmVdbGeCmUgkrR4aDDX2qwBFXTWlo6u4F/
	ogFp24VrKkIOgwC2XuL1P5C8b8ZeABFccKiABz8sJGed5PK1bAtcWarnHidOnrxDUVAomCZePd6
	JDplIIRwDY2lKLmgIk+jZ3sVe6fAbBvujJ4Y/eXjVAjy4dtoaSdSJZKeh2uJQz70RQ5fVbUZKKe
	P7Z7Ng==
X-Received: by 2002:a05:6214:2a87:b0:894:5d38:2e38 with SMTP id
 6a1803df08f44-899c67f21edmr217812936d6.18.1772449016038; Mon, 02 Mar 2026
 02:56:56 -0800 (PST)
MIME-Version: 1.0
References: <20260302104016.163542-1-bhe@redhat.com> <20260302104016.163542-2-bhe@redhat.com>
In-Reply-To: <20260302104016.163542-2-bhe@redhat.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 2 Mar 2026 18:56:44 +0800
X-Gm-Features: AaiRm52upSMFVSGiA7FtYK0a7sLTIYIcmD-dwDNNJ6XI-ZMSBKIWmEOJ2vRC_iE
Message-ID: <CAGsJ_4zBG96YbL7YpZMyLUsNOc6WRCZgntx0mSvJjZvhturoyw@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm/swap: rename mm/page_io.c to mm/swap_io.c
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	youngjun.park@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: ocd3os8scwwmfs3axkiiocjouz51medw
X-Rspamd-Queue-Id: 2A6B11C0002
X-Rspamd-Server: rspam03
X-HE-Tag: 1772449017-911575
X-HE-Meta: U2FsdGVkX1+m2QouRET8nVQSGncO3eMqGtNjKSu5ir5Bn2BHB+6uShZruprkj5HdoR6nVeYKZlBec/gJprsnl+eil9KuijwRI2Yfji1fUT3edLq4FbVIWVLZDaH6mwXzy8BzrXWjxBPgqbbIdxFNpLU8M+BbvGjq8W/5D7hU5A5ZpP/1BL7PDCtx7WOuikqcncYoGRvJHFISN7z8PtiQmPPgbLvhKy9RAwdGG4WQrCb+i8sR9MIa0FUly6BVY8INYmvsoxti4ViSi6tbC5/Us+6s9SMJH1VwJsdKKy6PRYWCgiiyHGd4aMifK3FwrlqvS9c+rqjCMKelkRMhKkA2P1aCO73fi3QQvQve8BNM64qRBsRJz+6iRAEHFU33dKZsjo2Goe/hLtVXNvluF28PeK8mqASo9r2SZRYENt6PNiXSK8JLD8fe+aBWXSWJTZtRHKZtM2sGWrOIDbgGW5t0uTsRHLRTZlCw0zbqBQ3+sO+EnN+hby4RfK+2o/0QX7GGzRDF8O3v4ZUHo7RxT6zKwx+vB4enAKYxx6cqd0c2uwtmugLJASdVK1iAwcCOgaobuQe64EgcvJDmTyXD2/IBllY7vnPe6G1xCVUU/YTQ7pAv5ap48ZIf7u7pde80JJnFZk5JcXVZ9muar0xUNDHQ9VH8m9VORcGqfQwHJk/QkvpnsRFef637RuI0DXMPC/iuMrIudyJU7XPQJz+eQ9M+jSIs/9+3t1TnSS93rMRAkq7YpBlKefUvmyK0ukpry801GSpKfdDorRA1VD5cn9fsNusnEfrUWmy1cbUnYoh7ha+55yh8znAYkOV+ZZW8t1azk8Wl7IAeUCV+s9v/BZbts0EiqQseC8sJxDX4zTqUdArUqX6xD/gEdPAh5dvbW6GYsEnGYj7bNWgGQXDadH0UrCjD6tiK5DrpL0NX73spJmBFRfIIVuQawLl9rLGzTuk3BhklhGpm3aeEihWqX8e
 dsVEsI8Y
 gppmK+a0L8obqJskiia9rS1hdGB5hVMqCZeSsb/iNcMlBwYAPALWbWLBrbWIs9qYHF72/+1+5zdGi21NNQj0cSvuiJ4SiAgqXc3afo3KlOPyWgBWZndXHFS5U4vcHHsb52qUMfttE7Tu68khtCIChip9iT9wTONTf+S8TSpEtBdHsSEv/5UGLjPErdGBxxku3aZAPNNh7eiaI2Iq6BXcCIJAE5A0pZt8SoryIKdrK7/IU2sylB4Gn4PWVdiMsMwnvLuQ9GDWMkxeNTwlLD5ExblIm3zKYLh2bgP+uw+EmwHpT3jCZT8nZklBcfGyRBl4F1imPVdKQCN9m/zR9dPWHjJvSgaLkWVUdZOtvfOuSebU8NUXAD7UMbApEij6jrNV4TKo5kOZXp0GgWXrFpUxUXtfrZ1Xi9Jl3EhVq7xvpdVVSKj7Kdl05hYnBJK2npc1S1x22CAEIRU34W/4gGaa9Q+3kdTo4g191wlgyvRYNjPKm0c9YpPLp7Dz2+5wbQqDvCaf7jtcYUqCr47Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 6:40=E2=80=AFPM Baoquan He <bhe@redhat.com> wrote:
>
> Codes in mm/page_io.c are only related to swap io, it has
> nothing to do with other page io.

That is true. Meanwhile, swap.c and swap.h contain a fair
amount of non-swap-related code, such as lru_xxx and even
file-related functions like deactivate_file_folio().

Perhaps we should consider moving these to more
appropriate locations.

>
> Rename it to avoid confusion.
>
> Signed-off-by: Baoquan He <bhe@redhat.com>

Reviewed-by: Barry Song <baohua@kernel.org>

