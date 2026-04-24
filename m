Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A723FED3FC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:59:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C9586B00A0; Fri, 24 Apr 2026 15:59:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09E246B00A1; Fri, 24 Apr 2026 15:59:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF6AE6B00A2; Fri, 24 Apr 2026 15:59:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DDDDB6B00A0
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:59:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 78AE21202E0
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:59:50 +0000 (UTC)
X-FDA: 84694514940.05.6EB76C2
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7C4FE20011
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:59:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Qxu2FhDl;
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777060788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5f8KT4elycAtFJ0kXecV1QCZWUTmhOqicbo482jUwJc=;
	b=gA252oK8D+CdDg5enktiGjZRi44sbDTMQpuxDHt+42HbVPxff7cFV6SVgJ8uBHqGDZFxSr
	rmOvEFsu9QnDPKRT46+7khnOt8hrr/y5vO2hiCoohKYs26LBYSgsbKmuLTZzwoHeXU4L6r
	GbB4/pbGUYzeMsKUv6fB8wFyEO5OBa4=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Qxu2FhDl;
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777060788; a=rsa-sha256;
	cv=pass;
	b=XiEx9kIrJuK8wniKbj+RS+TJjPP7YoadP/mTyzknpSPnoKGaPDz5t3ZJu0JtfHa9Z0VRyS
	+OYGXYqQNp5llwo/c9AWKfnEyvW2pJWUVF4JikkOKbyrZKp32FkZYsvylEMBu1IvqIN8Rk
	yZIaFr0cZJuVmBMOdZItVzrWlzh6ZTU=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-50d836552daso4694611cf.0
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:59:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777060787; cv=none;
        d=google.com; s=arc-20240605;
        b=MWC9Zb9hXZDmrCBqVWwB0Ql4RdjvY81z79sWu/hLsEj8oKJb68gsgABWT2mD7mcGMn
         aI3NZAE2Ez+ViBwrKkZDcaHNo3jMVLet8UXNs+k22+KPEFzXpj4rwULj/Z6z25SfihJ+
         AL4yAU4lewFoUExQBp3PhE0zDqO3m4EPbCxCnt4NZ4Fn52L9zsrzZvfVN07ltjXwsna7
         U4uECE9om/kjqz8BDzt+Uj/6p3WCaruwEu/P1nDOcyZVJW8GKL7z2sAk5xhp40cWnUQ0
         +BgCxTrTFKMEB/X5TihCZ2cBlMgdqdL2CdeFIGY/96g2nOZxYud2PjnH6kk2GsFd4ErL
         Ulig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5f8KT4elycAtFJ0kXecV1QCZWUTmhOqicbo482jUwJc=;
        fh=LlHMgw0S0sbYs/yyg+g8DFvK1HMbCgUoGvfvc5tp7+U=;
        b=dfTvSp30vQMZl1SZ1nnrYyxp5Rr+yjE/JWmMW4EbStyAQ96mbMzveXecwPTauejfQW
         MOM6tBHojmHp30Jf+i+iTrnmPc03OqTdWwflqgNAfYNtf72VMKoOY2WSop1JVQRuOsJ4
         VVoYT4+SqmiIyPGdipSjE3o6JS3S2CGdh0nFtza9SZ+M5usPqfZUg3+9DcwUqzMF4vZl
         HCEjq6X8adaI6YQClUqNJOf31WQY/n/GeFYFAf2oJdfoCIkKv+2kGE3yaS7BbNWVkZvk
         wcgn+ebpS0vPUCn6M+lPm8mWjadbB7LkWcYFykDNnODBW/sMYcy9CC25+alY4644eUHS
         kT/A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777060787; x=1777665587; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5f8KT4elycAtFJ0kXecV1QCZWUTmhOqicbo482jUwJc=;
        b=Qxu2FhDlemK4oB4L4aeZrrJWfTPnjJNmSfuGuBy5dWi7kVt9Fb98Z3CGCAUlGzIi+R
         D1XKl1RLG2GGLtkcdLjH8lCWYM/xzytFNh4i5Hjy7YCf/DP95ImNVPPyAjWgSzcbqsGg
         QK3GjUQYuDmYSbZNuQ5bEv/qLkp3tZX0J1dx8NzJyq7P0gjbiT3akp6kvrzfbraYuGCN
         3YBnCk1Q4iuiVTRrNjnl2/epUMUxrtJw3lZQ0hzQFJ3+AikviFxrBwvteOiMMUpF+24y
         LlaQ/SfLSEs9H3Ydn4GQFo2tuwPckZpKBTjjwV/ZGR0buJwE54QEimi3ka1UFtw4KVEG
         zC8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777060787; x=1777665587;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5f8KT4elycAtFJ0kXecV1QCZWUTmhOqicbo482jUwJc=;
        b=NdjSjUkQOe59azQfq7mTWiXV8hcXhU96CK9GiNmzCmM5vE2UJMJeOI3iThv3EE/SuC
         MU1wUhQsO4FtWqWoVVvWG4HcREk+B6do7/3gZYKwVjWlVgXFBkCe76LNH6gR57mY4+uY
         Xhvu/+K5+9vr8TEz0t9rvxUvRjonWUl24fGAdsxcdDthTc88jkdlY7H1g7je+V6NUROL
         YeAKE9Ss47yz5cxVlWR6Ru8D34cWVu5pFa0rEj6kDNVeRJ9mo28ZCTTaI9gGWRAy6mO2
         QT7zHXa7tv0XGXoSyH+pxmBxfz84GzlIPlwHA+pfEenYaxKOr9OMxRRjZGTLhFaWfQu8
         335Q==
X-Forwarded-Encrypted: i=1; AFNElJ86WxK0k6WX2TIITQkWX+TtZz+LNB/wqYHkORrRYxWEgxzBihA/yGdxJPewHa63EDaRzLf8S7C0ng==@kvack.org
X-Gm-Message-State: AOJu0YwfEcobLPV9g0SJdD7jCFjUh98vNn8Yct2JoNU39I8L/oJbZ9EK
	tuncfePRxRf6MFtSFXryCtdPdhz1NcpOXPYIHGxMRKpWwZOM49Vr/h6FOnRsOVfMVxHzDkVwFb1
	w1lA8oLpEg/T9AoBaX+aA8+NsykeTzfMJT8dmzIDX
X-Gm-Gg: AeBDieuLeWRHVaaDWxx3kRVzq7S99tf7JtoRTXXf3v20Bw7pAQEIYK70pR2iZO4Hbc5
	utVZcq96yr8T25rDEJBG2vuUgGbxKs7FyYJY9AJ5hMqEmMhOx5WWKkRa3NRHxQDDyg5X7c/n6GS
	ayj2il+BqO2yxPV/YjL11RspLx6je7DuDQ2Qkp/RjJ2uYZePQNX8yClqx4euGwzUDxFd3yPGzVa
	ayGJ+JtMwYov38nl876plmQQwZZJmCQRH0E+SR7QH7fa1ivDVkniG3IfDNy+w76EdHClYiQcy7e
	QD/fTlGLM6SGRcao+eaYudH5Gbc=
X-Received: by 2002:a05:622a:8d0c:b0:50b:8d3c:5bd7 with SMTP id
 d75a77b69052e-50e441a9a18mr45045201cf.9.1777060787000; Fri, 24 Apr 2026
 12:59:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260424070234.190145-1-surenb@google.com> <20260424070234.190145-4-surenb@google.com>
 <qxxhshfoe5tph4z324fzl74r532bxdrdvll2xvhaeken6bsdwb@q2wk2nbvxr3p>
In-Reply-To: <qxxhshfoe5tph4z324fzl74r532bxdrdvll2xvhaeken6bsdwb@q2wk2nbvxr3p>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 24 Apr 2026 12:59:35 -0700
X-Gm-Features: AQROBzD5xA_3c0_hTUm6u9T-bbzWrkTL-rrbMD7rk0vNpvDqT-w5J6qxPpAkp5U
Message-ID: <CAJuCfpE5C9UpkrAEvm6amw7=JYRoXeiSJuPFJnb+LRrVwn4ntA@mail.gmail.com>
Subject: Re: [PATCH 3/3] selftests/proc: add /proc/pid/smaps tearing tests
To: "Liam R. Howlett" <liam@infradead.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, shuah@kernel.org, hsukrut3@gmail.com, 
	richard.weiyang@gmail.com, reddybalavignesh9979@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7C4FE20011
X-Stat-Signature: umrk57j5o5386nuqakux5a6xdpm88xwf
X-HE-Tag: 1777060788-371952
X-HE-Meta: U2FsdGVkX18Nwjz/a5IRXoG1IegARtWGJxcxpntCNZOz5t2rL0HRPQ30l0JFg6gG4eI+If0KSZcDAb6QI6lmuuH74yzUv85EcqnqylPcAYlR0kh4W/lW+Mtki9oJqJEdmZho6Zwss3yv6OymYYyXjt1PfhncUjcP8MnPEyXiBmA5Eg8+LcvpLQ4a9hRD4Jf3keKmmiRtxEcgIJe6d4jraeOfsA9DkDqI09hIphYkR4YW4sNQHEuOPzzCtU3g2EK1VnWBux3uEfYNX67EVQ91/0TG1pBtNB4Bf4NY1snfgaV/CfpBHySFliWzkvwIw9RwY4z8BePT7jLOnJmPvncNYiVEzNhujExtgWTZxZFM3B4NlBPNme9biAs6cyQhOZBdIJtQG4KsULkrZqu5mHTtpy/UEAZzs5xo51NCUGU+slkODGO7+SajAueVrWOFDuah+VMvYSbDV+J4z45yzy8uVMbXz0Y5UEvn2+WGUJAOOUvgpflSmcNQdmnvNwHhbX0wzKLBt1xejIM3v5CgUihrhHsOge1yr7evdIrouZBeByb9tSuCC/2PDdUQVQT/88AlPQoavYEqhCXeNo6uHcaKkiFO4Xw1NQEH1wqdK6/LyD2rTzXWJwGhFD1kNGaUiTASiZnrmIDTgW0gooStcQ+f6iBvTeP+astIVJu4MtG+gUDnylMHayHzx3rY/agtjkXUXemRI6c61P6/b3cFzhUoioG2vwdMB6o7tT5ChZdG3cdMnSP9Y+qYU+PVuvFItEUpo6pVHM26yBVsIUk3rZwQxKDU1yhzHQp/LJSHutV+VkbhL8UU8+zx7c3xvtDZf8X+aJ+qBTWE50NQo/0hYhZC6sAsGDLEdFtgVV9PGMmbVwT9KvnDHY+B/zWt7EqPiIVtmmiK/BOON1O/ihJml1mFXJMZv2capFUZ38wa8wLSQJnI1W5OKSXNNDT7b9/XxBRcHrsJSvzZBieTghM6sW6
 qb5t8jug
 qkgmC6roGax9Kgc55G248fq7vpnzA3jMowmzmDut/gia5Q4cYtNPzpCheoRj9qnAzra20b6d8WJOOFBHHeFoQzdVTyzwdXg8BUUeaqIqNdWHwp7ZcomkVigH9egcPk3/n5GtbyN8/Oqjf6HYouokDydHcbGKNl7NKyfTj65YeStmpbpIaIrtDhUXCuZF6Oj8NK9U05Nl7rCw18mLxuPN839vnx07G3P8A+O96k3g4e+MUwExsGj1MXlKEWB3bxoHOwjGmS2hXDEyZ1WnLfW6M+WLIojwmaZxciZyROX+HT56UHv9UKc2bEtEfDJP6fHBYTsmPopL+d7txzphtg70YHJOUMkU1wJjZSAWKjYtapJ7by6Ry+iNRTIAxMcWpNIYnQ5MMqboG5Dib79c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 11:23=E2=80=AFAM Liam R. Howlett <liam@infradead.or=
g> wrote:
>
> On 26/04/24 12:02AM, Suren Baghdasaryan wrote:
> > Add MAPS_FILE environment variable to select whether the tests to be ru=
n
> > for /proc/pid/maps or /proc/pid/smaps. Add support for testing smaps fi=
le
> > by reusing the same logic as with maps file but skipping all the data
> > except for the VMA addresses, which are the only part relevant for the
> > tearing tests. Skip PROCMAP_QUERY parts of the tests because smaps does
> > not implement that ioctl.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>
> One comment question, otherwise..
>
> Reviewed-by: Liam R. Howlett <liam@infradead.org>
>
> > ---
> >  tools/testing/selftests/proc/proc-maps-race.c | 176 +++++++++++++-----
> >  1 file changed, 132 insertions(+), 44 deletions(-)
> >
> > diff --git a/tools/testing/selftests/proc/proc-maps-race.c b/tools/test=
ing/selftests/proc/proc-maps-race.c
> > index c5031b0593b7..b677bc23cab9 100644
> > --- a/tools/testing/selftests/proc/proc-maps-race.c
> > +++ b/tools/testing/selftests/proc/proc-maps-race.c
> > @@ -17,8 +17,8 @@
> >   */
> >  /*
> >   * Fork a child that concurrently modifies address space while the mai=
n
> > - * process is reading /proc/$PID/maps and verifying the results. Addre=
ss
> > - * space modifications include:
> > + * process is reading /proc/$PID/maps and /proc/$PID/smaps, verifying =
the
>                                          ^^^ and? Should this be or?  It
>                                          doesn't match your commit
>                                          message.

Quite right. I'll fix it. Need to post a new version anyway since
Sashiko found a couple of issues.

>
>
> > + * results. Address space modifications include:
> >   *     VMA splitting and merging
> >   *
> >   */
> > @@ -73,6 +73,11 @@ enum test_state {
> >       TEST_DONE,
> >  };
> >
> > +enum maps_file {
> > +     MAPS,
> > +     SMAPS,
> > +};
> > +
> >  struct vma_modifier_info;
> >
> >  FIXTURE(proc_maps_race)
> > @@ -83,6 +88,7 @@ FIXTURE(proc_maps_race)
> >       struct line_content last_line;
> >       struct line_content first_line;
> >       unsigned long duration_sec;
> > +     enum maps_file maps_file;
> >       int shared_mem_size;
> >       int skip_pages;
> >       int page_size;
> > @@ -199,6 +205,57 @@ static void copy_last_line(struct page_content *pa=
ge, char *last_line)
> >       last_line[end - pos] =3D '\0';
> >  }
> >
> > +static bool copy_first_entry(struct page_content *page, char *first_li=
ne)
> > +{
> > +     const char *start_pos =3D page->data;
> > +
> > +     while (start_pos < page->data + page->size) {
> > +             unsigned long start_addr;
> > +             unsigned long end_addr;
> > +             char *end_pos;
> > +
> > +             end_pos =3D strchr(start_pos, '\n');
> > +             if (!end_pos)
> > +                     break;
> > +
> > +             if (sscanf(start_pos, "%lx-%lx", &start_addr, &end_addr) =
=3D=3D 2) {
> > +                     strncpy(first_line, start_pos, end_pos - start_po=
s);
> > +                     first_line[end_pos - start_pos] =3D '\0';
> > +                     return true;
> > +             }
> > +
> > +             start_pos =3D end_pos + 1;
> > +     }
> > +
> > +     return false;
> > +}
> > +
> > +static bool copy_last_entry(struct page_content *page, char *last_line=
)
> > +{
> > +     const char *end_pos =3D page->data + page->size - 1;
> > +     const char *start_pos;
> > +
> > +     while (end_pos > page->data) {
> > +             unsigned long start_addr;
> > +             unsigned long end_addr;
> > +
> > +             /* skip last newline */
> > +             start_pos =3D end_pos - 1;
> > +             /* search previous newline */
> > +             while (start_pos > page->data && start_pos[-1] !=3D '\n')
> > +                     start_pos--;
> > +             if (sscanf(start_pos, "%lx-%lx", &start_addr, &end_addr) =
=3D=3D 2) {
> > +                     strncpy(last_line, start_pos, end_pos - start_pos=
);
> > +                     last_line[end_pos - start_pos] =3D '\0';
> > +                     return true;
> > +             }
> > +
> > +             end_pos =3D start_pos - 1;
> > +     }
> > +
> > +     return false;
> > +}
> > +
> >  /* Read the last line of the first page and the first line of the seco=
nd page */
> >  static bool read_boundary_lines(FIXTURE_DATA(proc_maps_race) *self,
> >                               struct line_content *last_line,
> > @@ -207,8 +264,16 @@ static bool read_boundary_lines(FIXTURE_DATA(proc_=
maps_race) *self,
> >       if (!read_two_pages(self))
> >               return false;
> >
> > -     copy_last_line(&self->page1, last_line->text);
> > -     copy_first_line(&self->page2, first_line->text);
> > +     if (self->maps_file =3D=3D MAPS) {
> > +             copy_last_line(&self->page1, last_line->text);
> > +             copy_first_line(&self->page2, first_line->text);
> > +     } else if (self->maps_file =3D=3D SMAPS) {
> > +             if (!copy_last_entry(&self->page1, last_line->text) ||
> > +                 !copy_first_entry(&self->page2, first_line->text))
> > +                     return false;
> > +     } else {
> > +             return false;
> > +     }
> >
> >       return sscanf(last_line->text, "%lx-%lx", &last_line->start_addr,
> >                     &last_line->end_addr) =3D=3D 2 &&
> > @@ -464,6 +529,7 @@ FIXTURE_SETUP(proc_maps_race)
> >  {
> >       const char *verbose =3D getenv("VERBOSE");
> >       const char *duration =3D getenv("DURATION");
> > +     const char *maps_file =3D getenv("MAPS_FILE");
> >       struct vma_modifier_info *mod_info;
> >       pthread_mutexattr_t mutex_attr;
> >       pthread_condattr_t cond_attr;
> > @@ -474,6 +540,18 @@ FIXTURE_SETUP(proc_maps_race)
> >
> >       self->page_size =3D (unsigned long)sysconf(_SC_PAGESIZE);
> >       self->verbose =3D verbose && !strncmp(verbose, "1", 1);
> > +     if (maps_file) {
> > +             if (!strcmp(maps_file, "maps")) {
> > +                     self->maps_file =3D MAPS;
> > +             } else if (!strcmp(maps_file, "smaps")) {
> > +                     self->maps_file =3D SMAPS;
> > +             } else {
> > +                     ksft_print_msg("Unknown maps file %s\n", maps_fil=
e);
> > +                     ksft_exit_fail();
> > +             }
> > +     } else {
> > +             self->maps_file =3D MAPS;
> > +     }
> >       duration_sec =3D duration ? atol(duration) : 0;
> >       self->duration_sec =3D duration_sec ? duration_sec : 5UL;
> >
> > @@ -540,7 +618,16 @@ FIXTURE_SETUP(proc_maps_race)
> >               exit(0);
> >       }
> >
> > -     sprintf(fname, "/proc/%d/maps", self->pid);
> > +     switch (self->maps_file) {
> > +     case MAPS:
> > +             sprintf(fname, "/proc/%d/maps", self->pid);
> > +             break;
> > +     case SMAPS:
> > +             sprintf(fname, "/proc/%d/smaps", self->pid);
> > +             break;
> > +     default:
> > +             ksft_exit_fail();
> > +     }
> >       self->maps_fd =3D open(fname, O_RDONLY);
> >       ASSERT_NE(self->maps_fd, -1);
> >
> > @@ -675,20 +762,20 @@ TEST_F(proc_maps_race, test_maps_tearing_from_spl=
it)
> >               last_line_changed =3D strcmp(new_last_line.text, self->la=
st_line.text) !=3D 0;
> >               first_line_changed =3D strcmp(new_first_line.text, self->=
first_line.text) !=3D 0;
> >               ASSERT_EQ(last_line_changed, first_line_changed);
> > -
> > -             /* Check if PROCMAP_QUERY ioclt() finds the right VMA */
> > -             ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr +=
 self->page_size,
> > -                                       &vma_start, &vma_end));
> > -             /*
> > -              * The vma at the split address can be either the same as
> > -              * original one (if read before the split) or the same as=
 the
> > -              * first line in the second page (if read after the split=
).
> > -              */
> > -             ASSERT_TRUE((vma_start =3D=3D self->last_line.start_addr =
&&
> > -                          vma_end =3D=3D self->last_line.end_addr) ||
> > -                         (vma_start =3D=3D split_first_line.start_addr=
 &&
> > -                          vma_end =3D=3D split_first_line.end_addr));
> > -
> > +             if (self->maps_file =3D=3D MAPS) {
> > +                     /* Check if PROCMAP_QUERY ioclt() finds the right=
 VMA */
> > +                     ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info=
->addr + self->page_size,
> > +                                               &vma_start, &vma_end));
> > +                     /*
> > +                      * The vma at the split address can be either the=
 same as
> > +                      * original one (if read before the split) or the=
 same as the
> > +                      * first line in the second page (if read after t=
he split).
> > +                      */
> > +                     ASSERT_TRUE((vma_start =3D=3D self->last_line.sta=
rt_addr &&
> > +                                  vma_end =3D=3D self->last_line.end_a=
ddr) ||
> > +                                 (vma_start =3D=3D split_first_line.st=
art_addr &&
> > +                                  vma_end =3D=3D split_first_line.end_=
addr));
> > +             }
> >               clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
> >               end_test_iteration(&end_ts, self->verbose);
> >       } while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
> > @@ -758,17 +845,18 @@ TEST_F(proc_maps_race, test_maps_tearing_from_res=
ize)
> >                                       strcmp(new_first_line.text, resto=
red_first_line.text),
> >                                       "Expand result invalid", self));
> >               }
> > -
> > -             /* Check if PROCMAP_QUERY ioclt() finds the right VMA */
> > -             ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr, =
&vma_start, &vma_end));
> > -             /*
> > -              * The vma should stay at the same address and have eithe=
r the
> > -              * original size of 3 pages or 1 page if read after shrin=
king.
> > -              */
> > -             ASSERT_TRUE(vma_start =3D=3D self->last_line.start_addr &=
&
> > -                         (vma_end - vma_start =3D=3D self->page_size *=
 3 ||
> > -                          vma_end - vma_start =3D=3D self->page_size))=
;
> > -
> > +             if (self->maps_file =3D=3D MAPS) {
> > +                     /* Check if PROCMAP_QUERY ioclt() finds the right=
 VMA */
> > +                     ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info=
->addr,
> > +                                               &vma_start, &vma_end));
> > +                     /*
> > +                      * The vma should stay at the same address and ha=
ve either the
> > +                      * original size of 3 pages or 1 page if read aft=
er shrinking.
> > +                      */
> > +                     ASSERT_TRUE(vma_start =3D=3D self->last_line.star=
t_addr &&
> > +                                 (vma_end - vma_start =3D=3D self->pag=
e_size * 3 ||
> > +                                  vma_end - vma_start =3D=3D self->pag=
e_size));
> > +             }
> >               clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
> >               end_test_iteration(&end_ts, self->verbose);
> >       } while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
> > @@ -838,20 +926,20 @@ TEST_F(proc_maps_race, test_maps_tearing_from_rem=
ap)
> >                                       strcmp(new_first_line.text, resto=
red_first_line.text),
> >                                       "Remap restore result invalid", s=
elf));
> >               }
> > -
> > -             /* Check if PROCMAP_QUERY ioclt() finds the right VMA */
> > -             ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr +=
 self->page_size,
> > -                                       &vma_start, &vma_end));
> > -             /*
> > -              * The vma should either stay at the same address and hav=
e the
> > -              * original size of 3 pages or we should find the remappe=
d vma
> > -              * at the remap destination address with size of 1 page.
> > -              */
> > -             ASSERT_TRUE((vma_start =3D=3D self->last_line.start_addr =
&&
> > -                          vma_end - vma_start =3D=3D self->page_size *=
 3) ||
> > -                         (vma_start =3D=3D self->last_line.start_addr =
+ self->page_size &&
> > -                          vma_end - vma_start =3D=3D self->page_size))=
;
> > -
> > +             if (self->maps_file =3D=3D MAPS) {
> > +                     /* Check if PROCMAP_QUERY ioclt() finds the right=
 VMA */
> > +                     ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info=
->addr + self->page_size,
> > +                                               &vma_start, &vma_end));
> > +                     /*
> > +                      * The vma should either stay at the same address=
 and have the
> > +                      * original size of 3 pages or we should find the=
 remapped vma
> > +                      * at the remap destination address with size of =
1 page.
> > +                      */
> > +                     ASSERT_TRUE((vma_start =3D=3D self->last_line.sta=
rt_addr &&
> > +                                  vma_end - vma_start =3D=3D self->pag=
e_size * 3) ||
> > +                                 (vma_start =3D=3D self->last_line.sta=
rt_addr + self->page_size &&
> > +                                  vma_end - vma_start =3D=3D self->pag=
e_size));
> > +             }
> >               clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
> >               end_test_iteration(&end_ts, self->verbose);
> >       } while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
> > --
> > 2.54.0.545.g6539524ca2-goog
> >

