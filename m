Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84575CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 15:22:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E32826B00C1; Tue, 26 May 2026 11:22:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E09986B00D4; Tue, 26 May 2026 11:22:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1FAD6B00D5; Tue, 26 May 2026 11:22:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BE22E6B00C1
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:22:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 607B5120386
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:22:30 +0000 (UTC)
X-FDA: 84809937660.03.CDD8AA0
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7C9944000C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:22:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jUIfiODO;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779808948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aN8WQ4CugWF6CWlj2xPxBqc9Jwi2zwDC9nUPjhKPtBQ=;
	b=TaP7SAZfRBUES9dLnATiz8PzGTTqZHoCOXKg+0d0zSnnwaXitfm8DMip6RSRq5Qv9eG+Il
	2QhR3VsonWRdywBJyxdnJCF58uHQEtvfI2L8/pz3vMooVEFbHb+THbzw8bpYlabTsrw+0Q
	Mu+2Dtd5Tp+WR4ehWYNlyJ+uGTqduqk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jUIfiODO;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779808948; a=rsa-sha256;
	cv=none;
	b=E4vqoiiUfl9InL1bFSV55taQKDVB1aNuicq3iOsDVheVpCuKSslU0o7jg6SEZvUxTxrJbf
	jgpE7TkKoABdcX0OI6bhgBwHnszgT+iMzwz92FU7r6q7UmDSUBjyYWAPB4MRxnV+Gdu+C2
	pup0z6+MKOlo2oBDZ+ySyMzc4LdFAnk=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-9106ea78cd8so1672092485a.3
        for <linux-mm@kvack.org>; Tue, 26 May 2026 08:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1779808947; x=1780413747; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aN8WQ4CugWF6CWlj2xPxBqc9Jwi2zwDC9nUPjhKPtBQ=;
        b=jUIfiODOUtTAWvOUsLca5NqL93pJiAwn53LOKhr7OgaUcqaCKCNltiUxha2r89nKhc
         tHtpKDSHgHL0RW/aA2SKNWQRDfuBE6QxMHpIH17ZePrY8032adGi5uScnEYgT8dL9SeQ
         UALABjNJa4QQxQGmZyu1IjbS6P0xJCmdPgTR5QbsNecq+dVm72YXz9PFE32MSULPXmr2
         i/XYijkCKEqWIetqBd0xdRKtrb4mCwRLzkIY3LYmZBOqjX09Riv0j4UXy4wbG/5Mp2b0
         DD8Dqq7SeySlgN6QJ6bi3LEG1M0Psvr5Aw2mMbsL6YZjHMPDGyhxN4kaVdo5i61Y/Qr3
         6oNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779808947; x=1780413747;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aN8WQ4CugWF6CWlj2xPxBqc9Jwi2zwDC9nUPjhKPtBQ=;
        b=flWG16xIJ+1vXIQVi8EE15UtJ5vognOk2zUIBA/VrtFhIQ5NA/cw06OzDHNBwGx+cY
         vfDNUuw1Zf84iHcfs4yxvIfZO+2+CD6nloKDpQMimCMOMmsveZ5kVh2E9wBaZz0XFJiI
         dZmhfSU/3UMOdS1VzZze9tJHylrpuBukA+ZFnDCaeBmyc+sHzZKIT4ZZNEvAYIIy+0sv
         tY56gNfHIMd6Zxisw9MuuWYWXfmgGzpQ7lKrOoFFhXxkdkp7W735cYfUCg8c2MjVyIaV
         KSLdL/u4/5KuVjrvBC4sbX+657mPvwW06TlmAYXLxs+dMl/h1LduvXF0v/wYRMk38tji
         LRHw==
X-Forwarded-Encrypted: i=1; AFNElJ/n4C7rg++wxvtq4dIjMgN1ildyMbAv5nyTgMKTHYRvphCNHRmxgwxhIrDcGng9gWUMJBuCZvUTzw==@kvack.org
X-Gm-Message-State: AOJu0YxVT91BsO4pG0piVR3h8Co48rxlF9qFm/nvhbkDAPYmeJ9jr2/3
	ImhYZYQHrhevEILMxPIIC57le4J6yMDKLFOX+IxfAXuSQJnUs6qrsBO3DPCzK/r1ihM=
X-Gm-Gg: Acq92OF/thSqDq7HBooc5/5wh7StHS57/t8p5Mt9KdLMRLuas4zPu0FozfqD3MLqLXf
	0/GNio2qm4Y0Ccaj0mrZQb3jQmc7uSCtj3GrLs7hRpRUWkYqdc79UlY5fyrEE2IHAfNOfGkPc39
	msouJBweZFZ2L3TcQ1uuxRD0L3Mv1UlP9Z+5rF02Sj5qDdnGwZAag/uGpdxEBdwfvGWxmVDLsoK
	ZNZkxMnVEu46LKWI3PFRvrDhSzuteELA9rsTpJ6kD3q91mjySLIruYM+6EX0AG/OBpfzCXra1GP
	aBny8lOHBiRmg1cugOyu4YWuool+Rdss+rgLJ3f9HdkeFHsYbe42BlEYU3672IvFjwV0G1ZkFRb
	KEyxaYI6MkfLjzmZVaPLZTTdbW4qx9vKQtYOQr1OowmlTasmC5ssR0+XqD7xnqgNvo2iNKHHFA+
	MRgSxzUyO+WkpTKACLFgGBRw+AHBaNnf2KeDAEFUIEtFU3iOBHM7bcsWT6Hr317TdTpKaOPXunK
	2zcRWRIL1TYjIFeKz5jngA=
X-Received: by 2002:a05:620a:2245:20b0:90b:584f:7f1f with SMTP id af79cd13be357-914b49a31e3mr2074749085a.48.1779808947504;
        Tue, 26 May 2026 08:22:27 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-914f86ff80esm232992385a.13.2026.05.26.08.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 08:22:27 -0700 (PDT)
Date: Tue, 26 May 2026 11:22:25 -0400
From: Gregory Price <gourry@gourry.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>,
	Jann Horn <jannh@google.com>, Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mm/mempolicy: kernel_migrate_pages: simplify the
 usage of put_task_struct()
Message-ID: <ahW6sbA89yAHYYG_@gourry-fedora-PF4VCD3F>
References: <ahMt6xyUNnacZU8-@redhat.com>
 <ahMuF6FC6TIOZ-iZ@redhat.com>
 <ahOx-76r0JvTZHL_@gourry-fedora-PF4VCD3F>
 <ahQH2pLUc0Y4z4rU@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahQH2pLUc0Y4z4rU@redhat.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7C9944000C
X-Stat-Signature: t5q67jkj4tsndyj4xdznpoqsrsiq4cs7
X-Rspam-User: 
X-HE-Tag: 1779808948-74847
X-HE-Meta: U2FsdGVkX19Q+Zry2EJW8gvP2+cCmVsrUhDTtI5uw3oSxvkTWjedR0qA9HIMFGLv9hNE4sariu6JuIfJvELIOmhsqr7oa6BOj+TuVfomEM3IPzH1jQRyfhN5sR/SsGyrwNmCe7+ur9+vY0V3P1VmsRNv65GobHqgxuvHAVgAoHZrIZ4CeQ53Vv7oXi9tHM1Bej1uMyDI4wcz7wxnOJ7ilwTaoFVyz6y31aXcw8vq3TYAnGjZn98pAXCr1QoBbHb4KwgiGi84UmOxTd+rZMg5Epmkot4t/3YNrfLqRsPRWf0uuK7KkhoNmbW0pBXywZsS/Zlvr5Oh+Mu6tXDDQRXpdxG3obQPdYnXLNSkDXwJaNRB+HjSJFL0UzV/gZZFV9apyanP27gs9orWeGNekFlUZuBouemBNaCJCzmBtclB6jlkBNC46wQEiJ+abQHajcCum+7bOQcG5j8wTGY6VpWYBjXACJVLM9zsgoDQsZz6JLcUUyEuGlZEVl3USTpElgDBjU/3Dh18iNxs/zpyhNctypyO2I8voRWE41bq90ZlxHVrbeP9jDBTtQojRTcE3/QNWjpo619rwWYQfQjOSc23ZZ7zqxc/CrJLyHw34YY/tEhPB+7ig4rStCAmeytSoIJZnMHH9WSg0wkfGcSTt+/25CYrGsZDa531s/pdC+YKpdKNiMUckhAI/TNCunF0ItHd54fSRwAeOUK/P6CUI95yMwmQbNW5PewVVGHQvrTHFZtJ3bcpLLmN/FUgEwN0jNQPRN+/SvljGCR+86BdpSCndu6bs5sUmDfU2gQNl0KTTuoNXh3neJhhKkPo00AbKAomI1xaj6wKDolG8FJznU9uPkhpIeByRWwiPuDEaj9KGgR22LqnNnT4tRFpsBJFw7pyPmZafTm4ZRnNmj77okSdV9olkpnqta/1xyYkmoH8HKQ5FffWF6LVWIp9PKZAFKi12ZQrcICRnaME8zVI8Bg
 6OyU8Cjt
 eCsfgE4b8KPnFfeaDTKCiFjl9uUZNEzePSYdtVU3M2bpU0caiEOMxdrOt0dZHODKzACA79tkEzC5s4u2P8a8mtspLar+BiW8FUFkK/12oi7heqn/I5AMyxfEuBwhaCV/3mdxtbndtskjesXr2w5lvoaJTppKoXBD3h7MiOvZ4AqzgNDGnakvUEmOgXX2qPDDgSDwJRgAMTE0QUzdYe0IRZNut8gy14ZBKhew9nlNcFMVVaQ0rc1NsKYoWgmCmJF4vv4OCWN6AlrcsGpdv6x7L0Rc1O3Kfr24bTlV/Ifh4jm92v+Zq+/k09z3Vxa+qPBedPunVOh6BlicH4FLPDyveOdAKK2vJj0rqzAXEgF9rBzytT+t4Oj2JsmDp4jHSmxFExq4poLS77FquxOhYRG27LrkiZcEVQdMAR25ANYurSB4auBFuztFkDltcLpLfQtQzK3xQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 10:27:06AM +0200, Oleg Nesterov wrote:
> On 05/24, Gregory Price wrote:
> >
> > On Sun, May 24, 2026 at 06:57:59PM +0200, Oleg Nesterov wrote:
> > >
> > >  	mm = get_task_mm(task);
> > > -	put_task_struct(task);
> > > -
> >
> > Hm, I was a little trigger-happy on that review, I just realized that
> > this increases the scope in which there is a task reference held (i.e.
> > we're now holding a reference across do_migrate_pages())
> >
> > I don't *think* that's an issue, but it might we worth looking at the
> > changelog to see if this was done intentionally.
> 
> I did this to simplify the code and the next changes. We pin this task's
> memory across do_migrate_pages(), so I think that delaying put_task_struct()
> doesn't add too much.
> 
> But of course, this is not necessary, I can rework if you don't like it.
>

Not necessary, just a curiosity whether holding the reference across the
larger scope has any functional difference.  Like I said, I don't think
that's an issue, but might be worth just checking the history on the
function to see if it was done that way on purpose.

> Thanks for review!
> 
> Oleg.
> 

