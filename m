Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 152C3606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 15:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=8alias.com header.i=@8alias.com header.a=rsa-sha256 header.s=dkim header.b=pdmSeHB3
Received: by kanga.kvack.org (Postfix)
	id 2EC3D6B00EF; Sat, 31 Oct 2026 11:45:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 276206B05B3; Sat, 31 Oct 2026 11:45:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 168426B05B4; Sat, 31 Oct 2026 11:45:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC1DE6B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 11:45:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5BE2C1609C6
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 15:45:24 +0000 (UTC)
X-FDA: 85383345768.26.359B65B
Received: from mail-200165.simplelogin.co (mail-200165.simplelogin.co [176.119.200.165])
	by imf05.hostedemail.com (Postfix) with ESMTP id 650A4100008
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 15:45:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=8alias.com header.s=dkim header.b=pdmSeHB3;
	arc=pass ("simplelogin.co:s=arc-20230626:i=1");
	spf=pass (imf05.hostedemail.com: domain of sl.lmysyibrg4ztkojyga4donrmeazdknbrgeydkxi.zmculzw5zubyq@8alias.com designates 176.119.200.165 as permitted sender) smtp.mailfrom=sl.lmysyibrg4ztkojyga4donrmeazdknbrgeydkxi.zmculzw5zubyq@8alias.com;
	dmarc=pass (policy=quarantine) header.from=8alias.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793461522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qD482B1x9OW46mcV0NOxxvY9DRkgOEV3+OdPHjQp9+k=;
	b=GKsupH8QF13wG66HHxbCtcQbmkRKb+dbM489IHcdf1wY9IOuKT4aWwmeMi98taomKM5U7U
	8YdkTPmvisukfT+YuSU7zFvMYrBYei0/gROiqAUy80MAXyDIlFuDYBcBtr3o9dIvLTB9Te
	gLU9TdB+0lAZFWt3YcZYpAMjOXOy0BA=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=8alias.com header.s=dkim header.b=pdmSeHB3;
	arc=pass ("simplelogin.co:s=arc-20230626:i=1");
	spf=pass (imf05.hostedemail.com: domain of sl.lmysyibrg4ztkojyga4donrmeazdknbrgeydkxi.zmculzw5zubyq@8alias.com designates 176.119.200.165 as permitted sender) smtp.mailfrom=sl.lmysyibrg4ztkojyga4donrmeazdknbrgeydkxi.zmculzw5zubyq@8alias.com;
	dmarc=pass (policy=quarantine) header.from=8alias.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793461522;
	b=eucSFRRLS1mt3NSz9kV8iL/eXnusR1Yr3uvCoW7FmIgYbaKzVwdGQf0+OlUH6hoBBvY/xU
	uwqGpyWQWjb8a401LAcfLqrPlAjcNNpkp72GVR+lfSzptg1C4dJpP4otV6pWc0hKWVUv81
	PJCJXT6XyAOL9KY0WyHxOhTgMWrZqYc=
ARC-Seal: i=1; a=rsa-sha256; d=simplelogin.co; s=arc-20230626; t=1793461521;
	cv=none; b=yW/8h64RfhKwx1I3c+GSAnpmJ4xHm4ZgAJRl3speQt81t8MNaAwfHS78fjJfQbthCZdpE9dvD2Og0E/20KB9rV5Ex9e+xop0IgALlCyB8NDRMytbTQ1QOUwB93Mll6xEDso5NhT4rbOK6pacJ5pOed3MuJonRGCbwugWP7kGZlVPECcP9dIuiiS7XDX9vEURWgribvS0weiEriawBuF1NpQfHL5v54UrvWNYhMKf71phq+Kh30GXBgujKHAF2XvRJcITtrs9JmQNODEua8mdpsFY6ZrGRFwoyaO9PkWoU80elQDA1bnCS2UDCDjLV2YuLSKMtAx2STZPBq9S1viDlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=simplelogin.co; s=arc-20230626;
	t=1793461521; c=relaxed/simple;
	bh=qD482B1x9OW46mcV0NOxxvY9DRkgOEV3+OdPHjQp9+k=;
	h=Date:Subject:In-Reply-To:From:To:Cc:References; b=eyB7Q4BpxOq0pFR8SAWnWikK1Nn3TXSSHW82WcJf4lYLfodWaDeS4qCG3YSUd9DoZ2pudtWQcHi0oM7ymvUYda+3jQ3Y+mRBwHZZwzqK8WZgwmyiqFR5Znwn/ki5XUya0FMVYKIzwHtsWY6qBEM8rZ33vkmc7uQ6iuWEaU61eCC6fnmXxPvWkltXgaera1jGarrrul9Mz5XA5La1p+ujPNe1ySpPiSzr10mTuJg3COtOcsu91It35A0B1X1pCRCK3FII5ZIvbubGgEbVWPRyvjh1B5Szwuim45QGp8qMr57NF/5zKRebJuLaWjZWTkonmJu+JgYZDk1R3j5Voc8z+A==
ARC-Authentication-Results: i=1; mail.protonmail.ch
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=8alias.com; s=dkim;
	t=1793461521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qD482B1x9OW46mcV0NOxxvY9DRkgOEV3+OdPHjQp9+k=;
	b=pdmSeHB3HPsR4w43goZTKVojtsSynHw87P4a1NEOtPmgtZT5QfqZEt+qXvamcdJmvbaMrl
	ork4p8f8wzDYmAZDHHTzv/3AyB0VTL+ZFAWUzl03YR8y0iaEHHa8SOZYJB0cudYdEBd1YI
	4bzM3VSVh8nmPFCX81qVRycp2p990D4=
Date: Sat, 31 Oct 2026 15:45:13 +0000
Subject: [PATCH 6.12.y 1/2] x86/ioremap: Sign-extend PAGE_MASK when aligning
 the physical address
In-Reply-To: <179346145167.7.7861216093151225931.1735978772@8alias.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: =?utf-8?q?Radek_Marci=C5=88a?= <github.unusual340@8alias.com>
To: stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@kernel.org>,Ingo Molnar <mingo@redhat.com>,Borislav
 Petkov <bp@alien8.de>,Dave Hansen
 <dave.hansen@linux.intel.com>,x86@kernel.org,Andrew Morton
 <akpm@linux-foundation.org>,David Hildenbrand
 <david@kernel.org>,linux-mm@kvack.org,Arnd Bergmann <arnd@arndb.de>,Michael
 Kelley <mhkelley58@gmail.com>,linux-kernel@vger.kernel.org
Message-ID: <179346151984.7.6028133845439165356.1735980824@8alias.com>
References: <179346145167.7.7861216093151225931.1735978772@8alias.com>
X-SimpleLogin-Type: Reply
X-SimpleLogin-EmailLog-ID: 1735980876
X-SimpleLogin-Want-Signing: yes
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 650A4100008
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: mqey59awysum1zjq9wremztuo4eu9imy
X-HE-Tag: 1793461522-523659
X-HE-Meta: U2FsdGVkX190f8y1FOFQMo5JDfKzmqT+bUhAh5n2INOETzqW5+UPcW4XkSYPGrXItmb9mg+ErGcOOtMvInw3vOkxy0Gc+Qau9c6qzxYwGgsWKw4OR3oZMl+PWKYtKAz2W6grsXOPyWGhsvneNhUW9w88Ty0ploOsCb+qrWxCkoaggyKHLG/cQkpTB4S48kQBJI8v3rTaSbRJCJKrv73S1NCab5bBFmnW8yvE1RPsvUoCwYEPOiV3XRE/XqkhKaskTTPe3WNTNkPEFRxfPphADxpR0k/FZgElmIvSehTTWCEgp+MGgc9UAriUHEpjG/Az+WIYXrSnN5FcueWrcSGY3XqS1wPIZLkeLysmxFyPNkUTe90WMY/duL5sWe/Tl9DNK9/H414Hb6ToRhLDRNbnpePSa/rWHO1QqkvR2v68MHDxY98WFsRnCD0eVZJzBrUchCB6yUCKFg7m2gBpH/rrjSQK4T53S2fnuOjuqkwO/o5gaGaYk0/Dzvd8EVfURvgIivnAQeoHPKCTbWkDiKNDrdc2QF+7WD6EiWISywnzLXb+hd0MIEt+ai6MmzuS1iGlfcKIRDanMcITY1k5gZbKbhJZwubLLQ/EuryGPn5LIYA+0RdAToofZh5M3Nh0poQD7LHE+CesJVtUdSV5+5LltQyaTHn2FrscNCdhO4Kc1Vot8q3hX6E796qHYOIGRB7fJKSgk7Tr4SqReFkj9H98Fu05BFh8vuETl4U7l+JNIJYvRdNfz5nT9mQ6vpeI1OwL7PqqzLqsBrxGqlqFIUXAPl9WueraZYYSlyjdwiuUpQHojtBp38tzNw7IBlbqMg6A9IsT7QzG94j14wHbkhpLZBEkL2xhC+RfguSNwGQ5GpecI/wDxXeMPabirgoZdFeKg5p4ZMHSCFxg+DYd+uZeLi/C3T8dMULzreep1YpuV2Wxnl38v7VIYuMqX089/ZLEy+krN3oMtNlGbWp8xa7
 UbhWIxCS
 IS+1t59yhWc+o9LKWNkfVB7Rf7ngX4zrKOnWZ4gfsfHpWQh+5Ei3DI1JuoCWbrJ8hOzIQCZx5hIO8jPREwZVFXA0LCRQmZi5JXtc6/8F9zGCK/RIHbKz+FiP7TMD2O7RS65LaveFUExrue3yiDxsDnGfBf58IEYaKuxGid7WL/yAZrVfIEYEZdVmo1C7w1+u5FaZY0gNBOSh+vHq8HFlRkkLtsl1Jd7T/Ju/WR21a1yT9/Avg13milnO9ezehhOYOp0KX3zlegHzUljupqViJ45vz3v9S+HXl7wj14y1lLQj8C+rYOm+4rGaRqE8lcqfvuYa30iW2BSiid9NzFYsWuIAGFEYhujad06vrleHqVXfAMedEfVEt1QAfPlwXf8tuLWYJBzkFjH+2gcJYI5iio1LTqX5TzlEdZyke1zk2FDu/m2MR14m+JNgX5SF4ZMFkpXkLtipoJO9Okccl29i0On7iZpL76oIAi4qHAEA+DUhaHUssrhGQ9a2Q79Dmg7KNHjq+rCy4IZVLjDi/cNUla9KOxwrLA0OZRecz6P5lsNdlxiJOElCWVBheaCFXL7hOOfBPsQN8EJXuX4yD47/l11VgfjrySdycFJjqlIz9F1jFXyg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Radek Marci=C5=88a <github.unusual340@8alias.com>

[ Stable-only fix: mainline is not affected since v6.13, see below. ]

On x86-32 with PAE, resource_size_t is 64-bit but PAGE_MASK is an
unsigned long, so in __ioremap_caller()

=09phys_addr &=3D PAGE_MASK;

clears bits 32-63 and ioremap() of anything above 4 GiB maps the alias
at the low 32 bits instead. The RAM check runs earlier on the original
address, so the alias is mapped even when it is system RAM, and the
caller's MMIO writes land there.

Commit ffa71f33a820 ("x86, ioremap: Fix incorrect physical address
handling in PAE mode") fixed this by masking with PHYSICAL_PAGE_MASK,
which casts PAGE_MASK to signed long. Commit 4dbd6a3e90e0 ("x86/ioremap:
Fix page aligned size calculation in __ioremap_caller()") reintroduced
the plain PAGE_MASK to compute the size before the high bits are masked
off. Cast it the same way here.

Mainline lost the bug when commit efe8419ae78d ("vdso: Introduce
vdso/page.h") and commit d4a65302dd84 ("vdso: Change PAGE_MASK to
signed on all 32-bit architectures") made PAGE_MASK signed on 32-bit.
Those rework PAGE_MASK for every architecture, so they are not
backported.

Fixes: 4dbd6a3e90e0 ("x86/ioremap: Fix page aligned size calculation in __i=
oremap_caller()")
Assisted-by: LLM
Signed-off-by: Radek Marci=C5=88a <github.unusual340@8alias.com>
---
 arch/x86/mm/ioremap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 8d29163568a7..14529884671e 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -223,7 +223,7 @@ __ioremap_caller(resource_size_t phys_addr, unsigned lo=
ng size,
 =09 * Mappings have to be page-aligned
 =09 */
 =09offset =3D phys_addr & ~PAGE_MASK;
-=09phys_addr &=3D PAGE_MASK;
+=09phys_addr &=3D (signed long)PAGE_MASK;
 =09size =3D PAGE_ALIGN(last_addr+1) - phys_addr;
=20
 =09/*
--=20
2.56.0




