Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEE8EEC1128
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 20:19:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB92B6B0005; Mon, 23 Feb 2026 15:19:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3CBD6B0089; Mon, 23 Feb 2026 15:19:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B14896B008A; Mon, 23 Feb 2026 15:19:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9E6856B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:19:28 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 14B1B1602EE
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:19:28 +0000 (UTC)
X-FDA: 84476836416.28.6F9300E
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id CAFC38000D
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:19:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="Isa/zrBe";
	spf=pass (imf02.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771877966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xI8/Up3XNsFX7BWIlObCd4llqnACUqRWzNuLSnRU3aU=;
	b=cfpdTZ4yESnHF/Owxs8ePUNbF0v7KgqO4H78Kq9wmlUQ5dtUjd9H+gSd34RFL0CIUlh9Tt
	wDu9esDLkDtX1iOOXoZ6LdGpZaWQ/vUdjx3Gz2UY9rVjfDn9k0vBRC99OezbFiDOB/YU9X
	rk3E6wgjJCV/qEMHoavzN6fdRiC+QGI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="Isa/zrBe";
	spf=pass (imf02.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771877966; a=rsa-sha256;
	cv=none;
	b=CB77v2Yue9qVjI9f4scDcyDcXFrq5idDNQohYGckDdEXzOpIhMXCXLSoRUjM3A7soF3mwE
	rDhs3pUTwAhX8J+Pja1aVRvnUOZeX2jx/UGpgJMCfBljDcG197B3Yx7Ee2Xu2aFCRFPKr7
	e13QZQevtlfQuY5yDTqJgoO489XG3xY=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-50336cffef9so36371731cf.0
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1771877965; x=1772482765; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xI8/Up3XNsFX7BWIlObCd4llqnACUqRWzNuLSnRU3aU=;
        b=Isa/zrBeTGReme0VOa1gZD/MPQRGWI261N9msEi27qYauwu0ZDVf9WXRcJKNOBGkag
         UWTX+mQWJuKlvQ+9kJ9BGAu5QfFadcyL9ItgsEWdUotiPVuqJyd79Q07A1nK/58ehyZc
         X8I0PjcoOeT/Kq8aUawP29fv0lmocOq0zorY8n4rTSj+iyLxXJ/z6lZdiTyyrnUHxJxx
         UcLDQ4Ik0K+BYpM7ijgm+2UxJbOyRO2NilDGvvwWejNpNZPDSq1JEaJDf1294o18V2Jd
         SItgdqQf4tgNvbmXlfuST1HC6G1zzfFQiXJmsFUna/oq8rlvcEf9wa0SnXa68+u8Tl8r
         zAkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771877965; x=1772482765;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xI8/Up3XNsFX7BWIlObCd4llqnACUqRWzNuLSnRU3aU=;
        b=iHklvM+UBgzYw1phnuWFU4wMdLHn9aPZMVCDZvw9HBjMjqSzeQMN3zhlcVUBYVirXG
         TFUp2iO1PKiURIsSXmsjl3n2LbY7WNwyHF8063I7T86g5e+qIHlVreDFAAhP0CD2jEr/
         9gieaTWg0ps8dOBlz7TdGGjfi+Fo0n+OFUUcw7bBvUrBIpXMfHj+IV7/nww1FaSslwpL
         jwoxNV6iFkJYqr5xdthzubJ/MuZkVnASNMe0DWlGKuygdvQnY95mkZj9KSkQ+7S0Od79
         7NmFBhUjrUiajsoFcM7VIJwXAob+AcmpfwS8KQhjtoMTSTHFytASaVZra1Zo7oP4ErbQ
         nY/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXfxIGo5BQNA3CjTFwu9cw8USwwjlBa5Rm/pZ6tl3yvAmayMH/nKCsBJhuebTV0DjtF4c4qumOHFg==@kvack.org
X-Gm-Message-State: AOJu0YztjnGxkkL4pgy12Q+92cPrDOWms74H3tF0bGxeUKGifTL6mXSa
	iENwF4OzlrC40nyJSenwrohH9m92uuyvI1vdfFowXjAtVJbevg9JZRMIS3K5OQiJQPE=
X-Gm-Gg: AZuq6aL/kObQq2oBbWSevhsavnSIEGVF3Lhykn/14XKjuDAxxXg4mTXRnZn1LEBgXuD
	gX4Q5YxzCZfAyM5250paqeIZojVl4f2J7QqL0XDdspCaffwi5Toet10ml9kcePFg3l93frO3jOR
	VrtcKAMnFDPHQWMGZjp+y+fH3mWmKloATVskYJ68ACJ8eY2tijh53P+ouS3zQiKM6EYd6BHUW1t
	n0sV0lV7wsqG84wJmB7VAXtCJNEv0/2o57+38sT+an8ApTW6+EIsI9slbH7UzF9K5PIkAvaBdTs
	ee1HQ1d7lKSsX/m5BC4+/zgKLvunWa7mLEdbnZFgWoQ6dzeXC3tqp9JnSrx3dWcVUGPd9VZED/0
	rQCNwdJtFMm61siEkURkorGfmBFAQasS31yjNW5KATkMbIQqDXSPoaStDdlvVPTNYQEYoNtPW5B
	TBxthxzhqooOAkkvOoCdWWDQ==
X-Received: by 2002:ac8:7dc2:0:b0:502:a241:1eec with SMTP id d75a77b69052e-5070bba6b70mr144568591cf.3.1771877964441;
        Mon, 23 Feb 2026 12:19:24 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8997e6341c4sm76857036d6.35.2026.02.23.12.19.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 12:19:23 -0800 (PST)
Date: Mon, 23 Feb 2026 15:19:20 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: vmalloc: streamline vmalloc memory accounting
Message-ID: <aZy2SHbXi6qdGS0a@cmpxchg.org>
References: <20260220191035.3703800-1-hannes@cmpxchg.org>
 <aZxymBwx67pMn1ZP@pc636>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZxymBwx67pMn1ZP@pc636>
X-Stat-Signature: hdxu8ohoic4g5wpn544r55g959ke1yb1
X-Rspam-User: 
X-Rspamd-Queue-Id: CAFC38000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1771877965-793154
X-HE-Meta: U2FsdGVkX1/hdwcruvhdtdWUcJfMmooxCZWhncJ6Majk0+89MfcwIE/OP7HM+AHmF11bwSeHrliDx/afmwXNs0wM61CiqE5WUz4/bT5STsHAcM2XeGayecGoEv0b6mQilLexHfrzDYJ7Q/bWNaFV8jh3zC/NEmfC7x8XT0l6T3nB1sNq8U1FjqrlApP2NF7koDuvD4RS8jtE+tJ8/C7C5YmFs2kYA/uqeZlVVPtszyHKToc7wdRf3mMqX+qCF73ZP0T+hh7qYPiV/k4Y9/JGKbnOR5ihQLAxBXb/KhMK79dq/HWxJXUdRMCI8lz1KDgPZAxXYzrvoAXEjdYNPtn0isOGo5HkAXYRJA4PyioexHir8ph5zuOZSL9eK8WSeJUDM2Of4LiIQM9snmvMLivMBeY0YNiZpZaLZG+tzI90u3/TuzegVsRJBJCiuRYEbrTFqskgyZInmjPOu4jorlVfitH4dzd28WVd+9WlZKUvKFIOltKwqdnUzNX7wLMLSLb4hnoIGy+dg7hA9Wrnvnie1wf5ZKPk6klLs1SzVTxy4lKwaPHVU2laEsR1N1UE1RJQQY5inw9SVKhoQqcUaaJlR2fKTd9kbLGSbthn9ezuSIBbreDI90KLcIPke2GaZVfDnc2JG9Hi9isLi5LTEpfofR5b4WRVBovOMrwyrHtLrxuaTNbsbGa+wY7jHKj+FtcOLXjeCnsSU3BFcJZigeoHFyKQ/ZACo6vnyHMMAioP3au2cwRBYbQKl0q3yWarrUm0GnWtgl/WIKA3lKE30XrYv6LkFWgqCiAz/4mqkvN/wdknmeukd9jhw30RjXpgKrKo4669E+lgVCK2tCVJ03JUGdKigb53wxhR+wlkk97P1c6jZw3Srj4WIgzz2uOBUjc60nz5bjrNDK+ARnoyGtz0xDmhfXX0Q0v2uX/sPMiEe+ZtQJuKD/ItkwNsjgEeNpjDRZbqPTgL42jvwYTIyPF
 84InM0i8
 9mgs23fase5GVRwtrJqgQIdZb+lJBNWpMISL02QIVBsmuxgVYZn5TZO8uwltrXU9LSW/5lf8ikf/WrRNgQyZ7zBez8v0y9wO3nfnF2wSphpHC8ZdOtzbC+7gNXtXZs3Xvjr1y1MhRHYpMpKvt/45gpWy0Blmi9y126IC4dzNUK80Sj7zTk4PSsZ80BUhZvmulIAyuSSjoVLEHQEuQkDX8OZyEPE6FNJZnWBeorvZqLft4Lw2YIOTVj3H++9jXzsvCcsRW+xwzyUd8edT1f/+A+JyFk1ezmZxdBChfb7DbElojKlNkwm6jBmJb8pZDJR+r9wc92DMUOBBBkPuLv2l2ZXuY/2c5YOrbmeNKN8qjSkxS1VswoOEJ26WT0qxL4PfMn/+31PLzFBkWJ8kfYWHX3QJcpaJ7GYC6/U5uAL4Bz+x+xiC4rPqDYET7sHGWboYxPSYMFGAN1zZvW3ve7JwGQzxvK+wmM0cxAXwx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 04:30:32PM +0100, Uladzislau Rezki wrote:
> On Fri, Feb 20, 2026 at 02:10:34PM -0500, Johannes Weiner wrote:
> > @@ -3655,6 +3649,8 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
> >  			continue;
> >  		}
> >  
> > +		mod_node_page_state(page, NR_VMALLOC, 1 << large_order);
> > +
> >  		split_page(page, large_order);
> >  		for (i = 0; i < (1U << large_order); i++)
> >  			pages[nr_allocated + i] = page + i;
> > @@ -3675,6 +3671,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
> >  	if (!order) {
> >  		while (nr_allocated < nr_pages) {
> >  			unsigned int nr, nr_pages_request;
> > +			int i;
> >  
> >  			/*
> >  			 * A maximum allowed request is hard-coded and is 100
> > @@ -3698,6 +3695,9 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
> >  							nr_pages_request,
> >  							pages + nr_allocated);
> >  
> > +			for (i = nr_allocated; i < nr_allocated + nr; i++)
> > +				inc_node_page_state(pages[i], NR_VMALLOC);
> > +
> >  			nr_allocated += nr;
> >  
> >  			/*
> > @@ -3722,6 +3722,8 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
> >  		if (unlikely(!page))
> >  			break;
> >  
> > +		mod_node_page_state(page, NR_VMALLOC, 1 << order);
> > +
> >  		/*
> Can we move *_node_page_stat() to the end of the vm_area_alloc_pages()?
> 
> Or mod_node_page_state in first place should be invoked on high-order
> page before split(to avoid of looping over small pages afterword)?
> 
> I mean it would be good to place to the one solid place. If it is possible
> of course.

Note that the top one in the fast path IS called before the
split. We're accounting in the same step size as the page allocator
can give us.

In the fallback paths (bulk allocator, and one-by-one loop), the issue
is that the individual pages could be coming from different nodes, so
they need to bump different counters. One possible solution would be
to remember the last node and accumulate until it differs, then flush:

fallback_loop() {
	page = alloc_pages();
	nid = page_to_nid(page);
	if (nid != last_nid) {
		if (node_count) {
			mod_node_page_state(...);
			node_count = 0;
		}
		last_nid = nid;
	}
}

if (node_count)
	mod_node_page_state(...);

But it IS the slow path, and these are fairly cheap per-cpu
counters. Especially compared to the cost of calling into the
allocator. So I'm not sure it's worth it... What do you think?

