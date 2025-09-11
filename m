Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1410CCAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 18:51:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 777A28E0003; Thu, 11 Sep 2025 14:51:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74F7B8E0001; Thu, 11 Sep 2025 14:51:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6653B8E0003; Thu, 11 Sep 2025 14:51:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 527F08E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 14:51:50 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B9BB91A0559
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 18:51:49 +0000 (UTC)
X-FDA: 83877863538.07.629E0A5
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf21.hostedemail.com (Postfix) with ESMTP id BF9591C000A
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 18:51:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Lb0nuMPF;
	spf=pass (imf21.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757616707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iSXSLjz9xxQBXrBSw3AK6oe7rPYSJGQAvD1J01P1Xw0=;
	b=hiZpStWwHS8+0LPHV+IOZ9cDGXsRQXqUlYEMFsempTY1q58UIfXzpmmDZNIKkz9OfVykPy
	8omNkzeYmDCUIXyJhow58ieYtd5G5V0n/ChhOl+FaSfsmolOgrwWcPdXSVV2JnC2m+zko4
	dxMwSyMrb8IUiOi/QJtB+fm1EYnXb3Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Lb0nuMPF;
	spf=pass (imf21.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757616707; a=rsa-sha256;
	cv=none;
	b=zBxboXbL0Fm24xQwZKtiPHI3o9L5QkIVd4kYqgqRKuDrMhrlPdvoetX9cWwmTWysCrmaU+
	YMql/O/SI9RAFz9dDq652tQRG1eMNTVrQiQqdRcINkWMe01NpFGGufkVDlK15V7EHdcLbg
	HnM2CTmpBvvFgLt/d8W3ZBEfKyWdZ10=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-45ddc7d5731so7916905e9.1
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757616706; x=1758221506; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iSXSLjz9xxQBXrBSw3AK6oe7rPYSJGQAvD1J01P1Xw0=;
        b=Lb0nuMPF79k9KfV+pmYrA0a1extrHxBLfalazr6kTczP1iNlMq6vZ/t+vBQBR/0SIY
         1E2dVPJHhV+gr3eXsi48ZN5OKdUMuBsgHJl+IBbmuJqaSYKqcq+NsTIY1wYga7Ym89Gh
         5AI7d44jyWLHMogbKEDVqpkqbsjlT/9uaaU5/GM2+yuMLjSyp7dKBmO79Ru31Lz480bC
         Q7xdOGMS2DQjnGoSsJFFbTeubw2ou8lgrMvhdINzNwMe7hE7emL1wqEYjT9fWm2VcYb6
         9qebXPOO4pqhgUwdP7tGML+ldrVIC+8kiSdK4yAw5yzE4aXVuJrOI7fBtemPA2hARdvx
         gpbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757616706; x=1758221506;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iSXSLjz9xxQBXrBSw3AK6oe7rPYSJGQAvD1J01P1Xw0=;
        b=dJhkMz+/FnbNNrfk7diZruGVwIN/UpPt67WSOaR74BzxCexJcdh2+7QsxgPHLgwJ5Y
         GF6IBNpeUmfeMKK8qqZQpPubDg1GMCwULfgtBRydb5q+i3xw8cAfY2x7lNGuHOXf3pG8
         V093Bk8Zpw176hriiMEUeiDH0t75HYEJ3nQO+0AGmllKLvHXYttPoQRgmWk0sqZpA/8Q
         n/o/TO+TNkbaWd6xBoGd4+OWlREjTCtpYSkbzqwGshhrW9ax//Ni48fHRUUtXkFRGiDf
         c+B9uwu5ulJQNnSoIme0y0Dw6n6bwHqsDiUzeV0vttHo4r7FxpLlZ2wxA6axgsbd7vf2
         7sCg==
X-Forwarded-Encrypted: i=1; AJvYcCU+ii+St2rAkJsWNX5CAB/GebMKZpJexTkgIpa3QT10Ka7imBmfFv3b+reHsH+j2mq12NARlAPj3g==@kvack.org
X-Gm-Message-State: AOJu0YxaywMJqJEMwYXQ6w9snStDR0ikh5fiHLvvfVjYsKgQyGRNEBHw
	cl9T9ZRVRfj4TOr5kXFMYE2XWd8OTkllkNtBZJq4DxLs/gt4DcoRN1jo
X-Gm-Gg: ASbGncudCNFAu+lKFaLWH9g7ATKuekl5GwrkDmjPPMsaekOXx8BoTWeYysHflQpukWG
	s4rQa3wBbul+A4GQq2FQtiDAY9GrLGSXvgqUecTO3/2HngoCfh2wYIBpaY7y77pjArCX0p4XY1m
	MUP+gBu3/e73OaNV24VGM8c0up3ondBvfKAHgmsRcFQ3ChHbq3ELppnQXkTPqUyhrtzzNNhuPkP
	6IwrUfI7tjipbjQr8uLqgPNPeOB6dpZiOSn85KRmrNEk4W3WIgWngBlvSDLjCbf9/TzVbqD/lZa
	IWHx9X6W7R23yDSRKHoaPAMPecZN0Clj8an5ulb6wonM6kerQGPflnqjxXn1WaaWDpBDo9MYUW7
	HFb5Hh3u4Fq9aGgj+q83T9VojSKgjwQKpq/y9OjM=
X-Google-Smtp-Source: AGHT+IG721ygNIQdIEEEEkJ+eIYPvjiP+uDfNNRip9ilX+h9GXA46usxqABET0AECdsMFBw5Cwgg8g==
X-Received: by 2002:a05:600c:314e:b0:459:d451:3364 with SMTP id 5b1f17b1804b1-45f2121ab89mr5163355e9.24.1757616705792;
        Thu, 11 Sep 2025 11:51:45 -0700 (PDT)
Received: from devbig569.cln6.facebook.com ([2a03:2880:31ff:49::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e015bf73csm18359595e9.11.2025.09.11.11.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 11:51:45 -0700 (PDT)
Date: Thu, 11 Sep 2025 11:51:43 -0700
From: Yueyang Pan <pyyjason@gmail.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: David Wang <00107082@163.com>, Usama Arif <usamaarif642@gmail.com>,
	akpm@linux-foundation.org, kent.overstreet@linux.dev,
	vbabka@suse.cz, hannes@cmpxchg.org, rientjes@google.com,
	roman.gushchin@linux.dev, harry.yoo@oracle.com,
	shakeel.butt@linux.dev, pasha.tatashin@soleen.com,
	souravpanda@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
Message-ID: <aMMaP6XgGfX3nVVE@devbig569.cln6.facebook.com>
References: <20250909234942.1104356-1-surenb@google.com>
 <20cafc1c.a658.199394de44e.Coremail.00107082@163.com>
 <aMLvCCZbmpSE/aql@devbig569.cln6.facebook.com>
 <902f5f32-2f03-4230-aab0-a886fd8e4793@gmail.com>
 <CAJuCfpGezf06eR7WnzizpwTaxZ5Rm8jbeW4y87zcr6LZuJ9MZA@mail.gmail.com>
 <aMMF8elYvlPoOF+J@devbig569.cln6.facebook.com>
 <613698f0.a994.19939d88e1c.Coremail.00107082@163.com>
 <CAJuCfpE=0jpana5qryqwPsuoj_8tCEMWFMcEBTB5-9Lyu_j-Tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpE=0jpana5qryqwPsuoj_8tCEMWFMcEBTB5-9Lyu_j-Tw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BF9591C000A
X-Stat-Signature: 7j6p94iogudf6rx594y9j5h4hmsks3r4
X-HE-Tag: 1757616707-658440
X-HE-Meta: U2FsdGVkX19KcofbVuFVk6LE72gMltrpD9S9+ga+qUrb+H/AA2fUVJBCimWmUz/qCcNCe8y0HcB0NZdNUeEXZelBwR7p5OoXgjxm6AjoEQFbbm0NORGrE8SwbnXaStLFLk6Bnw/7tycgTwOmF+HimxKHNGAcbPUONqpswn1AZSUgt51b/G4Z9IZ55nQVlMACnYZTt1757XnoGAt0VMOqKOvES+DZhppVs/43KLBwepWJEULNAMYgHBeTBf66PdzsIyzg/ObI/EPXVd+u7DWFhNDX1pFAKPElvUrrNQInZDvzBly2Hpk9huoWwHmVMRPwG8/V340Sc6QQx0UfjVMzwpi8WZMOUWGrXSMkCQeCGYJ3pyA+q3VmfcgbIIiN1maE/AITypvcgjynLAxzb2Me2lP9ZvF6kRbR0Tne0mGx7f3NVhv5P/a2LOdrkcMplaqElNOAQzvdjiMFwVIkF0Cvqzyl88bkyAV7PJwvX4wnbQ6FjxKAYGUThOevKXd7rUkCJo9CbnJdm6iKdKwsLP89+uh/USd7ljkQx0eh75p+cQPmsm1Gi/mrxT05X79a/292QMbewyNRfSQ8d1jjeimOHaL4zfoeE4gdyc0VHOBDIAaBHuSceZdSGitL6cyhL7ApBHPodz36SDkOgq0v191XElu+/t9dooDeCfF6ArRAT4xUVszeTE5NnF4S8vT/RrIWXNU+cc5gP3cfuMaDDwQVRfbnjNQndwBdTIE4GqPevgokvKYlwhb5E+SjGUPWIkDBL/YdCYadxFLwLeMUTIfKvJld6kLltPvYi8Pz+ZxqgYu96qL9Mj4d+mEYr/ekvJJ//ITUNnwL8ANmoxUwnb+FNzaz6aWz2IkuUYc3CYYbqEXoQ5dw7gNOzAJwDVdnJl6+UeiP75KVCC61SPnucx2pwC8ju0ohG223PTRfxY8x82SOopgZsmnYiYwoMGQcrhxnu3KAn7Y6aDza12RJmWp
 KYswgatw
 d8YoL1eCNXHi10WTXbknytU4bz6dPT290nHoG1vorclt8ERtdDFpfgVkosh2Axajc/lHcVAJp5rvj0f5+jJlXMrVDMOaF60Co0+/2wBp2i4ve3sWuyZNk0U1HkzmaehnUjrMrjFvKPG+LW3ImVcKcfxBnXBx1q5SDgnnsVhh1fFE52JCrwYEbJW3pJq1kyjM/lPBHjl4LFApatxf+sE67wfVRHcuwTG+Lio7YJ9aE9I07RhK8jIxdniilWr33agT0MZWnCynK2T60JRE8vlOd55vNjQQAjLefK5mIv2vujtDpCWA6g1Ak+ruXGf4nwLW4hLVCUMFTuNsX+lKFUNDn04WjwFJS3yfOxlb23gQ1lqEC6rPecvl60fgI0JMtnq2ndGouhf2NxfUvAdaUf5o+sX9aeHFZyiLUdpwmAabs9WYcM4hYubbfTpA/NIKTMow6A2yAphuqdtVzIHDFQTlS3IoQbWlkEycaJXHDoc8HYH1ddE45fU/8Pcg+knln/c1vJVZZAP51H7T90ljSbkfsRarrEFY9K8vZ9PHaWe+WAxtCE3AgbOfKA52oOYqx1va6B79Y0qo+NOg7mLizZbV79kPIhUpr5lfonlPQHfDl3CD8nzBQPVU9k85ECrqg3Sc3q15X0rCyIJId9wU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 11:13:58AM -0700, Suren Baghdasaryan wrote:
> On Thu, Sep 11, 2025 at 10:35 AM David Wang <00107082@163.com> wrote:
> >
> >
> > At 2025-09-12 01:25:05, "Yueyang Pan" <pyyjason@gmail.com> wrote:
> > >On Thu, Sep 11, 2025 at 09:18:29AM -0700, Suren Baghdasaryan wrote:
> > >> On Thu, Sep 11, 2025 at 9:00 AM Usama Arif <usamaarif642@gmail.com> wrote:
> > >> >
> > >> >
> > >> >
> > >> > On 11/09/2025 16:47, Yueyang Pan wrote:
> > >> > > On Thu, Sep 11, 2025 at 11:03:50PM +0800, David Wang wrote:
> > >> > >>
> > >> > >> At 2025-09-10 07:49:42, "Suren Baghdasaryan" <surenb@google.com> wrote:
> > >> > >>> While rare, memory allocation profiling can contain inaccurate counters
> > >> > >>> if slab object extension vector allocation fails. That allocation might
> > >> > >>> succeed later but prior to that, slab allocations that would have used
> > >> > >>> that object extension vector will not be accounted for. To indicate
> > >> > >>> incorrect counters, mark them with an asterisk in the /proc/allocinfo
> > >> > >>> output.
> > >> > >>> Bump up /proc/allocinfo version to reflect change in the file format.
> > >> > >>>
> > >> > >>> Example output with invalid counters:
> > >> > >>> allocinfo - version: 2.0
> > >> > >>>           0        0 arch/x86/kernel/kdebugfs.c:105 func:create_setup_data_nodes
> > >> > >>>           0        0 arch/x86/kernel/alternative.c:2090 func:alternatives_smp_module_add
> > >> > >>>          0*       0* arch/x86/kernel/alternative.c:127 func:__its_alloc
> > >> > >>>           0        0 arch/x86/kernel/fpu/regset.c:160 func:xstateregs_set
> > >> > >>>           0        0 arch/x86/kernel/fpu/xstate.c:1590 func:fpstate_realloc
> > >> > >>>           0        0 arch/x86/kernel/cpu/aperfmperf.c:379 func:arch_enable_hybrid_capacity_scale
> > >> > >>>           0        0 arch/x86/kernel/cpu/amd_cache_disable.c:258 func:init_amd_l3_attrs
> > >> > >>>      49152*      48* arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create
> > >> > >>>       32768        1 arch/x86/kernel/cpu/mce/genpool.c:132 func:mce_gen_pool_create
> > >> > >>>           0        0 arch/x86/kernel/cpu/mce/amd.c:1341 func:mce_threshold_create_device
> > >> > >>>
> > >> > >>
> > >> > >> Hi,
> > >> > >> The changes may  break some client tools, mine included....
> > >> > >> I don't mind adjusting my tools, but still
> > >> > >> Is it acceptable  to change
> > >> > >>       49152*      48* arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create
> > >> > >> to
> > >> > >>       +49152      +48 arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create*
> > >> > >>
> > >> > >> The '+' sign make it still standout when view from a terminal, and client tools, not all of them though, might not need any changes.
> > >> > >> And when client want to filter out inaccurate data items, it could be done by checking the tailing '*" of func name.
> > >> > >
> > >> > > I agree with David on this point. We already have monitoring tool built on top
> > >> > > of this output across meta fleet. Ideally we would like to keep the format of
> > >> > > of size and calls the same, even for future version, because adding a * will
> > >> > > change the format from int to str, which leads to change over the regex parser
> > >> > > many places.
> > >> > >
> > >> > > I think simply adding * to the end of function name or filename is sufficient
> > >> > > as they are already str.
> > >> > >
> > >> >
> > >> > Instead of:
> > >> >
> > >> > 49152*      48* arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create
> > >> >
> > >> > Could we do something like:
> > >> >
> > >> > 49152      48 arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create(inaccurate)
> > >>
> > >> If there is a postprocessing then this would break sometimes later
> > >> when the function name is parsed, right? So IMO that just postpones
> > >> the breakage.
> > >>
> > >> >
> > >> > This should hopefully not require any changes to the tools that are consuming this file.
> > >> > I think it might be better to use "(inaccurate)" (without any space after function name) or
> > >> > some other text instead of "+" or "*" to prevent breaking such tools. I dont think we need
> > >> > to even increment allocinfo version number as well then?
> > >>
> > >> I'm wondering if we add a new column at the end like this:
> > >>
> > >> 49152      48 arch/x86/kernel/cpu/mce/core.c:2709
> > >> func:mce_device_create [inaccurate]
> > >>
> > >> would that break the parsing tools?
> > >> Well-designed parsers usually throw away additional fields which they
> > >> don't know how to parse. WDYT?
> > >>
> > >
> > >It would break the parse now as we count the number of string to decide if
> > >there is an optional module name or not. I don't think it is a big
> > >deal to fix though.
> 
> Uh, right. We do have module name as an optional field...
> 
> >
> > The inconsistent of module name is really inconvenient for parsing.....
> > Could we make changes to make it consistent, something like:
> >
> > diff --git a/lib/codetag.c b/lib/codetag.c
> > index 545911cebd25..b8a4595adc95 100644
> > --- a/lib/codetag.c
> > +++ b/lib/codetag.c
> > @@ -124,7 +124,7 @@ void codetag_to_text(struct seq_buf *out, struct codetag *ct)
> >                                ct->filename, ct->lineno,
> >                                ct->modname, ct->function);
> >         else
> > -               seq_buf_printf(out, "%s:%u func:%s",
> > +               seq_buf_printf(out, "%s:%u [kernel] func:%s",
> 
> Yeah, until someone creates a module called "kernel" :)
> We could keep the name empty like this:
> 
> +               seq_buf_printf(out, "%s:%u [] func:%s",
> 
> but I'm not sure that's the best solution.
> 

I guess the best option would be to decide how the format can evolve 
in the future with some rules in comment or doc. But I am sure who 
will decide the rules...

> If we are really concerned about parsers, I could add an ioctl
> interface to query the counters which are inaccurate. Would that be
> better?

I think this would be nice as we just need to add functionality on 
top of the parser when we do need it. I guess most of the time we don't 
care about that temporary imprecision.

> 
> BTW, I have other ideas for ioctls, like filtering-out 0-sized
> allocations and such.

You mean using ioctl to control if we only print out the non zero 
ones?

> 
> >                                ct->filename, ct->lineno, ct->function);
> >  }
> >
> >
> >
> >
> > >
> > >I think one more important thing is probably to reach a consensus on
> > >what format can be changed in the future, for example say, we can
> > >keep adding columns but not change the format the type of one column.
> > >With such consensus in mind, it will be easier to design the parser.
> > >And I guess many companies will build parser upon this info for fleet-
> > >wise collection.
> > >
> > >> >
> > >> > >>
> > >> > >> (There would be some corner cases, for example, the '+' sign may not needed when the value reach a negative value if some underflow bug happened)
> > >> > >>
> > >> > >>
> > >> > >> Thanks
> > >> > >> David.
> > >> > >>
> > >> > >>
> > >> > >>> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> > >> > >>> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > >> > >>> ---
> > >> > >>
> > >> > >
> > >> > > Thanks
> > >> > > Pan
> > >> >
> > >
> > >Thanks
> > >Pan

Thanks
Pan

