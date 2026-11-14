Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34681606A89D
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 14:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=C4wx7cBO
Received: by kanga.kvack.org (Postfix)
	id 398FB6B05CB; Sat, 14 Nov 2026 09:52:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3704F6B05CC; Sat, 14 Nov 2026 09:52:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 238706B05CD; Sat, 14 Nov 2026 09:52:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA60B6B05CB
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 09:52:51 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6FDD61C3C04
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:52:51 +0000 (UTC)
X-FDA: 85434016542.23.40B24B9
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf16.hostedemail.com (Postfix) with ESMTP id 96489180007
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:52:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=C4wx7cBO;
	spf=pass (imf16.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794667969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tm/6Ewx7tmmRUl0t+lzW1rhB1ymVzZpDphuMopZREW4=;
	b=q5BIeYpj4AxBl5vwPcTrU+t726A2Z5DNvTB9vg42nOl4QS3NBdd8E+NgY4CgaNoh4lChpv
	NHEWfIMR+3K+f+BsNHCam7NWAEi7Xg0SPfxWeLu45r7dnF21ZcqaDkvQS66E3PvdedXuDK
	WNp9drOz2bLk53EVYEPDfDJRAdGgHX8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794667969;
	b=tXNhDK83IP6WyqVq41yP4QUebW7w440nSAW31ln1YOfz2MEy/4NPQRvwEbjzjzP0/6QOMj
	NkaY7K9GIskyRg/EGr5ZDZ431JiGzDiZpfZtlbQS8giwEK6NAFJVyn8yuDJHCMvOWjEBvH
	/oX6yfjcdaBXQlxnX5+vBs5dzsGlABs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=C4wx7cBO;
	spf=pass (imf16.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ed39646f04so6734815ad.0
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 06:52:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794667968; x=1795272768; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Tm/6Ewx7tmmRUl0t+lzW1rhB1ymVzZpDphuMopZREW4=;
        b=C4wx7cBOH7B3Og0pX82ggMqf7/CuRmlzjNEzY9ONKiIyVHXbbgAu6DUIrQu9LhRQ9Z
         AUSyjBOfRFI/uvpB3a1iGG1ubhJeJtx0KmjDoo1o4J/BrcYqQbW392WxP68QWD/QHZwU
         3I4vBOzoRN5mqTyM/xAyYa+O/1ka+2TBFI9IMaOFfHY2m38//EynRYuvDqFHlOzkwjpV
         mjNsKQzQLedCZSx8eSoxRNLCj9ICmv3t7Uq+Ou3Uc5iJDTdNqYRwZeHTNmd4oQqili+t
         uU1k7sruNyEQg5MlPZ3qQxmDcWV3px6fcA328CvlaX0jFoca1Z1S2EKwoRLISJnr8Ynt
         NWtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794667968; x=1795272768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Tm/6Ewx7tmmRUl0t+lzW1rhB1ymVzZpDphuMopZREW4=;
        b=oRyHkmF7un9XxDylCZGyHzPxjh5/CjXL+/UwHh5HOFE/KOcv/tIrgZ8NSCZvpuecuJ
         wz8gTxg1GL6Jgkcy+PWXrDsiqsReIcK1M5DGmUG8hw2g4RY9UY8oUmpk0To9s+fKbdAm
         yoPVAZ5mci+mGMrOsf1FJeMi9T5+8n5SJdAQC6iGFeFzt4owstPX00GfOawBTxzXJjWB
         Cf7NuE27w1McEs7KZzxFlYggqjuMxgAd4YyOoQ2PLubJ8ft7gRKePnhtEI6iyIPXKDGD
         SrPXgq6AD3x1ZFqh/bpSF5g8h4N7zH6H1/X+8WIWhK3yb0QGha9EuZHREGpbrKCUqTnb
         QoxA==
X-Gm-Message-State: APuU4Z8drvwXtafY+EmO6kBMTie2EBF2BJxkuyC2j0cqQd2nMAycRQOB
	E9fjS3+9H3ZB0nZAybWGlidN57PvzOWu/lX42j4LOtQNce/tOptJRSEtNhkZiA==
X-Gm-Gg: AYBFou18vyMGQd21AnijrAk8xuCUInrnn0+7S6EPu8xZGabCHJQBqnU/qC/LYZSYHWH
	5LSyWYmbmQ37eI+slnDAhikv9/uFpX7WJPftCaFW1Hq9R7c1l+TNlF7DtIBhXFtpGXMfu6Ud6eV
	dnBwCS7f9YO4HKVcTx7NMDR8hzq8ih2lWqr4Wk12NdlICoam0lNbHPU9CQZaUFa1bpf8WGl59CP
	PLiaXJnIlvgWxK/hSQZWl++3ocu9BtfdS5qFFQ7mUdPDLNsyhdBO7lIdG6WP91XzOsRrCdoNWZR
	V+1MJgn6WxtCkfhnKlg2Job9WWm3E+hB/f3u6Yt8F/Cux3gA5vCKzzcM8RJw3W66vK1twlAgLpY
	HZvz4xCS4liXWja+9JuHoJ7I6Sc+wkreDNjZEj945SqZp/Ondct2v0Vf2WVEerebbcibpBXvOT+
	zwJ45e3Nxtd9gIE9gLsH8xJ83rRqmTHPYMhSKh5r8VJy/yxJ9tsczmglkYJRkx3Sl0sz0ksiZFE
	sNcVUKI1IIJCOSwi0S4l1oQZCRIt0W319VKubnVAgm4O84y6xZTISmxIbKCff3iJMl3ayocomuw
	oire3xewDxtqmNISSzdmhYtBVPRQuj8OJ18LyPahTKHDa3oBWUMWnjQaZdAQrITJg7ZF
X-Received: by 2002:a17:903:1b2d:b0:2e9:8e0a:cc4d with SMTP id d9443c01a7336-2ee0dee4092mr53566845ad.41.1794667968394;
        Sat, 14 Nov 2026 06:52:48 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f8623c7sm21620975ad.42.2026.11.14.06.52.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 14 Nov 2026 06:52:47 -0800 (PST)
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
Subject: [RFC PATCH v4 17/18] mm/swap: skip reader rotation for single-device priority rings
Date: Sat, 14 Nov 2026 22:52:37 +0800
Message-ID: <799821479a3c820a041d0765fbb70a75598e641f.1794666741.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1794666741.git.lianux.mm@gmail.com>
References: <cover.1794666741.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: pjrr6doyez717z7h6wguxsmb1kbf14xc
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 96489180007
X-Rspam-User: 
X-HE-Tag: 1794667969-580289
X-HE-Meta: U2FsdGVkX1+9dJKF99qxwGOhYCirIVPuj9qE+f6hyy6ulj6jIBOW4Qo3oyrH16nKf651b79qHjhT+LMw7yweYithMGRlKG6pzrdmlOCpEiBBAVT6cEg2rMivDL+NhhOXZAbe27YieHlNeOlEcxjrLdgP1dZ1hSpqelR0AE5OZSvpX1YeWRYLibIQuajgaCLMCrz5ULeJ0vJ0c1nKsKLbddw1l2ASGiz7rTXE3dl63OvJCoZNO1K5i1XPx5M6JM8PF592B2MnCH4rAxLqq4B52ywpEoxsAr8ZpCL49jtCp9JUAYVnlx8zi2gJIlHAgRp1BgmkSUrYnZz0qlz5dZOBkD9lt1xBvK+xJ3SK8Sgcdf4kWzyLfkgAN0M+CehDuHX+jta3hIyrQWqmwbjPaQISped8JsZ8KAAu5CIw2J+hH656uq2K0GJQE1bkZ6RWd9HYWf6n8IeLivEPIJZFV7hIQIumetLH5evdOYLn1Yg7+sJJOE8sEoj1rVmAqALdpsz84+nGvBHTjBaTt/vxTEwogY6K36+YB+8HBOSj/ImH+4uqMTFiUu7CuDHDucLDBAiRnNO3qZXnxTwSlpfFWoLcH4ZBH9BalY9fLC2KNBr9BDqLokHxNBAzyEjme9fPBkOx7KPSmc/4DVYljUdHFKq4porVIB3pAFGThW3zrlOW2Kj+VJPM3+vW6Kcrq9G0QJXZ6LztaPNsU82TbEoargS5wmjHh4I9wR/EN5lAVvt7GeNLJiiyRVr9BpvO9oMzgw+sdek+F8+SLT+bQ+/yvXXjzWlhmkQnDuNz4gYNcyey6tFXy6mS/u3jp3X9VPrcOy6GEM5/VrIrJWlfFtURDAjgLPOL4ul7IWs3SBOS3ArfXWwO80HukiCByEG7YqVkWtErZ9B4oQ3hm/Ac2tXxysJuv3IW4ayEJ5BEvzcRsjRAZjXjb4xVml1krpJ5Bota/Q494DA3Rx0E3V0VMF6IXXC
 P5/WCx8l
 04lsF3IO3TZEWkw2YZbIJ6r1DL3Kj1vqI4q4PYnTc8u59pqiqY/OG0Hbpucy1yB45O69r9H/BA7l8Ym74lc+mw+J5bYRfb7tUF8mYP2AN3tRfhgVSzzwHl03gIFDsrVz3gBDG29HCVMgQb+cO9T4pMgqUff/AGvRZ57Jg8qNI/g4cR22PmDBI7D/D0Q5nW6ZVswSYLf/V0drdgO4hMT14pjvIFPRWDiic+GnFaCE7Y7P0YZn6XHwygbf9O6GlYz2PEjS2tbojnqqsAPdX0XSS+Ve7wWQhM75XfykBezSPK/jQMqR3jtbPmtYfa3+4tk1ORhPgqDvw+Pt9WzIljq4Be+y0XnLLDAW2jl7mbVbHFq5zv7n51bQxJniN++zZLk1B2NeccokMizvnArLVbYIfZEoXix1y//ExBBPBle8fkfcjjYoMuz8clZoeP+NjFUhWtsEid3snaWaKYzElZ8UAwnF5rp1Eae7E4I5FogudUe0ey2VNPsXjEMVaZktsCObUhIvDNUwKPsowXv3YniGSpTftD4stFMsdLT7Ki9fFD/Rn8GnfvMHVZGdNTQxRBAw1PBx3
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

Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/swapfile.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 616339c5ae5b..0c192844b121 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -334,6 +334,11 @@ swap_queue_get_device(long nr_alloc, struct swap_queue_cursor *cursor)
 
 	/* Consume masked peers too, so every walk remains bounded. */
 	nr_iter = cursor->nr_iter++;
+	if (ring->size == 1) {
+		si = READ_ONCE(ring->dev[0]);
+		goto check_device;
+	}
+
 	local_lock(&swap_queue_readers->lock);
 	ri = this_cpu_ptr(&swap_queue_readers->ri[queue_idx]);
 	/*
@@ -363,6 +368,7 @@ swap_queue_get_device(long nr_alloc, struct swap_queue_cursor *cursor)
 	si = READ_ONCE(ring->dev[dev_idx]);
 	local_unlock(&swap_queue_readers->lock);
 
+check_device:
 	if (swap_device_masked(si))
 		return ERR_PTR(-EBUSY);
 

