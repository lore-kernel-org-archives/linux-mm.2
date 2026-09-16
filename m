Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5176C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 08:52:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE2556B0093; Wed, 16 Sep 2026 04:52:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D93666B0096; Wed, 16 Sep 2026 04:52:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5AFB6B0098; Wed, 16 Sep 2026 04:52:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9DD526B0093
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 04:52:25 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0F44F1C2BE4
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:52:25 +0000 (UTC)
X-FDA: 85219009050.02.A5AE729
Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	by imf20.hostedemail.com (Postfix) with ESMTP id 175121C0005
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:52:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ATwAR7bg;
	spf=pass (imf20.hostedemail.com: domain of mhocko@suse.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789548743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2LBbelDPdAVQ0Ns+BBW49QmFOaM2BGUlkuMpM25cdq0=;
	b=Lt0T6oxzsfAD9h+1Tra8A4EABnJ/OopcmSjvOwH6hxTBCqhPAvyXwsG2EqMreJpb0ZJ7H1
	etASaTUYOXHU1Ie3D4uHRGhFs0CGh4O82gc9mbQgkYff0QM8/Kyg4QlzYdQiEJ/LA92VhS
	SwA0zBV2AIvisQAvL8Ywm9Jug4e2SpE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ATwAR7bg;
	spf=pass (imf20.hostedemail.com: domain of mhocko@suse.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789548743;
	b=JYV+ijCqx5Uj+nq5n+boF4c5MFnP5dyzxRU0Arm9PwyKLns1pB3R1HlOS+BFIzkfZFW0rp
	xcal4ULSpcm0HNC0WN32c7zAAuYqOCrvBNnZUEageoHkHpa5KNsKPLKUoXRnjo1AgeIv83
	eUpgOIHk7eiSHpoSxJ5bnbgxekGyrag=
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c29703cb470so104940866b.0
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 01:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789548742; x=1790153542; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2LBbelDPdAVQ0Ns+BBW49QmFOaM2BGUlkuMpM25cdq0=;
        b=ATwAR7bgA5r0A41tcAfqETSewekTJ6dg/8b0VdGPSuzpyHGj4EznWgxQ094FCts62T
         rOTVrbUpblyzFJGGS6SRhWiuOg5QoDyBOeZeLxIXID6O8aadAPrwawYiA65kTTjUh8oV
         9R6+XBf+xp3ZKu4krbDar+preKG7+qGaqHfZ00Fm2mpK/GJ7wkgnvtURLizIy2//lcRn
         NHedcsbnx7IsaaZFNa6/xoedUaYIyDwJTcHLjmyL9hOhqZNVkXwXan+WZuK//ZvbxQLJ
         1eOCToJDMMgj0iBHbdAJ2rVnAZ93H66NsTqtQxZY87iacSt2e2F/LqBlwz9uyqpwxBe0
         GXnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789548742; x=1790153542;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2LBbelDPdAVQ0Ns+BBW49QmFOaM2BGUlkuMpM25cdq0=;
        b=hXmZf7Ofr5lWI9DIR8kCT4lnAbMWxNjAsh6TK55ptwXB+ZR91G1Vxu3QG+nri5B+KN
         Y7DtaV9ZaM5VC1xtWISCfL2uiye2GwBLw5/DfqqptF53gFXiHtqPy4+MhllOCGWtMAnp
         pSnlFM8gpXnXWgFcmm5XHPkqNq+EAs5tn4RtOPhm3p+SF0nCoME9x4R9J+OaCgpI6PZN
         2W60FKjJOzU71pvwMnH6bEao9olj5T9ebYwDYnA8BW4A8JN9YOMgGo005wuk1afTQJBi
         FuuALjLyxH1TITXQthMvVwkbyM8czEKIQe8rdKHt+l/Ing1Oy4BeY+JPUFdfQWye1O50
         QeYg==
X-Forwarded-Encrypted: i=1; AKwUvBy3++0uirynydzn2ODV71RyqvgFs2Po51ZUUQMiexeNZ9b/oGLo9ZmqE6tpG7SgKh4N6qLzpSYc3Q==@kvack.org
X-Gm-Message-State: AFuF++nQ2zbEfzLhI1N/EjSgOgwQjO7K4PaJx0e35W5Js+zhl5d+HZ9g
	NSIgwwJxPPO9/5xufsr+CDzsSdvciTI+xWQA2aSWccxXHKANncAPsRNehzae9gtRawk=
X-Gm-Gg: AYBFou1ZqboTm8I7a+N7FBYKrfPylMhSVLcBM47+Oo7gbXm2xKlAuZRymviTAmX/Y3X
	6dTY9dVQ9RQcVnfUO0W3OkWM40ANVZAxBjyf0bPmdZtleMwHWvtnEoE7Ly1Vy7l2X3So7i9IMpH
	vH8c/91gRYiHlntnKHvXrJNn19SWhNi93y4W/uNUOAK26if16VUOjx21A8w2bEvwNt5uKn/S4ao
	CXXbasEUXkosxnHkppyvcV/DchLZDATKStVAN5UhsNawcTbT5b2gj8eXIBhb/612i+5kPfkkHh2
	0lYtmxTHgbmz5eqLJrKmicbryP6J2ZLyzric0yW5y5YTSgqQJrrpuLtd/L51n/ZqkioOnDv8O1G
	cSE7zhH1GXUBgeGNfmyv7cFXUSkUlmyaU7gc5VXI969E1lTpqm9azGfzq6RWrh12KFAb1T7/YXC
	KtHyRC+imU6vbc1tAr+bVEy8RgRiG0lkI01qAEe9nYVY0mhio6XZhg4b3gNOQP
X-Received: by 2002:a17:907:928a:b0:c29:4d81:c5f0 with SMTP id a640c23a62f3a-c29e51b1ad7mr218786066b.6.1789548741687;
        Wed, 16 Sep 2026 01:52:21 -0700 (PDT)
Received: from localhost ([2a02:aa7:4656:2314:c23c:9eda:81d:3])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c29de68fafdsm93069566b.63.2026.09.16.01.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 01:52:21 -0700 (PDT)
Date: Wed, 16 Sep 2026 10:52:20 +0200
From: Michal Hocko <mhocko@suse.com>
To: Kyle Meyer <kyle.meyer@hpe.com>
Cc: akpm@linux-foundation.org, corbet@lwn.net, david@redhat.com,
	linmiaohe@huawei.com, shuah@kernel.org, tony.luck@intel.com,
	jane.chu@oracle.com, jiaqiyan@google.com, Liam.Howlett@oracle.com,
	bp@alien8.de, hannes@cmpxchg.org, jack@suse.cz,
	joel.granados@kernel.org, laoar.shao@gmail.com,
	lorenzo.stoakes@oracle.com, mclapinski@google.com,
	nao.horiguchi@gmail.com, osalvador@suse.de,
	rafael.j.wysocki@intel.com, rppt@kernel.org, russ.anderson@hpe.com,
	shawn.fan@intel.com, surenb@google.com, vbabka@suse.cz,
	linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3] mm/memory-failure: Support disabling soft offline for
 HugeTLB pages
Message-ID: <aqpYxAktjexhaMGc@tiehlicka>
References: <aqiIEkrc6aDBOqRg@hpe.com>
 <aqkCbgHmMGxI_GLG@tiehlicka>
 <aqmGd0GGUCkbZpkZ@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqmGd0GGUCkbZpkZ@hpe.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 175121C0005
X-Stat-Signature: 6abj5tdj617xz78t8qp5twtgbwbkgg4t
X-Rspam-User: 
X-HE-Tag: 1789548742-266694
X-HE-Meta: U2FsdGVkX1+VomWF0Xy5RCtE2LNzJ79QjiyDI2J2aPHrrkfAwZ3/5/5XavniRiQE7HYkORW1D5Mv1hFCQcw/QKGbcKSvmcxW07tDLW1ZV25lWElgsoljRfrmGOJsPRajsmpq2vUN1hM1f1RDbnkOHqXexcqpbHe/XsW9jORHd1G2OTo0k0i6qY4ZluhHQDXLlnrCDsKdghM4KV+Tmeq2iUTlUM72RyMnNqOUBwQsrQbFCQtDVw6r3wLklARDOFV/vqs0kLRdKwwt0IqF+hf+UpRtvnpFtbO9brkk0fKyabqYx2yKCLvGIVPuXEhDFdgeROUI34HxIMTwTkQPXXLBtDwAjJmlSkRT8ai/Fy7X8PhCop2Xu6EAeSIj0SXkwX7QoZ+USJNl/zzC1yKCxYCe5fsgrWyNv9VO8IwLfAMvZJRap6biDAvtohqEMqFjDsVINW6GcD5idJXt48w8HGJzTr5F5BC8mIymBPkvXr3OMGQwap1BGQGokQPw/Til3XjU44TVxcMa0rjc2/lE2Cw5z2G6MbURSS7QfknoMS3fw8IvNSTqr3GURXOfFiEGBRY47LeGXgcxHateMGWb924QmZ6HdtaflmGSzLFofrsve9iToCFMtDh/6bFnMZZBTKvuLbe4e58t7mbM/DhKuNTYvzvzihOSTFwZrwBpHnXXR0EPy3sWqOchlhmWEXVNlKpYRVAg2ozUn4GDZ2zxg6puMIapeaYZfr1KFULJlM8VdA3w9/rCsEY7HUl/N4MXQ99gM3q++jnmJGgyvq3W1ww2sxpXYEDi47ga1s7ks+hHBmxwSQ/AJePk0DsD8fBriV0uzbsURXZxISL4hEXLSOwQim2v6yrdn4eeHImT9WopGrwcxrWMH1u0wYc71FqLnbQ4KGSrEbBGORI3fF7MkkwEf3bRvztAI3d6JeXlo8NXZgF7M3pfoiAykMKZZ5xmXpdWYUZ+feQGFvuCOCsfgwR
 IQnqxuVe
 FQAMrDXZ1sSW8PMclhxMt5mPim6MRHu2P/vG43aZ7EFA4qwjL6MGqqQwYEnYmmq7OgetEnbSSDMqVAPqi2e5TsT2R1o+PUu+j8d6/eFiN6p4mt76vZlQNcLmxcVnUX4QmHQ+Yn3lcv7hf6ALufRrEKQEiK97N33rxWmNFRNRk1H/wbZLAZiZWwVK6oVEzy2qWZs3d2RSTHx8PoAayeIkJLj+alUU/zRsO5Uadm6v6aJG9dA9LEiDCKAiaozj4gf6XdJXrNxhEAzDYRTElENLomPpALf9JD8mwcBetf6mSkaebxu3M8PrTEuBVrhTHPRxykTIeRGOXY7oZpveTCG2xNU2wO/TMW1BwGLuCUUyw3DH3hJmEwP6Xs6x12GKY9t3oXadfRZdcdkSqhnqXq5prgvc/ecSYzAz9y8VHWo5waBuVrl0EHqlGA6+UuLoqWm2YEO8K4NU+tfAj42/Up4asqsY9OVV8FjYrk6CFllVMAjb0Ap/rCvIxcSZ+IVf5XWkwgrTN4lVv9zY4e1U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 15-09-26 12:55:03, Kyle Meyer wrote:
> On Tue, Sep 15, 2026 at 10:31:42AM +0200, Michal Hocko wrote:
> > On Mon 14-09-26 18:49:38, Kyle Meyer wrote:
> > > Soft offlining a HugeTLB page dissolves it, permanently reducing the
> > > HugeTLB page pool. This can be problematic for workloads that depend on
> > > a fixed number of HugeTLB pages.
> > > 
> > > Currently, soft offline must be disabled to prevent HugeTLB pages from
> > > being soft offlined.
> > > 
> > > This patch allows soft offline to be disabled for HugeTLB pages while
> > > remaining enabled for non-HugeTLB pages.
> > > 
> > > Commit 56374430c5dfc ("mm/memory-failure: userspace controls
> > > soft-offlining pages") introduced the following sysctl interface to
> > > control soft offline:
> > > 
> > > /proc/sys/vm/enable_soft_offline
> > > 
> > > The interface does not distinguish between page types:
> > > 
> > >     0 - Soft offline is disabled
> > >     1 - Soft offline is enabled
> > > 
> > > Convert enable_soft_offline to a bitmask and support disabling soft
> > > offline for HugeTLB pages:
> > > 
> > > Bits:
> > > 
> > >     0 - Enable soft offline
> > >     1 - Disable soft offline for HugeTLB pages
> > > 
> > > Supported values:
> > > 
> > >     0 - Soft offline is disabled
> > >     1 - Soft offline is enabled
> > >     3 - Soft offline is enabled (disabled for HugeTLB pages)
> > > 
> > > Existing behavior is preserved.
> > > 
> > > Update documentation and HugeTLB soft offline selftests.
> > 
> > This is adding a lot of user interfaces to control something you can
> > disable by config option for an admin only functionality.
> 
> I may be missing it, but I'm not aware of a config option that disables soft
> offline specifically for HugeTLB pages.

No, there is none. And IMHO there shouldn't be any. We do not want
config nor runtime option for any random type of page to be soft
offlined. You can disable the whole feature. If we need to enforce a
boot time parameter then I can be convinced about usefulness because
distro kernels need to enable config to be generally available but there
are usecases where this might be better disabled during runtime.

> > I fail to to see any actual justification for all of that. If an admin
> > can disolve a hugetlb page it has power to allocate a new one as well.
> 
> Allocating HugeTLB pages after boot is not guaranteed.

yes, and so what?

> > Not to menation that the whole soft offlining is mostly a testing
> > feature so adding a lot of fine grained configuration space seems
> > excessive to me.
> 
> Can you elaborate on "mostly a testing feature"? For example, how does that
> apply to the BIOS/GHES path discussed here?
> 
> https://lore.kernel.org/all/aMkOCmGBhZKhKPrI@hpe.com

OK, so apparently there are some BIOSes which abuse this feature to
mimic a real HW poisoning. This doesn't change the overall picture
though

> If you think this should be handled differently, I'm open to suggestions.

Yes, do not treat hugetlb pages any special. In case there is a HW
related problem which decides to offline portion of the hugetlb page
then bad for you. It wouldn't be too much different if this was handled
through a real HW poisoning.
-- 
Michal Hocko
SUSE Labs

