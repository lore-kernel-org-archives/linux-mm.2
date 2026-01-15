Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 244B6D44C5B
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 14:46:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CCC76B0089; Thu, 15 Jan 2026 09:46:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A4236B008A; Thu, 15 Jan 2026 09:46:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F33B6B008C; Thu, 15 Jan 2026 09:46:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6648E6B0089
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:46:15 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2886C14034F
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:46:15 +0000 (UTC)
X-FDA: 84334473510.09.DF0266F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6C38D40004
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:46:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i9Netuif;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768488373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r46m2AalZZ9Hz53gh5b5F2uYhAVEruhBOyhxkfPgW3s=;
	b=sG5RoNnRiWYuuanTiwJ+j5NQ52llPdSA6WnIpkSCHrdrSAbuX53HpvFMpkeLSd5LEdHgXJ
	cdQniVxhpUPRm6CFhXAyvrapEjHCuQNCN+vTgAYJ1mmICsn0IttA2DZkZrDAKTSHX+RoR9
	vdY8sQz8zdH7bDbhLn2K5rssIkcB74w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768488373; a=rsa-sha256;
	cv=none;
	b=So2xoqaZZk/49o6vdGMwarWSfB0YKYlz+WZ32hCcDAe6lUqG8SsfmSlMNqNAlefduIzzbg
	BO7TvIzL+O0Ch0NCyOWzKLWTr92P+uQst5GbQ5rK3PUVMFvODK2KkwX0UVEyLcNiJWXML7
	OnVAapPwep55uLGtNgbzQ3wpYgJ7yyw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i9Netuif;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D817D601B2;
	Thu, 15 Jan 2026 14:46:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0FA7C16AAE;
	Thu, 15 Jan 2026 14:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768488372;
	bh=h2aVQ3ENQjj9ztxIwRYvM4dkt+By0RfpKKj6zYgSlLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i9Netuifl0YR/4BxtFdfMrYyCXF4B/jBbWTmhyyatFuOJHTRs/w5mpC1sU+GxeFMJ
	 0Woll9vOjlUOQDO0geV9OwfhU8/PPo8qQqtxi7HRNU582F5opZ7VBJvpXzBJ/Er7yU
	 jYZSIN5Ohlw8AvEj+efT20/UcXoQofWQpzxErBIo8V7elS/IWalbVLDuGpLqpMIqLh
	 EaHKqFXPESFncv/Eb+IChWRHIyFUjS3fNvw5bzxxw0lRykHswxGEVelSYnhxP5Eqax
	 Y8vcmnDm0t2vPFmYjo77hqhBGN1k8ob6LClc3Z4aL+kVDmQ87e0cd9FYW2ePYomBPV
	 WHpp/3MqDEs/g==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 19F0EF4006B;
	Thu, 15 Jan 2026 09:46:11 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Thu, 15 Jan 2026 09:46:11 -0500
X-ME-Sender: <xms:s_1oabPvP328C8QJhsdvftsXZlxBDY07Rg49HK8Kl0k_aWs3P3Tv4w>
    <xme:s_1oaUXLCkyOVxELPOHQMsMDp-y-_m_zmiDommX40jaij8aAkgB-TTRlHshJdAy5r
    2Ba1s4z8cAMNYy6dhJLPAJyWP6d6_CR78F9Cb1am5XYL8yu73KzYxk>
X-ME-Received: <xmr:s_1oaWRDQMgWadXE4IzlHNRqYBj4Fo67GGiWtdmapI5FCfSEy1kyY4dYPXviqg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduvdeifeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdev
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvddupdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    epmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgu
    sehkvghrnhgvlhdrohhrghdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurd
    horhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrg
    guohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:s_1oaS0gdJic4XkVgirKJOx43tM6uDjXzLTdYzibAHljfROdktH3nw>
    <xmx:s_1oabhCoPfzxxc1mRLqYBISskW1uFcCd453tURSDP8S08srym2GLQ>
    <xmx:s_1oaYZs3EZ9P06fRUDUmnNaSo1DtW5Kl5eqSDwmEC_Sr2RlM__uKg>
    <xmx:s_1oacOmnPNPQeXa9nu3Cij79UQOq0l3SC1gAHNrscl7o-OUexZQAg>
    <xmx:s_1oaUTkG-v00HfMZ7Cs7AORxD71IgJYQPXFdJGFHa_yCAW5AfNFcIbA>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 15 Jan 2026 09:46:10 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>,
	x86@kernel.org
Subject: [PATCHv3 01/15] x86/vdso32: Prepare for <linux/pgtable.h> inclusion
Date: Thu, 15 Jan 2026 14:45:47 +0000
Message-ID: <20260115144604.822702-2-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260115144604.822702-1-kas@kernel.org>
References: <20260115144604.822702-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6C38D40004
X-Rspam-User: 
X-Stat-Signature: tshp6ee6zbdu5ssczpczb53x3ksf14te
X-HE-Tag: 1768488373-65050
X-HE-Meta: U2FsdGVkX1+szYquqRVPGEqFQNbakfYZ8edb5vX8p389ruhxkdQFyL+3Ab/apqZO25RSBzq7FcaExAXCoVEEby/15t0wpVBIrdW5ho6V1ZvXVDrJBwbUoC3gezTUT1xmYuO9qmFujsuVryg6oZBZCqGbXdxRc1xv5iFaf4fJqWWa6IVr0jE2kb7P6XjAj/FEs6YxqgSzn741MfP34t7eQddK45wwGwcKSOq+e9xbmGpIjwOR1xbSo7hPJP71Gv+zMpPCPfMZRl2cKBqk5YRA1KwPDYnf/2nXEzc8wieOFdQlvXXU9wQgbCfZmP3gGBBeVdqCRPPZVQh1UrES0go/ZXZ8mLdLLWXzYwQRHH7AdDyVO4Bjs2DkaY3/6PNYkBrKxhwUd4DbryONjH6qJazdl2mjKoJ9ggUV3ltO5uJWM/6mOY3PjwT+cjC5DKsTyWu6V01wt79gPVVa8/TOqNb3aCkn8s3QDD9ekVgjV2bxtZsm4VKW9i0GD4g0Wn3RDICaCjt66ROE812Rsga4Aq256w22YNSMNJUNpFu9K+XNsMFPi4A+mc0eimBjaq2mX6KZ8B7YTCUkmn8lwomvSnpw0Q0xZFCDZ0Bxjm6An8kDDGiL/Rb24AAuRRTquMbo5qplQp+NMrJOuBPEF8BJCBPLflQ+c3tTmkoRC8BQgPg5DhwbDce5i9WK/DGGF9i3ZMFjGftipa6hWWt9mGuTQ/xcpNrQt6/1Z1Z8zaOJoqBgNO8Zy0iPFv/6XqFMzWckGXhboBDADF3xIwv2qo4+X+yj9ZKudZzmuK6Thk9Oazfwej3jvXOk/QB8Y8OIP23bTFhQWQU6BGqMtIkkb+dmXKKxaHN8/JCLckQ9vgIuWxsdIEza9xsO9Z6v0wCshPqxUq7CNPziR2t/Fl5lS40KwH/o4z+DUcL32TK5qjTrQuHLbA8RNOIh8HTmcA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The 32-bit vDSO for 64-bit kernels is built by faking a 32-bit environment
through various #undefs and #defines in fake_32bit_build.h.

Upcoming change will include <linux/pgtable.h> in <linux/mmzone.h>.
Without preparation, it breaks build of 32-bit vDSO because of exposure
to more 64-bit things.

CONFIG_PHYS_ADDR_T_64BIT triggers "Missing MAX_POSSIBLE_PHYSMEM_BITS
definition" error in <linux/pgtable.h>.

And CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS leads to "shift count >=
width of type" errors in pte_flags_pkey().

Undefine CONFIG_PHYS_ADDR_T_64BIT and CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
in fake_32bit_build.h to fix the problem.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Cc: x86@kernel.org
---
 arch/x86/entry/vdso/vdso32/fake_32bit_build.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h b/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
index db1b15f686e3..900cdcde1029 100644
--- a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
+++ b/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
@@ -13,6 +13,8 @@
 #undef CONFIG_SPARSEMEM_VMEMMAP
 #undef CONFIG_NR_CPUS
 #undef CONFIG_PARAVIRT_XXL
+#undef CONFIG_PHYS_ADDR_T_64BIT
+#undef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
 
 #define CONFIG_X86_32 1
 #define CONFIG_PGTABLE_LEVELS 2
-- 
2.51.2


