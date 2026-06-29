Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A478CC43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 16:38:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99F6D6B011C; Mon, 29 Jun 2026 12:38:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 976C76B011E; Mon, 29 Jun 2026 12:38:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B3EF6B011F; Mon, 29 Jun 2026 12:38:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B7EF6B011C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:38:07 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 02C081A0187
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:38:06 +0000 (UTC)
X-FDA: 84933507414.27.BBF223B
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3D0154000B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:38:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DBpFIUkk;
	spf=pass (imf17.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782751085;
	b=bJVKqKoFTTtsYfpteaWflngmCJU6BqhisK7me72Hc2ZgjSQmWKQpWiQ42th84UVU0cAX22
	vDmYKS1G+Ts7Zq6XkBAnvJ06/fJEu1xvjt967ZL/oTV08W3CNplUOKqQNKHHy1k9YP3ZSG
	3wLrJ0uHkGUCzr0ns0kcEJdW1eCv7/s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782751085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xo8uO5n6psQwUEUWovccxe/ZWX+n25l9kiG0x3jxhi4=;
	b=is/XOekTlx04VSp27Wzh3yAuRe7xx4rV/M4rT/Xa348UKSsZwkvOuxmh+ikNAQmByNQgCx
	ddfCHDZtOEe1wha8AOdpABPNlyPj75rySSrX303ZtbpSHHK0H+n/QDmLS+Pk93u9s5tX9C
	CiqVy+g5Z5sMsCEFFDm9Q2u/H/kqY0M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DBpFIUkk;
	spf=pass (imf17.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-842338c18e0so2474579b3a.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782751084; x=1783355884; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xo8uO5n6psQwUEUWovccxe/ZWX+n25l9kiG0x3jxhi4=;
        b=DBpFIUkkc4OieCQ1EdDf7elYynzEvYRsMnpahxTb9KD3vnAm0IndA2kQH/ZZN3IAyp
         K2v5lp5jmT6EdfKkjx60AkyWwPTcJwDE6b3SkIwlkVBLIu3PtMQkwn8s5JrgH5msfqaU
         k0RFAQTZhjMJqTYl4RvoliVK9GJnJg4NZQ5lnfyvhrdWvdSungKfsMAOHnXANB4/ZN7u
         H3i2dg4PflLJPQ+FmBTcjc5BCW+1rIub424kQZMilBLStFwFYoJaR95WFC8yHVhld/pf
         /EiMmJ5ztASY1luJTnSfyGl+b9umWTOk4XPKiCI154nQvVoJyPdXFBaecMmuWg5t9QrD
         nC8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782751084; x=1783355884;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Xo8uO5n6psQwUEUWovccxe/ZWX+n25l9kiG0x3jxhi4=;
        b=hQOP3Qj6DgISB4nWksULOpXM8NlyFjhMxF+dibZqq/GVyTjvo45EMF3a+G6pbu5DD/
         TJfSaG52H7tGoZvWYxIhB6H6Ve9K5TxcJCE5X2pQtpaDRk5V82zVSlorPgrSZcuheoJz
         uCciWy3RlKFatv3QDfVhePbsqShgPuoL0HewPLHGFcn4G1GpJJjFvO49BWHxNu+aMQ/Q
         GRhZijTxW0JAfFnwrN+++clZOkbsDtntzRJAMYOgotO1VOVOOVtqmgzWlHrM1DJDWSCS
         DiO+CLt7dHyaf+XSyHRtdftDkRHH/to61avnbo6jZIcPxLLA8gIjW2gdmsHSoN9n/kzc
         Je8w==
X-Gm-Message-State: AOJu0Yytyl8E/Ca/RRklkKNVW8ud26WcKdMkirh7nIC9kiYCoXSwcjI0
	0wSABrGBoyovwZoNRaSw48dkc2K7IN/jJ5g1RJ5igGcV4vQbQ2O2UG7l
X-Gm-Gg: AfdE7ckHqiL0LescCtdzjAH4GlDR61ddrunxYdjSRoSzRE5l2cReSQrApeSz8n9qKE4
	gtFDfQjJgXrtQI5Z1Y7g/NxeUAU8ZqplN0bHgDdjar0GHTIS/3TVJhobMtxc3VfiErAI1bNuFYI
	A+oKyGcwYIkkpxvVxm8cTETm2sOGfKdt9dXJzesli1S971zd//1C7XmJMGAYskP55a4NfTyly+s
	jNWkzhVDRdYpuIW/pQ6ECBPiEsbaX0MpmoNXMOpiyHsXzKWfwr4KpgnERsKImbQJuPXmFmYSH0J
	l2YhIy7Cni8JnpW9KAkYVM1i87End+WCiHipEC+9wqQ5aGZGe0yGjELUa28joerxV8R9Fedbx5D
	ta/XduxOkxSGviaEMiSnjnNI5bpTqEMWM7zNAC0wDW1tL3N7zO7NstNUt03UeKbmo1fnpOtCmGq
	u2WLfD7BQ=
X-Received: by 2002:a05:6a00:17a6:b0:845:36a0:9eb2 with SMTP id d2e1a72fcca58-8479f236947mr209923b3a.34.1782751083985;
        Mon, 29 Jun 2026 09:38:03 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847a02d41c0sm18474b3a.33.2026.06.29.09.38.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 09:38:03 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	WANG Xuerui <kernel@xen0n.name>
Subject: [PATCH v2 2/8] LoongArch: remove unreachable invalid range check in kasan_init()
Date: Tue, 30 Jun 2026 01:37:30 +0900
Message-ID: <20260629163736.1606688-3-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260629163736.1606688-1-ekffu200098@gmail.com>
References: <20260629163736.1606688-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 11xpabmkczhxdwg1ud5kwewotig8bono
X-Rspamd-Queue-Id: 3D0154000B
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782751085-478248
X-HE-Meta: U2FsdGVkX1+X4wUYEW6AwzghdaNPO1KMSQWkJtjjc0moOg+q8lnq+IGwj2oy1meaXZiCoNhN96oYKwS4VOuiPnR5ccsi56nbfQXzEdJuZF3xe/p/ajcS4sLomsmm/mp0phniuCNO2yxbIeYpxIk5Qexzdv7a15h2rQ0xfsN1uO46eTDSGrxIyBsggwzlxQMnP9OWDiekU9rN+M2WzMmwGvtFPmIYiAl0zDaoeZbumZjVGMW6vdS1F2NtR6lT28K9qD0h7Iqmr28B5gIEazI5DdAOyNdkTVbEwegZVV8LfwazHVjALjuqUJ1QqbXF+GnO9RV/6OQFkHTuaUf9sE0fsetHGdDs2a867rUtsZSLVP5S2dQCm28IGazvJz3aa7YyM0mDNQjMck87vAEXGyUMmURNZEu8OLR9fkvhvMOEC8Y9U3sZX9lse+CleZkhphu5sCxZO6GTtNx+lKAwSUbOCXJqV3xmPvlEC8KvcWR90X/g5L2YTvp0ndkYX72x6oEYQ3Actz94YYtg3mvWgQG2hYaQxo7zPgw4OzL0VguURIBAjGkxpKWuyoLmw1QwnKQzu5eO/xS2M1/ZMV//wXP5gDwH5SeJepI0G7CLTqjTcB/DKNj4CviUX9bDp5MCPq0p48cJENXVASaFgBapy5go4lmxH+2aFHfBCY7ldmYut8sREf1vyMYVlP/mW44vNxxwI7DRqWFSMcO05l2Yn3LH1P9CBvEy7fA4rYy/YLHTts9Yd0VSdTtgxJzXEVCyNTxJz7Z9+4apW/lBenBR4I2LIzo0uMdsMwbGvoqZMaDLZwsJpFY9RC5AwVRrcFAH8twcYBckGQDjai4uYqP9zuS+RszRGKb/oiuxhGySNrZ2ruw46WFLBifZFaKxZoMNIlm1e/fAByJqmKAu/1ueaFKbZiYjfk6sBW3RR6OhOxQcPngYeuBVLV+7Zq2NiQ1QOYnjsckKAsOOmf/9iSHbgSB
 IcXB1aqc
 /65Dfi+1OO3BJODGVhE7UrsOCj18E4O1faUX162k+kU87mQTYGA0RULDq+/qdoBTO/4iYL6W8V10wPw35R3eSwvGZ034ldChbMpqmmkQg/grEMAXXWOahb42YpdTxzPT075KZQ2e3sjUYkPH7z2jSG1xekPGoOXLCv60xH0ymQMOkv0MVSKjcWsqXIiRuhJ+o9uy6eZbo3v4iC1EvRTnITjbfTQJY3rjewJdGaolKpxGfpJGeRrtI/gvxlafD3XqFp1xOpJBZWvskFjC5aZCcQPvd30r9bR5n+T+c+bAcwAolu47qwCoZu89EpDgLVqYHnJR7/X0FrXQAnV6OOQfpNDSoQFM5fZbjdAELZMWnBCCbmYwSKnsVq8Lsz6cKopaH/SVBhscPh/5Vf3Hrvt/1sPXNL+EZw/fv/2ubdJJXIlQOVsRVatk4qjs7+e+GNQ9PDq4cifyHbmPbMsTNthvivnorALTenoQN4NBI3tYoXMOb+owHyTkojR5/FuqkvwdrEyPNwwLJehVVn/3R3GKpPNQEq7PmyoQqibTDQrYtdJ2VBCZWK4ZJpZ6EEMTaIZ2Pgpze
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kasan_init() populates the linear mapping shadow with for_each_mem_range()
and breaks the loop when start >= end. for_each_mem_range() never returns
an invalid range, so start < end always.

Therefore the start >= end check is unreachable, so remove it.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
---
 arch/loongarch/mm/kasan_init.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/loongarch/mm/kasan_init.c b/arch/loongarch/mm/kasan_init.c
index 0fc02ca06457..92ca0ba86406 100644
--- a/arch/loongarch/mm/kasan_init.c
+++ b/arch/loongarch/mm/kasan_init.c
@@ -305,9 +305,6 @@ void __init kasan_init(void)
 		void *start = (void *)phys_to_virt(pa_start);
 		void *end   = (void *)phys_to_virt(pa_end);
 
-		if (start >= end)
-			break;
-
 		kasan_map_populate((unsigned long)mem_to_shadow(start),
 			(unsigned long)mem_to_shadow(end), NUMA_NO_NODE);
 	}
-- 
2.43.0


