Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48158CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 15:40:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD0A46B00CD; Wed, 13 May 2026 11:40:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA70C6B00CE; Wed, 13 May 2026 11:40:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 996286B00CF; Wed, 13 May 2026 11:40:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 861826B00CD
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:40:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3566DA01CB
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:40:14 +0000 (UTC)
X-FDA: 84762807948.30.8F87137
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf11.hostedemail.com (Postfix) with ESMTP id 62CFE4000F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:40:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="aQ4Cvp/Y";
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf11.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778686812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Vsk6nSS0BOaYjUJQEKvY7BmM0q9+NfGVkftVEcz+BE=;
	b=Ujcd6J/e9QuTZdJ/t4PYz8cGWvz5V4RSUhfgrEin4bfBSrneWe9IUvYHprrLBopcsRM2k9
	If7kwH4EcnLzVJevWah+qhEGjk99yq+d2dagd0k1G9WbdgTW23yqBQ9U031Qjj2G8vJ4tk
	7oY+Erci3Do27Ue8QhnqznfyoIBtN3A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778686812; a=rsa-sha256;
	cv=none;
	b=cqJbxSW9X4Sb+rVXiJw3LtjtOL1FieKLFLsRrxTG5eiQPjsNIszG7ik2DP6MEzjao1AJBX
	4O6Ka/zmzgHDFJUf3hFupUatl+HvfJ49pDjKtHuAbynHSk1++rlZh9b8o4k3NexJDxKZ83
	iJQiUZhisMfYDPoEzhYAOkHsIWdz2CE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="aQ4Cvp/Y";
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf11.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=/Vsk6nSS0BOaYjUJQEKvY7BmM0q9+NfGVkftVEcz+BE=; b=aQ4Cvp/YxlgHKNRQHETVoEJvhL
	BMOkYClOlNIXJJRjlJ/F694viN0dxD3UgGvcP/rUjQjRRAGEFx7f6WEJFClSwHGZQWr3tB64zZSIi
	+3wpLPwhupyY+By42bkZlqEmH21ZW6Q6G0kbyhMIFWEVCcBmHMpPw5VEVQfC9IAx6CcyGz2iNDcBz
	pWW63czKtD8eGFLVdo+q3o7QTEMfxBvt8K/awG7Ng+fNmLcFVHFfWAprYZLSe44nmIMShQFgUAbXD
	0RoOaTSddktyYl+t6txa+T3AMLC2fKhJGWLK5ZSD5EKdiL804qR3JnM0EDBOWKu41PQO66J9dvmUt
	mAjMaP4Q==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wNBgu-003GUf-0L;
	Wed, 13 May 2026 15:40:08 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 13 May 2026 08:39:35 -0700
Subject: [PATCH v7 4/6] mm/memory-failure: short-circuit PG_reserved before
 get_hwpoison_page()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260513-ecc_panic-v7-4-be2e578e61da@debian.org>
References: <20260513-ecc_panic-v7-0-be2e578e61da@debian.org>
In-Reply-To: <20260513-ecc_panic-v7-0-be2e578e61da@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, linux-trace-kernel@vger.kernel.org, 
 kernel-team@meta.com, Lance Yang <lance.yang@linux.dev>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=1758; i=leitao@debian.org;
 h=from:subject:message-id; bh=0MzegEQa6mNO2V3I1Z6SLe0wht+O4Co94Tkz7tlZ2NE=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqBJs7KSP0K2Cs2gg9fb0ISbMpl7DyiUxMygPBA
 KXOdR++hVmJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCagSbOwAKCRA1o5Of/Hh3
 bc9DD/4nNbluygUYNKOBrciOIa+JY5x3LkUt0UJqRQmgFYINakvCeFSRKWudJYoU8Zj2LDinbwL
 CIDqZeXUALFdVp7mQ9RJyXFKw02qJK2xZM2ZHLvUkoapQwDs2tcY39eXOUgkYSlo5a5S7t5MrQI
 pbSmGUTZLICxbUc0tMXa4Jp+XPL6shtQ8cNJTZLtH57HZ7p/mrJHXCiFem3GB6KcvYxCGDESgxM
 Socfz7gkdIavesqzPQGxaYcPSllviC1KznNMf/yTK6BsKqFES1SN9riGEtwEvLrjnfi3kHcZvvp
 l/5p+ZahKyv6Hp2KoQsmEggQTcHSzDLQlOHvk2W+RkST7IUND1kgaCsbOjAZcblJsT9aoc5VYaK
 HXMwfaQrDTXYc8uxKpU94CteM5W3jD1dWG8fUIb4NNSX3m+q35IpAcy6V2KDef+aoJgk9nXCQjU
 rkWvD9Ls9D9soYjUJKDI08lhzIJQxegyZpysuHli9Whygy5mOfUFGMNMiPNF+Kejry7c68XtvQz
 31fpDl2XC65FlyUA/lWBc8hhyX8T3SzlbgImHhRd3n5yTj+XsiX4uvb6yQaLbEiEr/BX4tttEDx
 I3rHgjFk6P7FskMuBEaNMof/si/JbrmpAG9Jt6BaxgMvEui3KCUpsVAc2N2IIqAECL7Ixo6wOMl
 hsX4XCagr7RsqNg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 62CFE4000F
X-Stat-Signature: xt7maz9z6diuszqjqm56ukqjufspk5yj
X-Rspam-User: 
X-HE-Tag: 1778686812-212751
X-HE-Meta: U2FsdGVkX1/kk5JEoegtZY1kzyB2UIPu1cpIomUrZ0mfQgfj7QbjjQyNUEb/Lb5BG3uTfkUTDLytFc1nk8ylQextXHZ5LIFVgz3ErQqA2Sk9FeTWucL/SjbgmUyEoVRtlpdmjUuYPEyHBgt8G42dwNV4Ku0d0jr9rX8fdrxc9V1SEhN7tW8zosm3x31bCW84xpl1y4022jMkI7pZJwdXZkqrPov41ELkzlzLKOtPRAq1/Uq3x9mjWdeyg+p0s2vEFmPGKp3G8iCuHrqyHUqHPH4Ho6AOFrpTKJy3500K2t4Kb7OJivpS965na/TeDjVxvz6Tpv4/ihSXZKi+DjguiDl0g4Imy1okx7j+jodHjuN+kw/FOhvF2UUOXUMiO4OU9g8wMQu/bEKHVDzuMl9kA9IMdDVHl4C4HPRkYm9YG7OxoYjyiEWThuOlWXm2vUbOnswi+HB9rSQPTFcWYPGrYfK5vuhSesgvtwg4ICT6hnHkc9nJL4jxXCUqUoJXXrKuqcPe/W54LO1SD6JUTJiiqN9eDjkPv4Rmxr6NJhS6S4HzBcgVLWNLQYAjIVXrG2sej36ENfG+q6DQtPQfMYtxhTpT+RxYrlTT4Y0VXsP7Mz8VNypZpoGd+Va5QWw2c+tgpC4wl796QiJyCMZSwkLDeXiscUAks92ZaPZNqjzzfJgjaXtVr7SEpkQVeytExQRmMvVmJtVEUkx5jKXfyAALMYO9mwq8amZi00m0+wm6Ai68vlArIArhI7jnn7PsGPXqcKo3c3HrjBqWAxHtGsbsF8Iega/DWCTSZdWeLXYlIqbaxjzQ4Da3FRM4G2wWV+LoigxJJQOM+A8c+2D8gAGZNY2qDohTbLVW4b+X3MvYkGUA2C+EYxE+5dc3ObPt3IhDT8nmeKrzfUv0R7J4qaE3mpVhGHlH/kZdJdEBvzN6s3yWr3L3jkdfCqkUdkLx7bCIyq3bYmh6sAOmy8Zd+gS
 CY6qSMAo
 xL/MCZHnbwaKfMqoc9Itxg+z9U/bDhmn0syGPJUteAG/vCnEaYWLFfA2L2HT5lxA/LTPzIZNjjzsjIN0o2tAAfo3RloqBf8Bw5+swxSTo3ieimTu1gms5Qmmq9GS/1QSHT8lNWLsCfMWgErgKz3mPeNPPJIH70IoLf4/8Z4tPXMEhlDxDxb90bCN1Wxj1srrT0RlvSOhDXLvhVNsvMDCJ27pOPznM53+oh9RCKivkKpyjEJ9Q4ymRFRTsZ/4vIe+imAm7VeujCjBv9ENoqFxeJWsFYOaOqTWv0BpfxXa+9AxzFQRFpbLnzM4JEjIks2im/FGKx/HRfkC31+fWh0DySSun7IlI+8s25+uGk53xJyigmF8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The previous patch already classifies PG_reserved pages as
MF_MSG_KERNEL through the long path: get_hwpoison_page() calls
__get_hwpoison_page() which fails HWPoisonHandlable(), get_any_page()
exhausts its shake_page() retry budget, and the resulting
-ENOTRECOVERABLE is mapped to MF_MSG_KERNEL by the switch.  The
outcome is correct but the work in between is wasted: shake_page()
cannot turn a reserved page into a handlable one.

Detect PG_reserved up front in memory_failure() and report
MF_MSG_KERNEL directly.  put_ref_page() releases the caller's
reference when MF_COUNT_INCREASED is set, which is important on the
MADV_HWPOISON path where get_user_pages_fast() holds a reference
across the call.

Suggested-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/memory-failure.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 4b3a5d4190a07..8ba3df21d1270 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2398,6 +2398,19 @@ int memory_failure(unsigned long pfn, int flags)
 		goto unlock_mutex;
 	}
 
+	/*
+	 * PG_reserved pages are kernel-owned (memblock reservations,
+	 * driver reservations, ...) and cannot be recovered.  Skip the
+	 * get_hwpoison_page() lifecycle dance and report MF_MSG_KERNEL
+	 * straight away; HWPoisonHandlable() would just keep rejecting
+	 * the page through the retry budget anyway.
+	 */
+	if (PageReserved(p)) {
+		put_ref_page(pfn, flags);
+		res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);
+		goto unlock_mutex;
+	}
+
 	/*
 	 * We need/can do nothing about count=0 pages.
 	 * 1) it's a free page, and therefore in safe hand:

-- 
2.53.0-Meta


