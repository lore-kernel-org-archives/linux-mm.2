Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C7E8CCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:18:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AD1D800B1; Mon, 27 Oct 2025 19:18:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65DDF8009B; Mon, 27 Oct 2025 19:18:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59B0A800B1; Mon, 27 Oct 2025 19:18:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 440AA8009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:18:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 13BB4489A4
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:18:19 +0000 (UTC)
X-FDA: 84045459918.18.C2F0458
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf19.hostedemail.com (Postfix) with ESMTP id 63E6B1A000D
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:18:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hvHbWkeM;
	spf=pass (imf19.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761607097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0L0/Ocn9RqSsZN0Y29o3qrSHIg/Knm5QfgmpjPK++Dc=;
	b=Lb8ewccVkWWV1UQUCeNxkgNltoG+2v2sp7FXJZsMROas9lnOXisSA0cQpUTaT24yTyu5RU
	3Of5YK9kEnDz5u/FZjQUbg4kkxTJbymxHUBxe5hURTaA+zG9yRFkkOVXlZoiQnF7+gkGxr
	wfap9hllkbAc2FGB9l6APPJY/8XkAWc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hvHbWkeM;
	spf=pass (imf19.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761607097; a=rsa-sha256;
	cv=none;
	b=hcblH2r+Oy6Ll6bnHtlAr7CP2EgbDoacJnrnHiMOYy1ktygCskkvIh2zNEB1YBma/YJRCQ
	+pB7HIZnQIlshzrV18pPrYwHF+IzbmjcvSbpimYsy1xvupwbk1yGn3t7du/q5wnqDmQDLh
	nltLC3Mza7iR9PmQOVXGZt6aNfbM5Kc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761607096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0L0/Ocn9RqSsZN0Y29o3qrSHIg/Knm5QfgmpjPK++Dc=;
	b=hvHbWkeMCi+mGvHKY6QdSAqkwB8+dvLP330BknCQWQjexYhiDSjpkQh68nnGVIqt/WmOXA
	ym1pLJPCyIrwF+Fey/vwtrn/TcqXV/szfQ9TBW3DZxGU4AfLfCUEDoA0GDLWkq1yqy/SAz
	GwrAo1ztd805084vXph8luCWScY37+U=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH v2 09/23] mm: introduce bpf_get_root_mem_cgroup() BPF kfunc
Date: Mon, 27 Oct 2025 16:17:12 -0700
Message-ID: <20251027231727.472628-10-roman.gushchin@linux.dev>
In-Reply-To: <20251027231727.472628-1-roman.gushchin@linux.dev>
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 63E6B1A000D
X-Stat-Signature: u5ikudc34byo1frjew6oq9y4w4dzxbfe
X-Rspam-User: 
X-HE-Tag: 1761607097-574
X-HE-Meta: U2FsdGVkX1/cWp/XrxjpGZgqyDV5MkIp8bbirC08OMPvddRrSl4a3WIx9TFJiv7+64dQI8PAkK20bUAGj0+sydXlwpEH+yEWQDm3xslLrLUJqbrWat5z6AuGhFRc8mEsTbRci45KtJ/TZSrz5rb+U4TdGq8ratJkozA8wbW+BDKmAjSlt4R/FZMImztj8wyAlwwLf8RA8x3iwcBNz+5tLgIxbOokV0iCIpSBU9DFgTwGJRWNV/Twu9z0Ql+i3/WsK2Lyvhn9hLqv7CC8LNHCFR01LMg+GZAjqgMOZbF4w6wdSUl9g4S+7xtKOQwxjy3TnI+cRbh7Wmi2lSyJaZL+kxBK/BKmU95PnX++nWvT02nBb1zp5E8ShGtyv/AG4YJb9cDASSQgXi22M755sl/+Y59IvRdkwB+/zs1ZvAlF1KFKPVBAf3ChwsLiv8h3fU036TSbPV+OrBqtD/8sqfDEG/AbdXViCpRrtJfkYuGo/3bCBC9nEMEq1KQCOCoZEhSHWEPQ1fQ17A7HHX7rAqCMZk3pTwW2VTywi4X5goNm9i5cBji98UGfxqj+Fu9WlTKXldZ/FVAmgzWclrX23ic1cgmPNmHh0lic/PBg9NFIKf+gsWUFD7K43EoePdXIb++vsowaLtJKDLJS4jn6NaZsZAr72gue6puRXpjc5AZOSS0anTXOWmctXtftXaYQT++pA6LTSD+1GHHZ8IbKvCALccpg4nY+P4oWkrs97lFuDuyn93uWaGxFlUDvNw8E7avsCimL2JiStrAijgw6fIGCkQrx3vyt++HtiQb7HSoEuuUPAlqKZQ394ixkSecWMIkAZoYEz7ugHtrMyrdk7boWizivgeLC4hh9Fks/li00n0CDfB5Juyw2r3wRaBfmIFQl4CzjuwpBlpe78ov8lg/uKNSVZhec8V6CUeimxKEqcBiI5wpBQ3IRZzCLGfv+GRZQ24iP+aY8cfCEWyfAhS+
 ckyGkxxz
 74U8lA6kbHhyjj4m5m+anfeq0PQ/70Grfflf/c5NdHrmDtAvcF7be4UA5vfWUqMbhxV6QfhHNu+BrsTx/2CgZph4rfO4Ql2AWI0dvezuXmeD8AyoTvwZXtbQhgAIsL6ALsOxyFsthWF2wd9cDguwUG6pNtn7QqgWjXhNI67P1S4Fx4GTgw2i2okwEu4V9o7+SVrlZmiAytrNOc2o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a BPF kfunc to get a trusted pointer to the root memory
cgroup. It's very handy to traverse the full memcg tree, e.g.
for handling a system-wide OOM.

It's possible to obtain this pointer by traversing the memcg tree
up from any known memcg, but it's sub-optimal and makes BPF programs
more complex and less efficient.

bpf_get_root_mem_cgroup() has a KF_ACQUIRE | KF_RET_NULL semantics,
however in reality it's not necessarily to bump the corresponding
reference counter - root memory cgroup is immortal, reference counting
is skipped, see css_get(). Once set, root_mem_cgroup is always a valid
memcg pointer. It's safe to call bpf_put_mem_cgroup() for the pointer
obtained with bpf_get_root_mem_cgroup(), it's effectively a no-op.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 mm/bpf_memcontrol.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index 1e46097745cf..76c342318256 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -10,6 +10,20 @@
 
 __bpf_kfunc_start_defs();
 
+/**
+ * bpf_get_root_mem_cgroup - Returns a pointer to the root memory cgroup
+ *
+ * The function has KF_ACQUIRE semantics, even though the root memory
+ * cgroup is never destroyed after being created and doesn't require
+ * reference counting. And it's perfectly safe to pass it to
+ * bpf_put_mem_cgroup()
+ */
+__bpf_kfunc struct mem_cgroup *bpf_get_root_mem_cgroup(void)
+{
+	/* css_get() is not needed */
+	return root_mem_cgroup;
+}
+
 /**
  * bpf_get_mem_cgroup - Get a reference to a memory cgroup
  * @css: pointer to the css structure
@@ -64,6 +78,7 @@ __bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
 __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
+BTF_ID_FLAGS(func, bpf_get_root_mem_cgroup, KF_ACQUIRE | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_get_mem_cgroup, KF_ACQUIRE | KF_RET_NULL | KF_RCU)
 BTF_ID_FLAGS(func, bpf_put_mem_cgroup, KF_RELEASE)
 
-- 
2.51.0


