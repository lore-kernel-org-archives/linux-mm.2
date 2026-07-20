Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69097C44529
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:35:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DCB26B00B8; Mon, 20 Jul 2026 15:35:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78D3F6B00BA; Mon, 20 Jul 2026 15:35:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 654136B00BB; Mon, 20 Jul 2026 15:35:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 226EC6B00B8
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:35:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 90B021602C6
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:30 +0000 (UTC)
X-FDA: 85010159220.04.AB1F440
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf16.hostedemail.com (Postfix) with ESMTP id C995018000D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="IFD/onQM";
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KU1C1BFWfSEqKvrRpWFHlkg4mZCsJC5WSVAsWkbzWmY=;
	b=ki0n+x271vcUhjSWDvtFq/ZmOcc0JZC+HFdUWXcnPi12ZA/midiXXUXE9/YniOA/v2QhpC
	NWIBc/mMHl0s4L+sqaIII5DxCfO9k6LXQWhAekkvTGQvA388nk7HT8baDt9evBENACKk+l
	qq4hGsYHWJLTmt2YyFwj4FRwZZ9jqt8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576128;
	b=SmKo8EHd21tY7I8dEeP7+KmCL8wi60hW2Rl5reOiDGPR0ZcziNrG5kDYulBES3tDgehRj3
	M7k4Y5nDbtbe+3+ywcy4/LhpZXqg+O1SoxnQyvaxWtpFkEtSN4bvGjb7zMyYVvkOP3hr6G
	RZUWWxd/y2/eIr2Ys+105b+2SoafkFQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="IFD/onQM";
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-92e85499ffbso577754485a.0
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576128; x=1785180928; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KU1C1BFWfSEqKvrRpWFHlkg4mZCsJC5WSVAsWkbzWmY=;
        b=IFD/onQM9BlSfxoIfZgGFd5S5aAH2Dp9Nbavj8LMAQjQsOBjAaXiNay20LysMpqgn6
         Y4lo+UKiognOHamL1pOv8E6S+uwiVBNHDkx6zzFYHZtyZrFbyhFkpQH19nH4VsHIAqi1
         ZJMzu4hleiXHYd88ufLnfXpq1hrLpBhog6jbPdj8CMOci/5zW8bneZ/iSEfj31jBbvTa
         WgR74+Vf2BjRukbgMOmO0Otpzs0zegtZ7Q4IPTWBkPgxisSazjh1+pZkc2IaE/tVCRTe
         zEAamMyQfLf/zYHs3/vGDY7O1gvFZn9x+8E52cTgSinOEd3Y7qQ7AY8c+4EUMofcy3Bz
         4o/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576128; x=1785180928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KU1C1BFWfSEqKvrRpWFHlkg4mZCsJC5WSVAsWkbzWmY=;
        b=YOUuEQWrjbyX4BkMcMRnDzLIKcuju6wZ0D9v6tvL7X3Y7VbtAkTcXgQd8EqoT9H2Q5
         9SY48MQXascCigHaYiq6GCpCEARpfaTRHcEwCjGycp7hezVa2Zqa45WW6xIYjNY2qwwV
         gtLUzkP+gXhNjsFhQJ7xTqUZ4x341mrs03SRHYB2ZGWFLepHOsmEvNUutS153mVCfkCD
         XyNaFNrcbBbHxnCiyhFMcP+EHX1fQjGwmoYcGSo0/PoyJFvtvbsi4Y7ee/KrwZw34nXs
         v0Kd4IxrJYR8YpcYDEoRrC4i2hTZqSe8tMgP3Iy6zlVgwKhfUIz1xBlEF+gu9PKQUFp5
         2IxQ==
X-Gm-Message-State: AOJu0YxjdHzZPHc/tm4giWnAA/jO+h6mS/c+LXkh3VNLppNs3eWaZ983
	wTTLSjFLSyEclwh6/f3d87EimKYr3vl8oUQ4HjQpozosFjYHHvys4Ef2+uSq5LTYxewOvRdQTf0
	auScf
X-Gm-Gg: AfdE7cmJDz0qp4LisLeTHXt0c/xMs+mk9UI3GOJJC2p5hSeAhCEUFQ0Rj7A6aCUxeCt
	Lmyk45CsxF765G7V1QDEUKH0/H0I29gif9X8y6ahuId3bZb7tKogD8R8VZFMSM/x8IRjFI0rS+b
	dN9b6TWRqyUJezpztyKCwBR/Bjp/LRN7VQ8PL/dfC83QNdVBT88t0nT6YHXD/oYEdScVBiFjcUO
	0Zu2HwrPO9Dm8LpIb7YJh49wsd1V0CIOj2HLoGsb6xfmqtgzQeteMZy1OFqTkRF+Cb8Lp45buF9
	uY4dtyufNwp2Js//TyWnS+aBzQXfos+XHp8RwhP0LYveABoA68ed/fa8rhRCiQjhKhTlVSpkilW
	AhTPi8wmVi41HM21Qtefklva1sycaRjYpYULo22Lv2+EISvgBinVZN1pZQDylGOAsAwEgorROFh
	p1wC0wE4XDcSK3PRzDGqjxUCtTdYp/qXZpvWMaEhlrHtbZ2GQ1A2hWMcApFZxSQ1U=
X-Received: by 2002:a05:620a:4588:b0:92e:4e88:f453 with SMTP id af79cd13be357-930b41a0726mr1469051085a.52.1784576127960;
        Mon, 20 Jul 2026 12:35:27 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:27 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 19/36] proc: include N_MEMORY_PRIVATE nodes in numa_maps output
Date: Mon, 20 Jul 2026 15:34:13 -0400
Message-ID: <20260720193431.3841992-20-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C995018000D
X-Stat-Signature: ctwqrd9d4wj79qprectnw4odppdwfmfa
X-HE-Tag: 1784576128-29850
X-HE-Meta: U2FsdGVkX18lL1jIkIDfP14BXLKEer0+SfUo3qzvZqBuM4eYRpUmicSbXs1uVvBol4whhu2EtQZuD0GEGn0SDAoSBCz5RCLiOULleA9Svku9AP8vvOqhWfKQD/knM6fVefRPRo5tSIlHidv/gw65pm4vhoAl6qARYTTXFO/AHXTxlMNynlVrpxJCViNjDNEPa3zUYQu8VEz5EHseOFuQKPqFO9QCN1AExQ+FtKFgPs+QYujAv7gMnXajsfhYn1ejkG4mcn8VPmsOfYQXutZ8gqvj/Vfcz8l93+5/uhvb8M8EY/waj0jfdKZ0thZa52CqzRM2oy4VgXi8WzB+O4pJp0ISou2wbLb/NFT+F2QRdI0nMof6fMy1DQH8y/P4Z+iq5w7JRRaCRXNDRz5gDxRVSyqZUTSpNN4ByViILieOmEmdqHrJAoZsAbRwHg2xVHM1LfN8w+YETFZtOMFxD6wswD5ogzQ2xESatCx11elEyQOAMhBJpZc0/6jNztGm2tRShpeZjgq154AMQBTZw23PlpILd55mJRynZTsBJFqcrvkCkP/9VGp0/9xRybpLHV3N4UhimhxetbR36MxDzS4sqWJukkAvvzjRtwUtPNPiLCdbhaeNF1oasmCqsy/I2LNUEO/AVuOluvIDO7YIY6wZziZjZ+b8kv7pFlS+v0Y6iqG+k4DXnRmzDKoDh8YTpqRIohZ0DNU78UjxrG8G7LuID20hkmapWYGVGUfqbN7R5SHsTO7C7AzUKG10eF3nV9HFCMG/yts/KsDliMcbEgZ2cc42zOHU+ThwcEeP7YxWdlGcDeSgDqquZSHRvt2oOXKF7jBVR+VbZ+mJfsa2jZ8bAXNNZH0yVqPU6v8EdiuBDckl8KKs2vH8fyRsGfyEjev3cokAEpzZhI0tZBmhtca8xHoOUOCuZSZy25KlUoe7G6jnmmsJxMXctiaokOaLmsWzKUUOG8BaAGRtmmwRpg8
 /WjWxFXg
 JZsbDTjFS59z6lQbY0Lsf6Vumr+MyfxuGUtaFgYivV6VMoF8fMzhYJVDjDcLU2SC8rLIlMRnPitBoRzkEnckcvGEBLdEbemX4ZI/HLAgUY2mkHUh4jB9X4CTAvY1veO8HTgzaPILvmXPBEwRSuzoNdnsPAnLTEGQm0kdNbcqIAB4btkbcrjcUyKxwMfg6Ezp6exY9hytlxvISFD5JaAsckehhjsK1w06MLD2udheEOxXu3gKUXKAJpGDZ8yOucL+ZfFn9FZpL5uAeY4Dydq4O2PDxdErgpzDwohxQ5jaFjDVM66oKRQHbw7par7pVqjRoN8HjsEZzTo2y5SxUNVJKJoqIQR46ewLK+vprwpVTVzTtu3M9V6lrUm0vTJ+9zbiDXnAVmz+p17KTDlFHzR6/zRXUv0vTTOJWcgTF6MM41uazmmc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

numa_maps collects per-node page counts in the page-table walkers
and emits them in show_numa_map.  All three filtered by N_MEMORY,
so pages on N_MEMORY_PRIVATE nodes were never gathered/printed.

Accept N_MEMORY_PRIVATE pages in both walkers and emit private nodes
in show_numa_map, so private-node mappings are visible in numa_maps.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 fs/proc/task_mmu.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 817e3e0f91943..e116cd5f157b9 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -3389,7 +3389,8 @@ static struct page *can_gather_numa_stats(pte_t pte, struct vm_area_struct *vma,
 		return NULL;
 
 	nid = page_to_nid(page);
-	if (!node_isset(nid, node_states[N_MEMORY]))
+	if (!node_isset(nid, node_states[N_MEMORY]) &&
+	    !node_isset(nid, node_states[N_MEMORY_PRIVATE]))
 		return NULL;
 
 	return page;
@@ -3414,7 +3415,8 @@ static struct page *can_gather_numa_stats_pmd(pmd_t pmd,
 		return NULL;
 
 	nid = page_to_nid(page);
-	if (!node_isset(nid, node_states[N_MEMORY]))
+	if (!node_isset(nid, node_states[N_MEMORY]) &&
+	    !node_isset(nid, node_states[N_MEMORY_PRIVATE]))
 		return NULL;
 
 	return page;
@@ -3602,6 +3604,10 @@ static int show_numa_map(struct seq_file *m, void *v)
 		if (md->node[nid])
 			seq_printf(m, " N%d=%lu", nid, md->node[nid]);
 
+	for_each_node_state(nid, N_MEMORY_PRIVATE)
+		if (md->node[nid])
+			seq_printf(m, " N%d=%lu", nid, md->node[nid]);
+
 	seq_printf(m, " kernelpagesize_kB=%lu", vma_kernel_pagesize(vma) >> 10);
 out:
 	seq_putc(m, '\n');
-- 
2.53.0-Meta


