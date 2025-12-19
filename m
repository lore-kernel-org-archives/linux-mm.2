Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67FADD74951
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 03:54:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DDFB6B0088; Thu, 18 Dec 2025 22:54:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48C306B0089; Thu, 18 Dec 2025 22:54:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36DD06B008A; Thu, 18 Dec 2025 22:54:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 23EC56B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 22:54:01 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 759E0C050D
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:54:00 +0000 (UTC)
X-FDA: 84234852240.17.4387C61
Received: from mail-qv1-f65.google.com (mail-qv1-f65.google.com [209.85.219.65])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4A9BA20002
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:53:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=nD3atH0u;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf03.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.65 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766116438; a=rsa-sha256;
	cv=none;
	b=aCperfcs5QVd5ctTsLQQ6gck7FZ8//xI0p32RtIK7xRD9eGQHMjmd9x+yLvm5yAgtQKn7O
	ht009pciAwFvtXqO1MCSCZjwigM/jlqHdoaNUh9tDDwSUJVWSEIuRVJGyBVjPECa9vn9Zc
	6C9x1Q2LYWHewMM2jSsHTPmurIF8IOI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=nD3atH0u;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf03.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.65 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766116438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wO8ZD48aUCpKc6SiZGez/drh8VR8QFTGkKklbJiyBj4=;
	b=CeGwwwtgxCYThw95iqREXr6GjxrExHndWPDrUf++rTaw0GV0rrt/tqo0MSzFZyZoUhEHvw
	JoIJJDs7OIJ2OwOP3fAMOIgShoCmLJ8WuoYo6kQhT7ALw3yzLAfPhj3aVHEoc33IPY5DEO
	nVNjnxAx+64WAVxhNY7F7oUcY+dR+DA=
Received: by mail-qv1-f65.google.com with SMTP id 6a1803df08f44-88a379ca088so14141166d6.0
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 19:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1766116437; x=1766721237; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wO8ZD48aUCpKc6SiZGez/drh8VR8QFTGkKklbJiyBj4=;
        b=nD3atH0upfyKhTARBUldqKAhnMcK+FqkgiH3oPWwQCcNp/oRfQ9uhpNJQjV68d/CqB
         i5wxvFi2SLQxa6GJGdTTEykODmtd5o902gZyQCkZUwHG59DXuUgu/CXZkAfxWfr/7XD5
         E9/EdCd9vLoMxWvOCP+PDNeNo2sLKahu5JfpHH57RDVr4ILFevYoCn+zT3lMw0qCdayv
         0260U2LU63gLChNab8VVjtj1nbDUr5VZPI/f0P5TV9jqOVU9W9y9LemEtlgvazy6XSqO
         cOe1pBzz0BB9YlmB56Du2citpCuaMVlSZQoS3jIl/OISE3PyA70nSn6mUu0iDZmP5c/F
         7LSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766116437; x=1766721237;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wO8ZD48aUCpKc6SiZGez/drh8VR8QFTGkKklbJiyBj4=;
        b=HQ+Mqh6z3o2dhlATzCFQqalNzrmqvfOCHY6Y96QtiBe903pQc2inZygkD4vVGrZMjg
         x2HSeWzxNS8BJjVoLzWKX0uoPkKB4OPcDkaydQps0rR1a1MdnMmuGqgj7WeORwSjS4FQ
         HzsQ2QPPlpKaYHLLtiPB97GL/y9D4M3KYqkMh3Lxq6svXyoCeuPBqxclEm2iV2vg95s9
         7tqCjm1kq97GItr62aV8EDbYQfAUwTbPpra2Msv2o6ZNLskfs22t5ey17W9OF1HK1hsW
         EcZ0+8SsCVnWTazTe+eRO4I+2mJFS0gdztmD1Khfq/PX0Mkqr9vePi5HbxekkTEy2MiV
         IvgA==
X-Forwarded-Encrypted: i=1; AJvYcCWvfRLDYLhU9ZAILCCF5LKIPV5/R+zBWbFkTdqOYzD+2H3WYdfrrk1PfSiQ+D7rnscJkoy8srq0Kw==@kvack.org
X-Gm-Message-State: AOJu0YxPA7KjYZw9V6hemRtAxuE52Imt6/hjlDK9sE6UR8eDKtniwC+P
	9e+2HLkFaUf07Br5GruJJl8zo9fCVb+2lwijqgWHaSsdD2Q7JVMytVp/1cc1LuPrH3Y=
X-Gm-Gg: AY/fxX4xixTl6FUp+bebfT4RgoolkBb40mKfSDKZiokvX0XNxrdceLOdDaApUEop2pj
	dQZhU34zVB/xaGPM88KeSf10gzRk8FqhTOM2kDoXwe4ZhiHmbQo//411BGdi9kijI+cZWKbGM6m
	CC6i1RilJZs8woZ7Hrz1BQokrfF2JqdOyg02PnT+O+FA8JbmbjaoqDV/R5Mho3x86OJINweSD4I
	pWTl46rkzRTesbqUu7lh/Pvuxo4jCVfGilBRZcIawvNXL31bdEwS53J84TbKXGy3VnEeJzs9wvP
	v29kmrtmu/n84QE0glRphqVYB5IvfPMVrZyUnbDunuABk9TjbBTIqrTOBIsjRwBvHCcHdtyVD4o
	TFf9pB9zpXRYGrgygbz3zUbjWWMohty/PjP1aaHq2O6rPDCvW9hIa5YypyRP4w8HBblnIeVd/AB
	/jbIpNvXsfpQ==
X-Google-Smtp-Source: AGHT+IGuYY97o/y/ARn4XW14juzlOImdtCYWCwBKScTq7uY6qi729cqFufMxSnRLQQHTYA8ofovkJA==
X-Received: by 2002:a0c:f40f:0:b0:87f:b2d8:6020 with SMTP id 6a1803df08f44-88d86290cffmr27126906d6.38.1766116437011;
        Thu, 18 Dec 2025 19:53:57 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88d9623ffd2sm10768806d6.9.2025.12.18.19.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 19:53:56 -0800 (PST)
Date: Thu, 18 Dec 2025 22:53:52 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>, hughd@google.com, mhocko@suse.com,
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 08/28] mm: memcontrol: prevent memory cgroup release
 in get_mem_cgroup_from_folio()
Message-ID: <aUTMUKEkGu7cEgb2@cmpxchg.org>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <29e5c116de15e55be082a544e3f24d8ddb6b3476.1765956025.git.zhengqi.arch@bytedance.com>
 <aUMkYlK1KhtD5ky6@cmpxchg.org>
 <ot5kji77yk6sqsjhe3fm4hufryovs7in4bivwu6xplqc4btar3@ngl5r7clogkr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ot5kji77yk6sqsjhe3fm4hufryovs7in4bivwu6xplqc4btar3@ngl5r7clogkr>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4A9BA20002
X-Stat-Signature: 4f549z6amezu1pt5bzbjewsqqtwrxdcn
X-Rspam-User: 
X-HE-Tag: 1766116438-182393
X-HE-Meta: U2FsdGVkX18exi+crt4h+Mygzvt7LupYdj3glUrco8hzMD4mhMMOlm9cobg8YmEr3T2SuCV+nGSowPjaNDy8bRMfQwxV+pTrQTuQ3yumK/3F8L8F7BPnPVFF8kXP5WBKj3ZNr/qI4fJUwmgoe+Oczoc0KKpWrIr6ruqIOs6ZNCXLUEWI9KFaXnFVHf+pKV7CcCBD/1AWx+KD+rpQoyC+Oe1hUDaYW01d3mER/8Qs9MZ+Zsv0mrdQHfBr1GRYgrsKpjSkHwEn6xQb1M0MZ12n791dCdOU1dgp0i/nbJkgUNP0e45rt8XPW8tNaSjSh8odnmQtwLr8k8Uown9cdiUBjgXYnjLXzx+Zmt9mBhYTH3btzA8+Uom7i929comw8vLHA3OPrzUWDgQO+KMuUasF5fzzdJGEPTRBt1jCscGzu6uLPervrX+nbqaAvFVFmIaJLCSXNwCt0qQNn4uscQLhau5pfSdPyh4KQkeYqj41xMkijgPDzcEgcD/M/4k/EBnCm11KNfARhKGk7yP4i5RsHiqKgdEzwhPsuO0Tm7SpRRpAnYLgMyjOla/r6pBzUdb+lFqBPGY3R17rRzT05jkuOfg28i2pGKrWU+vpYfDbri22EVn4O7NwHfGq+t47Ezyv1jftRdIqIT5GlkuYR+inJjKsZwS+p28mXgYG4WRiwF9jpqLWaPFNsVR6tQz8Co391RcJb0rNDVbDPlCbHBw3JQRoBWxMHBT8CMqaWLWdpfo4M4CHb6xL85kcOhKGdP6o9T/aq/Q/sMW5NHZNenae21KziIq2ioPg8q3sekjcuIkZznX1US/I48MgJ9BztndRYEd6ZfwI7ukNvqNbicpuSXFqX/YvfN0sd174rzIrz0KghgdHy2/0da+t/W1rGWeytDxLtFi6ar+CdVblzu2ypHphGBwILdTdQsSf+K2fFVa6hbONyu0nDspDCek/dAYOCouP1WzE5JsHJhKp08t
 LiSfgCMO
 TGK5ow9PyKlI1LwUwdGF3dmsj8BIcqfY8fLbRNdWW/pJVIZkFFv8lmDB9gP1m0WFQ4VkdJ3o7bdgT/P2GC1TeJJSaYyf81eLFlID+WBU5A3bkeFG0p1oQ7pV5JPsWpMe5vxIggBEtwLlsyjxpaWFNjAiAfLE///3cclIfzUhtwzYzE1h/z6Mbbv21A5Eup072Rjn0Z5ZExK51Xf0l2IsJtrezseB8X8s/9L9cAeoxqBXWGXr5QlrKN4GHgq2H7LwBIVxMtI0RDsT4N3SmjyDi2hEO26dvc97+HC84GfAluI7ebJyHRnq/HtfsMJwkFwZoOjb1xExr8VCCOGu4sRT/SKh18Nc0NQcZzDUlX+OmDLTG7NXEf5ZGMfLFWmIWPXiHsYDnRn00+LYzJn7OaZWsf2aYjbi0PIc/6a+m+3grZvjpaAYwXr7WPJkjAN8VVvhpO81FgLnlkWZ8bqSPkmdd3/+bWZGodIduwGyPX/aPpjllcBU0uhqMF5PbGQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 06:09:50PM -0800, Shakeel Butt wrote:
> On Wed, Dec 17, 2025 at 04:45:06PM -0500, Johannes Weiner wrote:
> > On Wed, Dec 17, 2025 at 03:27:32PM +0800, Qi Zheng wrote:
> > > From: Muchun Song <songmuchun@bytedance.com>
> > > 
> > > In the near future, a folio will no longer pin its corresponding
> > > memory cgroup. To ensure safety, it will only be appropriate to
> > > hold the rcu read lock or acquire a reference to the memory cgroup
> > > returned by folio_memcg(), thereby preventing it from being released.
> > > 
> > > In the current patch, the rcu read lock is employed to safeguard
> > > against the release of the memory cgroup in get_mem_cgroup_from_folio().
> > > 
> > > This serves as a preparatory measure for the reparenting of the
> > > LRU pages.
> > > 
> > > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > > Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> > > Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> > > ---
> > >  mm/memcontrol.c | 11 ++++++++---
> > >  1 file changed, 8 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index 21b5aad34cae7..431b3154c70c5 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -973,14 +973,19 @@ struct mem_cgroup *get_mem_cgroup_from_current(void)
> > >   */
> > >  struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio)
> > >  {
> > > -	struct mem_cgroup *memcg = folio_memcg(folio);
> > > +	struct mem_cgroup *memcg;
> > >  
> > >  	if (mem_cgroup_disabled())
> > >  		return NULL;
> > >  
> > > +	if (!folio_memcg_charged(folio))
> > > +		return root_mem_cgroup;
> > > +
> > >  	rcu_read_lock();
> > > -	if (!memcg || WARN_ON_ONCE(!css_tryget(&memcg->css)))
> > > -		memcg = root_mem_cgroup;
> > > +retry:
> > > +	memcg = folio_memcg(folio);
> > > +	if (unlikely(!css_tryget(&memcg->css)))
> > > +		goto retry;
> > 
> > So starting in patch 27, the tryget can fail if the memcg is offlined,
> 
> offlined or on its way to free? It is css_tryget() without online.

Sorry, I did mean freeing.

But in the new scheme, they will happen much closer together than
before, since charges don't hold a reference to the css anymore.

So when css_killed_work_fn() does

		offline_css(css);
		css_put(css);

on rmdir, that's now the css_put() we expect to drop the refcount to 0
even with folios in circulation.

The race is then:

	get_mem_cgroup_from_folio()	cgroup_rmdir()
	  memcg = folio_memcg(folio);
            folio->objcg->memcg
					  offline_css()
                                            reparent_objcgs()
					      objcg->memcg = objcg->memcg->parent
					  css_put() -> 0
	  !css_tryget(&memcg->css)

and the retry ensures we'll look up objcg->memcg again and find the
live parent and new owner of the folio.

