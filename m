Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C11AFCCD1A7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 16:06:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EA418E0023; Tue, 21 Oct 2025 12:06:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29AB58E0002; Tue, 21 Oct 2025 12:06:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D7DA8E0023; Tue, 21 Oct 2025 12:06:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 09EAE8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:06:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A4C631A0632
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:06:03 +0000 (UTC)
X-FDA: 84022597806.06.EFB7C73
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf18.hostedemail.com (Postfix) with ESMTP id B68E51C0018
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:06:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=iM3kdgqT;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761062761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7xSrJWJ2WsVEF027THRDF2lIxxafjbZSNr6O9ZfI3lw=;
	b=ZW85EvyOoOxtD10QwAUoKb6n9+LwnC7g02H+JyJb+CJ0FfdJLeiV+p8/YF4rh3ItP5W77m
	kqpGr/7iZtukRkj70Y0nT9PCd6uISRJDg6eJaQk00HA1PHlrkxhnzyhojMMdD6tkhuNp/h
	ac4gr1Sj+KpFt2vS77cpWnZrwA2mDo4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=iM3kdgqT;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761062761; a=rsa-sha256;
	cv=none;
	b=Dr56CP8gWKFBSODSfdCc0IWQ1vSKYKkQyQTZ3cwn1I/15eSuiMqhl927EE6crD6K1HrQCT
	aOebi3DrwKsbPl3YHjVh2uIikXPxJGI6ykTI0wf+c2NwLgq2IENsbZaO/HHbhtCNEIJW6T
	x6P944111LDiOxtMmOQM/NB9ILz53Hs=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8906eb94264so798856685a.0
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1761062761; x=1761667561; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7xSrJWJ2WsVEF027THRDF2lIxxafjbZSNr6O9ZfI3lw=;
        b=iM3kdgqTdiUcV5Y1h2MTqtes8D2rbCjZvcXMcYQp7FGywpQBBsJ3YSAuuc1hTJWMg6
         ulxWiHXc6oLlDROr4eR1Zd4Wn1hZDchmLwBVLAgA478HoOJHF/Sw/ch6NWIlkucVtO4O
         Vc5CLk6JzG4B3NDkJ24QKk7cTA0rcyCuPXHuIewoz6c5ZA4eLJd0olcC8J2tXxhqnWHr
         fxtybjfDVxdexKuzC2OHZDKQWyvqeOaGwBufmUxN9djNvBY/pProj6hTrKvT/NRCYiPH
         y9Of2HQHLszBPrFThhNP9idjJAN8eztMh09p2MrGHUqEoS4OCDHcHfV5jSvNVLdLKLLK
         KSrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761062761; x=1761667561;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7xSrJWJ2WsVEF027THRDF2lIxxafjbZSNr6O9ZfI3lw=;
        b=lYMlC7AupEyv6CTCtRXVNWmMmn/XVN/P2/wWT6OA0bz/0sZ3MjmmyaWn5xSREtx+Zw
         yuRkOsnMPMyRxiFWzUMN9P7X4wFXku3+mw9M9839rm4Wriemr7IcuPuV8ID45m6aVh9v
         jy+chxJuPwEYl58lQzWcQYPqamPdsn48n3QEwuEx7VdQwIJxC+iP/IETiWlX6TSk8fEs
         CxCfyRPjPEYkFvE2RE7qjb4ivCtIAHZMrIA80hqB1vRu5SxP/0Ble1wnhjk9azy1Y8GT
         VfP9UF4xoLSQilU8eBluIN9GFYXVmpvdCVEjByCvlUblqovAEIQpM1wo0Qux27WFTuT4
         N1Og==
X-Gm-Message-State: AOJu0Yycjn4r67ocBa+CRBTfm3FGhDggfRQVrzNcSY5ob2TM7oQZ4bqH
	JXC7t2qmLxfF3g9Er8n+oII5MSr14JIMUOKhi/bXBrXUN8oy5+pM4BnEpdkHLKIUgj8=
X-Gm-Gg: ASbGncuk5yRWkKdXfMYTaF3spQvnCsh/v9JOGLuSM0hQjZ5i/VsvbSGir5xD88Wpzkb
	puKcdoMQmYpTLmqGQzliShPcgrt2TkTI9jLcOoqnSEER6i4Y/3wqXEH3rvfwJB9FESi9sTKhHgc
	Dy6ChZ9oSl8lwiGmWgA27kWSr2Hf5tkipPPQ1X6qWMNrq/Cwd1GI2vnR1K8Vu/qhN5AmxFUFLnt
	dw++TxbKDydpf/F+fJ+zKN4Vl7G2BZWLb3QyTz0tSHYzBM6mfWN7tXbMRZBLF5yAYVHfXZjf/K6
	RsbdOjpIZxaUPl+xO8nT+p3udR6tcigI5Yh31dFH263Mxqi9KobdBdhBcTrB1jw5YRsjlsDa9DN
	vKx5lGdMGu1P5GhjumKyaFY/g2S3v4aozd+iQVSqXE+PD/e5zjsPN5jh/ulobYPUTXaxz/D+mln
	8vu3YD1Aa2DBKJojLvp6fuCSjY80wmrLvC1WtOzwFxcGnSTyzILEH3idhGBB4=
X-Google-Smtp-Source: AGHT+IEozD5cdRIuXKqRZBVnxsUqJM/nYy2kEZY26uogQy1cQex4MnUvXAFA8vicpnFfEW7AKfS0ig==
X-Received: by 2002:a05:620a:4446:b0:892:a186:6b50 with SMTP id af79cd13be357-892a1866d2bmr1219386385a.79.1761062760478;
        Tue, 21 Oct 2025 09:06:00 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e8aaf34313sm75504191cf.6.2025.10.21.09.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 09:06:00 -0700 (PDT)
Date: Tue, 21 Oct 2025 12:05:58 -0400
From: Gregory Price <gourry@gourry.net>
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com
Subject: Re: [RFC PATCH v2] page_alloc: allow migration of smaller hugepages
 during contig_alloc.
Message-ID: <aPevZplPtDUPZFUn@gourry-fedora-PF4VCD3F>
References: <20251020210816.1089910-1-gourry@gourry.net>
 <10402943-b613-4bd6-ab78-f34efa74a95c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10402943-b613-4bd6-ab78-f34efa74a95c@redhat.com>
X-Stat-Signature: om1n9spaji9zf6wsotgfguesibe4ug6s
X-Rspamd-Queue-Id: B68E51C0018
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761062761-666619
X-HE-Meta: U2FsdGVkX19RRIRrYj8mdrZAOqgqJGq1fqfCfNYY0jntcndPhCAKUgtyMlCPrRizmY0N2Lv4mAKsMuvvv66dwXCrG8J9xyoc/jgK5S6bOxig6qrrFjzgYTOe3bthfDdzSUNTqIk+bMI1KDpo+F2blmYm55QjRKeMKxp4uEQUxhFJI7hl0yEewxpnNVwO+baNj+AOzWyTTsLO65AHWhW/tvUHDafDsqjIOaiGna4pukbaHUFuLIGyHf+ZpEV2qxc9ztEpAkrcrXvhPIK70y4FaYHUNLbh4GB3U3T3WxYEWohbt1LOJ6GuHNZbFzz9VMZM8qL6F5KrkSq8u/v1+7Xllp/te75hqNMHTbdHNw8YLRRbXubAwffaOqOG8T/4Au4nmDt7D7gTPuS8sKcTh+H+Od8YQ1lqHndZ97GLk/XXPnVREDk9M3QhqbIgJjorZczaLkkv5UytbPp3mAvtL1doMmwStamCXjmnSv1tKGCacTwNo2wdexYl3hEgxp/Rj6fnbAsV4V0KogQWf096XwB2tOJ1ACuLpXHg7H71I6rwOkYgeLkisjF9t/6M9gE+4jkvJLybzomN1JfyRYG4t4RQ449vwOc+TutMObdbs1sQ26WE/LeeUM54CE5A1KWSRkM4IgsVC7KSrHmw9GX2mqTQkx0LxHhdnOqxeVN31mw4wWl8FslNZAcmEvJAXlbmkSXCOf/qclrmR+uL/TtkeX7A3btd+urvMOcW8JyuLzvUgwxv3HEj7qTrrsVVoMqGc4bo/hS1igbjzemZnQ2duqCiSWP+U1neDzowaYmx1AWYwcihEpbX8uC8YOMutFNX8MvDd23lqOBblhbQyuY0EMond7qBLdId6dPAFyCMINVbLARB4DP8ulErwk+aMkAR8W+N7iVY0hE15cdITVBWT2cfWwtdPAzZ0ui2oV4ek5zMYT8JyRajkQ+BlOF2fa27mymlSVPjGIjtwRDgrIAdpf+
 g8mc8YDu
 I8RRxZ+632A8EEV90MloqiQtL6Zhyjv93maS5wfs93brcD+ELJfiA5vMg3dliZXEBVBs6JWdxxPcKV2HK59Hse6qquGDxl52slh7MzlTZPfOPSWQ7tWxY6+SZVN3uyY47qceInf+IGnE/AFKr0hj9CXEO3AYhga67eV9qWu6Z9zbuaCgdcOmQ2gtV7UN44knfM7ckQ8H7DF1MM/XF6C+VVq4X4v1il8G97WEXgfjlRJij/55l8k6MxASJ6jvY8Y0s5Xoa+ZCaJefq9+sySYs0z0RmvztzqYqMiYS3DVe3tqqbK3AYiIOZSQCMSrKjPGJyo1JAWJzllTvYfVskrvsz4Td1AsiJpq5Y4Hm5TNEVNZm3hzBc/6T/USH5PQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 11:30:48AM +0200, David Hildenbrand wrote:
> > Compaction `isolate_migrate_pages_block()` already expects requests
> 
> Please, let's not talk about "compaction" here, it's just confusing to talk
> about compaction for something that is not compaction but uses some
> primitives (because not properly separated yet)
> 
> Just say "isolate_migrate_pages_block() already expects ..."
>

will do

> > +			/* Don't consider moving same size/larger pages */
> > +			page = compound_head(page);
> > +			order = compound_order(page);
> > +			if ((order >= MAX_PAGE_ORDER) ||
> > +			    (nr_pages < (1 << order)))
> > +				return false;
> 
> This is roughly what we do in pageblock_skip_persistent(), just with a
> hardcoded pageblock size.
> 
> I'm not sure about the MAX_PAGE_ORDER check, though. If an arch supports two
> hugetlb sizes that exceed MAX_PAGE_ORDER, it would not work as expected.
> 
> Doesn't arm64 support that with cont-PMD vs. PUD hugetlb folios?
> MAX_FOLIO_ORDER would be better.

Will adjust to MAX_FOLIO_ORDER, makes sense.  Missed that.  Will take a
look at the pageblock code, I think I was looking at the compaction and
some other code for inspiration here.

~Gregory

