Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53E51C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:24:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D3846B00BA; Wed, 29 Jul 2026 10:24:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 483F96B00BD; Wed, 29 Jul 2026 10:24:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34BE66B00C5; Wed, 29 Jul 2026 10:24:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F0B6E6B00BA
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:24:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AE712C05EE
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:57:49 +0000 (UTC)
X-FDA: 85041665058.29.25A35FA
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	by imf03.hostedemail.com (Postfix) with ESMTP id C46FC20009
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:57:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="B/diQPW8";
	spf=pass (imf03.hostedemail.com: domain of jakovnovak30@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=jakovnovak30@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785326267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dcH4aYYuKoXJSYfGcjaRA3AXaiTJLDBIulQO5B/oLDo=;
	b=8c+ubXcwIjesHlKc+YC78CWHlq3J58foM6Jh2LsamEK2Nb1awRpi8P1A+OgURPIa0/lQ5m
	o9EN+wm2rmagv7IP/Ha2Ox/9jPYPytEQPUVHun0DoLrgLmXbysYjLmpB3bVsavLUZBZ6R/
	SdNav0P+8E0C4KqQC2mr3fifQW5PPaY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785326267;
	b=xiTUsrhI/c8bwONaEBrBTsjw0I8SVOJF80t8DsjO8gIEbd3vDjs+tLezOfsbos2uqwzZX3
	q1dHrJLV9DD1ZctZ2nE2YFp3Y85zpZ3YyAoobc2qapF8x2WcZi8gVBugrehG9Y7vgQoFgt
	iLb8REbZg+DjHPautvB9evpH2M5QPFg=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="B/diQPW8";
	spf=pass (imf03.hostedemail.com: domain of jakovnovak30@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=jakovnovak30@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-39c74c469e8so5294841fa.0
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 04:57:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785326266; cv=none;
        d=google.com; s=arc-20260327;
        b=C+ySpqpQEYAxQs77migA6aygiJJRmBJNHZpu3UhIS06EeIEldWxbqNN0AJcQdcvcXI
         CFOymzhyaj141mN+/MQh2f4cn++mYT/VjlWmFJrmmp/wzrQChe7jRqU7pRwLvvQY1Umi
         rg1ptH7hPYKJ97lRxyxmjerYhXP/WLim413rTnQ09yIB7pch5Rutg6znYukI3kKOcGfD
         YBOYUdmXgQsfl5rbYHHzGjpCqTvT3vFxw8+XTNFooTpN731C8FyLNyw9d1P8+MguURks
         sBTr9CCgOVgriVVqazwuQCYv7UyDJL6vOM+8r+HW9eir191QMJRb3ZvdRlqwVRgmC/Pj
         teNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dcH4aYYuKoXJSYfGcjaRA3AXaiTJLDBIulQO5B/oLDo=;
        fh=rJt6KBUMaqdDbIXw6hY9JFdlePgtRHSM7RHnPjGA6vk=;
        b=LjRUtIrIHynkS9nC0IPj4hq6IoL493Se+ejAfBHMPcjeBKoRG6kMoDu25NLUWvFTk6
         ZB086QGNZ8h7VH3utGssJh2PpRh6PXgEZlQm7457UCi9ycl06gfkuDaUGcno6GVhtXx4
         1nYKaF+Qpyut8HW25yUbRl3xN6NQyFeGk1hBOcOr+auAiV7PV5a3g9gt0yx67yjZ0ZJ4
         /ZmQDemj0EbmMOKaSuLqDbiGzYSDYxVN4rIszdfhbJhsvH4diav+oMuEf6mG2MKav/Vt
         7O4AEkQ7Sc320e7LxqFWwW53NnQFB5BINSO6TYljvCfUQ8LdS0IYs3XPTrHDu2bLWGbC
         KjVQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785326266; x=1785931066; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dcH4aYYuKoXJSYfGcjaRA3AXaiTJLDBIulQO5B/oLDo=;
        b=B/diQPW8ZElaJUwpSurLwfx5SQmgh8csaQEPeWuybZxPjPvtGPeCIHQ9kLvA5skPzy
         qOzC/gJCGwa9FpdrBQYoTL+McCZ5YbQqLT3Qoa4RYlSUcsUETvYUQ6x9b9FwtDFC5Lqi
         em6d/8R53F38JQO6fDs0aMNCPdkL5Jxk6/51wVsf5oCfmWoZ0xBWyPtyz485Lti1FMeV
         fjw2iGxXeWVTffOESNdn4wBpNwrJEW/7ufge+HjMQtQChdVG1+F3hmgiZ+Uu22qhO2dD
         pVZ6R+WqQ4E9301q2pSYpmWgHQoNAKk17eY/OHM/NhQKYkdyJMsn5QNCre6Jzyhd4jqd
         IpIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785326266; x=1785931066;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dcH4aYYuKoXJSYfGcjaRA3AXaiTJLDBIulQO5B/oLDo=;
        b=GlEl99BYGX1g84EAnU39nazHNCsr8WtfpvirCP8jmQSVgvCG6Jvq4VXCZk1mPg4llx
         iwgv7EOsnUx81+EaUvA9i/LXtXdWwGHm2/EOqN/2CxWg773hQls4ZpOV4MJSOq3efQEe
         YodlLeyafTnm4EQKjOXp4N1Q4nCIkYvxxOOhrrTiO7XA56LvKgxqXhj4nCE+OD9D4cbU
         piosEQvmciYQiZiNnTvgAm/j02pmQ5RYE75IzMKus23ESo3s1S8sSot+dRBn/dsxMsel
         83xvPRJzwXpat0h/V61Cf6MnMH9Djr6ZAQI1491+1wqcG9O6fxfc3BAWmOvB4zuX2zPl
         NYtg==
X-Gm-Message-State: AOJu0YxnO1fpDqOLN8VOyJ85RyV48LNjjr/oxgiXh1Vpm7kYeWJYD3pY
	5BO8vIhOt/J2+r6RB7zWwdebw/ZdvScJ4Hg/zeqUqDlOzevl07bHPQduvoVdJTq+Gj2MA4l5WI3
	w39421D0dTkUULuQhZ5ZM4ImeY7haoA==
X-Gm-Gg: AR+sD13DQAiTJW0+zbGqYSEwXQfk78wYWDukzWyiQck5hwTKMwZceo8qxJqCQU1d7yM
	AYuouso9MYaVunkH5i3PLw7yZ8ueZJB7poyaj0D1QZf8cQf8EIeq6e5fZf3zJI+OLLDItJrJwv+
	YY10EZnyg3eDJo2MboSuyLPd/4ihCzw//gvUcHn98RsgvCBkitWDglz3pusu/E2WLMVdmCR+9Dx
	eJvrBzP2rWh4Fc0wKteg1jwmiqAoBc4JBm5Fvz9dfv+BC+y89IudE7WOPkQJ6ocLZhnbzN8eby6
	Elo+fooUIhK/hyjQMLMvqKQZj6IhfoCOUx5k3KMKwsIEOokleXE2gMWGVoDxCyRi8Ki0ljCBkkf
	e3f/Ozi1DjNtInGoN9Ju4a7w=
X-Received: by 2002:a05:651c:b0a:b0:39c:7089:8053 with SMTP id
 38308e7fff4ca-39f51eaff35mr14776261fa.29.1785326265114; Wed, 29 Jul 2026
 04:57:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260728204636.20998-2-jakovnovak30@gmail.com> <b78f734a-440d-4fad-bba8-df77894c5aa0@kernel.org>
In-Reply-To: <b78f734a-440d-4fad-bba8-df77894c5aa0@kernel.org>
From: jakov novak <jakovnovak30@gmail.com>
Date: Wed, 29 Jul 2026 13:56:49 +0200
X-Gm-Features: AUfX_mwf1PG6jikzexvDJHP2AFA6m_tRT9_DJ5v8FJfou5IEMZUwV0atpg6abhU
Message-ID: <CAPUiDP1POYKJQ=Gfm-irzUmGaSNfZm+qO0xGP7Z=FO8a=R-6Kw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/khugepaged: replace mutex_lock/mutex_unlock usage
 with guard macro
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kernel-mentees@lists.linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"\\ Liam R . Howlett \\" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Shuah Khan <skhan@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C46FC20009
X-Stat-Signature: mxk3kpgux5ep18o7b7hh76i4yqcgpeb3
X-HE-Tag: 1785326267-713947
X-HE-Meta: U2FsdGVkX1+vVNpaqnNQQzAxr3BLep2CenbhDDlCEEWGRIelPzZqhTtJW6/G1CIXbdx+Ffr9b4fnwsFsI0YALA14GCFOZL4yg3g/jPFMixXPQFuXbJZqtlML0nd26UNT/ITDFCPo+8kTRHTNe+TB1URYISnr9Oq82b9TexMXzuPub9A4mdrGfZW8P1hjtrCNLDhuiB1l4xMbodgF2uKf//BhPOx5Xlf7LiF76Nw4BHcmqonH+8RKx99aLDjItpoIGIPcMfJZT+AkMDGq1YgLR50TafJj0ZS1LOcGtm/T/D5tYlK8BpbFPVYBlijH3BQok1MxyVF1R1Dr3UbRCsIX8uRIoi2vdQ+zGKbaikRDYxgUmnrcBtOlmJsVyTxKxK0BXNfWEIRvTFtyruLRlp5bTECwEgn3nrrICA9lG44z2vICHbT8Dh/KR92i8/MkoMzMcw+uaT1zKbdpR3T22Agu7zuILRRQJ6S9WuT0ZBW33ybasGNQRDM08tULr1Y+akLdKnzJuz4Sz6Z3yzCR+N+R7EvojwE7l+6BBsQubAEJdFUc0Ro51AQI7hqpRzHKOikLtBDhM0nrG5GYYRq0rmm3WuktOyVJgIa/MINmRxVfmBIZjpkQe/aCQ9zyqEFgY2ot6EBqKzZoLr5ydETu7Ni8BzXV1HfDwQ4c2vmyt9FcL7sh01yWYUVjEDfWcB/sjsH98C+kpsJ29x/T5RMRZcd9oVeYvKK3kxeGFVtX4HqCWNoc896okGH1prnPMoSa1xNIPSozKZ9l+AIvmMu+ZvRA90zYbTrYDRvFj0nIny14WP5yTs5v1aeehm2vdWenvLAZKCsFnIDxVfOKPhsMYy6rv52zn+wyFaPKYdf5sMFCOzROnOTH5p0qTZGNKVWT7Wz9eiZhNnHbK1E20I3SnKIMoShakc/f7YOccWgFxApdSObW7izRRER4h0nKFO6iDSphGdtYl1yGLkUIHxb5XUC
 iYr9vZSb
 bmdOy7MAUZ/ip7b9B/Eners4uU3F5CtqlZ+jaSkXWycFswkzn24WZt6Mr846eO4lNv+WBOUnqHIFDU1BEbIq0fom1RRTs7FS6vlWiZKG7DaP1flioGAz7VhpS24yfz3vWiqpwsTg0ldIlDCN21SINd+CY8Wk5UETLlZ6MjzayEJ7jzAURsxsF8Pp8rW0MnXQrLzIFW9qw3SYC8urVtVZ+3qKD3dXuhtBz3YEU0r81Zv2yiMCpliX/0cMYtWBcnH7SSzK8pxPFAV04gR8YtjVm0N2R1sBKMTfrnePS5kjwZ5N2q4SKmwa+AozMLELz/HUMEW/1bMxDDcwbxzg62YonqQiE6ZUPQ9RDkxE5ASZSuYfM+kTjKcCV70HVwSajrCFqwYWDNTl0p7FwhwsJj6O3XoJi/LVffEPkDbrm48dRYSwQH1jdKurO4bBzVRdDrQyLvZYdbQh0oQEExaAsrYdVv80E7Np3pHhqGq4rxwmguJRUSxN+VTiIEHpEWryaJhtEzTYYwciCbdhJloa+pds5xNPTvIFEyvV1syFtRvDo5fVDwuQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I guess the error checking could be moved inside the if
(!khugepaged_thread) block like:

if (!khugepaged_thread) {
  struct task_struct *new_thread =3D kthread_run...

  if (IS_ERR(new_thread)) {
    pr_err...
    return PTR_ERR(new_thread);
  }

  khugepaged_thread =3D new_thread;
}

I can send a v3 with these changes if this looks good to everybody.

Best,
Jakov

On Wed, Jul 29, 2026 at 9:56=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 7/28/26 22:46, Jakov Novak wrote:
> > Currently, khugepaged locks the khugepaged_mutex in two functions:
> > start_stop_khugepaged and khugepaged_min_free_kbytes_update. Remove
> > mutex_lock/mutex_unlock usage in these functions and replace it with th=
e
> > guard macro. This makes the code more readable (removing a goto stateme=
nt)
> > and makes it harder to introduce bugs in the future.
> > No functional changes introduced.
> >
> > Signed-off-by: Jakov Novak <jakovnovak30@gmail.com>
> > Reviewed-by: Dev Jain <dev.jain@arm.com>
> > Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> > v2:
> >   - Added #include <linux/cleanup.h> to the includes at the top of the =
file
> >   - Moved err declaration to the scope where it's used in
> >     start_stop_khugepaged
> >   - Made default case return 0 instead of err in start_stop_khugepaged
> >
> >  mm/khugepaged.c | 15 ++++++---------
> >  1 file changed, 6 insertions(+), 9 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 617bca76db49..7890bd3e2a9d 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -23,6 +23,7 @@
> >  #include <linux/ksm.h>
> >  #include <linux/pgalloc.h>
> >  #include <linux/backing-dev.h>
> > +#include <linux/cleanup.h>
> >
> >  #include <asm/tlb.h>
> >  #include "internal.h"
> > @@ -3111,18 +3112,17 @@ void set_recommended_min_free_kbytes(void)
> >
> >  int start_stop_khugepaged(void)
> >  {
> > -     int err =3D 0;
> > -
> > -     mutex_lock(&khugepaged_mutex);
> > +     guard(mutex)(&khugepaged_mutex);
> >       if (hugepage_enabled()) {
> >               if (!khugepaged_thread)
> >                       khugepaged_thread =3D kthread_run(khugepaged, NUL=
L,
> >                                                       "khugepaged");
> >               if (IS_ERR(khugepaged_thread)) {
> > +                     int err;
> >                       pr_err("khugepaged: kthread_run(khugepaged) faile=
d\n");
> >                       err =3D PTR_ERR(khugepaged_thread);
> >                       khugepaged_thread =3D NULL;
> > -                     goto fail;
> > +                     return err;
> >               }
>
> While at it, can we just do
>
> struct task_struct *new_thread =3D kthread_run...
>
> if (IS_ERR(new_thread)) {
>         pr_err("khugepaged: kthread_run(khugepaged) failed\n");
>         return PTR_ERR(new_thread);
> }
> khugepaged_thread =3D new_thread;
>
> ?
>
> Avoid the suboptimal err variable and temporarily assigning error values =
to the
> global variable.
>
> --
> Cheers,
>
> David

