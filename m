Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1521ACA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 18:32:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F8DB6B0029; Fri, 29 Aug 2025 14:32:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CF8A6B002B; Fri, 29 Aug 2025 14:32:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BEB76B002C; Fri, 29 Aug 2025 14:32:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0D0046B0029
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 14:32:17 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CA64F1185A7
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:32:16 +0000 (UTC)
X-FDA: 83830639872.12.5BAFE90
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf18.hostedemail.com (Postfix) with ESMTP id D8D9A1C0007
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:32:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=f9QU9bS9;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf18.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756492334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4PHAh511rPGE+8F3ucAdvrwVlVrQ6G4xQcacWJ3jlqI=;
	b=OAr3YqL083jacRBfPPohJ9oJpKF4BCy1Aaz4i++zxg/DSpb45PU9RbEG9RTaPE/2seVRge
	3SRbOg9iGRdCihL9rEhDQWNxeU3AKswDhCV6g7/AM3c6JHtbnpeudXsa3KuRoihPK/7zKm
	h0QQFYaIrQyz0fOopej/iYdA9prz7G8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=f9QU9bS9;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf18.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756492335; a=rsa-sha256;
	cv=none;
	b=woUSQVWFm+eG8TBFe9fuD7Gy/yCq8VVWc8ZiiYaEEgovwSmc9+oY56KbO9pPQABzCEl5cU
	Wt9VbPmE02N/XdImcXve4hmrIJyf+9QjvLq7tI66pm+Da1gFxpZH7EBT3LJA27yf4TeQAW
	nv+OXT8hw67x32YiNPHUhhMi7BiXDKU=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-afcb7a3b3a9so373552566b.2
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756492333; x=1757097133; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4PHAh511rPGE+8F3ucAdvrwVlVrQ6G4xQcacWJ3jlqI=;
        b=f9QU9bS9+r8+sIESDXCofH6d0vSGhHmjWdaU2m+kvZ5Q+MFrfR6U8pQ1Wirk0FeV4i
         ROcjoXZOfHISq0wJpVtq8HTGMg99jTOmraKhOlr/ZN13a549233e8tw3TWXavDeumE2v
         XhErIrwmdNE20uzwHmyRsPFxbqcoi5xhtBPcEZvyPUu236bkCctzvLeL1qEKyUodIg8t
         NDn+dReF6P1kdjEe8zIGPXZaYjnz8KSxPjs2hGCSuZPb0WhnEpkEW4dBGhh2hzlgPcIq
         21ZHNSJ92User3Y/mx+rWFwL94uc40H4Es0/cFa6qmowVC2peDJXm4VQ9D9843tnLikD
         Metw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756492333; x=1757097133;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4PHAh511rPGE+8F3ucAdvrwVlVrQ6G4xQcacWJ3jlqI=;
        b=s37SToSC78CisQSqZjY0nlop7Jg76i6TrgkPforwSYJffWQyVCeiY/tr3mZf6J8iFB
         ajkUMbk0I6/EMOCPvFsE6mZfvtMlMJXd+ZaxfLt3abDTvlkLyCImAoqEMHtLyXAbDSle
         WapNJ6FQyB7p7ZKN8D3xiMO/MzvAZTvUOG8fOQIM+e8YepecJs6hGu/P65/TxpgBUzCc
         lb8t0Fo/LwaTUxPvM5ZWxlmBMbTXhtvKjVF1EmRxp1Ji4fJSN/WDFJgvevpWedEHONF+
         ba4G1QS3YU3OMAxiKxHlePdYp4wliTk0Zk6aCkPCgebZahSIkMA3i1p4Q/rKVUpHpbML
         YWMA==
X-Forwarded-Encrypted: i=1; AJvYcCUc3WrrvBi408Di9Cx6z/iv8LLC9OrOoLpEBdhEmWmoJJ4mU9pWL4b0E/AnfXrbJBwJ2hW/3fM5EA==@kvack.org
X-Gm-Message-State: AOJu0YysX+ao4tg7d25Mild1dHSC+hWBzWt2YlTjDLh5jDYemMgQzVhp
	IZGniGK5b6VOEYs/65OJTS7zODqbpwLfDGjz7nJoujAmJQbOt60AshOwLIx9gzRf5uI=
X-Gm-Gg: ASbGncu1/y9FTehXCD28AJVLkUco4HpJqpwRvXv0KuZGO72MJms3VDILUvV5JQBE6KU
	PsE498iwaEv6El96m021hj3z5pCWKHcavYTfRcyv2pLEZDVaxbrtGt8hBoQhB57A5RUMFHn18uh
	qmoxv5x13VBiZRQ100jr1i6vmuel5/4WT2HXY0Fw1/yOosHpEIobFkDnXKuFGV8az+F98k57Lo0
	FXZen/xp44v5RW/nwIFjBci3LA87rlrUyxINhgTQ+YyWMYJDFlORBLAnWJNRz9IAUCbXjw6UcUq
	7sQzrrj8jf0Pg5M4ChtjwaJEpmmBUc+d88JuM9G2NgwQBuc8jnlIbIxOODTvQG/bIpcr3bSA0Qj
	nnp7Lr7G0JYuxAxLcphWZBhIa3bOCv/01oDB6O+lnnlOUhaPwDW6ZAAjFQR1Luw7TXpNC8ncv0P
	Y99iLE3cO43umztoL6o+52Hg==
X-Google-Smtp-Source: AGHT+IHpRiCf3ba1lpqbF53lceFqttZcUMtU+GGQbLjq1PiES95G84yXDwAe7MA7Rac08dyDihP+Vg==
X-Received: by 2002:a17:906:9fcb:b0:afe:b2be:6109 with SMTP id a640c23a62f3a-afeb2be6285mr1262333366b.59.1756492333347;
        Fri, 29 Aug 2025 11:32:13 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefc7f1174sm257964466b.9.2025.08.29.11.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 11:32:12 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 07/12] parisc/sys_parisc.c: add `const` to mmap_upper_limit() parameter
Date: Fri, 29 Aug 2025 20:31:54 +0200
Message-ID: <20250829183159.2223948-8-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250829183159.2223948-1-max.kellermann@ionos.com>
References: <20250829183159.2223948-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D8D9A1C0007
X-Stat-Signature: 4zotb1di3wgpt3ifenod4zdjjqjxo6xz
X-Rspam-User: 
X-HE-Tag: 1756492334-242833
X-HE-Meta: U2FsdGVkX19JRpE8+yPUVwWZ3NsGo3w0mFJdV8Fmci4nYs6RfGha3CLLkecwl4QvYZCStu1sY9ssvJoaW+1CHrrmf3lXlNWFIOJXYfTxwNWQNPMFSeO17wLBTEKbPEijuEgP7QPATbAME3AYTvXrQgWfIWiFEKNReR9CHn7eEEU3lM6Hx1qGQ7AHX8A9uG6gq/hFNgzleoQFiap80ItIGzXr6hJoJdRdRFZNKiUuFqR4W8tU1z1xvYC0v353SIPc5LuB2TzEivd0sOxlkqwLWy1X8YRehr0QXXmtsL1TGc2L0xewTd+Ebn+tY92TwKlB2AEGsk6j+ogXNU1U6wK2MRe8FwsmjX3+8r5GBd3Duy+veZG9p7tBIGjrTXZOZyHCWckUy9qbnvYkyotXNl34e/iPR1QQFT4UFZ2hLSJKdQovCdxruwTKrAJuqgWgQdqL6efB/ef4NI7pzF9qIfeaQRRfvZW/ktLYCtyZLIHg0zoh2p5lXrbSp5pInIba7TDTA3a0Dk7uUYLL2Hl4MqQPAcLVhp5D6OMXOYAGY4zMqCrJkiuSpu2p2YOeI+0GUnePVSOwGiPZ3bILKwlVzttSBwOPpjjCPaN6P7LTxk4knF0pfVrVKzcV1cJGg55/LMW8vuT1cQSAeZ4LR2yxuLHBy4V3O+7/SI3fPrdnkItkO4v+SYaX7SBCG0q43LTn4OUcTkdPlzO2V1sVGDVa1aUQFiThqM4/uEL27ou4dbSEuwJ1rIGKVXClybrZ65vbuxDa7BzoKJUAhN9Qd+RZpbLmlvZXSTVBpfs3J8SlvV0VjGUy4dR0EsZzwNyzhOEIJmbtCLg3T0pdAaMdbodjapwwfzHkiSUvbJRXZyMCFaNkDXL7LyuHgLReFTMlYT03f806mJF5UznL6EgrG+Se/6q1Jkwl6+tJbj62Gvkty/2KRroD851dvsnuNqWvmg4eciKuJPWqdd0HvjrOIWXP1lP
 CHURMrtq
 xWxLiJ7fD2mpNknWTMKcMDfYltxN0+OTO2oOGLxzFipgRMlWojQTExt35zusi/11v3Axj4lrhjHPcGptBB7Z0ctNAXv9D3LIaRLuTxFTCsZFNIyHmqYDSgOASrgHwwkDZeMyZMk69VJ+5RBP2Rx8MStdJQHfhgczqsc1i8ICrZfqEbaY+JBdxfEUthzCVLUr7EEVUTcA+Ne+Q86pMcoVMCsAThcwTm1Wj6TyMrLrLq30azYqBfB+yNWgmWpQYpIT9WMtcIfoLVavJ7wXyaaKzDqBEwz6LguKsjEGUp+xxKfqpMxxxohPm+rKjmGwFcWaqAAKwn2HNJOTJr8HMilYRAl/ip49qTblJY7atjl0paG0DItulQfPO7EzXgPxi1Kv/kbsv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.  This piece is necessary to make the
`rlim_stack` parameter to mmap_base() const.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 arch/parisc/include/asm/processor.h | 2 +-
 arch/parisc/kernel/sys_parisc.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/include/asm/processor.h b/arch/parisc/include/asm/processor.h
index 4c14bde39aac..dd0b5e199559 100644
--- a/arch/parisc/include/asm/processor.h
+++ b/arch/parisc/include/asm/processor.h
@@ -48,7 +48,7 @@
 #ifndef __ASSEMBLER__
 
 struct rlimit;
-unsigned long mmap_upper_limit(struct rlimit *rlim_stack);
+unsigned long mmap_upper_limit(const struct rlimit *rlim_stack);
 unsigned long calc_max_stack_size(unsigned long stack_max);
 
 /*
diff --git a/arch/parisc/kernel/sys_parisc.c b/arch/parisc/kernel/sys_parisc.c
index f852fe274abe..b2cdbb8a12b1 100644
--- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -77,7 +77,7 @@ unsigned long calc_max_stack_size(unsigned long stack_max)
  * indicating that "current" should be used instead of a passed-in
  * value from the exec bprm as done with arch_pick_mmap_layout().
  */
-unsigned long mmap_upper_limit(struct rlimit *rlim_stack)
+unsigned long mmap_upper_limit(const struct rlimit *rlim_stack)
 {
 	unsigned long stack_base;
 
-- 
2.47.2


