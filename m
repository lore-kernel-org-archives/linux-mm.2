Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0E35FED9EB
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 16:57:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 358FA6B008A; Tue, 17 Mar 2026 12:57:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E2BB6B008C; Tue, 17 Mar 2026 12:57:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D1636B0092; Tue, 17 Mar 2026 12:57:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0DA286B008A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:57:12 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BF38B1402CE
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:57:11 +0000 (UTC)
X-FDA: 84556160262.10.71B8325
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2706C100003
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:57:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QHskvkxx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773766630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I4OWRqmoUDp5UCqoQGC6TtFxCzZ5lzB9MnreT6p82/Q=;
	b=RWpemoj+bbWK81Ilx+KOqSywwlEP1wrDIrleStr1uqO7OhgokHwq8btzaXV+ycZeHVyFBn
	HDEn45TNz2qMxHvtX+lh8tUmX9p+oItnwJli9RRclmnOQ9STuiIYiF2kkaK+YkICXBTgfe
	uCcOsGBPwftYmu43o5t6gJXanZFrQJU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773766630; a=rsa-sha256;
	cv=none;
	b=abd4LqsI5ML4wE1C8ETtzfBPe80t8cBJo3HmjC7yiiTZcFjfjihAbrcos4Q+8aHtylxfwY
	TezPvQ/FLQc1Oejf/UxRem6Nq9fnq3Al0chZXWyBPIF7De0Ev27hsgY9jpmNHHdxEagvcD
	V00Iyp48j5ncfHg+3uzBlDe6ZmCN3dk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QHskvkxx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4624F406F6;
	Tue, 17 Mar 2026 16:57:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62C5C2BCAF;
	Tue, 17 Mar 2026 16:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773766629;
	bh=kzrTKM3vlrjilIM3sQvWnlvy3VBosxv9H7E3QmkzRlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QHskvkxx07TedlGeSfCg3qWrbY+3uik23yxdt4OBz7Ty8WtpRTbVRWFH27KQzM7ih
	 DMHCC6mbfKZd5XFSR4idzYoIP8JoBJXzxxedXgJ1qEdJo62bf9cMlJirqoQ35/wGrk
	 k928oEnRTJNB1+nuXT0TnCr036BPdr782+F1/qr5oU3luAsNCEI4oy7y9gVY+ddcv/
	 aguPC8Ef0KfVcO0aD/qWl0X6tfm45jxxrCfboq0PgYA/OdDH9+M1tgRCvlLpH3G3pF
	 Vo5vhQmp/XBajQRU26TkQBt1sGRmzjjQtpQGDg8Bm6/IRpRQJUX0gESRAuFhynz+x1
	 3xzcWj1mRkogQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH 02/14] mm/sparse: remove WARN_ONs from (online|offline)_mem_sections()
Date: Tue, 17 Mar 2026 17:56:40 +0100
Message-ID: <20260317165652.99114-3-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260317165652.99114-1-david@kernel.org>
References: <20260317165652.99114-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2706C100003
X-Stat-Signature: k6p49b5n9cq4d8bktxir79ijwyfzgfd3
X-Rspam-User: 
X-HE-Tag: 1773766629-409605
X-HE-Meta: U2FsdGVkX1+aYX/Ut85e1rI1GTcL81lqzD0PpoVBPLm+xclQk6KwpgVQO981Z/hW6GUl918Fk+k6iu/Q9iu22eXHyH4QZRah357QnvvJsd5JMupqVo7tO74joqLib3Gg6Rzy8gj4ipFKWC3Mpjg8XnWRZfv2QJAztKaHAPajlZjAyV7XBxbeDFKrbor6Rj/egWW7YBIE+1fzUgEU5cjBRqbYM9fYLIR0lFCsdHh6b6GlgglJ0tqSZ73C1hNoRBo/pMVWrn/YM5Sglw23tJvkSClPd9l9n5pwwoIoBIT+QaFwI9Nt0y4xJNSfkTe162IYmk3STLiokPHZaCWAvVrbaXIXwhgtNODdbOwnltyyZyuIbb0VTq1artbHExVgUTMEotpe5H/ggh6eUmbKzKViJ164XxTB3Kc4+gXr3mHQGKlRP+qV00wbPskmhdQ47xHUcxZe3fgzYPlB7a3ELBv0RihpgLcuyrX2vZFXY/K8cWCxACQiiIvJHozn3qGI3FS9GI4/F6exkditx8IqfOeyNrsTZ/UoZA2cvoPWbxXgEqQ7W8t/8AxF/Bof1ZruFKJWlXs3d097SZVcKWnj+jYLiByBMIDOZj7ERvCIGah3v8nki0UJvCYaGkpt7zRf1VVnVS3WPHG53gKsO2LdPVWhiDEkd8zMm6Q81C0aXu7cA5GT3kz7n87LAZkEH+L23kbaQc/Og0/wEQeg1IUurZLfbUaGYX70z/GTnZVmEQAhqtyOMl9rQ12NsTH0JKlkyCp3DETtz60Br5Zruy10JnjVjKC2TDFHwarj78RuTtaE7kJ8tt3Q1CAnS3xxQDcaJuxrtvMmlSr5EjNFFDib/Hqn+4Ewt7Z82AeMtV1NOc4MO6ft+9XR867dpol3GG+ywT+v4SW7tGk5d4UAOL+1fzUYwWbd+eQMqcjB4SayR/3qkxLeHGuxvP0V1EIyJN0L2C06YGxoltNkN/42n/9pNvb
 9xI1vf+E
 R0jMbV7d741NQ1nRb7yCTxgz28YqQLnzOBpbFuuP2xyzvCHBzzLLeO4Qs2KLp71xbQQCq8nNkW5SpIGffOct12KFjNr/ic6M2r2RNJiL9iYBDdiSZrComDgTspXBmEGS1UM76vN9367+gu2qo/EdcRq/opAiZ3j6/DPf/8X7sWLVakvTIZGwPrmJHyVbztUMyiKeCSvK/OWV1/Uyad8KPmM3OxdTLP2xpwIXncW/Mq8Q9njZ+m+Libq1HMu0ZnQVPZdqqk5bHV6ivMODXjsE9XYTA5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We do not allow offlining of memory with memory holes, and always
hotplug memory without holes.

Consequently, we cannot end up onlining or offlining memory sections that
have holes (including invalid sections). That's also why these
WARN_ONs never fired.

Let's remove the WARN_ONs along with the TODO regarding double-checking.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/sparse.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index dfabe554adf8..93252112860e 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -638,13 +638,8 @@ void online_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
 		unsigned long section_nr = pfn_to_section_nr(pfn);
-		struct mem_section *ms;
-
-		/* onlining code should never touch invalid ranges */
-		if (WARN_ON(!valid_section_nr(section_nr)))
-			continue;
+		struct mem_section *ms = __nr_to_section(section_nr);
 
-		ms = __nr_to_section(section_nr);
 		ms->section_mem_map |= SECTION_IS_ONLINE;
 	}
 }
@@ -656,16 +651,8 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
 		unsigned long section_nr = pfn_to_section_nr(pfn);
-		struct mem_section *ms;
+		struct mem_section *ms = __nr_to_section(section_nr);
 
-		/*
-		 * TODO this needs some double checking. Offlining code makes
-		 * sure to check pfn_valid but those checks might be just bogus
-		 */
-		if (WARN_ON(!valid_section_nr(section_nr)))
-			continue;
-
-		ms = __nr_to_section(section_nr);
 		ms->section_mem_map &= ~SECTION_IS_ONLINE;
 	}
 }
-- 
2.43.0


