Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 985E5C9832F
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 16:24:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F5AD6B008C; Sun, 27 Sep 2026 12:24:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A6AF6B0092; Sun, 27 Sep 2026 12:24:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 695566B0093; Sun, 27 Sep 2026 12:24:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3F1AC6B008C
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 12:24:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 992D9A0AA9
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 16:24:41 +0000 (UTC)
X-FDA: 85260065562.11.DA6B6AD
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by imf21.hostedemail.com (Postfix) with ESMTP id 01BB41C0003
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 16:24:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nua1+mH4;
	spf=pass (imf21.hostedemail.com: domain of 3RUO5aggKCA4q0zzo0o6u22uzs.q20zw18B-00y9oqy.25u@flex--cmllamas.bounces.google.com designates 74.125.82.198 as permitted sender) smtp.mailfrom=3RUO5aggKCA4q0zzo0o6u22uzs.q20zw18B-00y9oqy.25u@flex--cmllamas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790526280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Z4e89CZ9LoTsSmrLA9c8CquQRkeB41VAKqizkd8WFos=;
	b=Syb3YcJgxl2tSsTExHeNkKzRp14x0ug9maJGneHVAm/EwWRPg8xKxE3WXxykPc1j9XXc18
	HbEHkUvmlY0LslQKV85ITdQ8ilJtHNP1iW+bs73tm+HTVgTVJ5NbmT0aZT+2EPitM13/DA
	xz/+s6mbNbSmnKJKxZHAGn6EA+BXHVc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790526280;
	b=8LGgZEphOWT4O8KpySjYIeYyWrphKAEpWxH+VKmGqtzXd/ZgQNH7sBP/89VwdDvZQk3UnO
	i5AJvMyyRqRc+nMUgllpcLyLXu7xojfKsx9B0xGPR+3BO/xorZFKKl3bNv/Ug+mCt2/Hvw
	27H6jKIAUvLeYgO1LGNkVMfUQ/cb5I4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nua1+mH4;
	spf=pass (imf21.hostedemail.com: domain of 3RUO5aggKCA4q0zzo0o6u22uzs.q20zw18B-00y9oqy.25u@flex--cmllamas.bounces.google.com designates 74.125.82.198 as permitted sender) smtp.mailfrom=3RUO5aggKCA4q0zzo0o6u22uzs.q20zw18B-00y9oqy.25u@flex--cmllamas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-342a0e1d8c4so2103237eec.1
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 09:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790526279; x=1791131079; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z4e89CZ9LoTsSmrLA9c8CquQRkeB41VAKqizkd8WFos=;
        b=nua1+mH4YJQ79veYi6knPtWsYyfzSjokZdcDxakdSv2z4OvdjLzCsmN5r5FmoN8IVg
         oKY7YxD/8ouIaGsZAVM3wUoN47EZ0vkDkmXWL+41TKbjQDZS2jMrxttLlg+1uvVNPeeJ
         DGYqCyW3pP427TXFhXkeOCzojUmup+X0VtmnQn4Lqia3TirLy/BCmp0h4gFGY3rVI/0T
         tv9QPlQwcPdLH5UpgPS6wZlDl+QhP2/4orXkelQ6O50kkRsMr6+Y4rhFZ/gH6IzCsvKv
         0zDms//acppaIVVdtmMccL6TjSR0VrV2ELqfnYst7cYRDutS4CVkShnrwYNPpJQ05GCy
         n70Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790526279; x=1791131079;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z4e89CZ9LoTsSmrLA9c8CquQRkeB41VAKqizkd8WFos=;
        b=IX60e/e1rgaFW2hT6k9ApgwRBRaBkMKiVhxryKAZGkG/Au5co64lpQZROmIb7Zj5la
         HAAOuoy3QoHza0Szar+RCM7N/kg8J6ltj47r7OjStZPsfH+DD1a1xJJ5ju21BtdT9U34
         S0RgSSaiRzw2ymSF9maETuGySiir8hgyENWP+RZqgXQo320FZHceekMY8JDDtIiwdFcT
         LS4TWWvjA1g78oYRcqYRYN8mr8Z+z9VFKcO7M+31dpSIFEpU+0/WIK6hgVXjdj+8OKv3
         czSS79c0wTLa+7iV2DuA0JjoRlGfiwZPFUwRKrNIeBPi0BpBndAQOZSUf20xlGCs12g7
         GU8w==
X-Forwarded-Encrypted: i=1; AKwUvBwnW7WxkFa46LLhP5MZMaXwi1If96qwIRcWN9TSwR59swX06zPFzHhx0EcppXtntt2dPjGyCuZbjA==@kvack.org
X-Gm-Message-State: AFq9FYICtfLCfliWtJ6fzOpFAqBx/5K5Dbx1HGV+6OmNo/KZSPe88dlo
	ZQf6/2Anuy8IBwE2YFthFvYbma3dVk2zdT0IoTPYeq1Otr1Df3LykbJsPh0d8/rE7s7E3hfK528
	bf8eV/Q9y802p8g==
X-Received: from dybgi42.prod.google.com ([2002:a05:7301:aa:b0:33e:6278:a7ac])
 (user=cmllamas job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:693c:65cd:b0:33f:3878:8e18 with SMTP id 5a478bee46e88-3426c6f4d95mr6381557eec.0.1790526277984;
 Sun, 27 Sep 2026 09:24:37 -0700 (PDT)
Date: Sun, 27 Sep 2026 16:24:18 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260927162419.820609-1-cmllamas@google.com>
Subject: [PATCH] selftests/mm: cleanup -Wformat issues in hugetlb-mmap
From: Carlos Llamas <cmllamas@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Shuah Khan <shuah@kernel.org>
Cc: kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Carlos Llamas <cmllamas@google.com>, 
	"open list:MEMORY MANAGEMENT - MISC" <linux-mm@kvack.org>, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 01BB41C0003
X-Stat-Signature: 3ug55533i5tp8q8xrhfmmqzj8qimzcxw
X-HE-Tag: 1790526279-687280
X-HE-Meta: U2FsdGVkX1/Ijv3+9+8njPChW4mTy9QVH0GPMtpV85ArHI4iHXxXkX3CwnIj8hDzJfuAF1plliE5bxhv8a8T1sriu0ansE1Elkbtg7dZ/vT86C/cjCnTex9aAbKwHuQIx/fp/szQsi26cRKwvV4Eekwl/1eaOTuvH2K7s2zSu0j2NAhG6QcrZzUrsnzwbz2sSuhbBamEhOhlnARZt1Z/2rgaIpZsD6yeHzjso7OdjpYboaBD/am9tkTrGD7yY9Um4ct5Q9W2YK82rpTu8aOytWc7jM5y3EjOkfBgLWUlZjm4LVvwG/eaN+N0B1DexT8RmmTNWilsr08psCEn55rOi+JTGMSXmqZPrp8ssjcmG/WdxpaOoy6UgOzJzgy2AXCDpVTIzJWkSLrqJM4eZxf5HKa12yoDEQfXnE/iFvESgJIH5ibQkBlnyqxuGtPEVqTUwid0aivzdtA9ITePH2+lAGIRVLhLA/AzrRqFGcROhhqH78AoQtUTcGq7N21cS1DJT3hD50cLDfNZR4x/pA0gFkXR5SoSyNotEgrI8O5JGIfPC2R+cYQh4/IK33DgKS6QpDLsuzTT/KL/b9/1ygWlf3mEvZ62bq7w/PUf88xLaK/1Ov7pVQAIeZwhkxUEbnclvTtdqn9rfhaTHoe5WwjrOmGqBjihweQQKRUQJHzDF0U2ebXZcvqz0u3PcVNdjUN4OZIrQxjqJq9jkdJ1VmXaVZQQqF+cMhT4lpNK6OdvvWs0xmyvjQN9+xP7at94tNXNlNxsiGNNL2dLDkkOJy1lt6TNmjS62WTr/+XhDI4i3wKh3IpLXeOjJ9nbxJZUKGe9QZfQxF5DXBTmM3Xv3iBWR1d3EEgzqjCK4Y5Hi9fIIXOFIMq+1Pntgal9Snirn7JPMmy1OOkiT6nEU2tEuwhQjlynmzeeB5+giaOtWPfWjyf4arxEmrRyHd1I8Vz4hcxMRig9m8b6Q3was79DpG+
 /MSzru7l
 Lcsgc1cBM87NljGXfTB53X0g68SPQJypC/KUhbef0itl0PZ9d8i79k1KBqPvzxuWg2QGi63P3FgawWyK8pAJeHyZDT/X3nCx0dFpEHlGuAPTxA7bUf7DR8qoptn2VgMXOWNuFA1LpW19aqqQTAsHeflQkYcoaqxbekHuCYWoHUlwiw1CRhH98QwYL4q01s76Fh93Kjm3eEN1OXm6WzWffDuTZ+QJl2U27WhfHzqjjC9YeV50k0dtxyICxBa6oLZduror3SWUzwsAk/E3yyZciFLEHzTxKYhc5Yyz20aVCPRsUexaYqN9oQ6MqZGJnZqQvYMPlXIzpm7vgcwfMFQBdQLzbxH8NyL1/FkoZAQ2fFo10PWRMBUVodCu/TUTYHOLsjHsuwhVk6IDKt4bJFZJLemg5FbpnhNid5d/PWKjkvaf7FLZHgJ4nnY6s0BC/NUtiPVx2lYGhNFJ/D2p20OW2QpTqZDsoeiBr74brIOKXOKynzTNWUTw8stWtzo6x7uXHzl0DUlCYsr2DmZHQY2cVdHyuLcPJ2lR7p4iOs4obpEZTU2Dscz7vmziadar9i3s1o3JDUQrOvam7gy1nd93mfGFMcokePWJe2GG/SCZQ++lDtUg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit ae571cd6015c ("selftests/mm: hugetlb-mmap: add setup of HugeTLB
pages") and commit 9c5a65f374f8 ("selftests/mm: merge map_hugetlb into
hugepage-mmap") added logs of 'hugepage_size' which has a size_t type.
However, the incorrect format specifier '%lu' was used which triggers
-Wformat warnings when building for 32-bit:

  hugetlb-mmap.c:125:55: warning: format specifies type 'unsigned long'
  but the argument has type 'size_t' (aka 'unsigned int') [-Wformat]
    125 | ksft_print_msg("Default size hugepages (%lu kB)\n", hugepage_size >> 10);
        |                                         ~~~         ^~~~~~~~~~~~~~~~~~~
        |                                         %zu

  hugetlb-mmap.c:134:47: warning: format specifies type 'unsigned long'
  but the argument has type 'size_t' (aka 'unsigned int') [-Wformat]
    134 | ksft_exit_skip("Not enough %lu Kb pages\n", hugepage_size >> 10);
        |                            ~~~              ^~~~~~~~~~~~~~~~~~~
        |                            %zu

Fix this by switching to the expected '%zu' format specifier.

Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
---

Note that I intentionally skipped the 'Fixes:' tag as I've been
previously suggested _not_ to use it for kselftest patches. However, I
can certainly add one if someone prefers it that way. Thanks!

 tools/testing/selftests/mm/hugetlb-mmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb-mmap.c b/tools/testing/selftests/mm/hugetlb-mmap.c
index 0f2aad1b7dbd..2edbc992e6bc 100644
--- a/tools/testing/selftests/mm/hugetlb-mmap.c
+++ b/tools/testing/selftests/mm/hugetlb-mmap.c
@@ -122,7 +122,7 @@ int main(int argc, char **argv)
 		hugepage_size = default_huge_page_size();
 		if (!hugepage_size)
 			ksft_exit_skip("Could not detect default hugetlb page size.");
-		ksft_print_msg("Default size hugepages (%lu kB)\n", hugepage_size >> 10);
+		ksft_print_msg("Default size hugepages (%zu kB)\n", hugepage_size >> 10);
 	}
 
 	/* munmap will fail if the length is not page aligned */
@@ -131,7 +131,7 @@ int main(int argc, char **argv)
 
 	hugetlb_set_nr_pages(hugepage_size, nr);
 	if (hugetlb_free_pages(hugepage_size) < nr)
-		ksft_exit_skip("Not enough %lu Kb pages\n", hugepage_size >> 10);
+		ksft_exit_skip("Not enough %zu Kb pages\n", hugepage_size >> 10);
 
 	ksft_set_plan(2);
 	ksft_print_msg("Mapping %lu Mbytes\n", (unsigned long)length >> 20);
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


