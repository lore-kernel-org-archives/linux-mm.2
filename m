Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E667C624D5
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 16:53:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70EFB6B00A3; Tue,  1 Sep 2026 12:53:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6982F6B00A5; Tue,  1 Sep 2026 12:53:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5392B6B00A6; Tue,  1 Sep 2026 12:53:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C75F6B00A3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:53:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BED72A4267
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:53:34 +0000 (UTC)
X-FDA: 85165789548.20.3C88364
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf11.hostedemail.com (Postfix) with ESMTP id F288C40007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:53:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MLaJ9pPA;
	spf=pass (imf11.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788281613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R77RQ3EcQv+pz1+HV7gALVgNstOExEkgXHTcwGFLmOI=;
	b=z56Qkrz4IOkd8Xf+vsLRAO8nvOC5D8kDxXzMofR8rume2VD8Ve8jDZCgwl8hQ+OJY02Y3z
	UuqJ1ZFaDljFAm3iGRotm332FooxUnNE+vKoVS2vh2nk5BLq3ho6nx7SpYGTQu1dWzV2wE
	Ymm5eIHfBzFnXHTI+JNshpkAtUu91oU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788281613;
	b=rOttPNgZ0DiPHvMh6cRBxHXYkQejEV7C8AgSjRK06SbQmpJFBP2/NY+KsKhc2dPxekPQ5e
	KL8vAkAa1p0WbTN1uxhEqqNMieOCkShtf/AUw8UJkcv7dOzbEo5LxrVZS6CH/bsSvb728P
	kZGlXjBv37iZBpoBOsZmJbOMmxPn6Zc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MLaJ9pPA;
	spf=pass (imf11.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2d6fe26ef1cso53075045ad.2
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 09:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788281612; x=1788886412; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R77RQ3EcQv+pz1+HV7gALVgNstOExEkgXHTcwGFLmOI=;
        b=MLaJ9pPADkwJqnRL5b84PceZwz0kbMnIFcTG3LG4U81I9gBkJssc5BvEDKTJ3W/LvW
         PFaWGqGv3TuJjgJpqOOqFI4JKf4SFTzU8Diql/YtS0bnbS8T4Djb1gptrzN1W8KyGWIN
         uBAQgfJ42+YKF0xjjcwomn9qalPMzJ8YY3Usj9uu/ndncpHwoyLFFESwBBYcreDZUi8m
         7QRON/qsT+svNtCgeYBfNe3lvMyvji90ae3y/b1H2iuuUrkZ5oySqBN46KrdvM/bMwf2
         irHbkq1Xy26KCsbX7SU87+IVq8F7hvmjTHXDCUeniwlYTbVyCw15PxBpWmhldJfXJyPt
         HEoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788281612; x=1788886412;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=R77RQ3EcQv+pz1+HV7gALVgNstOExEkgXHTcwGFLmOI=;
        b=Ba4J9VjYz0CIq50OM4JmgUJRWe2X42x/wzERhtNU/dkgIfm/mehyJTZbDiHmYGpjHQ
         9pFpdVel2QwHWSAwWIS0KCSUlXN2BHL2Wv7TIicnILCRlGEZZ13dVSjbQZzRRBVd2NOZ
         GPiAqn83g+/ut61ltIYbTf9XANMb+5jhisosDxFw4Jt4wNQB0RPMxif7XbUfL1DuGo9E
         59fJ1a5Q/MJLptEYsQ9Iz5Zu2jCLHrfDpOY6n7BpRe6vYEpSX4W/2rcSZzp0pfMnlMOw
         R9OmAvegjf5wKdkPFEghyYsigIruDyJmImp1VtLZj6uMetXBiQVtNWaft/5JotQ9WIuY
         UZbw==
X-Forwarded-Encrypted: i=1; AKwUvBzFqAyR08IY4D02iRsSap24tX/l84Rcx7xpYrk6TSO+AvvI1/DMSYuDyF5Aw4LGbt3uWy5QKvgCVQ==@kvack.org
X-Gm-Message-State: AFuF++mJHD0nKKtbjhOQLfNPqqmtBCgfWj7EI6mYFtz/LbMu9cYYpaMJ
	TF/bxrjl0kZo27wVZFkepkm8aOcXIVB5hZ5keDlXYaDrnGKesrJfo769
X-Gm-Gg: AYBFou0GcRPQz+P5hEn9AG/yoFEAxhBe+vVFdrkSaQaMilocOyExFcRi2+h+kSU4BDi
	fOcZJy10viQT45TgWUC463oPDNA4PERuOMxqV/yktoC5APPwwQxz1COKQZgjt1RcjPKaD+QwvOp
	s3aaXlJMQnOMubz2tQmj8Icn6ShvD+pfBKV4XvJHUHmsQEDLvHZg0cRanTlDbuXfLJv7rj2aLZS
	StS9jebQtRHMK5O8Bp6Sge+GrHpUw149FAvnhiQZNXrFIf+0P0CBA0KhzFGIqH9COc98FhTPDyz
	Yv9WEf1WGSSCYvPNgypWq4KN8phx8uMcgPjvnDfzc3CoeLKFfqbgk1zBgGdRZ9E/fPME4aVDytP
	ZIzcXdZFbQiu/dKlesPL7r1wPq+s78EOJ48FiqE+Mo4o0S1eZ0Pa0KNdcJZ8dxCCdXhLhb3vlMI
	2BWeIsd9Pd/x9LHVgi/6Ok5tasBsPw1lXgxZdf7ZoCq0oDQOhVF3wDsZc=
X-Received: by 2002:a17:902:f786:b0:2d8:d4ce:7e3d with SMTP id d9443c01a7336-2d8d4ce836bmr420465125ad.18.1788281611708;
        Tue, 01 Sep 2026 09:53:31 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dadd357efbsm1762325ad.4.2026.09.01.09.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 09:53:30 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/4] percpu: remove unnecessary return in pcpu_populate_pte()
Date: Wed,  2 Sep 2026 01:53:04 +0900
Message-ID: <20260901165307.1026248-5-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260901165307.1026248-1-ekffu200098@gmail.com>
References: <20260901165307.1026248-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4ih6crwjxjqpbtecqyjs5igiwmjjtse1
X-Rspamd-Queue-Id: F288C40007
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788281612-817898
X-HE-Meta: U2FsdGVkX1+wYrhYlDMtLpzOKeW5aCLq5DBkhjI+g/uWxNa7Oe1wroahW8m9qgHYINx7GWDlqh8D2SgbDn81TF1RqAnl6StljkJ5CdEP/3GEkzjuDoyWgwgzq73wm5ZV0vZGvvr8CJBAeMHf7C53Xy1prWNMfNv2BbO3Azh97la3uAxj43j5prbwkeYKToXwkPbTikoR35NdnFOiIL7TPORR7AHbYMmBSEJIydkmKlV/AcOGEGa8LHjVkPDaag4lr5/fcfbDbyhIS7QoQsJaagAhdcuYQX4ThV8nTaI1HAr93Q+ctucmfJqt87e8sgSBO7jqUdmaUTqHzLQESk1e3mCGMTxa1uRTecqcTLwk4EDr5DPX0B1LWxO5WV39Cq5C9apdo+6TLlH9bNznBA+ZTZUraOE9mv5bfaFUi9kBgKtGwMrh+yWcs23tXVhJ+84lS3f3joLHYWAZqb1SXSk1bt46j66j7E+PcTt7+MQSWH827c/FR60xzvnFKUJjC4dZD/j7ZlnouVzUOzTuFkriuE4I2Ftwrlb0zd21mxXuuRBf1O2bU2jrUGLO2eaPRVmwy+ggsqi5I/OoJ8LR6PKlVDQaaVGp/F2zpUPOBkdzE16AypuUGZ8eJZkDN/mJ1Q5UytTlNd8+XZYsoFY7uotbJHmA8oMGeuaNP2zKONLtkA9+B1BgFOpep428OxwGq4xyJ0Lrom8AOp5eGfxNbNMYqjOa9Ud54/DyuO8EHx1u1r/E5emMg0rdVTnnOIRshfwZUNPagxPFdwjk4iLkOBg6Klnd8KDfhwhkNNEcgbyvaN9NcUn5lYnCBt/sUPLXUTtpVhe6+LfHbudxGO9h7oaw/NN2R3Cdz7+hNUK2t7BJlh4AYo8vQJPadlj3Y7QnZ2T3SXNYCekEhxTDB6RdR+XFn30ZsNk8LAuq9s6eNtneyoUAmxIthT/WRNKq8F8yFkuxLsRkYhJYDlrXDX0nlua
 yJC2FvQn
 AzGomoF7ufHicBbaJt2P0OTlVbXPIImygqsfqOVEv0TPG/k1+bJ11mdXeSJnC9wEN7i3eklaxFZ74Fu7mt4oDASsuH3cGa55RXgqCsT8Cm56mApO7STi4j8aMH1utrDzIOGnKdniveMIzti8qJRxJVJUUgyQ6yzMLpXR4tjDI+UtR3m9NiqZNgUXl24GCwQW2LI6cYinULXjppoWyBemgMt+YncMIgE1j0QxN+kbVxjMRJ2xeVz/6npcknNeAhgBoEESXivMlvbZhLRLz4EDHQdfPi0T4MfCTz/7mTgzt8TwLp1aXs+HKspnWuwMcgysNxRu3f73M16EqQH1QqcCpCNEygIk+yWPlRinxkO549fHVjqb7gn27Op/boY5YdFpOoTNbJbNjN8QMQ21gjLlHKcEXdO2UwWJLyuUpo6zMLIsMVQXATWwpVbBjXqmQUzHIXnjON/CSLyXC1/Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit c6f239796b55 ("mm/memblock: add memblock_alloc_or_panic
interface"), pcpu_populate_pte() no longer has an error label after
the return statement, so the return statement has no effect.

Remove unnecessary return.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/percpu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 45f3e3fda2f9..9df6cdf636fd 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -3178,8 +3178,6 @@ void __init __weak pcpu_populate_pte(unsigned long addr)
 		new = memblock_alloc_or_panic(PTE_TABLE_SIZE, PTE_TABLE_SIZE);
 		pmd_populate_kernel(&init_mm, pmd, new);
 	}
-
-	return;
 }
 
 /**
-- 
2.43.0


