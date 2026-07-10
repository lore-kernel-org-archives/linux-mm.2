Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2894DC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 11:50:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06E476B0088; Fri, 10 Jul 2026 07:50:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01F426B008A; Fri, 10 Jul 2026 07:50:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9DC76B008C; Fri, 10 Jul 2026 07:50:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDE3D6B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:50:14 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 647711402A0
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:50:14 +0000 (UTC)
X-FDA: 84972698748.28.5AE3443
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4BE2640008
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:50:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=T8a1An2l;
	spf=pass (imf17.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783684212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O1cv839pt6gMzmGWDQWXXSzIxfFZGm2rebUfeK7nSPU=;
	b=WlpwVQ+h7CKmbR26DDFjYzan69aoiwy/D2YBGH/pWmc7FbVcWe/00nACCqWXuuG71b9K9o
	9eE9J/0tuOtu3Z5inkQwq0mAQZRakxW5d0eRIhUGqehO+b1hE0YmFcepUOEfXfD4uCnTUl
	yYkLa6g49Ze2+6BK/q8iog6kWaWgOzk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783684212;
	b=p3IgILhY7qyO0hOexGPs4gB9faSVNjN/MOPy48gM7ks23j3Gvej1YI1EKdZTK8ad0j0y96
	IwWnpGumVye9EKfGSjoa4ZWcsCyxpLapnoHiCjTja2BrtMpKPi/th+snMt3zKh3YPoPfYU
	q5den1SMN8YxOeHl42DZ/uHWxY342O0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=T8a1An2l;
	spf=pass (imf17.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-92ea24a2dbfso61030185a.0
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 04:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1783684211; x=1784289011; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=O1cv839pt6gMzmGWDQWXXSzIxfFZGm2rebUfeK7nSPU=;
        b=T8a1An2lAWwxXDGa220tNZhvGLQYhxBRRoyOuKw0gWw9abb/0WWSxS/f5h+SGUFjsk
         LgCnER1ikB3xNke1rjWBY08ug/0S+NswSkAAr0g5deuKHu/EBcohDweuK5AjwO0XxbOB
         4DN8rR5eVpOyHCSJ77/qceBo6h2QCV8SVeAqtJquW9cCnof1Guk2oL/fL2X9a598Rbc/
         DpS5hIugBv1/TlhUcSlon5ZXJzyYd2rxtajE1tyF9Tjzn1AbwAzUsTykj8I8KOqWAHXM
         NLNiiRAsCX0wYYDDLM8EkhNAl1Gdfqc6PZEmkr/gBilSsPxD3YZV6vLvBtx0I6Vqr1Ze
         Dv8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783684211; x=1784289011;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O1cv839pt6gMzmGWDQWXXSzIxfFZGm2rebUfeK7nSPU=;
        b=RB2xwTi0VSzERkIpzGJzGOqsObg25fsFrz4pZh/FXc3I/+ZElwUyezwZqGsmiACIHD
         ZvQpAL+HnTWCirwZNT5Z34/ZJ9DrYYeGHOpBTX6tggkHb6qG42PM66wWsSfXyBY5SfI5
         8ooZppxNgeG0SHWDg5LaeGxINk6Y7iDJKTBJMgL7oN5YE1vSPTnzTOAyEwmBjjvHb9XX
         lP0jsN25M4eLiA6OYUB4XNr9GDIYHTQ0/c6+NBJ8ivSoNEN5Ntkc7QgTUPMxhxzghZhG
         jYGmwQbHL1v3P76uwrkVTozoPx0r+GOu8G3/FNC/U4QRUioH2B12fEBMmVnB7oqvO5gL
         DQ7w==
X-Forwarded-Encrypted: i=1; AHgh+RowFKX3WGxhMu7sMu356Pd9DQF9nRqJsVTnR+kKBOUER5C2JzOsh7L1B9GBsppLza5SAIODQfwU4w==@kvack.org
X-Gm-Message-State: AOJu0Yy+gmKpt8LY70EMEn7IRraX5mUFcNo9dYnBv/gROYjJdyPghFLh
	B1UlrSqLCJjwVg0I8+6OsLf5FHfyUkh+55poMFO+RIblpwxFbHBMXdzxDof8Jbmfp6s=
X-Gm-Gg: AfdE7ckjAufZPqyHa8jEPnY8SQQVy5OOr0mLoLxpysY2XiuN4W4uHkFJN7qz/ZOin20
	BSQhjRTfRhtq+rw+NfjNN90+oDaqDnYtU1mRART9miHHpFjfQS6fqjZVtQbHeUHpfq7GkQh0KiS
	FIifeAKZUllSShm9fwtZgsDA41k7ubACZplCGvgkWGn8BehSgvbtnc2VvPoULVU3XnbXPNwvDuA
	DVFscHvdWo0bCnoNtY90FPpKr0mrn+spKR6QLBEGiChGjtlZJGkON0EK/g7G/5fUZr9WR6PeCXz
	cW+MH2GQqzLKJs2006/hG1z/8CBiSMPKV4AdyDFPzxxHijpjmwnw7s3CUQV8h+xbHdWOC3aKBTm
	8bW1BKc9mVWLTNBQmwDUj3xgd3Vc6O23aQMNrx0lfKJwu5NegH754yQ72MMElY83mGjPI+vfSuZ
	KDNrKLlWeQfhY=
X-Received: by 2002:a05:620a:8082:b0:92e:c117:9eaa with SMTP id af79cd13be357-92ecf908aadmr1243149185a.88.1783684211285;
        Fri, 10 Jul 2026 04:50:11 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5b4a0cbsm176929585a.5.2026.07.10.04.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 04:50:10 -0700 (PDT)
Date: Fri, 10 Jul 2026 07:50:09 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Harry Yoo <harry@kernel.org>, Usama Arif <usama.arif@linux.dev>,
	akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com,
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, muchun.song@linux.dev,
	peiyang_he@smail.nju.edu.cn, mhocko@kernel.org,
	roman.gushchin@linux.dev, ljs@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH v4] mm: mglru: fix stale batch updates after memcg
 reparenting
Message-ID: <alDccVjPeCi_PN-9@cmpxchg.org>
References: <20260701145736.3785016-1-usama.arif@linux.dev>
 <2fb5ce53-666b-4b0a-a4ad-2b3a28c54768@kernel.org>
 <akU5VdOBkLGInh_t@cmpxchg.org>
 <cbba6349-55a1-416d-a686-d03ff72cc211@linux.dev>
 <alBQBRWDrVoh9P-a@cmpxchg.org>
 <843f6d0d-e893-43ef-9cb3-1df21fb64b8d@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <843f6d0d-e893-43ef-9cb3-1df21fb64b8d@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4BE2640008
X-Stat-Signature: i3fyx5xogkri17ecgzsrnmr1wjssn5af
X-HE-Tag: 1783684212-800830
X-HE-Meta: U2FsdGVkX1/nSZpGoSWMsC5hdZZpK4/+lU2EjRpDPjMXWEOUKq2+yyXjQZ6jENHkgsceYcgEE2kngqP+a0nsFIClzhO6fzgUuNZ+TMRw7MEg5DvOR/9m2OZE38C23pWt6DTK6EsuEj3sDjbROWwAPFlJ44MhTzjUkLXanKVHNgp1JMQscFBPOZsjC2LzIR/Z7Ojp02TjX4p/4wrp0CfozwUSOk9h3zfXrK03V67bWxy8Tj79+EdOqVDFysi2rDQB88lnh0mY7pSTEG8JfkDn5vMFkw3st40Zg9h+jpKPR0mTSip7Je/gQHFV4VWwCO2kz84vEiyYer6j7OIVxuR2W5maCK7Fs8TFSFsrSpHiSXduWMWBK9JAh4ZNf8jFzXGvJoaLT5MLzmpHDQpjt81hEoe3ADZwEvEPbXzUTc/pC00r3KCDRel5NkCgacsEDSo2XKsriN0qBkln86Lw/xFd5ncEtIuxpJQP2R6HFiFsk2cwuW2P4ppCivh2JlHJfdBedBGva2L7lJTijWHBlNt9pb1bKbyjATYlYmZrq09dZMM6B7jp0wkFfY2mdgdsg/b9a/OcWq4iKStUAEvOjlGqjX/NjdCLR6wl9FeXxP6tWYv1pH18YNgsH3J7fhvIwz1vqzxVtT0EKoiTSy8ebrKCByBZ/6FnyEwictsYAIaW6vFb0AX52k+iNaCwthdnVSeVVfWU4ZFQSuP+dMCqUQSusfJkkPng6g5T3GYFQrkYlQRh9DEAMzgLGu2Q7RJOGs1Ofm0mItrga6yb+j2DbuLcMHgFOGwSWfq6V+VS6QNebxKBqD7bPkgDCaP64QZw6DBCDyXIwa3g6z0rKtzWnQi8+Czk+YDIlv3w5ai8os0Bt8FTp4kUfiHBFZMBWfftr1Usun8DFTYsjMR+DS5kl2mVOCYxBsZNqlY9Yj8RZiExIPkHpqRZz4RE7aneMuAu/jA1j980uTyKi73bhFtdJqq
 I2d19HTG
 +xrUdhHv9Fm1L/LpoKKRXMUhU49/JM+WkIOEo0JuFJpW87PCCL+lb0wIS1EWS3E/kdcVXDWVLtBLOFN3q2dR9vNxDUmRNOnNvqRZnYTOUT41pLcKZX6zN/Q6ZuZ2bIKH0/p+TryAHHe1Glang4QiCCKF2zAXq8xmHZumFC5+bYyRn/5sZA1Cstd+4R1lgxA0ZrRsexrJKSrAFor/k3kRPJ439dJPIF/fSLc0OQ5RFvAarG4JZQiGGalY6czGKelfAYcft8QFnyCGUs5Rm7NjJpq9C65n9SGYFmGRTUEEDi5vpUANeN4q0EBnmPXc85iD9aN9dYps1qWyj9m4ufkR7hGGWr2qgJ+tqH2LNxQG2cWfKDjNtOsku0FLgVAwgFyebvpzMZrBtgkZtblV4Ps03P/ioBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 02:19:15PM +0800, Qi Zheng wrote:
> On 7/10/26 9:51 AM, Johannes Weiner wrote:
> > On Thu, Jul 02, 2026 at 09:38:41AM +0800, Qi Zheng wrote:
> >> On 7/1/26 11:59 PM, Johannes Weiner wrote:
> >>> lruvec_live_lock_irq()?
> >>
> >> But lruvec_lock_irq() grabs the rcu lock too. :(
> > 
> > Yes, but it's self-explanatory if you put it with those definitions:
> > 
> > static inline void lruvec_lock_irq(struct lruvec *lruvec)
> > {
> >          rcu_read_lock();
> >          spin_lock_irq(&lruvec->lru_lock);
> > }
> > 
> > static struct lruvec *lruvec_live_lock_irq(struct lruvec *lruvec)
> > {
> > 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
> > 
> > 	rcu_read_lock();
> > 	while (unlikely(memcg && css_is_dying(&memcg->css))) {
> > 		memcg = parent_mem_cgroup(memcg);
> > 		lruvec = mem_cgroup_lruvec(memcg, lruvec_pgdat(lruvec));
> > 	}
> > 	spin_lock_irq(&lruvec->lru_lock);
> > }
> 
> All right, should the implementation for !CONFIG_MEMCG be placed here
> too?

Yes. You can just #ifdef, #else the function body itself.

static struct lruvec *lruvec_live_lock_irq()
{
#ifdef CONFIG_MEMCG
	...
#else
	lruvec_lock_irq(lruvec);
	return lruvec;
#endif
}

> Will send the v5.

Thanks.

