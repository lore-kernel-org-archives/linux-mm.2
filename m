Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEF96C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 18:49:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBFCE6B0098; Fri, 18 Sep 2026 14:49:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B97C66B0099; Fri, 18 Sep 2026 14:49:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAD446B009B; Fri, 18 Sep 2026 14:49:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7E3B66B0098
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:49:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 25CCB1C2EE1
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 18:49:53 +0000 (UTC)
X-FDA: 85227772266.03.8204BF1
Received: from mail-oi2-f13.google.com (mail-oi2-f13.google.com [74.125.231.205])
	by imf03.hostedemail.com (Postfix) with ESMTP id 51ABF20002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 18:49:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nyfgJxyU;
	spf=pass (imf03.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.205 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789757391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Ph6ZaVxaO7CXgv08gaPlk+fBtFgV6Zs+sxg/G7AO88=;
	b=R8/xyeh+0XUyC53qFRf+BuZl7L0QiITNOUhGw94CxmrNr1YNt/rF4/iyviFirNB6bFByXw
	zjHBItEV38dVfu7hC63W8GcyEiXa/BRuOzD2WkfqGYJxS4p9jJEIBvoVO14sxEocJ5FP+F
	J044kphZsSgR8+FIPpUHzkuChGLgm5U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nyfgJxyU;
	spf=pass (imf03.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.205 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789757391;
	b=wpVrXqmco852ySqH956BBfAHUY95F/3ZYn5ae8us1OpSLiojw6Y0fE15giM+9Ea69sEFhA
	MtJ9DieqfXDF4S5jTrBkXVDq9Rvr+qM01IkcjGFSCtgQYcdwjGMbuvauCtHcaFFRJeJS0+
	TYFrvDYrGO9jCXQixuvNSl6FUv48kZk=
Received: by mail-oi2-f13.google.com with SMTP id 5614622812f47-4b37a2ffef2so551128b6e.3
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789757390; x=1790362190; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/Ph6ZaVxaO7CXgv08gaPlk+fBtFgV6Zs+sxg/G7AO88=;
        b=nyfgJxyUC8MyXZ4iC/tT8unH2v1aq09eYIRz8GRNbZrYkUNrDpOUTZIrr1ZR3IhCUc
         74vh8tYUMTQ97PGSGd+UsQndI+OGvHVnwDtGbu8u/lLmba0t1AQvB5W0cyn2zrRb+a/2
         q4y3WzVjN0kh4LJl8KF0HR/sXlGQ/S35WtEEsrNUEoRG8T87q8M+29gF4Hyg5W/qAJlY
         3v/+7ZSHy3t/8ehVyMSf42ZqpEzHosaA+ba6Q9Ijva/lMfbMzuAXdIhjnYhDEqZaLFp6
         PCkM8XkrsREe+KJQy39k65+rxydGMCt1lmjOs+82PtYAVb6K0InsJJY3SbyQ6KMtdEts
         QJPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789757390; x=1790362190;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/Ph6ZaVxaO7CXgv08gaPlk+fBtFgV6Zs+sxg/G7AO88=;
        b=wIHMSmxmfUDlaF/cx4mnAcsFzsandMxM1NhxNMSVk/SALgdsDZtRz55EXiVIj6H2mb
         G2KogIztobXnmKTNoncHFB1BbkzgxsWw0qneQ9xqgNU+wNnXzmRdbjJ5lvilVlsU/YnY
         bd10fStASBW7TbXPH1kbc6wFd8NIGFX0+duyFijmGiw0yJX3V1zzbDKMkicLgZ7UiR6m
         3b4DN3kvDWVVHjZoZrVcfANlsDC4Vv5pG0gIMIZ4Do9OHEfHFncVA4EnbFOWb5XT65kI
         FOE40myNaDNa9UbqhFyKsuVXgqeUKtnDRkxAyMiGBxScsAl8bJRZuCEZwlBZ/t/Wl2Tl
         jGIg==
X-Forwarded-Encrypted: i=1; AKwUvByoSwiQrq2Nv1fbyuCmYdrM/ykV1M81ww913SApx6wAyO3ifGQxKOr1asyf8fejxmcgFz4DdNJr/w==@kvack.org
X-Gm-Message-State: AFuF++l6Dc6J/Y4EmWpCFUsDht43NYdraC30a+cPEzQLlGvgeuZlqXL0
	2JJqwrWNaf3hOLFeEjSg4GBuuwBrKWm3ZhgZ/n+cFY7CK+jtpQnCrvNo
X-Gm-Gg: AYBFou1I3FVEcOFUhc2J2gT8ctZRHFZfmDni+FRchCRY6jJjnmZYaDK808Sm/uc0MJZ
	pnkrI9xL8KmbT8XGuTSJwrzx9hmBilotWqdHyXpQulSdr8jQEQxg3Lb8TxZatqiTuBR69lvTrL/
	NlMMMwtQiuP01V8i+mvGSl+G7R9wDyqb5mVASlF+QMLJ6ZaDF8O3PBJl93TVvryuPL37seoVpCA
	Ov3bDNfwKC7Hp95nMSe3Fe/qT8rMPBxcRa4al5kYiM329dEuiix0Fhhs2EF3FzkVdkzLLmHvWeE
	bvh8CU/H9SqYrScGocGgXbUgh+hfNEodmAolvtp0uEe9zA/tEUuAtDk/LLeGdQ9z5CWlIAoVLMz
	5Vlok6PNBuYgHV+DVnGlxl1wX4NJvZVgMv3Fzyxg0ZyFGEoLD7pS15tax/Kwq4ZNh9JmON0VpWA
	CwJF1yqH+qMou71StHPTBKVDX3QwptzYQWUa7FMHmSnmEc4iQ13h7VdVi77RxKH02dfv/Rr0uiw
	jAy5HgryZt7DSS3h1GX8xw6TFK49Q==
X-Received: by 2002:a05:6808:13cd:b0:4c1:83fb:8c7b with SMTP id 5614622812f47-4ccf6f9803amr3772164b6e.12.1789757390210;
        Fri, 18 Sep 2026 11:49:50 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:17::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4cf3f77781csm69823b6e.18.2026.09.18.11.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 11:49:49 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v6 0/5] mm/page_counter: move stock from mem_cgroup to page_counter
Date: Fri, 18 Sep 2026 11:49:45 -0700
Message-ID: <20260918184947.3681164-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aqzulM8S63363Tr1@localhost.localdomain>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 51ABF20002
X-Stat-Signature: z6nx7e6tpz5o8fqmp9bf6gnrxukokit1
X-Rspam-User: 
X-HE-Tag: 1789757391-885976
X-HE-Meta: U2FsdGVkX1/C08ZYFAeM82mRkVzxYSx/ezVKl2otNMrBnu+uHa8AeLLvFEyVIwlinwTsmxMoqp4qR3hjn1rr3TFxrToISgJoIDyVPwqJKrlZy23R/oW/ZdcyO54ryXqHKeHxfSetCPPe/y8Z8d9+RoPHuwvyhs3qwCmJf2Qag6P+I3SuW33Ji6o1U/wdZJdfCqp6bM0TYTu5O8bqkSCwQCwqht8tEI/ruTYjUP5C5TCr/UNdAVr6d67KoRqWkbMmsCsHn4STy3FY0CClgHUxbcRLdrCzkOGjG176nS1Nr8Z6ZTkOTn75SowS39IxKF6x2csjzU4MWMYVs5/xKXCTwc5DQdy0/5Q7lK9FK5s7/ghY55B1k1U9WGHXpgT5rr8Sazg5skX7Q87SQ5VyhMKEe4N1r3nAhoMksnnNtt3Y5a5VTkZ+iz6JWbKPlsMywWREvt8gISS0CzfcPXuigm/2H5+vpbD9upCsfpk9KfWnEP4gcQmMpVdy64SP+ZU3V4Q6WaLGTFtRQ3VIxM+tptCcI5NIjtVx7QMguepOpKR2nGxx34/1mF+woCOby82e68kpIz6pmvvsMlG7Yd6G+6OHmYVkJoWGBkZQfnpuDuJFD46b7BGza5GKktArXi2F3w3qPW3V+7p5s7bTss5lNCo9Jy1WliBiMLWoHoAp2FzP4qjMNetOhBnc5JB8/NZFDj06Tt2Wa7JAk5JkH8fhlRwfEdqWtQQMNiJmuXo4jx5k+oUvflA6fLAEdcD5UW5vJWBwiAJq4a5fsL4ipRfulYbq3QAy/tVVPFP1zdPnwhUGLRwFfIUEOGlc+5nsh/+iZBd/LhCCxmFidYMhez6sAjKDlVyW5dYQeAPNAEWTjz6W3kx0iW2A5k1C9UP98wiqouJk1J8joyqGrZCib4ZnqgRfu42atWGoyyQ39s8T8f+GU1KFs1BaAhavmOtvZIZTRuVxNQwRJqlyP5Rb/Iz9S3b
 8EfhQeYJ
 eheYMuEu9bEtNyk4J3UshAO9rKuZB2LRTBoLTwQz5q+R/7JHGW8F401r20FmOpWRSNg5ilyJZIbRWDxgFgnzRPSCVelJnmoRZLunvPZMcqvhbL6bRlXRcd7CcPlBc3oPkhrKz6V8sluSLsMhHpLs3c73GJ85XWD4OPeaFNw+OfZpXYJ3AcRVvUd5biTYq3CZHTqiKUX0+Ba2dLXpdwoOImktqfWCotbz0CUfNFBA3npasqaIa+0fwMijJPgMQWZsdwun5dZdyhZx6uBMCbwJG8oiQ1GTzcvPqvMj4Gw/hkkK7RJFmHT+jKSjgfkxdQPZxNYm7PdfA+z8NU9NluWGIusGeM7LqxIZcfw/Z8tQZnY+xQQfhjxRj3BgKRSztFQZIsDdthe6nG+2zr2jEuA18MpI0zmS+Vi6NrHSNUDf+qdogEjbE7eXsko5oXrotQv36ZssS2QecYPpxNaWEXiH8wP8V5xPHF0OJFEOvE3QammP5Oge3NhhojXPzW9zngN95Gsf4xK/qEW1mG/Qq3HZIHi0xof4IAtuZUgKY0wknUQ/6KS+Jg260vL6prfSoaAM/QUUD0fb4Xt7qzLiUT7X6EdpeHRUf0xtMdIdmshIZNqgzaD7rBIimaVKAtfbEAIE/1dRF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 18 Sep 2026 09:58:17 +0200 Michal Koutný <mkoutny@suse.com> wrote:

> Hi.
> 
> On Thu, Sep 17, 2026 at 10:57:00AM -0700, Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> > 
> > This is true, but this is already the behavior for vanilla memcg.
> > In this series I'm hoping to preserve all existing semantics without
> > changing behaviors, so I can fix this problem in a separate issue.
> > 
> > Specifically, in vanilla try_charge_memcg:
> > 
> > done_restock:
> > 	if (batch > nr_pages)
> > 		refill_stock(memcg, batch - nr_pages);
> > 
> > ...
> > 			current->memcg_nr_pages_over_high += batch;
> > 
> > So I've just preserved the exact semantics that we used to have before.
> 
> Kudos to you for the conservative approach.

Hi Michal, thanks for your kind words : -)

> > 
> > The problem isn't that big anyways though, it's a transient inflation
> > in memcg_over_high and will be wiped on the next high handling run,
> > and there is no effect on accounting or permanent inflations.
> 
> It reminds me [1] where stockage imprecision could even trigger OOM but
> it was reportedly only visible in LTP.

So I was thinking about this part quite a bit in the older versions of
this series where I changed the draining from being async to sync.

If I understand the issue you saw in LTP correctly, it's not one of
actual memory OOMs but that there was stock that the memcg could use,
just not in the current CPU that was trying to fulfill the charge,
and also the draining for the remote CPUs did not happen in the time
that it took to run through 16 retry attempts.

IOW seems to me we are synchronously waiting for asynchronous drains.

To me this did sound a little bit unfortunate since there really is
memory that the memcg could have used, just cached in the "wrong"
place (and for some reason that CPU is too busy to do the drain).
One of the versions that I worked on previously (v4, [2]) used an atomic
for the stock so that we just always do a synchronous drain via
cmpxchg and we wouldn't have the problem above.

Obviously there are pros and cons. Synchronous means the reclaim path
has the ability to reclaim more memory NOW and prevent futile reclaim
retries, but also it makes each flushing operation more expensive as
the cmpxchg operation is more expensive than acquiring a local trylock,
even if it succeeds on the first try. 

In my opinion just doing the synchronous reclamation makes a bit more
sense to me since it gives a stronger guarantee that we are going to
get the charges we need to fulfill the charge attempt NOW rather than
spinning until some remote CPU gets scheduled to perform a local flush.

But this is just personal taste, I haven't really seen too much 
evidence that we are wasting too much time on the reclaims. So maybe
asynchronous drains are OK here. I can do some more digging in our
production data to see if we're ever just waiting for remote drains
to finish.

Anyways, I still intend on separating out the two efforts so that this
one is just a simple code move (and make stock more scalable) for
cgroup v2 users (and I hope not-so-big impact for cgroup v1 users)
and I can work on removing the 7-slot limit and improving the draining
as a follow-up work.

> HTH,
> Michal

Thanks for your thoughts Michal. Have a great day!
Joshua

> [1] https://lore.kernel.org/all/20250530151858.672391-1-mkoutny@suse.com/
[2] https://lore.kernel.org/all/20260623180124.868655-2-joshua.hahnjy@gmail.com/

