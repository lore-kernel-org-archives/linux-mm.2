Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAA30CD8CA8
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 22:01:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DA346B00CA; Tue,  9 Jun 2026 18:01:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08A456B00CC; Tue,  9 Jun 2026 18:01:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E93866B00CD; Tue,  9 Jun 2026 18:01:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CFF346B00CA
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 18:01:09 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 63076407F5
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 22:01:09 +0000 (UTC)
X-FDA: 84861745458.24.289B28E
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 435BD20008
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 22:01:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="lZjv/CTI";
	spf=pass (imf13.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781042467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1NtSP0SUwGm7j9cBn9U8+z1zuObW3D+JrhcLu8mBRJU=;
	b=SSNodRQfBda80ExR5h4nOaqvw6oeIbQY1BJhyr/vKiiCS5SMrLaMWaLMqc8OhOowNOLS94
	GyNQ/FaRU7CxorEguMUpxMbgTkpuAGtBnQw8/uzNkAsXGDWisTBcgg/3FYuTZUu6a71Gpr
	nyyLs1bSJgmcrxZQAK3bSyEDvZH3BSs=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="lZjv/CTI";
	spf=pass (imf13.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781042467;
	b=LAGRgNSsBI32DCVV73gMIaIieQTW+UupJtpmRCJgzhn/Ba51Go3pYXKjyraE6ITvQElVuN
	xByPlfzzh6lqhi/HcM/NEuPVkM4m8liJ1oNocwRofeAMEiPul+KeSoALW6f+eYCwSyEK7M
	CIo7QKBbjyrdnabU7cPwgEI2P27KOgw=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2bf2911f93cso8145ad.1
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 15:01:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781042466; cv=none;
        d=google.com; s=arc-20240605;
        b=Q21RsX4j7dFxZlJVDIItJPKVoL+DYwW10xr7LrLR4M5x26YGHUfNi81BMiGJwFGxQz
         OpvJ2PkmPCLiNDmXm0KNvETX0W2pAHPUnkzzeKF5zEqzP8mcqKpBp7dVc1ZmKmJCA3VD
         yb48mN1K0OzpKyDffWhONpZ16kA1wLXLpioHgx0Ua4RVRCrJr0Ax7B117IdfHLpQR96v
         ssQqlIzTa/QQMRvd68hG7brQiyYCsBwDfcj04vYaSirr4K34wmWWT2VmAw9y03gZFCGJ
         zgJQNCLRzUD+pC+iUhD9mIdGZYor6CywsCCtLoCYuWKAg9N0xxW/s5HyDrIaHSqRsUtB
         XPxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1NtSP0SUwGm7j9cBn9U8+z1zuObW3D+JrhcLu8mBRJU=;
        fh=s5rbEoBXTXLDjRSQbRXGJfRDFbeOw2Q3Vb8JGw075cs=;
        b=ctT4gnHdZBIOeQxflI8rYIfsCkYynKFKpMdIiqQY+MZ307KRjH0xs4X21AU+meYrYl
         8fEZlZ2hL03YTa3+fcYaL5zE8Ei6woKXfm3Ih/F9dRxUiqATVDaI53sTwz3f9/RmkNef
         IzHyHKzao92bpWljW/tC8s14QU7LeDS8JyqdnjXDm5VZ2Jo2/FMGp+TZHUoGRbIcGOlP
         ko1r4ykWwTxmUDo9xh0FvBCgDwLg8uup2Iz3HDah765zjIJT1PBAjZfXICALvuJsDdee
         q1MxwOq9mPTQGC5CxInzEA8et4LVUJGGFaSSoOYLOu4ZLhhbuuEyXrtnlNg5XfKlK27T
         866A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781042466; x=1781647266; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1NtSP0SUwGm7j9cBn9U8+z1zuObW3D+JrhcLu8mBRJU=;
        b=lZjv/CTIc9gIF2aNE+vFzjUMet7ZyW+8tp/qjyGAGS358V1sSF8L7l6k1Y49xFXN40
         8btNRYLk7pv9v/+ijCVc0gt4tNDaKs/BO2ok8oZPHGWDlZzJRRNq+b0+Rqb1PFlDUGFa
         qjaV5nVHG6ZRfs828pvjXLr8CtC1fdwCRsJdfuHyq3Jgl7wI8W/QEIR+e1papZwWX8Y/
         Q7UZHFHiOhfZ3X6hA7CmXmyP1CYKSXfXoHVzbBQ9Fyt/YWUYMvWXlbso8wk3bJwQGgP7
         e1otQ5QQKJmUuOhLbqtmSJTM79nHJadsuQaq3Vzo6yXOejlOGqlQDfQhxWqqhtS2GTvm
         3tHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781042466; x=1781647266;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1NtSP0SUwGm7j9cBn9U8+z1zuObW3D+JrhcLu8mBRJU=;
        b=rSCgDJBfxp7soOOSBgqCjn3oztK2aco1Dgn2WoEtjhM0YR7vaPfUcZI2lbUg7ILItg
         qPQYz5nQcLurULqEzMJdEzj50JDjzYZr5/42CtI+tIM4lKekmSmtpuHhCq8Ex/u0AFUa
         jV21G2CteF7LlO52Kk10I4QArr23W1cEUy1Y8tnPJ090f1sq77czzQF0DnNdsW5GXV3k
         T6EjeueYgAfsuwJM+xgWIJAGeSQULJbYoSJ5cKrJx25OO6QpPkJlJKXUKqh8UbXn4xVD
         DsGr19kbGu7s6sRELpZAYGCBbcKj/V8gB0Ek0t3lcWEAGYierjuuPI+oyN3GBkntTccp
         G/bw==
X-Forwarded-Encrypted: i=1; AFNElJ+U21u1DYa33tzyiIM1j6MLYHoCtcGFa3o8wT10jEnK7d2X13cn7PWiLqKwADgWK1ReaxJtw8cwBw==@kvack.org
X-Gm-Message-State: AOJu0Yxrf2wNFYt5OHCHezXm8VTtItA3q3sHNRd12vLWNlE+VuFeBFhV
	xkklCuUDzJfDU53vBrKQkFZQ403INRckK57ublKuzEL6EPVpjrWMZvdXZgG0xbunFzhio56CnLu
	f/uWn03NVnPMVwJKNSRLhJfzFQlKy7vO35MDgAvR7
X-Gm-Gg: Acq92OEWzWG0kRW8oxQ1kDiBQs77iIcWKr71kXdwFfIJZ4+ir7fRe1cS6hjxBpUaBNx
	nXCPqpbsMx5rY+hURjveHDyw1hsnYa4MrywNmUtInJNnO+pUFuR9IjsLCDkX5yCFLtkNEiXPihv
	TXzVvCnGjJMbK4cqd08IWXhIrU08dBr61LaCJhLpMkryZvRB9yiCk75KA6fGjjD+i3rtlyA9QdP
	vSUEOPUTEPExDLAJ0HkxeaEfGDXv8w+Oix+HVWhShSygB+XZMWkGuKSBKTi31nKk8RXzOQtiyO4
	G8PHJg++iJXU07nl25p4Nybv9ehIvhYooSeEi4wUI4HFCRxQZegfSYqEUwk=
X-Received: by 2002:a17:902:d2d2:b0:2b0:b925:da98 with SMTP id
 d9443c01a7336-2c1eb729f9amr8197905ad.19.1781042462584; Tue, 09 Jun 2026
 15:01:02 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1780701922.git.abhishekbapat@google.com>
 <0e91fdd3a88dbe5220d15c4c8ff7b8f66e86af7c.1780701922.git.abhishekbapat@google.com>
 <41a7ebb9-1113-4f13-abbf-6f55d99d62f3@linux.dev> <CAL41Mv7jOJ0rtAEDZP2DEGa5d1GfTbK=DXg8k1BL5qjFuQjNuA@mail.gmail.com>
 <2b7fa423-c721-4157-96ba-93bee5010044@linux.dev> <CAL41Mv5ZzuVRy5cjp_Ozn=9QCpCe1mFS36o25Z1dnbYCvNs9+Q@mail.gmail.com>
 <CAL41Mv6XfbSMUvdU9btrtsh-HXejCH=HZmCuTL1gKRe2XAPvpQ@mail.gmail.com>
In-Reply-To: <CAL41Mv6XfbSMUvdU9btrtsh-HXejCH=HZmCuTL1gKRe2XAPvpQ@mail.gmail.com>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Tue, 9 Jun 2026 15:00:50 -0700
X-Gm-Features: AVVi8CeRKyHBDVE23XU6WUHDaYn9m65HDG64T09E-rZM88Ujcm7iUS2g5TRRM9Y
Message-ID: <CAL41Mv41N43YZOa3jcRWvY+5NP7fO8DCv5vMfLx06Pv_90jwwQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] alloc_tag: add ioctl to /proc/allocinfo
To: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 435BD20008
X-Stat-Signature: 6qqhctoptzy4xqtkqafanu8xkr4ouu5i
X-Rspam-User: 
X-HE-Tag: 1781042467-140290
X-HE-Meta: U2FsdGVkX18ATSaHyDV+p02rWT3b+f7QLiNlV5CnodLu8TPCw5xQKThuCJK6l4tTdfe1zI6A4RSNVmYcA8ND9Eugr+lEwLGopQkxKv3r2hmXP4nyIyaRIl7QqFMbfLv/6zI38wc6mxJjdu9P9FsgDpM1aFTt5zd9YHpFXXO51tGJrMjqykL7u+cHEvdgJRYOTxnCdW/bYOAHs78F8e9U09QHGjXQOvg1Lgcu7qWONEzpoKluYwAsgWDjAtQ36++U0eo2ffkR//rNDtSBQhHdQ5YiK/oNtPJvi2GU2Z+4mxzy2JMZ+DryYy+mY3sFwqukF1PbBdVp5yn+kfrGjms9kNJhBbmmYzQqcnRuKMITsbT4FsAEqbp0eRqMArpA3jrPWwkG8mg8/PfXVdO1cD365nD99f7xCpDs34P2zbfG5/aAz3DdvHGzh1zIY+i5zyoSI9f4qXa6tA1OWytmkrcsrMyNVMS0kuwauIWrTUaNBJ+OO2f/Gf6cJJmqRQlI1+3dsqsFm/9dDRJeDR2tJolXP5KGzAqjtH54Rug/357mlKRKbjV08SqtCeUD+ocg2WRsT3/KbqTx2o8L8qbJwdUNpaE9Eh3MZ+K3W6+HWW+jotbp91FIDxSNeBHKZHUUjg3hqoJM7HVCi4tysqanNRmTKAY8sEt6BM4WrDumAJRQT4uatSjsAnb/vfXbGjciiYB+iBOusUpvTmdqGPG6JAx+0o2REgCvQcfwqrs8cYxEX6WCfLh4KpbgcqjrrQ+HTdv7CLTbb0O9reGiJAQOUTLOjf7mH9+17mAoVvDLmYi/QpB/q6PTaAkroVUQBFAig7Qri/UvupBwCq+qgMpM1KWzP4NwtgHTbaU14SWmTWzSbJ/AsOA59l+rpqoavQDBue1n8ga9CGtgOorW3Jieg2jf3MVI8451XT8uFf4zD3sXWikwcaiCMlF5WOPg6+CQmG1+AJeypc6oW7lDPW0IIH0
 dfAGhppO
 BD2cWcaQgV5YlTF8bu286AvqgndJZYfeSO9Um7oXPw5tdWnSSylX/bguDb89hwM921WZHCEdZ0AkNZ3ne19ydo3cEfsE7ehvrRr+T402vPJOb3qc4uMv4JwXYvfEoDiKSLLHtvOuRSrOEz92rHaY7ufUJfuvjYT7kAStNzXje3W94LfHkPlG1WnHU7p6v8YEaFc80odprCuC/O0deHTetqcatwpTaaEbcJd1/Rb+km2K5iKzgYmm0TTiiYwS43IiAI3+7MkoBNQSxdx4NaHErzv5yUwpZF5K9GjNz66glDIFjifAYXiDS+V2FqQn3TlLJ0Pk5OJDAiEA5qQA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 9, 2026 at 2:54=E2=80=AFPM Abhishek Bapat <abhishekbapat@google=
.com> wrote:
>
> On Tue, Jun 9, 2026 at 1:51=E2=80=AFPM Abhishek Bapat <abhishekbapat@goog=
le.com> wrote:
> >
> > On Mon, Jun 8, 2026 at 6:44=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
> > >
> > > Hi Abhishek
> > >
> > >
> > > On 2026/6/9 08:19, Abhishek Bapat wrote:
> > > > On Sun, Jun 7, 2026 at 6:53=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wr=
ote:
> > > >> Hi Suren and Abhishek
> > > >>
> > > >>
> > > >> Thanks for the new version.
> > > >>
> > > >>
> > > >> On 2026/6/6 07:36, Abhishek Bapat wrote:
> > > >>> From: Suren Baghdasaryan <surenb@google.com>
> > > >>>
> > > >>> Add the following ioctl commands for /proc/allocinfo file:
> > > >>>
> > > >>> ALLOCINFO_IOC_CONTENT_ID - gets content identifier which can be u=
sed
> > > >>> to check whether the file content has changed specifically due to=
 module
> > > >>> load/unload. Every time a module is loaded / unloaded, the return=
ed
> > > >>> value will be different. By comparing the identifier value at the
> > > >>> beginning and at the end of the content retrieval operation, user=
s can
> > > >>> validate retrieved information for consistency.
> > > >>>
> > > >>> ALLOCINFO_IOC_GET_AT - gets the record at the specified position.=
 This
> > > >>> is the position of a record in /proc/allocinfo.
> > > >>>
> > > >>> ALLOCINFO_IOC_GET_NEXT - gets the record next to the last retriev=
ed
> > > >>> one. If no records were previously retrieved, returns the first
> > > >>> record.
> > > >>>
> > > >>> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > >>> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > > >>> ---
> > > >>>    Documentation/mm/allocation-profiling.rst     |   5 +
> > > >>>    .../userspace-api/ioctl/ioctl-number.rst      |   2 +
> > > >>>    MAINTAINERS                                   |   1 +
> > > >>>    include/linux/codetag.h                       |   2 +
> > > >>>    include/uapi/linux/alloc_tag.h                |  54 ++++
> > > >>>    lib/alloc_tag.c                               | 232 ++++++++++=
+++++++-
> > > >>>    lib/codetag.c                                 |  18 ++
> > > >>>    7 files changed, 312 insertions(+), 2 deletions(-)
> > > >>>    create mode 100644 include/uapi/linux/alloc_tag.h
> > > >>>
> > > >>> diff --git a/Documentation/mm/allocation-profiling.rst b/Document=
ation/mm/allocation-profiling.rst
> > > >>> index 5389d241176a..c3a28467955f 100644
> > > >>> --- a/Documentation/mm/allocation-profiling.rst
> > > >>> +++ b/Documentation/mm/allocation-profiling.rst
> > > >>> @@ -46,6 +46,11 @@ sysctl:
> > > >>>    Runtime info:
> > > >>>      /proc/allocinfo
> > > >>>
> > > >>> +  Profiling data can be retrieved either by reading `/proc/alloc=
info` directly as
> > > >>> +  text or programmatically via `ioctl()` calls defined in `<uapi=
/linux/alloc_tag.h>`.
> > > >>> +  The ioctl interface supports structured binary data extraction=
 as well as filtering
> > > >>> +  by module name, function, file, line number, accuracy, or allo=
cation size limits.
> > > >>> +
> > > >>>    Example output::
> > > >>>
> > > >>>      root@moria-kvm:~# sort -g /proc/allocinfo|tail|numfmt --to=
=3Diec
> > > >>> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b=
/Documentation/userspace-api/ioctl/ioctl-number.rst
> > > >>> index 331223761fff..84f6808a8578 100644
> > > >>> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> > > >>> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> > > >>> @@ -349,6 +349,8 @@ Code  Seq#    Include File                   =
                          Comments
> > > >>>                                                                  =
         <mailto:luzmaximilian@gmail.com>
> > > >>>    0xA5  20-2F  linux/surface_aggregator/dtx.h                   =
         Microsoft Surface DTX driver
> > > >>>                                                                  =
         <mailto:luzmaximilian@gmail.com>
> > > >>> +0xA6  00-0F  uapi/linux/alloc_tag.h                             =
       Memory allocation profiling
> > > >>> +                                                                =
       <mailto:surenb@google.com>
> > > >>>    0xAA  00-3F  linux/uapi/linux/userfaultfd.h
> > > >>>    0xAB  00-1F  linux/nbd.h
> > > >>>    0xAC  00-1F  linux/raw.h
> > > >>> diff --git a/MAINTAINERS b/MAINTAINERS
> > > >>> index a31f6f207afd..77f3fc487691 100644
> > > >>> --- a/MAINTAINERS
> > > >>> +++ b/MAINTAINERS
> > > >>> @@ -16711,6 +16711,7 @@ S:    Maintained
> > > >>>    F:  Documentation/mm/allocation-profiling.rst
> > > >>>    F:  include/linux/alloc_tag.h
> > > >>>    F:  include/linux/pgalloc_tag.h
> > > >>> +F:   include/uapi/linux/alloc_tag.h
> > > >>>    F:  lib/alloc_tag.c
> > > >>>
> > > >>>    MEMORY CONTROLLER DRIVERS
> > > >>> diff --git a/include/linux/codetag.h b/include/linux/codetag.h
> > > >>> index ddae7484ca45..a25a085c2df1 100644
> > > >>> --- a/include/linux/codetag.h
> > > >>> +++ b/include/linux/codetag.h
> > > >>> @@ -77,6 +77,8 @@ struct codetag_iterator {
> > > >>>    void codetag_lock_module_list(struct codetag_type *cttype);
> > > >>>    bool codetag_trylock_module_list(struct codetag_type *cttype);
> > > >>>    void codetag_unlock_module_list(struct codetag_type *cttype);
> > > >>> +unsigned long codetag_get_content_id(struct codetag_type *cttype=
);
> > > >>> +unsigned int codetag_get_count(struct codetag_type *cttype);
> > > >>>    struct codetag_iterator codetag_get_ct_iter(struct codetag_typ=
e *cttype);
> > > >>>    struct codetag *codetag_next_ct(struct codetag_iterator *iter)=
;
> > > >>>
> > > >>> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/=
alloc_tag.h
> > > >>> new file mode 100644
> > > >>> index 000000000000..901199bad514
> > > >>> --- /dev/null
> > > >>> +++ b/include/uapi/linux/alloc_tag.h
> > > >>> @@ -0,0 +1,54 @@
> > > >>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> > > >>> +/*
> > > >>> + *  include/linux/alloc_tag.h
> > > >> nit: it should be include/uapi/linux/alloc_tag.h
> > > >>
> > > >> (I guess you may have missed the comment I brought up before. It i=
s not
> > > >> a critical problem though.)
> > > >>
> > > > Apologies, I missed that comment earlier. Included in the v4 patchs=
et.
> > > > Thanks for bringing this up.
> > > >
> > > >>> + */
> > > >>> +
> > > >>> +#ifndef _UAPI_ALLOC_TAG_H
> > > >>> +#define _UAPI_ALLOC_TAG_H
> > > >>> +
> > > >>> +#include <linux/types.h>
> > > >>> +
> > > >>> +#define ALLOCINFO_STR_SIZE   64
> > > >>> +
> > > >>> +struct allocinfo_content_id {
> > > >>> +     __u64 id;
> > > >>> +};
> > > >>> +
> > > >>> +struct allocinfo_tag {
> > > >>> +     /* Longer names are trimmed */
> > > >>> +     char modname[ALLOCINFO_STR_SIZE];
> > > >>> +     char function[ALLOCINFO_STR_SIZE];
> > > >>> +     char filename[ALLOCINFO_STR_SIZE];
> > > >>> +     __u64 lineno;
> > > >>> +};
> > > >>> +
> > > >>> +/* The alignment ensures 32-bit compatible interfaces are not br=
oken */
> > > >>> +struct allocinfo_counter {
> > > >>> +     __u64 bytes;
> > > >>> +     __u64 calls;
> > > >>> +     __u8 accurate;
> > > >>> +} __attribute__((aligned(8)));
> > > >>> +
> > > >>> +struct allocinfo_tag_data {
> > > >>> +     struct allocinfo_tag tag;
> > > >>> +     struct allocinfo_counter counter;
> > > >>> +};
> > > >>> +
> > > >>> +struct allocinfo_get_at {
> > > >>> +     __u64 pos;      /* input */
> > > >>> +     struct allocinfo_tag_data data;
> > > >>> +};
> > > >>> +
> > > >>> +#define _ALLOCINFO_IOC_CONTENT_ID    0
> > > >>> +#define _ALLOCINFO_IOC_GET_AT                1
> > > >>> +#define _ALLOCINFO_IOC_GET_NEXT              2
> > > >>> +
> > > >>> +#define ALLOCINFO_IOC_BASE           0xA6
> > > >>> +#define ALLOCINFO_IOC_CONTENT_ID     _IOR(ALLOCINFO_IOC_BASE, _A=
LLOCINFO_IOC_CONTENT_ID,     \
> > > >>> +                                          struct allocinfo_conte=
nt_id)
> > > >>> +#define ALLOCINFO_IOC_GET_AT         _IOWR(ALLOCINFO_IOC_BASE, _=
ALLOCINFO_IOC_GET_AT,        \
> > > >>> +                                           struct allocinfo_get_=
at)
> > > >>> +#define ALLOCINFO_IOC_GET_NEXT               _IOR(ALLOCINFO_IOC_=
BASE, _ALLOCINFO_IOC_GET_NEXT,       \
> > > >>> +                                          struct allocinfo_tag_d=
ata)
> > > >>> +
> > > >>> +#endif /* _UAPI_ALLOC_TAG_H */
> > > >>> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> > > >>> index d9be1cf5187d..a0577215eb3d 100644
> > > >>> --- a/lib/alloc_tag.c
> > > >>> +++ b/lib/alloc_tag.c
> > > >>> @@ -5,6 +5,7 @@
> > > >>>    #include <linux/gfp.h>
> > > >>>    #include <linux/kallsyms.h>
> > > >>>    #include <linux/module.h>
> > > >>> +#include <linux/mutex.h>
> > > >>>    #include <linux/page_ext.h>
> > > >>>    #include <linux/pgalloc_tag.h>
> > > >>>    #include <linux/proc_fs.h>
> > > >>> @@ -14,6 +15,7 @@
> > > >>>    #include <linux/string_choices.h>
> > > >>>    #include <linux/vmalloc.h>
> > > >>>    #include <linux/kmemleak.h>
> > > >>> +#include <uapi/linux/alloc_tag.h>
> > > >>>
> > > >>>    #define ALLOCINFO_FILE_NAME         "allocinfo"
> > > >>>    #define MODULE_ALLOC_TAG_VMAP_SIZE  (100000UL * sizeof(struct =
alloc_tag))
> > > >>> @@ -47,6 +49,10 @@ struct allocinfo_private {
> > > >>>        struct codetag_iterator iter;
> > > >>>        struct codetag_iterator reported_iter;
> > > >>>        bool print_header;
> > > >>> +     /* ioctl uses a separate iterator not to interfere with rea=
ds */
> > > >>> +     struct codetag_iterator ioctl_iter;
> > > >>> +     bool positioned; /* seq_open_private() sets to 0 */
> > > >>> +     struct mutex ioctl_lock;
> > > >>>    };
> > > >>>
> > > >>>    static void *allocinfo_start(struct seq_file *m, loff_t *pos)
> > > >>> @@ -130,6 +136,229 @@ static const struct seq_operations allocinf=
o_seq_op =3D {
> > > >>>        .show   =3D allocinfo_show,
> > > >>>    };
> > > >>>
> > > >>> +/*
> > > >>> + * Initializes seq_file operations and allocates private state w=
hen opening
> > > >>> + * the /proc/allocinfo procfs entry.
> > > >>> + */
> > > >>> +static int allocinfo_open(struct inode *inode, struct file *file=
)
> > > >>> +{
> > > >>> +     int ret;
> > > >>> +
> > > >>> +     ret =3D seq_open_private(file, &allocinfo_seq_op,
> > > >>> +                            sizeof(struct allocinfo_private));
> > > >>> +     if (!ret) {
> > > >>> +             struct seq_file *m =3D file->private_data;
> > > >>> +             struct allocinfo_private *priv =3D m->private;
> > > >>> +
> > > >>> +             mutex_init(&priv->ioctl_lock);
> > > >>> +     }
> > > >>> +     return ret;
> > > >>> +}
> > > >>> +
> > > >>> +/*
> > > >>> + * Cleans up the seq_file state and frees up the private state a=
llocated in
> > > >>> + * allocinfo_open() when closing the /proc/allocinfo file descri=
ptor.
> > > >>> + */
> > > >>> +static int allocinfo_release(struct inode *inode, struct file *f=
ile)
> > > >>> +{
> > > >>> +     return seq_release_private(inode, file);
> > > >>> +}
> > > >>> +
> > > >>> +/*
> > > >>> + * Returns a pointer to the suffix of a string so that its lengt=
h fits within
> > > >>> + * ALLOCINFO_STR_SIZE, preserving the trailing characters.
> > > >>> + */
> > > >>> +static const char *allocinfo_str(const char *str)
> > > >>> +{
> > > >>> +     size_t len =3D strlen(str);
> > > >>> +
> > > >>> +     /* Keep an extra space for the trailing NULL. */
> > > >>> +     if (len >=3D ALLOCINFO_STR_SIZE)
> > > >>> +             str +=3D (len - ALLOCINFO_STR_SIZE) + 1;
> > > >>> +     return str;
> > > >>> +}
> > > >>> +
> > > >>> +/* Copy a string and trim from the beginning if it's too long */
> > > >>> +static void allocinfo_copy_str(char *dest, const char *src)
> > > >>> +{
> > > >>> +     strscpy_pad(dest, allocinfo_str(src), ALLOCINFO_STR_SIZE);
> > > >>> +}
> > > >>> +
> > > >>> +/*
> > > >>> + * Populates the UAPI allocinfo_tag_data structure with active r=
untime
> > > >>> + * profiling counters extracted from the given kernel codetag.
> > > >>> + */
> > > >>> +static void allocinfo_to_params(struct codetag *ct,
> > > >>> +                             struct allocinfo_tag_data *data)
> > > >>> +{
> > > >>> +     struct alloc_tag *tag =3D ct_to_alloc_tag(ct);
> > > >>> +     struct alloc_tag_counters counter =3D alloc_tag_read(tag);
> > > >>> +
> > > >>> +     if (ct->modname)
> > > >>> +             allocinfo_copy_str(data->tag.modname, ct->modname);
> > > >>> +     else
> > > >>> +             data->tag.modname[0] =3D '\0';
> > > >>> +     allocinfo_copy_str(data->tag.function, ct->function);
> > > >>> +     allocinfo_copy_str(data->tag.filename, ct->filename);
> > > >>> +     data->tag.lineno =3D ct->lineno;
> > > >>> +     data->counter.bytes =3D counter.bytes;
> > > >>> +     data->counter.calls =3D counter.calls;
> > > >>> +     data->counter.accurate =3D !alloc_tag_is_inaccurate(tag);
> > > >>> +}
> > > >>> +
> > > >>> +/*
> > > >>> + * Retrieves the unique content ID representing the current allo=
cation tag module
> > > >>> + * layout, allowing userspace to detect if modules were loaded /=
 unloaded.
> > > >>> + */
> > > >>> +static int allocinfo_ioctl_get_content_id(struct seq_file *m, vo=
id __user *arg)
> > > >>> +{
> > > >>> +     struct allocinfo_content_id params;
> > > >>> +
> > > >>> +     codetag_lock_module_list(alloc_tag_cttype);
> > > >>> +     params.id =3D codetag_get_content_id(alloc_tag_cttype);
> > > >>> +     codetag_unlock_module_list(alloc_tag_cttype);
> > > >>> +     if (copy_to_user(arg, &params, sizeof(params)))
> > > >>> +             return -EFAULT;
> > > >>> +
> > > >>> +     return 0;
> > > >>> +}
> > > >>> +
> > > >>> +/*
> > > >>> + * Seeks the ioctl iterator to the specified 0-indexed tag posit=
ion, reads its
> > > >>> + * profiling data and returns it to userspace.
> > > >>> + */
> > > >>> +static int allocinfo_ioctl_get_at(struct seq_file *m, void __use=
r *arg)
> > > >>> +{
> > > >>> +     struct allocinfo_private *priv;
> > > >>> +     struct codetag *ct;
> > > >>> +     __u64 pos;
> > > >>> +     struct allocinfo_get_at params =3D {0};
> > > >>> +
> > > >>> +     if (copy_from_user(&params, arg, sizeof(params)))
> > > >>> +             return -EFAULT;
> > > >>> +
> > > >>> +     priv =3D m->private;
> > > >>> +     pos =3D params.pos;
> > > >>> +
> > > >>> +     mutex_lock(&priv->ioctl_lock);
> > > >>> +     codetag_lock_module_list(alloc_tag_cttype);
> > > >>> +
> > > >>> +     if (pos >=3D codetag_get_count(alloc_tag_cttype)) {
> > > >>> +             codetag_unlock_module_list(alloc_tag_cttype);
> > > >>> +             mutex_unlock(&priv->ioctl_lock);
> > > >>> +             return -ENOENT;
> > > >>> +     }
> > > >>> +
> > > >>> +     /* Find the codetag */
> > > >>> +     priv->ioctl_iter =3D codetag_get_ct_iter(alloc_tag_cttype);
> > > >>> +     ct =3D codetag_next_ct(&priv->ioctl_iter);
> > > >>> +     while (ct && pos--)
> > > >>> +             ct =3D codetag_next_ct(&priv->ioctl_iter);
> > > >>> +     if (ct) {
> > > >>> +             allocinfo_to_params(ct, &params.data);
> > > >>> +             priv->positioned =3D true;
> > > >>> +     }
> > > >>> +
> > > >>> +     codetag_unlock_module_list(alloc_tag_cttype);
> > > >>> +     mutex_unlock(&priv->ioctl_lock);
> > > >>> +
> > > >>> +     if (!ct)
> > > >>> +             return -ENOENT;
> > > >>> +
> > > >>> +     if (copy_to_user(arg, &params, sizeof(params)))
> > > >>> +             return -EFAULT;
> > > >>> +
> > > >>> +     return 0;
> > > >>> +}
> > > >>> +
> > > >>> +/*
> > > >>> + * Advances the ioctl iterator to the next allocation tag in the=
 sequence and
> > > >>> + * returns its profiling data to userspace.
> > > >>> + */
> > > >>> +static int allocinfo_ioctl_get_next(struct seq_file *m, void __u=
ser *arg)
> > > >>> +{
> > > >>> +     struct allocinfo_private *priv;
> > > >>> +     struct codetag *ct;
> > > >>> +     struct allocinfo_tag_data params;
> > > >>> +     int ret =3D 0;
> > > >>> +
> > > >>> +     memset(&params, 0, sizeof(params));
> > > >>> +     priv =3D m->private;
> > > >>> +
> > > >>> +     mutex_lock(&priv->ioctl_lock);
> > > >>> +     codetag_lock_module_list(alloc_tag_cttype);
> > > >>> +
> > > >>> +     if (!priv->positioned) {
> > > >>> +             priv->ioctl_iter =3D codetag_get_ct_iter(alloc_tag_=
cttype);
> > > >>> +             priv->positioned =3D true;
> > > >>> +     }
> > > >>> +
> > > >>> +     ct =3D codetag_next_ct(&priv->ioctl_iter);
> > > >>> +     if (ct)
> > > >>> +             allocinfo_to_params(ct, &params);
> > > >>> +
> > > >>> +     if (!ct) {
> > > >>> +             priv->positioned =3D false;
> > > >>> +             ret =3D -ENOENT;
> > > >>> +     }
> > > >>> +     codetag_unlock_module_list(alloc_tag_cttype);
> > > >>> +     mutex_unlock(&priv->ioctl_lock);
> > > >>> +
> > > >>> +     if (ret =3D=3D 0) {
> > > >>> +             if (copy_to_user(arg, &params, sizeof(params)))
> > > >>> +                     return -EFAULT;
> > > >>> +     }
> > > >>> +     return ret;
> > > >>> +}
> > > >>> +
> > > >>> +/*
> > > >>> + * Entry point ioctl function for /proc/allocinfo routing reques=
ts to fetch the
> > > >>> + * layout content ID, seek to a specific tag, or read sequential=
 tags.
> > > >>> + */
> > > >>> +static long allocinfo_ioctl(struct file *file, unsigned int cmd,
> > > >>> +                         unsigned long __arg)
> > > >>> +{
> > > >>> +     void __user *arg =3D (void __user *)__arg;
> > > >>> +     int ret;
> > > >>> +
> > > >>> +     switch (cmd) {
> > > >>> +     case ALLOCINFO_IOC_CONTENT_ID:
> > > >>> +             ret =3D allocinfo_ioctl_get_content_id(file->privat=
e_data, arg);
> > > >>> +             break;
> > > >>> +     case ALLOCINFO_IOC_GET_AT:
> > > >>> +             ret =3D allocinfo_ioctl_get_at(file->private_data, =
arg);
> > > >>> +             break;
> > > >>> +     case ALLOCINFO_IOC_GET_NEXT:
> > > >>> +             ret =3D allocinfo_ioctl_get_next(file->private_data=
, arg);
> > > >>> +             break;
> > > >>> +     default:
> > > >>> +             ret =3D -ENOIOCTLCMD;
> > > >>> +             break;
> > > >>> +     }
> > > >>> +
> > > >>> +     return ret;
> > > >>> +}
> > > >>> +
> > > >>> +#ifdef CONFIG_COMPAT
> > > >>> +static long allocinfo_compat_ioctl(struct file *file, unsigned i=
nt cmd,
> > > >>> +                                unsigned long arg)
> > > >>> +{
> > > >>> +     return allocinfo_ioctl(file, cmd, (unsigned long)compat_ptr=
(arg));
> > > >>> +}
> > > >>> +#endif
> > > >>> +
> > > >>> +static const struct proc_ops allocinfo_proc_ops =3D {
> > > >>> +     .proc_open              =3D allocinfo_open,
> > > >>> +     .proc_read_iter         =3D seq_read_iter,
> > > >>> +     .proc_lseek             =3D seq_lseek,
> > > >>> +     .proc_release           =3D allocinfo_release,
> > > >>> +     .proc_ioctl             =3D allocinfo_ioctl,
> > > >>> +#ifdef CONFIG_COMPAT
> > > >>> +     .proc_compat_ioctl      =3D allocinfo_compat_ioctl,
> > > >>> +#endif
> > > >>> +
> > > >>> +};
> > > >>> +
> > > >>>    size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t =
count, bool can_sleep)
> > > >>>    {
> > > >>>        struct codetag_iterator iter;
> > > >>> @@ -993,8 +1222,7 @@ static int __init alloc_tag_init(void)
> > > >>>                return 0;
> > > >>>        }
> > > >>>
> > > >>> -     if (!proc_create_seq_private(ALLOCINFO_FILE_NAME, 0400, NUL=
L, &allocinfo_seq_op,
> > > >>> -                                  sizeof(struct allocinfo_privat=
e), NULL)) {
> > > >>> +     if (!proc_create(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinf=
o_proc_ops)) {
> > > >>>                pr_err("Failed to create %s file\n", ALLOCINFO_FIL=
E_NAME);
> > > >>>                shutdown_mem_profiling(false);
> > > >>>                return -ENOMEM;
> > > >>> diff --git a/lib/codetag.c b/lib/codetag.c
> > > >>> index 4001a7ea6675..a9cda4c962a3 100644
> > > >>> --- a/lib/codetag.c
> > > >>> +++ b/lib/codetag.c
> > > >>> @@ -19,6 +19,8 @@ struct codetag_type {
> > > >>>        struct codetag_type_desc desc;
> > > >>>        /* generates unique sequence number for module load */
> > > >>>        unsigned long next_mod_seq;
> > > >>> +     /* bumped on every module load and unload */
> > > >>> +     unsigned long content_id;
> > > >>>    };
> > > >>>
> > > >>>    struct codetag_range {
> > > >>> @@ -50,6 +52,20 @@ void codetag_unlock_module_list(struct codetag=
_type *cttype)
> > > >>>        up_read(&cttype->mod_lock);
> > > >>>    }
> > > >>>
> > > >>> +unsigned long codetag_get_content_id(struct codetag_type *cttype=
)
> > > >>> +{
> > > >>> +     lockdep_assert_held(&cttype->mod_lock);
> > > >>> +
> > > >>> +     return cttype->content_id;
> > > >>> +}
> > > >>> +
> > > >>> +unsigned int codetag_get_count(struct codetag_type *cttype)
> > > >>> +{
> > > >>> +     lockdep_assert_held(&cttype->mod_lock);
> > > >>> +
> > > >>> +     return cttype->count;
> > > >>> +}
> > > >>> +
> > > >>>    struct codetag_iterator codetag_get_ct_iter(struct codetag_typ=
e *cttype)
> > > >>>    {
> > > >>>        struct codetag_iterator iter =3D {
> > > >>> @@ -204,6 +220,7 @@ static int codetag_module_init(struct codetag=
_type *cttype, struct module *mod)
> > > >>>
> > > >>>        down_write(&cttype->mod_lock);
> > > >>>        cmod->mod_seq =3D ++cttype->next_mod_seq;
> > > >>> +     ++cttype->content_id;
> > > >> I have a comment on the content_id bump placement.
> > > >>
> > > >> ++cttype->content_id is placed before idr_alloc and the module_loa=
d
> > > >>
> > > >> callback. If idr_alloc fails or module_load returns an error
> > > >>
> > > >> (While the chance of this occurring is very low.), the idr entry g=
ets
> > > >>
> > > >> rolled back but content_id has already been bumped. The actual
> > > >>
> > > >> content didn't change in this case, so userspace would see a
> > > >>
> > > >> different content_id and assume the data is inconsistent when it
> > > >>
> > > >> isn't.
> > > >>
> > > >>
> > > >> Thanks
> > > >>
> > > >> Best Regards
> > > >>
> > > >> Hao
> > > > While I agree with your comment, I decided to place the counter
> > > > increment there because the chance of failure is low. Furthermore,
> > > > even if it falsely invalidates user data, the user will simply quer=
y
> > > > the content again. This placement also aligns with where the
> > > > previously used field (cttype->next_mod_seq) was incremented. Let m=
e
> > > > know if you still think I should move it. Thanks!
> > >
> > > Sorry, I should have marked this as a nit when I raised the comment.
> > >
> > > Given its low probability of occurring, it doesn't block anything for=
 now.
> > >
> > > The reason I raised this comment was just in case someone adds new lo=
gic
> > >
> > > in the feature  that could fail. But if that happens, we can move bot=
h
> > > next_mod_seq
> > >
> > > and content_id down together.
> > >
> > >
> > > Thanks
> > >
> > > Best Regards
> > >
> > > Hao
> > >
> >
> > Sounds good, so for now I am not touching this patch and keeping it as
> > is other than the file path nit inside the UAPI header file.
>
> Actually, checkpatch is complaining about using the same filename
> inside of the file and hence I am dropping that comment completely.
>
Actually, I realized the header file lacked a proper copyright notice,
so I'm including that.

> > > >>>        mod_id =3D idr_alloc(&cttype->mod_idr, cmod, 0, 0, GFP_KER=
NEL);
> > > >>>        if (mod_id >=3D 0) {
> > > >>>                if (cttype->desc.module_load) {
> > > >>> @@ -368,6 +385,7 @@ void codetag_unload_module(struct module *mod=
)
> > > >>>                        cttype->count -=3D range_size(cttype, &cmo=
d->range);
> > > >>>                        idr_remove(&cttype->mod_idr, mod_id);
> > > >>>                        kfree(cmod);
> > > >>> +                     ++cttype->content_id;
> > > >>>                }
> > > >>>                up_write(&cttype->mod_lock);
> > > >>>                if (found && cttype->desc.free_section_mem)

