Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF435CA0FF0
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 02:07:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 002558E0112; Tue, 26 Aug 2025 22:07:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEE7A8E0105; Tue, 26 Aug 2025 22:07:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D40B18E0112; Tue, 26 Aug 2025 22:07:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BEF318E0105
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 22:07:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6E04458E56
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:07:24 +0000 (UTC)
X-FDA: 83820900408.14.3849959
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9B61A20005
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:07:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ymWuVpll;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756260442; a=rsa-sha256;
	cv=none;
	b=xwGGghj+wToNjVGgf9nEOt8bR0llYPYKflKYt28ZVJzxVaqbZgr6FhGowgBhruCcdCWcrs
	iKQXKmHaWs+r3KIJhtK6mPLLDIgoHfHwFcHHZ7jDpsLLZ1I3Im1gWixyxXNpPoe8csZWKg
	oPXXrT2+MCM7WOKbqjvEVi4425YPTRE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ymWuVpll;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756260442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VWX1UVSegYtqh42uuyT4sZDPXoT9oomNFyTW1xLHoJI=;
	b=NZdQJ10x0wO1uAiSce+WNvMKnaSxVDUPTDEKtpjOyzVLfEE4kQ4ALgeE81mKPLoy83Hho6
	5LxwcSqW6vt3g3S0Fdz0cK6ENm9o0REsIp7Vtuf2K42v1YuoxcyIqPRYjSmfgGmYeETp2Y
	CHTqjLWHx4gxRf8GCeu9Gp0Z4Yiaf48=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4b29b715106so98711cf.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756260442; x=1756865242; darn=kvack.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VWX1UVSegYtqh42uuyT4sZDPXoT9oomNFyTW1xLHoJI=;
        b=ymWuVpllhJI0AUSbehDyiOZGaq+h/ugcQZc6pgV4eDBuLt4N878sAQuxjhMuoG3yO9
         HzhZjn1NgHeWQFgQNmjJ2SheB5bNDkc0odB1N9g+cqESVG3VqZZGDI3QEcaeqHc9W0fu
         +n+1Sq3ZhqM32hi2TKHj99MKEWwYaE5AaaEdSShog0T09Aregix+MNU6qJu9JVyQuviY
         0R7FX8SDXbTN9k1yEYYRzUcv0bVpHXlRXvcEsuvOFXvrsoesDgT5fIwe6rNBLGkrYHfB
         jXgcW968spsEAninmRRyfnHYo+i4hkdp8JPc0aqJoz5fWJ+KXyMTKKQzVBce+6hEY+FK
         d+4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756260442; x=1756865242;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VWX1UVSegYtqh42uuyT4sZDPXoT9oomNFyTW1xLHoJI=;
        b=b5OjtMJxxBM7trzZ1w+qudX0wdOlcHE8cD18ao0iqCKNXQ1akWbysNXEwUdgRrNeNL
         rDqzAiiqylA2CeggkrkhJ/9/WGAmUCFmSKRqWXWkwsS+KHAc/Dui7rXT+k7VUrTlUCld
         r1zED24949IOmdLLZ8QlJoE7T31ogugVMN0oQUNURpkpsTJS98kqrzaPofPIBZyveSr2
         rn95HHShvOHXrk9Ivr0aJZem4WQyCcoYQqbexucNs0Nl/muCy0DkbiHhhIv9a+F3ex7G
         d1vmQUWQeKQRr056Z2agdshWae0rdi+cjDvzgrEYOea5nEGqbil6j6FnK7ukezYu8z3T
         Ft8A==
X-Forwarded-Encrypted: i=1; AJvYcCV30FwI5LitdgEcBG4pKDgjXiy9VbpO1c8ZniG4kn2pWeLhheQ2ErpaE/2cjbBuJUSEmO4T2TNewQ==@kvack.org
X-Gm-Message-State: AOJu0YwQvkI+LMlAZ9n2UyrZZfXxRcTyZayjUoh/pMFVgsrS8SDCShhH
	rNZMvDf7ypmbkTB5EGIJElHz8YJlvejJliXcUyuw3diWgAAlMzadhq9TjxFJbcaIF0BzVcni2kF
	1vcJyJ4Noo1ug7Stsh869FyR5oerrcdHEV7oGDd7d
X-Gm-Gg: ASbGnctPAishP3AfS3j6n3zltkUpz/LzGk2dKJ/ZYZZyTIw7N/icK4gYACxh1qiarGV
	7H7SoN7j9HNtwk9VwHd1BwUBw00fRVL9oLK64TLuFM2fDVvu7qawRa2cj+PT+rBrH4ELfPsU3CT
	jV+GEa3XrfgzkPpMwhuNVXj88jLl0nTiaeASeBsZa1HZkQOPzY6SjS0ODc1fMX3AlBWXaizJtcv
	OX85YlC7IFc
X-Google-Smtp-Source: AGHT+IFRogYzpdvS27VPQDT5BDVWZvTYES2bLTvixxXlJL96BhN7ryYeZ5qbgFBB2ozo2W0txPoOEgVSyoAgjFH5kAk=
X-Received: by 2002:a05:622a:4d97:b0:4b2:ecb6:e6dd with SMTP id
 d75a77b69052e-4b2ecb6edecmr4306431cf.1.1756260441328; Tue, 26 Aug 2025
 19:07:21 -0700 (PDT)
MIME-Version: 1.0
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
 <20250723-slub-percpu-caches-v5-12-b792cd830f5d@suse.cz> <CAJuCfpFKjKAAyXgW_SFBXEp9N55txYdayw2h+=cSLO7wLvO2Pw@mail.gmail.com>
 <nhw4odptloo5dzmawss4q3mg7b5mtcfcs2z4flnqpduws7tlfj@hy75m647kp5z>
In-Reply-To: <nhw4odptloo5dzmawss4q3mg7b5mtcfcs2z4flnqpduws7tlfj@hy75m647kp5z>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 26 Aug 2025 19:07:10 -0700
X-Gm-Features: Ac12FXyqChrZHz3YR-zpLBKUsTqUb5c1nq9CXpqMMwcgYfcr33pd3dv9X5JM3cY
Message-ID: <CAJuCfpE8+u73+COnB=SHmjJKHYJncLgdt8VMGCXR3JDDZ0+s0w@mail.gmail.com>
Subject: Re: [PATCH v5 12/14] maple_tree: Sheaf conversion
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rcu@vger.kernel.org, maple-tree@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B61A20005
X-Stat-Signature: ksyyz85dj54hauesogekef7uhizkqeim
X-HE-Tag: 1756260442-767384
X-HE-Meta: U2FsdGVkX18vABGf7jYWWpjGexGFLPRtZxcPku3TmVzdXDik8gkans89ThzKTTCPU1/t1k3OjJX+Ff1SS8PFTcnm2Ntt2pHPbuuQb1Kx3vDviRMaLCEO5RmRRE5ga8/knFLH/EVAkEQw3ko88L3w7RJVuBPWOI11KroN2CL8d4POgPUxyfaipiXW29OWycycQg2dmcUUZ2SJjQhnZwv8sULJbX7boLWht1J5kPJ1uKu62BBIA2OiB7PqJEflM37f382cVTf448eZHgnFOlVgivrzcdWyNuSsGZTsYEEID6sOX83YNNzOZdiE5WfUG0s+IkjGk5vL33GdTNEx2mUEG0iMDON0jWo2eybTnYFd8bM5nYPMG30gk0K572MeW4BiaLso7J+wQyWX+5af7xmo35Ci/VlR6yVXG7iEU8dsCiYnOtJuNrEYLxRwarY0mSdAN7abgYXs4bXRE0c+aViwa3nKrG3Au2tVovAGwKyD8Gwxy67wTdMb4bvyzl90VdTJ4235fiXGfM+XdT8s4GqsKkaAftzec5QBLjnlzEJKIZWIHUlv3Nvjdm15xx+2p+Liz3WUN37XnrgxpzxuBrItPqu6bmv+rMmwopMBIxO5aA/V19xIo6GSI5YLSTfGYQwYXUwXWRVDgATpHJ48piSiJtV++zw2/vkm9VT0AUKPX6adw9OpVFq1riLbECCphXIWREizzV112iXuzxiUkQwy1cwfRQuzKSCyvTJHSTx8Dgid1hVn+j5lUMVly15t5kGEEWUoeLjYX0olyRt8yI9Ii84mX48WymYloAQE68nl9ZUkIl4BA4zqHyL9T5+Xh+uajqqMU8oMrIMfA3vetlWjXv+BDpL3DRcJi0KWZoQky9Nb8Sod0Cp8N6tNxOeU4Jagfxic3nStowUQiO7telQw0c3dnEkwTdCx6HGIjh8huUyfYC7Ps9MR5FwhTDKbouaQ4G8cmTDdkqujXfUmPXl
 Ltwp8mYU
 NxL8qTMEdGEPNM7C2b4LioC+DNVo8WK/q6GiFl6uc1j21/zkMHo0Q0PdRBbgCYDlIMl9ETR+R8VReESTxKCvG3a8o9/d9MrEMtywelfg38GXVaK7KGxZmFUhairS/DcL59ysVguWg94cZQzxQSGC51zjuI+OwP1cIZbJWtA1ZBOXtrZ2isEjwJMt7foGv2nGefcCWd1lkTC8kbUwx7pZUvvdCwcyRd+s29+FFOrtsfdR5IrBjRYWS0RG9DB2bAf1nW4vL4c+7V+8ZGkq9oNC9uduVoSXkwMCU4/ZB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 7:22=E2=80=AFAM Liam R. Howlett <Liam.Howlett@oracl=
e.com> wrote:
>
> * Suren Baghdasaryan <surenb@google.com> [250822 16:18]:
> > On Wed, Jul 23, 2025 at 6:35=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz=
> wrote:
> > >
> > > From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > >
> > > Use sheaves instead of bulk allocations.  This should speed up the
> > > allocations and the return path of unused allocations.
> >
> > Nice cleanup!
> >
> > >
> > > Remove push/pop of nodes from maple state.
> > > Remove unnecessary testing
> > > ifdef out other testing that probably will be deleted
> >
> > Should we simply remove them if they are unused?
>
> Yes, I think it's time to drop them.
>
> >
> > > Fix testcase for testing race
> > > Move some testing around in the same commit.
> >
> > Would it be possible to separate test changes from kernel changes into
> > another patch? Kernel part looks good to me but I don't know enough
> > about these tests to vote on that.
>
> Yes.  I'll do that.
>
> I'll drop testing first then the feature so that testing will continue
> to pass on bisection.
>
> I will also stop moving tests around in this change.
>
> >
> > >
> > > Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> > > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> > > ---
> > >  include/linux/maple_tree.h       |   6 +-
> > >  lib/maple_tree.c                 | 331 ++++----------------
> > >  lib/test_maple_tree.c            |   8 +
> > >  tools/testing/radix-tree/maple.c | 632 +++++++----------------------=
----------
> > >  tools/testing/shared/linux.c     |   8 +-
> > >  5 files changed, 185 insertions(+), 800 deletions(-)
>
> ...
>
> I didn't see any changes in the code block, but please let me know if I
> missed them.

I was referring to the changes in include/linux/maple_tree.h and
lib/maple_tree.c as kernel changes and the rest as test changes.

>
>
> Thanks,
> Liam

