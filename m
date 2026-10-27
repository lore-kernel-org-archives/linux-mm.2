Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4EB8606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 05:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=kNmMr3X8
Received: by kanga.kvack.org (Postfix)
	id 9FBEA6B05B8; Tue, 27 Oct 2026 01:15:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AD226B05B9; Tue, 27 Oct 2026 01:15:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E9596B05BB; Tue, 27 Oct 2026 01:15:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A08B6B05B8
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 01:15:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1DA0F1404EF
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:15:22 +0000 (UTC)
X-FDA: 85367242884.27.728881E
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf29.hostedemail.com (Postfix) with ESMTP id A23DF120006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:15:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=kNmMr3X8;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf29.hostedemail.com: domain of liuxiang.277@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=liuxiang.277@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793078120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lmwmgtsLJLmyIO6l45opT4PyLPoNsYcCr/gU7hyAYOc=;
	b=jusVV1KWEZxqk3Keoh/JFsIPD/qlKbURxwTyDHZ/fvYIFhwVsFU15Q+1TzN/uzrLbQL6Gs
	kiWhUYTVa76+hEURUqkY0wrYi5AniVhMUVklLDRPELykp3ft89ZplODWn9RYYlnxpr9VMO
	J8d3H/ILJL4rRpkm7FGfiAts5fB8YCk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=kNmMr3X8;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf29.hostedemail.com: domain of liuxiang.277@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=liuxiang.277@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793078120;
	b=OFRQqWAdHem11C0iTRaEZYGXRo47ij9v2JiqfEEgAKrWA7nzixrJ1M79L1+yOLJuGzZEEq
	FsjuDZ0USF1xIAupPMMqT+cayo20sz/MW9rqvz/hli+nQbAvKR6zSdBMZfS6yKbzAtlZXL
	k109T7H4Gp/sQgfHxIP/ofrh9idxRj8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793078108; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=lmwmgtsLJLmyIO6l45opT4PyLPoNsYcCr/gU7hyAYOc=;
 b=kNmMr3X87SqE7/qiysWxUXdpWFmnQuVFIugyX90l7z1Iolh1lolPYOQPa7ItNDpwwgMsV6
 3LNGHjpiKVRZfWAbdnr+9NpDIInEwYwqla0mdzq8zfxZGyqiJaP2JuxLHKmSS7gvHKaP+Q
 1ZvvWK+JJgu/oqibqkunCXhqlk6g4jADO/Y+CarHEUd2svmfm8fEvHwY4dKXCQqom/b/fc
 rrxcaqs1Il6NPVljYgPA2pS24vsEogUyxZw2sFbFlM+lnvezvrG4fJqFwdzrIWwavnCPwj
 gsfD1SYKmy5vbzdJjForx4KqBgt5wMeXuQObqzRTPkmtzZgZhL/wCTDut3BFIw==
Cc: "Andrew Morton" <akpm@linux-foundation.org>, 
	"Johannes Weiner" <hannes@cmpxchg.org>, 
	"David Hildenbrand" <david@kernel.org>, 
	"Michal Hocko" <mhocko@kernel.org>, "Qi Zheng" <qi.zheng@linux.dev>, 
	"Shakeel Butt" <shakeel.butt@linux.dev>, 
	"Lorenzo Stoakes" <ljs@kernel.org>, "Kairui Song" <kasong@tencent.com>, 
	"Axel Rasmussen" <axelrasmussen@google.com>, 
	"Yuanchu Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, 
	"Baoquan He" <baoquan.he@linux.dev>, <linux-mm@kvack.org>, 
	<linux-kernel@vger.kernel.org>, "Bo Zhang" <zhangbo56@xiaomi.com>
Message-Id: <179307231985.76444.4463824301717648100.noio-rfc-v2-coordination@bytedance.com>
Content-Transfer-Encoding: 7bit
In-Reply-To: <CAGsJ_4xVR53NcKuN3bA6v+O=37PeQ2Vnj-8WHo6ScYH96N4seA@mail.gmail.com>
From: "Xiang Liu" <liuxiang.277@bytedance.com>
Subject: Re: [RFC PATCH v2] mm: vmscan: avoid anon scanning for GFP_NOIO with low swapcache in MGLRU
References: <179248830836.1744016.8424217811286616919.noio-mglru-rfc-v2@bytedance.com> <0cbd219d-f69d-4f72-aec5-43e1f2d978de@linux.alibaba.com> <20261022102726.56682-1-baohua@kernel.org> <fc302ca3-6bf6-4bde-b3e8-8d2e93a4e4ac@linux.alibaba.com> <CAGsJ_4z9GZkpV+mpoGogma4oSX4cHy+2UDzyUQSjjOLOfekEPg@mail.gmail.com> <4e647816-0b8b-4a75-8777-8580a574d752@linux.alibaba.com> <CAGsJ_4xVR53NcKuN3bA6v+O=37PeQ2Vnj-8WHo6ScYH96N4seA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
X-Mailer: git-send-email 2.20.1
To: "Barry Song" <baohua@kernel.org>, 
	"Baolin Wang" <baolin.wang@linux.alibaba.com>
Date: Tue, 27 Oct 2026 13:14:50 +0800
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Original-From: Xiang Liu <liuxiang.277@bytedance.com>
X-Lms-Return-Path: <lba+26ae0335a+74fd5b+kvack.org+liuxiang.277@bytedance.com>
X-Rspamd-Queue-Id: A23DF120006
X-Stat-Signature: xao8dq73itiahg5ancihnpe9j8dxuq9t
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793078119-597288
X-HE-Meta: U2FsdGVkX18opC3naOLQukH7Hfe9MoabfINSdW7AOyCuqZGMjah/YrCm9gtnTLyuxSKozhuFWvExsPd1L1yO+k7G0BqNMxMbnC1yRZUxMFPEAjxqEKUNruVLviqOFhB2HW3MdaI0U25zWoM8pXMvxMjaEZMuccWD3LEbAvPcdK1jDGz6w+hziIoMdAla0w0B/Z8CzaMWZdVbxpPscCkC8odHZejibTSCU4G+y+XxZPhke/H/mwKZV0kZiQS5PTs6ISLREjQcqqQ1OItnejOA16NAZx9pWI5YedGsM8gPQiYUlhMQjehtuXCgAmHHGAJIqJo9x56Vo5DfutgvvSuCmhJc9Wi/UEdKFHKyJpJTdvk1l8x1YT6qz3svV/0I9KNnoUBXpqEQZKJnz/IrrJUwwG6z6SN9yDAZ9LVfFcXkl3UA0I4xyoOeaIdwMqe362o1kJ2avdzh2YxD/vkm5dUVj1/hcN6A9S908lF6iu6nrMfLS+TlTlwBLoq/oBVtKeEe/vJ753efkjfPiVLY7TL9GWsmGlI7yGCdnujKES6I+Acg9+EBkg6GyyTvnCMVkHBGqM5131mS7RMhHrpOt+kcQ7PNZMnavdv2zE5efPr+xg8T7lgaCJl7On3JnIPWnNyNMQ6l1pZRk2D8VVlyaJVwg8CEVCwBfVJW8xikkjZt35/mD7UMobe6F2OyiJCaaT2LMuzf6hmnVvdc8gckTnFPDOrhiN4xqu3C9tK33MiJ1BF084DmiY2lwVXLfq6xKtG6ueZYbku/+VTlj3DMsg/QrU5KglzFUvFLoZEa+gyk1YGq80RdA1PJFIcANSBVX2EEh6qcEYcINhO45YU3CeO+ZbhdEHruMziiabJ0eBAlV4g+pCtTUdREGjwMR1ByMMlBNn5Vu3GNeMANXvwb8PQviZhrBDLJ+xp30pYu9TKZSqx/at1hdF4ZLMUgayyQCkC9ahiVIZop6QlHFnVSIPU
 pvwA69KV
 qcMBJRCGLA4jJl2gSKWo9+12/e0Hw+y8FlXj0MUK3WSoFOBpnyiSTo4bgah7xnXkPKeyM91sPR/u5I9UTnFygtYvwh65HO77rRNLXeZAA/DbsAJiqtAGC8wdI7n2YjrOutCf+eYyWNpZOjT40bTR0Z743iDsxujtz/NE6Zg+90gWlU4slp9oZUr4sdY9RyB+eLLSvWAX+qJ5bv0ZfKz3TYjKHMnRIYIRmqM6wblsk+4L0itw9pA3+e0Hqm+Wr5qtyfG/3HDIiyjYRQ1kPHPBpoWMzXnXxsi8dlV9y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Barry, Baolin,

Thanks for the review and discussion.

I've seen the RFC v5 "mm: mglru: fix swappiness behavior" series, where
Bo's patch 14/14 addresses the same GFP_NOIO issue on top of the new
scan-budget model.

Baolin wrote on Oct 21:
> IMO, 'swappiness' and 'scan_swappiness' are really confusing.

For a standalone v3, I plan to rename scan_swappiness to
evict_swappiness to make its role clearer, keeping the rest of the v2
implementation unchanged. The split in v2 preserves the original policy
for anon aging, including the page-table walk.

Barry wrote on Oct 22:
> IMHO, this is confusing but this is a possible way to fix it before we
> land something [...]

Before preparing a v3, would a standalone fix against the current MGLRU
code still be useful as an interim fix before the scan-budget series
lands?

Or would you prefer to handle this issue through the new series? In that
case, I can use my GFP_NOIO workload to help test Bo's patch 14/14.

Thanks,
Xiang

