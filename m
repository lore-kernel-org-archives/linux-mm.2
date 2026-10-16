Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FB0DCCF2C3
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 14:07:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B5A66B0088; Fri, 16 Oct 2026 10:07:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68E996B008A; Fri, 16 Oct 2026 10:07:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A3B06B008C; Fri, 16 Oct 2026 10:07:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 301956B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:07:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B8D7712048F
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:07:25 +0000 (UTC)
X-FDA: 85328666850.12.FF0EB21
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf27.hostedemail.com (Postfix) with ESMTP id CF51E40008
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:07:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tAx0XQSh;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.42 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792159643;
	b=hqItFl8AtXmD/VmM+m+8oPukfd1pLGRcNsrxswtK9xrrmYldxbc+nlkTdR44NyWQnn81NL
	E9+kgz47DNQfrXv2af6Tjg69/+mqFvQ3WlvdxDt+XgSZYbbqf++SqRtpRAYuLNXziqAxey
	9j7dE1fRlsWQGVrZwaZpOh4jf5Xugas=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tAx0XQSh;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.42 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792159643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QayzQmhnTMuUa2ajrFbaahJ0XP47WZ2WayG+9I0E9kQ=;
	b=rnwnQy9IoKnXvHeHAWHooLiXyTs8L8GWaUyP9GRedImsVMq/2Uzp2gPTRO5yxTLjyMU7e8
	5EcZU8UGeftxYNogRlUBcCWVp6UiT61LtYY0K25+HLj5ck8DhDZnrI7wAYEYrZV9xD6Jfi
	lqbxPGtjm8yDqdQWeOMLS1Nbc0lYWpM=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-917b78dfe30so406386d6.0
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 07:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792159643; x=1792764443; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QayzQmhnTMuUa2ajrFbaahJ0XP47WZ2WayG+9I0E9kQ=;
        b=tAx0XQShG7bHN8cqijh7TZDrUavPbElwS25HCFzaUxhphsMODXcgaXjHdCm5qn32lx
         unzDd6jdWpyiNzquSCcsF7PUz/3xcnkbhxKncwoOhlDKt1AeH76VpfL6UyF7F4ICWkoe
         0arQ/9jaP3kiaJZkfeacqe2shsYCIHRfk4bCue27LCDBObk6NkcNaeswq/P0XdJ1iBdC
         vMRZ9bztHc/46BJGk3SXLHmu2ob5AUd3C4UA7mBpobCLl6md9R1fqJoDAx8nIbLvRM9N
         4bEgAF+RYfDL7GM4GPGmZDcHcCIBme3Ea4hFklERtdILhqibLJXkSeQlDsuO/DaJPSnj
         KXOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792159643; x=1792764443;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QayzQmhnTMuUa2ajrFbaahJ0XP47WZ2WayG+9I0E9kQ=;
        b=fbBpyWydPVC73QussnhFFVfUkI7hq4hxvC1YOTSDEhSef5fHBqr3Vp7dsJpw+afiFx
         7tPH24xDL2KtdB6CsU6qRI3k+H0AnNvtU8rvEbi02t5aG1Yw1C16RKdWlJCu9IKEqv2u
         iCSeFffMuVBEidG+IacvvbPM8kubUOYgZzR0Q5XYrNwl1BQPyysCPr8iV2EozVdwvLhz
         lXRfJDxRuHfqWLZP26r+SuyJ3q19mlB8XBI2ZxZqZcTqMPiZ15adcUYEXXK64NjiSWCd
         AymWJWTbkUalo6QlR11zwpMm4g/keVcBE/J8ZnnHB9c0JGSWjWO0du0q5e2WwIK58iEw
         yQMA==
X-Forwarded-Encrypted: i=1; AKwUvBy7Ha30Mn8sXj4moYunRy8Uacpejgh0rlR8MRlLAKAmW2xQS+p8cyNNJIu7YM8onUWAkHwE49SKjg==@kvack.org
X-Gm-Message-State: AFq9FYIoje6tkfwUCllLjkBgsOyl7X++w9LAkTOaFM2EBa//fPKlUbGq
	8tFostt55+37AFpqFj4tq03007Y9jTFRoW9IbshLkhgkdwtdtNp7yjC6zYkWH5db+F8=
X-Gm-Gg: AYBFou1rI/GwLjfJxrtX44kDNOx1UIDePQ4K71rc7xFlRekqZxgKAopyTf/4EQccYTX
	vwErZKk8gME9RIroTEV3PhCcZdqLndo9zS5E7IyFXCu5HIzra+2pbqI7Upox8NqiXoRKoA+8PTk
	Q9pTis3LiAcqJt4wfTWCQuGfNuFKFD7stR787j+pJiLbb02U+LrKVowJKot20UaAw4Qmdsj5miU
	HHDFcxHRHNLPIp0K3nPhegygM6HpF+dUdf7wlPtKdg8S6+U4kZaraIPNLbonTgZ2R17NJWAo72U
	h0vrbXOBtEB0QaiHDWwbVu7UZDmAZtfasqBrotXscHgfWyC3wZhB4ANp53taQehS5lf0gdErzHV
	7vCs7pPMOM36Ey5dFTPSo4svdEjYkajLykiXLPSJ+8v4VAvAKHydBfc/vsmunwSTRYYXpEwtCa6
	EyZgA2QTkpFyHlAppe10iNUWWO+85aV1kVE915hqqKZVeJF958aVcaxEggr1QnvfGEMujHvCXI0
	LKlugu/wS5ooBYQ46M3fOn8dZGqhK82LTlL+R7cmpLfsD/gH/rP27M9jMXUaoXTaQ==
X-Received: by 2002:a05:6214:3a8a:b0:917:a1a7:6369 with SMTP id 6a1803df08f44-91bdf07e362mr1076226d6.22.1792159642853;
        Fri, 16 Oct 2026 07:07:22 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91bcbb75af3sm23592056d6.40.2026.10.16.07.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 07:07:22 -0700 (PDT)
Date: Fri, 16 Oct 2026 10:07:20 -0400
From: Gregory Price <gourry@gourry.net>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org
Subject: Re: [PATCH 3/8] selftests/mm: check MADV_COLD and MADV_PAGEOUT range
 handling
Message-ID: <atIvbzEGUcyCqdC7@gourry-fedora-PF4VCD3F>
References: <20261014175756.2035176-1-gourry@gourry.net>
 <20261014175756.2035176-4-gourry@gourry.net>
 <73c55ce6-67a5-471d-811c-facf712b2fe9@arm.com>
 <atIkDw9r6CVDJaG7@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atIkDw9r6CVDJaG7@gourry-fedora-PF4VCD3F>
X-Stat-Signature: 5jqm9kc7wju7qwe14rrjouoo5awdpxdc
X-Rspamd-Queue-Id: CF51E40008
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792159643-259599
X-HE-Meta: U2FsdGVkX18uBoLONiV/SUmEQRQ3acTABhIHxEUtuo3RqrH62hQq3iSUss80/9Oh5HdbIsMz0PkFC2rMCTR100eJEkiZbyKM7/4FQvLl8HzcXPTnRNxXunYehWkVqBshbjUH8cnqueh3LG9U6tap2ZnBOoY6//WQcSCWlABL2iu32fxA7lLyntDhDt2JfZiYTk58tFdmEXrHDCNTINUPyfFmMk3/0zq8suN+/4ewag9s6J6039Rgr2ZSO+ru6EsM0cao4NVXu+bMzN412rH8sWNC5wsLhSun+9bmcpTvacIo709c4C0o8M8FJNn184Xc0/XfViOn+kIpPHEGZHjckuoj/wC39GbgGfy/hWxJfUhYkNb/Jtp5r1mOzM+qTsSpSJTAFO7+1ZCyJY2o8t9icYBxom24CAzYFNIJljGiVnS5pXCULx2KEIc5Xe9mNgeaCmrigoPSTgYWSe9EwPLSxTDQO70AwNAQSc1slXmlnUuTsux6ag1GhyBlecpKjyCxgNbxKAs2wYY/I6IWOJARSadUVWn8oKvFfxLlZRsvaEgebVRj13GYp4z8Dysc6birARdhXlJLYyfQ5f+rLLmWff7aGtEXPexEU1Ed4MA+nP6LLPb5qKCRfNdVS2HJIpOEiUSB9yaQk7mj6bm1MOunrbA3WnsV3WTctHYUr6DczBffvCoyiJbJctrv9Y/gWYJ5JiSwlrfzIQ5VX0VFmOLKF1y3w8C4iBNS0AISi4m7KIZ9eY4+5pM6+QZV8VqGz+IkQPJttKjGka3h0Ismwce66aW0Xu8RAm/IULOhb1IhuV/R510ACLZhPsr+GJFyngLw8T88mkCs4e5Zc7Shs1ZUzWq/BzByrgTLUkxG+utLJ9RFT7RN8SQ3xVVV58vcNWj1GTogF7nieM6wegJG5vWOnqmVoEmw8mo+NkJIlas/rrtZH9UZhNv5OswNijoCbDle6yEmpfkl/zYZj9wC9ud
 9aZKZAoM
 KglkyDI+VuN3fq3wrrDPP1OspsbCjJMHx8jH52V5SI8phHLxqf/56mJgq4OsCMbaToruZwumIygwWlqgmmG0Tm4Q7ZWFZ5wQKhtDyax+JN2tYFqTtlafMnY5F4HwR7SP4TPZEbfw3oWymajtMLBi6nAtvhxsX5M2Y0QTSs8ipvgauiFeZ4V5Y7pOLYAfg8Ava/6PcoC+orZlpGwVxKeCGFWc/LBHVj5/OXmVF+2nAHZF3UzCE0lTF4xR3rVO/7g1rkfZdh4PNvQaZrxkRhemlltpkupRgOgfrHDHkLnxJU4wciP4HfnyzyZ6ZWt0P1dVHw+nrslCxV8OIXu6XvVose3vNd71qorsBF1zT1E7HjF+bij8IozU3CPLdUujxQiagePRG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 09:22:54AM -0400, Gregory Price wrote:
> On Fri, Oct 16, 2026 at 05:47:57PM +0530, Sarthak Sharma wrote:
> > > +/*
> > > + * An unmapped gap in the range makes either hint fail with ENOMEM, after
> > > + * advising the mapped pages on both sides of the gap. Only MADV_PAGEOUT has
> > > + * an effect on those pages that the test can observe.
> > > + */
> > > +TEST_F(madvise, unmapped_gap_fails_after_advising)
> > > +{
> > > +	char *mapping, *control;
> > > +	bool swapped = false;
> > > +	int retry;
> > > +
> > > +	pin_to_current_cpu(_metadata);
> > > +
> > > +	/* Make sure MADV_PAGEOUT can swap at all before relying on it. */
> > > +	control = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
> > > +		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> > > +	ASSERT_NE(control, MAP_FAILED);
> > > +	control[0] = 1;
> > > +	if (!pageout_until_swapped(_metadata, control, page_size,
> > > +				   self->pagemap_fd))
> > > +		SKIP(return, "MADV_PAGEOUT did not swap the page");
> > 
> > This test is checking for both MADV_COLD and MADV_PAGEOUT. So if we skip
> > here because we couldn't pageout, then we don't test for MADV_COLD
> > behaviour at all. Do we want it this way, or should the tests for both
> > of these be separate?
> > 
> 
> If swap is off, the behavior of COLD and PAGEOUT look pretty much the
> same, and we can't actually test them meaningfully.
> 
> We check that madvise(COLD) returns -1, but that's also largely
> meaningless if this initial pageout_until_swapped() call fails.
> 
> At least that's my thought.  If you think I should split it, I can.
> 

on second look, i will just move the cold checks above the rest, since
they're mostly checking failure paths.  those are mostly unchanging
regardless of swap status.

so basically no need to split, just a mild reorder.

~Gregory

