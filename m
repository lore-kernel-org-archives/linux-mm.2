Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E577C88E75
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 02:28:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 668456B0092; Tue, 15 Sep 2026 22:28:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63FFB6B0093; Tue, 15 Sep 2026 22:28:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 555776B0095; Tue, 15 Sep 2026 22:28:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3CC126B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 22:28:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C60C3160581
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:28:07 +0000 (UTC)
X-FDA: 85218040614.28.17B6AA3
Received: from mta0.migadu.com (out-222.mta0.migadu.com [91.218.175.222])
	by imf20.hostedemail.com (Postfix) with ESMTP id 91D481C0003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:28:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=icxZfwJW;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.222 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789525686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kJgEZ3B/DsQ5071yZaP+CFUO+XNU47PB26CE8J37aAU=;
	b=Uu3TsvEXkZ8UkK0DuROiR+6YgbT3jS6ujF4lKnGwQVmQ/WDUum5JGlpV52mGBpo1I3kiB2
	DEEbDeojvklbL8pVOR9fYr/t0ikFcqolvkBkuVZTLCVV5gPfysKIUrBDXUEMc3iGc/8ie2
	3w1rRMV/6h2nmY7hYYmKN0YRwhVdLqI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=icxZfwJW;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.222 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789525686;
	b=P08KkVqC04CF+ZELvGaUt0Ky/qDiRM6CXD4kI6C9H07EEyPcpql30oIUOqzif3VQMIPB/d
	A65j7Fi0MsssbfT7SGgSWjKypwn7YaT1wG3k1oJuatvV8BohBAtN3j1IA5mFlAxAUNHF8Z
	+RTbyYmdlHzBCpkFk2tFQBbc83jhU70=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ZyxvwXCuu3wDubtodIGxIsLb9DGpsFtLwTaxFFn+nac=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789525684; v=1; x=1790130484;
 b=icxZfwJWf9IQMeeSSW2HGckpLv/cicx7r/t1n3GOKWT4uTHFT+Tzb0PjFo1E4waqCykBmRue
 C7eDTylMdvEocKy+BNqjgV1NKoBD5QWzCUtMghpQDMa116QaawXSRGqYNO05I9sK6+t7b9G/5yj
 yISOx8NczZymSfEYFS6PWUfo=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 00efc25bd57ee33c;
	Wed, 16 Sep 2026 02:28:03 +0000
X-Mizu-Trace-ID: 00efc25bd57ee33c
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v3 01/11] mm: memcontrol: take a const folio in
 folio_memcg() and friends
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260915-folio_memcg-const-v3-1-c239a6010b58@columbia.edu>
Date: Wed, 16 Sep 2026 10:27:41 +0800
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Chris Li <chrisl@kernel.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>,
 Youngjun Park <youngjun.park@lge.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <FE95C2D9-510C-4588-84AC-4AFCAA2D3921@linux.dev>
References: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
 <20260915-folio_memcg-const-v3-1-c239a6010b58@columbia.edu>
To: Tal Zussman <tz2294@columbia.edu>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 91D481C0003
X-Stat-Signature: odp8hwhdsdzkuerra4ioh5d84tp31bww
X-Rspam-User: 
X-HE-Tag: 1789525685-741205
X-HE-Meta: U2FsdGVkX1+2Y7veBsO9mPxjJ8ZQH2GznSf1I9byhNSCJR3s3WNi52KppGZKfHMle4dzOPjRSDZ2CoSwUt22sGiDidJh1VSdLERqs/Q1Vg5xf1LrVAlOzN6AsYexgiuj6hcGPP5qnKKzoM26taMm69ymEf8ZNib03/GhQUuok2iqKF72vteIo81KuEyxFGtCO4Jum8Jmmam1kp8P7Maj6yJeSbVwT5m8LYYIzmaN8HbW0DudEUf8uDGq/R71X7VahaAYEGn8aitxfsAs5NZtXKCdEybdjnuD0iJLSWn1Vvar15axTpDvTkRm7f8dJ7Td06CQC0ZjK3tO9iOyr7V1zN0Jm3+zAb/YgcVbtPLGPJMlsKcnEdOQSurFrlATH2vrPhZWOFA+tS/VTsuFbxXLkOjSpsFT4o2zo74Y4K8oLasLpTL+EQ29wCzpE/2I+0WQnlKEVkfX2Ke8m9wYefrT9bXkYlTXrLysRf+r+DNlZRFe04hMbWsH7o5YiRZ25x/236RPentfJkflEtlKAb99Xps+YWul9CEfMfGuQE7PFfPeldK9c+/NVhlfxt2gzpMDrtV6UqEGStuA5OJyVx4esz8sfrD/DpPXiq4FDmVcNtgivHoojh1jdpVqPqZY4E8SFCaFleg49RX4UgYIfZdr7eeaxXFOc3R02RcC/QPmpSIw2xO1IKNa6/DDyLp34KgUzC9ogN9vqm7I0XluDDs/AjvQb+dbPYJB3MaJjLIU1PQNidMhXF7IY0Scpnly+ifkCue0pVf6h+Zf1UEpQttNNtctIrk6wOerH+IBT43Cug1oYeUyCqM2ANzMUc7XaCOLQ9nCaN7g4RFp9kvhLg7UF8XoONARC5nAZur4iQNha6rwtHrNcYJ1c6R9D5anPHXjayxoKXF4iRbtavsW1Z41W8vMuvqpp4UIn6PjJftQvoZfIB4kDa9S4EwPN9vpuaFhG/QUbTqgeudHUiwSSlI
 G1TWwN/j
 6l8E/UaJpPEcfF0uaECfliGQK3jWjjoxNgGMCi626Yg2W12wZkPS3vpYWxMfr2/yDBztqt6x+q0JgGkshJYNVSOCpk6+qBFaVzbELXd53No5qLTMrLUQfbDWXQmptkGpDotA3YDfWumU5KHPQWSOk0kNWUfPwCW704xgzoW3cmsOHUQkTdnoGdwdPNP7VmlDgMAz7rcZGA1Dh/gRL1LMkrItrAkN6ow04yIqGbUcLgrc8mgbjMXyPCGSy5hfK9THLIv7FB2En79hDbEIpydhGNdddYu64/FeEbI6/r9ZEmBsmaIGBdOpHTTtFGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 16, 2026, at 07:20, Tal Zussman <tz2294@columbia.edu> wrote:
> 
> The folio_memcg() family only reads from the folio, and everything it
> calls already takes a const folio. Constify it, along with the page
> wrappers built on top of it and get_obj_cgroup_from_folio(), which only
> reads the folio's objcg.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


