Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8796CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 07:22:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43BB08E0015; Wed,  1 Oct 2025 03:22:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 413248E0002; Wed,  1 Oct 2025 03:22:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 329958E0015; Wed,  1 Oct 2025 03:22:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 198D98E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 03:22:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AB4ED140943
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 07:22:49 +0000 (UTC)
X-FDA: 83948703258.02.C304A85
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf18.hostedemail.com (Postfix) with ESMTP id ABFF31C000A
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 07:22:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=iqK4JFji;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759303367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/dGsRtrk3NgIPfHc9qy1Hht+Zu4gDykb2oRP+kyh1y8=;
	b=ziJDl2/8pBeX0S08Ney0agdauyluXEwTHMg4d9URjmnHoiOF8sEi/zTKt3CogvU1aw2Ml4
	pcAjFFUDC8q/8gMeacZmFCzMEmQlP4OX3906r18hERTEUa/HZtbDotvOuhu64PyVZP0xFN
	pKA/HueY3C0961bIEs4Bv3HsCQiCYRc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759303367; a=rsa-sha256;
	cv=none;
	b=ELHfgzUb2DhS74vohKhl5C86FY5htepKqv9epCjEZsmHKMyQeWlcw6BZ+vnPO+6sFy2M7B
	ok6y6ZQdHoi8vKcAFmq1PSGis3g9PaB7oZ9vtuanCnJTuydUdFGWijg/HY12myNQ42KzZJ
	HagsggNf/WdDxVtu2z5tZgKR01Ia+o8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=iqK4JFji;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-795be3a3644so39153306d6.0
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 00:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1759303367; x=1759908167; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/dGsRtrk3NgIPfHc9qy1Hht+Zu4gDykb2oRP+kyh1y8=;
        b=iqK4JFji4ziYEGcGoZ+tEVZ3tuReZ+VvNgKPDvYgD+aZpDEoFAguKFhZqoDhnDnTIR
         Bt/Nn1vjJVFKc4Oamd66pQbY9tlmY3zYSBCorW3HnjceDYO+L9W/G+oY9XFBnBt5337C
         rcYWIw2Tc0DcugxqzxFGofGyNJKOZpLLSYyRqRGNlGhK262v4Si26d9cCUnKorSSvK0M
         Xadrff8AFONm32D8rQ1O9a9S6HGvjhPrz2jBkDmWu3GL9dx6gNHl8TJRhtdZkS1S8N/b
         ASpdi3hPbBwfr6FnEJbzGTfR/Z319BUt5ENbA0XX3ns28VaS/TUoxPa2Ws/SKisfP7nO
         8OFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759303367; x=1759908167;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/dGsRtrk3NgIPfHc9qy1Hht+Zu4gDykb2oRP+kyh1y8=;
        b=V2hP9fj33vNzaSNkimFnaSOpSBjxJ5ksPRDItlLB+mg33+3i5G0X6MO4atv2ofaiMC
         BRbXahXT9trFvU73iAwfnS5IPY/0EZQW2amv4atJEqsiGgu7u8cu4H1No49O96ymrEqk
         uxwoHI1Pih0wzxUIhpEM1T38HFYmzNdTGi0IH7gYyntzE28vWkz6a/+zCUOr3wgNB1H4
         Cczv22sRHG1t1gqO9YN2rJo4hj7UEcqRQBg1zAyr2CeD6/vPj8iCtnSPyo5xiJhq4M6c
         d1LmGlUld0fy80h4LdgqSAXlI17eDwyBaAi5IKi5wfpkwXxKigXi9D6Y5mMlOVVt3Pss
         gXew==
X-Forwarded-Encrypted: i=1; AJvYcCWc69UgiJJBbPE4S2/W+vpX0m2wcdjpk0fkFj9A+MCE4rBxX7SG66kR9v5QrLOeSQFaxYt+AX67BQ==@kvack.org
X-Gm-Message-State: AOJu0Ywwvqy6lAAqk9egcgGsZg3c9lenUeU21lFkfo4aVWCGSfEF1sar
	KFKftg3wbcXznC/Fq4pQULAs/uNE/fdd4nVGkQZSwLBdQdhXOQsihx6SL3lzZmcJUiA=
X-Gm-Gg: ASbGncv7alFgSJ8LkScXS8DNmdVf5i+kSlww5MBe5G0SQUQtKd0OU7Wa6lTZR1yTioR
	2MGLkHG7dGxerQqKjUVEWAQUEUI0gDZYDvmGmb1jqf3wGq0bKrun3hONZ6uuJuJFvH2u4eoQEz+
	K1LR94p4UjTfutnegYXZyeIRMuDT1ltOB/udo8QeuWhyh/vBexOTbApP3iYQQJffIjqC7dyfm09
	dOMrJto5n2Ix3ST9zYTbiMgV5fpDsp2uLnZ0Zpz30Xy5CVFoFWnEoUr9wgVtmNh5fCPPgOBr24v
	hVuaria2C5JHyBr6FkwLRUVWf0ZZThx9FP+UKQeq4LwpQPQrCjNke3uB3RMpfClb5x2WXaH4nte
	OIvIBDP5PsddvLHmxhKxkuM2dRn0nFUFTYoBsdep+zsPp9CnkU+89sVQem3O72e5X3V8m/6aMDo
	tEKw7fM1OR6zPbHCyWx9RQQYZ4sRK2fw==
X-Google-Smtp-Source: AGHT+IEb4zYPFyY51hBg9M62QR/+6dWkMsCJckH5yirdBRASwDVM76yHqNVz6fekjl8pBVjStIx0HQ==
X-Received: by 2002:ad4:4ee6:0:b0:863:5c7a:728a with SMTP id 6a1803df08f44-873a547f9a5mr32344286d6.37.1759303366554;
        Wed, 01 Oct 2025 00:22:46 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8013cdf31besm107925176d6.18.2025.10.01.00.22.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 00:22:45 -0700 (PDT)
Date: Wed, 1 Oct 2025 03:22:43 -0400
From: Gregory Price <gourry@gourry.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>,
	Wei Xu <weixugc@google.com>, David Rientjes <rientjes@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Bharata B Rao <bharata@amd.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, dave.hansen@intel.com, hannes@cmpxchg.org,
	mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
	raghavendra.kt@amd.com, riel@surriel.com, sj@kernel.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
	nifan.cxl@gmail.com, xuezhengchu@huawei.com,
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alok.rathore@samsung.com, yiannis@zptcorp.com,
	Adam Manzanares <a.manzanares@samsung.com>
Subject: Re: [RFC PATCH v2 0/8] mm: Hot page tracking and promotion
 infrastructure
Message-ID: <aNzWwz5OYLOjwjLv@gourry-fedora-PF4VCD3F>
References: <7e3e7327-9402-bb04-982e-0fb9419d1146@google.com>
 <CAAPL-u-d6taxKZuhTe=T-0i2gdoDYSSqOeSVi3JmFt_dDbU4cQ@mail.gmail.com>
 <20250917174941.000061d3@huawei.com>
 <5A7E0646-0324-4463-8D93-A1105C715EB3@gmail.com>
 <20250925160058.00002645@huawei.com>
 <aNVbC2o8WlYKjEfL@gourry-fedora-PF4VCD3F>
 <20250925162426.00007474@huawei.com>
 <aNVohF0sPNZSuTgI@gourry-fedora-PF4VCD3F>
 <20250925182308.00001be4@huawei.com>
 <aNWRuKGurAntxhxG@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aNWRuKGurAntxhxG@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ABFF31C000A
X-Stat-Signature: ocmdoah8ygk8s377pnr4s5c57qctcwkw
X-Rspam-User: 
X-HE-Tag: 1759303367-215906
X-HE-Meta: U2FsdGVkX1+RYF8cFcLdKelOdA1aM0kbV4+FoczExwftD5Wv3cMLkIacEU9QTpxr4R21ohx4IyUDRCWRBuk3dG7VSLuP8i4MG5PJfhD4vHv6kdWaNR9jlk7axX3LT8XKwfIU9cQvtGotUqUzsWANN2yJdBMV+PlP1jQABjm6N0OttllO65iORQaaVBRlGmB1JVYoOPN1XQSa30KJwAxZwTSYCuGFMoCK3DyUd5Fsnw/wnZ2xOkETTnS55neiIHWJN6jjby2m8/VcpTKu5+5IGWhN5YxQzED2rkY2BYIk/RLsM7blIQ+9zUD4WbzcCqqouL1M2TqHMPsJ2GXPCvaZw8TXjfnZN4X4OdFQH5dfOoL1HuoNJ7HRRqy+p9u8zTuN3moYq6uBuf/YE9msmU8kH44upBj/KUSvX0Z1y5oPhBv7d2bo2eaKmaSGDpbk6OPnYyXWGBAMJSLiVY6rbasrHSgnJBYLQuiu1PzZxfo6EfuZ3EqrPedpVvbCjtkYZ69Rt6rNnVEeT1US2KovzwRGy0qPDU6fiO3DztLaNiCJiQgYiR3kFIJObumTGkU0vzfmJ9Gr0BSUTAcqpNKtx1cBDT5N+VgTqrmsNCXB++tr2NY1iEAdSy8SY+CT6uH9A85bovTIRCiYWFD6he5v7NUy3Y8fOtqjruwmZ0lphAxR9J9FIol0sFm/dU+T4EVLDKAcN6Q1HCc3/FYMJpe+3ASRJOB9GbaBjaUhz/tUceHaLdyZj7fSSqfSz9xpqPjwZDJJ5JCLGqqVGn9TahDgBchGq6UCr8FivOgB3xZllT5avqOf83XVIl4pCt9QmhJKhUoGSQ5PN0tEl1FLbY9dL70vBtaarSIvURlpYrSTJQVywpdExxH9ZgfFjXC1WzReP3hC3OQ3o81geYEmQkrFxS2Nlz3/wZv8tYCzX4I6bS4HJLwDwFT0E5J1YdZfyR/sOzHi+N9v8DTLJU9CSevb30Y
 FAF5A43E
 SbEY/aZFsn4Z1SGFb5dN0Hd99TI2GA7CCAjghxjAKPPLnmfokWT0tlln2hpQAQdO75hCvXUbXb/f/uoZl39rAhYjCFH8azq4DBaegUaGwiXasGWN15Loi+TZ8O9e6Uu7kGRI/EeCzVOC6j7UPnYhYebAay9EKinxrkMBSa+/vpOy8j/CgO3/ZUY9KtyGd53C19olzn7SqEoOTT4pT5VODxRth8uQh2stzc1yOdHyp9+hppwUoQHKv7q2wOWRWXFNfjWWW2F+MGw/0OJJKGTpOjRg/xtK1kd63Eb5/HvOO8WvSm9dDi7ojwHmmWu6p+CwDs/tY9uk5p0kAwzvUV3IPKWO3vDh191x5GKopYloP2vGZfvDDymwpLBdcTk/X/Un5tUX4GJFtY0MNYZw8PTymK18R79gXDqISlZV84Woa2J9IlsR8T8A6Rqaq9WSIbkXlaxAgWvIJy8ZvLKVkc4lpXdl4g8x/Sku+6IPD1Rj/hWOhYKUdrglfwollzOhPjodJB5bHB3cm38z0mCJa/RO5C1d4HA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025 at 03:02:16PM -0400, Gregory Price wrote:
> On Thu, Sep 25, 2025 at 06:23:08PM +0100, Jonathan Cameron wrote:
> > On Thu, 25 Sep 2025 12:06:28 -0400
> > Gregory Price <gourry@gourry.net> wrote:
> > 
> > > It feels much more natural to put this as a zswap/zram backend.
> > > 
> > Agreed.  I currently see two paths that are generic (ish).
> > 
> > 1. zswap route - faulting as you describe on writes.
> 
> aaaaaaaaaaaaaaaaaaaaaaah but therein lies the rub
> 
> The interposition point for zswap/zram is the PTE present bit being 
> hacked off to generate access faults.
> 

I went digging around a bit.

Not only this, but the PTE is used to store the swap entry ID, so you
can't just use a swap backend and keep the mapping. It's just not a
compatible abstraction - so as a zswap-backend this is DOA.

Even if you could figure out a way to re-use the abstraction and just
take a hard-fault to fault it back in as read-only, you lose the swap
entry on fault.  That just gets nasty trying to reconcile the
differences between this interface and swap at that point.

So here's a fun proposal.  I'm not sure of how NUMA nodes for devices
get determined - 

1. Carve out an explicit proximity domain (NUMA node) for the compressed
   region via SRAT.
   https://docs.kernel.org/driver-api/cxl/platform/acpi/srat.html

2. Make sure this proximity domain (NUMA node) has separate data in the
   HMAT so it can be an explicit demotion target for higher tiers
   https://docs.kernel.org/driver-api/cxl/platform/acpi/hmat.html

3. Create a node-to-zone-allocator registration and retrieval function
   device_folio_alloc = nid_to_alloc(nid)

4. Create a DAX extension that registers the above allocator interface

5. in `alloc_migration_target()` mm/migrate.c
   Since nid is not a valid buddy-allocator target, everything here
   will fail.  So we can simply append the following to the bottom

   device_folio_alloc = nid_to_alloc(nid, DEVICE_FOLIO_ALLOC);
   if (device_folio_alloc)
       folio = device_folio_alloc(...)
   return folio;

6. in `struct migration_target_control` add a new .no_writable value
   - This will say the new mapping replacements should have the
     writable bit chopped off.

7. On write-fault, extent mm/memory.c:do_numa_page to detect this
   and simply promote the page to allow writes.  Write faults will
   be expensive, but you'll have pretty strong guarantees around
   not unexpectedly running out of space.

   You can then loosen the .no_writable restriction with settings if
   you have high confidence that your system will outrun your ability
   to promote/evict/whatever if device memory becomes hot.

The only thing I don't know off hand is how shared pages will work in
this setup.  For VMAs with a mapping that exist at demotion time, this
all works wonderfully - less so if the mapping doesn't exist or a new
VMA is created after a demotion has occurred.

I don't know what will happen there.

I think this would also sate the desire for a "separate CXL allocator"
for integration into other paths as well.

~Gregory

