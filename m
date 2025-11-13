Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53B9DCD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 19:16:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99DF58E0008; Thu, 13 Nov 2025 14:16:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9764D8E0007; Thu, 13 Nov 2025 14:16:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B1818E0008; Thu, 13 Nov 2025 14:16:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 795008E0007
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:16:42 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0CAED160B35
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:16:42 +0000 (UTC)
X-FDA: 84106540644.14.964067F
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf27.hostedemail.com (Postfix) with ESMTP id 126E240005
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:16:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Oq4qE8gu;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf27.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.181 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763061400; a=rsa-sha256;
	cv=none;
	b=nwfatawlNo0WFRLq6QqjZcp7ae4/0XPzNW8F53BaDwIjR/ywOj8cr2Y6112c1ayiORe5sA
	A0YXRxsjONNAmu+QneRUBIfFORHn5GJGFR5AUBfYS5mCVJWT55GWnX/vzNGhf9Krt8pX7Z
	fR3qnlGRhMVjVV34QU6fWHyToL2ysko=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Oq4qE8gu;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf27.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.181 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763061400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zxjShYqK0SmvQj3uToI7bKSMFU1VR+C+fw1226ulLGs=;
	b=3vctwtn08Rdg4C5lomN9fEyggu93Awv2xrKSXy/Bxri/miEmkEXhy8SAOfCpCM1KFLmesu
	uTwgA6uibLZKUxkmD6K+V0Q9duvNl3swAUnq9Xohyz2F+DsGK9kRvIGv54yj1oyuTKTwJe
	nBHjA+0WkBPIYgwYWSo6Z8QY4Ss8GSA=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8b263ef9ecfso110705585a.0
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:16:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1763061399; x=1763666199; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zxjShYqK0SmvQj3uToI7bKSMFU1VR+C+fw1226ulLGs=;
        b=Oq4qE8gutSUP0ZdEXFdbIEcHu8NQgjawd9l6Tq2YRL034utANGi0TjjOrWHDOWjg8a
         CbiSBDsA/VuUYaSPp5ETOo0VdhFl+Mw5R+6/L8DfN3srT0G/BpI+DTnTR++fy3sjAXSe
         uWWQumvmIJjq1CbZYwkh+oe1AIdsthmo8tshthsMx8ztlXTSojg/9sNkFRciryGOw2Y4
         EBLzy7jtrlq7MfSCPGVpzvPPSFp5r8AtdWSRVt7dJlI9q8SaNwC4itPOmAHI85EIcR/W
         +QpMSTYpCRLcJ/C7cjP21IKI3ajhNLgUgxHV9bA6VHFSkpUBIIYffU8gBcTOOVF7ne0g
         lqow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763061399; x=1763666199;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zxjShYqK0SmvQj3uToI7bKSMFU1VR+C+fw1226ulLGs=;
        b=OegnGhHrXl7I80FxvqO5eQRrV/FICfDSfoo4q+sSKnTVxgf3IS/iR5L3UcI7magDU+
         NGwwELHv6as+EpJslp8RdOdEzS5iSpbXfyjJxErRTN+lrSE0OAxAh7+2q/OsPGoGtoxg
         vF8S4tntxZFY4dmKd9LJih1BoqWyhZBkCs0YDfrbb+jVsO5UHsXisIqdTSf208UaWHGr
         MJqpKlnWYm2/k/giJp0GyXD6nvQYGHlW8z+uKDlcbEW+dUKvf+J0bvl4885xkTX3+4nM
         +LrPk7eDivxD1wmfl47FLTpkGffwKbX4OAhKVmRhnrZpAlZuS5vkATq5euQA8Fbb6A6L
         1Sgg==
X-Forwarded-Encrypted: i=1; AJvYcCUuxoYMT9Kog60B2mMPP834wDZgFFNZe2h1PS3ZBliVHFXnkKKnxRaeAOkiKbqK567VxylAXk7pmQ==@kvack.org
X-Gm-Message-State: AOJu0YwGVJHnO39wKNgRKOSOQN78SRDVpLg/okQCanZ7RnI5JxPOGq1Z
	xQjO9XFQ99CcOlX6zJHj3S0Lk2HCmq+ciWq7+zUgx/yZ0vd7OEFvp/w9VSXVku6C1rc=
X-Gm-Gg: ASbGnctYAH80gD9LwBkW/E4K8+bP9qHrtYXJTq9ivr6/kv3GW+qKGke62Wn681LVFei
	eelUGqZJc2Vooyo92Bme3XiFeGAIVBPpUES5RTyIeiGE1lak5l+JiaVmOzS+CR49nPr0SewyTWa
	qgaDXPZSHQmGcSR44U66MZ1Rv+xGpXTTWrHWocaV0w+W1HdqYzEO20H6m/4J2pmr1PoPoHrDiJm
	BrcM0WDCAwZQMa79QUoUicvH7APaoGmaLu0PMY6+0wMwzc5MI/uH5gV/edIunZ6cbtjGdgpxKQO
	50xuOiwtoHvY8MyoAEuSlsmowWZ/DuGBEvJ23XXHwC6BXrEdnQBClkLgR4VXeUz6CENI1zwGvp0
	BrGDO9zhvaCNiGDujYhhA/YCegmNyEDp2+3ESCxzbBT1rAR0IuyOzdDfq5fjfuNkryY7A/GBgxL
	0=
X-Google-Smtp-Source: AGHT+IGpEDPemMbTY/tSqdrsw5hKYs/c+DFsc+7Rz7Y9vOLYTYETjGT8tc6BrkQHX26180I021LtWg==
X-Received: by 2002:a05:620a:404e:b0:8b2:eb2:54e2 with SMTP id af79cd13be357-8b2c31b0e9dmr75851885a.47.1763061399043;
        Thu, 13 Nov 2025 11:16:39 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2af042c9csm185548485a.46.2025.11.13.11.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 11:16:38 -0800 (PST)
Date: Thu, 13 Nov 2025 14:16:37 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org
Subject: Re: [PATCH v4 14/16] memcg: Convert mem_cgroup_from_obj_folio() to
 mem_cgroup_from_obj_slab()
Message-ID: <20251113191637.GA1240@cmpxchg.org>
References: <20251113000932.1589073-1-willy@infradead.org>
 <20251113000932.1589073-15-willy@infradead.org>
 <20251113161424.GB3465062@cmpxchg.org>
 <aRYJzbZpd-UP3jh9@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRYJzbZpd-UP3jh9@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 126E240005
X-Stat-Signature: 64xdurp9n37fcxinadexqc3jxdxs78bk
X-HE-Tag: 1763061399-910911
X-HE-Meta: U2FsdGVkX1+lIr5AfUnUcnzzcStWHpoAm6mO9HrxHRhQ9m8XAkXBHV5dEfIfNSnCMb8m4/Pt7H1FvoQZlnMx9q9laFH0S2dB70YqFiwPpvysCits3yj/JdeUjOq7alSydf4l8OAgPg0WF2LmZPQhcZdTGl9fXdq/1vRG7Ixw4c89JZaPHpKuSIqbcM81LmZ77hRgkzkMsPCbjmWqeG8A9KQ/L+6k5MzXNBnMrOVo9AGuaNS0GYVvJbe09nVPpc8ZMUltCNfF93K4BZ+M1ILk1AKs/zeDbyOPWlUX+iXBVHzxAupvUR3OyuQcEK4xofB9A3VUKaZ1uukwdIsPldfD3x8neqqb8cT7HeYoEpGwRM3oesVkMaNTzm+FZTTEOAMrwUwwSPFt9r1obnyVWixArHZ0nNJDPDipymkNeVB2FyY9O0epak+ER4cKPxSVbTgdCXGv9Lr4b6ZsUBBloSGkPfVbHlttX95nWNIo2OJzteV5YHfGGQv78EQoayFbYaoXhUWYXNmAKnWG06wOLpQThsQhYsVgxCD9sKCiV3xhm5CQ2MrA8jDykth1TnygpTpjZQXpaoM4WDkZo8SlYdmST2CDu5yFo5jFC6GWYFfZ0otrPwSpzRSYGKGwu9B314bw/efSghjWh1tCpAddAksGh6K4b9GDXkPOnjqkPfLnUC0/OE8MOCeKUNY9MPATV1ypyB1QYqHW3po+6OhwKPWVmbKloaaSX3RLVIWO//0vKlbsBa/NVYVBb3SYrlIi9DpWdvRIP29XrdS4TAmlnAf2tsU8w2ZQBxtHG0ldRj4UBOD220PH9A7xVJ8dt1tBmZGLVSYq5MbVbd/lai5dkbvFskdKmwvPlhYwWC4jBG3lujt51pouD9uWiHp8hjAQ0U9G+xxZmQ0qRFVvu+lK57XkpnHFLrAWFxwqaXwxIke11sz6ZyQULz/JnS5FneF7qpSQLgb16P2VkJLWXd3GMu5
 KHGo9F/7
 JNle4mW63MunU8c/UvmrD88JTwFbYKpYs+sy5CR36YSlrCIjFqgcRiwvWKQ8FwdIyYvXxK8Q1lplZPxwW7ht4ihTL/H7InaZpAHg2Q/3aDtsvUjuss7bcKDDG4A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 04:39:41PM +0000, Matthew Wilcox wrote:
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2599,9 +2599,6 @@ struct mem_cgroup *mem_cgroup_from_obj_slab(struct slab *slab, void *p)
>  	struct slabobj_ext *obj_exts;
>  	unsigned int off;
>  
> -	if (!slab)
> -		return NULL;
> -
>  	obj_exts = slab_obj_exts(slab);
>  	if (!obj_exts)
>  		return NULL;
> @@ -2624,10 +2621,15 @@ struct mem_cgroup *mem_cgroup_from_obj_slab(struct slab *slab, void *p)
>   */
>  struct mem_cgroup *mem_cgroup_from_slab_obj(void *p)
>  {
> +	struct slab *slab;
> +
>  	if (mem_cgroup_disabled())
>  		return NULL;
>  
> -	return mem_cgroup_from_obj_slab(virt_to_slab(p), p);
> +	slab = virt_to_slab(p);
> +	if (slab)
> +		return mem_cgroup_from_obj_slab(slab, p);
> +	return folio_memcg_check(virt_to_folio(p));

Looks good to me, thanks!

With that folded in, for the combined patch:

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

