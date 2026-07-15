Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C385FC44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 14:19:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB2CB6B00AB; Wed, 15 Jul 2026 10:19:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8B5B6B00AD; Wed, 15 Jul 2026 10:19:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9FE86B00AE; Wed, 15 Jul 2026 10:19:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 82EBC6B00AB
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:19:13 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 469DB16010C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:39:57 +0000 (UTC)
X-FDA: 84990665634.19.AEB39A1
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4DEEC40006
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:39:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784111995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BcTdMoZv6JVy6M/fO3WdP9FofoXGw30zAP9bsFgIqfs=;
	b=F/Gfn+6QPoGZHmYOsfvD9S8989kA1rG+e8SKUEk619CrsRYEWm/rMGN3fEXaUJ6uARpoh+
	8vFCbJOyW9Mh9pw2/2r7sEJ0zLK1mBjOwtiadwl1yEeGbxuZbEwhUKUU1zwJN5uo3NEZNg
	zdus40gtob/s0Fv3qotD8iRf4HW9aCw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784111995;
	b=r/E/ZUGYXnsGBIA5ullJdmYTAg9YNhZRgP5dtJlmdv114FAO8L/K8aPQ5g7Ls29UkjXEI9
	1xbeXl4dlvUgRCbPe8eQvErfoFFT5hcgZ624eOyGKryGMX3XOMkB+OmwG+FJyJY1YoNfT1
	AblKCzbiAFy2MTpDfhGI6CBkYOCAfIA=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-92e85499ffbso149652085a.0
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:39:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784111994; x=1784716794;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=BcTdMoZv6JVy6M/fO3WdP9FofoXGw30zAP9bsFgIqfs=;
        b=f86fsyrcAZA0O4TOw/MTbshFX9Ki7ih3IKgze+6J+ltr97JzY5+2X4MN3Onfo112MP
         nC+j09uLBnqiwDTMSiNfvazT0ptEAuQiyPFfjHOffLSxN5B1BPstBMZZrJ+1AhIlKeq3
         nUMFT+TGJJFolKEuBysOlZEoJ47uD5SrvyJQKRjuwg5d+7uysgETrnmVI10xz1kfJrsZ
         5eBWeX4VBtLM3YzgK+sZXG1GfarTO4oJFEQHJd/Nl4oo4WCrr5b/B+gzJ6hffYJdRrg0
         MIJrjt8NJgM5ORuIOZsZIH+CMxw3WfxEj+1ik8HXHQ/+w6UNZ+uDdehUe4+87l1pXW3h
         k/sw==
X-Forwarded-Encrypted: i=1; AHgh+RqfF01TLjW3ZDzwHsrYDaYyiMZdQdbf8Zs2lG1Z/0uWM6te/XCdTWV58y2qShJP/Q6JKHsonIWrBA==@kvack.org
X-Gm-Message-State: AOJu0YwjD5+5u0jz6ueB+SUIazs2juy7pn8wQPpN0T9acqjcl8a1ooK1
	rYQdyk+EJIkhwPigJLBHhNaJ6olCP0bk2my5D4QvrXS14lqgtF2uSvk3az869ULPcHQ=
X-Gm-Gg: AfdE7cmbgsa3+sLWQJGMJA2KwohRgNpCAxuSsea85shb9IRguVy0XHyD25JoJy1ddfD
	O6lJCDnV4RNvFRwOWNsDXjCJ/KW4weqsLUo7BXoon3YJbTyAFArWwyb7tdgUPpQCb8jhMMwRk5W
	adJYikYPHDcnctQpcgzbVilW1FGkFh+debFPRKqOtWWpQJchmiIt7GOwhA7AXJ0lYykXTJllOYN
	tYtmBfbIeBIGBJOhH0Ii78pLmakHYhoggmPGfhLceO2IErxF6Xsz1e843G9P7cwgFEHQM8o0HNV
	IiwDQXtMZXNAijm1rjss6ns8/EwTpvXQCK4ewEq/tT1RRn9pL02vIitrAqN3OsyS12TF3HCYCqw
	yYw9xQdtkExBGUdJDs4rmYEl4UqmsxVd8RLVB7JADLRYFI3aedjbGzkK79FFPloWTNQMgyS5cSz
	VK7vEY2NactBsTakRzZU4agqDBJk8Jm/Va3xb/XEsRzNU0W72Mz6xj3Q==
X-Received: by 2002:a05:620a:3947:b0:92e:60c8:1cb7 with SMTP id af79cd13be357-92ef2bcc66emr1997101485a.50.1784111993316;
        Wed, 15 Jul 2026 03:39:53 -0700 (PDT)
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com. [209.85.160.175])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5cf7ab2sm1630122985a.30.2026.07.15.03.39.52
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2026 03:39:52 -0700 (PDT)
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51c1d487f2cso20468261cf.1
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:39:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqDkKfJx0Qp5ZsDQMX4HKYJkW6vmPr5iSQe5VTdf+hISV5+NEv1wikY8env8cnL09BrEM1ls9Mzxg==@kvack.org
X-Received: by 2002:a05:6102:94c:b0:730:db02:1d08 with SMTP id
 ada2fe7eead31-74533c1eae8mr11245328137.10.1784111681255; Wed, 15 Jul 2026
 03:34:41 -0700 (PDT)
MIME-Version: 1.0
References: <3ea30f8a-bb29-4bf5-8400-1c4840d46a88@kernel.org>
 <7e84b200-25eb-43a6-b5e2-5f27f2d82a77@intel.com> <31988089-095a-4eed-b5e2-c677c70f79f6@kernel.org>
 <14e250db-1641-4085-8d13-02f819657d5f@intel.com> <d83c76b3-ea4d-4c41-b4c5-f5ae558ace55@kernel.org>
 <alYgMxKqRnF6_X0A@e129823.arm.com> <6df814c9-405c-48d8-96ea-929c4b28949b@intel.com>
 <alZe-Cu7yQw9qRXU@e129823.arm.com> <alZo9feSrSB_StfO@e129823.arm.com>
 <CAMuHMdUqL=vJFAzYgcRVNbD_VWWwhehwTuhTfwLt_yRR8c+B0g@mail.gmail.com> <aldV23PwIXnFloaN@e129823.arm.com>
In-Reply-To: <aldV23PwIXnFloaN@e129823.arm.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 15 Jul 2026 12:34:29 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVOHm6MmP9QsNVvxLsGp1e0jC9u9RGb6+xee0ZBs4Zwfw@mail.gmail.com>
X-Gm-Features: AUfX_mxU0lxjO-fzCeQeNX344H_SVkvovWXaE8EEgaGKFYO5e9NLd2LkTofC79k
Message-ID: <CAMuHMdVOHm6MmP9QsNVvxLsGp1e0jC9u9RGb6+xee0ZBs4Zwfw@mail.gmail.com>
Subject: Re: [RFC PATCH 10/34] x86: mm: carve out the generic compile-time
 folded pgtable case in effective_prot()
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Dave Hansen <dave.hansen@intel.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linux-arch@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, x86@kernel.org, linux-mm@kvack.org, 
	kasan-dev@googlegroups.com, linux-csky@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org, 
	linux@armlinux.org.uk, akpm@linux-foundation.org, ankur.a.arora@oracle.com, 
	rppt@kernel.org, linmag7@gmail.com, chleroy@kernel.org, klarasmodin@gmail.com, 
	chenhuacai@kernel.org, kernel@xen0n.name, kas@kernel.org, 
	zhangtianyang@loongson.cn, wangyuli@aosc.io, tsbogend@alpha.franken.de, 
	ljs@kernel.org, jgg@ziepe.ca, catalin.marinas@arm.com, will@kernel.org, 
	arnd@arndb.de, ryan.roberts@arm.com, pasha.tatashin@soleen.com, 
	rmclure@linux.ibm.com, baolin.wang@linux.alibaba.com, tj@kernel.org, 
	kevin.brodsky@arm.com, anup@brainfault.org, atish.patra@linux.dev, 
	pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org, 
	tglx@kernel.org, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, kasong@tencent.com, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com, 
	dvyukov@google.com, vincenzo.frascino@arm.com, anshuman.khandual@arm.com, 
	yang@os.amperecomputing.com, chaitanyas.prakash@arm.com, ardb@kernel.org, 
	guoren@kernel.org, yang.li85200@gmail.com, viro@zeniv.linux.org.uk, 
	dinguyen@kernel.org, schuster.simon@siemens-energy.com, 
	wangruikang@iscas.ac.cn, junhui.liu@pigmoral.tech, muchun.song@linux.dev, 
	vishal.moola@gmail.com, namcao@linutronix.de, pavel@kernel.org, 
	djbw@kernel.org, yu-cheng.yu@intel.com, baolu.lu@linux.intel.com, 
	Jonathan.Cameron@huawei.com, coxu@redhat.com, andreas@gaisler.com, 
	liam@infradead.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com, 
	shorne@gmail.com, jonas@southpole.se, stefan.kristiansson@saunalahti.fi
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4DEEC40006
X-Stat-Signature: jhurm6w5z8imbiaz4jgfuxwhsdkutkqa
X-Rspam-User: 
X-HE-Tag: 1784111995-16734
X-HE-Meta: U2FsdGVkX1/buhafExxp3IOW5Npr5BbjC4ui+RJeaHHWR+HTEMGnFL3wVuH9TZhWWUjleP+d3TalAPBg4ciJsoSCMo2NBEYlghFvihiGALvUplfN1hshNsol/3SIvQZZhEFRn18L4+Jod0ZM4FCnba+vt7ofAkwHCnt4XTydOt83me4Ca1FGLpXVocKOpTZoZF7Ay9ussRYPGMmdldCi2xwdp4hJm2SR4j57N5RlGl1aBFzZa91v4gcxdMFQA3l2YQ5bUHIWBAq5nb3qJWxVoXOeZ5Ad+Z+eooL7+HiQFWQVKiaY83OSyaYMh8/fJYIgKoGM8DaRpCjADaiAeEl+VJwbjlJG5z7HeIpC4NK2V40T4ycLg5TGutiIYd+3TxIUQ+3wAbpIseh48VhJS2ZLvmfH7yN0BDrF3OoK8sWt/Eg4nlvahvcaCuMdcYHNtwmB3viEoMHzGkGGNizh3nlA6oZfCD7Qu5BUBbRjm9mp6LF3xhgWH2u6qyL6g5+1QdMHlIAG5kp0D9QKhjNtW15ZNtgcFkSrw/2WJD6ba6GZG0sFot7aBygC5HJhYBMdp8Kj+upNS1+tN6BgL3svbrGx1DxVluI1rbthYuhMYgjQI7Ez5SYQ5jfrUG7TfwC2+Xue4qzQ7ehOxvLFSpFyOBPORLTSheucZCRTIJjgQtNT/51iLFzqmU9d2WKKgR5tnsd1A56zw1DKRCJbCiW1fgOpVPl3P6uPU2wIZddEOBExJpkyrMBItw3cIST223yVd6HvE+uP584amwhMslX0RS4WBxFr4po+VacHwXEfckdWa4grWCipnoxsWBqBFmHPW5bJDDNGxzxxvNrCJsIXfW/Z3A5oTUmFPG7rzWjvI/UO8pvUzksHqpXS+4yMUB4awO9k/Q3KItLCGKFx3fGdO64RX1LSuBNg/WzfrMZIC+4x4XWiKktE6APZx2TbzQOYuR7V2L/4ze4GAIciKs/QzI7
 BWRsPiia
 0TmWC6iOzevxyIeJQCLRapy+Ce/3Mm4E3KyWvEiYjMtaSGolKb0eoGj+7Yi1/gbFI/z5mwfhNdiX1/HUVawDrFUqWVSS+hWojWH3vL1UE7juppnjT5jfRf9TixkwKexrQCJp9IdvFAi1uWRreUaTvOUQ8uSPCqHBhzzFF0R9Pwq5pNP650uj2pU9/YUPY8o/q4wmvK6WCvOau3AxRW1LFW/RDtR7o3x2+JQYo7fScjPbXa52M/z/U5tv8LnzsDB1/6M7BTRSqKTJitBgqupjjQkMkMJXcrnAUN36fKaXjCAKxhqPTh1wdXkIJj+kocqc+ZFgjJsl6pxS5Qv1zyU7tyo57XWxb7o/Snyl+KaEIAAEZUkZ1WODniKfiB9x72R4pmlNjDhXOA9rB7cS7EWzHWIImIrlfx4vfGYukkXylzpOm2ttcIyNZa/r6/0ozcg2UYP8BPfSmEdOxx5Tb9i/FlXDzl4aY8qLlaybkjoxelmniKB7vo8qIAhNIoS0gnhteVmWM3mb2l8hd2V2+xkrFVFmYdegFhQvzL2NjQlKl/RO3+I+JiMRhh3n3GQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yeoreum,

On Wed, 15 Jul 2026 at 11:42, Yeoreum Yun <yeoreum.yun@arm.com> wrote:
> > On Tue, 14 Jul 2026 at 18:51, Yeoreum Yun <yeoreum.yun@arm.com> wrote:
> > > --- a/mm/ptdump.c
> > > +++ b/mm/ptdump.c
> > > @@ -190,6 +190,23 @@ void ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm, pgd_t *pgd)
> > >         st->note_page_flush(st);
> > >  }
> > >
> > > +bool pdtump_pt_level_first(struct mm_struct *mm, int level)
> > > +{
> > > +       if (!mm || level > CONFIG_PGTABLE_LEVELS)
> > > +               return false;
> > > +
> > > +       if (mm_pmd_folded(mm) && level == 3)
> > > +               return true;
> > > +       if (mm_pud_folded(mm) && level == 2)
> > > +               return true;
> > > +       if (mm_p4d_folded(mm) && level == 1)
> > > +               return true;
> >
> > Is this order (... && level == ...) the optimal order?
> > On arm64, mm_pud_folded() and mm_p4d_folded() perform several checks.
> >
> > > +       if (level == 0)
> > > +               return true;
> > > +
> > > +       return false;
> > > +}
>
> It is. since the purpose of ptdump_pt_level_first is designed to be used
> in the *callback* of pXd_entry(). IOW, if we check level 0 first,
> it always returns wrong return in folded case.

I meant the order inside the if () conditions.
E.g.
"if (mm_pud_folded(mm) && level == 2)" does the expensive check first.
"if (level == 2 && mm_pud_folded(mm))" does the cheap check first.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

