Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9273CDB476
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 22:57:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48D086B0088; Mon, 22 Jun 2026 18:57:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43D256B008A; Mon, 22 Jun 2026 18:57:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 354366B008C; Mon, 22 Jun 2026 18:57:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E30116B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:57:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 29DB11C18B5
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 22:57:42 +0000 (UTC)
X-FDA: 84909062364.01.B4E98D5
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8888FC0003
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 22:57:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=B0rspC0+;
	spf=pass (imf28.hostedemail.com: domain of 34r05agkKCJ0Q7ORKP7ERDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=34r05agkKCJ0Q7ORKP7ERDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782169060;
	b=8DHdFhooY3Hmju/6ZefQobIDrNjAV6HBshwr7bEmxrfnrCfxpqyka5cuvNrQVp4vDkuK4N
	chjO6XC47KQPCpot9uMXPf/7YvmUJgFSATW2payutbEogVVniekS0FOn7YESvKFz2lRRFy
	gQdRl0xJq9X//CiNNC99Ah9Cynd0C6Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782169060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=GuqegTQ8Dp22axBp2zLQ2UPTz2GcEz8o9NQNs3L+qeQ=;
	b=SIWGwuDfz8d18R6r7kiFtkt8mcyulVjAFJpi+KCRh0Kr+LnlzWGr+SnQStiyk9huR3DG23
	+P3TZ+ZvZNAlO+hCecgdzFooqqAgJeaxH8bQPxHyJFDx4xCjsKQB7pHg9M0wIA9GkbZ/bn
	4+mTDdhZPvKaKMahxWJuAR4IwybIsI4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=B0rspC0+;
	spf=pass (imf28.hostedemail.com: domain of 34r05agkKCJ0Q7ORKP7ERDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=34r05agkKCJ0Q7ORKP7ERDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-6960fb32b74so4029087a12.1
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 15:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782169059; x=1782773859; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GuqegTQ8Dp22axBp2zLQ2UPTz2GcEz8o9NQNs3L+qeQ=;
        b=B0rspC0+ERwbX1LU+QB1ls51TuQt9A8+ImLG6O+FBuemW1p5Zs736xR1Uga51cEyez
         UqOq4J3MEBpv2YZbjseE7VVnxGvbmOe2E4YCoK0rXhNn7TWmo/nKFffDEACQ1HfopVhy
         eM+6BVa+mn/YFBl+p3LIDcoTJOSezwTn+4sHc0FdS4ax8/N0+UskqK6Q0qbYgtfloL7U
         YBeA9uNglesNte5iBJknYxkQnMMZVePED6CNuJ7GF36FY+EWndcDJz/l1HmGyEhHHIDg
         vHqvQ/EOEMKeXS78tz6o/pKpr0hSFnTMh/L+advmoZ/U+EoSmxQSGAZURbiSLIbF9Ymd
         X3rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782169059; x=1782773859;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GuqegTQ8Dp22axBp2zLQ2UPTz2GcEz8o9NQNs3L+qeQ=;
        b=jHgkmzqVj7rQxBVDspymr8Modu1r4Z9Kjap2qmeJp6rW+iGWQLyt84wQMGbyT651WW
         0HvngVgM4ndYgv8KJR3hzLzq7GfRZ+ryUdPK1F2YCmEqn2sOGxul54XttrAfB8BM6hrC
         z7OsHB/2tRGL9fk69GRQUgNVL65HTfGSqRu0AR+Jfa2bls8YJBX8YPkTUkG4AO0JWKcR
         gxRRMAjY9nKumlNBfYZBdluacabVFKiagqYAtWJE90uJl71tco9Bc2EqcYuvOhomGlIy
         aYz+X3hx7UVk8HZGrBE8qjtYqLifsdV0T/sGU7R3PlPkhGFJZUT85AaIi1eUr2b3+FMF
         uaEQ==
X-Gm-Message-State: AOJu0Yw6XuhDYQkJ6mTWlCqJ9DzoEMbtaNtokYeeG4ibyXujjVvktKsN
	XhIYo/tuOXkhwMUHYoZhpfsK2lR+udxqoHlZ4nPwVl6r9T1OsDIgq710kr2quZbhUps+6e1kE5V
	yPebbeALCvoRapA/+SQ==
X-Received: from edpg19.prod.google.com ([2002:aa7:d1d3:0:b0:695:4008:2b79])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:2345:b0:697:5124:15c6 with SMTP id 4fb4d7f45d1cf-697dbad0f06mr66279a12.3.1782169058595;
 Mon, 22 Jun 2026 15:57:38 -0700 (PDT)
Date: Mon, 22 Jun 2026 22:57:34 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc0.786.g65d90a0328-goog
Message-ID: <20260622225736.2961438-1-tarunsahu@google.com>
Subject: [PATCH v4 0/2] luo: convert serialized ptr to KHOSER_PTR
From: Tarun Sahu <tarunsahu@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: aengcb9t4n77rqad54fqmayxfbtcs9we
X-Rspam-User: 
X-Rspamd-Queue-Id: 8888FC0003
X-Rspamd-Server: rspam02
X-HE-Tag: 1782169060-572063
X-HE-Meta: U2FsdGVkX1+oocV2+o2cLLiElSTe9gQgotSo2fslhHp4Z5rgwF/MpJwhWfgMtStducvAS7oYIE+xxzkAOr/haTeBK0uY4rZf65jh/bo22BhFaTrTYNs9ajQNIsOmEACJ9eFWdH03yXVX8dZkprzqdw6gOzuT9kbddY/Km2byibFZwk1TFiu3mKfV9YrvsWg+24pzDGM5JexF84h/DQzJeQUi2X400kStKZatcrblpIVAm0/3cBvLaYB8qy+hXDrBHXbE1kv5xFQ3Op6sGcD7oyng8nL3MEw+28UtpAQrIWm6P3zJbjtizFeZAWodQfg7pGNz5VuauQ8oN8wdnfqBdefxBH8eGT1buVrrux4QrhLWCcwxbZmfnrB6QRpU3Qy5WQH25wncWVNEx60Je6cbTsdv66zCxqwnSHz1rz0JRXR9y8wf7bBrrlHO3dAiB8F5lqEdnoTCEtES9MK46AM2syeFJZ0c+Nc0nS6Dpok2r712yjZ0YlQMAYT/2IG1xbYMOWKOZ1ZrIp6bO5ygBMKazfGwmV4CmTe/B+Ij5RLO29O00Ou2/wqslCEOzdchU66xMdmcNT0gfMjld+sxAqimtADrIRa832cmgiSzPc0RCzmyG0LUpvduUpHU6RDoe887nlFYbVZkWdHi8YW9OsAt2HwNJ2+e91871exYU2rdZPSrFhuk5viSAFFSN8Pg1D/4uaWDsDKcAOEi/8dOHxJ2cMECIOQFE0w2EHT9TpKvocC9C9aEDU0Z3VPmFw1/1yPaYOKLHcA0XPiHHEfEHpX1LlpTbBCpU6ATdPVrHjzbfSVPBmZM5YuFfwnoX2CZbMxcRqSEyejgl9K4Fi8wWo1CvOgUSmvSQejw42Ru4Fob9Rgt7Sw4yvDy8ZxVtsM5Zgc3PE35LprsJtVxydv/yDHZzEKyZujVzcbJ77AS5RNX65V3Ffx5qVem+lUMjHb/uADehNzV4WQqUUkFiUaUPF1
 mV4B59QI
 8mjzTrmQsRxgua0ybL/nnlk3h4XS3v+WUk+kbkOym6zG+ygc+F6tlgssI/QpIqJCVJgDpje+WGVQcz52hWmrlEDM1NnOuo+erKb36iOVkTZd9jQppmhhw0znTFc0Lc3j4Fz5qL0l4/SJGWIYSO1PBtrIjl7AaW2OD5Vk1i6SUS4dk+c2czodl4YonkhsYigM1MSUBf5FytcgOCYDfxmIgXaHvvQPABJ8v4v/T2u6YZkb+25cE1ODEbUtomkGVZs1xZhgd4CQnMB+T2Qz2VlQ0h4dLRTmQ1QrVM8R0mTgsM0Q4Blfw/abLGTvGMHSeGWO2z1lWHDQVA1dcdRpBER22z4vNEvHsfwTRSRVRSIaj4cUrcT41Irg/LbkGWSIZwAxKZACnvApHBQL+tYxvSEagqVzQN9H0J1DaQNJXI1bw2zz801AGh4j3UPhPaeXwOOqWZ9wpJ7qAeHWD4p5Y+Yei4vf8fmV1U1liJD5tm1bx48a718+/YJa/naFqjZAd7z9qEpmLdOKC/E/psVvr/nOGvB3wby5vm158BUJdJ+dI6w8B2B5CGrgCLw3NYpJmBUJRFVBJ02HJOkcEzfFeYbn2d40GZ35DTfEDbenzpfz8hsweslqnobSKlAHSdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert raw serialized_data to KHO serializeable pointer (KHOSER_PTR).
This series also takes care of resolving the bug with memfd of using
phys_to_virt before checking the args->serialized_data value.

v4 <- RESEND V3
	use only KHOSER_COPY_PTR and have compiler time check for type
	excluding void * types. Remove TYPE(UN)SAFE variants.
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

 include/linux/kho/abi/kexec_handover.h | 11 +++++++++++
 include/linux/kho/abi/luo.h            |  5 +++--
 include/linux/liveupdate.h             |  4 ++--
 kernel/liveupdate/luo_file.c           | 24 ++++++++++++------------
 mm/memfd_luo.c                         | 18 +++++++++---------
 5 files changed, 37 insertions(+), 25 deletions(-)


base-commit: e98a9c61721c14bcd29f11f4802e52e908701f7a
-- 
2.55.0.rc0.786.g65d90a0328-goog


