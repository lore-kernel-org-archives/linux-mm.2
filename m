Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04370CD5BC9
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 02:21:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E5156B008A; Mon, 25 May 2026 22:21:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BC546B008C; Mon, 25 May 2026 22:21:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D2176B0092; Mon, 25 May 2026 22:21:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2CA386B008A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 22:21:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CAC761A0250
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:21:07 +0000 (UTC)
X-FDA: 84807968574.18.E6F8F8D
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4254540008
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:21:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nCyySfK8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779762066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N6lb6S73FS1qu+rJyvkj2xvcDjRxUx8n4aBkU1vy4b8=;
	b=h4z1WN6uIKYqOLk2gLZBKIMWaiqPDPRKUzaFGXOBg2Y90+CkquKbZXZH1M0Jfh3TkMEVc7
	C3PGVJsCVc5tsVxm0fHwec6eFweiWXeWShBjkmCrvCe85Ii7dniKfGlmwXAh7lPPDa3nsI
	0yHoReJ6A/pTVBjnkmzLrF7F+/MCwBk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nCyySfK8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779762066; a=rsa-sha256;
	cv=none;
	b=1bWQisBGCssFhu9vs/pnlBoPsaIjvaJY7uO/7Ja5YFO300gAv6CNPzL/cLaylml5L+9eK+
	zGcIIewCBhrg4mS2sV1snKWvlwkRjPORugx1csFPx66mQu1vDLfXZB+5cORHuNhn7bz+vX
	UHkBA2ZIMQNyeSIzCPMAkfpmMF9LtME=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779762064;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N6lb6S73FS1qu+rJyvkj2xvcDjRxUx8n4aBkU1vy4b8=;
	b=nCyySfK8JImDMjF+2Q0D5xtDEA1316DcKRfpuhoUv7F2U8I48894ytYteI50/nwzQVfPSt
	zXWSLi4FEYDV4lot4zHA8boMeiiTiUVY0youPBB3dkxT5juQZCcBWQqyoZ5X16KSXwvoCI
	MnIdZfKhwwPryfLftmuQN5jBLEKdBUU=
From: Hui Zhu <hui.zhu@linux.dev>
To: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	davem@davemloft.net,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	KP Singh <kpsingh@kernel.org>,
	Tao Chen <chen.dylane@linux.dev>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Amery Hung <ameryhung@gmail.com>,
	Tobias Klauser <tklauser@distanz.ch>,
	Eyal Birger <eyal.birger@gmail.com>,
	Rong Tao <rongtao@cestc.cn>,
	Hao Luo <haoluo@google.com>,
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
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Lance Yang <lance.yang@linux.dev>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: geliang@kernel.org,
	baohua@kernel.org,
	Matt Bobrowski <mattbobrowski@google.com>,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH bpf-next v7 01/11] bpf: move bpf_struct_ops_link into bpf.h
Date: Tue, 26 May 2026 10:20:01 +0800
Message-ID: <909faef088325613d895235f9c02993dc51e5ea3.1779760876.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1779760876.git.zhuhui@kylinos.cn>
References: <cover.1779760876.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 8b539nngsb4x75fokxqejpmbmmguojpk
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4254540008
X-Rspam-User: 
X-HE-Tag: 1779762066-71283
X-HE-Meta: U2FsdGVkX1+gs9WiD62v1lhtEZqE9agQv23RtsqcTvRafvgoUSoMOP8Ridikw4iBrrnMMJbZHys7ICL+sZ94q0h6/xI4ekNnu+UImtCW2GJHAG/MV4xsLUsa4GNs2pxNvNx2nIyirJTceTXu6xK5MdtPJ0inxlWWSG9gccy23AQivYj6DbtougbechyPz4VS3dR4PT80BoC7mSscLj3k1KMoFI3ENaNkks32MgJjwHwgvwng5xUk3nMFmy0YZn9OJvrjX5/BbNLMDP6aSLvETkGpTrVuPhC23h/4FGx9uIncFK+QcRk3UH5WxxnwxBHrhpHAo+azVvGhPFNGuLYy9EgR8SMbRq6gRxOsXwpB/K8SNIP5w2+JML+p46Un7xzl9Y/tP8XmiGSUFYTvR4h5YRw9L8WJ1LyMlrdXphsMXL65HrO+zJuccvtNpRIp6hc8hE/Obs+BwIpedhtXM2hjSJWK5jiqUF8fqg+Yo5IIVIWaGFDtnSkr1FM4v4mtCmQBFfFFX9rMEZxWjbCy7sSPYY1gM1Nv/bb1c0miqpNMp2Z9LS0BU6Z4ozDrcOxdwHhGstWLR0WBw0k60yIJlGUGzoGQxGjwMsbfF+UfrGPDhs62TiJPyozffPBE+pSToyoamfZrWAoYS+9hiu6iv9qhT7Nis0EiBpZcTW9hoypS8BuNMXS6C61e8qDpBRKfk3+NGVG7Xh0kj4+ZM/7sT+JG+iwGSiKQCysBbYvJlFcBi1N/Pw6yVuZf3rzJpyiXLE/01LwkACITRqV2nBBRqwaoOhbUcaF7z05+f02hKGtEK4tpPr/+PCCEubbm/4BOPzKUkRsZG113bgmX+czUrd5jleDl/Tjh7sWbavCxl42ymwkM+efvqDOSeu6FO77I5yTCeSo3F6qBrJ0iMIcpdSCT9gJX6MNSGwnZoa7brf9VrdnOcUqij2pMguM+75LdYh9FcIoN2rU4BM2d7nyGes0
 /zfkPZrY
 vH4v/RVizsulXEv4gjuVdktX4OS1UrlB+N52CD80LwXZLpEaq+NQsRjZRMkH9jCdG39LOsVcX9rAgHGFuJRtVJxZsU9vzWFmfmUdKOSeFpEvZBjBisjPI96wrEtxA/fY4U60kgEk+7mKRIDGJCa2pSvfndOj4YGUC/wLW21rYqOpb2NNgRmwnDBaOWlriysezoDB2OxOWr4ZXef/6LzSaaw+GIB4YrphbEduCQBpN6Qwoxzt1LEcORopNiBhsAqfScBflKEsISNtkPIsM89QfZyL0SgloI6+hLSkMGE/ayoDjx0mbwG+eEjYjOikaCcrhaRsc3QQF3rPMwsA=
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
Acked-by: Matt Bobrowski <mattbobrowski@google.com>
Acked-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/bpf.h         | 6 ++++++
 kernel/bpf/bpf_struct_ops.c | 6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 1b28cacc3075..01c0bf5a9cd0 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1908,6 +1908,12 @@ struct bpf_raw_tp_link {
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
index 521cb9d7e8c7..cf3c604d48ef 100644
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


