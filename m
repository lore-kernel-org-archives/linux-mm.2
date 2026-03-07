Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9720AFC9EF8
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 12:27:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C22676B0005; Sat,  7 Mar 2026 07:27:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCF926B0089; Sat,  7 Mar 2026 07:27:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADAD56B008A; Sat,  7 Mar 2026 07:27:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9A4F36B0005
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 07:27:52 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 333BF140CED
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 12:27:52 +0000 (UTC)
X-FDA: 84519193584.18.61952F1
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2F097160004
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 12:27:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=BFbygVmW;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf08.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772886470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uz9X7T/t4Rpp9g+PKOPXwQF1hZ1s/CH2mdGFNaauaUM=;
	b=I04uSWEn0KKPSQ41cxTEpRUfvGDLH736Sc0bOK1J1IJgjuja9JEaHC73fiSqgnrY/wYwdL
	Dqo90phRZ6WTPKgAM3VwNJHHfJ7lD8mRQp6oTSdh7wE+e74AYBv1sYK7ymWAKSECfNgEjg
	QoTVmxIsIGcl7G7Eea0xrYMvjW2vmwM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=BFbygVmW;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf08.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772886470; a=rsa-sha256;
	cv=none;
	b=KtoQOE5GD/UxmoVl2Au2GHX8eli1mIZE6ATeoEiZXSjBpybqx/p35Wr2+BUlAMECJotevd
	A7PBdDHhCakq+pxcdm7nwgTQqyCHnsisH6mlvQGf2H6pAocQ+YoxZvE970uytlvnDBjWJ/
	fyui21LEoQ1uTq00XWL8U3/Wxqlw5Mo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772886454; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=Uz9X7T/t4Rpp9g+PKOPXwQF1hZ1s/CH2mdGFNaauaUM=;
	b=BFbygVmWwgyxC6W1+FidYaehcByVbu9iKDcARy55FEOb4L5bfvOlJOSRXvt8cthG4QXE6OOQ9MGYaTLiAJuuECRehj6Z2e7t2k4NBz6jd15yGxP2sPU1Ua/cFaxXDVWo1YeE/MDYy5icCJy2+TKI6pkSjtTnNcHWNvjhVgAwC+8=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X-Pja1z_1772886444 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 07 Mar 2026 20:27:33 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org,  akpm@linux-foundation.org,  mhocko@suse.com,
  vbabka@suse.cz,  apopple@nvidia.com,  axelrasmussen@google.com,
  byungchul@sk.com,  cgroups@vger.kernel.org,  david@kernel.org,
  eperezma@redhat.com,  gourry@gourry.net,  jasowang@redhat.com,
  hannes@cmpxchg.org,  joshua.hahnjy@gmail.com,  Liam.Howlett@oracle.com,
  linux-kernel@vger.kernel.org,  lorenzo.stoakes@oracle.com,
  matthew.brost@intel.com,  mst@redhat.com,  rppt@kernel.org,
  muchun.song@linux.dev,  zhengqi.arch@bytedance.com,  rakie.kim@sk.com,
  roman.gushchin@linux.dev,  shakeel.butt@linux.dev,  surenb@google.com,
  virtualization@lists.linux.dev,  weixugc@google.com,
  xuanzhuo@linux.alibaba.com,  yuanchu@google.com,  ziy@nvidia.com,
  kernel-team@meta.com
Subject: Re: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
In-Reply-To: <20260307045520.247998-1-jp.kobryn@linux.dev> (JP Kobryn's
	message of "Fri, 6 Mar 2026 20:55:20 -0800")
References: <20260307045520.247998-1-jp.kobryn@linux.dev>
Date: Sat, 07 Mar 2026 20:27:22 +0800
Message-ID: <87seabu8np.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2F097160004
X-Stat-Signature: iek4xybumo4k1fc5gebtdx7xcdggngjd
X-Rspam-User: 
X-HE-Tag: 1772886467-664379
X-HE-Meta: U2FsdGVkX1+Df2f04UMAXS7AZBeKiED+I0Yjz0XmB2PYofHpogkzWpwZYeafuYN8Tfgz+K2B8SuoEoaq924RCNKh9uk/1znJo6IHoADvtVNvKC75UUjfJS4r0HixU7S4jXEpSAH/I38HJj+zXmFXXO19TKw2I1Na5AOmSxCLTy8fIjSyJBzkXPCnC0LlXIsTm00oNGcGhJObr2uP0EdnYQ0tPhfVghou4kxK0ZTSLCytBP8knBGtFlK1EeqdtorwpzNPc8Kh+EHE9+g3yAuChPCtTt6qd2QgNedNq1mC/2szqULvwm6l1hcSL82+rqoEpjAMgBNLlDnLIPKnZW8nArVnRb9VDW/UbuD2ix7M9RP5cEultnqfaDlWEqwn0xjWdoWSQn1+Qb0Dsw4IaUyj0NVChIFM+y15PCrpPs1r6xtKXX1o8LVqlh8cI2n+6UqJTaVk3ZDvtn86qln6rDoep9MUIRGX7BQJZLmaIJDtHxo9VIHF5LA9GYqXkC1O6cOP9iDWRD/QE8y9dUDvXducw4ZgKZtECELCACgv9FVEs/Kn1sdIuv0HrNLaonAn5YM6VnHLQLQkAKpPFV/r8zwK9XBw7sV+P/mMw//rzkuHP98PCr8zFF9L2dBRuNPpflsCxzLsmiRALQn+FXXhts1uKLCgcU0hH7AV3KXusYTECR5p9o87w/UbBIFbQR6xsJeIvw51vbT67bQ4Lrt8ceOSe8KNapwyZSsC1Ervj7mGdTBvbmfTtpFnoY15UVlv52V48LOEDGzmRaBuIJNGgn6sBNpORlOPmBde63BpjPJFfyuFXGeL2oxvWsvinP/SOHDKZMI3Y3ueAdxBxuMEA4ZjOD/VZnBkUtHja/TOIYPlK4pQIU24DlS3uhxKR4bvDavOiK1lMu6AUkEu2Noi08/0ZpUhoNhVT8pUNb0gvgWYQWHrhb2eRCIzFl9ykJBdmJRdeOqhMT2qw7qeGmcPAqF
 PWm7W9XY
 tuKsAF6PsitoZWpBsz1ojKhGHovb9q5V/ubMMfHBF8M6YaS8ZWDk6O3J5FyNmVt3yCnaqmUuePdolFKYoxH6D7jWEt1INIPdrITIlTQi0ZKF6QXhpzNfjk7sZlFLp2SpLLSI96ZIWmAb8E1TDIsRzNlprb/MdoyvZb6/PuM7fv0atBDvPTe1jEAAoUKnX/s86ph+y1jP8wv+8bhj84sm4jdXa7+9F8/oMhRo3eZ7UUOQ8z+iXNWRuij4S6tZ8VnkDVeyi5/FNSsJLAQf0nd3gh0khTvMYbxg7migM3QRKXad3rnlHX+6zCv1JutvjZveQF7UdpgDo9TZ5yansvm9QGOLxf+jakY/AOLHgGAkifuW4w4yBp/IGjJBto3dmMAeLXS03m7LRGvVeFUE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"JP Kobryn (Meta)" <jp.kobryn@linux.dev> writes:

> When investigating pressure on a NUMA node, there is no straightforward way
> to determine which policies are driving allocations to it.
>
> Add per-policy page allocation counters as new node stat items. These
> counters track allocations to nodes and also whether the allocations were
> intentional or fallbacks.
>
> The new stats follow the existing numa hit/miss/foreign style and have the
> following meanings:
>
>   hit
>     - for BIND and PREFERRED_MANY, allocation succeeded on node in nodemask
>     - for other policies, allocation succeeded on intended node
>     - counted on the node of the allocation
>   miss
>     - allocation intended for other node, but happened on this one
>     - counted on other node
>   foreign
>     - allocation intended on this node, but happened on other node
>     - counted on this node
>
> Counters are exposed per-memcg, per-node in memory.numa_stat and globally
> in /proc/vmstat.

IMHO, it may be better to describe your workflow as an example to use
the newly added statistics.  That can describe why we need them.  For
example, what you have described in

https://lore.kernel.org/linux-mm/9ae80317-f005-474c-9da1-95462138f3c6@gmail.com/

> 1) Pressure/OOMs reported while system-wide memory is free.
> 2) Check per-node pgscan/pgsteal stats (provided by patch 2) to narrow
> down node(s) under pressure. They become available in
> /sys/devices/system/node/nodeN/vmstat.
> 3) Check per-policy allocation counters (this patch) on that node to
> find what policy was driving it. Same readout at nodeN/vmstat.
> 4) Now use /proc/*/numa_maps to identify tasks using the policy.

One question.  If we have to search /proc/*/numa_maps, why can't we
find all necessary information via /proc/*/numa_maps?  For example,
which VMA uses the most pages on the node?  Which policy is used in the
VMA? ...

---
Best Regards,
Huang, Ying

[snip]

