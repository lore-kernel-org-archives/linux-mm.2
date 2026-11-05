Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B27C4606A330
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 15:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GD5p0u6J
Received: by kanga.kvack.org (Postfix)
	id D9A2E6B05B3; Thu,  5 Nov 2026 10:07:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D42BD6B05B5; Thu,  5 Nov 2026 10:07:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C58E26B05B6; Thu,  5 Nov 2026 10:07:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A49A86B05B3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:07:17 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CCC88A0438
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:07:16 +0000 (UTC)
X-FDA: 85401393672.30.C5B279F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id EA23A18000E
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:07:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GD5p0u6J;
	spf=pass (imf06.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793891235;
	b=MbX+IpD2V9mj5tbzRNcDWVT7B5Y84YQIspTtKEeV0Wpzh9FBFMUr41p+z2/bnkH1K0cwbn
	1qOQFQ4i/FS3JBX2mmQtmGb74WFWcCGaV7LjmFAsT+H0XTrMx2tQuGQ8s7qYxIPAFHUS0Y
	BkMhr+/joXayzSBW8ZitPXT4c/0LJCw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GD5p0u6J;
	spf=pass (imf06.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793891235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6LZ+1+Vvz+jfm5vRHAeunaTxWBAAAXS8a4MaB1JvOmw=;
	b=6BUfM13RhSSUr/w1PVSkp12jO6x9OFZuck/z81hxYSZjmDcIydoPFIpmSb9YKveK1NHgST
	sSvIQUeBb6SUCm2QTCFha9P1O+lRqe7JG5idnnbaxWhqT/AwXrm8kGgx7L86jtmTCDt1x5
	HS1fu0NoKf86Agnx7VtKEXaY2qOeTS4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0352343A95
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:07:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB57E1F000C1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793891233;
	bh=6LZ+1+Vvz+jfm5vRHAeunaTxWBAAAXS8a4MaB1JvOmw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GD5p0u6Jseapx+w+38qghF/bxRs/L8q4opQu6FB7+4aFCDyJUWDg/stoFH7v+Zuzh
	 FwX/xd9Lw4PkbjplDNow/MwokktVQMCMD4J7OuqP+19Ou83wnaXIzD+3zwVqQHm8mB
	 63w6mEKeV5f8UcMwHxMZSIbxSSqQp3GRKNlyhiSigCECj7HUQIvcmhxBbuQEKIFh5U
	 QiAgL3de6CPWo7S6R9IvfyPgAgfFkwFYvNkMScBM/furgvFJPBEXHkpDFL/rY0lVTX
	 +umoa5XA2vTXys+cOkMDbG1Kiyd2X4vVmhth7Z9PsUSQ53k/Qf1fsBNju40h7KgsT4
	 nFxkJpbwXVe8A==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6b56c428212so214081a12.2
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 07:07:13 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBykI1nW18cnJagiTTJeQ2CXo5smY/uDAX8Lk/1/jJUy9v0EsDONcSw7wBh5wBpXZM90xXrqz2Gpwg==@kvack.org
X-Gm-Message-State: APuU4Z+cO3cq7GKuTDAOY1g4oVQVBUSrX5ur2Xu29oTnzlnxA0KdAmLd
	RVIlj26T4lXHt50QgNQ7BCn3IxKkDTGz15KoNDIeHRLxs8LIp7d2V619Je6tAiF+kypxl/F8g9p
	RROxHthQSR9McR3187iifgLCWPer3jZg=
X-Received: by 2002:a05:6402:27cb:b0:6b5:685a:aa29 with SMTP id
 4fb4d7f45d1cf-6b5685aabaemr3342720a12.30.1793891232594; Thu, 05 Nov 2026
 07:07:12 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261029172956.20791-1-dongtai.guo@linux.dev> <20261029172956.20791-6-dongtai.guo@linux.dev>
 <aux9Hm0QFJLUDPWv@kernel.org>
In-Reply-To: <aux9Hm0QFJLUDPWv@kernel.org>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Thu, 5 Nov 2026 23:07:01 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7Dsnz03iXChzE6nYM2cs+D6fdDFiWrDxX5jM13kYL6HA@mail.gmail.com>
X-Gm-Features: AclHuK-7ZT562FqR8Q8-CsL50vorYou5ohB9VqtWfcaV8ssgwEH9NV-xDdP2-NM
Message-ID: <CAAhV-H7Dsnz03iXChzE6nYM2cs+D6fdDFiWrDxX5jM13kYL6HA@mail.gmail.com>
Subject: Re: [PATCH v6 5/8] LoongArch: Allow memblock arrays to resize
To: Mike Rapoport <rppt@kernel.org>
Cc: George Guo <dongtai.guo@linux.dev>, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	ardb@kernel.org, shuah@kernel.org, ilias.apalodimas@linaro.org, 
	akpm@linux-foundation.org, baoquan.he@linux.dev, ruirui.yang@linux.dev, 
	guodongtai@kylinos.cn, kernel@xen0n.name, graf@amazon.com, 
	liukexin@kylinos.cn, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6omu6acncer64o4dfnj686b9swaake8n
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EA23A18000E
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793891234-361773
X-HE-Meta: U2FsdGVkX1/qNmM4I2Vu5e0JgnwKkaNNbw4EfLJWn6dr/LdG1717rExrNLo9DbgPqwGZ4jEA6yEYNLHD8fWl3Am0ZT48nrYJ6zE06oanPbpf9Ugn3KKE/U80o7+fCbQg+OjCApZ0uW1SFb4I/6ykBjs2fqOSP19tlH29W3JZkwS3fGAdEIzPUYc9iJmANPV8BtmUtss+TDaJWKc4PJso9Lm/8uXpbq+Fim8nOM65ioycVVXy6gTobZPTP4a0UXWYNv62GWQTSd4yF0acKk1TytIyclnw4wt1b6shJ65bao/zS/C3HL+Hlb2yQfPXGEacNvhORrwkYxpd6cSZDMPbKdUhGxR4RShUVgSNh8RnJmfdMzvwunYbcPQrWJkkjWuT04RUV3ixCJovlgWnvLPXgD/f1hp4prombd4Yth5NUR2MLunx+p1KtT2R+mavRorNuZslZAAMYh1Zw6Tb+4du1z0wzJD6jEg7Tz/8AUo2aaM4vGKPqrZci5CJ+2k9yXYjGJBJLIK3ThesiLWoetehu667Pp0zdVNYDrAEdWL52/Z3AHLfp3AxcrSbSHvHrcXpxpiXHivpUY12Ud11+Irg2kpljeWuOMBvOd+eN3pTG2CaZzDryiTz8IxqKVcyeBk+c79oMHhKRUREQ+qlngq3B0AWkUHZ2+u0OFr9LjxGFZDjaoTcoCTHEoVZLm9HgEsH9AaFSiKpNszG7p62/fH6tjYI/fOgERdav0vM9PgVTTRPEqXReEIGYvdbIeLYFlZ1d3Nt27v3+HWQuL7yTDeEewIOMPR570kNm/kV1R8zHcVIEFeR1nuRmg/kPv8m+564PM3nHeNQtCN4YythV1BXgrEBSyc4oNOk4w2qb9nPRrWhitd8pxeFBF2BCGzI6nhW3CwBMVcGrWGdudvrlyB5Jg3Wu7+2SrdjUNS7ZSl0waMyXOwHocDcbrR2YqErUeJfYvkZH9u1zM3jLEJa8Dl
 xs/kHlFA
 +c7zx5phThjML4I6mXYaIckvXyJ08nP8wgIXUeoG/B+0ksdb66R66P3ugIM+shnlTLkw/FiblZ/kA5PKZX7LYWJP8CILR/09KdTqhD8uTn58yGgIsI5Q3sh3qF343HsI6Lv9ZQN8ZDBdKHJG5X9rxlfD7MWKV4bQ88sq6u/YgKcKQSzbzr0hdnZjLM+XEAh2lY6iLGzchViilzTg8tShcvQY5z/ggEnWlxwQy9Y7Ym8aKlNrm+Nb40Zrs6VQ+pZsJ4q4vL1I4E6Z27R0CMnszummkpL1jtpK9HkAzA3SMWYCsdAr/UtJctLff5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi, Mike,

On Thu, Nov 5, 2026 at 8:57=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wrot=
e:
>
> On Fri, Oct 30, 2026 at 02:29:52AM +0900, George Guo wrote:
> > From: George Guo <guodongtai@kylinos.cn>
> >
> > LoongArch never calls memblock_allow_resize(), so the reserved region
> > array cannot grow beyond INIT_MEMBLOCK_RESERVED_REGIONS entries
> > (INIT_MEMBLOCK_REGIONS + NR_CPUS).
>
> This might be something to fix independent of KHO.
>
> Huacai,
>
> What's the reason LoongArch never enables memblock resizing and why it
> defines INIT_MEMBLOCK_RESERVED_REGIONS to include NR_CPUS?
At first we didn't define INIT_MEMBLOCK_RESERVED_REGIONS, then we got
boot failures on a 128-cores machine, so define it, and the value is
similar to arm64.

The reason LoongArch never enables memblock resizing is because the mm
code is derived from MIPS, and MIPS never enables it.

Huacai

>
> --
> Sincerely yours,
> Mike.

