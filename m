Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23B59606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 23:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=OfdM3aj3
Received: by kanga.kvack.org (Postfix)
	id 46CC06B05B3; Mon,  2 Nov 2026 18:17:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F6406B05B5; Mon,  2 Nov 2026 18:17:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 297376B05B6; Mon,  2 Nov 2026 18:17:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 02A616B05B3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 18:17:33 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8023C1402A6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 23:17:33 +0000 (UTC)
X-FDA: 85391742786.22.E821129
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9BD5FC0006
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 23:17:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=OfdM3aj3;
	spf=pass (imf22.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793661451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xKD9YvpeuRe/dGg9UOpRwAfoOUMyefhjGpw4KelDrg4=;
	b=eY1lu73H6qqgP3LrxI5UpRQLMnp2tKReRVf2jeTeU+BywoNJOgWbI9w3gq7sdlU3NkbaHU
	PYf6uNofTW/Y/4iYI0zhEh+Z4heO0s6MRPsDw5KsDVd7u3+o5Cu8dXX5hQFLQ+RMQaoXHM
	sKAsnZoPlXICh6OaBG1waQKUS+tK+hw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793661451;
	b=HVi0nVchQj5yA4bJRgoeHnzFIJzjIeVxkTp6QlLSV0gJ4ILOLcN4UcvaD90qp4Q0qLWdOR
	QaykMvp+TUalJGPZ79IyhjPozIGZRx+qxu0G82JVdFVJOyIhyrJwaeA1SoqUSCpO5ochZJ
	HumT7wSQ4eTvHGGCTb/XMEyLUM5hQCc=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=OfdM3aj3;
	spf=pass (imf22.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2e8d6fcbba0so7145ad.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 15:17:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793661450; cv=none;
        d=google.com; s=arc-20260327;
        b=P2jvqhM3TvX29KmGIyOVAFUTJye6mYaf2q5vvA/zAba93o7Kc0HbueIXEN1Jc+eOmc
         gBqfimZ4srqT7Xj5q4pxcsww5Z6au9Ik3DlsFKpXMTkdHpLsKcMRZ6UnaKSKjqWG7E0h
         upDplKCLcAjBdpd5/AA7bWCmuQesNthzH9tGPa6rCowYcC3l50Nvl8yecJo6bP3wfe9N
         Hi5cvGHuNhX5T92AxfiRFTTq6dRSubHUPE98wwo+wyZ6Z3h+uepoNmivsnijV253HmkG
         FIqovRvYvyGZDIX7qBj0PjZCvGJ4rUMXZUlcJksOIszLR3l1tAfMqnsPXJsvOwDfWi+o
         Xulg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xKD9YvpeuRe/dGg9UOpRwAfoOUMyefhjGpw4KelDrg4=;
        fh=uUn7CAwQbdHQnE2gK+Yxx8rbEswFoROIYVR9/wyd6uA=;
        b=IEPa13Jm+EL9vIgTXp+K45fcKSag6YuIQXqlOArvyfwegfu0j3+RFTLeIluiQ6oPjc
         BtqamLcP+InfvRYcYe2gXzhbxARLS7HaOkR4OBgUFRLMS8VCGz+BPGIlIiAPqC0l61sH
         YDkv4MiRIoMv9P1vkKNaxyHTPSmeFS894u0hzhuL7j0nl1ylD1sdzFdL4wZK1AMc4Y5s
         PnbWUhINW5d+U5ovPMWVLcNE840FsTBZXL0RVuHZHiSH6z0tNTAT6ZKJdESY+2MJlOss
         UBjezrD681zRW/1FknkA/DnN2Lzz9s/ak+JFVH9bSiMEHaKs29UcF/fdk//5wMcLhlnE
         hpFw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793661450; x=1794266250; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xKD9YvpeuRe/dGg9UOpRwAfoOUMyefhjGpw4KelDrg4=;
        b=OfdM3aj3p2FMT8zXM3TW+ri1Q62SvlV2lp61a1beVwZjh2s7nnOXDFRRMwTICt7aMJ
         nR5p+qJhOt1EaiE7y6Fl7oSpTotVQgXNF/G10YDr3EYuRYAroBDXzx5dH6ab0yW35RN4
         rThc+9k/nxEjrFFKtvKHPqSFPjemIu7slUlRZ6J4tw+iMTzwqqAtvrzAFGrJ6OYrEY3v
         xsWfJBYUm/FUkmvpUNDAf3Sq0OFZeO+beSo57e9sp8BbAXDE8+Uk13oWqsNzZ/1wa2ix
         MduidL8omoP6bhyGTZ/Nx9vcghW2RiAWsjwF9OsbCFohUXX/gN30QlCX7YDYWXHjF5Ps
         Ss7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793661450; x=1794266250;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xKD9YvpeuRe/dGg9UOpRwAfoOUMyefhjGpw4KelDrg4=;
        b=WhNkInvn4+Ne9WRqcE9stKETQXFQJrxUt2iJsT1dlxqJM+Nk8tptHZb5W3QKIq8Ehm
         eQemcTM0lPC1fJb83LSNeXA52l6cm0FC/W+r+b63aOyG3La6i7Spx+s7QQ+QuX42yin3
         iw1xHiMyzaMK8pbVK9OshBesGvxYVAekR6uXb86OeBeF0pyoqqK1ElVNO90LAwCg9Iy+
         yObhvKok0j4xnkpLQ12P2U6v9Vx2x6vLnYl9BZvRQ8OqoexeBg5OW0B7VLmkglSGm10Z
         tUkwZwsq2I+OpHglvoGdmxlBjUvU4VuC/NbWFI9nQ7aUSRo7igWxfKsz9Gh9oTg/UAmu
         jQhw==
X-Forwarded-Encrypted: i=1; AKwUvByrsg6CN06mYYY8BkSIPJcVl+SlO+z6ADp01kRSMxjwivPg+8JhW4Cd1MomgZCkuSS7mXYicGsG+Q==@kvack.org
X-Gm-Message-State: APuU4Z/+WDncrb/qC/Pv5paORE9+UyyW0Gfcrw2xwa+wwurwf3eUx0hI
	C/DCzsRR9wHcNEtYPHZUV8SrHm6pSiD3xCjEG2iCOgxTpIS9eTPGfluS7oGYYjQuI7HpXN710pP
	6LmwcVQk0Gxq282dw2NfgSfHE357m1tXWaq1hZuo4
X-Gm-Gg: AYBFou0VkPVYqj50meXZtTrVA/c+6iMe9ZzF6rNnjmUNoW86j5AinO+l2mrISLmSBaF
	3acX7uJYk+MC0sI9uLtGSFpVUzoVxc8TQEOiLM0NDkYdjbxkQztnfIgropLaADuqQSWvnkRDwQR
	JrvY3Vs3IJYu2Z3U0lrK1RlZpIXJQjIB+2LTshHPUn/NsCDHw1yDljXl0reAIiAjh6PxkfODs6I
	6W/qdt2ZBv1URJzMATNDp0h2nNNpenbO8wrpj64hn7d3rRk6+FCXzqHPqNrtvwS2jhVZSi+eY91
	uFiNS2hF/60fuoVdU9ecjaNzIcJ0ACuw4s9rFSiHl/QfphS6CRKFjuj+T3lYv0MIlzsil2JkL/B
	hX47w+hTzzJqwOmn4Pb7GSAx0z6TFUTqznmvleJSrfiEIHE5pTdwykUFyG/frM+y09Ss=
X-Received: by 2002:a17:902:cf0d:b0:2c7:f0cc:dafa with SMTP id
 d9443c01a7336-2ecee02a602mr1319195ad.5.1793661449821; Mon, 02 Nov 2026
 15:17:29 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <cover.1792690544.git.abhishekbapat@google.com>
 <f577c773058265f0eb7fe2c10fb6aa4003445a00.1792690544.git.abhishekbapat@google.com>
 <sashiko-outbox-183008@kernel.org>
In-Reply-To: <sashiko-outbox-183008@kernel.org>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Mon, 2 Nov 2026 15:17:18 -0800
X-Gm-Features: AclHuK-hHejKvvLFEoGswR0AFCGtiaitOOypnWQKOfKmeT59R1ag4cCR_-OpHjQ
Message-ID: <CAL41Mv64927fy+w4FVzROTS2iNjRqZc8Ss=dZxuk-WqmJpoh8A@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] alloc_tag: Extend allocinfo_filter to support
 tracing queries
To: sashiko-reviews@lists.linux.dev
Cc: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9BD5FC0006
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: bdquorwwuh33oyzd6aufzydan7w1ugor
X-Rspam-User: 
X-HE-Tag: 1793661451-909315
X-HE-Meta: U2FsdGVkX196LiuUdBlNCelZHSVX2zIMxF87g2d/1t/utu1IPx3gBxvrtuZUJOd5oTQt8IqxTZWlmMEjrxX31lLDftyoor+UAVqI6pzPmvKCKa2O92C1BUGfkaXaw0l+F8zBKLjc8rJ2mHmtrZfeXz3cfBXIxUb6QaPCxaMDNrRyA4/zSrIli1MaPa4BTlJfdWJW31ZjZT9v7Q83HxaavoBA/IS8XmJEj0cB9a8XoJ/i39P8xD1nqv9ttyzGDjXeWFgn0ff3ahPx23YNCQVOPHFcpC+T82r8xI+ZsWQn88pwr/Kd5JwFAcTSDRy60bck2817NsWY6xNTDSOo9L30evVuJhFAiVnIbfQNejy4TGnUrj/k+oIn+PNuMoOaUN4GgPVApO91E+bulC5z/88WjxsN7cNG1EFwrnmSa0c5GL/c6F9aotUACscq4BxuANo2zsvBtZ82lhnlAGhrACxKzQQX8AvVXkD3z6JnK2/Zav+I8farQ9ySpJBq6REgiSCCNp6mgDMSuYh+HFnrGhDBv7QpmQuzG3B+Y5OVm8MX+K4PuQxCGjJUekqFMKOzNlnFl8ZneHUE/DLndmzm/OOjc5PmPTX/9HNfpwWtPXsZLealDKR14C0piCGgkLLfS3g6oSZmSEF3TYG1/mldatPXsitMT9m0VJmo7+ZYCMI/uCFpAJqTmL2jVy2w66QaAtYIFVpCU8vDEQzG2W5Pg9nuKtVAtYoBpxnA9sYUYydz8u9eP4gtbHb1MnqCrKOi89xSsXC6upu0LjLnW+2JniylRlmG15Xcc/gQe+DebtkD5IAzrtyCRWLd0x6KZoFJzb6q/uwj31WCGP8doXxAZFuQFUvq8knP8vYC0gJ0TKaZESglu8+HgWi0vsPRrusrm1pnNXOAlW72pAdwy/ZLh8wlf7hnVVHHXGgYKXOzPSosl5GZKqA/+mEG6NizvpuLJ7MHPo1oRGbWQCDEU8k/6Il
 DrlD4ow3
 MhrgQcsCQkNi3iocpdz+Qo8VwBSow9/8twUka2ul9qXS0C/3Y0mK5cZ4HXOuH1PplajW/WSuUTcMtp7UYkn1bQRMEPiwRJIoObu+nMc9xDwjII+5e7XFgS2NIuZr+BBi/ePfDUSUF+uDbX1Ltp1wsUqXitEAvcjbxeUXlD+qrIIqUqyY0pAgGuZbWmcy44TdDE8yVw/Z9DOh0qTNuUfM6umo194cOtaZSZiAvfWUs/bTjdI0jCYa/d6c9UjiF0ezgYPDX7UhfVXIMU0bhqxjDjDHQpCNgeScmLXTgH2XGAAcEGEa9Xh9IWft4Q1cT0qLx0bdXX0Urkfg0gSUPuxtuCLHd41tJsVWf++hvgpbJzhndQB3fBqdRUmc3z1tZ6HjGbg6k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 10:38=E2=80=AFAM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [High] alloc_tag: UAPI breakage in ALLOCINFO_IOC_GET_AT from growing al=
locinfo_filter
> --
>
> commit b1243e6bc8216f5fe9d8786ec8ca3a597c41681f
> Author: Abhishek Bapat <abhishekbapat@google.com>
>
> alloc_tag: Extend allocinfo_filter to support tracing queries
>
> This commit extends struct allocinfo_counter and struct allocinfo_filter =
in
> the alloc_tag uapi header to report whether tracing is enabled on a tag a=
nd
> allow filtering tags by their trace state.
>
> > diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_=
tag.h
> > index dafcba2f7e2c1..a96054ac22376 100644
> > --- a/include/uapi/linux/alloc_tag.h
> > +++ b/include/uapi/linux/alloc_tag.h
> > @@ -38,7 +38,8 @@ struct allocinfo_counter {
> >       __u64 bytes;
> >       __u64 calls;
> >       __u8 accurate;
> > -     __u8 pad[7];
> > +     __u8 trace_on;
> > +     __u8 pad[6];
> >  } __attribute__((aligned(8)));
> >
> >  struct allocinfo_tag_data {
> > @@ -54,7 +55,8 @@ enum {
> >       ALLOCINFO_FILTER_INACCURATE,
> >       ALLOCINFO_FILTER_MIN_SIZE,
> >       ALLOCINFO_FILTER_MAX_SIZE,
> > -     __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_MAX_SIZE
> > +     ALLOCINFO_FILTER_TRACE_ON,
> > +     __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_TRACE_ON
> >  };
> >
> >  #define ALLOCINFO_FILTER_MASK_MODNAME                (1 << ALLOCINFO_F=
ILTER_MODNAME)
> > @@ -64,6 +66,7 @@ enum {
> >  #define ALLOCINFO_FILTER_MASK_INACCURATE     (1 << ALLOCINFO_FILTER_IN=
ACCURATE)
> >  #define ALLOCINFO_FILTER_MASK_MIN_SIZE               (1 << ALLOCINFO_F=
ILTER_MIN_SIZE)
> >  #define ALLOCINFO_FILTER_MASK_MAX_SIZE               (1 << ALLOCINFO_F=
ILTER_MAX_SIZE)
> > +#define ALLOCINFO_FILTER_MASK_TRACE_ON               (1 << ALLOCINFO_F=
ILTER_TRACE_ON)
> >
> >  #define ALLOCINFO_FILTER_MASKS \
> >       ((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
> > @@ -75,6 +78,7 @@ struct allocinfo_filter {
> >       __u64 max_size;
> >       /* filter criteria only; see allocinfo_counter.accurate for actua=
l accuracy */
> >       __u64 inaccurate;
> > +     __u64 tracing;
> >  };
>
> [Severity: High]
> Does appending the tracing field to struct allocinfo_filter in
> include/uapi/linux/alloc_tag.h break existing userspace binaries calling
> ALLOCINFO_IOC_GET_AT?
>
> While struct allocinfo_counter consumes a byte from pad[] to keep its siz=
e
> unchanged, growing struct allocinfo_filter by 8 bytes shifts the data fie=
ld
> in struct allocinfo_get_at and changes sizeof(struct allocinfo_get_at):
>
> include/uapi/linux/alloc_tag.h:
> struct allocinfo_get_at {
>         /* inputs */
>         __u64 pos;
>         struct allocinfo_filter filter;
>         /* output */
>         struct allocinfo_tag_data data;
> };
> ...
> #define ALLOCINFO_IOC_GET_AT            _IOWR(ALLOCINFO_IOC_BASE, _ALLOCI=
NFO_IOC_GET_AT,        \
>                                               struct allocinfo_get_at)
>
> Because ALLOCINFO_IOC_GET_AT encodes sizeof(struct allocinfo_get_at) via
> _IOWR(), and allocinfo_ioctl() -> allocinfo_ioctl_get_at() in mm/alloc_ta=
g.c
> matches only the new command value and copies sizeof(struct allocinfo_get=
_at),
> won't userspace binaries built against the previous uapi header fail with
> -ENOIOCTLCMD (-ENOTTY) when invoking ioctl(fd, ALLOCINFO_IOC_GET_AT, &par=
ams)?
>
> [ ... ]
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792690544.=
git.abhishekbapat@google.com?part=3D3

Hi all,

I recently discussed this with Suren and we realized that the IOCTL is
in v7.3 so this UAPI breakage is a legit concern. However, we have a
workaround for this. We are going to convert the inaccurate uint64_t
to "flags" where the bit 0 would be a check for accurace and bit 1
would be a check for tracing. This allows us to extend this UAPI
without breaking the previous versions. I will send out a v5 patchset
with this change soon.

Thanks,
Abhishek.

