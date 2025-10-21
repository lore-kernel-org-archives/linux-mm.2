Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D2ADCCD1A2
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:48:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E44C8E0008; Mon, 20 Oct 2025 16:48:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BBCB8E0003; Mon, 20 Oct 2025 16:48:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D2258E0008; Mon, 20 Oct 2025 16:48:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F04678E0003
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:48:02 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 83CE31602A1
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:48:02 +0000 (UTC)
X-FDA: 84019679604.06.3CA58DB
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id DFD59C0008
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:48:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Okn8LorW;
	spf=pass (imf28.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760993280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=K9q3clnG/Bkvn7l3sw7E6dauVwm40zMq9FQvMaqCBk4=;
	b=0kN5N9+9+pqZY3h6FZBBxi0WwWo0JRcg92t6olcR+aBTjOvOQ4FMzLEejWR8UUa4+8ZXjq
	/7XvQDOkndhAABS1tXHgdHrXxoHVMGyrcDxNWeBUJhQTEdSupJfwfwVY+iEezVVLzXKgIY
	Ghdg9bnf7x1mK+cgh33/takIKe1jVfA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Okn8LorW;
	spf=pass (imf28.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760993280; a=rsa-sha256;
	cv=none;
	b=5bebvlDlIwhUFCKvkXqi/pVI/PlL93SsZ/EcJDcMIrS/HodhBS9x8msw5rwFNPROtqUu1y
	Yd6UDku4BZ+/EtnWfrxw9PLnCRKhB0OyvraDkLBD/snte1PMCFPx7/k4h3CLtLhlbgCMt4
	2Mm594iZ46fAgDUWMHuuxoPb369f+oI=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-27ee41e074dso56784075ad.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760993280; x=1761598080; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=K9q3clnG/Bkvn7l3sw7E6dauVwm40zMq9FQvMaqCBk4=;
        b=Okn8LorW9PLQeE4LDttfN8xBhVxcry4JPuAGkw2sgczqMpoBMUDgRuSNAEEHyYBZsL
         6UJqK6fgEysP8TIDUDeuItWYhGhIbJPOZ8wKTKo5oYHW9sV7/1i3A7eiz+C0XbDmC31P
         8F4HM3UFYP6kgVsJrAPGBvvmaXMz+3s/RLRlN/PnyDaT/eRbomiv6cC1aDEKZG2vvE/o
         nYOUHsKx5H20Z7sY58+k39uFvDBY5FiMnyLJsT828YgPnsTKWEGlxrVpBiTx8QPaG4Pj
         clYeSOY1uV20KzC8sVO0F8Sn9IMQhkwuEzn0JWtD9p/VNmGIbRCKAyOVjdLIDyB553i2
         zF3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760993280; x=1761598080;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K9q3clnG/Bkvn7l3sw7E6dauVwm40zMq9FQvMaqCBk4=;
        b=a8g71nQug3T3TPY/UqFCspmbE4XP/HRwhg8nQmGHseJsMLW9E6IhQYFN26+RpYQbmW
         AfHPK9ycNtQPt0NMnt3p03HA+SI6oo8ufxyTlyTRelyBoq+WbgzHsq/G7m8fBqqtnGjz
         uEtGGsDpDzb43StG1/ToQi0u1WPEcvUKxvlTx/DAlbSbwMhMb5z/jpJsAGVsdtAvx0Zl
         PVIWZCidPn1RLpWwylFCqL2fqCt68xGrUMAaxXwFMgEktvMZVF08AvHjr0fejc+7eL/m
         +7eYmnYLNXqRVmaAz+4N4l0h83iED8PnJsJ0whu/KuAHFOnPxWdxOcIdgU3MoiToU8OP
         14IA==
X-Forwarded-Encrypted: i=1; AJvYcCVRZI0FOo/V3DWcXxjhqO9K9yBH6OyCjVjE/ShIENqPv6l+SQhoaW/MoWbhVJ+4byCNQThIBCbqnQ==@kvack.org
X-Gm-Message-State: AOJu0YzLSM1Grap+hhu8EgC4LnpE19dmRw0D3vmDQsvhu8foCe8AxZbS
	37QjraYjwjfhOiV6VOORX52fZCJt2o7Qd4eXDXOC6bEpC85Jd5O/om+u
X-Gm-Gg: ASbGncuSTMcJfEJXQHe8NfR8ALy7qTWIrbcpZk8ptrMo0szQlCVKUzDKGP2Z4dxlxaw
	Yi+rDd2WNVfkelk8a1MOsfND6ehtyPlJN0c9oxArPDE1OGCFQAec9SqU282CvuDm5IYrA/7hrVh
	RhPm2Dm7ldkLft9DHNFv2QVVjY/YrlgBBc/MROXfUzeUc/JEPoZFebJNbYvVpLyAXAujuHcQHRx
	hRS3Nr4vkbFWm5U4LDsqTxqqv2DqgDhjnv6M1OmrPTt8qbAaxKpsBOE7yOKNmqTptLy/xpNo3Ag
	b4s0EyksTOdHAZ9t/0y0gyfgdzJes4B1vukGeP/CArfDmJw8K9r6isZnunZQ7jidGmSFEr+ePKG
	gcaPCaQDXIRuP+4LubevMIrP6HcEhGX9NyD9t2mWDX6xtPXQEtxPJ/BWl73WsmdwGdGTHUo3Lmm
	rYlW8ShIJ7
X-Google-Smtp-Source: AGHT+IE5e+ebTLo/EOuOY7XEa0TXekx7W1YXHb9P048rXvUtgRAvL3w238dOjBn2L0cKSl72dYYTtQ==
X-Received: by 2002:a17:903:22c1:b0:278:704:d6d0 with SMTP id d9443c01a7336-290c9cb2666mr188482125ad.19.1760993279652;
        Mon, 20 Oct 2025 13:47:59 -0700 (PDT)
Received: from LilGuy ([2409:40c2:102c:a203:e88a:758e:c83e:2ed0])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-292471fdcf9sm88461725ad.91.2025.10.20.13.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 13:47:59 -0700 (PDT)
From: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev (open list:DAMON),
	linux-mm@kvack.org (open list:DAMON),
	linux-kernel@vger.kernel.org (open list)
Cc: skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Subject: [PATCH] mm/damon/sysfs: Remove misleading todo comment in nid_show()
Date: Tue, 21 Oct 2025 02:17:13 +0000
Message-ID: <20251021021712.59017-2-swarajgaikwad1925@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DFD59C0008
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: rrsfkwzot8psuu9tekkzdbgfwnw9jgah
X-HE-Tag: 1760993280-810512
X-HE-Meta: U2FsdGVkX1+euXNrnRefateWvOpuUJPwX6n9YtEhK6RAXVzrssjJIdipsY0JOKf6n63eT22c0IAKzzSAmRGztup45dnPo8tXjem8RzoDRGLNxSAqx0aclWpFJGgpez10C1judC6v8T3ezbJYib6+PpxVpSnfyod6g+UTqQVQ8C6QvdIZ5m1YD37apuBSHtK3p+VoNhPzFzPCYMtW0ipNazI2Jv/gLd3cx7PsnyqHNfa4CKSYzcljXTFTFMitZdOyekBcKSTOay7IesxGw8Jk5QASpF5yrTYnSWTmvc1EJFewztoGuvdb0YA+rlophjDv9Ob+e/Ujvj9nKmZISZ4DInfO5kY2fLwesX1Y8VpZauFr4vB2scUCuMSfpumqT5RSroPDy9bsb2YP1m3m35dosaZgmWAtVZSWEAli41ZQ7wnKcOeSxZYrDuaae7Pi/F/OXkvA5nTuY3kfgNnEv97hejr+9BYtMZyaPRqpHop+53FYUCt5TYq4jrKS1oYIX6EWxrQhiFjZvwdobWDUGgS/uw52BDhFq14E+itmWS8+8HHgpgmbUe+QUwt71n2f0e+5pg0b85tO3usrk+LuKxXiiu78Rrizs1N9jCbcAlfXpeV8MMiBP7ROeS+aUmQLAn/vZTRKAPoIgb0OUFMsZYMFJ5H7Elte3s4yZevNXkz+SWngWvsZg4Iz66fD3M4FZDETq6zsmiHXQtqPk6WU+wSY4Jig20Hh4gQW6sjnZY+HVN4XU6o9y/tBVHsxfLtu1tm8vuIwqpEAOGC9D4tS07sgQ04Nr1JfYWTy7LUE8LMkNXanzjjWztfdp3tNTn5gkx+yuAII7BH1jMGllTncBqM5ClHkc12hzphTkxBbrBmFWyKLXpuxvcaC92ZW4oUL3sgHbat4UC31Qcbf4qrqP1OgwPpG0hSXZcwZ+OMPWOwyF7xZFR7EcX/mYRsVzEtH/F4siIP9AKP6gWu8mxvNj96
 PJE/6JKl
 QgykgT4bKkOFNd7bjldvMBVrwSfDFtB2kLd9uvnUiX18E3LbhwkNTjImfSnT4MqYfjZ8oaMxUuHi7nQXAPQTsA0okdNstopvVU7LsPoaoCyo0sAyyYx6dyR72NUcEGM5EsK5WUTCLClUHr+f2NJyxSaJSspnmTDt3VJ6w0CehECTZ7dsmxsFn8QguY4/Cn+5jfSqM0FJIPeHQ76kFKJ979ODyTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The TODO comment in nid_show() suggested returning an error if the goal was
not using nid. However, this comment was found to be inaccurate and misleading.
This patch removes the TODO comment without changing any existing behavior.

This change follows feedback from SJ who pointed out that wiring-order
independence is expected and the function should simply show the last set value.

No functional code changes were made.

Tested with KUnit:
- Built kernel with KUnit and DAMON sysfs tests enabled.
- Executed KUnit tests:
  ./kunit.py run --kunitconfig ./mm/mm/damon/tests/.kunitconfig
- All 25 tests passed, including damon_sysfs_test_add_targets.

Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Suggested-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 6536f16006c9..760279092b4f 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1112,7 +1112,6 @@ static ssize_t nid_show(struct kobject *kobj,
 	struct damos_sysfs_quota_goal *goal = container_of(kobj, struct
 			damos_sysfs_quota_goal, kobj);

-	/* todo: return error if the goal is not using nid */

 	return sysfs_emit(buf, "%d\n", goal->nid);
 }

base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
--
2.51.0


