Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0E21606A32A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 15:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=c9fPYzvO
Received: by kanga.kvack.org (Postfix)
	id CB3CD6B05C7; Sun, 22 Nov 2026 10:50:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C64A76B05C9; Sun, 22 Nov 2026 10:50:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B98416B05C7; Sun, 22 Nov 2026 10:50:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9D22D6B05C7
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:50:07 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EF78FA074A
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:50:06 +0000 (UTC)
X-FDA: 85463191212.15.5742C89
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2AD60C0009
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:50:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=c9fPYzvO;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795362605;
	b=5dkBnNRxENTjIOP/dEIWwRLA4AaYCOIvKtNzVYeypoNU/KgUNyS5m3qWtCswKJ/2P1H7O9
	Lhpb+27Fs/KMl+zsgN8kpE2capyoDZu29ULAn7wVGsMo6pGcfcExGFsr6qoO3yA97JWuNM
	IuN5qbWBJ2PF3yk7mBxNYtR3Q5l9lMM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795362605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w3rclRjxjm+xEndB7WYb8szsZvXx3T969YLqRHQLZsM=;
	b=4AeHtrwPrra2K+siXUYrxTsEy4WUBEvuyXO9fjw1BTXfy8wa+tn8f+dlTSZC6Xbp0Ybddr
	gQhH/FaoNR5I5r3bga2Q1CTky6ce9qSiV59g/F9z7hMJKksD+C9uWno6PM6hdWOodu+CMy
	GqS3Ce8LlIJg33e4hqoIdzGOBnWXcyc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=c9fPYzvO;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-949680e6d82so310658285a.2
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:50:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795362604; x=1795967404; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=w3rclRjxjm+xEndB7WYb8szsZvXx3T969YLqRHQLZsM=;
        b=c9fPYzvOjzDdSRQg2k/LBsEpyWyR1bioQ4wrzPygyZ9ESUrLh941Sb/5dVZAWCYy/f
         YwLVfMcUzRq4+Xy0al+EtPoKXz0mV10221F+qiRO8JyLRE/bJ7aHKKTa2vvyonljVqn7
         NqTfqv3TS/uDRSWM+gP2bGoI6w9wsfOUQ9f4XIJmayZaewZfNWV6FUmPZ0gOGnIb5F6k
         BzUAGyHKuuH6UTBMl7JZhH2IwrLXF00AD9VIfm4X6Vg71RcR85MWWd9EHbPEhvex23TQ
         rX3tvXzGLTM/oP4frrOyhP08eTxIwxPrRC8LigtYXwu+J5KTa3vjvIuLNnkYuHxVtm3H
         DRcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795362604; x=1795967404;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w3rclRjxjm+xEndB7WYb8szsZvXx3T969YLqRHQLZsM=;
        b=Ao3iyAwn4J162QV+0750WKYj5G3IKxgeKedgqjZyhXEQnaLqAIsLqWRw53R0p0MYQY
         wjj/Jj58fJA+QuxSV/pqyjWN3z9xTWpG2LejjBtx4BxI4wZjqWBU5WgRM5bV9nTUKA5n
         waLw73kAgpg5BwLxglRo/Y+11KG7fsSpXWJ0lcVzDiFEgzr7mKZQTdsFyg1+an/GGH9x
         ePH6edCQJoaSK8s+iQFwVWP06M5y0XC5iRis+Zp8dXnHjcNwKyXY1AiRIQtnMJME8LY8
         +iQfLyd/FNKHASnusCJZficTZNAxDZ+sI8yFYN9d0llwgvQ8N32HyekVxImK4OeT8Av+
         Zqjw==
X-Forwarded-Encrypted: i=1; AL+hErGem5QItTni6SqEz+nDgjG84oqDdN6i48e6SG6BPCBzjhIEUEd+H/TghMXXfHJAzRgkAkCBCOJeTg==@kvack.org
X-Gm-Message-State: APuU4Z9s3JzQGXxtjtyX6dWSXsBmav6cSq1aWoTtWUD8M3pVQZjaT/3D
	5M8LB6yN7PAHHIrTbZ3GTW/jImaBRKedB1hfJEwHRSWNW98BP5dAAhimfu8yX4eLQ+A=
X-Gm-Gg: AZFdTZchn7fuf7GPimhMMyDFBXJPfTADFcMMu64dRUj+ulMNZqkkJfEUsBpwwl73c44
	i5NNw86e1K6mq45ne6hcP2/00ce8k7oROZU6+FTto5vgzmFoF5YBimU+Yzafuu1dUjx33et62Tt
	gm6Nl6sm8mv0oPmJWBm9T99mMDYucoay++azztmbAJ/FTan3hl5v6UrvPGNJDgZVlTDkTYxfyQA
	a9Dp8k6+hino0SXyVFiOveZu5mOHjviuAoDKEQGzuw4QWJVCqj/MziQ62+Lps2AkmdSQRWjpb12
	FVYokAxjJ3fMop56gIM1xYrgv3Fn6hNC2tsamgx1Jo0zmCWcvzE8OdkMeYuAR1oUyjbmNuOcMyo
	Tz4xRKlfjF1Vc65NtjRsY2+DeBZJBN9cHIJpJyYzdmZ/xyQCLrQKvrnSp3O5sxvXyILYsa0VECc
	UriwwAqRsCEBhG57PhwfP695Y2Wmj+G3qyRQ5ePctfbLmkAt7OiuE+IQZm/JOEjmckRJCLPF9LG
	JmEFUJ/2U3cLwhv2Pd8OzerUFCcckjPovsR5iZtdCo4G+fWiG8jkdomBzSgHeqamCrBocCkE0KM
	WSI1kfAds55cVbsX03S9Y6EdzUOek7PCnrIUoTUbRL0XtE7u95WRMhqvod3fehN+uMVNixKDdKN
	FnIm+WiUh95FfIrgptvDAH6ZLlVgb
X-Received: by 2002:a05:620a:6505:b0:949:744e:12eb with SMTP id af79cd13be357-949baa10b08mr1523882385a.65.1795362604231;
        Sun, 22 Nov 2026 07:50:04 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb41c105sm632888485a.39.2026.11.22.07.50.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 07:50:03 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 5/7] mm/mremap: apply the mmap() offset limits on
 expansion
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Kees Cook <kees@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, 
 Ollie Wild <aaw@google.com>, Adrian Bunk <bunk@stusta.de>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, linux-mm@kvack.org, 
 Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
 stable@vger.kernel.org
In-Reply-To: <20261121-some-more-ai-fixes-v1-5-236e925d9b64@kernel.org>
References: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org>
 <20261121-some-more-ai-fixes-v1-5-236e925d9b64@kernel.org>
Date: Sun, 22 Nov 2026 10:50:03 -0500
Message-Id: <179536260304.412063.8485838901368834162.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2AD60C0009
X-Stat-Signature: neueoc9iriykpgbric916eihtucc9b4k
X-Rspam-User:
X-HE-Tag: 1795362605-702822
X-HE-Meta: U2FsdGVkX1+K9iHovLKlNDHXXi4eGqN92kIOpqdXgHexLRx2eGydMn4mlijrrNSmNBDt7oykW2H/M8DvHL+sMqA426RveXLY7m1Afae3wkERZVIOC785mfoFjp0HRKRuzh0FzVqbW3xKsWOBFOcZg0Wf9eXJfvnMVpYBCGK1oml/zp5sJ8b73x70fXMMr+IDEaw58xRHezlQoX4Ry6BqXxT2UyuBan33VibL//2yy1e73xvDSiPGUkZxnIUKgfH2Gn/gsuVMQlrbwHifnM8VOmYfbsR71Kui0sRKYGsq5wVqFwF5DpHsLzToDiJgidTpyVQcFIEl2R6WDD9IYiCKW7ow1VWrJp4RwgJldmngc/5nQMIaXCGGBxQHGJog+a56/WJtqNYf8Y92d0+cJfMUsx1EFN8TY18ATy3yWUwgkJ3/OgdazPo2u3CSzwvjWdeSVEvuVRIEL6eXE38mTM0kapVc5Y9cmpuLw7iEUNOcf0fsEDj4BRVhpuUuO1GoJhcVWNZmC45ndQz4uexPX92lzKo7SxOIPjxdYp41a03OuGJV/UpuMuZusnbafE9FsP/CE49K9rJcJGOku7BHIGIa51aspo+3C/XEBmTXdENMgVro4IV9uAMgJ24J74lw6/6opofPOcsxq0RT6n08bJUo/9bYBpb/GtuPleGmHUDC6xkFedSeas0K4e7WglPovdKG0uFyI6ueYkpVcc3J3KN8D8x28G+mvf6amzglaX3Pb+j9Ny9nFRCj4QkNBT9oHsqxbfp6V43SHCtvD+Mrn7szjilFTVutHzRcNfOsb6pvygW1dv+6POIcJoQKE8vORDY4CqpH8pce3LM2gv2ttqwTLg+I3IccT90M8lirAj5XHYcbcykINNkA391p4whCNWNw6NrFtUMw24+iWtKmx+j8aKRmsXoAaduP/Pk7jarr9RNI5MTbdlU+3q45UnYiRW2HSFT2D/GRaiQ2guaZK4v
 e/liyUBX
 H3yXmuWEupFu11ToAsKzDvT3guow665I5jnOeacNuWBdgABWnXOl+HK+xgm5SmMbgE621OH8TzbKDW95cCaQWTn3X/yhHehWHIGXmwgtxcnMfG0dK1ZJwvZ0KdNB7sSdA3DF9jk67UPg5iP9Xo3p+EartX1zJzpBAcsUAuZ+of3pDNziPHekOoMlAd2U5l719twB+ajGvPaKEVd4KRlh2l+o2Okt4EYctilrciSgjikEc+TBK3aIRpKdudvcxn+W7LEoASTV9ZdFtfx4ms2w/8+JcAE40YZobflFerZXXzpjjmOne7tlauxtY5Cv8ZuhcE6GMD58Lvh6MBpj+ZqkvEOW2eYmm2Sigh83o1XoxB4zcIGPyTbfS1cHMuo0fu2e/85foBeupmnOpLYGUZMxmKwUjZkC0bVt/Uh9eDe3h05hGRH9zLi96++CNQh7AEx7i2RDITh0mfkAiL8xlLOCQOrgichdN2Ds3tX++w3XXf9sntW5z++n2FZ7ZjXkMTTh4RWmcHy6Bgkpi6JY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-21 16:02 +0000, Lorenzo Stoakes (ARM) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> Commit be83bbf80682 ("mmap: introduce sane default mmap limits") made
> do_mmap() reject file mappings which extend beyond the maximum offset the
> file can support, via file_mmap_ok().
> 
> However mremap() can expand a file mapping and only checks that the page
> offset does not wrap, so a mapping can be grown past the limit that mmap()
> would have enforced.
> 
> Fault handlers rely on that limit. For instance dax_iomap_pte_fault()
> converts vmf->pgoff into a loff_t, which overflows for such an offset and
> defeats its i_size check.
> 
> Fix the issue by applying file_mmap_ok() to the expanded range in
> check_prep_vma(), failing the mremap() with -EINVAL if it exceeds the
> limit.
> 
> This means that mremap() now refuses expansions it previously permitted,
> however no file can have data at these offsets, and mmap() already refuses
> the equivalent mapping.
> 
> Fixes: be83bbf80682 ("mmap: introduce sane default mmap limits")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ ljs: fixed up commit msg ]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


