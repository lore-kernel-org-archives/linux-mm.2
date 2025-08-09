Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1790C87FCF
	for <linux-mm@archiver.kernel.org>; Sat,  9 Aug 2025 17:36:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FD508E0002; Sat,  9 Aug 2025 13:36:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CD288E0001; Sat,  9 Aug 2025 13:36:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E2DC8E0002; Sat,  9 Aug 2025 13:36:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F21E8E0001
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 13:36:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7B4C4B76EB
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 17:36:05 +0000 (UTC)
X-FDA: 83757922290.24.88F427A
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf26.hostedemail.com (Postfix) with ESMTP id BD93B140002
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 17:36:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="coIi3MH/";
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754760963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CxeN4bEFMFF1XLou20dSMvySsqXDf3bO3Hp54pFsUeY=;
	b=gyWvnajL6xNqW77VyVLmsxaIgmiPPQxj0dCh4tccLFJSebJ3pd5l5aSAjXwz15fFIqzwGg
	8MYiX6eCo0W9UMbkayNHrA5B9Ecu9HHQcWPB3/mcMJ0xNElsRM4qUwlY7XXF8I2ScyQq1B
	EI8OKp5rpuC0y6sqAfQcl3ZWrXnWVAg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754760963; a=rsa-sha256;
	cv=none;
	b=CrBFd9UnSAVPM8R1QimeC7iD3NaoxuWb9X4s6UtUU1iaNPgOp7ElGjC5OdfzDVEkzscrIO
	pD3AadLqurUUdtSQpJKNMrFqudUPF5qhfJ+G55RcOsix84qkbpDPqvubC7Hmqo7/6yPvUx
	oMWJOHsn6hnb5X8VEbhkZW8cKzlH8os=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="coIi3MH/";
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id B675E5C274D;
	Sat,  9 Aug 2025 17:36:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E9E2C4CEE7;
	Sat,  9 Aug 2025 17:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754760962;
	bh=SWCxcOH9lwbVnD44cEsqOWOougLWaBTF3Y1gyrKV1qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=coIi3MH/jyBZh+W4xMGEahH3bZIPlZMkcZEhJ7Xg16rrySXJeh7S/zLld66NReMJ2
	 Vzswt03DCOBaR4JYX83JeNWlsVV5eAZtgO0SFm/gIQ/DKEdayBl3qBEUob4YeJemZF
	 VraRlBTq/oCsanytyyik6EbncSwhhuQeWPQOiVCp/pdSD7dodhBKg++/t8No5L2L23
	 6ob2EJ7h418WTNGQVWjFw7NuOajbp1h3NCkbsPvUQjOLjGA6yHVZtJXass/N9K1gQR
	 vj6RV7+pYN6pCyfe+TEeu4KurNYrZoc4T2RZV4wM0Nvf36gXZzh5XqSWaknAK9sLBl
	 VWC7chIu87xIg==
From: SeongJae Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/2] selftests/damon: test no-op commit broke DAMON status
Date: Sat,  9 Aug 2025 10:35:59 -0700
Message-Id: <20250809173559.71327-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CABFDxMH0LDLLdJf-t2DEHCD40EJDfcq35cJM-HS5GkLX7KqsHA@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BD93B140002
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: pixn7png631e4r8wewn963kcg87f7qo4
X-HE-Tag: 1754760963-490568
X-HE-Meta: U2FsdGVkX1+FtPVPw2x3JGwLE4uIYi614HUShEO9SJg9mRgr0Pyak5GCaevIgMEOLEB6w+y4jywHO5XbGw3hrzypZoy0pyJdyxpHfUm9MGf1kNWO9GAnJSXwYZedY5CrObWQ28/4OLRiO+0YUh3mkaYVQan8kaTREpNQM7cpzbJVokb/EeLM461gDABoOAsB94L7wczxB/d57DNTNbzm1l8w9AS5/odsS5MpZjFTLYzndXKhz2mnSLyZffGuGKlxs1W7YrqdsZvN4Vwy/3Cg8xPNbCmqz8o/sDSIxkNWzmvPEa8Y6Oi0eS5UuHxucdU0YLWRugymeoEgwBa81AYoXXozYXoLRo8PccGz9yR81BJdTLOXZe4MzR7WKst8mU9+5mhZ8kazjaViEfrxa2rq9nped59UEo0J5Drf/pCxLXLh0VJBXsoo4XqjrO0Le9UzLnXMY7Lftq7fVgkSDKlGtg5o9UGSK+EvSxj/oMYvelQNbw6dGbs4EITBLGoBZIhrNB8/d3QuasnrT/ppiE0G1OlDGTQ7716J1NGwCrL9UNTudh6p6Dfd4vk/Qak4lno76ek4cmJ5yKvFGpD1FE5qd5qMUcF48hxwkJ6okkQG43bPj5v+1+2uRFkbkg6NotW7bYL32JVboJTXxcLUqTN3Bpjl0laOsni3smnisks11x9KOk2QhXy2YY2Qjm3sLV9wUiPixn0CyTPlGSAsIK0yAPwUg1zr/ZOiakcSpY/wStjqwq0yc5hhvKE8xRLljTPlwumuj+n/Xfqoe/13hlqgyRoj1awkytIIKKrZCdiLz6oaPxTcHBP+MVh0uBULGM4leYBA5M4zE5c0k+uRkAYjasnpXuN55RATJAs/ak8nAY47GRWcI/mTrmH1VZSvImd/yIB2POri+rDRu5JQpRZdulpQki4QqZ7IHG0HWQCxk1yUf/H9wfj0DXeD5QDK5KOEsAn+UCY4cCLQOL9/WRE
 d4wHren8
 H1kRpkPDCJ+CIoLH/Ml5FsiffWqWDw2sMdZuYNIjPXBZDOfXEop2oxYh1NwRwWbROQoi/QlLWPlosOLKNyVnVmZEznADXnDmrWVUSi/aV+H7ezeIeLNmRv9eeh4r7xIWCTEds6ab0eUSBLjnBgDCZHJt9i4eb01FYrO7tRZ9h6F12JNYwQKrj4xKq31AG5sSOeoHSnLyGk2lpO8kjeVVkrhZUJZOxSXAqIDPrCp/1+/ox35yoYpCkJ+i4OB2saweiz5i7+ubGmiQvRzBtI2Hiqgx0SLNUAKPMn0NMbOxXIbb040dsxyX1ymYwJ9/YV8OkT+DJ8rRc1xred7mOIb1Oi5T5cw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 9 Aug 2025 15:39:41 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> Hi SeongJae
> 
> On Sat, Aug 9, 2025 at 7:05 AM SeongJae Park <sj@kernel.org> wrote:
> >
> > Hello Sang-Heon,
> >
> > On Sat,  9 Aug 2025 04:55:17 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> >
> > > Add test to verify that DAMON status is not changed after a no-op
> > > commit.
> >
> > Thank you for this patch!  I have some comments below, though.
> >
> > > Currently, it is failing. but after fix the bug it should be
> > > success.
> >
> > To keep bisecting goes smoothly, let's introduce failing tests _after_ their
> > fixes are landed.
> 
> I see. As mentioned in another comment, I'll merge this patch set into
> one patch. I think this comment will be resolved then.

That could make the patch be unnecessarily difficult to apply on older kernels
due to the test part.  Please keep those separated.

[...]
> > > +    if rc != 0:
> > > +        return None, f'drgn fail : return code({rc})'
> >
> > Let's not add a space before ':', for the consistency.
> 
> I see. I made so many mistakes like these; (I worked this very late
> night...) I will fix them all. Thank you for checking this moment.

I'm sorry to hear that you had to work on late night :'(  I hope you to have
sufficient rests.

[...]
> To be honest, I didn't use kselftest framework while making these
> patch set because I don't know how kernel developers use it.
> 
> If you are okay, could you share how you use it?

Sure.  I do below for running DAMON selftests.

    $ sudo make -C tools/testing/selftests/damon run_tsets

You could also run DAMON kunit tests like below.

    $ ./tools/testing/kunit/kunit.py run --kunitconfig mm/damon/tests/

I usually run all those together with additional tests, using DAMON tests
suite[2].

> I just build kernel
> with custom patch, and execute output images by vm, and setup env,
> then just execute tests(it's so raw.. i know)

It's ok.  No one fits all, so different tests are needed for different hacks.
Please keep using whatever works best for you :)

> 
> Maybe is there a kernel build option that automatically includes tests
> to output image? Or just a general or smarter way to execute the whole
> test?

To be honest I'm also not an expert of kselftest and kunit :)  You coule refer
to the kselftest documentation[1] for more details.

[...]
> Thanks for reviewing! Have a nice weekend. I'll do this job after my
> personal schedule finishes.

No worry, take your time and fun! :)

[...]

[1] https://docs.kernel.org/dev-tools/kselftest.html
[2] https://github.com/damonitor/damon-tests/blob/master/corr/run.sh


Thanks,
SJ

