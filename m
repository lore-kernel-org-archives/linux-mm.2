Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51F93C4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 17:32:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E48A6B00B6; Tue, 14 Jul 2026 13:32:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BBBF6B00B9; Tue, 14 Jul 2026 13:32:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AD8E6B00CE; Tue, 14 Jul 2026 13:32:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2703A6B00B6
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:32:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B30D21A042A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:32:00 +0000 (UTC)
X-FDA: 84988075200.08.B015FD2
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2B6D74000B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:31:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="PyOnH/eB";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf07.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784050318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EED+JsuEN1JGI38A9kwy6+zQnMSj5RwByViCEvcfIxI=;
	b=n7HdjNuATuDPpHcP2efnQabz9xb1ixcnmJudEcgWESRaS+CKEsPBB2y0oL0s27zUQrjNeB
	BDjqpa+LQmuVRIWO1Y4XCq6pshwTQTsVfgshO1BGXeoq6+CKWlQMZswQ0c3Rfg1Uou5tsp
	knyH9qUnC3ZX0nprnYOZrds+1CI/xKc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="PyOnH/eB";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf07.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784050318;
	b=8o3dxtUeNajzr10ApFxQ+oBZA08kmWIO0rDkZAudXGvOsetgagl7JFiEmRjOnJkM56/eEW
	6hKdXaG1AbjMwR3OB1Qql0QUoP8sf0i/EhXs/C8tvem//MUX0T+qsNo2LlpfFP4xWYowaP
	qibnK5YvEUpVdtCdRvaePhGCPCmpIN8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784050318; x=1815586318;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=s6g0qpuKqxGTnfu11FpV5HyC4k/FYmzxINNYeN67niA=;
  b=PyOnH/eBjKOb6JgWSl3f/dkhzLeIR8ro/r66D+6TJgoIohw8MzkhxDwG
   WL7d3Bj2rB/gyN5lNyY0FrLE8oQ7rId+rPdlLZ5huuqqp5HbViqVrLoau
   jcBes/5Q9XGUaij7QgVOdEKzZQ/yNsn2Qrv1uNUFM5rIwf2SboGWDxo/R
   DCfhRPEoq1+rMK8CWaDrI4tFfxkQD7Kv/Jj5rvpKOYOALJZKj3+smqiMl
   Q8hTqmKZGGsQIPsGSD5BVPDrg6t+W0RxtpK5P3wAmGiN3mDp0W5SuhF6a
   UaCWzO2RvPr+G32R0OGgIgi0zL12d/xgluxSeZNVJb/RHNHU0+Da87i2r
   w==;
X-CSE-ConnectionGUID: zCdV+q14R8+ZN4kuGbm1Xg==
X-CSE-MsgGUID: q+D/MO9jShmSzbhkwOGOwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="84463282"
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="84463282"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 10:31:51 -0700
X-CSE-ConnectionGUID: 8IQBNJerQKGX6bgmgii7KA==
X-CSE-MsgGUID: RDwDNHbdSNWIo/GfdPUBTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="259498483"
Received: from aschende-mobl.amr.corp.intel.com (HELO [10.125.108.120]) ([10.125.108.120])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 10:31:48 -0700
Message-ID: <e2d9f516-2dae-4356-830a-14b99fd32a90@intel.com>
Date: Tue, 14 Jul 2026 10:31:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-hotfixes v3 0/4] mm: fix UAF caused by race between
 ptdump and vmap pgtable freeing
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Ryan Roberts <ryan.roberts@arm.com>
Cc: David Carlier <devnexen@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
 syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
References: <20260714-series-vmap-race-fix-v3-0-b812eccfa0f9@kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260714-series-vmap-race-fix-v3-0-b812eccfa0f9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9gqdh5n1q6grnihziwwic1geonm9pw1e
X-Rspamd-Queue-Id: 2B6D74000B
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784050317-462632
X-HE-Meta: U2FsdGVkX19gTT+qfKFyfJltMKVTUGfH3kCxdHScCZIKybswmsIHTc8JDyUjMAkrRBM1BNEOsFPSU+UgOB3lKYmgPyjVwjQptGPAw8VBfLK4euHhFPIdNVn3umGdutT3hiixWrN6BgdclmOGJI41fwL0qVjFpATe0qBwpIpxouZ1C8+Y56TX5nWdFVAghhnI/BE3fKsTxGZiADM31OwYpEKlp1kM8FTyTxV1KxoXWSrNjJM0kkXbnsuGRaTAetBxDAeGExUTcaPlb7bWA49m1sNaO4nMyVmQHp7tsftXJ8U1TCfzpvSwFQLu3Gh0SG93IxMrX9raa0UwJouUvHUU7i06KhZQxIg1dnfCIbC7iuajgU5s4ZzhlzTuPwQXpkHA55Aj+0VOPChX3glOStm2hGQyovhf90eRBpqX1N/ArbLQpiyeMloVEDsJ20hN3W/4RMBvVvRGgZOZmDEMjgy+S5WwpOLv0lkKfrYFhQpkiB/wqk+jQyOOKZOTB2JPFMcWObyjGrQ7LU1BsPGxDTiIsWi7WNpS2RQofgzyVzKPUe1EZ7IJ901PZWKg+/p9mBIDFcbwLsqGAqvb+d2Qv0vboGbVFEWX9aFooUGN3nW/cFb5tqpurCAQP0d7rTMN2ousve+cOPMJ152KHLQPyMKFaZOtbQLd+fgCSxTMlLk0eGSLLSqGIfX/SojuiblAmKM9xPdNYoZDTjC6BGeOtV9wyJ9mgW/TolzMRY5a1A9vX38KlcEkiiA0wF4/hfsQkfK2ZiKxOsD635Mh4n/HMgr5GbyJhxM/SCUFSwga3huygmgvNZ4Rw2nIwr57ZchN5l4GFLm/n4K143CNnwh1I7RqvC1tNT7UDcxrgxYMxsMt4HQ8iueusjbvtC0+/lxqgy/S/OJSGVrtprke0LPH0d99+sab4luZk2whWiBmhMM+hJScK/Rs7yfWkkkV98wmozrBniu8g8OtUCHzVf4xYro
 5GGWKQv9
 Tpo3xkp6FbVRHERVlEnTboFJKJD6o+S1kSSGVsR/b64KuR1znO93xT1QtV8fSqfwFXORcqRlnoLpCuZ9qsr3n8XYIYU5uQvlGSOwPufsJ6t5IStEb1BuH+Hpg/nQJ2V9I8jcKy2zct73TxMfSayKKw7TwXb9WEHWBmIf0538fDYKaEWVCIOnopLcqpGQjFbQg4js7rXxItENDz0dxJ+aL8nSncHmqnlu85MGf6hB04eamDiULxXN7pnD+pfV4loLtALZFKB0K9nbtoN+mZj9BhPdMxKer1w3pSwR/2Bn+4A//SoLkmWjJ8mJTGa6UmjfYBZdGI/QB9SxcroHCMgd+rdA9zg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/14/26 10:24, Lorenzo Stoakes wrote:
>  arch/arm64/include/asm/ptdump.h |  2 --
>  arch/arm64/mm/mmu.c             | 43 ++++-------------------------------------
>  arch/arm64/mm/ptdump.c          | 11 ++---------
>  arch/x86/mm/pat/set_memory.c    | 14 +++++++++++---
>  include/linux/mmap_lock.h       |  1 +
>  mm/pagewalk.c                   | 36 ++++++++++++++++++++--------------
>  mm/ptdump.c                     |  7 +++++++
>  mm/vmalloc.c                    | 41 ++++++++++++++++++++++++++++++---------
>  8 files changed, 78 insertions(+), 77 deletions(-)

BTW, this is super nice. It fixes a bug, makes the architectures more
consistent, and is effectively neutral on lines-of-code.

Very cool.

