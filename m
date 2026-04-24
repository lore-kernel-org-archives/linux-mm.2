Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7A9BFED3CB
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 13:21:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1810A6B00A8; Fri, 24 Apr 2026 09:21:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 158AC6B00A9; Fri, 24 Apr 2026 09:21:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 070D56B00AA; Fri, 24 Apr 2026 09:21:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E988E6B00A8
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:21:47 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9942C160190
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:21:47 +0000 (UTC)
X-FDA: 84693511854.12.92A6CDE
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf08.hostedemail.com (Postfix) with ESMTP id A4F5F160013
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:21:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=nZPvUCId;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777036905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=16wGkXPwfaEulioMF0Lhct1ImQNDyT+VaYWOkGB68v0=;
	b=FQx7Njz5KCC7Ebu2Wxdu7Ju7aSLcIE0NmTeVgbbdTCNx+5npFH50aGLoGvi8CejMwZraxp
	iUSYToZIxtJpKUcDbFUFS1T6yxjoEBGxoiJr4vHcdSacWh3ptwq3C2dk5C7uUCp1Pst/Eu
	XUqCvWGFcYggYp11sLSHQ46tNYeFrQU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=nZPvUCId;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777036905; a=rsa-sha256;
	cv=none;
	b=e5VY7CJPvxFM3lqiDskzFSWWK8lXwmyqc6uWSBU3+opN3EV5WHcuJM5PAadJiD8FnHvFlp
	iKf1H2MQSc1npIukyaCUEDU33PaVThzjXTMGaLfHm+QEaqgefKSzOuyDqvzf+e2LWp30cd
	I6qC4ipd6Y8CXPeyxDUcGVzhgd9KT/A=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8ee9ec26edaso445895285a.2
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 06:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1777036905; x=1777641705; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=16wGkXPwfaEulioMF0Lhct1ImQNDyT+VaYWOkGB68v0=;
        b=nZPvUCIdgHft3VDNPDqlrHfqWLl4SFi5Du5vbHzTbmlR4kZLvidq8UKW4KU3w/xi4s
         L/aCHT4hEAgU5HZzV5OFvj35ZlB4SvBmI9uEu9vziAud0B2KP8haAE1lZXjJt9HwKxHl
         7YOZ/3Tibp7CaRMOoPO4xKSALiOtcKWJQkbT5uvCUqE9sU8REkqJEf0JcXcAW81STLoB
         bsGjCLTJ7fXEcQWbhZko0Xcch4zgTj5x7snRdEeUfjGxzOYoYSUYPpvZVS3lUUTWmUxf
         +2mVMb2rqn4h/re3BoOvm7mkKgA36aKzGavDi7qUrbmuV7R8wj8paJQme8E1pLwtTgeg
         T0Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777036905; x=1777641705;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=16wGkXPwfaEulioMF0Lhct1ImQNDyT+VaYWOkGB68v0=;
        b=sH+Zhy1pGODcx/Nl7YLY+AXU9L610c5DMT/m2luB7tKgROfhSUUEgaq/4ZQgszXp4B
         Bk+55O8VbLTLzmbCfMzkT5z0HI28n0/2eLStixcr+AQBQngS0Ic6p3fqOL67q0pAPq5b
         DYM/yQHdsktLG8qH6dsVt30gbRactlnwD6jtfKs3y+6sBaQzfW6HymdG/8+m76+aiw+y
         1TKIbnv48JcEniL7R79nNB5V69WHNDyalzz2OUDMgLDW7er1i5S4icO7Kjt7MGl/gN3t
         7qYsoKc/tmpFOs6YyJ3ay+Y7JoL2wd6TzVJjKCoP9FCy5789Is545FwdRenuckpjrHo6
         SVTA==
X-Forwarded-Encrypted: i=1; AFNElJ8DiyAlv+S84jkP76bpwRrsxUgpBIiu2olzW9f2wZ6azbKsvwy55icUAYJs7OXnfdfO07LY5oE9Ew==@kvack.org
X-Gm-Message-State: AOJu0YyALDX+geKOuWTlUukwmOV8NhZTXjfZBceVGz7qG5tvHqlXwszk
	eygT+PCozNP458R0wOA7/VmHOLbYdQZEgJwHePF9BOgQyTpPNgGFoZqjJfhlQVXu0eg=
X-Gm-Gg: AeBDieuZ01jtxqmcTNfue4lwn9QgxQGBZSTFB/slzQqfGAXceqLPmlmsvkgt3ciGOmS
	5TBtUgjumkvEvsw/gtXSWDXMOoe/8imqUiqvsNjRme28hWnXIKeEp+IvSdbj1qJC4d63ZmUy2UV
	K4bz2qx/AeYMY9PGxhpl45XS2Rq4RmLtEnl/IXJeZO9CHwFFHhob7Qtwg4kKZ/BAuMzWVJpccpL
	2gNk2UgkiKDaL7huoKrbfr7zobdkMQMg61evUQ+TGzf7yr67aZz3FiX+KhqEsh9gwbAyYt8Xl+C
	XFB+KbZPyMN17siAhkUsaivHvAApXC5EN9rC9dx4zNRJ/Ss7vRQJ3sfXgFHkloQtXsM7qTgMrAV
	0GWKQcDwCrcVKJ1uePEQgC7qGLvWHQHy2qpBIsJn4aWM0axV7bUhX6rwqr1ha2fA5mGiEjSqkHk
	MWOdoUcGP7iB7pwJmFcBhc7GIWFQYDaDFb4yeTsK642nirY14dFmh0lk9dMco5DPFT3WLP/hG+5
	pROJYbXRzUL1Tn0QA==
X-Received: by 2002:a05:620a:e98:b0:8eb:49b5:bdb1 with SMTP id af79cd13be357-8eb49b5bfb0mr2404787385a.18.1777036904421;
        Fri, 24 Apr 2026 06:21:44 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-70-94.washdc.fios.verizon.net. [173.79.70.94])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e7d8edc2b9sm1999356785a.23.2026.04.24.06.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 06:21:43 -0700 (PDT)
Date: Fri, 24 Apr 2026 09:21:41 -0400
From: Gregory Price <gourry@gourry.net>
To: Donet Tom <donettom@linux.ibm.com>
Cc: Bharata B Rao <bharata@amd.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Jonathan.Cameron@huawei.com,
	dave.hansen@intel.com, mgorman@techsingularity.net,
	mingo@redhat.com, peterz@infradead.org, raghavendra.kt@amd.com,
	riel@surriel.com, rientjes@google.com, sj@kernel.org,
	weixugc@google.com, willy@infradead.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
	nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alok.rathore@samsung.com, shivankg@amd.com
Subject: Re: [RFC PATCH v6 3/5] mm: Hot page tracking and promotion - pghot
Message-ID: <aetuZQFtb2dR50cv@gourry-fedora-PF4VCD3F>
References: <20260323095104.238982-1-bharata@amd.com>
 <20260323095104.238982-4-bharata@amd.com>
 <250e68f3-3664-4148-bfbf-52fd4230a3b9@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <250e68f3-3664-4148-bfbf-52fd4230a3b9@linux.ibm.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A4F5F160013
X-Stat-Signature: fttm1hir1gehbbjm19dfbriwysbxa8xf
X-Rspam-User: 
X-HE-Tag: 1777036905-405681
X-HE-Meta: U2FsdGVkX1/ZUAZOtLuIhr0DTmpMYQyMhrDTaBGKmyeXcFEzvG255TIvzFpi8j65MIA81PWQpJm50mH/HtvzWH+9Y63Xo8hd6YNS9WmIFMYcJhpQFpfc6rdhS4ntZpolrYSi+PPTJNjYDAnYWXA1MmJ2i7YJ7s7PAt8obWNFrmhm7VX2ZBl8FLA+gQw91Q5PGHqj1SJW2bg1YDtb0npa9Xp5KBN3adaXuXzDvTBKH3rhzEn9VjL0Kxku3+ru/KSGF9/1Y8OAK6epOxRwWt+xVS0L7f6t6lx9GlVgGKO9IuiAw3ZJ26AR/M86xGZYTHOdL/34QkUyv977Wd1859XhjxyWK91bjDXgrY8U1VxFNJQxSGaRepC2QP37m+4Ff8tGUD1Pdqd23cvGKTXYRcUc5SS5djkbytLZY71bkF9RzTBvm8RTsAR6Fq8MZFpk2U/RdyC6E3izhfjQyS7hOP6EOflToLRH3gpQF9ceH8IgAVTg48xsJQnfJ0a9loEMyFSOyLlW6TacxEo8Df7NaKcj594hC25ZdywhP8/rexmranvtqxAlCBzIgucepFVo5TQ81syR0Y/S6xkxp2BoCDd6pRqJlUWVpDzOvGmuYNh0LM42HZTEdRbjKFjPIKwpwht4swFyEizIJuko4smP25GJbc0lKDuTRVVNJ8OBvSz4gSgtmNrjDA3jjH0pPswwa+UiTCGfPKsbMBSJzvLQEjdfLxY3fKoOl3bURqWPsEys3B6cNyxtV/onGGtm42hXY5qrtRImwj9zcZy7QjcJcUDwYzukZfeRt0RhxZGAEiJZDxkblF5jXNjh865EZ99/18SQtQ8cUrqC81JONsKsEaYdsRGDhph9/K1V1nOCFUfhIxFLzItOnXO9SX8SFVGj1UsG1GemKtL7RiBNShFBmQn+77qSSzXsRl+mtRqa0EN1VMyZ09074vSyjYZJkLPcfJvyemJH5igOWBvLOeySRIT
 2Oe1kdth
 P4h6dQRkhl7EagSisP6/u1Sur7N5i35/ZW4w98l1xzUetaqfRhCRXco/LeQgfkJl5UI4q+B3ScMv02+j6lA2/G22JCEnENEtPr/tlOINmMLCxrH0o+LPVQ1lXMDWQAtFxuDQQ4c15LMvAGsviCOGZ3kxqMOydFtnTItWRrMsf6XEurxXXxP4En5kW+yvLQD2oOJZs5CB8yyuURkE4eyr6GFystFaAXIwUQqDQedtfRV/xegprI51tBl4uPCUJfJLoWsbiI+AQW3K8GBKXhHJHrqOKxKPkM2D6w0BNhlUY88hp2bN38kGXm3wGC91bkyX5/cH90RBYTqy0q8KFgK3qms7FzlJBwjQX069ANaIy4Lir/Bjt9PJwPfwjayeXG7p+HhS78dG/I8bRy6QCQkSyiQclflXVQb7mTAfAGMynjbE09JM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 06:27:02PM +0530, Donet Tom wrote:
> > +
> > +	/*
> > +	 * Record only accesses from lower tiers.
> > +	 */
> > +	if (node_is_toptier(pfn_to_nid(pfn)))
> > +		return 0;
> 
> 
> Just a thought—could we check this at the beginning of the function, before
> the switch case?
> 
> 

Can you please trim responses to omit un-related code? Not all of us use
mail clients that auto-collapse quoted regions and it takes a lot of
scrolling to reach here n_n;;;

> > +static void kmigrated_do_work(pg_data_t *pgdat)
> > +{
> > +	unsigned long section_nr, s_begin, start_pfn;
> > +	struct mem_section *ms;
> > +	int nid;
> > +
> > +	clear_bit(PGDAT_KMIGRATED_ACTIVATE, &pgdat->flags);
> > +	s_begin = next_present_section_nr(-1);
> > +	for_each_present_section_nr(s_begin, section_nr) {
> > +		start_pfn = section_nr_to_pfn(section_nr);
> 
> 
> I may be missing something, but in pghot_setup_hot_map() and
> kmigrated_do_work() we seem to iterate over all memory sections. On large
> memory systems, could this become a bottleneck right?
>

I think this is going to end up being a function of page / section size.

I would hesitate to over-optimize on this early-on, otherwise we'll find
ourselves re-building a bunch of DAMON functionality that chunks memory
into regions and such.

But it is a concern.

>
> Since hot_map is allocated only for lower-tier memory and the hotness
> information is primarily used there, would it make sense to skip scanning
> higher-tier sections?
> 
> for_each_online_node(nid) {
>         if (node_is_toptier(nid))
>             continue;
> 
>         start_pfn = node_start_pfn(nid);
>         end_pfn = node_end_pfn(nid);
> 
>         s_begin = pfn_to_section_nr(start_pfn);
>         for_each_present_section_nr(s_begin, section_nr) {
>     }
> }
> 
> Would this approach be reasonable, or am I overlooking something?
>

re: your note later on - kmigrated doesn't run for top tier nodes

kmigrated_run() { if (node_is_toptier(nid)) return 0; }

> > +
> > +static int kmigrated_run(int nid)
> > +{
> > +	pg_data_t *pgdat = NODE_DATA(nid);
> > +	int ret;
> > +
> > +	if (node_is_toptier(nid))
> > +		return 0;
> 
> I might be missing something, but since this function is only called from
> pghot_init(), would it make sense to check the condition before calling
> kmigrated_run() to avoid the function call overhead?
> 

this gets optimized out when static is inlined and optimized. 

~Gregory

