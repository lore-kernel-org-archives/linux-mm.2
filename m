Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC088C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 15:29:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AE626B0095; Fri, 25 Jul 2025 11:29:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45F916B0096; Fri, 25 Jul 2025 11:29:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 375036B0098; Fri, 25 Jul 2025 11:29:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 224F96B0095
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:29:45 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 79494BB93A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:29:44 +0000 (UTC)
X-FDA: 83703171888.01.6E4352F
Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.8])
	by imf12.hostedemail.com (Postfix) with ESMTP id D38F24000A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:29:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=126.com header.s=s110527 header.b=h6BVHzyr;
	spf=pass (imf12.hostedemail.com: domain of hexiaole1994@126.com designates 220.197.31.8 as permitted sender) smtp.mailfrom=hexiaole1994@126.com;
	dmarc=pass (policy=none) header.from=126.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753457381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=h1Dz29rI+/K8fhWCMTI5e7yo/1TAQNiw3qtHZWLJAKc=;
	b=0PpFUEV7BJC4xi2GPSHBOzFR3OlQrEGoKqmYjG7y7ml7z4xGN5TjUdzqYSIEryVhJqFItQ
	+ZKmFZ9NwZh8DNPbqkkuun+5aSVmZvrMyABC00t1MAMwPD2nwcHDqzQK+audk0gNWUL3+8
	uTLX399f+F2WkW0rzmE5IHnBTP5jEcw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=126.com header.s=s110527 header.b=h6BVHzyr;
	spf=pass (imf12.hostedemail.com: domain of hexiaole1994@126.com designates 220.197.31.8 as permitted sender) smtp.mailfrom=hexiaole1994@126.com;
	dmarc=pass (policy=none) header.from=126.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753457381; a=rsa-sha256;
	cv=none;
	b=qVMl5y47X01Y3jWoclc21AfgYwb5Y4GZS8Isa1Re9D7SQ/I7RxoI4lZRysMcHzKfh2jIU9
	9ABYj6IxkE5mVspJJu6seAjJr+hC5ZGcfVTxP4Mx1xDkRDAMY3gMVJWV9cu4I9FrF6HzYx
	nMQkyYlOxxl9ko8C0i2z02tUL4GOLDw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=h1
	Dz29rI+/K8fhWCMTI5e7yo/1TAQNiw3qtHZWLJAKc=; b=h6BVHzyr8uNf327rNA
	IKMyL0JkijHEQVT07M4ZBEEE4q3R9+3Gf5AF+xb5iS//SMvRlEHnlt8dnESazBW3
	5PI+8l5xIEJjlnEIB9BTNvbvKKEWyVscCLzfAv0Of1n6JZIRQ8VNlJiPxtsjCddS
	xJBrJ8LTPw3lp3DqOyAX8E9VY=
Received: from hexiaole-VMware-Virtual-Platform.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wDnN+W1ooNoTy_DAg--.30721S2;
	Fri, 25 Jul 2025 23:28:54 +0800 (CST)
From: Xiaole He <hexiaole1994@126.com>
To: Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Xiaole He <hexiaole1994@126.com>
Subject: [PATCH v1] mm/readahead: Optimize nr_to_read boundary check
Date: Fri, 25 Jul 2025 23:28:34 +0800
Message-ID: <20250725152834.7602-1-hexiaole1994@126.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnN+W1ooNoTy_DAg--.30721S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tFWfJF43Gw43GF1DJr13Arb_yoW8WF1rpr
	y7Cw4fKas7Wr4rCrykA3WkAw4Sk3yj9FW3X3y5J343Zw1fAFsFqF9F9a4YqayUCr42yayr
	ZFWqv3y5Aw4UXaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pijQ6dUUUUU=
X-Originating-IP: [183.253.151.152]
X-CM-SenderInfo: 5kh0xt5rohimizu6ij2wof0z/1tbikAaVBmiDlXfIqgAAsu
X-Stat-Signature: rp5k1kqgnojew3z364dxikr5aks18mu4
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D38F24000A
X-Rspam-User: 
X-HE-Tag: 1753457380-74690
X-HE-Meta: U2FsdGVkX18XCscdJjOv2f451gVk3IimjdvV+LiLt14Ci534ZqYggFjh67eK9/tGHiQ55JYzNxjGZz6tGQfcb3UtFYb9uK3wiX8O6cVStvEtjK+Fg/yyhc3/uOMc0kZ94xaWMeZICNw1969RRBJ4W0PH0+A8yDqEdhNZSPHPt4KIFdCZaC/n0ZCT6xYxrkMdq2KD8HlZZF4JZpaGDDSENLf5ggqHSvAZGpjMBcM2RuXM5UDDFDqxK5FaO8yC+gFUAebSXSEybO3erz5Z1GGF1ZOldYOqfEwCYm/JXwEH0HFa/tqHH1kTemX2Fs5XFdYDYl+KpyXI8u2/6t9+cZWMkMG2tPUVvFltO8OrPTnrm1S3kPmhPEkww9nbLicl4i6oVIUYQ4yhnduZlReWEjfQLkppxC5ZEGzPjs8nmg280EGxbsxUcyR2lR5Sz5F3pXdY2Ta4O4tUpxcK4XJC/6cb+mg3bbaxp+PdKmF0FLkfx3v52XlcEKy/mpqHI0r0bswfR0bGgrVkYyixA/EPSQLFNSaxOU6dtgbUvcQ7RGx7ZvSHrjYDnxfhaoWB/kJTtgQ5xYVnn28BwhQRJ5h/YaLQt9mgRmNjDMaWLddMk0Wq/IDk+Dc6bdl0fNPueWhh/K1rEzMG8LNsComqs6homcfgFTt7HjWFgwcuF7j9kiRnGu2i3oVIsbGK6jRoFdd7Y/A2dHOwftMjgj23khfOpp4QJCzr9NwC4KlgodRZnMkkRXx1Ev0lbX0K41UgxnmSNzTkJt9HjXBRDpH+83YuCWSKxnUlbAHd0cL7j+tU3HB0qthr1R+wkKfMjB0ui38i1pUN7dkHgNYIHIRZxFL/qUcxh30dbdRxTHeHetKRT7oEGcJV0PHjO65qwlPBmM49jQWnk49WldgSmikpFt/cZ+dx3VlUIA05hNfx6muwtq6jNd6Shl+eAlvXpgibplQx4FlG6nbAOscvzJzMCy+nm0x
 ifsp/8Fb
 TnSta5BprAB/HE8ozqxEXimFl8runI+dW5etgV0AD0Q4AFaAImomvl1W5GJHjElBwEC+7BHlecqHMyqyHmwbXDhOpO4W2I1Q94cIcLW3wXQiYcXEKivrM4q8lL46Z7/RDlzu7EKGQV6APwyVQ0p7brkm108S9UklTqA5CEMt9M60xYCtH9ZiydwFNoRZT1UvFxylK6NFGDtXNWlxfO9lhScmyyiIbxOhXi+v+XS3SS1SKA+fFi1co9C2D3JnoO93QySnWi2pF5wXolM3z2PqFxAzzqIjRRXq9tKdxTzpBjlF1q6kIYIk3MlNWFe14ovFnoQM+VmRhwpqwGyc1q99965kzRs3jlgKcZJ55d2O8nWsaGV5PATOtqdzEmaL6bn3yVJO1uGmOd71D4UPh+KFLytM96e1r16k7rdUT8c/24M8U7XXqb0Q0peMFzCU0PjvNf+41
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current boundary check for nr_to_read in do_page_cache_ra can lead
to a redundant self-assignment when the desired read length precisely
matches the remaining pages to the end of the file.

Currently, the code is:

if (nr_to_read > end_index - index)
    nr_to_read = end_index - index + 1;

If nr_to_read is, for instance, 3, and end_index - index + 1 is also 3
(meaning 3 pages remain), the condition 3 > 2 evaluates to true, leading
 to nr_to_read being assigned 3 again. While compilers might optimize
this trivial self-assignment, it introduces unnecessary logical overhead
 and reduces code clarity.

This patch refines the condition to be more explicit and avoid this
redundant assignment:

if (nr_to_read > end_index - index + 1)
    nr_to_read = end_index - index + 1;

This ensures the assignment only occurs when nr_to_read genuinely
exceeds the available pages, improving code precision and slightly
enhancing readability without altering the core functionality.

Signed-off-by: Xiaole He <hexiaole1994@126.com>
---
 mm/readahead.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 20d36d6b055e..bbcfbebe7569 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -321,7 +321,7 @@ static void do_page_cache_ra(struct readahead_control *ractl,
 	if (index > end_index)
 		return;
 	/* Don't read past the page containing the last byte of the file */
-	if (nr_to_read > end_index - index)
+	if (nr_to_read > end_index - index + 1)
 		nr_to_read = end_index - index + 1;
 
 	page_cache_ra_unbounded(ractl, nr_to_read, lookahead_size);
-- 
2.43.0


