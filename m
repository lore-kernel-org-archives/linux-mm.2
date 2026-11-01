Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 624BF606A332
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 02:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=cYXLGvnX
Received: by kanga.kvack.org (Postfix)
	id D33C16B05B1; Sat, 31 Oct 2026 22:13:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0BCF6B05B2; Sat, 31 Oct 2026 22:13:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C21036B05B3; Sat, 31 Oct 2026 22:13:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B1486B05B1
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 22:13:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 306FE140220
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:13:51 +0000 (UTC)
X-FDA: 85384929462.30.DADFB6C
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf26.hostedemail.com (Postfix) with ESMTP id 61AB4140007
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:13:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cYXLGvnX;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793499229;
	b=4/Hd1o6qc9ea2mmcSw8mOaC9sJZCdp0dUErIKO44UqKTQn4i2zkNMLATm+yvd/XbDMrbXz
	TShFCUlZ2un2Xa/TpO9RnylhJI22jesnKLcMX5jbYsrqTcHfBlLIe1OFsHgXEaI+TdtIuV
	08CBj2MWc5mJaIAL7gsdTO1Kduj4ncs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793499229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vO0BDg/8068w2sWF8c7lp9ZJV9hDUZO1hrE8aPsToAA=;
	b=bFxO+dY0CDbhRyT4+3aOEtrcdrIYV/Fuc9NPmwrhUczFYKdrU/fFMwUjWx7qzlRa7OBZoZ
	/hlfWfvGCegjU5jHliU2sd2g0ARmWJVFuPCFpTxd5GYpdl8IWTKGDZ2ESvjJ913S/UOFr4
	zAkS59mS2K0675DjX6anpD1esubexOQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cYXLGvnX;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-93e63ee7b4cso195625185a.2
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 19:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793499228; x=1794104028; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vO0BDg/8068w2sWF8c7lp9ZJV9hDUZO1hrE8aPsToAA=;
        b=cYXLGvnXQjr5pnDZed896o5k4AxSguF/SrxAVx2Uhy59VmqS9pvBtW+DT7xoP+LdS4
         46DpDgluKjsk0tIOUtFFU8HGLq5QgeJJvkYm0az8hG/6yzXiUIw7oLWxpLEYwMf0bX/R
         98qsF1SOxS4SMBRb03LrjUF3EKPQNicxAQjnU4Gapt9YMP5fZHAjZj82oNRqCuWPA43Z
         akWp1atjBjJ6h0edHHTm7FqD3RKMBq5CQYkmDpGTWNPHJ8jl8tMB58sKAvEoDgbNNLWa
         BZ09ZxB9KiqCoTRAk4W8CXKW+MXz0Jimx/k49Jly06eQ8cj+awlyI5ELi61wo0H95A8u
         wVVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793499228; x=1794104028;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vO0BDg/8068w2sWF8c7lp9ZJV9hDUZO1hrE8aPsToAA=;
        b=xm25u9N3gwjtlOzhOUdWmTmapXwBE1MxmaRERtWlc8U240Yih/wjyTf6prZGjGF7ih
         299BMepcjdYYD6q2WV/56Ftbnk+a3Hu4kMEGY5F1URmuypAPiQaR5b6LBAtvkEf9DJct
         h8OSwgi3poqglLIoMz/u4B2XXa20k3XlX/ppWBCKEGtR+k9c/lN3aYqKeVRyEv4w6AyJ
         0aIiQuLrjSWTgp6d/j/DqU2kf8pkEPEVRRRTs+/SCzge02Mrz4ObdjX45zK7zEHaxClC
         Q8mRie4icMHLcY8UxTBTdO7idB+NGrMXpZhR+dBCr7p7CGrOluMoSyBNyk/P1zlQtH6I
         SrcQ==
X-Gm-Message-State: AFq9FYJ4Qd0WX3GjEGtt6DX9ncy1vPwgmbg98FBxXl3NPiS3mxrlBIZe
	8Lzq6/J5bHjKGlpQ6LljdDWX1LHEVpMmbTHypEdfxJfNbCOF+x5lcH+VcJSU8ZO7U7VzVhr09UP
	aj76C
X-Gm-Gg: AYBFou3aip3mBiwO5JC2I1SS6gG1qnB+80dgxiDjI1olF+uKzp8tZHacVTnfftqSJ6E
	36dq35D/6vP0NdZ6ivVC3cUVDoOfOk7K8S8oRS+S4n7j3erEKj531wA7CIgIlmI8HT7spNkkxs4
	5K2wLPAlYTru5Qvdy7u/BCq+5z27H86ePyi2p4Ky7hrR85Tl1LEgnwWvnQxPMneAeUMvWVJ7TaW
	OEKx1bPhR7zO/gR6FepIq3uhApbPSTSUbXh9pUjgwntWdGJ6bG3a1aMO8wd0OLX4sIfinRssBOK
	X8rlhxP/i6KPlGkKyTzHRj3TAtdIy6YLNIUcvT3uTlyumDzBgxG/v5qUwJM1HefafAbSERGsdBD
	ioD+aEeLaEqvaM4vkBMjxwW0DZJL8z47Qoq1qlsHcNG0IIJ7FkxfYMa+PsRKMxR7xhnvM4HtPGU
	xHKhMoSAgFXkZAP2/DIlfEV5ihH0ktTPLRtb2VQptdh3wclI+AC9IG9Ts4wwprpIJNeJ6+t3bbr
	7XLfcx8jgP3JbsbyA/NtuIrCGti1cBfeONJcsXkEO0hZCGb84d7CRk65Dq92AuTU9XqzPgKLJTv
	1ALhcGeLy2WQ65zKbi0NVvMsgmPn8VhqCk7KkLPbXk02c7CfTxwliIdRjPE86RmyS+BIFXuG3xc
	ghmc30bd4dw==
X-Received: by 2002:a05:620a:2a01:b0:93e:c12c:f136 with SMTP id af79cd13be357-94421824e76mr1073212985a.81.1793499228208;
        Sat, 31 Oct 2026 19:13:48 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-94425858552sm498131985a.18.2026.10.31.19.13.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 19:13:47 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	nathan@kernel.org,
	ndesaulniers@google.com,
	morbo@google.com,
	justinstitt@google.com,
	Bessel.Wang@huawei.com,
	jiang.liu@huawei.com,
	mgorman@techsingularity.net,
	anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: [PATCH v5 01/12] mm/page_alloc: reset can_retry_reserves when the slowpath restarts
Date: Sat, 31 Oct 2026 22:13:29 -0400
Message-ID: <20261101021340.2251928-2-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261101021340.2251928-1-gourry@gourry.net>
References: <20261101021340.2251928-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q6qka71p8jazs3rc8bw6tiewet84tiak
X-Rspamd-Queue-Id: 61AB4140007
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793499229-971960
X-HE-Meta: U2FsdGVkX19I9gcsGlFBYVQfBHJRhf3YIj8/mte4IvXe/fxLAH3bIEMK2Q0odsWHvajmEWe/UyYG9rBBG/kHYb6deoFQKpYLw0vV8JNIEDKYWsvGpfgQ71WsJIdE8WblfAbMtzfow4XBVLp5jJQDFaxP4oRqb7KLjYTfe/5wU+HHm2BHCrj+5XTcfbwnIaJ2iwUVy7m7atBVYq+qVhEuZlE1ReVLj/b09fckHsx9Ntv+oCtF4G5y1dFuEXgZfor1g9MTqoA/wk+taOm5evyhSPSlYql40wvh96IQMSYwQjHFerMvlhNOi7wresCbLI/4VLTAeClbO9P4xBUgNwFsjaEChpbWw0NP2WXBsLjS9iDjUop5P+/ezkUkuOOpsg2t+GZOkcTBTj2JsZHjqLcpEnNEXaLnF8g604EY+1E77iAbdBXhK+UMMtp90bjAvdwsNSgNyEhxwmv84N9jtcajofO75rUkQVnFfxU8FM1SrAQQd34UoRVU9seOH67c8kqvHzdaAFwlHVtk/JW2YAKXgH0Cf5FByUuRdQNnSQoRNOiS+dqlP2nsvcvFRkNFyPGgSF6/mW2VvrNHQ69lJeXtx6f1W+FxFaUe+Vs2CHAk8i6iwxqGpEJk4R4TojNprGP3j0LmEdjNvcmCfMvACGaKWFuO76cLo7IGP+Jgr4vEUiu1yL+CSiGytJQyO8hcV2daREmQdRumTKV//awk1baa0DrtXsMdr5lhurIMNBOqvovO6b4PnFZBjcyThd+aQklHc7aw96qPW1kqoVi8dEShibNfG6YZ6SM/LVvaFCbA6E3K9Jz8N8ZnslPtxerh1ptogjzLTst38AyJT9IGPVs4ETOJbABj5FTwfcBXvsKPs08bTjrvrrJye9IDUdlvH3EhSVAs6KBTnU0XtRcIejCbYYezYA9GP7onZ2EE9VFKv5e5wNMOpoLDuZ/lMgNNz/ZifgdT0MYbIq8k/Uf+tv+
 n9GG8DNR
 X7G5yiwtT7PUMviOv5Peyn0475rUACjIstEzw7HLNzg2yc6XfhJguzVTXZ3x8leRrupaR3KXK9/W5Hw6UCoqRbaT8Tqi4rdxvjIK+pfOBVKH9DCFpOvpv1aSmY77TBtzk4cCBqHfQSEU5e9iT9GgHn/OyRv1zeItMZkSjQLnd1HvhTtL5vDy5iVP5AcDedfFS3tyOYcfXvVi1oLSXDsAdqY5LJz4bmnaX4vkhW/fXpMWUqUAdWyc8HzH2mb4jnCqVWfnnmlqPHGH6t1I9QaRVBkipZNX41msugIaBthIHcTqQ6sm6zbJ2ca/Rd/Huj6LiT82fvKXzeccaNung8zViF0i9prAEMNKJLwex0eqcEhpuHSOaXNzl7twLGQbiPpCx9lIVZ6vhIcEF3QaDTNI53CkwYKAJRk5FEhWM2PPSxinvSfifujWfnHhx9rhOh7K/3vZD/uGGwt4jD2U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit 2c4c3e29897d ("mm/page_alloc: simplify __alloc_pages_slowpath()
flow") retries an allocation once with reserve_flags when the caller
becomes eligible for reserves, guarded by can_retry_reserves.

A restart after a cpuset update or a zonelist rebuild retries with
can_retry_reserves already set to false, so a caller that cannot
reclaim (GFP_NOWAIT | __GFP_MEMALLOC), fails without trying reserves.

Reset can_retry_reserves on restart. Only a cpuset or zonelist change
restarts the slowpath, so the retry still runs at most once per change.

With a kprobe helping to make the race deterministic, an allocation
can be made to return NULL. With this patch the allocation will succeed.

Fixes: 2c4c3e29897d ("mm/page_alloc: simplify __alloc_pages_slowpath() flow")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/page_alloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a8cac5e01066..f1048168c90c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4783,7 +4783,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	unsigned int zonelist_iter_cookie;
 	int reserve_flags;
 	bool compact_first = false;
-	bool can_retry_reserves = true;
+	bool can_retry_reserves;
 	unsigned long alloc_start_time = jiffies;
 
 	if (unlikely(nofail)) {
@@ -4805,6 +4805,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	no_progress_loops = 0;
 	compact_result = COMPACT_SKIPPED;
 	compact_priority = DEF_COMPACT_PRIORITY;
+	can_retry_reserves = true;
 	cpuset_mems_cookie = read_mems_allowed_begin();
 	zonelist_iter_cookie = zonelist_iter_begin();
 
-- 
2.56.0


