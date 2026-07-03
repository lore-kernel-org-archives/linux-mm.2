Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5BBBC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 04:14:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 934B86B00CC; Fri,  3 Jul 2026 00:14:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90BEE6B00CF; Fri,  3 Jul 2026 00:14:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D3B86B00D0; Fri,  3 Jul 2026 00:14:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 510126B00CC
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 00:14:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C14081C77EF
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 04:14:39 +0000 (UTC)
X-FDA: 84946149078.05.B524F98
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id 08FD720004
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 04:14:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jtl1t2fW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783052078;
	b=r4Lt3/0qXAlRWWmHk88zxiOum3gKwbADdVWRA7dK+KU/aRGOyiGZylzZckwQKLb3H42Z4U
	78QTVuhBC063nzTTzNfkxuZq/pPBbdzsvU8w7McxvOHBzZ41rJu0EoK6vGfOb4ZNmBqW5U
	HrWrYUUJAyJSJcUNI8djnrEZ7F70q74=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783052078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rkw49/Ci1tH2YETEaxaeFCz8QbSFkKdO+S6ON/GBGTM=;
	b=PPxWSh8cbnNteiXIC6C6VLwGULpi36j3//fOT2RdNuBBgUoVtFs/WYA/jSNgZRsJBOUHy4
	qD0383bP2NXhd8WIFYvunnMkxjRrJYz79jGg82sR9BWZuypiXRbSOuA2WvwhiPiEdr186Z
	wmfSq3W0ITB8UDqPSRYLvvFqX8h/rCY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jtl1t2fW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-847d1e9db22so145348b3a.2
        for <linux-mm@kvack.org>; Thu, 02 Jul 2026 21:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783052077; x=1783656877; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rkw49/Ci1tH2YETEaxaeFCz8QbSFkKdO+S6ON/GBGTM=;
        b=jtl1t2fWoozVvue2IrtEscwLmfAspQcYhxpsSdqWHQqDyX1kZ+U2jF23EKSbOUFoBa
         jpQQaqsyCj0PU+E4eVegAMO7q02b1/+EngjBOHhoOZu7SshWUjJgtBhezWlUec6Ftk/U
         q50b2UInJA5kv32uFwIHFhLF2DWPyLzqCTUWLfb0TvFAeQSO0cO99dlErfQ7AqNlid6E
         RgpmxhjpoPwv7GAXekR61lr7aZhsoCAFNjQ21Y/1n0pTiPS1vcqgnWQbZuX8lr5WnBO3
         tEL8zzDq2XkeZy4Be56PXeRkuIQw+DaxgHIYF5ljDr54pT3CUm/zNNgnm8xveKxSm/Ga
         6Y4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783052077; x=1783656877;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rkw49/Ci1tH2YETEaxaeFCz8QbSFkKdO+S6ON/GBGTM=;
        b=Bi/ckcskreeh0GvdrAyQs4cxv51EmMdVGMq1qN0w+0IqKul/zz6cWfyKSaiRW3zbBB
         /3IXMTgM1edvWQJ8nFZX8AaCJbadI+du5ebM1ORrfcfZYmS5JrMLIcv1g/cSR3nOmNfX
         vzmbjipA25YmUFcY41WLlOUtxqeVTbaym+kQhoqAVLZy4STx+IZFMkqPyCnBv7ivQARe
         aKH2Ug+FtMTnvHKzx9Qvwlr7dtXEATawmQWaRZkPKPunyXUQZsUnge36+EdtO1navJ+C
         DkmvpMOumEr2E/uuJFYGCmIDqNb2KkEmWY5jPEC9wW2pY0NtevZ9427EeWvZQGa080S4
         P/FA==
X-Gm-Message-State: AOJu0YzXisx6yXgJFtCxNpBvu717OuA/qw9jpOGS6nhuKiXIdaV9oASd
	wC1uqlmWjKC7tUcDEaGRw/zYiiru/Wf/FPSXQEovJWtIVdFdg8gfzkQR
X-Gm-Gg: AfdE7clLp95atBjuJj+XGMgGq671LNgO3fk3889D9/i7R8Gc/z+XHlwc/GaTr0YwAuz
	sqRszvk1Kb3K1IDRsiK7UDJCARu4d2pRyOiQ8fxop1HnEIIKLFOuAI2toVwZTkOA0SIU6zdllZy
	ud9QLv9I/ONQeTxXZn1MjlejCk8LJDuy8CM6KKq/vs0cgY0Jy4f1Gur6Esp8jpgJA+eVVLJN4Xc
	ssLUvb0pztgf1cnK6cNYqsHm9lbkVj6KNw6Up1Qb0rvyHDfw2JS88guIIMqb3mrs4LSMjad3hi1
	kdjsvi6wEhcIUZ793R8gTNYkH3wXeXCqoLbXVKraUtVwPgSawSjdYauZfcUUTaz+7ZWO9LcUiwb
	3h0EsYDAq+AB+EX2YmkGYyKm11BZWYT/jEpcxpkoi4j0DcJ1JMWGtx7ZKBQVJx0dAyhGE6zOIA0
	CdXbxOsZI=
X-Received: by 2002:a05:6a00:aa0a:b0:847:8971:87de with SMTP id d2e1a72fcca58-847c09885f4mr9521873b3a.28.1783052076920;
        Thu, 02 Jul 2026 21:14:36 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847cb94bd7esm2207768b3a.38.2026.07.02.21.14.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 21:14:36 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Andy Lutomirski <luto@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	driver-core@lists.linux.dev,
	Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	linux-kernel@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH v2 8/9] arch_numa: remove redundant node_possible_map assignment
Date: Fri,  3 Jul 2026 13:13:28 +0900
Message-ID: <20260703041329.2797584-9-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260703041329.2797584-1-ekffu200098@gmail.com>
References: <20260703041329.2797584-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 931caakzuebt9859nxtwmzwec5gfgyfj
X-Rspamd-Queue-Id: 08FD720004
X-HE-Tag: 1783052077-938401
X-HE-Meta: U2FsdGVkX19BoNcyu9OHQrX6RugKcRVSxDnKpZyvj0qlRU7DqWrFGh360SK2YOohQFDcFTLdmY9hcu/HzijV44POZuM/OCbpLdyZQ7cSVULb5/Ku1xxBnXt+HUAG1KwGn1tApzAG+I+Nx0aazz7/bfoibqV1y3rDNXXJir/NLp3909iOa3ijugAfnzGah5h3KONWBf63NLRUihFT9/3fQ+7ff1pub1u5sNppgwjKMaa53OgCGB7V/fxFpxmApaC5LiYsGzhrJlVNcT4NrcCzB5o+fFhBzzRmz9jCGzBCw6f0ZHKL7rUJBljWT2eqUMXXYZEfgylDjA27gK5ZCXmsT+myju+FxLrG61M5xLlL0jSM704sLZ6+FlrcvCDekYbBw4XefdLncSSF3/K/aB9bFEF5DPggMhwdLi1pheW5/152ga8v6RBrnjeSxg7Bsv1qldMDto48rsC4a5fRGYGeqKDV+Jm5zsIMIvb/KWiYhNaHtq0WSc3TzF2up6+o2F2Hv6LjaXLV/FeH9PgwsFC6haxsUz08y8Tlv/Kq6LcgXGDck/5Llw6awT+za0I8Cav8CUoYmJbeANdf+N4XhzK1mAsP14tn4rNN0iIrKNBM64rj/81IJZaD5Ur1l7Be1a4WUwgK2ahhT26cFOF9h8mrHcgRCndGDrvlQH6fX1oW2OqDNB2sXKLsAYm3Raf3s9WVCW4rZfIMxRs0fIv8Mmgc7qIDdtFrb7KHAmSFk4vlc5cq9nwUIruMopxEa6VBeXDRlC6ojS9AEqQ9czXj6Nmp4mD4UAniOkHcWLdqLPDU6EgyNM473vaj8LC4+NIt0AUQ8jTXp3cAi7acXfK9f1MFaeznnP+AJALDnVRBXfvRpdQlo5ZpeOmmSUsyKGWHRZZcIn3D6t9/JcnNeX8y1/MTAdUwrVXMhRbU4UXEqm5yFl3TEijmzYHkD30c3zAvlTNtq2KzOQvPDUMP4ue4DYq
 ybZzfxTK
 v8Zr7wO62h/leSF3Ywsijvbq0OzMds5E5IMMGEYghwMcwhuVbZGKlOjvJ60pB3aUvzUotdKkaEqmJ7UIsJXM0l+0xv6kHCOmREA5RSVSdwNGzN7Bziryl6P6l5YRM7x64piHBFjl/4QxK6BG6usUao0/uU2VT1+yl5LKyrrvJsHjXN4bruN7eCrSptrO3/Q+b4X0g5L/fzBdLXfRwLTmcK7aWGqQJFsc6ISyvlvQTo+qazhn679WNrlwiDjVlZqqh9MTY2UpgAutcxHuxygcO1LxZS5kRxjuNm0Kr7YfSeM0JQ/1lyNmEg8lZqIU+BGW1b31M/jSRLlQesjBtB+i1XD/ilIOJkEbEPj7jmKF7wYtd+YIhhiU0KzNYXZoL+GViAWcBlUWPjUZ6YpcT9n8j6WbeLWPBZRuAixq1JrZ2u7KJu+KSAf55IK1BUk9EmT/SbCJpOll8U5nCFD8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

numa_register_meminfo() sets node_possible_map to numa_nodes_parsed.  The
later assignment in numa_register_nodes() is therefore redundant, so remove
it.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 drivers/base/arch_numa.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/base/arch_numa.c b/drivers/base/arch_numa.c
index c7f63c4cf367..6476227b772c 100644
--- a/drivers/base/arch_numa.c
+++ b/drivers/base/arch_numa.c
@@ -221,9 +221,6 @@ static int __init numa_register_nodes(void)
 		node_set_online(nid);
 	}
 
-	/* Setup online nodes to actual nodes*/
-	node_possible_map = numa_nodes_parsed;
-
 	return 0;
 }
 
-- 
2.43.0


