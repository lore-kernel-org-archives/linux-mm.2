Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 600E2606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 21:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=AggPk+YX
Received: by kanga.kvack.org (Postfix)
	id 6D48F6B0186; Tue, 20 Oct 2026 17:59:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65E116B0187; Tue, 20 Oct 2026 17:59:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5264E6B0188; Tue, 20 Oct 2026 17:59:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 230326B0186
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 17:59:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B7CC1A02BB
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 21:59:10 +0000 (UTC)
X-FDA: 85344370860.20.B7DB293
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf25.hostedemail.com (Postfix) with ESMTP id E4ED5A0005
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 21:59:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AggPk+YX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of med08elkadiri@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=med08elkadiri@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792533548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OFRf0ceigKCMfSem0YJiHH5DCGenKyglDuxNlTimA90=;
	b=i5bKX2uURIg7fIhBMmll8VqvcPjn+GF0UVkN0F1YGU9NzD4KzFTd7MClUKVMpSbt03+iQm
	Vq94HYmedafN46r+Remx8B5InLMR9RetSr1WJ15j+zPjm0U2ixNhCPNMYZT9FVRYsQEaXx
	uqN6eEXnAOaGbWa6xk25egAXZPJMnyc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AggPk+YX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of med08elkadiri@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=med08elkadiri@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792533548;
	b=LxhoipxS7TAZ4px8MhyTV84b3kmzyLcrrq5af3e26emlIb8LfPj4RcPuhE6R/N6xFNtq+W
	DC4XOVZUdJ0BkPR0pkwnDS1oz2Qly4uJhZ7SrDgSX8uNPrUrCVSpTE9ZwVztj4O1urdlkK
	4M3FDC+GOV3rBAQp5MBOX4oCATGezi0=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a1d293b293so320535e9.2
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 14:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792533547; x=1793138347; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OFRf0ceigKCMfSem0YJiHH5DCGenKyglDuxNlTimA90=;
        b=AggPk+YX8PGEeMuIPcRcOy4u6BKkY8N3Me4pitpKs0wBgF6WFv/IU8BjZJe2ZYaZNH
         z7RzUOVjQimtY6uPZ/EUy6soNfOnR5YPBPKLKviEYq4DnPITgMVCLXk7tj8x/PooaZx3
         0ONaFjOQOOKtzCO/Atrz4tGR1SI1pd2B2oFLs+opovM/0z3QwduCFQp14O2njIBI0pvH
         pXBJxiurWFRwkPyJOaZO1uMKE2979TZni6WB+FEyxz83dN+s3iJHTTKxu/bjocPYY/IO
         HDVxawDOGL7Vp3IoVMWQCda8Y6AVjCJhCKBuLqzaM90P3UTtQfvBDJLZz4zXsmm/en9h
         6VDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792533547; x=1793138347;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OFRf0ceigKCMfSem0YJiHH5DCGenKyglDuxNlTimA90=;
        b=sxUtHyrk+uK2Bl2w8mq6Aein4pen3viCJ3L3iYnHFYZrag+5N4XY9dindSawggsxN2
         I4RRk6iOieGVaA8/0Zic8rDCkrZgIYVklrlu0iXmzX6l8HxyLxpMaU4wtXgCsFIPhFnl
         t5rFoSk+Gyp2f0Qi1BU6GLZ7ckvcspfQjfVzNNBs8Hr78y8nhM+IYmImoA1Hx+7wss/x
         N1PG1+RRNjTTe+Ast+zDjFmnP1GBcXfnf4i7qGibpiYbYWLHJnoJabey3a854ShXzhJZ
         NY56g7Ps3WObcvpZr0LtHPMG4cz4iwWXxo/LhRCjQ9L98JJdqJcz/suguZYovhcJ3pYl
         2tug==
X-Forwarded-Encrypted: i=1; AKwUvBz55KqCSkHS/4kp+PoTX87ZVXk26IjioZ8t9S8dEFpriR9VIkAxZ79qdmUBQuzTbCcnz4ehG5QHvQ==@kvack.org
X-Gm-Message-State: AFq9FYJBIw5Godhnz9GsiNWX/lJk2xtCSptCmfscncxi+oRpTevQ292C
	juE5yNnD8Fw1wuEeNABxs3nw+OrjSDfLnSV2xUAVhRYxESjNVILqT8w=
X-Gm-Gg: AYBFou1GjVpic8RAh6n6eoq4ucwyf1qnCRyubUoL2j9dUQKygL2zzzQyjLlfWgkl2hk
	+gUFSqWVrAdpEapKabD7FIzUqzH93tUjkZKgDqB3JXf46r+TlDxMKPZEnQ9ZsYvA6sSIimtCin7
	ZWLsCfL7FkcQO+9nwi8BM98XI9jzu0kX1CjVZE4Gbc5dyL0rUmj07OaIh0ROorDa7NHv0SADeuY
	csWlx7S6lJg0vn/wftEkrt4VNZk7iR4chyrv2pwuwC4u/g41qZCi5qKgAQi2yMXUnzE3U3FPmaJ
	KQF6jPhezLgRBuvw2yjINLcnVd/LJk6hZqOLEmszpRLIUsFXhCfpcDzxIXbDg3zeYXQ326erDHk
	stW3bubzD47vWApv6CJNTbg5TELZ8eSAOFPIYunKzEd9N3YeDYB/TjYhFkR9UaLYuXP4r/CJUJK
	i3e0AHPYiod6jBRD6vTCrDOYnJuKPQgh34V4pStXk9QZuBRih8FXfQ1kAoGoPcAa1AEvOVDm1BE
	Q4uGvzONheVHtNRmcP/EsvB/I1BK6+/4fcUBwEzHVTLvAqiUoMOAx0gGbXEjm6Pcx4xuTmbo4vQ
	zc5AiC92ee9HznruAw==
X-Received: by 2002:a05:600d:82c6:b0:4a1:96a5:366e with SMTP id 5b1f17b1804b1-4a1fdb1d212mr726455e9.7.1792533547325;
        Tue, 20 Oct 2026 14:59:07 -0700 (PDT)
Received: from Ubuntu-2604-resolute-amd64-base ([2a01:4f8:13b:86d::2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e25828cd1sm1095988f8f.22.2026.10.20.14.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 14:59:06 -0700 (PDT)
From: Mohammed EL Kadiri <med08elkadiri@gmail.com>
To: lance.yang@linux.dev
Cc: david@kernel.org,
	samarth.colleges@gmail.com,
	akpm@linux-foundation.org,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	peterx@redhat.com,
	kas@kernel.org,
	rppt@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/ksm: keep soft-dirty and uffd-wp when merging a page
Date: Tue, 20 Oct 2026 23:58:49 +0200
Message-ID: <20261020215849.730615-1-med08elkadiri@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261020055518.36087-1-lance.yang@linux.dev>
References: <20261020055518.36087-1-lance.yang@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E4ED5A0005
X-Stat-Signature: ujdtn9q798cfdotmptchm3rypo9y9f9s
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792533548-554291
X-HE-Meta: U2FsdGVkX1/16+tq36dinF2gGGKodIAioWHWx1SCSIf/cQ4YkJpD8yV2pZ0QlWRvAqMEXAxThwflaccaL49e//RbybFDRZnzc/S+GPWEmOx44BCv53OrHrzcgiAnsxxmFL2VvGd7OEiCxLWAjQjnPpWg4xkJZ1kUoJRYFBhxAN5ALSh1Qw1GMNLLxh0n8nfbQ9N/YcAugoZhYgTYB57unQP+hE8XdLOIC1gW3rI3YiLCzcDOO4SZfqC6U3mmddzv/iHkidBzeYqV8N7sGsA7x7lFZbbDxpQ7xRHu8pIBJz4tNgaF+dXMSAIuaQGiQm4UDQzLeoYS3nGHXgrHdfsroLLM5UqGXbARgrsh1Gfe09UPei1RCqKkcjTreHzZVb52qdyCwXRNTVSjfXnBuLiMl0muT08zc4Hzvx+00A7fb7VLoZ9QGlxXo50NvJiXTX8SRmM60f1TNb/SJuPOU61LkQp22OJz1mxSbr5b7y12zT1MsQQxJ1jaDzvwUVAu4eI9OvnHs2eMSqz51Ry+nj0I5vjUUSCv3HhMXweAE3Rzg9z8PknoFdH0DCVD6hiFEc82WX65tfs7c9pLZ3NFRixPzNvF1Wgm6ynL7JybiM/XdVAktVHjkPjtbOlX0P/OKMbUVljOrNpL840LfKXjPsALCgpnLV5WmmdAiN2hfOAwR8HxT7/aabVQ38nvkYXdd/pszvLXu3swhV9LMHirrGpcpCUlqxnIsgeZ5MAs1D2gimOhAvATzw4tlnLPtE8QkMtXROCyred/3y3XcjkwjX58NU59k0Fsg/oxBFjADbVGuKqCUBNNXJspGOywCJtsPg2LxVXjnxufjbNxwzbvtb6pItAQeNBg0abZwf4+9ae3yZFQJ7JCIxYoxj9+Nr396AERHenu6e7k5UGqQH+ll8SZI2pO1xiqLAACNNFeZiz79xoGiTcIJBXZ5SV8dMXT34GCKoFTpLMnJIqTjPQBIbn
 RyLpQ43J
 OjNvAaVdbuPZ4VIrlDYAO0jVMQKX3zXcpuxCAZkwFxyoonitq5rOO4LXJ9EOEZhnxjo0bWv6ZEqIi+PkFnxEuzUsJqgjMJyLLbsoBeugTg4FRbgPJFy6ZB5XkFzYyWDl8B6KSPodxs38G+t764+RdW78aN9ONcI3G4SxJOVEPC37f1skjEmlX8DfAezx2x9eyr/NHCKZJdO+jn3UGVfktO8NgGDKt49uz8NUoldYLTND0EELqVyL9+L+iylB9HQE+bj1jsk46vN2X1/Cf/Ls8HXo6+1h1K5ossYZQxfh7iUmhviMYNpa1PQ2Z8+gjorrMNZCC3BBHc/9kfkbr1vVXRdEKbeBnZ2YTpA6L7uKHiXAWtCNNLYwcYF7WfoFfeeECMu4EbHYD/z+OhFGCE7lHfjkpj5QSb+zgqWd+AF7pQMOXRc4gE+C+PiIes3Ak7MNT8cDah1vO/vCYwPhWWkAnD0Ywtl0VX29jUU9zKei7avW0dmuNkzJg82LtMXmcovFRqNCKHh5h4aXMn1/lqpXChEmcj6c0OS5Vakw3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This works for me, on b306deee4cba (mm-testing), x86_64,
CONFIG_KSM=y, CONFIG_USERFAULTFD=y, CONFIG_DEBUG_VM=y, KASAN enabled,
THP disabled.

Reproducer: merge 64 identical anon pages via KSM, arm synchronous
userfaultfd-wp on one page, then MADV_UNMERGEABLE it without touching
it. The page should come out private with WP semantics intact.

On the same commit, before applying your wp_page_copy()/handle_pte_fault()
fix:

  UNMERGE ret=0 errno=0
  AFTER_UNMERGE target_pfn=1153393 peer_pfn=1153393 target_KPF_KSM=1
  FAIL: MADV_UNMERGEABLE returned success but target remains shared/KSM

and every run also hits this in dmesg:

  FAULT_FLAG_ALLOW_RETRY missing c80
  Call Trace:
   handle_userfault.cold+0x30/0x3f
   __handle_mm_fault+0xde9/0x1c30
   handle_mm_fault+0x13b/0x440
   break_ksm+0x8a/0x100
   ksm_madvise+0x467/0x780
   madvise_vma_behavior+0x1d1/0x1e40
   madvise_do_behavior+0x431/0x14b0
   do_madvise+0x162/0x210

break_ksm()'s internal fault-in to unshare the page is landing in the
uffd-wp fault handler, which isn't expecting it. 8/8 runs across two
boots, same trace every time.

After applying the fix:

  AFTER_UNMERGE target_pfn=1063999 peer_pfn=1064929 target_KPF_KSM=0
  PASS: target is private and no longer KSM-backed
  FAULT event=18 flags=0x8 address=0x7f3dcb727000
  PASS: read generated RWP fault and remained blocked

No warnings or call traces in dmesg. 8/8 runs across two boots.

Tested-by: Mohammed EL Kadiri <med08elkadiri@gmail.com>

