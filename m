Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DBF2E6BF37
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 20:11:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B7736B0088; Fri, 30 Jan 2026 15:11:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4649F6B0089; Fri, 30 Jan 2026 15:11:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F2106B008A; Fri, 30 Jan 2026 15:11:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B7CF6B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:11:48 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 62B641607D1
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 20:11:47 +0000 (UTC)
X-FDA: 84389725854.13.3E9EF6C
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf13.hostedemail.com (Postfix) with ESMTP id 72C6920015
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 20:11:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O8Rl75P+;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769803905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KqTERH/+2h6DWpnL/jhYC24xZ6zypIXUC8x2yGcNW24=;
	b=Cmno7I8zIMqGOm2PNVEbkWtBUjw3t2sJ5qPhQI4jCMZYKucBSwWikeL5YJ94/5G9prm/KV
	0SW7R4kKuE9Hv38xOcxktMLXHX6yeDxboFeWV3f2EFkJjsC8lVG5nBjjj1tQE0PdASDsPO
	ZE/Ow9NpmS+mIbnyBirRLVzmFX83UDo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769803905; a=rsa-sha256;
	cv=pass;
	b=VJnMEb9lkdj4mBnxAUNpsTgK4kS11/kRbe8VYUfWYvIcuzhsxiVQNe1HNQzH66SJc9qIjP
	V3toVYmY0brWaSHfNIDmxDBjBKJXd5+jotJqPHXcLQ8Xq9yVpG9nbe8a7qdQyS4aYE8XGe
	FehmszI3n1fd8xlfQKVbKejiRHSQyrg=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O8Rl75P+;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-34c93e0269cso2188838a91.1
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 12:11:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769803904; cv=none;
        d=google.com; s=arc-20240605;
        b=MZ+jNhiiF3jT58imMazwvnEmE8hV1g+x6NwpSEOsDLongyUWwo/RrHqaP3b51+ED/J
         7Dk2fzPXkPwHmlNQEeboSfRL0PO23DnALiw1KTZqOWCaTvhxpedG9szGtw3i6KzL8xYZ
         zUJKo6IXMe0XxikexW7Fvfalw0+PO+hQa5kj2kwJwfcbaGM2D26R/ZuA1fBo0sLiOYeH
         F6iJZtFgaQKoqqW5pXXWN+ZXHOByJjQM9J2Cd/dZs5D6rioH6EdK8qX7E119Nt1J4Ayt
         oi23HVH/ij65RXf7YyorsOSfDl4CezP1DB+UW7OgeX6GmKA34Mt0s1tEGVlhJoJfZfb0
         lBFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KqTERH/+2h6DWpnL/jhYC24xZ6zypIXUC8x2yGcNW24=;
        fh=KzDcromgYX7bva+7UFiQdmxpUe+wYJya3vElXjcP7Jk=;
        b=B12RfG+5HxiSxvbEyHl/Iu4/T/dR9P0/rc7je33CiDPdMvd4+ibN4IbrSie6kM9V87
         mOoJ2HBTd9YaPfpfrxpL16xuqtBXKKYIHbyGZqM7BbceLNPAz1w/U90GakVwoDbVR1Ek
         gmnvq+E/7B948fDj0jt+uhI/WX6SCVUu1DxWyv3qPLqGsgjYY/HbkI/cbQviPGjJdDaN
         MGBYHbjEwH4MLPcpBUhTd1RTVNFO/pSnp4515CM9ZBBsD6fSANAaF91DifGvLclsOe8y
         BYBVyAambLMyW8zou9yLxJf0xrcF3knHHKh0CtzGqkBpedXBbqdHlINxf7Obuy9D7fp3
         +gIw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769803904; x=1770408704; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KqTERH/+2h6DWpnL/jhYC24xZ6zypIXUC8x2yGcNW24=;
        b=O8Rl75P+ePEUWHrlSDOA/J3+PeKBY9gmt9zrOYYWNZFvODEOlEQYsfseden9NlU4/G
         nGXhsPpQARx732CYovQp+iqrxzivsYB1xgJumnO2jwf6zcHptQQ++ZoNor3Gwy5V+t+U
         WdwKdUr/RTGuB6AGQzIu/HS86PYVa8Hcy8gM7tYwGMluYaXjmsXaNr5TwlQyeaUpV5xF
         J/bSwQwb+F5uZZxsDA2uzvptjLgpPhp/nkWkav+EFKZmRibJyAGhDAotWMXcHP4ArUgr
         ARSBoycEI51AB03VcgRsXkttu0hstRRCXJX6xnaUqPCIU1sihZY5CMjl9EAIYObTS9sA
         99vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769803904; x=1770408704;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KqTERH/+2h6DWpnL/jhYC24xZ6zypIXUC8x2yGcNW24=;
        b=dN86LEYH66n5x8IhubpXAterg6/acHDxSYJu3scBsykr1tJnVd2L/DX1V5lzDPNHs3
         MQlGsR5P5cT7gCRDfb2cpbiaq8TJAsr7/DKPNWyyb+IEDS137CewOTLVznpHZbyZg2Vn
         /1E2l3Ykc/HMK8Pck7I6ll3S+Y9VTPRzJ1b4Z0bF8DI3TVCdMZIownU/KmDDQjDQs9rU
         LsNG8Yd5tSyjmMnyzm2/KNU9AveUEYe5nTwy+XK6zKKgDJ52re1YMy7YZPJ5Ags/Fv3n
         5AzWycViYrcy0RjfHeJwEWMuTz9zlrdnOBo932yVB7I4QbGU+0u5Cl1hx7yPSiOApF4L
         QSvg==
X-Forwarded-Encrypted: i=1; AJvYcCWChXUrMm3PQp+JwxqcfYKbmQ0fFvpK8h/OhMmn0BH/nK68GxFaC/gah6LoTT2J1IQ2r6eAzsHxqw==@kvack.org
X-Gm-Message-State: AOJu0YyuTOryrt73vhFxM4zVThFvDq4M8tqfhmiQlIZvWpC+1O8sejCo
	XsxuiHFILJk33G/9TcNLOPi3i5fS5uRhx9hv39X5qbglfeE5a35Fhh1dStyVKC7V3HfZyE9DdcN
	KM5P1gcYf6+6AgfE72GSBq6Wj/ohNaxQ=
X-Gm-Gg: AZuq6aLtcUEOuwJBLLqtcD4zbAFxYDJYq36EgGEPt7ofUpBhiolqimV8h2/UVEslKXh
	j84lXbiejaReaiyH8OXBkxdHKCK7H5V1Rskio9Jiq30W7fXIVoF02fYWmwHlxw7tLFypsnDJPP8
	mB912s+Uey6syfiRnpMTG9+S4eMHioDKTxadg3o/Gs8XdZC/zHo2288GpSaLAKZ4qgHZDRS4FMp
	gLd39kygsYtCd328lTA7SJMuapc+qLb9QzWaDl88J2+yJkphf3zuIwQP3oDRFENww4XTVnXAAhZ
	D7SbFSHKJj0=
X-Received: by 2002:a17:90a:d2c6:b0:34a:a16d:77c3 with SMTP id
 98e67ed59e1d1-3543c3a6c21mr3874104a91.2.1769803904268; Fri, 30 Jan 2026
 12:11:44 -0800 (PST)
MIME-Version: 1.0
References: <20260129215340.3742283-1-andrii@kernel.org> <202601301121.zr5U6ixA-lkp@intel.com>
In-Reply-To: <202601301121.zr5U6ixA-lkp@intel.com>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Fri, 30 Jan 2026 12:11:31 -0800
X-Gm-Features: AZwV_Qj7wDya2OBtNs7PUmH8JcxUTODcuVx2e0LmJSjVryNSnlC4sk5utSn3GV0
Message-ID: <CAEf4BzZthAONGByqvk3pHRT3GaA8=fNbz+d1V1CY1N8sHEcsjA@mail.gmail.com>
Subject: Re: [PATCH v2 mm-stable] procfs: avoid fetching build ID while
 holding VMA lock
To: akpm@linux-foundation.org
Cc: kernel test robot <lkp@intel.com>, Andrii Nakryiko <andrii@kernel.org>, linux-mm@kvack.org, 
	oe-kbuild-all@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	bpf@vger.kernel.org, surenb@google.com, shakeel.butt@linux.dev, 
	syzbot+4e70c8e0a2017b432f7a@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 72C6920015
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: d7ee77sc7brquf1za596bg3fwtdhtsu8
X-HE-Tag: 1769803905-186900
X-HE-Meta: U2FsdGVkX1+2xiSgvf4Cj5f3UQPjulXtlFDojS7OS9Sw34zJ8GEzRCCUiuUb7i1q/ZPI8CmsnSs9xh0dtmX1z4eeQ6eKh6n2/KJLk26czxuMorBe2UkfQ7NnJmgu0WzrYLjBKVl2IeTPe0M5nkeYwlsmxFtB4WzNA6svKuBG5B3TGoc4EIYtP+x/B3Bjti1+7Cjy0KaS9webFSGXfTxr8MpFgmAFEJlndWbyicnJ27bimVErXMexlhvISWDDkXr8HrolTJw9kIA88dhPiCVDAMsyXqdrww5euSO+NbNubP5LMB6D1PZ4KU2kWvLDG7qFU4Xr3eJ2Kuw+BQbY7xAnRK1KBE2kGSFEfmzY3hC3Sj4yIFfQhhpSTv2XKwtxHkrQtebUUFdl1qQms7nxOuYbAXRXLp+r2KDE5f8FDsbEcqSecRn5fOEftX74oJSOKwsUylql85ZPtJYtawvyON+QITE3wA1XGYhS9cMvMXokLdc572rg69ELPppa9jsO0Hk8AEelTR/zaREPsSXSn1qMWLXH9Ha9UIf2JTARmw+6ECUm0d5/hdHIwDWYBJBN6zio6yrZAZxERx5Zfn+O7jdC66w22XJvTakC35vWS+/cU5Dvm5Y7l3JYIf7RicCdUdwoWrEjs2Vp/VLi+aJSAplbROgz4FfO/Vzfm4VHvFamdo4GF5kNhdTZDVae1K8faKrOeUzP+LGVkFHgAmJ2N4+zSvxJEQ21zNbVmAn6DExPQiNtntV9EDBKzgJDxa38Shz+4ndAZeAxcUTd3Hbm1L8Nx9i/82Mx7txB0RVbr9XXLSU4C34BUEHa9eOaCEncFl22sjBYcAUZnmEs3PGgbvmylyfqBbRuXjKq1WuiHT2o2nUmiZy4eBs4kQhspsa99AUADe8s7pBiYwO7XiT4FR4u4pPxxYHZZcQGeyiIP7g6eYZD1M6rYa34V5pgM7jplM1FNb9b2UQtsTssDcZx7Qi
 B20IL9T0
 UzvQLbUqexP6WyHDaOgrBSKyLEkfS76mqUGoX/o6Fn9a/qDNt52k8QVzXqypyPFkB120nnchXw+EJG7HeBIAPuCpaYLwdep7FWRjc9GNHHh92pzgMR0eRXW8F0Y//6hFQKPBVORGGn38SHr9wx0wO6z5bRfbHHsuQNDXrSMvpt9jQ6gbxyh+7UB3VVc205MTKtTzq02MPOv5aIwKtVb8bXN5XZIxYEj0620KUvNXsR36FUJ+phs4DXEJp1szobb32ovFKwuhQdolVFDEcJQEH13P1voYI85U3Zgdp9B6SovmkbbCHxgoZgLPHr3s0cq67PURxHCu5Fc2LVGZG/KexRCX6kKuwZ4eEocrF5xRRYsiAHjqdqLsZPanJUiXNfW0R1ggCdAcZPwZUOEYhtrwhvkvzGmvV5pE24jJtBnm/WzC56oq53HAcHwBcAfGgFxQjk8LyPYw3k1zWAhgxnW67sRxA9Agg8bzHI4MwvyEjTDAu6I3COurvCgPHCu9ukmFeg6Qz/sAMTLqgw/pVCxCrMLRyt0xwqXckq/dFRl18RunrIzF/K3dlaMLqsiNCLUI0rq4kVYgtG2bPIJrwv0u/e8zZBsVxfFr6alS0f/cXZQroU6q+6GG6h7Chqb8/IwibjZg2eD4BGjagKRc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 7:55=E2=80=AFPM kernel test robot <lkp@intel.com> w=
rote:
>
> Hi Andrii,
>
> kernel test robot noticed the following build warnings:
>
> [auto build test WARNING on bpf-next/net]
> [also build test WARNING on bpf-next/master bpf/master linus/master v6.19=
-rc7]
> [cannot apply to akpm-mm/mm-everything next-20260129]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Andrii-Nakryiko/pr=
ocfs-avoid-fetching-build-ID-while-holding-VMA-lock/20260130-055639
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git =
net
> patch link:    https://lore.kernel.org/r/20260129215340.3742283-1-andrii%=
40kernel.org
> patch subject: [PATCH v2 mm-stable] procfs: avoid fetching build ID while=
 holding VMA lock
> config: nios2-allnoconfig (https://download.01.org/0day-ci/archive/202601=
30/202601301121.zr5U6ixA-lkp@intel.com/config)
> compiler: nios2-linux-gcc (GCC) 11.5.0
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20260130/202601301121.zr5U6ixA-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202601301121.zr5U6ixA-lkp=
@intel.com/
>
> All warnings (new ones prefixed by >>):
>
> >> Warning: lib/buildid.c:348 This comment starts with '/**', but isn't a=
 kernel-doc comment. Refer to Documentation/doc-guide/kernel-doc.rst
>     * Parse build ID of ELF file

So AI tells me to be a proper kernel-doc comment this should have been:

* build_id_parse_file() - Parse build ID of ELF file

Andrew, should I send v3 or you can just patch it up in-place? Thanks!


>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

