Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78698CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:19:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78E876B009B; Mon, 28 Sep 2026 13:19:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73EAE6B009D; Mon, 28 Sep 2026 13:19:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6074F6B009E; Mon, 28 Sep 2026 13:19:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32C696B009B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:19:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9AEBA140252
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:19:33 +0000 (UTC)
X-FDA: 85263832626.12.FA93226
Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	by imf30.hostedemail.com (Postfix) with ESMTP id AFB3A8000C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:19:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm1 header.b="Xn2F/Bee";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="R mLDyIs";
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of linux@jaseg.de designates 103.168.172.137 as permitted sender) smtp.mailfrom=linux@jaseg.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790615971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uneboma/He5NY712qSn+vkKH9VLe/Cb1KqO8Cgbtg6s=;
	b=GIH2GblKNkdzhd7swFD9OCcDdX/WrqKn7GLhB3iG7bORnGajdCc2f2GiirOV2IakQxXvE3
	fZKrcOESery4RSU6CcKRZ1KxvSLFZOs4mKn+Wj8sp3yjTkM0lIu8t3KCJ2fTBGlpwIvn/B
	0k7F7QbruiB2iHQ5SgcuNO42lCuOgpg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm1 header.b="Xn2F/Bee";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="R mLDyIs";
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of linux@jaseg.de designates 103.168.172.137 as permitted sender) smtp.mailfrom=linux@jaseg.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790615971;
	b=X5uJeFXyR1mN6CR3/nY4UPTuaB7qm+ltgJdgWqustSp621LMr8nkYHS2KBxOAPxdhRCFlI
	HJe/eztsAwuAiNwwk08+Ucl6SM1CwV2Ru2gnlFv5nzmImurqmXc6X8w96Io0+BxSXSgpTT
	95GtZPsP/vlanXBPe5pfTbiogAxy+MY=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.phl.internal (Postfix) with ESMTP id 3819B138050C;
	Mon, 28 Sep 2026 13:19:31 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Mon, 28 Sep 2026 13:19:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1790615971;
	 x=1790623171; bh=uneboma/He5NY712qSn+vkKH9VLe/Cb1KqO8Cgbtg6s=; b=
	Xn2F/Bee2z6el8igxd45eG5wNR3NTrKx7+cMDXdvBagHejvMQ3l2B7xoMDOi9tbv
	bmOai/bWCJXgQ+8FZ/MIddhy0zYXzhBbanH2mxuHc8QosuY4W8JiMP32EgCpQNkr
	Yus2uclL3ku6O7zRGgEK+MAuyQD0pQHCEF8swZb/H8O2HrPYlBbMwLvyqGZKS3Jl
	PusYIKbSPFOL110nj4ceQI78Y5dYwDs79Xo0zqWaxTkRteg6joLAhQ353UlE0Eij
	x7tE8hVpGVOWGn3LDMHxw6lYG1eA+Hb+3jlNebmsj6uRn+pqMxYqdXO1VbAQo3y1
	cvnEY6u9S6yjH6CE7K3ezg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790615971; x=
	1790623171; bh=uneboma/He5NY712qSn+vkKH9VLe/Cb1KqO8Cgbtg6s=; b=R
	mLDyIsjulzLIsTwhRMi0Y8pi3oNM/uK6t1tFueteHaAp2PQV6ZJnqI8MMbFXxLCP
	O8b6xvGyE3q1wE+kLOAVQ8ae5i+YEcumlA4iyJUZUQdIbNLhG+/laDPiLcjyEq7G
	OerP/50s2I/1C6OOeoEzFNgHc+ypOrPXoVlUA821ZWTYhy8B2iZDjovtwiEX03kl
	0hohRTpk0Wxmffqx4xEOPBHa+aBfXK9AmU6cdmLJPzVqbojT7MuftNBq6N9nbvA6
	XaxG1IpqYx9b0qbzz2Nd1Wi13Hf7pRY47+jT3T5kQbAAe1GYhcSsqKAf8379EyyV
	mVTNcl8tATt9OsqjzQDWA==
X-ME-Sender: <xms:oqG6akz_t_NO5OQBDb9ttMWsMnqn7AY4tbbx4GGKRtwzWbhB7JWHdA>
    <xme:oqG6artZp4tzP0Ns9p7PItzsybQZRH0NgokjY1zt8AnVEL37BJo9tEZGQmH56GOsF
    dT4vAkjW-zF0y8TtKilHSrGfujQK-i_QqsM8Bkc9Zqi2NkTDsUEVXY>
X-ME-Received: <xmr:oqG6aikTFlGCBNwtgNyl556uB9m9tUporo9_2rYIo-Q959DayGUzMck1qpmfLrJf>
X-ME-Proxy-Cause: dmFkZTE/22e7clbyNdHwn0HCBx+H3lsiFyo6QkPV6dpSn20/QyCOxtHNd7QTmx6b7eJ6RH
    b7MD0YK3xmhVFW7pHJl/jJiaLCtzwYaWJ6VBcJNMtYB/lM8rXCQqoyXJAKc1Q+3NTJHLRu
    Q+616RIwRjK3mn/tprgeZTxr9VaE0UGr12rr0RgYUziHPYN8WsIu22gnQm98Dq7NFgLEYb
    bOn/3mv6ye0r5zsmXTZhHlWNyOVRZl7FwJjAmuaSy3Z2MGyz8Xby78ZPjGLjvAF+o1XCsp
    YM5+7QijkJtemWRQaETyS2I23TsNHUOR4KF7C0sS19NgtEnCYopA0Qb1idGIqDD/y3bADx
    xRU4viQI6KJSw8q5mlwZtBEc0ssyEq5m2pBX9vtZm1x4BknR2LEptfHY85GS+fDNvix4gY
    7KSs25IBd7mTFsOBM4oeGwrKZn7tHV2mU6Lx2n9+HpPSJuxygANxQ52D2fB8CRAZY8xEJ7
    HjaT3/3gywZt0jGF/7GuvB9dQYMx/Z619uzsZwfJdJKFCLiVR/khsnerLC9mx1Xp6nLWCR
    6smPwWlZwgXj56Nw2D3J2DNcbksR+eBw4vu0EK753rWvj+zVGnaMQy+RoJcaZVWqasYsfx
    /5b4TjmoopI39a+8sRxSiX0DvGSb4mD5JElNjPTWLqifji1U4yiV+MKYODmA
X-ME-Proxy: <xmx:oqG6arittnioN3DLHsayzIWeuevkbgi_c00u8crZZkBOn3QJcTf6MQ>
    <xmx:oqG6agHtBatmdR3EF5qifCfYs_5Mo7wsCcsuqa9yb0eaowtZ88cfEA>
    <xmx:oqG6agOFv8Qri8cKFdDvtZDh0Vq8v7tJe4vSDLnoiH5j1TT3wsV6sw>
    <xmx:oqG6aj3m9rglGLVtkHKbdslitarg2WO4XrwWeHx7c7JjXpEKLlB5cA>
    <xmx:o6G6amD-XKs1zcTn4v0Jkglq701b2vCXV_LIcW5qh8psE-RWxjBqgIoH>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 13:19:16 -0400 (EDT)
From: =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
Date: Mon, 28 Sep 2026 19:17:52 +0200
Subject: [PATCH v3 04/12] arm64: Enable the crash memaction registry
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260928-crash-memaction-upstream-20260921-v3-4-e511e9ee2329@jaseg.de>
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
To: Jonathan Corbet <corbet@lwn.net>,
  Shuah Khan <skhan@linuxfoundation.org>,
  Randy Dunlap <rdunlap@infradead.org>, Rob Herring <robh@kernel.org>,
  Saravana Kannan <saravanak@kernel.org>,
  Andrew Morton <akpm@linux-foundation.org>,
  Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,
  Pratyush Yadav <pratyush@kernel.org>,
 Dave Young <ruirui.yang@linux.dev>,
  Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
  "Rafael J. Wysocki" <rafael@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>,  Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
  David Hildenbrand <david@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
  Brendan Jackman <brendan.jackman@linux.dev>,
  Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
  Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,  Mark Rutland <mark.rutland@arm.com>,
 Alasdair Kergon <agk@redhat.com>,  Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
  Benjamin Marzinski <bmarzins@redhat.com>,
  Herbert Xu <herbert@gondor.apana.org.au>,
  "David S. Miller" <davem@davemloft.net>,
 Mimi Zohar <zohar@linux.ibm.com>,  David Howells <dhowells@redhat.com>,
 Jarkko Sakkinen <jarkko@kernel.org>,  Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>,  "Serge E. Hallyn" <serge@hallyn.com>,
  James Bottomley <James.Bottomley@HansenPartnership.com>,
  "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>,  Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,  Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>,  Lance Yang <lance.yang@linux.dev>,
  Baolin Wang <baolin.wang@linux.alibaba.com>,
  Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
  Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
  Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
  Matthew Brost <matthew.brost@intel.com>,
  Joshua Hahn <joshua.hahnjy@gmail.com>,
 Byungchul Park <byungchul@sk.com>,  Gregory Price <gourry@gourry.net>,
  Ying Huang <ying.huang@linux.alibaba.com>,
  Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>,
  Arnd Bergmann <arnd@arndb.de>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, 
 kexec@lists.infradead.org, driver-core@lists.linux.dev, linux-mm@kvack.org, 
 linux-arm-kernel@lists.infradead.org, dm-devel@lists.linux.dev, 
 linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org, 
 keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
 =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
X-Mailer: b4 0.15.2
X-Stat-Signature: j1qb4hdom1ardnu1y456xehwtu6i793z
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AFB3A8000C
X-HE-Tag: 1790615971-781535
X-HE-Meta: U2FsdGVkX18TT5dFJvc3Gm07RRfrz9gY9U1DMy/73ldK9Xp6zdHVFVYZJaAzfbYLCSe24HcmVDg+kS/O13miy+ZKDXpUL3SPTlEHGkVj7IjKA9rvWhTN9RrhSA1cTw9ZKJqhFsEGRlh1JYD1rvQS2Bx2jCJwsbszzTwOy7B1D8jVHaksMkSP0s9jsoRXCuy+gZ+9zJP2lTjOnu1mj2NAQ3Wcnb8T3waDs4LT51e49Y85hCaf3mOVtF/tbhZCAhzSb5k6CUfnRccBoXstzpFNPvjhqZoizpgidXAeB7mdLdAjtkJPjczEjpwnOOIB7bQuBdTvmMEtSCnx4Zkarm/8pGSqxZO6/PbvBuycWmU3hL9wKRC9NMvEzSFIfvwS4qTPiIUAQ4kyqBqiV5gbJyn+PeSAvH58Om1RSL7q4WT84MKl5KXajDJ3ZKOE7yuc5WKcyKZYFqQid7oINMVKZNAAUHkLb9MVciiW4XKM3CkIGbE3F0MgvRjAqhg/cAPbqwNIWXIeRlmM6aCvYnlYleMISsH4Y2zO6sWhbpqMjZNipAX573eIp8tYq/EvqIgjy4HU9+moG+49SK3I5SUe/p2q6G8WF+yUGWhpiS+kga8U+g85jkFy9yw+0lCTncZc7DeETdq3ygdD5XV+8uhRd3C49TJdzWfq2kI0JVGQl3r3X0xqnZvzmzZhtKWzVsRcjxCrF/znbbUAwzOxhNZLFfgHlVDo9HfYfoER5P9wx8EyKPgTDBQweqSiJcfI0OfYRLq5xNm4iWg7q3MZjZv7USYq9gaynXc9aI6jVGHuft8njZjnQTAl+3h3psdWfIuFctzr8GTdo+Yr+WWsIjCuPInOn3soUtqQAZzE0vlO/XBo34PMLbi84X+fWlWzMNKfhOEK3Xr9W/IONxAUagWAt5BUbZpBqankYdjsRT+/TTTjoJVHW3QcXehfCa7KankejRAgeonU1slaXyyjSRi4QVY
 VV3JUlid
 61mn30GrF18arTZXMPSPLSX7NQsEdkiaHuHF2nbG6V+N37/wTPMzHxfmkLxPE3u0TSf/a2a0PllJoIrD4Q9BRD/thVbQt97krx8y2vzhDJT2kXOtXKehKRceDsJffKLgHkJT9vnDsuQMK/ilANow61EWeOvuF8PpIef0R6WIe3jhS/JKTcFFBE7YgEJrHVitxGFhBD2RrFMJ+jPA4gZS1O9ZVVEYiGrSHwGcvuBzryeEAAIzD7ijEu4K41JuwsM+7YoQYJC1GwB7mhBoWN1YCGaMb3/ZKHtHcTpE5hK67+uz0mrJUiXXpWvwFaL+AYAD59hXOiEGio9lY8CwVtVNSgVDQsVV7ULkeAMUY/Xf2mNtWfgQ88A0HDGDBimbx7DIi9KulkpEuw3B7TkUMEk1HkcuIhqYFoyBPit4tFC3DOLs08GpTlMxS18eanUZ/y81mPov5XWec3MPW+vEessw7U1iyfuA1UEQD8xaF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Select ARCH_SUPPORTS_CRASH_MEMACTION on arm64.

Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
Assisted-by: Claude Opus 5 <noreply@anthropic.com>
---
 arch/arm64/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 54c344d39830..4894a5cc11ac 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1720,6 +1720,9 @@ config ARCH_SUPPORTS_KEXEC_HANDOVER
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool y
 
+config ARCH_SUPPORTS_CRASH_MEMACTION
+	def_bool y
+
 config ARCH_DEFAULT_CRASH_DUMP
 	def_bool y
 

-- 
2.55.0


