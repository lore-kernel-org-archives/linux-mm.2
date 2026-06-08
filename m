Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5BA0CD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 20:30:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4DBD6B0005; Mon,  8 Jun 2026 16:30:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E244C6B0088; Mon,  8 Jun 2026 16:30:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3B276B008A; Mon,  8 Jun 2026 16:30:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C680A6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:30:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6BDC71A02DD
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:30:58 +0000 (UTC)
X-FDA: 84857889396.25.BE98A7A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id 051E62000F
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:30:55 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SktIJnXA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf31.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780950656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wraIK7t3kueWFe0dHeV0rjdNvan94EJMyKFrwQ1Qu14=;
	b=lyyHxhjBpuf2XBp4YBISqyy4OQYvjaCQqkoxL8SfyQJBZuREtpByHFH5m76/TnXiIUwM8I
	xOmjrJIgdOG9xE04C2RGIuJOddN46FJWEVKlStu8yM+4feOo0/PLljf7TVaTM6wVqRoQlE
	Q6ZoZlRLNHlD4kqIspCU9+B/jcFrdsI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SktIJnXA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf31.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780950656;
	b=5Do5P4Hysj9u/5s0RmWMHojXBRA8I0S0S4HJT381FnLrqSq2E3o6tfkO4qzYtink57637y
	8BFlNviDXAuDWOrsH+0p/0ZGRQtr+9MQS1ebNQ2C2Q+p3SoJXvCr3/C/Yi13qmkShBAZ2d
	wb9K2HEuUysnA/aXNhj5SIXkzL/4Le0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780950655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wraIK7t3kueWFe0dHeV0rjdNvan94EJMyKFrwQ1Qu14=;
	b=SktIJnXAGog2N5OhR8zAxCEffXYvadFkaR4iE1X7Aye9sEnOJ4n0VIOzc0yfUJ/aeXwTse
	fbUUO3IIcDphP8hWbpFvVwphKcw2dieGZfoy/dExh917R6fugucp3mlNiPzP5lDtVf9Tn1
	2liYCAlGAbzTcC1D4xbI6DFgqWyvoQQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-711-GKCDExJOOuuY9NO2lEcP8A-1; Mon, 08 Jun 2026 16:30:54 -0400
X-MC-Unique: GKCDExJOOuuY9NO2lEcP8A-1
X-Mimecast-MFC-AGG-ID: GKCDExJOOuuY9NO2lEcP8A_1780950653
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-490ae3bcf4cso23269385e9.3
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 13:30:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780950653; x=1781555453;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wraIK7t3kueWFe0dHeV0rjdNvan94EJMyKFrwQ1Qu14=;
        b=l93rio7YEVlwPhO7ynH7LDzj5fWzJEER1X9bE9ZKFpVTGnGL2ZC8JIzVnb/Ajmdean
         hhjw7Xlfyi0PP8sMoCpsAtsDDZP6Ey2Ds5+RKDEiArqotVqcfCV0TiDQBrLXM7ekYsmA
         veXDOw7YOBC8LFzvA1JYogzJTESpjwxoUCbnOkDNMGMXoGJht31sLnuOmB8Y1j7DcfPy
         xOLPt1J3TiW2xAZ8b/lZeZltxabYBdTCJmz0Uik0vfCSx0wMXYZF8hBTIcpdJv+pFWqP
         nesB0O+pQ4hUwYU4semXmo9bDM86aVo3Rob7xdf3AG0YAUwXq7SNqInnudLQncNGqPFq
         +J6A==
X-Forwarded-Encrypted: i=1; AFNElJ+fvOL1M8YUmjnj9fHLB6RLPaSgCHc3nTG2GQkIAhJulo3g4YzjinRJeRuE2eojS0WKORJjA+JSRQ==@kvack.org
X-Gm-Message-State: AOJu0YwCYMHRvdbaDL8OSzeN6V8VbJ3c8X8ryTlaFcut1fsrkAflq/is
	jsgTfz9YwgVEvQC1XlwySYGraLDV35ZP2WC3Dbs24PAH3OG5qAtcDfI8jKGb2wtUiJVcfjptxwr
	a9hscq9700sPSIasYKbnF4/sJCPkZKbQMZmK6pIaOxNMySb9HToxd
X-Gm-Gg: Acq92OFeuvIq1/JZh/jVROcR65XOGwmbNs8PCJcLPDUJ/Rczm9dgW7OHkWa0yZxA1jT
	n3iMvxMUCAllPFHGzOslPPTRihfbl9Q76fLdHrWB8lFR/uoZT3gMAPZUohUnBgkl/TNzumXSW1p
	0FRllEeH8WeFQbZ2keRdlUG7SeS/laSZpioDRteN3VNiSZVEzl/miVOFkZ40EibkNS/Tf6+lL0y
	4TctSkISvycUoBhtP+0iT0VeFgZKxxLiJMeKlAxPsEfZo+C9inp6oZhPvrXiCQBi/k90MehIydJ
	9+vAFiY+Q5+vxY+ySzOSd+P51lEfSK12ecA9YB3MA3Y7pHokHcJj3OgzFD6kN13uk+aR/g0LvqC
	sC0yzRz0N0aCCU7KP+DllctqXLnBly8NhqejKzT3+nGnsrMjIZz2ahA==
X-Received: by 2002:a05:600c:4e55:b0:490:601f:d775 with SMTP id 5b1f17b1804b1-490c259a232mr289729415e9.5.1780950652941;
        Mon, 08 Jun 2026 13:30:52 -0700 (PDT)
X-Received: by 2002:a05:600c:4e55:b0:490:601f:d775 with SMTP id 5b1f17b1804b1-490c259a232mr289729065e9.5.1780950652571;
        Mon, 08 Jun 2026 13:30:52 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f0a43e9sm55339589f8f.0.2026.06.08.13.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 13:30:52 -0700 (PDT)
Date: Mon, 8 Jun 2026 16:30:46 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Price <gourry@gourry.net>
Cc: Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 12/37] mm: use folio_zero_user for user pages in
 post_alloc_hook
Message-ID: <20260608161810-mutt-send-email-mst@kernel.org>
References: <cover.1780906288.git.mst@redhat.com>
 <f92f6f06e5804b4ea7f68b8664b7e69953b50f4e.1780906288.git.mst@redhat.com>
 <aiacZ6_7SG3nvVjM@lucifer>
 <aiblhJv_BvMn_8XY@gourry-fedora-PF4VCD3F>
 <20260608154354-mutt-send-email-mst@kernel.org>
 <aicjNRrHYOOBt0Hx@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <aicjNRrHYOOBt0Hx@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: owzjINy2KomWg_o8VKaiot5oTKhd1cS3hb2ZfziIfPQ_1780950653
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 678c3fi5niqk3zwzk6uqmxkj1eujkhw5
X-Rspamd-Queue-Id: 051E62000F
X-HE-Tag: 1780950655-542345
X-HE-Meta: U2FsdGVkX186mP1lYEuqxdJNv78zAX5JanTW6EimBfy11XHbIRF/A8xJ0PBhPr8/eRhGl3XQyPTpXzhK2Tbfp1D8Z0wkaKTTZZThp6mXdpxZntUhx9S1XMfT/iwXqu+O7LGRT27q1tWOp81D0i1/ZmDU0OJGq6J5fHs9ZANXlhJLraIn49Qq1gFft6+zKq7XOeQXHKOwLgBHPEfs+9eiWMKQF/Pvjzh2xfDzfcY/idYbRh7EJNNNO2t3efAQmF79ncXOe0I5hVGcVtH1PFgpE0Li1GpEBCfr20l/vdc5ZtsCSkS1IfQKqkSHldmsAdEI8hiX7Br213kncHsiUSngUhU4sVuYrnOD5AH1chU/jX9jqn2o5Pk3kHzFLha5IOTs8cn1NJof5M1QMHhjZmMutF53KlbLXvw84taJn7OFEzluGax6MYnXx4NeLNO3XUtht8V4DMRGUgtl6dJjMGQcl1BNEhJee5asALwsbRjj0AG+wJc0dg/7c9KpdOWI9S+wRlqBvuPYYjteZseB8GijqtuCAmlAywjl1rfGb2qo3t/awToEceE31PYyE+0TMd2dYqNMrC6QYxtwsSH0JBdbtUB9V+kyYfPumbAyMZ8JFnwaXeuZcgzBxuyusLjCBa9Q0R1EKjOUYGIwuK8IC/+ABtvsB9uaB9Z35kI/0HAPsLJidkyrhe4XO4iid9kTe8bqy/9CweeKXMmLocEVZT4y7uZYhB1HoW2HFZnITycuQ9Kw9Avx+DD8p89/ik994y9FS/pkVqcDvjgzc3Lslrsk7w0cWb3ql6mwQcYzc+/CR8QnFlLBRoXv87vlnumQfxdZVEGj8ERbP1z3j8RTpCJLlXJy4iRamWm8hZZAwpgnziGDZ5SSApqB08jY3B1B6pnk4vz7RIQMJwpdoyQ2xXFeoulH+BFC3M/hA5sFdgLav01U05kb48aYSDfXk8WqBZmI/JXddmit5UeORlRqQDc
 vMF5y3MN
 hb02C21A2vSAXYuBDJn6jwcoZ36rABlNa3vhO6mze7fA3oB7TJFQYFHdNGzHBBFntbhplSWIkOorNwqhzTlDRrdTWZH/zn9MEgmq90DylY+NupiJ98IV0jmRhVpyZ5hSRzVW2N+T6bbupvBYNxIgCaGjaNL1g5jMlnQUdAZfynDwl1MSsfgZlPQQ82NIQe8nMkIoUXkvFsT6H/eImSqPNFkEk2vaTUddc8OMQ/bDiwRGpDxbz7CkhFTvbORcosu3ByjUFiQJiHWwwpSNnRWikiIuDAJhvvZo1P6JTJYeF5flnWK13fVO+pvl0Y+GmtMlc8jFKZZaBA0a7H1xccAFOOTlHipx4kCfzDau5tFidf4PissB1UMSzoFoV5Hvj9pAK2KownOXi3Gt7kulqMHeC3vq9nqytCi9H/CWe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:16:53PM -0400, Gregory Price wrote:
> On Mon, Jun 08, 2026 at 03:45:58PM -0400, Michael S. Tsirkin wrote:
> > On Mon, Jun 08, 2026 at 11:53:40AM -0400, Gregory Price wrote:
> > > 
> > > If `user_addr` is now implying anything other than exactly: "This needs
> > > to be zeroed / caches flushed", then this is bad.
> > > 
> > > ~Gregory
> > 
> > Well if you do folio_zero_user in a non sleepable context then things
> > are not going to work. So combining e.g. GFP_ATOMIC and GFP_ZERO and
> > user_addr all together is not a good idea.
> >
> 
> Can you say whether (GFP_ATOMIC | GFP_ZERO) w/o user_addr has the same
> issue?

I don't think it is because it does not call folio_zero_user, right?

>  If not, then this subtle complexity is now a tripping hazard.

Yes.

> Is there some combination of arguments here that should just outright
> fail if a user attempts it?

__GFP_DIRECT_RECLAIM at least.

> >
> > You are saying it's bad? It's pretty fundamental to the idea of moving
> > zeroing into the allocator, I feel.
> > 
> 
> I'm saying having to infer that safety state from the cobbling of those
> things together is not a good pattern (at least as-is).

Understood. Don't have a better idea, yet.

> If the introduction of user_addr into the mix is the thing that causes
> us to have to infer safety, then there's an argument the page allocator
> shouldn't handle that operation (in this case: user_addr cache flush).

It's not just the flush, we are also trying to use that to optimize
zeroing.

> 
> Please consider that this is arguably the most fundamental interface in
> in all of mm/.  All we're doing is going through the process of figuring
> out what changes here are reasonable while trying to meet your goal.
> 
> ~Gregory

I don't mind discarding all of this and doing something else completely,
but I dislike it that multiple people are apparently now angry that I
don't address all the contradictory comments at the same time.
I thought just sending a patchset to show how the result looks like
is easier than arguing about architecture, and would be helpful.

I'm not pushing any of the mm rework, I was asked to do it,
myself I just want the ridiculously effective optimization in there.


-- 
MST


