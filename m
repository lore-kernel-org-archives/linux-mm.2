Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB6EDC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 01:22:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E46A6B0088; Tue,  7 Jul 2026 21:22:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8956A6B008A; Tue,  7 Jul 2026 21:22:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 784E46B008C; Tue,  7 Jul 2026 21:22:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 40B756B0088
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:22:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 87CAEC3D0F
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:22:40 +0000 (UTC)
X-FDA: 84963859680.11.C5E4FF6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id EF0384000A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:22:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G6D42U4j;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783473759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Lb/jkgxNgC6dvY0hK5vMR6pog+drE09r16IzbOKXwA=;
	b=xNz4H+8Z0pNj0Mq3OMFJtGPMBl7ZYnC4zWASOE4t+v/bkkyFnWK3cFHGI0rIPyEFaOkFcJ
	TQT4w/dzTGGjTPwNnleRF+ImKQh3Jlg75Cg6P6Jr6qwGouCdmESUstZwY+x2duTHreH/7g
	h13MsXUhSjsFnrlW3Q3i2GIeZYNccaE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G6D42U4j;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783473759;
	b=fFaZ7PHPIFJenZvo6zwxAzSZzJh96LItWbGuSaiANAiy0Pv+LumeEPR1ZntdolUiLmqi/P
	W/n2Pbvn+1UhrpOms1HJw/1U8Umr0c+5AKtlSIx6tNWUbhs5CarwPW7Wlpx0GQVjhTvaXv
	jUOoz3kwivBWMIS4vZUA1H8m3LFicTw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 518DF60008;
	Wed,  8 Jul 2026 01:22:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1CF1F000E9;
	Wed,  8 Jul 2026 01:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783473758;
	bh=+Lb/jkgxNgC6dvY0hK5vMR6pog+drE09r16IzbOKXwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G6D42U4jW0u9iZ2KfKwxSHncc86EbH7VO7FsvrbISBe6BzRSItxsNn0lnfjTcZl57
	 FgRRtojmPt7DFMbFuOJUdwU5WTXc6GGHkK1PfgPTOJcX6Qg9IDevUfworOUw6hjhyA
	 /uEX0h8wokA3X9BPVc5TTnbwVtAq772oe9u4JDUAo+8JF8iHgj2ircIrM8yNMkGdCP
	 86uk0CjVpshWm9FT8CIfzjAmqIfsIu4T30mqmj8J2yEbG5k1goqBKin6XoPjaWBnRr
	 EFFdrUYiI4aePlYwUnkd2s4s9a+OZuu8NMtbCaSJcYoGujvrNTmCsEXHca/p9aybnN
	 4nd96S4W4qW+w==
From: SJ Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SJ Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/3] mm/damon: Introduce a huge page collapsing mechanism using auto tuning
Date: Tue,  7 Jul 2026 18:22:33 -0700
Message-ID: <20260708012234.92093-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <b786294f-0ba5-4b05-b956-d902c358dd88@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: adt6ttkwrwbtta5h7nn4m4rennec5po3
X-Rspamd-Queue-Id: EF0384000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783473758-330133
X-HE-Meta: U2FsdGVkX1+tMseH7/M+lEhNtdmSpJzvTuRNJAJUIe2X9++IE7lFz/13RWqHL0xhQxIovS1kcj9tyfDO3JT/E0J+zrO9QrQfleRRYlIY2KN/KolHiVY1VL0Ua7NQeIYWE1UNeuNazFm3554LmmnrBCZXKYs4FqZxDwDGrbg/mwWbsXqi7onGIIHGF2617/z6bIfqqKTvR9HFjBfqbSWc1LiBG3MThsIPj4Kt3naso23KwbKT8PtguIl85xbVu+stN4yxiQeVJfnAPXcJAobBwYu8wQueEHIL0wKxABeQ7yco+Rb26M3IvNLt+Zw3aq2x4vcGvnn2K7wYcvlQUKTwbHKlnrR7H7PJJR511ZXzG7o0o7a9HhNNzqTS/GA9eBWTNLt/roEDg4EJiVi1h2zD0gb+8YzPJfiMGm2rLiIHyENrWt2ORorZSnlEmRNv8y6+/jzbsFveZJ5s+Kq9aTu4dtfcA1JWOwSGQlUHvn6B4h9EpU+WZNpRp3/n1ZkVFORPpZH6cAtGbBFrFAnDTYDTLsFh/FNETpSkhgKOG6fYt3uV/OLxpB8g8iA4zP9CbQ3NBZgzdfR9laCHagPwzjAkLZ8lSYAXYZ+YNfzLclNv9ccrsqG85r9ZFQ7ILrKHFjIZ0INbxQI5/V1QicGVuerZvXQBFsjTTJ7sGduYMkAGRpMQT99qM1YWti0qdAkt2+vLM7HR1vdDgs1/x2ckmJOpFyDuZNAJht6Z+UCQhNVDwIRu8tSj/HUSf5wBkwSHHS4RYA4GMJtqkfORt/YcYUsGPtLvkQ1iIznx1AAHqppamg6La140x4sf3bvGwV8IKUsNl6AcgljBTCwrZ4xnZN51Muh/6PfRYZXnzqB+74YubEE0YLgxrJIZMpHZhcsohP9nI4rrWE1NuYtIwM01n0lluEPsGsNZWeLoN586s9cVi/k3t1pBdrRE+ALh9RSos8juouvS8HDeYxL4cSpGW1N
 RmhVF+fy
 M1RBj+6vIo/lxgWSsF59ps75tO9lAXZ/QSkZlMN1jeg3AGzWenpZno74lQPFIpINJaJBzK0t6DP0CoPo/y/zlUHYLOGiDtXtdAvjJ/voD1l4NMf1vuQ7QNDHrCFlBiq24QQSztwP6Vitro6ibT0pQBiyS5Yz2RR4W+bvcr6SYijFkPZnjrRokRYVnhiTJLd6jgleU/M/aPVvYbjPkn5Q6E+ed3720foDJfDbSeedxhar00ASHRa5pXVkkeRc5EpFc/sG88NhtrzWi9Pc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 7 Jul 2026 17:25:36 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> 
> 
> On 7/7/2026 5:10 PM, SJ Park wrote:
> > Hello Gutierrez,
> > 
> > 
> > Thank you for your replies.  I still find some of my comments are not replied,
> > acknowledged or objected.  Could you please address those all before the next
> > revision?
> > 
> > On Tue, 7 Jul 2026 16:31:03 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:
> > 
> >>
> >>
> >> On 6/20/2026 11:02 PM, SeongJae Park wrote:
> >>> On Sat, 20 Jun 2026 20:11:46 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:
> >>>
> >>>> Hi SJ,
> >>>>
> >>>> So sorry, I missed your email. I just found it. Sorry for the late answer.
> >>>>
> >>>> On 6/17/2026 4:44 AM, SeongJae Park wrote:
> >>>>> On Tue, 16 Jun 2026 15:03:13 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> >>>>>
> >>>>>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> >>>>>>
> >>>>>> Overview
> >>>>>> ========
> >>>>>>
> >>>>>> This patch set introduces a new autotuning which allows to collapse
> >>>>>> hot regions into hugepages.
> >>>>>>
> >>>>>> Motivation
> >>>>>> ==========
> >>>>>>
> >>>>>> Since TLB is a bottleneck for many systems[1], a way to optimize TLB
> >>>>>> misses (or hits) is to use huge pages. Unfortunately, using "always"
> >>>>>> in THP leads to memory fragmentation and memory waste. For this reason,
> >>>>>> most application guides and system administrators suggest to disable THP.
> >>>>>>
> >>>>>> Currently DAMON has DAMOS_HUGEPAGE, DAMOS_NONHUGEPAGE and DAMOS_COLLAPSE.
> >>>>>> However, there is no way to tune the settings. It will collapse all the
> >>>>>> hot regions that meet the access pattern. If the server is a bare metal
> >>>>>> database or big data server, this will also lead to eventual fragmentation.
> >>>>>>
> >>>>>> Additionally, currently THP is set globally. Ideally, there should be a
> >>>>>> way to control which tasks can use huge pages.
> >>>>>
> >>>>> Could you please reword for prctl(PR_SET_THP_DISABLE) like per-process control
> >>>>> cases, as we discussed [1] on RFC v3?
> > 
> > WDYT?
> Yes, we can use prctl. However, I believe DAMON is more transparent and easier
> for a sysadmin. I will rephrase this sentence to explain why DAMON makes sense
> instead of other alternative.

Thank you, I agree to you.  But I just want the pointer be clear.  Your
revision plan soudns like a good plan.

[...]
> >>>>>> Benchmarks
> >>>>>> ==========
> >>>>>>
> >>>>>> Huge page collapse autotuning was tested in a physicial machine with
> >>>>>> MariaDB 10.5.29 and sysbench as the benchmark framework.
> >>>>>>
> >>>>>> The hugepage module was set up in the following way:
> >>>>>>
> >>>>>> # echo 1000 > min_age
> >>>>>> # echo 1000 > quota_percentage_hugepage
> >>>>>
> >>>>> I guess this is the quota goal?  What is the unit?  I guess it is aparently not
> >>>>> percentage?  The name doesn't sound like very consistent or intuitive.  How
> >>>>> about hugepage_mem_bp or target_hugepage_mem_bp?
> >>>> Right, we agreed to change the name. I will correct it.
> >>>
> >>> Thank you.  Because we agreed to drop the module, this could simply be dropped?
> > 
> > WDYT?
> Yes, I will drop it. The new patch set will not include any of these parameters,
> but just the target value for the quota and a new quota metric.

Thank you, sounds like a good revision plan.

> >>>
> >>>>>> # echo $(pidof mariadbd) > taget_pid
> >>>>>> # echo on > enabled
> >>>>>>
> >>>>>> The goal was to achieve 5% of the total memory used as hugepage.
> >>>>>
> >>>>> I guess this is what the above example is setting using
> >>>>> 'quotta_percentage_hugepage'?  If so, it means the unit is 1/20000 ?  Is this
> >>>>> correct...?
> >>>> I actually set it to 500. I will update the cover letter.
> >>>
> >>> I think changes of this series is matured and very close to land.
> >>> Discrepancies in the cover letter and commit messages are my concern that
> >>> blocking this series.  Please keep everything up to date and in high quality,
> >>> from the next version.
> >> I will test it with a bigger database.
> > 
> > Thank you.  Couuld you further clarify what you expect to see as the result,
> > and how it will complete the story?
> What I expect is DAMON to keep consistent huge page usage to total memory
> usage ration according to the target value.

Makes sense, as long as we have a sound theory.  But, I'm not sure if we really
have such theory.  Please read my comment below for why I'm not really sure.

> 
> Should I publish these results as well? I mean showing different target
> values and the actually achieved values. And theses results for different
> database sizes.

Feel free to add as much data as you want to show.  Nonetheless, I'd recommend
adding only data that gives us clear story in a condensed way.  The data on the
cover letter will live forever in the git history.  Let's not make it
unnecessarily long.

If you want to share your findings in volume for discussions, please feel free
to share.  But not necessarily it should be the part of the permanent history.
You can send it as a mail without the code diff.  Sending that as a reply to
the patch series could also be a good option.

> >>>>>> Since the database was not very big, we may not be able to achieve
> >>>>>> high amount of huge pages per total memory consumption ratio.
> >>>>>
> >>>>> I believe this patch series will work as you explained.  But, it seems bit
> >>>>> weird to show a test result that doesn't demonstrate what this patch is aimed
> >>>>> to achive.  Could you increase the size of the database?  IIRC, you were able
> >>>>> to show the percentage is over-achived case in an early version.
> >>>> Actually, this is what I got using the TEMPORAL quota goals. With the regular
> >>>> quota goals, it actually over-achieves the goal.
> >>>>
> >>>> Is this an actual bug in the TEMPORAL quota goal?
> >>>
> >>> You mentioned "Since the database was not very big, we may not be able to ...".
> >>> Based on that, I was assuming you will be able to make the goal achieved, by
> >>> increasing the database size.  Now you are saying about the goal.
> >>>
> >>> Do you mean the database size is not expected to contributed to this result?
> >>>
> >>> Of course TEMPORAL goal might have bugs.  I find no clue from this datta,
> >>> though.  Do you have some evidences that make you suspect it?  If so, could you
> >>> please share?
> > 
> > WDYT?
> I have no idea, to be honest. I will try to test with different databasesizes with temporal and consistent policies. The behaviour was weird to me,
> but I don't know if this was a TEMPORAL policy issue or I didn't set the
> DAMON parameters correctly.

Thank you for transparently sharing your thought.  And this is little bit
concerning me.  It feels like we don't really have a good theory about what
change will make what results for what reason.  It rather feels like we just
doing random experiments and showing the random results.

I understand having data first and developing the theory driven by data is also
a good approach.  But I feel like this is a time to step back and think about
what we're doing.

IIRC, your initial experiment results on the very early version of this series
looked promising.  But from a point, it looked like just random.  Maybe I gave
you wrong change request, or some test environment has unexpectedly changed.

How about summarizing what tests you did so far, what changes in the kernel and
the test setup has made for each iteration, and how the results have changed?

If it has been too long since the older tests, just doing the tests again or
dive deep into debugging of your current setup with the all mighty printk() on
core DAMON internall code can be an option.

Have you also monitored DAMOS stats while the tests are ongoing?  Maybe that
could also be a good debugging option for understanding what's going on as
expected vs not.

> 
> >>>
> >>>>>>
> >>>>>> The table below shows the memory consumption over time. Timestamp is in
> >>>>>> second and the memory usage in is MBytes. Gaps in the timestamp means
> >>>>>> that no changes in the hugepage consumption happened over that period
> >>>>>> of time in MB. The total used memory is calculated as
> >>>>>> mem_total - mem free. The huge page used is calculated as
> >>>>>> huge_page_anon + huge_page_shmem + huge_page_file. The table also
> >>>>>> shows the huge pages to total memory ratio.
> >>>>>>
> >>>>>> Hugepage autotune benchmark:
> >>>>>> +-----------+----------------+----------------+----------------------+
> >>>>>> | timestamp | total mem used | huge page used | percentage hugepage  |
> >>>>>> +-----------+----------------+----------------+----------------------+
> >>>>>> | 0         | 3044.988281    | 0              | 0%                   |
> >>>>>> | 22        | 3160.207031    | 2              | 0.06%                |
> >>>>>> | 30        | 3250.90625     | 4              | 0.12%                |
> >>>>>> | 69        | 3781.238281    | 6              | 0.16%                |
> >>>>>> | 71        | 3822.226563    | 8              | 0.21%                |
> >>>>>> | 72        | 3846.578125    | 10             | 0.26%                |
> >>>>>> | 73        | 3852.402344    | 12             | 0.31%                |
> >>>>>> | 74        | 3868           | 14             | 0.36%                |
> >>>>>> | 75        | 3881.84375     | 104            | 2.68%                |
> >>>>>> | 275       | 4194.175781    | 106            | 2.52%                |
> >>>>>> +-----------+----------------+----------------+----------------------+
> >>>>>> After second 275, no more pages are collapsed into hugepages
> >>>>>>
> >>>>>>
> >>>>>> THP (always) benchmark:
> >>>>>> +-----------+----------------+----------------+---------------------+
> >>>>>> | timestamp | total mem used | huge page used | percentage hugepage |
> >>>>>> +-----------+----------------+----------------+---------------------+
> >>>>>> |         1 |    4489.320313 |            184 |         4.098615986 |
> >>>>>> |        15 |    4581.871094 |            214 |         4.670580984 |
> >>>>>> |        30 |    4757.742188 |            376 |         7.902908253 |
> >>>>>> |        45 |    4937.574219 |            558 |         11.30109595 |
> >>>>>> |        60 |    5147.867188 |            728 |         14.14177898 |
> >>>>>> |        75 |      5407.0625 |            918 |         16.97779524 |
> >>>>>> |        95 |    5668.796875 |           1040 |         18.34604455 |
> >>>>>> |       105 |    5723.839844 |           1056 |         18.44915352 |
> >>>>>> |       115 |     5736.84375 |           1072 |         18.68623317 |
> >>>>>> |       125 |    5732.042969 |           1088 |         18.98101612 |
> >>>>>> |       186 |    5753.601563 |           1184 |         20.57841488 |
> >>>>>> |       246 |    5746.398438 |           1280 |         22.27482159 |
> >>>>>> |       306 |    5752.128906 |           1376 |         23.92157795 |
> >>>>>> |       367 |      5772.5625 |           1472 |         25.49994045 |
> >>>>>> |       427 |    5832.019531 |           1568 |         26.88605536 |
> >>>>>> |       488 |    5813.246094 |           1664 |         28.62428277 |
> >>>>>> |       548 |    5807.621094 |           1760 |         30.30500736 |
> >>>>>> |       598 |    5841.253906 |           1822 |         31.19193292 |
> >>>>>> |       669 |    5982.160156 |           1854 |         30.99214918 |
> >>>>>> |       931 |    5946.605469 |           1868 |         31.41287933 |
> >>>>>> |       981 |    6020.207031 |           1896 |         31.49393352 |
> >>>>>> |       991 |    5988.445313 |           1910 |         31.89475566 |
> >>>>>> |      1011 |    5988.570313 |           1926 |         32.16126554 |
> >>>>>> |      1032 |    6016.039063 |           1936 |         32.18064211 |
> >>>>>> |      1575 |    6057.289063 |           1968 |         32.48978181 |
> >>>>>> |      1606 |    6026.167969 |           2000 |         33.18858702 |
> >>>>>> +-----------+----------------+----------------+---------------------+
> >>>>>> I ignored some points to make the table shorter. Anyway, the amount
> >>>>>> of memory consumption, total and huge pages, is a lot higher than
> >>>>>> with DAMON hugepage autotuning.
> >>>>>
> >>>>> Could you further clarify why it is, and what this means
> >>>> Memory fragmentation. I will add information about memory fragmentation
> >>>> in the next cover letter. >>
> >>>
> >>> Yes, please.  Let's make the complete story of the benchmark.
> > 
> > I'd like to again call out I'd like to show "complete story".  I don't think
> > additional data points that look interesting but not providing a complete story
> > is really adding much values to this work.
> > 
> > If you want my feedback on benchmark results first, sending benchmark results
> > (with your analysis an discussions) without the code change could be an option.
> That makes sense. Maybe I will just reply for now on to get your thoughts.

I suggested to take step back and look back what we tested so far to get a
better idea on theory.  But, yes, adding even more data shouldn't harm us.
Please feel free to share your findings.

Thank you for replying to all my comments.  To recap, let's keep discussing
about the test.


Thanks,
SJ

[...]

