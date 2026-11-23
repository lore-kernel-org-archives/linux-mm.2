Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8F04606A327
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 20:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DwAC8cHH
Received: by kanga.kvack.org (Postfix)
	id AF9306B05B1; Mon, 23 Nov 2026 15:22:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A832F6B05B6; Mon, 23 Nov 2026 15:22:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94A196B05B7; Mon, 23 Nov 2026 15:22:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 683406B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:22:29 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F2810A81B3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:22:28 +0000 (UTC)
X-FDA: 85467506376.19.6827437
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 33CA1C0007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:22:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DwAC8cHH;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795465347;
	b=pNDB9m6gooCwXRw8XSmczShff2J2BzAvaHX+e2Y8LJoH1GiN1Y78un6FG4xAkNtsQR2Ea8
	EMotjP4aGzFSac17Agm/UHU8r/++9QI2N+GwmJSeJGzlRxGsN/XXmaLvHuySYp/VXfkJt8
	lWHxN2QKBdSJyw3EFOmmin3vMf31a+E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795465347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=25UVLybwoRnEcpbdXV2pFcFQ0Vqv+61x2so2s19OgUM=;
	b=N9w0L1lRGJDsCiIyxg4U8puBMEImFcLM7h+qZxOL1DzzAKUIVwMx0//q+BTCqOIyOfKbJ3
	Z5fMnWczNnacPu9QaG3FF+fwMXaF+175evcmJ34cm5RJLE0gmgfi7nL/IwMZFBfeFaW1bd
	zC3tTWDgcuM3xZbShXo0Lu4ubvM6rg8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DwAC8cHH;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 976456189E;
	Mon, 23 Nov 2026 20:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04ACC1F000EB;
	Mon, 23 Nov 2026 20:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795465346;
	bh=25UVLybwoRnEcpbdXV2pFcFQ0Vqv+61x2so2s19OgUM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=DwAC8cHHY+5qU8NdK2ZbrsvhxFqopogKwAxsWk8kEnCCVT6Hmbtw0V6XziVvGOJFl
	 UqXnmynokZ9RofSYPre5yp5SaL+eP7gD+iVzbExurknf8l0NwCrdN3RTO1xJ6LK71f
	 8PNPmpHS6+1C0lJh+4nQoWqAlcS3s5LQourJH+QE=
Date: Mon, 23 Nov 2026 12:22:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: kasong@tencent.com
Cc: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>,
 linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, Muchun Song
 <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, Ying Huang
 <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, Baoquan He
 <baoquan.he@linux.dev>, Nico Pache <nico.pache@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Vlastimil Babka
 <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Nhat Pham
 <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan
 <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev
 Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins
 <hughd@google.com>, SJ Park <sj@kernel.org>, David Rientjes
 <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, Vernon Yang
 <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, Tal Zussman
 <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, Xiang Liu
 <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, Zhao
 Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>,
 Joanne Koong <joannelkoong@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>,
 Hui Zhu <hui.zhu@linux.dev>, Maxim Muzafarov <maxmuzaf@gmail.com>,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 damon@lists.linux.dev, linux-doc@vger.kernel.org, Tianyi Chen
 <hi@tychen.cc>, Ridong Chen <ridong.chen@linux.dev>
Subject: Re: [PATCH v6 00/18] mm/mglru: frequency guided promotion
 (MGLRU-FG) and flag cleanup
Message-Id: <20261123122223.ea225d3b6424c274679b41de@linux-foundation.org>
In-Reply-To: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: 9afb9d31fgq5z5aa5mcuhgys75sqe84z
X-Rspamd-Queue-Id: 33CA1C0007
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795465347-833286
X-HE-Meta: U2FsdGVkX1/daBPrOYJgK02zrCAkI6gZ4etXZTdRGQ6b2qbDklOzpy1GGh3+EiGtxX7RmRW1GsR58GnG98HP3qii8QJyBEpDQM1543WJVAQB+sog1vR3Qwyk7eGFRKkzv6aIpK4Psma5jpA46jhWhBBKa72ytLnqxZ6vGsM0HRkGPYlnuQ5IJdlJR/cCR8ZET6J3/ImjU22wFEyepnjqPimD8E6WA9x+mUkueDYxYqKPgQk9Qx3IhupeJ0vQYnaYHNqkTmI+/DnbHXpQRQlboi3BMI70OmLHbQ+p+mm4vboaRFlRgJCMr95ixx4Q85DyaXEn6lzmBRc+qziKnQvmbdTYzL0z2MuX7upYlLvsFUJ9cQDRXsrNXfnjbesgFHfL+snTSB+RWAAK4UW1SxWUKrRuQfWA1rQ+icfdRcA2VzxgaNVGY1HsqMmP9fbdp7y5MWyLdoNyWYvnlcApx2t8r84Hd0BHayE/UpuIYVHvdo3JLTq1yx0LiJGldJCVBIlOsdjO1hJ7/Z0vYUnB4nJaInM9JNZIZbaIdaJjzVsCeC0bRDgSu94Udoa8t7oy1thmoYzMWd5BLuYXJNrLp4hAj03AZvJdDGco4BLC7fYLggaFFRQg+dmxuc4lWVzpJGa3BfcbtAMPuQhjyOaLJ82AgX0cyMII5nzSoX0huQiOD4Pb9OqQJICLnLEbxeS7UMsq1l4o/xBVchKuiHOHGxE0aRxZ0A7KJzQXod7w0AcVnzV0hShaYPEn0ep1cq3PogBia33bVtTNg6DfrqsX7J81dT8t2XyOI9k75IWjFNF5/SVJUVmb7B8Rym9+zUq2KF7HTkfmu87ALdA+voXKKClhjyyQldvRTslA2ehmTCQGT4veUqoKF+e9HH1DyBQryQUjGGib/23oYE7XBnKPwqlIOdNdvdy9SeQzIJITMkckUD6aiRILPdl1BIocnVvZBL1o+NzPJ1YSBa3PjL6IrqX
 G95AEIZP
 1ANWt4TO/IoWy/0B86tFepYJo5PISFxo7W00AQqgixjfA3qIN5IUl62U0SjDACah+mJefdgDQ2+IJq5dYsnlYXAZfVKrelnwSZ5QepTsrWFNtMntBggbDRhfZOUfMPc6Ra4Yhdjab/VuEpAUnzieLe56lODY4qc+G6cc7ehMVMaA7FOoULodCBg9wMBaUQ1VRSecsgIk+C/u3wbpWbcL1TqVZtefJdPMYoHHcZUHwcAlLHfmi4960JptVZUDmMdeaIwD9bpcqep9KnHBYD4kUhDnp78IP8pdCmwFoyikXQFY5y3CbCII4gm4LaHAix02xerHga5m/jlBtF2vDIDj9cxEbJLaEZEhgWJRUKzSEauT3/ALQ+lB6Ul8U4Z4Tx63Dsi/x3P9KduAXJfy48yU1ByS2G1nXJXVJsivVDkH8FowXQA+vuBM2NX9DJuHXhmFvA/pYG9YSwEFQIA26sKGvFTu4lRHw65bwD748pRrFBb31ji2nQT6MnPyXzzoaXWnin+0VwAse+LCLGXzr5YwpWoYn928qmczeVTrxAa//VxcoDf3hszMeHIh14RMGYqPDJAD5Qje76qtnQaSsrISdRhEX8dFa7znvKY6J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 24 Nov 2026 02:52:52 +0800 Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> wrote:

> This series implements MGLRU-FG following the idea proposed at LSF/MM/BPF
> this year [1], based on current mm-new. Depending on the workload, it
> improves the performance or reduces IO by roughly 10% to over 50%,
> fixes multiple long-standing issues with MGLRU metrics, and drops one
> page flag.

Great, I'll add this to mm-new and shall move it into mm-unstable
(hence linux-next) promptly.

I tested v4 quite hard last week and I view the risk of breaking
linux-next to be low.

> The series has been tested on multiple platforms (desktop, large server,
> Android phone, x86_64 and arm64 VM boxes) covering many typical benchmarks,
> databases and real applications, so far everything looks nice, with good
> test reports from other individual testers too.
> 
> Different workloads may get a flat, minor or dramatic improvement, the
> gain here is mostly from real improvement of LRU's ability to distinguish
> the hotter workingset.

Well, the hunt is on to find something which got slower.  No luck so far!

> - Minor optimization for clearing refs:
>  https://lore.kernel.org/all/CAMgjq7Dd=Y+GekSD9WO5oGdoa+S1eG3T-U=VsCexopvb723zFA@mail.gmail.com/

Right.  That was the only question mark I could find and it sounds like
you erased that one.


