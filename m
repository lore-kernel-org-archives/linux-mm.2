Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 694BB606A326
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 10:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=oLB06oPt
Received: by kanga.kvack.org (Postfix)
	id 69C646B00EF; Sat, 31 Oct 2026 06:13:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 673FE6B05B1; Sat, 31 Oct 2026 06:13:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 589816B05B2; Sat, 31 Oct 2026 06:13:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2DA3B6B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 06:13:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B5FDAA0915
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 10:12:59 +0000 (UTC)
X-FDA: 85382508078.27.FA252E4
Received: from mta0.migadu.com (out-85.mta0.migadu.com [91.218.175.85])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8AAE9C0003
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 10:12:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oLB06oPt;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.85 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793441578;
	b=VGbik7EJEsOgIGGNmZxMY50q6ErD3j/82MyTNdaZKLst/R40KX8saDYr9C2lHa2qLFAv2E
	DQ9Il1sSu7xzb+Whd1TjgY+29RQfmnWgifbVsXz29vWYundG6ec3kHqfz1Sx2KLz8wA6tM
	xJY44LFmsTc01oqab6dwyr4XhBqAoMU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793441578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dDCOuaNWdFHWDg4eo0if1LTvwbtTxO+pnWs7/GHeHF8=;
	b=bMM34GfEdLaIXACJvR3ERZdWpcdgUrcD/E2jgkCnU/xdjUmRqUrSojRZKpeNWKa78Cde8c
	Vl24+6CurI4hpzK1nilaIJZYMEossmlj4HO5RdOp/2rt1cu0c/9IZJCHz7s+Pw/mj/giJe
	fEULlavcTGGL2jjcGi+hghmJ05P5Fok=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oLB06oPt;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.85 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lZTmGrotgsDGI65tFXKRdBILlZ1ISbBZpIj7+K9DZDI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793441574; v=1; x=1794046374;
 b=oLB06oPtTuGAdIRr8hXKWIyuAE/VFfRZ2aSmX+nn2L9fhl77u8r1uFIBARMhGEesrc4oTcLk
 Ny18QOASskvHzGJGUQU9J9Xr62mA/lMG67loRk4XIPBfwTHygeyAP57pQtg+X9uScl77eSjNhc9
 ynBvjhd1WXGHSz4P5Yf3JqXA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 3800c739b860db0f;
	Sat, 31 Oct 2026 10:12:54 +0000
X-Mizu-Trace-ID: 3800c739b860db0f
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v5 4/6] mm/vmscan: pass scan_control to the vmscan
 tracepoints
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261031090041.58574-5-ridong.chen@linux.dev>
Date: Sat, 31 Oct 2026 18:12:27 +0800
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Dave Chinner <david@fromorbit.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Qi Zheng <qi.zheng@linux.dev>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	bpf@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>,
	"open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_) <bpf"@vger.kernel.org (ope>)
Content-Transfer-Encoding: 7bit
Message-Id: <DBDE2024-5586-4938-A8A5-B6247E2B2BF2@linux.dev>
References: <20261031090041.58574-1-ridong.chen@linux.dev>
 <20261031090041.58574-5-ridong.chen@linux.dev>
To: Ridong Chen <ridong.chen@linux.dev>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Stat-Signature: sx4f63f11wkjpbtjaidckmii9uuai1dk
X-Rspamd-Queue-Id: 8AAE9C0003
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793441577-62282
X-HE-Meta: U2FsdGVkX18KTHE9Z5a4TawJ+oXA7F4DGjXSPsH8ygfImPlk3uQwL1wnZsYPGJnS5w9kS+icIlYtDGzqYZ+Adb8xfA+8N/rG64d7NNU/MVkNhOq+GBTYgxfjjA99GzLUEh2dpnWO1laqUYdtVWUijcBbA+0rIpz3q3zaAS3//Q3oxJ6FhrB0mk3EI8KG6xHFYzIvXPs8hdjzjyZMr+jd00azMyXmqbdTcpDBUSw6Pm9GrU2YYjYwKCMQKbV+LMVaC22gsdfjvy1FoLYJ3U3qRT9fptKdYfija2fcZAqcj7K4BF7DnTy708OEXCGn2urP1P5xKa6J0IAW67yij52rC1YnaFCzqEwF6RoisPC4g9VH6mFsP3mxaev+FxZUEjeo1iaQZKzdD7g0g5MQMaREjICKUfI8GdEf4eVkszkaK3b0prhFFWxFAoJbulPJx0cX2IWo9QOYXW42GUH77mOaljrprA1vDYAxw4Vaa5+cIGR4JJy7Y33U7lt3LGO5cXItGG8U+lt5WGEe3c0d7GCyPkgw8OH9qK+/lQYzElhW4Gj4WuITrGMzNXv8mNwtNS7exumbgUPYvxvfWrGJ/fVqBPzf86D+2bkUu3iOMv04iR/RuEedduhwPXFgTbur3CybY23H9o72fr09VHi2i7bV8FSpJyXCsQcp4Hq4ToC8PPbnbXiCVasplBJCWyj0RK0D/mKpsXoORm23bZcAmLZD0FDFmZN2yC42ZKAXAMB2tFLLgkxoRGyVJ9w4CDmNMS6T9P/yXyCyrziqZIsziYXI+Q9zJ0zJZXz1Rd7FZbgPsyIkkKbkwXZ33+K1W0huKpWDpHG6RNwjv2mMwFvO1OAiiG4S84zqzn4mRx6dSnrnSAdYp7C/tIR+Is6fi1Y7ewovgyNQbdW/RMladTUsSrtUFVnDgvIiFbkF9kiCIsdBvO6uJ/vQe0d3UlMRRZ0wDmxZzLPHL8dmn2eL+Xj0G0Y
 T5/k1ma5
 iTdJKwGzIsiWwv2ujz6Y9aKuXW0xWOO9RoxB+OhK1pUK5KFoPFDeiX9bhzH3USdR1G9hgkHVVY6NVlryS1ZZxXtZEuoocIalQo7lUYGVu8yE0JL0Ynk1BxokWitRhQTDo05wh/uyeJ9H8tZPM6xOi0WvN3mnBdkkgi5yGoY1L5Lrl9ph74gekQKvoqmVFM0edY/Je1F5+L5k1bpYzSdWXIXjcqVe95wQdmvVCZ1yTRDsuXbA50aX2xQgaZrbI0Joq+VkjDh70aHa/ju3x3pnxh1wicwg9D15/JAOKtcIoAWLR3NYE697gujJ7RYPdNjOJJ4WKrHXFlzqorIDhBCjhGnJEPLmKGZmqN+tcQIZi6Lj3a1T/GB1mCTKWJOUFdgoZ3Ok3P1z5FyUeDoJPOVkpcJC8NPz1DMHoqa/8iJ3DDZUrHasuCh/t4KqYNlytvtU/w7Z16R2Fbk2Ymc/VM1WItZT6kkoQPC0qoAJq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 31, 2026, at 17:00, Ridong Chen <ridong.chen@linux.dev> wrote:
> 
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> Several vmscan tracepoints spell out reclaim state as individual
> arguments, all of which the caller already holds in struct scan_control.
> Now that the struct is visible from the trace header, pass sc directly
> and pick the fields out in TP_fast_assign instead of spelling them out
> at every callsite:
> 
> - mm_vmscan_direct_reclaim_begin, mm_vmscan_memcg_reclaim_begin and
>  mm_vmscan_node_reclaim_begin: gfp_mask and order.
> 
> - mm_vmscan_lru_isolate, mm_vmscan_lru_shrink_inactive and
>  mm_vmscan_lru_shrink_active: reclaim_idx, order and priority.
> 
> - mm_vmscan_reclaim_pages: nr_scanned. nr_reclaimed stays a separate
>  argument: it is the return value of shrink_folio_list(), which does
>  not update sc->nr_reclaimed.
> 
> - mm_vmscan_balance_pgdat_end: order and nr_reclaimed. highest_zoneidx
>  stays a separate argument: it is a balance_pgdat() parameter, and
>  sc.reclaim_idx may differ from it by the time the end event fires.
> 
> No functional change. The tracefs event format (TP_STRUCT__entry and
> TP_printk) is unchanged, so tracefs-based consumers are unaffected.
> BPF programs attached via raw_tp/tp_btf see the new TP_PROTO and need
> to be adjusted; tracepoints are not a stable ABI (see
> Documentation/bpf/bpf_design_QA.rst).
> 
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks


