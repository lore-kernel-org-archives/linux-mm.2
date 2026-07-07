Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 285A4C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 20:18:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B6E96B00A2; Tue,  7 Jul 2026 16:18:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 167D86B00A3; Tue,  7 Jul 2026 16:18:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07D7E6B00A4; Tue,  7 Jul 2026 16:18:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D35556B00A2
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:18:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 559C18F267
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:18:14 +0000 (UTC)
X-FDA: 84963092508.25.734D5ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8BB4B1A0002
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:18:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xoKMZzuj;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783455492;
	b=BJDaCFh3e3mvhG6WcmM0SKh9wYJAXQEUoHLqU0au5FwXNYM/MDEZggUwTL5qUqqbzLJLmi
	DDDZq0YEshJP2PAhf4gx0cwYovuDt4OaXgT5DKjfWa3EO/pSadL0tez/E7WpeuYCVY7U/W
	oGdWqiq8Wg3MMRa0LYVgoeEYoCAm7FY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xoKMZzuj;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783455492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DGRBEgUXIEfD8dcevWghW75nycH77uwjkCcUHva9V7E=;
	b=wg6VYQft6+jouarX9czTYrwxb7SGhvVryTySqFeWxa3mXcT6VhyEmhpulNn7EPxO3vD6Is
	MdQNleOrxUfNSLSaGIZ83Wk44/zkvk4H9vcwjoxHtvQFoUA2J+JXAFXvyDNRKbDxyDENee
	WAdqwTCeEJJsMoXUVS8uc+th9aSlGJI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B292743803;
	Tue,  7 Jul 2026 20:18:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063911F000E9;
	Tue,  7 Jul 2026 20:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783455491;
	bh=DGRBEgUXIEfD8dcevWghW75nycH77uwjkCcUHva9V7E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=xoKMZzuj0I8JJZvIEyWy9EMohJxlbDU7BOafGQgQ+aeQ7NRZ8kZIETDvWSnIPCAbI
	 nDkhHAKYR/ofR80su0ojMxOmY4XFt6zdYD1ASYs0OTNRCZPzB+61Ur34t5pMWf0yKY
	 WY4PND6r+tbRW7v8HzA7RmR+PayCfiT1xrpI3t2g=
Date: Tue, 7 Jul 2026 13:18:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Barry Song <baohua@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org,
 baoquan.he@linux.dev, chrisl@kernel.org, jp.kobryn@linux.dev,
 kasong@tencent.com, liam@infradead.org, linux-kernel@vger.kernel.org,
 ljs@kernel.org, mhocko@suse.com, nphamcs@gmail.com, rppt@kernel.org,
 shakeel.butt@linux.dev, shikemeng@huaweicloud.com, surenb@google.com,
 usama.arif@linux.dev, vbabka@kernel.org, youngjun.park@lge.com
Subject: Re: [PATCH v3 2/4] mm: drop stale folio_ref_count()==1 check in
 do_swap_page reuse logic
Message-Id: <20260707131810.96a4c1c56e00264b311133d8@linux-foundation.org>
In-Reply-To: <CAGsJ_4zGBK7ndTyFnzdzw0tuwaQwbCChVBdkC4E1YBE0NwVHcg@mail.gmail.com>
References: <20260701235955.36126-1-baohua@kernel.org>
	<20260701235955.36126-3-baohua@kernel.org>
	<3a185a5d-2f2c-4e9d-9cd9-8bdb236dfc5c@kernel.org>
	<CAGsJ_4zGBK7ndTyFnzdzw0tuwaQwbCChVBdkC4E1YBE0NwVHcg@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8BB4B1A0002
X-Rspam-User: 
X-Stat-Signature: rbjpwr4itje77abueb6zma7u4i4sh6wj
X-Rspamd-Server: rspam03
X-HE-Tag: 1783455492-217232
X-HE-Meta: U2FsdGVkX19qDtntO4yXKFCRg7Ydz80klIWbsSuJWTBen+td+yeLqGcgfowj7sJ3rbfisuQyb+WvMTntzPn2E0eYkkJ2+IBeojUfd1EaxJ04IoGBU8rb5x9Jz9PS75liK06nIit5N6NI4IdW88TXs0QbVw1lVdjw8iZuLAzyy7FImuh7CIdS49NfBPWZYOeemZLctiYpWDocitCUbiK+efoBpteY6y/CrEzhZXKI7vPSAY8dSPVTOfhM9a9xnaaecTE1u2FRqwvgEJsg6oVQrked2cKhUv24X6Br08oqPtdKJSzJen/vt439IBDjbyjYVgJvBNx0L4yXIQTIDcbCGCoghW2d7G7xqiGQcW53BYt0mPqiBUN2YgcMgCt4KOa8GzQMeXEucuTFR4hKKlRux4qY5lnL25xfJEYAhweEf2XprgnbfrptNj7jblAeylvcEQ1besJWaINwN8gUTzlPIpgk5NVuRuMBsXv/vR/zlnfvoExHvUrCtTiG9Ke1JUjWopjskKP7ei2NSeBV8/9cWUn2TgGY09b8k1wO82cWhTvwFxJBsP8GmTq+vouShagi/fe+XMBRaInGlHa1tTtRcuIfB4CYWzs8rg/JCkLbMp4G+pcJJprtNArl3+MkFudRMT0w2oNhr96SumlKLM8XmiyQYZwSHq24DWeSEnmiiEyk3Va2brX6hWfRp4nUzV3d76pCU/6HrHOtOgWYoPFXufp0TvRAgr7rvieR5upBVjyv7dk3mZTlrglHfDsEgHqLFM8E7fTYyaUCtX073joQgJMo/MdEc4gsoSRdOK7A+HcZu3nQKAJLI8c3q5cUWxeJ9bMDoyZquOFi2J6eIxGEUgIQVPNnnIqV8oH2FCDliCP0+0MkYPC3yj6Cf7HhozuPKzZ0R6XIXc0bTbWcpkAbaKgXYjPw7aEpzulKiGsJzLC6rU5x9pRF4Xj6VttMFC6rDjJAYrPm/KXaBTpJ8zA
 v0GMsl9I
 ar1N7tFx/D4lcmDtnkvPAXzuFwhryax8zCa9TcrOZbMn70qm2oZs4rz3ApDctGUxxZaKBQmrWWIkaBjBtYtbnpaZR0r6ecfGTGPNbya9UShWm/2xbP61Tf36tOGvzZyqFScFF6mhFvAeoPsWgsG35PFP9aylGyr1Cnbtfy4HISI2u+IUbm5hRCw4njyMDi6O34QpQHh4f6MpEo8LOMznf7z2v/E0F8tTEZAU+smeHKDti1zesmEd3+LSgwil2VttIISUV52zPBhmpNAyOY2DT9gbf/IgxGNFjuV0Pj35c1fMc2DfxYU31aekOJoVdxnEOH2uw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 7 Jul 2026 19:08:13 +0800 Barry Song <baohua@kernel.org> wrote:

> > Sashiko points out two minor things (one flagged as medium, lol, sure sure).
> >
> > Here, you can clarify that folio_ref_count()==1 is true for freshly allocated
> > pages (due to the KSM check) in which case exclusive=true already.
> 
> Hi Andrew,
> 
> I saw that you've queued this in mm-new. Thanks very much for that!
> 
> Would you mind adding the following sentences to the end of the changelog?
> 
> The ksm_might_need_to_copy() check may allocate a fresh folio with
> folio_ref_count() == 1. Along that path, exclusive has already been
> set to true, so the folio can still be reused correctly.

Done, thanks.

