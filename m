Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8FCBFF885A
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 23:48:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07C276B0088; Sat, 25 Apr 2026 19:48:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02C966B008A; Sat, 25 Apr 2026 19:48:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5E246B008C; Sat, 25 Apr 2026 19:48:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D04CC6B0088
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 19:48:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 68E5CA0444
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 23:48:55 +0000 (UTC)
X-FDA: 84698721030.04.B662EB6
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6FA5380006
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 23:48:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=V4NI6EMm;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777160933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bZydx8l84GIjMRw3J0wCqIG05nmQhWK3VDWewjGvVJo=;
	b=VjIjxK7tlUmDORI1yY4vyLKWEekRvK+xT9EE7YJ1pdXo+MnfT5d/Lz7CbqGbKqwdVSYcgg
	6ehMlRg+qDm3x8ylPlL7mf8L4HRuDoVmnfY/qL7X4Jqy3OVby3YUD5lsDJrGcpUIfV5GRZ
	HB+eGu3lZcXEhpgLKqKBR0EYqCpQ9SQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777160933; a=rsa-sha256;
	cv=pass;
	b=hd4tKeFL2p58MzDdtazMIycJvOIlrhFdUFChTdWziLb1qvKwf0kWG3MEdQk76OCBkhv9kV
	XSIEyTOtcSxvEtGtDS9vDRSyOmZxayk5vSMGkPScVdg0e7EWVf0yp/RqjOAFM65eDyjLmq
	ef3aP+7IijDBLAW/QTbMFGMGOttxa/4=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=V4NI6EMm;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-50d6b393d60so5218811cf.0
        for <linux-mm@kvack.org>; Sat, 25 Apr 2026 16:48:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777160932; cv=none;
        d=google.com; s=arc-20240605;
        b=h5DXV2FiTDKEhQ3rJWdI5IhISEzO3//hX5ZkwgwuCzieQfwXvhnMzrsNxMGr9XqMWV
         yWP7SCyRlfNqJ5KqnTaEoh+jKfSsN9ofcwrHnEa2wbil6YVIGgvLD20ZdGUY8MtS6RN4
         pOXlkkjPkR5sjgOx6G9Mj1xkP8lrMQv7vvvQB1v2oQ9dVgQty8qMXN0uhmNr39Ux4SoB
         jM1EBT6OUJOY+NN3pyty1QUt/pO5MXGgSi/+bNEcM6lVzwBzHXuUcTjy+KGknWMde/D2
         MwVN0CfLTvjiquvks5D7DIRyX0aeGPjkQjSWB+9IcUy5+nIycUrz0QnUdU5ysWjHS+0/
         Y7/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bZydx8l84GIjMRw3J0wCqIG05nmQhWK3VDWewjGvVJo=;
        fh=61s0zj6I3udG9uZAEvEeYAOTfGcCbPCUAcrlssnxKFw=;
        b=TjrNU1qmS9+o4TzKHcr9ZP4E1KatFOje2JHISLlSQ9CSWZ+A4zu35eW5klBg/uX9vr
         uEud9Mzx6ZHhcZsc6nAyMXg7MbXICQ8Ws4xf2DgbTpBt4a/VLaXpmeCulSNLiUhA1Kpa
         KD5tiHaaqt8A+QZcJLuedq3MzhGvwKZarLM/dl4bMkCKk6fTsAvV3JR4Lztzks4hobkD
         dkPVCpEh5O6rJvjJz0TCXdla67f0qQFngFTqCj79qyS1bfTeSTDiyODZVwh9YSh/tPFN
         W0ZKVyMY95Zj8fgxBWNk9LGfC90q1B5EksTPObcDpyauW3G+avQp/J8nQF9xbh3PespE
         jSsA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777160932; x=1777765732; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bZydx8l84GIjMRw3J0wCqIG05nmQhWK3VDWewjGvVJo=;
        b=V4NI6EMmOtqmP/M0htHcmv9ApYA98LUtL8sX0BEjqX97YNJacrOqKYoYG+wBWh2HVP
         CSA2laf1xagitofsiC4Ldj6DPHBTVDfFdjqr4AbxioEI10GrsglUYKYeUAnGUwB2DxDK
         d0MgmWhiQI/9c+39a3wYaNtaIlb+5KOkGjq9UBAMxX20G3RPxipsaojeS7S+ytv0f/R9
         OLtdm7DSWlSrRc2KvY39VOyFKbZA+/4VK0vkyTVutaQFlQ5wtnzJrGIWzenT+eQMzC/6
         SEAGi/FXLcu+W0awkD1POeRRONI57YJ4GTICG4itC9YotAONiD/J+6lBetvZ7nWMdESC
         RsKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777160932; x=1777765732;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bZydx8l84GIjMRw3J0wCqIG05nmQhWK3VDWewjGvVJo=;
        b=mEn7NaCK56HFAhJGpbZbxO9tCjJ0d72yRjvuAIGH7ZmguuOW5RFvFVW9qkrOSa6ZWS
         kZ0DuE8D0oZg5NrPB4okNuYJmyRgDGc5KFb93Q1sVD6P/uD492u6kbwvFgPjIucQFBqX
         5MTt2m66lE+GypFmKUcH9uzVWmJ5jV17UmSqb3ummaR2CPK9UmdP3AKO8Bh5nYnPhXvl
         S7NhclKrG7995NRBp4lvOmnycMBApx9BA7u8zk4yKojL6+0daur0f0xDAyNx6TBOkLJW
         yVXMwV1gDBUeZEUF0Z/iRKP5PcmxOKb2NCo4gwqf7N2wmdX4e9mzQ/vKZMEhPf5TVNtV
         R7iw==
X-Forwarded-Encrypted: i=1; AFNElJ+LyJtn+J6sx7X6yIDGS1fsl7b/K4qOhNerzXH1Chg+XR8f7QZjJpc28FhLwPyEeb/0uLfhjR7zzA==@kvack.org
X-Gm-Message-State: AOJu0YzDH2jNsYo4FDwGeIjvd6jYRtuaehlOA0hPoRy0KF4l2957URl9
	3Fn8LytoB22pL3Q+MYixdGytUEUqmRNCquIMQxjvWArEFBo3E2hXLsFFBap7HqDiwaUDZlxo1Wi
	xQuPBCtQD+G2oau4rSx8OrhxY8vqOqIcbMbn+uceK
X-Gm-Gg: AeBDietLU9RJgNm6N5FhcSy1XrNrEX5zzvbwm2IDpuDD/7Eemu7Wwjucpcxqs3173LS
	yZnbkA7YvME9vMKB2J/03Ta5bTOFz0Le403PXcviFq2AoOBGmISaqqJaeUD9Nb6Wp6vFNjqiq2G
	SFK2owhZouddSVyLRv+W5vy1AS0eX+ZHTmQ8SNP2c65WjvLCBENQ+KVt6jGYYMyfl1Z2uvatdDD
	amdofHsC4pGwmOiZfiycBhOcNDtD0B8coGYe2smz0Fkz2KFDF/Mrw75u9IfHIHkmei5LKpNncEZ
	+botLa27ydT8i3+tuXbzu/JOZko=
X-Received: by 2002:a05:622a:2599:b0:50e:41f3:6467 with SMTP id
 d75a77b69052e-50e42a9a87cmr75265781cf.12.1777160932012; Sat, 25 Apr 2026
 16:48:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260424070234.190145-1-surenb@google.com> <20260424070234.190145-4-surenb@google.com>
 <qxxhshfoe5tph4z324fzl74r532bxdrdvll2xvhaeken6bsdwb@q2wk2nbvxr3p> <CAJuCfpE5C9UpkrAEvm6amw7=JYRoXeiSJuPFJnb+LRrVwn4ntA@mail.gmail.com>
In-Reply-To: <CAJuCfpE5C9UpkrAEvm6amw7=JYRoXeiSJuPFJnb+LRrVwn4ntA@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 25 Apr 2026 16:48:41 -0700
X-Gm-Features: AVHnY4KZBbekKCuP917ssJD9scQNvVAIkA6V3UQh7_KRcYvTGhJaQbkMQyDyQ6c
Message-ID: <CAJuCfpG6wZe9N2XREe0Aef=aH5LRGriZYaQeCsqPqoKqMEXN6Q@mail.gmail.com>
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6FA5380006
X-Stat-Signature: bf9jbm9esnrhjij8fmokzbie6hi5zzrj
X-Rspam-User: 
X-HE-Tag: 1777160933-569450
X-HE-Meta: U2FsdGVkX1+IQfaLJ/qVBGC9ZYEwHw4x9snGeuc65Py1oYwOOBZ7LkDf2XqFm3e4azxhI7PhM4f5P217q3JQ/VpIQWjIhWjSt/YJmLJiEjgCpsmSkSoLk0piSgl5H8C41hgfbqldu5hlz7EE2g6ea/lLSjvhr6f9yiz+snI0esWAjcGs6s94tp2SVb1JcNkqiuB+TAiN82KrYvJQ7iiyW+ureU0dlmLjNS2HOix+L84rucBwhzZBsmwXkbUSuFhry4TqrHXW9ItMKlYOXs1L1io9OSQQfK+uvoPyFY9A83MAWrGXcMVAhYzfDgBznpsRNG9mrsZHtHZG3CVS1iYjVg1P518VctsJVazcBCGIhIJKUMeOXOQ7Ui5SmCbYl4z6knlz2U1QiI7HH18ZI0XNpkt/9Qt/auBbJLLoAxwcnavDqBZ6WsejknlXBUNyHufWo8Bjpgbf5k0dSAYNe/5kUiHOvb9OlhASzfGwtorS9z2R3xn3jJ5JXP679VAhK6wfaVUuo1/gqDvNeRTJashpSeFV1jBI/1SqMzwggdFPtxFnygFT69viocNTI7h9sm00HPXcNnTUAuBSP6CXj0dUzsa4ce2w3wv9OfaPD0Bfl3mvB5S2sG5N1KGWOTDkAK25LULdpM0YoUiHpSGDssd6h+1CUBfS7qAobrZkjWXNyhQ9kiommZzzdeDrLAx9ZW6jf3WHH+0mrlxvmub4zYfNUzxfn/VZ9Dcjfzbvb3GFNEKXSAYoiRMOqInKbBWoHBlzio5QORBvWfUNedidFLQrkTMsQzBtNPnAxCtafiNsUdEVc3/Ri1wgwHSds1uCIawFZ8MoXjaHztXIirBRVgft3S9Ip0CuBag4rVAw3SAULrw9W/E6ICR/viHtXU/gTm1MlfTfqhlWAQSf+UDyQA+JEBhtUrFqz7rULvTpeDoMaEjOgNbj/HxL3K9P41Xb52wKDmULRRDdumsfmov/zvO
 AAbJBpjg
 SS4IbTCW+CcFZgsMfOlu4x0ERTBbyv6RjfLd/6sBJSo6KIn3gkq2YRFzNVWayJuRmlI53EvfL7JcyXXJ/BeJNO40iM5AQ7zvQ61Fi453xanIjg/vN7uonglO526uibrYuAheaeIzBBPjoj+m8XQTUGg1rbz9My6iizwUEe/qqHki6nqMJ7gwd1oHQRqmgc9z5SgHfjv6qIOlaeORDMGXGfZlhtc/PRUOQdOYCKHUisMEWX6IdJpSD9AVNxGc6l1BKXHf+8Fj0rARo5QrzBNSrxnr1iESfBTgL8nvcntF56ld9bzkPeoX9w0tiCntLWgBKBNwDxDBhCSvlQfhRVGZusq8by05GMRSMmc5ZqNyFJjD3IqPitgt0gNSfqDOBKaSZCzWL8iI/LvvW+uA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 12:59=E2=80=AFPM Suren Baghdasaryan <surenb@google.=
com> wrote:
>
> On Fri, Apr 24, 2026 at 11:23=E2=80=AFAM Liam R. Howlett <liam@infradead.=
org> wrote:
> >
> > On 26/04/24 12:02AM, Suren Baghdasaryan wrote:
> > > Add MAPS_FILE environment variable to select whether the tests to be =
run
> > > for /proc/pid/maps or /proc/pid/smaps. Add support for testing smaps =
file
> > > by reusing the same logic as with maps file but skipping all the data
> > > except for the VMA addresses, which are the only part relevant for th=
e
> > > tearing tests. Skip PROCMAP_QUERY parts of the tests because smaps do=
es
> > > not implement that ioctl.
> > >
> > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> >
> > One comment question, otherwise..
> >
> > Reviewed-by: Liam R. Howlett <liam@infradead.org>
> >
> > > ---
> > >  tools/testing/selftests/proc/proc-maps-race.c | 176 +++++++++++++---=
--
> > >  1 file changed, 132 insertions(+), 44 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/proc/proc-maps-race.c b/tools/te=
sting/selftests/proc/proc-maps-race.c
> > > index c5031b0593b7..b677bc23cab9 100644
> > > --- a/tools/testing/selftests/proc/proc-maps-race.c
> > > +++ b/tools/testing/selftests/proc/proc-maps-race.c
> > > @@ -17,8 +17,8 @@
> > >   */
> > >  /*
> > >   * Fork a child that concurrently modifies address space while the m=
ain
> > > - * process is reading /proc/$PID/maps and verifying the results. Add=
ress
> > > - * space modifications include:
> > > + * process is reading /proc/$PID/maps and /proc/$PID/smaps, verifyin=
g the
> >                                          ^^^ and? Should this be or?  I=
t
> >                                          doesn't match your commit
> >                                          message.
>
> Quite right. I'll fix it. Need to post a new version anyway since
> Sashiko found a couple of issues.

Actually, I realized that I can use FIXTURE_VARIANT to easily run
tests for both smaps and maps in the same run. I think that's a better
option.
v2 has a number of fixups for issues flagged by Sashiko but they are
quite straight-forward, so I think I can keep your Reviewed-by.
Will post an update shortly after I verify that Sashiko is fine with it.

>
> >
> >
> > > + * results. Address space modifications include:
> > >   *     VMA splitting and merging
> > >   *
> > >   */
> > > @@ -73,6 +73,11 @@ enum test_state {
> > >       TEST_DONE,
> > >  };
> > >
> > > +enum maps_file {
> > > +     MAPS,
> > > +     SMAPS,
> > > +};
> > > +
> > >  struct vma_modifier_info;
> > >
> > >  FIXTURE(proc_maps_race)
> > > @@ -83,6 +88,7 @@ FIXTURE(proc_maps_race)
> > >       struct line_content last_line;
> > >       struct line_content first_line;
> > >       unsigned long duration_sec;
> > > +     enum maps_file maps_file;
> > >       int shared_mem_size;
> > >       int skip_pages;
> > >       int page_size;
> > > @@ -199,6 +205,57 @@ static void copy_last_line(struct page_content *=
page, char *last_line)
> > >       last_line[end - pos] =3D '\0';
> > >  }
> > >
> > > +static bool copy_first_entry(struct page_content *page, char *first_=
line)
> > > +{
> > > +     const char *start_pos =3D page->data;
> > > +
> > > +     while (start_pos < page->data + page->size) {
> > > +             unsigned long start_addr;
> > > +             unsigned long end_addr;
> > > +             char *end_pos;
> > > +
> > > +             end_pos =3D strchr(start_pos, '\n');
> > > +             if (!end_pos)
> > > +                     break;
> > > +
> > > +             if (sscanf(start_pos, "%lx-%lx", &start_addr, &end_addr=
) =3D=3D 2) {
> > > +                     strncpy(first_line, start_pos, end_pos - start_=
pos);
> > > +                     first_line[end_pos - start_pos] =3D '\0';
> > > +                     return true;
> > > +             }
> > > +
> > > +             start_pos =3D end_pos + 1;
> > > +     }
> > > +
> > > +     return false;
> > > +}
> > > +
> > > +static bool copy_last_entry(struct page_content *page, char *last_li=
ne)
> > > +{
> > > +     const char *end_pos =3D page->data + page->size - 1;
> > > +     const char *start_pos;
> > > +
> > > +     while (end_pos > page->data) {
> > > +             unsigned long start_addr;
> > > +             unsigned long end_addr;
> > > +
> > > +             /* skip last newline */
> > > +             start_pos =3D end_pos - 1;
> > > +             /* search previous newline */
> > > +             while (start_pos > page->data && start_pos[-1] !=3D '\n=
')
> > > +                     start_pos--;
> > > +             if (sscanf(start_pos, "%lx-%lx", &start_addr, &end_addr=
) =3D=3D 2) {
> > > +                     strncpy(last_line, start_pos, end_pos - start_p=
os);
> > > +                     last_line[end_pos - start_pos] =3D '\0';
> > > +                     return true;
> > > +             }
> > > +
> > > +             end_pos =3D start_pos - 1;
> > > +     }
> > > +
> > > +     return false;
> > > +}
> > > +
> > >  /* Read the last line of the first page and the first line of the se=
cond page */
> > >  static bool read_boundary_lines(FIXTURE_DATA(proc_maps_race) *self,
> > >                               struct line_content *last_line,
> > > @@ -207,8 +264,16 @@ static bool read_boundary_lines(FIXTURE_DATA(pro=
c_maps_race) *self,
> > >       if (!read_two_pages(self))
> > >               return false;
> > >
> > > -     copy_last_line(&self->page1, last_line->text);
> > > -     copy_first_line(&self->page2, first_line->text);
> > > +     if (self->maps_file =3D=3D MAPS) {
> > > +             copy_last_line(&self->page1, last_line->text);
> > > +             copy_first_line(&self->page2, first_line->text);
> > > +     } else if (self->maps_file =3D=3D SMAPS) {
> > > +             if (!copy_last_entry(&self->page1, last_line->text) ||
> > > +                 !copy_first_entry(&self->page2, first_line->text))
> > > +                     return false;
> > > +     } else {
> > > +             return false;
> > > +     }
> > >
> > >       return sscanf(last_line->text, "%lx-%lx", &last_line->start_add=
r,
> > >                     &last_line->end_addr) =3D=3D 2 &&
> > > @@ -464,6 +529,7 @@ FIXTURE_SETUP(proc_maps_race)
> > >  {
> > >       const char *verbose =3D getenv("VERBOSE");
> > >       const char *duration =3D getenv("DURATION");
> > > +     const char *maps_file =3D getenv("MAPS_FILE");
> > >       struct vma_modifier_info *mod_info;
> > >       pthread_mutexattr_t mutex_attr;
> > >       pthread_condattr_t cond_attr;
> > > @@ -474,6 +540,18 @@ FIXTURE_SETUP(proc_maps_race)
> > >
> > >       self->page_size =3D (unsigned long)sysconf(_SC_PAGESIZE);
> > >       self->verbose =3D verbose && !strncmp(verbose, "1", 1);
> > > +     if (maps_file) {
> > > +             if (!strcmp(maps_file, "maps")) {
> > > +                     self->maps_file =3D MAPS;
> > > +             } else if (!strcmp(maps_file, "smaps")) {
> > > +                     self->maps_file =3D SMAPS;
> > > +             } else {
> > > +                     ksft_print_msg("Unknown maps file %s\n", maps_f=
ile);
> > > +                     ksft_exit_fail();
> > > +             }
> > > +     } else {
> > > +             self->maps_file =3D MAPS;
> > > +     }
> > >       duration_sec =3D duration ? atol(duration) : 0;
> > >       self->duration_sec =3D duration_sec ? duration_sec : 5UL;
> > >
> > > @@ -540,7 +618,16 @@ FIXTURE_SETUP(proc_maps_race)
> > >               exit(0);
> > >       }
> > >
> > > -     sprintf(fname, "/proc/%d/maps", self->pid);
> > > +     switch (self->maps_file) {
> > > +     case MAPS:
> > > +             sprintf(fname, "/proc/%d/maps", self->pid);
> > > +             break;
> > > +     case SMAPS:
> > > +             sprintf(fname, "/proc/%d/smaps", self->pid);
> > > +             break;
> > > +     default:
> > > +             ksft_exit_fail();
> > > +     }
> > >       self->maps_fd =3D open(fname, O_RDONLY);
> > >       ASSERT_NE(self->maps_fd, -1);
> > >
> > > @@ -675,20 +762,20 @@ TEST_F(proc_maps_race, test_maps_tearing_from_s=
plit)
> > >               last_line_changed =3D strcmp(new_last_line.text, self->=
last_line.text) !=3D 0;
> > >               first_line_changed =3D strcmp(new_first_line.text, self=
->first_line.text) !=3D 0;
> > >               ASSERT_EQ(last_line_changed, first_line_changed);
> > > -
> > > -             /* Check if PROCMAP_QUERY ioclt() finds the right VMA *=
/
> > > -             ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr=
 + self->page_size,
> > > -                                       &vma_start, &vma_end));
> > > -             /*
> > > -              * The vma at the split address can be either the same =
as
> > > -              * original one (if read before the split) or the same =
as the
> > > -              * first line in the second page (if read after the spl=
it).
> > > -              */
> > > -             ASSERT_TRUE((vma_start =3D=3D self->last_line.start_add=
r &&
> > > -                          vma_end =3D=3D self->last_line.end_addr) |=
|
> > > -                         (vma_start =3D=3D split_first_line.start_ad=
dr &&
> > > -                          vma_end =3D=3D split_first_line.end_addr))=
;
> > > -
> > > +             if (self->maps_file =3D=3D MAPS) {
> > > +                     /* Check if PROCMAP_QUERY ioclt() finds the rig=
ht VMA */
> > > +                     ASSERT_TRUE(query_addr_at(self->maps_fd, mod_in=
fo->addr + self->page_size,
> > > +                                               &vma_start, &vma_end)=
);
> > > +                     /*
> > > +                      * The vma at the split address can be either t=
he same as
> > > +                      * original one (if read before the split) or t=
he same as the
> > > +                      * first line in the second page (if read after=
 the split).
> > > +                      */
> > > +                     ASSERT_TRUE((vma_start =3D=3D self->last_line.s=
tart_addr &&
> > > +                                  vma_end =3D=3D self->last_line.end=
_addr) ||
> > > +                                 (vma_start =3D=3D split_first_line.=
start_addr &&
> > > +                                  vma_end =3D=3D split_first_line.en=
d_addr));
> > > +             }
> > >               clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
> > >               end_test_iteration(&end_ts, self->verbose);
> > >       } while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
> > > @@ -758,17 +845,18 @@ TEST_F(proc_maps_race, test_maps_tearing_from_r=
esize)
> > >                                       strcmp(new_first_line.text, res=
tored_first_line.text),
> > >                                       "Expand result invalid", self))=
;
> > >               }
> > > -
> > > -             /* Check if PROCMAP_QUERY ioclt() finds the right VMA *=
/
> > > -             ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr=
, &vma_start, &vma_end));
> > > -             /*
> > > -              * The vma should stay at the same address and have eit=
her the
> > > -              * original size of 3 pages or 1 page if read after shr=
inking.
> > > -              */
> > > -             ASSERT_TRUE(vma_start =3D=3D self->last_line.start_addr=
 &&
> > > -                         (vma_end - vma_start =3D=3D self->page_size=
 * 3 ||
> > > -                          vma_end - vma_start =3D=3D self->page_size=
));
> > > -
> > > +             if (self->maps_file =3D=3D MAPS) {
> > > +                     /* Check if PROCMAP_QUERY ioclt() finds the rig=
ht VMA */
> > > +                     ASSERT_TRUE(query_addr_at(self->maps_fd, mod_in=
fo->addr,
> > > +                                               &vma_start, &vma_end)=
);
> > > +                     /*
> > > +                      * The vma should stay at the same address and =
have either the
> > > +                      * original size of 3 pages or 1 page if read a=
fter shrinking.
> > > +                      */
> > > +                     ASSERT_TRUE(vma_start =3D=3D self->last_line.st=
art_addr &&
> > > +                                 (vma_end - vma_start =3D=3D self->p=
age_size * 3 ||
> > > +                                  vma_end - vma_start =3D=3D self->p=
age_size));
> > > +             }
> > >               clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
> > >               end_test_iteration(&end_ts, self->verbose);
> > >       } while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
> > > @@ -838,20 +926,20 @@ TEST_F(proc_maps_race, test_maps_tearing_from_r=
emap)
> > >                                       strcmp(new_first_line.text, res=
tored_first_line.text),
> > >                                       "Remap restore result invalid",=
 self));
> > >               }
> > > -
> > > -             /* Check if PROCMAP_QUERY ioclt() finds the right VMA *=
/
> > > -             ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr=
 + self->page_size,
> > > -                                       &vma_start, &vma_end));
> > > -             /*
> > > -              * The vma should either stay at the same address and h=
ave the
> > > -              * original size of 3 pages or we should find the remap=
ped vma
> > > -              * at the remap destination address with size of 1 page=
.
> > > -              */
> > > -             ASSERT_TRUE((vma_start =3D=3D self->last_line.start_add=
r &&
> > > -                          vma_end - vma_start =3D=3D self->page_size=
 * 3) ||
> > > -                         (vma_start =3D=3D self->last_line.start_add=
r + self->page_size &&
> > > -                          vma_end - vma_start =3D=3D self->page_size=
));
> > > -
> > > +             if (self->maps_file =3D=3D MAPS) {
> > > +                     /* Check if PROCMAP_QUERY ioclt() finds the rig=
ht VMA */
> > > +                     ASSERT_TRUE(query_addr_at(self->maps_fd, mod_in=
fo->addr + self->page_size,
> > > +                                               &vma_start, &vma_end)=
);
> > > +                     /*
> > > +                      * The vma should either stay at the same addre=
ss and have the
> > > +                      * original size of 3 pages or we should find t=
he remapped vma
> > > +                      * at the remap destination address with size o=
f 1 page.
> > > +                      */
> > > +                     ASSERT_TRUE((vma_start =3D=3D self->last_line.s=
tart_addr &&
> > > +                                  vma_end - vma_start =3D=3D self->p=
age_size * 3) ||
> > > +                                 (vma_start =3D=3D self->last_line.s=
tart_addr + self->page_size &&
> > > +                                  vma_end - vma_start =3D=3D self->p=
age_size));
> > > +             }
> > >               clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
> > >               end_test_iteration(&end_ts, self->verbose);
> > >       } while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
> > > --
> > > 2.54.0.545.g6539524ca2-goog
> > >

