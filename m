Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46C63CCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:17:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A080E800A9; Mon, 27 Oct 2025 19:17:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DFD78009B; Mon, 27 Oct 2025 19:17:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91CA5800A9; Mon, 27 Oct 2025 19:17:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7FD608009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:17:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 307D7160287
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:17:44 +0000 (UTC)
X-FDA: 84045458448.08.4848594
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7DE80C0005
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:17:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lJD2QcuS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761607062; a=rsa-sha256;
	cv=none;
	b=XhJNhIjpVlPU6WVddFcW1dvwNnXXuyTa/Dgh3Gw+JZH3JOJGpBVbdqfGkwqMBAZPSDWHqw
	8VcmVyxVgRzkYCFsHjRZwxQ2Ewj+xDd9wN8Gc56zLDwzHn5AKP5ya0HJVZmNWCom7tQNtd
	zk4mIrvpVF0AwDqfV6+WHLOL/B5y4/g=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lJD2QcuS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761607062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pie7GrC+9+lsUm8ND6bCvId8ysPp7dmE7YlQN8G+ZkY=;
	b=wgPVUOln+oYtZpxJ5HDMyw9Bzv01oZH40x4rpASa9cyhEhp73l0UPdoMd+iwuaDvpd5F+/
	p8T16rqO3K/CrTXAIqTNIcG9Fn+Td4ZeQCbNtrFzLxSw+IoQI2G36NShxdXqPsKf2fDFeC
	eyBiajidh+Cm2P5sMfDHLdkfI6Vm0ZI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761607061;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pie7GrC+9+lsUm8ND6bCvId8ysPp7dmE7YlQN8G+ZkY=;
	b=lJD2QcuScgMclRJ6mDHlCLu1e/Po/2+/GKKJZqnv3su5QYU6Yn9p+hz/5DJblXQYn/HUVM
	REvI4h4hi9CbZi48THsPHxWgjBsXmbbIlEnzvgXARMru7YA1bCStqffp+NSOqSsAWR1g81
	J7Zg8jJlzKa2E2a1Bk7M0RzVoh7Tg58=
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
Subject: [PATCH v2 01/23] bpf: move bpf_struct_ops_link into bpf.h
Date: Mon, 27 Oct 2025 16:17:04 -0700
Message-ID: <20251027231727.472628-2-roman.gushchin@linux.dev>
In-Reply-To: <20251027231727.472628-1-roman.gushchin@linux.dev>
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7DE80C0005
X-Stat-Signature: 1pn6hp6d6pc1bk9dw5imdh8s1813uc5t
X-HE-Tag: 1761607062-197342
X-HE-Meta: U2FsdGVkX1/AC1om2rSXl0gfEWCrBPGT2exI7aA5e8zEO6Z0JY3TcqSyUPECrxwpXF2zMKq2EzPdTpOgKf0csAYvKwvkn+7B9gd8vkRuKllvB3UF23DJSGD7pZNEVIt7/4lUv6I0fHJHBgba3/wllH98C/Yn1FhOwdSfnN+kM3kamwgCStiHqvlG2UirVLxbCubsoDyB15hyRskN/xTJDYpP3H6rW/7hDAJbRjkKGefwCihTtuevh4+w7WETz0a+mHUhbIxKVO4SV5Cm5rb+aD2+MsXjB9sWaNjZrDuaahQ94sSiOrEy9QLYw7XewWeS9OIqo2RdNcsC4HV6H8x6iO7mqqyZ+E68Y9TJz98TrAIbK85Wr3OGCZO9miw2xd2G0ilqpyEzwIi+dnSoA/GmJpkQacdjpc4MC6Xdfr0pcdQlIijH0KFF4F/HDV2Py1aj+k75j/KQrSrwJ5DdRHMOPH2ZJhiKPveUIEFgobgFkNW7nnKOdtsU0jpS98b+LRBD3sPOoZO0Pyiq/cQglMICSUil7bq76auop8gTt+unLKH5Db8K/6qYs43YVThmDwFBucCCVJ1GFmXtITV0uqgc+d76ayfPPfCK1Oa740jtHTFjzO7GvEtkDJG5Gf45JtBaWWStmNOKdMejokzHso/ehJpRzwpgBBnDn/jdw5ubrA+oowKfzB3a4akyVb8AnomS5H/juP7qoZTEWyAtJl3lMLwcUcsw94WXeYaTvCDoJrrPvsR2Iz7ZQOUTDXajd4EfBpx4MlwDxgTa11YZMuzIGZB2yukw9ZZsZ8kPM/oaCWlKn3gOgbTa7SHdcuIIRJf7o+KQRDaobeKiTv7/4N3P13ikEtRt3rcBsomsokdKy4LasYtjLbFVRbhkKGMrzCK6Co1f1Pa3mgX5EFx6lOfq502Swaf8eCBYedvK6o6UfoKpqef+xJoDSRBtZ7O30HCROOeyStuWh++zlQUCSGL
 ckvr1Job
 VlfiNW10+OLxo5GMCzuqJ88sxBel1FQzhKKqOsZ8E86plDWDv2I6KL4vXHWART0xMRR4aJcrZ6wwTFWDoa4U4mLpqG0lSQtRk9o0AlBQUUJRC/sVDGa57O4hFO17RWdHxqLMQKIoKdbQCq+AVPifR+FqeYqWzAH54o74N/VK4fvdNS1zd3o5zddaExSwELlUbMhzzje2Lx0DcFrvEDYhaWFgt4qjz46u0/V/EByLpCZ9OUCbEAsn+EfSviVcNaNLIvuRXKknLb61O8P3hOThBWvOydg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
index a47d67db3be5..eae907218188 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1845,6 +1845,12 @@ struct bpf_raw_tp_link {
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
index a41e6730edcf..45cc5ee19dc2 100644
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
2.51.0


