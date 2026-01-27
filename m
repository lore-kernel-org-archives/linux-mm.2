Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08685D2D8C1
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 09:43:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7046F6B008A; Tue, 27 Jan 2026 04:43:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AE6A6B008C; Tue, 27 Jan 2026 04:43:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B0BC6B0092; Tue, 27 Jan 2026 04:43:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4BABB6B008A
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 04:43:35 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DE6C6C35FF
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:43:34 +0000 (UTC)
X-FDA: 84377256348.30.934B876
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf26.hostedemail.com (Postfix) with ESMTP id 35131140008
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:43:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vUqg2TQG;
	spf=pass (imf26.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769507013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RkVeShES4B2VgCiXTgzhTlETaaAj+olyI2gU3ClsRew=;
	b=Ur+i7iM0lvAWEbToXnFIAskG0oCuqiOssyB2kNCqzqZwidy84Q7BWA3+gkBtpDarbZtQci
	yZhgAhLsGUd3NHaPVvOM9uK/J+TGQ6agktCOF2rvo8eT0ncWFXwjAatK7Su75aQ1BVZJ70
	Y00MsXyrtzSe7XPxehK6YPCljZnfvn0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vUqg2TQG;
	spf=pass (imf26.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769507013; a=rsa-sha256;
	cv=none;
	b=1B1tGE+dOdc45bkKbdCDh/6xubzFM8nYiPKLO5v/xmO3LNaZL27H3xZ3ExxCJ5hi7LhTsE
	qaeRAqdSNO6CDkLWAyP7AbxsJsrVO5ZJBMWvQTH1/InS3ci7WIYuth0Pugfek7FJSmUxsG
	rIJXDxtihbzMGelqDa/DZGnIRjO8+04=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769507010;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RkVeShES4B2VgCiXTgzhTlETaaAj+olyI2gU3ClsRew=;
	b=vUqg2TQGgleAvGPxg6XpPWj0hk+VX3LBsQJb5GxaEMooMNP/ieKchFW14UMkjxRPh0Q6a+
	r1cWOTF9Zw4grH9/KRuvlSn+G1E4enTMa1Zz7X/x7mCHk+mujGKmLYodR2iDlRzqHsXUHV
	e2hnU95tejeSh9IVMOfF/K+2v8LQ8k0=
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Hao Luo <haoluo@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Jeff Xu <jeffxu@chromium.org>,
	mkoutny@suse.com,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Brian Gerst <brgerst@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	davem@davemloft.net,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Amery Hung <ameryhung@gmail.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Lance Yang <lance.yang@linux.dev>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [RFC PATCH bpf-next v5 01/12] bpf: move bpf_struct_ops_link into bpf.h
Date: Tue, 27 Jan 2026 17:42:38 +0800
Message-ID: <3a6694566eedbf17f84dbe5ffafe9aa0aa32108c.1769506741.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1769506741.git.zhuhui@kylinos.cn>
References: <cover.1769506741.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 35131140008
X-Stat-Signature: 558up47sz5eybmfqiggb9enhikej79k8
X-Rspam-User: 
X-HE-Tag: 1769507012-742752
X-HE-Meta: U2FsdGVkX19PDRRPUEJAlmFdOeJAAETY09dyjYOVy4SBGW78OPUdbOh+Wq/AdEvTu2mQVXD+gmkhW4Oqd5TZQkwwyhBDzBlqMAOkm/elSZWA/7qKvAo5YmNkR7uN9qsNV29aAKMFuLVVMg8tK7sdi7FDisxLbAJkajhcD4yR40zigvEsu2NyYw9BPkT/CoKgHtO81GQ8m5yf110fWiXEOC5zHwyHZ5UNrPMXT9W1nIegeYLYrjgme3QYZc6XPS7hkxka20UTxKOK3oQuSvlfha4j3WzaLV+9d8ogGdjTmqU3zMCm4TRFjYLORIJN8pdPuWV0B+nmX3/awOEH2E249lLLHbWDpQjVUXkSusDnwUn68nPfSK6nlqyYiBh6Gdt4Q8MX5MirWlzLrDK/3XbZLQw7hvz7CcL62yLs3AZlr4upWxAcOB0qFVojV4Yu/3hwUpdiK/uhjA59+P7mqhIpch9oQl+Rh1REec5w6niO6FDAa062Z+aUfkeaop2jLqsUUClXgxvkYxy74u4QZg8/Y9O0kKPFGM7aWi+F2fxll897VLygdS9vbQ4ybexrSwlqPBb0sCPWsN/AFmZ6BsPKweHfxPZMP4Bghhx/TQdbKNe/B3RUMiDEV3Jt9FlNgFcxDJMWo9otXtfYguIgo2LQQq9o7BjQzwPR/M3SPZd/LFFrg9DUgbCJiKGMxZ/bvrLq09cZQMzFghE1YdYlVsmkAf2cCzrqw/fgd4u0pjsBgXhvmUghKY5g4T2N9irQX3O5x5bYWhaFvMoB7sIc02iEeRfsW7j3kVbaVcvPNo50GR9zkZxC/2E14fJWnJlK3RP6Kp21xOyNC1yrQ9b5M4vPUvLpPAnk2pSrOgdMx2AmLPFI1bcAz3+Rul3/HX5dzB8a/yjFPP7RnipYNviAiJ9nr+eURoeDSo3zIJ8h/+DI9qTOVzQt2ldoFpiXiHoGMXJzQL4wmtsAaingXcKHqfa
 Koi48SXa
 1n/N/eIpL+1kRzZn5kSf9L9LH/Sq6zA1sjSu0JOeC3E4d5F4TTXUVVlPjX4l4e+yYCLw2ONUOCVv+ApUva7bkeDrhmxmI6Lmp3X7W3ZlGY+PaolrD6xgNfi6dgBnpWnCUSYmH42uw4E4ez1Hkdkcj2I25jYxG2gKMoFsxYrzoyXq27UJQteR5R/kIIIXSINSv486PCD1qSZN8hxQppnYtqi6DyHdlIsGmfE3ZveX6Ifx8Wa7MK1h80ma97UycyOuxwgM00lNjq5NaSNVZCeHTJTCuFg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Roman Gushchin <roman.gushchin@linux.dev>

Move struct bpf_struct_ops_link's definition into bpf.h,
where other custom bpf links definitions are.

It's necessary to access its members from outside of generic
bpf_struct_ops implementation, which will be done by following
patches in the series.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 include/linux/bpf.h         | 6 ++++++
 kernel/bpf/bpf_struct_ops.c | 6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 4427c6e98331..899dd911dc82 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1891,6 +1891,12 @@ struct bpf_raw_tp_link {
 	u64 cookie;
 };
 
+struct bpf_struct_ops_link {
+	struct bpf_link link;
+	struct bpf_map __rcu *map;
+	wait_queue_head_t wait_hup;
+};
+
 struct bpf_link_primer {
 	struct bpf_link *link;
 	struct file *file;
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index c43346cb3d76..de01cf3025b3 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -55,12 +55,6 @@ struct bpf_struct_ops_map {
 	struct bpf_struct_ops_value kvalue;
 };
 
-struct bpf_struct_ops_link {
-	struct bpf_link link;
-	struct bpf_map __rcu *map;
-	wait_queue_head_t wait_hup;
-};
-
 static DEFINE_MUTEX(update_mutex);
 
 #define VALUE_PREFIX "bpf_struct_ops_"
-- 
2.43.0


