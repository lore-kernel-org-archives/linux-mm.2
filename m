Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47409C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 15:01:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A0866B009F; Thu,  9 Jul 2026 11:01:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 351BC6B00A5; Thu,  9 Jul 2026 11:01:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 242E66B00A7; Thu,  9 Jul 2026 11:01:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EFD706B009F
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:01:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 861361201F4
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:01:15 +0000 (UTC)
X-FDA: 84969551310.09.2FE0F44
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf01.hostedemail.com (Postfix) with ESMTP id 415D440019
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:01:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=T41BnhzP;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.48 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783609273;
	b=vPex1BTEpMIpbWYHQI/zRmVKdRM7mcvLKDlcvQyMBgCk7jjrsYGDFuG1sFM2wPwlb7SEUZ
	UXT+BcNbKHnAcTS9GMNsT78mEqYox3JUKv7W/QDrI44oD5nRDvhgnOahLXLHlGh1655R6J
	cyA0mfj903Q2hXZudX/0ZVCXYRNsMRI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=T41BnhzP;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.48 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783609273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lCoCDKvKWAelS8ArabvJ3verPItQS1mXV1mG6RVch54=;
	b=QsQ6KmsyAIB3YitvUmEmRBFhqrK+oLsiitWEh72wtNlfg6AaMBRZVLFa0a0XMYtQONQr+2
	cNHYBF8Vre82TL1RP8hohkmn7wh6c8G07/JGy6pXBqqWoP10yqwlvevH/lC+YIm/OFqscK
	o2+W/7ss/vHZYV4QASASS9O2Wn7IaFc=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8e5be46f663so84536d6.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 08:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1783609272; x=1784214072; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lCoCDKvKWAelS8ArabvJ3verPItQS1mXV1mG6RVch54=;
        b=T41BnhzPftbe5CC1rSiIvyqks4IxexloUTQCQqh9FxVzU8tcH7iI9xgdr3moT8Am9x
         7dOfFGb8XLxa0NgD3JMNBGPci17PCTUIsSem5YxAVELUM75+UeLeMiHFKu1B5GdXgBq3
         b16OcNXvUTD/Jqjav/Om92F4066DWaCpJY6unQS30t9RdDBWcaA8OQIXkjwzx2zHSPyB
         BJpNCThFuWlMyok9mgYs4wN0J3jT5NtLQW7nCYifXTxKoYHIoHjKi2zCzFRjIhFQkWip
         Ux24T4fyOrlt5FopXPWsqCNSIdKiovOjQgXSlIRr1qAC4zBVyaJyKojAeLkRzuuW4uxe
         aEfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783609272; x=1784214072;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lCoCDKvKWAelS8ArabvJ3verPItQS1mXV1mG6RVch54=;
        b=qRGsXC2DJMQtgq4pvjTldWsv+Atf17ix8bpIZDtvtOTQS3g0sgNMv4NxZc1WLsSjpL
         ViL/pVi+w8trwNKkIP3IDlIFB1V/YbSvE69wAxWn9rvOaCkgbJ8F8aYLhnQPq3I0NRNG
         DaSPXUgtsWrCAotur1PwMnSxeIoEHB847qLSaUSAeD4LcgzekC3W8iUQFOOT4Ypr91yn
         AY4pQxCIYQ3E3vbSOY1v9dcJ72YRi/5BRNamsBW2r8eie/q+xwYlshki6ZrTIpVWwRao
         HCD2z+nXhm5iKe/PLLIt3NEdodXz0qkKQWYJHHpFJvGIuEo2IwQFBLNQ4fNgqsdfGlcR
         CAKw==
X-Forwarded-Encrypted: i=1; AHgh+RpdaeBBYa4C8toUwDDtxfyLpBuYY4nUF5v36ptNQ4CTNjyxg1vejsJPrhbdCDGZlVObeXTeKc2erQ==@kvack.org
X-Gm-Message-State: AOJu0Yws5A+Del0KE/Jc07CGUjUQyHC1rsvarHzwYW5yikH9n7sHwfsD
	1QJNvKEMFD1EVaNYTzIenKEX+9H6kuMpHu+cdEiLCMnGEEQh6q+Cq8pPRINRTg+52aA=
X-Gm-Gg: AfdE7ckT8suVqULsT3TvMi/VthzxAQSZaErg8mWmIZGhgIZZt/SJUPrHkbQF7GFP44c
	OVN3hLKyt6STL1iwhzRjpg7UIAQgU4JarzndaFJfZ5mfRZVjIjd6cxfcKVpnwcIHi+LVxrfuzTq
	ajAdN+m/kdpiX+p552FkagAFlxTv3bH+/lydI5W8rJ3I8lLv9sPshPF5RMp3vB1VQScXyIJuj0V
	uY/LMurtj1F4B2BaZelbr9MROtaRyVvoKdK2OMlVnFFDw1oM9LmiCo0XfR0GMyseBuqJ3SgxUZZ
	Bm26Gt1NS/CRU/ut5Z25kRm+cSsX1IbuMbXu2A45xup1RwmV5WurO2zkfoM1dln4Gy68YctWNH2
	KK4vNO2zK2X7x6rRXjPQ2JPc/QLOZ5cwLqjSIJp8t2+xFSyPTESI9uodC1TNGhN3gOrYa5Cp69l
	8iu90uhx/ftL0=
X-Received: by 2002:a05:6214:1305:b0:8e9:f62b:8fa2 with SMTP id 6a1803df08f44-8fec342e855mr93084796d6.55.1783609265440;
        Thu, 09 Jul 2026 08:01:05 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd81f4bbdsm18994596d6.36.2026.07.09.08.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 08:01:04 -0700 (PDT)
Date: Thu, 9 Jul 2026 11:01:03 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Barry Song <baohua@kernel.org>, Nanzhe Zhao <zhaonanzhe@xiaomi.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>
Subject: Re: [RFC PATCH v2 2/3] mm: distinguish large folio swap allocation
 failures
Message-ID: <ak-3r4i2qdejYzSP@cmpxchg.org>
References: <20260709145124.764807-1-xueyuan.chen21@gmail.com>
 <20260709145124.764807-3-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709145124.764807-3-xueyuan.chen21@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 415D440019
X-Stat-Signature: cuqg9z77ynhn5xhfipc5pcrrpxz1r5q1
X-HE-Tag: 1783609273-934040
X-HE-Meta: U2FsdGVkX18fOdeCzjtaklHKNOYO5WfHnrK90lfA3dqX7nD8CSEoHCoJWjGcHuF3vzV8vLIAwSQf4BIizO7zweU2Gg93yUz873hy3d66Y5C/W0BJ+ZhDtbFEhWryy6RsZlfl2GhnBr9K2bGnIF6C/WeLe+sOaaMN3+3qAjy70ps3K5/0u6HjVJDntYnVxYvtLKZozKh0632F4a5BYkNOLpmrbf/Pm/KMu919e1WtRLbUheilxvBEqMZT7VikFKiAA29h96nSAY9QT48iCXbWKBCe/YdXZ8a2XiMEOqdf5NrPggVoLTwubhhTdwqby8I6YzbYwO4EwGx2MHKyhQm5M4DwqCZLdGezzX12J/2nZ/mZtMszJpXHG6VXVU1tlJCYWgtDTGpgH9nARQ8DrRcpN79bMbH0y+Ew/QJ3f/BVjeSOMbjwyG4KuCmhLgc6gp26f0YCCF3wnuu948ZHvfRNBLXJoFnlU5jgky9Z15dgRBMpk6ZjV0S6l628S7kt6+E02fCNxscRW/r+KV80BU3kH7aQGL48Sk0BykqGI1HvZM4UGU6JR2Ms51+ZiH72qM6TCxbVaEb61Xt/RTFLRT3193JI5tSbP2mdQ+EP0Ef2Res3TmRH3OoCgHR0tnifT9B/Wz53IXBbYBtmbS6uIr+BaS/YAY+ltpF/1XhwTYU8QbFHBeNiXVNzut58TSDjiXg/Qp1mj0zOZ/t0arw64Tbp8BqhdI05NC6KdCz53wmQSdGnChQ21Puo2J6AnEYU0A7fvRkdjtUA9UlKHgNfMwXQViwBct/4tJS60mlUCzIRO/RKK1RGQ8VpUFYijIZo0/CMX6vzlQvT63ZqLrEm01SfRqbuljB2fbXzJP9LBqsuq1sCh3jVRt7U+1c3o/S3jtfPBsQRR6c5RhWNvkNtzuMnTmANVMSOu/i2WGdKgfmgHam0DV/gFQFoIGPfkvMEUM5aKh9X+VqCuS36y6j++On
 vs4yFyfd
 NGckQVvlBibrl6kyQvsPcyrjgJkm4npNOwKCgni3AmKr2hBtLGM0sUtVQ80f1wXIf68dosToQjfZDuIQKD1LqIpOobFAAj2w41kW/gAl7+zjxTd5lFbsGsgM7dc1pPeYGtVtg5Irx5gYtPDccScjO/50qmRnwjxx3ZnSgUaGpJdAbef2W39WxWO3WUpP6Kl5EIRn3EPOFR1C4h8MlXbKZTN35hoSSaPYjoEZsZQRSBIS85mmOTzMlKORJtrYlTW4cQj12xP/qeN9JfNi0fMtJT8Uq6vOS6qbesf6IXGWknPbZw32x5azASObNbRMP3mNXv0YqlkmyKgOIYgEQvXUSdbKHSXhNQu7fZRkNTY/JEL1kQO3p7qfFfFKioHtjhghKEU7RjTlI4FTIS/kicfbJNWFqrBfn6lcIg12t81jxn85tEQ6+duyq12STC0/zKd//8QjYbJvvQMYi7nGJa34nlNbGO0+SA6xWh6QY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 10:51:23PM +0800, Xueyuan Chen wrote:
> @@ -5550,10 +5558,7 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
>  
>  	if (mem_cgroup_disabled() || do_memsw_account())
>  		return nr_swap_pages;
> -	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg))
> -		nr_swap_pages = min_t(long, nr_swap_pages,
> -				      READ_ONCE(memcg->swap.max) -
> -				      page_counter_read(&memcg->swap));
> +	nr_swap_pages = min(nr_swap_pages, page_counter_margin(&memcg->swap));

This hunk is unrelated to this patch. Don't mix refactor work with new
functionality. Make the previous patch a pure refactor job (where you
add page_counter_margin() and use it here ^), like I had proposed.

