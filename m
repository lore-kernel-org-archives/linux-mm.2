Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1BFEE9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 08:57:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4BC26B0088; Thu, 19 Feb 2026 03:57:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CF7C6B0089; Thu, 19 Feb 2026 03:57:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DB926B008A; Thu, 19 Feb 2026 03:57:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 795526B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 03:57:19 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D988416014C
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 08:57:18 +0000 (UTC)
X-FDA: 84460602156.10.716D404
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 40A304000F
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 08:57:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uoGU5tz3;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771491437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h8nRFYSR7MhhiCuppyUDz9suOGzDa9Hbb8qkBoNa64A=;
	b=79rN+7kDYzrh8isqUavXVdjII/HCPYjUl2HWNBw0dJI8QWQOLXal+Es4uWiauDT633fzzN
	iWYx3MPtP1PP1egVt04VfMOZHu9Wc2tzJj5WdwBSJr04lyduLeheDuEAJMRd7E9wpXJibY
	ofTOKpe15i42QrdyhUAIhccBspc4x0o=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uoGU5tz3;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771491437; a=rsa-sha256;
	cv=none;
	b=av2kZRw+ektNlL8H5FSruKETuk/HkRBsgEhXWpKER+R+EboHCyuELx8uPFOn2tluKfKiDH
	xWOtXr8FKZyn8bLnXrz+I56t5n9ElELIg5tSpCcXB+XtDAUlCCY7owVbXgV2fTvqgzQobd
	lx6SwIn+FV0Gr/XwMOEaqKVvwnsB2Bc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8AB4261118;
	Thu, 19 Feb 2026 08:57:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA993C4CEF7;
	Thu, 19 Feb 2026 08:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771491436;
	bh=JnTVAYhQ/P4N0pSZd4qr1+jbOHBcQ58Dr2VlbwxwgQU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uoGU5tz3M9il+NVBLUl1f8VpETmSHceacznaIvb6Co35cHpP+qVovru3BS4N4tt4Z
	 60Eik2Tsmm1P1zsWHUuNeObk6FPcN/SLdbc3MHNF02e028MNZV2hZE1UnPjUVkW6Fy
	 vlyHmi3UD3ViLam90YEjAeI03XMR7T9YK60zMYVCBmQfbyBGGeEkF5WhdO6rdqnAyc
	 O5a1lHVYRj8HcTu193k6TIOfRrifReZPXtaEI/WZUtPBdn/V17e4z0uFzyvRwhD/B2
	 UjlsfydHdoC/g5cnDlwBHVQ0ITUF2u/irftL369I7mvmxjFmFFizHYeHA4PnotRRiz
	 sAEK5Dx+XY7Dw==
Message-ID: <c038af7f-bea1-4270-b423-41fa5939246a@kernel.org>
Date: Thu, 19 Feb 2026 09:57:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: move pgscan, pgsteal, pgrefill to node stats
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>, linux-mm@kvack.org,
 mst@redhat.com, mhocko@suse.com, vbabka@suse.cz
Cc: apopple@nvidia.com, akpm@linux-foundation.org, axelrasmussen@google.com,
 byungchul@sk.com, cgroups@vger.kernel.org, david@kernel.org,
 eperezma@redhat.com, gourry@gourry.net, jasowang@redhat.com,
 hannes@cmpxchg.org, joshua.hahnjy@gmail.com, Liam.Howlett@oracle.com,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 matthew.brost@intel.com, rppt@kernel.org, muchun.song@linux.dev,
 zhengqi.arch@bytedance.com, rakie.kim@sk.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, surenb@google.com, virtualization@lists.linux.dev,
 weixugc@google.com, xuanzhuo@linux.alibaba.com,
 ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
 kernel-team@meta.com
References: <20260218222652.108411-1-jp.kobryn@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <20260218222652.108411-1-jp.kobryn@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ogmddoqq4xkf37qea8hnswgy9ah3o468
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 40A304000F
X-HE-Tag: 1771491437-430226
X-HE-Meta: U2FsdGVkX194YTQhNKFDzcdQFTBZpZd3Za4f1ZW69vk0nWula1JJ6XBqJbJysabMFqM5VCMthW1E4gGqYJVm2pbgR+tVzai8oRvVW8guJW01FoRUwjYeubiBoRDVim49VUVnbzz8+2eBZBWv/Ifd5wyvm5vUDzKBhHo+MAtCMSEx4+g52dIyfB/IzlQyeRru9sDGOhjgUmRm2GNNIvLkvS+r8f1y6+qVjvS7wg1RJfcjGKZZdrXxdwmm+ZFScsqTzjCM0PdPJCOvIohp8NfsimT9roVdDKSXeziDhJY/hwXl16a1AXb4N4jPyeR82Kc6IsWinUAutFZfZFQkuVoM26ANCpuRY1NQzaZVdAae4XQzwLojYrWotydiL2apjkUY6yIIrj/9KU+YTU5hTDPjViRFRuFGB6xXqPU6c6IyvXmwNy7Bs8pN4SrCCAIIgSfhpI5x7jnKtkT+C7IUFrTfIDr4U294+q2/+HmDSQHYYaUjXvLAucKfjDRdyRuFv0dbV31S4OdL0q6Iu3Vgky1e1FR1/BvxFUmBtAmtyBkEX/bZRc/JSeiOV2fEpY82M7/L1p5xSqvoFA9jv75g81eSwnOdHtPgVyXD0gqOa1P/cK4eZERLMkEZHPRkVbt5bJV/51/6RDAEoxUftlqIHyaU8x3tuA4RpmHVbLWX+0i+1mPANAZnGJm4jRxFCVjd3LP0wk8RcOF2US7O+JKayW5UNYNPdKngCVlY3bUdTPic69lwPXtMkKdeKcySdt6lMXeLL+idoSOdIXMIy4CqEB+nDvDySezQ2fFoYYaX3zsAx645LknbTx+w0M3ByRjmbgUnsQzxLNbru6yCMyvBeEBTt+14DXCOeoWsejdz1EANneQ6q0VUNmUqFM0HtVO62EcS/aCxDL22DUMFuzGQ9RXzjuGQWfRX7tgAx0pcAvi6OZ8IFZldUL9JiZX1ubtKI4Vp75sfyb1jiJTf8Dmc98j
 XP2q5z0w
 wixE51ffRksU0iHf/cmssgaKxI1ubmnlss56XGYme1McHjMEVoc/lZilkTK2WLL7SSMrnCfuOAeJkoLa8jLP1YndeIFov0BYAQ+KwRTk/9eusBJVhzPweK74oN3q5iTRbuwMSuV4r7b9NeKXjLd3CqowbvPCafF5bfG5tA55F2OoytZrlzdCHRDq2HL32aXg10t5cnIjYtr1M4K5c1MDCVMvxZrtpikNp8yVmOSMsLjy29zr/8P8qwHvieWu1iNK9YEIHmpEInVNwadOPMa9tWQu4ltB02kJVDYHmrExu6mJaKxnj8HDWUirYzoWT6ZVa09CZMurN42zt3ZW9kFkJi/72hZmn3tDDWV32kwVQrDLdCFcAZ3y/YuedXDSZhoLIzSwfSZn0Dw6jsi0brcbYOzZVq1R+vZj106M3hU16+qRdxFnOfMDiX+k/0A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/18/26 23:26, JP Kobryn (Meta) wrote:
> From: JP Kobryn <jp.kobryn@linux.dev>
> 
> There are situations where reclaim kicks in on a system with free memory.
> One possible cause is a NUMA imbalance scenario where one or more nodes are
> under pressure. It would help if we could easily identify such nodes.
> 
> Move the pgscan, pgsteal, and pgrefill counters from vm_event_item to
> node_stat_item to provide per-node reclaim visibility. With these counters
> as node stats, the values are now displayed in the per-node section of
> /proc/zoneinfo, which allows for quick identification of the affected
> nodes.
> 
> /proc/vmstat continues to report the same counters, aggregated across all
> nodes. But the ordering of these items within the readout changes as they
> move from the vm events section to the node stats section.
> 
> Memcg accounting of these counters is preserved. The relocated counters
> remain visible in memory.stat alongside the existing aggregate pgscan and
> pgsteal counters.
> 
> However, this change affects how the global counters are accumulated.
> Previously, the global event count update was gated on !cgroup_reclaim(),
> excluding memcg-based reclaim from /proc/vmstat. Now that
> mod_lruvec_state() is being used to update the counters, the global
> counters will include all reclaim. This is consistent with how pgdemote
> counters are already tracked.
> 
> Finally, the virtio_balloon driver is updated to use
> global_node_page_state() to fetch the counters, as they are no longer
> accessible through the vm_events array.
> 
> Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>



