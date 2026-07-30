Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B466C5516D
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 17:57:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD8076B0088; Thu, 30 Jul 2026 13:57:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D87E96B008A; Thu, 30 Jul 2026 13:57:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C50776B008C; Thu, 30 Jul 2026 13:57:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 92B826B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:57:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1BD99401F4
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 17:57:37 +0000 (UTC)
X-FDA: 85046200554.30.2F92C65
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf22.hostedemail.com (Postfix) with ESMTP id 307BEC0007
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 17:57:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=m0kAVBZY;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785434255;
	b=SXocKV/p5SXIzrkXAMFvxzCSDoyztRKIk0YWvXH1zW9TKCVWJgab7jU6cVmEpt/mufHMYp
	0i2uiWSkbslfUbo/WQvA+u8Quz0JIhtxdX4lfnF+05QSjyIl/oe5lJ9NKVFeMQn5x5o36P
	eVHoFQxS3B+PHMBP4yTXf7NG9q8rPaU=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=m0kAVBZY;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785434255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+auF4Pvj0lsXi2Xdq2se/ugAp43HjH47f3W64X2F86U=;
	b=IV1J0cVJUkV2CXgIXb7vkESB0CL1t6/eUec7xaqF1If3meuNaDJojGC8EoY0QCUiydipJO
	PXgGxmOesH1XPEd2tgh8ddSnh9k2W1iTY0de9HAJupvh8OgRqXTmJ+iVGvqtTtZmSoxi1S
	IzgxRhZoB91uMMOB8e/UzviH7O4edJM=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cab97c86bdso17495ad.1
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:57:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785434254; cv=none;
        d=google.com; s=arc-20260327;
        b=avfOZeKK3l+EP2QtkyvM5qs+WddOXNBc/OdDCRfVS+KCdeCLHuHS9HaIjdenZ+heiP
         qGu4Ivy8xU1GVU08K0nbb5w6JmJZf9mgHeYPBptW1/5DlOa+4SdUgzGdYoLYQrQ0q97w
         ak8Y+cyR38UIIBhE3AoHIPtxhMyeRV7OuRKztJdBQGD1sXmXGZN2tjprxPwpR1QXuEZy
         Gjtwva27wrfdQa1M+vi+oQA3FsB5MgRpVEg9vTuY2/nKx4Dk7JvNH/PtLz/OfG/mMuTB
         h67wBow6tYiYidD3wqWQpb2KuAfbjIfxu8frykXUHGFHHWzKhaFocI3GMKC7avykVaw3
         tRAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+auF4Pvj0lsXi2Xdq2se/ugAp43HjH47f3W64X2F86U=;
        fh=P/ZPRpx3zZX2r2+6IUNdKnvK7LG/554ML4AnXOPlJKQ=;
        b=L+cO0r16eWhoAcdRFO3GCi9/LiC1Xs3ITgKj2KyE5D2/ttgMnMs21KFEB4VYnre4aQ
         XA9elRv7yZY87G4ZRjxSs/fReeYr9dekAX/ZgrZuUxWXjFU6UidZl7tdCWrA9r8GPP9x
         fL08IDX5sZE7TCPZNJ9FpzshfJ7tMJ3rsnSm1aDOgKlk1JSVW2w9A+fVMC91NmH4raPW
         AHeMROfhP+vVtJqb//d/5C1GGPGqz0qXsAhXuRHDtAIBNX//OAdqdFXnqEmc183frRnV
         oIyURp/Y09xTloLyeiB+A7k4tAdQbxFC9gtUori5zHdxZolAmJrzKGkiaFyYCQ155c01
         IMrg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785434254; x=1786039054; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+auF4Pvj0lsXi2Xdq2se/ugAp43HjH47f3W64X2F86U=;
        b=m0kAVBZYNaGpfzoqtzuav7+R5D6P59zwvOwTtjvVf+h1m57b1xA7GCTgCTsN3JzAds
         BHSkfbIAnEB3M0fTbDCeDjSgBtnbRuv3dcTsfl3xAazyQi+cEgPWUJFQCqg30WZLekSO
         xz/RJOtmYnK+qKfo1ccVAnQLEttLn6YDqToWHWLD+OiCPd/bxkSrB8kh+bOkLsN5iEMF
         5ZdLBbVPQp19zpFTrFB4EdezYB1rPLQkG5G2E3x1lk7FU5JHSspczWTB2re/rSzZwXi8
         t7/Rj/C48ZkxU4qIt4zyMvRNEcZl8i5LsMYGgf3W8uYmHk9t6zd43uxaAMh3Wubm/o1d
         ZHPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785434254; x=1786039054;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+auF4Pvj0lsXi2Xdq2se/ugAp43HjH47f3W64X2F86U=;
        b=Cfc9J6j6ZENMVhCDUDh9P8cznsARUqBU/kZbLR1IYbBOzBKHhXbrtZ32l0ncq0+Jdp
         soywWaXtLGB8Jk8YHOMTXnfqN6udNzZkZN3+xWXuymLStxNVpKzKQU+Z0feO4ZBSxCIZ
         LX3sarrOT9m7MeWVPczDTfGhycWR21iIFsFKw6M6vumV4RGbtpqDVct20DUKgbqIAluF
         wzG8JDdCibT+INL/YwXBBXJl/T6ffh7aD1+3Tv0HILqPapHKPw1RnBAyYiYQ7WOL/PjA
         KwG6n3OBa9OZGmNhmbI0kjufc2aC/c6YWSa0aBx/mIykWb1L9C/EEyiz0Vfia4QuyMJc
         wSkQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq1C+WUyrTGNh5GMDu9hz9iPUvqCh69NVKPwNjYRgq6BFi+MK91Ks1MAcmcbasG4UUNn5BbKUJznQ==@kvack.org
X-Gm-Message-State: AOJu0YwyaDLMPMDJK5t4eEiOkOCTaKv6t23VE/P/1wc0r09WEEzi1SL2
	zPpo61dE7cro1Er7ABuwZtwOzlbouPW+5mK8HZwtXd9CNflipdAUJQMQoBACO6q77oKDN91kyXq
	iqzTircVUqdpb0FvA2IHgaORCQm99E15niPewlFck
X-Gm-Gg: AR+sD10lb0ghC1uZzXK7alBH9vls14p4nkG8dA/sGLA5EtcUuE2cjj2EHhgucYYEhR/
	YE+EGc9dXlTBqRgiYIVRYI9fHQOfv8/on/ACu7vOwN7qnzQzLoqdkLo38OD1oQppdF6Hh3h6ezR
	wke7Y+cacA1mH6b5Yderp2Qw8kUWNj8SncaautfPmA3hQjnqvERmWyOgYdkg0vkXL1djc4tyf7L
	DF/MnkpfIFFISMlT/IZOQaawP1v05fNgb5iN6soaQMddjSULVH0mEPPw7Odu/9m2hjawovFZxhZ
	aLN1+EDfYevgdRQ+G7OcwP2lyrF5WYqApaKXxG3uBOq0shTRp12i2l1w/KiYXoN6x7ZSD0iLqi0
	=
X-Received: by 2002:a17:902:f544:b0:2c7:f0cc:dafa with SMTP id
 d9443c01a7336-2d0413fbd0dmr598465ad.5.1785434253268; Thu, 30 Jul 2026
 10:57:33 -0700 (PDT)
MIME-Version: 1.0
References: <2614a3a2f5cb11b63e3cacdcc8ab20a0fe7ae972.1785365110.git.abhishekbapat@google.com>
 <729c578c-e5a3-4351-b07b-469f79c26b0d@linux.dev>
In-Reply-To: <729c578c-e5a3-4351-b07b-469f79c26b0d@linux.dev>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Thu, 30 Jul 2026 10:57:22 -0700
X-Gm-Features: AUfX_mwMejtS5C4Kuof4S5K9YnU-wan6nEJME_k_jp8lwPAmKxdiMA9cXI4_DHA
Message-ID: <CAL41Mv7_CjWTahWO9sfDZkVKZKEU56j9Sk+xMWN7zbJfRH5MSA@mail.gmail.com>
Subject: Re: [PATCH] alloc_tag: expose profiling and compression states in /proc/allocinfo
To: Hao Ge <hao.ge@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 307BEC0007
X-Stat-Signature: usnieui697ecbt4kyexxfuorfi7hxwi3
X-Rspam-User: 
X-HE-Tag: 1785434255-423416
X-HE-Meta: U2FsdGVkX1/UP7kv4fyX5rX04Wt54+sWgwxFUvtbsp9ytBc7D59o624DU+lHihksKRiGoxtWq0b65jhH2UUgCqcy/1KieHuL/AIn06GxQC1jml1EHwqyS4HNCbV+Mk88mGtlC6F04uYaOHOPePA60wiCgckJWLQqdhYN48RR6792q0/HgpfNb+qXKhje7Qp6BI98uajGB0euYyBeDu5KkvO/4QL8U0QI+XHCo5CrvXnYAeZ8DNpr12FsthEkNM+q4KAiBOmEjmX12GFGMI03sLWt3z5kShjM7ZmMsDdxkti0PGYBlXWETjNlGfSIQZv1aA7nsuKEWnbPy683R4oNCkKOzmwTo3AZBVIB/ISM48kT4F5tqUg71Nbhq4J3MGBXERUQoZ7ChsqnAHEjXbmmo3teImreGDEnzlXz1XdL2zWFzvTmdMriQ2Yl2PqlwoBZzHPK1maMmXfwwp7B8cvHcJS9jHzP7XkD2JQ46joEiFqiq6LlGXtymO0pmW+PP5iQNQiOLTy/SYPjdl09OFz9t3zUTxJHb8ndlvaHg4ofUPYGlx8DJRMEd1OQ9RSuCSxD/Zd7rRi4rFdPbL2tX+Nnf20SCTKUILs5aIb5PSoiU+9lMxNZhHbFBmBhH2d4vKpyBjq02ZQezI3rOE3hJSuzgTehu/W+Weluj7shaZxzh3PMw2z3thOlBtBtryCw8m5KzTxyhR2mitkMsmd3GCoYJvWmOpRsgTj8WEmQR3SJWc+7KIJi4jkWEgEe5SVU6xEmWha8t86Znw79Lkgdls1G3er9BPSP/Ztd+wQ63qc3amI+892YMzgvv7mWhag2VM6Zy8KgdjaZ0pRRpbXnzuIAGKA097AkMhLIS2odE3V4suwJ6R/OTnvDooce7HI2XpHqw26MuOiM1AROHQ/rnUOKhnBbru14mhW3T+ugGtIKRFezFE6aLO0ynFYsCykSofZSCO8oQn3liaJ286VLvrJ
 DlsH+uhW
 3KpciRjvdFwFrXbaLaJrEXuH6U98JlKlsOTez53pMT4NHjZCpmecbyvQuja6E+SDwCm9rnqOwImCRQ/ElHwLFSePaKhYKI8wG7VbJ9azDwMCyTpiLg9suYFpO4kb9D8kOU4tqDvnuBb5NV9txhAaR3eevLSPPsp2E2Ed6hA1nxNdo54AONunk3bkAQaZUiXyW6Zr/ZG1wY1wkmFotgYrcPm6C1RJ31xG7Oc4B6ue3WRjLxNaHF+X1XBZr0saXRjTo3HhnPnQlRVxByz5VYD7dMQ5XnMly3k/TtIEBnLL32DG5AZAZwzrmzxzrJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Hao,

Thanks for your review, however, I'd like to disagree with your
points. Replies in line:

On Wed, Jul 29, 2026 at 7:23=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Abhishek
>
>
> Thanks for your patch.
>
>
> On 2026/7/30 06:49, Abhishek Bapat wrote:
> > Currently, userspace has limited visibility into the exact active
> > runtime state of memory allocation profiling and its page extension
> > compression ('sysctl.vm.mem_profiling=3D{0|1|never}[,compressed]').
> >
> > While reading the sysctl provides basic on/off status, it is currently
> > impossible for userspace to natively determine whether page-tag
> > compression was successfully enabled without scraping dmesg boot logs.
> > Furthermore, since /proc/allocinfo remains in the procfs filesystem eve=
n
> > after profiling is dynamically disabled at runtime, simply checking for
> > the file's presence does not reliably indicate if the allocation
> > tracking hooks are actively running.
> >
> > Resolve this ambiguity by appending the active state directly into the
> > header of /proc/allocinfo.
>
>
> It's not obvious to me why userspace would need this state.
>
>
> Suppose userspace reads mem_alloc_profiling_enabled as disabled, then
> the profiling
>
> gets enabled later. All allocations generated during that intermediate
> window are lost.
>
> When users later cat /proc/allocinfo and see the enabled state, will
> they mistakenly take
>
> the output as a complete, accurate record?
>

Currently, userspace has no mechanism to determine the actual internal
state of mem_alloc_profiling, meaning users are forced to make
assumptions regardless.

By exposing the explicit state, this patch allows userspace to query
and validate the state concretely rather than guessing. If the state
changes, userspace can immediately detect this and react accordingly
(for instance by invalidating and / or refreshing its view). Rather
than introducing unsafe assumptions, this brings a clear, testable and
net-positive improvement over the current opaque behaviour.

>
> I'm also unclear what userspace would do with the compression state;
>
> this is just an internal implementation detail of memory profiling.
>
> Put another way, personally I'd prefer /proc/allocinfo to stay lean and
>
> avoid exposing too many internal implementation details to userspace.
>
> Unless users intend to dig deep into how memory profiling works, these
> extra details
>
> will likely only confuse them =E2=80=94 most don't care about internals a=
t all.
>
> It's similar to how we use APIs: we only care about what an API achieves,
>
> not its underlying implementation.
>
>
> Could you share the concrete use cases for exposing these states to
> userspace?
>
In large scale production environments (such as our deployments at
Google), we can only afford to run memory allocation profiling when
compression is enabled, as the overhead of running with compression
disabled is too high for production workloads.

Currently, there is no way to write an automated regression test to
validate that compression is active. Exposing this configuration state
in /proc/allocinfo provides a clean, concrete interface to write
regression tests that verify and enforce this constraint in
production.

Hope this helps clarify the intent behind these changes.

Thanks,
Abhishek.

>
> Thanks
>
> Best Regards
>
> Hao
>
>
> > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > ---
> >   mm/alloc_tag.c | 6 +++++-
> >   1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> > index 52aece27b00e..89ec2c6ce57a 100644
> > --- a/mm/alloc_tag.c
> > +++ b/mm/alloc_tag.c
> > @@ -108,7 +108,11 @@ static void allocinfo_stop(struct seq_file *m, voi=
d *arg)
> >   static void print_allocinfo_header(struct seq_buf *buf)
> >   {
> >       /* Output format version, so we can change it. */
> > -     seq_buf_printf(buf, "allocinfo - version: 2.0\n");
> > +     seq_buf_printf(buf, "allocinfo - version: 2.1\n");
> > +     seq_buf_printf(buf, "# Profiling: %s\n",
> > +                    mem_alloc_profiling_enabled() ? "Enabled" : "Disab=
led");
> > +     seq_buf_printf(buf, "# Compression: %s\n",
> > +                    static_key_enabled(&mem_profiling_compressed) ? "E=
nabled" : "Disabled");
> >       seq_buf_printf(buf, "#     <size>  <calls> <tag info>\n");
> >   }
> >
> >
> > base-commit: c73b725a57f276a3702ca213bde78fca029bc619

