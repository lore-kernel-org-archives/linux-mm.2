Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9B41C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 11:47:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAF406B007B; Fri,  7 Aug 2026 07:47:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A60346B0088; Fri,  7 Aug 2026 07:47:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94E866B008A; Fri,  7 Aug 2026 07:47:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 61BDC6B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:47:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5CBE61A036F
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:47:11 +0000 (UTC)
X-FDA: 85074297462.15.0FCE585
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id AC449180009
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:47:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Cv+DeKgG;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786103229;
	b=l1YqrGlo72jJ0ATJccu+lIfG7wzO6wRszkIajyQJItEy0iL9dQQQCRt5bhXvk/kQi9tFYY
	i4anSllxRU5r1LiUUgnJjjgNQRIREd6HQMBSyX1sm+FC/obbcC8Vbu47uR1NTg/Nw7juwR
	6HHW+5xC4caqI+VpjEhJCzudAL1nSsA=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Cv+DeKgG;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786103229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uoRS6lteyHuaa5Tp6C6fzOIn2zZDD6ahq8EkedV4ffQ=;
	b=xPbLexjn0mkSwj20LszPCbEV0ahwUJTEWTAMdLX5/NdRQSDZr6ekZiY5SG3wO2xz82kkdW
	k9dcPE/uJEuss0/iLrChBtAnn0IWCsMn19jiZUKQgg4HVH3puT3wP7bNhSmuG0zWsl95VT
	v5I3yl6qXNe92eq0dCDXDLQm9d2lhfU=
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-8143daf89c7so33166167b3.1
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 04:47:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786103227; cv=none;
        d=google.com; s=arc-20260327;
        b=lm/ApGP8xw4m7wy0A0FZ8yQXNaMZWaRv83FvXz4ppwrCOL7dGTpKb0mhqjKkciqc6E
         JbJO1qdL0j0cpdTZk3TT6o44SaH8zaiiyFOWXNEqEkLYCJLmLsAXhW/43L5kIjRJKcg6
         dBzmcwdWLdAcdTVavISIWO89ufp/9pR+PHyF6D40ANFZM1/YLmIQ7Hj29zk/89KcZBFG
         lWkP3jd7+H8Wlvs06uyevVBM7UTDVqcm7BeLiGui9kZUBP7o4qMIIDF+KgaakAoPFeSk
         VnceBTlU8Hd/rIscq82whYI3LaQYKS59yc92vNBn67rXDsDWtqpvNBF2Mla+QNRy3F1C
         d/Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uoRS6lteyHuaa5Tp6C6fzOIn2zZDD6ahq8EkedV4ffQ=;
        fh=50Fqg4Fo9dG98Sgq/9tHjFVjcVUQdkm5zMc4AB5jUJ8=;
        b=XEa76N/mgGdvY0DHAFw8b8l+6lwo0YswZzFlFLVH5JARucAoCdkw18MSWqrzH66Hrl
         p/NfH4cLyXZjpYdTGoPBX+K3OJFIM5tf3jzkM4lCG/neTfY8SmIqnH9M4DxUeJiBNK9x
         vXOGfo2BpWdHeYXbcbgqgANiZ57q6kTO6sWJmKBeJkrpoiJMCdoSvVy/KUCGiGyhLzw+
         et0552aldN46PqHDh7kHCzuTu/0XLafFzi2/I/ninFs7o4M4hH6kmiCQ0cr68CZGSyoH
         UsvV5sSCmjpUHa+stjf05OR1STIx9HQWNjKxnk2gHu2xOnXN2fHalhR3GJndTNdvPLI+
         n+Xw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1786103227; x=1786708027; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uoRS6lteyHuaa5Tp6C6fzOIn2zZDD6ahq8EkedV4ffQ=;
        b=Cv+DeKgGthTIJHmmTB/fkdImx54FNZB/VHJsrGi0hddRtVW+QU7qZpDhtjyvaowb5B
         OUq5RhRpBz7NIRpfwHr+fB2UufOEM17vvaCy4ZMb+Azz7AxLul5Rk9UOo7WEEWIgUz8I
         CTRtOP21l8ziY4KiK0NU+894tpy2JLiq1+YomqVmWRKkHmCeHaAxma/BZLZVOIk3qCRC
         rZ7X4AsqxW4o7Lj/fVhJoeYLBfDEH1ByMtXFdoiMuO8/V6qq0XODfGnYtnLC6aYhEFNs
         Gg7p/6+GHAeALmFXFSKVbCFmRq/x9DtJn6YfHD/AI3bBaoGrb/u4Wy5sKKgNbNnSJG74
         pJDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786103227; x=1786708027;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uoRS6lteyHuaa5Tp6C6fzOIn2zZDD6ahq8EkedV4ffQ=;
        b=WqXnpdRRfiUj9a8z5jUCoPC4o88C8zObOpNH6cjhSPTai7Oehfr2kE/ujMgNOiluH4
         J/evhEBZ7y63asVTITkd9Ru0Lhrosj9UYES7wQEXDe58Pg1evgQc8oGf2k9DIO1Q7D3L
         3bpyaCxyOZkqubk75yqaq8EH7m0vHTspYK3rk7yX7F4bU5mDbAZiveJPU+9pDP5g/jmq
         1yTWcFc/lkDWONZsaMghGAarpZb46Q2ZhE58/mwHOMBwUOK68lDO7QuFjGvN1YlyekIN
         Z5gHuwAr1z+NnKc8xyY3jzOqSJX2BeTqfmKKcvP3l36H0pwzllPY8FD2QzrJWEpkuiYj
         i3PA==
X-Forwarded-Encrypted: i=1; AHgh+RpuNkGPYx1Oz/5Dlq99xRDRjQhG8+D4cIp2SbCNt6c+LqikiMgMFg2AO68MNgy8AkFuiysvg1MNRA==@kvack.org
X-Gm-Message-State: AOJu0YwZcBcO70Z0jkPx3XfFwkEVLCBtJErutg+0lk/sR69epZtulHgi
	xdZL0cpWiekbzKkT39rEIQhP40L1e3SAGCyQxvLDfixwS0jxkTwT48dUrtZ8BcBi/TDbsTJDqJe
	1eKpDx5DpW38J/P9ZNmK7v8+cseR1GK8u277npQFPgg==
X-Gm-Gg: AR+sD1266fj6IKoheCoQvXt3nEtlvO9CFU7ri9kULsKyYcY6WgcyDPHZ2Q2vxLYTup0
	iw8OR2Pw0Nu1IwKdgodhZiilv+lew/5b63eJKuvnK8FS/qS7L3sUWphxhcJ//2TAfB4m8sv9tL5
	D2yLhotIBxIWsIgsCGL5745hVE1XG+dIChb86vIsMz8qVQyIUFC/paoGKarCwh/+NVWXBbFZ/BB
	isZcM+x/Gm1TYEoorQKJiih0HucNQFSR0VzQI19uHvf8MhC8zRUEBQAxGsb9kDZ7j11+pVu+DKh
	Yhe4Shy5UWQcXeNAUWTFAoMi5o1JkX2OXffobsH1Oz0=
X-Received: by 2002:a05:690c:c0f:b0:81d:e7d2:a46d with SMTP id
 00721157ae682-8225762b659mr50005557b3.5.1786103227417; Fri, 07 Aug 2026
 04:47:07 -0700 (PDT)
MIME-Version: 1.0
References: <202608070433.x3vNSfjt-lkp@intel.com> <20260806163644.20229f5ab7cbf176edbf2613@linux-foundation.org>
In-Reply-To: <20260806163644.20229f5ab7cbf176edbf2613@linux-foundation.org>
From: Muchun Song <songmuchun@bytedance.com>
Date: Fri, 7 Aug 2026 19:46:30 +0800
X-Gm-Features: AUfX_myppgswCKizRll7wa06WzEcopq9AaGL6Phs6d-kIlQXFDfCLVlPjtCaBeQ
Message-ID: <CAMZfGtUdQqMVJGZP9MkqTcxaOQX=jmBi=BgESLVQy4ek_9pMjw@mail.gmail.com>
Subject: Re: Re: [linux-next:master 8777/13479] mm/hugetlb.c:3095:39: warning:
 array subscript 4294967295 is above array bounds of 'struct list_head[1]'
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AC449180009
X-Stat-Signature: 1kyh38y13cjj85mm9cu9o436p8tmxnjo
X-Rspam-User: 
X-HE-Tag: 1786103228-287804
X-HE-Meta: U2FsdGVkX1/Ks5/D4UzOW9jahlliuxR1EM9s8UlwLhken0Lr21uU1M3tvKgryRKvmHasBFJ2vw5kvio/v66SUAgVqccnn8bCnqdUACevkWXmyjI8ItbwozHgTOIMCHZsGFBQ7EefDFn0x3dJupgZQfDtA+2gk2Cf+G0b/55elJvFK4nHTfQYYgEVm6CC9Kd0DqSu+rewS9jdymnUDKswBsu/He8IM19e7moXHH395ACP1jfR0Vm7BX+oofp9mW+yPfHNLxRFtw/WSZjV7pJNVDIsp5W0JtQOejRm9rgy5flW1mjvM5BCSTbs68Oak9nhGBq9HAQwz3M9YDzsz7zl295TviuThugDM8FZtIndLrqvVas+h2UegO23sTG7S8xnLy2n7ak/96pUxViB2heGWaEv2EjqLAmimqQhK1C9LsqfNwEzecQszB3mabfVVdwKehLL5s7GwCaeru9QESFXSNyuxL5iPRwdmM+7LX6ZUnIEyogIE5njty9JzMmcuyottmLcxAD2izVZwEtfIjGuOcyzw26MK+g0O8fntoqN6dzz9Rq9zQD4pk/fevQ3lf+E01g0O4e3zpSH0wqw2PBKQkOWsGNwqk9wSDZjBvER3TKIe+YFqP8f0QZ1rRJhzwKL2yqkZ8fsXj0FsSEsJeA17NvYeqxfoXGazhHEvrnewwG+upoJH3n2mpOHEOJpIp4ywFd7RzUScpTZTSkkzpbSappyECEPpmrs2KtQeeoQhuywIr9EpmHxu+EPjUY3jlkhcDPkP3Ox6tDsIE0uLya5mMP16yECPNdMHhGmjgPuJcWLna41CZ506ybGBWcPY3PrWCOmXh0N/GA150FCNNOOjJK/jGMp6c2pWkqqwBQ+HO26d5SNC8h2TrN5CjbhTYmbviS42uE9a3GxWGGQzjjVvCKO+YjlvHFXbiAV/Ik+OXZMkW7ytZtwffZf6miYDq9i9M0PahPoQoq3HUPdX2c
 F5e1BzEF
 1RtWy16/rG8NG8BVUkzAoi//4W8RLu7rmmRoo4ecfUE2lFgawkavsXkQOdiZq3+m/Quoh4a4wHJ45LWd4zkWygcSQx65J9fGgn/xT98dnLS/z9rq3VTrD9EGto6HCnR5e1wdlKODYIzgclPap2GK0fATl36W2He8kqXcqE+8F93M2HP4Pw5kqcF3zKbkyBV4XyXJ5kw+y8pVKPQuwsB2ohM60tytlIOVn+zYGJYamjq9MtragDiuwnzBNuWy8r16yS6rUy+oy5Jvb/XFCqD0RyJVi6UfekIHOfL13rE2nQqt+HaKbSoXxABMRMUs38KjofJjZXYpDBxOhX1waXcz3q7hQFB5APpukRh83vwjKJiCcMSLm9j0KyseGPtVnN7C8YTjuR/7a7yMiGeENp9dkNwTvV+5eG+x58Rblh5YOh9Wzkdku/WRZ3McPDmFLSneZSVNfaYMxzvV+nj6T0NaaSk+Xwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 7, 2026 at 7:37=E2=80=AFAM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Fri, 07 Aug 2026 05:01:04 +0800 kernel test robot <lkp@intel.com> wrot=
e:
>
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next=
.git master
> > head:   ea2bff00da89d7767d677bb68470130ba96f4928
> > commit: 20549ccf4da49ff6dcb35ffc741f92aa92e07aeb [8777/13479] mm/hugetl=
b: free cross-zone bootmem gigantic pages after allocation
> > config: parisc-randconfig-002-20260807 (https://download.01.org/0day-ci=
/archive/20260807/202608070433.x3vNSfjt-lkp@intel.com/config)
> > compiler: hppa-linux-gcc (GCC) 8.5.0
>
> Such an old compiler.
>
> > reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/arc=
hive/20260807/202608070433.x3vNSfjt-lkp@intel.com/reproduce)
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new ve=
rsion of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202608070433.x3vNSfjt-l=
kp@intel.com/
> >
> > All warnings (new ones prefixed by >>):
> >
> >    mm/hugetlb.c: In function 'alloc_bootmem_huge_page':
> > >> mm/hugetlb.c:3095:39: warning: array subscript 4294967295 is above a=
rray bounds of 'struct list_head[1]' [-Warray-bounds]
> >        list_add(&m->list, &huge_boot_pages[nid_request]);
> >                            ~~~~~~~~~~~~~~~^~~~~~~~~~~~~
> >    In file included from mm/hugetlb.c:6:
> > >> include/linux/list.h:163:12: warning: array subscript -1 is below ar=
ray bounds of 'struct list_head[1]' [-Warray-bounds]
> >      new->prev =3D prev;
> >      ~~~~~~~~~~^~~~~~
>
> Well crap, that patch has been in there since June 12.

This isn't the first report. This is the second time we've had the
exact same report,
see [1]. Interestingly, the GCC versions are all the same (8.5.0), so
I think this must
be a GCC issue.

https://lore.kernel.org/all/202607010945.6lDjBFTU-lkp@intel.com/

Muchun,
Thanks.

>
> I can't reproduce it with the provided config and hppa-linux gcc-16.1.0.
>
> Muchun, I'd be inclined to pretend we never saw this.  But if you want
> to address it, please do a patch against mm-stable with
>
> Fixes: 20549ccf4da4 ("mm/hugetlb: free cross-zone bootmem gigantic pages =
after allocation")
>

