Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9C79606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 20:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=FjgHGIwb
Received: by kanga.kvack.org (Postfix)
	id B208C6B05BA; Mon, 16 Nov 2026 15:13:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF83F6B05BB; Mon, 16 Nov 2026 15:13:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A35B26B05BE; Mon, 16 Nov 2026 15:13:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C6D26B05BA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:13:28 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 22C5F40103
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:13:28 +0000 (UTC)
X-FDA: 85442082096.20.34CC89B
Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id 35823120010
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:13:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=FjgHGIwb;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794860006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BDGAdzVguqNy0JEZoxyPcMqb3hE97RGPZcChbfGjrxc=;
	b=WnyRauDPFNGnamhrDxaAi0imQpwxQfUXxx7bQjMSJIgBaSinayaHY5z4j9ytk5ctfn8GOL
	6SqMU9yeCEeY2OKph1uuN0blr7cKEV+G3+NDf7CZGG6NABAPoCfmr+HF15dGYhY4NNH38x
	16d1yK9l1KkhK8Uz6m1mHM2tUgI+1Vw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=FjgHGIwb;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794860006;
	b=3yuBvjdACetKAcGn72OLDZ4BhoTSYM31p2lZVsrJ0/MSc9A8ALiHP8KIw9FD7uij20T6LN
	8InRu3C6iDCHSqH6b/17vzU1setRHCYiDDN2YntA7asHQclDYz4LFx21s+u1VexZgN16ls
	1hgP+MfStHGE03dzZcJYQGK/6nSwBtk=
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-5ea969fafeeso1206174e0c.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:13:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794860005; x=1795464805; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=BDGAdzVguqNy0JEZoxyPcMqb3hE97RGPZcChbfGjrxc=;
        b=FjgHGIwbmdPx3fMY67BSLUV3XpGCKlbKrUUzXnVhSG/RrvYjI/BblJPT0E/+0MBuMZ
         2bmHWxC2pm1VVrcM3vXOnoxW536AtBeQ6biibhS7MHLOtTICayBuTkH1E6C/neBNk98w
         LJsL7lweJYStZzmhGyWyKubd6kNlNL4oFqz35jlOZsVQgtEwLjU2NEbqs7fWsDkpdJCi
         D2/Ai8pJDk6AqdOUbF35nHpa+iX26wdMIRSiC28SgmaGwqd5hrEyfLq6AkAqzPTwEF9D
         WBqXeIshWU4CvlmH3/ZaTjVQwxAGKeHzAsolma17J/wEuItrH7Xk1qt6f76KcCijBh0H
         2LGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794860005; x=1795464805;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BDGAdzVguqNy0JEZoxyPcMqb3hE97RGPZcChbfGjrxc=;
        b=V54Xz2PwMtqn2nGqKI7Aqg5aD9Ctpta4avYYjMMCp64aH7OjLFCX8lEgV1xL/rI3eM
         UCGZO8K1TlAEhPqw622m2ZsBMRxR/rywO2coc05iLuLGOfJZXZdhDduxZ+8d2wWs/xj9
         uyeLa2iLqyfqFMqIyZafph9WBoc0UwfnkaU97Eu0/8Osee9ejqFdoYxVFAEd/8BEaWQH
         1a2WqPjzL1B1bmpqtcV7WoMbug6bGKPhkkqoTgNDjlQAdrElB6Th3R227IfD5eJ+EhnI
         ZjjsO0gsh9qbacFBIKA2odb6Y5DZtFrw0SCKHCk5aOA3BE8N4Zbdve/xENCp7Ve7ecCm
         ts4Q==
X-Forwarded-Encrypted: i=1; AL+hErFRdxXrnEUt5zgl2/8cem1GbhfyY2F2aDdVO5/B2ctuLpthOP5QjI5T1TW/J+1bv8uqPEWXfKuhcQ==@kvack.org
X-Gm-Message-State: APuU4Z9+kvhxF9EfmOmxBArtt6tNzEWJgEzLK3livvJH3Jz9dO/dtsrO
	ymDA/vF44sXMwfj2NwPuBSiYQG/BsYnSwPKHXUCgAKY9MYHeO6TbgjgtGrdPB3FBFUo=
X-Gm-Gg: AYBFou0fWmA1mg3vs1aA+td1zYkJ/vtVa1OT7VZLXQcixM/k+ybDQZVN/rwqREbLwAB
	kPvwC1WkHsxeDVHCPUc5x//RwgddpLycD6G/khz0wJPimrfI40qpPYQ/EOm6w5gzBnK+3U/TWzg
	cvR5+LHSQOty9yDDodGtUxQb4iTgji1ZwIMjb2kTAYq/ArCRZ8fbnU1D37BALC7/AcO0M386zZi
	aIy0PrhuEk8Z5Qxx+sp/0W+ATDLsolZPi3MR4GlpPdI1c/45NX71M3sqhPH4WQzW4S99EOnKSex
	CFUB0dIdH7UW3nbnPx+wh0ohBs5F3OVrcwQH8Q4ZjiknLG8vUgtVWfh82TTP25mEBNFcDIDy+kU
	fo4v3qiaBZLlHBMytnjbx2Xe7vBdawiDsKw0SxbAJzHAlFVabznzI405/2qAiz/1aDHISlIZXmG
	4txxUMtUdoghOAWHGjdNpyhN9FP9APTRwizQZQ53kvNJzWnhR3iaML/WF0DK5mTWcEyEMaYwttK
	WMnJRhyW17ju9UVbV0WI1Zup5egclOWrrTP995FXBrVYdgsBDeL7NgMld+WN+qwRVeYLEeemRyo
	f3pQq3o/rRZ6E3dz5XCdiO0I7CElrph4x7z5aje1JaxzpkyoQeEZnvlnbaBweLrrwHYQyxw0xd9
	XC64nfoLCFcDcRw3cYF0MJ7p4oeIrr3Q1BLROat+RUhERUuO4V3oh
X-Received: by 2002:a05:6122:3c4b:b0:5ea:389c:51fe with SMTP id 71dfb90a1353d-5ee34aa9574mr3361794e0c.17.1794860005139;
        Mon, 16 Nov 2026 12:13:25 -0800 (PST)
Received: from localhost (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ee3e031bf0sm5639266e0c.5.2026.11.16.12.13.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 12:13:24 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 16 Nov 2026 15:13:23 -0500
Message-Id: <DMWWRQTLNYH6.1LJ2K5HT60LK8@soleen.com>
Cc: <kexec@lists.infradead.org>, <linux-mm@kvack.org>,
 <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-kselftest@vger.kernel.org>
Subject: Re: [RFC PATCH 2/5] kho: build KHO objects into a single kho.o
From: "Pasha Tatashin" <pasha.tatashin@soleen.com>
To: "Pratyush Yadav" <pratyush@kernel.org>, "Mike Rapoport"
 <rppt@kernel.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Alexander
 Graf" <graf@amazon.com>, "Jonathan Corbet" <corbet@lwn.net>, "Shuah Khan"
 <skhan@linuxfoundation.org>, "Randy Dunlap" <rdunlap@infradead.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Tarun Sahu"
 <tarunsahu@google.com>, "David Matlack" <dmatlack@google.com>, "Samiullah
 Khawaja" <skhawaja@google.com>
X-Mailer: aerc 0.22.0-39-g5d7784875be2
References: <20261116134013.1636689-1-pratyush@kernel.org>
 <20261116134013.1636689-3-pratyush@kernel.org>
In-Reply-To: <20261116134013.1636689-3-pratyush@kernel.org>
X-Rspamd-Queue-Id: 35823120010
X-Rspam-User: 
X-Stat-Signature: 6wxhugr4d391qd8zbd7r448qfwjyyjmz
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794860006-310556
X-HE-Meta: U2FsdGVkX19amCfwW/v+GHoyoIQD/B4fnf8kESVpiPh1Pibrf61CmeY1s81BSayhCz10FmpGTqxLTvRxWSi2kKgk4eqBVHG7szHjjkQBtj3VcBxLqiVG99TptH6jlNtokaNuuxVUS0PKMuBCnTKL2gwuSZMHJrmQ+wIAG2mF3E/UbEXzxdNMipVQgtawzgIUy2GoSr74Db+euAdMgU7dyYDhcUUISUOXsMYDc3+bUJTaxEUVERG065F8Xc35vUutDU7XZj4TrZsCxfxj+vE5BoUEqQxfX45OPnufNI2IvbrsvsQBwbJgtDznUhlpMq+x2BqOnA/gCcxJpVBaKoxM/Fx/z6yeONWzZApvJnVpXK4cTrfkF2Sx22UoNqBXlGPHpmQBATBPoGYUa2YBChDkVQARrtU7xpg4G+eFRW2dmRa8XlBCwPy6ZGslCFqyN075xAFmwp2KK32ofXZku1GDj9D8CBDPesF09KFBbbgtynEge7e6NaSlEqt5yG33DqmVVlT0ylBLl7SzFk5FnE6n6CpS+79uTmDO+ZDbYYMmqflXHFP8V67iFBhKgF7ntDo9XXtuy/qQ6nfNVWgCz+Y+OSkC08TfI2lFnUeHpbI5469sxy11ySbOjN0TEI0c0kTSCsv9R1Troz88BK5S+obVGOUGqciv/Apzj2HDZzoHuiZiBQHPgya0qhYwiAc2prhLyWkZk+2ckFavIcW98qjGTquyH+3uGZ2se8pZU33escga3/yxEwRLRKOpqsgkNCZgr124sa0JvN2lNI/pLvTI1po4ie7Wx2w7NXztowovxypi34I058Db9EcQKiYuIcKY+24xSTNuPNE0Q4fGAAQz/KjXlh80NOI+1i1nwmdxtM3poq70NLkkN/hNKbAjSspHKgAJ+tYcbWX7JWAXMSXoihAbkDedhmYwlUqHns5qCmVgGY7jXVmq+8LYK9gvOSyo6fvN9rqO2x5gS/fIz9U
 NhG3aI47
 7hfBUTHF6ruKHE+5tW336sZujeLP92Kgueh4YlkEscYe9aLUKg01P66Z/Cf/v/DH2MTVE3jAnUztZUIEYzORu0sDveaLIcre1iHDjqKeWA8b6ZNkDaoRxSP+cWmT3t62nxpcLmsz9VLtyUy8UaToshZlJXQkJznTaZ+cYkHOtUJ+El1CAgVDIAzyJDO18xhMmAWCQwP8ZdhlnLMs7dSF+w81D9bZqBbDLGgxBd6MJ2s/IvmfZM2XAa5/OTVVXgJEi3fFEqZUxvdWKIS9VZYRy8M1M5XJotdOQDivzXxXf26B0NZa65Dje44SQN1XkRCuUzkMb9T+Qm54aP3DSzGUfffI3cUHPcI2JZq7y6xogTpDuYIkBHIjKfYc+2C1NdfscVJix
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon Nov 16, 2026 at 8:40 AM EST, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>
> kho_block.o is part of the KHO infrastructure, but is currently built as
> part of luo.o, which ties it to CONFIG_LIVEUPDATE.
>
> Group all KHO objects into a composite kho.o, built for
> CONFIG_KEXEC_HANDOVER, the same way the LUO objects are grouped into
> luo.o. This also gives a single place to add new KHO objects.
>
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>  kernel/liveupdate/Makefile | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
> index d9f4694625567..bc679905ce3f2 100644
> --- a/kernel/liveupdate/Makefile
> +++ b/kernel/liveupdate/Makefile
> @@ -1,13 +1,17 @@
>  # SPDX-License-Identifier: GPL-2.0
> =20
> +kho-y :=3D								\
> +		kexec_handover.o				\
> +		kho_block.o
> +
> +kho-$(CONFIG_KEXEC_HANDOVER_DEBUGFS) +=3D kexec_handover_debugfs.o
> +
> +obj-$(CONFIG_KEXEC_HANDOVER)		+=3D kho.o
> +
>  luo-y :=3D								\
> -		kho_block.o						\
>  		luo_core.o						\
>  		luo_file.o						\
>  		luo_flb.o						\
>  		luo_session.o
> =20
> -obj-$(CONFIG_KEXEC_HANDOVER)		+=3D kexec_handover.o
> -obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS)	+=3D kexec_handover_debugfs.o
> -
>  obj-$(CONFIG_LIVEUPDATE)		+=3D luo.o

Please send it as a separate patch. I have the same change included as=20
part of the kho-ro series, but let's fix it outside of both series=20
instead as a standalone fix. Also, maybe rename kexec_handover_debugfs.c=20
to kho_debugfs.c and kexec_handover.c to kho_core.c for consistency, now=20
that they are not shared with the rest of the kexec_* files in kernel/*?

--=20
Pasha


