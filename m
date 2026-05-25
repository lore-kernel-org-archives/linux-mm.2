Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3F73CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 16:38:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F34916B0005; Mon, 25 May 2026 12:38:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0C276B0088; Mon, 25 May 2026 12:38:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E48C96B008A; Mon, 25 May 2026 12:38:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D5C666B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:38:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7F964A017A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:38:08 +0000 (UTC)
X-FDA: 84806499456.29.13B4615
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id CDE832000A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:38:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=faQpIRSx;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779727086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q5U54gS45JuVd2BwEnLbeDvEWQ/J9bpKUA7tXloYeaY=;
	b=3woN3k0v5xrK4TRY9SzolsOBVusFG27R/r1nkk1qYy7k7V9ZvOGGiw6Z3tRQ9PUmNTm31+
	TuVcO5IpI5CceLLAZ6dCACLLO8X/iIoEtO59OvhEGnd8mVHANMygQrZOFtWAGGQXMMi7mJ
	PVi0w7xJBIRAnWqItImaRqKl2Lmw+N8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779727086; a=rsa-sha256;
	cv=none;
	b=2FhWeyZCcX5zsS6fQbD421PCJNEKQHVT5INYFGKmc9JH7hXNHaW/YWSsEp2NIR+KSve8on
	O21275BU7aMkvhKZjqf7zyw5+0eEguiIGHtI9lRPB2l5GpR43EZtnoA6ONq3lR6OLGKxRX
	vgQK8xxDJIT8nUCtOm+2P6DobUmPwfY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=faQpIRSx;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D384B404DC;
	Mon, 25 May 2026 16:38:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4461F000E9;
	Mon, 25 May 2026 16:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779727085;
	bh=Q5U54gS45JuVd2BwEnLbeDvEWQ/J9bpKUA7tXloYeaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=faQpIRSxTi5bRAhXgEFBkSGcCpMWmoEBQs3V+kx85/StV2fFbEp+jG3cmfppSnCPO
	 wiJDLxDLp7tie7/z5tNc2xuSfsVnKNn+z5VoegRJ1mNo0/YY//ayiIDiAMZU9vX76k
	 sytkrbIqHzhiENqIGnkBURa0qlkEsRe2oXEK/VzXyJL5Ud5w+GQgpQBNT9FIrdDxZI
	 Tgecy2eUp9mN58jnbzLIq3M1lXFoIvt2md9QOyevvLgGuceeJUNJaa1IEVr7Oexwiu
	 qc+9me8FnL4jWSf2hlJXUTOBv1wqF/Ozei2UcipFUy9c2PUx4xSkNh7mE7RxV/8hKa
	 RbKWPmi9Z27ug==
From: SeongJae Park <sj@kernel.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Shu Anzai <shu17az@gmail.com>,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/damon/core: detect internal variation above max_nr_regions/2
Date: Mon, 25 May 2026 09:38:00 -0700
Message-ID: <20260525163802.8667-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <9cc396ae-da42-48ad-97d7-213208884ee5@linux.dev>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CDE832000A
X-Stat-Signature: trmspfq4n39sdmxsg3o1hxx64e5crk8z
X-Rspamd-Server: rspam06
X-HE-Tag: 1779727086-537231
X-HE-Meta: U2FsdGVkX19oECQY8+eNF1zvs6cjHlfFNTZTRPf/ffeLc1d/qNC+FY4HFcfDwp4LpwLUsVwAWHAtMprgRixJW/vKkBVB4HveL2v0RxtQUR6EpfbO2rIhSs6Fg9bMYiSNqyfQB9Ccqgo9lfPkVpX73T1jkSkJfqsIDJENvzYXzPMDGnJOCnJHiGDfzqENLE/9yzQfAnEYG9mMqHo1AwAp+rQ2nn1jKZBgFz7ALidU/qlu8vUH1tQAXeKvQMSczIOwwFHMgGhbt1FBFNcdbcNE2SxdOxKj9gUrVfztnpOvcb0bkF+tJDHrUtAK/Rx+JPjTCRFNVCdPA9VqDHJ2PUdBhKYqa3OJqdptVndtcjpCpSyFrvSE1QG5ILqoCtYVZ6wrlLojPnCznyEy3xvFWf2A3uAn7b0LmsC7hXihE/ixtiQOdeRwcTDB1sCyitLmCPHWhzc54c4XKOYSpYDgHXLh4sNQl3YO3qm9q6KO/+Y4Rzg2Vql2Eokp8U2Vzr43vck9ULI0d5g+puvi8XDVlWYgCzGuiS3IU5JI9Y4IyuvQg0Cz1/H/yxZ1PcrL3VSbFbPR+uCbvTm+PEaqFv9ML++UWZ3/KzmxZqtMrCSqVGTiNYnH6dIM3YZWJrG+8hWXC8Jd8cIVSIYHOVUSAZs2ueTo02mycrCrYlZZXtBF3SXeJJ/3ZAFrkGjavPqoL5dAaazKdhBneCFzVqSUzLv9P/z6OpLLPeQE4zze6h+wq2mRTgHZhHIuyHBGyEr0TYzb8ANrcdNw90frd9q6/SMAc95V4m8/4wPGzRXIJWRxxYFY4Huj/Lr8C25k8eA8NYEO2jj98YUJrwKMLtHutSDnEYHKf6GMR+ue+CGA71pcM4Xcvt21Q/KEAvvY0JyCSCWSgNw9BteclJJFFfC6n4r3PjUfccczplNgt26fZ3soXtXozhih0Y1OFFsoDtG+vtmXsh6zGzi7s/Zof+SU7HQWPXb
 eNYzZl6j
 FQOgfS+0LiSqaCVtETMvhH6RjI/du+qmf/rQJkN5qVX82MR7Jf+Yniw7UZESO+d+X+tCzNSI0osTWml6ll2yd7lJ/RSk0XTXlCGLkCiWmdcuIwU7SQO3mfMChOSnYTEe1K4531mwxFgg4kICAZGj6D0LrOF3nnZgUuORqd/61szVBjQU41Oz5iHCUTTfpX5ZY8JEN1CkKjd12Vv2nT38der3bLRc/uiws2HzWsH7ev+gMeH93eES2hec6rioIEH+UN2uggGoq2E3boSGjmjtkpnveJ5hmk0Dy+NMb9rKIEdFILxHGey9tdt6T819ZXdvMKxSjlHEqtbVyLXW/v/xAWjW9QKld7ZxuKIHPPVqY3YMiwoWsPHHT0Di2Uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 25 May 2026 16:09:42 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:

> 
> On 5/23/26 9:43 AM, SeongJae Park wrote:
> > On Fri, 22 May 2026 23:11:47 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
> >
> >> Hi, SJ
> >>
> >> On 5/22/26 10:42 AM, SeongJae Park wrote:
> >>> On Thu, 21 May 2026 23:07:11 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
> >>>
> >>>> Hi SJ,
> >>>>
> >>>> Thanks for taking a look.  Quick replies inline.
> >>>>
> >>>>
> >>>> On 5/21/26 10:30 PM, SeongJae Park wrote:
> >>>>> Hello Jiayuan,
> >>>>>
> >>>>> On Thu, 21 May 2026 12:52:22 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
> > [...]
> >>>> counter was just for convenience -- easier to cat a sysfs file than to wire
> >>>>
> >>>> up tracing.  Even the tracepoint covers it, It's cost to much for
> >>>> Grafana to just get
> >>>>
> >>>> a metrics by tracepoint.
> > Out of the scope of this patch series, but I'm interested in how you connect
> > DAMON outputs to Grafana.  I believe that could be useful for many people who
> > willing to get some fleet wide access pattern.  Maybe worthy to present to
> > wider audiences, like System monitoring microconf [1] at LPC?
> 
> Honestly it's nothing fancy -- we just export nr_regions as a Prometheus 
> metric because it's a
> 
> performance-relevant signal.
> 
> 
> Vsualizing access patterns is a real pain point.  I have a small 
> AI-written script that pulls region
> 
> data and turns it into a webpage I can open in the browser.  It's not 
> live like Grafana -- I just run it when I
> 
> want to look at the data.  I don't think Grafana has a component for 
> this kind of view anyway.

I agree it is difficult.  So, you are using DAMON for not data access pattern
obserrvability but access-aware system operations like proactive reclaim of
cold pages?

For Grafana integration, I'm trying to use idle time percentiels as the "format
for fleet-wide aggregation".  My previous talk [1] at LPC may give you more
details if you are interested in.

[...]
> > So I was thinking below as a suggestion.
> >
> > The basic idea is, choosing the number of regions to split based on the
> > remaining budget (max_nr_regions - nr_regions).  I'd prefer making this simple
> > and lightweight.  So suggesting something like below.
> >
> > void kdamond_split_regions()
> > {
> > 	static unsigned char rndseed;
> >
> > 	budget = max_nr_regions - current_nr_regions()
> > 	if (budget > max_nr_regions / 2)
> > 		split_step = 1
> > 	elif (budget > max_nr_regions / 3)
> > 		split_step = 2
> > 	...
> >
> > 	idx = rndseed++ % split_step;
> > 	for (; idx < current_nr_regions(), idx += split_step)
> > 		split_region(nth_region(idx));
> > }
> >
> > I think this might be similar to your downstream change, but what do you think,
> > Jiayuan?
> 
> 
> Yes, this is close to what we do downstream.  Roughly:
> 
>    void kdamond_split_regions()
>    {
>        budget = max_nr_regions - current_nr_regions()
>        if (budget == 0)
>            return
> 
>        split_step = current_nr_regions() / budget
> 
>        for_each_region(r)
>            if (get_random_u32_below(split_step) == 0)
>                split_region(r)
>    }
> 
> And I like your version better -- the step formula (max/budget) leaves
> a margin so it approaches max more smoothly. I'll try your approach first
> 
> and test it in our env.

Sounds good!  Please feel free to let me know if any help is needed :)

[...]

[1] https://lpc.events/event/19/contributions/2075/


Thanks,
SJ

