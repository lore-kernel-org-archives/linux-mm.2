Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DB82CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 11:12:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C1696B0088; Mon, 22 Jun 2026 07:12:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 372156B008A; Mon, 22 Jun 2026 07:12:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2885E6B008C; Mon, 22 Jun 2026 07:12:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F404D6B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 07:12:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6B696120112
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 11:12:21 +0000 (UTC)
X-FDA: 84907284882.17.BD1681E
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf05.hostedemail.com (Postfix) with ESMTP id B669A100002
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 11:12:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qm05gz4D;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3kRg5agkKCP4zgx0tygn0muumrk.iusrot03-ssq1giq.uxm@flex--tarunsahu.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3kRg5agkKCP4zgx0tygn0muumrk.iusrot03-ssq1giq.uxm@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782126739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=m10nbWcXsn2fy3EJyAc5wf96aflhFz5y+USLpvcgRX8=;
	b=8NC0WsuOdnlXEF2X9dVP58bUvfb21JAIp/qmopdV8bfpE7RIZiZtaTOck4NmbiYXGNrpJd
	8e470SSMwFrpj/yTO0bFY6l01hfjagg+8g+ve1auvODMhB2kvmhCYW1W9O7YHyj8CcuJHi
	ytulVdyqqOi2NPMIvipWo4meCaQmUT4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782126739;
	b=rSXM22QOqTKs4pf6N5zGYLDjLLZW/f1Q8yLHIfImdR91ZjzXFyWw4Z5jocLZjJx4k4ixPF
	bFd36Kz7ZjDF/mxfVCooqisWwBrwNy5dDsFAdL5c4Wv+yPuJkvh7jBFbJrfj12j3/I8JLm
	Gx5uMq7meVPhzLK02rru8XJzex9II7s=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qm05gz4D;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3kRg5agkKCP4zgx0tygn0muumrk.iusrot03-ssq1giq.uxm@flex--tarunsahu.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3kRg5agkKCP4zgx0tygn0muumrk.iusrot03-ssq1giq.uxm@flex--tarunsahu.bounces.google.com
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-6973d186db0so2469608a12.2
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782126738; x=1782731538; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=m10nbWcXsn2fy3EJyAc5wf96aflhFz5y+USLpvcgRX8=;
        b=qm05gz4DfMUisjole4mHvR4fBjkzBGLZluC8HvEr9F6anSnoIpigz9amnXqvCGM+V2
         vSLwaEmtENDoTDWxlCd16ynLKDS35prmdb8/EMr19sjo1u6eOKK6UtcmUCMduNNNUMJg
         ObfWNuRVPxkEVMqoKNWytIZCAH/ffvZY5UV0Fcr9e6qSeZqBZMdCRnvDwyT4xhOmRuOJ
         orXXI+Y42Gi97Kb7/XpV8qhgO5FmWiNJ7Ec+Pdfi6f/y42c+bowhZ50kW+wSXroB3q8B
         N+JeFhblC66WUMUP+3fHXuTjEL/TKU77lUj6BVQwQugVhQkgvTWhL+OfJPWskSM/Nkas
         Q4Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782126738; x=1782731538;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m10nbWcXsn2fy3EJyAc5wf96aflhFz5y+USLpvcgRX8=;
        b=DlgxxZKHD1DpXUhmipZzr5Hy2BR6fhavJeJuZT+mjX1+NU2Q1xbdskZgSzok70QpRS
         KcMXdeDlxkx/QdGIdb9lmWRqBuiNnLAwrDlNwoOtCZ+s8EkU4A9gKAbLOLElmoagw4OH
         5O4YWEJLQ1MtFi8IoAS2apg21T78kYih7UeuMAfN0+GVVaNgxBVSnMt6LeV3n/+WPGev
         4+3oce4C7xQqQfUmaRbj8oB6nixx7uMwHQFDJfWoEGYJo6tMJzYnf/B4W1U6HOLdQkes
         4z8T8latAO03ClcF/EaTC7ZJymhCpTMN5QpPjHA421BYRXBCcVbLl2RsAwJ2QWdxCJRn
         BAHw==
X-Forwarded-Encrypted: i=1; AFNElJ8RlhgrHeAD+oCiks4s7/DpmeUvJKGEIpNKPuUgobFKmFHRjzQYlXdwteJiQlCj+WdUeVd6FZgW7w==@kvack.org
X-Gm-Message-State: AOJu0Yx8pffqqoSFBIGrB+stJS8T9dBsC7e2RtSWLqlV+1aUATmxpio3
	8l/TpGo1Y4zLpvPRgG8ZkEufcXhoqEwh6KUYcwYRvssBGEt/IbmUezFX7w//kf2V2rMjys9pulK
	cpXS9xdV5jHSDXo+JUg==
X-Received: from edqz7.prod.google.com ([2002:aa7:d407:0:b0:696:5e7:d0af])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:5215:b0:696:8f45:4ae7 with SMTP id 4fb4d7f45d1cf-696e5211777mr6088791a12.13.1782126737649;
 Mon, 22 Jun 2026 04:12:17 -0700 (PDT)
Date: Mon, 22 Jun 2026 11:12:13 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc0.738.g0c8ab3ebcc-goog
Message-ID: <20260622111215.4157974-1-tarunsahu@google.com>
Subject: [RESEND PATCH v3 0/2] luo: convert serialized ptr to KHOSER_PTR
From: Tarun Sahu <tarunsahu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Alexander Graf <graf@amazon.com>, Pratyush Yadav <pratyush@kernel.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org, Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B669A100002
X-Rspam-User: 
X-Stat-Signature: 9481kz9f6gh1ikz1omexqbh1iqjhoo6t
X-HE-Tag: 1782126739-117476
X-HE-Meta: U2FsdGVkX18qAygrXF8enqY6kjGZntoYJyRv1lE6gWAHbNUX9eIJKJ5+gTdBPp0nJlZpxgWb0F3zfodH7WO7cRL+oY3nmPYN24+LOpo+213Iaof9BT7X+CKQQACcTPfidw6BPhr+XxEhPcxmyBSr7tSG07c3+p3IL4pxe4HntJntK/vHXsTUvhOYO0XTMWhdgtXXES6vVXlJKZtfvRTAdep/S6wKFjC5pY81PW923fQzFjP2VOod82DKzJbRot28ZDtcUqivV0ZggONhN8tF+qG6Slu8aUs+ETrm0KbIjq8asWcMcQpV2QBAJu5rrzL+cDvRhIb1WSyEU11bxVh1gzMgovzLY4XFQmKpeQ3+Zvf0ZbzGZdu4kW4q2ne1V9SO1tKRFthY/MhORTLpQDVFQ41CKxTpNaTu3A3ymNpazwCUy/ki0wREQPgo1hDUTx4KHw6WDIp8GJrlMQV+ZUtzZnigEv54JXwAa/7WA9TmbG115K8epG9i2fpfKv7wmRvJ1PEXSg+IDE4ja9YUx/bz57EFnSKKrClLuU1Mm904UIZdkHSiZUsFtsP98rTneb+A+JRWJTqgQTYT1O9wZ8gOSwxPrgLMqHERPMsv1syZpQY2zBKWygpSK8UjEKIjwY8sAUSM8FmSUNoaIIu4Zrug1cJ13NB1IOQzaCZF3eedCuTghBSrZBVRiOq/BQIa7E0OFh141WyaRsIJpIK6Sp+MgrOy3kh8002PsD4VPMBKDcnJcHvwcx56ybpwSVY0kNlPinqAEUPyJEXdZYgetVyAV5znMDOKzTn3c/NuB0Jeu8wmyfgdWOlzsiL1AK/DSWKFWYGdlwsBpXggGTx5ALG/9qL+x96kybIoMALXLfbNRBK5AfD/pPjgdLcZZVGBx0XbsI8K0x/j3ZgmoLdDL30Kl8mnsAH3aQok8B3jlgx5EKWSgrze/nU6hrlDw7HwrQ8jW/wcCSQYqgNvNA9LBIx
 GcZSGOig
 e89aPJDH86lzbdBXyNc+xt0FnOdzc9BA6WcEUp9Vmhg8ilGRumd+LR0EayoR+JOjHPQ14gD2qsDOpnRb6t6qhsd6EaRtSQa88YAgA73wNbWQtCxPD12r5zI42LovHTwu9SeBMiCZQzq4lXRUBbdlX6UsbRW52MG/khGpU2nqYi/UptBoprTVK60THKyZM2/4sWPLXvYiGXE8VhwxJCeL7InpD6OxvhlQAewSnyKhxCc97NYm9aa/3d+jibgbRJpMZwsjZCfZC8szrDm7vpX1MmfLZzbDLHdmMhkcO4z4+KkkLTzz2iTEC+XsayuFbj4Y9zyqonMZ37TDzfL0nA2crQ45luGhfpoqyeYBw06lnOrmGwEJn9ZrMuYTl+hwtBisxiz44N8OkrbeTO4rfdNLJmxrU2HHx/aKUaGiDc70pSLdTXpehXhntt3Mc4YALqHWCbXVrDZYwGRLHq7cj7eoy6U5D+AnMoibCXICwk1Lk3Summ+Enyfs+2HG+3jNqKJZzBhxtJPPcdrFHiXjx973x/hdq+OcJlzfMUC0Riwm1zk/Syg/V9yzZY4Rnnsoa4djqGySkZrpCJQu61ZITIjpEhv5K5vnC9msuS81wlkN6J0iU4NM/e3yByYaqh0buKrNf+9NWlTXUt+Fft3g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert raw serialized_data to KHO serializeable pointer (KHOSER_PTR).
This series also takes care of resolving the bug with memfd of using
phys_to_virt before checking the args->serialized_data value.

RESEND V3:
	Sent incorrect thread format earlier, this one is with correct
	one.
v3 <- v2
	Rebased on top of liveupdate/next
v2 <- v1
	Use KHOSER_PTR across liveupdate files instead of only memfd_luo
Tarun Sahu (2):
  kho: add KHOSER_COPY_TYPE(UN)SAFE for phys copy
  luo: Update serialized data to use KHOSER_PTR

 include/linux/kho/abi/kexec_handover.h | 12 ++++++++++++
 include/linux/kho/abi/luo.h            |  5 +++--
 include/linux/liveupdate.h             |  4 ++--
 kernel/liveupdate/luo_file.c           | 24 ++++++++++++------------
 mm/memfd_luo.c                         | 18 +++++++++---------
 5 files changed, 38 insertions(+), 25 deletions(-)


base-commit: e98a9c61721c14bcd29f11f4802e52e908701f7a
-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog


