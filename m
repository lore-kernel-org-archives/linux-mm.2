Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3D33606A330
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=b9AALT1R
Received: by kanga.kvack.org (Postfix)
	id EA93C6B05B5; Tue, 10 Nov 2026 09:13:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E81196B05B6; Tue, 10 Nov 2026 09:13:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D97646B05B7; Tue, 10 Nov 2026 09:13:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A91A26B05B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:13:27 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 30FB440908
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:13:27 +0000 (UTC)
X-FDA: 85419402054.06.DF72275
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf17.hostedemail.com (Postfix) with ESMTP id 35FC64000B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:13:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=b9AALT1R;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794320005;
	b=PXV32klg6CxllzZPmz/sHIhk4vQJSgCl1EaLrcyiGdKidz/3395ra97w4XMa19oLNEsVks
	oUIk6AnL/csd9bF3Gugkf9+mIGNDeTDqmSksG63KLwMAiLtzhHXLjFJT6cd+b44tJ0Hc6r
	u7KQimxJItILttSKC6qvb50TSyhNSLs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=b9AALT1R;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794320005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zxw5SnAxDIU0D0Hy3l+WBjwwTUDod245nHFu8beK+jI=;
	b=eQ5kM+rXLHJvDYp9rLUYGRHYNy9Pq8iutSWHRvBVluCi0ZgIDp8C6XuQaogtsffUPsNsIq
	AalyWbzdLPqm2jeEoJOyvqmf07cPe7EF82ycqOyucrqhlJnIk5W9kCjhotQt7qS9r4XLHd
	FyYXXgzYNuo39I+ItqPDqq2IAXAKFLk=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-945ae2daa3eso231568885a.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:13:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794320004; x=1794924804; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Zxw5SnAxDIU0D0Hy3l+WBjwwTUDod245nHFu8beK+jI=;
        b=b9AALT1R81CJVgKL7doRQsznGE+icBpHQ/WS7CIv/KsZyRZK/Ne70JStlKZ7vSg13h
         HniGLpHPhwb20xM8MoGBdd+0pFvpPCAGgYe0qioytrQQG9Mhu92IBYf9YooHkGNn+Lno
         l+pMLsrn3Lmlcqj5IxiEa0rD7/tcbz7LnuLZGowqLBamBZFLimmPFhUqtv8MNnfvAhSS
         dB14UJf/SlCrzcaXvxtdB8Qtc76YEM48rH4wsdCwmBIKFeYxj2PA9npXKHsZ1/Ohvwgq
         X17Yr38uVVsBnjw3Pr59CeYlxJ1IVCsKBmwBiDVg0qrSxI4g6Ck02PNS5Dd9bZsPK2X9
         37FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794320004; x=1794924804;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zxw5SnAxDIU0D0Hy3l+WBjwwTUDod245nHFu8beK+jI=;
        b=VdHngN7qWf5Nre4Ob7abJ/gs+chVfnuSGTSlGEeaO7toGPHM8o+MPQgzsxcicu/1H0
         8dvNP+mIpSKMQ52ppR7XrEJ68uKewjqAYwCKN0tmKl6BRZjOJyYHjhCZxDIiof2Tu0+f
         4ocJPV5NM6EZE0j37vRlFcNmNFVN4B+EOI/Rppzou/JbE3VHjFeKmHqq4fuy/FqcG+av
         YBYIuErANPOCWqiAExqIfjU+4PtVlHI9fOgGIO4eNTCd2zd9UB3fC7eUEceNLqTHHeyN
         F3s4tagwVQ+FUgFpVF00H34zHIQpkkdhUfpyGIZ7DS8rPz7EZMUqmHTUI1bi5xXbsG4G
         J75A==
X-Forwarded-Encrypted: i=1; AL+hErE2CGuklBuExGidryI7sLZLoCdz9/o8Xxwsr1Y3w/IXpYCiT1WqVZ+hlNKYwoXoxdE9Vb+Rt9ZJpQ==@kvack.org
X-Gm-Message-State: APuU4Z+6QNnIdkJYldW3U6CxRUJOKBT8hPxiQ/807lu2+2Q1nAjKaoSk
	AJiXy/uSQR3/B0Qi85IE1HhKg82TOJONZASotYYBtr6Gf0Lh44TkpwjbPHTuxX2Ca0M=
X-Gm-Gg: AYBFou1b0oTSolMmyE+2t4hLQ2Orlq6p3+13WJwhuNB/xIxPUDmEDSoC0ibNjpQ1OhF
	9LeAb9DxkdJqLSJDEEBXsvd3s5hhzl89RlAHQHV//sm9FoYyGf9XmYwu7i8z5D5NuUuH6DDe6GU
	PU6YPR6cTfSmcSXLbJ9bF24fSCxTTTw6VLoHjwQBnN1HomuaRVM46j8LvJR7T/mtV4yhffQjvmq
	1Cqo5mhvBGsNVrQ8bLX9A3nzqfsfV+E9m3Rjz75YACBDyFgfiKjyPoyqvOkUTC5WqNXEnQbcrNt
	xMIl1tFydkujmIPko6LiFF56C5zXgHnfXEJxwb88/YhG6MqF8HjHHFiMaze9xddFq1lvdiCvAKd
	YRcp6Z9yhbtTQCyrir2OXHo+QlNud7occMpPADE3Q957m/urkj41TcabvrJXW+Bjsskou1T4Sb1
	hwAcmCEABMR+ZLvX5gsTjBrL9Dd2zB+rgkCV1NUT4+47feCxdaiwUTOJQCwgSaeH8Z965irBiod
	nGfLk26T1KpIQPjN59PW9Ji8dy/X6NS1VNuSfFOxHR66T6i1Ftt1taWDvCwFV28uE/lq8voETkc
	2+2Rs11gxS4lMXfnc+nqMOQQxLFyHB17NYp7ybHgJmvV+OBco4Dx469EKZChwPRcElt2mXDUjNL
	G45mbLRE=
X-Received: by 2002:a05:620a:3710:b0:93e:60e8:c9ad with SMTP id af79cd13be357-9479f1e4728mr477644085a.12.1794320004354;
        Tue, 10 Nov 2026 06:13:24 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9479e7a7aebsm233058985a.28.2026.11.10.06.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 06:13:22 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [GIT PULL] page allocator hotfixes for 7.4-rc2
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 "Gregory Price (Meta)" <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
 Josef Bacik <josef@toxicpanda.com>
In-Reply-To: <717f8bde-96fc-42e8-8f69-a31a8a8d6f0f@kernel.org>
References: <717f8bde-96fc-42e8-8f69-a31a8a8d6f0f@kernel.org>
Date: Tue, 10 Nov 2026 09:13:21 -0500
Message-Id: <179432000122.2062277.3367569021688702450.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: cghzk9do4qr3n9fcbjoyw57oar9cnghf
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 35FC64000B
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794320005-115211
X-HE-Meta: U2FsdGVkX1/1JUq8qV3OHUClmpdGB+kDABE1h4ER5cqJG9NT0POMqLE+4Ch3gqpZF3FRWSaWnxemoxzEQA7H09cYu2K0LEwG3cJ8lHcl4Bm+zJXnieHG8ocSQ56jZXFsvkA5dP/9MSpgZAM0BWA3W1AlIjIP9APYtpXcIZgW861UUJTemSyPlCbBDuQv4CX7YlqEj+GC8Cozkcn7/dPNAdtirxwOb/3SDyMaeNs+OezKrslouN30NzTogkEsFufARcj2EAW/PBSY/2yjglMPAApwGA3FZhXwCN9AV384t6FExTqgkhKhQRhswt6Pn2pI1O9MqxMCmjdpDCu4INvriinf6oFZFBsl+rCBXOAnki6NT/kqgA4OHLHZk7vbpLgbJuAsP3XBJnWqj0N63nBlBdh/ZPWJl5XFqtpgugLFirkFIcRZcs9S5AW+wgYaotHtDYJGzaoC69goyO2lFviDmuHPLCMyR+srjSfFUAStl5BS6rX4On7WgEsVdyR4/4VITFUSozLwliLC6JlxoKoBAioyuAlI/3BGvsNmjbqhmyDR41TM9sdQn+5KLNsCCq4XxJJfTiC5U2NhHrkxQ06gW9TU8GLY20d8QYCsAYd0uZDMgZ2Qr3c8JQggl+pxiT+MqlJkf6X9CKmKv5HOrLtSNioicjby7KiM525dYBeHQRXsxIBTt1x3NDydp3VQ3vUElu2ApePc8Vk92Tye0E/frELlqYInX3oRHCd9BwmMYnOw9wjddn5CsEcErb3+a1IEf9S7YLCiNG//uCt2D+H4bEs9JYnhgBR/d63b6CT0/wQtqgHZF9qinwi1VLFkrrEgamRm7+98b379eyxwXBY3qOaiw7tjerp1CGuelou4/FBTswR/N252XqqrLc8aiUoPSQq+6434RNOuPWE8ofdn00PDRnaYBWivM+IvtxKXOwylI9d26ufTEtEcr814QfcdeMq65KsBXbRP+ig0vty
 WmERGWGx
 ktYnFEchVUVqa4VnXJ945/tsTi8G/6tViRsBIKjjR2uFMOyQSnNzgMb3W6defuTh0NZbUXZUSZ6XXIM6zGfZo4mI6YwOVQiO2iQSN1sY3EfKB+xD0vC3XxCxLC85cysn9v3NN/2LlR6/w4Sm4QmAWpqMGNtUsIz3551+tgAK/Pz/HdA8d/IcZLYBDOIw3MpXEA3nMcX8+nrG4kgawXWV4NJR5dFLO1dWilGjmv0ZOBCYwxyKdurDI4KdvuzoBtv/CCM4ZQRwGrIRGs1TCiihTdpdoMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-10 09:46 +0100, Vlastimil Babka (SUSE) wrote:
> Hi Linus,
> 
> please pull the latest page allocator hotfixes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mm/page_alloc.git tags/page_alloc-for-7.4-rc2
> 
> The page allocator tree has been created as part of the mm maintenance
> transition. Commits from there should be reaching you via David's mm
> integration tree eventually, but for now it's part of spreading the effort
> of dealing with the (AI) hotfixes.
> 
> In this case the AI hotfixes came from Josef, but since Gregory has been
> working in the area (hotplug races with page allocator) for a while and
> there was an overlap, we tried to combine the better versions of both.
> 
> Thanks,
> Vlastimil
> 

Thank you for massaging this.  The hoard of reports on the allocator
landing at the same time was really unfortunate.  Sorry for the pain.

-- 
~Gregory


