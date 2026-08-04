Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77241C561E6
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 19:59:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9CB36B009D; Tue,  4 Aug 2026 15:59:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C74AA6B00A0; Tue,  4 Aug 2026 15:59:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B63F96B00A3; Tue,  4 Aug 2026 15:59:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 82A586B009D
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:59:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 08FF6401DF
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:59:26 +0000 (UTC)
X-FDA: 85064651532.02.4D0BE21
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id E4A7020005
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:59:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=J2Gua2pl;
	spf=pass (imf13.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785873563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=12t/KpEWJ9OZ/EDgQulX30VA8XxZwBhkHz7JGZZPgHc=;
	b=PjVOjod8AsQMvF+dtALgNFFE3P0IOIrDLQVmDXVWx1Y8FlNjsvTO4Abeq7eorN/PF68fa2
	etXJudthZIPQOHhtqIYQAonaFb01XZFUOF7jqpO4Viu0zrZ/U1rK523OYVHUkzKWmYl7oK
	S0gwzSaTSSd+yNdIsKX/lobbxr9anuM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785873563;
	b=yr1IikUP3gWsfmHPt8tPsB+vN+6UoPbUkrPXZBFY9btLTRnCtExsFIRJ5CkGkPQkPj3jIU
	VFjQG9P/N5Z+gdqtaRwOMvAlMcSBqtbrC6bIjPRkqeetbmFVBk9LClC2h8/dbr+9qO6Fzd
	1Dad2Cs5jW8QU6laSuxxWb/v4nscqng=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=J2Gua2pl;
	spf=pass (imf13.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cab97c86bdso3425ad.1
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 12:59:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785873563; cv=none;
        d=google.com; s=arc-20260327;
        b=WcyQ/NW4yCf9FiTQ0WPiz7mi4oFkoBoKA32xuriWvWWIuVHMnuKC48Xaxq0UM0ZtDW
         FHBWNZ1y9uQG5GxRcg0AwWs8T/IrZks326WSUTSyCOt41q9N1MHGP3riPHeQjt0vxX3C
         0vYmz1IccUeOdXn+AbiFxfzJD+PYIJ9UmwHf34wQ/cNQAJnTrZ2NfHAMN/x0V7PGfMZ1
         uZksnTnfYo4gnzFklSPH9rtMQYEBwz5OTVIg1gbr2CzdKUHVH8oWEgtRKuFTpfI4cB3Y
         RELKh51w8HTrmT+Y5ZmUjQZ2iEiPOcjqNyE/n6VL4fBgMmrvoRDyg8+BuVzsvoL/dvpd
         AJtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=12t/KpEWJ9OZ/EDgQulX30VA8XxZwBhkHz7JGZZPgHc=;
        fh=AhOVF0j0pHKUX/G8A9BY3JLb28OLWo4hVd2p7bHoaow=;
        b=Nfj0A0UIod5EU2i5d8+Eyf4PVWjsJZZ0rOtTYRDRjWAvXG+zC8/XS6X/aRTOw3/ChR
         +gqFx27icO6GtJfgjUObZlLueineiBnESssbXZh4/Iw04AhmWwCOPI3z8stGEM2yQ1Jv
         TD2Jdn1FhBksOF3pwYOHKNHD/fKvyrnm16P0037Lhr4FyeqnSEuqDNR+cng3gLF0EW9B
         JQvLbarGFfaOTHozwyRuKxLoPuYg1ur6JB5K7hwxz7EFeEnDT3PMi02YpaznDR856eQT
         92aJhlB7jxwrALvtoRC7v0ROfvMUKm5e4zFUXmGfeE5d3ZIcq0hJ+QHBaK8gp2j+QOYg
         +MKA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785873563; x=1786478363; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=12t/KpEWJ9OZ/EDgQulX30VA8XxZwBhkHz7JGZZPgHc=;
        b=J2Gua2plokKyZZHOFnZiBewx4aFzWIIfY8THrjmIUh4iXkLkwYtrJKRJbNfaoUAcUZ
         o3SmX3mZ9LoPkWFV9zfqpLoqcrhnDLeJcWXipk0TVCmiM35Xa7xZFFAWRZ2motETq+OB
         vrNlYRm+8Yzh0vc9vuxp0MXCdvh5Iyiok7vZQ3rj8lEIRvqVLwVB1ClinIbQ6qGM0FhM
         MpX4SecrB0JyYxOQ9RMfwEHinU62AJK4pqv3/9VgWw7CvcEt7G8KeHg1Cp8r76p4th1h
         wPHEadc0DAQegF/ioK0iRQJReOZkWwd4l3vHyA//1mFwMYj/w0Rk14wiU8gChgUcSvOD
         kZJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785873563; x=1786478363;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=12t/KpEWJ9OZ/EDgQulX30VA8XxZwBhkHz7JGZZPgHc=;
        b=CqW7opKlOUJOiulHXhjRTqArCglu4fbtxJZqCzjQ0rLI/tLleKyyfvq7PTYAacnAKf
         IIzo/t7i4jrLtkRPLiPsMawua8WvB0UHcj9t53h8EWc0JVg9Kb7BiiiSytQ4nnlhFoaC
         lWRVVtQ0MVEv6emA5CwwqLdyO1R0kaCew2j5nMqBGxIN9ulrhZyFljvc0acdI1PiTBRC
         falQoLEzKLZZOBMSV70XWNDYGWa8ELKOcDmD9lWxXqCYJMHOrucHbOpjnA12V1m0vQsF
         GpnLNWM3NFZVPh0j+EaD4IP/vCcF2wsIAG+cA+IKNw7vuya+YKgzpe3mfe8UjKXi7XKl
         pa7Q==
X-Forwarded-Encrypted: i=1; AHgh+Ro3TWYODaLNGQSXvCJf3Ct2JsKHIyXYK2tfjJmEbAV6ys2uG8Gh3xHCgTXtaVeMMo7j0B9ekI7b0Q==@kvack.org
X-Gm-Message-State: AOJu0YzlqJVz/m49WQUGjpL2WFmbYORknR/mOs529PgeE+uEGUEtRWgZ
	al4yQIrIXCwmI3ETHPJKfdQ1ilH/av+3Xc7S0a+faTDw7PzptEn18x5ql6/JWfaBmoPcMGHGsWJ
	0pQGaxCPnhiBseqgaj4gvWO3B1AYoLpyUawr+G/ag
X-Gm-Gg: AR+sD10RTgdQkNJwXb5/Y4K6xjnlnpHlnrOkKg4xFLlFdViiwQF/g8GbSaewarj44n5
	/JvjSi1AH1xF9mgeaLrw5spdySRym3Vpqe+FEAbFVykA8IkhUgNn7bTSNTJCcjFXO2OZOPG9AGO
	pHEPsJF6krz4K0xKB8VmU2GEG4DSoZtgywALU7Mhc3Qffi7YQSf6pHdhlarhgyuG+Gxynpwxx4Q
	jap6EB2A+orxfAqjJp6yhJrLbhWwxqUWTzFA/Ih1L0ajda7R5L+G5FXAq3RjkpTpPZFLmyWO+qm
	5nKHbMSpGB2tYa8CMSVLLyhMrLEj2JuVnkTzeUUH+YhsU5zImDKZpklMtD2f2lAKPesGVvW6ihR
	wITN/ibVRTo0=
X-Received: by 2002:a17:903:90d:b0:2c7:a13a:7fe6 with SMTP id
 d9443c01a7336-2d0caf1ac97mr1446015ad.10.1785873562130; Tue, 04 Aug 2026
 12:59:22 -0700 (PDT)
MIME-Version: 1.0
References: <d635115cfafcd35c8e3344b418acb1020aba1052.1785794035.git.abhishekbapat@google.com>
 <0b95c0df-8cf6-4ad9-9552-d7c4a657a25c@linux.dev> <7e71f6d4-7bc9-449c-a122-49f0e8397150@linux.dev>
 <CAL41Mv5Aa3XtmqVbDTnsf8RX4nxC7J7mUXZzFaUZ9NSMyAbpFg@mail.gmail.com>
In-Reply-To: <CAL41Mv5Aa3XtmqVbDTnsf8RX4nxC7J7mUXZzFaUZ9NSMyAbpFg@mail.gmail.com>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Tue, 4 Aug 2026 12:59:10 -0700
X-Gm-Features: AUfX_mxZ-0FNc_HLNdFRRnXxcn0NEdF_SMSpzT-y9JHOFU6Z-NdT3iHXOQVSrHk
Message-ID: <CAL41Mv4aBfcNtDCA=s1saJSrK+e_FiNEin79U9WQu-Ww-g9aPA@mail.gmail.com>
Subject: Re: [PATCH v3] alloc_tag: expose profiling and compression states
To: Hao Ge <hao.ge@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E4A7020005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: a1h7yjyidfq7tf9uyszfz94huecxa7yw
X-HE-Tag: 1785873563-18189
X-HE-Meta: U2FsdGVkX18da0wEqpbeXjs7/XLDgeYNMycBzSFO2/bexsYXHtVzeNW9fu/6Fbmf3P0Al+EHUJS8njKzUNgvipsAvaMcMbp/+6V/QlkDDVnuKdTz6oq/F/9wDP/UdB4Kyga7ng8l/N0nN1RuEYPhqljKGNw5Q6wKTmlDFtog6pEO+zf3MoWGrPJi4FMvl9R05MJp28/K2v3lummKYJwDPWC0HskDGwJwC0ry0a7T2Nc9cFz9zB6/QIdPLHDKa5c+nMxc/vfZcx3a1VQPrLLXE2pOou4WvYqa08eNLJ7MQ/6h5Q0N+DuTDD0ASLi+T4mTly14PIHHSN3pwwCx9DYz/TnHhSFv94nQpYZ/IyP8BxjqFLFJFbL91Q3gcLPlaXoa5yLbRYjKV6lgLl236e/WKyWqcStm1tGIoN6M1duLotF30mpBFQEvb7p68oteLICSKMvt4Vqe0sHkd0Mh65bMkNruvzGw5I846RFG0GZStfvUKmhldz70UQQJtcfcyjSjN5/QwBOLdXeIqQnEFKxNT/LVa8+9s+YHR53Rp5hi2QMRgnX4qhqNU2b4sFGtxlI469ib2Hxb/esJJWbZWONzEO/jtwp7xkADWqgHtDjHuutdLMG4OiMZ9FI0zm7XwE0lPBNN3CcbmeZr9HpzpDFySuS1O4mAGkM7HjrHCfF2DhttkY/a+4me5aDKTcEPEqvNS/iS0kJ2Ojyx6AzT16k8AfEkxSOmNn/PalHvPatqU/TmeHNmTHsu0zRmlpkRVJYnLuzD1AiRhnTb8aaVKak1x1DvtEOLXh2k5KPooPphmvuFmm0B2vnFBdd4MIOAqxx15jdB8l9K4/z57nOBomG5iNyGRbOwHgMDbBfUx9/jUiMZulWW53ShCdZ1ZQKwjnCQwXpnQmP2ORZe1f4VLjD3aiAQ9uT95fghRHtQY9+dVlCWDM0/vIYqXJKU1CALF1dkhbVxLPwrj1zwdNbY+cC
 U01Qha0P
 2xuVn78FrYjIDGdTQVj+VJt4zLz4GXK3G6yynNimWIM6JFESbRCTXleoYW07jfN5VVBtDuRBGd3DjXHibCM9bmntQIPC2SHL+qe1T3ZHuviC9SQ2lO/beNCXkoxsvMyKDEQ6N2pxPlk2vujzuwSEZzFScyE5UXtvFTamhuxZknGJ4we6DWRN+e+haQoEcZxiEkFSg8dZdNirwJ54Sw2P9DexD2EWVa+UvF7HYm8G3f4F/zoafg6up1DBU7RyXssMryXfjV8V9c+2iHzQAkIgnl7lJOH01CazkcQUdyPjmHfnDa6zurBYCwaRcxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 4, 2026 at 10:28=E2=80=AFAM Abhishek Bapat <abhishekbapat@googl=
e.com> wrote:
>
> On Mon, Aug 3, 2026 at 9:14=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
> >
> >
> > On 2026/8/4 10:15, Hao Ge wrote:
> > > Hi Abhishek
> > >
> > >
> > > Subject says "profiling and compression states", but this
> > >
> > > patch only adds the compression sysctl. The profiling state was
> > >
> > > already exposed via mem_profiling and is untouched here.
> > >
> > > I think we should make this more precise, like:
> > >
> > > alloc_tag: expose boot-time compression configuration
> > >
> > >
> > > On 2026/8/4 05:54, Abhishek Bapat wrote:
> > >> Currently, userspace has limited visibility into the exact active
> > >> runtime state of memory allocation profiling and its page extension
> > >> compression ('sysctl.vm.mem_profiling=3D{0|1|never}[,compressed]').
> > >
> > >
> > > Profiling state is already readable via mem_profiling. The gap is
> > >
> > > only compression. Also, as we discussed, this sysctl reports
> > >
> > > what the user requested at boot rather than the actual runtime state.
> > >
> > >
> > >> While reading the sysctl provides basic on/off status, it is current=
ly
> > >> impossible for userspace to natively determine whether page-tag
> > >> compression was successfully enabled without scraping dmesg boot log=
s.
> > >>
> > >> Resolve this ambiguity by exposing the active compression state by
> > >> adding a new read-only sysctl `vm.mem_profiling_compressed` to outpu=
t
> > >> the
> > >> state.
> > >>
> > >> v3 change:
> > >> - Added documentation about the behaviour details of the new sysctl.
> > >>
> > >> v2 change:
> > >> - Moved from displaying the state in /proc/allocinfo to a new read-o=
nly
> > >> sysctl.
> > >
> > >
> > > As this is a standalone patch, please put the v2/v3 changelog below
> > > the --- line
> > >
> > > instead of inside the commit message.
> > >
> > >
> > > Thanks
> > >
> > > Best Regards
> > >
> > > Hao
> > >
> > >
> > >> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > >> ---
> > >>   Documentation/mm/allocation-profiling.rst | 13 +++++++++++++
> > >>   mm/alloc_tag.c                            |  6 ++++++
> > >>   2 files changed, 19 insertions(+)
> > >>
> > >> diff --git a/Documentation/mm/allocation-profiling.rst
> > >> b/Documentation/mm/allocation-profiling.rst
> > >> index c3a28467955f..3ad1e9aacb9a 100644
> > >> --- a/Documentation/mm/allocation-profiling.rst
> > >> +++ b/Documentation/mm/allocation-profiling.rst
> > >> @@ -43,6 +43,19 @@ sysctl:
> > >>     warnings produced by allocations made while profiling is disable=
d
> > >> and freed
> > >>     when it's enabled.
> > >>   +  /proc/sys/vm/mem_profiling_compressed
> > >> +
> > >> +  1: Page extension compression is enabled.
> > >> +
> > >> +  0: Page extension compression is disabled.
> > >> +
> > >> +  This control is read-only and reflects the compression status
> > >> initialized at boot.
> > >> +  Note that, unlike `mem_profiling`, which represents the current
> > >> state of profiling,
> > >> +  `mem_profiling_compressed` represents the state configured at boo=
t
> > >> time.
> >
> >
> > Sorry, I forgot to mention this earlier.
> >
> > I wonder if we could remove this section:
> >
> >
> > >> Turning off
> > >> +  profiling at runtime will implicitly make this sysctl effectively
> > >> dormant. However, if
> > >> +  profiling is toggled off and then toggled on again, it will resum=
e
> > >> with compression
> > >> +  still enabled as long as the value of `mem_profiling_compressed`
> > >> is 1.
> >
> >
> > mem_profiling_compressed only selects the tag storage format (page flag=
s
> > vs page_ext).
> >
> > mem_profiling controls whether allocations are tagged at runtime.
> >
> > The two are independent: toggling mem_profiling on/off has no effect on
> >
> > compression. Only shutdown_mem_profiling() tears it down, but by then
> >
> > the entire allocation profiling subsystem is disabled anyway. There is
> >
> > no resume path.
> >
> >
>
> I added this based on Suren's comment on the previous version asking
> me to explicitly describe the behaviour in the Documentation. The
> original version did not contain it. But personally I do think keeping
> this here makes sense.
>

I checked in with Suren offline and he suggested I reword the
description to make it simpler to understand. I'll shortly send out a
v4 patch with updated documentation. Thanks!

> > >> +
> > >>   Runtime info:
> > >>     /proc/allocinfo
> > >>   diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> > >> index 52aece27b00e..877068241f06 100644
> > >> --- a/mm/alloc_tag.c
> > >> +++ b/mm/alloc_tag.c
> > >> @@ -1303,6 +1303,12 @@ static const struct ctl_table
> > >> memory_allocation_profiling_sysctls[] =3D {
> > >>           .mode        =3D 0644,
> > >>           .proc_handler    =3D proc_mem_profiling_handler,
> > >>       },
> > >> +    {
> > >> +        .procname    =3D "mem_profiling_compressed",
> > >> +        .data        =3D &mem_profiling_compressed,
> > >> +        .mode        =3D 0444,
> > >> +        .proc_handler    =3D proc_do_static_key,
> > >> +    },
> > >>   };
> > >>     static void __init sysctl_init(void)
> > >>
> > >> base-commit: 94f9b3980dd446b56acf1dfed649e9b32a9f3813

