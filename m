Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BF7EC88E78
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 09:03:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0FCE6B0089; Mon, 26 Jan 2026 04:03:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFA8C6B008A; Mon, 26 Jan 2026 04:03:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A06996B008C; Mon, 26 Jan 2026 04:03:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8D5766B0089
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 04:03:20 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2265313B86C
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:03:20 +0000 (UTC)
X-FDA: 84373526160.06.4655539
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf18.hostedemail.com (Postfix) with ESMTP id 649391C0005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:03:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O10fHPKl;
	spf=pass (imf18.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769418198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RkVeShES4B2VgCiXTgzhTlETaaAj+olyI2gU3ClsRew=;
	b=EP2odl/hHe+jZST8eCPOKZBRbkZMQOcekmDcHRNc3TbTVW5h3mxLA+OaG/jscO1/9KOrAK
	p2YWOPTJfbUVMKdaUh87dpWUwVq+Q0HNu6wsYPG0pbfwpJI+4AM37yiWKxG6H0ibrrFAkc
	F+AbqPzSryj4Kh+AUjwni/9I0Re3Nls=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O10fHPKl;
	spf=pass (imf18.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769418198; a=rsa-sha256;
	cv=none;
	b=TXdSNDHmJsTs/ZGDILCM8mdgvAls3TdIah3EARBwZ2mLtzdqZRZUJfv6eDXWH94y4aSy2b
	aQ4fV53vn7Jd49LYngIVAnmBTu/Objp6x6N3eVWhRktxhTd/EJIhix4/upWZM2iROxzQSK
	D77Got/21y5c07xGmXY6bGz3aj2LNYg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769418196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RkVeShES4B2VgCiXTgzhTlETaaAj+olyI2gU3ClsRew=;
	b=O10fHPKlKdFZ/Yi788FotJKbzD4VjaoFeypk+NZQorir1kC9RdW6L3vR+CzlcnKOZbL8yG
	GCtjC1SsiJZikVD1hmcM24c3ab3v6CNMIN/9hLkkwSvw5a0c9mf/TEAGf7bCcPqtfKJpMk
	+4sGOOZ/TBVSqgB6QFsg56vkvSIZJV8=
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
Subject: [RFC PATCH bpf-next v4 01/12] bpf: move bpf_struct_ops_link into bpf.h
Date: Mon, 26 Jan 2026 17:02:25 +0800
Message-ID: <3a6694566eedbf17f84dbe5ffafe9aa0aa32108c.1769417588.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1769417588.git.zhuhui@kylinos.cn>
References: <cover.1769417588.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: po8h795db66q5ba1z8p9jb4xr5e4sm4y
X-Rspamd-Queue-Id: 649391C0005
X-Rspam-User: 
X-HE-Tag: 1769418198-1494
X-HE-Meta: U2FsdGVkX1/6Fb/XX9PKBpZebZcd2SJmbuDWu277KxdyKKCMhC1BSMKsItv6yqB5r01L6LtcXwWOE7L1AA2rTmhOMLocQIj6BH0RMiCrQtHVlAQH+a2RHPTRsMcw5d6ZPLoYiNpmoFLMkSDgjGs2wkySjbdWSrEnEDnyzysHrzhL6Qp8KB8oZrnqCHAeC8SovXUEaitKNu9fVt6DxXKbQRxN2r2YH69LybE8IGgwJR8jZqIF9L8dS+BkoI3kHHVHBji1izA5UBPxs5BtllCH3n5R5UWdRvaL8mdNJdTK5+gIKAjb7RsBcycmuUUSzW/SdlrVq9WmiA92QGEWuiO0iPoiFzyJNPY0uxzLeZSVq4uum3MWRabt++9pNSv647LBghUlFYy1aKS0etoCOAJMnP9241PFNC8xV7E5CFbFNbmiBBsVq4LHVCB+0tqrIRlPQeKAJBm5IWTW9aLxSAc2pscIzG5gyIJ0ap8wFTIT39g5+VYMT5Ne7uBL8U2Gz6p2Gw5++e/70rB/jtUopx0G2zJHR+ePQFbcyV05PcknW8bUM93Ol2eDAvgQRXzxnpSwYnfZbnmWdFodwIrgfynZ2A7jCuTKFQxF3VGIWTzSD2rhKDPN/dZSQMT0J2Ji/Uzv2pNsLIXltA90OASPT9dyqfCIE0eNr2roZ33JQVKllzvTPq7synQGTM3hU56gZ02Lmmx8HoleEY+uY6MEIAMQgTRK2bUwgiphqVMXMQn3bIfJ/2nMzIY5X/fYue18wXKQ9pfXXeX7ppOIyViZWqi+GJg6eBWFABRViTUMTGSYhCcxtYJnChGKM31IgFMzCxjoopVh3iytnHSE+ChCtK1eaCAJmtvXQy2fnqAvMGuJxD5NLpWeaO9dnJ44gOIQFFxqj5LrQoEpimSliDVh1od6TahOfl0alg00rgG5JDe1YfZhYVVAv5C4tHpzTDlFSLzWEihxFd/2uPYLf3Wxu0G
 iXATf+9i
 nNc4g/+B5/XsfiMY7usiRKiG41D93XLylPCgr0ZbBPD3r1xhr90Lw8al78ldjkwDP3Ecctkru4832V8LZHLAONQms/02O2kJmSH0wfJG6+QdJz8NFOLkiRCO5oOykMLyLTa4Khd+D46xaDh6QtEsJZU3Txp3jq4ZsH9sEFCxiQxona05o9wBsD8sL7Rt/mFCWoORGYNlXgCtr8FYMdNdSz/KhMuFFVMvb15QLn0ylxLfZ43vvlMTWhA065AE2C8p16u4wfYb668NWFUBXxve/MKe5+Q==
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


