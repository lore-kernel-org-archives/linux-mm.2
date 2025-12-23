Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1DFFE6FE23
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 16:18:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 242A06B0005; Tue, 23 Dec 2025 11:18:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D5E16B0089; Tue, 23 Dec 2025 11:18:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D8596B008A; Tue, 23 Dec 2025 11:18:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EFBA06B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 11:18:26 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 94BD613AB83
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 16:18:26 +0000 (UTC)
X-FDA: 84251243412.24.27ABCAB
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf19.hostedemail.com (Postfix) with ESMTP id BC4691A001D
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 16:18:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PWWHgnfw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3z8BKaQgKCMw1su24s5ty66y3w.u64305CF-442Dsu2.69y@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3z8BKaQgKCMw1su24s5ty66y3w.u64305CF-442Dsu2.69y@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766506704; a=rsa-sha256;
	cv=none;
	b=qTwRGgi22i0PqoBBlEKuTQk0OLSH/NIu9gmwZ1lry1QA62qLNKiWCpbpYtGOIgrD7aKDx9
	hVPFdHCZoRTOtctzbqMFBjDEqH6Bk/nFYYFvDxxSCaO4gcOTqrokD9dJRqApLPGPCK5ORI
	aYhrfi4rqUN/GueGqFqgoOuQIk8t+e8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PWWHgnfw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3z8BKaQgKCMw1su24s5ty66y3w.u64305CF-442Dsu2.69y@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3z8BKaQgKCMw1su24s5ty66y3w.u64305CF-442Dsu2.69y@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766506704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Gp9XbXDpsLxRfCX6IDYmiMiyLFvCv3BI5tK1fIK0sqc=;
	b=DFYLlLDP8o1oZbVTI77D9jPxHFkQzu4J/WLCjvCAj/zJGC2yKOI6p6SXcP1wsQrxk+hULO
	Xbxss13x1jZmfh9Xw2zIX0KCLGbiNnq/JSIIXr1o0/yXQ4rzO5N+qUni1UmodOIECa0+k7
	kjgibe7umkk6gcIEvlDKI5rMIZTUF4I=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47d3ba3a49cso2056795e9.2
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 08:18:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766506703; x=1767111503; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Gp9XbXDpsLxRfCX6IDYmiMiyLFvCv3BI5tK1fIK0sqc=;
        b=PWWHgnfwRiJ6VVI9zoMx9lwBoiiklR0Avzd3yelr7C6F0XfGO6wYMwaPouBg7SBUWz
         3bEWHSKeAhYUQNgR5OM6kOu1wJDfckwaDqkV2v/g6GoXj5Iiy95PJuHiw87kMzUPp18i
         5Zt3p+yA/YwuWDqcai0L3wETtC0q/tc6Rh14RSAW9d/D0vliJhaf/fpKY25uwaoNU9EH
         n0vvIsA7UUxZeaFTmCg6KujJAL24izH0V4xIKUSHv+ugJW3JTrG6mP+uKgfaOMbdITqW
         z+CZZDwnQCqHi0Fev+HTPTLORg9KX2D7cL3gUDHDqEPzO+1lqF/cwk5hrJAAl3eWu1GI
         3Vxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766506703; x=1767111503;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Gp9XbXDpsLxRfCX6IDYmiMiyLFvCv3BI5tK1fIK0sqc=;
        b=sI9VOTYAZjZqBr1V01YykiuF+hxD0Lrl86Tzmzs4oP9htiQo/64yMZf779QJiD+hiV
         dhFymFnJ2VRuqbf3xzhww+f6W7wzLRFNl3I91dBT5Xn/exxrHbS4hNAD59HkxmKICmxY
         vjJBiP+GRnCskmfZv5HfX2D9IQH4t9RKbLTsYmtNRVittFvOOlw5ujgZRLECSwMVLZZb
         xSmA5wF3R/GHrJNbNXzUKMDRmfR2pbz6amogmCddrFdhMyQ01wkHBZU47ge0lmcomhud
         U2c9WGdjLlgoKFEqSuIsAO4bAiuZPZVhvxOfBvdTPM2aCTsmBa0K+jwb6Gxsk6gRP/26
         +2sQ==
X-Forwarded-Encrypted: i=1; AJvYcCUn+bwHb4hCp+xi0WbN5NOVa/PTybP0Ns+JgnN22h6cUwUUdJ0F7K48mXoLP/ACnBSb6MTqI7mpUQ==@kvack.org
X-Gm-Message-State: AOJu0YywAM6CPdSF/E8xX8camyr1NXAZfk8LCMlBEjOwNnP3UZJU4Mp4
	4ZrggYlKjN6MES/ncLYlCwhNch/87meUF9BwV78DBlFsLP0OitPa5n5+ACCcncIANvXxuxrECAS
	MhddwdsqCj+xx0A==
X-Google-Smtp-Source: AGHT+IGPr3MNh9Y63iLCh43jSDD1otDWg2upubHvHKONp3Z/jU8xumFyRt2FzEbY0GIFeXDVV9+gjwkh4PeGrQ==
X-Received: from wrs12.prod.google.com ([2002:a05:6000:64c:b0:42f:bb46:77bd])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:115:b0:46e:37fe:f0e6 with SMTP id 5b1f17b1804b1-47d1997e733mr103467595e9.30.1766506703258;
 Tue, 23 Dec 2025 08:18:23 -0800 (PST)
Date: Tue, 23 Dec 2025 16:18:09 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAMHASmkC/x3MTQ5AMBBA4avIrE3C+AmuIhbFlAkpaVUk0rtrL
 N/iey84tsIOuuQFy7c4OUyMPE1gWpVZGGWODZRRlRMVOJa4eSMX+ihR7fsxYa24mXU2NqoliPK 0rOX5r/0QwgcV4GlIZQAAAA==
X-Change-Id: 20251223-b4-kunit-user-alloc-6ae8df0b8a92
X-Mailer: b4 0.14.3
Message-ID: <20251223-b4-kunit-user-alloc-v1-0-fb910ae0e50c@google.com>
Subject: [PATCH 0/3] EDITME: cover title for b4/kunit-user-alloc
From: Brendan Jackman <jackmanb@google.com>
To: Brendan Higgins <brendan.higgins@linux.dev>, David Gow <davidgow@google.com>, 
	Rae Moar <raemoar63@gmail.com>, Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BC4691A001D
X-Stat-Signature: cmjg8jpcq5pck7biqky8npi4bucghb1u
X-HE-Tag: 1766506704-91571
X-HE-Meta: U2FsdGVkX1/bOSpoVmh/qMvw/2TWmbvoZ8vCQ6loxvY/HhAihMladQAC7PRXnbkALmJxCUejeeFsORhgvon4SpnzvV6sPAIj9/qi/uS0QRZRQfRiV91+GBbKtbP7tFhE5TzsAJQf2MMbqmx2FWMiku4B/LA7KSgy0pmU9Orh/t1T8yXaQqUC37XWPoCKEPMY+H4wqkZ3D4CCEOohRSKNfAr/R8RQmhUfKEaUEad5W4G2eSan641RuJcV5SuxTf96OX4O+e8vuHmGoN3UBlxyUwWnJ8mt07YFMIgu8nXiGhID6zbO4m89pBxTXgh9IJL9q+eRLGJdB8sC25d2iN3SCyfTL0A/gI/Az8frsbV3EsXBDkq31RvePGCkqmXMPxaLeoXGipKO7HjP/4sOaGdnwjvLKXjG+no+wLe+RQZ2ns0NwcCH45QgrOGWGV5ceFSEgGtixfV3RvMgaVrWlyWf+AeecwaeNU+6iwqMbDtFRx+lAU+zgOn00FWXtH5Wr6vHiFyHEf3XVnk2zldvSs/Lo1WMdswrcqYTKhWNYkTsLc3gfQAcquSfa4o9ECrV5I3gBroS3tq5IFMeegaGnpKBP+5+tFJFpStspDmPqXoVALqPs9Mn4wc2Vc2EJrkXhxSS4VY3TFjkPQMaXgNfi5+O6hm/KGLPKto6BAUUpdOptr/jKw2NL5CCpxg2wu4bJcoyRllYF4dj93OE18pdvqjf5g0wl5PpPc1/ghbrUq6a0zSZPNOBXe0QYynVeP2ANKwqL4zvGluoAlchYiIZlrU+4nf8KGEEOHN6lLTfjKcLz0dIim9JmxG5qaw4LbJA0zltHDp7WupyDPr4NtdzuKZXkxIDCz8F1fZ6Yn8vtMuE11zG8H+bd2LdzLYDk/5YjcVb2W/8Sh8TD4Os3uS2kP9vrE4hr6w0xGde/3vWbU4cLFw+BEisqawhZNYRagfVs9di49SEFA97IW8HbCMp2qy
 3KW3xIY4
 VhzTRtHpKMUuu3gb8yz1GXCSDlJSkcws5fKH04YGXhAOMco5UPgWCFWTUnzJw+iT0HL3jd+kbg9rc2q4U/ju3hbUqd3TJv8PHbCotU5m9feghmE19iisfATplRnzUJa7dcPfAJJTXaKhcUSzrqjC42JE9PESFQPUFdMfroVqNSPvRlnGRCb6RN9wke8SFikan1AgwfpgwZTbKeqAxDDywnJkIuIKMKZHoKxIXOdt6iY5QvEKnThSRy5ANQYhEXCK5rVPQzerQoHQOfyXeVorxmFs/MF0vexmjHsLQEZOg9Zdc7N/SyKbEugH3LJdpD1k7oikUFDmJPOy2oSxuSwed2PvfsXYJaTxI3sdJHr9KmuIuOa3DuWvekp3251/hvzfzobLukPzzFWk+8yMk3VsPAkxthSo2moQlrlnlhSo2UeyifKTpn8lRKje4nndFL5aBqWWN+5ZmsGDZYt/qYovd52csqMHOoJDN8ZGoR0PMIddZT8432DIpVQ3R66etspyNQlAmI68kdTIpU79XVzExUCs+FBt9w9EkMdU8fuIg7gde8wgV/JeacOfRUSEMvNz80aL4ipER6vOSlaUbuRAKP2FEDh5z0ImxYupBloTjtZM6lST+DcUaX0hds2Xiv1iYiKOE/zhek2DcLtM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kunit_attach_mm() leaks an mm_struct (verified with dumb printf
debugging). Fix that. In the process, add a new kthread mm operation,
and clean up some nearby cleanup code in the KUnit lib.

---
Here's how I understand mm refcounts:

  funcs             | counter  | manages lifecycle of...
  --------------------------------------------------------
  mmgrab()/mmdrop() | mm_count | mm_struct and PGD
  --------------------------------------------------------
  mmget()/mmput()   | mm_users | userspace address space
  
  All mm_users references share a single reference to the mm_struct.

---
Brendan Jackman (3):
      kunit: test: Delete pointless resource API usage
      kthread: Add kthread_take_mm()
      kunit: test: fix mm_struct leak in kunit_attach_mm()

 include/linux/kthread.h |  1 +
 kernel/fork.c           |  3 +-
 kernel/kthread.c        | 36 +++++++++++++++++------
 lib/kunit/user_alloc.c  | 78 +++++--------------------------------------------
 4 files changed, 37 insertions(+), 81 deletions(-)
---
base-commit: 9448598b22c50c8a5bb77a9103e2d49f134c9578
change-id: 20251223-b4-kunit-user-alloc-6ae8df0b8a92

Best regards,
-- 
Brendan Jackman <jackmanb@google.com>


