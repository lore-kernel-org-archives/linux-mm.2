Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B28931125876
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 19:24:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D56CC6B0005; Wed, 11 Mar 2026 15:24:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D047A6B0089; Wed, 11 Mar 2026 15:24:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C06C66B008A; Wed, 11 Mar 2026 15:24:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ADE076B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:24:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4BEF3B8890
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:24:23 +0000 (UTC)
X-FDA: 84534758406.13.4B9EEB2
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf23.hostedemail.com (Postfix) with ESMTP id 32E7814000D
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:24:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="WdQoDe/R";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.50 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773257061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8U0uYARB35fXHTmG04QQVNwq76UNnAJXyOiaCIyb4bk=;
	b=HBxFmIywwvSKY/aZ2f/ioFQ3p1+cBE5RnQ4OzycGgesqqa4YnqDG7nXGKchycwB4N3zGkP
	7blm08yeT50BplR77hAlH91SiaurJsFiFyN1SsZC9rdF3xFU/bD0jlBxCKfz9NVSWDzZ0a
	a4L/R87QyaCeLzF59L9p/pPMde9vdyw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773257061; a=rsa-sha256;
	cv=none;
	b=pu1JQ8XyTgbOqULCL9yoV+BNSevx3Peu1qdfAyRHiwOaCbFtxUtQPtrLL7SXp0+I9pGfQ0
	s1/Vi0j+H2MP1rR2AUlYogNdrjoPm+dn39KKK7tbqs1lDzx6RRvW7bhPrHCkficPEyDx27
	fr1q6WAE6V+QdqPWitULUvDkS73+bi0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="WdQoDe/R";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.50 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-899fbf92bdbso3110866d6.0
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773257060; x=1773861860; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8U0uYARB35fXHTmG04QQVNwq76UNnAJXyOiaCIyb4bk=;
        b=WdQoDe/R0BcZO0rZ2zcUtH1hWmfNzEdA5DRDS7qQ2R/zrY0RawiA25yqbgVZLyr82f
         8OtLki66iNPba3td78OTnYu+wzZtZkgOxvCfl3hgY0e07fS5jTIM+z1CTtlD5mv4qRXj
         t6Bwi6uusi3PDJYyg28RrnwT6f63yVCQcU2UWKTuZMKPAbqzOeSEtyAF4iKTWWQvAd6B
         uKy971Ee6oZyN+JWlQ8lWpUbqeWqklsVaErU64aVDIUa/accxkn1oMTfnm5qtqyJH2Jn
         MveiyiRfS4OYjRjwOnluh0Q82VPopx1hkKVxCW2Ik4YQtk99rRo+2Xg5PDuV88sGylrO
         nObw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773257060; x=1773861860;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8U0uYARB35fXHTmG04QQVNwq76UNnAJXyOiaCIyb4bk=;
        b=jnIXsgV5/M9OQ5pthqEKwfdhW4oAT0T1UKwlHlD9NTeCM9aX7YX6sX00ozHGDaqkmy
         E6AMO1sV/uxeFAgUYFaBkNQZqCEYlGUeTkXU2CjAyW/d+sBoJPlRwrskFJ/VlqgGEVS5
         RGavuCDkPyKpsRbrio5P2Le7jicQ8KfZVfg8IMRVWtHFWKkRm/Ma0EOTdgt6RDy4COx0
         AaG8SIwnTo0BnCWysZVH0zLQRxmGW1pa7Fll8lW7rA+FhYN4BguDzUEtk+6EGryIACBF
         Dv8c5jwGStf8HGgpJpV3SmoDDy/Ha6k0O73T7D4m9PLdYjEUl3EJVx0+uyToGm6PPVzn
         Kz1A==
X-Forwarded-Encrypted: i=1; AJvYcCVZPQStkDteXrtm38bSDfx1xZnaWb6wAwBv7uM3B2S/Sd9qo933sB05ltPP/3kTt1UPfBozqsw0vA==@kvack.org
X-Gm-Message-State: AOJu0YwrXMALV/w8cF9Rb32qGtlhAtgkaAS3KzuYSITFSe77vYJ0XqoQ
	cr0Q0sidfo0laOzSQw3wbuw4BjW3bJ6fZBhgUeh9nnZtsEN66oX8nea23LVJYaakKSc=
X-Gm-Gg: ATEYQzzS60B1gUDSCWruLBeibjyJyL2bFvng14ouQAB2zm6mffo4KCrkdgmAwh+8THH
	4SQKaGB4RD59TL5m01pJx+nN79QbEvdIHnkglQ90215kMxaceu94Bwj6gisHpRMzcZFMYrXTdn2
	7u1wm9gZT5YWbBFIIH4yI76/QV7eLY7dFk+qixrElDRLbZ86ULRmEZRKrgsoikfW472Wu9f022X
	hF3Db8lbsOTmCfpym4sbowdbJk41aAOBk82Y0uAAzNmmzgCbsTNDZTfbXogG7KLGbdyfAJqfq/u
	CCDXf53fnWqkhU71OpZKwHGVxLI7Hh7rPb0RbXxgf8acV+0MjBvlN7ZsquV61FHBzKDiEo2kY66
	Es75c96Pq1MLNEmw/MLZ8r4NkwPwYeW2LLaoswu+fDLfnFtLQyRUhnB2Ail0PfLLr+M4dRsK1vr
	X3f31m6zWz1WrsPRltCCP73w==
X-Received: by 2002:a05:6214:2305:b0:89a:717:1e48 with SMTP id 6a1803df08f44-89a66ae1ce8mr47665266d6.58.1773257060159;
        Wed, 11 Mar 2026 12:24:20 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a65cfc409sm20026086d6.35.2026.03.11.12.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 12:24:19 -0700 (PDT)
Date: Wed, 11 Mar 2026 15:24:18 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: switch deferred split shrinker to list_lru
Message-ID: <abHBYss1GDYX4uWe@cmpxchg.org>
References: <20260311154358.150977-1-hannes@cmpxchg.org>
 <050ce5bd-4725-468e-acaf-7fca72b84d06@linux.dev>
 <abGpgxsDKeSc6cjR@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abGpgxsDKeSc6cjR@cmpxchg.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 32E7814000D
X-Stat-Signature: ichiceysqg3nnirzywbhmd98thy1nqf5
X-Rspam-User: 
X-HE-Tag: 1773257061-427661
X-HE-Meta: U2FsdGVkX19DGuMuvxoykaUMWEjyCw4WjTn7ZZ55+PttmB5sWkRZKtJq3WgYq1XJGsTNELbBPGzUmMessTwYDqjVfUXES4EvWjaHdKOm+6onGUatyzV2+CAPRekrpFWlyw5MOuadoc8eQD2e+Y4f/K7YbFlTLvEQDuB8enmmfE6WgbIP2xQEqhGNh7hNq/bW1vRWLBckMNHI3WqZT0swo9A/i7GTfUu3j3qcZ2SxfVyhCKrVRJsLzi4SHKHyTiO4SEqJTAi3aznUHpgQY54LxdqEHFF+p42i+teJChYSGWgjY/jSg8/TH2G3+TGh3WKESeMYKGD5ecr86msUCmoU0aXETs6dNCFp8cwBVsJ2svNywQjYrVY7DKz7Oo1lNo3avON40I6RJV7QbpOZxnvIX5sKCB2mBKXqyMlHXoJW8GzVJT7cEWlhOLNVE48lgKoAGoqxXuruxv4FHKfifhmJuzmVsCOWalXrrvbOmwz5vbkvCBgKB0xZaplPBIqNwy3R1ndxkBtwg6uzhmEAtHZ5OcfIzN6IbOJzS9U5d34v7Eq6LSfTv5mko4rKW/QshkY1ENYYe96Rz6n2QKX5i0UlxHg9CNNPWlCiOcy0nPKlLGUXZ2v4phorPANqwSEX+8WUBao/snfxkJEhH6myZgZftjn/VbVohkB3rxImnNOngE8c/7lYF6QbjQktyCgHNz2Z4arsccED4GAvJzL872gEEkHFgYsCR2MVUza9SGGTSKGrRnDTyGyeI1QG2tjdaqTvqt32vtISXj3eqYwayKrsc1JwlnfMorjTmrVohIrXGepGT0SXjkk0GNSX5WCLeihQT0e9XVmJGGu0cNJhSYUA4uI2/ZysFmmPfY8F5O5W2VX2k5B4hkfXu0qAkuuftG5UM3gVz5l9Z4tqL2fUswhaiagQmYDq6ZOTt4CprZDl8bgHQX8IUCG1AfdIjypQV50MUX+YpjsNt1mbFN/LdQp
 qejSRjL9
 +zPEIpiem6IsDVfGUxwLizGmJIxpOkakZAiLl6hUJV1z5lKFJzrXx5syk44mqMOjnhUupgT9ottz9+BI5gGAPoLzbJkXAEtLY7qPngeKeNxpXxjBm33HAdh5+2h0BSzWxDLtYBPC3QR8glIXGBN5WUa5RGci61jv+MKmjIzY6zLAwAgbLuWnXFG4vezSvEzJTE1aQxYXB7CZC6vq5YQ0dQsBadysuWi19f93D1rE6v+ua0HCY3XdFic+pfDK25Azt3e+2rHpEpK8hWvpfMXPmxRvIUAXsOgQks1SxK8lUUksL2uAaZoxiPdN7CWEwM2JT9eF4btZOQ0Buizmbi7ETHNW1T5GB2k872oNKPMxyl+nybccc3CRAuwx3BjB0QreeHWWYEsYZFBJcTbOnihurCMZ06+JFp93qkHqyeHHhBwvXIpLkCANljZjgvC0KTohezPfP/CVfL40fcrs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 01:42:32PM -0400, Johannes Weiner wrote:
> On Wed, Mar 11, 2026 at 08:00:29PM +0300, Usama Arif wrote:
> > On 11/03/2026 18:43, Johannes Weiner wrote:
> > > @@ -3802,33 +3706,25 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
> > >  	struct folio *new_folio, *next;
> > >  	int old_order = folio_order(folio);
> > >  	int ret = 0;
> > > -	struct deferred_split *ds_queue;
> > > +	struct list_lru_one *l;
> > >  
> > >  	VM_WARN_ON_ONCE(!mapping && end);
> > >  	/* Prevent deferred_split_scan() touching ->_refcount */
> > > -	ds_queue = folio_split_queue_lock(folio);
> > > +	l = list_lru_lock(&deferred_split_lru, folio_nid(folio), folio_memcg(folio));
> > 
> > Hello Johannes!
> > 
> > I think we need folio_memcg() to be under rcu_read_lock()? 
> > folio_memcg() calls obj_cgroup_memcg() which has lockdep_assert_once(rcu_read_lock_held()).
> > 
> > folio_split_queue_lock() wraps split_queue_lock() under rcu_read_lock() so wasnt an issue.
> 
> In this case, the caller has interrupts disabled, which implies an RCU
> read-side critical section.
> 
> That's also why it's using the plain list_lru_lock(), not the irq
> variant. Same for the lruvec lock a few lines down. I followed the
> example of none of that being documented, either ;)
> 
> How do folks feel about a VM_WARN_ON(!irqs_disabled()) at the top?

Okay, lockdep actually does warn. rcu_read_lock_held() is explicit and
not appeased by implicit RCU sections.

Paul pointed me to rcu_read_lock_any_held(), which we could use in
obj_cgroup_memcg() to suppress the splat and permit implicit RCU.

Or we can make rcu_read_lock() explicit in the above code.

Any preferences for how we want to handle this in MM code?

