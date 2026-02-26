Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B780EFD9E0E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 20:06:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCD216B0138; Thu, 26 Feb 2026 15:06:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA3F26B0163; Thu, 26 Feb 2026 15:06:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD0456B0165; Thu, 26 Feb 2026 15:06:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B77A86B0138
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:06:23 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 776DB140113
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 20:06:23 +0000 (UTC)
X-FDA: 84487689846.30.B7E90DF
Received: from relay.hostedemail.com (unirelay09 [10.200.18.72])
	by imf06.hostedemail.com (Postfix) with ESMTP id AAE03180005
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 20:06:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772136381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rs9phl7CZvkpvyuP0IIhlSI4jujqBSi/WWAKbzIQYsk=;
	b=DCaMuwt5y1KOzQ0LXqvgHjCsgZy+gEEZva8XrzuwlH8Mm6wB7MQmwMKn5IqY+ddhFktu7G
	FuizJZYrsWM+s5iS4Ea8916Fv/SLtH/zSRT/YL6/Tqr78ygeYP7jxo1mLGn6ppqc2/FJqL
	a/FK/PIKfxnFIr2clLmxwJbJgi1riIg=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772136381; a=rsa-sha256;
	cv=pass;
	b=E//SUYCMH8uRxXUH676DO1ml+IIn+p7hy5cn8Zwgc24L8rx8v0s8UuimU2sEz4HpixxbMw
	md8ZGPif3DbRghyHt2rVu8Bp7Qh6F50nNMFTWep65uHM7cefOD3/1KNo1ncLf5/8laemHY
	kveuT5/MmUVv0j2UasXo/QtkgdO6ZCE=
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3460D88415
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 20:06:21 +0000 (UTC)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 11915160186
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 20:06:21 +0000 (UTC)
X-FDA: 84487689762.15.D41FED3
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf26.hostedemail.com (Postfix) with ESMTP id 619F8140009
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 20:06:19 +0000 (UTC)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772136379; a=rsa-sha256;
	cv=none;
	b=20TJHUhad5H3uOTktI8kqqRc96J+IqvlWMk+K/cmeRaY1kcM/Gr5GIP+ANUeieP3eaCaPW
	YRJZTW7AL7PAcbZz1fWtGcm3wiFcip4PB2YQmpmtXqkVuUnf04PkGSuPqDI2OwXOsApXF2
	zx2I4yBfMFd4S0KuO1PV+YwbWcbeY/U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=orHl8mid;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772136379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rs9phl7CZvkpvyuP0IIhlSI4jujqBSi/WWAKbzIQYsk=;
	b=nnQGwwhi/27pAnV2uPf+upGZuP17zisjkvEhdvxP3QozyBEDUvk7dz8Jd7V/rO/w4z/yzO
	GYL2WC8BCmTXCpH0N+isul964O0KBAq7X6Zi4wnopjCMmAaedwEX7VPxJyTl5c8ZmNAtrW
	Uv/Kpn95Zy3RgtRiGx+hOhcxpKnknA8=
Date: Thu, 26 Feb 2026 12:05:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772136375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rs9phl7CZvkpvyuP0IIhlSI4jujqBSi/WWAKbzIQYsk=;
	b=orHl8midT2uBXGfRsOr2njRHvvNwaJQOJxd6xzi+HlP7ns9d24jSabNuhSMVsgF/5A8eAD
	edn6NcjIBNt+DuaQK91WZ1tfqHMII5n1FfROxXnXhPSsmmZx9Ixfi1DVOI2d9mtCPRreRy
	G6h/hIlv0jKp6ctwaa3sZXskEjI+8zI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v5 update 30/32] mm: memcontrol: convert objcg to be
 per-memcg per-node type
Message-ID: <aaCmpSNRZU1wIYxq@linux.dev>
References: <0f915487ffc653cf6ea19335c21c01aa06004641.1772005110.git.zhengqi.arch@bytedance.com>
 <20260225094456.74145-1-qi.zheng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225094456.74145-1-qi.zheng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-HE-Meta: U2FsdGVkX1/Y0zhKEZtGPtfgEizEvcnG1WYBmVTPEeQr1jSbXcfH2ML9TZsejCRGy27XE4/4Z8OYLd561rETnPoqN6rjmeJXg/f2vx6MalzFpPze1ThP2p3OAlns3yQLuhg/VAv+nod2muP6Co+Xa3t42gSjBVRMOI0+wc5DVXqXvyhclxNT8IWilg+aj+6QTN0GrH6uzpSdxeLuBmGH/O3d+bd+jmIPf5y3/t1MBvhc67RkB3Oh48PZS0oUyfOTdl87KiD5qlf/6BoyzLd5nL6tj3BzvA2ORc9RzdUWSdlhfyEM/PQ93lMLqy5Yo3BbRYv7Y9ZKHh/bb1ebOXE5LgDgLYYFZiIthTSqnkoVTFjVcfhTHGt5KCfjGhxse3Fx1usMXP3nb2u/NuMN3tqIEIVEccXPResH1z/k3zUcfz93jlIzs2r/zVyyblXA1eaazt2VgXu51h7FjN/zzgDIBg2DoyAS4+fRgeCdsbNMP5MOOgh/nFJMf0XzQh8b7SFWDINJU/r+ZtpfJXDc+6tCXE4RFQXHYkdOl2GEzC4aRbzGNK3SQykWOr6jFt798KseC8M0y4Du70vz7x7q1eRU6yc68V2hW52c3cBM+VMbO/pnY4yY25MhAEl7wAa8t1YkjJ+LEcQ+ISlWKUUWEA5WMhYjm9vKo9uPHlwGNkoMUvoqyMSD9yZma8+BQTin6gWeXWmHWWSKswcAHjVSwKPKA3znrRoN4djQuFBuzY+N1b+Vjo2JL3kGZMUEpyopVvgvEI5hOI2fBgPNrEbNuBGwAcnAvnAtkNLxUC9+hFJqIiE1kTvJSjjXhlIA2OqZWbvNQk5VWJqHvAQt23b7hsKyG7KIuiSwf1PY2ZkHTKXFFf2rsdstf1TgBQ==
X-HE-Tag-Orig: 1772136379-465799
X-Rspamd-Queue-Id: AAE03180005
X-Rspamd-Server: rspam02
X-Stat-Signature: inhxyfxugkhirkqnqmyq6uqwi9qcth3f
X-Rspam-User: 
X-HE-Tag: 1772136381-462042
X-HE-Meta: U2FsdGVkX1/U6ze2D1b0kp70nRVpcJFucjNvB59q4ahtmBYwrvv+EjBaj5lm4obdH1zUmtugx7fxtPD7mxP5Adj5WqOyXYZ/Z2INFhLj0AnSNkptIeNsHKyGjsiuqCZ00jnTGPudvkgtbDVcwIOYUvLJzz23Jn5ouKTyxYzACMr713QnAHkpOWqhrQqixxce7twGXN2NIcer4ydZL8V8Lw4lI0JbZksPMMSnaZM+j4B/xadOrvA+2plcwaYdUL7DiGCfaTUrPkCfKOXLrJZJrylSXDxYTF+8WfCI1zsQRWl3nzcJjfdcnGijqOl14I6WUepQuX4Na4Y4sfpVcyUKnsxlEooUmnCSA+UGjoCnTWbprdAFH+roG5OsG8PdZlFKPcDS+zhomMdBSBvLrIUxQsij9u2duVfY1+wmBFYQeaH1LDotk4Kz/j/m6LH++MnTkapidVO6aowiLPtcTU7uq3f3yF/rSunA8GpwHURhk4/ZtxNVp8upqFNvFoHlzhhf2/tXen9zEpLXrN99nFJi/iJHG+6vTkKgbkJqQrcR4T2VahFGhGrXPcMEhWTZGPi56S7dsoBKD7GHjIqc/L8IAnDK6XQymmY8SePtQ4inpUjmqvu4e58Zx7ofJOCxu0iUcSenOcR3NxnTnRfKQ8ctdHKfzzEveu7Fw3Y0Un9JDHsJZftx4XQDSjnQVrisQ8kwkwerL+nti9PZ+l/0PYSHcy/fS0wN+LluhJL+WpT2oUaUaKp9MpUGZrHS7jSpriPzxw69s9BE8bVUls3q90zG7jFO1nF6tgOkvZ25o1DHlf12C0suuvr1EookX5pJ5qNDgv3OH6aMigU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 05:44:56PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Convert objcg to be per-memcg per-node type, so that when reparent LRU
> folios later, we can hold the lru lock at the node level, thus avoiding
> holding too many lru locks at once.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
> changlog:
>  - fix a missing root_obj_cgroup conversion and completely delete
>    root_obj_cgroup.
> 

After this patch, do we care that page/folio/slab points to the objcg of the
same node as them for a given memcg?



