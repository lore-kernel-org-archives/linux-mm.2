Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5896FC6171
	for <linux-mm@archiver.kernel.org>; Sat,  3 Jan 2026 08:47:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 336AB6B00A4; Sat,  3 Jan 2026 03:47:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E4546B00A5; Sat,  3 Jan 2026 03:47:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F00C6B00A6; Sat,  3 Jan 2026 03:47:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B3786B00A4
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 03:47:51 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AA26D1601B5
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 08:47:50 +0000 (UTC)
X-FDA: 84290024700.11.2041B19
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf08.hostedemail.com (Postfix) with ESMTP id D0147160005
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 08:47:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cCHBqoOx;
	spf=pass (imf08.hostedemail.com: domain of ming.jvle@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=ming.jvle@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767430068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LLfzaNCKblQsWrgVFWjAAIDp8UyGda/a68IUZKqrEfs=;
	b=nNlx6pcQ0QlxS6wWE36km6LxqPmYVoODX7Eof65VupFkBKURNqd6SOfT5drEVPaVO9qKvy
	QAu/wplrHuhNoAtIAIJz66LWtBMcLjHczdacfymByb1NKQdjZMLGqsfGmqOZV67mfQezYC
	EDEL81Wf29ODhZ7KWX0vQ57knBbQWrs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cCHBqoOx;
	spf=pass (imf08.hostedemail.com: domain of ming.jvle@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=ming.jvle@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767430068; a=rsa-sha256;
	cv=none;
	b=vtRoB1Kyb9ljPTU0gjmMy8vrALyhjavTXTd/kOvBqWmhpyMYeV+PLQ/jfTzWkAUXvL1k08
	WzjH5cNH+lMDp9W9aP5HAkoqTySvRI7C4BWX0im6c5XZgj2n0QATdy3zqKr87YI6gKWhwO
	syNM9gcoIPC1VXJ6Dgb5cvAPTT0h0dE=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-803474aaa8bso241887b3a.0
        for <linux-mm@kvack.org>; Sat, 03 Jan 2026 00:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767430067; x=1768034867; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LLfzaNCKblQsWrgVFWjAAIDp8UyGda/a68IUZKqrEfs=;
        b=cCHBqoOxbWuilVY+ZSFp5OQN6j5RDhvBRvF25aSlW/tMDShq8cuU5y6hd5tbiz+RkJ
         vp93qrPCpXFyZBvr8c2BerlaRs/MzXv6NAI2dyzR7eH1ob5ChywYlURECyQuz4qUanvy
         c156ZinZnRfhYi/93MrNIHe8A38Z7rfuVelKA52khLpuugSwwH/J/GFfjqGDG2ebovUH
         UkH7mDXOEFNl9r+4c89xt1q6e8blBmD89f0LKSubdqY7WScxM8EmIEVIt/y8S43DaPnB
         EbsUtErwd2R56joO+50Bhcux0zGKKpdN7oaCCMNgZurM9m46Zqrpo+39aoAkBM2f5rgd
         EDGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767430067; x=1768034867;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LLfzaNCKblQsWrgVFWjAAIDp8UyGda/a68IUZKqrEfs=;
        b=VuqDvP3QnN3R3E9AM/j0xLWP8FmfRDf2LT6L0K09D7JVXfnxB11aYdFnN07OcnZZ+5
         2F//8O9WOdBSHzZxwcxhAmyLY759/tlFXbZTcVw8zLtfnY0GX7fxGwSy+wECimoq1HbB
         Gu6NX5ilAiGz3YgyumeGn5Miq/Jcdo/104UArQ4FOJbbDH9yxXVGKuRu9XYLKgyQJyne
         fZ5gbqn+MRDHuWu8HycMewxCNWPMUfpnbACfPk+PhGIaapIHnjBZQHf+GPo4gqIoatGc
         ov1aUl8c9sYpB2xg2I4MTnV1Z/cxpeZNBwD8p59lMEZxor+SHOAUn4NxabvfOkYC8Bcz
         UQWA==
X-Forwarded-Encrypted: i=1; AJvYcCVY6F9WcmooaaWAFDza0lUn0U87rJ8rx6OPnZvfAo7JXq+c/l+qw1vBu9AWWpmUxyjCURiXJdMQ6A==@kvack.org
X-Gm-Message-State: AOJu0YyrE/y8M02Y0gTGkoeMDW1QrkyNYtimIAdlQdb3KpwaC7p7sJrv
	+mFYg+dHKoEy5M/ANoQ4UooKSPv8kpb1nsYxWGOsC6jyvURbaLobHk/i
X-Gm-Gg: AY/fxX6iTgdCESSuop15V5C8bDreOg5Z6A6yIYmyrwNFtRKHW7sYsymjDXS/nzyY7lc
	mcBJcLLDNCyb3rqPu9cvSqpW41P3VFzjYN+lOIy3PhpZDofm9BKInh4GtJzsmQH27x8fZMb7QSz
	fA+gxEXm+gzihRpV6qJ1ahvljVYL6sBI6Chm1i3bepZzrLcjsmU6b//ZIymo72zxbAyvey9w65H
	bGuUKaXvQRj4MT5lcngMvZI8Yiwt/Io4dns3d3QXYKbhNxI8eUX8S8Y0z/npk1+L8bDwVXcmttt
	nKMCpWMJGZwnZNidoCq23yQ5gXiJYfMg43EUzHIBh17XeEl1u4Ou5AF4Qo2AxerwhliDyQ2yw7y
	i6Z9pJKEFN0VG0D5Wn709Q1CVv9PxxKbg2fWklae2xuAn/Q5Q1KHpMq1salI64VOOhyPiAcxCNe
	jZw0WfYNoQl8i6NElN7d1N7UyAvHRQuYCeIuk=
X-Google-Smtp-Source: AGHT+IFlp8qcq2QazAOf3KnrJVHQQLc5fUVTVkMNEtXBSYaNUnUycb5/s395woDebt+kaXn7KmVKuQ==
X-Received: by 2002:a05:6a00:4ace:b0:7e8:3fcb:9afb with SMTP id d2e1a72fcca58-8148ba19ccdmr1341264b3a.17.1767430067508;
        Sat, 03 Jan 2026 00:47:47 -0800 (PST)
Received: from jvle-ThinkPad-X1-Carbon-Gen-8.. ([210.73.43.101])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e197983sm42704939b3a.33.2026.01.03.00.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jan 2026 00:47:47 -0800 (PST)
From: Keke Ming <ming.jvle@gmail.com>
To: mhiramat@kernel.org,
	oleg@redhat.com,
	peterz@infradead.org
Cc: linux@armlinux.org.uk,
	catalin.marinas@arm.com,
	will@kernel.org,
	tsbogend@alpha.franken.de,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mips@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Keke Ming <ming.jvle@gmail.com>
Subject: [PATCH 0/5] uprobes: transition from kmap_atomic to kmap_local_page
Date: Sat,  3 Jan 2026 16:42:38 +0800
Message-ID: <20260103084243.195125-1-ming.jvle@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3fp1qug14mww9hu36wca1zugjgryhr7e
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D0147160005
X-HE-Tag: 1767430068-890238
X-HE-Meta: U2FsdGVkX19N6nvGkiv7SYL7gweiXXdp/Q5evWkLAxU/jXul+/b+6JX+jmO2UAgBhAA9h1z/WuI9V3Jdm9uh5cf8holAkOP9Q1Cp8wbNbaU9vWqiOkNd3LtxW6hFBBrWHHwjvG1UcrM32+4OIXTOcaVf/i1kDUsCJPzvRWCyXZlFDSxmGXKDJoNQOPQf7wgGaLluDw4+s3+tbDfUWn7tkiDx9/eyQ0B4Xsp80KUO1NAUNNJ2RPNaTgs66OhqtQ2CbNnYqwcYsGSaoXVj/ElOgh3Itm0jTeFtn50S9LFFGsMijsewMd2NbwPVLUyZMfX4QqU/vMZHFGhdVjpHM+O7iZNDlMGTQFugNg7Phsp7Z9P4gYZ8WessIwIv1IXcfrp6Rhgr7OyPkCbdqMHS8xpMpCTd0aZWsn/MwGq3UFKjJoOoCDYX8HGOBm6aV8gGzCE8BJVAmAHn+GH45p7hfcnxgVBvDQPmboK5gLy9wjIHw7FFeehrxjIj7dNK3MUA+bJ6RJJOcmu++z+aRir57qisTdyy4kGmjD4aJ6lvbd+X6BPOeP9uEbNcDh5OZuZRjTbU9dSZfAwMiF061YvYWVJDFZn54YeOTBDrrT0WoyBF3m1841Db8+1hKt1xKz7/HmKogMUNr9RcWYs39i4yXQLHvCHCgkdSfIBMndbBWYsaQ5Y6MYpsx8FktY2j3YiYoEyAKybXSV+uv8MBHAD03GYRaYKGeLdodsYeYebn9OaPpgtA1Hby5WxkWHpMcqgKtvaOelUOG0eUIbl6t+T/NDsf+Ixmhr4ZANyuWnl7/Aq6HwcHMi42UVBLyiKpNVC8mtIrfR2kddJzSlllgPC+dQns5Jiy79yE6BdhqhFrERjAzRvF4EP/zEQ44UNzT7QPQq6GvPmv5gsFXEMsCAGqUeGKytPX787XBXmlcguJB55F6Z0tzcHw2vUk62jDUoL0Rvlf9iN9dEfLbSPqKYiiR/7
 47OeWMSY
 nojckRFcUVZ17UJxY+dQDsz+sEuqgQ4dPpMKNX0hfs28dzN8cAjnSKCA3L1bS1g3wNubVwgjdaFvNlhx8niZ3bUcJA78vFMiwoxfExWvMbhpzYevEqsNeazSQJWKgUPH/BKIId6VryOaP88XHRLZ5Ynpz7szwiE9Zi0efCM1fIi46l420f/cQFEv1L6K2kAsrKbeXZ4ZWKwGRZDJ70NWpuY5c3KRKqsYtouHiK5kinTwmePojoKjgjsMgtbLrl9WFu2LWV+D6Sgx07HbmcAQVsZrJrvcBeAaFRtbpn+nQ+95b/5Mqk1rcuDQDWlY0xJM6trt1Gcjj/j0gN47YV/wL2CGu/3vId84jb68MqIlNBmZTh4RiYK+T7P4q0UlfJiDKAtxJFTYeZvt20axDNg0FA6YfhtT/5IzS339CNS3KRT5aUsxF/qu6/pxcbvV3KMJmfN80Q28NDxrnFDg0YkaUC6Hi0XNvj0id1FnxvXVdr1aG98UnANyjroH5sW4maV8hjGA3uO4wpRCOFKYV4wqcKTSanM82GCyUV44EPi39EqLHqessSgrz/fuINyejjS78yF64XOqrcnuBgu4X1SS4XDFPHZgyz3qvboenPOc+XTnuwIM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The use of kmap_atomic/kunmap_atomic is deprecated. The purpose of
kmap-like functions is to create temporary mappings.

kmap_atomic() typically disables preemption, while kmap_local_page()
allows preemption.

According to the documentation, kmap_atomic() is primarily necessary
for contexts that cannot sleep.

> kmap_atomic() may also be used by interrupt contexts, since it does
> not sleep and the callers too may not sleep until after
> kunmap_atomic() is called.

> kunmap_atomic() may implicitly depend on the side effects of atomic
> mappings, i.e. disabling page faults or preemption, or both. In that
> case, explicit calls to pagefault_disable() or preempt_disable() or
> both must be made in conjunction with the use of kmap_local_page().

Link: https://docs.kernel.org/mm/highmem.html#temporary-virtual-mappings
Link: https://lwn.net/Articles/836144/

Keke Ming (5):
  riscv/uprobes: use kmap_local_page() in arch_uprobe_copy_ixol()
  arm64/uprobes: use kmap_local_page() in arch_uprobe_copy_ixol()
  mips/uprobes: use kmap_local_page() in arch_uprobe_copy_ixol()
  arm/uprobes: use kmap_local_page() in arch_uprobe_copy_ixol()
  uprobes: use kmap_local_page() for temporary page mappings

 arch/arm/probes/uprobes/core.c     |  4 ++--
 arch/arm64/kernel/probes/uprobes.c |  4 ++--
 arch/mips/kernel/uprobes.c         |  4 ++--
 arch/riscv/kernel/probes/uprobes.c |  4 ++--
 kernel/events/uprobes.c            | 12 ++++++------
 5 files changed, 14 insertions(+), 14 deletions(-)

-- 
2.43.0


