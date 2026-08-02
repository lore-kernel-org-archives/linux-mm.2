Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D39FC55174
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 19:54:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 052CC6B00A3; Sun,  2 Aug 2026 15:53:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 003FD6B00A4; Sun,  2 Aug 2026 15:53:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC0236B00A5; Sun,  2 Aug 2026 15:53:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B1DD36B00A3
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 15:53:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3E06C160540
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 19:53:30 +0000 (UTC)
X-FDA: 85057378980.30.6384C80
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4CC891C0002
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 19:53:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=Pwt1XfR9;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="I IyIrBG";
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785700408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a2Jw/mn+UfsKcDTO+dGnQEf7SQYHheMbTSYp9dOdyHA=;
	b=o8UUpXXn0PDKHd81ar6JrYY6Tnjx9kKIDh4o8PlWbxDDWLTOv0ynVnDFIkcdZF/OD5qbOe
	STpcXZzMfd4zvGKEOVXF1oZClSj4x6rAO1gmzyBaXmXD7uDMXwiuyygwqWNSvjOMea1zYE
	uzkZ6qNtv+1F1NIpWAa7syIj/BBVDDY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=Pwt1XfR9;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="I IyIrBG";
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785700408;
	b=EWav0scVBdRMvSeRaGFcXDQ0Cjsog1TFCkgrxg5Yqe6aA7CqR1Ct+qClUApZ1ff7Fn+WJ5
	HHuEyZcEMNu4NXsfx+kumJB0qVLfxSNHTbgpPJBe5k/9suwa8w0KVNo4B7pneLLrsYd5uT
	onGytE6W5qSrZkgMkWfuEhRWr8SyR70=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id DEB671400051;
	Sun,  2 Aug 2026 15:53:27 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Sun, 02 Aug 2026 15:53:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm1;
	 t=1785700407; x=1785786807; bh=a2Jw/mn+UfsKcDTO+dGnQEf7SQYHheMb
	TSYp9dOdyHA=; b=Pwt1XfR927N4rs7e9ppzMF0mFPF2QC616AAkWDcjo0sXt7if
	eKQZhjKtcPkPgiG69y9DcADkO3G9/XQR9R0VP8+asAV7NASoH0mtJAGWcYfP/R7n
	beOQc+1Uy0063uWVRWqSTgCitYzQoY691uQoLlFHvzDqdJebW2aJ2ei7Rhi4N17u
	dUTEEZrdOZWz0yPW/zO5UbSTvYVcupLCZwbOzq89jz0j9K/YkuNRbBznkqOQMCX+
	a5X3pZFlalVUcbRyvQyyZlELIgg/3K/iKVqqlPQExqItOY+z9Quyp4xKXcCGZpF5
	1WTQPY55OflfiMKGeBbxo2SPj9tak+qmqmBGng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1785700407; x=
	1785786807; bh=a2Jw/mn+UfsKcDTO+dGnQEf7SQYHheMbTSYp9dOdyHA=; b=I
	IyIrBG7CPap1NwdJClTpvaxTmQKXxZxFUysfUkBFxrKXhz4QmgmhuW+Puo7b9rO9
	tFfZPSK9DNXc01kkdI6h9ls1YkcxSj4tAc03YPqci8BQ5egrHIz4xXh7+2cJcREj
	wrrnL3ztiRGSHasUvo3gU1qVykspwb41YIICfxEmTsiXhGpvqIQzQeujIHc6MbC2
	Ya2HFFs/TO8omJqOLZCZK7+FS+5SFL/oGQAE/5ZbMLjaP6CinPl18Sb5aCGZpT3K
	Ke4Si89gt3rsvUTV0l7Ci63mKZ9CmIxfjSi37r3EVVPxYIlnTyWsMtCl4bFbj/f0
	EJ2Q5u48bSdHI680JjfXg==
X-ME-Sender: <xms:N6BvahUhGeuYZ0711oAZ_Gzhs-uUg478G-UNtU64eAXrkg60Uam7cg>
    <xme:N6BvasGbgw0X2LSS5tz1m5FXeNKL8sTvvCU0H0rh4vimvQ663BUpcxLqIJMbLS-Y0
    6iLVwOjjnKZuldgaAncga8g-vKRomQQ77yu6lIv8x5JhnvnxDMJSDo>
X-ME-Received: <xmr:N6BvaqVUCjk-ppRiuoTfg1iDjrg2FDD2SrUSXR8_n-JL2aF69v8OJHGRQ3M>
X-ME-Proxy-Cause: dmFkZTF0jcSSKFGDg2KrIu5c43P4SsiipwcvDQBe+CHxos2n8PFgvSXAdv5YVW583HVAOz
    W5evq6qe09LpHqloXNM1K7VWF721j2bpam5IryqVMcYz9qouNwbpBEKv3Y5gifbeJAqW/Q
    YZQrbB51yLEk86mWZaGZ1Drq0Xy949i11wvFP7mkSWE3f4+XiyFqs+bTi+V6AVpUjNMMFr
    yeY2fCKzWlrX4GavSe/JRyGqxABGArlOuRBA0IP4mMA1yNK8fSDYGTdjzDrtr8AjwNqVIi
    3BcHDiClTVSc/WD5f6J8XCsMYF+6dE+0Mr4gWnl6eMmh6FUU5GqCPEjsceh07AxGuRDdh+
    EfRV12s7ikyQpMRWBYerSeFU2WBXxwmZE2LSsp5hy0hwP/rtpbErwtxuMvwEAS95+EE44V
    wr/cr8b/Uj/n7txdJMzlDjK2GRMySkFpK+xQTR6kTq9FyioT1d0lGAzRCmwklzvYIFPHue
    b/sz8gYxpIjRubmuFCDvAt3N5F676Rjh6sI5Q1NCHcULkgi970rianfQBc4MP7/ZcNd0as
    ZiYLbRwIgFAwoUdb+2NjIHD1mIkQXuYKVl7Hr0jZj6jOVzy/N1jN24aUOJuJjOLsxIVqMq
    Oz4v4aokkX+9Og1Ez1qdRHcAVRF97BiFz3KosqyvJRDcMOSxgWigX64K07sA
X-ME-Proxy: <xmx:N6BvanAP-8paNO_ewjpIydZkMjYcfBsBbXQoQHvRaR_VTSdI5i0lPA>
    <xmx:N6Bvaj12wix-oBeOaW8Ma_MGMDW1wIYp0ylPkCBIZsyFBupY_3QYww>
    <xmx:N6BvavR8e8GmcI_M1336EuK7BJRpb26NtSgJFO2clNPUpggV4GPf8A>
    <xmx:N6BvaobkfhT0quS9diYMdO6c38L88t8D8X2FiTwTKVVWU_gM8g0oLg>
    <xmx:N6BvaiwLgSwxHSaZf4y4mbUXY4VCcuRQx0mRiinuZEsY0dNXo5dF5pZu>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 2 Aug 2026 15:53:27 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Nico Pache <nico.pache@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 14/16] selftests/mm: zap whole PTE tables in the khugepaged race harness
Date: Sun,  2 Aug 2026 20:52:46 +0100
Message-ID: <20260802195254.1937477-15-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260802195254.1937477-1-kirill@shutemov.name>
References: <20260802195254.1937477-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4CC891C0002
X-Stat-Signature: wx78a61hxtjz4fn4ipt3db1pyawhdq8k
X-HE-Tag: 1785700408-327593
X-HE-Meta: U2FsdGVkX1+t2bU6kYqSZJ8uDASDfScLswokR5y3PFaURy3PQUhNjEX3RZojx2iKDQr/Boeo2q4C1D8uVKQYSAiXaZ8bWHUxSgPX6feN99WDOL4RGIIz0XJ83ulP7VRd5nWTxXiY9XpPqRlpfsn65jm2tGvoJ83938ioNagW21skjan4pqCBk35n5RSSrAb9GvbXpvTys16kSKDlVYAat3pibuPjqJMeAB+IXrra5+Pbwx5UpC7+1kiooZi9Q09EXXnbbQM4t7yRCSM8Wcbm1qW3BR4rt0RKsL+ZzB8PrO9/X+nC6S+efm7694LR5DloM2VegpdcMZrP/Mck5lVy7dZf1KG0c25e21Fv99JNIsJVmkZHAWSEmfRmiGcUddYf/tPz4MRbVKgs5IMWMzi9Yzhjkyjkg/F1HW+juBmMS1w0XaM5gCPFBky4L62wXSowiJ4m+wbk2Yx83zR1FX64lAGdMf7D9nY3obixhGD6vU+6vdG1gDxCDK7Ma91z6XI8lQDALKB9Nylm4LGcWMF8R98zyvZ6uYmM5BvkGsXmi0tU/PsfjEtS6Vvtdg8NRGBgd4A8llJRKmkTFS/ezTfzru1jOkIC/+V1MKAS/scMjVXYIBjpwlVIUF/UhTtKimh3q0XepYp1mk9dROV5W9+/I4L1irdtyKH9XH2mzi2LKre4AOlejZ06RMSr3f5ppCPH0GBY6WgMUwyXsx3TXdMN5AXXy3Hiv6QrNE+sX+KHcJT+jxNXFXHQR+BpgqsMr7o7FBkGx6by4fjaifkXnkLh6kw3IpOd6pAiv/a+A/T2QTjAy6a4wpF1ajpZfmjGwNR/D/H0Cb8dWI8Xpb9kJXuyHFycWLKEsoJuVdgh9JnKZwYOU7MwTTAfsm/4c3shXosBzA8T76mNLjsseQLbRls9f0l56FD1mZlWbVuBHbHUdp/hAi9tb/H+WEBqbyBTLUeNetfgG/d9hfihoMOKz1w
 80pjqrm3
 TVOqf8HalmHha4QLqKWePEig/hZ/VlEAA1vQ2q/EOOiQdbmAalR/nvEcW9hT7bt7O9Z4oI4nm9DCMH/kmlHqdHrxnSZF4HnB8m+GzRQ7H0KdnQcnA4d52mu76GrmMUQ5o9MIxtfxlQbY6tmuMT8kGQ49eXVb3+qI8MZHO0y+QwZ1eBkvYqeE2OGy/GPOrf6ST0S/HxvMEyR+C+gI9VnTk8ikdx+IBcT//u/E+FAU84ds9k6H5jMoB8PR+4PH0FXtq739loJl9hRWrsI37FLFw4SAtOZineYWZhoUN+98qDCbQN5Ubp6lU6gotI5bVlFz8RPOicawOqbnHsv/s3oVMqbvXHsDrUXwIp+0AH0ciGOutrCN0CwbdDBsyAYz/0YkGpk/+L1at6y9Rg/eRHtD7lpbWNsHu4/vrU7Okwl6i0t/5fliJy0MiPHi2ZQJxfsDKM2BgEbsT+vxbg1sOAq0I/c1QoZBfMECxHJyVjtTj8mkLBZM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The race harness's MADV_DONTNEED thread zaps 1..32 pages at a time —
never a whole PMD-aligned area, so the empty-table reclaim
(CONFIG_PT_RECLAIM), which only engages when a zap spans the full
table, never ran against a collapse in any soak. Fuzzing had to find
the resulting class instead: the table vanishing between the
engine's park and install passes.

Make the thread zap a whole PMD-aligned area once every 64
iterations, keeping the fine-grained zaps as the common case.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged_race.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged_race.c b/tools/testing/selftests/mm/khugepaged_race.c
index 304c72b4ee3c..2aa45c9e8a77 100644
--- a/tools/testing/selftests/mm/khugepaged_race.c
+++ b/tools/testing/selftests/mm/khugepaged_race.c
@@ -124,8 +124,23 @@ static void *dontneed_fn(void *arg)
 		unsigned long page_idx = rand_page(&seed);
 		unsigned long nr = 1UL << (rand_r(&seed) % 6);	/* 1..32 pages */
 
-		madvise(region + page_idx * page_size, nr * page_size,
-			MADV_DONTNEED);
+		/*
+		 * Once in a while zap a whole PMD-aligned area: only a
+		 * zap spanning the full table triggers the empty-table
+		 * reclaim (CONFIG_PT_RECLAIM), which can free a table
+		 * out from under a parked collapse — sub-table zaps
+		 * never reach that path.
+		 */
+		if (!(rand_r(&seed) % 64)) {
+			unsigned long area = page_idx /
+					(hpage_pmd_size / page_size);
+
+			madvise(region + area * hpage_pmd_size,
+				hpage_pmd_size, MADV_DONTNEED);
+		} else {
+			madvise(region + page_idx * page_size,
+				nr * page_size, MADV_DONTNEED);
+		}
 		usleep(rand_r(&seed) % 500);
 	}
 	return NULL;
-- 
2.54.0


