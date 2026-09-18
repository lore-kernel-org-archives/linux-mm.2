Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14B0EC982DD
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:14:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C10896B00B0; Fri, 18 Sep 2026 16:14:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE8186B00B1; Fri, 18 Sep 2026 16:14:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD6FE6B00B2; Fri, 18 Sep 2026 16:14:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 916666B00B0
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:14:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7F549807C2
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:14:41 +0000 (UTC)
X-FDA: 85227985962.04.DC8AAA8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6EA091C0008
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:14:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ETBEHQSj;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762478;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q17JrGUK4X2t1hdvERj4yssWTWrML9FbBLdlOjJS310=;
	b=We8cNawUOdAnw8qUhW3lr6oVLhiNL9hXYEcXA2rogido4x6lShAMjvq3sgQglKQmQ94jUC
	WSOvf+YwyUFjR+eTLb+2ItwYDg2fm/mTKHwRIsKTOs9PyFK7OX8rxP/KXkMtTOpQchh/zQ
	SiA0e0J16UUCTC34/c/EZJqXDIc90dk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ETBEHQSj;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789762478;
	b=OQMD5AeGCqTTXBxPcyHaY2EcmkQ0sUDXsqkr6bNOLZvauHPZ75sxiMRJSJrQlsSZaYQ8G4
	+RmEsA+LL91oklCIVEajCc7Q6C3SQ7B0CGHAeWQtDt/UK+gHd27Teeh4AnFVH/IDQW8AQY
	Mn5b+ZHgKlqeGYuFisXyQlhL6USGpbo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 911CF42002;
	Fri, 18 Sep 2026 20:14:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DEB01F000FF;
	Fri, 18 Sep 2026 20:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789762477;
	bh=Q17JrGUK4X2t1hdvERj4yssWTWrML9FbBLdlOjJS310=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ETBEHQSjaEbWTS0FCNxpNsb4d8LaDdQvdvmy91bRbiFD/AtP90FJQjYsAaWVb2aqA
	 OmMgE7vCtF8xOjhn9m38ewd62M/91G0v6uoI1y+8AMBTyOmyK0tXrJV60eaBtA8ZVB
	 ZnpMvv3o7E33QrBp5wb5ZnyRGO5/VBIPM1JVEpN1nKSQ0KIxK3vBeW11oCyqgdI7e/
	 7CwIRWGIipa5Q1VNV7xrMLrNBkL1KIOKc6hU2iUjiyTsqlwWBgx/M18t1++jdRB+NE
	 ulLb1dshJBfQS38N259RH8mEbQROFMLVWMYs6vE2xJRh1NWybcJ+jM/Gtl79jg9t5L
	 hbf9pGUtrElYg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 13/13] Documentation: PCI: Add documentation for Live
 Update
Reply-To: sashiko-reviews@lists.linux.dev
To: linux-kernel@vger.kernel.org, "David Matlack" <dmatlack@google.com>, linux-doc@vger.kernel.org, linux-mm@kvack.org
Cc: "Randy Dunlap" <rdunlap@infradead.org>, "Lukas Wunner" <lukas@wunner.de>, kexec@lists.infradead.org, "Adithya
 Jayachandran" <ajayachandra@nvidia.com>, "Alex Williamson" <alex@shazbot.org>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Shuah Khan" <skhan@linuxfoundation.org>, "Jacob
 Pan" <jacob.pan@linux.microsoft.com>, "Pranjal Shrivastava" <praan@google.com>, "William
 Tu" <witu@nvidia.com>, "Bjorn Helgaas" <bhelgaas@google.com>, "Alexander
 Graf" <graf@amazon.com>, "Jason Gunthorpe" <jgg@nvidia.com>, "Parav Pandit" <parav@nvidia.com>, "Samiullah
 Khawaja" <skhawaja@google.com>, "Vipin Sharma" <vipinsh@google.com>, "David
 Rientjes" <rientjes@google.com>, "Jonathan Corbet" <corbet@lwn.net>, "Pratyush
 Yadav" <pratyush@kernel.org>, linux-pci@vger.kernel.org, "Mike Rapoport" <rppt@kernel.org>, "Saeed
 Mahameed" <saeedm@nvidia.com>, "Josh Hilke" <jrhilke@google.com>, "Leon
 Romanovsky" <leonro@nvidia.com>, "Chris Li" <chrisl@kernel.org>, "Yi Liu" <yi.l.liu@intel.com>
In-Reply-To: <20260918200640.887030-14-dmatlack@google.com>
References: <20260918200640.887030-1-dmatlack@google.com>
 <20260918200640.887030-14-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 20:14:35 +0000
Message-Id: <20260918201436.0DEB01F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6EA091C0008
X-Stat-Signature: d7d9x73motpz8jh887wqseiyr6jqspdb
X-Rspam-User: 
X-HE-Tag: 1789762478-422262
X-HE-Meta: U2FsdGVkX18GdftGRs7Y+15d40bcQFHeEJTCzkP9CtYW8+Q6L4cZ2XfHPrfMcm1w/pTsHdJZHWDCPA8Mr2yPIrWMW/x8An1PcDKEEN1pc9PDWDMMUb0qiEyzlfsbHSdfTGH2nqL2qA8rdMcnA83tqZt7dcx6L015RKCZBdrqSMUgDOpXp93HZ9JyA/wVxlWDLXcUsCNbk3r3GiVwixDeV0UtErCzAudHxbsNkHxZGgT2er6EDr31k+Y3JQJRsadgf3SuKlHM1oZqudlJXdAGbDbx2RjwZjMFLftAGAXeDnOVyH/w1oO8Saa2wzLFjKrnj1z7YFZqVcAk/zxMoCw1rwtB0p4UKPp1dN7AFMKrdoh4dmoc4Cp+RumegEEG31TXo3LpvEBwLd91+k0S/nZN0XP9IJcWt1vXYuwyXQvTeryGWREIXUHx5XcxdAU+T43NufOm7p0ELMTXaTvp5+SA71fySR5P2rNX28Qfb3gsf9jHWj36tW9R9kWhu+Py50NfqvAkw/vaZPOteKYa8Kl3qowdGRcDVBMctOniFcjVXfssPLyxQr4IHvwJf1+CkXyCu544jkNLItitpUbVLFEqDpFEAIH2yurZHtxoC4CmfKnmF+B3QB+efBt1c20xKZKfxYNqQeM8BVy6MH3WP/OiRkFSNcaSu3+s7kluDBeSWHdnHa9tdzw8C92XQ5eIqM1lVITSxuiMAvPtHpvvmqhRu5+4FVlN0sht/HQCzsiudyijvo4DB22diFiAbj3yxzUJhnsgnEtebh9ob9eKHyMov+bZQcFXN/hnR8ACPScRe4FvUH4G+IdBmQPP6zdl6b09SGGXXDMGgVvMZcje1hHr8H0DVY6YWeuveEoP33x251T0nb4ORKk8Br4YDCSaGcIIpjiMykNjltHEAPcDUcFSn5IDN1+f/BllHXyYRWTOGmJWCsxqApP0QfIXM5InfHC2WojJ0SgHitJ0ndGe4p5
 U5IN7Fvt
 JES1jnPw0ZDtpGbt7QEtB6tkadO72cntvhUdnAAb/7dgcF/ZUDaiV3deK5d9wRMtIV9zm2YCOhS4EDklWR8ryMFcN+5f9jIWJARv1z7zvFktl03ydfgwAe0HYZx3/rvx1JMC2l4DHLb/04SKx/J3A2pUSkDp6D5pboC7IfrvQhFzC4CxmEYiC9uoKGjDW4oae0epVWqzQJ3mQUJUfZECcyE0VAEerjf0D7zm6umNBSc+ANv9wvJJysacMWFlnlY5lLsNqGkmyuhBJ6RSxXa6pPTe846TZvTz1bq4xkKB6WlUYRZRo6peLUHN7H1vKGvFIQ6FvfUx5hWEwOvtvoaRu5OoSyMi3icmqsTu3kFZNhSr69sJGmmTjPk3c8Zp3YzZya0/weFn9M4c9ojUcwfrgpLRzJCJ0mNVjo//oUjlutlDg1twll9mB4EG/Tqq4ZqyMWampABPO22FHf3mcuRHSf6if1AeY6tBSSNMccqfcg6A9QqZVNaNoAJnJiI78MLCPaFjKRkFAn43xAkFjmS4aaOT2rzCvukUQglQkykM0/SQdKzPHJsVfXWU8yMovv2YpxZbzbmpt7LkSgt2hF08CR5zeEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Add documentation files for the PCI subsystem's participation in Live
> Update.
>=20
> These documentation files are generated from the kernel-doc comments in
> the PCI Live Update source code. They describe the File-Lifecycle-Bound
> (FLB) API, the device tracking API, and the specific policies applied to
> preserved devices (such as bus number inheritance and bus mastering
> preservation).
>=20
> Reviewed-by: Pranjal Shrivastava <praan@google.com>
> Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
> Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918200640.8870=
30-1-dmatlack@google.com?part=3D13


