Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F83CCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 08:48:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D158C6B0011; Thu, 28 Aug 2025 04:48:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC59C6B0022; Thu, 28 Aug 2025 04:48:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB4096B0023; Thu, 28 Aug 2025 04:48:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A60AD6B0011
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 04:48:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5DC94138FD4
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:48:29 +0000 (UTC)
X-FDA: 83825539938.05.1414655
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf27.hostedemail.com (Postfix) with ESMTP id 26BDC40004
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:48:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=HY0bCSZA;
	spf=pass (imf27.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756370907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=po5t56gupEUroA6hj2hKHRirq45/Eh6BqU6ENRqwXCo=;
	b=Oty5+O1w9dhofy2OprOS3tkpbms9FyNcReYJBdPEiEQuWevD20QaiNf+q1ClRujjaogfZ4
	mT0CURqGii4qA7/T4HcAO79cjdw3Jp/jhLDUbCxhAfPFFj+kvbNeKqkVwuAMzvK5tfO/Du
	DHB/IYQj61s0HS1+CtPDK5oKrfnBEHw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=HY0bCSZA;
	spf=pass (imf27.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756370907; a=rsa-sha256;
	cv=none;
	b=oDrcd4OD+1WTEkss79mgJeSzlIEFttx5UhDUer8JTqa3H2EDFFSW02vCjN6uiCR17VILrY
	d2APKSM8LRg2PtIOifDQKHrn9ceFBnfXriKOKJc3/nT4htnpo61PZCsDWpHZJuExCAbBx5
	T1v2b9/JjRnFpK3dYcliKb5fcs8KRAQ=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-619487c8865so3476578a12.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 01:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756370906; x=1756975706; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=po5t56gupEUroA6hj2hKHRirq45/Eh6BqU6ENRqwXCo=;
        b=HY0bCSZAG7cfHg92cRsNOJSZgvxnB3lkyz5OerJGc2SMubLD4Tgerro4rXbcHGNKTp
         UYbwIsO1vid9m7sv1RECqu9SQxs7qs1Li/ExjX3rlwOt4FEpgXfhGLe7nxXCLPn0yzWY
         dpU8QN3unUKf0hvC1Hr5/UfQ1pZ6/5QsPM6BAf55uBGO9WgQyJm3p1WahDfFaL+1j94W
         TAiKJHeJiLGT4LXdO/GKJrjjkgadPYUQKCUJUWpekmh35tX05LaClGbcO+YWaJ8QWq/k
         EXQ4EMV7gBH9PNYojFKaBiX/aS8f5MqTria8UTJKrMfq2Tpt1QyIaPigT0kxa+BOxX6t
         FhiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756370906; x=1756975706;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=po5t56gupEUroA6hj2hKHRirq45/Eh6BqU6ENRqwXCo=;
        b=DYap/rjcgoH7VweUbEnamOswi1uUxLzywry0Id/cnwtbkYt8rRXGDT8cZQfPx7IeKQ
         ohSWparV7k51Rwg2hFRb+vuwmvEKBFvdx4lOOx7fcqwE/QD+Ini3lbG8XszwaHUAPDOg
         5/BJ2TWZfAQDqNJQYlVo00Q62Og9w4N7oNvUS2HAH9QPN3bnJRYxRrq984Q6fEBN2KaP
         YVbl90AnR2ZtXby4Pud9IBlqpqUJ9y2xUQaKemUb0YnX8FlscleUsbWW7yLqJ38Jju4q
         kHooYse7JIvrjVJUslX39vaLy33cdiBuQJrN/TGqvMBh0x3o+pujDZoMMhgx2tK1kP4G
         +BDg==
X-Forwarded-Encrypted: i=1; AJvYcCWs3M7Tym7+zcr/CsJTjwOrw7wIg2NqjA3mlmvM0KIR2pyb2cJLeyjUWraYjibFwnFJVX10+a1Ovw==@kvack.org
X-Gm-Message-State: AOJu0Yy8TFSPgjp9hIFVG5k8l+E+MAw3/WS6ikgd22rsLd7lramjyBoY
	0A6I64tEjnsvRyrCjFqS1COvQZaZq7cjE5c0VYVn3jUdtoEz89OdsDOdXxFdNKeHmfw=
X-Gm-Gg: ASbGncsamDFX/RGOn/sdE6ReLFuoQW/XzX8BEsX6FIwGd1IhtAAr4FXnrG3Uz3C/umF
	TWaFAEc4CUSuABV59iFh1qnQmBv0VGUlkFd583y8iaSrS2V4iLeVUqxKp2FRFkT9LgzCVVuxums
	rzyHENVNlxLuXm0sGVSVxDHp+v1odE46NZKoSUDnbdx8m3mp4kSJ/j/rs+rRfycnRo1ELttdt59
	S6x7TLxHbfJje4SAwCYjpnuVTFgOF3k6tYO+zFw/XKw9lEoFHRSZd1PG6XeZk/pqkrdLRONqn5y
	qmiQLcptxihT6cPf88OrS8dquzlfMaNr0a2q1GHx3dIrM6UQkFXOOvvwYL1iUT5uBbaL8g2GnQ/
	Ah7mVkR6hvUQJKg/WCyRgb5hg6kHhsDd5EEiEVov9GIhNWmIDZTJjMU0fV1hTRyBbpwLwV71fCX
	ARnlpGRzmu9zIs1Uc7ktljdeGz/NpkUWUd
X-Google-Smtp-Source: AGHT+IEwSMufyxIazeK4EN6r3xqwf4pSdVAWUgiAPZLRoOf/5DVGbNYWNx+rE4X+wLoHpKnHe4pjbQ==
X-Received: by 2002:a17:907:6e89:b0:af9:23b:9f9 with SMTP id a640c23a62f3a-afeafecbe4cmr668160966b.24.1756370905526;
        Thu, 28 Aug 2025 01:48:25 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe90c8f85fsm697372366b.8.2025.08.28.01.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 01:48:25 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
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
	shikemeng@huaweicloud.com,
	kasong@tencent.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	chrisl@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v3] huge_mm.h: disallow is_huge_zero_folio(NULL)
Date: Thu, 28 Aug 2025 10:48:20 +0200
Message-ID: <20250828084820.570118-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <0de24b30-70ad-498f-9eac-01596c8713df@redhat.com>
References: <0de24b30-70ad-498f-9eac-01596c8713df@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: d9k5czd5spq5f6ethtrpp4kuz7t89sg5
X-Rspam-User: 
X-Rspamd-Queue-Id: 26BDC40004
X-Rspamd-Server: rspam01
X-HE-Tag: 1756370906-139553
X-HE-Meta: U2FsdGVkX1/fHpsmYEBIb6CleW5X/1OeXlTwSFqGytORTrCQj2IaNb4QgAaFLs3G9xdBWxHVEGuLYMOHnd8DrvlOngitsMqI1j6qXr1xoHKhMGWQfq6pu3zaRDXpssn9qCWDpNEAhI6Yyx5HjnFkG+R8e7Cu6UCRFjwN0fKrSBA7BeFHYgDyZH7HcfDmTXB3FdQqGdeDlgXS+fF/HqsFj0TJ26sCCVx1TnQtPkdQxX5xIUNjm7wIx6B9WlY/SkUC/tFVppQaY9Ye306TGqyQpMtuUCxFXPd65pC09cfY3UMVG4dccVI65uX+MpqrdENAhi3iTi8uQFKcdmDHNaUrOhIikl3f+02ii2trwsHcaAlMlvD/wgt1qSktk7qEnGE8cgglYUQhwNs7zYTA/V5YNn0kVpZ//NfpkQeSAEaDjgIWnFmDsh3vEJ1VQAEWta5Y9ss1kg5+m96DpueswOcGjNCn1S5mBjorg8Vziy9WpKxlVhjDgQFsUNEjuyhiILOXQFhUQOuOCSR74tWYIYFrWxZVGCcSJx31Hq1O7FTQcu0r2oMTo27GZsfZ4aaHj/j5RsFzVUOzfY35Y7nODaIkqgEUGym8RFZ3+44mxGAsrZohHmC3atKCugLCU8R2ka9ieQm7whiuMxmDXGkLuZGh6igJWrUn+s8vaepfXxl7c95s7TctjTNC+NanxBt2yGmYeNjhSCQNSj3Qy0oC21VK1xJ/MuzG9x5AoTv8rxQ/SCRswONUHZ9UHGS2dlQ4onHWs9f8hgQFBvYeS94AYw3WUaADFEUozMRI3gVL3E0nf+1tZ0DL1oFAyMdv32VqOc0Lr2qOUoLSthxrSw4g1XjeiH/IR1Z0mD14lSDqs7V4lxmYbU/IyWP9mCIvxz0LydR7IioxzHyHw8ul2o7A5NKroBP7GHqrU5yf51pFz8QfKECRSd5Bpacx2EtxVpcyblAsDYV9bvYi9jLr4g06Tso
 kUeq90Cm
 B2BKfprBChsJnwJKie8HXJY3aHr0GFmCw96c+O1jO3+pWg3AzZHF9RZMqlljsECyqz0QYl9jST/ZVnxV/vXnHSY3koBciSo6GMG+meCWeCi8LWOuaP4pPhK8e2avz0BLYaj3fbKSLn721nKM9Si5QPVFFEAVHjx7mhisBfCDJ0y3aeVEYzS3au7hLjBq9ay+Z71o5Pqc2DDVZrLGwS5A+6oxK4lkhpOpcICIgRXoGhu0kc+mNgdJpXNvn9ar3LNUFf+RR9jxx7tOIKFBQMq+d1VbHBoLUl0NdDnDJ53kiSvB3QOMv1xEnE7b6f3vaONgHLRkqDET7FWVCjntLdb++sMg5bA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Calling is_huge_zero_folio(NULL) should not be legal - it makes no
sense, and a different (theoretical) implementation may dereference
the pointer.  But currently, lacking any explicit documentation, this
call is possible.

But if somebody really passes NULL, the function should not return
true - this isn't the huge zero folio after all!  However, if the
`huge_zero_folio` hasn't been allocated yet, it's NULL, and
is_huge_zero_folio(NULL) just happens to return true, which is a lie.

This weird side effect prevented me from reproducing a kernel crash
that occurred when the elements of a folio_batch were NULL - since
folios_put_refs() skips huge zero folios, this sometimes causes a
crash, but sometimes does not.  For debugging, it is better to reveal
such bugs reliably and not hide them behind random preconditions like
"has the huge zero folio already been created?"

To improve detection of such bugs, David Hildenbrand suggested adding
a VM_WARN_ON_ONCE().

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
v1->v2: using VM_WARN_ON_ONCE() instead of checking huge_zero_folio
v2->v3: use "!" to check NULL; removed the #include
---
 include/linux/huge_mm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 7748489fde1b..96ac47603d97 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -479,6 +479,8 @@ extern unsigned long huge_zero_pfn;
 
 static inline bool is_huge_zero_folio(const struct folio *folio)
 {
+	VM_WARN_ON_ONCE(!folio);
+
 	return READ_ONCE(huge_zero_folio) == folio;
 }
 
-- 
2.47.2


