Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC341C43327
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 13:02:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 994396B00AE; Tue, 30 Jun 2026 09:02:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96C9F6B00AF; Tue, 30 Jun 2026 09:02:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 884056B00B0; Tue, 30 Jun 2026 09:02:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 582D16B00AE
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:02:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B6BB5404F3
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:02:17 +0000 (UTC)
X-FDA: 84936592314.10.19D4C9A
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	by imf21.hostedemail.com (Postfix) with ESMTP id E0D0C1C0019
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:02:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gkxhg3lO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of igorpetindev@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=igorpetindev@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782824535;
	b=EpFcIGovoO49EYR/zKkcomQDbJ1VxAHkf+gRCeiGrghtN9FL0hvn+mAxeJwtMAvd9hBBPI
	2d61tJsrIdvTs4Mhwy/O/ybUM9VPw0OCCja6M09xZbrIwpEDmE+6ZKFQ2VFREg9iGS2cKF
	2YObTipte3IBYjPpl0Fa/GtOonuZP7U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782824535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zu2l5AZ4IXQ/v54+K4OjIVD1i6C2Ms36Ij+X87CAB6o=;
	b=2AwMnSusBFYQl5Q/IvXbC1usv6f48lfYz7WFmtVfRw7MTl0/+lIGmp8Me3NBJsdD4nE0JN
	LBy7SXLrw5fKN+IBnL3KlsXgA40uqMsLLhzu3+aJNflPDq86RSi/cqtpMiWvv5rmiAcr5c
	aVYBmzdBCI3luBSESkswMNGSkwTL34w=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gkxhg3lO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of igorpetindev@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=igorpetindev@gmail.com
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-39b217f54daso6821921fa.0
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782824533; x=1783429333; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zu2l5AZ4IXQ/v54+K4OjIVD1i6C2Ms36Ij+X87CAB6o=;
        b=gkxhg3lOkAXe3s++I9uT0JXHi7B3IwR7NAQIZL69nIq5ZKHuGsIqmjJ2Oepv3ho6ZZ
         k+2Mciygzv1DU2ebg30BvGmPBNbmlTeXixjAvzfdPdO4Xp91S6VOiLs99jNvP56MvlgL
         8ZodEy1V6tL89K9BYTVDN3ChnQFsmPZpUtFVYyT4qV1uadZmB3KoI8sUSSPZG3xK5ACW
         34JAaIruCpG556VGN3oz43lL4AF7hXcDyefB9KZXdG8hNSud9xHb6wuuR/v9tbtn3sWL
         AMQ80PAOCfQNDLymgNWHiYfS60EONbNu4MAchAurxNmP5unygaojZc25h6w1tJQTbKvP
         8qyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782824533; x=1783429333;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zu2l5AZ4IXQ/v54+K4OjIVD1i6C2Ms36Ij+X87CAB6o=;
        b=RdPUc/0q5ReUwujXfxorT2LfQlMw46h2rKVWeBvexWdSyq30RjzcwLqY64bqRJAFGr
         MPsZxcIV4iJsqeopfouad7v8wm/AxyGJSeLpf6WoPgE00KCEFIt21U5UOFL9qKhpd3zr
         rwnSF8kt785Yij4eah8bM3OmfBH3LSJyK+XtNEVpHSPwGZ/c3YFUA9XHiJhLBrqJkZ9d
         Z5PkUomkYaFhZoyHgfLCqZe/Ov2vLC7fUfrvoHe/5mYdK935AStJFjD9yj3vl5f465my
         Lc7wkMWsoqnnGPwhy/fMG9SFOb3W2hz0lkhYxJZjB0FbvMUJgNe03ovfB1qvNvaEJotk
         WJig==
X-Forwarded-Encrypted: i=1; AHgh+Rp4pzF0mH9AJSBb8gjTrmPNkSMMP0RMY/uR0jC7aTLrxHSOMfUxc5t/MxmkYjsOycjXnrXlu5HPHA==@kvack.org
X-Gm-Message-State: AOJu0YyCQzjnDp5Pi0MHUy5d6Q4fiyFX2wMVR++tVx4ZxH/dAVfw5//m
	8sal1ihhNJqlcODvYtLN9qM8BXFPr6fsnoPhY/JpF+/c3246W7xxWt00CHPV5sidE9s=
X-Gm-Gg: AfdE7clEzMY2DM0MPqUPvwJR1wwdQN7to8zrvsPaxR9Kq02OO8IrtAIgIZHnJyX0gG9
	JsZxFVQfRZg8qPeWHN4IIK4mH0b1FxNflEgOhsOjk37VGYdhC1iEXSg7TLiGZJ86wjSCmQdXgQc
	1MxTPrYDwmaexohMgzc0JHjQJpeK9wQBLAVhQBZG6c3NSsWAJ0TO4Sw5WtMSNSp08n+rQNsR1FR
	C6fxKRVAZE2mQPw2IYoXBJr/iaSNwSxn6hYHGNq1yIiZvYFMxB3VWsKXLK9i2YRTa8n9imoIrRP
	EwxYB1ZZkt1n86DFmDogzRTXT2vBee0hUXFDkBFgImzayFqUwIuYeSy215f9/O2GHe7nvUtTTaM
	1mPXlOwtfDdCVwBpm+rNSu2HHJpXXVtXl6aRxnbDLcgMeeJpkC+dPfQ+KE/lICtoQh8SM5d8zyN
	EyuUbRstRAQ7uvTB27tpR9w78cuolfyKkxgcwet04q8ds+CpIUuFG0n6JaaTlEzElEb8VNQj+iT
	0Z1uyq7/SJqec+97g==
X-Received: by 2002:a05:6512:3b91:b0:5ae:a4f9:fca with SMTP id 2adb3069b0e04-5aebf97aef0mr577753e87.15.1782824532661;
        Tue, 30 Jun 2026 06:02:12 -0700 (PDT)
Received: from debian.localdomain (95-25-158-125.broadband.corbina.ru. [95.25.158.125])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-39b1d81c80fsm5833681fa.4.2026.06.30.06.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 06:02:11 -0700 (PDT)
From: Igor Putko <igorpetindev@gmail.com>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	IgorpetinDev <igorpetindev@gmail.com>
Subject: [PATCH] mm/damon/vaddr: remove redundant RCU lock
Date: Tue, 30 Jun 2026 16:01:58 +0300
Message-ID: <20260630130158.3826-1-igorpetindev@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629165349.4260-1-igorpetindev@gmail.com>
References: <20260629165349.4260-1-igorpetindev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E0D0C1C0019
X-Stat-Signature: 1ztesjkfwn93nt46p5ztwcrtnreur8ys
X-HE-Tag: 1782824535-366047
X-HE-Meta: U2FsdGVkX1/W8r1FLwC7eMCo3n4d9bgWOIfiW3KbZe7GfjanjGQfbdZiirjmmUIoLgYPB+oBg5KogI5oFk1guoeQYWgN4yVjiVQZJs8UhyHQRER/BisifQZGwTSmteR2N+PTkCP5hGWIxFRe4z4B7Ai594hBf+kZqGMhpAAQVkzclS2kCZtfWBG/QgxIB9ZJeg4LGe9yoKzB76Blli8Vq5P5UB3L5eCWwiijOBRG6awKLehdfDxHbSTYsDMXR5QXdCnYqzxYDP/TkXHY7ylkTkBFbXE1euybEI5B5KVibvMFL1T3fWL1E8jfG2rCWMbyR+eL51rnJ9ALt2mXfcXuVnNyhB3B8Y8aJf7cW4YCuB+uxQh3bJeeW0hGzJkaAhgq3GAfIBJSxKjrIqaAW0N/t/Bolv/hNn51NkWSZd5KzDQqRUQhxc6QR64Jrg6TN71J8rob7XIiGFH9G/UjbLPriQcsuKmVkEwHkSBANB1sKW++DP7QXAldHZMj7pLSOPpdmTUbfSu2hLOd0bR5JDs+PX0S+Ifz2BsvPiXRLn2cDkWJxyLXA5VmUBHl1/uEmhOCUR2a37ew3Dba94t7IKFwAycwSpqECS4rBWoEj5W4vKl+FNZBIcbSNq4F6RD7MtI8ebg2WOxyDrn7LdLoX+InpQX/UjAKdMr+9Llc3mqbTs7EP8nKZlbiqSqDTMi+uxHMLnJRF6e7ePNIAr9bxKwuUkZ27WDYkVBdpVEtTcHkJqg5KZsBM8kB7UuKVuB51FrRpdi7Vod3GyD+FmPn2j8YBD0SFnvEj0PuTGUuPvSoJjuPlQm+eAftrf0WLXbh8PR5jyLiaOZa6n9s8i0dnKZsmmrpUGt0Y84wBb3PtVcI2wSo/zQuwZzz8q2YEJK5w8UBMZj0RFUDR5Hhe0pnkzlpsoZ1nSZHH0q0x8seMYeSpCES1bx+HGSp8BWzt+1Dj8b4Fl5Fyu7vY8aHC4Jg0Vf
 fW5Ir/vg
 7xcnBhFlyt33czf6s7l9LGq8K/ftj9PIoNsbEkh+Ozn8lQDa3K3ZGQMtACI8WcjS3fDCsOf1pXKFdqfYLOtC544wO6NeW1gU9c4O08o+3npV7erPodpAAs7axBrIEm0+TTbBcWOd85jDf8Ojrxpo17kIPXYpMew4wVHrfczR/NtPYRt18vqXOLHTqkMK8tFD4oZhuuZbVnZ7o9KEvEBAhUrfGsVY1uYbJoQYQqhx0o6XdV5rGH12LmLjvy9NVLMwY5M+Z4hV5nffh/ZzDl4CAzBd6Ddb6oSUgzFbNTZDW2Gidx0meeXmGyJR5LYo5zlQ3I47+G2PgZQmcTaJhDLuAWFjy4WbbIoFyJ9RSAYHMh1Cu4+Ksefcmo+WFUxktcOR0uLqQ8Gq1PYzxiXG3QFSuJEa+UqvO1vZjjLFTNwZ3xjhWcWJiXuSfMTehKrfQdiXRbt/uGB+Y+KVxSiyIfC8FU+TrhQ/N2PYVo/77qW1RWxnWmldCZeamGFNKww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: IgorpetinDev <igorpetindev@gmail.com>

__damon_va_three_regions() is called only by damon_va_three_regions(),
which already holds mmap_read_lock(). Since mmap_read_lock() is held,
the maple tree and VMA list are protected from concurrent changes.
Remove the unnecessary rcu_read_lock() and rcu_read_unlock() calls.

Signed-off-by: IgorpetinDev <igorpetindev@gmail.com>
---
 mm/damon/vaddr.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index d27147603..345b89b5d 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -84,7 +84,6 @@ static int __damon_va_three_regions(struct mm_struct *mm,
 	 * If this is too slow, it can be optimised to examine the maple
 	 * tree gaps.
 	 */
-	rcu_read_lock();
 	for_each_vma(vmi, vma) {
 		unsigned long gap;
 
@@ -105,7 +104,6 @@ static int __damon_va_three_regions(struct mm_struct *mm,
 next:
 		prev = vma;
 	}
-	rcu_read_unlock();
 
 	if (!sz_range(&second_gap) || !sz_range(&first_gap))
 		return -EINVAL;
-- 
2.47.3


