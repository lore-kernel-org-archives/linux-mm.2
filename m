Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 730BBE83EE7
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 08:57:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C33236B0089; Wed,  4 Feb 2026 03:57:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEF976B0092; Wed,  4 Feb 2026 03:57:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1DEE6B0093; Wed,  4 Feb 2026 03:57:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A238A6B0089
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 03:57:23 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2489E5A89A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 08:57:23 +0000 (UTC)
X-FDA: 84406170366.03.26E1F19
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf04.hostedemail.com (Postfix) with ESMTP id A165740002
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 08:57:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="D7/FWOh9";
	spf=pass (imf04.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770195441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RkVeShES4B2VgCiXTgzhTlETaaAj+olyI2gU3ClsRew=;
	b=jAjuQUG32pLNR1SuXwyF79asLptc1osfMH2votQcQB0dqaVMyVz9h0TbqU/W0iI5EBWuie
	6PVOkWJ/yLlMDL2M3XsTDDbT70bo426fIeH2dCsHbK+rRPTUCQ4iqjoSKX0Yflpv1qBE3e
	Atyqa95pawv1j4H6W4/wLd7uC8FPZys=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="D7/FWOh9";
	spf=pass (imf04.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770195441; a=rsa-sha256;
	cv=none;
	b=E7Mr4uNzJPGetQVl+OOc6O61JuvPkUfeSW11kMN6ZlLZVQAQ5nKZ3RrpXdcW362+RIZRWZ
	rphrh3KR9Z8I80ZnDo5AS+ozV7sG6Y/2iNBXEeA8vKwWOAhQsIwCmMKyC8AVY6ckySRtyN
	yRTP3dG4tReODs+1wN2UON2w7zGUE4U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770195439;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RkVeShES4B2VgCiXTgzhTlETaaAj+olyI2gU3ClsRew=;
	b=D7/FWOh9l1DyX+Qf26vxbeCh2yggZ/LsRQp/mMd6MyzObyeg4wGjSqb1XcEcTsLRYi5erZ
	rOVzmzbeq3IOH1k3GS23YfnHRHG8+d6MLXLu05uovdPyJ1QtDtaiLSzvn5QoMGrk1X/r+E
	cxPsQgrSMoVYWbKH7DsWymuEm+lbcWs=
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
Subject: [RFC PATCH bpf-next v6 01/12] bpf: move bpf_struct_ops_link into bpf.h
Date: Wed,  4 Feb 2026 16:56:22 +0800
Message-ID: <304c85b2bd8b5660f96e6abda262793243281076.1770194182.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1770194182.git.zhuhui@kylinos.cn>
References: <cover.1770194182.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A165740002
X-Stat-Signature: n95edjcgk4iybuq51ndhd9r74tti6y9j
X-Rspam-User: 
X-HE-Tag: 1770195441-165435
X-HE-Meta: U2FsdGVkX1/i/xP9HfuoN4eFIvmc8obERZlT3BDpBIUe2rPugUwYSPUCAUnINGSObsKJZ2CCOaQS3wgpoygC4+IZ5e2F98oGzqeNoaN3uzwJrriupazS9zS0FNQoEVbw5DtYZ5Bjsl4yFckC/yvsmolVcy9by/VyklbuzuRNblhI1XJ4AE6bf8czxM2fxOL0JG5gtQlPdK+VXGUFIJ46rL9a4B4IioTtq8rLTY7wwPL/EjDUL+cA9q+oIod7Z+ZRDg/73qNDF1ebv6kLCkZHs02YZeZj3NWj7TJMIw4Zay5Jl/BSc2MOrPUtHPA2pVfwb0gtnzxmyZwHoweF0hkH0njmyjODOSmoQUJiL72F+L03yjWtiE00VWmPXF2oEVk9S7/rc5Hfqsa4B/SWoDS7N5iAnvczui63bfXSnVMyySNaZ4HK79SmBG2aMfW+OSSvwJwgeX4Zpd01+9LKhBCksdJVat50I86yGFKIm/VHdPTLCYOfxNMyz4a1ZReP4xCOnUQZ9fj1oJt8N3YAF9a0hAzxL/HP5yHbuXOtjIadx6zI8yozE9aPh3IUkmlet1X+JoDVwoJRYGFTD/FlpSEtdUrmF+h7emJ5v/iuFFhVVsw/J0GpyKmykfZAd7K9jGm7cZIUgWkX4qH4fekr0tmPSaqWod3Q2WcA4QHynhTizkVTMS3VfJ8gD6ic6liGuVIDC/ZrKLTDuRrhC4gJHq8KMO6TGQ/BnE7gXnb2iOKFng3E7l/WGH0lUHLKWG1jWPtIT7PjtIJhCpYCFGuCwBnFechTrbAVOj7p6MiL091HV56/MAFnWSpchgkxIwRUiH6qRev90LylOjiloXR69b1+bEw7yuISovRRy4ggmV1wnsGQ7stDIxZfyifloFv3+OcKfiRA87NciIMVr8PatTGzNobUYQHVXFEN2Gd6/PItQiX794aAhxYLXwP0Ar72UW/P
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


