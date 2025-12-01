Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F703D116F5
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 12:29:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BE696B0012; Mon,  1 Dec 2025 07:29:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 896426B0022; Mon,  1 Dec 2025 07:29:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 785566B0089; Mon,  1 Dec 2025 07:29:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 62DE56B0012
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 07:29:33 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 13C9012FAA5
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:29:33 +0000 (UTC)
X-FDA: 84170833026.07.A5CEBA3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id C8D1AC001C
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:29:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="D0g2Aj/m";
	spf=pass (imf10.hostedemail.com: domain of lbulwahn@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=lbulwahn@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764592170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ca8yK1wS3qH2YmoRxhlaDFY2F5cnDgLmksqHhgU1/EU=;
	b=Kr6QJa8zQqSe0LbhYzLrMhqZtnIXx/XDqjcXOGNdraRAGAK1NzpNGAdhUFI/vkuoRTrP28
	EnglRk8ZTy09Zm6/UqpMnAROrr2KrOHZI5VZ3cdgCRmHS6hW1qFbpyhQFlkw+91RDJ5QrT
	Lt9RzysToZ/z2/rc3bd9QmWzz/6AEHQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="D0g2Aj/m";
	spf=pass (imf10.hostedemail.com: domain of lbulwahn@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=lbulwahn@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764592170; a=rsa-sha256;
	cv=none;
	b=MgXHNPoxhz3JqGl3fKyANTBRY9iUIYC8zPRNDhHsE/lmMaCL6wdpxZ3jKFAC5rV3Em3ltG
	6ONET37FJ7UmiGdhAbzDUpAvEfCLX5PWAGs0goChvVx2eTf86aq7HPZIGmXPV08gcBPjyq
	WvtCMaPMRBGvATMUjhI967ybWsi1k9U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764592169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ca8yK1wS3qH2YmoRxhlaDFY2F5cnDgLmksqHhgU1/EU=;
	b=D0g2Aj/m1Cqsk/ZolCS7gztLf+MyvPwZJe38ng2cU/Tv4utFhVmlc1PS7qbF67+dShXjtt
	ICmRFn+VrAd9SRKGfTNyCmhpccTDnCzIrsr1di8cLVyURWtp3yY5uPWDpKFc2k09jtJAub
	l/4Ad9o6gv0OqHxtptmMsiIfS9dyuj0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-568-NsD3fIAkO7OA_Cz6hSzdPg-1; Mon, 01 Dec 2025 07:29:28 -0500
X-MC-Unique: NsD3fIAkO7OA_Cz6hSzdPg-1
X-Mimecast-MFC-AGG-ID: NsD3fIAkO7OA_Cz6hSzdPg_1764592167
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-477a0ddd1d4so24082455e9.0
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 04:29:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764592166; x=1765196966;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ca8yK1wS3qH2YmoRxhlaDFY2F5cnDgLmksqHhgU1/EU=;
        b=PECRs8RxCqjBys0dIfb/4OtyNkN+ITSiSnpMgQ9GWd2/ROB5LwCSkpqf7Sv8PgIi4S
         pvS+bqTuHGo53AcdiQf8xfQ6t5zGS0kg7+LSfbwdqB9FOabnDD6dEOOQzqSa3o2Gb4Y7
         9uqUUFDGaJwSCpaCTw8S1SnB2uSreXwVK59OXSYEjrnA/eI9uxSAgCUGhaD5GACp6yqB
         l3TEuWntRtZfnRg7cVmnZVGObnyR7Ftt9QUlYpq8EiHVlBNSkop9CFOwgaMhZrMPaSmP
         Z48gRfED1rtWdJ/IQUNyMNg3Dl70LK0sPjJbrRzJsAC02d2BCAHtuoDoSEaLKx5RotlZ
         LFOg==
X-Forwarded-Encrypted: i=1; AJvYcCUfDBVQdzZjVgP4Vho8M9qwdC4x5V2i8Uf0KUaXxpYBoWHe4DDdTjbfv54BQgvG8t3kf7CL0gvc1Q==@kvack.org
X-Gm-Message-State: AOJu0YxRjDiWrfSFoAZKooihW2AsMytKGuPGPV4G0t1VZIAOfeFiCjnU
	yEEOZpw7o8oPUwe3wyd/Cg4AgTf/9qgJkNRLRrvJRGekM8HieD4y/6g0H8gqWCLdCIx8zu90hH7
	YYbwiJn7L0HyQD361n9AbW37T6hO+7B0XlQY/+MVC0QxN2wfP2UFktgwxmhvX
X-Gm-Gg: ASbGnct56Wdxusa8R4qNeAOQ2Oifiey6V9rqe+Oy46PaGdtrOa5CXToVhwfsmjjqg+O
	gnHk3LevC8uWBE+Y35Q6ENnzss5mx3v7PVyL+hj98elh7RPAgTc9XLhRMiMoB3+7TO4lvhM7+a3
	NYgCNjTnGQBr4UCIOafJ1cGYEGbjfOG+2Uz/cgSbbY8dImoPvfkFPheAfREpfZtTr/eVSrKr8Yh
	FLsLZObkD1gDKiU4pgUg4wfkg8UgYLYfJyPDqeWaA2nwnC1sPvSD4RsBnrFFefOCtYM9nT1MS84
	2KCuMk9PNuL/cralMM1oYX8FLK+zBTEqpmGXkcdbk6LHG64g42mRdwxtbw09XanB56ciWvsNCWX
	1ZSlPaDfi5gZwYINQHZ+aZurB2tHhLiJqy6W0HqMXMNBKxjEIvnu4uMMj0Ok=
X-Received: by 2002:a05:600c:35d1:b0:477:fcb:2267 with SMTP id 5b1f17b1804b1-477c10d6e76mr438528545e9.8.1764592166421;
        Mon, 01 Dec 2025 04:29:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGHHKHctxlRfqZ9WkPraYQ3bIJJ+WctP0gnjsdA4rTh8AqmKuDWYVCveAkjDx7E7cjJwY7WCg==
X-Received: by 2002:a05:600c:35d1:b0:477:fcb:2267 with SMTP id 5b1f17b1804b1-477c10d6e76mr438527865e9.8.1764592166016;
        Mon, 01 Dec 2025 04:29:26 -0800 (PST)
Received: from lbulwahn-thinkpadx1carbongen12.rmtde.csb ([2a02:810d:7e01:ef00:ff56:9b88:c93b:ed43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4791163e3cbsm243345255e9.10.2025.12.01.04.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 04:29:25 -0800 (PST)
From: Lukas Bulwahn <lbulwahn@redhat.com>
X-Google-Original-From: Lukas Bulwahn <lukas.bulwahn@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lukas Bulwahn <lukas.bulwahn@redhat.com>
Subject: [PATCH] mm: fix config option typo in header file
Date: Mon,  1 Dec 2025 13:29:22 +0100
Message-ID: <20251201122922.352480-1-lukas.bulwahn@redhat.com>
X-Mailer: git-send-email 2.51.1
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ORmrAj4FjXspBrJX5ej8fONAAf1yy7xcFGmcfDtjwcY_1764592167
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C8D1AC001C
X-Stat-Signature: a8113bnqyhyuui5euhynunbtacsrgfqu
X-Rspam-User: 
X-HE-Tag: 1764592169-531620
X-HE-Meta: U2FsdGVkX1+3BInOfka1xm1lNuj33NF5ncwQLVNInKNbciAeSYCRFzP2pOjchRpbz0LlM4IsZwvr3YUxzMmkepxozGScD+5dlV5bqmJYUE3+XZ0IuZ3//pHgi10wHP8KsPLlfeL0IgtfYrXe5rSnR9ruQscbLJBXPo4H+i6NpAHnUfqFbvV6zJDSkjJNDG0qdMucc/kVV8hZ7SYNjNkIqbtpEx9keKSquQa8pJ4XPOpPwVZKVv/9l/M1CbznkSbGwbzkKTSVGv/ddmg8jG6h4c2K7q9D8Pdm9tKsX2dn+FciNC7AhM6GGZ6S+uGJ16AWO5FxbcfwwTak2HGTVTZkjwm57lTIe/kh+YlQ8RK4FTs9acTGA7bLqC2kr87CAeR3gehnRVIXsfCnQwQEF61kx5b+x0Pl/hmAEW9IzAyfH1t7T7f+xuVxHSJYdwVBH2H9PDjf2OjIyQML+kdumOHwrY0pxkhXKv6Pbup8HtUQiTtsppmmKboaoJql2W7+4UVodRhaRldPGY8ORbdKygQeSlvPxi2EEpXZ4VA0RxaMlHJ4xaNC96/UZKCB966nJLwybwE/pS312rqye3f8WAMnXmhbOEsBQabNot2W5FLWlNyyvQ6PN15nXNakL8+QA4e3UDcI2HulUq6CINJB/ZZMLW405rubOlbvNDGXo51lb6cVRIh0EmEHHPF5j52gQl9k6E3iS9FaJu9glWJmxnTlPX6+nG1Pk3DZ7UuXCR1syhUq70cYhkCz8c92HmXtIfMeiZfcYP5SoANkt0cC76DChO1bcAfRORxgT9YCxNTlxFaJiAah6Qa644He5Ew5XF1m2T+SXvFZRBD84HbS4O3iy3hr25jm7rEBP+5+4WpbC8PfTY2qgt2y+VRJAIsaR+xYRZ2S1D9F3ps3SMRRZKWtgH5k5Kc8uaW02AeUAY7DL63+agdG9uJyqm3GoL6KtxaoohhfwraANRRZt1ZnrT3
 +JMCCFlf
 IWdR4ez3iNIcP9/0a+7AIT7nV4inWBmgiSu4AaAyugCziR9gq3hoVjskdlppbVWSQkY7VkJ+/bjUG4LNHAZ2Ct+IcSTk6Odlb2n18
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lukas Bulwahn <lukas.bulwahn@redhat.com>

Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") significantly
refactors the header file include/linux/mm.h. In that step, it introduces
a typo in an ifdef, referring to a non-existing config option
STACK_GROWS_UP, whereas the actual config option is called STACK_GROWSUP.

Fix this typo in the mm header file.

Fixes: 2b6a3f061f11 ("mm: declare VMA flags by bit")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
---
 include/linux/mm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 96acf31268ac..394126bf637a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -443,7 +443,7 @@ enum {
 #define VM_NOHUGEPAGE	INIT_VM_FLAG(NOHUGEPAGE)
 #define VM_MERGEABLE	INIT_VM_FLAG(MERGEABLE)
 #define VM_STACK	INIT_VM_FLAG(STACK)
-#ifdef CONFIG_STACK_GROWS_UP
+#ifdef CONFIG_STACK_GROWSUP
 #define VM_STACK_EARLY	INIT_VM_FLAG(STACK_EARLY)
 #else
 #define VM_STACK_EARLY	VM_NONE
-- 
2.51.1


