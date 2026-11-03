Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ABEA606A329
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 04:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=ZHhoXCfZ
Received: by kanga.kvack.org (Postfix)
	id 3F1166B00EF; Mon,  2 Nov 2026 23:18:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39B4E6B05B6; Mon,  2 Nov 2026 23:18:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28AB86B05B7; Mon,  2 Nov 2026 23:18:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 036756B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 23:18:25 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 77B1CC02FC
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 04:18:25 +0000 (UTC)
X-FDA: 85392500970.08.E23C669
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	by imf23.hostedemail.com (Postfix) with ESMTP id 47E6F140004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 04:18:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=ZHhoXCfZ;
	spf=pass (imf23.hostedemail.com: domain of daejun7.park@samsung.com designates 203.254.224.24 as permitted sender) smtp.mailfrom=daejun7.park@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793679503;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x+dElKkp++qIJHqjVaYGMgPLSvYo/yZEgWC3hXRcnJ0=;
	b=whCnppmXgiwp+r8ZpyvYkrYJOt9rK3NmwHscH15VzhXIEJT9f8apbTK1sYEksfVPXcNiVk
	owGOVg/WlNVtG1UNcx+dINt4ashqlCfiMLBIOq9T4aDkxIks8AbdA8zvWsJjJBq7oQn+5W
	8s3FXNN0eDcucgFXaBeNiyBAqoutmJA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793679503;
	b=HJJdUbPDIpDfzJyfooHisXIVDgvqLeSHJH+pTL+f1jKVVPZvaoPRzq/im3xr8cTv5qbg38
	3qOrDR1e7cMwXrbPG9TkH7S1t0tLtt2E5IT3FyHBIb3/Q+grPvk+5rG6ye5qXjpGywPJBQ
	PvMIkIxHWQXhzMKECBpEsn0bsmQHz8M=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=ZHhoXCfZ;
	spf=pass (imf23.hostedemail.com: domain of daejun7.park@samsung.com designates 203.254.224.24 as permitted sender) smtp.mailfrom=daejun7.park@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261103041817epoutp012e55161e517901d3c16609160f8d03de~kbgACKYne1747317473epoutp01R
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 04:18:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261103041817epoutp012e55161e517901d3c16609160f8d03de~kbgACKYne1747317473epoutp01R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793679497;
	bh=x+dElKkp++qIJHqjVaYGMgPLSvYo/yZEgWC3hXRcnJ0=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=ZHhoXCfZ6PldD2Q7Pzg8xGCWL7fQEqoii7xTCAuQ5dLlfxA7qSjsw6os5C4YImr2x
	 VGz54zxa/JH9h1znlIZzupJskSP5FbK2GuJitNjc3VN5T3uo4krR8+jDw6Q8cedvip
	 JAO8X+12g33EyhOrfY0AxOG+xVyyPa7MR2qHAn60=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20261103041817epcas2p3a3f9b84cc41517462395611187f08c7c~kbf-w6PNE1410014100epcas2p3L;
	Tue,  3 Nov 2026 04:18:17 +0000 (GMT)
Received: from epcas2p2.samsung.com (unknown [182.195.38.212]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4jJb0T23ZWz2SSKj; Tue,  3 Nov
	2026 04:18:17 +0000 (GMT)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Subject: RE:(2) [PATCH] mm/readahead: keep at least half of the async window
 when aligning it
Reply-To: daejun7.park@samsung.com
From: Daejun Park <daejun7.park@samsung.com>
To: Jan Kara <jack@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, "Matthew Wilcox (Oracle)"
	<willy@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Daejun Park <daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <747jhqta3plrrx3bfikceoltsewshdpejdei2qjpn3onnvtu3p@cptmb4phbn54>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261103041816epcms2p19b933a93aed4463f954e901c7326e055@epcms2p1>
Date: Tue, 03 Nov 2026 13:18:16 +0900
X-CMS-MailID: 20261103041816epcms2p19b933a93aed4463f954e901c7326e055
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261102214705epcas2p4e71e245666406025381037104803dedb
References: <747jhqta3plrrx3bfikceoltsewshdpejdei2qjpn3onnvtu3p@cptmb4phbn54>
	<20261030-mm-readahead-async-align-v1-1-109dea6851fc@samsung.com>
	<CGME20261102214705epcas2p4e71e245666406025381037104803dedb@epcms2p1>
X-Rspamd-Server: rspam06
X-Stat-Signature: g39kc3kb6ztdnuwmgn8r4ogu9pge333b
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 47E6F140004
X-Rspam-User: 
X-HE-Tag: 1793679501-367547
X-HE-Meta: U2FsdGVkX1/7YTIGB/svbijX+JRYSzcbLDrlD4ngmIrW/HJcPI6JRzKnQ3N1yc9uxrWViXciXkfLz23xuq6qjqp5Jm4/2UvSF8PAigOeiV+/qnnDhmIquZ3KEeTtPC5SObSP0V56ZqEgs2Dun0eDzd4ytGCVpTBCK6j+oLwyLZ4xL84PUvltTLYracDrTHJgF0BoiaJQG1hvnlOzt7mOJ89RoB5l/DnPIVfr63J7lvhdRq7k+EFRb//OXxo+FPkrL6PUitraoTsMs0Ky21qU6T/sZBYESfJzpY0DZFcDQpCLM4eIYZCYJ6X9pMI6gM/Vva4A1+piILNH9t3Pxab4roUSxo35DhYQZEH/KIUeT+8YfDKPmSzzRlGGJdM8tJzZCOF7HJsEym2xqZeAEehLIIPaveYRhqxadg7dJP0xN7v+faiWzluNLDngPfHk3ri9mFEiVdbwZ98zMwbykbpDNl61S1pj82lGL5w44wGUUwe3+Rp9H0+eeU4IJeTbC4RQ6AwUx2S0+YqKphxjE56PmuBXYWMW/zz9rCSrekDWwr/DsfRM7dHX186lDBgHdZjNN2QcWbiYKolewgiLa5D8LhmQ3ulBynPW8xzhNvHAd3YbUfDIULI2wNhpmOFr9sUiPaOC9BisN84j04HPtP1Z0xidakdPcsjOBSE7dHv198Lm6TRx3/rQE2h3gzD26zuhLGGrW0QpSWmD3NFeq8eZNL7LuhJeDtyNBoYZ1HNZWT8CjVJQIZ496hXKagw6N+Ii/KEPAoU+VfyrBa2aFDcTt/Pc82HQuzG+VsqrYgajDEQCVroFuZWL5eJul/Uq/ZXxxroVWKXaHOsWDq0kbGLo21ZRozu1kIlNn7YrfjrJPffENZYU5tii6yXY55BL78DeGUBaqbrWU/WrhvcAiDG20K4MemV2ryiL4rxTfIFBiE0W1pM30pwW36h4HiSlmY6KLhYMVm3Ul+W4RhTgUK/
 RpEhVOUT
 MdywICpOqDJl+TzAolM/5AwpE/VGa9IRPo+vhzRMab3RSHr3vXiFHv9Cxk0H0FvQ+rJdezANb0O/6aPcyBEJXiJhARVPOOcKcxbtqMKg2vXsBDA1WL7zd9nCCEYExyCCVWY3Ey/goiSCi6ZqLTWXT4muyEsJNW3NPBvNwwQ0jz81LP1ZKP1WfvII5+S02mAXBlQhn1geGaVJ6uNN7I8KV0AE6mTKpUxhoRJOCCS2xIsUExzZwKIezxZaIIoICGaP/OgLg7oKwhWuoDpciprp3tmSKEOZgqg/6ysJxmEI+JBNkTck6/au8ts5I7AqIaeq1yUlq/HHsWb3nDrPOA9HhBREvOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 10:46:53PM +0100, Jan Kara wrote:
> OK, I can see how it easily happens once that we trim the readahead
> significantly due to alignment. I'm not fully clear how it happens
> periodically. Is it that you do 1 MiB misaligned reads and so we
> periodically end up triggering async readahead from positions that are
> not aligned to the current value of ra->order?
[...]
> Instead of trying to second-guess the logic of page_cache_ra_order()
> in page_cache_async_ra() I think we could pass a flag to it in ractl
> telling it it's allowed to shrink the window instead of allocating
> small folios and then handle the alignment in page_cache_ra_order().
> Hum?

Thanks, agreed. v2 will pass a flag in struct readahead_control and
align the window end in page_cache_ra_order() after clamping new_order.
When a window still starts just below a 1UL << new_order boundary, v2
steps new_order down until the trim keeps at least half of the window.

Your diagnosis of the periodic trim matches the trace:

1. After the 4 KiB read, the window at page 48 has size 56 (ilog2 = 5)
   while ra->order is 6. Aligning to 64 before clamping to ilog2(56)
   trims [48, 104) to 16 pages.

2. Because of that trim, ra->size is only 64 near the end of the 1 MiB
   read, where the remaining req_count is 81. get_next_ra_size(64, 81)
   sets ra->size = 81, and ffs(81) - 1 = 0 skips alignment.

3. That enters a 13-window cycle every two 1 MiB reads (sizes 64, 81,
   63, 126, 2, 4, 8, 16, 32, 64, 4, 16, 32), where [896, 1022) leaves
   the next 128-page window at page 1022 and trims it to 2 pages.

Tested on mm-new in QEMU (XFS on NVMe, read_ahead_kb=128, cold cache),
reading a 512 MiB file after a 4 KiB read at offset 0 (5-run median):

- max_sectors_kb=512, 1 MiB reads: mm-new issues 3329 reads in 0.251 s
  with 9721 folios (0 of order 7). v2 issues 1031 reads in 0.200 s with
  1039 folios (1021 of order 7).

- max_sectors_kb=1024 or 2048, 1 MiB reads: mm-new and v1 allocate 2839
  folios (766 of order 7) as ffs(255) - 1 = 0 skips alignment. v2
  allocates 1039 folios (1021 of order 7).

- max_sectors_kb=2048, 3 MiB reads: v1 issued 348 reads with 0 order-9
  folios as ffs(385) - 1 = 0 skipped alignment. v2 issues 265 reads
  (273 on mm-new) with 252 order-9 folios out of 277.

Daejun

