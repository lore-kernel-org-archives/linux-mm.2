Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 699CDD6AB16
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 22:29:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53FE26B0088; Thu,  2 Apr 2026 18:29:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F07E6B0089; Thu,  2 Apr 2026 18:29:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 406356B008A; Thu,  2 Apr 2026 18:29:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2FA766B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:29:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B0EEA1A016F
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 22:29:48 +0000 (UTC)
X-FDA: 84615059256.06.D01F967
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id AAB451C0011
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 22:29:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VJc5a5a1;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775168986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QokyqOaRb2d7a0WQTgav6UgM6+RuSyQJA/kUDBXW6IA=;
	b=FhQR4edqN+QHNXGt7yNfWpJGf4ihZuHuuAi6vL8lS9Z3+TkpWn3s1UBmiUCwJJHQPM3vrj
	f7hGkSrp2sge6c1SQ6coLVo1YRxy7iqM4yQ8ZRZimnyYzcp/CIV/erkAUu0Hqd6Wafz5z0
	PUK+9uTWhIBVdcLYrYk6XY5sZiDGBcw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VJc5a5a1;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775168986; a=rsa-sha256;
	cv=none;
	b=SPv4RH4IvK9Isj0qKTlp79vV7UMYf20f093YYz2JVrzReR587ua9fNDiUnan09bT7kRIJf
	aTJUAhm1xclRqoka8d7LnZ1cRae8d3eeC1P4ir3NdLJiszig/2WTnR31pb7bZ0fKGjDx+G
	ny2CeNu3YgNsoIpagNM8aGVYqc2TMsA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A2EE54409C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 22:29:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 887D2C2BCB7
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 22:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775168985;
	bh=p/cM/BYynvOsTethzjsaVxXXDEJp68f11Moa7Ph1ba8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VJc5a5a1BpcjqQhdSyAdrv1enZ8NwIfl0UMSW0YZlV6mqvOeKiwgXdC3x/mxfqquG
	 LPeOMgC2AeM8ZwIpSSlpnQuP+dBAtc6IsDgNN428WpC9Ll/LXZM4M4gk7FdO592rps
	 IFP963mmyUB8eMbtBeO4yoxI8JmGV/OJXwbNdPpIDwi4feT/r9QbFxWtwo0yNxvMjm
	 ji3LLib3XtPicbehFNQ3k14rcz4j7K0s6QZTw/B6cgoMNFnoBByu9njMvfkGfxsOve
	 BHl8NkcqXixPTnx/clOHF1ZSiIausraqZzdSeig/LQp4YbmEz4E8dDhOfPxmvYyrXH
	 NaU4kMC1cC9qw==
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-50b2b289925so11973801cf.2
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 15:29:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWB2owzJdLse98tx8n5CL7OKBqL2pHAZPuWJrlsTTvwJ35+Hl/7KopA8EHmP4tjtHmn9k4d7a7JLg==@kvack.org
X-Gm-Message-State: AOJu0YzdavsobFXj9UkPv1hS7oxiPFZEydg5NGhcjV0eOPhK5cd+aJ60
	p3OlQBcTyA19GGMLEjCDzvhOriGmkPuN/vUdo0sDtjjmjnlyigCz3ceHDz70VYgKwekGxzgkCHC
	jO24Whe4TILME5S2Ti1ofHzoNcCtY0mw=
X-Received: by 2002:a05:6214:5e08:b0:8a6:1545:41ae with SMTP id
 6a1803df08f44-8a7025b4ddcmr13631776d6.15.1775168984768; Thu, 02 Apr 2026
 15:29:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260225223712.3685-1-21cnbao@gmail.com> <2558f7d82b9a482387960f45409e1b76@honor.com>
 <CAGsJ_4wV=OpV-ntZQGKQawrO0kemwdT8byySBCCZiOOgugcQtw@mail.gmail.com>
 <adfc0959cf294aa4ab71c60ee1e35720@honor.com> <CAGsJ_4xUA9MfzYbTdpGsLsWoRb5ORV=_Vi6-jDh6VC=guOdcbQ@mail.gmail.com>
 <d11be6d7aaf14d6e8542c5bfb56bb0c1@honor.com> <SG2PR02MB5409697C73FDDDC6ADDA33FBDC4CA@SG2PR02MB5409.apcprd02.prod.outlook.com>
In-Reply-To: <SG2PR02MB5409697C73FDDDC6ADDA33FBDC4CA@SG2PR02MB5409.apcprd02.prod.outlook.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 3 Apr 2026 06:29:32 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yjBEj=449YuOerqRN97SH+5ZVM067g=NHdqTEAPT133Q@mail.gmail.com>
X-Gm-Features: AQROBzB7JOo_0w0UYjL9syl1urF8Yd5rtvEOBoTWLgdlnxI75eVMx07lmJOva2s
Message-ID: <CAGsJ_4yjBEj=449YuOerqRN97SH+5ZVM067g=NHdqTEAPT133Q@mail.gmail.com>
Subject: Re: [PATCH RFC] mm/mglru: lazily activate folios while folios are
 really mapped
To: =?UTF-8?B?6YOR5aCC5p2DKEJsdWVzIFpoZW5nKQ==?= <zhengtangquan@oppo.com>
Cc: wangzicheng <wangzicheng@honor.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Lei Liu <liulei.rjpt@vivo.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Kairui Song <kasong@tencent.com>, wangtao <tao.wangtao@honor.com>, 
	liulu 00013167 <liulu.liu@honor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AAB451C0011
X-Stat-Signature: jkyb7hfyq1p4xdjxmow4szu63zwyxdrj
X-Rspam-User: 
X-HE-Tag: 1775168986-15420
X-HE-Meta: U2FsdGVkX1/QjzPGPBbyaWz1Mp9owakAkAJa7/06FhKaK9vKa85gbB6Kiee+P2R1XyWA+4OYKd2jwXkwAOD6MT/3Klb0XjoXnXdvvV9f34kvXWJGfrDM9wDxpLXdnfiqoe+Gj/sotPz+VFsIls3Gs1FM41AipuO1b8XaztGM4LjjAT44Qrld1qpifZ+I5W09Zsi+0s3k4hcAa+ymJk9YJq8I080S6n1a1cLdwGovzE8GLrv7LVAeAjHhsHB1P2SD4lRXSP4gg/MsvoMYZS5A4ePAF6Nlq6K/tQIb1mCNYvf5def9wOLfKbwS3Ec2gczDWdipQJ/NFR7TWcihB5H7Gqq86AJ1QB2SOWPNcNJWVEY5hpPE2kO/uSU9Cz7uj7N2dMTlr+onhxMTWLhBZiOaAZTydhDt9GicXJ7tBjjgSedXM7XW+LlAH116F6gIsW8vOJvvQYYxOzPYbxZYy5og6G2bUBcmMcVAAjuEUlfMP66+FjufD9oSQdyelp6HdKanH4/SwrqvWHxqYGh5TOhEQEhehdQPVe4w0dqIcNrZmxY9uZ98u70l0lGnOj8gslyK9vNfrTCgUwtkVopf/sZSkhjMn4q8r4gTXFe4xpXpOc54Tixjozfax7dcLXSZ0O/PRch1iVdjpoGl4HenHJxuB7HwtiXm6SQAtcETOi+MnLnpR0r2fpv2533RyhI9iX1fH2HEtP6ouT/T6cYfczZtOI9XSC6p3SVyginhAXPr4usvBJKWbmfBuyitNuOkFWSG8+gkhWiMXhCXCtDUhZIrxx7KFCuyaWGN2h2D4O6FMYjWQI++VIv+5lZaH+uz/rDNdekvZtkbCl1IxEsVqy8k3prRv8ZaAEkdC3oc6FVHwCVK/AIVNzoAj6qA6ypSDQ5AYD3x/7k9f5iUSShsfa+e/Q/5q2llVz2FYZb4gvRD311YY0sjmTbQSzkRWgQV8Esnr5vkj9fpTVjXcWkuhRH
 g4AUy8fk
 Oz5krBNcGqrZ8LMM+p3j23aJ1xedNMXAMVFE4ndw40JdsnNNF5XvmZ3ziFVxxTbCiSPwJNewjy36jdBe5Oio57dEMmiXYOjts7oe1scfqZHPxrE19EUOmzKyhHPW5wg7T3sDZyh5dyr6lXXvuKtLOIwQg+9WdW4wwK3DI9mdPI83A430f2CbD69a1rheMEZoduoWT03zRBMlZHhSMBHxZT/Dsc+UDJfZYsyeFFky2Vsh9mv+RJv/dJvR1ZR5Fux8MTDGQkgefcR03uhO1FTYUT/jpKivGMzS+k4viBwPcJAzbWyIL7hlNQJ1l1+AMxiHojkuB2uRzGoAJ6M6zkAPwh1d9Xx5w4QhyQOzU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 5:59=E2=80=AFPM =E9=83=91=E5=A0=82=E6=9D=83(Blues Z=
heng) <zhengtangquan@oppo.com> wrote:
>
> Hi Zicheng,
>
> We ran the same RFC on 6.6, 8 GB, with zstd in our internal whole-system =
perf model. /proc/vmstat (before =E2=86=92 after; % =3D reduction):
> pgpgin                                          57807848        55738480 =
       =E2=88=923.58%
> pgpgout                                         31585160        26367420 =
       =E2=88=9216.52%
> pswpin                                          2305528         1534481  =
       =E2=88=9233.44%
> pswpout                                         6618935         5327316  =
       =E2=88=9219.51%
> workingset_refault_anon         2104047         1356316         =E2=88=92=
35.54%
> workingset_refault_file         9020966         8407346         =E2=88=92=
6.80%
> workingset_activate_anon        1196828         412937          =E2=88=92=
65.50%
> workingset_activate_file                2941357         1468218         =
=E2=88=9250.08%
> workingset_restore_anon         590337          412322          =E2=88=92=
30.15%
> workingset_restore_file         1801398         1285060         =E2=88=92=
28.66%
> workingset_nodereclaim          201014          152864          =E2=88=92=
23.95%
>
> Here both file and anon refault drop=E2=80=94different from your Android =
run, likely workload/environment.

Thanks to both Tangquan and Zicheng for the data. I=E2=80=99m guessing the
difference might be related to the readahead and fault_around settings
on low-end phones. Tangquan, would you be willing to share whether you=E2=
=80=99ve
ever adjusted the readahead window or fault-around pages to make the patch
work better?
I guess this could be helpful in shaping a new version.

Thanks
Barry

