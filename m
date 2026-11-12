Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6A8F606A337
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 14:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=Q2CrUZIO
Received: by kanga.kvack.org (Postfix)
	id E92246B00EF; Thu, 12 Nov 2026 09:59:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6A146B05B0; Thu, 12 Nov 2026 09:59:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D59286B05B1; Thu, 12 Nov 2026 09:59:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ACDE76B00EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:59:51 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 496551C3E5B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:59:51 +0000 (UTC)
X-FDA: 85426776582.21.BC08AAF
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5C4A2100009
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:59:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Q2CrUZIO;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794495589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mWI7ugCczmlr7WYE/mOm+2XZ65nCDibs51EgikULhns=;
	b=dtamYmmBmdkSutdtXkffF62bTqO+TJgsExkTq3Bh2dtD7Gaz7XLlm1+AY95wSWC04cNnHX
	7/U6uyEgxNmvLmtDJWxcna4LaQ64bKXh1jyFnhOqa8qUBuGSHT9oMGF37+zITFPCjiQ4Rh
	oxvJBnVe0r1kFaPHFrYfBSP9RolH8jk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Q2CrUZIO;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794495589;
	b=45iCEO7skqqXxi3h1TH5/HasNOJ1KI7wctVIR6etLpSX48KNY9SycUV9ebU5mXlc2Kip4s
	wZ2tMSwLSQOpUk/dPtYOseeaXJHeKDSw2TSg6GbUEBocCX+fubhUk15BDzQoHNteG3YO9m
	dOIHCPttVejGyUPo/4VxSeLGvR0YMo8=
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-97ccbba8e86so1176514241.3
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794495588; x=1795100388; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=mWI7ugCczmlr7WYE/mOm+2XZ65nCDibs51EgikULhns=;
        b=Q2CrUZIOEGPb/Eo1H2YWGFveCjRzwHr+knlT4wkrAH4TLZuFkeba4az9Cxi5P2NPqS
         72wJgqsgARNNIQYDBXA2Z8w03mINydaHdnf8SRriC6/FuOBiJE9pADcXKj4kSVkEUJ26
         SYXYObfNh1oMV2piKnPYmPdPKIl5uZmYTr0pTCr2fMGFUQdJm8kZcGYf/wcMwAJQfV4j
         ClyZL03aCvEGFYqP0/O7fLKYyvVAKr1DvJo0onXfH/Wq8D5v+difu5kQTSzUwqnU7El5
         uwLvP4kxztGSEmNVPv5I3WNw0JDIMHtfDg18OQ2x0HLOltiEX07Bfg0PPRz/1B2rN0sK
         Mtxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794495588; x=1795100388;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mWI7ugCczmlr7WYE/mOm+2XZ65nCDibs51EgikULhns=;
        b=Zc4UfNG16kwQgeg6Em662wCo9HbWoGbNfA83sT4GctgTs9xHBnV5avt4P8SW6djxC+
         GgrZFH03VN1U0E8Z8udHWNTeBJ82qfjgXAD7bTEWsDQgkoVF6mly31DvRS9yB0HvJsV6
         uLMl1+QjPlR+4YR3lgQ9FjNiSwq2656b7Tk2pYStEJ8gefrCjMAt9vDCPxhmWjc/bihe
         j+bK2J5XEChyGEFdj+vxEUeuKuwXzFtA47lEF9gIRAj6+tdtkc0ajSlm2f65JWQ5D7E3
         XZ89wA7+Wy+iBC9byusrOkU6F6Q32igCfjfEfqpzxVF9UQdZ+BphqgV2p/LcXBdMsWfh
         jApw==
X-Forwarded-Encrypted: i=1; AL+hErGJhc0AfKpE8LRsiNDK9J0dTJW5pwaJ0J/9jVTleJRfBy44ztUT1L/BqZu7E7yDrdEwvwmOhNcGlA==@kvack.org
X-Gm-Message-State: APuU4Z/aljEznX8bbwVGdElbQOzFuYM9LfPWCA6wytX7gjwQGdr+mdxN
	QbCvvrvcljQ+khn8EGYdn+YwM6Brc+3wE7aFBB1qNvQYxUXMf2QZlxHOBOZwwprRJrs=
X-Gm-Gg: AYBFou2+Xpnhr5BgTYDLAXd80XCmA4rEMgWfZ9KEnDgSubbba1vfaAATHNSUIN9MJwt
	2a6iRHXlHM3RMBFdYaJRG0Kq84V3DTg735Y8tZmandcs92kZdxtALmx3YYImzEnxWkUn1yRjGYy
	Xexdccpec3LXf0quh6VKRDB8RzTco/kKXnHZPk1mJK41bZXTWc9HDt48F/Yc70SiPoF6PQSKz0n
	nSTXYmyw0uDQyQHGmscqcUXyj6+VdsEsHQVyJT4B6drMVAuhft4nKgNHUN+I70DIn9e2GQew9EU
	T0e/zLTCWAsHUvyG2xIpzgfGX6uTpljo4PdXsAtMf2c7d26fwyCtFL0rer7bUZRjrSel1cGBdLN
	u1KAgARVxKdCqTkX0p0Tx/Yu6gbcgdR41rCuMynDNtIcWMxaMNnwh4MCAsfR3tebvznbdT+Tsay
	DK8pS2xiasz16idlvbSKHpn00HF9IDBqW/EeYitl+jjOvhNlHsucPjjWDWt9gqjC/8fGE1p8nKp
	5I3uxmWiuCzQmzseT2Yx1HXP8ZZyEVVtuc1AnQKVQ1KIaNP2tHg/rDypYqOeW1UXlxP/JRT2NXH
	OY/QHtns63t7xYxT1U+lMyvupdx+j1AhwTM/ifAV7cPyM2tg1i1YZdn87yT7Xj+ne2PNBMjBRDQ
	IloIjDuEdWjoecFuVV2vuWZEhRgXB5oM=
X-Received: by 2002:a05:6102:f11:b0:7c3:8150:83e7 with SMTP id ada2fe7eead31-7d4fb24dcfdmr2020028137.9.1794495588205;
        Thu, 12 Nov 2026 06:59:48 -0800 (PST)
Received: from localhost (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d302239188sm5739554137.2.2026.11.12.06.59.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 06:59:47 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 12 Nov 2026 09:59:46 -0500
Message-Id: <DMTBLFVSOEYG.K5WAQC5KN7IQ@soleen.com>
Cc: "Alexander Graf" <graf@amazon.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Chen Pei" <cp0613@linux.alibaba.com>, "George
 Guo" <guodongtai@kylinos.cn>, "Kexin Liu" <liukexin@kylinos.cn>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Shuah Khan" <skhan@linuxfoundation.org>,
 "Sourabh Jain" <sourabhjain@linux.ibm.com>, <kexec@lists.infradead.org>,
 <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>
Subject: Re: [PATCH v3 1/5] kho: reject zero bootmem scale
From: "Pasha Tatashin" <pasha.tatashin@soleen.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>, "Jonathan Corbet"
 <corbet@lwn.net>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Pratyush
 Yadav" <pratyush@kernel.org>
X-Mailer: aerc 0.22.0-39-g5d7784875be2
References: <20261112-kho-bootmem-sizing-v3-0-f0c8d00295d5@kernel.org>
 <20261112-kho-bootmem-sizing-v3-1-f0c8d00295d5@kernel.org>
In-Reply-To: <20261112-kho-bootmem-sizing-v3-1-f0c8d00295d5@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5C4A2100009
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: z7a61o5aougkkfek4nxddopg1rszmm4r
X-HE-Tag: 1794495589-541609
X-HE-Meta: U2FsdGVkX1+xWYnSa+ywTCJqAH82pPzFY6utMwCohYUWVri2GynjdlUA9gXFMFbtheq46sLlSnYsQfZlLLSqRHGoNln6pSXNDiQGtNjpbaB25i3sCxY8EBVC4bm0u7ZZbM7Brs3+NJ/w2+fImTf76ObraSY1NC16IFgeNYQTyer2MGTyFsU2k9vluutiz4iOKPRVN+DLEQeTuR2XH6n2wsd6a2IMcCBlSKjeR9Ft+5BjduuycrByrISnja7EqfrKyDiaUaYJR/MscmlbRfSfXx70yeT/BLJ0NyCq+CmZ1vkP8zWoykVuCbBzDASpgogagNATHQ4AjvF1Fuyoyguv+4anrM3G438Y4UZcxrAv2i+vOX70zIY/udwHzDaFeCYrC/K7Q29fwVgc/0D0Dse5lnCLso3LAPQbXIQb7vMGmZ6CaMRdfGUmhiZ97F/L5HIBuWeKj3QJiU2TW5efMDfQITTl6TKm6wbHHUgyqJ8jHi/qsNCwWZitputkPchHqmlrM4nRr/e6dbZoca3dmBC3d+1/Ca0MUcrIYMffWogCnDD+/bR24RbeJQnU2IqrefqAd/ABo8QpPHMU78P2n+IyLvuTHCDhBzeV9rKJkVa76UZEhyFUObHC6ykQmWd1rq+FgaJyPPQoW69D1XBfi9OXH9AdAGCQlNPRTxxXxmklarETGNEaNVzFBdJ/6/rBcOERJz4atCDbjXipCPJq9dwdUjvH26BfVhkTSNVJRaJtNoRpjTZ8rSUVch5D6yvb+rikhRocwlngPqM0Oh2a7Yy/Tj/1vDBpSgOCxjXfGQO0g589Po9XfHitnPgwpKe5zfrCfoFn5gaF5dqS9DqYPHSPZhD7uV+xxH4LRjipOOdcuzF5nFSAlMl3jLbvcABQKsL+F+Dcn2voXRLo/e1XToENgKynbfcWP/TYDP71s5MaLrY1BOLRgkbUXzgZuL0D50SLuK7H1C767uV6LhDe4k9
 7u4hwU9D
 zLnn6uRCYrh48/a3x8FUBceEmKHKCsGqlHh+b5uz0dc+sAclpScjaFvFQrsSyMmZCKJYOMc53UWeILNPs43l3Esos4lbB2C1jCo2/1cS/HX4zf8iup4o371KusDzpHbdsUiuPVqNmG2jbxruVaZuEzWwxnuBXu1LkNbJwhal26QiSiScZ3ShvmFEeKRWKm3VkbTHBjJ1RNF0bFvkKwcbDoRa7wqUvjAVyJH4q2phgBT6QtUno6cESD0wTYInRNkjBNxBrT8b3rZRZgzkOuw5ByK00ghAomAUKqYXLAJ52oKVYkZ9hT9eKq/tdffx46RtwPELveg0R59M/JYOfR1MoSxXB90faU89HXKhvaldL1SN1tgN02uKkDvf7Ytpu4pY00TneHFkaTRoxUJtmsIQQ2jZKqOsYP9GaRfQIr4Yg07Nht0iRTb2nOczjJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu Nov 12, 2026 at 5:38 AM EST, Mike Rapoport (Microsoft) wrote:
> kho_bootmem=3D0% sets bootmem_scale to 0, and then the bootmem areas are
> sized using the explicit sizes that default to 0. KHO remains enabled,
> but there is no usable bootmem to load the next kernel.
>
> Reject zero scale the same way zero explicit sizes are rejected.
>
> Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers"=
)
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  kernel/liveupdate/kexec_handover.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec=
_handover.c
> index 6f1f55fe31819..b30ba686cb301 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -703,16 +703,22 @@ static int __init kho_parse_bootmem_size(char *p)
>  	if (p[len - 1] =3D=3D '%') {
>  		/* unsigned int max is 4,294,967,295, 10 chars */
>  		char s_scale[11] =3D {};
> +		unsigned int scale;
>  		int ret =3D 0;
> =20
>  		if (len > ARRAY_SIZE(s_scale))
>  			return -EINVAL;
> =20
>  		memcpy(s_scale, p, len - 1);
> -		ret =3D kstrtouint(s_scale, 10, &bootmem_scale);
> -		if (!ret)
> -			pr_notice("bootmem scale is %d%%\n", bootmem_scale);
> -		return ret;
> +		ret =3D kstrtouint(s_scale, 10, &scale);
> +		if (ret)
> +			return ret;
> +		if (!scale)
> +			return -EINVAL;
> +
> +		bootmem_scale =3D scale;
> +		pr_notice("bootmem scale is %d%%\n", bootmem_scale);
> +		return 0;

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>=20

>  	}
> =20
>  	/* parse ll[KMG],mm[KMG],nn[KMG] */





--=20
Pasha


