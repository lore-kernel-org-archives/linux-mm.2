Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DF63C88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 07:00:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24D806B0095; Fri, 18 Sep 2026 03:00:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 225196B0096; Fri, 18 Sep 2026 03:00:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 162456B0098; Fri, 18 Sep 2026 03:00:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA2BA6B0095
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:00:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 575B4405E8
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:00:07 +0000 (UTC)
X-FDA: 85225983654.05.D69C75F
Received: from mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf31.hostedemail.com (Postfix) with ESMTP id 692FB20002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:00:05 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JiAGQ2dD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789714805;
	b=11ciVyMeZyOL+G7D3gn5tE61kYJ/dfy2CvUGMc9kEQz9Z4Fjah0J0x26MMbJ+poMBmpevg
	nZuMWE2PE/bamiGFsyHfPSJlw/4NQ5kP05U08ev9J5tHaEHalSag5mRd7f227vLloG0EnV
	DBG38qVwwGIgdbDnJb6VE1gV7/tbB04=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JiAGQ2dD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789714805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gVtF4fTpRBJLg2adJSOtRMWPDMu2Q/zDsN0agcb0gHU=;
	b=Ok+qtFr8xaej2DT/RQ91VI2iiROpPMFa38yKBTyVDPn7FYw1xnEkn0n/Pm1rO7v8nn+2qi
	j0Mcstk989ifcapsgaZqwLp11sEfXmeQdy9oBfDepN6E2gUzflpnO5t+bzMHfUmmlpeYRR
	gIsRX4Bn1z4/3T9E+U6JnxR+AiwW7Pc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5AhHIUfW947DwN3a6RXdBqv5Jg4ND8aDfO50FS7r8Ng=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789714804; v=1; x=1790319604;
 b=JiAGQ2dDVHRzkONP8nYitr16QOtQvBEDWuhFHjQfTvRcs2KkgKicFJl9QuJ4ZXQw4sO97DTW
 JiT6rBcE4NHZEzix7tTWyCC5BqwzoSCAlatrKXb0clJXfaItQMpYblRzUCZ2niHnoh6gJrCs4fE
 zDB82Uy8503PWrsxVTFsynjA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d10ab4f1e424aaa1;
	Fri, 18 Sep 2026 07:00:03 +0000
X-Mizu-Trace-ID: d10ab4f1e424aaa1
X-Migadu-Flow: FLOW_OUT
Message-ID: <fa0bdb5c-3903-44bf-8d14-91d77e32b201@linux.dev>
Date: Fri, 18 Sep 2026 14:59:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] selftests/mm: init page sizes early in
 pagemap_ioctl test
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, gourry@gourry.net
References: <20260908134117.84405-1-zenghui.yu@linux.dev>
 <20260908134405.84448-1-zenghui.yu@linux.dev>
 <b1f2a146-1a61-42bd-98c5-fc4380b6ae49@kernel.org>
Content-Language: en-US
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <b1f2a146-1a61-42bd-98c5-fc4380b6ae49@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 692FB20002
X-Stat-Signature: 331rngzo1iwkxy57eaei1ctaqk4gie79
X-HE-Tag: 1789714805-628642
X-HE-Meta: U2FsdGVkX19nmbQGK8zJHXHKn1nKZsPJsB7SJt5aLQ/UT6aAKoESyFfKCYYYOUwFWADTrsc6ZroVJTN9aimtIU7yMAS2iq6KOX2A5eqXw5nunUDPF9q2yrBTmsX8A9Y4xLJzOMwaejnoplxWm1GPmgSs/o2E2cEMIkmvSDD6VdRf0sF5IpBKqg3I06YZ7p8lpfAeuH1HvLM5oubKvBzMfkAj0MbuOJLLToSjzFOcGSOeDyyqPAQE3oCrylqN2OUbWHlNpjqGOw91jgts5of+sektWMY/OdSPJeIKeSCmFYaj6prJ58z6YjCqfWOG5YruvIG8BP7XyHXXLBrnZIkx2S9ndDQhNWqfV457yEVkN82eDlcQOv2KLlXoIjdmbd4IrbVfvlJcAhcKFuM/Mp0CcJWSv+7GcA62EbeIWZt/QWyPwJsvCX6TPP6yfEn64g1zaMG7Vmo4VqEIkJ/hTQoNJ4Ns4tomhhifLYEu1dmHSV90/Nf5KVT/7XXyLmNZxhaPPo7kRHuZqn3aQ/DhGVjmnRK0ZOB+LI564SUBTwqBJHf9WGKn3ecblv8Sgj2AaZOjH4k157WVfQfPVHJhd68qWB1ZTKOODFlCoMIQBFkIBKs7IKBa16Bgdb3r4MKZuaK10neUz5El6zRo7LprLqr8TvxEQM032jRDGU7MZxIuL5Hh4Uxw+XuJ9tdgCAaIHQks4Z4iHkbymkCytofh6Skz+fwG306Q+/+82i7ny8EKArf/4rVb/sS4trP/NJSrM8n5HDA391PaFawIdHAnYq0sY7zB8GH3rwCQESYWHAA1bR/htR4VFWT+LLEIpdf8taj5mD1jENm7Pi2sCC7i7Az0+eAz0Ap6PnGVqE4xBXgfCht0w2f8ZyyAZHLrCHuoumQ7mE4xOZ8oDZXKlC0f3xH7ZWZn6cCNJob7kWLNq+wnMZ+eJKoZOVnj2i07acfHhxvjeSeA4bfRGEZCEgd92zX
 g3DZkjvh
 64s/nggEWhDW78mstqLq6tF8TLymWNY9Wc/YQcZlEJGvKhXd7RvHFfxi9+U4iBcoNaLKcnAICeo3V3QVo/fxkX38k2a95peS/ItGWN6+rV4QV0nQCHK0tLWGPSPkOimiA/2yixoxn9IDfQ5lrdsn94PSs7yOcenHXUDXfXqnnTpVoSYK8631Ph4J34VGueTs6UqpvNWvo0aVND8avW8HMTmiVLacGpFAcoJzLtb8IPV0qXYrbKfLm3DFX25ba00NCVg+40z7lZeX0A5W0bYhylERa9T3BEuStQ2L/FfVQp4v6gH40vFvJuUSE08AGzgwQUNgRxo/QFElRJT5NTJHM0e/8IkcF3+YCIv+ekPtp7WcUj3PzjXghO+anMFK2mCtUiJUZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On 9/16/26 11:30 PM, David Hildenbrand (Arm) wrote:
> On 9/8/26 15:44, Zenghui Yu wrote:
> > From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> >
> > Initialize page_size and hpage_size before calling init_uffd(),
> > hugetlb_setup_default(), etc.  That won't fix anything, but it is safer and
> > saner to get these globals set up before doing other things.
> >
> > While at it, drop the page_size parameter of transact_test(), which is
> > actually unnecessary.
> >
> > Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
> > ---
> >  tools/testing/selftests/mm/pagemap_ioctl.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
> > index 1a87b7483316..d9a4fb782ecf 100644
> > --- a/tools/testing/selftests/mm/pagemap_ioctl.c
> > +++ b/tools/testing/selftests/mm/pagemap_ioctl.c
> > @@ -1489,7 +1489,7 @@ static void *thread_proc(void *mem)
> >  	return NULL;
> >  }
> >  
> > -static void transact_test(int page_size)
> > +static void transact_test(void)
> >  {
> >  	unsigned int i, count, extra_pages;
> >  	unsigned int c;
> > @@ -1653,6 +1653,9 @@ int main(int __attribute__((unused)) argc, char *argv[])
> >  
> >  	ksft_print_header();
> >  
> > +	page_size = getpagesize();
> > +	hpage_size = read_pmd_pagesize();
> > +
> >  	if (init_uffd())
> >  		ksft_exit_skip("Failed to initialize userfaultfd\n");
> >  
> > @@ -1661,9 +1664,6 @@ int main(int __attribute__((unused)) argc, char *argv[])
> >  
> >  	ksft_set_plan(119);
> >  
> > -	page_size = getpagesize();
> > -	hpage_size = read_pmd_pagesize();
> > -
> We have some other code rework that part, so I expect some conflicts for whoever
> goes in first.
> 
> Why not
> 
> initialize them right when defining the variables, marking them const?

I'm afraid I don't quite understand your suggestion.  page_size and
hpage_size are static global variables which cannot be initialized at their
definition.  What am I missing?

Thanks,
Zenghui

