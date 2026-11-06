Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16FBF606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 17:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=hWyXD4de
Received: by kanga.kvack.org (Postfix)
	id F29676B05B0; Fri,  6 Nov 2026 12:58:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFFCE6B05B6; Fri,  6 Nov 2026 12:58:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3D1F6B05B8; Fri,  6 Nov 2026 12:58:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C547E6B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:58:36 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2B350A0011
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:58:36 +0000 (UTC)
X-FDA: 85405454232.28.AB02660
Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	by imf26.hostedemail.com (Postfix) with ESMTP id E2F5E140005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:58:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=hWyXD4de;
	spf=pass (imf26.hostedemail.com: domain of "prvs=76345edb3=mkbund@amazon.com" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=76345edb3=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793987914;
	b=HW1IY3Od9L1C/s4OIHuUUX6K33/ffch84ettpSr7TvmqaVPGuPyXFPYqz7Cnc2/D/oGrzC
	xugJcyMcR6Xm13n87HKBT4u0rXoKAEwip/+GoABdw+7mXgldnh8BDdce8U0/mjE2XV+K9A
	l7mpUJEdSZ11R7kOC/8+FTgyhXNKLYE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=hWyXD4de;
	spf=pass (imf26.hostedemail.com: domain of "prvs=76345edb3=mkbund@amazon.com" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=76345edb3=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793987914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DvwQWrNQDsi6oCmlPjAhQ6lQDXeqrlYyqk44/rWhVUc=;
	b=IURvvjpix95z4NpSNLDIG6ohA3f/Jp22DdE3USzh9Mt8wd+BAUEl57V6h+iGiuH7PIfr1p
	bErY54FbNXdSqXfBPHJENwQcBF3Et/97LYHnpljYcYRui511ya/UUk/JBY2q7n1c4v6nG9
	wYhlbxrdD89e1DlfR9HNTtTq2A0vWpU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1793987914; x=1825523914;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DvwQWrNQDsi6oCmlPjAhQ6lQDXeqrlYyqk44/rWhVUc=;
  b=hWyXD4deCaAdCgGppFAPjRwcbRInPMkBFeQ4DBC0W2EX5/o1hNbg6WA0
   Gib9HPPgVU2FPZe8N9xdZFfDxGxhAnCDoBAwcNPoN1Umgci8xNrv/OaKI
   PiQ2Ya2xRE8K5CdwkBMX6+4JjQLJhjEvc0JI3KOwPLPmkbLHeV9ocjJOe
   +RL09k3r63ty9jdxzgCO5fxUmggpONFC5iqS1Ppx/Hbx+JT2Ejllb245v
   Jx0LNyO4Lg+yVQXXXVb/v4soCnbPD6Nq36xXEqK5Edx31A8Hvxu3QcpCx
   v6nBir5bv7y/gQprkHGoRPAfKFGlFnpaQJiVscrpfWZ9wnlbkrjDuK9bR
   w==;
X-CSE-ConnectionGUID: DiyCP6ohTQ6hyTimUcVrpw==
X-CSE-MsgGUID: SxmlFa6ITHaks0tl955W+A==
X-IronPort-AV: E=Sophos;i="6.27,197,1787011200"; 
   d="scan'208";a="33332192"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2026 17:58:32 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:1052]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.15.208:2525] with esmtp (Farcaster)
 id 0d91adbf-b11a-4273-87a3-673ad09ef406; Fri, 6 Nov 2026 17:58:32 +0000 (UTC)
X-Farcaster-Flow-ID: 0d91adbf-b11a-4273-87a3-673ad09ef406
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 6 Nov 2026 17:58:32 +0000
Received: from dev-dsk-mkbund-2b-9ea2efba.us-west-2.amazon.com (10.2.100.138)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 6 Nov 2026 17:58:31 +0000
From: Mark Bundschuh <mkbund@amazon.com>
To: <sashal@kernel.org>, <stable@vger.kernel.org>
CC: <linux-mm@kvack.org>, <david@kernel.org>, <yangge1116@126.com>,
	<baolin.wang@linux.alibaba.com>, <21cnbao@gmail.com>, <david@redhat.com>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, Mark Bundschuh
	<mkbund@amazon.com>
Subject: Re: [PATCH 5.10] mm: replace free hugepage folios after migration
Date: Fri, 6 Nov 2026 17:58:19 +0000
Message-ID: <20261106175819.1829099-1-mkbund@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <2026-11-06-1-daily-reply-0018-mm-hugepage-folios@kernel.org>
References: <2026-11-06-1-daily-reply-0018-mm-hugepage-folios@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC002.ant.amazon.com (10.13.139.212) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: hbyo684r5t3rqbjyoc8e4x1yg3ydpgmk
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E2F5E140005
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793987913-897917
X-HE-Meta: U2FsdGVkX1/ncRIx1vRl5iOwc0d9p4oVfgFBKXcrB/qxvpqV8CH28ldBcnpkegV5+oAKxDXdcNOGLoTcZAKTxDTHxkeyUXPdhoEySBL0SxrmhZ6/6eG48aVXd+CaJ7I6Uw5Q5q7weGXw5cFc6EqZvCa573gI7ZiOlyS7L5tV7nOfPZv1eUkPcAS6UgJGhYvzYOk0h7CClpdyP1tY7xxv79yULF30UF86t51X7QMgrPnZaDG4CIwCxl6ZFKG9ZSDcMVjzI1uLoP0BhX5cjnc39oIdVhAhJn4XtKlZkcf0tE5ByNSxfvBFraFApcFbdGWRBUQVuBOCALMPpT7QXF8bWnhiPSnlG4RXkDc1Zp1YeYdGHpavMoP+JwS/FqLWGNBx2ode15cDBL6sLS1NYzHGoGYq2WsY6Qzh97fJWTHZHglkE13VWApiVFeTAyn2bFGBB0xPRz4vzJpnj6JInMDOdgeUmLDT0Iacq79GOUQ+hwrQHxR7Bojj/tjRZvT6TAvDIjKNndS/BKU1P0aaxy2idANHivJb/qPlDR4yZaGsBLfoB2kN5nQIqN+jx5Tmhj/IL2UKBOEN6jBDlx6H4uCtaVM3XQV1gSalYMt8RFxfCPDlWZVYEMpAq5f+g62Zw84aY0gDlbDWXlHLcddcdFi667onLC0pUo2kghPAaRo49Ab5UQnAUTouRQl+aAEBErIzl57TiTDWnjcvgSOwimhfyjrLbnsJcqK7DyAEhZRlO7IACMt10ahaN+/rqNbJfxetjwmNwjSrbNUA1sP+GE30yHo5f49arKD/qkRXaLz6mS3BUAHQzAGj3DSoBBecyI0QnLsNd3o25eyXW865aXMotyNOmESdFENcEdxRyW7TxUCokh2SlQfXj0CVVZF4DOvO5xoY9RDq4d1I+CMiQC6f1cMhx2sTinVsPXZu+hH5wX+AwSxwWIoLc13/jdLGolW6wGWdLlev3fgLKm3UYY7
 bykJIsTf
 /NpD2r1sL90nrbJ6PdPtWQAwCHUsFDmdpIXKhej7sY6nfLlERUWeLZYDMkOXXCzi0MkXFMLpAV0ULyc5UFoifseH12Qw3JvIOkz4uXb07D64x3E6nrEOI7DSiR3IQgmkGmi0Unphqh8+5HMAL0os9Az2qvZ2dCK66voxVzwvKqdFINAq6qHmvpVxXVnYxV/o53uUcbGJlu9AfbDW2CLTxo/0+p3WfH4A6qtimmKipnrewKE0oJxYojvYCH71nic1L06BsiAJvy5Kqh1kLt2LvuDxuBSQk7yM5GNbMxxJzx6OUjuPVTchKEZtCCFL3lKOKgC9GcogFAkZYBHbq+XU62lsspCLqdyylxAbYFzss21MxDUMGR4D2F6ut8TUKjUbYbpsfXPcFTLgVFETZbDzJpfo5K0hYVJpXRRpiQNMbj6CRS4IIAibNAgqF3r79M+qBj8qzNJeZmar+IAMv2TX9IwxGfifPediq7Y30giX2wz033OtTFelvhDWZNqJvK/o4AjQQgO9YGlJKJbWK2Toq1qaVnIcLiZWd04FinxyDakITiSZD8F5Zwlfn7oxA+haLEe26N6XGkboibr6Lg+OqBY3Bb7fiHyUB/orsGURAP1mBtE16+BaxSUv/E07IBkT8LFZ9Vda1cJvz/O3rmn0lfOgz9b7ocr4shgqlEL76/Yte0rFPEm7AJgWQRNTaPtV2a+pcEO2QTs3CR2o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 11:35:53AM -0500, Sasha Levin wrote:
> Could you respin 6.12, 6.6, 6.1 and 5.15 with the full backport? The acked 5.10
> patch stays on hold until those newer trees are covered.

Will do. Thanks for the reviews all!

