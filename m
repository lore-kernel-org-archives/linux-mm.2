Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E348D4A615
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 09:14:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6D0F6B0088; Fri, 16 Jan 2026 04:14:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFA916B0089; Fri, 16 Jan 2026 04:14:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D26416B008A; Fri, 16 Jan 2026 04:14:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BD6016B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 04:14:34 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 665CD1605E4
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:14:34 +0000 (UTC)
X-FDA: 84337266468.21.EE55787
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf05.hostedemail.com (Postfix) with ESMTP id 92AC8100006
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:14:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cevXBDWB;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768554872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vF0itXi5419rm4LJFbIRbe8CXIn7csZfmAPobL5TwmE=;
	b=uHSfAAl1VhAAlv7cXGQIKP6gQCHJP9gEMKAj21G+cYewPR415CYI6Qx3xM4K1U8YzEqudx
	dOeq9h5GrpVYoRnwxk+tzZDJQdmtKOQifNaNqd6+KDCX9F9tnfBSr8NpyJ3D0hLR+Jwq65
	hkndHQDMWrHQ6aGV7D58ayM2AuLsjPA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cevXBDWB;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768554872; a=rsa-sha256;
	cv=none;
	b=8fxbnTNyt2AoHZDFt3ktMzyxZj/Hx5SfHxMEjEP6+Xs7IiF4PMYLHXpowvL1CvGbYPy0Yz
	JREE3PD37K20Uf/4/4Kkt0mYYxg1Y4w4OYxBtHLcW3PeAtPG+Y0da6QxosWKXPpbY9kCvG
	1A14pHG/X+uvyvb0iFIF97PWQnJxw4o=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768554869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vF0itXi5419rm4LJFbIRbe8CXIn7csZfmAPobL5TwmE=;
	b=cevXBDWBGZtwpQX0uRsWsByXI/bV7/Hpg+kCW8fnJaWNApAiMl5KVCDEN/W2ndn4UcIalz
	Lp1xm3CLvjZ4uzDR8knkxBZ3gV3lNJ9ZopjWMjoSc68YF2DD21DQ/Swxq4ls2SJXko6vSL
	LcCPbyGRYSRIq8IE5ekzxZ4d6oQp3Os=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH v3 04/30] mm: vmscan: prepare for the refactoring the
 move_folios_to_lru()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <65187d0371e692e52f14ed7b80cf95e8f15d7a7d.1768389889.git.zhengqi.arch@bytedance.com>
Date: Fri, 16 Jan 2026 17:14:10 +0800
Cc: hannes@cmpxchg.org,
 hughd@google.com,
 mhocko@suse.com,
 roman.gushchin@linux.dev,
 shakeel.butt@linux.dev,
 david@kernel.org,
 lorenzo.stoakes@oracle.com,
 ziy@nvidia.com,
 harry.yoo@oracle.com,
 yosry.ahmed@linux.dev,
 imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com,
 axelrasmussen@google.com,
 yuanchu@google.com,
 weixugc@google.com,
 chenridong@huaweicloud.com,
 mkoutny@suse.com,
 akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com,
 apais@linux.microsoft.com,
 lance.yang@linux.dev,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>,
 Chen Ridong <chenridong@huawei.com>
Content-Transfer-Encoding: 7bit
Message-Id: <897EC629-8E32-436A-B829-AB7D1A291C61@linux.dev>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <65187d0371e692e52f14ed7b80cf95e8f15d7a7d.1768389889.git.zhengqi.arch@bytedance.com>
To: Qi Zheng <qi.zheng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: i8g5hs3r316wr3de4n98ztpozkdat1w6
X-Rspamd-Queue-Id: 92AC8100006
X-Rspamd-Server: rspam04
X-HE-Tag: 1768554872-553812
X-HE-Meta: U2FsdGVkX1/mafty/BEtKXa1zqVXrTObM505M8uwTPnwY9+eR0Ahqwi9Fvlq9nl1DQpRt9l9kxobwHCV8eAUfYaLytttv5l3k2OtOmMvsZQvcogYdhcJZVWh536APCPGnmdw/qPCgWfbwYpznAUu0VKsrNdOuziXJN9ddxU1rtxNAwwoJBpG8WmR5x4cFltkGQ3HGJQua6pSt0GR+zd74GULf7S+F0Lro8a3mmz1lpqyMddXLnfqD0JFTbl0qWkv+812MnBykPA2+51fqcaNdTf3StJb0HjcUSL7MYEewdr2G3G2j+F4yXqLYSs5ooDMkXnZLUetIyaH3j2BwFU7sje7XoTO4QMVe496foKXtSD5gp7rdH4MYP1DigDclTSlk80f2XmWHVKshliR4NP63Ba2vOG/mgyTLbRo8N1som8Edvm9oqqX1CRkX4+Vl+NboJTfF9P4WSmqG7g5nC4EpnIDrM08/Gqzzf8+o5iDVUWPE+RA/Twl1BddoMmZp+SIddfYEZTksW0EODrXNhd9tAt1NOSCUroFPcvTasAIaKU07NfygToWq0HnelB1ofMPqDzYpZ3cs8MWSlmKaLS5VpaYmGu89AcP+QpEOS3Sj0ZQEpsGNLmxi5/pXhdhllsNKwRrzkSKLYQTZXTSKCvJvH3Nu7hX+y0qIzVHXBv65eBpjFA1ZKvMnRHGdeaYMDr7k5G2nRzO4kMKuEZ1mL2t1Hv7Spk5v5ZzZ84m9u7LWT21o/9vSYZcB82hJtglCEVS15kT9h61Q0cxGcweEatZkdLqc0XCk0pJRDw8Ot1nmOGLfVBp0iXl1PSzUCPeB4gircwQTaKtMPmCwbJmbUXEwXcuyPi64swoXkrAr5lstTu6T6ZZ0n2oNBNCl5Z50YIEnQBVcAvAFH5+cVwF0/C/R2bihinOOTONnV8yT7ahw6WmL62WFkdJ39MG7PdZOkuXmrHb5L3GvgVxatKFdev
 nn8eMepk
 rTOd4Ebesiyz2YpP/auSu5M5rPVGPTozYiPX4ZSLR/dCH0rVTkT0TPelgqNpeFGx/fMzFODH/ZiDMFDm7YcY5TD+IAw1Xynxa3bq9aZX9OuV5kNzH05UL83uDGBTsKKHJs66q+p174IgcM//U37UV89SOyxZz3aovzwRwSbIxDv/Opnh881P6TEKCO6xXIlrstFkdzlG5yk8rmYv1LVzxLZPlxgB3ZPD836rAS6mFYrnStqYyrqwOxLp0eMTclOamAOMWzZ9RibGUSnPRYjRbEcyLFJBBw0iyB+8QsQCU5SYBN/vf5IGBKFeLO9A/i5JxQchtcNxjJFHc8z45QBjIQumsrZVn98Np5WbpwSHSMVxBbmZHBHrv80Sd+TF34jWRhzUHzKWCW/bYMQqJt5XyZMypiB00QIni1GBfTRUcIKtQ3JIOVnn0KvEmztKOQKMlnPcA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jan 14, 2026, at 19:26, Qi Zheng <qi.zheng@linux.dev> wrote:
> 
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Once we refactor move_folios_to_lru(), its callers will no longer have to
> hold the lruvec lock; For shrink_inactive_list(), shrink_active_list() and
> evict_folios(), IRQ disabling is only needed for __count_vm_events() and
> __mod_node_page_state().
> 
> To avoid using local_irq_disable() on the PREEMPT_RT kernel, let's make
> all callers of move_folios_to_lru() use IRQ-safed count_vm_events() and
> mod_node_page_state().
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: Chen Ridong <chenridong@huawei.com>

Acked-by: Muchun Song <muchun.song@linux.dev>


