Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C1F0C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 13:58:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AC1D6B008C; Fri, 28 Aug 2026 09:58:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45D486B0092; Fri, 28 Aug 2026 09:58:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34D8C6B0095; Fri, 28 Aug 2026 09:58:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0EC6C6B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:58:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 762F0C03AB
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:58:13 +0000 (UTC)
X-FDA: 85150832466.01.19B651D
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf09.hostedemail.com (Postfix) with ESMTP id 47E9B140005
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:58:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Y0JhPLad;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787925491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KpbfDG68Jz7v4yiugpNXGnV426H5322VZcT0zhKeUVQ=;
	b=ju39BlCX9ymiVi1xAT2A1sfzbu7ipyjUuIvAgQc6fTSHj8fKhxmQH85mGOQzE0lPDCBpqy
	N3wh7SIX2itxtQeeZjrzd0Gk29rVeXVeqC+CvPo0JYgWsHGcrxeqGVRGFJZg6khxpr7qlH
	mYEEGLvJYT3qYyEPLIFEvZBZuN8I+9I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Y0JhPLad;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787925491;
	b=nuBDBtP1RtpSqIFRDd2NxbpYlHCoshaT9k/T9DvsLz2S54k2Ptey266z1FzIDu1JsTTQ1r
	4/7q67XIyi8HGPFfuvnm/nhzqK8PeoAGBHqTYt1iy/3CecvlONXzYmHtF3FKRAYoquYRC9
	CfgRKglp4DSNVls8WPJz82km6OmMy/M=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-482c58a8683so812879f8f.0
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 06:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787925490; x=1788530290; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KpbfDG68Jz7v4yiugpNXGnV426H5322VZcT0zhKeUVQ=;
        b=Y0JhPLadHVzwa0AqSjzi97OlM6QC3pTnOnZ/ZptwVIpoc+qOYIvbkG//wj8CbU0u5+
         4DuE6a/mLFZqtUJf+VwRCaXAllpHW5UDzKYmTn1zGSNbwS2rIISv5IkXDjmD4XDaSBrv
         BJGlbAxOX4nFWF4a26cwsOFav4Tcqwf72yW51SZb5iTlforf7rNOQbpDt4WN6bE76p/F
         zus5TwX9Fxwvo5wF/N1te8DxbtBLsivIng99n6UY8s8vVkpB2Cad3DZq7Kp8vz922fKL
         qAArscAFQdtjYYfS8rgcJasFJyNlX6FTLk3DqxtJONTsn+VF4Ke9ezMEjLVH/UBbERU1
         JVHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787925490; x=1788530290;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KpbfDG68Jz7v4yiugpNXGnV426H5322VZcT0zhKeUVQ=;
        b=q9v8vbTqMZeDjXccsKvgwYYaT6FNDcaXQSiPbp7a/vt08e+JuiLAztnfFS9lhRtnr0
         agNNJAN03iME4FeOl/YM8yDaOcAvIT0iGvq7ID2gAKcvt3h8lLiba9Zku9Aoxh491IMD
         0lixD1J+sW69KdT2fxTrj9MakwXRZx7UMfWsUPmfVJ8Ro/bw66b5PYPDYVMKTj3BKbj3
         /CVCAPF88TyaWhg2B1TYom4uQoSlbToQRi3d5HgWEesWBoaHf5AYh7cWcmEFFQKuig1N
         wMLKJ9UgqmiW5dFCYxeqOeMCuAZlS0KbelAN3pZ5Lf2DSqnjsbOXRFryshOt/PNLB3mp
         bvZg==
X-Forwarded-Encrypted: i=1; AHgh+RrpXMBoCsUs4DE7O0a+NJjNlW/ZbzxLiEo3LEHpxlvdcsQeYxR+rg2iCHzyyHY/Rfd8ny0b9EFEbA==@kvack.org
X-Gm-Message-State: AFuF++lgrKZ54kXUANsOJKePks2kmCijtSI+knQZuCuvZKkwhOpQHm+u
	h2oplgSdFGccjTcGd6nDkWhODL7D37N4Nf7FKjtmnopAzhm7Dku+jMR4R3m+m7yhODD5bN/jjKp
	ZTJ0fYho=
X-Gm-Gg: AR+sD11AXQXuomHr43P+6rEFJ0nPKVRoQ0ULCGGnDYgLiaVETAonTyZUIZnhxANywzR
	2p1GQKpICsOIwK8ZVeZTCJZSZuoaH7OBzWxF6w5EMJ9J50FJj3sLN9yKt4iAr3rvOKqMx+b/GcM
	Ij4kRFsgADMsabqHrMqZ9Yx7nIgj/VyGcz47Qo72mdLY+99f6LQI29PcWgPiU5cF+UjzQpp5tio
	mnDtskE3fM+juYl4oo5mM6o5DLxUraZejAi9whRHnqK4ShDVXvsjicsCCqt8AhddbOK42vIscqb
	wSK2J4jgBZFkeBU8xUgyeDqfdYQbRmeyp2L7wtzMp/XxSkBFM16zQYJgZIBxXOGPTK6fkq9t+7B
	NxcM2ezCCMUhATjgpYANlWCd+sWHek9seD73+VMJu68BWlwyfz/ahPXO060rbDlbDkn8ZhocZBQ
	+JKG1qvYq86MY2vn45NW5JShOke9UGTxPx+ujwDOJGqtONuaCESo59zCn8uJvNkoIFkvRdAHzYI
	Q==
X-Received: by 2002:a05:6000:4b1e:b0:482:ea08:8c8a with SMTP id ffacd0b85a97d-482f79c8f48mr11841026f8f.20.1787925489731;
        Fri, 28 Aug 2026 06:58:09 -0700 (PDT)
Received: from localhost (109-81-85-229.rct.o2.cz. [109.81.85.229])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482fba3cf65sm8616460f8f.0.2026.08.28.06.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 06:58:09 -0700 (PDT)
Date: Fri, 28 Aug 2026 15:58:07 +0200
From: Michal Hocko <mhocko@suse.com>
To: Hao Li <hao.li@linux.dev>
Cc: hannes@cmpxchg.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, akpm@linux-foundation.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: memcontrol: treat disabled memcg as kmem accounting
 disabled
Message-ID: <apGT74PpkVvkUkY4@tiehlicka>
References: <20260827091813.22327-1-hao.li@linux.dev>
 <apAnveXHmeQlKJnU@tiehlicka>
 <apDZV9nKW69ZbIj1@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apDZV9nKW69ZbIj1@fedora>
X-Stat-Signature: j3xzdgwyjibmfyi1idk6a5ddye3jf73t
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 47E9B140005
X-Rspam-User: 
X-HE-Tag: 1787925491-549941
X-HE-Meta: U2FsdGVkX1+sNCwUwdLBqk3lqAE3ObOoBoD0T1peKL6XTPLd0cJC6qHHWPsSClbZMQA3W+la4HsM9Y3CrUIWtjBZUqYO7THMVeMtqbL/k+/feWnANhThSEP8MY+D2WiKmp2mfHN8KIN8+sY7GhsNhWn6oxWcFCdcIHQmI7Whe+EH4OsqklBONsMPLuAHZBSOxhZ5n+47dwShaUKFaXq1Jgyzn8xJOIfAuKmxIBh3PtvYA5wG34F7Ki2x1JccE8V+pZ0bNEyqcn2mlrcOGRzU4n7lZbsjcQhXL7vqD+XTTF8L+h0CjuZZI6bvCrW39TUzl43ZE+i10NPzO41nst1XfUsj4MzXgWxMefrM175N0RW7VSLJ2lgDY5dm+/x8lCAWENOgdeDj/mU/zLYuQdNOS4yYG4+dVl0ncLfC4DkaFyYBl7JTM/RnIkdRRDvcwNWauPK51t3WXz+CxBxxz+lUJWU/aB/cLlkxrkzH0KNG5HmO2EVLA8eAHKjctgi+1XdK5YfDSuykZGflVURjbHMbh4ZmyGz7I3QyFk+1ms7tx7UXZ/o+pHo+5C61fe+ZLourUid2kgemBsl858oH0hXjBjWOVuFxdquNIEF3VyYQxdosYJVoREw8dxtX8mXFKQzpVu+T/xpynzHCzxWzkBpSU08itymP35TXxIzam5H52l7N3wH6+GKUbbG+cqBCGgMOZoGnvqT+792m1bTWE6E/8qpKlYQHpQxY+CX2HqDr3bKwL24DaKi3p5nVtSlzom12nlp1576B+Zhz5xXh7+b5ov8mUcfefRJL/OcX6a9SzTkgsLZ1e9CmIPJBW43JWe74l398T4jeTL2ZWYYlrRorLXa1PYl06WafeTPASTG6oc+txb6UGa5wvoflwRJU37vCKK1EP7AWPaq/Lf7/+GI0EwFYNyuHDpIL0FXvfhWqn2K0zpg03zWkMvJqy3i6Ux5YHqDBGyx1uM/6DwzYxFL
 SQBtWBmf
 oTTk4P7Edupbq1S8owvFap+tE3e70bSzOfOoUJhqp+OMxS1DuqK2uGmGNzsyyk3khOCVPM5jUNZv1fxClvebvuUY6ofTcDn6dyO7KRISQVatlWJhUjx1xnf84mvhxFr5WqzQuRp3Oj7AYgUjUiMmiQmxuNgrQscTDSl2NYR9Qa91GQ3PhOWr5+X2Mzti/MMIQ8uXr7yFz+vRjBU+xzGVw5FkFxPyG2fSBEARG0usUWvYBRqBSIP7w4mg5X7jCdQy8k53giRPvoKpd0wvI7KQvlqeb0eF3+W0jxelq8ikO4Se6N4ON36UcYLsCMwT4tKWzGU37qTJK2CmNI2GkSdT/dcOOs96ISkBV12vM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 28-08-26 08:47:54, Hao Li wrote:
> On Thu, Aug 27, 2026 at 02:04:13PM +0200, Michal Hocko wrote:
> > On Thu 27-08-26 17:17:50, Hao Li wrote:
> > > mem_cgroup_kmem_disabled() currently only checks whether the
> > > "cgroup.memory=nokmem" option is specified. However, kmem accounting is
> > > also unavailable when memcg itself is disabled.
> > > 
> > > Check both conditions to ensure the function accurately reflects the
> > > kmem accounting state.
> > 
> > It would be really great if you could describe how we could end up with
> > the inconsistent memcg enabled but kmem enabled and what kind of effect
> > does this have.
> 
> Yes, thanks for point out this.
> 
> > 
> > AFAICS the inconsistency is possible and it would lead some wastage but
> > no functional problems but the changelog should be more descriptive.
> 
> Exactly! The most direct benefit is that when memcg is disabled,
> new_kmalloc_cache() will not need to create a separate `KMALLOC_CGROUP` slub
> cache, but can simply alias it to `KMALLOC_NORMAL`. This avoids wastage.

This is definitely important detail to mention in the chagelog. Same as
the effect on the __list_lru_init and other callers. TBH I am no longer
100% sure this is correct. You need to explain more why this is just
wastage rathe than a subtle side effect that is desirable.

> If this sounds reasonable, I would be happy to explain it in more detail
> in v2.
> 
> > 
> > > Signed-off-by: Hao Li <hao.li@linux.dev>
> > > ---
> > >  mm/memcontrol.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index 1ebceade4021..b28f6165c354 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -132,7 +132,7 @@ static DEFINE_SPINLOCK(objcg_lock);
> > >  
> > >  bool mem_cgroup_kmem_disabled(void)
> > >  {
> > > -	return cgroup_memory_nokmem;
> > > +	return cgroup_memory_nokmem || mem_cgroup_disabled();
> > >  }
> > >  
> > >  static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages);
> > > -- 
> > > 2.54.0
> > 
> > -- 
> > Michal Hocko
> > SUSE Labs
> 
> -- 
> Thanks,
> Hao

-- 
Michal Hocko
SUSE Labs

