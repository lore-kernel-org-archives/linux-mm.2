Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A118C83F17
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 00:38:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3B6A6B0197; Wed, 23 Jul 2025 20:38:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEC796B0198; Wed, 23 Jul 2025 20:38:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C02106B0199; Wed, 23 Jul 2025 20:38:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC60F6B0197
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 20:38:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 20D65140107
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 00:38:11 +0000 (UTC)
X-FDA: 83697296382.24.DF10D59
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf04.hostedemail.com (Postfix) with ESMTP id 314A940003
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 00:38:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=purestorage.com header.s=google2022 header.b=f5hVuxSo;
	dmarc=pass (policy=reject) header.from=purestorage.com;
	spf=pass (imf04.hostedemail.com: domain of cachen@purestorage.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=cachen@purestorage.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753317489; a=rsa-sha256;
	cv=none;
	b=EGYA0JlcSmSLc4MoTV0W4RdzaejYfJpjh0pPo4XVjXTd8Xnsrfg3YDwxYmH6sLOZcrKMfy
	dP9GIwGY4z/qS4lil27qGR2r4jPPkOgQQoQHQQ29I7yx8ziWFVR1EScZN/pbbHxvaWriQt
	Xgs8dyIuBTIbKpsXUpYTb6q2ijlmqps=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=purestorage.com header.s=google2022 header.b=f5hVuxSo;
	dmarc=pass (policy=reject) header.from=purestorage.com;
	spf=pass (imf04.hostedemail.com: domain of cachen@purestorage.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=cachen@purestorage.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753317489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kVzlr0W1TivM5rykoDGW/szIU5hwSlOTrrmV8HajOPk=;
	b=zyUl/CFVXRUi6VjmQgrXgK9ErWJfdrGpIAVkGnAtMR8TTdtECYvbqfapSFsPdjVE+ivjir
	d44o9WSlS4BA/Z65tqY0ZTN+QB3k3co2W8oJOjoCpH0xmsX7yvkC7B0YZoXlTHH2KXAo/E
	3FyTrvfDNJNAL4sibgy8BqQHixPAxYg=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-313067339e9so67827a91.2
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 17:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1753317488; x=1753922288; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kVzlr0W1TivM5rykoDGW/szIU5hwSlOTrrmV8HajOPk=;
        b=f5hVuxSoi8WToPt0DMXDgyKG4Fh+0fK8L107D3hNvgfb7oKROjpaxkp4qJZBMZEvTH
         PnfSo2sG0eHAMpnBEZeEbb/K8VEoN+yWygV1qJ4/QpoHYfXccMBB9Gn+GG3EpqxvhQnx
         b8QT2dvYtg2d++uTpsqrGVqnj9DBy5v7dV/0VlFEhd8TupM4uHn+6JTJIyLyoFfby2LD
         GqS8H7St98goUVh/VbJIGDdA9UBMzjh0Dx1CM0bSGZAYY12545lloAGgBQqjYQHTpp53
         8Jae2v8edDmpovl+4uYS0Ugs68c7J9kX5HcJU68pzxbhFgIn+a9KXOdaqS4SbxLGL4ab
         eJ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753317488; x=1753922288;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kVzlr0W1TivM5rykoDGW/szIU5hwSlOTrrmV8HajOPk=;
        b=Y40OL4x8JaA7lh5ZXZ8PdPgVJK+nD5kxrh9cHqAeapgHKTw0IFvvJA4FNPbknP0wON
         wOiwHIPL+DRHJPrSU/FxrbeBPvKbx3yBE5tVkmWTuLvzLP7/VUO2k4jhp/KWjmQQFpyj
         mJwAzDB6jqYLg9FGKzTYcCf0ZnH4/Ggc/mAFUIhuzHRQ3k04VSuu93GfKN+AVGpRgvpZ
         7JafF7cO3CaA48+l3VynHx897lrsmeqfjnF95+P+SWM9hXdS9SY8tt+cd1yOshjAUTu+
         YnrYZPL0/+f0pPlPOMz4r0c2URiyBOx2Ws5cXq2f9BZ3QevOR6+L9cppxpWaeh7hZGPA
         hHVQ==
X-Forwarded-Encrypted: i=1; AJvYcCUp2VRek7PkfwRyXd10SKDGrL4xfMwSpgKv8BGZt+8lYYSVyiRnBRMmTVd9PR4m1G1cohuAcaCvFw==@kvack.org
X-Gm-Message-State: AOJu0YyK8quR8R1v0kEOURppiZtJi7gVAHgx2wVxZgIqc7N9nUN654oK
	TS0pK76F8uA8jeeAdlj342BKlZ+1tnTddrr1/Onkbktu/NOUAG5rj5eBFRi2tSASdXMd9TUgFEa
	0pwbHdebYvewBs1jRq8MDJkahwyabRWXiyEKanIIhcw==
X-Gm-Gg: ASbGncvC1/jDww6vcMVYDflbUq4kJQ2jjyputlTjBgdMTotC3ptDkBfJCafWD1Qq561
	TCsdFH53od/9settt+JdZW4U+Az5frtfma/aHIUiUNxBquGtcTzKlswYGEYe39A9wdfbVYlR21q
	Ji6hnRtSrdwmaj6/GY8MnZNtjs8acuK8KPWcpZ4GyhNW7cJWwxjNX04jdW2vBQj8O/j76hrzNQR
	7N4ChfU0QyMiqXASu8=
X-Google-Smtp-Source: AGHT+IH4VTNJrurz6Qk0XlK+5MoFyD1kgLcpcng5VkI23KoPcgTNi8H+hvLg2MhXAytRFMo4TVGnDbgexwbZuZL+CIo=
X-Received: by 2002:a17:90b:4b52:b0:311:c5d9:2c8b with SMTP id
 98e67ed59e1d1-31e5082c398mr3391035a91.5.1753317487789; Wed, 23 Jul 2025
 17:38:07 -0700 (PDT)
MIME-Version: 1.0
References: <20250711002322.1303421-1-cachen@purestorage.com>
 <CALCePG3a6wG+3Nu7-JHha+LMtyRRNF3sXp13sS-=Xv1pvsX09Q@mail.gmail.com> <2272d95.4512.197f7b1354f.Coremail.00107082@163.com>
In-Reply-To: <2272d95.4512.197f7b1354f.Coremail.00107082@163.com>
From: Casey Chen <cachen@purestorage.com>
Date: Wed, 23 Jul 2025 17:37:56 -0700
X-Gm-Features: Ac12FXz6YP-uwsEzBgKW14HU9FxDMDgMIWxUuN9SFGhPeADgC7PX8sOXbrv3-gw
Message-ID: <CALCePG0Q8vAEzP+5ASzY-ytnN_eph8F=-F3MQya5MaYcwMNMBg@mail.gmail.com>
Subject: Re: [PATCH v3] alloc_tag: add per-NUMA node stats
To: David Wang <00107082@163.com>
Cc: akpm@linux-foundation.org, surenb@google.com, kent.overstreet@linux.dev, 
	corbet@lwn.net, dennis@kernel.org, tj@kernel.org, cl@gentwo.org, 
	vbabka@suse.cz, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, rientjes@google.com, roman.gushchin@linux.dev, 
	harry.yoo@oracle.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, yzhong@purestorage.com, souravpanda@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 314A940003
X-Stat-Signature: b1ktbfmsmrfdd5adkbcxpmo48wbxdxb7
X-Rspam-User: 
X-HE-Tag: 1753317488-249818
X-HE-Meta: U2FsdGVkX19YD4X/j3/9LoBtLKUYyNAXlT3Zdp2pXOi8um1BwtI8QELZn5tn0VahcTS/8AB1kIU/uTlxsI9m8eKxr2fMsGuxz0c84mR2B6sIbjuxS5vb41136MPQ3s2YNOmrKDrTMQG76EgFncJjCX+f2HjZvoosFOOCXIQkSg8t2xhMvZikzkJAdO/d3ZgdIMdrvF4ynwjPDHsWvnY8Fomzoi4ahO1t4jvy1HC2WYAkvy1+1HatbgFm2Z/MtoWBcui1qAWJIwXdc/TzbACG/IUHREJW9kZdgePQ4mWLGp1dM5dMERQ1sJ4md2g+JtEhFLwM+d9X+9TiwkMXBUkhEqPTxkSK7O9fnN93VLGg9Wbty8KuAcQ2xHSrRdW134MK0FnzKR0PyfWH8DT/sitFnldS+lpel8PsSegfmO6ftihNj5VOKXT8WI2RNgelNwSZd+0rFbWqOqBbLnwMZOCfzTNxkvXcz5aIRb8skntDeW8LwjDHiE4oREV1I1pDW66p8vfFsxXP0GYfuR5GAIAH1M+bHKD2XSm2lREROdaF9XOO74Z98tG4rWAkyBSD/TGL6D1Fhx9uwBi3wB7mcwl4f3S8TkFffXj49Dq7rRi4wx1Sze3fFdrcx2FMf5kTOcaJ6o6+lLJAwnBp43UKmerve/Ih28BMvqVytNZted8QEJVsTDvs4y07CHlsy1RD0k+81BhlDETMUnKom9jplKMjplRPGWqoplWYQxP3HpZVVdXKc0qDjApSlaqLvFDQN/SWSYA9ONCws7KGtIkHHQEoetIc/S02KGQRnPvwdbHBTpLUT8+d7txRHujvldEVMwHEiWN07QVqfupIWtX136eYjaPIXVNg1047mIeL+btXauEO5dcYx6L4pMC4cPlmXITw+TcDDLQ9QD8o2z6DAenRn84arYGOzUHR7a8Ls4bjyiyAGY1ORO7QjVoC0ui9pRvNflaxh5RyWIf0wB1lwhR
 eklGDFY3
 2RVjPlRabi8KV8xY+qcVaP338VpVCF1pSMAh4C3Oraj4nYZBgsGSyM726FtFt62N3E98TsT+nVA4TJMCWJkmuKNQdbwnzq3cCTF2Z/+Em7bcQO83lJFpYnXzGyc6zZbngy9b4qGuxIMhrImyrCFe3/r3ivRp8BJedfhx206VNJkR1U+fdCksIfdHYmoO75U/afSzTm0eIdPBTsp/2K+zmx5jwlnCsouHN+XmMUjaNaVN6qcDSKusmo1+DQ+7IBBkmsEXr0/4V8nQqqnh0tveiTFdAMwwKXL/MOFkPcXfA4+s6ICvCO5e5BTIv9+pEniAke8l6kAglrw5c6+VB8y1vUPpCFHCYVWUxTkPBXjGTNwxU4WEDY5jrv9KhGpo7p3BsBqesRNAPYQoKbDnCp80WIqipRLTjjKq1A6K/gs8bUbPginsk+V2JA3pmNPl7DMP39tri1myWayidETLeDkb97n9FWyvv5YEamwNm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks David.
The calling site doesn't detect NUMA imbalance by itself. We know its
imbalance from per-NUMA stats. I would think a software developer
makes global memory scheme based on information provided by per-NUMA
stats. For example, the system has several major consumers of memory,
most of them request memory from NUMA node 0, leading to imbalance. By
detecting the imbalance, we let some of them request memory from NUMA
node 1, by hard-coding.

"What if the numa nodes usage are almost balanced globally, but
strangely unbalance locally for some calling site."
I didn't see such an issue so I have no idea about this.

I wonder if Sourav Panda or David Rientjes could provide us with some
examples. Thanks

On Thu, Jul 10, 2025 at 9:16=E2=80=AFPM David Wang <00107082@163.com> wrote=
:
>
>
> At 2025-07-11 08:42:05, "Casey Chen" <cachen@purestorage.com> wrote:
> >Hi All,
> >
> >Thanks for reviewing my previous patches. I am replying some comments
> >in our previous discussion
> >https://lore.kernel.org/all/CAJuCfpHhSUhxer-6MP3503w6520YLfgBTGp7Q9Qm9kg=
N4TNsfw@mail.gmail.com/T/#u
> >
> >Most people care about the motivations and usages of this feature.
> >Internally, we used to have systems having asymmetric memory to NUMA
> >nodes. Node 0 uses a lot of memory but node 1 is pretty empty.
> >Requests to allocate memory on node 0 always fail. With this patch, we
> >can find the imbalance and optimize the memory usage. Also, David
> >Rientjes and Sourav Panda provide their scenarios in which this patch
> >would be very useful. It is easy to turn on an off so I think it is
> >nice to have, enabling more scenarios in the future.
> >
> >Andrew / Kent,
> >* I agree with Kent on using for_each_possible_cpu rather than
> >for_each_online_cpu, considering CPU online/offline.
> >* When failing to allocate counters for in-kernel alloc_tag, panic()
> >is better than WARN(), eventually the kernel would panic at invalid
> >memory access.
> >* percpu stats would bloat data structures quite a bit.
> >
> >David Wang,
> >I don't really understand what is 'granularity of calling sites'. If
> >NUMA imbalance is found, the calling site could request memory
> >allocation from different nodes. Other factors can affect NUMA
> >balance, those information can be implemented in a different patch.
>
> I think my concern mostly due to my lack of knowledge and experience of N=
UMA,
> but I still wondering what action to take when " the calling site could r=
equest memory
> allocation from different nodes", does the calling site needs to detect n=
uma unbalance at runtime
>  or it should change to hard coded numa node?
>
> By 'granularity of calling sites', i meant to emphasize that information =
is local per calling site,
> not global.  What if the numa nodes usage are almost balanced globally, b=
ut strangely unbalance locally for some calling site.
>
> "what adjustment the calling site would make to solve numa unbalance" is =
the *big* question to me
>
> Thanks
> David
>
> >
> >Thanks,
> >Casey
> >

