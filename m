Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8CCBC982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 00:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE76B6B00BF; Fri, 18 Sep 2026 20:25:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B987A6B00C0; Fri, 18 Sep 2026 20:25:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5F826B00C1; Fri, 18 Sep 2026 20:25:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 770496B00BF
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:25:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB0B31C085F
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:25:35 +0000 (UTC)
X-FDA: 85228618230.17.0003366
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf06.hostedemail.com (Postfix) with ESMTP id C8A1A18000B
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:25:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="J TORV64";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=NJfCtBuq;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789777533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZsEX+0ruB8DSYOnav/6r+swke5RHnhh3EckcILtj0PU=;
	b=iRFyA1ZZ/NP/1qYAy8sA4zDrW36nE6cZEXMijIy/Y8SbWBbjNLPvAMeq2wr0+rVSC0FxE+
	yMKYuC7f0UD/+rvGqsg8fwfhSruYd31taOP9CHQcqrOrKKscglY6N8XzhPDUEwR27/oqao
	Aay9LZ8mUHkVcqeyhwmn+LjxxuWc6Tg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789777533;
	b=CL5529yLMyFWcBt5onspZfwi8BzW+EkrvM1HJqfQxUiF6ADD39t3prYNp1qVbeq/RqSpnZ
	Sx3A7/3H1i0Xw833qRCe4O6U9ICpdr/v6ToGlVaevSHX75MZJL81bEbX213/dDA7c3vode
	3O7MGjGSJvdwcD0w3+Tx6zrjbsDevJY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="J TORV64";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=NJfCtBuq;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 5DED1140016D;
	Fri, 18 Sep 2026 20:25:33 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 18 Sep 2026 20:25:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789777533; x=
	1789863933; bh=ZsEX+0ruB8DSYOnav/6r+swke5RHnhh3EckcILtj0PU=; b=J
	TORV64XLJgBCCkzrwuTlkYSUGxEIV88/s4K2S3TWXPhU2afKbpCKqypA8RyMDPFp
	nz8AT2tEVVePtF4vM/HGihaX3p34vp92p/0duTObgRkjj4c04Qdud1xxd5ohpM9s
	STMw4LooBS2I0CLf/JL851GBDq+Ew3JGE82UTj0FTp5PUNtVWocrqfyOx+uiHL99
	B/BhoPC/8agF/W0oqwwfUc1p7Y8wVpEh9edve0kFXOI+p9oc1ZzlxXF5yDjJhgC3
	gE1Kkza/3ixLh4jENZCGWiqZaKUcCMNn9x4IDpJAQiMyxbmHMDgX+eAdcutanLuw
	ySqMmvKRshlH6kYgYjl4Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789777533; x=1789863933; bh=Z
	sEX+0ruB8DSYOnav/6r+swke5RHnhh3EckcILtj0PU=; b=NJfCtBuqPjxHtCUF5
	rA8X4eBVknkb76xvoX9WUnD0U4Eg2lvAB4IRZoueZM7VU6OBnXVJHtwYYGEsl+hb
	POz7J4FuQMVT6e24HbeyX0OMQsgyuIntNHkgsJJtuThv2mPIveojwc3/fBFjTt2W
	zbelc0ACznmSJ9n5/o8rjYYzN/C+P34PcUrnYAGgOaK8s3m0tkuiQiBjggsCj7UY
	WY0FkI6nhcHFN/abniVMd/12jlquIdpysPw/xhf0Eu5tXKUVzEffZaZagPQtSB9t
	0Kqmzynla3sQiOWFh88Xg2NIvFrPK+UQt11NrAg84JvFGAylij2HZI7Wy1SrOhpg
	dtzKw==
X-ME-Sender: <xms:fdataupXt6zh-RUzvxGdRRe410z8FJ99McFWrOeS80DjOmnZCPT6YQ>
    <xme:fdatalBDCaUF9Ojwbvkx7DdZs4P65qQDbqM82i9cqUm1nmF-z3paaNkHyKjNxqmOY
    4RRjp9TRbAjdzzlW-v7DPBwQI03q9dLNnpV-baQqAvu68Gow-NAdg>
X-ME-Received: <xmr:fdatalbh7y-SFuo3kvhxoQ5pu249NvqlhNYrMaz0Xue-zAoGHaSOwG3PGlA>
X-ME-Proxy-Cause: dmFkZTFyC+XeKYnZ766rqTYe4SsoatN0doBd7ADemiperjFlmE10ggdkgYpZeWmNOU4aBc
    lm02WEvCO2QGG+A0SGXMzCjVWjDSVCQ5WJ/xmSMbLZJLqVjt5aEnrGd0hUbHPJ/ejcqjFa
    xrmYY/YNxh9EpvRrTjNMqslNp6oZ1XKAjj0b9YUD/U+Umt4HJhNRFStrIx7jR3Gf+CAD8k
    /TwEvtSve0+WgA7utVqBt9LeXDUSIUkf7dn/1M9JWIyORT8Kp2cNKrwYutOzK/Z35sBm5S
    qWNICJAq9yYROUOkEgx1cQSYtjkPP2DMZwKGXS3JxTiE+xMdBmJUepOSBHs3/DvnVTIMEa
    MZHxhDKY0xlI1hrODY+2xppEEtaciMYpLIJfUlGrUvkY7nVYwYEAcgwwYVB4MdOWOT4+zn
    QUHtQxYd0JkjouR8IN9JCkskC6nPSkcQMYQkMbtjGp985VZy7s/Ivh8h/z80/05cYhrJQ7
    k6eEdO+Qy2SD34yH4g0yfwfXsVYLzRF2iPpq21uB1ysg1zgQz5RHJe09YtftMgtktqW/lb
    2bgEd7AJGhA6KOujiAqda3lcX/xvIxRZdBj0Q5EqwhmDShOybvaaLhAtwghRhD92V0/oBU
    9t+3f2lmkmcziW5z7jmynBsylzhDqK4ZLEO8wje6DgwOmRIn/Gev8cSaIs3g
X-ME-Proxy: <xmx:fdataltnPC6DWuaiLSMfP-LRjc9ZVJnTvWDnfDMOOP3iUBE6kj2r2w>
    <xmx:fdatav8sSXDY-z_bszdnlHVqIHf2VWbZslhxCYpqxNkneyGO9DEblQ>
    <xmx:fdatatWhuG65afOTqON21CS0Y2dOwsYB6i-XiEqD_N3DTVRv2h7UCA>
    <xmx:fdatarvvT5CNOvYqSc07fmW3yafSvKAu0NdF5X1__tOplppOtmwz3w>
    <xmx:fdatagyamm0m4TXYJsAvu_KSurLeEK-iBihloNz-a4V6vjpieHnivpEf>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Sep 2026 20:25:32 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Usama Arif <usama.arif@linux.dev>,
	"Nico Pache (Red Hat)" <nico.pache@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	kernel-team@meta.com
Subject: [PATCH v6 19/19] selftests/mm: zap whole PTE tables in the khugepaged race harness
Date: Sat, 19 Sep 2026 01:24:49 +0100
Message-ID: <20260919002451.496763-20-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260919002451.496763-1-kirill@shutemov.name>
References: <20260919002451.496763-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C8A1A18000B
X-Stat-Signature: py3cyf8u6hekwp7z5zkt3ha94c1pdeim
X-HE-Tag: 1789777533-678569
X-HE-Meta: U2FsdGVkX1+xXgT5GwpmGIr0BHO2Br2HHijSfYJNdXDpjWcttUKylfLKVbWsc2e6nUlJxFjMd307XDrzI+syGYUnWW+OIQFpMo+TYFgtuKaprTx7JAILEOOQUcVwpO1DCwCX6mFma/jlQ/MGGkZ4c9qifQBABCH9y4jttCnsQAaswr0B1AtCFANB8mVfLbvqyB2tP6HJk2xCgL733JsIcUu0DxkVHIAXJa5rC1UTXXjo/Gz6AM7M/8OdfZl5wk5rwb6a50jJLlNeeT3WM1S56c83GaTFXlyc0zQwanj6EbEVsVK63zT6lFwR2uugQaICPZWe6gqPEapNtJqISsn/0+a/zAuK+kR+lyIwfWrXwTLayCwF2CE/5XIDgkWqCnp7Yvi+NKos4sFSDRhX5reanvRQAehq3SvijI/2M5HCjYW4Ybz655oplOagQB3WW4lGctoEzhg/aXZDE4OPCZO6l3ZPEuzDEePHDRHlILdWq5jbBP6mnqHqzPfulQ7c/s17zDRnn1uB/qBmH14C06zteqcXvZOTycCe4TLDEW3/LRtm1xSpoOX69tcN4wPD8Pa3PEVSNTHKd808YrmJxNsTgik5kFTnbxf4Eww59PdNzATHtT3dNYCl5C69TuSIf5hWk8XRJrOVVTEkJk8t3M7zEJ5W8P479heK51ziPau6wv8HNudRltjyYSn5DwGuzj4sFFaTOICg5lSxRTkEkLLggu3hzddwh8ikPe7kf398N7oSfipEHHOxmDiuiljsPeFSPILMSK54D41gJcYo5a0j453WgVrh/+CAfIkNtrVoeBN0hpqPki3JzVEtd8YfYi42qE60ApAzGvumF66NHNcpF2BnRuYXlAXPbA62BFG7ab9vehX/rTmYQawQkS+4pihABQ/DofQrRrB4DTVuqxqUCN8L00Xcaev+ygvEgROJsaURJpMHQdTidRkVj0Ude1GZf5vtqRd8ygv4+xf/a0i
 2xCmkTvk
 u2XqlKDHCX0PU9fK05/VWRYkXGy5Cw3boMl6stHpjxtdRn/7T9GMLOhmI58yeBoPqe3uI4zpvhTEVmoMGmUpfjYxTtco2Ns215lF4Mk2OYLoDbT/PT9ng/T1Ne+LyPdNRON+4btUOKjvSC2tK9LQt27NX2pETWP5EEek/3+v9oAtzkVVsF8jCravBV89NcZSiOCYzQ9HwfujXfiNv2nwEaRe6y1wzNA50FOSmhbsEt5XbAca7zC4W7Bb8vOQGtqWcfhqA95oDMh6U1Tlt08tU2d3MuvMgl85skBJrWW3nWss8mtOZy7Y4UVlFoo2x9tbMa7JGuncv5B2+CVnV9+PnlIxZvZUE96TLi7H1LcqcMNIX/iT+xJlzw2/6qM2saLqzyXT+6nCxPLS9/1Kd2qaoPueTCeXvU0x9IPqoualgZHQNfmaqv/TThEPzPZiULNTUZSUzwffLmpjE0GoeWqjEfnrD29OGW0mewvx7XfFHmTDIqMGoN2agLUOLOwvUaW65ZfN7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The harness's MADV_DONTNEED thread zaps 1 to 32 pages at a time, never a
whole PMD-aligned area, and only a zap that covers a full table frees the
table itself (CONFIG_PT_RECLAIM).

Make the thread zap a whole PMD-aligned area about one iteration in 64,
and keep the fine-grained zaps as the common case.  The new case frees
page tables, racing that against a collapse walking the same table.

Assisted-by: LLM
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged_race.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged_race.c b/tools/testing/selftests/mm/khugepaged_race.c
index 68046f0bf6d3..abb0678522cd 100644
--- a/tools/testing/selftests/mm/khugepaged_race.c
+++ b/tools/testing/selftests/mm/khugepaged_race.c
@@ -118,8 +118,21 @@ static void *dontneed_fn(void *arg)
 		unsigned long page_idx = rand_page(&seed);
 		unsigned long nr = 1UL << (rand_r(&seed) % 6);	/* 1..32 pages */
 
-		madvise(region + page_idx * page_size,
-			room_from(page_idx, nr) * page_size, MADV_DONTNEED);
+		/*
+		 * Now and then zap a whole PMD-aligned area: only a zap that
+		 * covers the full table frees the table itself (CONFIG_PT_RECLAIM).
+		 */
+		if (!(rand_r(&seed) % 64)) {
+			unsigned long area = page_idx /
+					(hpage_pmd_size / page_size);
+
+			madvise(region + area * hpage_pmd_size,
+				hpage_pmd_size, MADV_DONTNEED);
+		} else {
+			madvise(region + page_idx * page_size,
+				room_from(page_idx, nr) * page_size,
+				MADV_DONTNEED);
+		}
 		usleep(rand_r(&seed) % 500);
 	}
 	return NULL;
-- 
2.54.0


