Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A35CCD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 15:12:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CCA56B008A; Thu, 28 May 2026 11:12:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97DF26B008C; Thu, 28 May 2026 11:12:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86FFC6B0092; Thu, 28 May 2026 11:12:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 79DF76B008A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 11:12:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 09039A08F2
	for <linux-mm@kvack.org>; Thu, 28 May 2026 15:12:42 +0000 (UTC)
X-FDA: 84817170564.28.D536321
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 104CE12000D
	for <linux-mm@kvack.org>; Thu, 28 May 2026 15:12:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=BDodPdsO;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of paul@paul-moore.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779981160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bNBevCqfk00J2rt3EB2DabDjtH6s2ImxOWmElvURxdM=;
	b=C8JZ9hWkGmt9r9FjSUgNxHUDl6QUF6U5ZmvYJDVu47n2E3SGhZwWpJo6w6A8LNBmVTELqS
	8F51CdwqGQKtbGOMtpIqGHU3Vel6LevqhGrhtVJaFJzZh0+vY/Z9gQrMJc/8+cftt05rHu
	pzY4I3Emxa6+Paj19FuzyqINfzEKHdo=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=BDodPdsO;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of paul@paul-moore.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779981160; a=rsa-sha256;
	cv=pass;
	b=5mj6s3QWH2B2kbVUNevSTuS4+EgzEgVn8WutTvRc5Imwdjb48M29u33exYEoZAvEgx8QFV
	KT2CINQUEs8ghKn28NCP/vgFQPg8qG5QI2Q/ZQdCtjKlVINM801dt0cTTkIqgkV3NDMcI/
	mC5snzLQXkGXX6e0xGN6W98HpRcSrh4=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2b4583f0a1aso94948015ad.3
        for <linux-mm@kvack.org>; Thu, 28 May 2026 08:12:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779981159; cv=none;
        d=google.com; s=arc-20240605;
        b=Rb7U7FsSXsJyJP+DsB2UHJOHXUk9FNqpbziBuXamMvgrGQl9xnrtBmdPBcesyDZACr
         SGBUUOvgVZHcxQOi6Q2BHBNlDIqCpu4bjFcfumni+16ACbV/UQvQAQ1aBIqN1gMnnnPF
         Ut6nvMRumdxQyGENqsWiectBPLUiKav7HdA+hvtx81xrvzcAuTJGEFKkZ7wY9qeySe8X
         2lqgZaNuP3SHM012by1RlLv3YNI1J+mvHOoSSD1mlfh1EzwbV52rE4yfBfvlunJx/VOC
         C+f9VVqyqczn/O2nKRm+Pis2NFePJIFbyak9sljQNfSSMMjRoOQw/UH2xukxXooRYW1f
         fnRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bNBevCqfk00J2rt3EB2DabDjtH6s2ImxOWmElvURxdM=;
        fh=/nca8pdtQJNZa2SIUXVFQCvQqkNPFeTOKas4Hr+Gxsc=;
        b=le33UZVsQMVAH3Ypsi4mcRlmGD6ZHmS6dzjMY0wRBVTDViGVjsB7jeG/tBrbf5azcC
         xwmo7O6g1bcYsCUMVz6Z4cGjfvZuka6MKE4DAYqqQRNCxS6KMsWHssXqmradtc1qpyOv
         j0lvHkHVHYRH4J0KcOI+rgAXAtxe2VvFza1v4IKulXVrpXpEcg5RGlmGZcdTXpQ66797
         kMEKtyZPJt17lXuT41GrldatQbIhXU9hvoylwnbq6S2qz7eViJUONccq4i0+OX/JSsIV
         YuvB1GkENS2xUxUhTWBHHJ79bKTM/rzKVLLXyQF//DV5mBElO2X7nTmK1yWoIPVQ8UqB
         2J1Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1779981159; x=1780585959; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bNBevCqfk00J2rt3EB2DabDjtH6s2ImxOWmElvURxdM=;
        b=BDodPdsOKny/rMkCsnKbaAhtJlmKIRYium98PoweP31LXVsLjF19pXZkT0pCTRLKIh
         2DCGLUJwsxR3Jxqv3+8UwLKrn7PsU32yCf50JVD0xzLBy+5cYdesulZUmB6eSDjv3Wb+
         yBlSwPnK14AwjJc7jSInx3CZ27WfiLfrPwfQOj4p+s75/5qeQOiBHcQzOKVgrLl1hmPQ
         yC36f6A31cen2k/E0spcqCwiIczOHO2cU4KY0AeT+Vz4K65nRZi6Arp+dDly9pG3t8Rv
         VnxoPJXo0rDZ+qDqwlb/MpsQ+jdwazo32fSp+9SIO8MqflVOicQbljWsHMawhMl3w/nZ
         58zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779981159; x=1780585959;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bNBevCqfk00J2rt3EB2DabDjtH6s2ImxOWmElvURxdM=;
        b=IlqXuKavK5hPwWMHG7pqOpMRubnHpEb/6PErTNK0N7X1wP4WdQ20TAqVajgkjhZQGV
         IWsTaMt0E5ItMuxAVQzgen0msMoouhlweD8gXp2z4LnRWDC1nHWqvrBIcVNa+TEfPBns
         K15QltyqlBKmyT+rzt4evbA5NH3qJ9unFhZI9i8sr2e0nCwpJwgRns1ijm0IeUXYEgYy
         KI/Eo2YKCIX1d5k3Ovhv5SEj/k+YCfUeUyXYk9fTG6fR4949QWtz3HIk+HccU9iYKWoZ
         Kw3VE3FBPmb8z7QmwpJlzNTdrP3gJEdz/I/+mMNGKp9ajMZVljj0kQhfWk8nz1w3SUqt
         /Oxg==
X-Forwarded-Encrypted: i=1; AFNElJ9dfkOgqjXFTbNFY3mmYl4V0fbxVTLdm9KYqcYm1BxkCYlQC2JuS+Sv73W8Bfs3izW7Bzxr+KJccg==@kvack.org
X-Gm-Message-State: AOJu0Ywtm9m4AlZLX5DNGfp1tOJkMr56brw6lja0Pd3oOnfI4nOY9Rv7
	2i4C/emwW10wxu7zbjvgP+Izwtui0pFyINVuiCkQvvY3y1hk9KNAF9jjDiMYKw0EyYnWDBwaTTy
	GFxK8QeaCQKJY049U8Fu0POuiL9MuX1HAQOU2T9ZU
X-Gm-Gg: Acq92OHqx/QIkTurf4f+0c4hZ7aGo3sh6Z+mYZJXSZe0+VQLfrpyoLLNG37aWU07CJp
	Mo0mgDCIWYo5GzaNWd22bVAjPvO/FPsSFUpk5q9T0eIpZ+defE1eFVZD7HXwk+Z4kWGchcBoQNH
	YItjM45p53PW9FqYs628gmXW0YXNSDkXt8Ll9qloE7g8G+B15wtzpJJRqs5O4l2kxWWAyiF7a4z
	HyMYk5HVC30a0vED4I2+xfMd/fUfIGn59Zr3WbAwUkYwtpcU+kBIApvRSauF8HsPOgujgDLA3H5
	CaGCY+vJsCbyO4/FbQ==
X-Received: by 2002:a17:903:2bcc:b0:2b2:5099:2f3e with SMTP id
 d9443c01a7336-2beb06ea859mr302897195ad.4.1779981158837; Thu, 28 May 2026
 08:12:38 -0700 (PDT)
MIME-Version: 1.0
References: <202605281316.GwqEa9Tn-lkp@intel.com>
In-Reply-To: <202605281316.GwqEa9Tn-lkp@intel.com>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 28 May 2026 11:12:26 -0400
X-Gm-Features: AVHnY4KGkw7s8GFEZnhSp-WLxdURT-RSXphDvHJcUZTiyxeBb39-HOM0H2amaTc
Message-ID: <CAHC9VhQkE9cNxakvHSn8wgguDTehYHUpF7ujc+tzUbT1fqgmzQ@mail.gmail.com>
Subject: Re: [linux-next:master] BUILD REGRESSION e7d700e14934e68f86338c5610cf2ae76798b663
To: kernel test robot <lkp@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, audit@vger.kernel.org, 
	linux-renesas-soc@vger.kernel.org, Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: o8q6g1yd7ef6p6biqqx3nkqpquacm6ua
X-Rspamd-Queue-Id: 104CE12000D
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779981159-795650
X-HE-Meta: U2FsdGVkX18Gk/7MPUS5fOnSlMmeuhAudAauxsuV0PRXItojXHB3ZZqO/3oHMfkbUtkIigy6ObzbP4v2Z4HYLQrH6FIgzMt3tY2C/T83hAkA0DGqZUxU4XOAcdxzZJWyO9azd8ywxQOcstpsRGK09DJ/h+zjYCgNhdk5ZDJvz3mlt8j0r9d29tSjRcovZK/t0u9uV+B2FLhoHz9VtXHQsBqXSUUvzyI/mzMGiLpeKW5p8epIoqOjF1rPBaoALUfeuoIpKVEJ1d1o5WtqvyAGtEiM9N7NLb2YkKxJv7MbthdttIA3ur/ltg/yGwpYwjC9gql7G2180dqWsTNYCxrYApduUbMToTt2Me5jWnH6Aj+OX4LPnpyC2cY+sGAJUIcJyWtH3lb2y7RHyJKsxc+6zBIWYNfR5uO3fSKpFZ6rMeEyeGqEyGpCaU1sv9dHYM8RB2CsJ+4B7vNtkoEIA3ysPlGf1I+TkFJHfQuUUVpeLuAmYBHg9XLYZucQIQqex9Eku/UWXhwczLsJqly0IgTmU5tGn/imKelCE4y0BaHPC99dHYdAg/O5cr9Vl6ArcSQ7NzEubyeAQR5JUp1lJEvkU+uASw+wPLJSF6MNrW3lbRUwUmAgsbbrH/EnIC6IBx66LqinKaXZa8P9cvB/FGPOoosn8CVI6pMku9IWE4b/h5z/U/2J0XFhI870df9WuMg8TP1/83NqEoKgiBWVyv5xr69grSjbrE2CjZVVs8W+csgk0V4ZsGLxy9Xb18+FW9cAaHrmAtK7Bze9xTorvd2OIJvAd6AyTBgMQUOTQehGIrr+jE8Ht12ASLkpocHEBRgnpkaO2RB2tSgKIqwIFKjtmsDshLvCoYpiEvFg77Y4UdBavTBk4d+efxRmrlJ0AqImiAplfpulO/3ioOAo7xKY0qFkqJTYfOpnmL/SAxS8S55btDHkJWRxXDN7G31lip02SL0RhiiteZqtygD3LBs
 e2A8dn8L
 fhbHhgp08ElHQsa5I2pKRRNv7/9brFzYmhLXOw2dqJNvXDFYje4SH3aC4I3keAFGGD5qu8pEe8JXAXFCeWsilwHJuW8iwPYi35cKNf5pRbcDFgkWShWKpKtZp8GhVtQgqdbJc1dtRfM2V35f34Ug7C7xi731Ul9jAvxqReBnZX2QvoVof3fa3g/4e5sSI9y953lQpXbWFWNE/4mQkfmm0Sumb7g3Zho/HzqPELMpjATWJtgqyHHvMih+22Uge5pjKX/4JpRwN9u1vILRfT7+KIYjAy/1jPhtnU9uOfJTSJUaey0ohvmalPOMQsc7VKM5FmAbMNetyMWBvX0ZE6Wj7MU5guWAMfzQrHwSh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 1:09=E2=80=AFAM kernel test robot <lkp@intel.com> w=
rote:
>
> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-n=
ext.git master
> branch HEAD: e7d700e14934e68f86338c5610cf2ae76798b663  Add linux-next spe=
cific files for 20260527
>
> Error/Warning (recently discovered and may have been fixed):
>
>     https://lore.kernel.org/oe-kbuild-all/202605280441.YSawqHBc-lkp@intel=
.com
>     https://lore.kernel.org/oe-kbuild-all/202605280456.3Hhpgxl0-lkp@intel=
.com
>
>     kernel/auditfilter.c:592:15: error: incompatible pointer types assign=
ing to 'struct audit_fsnotify_mark *' from 'int (struct task_struct *)' [-W=
incompatible-pointer-types]
>     kernel/auditfilter.c:592:17: error: use of undeclared identifier 'aud=
it_alloc_mark'; did you mean 'audit_alloc'?
>     kernel/auditfilter.c:592:38: error: 'audit_alloc_mark' undeclared (fi=
rst use in this function); did you mean 'audit_alloc'?
>     kernel/auditfilter.c:592:60: error: too many arguments provided to fu=
nction-like macro invocation
>     kernel/auditfilter.c:592:85: error: macro 'audit_alloc_mark' passed 4=
 arguments, but takes just 3
>     kernel/auditfilter.c:879:10: error: use of undeclared identifier 'aud=
it_dupe_exe'; did you mean 'audit_dupe_rule'?
>     kernel/auditfilter.c:879:31: error: 'audit_dupe_exe' undeclared (firs=
t use in this function); did you mean 'audit_dupe_rule'?
>     kernel/auditfilter.c:879:59: error: macro 'audit_dupe_exe' passed 3 a=
rguments, but takes just 2
>     kernel/auditfilter.c:879:8: error: incompatible pointer to integer co=
nversion assigning to 'int' from 'struct audit_entry *(struct audit_krule *=
, struct audit_watch_ctx *)' [-Wint-conversion]

Thanks.  This should already be fixed in the audit tree, if you
continue to see errors please let me know.

--=20
paul-moore.com

