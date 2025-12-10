Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B5B1D3C932
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 23:19:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BBD46B0006; Wed, 10 Dec 2025 18:19:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66BF96B0007; Wed, 10 Dec 2025 18:19:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 581306B0008; Wed, 10 Dec 2025 18:19:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 465166B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 18:19:02 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D4F8F5A8D4
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 23:19:01 +0000 (UTC)
X-FDA: 84205128882.01.B375A67
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 260031A0018
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 23:18:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pmj/n4uM";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765408740; a=rsa-sha256;
	cv=none;
	b=vZC2wJQGd3tnx3ml65sZxdneWRzdOA3wMFbhz46Vd8NA/AyO76CqjsYzXEQKjexJCthZQV
	tPrFvvd525np3YwkWVkdjNiHRYYapVVuBra1Kg9QFcQaUvi4t0N4969kwxBYiXlNIwCcTn
	rSjHlbBxd3cuvsjkZVlk8TZy/vcalsw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pmj/n4uM";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765408740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JGOGhVtLlTsko8rIWvFU2k08z5EZb2wu84K9i5/aev4=;
	b=EA1lGArT8r8mOdGTg5pUgLZ6afdXOEIvLHZani/v09I6etvYvixbiJ+Phsb4gjAnj8yjbo
	JeHUt8DNETdHCvSc7KvfFqAH4w1WegN14WpR3Yy9B6iucOEPnYKoV5N219dSczHPMbnQL3
	EZb6gOOjjQqrgk3HA5YCaCA5GYmCQ7A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F60C43DEB;
	Wed, 10 Dec 2025 23:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D2EC4CEF1;
	Wed, 10 Dec 2025 23:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765408739;
	bh=ry7JUujyO9LI43NEsCg0bF7+NPHcsipy6vmhKC/aO+8=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=pmj/n4uMG83Rk1lGX1UQyVXWINuA7QOIoWzjKBX4pmZv99iaCM9HpMWRaZy4J2pFq
	 FF261DMdmW+pse0VTwj5J+CzC7LZDrrrXmazAdNH69PRx4fqCyqjbs1ZxyImnj887l
	 R5SMpUKxQy+/bSvVxnhFJFSb7we3atpuce1bk8DWf4YNUZNTJUbvVMgz2loHcf1tVJ
	 KzxsZ4Za+qGlAjrvYzFqY7Sf376o/CylxALpGb46YPd6pJZoDXoQco5k2pM96ix2mk
	 F/Ypflid2lOsrCpyLN1tdSzlSe4Fg/b5P6n06n9ogmZ1Q4e3NJ6klPrSw0OkPhnGls
	 fAKfiaDuNus0w==
Date: Thu, 11 Dec 2025 08:18:56 +0900
From: Kees Cook <kees@kernel.org>
To: Alejandro Colomar <alx@kernel.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
CC: Christopher Bazley <chris.bazley.wg14@gmail.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, Marco Elver <elver@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Alexander Potapenko <glider@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: Re: [PATCH v5 4/4] mm: Use ARRAY_END() instead of open-coding it
User-Agent: K-9 Mail for Android
In-Reply-To: <e7bde864b0394dd0946b5227c6afac7c05560654.1765406337.git.alx@kernel.org>
References: <cover.1758806023.git.alx@kernel.org> <cover.1765406336.git.alx@kernel.org> <e7bde864b0394dd0946b5227c6afac7c05560654.1765406337.git.alx@kernel.org>
Message-ID: <A17C0418-E304-43DF-A6AB-0F142D7B8764@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 260031A0018
X-Stat-Signature: 1gmhhxumpnfy77n8rayajb1reghafirj
X-Rspam-User: 
X-HE-Tag: 1765408739-89276
X-HE-Meta: U2FsdGVkX19ZnBU311jcfEtOVnRuBFNBDJ50ustTIO+2geMRKubBZ38iu1gPO/vSRStuPZcQHLpLd72NHzMP+g9QAr46FWPbOu9RDDsbKZKkgwZWour2hQ2IRK6WEaay2Wu+sM9kZ72LtqsgKnVF3/QBhl1H1zwFFh9fUDXLIXA0DZGXeMR50iu0o9iEzYqgaKX52TCHHlxtDdh8JHWJ9+wIBJsALrKplITW9+59dpAZbIW9d4E8WDE16exnYFAY3AiU3PCRIo+gHm8ZoiQLvcyNy0d55caS2KQFD/XDQ/i4Lm/+iaAzBRiJCSnd91MrQJYJCxqnhMXc78ULNYlu/ZvzKxeweuWGT1K6KtvPVSniWksXKtcZkfRBDyfcnNN/WDMWbIMWqg0Nlrd7YnrOHmyzo4V1+VgJDQMyvLTrZ1o/Vo1lniAQaY6lrc7m6mHkJEPzPxOVoGwgb/nyiqFNJIoUvW8mbCbwTaW/AvGGSVEZbUBjURo351s0INHJ9OOVtSris6dmiv7BEWdvELJVZ/gkittAPKL+/s+Vgm0806u30gG2hkn/G4qwL14WWPDluZb4cffoUtwz8655eovnNMx/SJc1WZKx4JBMlUjEGdHAVLfJAYkfRTdXHsov6WDYVAJN04FoguxagVK6/Q98vgD0jpFCJIhHWj1xEebRrbtlj5gQzjn0UPz4Rv0UHZzDyGTd5mtuClN0sIVBXwnwdycAC64rKH+i8tFDDnr8znogpLE25pckukyCnUL7mR1OokbKbTf2ePWza7bYfSH8Q2Zfdhrk6cvOLw1ren9P9mztCuwjga8KVlpoxhUJxL8xcsHOE4f6UHnJnMm7BGfhL9hm2mosNxcs5BtK3erLNBaurIZu/NLk0qE4hFTPf3odjfCU+9zldqL7zGYkHh6w5iuMyFuoS1TZlbywy0ley961JAZtNM2Cy+BYMj3bmtsUmvusw6ir5BdR5ehxfIh
 d6XGiWCt
 9WEuiRNy66Mj2tMHIke9EM1TonmtmKC+oHVeKmkNWqKGpC/h1lBH0OkfIn1j+ZwhAQ+EP3zhF5AX8GPIPcRz3xJ0+zTKJiFfyzLgU26a1LGQrumz6eWOz1T32lCIjNVpj6nTVDotNKI3ksTvzm6jv6aiw6XXrrdLGmJJD1+N91J4OYivplyqECzx+D01udUeh2xRf85zwdoQryzTzAnDWrOdZpMahF8xmfNr6JUt2gAfe5K7OD6M+WtzinPxBhryhMBUg272waRIb92/pJ91XnWj+VtDGz0RyMOHnfVuOeCZhwKYFpKfojCWjhJVu+LpTZfZOQrUyIoLkJhS8vGxfx5CJclJP33ebXCSnpVDuCZses2hDrsTqCOmirNXz2AVjq8erzJqGS6ZzeBmduZs8ST7lF6PRhq4FMFAixRdcwv994ak=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On December 11, 2025 7:46:49 AM GMT+09:00, Alejandro Colomar <alx@kernel=
=2Eorg> wrote:
>Cc: Kees Cook <kees@kernel=2Eorg>
>Cc: Linus Torvalds <torvalds@linux-foundation=2Eorg>
>Signed-off-by: Alejandro Colomar <alx@kernel=2Eorg>

Hm, this seems to be missing a commit log body?

Are there other open-coded instances that could be replaced? This seems li=
ke a great task for a coccinelle script=2E

-Kees

>---
> mm/kmemleak=2Ec      | 2 +-
> mm/memcontrol-v1=2Ec | 4 ++--
> 2 files changed, 3 insertions(+), 3 deletions(-)
>
>diff --git a/mm/kmemleak=2Ec b/mm/kmemleak=2Ec
>index 1ac56ceb29b6=2E=2Efe33f2edfe07 100644
>--- a/mm/kmemleak=2Ec
>+++ b/mm/kmemleak=2Ec
>@@ -510,7 +510,7 @@ static void mem_pool_free(struct kmemleak_object *obj=
ect)
> {
> 	unsigned long flags;
>=20
>-	if (object < mem_pool || object >=3D mem_pool + ARRAY_SIZE(mem_pool)) {
>+	if (object < mem_pool || object >=3D ARRAY_END(mem_pool)) {
> 		kmem_cache_free(object_cache, object);
> 		return;
> 	}
>diff --git a/mm/memcontrol-v1=2Ec b/mm/memcontrol-v1=2Ec
>index 6eed14bff742=2E=2Eb2f37bd939fa 100644
>--- a/mm/memcontrol-v1=2Ec
>+++ b/mm/memcontrol-v1=2Ec
>@@ -1794,7 +1794,7 @@ static int memcg_numa_stat_show(struct seq_file *m,=
 void *v)
>=20
> 	mem_cgroup_flush_stats(memcg);
>=20
>-	for (stat =3D stats; stat < stats + ARRAY_SIZE(stats); stat++) {
>+	for (stat =3D stats; stat < ARRAY_END(stats); stat++) {
> 		seq_printf(m, "%s=3D%lu", stat->name,
> 			   mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
> 						   false));
>@@ -1805,7 +1805,7 @@ static int memcg_numa_stat_show(struct seq_file *m,=
 void *v)
> 		seq_putc(m, '\n');
> 	}
>=20
>-	for (stat =3D stats; stat < stats + ARRAY_SIZE(stats); stat++) {
>+	for (stat =3D stats; stat < ARRAY_END(stats); stat++) {
>=20
> 		seq_printf(m, "hierarchical_%s=3D%lu", stat->name,
> 			   mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,

--=20
Kees Cook

