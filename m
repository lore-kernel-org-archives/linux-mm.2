Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16B48CDE00D
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 04:38:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 789A38E0006; Thu, 13 Nov 2025 23:38:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7130F8E0002; Thu, 13 Nov 2025 23:38:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 601E78E0006; Thu, 13 Nov 2025 23:38:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 46B6C8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 23:38:14 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D169D57BF5
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 04:38:13 +0000 (UTC)
X-FDA: 84107955666.26.05398B7
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf28.hostedemail.com (Postfix) with ESMTP id CF201C000A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 04:38:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=g2rTefQg;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763095092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=75LsZlrkz19mYBMXdx3jHbjL15XI4sQkrG/ZqqsZljk=;
	b=w37rDGT+hJhstt6aIYxnfrHo9QkHP/4ccEIxYv0dL0I1leG3d7TYZFstv1WvUU+M6U8kiQ
	1jbDhjuFP8PaAv7YsLnxR8rYLguFA7NFtx9R0awJJ2HExblp8c9dKKTgv9Ln+gokF/diJV
	QppT86l+SG+MdmaTfRHN24BeBnDlxhA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763095092; a=rsa-sha256;
	cv=none;
	b=Mk6TXmMm4pozgdPLP+wBpADjs7fxRsep7DmvT6eJQzY9YyWd7XePOpGfYByAPy+Gd+nEWQ
	dQN/03VN77aOpKHG7OfFnSoV44GynwrUKJUp7xcisofhyxquIoo0RlKAiuSvRWZ/uf95+y
	YBACSpMAdC6CIpQEBSnfP/U4Brru+Xw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=g2rTefQg;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-641677916b5so2819746a12.0
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 20:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763095090; x=1763699890; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=75LsZlrkz19mYBMXdx3jHbjL15XI4sQkrG/ZqqsZljk=;
        b=g2rTefQgyfpqRXZlc2JMyqebSYT7XuPkNXOvW1CjpsGtR6p/7RB+lWQ3vl8Z5gUNR6
         ko3YI8OCR89MI9e5mN4XDV+fQ+ylf71nZuajls7+8M+XpGFiBx42g+xZWp4otKQ3tORM
         AUX7GxfNPFtMYOOvr0frfK7Rn7S2lq3+uioS+RSzqrPKtxkgv70EEOH0f4NaIjd94ZLX
         bJ9w7jJtbkABxalzJJ8djp3wRUVrMjhMn1mxD/RPfytQt0kMm3FM7agQQc+zwZ+v3NLF
         32D9As3hkqM6sbRQvTKnI2MROav4z2JsCsnFXZPeSowOeh6vBgiwB9FPC8ckl9o4YOFI
         twVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763095090; x=1763699890;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=75LsZlrkz19mYBMXdx3jHbjL15XI4sQkrG/ZqqsZljk=;
        b=LxfM64EU/RsjDNdCno/omH87Y0X19mxzCnKuf6/Ls0c+qnYX4Um6OsuHrkV5zjEjtp
         1gDf9yIyzF6Np050SZ6/EWr2S7kjEIYmCMJn2gZ5YSsynXhvEb5jDZT6h+utrhGycRfC
         nXl5PcM3dAI3fWWl7pddME5fn3dbUXzrh9af6xnnhN4kd4lQeOkXYKaSYpzjXn/lmxoJ
         3s+OfnAzKZjcAX9XljXwawJ/xwPmh1dKs7r9m3hNRdnkqJ3UHQLXrNA7+GsJV8eSenMr
         VpeSQANymbOpZPieqQg1RNZkYB5K8oMubHc2gp9TbpdKgcbjpeuiAmZctfER9P816uYW
         /4PQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGeAgiqTFj6J3B/1i69XuWIJitCif6u3Xn2ZtslVF9Rl+89q2n2mWqBaSBIECcdn92+2uO8p4uSw==@kvack.org
X-Gm-Message-State: AOJu0YyIier8vPW48VX3XRQoIV5ecnuemMsUACeBjGfCFgZvvb2VwnaM
	COXNJWrKMVTVRSrLZyHLiqq1HJO4FRRTpMoo0hG3CfJ6Qr8gjRUi1xezjII8DP4IWqjO3z6zyQc
	X7yZ4gXgSqBk6grKCOx1SeXVwHy+NE/PsAkU9p3IGDA==
X-Gm-Gg: ASbGncvKfVa+zQr0WN3YVyXpu9NZOIuS8SSSCBm0fUpSrPXudTfAqY+iRFWOrCOOOj+
	LI9uV0tOv4yugn0QErG2AD93r0oNl95NjOVPzbhTneAWPlsCYk6dObgqO7Jj5Uy3zUpHMZyc9h8
	yJILi2oBzqzLPDoubQ9e/fP2z9l93tqQUIvECDK6OPJu1eMqh2X5TA3EosOgKoYonoXHr6IlPTX
	+xV0yKpGL6yiK8YUCjEtFMA4/lY3h1lc1UJ9tImiD+GlZEkrqKF7GPQxQofBMPifhV+
X-Google-Smtp-Source: AGHT+IH5rJ8YaoOZJ/bljbGnJEtpsMqaJ/zjTHTHaUgm7y1k6s4PlCcpG4rSsf9/sg1rVEhMd6xOPfkaRP0BAtS2RLE=
X-Received: by 2002:a05:6402:2115:b0:640:ef03:82c9 with SMTP id
 4fb4d7f45d1cf-64350e1fa2cmr1323111a12.11.1763095089974; Thu, 13 Nov 2025
 20:38:09 -0800 (PST)
MIME-Version: 1.0
References: <202511140809.4JN2GCxV-lkp@intel.com>
In-Reply-To: <202511140809.4JN2GCxV-lkp@intel.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 13 Nov 2025 23:37:32 -0500
X-Gm-Features: AWmQ_bmvVrEBXZ1NreajG0yZ7MNUMcDUJEYu2_AG45IpCCW1b9-zmyc88OFNQWY
Message-ID: <CA+CK2bBR5qqRMNKVYezCn3RsHx4=YLGsPaCb5DhveEQi3k6N+Q@mail.gmail.com>
Subject: Re: [akpm-mm:mm-nonmm-unstable 84/106] kernel/liveupdate/luo_session.c:101:3:
 sparse: sparse: symbol 'luo_session_global' was not declared. Should it be static?
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CF201C000A
X-Stat-Signature: esib5qnmpmthndixwustcbmju9wofxuh
X-Rspam-User: 
X-HE-Tag: 1763095091-209776
X-HE-Meta: U2FsdGVkX1+G9zqw1uhiweoa1vNgNLRv971xkl85yRmW1WOPi4hWFs3YlwKh0IAbWAdyDwaZlW68i3uMQJU2xxk+efPgmegDXBZqR/i79kduELyIi+zrBzZjysZ4s1lZwg5gN2h7GC33yCJpgNzLwD9SVtpONVfuKEVKQQDrm8oe7F39yYL27cVWdyT7APV5dFpoccZFJDqbxkZpgZSF0n7s/uhnWMnSFj+xQ1k9nUj7CoZIZ0aAwvdDDLQARWcZ2lj8L/thBlBtFHDrMMfhffLgsOHndldv6bKFfQYWTMtMkZ7WzQgrI/JAaVFYGTxBuJTBrepavL9TmyyGusKYBpwsaYQy+daqQTKWTGK5fJ3/y1B23J5F3qSBlEgQ+SuQ1Fltu3ZdhxBPKMTAcBLv+1gj+NWOh6amNtgMh5TDIzAE2cihLkWwB2Qmm/HtjK/xSB42gmbCTCuaESj8zx9SZCcfMmlvuiX/tvYHgb4TX9dSxNme+CucIICsFlunGXwOQfnvTfSTfmhQHf0jY0nGxBi9NPhuauOtgZp5/plRLNCqS44CR46R9VGb8DARWdYD9s0hP7fmzeJjczOVBxG+NsD+RcSzvBUqulTnzNSQg5VgC3CHW9cAT4/TQAl2+kTj5/8djnVMaZCkFoTzjzcH9406SuF41R3LMsla2kQTpmv9cHVAYewDkYhzEau2RwN3mwpeS2D24tVz5DxdWcibcAoYOtI86/EJtj/q+Kq4FaLpRe98CIy00ti6GL2uu1eTxchgIFUSsfVhf8IdfVgZW7Ws8SwZywAaoc4QquMLYW/pblO6LSUpYX88TLXtJI6XL7UBEB5ccg2154m1yxNETupqhmCK8PnQWhiSWz/1rKltqNQZcroJb1iaqKAVYuxbM0+IVrm5dLHH8z0MtBNr5EUxmi4fIQW0WBbyfJhgPoVzc/XSGUuznbRLC9qinTZWk/Af75Iu9+oj0Zib89S
 wct9/u7o
 G+F4CNU6qRvaR1Bu6aQ7MUCfHv8Lq2FXUfdvUMyVQQxM75kUX5BaA30Y7HX3d1TupqdeXQC8lHM0pg8Yx1reeNnYzMGpgfEFhxUwr47nJ8Mw8gJuAMh8u01n3lifK9yY/v9xYH0/9GFlOISh0hi1N3MlKCE0HQg1luxrTym6/Kgp84l+A+OrsICo6Hjnz2/Id8xiakjzWG3EXNUJzVIAuwQssSjBSYsrdCyK7gaUdj0Hi6UJodEPUbuczFHGHKf2bBrvaorQI5qFRsOu2jcnNYMIJr51urRTtu2rfhKFwvf0tDRZd7nIL0kRnqyCGt1oivKl9L6wnNVuIuZHvZv6fay4MnvIWTv51qP/4zcHmLTGG+O3Z579ikzIMVZ1P+e8i6UnFQp5S6MczAnJjCLKLPkdS1c00WQKEEtM83cvZ4EPvMvn1vFdONcej7cacUaohSCHxDOGUsJkVpy+rMicNO7VPCA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 7:29=E2=80=AFPM kernel test robot <lkp@intel.com> w=
rote:
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-no=
nmm-unstable
> head:   c3e0350a1f9934c5e56d859a26bf37a15ab7bb25
> commit: 877409d046405d44ba7e15e19345239c1affa4a5 [84/106] liveupdate: luo=
_session: add sessions support
> config: x86_64-randconfig-123-20251114 (https://download.01.org/0day-ci/a=
rchive/20251114/202511140809.4JN2GCxV-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0=
227cb60147a26a1eeb4fb06e3b505e9c7261)
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20251114/202511140809.4JN2GCxV-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202511140809.4JN2GCxV-lkp=
@intel.com/
>
> sparse warnings: (new ones prefixed by >>)
> >> kernel/liveupdate/luo_session.c:101:3: sparse: sparse: symbol 'luo_ses=
sion_global' was not declared. Should it be static?
>
> vim +/luo_session_global +101 kernel/liveupdate/luo_session.c
>
>     89
>     90  /**
>     91   * struct luo_session_global - Global container for managing LUO =
sessions.
>     92   * @incoming:     The sessions passed from the previous kernel.
>     93   * @outgoing:     The sessions that are going to be passed to the=
 next kernel.
>     94   * @deserialized: The sessions have been deserialized once /dev/l=
iveupdate
>     95   *                has been opened.
>     96   */
>     97  struct luo_session_global {
>     98          struct luo_session_head incoming;
>     99          struct luo_session_head outgoing;
>    100          bool deserialized;
>  > 101  } luo_session_global;
>    102

Thank you, the fix is:

From 3c561cef2649c368b8aeb8e6e16fd096fd8634a7 Mon Sep 17 00:00:00 2001
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 13 Nov 2025 23:29:18 -0500
Subject: [PATCH] Fixup: liveupdate: luo_session: add sessions support

---
 kernel/liveupdate/luo_session.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_sessio=
n.c
index ec526de83987..e1a45af892eb 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -98,7 +98,9 @@ struct luo_session_global {
  struct luo_session_head incoming;
  struct luo_session_head outgoing;
  bool deserialized;
-} luo_session_global;
+};
+
+static struct luo_session_global luo_session_global;

 static struct luo_session *luo_session_alloc(const char *name)
 {
--=20
2.52.0.rc1.455.g30608eb744-goog

