Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9B47C44507
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:15:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A07B56B00BE; Mon, 13 Jul 2026 13:15:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B7DF6B013E; Mon, 13 Jul 2026 13:15:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A6FE6B0141; Mon, 13 Jul 2026 13:15:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 50B8E6B00BE
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:15:36 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B38051A011B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:15:35 +0000 (UTC)
X-FDA: 84984405030.28.9282939
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf29.hostedemail.com (Postfix) with ESMTP id B6D22120005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:15:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jmmSf9Nk;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783962933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mxVrxa7HxzqTiw7ir6NHv4olNuo0XGTjz/0zgJXDsGk=;
	b=WNwEHPxgmIRluciG0UUWhzywP3RXAuNsL4QP/PRDB/Xr1erL/q0QnaJXKJALBen/tQ2O8L
	XbiGHJJeiqsSXkhvZz+vVgllMy0UmtZP9g55eK1VZNq6JQRuugwzrej3eRnz0qIEoGYQg8
	DKg1FLVraNPuIe6h6baED399O9PLFs0=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jmmSf9Nk;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783962933;
	b=DqBexczx1Vkp/oO/+2gMu+O6sdVfxIoxt73uU677Z2G6N6+MOuLLuT2q42pvWO18H6v1QP
	K/iftFY/ySJV77YH4UjDCfQm/S1rDZ/osUSX8Ds1kMWmCjQMdVgx52i0btTzaEjQ7ShzYb
	28C1xQAQh+O83SUZYwBdbXbQWw/rbdk=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51c10ed63c0so9901cf.1
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 10:15:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783962933; cv=none;
        d=google.com; s=arc-20260327;
        b=Nm56gFUV5gS4g1dpwCgDSwGcZTWzn3xzmMzBqRsF8gNp177kKYRKyQLy+petRhOSYH
         M3zsrvUovYQk+nxwpzrdF+4lmD/I4Sf7FHM5cXqK7wT7Xdv59AzVrXh5fsvq05YiWldC
         0r0A3GjNROs4bytsQOz/67lZM0OuMvMrc2SmOhl6v+bubxuOVytE7jWlUoQ4tMyZWCqT
         yI7h+jQp0kpsWkBBcBj0tg/PyaMeOGMbmTRD76Mvhx/1qLnwQbm6/scYE9p8OaS7TLF/
         NKNtueQ60NcAv+NQWxwGTCIlUvBHveGuSGe9Jh2YgxlLQKsYRa/HvjBPEZKgmDziaIvR
         fG3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mxVrxa7HxzqTiw7ir6NHv4olNuo0XGTjz/0zgJXDsGk=;
        fh=5GTGzPDFalB2pMVp1cshmedU3d+ntroAYgYiAAAcN4M=;
        b=i41FHlUiw4QVCfUIsEJECg2lM+HcfmgJ6c2EloKltclIxIZ0H6dcmgspeTr0pkO0wt
         Lql9gqcSGWx6KHhqFefdj9pfxmUMVPnYAHkWYvJSu4hp+/UBQBAHmj4nhFtX7d9LqSTC
         mH21bCn8LKxGr1bN0t23dOaT1buBZwmqXQvLZmZFLNtmlFBlWOE1JV8w7uCwnq2Vsd8w
         /Wsq6bL9oUZLZpbK+6n0tGCvzb2Fev4/anE/q1w1gmVFd4kkBpu9RjEqAFlaI2oZlgl6
         QWv6Y2glr+sFS6SyFWBLAykujxnwGyqiGnMsv7btKqACe9ATQcyp7NkY3Y/gPBlk+Ox6
         O3aQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783962933; x=1784567733; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mxVrxa7HxzqTiw7ir6NHv4olNuo0XGTjz/0zgJXDsGk=;
        b=jmmSf9NkPnHpIZgfkoQmPXTE0OaCOO2jLsZc8G64ciHxDIR0VXnuQ5WRpGn66dCgNS
         XsMHTb6VfyS6Ci2HPTsAettf6eCfbEhvdGyFDM6c1sY4hJ+Bz6xhzp1w0yiKZV/wbqJM
         /Kuck/zxaYB4zKQgzjYEQhgOjXDqOFtZ1yS+bSseCbmGgIFaE6SbQeOUuiNI83qhDu9u
         d3Avgkx065aTa/Bmez/YreTY2nkp7w7ZBtYbTbBz/tyA/5/m7pFubvmkAO9oTLZHSYKM
         pzoyN9fADALORnc4SO72ioJgO/qJuffdaqfx+kSPKIWbOIDGnVN+0GTIAOY6vAGy5Cdq
         5zVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783962933; x=1784567733;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mxVrxa7HxzqTiw7ir6NHv4olNuo0XGTjz/0zgJXDsGk=;
        b=sORJhyoSlqo2yZzwKHOcDIZ1JqNifkqUBXHFt6pjcMQfbnhIXJxa2aqP30n7NVzxRe
         NL3NN+eZwE6CIrKS7WsknmwWl+mAcLOPQql8uCCCsiU1I7bPe5f9+/qHE58OiEVEkV7k
         Rk3ecwAyryS+EKZyAP+d4Ve/8PzptJdeLykkp6xH/50GKIU0W4PLulDNhYX/UMP0i4GH
         GOxh/NfFZ2PRCiAfIUv5KJ6SrtUTbFDGSUM5+pgA2v5rnb2jsmk5u58yI5iLExd8QaRn
         RoI9wO3gD1JawihcJOWDqXdJ5YdL40775oQnywrI3vq+Tq/E3G40uNZTTFqOahLMLGJ/
         6/dw==
X-Forwarded-Encrypted: i=1; AHgh+Rr4vKp9ynzIR39HUslmdJr05ISNjHLoUKQBAk7gY6W/RQiX7d9dCMeC5T3cOTeeWm1PriRKo9RwBA==@kvack.org
X-Gm-Message-State: AOJu0YyxkGp7/Jh1YxRVP/7PgpUM5jYmAOmMgqIQTYjVxlYcW+W5y1iV
	LD8j3crMyUOryshy4dAUwjgvrirlPIVlYQVJ9ET2WM5UcZSxFuJuWv8HAPgfcCInjXKBl+8jpL7
	E8kLkBg8NyCkBsmaqpXyOZyYJ9P289ImApyo0wYtW
X-Gm-Gg: AfdE7ckXv968EW87nz50s7tKrcc2/k/r5TjpTJAH/hq1iD1MC/cPC3ZtE3of0AWNRUY
	dRFJldOclHJLiHSqwJIF7Vio31P4Dmh1lOn0SfpKZdZ5sXmw2A9+rog5ijHZ4u5cCZlhjMxwoaT
	1W32ESshuoiCpj6Fe2bH2wTOfegmV+twdLnzBCUWKeD2oXBwA7y2dFoZV4TjKLiEEyBS8bSqmoe
	ZY8bjBjZOjERyJZmAT/Xz9WiNRpJa60ZBE1+jcHlyyfqRlqwNXYPQM5Rbeq31nsgcfUqcjMc8lo
	LhWUsQ==
X-Received: by 2002:a05:622a:90b:b0:51c:97f:83a9 with SMTP id
 d75a77b69052e-51d71546a4bmr4450771cf.1.1783962932086; Mon, 13 Jul 2026
 10:15:32 -0700 (PDT)
MIME-Version: 1.0
References: <202607091820.qbjlGhKK-lkp@intel.com> <CAJuCfpHjUij9kkD6QiWxYvsYD3iKga9rzJZWnN9vCf3bhp-dXA@mail.gmail.com>
 <CAL41Mv6UNWWdv3a2g2+tKuy+EX=8FJZSCcEAyHYyuUybYK4NMg@mail.gmail.com> <CAJuCfpEpFDUNjgsHiETmxTLyVfHdCKEk8sR2fQtixBR8JOYRoA@mail.gmail.com>
In-Reply-To: <CAJuCfpEpFDUNjgsHiETmxTLyVfHdCKEk8sR2fQtixBR8JOYRoA@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 13 Jul 2026 10:15:20 -0700
X-Gm-Features: AUfX_myZvy1Z8rlEHgfTq9Uyko36CQ_cIKDIOFd8bUwroWjufDnlrmXdmhg81mI
Message-ID: <CAJuCfpGmHY5_4G01DNodJA8byCkJUET00Lr8Ap0P6+XMV1=7jw@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new 344/369] mm/alloc_tag.c:356:58: error: implicit
 declaration of function 'compat_ptr'
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B6D22120005
X-Stat-Signature: zn6z9iboixqeyac3mda7onms8ftbe4h7
X-HE-Tag: 1783962933-644596
X-HE-Meta: U2FsdGVkX1/sLgtCqie3cOK1tUImLBuGHbvuct7Uy/WPj+P/3MYSDcowncXJdjXTKpBiGKGCn4jEUmyTHEX7fNCai4DPqmXQu/amQNSC4alH6Len01q1S2wEJCFZ5Qal1ceBIP/PeDRw78Mq9txTlyaiwOHSyKiTu+CYjbcrOZGxL+IaRJH3RDkChf8/uPyq1W0rUydfK9DuqnhUTlfl91ENq7hSJDnWKNcsaEIWpB94i/ESWZZ0cnXRCKFV/Cm74Sncf4fNfb7PuXNZ6r+P823uR8AHoP+ixv0NIDAiDU4VpJzfUgs1fxa6BTKwYwJLkmwbyiz+MDw3OOX0F7/UuVeP7ioQbCGhmGIrK1bUgqO428JSrKJ5/LL5p9J9qNlshj1ZxkiUNf7urDRr7rEE9bU2EPUr/ZHgf3aABmL4vOGKmKlKig3hnBJG7a2eL8wT7MjemML+ZpIH2YRLTczF50jbMf5oGrTcE39AIt7HYzMElxzotqPEXmehWOcqvY+D7rQcdEQ1dpN/ce0oPquA32WLn4fJo/uDDM1gHJQf6gqPaC2hKCXgR7s5TgwQ2yIS+tKOA6gzJKd6vmyem7r+D8ZTB7ACrpRoEf8CcnrolueyKSStsFiTeNfJZDi4FdObyYX/lDPeI/+QeC98CwppdANPddC+9rMuCrv0YRAaTxAXgPe/8PCk8PDEfAIHKOhwM2kNeww23tVe5w40WTuU+WbPhA4KsO2gf7lO9eL2kYclD8Ak1xmAlzuKXrX/a/lil5NZDsfISAA7UQPijXaIpbRDlGfqLPrgQQq82r86IS48g1X0YWpcRpmhQsZR2X4WHR8Wo+UWYQcI3YrzIj495uEeAq9hirIgO8S2uv/mee6+pWyIk0aEG+JFVBW6HIN74AkW8sTHE6eoVMCpGlqu74ikwCUc28cTVDJiPAq2e/3RYgHKn1UHp2YzW8Psh0/gt+0IRPhovMGlZdxVQ1U
 863Qc21u
 e7AyQ+hNa74+Xi0MS2qfEKRAyqmA3QXcU2vqlG7QctuqYbqfxWTtSkTTvciwoT9PzNRt62icf6TfSl7iXAOHAJN5q0IGj0py6+ZZb7BsvWOjRulLuEVTABpC7NLFTo9Hsco6kswfb/ncPcBPrT29pfQKQC+HYOse68OFD0lBVRIz/MflJS3WNxWZpM1C9Kyotip87u1bENOyJxZmg1oFqmPoNNeTmUMc4qMnjrKSY/7RObnLRrIshjrNkJ3qd+E4vBpesEeflXUZFsWyIGn7ORlHx7DzTg6cADC6UzEGlN5dsOUSrWpSNxxe8cTlchZ8r9iH/pMu5Dyv3nPxbopOKROs43kz6jGtlKreS2GX94oRk70kBdAg9BveIhEDdFMTzTf+ha0SALFhVuA8ZNRS71TX9h62hx3k77ZilJn8F0C91c9uGBdfuP4jUog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 10:13=E2=80=AFAM Suren Baghdasaryan <surenb@google.=
com> wrote:
>
> On Mon, Jul 13, 2026 at 9:43=E2=80=AFAM Abhishek Bapat <abhishekbapat@goo=
gle.com> wrote:
> >
> > Hi everyone,
> >
> > I can send a fixup patch for this error if needed. Could someone guide
> > me on whether I should amend the original patch-set and send a v9
> > patchset or if there's another way to handle this without sending a v9
> > patchset?
>
> I think Andrew already fixed it up (I saw an email flying by but I'll
> double-check).

Here: https://lore.kernel.org/all/20260709171454.58E851F000E9@smtp.kernel.o=
rg/

>
> >
> > Thanks,
> > Abhishek.
> >
> > On Thu, Jul 9, 2026 at 7:45=E2=80=AFAM Suren Baghdasaryan <surenb@googl=
e.com> wrote:
> > >
> > > On Thu, Jul 9, 2026 at 3:00=E2=80=AFAM kernel test robot <lkp@intel.c=
om> wrote:
> > > >
> > > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git=
 mm-new
> > > > head:   59e34180e138a293260301c139cf7ee800978533
> > > > commit: 27ace96bf8195484c9e9e1a08eb5af5a4e81f9f0 [344/369] alloc_ta=
g: add ioctl to /proc/allocinfo
> > > > config: sparc64-randconfig-001-20260709 (https://download.01.org/0d=
ay-ci/archive/20260709/202607091820.qbjlGhKK-lkp@intel.com/config)
> > > > compiler: sparc64-linux-gcc (GCC) 15.2.0
> > > > reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci=
/archive/20260709/202607091820.qbjlGhKK-lkp@intel.com/reproduce)
> > > >
> > > > If you fix the issue in a separate patch/commit (i.e. not just a ne=
w version of
> > > > the same patch/commit), kindly add following tags
> > > > | Reported-by: kernel test robot <lkp@intel.com>
> > > > | Closes: https://lore.kernel.org/oe-kbuild-all/202607091820.qbjlGh=
KK-lkp@intel.com/
> > > >
> > > > All errors (new ones prefixed by >>):
> > > >
> > > >    mm/alloc_tag.c: In function 'allocinfo_compat_ioctl':
> > > > >> mm/alloc_tag.c:356:58: error: implicit declaration of function '=
compat_ptr' [-Wimplicit-function-declaration]
> > > >      356 |         return allocinfo_ioctl(file, cmd, (unsigned long=
)compat_ptr(arg));
> > > >          |                                                         =
 ^~~~~~~~~~
> > > >
> > > >
> > > > vim +/compat_ptr +356 mm/alloc_tag.c
> > >
> > > Missing #include <linux/compat.h>
> > > After adding it the error goes away.
> > >
> > > >
> > > >    351
> > > >    352  #ifdef CONFIG_COMPAT
> > > >    353  static long allocinfo_compat_ioctl(struct file *file, unsig=
ned int cmd,
> > > >    354                                     unsigned long arg)
> > > >    355  {
> > > >  > 356          return allocinfo_ioctl(file, cmd, (unsigned long)co=
mpat_ptr(arg));
> > > >    357  }
> > > >    358  #endif
> > > >    359
> > > >
> > > > --
> > > > 0-DAY CI Kernel Test Service
> > > > https://github.com/intel/lkp-tests/wiki

