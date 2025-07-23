Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEFB5C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 09:51:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 730D86B0095; Wed, 23 Jul 2025 05:51:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 708236B0096; Wed, 23 Jul 2025 05:51:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61E946B0098; Wed, 23 Jul 2025 05:51:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 502066B0095
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 05:51:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1F11213387A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:51:04 +0000 (UTC)
X-FDA: 83695060848.01.77D729A
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf19.hostedemail.com (Postfix) with ESMTP id 489751A0004
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:51:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zzz4m8IP;
	spf=pass (imf19.hostedemail.com: domain of colin.i.king@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=colin.i.king@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753264262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9ZMzVfgVazaFJAzYrHIuEN/Gbih3lNCuqRrmR3G639Q=;
	b=g8nPVxSl4aU9ZMmWbfDDCfa9y4x9c6BiAfzn8LfC9WjCP0bDw5Z8DjNxn5c2L7mNwe1S2k
	nk1A6UbP0w3aAB+xujPK7RoDtrgsbeC2DcvFCoz9iGtOn2Uo+DLGtJ4fjiDBNtrk1OiQnP
	Zudld5rjE1kM+EZAsx/Kmf09ywVKUBY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753264262; a=rsa-sha256;
	cv=none;
	b=yRN7pCM1z3B/LTvk93HE5Fcb9QrtsRxJp7Hh68E4Jbi+MrM8SnLAMnuaizgAzNk2VRMGiX
	J2UaD3NUEZBJmNF2N6IhmV+w64Zvh9HEiW4AQttBfPAKzji7YFu3odmvk1OVgyLJyCRC52
	ypnj82M/YP9p3WQwBHBp/11z/EPngT8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zzz4m8IP;
	spf=pass (imf19.hostedemail.com: domain of colin.i.king@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=colin.i.king@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45617887276so42813815e9.2
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 02:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753264260; x=1753869060; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9ZMzVfgVazaFJAzYrHIuEN/Gbih3lNCuqRrmR3G639Q=;
        b=Zzz4m8IPj2g0D8nKM+rBgzGlbcQh4fScjJi89zwfUvGQI0OEpVPL9P4TWLNUZ3lKHX
         yiW5m0P7mp2wVCy7RAOdxlRSvEj0VwItfH8B9R8aQBBYzqAjMbbUkFeV9jAGXepvaYya
         3iYQ93cSn8fEIcIUyDm/+NXfDxmENvK5xTcul8k3xxTr1JtY1aYhU5qlK7CbuTod4YGW
         v7qQuaRHdAWB9DZbQDeqMWZe5dbwTENysRIJZfawAZmuz4JCE4MGhodVx1joc62ZQ7n7
         9nIZets6mt2aXulv70q9g9IF5ZWViGbWmwOf7UrSJyfGNaUZMc6inyWB76qlztmP43HU
         kzNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753264260; x=1753869060;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9ZMzVfgVazaFJAzYrHIuEN/Gbih3lNCuqRrmR3G639Q=;
        b=r/R0T/GPbRtPlo1vHn/0I+ktx0OLhDFEYmVHqisTvpQzv3j415am6zUmkVrLzRB+Rj
         cnYENBVFYSFRTTGy6TNq352mNMA4Oc9vTBZPx+HEVLXrS7ae913elEg6WoqOc6QRLdU2
         GNuIU+L49CaR1AeI5yzdM3MaD7aADyp3eYQt7du1jkYY67My8H5kgWfEmW3PsRSAYJAP
         O+UT/mQcCCWMl7xnLbKACKbmJ5dlNU+aaoGbQin6CSNn7qjsU8rpjw7xil/ioKXz69WR
         DG8T9sZvaNMQLdNxZyAOqj6FOjTN1vlKYG/IzH1f1ZJQeQvB2cNDZ/9kklZN4mnfRdop
         7ONA==
X-Forwarded-Encrypted: i=1; AJvYcCU39TEHJ051+MmnK0Dtaux1pTiX3DKSsVO9k2EuXq8l5KcUP+WENWffYbmRwNghU1AF9HEKBcwjKA==@kvack.org
X-Gm-Message-State: AOJu0YyhuCkf9ZwUa5CmepHL6JYrkwuY5rdw5rbijVu4MQNZ6wsqVwhi
	uObswsQa0B3VeobnilHQDVUYAitwPCnDViSLbTusHqisZP9+gerCZ7Fd
X-Gm-Gg: ASbGnctCwkXmucj+ryKCIXXArW3OQFxE24wpDmq36DYgcbI42YS6L/EeGoLRH7N0r3K
	ZaPGrpYQ+FyfjahEPHoMk/EuohU2PapQnZDp7b66L1HLzFaN1QQMxacGIZdqUU76gZaUVYDNFxW
	bcQ370PquwzwFwTKrlmuHN9Hpn+xjuSL/RAV0Bsc6CQiwok0oR9TrMPLtSdlqBAVkfnp/ySJbR7
	Fvv+gX3u7POMsSZNaeAcd3XC2qTtpyt3d8fSUq+3ZwxMKuWkA+o7DEo2/qJ9RGX6VaWXm5XpR+p
	Q7/LkEJyfUYoq/w87sJJmJwURWzb7Qe2KDcPq4uP7qV2rnzqVmnwSluADU0oTOyMORp9Bo/d6Ab
	RObvm3CNum7xrKJPh9B0s
X-Google-Smtp-Source: AGHT+IFYj/ZHoVPwCQEBnuRa1FRBb7f+LGF2/wD/iPkl2oqJC2a3kqKCSYyK1/tiu0v3EbYr4ZdR7w==
X-Received: by 2002:a05:6000:4028:b0:3b6:136d:55de with SMTP id ffacd0b85a97d-3b768caa42fmr1942681f8f.7.1753264260184;
        Wed, 23 Jul 2025 02:51:00 -0700 (PDT)
Received: from localhost ([87.254.0.133])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b762bb4f6csm5464974f8f.4.2025.07.23.02.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 02:50:59 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] tools/testing/selftests: Fix spelling mistake "unnmap" -> "unmap"
Date: Wed, 23 Jul 2025 10:50:27 +0100
Message-ID: <20250723095027.3999094-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.50.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 489751A0004
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: nf7dmziau5qd8yuts1yzdwn1p5u8xm6e
X-HE-Tag: 1753264262-195876
X-HE-Meta: U2FsdGVkX18//SzvpTA4xESS3zwJ2l9q4pHK89oJo6aajYKSy8Y+/N7kMALhFlc5/noeAMiKO/uF9+0jnAY6F1wmyM4Fq/99kC0s2KaeACEg6toFE1Hu8oDqTzz1eDP09Xkc4LGpHXZ9Mai0lHl0DM+Egwf8D+36QbHF0oj5/L2xHOBuQuplrxW2ZH8XPbkw6gl/xyyvz1veC7EYmr8fyVRN0mPeQUTB3D6+ejBN/kGa44mmw2/IuqoXpFDqIXumRGbL3VBGJlCrzluLgiUuopzunn9D4+ZQ/hDscMKdWcXlkITBJoCM6zhR8SHkZiWVjYClnqhvTwhPkDYHfrufubQdRao7K8mIDBkavK78hjhOB/y2B6LLYg8LL9F6aAxCqzu9dVx9+kleUZtTkU80ZyA3JlApitA3YBT4jizmH/6hTnsNfkjHfFx1rPXajsx1wI/n425o2MGTvhRfW8rbIRedhF9mOao7QoW+8S1eE7qwd6BNa+agLvwN9suQ7SjwWfYrJjb2zyxA5Z3gyDbpyPHl69kS6kS9Kx9+gofmjkOiFg1Vk1gZLPE2pImDLJMC54hekwC6GUvSI7KDCe6mBPgzOUvIqOIMfWCZkccKR7OGvfWaTHjNo5ApZjAJ3LcbfYS61YgW6hxDSlvYuAfvgLxCyIv+TyjHVDxbf6ELAE9KA8tHzRKJImE3elcZFB88F4rzUCab1FMM1acR7wl/ZBnk2gr9P6ztVGpiFVlGkqvgViI+GTkuzmMdQD54N5A/Mt86SL1eTVamncbkLQPMMj1cU8ohtKMPsNDpoziF1U2YL2/phErnVtEPpe8VGiYkRxW1oHeVJxkGXu5hQbWGLyTuGWl65zdiOH5bBep/ZUUviwWMrP7Ra97oLGbkQymrc72KSvaawwB48NM6nzaRlVQDXxDjxoXkYT9X1g0iIJrDKPxaqJ9nFQdBojheF6YfIrbRHKnjDyk66L44aUb
 N5tTs9CX
 IaGXkrya0fjI2SGzhJmDoQQjjSBxDbtq/XpNW/GNNRA5eX5mNyWMo2lYLpae33KF6Eh43Cmu84m0VAEO6NlOs+eY2JUuTSD4x3yxuyeWkaY/+qa4Z/9cUMtdW4nVjMrCUlsebbc+wIEZ5Wllqv6+IU3GJvPKJ+muWH0tljLLoJTnYsQiyus365WAkHqbNSxHt0tuCtHRJGfmOTmy4YlSaCOyL2shD5wpt7YpTb4x4emPjqlu6j3MPDWndYn00s6xVTFrfGfDrbM9HAU0sha1wzzFit9KYXHqc0w2iRLt92jMmbQVO9pxBY3qg9np71y+QoX+EkyzOpLwYaUMiMeprJImW3bjFh37Hj4sE7yHSpzj3Ktq4xmHYEHgYb6x8vfnSKkoeFTTA8EXRr5f0QBoPk289JXFsvUN7r2D3jBB1KveWbYpH1kqIKCuRGqTqf6eKuuBkn4Oqd/spAS8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is a spelling mistake in ksft_test_result_fail messages. Fix them.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 tools/testing/selftests/mm/mremap_test.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index fccf9e797a0c..774cdba102fc 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -525,10 +525,10 @@ static void mremap_move_multiple_vmas(unsigned int pattern_seed,
 out:
 	if (success)
 		ksft_test_result_pass("%s%s\n", test_name,
-				      dont_unmap ? " [dontunnmap]" : "");
+				      dont_unmap ? " [dontunmap]" : "");
 	else
 		ksft_test_result_fail("%s%s\n", test_name,
-				      dont_unmap ? " [dontunnmap]" : "");
+				      dont_unmap ? " [dontunmap]" : "");
 }
 
 static void mremap_shrink_multiple_vmas(unsigned long page_size,
@@ -727,10 +727,10 @@ static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
 out:
 	if (success)
 		ksft_test_result_pass("%s%s\n", test_name,
-				      dont_unmap ? " [dontunnmap]" : "");
+				      dont_unmap ? " [dontunmap]" : "");
 	else
 		ksft_test_result_fail("%s%s\n", test_name,
-				      dont_unmap ? " [dontunnmap]" : "");
+				      dont_unmap ? " [dontunmap]" : "");
 }
 
 /* Returns the time taken for the remap on success else returns -1. */
-- 
2.50.0


