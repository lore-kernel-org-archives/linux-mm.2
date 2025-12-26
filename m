Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84379E8FDAC
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 18:43:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E16C56B0005; Fri, 26 Dec 2025 13:43:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC4AE6B0089; Fri, 26 Dec 2025 13:43:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC7326B008A; Fri, 26 Dec 2025 13:43:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE5E66B0005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 13:43:52 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6666656983
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 18:43:52 +0000 (UTC)
X-FDA: 84262496304.16.D9FE89C
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8DFD780007
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 18:43:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AWbAny1i;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.217.44 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766774630; a=rsa-sha256;
	cv=none;
	b=4zYhURvh0hBQchdCWMkE3RfmzpEgkMmL/7DQFWaOqdF2E81WBBPtLUiltqajjtDHn2V8dE
	fxPjDRIeAQIjV4pihmg/4D7H/CtOvg1qtJNjWQxG0fsucgYos8gZvNe7l0q9wa7k/HazPx
	kfjSFvwvl19M3FOTKJg5wtlfpM6ErZo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AWbAny1i;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.217.44 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766774630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AJjsXKscziHjL5G8tly5miUEYllllBSBDsQmSPlk9iY=;
	b=JGpDslHA+4MBqL+yp7H4VNf3yEBJxWljhNo4+rHv3ySS4qH26/m+2BX7jAB/aN9TvvxJv3
	pUnLxMe62SQQP4aa3fTx3hzvugy/G9M5IEOfPMTFnYz9EYf4lOhRf7uNfjczFlbQUNoxDV
	YfoHZK2hGGUlCfGW3NYjdeWOqwxHIVE=
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-5dfc6be7df3so2646105137.0
        for <linux-mm@kvack.org>; Fri, 26 Dec 2025 10:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766774629; x=1767379429; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AJjsXKscziHjL5G8tly5miUEYllllBSBDsQmSPlk9iY=;
        b=AWbAny1ihr5NOKKif7p9Mxv9MfVQLQZo9mijEyq4uFY3QJIdrUNGWh9hHcjKhPtQiF
         P1rYeOIMRit8rKEY3/IdzXoXWFAUlWHSvuW25wSobDKx6wXoKVj7urR/xFo9Wv+1BRzS
         IyCOsnIWvihcQMpUdRcAV7vDN8Ha+SIhNy4SANR1Wd2//CoM9CYd0UtFtj+wxZM9miXp
         Wp1IRZGyny0ME/k2bqeLraau7N6WnFRA8zJJJh9tECevg8q3HFzlxTFlnK6CT7HiJ8IE
         X93+OMxNgseEuzjPxf2I48S57N16qyKncq3woqJ/Anjkw4MbogUU+c7BLZUo2cbwdwHX
         gzgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766774630; x=1767379430;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AJjsXKscziHjL5G8tly5miUEYllllBSBDsQmSPlk9iY=;
        b=gk6W5+0TLx9ipGJYjM2NeRXxMpZFvExhrV2WDANU4UTJA4hm+AP6ojF/zcJa0lDDJG
         IFCmEJAZrVXEoOJVPoy6yiBLiA4bUahQlZDgdE71eeXdJgZblQgGUUmcWCqiYhkmSi/Q
         82EFOWVa6sAIxinX01fZwSLyw6/CzpJDnK7OX/8ViPnFAsVnEt/OqD7o9Y1WWf1aiTeb
         u66gAU6y5+kuodVI8nwLHrxPLn1J1ITfnkrXT4fveEnyHtiOtQ1VGcshPF8ossL7HWWi
         oZeZEorOp00GzGOLXB0CHGImxzUgopRwnCLeCf0xcxCrqDzEuGPa5oMz90BVNnaY/I21
         ZpKw==
X-Forwarded-Encrypted: i=1; AJvYcCUoAnG3/LE0tJ3FbkdvktgTO7oe7pS2EDsgpwWFhL+vppy/oGrCYI19CCthz4c5eG9LJI01zpgXVw==@kvack.org
X-Gm-Message-State: AOJu0YxM9Vx5SqgeDIWjOxeHBAcUATRZVScNSgSNHQn3ICLgqhflUFf7
	jFQJkBBam3oZKcNWdgqG5DEJ3MxaHpWj1P4kEzhmdQqSDU6NLXl6sIh4pfsk7UfR2ucEU53wn7M
	6Vxmhz+pvyyvf0b5h6N/VZ1rfUCb6mew=
X-Gm-Gg: AY/fxX6kP+l79jKj4SD9QqNCR92W6bSM01v6brmdY/Zpot7jZxkzMcmYzFMx7WFlQGw
	9jtqznwtGFqYP4+1Vrb1TDoWEVG7qxh2ICP6z4cD3FeQvmVoMNIwR4NyP3gisFPhpl3RIJc2MPl
	uVM50fv22y8NIyBk5uSb8aiU8x56GSfoAqwPAFmdayXUoKkprCRtCN+kckTdCaAEXOtD52qR81Y
	rFeT1f+Qeqs/sehACN8MuvtDSsT1un/AtFA3tfl109JCA9lyoL2Bnq5PAxCSLcDfvs+xw==
X-Google-Smtp-Source: AGHT+IFWm1BHVCgCz2zTsLBhD7w/jnavaf615z1Cg8E3jCFm6C0snGNtsrbsTf+upqBpfzQeQlKsbB0atGIBTB7JvCQ=
X-Received: by 2002:a05:6102:442c:b0:5db:cfb2:e602 with SMTP id
 ada2fe7eead31-5eb1a656c43mr6743668137.11.1766774629497; Fri, 26 Dec 2025
 10:43:49 -0800 (PST)
MIME-Version: 1.0
References: <20251225094057.286954-1-wale.zhang.ftd@gmail.com>
 <CAGsJ_4yEAOxUmrPvca3Nzc-OB0+xXk5Y5gzszsY5TPqHCGvgcQ@mail.gmail.com> <CAHrEdetNrGJbogkhMKY-25fgtxupPxKKLkwFGuenV8p5EwzZVQ@mail.gmail.com>
In-Reply-To: <CAHrEdetNrGJbogkhMKY-25fgtxupPxKKLkwFGuenV8p5EwzZVQ@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 27 Dec 2025 07:43:37 +1300
X-Gm-Features: AQt7F2qeAC7SiLMrBSchjbEF6oNKpYWhGFiPxdC477fZ9SuDsudhVPpMbYu_0bY
Message-ID: <CAGsJ_4wcovpuNKPTfS0STBOHrNREjP-4wam8Oe4e7_ctKsbAcA@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm,swapops: Fix compile error on set_pmd_migration_entry.
To: wale zhang <wale.zhang.ftd@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, chrisl@kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8DFD780007
X-Stat-Signature: z56w7o79yrai3whqrykmtbsootujzfas
X-Rspam-User: 
X-HE-Tag: 1766774630-387180
X-HE-Meta: U2FsdGVkX1/MT6g9DL/tibifXfJbd/a6moxHE3gFAJI5Cwsug4imvjEirqCgPmo1AFugHFlILYD26OAT7IUHl9/5MqU0hlMStuUHrKDBTiN6h8AAYlwitejNqsA9ENBmMgp1ZJhU3ffNlpgkRPKGKSmTZPZeOj/klll6rGuLoxtqI1PKsjfsUdtJqltgrMEVQ66ZyhvHvB14jvmArH1FJM1hKyrK4k//RQM3o4P0CU+bqjnkt/ALzRAhPtUox+CMSHhNVDPdUfJD/n6ZjLnNKX//NvpYCF444wT7ZPKVGdTtADJDA7ka/mSUTyNHTrU7ww3tqQjNyME82q0kAlmNnrp8ND38BXs+v6eFzS93rsGC0ICORClHBfEQtKW6D/drZGfQ5X2hUnwS29M8sJUc6QuLuW/EGEHEOQXmafCu4EkkWqhjSG/2V1ZBpnzyApLJ9Ms5Ni4eXIKq3yyqAHAFa6NUFqYi0hG/BhcnolmDYnLJmYWwYKLNQSrmq0Wgs2RN0Hn/c5nWJgQALFPBPBlyGz+r2fYgJ7BTf2NYYxSWIN7XnIWkcNAmLPs+m9aPb8hSJc033DfVhx+orU41XbNHnEEcqtvrVio8U4HK0ZS1y4C2GCd+qnlD3dhgHCRHif2nr/j8m+elOMInRjoiu0hNPf5bT7dXi0SorzH1rjt1h8FHf/g0m4IymR3tld9D2DTqgmnvFZPHjnDLzqRAIfpq6xeX2q7AXaryh1+9XG/6zviFfmjVcHHzyHEgwyyPgbVoejJqYBFJ80PxdJfLhH71Vndl6u8y2kgpc14ZLgZE6ACN4St/D9qaxc7AxBq3Xfbj+sdXPUUcajG1jWjg0Jgf7KYSx+wbS9vsGhuci4w5u20shIWyh3ukNCNhEUUuty6TvodUegiVlBOETD9/6bu1YAJckA9WMv2VPoQACPyuNd2IuUalN0f1pbbjoFm3k8mIEFlSvkKrmwg53g+NQwH
 Jlah3KS0
 4CBtARu3IT3g45YVYqkb3hEH3TMXyDOJ8d3C8VJkSBCFp+HsjAeUg2u9nl7hBvSE00Z8EIX9p8LRI3OUiUO6RfLvtB1CCseRZQhaj2sFkca6KTDcNtfYL1+qXZRWrKwVZzq0GMY5A8AHUgB68tvJ/gzdno9i6IwJIfNEUru63PqXiBate//aiYtv0EjwK1QgXlm3RqGlJvobrcJpThJBFBK6kCxvmqTySTzxxYnBNTOMl6rWxTCBeXv3xyVjzCiWTH9lKFpWkBZygJJ+5nv1z0IeV0VOCobxi0VCGls1mCQx72hx/1SXifXFZUXnUi4BvTizHhV+fJ+3caFv+siL0cz81Yy8ANj6bn8EUgHDnEqYfv+Y1qwSM5s6J/eOuPiqw7qlAX2pq7aEJl0QaAlZ43tNEvRLbqud3/T9la43rAPI7kS0QYc6E/PnB/f1/OQem3P0zVnlqcE2q6U4y7FZUBom9Nv6dS+b8mHlunGsQdS+iFcJbE/OIKLaAqkcffYBTrgsf9i9gQIKlpeE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 27, 2025 at 12:46=E2=80=AFAM wale zhang <wale.zhang.ftd@gmail.c=
om> wrote:
>
> On Thu, Dec 25, 2025 at 6:22=E2=80=AFPM Barry Song <21cnbao@gmail.com> wr=
ote:
> >
> > On Thu, Dec 25, 2025 at 10:41=E2=80=AFPM Wale Zhang <wale.zhang.ftd@gma=
il.com> wrote:
> > >
> > > ../include/linux/swapops.h: In function =E2=80=98set_pmd_migration_en=
try=E2=80=99:
> > > ../include/linux/swapops.h:346:1: error: no return statement in funct=
ion returning non-void [-Werror=3Dreturn-type]
> > >   346 | }
> > >       | ^
> > > cc1: some warnings being treated as errors
> > >
> > > Signed-off-by: Wale Zhang <wale.zhang.ftd@gmail.com>
> >
> > Sorry. NAK.
> >
> > This looks odd. We already have a BUILD_BUG(), so no fix is needed.
> >
> > we should already have:
> > ././include/linux/compiler_types.h:631:45: error: call to
> > =E2=80=98__compiletime_assert_907=E2=80=99 declared with attribute erro=
r: BUILD_BUG
> > failed
> >   631 |         _compiletime_assert(condition, msg,
> > __compiletime_assert_, __COUNTER__)
> >       |                                             ^
> > ././include/linux/compiler_types.h:612:25: note: in definition of
> > macro =E2=80=98__compiletime_assert=E2=80=99
> >   612 |                         prefix ## suffix();
> >          \
> >       |                         ^~~~~~
> >
> > Do you actually see this being built? If so, please help identify why i=
t
> > gets built.
>
> Hello Barry,
>
> I compile the 6.19-rc2 for arm64 with -O0, this kind of error log will ap=
pear.
> In file included from /home/wale/repo/linux/master/include/linux/leafops.=
h:11,
>                  from
> /home/wale/repo/linux/master/include/linux/userfaultfd_k.h:19,
>                  from /home/wale/repo/linux/master/include/linux/mm_inlin=
e.h:10,
>                  from /home/wale/repo/linux/master/mm/internal.h:13,
>                  from /home/wale/repo/linux/master/mm/fadvise.c:24:
> /home/wale/repo/linux/master/include/linux/swapops.h: In function
> =E2=80=98set_pmd_migration_entry=E2=80=99:
> /home/wale/repo/linux/master/include/linux/swapops.h:346:1: error: no
> return statement in function returning non-void [-Werror=3Dreturn-type]
>   346 | }
>       | ^
> cc1: some warnings being treated as errors
> make[4]: *** [/home/wale/repo/linux/master/scripts/Makefile.build:287:
> mm/fadvise.o] Error 1
> make[4]: *** Waiting for unfinished jobs....
>
> There is an example on my
> github(https://github.com/wale-ftd/linux/commits/linux-6.12/) that
> used -O0 to compile the 6.12 kernel. If you're interested, you can
> check them out.

This is not my question. The BUILD_BUG here means this code
should never be built. If it is built, then that indicates a bug.
So my question is: under what kernel configuration would this
code actually get built?

Thanks
Barry

