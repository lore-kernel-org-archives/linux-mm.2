Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6113ACCF9FF
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 08:34:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1E928E0095; Fri, 31 Oct 2025 04:34:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF5CD8E0042; Fri, 31 Oct 2025 04:34:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B329D8E0095; Fri, 31 Oct 2025 04:34:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A3FB18E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 04:34:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 390CA49C52
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 08:34:30 +0000 (UTC)
X-FDA: 84057747900.30.D5CA0EC
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3B21220009
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 08:34:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=McEkAoh+;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761899668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Brce2942SeTVJJTNYHk2AtyCkePvDy1yHUmXXiPEbXA=;
	b=rnrj8//ZTipnuvm2E4+pdHUds8vm5CQo210/mBS5ypUtKHbYY539j5fAbiP7tAsA0pNrrN
	GjLs4PZFLKXNhLOYrjlblAbErlrNr/whKZqExqe36GiKbkGvrPRqMRW15pDMv0+A2CTDB3
	4a07jlNdG4ID/3aVVrAr1u4n0a1JMjs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761899668; a=rsa-sha256;
	cv=none;
	b=himt08bAYyrN8xV8Z1AqBt13TW8J6CHcMuTb5pXIyYmI+zZCre+IEO74T+q9qrNOZsBEAn
	8zPkqJIa0KUgSahBt9+TNZK7swFmWu3Unq+CoK3kbFLoAbT7E2gpJ4oYNwU/T5DUoABExC
	aBe5VGS/uGsj2INKAJMLm6an0V9kgt4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=McEkAoh+;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-47728f914a4so9564625e9.1
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 01:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761899667; x=1762504467; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Brce2942SeTVJJTNYHk2AtyCkePvDy1yHUmXXiPEbXA=;
        b=McEkAoh+jn5ZwX+9OfQK5b+CYBHhtcI8HHYFDMgBSSxz7JT/J4GwcCMN5lxmm17THd
         ftdQQ2X6eM6bnesV+DVB4EPUSJLp+9HSYIttQuVhwFqPcgjCXQLJiuDfVntlvg0u9Fnv
         zNl6DSbVisgMYVI/FPlhJ5YAEgqQs5PaDw8d0TYuM3sO5oO67a11d07dJHo7Z3+vIMyB
         VB7Il+H1b/p7uyymPzn1ADwsIhUDkGRgXtaVLeb8VlUxx2fu8v6qT6ca5zgJuGoZBMEr
         7e9q8o1XPflkM3nOAXwlPZO0gMXOxxmKI7vyauOBNn3ypnYU7AZJ/Vy5e/e6FCm0k3Rl
         ym9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761899667; x=1762504467;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Brce2942SeTVJJTNYHk2AtyCkePvDy1yHUmXXiPEbXA=;
        b=Wx2ECN8YMphcv6MpZFE+YVV0p0Uj9xcIdqvb5orUan70Kvh05ktcALdCVHM5RZ+4/M
         TXj6e0DYA1wZrFr+B8zCYIQhcli2CnNIxJJYofokz3q75/XIDpPZ88VmQvfBTAixNyjy
         9cd6pnDjS/MCbs3BrNmkbN2BuoSidkfzsomTDMVMQszYMNYef+fWXSp4hMj7J1I7ezfS
         aoQSe5y5abhWwgx1LvPq0W3GuQ5FifcuGwYdBmVFzwPkotoRvWGem7ZI6dNrqq+QwQv6
         EQcDyUoM9bEF+OIfzDE01bHw3mIFaF2BncEeqtzWWq3mctGuZ4C8ktQXch6QTyCJEzSB
         +ggw==
X-Forwarded-Encrypted: i=1; AJvYcCVpoNqn/p1OCgEbpVTyocg6TdX8UXN/MywrMYwAWIMZtFjsKcyMH26LC5s/CyoqbMPgcATaUHct4w==@kvack.org
X-Gm-Message-State: AOJu0Yzp6DyE1N0+iOTbe1fXcQefZ0jkS1TQsU0x0xMSx093aHc2HVYv
	qsqd/l4gJfHanoxLtbz/ZE+XuClY+JnJEvXMRPY9k9y+z8oTj4f0sOHqybETuUZDLZ4=
X-Gm-Gg: ASbGncs2scMEyORpu5JLwxngoUkCRnL56O4shjLTIuSFhj7jADZkYpspZwPB+80wO63
	/yLEQFcBLOwxecG+MBew/66gW6AG8w1EU5I8W6CQqUZUkR7tDAPX35hqmoKhfh3gj02UztMi51R
	GnK7W7f8tLFQCBgG2DyVyhlUmAVb+hLo66e0uLF9u7m/X5a5YEKabsbshYFYe7ndZny0AD0dLRc
	YYVOdQy8WZIdkI15M3qu2THRFpEkaPOSZOwwfTPUW60yD1btioLQzhfEPua0LZ+JPomhgJMoj1w
	tcEswIWrDg5gRtqY0TjB46b8j1no4YhMs4TcjCO8b6ngVpP5Iy4engSgn9XAudPuc/fb/RWnIcO
	WIKpVQL6EVwK4pmeGOG/vtdtquRiVO3eoXTeWRVthZtOs2rtGcMG3ESobmh97A9nF6dSXhLaQHn
	3Vz+yW4rbUY6ZSPQ==
X-Google-Smtp-Source: AGHT+IEqeWzc1dYod8DDM80O+3DfRoIrCHAb+32/10VgcqcE8gyD3g3E2A+vxz5v6zZlDzTIz39ZaQ==
X-Received: by 2002:a05:600c:34d0:b0:475:daa7:ec60 with SMTP id 5b1f17b1804b1-47730872dcamr20908505e9.21.1761899666777;
        Fri, 31 Oct 2025 01:34:26 -0700 (PDT)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4772fcf6c05sm17137655e9.4.2025.10.31.01.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 01:34:26 -0700 (PDT)
Date: Fri, 31 Oct 2025 09:34:25 +0100
From: Michal Hocko <mhocko@suse.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, bpf@vger.kernel.org,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 05/23] mm: declare memcg_page_state_output() in
 memcontrol.h
Message-ID: <aQR0kf_g2e59JCmz@tiehlicka>
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-6-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027231727.472628-6-roman.gushchin@linux.dev>
X-Rspamd-Server: rspam01
X-Stat-Signature: 3fsnwt1iz1mfezgdsd985nsdp4z65zmf
X-Rspam-User: 
X-Rspamd-Queue-Id: 3B21220009
X-HE-Tag: 1761899667-298646
X-HE-Meta: U2FsdGVkX1+Bd5Nz0MzMqmlrpRRFVjpzSMHGHNRTafffhGbJ1JtWCoHaI6XPmF/sPiYIOjerg9FnjJ3T0QbWq+FxulSyxLWpXeWME9V5seQ+dHV1Lh8cAdek8oJSuwCbE2edIWp7JO3ED6Ipt04zzH6Sf8Ymq41cSqYJTo4GN2r7INu/jBGkav4oqjT+yux5fpsNZGCY6U11Q01vPeSiJ0/o677Oc9JfLsd6FW3qCTdPDl8LLSUqReDaUVGKLsFySGsKUNn/Ifu0szvRkumBlyq9U9MlmQFMv0a+0QS0vMmu6GHdVkZ8vzjRmn5H+9Or5OsarJm5o7r2CsJ06jTDtZwRKxOjo/c4VOVA3yoZzihNLI9n5ymeWCbsdZgcmOERVJMi9OBA9KTuCsoWzG4jEnuqo+iSr1kcPkS0eJ6B99GA14EcD41Prvjz6GCjQ+muANkauGXEI42pQ7J/mCAzC4fRDMxvW8c/N4giRvteS0rNcF1hHT2Ol8OvcEzm/2xdtHmli7sUEVNrzdDE9dpeNgbOSczqXcG5BElugfHSy+iz6zRASjo2N9/eN30Z0UJUymY6ZxrvpX6xbKJB34sWqrhU3wn7FVUKx0h3DOwKDeWe+k4WKdSbOea5bGbQfGpThlTCG4112pCa3cfbfCXEzSQ4J+LdmNy/WCWHD+NQ1Wav0hsY3wI4Q4KYLpgFkzfUOonIKDpriBwb8btjlw7FC6Wxw2xXvTGwmsMpWt/LMyoxPJjeRXgDtXxi6/fMxM/Xz1stFJP45x9lFnDxPi1oxz7DHcydLevxdB9twCQJ98qOrXuNgMho1wmvkBChmBT6K5lB/MhRVw6MdYxtmPN+oyaGwgqbL2WrLS4KgwiCjF4LcOQ8MrsSb8C7AAj0ezTRovGQS6nOtYNicRqgqLeIZSa06Kfq//Nd44ASCBo98aRMyVgPC2mCHc/a8bD1/UlvWO7FGJfXijt15WgrCGt
 Ze/TVKKJ
 7dej8Yq3f6WWoUp11Cqbt+LnGfsed36iEgzPl34gHHH2K4w4or/m5U1GmnaFRcgGKZWhU0Y9a8G8/M8O3VucoTh5gEfmd0wSuqgy5T0rIZDqzgq0Kvr5d2a0PaGfI7f617vx6mr6uMibagMq3ln+AwsB18uJlNcc5fsv/gLeT7Am3Aj/nu6y4jnKm9zMhvugsK7Cnkz1SU57zeBauSc9xHd92MHuZMtE0l13UAaEzz3YhbqamWCLunnb91tGCnpeFBaecoWIc3AJ9iRbi1UmFDkj/DhDIbBj/4pWhVrZidAJ1eHeBgja+OtilSFn8hD/4h2U5DX0odm0ttpQY7llWRAIbG1aiZlDn8iZ3EaVrZwFhZK23m1bSwKC9SEy1lrP1yELSI6QheEHdyILwfwGV9UUYJZRfsUU6vWWSQU2zzLzBx5+OZInWTwUyVP0uYzr9uqS5Q2UbhrsyA8FwK7M4Kvj+ZIZnKrMBQzXMGI4EV6Vt9cGuNRn9pmEjHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 27-10-25 16:17:08, Roman Gushchin wrote:
> To use memcg_page_state_output() in bpf_memcontrol.c move the
> declaration from v1-specific memcontrol-v1.h to memcontrol.h.
> 
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  include/linux/memcontrol.h | 1 +
>  mm/memcontrol-v1.h         | 1 -
>  2 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 9af9ae28afe7..50d851ff3f27 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -949,6 +949,7 @@ static inline void mod_memcg_page_state(struct page *page,
>  }
>  
>  unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx);
> +unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
>  unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx);
>  unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>  				      enum node_stat_item idx);
> diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
> index 6358464bb416..a304ad418cdf 100644
> --- a/mm/memcontrol-v1.h
> +++ b/mm/memcontrol-v1.h
> @@ -27,7 +27,6 @@ unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap);
>  void drain_all_stock(struct mem_cgroup *root_memcg);
>  
>  unsigned long memcg_events(struct mem_cgroup *memcg, int event);
> -unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
>  int memory_stat_show(struct seq_file *m, void *v);
>  
>  void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n);
> -- 
> 2.51.0

-- 
Michal Hocko
SUSE Labs

