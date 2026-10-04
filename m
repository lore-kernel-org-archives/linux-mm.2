Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5C48CA5FF0
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 23:00:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6079D6B0088; Sun,  4 Oct 2026 19:00:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B89C6B008C; Sun,  4 Oct 2026 19:00:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CDAA6B0092; Sun,  4 Oct 2026 19:00:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C82B6B0088
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 19:00:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 86830140BE4
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 23:00:34 +0000 (UTC)
X-FDA: 85286464788.29.0459596
Received: from mail-wm2-f7.google.com (mail-wm2-f7.google.com [74.125.225.135])
	by imf15.hostedemail.com (Postfix) with ESMTP id B3BA1A0006
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 23:00:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZasmYC5e;
	spf=pass (imf15.hostedemail.com: domain of jaeyeon.lee.dev@gmail.com designates 74.125.225.135 as permitted sender) smtp.mailfrom=jaeyeon.lee.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791154832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s/9bjhbBPUpWaue8GUHQjnboGL/2wNmsZKJPcvc1aM8=;
	b=GzLTYTASjmNwED8zVvZaQ7vcFmp59mEhXMXxpvqzoXrNw3ujEYUL7QueZoMAAMO3ZNh23D
	GZ3wUAIXagk7FYNRn+n0r0/6PXNYKTrvFygy8r1p/7K9Au8i0GfCQJM7LblqvtEyPFIgDs
	FN0CKEE7FI73w1Ha5247eOqsmyXGQsE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791154832;
	b=HjqAcUuD5Sz687pB3QTpQKbikj0u3hPYHap9XefxIXf6EvQrw9j+jAlSuMAH//2zIpOljN
	KyzTmWa3CEPF8ntr84OuNZb65avVIao2q0XKEVihKRqZv+EK06unQBlTIyJs1GyH0SnPrd
	v24J+te3+xXDyujbWNL8H0gbIwSc/qk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZasmYC5e;
	spf=pass (imf15.hostedemail.com: domain of jaeyeon.lee.dev@gmail.com designates 74.125.225.135 as permitted sender) smtp.mailfrom=jaeyeon.lee.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm2-f7.google.com with SMTP id 5b1f17b1804b1-49e8361492fso5919645e9.0
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 16:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791154831; x=1791759631; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s/9bjhbBPUpWaue8GUHQjnboGL/2wNmsZKJPcvc1aM8=;
        b=ZasmYC5eU6EXjS2R4XTJIgK9aV+yno07u02657mYt7nVt4lXUMCRX3PFLjWIOpS/+i
         WEPdiI4h8gNxF4pXgvaHI0APYk9gatStk7OQ7A9DiixWZKWSqGglP6xvZm1DM+Mjk946
         /pUV4w0A0s1rBuxKxxIt2gCXZs6j51CERFOViPbu7tS725nuV/GWLM7iH5+7R/V5RZfm
         DTHlLRT69hmfhWEsXOENkwSjaxHabM6JjTrVIu3F28YdFyoIflUkKm/L30J6oLaBotjv
         jdfauZQ/zhrLsWr2WvN5p4sJGUmdMCfmrWcswl7g9y4UYlr9RuFRsmJ6UqjE8PlF+wNK
         K25Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791154831; x=1791759631;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=s/9bjhbBPUpWaue8GUHQjnboGL/2wNmsZKJPcvc1aM8=;
        b=oVBwLlz+5971Yxq1gH8AXCrjb+kh1QuX2Fo1f3GENUbT/5YZCKARAhmD5IzuhblOyH
         j2bEVJi+zD/QS49ordw5z/KAbfLUWUVbZHbY3qHUkqkK18tHlArNt5VxgFFk+FHZZzv9
         3yW0i/ehJuDma6AMu9ah/uyTMQv+b+HPek4lwxib1lHV/AZSimpS/BVQQosv0isOuz4R
         FXsziSbyZJ/4jWbucCwlhf7WJQCFpDQVSFAmVZHPamqaqx8mUpiEXiaQE4L+6L7g10oo
         G0xQLUaGuaSg7gV+BjzEuopbkOyqmfTv0mfaA1ZxygW1JTZRXh8HyWaTY/sh1KyuYZZg
         3LFQ==
X-Forwarded-Encrypted: i=1; AKwUvBz9ZFGBX4jTwStD9yMt+ySaIDyulInIiAhZWh+aN0DU+vyWhN2HOt4Wra3XqmKkDqcnwuz5ZqkhWA==@kvack.org
X-Gm-Message-State: AFuF++mYOMkt1BlgoPY0WZaTEtcgBGY0keVgepuhNmacxz2brWOpJq71
	v32kjcTANk8WWbW8qpJuvoAIgSsRnALs8A77XfzFqPXZlCDEfKuzZr2i
X-Gm-Gg: AYBFou1auWxOtbJeXgZbIWJg5gaRdz5+1NJCGVxLqRVSCM7IT6rwTfuR7A7C/AnOXgi
	x/WT0WoHV8BOIzDTs3b/w40buvKhJngP86vPnd4qMlzuFZicRDwlADINd2RTCgAaKTUuaVlnWYo
	O8W8O/wphLGRswtD1ZPjcuCTSSXZv+hO+10+pPCfxuCYOs1x8gnTJeFc8niO+6T4oqiASpws8xB
	vBVNxd+dP7XVrwH7/QPZD4FTY0PXPfluP3IUjrc53i+6cpT0ryna3R+zfmMBviqXHJ3bAKjG6Wb
	OKjKgl+CkBofGlOJFWEpXhBkeN/bZALCzeGQRLGx/YoPbjZTX/ive0lyKIvCa9PNLtpey0aUtW8
	jThUvRAAHJPZa25TaE8w1E6T7l/+72dnE4s2jKOxR4uuY39WHnhgDKtD5NgqpmV7Qzb/shhnywV
	Op43gKXoPaJpVTD4PDGtF1waKxani75yCTz0oJM7ESiO0+c+8urAeSxFurPtYdXmhcPP6V6gQF2
	pTWpjt8A/J1Jasg6Pd6uFg6ngpFxmfqh5ONkWNWgeuKTocuISsDdAFh1Gulu3H13YDoAOHAUvam
	/E2Dwip15CsP42w66doiXPYpkPjC6Dkezw==
X-Received: by 2002:a05:600c:3e06:b0:4a1:6ad5:257d with SMTP id 5b1f17b1804b1-4a16d3d5c54mr70770065e9.29.1791154831127;
        Sun, 04 Oct 2026 16:00:31 -0700 (PDT)
Received: from lima-kernel.telekom.ip (84-115-220-212.cable.dynamic.surfer.at. [84.115.220.212])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a16bcb9a21sm240046315e9.10.2026.10.04.16.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 16:00:30 -0700 (PDT)
From: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Guillaume Morin <guillaume@morinfr.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Subject: [PATCH] selftests/mm: hugetlb_madv_vs_map: fix TAP plan mismatches
Date: Mon,  5 Oct 2026 01:00:18 +0200
Message-ID: <20261004230018.190880-1-jaeyeon.lee.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <aqgUdbtumaO8RiIb@bender.morinfr.org>
References: <aqgUdbtumaO8RiIb@bender.morinfr.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B3BA1A0006
X-Stat-Signature: 444r8phbo6r3cr5u16fa5kq64g78hek5
X-Rspam-User: 
X-HE-Tag: 1791154832-801403
X-HE-Meta: U2FsdGVkX1/mkkv1mh5iHlDDZuYu3u5IFSfgrSCMniTng7N2ZmsFKx5RE5zPzY0Le8CkLi9ulYgAto+xrrvndWbueew8zXatl3P9j8QaPSwp1oNnRNojzX37iGqQPDaSpWTgmLQBrcDyo/Ayesov5hLnqhse8ZAMnffPM8aERJfw9foacAemZ67VoQGUlUoDFSyPIcIOZXk9AAk33WmtQqn+0/kRsZvIsgFijn5fd14o9Fzlje6eDZsVexxDtBouIuGGVpxMsLddSNzF1G3wXOyPlCq1ovG/6VrTSuYqbsK9rVGqcNQk1QHX1KIV8RQIRQLofwnR0zR4PXuTthbSA8WFB8qtl7lR0fTJ1VFdw9mqe6eShV6LFgtx2l+a1Tj0yuxYrbPmBWrEqS1gkyPBNc3trmFZbAJpM83vevGIgtmgLkfNRt+H8jNDawS6RNvt4rDCcQE+cBytWq/VErjB1Cm7mVGwaq1kOMCiGq5921JpXJc1+KMpm24J+EaOUVCeg1R/mYlYLEQbdACw9fxK/sW+SI+/RCsSkK0cJgVMKYQPvR5lLlG7aukqnu/wZv8Gi1gRZg6VoJb4HvKhriA4yOzZqAucikjFwCj1DMmzavK3wxHxfK1lGK/9DBwv+3TwAcSaRatJWAxlVogBsoL80rKVq2KYN9DWrE14puMovWLYiwXluOXg/VJ84b6ge0aedVhQHGKhQpLQTAvGXhIH6k8r3mQr+mkSqgkviiu0vHVn3OgCBkmzG2pS1mAKiOamjoUTYY9JbaadKJbqUj5LxSjpMUFBTnXU+FALQxqgS8PoN4inXs1PsYGykqj/+IeZeWFK7sMZiRnlz0u6EThsk9Uvsz32bWKX+HnlTXS9cdE5sK8uid/YBURx9BoWlDOBwd7p7nBwh4lnbT3QIgEGC49G8PrvDOTzyqRJDvon/xDz00rrpxd1AkVeRpUiZ3kh3JAdU6Mx+R7a1ePwPGB
 o1y3FPm/
 8jzSjojdEULRGzTeqS/DCTZ5hJBcU3OKAAtPMpTB/XG6sf5oqokD1tDnGxYekf94AdkJvL8Gj1wqAUJLPP2ox+jcEaGceBej9IKFSwBbNLwl2S56Vp9Th1kx3CQPj/qFdCRh7svmSQQadzxkXkk3T4G5t9PHSREF9N+T8455Yxvh21tENKzTnJuZ0qKhxbV9tWdAqzksVvX7ZuL7Avd1+tikLY8ZXQpO5P3YvcXg64F4IVy6f/DWiLP70v15CfCpC7gUEC7IM6EP20pNqj7PAcsddiy64pmIdxxGevXEJHgfazvcMEqwuDb49NBGOekS4I8cX/1dGBHrqG0nfoQB3WjdyU7rWvZog5plwYSd2TSBiinueyrGBuN2p6r4e1/PvT78v0saKtt3MXI+7CMs0l441e1BZz7R144JuMbEvaG/MYD4rciZb179VhL76cTaAJT2sWp0f6UMjF0HiydfuRfuhxsWJJudV/BhedUFOZMSgGu650kISlUGOROEsh1tKZYDB9aUB8TN6qmS2al4qTD2BZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The plan was raised from 1 to 3, but the HugeTLB setup check that may
call ksft_exit_skip() still runs after ksft_set_plan(), so a setup
failure reports one result against a plan of 3. Move ksft_set_plan()
below the setup check.

Also, when the underflow check fails, or munmap() fails,
test_underflow() jumps to err_cleanup and exits without reporting the
remaining results. Report the munmap() failure as a test result and
skip the final HugePages_Rsvd check in err_cleanup, so the output
always contains the planned 3 results.

Fixes: 827149aad495 ("selftests/mm: hugetlb_madv_vs_map: add underflow test")
Assisted-by: LLM
Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
---
 tools/testing/selftests/mm/hugetlb_madv_vs_map.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
index 1d111f42dd59..5dc44ff0a377 100644
--- a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
+++ b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
@@ -169,6 +169,7 @@ void test_underflow(void)
 	/* First unmap, this will close the vma */
 	if (munmap(huge_ptr, mmap_size) != 0) {
 		ksft_perror("munmap failed");
+		ksft_test_result_fail("munmap failed\n");
 		goto err_cleanup;
 	}
 
@@ -203,18 +204,20 @@ void test_underflow(void)
 	if (waitpid(pid, NULL, 0) <= 0)
 		ksft_exit_fail_perror("waitpid failed");
 
+	ksft_test_result_skip("HugePages_Rsvd check after child exit\n");
 	ksft_exit_fail();
 }
 
 int main(void)
 {
 	ksft_print_header();
-	ksft_set_plan(3);
 
 	if (!hugetlb_setup_default_exact(1))
 		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
 			       hugetlb_free_default_pages());
 
+	ksft_set_plan(3);
+
 	test_madv_vs_map();
 	test_underflow();
 
-- 
2.43.0


