Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53FD4E668AF
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 04:13:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8F346B0089; Fri, 19 Dec 2025 23:13:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3A856B008A; Fri, 19 Dec 2025 23:13:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A740D6B008C; Fri, 19 Dec 2025 23:13:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96F806B0089
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:13:16 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4B24316035B
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:13:16 +0000 (UTC)
X-FDA: 84238529592.06.3FC8484
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf28.hostedemail.com (Postfix) with ESMTP id 86FE9C0007
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:13:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NAFuJG62;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766203994; a=rsa-sha256;
	cv=none;
	b=UxonqyyQW7edwe1dM5GbVSSDYemyLxvaU7PrLY8cpfMfAWCOFby7gIVfFT7QNl7ZX+lKR2
	nNOfIa/5HrRAsW7A8HIIVhtOkGMh4P+Gb+NdiJTS3QJeEFJC/57Aa8jgKIaWQiBTIaukfl
	rRsacRbn2+pKjUf1/arYpR3W1QCzk0s=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NAFuJG62;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766203994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bPQTxbjOsUH1fDrPgGNgOPUx/ZBOkWfSHpGi3Oz7pPA=;
	b=sZxNSqYWv/jBdazS3nR15phph71ZBw148ZN0aT+tx/YJskkgHq6p0HkL5ZvzL3iGdpefzq
	8edz3g1C7JCw0tgNHGqclMdC1j/A4bfkI9MjxotDjBgm8DlIoOw6716doLRXAGY6WDF/Ha
	ZY+r57QvV8t3oE3Zx/+R+20NsYashJQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766203986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bPQTxbjOsUH1fDrPgGNgOPUx/ZBOkWfSHpGi3Oz7pPA=;
	b=NAFuJG629yY6Nhfr9Us/v7fJyz37uH4uunecV/tadsZ5GP8rCD3f+908GyEqk3QU5C5PSP
	nmsFCXDBYgQit8pWulqlilS0o4+Z9izosHwV0Rxa6F+P5Abq5fgTpU+Vkrel8ZGTvyUTPy
	H2KuQ45lM144qRyi1uN24A/LTj0vQGE=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: JP Kobryn <inwardvessel@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH bpf-next v2 1/7] mm: declare memcg_page_state_output() in memcontrol.h
Date: Fri, 19 Dec 2025 20:12:44 -0800
Message-ID: <20251220041250.372179-2-roman.gushchin@linux.dev>
In-Reply-To: <20251220041250.372179-1-roman.gushchin@linux.dev>
References: <20251220041250.372179-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 86FE9C0007
X-Stat-Signature: qokxper6jn9zifnnnmy3bj17gd3mud39
X-Rspam-User: 
X-HE-Tag: 1766203994-944128
X-HE-Meta: U2FsdGVkX1+3wWO/g1QaVDXoIKMOPG7V1jYPvKDvt00YwZ3hkGXjRRmVhaTzfY2lSWdCnXxFDOg3y5+xicMiovK84ZR8UvpYNM4tS2CNYF8OixWY1lXxf7S5io4o3N0wp7RzMAMJ7NOqclrZtGH4Q2b/GLuYy9vFubAgGcgoAZd9Po4aVD9bnXgiWso3qBOKQNTH1/Hwwzph7mOfN923QNR2KAJf0I0uHDFVcabBukR1FAxwHdrYL1zHFgEyCy2hVI81g/Hv3wxOYcXeL98ZdrqGX+T66uH8BVBdvqfeHgPdhMQVF6mVY1yTQRyhxM2SbLqC1tncx5vB2M1FpHACcg8JIC42FFsyEfT1MmQq0JAFv4VJrxjr1Uw0x3SLCNH0Ox+UvVYBdV3to5RPNGcqBUcDtB52AeJ87fkuPbL6tEU2Gxj7zD1W4yige1mNau5hpJ4yhqQpZxyM2jvfKiUK/QgW+Iisb0kJYUhOVEJ2fPZ/Mqw2Yo/czINJadX8/OFKTeZxgnEl5Mglf4w8iNYs6n0hNk1cvX+2yzBfru4SY8xwhcnSatLbspsNO4x0MZHpeXpBSph0ZoLXUk987QP5YLbL4PqH61pNoKGHI0ChUVQhAMD6GCJgc+aQv630eiZR+PSpccotORgMpHRjWxHxrrSB56Cmuq/zsKpblFZI6Q1B9tGU9lz8BJZ6e8J3Ca7+nVRqTWjlIUG40ycvtlzHGyZxC7G2d8RD/EXnFR0LTDUXRjl/OPS362D1FSEaq+MiNpImS42OSYEGjvJ7X7qq62R+KK2F/HUsJHnHKijqNwFSI5gEGR1buiBTP1Pwqy/ZfZPjYV1A04vuq5+nU712vuck547FaGmrjpPXqRjkmYETuCTOJFCgwwdsW/Kf7CQF1A7jlLBiQvRL6mdeXAUJMbnlHIESn0q4ZihrNJisv2/BdcKg75IQit+JOuux0ytIX6Wq6he+Y4cnpfTNYww
 C/BWeLGo
 FXn4vUmRMS8Icyi0HAm49MV2s2psYSAA1V3nU7/wGYjh3/cs7d2mYGMzFC5A4YQgCVpLVI2987Rkr00+ZtYeSgMc8SqVALVn+bbZ5bEBUfkCaudWSXPUmCTc5j3VLyJn8TTOo8oPNMmm54S0K9Q7WGafdsyXkDwu9gGH1crT3VEnA6Ez5sSuJHmL7GiJwlC2t+WZcLykEyDcXgNmTquSXLz/tO1TYvBJxC7BBwxuTklUNdCn+YVANrQ0AhAFgDFTIbgnm93bxZh78FWFkTo/F6zDlhfBZuwlRTMvrIZIISV2SFpvbev+ZcmICugDvoyR+NZq06Tkm7mHN+Or1j+kb4VbA6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To use memcg_page_state_output() in bpf_memcontrol.c move the
declaration from v1-specific memcontrol-v1.h to memcontrol.h.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 1 +
 mm/memcontrol-v1.h         | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 6a48398a1f4e..b309d13110af 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -950,6 +950,7 @@ static inline void mod_memcg_page_state(struct page *page,
 }
 
 unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx);
+unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
 unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx);
 unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 				      enum node_stat_item idx);
diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index 6358464bb416..a304ad418cdf 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -27,7 +27,6 @@ unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap);
 void drain_all_stock(struct mem_cgroup *root_memcg);
 
 unsigned long memcg_events(struct mem_cgroup *memcg, int event);
-unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
 int memory_stat_show(struct seq_file *m, void *v);
 
 void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n);
-- 
2.52.0


