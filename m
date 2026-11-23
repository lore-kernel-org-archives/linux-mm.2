Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EE70606A33A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 14:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lwRxR/zw
Received: by kanga.kvack.org (Postfix)
	id BABC06B05D6; Mon, 23 Nov 2026 09:20:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B839D6B05D7; Mon, 23 Nov 2026 09:20:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC0E96B05D8; Mon, 23 Nov 2026 09:20:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C2186B05D6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:20:17 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1E7731608CC
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:20:17 +0000 (UTC)
X-FDA: 85466593674.16.E016B98
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id 640FC160011
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:20:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="lwRxR/zw";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795443615;
	b=kFtz/e92wdTeR8WnSFNdsQZekdOh87rgvUs5aLcQWbH+TOyBW+5iQcqa32ltmdQgsqHFgf
	ocQ+soAJACTOBNZYc6F5z7Rh0zz4l6//fw2mYZcBF3eb+2T7nmhr3+ABzrU7X35m49+09E
	6t9KPDCSMuLKu1ZLsJh+sR8AZDL+YiA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795443615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mXV6+GG0z8PCuL6UAZBUPBZ1GbikKdS6r0oEptKGfNs=;
	b=ABwjpX84/s1DxvU1PMhc4INLf/axpvzMUvgqM69uRhkiV5NWNlXWaqLBK7wO7wNX7JecvH
	2VMvcBqXI5mLGljAn7+nXV3SemFmOGubHkgJF9uYf/LXSnHVAYtrD0cT+788yDXEr3Y2Gz
	WkQzgzXBqvZSVp274fn1BFdDJMH3iw8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="lwRxR/zw";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-385d8a00598so4608572eec.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:20:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795443614; x=1796048414; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mXV6+GG0z8PCuL6UAZBUPBZ1GbikKdS6r0oEptKGfNs=;
        b=lwRxR/zw1wjkSktTs0q8kbCdliv64d0xs5oK8gAEdNoh2OWMjvp4x97zKkH+I+u24y
         lQBFZwcC53rCbThfr0VPz8i5meSlZGVxmF8/b7i0LqPCEPOZZoyb3OrybKYGWpk99+A5
         Bk6PNI/YWin8fH1Q5gBcficc4akRqlsyNVHro2gIR/mbQCCZbDFxYgfrknG/XJHC8u4v
         hEDdajfVlYUaal1xjsd+q/698CXPvEP4gOxsDa+a2SHlc1Zs9ZFNE4QOJSPFnTyQ1xo7
         awujC6R+CNW8Z1F77zO1ynet8xWnBn4f9bzOuMgKN5GVkAe+kXnWov0CaTQAKB2yElwR
         AG0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795443614; x=1796048414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mXV6+GG0z8PCuL6UAZBUPBZ1GbikKdS6r0oEptKGfNs=;
        b=XAIv/e+pWS0IokdyF1pLPbvjURgMhBwnkce+xR+wkiBlj0u19xwvKoUBTnLykhhBSB
         IijpS+hoyZYq5/M7F88KF6qsQ+hAfJLuPkKE5tS8QgLErf1DpVsRehazGUSuiHM1tBa5
         R+C3Y6pqngxAbn7o8v/goU7mcuZ19mOp2KzilpprxczUvOgSDfwYKsYRu++bi/wu1I1H
         U0Bh+SzWKycaKXGPrwwibkPoqfONTRmOSRawhHLpjWA77HhBNgAw19X06tV3N+L7bVYz
         LJpIcsGJgQjK/TlxKYbCf2u4HOsVGw0CZ9p0g6xFnGjRUsJplyjaWy3ZpDxvMtHh6Lda
         tksA==
X-Gm-Message-State: APuU4Z+OpCXR0aRTjFx5LdZ7jzG/HQItwi9EDgqLUel61JvNTBRcMIqr
	k3fwPIry9zdDT4IpOInOaGwu2iIPGapJGzriG5GMtJgXsLg5B7puaYVq7Fiqge4i
X-Gm-Gg: AZFdTZdJE3GRFSoU09+MZ97Kiv2quNfIIUWBf8ftnt2kq9Cy0TgSZE6WOha6Ykf45Hf
	xS/rkj0TNuFDBOWvfh0JjijEveIvuwhlb/TQHeZ6woELE92mp1PpB304gRoAIxToEy1stP+/H8L
	ql83Rz6sa2MPz+cK/9tvJTCCeC9aTIVInF9gFIN8qR/zzdm1tX3AxV0QOajCCmdyl7MMLuvTR5h
	qq8hyiUD50GVsbKn0PQ/uymg2IMHalnXz4p3EA/ZAseOKAwR+58AXFWPV/v4WOThdQ/qaGAYNko
	VJjwGxsTbKtGmYGt7xdCWgofeAkNfPoymVU5Ma2SJqjds/7rrnmluG/F6ymqdIwVuj+ev3PKdbu
	mGf54JDK+XJx+4QopI4OpIAqPiTUAWnJBmfXofWRlH21SUnvGmLtOfpnTzBONhcPOq5lA9L6tBl
	qkXL8MxlujzeLwGTeSHtAKVAwMblnbXMeXB0V/mfg6Ay4YQHIzfQE+XAXGri0xF3y1aNkxl16om
	3QCyubBxJpdEXdui738IYBgcTeug35YoNAmYrcOeF7bnSqWEnYoV9ovhy8yZbSFm83+AANWxhIy
	zEGFB0ZTxRUzUQNojWiTmBl82Lv+cV9a8D0624PZl0NEvuSOjbwdnAg2qGYV8fTJTYHX
X-Received: by 2002:a05:7300:8282:b0:385:af7b:d788 with SMTP id 5a478bee46e88-385af7bda3emr10643390eec.2.1795443614142;
        Mon, 23 Nov 2026 06:20:14 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38577214c2dsm35579857eec.17.2026.11.23.06.20.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 06:20:13 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH v5 18/19] mm/swap: skip reader rotation for single-device priority rings
Date: Mon, 23 Nov 2026 22:19:59 +0800
Message-ID: <e2a77e8a6c81c5cf56694b18f8e27b038055ddd4.1795439990.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1795439990.git.lianux.mm@gmail.com>
References: <cover.1795439990.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 640FC160011
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: kiarai9y98oboexqmeejrbzqd56dpe3k
X-HE-Tag: 1795443615-161009
X-HE-Meta: U2FsdGVkX1841/X6OO/Br/rWoG5gInvgRF4ZRmsQdWMI/duddkOMp/X+xtfRzw7r8XSq9s8Fhu2mARCNGQ0wrPHJOzVR9OUmT8sYACOGtfur7nbKD1n8eOeTFY2nlYgYeok30FGSObC5X4t29WFb1RPvWvU7NjGuXaBsjDHxeWF4vrDTkrSf2tFdxsOPVWgtkuFwsYhVLDfl4qI93wmkIbhR9N0gMmGr5+lS3MDOjZtXSMieWg6dMvgoo9QUDFAdEbA0y3VE8NOOeoVuL60EhMKZ9NSdE2ggGmeexBThx6Ux0uVVMOfoaCZBqTUBgdQiZ0Sr3VVkhLgpu1mYZB6IvB5aRlUBM3eaNqYV0r3bI+nCKV5e+hIWXCjsDPc+G9iyvkKWqIrZN7Q0bmBs0aVax/h2p+8v9y3aIwqLHVErJKlt7f8gY/vg08WRCpNlL8BfJGOm47g8KP0ymR1UThUG+6jy5l2rWwQOooSL4xB7cmnLHlGrtp/7EntvaSKuE1fgyyPxRsiq4OAhDxn/vntrH1HqXgj0bJyZu0PF4buk6IBx5yKNLh92mNW04E4/DdVWoIRPch3Y2b1LR90ifk18wNfiz4fNkywGjEJmARN2BuFzGV6RhczdJp9WtPoEMU1BIl7YEeB3yRjGOfdxcs5TAajD6Vqp7OpBeKvHKciIvG77rhJMY7MCU9sja4A1jNytZ2SLVRIlipYxmW/G8dbPDRBvFiUG03ZajGbiSBSa+r8znYUNSXKXu+Hb+Wa5U2h/rxkf5az+vv0eBIBtf9AkHioE5rQ5hpXqSCWf8khSW0ZpXEmBvMo5wIoNGuh2iYap3HrPvAwaqn7NJgFu4D7LNh6OjdfVBXiYKgqZam3VO/SExuo1AN07jLFpyEdcTB/T3zI6xitRuDz6DmK3CKN1aN360ACSizbnsLPWtfXPpzgn4z/OoYbdZpErHiSGhusaFTjSALZn2BNNZb4pGex
 QqJEGclK
 M9zfme9JLbQELbJEbtEK3SGyGuMYYFAzPid7yn21LIbNAbe4chrzEau25lmiijcj2WH9HKCDlf/lMyEpY2lRvVJpyCTIbClrVgr1MrV5JdQxFRNMSy1v62sRYjI2sWh7EhT9v+bXtkq1nzIO9y0re86DjBTArpkvDBqFOx5v4IW3UanDisYyotLLKNo6dwfvXsayipIohjb/LpKoyzq4NuYZoA3vkoIZt3ik9o/vxp6qOEH+okcSyKRjr8ThFd1ilMzm883voikJfWKpZKC0IuvKVKyOyB5EKSRWeo+d9Kpf+BsUZ3a6Fur2iNP0u6+SLvh/gM4kAbYKoPnXAX4KOOvGmX8L2xfHkp0vAjj90ejt/QFisc6d8MbX0DPeiY4deRV2u/j8zsn2+v0xrwNn/XhK30lyDXCoBAPL6W0muomDX4FrRXFzkRTWk6vvQbizIHGx3hALcGJU+AtukgjUGW2EJGjh+7BZQdZBrYKbs+fi5575KuU35T4ErXWsOO3ylt/Y9SKYM0CYC7Od+NY4RjKKL0xv0pSceMXt1tY6l7iw6lJc7eOJvm/nDm6woPNx7ULpi4oYPQfoqTAWKLxVHKC0qmmxeXnkZ2oTe2XoQTYWHmsmEefgpTllT43a5zPJuTQ19XGwK1vSkRka3jgY9+Xy/4mM81ogFHbJj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A priority ring with one device cannot benefit from rotating its starting
offset or maintaining a quota. Read its only entry directly while the
caller continues to hold the topology read lock and migration protection.

Consume the cursor attempt and check the full/disabled pointer tag through
the common path. A masked singleton therefore terminates or falls through
with the same bounded behavior as a multi-device ring. Keep the existing
large-folio same-priority failure boundary.

This removes reader-local state updates for the common single-device case
without bypassing device lifetime or availability checks.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/swapfile.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 5a8663e9f954..91de93043500 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -333,6 +333,11 @@ swap_queue_get_device(long nr_alloc, struct swap_queue_cursor *cursor)
 
 	/* Consume masked peers too, so every walk remains bounded. */
 	nr_iter = cursor->nr_iter++;
+	if (ring->size == 1) {
+		si = READ_ONCE(ring->dev[0]);
+		goto check_device;
+	}
+
 	local_lock(&swap_queue_readers->lock);
 	head = this_cpu_ptr(&swap_queue_readers->heads[queue_idx]);
 	/*
@@ -361,6 +366,7 @@ swap_queue_get_device(long nr_alloc, struct swap_queue_cursor *cursor)
 	si = READ_ONCE(ring->dev[dev_idx]);
 	local_unlock(&swap_queue_readers->lock);
 
+check_device:
 	if (swap_device_masked(si))
 		return ERR_PTR(-EBUSY);
 

