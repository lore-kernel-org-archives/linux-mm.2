Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89D3AC982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 12:24:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94A526B0092; Sun, 20 Sep 2026 08:24:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FB736B0093; Sun, 20 Sep 2026 08:24:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 811136B0095; Sun, 20 Sep 2026 08:24:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4BE4D6B0092
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 08:24:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DA96BA5DAC
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:24:22 +0000 (UTC)
X-FDA: 85234058364.01.BF1D334
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2B3A1120005
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:24:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MUy8NVUf;
	spf=pass (imf29.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789907061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ONHA4wMDILxcRZ+Lg+d1Nlct6hNZeNgcOdxBA0gn77s=;
	b=ezMCGTEE22Wwwj9dGAvOS1iePqn+DCpmuN4631nS56SSIqpppI3WujgnZS8ZdRGUtaSbe5
	CxRGz7AK3h5VXx7uQ9ojqR3o7yYQr+ru0XVkaa99GtlM6lDhMYIy9IpvylvOQiEajXM1dH
	amjmxs6oSxjY3qRrXugX+wGbwedc9M8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789907061;
	b=osTBeXXJh1MJ+GkQeQW6PcGm+7A76RUgy25Nypyq7mLtW2TjMgKb6sB8fKvhrDQP4K7b1D
	HLkD709KaCdTzTB1O4CCmtSMCK7MqcujO9cWpDHMoIgeCMf8shagNLCfuaZN657rp3U19P
	uVEnUrR2fcMiL2LKoM7J5ja6ojONlVg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MUy8NVUf;
	spf=pass (imf29.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-396ccda24a3so1619355a91.0
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 05:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789907060; x=1790511860; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ONHA4wMDILxcRZ+Lg+d1Nlct6hNZeNgcOdxBA0gn77s=;
        b=MUy8NVUfASuaypo4Qt/qzFtMfidM7IR+9kxmTpCc+hveE2K6Yf8uuu1cwnBf6k6d5D
         Bl3QfqTKfLYeSjMqJSy7UPHW/Je+s6eLnHKU90cm6Wd/RfiGZ0Cs3+2l5WeqU8VtML6y
         29FiXTr6/YbNlGD0+TWNaqiijJTuvbKPClnpEsbbu+PdqlMkNButZM9HShaAqSLQBxGF
         Le7z3SK7cqs6dCqDFO6eRGwNaJUv7CCS+ohXFTkups2samgfNLWKrJcLE4aYaRm9ka/x
         IT10XiugiRNytDoPClUlu+ZDnBvgPQTmDpZXmtYx9FNuCkQcvJ9C2fiRtmlGV4KeKG92
         w34w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789907060; x=1790511860;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ONHA4wMDILxcRZ+Lg+d1Nlct6hNZeNgcOdxBA0gn77s=;
        b=LJBOAMS8buchhTuSgb8KwPypXsWKMt/Konw0IViBll4ujlC8P8fPLQTnvbEQU5n4zs
         5DDGu7GrYxEhG/PLhk/OlgInLp46QX8VqvO1ZmGPiDUv/ZNfR5dqU13kAzwTCsXTIajm
         xrndtpWELhNiypKy1WkDpNSlynOwC/2lDJTXMYnEgJmRRVo4M++F+++KqpybTK8Fqg5B
         Kc+ogEHSCjjNUDqxYB+3XjhlRbZiHQrJKc+u1DIdu4VY3pXSFI3YJiyM96rXMr24wVnI
         l0ZQriI0X+nRBbrPbqaToj+3EyIIWQvdQGnJ7Cj2fMX1WXsDLEP/1wzbnPRmQvJinf/L
         zeiQ==
X-Forwarded-Encrypted: i=1; AKwUvBzM4/DpbkWdikdARtsv4Ki4gWbpm04z5EjYh+r7lwrn7MQZXMp4qRVB+MpE1hrfqis2Fe9roZvRGA==@kvack.org
X-Gm-Message-State: AFuF++lDVQjb4XqxdKqvvAXAV43zzzU/j3GjOK0F7Nlc2Rcd67O8cCdM
	jQTDyd5XVrpMhmGEEe3mMd6SBmjGgIYo0fsdGVgt0rDKVDGhz//G4yA=
X-Gm-Gg: AYBFou3NgGmzCyDSQOV1r8wTXswp6fuwu207Uf6MuHe1pFCvC40mRhTMCtYPsvgF9uI
	/Yb5ZNnHyQ0p2UyvjN4PJaPoBh+cAWOUi/5Q/b9bgn7sZ2VxBkb1fxB+h8LsRxQiS/nRMZhpx4h
	ylKJ0CHSk9CYJLOQ9hxuUjOzGUWadgJUwAHLoNyNqEYl+m1NItg+rp3f0rCR1K9bjtSTZQoUx/a
	G8Mg8spr3h8k1Si7DYNsUiCHxj2Qjn5ICJ6c4pwcVXcLlcmo1MX4knHKIkuZURTo7ghgCbbb6fN
	+bHcm3Ru3+TJxGCGJgTz369EPrPWBHTTJ57yGDVco7eAoSgXpGaKw9v63jSDjWFF4gg4EgA1DZF
	Z4Mm03axYWrFTQOOHPc/gug2i+dgCg35RIKKUmNLDh4R/zJRqej2BVR0+HI8obgjRtaOnIF4Nm2
	zFIVIrvioyJ9O3M822nbtElcfyUHuRkGVgKtADMMIa4wwP1UXqFnYtI6zsw9g5QL218tT/jCd/o
	JRJjj9/dV1r497dTEEAfuqH1I8=
X-Received: by 2002:a17:90b:1dc7:b0:39e:6c68:1553 with SMTP id 98e67ed59e1d1-39e6c68331amr8421991a91.27.1789907059964;
        Sun, 20 Sep 2026 05:24:19 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([2001:2d8:7f00:8c85:e0d6:4b87:c472:c9ae])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6cae997csm8753943a91.11.2026.09.20.05.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 05:24:19 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	donggeunyoo.kernel@gmail.com,
	stable@vger.kernel.org
Subject: [PATCH v3 1/2] mm/damon/core: prevent size quota overflow in the temporal goal tuner
Date: Sun, 20 Sep 2026 21:24:10 +0900
Message-ID: <20260920122411.610213-2-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260920122411.610213-1-donggeunyoo.kernel@gmail.com>
References: <20260920122411.610213-1-donggeunyoo.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3kx3jg7rqma9haay67skaksxntwrsd65
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B3A1120005
X-Rspamd-Server: rspam03
X-HE-Tag: 1789907061-465939
X-HE-Meta: U2FsdGVkX19w+DOkzY62FDTHKNKRg3kz4phLkPy3/Zqdm+YjV/TIizjtDyOJPBicPYWJuU2lFaBcDl6G/6TM2rRLF1Ts9xOqOYona8ImXtd0yabNMiZ/vZSidpn3YNT77LfQLF+lD8p2SiOf/cKEY3h+KUixncirn5XXtKSvH0Gg1gzpUJAtleKR86ZS7AfJSkp+BnVTeZAYwM2kt68i/ZJH1RdOsduDc9tkB6BgVZQDrp9OoUNbpc1otSE3+G+Hd67Tl+yQYtB6bYewwPX0/M4rF6ZzdfDEkpy1/vc5RAYg+Iv/oR+5VDuVwbNBDJqMPl5uNfu8vdeUqiK8jDPKh2lZWzpyFPw9GzCkZNzJnEVj1vYDJAnqI7/q2Cbisr6wLQJcI8Vk6xN2EJOUKAQQONz9Myui/QaQ122ZjyMkhD/qk85t47TxfwA5wkuCTzLSZDPwqNxYuUMr4keqPR+VNJCy0qk7jFsNwMfILqu8u078k1ixpjRmIq4B3xEAPBvNpb1Eygr5cmMUYh68cqk0fK/5VLE3djruYq7BpbbkqvAe7wbEWB3dWG4nvDGu0UEOj5Exvm2gn5PfeoS31e1lQuCaxG2x5d0RJBpJ8OasX0p4o8M7x8DmCUR350OAx0ZG/TLkSk/kvwUxh535ZGaNiz3rDCfEHus4PX6vmBLgmXb+2eSy+bEw/Kw9ZX0tqQzKPKdN890VUZhiju9XUXn2JmmABAxVeSQ/s/eooIbW0q5J7OIUAARUysfyQB/z5rxRVSxuVI9udomLhwS8h7cSpt4XSmOKfxd03hJRXBL1INLRA65VTHuxsh3x0kSY87GcYWl3SWarXdH51AW8xZ7wbS1bmenOqKyuq9uVlFDgvHf3AZv3EhOTBoPJrWR1NJ5b5Druv9IEaxekJHkLMOHGTOzwE1cmgKi/qNcMqfXnA+1UOc743s64Bb8ukTbzdhJaTf2Ugo35mxpISC7h3V3
 tCjkXBMW
 BQ1HWMyDbaybzYkNhFlyK0go+hvNXvo9fXvyHIJ4k1C2lTi6835i0bX3BsHjXuOu0SxVuBnquWkKKmFBgfR9szjJpgdud9fbvnn+RKe3cxskbklefi5XKmyBTHLErAWzlz64PrcnrwQLwcb88DO7kp9M1jAsxnCzNrkRqkDYcUpJSDc/YXqgIH8TJ3ml4sa7vHqA6pn5McFG0LCw6+uZrn0gF51OqOuieKXijM8x2TEA4C2wyubqlQC3dVvXXFU9EShdchgyKLq2Or+5JYJQk9c5L57GccDCzRnog8xsZzt6dB/U4KPGhYoVQlY1lVM6F5RKBvthG+SpLhh4E9PlGHKUgYkvyRh817tKCRcuC6oqoOaIx5JmAxcEen5gNxaXIqk+GT8e11UOR3FToX8UMc80XPrTn4Ev1If3ym4keIuf66nftp5TqZJW67g0mboNEjNImXl0yrlO+lHYaLtV+uJIT6ZIE4siLjFrT+g0VGMWMHs0TfErVHUPh/wYVrqpDKq3jaiMzTjv4hJk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_goal_tune_esz_bp_temporal() converts the scheme's size quota
into basis points with "quota->esz_bp = quota->sz * 10000", both
unsigned long, and damos_set_effective_quota() divides the result
back by 10000.  quotas/bytes is unbounded; bytes_store() hands it to
kstrtoul() as is.

On 32-bit the product wraps for any size quota above ULONG_MAX /
10000, that is 429496 bytes.  It lands on exactly zero when the quota
is a multiple of 256 MiB, which includes the 1 GiB that
Documentation/admin-guide/mm/damon/usage.rst uses in its example, and
a zero effective quota makes damos_quota_is_full() true on the first
test of every charge window.  The scheme then applies nothing while
the goal is unachieved.  Other wrapped values are simply wrong, and
any product below 10000 divides to a zero effective quota too: 429497
gives 0, 500000 gives 70503.

Triggering this needs a scheme with a quota goal, the temporal goal
tuner, and a size quota above ULONG_MAX / 10000 -- 429496 bytes on
32-bit, 1844674407370955 on 64-bit -- so it is unlikely to be hit on
a tested setup.  Nothing is corrupted and nothing leaks.  The scheme
makes no progress for as long as the goal is unachieved, which is
easy to notice, and writing a smaller size quota restores it.

addr_unit does not cover this.  It only scales the numbers a paddr
context writes to quotas/bytes, so a large enough scaled value wraps
just the same, and vaddr and fvaddr contexts take raw byte values.

Bound the multiply.  A size quota too large to convert now takes the
same ULONG_MAX branch as a scheme with no size quota, so the
effective quota becomes ULONG_MAX / 10000 instead of a wrapped value.

Fixes: af738a6a00c1 ("mm/damon/core: introduce DAMOS_QUOTA_GOAL_TUNER_TEMPORAL")
Cc: <stable@vger.kernel.org> # 7.1.x
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
---
Measured on i386 under QEMU: one paddr context with a stat scheme, the
temporal goal tuner, and one unachieved user_input goal.  Each size is
written to quotas/bytes and quotas/effective_bytes is read back after
update_schemes_effective_quotas.

  quotas/bytes    effective_bytes    effective_bytes
                  before             after
  4096            4096               4096
  429496          429496             429496
  429497          0                  429496
  268435456       0                  429496
  1073741824      0                  429496
  500000          70503              429496
  4294967295      429495             429496
  0               429496             429496

Everything the conversion can hold is unchanged, and 429496 is what the
no-size-quota row already produced before the patch.

 mm/damon/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 2258b72da7a78..16d4145379a2b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3274,7 +3274,7 @@ static void damos_goal_tune_esz_bp_temporal(struct damon_ctx *c,
 
 	if (score >= 10000)
 		quota->esz_bp = 0;
-	else if (quota->sz)
+	else if (quota->sz && quota->sz <= ULONG_MAX / 10000)
 		quota->esz_bp = quota->sz * 10000;
 	else
 		quota->esz_bp = ULONG_MAX;
-- 
2.53.0


