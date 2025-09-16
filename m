Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84DAECAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 16:01:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DE378E0005; Tue, 16 Sep 2025 12:01:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A64D8E0001; Tue, 16 Sep 2025 12:01:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 794F88E0005; Tue, 16 Sep 2025 12:01:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5FF0F8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:01:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1029B140249
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:01:17 +0000 (UTC)
X-FDA: 83895577794.08.40A0B8B
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf01.hostedemail.com (Postfix) with ESMTP id 209D240024
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:01:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OipuWBah;
	spf=pass (imf01.hostedemail.com: domain of 3yYnJaAYKCFAAC9w5ty66y3w.u64305CF-442Dsu2.69y@flex--surenb.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3yYnJaAYKCFAAC9w5ty66y3w.u64305CF-442Dsu2.69y@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758038475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=16noxQnX0KIlK98rjBFjGAUY+DX3PGXWiRxf/Pcl2t8=;
	b=l1LYSJ1IQ4fiFJ+VTyUSg0VFOvAwPOQ18Q/jXuKJxEkoOZXBbCR7g5uSsu1rVVhnun/S7E
	EczBI7ZLPctbCE9vsoQZcJb5D4fNFKLLryTIuJwGe5l0LGWXHJ27n9Yn3IKMJEvFlUgubj
	3jylfwA6BCTE63vWOcspPgR1eCGvLJk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758038475; a=rsa-sha256;
	cv=none;
	b=ZVA9skEb7U428W3BH9hihVRrprsi4JNSWLFDgnsASRiCNybKJTWCW/zuDYTmFn/ZueRtlu
	Qm7iv1Gs8ntx0HZ45N4Gb42I8ZaZZyIY9VzKdhXjeYzfwT2eTilCiwXgu0jOknqApZYnjg
	+6SH9FYtYKWvkIZsnWyxOOj3Ix3/GcM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OipuWBah;
	spf=pass (imf01.hostedemail.com: domain of 3yYnJaAYKCFAAC9w5ty66y3w.u64305CF-442Dsu2.69y@flex--surenb.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3yYnJaAYKCFAAC9w5ty66y3w.u64305CF-442Dsu2.69y@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2621fab9befso34927195ad.2
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758038474; x=1758643274; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=16noxQnX0KIlK98rjBFjGAUY+DX3PGXWiRxf/Pcl2t8=;
        b=OipuWBahiLZdtU5vUr38mXB15AMdGoBtscAh5fOlZjjIhYOfH4o3aq/NkDmLutGV8h
         1mCpHjtSlYK2kEgKbWxdWi2lhw128WiJD84vJZGSUS08yLSmJ/JzUDoFz+bh+PGDH96y
         AWRJGS+wlnRSqPnTfyQcCtrkgCeiCzLYAgzu0ach9xkVC1qOCC/kMFEVd99YMDOMq9kK
         WZc9MUE7GvCuwbvyU3z9Z4tHVN/sjjFFEehHB/iLoFLheBkiq1jjiFyOqsI5sv41RKLV
         Xsz3pezgks9wGP3kI60Kn5hgwqKNiXjTjsdWKvjRj59V+B3nyAJynnZTAL2ldz4cEC1o
         BEAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758038474; x=1758643274;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=16noxQnX0KIlK98rjBFjGAUY+DX3PGXWiRxf/Pcl2t8=;
        b=TSkVrlP5LaXJLxrWI/2/5lN+Khd9bxYoNkwY+4iLFoSQRkaqMbwjRS1DgnYbEwcrPx
         5UYHrU9zyI3AOSt57VKOjMwYwABU4+kmU+9/6g+N7c+O8aK/PWbLmwQ0g3Nfnzz+P6iy
         N6lfRWGQWLKtlg3PRd80mTxbYh1TcurhwAlUGjq8B/4pla76WmL16Vv/x1pISpAucLgB
         jtSYDBgyl75mtycMUv6ypDLmclOYRp2P2s+wRV+Pa2ZFZ33J7ExZPhW+GDMEc+3Udj9Z
         PkEX1p6uNptQdUlZNnWe89X618s9LAe0+uaNHTJ+gO6xtzP8OLq1CqAa5dBztbLaXbdr
         XcNQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0iDIMsrxXdZOL0WNPmEso+2oNsDB+x5ls7AYGqQLcgfPZSNTx1KP8kXq+ZBlDrTSNCci8VyO5Gw==@kvack.org
X-Gm-Message-State: AOJu0YwQmi+6NbcUzaDKB8KDL7t6/NrUO5g3Pl25yo5swJGle3jLJEsn
	C6xtza2weyZLfN+BoGd2VRI+bTXbu4wFPqnwzhyz8Mn+wPN2ipmt+sPbccedzmHOAklHKSAO5PQ
	y0Cmtbw==
X-Google-Smtp-Source: AGHT+IFd7myaxOXphUd/MVgrf6Fz4tV4x05UEurwdAPSr2crZiMufGY/rfW5WckYFeXemaVy5X/Dfq/hQv4=
X-Received: from plkv16.prod.google.com ([2002:a17:903:1a30:b0:267:ea8a:35da])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ef11:b0:235:e8da:8d1
 with SMTP id d9443c01a7336-25d24caa073mr179675535ad.8.1758038473731; Tue, 16
 Sep 2025 09:01:13 -0700 (PDT)
Date: Tue, 16 Sep 2025 09:01:10 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250916160110.266190-1-surenb@google.com>
Subject: [PATCH 1/1] fixup: alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, rientjes@google.com, roman.gushchin@linux.dev, 
	harry.yoo@oracle.com, shakeel.butt@linux.dev, 00107082@163.com, 
	pyyjason@gmail.com, pasha.tatashin@soleen.com, souravpanda@google.com, 
	surenb@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 5cy5uxt9w7f4sef8h5jczcaohsuwfysc
X-Rspam-User: 
X-Rspamd-Queue-Id: 209D240024
X-Rspamd-Server: rspam10
X-HE-Tag: 1758038474-183156
X-HE-Meta: U2FsdGVkX1/Ma0hQQGaWr65Ff2OcHsuLKFdo/cQVXJIOfUfYVBpkfNIw1iYiw9tDQmVVFmnsHrS/krMdDfUbxLxemaU2OZq0V+fwIdzutGTO0X0ouw3p+I6DvtHHJPwYY0codXpXAFsl14AY3R/Y6bjxppumAY1NP8T8x3vFBVBfjeoyslhpWzJG3Chwgxkw+aDh1YyYQevwkyS0jjH38Nr4a+Nj/TL0UQXrQtqnI367Uhar/DRNY7MDvFjSrBgla0i6p1Ofigtj02b1Q4FrwXIC/Nhwx1AgQE5ToRKIKbvPOX2xGjV8RktcWgAW+CATuYIaOFfHGzu2Zwm7hZgdA4ytHZMjO9fwqhZIZwJXcr8wELSwHaj7wDW0s/7Xyy0oS3torPGbpPDHpDmVjCbFfGdScCs7FAqpgle73Wk+cR+K6haGwZ5FupY19knToZunFLcAE0fBmfzVZT9rhmAHRuM6jnT/CO1Of5MnuytzpLLVhJcScDwgQxIN139RIjzLufRq/melwNhyVctA3Z9fMV0cPvdOjT6/c3/232agP2QHCCKTx/w47Xi9jmJOD4ShdOon/YSA5SNFEuKMmZdo0Xhn/sIj67oxHenXA/BhJnEIDAN72POpDXI19wqX8MRqarJ7iBOtK/xTH14mY1PWEt27Lz++7eDAgPbIUynWFUH5pvtZOM3TWzX3uJZNQ/b9LrLNKvbb99vgp5wAfdKnIIA0kl9nC35HMFPhb23tsFruN6l1x59Xon499LAIhtSEZ0O4ltZxVzONmBSz6oEk6E6HQ47Yq44mGACfbBXrXMEI7xMaDf8Lb9xsBcT4Lms2aXGFlgk6TDjeOMfM6UDCz6PMBcm1wVE0hKLGe3bIrS4K6H0MsDuvbMZK26qhrGsBdu5JdNiSNTSzfFmdLk+s4YJwewIthpE9os7/p9JM3QvKsOjCvwbFsJIa1Uly9MYFknJkFFvGsj0FAwbAfy7
 VHjTNLKQ
 DrCzakm5ipXP4GGE9az5sXRNVe8ODJ2dYJZJQb3EGpVJT8U+aY/hqbsEWr2n5+I+4dWZReFMsllNWRXm78tzxehdeJB93DERIZE9lqw9NNP1TuOjBtOSQ7PRw/pG9xOQG48IgyogzJoeVZBrSHimuc54zlr4aHY08DvWIPBGje5Wy5+Q3cCbzB3/MpQNT6JMSRhF2So+auaX3ssl8ei1Lp7APmvjNmn/cK5FL5dWjA5mzIs5oOfOzkg+Q19fCX8pKu1YyQcJtq3Ji21o1lNAz2ENzWd11iCjRXUIJYwjY5hEC7w6H30HRuKx+Hj42bBUlo6+QRHP0gcWyQd6ZeOZSyDC/zyk+QKNng5puPtE9POdw8DZV6YbVei3dxm2Jo+Wsbc/1tqbkZ6EEsBmhlApRtpMmGZQBGmLo6sVG3qPzkdtQTOl0/YAiSBRuh0LETs6pidC5GbtPtGOIwQa9z0ENoDwANXca5on71v3Bs6tJcAdEFEjqeRVG4sGJipm1ogeBrH2NVl3xBaj5KLW03I5lKArHD7MsloCWzbdqNPtB4zgpngv53DTmcyS8DYlkB+ClwsymO4pM9KrZg6G9cH7qZFwZ/h4RC+ptlAqXql1VQK4vTeCT3w0bQLMgm00iy7MifkGeIglfMc3C3wI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document new "accurate:no" marker.

Fixes: 39d117e04d15 ("alloc_tag: mark inaccurate allocation counters in /proc/allocinfo output")
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
Based on mm-new

 Documentation/filesystems/proc.rst | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index 1776a06571c2..17668f82ff1c 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -1014,6 +1014,14 @@ If file version is 2.0 or higher then each line may contain additional
 For example if the counters are not accurate, the line will be appended with
 "accurate:no" pair.
 
+Supported markers in v2:
+accurate:no
+              Absolute values of the counters in this line are not
+              accurate because of the failure to allocate storage required
+              to track some of the allocations made at this location.
+              Deltas in these counters are accurate, therefore counters
+              can be used to track allocation size and count changes.
+
 Example output.
 
 ::

base-commit: 199236646ffd82b5a5bcf2bca1579ea06cb0ae74
-- 
2.51.0.384.g4c02a37b29-goog


