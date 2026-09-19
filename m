Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7646FC982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 14:07:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 662286B0088; Sat, 19 Sep 2026 10:07:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6393C6B0093; Sat, 19 Sep 2026 10:07:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54EBA6B0096; Sat, 19 Sep 2026 10:07:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A5B26B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 10:07:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AD232A4101
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 14:07:43 +0000 (UTC)
X-FDA: 85230690006.28.0B3B32A
Received: from mta0.migadu.com (out-65.mta0.migadu.com [91.218.175.65])
	by imf15.hostedemail.com (Postfix) with ESMTP id 95B1DA0006
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 14:07:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mqt6FUuX;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.65 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789826861;
	b=JhudWmI3AGBOfK4nncMcCqVCbpcxSI5+x68AkzB97iIoVGs9crNCOHJ2l99NwfAsNGgnDU
	smmW2mhb3mWOp4QAK7gH5WmiNfcNAgXI8PbtyKLj7Zh7OFXnnwC8xfUgD5xKDXpAV/TdNE
	6VVqd7k+pXJl+qhkzfDtEKGn7WbDVqA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mqt6FUuX;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.65 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789826861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1RJtSmGkDzOhRF7zExD6eG4nMnJW5Es9Ic7XyY94Oj4=;
	b=TZBEZKk0MruJaLlg2RnygLYlxvnlQjI2JC3/9cn3WI3AXoa/zvDuFrNNC9y07ZtiyH6gUw
	Pf7cVzbLiWJtXX7KqKLc0Og4p3SA9jfnBbB8TLRVSXUd7BijIZOb126E+zpROxXNM+wT0w
	LQNmh7OmopDBrrA5VbL3UV6T+JbQzrA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1RJtSmGkDzOhRF7zExD6eG4nMnJW5Es9Ic7XyY94Oj4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789826860; v=1; x=1790431660;
 b=mqt6FUuXMFr5TEmLd/Q/Yc7UnGrkFFt7cnv558YaEsU6Vh8n7PyA8OR+ru3pS1o5JvD957Yk
 +b3PDUY6awRtFAZWYIo+vVXFm5eURkdXn6ow9TQg96V92kPVGoWdAUTtvB9B3qysIv8E+t14uye
 rg662j5uUpj680cmtR7g5Ql4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id b0b09ee52edac098;
	Sat, 19 Sep 2026 14:07:40 +0000
X-Mizu-Trace-ID: b0b09ee52edac098
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 1/6] mm/sparse-vmemmap: drop VMEMMAP_POPULATE_DAX
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <186ee2ba-daf3-4120-a3e3-101cac1ff5a1@linux.dev>
Date: Sat, 19 Sep 2026 22:07:19 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <4AA6C66B-0FD8-49F3-8447-959A3E438FC2@linux.dev>
References: <20260913083734.86802-1-songmuchun@bytedance.com>
 <20260913083734.86802-2-songmuchun@bytedance.com>
 <186ee2ba-daf3-4120-a3e3-101cac1ff5a1@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 95B1DA0006
X-Rspam-User: 
X-Stat-Signature: o5zcgsyq38k7tzg7swwytb1iems5u38j
X-HE-Tag: 1789826861-772125
X-HE-Meta: U2FsdGVkX1/uaJX13rh3sMDbg3akcQ0r/uF7X4fdR7XoXIfzPODNWwmDxRNBCuwS245kbRNIDS1aOXKV79RRwst5TW8UYzAyBiB55bzUwyLoBsztq3l8UOEUKNnjxzYFqwbNIkuPexiDEoRQS0BQR+MsYEo5PJT+8JgAFO6EMClxqLimKFz1w+HNECh8U94AnzCPO3H6gSZdiX07jaYZC5hGcdihYJVGBu/W/GeGcT+eH/VqBMleaT9vQlaU66CVW4Vr5QGqetHYB1g5PbvK5biLSmLqowYNOxIObX0Y6adiwgmZhVEoxJP4SJiEo+fpQC4r21oIVmCHQCa8io+hyuBgqVndD9MCt5552fj+O1b5omBxql/G/rXizBi+cEoDgK0juHHhzGtB24u5smMep+bxwSqevVr5vxzF4t9Hbq1QUZQFCYQf4KGwTUHn+eBWo8djzIIbUk93ooWzYhMGgVi2CM6T0tH82TY1Yj5r2ENcLXVmuChTcWzWBKBTOobFMGvY1DoCWhNjkl8Y7DIcm85MCA0R8qVUb1wueL5EthbSq0VU+AALzzG/GDgzG2gbop3u821mlT7XgPWRLmO70JYhEXlCtOF6GZ1yut/NTXwoXUAuk96rdh6no4nl4/08VS0EynsiWpj1lDu/uLnpz04gi1exTDxaU5Ou6IJYYgPqUqr5SZPbdROus52lsfxxXc5PM0V7JShr9Ro+2QU61GkMlHse33jhQhh5QzJAxuTDli8ERYhF+Gf5zqCV2F1DnMQaGm6114Et9qsyeQBcRHli+h/gi0BdjJt3IIpj8om3FVZZ+iqpaKJV2CUn38Wmkl0gcD/x3ygFomZzlP5lSJqvvZq9jBoBHS3U9Ybn2Aqp5O2pgSmYe171eX/Q4SoACU/kTcxyW2KPiSrte/NJKrCBugUhfoKLMoFIl0EQqoUtDXmHDRGJaR9Ngc/UX+zI9S0+QSKyMc0JuG6ATLi
 Io6Vij8/
 8iYxCLL3JamN7GT/yLxM0OGn+CuZf+01shRbzlb9LVy7RQTY8K5ErzenK8IwPaozQUSHkgmXfQ6nvwYRBK2jb7IbU/DJeFSQKUyEk4lwuNHQiNJLUYUqvSProag5APLrUdMa+98MVB0aLTvHsz3yzgI+3xNdc0uRmAWwMnnR+ZGcKuAgNxdgiq/4pkeM5wTV6HcP5saW9WE0+5ORCqtJHa4Oi5uLC01J6ci+3gVStNcFCYfJyEEWuwC+ZViFfBCa+3vwA1yiWId1kBJgSzywR64gwbUN7UBOAGa0+xV3UETiLhR8uMfau8XwU6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 19, 2026, at 22:01, Qi Zheng <qi.zheng@linux.dev> wrote:
> On 9/13/26 4:37 PM, Muchun Song wrote:
>> VMEMMAP_POPULATE_DAX currently distinguishes DAX vmemmap population =
in two
>> places: it keeps allocations on the normal path and takes a reference =
when
>> a backing page is supplied for reuse.
>> After Device DAX switched to the common per-zone shared tail page, =
both
>> conditions can be determined locally. DAX supplies ptpfn for every =
shared
>> tail mapping and requests an allocation only for compound head =
mappings,
>> whose PFNs are not optimizable. Therefore, vmemmap_optimizable_pfn() =
alone
>> selects the correct allocation path.
>> When ptpfn is supplied, the caller is reusing an existing backing =
page.
>> Once the slab allocator is available, take a reference for each =
reused
>=20
> Does the availability of slab mean the buddy allocator is already =
being
> used? Could there be a window where the buddy allocator is functional
> but slab hasn't become available yet?

Yes, because the slab allocator is based on buddy allocator. But I want =
to know
what's your concern here?=

