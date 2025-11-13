Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDA1FCD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 22:42:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8314C8E0005; Thu, 13 Nov 2025 17:42:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E2958E0002; Thu, 13 Nov 2025 17:42:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D1BF8E0005; Thu, 13 Nov 2025 17:42:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5BE9F8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:42:06 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0AB4EC0186
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 22:42:06 +0000 (UTC)
X-FDA: 84107058252.11.37E3445
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf16.hostedemail.com (Postfix) with ESMTP id 41D1A180002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 22:42:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Qn/u5eFN";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of brgerst@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=brgerst@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763073724; a=rsa-sha256;
	cv=none;
	b=DCgdfy2krDpol43ZLPf7YC/QfGkTRhv61yH4wXljXePTCZJ6oOlF5i57S8vlF5izA6S+sj
	9FG3Yz1uP3Vxge0z0ssRrYYSkbwAXb+1ts2j4KhwOiAyh/E70W8ZaTjsI9eBNO5dylQutJ
	mbBW3WicB5M/gD0rXkXJ4417+2N3eNs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Qn/u5eFN";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of brgerst@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=brgerst@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763073724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iORugXgswwslqtIFyyyu+POzNmV64LtVZTcIC4QKuug=;
	b=t5xPcoXopU/LzvmwM/NXefgcJwEsiCrAR75OrGLR0yIBswQ75xVnL/w1PfkWTVNOXMrrFG
	uYyIluuQl3pLTxaQgNINA2tQHGWm5CTkbKOutgvNWnmjBEsWI9ByTMN0jywBjiuc+xSpLr
	WHq7kxc5D+AVKBYTCsBqezSPEUjyR2M=
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-594516d941cso1404819e87.0
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:42:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763073722; x=1763678522; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iORugXgswwslqtIFyyyu+POzNmV64LtVZTcIC4QKuug=;
        b=Qn/u5eFNpjbn5+3VG8veLET8cdDcpRBvG7itEnzKem4jxGn0ibTiYTyXhHK8yinRsz
         JVjb3YrF5g7k//UahTPjnIpFHpe0/8jcneGYBKT0AUS3YCG5jiCahNOkIvB5PO83/0zM
         omAYLqO/A3OGFuHoE9G9SLgo2T7pI8NTh1blSp7iRnHRUGrOEdfvJPTCCiKmEkerfnU/
         gFPyNM1WQg/VAyiGAloqdR6RjbT804TCvsFdV91M+OgoRNbZrblfha4yqv68ynCtTF3F
         neGryPbkvEIojPvBFYE6hlCaiOgTQPcpKuzuHpQu4eeSFOT11jWkcRoh0dZB7H70Z6lZ
         Zp7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763073722; x=1763678522;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iORugXgswwslqtIFyyyu+POzNmV64LtVZTcIC4QKuug=;
        b=pNvUzXe1y7cSxmuBCW5rPA+ec3No/oV2SS3HyiUFCw3rZMxW+M9hOEZRADxaQHHeJa
         eJ5z1h68DHLb5mXSb2S42+QUtabAnIJ+VVlQfbqEHhUv/i7sXd0HX1CshuFEUoQcXhJb
         jFihNyoo0tk5XBW81Dlp+fVwXV6MmcTSABlZ8gAKKQxV+QHRoGkDXTkB/5XEKNvREGzl
         K33HFhNMLXJ+ulr4FK29/F4L1SNlOwpFj4G59W0k9jlhS1kIJ0U9XRu+3mb8dvsL9ER1
         YeWV5uxOgBkVL2QEPdGJSmmtmk2I8zis8V0j/zONLGBUDcY8PwSeK7dSfy18gVYavNRs
         gVxg==
X-Forwarded-Encrypted: i=1; AJvYcCVJAWy0xp9fLamEkHXbPOjEz1gU7yw8UjwBDxbD9ACW06WMEej6Gt8E11iUwSQala4LKOR2FicVsQ==@kvack.org
X-Gm-Message-State: AOJu0YwoebxU7Ty4JCEscuMj3IU1nzxCfmmbsD71DX88N664tlnR9P0W
	gH1hkZlkhBeSkx8VPwOm2rSRBMLi8GHExt8pfw4Nks0KYWEOfmjMWJ24o+NOZc+Oa69x2k+BNCS
	Rx6+HoXDJ4OvRwNOMYWHzG0UwXV2O9A==
X-Gm-Gg: ASbGncvz53Pnlx+sHEfDURqQWGJOAii2f68MZpejyuqBf/JqOrBMn+hXKLS+2D204O7
	/q59bGwA9ja36Ar0ccbUGS+E7rRVasOFD3d1OcoTE3kCa7h26JMI0CXq8x1u1z02PkTQVQXkSjW
	AAi1RqS0KtNFhfEy2NRcrCCx+UIKlZFKfjksbSxwy8fdvGyHQRSOvuEFbW4JALhgdjB4rjP6b9n
	9fnzl9wPBMGEOl/+b0FTifOP2fY/DNaolWTFRWCgbm8J+kqPVWtF+jwW87KPJg8wY14dziWO4xo
	eKzvoz0wrw==
X-Google-Smtp-Source: AGHT+IFCToYdqZbl71EqpS0eC8le9ob/knb9SdPrT08DySzFeHSRTMktnUkZr5EKTLoqo4bD7c+slGVSwPhPlJCTrzI=
X-Received: by 2002:a05:6512:4028:b0:594:3340:1b77 with SMTP id
 2adb3069b0e04-5958419572emr314261e87.1.1763073722004; Thu, 13 Nov 2025
 14:42:02 -0800 (PST)
MIME-Version: 1.0
References: <20251112202258.1310754-1-hpa@zytor.com> <20251112202258.1310754-3-hpa@zytor.com>
 <CAMzpN2iwrzKzhif7WXsoQi=4OdBENZMV14Hm2a5ePukywNgh1w@mail.gmail.com> <1cd27f96-9f29-4607-90d8-c98593eacfbb@zytor.com>
In-Reply-To: <1cd27f96-9f29-4607-90d8-c98593eacfbb@zytor.com>
From: Brian Gerst <brgerst@gmail.com>
Date: Thu, 13 Nov 2025 17:41:50 -0500
X-Gm-Features: AWmQ_blr3u4Fuh8i0XUra4JykNFO4ZmM9cHhbLUDXWn1GELeMIldMfvLmrHMFh0
Message-ID: <CAMzpN2gC1NWFu5XG49cCrktTUZbDBbng71RjpALMxzSOmPrQPg@mail.gmail.com>
Subject: Re: [PATCH v3 2/9] x86/entry/vdso: refactor the vdso build
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	=?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
	Xin Li <xin@zytor.com>, Andrew Cooper <andrew.cooper3@citrix.com>, 
	Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, 
	James Morse <james.morse@arm.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>, Nam Cao <namcao@linutronix.de>, 
	Oleg Nesterov <oleg@redhat.com>, Perry Yuan <perry.yuan@amd.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Thomas Huth <thuth@redhat.com>, Uros Bizjak <ubizjak@gmail.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-sgx@vger.kernel.org, 
	x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 41D1A180002
X-Rspamd-Server: rspam07
X-Stat-Signature: 6nox85po5p5ir8iwictezygxqthp79wo
X-Rspam-User: 
X-HE-Tag: 1763073724-13588
X-HE-Meta: U2FsdGVkX1/4tkhzhfpnBZB9YcttfmwerYtqumhRt3j5ChWnvG1T9NLa9CDQqVAJiZB46NpGFZDr3XpJoRQTLLjsHYOCJD5pKOPD7wjaZq0JZRJ5zJeZY52Erq1tqg9xyvk8SI8ENw8/H4KSwqWPZ+D9QMB0puPIwjnrlAnRUebablAALtAONZIwmaiKhp21KHCYiIHpeviUPBRKyG67YcBwtm0vluofhWbVvjEaKtFUXaLAUzA8iEP2CQal2C5/Ateyo8YDXIiWmwrAC2+g8cMNE426E4D/XxHfNLjLlxBF/mRz6pYMCdjvepPIufsrX+iHcBaHgtwn2rOmwPluGJznByqCfLa4xs2taDVxqtZDdRy+sW/emjlLhG9jd1+cdUpPzSYDepO3AS7fTxYFwxVlo0t/zhp+CMlSTsKQbKdoMIHnG89THPMC9d+yRzOOjNZtx235K8MtICL653a1moFdZZ+G0txldWmbQl7QH+kG3NH+xZTqRGSLbuzYwN8NLA1Wq7KMd4G9TNQe6hiF8X8AM7pF9NflMJdDAVHi1Yxaa/Top0nW82Bt+w7C2B8a5hwBZg8iv69sN8yKNwmMiloh4bP2CX90VMy2eJa4NKU4gHOQJKWRc3y+GrfFUxruZApwB5yKhX8G4Q2Y2602J30Xz+d4HoQn2m5DvP7sUslkQZOm1lMDDKTCoIMdzQi+DnMKRkdMye7mgaL9+xw6ZdXTsdO/74NDk4487Qwvlxc6H02FqQQkM4YDh0l9kim/Uz/39upTChz66NnY3N2pvc7q4dXkRMtXZodG0eUM97RWShUAyDl4b1mqJb0eTuBlsZXPyCl/3t8rruOKdy9wOweu8sklTLATYOKeG6F12YwCYcEsC/bf4F8hcCoFBSy5UMHdkA8sfMBuSB++fAXyL1H3GYAT5CoyMtMthhg0lDLAeswlf99FLoRncpcd8TNoR++fzu8NKTW44AJTaf2
 XiZKGMog
 YBM99fkb/C78DEJc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 4:12=E2=80=AFPM H. Peter Anvin <hpa@zytor.com> wrot=
e:
>
> On 2025-11-13 10:38, Brian Gerst wrote:
> >
> > Some of these changes (like moving vdso2c) can be split out into
> > smaller patches.
> >
>
> Sure, but is it worth the extra work?
>
>         -hpa
>

The vdso2c move would be a clean patch on its own.  The rest would
probably need too many intermediate steps to be worth the effort, but
it does make it harder to compare the new and old code.  Not a
dealbreaker though.

