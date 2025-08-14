Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8882CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 11:39:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43FC2900143; Thu, 14 Aug 2025 07:39:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37530900121; Thu, 14 Aug 2025 07:39:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23C4C900143; Thu, 14 Aug 2025 07:39:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1023D900121
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:39:19 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A0E0F1A0662
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:39:18 +0000 (UTC)
X-FDA: 83775167196.15.5926297
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf20.hostedemail.com (Postfix) with ESMTP id E9A181C0005
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:39:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A5YyXAW8;
	spf=pass (imf20.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755171557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VZ3Ok5UmHLoHWrDAxujuogwrgdytQSS8sb0kcHc3uIw=;
	b=gqjdUaQDem40QWSspiWsVdcUfsQ2woCpMDE5TXTPJrN6FXL5cZfR2WBLmNKNBQ+83pzTL5
	kXZeBv5UCwoaRzDvDQ6mzOomdA7SyBCgU9jAScGpMAwpgd4dTxoC5fmVPN+uJMlBdH9TUZ
	nGBa9159I2neRLMXi3OvrmYqlM+JeIQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A5YyXAW8;
	spf=pass (imf20.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755171557; a=rsa-sha256;
	cv=none;
	b=f+hf0O1+ujBnsxJv1k0IB6b1TOeLgiyjz3cBnb8372B8f8xy0AXgT5NKVRRD2mBSguht2J
	CRb4In9bblgOQQq7RSq1EgZhvNj7u7k51fSorzc7O/2B/PJJFgzq22Sj34ek4Jp7ZJpl0q
	ngmxJuYwpjwTBVOPajJ16/2uGeVEPOs=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b471740e488so821090a12.1
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 04:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755171556; x=1755776356; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VZ3Ok5UmHLoHWrDAxujuogwrgdytQSS8sb0kcHc3uIw=;
        b=A5YyXAW87LhTJ1Wax1UZMr2xBtsXzAcYXQ5I0/zmlKKQ31JaCMZloN1fe0irgg8Ff1
         oBf12MwJMDF/tPLQ5P4Gdka/WAanEtymeH93GDHIxS986XOwPGMEbK5/eQAABYRaUGud
         mgmOroEeMLkRrtk2mHl3QcdTvfuVInBASmFg5/h1NI+wqgqWz9cKuOa7CStugM0AEPO7
         yCEvkgDM8ZUOkrsmvtEfcPcrd7YHcIHKBkc9DcCRxjf+8aUmNgq8wNQhNUp/8PYTqTqC
         RcUP26w4A2Qlq3NIMG7B3kIHse60vgrjHTe6x97lw5peaddjeIniWKA7UJ44RZvVhWKy
         T7Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755171556; x=1755776356;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VZ3Ok5UmHLoHWrDAxujuogwrgdytQSS8sb0kcHc3uIw=;
        b=P15A5Mab3oHNeFesL6D/HpV84AyjnGKeVD2DH7ZFKfilnmRycKxZcQVSiC+mpH4QHE
         Vt25hGTME0JD6N6c4m3UAsEBbPE0UHzVeW3gqsrnSE2kBmqEDDBQsCV2lDhuFqpiCj0Z
         NiJsj29vuZgNOFQBloi4Ad5mphQSD5uW6S4MT8bc9AOmNEti8OwOWX4ttHppGdC3a3F3
         0KD4RihkzXZrYb9WBe2b2vjurRctnu2M55Wfcv4dXCHvswNqYzTLVPqkHQiG8PoTMubK
         w7uey6hSyCXc82367wGq+CHXv60Rlokmk8OztvrXRGkR/+VCH4iQdtqtVnxfWxfdCDnG
         fcmg==
X-Gm-Message-State: AOJu0Yxo7IaBL2ONHHirbQwpkGJB6bwXRNRUlHfWTiJAtscr1LzHhyRK
	RfDmdUKTIvm4GJuzcEFM6ZbWIUT7IBP005duK1rG1MHVXkQwqLoHOXUn
X-Gm-Gg: ASbGnctK4Uh1LQp/X+etz4UnDCn0qsRdkkUTl4IuHdTko1Qt9esY0lJjZGd/h354pQI
	Zuoy6S4VZvGzrkw/mE1RudOu9TPlPZ3UHCERYLj+3jaB+TDWmdzMz5mtcim4zSJwno1ioPsq7fM
	MZ09vk9TVDLl5FXkwAzz9edT6zVvTj7SkINwx55VDp2gNdZScBjzoeCoSbmOUL+fc913FXqEGwy
	T0e68qgaS+hEWoxI6o/mTvt7Tjm1xnNmPzl2MeplEXSJJ3YdJdPQdFWpf2qQdG+s73Rg0ix7wAe
	5M7oZoNDedD9/RbOu3Ze8Qwbe9TlVDrjgmdsnWLGMaNok+wav8cAiWCp2zl6CghMmTRKWMWc9NY
	qkhYkEDOwQ9LbcUxnTqdjP2301V/G19LZvPClDg==
X-Google-Smtp-Source: AGHT+IFfX8J3F6Rx/3rOvL5CK1Vx8/H+JlLRh8JssMEAUGNYAO+7LoyRN52FNBK4eHlgg1RVjnH7qw==
X-Received: by 2002:a17:903:2f90:b0:235:f459:69c7 with SMTP id d9443c01a7336-244586f73f9mr36455375ad.52.1755171555703;
        Thu, 14 Aug 2025 04:39:15 -0700 (PDT)
Received: from vernon-laptop ([114.232.195.227])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2430b53d504sm49046215ad.87.2025.08.14.04.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 04:39:14 -0700 (PDT)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	glider@google.com,
	elver@google.com,
	dvyukov@google.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	shuah@kernel.org,
	richardcochran@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.or,
	Vernon Yang <vernon2gm@gmail.com>
Subject: [RFC PATCH 0/7] add mTHP support for wp
Date: Thu, 14 Aug 2025 19:38:06 +0800
Message-ID: <20250814113813.4533-1-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E9A181C0005
X-Stat-Signature: x7qzktm4u1zqjufsq8xcej1a9tajzue6
X-Rspam-User: 
X-HE-Tag: 1755171556-298084
X-HE-Meta: U2FsdGVkX1+/3o6KEzK8+wmQsW1KntsHpU29RHXTdSrN8uK6LS8pTJDFaLBo6NUeL0l5PtZL12FrEvUyVVSVsTqrqbWs1CxQkXhlcZKcfMAiiduFQqXTt44TSCFgz6e/IjrI6qzJrdgIsM94ScpChuGDIf81B+DCdctz90KaiMLLvn92GEBDLySJ9TTya4NqSoMmQhC0dJApoGNzuIas75eo2QQGsrXtgvUYnCtsiXNwDGB0XTS4vKTcpjUCmF3wyxqiVH5lzY59pWpMzLK9zFkKcBuVrLNH5PN5jTxLTLQH6FB057qxgBChEBz7rW3CkmFXue47G6RYNmFLvFv8miX7cXdmEFnQXs/D7addEHl1iyC70o7yAwDJe/cscV3NNYLjUtMYLWcP+h1Hdsjd6x8L9cFNZhZeB9cR9GolX/olwYqK8o/HVfXTxJzGZ/D1k3ehDodm1jO/pDmjilJXME4HK9gA93qWAE+pGuvO6Unn4rUt0fGjYvcDiABnlaXKKZBgWrqmj5g5oEUcLpmQoYWv+p0GVnuIepYVdfaCzOsK+OpKIqhwuySyrOMWM1SCnAcDy3LnXYyf3lnpDCSSMpjwSy0bFodU4N4G0XnuvSDi0gY85XdKsdUWpm5wjHv7BgMQcwUMld8cismg4DMnNUoE65EL+h4TVrLAmDD13dh+7d46GyWBc204usPUC6ayX02fXm0NkP11gEsph1yBtt1V5ifefjnV92Fwhoy3m1C1QO8ItIsTv4mXi9LuuVqluTGSE0v8W4gETkMO+9ewXgm+9hCfOfdEIrbeWMv55wGioN5T/DaMOBV5CStILlQsdDo1JDMepwJLt95ibYA3F3nfX9G8GNczOdpHV43lRxFFisCUCv/SKtpQox5kaxJVklXthTRF82S4WrlbfT9jDeYpHJksjk/41XmXS6plYZ7CJTO9q1vjWFzPziF1XbD6aaDvkByNTzaMpu7DoWc
 p01QkGnh
 Uw1M5NYwuS8UVgOD+bAwXR9kGH9wX5AhGOVLcpZ+wUDxsx2PvosvTxrq6rjfgViYiP9eDjUd/WS1cvg+52SQwAMYBRsVbTYE279O2XRhA6cgVwSVkYGR5DEQnFZMfrlTAEuBR+pRSYi9y8URmfZ/tCwy0dJzOOUmERMTCW9tuUUOKbST3/PFYTICBwsg2l1QWf1qohR4LjCWQHKE/QTPKyWSvxr8A+fbFTYJZPgZ/+vmpAIo6zp2KZXr+g9YW1mFYN122g1gOfuIvW9ClIkz3TLnCAQlSUDpqtElbGFcfi57YfrQFrQLhQInXkXxbgmZz9OSLz5lib2Kv9Pzv0FE4qXv0o8PZiDZ6YazElljX5lddOZuWdCifsCukvHJxZ6tJtk1VLrLC1owlFel8A6JHuvWzqRtCrQVyR4fbG79eshuMnFFoOjdXXNuNF1CwH2EzgfecVlMez+7EH0p4TXLxMXlV7YIia0qmW7krXSdr1k3jhurSUKjgwnsierc/t7kXvIBRbego1WW/pls8Dc9CiLDmaNERyIgzVuJulkBtLtgm5e9ThTbMz23xv0uOSY1vAz60
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This patchset is introduced to make pagefault write-protect copy support
mthp, with this series, pagefault write-protect copy will have a 9-14%
performance improvement.

Currently pagefaults on anonymous pages support mthp [1], and hardware
features (such as arm64 contpte) can be used to store multiple ptes in
one TLB entry, reducing the probability of TLB misses. However, when the
process is forked and the cow is triggered again, the above optimization
effect is lost, and only 4KB is requested once at a time.

Therefore, make pagefault write-protect copy support mthp to maintain the
optimization effect of TLB and improve the efficiency of cow pagefault.

vm-scalability usemem shows a great improvement,
test using: usemem -n 32 --prealloc --prefault 249062617
(result unit is KB/s, bigger is better)

|    size     | w/o patch | w/ patch  |  delta  |
|-------------|-----------|-----------|---------|
| baseline 4K | 723041.63 | 717643.21 | -0.75%  |
| mthp 16K    | 732871.14 | 799513.18 | +9.09%  |
| mthp 32K    | 746060.91 | 836261.83 | +12.09% |
| mthp 64K    | 747333.18 | 855570.43 | +14.48% |

This series is based on Linux v6.16 (038d61fd6422).

Thanks,
Vernon

[1] https://lore.kernel.org/all/20231207161211.2374093-1-ryan.roberts@arm.com/

Vernon Yang (7):
  mm: memory: replace single-operation with multi-operation in wp
  mm: memory: add ptep_clear_flush_range function
  mm: memory: add kmsan_copy_pages_meta function
  mm: memory: add offset to start copy for copy_user_gigantic_page
  mm: memory: improve wp_page_copy readability
  mm: memory: add mTHP support for wp
  selftests: mm: support wp mTHP collapse testing

 include/linux/huge_mm.h                 |   3 +
 include/linux/kmsan.h                   |  13 +-
 include/linux/mm.h                      |   8 +
 include/linux/pgtable.h                 |   3 +
 mm/hugetlb.c                            |   6 +-
 mm/kmsan/shadow.c                       |  26 +-
 mm/memory.c                             | 309 ++++++++++++++++++------
 mm/pgtable-generic.c                    |  20 ++
 tools/testing/selftests/mm/khugepaged.c |   5 +-
 9 files changed, 302 insertions(+), 91 deletions(-)

--
2.50.1


