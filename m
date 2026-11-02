Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46AD8608A347
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 16:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GXA+L2KR
Received: by kanga.kvack.org (Postfix)
	id 31FBB6B05B6; Mon,  2 Nov 2026 11:30:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F8CB6B05B7; Mon,  2 Nov 2026 11:30:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20C4C6B05B8; Mon,  2 Nov 2026 11:30:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCB346B05B6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:30:20 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 632ED80191
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 16:30:20 +0000 (UTC)
X-FDA: 85390716600.06.F0E6973
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2E153A000D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 16:30:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=GXA+L2KR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793637018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iNKubM0bQBA+ECydhGutl5fpgFXycwBIVGn2oasC3ms=;
	b=uwXL6oULxix2xxNrrP7xGF45ybtBKEQ+/CPLftymZYkGKASVIkDu/U+nPVOwnKog3TlqOz
	FZkVYZR6MZxPrSrAbAagmt5AQMvrLvvS6g9Zgg3UISwFpnsJHUr5bO4zumi5O406KvpbM6
	P8UCNU7ndydB/Ag3VAM83LK9zcwEvqM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=GXA+L2KR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793637018;
	b=rn38PzOrRaXS5ote9Ogw4V6RZ9zYQIoqRtSgAxyqiqfsDM8m6IEdwhVmHrwigmYAtUuXxb
	yjjxYCjiZyswaUqRKH/+EIbCggWeDMWreZn+1g83ppVf85NagMwXmavJ2A/yfgVbDKmzzb
	sa3UzQbj62QecUGM0OFeYHMAkTozKc8=
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-8b0e21048f8so26314557b3.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 08:30:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793637017; x=1794241817; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iNKubM0bQBA+ECydhGutl5fpgFXycwBIVGn2oasC3ms=;
        b=GXA+L2KRAXbsuPSB+bv55q7njXHLfnLPnzqSaPmcUPHP61R6QDrHOKhzoEU7kLD1n8
         pVUpa/9+vUGWNWJlbBkQW9t+pX4bCXmgK2iODZObfbwVGppBzcD4H+fZmwqk9FVKrQDD
         cqxYC1O3yEOq+mP/N2qmumHen7cYAHLzZV6ybvUnDNE+n+5Zmvo1MDIEKffSukWbGJXL
         JtApYow/T7AWfHDLXCNF8M0uZ+g2nksUiMeht7oYhkrPuxfw5lKdjMtL/QovXZ0heN8Z
         WQPSxfPUzmy9t0Yra+kS7B2xf+sjKAmPkQVoTyG5QDDPy5m9hyeQLh7ykNDcT3u6EIYp
         c29g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793637017; x=1794241817;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iNKubM0bQBA+ECydhGutl5fpgFXycwBIVGn2oasC3ms=;
        b=RDezflXQrZ3w0GnL7Wkf5xZPdA5ULgk9y77Hw9+IwVv2/SQgSGQpi8Vf6s3P28dlPh
         esrZHDyRxCi1NcmSno7Bko/8nDxW8ahD1pTYXmePy5VUQak4O9FkUFCxflsymctMpdSA
         EKrDQvgyVkyLLZXyW1aIJnzJHJIO7lLtL+MTOHEpX8bgOXnZcRnb+StYZx+beW8BUm5I
         fzlJ0T1xTYcJgUhq6+R2m1UsduexHhCPkO3HNuIxni0ngr4D4UDytD5RXCgoL70Dge5J
         ey0T+/mJhZExqYkQf9fL9YTVoNj5ubAgpQ4xWTplrbA9ICd4n2TEYiInCP7idUVJ8+3e
         g3qg==
X-Forwarded-Encrypted: i=1; AKwUvBy4Y72ISIGa8+moTGugU5sX4Mkqjs0WwArjzlNfRQRLXFM8Ce9rz6rrwtob4XDOWU6voja0DMgETQ==@kvack.org
X-Gm-Message-State: APuU4Z8A+AW+ThWmWgRCz+V47pA06igf54BLtAMrSHHZIJennNh8ZsXT
	JTQJR36d1ozDUdoj08w4OuCIFnDs3jgVsysaWV1Qq6BIgaziO3K6cMQ3
X-Gm-Gg: AYBFou2GpgYHdiq51lP53OgLOf1xPUqWYD82Dlce853y1IEZNnoSTWuOwC6lDvbD0Oh
	Ed0w2Zho7Kuh3INN56ij/NNp1gJ+x4EGzf9V5wbfTzeLChUwOF8SHGCuCvDOz3RXHoIITbhTGDX
	ryGEzaqyxv57bWRK8sFudwrko0UZAcbtE160Sg255mGwLaRrBicDvSJo8yIdICClvBHOaVIWmR1
	T/mhcC/+h6F4eHXz7to9AZrxgs5kwPX4FpLGN5DikZBwmfvAeReu1aM3q3CScsiQxGs16mEBrXF
	161ccuKMxui/6S/ftTJfuwINDZ9CvbH6J451VZkBi84Rv7lRQMQAT4BDyQrTfip+YZ654B0sNtO
	3BaJ9CLKBqCgIYgoyCduWk1v24jqv3aZaE3CsdpT0iNdA5FQILAF/KDUkjlqVrSvbAalmkj2pH2
	z6PSLsNdYEwSQwBb/Hkn2QH4ck8G/n5CHcN4u6UfOJq8P5z1wWZnbrhteBMfkg4qbX01KGRsBn5
	Xml9Ekjrs3VmLpc7hoJSbZbfy0xL0Em2KbOprCYQJnDZuZ0JGhBTwUAaTFMxY7lFi+0eRMQbAzl
	com0bBuCQSGK4B5TSh5c1W0xPH0ujLJrnMcRckS9rrPqc1j3v5KAoDJlylX4
X-Received: by 2002:a05:690c:9216:b0:8b0:f1c0:60c8 with SMTP id 00721157ae682-8b2b67112bfmr61784587b3.22.1793637016851;
        Mon, 02 Nov 2026 08:30:16 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:11::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b2b7165e59sm55425717b3.31.2026.11.02.08.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 08:30:16 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
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
	Michal Koutny <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v7 0/5] mm/page_counter: move stock from mem_cgroup to page_counter
Date: Mon,  2 Nov 2026 08:30:14 -0800
Message-ID: <20261102163014.237806-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aui3TJqadHUv-4RW@tiehlicka>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2E153A000D
X-Stat-Signature: bmstmtupgq73jowt64ro4t7qm3cyz5mb
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793637018-162807
X-HE-Meta: U2FsdGVkX19JsNNninVH0b7+40SaNF0cObTzR4WUkpJrSeBJ6lCPdEVQghWhg9CC7h313g8TC8nBmWafdQSxptT6ivT6OJII5uF66nYoQDGEIyJMRxg12yG2YxSwk2b/xGL7kpMW9xuUurLu8JoOm7mcPH0tDkiYllvsavVSsGRwKOfsr0mK47lhOYWzwmtzaCyUp1Gg1LJhdjuXSCtNLINizcjS3dWeXFg5mmFiCpWoAusdbwz/EUqVb7olPn6zhZ8zc27X/KoGjdNv0t67VbXwqtikaGSwSfP4jI470qPduXyo5GBXE316vSg2lnm9KVSqPMNTzXifdZk1y2FWNXNc3XLHbYkzW+mEJMYpe93OvcmReXF8oVvHpzpIKPl//YhuMNwRerOMONqsyHfdiz1+QI+i04XQNCVLLFSTdmYWdRaVdrCiBaZnSaKQcWLJAWkix7Vq5Ci429YizLzETf4DckA3U5JpQGM429jlWoYdC1eKX5RifN2Vst39xVrL+jHW3Hpl30wAsnPjQdl88SFfgoETNCEMwb7UrKvSYDMg5QzuAw88NnJ3r3vXStU3K/Zv/IcoypE86FJELee4oa6US8Ws6/sLDu689g1AQXSJpEbSdW6gBD5j+5/H8mN3okauNuxqNKfC6KVW8K2+q1Q6lrsHLdlROVjbVoApVKDMZNAb0Dn5QJyX65uFgME5PWE+CpuawTJbRmJorvsC6Ou++U79pmv4jWShOmaW0en+WVthWZB/DdX1JA3VxUwk6kTmnSfIyGMnWbmtRARwT/hEAMm4s8JKffdZZANuzUW+3fJcX9xkE3jLxnUmCoiNqOTa69mfKjDRDUqcwzrIx2Wo25w9ZnhcjkLIn63qbPaaxZmC14RIR8m3fUGFNlp3dGNhWOfFwNV4lCt/YN7uWcs3prxFkC+xEHdkW6tDtgztrOOkI7lFssrDjxUFpSEE+DyIjlAumGpqxp1P0S+
 Pd+AmikL
 KwkLa05Z8w5YnXliWRvyMctF02P5o13Cds7tF9/JKe+wTnmpksuIso2VCPlBuYFpOoPC3nllIjLhxo4GtJv10Cnmx+JjkTLNnLo7bSoOmRy7l8s3fFLnj69aND9OM1YNJKyHBOiquO2Zfr13B5meuz/VvZkzo+rjhTcXmjEhsY3CzRaQS2KlNkzm9sbNabNYEb7Fkjf5uX4KcxIQXV6lBWpmcUsZ0WRvth1jjUJ10wj5l3pVGCHzYbBF6NUIEYzMFv/AvHm/hVCIYV1QOGY/uh6cztSrSHIsY0icw7BP6wAW8xrHQ03kMt02mS7CtMOv4FUIUZsCWYbOgmFY60lBIY/ybT3xHXJIw4j+4MT6SywiIt1kOBepEAK3I9Ke00NHZTZ1WOj1quLjDXkBxkK+IKLHEmCnRPbTawHY4eEZBkOuyGCJuffUfVCmP3NnbdOCLUVKsmX26HCFWoYXtwql0bclZqgc5+33BHFWWXEr7x6PlaiJjFdqgRCw9QarC66ry95bMJjSofpAEUuGn8VmUdFpMQKsBvcK8r9oWwcthaFB5AnsZKNtQ61vwTRiuDTjXsVPKMIGvX37noRAlG5tX/YeUzYW7SdUdojFBeT8qyfyfVECnj+4/N3mIm3esebRuV+HO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2 Nov 2026 17:16:12 +0100 Michal Hocko <mhocko@suse.com> wrote:

> > > > > > We get an added benefit of simplifying try_charge_memcg(), which now
> > > > > > has all the stock management handled transparently within the
> > > > > > page_counter layer.
> > > > > 
> > > > > This is quite a large change and I believe it will be really benefitial
> > > > > to have some high level design overview in the cover rather than trying to
> > > > > chase it in respective patches.
> > > > 
> > > > Sounds good with me. I can add the call traces above which should
> > > > explain my thought process a bit more. Hopefully the problem I am
> > > > trying to solve is evident there.
> > > 
> > > I believe I follow where you are heading. I am not sure this is the
> > > right path but that is a separate discussion. I would focus on whether
> > > moving cache to the counter makes sense on its own (without that future
> > > work) at this stage.
> > 
> > If I'm being honest, most of the generic benefits that exist beyond that
> > work were in the other part of this series that I got rid of to scale
> > down the scope of this version. But to explicitly name the generic
> > benefits, it would be unbounded memcg stock caching per-cpu, eliminating
> > random evictions, (like you mentioned above as well) limiting stocks
> > to leaf memcgs only, etc.
> 
> limiting cache to leaf memcgs makes a lot of sense and addresses a big
> concern I had. How exactly does this work?

It's not a big change, actually. This was the implementation from the
origianl RFC of the series:

https://lore.kernel.org/all/20260410210742.550489-8-joshua.hahnjy@gmail.com/

The idea is that you treat a cgroup as a leaf until it becomes a parent,
at which point you drain the stock. Stock can land on the parent due
to hierarchy walks, but I can also write another part to this that
prevents stock from getting cached when a cgroup has children.

> > I think there was a proposal to make the number of memcg stocks per cpu
> > even lower than it already is, because the author wanted to include
> > additional fields into the stock that would make 7 no longer fit into
> > a single cacheline. I feel like we are reaching some limits with that
> > side as well, so the "unbounded" portion seems to be quite opportune.
> > 
> > But I believe those benefits that we would like to see are made better
> > by this series, which makes the stocking transparent such that the new
> > optimizations don't make the existing memcg charging code any more
> > complex than it is. By abstracting away this mechanism, we can make sure
> > that memcg just handles the logical charging semantics, and page_counter
> > handles the implementation-level details of stock management.
> 
> Yes, these are all good arguments. Especially when clarified that this
> leaf only feature. I have to say I was struggling to see how caching on
> all levels of the hierarchy would work in practice.

Sounds good. If it makes sense to you then, I can fold in the
leaf-only caching into this series to maintain more parity with the
existing code. How does that sound? 

> > Personally I am a big fan of how try_charge_memcg looks after this
> > series, what do you think? 
> > 
> > > Quite honestly I am still not convinced this move
> > > is the right thing but I would like to fully understand the mechanics
> > > first. Having discrepancies among different counters just sounds like a
> > > potential source of future problems.
> > 
> > I hope that I can present a good argument for why this is not as
> > concern as it may seem initially.
> > 
> > My first point is that the memory usage counters were always fuzzy, as
> > specified in the memcg v1 documentation too: 
> > 
> > usage_in_bytes ... doesn't show 'exact' value of memory (and swap)
> > usage, it's a fuzz value for efficient access.
> > 
> > Secondly, the raw value of the usage is actually always accurate. It is
> > just the stock portion that overcharge the memory at times, making it
> > seem like there is a discrepancy. Flushing the memcg stock immediately
> > bring the counters to their real values (like what happens right now).
> > 
> > Finally, this is a change that is only limited to cgroup v1 users.
> 
> Right but is there any actual point in adding caching for memsw charges
> now? If you have a way to opt-in to caching then you can simply disabled
> that for memsw counter altogether. Fewer problems to deal with, explain
> etc...

I think the problem actually still exists, unfortunately. In fact I
think the issue becomes bigger if you remove stocking for memsw.

Let's say only memory gets stock. Then on a single page charge for a
new cgroup:

memory page_counter charges 64 pages to refill the stock, memsw only
charges 1 page to fulfill the current allocation. Then you have
memory: 64 pages
memsw: 1 page

And the invariant that memory <= memsw is immediately broken.

Unfortunately only stocking for memsw is not a solution as well since
successful memsw charges still charge memory and will therefore go
through a hierarchy walk.

Actually maybe then, the solution is just to remove stocking for
cgroup v1 users? Does that sound like a fair tradeoff to you?

> > This entire series actually has no effect at all on cgroup v2 users,
> > which I think is a nice perk. Obviously I'm not out here trying to
> > make cgroup v1 unusable, but I wonder if anyone is still using the
> > legacy feature.
> > 
> > I hope this wasn't too much of a brain dump on you. Thanks for your
> > feedback Michal. Please let me know if there is anything I can do to
> > clarify my intent.
> > 
> > Would you prefer if we continud the discussion here, or if I sent out
> > a new series with just the cover letter changed? (I don't anticipate
> > any code changes, based on sashiko review or anything else that I see).
> 
> Let's just iron out things first.

Sounds good to me. Thanks!

