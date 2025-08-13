Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AD69CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 16:22:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF77E9000AA; Wed, 13 Aug 2025 12:22:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACFAA900088; Wed, 13 Aug 2025 12:22:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E5679000AA; Wed, 13 Aug 2025 12:22:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 88358900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 12:22:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 35178B9791
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 16:22:02 +0000 (UTC)
X-FDA: 83772250884.22.7FA5FCF
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id 524CC4000C
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 16:22:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=EaKN0Rx3;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755102120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4QinmQQFXomCWAaJH8CKN0I0il8aAmJNtIteVH369jE=;
	b=T0y8E3SeKM/lpteNfkxkpABHiqc7Qqy/iHKYV+/v8LGjaBw2NBdKviZ51N61FhZeI4khJp
	GDA25N9pmXWa4gVf+m44EL1+GOneF3+mfe377I08iqF4ZiZF3j1OHdfh/h3hwQL828EI+S
	hZGID7YQ3LI3fw3CifDifOs8ATolxoU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=EaKN0Rx3;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755102120; a=rsa-sha256;
	cv=none;
	b=HYz8x7MYkY/+KRFeGVQd0nVLev7FiSrkiew75/+zVp++L7+YOFzXn75EeNezfoEUnKgVyM
	kc+gxsC4gFMe/WpR0Irw40pQvWVUgVva904lMfs8DO80vakNxnyxPAkLeVSK2IIp/mkZdM
	/lbLOAeKtD4TV9zA4qI7U0v5dnVpefg=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4b0bd871d9aso403141cf.0
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755102119; x=1755706919; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4QinmQQFXomCWAaJH8CKN0I0il8aAmJNtIteVH369jE=;
        b=EaKN0Rx3MYlcAObgtqewdMjaxtNvR8UekFB9Qa7U6JVEaGNSggETnaJb2evvxqQwO4
         6BYLdbapitBlcz3nxNeF9mjM6OckK9hhDFWi2umcBR7GO0ntEFQnjtevVOdTPBQYvYU0
         zjqxQ4apjPu3qQuolX5GCFSikmBk8xWFPu+uSWB/8YvH6NeBhA3VTZMzQgAGXIcFFOwS
         /tPRKrik97GyBmPFjqYRpO8uokztzY/cPnyclFGO86SMTmUQZEBb6HNbWHuUDBoEVBOb
         3hv1WKXkz7X/c1M223iRF2B7TS8+S2sYZRWSoxr85tKiUmXYxtdMDWPGbmHjjtZYq50y
         iNjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755102119; x=1755706919;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4QinmQQFXomCWAaJH8CKN0I0il8aAmJNtIteVH369jE=;
        b=OGkIf+3O81c2MaHh9IbloRxxjtU4VjV4bDlUN4B9UgYyyUZRuVLWIoAxJwu1xPlS/o
         /ths+YbCY1MsfPhSBph/YTS2Yfr5vGKHzfN1jczMDpEqKOYXA9RJWoPdK3xmVIpwrPOr
         wGwY4eOVjqG1DqYG48/q2OXBh3qfcWdUdzkSYkiVrQb3RAhak8sU0Zgsi8nPqSCd5QDF
         XYi0G7asGLE+jjRLGaDrK3xKZVWQXehNjJuaXvIpmWaI9aCdlwGi1hecBB8bYWA55LrR
         G53roLvwXwXzxsqtYaY5hWNamgPv2ctt5pogEi9QE5toZC6VrXEw9UcFsZ5iHaR95g32
         iKiQ==
X-Forwarded-Encrypted: i=1; AJvYcCVqtMgBb3GP+lnfBKURY2+Tcb4cbXcrYDINQNV9e4+s3l/q+x7IRZt41GqANbnqLV70XzO5+6B7ow==@kvack.org
X-Gm-Message-State: AOJu0YwgnpdrxK1Azlgi2Z7W7+jh/poRZcKfJqtqVUFG4fNGP/k0gFJ/
	Ta6bDysaTTq4HLpftFSlRkws9udtQMiq+hFg0NsrPw0sSDM7UoDqwL6vud1Sp4mZHbHXvLWYMi4
	/rVKriJY843g+QhP65kISpf4Nk/fAzErYireFhwt1
X-Gm-Gg: ASbGncumAcyochXo7EykaINA2h3BJIR6YJupJfWaqOsQNGY5CzYeB+eeU0pDuVGUJ1m
	+nBMP06acd7JheK2d3lbKvWtJ3HcPr5wT++ovkuNGa2VVLDFzx53hmfRyNCnxa5ftGzaawNlcTr
	hLyUqr6lb2z66LeDVzEkLLecu5eEAYEtPFEht2K+k+c1dalhT6HffPyVluofK/lz0NKCJJiprpb
	S1+M5BxWFTaiknpCKywCQ8f+KgLgd53zcvkaBwSVQG6BjyK03S1TDB3
X-Google-Smtp-Source: AGHT+IGGAjAQlJAs/6fOMgvF3DcusMKTQOaQbjz9ZrFKQ1wo0Qm87n6yg3dhd+rsJGWsOVYpbpOk1wnlAHiH0dZ6fyQ=
X-Received: by 2002:ac8:7f92:0:b0:4b0:83a3:9bac with SMTP id
 d75a77b69052e-4b0fdbc7fc6mr3865131cf.17.1755102118775; Wed, 13 Aug 2025
 09:21:58 -0700 (PDT)
MIME-Version: 1.0
References: <20250808152850.2580887-1-surenb@google.com> <20250808152850.2580887-2-surenb@google.com>
 <7d3b4b0c-f905-4622-95a8-e4d076dc71d4@lucifer.local>
In-Reply-To: <7d3b4b0c-f905-4622-95a8-e4d076dc71d4@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 13 Aug 2025 16:21:47 +0000
X-Gm-Features: Ac12FXycH4KgQhHe2VKUKoPE6OrMOaMbLer1JM-gxVxQlhmfWUD7HLZEVfP2gtE
Message-ID: <CAJuCfpH+Mg7P--sP7LmhhUgGSU0AwmoJLYGyvft5fPC0Mz1P6w@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] selftests/proc: test PROCMAP_QUERY ioctl while vma
 is concurrently modified
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com, david@redhat.com, 
	vbabka@suse.cz, peterx@redhat.com, jannh@google.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, paulmck@kernel.org, shuah@kernel.org, adobriyan@gmail.com, 
	brauner@kernel.org, josef@toxicpanda.com, yebin10@huawei.com, 
	linux@weissschuh.net, willy@infradead.org, osalvador@suse.de, 
	andrii@kernel.org, ryan.roberts@arm.com, christophe.leroy@csgroup.eu, 
	tjmercier@google.com, kaleshsingh@google.com, aha310510@gmail.com, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ytdgi4o9f5j94dsfwoaczhyaph9355tt
X-Rspam-User: 
X-Rspamd-Queue-Id: 524CC4000C
X-Rspamd-Server: rspam05
X-HE-Tag: 1755102120-694069
X-HE-Meta: U2FsdGVkX19C0EzH2SHZx3MwU49o/O4e49PoxChb2p/AHr6NLXLB+KP/ePPWzj+u8Sa2XsSVTmMd+3j8xvqQDS7ADDMkY/ihYpLHfNW596WJYp3hGD7RZ5t4q3WM5slnWXqQ+HuHXmNlOPoAoph+/qaZ3eThJbEJMncEBGHOWxlheymgmWIRxfkevqPwD+vXG2t9hCiE0EKw+FRJdm27i8NDMm3MXiGT80odwi+G45JDzZcVDbeY8eZx4dWBJPtPzaScNCtJMYS2HcsmawjqThGLIwR/yNNKuQf9a6n43JOd3LN51bCXuUMwAyVedqdVtuP4OhImh8WfHUK2z0vBXEPi+GfB/IMJvveP1B2VUWXHkNFwEZ+lYiJiMlQu+lJLFyxvypIosrOCcublTqkyJANqjbilpAu/TdH13OFbzl61Bg191xYef3a0B2rQTVmuf5o6Yenb5+53MNaoamXE/RIvjn58gnXO6dstPDk9/SRRg61woKM6xzEkrO7yKY0blRbrSALHc1muUq0hsM8cY4nQ5t5BP6YqKWztP/Y/57LwQ0pze4w6DUeSIm9XxQ4HdzzVAG1Ld4rD0Rt5gVqijWxNsR/fadpSCCWjMc81ZgMeU5JDeTt/EWqTG4ZZEA+JrLRpee5q/sChaCvcFZ94swj9kxwnD+CqdvCjNoGD4w2MBIu5XA7GzZKBBADkLdRzuVYE72/ppEsG+XvcqIqamNUhowyh0c3MZ6xQjCufRCFb9kjRs8vhl0+rkw9+9xGLEKj+O5MkDocqro2BwKkGO/fQiXtLFKFiFHmuKeTChGI9yvTOLWQ2DXhJTCstzTHrPBuR8U0UXmf/5vJbeVK5uSpVjU0+a89jGzt3XRq8IZArCO0028Po/IxQ+BlLR1Hz9x8vdGXakZIw2QEb9LUIIMBbfIwLVwEykjGKxtuXcggAd0lgMkh85ilh8zP0s3banmrNjQpaYTfcv0fFZiN
 buXJbuyY
 FHNA72ub/0GNRyu48tZHMT2UfWP6gn3bIkSfJZkjJPGzRt1zjNfyWnVqkir5H9f/HYTD+nqgqWfte9FHqhGnE18T8sukKB7OUB2Uo+GWD0uRcoo4GOF90VoAdmIa6nBKSU+bGUfJ3IzJek3eEifyo4qWlRvpHoijqTLUCHx0j3h9GC3atmgBP5gJElbcbChZdLodm/btmpUVjMipq1ELleIfvD2NkdDaAWWJWcFCvfu02JfOJxUZLLLfWIBxPFyv56QPwlfZXMvGdLxU5R96jJiB26kyZRdw6VMcEtG35j+lHuY8DcJ3t42qUYA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 1:39=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Fri, Aug 08, 2025 at 08:28:47AM -0700, Suren Baghdasaryan wrote:
> > Extend /proc/pid/maps tearing tests to verify PROCMAP_QUERY ioctl opera=
tion
> > correctness while the vma is being concurrently modified.
> >
>
> General comment, but I really feel like this stuff is mm-specific. Yes it=
 uses
> proc, but it's using it to check for mm functionality.
>
> I mean I'd love for these to be in the mm self tests but I get obviously =
why
> they're in the proc ones...
>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > Tested-by: SeongJae Park <sj@kernel.org>
> > Acked-by: SeongJae Park <sj@kernel.org>
>
> The tests themselves look good, had a good look through. But I've given y=
ou
> some nice ASCII diagrams to sprinkle liberally around :)

Thanks for the commentary, Lorenzo, it is great! I think I'll post
them as a follow-up patch since they do not change the functionality
of the test.

>
> Anyway for tests themselves:
>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Thanks!

>
> > ---
> >  tools/testing/selftests/proc/proc-maps-race.c | 65 +++++++++++++++++++
> >  1 file changed, 65 insertions(+)
> >
> > diff --git a/tools/testing/selftests/proc/proc-maps-race.c b/tools/test=
ing/selftests/proc/proc-maps-race.c
> > index 94bba4553130..a546475db550 100644
> > --- a/tools/testing/selftests/proc/proc-maps-race.c
> > +++ b/tools/testing/selftests/proc/proc-maps-race.c
> > @@ -32,6 +32,8 @@
> >  #include <stdlib.h>
> >  #include <string.h>
> >  #include <unistd.h>
> > +#include <linux/fs.h>
> > +#include <sys/ioctl.h>
> >  #include <sys/mman.h>
> >  #include <sys/stat.h>
> >  #include <sys/types.h>
> > @@ -317,6 +319,25 @@ static bool capture_mod_pattern(FIXTURE_DATA(proc_=
maps_race) *self,
> >              strcmp(restored_first_line->text, self->first_line.text) =
=3D=3D 0;
> >  }
> >
> > +static bool query_addr_at(int maps_fd, void *addr,
> > +                       unsigned long *vma_start, unsigned long *vma_en=
d)
> > +{
> > +     struct procmap_query q;
> > +
> > +     memset(&q, 0, sizeof(q));
> > +     q.size =3D sizeof(q);
> > +     /* Find the VMA at the split address */
> > +     q.query_addr =3D (unsigned long long)addr;
> > +     q.query_flags =3D 0;
> > +     if (ioctl(maps_fd, PROCMAP_QUERY, &q))
> > +             return false;
> > +
> > +     *vma_start =3D q.vma_start;
> > +     *vma_end =3D q.vma_end;
> > +
> > +     return true;
> > +}
> > +
> >  static inline bool split_vma(FIXTURE_DATA(proc_maps_race) *self)
> >  {
> >       return mmap(self->mod_info->addr, self->page_size, self->mod_info=
->prot | PROT_EXEC,
> > @@ -559,6 +580,8 @@ TEST_F(proc_maps_race, test_maps_tearing_from_split=
)
> >       do {
> >               bool last_line_changed;
> >               bool first_line_changed;
> > +             unsigned long vma_start;
> > +             unsigned long vma_end;
> >
> >               ASSERT_TRUE(read_boundary_lines(self, &new_last_line, &ne=
w_first_line));
> >
> > @@ -595,6 +618,19 @@ TEST_F(proc_maps_race, test_maps_tearing_from_spli=
t)
> >               first_line_changed =3D strcmp(new_first_line.text, self->=
first_line.text) !=3D 0;
> >               ASSERT_EQ(last_line_changed, first_line_changed);
> >
> > +             /* Check if PROCMAP_QUERY ioclt() finds the right VMA */
>
> Typo ioclt -> ioctl.
>
> I think a little misleading, we're just testing whether we find a VMA at
> mod_info->addr + self->page_size.
>
>
> > +             ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr +=
 self->page_size,
> > +                                       &vma_start, &vma_end));
> > +             /*
> > +              * The vma at the split address can be either the same as
> > +              * original one (if read before the split) or the same as=
 the
> > +              * first line in the second page (if read after the split=
).
> > +              */
> > +             ASSERT_TRUE((vma_start =3D=3D self->last_line.start_addr =
&&
> > +                          vma_end =3D=3D self->last_line.end_addr) ||
> > +                         (vma_start =3D=3D split_first_line.start_addr=
 &&
> > +                          vma_end =3D=3D split_first_line.end_addr));
> > +
>
> So I'd make things clearer here with a comment like:
>
>         We are mmap()'ing a distinct VMA over the start of a 3 page
>         mapping, which will cause the first page to be unmapped, and we c=
an
>         observe two states:
>
>                 read
>                   |
>                   v
>         |---------|------------------|
>         |         |                  |
>         |    A    |         B        | or:
>         |         |                  |
>         |---------|------------------|
>
>                   |
>                   v
>         |----------------------------|
>         |                            |
>         |              A             |
>         |                            |
>         |----------------------------|
>
>         If we see entries in /proc/$pid/maps it'll be:
>
>         7fa86aa15000-7fa86aa16000 rw-p 00000000 00:00 0  (A)
>         7fa86aa16000-7fa86aa18000 rw-p 00000000 00:00 0  (B)
>
>         Or:
>
>         7fa86aa15000-7fa86aa18000 rw-p 00000000 00:00 0  (A)
>
>         So we assert that the reported range is equivalent to one of thes=
e.
>
> Obviously you can mix this in where you feel it makes sense.
>
> >               clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
> >               end_test_iteration(&end_ts, self->verbose);
> >       } while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
> > @@ -636,6 +672,9 @@ TEST_F(proc_maps_race, test_maps_tearing_from_resiz=
e)
> >       clock_gettime(CLOCK_MONOTONIC_COARSE, &start_ts);
> >       start_test_loop(&start_ts, self->verbose);
> >       do {
> > +             unsigned long vma_start;
> > +             unsigned long vma_end;
> > +
> >               ASSERT_TRUE(read_boundary_lines(self, &new_last_line, &ne=
w_first_line));
> >
> >               /* Check if we read vmas after shrinking it */
> > @@ -662,6 +701,16 @@ TEST_F(proc_maps_race, test_maps_tearing_from_resi=
ze)
> >                                       "Expand result invalid", self));
> >               }
> >
> > +             /* Check if PROCMAP_QUERY ioclt() finds the right VMA */
> > +             ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr, =
&vma_start, &vma_end));
>
> Same comments as above.
>
> > +             /*
> > +              * The vma should stay at the same address and have eithe=
r the
> > +              * original size of 3 pages or 1 page if read after shrin=
king.
> > +              */
> > +             ASSERT_TRUE(vma_start =3D=3D self->last_line.start_addr &=
&
> > +                         (vma_end - vma_start =3D=3D self->page_size *=
 3 ||
> > +                          vma_end - vma_start =3D=3D self->page_size))=
;
>
>
> So I'd make things clearer here with a comment like:
>
>         We are shrinking and expanding a VMA from 1 page to 3 pages:
>
>        read
>         |
>         v
>         |---------|
>         |         |
>         |    A    |
>         |         |
>         |---------|
>
>         |
>         v
>         |----------------------------|
>         |                            |
>         |              A             |
>         |                            |
>         |----------------------------|
>
>         If we see entries in /proc/$pid/maps it'll be:
>
>         7fa86aa15000-7fa86aa16000 rw-p 00000000 00:00 0  (A)
>
>         Or:
>
>         7fa86aa15000-7fa86aa18000 rw-p 00000000 00:00 0  (A)
>
>         So we assert that the reported range is equivalent to one of thes=
e.
>
>
> > +
> >               clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
> >               end_test_iteration(&end_ts, self->verbose);
> >       } while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
> > @@ -703,6 +752,9 @@ TEST_F(proc_maps_race, test_maps_tearing_from_remap=
)
> >       clock_gettime(CLOCK_MONOTONIC_COARSE, &start_ts);
> >       start_test_loop(&start_ts, self->verbose);
> >       do {
> > +             unsigned long vma_start;
> > +             unsigned long vma_end;
> > +
> >               ASSERT_TRUE(read_boundary_lines(self, &new_last_line, &ne=
w_first_line));
> >
> >               /* Check if we read vmas after remapping it */
> > @@ -729,6 +781,19 @@ TEST_F(proc_maps_race, test_maps_tearing_from_rema=
p)
> >                                       "Remap restore result invalid", s=
elf));
> >               }
> >
> > +             /* Check if PROCMAP_QUERY ioclt() finds the right VMA */
> > +             ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr +=
 self->page_size,
> > +                                       &vma_start, &vma_end));
>
> Same comments as above.
>
>
> > +             /*
> > +              * The vma should either stay at the same address and hav=
e the
> > +              * original size of 3 pages or we should find the remappe=
d vma
> > +              * at the remap destination address with size of 1 page.
> > +              */
> > +             ASSERT_TRUE((vma_start =3D=3D self->last_line.start_addr =
&&
> > +                          vma_end - vma_start =3D=3D self->page_size *=
 3) ||
> > +                         (vma_start =3D=3D self->last_line.start_addr =
+ self->page_size &&
> > +                          vma_end - vma_start =3D=3D self->page_size))=
;
> > +
>
> Again be good to have more explanation here, similar comments to abov.
>
>         We are mremap()'ing the last page of the next VMA (B) into the
>         midle of the current one (A) (using MREMAP_DONTUNMAP leaving the
>         last page of the original VMA zapped but in place:
>
>       read
>         |
>         v             R/W                            R/O
>         |----------------------------| |------------------.---------|
>         |                            | |                  .         |
>         |              A             | |              B   .         |
>         |                            | |                  .         |
>         |----------------------------| |------------------.---------|
>
>         This will unmap the middle of A, splitting it in two, before
>         placing a copy of B there (Which has different prot bits than A):
>
>         |
>         v   R/W       R/O      R/W                   R/O
>         |---------|---------|--------| |----------------------------|
>         |         |         |        | |                            |
>         |    A1   |    B2   |   A2   | |              B             |
>         |         |         |        | |                            |
>         |---------|---------|--------| |----------------------------|
>
>         But then we 'patch' B2 back to R/W prot bits, causing B2 to get
>         merged:
>
>         |
>         v             R/W                            R/O
>         |----------------------------| |----------------------------|
>         |                            | |                            |
>         |              A             | |              B             |
>         |                            | |                            |
>         |----------------------------| |----------------------------|
>
>         If we see entries in /proc/$pid/maps it'll be:
>
>         7fa86aa15000-7fa86aa18000 rw-p 00000000 00:00 0  (A)
>         7fa86aa19000-7fa86aa20000 r--p 00000000 00:00 0  (B)
>
>         Or:
>
>         7fa86aa15000-7fa86aa16000 rw-p 00000000 00:00 0  (A1)
>         7fa86aa16000-7fa86aa17000 r--p 00000000 00:00 0  (B2)
>         7fa86aa17000-7fa86aa18000 rw-p 00000000 00:00 0  (A3)
>         7fa86aa19000-7fa86aa20000 r--p 00000000 00:00 0  (B)
>
>         We are always examining the first line, so we simply assert that
>         this remains in place and we observe 1 page or 3 pages.
>
> >               clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
> >               end_test_iteration(&end_ts, self->verbose);
> >       } while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
> > --
> > 2.50.1.703.g449372360f-goog
> >

