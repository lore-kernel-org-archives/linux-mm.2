Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C53F7CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 11:04:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 463B18E0139; Wed, 27 Aug 2025 07:04:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41B578E0105; Wed, 27 Aug 2025 07:04:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 303F18E0139; Wed, 27 Aug 2025 07:04:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 149E78E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:04:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CC79A1190CA
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:04:51 +0000 (UTC)
X-FDA: 83822254782.12.EA8F0D2
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id D81F0120015
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:04:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4cSM3wFe;
	spf=pass (imf29.hostedemail.com: domain of 3UOauaAgKCCUKBDLNBOCHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--jackmanb.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3UOauaAgKCCUKBDLNBOCHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756292690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nf4CiXWHDpJDlUPbhGw995yPVPVvyqVPHVSb+srJYto=;
	b=rbffECZgkeC/4Oh+DBtJfsjkaBW4yA9v5JH091CusmBY8abjf0qvNRJTsQhal7mCmmQUTn
	6U+kBZG6pU38MKIiEMif1SOSTiuiBC1EDJaFnFQ2qp4zniXDMBGIbq1ZP3a+50/a6j4BZP
	v75aEKjmn+eBeJiDIRO9+7ztqX2ceDU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756292690; a=rsa-sha256;
	cv=none;
	b=hHPtxQMsAdffGl79DlSBL6LqANxvxlToryiMxZTp7JOvRCHX4hJ+op1Ycnsc9h8xSEGyLA
	CsaOzqKr7BAvn4DGS7v6lRvmifJUNAbN+p3dVj39PXZRakW2H6xrsl4tSmk1QfrCRAEln0
	PLni5sTas3Cvr4siAvJu4MAqafarZV0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4cSM3wFe;
	spf=pass (imf29.hostedemail.com: domain of 3UOauaAgKCCUKBDLNBOCHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--jackmanb.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3UOauaAgKCCUKBDLNBOCHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-61c6d735e9bso2507972a12.0
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 04:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756292688; x=1756897488; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nf4CiXWHDpJDlUPbhGw995yPVPVvyqVPHVSb+srJYto=;
        b=4cSM3wFe1VJmYu9A7QyoGB7BKRRaPw+zR9itvOWQx+Rg6NYMPKyMc0Y+z3ZkrxGEzB
         zw9qg3Qlk+tyFteR1LDzjtZBJWxKXIKsoESEyWIYG52PeKnn/0YR2uCNfaH1yIyhn5ja
         cVmA/wN1OtJsBfA+bOUDnjPAuLc6ykGSyG+j5S9ZE92pBeT7gzwLJcxV03yZM9hQU/rW
         iWl081RZlh00XqffRb41WyjIJaaV+b1sCugXIlS8I/WZAt6g+YZABYF6SekPfirrBXep
         d5V28tedBzkPNSB7cXJIqnM8n1aVfgqIc+6Yee60sS8iThQn3uwyCtX1Cmo7BwkE97j0
         +FeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756292688; x=1756897488;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nf4CiXWHDpJDlUPbhGw995yPVPVvyqVPHVSb+srJYto=;
        b=s1kHuJ4ChNv1CJCti3c4yVvRJNH+/ZSaf6nnTzHnLD/4Pp8Bky2jUPdux+cQMa1svl
         V8BrHdwNZS3ELSY96zAxSBHnWEePQR5a5nuDH6K6fOtVWvtJJLratYH2e/Jx7HNXMs7T
         xtaKgqAUz4muUmp27x3Ui5uum4WEw+dFyI+g58lZe85M1wsGaI+xzbbzjGy0Y+q3b9Pv
         hfKAH0NX6au7SSZtBFK2C1Wme/bFWNpruO4a2bHZnuWHj2n2vqlkhomOk3Gf7w6rpWmr
         JHO1iOjtpMQtHTmBqO6QrpAcR+MCy9TN/nkQDB01Ch1pWGjOC5qIhbUlq5R8nwzCHvcg
         UB+g==
X-Forwarded-Encrypted: i=1; AJvYcCUvYs4nQfuhm4EOCIn5Mm4THUqPVKWa6+rhJehxEddsAIe8ugor3PwXIQbS+g23T7gk2F2LlKiJwQ==@kvack.org
X-Gm-Message-State: AOJu0Ywf5aQsYMsuXW+/OTPCWFzhLAAemczHXHULriIQ/ijnSmIL77XU
	JCUqrhUDmNvisTGMDIcW+Kk5SJc6Exz6Wyx+hKxhDokfswolxoN/RSqe5HdMqzOq8mYwO9CKRD8
	R8FD+7XJRN2DNRQ==
X-Google-Smtp-Source: AGHT+IHrZXwCVvuqupUKpT95XmcWj4Xa/7qE/DbFzWdo9LcsAOtZKdLGvcR+C3sRuAOM6hlRZPCPsneY5yWc2w==
X-Received: from edbes5.prod.google.com ([2002:a05:6402:3805:b0:61c:8c63:a94d])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:50d1:b0:61c:b951:adb with SMTP id 4fb4d7f45d1cf-61cb9510f08mr777554a12.9.1756292688190;
 Wed, 27 Aug 2025 04:04:48 -0700 (PDT)
Date: Wed, 27 Aug 2025 11:04:43 +0000
In-Reply-To: <20250827-b4-vma-no-atomic-h-v1-0-5d3a94ae670f@google.com>
Mime-Version: 1.0
References: <20250827-b4-vma-no-atomic-h-v1-0-5d3a94ae670f@google.com>
X-Mailer: b4 0.14.2
Message-ID: <20250827-b4-vma-no-atomic-h-v1-3-5d3a94ae670f@google.com>
Subject: [PATCH 3/3] tools: testing: Support EXTRA_CFLAGS in shared.mk
From: Brendan Jackman <jackmanb@google.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Cc: linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D81F0120015
X-Stat-Signature: uha4a61j31w8w354qbnm8qkeoqhzcdqo
X-Rspam-User: 
X-HE-Tag: 1756292689-76306
X-HE-Meta: U2FsdGVkX18UT/0B20/2eACJrXpT8/6x2vZ/cRmFJHR0JwJSlWb9xn69q+3VJbDcYuUG9G8GAcHPNRqzp63apAAgA9aRXpmol2O6S3jdwjE9jMW3zw2ncWl2N88rzGzj/BFxYod4s0z84wkToG/2UrfH0AhqJHoJkzZJSS+RsjjcnFk8hNhcmkMZfAaWvTmUFT671D3pXbbsWHM6krbP6UF5XIWXOl9tKhmNMLd3IB5LNaKLkaFdLC4AoAcLe50qw0p79v0R6QIadgW46jvN4qMsEGavKkwKCuVTEirYV0AFWEDAVv+yVCAA7DGeFSpi6nPoeXZN9kMZG4FEu+8BYAPNaKnhgeUwJxySuaxHHhd8/g24R7mNKbJHlHZgYZmR1IzusCYbhPtbBGGoh2kQ9slCOZdsCqMQ19edvwzj/WgokipxVT1XdkklZVJ9bTEcnmqDxg4smbMcOLRzCEZ8Yvz9ukZeWzGe+3zFQFD6+bSR2uOtkxdDFGfjr5y4mKQvJLcjJqoyU5kaNxBnal9PO3JNZHGJqNqRdiWMLgKpVOEMYnwc2aQ7RvjEHeov6bjRvXjSOnA6qTIpJxE2GT+WDcKRncN2onoEcnCAjxabFtlw/T2elNUkMbTANrkoabEGt35WHOp3jySxRlpO+tvKm/0nvjXoE/bHJfihre1hhTRYVwfdG1Q1w0QU0PUqKVoVQ9Y2HGOI41UhFNEawYizgbJevGQN+VxpNkH0hg9XkrspeJ02L6Jbh0AhAJzCBGo5xbcRz3eUV4M3qMzh5Tlv0KfJO+BHyKNuDC3ZnwkoXHytVtTMZKynO7iclBTDkiJKK4YIPkUBPsN955bma9gCxl1sfHvoYp8bgith4YichazenKD1rS/CcFvKzvLNZB7lDyj/dH5PXbK5VyHz/mFajhL3h6xee7BKeTo6gx50kwUPJHiY0b+0C4mtU/P4xMQMl9mb6L1T5Er8PhjxAch
 nj+Quhrx
 r7F9FbDQV9fj9bVaVvn6XUXvithlT03sBu7M3QZr3MAAI2YKhNkXr6qcjmVow0vmZZArXhV9TLoyXkLp5egrKGXoeDcGivPjfIewpbiXx86bPRMXOC9R+4pPJXIL4W+jQNC/wm/s4D/IsIDe4G3yZh5sHTL5zVcoAfmIRJHxZMClQX6Ut/rWKuLC5a3ayhQ2DcYJuFgIEqffU/i8LhlBDRd/rBjN2dCxE1ak8GbV5KqTg3xX3/CTPfrmq0vUA/SEwKldQ+9rXcQDVDRWDtF/yBePlzCPBGRpnwz6StYm0OgSkbtNwSUYLooJHNGzpxOkihponldzqIGgb5iRg9VHNNFz8VFvboenhhLv+DDmRQZzjUU11V5u9lZuWLTk4txpS9Cop4+OVnNqLFvTb2DE6+m7HRJKnC4IpnAmeGgm36E56gq7Z8bxXZOHOba3rHYtHmnogcfU0lUpw9OqMhvVqzK2Ssz7lMtYB1blsRPE+ZqaZocP4zNFOm27SGb0CUF2nEL0D6yN4C1DyER/Xt26QhyMydW2j5MOwK/3qDFowFkgi9uQaFsTkAttgnZNJrBIJgvsD8CmzI0KpwiIlu/LeDaU41mdBQ+dAYSY1AKHT2KHkq10=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This allows the user to set cflags when building tests that use this
shared build infrastructure.

For example, it enables building with -Werror so that patch-check
scripts will fail:

	make -C tools/testing/vma -j EXTRA_CFLAGS=-Werror

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 tools/testing/shared/shared.mk | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/shared/shared.mk b/tools/testing/shared/shared.mk
index 937aaa7623320da1085a8e0f43f6a728ddd3ab1c..5bcdf26c8a9d51ab2cbd264f2f8a7445d7c036e3 100644
--- a/tools/testing/shared/shared.mk
+++ b/tools/testing/shared/shared.mk
@@ -4,6 +4,7 @@ include ../../scripts/Makefile.arch
 CFLAGS += -I../shared -I. -I../../include -I../../arch/$(SRCARCH)/include \
 	  -I../../../lib -g -Og -Wall \
 	  -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined
+CFLAGS += $(EXTRA_CFLAGS)
 LDFLAGS += -fsanitize=address -fsanitize=undefined
 LDLIBS += -lpthread -lurcu
 LIBS := slab.o find_bit.o bitmap.o hweight.o vsprintf.o

-- 
2.50.1


