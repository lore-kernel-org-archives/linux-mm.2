Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAE72FD877B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 14:03:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38CE46B0088; Tue, 17 Mar 2026 10:03:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 364896B008A; Tue, 17 Mar 2026 10:03:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27A3D6B008C; Tue, 17 Mar 2026 10:03:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 15BD46B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:03:13 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4D2B11A0240
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:03:12 +0000 (UTC)
X-FDA: 84555721824.06.AC345BD
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf26.hostedemail.com (Postfix) with ESMTP id E251B14001A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:03:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="uGK/Pyja";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773756190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q0tipdXjQf1YFueIG3pjpKIi6COxIgjA+uwJOLkXywE=;
	b=RQUUDe8KMiZn7zNk8dFqQNOtPTv3HsZrIesDSi4LBzJ3U42CWZ8Arzu7hecsYGGmHvdDFZ
	COnfYmc4EktY2yCFLYxZYjRFJUaXpMrkzc1NMLUUE3mY82MUWuEnIlQ3ohikpJ9qeY78Sx
	OY1c0BKYXqt95eTGzIkQ9LxrPMoargg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="uGK/Pyja";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773756190; a=rsa-sha256;
	cv=none;
	b=3bn4y2yhSGbSk5GvCnxLti2Dw7/vjkoIcJjZ8yaXR0sve3qCbAQ4zZVpZPtoz0XJfnTSe2
	eQXrjqK8dsMOVAC6fo4Q/zSO2gTkCaJpRVT0toUtBQ/dr93L+ak2PtS8CDt0rjk+FFhKWy
	jnf8xd/WDg4GIz+0G3l8j8TRo2J58ds=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5094e1d17d3so50088871cf.3
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 07:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773756188; x=1774360988; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q0tipdXjQf1YFueIG3pjpKIi6COxIgjA+uwJOLkXywE=;
        b=uGK/PyjaFBcA0AVynYOwGX+SfQs+w4VMemO+8NEXovmYIrPN20cmU24b8YrrroJrpW
         Cu1scn4vUd83PQcgEprefpuZpKvxGiE7CrV0/QJAxIqi+nZNKtjuijNIcyn++kDpot7t
         cuEvDLw9dMaAel3b//N/+mBDzcThnWxUPfFN+YAfAr7Zl0CsIjOrPl2zGA4wfYbzpnnM
         oidREqVHQW2k6HRYXs1bBNvo/MqDeDeb96CsdVunhgUF4vsjCLeFFi1Gg7XT9/J0Yeuu
         uDgSHyqXSFH/wMP71tuc2ema2h3h/L7GIcd4ye3dm+nm3UhWxpARC9i1W3VojgVOMXS/
         clTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773756188; x=1774360988;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q0tipdXjQf1YFueIG3pjpKIi6COxIgjA+uwJOLkXywE=;
        b=eQ7RpG7D+8PWcoRXo3oHnshpi24G145gjj6iaPi+3FC+nB4EsNbJfKegC1Q35rjK9D
         Tnw/HQOwXIhmChtQ79hZ9TAnSaHizTgs+JsvBuQIST8YML9g/hX4o6Q6RMkACI4wmo2z
         I0oZgBntvTbhrDNWFLvgMfKHEeNodcLR9bD2qLOUHkAPZ5wjYb+tlpwp2zVPetcvm8EH
         VxKinIQKmU+yaKrDOMUgSr6z/nD3FjirKjFnXZJ3AgUxG16pkqqJqWMk9DTM+uGMtIny
         LOEjcuiHm7rCE7DeoonKDa6T69fsNhparMAsxtWx/4cDhIb8FUaSZVMMoQ9jRbAaDpxP
         iyZg==
X-Forwarded-Encrypted: i=1; AJvYcCUHtkzFX/qlO5YY4IYL+pXxQ8oXoM+4H3Znkh7fz90UVYxViUdCMTnz1nRj4ZYFIe2clPLGPj+LvQ==@kvack.org
X-Gm-Message-State: AOJu0YzOslJcfbNWqlJ59TuJpsqg1i0OIl/hrUsjtj6huMxxVLDNaaWg
	/W1cFtbSSBrjfr+tPKQq59xHV5tJ4FzT/6vTbAj28dY3dLaytNZsb4RC+aI2Hi+sMVE=
X-Gm-Gg: ATEYQzxiXHaCgQma7GIin/r4UwPazp4J1BEznFuYoMuLUo3DXTzhK9TcsQLD9pK/du2
	6nUQefGpieAO8bKtGriado9t5ocqjoFDJSr8K9jbd/LZR3g/fBbghJaJmMsh6LIA+tvRYtN/hQs
	rvZ7hDNf4ON/0XWtbGt+1fmprZ6K8CqQRBTjE4Ts70mCFQr6tM0wAws9D/2TN0vpyMPjD0FOqnz
	4SiBJ6Gb3jaGyECVt40rlmPFmxCPIFcb7T6yG1VKOsWIQTeCf8BmBFVQhyfLLg8bZDove94t5tL
	KXG55+Y893m0TS6dZ9bFrFfG7RbcICSiTZ8cjSP//T2lbQK7EDljBOf/F9/jsWe9YXr6VJDyTxC
	LDx2TzCnyb6Jg4j9iw1InjRv82+DASVAAc2pYN9MryM1DxRT/YJtGUeYtqCQXQMxY7gUDiYO6cd
	RpTkxFIbfUyGG6bWHhi7iKZw==
X-Received: by 2002:ac8:5fc9:0:b0:509:1e54:a501 with SMTP id d75a77b69052e-50957cb1c78mr217731181cf.9.1773756187953;
        Tue, 17 Mar 2026 07:03:07 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5093a0ea244sm143096271cf.16.2026.03.17.07.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 07:03:07 -0700 (PDT)
Date: Tue, 17 Mar 2026 10:03:03 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/7] mm: list_lru: introduce caller locking for
 additions and deletions
Message-ID: <ablfFy6xnWwZQyUq@cmpxchg.org>
References: <20260312205321.638053-1-hannes@cmpxchg.org>
 <20260312205321.638053-6-hannes@cmpxchg.org>
 <46d9173e-98cd-4f59-b0f3-e477afd5283b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46d9173e-98cd-4f59-b0f3-e477afd5283b@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E251B14001A
X-Stat-Signature: j8c4dge46mqdbdpmce91b3zekzknts4t
X-Rspam-User: 
X-HE-Tag: 1773756189-843483
X-HE-Meta: U2FsdGVkX18EaxjliRs0Sp4n4vh1xIVx47Ol3lLGXLtE29H9CXFvcPSyOTBSnUqLPSQ+iRmKjAJiY3ZfiydzX9VFZMeW8wvtkkxFxqAINfkqp/gOy/cdEC8KCA9Qwz6in1CAMI0NNUn4GX0fwSP3nuwtUefrWGSvmrIaSKL2vWWTUdl60UO7rS0ghvlYym3Wlgr/T3OJdZrB4OvQxG560vezyCezotK+PwwGRwcvt2jls4YWc0O+iXCHjqn799NY/Q7JGF/7GjjFoBhDeKNstqJHFOiITPncNFU3FmXGU/cYl2ffnvI29dgaaa9dRf0yGTj14Zs2ivndqRqq/3HOOqoBypqJq6yvfhmHfYgYen5hZDz6T6lWwkneLeJlXmD5K4yH3M9WK5ng/Hu7J3YupFl8w8I39buv+RmzJGELgILm0MOyYobXpLaLyJf8hOZcl8hvugPGOOEPn38MBsrMSOrjUfd/bbileOHOXbm5C9wJ66Wc0hVucD63jojl6BDtPOBnJRXvnVGiHvobzNlOKQeJqI2AfPiTMfA9DDXi3XzGkvJzSb8dYz7wKXFODy6uIW4vYm9o7OGWSqcyGIUhcKZm0uwYGy8cJ+HrWP3u/wKNtwxMcQ+0x/L1bFMJ/DqeHbD25BnZ24quD/+EwUUvkHHLvqWVq4tAH2EiyrZGFrdxW8YYKWPzZMwdWKpaWb0ZLZQICTT0DFYwBi0R0fJwQQ+tlZzmePW/VEeWLcEFvh3Eek7OPvxnHrKPb5QsiEfCG+EL/gab2D/9KcxvfjhbPIey5snTr8F1nDak+dD5Mp04sRSPNGyhyfm/uMeC8lwiqIaKjVBQvSEGICXxozLXZOOLAGTWFtNx6GXql/Ee54rffZ/vStQIok+SWj+HEENVGMHwoKdrZ09015ujjaL7SQupU55v4QmbMFPnqmeCGDymjuaqRgUO8lCOOyCUU0eUyydWei/kzb2M528QR/D
 0gkUyHh0
 Gz1j1aBu/3t0S52PSEazhRs3o/Sn1aodhzVPf/M1f6q56MC9FKfcHbe9Js3LObm988YScDNeDUoLG1BHuZlf6/6XaFMXpuzFATMEvv3MdrokuCLjAfS/SvkdRSh7jvtZKFbPQLS3cejac9+29h6onYe57zvlEL/WrNQ2CP0SfKza5CoEAOG0QXxeWObboQzbLdt9Tz02EwKIXiomq1Q2Ew4RST6cCYn+ojjX/+S90oFi+y3GwqX7S4VhFZbcFSe6uW9vSG99Az/WMDWLg3w62HOR7xHgfbpB8gRzuovW8xokjq9bq3DsjfuC+6cxRvgNx+SGHbhgZ7U6jBTkSbM+7C0Wl78/jVFaa3nRPlHwLy3hQUuYY9OwxLxVwWpqUxPKAqqMJvvaDvWIeXTPx91tSds/9W1VjeD8i35XF+GTDfjqD9ny0TaAbPQeLhULBCsyULaJEKQgHUelvzlxtSS4ohBk2BZ/UShfgCW8+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 11:00:59AM +0100, David Hildenbrand (Arm) wrote:
> On 3/12/26 21:51, Johannes Weiner wrote:
> > -/* The caller must ensure the memcg lifetime. */
> > -bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
> > -		  struct mem_cgroup *memcg)
> > +struct list_lru_one *list_lru_lock(struct list_lru *lru, int nid,
> > +				   struct mem_cgroup *memcg)
> >  {
> > -	struct list_lru_node *nlru = &lru->node[nid];
> > -	struct list_lru_one *l;
> > +	return lock_list_lru_of_memcg(lru, nid, memcg, false, NULL, false);
> 
> The two "bool" parameters really are ugly. Fortunately this is only an
> internal function.

Yeah, I absolutely hate this too. I only didn't look further because
it's internal, but...

> The callers are still a bit hard to read; we could add /*skip=empty=*/true).
> 
> like
> 
> return lock_list_lru_of_memcg(lru, nid, memcg, /* irq= */false, NULL,
> 			      /* skip_empty= */false);
> 
> Like we do in other code. But I guess we should do it consistently then
> (or better add some proper flags).
> 
> Anyhow, something that could be cleaned up later.

This is a great idea.

I have to send a v3 for the fix in __folio_freeze_and_split_unmapped()
and the lockdep key, so I'll make this change along with it.

> > +void list_lru_unlock(struct list_lru_one *l)
> > +{
> > +	unlock_list_lru(l, false, NULL);
> > +}
> > +
> > +struct list_lru_one *list_lru_lock_irqsave(struct list_lru *lru, int nid,
> > +					   struct mem_cgroup *memcg,
> > +					   unsigned long *flags)
> > +{
> > +	return lock_list_lru_of_memcg(lru, nid, memcg, true, flags, false);
> 
> And here it gets really confusing. true false false ... am I reading
> binary code?
> 
> I guess the second "false" should actually be "NULL" :)

Good catch, I'll fix that.

> > +/* The caller must ensure the memcg lifetime. */
> > +bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
> > +		  struct mem_cgroup *memcg)
> > +{
> > +	struct list_lru_one *l;
> > +	bool ret;
> > +
> > +	l = list_lru_lock(lru, nid, memcg);
> > +	ret = __list_lru_add(lru, l, item, nid, memcg);
> > +	list_lru_unlock(l);
> > +	return ret;
> > +}
> 
> Nice.
> 
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks for your review!

