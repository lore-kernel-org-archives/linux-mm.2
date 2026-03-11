Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E38F5105D26E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 11:04:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 230E46B0093; Wed, 11 Mar 2026 07:04:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F1E26B0095; Wed, 11 Mar 2026 07:04:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11B1A6B0096; Wed, 11 Mar 2026 07:04:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E37586B0093
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:04:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 76E651A0752
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:04:01 +0000 (UTC)
X-FDA: 84533497482.06.FDEF35C
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
	by imf06.hostedemail.com (Postfix) with ESMTP id 86BE518000A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:03:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.197 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773227039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FnHQ3bIdAi8wEjmBqXkx8ht9ABbXk7RHu/RXzBRYxKc=;
	b=iV64g2/LIHP/Fw+kkpd0BH+XM6RpIkwu0BmfYUgMGGhFlHXu/wt2N7pZH2J8ALMHPTWDeX
	POZL/VFzPxzgFwaqEQSbJa9g4cN4b7WPvJqjPGun/v65vpaPV9lT94VBDR+qTq3ZUBoADj
	fyBgMNFXW9ZpVpvXCrRJziMlmusAf7Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773227039; a=rsa-sha256;
	cv=none;
	b=ekvbJabcOVwwo/dvlr76XG6npasMHY+sKrfs5Ha7c6vqALais/0I7GhMq4B0HDyFKqXdK4
	xnAypP8PHqg06owSogvMxMU5pNz0XhSPt45lx8SYnob1qybp9XJDZqmQykFzFMTYUQ4sVv
	uR/AWV7uq+Va+ITOzg2J2Vls97NfYK8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.197 as permitted sender) smtp.mailfrom=alex@ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id B34EA4333F;
	Wed, 11 Mar 2026 11:03:53 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: akpm@linux-foundation.org
Cc: alexghiti@kernel.org,
	kernel-team@meta.com,
	akinobu.mita@gmail.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	gourry@gourry.net,
	apopple@nvidia.com,
	byungchul@sk.com,
	joshua.hahnjy@gmail.com,
	matthew.brost@intel.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>,
	Bing Jiao <bingjiao@google.com>,
	stable@vger.kernel.org
Subject: [PATCH 3/4] mm: Fix demotion gfp by clearing GFP_RECLAIM after setting GFP_TRANSHUGE
Date: Wed, 11 Mar 2026 12:02:42 +0100
Message-ID: <20260311110314.237315-4-alex@ghiti.fr>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260311110314.237315-1-alex@ghiti.fr>
References: <20260311110314.237315-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeefjeefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeetlhgvgigrnhgurhgvucfihhhithhiuceorghlvgigsehghhhithhirdhfrheqnecuggftrfgrthhtvghrnhepledufffftefhjeefhfefueekveffheejtdeilefgkeejtdeugeefudfhieefgfdunecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepvdeivddtmedutdgumegttdelvdemgedttdemmeehmeefrgeivgenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpedviedvtdemuddtugemtgdtledvmeegtddtmeemheemfegriegvpdhhvghloheprghlvgigghhhihhtihdqfhgvughorhgrqdfrhfegofekiedvrfdrthhhvghfrggtvggsohhokhdrtghomhdpmhgrihhlfhhrohhmpegrlhgvgiesghhhihhtihdrfhhrpdhqihgupeeufeeggfetgeeffeefhfdpmhhouggvpehsmhhtphhouhhtpdhnsggprhgtphhtthhopeeftddprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheprghlvgigghhhihhtiheskhgvrhhnvghlrdhorhhgpdhrtghpt
 hhtohepk
 hgvrhhnvghlqdhtvggrmhesmhgvthgrrdgtohhmpdhrtghpthhtoheprghkihhnohgsuhhmihhtrgesghhmrghilhdrtghomhdprhgtphhtthhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdrtghomh
X-GND-State: clean
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 86BE518000A
X-Stat-Signature: o6bomf73buoxbee1ac949d7y5gkqzsca
X-Rspam-User: 
X-HE-Tag: 1773227039-300178
X-HE-Meta: U2FsdGVkX1+BysdBnof378F2hMd1h784slo5RQzmnXN/JcA1VJrSJmBrXx/4n7LWS2uhUyj/zZ8fbko7vMYe+1luCcgljMTwaRfrcQQUf2iQI7cwWGwsDF7cOo3oAjw9UIMag+F8iR/QzJedqN05DAsxOcuMuThu/0scWOqzUT2PdTU1hzJoQ/rbPWard2oxqURFC10Lvxnebe8nrcbbnkNiSn2fgGgNYiazNbCfJ2R+MdbiF8pdCv5lcOWTykEpPHLrsVdHULN/Rv6Q+96+9xnO8dfMK5yVKxx7JpfaCNY6i+92W5RLC4XgldcNmJ0CcDFpYpoBPO4KX9kiyzbjV9jJRc+eZVZJ4W4VuuPiMMIlnp3d5fiZMyVWCh+BinT3I349YYenC6LGSwsF552fryxNol2KoG9UhEMbnOBuZvO7N7God4BuI4ZlD//s7U52no7AWe2a8a3nvelx30MD8E10ZAw5oR5oMAZUxGBB4+8j62FV08yVqEHz+F6fMyRrZsdS5nTdYL2Pnl8VuN75o8uoWIEeTY9X4lHMhNjCyCI8uDRa39EUj0SBS/dxc6JIT5T+nKFZlwLzaivlyJkfI6gHqJ1NWFsUuwjBoOen7wNjAgVE2lwY6LoWmWzTlnFwVvuarcP+rik3g1NVLp3A1pkhiuQvPX0mWIn6vnNPFS3hJeYFZJoSJD46SVEQpIQ/9wxAnjn4S9N+tUARAgpmBXgBPM8i66olwuBRykhQ3V7cE1gDjIJ2Ai/SPg1KK3rm1lI8fs4i9SfNFQ/LgvqMroSgQ0aB5Z0Ip0tXZaD4ViorIP6W/ic1g3vr27x+Wg7uc1RFO6OXkktYtZlFXxzllz6IRV3lz+XqFgF6k/cLjgc+V6XjQxxB8fWp7nayQxwHmncCbuoNaTCilZc/wg/oMjCUqv1kQqe1d4KJL6ToPTN2V1kZT4Av2U4ffvTwIJJwnNnmxSal0okDQH5jk3a
 Fu2U8GEp
 L9jJge5Tv6mRoUj+vm7NaGLlpGfSQ0kyd4GxvIaIU84L9jjMJDFYUy+1pdSrqXxyhdqxC/NwvYJWxIibBrMLZJhOhU7tydxhLqlCeXbv62S+tcNKm9/b5T5cobp49y6AX7BGzPA+u3qFFZKtaZce+5QP8FrDEma9AwEoP3pZyUIL0saZDlwcnk92xGYs3Nwju4f1gmuq3P5x+HCk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

GFP_TRANSHUGE sets __GFP_DIRECT_RECLAIM so we must clear GFP_RECLAIM
after, not before.

Reported-by: Bing Jiao <bingjiao@google.com>
Closes: https://lore.kernel.org/linux-mm/aXlKOxGGI9zne8sl@google.com/
Fixes: 9933a0c8a539 ("mm/migrate: clear __GFP_RECLAIM to make the migration callback consistent with regular THP allocations")
Cc: stable@vger.kernel.org
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/migrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 2c3d489ecf51..ee533a4d38db 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2190,12 +2190,12 @@ struct folio *alloc_migration_target(struct folio *src, unsigned long private)
 	}
 
 	if (folio_test_large(src)) {
+		gfp_mask |= GFP_TRANSHUGE;
 		/*
 		 * clear __GFP_RECLAIM to make the migration callback
 		 * consistent with regular THP allocations.
 		 */
 		gfp_mask &= ~__GFP_RECLAIM;
-		gfp_mask |= GFP_TRANSHUGE;
 		order = folio_order(src);
 	}
 	zidx = folio_zonenum(src);
-- 
2.53.0


