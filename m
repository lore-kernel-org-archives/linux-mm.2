Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8AED606A32D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 10:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Q7zccCPJ
Received: by kanga.kvack.org (Postfix)
	id DB1726B05B2; Mon, 23 Nov 2026 05:11:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3B566B05B4; Mon, 23 Nov 2026 05:11:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C039E6B05B5; Mon, 23 Nov 2026 05:11:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 916DA6B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:11:33 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B6267140823
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:11:32 +0000 (UTC)
X-FDA: 85465966824.22.E778E06
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf23.hostedemail.com (Postfix) with ESMTP id D88B3140002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:11:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Q7zccCPJ;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795428691;
	b=SrPcP/+cCNvGG7fSWOQW6bE89yoXmD6sXicjiXlim8B0cc3IrqWe/cNpObWcScyHIr3BiU
	3kp1kHxJ2qQbIijhlL2ROAoBUsgXQZ/+sNXzEJsOZR/bD2lNPliwbpCOtYZ0SPlHAUnJ5J
	Lcz8evL8u9Uhkpr9TLw+ZwPMRpePc2Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795428691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DwLiyOh05b0NI0/gh6SV/G295VOAZ2Tu2Ln3fZH+sNU=;
	b=GFlZfh1p9pOQAqVzUimhEJshJ1RU1GiJDqakERGh73PHudah4ceG12bxgE9FkpAWmcYZXZ
	s3dDd7GNrZYKnXd4nQx2msUtGJ/5RaCymrhqNTMEwsdDDpkbRe1eQVTfECS/Dir2b69li1
	UxK42cDNmLnCF67OZ4yOEp6g9P+NRPA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Q7zccCPJ;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4a5024b3c28so2419876f8f.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 02:11:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795428689; x=1796033489; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DwLiyOh05b0NI0/gh6SV/G295VOAZ2Tu2Ln3fZH+sNU=;
        b=Q7zccCPJ7CMObMkhvEPB5P4WFoeBPglKuGoOnci9dFczFSh5yctJPGnHauHduoOfqo
         2ipeFzJQfARSSsY5M8kkjH6XFZ5hlrtxzJ/0+YH5yCT+zN9cixQmG4DmMZGmyGP/Ub9b
         90YhY++THdF6zHsKCGKSQsE/s76taHCANRbDFdcdRsifH5uCoENmuGgjOwvjQBxgjLeQ
         dJL1/YEfP+Ji7sdNQvH0coMhGn7tJmH1bGdFAeyvicLafWdbhCAXDjnjKUxZW0aIbnz+
         NOH/GdwIxn5DfxB/vC+fUffCCKfwf+zcmi4XB/k1I/+P7ZKL1e2iTxX8/w9nb95sOcwA
         h+VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795428689; x=1796033489;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DwLiyOh05b0NI0/gh6SV/G295VOAZ2Tu2Ln3fZH+sNU=;
        b=ypPWD7/R+Beie35JDIPIqIxZuXRMRts7OtFEVQ4M6PhLwBFRtMWfEatfj5nrHz38qv
         AfYdrxIkggA4hNXE+o5yDLCpi0Jt0RN1AcdHXvILElY/wAZjR8axvDOCw+0I5udRPVxq
         VaEYM4x5JDOn6nr+egHNwPODlnfUyCmT3UCaVbZHRuy/uXi4yzMcLMoTYJy1/fLPZvNM
         gX5QAakCcHxUkfGuCrN481Jz1LBf00tiOZBtuvx9JkEt9iPZzRbMtgTtxWmBD51oz3mA
         nKyJ7eH7VpsQdLh7tH6yY4Mf1NsrPcgEWWVsvw24slssDXkLkaZfyMJwUsguxjQFt7MS
         7WnQ==
X-Forwarded-Encrypted: i=1; AL+hErF0CpRZHfHX5OFipvXONjkEqr6fzNowKVC7C9sUCj8iOnKOATh1I6snAe5LuSBisMBY6Od2Z8z9hg==@kvack.org
X-Gm-Message-State: APuU4Z8eqSLtjqzkAxV2u82+Zoe5rkJDwKYOa3cbU/a+56biIVBVU7iO
	6/OWEGz0E39pDVZ4wUy9/2uj10o2QaW93JK7IxEktiL25yRfr1xes5JBk6cUaEd6NYM=
X-Gm-Gg: AZFdTZcpCTVLRwjEWES/sDBu1oqou6hD1C15USvCraH0Y+LcZPvrJci5xVNZuavLYVj
	2UzeX2F/Y5KB2RbZQkj/NSHjN0DhBSOyKmx/b7VVtzlpN8f7cBKAsrtl7ewPBZ4it/Jnh/rxXyr
	rGjdjrlRBbVaXWc/h1tUuY8WguXAUshpK0gVx7IwEc3nvUZeNtC5mt790ddHdLm9a6HYsnqBuVY
	kT8PLcroZ3vVw7f4+sPxohHOlnVeJD49T8it0UaDZSZdf3fYo0hfiNgsCcCnKOR6kRWwKWFFRIJ
	aBnlOb3M1VUG49JOiyPZIwAnyy5gEUNg98mFwfFmXuQxdEG1NQtFI+HyqhlTUAZKQ2Kjc5kyDkd
	Q6X7/bTBy50yZESTlkUYYpSiib22k0L40ZkC2xt53AxXrcQmfcD5ds4GSsacfCkhifJqtLlXfSI
	Je4jSqqE/qGYwcHm+j5qWMLn1XLJr1MZVTR+otJE9bms3oHAZ5kbWTL/dgiNDLIN0E0xd/bnaav
	zDg5vJ/nDWIWTiJe/sZbCXfodS3B40/Pls4IlNCAG9NLHcSDk+/4B8cu7kedjzcK41DfuaQKxya
	3aEg/w5XN7RFXizJo/Vk7O70/eXxxt5IYDg5A/F+2Yg=
X-Received: by 2002:a05:6000:2211:b0:493:72f7:1d5b with SMTP id ffacd0b85a97d-4aa5b235116mr26571679f8f.29.1795428689306;
        Mon, 23 Nov 2026 02:11:29 -0800 (PST)
Received: from localhost (109-81-82-199.rct.o2.cz. [109.81.82.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6a67fe75sm24009577f8f.24.2026.11.23.02.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 02:11:28 -0800 (PST)
Date: Mon, 23 Nov 2026 11:11:27 +0100
From: Michal Hocko <mhocko@suse.com>
To: Zhan Xusheng <zhanxusheng1024@gmail.com>, Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	penguin-kernel@i-love.sakura.ne.jp, tj@kernel.org, mkoutny@suse.com,
	chris@chrisdown.name, cui.tao@linux.dev, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, zhanxusheng@xiaomi.com
Subject: Re: [PATCH v3] mm: memcontrol: don't miss processes whose leader has
 exited in OOM scans
Message-ID: <awQRT7InNqEF-K8-@tiehlicka>
References: <20261121073222.834282-1-zhanxusheng1024@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261121073222.834282-1-zhanxusheng1024@gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D88B3140002
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: yudtwm64rgzbj8e9qddn9fgdnw1qbgtc
X-Rspam-User:
X-HE-Tag: 1795428690-566680
X-HE-Meta: U2FsdGVkX1/0U+yIhPp/J/1nO2hluXxXSv29JxonJP9QJMEkkZjfiSI/ZNpjR9YLv/wwCHAM146x0zuHeuf9QDzYZotcYpigzKziNoe00pSnJ1o6uQ+RIMuUzDR/YkwOzhYsgJDFoDX/jtAr+MGkJ0m1n1Gx7HANUuTC/qwJ7TnqI1KxmWXoDw0n54mM4eSvoywF2LU0jzn2XUlFKo1XnVYNOW74s9YvzLngHdQhey8KCvvPwsFj3JWywc4y3oS78eA03tGfRKfCV+O42d/VmKq7F3EiazVlmwb3XnLr+kQXyNJHO0VYhDtA345kkZn96dHo6b53+UoE5YU29tZr9qX6hTRH2Cc5g8AdntG40Aw3uOzVNN1/jWnnA4eYUanYQ7g42v95XWQyhCYorKPPOmd9Di+5fWbkhck5ILXf2HZRCO0+qaAwuiEkS8dTr0RadlUTCzmAQkV6Ehn3urzMWbskpXzUJq9NZmFH0Za7SH4GbVvqt/yzQ9d4qY50ftSOTEOxWwB2eGMDL27GuqNaYDIsEU0PYJenb+TFVdYbAA/SIuvhaHHcUJnFj9er+k+bvf+/FiUAyPQKzlUJWgINvZgY/PTJCRLZVarWi8lVyX4lulBmrwgKefjshG+JQlfakDUFdsKMJN4KM7rL2L/FOekrfI7nH8DjN767sQy22d5FAQTszq0f2IkSiBKzW6KLgtSkuxipmnvLrtSzgmg7chN0cBRlh3/sEK7dAcPLlWVSWu1jozrG+b9jcI1s5upI8Byr+q7INKXpxfhpMGFiKOu50NMUEvf605tANJW7NrgjRtIuGGrTp8QD7QmoYDHC9Ed8j78Ts1YA1lUeBoA1K+nacljRpdgayhPq12Cpz6iHe92lG4gwu0Ty/ua8mJ96UIqhCN7qKGx9bsRm0uwThkT197BpAWMBD0d8qpsVBFuY2mnPeTFgSKFHgVWE4g9R3km1OenIYcB4u7J/tRl
 c+ZhlOSy
 TbWodXRL6Ge9E7iyK44JX/NBqJ9yDDewJ3qAOxEpOYaP9Sb9TMx0D9wy2fEZIL8IJCnDSVqLQHYK5AGebUiEjYARZoUXaoY96t/2Sx/fxEZ43RwlTrwdoUhqKSnrnca3+AYrDWHqVja2GGRS48SuiSe/pdJSKobvDadsclabk1u2+QQdPmGzRNhZqA57rjra6PhTmM8391nSdQLXVDZHQJ8oSS08NIOt4BjQWwIGOH3dJZmTZgMzXj0tNdN/JLm1pQLCE9YbfNkfKPBagVwUksTiKukzIWxeFdlAYEpysmoElU/ua9DHuFuTNS4bVh905k6DZtr/FYHUZmAfJ6GYe7ds2zY6TlPVxcQFGeDr5RbVp8YSexftUSiSON1hthyY+O0FyFgRUqOL8YMbHLEQTNvnIyVnGPkbXBEIMAEy8+4ldmnAj2c4+V4071Hk8rvG11DL6Q7LbVwg+eFGlMUD+Tgq3t6Gx3pBGLEcuIH+u519czL5SL52yG4aBkyEStAfIMkFhEtCISTaiWMtYntMO/Vmcapb2OHR9RG7QtnNETTKLUFYZSaVf1U1Y40NkeR6p/GrTjoXTbGMoGrQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat 21-11-26 15:32:22, Zhan Xusheng wrote:
> Moving the exited leader along with its threads came up on v1, and
> there has been no answer from the cgroup side.  cgroup.kill had the
> same case: da13e0e72a73 ("cgroup: fix cgroup.kill for exited thread
> group leader") walks all threads instead of the leaders, and
> 5f4a3f743acc ("cgroup: don't kill migrated processes through their
> exiting threads") then had to keep an exiting thread left behind from
> standing for a process that has moved out.  This patch does the same
> for the memcg scan; the second case is what the live_elsewhere check
> covers.

Tejun, is there any strong reason to keep the exiting thread group
leader in the original cgroup? This makes CSS_TASK_ITER_PROCS iteration
really tricky and error prone as above examples show.

-- 
Michal Hocko
SUSE Labs

