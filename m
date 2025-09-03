Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 863BACA1012
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 18:59:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B17BA8E000D; Wed,  3 Sep 2025 14:59:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA1A98E0001; Wed,  3 Sep 2025 14:59:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 941878E000D; Wed,  3 Sep 2025 14:59:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 805008E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 14:59:41 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 22322160863
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 18:59:41 +0000 (UTC)
X-FDA: 83848852962.15.581A2F3
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4237A1C000D
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 18:59:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UpwJPZzz;
	spf=pass (imf20.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756925979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p96JFKpspRPKBmH2rgBynj/gu4bh0EGooQeUZ0NhcIU=;
	b=qkllFkuo7SLFdizBmPDm1e6hyPAITJCbf/pQU/twK94HA0rb0JTt3HiMCJ+pGTEzC79Dva
	OQvsVELrv75rycV09woYm0oHtn0ZZOKyaJ9apysMXtW5BcWARn8WJPElHXtXF8MDr7Ao9D
	p2yECqKZBJP7yyl/FVIvq1ceekiFc7U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UpwJPZzz;
	spf=pass (imf20.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756925979; a=rsa-sha256;
	cv=none;
	b=NfKlXDYYDS3BzrJdMYF1q71iUL7iBOqeXMV1EA60C78sPKVx4E/lKulK1CC7uKnVQdGd97
	Ugdt8dE53W4KjBN/lu5/LztWsK2xGIsa94lra2mfKXAOFhbIEp5YdgBeqN8q1zGwJaGDh9
	eXhjZbD4crtx1MQGiGcivNMN84pbEbg=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-24af8cd99ddso3801815ad.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 11:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756925977; x=1757530777; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p96JFKpspRPKBmH2rgBynj/gu4bh0EGooQeUZ0NhcIU=;
        b=UpwJPZzzISOoEAmGfBQGC1CYfabaRPoOv0al+bwMFYLinWYm/Ocjl53zZVZXWL+RrU
         R2M4O6FEYo6kPIQ4Xvf8HuqZDlenSIwkWz2uWbVHCXoE5SmWClQA+qrUxppDYg9rCN+V
         oiafKCYbn3lHdQMarnL4RjQ4ynG3zU8kjlzZQkPVf4zcYopeQrITSUB3g7HcEp4PxBrk
         qzE+0FvqYEjd8WbOS+nRqRdBRygN1rvR1yDeLX9hc+RXZl8dkzWYms3Wl3csLS2qFmRA
         SXe5+v6UeUxgzU7XtucKeM17ghrp5ZmNQlXvPcsXD7+LTs7/DO333pYeWyseTUX/dRrl
         kzjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756925977; x=1757530777;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p96JFKpspRPKBmH2rgBynj/gu4bh0EGooQeUZ0NhcIU=;
        b=UvauajrhELSTsZUpX7lCv/mjobijP5t9IRJTeNy/aai9aNJYjgYG9blJlX0qP3nsG1
         UVCWEwhdzE2FjKTqFqHzalihiKtCsWMAgAZNUW9lTN3IjHGCKyhFMraKx3/LZ5MuoIxC
         9iZinNlOTMIbnxFjea3yzKCwx449Fpe9SUzYYWzosWFQmRP6C0nznBp14HCAVxYE+ljg
         g5AkxliovgeaP5XBmAiBwjhACpDI6eg4u8jFKHXPNB6e8DGbwjJjypkgc6ZHXF2BkjnO
         WsmVYfvwTrtoI5WpWgsjZlTth0OvoaupeuzhaZJP5eO/annmYziz2mvOG50G0W1sAMq2
         ahNw==
X-Gm-Message-State: AOJu0Yx+UZwEHyVkZAqDr6McVbPhI7tDkPHAEAnryUKx/srnSma2RLCd
	zPzPXwLm1ssCkfe24UiG2J4mQ+NANAxEHdu7XF2/DVespJcHowB/uDLWKCBefg==
X-Gm-Gg: ASbGnctY4qh9VTbdk4h7DIzCg81NSYm3ttqPjDePE8hLqVJm5dBSugXgKnC+YXS/V3o
	DXZhIZv8DhgMLfprsKQ1jKGJwVeH/oQ8P3zJAlX9tB1sU5bmMrNkT9RSNUFF1Tfd78Z8zEEFdOl
	pm8W3qnOxCPIfL4deHjd9laYJRPBNFv6zBDtCixnDFPl2cNe1pV4cusjC2T9KTWG1w12WEpeJQG
	VhR8553XJrGDVUof+Uouoc/ZuWLkutcHqmoDC72+ZkcttchksR8uUE7O6OxmwN+Owi8njSVGRsQ
	k7cwiGgtkMj6e99cqyXIVilWUao0ZZiK4wlC/8AUkY3cG7g2k317U3OWHqudVoxTtuEye6X8ctW
	Glws74oC9Sp876kdgpJDIiAQwluq3BfT34OCNyhfuZGWGWdZQ73UdgSuwl1q+lDy7BMiuEgFdyO
	U=
X-Google-Smtp-Source: AGHT+IF6bU8SPLeBKOcF3DV0pz3IKcU2SprGWCJIgsDwHZ4utP76U3dUm2BhH0lDWIsPOTFAl0TAFQ==
X-Received: by 2002:a17:903:2f8f:b0:234:b743:c7a4 with SMTP id d9443c01a7336-24944b19ea3mr233283115ad.38.1756925977585;
        Wed, 03 Sep 2025 11:59:37 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-249065ab343sm169403475ad.126.2025.09.03.11.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 11:59:36 -0700 (PDT)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-efi@vger.kernel.org,
	virtualization@lists.linux.dev,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Justin Sanders <justin@coraid.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH v3 2/7] aoe: Stop calling page_address() in free_page()
Date: Wed,  3 Sep 2025 11:59:16 -0700
Message-ID: <20250903185921.1785167-3-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250903185921.1785167-1-vishal.moola@gmail.com>
References: <20250903185921.1785167-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4237A1C000D
X-Stat-Signature: q6gfiwi11e3msj34xce5ceozsgzn5717
X-Rspam-User: 
X-HE-Tag: 1756925979-880084
X-HE-Meta: U2FsdGVkX180ynONHLVkutcHfqQxbzHrDwfmrrAzkCnUfzjar6sYCROtTcdOjubhv76dshc6dQymDeKiHaZqJeUJYW7NXNZCxF3EKi0CeAA+K/OYlJCTaJGuoodtYhLXa4mwa2FF1H31uIjAZZVPsxzdARJ5pre5PCYWFvQ/4OvZ60p7auTOjYjtTkpPS0XjfIQZmqYxaZJleiNXzdd4M3YbIiW65ssKCprx1BH8xn0fxF/i0oUXrSwRU4XpHIL0eD8jo9FGFTQvrlzNXZWIaFWn3KJSC1bCM+jufr+ce/fchd9OC8vg1MTI0vZ8F/rUQQ4CxiTs0Wvrtru/929hJHtWePpQ4Nch+ML23D4lGZPRidu2zfRKkT2Dqj1YRX0645XIY3Phwq9m2T7iDB/nC99T3wF7mOkNRlb/ilhXCi8cTwiX2ambiHADUjUCD1VoTssjq5V7Ng4GTotEaRcp+EszpTN4Ux9qQNTnZtfuEH1n6nCMMO5sX78Mu/jLivWK8Y2yqAL6AEBnFnPCIdSEfM7rryFAe9G6L0wAJ2poK60LPzLbmUpvK8uaf+sq3oCGt2WFE7xKgmZAx3mJqU8uNqXAgOLeFEfG7qhUrdtF0T/Hf/vtBjZxFt+D9XBDxGCoqqHYcP5l6QVCLqOzQhmlB2YZXBueGUFrUsPOA+UUWTNJsPbtzGhY78Jtf5KDzZZR0us0KVwrSPP0OC0VhH0co8V49u72bxMoR/4RDVs0aYBxWgjXS/hpReiLvyO1EEqZNmN/zjwMlb7t2BvSeL7HQqKcv5pmT4YCezdQLL9mIAIgcrZEG1axzgWpIYqySUe+/ASXtqUNyJcTcGodVk4YRocdA1uypqp6uTVHltFygoXF/jaNMzLsGcaEIhiivYpXRap4ByxxpP9a+AG0WdWpdHh0WWnLnsS9BJJNtqXf2p4h/Bz4tusy4p3xphQ/lKypwJFQNdlf0mj66ujrR5g
 TIn7LQdL
 jGdhYhIKT2x4GTYFKStk8GIgdUnYwSblD7iBMTnH6aKqTbFIS6IRMj9BKkELuBa0QZCh5SYoUx+Z7cyoUPfZ5fLl0DtDgq+yU11QnOGjUWkHapinAfvwxkISOrihcP6LvGMLiPWPy8ZmT/LgFxJVm/2/rZYpoAplDXVNBHmVHbsXKTTplN0FDt48PGrrKeqW9DWddtX7VXIvWoE72gs6c/qIKK2fJF4PKQEguVeKp4jeJD2Vi/nrzEmLdvbc3l1u9L+iXWW8iKDZBLV15K0A1VtBVnEmiB5mahVzQFOS8vkswN+/FSBcEAtnzjHx/i05q9BKLlR4RrLWdrqJx8SCgFR+x5c7PD3PMblq4tWFZhjuoAeD5MyjwlY/avq8rMQ1JljaWa2yZVZO0RRcXOt/va8rKBVAR+IwYXrNh//93PM/9SP/qh6dQ+Gat6CXUmNDWypc32Xc+GshzsjykOE8Z9U7Ktz5MckHKJtobKxDzMX6yBiBSashlQyRXIan136kUMzkxJ3gxjqqGWdEcvJM/7tyWezSrjXK2+3yw9rvonmfZjahtrOerjHwT2bh56gBpni/HfdcUyfRUY/U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

free_page() should be used when we only have a virtual address. We
should call __free_page() directly on our page instead.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/block/aoe/aoecmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 6298f8e271e3..a9affb7c264d 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -1761,6 +1761,6 @@ aoecmd_exit(void)
 	kfree(kts);
 	kfree(ktiowq);
 
-	free_page((unsigned long) page_address(empty_page));
+	__free_page(empty_page);
 	empty_page = NULL;
 }
-- 
2.51.0


