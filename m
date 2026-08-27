Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2362C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 14:03:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE8836B008C; Thu, 27 Aug 2026 10:03:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E98EC6B0092; Thu, 27 Aug 2026 10:03:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5FE76B0098; Thu, 27 Aug 2026 10:03:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B08516B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:03:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3F2DD80464
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:03:18 +0000 (UTC)
X-FDA: 85147216476.10.38D6324
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf13.hostedemail.com (Postfix) with ESMTP id 40CA720014
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:03:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=F9LqKLOM;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787839396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ALN+Th3VygsiiqX2bmJC+etz4YolkrPm7RtMfzNo3Zc=;
	b=8gAZmzW8RG8lKYxsfUdRTSXAS0gjN0Y9tOKWOGuK2j+HrfX48H1m/iTlzJp3xMw+Dq9HTK
	rLDO2aLOf2HV1S9cC6wKGNLCkiJjCtS/IXO1oGbC6sYqnfiLDdD8jRIhDKDajul9+pojbG
	L24pTI63fdKPGY3nMfalY30HzXVtrV0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787839396;
	b=Bkns4g3+D4v9Ueo3ygSthVEAxxYuYaQfkYo8/DjDkpkhadCTb7xVkjN86kqqThvdbEcIAF
	bZe49DcV7lX9Mbz4z5EJIkwmlcxbNzpoP4E0sEtpM4TAoSYtrZuM7SisnxwKcbbtgQbVEA
	JdVVM07MJcLJysni+POTvCsIV4SgGQ4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=F9LqKLOM;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-47fd4531020so1275324f8f.3
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787839395; x=1788444195; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ALN+Th3VygsiiqX2bmJC+etz4YolkrPm7RtMfzNo3Zc=;
        b=F9LqKLOMZvjN8wl1qALT4Q8IlwD/VbcHz4sFtLwpg1pHwjZzwd77RNV7VCJHuGFkdV
         yhmhGqvlKiwQPArNNADXXjVJHBAdNTxaSPKBa9fIf7kqJvNk/Z63thXhRIi+SQNy0Yiw
         O0RRWlABWG2wxrQq3tKu7j1Xgiu7lACxZq485doZKqy/0IrZbn4aHS+bo+mHdZgkJUlB
         Qx5gIAunc9ksapNyikLhwHVUQIIxohi0qK2o6AUBSXdGdUAi0/XVUtD7DldppDYmBvkS
         wr0iGzIuaHNbwTkT0wBQNKWU9/jF5hkryAW4VqHUi+2VdcgatAs/oBQOOZccVq1y7n2l
         vbBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787839395; x=1788444195;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ALN+Th3VygsiiqX2bmJC+etz4YolkrPm7RtMfzNo3Zc=;
        b=Gm9Yynm1V6KvGu09Ti+hTunuD7AxCAr2grUBhQNAxsBREaMpDk6rZBJicTGJRInoKS
         OR/2PV4t31EvZ9jHHnOy2Gye6Jj0pxgPgqHe62JuPexggzaKh4SHZOzJzfODmHxIHsan
         SNJ10iufIOqTc/O6X/3K7wvVA8Byy623ndmcxV4F7tdAOpMDemjxZ1Jt+vgJlWnk9A3F
         Fv/VudJSYYzPWFU0pcO61v8mJF/5MkMSNR4gmLoe2lR5bwxjjj2zerXgu4ZxDDhJK7GG
         xeQkDOO18u3eCfJgnS6NyXTO9RCNlp5LwVUdl55hh2dNjnWZczpGT9Mzge+7+XSM1lKS
         8zkg==
X-Forwarded-Encrypted: i=1; AHgh+RqYwNFR0uRKptYLJ8wVX/LqBwd8fIysT9BfP1bPSf2uUgGLmqnDL3Kv0yiyFdcCG9+14n41fVUNRQ==@kvack.org
X-Gm-Message-State: AFuF++m2rCutfKI8908ivUK11KQXhdDMQlFzK03a5gzHiAjWMi8vgO+H
	uLunBVfkQUH+wB/aEZQv2PSQOSRjLJEKqDceuJLAdvjiU/vXjb3LGSwlEfFYtBH/cKU=
X-Gm-Gg: AR+sD114wbS0TQ8rS7K4KadMqNA8mrYIOtLv77YvKEtU47auZxMlxLjyw+feOKvTgg/
	F6O9cvtsgOQIiDRKHWA/zNvG3YrmoSdYuhPn7jh7exqer9YvU4cshYQHkWQ11VeiIoDZLAM1f9n
	oHCGhUM4WM/DBk2LKa/AMbaCattjCCiTEAvA66i6FR7ayZNV2T3lr3JCytO9Sk8iF/vJmN4hTYG
	/WA1DEpi3OxhYM9tvwnFgvb5lXwIZCdLEyGMvp6V5B6SMr5VENox63g9LvAGn+9XXJBK95V4fO8
	aYweV7NB2u12pr+DjRkoLU4zRXlgdlTCmxLpX5MiVurhcKFkuQhP4RJAZBfju8tGUrKktCbaeKI
	7ooK75lYzSz9qv4yoFYxCe57CumBXNBWfp1jHGUkOp1DYyqlkK/zM7ytaCNIqQ3GLSqbaMQ7Ffg
	r1cR27lkRlnTzZ2fSQ0UqRuHFs5g+SkQ8iJDs5xzwtLRvBFskjaQm8tY/dcsdtTeZ/oIbw5naV3
	Q==
X-Received: by 2002:a05:600c:4e55:b0:499:484a:81d0 with SMTP id 5b1f17b1804b1-499dc723fadmr189406965e9.9.1787839394561;
        Thu, 27 Aug 2026 07:03:14 -0700 (PDT)
Received: from localhost (109-81-32-216.rct.o2.cz. [109.81.32.216])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482e28dbe1dsm9947082f8f.22.2026.08.27.07.03.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 07:03:13 -0700 (PDT)
Date: Thu, 27 Aug 2026 16:03:12 +0200
From: Michal Hocko <mhocko@suse.com>
To: Eric Chanudet <echanude@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Maxime Ripard <mripard@redhat.com>,
	Albert Esteve <aesteve@redhat.com>
Subject: Re: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
Message-ID: <apBDoJEq_4UuJAaP@tiehlicka>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
 <aowHqqaqK7TeexQH@tiehlicka>
 <ao2gA_m3BCBu2esy@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <ao2t6HP-Zt5KDg30@tiehlicka>
 <ao3UKM5SbxBmxuR0@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <ao3quaSze8YjPjxZ@tiehlicka>
 <ao3tFg4JLNlbylTR@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <ao6eC2SUIGVz3Qct@tiehlicka>
 <ao8uZ0cNyqaAJuPB@echanude-thinkpadx1carbongen13.rmtusma.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao8uZ0cNyqaAJuPB@echanude-thinkpadx1carbongen13.rmtusma.csb>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 40CA720014
X-Stat-Signature: ptuqsqbbitotyios3dgoci4kjtdyfpbs
X-Rspam-User: 
X-HE-Tag: 1787839396-716399
X-HE-Meta: U2FsdGVkX18CxfHtwVEvDSRWlLkRsIQbJ7Nf8UMqaLp0+QRdyebNhayvKPf+gH8RbT5OyMGG5xUaz3O8TdeVHvN7kiXIRYcUkZsURPe+bt9kuW50r/8jx0hwMHstZr9ynbSgj8sUF5WTEMYcJwcza3ezDMnyaHNzX0sxOf9nZ+cJF60MSlZKE2HDcl10UNvjXErFm6EIO+DP9yFt0uwvFULrVhB9lDsxsKgiR4vH/WfqdMbSZsZ0+UqL3285bwxV6imQpll4xXMnWxgy1ogTbc11tcBeIawY69Dm0pplD2z22Y4x7B0Lw8hApDdHct63w2cOhbp4lgt9SB3Ybwo/nUeCD+EMPGqyLTOX5RLoXSfE61pz6FwGN+qLwjDSMlLEZPOnfUqwVlkWKm/Q97cKh2oejzO2iRMsb5oKDFc2YDwXqbah9tW8JW/FXRqOsu1kKNO1wBIe8tFn0oI953qPYY1RDQbMIdgapLTiUeJYsZXCOHZ3GqQcJLQOFQGeYkbMlbb0/+JuQLD6+M4NpM/PpfFS8AosFOJ3pcWOf/LkIpD4WFRkxRpXjzB1L75j7la/x++rnydJpb1XOKQkf9FZyJoD+JXITcSq0wt10iuW8pvsfbGtYUzOJzqUJLrBswrLh3P0dbnrEfmRgYhlwxu9hMKtyd2pJ1/cWWgfwi2cubgwk/WU1vJIl99adHjjgqCkpPDY2dpi71mCZU1+QrxEanY/TZmQuOqo9k1EgK5wRSTiV2LtheEARwFdQCnZpQu751kRJFNMikqGS26mY53RHoyTsdd/EZ46b1uhD7ftO2luT9nbqQtFSmCRVAUW7BiIP6txJ//rezgqyrrcwpLRYfPl0nGbhSirtzNJHbAcxb9GOxGH0lAlKcl1BQHWKG1DagdbD9xpZ5U1FrYAR8t8RVx76ZXSrZPxBpHoypNS/7iZGoABDZAVasBgQ98nBUVeHf/8DP6B83nTh4Pv/bM
 mgmz0/5L
 YfyQhSnTnvCBRUnf5kWMT/Assw5N1Dvj4AEbBlDDPPV+S0TwI8HHrHm0KnDv/KRDVW3lqJ7qcoUKeAuwMOWt+4DgZxQhheD8KcUQKeXpzbU+QD+3IaghC8I6unKLe0XfYoaHgg3tt9Dcc26HtB43NRtDZNGwDuj3wkU1RWEetQy5oKGwVzi0lQWKhKSiv283gM0UMp+gobMWjtzbgT+55w2jnROCNMu7zUqaQQML/wU4POBFuTbaXPmdv2LJy/ZXkh7Je+e33xc5xs31juYMXPvFBa+Zu3muaGX/M04ZCMNC0IFbGVxghLr5mMDkwphrAD1SzcESZSiWy5MPwrPD/c6ebTvY39CrE35131u/CVtBAmCdkVCSZuvVyOT67HBBjkSmQX/gG/cGhQ480mV0QRPNHiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 26-08-26 16:31:56, Eric Chanudet wrote:
> On Wed, Aug 26, 2026 at 10:04:27AM +0200, Michal Hocko wrote:
> > On Tue 25-08-26 16:58:51, Eric Chanudet wrote:
> > > On Tue, Aug 25, 2026 at 09:19:21PM +0200, Michal Hocko wrote:
> > > > On Tue 25-08-26 14:33:48, Eric Chanudet wrote:
> > > > > On Tue, Aug 25, 2026 at 04:59:52PM +0200, Michal Hocko wrote:
> > > > > [...]
> > > > > The administrator opts in by mounting cgroupfs with
> > > > > memory_cma_accounting. At which point the cma allocator will charge CMA
> > > > > allocations against memcg and manages a per area counter depending on
> > > > > what area the allocation was made into.
> > > > 
> > > > So each CMA area will have its own counter and limits?
> > > 
> > > Yes, in order to enforce a limit per CMA area this series add a page
> > > counter for each area. Areas are fixed and discovered early so the
> > > counters are added to struct mem_cgroup and initialized when the cgroup
> > > is created.
> > > 
> > > An admin would then use the cgroupfs entries to assign an area limit to
> > > a given cgroup, something like the following, using the reserved area
> > > for example:
> > >   mount -o remount,memory_cma_accounting /sys/fs/cgroup
> > >   echo +memory > /sys/fs/cgroup/cgroup.subtree_control
> > >   mkdir /sys/fs/cgroup/mycg
> > >   echo 16M > /sys/fs/cgroup/mycg/memory.cma.reserved.max
> > >   echo 64M > /sys/fs/cgroup/mycg/memory.max
> > 
> > OK, thanks for the clarification. This confirms my initial suspicion but
> > it is better to have it clearly articulated. I can see several problems
> > with this approach. First and formost I do not think dealing with all
> > cmas this way is manageable. This can become a mess very quickly if we
> > have one limit per cma and too coarse if there is a single one. I also
> > have my doubts about space allocation control through a simple limit for
> > something that is effectively a reserved physical space.
> > 
> > I might be proven wrong but unless cma serves objects of a uniform
> > size then this will simply not work in practice. Hitting ENOSPC without
> > hitting limits and thus impractical for shared space management.
> 
> Isn't that an inherent limit with CMA as it is? If the area gets
> fragmented, some buffers may no longer be allocated since there is no
> remaining hole big enough to accommodate them? I do hear that putting
> arbitrary limits would make this worse, which might breach the threshold
> at which it becomes a problem.

I wanted to say that a limit for something that is basically a
reservation problem for shared pool is an ineffective solution.
Exactly for reasons you are mentioning. You might set limits for parties
sharing the same pool but that will not ensure they will be able to use
their promised portion - that makes low,min limits effectively
impossible. And hard/high limits are only to stop runaways.

[...]

> > Thanks. Yes this is more clear now. And it resembles hugetlb situation
> > more than memcg. You simply need a memory pool specific access and usage
> > control. Dispersing that to a global memcg limit seems rather coarse and 
> > I would say impractical. So it really calls for a per pool control with
> > an understanding of how the specific pool really works.
> 
> Thank you for the feedback. It looks like this won't work. It also
> excludes the attempt through double charging dmem[1] as it would have
> similar issues trying to use memcg.
> 
> >From your last sentence, would this rather call for a different
> controller entirely that would handle CMA semantics?

I would recommend focusing on specific CMA users rather than trying to
define a sane semantic for all potential CMA users because that might be
a lot of different things.
Then I would suggest focusing on the ultimate goal. Do you really want
to provide any sort of guarantees (a reservation system) for a shared
pool or merely cap maximum usage.
Last but not least think about whether the whole sharing of a
constrained memory area between uncooperative parties really makes sense
in the first place. Especially when the pool serves objects of different
sizes and fragmentation becomes a real problem.

> [1] https://lore.kernel.org/all/20260519-cgroup-dmem-memcg-double-charge-v2-0-db4d1407062b@redhat.com/
> [2] https://lore.kernel.org/all/7e4e9662-d876-4493-a0b3-e31640937dd1@kernel.org/
> 
> > -- 
> > Michal Hocko
> > SUSE Labs
> > 
> 
> -- 
> Eric Chanudet

-- 
Michal Hocko
SUSE Labs

