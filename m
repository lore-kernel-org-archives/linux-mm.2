Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 969B1606A324
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 00:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=cyqyhyGl
Received: by kanga.kvack.org (Postfix)
	id AA8726B00EF; Fri, 30 Oct 2026 20:48:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7FCB6B05B1; Fri, 30 Oct 2026 20:48:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 996206B05BC; Fri, 30 Oct 2026 20:48:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 787E26B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 20:48:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EFF311A0908
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:48:41 +0000 (UTC)
X-FDA: 85381086042.14.5842BD8
Received: from mta1.migadu.com (out-95.mta1.migadu.com [95.215.58.95])
	by imf11.hostedemail.com (Postfix) with ESMTP id EB98840002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:48:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cyqyhyGl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.95 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793407720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HU/ADiEQ4yElXdERdWH8C62mg8dV+VZgpatRQy1+Ol0=;
	b=SXZrPMNOrlzCR/z8iTtIbdVM3yI8wZLDm2ZDclDhzfwyCtucyPWYp1sZ4KcX9Sb2ASLAgl
	xe0KP5RN4ywRGueMIbM4wB/1vxl2EYLnEfj64GguJRi3P76LGLpTYjmAB4+TrDX8tzZ1i4
	UtRzGWRSiZTninB3vE1C0D8yKymNSRY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cyqyhyGl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.95 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793407720;
	b=GzDI0g6pNpQdaGfldApwPSbfPZhuTiZ/jLI1HeKqasKLBz2OFzUfwvOCeDhAmimyE82PK6
	bBL68hNODhFXlq7f4AOJ74ezSFILusYEss/FTIvc1vv9w35+gaoj2jrVKP4///23VlkMVM
	+sIqQRsc+CKjch5QpFWYowV+N+F7TuY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=FL3rfgpnw9CP8lcTq4Q038BNConm9rfhH/vECDAX41Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793407718; v=1; x=1794012518;
 b=cyqyhyGlFMgmCD/YaWRr8xXEVNHxuVgYODv04hI98i88AwsTpkvxphUlhrBCbj53L71/NPsa
 wgwuTjOfT8zJW+6ozKaYGiI70xyjDpufl+HoJtKo1i6lsAfJUkx+Coh7I+E5odRCpNgivaahyyL
 /mO0xmm94u82XLPcNGSeUH5I=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 8d4b375cdaecd94c;
	Sat, 31 Oct 2026 00:48:38 +0000
X-Mizu-Trace-ID: 8d4b375cdaecd94c
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v2 4/5] memcg: use high_work for remote charges
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261030205418.341214-5-shakeel.butt@linux.dev>
Date: Sat, 31 Oct 2026 08:48:21 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Tejun Heo <tj@kernel.org>,
 Harry Yoo <harry@kernel.org>,
 Meta kernel team <kernel-team@meta.com>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Michal Hocko <mhocko@suse.com>
Content-Transfer-Encoding: 7bit
Message-Id: <C6F1CC60-B4EC-4C83-BF03-61577CF4A0F4@linux.dev>
References: <20261030205418.341214-1-shakeel.butt@linux.dev>
 <20261030205418.341214-5-shakeel.butt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Queue-Id: EB98840002
X-Stat-Signature: oktnhphxzb6oz5xr9m84ibgdnruduztd
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793407719-477596
X-HE-Meta: U2FsdGVkX19/BmQ9oEbr1PmEYIlWHeG35cwLCmob1n1Q3Md6K+YoszPkhgoEqFULH8haHDLxh8kKvpHc4HZuJLEvrer4IaeXBXPYNXqP+wHTfPo8le/TW3uPm+iR4k9opAlLGU5lCI8MIBdTxCT+MTM+gnE8HhtHK6kE5mxtQZgJu2EruyX/Xb+aqOjmleUk5rrCRsgK7ssGeTabuPnDm8AsIVsybqe/rvJ4hGeIHV2jgQL/ZGizvDKHSxa8BH+l9/P1XBUAT+0gv/Tr4oUwpWM/e6dTf0o2zhry8j2GSHyI5neC9aIe4MEW7O2j5Y5dEkwOEPCE+PrUcGwPAQ3Y7owepADJnRc5qyoJPFa0kenD/pSjXSMYV3r2cwq54G6lppVCzzgMXU/W3rRMgD63UXu518Z+kEdWvkfwTFK9U24K3yC+8fD84F+eAJNS1Rd9bknaPCHo19wdnn88xp1SK1WJit4BL+8qsCkycLYgMw1W9fGXfLDTJVkjQFFLPJJ9EllrWuOrzoLW7z6I3oHR0I4xVKRM5uwjcHiXJtSoJ423Qn6rPAB8awOh4sKxJ7HjryWHN0gxicSM0ykiu0ovmM0TzwkaoITU4Klep7b5B6cmwrYobI5soBApOQ6TVkJAOcELoZKi7YkY1eOj+/dYYC6TgyG0J4r5gZOcRaZir6ItT+nEpvclMDyJcJrz7qmOGGlYbX6ROD7JV1P7xTFfiWaHCajq4RCgjDX3He1E7lPohdJ0UuWScMkHVH46kwzYtJx5Z87XaD6Xek9doxQrvvZ3NhfN594sA0VIgnOb5OvocWUMVJ3yFKZEhWhzDDWXoMsVPv04+VDzmJQxSFmLJtVUKO/0z+aNp6XHc89QuXJ6dhspVXOXBR3w5r6pItUHYCG6KWTjJCCIFclF1odxaTWz0Hb5j99JnCe/cfNqOpwUsEnfhP5DTFnuiRnchmRQ+3ndFOCALyNVntWL6Y/
 B5GkS9fT
 FcpLTTXjBFr4Zo8aV/p8DWp5onQ9KC/bmIhqf732EvT6R6hHp9Cg+Fza2DBBIRkwkGWEPSh8M4uAC+ueYZXBcptzSYpARPu75cRbB+7ieudrw168eF0gQQoRlyqYyrntmr3sv58JrMUdEm9Qy3iYIXh0ACrTx+l+TiecJEpyG2MnKFgptHcjEzFFaISTBJ/at+skYXqAWIhafi8rrVZIOWdZpFZ+1G3FTkXjzN6DO/Eryquad7oZ2YnXrW7CxApfv77vRBTaZj6OnW4kU5dqtG9zT+d8r2f3yIX0VkOdnOBRK/hil+BoPeJSqdhLUM6psur+/5S0jDEglExvQktz9RWRgM+QrwmRQqqXnzdhbPufYWQcqDU49OjLvyxkJ/g9o/eYt6o0f2a9M+XE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 31, 2026, at 04:54, Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> Some charges go to a cgroup outside the current mm's cgroup and its
> ancestors. The high handler uses current->mm, so it cannot handle these
> overages. Filesystem notifications and remote page faults can take
> this path.
> 
> Use mm_match_cgroup() before checking the high limits. If it does not
> match, use high_work instead of recording task overage or doing
> synchronous reclaim and throttling. Charges to the current mm's cgroup
> or one of its ancestors keep their current handling. Tasks without an
> mm also use the worker.
> 
> Like kernel threads, remote chargers skip memory.swap.high throttling
> and its high-event reporting, and a fast allocator can outrun the worker.
> The memory.max and memory.swap.max checks stay the same.
> 
> Suggested-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Acked-by: Michal Hocko <mhocko@suse.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


