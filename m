Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20A31C982CC
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 07:31:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6895F6B0092; Sat, 19 Sep 2026 03:31:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 612BB6B0093; Sat, 19 Sep 2026 03:31:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 465716B0095; Sat, 19 Sep 2026 03:31:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1856E6B0092
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 03:31:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 91C4F401D2
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:31:49 +0000 (UTC)
X-FDA: 85229692338.30.6F50218
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf27.hostedemail.com (Postfix) with ESMTP id C354740002
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:31:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N3svGeyS;
	spf=pass (imf27.hostedemail.com: domain of aa9736195201@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789803107;
	b=AJ0s8PxADuzNj1axkEZHFUUhaK4YeJ1elecKnUiupmrwYGqnw9KBPBP8RdL+tl1d3x8LAh
	cdc0OJehkg6r7RAwI35v/e1Ziqz1iZqhMIMGQ8pQPf+lGH92ucmly4yta14f30UJeC2LA/
	NoYSpM2VnUYERMaUN2H/dRqJUr9TPY4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N3svGeyS;
	spf=pass (imf27.hostedemail.com: domain of aa9736195201@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789803107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/n7V6rVhzACsIJzJlTeUTwF6umMgMDmbC0nfLvGCwoM=;
	b=6S6hWPJBNOmrwwOX0/+G4T0t8TFNj4ppDUh15OLb2r14XrtaTLWYATr5qHU3cbwVvFVK9l
	atzkgDwHVSHIhLX82V+UoG+bOr1C4l5joJ+n/A4rvyJ6qe4CykEfjztye6CQqR8+AW3/Kj
	IMEgTW0qFrC+KnjITg+eLN3a369VlpY=
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85469a33c9cso2022243b3a.0
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789803106; x=1790407906; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/n7V6rVhzACsIJzJlTeUTwF6umMgMDmbC0nfLvGCwoM=;
        b=N3svGeySXFAJj0J5t7W8FzTFg7vtEWcPtIVT3v4hfobjbkcPGr/l1ns4YNp/9tuOfg
         NFOzQpCB6lI1brPDPyzAeqE4ZoiH0auC1BCpEeiBSyRIQoGWRhqVOo7AlCVsm8EHcne6
         kiphgeyf7I9++swF6m2AXSRb1nKOM9QId9unyz9OkLFsOTgc95KWzsDCSWH5SHGBr9Bn
         4z8XkHj50Vv4pf/HmtiqrOc3ZK3xfF1Q6F5XdZCIpRg8OlHh9TNwAnU4eixVsLQNSngf
         zy8g/IJ00rVMUImN3h3kg/l0O/ZdCc8OH3QZIyGZOBzuaOWmd7A5b5pgTsAH7GDgVxrO
         H3Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789803106; x=1790407906;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/n7V6rVhzACsIJzJlTeUTwF6umMgMDmbC0nfLvGCwoM=;
        b=V1XdD7PmZi1onawZvkFJ92fZD4fIt2L5tBtbBHBR3Ps1YwC0y9uDwwn2awcAzAvd8d
         B6n8x2d7aex5tHgFZYDhgkq4aCRVyd/XzllsQoaakZjtNIISjSzCMm/oclvHzj0EHYF2
         ropx4nC5+yOkUbLhJf9PMFr9voXIUXT999IaHMzFpogEcrUvL5JUaFQKMitbex9c+iuj
         bEvJphZldz4XzJECpGDGXQeCBi7JNgJHgLRqiwIlqQUsZ7/WC0TvCl/MNkHbJx3z6St5
         1Bj1+f+nOYSAUcKtwKbQIOL7NDT6dI6PNja+9IJ6TYNzRQItJlmsq0iAoQXPx/sOg8YJ
         oygQ==
X-Forwarded-Encrypted: i=1; AKwUvBzdXty83NDb0NDng8SEkyDKxVlCL6iCVhimINfz8t7yPwF77RAWz/36tQZGojGC/pn/PSbdpIh4fA==@kvack.org
X-Gm-Message-State: AFuF++lAesIeckyVD8QraTk1Ksy2i+HQlTV1+99FQaPugVhJQlDzgmWC
	OHtRz/BKwqSp/jNaYNp6qcfax4Z5aTiY9/viriNeICYWDeBsW7LdHA/j
X-Gm-Gg: AYBFou0KeYQisqz8lf7tf9C6BLwzXzLGYHyO3OdDnYWq+5BzknBEF0T4dCNCzF92Tzf
	azvYbIRR3tXMSeJivpr1tSbusOXz1v5wFq3pUDrdReb3ZTrbHjWUlSRHYwGRCTvshyVMcP+4sXL
	07JPjAItYmnm+Iv/FG2Vdf8VPzrZOes33D0eQV8D1Vo3FRGpJdhKE8SsjTwbzYR0euFYyaB2wYW
	S5X1xH7bLzbY72g8QGTKpk3KksNf3wcwjgK1RItorp8TYJGfeqGe82CNRuhf8yXZ4+O8mxd3ggX
	68thUw8jh9BssIbG6NhVI0ndfdmnHFTO3a91FJntJunxgAC/344QJl75HVfr92XZ/oOfLJzk2Gv
	XONHxt9KqR6+3Mh4lMaBKr7sIm9IrsY7kPMlVcrqOdnN8cqk8YOrV5CMN9KVl4LFhTc/mXwvsCD
	3hktT0MI41GQh0HmFsPT7idJ8sEC7z0rg1A00vvK0HypCMiZvfay2AKWSiAFbGiR72oH0blsfPi
	aZNumCgWPgym08SkSTtqmfv/g7029RjnzI1dA/SVuzg3J0lnsh8tmctyvzVxyY0f1Xi8tR0qUFz
	6H2JaefXNyP+Lu8X/tdBkmbMQA==
X-Received: by 2002:a05:6a20:4386:b0:3da:f969:b077 with SMTP id adf61e73a8af0-3dd8c425bdbmr10860733637.11.1789803106328;
        Sat, 19 Sep 2026 00:31:46 -0700 (PDT)
Received: from DESKTOP-TJS95SS.tail460ce2.ts.net (36-232-198-121.dynamic-ip.hinet.net. [36.232.198.121])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc72ae9e9c8sm654498a12.17.2026.09.19.00.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 00:31:45 -0700 (PDT)
From: Yuan-Hao Hsu <aa9736195201@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	liam@infradead.org,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Barry Song <baohua@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] mm/memory: reuse the whole exclusive large folio on a write fault
Date: Sat, 19 Sep 2026 15:31:33 +0800
Message-ID: <20260919073134.639-3-aa9736195201@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260919073134.639-1-aa9736195201@gmail.com>
References: <20260918064238.868-1-aa9736195201@gmail.com>
 <20260919073134.639-1-aa9736195201@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C354740002
X-Stat-Signature: c6x5j1wprpcpru86663ttgyx5jmamd6k
X-Rspam-User: 
X-HE-Tag: 1789803107-584186
X-HE-Meta: U2FsdGVkX1+Dwky1eiWBQgyfvj1xrfkkKDzXMTXq/u0JxRI/CGGmuzWouoFQBYy5VKqFBBaI2zIm7B5jCRRsZe9NvzfP6A+cXjNGAhZQqdSaooogMIt+bTy9uRVnH0JoBXywVzM9Wn5LjdZd4Y1DgmoUziC+Zts2C7a4n0eB93/ea7g2URZejuqz/uQJ73kRpdZzPQx6E1Zfk5cdKS1qm5Igc9dmxXV7QuZs2CvualXXOioXt/ImwU/i2l88Gu6tUVIjbWlauEEiw8RF3nTZO6dkXERrqUe3YVVx6fdXU8rpqYm9bxwwkQGa2Vek29tdqN/FuxGHBqHRCyj0JMSEV33qXhO0vFgBgzj5IxWY2vLKbiuMpZkG82H6WCbZAEUC8MJ3GDfi3STDa1rsxgk6ZunKKWCAObThGXBcgaWO7boNIKsKjuSfHodPA5xqyun4dIBQ2SsY1z1aJyWM+sNYB7UqDk3fLuouZMfjllu66csI0JkWam2OHPcMawe/hIHEZFJvS8tK1pxAxmYrQc4Seds7JPb+bsoR6F8WRJ4OCOB2ujF0dfuX/dvfv6NQ5H6a1zSbymgsqi0Tf/qKR9s6IRFmkYuS0KtcQXo1fFgmSKYtOLpIlYEedJQcWpv2l8aB+q8ACvrjKYsIYmbLub+SolKHX7eReUw2uQFJM44ziRM9xn8UFaBopBLMOEAPbxYWsntcl/tPGYeI046HWGtur2ryemH+nH7gVgnFuoG36F/Yhf56Z2HcOXATpcBQicX+XnQBY7QD6n39+4XnBHThqDKfmkYNMiPNmQer4H/Y9JRuozgds8HwzIMDD6CrypwPcyHOqSK9Jx7olJDRnJvRK31LZhp5OGnYL0L4RRhj76x57Zb5u7hDdDt1EtdgsLUo2lql2pBmywNJOK18ZJU5ObaVQ/Yy24oOgfCN8WvdyoYhnBdPzziDhWOO/FKYHsobf5XOFusg2om5Q2Gu85C
 5BGiwhgN
 wNZskB8qZdGKm2J5+LxXTctpmx1bM3d073LAK3yB0melLuCQyJOl9rUkqNL7AGQ4JccnrxHj4Zf0iEm2qRIzbvyxRyawzA+iMOskNdGpMw/E0gjcuBI03Ipeq++F3qxMOZzhnm+5G6+vpo1rO2XOkXZVwdAxMvfFU80DrdhpL9OrnBdasPrfTjViWRmVA7UJYFB4ib4P/PrMKAaX+VWrbyJGF1cjiRQQmdwpduRpdNb9PeeprqufSGq+vQkNd4Dd8dD7Q602fPrS+eYAQP2n8plNnw+uqpAMNFUcIyEIzhXCE4u0dCo5p4/2LTsDLlxVrD+9K5uLgJp1ODtos6oxfJHZVmgRej/dcD+BNSYrv+0wg1C2zpc3KTvWP7alJsQnDzXYQj6hZBRVPw4on7UYBzRntT3k6PteB+FSb4wypE0oDPTbQZT1xsAdtqXFP9lh0rFFPS194PkO6wHA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With blocks of 16 PTEs a PTE-mapped 2M THP still takes 32 reuse faults
and a 1M folio 16.  Lift the bound to the page table: the walk then
covers the PTEs that map the folio in this page table, at most
PTRS_PER_PTE of them, and one fault does the work for the folio.

Its cost, measured as the time of the store that takes it, against
420 ns for a reuse fault today (x86-64, i7-12700KF, medians, ns):

                          reuse fault   fault that     COW fault that
                          (patched)     allocated it   copies 4K
      1M mTHP            5,400- 5,700   63,000-68,000          1,500
      2M THP, PTE-mapped  10,000-10,500         126,000          1,500

That is 14-20 ns per PTE, about 2 ns of it the scan.  Builds that
differ only by NOPs in front of the function take either 10,100 or
7,500 ns for the 2M folio, with a period of 32 bytes: the loop of
modify_prot_commit_ptes() changes speed with its address.

What it buys, 256 MiB after fork() and the child's exit, medians of 15
runs, two boots of each kernel:

                                   16 PTEs         whole folio
  one byte per page, seq
      1M mTHP                     5.7 /  5.8 ms    4.1 /  4.0 ms
      2M THP, PTE-mapped          5.7 /  5.8 ms    3.9 /  3.9 ms
  one byte per page, random order
      2M THP, PTE-mapped          7.4 /  7.5 ms    4.9 /  5.1 ms
  memset()
      2M THP, PTE-mapped         40.2 / 39.4 ms   38.1 / 37.2 ms
  8 threads, random order
      2M THP, PTE-mapped          0.9 /  1.0 ms    0.7 /  0.7 ms
  one store per 64K, 2M folios    3.3 /  3.3 ms    1.5 /  1.6 ms
  one store per 2M, 2M folios     0.1 /  0.1 ms    1.4 /  1.4 ms

The last row is the pattern where the whole-folio fault is pure cost:
511 pages made writable that nobody writes, 1.3 ms more per 256 MiB,
paid once per fork().  Anything that stores to more than one page per
64K comes out ahead.

Link: https://lore.kernel.org/all/36933711-ae0f-468c-93bd-d6a67d974c9d@redhat.com/
Assisted-by: LLM sparse
Signed-off-by: Yuan-Hao Hsu <aa9736195201@gmail.com>
---
 mm/memory.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 73e5691b3ed8..85c883d1e558 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4355,19 +4355,12 @@ static bool wp_can_reuse_anon_folio(struct folio *folio,
 	return true;
 }
 
-/*
- * The pages of the folio around the one that faulted are handled in aligned
- * blocks of this many PTEs: a 64K folio with 4K pages, and the size of a
- * contpte block on arm64.
- */
-#define WP_REUSE_NR_PTES	16
-
 /*
  * wp_can_reuse_anon_folio() found a large folio to be exclusive to this MM.
  * That holds for all of its pages and not only for the one that faulted: mark
- * the ones in the same block exclusive as well and map them writable, like
- * mprotect() would. Each of them would otherwise take a write fault of its own
- * that repeats the check on the very same folio.
+ * the ones that this page table maps exclusive as well and map them writable,
+ * like mprotect() would. Each of them would otherwise take a write fault of
+ * its own that repeats the check on the very same folio.
  *
  * The PTE that faulted is among them; wp_page_reuse() completes it.
  */
@@ -4378,17 +4371,17 @@ static void wp_reuse_large_anon_folio(struct vm_fault *vmf,
 	const unsigned long idx = folio_page_idx(folio, vmf->page);
 	struct vm_area_struct *vma = vmf->vma;
 	unsigned long addr = vmf->address;
-	unsigned long block = ALIGN_DOWN(addr, WP_REUSE_NR_PTES * PAGE_SIZE);
+	unsigned long pt_start = ALIGN_DOWN(addr, PMD_SIZE);
 	unsigned long nr_before, nr_after, end;
 	struct page *page;
 	unsigned int nr, i;
 	pte_t *ptep, pte;
 
-	/* Stay within the folio, the VMA and the block. */
-	nr_before = min3(idx, (addr - block) >> PAGE_SHIFT,
+	/* Stay within the folio, the VMA and the page table. */
+	nr_before = min3(idx, (addr - pt_start) >> PAGE_SHIFT,
 			 (addr - vma->vm_start) >> PAGE_SHIFT);
 	nr_after = min3(folio_nr_pages(folio) - idx,
-			(block + WP_REUSE_NR_PTES * PAGE_SIZE - addr) >> PAGE_SHIFT,
+			(pt_start + PMD_SIZE - addr) >> PAGE_SHIFT,
 			(vma->vm_end - addr) >> PAGE_SHIFT);
 	end = addr + (nr_after << PAGE_SHIFT);
 	addr -= nr_before << PAGE_SHIFT;
-- 
2.43.0


