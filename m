Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BD8BC61DD6
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 11:05:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B0E36B008C; Fri,  4 Sep 2026 07:05:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 588116B0092; Fri,  4 Sep 2026 07:05:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A1476B0095; Fri,  4 Sep 2026 07:05:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 20D386B008C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 07:05:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 88483C0A10
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:05:06 +0000 (UTC)
X-FDA: 85175797812.08.EB12C19
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf27.hostedemail.com (Postfix) with ESMTP id 99AAA40002
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:05:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=HhYH3YiY;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788519904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1rOqG9BbmC32OqlOD3H5WvHopYjdITPBpgRjKKEHgD8=;
	b=nj2KAWsOLQOYnHaDuK0qK6LaVKs8AaVbSkUwdum/MgRKufgeofajUwOKBziffsmXP6tbCD
	acmZ26y9QD5DT/hiQWJChywgxMGjnRFGloogrGsBb+Uq9hp1O1OfFdEg+/LjVoTEJHKTJL
	JeagOi5gvAlgnZ9q+c1USg70Y59L51A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788519904;
	b=vNrFxxeymZZ26vSYWPTD+/vUvFsGa28LbO9Vls7IgovQll3/RTSG4Yzgta9ral7LPPW1Qr
	UtSy6AAgUaJlTFhqww8Mv0vfUzpctpUtXrShEURG2j0LwbinAOl50+zRxNZYWu0KTpxozB
	VWQMwEm9yse2FoNNVDq5DclxWkGmXLE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=HhYH3YiY;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49b96837ca3so5855635e9.3
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 04:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788519903; x=1789124703; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1rOqG9BbmC32OqlOD3H5WvHopYjdITPBpgRjKKEHgD8=;
        b=HhYH3YiYnch6RM/M8pFKkaE2DB2AUIJpHJmXZdR6nK67LDDj51TPiOnkXoWO82/cfU
         ak4fhkCadz+EHgmG4AxzhcaGRYc0Wv/fbnmJxFtRuV49RcsM1BZ6yoIKEMbwIwnMDFbu
         pL064O1dJwCKNp0f1+XYGjHFdW0oUor69umPtP1KsySZHtIi47dE3Q+k1cDFyTFA+BPV
         uk8GJYrD2hUqOpPksgsZ19lmzbFlY8lJ0icm8eVB0n4P+oEHs/wuQHwAEvNB4/PHYpAP
         HNNclp3KxI8cPGEmuhbAlMOkZfJZceCakBNllZNO0MqcZ6lgf+m2WpxR9WJAOC76i5N5
         gAdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788519903; x=1789124703;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1rOqG9BbmC32OqlOD3H5WvHopYjdITPBpgRjKKEHgD8=;
        b=mj5eyb1VXVsFocW7LaXdK03H3mSP0wxV1S9+TdDIO5SvQJhTxWqmI14lLx9ldfM6q6
         X7e3YIbEnzFQAlZ80Hh8SnqwldgzUv/bSC/Wg3WKlUhbtctb4ej7j8WOZuic2oCJMtvy
         /iHh5E0fXkDbxQrOZSRdsD/tDKT2+Kl6s+ennEv83lcnrfzkHHL85JiOMZPMDn0droxQ
         XCQ2jR6uj0EvcExygIPTuTqR0F4R2FEVe2sXOyY9e6CNLB4F6pI85kdpRmQ5QR6I6QjH
         vfQOk5S+L7br5vo5s8xniA1nLMzhXRqqRNfUdg4RX1aMS5CpRRRIFpQTi7L9fdH5hQii
         yNyQ==
X-Forwarded-Encrypted: i=1; AKwUvBxOSpL/KdTVFlUYfvqsUJFKvZKDHJFIKvkqfl3RXApH61M3z2et8RPETOKrYthX2gp3Wikf6O9KCA==@kvack.org
X-Gm-Message-State: AFuF++mUP28hIxStA53/DFpMJF0fBBxVdEefLEs5wnXLZ/DtjgC21mmv
	NvNkNrDZIauYPHRJcyE0jniAkCnwmuOfN9XHCUgppcohD261TXlWSEn1xD5hgmR1LJs=
X-Gm-Gg: AYBFou07rpLe6aCA/dQYv+p66Ieu8D0o0hFuDyIrj4ec/evxjYXgImfOwcsUmGU9l7E
	7OyMbfFrFDGkg/tV5WvHgtGoMnu2pXrWJ1Zd0r1rpIcOhFB+ob+BCZXZ/TKM079s0y8MDSLJHYF
	xC0hYX5RKpTl09NyIXViSCsvqW6Spi5dgFra/ZwUIl49ruvhRK2Bsjs4pahH/KyRiPAbKagFHxn
	NFSl4fXecaEB7tp1vaGhXx70KFzqWQ/kCzj6+Utaz4alhn3TO7OLE7Oh3hooDyoacZ4ezSIHeSF
	aZNGN/yajJ+A9UWH6ebPPw8ub7VilazmKp7I4dUm9lq89a+9X7Rj21zPHMWvdBRgdIXFYi1xVj3
	2GvBJ7SD802Ws8Ti2V1+HGihbcdMNx7hIOUcib086OMgzYHU6utk8GVD3rGVjlyzK6gHmBroHNM
	snpE9iFfqA/5lfr9lM1YZiyzi/XjAkmwWWZHOSHBIC8Rk4DxKXCcu92Mo7WB/dgAgIqCNKs0dBh
	g==
X-Received: by 2002:a05:600c:3508:b0:49c:fc6c:be02 with SMTP id 5b1f17b1804b1-49cfc6cc032mr25392865e9.25.1788519903187;
        Fri, 04 Sep 2026 04:05:03 -0700 (PDT)
Received: from localhost (109-81-91-122.rct.o2.cz. [109.81.91.122])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cf771e9absm62865535e9.9.2026.09.04.04.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 04:05:02 -0700 (PDT)
Date: Fri, 4 Sep 2026 13:05:00 +0200
From: Michal Hocko <mhocko@suse.com>
To: Ye Liu <ye.liu@linux.dev>
Cc: Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ye Liu <liuye@kylinos.cn>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] mm/memory-failure: convert process iterator to
 for_each_process_rcu
Message-ID: <apql3JZ3dryCzJtz@tiehlicka>
References: <20260904083001.553587-1-ye.liu@linux.dev>
 <20260904083001.553587-5-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904083001.553587-5-ye.liu@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 99AAA40002
X-Stat-Signature: 3oxgwirr8r14q7stjxi6utgq4u3mnxb6
X-HE-Tag: 1788519904-390199
X-HE-Meta: U2FsdGVkX18TGHDO7PFfTYDCtkj39QPMDIX7J2pFgLHIeRGToO30laFzP5KZeafgk2VCq2ecyOJ54HvbAouPXqVFTHvE1jE8ev+6LbZHZoYFgiZcFfCklPW1up6k3Iq3+XjQx0MR943qn3QZL16MOLqPgiFhWKZAhmm5TS/QEqJ80kSwgN06t7uhoD4ylRedKUHg6MdF6ljCtZKErd/JVYECIjQZrV9p3Q+qYSgvR4ZozoZoH8rucufQoGHszP1Ql/aBAPKXUx+1GIk1Zj4pRWlQBQSIF4QLi6a1jM3ktxAJIq4zotEfkCwMEkrRxDUzZcS+4ZEzI+RR8LGjfaA1eXdJFNbwPnDc4fClR6JrPqIniBzQiiCaAL8FArxFTsnSkl/p5shmAZJYCcSAY/BAd6lr41880LlVkEdjIFRL7z2zEmDUaLmyyr5kyJ1Q6HTzpqrtozpi11swQk7raK6iK3LY9EAhz/Pz2oDh59oNqXxoYNDOUhTedhDGNXBk7y6mrJKTNXBmSyk7N1Ke9fEWAWZQOlLuyboyh8jN6IatGJqCM74O5peT/+XnZJRJPPj981/9DHCkl3NhGGgIouHsZOLEf79rZAee+3MV+XEYOW5o5/zIyH4xvbsrgwDpKw0n6ivhZT0YRIXoJd3R2TPtmHEyLgaEmUWc8eTNgnqo0+Kd9rsv5zzzYBt89FGc+CnPaAQXA863VXfMn4zFJM9llIvqDDI6tvDEheKfIjvFOjZuOeBhKT2xfNgLb/0VnGKCg6dDUqfVqGYy+GytQFSWczEw3AklnBG1OW9HMm7K4rqgnpbNVf4neT0nyPM1ZmnNOfenc7QVM9NTLBm2sFbq4OdmyHTKBHHfsbU5wGqtyumLFLUxtLyJZPF7WFtuQax+T4tJUO1l8ZnZOzQEuvmx6Q2+URYG25AgrGedLlowCdK2iw6IJSECM1PFjEdNloZPpnLhn4GSz4qkYKvPs2w
 x4GA864C
 UTCkzK6kgTyqyMBGPhEeMYnDrujlD/AmVUM5f+jFR76jbT+3xgp2zhruxo/Rq1Lo6PTCPYLRbliFYw/5DIPzsPSjimI94DS6TBzGcKNXpZtWdHjQ5YACd3ryIstKn59Pnw6wqobnGYX019UlJZu0cMJSBA0DeFM5uEsuHM8OxzgclrUW+0xh7hvP1UMvmwicfjXWqi6lLAlNun5Kii4zvEbV77BPbeQw4yj6dnyw8zqJeapZ8XT76FIhPhkRp6oyWNvvGpiFBu/Q46DkhHxQvQBiQl0J5Ri8HN2Om4giqtyy4jp1iCEZ2SONwRLFUjHYLha9og8N+AyJzWBiDoimoOz5B0SA+OHd0dxAxFTRTTA8j+rYxeahFLnA8cJTaQShhFkIiY2sEDyG/ogzQG9O1kOnuwdDlOPmiiPKD7rysJRTh+ZR8na5cZgxC07Sfx7pbV3WvUysAgiy+N27kDhUXR6hM2PMnqEtzIJuIWOWUTpoFwWBSu2fTbrY8RDiZfD3GLWOnMGJ55vsBI1FiMvlF2SgIohdyzTOBQT4cZI4gxBt5Z7BraOhgL7VrbLc8wXRLbJtiox6BD714xTA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 04-09-26 16:29:56, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> Replace the manual rcu_read_lock()/rcu_read_unlock() pairs combined
> with for_each_process() loop in mm/memory-failure.c with
> for_each_process_rcu().
> 
> No functional change.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  mm/memory-failure.c | 16 ++++------------
>  1 file changed, 4 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index a8b03e2920ba..63a2ff08ee33 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -555,8 +555,7 @@ static void collect_procs_anon(const struct folio *folio,
>  		return;
>  
>  	pgoff = page_pgoff(folio, page);
> -	rcu_read_lock();
> -	for_each_process(tsk) {
> +	for_each_process_rcu(tsk) {
>  		struct vm_area_struct *vma;
>  		struct anon_vma_chain *vmac;
>  		struct task_struct *t = task_early_kill(tsk, force_early);
> @@ -572,7 +571,6 @@ static void collect_procs_anon(const struct folio *folio,
>  			add_to_kill_anon_file(t, page, vma, to_kill, addr);
>  		}
>  	}
> -	rcu_read_unlock();
>  	anon_vma_unlock_read(av);
>  }
>  
> @@ -589,9 +587,8 @@ static void collect_procs_file(const struct folio *folio,
>  	pgoff_t pgoff;
>  
>  	i_mmap_lock_read(mapping);
> -	rcu_read_lock();
>  	pgoff = page_pgoff(folio, page);
> -	for_each_process(tsk) {
> +	for_each_process_rcu(tsk) {
>  		struct task_struct *t = task_early_kill(tsk, force_early);
>  		unsigned long addr;
>  
> @@ -611,7 +608,6 @@ static void collect_procs_file(const struct folio *folio,
>  			add_to_kill_anon_file(t, page, vma, to_kill, addr);
>  		}
>  	}
> -	rcu_read_unlock();
>  	i_mmap_unlock_read(mapping);
>  }
>  
> @@ -635,8 +631,7 @@ static void collect_procs_fsdax(const struct page *page,
>  	struct task_struct *tsk;
>  
>  	i_mmap_lock_read(mapping);
> -	rcu_read_lock();
> -	for_each_process(tsk) {
> +	for_each_process_rcu(tsk) {
>  		struct task_struct *t = tsk;
>  
>  		/*
> @@ -653,7 +648,6 @@ static void collect_procs_fsdax(const struct page *page,
>  				add_to_kill_fsdax(t, page, vma, to_kill, pgoff);
>  		}
>  	}
> -	rcu_read_unlock();
>  	i_mmap_unlock_read(mapping);
>  }
>  #endif /* CONFIG_FS_DAX */
> @@ -2288,8 +2282,7 @@ static void collect_procs_pfn(struct pfn_address_space *pfn_space,
>  	struct address_space *mapping = pfn_space->mapping;
>  
>  	i_mmap_lock_read(mapping);
> -	rcu_read_lock();
> -	for_each_process(tsk) {
> +	for_each_process_rcu(tsk) {
>  		struct task_struct *t = tsk;
>  
>  		t = task_early_kill(tsk, true);
> @@ -2303,7 +2296,6 @@ static void collect_procs_pfn(struct pfn_address_space *pfn_space,
>  				add_to_kill_pgoff(t, vma, to_kill, pgoff);
>  		}
>  	}
> -	rcu_read_unlock();
>  	i_mmap_unlock_read(mapping);
>  }
>  
> -- 
> 2.25.1
> 

-- 
Michal Hocko
SUSE Labs

