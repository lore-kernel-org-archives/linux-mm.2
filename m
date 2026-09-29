Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 271D8C9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 05:34:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4752A6B00A2; Tue, 29 Sep 2026 01:34:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44C646B00A4; Tue, 29 Sep 2026 01:34:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33C276B00A5; Tue, 29 Sep 2026 01:34:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1B55E6B00A2
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:34:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BD12DA03E7
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:34:02 +0000 (UTC)
X-FDA: 85265683524.15.EE290A4
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id 889FE180006
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:34:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=biv6yt7Q;
	spf=pass (imf16.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790660041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aIKIMkYuFOTq61i+iCqWLdJrE5c2b5L+SL6VyhrzHK0=;
	b=a4ZCrW4tcT9LOUvrUAgt6DLzYNI6LfOiP2CEEDeL5xjqXGZ1zIkhmL2WWbYrVOru0bEDbE
	MqTwph4Er9a7cinL4i1UjcoazD3qbnF2m0T3ROzroWaWXJNj9FHzxctwt9CkncQckLF7EI
	s4QBvKk4idpJsz0xMvuvraBWRjTzCI4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790660041;
	b=aVCVRwCaThS1DPfA5YFJWNyPAaWg4VPxmxDMCLDbluhie6cO31loDzt/ekgmug1zREVpra
	GkguC54Lp5vB3vDSzU/FNaMOuaPuUtQnhjyOCjdNrhI5C9x4Yit78KW+ahjvS1FyosG4lA
	FyoldamuZfdBo6GQgFvmZUyzBGXBv8g=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=biv6yt7Q;
	spf=pass (imf16.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj2-f43.google.com with SMTP id d9443c01a7336-2d747ec6188so17567365ad.3
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 22:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790660039; x=1791264839; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aIKIMkYuFOTq61i+iCqWLdJrE5c2b5L+SL6VyhrzHK0=;
        b=biv6yt7QT+1b1r2yHHyCpa3zenqKvCXVVX/DKKD2Jfm72FV4P+yewBp7bLhBmwrS3F
         0oj/HU10ScyYqRTGC1z5IrFs7/9Lz4/N7hKneaQOUw8nsXXDqdImVcnMXQkPMxcf3KU9
         +vTh1uqYiCJCkWbCGHcG13Rx37k0XQUbNZTRadC3fcbGiXlevP84/8TkMCXPZMqzRBoU
         HpGyC8FGRxPpR8rB9rxaKGPqKLuQn9GioCUCTuUancjapHP/3jdYG6TfbRAXpNIcu85t
         QgmRVYL5qd/MF8Yj4aNwxkdP5v1ucAe8DVaOE1pBSaD8GWVDZdofxzqudJe7ArwgGGlB
         6XCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790660039; x=1791264839;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aIKIMkYuFOTq61i+iCqWLdJrE5c2b5L+SL6VyhrzHK0=;
        b=p53ao9r35ST1D4sgxppK50V4KZLU1kgtlyMM4OiY7DPxCNxUJAgigU7Oz2Cq2c6woO
         n1x595pBgqmGFvVCyuJRvd6lkRgJQT/x98JuuOLfy49NrVj9uuxuAGTYhNT91pMj4ghH
         DVBer6Wd+naVbtsho6bGITj3XIl2XoTmtSP8UKtbLEJM2nF+T5lzIjqJ47/zsGWka7ab
         Dnu7JfRdv4PdVzKXj0a/cMfZVq0IpK2e/I/wx/trFI3WS3CR0OGRc+/kDBDue6VG5h2W
         86WejWOvpeDsd+Rq2x5CUa7z27wZbjbo+WWrsStLKZowFkF6lnjfupW/C3Q07fZ/u72H
         bB8w==
X-Forwarded-Encrypted: i=1; AKwUvBwHkzklOU+WWJJwMcQZ5E7clssOUMuQPBESdLbq+J7kNQ2ORrBjUAqknusWfvrYl1DhaYh7NsZtNA==@kvack.org
X-Gm-Message-State: AFq9FYKIi4swd3CYQDAP3FPcrzqlHLAWKymOU7sKgPkGH0TcpoNXuCEg
	/8ZzvYMthydKJiLzcctFWDVZf8S8jCFJxYmEY3jgQtGnKJkjmRhg42Fp53Duj4wOjcY=
X-Gm-Gg: AYBFou2EuzFMrIHIwu3PiD9yrzb3eVQprEPcGzOwaKLEBzYBOjDclRRBDRhryjFk3l8
	gcf6p93ZvvqozfHvLRqcxyJgJzo9soCaXWZP8BRGx8GfMW6hx/cTX5rvA50IcKyM+Z4iF9b4yvi
	ZdbWtiA6upibGemo6ii9+y9IJeKQRr/fOFJB5Kq8jg7OkLkP9LFu1G58Z/VTZYXmywjWt37U1fL
	TbX5c9HoTfjQ4J7tbtBWYNcF5HpSag1mC1UUXp7aEGPP42R9yiM0rYf7xoXRxlcaDtaW+zUAKq9
	s+9EvTDrLjensuH3JC4fyBinw0vcXXTlB9tSEc8+QmC+LJzvetporsKtLv32a8PmMLmgXvLFAKa
	vyZklZFT0xDwpikkgvZTARrAqjPFe1jP0yj+KhXgQpzSF7JLtIR67vHLrCF6cbEDWNHOEzLb+Ko
	rc3YJk2vdU0EXsQpY78sIYaSdHDB0Tx11qwhDug3V4UZrT3Psz0TIgLL9JES1AWptGmtZSXkY6+
	qcvZEAwqoVaKJ8kc9vIkk1kiLj3Gw==
X-Received: by 2002:a17:902:f710:b0:2dd:3ddf:b87a with SMTP id d9443c01a7336-2e2c937e018mr7110035ad.0.1790660039331;
        Mon, 28 Sep 2026 22:33:59 -0700 (PDT)
Received: from G6L4RL2QG9 ([139.177.225.254])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df9142bafesm49251765ad.51.2026.09.28.22.33.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 28 Sep 2026 22:33:58 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH v3 6/6] mm/mm_init: add zone mismatch warning during page init
Date: Tue, 29 Sep 2026 13:32:31 +0800
Message-ID: <20260929053231.66085-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260929053231.66085-1-songmuchun@bytedance.com>
References: <20260929053231.66085-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: od9x1bn13y4iqccxmcu4499q77u7kpsq
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 889FE180006
X-HE-Tag: 1790660040-707084
X-HE-Meta: U2FsdGVkX19GRUZ4Fp7Vy3spXqbWJRosjCAfPKfoHxcKTwsA1WP2TMM7yYpqqZPiWnLeHSXQ2f7AhS5xQ5QQJOVSVQNiSbfnCvvsrJ6GO7QeYeWRnrTrnWMiLD4szqXaMIG92zUR+/q0t/RSf4/p1fFmS+8Lp+bMlHnY0JFgJ4hrT0fMtFX1xZhxOozdp48FJ3Ep7tAEqRs2Q1a4byz43se68YReXsyH5mA2gB/CVs0N/1ZkrBETCpYYGPfSWIdxIHh2I2nUjzlGm3G4ACnFtru+hABDtq9LB2JMltZZXhFY45ask1QDiDezjyVQu1SAa0Zn76Hy/EQpt3UAUyyNYPK6i+Mwj1E5xRKqqPi9b2lieeO2+6kdHAdt9fg+Y9lMlslizD2fLAXdFRSL7/hg2LPoEi0TokBSwOnrg1BhPjq2P/QiPNG8Nn0yL7r/G9uCu1ULYmQj7cE2yu594SAjyTqr/TKX6185ohVS13LXxZeDPMr+Y4xiQFQTecVRyzc66Pex/AQ6K498e4dtnJdF9yIRsgZqHjCfmIrXtGMFz1UdOkQ4QEBNbiU2laFzTiWoxxzE5TvP8huABqzmB10F1W1TGSXTE+/8CoQ5ux6NJZGtjA0w/PWmYnjy6QVwc/DxzE52C57WS6ZboF4xQXHhCLgxuAOMxaEC3lZYAett+RzdrK9vLaxv9qdHSa1TZRUFMcaXjpH6VXrM/1E5CFQu45DD6iTxmwmHsvS6Yw0rJKvxwelyFbC0X9REAdFLpkW7hF1UtWcrKHq+xAQqsjjaraH2HHXJHe5qzPp7pqlZwf3Q9lxqqBGkTFEUeooE8vB0lavCraII8DqgEctyy7NCPQtkyNAJIiZ+YssxveileeA+WYPuUMc25DH7IsIf8F+nyCWEQ7gT2YqTptLt5RxELdCOIv51Aqo3VDTp8v1bJ2289SY6p3D6y4Mswm82CM7f5hHocX1sSQh72Ehhfaj
 foJ/kHYQ
 30NGW+LietPkNsz13sk5PhMoSvG7m30giNyIG6d4Ak7aiPklL8JIIFnYYRrbsXkp6XIQ107aWv8eXHZDzbkLI9Ev1Mu02YLad//leJDzxg9PagkNBfqNEd2WsFIGY2HXjjS9vTWsbAe7usDXj+FeU5K96mAhRae6ZiUwAylA8Ya5Z2238ZYNQCLlX0U7pe24AJHoa3DUa259XuL9RuyvePoMrstcDEmZbSxFIJhHNyGoG8L8HPUpkkyySwY1DIOaXLs0qAQH7Wz6urTvSsxeOhbHWwJ+6ezCLDHZkwhyDpRqyCrJj/84RMz6q6acHGmhUjRFAP6CO06hczWAK7VnhqjC/ajBqWBOGXfHY9/x8vTfJQc3133WntepcVJAPqW3xefozCNVQpoLwuGZjiGp46Ll0Wgqs9pIjmwmfgyUjFGmFPnFEqKpkfCIunA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For vmemmap-optimized sections, tail struct pages may be backed by
shared vmemmap pages. Those shared pages must carry the same page zone
ID as the struct pages initialized for the section.

Warn in __init_single_page() if the shared tail page has a different
page_zone_id(), which would indicate inconsistent initialization.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v3:
- Collect Acked-by from Qi Zheng

v2:
- New patch.
---
 mm/mm_init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 1650d6bc1211..bd02e8d06965 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -609,6 +609,9 @@ void __meminit __init_single_page(struct page *page, unsigned long pfn,
 	if (!is_highmem_idx(zone))
 		set_page_address(page, __va(pfn << PAGE_SHIFT));
 #endif
+	VM_WARN_ON_ONCE(vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)) &&
+			page_zone_id(page + VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) !=
+			page_zone_id(page));
 }
 
 #ifdef CONFIG_NUMA
-- 
2.54.0


