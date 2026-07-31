Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87097C55173
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 21:48:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A4B36B0088; Fri, 31 Jul 2026 17:48:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 255446B008A; Fri, 31 Jul 2026 17:48:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1473A6B008C; Fri, 31 Jul 2026 17:48:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D90F46B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:48:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 54B6B12016C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:48:55 +0000 (UTC)
X-FDA: 85050412230.08.A3EF335
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6160AC0007
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:48:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q7Mfp9Fp;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785534533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+6NJaceoftQlu3V+oVLti0xg4HHs7NkT1GiDbWZAPSg=;
	b=e3JEY3wpDP2JzH/3rUnq03IMP5OLbJknqM8NB7hzLmZajjlGGKD8PcNIUqgUgC32LcqF09
	qIlM+JInTiMmjPXidVREO7jMkpiFzcWM/6z6BTEigAL4yiz5xVp+HmIMpm4te0ddis+WwN
	2sSDujaY8VpD02YkRYg0zi2YeolnebM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785534533;
	b=mE41Qs/L8XE8kqaz7KVF1Go/DRRd2E2K2pC8hSs2NPmRWQJNXnVGC50RFdMsNzoImHgyf6
	1Mc2awQPCcWzK0aCvt8bccQzz9jceYgZLIOQp6FD5hJ8yT9NNIl4NVlEPnVAk4pY2IwdY4
	Z9uJqLuyTpLHyjSlHsQwBkK2VnFSLlM=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q7Mfp9Fp;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51c15a5b265so88031cf.0
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:48:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785534532; cv=none;
        d=google.com; s=arc-20260327;
        b=GWSoUCCuJe8SMf+iuAr6G4VwdCQnY0277P4VAmUYV0UYMlIifUxPiJ+/ObRJtfi4Qg
         NXmhr0FydM7l+5g+JN50xXN0LHuoG+NklhiJ9zg8dwO6Zp5Fmf5QQ7mfl0o8f/fZxOdP
         I7kSD2Ne1v29ldPrkIVO+mdtaZOZSXeJ0bxEJjQQ/iPgy5AD7OP58SpPT+CT8kdFEU04
         CzJg3nIR2Xr766UUAPtTRGwkGdwOxhn8uYAMRZOAbMdaepHG+XBt3OqELKnDIYAqENum
         Xmij1LUPS9HdM4uaL5wmH69QrPAnNnzNPK26kK472GoKrUA7vM5YAhL/npr20275RGk8
         y8Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+6NJaceoftQlu3V+oVLti0xg4HHs7NkT1GiDbWZAPSg=;
        fh=vOlaChF/4VruNzPnFo+w0bF2vxLUDlm4NBR9z4Iryns=;
        b=LXQzJTvdz7HWdH6p/Xv4RqiBkXzUuwUkuNaSEhrK3oAJoESum9BAJWBY5xvSEdYwxK
         3oROX2HWTyt6eYZAedLb+4gsVG2SaqMuuibyEOVySqwrESoTfGuMwKWn2mHQUZXbPzx8
         H8WZhCuwt7ObRALi+Kgv7Z/DU93ckM9Mx1/7q8nz9yaS1AxE7b2UnmmlvZzpj/eS29G3
         eQXGdBPSQKJ9OF+SeeUmeNsF2Cz2FQ46UKgbBWKgPw/kCaZlvt5YUCD9ftUWmxu42sAT
         B7+i7/3JwAppZ5NiEmo+T1gYsTIAbLSGQWD15RX0wlm5wnbnRxyD06er2nT0aD4sAyvi
         VUew==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785534532; x=1786139332; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+6NJaceoftQlu3V+oVLti0xg4HHs7NkT1GiDbWZAPSg=;
        b=Q7Mfp9FpTtXKJbRJzNZaHeF+pkKILlw32tVykI1Bz32RxgebmJut7DBMRRfWNLo8pC
         l4itvmzjN52JyYqE8Xm8IXhtZks/md6D8wfqRyjSPB8A4wxZKwZ9FTa+FGC4vM8YixuP
         Q0ZE3pnu+1+J0Y3IbmilpHD+DT/jvBJHHj++ACEX+JphtU5T2zmwtHLl84oV+VzhqKPG
         ESAPQRMbji40i7hYcZAVky4+zbPd5CpF6QUnSYtC+i3ndktyaHxqjLz4dh8R1ZzLvw8l
         qHUheuad1I5ceIX+i+BfOyp1wbp4KykhOjXOHV1xnVK8iBzJA4yhkCWS/z9+aJYEb2VW
         SNQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785534532; x=1786139332;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+6NJaceoftQlu3V+oVLti0xg4HHs7NkT1GiDbWZAPSg=;
        b=COPidmwGCsSgTVltwbhygP6bhJXsievibNuC3CVoiSWFFE7gBKrVgIDe5Jf6FzFEk6
         4skNSyXX7dhzmKI0u9AE2zXsyDpXKPBvnifi3ZmI9s6lKn9LRVKXreXoSp5+B3lrY9Z0
         9r/VIZmu6ma0o/71Eq4Hg0lluQUWUC/JhrvJKk0Eg6sQ4voKk5CECbzs/tV7N68oQPfS
         KcSEVuhrPXwG65ebbJoG/NQfpA0xzngWw6fpgPNabbcxbhrDgBIFAXVTyeQbdPXLVAVV
         DjApPVCJ9VzfTDPD3PpPrPJhDM1mBZmKZyzRzhsvVALw5wqhgdF7d8ehkATDKiBWhyog
         2rYQ==
X-Forwarded-Encrypted: i=1; AHgh+Roi6Bm2HJlx74WROJcDIuHgUL+9uSPvcrjxUxjm+c8SbqlO+fXW4UsZBFXkjrfLdivltWk0DYTTcA==@kvack.org
X-Gm-Message-State: AOJu0YyqpkdYdRL8x/T2ZlZumaaC3FsO3N6zOuAkgtGANpH4zIrGUQNr
	CeTbR575CrL+dKEeryeSGXwLNIb/SlxVtbWd86kGQWP72JoAUJd9myNSHgJw7KACdZSYnRpmTdC
	GsVP5N0W6yaoUp6xWgnAzbO0UUk12hO1xXaFZCLKz
X-Gm-Gg: AR+sD11GWC8vBjeiXesvuIlpY4OuN6wK3KeRWoH+wDIOZbevioMncFbldDG+BefL/PH
	UC9cid1hGqtxVe2Vpbt7gG355Z/F9xbkFV0EEMjOwi9uQemaP4fP46VF5gyZjY6fsnHVOSzwvlv
	bAMriwq3p5W2EEkffxuUY5h6KHqN8JiIOzdmW+ead1Elco/fJg11fp+oPImlGRYv1KJHx2Uc0Aw
	ZtAGEzJUundhMjLvaOx3f3CCQJfPaK8XD5RxCnXcCNizkzL3T+gJBYqT9f1UH1EdaSjXBltb+ZW
	M7j8O1RGhLvoj976niF4VZe35rzJQk73afeDkXcZDfI=
X-Received: by 2002:a05:622a:22a0:b0:52b:4ec6:52ba with SMTP id
 d75a77b69052e-52b599faf08mr6569441cf.6.1785534531823; Fri, 31 Jul 2026
 14:48:51 -0700 (PDT)
MIME-Version: 1.0
References: <0d84763f140ea735d790e0b30a8e954536beb875.1785455267.git.abhishekbapat@google.com>
 <0dcd8c2c-d841-47c2-997a-640d1937a77a@linux.dev> <CAL41Mv49qeLm-MmHtQGFnyzjEsE+8kvOgtMTKpjNAzDWozum2w@mail.gmail.com>
 <CAL41Mv46p9bFhX-UYpZ-jk9g+yQcwtMbcQHGnfwp8rQJzw_FEQ@mail.gmail.com>
 <CAJuCfpFCs_t4DZA=rdA_a4rL+kJ_tckjQM+9kHUZuLTK6w0WTA@mail.gmail.com> <CAL41Mv4Bf1WG-yeiZ_DiDm7_eMO_5M0Ta1eivm2HthJUDuUL2Q@mail.gmail.com>
In-Reply-To: <CAL41Mv4Bf1WG-yeiZ_DiDm7_eMO_5M0Ta1eivm2HthJUDuUL2Q@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 31 Jul 2026 14:48:41 -0700
X-Gm-Features: AUfX_mwWl0CbM3FcwrFUsHHQDbeNmYR63vTDzpoyAALlhnJBOQ6QdN1XMgRzAHo
Message-ID: <CAJuCfpH2ee0+bi0HDYL+cdcBETieu1Juph__tc=esEoBMFQDnw@mail.gmail.com>
Subject: Re: [PATCH v2] alloc_tag: expose profiling and compression states in /proc/allocinfo
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Hao Ge <hao.ge@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: p57dray54ichxrdqta4xszjowubre8ye
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6160AC0007
X-HE-Tag: 1785534533-966940
X-HE-Meta: U2FsdGVkX1+WlYSNBUI8rMwg62BnnFRVcILDaSuohMwdxelB6D8Al0dVVLHW5HBwHeCaSbti2k4Hx2mfXN/Ew6QeD08yyX3dT2GxA3EfTdyFjWgWPhjn2jfl4MV7DfW03NtTQIJKrbMPyefvYhmEDGZQrvcGmT9+ePEGb9n6Biu9xMxdXiuFXaT8xk/6RmPCEkY7y6gc7ElFSHEtp/B93Dnnp5ojBX9PPtHswkZ/xEVAIzSNSIdBGNfq9eYB5YEFTniXGrUqBfLsFaiWXMHYbkWAt8tV/RRdQRgID6CHgm2SEx6c1SgjUn78t6qGLjJ9GZkscs8oglfABS/3fpyxdEJsABrczioPeoUT9OQk0iVopvVJecuumJDutYtNXY+ypHaq275TOUm3i18TfwUSsaQFgYKZz9zWKpFmaD9T2Z+1oIXC/xzPmg58qSRKYPWMo2Ccsj5ZZu9wZGyEgt34sepUpZEuSVfdsXkN0x3fn0KjTEyi8r74YdA14cdtHI1meRKrr/L8SoPiHwRjIDR0zzmtPmjFbqsyIf1GTY+OchZvP8UR2GuByE1KXCKaIKhJKB8Inm/F2KNTh7oOaaNb/a5fcgINoUw4IzI3mFHeBMz7DsVioFgS2Wry42ArB1PPR0aoKzVFg9F+DmNvkHXo6AL2VLuU97A9HStCJW1BaohazueuWmOZMTi99hPr5tAqfttDpKRcZft7Pze34VOr1jUtfVEdwsNLBtBkOjVXjgfk8fwsTTqE2xFK/gldaJsm83WfQfY1pQ/aHXHAr0tAnaPN/cCYH3AW+X/X5bDkfMpGdTWnCeNQSf2N/dgggXgVvm4xYpEPumUwPTL/DqonS1NJfNWvgfjYGOd3kvaMvz3aP7M9fPmT6k7j4wUnCqP+AnBTKUgwie/kINyjs1HYeDBy+gtQE6BOASilxbv7I9tL7lgPMNYDMR8XqT3lN4iebrziILLCWZIDpOojonQ
 bGvX6Wj0
 7qDNjL8+08fSqedGYBNUwNYvOe7LsB7iQ95vUUYxhEY7BcjqfnNjQbYDrCYcZGjjP3TENujpgJy6BOZ+gSwYDHzH5Q9TN4MsCoaL6pf6oygAJfoJRoZxgtMm4PJ8tRcJ4q7neZqXgH4p7C+C71yAws84I0SwmmR65NX9NtKgMnSL8JNqlPmAJ24gISuGTUaN+aKh4bPPsadAbc6vA7uBgP2y1V6MfmuSrtfqJYcIyzawh1kxKOnBXs2VTmD4l861ggEfaLFOC/N31DJXOiEL+j2gadQ5lU9SI5eXIly6s+SxLTrmfYgmntne5xpx7fcEMKKOnbpFbObSV4yN/c6vo+jw9q5FQScw/n59/jRW3itP2ZuM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 2:10=E2=80=AFPM Abhishek Bapat <abhishekbapat@googl=
e.com> wrote:
>
> On Fri, Jul 31, 2026 at 2:04=E2=80=AFPM Suren Baghdasaryan <surenb@google=
.com> wrote:
> >
> > On Fri, Jul 31, 2026 at 6:37=E2=80=AFPM Abhishek Bapat <abhishekbapat@g=
oogle.com> wrote:
> > >
> > > On Fri, Jul 31, 2026 at 10:25=E2=80=AFAM Abhishek Bapat
> > > <abhishekbapat@google.com> wrote:
> > > >
> > > > Hi Hao,
> > > >
> > > > Thanks for reviewing the v2 patch.
> > > >
> > > > >
> > > > > Hi Abhishek
> > > > >
> > > > >
> > > > > Thanks for the v2 patch.
> > > > >
> > > > >
> > > > > On 2026/7/31 07:48, Abhishek Bapat wrote:
> > > > > > Currently, userspace has limited visibility into the exact acti=
ve
> > > > > > runtime state of memory allocation profiling and its page exten=
sion
> > > > > > compression ('sysctl.vm.mem_profiling=3D{0|1|never}[,compressed=
]').
> > > > > >
> > > > > > While reading the sysctl provides basic on/off status, it is cu=
rrently
> > > > > > impossible for userspace to natively determine whether page-tag
> > > > > > compression was successfully enabled without scraping dmesg boo=
t logs.
> > > > > >
> > > > > > Resolve this ambiguity by exposing the active compression state=
 by
> > > > > > adding a new read-only sysctl `vm.memprofiling_compressed` to o=
utput the
> > > > > > state.
> > > > >
> > > > >
> > > > > I think this should be vm.mem_profiling_compressed.
> > > > >
> > > > > Otherwise, you will need to adjust the procname for this new sysc=
tl
> > > > > accordingly.
> > > > >
> > > > > Also, kindly add docs at the linked path.
> > > > >
> > > > > https://elixir.bootlin.com/linux/v7.2-rc4/source/Documentation/mm=
/allocation-profiling.rst#L33
> > > > >
> > > > >
> > > > Thanks for bringing this up, I didn't realize that I forgot the
> > > > underscore in the commit msg. I'll fix this in v3 and also add some
> > > > documentation about this.
> > > >
> > > > > > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > > > > > ---
> > > > > >   mm/alloc_tag.c | 6 ++++++
> > > > > >   1 file changed, 6 insertions(+)
> > > > > >
> > > > > > diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> > > > > > index 52aece27b00e..877068241f06 100644
> > > > > > --- a/mm/alloc_tag.c
> > > > > > +++ b/mm/alloc_tag.c
> > > > > > @@ -1303,6 +1303,12 @@ static const struct ctl_table memory_all=
ocation_profiling_sysctls[] =3D {
> > > > > >               .mode           =3D 0644,
> > > > > >               .proc_handler   =3D proc_mem_profiling_handler,
> > > > > >       },
> > > > > > +     {
> > > > > > +             .procname       =3D "mem_profiling_compressed",
> > > > > > +             .data           =3D &mem_profiling_compressed,
> > > > > > +             .mode           =3D 0444,
> > > > > > +             .proc_handler   =3D proc_do_static_key,
> > > > > > +     },
> > > > > >   };
> > > > > >
> > > > >
> > > > >
> > > > > I think adding this sysctl alone won't be enough.
> > > > >
> > > > > If we set boot arg sysctl.vm.mem_profiling=3D1,compressed but pro=
filing
> > > > > gets disabled due to insufficient page flags,
> > > > >
> > > > > this sysctl will still report 1 (compression enabled) even though
> > > > > profiling was shut down.
> > > > >
> > > > > To verify this behavior, I have set up a test environment locally=
 as
> > > > > shown below:
> > > > >
> > > > >
> > > > > [    0.265503] 4046 allocation tags cannot be references using 5
> > > > > available page flag bits. Memory allocation profiling is disabled=
!
> > > > >
> > > > > [root@localhost ~]# cat /proc/sys/vm/mem_profiling_compressed
> > > > > 1
> > > > > [root@localhost ~]#
> > > > >
> > > > >
> > > > > I'm unsure whether we should initialize this sysctl when profilin=
g gets
> > > > > disabled at boot.
> > > > > If we do, we should set mem_profiling_compressed to false in
> > > > > shutdown_mem_profiling.
> > > >
> > > > I think the way it currently works is, compression can only be togg=
led
> > > > at boot time. The new sysctl my patch introduces is read-only. Base=
d
> > > > on the current behaviour, if compression is enabled, and profiling =
is
> > > > toggled off and then on again, it will be toggled on with compressi=
on
> > > > enabled as long as we're in the same boot session. I don't want to
> > > > include changing this behaviour in the scope of this patch. I want =
to
> > > > limit the scope of this patch only to expose the current state to t=
he
> > > > userspace, hope that makes sense.
> > > >
> > >
> > > I reread what you'd mentioned and believe I originally misunderstood
> > > your point. You rightly pointed out the subtle bug where the
> > > compression state is left desynchronized if compression was unable to
> > > be turned on due to lack of page_flag bits. I acknowledge your commen=
t
> > > and will change this behaviour in the v3 patch to toggle the
> > > compression state to "false" if this happens. Thanks for bringing thi=
s
> > > up and I apologize for my previous misunderstanding.
> >
> > Well, if profiling got disabled then it doesn't matter whether
> > compression was requested or not. The profiling is not active anyway,
> > right?
> > IMO if would be less confusing if we let mem_profiling_compressed
> > reflect what the system was configured to do. If that configuration
> > was impossible and profiling got disabled, the userspace can detect
> > that by reading mem_profiling sysctrl. As Hao mentioned, this should
> > be clearly documented in the docs.
> >
> So, IIUC, you're suggesting that I not change the kernel behaviour for
> the edge case Hao brought up and simply expose the boolean value
> through the read-only sysctl. Right?

Correct. And please clearly document that mem_profiling_compressed
reflects how the system was configured. In contrast, mem_profiling
reflects the current state of profiling, which might be different from
how it was configured originally (might have been disabled later by
the system or by the user).

>
> > >
> > > > >
> > > > >
> > > > > Thanks
> > > > >
> > > > > Best Regards
> > > > >
> > > > > Hao
> > > > >
> > > > >
> > > > > >   static void __init sysctl_init(void)
> > > > > >
> > > > > > base-commit: 2ed26e8a624f41887d64e2e37a2f6ab36a118d1f
> > > >
> > > > I'll also wait for Suren's comments before sending out a v3 patch.
> > > >
> > > > Thanks,
> > > > Abhishek.

