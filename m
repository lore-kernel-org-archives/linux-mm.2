Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B31B8CD5BC9
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 02:21:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 275316B0088; Mon, 25 May 2026 22:21:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24B526B0093; Mon, 25 May 2026 22:21:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 162D06B0095; Mon, 25 May 2026 22:21:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 04D516B0088
	for <linux-mm@kvack.org>; Mon, 25 May 2026 22:21:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B7CCAC01AF
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:21:37 +0000 (UTC)
X-FDA: 84807969834.25.527A3A1
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf19.hostedemail.com (Postfix) with ESMTP id 215331A0003
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:21:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GqLvCluv;
	spf=pass (imf19.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779762096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hNDaNP16Qm74gfq94xdOPMH/X6ONx50Ta9FgPYJmm+k=;
	b=kg6vd6s5D+BbKt1QVI0Z+u1IvUJENYdatiD/xgsEqi9K3TVIMb6l98mHtwXwDf5jKZQFgJ
	U/fgu15LEF1xeG8/jj/G9LH4/Xi5qSSQAE3uFkeWRQ5JmYEv2SkjUghpQtVj7OHn9fCStA
	vZmsmq8keJzHQ1IuMSui2B7oTNdLJp4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779762096; a=rsa-sha256;
	cv=none;
	b=59vozYMlwEVLnNJJXyL28pJ2LdyXAIVUgE9HVBw1QlXGiUlKx1iRzNJW5gW2Ty3qlJy0Q4
	kjeu0tAS7LeuLPdTYctx7gg5Ec8on9tPEXxDzQPYoHgCH77P/rneXs+bJgHaU07tnZ/PcZ
	1TNDz2Cq9nRkSXrOx4N6Mz5h0y6q+VI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GqLvCluv;
	spf=pass (imf19.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779762094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hNDaNP16Qm74gfq94xdOPMH/X6ONx50Ta9FgPYJmm+k=;
	b=GqLvCluvmmsKTWVXkXT9WhCYZ0SDbKpXXvM4VH/Q93rW7GfgAp94Oa9v8Wc8YPld0kd28T
	lp4oBWHvq0K/M96vvb0C/hky2plzX1PDLSTm/K7QgA1u2X03kt8uCk3hnIkbaHVUDXZMrL
	zD8wvJkpcIWT1xRoyAxB6k3ZpDeHLY0=
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
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH bpf-next v7 03/11] libbpf: fix return value on memory allocation failure
Date: Tue, 26 May 2026 10:20:03 +0800
Message-ID: <8bfb7027abcc02c21db565cf52d6af78a6ce5b7d.1779760876.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1779760876.git.zhuhui@kylinos.cn>
References: <cover.1779760876.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 215331A0003
X-Stat-Signature: d1k8fr7rek54i3gsfn58z8pou1fb6aes
X-Rspamd-Server: rspam06
X-HE-Tag: 1779762095-188860
X-HE-Meta: U2FsdGVkX1+pneKvoRlrqGwUIh2+GFkLBljLtoyjHfw9Jj16635HcS9VNi+6X/W+NdXP/LuAirYtgus8MnGqoKsdE8s6AwBb3YyDFQVPvA/6w1ozVHdzu1E0YQuMieHjmjWcmOzElO976/iUsIxdZQMl7qypXMYotNgLE01iEUGa0acntJcnUQsVDGg7N2gIH6/3Z71EKEhip96uWvQctsAsNhlaogUyxPq5xE0kpJwDeehDtW6MDo6saChQVjANWcpvvlbDj6gkUR0beDFMmwy5B1mbyayw6O+7u/rgzC88KWxFI5xyeDeiqpg9Rl0kmMU2gw/KPov7XUgknr5/ys/jof4HBMH2Suk6V+VNp6dSOHF5PvQVKO10wMmqJ87RhljzLtSzj2fzY6xOEnJL3biEHLpksEGG2C86IqJOuAiKRLPQNFcKA8o+qDOY3rvh73YwGjvKS7WNB1yDdc8/Yf3sWgRDaJb6r23GNvL8y+eEfcmUtA6nnCBdbxSm67+2HVFmNumnHlIZ46FmBXC/F0gXvDXHWtS47ofIHm9NDSWXB80wzYCMoiTBiE1Z0ZvaSB7rAJqeJhbiBIgtCE6lwVY0qINKHN3i5bdz7xV9GrzWSyAJwc7WHhOnQ3Y492sS554OMb9Il6bLYQ4hesxoBN6qm8yQSpU9X1/A9h4F3D5bGt0JV20L+UWUzybS0AudkYWFhacyo86HVd6fHHhbIasxDxKcW+XbL6Q3Y5ZdFymv3CNqbozIwRP7xf5EEDy9FXXyFTmu7b4D4/pp9MVy4TjN0uzzvseqhdD4Xgn5LS3/ZRQEIxpOVYazcqo5DMkv0jYnUgtNa+UsNAdLP3cAhRITl+iH/povdo4IIGEkgS8ncse0bIZgP9IKFZLGCldY9q2EW5dAbfUyo2mjtbf7wpq3ipWXrTLYrX2jtwZoYNbm0eG/3eNJg+FQDwc4dcdm+607tSN0/0raDh47oH+
 iA52oPJD
 3tzngZK1qPw4GAm1gAsTMr5K/4fyNjOH6KhZTqNznFXeDbuXdzVk773z3iDpEWUbq0HXc7wtjZTzZynAlvhI2QLOxe2CjNxPSxJ7WGNYlUIpP/v0EApL7hKbh7/e0Mn4jpbPATj9dTvSU4LS11PckAzG1eivNThVXOWHWvpDmTdZe7jZSZnh6G/M4fQ/kEtWSjNeIjF+vJojpEAvb6HNk4IO7bUGrBLDQVeNiNXXdErgmXpN0/Xeg0QAHlzP3ix++cRkz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Roman Gushchin <roman.gushchin@linux.dev>

bpf_map__attach_struct_ops() returns -EINVAL instead of -ENOMEM
on the memory allocation failure. Fix it.

Fixes: 590a00888250 ("bpf: libbpf: Add STRUCT_OPS support")
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index ab2071fdd3e8..1e8688975d16 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -13701,7 +13701,7 @@ struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_map *map)
 
 	link = calloc(1, sizeof(*link));
 	if (!link)
-		return libbpf_err_ptr(-EINVAL);
+		return libbpf_err_ptr(-ENOMEM);
 
 	/* kern_vdata should be prepared during the loading phase. */
 	err = bpf_map_update_elem(map->fd, &zero, map->st_ops->kern_vdata, 0);
-- 
2.43.0


