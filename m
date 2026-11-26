Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F905606A327
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 06:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=orQsZTUp
Received: by kanga.kvack.org (Postfix)
	id 5277D6B05B6; Thu, 26 Nov 2026 01:03:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D84C6B05B7; Thu, 26 Nov 2026 01:03:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C7816B05B8; Thu, 26 Nov 2026 01:03:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0F9656B05B6
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 01:03:30 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9E22F1602CE
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:03:29 +0000 (UTC)
X-FDA: 85476228138.17.2A73D47
Received: from mta1.migadu.com (out-215.mta1.migadu.com [95.215.58.215])
	by imf24.hostedemail.com (Postfix) with ESMTP id 74596180007
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:03:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=orQsZTUp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.215 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795673007;
	b=raWOKcTN1akPEaQOo4l0yVK0sAT2IIxMLZOTw7c0QXomctyc44POJvdaQN9Tn/WpErKT9G
	qmJIdFkGRtbSR9gPAGdbDrnQe69zAL21xG2VfjRkEDcT+seK621pzzs/4LwrMR6H7/9sIu
	35z4sudN0xF8+NsvEJV1+zgg4lOIkJo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795673007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0PzfTGtQNoeXf6Gjoec1s/Tw8QgiWIeiBg+XwjQcs8o=;
	b=refNbSK4ComDd8U5nLKaddIZlTrtVq6ZFU5xvfMP+aUwUHYMdZX3cbPtzNbJbeFs3wRwcM
	xKguiEU3PRPxZuAFEsKNTV7UkmNfbeiH0vN132zyL1bVrT1tvtbQhSw65t0h3cYsIz2jxW
	KorDTuGNRPRubHR1QwIWHd/O7tw2/KI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=orQsZTUp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.215 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=748+ddCbsTP/XIDjke/+TROSx5c7dPfXbczUrGruMHY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795673005; v=1; x=1796277805;
 b=orQsZTUppfMHaenXYMAuC6fgaFhIJ8I2sIqlnrUlmWRJmaBgrone90Ei8FYK5hiRn9+KB0fx
 s1KYh08T/FBsUCyn5YuPbPE/4r6A5TlNSunVVHVc3mHMoxG2VB/378K8bB3DeeT9iTFBPUCaauZ
 iyZ991Wg8d1sMoBHJQBbY8wk=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id c47457697a4402af;
	Thu, 26 Nov 2026 06:03:24 +0000
X-Mizu-Trace-ID: c47457697a4402af
X-Migadu-Flow: FLOW_OUT
Date: Thu, 26 Nov 2026 14:03:19 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Nhat Pham <nphamcs@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <ryncsn@gmail.com>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Barry Song <baohua@kernel.org>,
	YoungJun Park <youngjun.park@lge.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Gregory Price <gourry@gourry.net>,
	Wenchao Hao <haowenchao22@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rik van Riel <riel@surriel.com>, Wei Xu <weixugc@google.com>,
	Yosry Ahmed <yosry@kernel.org>
Subject: Re: Virtual Swap Sync
Message-ID: <awfLp4H_pyefSM5v@fedora>
References: <CAKEwX=NXSwSiuY65EV5nqFocMLd6-afsiJfgy_ahB2v_MDmcng@mail.gmail.com>
 <CAKEwX=O2McF-gyqJT2a8R5q79+QABCPjULrcjC2CC0v8TnXxJw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=O2McF-gyqJT2a8R5q79+QABCPjULrcjC2CC0v8TnXxJw@mail.gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 74596180007
X-Rspam-User:
X-Stat-Signature: xfjqjwnwz878i8xj3bedpibo3ictbeqy
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795673007-469799
X-HE-Meta: U2FsdGVkX195fWAQViGfi/+pF4GwcxbnmH7e22U3vX5xe68CGo/dAuixXTwzFNRXwAaABOs6VHRaDi3oTDJQretyU5DBkYO7Q7VgdHxH7e28VouWJv8CDo3RQxQXiect6rYm2t4XHo7Lwz6pmjHgHLy70ZqR1CmYFROvpfRavlpAYifIJRVckF6T6z93mmcsGtzFHtEYVizhYis2Yr5xs9HqmiCiczKmUIc3rvZXKqIR1xooGOzA+2F5JZ8iFu+jorNwUQrIX/WLHeVrGlwaQBO6cIpx7qKu9GE4FFWcXtuvWuu6fV1Aaiw4D6n6tqJRwYJ0m/+py54Cb4mrS/MCcrsfM1Q/+NYyNrJEe8NhMNORsM3bRIuivivhGSaAL+uTuG86cJcZxK6r66NapTXEnQObWFcGc7QxLYkF4GU3beylf/enra/B27e8SacZl0IP1j10DAvnLmjH7V9DHjQ51fHfqP2AQ86sUdfo4PHxOH5kWyCvYxzFEzIL4YOuvYOyQAvywkx3rHv3/SUWoFeIuJHLrY8lWaqa6Ylex/rmbzVLpYTHuDrXeol5P5mMJwXznXlvYGCmaDu5JbWluHS8xsmXQRwY6Q56i9k26PFPlwxqt2Q+VyYqxLuwg0gcUUZf7hAkROe+vnU7PBYMHvGSrCUuWuTGfPSRkRtrRNCPdeUGfMWX7z/N3KhU8EjeBK6hRyTxvHC+r2IpafLUwB2EMMFcjVTuxDE/C7huMtGe1fMNravuU1nzLM4xpkty/1LD2nw4GvYhxTR7ev7xtCsSGyJ06pTl1VOenHRU8vY4zcFzdutG6vaNhhML+X6RXHRmFa/nhTmMllm6zJVV10b3Y+jLJsXFJqxYIqH44Wnr9YSkk140LXOaLvA5U+6xYPNQgXwnVcMDEwbmgCVyTfhFy4mmoJkbCeQ5QF16CCBT3PteUsd7lKSBakPQBumS7Wa/YE6tpjwzUbNkcz6d9m4
 qq7XO5f+
 eZ8vtujwQsbyrbpFYAxgDIIncIN28SHrWSlyHiNjhpDJw3DLVo2qj2POlRBaLKlAJiNkr7ZTqwWGWwk3u+T+xs5+ZAs5IAUE0LxW1wpFhVGQzKPM3QLF0Oe0IpJtA+gtsMAy6KBI6wcQ1djgEduJ4GopeBA4sIPjJ3hig2TwndXQpMDbp3hnAPYv609Sy+iESjEuq4jV6h89LxKTPdRIElafRRNEOpZplGhmL0RrJ13S7vngJRIaoiJCamyNdbJ3ze84mawLHIRvb7+0SbvB7J9hQDZoMwddoDeJMT1lEOe4X3l/uq7R8ypuEOZdM1QYxNTxC/ZNsLcd4M6Y9h33Fz7FXFqg5VBoBC+58jlEax3Q7Vj9E/n5f5DAMVL9Pv4ZXV1KSS3OiJ3cjPI1o51SV9hi8N8GizOOntF6de7lWUmquS8Wx4eqPDUhw7Ah4aS8zWbO6zcoTzEQj21UMgLLi5uNyCrOkaNkfzmuUMZF65xBo/cjqVw3wzbJiV7BrKme6usCNeUdYcQ+1HwzXhVjoIw9VsSn1nMsneh1hsghJy+pvid2HJ1KJ6f3eR07KWmpEfmN7e1xqef1SUzjNe7Oh3fGV/rCN3Qz7eyVFTWjiEAjIQQff92lvrNTvwwv1R0ftLeUvuomO9AY1Mes=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/22/26 at 08:31am, Nhat Pham wrote:
> On Thu, Nov 5, 2026 at 2:06 PM Nhat Pham <nphamcs@gmail.com> wrote:
> >
> > Hi folks,
> >
> 
> Hi folks - thanks everyone for attending. :)
> 
> I summarized the points we discussed below - please let me know if I
> missed anything or misunderstood a point.
> 
> * Control interface: Google is interested in a knob to cease zswapping
> (which already exists and will still work in vswap world). Kairui has
> a use case for remapping all swapped-out pages.
> 
> Vswap currently bypassed when zswap is off; per-cgroup selection could
> be added as concrete use case arises (for e.g migration/compaction).
> 
> David objected that a virtual swap abstraction should not carry a
> swapoff interface per se. Folks also asked whether making vswap a
> mandatory layer would make the implementation cleaner (Nhat will
> explore this direction and follow up on this).
> 
> * Virtual space sizing: We discussed using vm.overcommit_ratio and
> vm.overcommit_memory to limit the host's logical memory footprint. The
> exact sizing formula is still unclear - Nhat will follow up with
> Kairui on whether it is acceptable.
> 
> (Kairui, if possible, can you respond here for your exact use case? Do
> you want to limit physical memory usage, or virtual? My understanding
> is you want to gate physical + swap, which would be closer to the
> latter).
> 
> * Priority and multiple swapfiles: should not be added for now.
>   No good use case for swap priority was identified.
>   Multiple swapfiles were used in the past to work around swapfile
> lock contention, but it is unclear whether they are still needed with
> Kairui's new cluster-based allocator. If contention remains a problem,
> we should fix it in the kernel before putting that burden on
> userspace.
> 
> * Proposed phase split and charging (from Nhat):
> 
>   - Phase 1 - initial foundation:
>     - Decoupled zswap: Let zswap operate without reserving disk swap
> for every virtual entry.
>     - Physical backing and writeback: Keep disk swap available as a
> backend, including when zswap cannot store a page or an entry needs
> writeback.
>     - Charging: Retain memsw charging for virtual entries; keep
> virtual-slot usage out of memory.swap.max. Actual physical swap usage
> keeps its resource charging.
>     - Usage counter: Expose vswap usage so users can monitor
> virtual-space consumption separately from physical swap usage.
> Essentially this gives you a method to estimate the logical footprint
> (memory.current - swapcached + vswap).
> 
>   - Subsequent phase(s) - further support and controls:
>     - VM_SPARSE: Add VM_SPARSE as an optimization after the
> first-phase foundation.
>     - Runtime controls (added as use cases arise):
>       - Host-wide runtime disablement knob (and remapping of swapped out data).
>       - Per-cgroup vswap control (for e.g, if some cgroups want
> migrations/physical swapfile compaction).
> 
>   - Orthogonal use cases and concerns:
>     - Cgroup-level logical memory limits in cgroupv2 (memsw?) - swap
> developers will follow up with memcg maintainers.
>     - Static sizing: Define the host-sizing formula and decide whether
> another interface is needed.
>     - Swap tiering for cgroups: Explore backend selection when a
> concrete workload needs it.

Youngjun's swap tier comes from concrete use case of his company, it's
been v11, he presented this in LSF and LPC. 

[RFC PATCH v11 0/4] mm/swap: priority-based swap tiers with per-cgroup selection
https://lore.kernel.org/all/20260916183437.2946306-1-youngjun.park@lge.com/T/#u

This is xswap road map I shared with you when we discussed about working
together. I also mentioned swap tier in road map because Swap tier is a
very important feature we swap developers plan to add. 

https://lore.kernel.org/all/al8ohWshSSZ64AtT@MiWiFi-R3L-srv/

I thought you had read them.

I don't know why I couldn't join meeting last time, I tried at 8:05am at
my side, kept waiting for people to approve me until 8:30am I was
added. Not sure if you guys also talked about this.

Thanks
Baoquan

> 
> Folks, please comment on the summary and proposal.
> 
> Let us keep the communication line open and coordinate on the next
> steps. I will schedule something again.
> 
> Also taking a step back - once we reach a consensus on vswap, maybe we
> can repurpose this series of meeting for general swap alignment? There
> are other swap/compressed swap developments right now (looking at the
> orthogonal use cases list above for e.g), so maybe we can do this once
> or twice a month. My experience in the past year or so has shown that
> we clearly need better alignment :)
> 
> I will reach out to set up another round of meeting. I'm hoping we can
> do it one more time in December, but I understand that holiday season
> is coming :)
> 
> For folks in the U.S, I wish you all a merry and festive Thanksgiving.

