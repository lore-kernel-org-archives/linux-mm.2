Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE8C3D72356
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:56:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E10B6B0466; Fri, 23 Jan 2026 03:56:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CC4E6B0468; Fri, 23 Jan 2026 03:56:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CF416B0469; Fri, 23 Jan 2026 03:56:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 09CB16B0466
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:56:22 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C3D721AF998
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:56:21 +0000 (UTC)
X-FDA: 84362622162.14.6F47D21
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id 27D51140003
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:56:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I2mHUI2A;
	spf=pass (imf09.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769158580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4IZwwlsklIfyYIeeJQqajpok/bifebBH8KgsHF7gR+Y=;
	b=6Tl933XRK69hdELi1hck6ITzpG9/9UHoMif5fxf0yCzC8ZMMctcR8A32w/gdG1k8A/G6Mr
	vgv+ol1gXHw3IbPgDRggq7d3W06JtE2n3W37wPskmu/ItmUWUpUy6+yzEONscoCW3wl0FM
	A1Hax57qPxMB7t6cA7ph/5amBVZyXcw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I2mHUI2A;
	spf=pass (imf09.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769158580; a=rsa-sha256;
	cv=none;
	b=5m1fshO5MUWuINiJ60EkFPzmeNVRKc2T/WKvsHSC6QOqJ3r5AvPT6pu8SgP/0SyNSm4L4T
	Q8Fv8IfPOHji2P5jRgwBjjY/cEAu9Sn+sBe3VZIiNm3Qu8dt8/NIEco0JKmIz8+Zl86GE0
	E1BSWUdfJeMmq9daydnX2FFqblnAcY0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769158578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4IZwwlsklIfyYIeeJQqajpok/bifebBH8KgsHF7gR+Y=;
	b=I2mHUI2AYbqOhP0GZVQ7d5GjtaXLD2bXmUkzdEJnIsbrYIYnXnORHCehEq1EhcFDRTLZe4
	lJuKqiCRjeZj8O4b1t5Th3DoiD+cse/Y69dRz5iANYxn/eayBcnQplrZ4hCExPD/EjK81m
	Q5XMWVUkr84piWYFfOv54D77MdMEa+A=
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
Subject: [RFC PATCH bpf-next v3 01/12] bpf: move bpf_struct_ops_link into bpf.h
Date: Fri, 23 Jan 2026 16:55:19 +0800
Message-ID: <6ddaa3949346e2b048b7bd6714d182c96a586d4c.1769157382.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1769157382.git.zhuhui@kylinos.cn>
References: <cover.1769157382.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: bm8dg5xbqhwdkmeazwwnqn73oyfti4a9
X-Rspamd-Queue-Id: 27D51140003
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769158579-38627
X-HE-Meta: U2FsdGVkX19JVfS/OwL3SXrIxW4h9cYDEfRfqIruXGcI8vd2xfOQfQbIt8cNixBBghYV49o3oFjmDdTQjBfRcTw2eEa8PynpsiY8DwhawRf7L3V2BzQjB5GXhU8+i8EOJF0LaqLG6TzobMx1fhfEb0qdyqk6HO8nv9jzB86D5V71fciu0FU51mcjhiBZFI/iiCCbgiTcPeH2F6LvAMukCqD4Lbg/YTusnN4FseF8xiY6WsyPNziUUiZr4VdmUwFapLSRFK7O4nJug2PRu88wZM+ayGRlJSCA4UbK6LMkIrK7H+06VNnqkR2FGlcbm/qjnsiJNDR5oSPClhTZ83kiNNsJmMMviVBNZu6DWarmViPzk5ACjYb/B7poGtSett4OTU0FHmGrK0cnSPD6+ynanR3G1lrwnURuJwk9nNSn/b0EHLAKTrS46p7Xjme7kIXFYfYZOQW6AecSC3JiDzXWPhzYQADK0hY08oauArzcCOGUTlW4BkIp8POWE1HA0S6NHMVBCoA/qRsmXBrQxPo6DwxJ2H75v7SsKzaLcXEIzmHtDqCyFWRKZeEl13knTwUojnovzYvPY048Am0lUKrIopujYYWgjU8iBI+GgF/2cxJ0bRT9P+qiNOdP1CChmwwmbq7/STGbD0PYdRtbAu+2moWThlLTjHsAKF/6DHW6JZaSuQ/v3jGRO8NsQmTxO64FM8DnTuEBxLN313uYb/GZVKKqUc3W2f1aKxyv+IXUg415KQp2ip8h8INV91wohXLGuGBhLWicJWF8/03u9u2xj4EngGkDF33F3rFYWiSllMhUVsdzHygSJFFouD6ri8BU+uPIfuwWHYLmzcO2RcVEA/RkkPxdxTHFuB6q06Q97AbIhea6aPAIgZOpj0U3aFXvNTYOJssSTH54WRZa3+8z6MjNXUG9e8aaqqIyywpWxPE/E8hjp7kAgESkw+yK+7s1TFl1vB4NQQa2OXwFJ+9
 G3Lvfe9v
 xxSIICNE6LGJS6jMo1DMkZgwAAakJ5fKqmkjMlsC2RylWU7HdgGGl2PfbS2Czhos5KD1C7Oh0zZIZRNwtbbl5Tjav0ExhmspW+uIzknDws5d8p65VYxkIwg90h5+JO70SZXwoXA4jgZ88pYHA35kc/yXe/mKx6ENRxDieSEbvFlQsFgnQgJ7A7CnCqAuNAzBnr23klmiMoYrffVZjxXy1cS4lZK120Us/mr6maPPUVj8dt2prSPkksOzOo4aUyDF/zWMTq8hRR9UeB+e33FEwKUg5Lw==
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
index 5936f8e2996f..031682f1ad39 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1881,6 +1881,12 @@ struct bpf_raw_tp_link {
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


