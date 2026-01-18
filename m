Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B51C7D4A5F4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 05:09:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBCAC6B0089; Sun, 18 Jan 2026 00:09:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6A866B008A; Sun, 18 Jan 2026 00:09:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4C5C6B008C; Sun, 18 Jan 2026 00:09:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C50EA6B0089
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 00:09:11 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5739313A7B5
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 05:09:11 +0000 (UTC)
X-FDA: 84343905702.09.F37139E
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4A38AC0008
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 05:09:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MtKxHAq5;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768712948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CcdCzCeZyy+3wcJ3ycr2MFhPXDKfMUMZ+CbutgXspfU=;
	b=SiCZq1LznIhnSUerhxp2rEXFSghouPgCKHoKMEWZ0b3tnzgdHKD5iDnhMglnzPaNsE8k+t
	p1t6nXp2J8zsWXCdhVz6lNVtYm0P4h633WIWczxhRvjAU92A41C3W8zDJqkzC19Dok37xW
	RrV7TqR5RykDfHibGGmn5GFqdfk/VmI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MtKxHAq5;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768712948; a=rsa-sha256;
	cv=none;
	b=EB9Qv620lEdSGBCIEhKfUKQ/R6w1wYcmEFQ805ifu5gwm5Fz/vG+kjmeZTYUedMGZSpdd4
	VyJTs0Q9jRXsOEuxhaKa2Y+eOd5g+pyhBK110U4/DjcoR+Q8N1bXpt6F7YsSknsnHc+q18
	5ybLbqBgX8hjL7/ymDE72NCiC7SzitM=
Date: Sat, 17 Jan 2026 21:08:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768712944;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CcdCzCeZyy+3wcJ3ycr2MFhPXDKfMUMZ+CbutgXspfU=;
	b=MtKxHAq59xa92tBu3FCniyhCEgQ/N3jO/AK5C2D6xr2EtCr1iPYL6VkwbyipSetlILjwL3
	dcEaP3370HFnVDEftsUmPo4xrJHlw0xGVq2YoTG0MpDqeWDPFk3c4QnQmgMhXbvaqsd4PQ
	9vxcB8SatgqtNQTbnQ0MtphswQk3nPk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] mm/vmscan: add tracepoint and reason for
 kswapd_failures reset
Message-ID: <eincfrroi5qp254yv7stkayzy2eayw2zgrjbq2w4icrknkze2l@yodvhzqggxkm>
References: <20260114074049.229935-1-jiayuan.chen@linux.dev>
 <20260114074049.229935-3-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114074049.229935-3-jiayuan.chen@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: yx6i67tz9cbiypeetfyxz8qwk1heicnq
X-Rspamd-Queue-Id: 4A38AC0008
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768712948-336168
X-HE-Meta: U2FsdGVkX19pd31bBUPApW6p01SKzB3ISVdC0LUhjD7nAjGN2XCB8tzKjB/Jn8aHhtSjKaMtlA0m/k0XZqwmis++Xq4RwcyLZZa4W+liCsCZkehuQszHTpKzpS/XOcRGjIytCuZ4K6kXLybns2HzodkP1jEOqvYpGpZN78RfPGBTX7aLG82s5Xb8WAWSYlfVMAdp8gh3am1XTkLdPI41u332O5jeu0UJfSV6RuUCRGsuaELTK5cUITTQ9m4oLm5afRGa9gqPsfXMPOzm4AuypGj0IK6Dt9FbbDuAL9k8ww4g6wyZwXxqNlzxuPL3Vv6Zi7o+QBRzs3iEJbZMfD856F1pXAhuf9mbdZwLuM1mIl4xZRmOOp6LMPW92JWiHEDIKO0Jze/wK249E9zlbrnD0OKe+6TA5KwSPVhCvLwaMxT/poUOkzZcGHL+KVg0q/5cv4eW4By7v+UF0t9Q3Fqqq9vpX+f6ADG9GLOZnwNnKQDoIBEEqeqzPyCXPY9Gco7vgdz7aXeZ5O9x05KU6iVu47nAjThWaZulMOLF9etvGtQo8rAeoEND5eV0BsazTyYP+bY7Xw3pAP7hiZV37OxsDLb6V4rXCky8NEZyLIbRnELwdQoJx57vRdHo5fdfOfSTLCV+b1V8RDCMvXJzoAto5r15mmjVrT2gWYiZ0iQeaeeb4xoZ0JzYABduk4d5zd5WIT7nvuykRlSvRgIOrfQfZMNkV4ZMJ0nFXd96Z9y31267cSWcRzxqniOq15LwkeWy/DMUhXzP8pP4tJpFHcZbtCOYsClHYyzOJtCwv86yXNAoDOvkUCNMPghovOD4bI2hNMtoJOym+TfBsvPEEoLpdN5uWBzSwR6NmhfJRa4ihbWmOu4mnhZdOpj6j8LKFwLLvtvLrGnYdWHsFgcpwXPJZXxaQ4D6AelIAIYxbdwlvLWVKbwSb4F6Y2GMUckFJwCpARfEi2usW96OOu9zBqh
 um+S+eeG
 K/CROI0owgihSIeXvQwpJBnseYvjLUeusvObhH6Sr3ooHxm94kt3QfI5Id+U3D6pPQqLGFPPiQ0LEFG9DN5rknXhR8ECCk8BSbi5Ur76BfeBizOcilekHLWmc0HSbOx4dE0baeiR1tlS817SIHhw2211q1TzDDKhZgyjHFiv6043bN1dEnAr7gwV1AFGk392XAI0OGQjQ0J6tHeg4qZb9neOa7YNAtvbUS6/DTmZjPuRc3J8oc9aXgr/RSKMloXurWNs2cisgVSniciLoNrgLT9N/D3t6NBuONtuB+8gmFdujEzOpyEgTQvO9KZjBZd/nd1qA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 03:40:36PM +0800, Jiayuan Chen wrote:
> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> Currently, kswapd_failures is reset in multiple places (kswapd,
> direct reclaim, PCP freeing, memory-tiers), but there's no way to
> trace when and why it was reset, making it difficult to debug
> memory reclaim issues.
> 
> This patch:
> 
> 1. Introduce pgdat_reset_kswapd_failures() as a wrapper function to
>    centralize kswapd_failures reset logic.
> 
> 2. Add reset_kswapd_failures_reason enum to distinguish reset sources:
>    - RESET_KSWAPD_FAILURES_KSWAPD: reset from kswapd context
>    - RESET_KSWAPD_FAILURES_DIRECT: reset from direct reclaim
>    - RESET_KSWAPD_FAILURES_PCP: reset from PCP page freeing
>    - RESET_KSWAPD_FAILURES_OTHER: reset from other paths
> 
> 3. Add tracepoints for better observability:
>    - mm_vmscan_reset_kswapd_failures: traces each reset with reason
>    - mm_vmscan_kswapd_reclaim_fail: traces each kswapd reclaim failure
> 
> ---
> Test results:
> 
> $ trace-cmd record -e vmscan:mm_vmscan_reset_kswapd_failures -e vmscan:mm_vmscan_kswapd_reclaim_fail
> $ # generate memory pressure
> $ trace-cmd report
> cpus=4
> kswapd1-73  [002]  24.863112: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=1
> kswapd1-73  [002]  24.863472: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=2
> kswapd1-73  [002]  24.863813: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=3
> kswapd1-73  [002]  24.864141: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=4
> kswapd1-73  [002]  24.864462: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=5
> kswapd1-73  [002]  24.864779: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=6
> kswapd1-73  [002]  24.865103: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=7
> kswapd1-73  [002]  24.865421: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=8
> kswapd1-73  [002]  24.865737: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=9
> kswapd1-73  [002]  24.866070: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=10
> kswapd1-73  [002]  24.866385: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=11
> kswapd1-73  [002]  24.866701: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=12
> kswapd1-73  [002]  24.867016: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=13
> kswapd1-73  [002]  24.867333: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=14
> kswapd1-73  [002]  24.867649: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=15
> kswapd1-73  [002]  24.867965: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=16
> kswapd0-72  [001]  25.020464: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=1
> kswapd0-72  [001]  25.021054: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=2
> kswapd0-72  [001]  25.021628: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=3
> kswapd0-72  [001]  25.022217: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=4
> kswapd0-72  [001]  25.022790: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=5
> kswapd0-72  [001]  25.023366: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=6
> kswapd0-72  [001]  25.023937: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=7
> kswapd0-72  [001]  25.024511: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=8
> kswapd0-72  [001]  25.025092: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=9
> kswapd0-72  [001]  25.025665: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=10
> kswapd0-72  [001]  25.026249: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=11
> kswapd0-72  [001]  25.026824: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=12
> kswapd0-72  [001]  25.027398: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=13
> kswapd0-72  [001]  25.027976: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=14
> kswapd0-72  [001]  25.028554: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=15
> kswapd0-72  [001]  25.029140: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=16
> ann-416     [002]  25.577925: mm_vmscan_reset_kswapd_failures: nid=0 reason=PCP
> dd-417      [002]  35.111721: mm_vmscan_reset_kswapd_failures: nid=1 reason=DIRECT
> 
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>

Thanks for adding this.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

