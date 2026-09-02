Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 517C1C624D6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 10:51:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6BFF6B0096; Wed,  2 Sep 2026 06:51:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA76C6B0099; Wed,  2 Sep 2026 06:51:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A70B66B009B; Wed,  2 Sep 2026 06:51:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 81AE76B0096
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:51:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0A2448015E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:51:16 +0000 (UTC)
X-FDA: 85168505352.15.319963A
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	by imf06.hostedemail.com (Postfix) with ESMTP id 55182180004
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:51:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SJ06Q6Fz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3oP-XagoKCFsO6HGG78HKM9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--vdonnefort.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=3oP-XagoKCFsO6HGG78HKM9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--vdonnefort.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788346274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0x2qbND6Sa3WNSOYkn6lqr5Ld4Ihzkg79AVpCRYTR1A=;
	b=JYu7mrgUlWp/+x109DL5WT2gHJf/BfKH7pmyWpy63p45QvV+SljS5HIe4MvrE2LQJEi+1h
	nxkdWA2oSB+2up8qNaiOJfYP+EAVMVZzgGUGMBPRvY5kR5TvbhhKzGDaHWaAeUBFm2fLVX
	IVsqj9lZVOwkhPTVa18RQcPCFXN6m58=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SJ06Q6Fz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3oP-XagoKCFsO6HGG78HKM9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--vdonnefort.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=3oP-XagoKCFsO6HGG78HKM9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--vdonnefort.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788346274;
	b=2QNr6+PE05wviGdtnrmO70a1ux8E+gBE5vMlelCN+b04RNB0zYqiC+LJ3NBb+KUeywviw7
	ukmOb+6YOklEFrDf1lamar0yzIDYShDh1mp4ohzVKEkyquShBPrrLypMkAOxIKVzJ1oafk
	hTiqHgQNfWJWssf6Qxq2ZRrOLQO5ieQ=
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6a60a4f1ae2so1177590a12.2
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 03:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788346273; x=1788951073; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0x2qbND6Sa3WNSOYkn6lqr5Ld4Ihzkg79AVpCRYTR1A=;
        b=SJ06Q6Fz/2u4R14J2XOx25azDmS21kB3LTuTz9mUtQM3ssZWPsagE+4l5VzmnTB66d
         jsgXW/6oxe/yX/V9rvJWZ3GL6IxfuLtSalpyJcWwafjqNkaqyv4TRU42kTTHvCnKjgY/
         PDyxejZ+82xKqmkmoG5F0xD9E6tjOICNx6e0MoGHG4p4m4xxoMiTazH31P6XqKagZ3So
         5LKP8JZ/FOH2jh1rjDjTUnFGo6fksE5Vq8HQ30+JfDRUYxLYkvmqS47c0TNkDm90NFvp
         yuXyXd2vN6J1MTA/J/bB6I4AfjBYGsgK7MkaHNcFcjCdi3dGzqC2m0695DNekv+8YSlY
         7GTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788346273; x=1788951073;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0x2qbND6Sa3WNSOYkn6lqr5Ld4Ihzkg79AVpCRYTR1A=;
        b=WaWgsmsjgycG3sYUK8gA9gBGKjxOFjuVpS6usv5QVMepOthFyMvguiTIgnEr4F+AQp
         aFjUWliPYvHYzGRW54Z+g4WKUefg27C+RpMUqMWUV6qncdxquwdTdq7LQq8Xh0WTAWCf
         hkA8D+xv7Z3SJse6nhUX90ckEiSAjJeNtIq9hDlz8tB1Jqx4wgx7VBFqN4TdTCVYu48x
         KrooyNuTxZtFW9rt83tvx4OTr+AC0eVgCRkrRI5gZ9h/fjBg4MWEBeMRnRsW8OjEsxbc
         wmUxUda0pEQQr60FAXvWp4HwRpL4d8guq3Ezs0J1LFGWBv4HzjnC/7zKGxHWIuu8s7ym
         ckHA==
X-Forwarded-Encrypted: i=1; AKwUvBzH12KcKbKD9q5SwUSMq5s9tLRMBw7M9ApitqDfvP8iCMjkk1BMtjQVQ6eGDkude1B4OiNkdMK3aA==@kvack.org
X-Gm-Message-State: AFuF++nnzmqDwZia8GjrAVgfI58j3N10EbJcRjAX/MXAbXs/quMOhcKU
	Oq0WmqUaVY8gt7yeDAJjcOo7Jrbo7cXd9WEWav4cSg7Cu1wRz7dsyVB4XFmYaL1k7Ko5LD+SMLk
	MDCbbxOIVeb8EYomvW1bbCw==
X-Received: from edyf4.prod.google.com ([2002:a05:6402:684:b0:6a5:e070:f1f6])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:46c5:b0:6a3:f47c:969 with SMTP id 4fb4d7f45d1cf-6a68224ce3emr2605259a12.3.1788346272605;
 Wed, 02 Sep 2026 03:51:12 -0700 (PDT)
Date: Wed,  2 Sep 2026 11:47:07 +0100
In-Reply-To: <20260902104712.2399797-1-vdonnefort@google.com>
Mime-Version: 1.0
References: <20260902104712.2399797-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.970.g62bdec98f9-goog
Message-ID: <20260902104712.2399797-6-vdonnefort@google.com>
Subject: [PATCH v9 05/10] arm64: can_set_direct_map() if BBML3
From: Vincent Donnefort <vdonnefort@google.com>
To: catalin.marinas@arm.com, will@kernel.org, rppt@kernel.org, 
	akpm@linux-foundation.org, sudeep.holla@kernel.org, jenswi@kernel.org, 
	robh@kernel.org
Cc: mark.rutland@arm.com, sumit.garg@kernel.org, ardb@kernel.org, 
	thierry.reding@kernel.org, david@kernel.org, danielmentz@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	op-tee@lists.trustedfirmware.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 55182180004
X-Stat-Signature: ctctf6eromfgztf98bmbe5f4deg5y3rm
X-Rspam-User: 
X-HE-Tag: 1788346274-447073
X-HE-Meta: U2FsdGVkX19j4tNW+vjK2/7dnw4oX9KCBK3uoG5t8Sj6TLSq9weys7wMPjP8SuJWDyXKzKHEpJHHUeevuM60ZZFakq9AZi0NI3FLVKAlb1Ysccbydw0CKXRQ/aBh4byVijFirp45+YDopy3g2zkdJS3vuCCgbUoRbO6IZC9kpRwdBMhMdPGYzPp65b0bvdd8tAlVa5c1KdTxIrUQk5FDTMyKMUUGrHNAljVHtGDCrfkYQOKN0dFbGUg0DyZTfuNBdKfB78UaGWTwJmljNvKJDm2XyfMcBtn9McEDgBFwL12PQcskOAXUFC+BTKhV16gwKvOzY8OSkLTsh+zLcQ0FactxImTFzeuXTS63YUl4tOKcFTRpjAVUVPBgF6MJIcZsBiHhZgr1nYZVciB5AhT/8EbSBC0mN1TglH790CANY21PgRuDAieFGurU7BHbXLH61kzYv2XeyOUrpLL8w2Q77HWngQFDyXedP111SNCka7sN8HhSufP4rxNuhYK5fuKOs8LNYxP9mOQGrABb+2hOutPLqAUfvc/gf2oz0iLQk4XkFwEE/3Rl0VJ+sV9cH2utDFtzvMNKpo5QkZbWDR85pNqwoKrjRwcZUe2Y9SwympxIwOp7mxKxs64b5nwiTW+IpUs/nsDLj+1fE+grLpZ77d2dwCdd3tY6KAdUY7l79uXrNT2m7/BMAeruGsOn5+80VZ+DnVhk8c5qPmx63alndKgpgys1AyWlUP0HiFiDnOMD2ZUSTacmVMwe1XactlfKh8KYiy8rBBj6HTIRM1Ffbi0KtC3SwMC2bjkHvOabKRdBRddorw5k0VJ6m/OJabxGsnn0vY++1lTfDjvi6UlWiwE0/LslSlWKm0zLKKy9r4aguSt+sm9qL/NAiJ0eKcTKOStrMTodZtrL9CP9xZMcEXr6EoFlOJsjPLlQupy8/NHADloLtFjFtCBQIrAGcGVYGfzoXpGK3VXQ4YLSnXP
 TlZtzrI6
 Jv8w2be8P+6Qik2HoA6YOixgLOSrEHpRbUkD4lDLO9Jt4jrbpkjVcXb1iQ6C0HSAyJzE7Yx1pteaZmbd5fOzlDkl33Ek6uiVsOSWSQinsutKxvWU93658g8z4zCuSyojOw5dWasdgFWUa/wtqQ36fxSAAiiw3/EzHsWJw5VrLthuieUx/gd3XDGCeE71gLRX7vOke6bctQ1aTLFOHnMDaAU81jeZrVhEFGEdTHw9MNUyvWib0NpGNx5V87xL0mKfExwa6heHnDfmk9bMlAa2va+QWFj89j4wf7qaPaTTzphrXsJ2c2bYdlF6B7FOX+QTQGj0gzVrMTBCDm0WxYuxC5rAgFgsCW3LsLgXxTGffv8ksvMPks4zuaVrDrrhHdVUourIr+tX6WJA9OBFV7wkFLc6aOVByc9aV0yueBDAjLEIwn7J4fz5rwZfskVSy9z0Hx0GKDG60cN0/6yco1qNeT68LWk44I7K+Pap7rZ/Pnt82SUX7AGvHf0sam9UJ/U2Rzum8FSTZepm6sF6Nn93PjQcLFdHZBW9EhBsIyFfonWBZNVDuBrPtJsWGy7hCIGKUrOvSTY0boOseTWZoFL7X2FIsEbMc2+uzjekj7E+do3gtMFHZkVd3j+x176x22NKGEwXUm/7QiaRW2LHL3UMFYvOXAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Systems supporting BBML3 can split blocks without risking unhandled
page-faults. It is therefore safe for them to set the direct map
unconditionally.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index bbe98ac9ad8c..58898ae53f5d 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -99,7 +99,8 @@ bool can_set_direct_map(void)
 	 * Realms need to make pages shared/protected at page granularity.
 	 */
 	return rodata_full || debug_pagealloc_enabled() ||
-		arm64_kfence_can_set_direct_map() || is_realm_world();
+		arm64_kfence_can_set_direct_map() || is_realm_world() ||
+		system_supports_bbml3();
 }
 
 static int update_range_prot(unsigned long start, unsigned long size,
-- 
2.55.0.970.g62bdec98f9-goog


