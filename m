Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A72BFCDB475
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 03:00:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C6468E0007; Thu, 13 Nov 2025 22:00:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69D4C8E0002; Thu, 13 Nov 2025 22:00:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B2DA8E0007; Thu, 13 Nov 2025 22:00:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49FF98E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 22:00:35 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DAF5FB73C9
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:00:34 +0000 (UTC)
X-FDA: 84107709588.25.B6BBD63
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5DFDDC0003
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:00:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MkQiZI4s;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763089233; a=rsa-sha256;
	cv=none;
	b=8hX8OwTM/z4waStUBKMwhmiOLsz4YQegQf5wGFRTB9o8paztWhMqpA/XXR9uNn1JFs3JDQ
	s8xP0y7K4jMRy19HvMetV1I4Q+5sF62cDt3RCSlGUtkFmUhfCMUwfaCS7bNI34lPa7g+yd
	riZEOsrqTw6SYBgmHDtOwFumaPDOYwI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MkQiZI4s;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763089233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=PuIeuczuRJ5d7wk7+9TFQXIGeMdW+kkcrn0L1k8p7b0=;
	b=vVr6HM7e1agh2q6/QGmDO5L9OlLloSgg1HEpFw0F+6sb88e1Ok4F2VU7VU2SBB87G+7uEe
	04bpySic4tlbqU9jmVEtHTZeOrf7OOSOC9XPRn0n6UZzivFryQ3gFAQqBC9xKXdXTrSoy+
	jsEpNasdJmEhvxg2WvZbmra7iAg3NPs=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6418738efa0so2456330a12.1
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763089232; x=1763694032; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PuIeuczuRJ5d7wk7+9TFQXIGeMdW+kkcrn0L1k8p7b0=;
        b=MkQiZI4s9PCJOiq7xtq1XzCak0REmSE10kz9bVyDRVTG+9b6FaexdNtxRbhGFmAl2m
         ZHS9URcZKBxGurz/5ACb2ZzBjwBCGirC3jyIJORcFJN7kDzVAv1jdMMwS4r3veNiuRG8
         QVWIrhen1x6Rjra+5+JWCcXXAik4yv9Qg4hFIr0T5beVAOeRYmsL0DnnSwshhDJffEcB
         wr/jd0JDE8dXpftsS7AQzhcyIwGaX443AjmHC79S9NHaI537pP5hIWJlh7XY/AB1arhX
         9iZPu3iX90LQ2cmgyYuuYgIzKMbUN0FXKyKL/azirmNwYg1fGzaKOKqBt05Z/zdUuZhU
         /1yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763089232; x=1763694032;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PuIeuczuRJ5d7wk7+9TFQXIGeMdW+kkcrn0L1k8p7b0=;
        b=wQSJXZWu+Qq1tJ6rrQWkbsBrDYJ4U3+vMSH/ybnvldRGEARdTuf/6u/D5rmNk+NvNO
         9ESePlNTziCfCHIzeKDjbwSf2YNkKBCH6bCvwGNe/R0L/E/S786vg+wPyd8qKXnJQdOm
         zA2xQZiEX3zyJk9yvTuydv5Bp9ZuBnhf4P7BiJwrGaItUI4a+/CBntz4r9YIumsaeuSs
         xY3rudTKEpi/wH0FpB988sW0VfeackPF0AJBvvKBSTU/WXiH2WveUwiaoreQvAmzq4ck
         s2O5DqnN5P7j8zvp0mwALXnaAd5Y8oIji9+EnFRUytdCQs7gj22p0o3iORPxTnjrTkfv
         mjyw==
X-Gm-Message-State: AOJu0YwrOwzCmAzqw/1Td7Xn30cj8QFU5VAA/wqdZ/SWxVTYRJCOj0T1
	CxzDyRIMuM8PlwbPHY6ljpUsGdsqaASbFVXklP60Bi9hKD94h9ht5tC/
X-Gm-Gg: ASbGncsZSC94NE3FiU3yno4vju3lazzjRw3OWPjTMmaMUJnOsw7Fd/ByWTTB+Kr8EPK
	TBLbNQ0SJkmmij6TovIVhNLF0+iQ3SdL4zR85V9uIBpfEDoL3TUY7HTx4DB9OCT+BZEsbP5aeFo
	wYexK8kVk5QLoxPA9oJ/xNR3fTSFROFfanif+h7yaV4p+IaVcxzdsLb3gp5e5a5OVYc+QVAu0TR
	LOxFds1OTdb2em7a4chIU5qyxww6XEZIOucsSXhBCJ9hqk+5VZ3R82uZCQRQeCphVm8gBU42XHM
	zcrouCoCmCQTGfCtHUqogy5d3J1q09EkGTdpBT8gYFxSg//82SVapjhZMwAZZo/BDh3YtZiPJs2
	dmIwURZIs2Xp0jhCF9kom32a4xPYgqJd3aGWEtF1OCtqh0GeEdWpDv/8z6OE1EhIPAtSe+cUjkq
	oo6vuTyGemKTAXfQ==
X-Google-Smtp-Source: AGHT+IG2SmilbrHIlgqpDHDuUXUAkBoaEk1LbT8KmsmHg8EgNbhdH7i5H6dXkTvLhkk8YvUNwLvUdg==
X-Received: by 2002:a17:907:2d2c:b0:b72:b7e1:5c90 with SMTP id a640c23a62f3a-b7367b8d98cmr152682466b.34.1763089231522;
        Thu, 13 Nov 2025 19:00:31 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fa80e3fsm297802966b.2.2025.11.13.19.00.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 13 Nov 2025 19:00:30 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch v2 0/3] unify PMD scan results and remove redundant cleanup
Date: Fri, 14 Nov 2025 03:00:25 +0000
Message-Id: <20251114030028.7035-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5DFDDC0003
X-Stat-Signature: 7ue46noqq6hjymtxw6zydqmntbujebb7
X-Rspam-User: 
X-HE-Tag: 1763089233-827324
X-HE-Meta: U2FsdGVkX19pZzDgSr4k42+85iqE0TsT0lnqzwmuGQPNjTnvHy6QC+vaNM37hHig7GptaRiUXbnXjrs0gMjMxxf7lFAgmgkSP06zd3e7HliCvScTfNvPIBCjHSR9TOgE7kJbmI7iDXYg2go+ct2qdj3LLFUEpYM6wsg1+UtK5gIWD/V+V4dCjPMWKQxtrNidlFTM8+TqeTte91KP49phXzKnL62Yz5qJnixOr+UwzLhAWdJzZVP6y2D+FgfIYRT31Wx9eBCNBHBullCxJ/bR4DKwHmzeLdPbdHwNoKfusjgv58vcanPeE6FJIN0c8fZRjnIso3F/nydkcJHkLtGv0YojgMJO1ynwzs5WdreGaGBJx/uCLU/cBcpEIemwRWrgAAgpoIcEy/U8l5/mcFEP2HOphGZYwn5GT/OLWzmNUTnLjtGrcUtpAvx4/HuM4pLTALHw72mKycaQeZTgDzUe11g5qjxlkO6jKbAtyxJDT3VLkMl2cztMzimQrCZGp18a4kwdfukA8ZJjmLjnxhHGjBO+2XNB2Ob/L/BhG5VxFfBdQiWEj606Pn6kaGgQEome0weUCVAAKXPaHn8GxO5sRvAbvQoWklC7hO0AhinJcr7M4qHLVy1hXdOCzVRZmWFfpwbhNP6LUsqLpX9XItVhWsSS9QE79PRlOgugxLn25+kdU32vAbAcNRMgshfzi2pZ8xaiGfHyozBJ8RPakp2syPa7GPgCw3n06kcIt0LNNNeN8usnSjLHBx87VH6Yex3fH/bS2P+e+aaBdv8wZr/X/N5rBJwBP5dWNHiobZJOU5ucVkJ7FLaFX5dCV6pOpc8vdFMpzloDgQsSup46/DWpoxcUzwndXa1b7TAElDEjSRFaLDHmXQBZKEWYV6fFvhZWJzbmTyzwJv265f5gRJWv3dcq3wDrq6nDUWQTu6U5nm02u5h3U8/eYUoeH7tvTbZ9aFipa57+roNOi2/c+2P
 QzPi//hz
 PrxOT+0l5QT7hr70rWsYTorSjVqY7QYINAq89XkPknSsPr0+KOhAdvA7Y0p5lTDuqZBvWkWQ7/JG3LLisn8R4n+IdkyzF8odT9BK36VPa/FjK121YlGiI4xjIjUwe6Hv09/WaNsjU5OcUXxEQD76kCIU78NKEFjHb3rHXPS/8o0euth5YkwP4VPpFXeBfgDXTkBu0SPwytTuUV/p9mHFAvSfm/YhECEjyPxU3n24mFUHi48QTK75s1Linys+ERf445iJ9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This small series addresses two minor cleanup opportunities in the hugepage
collapse logic.

The initial motivation arose during a code review of madvise_collapse(),
where it was noted that the function was missing a handler for
SCAN_PMD_NONE. This oversight exposed the inconsistent handling of
SCAN_PMD_NULL and SCAN_PMD_NONE.

Since both scan results are functionally identical (they indicate the
absence of a PTE table), the primary patch unifies them into a single,
clearer identifier, SCAN_NO_PTE_TABLE.

The series also takes the opportunity to remove a redundant clearing of
the struct collapse_control.

---
v1: http://lkml.kernel.org/r/20251112020031.25350-1-richard.weiyang@gmail.com

Wei Yang (3):
  mm/khugepaged: remove redundant clearing of struct collapse_control
  mm/khugepaged: continue to collapse on SCAN_PMD_NONE
  mm/khugepaged: unify SCAN_PMD_NONE and SCAN_PMD_NULL into
    SCAN_NO_PTE_TABLE

 include/trace/events/huge_memory.h |  3 +--
 mm/khugepaged.c                    | 24 ++++++++++--------------
 2 files changed, 11 insertions(+), 16 deletions(-)

-- 
2.34.1


