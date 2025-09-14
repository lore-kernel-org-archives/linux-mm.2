Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D8C1CAC58F
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 02:49:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8995D8E0002; Sat, 13 Sep 2025 22:49:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 871468E0001; Sat, 13 Sep 2025 22:49:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 787A08E0002; Sat, 13 Sep 2025 22:49:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 64FB88E0001
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 22:49:38 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0CB9713A264
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 02:49:38 +0000 (UTC)
X-FDA: 83886325236.26.2C1DDFA
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf28.hostedemail.com (Postfix) with ESMTP id 325C0C0005
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 02:49:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=feJDkiQA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757818176; a=rsa-sha256;
	cv=none;
	b=QMYlgJtL2a/fsXkSegDk6dbdOo4cVtHV+hzeVTwlKQbv9a1gFr1rnOfSzyGC7Ug0OnW1lW
	oaAs8ZXy5mqCk40ek8bqY+2tztihWlrxQMDi42Qq2tTBqf77fLbJy3zoOCpHCi58kZgEHr
	gnYZwk+Jq+MCGMy2Pd31/bTMqMbAANU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=feJDkiQA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757818176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LFavhNV1lWZBO2CYtF6B2ruxGVEn2hxFtUjzEBzIPFo=;
	b=rNyR+6cB4JGPy+KxTM6lTvCkkljxdXHppKpfP5K/f6bP/sujlSCJWlcctuyLX9OyY8vF+U
	eB+Gayv8dvBFuyE/3y0kJd+ckHNDzhr+862ZLjASUA63IsYDd3WPOsSv2VmdEDdFORWbTr
	qmaFEPUxvpV+uXX1Xqh0abXQI52jYi0=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-7726a3f185eso9884826d6.2
        for <linux-mm@kvack.org>; Sat, 13 Sep 2025 19:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757818175; x=1758422975; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LFavhNV1lWZBO2CYtF6B2ruxGVEn2hxFtUjzEBzIPFo=;
        b=feJDkiQAuDtG7WvjScPZWT1HPuqqLAk+0fANA6ym5O2tvM8SedWxyB/UwW2tM0QCUJ
         7bapCYY3MFQayBpr4ALx+hGJeWBaTVJjWVQDUYzjASwvus7Anc4LP8aLdi+teyMo20rC
         ZcZl8LrXbOsHoYqgI/Kh8JUV+poRFBvy2UUsKz/qe0h3j/aqIi9dAJGVpcv8auEVS8pk
         Vx4SGCJsgGoo2CabY/q29x7D2NIbGt9JIt5D75Giadk39SJwBOV3FF6v0ldzR4cgrIro
         Ui/op75mscZuy83OMYUo8OKsYHSCh70uzU3TusdmPLhAT+03/oLJIeXHiLc/e9/k8uPj
         +I7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757818175; x=1758422975;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LFavhNV1lWZBO2CYtF6B2ruxGVEn2hxFtUjzEBzIPFo=;
        b=N8KaZtO9OfmlM6+X+WE5ZCgqrZtloKouI3e6FcUQqLQvvYBjRLpTZzFaQucYB4erHo
         T9hD/85RTrnIhUUyyCeQSiG1g2HpLS6jV8RTmmlR0mBS3p5i2w+HUpYIdQKf4uQWSRJF
         8pfoOn0j7ztQSujjsOiseKlTTYbwuSApnBTSOVU47k1pOybbVqcXLpIR0VX0ELyMM+k+
         N+sH07qQnL3eTZ16kh08XC/m2IH4PqaFJ/x6qnrnf1gnsqSSb1LmDdZoY01iwWzdYQcJ
         FyufPxeGb4Xe80v57lqDcu5p5VZLGITV8ktiuMmi7Kh2X4Kkm81PCs6MfAxTBD0COAXu
         fcqA==
X-Forwarded-Encrypted: i=1; AJvYcCUYrBLz7B57Dphitsc863LbPXxIqreO2sHn8Tkt14trAkfxd0DUAXGxKqlcNjhsXPu8ZmP4GFrGCA==@kvack.org
X-Gm-Message-State: AOJu0YxI/Ph9yXlZ/FxukbG2jReWMGnQQquWx528jD2NntnFm4kK/xEu
	xc+bOzVImEFLPcGNC9gMOStUANRXnaqqBP6/h5jCvr2qyG8H9sDsK2M34wJtf0fh17C25hFIvo/
	CLV6FDAVj9789XINli+rhBdBTY8j9hmQ=
X-Gm-Gg: ASbGnctk/mAR4ll9OLTNVoZeM2c4qmwI3QhRqLgVtAbuUmYwNM7JiURF2yZKqiQi6l/
	1mUVXBxbFH4dGBv71DeMggWoy1TqNNgIZfw/5syHB0ICfpiLxh2REiuc8cRAyKZHu9VrOPdaoHn
	7JIhMW8C2QTSMNBL5PVx2/KEo1+QKIMb3tgoQSVctTYVy33slikPv7t19H/smK+HGnqocg/zj9K
	pkCDaUGh9fNwTcjMP1NC19RroGm5WRWNqPh6i8B5DTG2FKhNpc=
X-Google-Smtp-Source: AGHT+IHu4nD3kgKhcw1xieNm3ZVi/4aJiGK44+ie7MDg9WJVIme29An0JlKCztQhHPTvo3RppfrMwRprZmHweH0qAnU=
X-Received: by 2002:ad4:5aad:0:b0:728:4af1:e4f9 with SMTP id
 6a1803df08f44-767c46cccf4mr121368526d6.47.1757818175268; Sat, 13 Sep 2025
 19:49:35 -0700 (PDT)
MIME-Version: 1.0
References: <20250910024447.64788-2-laoar.shao@gmail.com> <202509110109.PSgSHb31-lkp@intel.com>
 <49b70945-7483-4af1-95ba-e128eb9f6d7e@linux.dev> <DF4CA2C0-25AF-462B-A6D2-888DB20E0DFA@nvidia.com>
 <7d4548ce-e381-47fe-8bb3-5ea38a172527@lucifer.local>
In-Reply-To: <7d4548ce-e381-47fe-8bb3-5ea38a172527@lucifer.local>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sun, 14 Sep 2025 10:48:59 +0800
X-Gm-Features: AS18NWCQoXZMjj8Obq1_xmQrE5op8oMXWfkf-LaS63VH7m9IskWXpSuwhtt-rJU
Message-ID: <CALOAHbAK54mrpWYbCzWjMPrrRFOb7-8kAM7Ud7s6tCMyU7fjsg@mail.gmail.com>
Subject: Re: [PATCH v7 mm-new 01/10] mm: thp: remove disabled task from khugepaged_mm_slot
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, Lance Yang <ioworker0@gmail.com>, akpm@linux-foundation.org, 
	gutierrez.asier@huawei-partners.com, rientjes@google.com, andrii@kernel.org, 
	david@redhat.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	ameryhung@gmail.com, ryan.roberts@arm.com, usamaarif642@gmail.com, 
	willy@infradead.org, corbet@lwn.net, npache@redhat.com, dev.jain@arm.com, 
	21cnbao@gmail.com, shakeel.butt@linux.dev, ast@kernel.org, 
	daniel@iogearbox.net, hannes@cmpxchg.org, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 325C0C0005
X-Stat-Signature: yk348gafh7d773iprc65wzfoo6zbtep9
X-Rspam-User: 
X-HE-Tag: 1757818176-676012
X-HE-Meta: U2FsdGVkX1/qBubCMRHZHUKu3CwO5MMXTyuG+jBffucKNmoBFuPbZGbblbYirfW7Ses3wVOE6ftj//45qsunApC4Gu2o+0qQo6I6TrRs4okfyHgAPIaWMwx+Oeqp+JE8VNDuMTBWHrS55GR37ImLkJCNhO59eR57DRa5dmtrmuGcEioCfk7qJcorWOPm6YMWKhdSemd6U64UwvBDD0teBq2XVVepqV+shV2v8I+D3g0o5CuqdYtUty3STrwZ/A+ZljSQSAxUzZWIP1UXav9yjee7x09/PU6k7MQSOjwrYuZKaf+ln6MtOMJ5EPvR6ExBMDj71BQFDjXCDQfJ9eCbOiEPlEDlFFhlFHuUcdxmTCqAj2Gme5dNd4UosBPR2RxyuMCRAP2qboBzTF+cZSQrR8zzBsNu+WWn3Caij0TMTu7qT037qRv5mQ25QUfT8HN7mgwjVzV4W1+eWMer+Ae08ByBRipYqXOMaeO4FKpKPprFQ1oxS1vPgbbpCuVVt1x+DyreqON4dpeJW0Uk6UjesOvrW0uVepCSI3UNyvy2tHJdi4GlBHAkB3J+Q8aqI7GPYAwwKLSrDnWRrv746ui9DheYgKwqjFnheD5XsBlSJOzqm5KE6LnK6vSMVqj2UCk3NZEBf1uxqgSnryBOmzX+WKVdAsyn8IhjV1jxj8ZxWYEtkUQjmuBt+iho0QSxGPy+am7fJad01gN34hJhEVOjaaofSSDcw1jsQhvihSh41wFa96g6gd2Gr+hQa1eXJOJ7GQTDVxIjHmfoSPT9nGFpfWsIDjoS5SzIaLFkhBGdvC94xtc7HX9xhi6yaMwutTctytrDXognVvaDc08idrIMaoNyclxb8EKUjhOoHLacR+6/LO93c3jKWkz//maOOLDejpxhRrT7Y0+16dG+Pn2InWtG9YanK34GhLukEkE6NilQOF/6QrPrrhU1XWrBbnS66arFhDrxAGUdzt0SCyc
 P2M2MP/d
 kKb1Zh4ZSixm7VxWGEMns4rrfEG3ajo+fetmuY/8ml/2rVUS41mA+5ljJ7MobG8wK2lMm9BlJhNxvXRdhWpkuvtWXwUAkDpNa/wwrs6binTss+L6PE+nghMOeg6TfkB3r1k+RmqKDyn4y5Y0n10vONG1FXbUc7201AIlDP8F4M3yNJGtuxBPJ4EhYTPaYGCP+4dtzrLWwhB7dRdMAMghKNLuLQKqbIkGe4he2TKwJp+5fWGG/1CJm6rgDSd5+AFqvZxy8hBF8D+/cmPFRAH0qy3iGtll/aeS+mB79guglNUPep+90fM3hmyS4grGFyJgB6s7ByRnzzlPpQIda1nfRLF66IIikTN6XJFf7jX763/WhotqDSKc4yk4rhjD2vgjUhIm6Lk7ldYQgbi3shATDNnX75m6tDVV1LmLHANM95S/9yfN5u2p8yRUbqI5p1r/PY7wnhxaPReR5M/5VIXpOUObE42vqwR4sQTxmCXoV7xSO7qwb7iMhE7V3VXRnYcFbyKdxMyZSMXk/xvVv4jO3Etga7SsXJ682yVydnTB5xospUXZrsAhbiG023ZONw2JpAfi4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 9:47=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Sep 10, 2025 at 10:28:30PM -0400, Zi Yan wrote:
> > On 10 Sep 2025, at 22:12, Lance Yang wrote:
> >
> > > Hi Yafang,
> > >
> > > On 2025/9/11 01:27, kernel test robot wrote:
> > >> Hi Yafang,
> > >>
> > >> kernel test robot noticed the following build errors:
> > >>
> > >> [auto build test ERROR on akpm-mm/mm-everything]
> > >>
> > >> url:    https://github.com/intel-lab-lkp/linux/commits/Yafang-Shao/m=
m-thp-remove-disabled-task-from-khugepaged_mm_slot/20250910-144850
> > >> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git =
mm-everything
> > >> patch link:    https://lore.kernel.org/r/20250910024447.64788-2-laoa=
r.shao%40gmail.com
> > >> patch subject: [PATCH v7 mm-new 01/10] mm: thp: remove disabled task=
 from khugepaged_mm_slot
> > >> config: x86_64-allnoconfig (https://download.01.org/0day-ci/archive/=
20250911/202509110109.PSgSHb31-lkp@intel.com/config)
> > >> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project=
 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> > >> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/=
archive/20250911/202509110109.PSgSHb31-lkp@intel.com/reproduce)
> > >>
> > >> If you fix the issue in a separate patch/commit (i.e. not just a new=
 version of
> > >> the same patch/commit), kindly add following tags
> > >> | Reported-by: kernel test robot <lkp@intel.com>
> > >> | Closes: https://lore.kernel.org/oe-kbuild-all/202509110109.PSgSHb3=
1-lkp@intel.com/
> > >>
> > >> All errors (new ones prefixed by >>):
> > >>
> > >>>> kernel/sys.c:2500:6: error: call to undeclared function 'hugepage_=
pmd_enabled'; ISO C99 and later do not support implicit function declaratio=
ns [-Wimplicit-function-declaration]
> > >>      2500 |             hugepage_pmd_enabled())
> > >>           |             ^
> > >>>> kernel/sys.c:2501:3: error: call to undeclared function '__khugepa=
ged_enter'; ISO C99 and later do not support implicit function declarations=
 [-Wimplicit-function-declaration]
> > >>      2501 |                 __khugepaged_enter(mm);
> > >>           |                 ^
> > >>     2 errors generated.
> > >
> > > Oops, seems like hugepage_pmd_enabled() and __khugepaged_enter() are =
only
> > > available when CONFIG_TRANSPARENT_HUGEPAGE is enabled ;)
> > >
> > >>
> > >>
> > >> vim +/hugepage_pmd_enabled +2500 kernel/sys.c
> > >>
> > >>    2471
> > >>    2472    static int prctl_set_thp_disable(bool thp_disable, unsign=
ed long flags,
> > >>    2473                                     unsigned long arg4, unsi=
gned long arg5)
> > >>    2474    {
> > >>    2475            struct mm_struct *mm =3D current->mm;
> > >>    2476
> > >>    2477            if (arg4 || arg5)
> > >>    2478                    return -EINVAL;
> > >>    2479
> > >>    2480            /* Flags are only allowed when disabling. */
> > >>    2481            if ((!thp_disable && flags) || (flags & ~PR_THP_D=
ISABLE_EXCEPT_ADVISED))
> > >>    2482                    return -EINVAL;
> > >>    2483            if (mmap_write_lock_killable(current->mm))
> > >>    2484                    return -EINTR;
> > >>    2485            if (thp_disable) {
> > >>    2486                    if (flags & PR_THP_DISABLE_EXCEPT_ADVISED=
) {
> > >>    2487                            mm_flags_clear(MMF_DISABLE_THP_CO=
MPLETELY, mm);
> > >>    2488                            mm_flags_set(MMF_DISABLE_THP_EXCE=
PT_ADVISED, mm);
> > >>    2489                    } else {
> > >>    2490                            mm_flags_set(MMF_DISABLE_THP_COMP=
LETELY, mm);
> > >>    2491                            mm_flags_clear(MMF_DISABLE_THP_EX=
CEPT_ADVISED, mm);
> > >>    2492                    }
> > >>    2493            } else {
> > >>    2494                    mm_flags_clear(MMF_DISABLE_THP_COMPLETELY=
, mm);
> > >>    2495                    mm_flags_clear(MMF_DISABLE_THP_EXCEPT_ADV=
ISED, mm);
> > >>    2496            }
> > >>    2497
> > >>    2498            if (!mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm=
) &&
> > >>    2499                !mm_flags_test(MMF_VM_HUGEPAGE, mm) &&
> > >>> 2500                  hugepage_pmd_enabled())
> > >>> 2501                      __khugepaged_enter(mm);
> > >>    2502            mmap_write_unlock(current->mm);
> > >>    2503            return 0;
> > >>    2504    }
> > >>    2505
> > >
> > > So, let's wrap the new logic in an #ifdef CONFIG_TRANSPARENT_HUGEPAGE=
 block.
> > >
> > > diff --git a/kernel/sys.c b/kernel/sys.c
> > > index a1c1e8007f2d..c8600e017933 100644
> > > --- a/kernel/sys.c
> > > +++ b/kernel/sys.c
> > > @@ -2495,10 +2495,13 @@ static int prctl_set_thp_disable(bool thp_dis=
able, unsigned long flags,
> > >                 mm_flags_clear(MMF_DISABLE_THP_EXCEPT_ADVISED, mm);
> > >         }
> > >
> > > +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > >         if (!mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm) &&
> > >             !mm_flags_test(MMF_VM_HUGEPAGE, mm) &&
> > >             hugepage_pmd_enabled())
> > >                 __khugepaged_enter(mm);
> > > +#endif
> > > +
> > >         mmap_write_unlock(current->mm);
> > >         return 0;
> > >  }
> >
> > Or in the header file,
> >
> > #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > ...
> > #else
> > bool hugepage_pmd_enabled()
> > {
> >       return false;
> > }
> >
> > int __khugepaged_enter(struct mm_struct *mm)
> > {
> >       return 0;
> > }
>
> It seems we have a convention of just not implementing things here if the=
y're
> necessarily used in core code paths (and _with my suggested change_) it's=
 _just_
> khugepaged that's invoking them).
>
> Anyway with my suggestion we can fix this entirely with:
>
> #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>
> void khugepaged_enter_mm(struct mm_struct *mm);
>
> #else
>
> void khugepaged_enter_mm(struct mm_struct *mm)
> {
> }
>
> #endif

ack

Thanks for all the suggestions.

--=20
Regards
Yafang

