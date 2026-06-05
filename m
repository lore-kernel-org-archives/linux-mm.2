Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E773CCD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 18:42:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 324AC6B00B8; Fri,  5 Jun 2026 14:42:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FC226B00BA; Fri,  5 Jun 2026 14:42:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 211846B00BB; Fri,  5 Jun 2026 14:42:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0EC716B00B8
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:42:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A2C25140186
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:42:04 +0000 (UTC)
X-FDA: 84846728568.25.BD5A53C
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf21.hostedemail.com (Postfix) with ESMTP id E7F411C0007
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:42:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=trailofbits.com header.s=google header.b="DFJKT/Af";
	spf=pass (imf21.hostedemail.com: domain of sam.moelius@trailofbits.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=sam.moelius@trailofbits.com;
	dmarc=pass (policy=reject) header.from=trailofbits.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780684923;
	b=K62GYWNfFs+Q6h3ALWhgmxZWAmMAu3XLdkipNWd5/cnb5PoG8UqZRjTbdStzzcJq7Nb4Wk
	gLSTxwKfGg3ZDGXEJNgypqfeTNs1pVXCxVsfxKRhzJwbEJ65qlrEo7KievqFZOriolz0eN
	WYQ1FweWuDmXvp5/YplvvinKR4jpikE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=trailofbits.com header.s=google header.b="DFJKT/Af";
	spf=pass (imf21.hostedemail.com: domain of sam.moelius@trailofbits.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=sam.moelius@trailofbits.com;
	dmarc=pass (policy=reject) header.from=trailofbits.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780684923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9dziyAFDBMS+ZSt7oFPGlKy1Vv4XAHLNgQ9Ot2eQsEo=;
	b=gOVGIO/OPcrrNUVj0bru4xkyN683HMZbDsHpitqlpW+kNrrMBuW6F1kZfig4w9+eO/1YxE
	ULXK8zv3z6j0DqIP+VeXAB80ieEnrqBNpf8ZJVtAcIPCbvYhBMNxtofWUjH4drcKr0j5lR
	rFRI2Eqvnt9BtALkVpc7vIRbUE2vjSw=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-517863a2edfso17686911cf.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 11:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1780684922; x=1781289722; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9dziyAFDBMS+ZSt7oFPGlKy1Vv4XAHLNgQ9Ot2eQsEo=;
        b=DFJKT/Afnp4MZRv0LzF6yzekOX1rMR2fbwmmeRF880qrP74TUDqD9vq0tl993m06yw
         /jtMVVtsDs+PH444EPdGew3GmAJ8SpPt2aHaw4pymWH+dflYJWuSLm7w3INjxjsIMAeR
         Lc48anGERhS7YichTdRNyALzuT3k1y9R+d4treJV9LWapMm5Vis3UrszaSna2JoCmdSR
         ZkV1moCJUf5DOeuej9OjXynjNSinKCsAbbOUTvjHAHanHmDQV05Ir7sGlofe/ufDsYKR
         IXq9OclXyrgye1jwy1YfZSBhJNdAa7CuINh+I/7TMESC8VR5N7oP4owgXjLjfvOH8XV8
         C/gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780684922; x=1781289722;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9dziyAFDBMS+ZSt7oFPGlKy1Vv4XAHLNgQ9Ot2eQsEo=;
        b=P4/LRvkYem+YulLAP6lCKFEtXByZc76d4YG0q1iB9n5cz4N66Gz3BlY12NCnNBJMKc
         OSRdKoUjweBdTkh0VLETuW59gWSRebOTbcPUXQztVmPgtFG9uxAMcoFRYaW9w32udHMJ
         MKjik+98dw8UxB+r8M/gIkHmFUlur2gApFMhIks5lIyIfTLAAhAe4DwTo3hgmAymmCe5
         K+Tmur2etm16WTcVljdLRhDLtRY6yAzpLaKAbBERoGV354HVptZ+RsMbNxPML+IY9gjG
         D9Fc6q2uatQOLcq24Ba8yvxDcDC256OPNsp/ncQFwrvSrt+66MBTOKRBx1NJf6qlj6xF
         ug3g==
X-Forwarded-Encrypted: i=1; AFNElJ+TI6ni0JaTUmbQsmqiE/b0qoMIWVtPc1SQgAWcelXCCk+O5zYizaReXFgopzRs31+7hZNqfJsTRA==@kvack.org
X-Gm-Message-State: AOJu0YxxFbq/RSOEurI1MUxpRIBUlH9SS7rwWNqg9k5+ZJBJtBXelBIk
	VagOF596J/nNa0hqKe3bxwbDtDh5T1HXUySuXoF/QAQnSgjtTmVuz11xjDvefnVe99o=
X-Gm-Gg: Acq92OGH8g02PSHtrQEFmA6BrjvA7eH7y9lFrtDaNvVCS1WtJBhohGjxot308z5sGGa
	oArlXcl6JvqvQ+Pjhs92XiCiCYYsUR/PsJ/iAT6X7Yz1Zmbbf4h1nhtWsbOEkicV1KdtXH8bf25
	M4Y/760n3RTqKoKtg70tho+aqC6pnsYHCssPLxd8NWZ3gxOT0d5yfwnlT3eB+wjBqCYQBxKnm+H
	XBiSgeO39tYOyZc7VTfBBfD3bSaY0p8AQIbkDurddAroRSldrCOGHUUJaM/QIHCyzGQmDTSExMm
	DEy3dRJ3nR12GH136IIue7s+JXnjOj+4Jik2+en3BcIYrLP1h3CwpoHPsRPH0reppgLJPKGtmdP
	yMno/vj876C84SZbWpzBFSnEW7ko5hEmGW24fipW2YEi1rlcCgAR5PEJ20ZePELcA1VPaXd3WZW
	cNZpGHzoiuliMQ1IAbze1l8mzygFtzUpfc/kv4Wg==
X-Received: by 2002:a05:622a:4c13:b0:517:8f2e:5d9e with SMTP id d75a77b69052e-51795a71833mr68589031cf.7.1780684921860;
        Fri, 05 Jun 2026 11:42:01 -0700 (PDT)
Received: from localhost ([161.35.96.86])
        by smtp.gmail.com with UTF8SMTPSA id d75a77b69052e-51775c2e2casm85460011cf.9.2026.06.05.11.42.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2026 11:42:01 -0700 (PDT)
From: Samuel Moelius <sam.moelius@trailofbits.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Samuel Moelius <sam.moelius@trailofbits.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org (open list:MEMORY MANAGEMENT - MISC),
	linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] mm/page_frag: reject invalid CPUs in page_frag_test
Date: Fri,  5 Jun 2026 18:41:52 +0000
Message-ID: <20260605184157.2490353-1-sam.moelius@trailofbits.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E7F411C0007
X-Stat-Signature: 34cbefhokspo614ues1xorowzrn6d1dy
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780684922-767637
X-HE-Meta: U2FsdGVkX1/rnWxiFOrbq8BEtwDgT9CjMsX0YI19iV+QvHLFcc5T4kXhux568efsThKYvRuS+tDngFhYAop+pbzyJCtywyC2Zgsqe0+i7psgeVRLqF1qnwmiTHvvVvUB3gBJWfNaPeVEEe6+l6WZwjbFs1320AatTilDjVbXh9Vl+MifkGFadJ4PnX/9Kc328G0hx9xOgI2AXCyM6Qv27h3nuWKMzpm0ZhFg32cFCIHdMha0k2VoXYwXq6xGZVC+3KSKSRF1zuzRY+nzQny6zMjSWA7qEEn46afYSHJNU0D2pfB6c1wFAMtb+Q3q6uZIpWWEYFakooGkKlB1831s1w3231fLZt8M+O2eCRuxuvu7M3JfLpZi1y42feiRuxvna42adkUhUSNC/3Dd9x5cwGtQLI8Zq+LUF5/u8UeQ1Ht9P5rAWqqyCG46jxbqY+Ez61SIEuS8v1/mIxUaNKGh7VYngMLiF1GJdF1/ZquRl6ta81XhjvCc9kS/Wdnt0zKHEuoeazdv/j7MQrkwWDeoXJiwbo/2JWH7ATwOqzLlt07UsZOjClalBmfpkz1xbfI2tlVl7/PWuosqeA3aGwGqX4uO0Li9soHAx6U2WMAwzeDFUkOmYiLQOlMvN42reT3YIRfLhwdnNS2IaYG7OfIRVupXX59x1bTVFHYL34+MFEFty7WeoQ6Ycaib6gLtNPPgfFU78LAi9Y8NTBEECHkobnRZlE/GIdlSRrUUyPxNMLaOHfPyvK39TjD56VJFf7g5/Eersb7Mye96zI5oYCUL5eHJLV4Jf0HASfkjCtqK5I8zo6KV0dOhhBqSNpdITsffCvAzW2JkCkQNUk1ELcC/fLkS6YmdrWHxD+aH+mgOq4fZrEqr9sAMl/i80Lklr25Pj7Q3l9HlJaTxVkCXWf/2onXGsz5al8pA+4urLO21OLwA00fAZ0wytYBJSrhljQbX509SOgVoNGNV7UliGJF
 wfWjCwZz
 zPJVzl2dcBrq+axaCzMMBEPBDc7O/vQoS3OJIRs7kQBF6n3WxtWwQVSPNwdLOhSWxWzCjCGXwTb9ScnNbv2hl3+PlsPPV+0ifOPCR8KoChn+qSEauN+zXyZIAUI2lLIh6ebBhAAX0Qlv+2E5Cm0tAqHmS5JNTZd3ogZuVOobmlXyiSeCLba51fVdcENCnWC3VxPpl0uxVVSvdiWMswy0lcbUOx4V959bRcCajjcrRVevd/V7wGSCoucvCVZ++ewfXq5koqZQPygzwouPYg4kk+0DRvP7nx42+bZ6cqzY+0ppsuHHTWRbp0INGMSWvReenUiFhWFPYGfsJdexK2b6UL0oNJ74/KyDTCeC5LK/BPQ96iR6WBpvGIZAVUUr8VP8DyEaCpfgJw3xSMLTkdtsIOxnEbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The page_frag selftest module accepts test_push_cpu and test_pop_cpu as
signed module parameters, then validates them by passing them directly
to cpu_active().

That validation is itself unsafe for negative or out-of-range CPU
numbers. For example, test_push_cpu=-1 is converted to a very large
unsigned CPU number before cpu_active() reaches cpumask_test_cpu(),
which trips the cpumask range check with CONFIG_DEBUG_PER_CPU_MAPS
enabled.

Reject CPU values outside [0, nr_cpu_ids) before asking whether the CPU
is active.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
---
 tools/testing/selftests/mm/page_frag/page_frag_test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/mm/page_frag/page_frag_test.c b/tools/testing/selftests/mm/page_frag/page_frag_test.c
index e806c1866e36..c8584d0fdeab 100644
--- a/tools/testing/selftests/mm/page_frag/page_frag_test.c
+++ b/tools/testing/selftests/mm/page_frag/page_frag_test.c
@@ -131,6 +131,8 @@ static int __init page_frag_test_init(void)
 	init_completion(&wait);
 
 	if (test_alloc_len > PAGE_SIZE || test_alloc_len <= 0 ||
+	    test_push_cpu < 0 || test_push_cpu >= nr_cpu_ids ||
+	    test_pop_cpu < 0 || test_pop_cpu >= nr_cpu_ids ||
 	    !cpu_active(test_push_cpu) || !cpu_active(test_pop_cpu))
 		return -EINVAL;
 
-- 
2.43.0


