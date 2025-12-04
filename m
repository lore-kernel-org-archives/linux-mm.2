Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAD18D206A8
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 14:11:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EA046B000C; Thu,  4 Dec 2025 09:11:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29A356B008A; Thu,  4 Dec 2025 09:11:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 162756B008C; Thu,  4 Dec 2025 09:11:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 013546B000C
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 09:11:24 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A307DC01A4
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:11:24 +0000 (UTC)
X-FDA: 84181976088.12.9A5F1E7
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf16.hostedemail.com (Postfix) with ESMTP id 894FE18001C
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:11:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Wd2pyX+b;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764857482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7tkRn95qVGHRVjDZn+eGOwJkoMDfDMgAwJnLmn1mIEc=;
	b=gpU0uTQlTXCL0akiywfRdkfNMZEYUlA+d3aXF1NhCyI8G3Hs2O6GF7LWGLQMgw+n9nz9lG
	CdPUNRm7BaacwsFEEJEQYJJLGXl4vyrSk1hKPryPohj1tGbI0pR++5DT43E8eT8le04V4r
	Q9HQ/r9HRns39hgBvUPUldWaLOrbtAY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Wd2pyX+b;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764857482; a=rsa-sha256;
	cv=none;
	b=tM5tR8MKTH/klIokC0kyM90jsUMts0S2ygqt8bcBMdOVHGHrrVbuN8N4Fco9dXKey869ha
	YlRmmaWz9qh3gihQT5VQqqTDh2y+teA/j7PWDD5HKkT0iFg21HzqZZ0ReY1vjzM2ef/k3Z
	qZSgcdK/pbsNkDOmbK+YLIlOboLUecM=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6418b55f86dso1657589a12.1
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 06:11:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764857481; x=1765462281; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7tkRn95qVGHRVjDZn+eGOwJkoMDfDMgAwJnLmn1mIEc=;
        b=Wd2pyX+bktuujgLYtGnditF0efOT9+RgRCyzbwRG03PKetiyHcKVK6lukLIIGYdPzt
         jUugpmfoYSv/tG906mRCapgygA9TX9Fv+gfr/yvkMYWa7oFNHji5I0c/AUFtOM5QRvSs
         AcsV/4XCo1gHlxx6Gf8KqcVUdkLyRqdTEVNKiqbHR43JiSS7+ZPKzdcq9HniPdXh2RAj
         4s/An8crzTpaWpF0OfG0zxH2JiJu7OKzJj0X+AWsxPsdlsvSkfOHqLB97eW/PTOpGpfN
         eDHZnDA5ywQ8Ym2DCIm0VxcIda2ZU5R6bkILBnBdpPPFnz6y8cUpMKkXKIhCeIc2yGTR
         NirA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764857481; x=1765462281;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7tkRn95qVGHRVjDZn+eGOwJkoMDfDMgAwJnLmn1mIEc=;
        b=GS52Whhme5yqVWbVEtmE4XRp0Ht/ecdFTk3Bt9Q7f2EeTfkxzA7Xy8U5sB8S46FpIY
         CgrUFk1NnVsvILjJfdy85oOehBD98RmP02lgm7x9z7knW0iNXCk3McR/snot4eIsrg/A
         Xe1PfRaiusdtHArp3AIvVwpY+ZXVCz9BZZa4xO1Vxq1ObI6Tz8/UmzECuVl0zw2JiWOL
         kXQrfoRyyRg/RQto+PlOe3ggcus7slDbBbwlCaUiVWu8dpnBiTn38X7GVYTOLaIbZwib
         07/HT7qtBxFFMHTiQr4rPzNqXyaoxdIErjyKvgHRuuhWh4uhFxPVyswmZizXoatPELLx
         iCdQ==
X-Forwarded-Encrypted: i=1; AJvYcCUB5IoXFYTRA4vWU5G3Gc4Psqyhc8pWFMZHfZq8HzduO/zsfBFfeAqa5VGChwjBKeghsDmT74rEuw==@kvack.org
X-Gm-Message-State: AOJu0Ywmcjsk0G9J0fSU2QNz3XfSUsOzqTWlfW2fMsM9A1Eqkj3tjiP1
	xjwMhYMdUwS2F6jJmfC5/092z0JlG7Uy9AhG1FJV5XP1I0R+71MwPUuMXGuo86uX/D20d3rnyne
	PXad9gl92mJj/avKmlWnECetdp9Bnktf0hubtxa/ABg==
X-Gm-Gg: ASbGncvYPUfuXcPlHkdB7VHriluBrzo6nJD7nMIf8UOu1D/VQqo+N8Ib5mcoIq0Xs36
	dbPRZ+BI8uD9NfKG1MxR1HBMnn4mSz01CeY4dQdidbFIxpvgJcfzyS7yalAehHv3NMhX7Oo6qU2
	jzSKCk1RbV//pRGiHNy3YIBOypaBl9cHbBYShvuXoAbjLTHHCWAg5NolwyuXEyE/PEqiMlieRoe
	f3CtaQq6jQoeyXX/rARXJ0GaNuc5ao3l+gS0EDkbIpKlm1EkPPW4qrBSzBLkfmzz2TWcs0rAeyT
	4LI=
X-Google-Smtp-Source: AGHT+IEhRAVoLtpsqJPUWAmo1GTMqaZj8n1T7c6oR6OIyFmDC94SnW4iSsp1l0JsjDPMeePySrZtC7tGSA7zBq94e9s=
X-Received: by 2002:a05:6402:35c8:b0:640:a9fb:3464 with SMTP id
 4fb4d7f45d1cf-6479c471f70mr6117707a12.7.1764857480963; Thu, 04 Dec 2025
 06:11:20 -0800 (PST)
MIME-Version: 1.0
References: <20251204102905.1048000-1-arnd@kernel.org>
In-Reply-To: <20251204102905.1048000-1-arnd@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 4 Dec 2025 09:10:43 -0500
X-Gm-Features: AWmQ_bnnGYOfI1j_ZtSYbZZRrojADNXpeVU38MiJhLSZDkVtvQ5nO9cDjJiYKYw
Message-ID: <CA+CK2bD2HTpJm9xsL1+V=EOUkrn1QrCks+T14nB8doyDfN=JyQ@mail.gmail.com>
Subject: Re: [PATCH] [v2] mm: shmem: avoid build warning for CONFIG_SHMEM=n
To: Arnd Bergmann <arnd@kernel.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Pratyush Yadav <pratyush@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Kairui Song <kasong@tencent.com>, 
	David Hildenbrand <david@kernel.org>, Christian Brauner <brauner@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Guo Weikang <guoweikang.kernel@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4yccj36m9d7kwzogpm53jytuw3c1u8wg
X-Rspam-User: 
X-Rspamd-Queue-Id: 894FE18001C
X-Rspamd-Server: rspam09
X-HE-Tag: 1764857482-875241
X-HE-Meta: U2FsdGVkX18vsPoOEF6rvbW/aA6huRfSeqFgHUV6aVjuEnJKxAlE1LxiTsu5t8jfkQ5w5uTDEEtklsTrve6c6L2rF7DaKdEJ+FE/O5QzInMd+EhdZR8p7J+/KRE5kNDlRH8tzHu9pw7TXqP717GByV0DSzMHRWJAHbNPLxgDaDMbSALwOk2RXE9886ZF9yMBhMU1B2lrsP6WgXiE9TqsvDrYvuB845tJ2C5FMVqocCRDH0Y07TBchRupJyb8NR1vb2u+6za4NJQ5UJMpES9+QlMfUU9pTd0TAdA0YHNxMpRw3dnzpfbFUnSFdW66vDijZYNyDeKgJxZaaStCeVhE1lMOl2pBbabb3CzNfdc8BDdXGs3mn57b9mt8pxBhKbgbmJfK9MBlrZHbKZthsNoOekrFE5n0zKnTyRbnJIITnDCeM9vjQrfJ+4qcHukDJxdz2RBZjfzISJXFTye/XDAABhH/ClCaZA9nXxWyzMMH+yVeYp4KMW8cTDt7jdtjIRVzdi/Bmwix4vigBvEyeb393r202OomyMkSTLXO/ujMZCLRtxge1PMx/8Zcp3wAHgebLqUY4ECv83P6lVkgrKPbSyLJJ03xtmfTOzW71CFKirDiGzLvd/+kTe0Hps50K3VLbrP94o4UJDO/8RED3RSiwfw3U502Zz8qCpg+JOz4RCL3PRGIR2hzkgdoHzpUOS0Rv8LUx6lP+bXt0z1FY/o7/VBwCb53zHsQcZlFQ0nd32V240gtNENdKer5QgIpRI2F6uHpGrr9LcitweC7CMD9OFlufOJg9zRYhmCVo+mDHnqWNHNftyAP2cpCK2Aatz2kdLCI0+vxhs8Tvh4yrNTqL3EJjuogzJ8Oi/Fpf0uGIbXBAsuAVtM+HSSwAhyz96rVzb/gVYaOeC4NwNJCvYmyz8tb1VqEVADV9VfW4fruECHV9Jp7OZbxCDm82byk/QJjbw5hWyNrzjThge+mZBz
 v1CcfRnQ
 TQTBK2dJ7uUBm7GCjErSbm11rP7ZQgBQ0ljfkhwQOjA+lrv/j2aaIdkpMQoaEZoDyKCfpy786hJBcKJCqeercpceHmWZ20RmDh9VTgWbBi9GeGK39P2HVKswsCagI7PcsvtvHGvsR4PNLNY/8ZqmYKAe0inzghQM8lGUYTwG+lBtJ0iwF2YMaws+JGZSh290b0UcczkZ5Y/FGq6ckyuhyz6Q6ZZ/Xa8ZOHU+S/P01nmPHoLvKt/hGZBJIsazKSVQ4X2CFHDjaWtwnwK+5i1QCYInMkLtSbwGYpWvReXtEd7lcdMlGn70lXyXflzVDnhaOzBBXMsF7Du+uacvop9LYIHy8Wtjh/5W7Z3xQkUTHPnXkSDvCFJktdwuVI4XLH6zqBE/BRTkRGNqypkw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 4, 2025 at 5:29=E2=80=AFAM Arnd Bergmann <arnd@kernel.org> wrot=
e:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> The newly added 'flags' variable is unused and causes a warning if
> CONFIG_SHMEM is disabled, since the shmem_acct_size() macro it is passed
> into does nothing:
>
> mm/shmem.c: In function '__shmem_file_setup':
> mm/shmem.c:5816:23: error: unused variable 'flags' [-Werror=3Dunused-vari=
able]
>  5816 |         unsigned long flags =3D (vm_flags & VM_NORESERVE) ? SHMEM=
_F_NORESERVE : 0;
>       |                       ^~~~~
>
> Replace the two macros with equivalent inline functions tto get the
> argument checking.
>
> Fixes: 6ff1610ced56 ("mm: shmem: use SHMEM_F_* flags instead of VM_* flag=
s")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v2: make shmem_unacct_size() inline as well.

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

for v2 as well, thank you for the fixes! :-)

> ---
>  mm/shmem.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 3f194c9842a8..b329b5302c48 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -5794,8 +5794,15 @@ EXPORT_SYMBOL_GPL(shmem_truncate_range);
>  #define shmem_vm_ops                           generic_file_vm_ops
>  #define shmem_anon_vm_ops                      generic_file_vm_ops
>  #define shmem_file_operations                  ramfs_file_operations
> -#define shmem_acct_size(flags, size)           0
> -#define shmem_unacct_size(flags, size)         do {} while (0)
> +
> +static inline int shmem_acct_size(unsigned long flags, loff_t size)
> +{
> +       return 0;
> +}
> +
> +static inline void shmem_unacct_size(unsigned long flags, loff_t size)
> +{
> +}
>
>  static inline struct inode *shmem_get_inode(struct mnt_idmap *idmap,
>                                 struct super_block *sb, struct inode *dir=
,
> --
> 2.39.5
>

