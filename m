Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDDA5C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 12:43:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF6FE6B0306; Fri, 14 Aug 2026 08:43:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA8246B06A9; Fri, 14 Aug 2026 08:43:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBE236B06AA; Fri, 14 Aug 2026 08:43:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 94A846B0306
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 08:43:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2F0931C0F79
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 12:43:04 +0000 (UTC)
X-FDA: 85099839888.23.5D9D345
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5A67518000B
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 12:43:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PHatWBBq;
	spf=pass (imf16.hostedemail.com: domain of thehajime@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786711382;
	b=amkELAKh3AzkWivgOVB6odWe5DCDdg8WB+UvKGSm9i3T4+9QO+Q5Xl8umYiMH0igcC1oZ2
	A41XMNuWW4UTnLpQYrWNgO9Mbtco0eyVhdsfxpENJOiYbawWXu5+gce2HOiwQaN1NrtfSu
	SQFfSXliO5rAl8iZjVLXnjU2XhiypYc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PHatWBBq;
	spf=pass (imf16.hostedemail.com: domain of thehajime@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786711382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GROTtVEhO+sxIkIUN+C4wkQjV/TpVr5EltjZRDElHMY=;
	b=rcCE1/mYqBBJq4xYNwIu8RsHRMnVziGvsVkvPDHlW2yOqCxIeS5X3s9590cQUg0Ij6WCnr
	xhYvPJ8UL+mNjCGIOw66QZTiX9WjAC1k32reS3/qkbq9KViJSMk9bRr7SYrRvGL+CttdwY
	IVIh/n5umOn+ae1q3cJp2iWBKnmLeO0=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-38ea87caafeso791974a91.3
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 05:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786711381; x=1787316181; darn=kvack.org;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=GROTtVEhO+sxIkIUN+C4wkQjV/TpVr5EltjZRDElHMY=;
        b=PHatWBBqj/tiRt/KbhBWSvZzss8ipWBU1ycSw8f382c/Wpy837es0UdcIZBQ0MLsoU
         NTeuL++ngwXUkcBhcQFghtvJK7Yfz+PrlKYhPh+GjDr42ULWMFVewgLrteGPGc7kRqvn
         7k1CSHzLPRKkq/94TPMAa9rIbtUuZFhIvFfF24VTELBLrysza/N92OzNYr8Ve0uSNuXV
         bsBbQxiaQqTyhSlfknnhJnCRCmMgPkgIfR+tajc0TPQcNgdWlr0cM4nnjQNswNCZqUp1
         MZPSlXATKEhFdSo3i0PA9dJnZByFOIeplgN1dhBlphe74op9g4LnePPNaclYcmRBZE2U
         dz6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786711381; x=1787316181;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=GROTtVEhO+sxIkIUN+C4wkQjV/TpVr5EltjZRDElHMY=;
        b=RxyGaQnJ6m/CVKUTnLKyRFQsX2gmJTn+DyU2w0qNWNagTU4mLYdUy7rIKNQ1sLEgAw
         TRXOLkKWOCMFNdXt5P5vKllCyWrIq1hSWidzASmJjPgmdIVkY9cLLvPJbOiGYh7TzVQB
         4otAmTJugGPCcPPnE4EVtlf9054lxrLkmeMlSZJ8puRUCCCZQBDj/QSHP+LPu8/6PsKn
         mrgJbpKsKfVNdspmCGfkX/Fhs4hZZIgaVd8qBrk7f8bZ/cm1kS1LreWBIFL7UqoHX946
         VVNQ3CPLeaCJsEs1PMfXT7YFfNocz4DxdO6BICrF7i7QeF2Bg14RmBjPJdml8pprolBv
         se2Q==
X-Forwarded-Encrypted: i=1; AHgh+RoZO0J/oR4+qmQTHzx2e3xdzPuljyV+Jww35QHe7l02U7518T2wiw3Pmw7TU3ySdf+ZAuBPVgyGbQ==@kvack.org
X-Gm-Message-State: AOJu0YxTTacL8I17W4UQuknnGJjPqr6kE0kzW9GU4O7gz0WR4wdq+aiB
	OKFraO61DhaGwPTPaW+muDbDN2VzatOyGO1DBtURRTa0QCbgD1o+S0Om
X-Gm-Gg: AR+sD12pBAtlSxA+SALM+Pv7DU35tTt+mRMtR9hRggnJJBa8PYTJiIU0qP/XEm47qlP
	wIPaQl1UmkoaEOsgU7P7UIxbWYABFXo4Q8vXr86rt7YnmUGVRUm1nS316NNN1jBrExF9CmyEyre
	KMRX13E77dEpy6Drpv/uHfOXs5g32wMWb2PzjAfYypyBGMB0f2iGmJVn4hVyYxxAX+75Vz2BBP7
	vDkaxF+yljqyJ7bs9gBUZzzPbbdHEh89CtpDFIkrVtrpWFAFz12TYExR8cTJ91ldnGYRORdVcHV
	pu7KbspAyrF1WTbZCSDfGfLaeNCawEXyNSTCDKxxVhXEMOcf7U+v83SL0wpa9HVRtP1ZMUFmxQg
	NfVDeRMwfHPOBXWws+umWc4IFcgZPjprIqfPuhfyMFhNFHBMDLk5XXmErK/xY2lP2bgdTh7t+CE
	Qp5RlEeSZeu2eGdfgROFWstISLdONJnPRzvoeQcMc7a3EJVoEzbR/3/VS5hayqg/B7NkuD4qftO
	kgtvKX+yOCj3KcOWY2MzeYTp/Z6yxmFQgO44eIrPFlYovQKIFdIcZcGtN/rjY5977LXnRCsSSxg
	WI2VcA==
X-Received: by 2002:a17:90b:3842:b0:38e:524:8797 with SMTP id 98e67ed59e1d1-3933b89a285mr4743746a91.13.1786711380964;
        Fri, 14 Aug 2026 05:43:00 -0700 (PDT)
Received: from mars.local.gmail.com (221x241x217x81.ap221.ftth.ucom.ne.jp. [221.241.217.81])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-394eb7539d3sm2774290a91.15.2026.08.14.05.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 05:43:00 -0700 (PDT)
Date: Fri, 14 Aug 2026 21:42:57 +0900
Message-ID: <m25x1crhym.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: ljs@kernel.org
Cc: daniel@thingy.jp,
	gregkh@linuxfoundation.org,
	linux-mm@kvack.org,
	geert@linux-m68k.org,
	arnd@arndb.de,
	willy@infradead.org,
	jack@suse.cz,
	akpm@linux-foundation.org,
	liam@infradead.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 3/6] mm: nommu: fix an issue on map request to /dev/zero
In-Reply-To: <an3COKVbgQKdY52d@lucifer>
References: <20260813063401.1786548-1-thehajime@gmail.com>
	<20260813063401.1786548-4-thehajime@gmail.com>
	<2026081355-remold-sterility-84f9@gregkh>
	<CAFr9PX=zC8GnxwrR=wTwA4xQq89cHYpxZWooS+-=Q-WuNbjanQ@mail.gmail.com>
	<an3COKVbgQKdY52d@lucifer>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 5A67518000B
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: wouss5brqfqpfknq77hukfdozkfat6mp
X-HE-Tag: 1786711382-114309
X-HE-Meta: U2FsdGVkX1/AhC6tOSNHKbYpGa5e9rR/zJQ7R9bEJrdNgAp9gXk568SVitJ2PROS+z/JmDsE/7aoEtIT7tWUo/cCS7BlMOZKvZV3+fqF0/0zfrYD9AIvJbGA9sIX4xpq56efyaXLwXr71ryP+sV7mHPV5Z4kcFVMgpHQcfG9caJrEnwam4E8hEczB9wBwTLO6etEyXrd/8FFER51EECcqpldjrbu5PXltU4PB6qKOq6R2mAauEn9PpXlMnCt7UbWrznKU3DvTqXKED/MkNncJj082LjqwMM3mF6sVosN6VyIJNQ6xF4st6VA8HAHvbzf1+TV7NfeMNZNgaeCJK5qlT6m4DffEXokDHHzMOFC6Bf2LzPvclmcGHBHHTxq0e4i9Lsiyr0nkDoV4NHBmcFt6AuKWWKz3sDX6PYQ9A5B1ihj7uk4IMWUNguROSLl2PL3w9Y6ROoFFjO3pBSgMxvV6T15YFaTEwP+6Y4MfLDdpOUPHrIwVLw5ZUyiv+97xiyZCy5RCWwyLNJTdhYAPWadMJTOi0sJr4054QFFuvw82wsST9nD2HEdYd2hVaYqD9u6KTim8wJoRjWWsD9Xf0HWuUfQOWjFnTxa4kFqCAfnhAb+8bvwU/CjWWsOrTwF7sBfpQx9Q2jRnc2trR7rf2GUAQ/TyNYh2p3ayuyU6ROKW/n1ZMUOa8RDJb8Ix3sB/UL5OuEdFaGPBWYwKE+2aW6aL8RjX7Nms1vGfLqOFzmGCIoXx09PbTmm51Nyju9/E2fLdd9Ghnbs/bm7b2okX9Q9gyXAHcYW/LVpfK6PTnabl7/zNAHhkAHpVYkhQ4B//Ed4d2RwGHUFrP5/QHUJ73pixtFjGc0edHkwzD/JdnE8Z1a6dXNlssAhqyV9EGPpL8QPb/p1xmR9FRFhLo12HQzNsnofjTsH2dSjixcTY/PYLW/dWE8yep7Flv3GxybUjXMG/0r2kjrrk0QF5r3JlMU
 kFiDzrwu
 1JUenvC8sD+RdYYybBq2oG1UpswLcGzKQzAiePyP93pVxNllrnf2Lja4E3DIYg+Xv6GG1T8MgjNMmbqrOcZeAkBsa6cadZl86u1MJVolX8Lfegzi5iJMmjAfjWYQZCY7BXao96IiHTr3NFgmUjrtpD7mCsDA4j78mN6Jq5L31Zg2rjQ/d3mzwFK4P5ftp4VuslElnjBflWrdPCDZl9bjawnenoRht0c1neIEcqm4SjiaAuDPL29ydkMjoOSflm76/iQS6OCWwxIy+lgzTom5TKSghCahQKvVvopwVXaoCtc+q9BZ55mYvY0od8i1+9O75GhbciogC5SiR0FX4fuLW5ulPBzrrnrCKPq90hs6I4Z95roTTkn/AyWHWQ7A9ZCoTvA3TgU22vVnWbAp+YIY5jAu2nP3T57fRs14tMO9CfR/l0bc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hello Lorenzo,

On Thu, 13 Aug 2026 22:29:38 +0900,
Lorenzo Stoakes (ARM) wrote:
> 
> On Thu, Aug 13, 2026 at 09:43:37PM +0900, Daniel Palmer wrote:
> > Hi Greg,
> >
> > On Thu, 13 Aug 2026 at 21:26, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> >
> > > Given the age of this issue, I don't think anyone uses no-mmu systems
> > > anymore :(
> >
> > There are a few of us using it for hobby stuff[0][1] and there are
> > apparently people using it for actual commercial stuff.
> > There was a session about this at LPC 2025...
> >
> > One of the big problems for nommu seems to be that everyone is
> > convinced it is completely unused and totally broken. :)
> 
> No, the issue is that nobody seems to do any testing or contribute any code
> aside from at least Hajime (thanks Haijme :), and possibly others (forgive me if
> I am missing people's names here!)
> 
> There's been situtions where nommu has been broken for a year and _nobody
> noticed_.
> 
> And yet whenever nommu comes up people always seem to pop up and say how
> important it is, then mention a talk etc.
> 
> Well if it's important, test it. Test the tip kernel. Report bugs. Contribute
> code. Any or all of it :)
> 
> Meanwhile we in mm have to _constantly_ fix stuff up in nommu because it's a
> total mess and has real maintenance overhead.
> 
> Having to account for legacy systems that make no sense in 2026 when you're
> trying to make improvements to systems people use, or not being able to do
> certain things, really grates after a while.
> 
> I mean if you don't believe me git log mm/nommu.c. This overhead reason is why I
> now co-maintain it.

after spending more times to look at code, fixing issues, finding
other flaws, etc, now I become to understand what you meant in past
emails, when you're saying a more maintainable way of implementation
of nommu.c.

Since I wish to use nommu.c in future with the latest kernel, I'd like
to contribute it for, let's say, refactoring the nommu component which
mm subsystem currently has.

but for the moment, I wish to start with introducing test cases from
very basic checks (which is in the [6/6] patch of this series).
Without such a base, we may not have any chances to improve this nasty
situation of nommu component in mm subsystem.

# this motivation also applies to LTP (linux test project) which
  currently doesn't support running tests on nommu platforms (I've
  already started).

And also as I mentioned before, ideally the code should be maintained
by people who use it.  And if I claimed that I used/use/will use
nommu.c, I wish to maintain this, or at least wish to help to decrease
the overhead of maintainers.  This series is a very fist step toward
this.

I hope it clarifies a bit for your concerns,
-- Hajime


