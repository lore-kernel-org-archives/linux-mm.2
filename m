Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36290CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 16:31:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DD136B00B2; Fri, 22 May 2026 12:31:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B3FA6B00C1; Fri, 22 May 2026 12:31:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CB7D6B00C2; Fri, 22 May 2026 12:31:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7BD296B00B2
	for <linux-mm@kvack.org>; Fri, 22 May 2026 12:31:18 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2BF1C1C080C
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:31:18 +0000 (UTC)
X-FDA: 84795595836.01.DEC3009
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id C57D140004
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:31:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F4nqoacz;
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779467475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZB1zN0lFhdutdAJ2gklLxjJbqSoEBLb4bQLOW2WicV8=;
	b=fXt/QFwUgOFT2dUlIjCajK35Y2Qf2XktJIk/yMChYgDqPhIsVbQAVSZPyYenM+x7Z9AaR1
	3VV7DVDwFpI4qDN7F4AfZUGm8ek/fwC8PnIxPX6JrYZzPyl3gnWYJ00WK9V9C60VAxuLGD
	irZKbdZooRYM7kmB4yyyPY+vS6+33bI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F4nqoacz;
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779467475; a=rsa-sha256;
	cv=none;
	b=PqzcR1DjvOtuyNs92DUe8Ic7ArJpcaMSZwR8cfmitmNpp4n436lkWwH/tFzKAQuZN0yG8Y
	pBqDlY5cYzeRMSylHdu9A483xWe2XJoZL/zrm2tb3Bay107jGZngYAC9p7NonTfP3WgT0K
	ltt0zJGtOza9A2qalKGc+MS/dzHDO6s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779467475;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZB1zN0lFhdutdAJ2gklLxjJbqSoEBLb4bQLOW2WicV8=;
	b=F4nqoaczi57Rr0qAFhwJkWP88Ii6WZt5phliC6RzBfo2yLF1rgkgYaDzx1b/SL1VgbQ991
	Gqh8F3NVz8/5vGGa9lkFiCsWOZTpK7t8iGofp0tscqMU/H6qgF2ik4LX4gz+l3Hdwo7cxz
	iL1MpE9+7+1B2VGI87w0iZCB4h7XLhs=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-221-0yaNLwiJNqq3Cd95gHeOFQ-1; Fri, 22 May 2026 12:31:14 -0400
X-MC-Unique: 0yaNLwiJNqq3Cd95gHeOFQ-1
X-Mimecast-MFC-AGG-ID: 0yaNLwiJNqq3Cd95gHeOFQ_1779467473
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-65c7df54465so7143177d50.3
        for <linux-mm@kvack.org>; Fri, 22 May 2026 09:31:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779467473; x=1780072273;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZB1zN0lFhdutdAJ2gklLxjJbqSoEBLb4bQLOW2WicV8=;
        b=mj0V4nBEDYO6hpkznVXNI04L2T9rPocnyIE0cpDTi+apt5qaMTPx13eqw/gn60Znhz
         DRx/K39/8HLfaQUXNC4D/fmZAsaBknhm4M7BFrZdr7bjPscQ1Mec5u+iOA6d09V5JLoh
         Zsu44HD5cG4pB1YLNVMoP0Eq9r5Vb4cQmeHbyaP1MToC7d6Kk9h/G9Q3I7p4bLlZyOpf
         fBiWClZoEjDn71Y49Y2mglixvVzZ7bDT/Q5wZW7ffrz3xttcuiXbfTYc9RqxeknEIRxn
         o7fm6tIc7pxnWBebbxYquXRszXI0qrZFh5aSdQYAq7sH1ahWK9qt5jyWfG13YDuXPqI/
         Ictg==
X-Forwarded-Encrypted: i=1; AFNElJ9mXovLjZLSUMlFiiRtK0ALmBQxZQGoQYm/Un/xzzbkCoNtc4pf9ZaLB3bZkEz0Ud/pYXuibK4ofQ==@kvack.org
X-Gm-Message-State: AOJu0Ywcdz/XaXcUBKEUXKR1G/8JpgP1MNPxLUUzyS4EnkgHMlU25HRp
	GFJahBa+JekORjzG5gX/z/mqbysB/HmRiNqxL6s8r/8Do7XBpdJ54XwcGWkGRGB7F0usVfHbRkU
	fCMkZ7SrNsYlgU7Ht0sAL3JlvqzKRDL9ie+9kBHLGxtcjIr0hZM0rT1A0U6+YgOzLazFjdYVhyA
	MYO9FJEWTVJKMYGLY/zuMUw9pHXcY=
X-Gm-Gg: Acq92OGNGepq5ju2t2w1A/NZGsEYP9rijQgPz2EIDROAngTulIOewOHgP+doDrPHF4W
	/L6PQehoBi0gypLntckxpnXrAL4URxYTcmZqO3cESYfLZOhBnsEV9vVZg2YO3htRZ98KFB1aTPV
	ADuyWmB0S56BE3g5TfQSH3r1RxGM8F9x29m15SMWaGMAVUViWO6uA+tQdzjiHVHmpI1296IhFt5
	WZJb3u/KI12acbv
X-Received: by 2002:a53:ac9b:0:b0:65e:d9f4:115a with SMTP id 956f58d0204a3-65ed9f41984mr1675641d50.52.1779467472985;
        Fri, 22 May 2026 09:31:12 -0700 (PDT)
X-Received: by 2002:a53:ac9b:0:b0:65e:d9f4:115a with SMTP id
 956f58d0204a3-65ed9f41984mr1675510d50.52.1779467472252; Fri, 22 May 2026
 09:31:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260522150009.121603-1-npache@redhat.com> <CAA1CXcCoDU_pnp0SmMzRi8wPGB1OBjbbokevq2X_03X1vpWtOw@mail.gmail.com>
 <ahByO_HWn6MB8z-u@lucifer> <CAA1CXcDoFdZZ4aBx0BPA7QXYKYBYDoqUiLTLYe3L5opJ0LsJGg@mail.gmail.com>
 <ahB_hae8coGvf12Z@lucifer>
In-Reply-To: <ahB_hae8coGvf12Z@lucifer>
From: Nico Pache <npache@redhat.com>
Date: Fri, 22 May 2026 10:31:41 -0600
X-Gm-Features: AVHnY4JwqTM4KQ585Lna0BN9qklHfMsqSL-jihLqRIt4jnbKPb5w4AMPLogCSss
Message-ID: <CAA1CXcCoyGzEyeFPW+zKiA2AOj=0Lm7R=odLtVru+dQa0P_2cQ@mail.gmail.com>
Subject: Re: [PATCH mm-hotfixes-unstable v18 00/14] khugepaged: add mTHP
 collapse support
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-doc@vger.kernel.org, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, 
	cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jack@suse.cz, jackmanb@google.com, jannh@google.com, jglisse@google.com, 
	joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev, 
	liam@infradead.org, mathieu.desnoyers@efficios.com, matthew.brost@intel.com, 
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, 
	rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org, 
	richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org, 
	rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pcepgjqW9MJ9u9d8RUWjQgePHBJlEqFTGWS8vbIZk8M_1779467473
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: s8s4u9bqo1oadquw1q7gh7jdodh3cy14
X-Rspamd-Queue-Id: C57D140004
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779467475-80898
X-HE-Meta: U2FsdGVkX18Wa+00TQz+AYav4aYO8htbcjqDVd9YH9QUFGKG8hY6jV+OAHLhPAwDIsTdMSuYvpbM+5aVk516Kib72W2P0AWtJfDOqQ3aVy+s4t3NTLyTyUHriW/aY81kE9vgIwjuvDRj63Aj1FSobkZuzqlmuuXd3Yu+2+fnGIaMJHBXAWgjlCHxC779qHgkS+nl1YoGSpWbXTjbkPDfQIbTzgAzlQsKOWabAosQPtTuEFg4Z0bujkmYUJbX8ezXwprjZQWRuqQPFoNSSEYcsPbzGPb+CZSzcOINe4Z3OdYUp4EHEKjQmNG1QVZwrrrjp1UCXc4MPGbvzIL1G/vQS/6CFdgwuUfaCS+onXVSG+E1CWGTtI0B6EVv3j953pTWvch6WOua1t/tT9PjOjL/6CQ/nwZW4oaDD072OYV5WOpqnqe/WJiygXTUxRpKw7zrgFeMa7cuUYttOKgrq/gz5pujp4eQZSLnRpmVHqKCd89eBerqf2s+Xj6z6GyZKhbdrUnR3i/Ti4L7/aIKd3v+DlQZaR/KTKL1rqHncJJW0enhLmtK294YEzOanhv1Sl3AvE5NlVNZfvsIFpbfmE9VplbQ7wCpUPs/nqBNCcB/R/mbnE/JHpxa7oz9jlwUFlPTMBY6YQkZsoIswWBNaNGflvz0R0n0feGxfkJyH6wezcePYvAT61FKEa8dOlnmeDeMteaVbHVM9UJh8ow/nmUxwBbiLjOkIt7gGfAllbLZhPgBeiIA/y5VLWhLw8bUZWrmMldOfS1xTykzCU2d0Q74ki7IIEDQL7m2P8Fr/c7JWTp3dzhg/aOPCeIZ5v81Y6kNaxAhm8cKXW5sy4hRSyZi8wAecrAI+bIBPkQOZP35FriKmFebBenAJsj+c2dQR0274RJOOX1pK4/MBIMizK/sN9VtOytfOf+sTKWKW92GW7NxRV7QiOrmTGne8leQ0COqtrmcCTLF6iDlZrW3w+H
 o2hn7LW0
 dogLX9CbtofYgax851XNmnplIkIw35Wit5U0UcC0L+YYF+Ulaff71twOrpYzNeCpuM7y8q7pc/EybZzrnbFxrBFRwRVu2RpE1V4nUwXOzeYX5n4Dv4zGvvZilrknGQPp8/uIyjmBqwoKhTsmU95JuUbBhDaHkVGy1jJEwH2WgZhoSy10oONzyVoV3ou0E8hhyGKl9JnpbLAUa8s17AnGtqMqeINzIIYsDLpd67RznLlYlp7W7+N8p5dZaCYViYjhNUVhiYLkgdXlQqZVY8SnaK7yl3fJJbJtdl/wp2Puirm1sRUxxa1qdGytPqoBWyBNcs4zX4i9ftE3bty6y5VhuoNZk4+IxHghrFcqnTP9NaIyDpkR7f7epY1vmHN1TfqZ9oZmXXtsK/eTVcPE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 10:20=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.org> w=
rote:
>
> On Fri, May 22, 2026 at 10:08:19AM -0600, Nico Pache wrote:
> > On Fri, May 22, 2026 at 9:17=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.org=
> wrote:
> > >
> > > On Fri, May 22, 2026 at 09:07:29AM -0600, Nico Pache wrote:
> > > > Whoops I manually changed the coverletter subject to reflect that t=
his
> > > > in on mm-hotfixes-unstable but never updated the others...
> > > >
> > > > Hopefully that is ok. Just a small mistake. Base commit is referenc=
ed here.
> > >
> > > It's not ok, this isn't suitable for a hotfix in any way shape or for=
m?
> > >
> > > As you know, because we told you :) May has been difficult because of
> > > conferences, holidays (and in my case burnout recovery).
> > >
> > > And unfortunately the series seems to have needed quite a bit of revi=
ew again
> > > (my suggestion to you would be to ensure you don't make major changes=
, only
> > > small incremental ones on the basis of review feedback).
> > >
> > > So this isn't viable for 7.2, and we'll have to target 7.3. Therefore=
 there
> > > was no rush.
> > >
> > > Also please don't spring a respin on this series on us without discus=
sion
> > > first, with people away and (frankly) the amount of work involved her=
e,
> > > you're going to have to accept the pace that workload/availability pe=
rmits.
> > >
> > > Adding spurious hotfixes tags doesn't help anything :) please don't d=
o that
> > > again.
> >
> > Hi,
> >
> > Sorry for the confusion but Andrew and I spoke about this before I
> > sent it, and he confirmed that I should send it against this tree to
> > prevent merge conflicts.
> >
> > Because Zi's series depends on this, and this is already in the mm
> > tree, choosing a candidate before my commits was best to prevent merge
> > conflicts.
>
> There's some kind of confusion here.
>
> This series isn't suited for 7.2.
>
> Sorry but Zi's series, unless it depends on functionality here, will have
> to be rebased.
>
> People have been at conferences, people have been on leave, I've had to
> pace myself for health reasons and it seems there's been more than simply
> review comment-based changes happening here.
>
> (Again I strongly encourage, at this stage, to ONLY be making changes bas=
ed
> on review, not adding ANYTHING else or changing ANYTHING else to avoid
> delays :)

All the changes are based on review points. Very small changes in this
version; the largest being the one that you specifically argeed too.

>
> Also - shouldn't mm-unstable already have mm-hotfixes-unstable in it?
>
> I think in mm-next we will have an stable branch, that everything is
> based on, where things go once review is complete and things are mergeabl=
e.
>
> And a separate hotfixes branch based on Linus's tree.
>
> That would avoid issues like this :)

Im sorry im new to this, but I really dont think this tiny error, and
something that I'd confirmed with Andrew beforehand deserves NAKing
and defering it. Ive worked through my PTO to clean up some of these
review nits just to get it in 7.2. I even through this through my
rounds of testing today before resending.

>
> >
> > The intent wasn't that this is a hotfix, just that this was the
> > closest base before the v17 that is already in the tree.
>
> The convention is that [PATCH ... <branch>] indicates the target of the
> changes. Putting the hotfixes branch there implies it's a hotfix.

Sorry I thought the <branch> was what base you used.

>
> So please be careful with that in future :)

Yes will do for sure.

>
> >
> > Sorry for the confusion, hopefully Andrew can still apply it to the
> > correct tree.
>
> I'm not even sure what's best for that at this stage given we have
> conflicts and this has to be delayed until 7.3.
>
> I wonder if given that we should not have this in mm-unstable at all and
> just wait it out until the next cycle begins? Review can happen
> concurrently.

I still dont see why this has to be deferred, I was working with
Andrew to prevent merge headaches.

-- Nico

>
> >
> > -- Nico
> >
> > >
> > > Thanks, Lorenzo
> > >
> >
>
> Thanks, Lorenzo
>


