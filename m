Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 722A1CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 12:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B815E6B0006; Thu, 28 Aug 2025 08:07:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B574D8E0001; Thu, 28 Aug 2025 08:07:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A73EF6B0006; Thu, 28 Aug 2025 08:07:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9299C6B0006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:07:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1F58B55A6D
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:07:09 +0000 (UTC)
X-FDA: 83826040578.11.9756CF2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id A529F20004
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:07:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YqU6jxhb;
	spf=pass (imf03.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756382826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SBX/QIbYF8bZcQSGX8zo3R/h4s6Tk9khHg95OayRspQ=;
	b=d8g6gaqo7yVfyvlmORDilS03Ayt13K82QqCfRK2+cHvyUAtfjidGiN3cRPp9Rzn6fY9ESI
	vu2z1Chi2ApV2RpTPmGfAAkKcfhqCgbCDSEbCYjQytHfCnmFjTG3q3Y076l9pogefm80qR
	OtN0ZryadGPSchLGz9j2/sJ4NxQ+RsI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YqU6jxhb;
	spf=pass (imf03.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756382827; a=rsa-sha256;
	cv=none;
	b=8qfg5xSUYOdt2BwcAOf9RiJgmpc7ZY13tl8LmVADaGvnSsnkyN6DTUrT5kmlXf00XJW0ga
	sMvlVqTQ/5pCT6fiZj5Iw2beaY6bIQb4wL/FZnkkmD/1ky9AFlSVMPfixm72g8S7OKTtye
	drOD06rF7APlMzciTEDznb5Bpkut8so=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756382826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SBX/QIbYF8bZcQSGX8zo3R/h4s6Tk9khHg95OayRspQ=;
	b=YqU6jxhbWNogrZ2XZr3BHxDDSed3W+GwwGeH6S4ct9+YWFiJJk6B6Jl7gUcCO/JvzpKwXn
	FaFke1oHiihLGLrzgnYo+ZHSYOQeMMGIw7k+iUyftyyumZxlIhS8gZ62c2jGTcyL9b/Khf
	hHBuJbyegkaguCfvekEomkXqKGBjX5g=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-0Hfn9uJLOOiwZkpFuZlx0g-1; Thu, 28 Aug 2025 08:07:04 -0400
X-MC-Unique: 0Hfn9uJLOOiwZkpFuZlx0g-1
X-Mimecast-MFC-AGG-ID: 0Hfn9uJLOOiwZkpFuZlx0g_1756382823
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-b4c724d27f8so103535a12.3
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:07:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756382823; x=1756987623;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SBX/QIbYF8bZcQSGX8zo3R/h4s6Tk9khHg95OayRspQ=;
        b=bS82/IWLkaPgXGARYSvAdNF2OY9HAanMdAncYI6h/14F5PtdJHleYe5VvRvXP/ccUl
         NOb8uJWiNOGgyQXaGzAgRD9GjrSTYqsyr7WOeq0rnZzip91ZYA7rgli0APH2JgiBaali
         ucHLlLbD6fWb1tdGI+SCq+nMaccoMjxHsBK7nmLf26ynigT0wkANxFRbwTyYAElMSTGi
         R78ZjWbT8Y1h7fOsyLU1/HT0UtimsHqV1jCIp5Qs0B65OVXaUrrY+CdzJi4RdQRg4WKp
         d0U0EZlkbcKNhut2GfDYe37IQpjlC1MeLwGAYz/p7WjYlYbiM4xAjTaccz0WEV6D7uwg
         MXnA==
X-Forwarded-Encrypted: i=1; AJvYcCWO555J0QVsBJS6aaj5G9sZa7Cvg8rs24WWA1BI9Ljxzj5rRHpwfL7jsjbtjxD6jf1IOBjhXY0TaQ==@kvack.org
X-Gm-Message-State: AOJu0YxgY2aUjZNGZWhM6CCuyBhwh6+6N+/eP0ZC88kNCbsOgxNsyn7u
	IKl/DggAgXaljuys0dORdjqw9fCTcWDsSfS7e7SAoUvqdwca744HDz7741/6V/+Ch04zlCQIeSw
	du8kJD+PQFTPe4arC4FobssbLB78UYZ6QCxabi1eXLV3ipG/QAXPL7zL9Rv0pdtKfJUU/ysA+EJ
	alz7sUnfncAC4nhpTfN8I0W1HyNPM=
X-Gm-Gg: ASbGncuVd9QPyRh+o7agAA5H8ggaVQnyMgiU2/hkI4RasXgwfLGkGrUgfdK8fFDNm2m
	Rs8MRGW41JpdYM75izBNiAYc7+uIShMpN9inLjEHnK8yRZo1vOCR2blYs5cHIBCNHqQxVYPBusK
	dvdLHWb9yvyLUVwCaBBbD2ow==
X-Received: by 2002:a05:6a20:7d9d:b0:243:25b0:2309 with SMTP id adf61e73a8af0-24340e48550mr35446723637.59.1756382823056;
        Thu, 28 Aug 2025 05:07:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFPl46FQKLakvRj51XKCAXSyuwM7onWpJnbvBL580YvMUNDYLqc0Olk0TvUAUpy/bxer8eKtnxuHkf8DmZWq0g=
X-Received: by 2002:a05:6a20:7d9d:b0:243:25b0:2309 with SMTP id
 adf61e73a8af0-24340e48550mr35446686637.59.1756382822644; Thu, 28 Aug 2025
 05:07:02 -0700 (PDT)
MIME-Version: 1.0
References: <20250827075209.2347015-1-chuhu@redhat.com> <20250827075209.2347015-2-chuhu@redhat.com>
 <87956f34-e6b0-4d03-b30e-56be4f6b84f1@redhat.com>
In-Reply-To: <87956f34-e6b0-4d03-b30e-56be4f6b84f1@redhat.com>
From: Chunyu Hu <chuhu@redhat.com>
Date: Thu, 28 Aug 2025 20:06:51 +0800
X-Gm-Features: Ac12FXyILQs_Ui2_C9YHzrL5YLQvAGhMkQil8RoobMNa47PuiF0hFuCoJjjV8Jo
Message-ID: <CAKJHmxzQwtt-NUukp=w3Rp8S2OG1ojnawXZRC_iKCoSV-HMFqw@mail.gmail.com>
Subject: Re: [PATCH 1/2] selftests/mm: fix hugepages cleanup too early
To: David Hildenbrand <david@redhat.com>
Cc: akpm@linux-foundation.org, shuah@kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CZtErkK3j427AXwqXadnw0ywancFhi-Ix0-cqxKjcG0_1756382823
X-Mimecast-Originator: redhat.com
Content-Type: multipart/alternative; boundary="0000000000003bd66b063d6bbe11"
X-Rspamd-Queue-Id: A529F20004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: z6of4yszzueg4uphs1iquhgdb5dqsr4e
X-HE-Tag: 1756382826-971375
X-HE-Meta: U2FsdGVkX18HF9B9PfWtlfzeO03GxlU01YTqHKGG+ae3P8F9X2lE2DBaUWEVichpuupnHQKEz0SsgmP9DNTelJJNjQ8B3uwPAXzD5Y4LUWo6yEeNiiw/P0bBMEP0YF45VSAzsOvVhbPoUagJrDbk1AM1IFiOcgTJKiOxqLP7s7FF2xC/7FWOSO5U4kTewj0ILt+gKZYAw2aM81GaMIp8Rg19ugBty7am1u88fM2W5useJeXcCjemp8Dnh8A8akvG1UabXfiRBKKDASvqsO74/jGLgBlvohKVQSLG6gzY3ZBC/2wje5tdDoaa0wsnwuBntn5WTdLOzbKbTQ5w9KRgazEZJGhKjFENoVoKCNsIsr3aui6H7h0Fl/FocWXP6FFasZVm969meft01WEg5NW/9ZPUR+ul5WsZBoD/Uy5YmIFh6m72ujvruLRnoXi9Bkq2kI+qq0dLkS6xtzuoaIOL5QKgVBxWcFuosu3QYhAgBDJVNXliKb4kHGCcHtKgB6fULmrVjJk6+RykGc03pE7DYDc7RSS0qXIYEg+9320mjvgNl8WJAvfngjiWz20Ih9Dge3MI3EFdMTTQEyoStdXk6KAPP/DaJkJlrKco32xEFHJz/s8lUKj7Dj/ZDXeELv/2AHmTP0T+1lenUs3Z6pd2amAWPC6R0OSGyjC0uKgH3fCbGKf67GCUQy0pTFmP24Ih3W9oGzhSOFnKNichbD3imFYu/WyDr+Q5uB+6IjWMS6lLBWI2NpF+RhP7tLQugC+n59GjD31B4Py3K1sHkG2iniPbK/QdB0IEVsSKbE21tg0Uy+/aLAZCK/4M6u+KsAmGYvQVawOfOPUYcsbSa+twZNBzxpS7PoC3njVzlDNWb4S2emR76kZldIPLPQ1zymLIu0Ka9LWoKgzd4lu19rVvc5JjuR+0dCFIzUNkUiqfHQUxXNRXbcTX50o4ejC0ireExuv4Wjx+oz3ocMhLOqD
 n35EHVP9
 6R4mzSHgvqPzX97YOtw6Naszl9EvMRmSNmWOOBr2/5nnoXDwe+i3b/F8fL9gfQdMyDia3an9DcY1hqo+nqk0wiM5uVyG2H4TwA3GejX+vN4ufSzUBLFN5wkTJHdQiDOHLC8RfhF/WkquJsiuyEZqBXf7rKM23g+gJaXCvx1X1+fPRRU2YqHEaikcDCcPj5PW7fuou1l2AeGoB8OoCwaz/OeMAszbvJoHhN1VL6oplhtlJlBIjs0eAKOWb9QxgJggFAp9nPhjRukjNTvwHRDPGxh6tTWUAYMw9DIVFI9Nvfd5j+Bdr80FaUPjv8fMD9NBTJZ2xW4qRZ9STNpsEzGr53EV5mEbHjgubp3/5kbeRlXO1A6yjweAM7zCiZ1AlwERM7tMm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000003bd66b063d6bbe11
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 27, 2025 at 7:41=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:

> On 27.08.25 09:52, Chunyu Hu wrote:
> > The nr_hugepgs variable is used to keep the original nr_hugepages at th=
e
> > hugepage setup step at test beginning. After userfaultfd test, a cleaup
> is
> > executed, both /sys/kernel/mm/hugepages/hugepages-*/nr_hugepages and
> > /proc/sys//vm/nr_hugepages are reset to 'original' value before
> userfaultfd
> > test starts.
> >
> > Issue here is the value used to restore /proc/sys/vm/nr_hugepages is
> > nr_hugepgs which is the initial value before the vm_runtests.sh runs, n=
ot
> > the value before userfaultfd test starts. 'va_high_addr_swith.sh' tests
> > runs after that will possibly see no hugepages available for test, and
> got
> > EINVAL when mmap(HUGETLB), making the result invalid.
> >
> > And before pkey tests, nr_hugepgs is changed to be used as a temp
> variable
> > to save nr_hugepages before pkey test, and restore it after pkey tests
> > finish. The original nr_hugepages value is not tracked anymore, so no w=
ay
> > to restore it after all tests finish.
> >
> > Add a new variable nr_hugepgs_origin to save the original nr_hugepages,
> and
> > and restore it to nr_hugepages after all tests finish. And change to us=
e
> > the nr_hugepgs variable to save the /proc/sys/vm/nr_hugeages after
> hugepage
> > setup, it's also the value before userfaultfd test starts, and the
> correct
> > value to be restored after userfaultfd finishes. The
> va_high_addr_switch.sh
> > broken will be resolved.
> >
> > Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> > ---
> >   tools/testing/selftests/mm/run_vmtests.sh | 9 +++++++--
> >   1 file changed, 7 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/testing/selftests/mm/run_vmtests.sh
> b/tools/testing/selftests/mm/run_vmtests.sh
> > index 471e539d82b8..f1a7ad3ec6a7 100755
> > --- a/tools/testing/selftests/mm/run_vmtests.sh
> > +++ b/tools/testing/selftests/mm/run_vmtests.sh
> > @@ -172,13 +172,13 @@ fi
> >
> >   # set proper nr_hugepages
> >   if [ -n "$freepgs" ] && [ -n "$hpgsize_KB" ]; then
> > -     nr_hugepgs=3D$(cat /proc/sys/vm/nr_hugepages)
> > +     nr_hugepgs_origin=3D$(cat /proc/sys/vm/nr_hugepages)
>
> I'd call this "orig_nr_hugepgs".
>

Hi David,

Thank you for your review and valuable feedback. I will rename it with
a v2 and resend the two patches. Do you have suggestions on patch 2?



>
> But it's a shame that the naming is then out of sync with nr_size_hugepgs=
?
>

nr_size_hugepgs is for uffd-wp-mremap, the test need all sizes hugepages,
it's used to save and restore the nr_hugepagees of all sizes of hugepages,
it's a test case setup, not like nr_hugepgs which is a global/general
setup.
They are not the same kind, maybe they don't need to be aligned...



>
>
> >       needpgs=3D$((needmem_KB / hpgsize_KB))
> >       tries=3D2
> >       while [ "$tries" -gt 0 ] && [ "$freepgs" -lt "$needpgs" ]; do
> >               lackpgs=3D$((needpgs - freepgs))
> >               echo 3 > /proc/sys/vm/drop_caches
> > -             if ! echo $((lackpgs + nr_hugepgs)) >
> /proc/sys/vm/nr_hugepages; then
> > +             if ! echo $((lackpgs + nr_hugepgs_origin)) >
> /proc/sys/vm/nr_hugepages; then
> >                       echo "Please run this test as root"
> >                       exit $ksft_skip
> >               fi
> > @@ -189,6 +189,7 @@ if [ -n "$freepgs" ] && [ -n "$hpgsize_KB" ]; then
> >               done < /proc/meminfo
> >               tries=3D$((tries - 1))
> >       done
> > +     nr_hugepgs=3D$(cat /proc/sys/vm/nr_hugepages)
> >       if [ "$freepgs" -lt "$needpgs" ]; then
> >               printf "Not enough huge pages available (%d < %d)\n" \
> >                      "$freepgs" "$needpgs"
> > @@ -532,6 +533,10 @@ CATEGORY=3D"page_frag" run_test ./test_page_frag.s=
h
> aligned
> >
> >   CATEGORY=3D"page_frag" run_test ./test_page_frag.sh nonaligned
> >
> > +if [ "${HAVE_HUGEPAGES}" =3D 1 ]; then
> > +     echo "$nr_hugepgs_origin" > /proc/sys/vm/nr_hugepages
> > +fi
>
> FWIW, I think the tests should maybe be doing that
> (save+configure+restore) themselves, like we do with THP settings through=
.
>
> thp_save_settings()
> thp_write_settings()
>
> and friends.


> This is not really something run_vmtests.sh should bother with.
>
> A bigger rework, though ...
>

Totally agree, with the c interface to do that is better. then the
vm_runtest.sh would  be clean. It's a bigger rework outside of this topic..=
.



>
> --
> Cheers
>
> David / dhildenb
>
>

--=20
----
Thanks,
Chunyu Hu

--0000000000003bd66b063d6bbe11
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div class=3D"gmail_default" style=3D"fon=
t-size:small"><br></div></div><br><div class=3D"gmail_quote gmail_quote_con=
tainer"><div dir=3D"ltr" class=3D"gmail_attr">On Wed, Aug 27, 2025 at 7:41=
=E2=80=AFPM David Hildenbrand &lt;<a href=3D"mailto:david@redhat.com">david=
@redhat.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding=
-left:1ex">On 27.08.25 09:52, Chunyu Hu wrote:<br>
&gt; The nr_hugepgs variable is used to keep the original nr_hugepages at t=
he<br>
&gt; hugepage setup step at test beginning. After userfaultfd test, a cleau=
p is<br>
&gt; executed, both /sys/kernel/mm/hugepages/hugepages-*/nr_hugepages and<b=
r>
&gt; /proc/sys//vm/nr_hugepages are reset to &#39;original&#39; value befor=
e userfaultfd<br>
&gt; test starts.<br>
&gt; <br>
&gt; Issue here is the value used to restore /proc/sys/vm/nr_hugepages is<b=
r>
&gt; nr_hugepgs which is the initial value before the vm_runtests.sh runs, =
not<br>
&gt; the value before userfaultfd test starts. &#39;va_high_addr_swith.sh&#=
39; tests<br>
&gt; runs after that will possibly see no hugepages available for test, and=
 got<br>
&gt; EINVAL when mmap(HUGETLB), making the result invalid.<br>
&gt; <br>
&gt; And before pkey tests, nr_hugepgs is changed to be used as a temp vari=
able<br>
&gt; to save nr_hugepages before pkey test, and restore it after pkey tests=
<br>
&gt; finish. The original nr_hugepages value is not tracked anymore, so no =
way<br>
&gt; to restore it after all tests finish.<br>
&gt; <br>
&gt; Add a new variable nr_hugepgs_origin to save the original nr_hugepages=
, and<br>
&gt; and restore it to nr_hugepages after all tests finish. And change to u=
se<br>
&gt; the nr_hugepgs variable to save the /proc/sys/vm/nr_hugeages after hug=
epage<br>
&gt; setup, it&#39;s also the value before userfaultfd test starts, and the=
 correct<br>
&gt; value to be restored after userfaultfd finishes. The va_high_addr_swit=
ch.sh<br>
&gt; broken will be resolved.<br>
&gt; <br>
&gt; Signed-off-by: Chunyu Hu &lt;<a href=3D"mailto:chuhu@redhat.com" targe=
t=3D"_blank">chuhu@redhat.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 =C2=A0tools/testing/selftests/mm/run_vmtests.sh | 9 +++++++--<br=
>
&gt;=C2=A0 =C2=A01 file changed, 7 insertions(+), 2 deletions(-)<br>
&gt; <br>
&gt; diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing=
/selftests/mm/run_vmtests.sh<br>
&gt; index 471e539d82b8..f1a7ad3ec6a7 100755<br>
&gt; --- a/tools/testing/selftests/mm/run_vmtests.sh<br>
&gt; +++ b/tools/testing/selftests/mm/run_vmtests.sh<br>
&gt; @@ -172,13 +172,13 @@ fi<br>
&gt;=C2=A0 =C2=A0<br>
&gt;=C2=A0 =C2=A0# set proper nr_hugepages<br>
&gt;=C2=A0 =C2=A0if [ -n &quot;$freepgs&quot; ] &amp;&amp; [ -n &quot;$hpgs=
ize_KB&quot; ]; then<br>
&gt; -=C2=A0 =C2=A0 =C2=A0nr_hugepgs=3D$(cat /proc/sys/vm/nr_hugepages)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0nr_hugepgs_origin=3D$(cat /proc/sys/vm/nr_hugepag=
es)<br>
<br>
I&#39;d call this &quot;orig_nr_hugepgs&quot;.<br></blockquote><div><br></d=
iv><div><div class=3D"gmail_default" style=3D"font-size:small"><span style=
=3D"color:rgb(31,31,31);font-family:Roboto,Helvetica,Arial,sans-serif;font-=
size:14px;letter-spacing:0.2px">Hi David,</span></div><div style=3D"color:r=
gb(31,31,31);font-family:Roboto,Helvetica,Arial,sans-serif;font-size:14px;l=
etter-spacing:0.2px"><br></div><div style=3D"color:rgb(31,31,31);font-famil=
y:Roboto,Helvetica,Arial,sans-serif;letter-spacing:0.2px"><span class=3D"gm=
ail_default" style=3D""></span>Thank you for your review and valuable feedb=
ack.<span class=3D"gmail_default" style=3D""> I will rename it with</span><=
/div><div style=3D"color:rgb(31,31,31);font-family:Roboto,Helvetica,Arial,s=
ans-serif;letter-spacing:0.2px"><span class=3D"gmail_default" style=3D"">a =
v2 and resend the two patches. Do you have suggestions on patch 2?</span></=
div><br></div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"m=
argin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left=
:1ex">
<br>
But it&#39;s a shame that the naming is then out of sync with nr_size_hugep=
gs?<br></blockquote><div><br></div><div><div class=3D"gmail_default" style=
=3D"font-size:small">nr_size_hugepgs is for=C2=A0uffd-wp-mremap, the test n=
eed all sizes hugepages,</div><div class=3D"gmail_default" style=3D"font-si=
ze:small">it&#39;s used to save and restore the nr_hugepagees of all sizes =
of hugepages,</div><div class=3D"gmail_default" style=3D"font-size:small">i=
t&#39;s a test case setup, not like nr_hugepgs which is a global/general se=
tup.=C2=A0</div><div class=3D"gmail_default" style=3D"font-size:small">They=
 are not the same kind, maybe they don&#39;t need to be aligned...</div><br=
></div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0=
px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">
<br>
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0needpgs=3D$((needmem_KB / hpgsize_KB))<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0tries=3D2<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0while [ &quot;$tries&quot; -gt 0 ] &amp;&amp=
; [ &quot;$freepgs&quot; -lt &quot;$needpgs&quot; ]; do<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0lackpgs=3D$((nee=
dpgs - freepgs))<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo 3 &gt; /pro=
c/sys/vm/drop_caches<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if ! echo $((lackpgs =
+ nr_hugepgs)) &gt; /proc/sys/vm/nr_hugepages; then<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if ! echo $((lackpgs =
+ nr_hugepgs_origin)) &gt; /proc/sys/vm/nr_hugepages; then<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0echo &quot;Please run this test as root&quot;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0exit $ksft_skip<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fi<br>
&gt; @@ -189,6 +189,7 @@ if [ -n &quot;$freepgs&quot; ] &amp;&amp; [ -n &qu=
ot;$hpgsize_KB&quot; ]; then<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0done &lt; /proc/=
meminfo<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tries=3D$((tries=
 - 1))<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0done<br>
&gt; +=C2=A0 =C2=A0 =C2=A0nr_hugepgs=3D$(cat /proc/sys/vm/nr_hugepages)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if [ &quot;$freepgs&quot; -lt &quot;$needpgs=
&quot; ]; then<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0printf &quot;Not=
 enough huge pages available (%d &lt; %d)\n&quot; \<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 &quot;$freepgs&quot; &quot;$needpgs&quot;<br>
&gt; @@ -532,6 +533,10 @@ CATEGORY=3D&quot;page_frag&quot; run_test ./test_=
page_frag.sh aligned<br>
&gt;=C2=A0 =C2=A0<br>
&gt;=C2=A0 =C2=A0CATEGORY=3D&quot;page_frag&quot; run_test ./test_page_frag=
.sh nonaligned<br>
&gt;=C2=A0 =C2=A0<br>
&gt; +if [ &quot;${HAVE_HUGEPAGES}&quot; =3D 1 ]; then<br>
&gt; +=C2=A0 =C2=A0 =C2=A0echo &quot;$nr_hugepgs_origin&quot; &gt; /proc/sy=
s/vm/nr_hugepages<br>
&gt; +fi<br>
<br>
FWIW, I think the tests should maybe be doing that <br>
(save+configure+restore) themselves, like we do with THP settings through.<=
br>
<br>
thp_save_settings()<br>
thp_write_settings()<br>
<br>
and friends.</blockquote><blockquote class=3D"gmail_quote" style=3D"margin:=
0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">
<br>
This is not really something run_vmtests.sh should bother with.<br>
<br>
A bigger rework, though ...<br></blockquote><div><br></div><div><div class=
=3D"gmail_default" style=3D"font-size:small">Totally agree, with the c inte=
rface to do that is better. then the=C2=A0</div><div class=3D"gmail_default=
" style=3D"font-size:small">vm_runtest.sh would=C2=A0 be clean. It&#39;s a =
bigger rework outside of this topic...</div><br></div><div>=C2=A0</div><blo=
ckquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left=
:1px solid rgb(204,204,204);padding-left:1ex">
<br>
-- <br>
Cheers<br>
<br>
David / dhildenb<br>
<br>
</blockquote></div><div><br clear=3D"all"></div><div><br></div><span class=
=3D"gmail_signature_prefix">-- </span><br><div dir=3D"ltr" class=3D"gmail_s=
ignature"><div dir=3D"ltr"><div>----<br></div><div>Thanks,</div><div>Chunyu=
 Hu<br></div></div></div></div>

--0000000000003bd66b063d6bbe11--


