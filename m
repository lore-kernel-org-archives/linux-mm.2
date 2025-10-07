Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77492CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 16:17:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C20968E000D; Tue,  7 Oct 2025 12:17:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAA4B8E0003; Tue,  7 Oct 2025 12:17:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A98E78E000D; Tue,  7 Oct 2025 12:17:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 928F18E0003
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:17:34 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 49E5911917F
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 16:17:34 +0000 (UTC)
X-FDA: 83971823628.22.EF89645
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6E704C000E
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 16:17:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K8fCdafY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of jpewhacker@gmail.com designates 209.85.166.53 as permitted sender) smtp.mailfrom=jpewhacker@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759853852; a=rsa-sha256;
	cv=none;
	b=JttWn8c0r7QjysbB1lhmusre2N/AaIMz3Q8YPAAFUP6mzA/+UMC37WESAFDT91Iew17eRx
	2WzAR9IHQqIqaqaTVS32Chv2RKogx2cHUXdMMVn/zetH+Itv+t9aj0zd9DxiZTzfc1v5+2
	GhYr1moKc9X8/O8T7wKswpyDJtTR1Tk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K8fCdafY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of jpewhacker@gmail.com designates 209.85.166.53 as permitted sender) smtp.mailfrom=jpewhacker@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759853852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zKULPQQuwiOMb26v+cKjhqRJho79LgmVc0rOc9shKDs=;
	b=EYoJJBtLyK3F/AtuBHVMqaSrUhFKfrFQTu6VmKkX4m7PowyKzzrD+4Y0/YtgZpCqEUDUai
	5NQL+XXadiyft+fZZrFbw80Llf03otgMzZr/zWCMi6yuwAgaijcbN+4yELKEPBWNw6wwdU
	8Ux6UflLIZuUGKZ4DzdK6+DNxbBj4W0=
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-8ca2e53c37bso552122739f.3
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 09:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759853851; x=1760458651; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zKULPQQuwiOMb26v+cKjhqRJho79LgmVc0rOc9shKDs=;
        b=K8fCdafYojl7N86GRoyX+Kcr+AbgdILmMzwFiay8+Scj05ADYSgZ4Poh7VZM4SYwkB
         z7S/SwfUh3KCUI1IOP5+s10gruFrd9KbnJf/srh65siSh0e4WrN8cAEC9/6x3n7beORx
         fFylM5UYgQ19Mox1b4U1l0i4dTINGgW2Pd6CMQfzZ7/Vw9luX8hAesNjyIGKFFDemzR7
         cO5CdOdsHrCdXEweOLBznml83YbG4jBeYmI/CNsU8vQHCZkPBoMUOaFP+b5L36vr3WPH
         cAgjpwAM5Hj89GlhY8O6xQD04Z+8RYj+tAW4+tIvD9r14S5j5ZFWmmC4YTahXRxuk87I
         VJEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759853851; x=1760458651;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zKULPQQuwiOMb26v+cKjhqRJho79LgmVc0rOc9shKDs=;
        b=WqcjL626MUBINr/mwnP8X8j8PILR1qtkj9wiwjSufF8yCS+777fSh7+xEP3PTzt7Nx
         H+p1JUg+8uFnb+Y21ANmpkQtgwspxo06GiMQ/Dvd5HPmR6cqiqjic3doDMPqZ831ajLZ
         HIBaF7u9EOLJwUo2k3qztI7tvSIU2z9OKJLbDVyrMvnM3VK65vci0A1hFe6wI4ig+e8R
         fBqMgPCcEUwIv7q24wxL2ziOuy39TxCVIjWDMQBAcOnBur79QXNlyCEs42dSAqxjnJG0
         7LnsgrY2SeC9dMso70Yn2PvwpMGsXTkJsdTq/s5kaRD3uMOs9Ubrva21nxon8zV1OD0w
         mjQA==
X-Forwarded-Encrypted: i=1; AJvYcCVU3rZFN54r0Pj/pdIyJkiDMJuIZYlc4ihZeXShUVUnDhze8X3WGjNxSZ28hiTPiV0M7XFlhaK0ig==@kvack.org
X-Gm-Message-State: AOJu0YxfPXpzEwgC8yT7ixzvxbFFva2CksFHyW8F9T73BQKTy3rc6sLB
	AK8hr5AtNIsaiyc+Yjg0F958PuTkmkYOIRD3roCv/xlWAH1Y8D/nkejB
X-Gm-Gg: ASbGncuQlUwDaQ03spNTzE/2evjJvSc8BcvJvyyL9eqZ4Lqmd1E+iZEfAp45RJtbC1F
	jXkhcz95EZZKtgoyp3NUNdPzDf76/ILGrLntUWs1GKDDJxeI0IrMeDdihlAE6W6dos2Ssz07mlh
	Nk7Kr3pTOQmX+vGEfsOZM6kAgyAg015PFQ/zujzVUWyRInhUyr+IQuI6+/3/vBIUOwgibl/ksJW
	gZUbzYdk28ujfPthBC25qSzp904VJmhjKa0QWlhIYnOxXRtl+gAwUZK4q+bZXx3QLuhmdwGT+Nv
	NS3TuLJ6VmUQRHkbxRnyXNCkY9YTjdNK1hw7a4WsRJXwn19R29e5j7/wSjWdhmrFY+XuA0E1b9X
	rYfc7+ex12p1X1c2Ypr87Uafvc8O81g49q5vIwzStBZzNE56w06B05eQ=
X-Google-Smtp-Source: AGHT+IFyXdSH5lmXmhQmU+6+2rFb2XcvaPsAqqFnlPFjaKItZfU6kDMDObVgHMoy+y6gZCvNhaIPTw==
X-Received: by 2002:a05:6602:2d91:b0:937:43fd:ee68 with SMTP id ca18e2360f4ac-93b96ac2dbemr2694731539f.18.1759853851293;
        Tue, 07 Oct 2025 09:17:31 -0700 (PDT)
Received: from localhost.localdomain ([2601:282:4300:19e0::7bc8])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-57b5e9e8efcsm6273618173.2.2025.10.07.09.17.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 09:17:30 -0700 (PDT)
From: Joshua Watt <jpewhacker@gmail.com>
X-Google-Original-From: Joshua Watt <JPEWhacker@gmail.com>
To: jimzhao.ai@gmail.com
Cc: akpm@linux-foundation.org,
	jack@suse.cz,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	willy@infradead.org,
	linux-nfs@vger.kernel.org,
	Joshua Watt <jpewhacker@gmail.com>
Subject: [PATCH] mm/page-writeback: Consolidate wb_thresh bumping logic into __wb_calc_thresh
Date: Tue,  7 Oct 2025 10:17:11 -0600
Message-ID: <20251007161711.468149-1-JPEWhacker@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20241121100539.605818-1-jimzhao.ai@gmail.com>
References: <20241121100539.605818-1-jimzhao.ai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6E704C000E
X-Stat-Signature: tqyq4ddk8g857ihe8n3qsts5rpw6y8sw
X-HE-Tag: 1759853852-188643
X-HE-Meta: U2FsdGVkX19u7rCBS5sY8D1sMZ1wBklOPm4jeGIhjV0xzgN60T+JohJorzSN/xKXyw4MLX02G97T/TncpeMPl8hRfmfhzXkhyMIrE/WB9bXjyyeHZdwPi1nBuIqqrvaJZkIpR0l68SoLUKOg8fc85Fk+zVX6FOvZVuCIsLQ+WfUQ3fgjYFR/QdBvB7geelQ0wjKDHRx4pUTMiV5IZgx4A59sYBGcUsY07e1o4CLyQOdWs5WgMe4uKN8XmT5uctfX1rlmGiiKppdI1ojbqDmDrgqtBdbCWcOId3ICZd5F93doNigvPRrMcHX8DoDLWf3FEwg9DREmajZofE+7rShKKQjog2KHj+bqKq/muVaba8/WqQwUMptV6m4NakbgIVkpa7mSm59v9CXssx4oQcywpZQBMJrVPV6HeLinZ4NGNhAAEOwt2+Un1PMb68wcTO6jdlRfG9CGFZGzJPEPwdZjJVE2ujSAhw9T4b8U0FZKPTx8w1N+e6SQVk+oY3txZ55mXdWQnPZbehcS1l6FFVQCrd1aas0r0lCigpSj3wSXHBAWm5UbOeTMCA+g0iqz7zgFt1n3+Uw5qN5peUX8WFp2DdBOgr8tbSZLBfNmmkvwi4R5n2jYpZyXm14cTDVzD425ofx5VlXwOPQs/dhiufHDSv1hj2RmkLhlq7asWr2slJaIyQaf4yOa9OtfqWKndFRj7iWER20hV6p+c6Y9z+htmvMm6Wrmgijf/rDIfD/0Pb80glhmIm80mvdf5vpiT+0SMunBTU3UArprmynvS8ti0e7zok8XACRW0wsr67MUukE/S+L2JeAIiDzaeDjR/ZWMobPayw3IIOCzBNTm553m95oITMwepwJcYE5dSnfvw9US+AKobtTFAtSqX5higP97+rFRZzVelE5nJgJOvJ81Le06EzwX9z4XVubcFsDPhGWSt4R7SJtyiUioGAhEeqW2Rif+dSw35tQVsBYIrQa
 09hQbxkQ
 geLWuGQr9OH+hmvBLYW4HavHGkRUXWWbjXNu356iwEwuKU1nruUSYHJLT4PkaVPdVAXC1h82DsxLlr327WSDGSt1+bnV+nU4RLRv/KvUj55P9aACz0bFmYiXneA0nfGKLdcpTFKw3WqFOXFzd7/4htY86QcEvTvYIyh+tcDjt9icYIHzuuYj+V1oMme7cA2AFljAdscoWWw8j3w2Oe5qYfkTwoim5DiZaG2kZCqUt5b7Kj9gCgjtMgihClBNGizFoE4Jn26h35c32R7nQcX/NcZUPLzqfq4VJLGG1QfRIKH2KNodn5Mli3PjllLGlCP3tY4av6QqtUysZX0rnWeNyGwTGOQV0coNxAUtVPV/pbcduEP+2xi7wP/pgIKuF8P4tLec+u2Fsc02nF/IREh0tDqyUXeRLkPzDB93b+B+bytiFXqCjn+czyylj2jHt60u4orlxmkdn1Fr65TZdklHvh/3+ZQT9n4CZyVB5A6sblCbyiG9GMVv4tIXsawmSrFhM9npUvn7iGTmP9wfx+XePpmCs3y0iGMwYluu6LANo9ZuzwA1Q7k+FjOospBA3rEn1TDRA+VXpRGplWg/gbOCnAXL55d8pe4hp8TvA6CkoR1ENGgE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Joshua Watt <jpewhacker@gmail.com>

This patch strangely breaks NFS 4 clients for me. The behavior is that a
client will start getting an I/O error which in turn is caused by the client
getting a NFS3ERR_BADSESSION when attempting to write data to the server. I
bisected the kernel from the latest master
(9029dc666353504ea7c1ebfdf09bc1aab40f6147) to this commit (log below). Also,
when I revert this commit on master the bug disappears.

The server is running kernel 5.4.161, and the client that exhibits the
behavior is running in qemux86, and has mounted the server with the options
rw,relatime,vers=4.1,rsize=1048576,wsize=1048576,namlen=255,soft,proto=tcp,port=52049,timeo=600,retrans=2,sec=null,clientaddr=172.16.6.90,local_lock=none,addr=172.16.6.0

The program that I wrote to reproduce this is pretty simple; it does a file
lock over NFS, then writes data to the file once per second. After about 32
seconds, it receives the I/O error, and this reproduced every time. I can
provide the sample program if necessary.

I also captured the NFS traffic both in the passing case and the failure case,
and can provide them if useful.

I did look at the two dumps and I'm not exactly sure what the difference is,
other than with this patch the client tries to write every 30 seconds (and
fails), where as without it attempts to write back every 5 seconds. I have no
idea why this patch would cause this problem.

Any help is appreciated. Thank you.

git bisect start
# status: waiting for both good and bad commits
# good: [4fe89d07dcc2804c8b562f6c7896a45643d34b2f] Linux 6.0
git bisect good 4fe89d07dcc2804c8b562f6c7896a45643d34b2f
# status: waiting for bad commit, 1 good commit known
# bad: [e5f0a698b34ed76002dc5cff3804a61c80233a7a] Linux 6.17
git bisect bad e5f0a698b34ed76002dc5cff3804a61c80233a7a
# good: [5f20e6ab1f65aaaaae248e6946d5cb6d039e7de8] Merge tag 'for-netdev' of https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
git bisect good 5f20e6ab1f65aaaaae248e6946d5cb6d039e7de8
# good: [28eb75e178d389d325f1666e422bc13bbbb9804c] Merge tag 'drm-next-2024-11-21' of https://gitlab.freedesktop.org/drm/kernel
git bisect good 28eb75e178d389d325f1666e422bc13bbbb9804c
# bad: [1afba39f9305fe4061a4e70baa6ebab9d41459da] Merge drm/drm-next into drm-misc-next
git bisect bad 1afba39f9305fe4061a4e70baa6ebab9d41459da
# bad: [350130afc22bd083ea18e17452dd3979c88b08ff] Merge tag 'ubifs-for-linus-6.14-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/rw/ubifs
git bisect bad 350130afc22bd083ea18e17452dd3979c88b08ff
# good: [cf33d96f50903214226b379b3f10d1f262dae018] Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
git bisect good cf33d96f50903214226b379b3f10d1f262dae018
# good: [c9c0543b52d8cfe3a3b15d1e39ab9dbc91be6df4] Merge tag 'platform-drivers-x86-v6.14-1' of git://git.kernel.org/pub/scm/linux/kernel/git/pdx86/platform-drivers-x86
git bisect good c9c0543b52d8cfe3a3b15d1e39ab9dbc91be6df4
# good: [40648d246fa4307ef11d185933cb0d79fc9ff46c] Merge tag 'trace-tools-v6.14' of git://git.kernel.org/pub/scm/linux/kernel/git/trace/linux-trace
git bisect good 40648d246fa4307ef11d185933cb0d79fc9ff46c
# bad: [125ca745467d4f87ae58e671a4a5714e024d2908] Merge tag 'staging-6.14-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging
git bisect bad 125ca745467d4f87ae58e671a4a5714e024d2908
# bad: [d1366e74342e75555af2648a2964deb2d5c92200] mm/compaction: fix UBSAN shift-out-of-bounds warning
git bisect bad d1366e74342e75555af2648a2964deb2d5c92200
# good: [553e77529fb61e5520b839a0ce412a46cba996e0] mm: pgtable: introduce generic pagetable_dtor_free()
git bisect good 553e77529fb61e5520b839a0ce412a46cba996e0
# good: [65a1cf15802c7a571299df507b1b72ba89ef1da8] mm/zsmalloc: convert migrate_zspage() to use zpdesc
git bisect good 65a1cf15802c7a571299df507b1b72ba89ef1da8
# good: [136c5b40e0ad84f4b4a38584089cd565b97f799c] selftests/mm: use selftests framework to print test result
git bisect good 136c5b40e0ad84f4b4a38584089cd565b97f799c
# good: [fb7d3bc4149395c1ae99029c852eab6c28fc3c88] mm/filemap: drop streaming/uncached pages when writeback completes
git bisect good fb7d3bc4149395c1ae99029c852eab6c28fc3c88
# good: [7882d8fc8fe0c2b2a01f09e56edf82df6b3013fd] selftests/mm/mkdirty: fix memory leak in test_uffdio_copy()
git bisect good 7882d8fc8fe0c2b2a01f09e56edf82df6b3013fd
# bad: [6aeb991c54b281710591ce388158bc1739afc227] mm/page-writeback: consolidate wb_thresh bumping logic into __wb_calc_thresh
git bisect bad 6aeb991c54b281710591ce388158bc1739afc227
# good: [f752e677f85993c812fe9de7b4427f3f18408a11] mm: separate move/undo parts from migrate_pages_batch()
git bisect good f752e677f85993c812fe9de7b4427f3f18408a11
# good: [686fa9537d78d2f1bea42bf3891828510202be14] mm/page_alloc: remove the incorrect and misleading comment
git bisect good 686fa9537d78d2f1bea42bf3891828510202be14
# first bad commit: [6aeb991c54b281710591ce388158bc1739afc227] mm/page-writeback: consolidate wb_thresh bumping logic into __wb_calc_thresh

