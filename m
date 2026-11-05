Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B552B606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 05:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LigJSMc5
Received: by kanga.kvack.org (Postfix)
	id D3D916B05B0; Thu,  5 Nov 2026 00:18:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEE7A6B05B4; Thu,  5 Nov 2026 00:18:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C04496B05B5; Thu,  5 Nov 2026 00:18:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9EED06B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 00:18:24 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A896A8525
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:18:24 +0000 (UTC)
X-FDA: 85399909728.18.5A0B768
Received: from mta1.migadu.com (out-168.mta1.migadu.com [95.215.58.168])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9CA6BA0002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:18:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LigJSMc5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.168 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793855902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EHHTNOyGnr1PE5k2wGmLgV3xyiVaxO8J8/TzziII9T8=;
	b=ZFlRQlkn0z1cJSRosIumPoeIKUC/WXr2YPeJ2FRypkAGchgTAcmX+rhFZFPxUprw/tno9L
	BfApB/xI+ep80h/SdVNsbtgonbq+Pd99LYVr+99igbIOK3JaSy1p3fTDtdgtjzdxW0sesl
	Y9AhSjxPTM4Vswp+p5qWlnQCwpk/hF0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LigJSMc5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.168 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793855902;
	b=3NH595tTNo20MCy8iBjF7VwDjhl+MMATyHDG/m0l5sH8LwY+akXHnVhxlcm59siAXKyjJP
	Sn8ZtFdWHnj2GAuieECP8Yuc0uQp6HqEp8q9wCOD/Ttdp5KktbHiLipxHTHjBTe94gMaje
	DWBXPHct8hE/PzpISTK/II/jn3Obqu0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=c1YgwgSqOv/daQ+67ELiYNYLj7qD2N3amAckkdhSUFU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793855897; v=1; x=1794460697;
 b=LigJSMc5f2KYDkMP0eS4DmhfkzQd9R9sulgvx+S0yl+o6hjQfLqt078lH3wk8PUJOl3Vzf2T
 Pt6OseP+xN2b+8kYa2UiZQqI0/B5Gi1oyMX3j2K6n+tyl3SI1WLgWMPBkmpjKr8E/9hCla6dahW
 DTptvkQIVzKcpX+8HICbxn8M=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 6facb84ef91715ec;
	Thu, 05 Nov 2026 05:18:16 +0000
X-Mizu-Trace-ID: 6facb84ef91715ec
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 3/4] mm: hugetlb: fix GFP mask propagation to CMA
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <ac2de9b321f68c1025333e92e3ce94beadcb0b6c.1793850539.git.zhengqi.arch@bytedance.com>
Date: Thu, 5 Nov 2026 13:17:57 +0800
Cc: osalvador@suse.de,
 David Hildenbrand <david@kernel.org>,
 akpm@linux-foundation.org,
 azpijr@gmail.com,
 Lance Yang <lance.yang@linux.dev>,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 Qi Zheng <zhengqi.arch@bytedance.com>,
 stable@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <711211AD-BD2A-497D-8541-B63C68509920@linux.dev>
References: <cover.1793850539.git.zhengqi.arch@bytedance.com>
 <ac2de9b321f68c1025333e92e3ce94beadcb0b6c.1793850539.git.zhengqi.arch@bytedance.com>
To: Qi Zheng <qi.zheng@linux.dev>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9CA6BA0002
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3cz1uwrw848ajapu9117yjdaxxnc3gx9
X-HE-Tag: 1793855900-38564
X-HE-Meta: U2FsdGVkX1/2nCNzI9aiKnVh+GlU6Y62mZIrIIR9YDAIDGRcBiJyr0WlfpyJyxwTO1moW7u9TbQKCUmE5tzZM51IjqAKRVC/YQyqkD/Sqbg+mdIw+djRTOrTJHP0AHXJXV3+msJSr2/UygW1PEfbcB03+IFDYboCt5t/u9kT52mnsbDjByEIReJcRYUTvaBGGNowSGVs6TCfy43WUdUqNIqqhPBWCKcdEOLE7qrELa5f8aWV/aLoU7D8EH7WCQoe7a1bXqhLFl2DP5zLyjRNIw+r4e6YygTZkj/pnCv3zpiL9qZgf3b1FLDkbbi/SBSM3eT9ZPSRcA9Qo8Ev3cMk3oyB7mjYQZ5AeMMqJxaDMjV4D3glLzgfTlrwYyKXJFlnu2/dM08RwCdWrdD4K1NcST+cQbdcvUK0fnrUEUfOO0kC+J8Sz8gtvc6HiTsEVwfjHNHhKEvLRRnAwBjs6WrvLFMe38EJMN8heFtYLe73g79cAcxaXeAP0TFf6HcQbsMaGD5GcD/LaksGAKft6hc4kgUtLhno4xiKqSWzbpmfqWLRADci5QVEsN4nlNNtsDKpD1TssWq5NAx2K5V+QlZ9jS4inxDlIExF5qIulBcaRANVek0wAVTYjjWOHiG9TG/eY4B7YHULM/IYpu3HaRYQwncZWpaOV+EIYW1G2wrpQxyBOAYXPczsT1KPm5y1k5CuoNm/K1B/lERnbXrTB9sALhiCJ7/26KKmVWcsjzE7hiAjGHAqOWrPcyeMuescxkNAuSa5qrclpGxsVJsXgGj0XpxjI6OOpEZ2J32b8lK0jK21ma8IxXspZX7nmahRfrBKHXf3BywMEL2mtTD+K6+275jbVCm/cPLOg+IGqQm1CGoXt+CQ68s5HqtbfszymU5J5PKiZB653xQMddhY9UBnqT7qUbwIBsbkyQNB8W/eBkKD/XY77geHl0dRGFh/10HRUCLb2LIhgfQTzPQq2F9
 Na4BsYm6
 jqdWXJjFRtfNys4Ufc0RWHPJZV0vnh5uz9QagvmLuxM1SwoN0ozO676yp3L2f0JFu7VrS2pVJ3KWimptIU+vVzXz0C1GFHjw4NPxFD9DEkxgUwXc7h0xEs94uoXcx78mdfGIWzC+O+3TEYWV/0UT4GFVPUDkQYAFGUlhRB3HP3YSqyDc9z5qsLrSvMAm5H/5+/Saa9gtInm0haldzogNXl1ONgyPTajU+6+u53cESsBdc581xN38AD9krg7ioEYd7bgaJyWUvjknSkdQuVqXcSFk6L88OFooiRWF3tGCSvM4Ur7T6E610sVFeS7udHipS4o20yIjX3j1zAbXSX7noQ0EBkDQJ8bcoLtLSiiZ9jf2xktU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 5, 2026, at 12:07, Qi Zheng <qi.zheng@linux.dev> wrote:
> 
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> cma_alloc_frozen_compound() uses GFP_KERNEL, allowing direct reclaim
> during the first MPOL_PREFERRED_MANY allocation attempt even though
> the caller clears __GFP_DIRECT_RECLAIM.
> 
> Pass the caller's GFP mask through the helper so CMA respects its
> reclaim constraints when trying the preferred nodes.

More natural.

> 
> Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


