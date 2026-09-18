Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CB20C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:07:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28C666B00A5; Fri, 18 Sep 2026 16:07:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 263BE6B00A6; Fri, 18 Sep 2026 16:07:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12B436B00A9; Fri, 18 Sep 2026 16:07:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C356B6B00A5
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:07:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 52C92A07DC
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:07:05 +0000 (UTC)
X-FDA: 85227966810.07.49E8C82
Received: from relay.hostedemail.com (unirelay07 [10.200.18.70])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3A4E1140009
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:07:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NNhCAqWpdqP/8unoyYkwhtURYEVhgOr7+m0jRabjXBA=;
	b=w6ZPeUJa0T9WQNmqCm+SRvbSiirjB7NpfWrQcWEMuP7Ecq+lWvyu/I2hiC/2PXp8iUOxHo
	kKiE/TEbz81T5aemaWR2z/2xU0bnWFaGxUMr+WgwFTqa4dLi1f8MaaFz5ypq/p+Fi5nrIO
	kHXn9DcSv0jk5OWXNIOV5O/05AcloLI=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789762023;
	b=nvkW/482SRweO+Mu+B4R7ydDU3CBadagtJKFqpm01wdg0z4q+bVSEdhI9D7ZPYlvl28kF+
	4tqV7f/v6t0szp1UGkfjeEKUtgPOBVLHdP1hm3P33RgEwSB9QlpEttQkV9jQQenu4xQGSH
	hj+CuMkpACiHqEvZN3om54j31VKqtBk=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CE08C160797
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:07:02 +0000 (UTC)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A02CA1A078C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:07:02 +0000 (UTC)
X-FDA: 85227966684.04.7E9FB22
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf11.hostedemail.com (Postfix) with ESMTP id D8FF840005
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:07:00 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NNhCAqWpdqP/8unoyYkwhtURYEVhgOr7+m0jRabjXBA=;
	b=1wkzQSLRSIdO9XTYzXCzjCNLLlhr46HxdNl3VtRdfS+kxtjqzAOTW+ZgSCnmCoalqiSvcE
	lj02+ET6sFyUmqcIMpHDz58zHwdqElUX3wHhyFFkcbjuFugcvFuRZKTiZeGYoP9oE5ZnT5
	dVcz1L6hFSb9B35fgsjPliubMkYMsxw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789762020;
	b=ZUWM0BIo3VArquopm5i3+Yd8VgWxmPPimIxgu8RRcoEhPKEj4pbfhUebp0VUbws+IGvbpz
	KAGImTYDrZk/W2C+LsdUVuf6mwlZxDM2XZFlPSPSFjejNbEUvw3gE+kVEZbhjxDsnGuuD6
	cEy1bKTp1D6vNkNN1/JvRlrjoUvssdk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WYt47MEV;
	spf=pass (imf11.hostedemail.com: domain of 345mtaggKCCoJSGZRGIQMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--dmatlack.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=345mtaggKCCoJSGZRGIQMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2d6f80c76e6so22595715ad.3
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789762020; x=1790366820; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NNhCAqWpdqP/8unoyYkwhtURYEVhgOr7+m0jRabjXBA=;
        b=WYt47MEVUOoB1Qu1mzCqEyTGSbqEKqx4qETAtotBDATO83YD8Tz3aLGLu11qe2yAwA
         BXcCrhzgmuji1D7JAgP9IpeJea6JpxFPFu5YKi8ggmrsp4l/bmJ6lb4TpUkad+YMcFg/
         16LhvoM5bRsd6+jjt/k0sZTRTiYJLcJlU8jGPbFJBSgANmIEtIuM5XvHJHJqQ7Ztmnme
         mpsmKJSk4Cq+51VQ1bkeFdySZ+XaLJNjvOsvHKasHtGMtEjOugmxypPXGnbBw/s/rYZ8
         kOUTTXGrFE0roh8mp3qOCgmTV+R0MhacI2StVtUqidfJGQU1HauSRh9HF/edFnFV32pa
         QmLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789762020; x=1790366820;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NNhCAqWpdqP/8unoyYkwhtURYEVhgOr7+m0jRabjXBA=;
        b=YHol3KeQ/LijOq7Zw43aSU8O8hRhQm1Hc4IheH9UJMJ9l5SqzuUfA/4vLP2KOFfo5Q
         cXUAublKN/eOlZ/omcgvwXahWxAMLJPmmCbitNk+vBoK/YGI9p5srnL4MPW7cz28nT8/
         X3BKXRjn20p6i8DX7hhqKPvY5Yi7AN6ILkTTysR4AQ8LnRY4cxzl4FfmxaTw0I83m6V5
         Rf0zeKHRAoZhin/H8Ai+9oujQbUb+465UcJ8s3x3wgD/QR25XHMo0ZHg6hDv2qirTv+F
         t5ha8v3QpFvCODR30UsvU3p+kRoEJ8QYP7QqZcqW6JIjVw0G+AS4cNqMkJsHhCYeH11F
         YJBg==
X-Forwarded-Encrypted: i=1; AKwUvBxDco3RXci+OuBdz+LwjPZvcErsp8BZBe9LZ2z7DXNP0aVjrdFUjL+jasafhpAop9YxcBlH1fiD5A==@kvack.org
X-Gm-Message-State: AFuF++mikfFCSSJrTNkp+WflCdoWGWLIsqOElJmC6ZpiVlFf7w4YmdB/
	E8JM7t4oFpKzb81ajE0/0v+KBBymFcMP+PvJvGwBEJ3vwHm7iuDT5w8V6nav9RsSKxaD7P1FmyD
	gLJnO20/Ly41svQ==
X-Received: from plec5.prod.google.com ([2002:a17:902:f305:b0:2dd:2f59:daa8])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:9cf:b0:2dd:c053:e662 with SMTP id d9443c01a7336-2ddc053e6aemr12608265ad.40.1789762019617;
 Fri, 18 Sep 2026 13:06:59 -0700 (PDT)
Date: Fri, 18 Sep 2026 20:06:33 +0000
In-Reply-To: <20260918200640.887030-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260918200640.887030-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260918200640.887030-8-dmatlack@google.com>
Subject: [PATCH v9 07/13] PCI: Refactor matching logic for pci_dev_acs_ops
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-HE-Meta: U2FsdGVkX1+dCy0ymo+5n4FVzJHUWkKUCc5qgAxc97nZ2AE/uv/+2c8oJpT4PZXnSU203cFFljTDCJ8ZjjBNpn6ptGtd/N/djdd37dQARCtmjR9/OgyJ+eRx+W3vp195fUsQf8ALeWxMbl2jGkMhLZ+S8p37jd5Wh7/g903ApzhdN7ZPf8bAW1Przl/3EvWBzpQWpkCXRB6tFm46Cm5vCNJSoH5eqQ/z1UsCvz/mD4F0GDJQpBTPr1aaI9TvVdAy1bVuKRpohOsLlPMgE7dMYS1jTtCEkC0Ld9hULcV1mtQZSN7uGfuMnR75y1iMmFAsRQnp7iUOGcPprORZ604US9VRd3D/Nvh0IF0hPKdPYD22PItSYM65js2Qhomqjn4+0lwBUtI67f3UY059+h9gm4RxElN/O2Po+7z27xUYvYuMf2Y21/4XbJfPQXRIU2qb7L2bhe4ObqABudwPYS8FvvsPTHi2p5eeX0oKX3CGKxXdxe7C/Qoz2LFp5mGDZTkz9ARJzpk7uAB1u+OKcVojSfChEDG1GHyI2vFP9w84Fsjm3WqmzSnUt0CXA5B8FZGLJlZbPG9nYB3klZkxBo9oPEmJfjTXcWw3n/gNeGewjadUvNWsHuHytMCEI5dnuykx0+fis0XNZx1L4RZepCmAlcIMVUlLKblVbrxMSQRN6z+/38svpbNYWv7ZdCGQyEY6yQ0mGlcUsR0i3fInWHbRN16ji3W/I/pf8hi9Aio5CoafgHq5J4Nres4jM3a02W7i9pc72dRXKSzV/c4wwbwJwnFUMbcWCiMfe/1GbRwYwNIxV8HAnvMPJOeSanCeA1ALGN9NV50Fg01Pqu1Zg8K+YAJ2fUBkzHe3k8x+FYf2kwYwzjF4CR/tbmSfw7b9EajmIM4AscPr2f67IA5L9gAfOrdLMnkp+fjri0UYNbwadFqZ9G7F/tmThnxZZvMhYghHNnf/q6f9rFHhYpK2N7m
 McybZISW
 xwwgxA91FD9rxNIYt2c0AgW8kANmH5+HWxu3d0yhE7tIo3GjdI/XHMFnCBChNKbVI354x4d8WMyItkujsxuxDP06aZzUEkZUGQvYfTWbMBajQRA8eQsvBUXtnPWvJPKuri1PXXGE+jGrarfjJA3PLk6jr4GzuJzVkgLqXmDZo1rP1K3RJjAkFyGYztSGQRLygjUoM+2qvSzvj8E7UEwlHaThAPjuu3O5mISCWIejv+/ILtwUqOtgpaCxDRuYHiP3X2YZuHtGVXS+qdlc/JOKEy//iujTekvgT8c3N7c9NnBpdWIWhwpgJnVJozZpS1X6kRkUbG+IgPSa2/i2J+QS7pZ/NS4fIBqjrCl1TTvLxdVAtHQO/loVGYVS3brolpHbh8TXnQOUvpQ5MvetoysVowmQPaxHmq+jGn5DpnmXuDY6pVisc0UINReR20QX13O6SDijkc9fkn+EL9H9e3qSAVPZWaowBj1WdQlUhXhmns8pRAQqAAD0tOktXd2alIQH0zSrkGhwtfePMsmKJ5gHoJe6Wfd8qNjafbpU++sOERAbT/ZPCcA86wka/1Yp0x0pATIlDUcPcZNai75ITKyO+eEl6z1jtNwqT20OKDQotjOSiz3tpsmGBgfiXxhCIBdaUWRU2ryd6Qi8774YOH1FgW8G6fjZkT8g48Gxk7hy9Lbf44+UUJ3piMcdOghUfZRnOL4Pb
X-Rspamd-Queue-Id: 3A4E1140009
X-Stat-Signature: 4qja6aj6jj7xxu9gy9zcaoxi5emhhmr8
X-Rspam-User: 
X-HE-Tag-Orig: 1789762020-389514
X-Rspamd-Server: rspam03
X-HE-Tag: 1789762023-370522
X-HE-Meta: U2FsdGVkX18qETK5GSntJ1L7pc48SQBAYnf0XBpTSBUOQtETw/3DGmzLJflEkos9ga37TdbCGjbEfFiDAxuThXjI0lj5R1pQ/rh2o5EzfLUeCu/7sL/3rUysZCZodq+zzAHXbp9rQjXBHPzNGz5jI/PXhQc2rIHXMiO7troYqvijc2YJxgsLrEBuvYyTe5VcXe95oFSUPFyMo8l8/ShrlqonDJgGr0/lVwaAQQrxMT+uZTK7FlCMGSRlPpX1JzkfDE17hreDVFkak3X3jEXvSbDHJPYG1dM0HC6D5oLczeLoYFMnVNCXU3ldjDdyLkmBZsauRyBdVRwQoBUqjnrFASac7JGQv9S9edFvDioO7do70k+W9pflXpFXd0PCLoavxCaKhSdxpFPCpnU88wEOmMnb8vzZIgcft6yYMlnIu0P8Zaae/jFJ+4E5xHLGOdm/mhYA4+bIHDbVV1f/dGFuQ7rH0XXnhh670inmNtp8wTK3G4qoHECALyZTbhguCQDCOC8i5DBV1pM+I42ZKVsbJJrXZpLJs/laEjRvpjCscwr4qeGTvc9WU8hVwJ07njcfuu5TBJN+7kVl+SY+9rsf8+BuCE+Jq18eub0PpACz5ZJ+P3YotOrGiOfCxgPCmhVa5GJBwyUmy0MRFkN7v6Y4mevfdZAbttqXiezfaYB7joxl61POX8wCOcSk+iRI7+WpiPLO0Qf6E/P5YoxI+Y/I5UepOOi594uAYrd0s8AHo/nzpAKsHdXZTYFfdpKjSOECPVxnJud13Wf9oR8I++oFBZJSIdZs9eAWYh6NU4V6q8vGFRhaNEMedu5jXSQjDK9t9K/a4+uiv1vDf7QOciTomKD3dP39pkwAV35t/PEnpDFsppWXp2xeUB2jYMED/lrqLhiLcspVQMyXcSk4564JSuIUM1HalrPPn569G9hzPgcIilEdsutGKAKhu/VLZOTiwBQauB0H0K0DTFDd1de
 scRQyOg8
 8WyuYRMiZ3KfJNB3u/OyMTtQFaB5LAAu7hwLIK2N9dFTZLhFrRxgK8wsVkTWCqVA5Wo+yZ2O5+7JptBOUDbbs0PfRz512BIDACy/HrquyMFu1ryrRcIBOAjlO0J/mCnYBxfMU+nVLNgl2lDCz/HWNnO+RK0ljAqQ/atxOuoBK2fNylvkwNnXdkX1uO/wsy6GEdHnkTJkdE6g1Fi7/MtNLrCCOqGrd2G1lcyVxuuMhjMjRaJTn9pN76J+cSU+/aDwVWmHHFHMCBM6QY4gmqdIHfptvZHCI5ptvK3hDeR64mg8SNLr5EXmG8hlSd08PAHYlnktSRNtfX/gZW4mC545k+enPEfAKC7D22LbSEJhUo9YhuOBNxPpoI66J5GOzroel3kIM5zeOTVgvDEQ9oG4AlOFvovPw2IdxA+IbG6HAOZfZWeMfPiIitM1Uo1Ev+M5C6ADyRrneDe7NYTIVsMhSwW5PZ9o7oUgpYd7LY6VGmgt+d+8D+O1UaqRvT1ngeoG6i3lu9ElaA4R/78IuM5kKIVcOq21DrMOnmECKGHYxCbmfBzvO7oXjvE7l/GPLB5LQq9mE0rgNPYArBvfucWk+ZSd0RYbNv+JkGYXwPbmzyfb2AGLQkrcU+cbvuOsiqxf+bG+SmpdZWlSA8mZTYsnS/ONNc0tdMGzndV9aXD9YzGu7ZgQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor the logic to match devices to pci_dev_acs_ops by factoring out
the device matching loop into its own routine, pci_dev_acs_ops_get().
This eliminates duplicate code between pci_dev_specific_enable_acs() and
pci_dev_specific_disable_acs_redir(), and will also be used in a
subsequent commit to check if a device requires device-specific
enable_acs() during a Live Update.

No functional change intended.

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/quirks.c | 51 ++++++++++++++++++--------------------------
 1 file changed, 21 insertions(+), 30 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index de9bbccda21f..7aee30734303 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5377,9 +5377,6 @@ static void pci_quirk_enable_intel_rp_mpc_acs(struct pci_dev *dev)
  */
 static int pci_quirk_enable_intel_pch_acs(struct pci_dev *dev)
 {
-	if (!pci_quirk_intel_pch_acs_match(dev))
-		return -ENOTTY;
-
 	if (pci_quirk_enable_intel_lpc_acs(dev)) {
 		pci_warn(dev, "Failed to enable Intel PCH ACS quirk\n");
 		return 0;
@@ -5399,9 +5396,6 @@ static int pci_quirk_enable_intel_spt_pch_acs(struct pci_dev *dev)
 	int pos;
 	u32 cap, ctrl;
 
-	if (!pci_quirk_intel_spt_pch_acs_match(dev))
-		return -ENOTTY;
-
 	pos = dev->acs_cap;
 	if (!pos)
 		return -ENOTTY;
@@ -5429,9 +5423,6 @@ static int pci_quirk_disable_intel_spt_pch_acs_redir(struct pci_dev *dev)
 	int pos;
 	u32 cap, ctrl;
 
-	if (!pci_quirk_intel_spt_pch_acs_match(dev))
-		return -ENOTTY;
-
 	pos = dev->acs_cap;
 	if (!pos)
 		return -ENOTTY;
@@ -5451,56 +5442,56 @@ static int pci_quirk_disable_intel_spt_pch_acs_redir(struct pci_dev *dev)
 static const struct pci_dev_acs_ops {
 	u16 vendor;
 	u16 device;
+	bool (*match)(struct pci_dev *dev);
 	int (*enable_acs)(struct pci_dev *dev);
 	int (*disable_acs_redir)(struct pci_dev *dev);
 } pci_dev_acs_ops[] = {
 	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
+	    .match = pci_quirk_intel_pch_acs_match,
 	    .enable_acs = pci_quirk_enable_intel_pch_acs,
 	},
 	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
+	    .match = pci_quirk_intel_spt_pch_acs_match,
 	    .enable_acs = pci_quirk_enable_intel_spt_pch_acs,
 	    .disable_acs_redir = pci_quirk_disable_intel_spt_pch_acs_redir,
 	},
 };
 
-int pci_dev_specific_enable_acs(struct pci_dev *dev)
+static const struct pci_dev_acs_ops *pci_dev_acs_ops_get(struct pci_dev *dev)
 {
 	const struct pci_dev_acs_ops *p;
-	int i, ret;
+	int i;
 
 	for (i = 0; i < ARRAY_SIZE(pci_dev_acs_ops); i++) {
 		p = &pci_dev_acs_ops[i];
 		if ((p->vendor == dev->vendor ||
 		     p->vendor == (u16)PCI_ANY_ID) &&
 		    (p->device == dev->device ||
-		     p->device == (u16)PCI_ANY_ID) &&
-		    p->enable_acs) {
-			ret = p->enable_acs(dev);
-			if (ret >= 0)
-				return ret;
+		     p->device == (u16)PCI_ANY_ID)) {
+			if (!p->match || p->match(dev))
+				return p;
 		}
 	}
 
+	return NULL;
+}
+
+int pci_dev_specific_enable_acs(struct pci_dev *dev)
+{
+	const struct pci_dev_acs_ops *p = pci_dev_acs_ops_get(dev);
+
+	if (p && p->enable_acs)
+		return p->enable_acs(dev);
+
 	return -ENOTTY;
 }
 
 int pci_dev_specific_disable_acs_redir(struct pci_dev *dev)
 {
-	const struct pci_dev_acs_ops *p;
-	int i, ret;
+	const struct pci_dev_acs_ops *p = pci_dev_acs_ops_get(dev);
 
-	for (i = 0; i < ARRAY_SIZE(pci_dev_acs_ops); i++) {
-		p = &pci_dev_acs_ops[i];
-		if ((p->vendor == dev->vendor ||
-		     p->vendor == (u16)PCI_ANY_ID) &&
-		    (p->device == dev->device ||
-		     p->device == (u16)PCI_ANY_ID) &&
-		    p->disable_acs_redir) {
-			ret = p->disable_acs_redir(dev);
-			if (ret >= 0)
-				return ret;
-		}
-	}
+	if (p && p->disable_acs_redir)
+		return p->disable_acs_redir(dev);
 
 	return -ENOTTY;
 }
-- 
2.55.0.1082.g2b9226bbc0-goog



