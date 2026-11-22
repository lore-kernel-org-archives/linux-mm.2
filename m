Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52F78606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 15:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=j/wT6Qc4
Received: by kanga.kvack.org (Postfix)
	id 516AD6B00EF; Sun, 22 Nov 2026 10:32:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A0A06B05B0; Sun, 22 Nov 2026 10:32:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 341006B05B1; Sun, 22 Nov 2026 10:32:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A16C6B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:32:05 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9C45E406DD
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:32:04 +0000 (UTC)
X-FDA: 85463145768.29.30554B7
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf21.hostedemail.com (Postfix) with ESMTP id A57631C0006
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:32:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="j/wT6Qc4";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795361522;
	b=HZexyauMZLygcIHLzo4MoDjz9Wj8biGq/AL8NpJ6G4YTM0wXYoG6A2bUHU6PBYvoeazUUf
	HewMfkUX7GFkz/XMehtKMr388+7NnbpzJDOKEdEs0BzKgUxcHWaNCEzNddRm+/1rY2pRlI
	SMHKYVxS/C2779XxgUDj0qZ8QkzYCbo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795361522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NYFpjmsPtm5tW7G6832pWObwECaMPmu2sWxAUpoI3jk=;
	b=cao4hsVzzMOzcaArWA8o/oUHNqifoc1qxDFbaSbkh6uJqnDQq8kdR5zKfNSOc3nQWnwOyV
	pGgSLKa5Jm9D0qwydbS8fhZqClUOpFrkNRfiLPtao/Q6SZ8Dg+1eC9Kn04Gt1qYR1X2k9e
	nNnTpNpxtIc+pkutOhYFbzZHkrfEhoI=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="j/wT6Qc4";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a3517554f7so23516515e9.2
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:32:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795361521; cv=none;
        d=google.com; s=arc-20260327;
        b=baZCW14sBn6A79tCLXV42DlaUOiQ8bNJ9O0nKssE/DUrdMoSpUDuXsTKUPt5sRmIiD
         9LPbr/FYA/OwV5DQNnPBH5oujNBgI2akhoioNae9ZesZrH0FAx/hiW3+X9UC40qCaZOO
         YUP+N+GDeU0VOR7cnE9sU/m8YLf5IGFXTsXaIAOghkqxjs8fGlMhxNtsmZ18VabMBsiE
         suysyUL0eqykozdcMPJNNQz7S+DuCaZuhPzCY8ijYVO2WnmF68WFO5ghWeKfMB3zcHUt
         NhMkWzVe2mr15P7c2loydSU/wg9PyWQctiYxxI7RedFdasw8hmKO94FhR5Zqy2KVkN/b
         sCMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NYFpjmsPtm5tW7G6832pWObwECaMPmu2sWxAUpoI3jk=;
        fh=49WVmfnLVgVzat1P4D/D3awTneFFDNTlY5zGKKfWdeI=;
        b=bxomaZxfEqF/3mwcfXs5bLWIbM94dgaW3IMC+Ua3E5DT+uG3CJRjx3bsyptRI3eltq
         ilxoBppgP+Nm5JAnHtKoh1raegMFNV5xSsZJxjPy7AliAziE4VCcCNUx9qUh8x1DzNLR
         2Pds+NWjopO3pQkD8r7a0TN6yoeeYRd6eucxt8ndQtCy9shMehNq5S+11aqCNBZNQ/dy
         jONYJfeWbBPnx5fQ8uIuEVuTu4xkMS5CAW/UERSS2ddvPjxLFZoQZciz7aOAbLV4cjeF
         U7pJ2JFMts09K2Kb75k9KUUzX0XVIQltj4IWOg1TYqfYIG1txb+rXjhlgDpbWcHYFBiG
         4Wgw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795361521; x=1795966321; darn=kvack.org;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NYFpjmsPtm5tW7G6832pWObwECaMPmu2sWxAUpoI3jk=;
        b=j/wT6Qc4tVElBpIj/pkY+Ox3QKnZVOUCVQqMNifq7Ca1Ofj1yXM2quv/LZS4cU+Dp6
         J2hl4PQe5yL2Y3YvWQhR64j2UW4LFydKF0JduDaj+h1RZjVaEF86n/XQlSkPc5x0mllL
         FO0/jCmVA2jcIxUyIDivYPYGJ9S+d2Q/e9L0/nqWj8vKr0A3i+L7pihgHibxBfa3yn0N
         Pht4XvK2xCqx0uTUTAB+XcQewOgw5bv+zUbU+LozZ9f4u/OUw1WSbcyT6h6Z59IZXn6E
         VGZtXb2al37wLafC8HS4f7yUO1GNgWba/eHvDee4s0X80F1VOFQ2o1VkFx99uwitptXv
         qz7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795361521; x=1795966321;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NYFpjmsPtm5tW7G6832pWObwECaMPmu2sWxAUpoI3jk=;
        b=F66Y5wFyK80vBOqr5I/ekC5k/tWnuVKHAYnDBmxJmiXD/WKLs/KZR0jNavNKv/ie3n
         FDHEcA1HinNTDBvIFSyCUaHrxbttD0dk49poYVDr/abdpQHthTAPXXNQTQ5RQeAvi8H6
         70sCfBdQJMiLvBm3b6X79jRHTcvTjSHBFKS8wMkEH3WNcc1WBvxrOR5MVFJYx4bhgywv
         gMrZvCPhAoO5snUK/fMVCdxIQVjXmKNKaWhDfX2kbdQ/2JCyd7SMMJwrtmmqIuD4gnw8
         ERyGSbN677WymkuZtw3nAcwsVVgDqDeUM8Vi5CIoWG5RwrdYty+9JLgNAuLHfwvONjEA
         TOyw==
X-Forwarded-Encrypted: i=1; AL+hErHViXqkZcJK6NApbTLIA0ijHDCPnMoa/nHichAnY1nE8vryUoT1LRz/Xa+5nEJqHoYHWlQ/AstMlA==@kvack.org
X-Gm-Message-State: APuU4Z+zaDb9NBnHagSF8QGqmOTDfig+EAOEEUGbPLMlqDsKbP73laqr
	Kjn/OVJ4HsR0bpM+wDRhwmrye4KlLwQhtjB6qxPtNhwrtTA85cqjGNCLbHHt+lq/5Nhf6JkdjLh
	wack/2CwuM7QMGk6fP3yxW3okqF1UM/o=
X-Gm-Gg: AZFdTZfuSHiOmmhDolC+Z+vZ3uHjo4+RMLIppW+d5ZlDwPwwS8WEPwsoBRwBNaczvWw
	YPVbMJlGRKq7cICRfBcqUKXOKUkoedMngnWpV/Z5pkkw8LduKLbLxDjririEuNuH3ekWXjfPVgP
	oquF8gAL9+RXLg9cBfmO7iz75mb5I+TQlMMN9Nbww29/sApA4bVS2w/RbAOdyIF1eFphGLjrXLa
	cv9LXoStJWJw9+62Y4gyJMWPcPbbsn33GZ45ngGnyNZ7iAWM3qyurg0saRSB4U2fEdUAgu9WxR+
	hJdsoHTOkCHsXAs9kfc0leUaF6nrC7p6ncVDq698fVuyhPsVgmDrc6+uzprffnmAZM1dHiNrUSz
	AcoHahPlod4vGphA2YlGjuClGqZ7asDLBgxAv76WCSj/61zADeVWjn0Gu5+Rqn411fR/B+LOFIe
	kE7s7qFalLdTXYMxxRsVq6cCntwfWtCacDQpGls/AmHj9kA9vrcrQV
X-Received: by 2002:a05:600c:3511:b0:4ba:73f:ef5 with SMTP id
 5b1f17b1804b1-4bb88828304mr192354365e9.34.1795361520883; Sun, 22 Nov 2026
 07:32:00 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=NXSwSiuY65EV5nqFocMLd6-afsiJfgy_ahB2v_MDmcng@mail.gmail.com>
In-Reply-To: <CAKEwX=NXSwSiuY65EV5nqFocMLd6-afsiJfgy_ahB2v_MDmcng@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Sun, 22 Nov 2026 08:31:49 -0700
X-Gm-Features: Aa3M54oFs-onXEgzFSCUJR6noxWe_j7pdReKnjl-3Np_FarnqLTrTWVKv1OO0fE
Message-ID: <CAKEwX=O2McF-gyqJT2a8R5q79+QABCPjULrcjC2CC0v8TnXxJw@mail.gmail.com>
Subject: Re: Virtual Swap Sync
To: "David Hildenbrand (Arm)" <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Gregory Price <gourry@gourry.net>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rik van Riel <riel@surriel.com>, Wei Xu <weixugc@google.com>, 
	Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: zaksg8k6dak9mmhyexkp16rycmpx917r
X-Rspamd-Queue-Id: A57631C0006
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795361522-89183
X-HE-Meta: U2FsdGVkX18BZ4rAJP+2534gTm9RXEs9DgfZhaAUeRs+ywFMsjMvwTCtIaS6fYr5c/9XNC+BJSxjRkf8tysC0JiOfd9g5yDV0ABzzEUHcRp2Jc+4cWUlTuhQpeJx/rcPLgz/g6x71zTa+HP5j8gNvDpVLuwlsHpMJmhMThizzIy20qOVdZY6iRCQfgzzM+jNRxIw3qHJQLKRQXMjtua6jlXgM8LxrkmI2etPtq//KgSThE526TSP3CQ+KqjFqAJ7LLjfIgsgrnCG8uD5USreeT5ZZByjZqkRyGy1IB4EqipYp35Xe1Ew0X43nWHscmTq7jMy7+5icKd6bhO3HoXCt04K9hNjN3BVzs9k+BNYAM6ul50XDqBPN2J93gvMXptXJ5LwOwS+URkZ9OKK/fvatrZCShjih6h+Y8iqhOcLUEefsmFGF78Og8+4EYVc27wV9VCIkwq6kPEChT8YuNtvU+Su+8EPDlL/hSPmVUPZtKvbTpoUvbgBvPAlBhgPMxeuLLgw4GYj2rF402dhXPFB8nZcK+EMjQJac3shZTesZIOHNtTqNVGe8620ufZc4/HIw1kT0G2eZO8BQDm0d7eJlq1Vv/g/gosSIAJO0WNhlm3zDwuueKBWXiTTgjuGj5oEDFJpcwAGjKu0h39TotbG/EPgo0/IZzOBnpytAt8l0gV4gpqtg5K3VwF0DhsEuavgXkwaCH0dSylTaU7UdFowszA/lM3u5S2pu8ZatnCxdde5fXr2vkk29DVzexao3oiOpIMGL7eYO/78Sya7S5k8BVDmI8+JvyVA49F+oezre3SS5BFdRcQcwddgOkGtsVaZKtmoK188VBdKkcbOyU7WTgLHqKhghHf8SQ5hsHSaqMburB8tWgxOl15v5nckdtEmGrekvhTeDCWeUeKUJ67AwgUUt+3JFsqJMwCS8rHcosOsG1g3HVfedGPu7+7swXu/r7paOim6rf6Irndjseo
 udWVeWhu
 heY+rGawUOOQm5bzJIFTeQsHH+qQTk2Pr+HDTDwNP98vZvgKy1KV4RrCr5NLZN5QhtruIPcNG6Np4zwAT3jiAhlq4KjuOhu+Na54U5Ah4Luw91vx2c/HciiFMy1hOPL3ToC3byQdy9swdK6r1zSNmROzveMv0f0h2A2DfNDl2hTWQ4+fuxV1cQrNS6PoC6GO4UM61mWNMKgUk4Fw/omqn9X5tDX/chkW6IO6DQWCrBPmoN9jbFsXjoA4vfRjmxqBVwOfFGCWPbF0HdpBdNgNtQFt1ZxSVbtNvL1Auqe6vM/VwkUXiufSjscazSYJRjMi+z0Gu4na/SUXLpMr+4eIG7Pya9qLd039qS5tX6WJSmvhDlo3k5Wa5xq6X2oT8F/YKJgN8ioHcrRBP5ndO3fCs2/ozvbBk4btxnFSFqDXg9KuZldmgZnQDeQe9QebAdpUwtnDWkbyilvd+tRPMcPx2WF62FulhVTr5lF7psN8ouKZmK8INpWb4zICrba34VLuy7Sk2OoSemRBuOXdXTeidNi0VAoyTpcUNQ56suYDyA5fydmKXj8ahNbkdjXLuYAWfD218VMn1R9OhbAyBKAT2A497pc2qZskoXG4U78+J0DAYd/UIsVhapNM2nPi2/AoFdQhnVb8fhG+ymGZQNcTM9fM66xwbl2ADrcCCLCNMU+UeYFnxFJnYbBoVM1GCcZXzPlIydM+ir5Kxwf4kpzhvXXlJoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 5, 2026 at 2:06=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote:
>
> Hi folks,
>

Hi folks - thanks everyone for attending. :)

I summarized the points we discussed below - please let me know if I
missed anything or misunderstood a point.

* Control interface: Google is interested in a knob to cease zswapping
(which already exists and will still work in vswap world). Kairui has
a use case for remapping all swapped-out pages.

Vswap currently bypassed when zswap is off; per-cgroup selection could
be added as concrete use case arises (for e.g migration/compaction).

David objected that a virtual swap abstraction should not carry a
swapoff interface per se. Folks also asked whether making vswap a
mandatory layer would make the implementation cleaner (Nhat will
explore this direction and follow up on this).

* Virtual space sizing: We discussed using vm.overcommit_ratio and
vm.overcommit_memory to limit the host's logical memory footprint. The
exact sizing formula is still unclear - Nhat will follow up with
Kairui on whether it is acceptable.

(Kairui, if possible, can you respond here for your exact use case? Do
you want to limit physical memory usage, or virtual? My understanding
is you want to gate physical + swap, which would be closer to the
latter).

* Priority and multiple swapfiles: should not be added for now.
  No good use case for swap priority was identified.
  Multiple swapfiles were used in the past to work around swapfile
lock contention, but it is unclear whether they are still needed with
Kairui's new cluster-based allocator. If contention remains a problem,
we should fix it in the kernel before putting that burden on
userspace.

* Proposed phase split and charging (from Nhat):

  - Phase 1 - initial foundation:
    - Decoupled zswap: Let zswap operate without reserving disk swap
for every virtual entry.
    - Physical backing and writeback: Keep disk swap available as a
backend, including when zswap cannot store a page or an entry needs
writeback.
    - Charging: Retain memsw charging for virtual entries; keep
virtual-slot usage out of memory.swap.max. Actual physical swap usage
keeps its resource charging.
    - Usage counter: Expose vswap usage so users can monitor
virtual-space consumption separately from physical swap usage.
Essentially this gives you a method to estimate the logical footprint
(memory.current - swapcached + vswap).

  - Subsequent phase(s) - further support and controls:
    - VM_SPARSE: Add VM_SPARSE as an optimization after the
first-phase foundation.
    - Runtime controls (added as use cases arise):
      - Host-wide runtime disablement knob (and remapping of swapped out da=
ta).
      - Per-cgroup vswap control (for e.g, if some cgroups want
migrations/physical swapfile compaction).

  - Orthogonal use cases and concerns:
    - Cgroup-level logical memory limits in cgroupv2 (memsw?) - swap
developers will follow up with memcg maintainers.
    - Static sizing: Define the host-sizing formula and decide whether
another interface is needed.
    - Swap tiering for cgroups: Explore backend selection when a
concrete workload needs it.

Folks, please comment on the summary and proposal.

Let us keep the communication line open and coordinate on the next
steps. I will schedule something again.

Also taking a step back - once we reach a consensus on vswap, maybe we
can repurpose this series of meeting for general swap alignment? There
are other swap/compressed swap developments right now (looking at the
orthogonal use cases list above for e.g), so maybe we can do this once
or twice a month. My experience in the past year or so has shown that
we clearly need better alignment :)

I will reach out to set up another round of meeting. I'm hoping we can
do it one more time in December, but I understand that holiday season
is coming :)

For folks in the U.S, I wish you all a merry and festive Thanksgiving.

