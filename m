Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7347AC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 14:52:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6894F6B009D; Mon, 24 Aug 2026 10:52:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 639E26B009F; Mon, 24 Aug 2026 10:52:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 504886B00A1; Mon, 24 Aug 2026 10:52:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C88F6B009D
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:52:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D5E614018F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:46:27 +0000 (UTC)
X-FDA: 85136438814.30.DCAEE69
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 26249A0013
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:46:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b41+8o8I;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787582786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uOdefC3ft+rIrM+lRzrzTelVuZoqvjKq0Pla1Vm3VSg=;
	b=FrQysYT0bc8TKaQrdUr3e3yfaJi+ObKVYMOY4gsk5Z6/dYVp5FTAAVvQ+EEq5MHj/nRpe4
	GwREJY+S8mlvg0q1iRTUsik4qB3QBPDOtgVx8Q3Sa/iATXjtHugr+T4vpR7jssRwNgDFmY
	v191P5Ui+yaURry1dSdS3T5Y8XCj9as=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b41+8o8I;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787582786;
	b=8ggEDEdlmvZ9cCtt8sg1TbSv9x1qAyA5pxG0SKueFCI3Y28wc2/fosSyMtdXyqeKQhSg3A
	aRUVy1N8V7WGIHT1CuYq8YDkgOYPDmrdCsDJeUdcUy/5FK3no/yMu1Sj/cnAzFC8NQZoLi
	CsLiTPK3dGx7OhRDO/cDZZ/u2cxfl1g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 95ECB6011F;
	Mon, 24 Aug 2026 14:46:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06261F00A3A;
	Mon, 24 Aug 2026 14:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787582785;
	bh=uOdefC3ft+rIrM+lRzrzTelVuZoqvjKq0Pla1Vm3VSg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=b41+8o8IJgBxDHtRI6Tjnf9CM9J5j7Wpr08L9h4SkEN4zb9xlhboO6fa2EYO4zIZl
	 sdWw3YJjUhNAWD7KdcvLEZNGcsRQNWqOlGqMHDg+TxRG7kNVkA+vdr2xJkdvknL/qB
	 mPvP33WQVDJrkciOrZybBGyyh/1NNq6U9ywOoci9m/Q3TcZzdua8N1wZAAdGBDITuS
	 jyCSP2oFp9YGQG4Qp6ZlxchyScmDZfKO3PAMS5HdMhTNdpNBVxuw/MfqzoNwwFWoi5
	 KIHkUfgwAZ2DybB6RBTPsGah/+63Ev53H6zpuWubJqmj3Waob9OZxqaLdwmRjAM5AU
	 1A47zHPy7WF3g==
Message-ID: <5bb86e34-6196-4b50-b553-be2ff7c1fa32@kernel.org>
Date: Mon, 24 Aug 2026 16:46:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/6] userfaultfd: decouple fault reason from VMA flags
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Jonathan Corbet <corbet@lwn.net>, Lance Yang <lance.yang@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Shuah Khan <skhan@linuxfoundation.org>, Steven Rostedt
 <rostedt@goodmis.org>, Suren Baghdasaryan <surenb@google.com>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
 <20260823-uffd-vm-flags-v1-v1-5-3086981b33cf@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260823-uffd-vm-flags-v1-v1-5-3086981b33cf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rer3t4gezzpa76uy69gcwsgs75891hs1
X-Rspamd-Queue-Id: 26249A0013
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787582785-297261
X-HE-Meta: U2FsdGVkX19v0RW7Ej6r1quY/nzJVn1mLvD8Rssaa84zdO3AzsrJT+BAjrN2RF7fqWzkeFdbfs+FWBjqBvWmFPfkrxbDah7PfMKjn6PWvYCJDX4o4pqqxEcmY4FVqc0wVW7ycunVM4nzDDQgskH5vmLTegjTyZTiMIML1myQPmgnDKBOk/7bFxFl4i5xIhlQoWVGTRKA611p48S5pVDb6al25wgAcJO+CfwUmpAmLD1tor9eLxstRUvJl6Agy2g+HWuARH9Bav3OVMaLoaRbYIuu95VfijO51Co6EbLAJg/NsFLhQvRIIde1DEb/ql8so/bHy9GfmUk9ydXW6m0uIhiuq+cvXKGbOhkyOGg4k9CKtOQ8ON1uGHgHLMd/s3mxc5T++/VxECuT/81bQ/brV+0wMjDmWYmiSqPNjqu5/tRyOqNUR5Cht1BrCO/RR0dAjf3lwaYWtn3d11CssdpsN+GDTk/Ptp95Kh4OFCra8EmjZT7XWi79xSu7YWO9OuWJ7E9Xun04CjFvJA4PkV6R1vuMlR8ogKzovy/HQpDNBr8rwkurP67c/emegEYH4/i0TyRSMxgURqn0W/4MaCf7v+F6DBSnhBcEzBcjChb49gf/1FxfMzj8nGzZ1wdipjklY0TCVNzSZlkVDONvDii567ZYbvZpTC7orQ/Hjjus9/RF5oQXkXA5hCdJ/CiXfguMeXfGrrd+k4fnWNSzMOQqiB49e9y440/6ylkQyUfeyx7qlJb4tFduKTJSzapE1nCP/+3cr50xouOM9fTqfxijUkqs8CrvOkzCsQfJ3lyfVUcJdXNLETmOdaDNrYUiux3NsU0QVAorhht/y2aG3dl9JE5HfIuswwq+KuwueA87bOJm/AjBiqyX3f/SEHeDWVNpkUpcpUEUHKiHiwGasZA/GDKNFUBQW/gxJqESWroKfbQhX9K7BtzFFY9lNl9z27GaqGmjX2QFsTjs9joVcI+
 Ot0dNpv/
 LCsG17qW6CIsGcnn9maBCZAOWmJUQdp3aJW4hneHUgTUSegVaHRxncZeU8iHNxzokDfmBHf3a1Nh2zm/B5rM8WxgmajdzO6q5rWqvAfiGNtZvbKuOk1hqPfSndL8uwKR0Ohf0/pvGZWexSHZrTCnJvfuiwsq9RymvYE9eI1iawX4VS/d7vzxltZAODkiZS61RzzcqxnY3JAIbPxCNhNNoobzqU+DYj1fP+0Kmj38yKOHHh4tg47UMYh0NGdXIvACi/fvz671L/Tiz1Oop34BwUXibMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/23/26 14:17, Mike Rapoport (Microsoft) wrote:
> Introduce enum uffd_reason to define reasons for user faults rather than
> overload VM_UFFD_* VMA flags for that.
> 
> Using a dedicated enum makes the code clearer and decoupling the fault
> reason from VMA flags clears the way for moving the uffd mode bits out
> of VMA namespace.
> 
> No functional change.
> 
> Assisted-by: copilot:claude-opus-4.6
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  include/linux/userfaultfd_k.h    | 16 ++++++++++++++--
>  include/uapi/linux/userfaultfd.h |  6 +++---
>  mm/huge_memory.c                 |  6 +++---
>  mm/hugetlb.c                     | 10 +++++-----
>  mm/memory.c                      | 10 +++++-----
>  mm/shmem.c                       |  4 ++--
>  mm/userfaultfd.c                 | 30 +++++++++++++++---------------
>  7 files changed, 47 insertions(+), 35 deletions(-)
> 
> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> index 45355bdb4ec7..f401623f315d 100644
> --- a/include/linux/userfaultfd_k.h
> +++ b/include/linux/userfaultfd_k.h
> @@ -9,6 +9,18 @@
>  #ifndef _LINUX_USERFAULTFD_K_H
>  #define _LINUX_USERFAULTFD_K_H
>  
> +#include <linux/bits.h>
> +
> +/* Fault reason #PF handler passes to handle_userfault() */
> +enum uf_reason {

Can we just call this "userfault_reason" or "uffd_reason" ? Maybe the latter is
actually what we want?

-- 
Cheers,

David

