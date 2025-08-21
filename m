Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC92BCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 01:26:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37CD18E002C; Wed, 20 Aug 2025 21:26:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3068D8E0002; Wed, 20 Aug 2025 21:26:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F5BE8E002C; Wed, 20 Aug 2025 21:26:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0AF538E0002
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 21:26:11 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C5755137926
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 01:26:10 +0000 (UTC)
X-FDA: 83799023700.11.B02C7E0
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf05.hostedemail.com (Postfix) with ESMTP id 22C61100007
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 01:26:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DXf7kKTp;
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755739569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UnEnB+OmfWctn0N7nbpiwPaAHdKfBNMlU6IYB1kOEBY=;
	b=tGVf+Tky9OBl9jBFygANDvWq7eQuwHBt2vhzZrYN5VktZ76PEimRfbrtizyR8G/wM1QDfX
	tsMe31dHX7oTdLAGVZD7hl1Fx6cgkTRZQBb9NxlNHw8xAV5L7No5kxevE3VCILb4Zw1VSf
	mf+eiWVRnhSN0CbUGbiWxAR3UVqQeyc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DXf7kKTp;
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755739569; a=rsa-sha256;
	cv=none;
	b=yNBvEl/ISXna7biCSo5FNFITBFWFJvhxj87uD+J2Vzz97NNoG3qdekssER456i32WCQlv2
	WyNV4iNVgFlC/vGkVrbnNmuRIJ0qrSVUCHJmu+mvbZmPr9xS+KuDg9Axz7LXIXuG9CVW8H
	GrmOyoZoJNHxs7seJSvkbJAh7LcrcJ4=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4b12b123e48so157341cf.0
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 18:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755739568; x=1756344368; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UnEnB+OmfWctn0N7nbpiwPaAHdKfBNMlU6IYB1kOEBY=;
        b=DXf7kKTpx/ghqEljsceFY3e9Uh128T3rhfQc1QNr8FZpZDBPz0cf+7kk91iLlIego9
         Q6WzUP36ONNcU48p6QhYgXFvjvWt9EXUEVfPmLhUUDHyT8pouj1bfgnj57uRokqw7CL0
         tkGq+2H2imZAhqptHXrkVMg6Sd6s2hpW0ifnFwcLGAyZ3ri9Y7Uf0xhxMo9NBeZxL+nn
         2eH/sQEeUODWE4a5FGk1/+bvSUPVYyiRjUbxSLIglHd0K6+tvS5ClmZDIKFVXLjuc0r7
         K4iEYidD0/W5kMbb1lGVeGN5IZOiKDQBK/2Nv/SihvfKyKTUoRFppitkPUkqCxwodTdl
         E3Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755739568; x=1756344368;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UnEnB+OmfWctn0N7nbpiwPaAHdKfBNMlU6IYB1kOEBY=;
        b=ZYZ1SpH6Vh36JR7rO2BzTt1WPnwNhE87OUIpwb5D3qrmKnCIvLAVC8E7UYkdEZ76AE
         BGhxb6/ta44E9PZg96gPE7O+aBFDOOVarNIw9zwgIRBQEkMOb4Xq68WrG8jtyAW7EDte
         LdSd9JrqFieQPxhNuxYkdQnbPmOypc57iylZ9n7gbT9st6pwd9M2y3q3vxUSNyBo1C9y
         EnSY5dC3Qt9ThwfUNzRym9j8SY4JliJlf/ezS0EIn9ebsqvbjuGbtuxaHoeS7PMQObW3
         a9EfIMJA8KnFYaxIsp9xAlroZAg86GwVLluub/JRo34Gw9/gZryDz/22zcR9bRbgxM4R
         tc0g==
X-Forwarded-Encrypted: i=1; AJvYcCVnY2MJDQB8XOJGn7WQy8alLJFO430qOPkpScYRPRN9+zOB0STWy5Ztis95kMZYXiOpE4l/CDRk0g==@kvack.org
X-Gm-Message-State: AOJu0YwsvBbwyEaRDp37hXBGHLRoVUAmavNkaFPYUf9ZWQ9esChpqwP2
	D7itaMV/hZwgvuuUFDZULx6KlG/KhzOFKV5hcNJ2aNdSh6DkD8QHKfq/jC8NI/QmsVGN3oCHmzP
	sxrpklrITmODq8JrySjJOLZbq17KLfviOgNdn2XXE
X-Gm-Gg: ASbGnctGeyspWZ4WhopjElqbj0FsrRCEZTKBBLhdizUAHGN4ryF6xXzwQfSCgqshwzc
	3FLFzUOqXWUS6TXMHePjAUQvC0x1aCqzBampUybL56I+G+/SiI27AA1xLu+EElnhReIvjY/2Ci9
	i8dN+vJbxN7+JsqmFM1IFTBpE7KY5a48nkOEnxZkb3krxJMq+Euiw934KpUOKt+rIYcDdExsAHW
	ItyntHLjvdwK159MIaLMfw=
X-Google-Smtp-Source: AGHT+IF25yXOemiZH2ZR4Arkb61fkkHIrHwpV+wk+bChi5o1xR1rtRMEG0QaE7vvEbDuUircQFhw++4IAgrYcJ5sqPA=
X-Received: by 2002:a05:622a:1aa0:b0:4a5:a83d:f50d with SMTP id
 d75a77b69052e-4b29fa06aadmr1313601cf.11.1755739567869; Wed, 20 Aug 2025
 18:26:07 -0700 (PDT)
MIME-Version: 1.0
References: <790da5ffebf18a5a1211ad8dbe4e5b4a19871408.1755190013.git.pyyjason@gmail.com>
 <20250814201114.1921580-1-joshua.hahnjy@gmail.com> <aKM3j3geY7JiPGQ8@devbig569.cln6.facebook.com>
In-Reply-To: <aKM3j3geY7JiPGQ8@devbig569.cln6.facebook.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 20 Aug 2025 18:25:56 -0700
X-Gm-Features: Ac12FXxfS-7fdVyZ0dA_OJvGZ-bAD31CipxCzxMcWrdx3YWMjTVoIUgJPZr-Bpg
Message-ID: <CAJuCfpF11tbq7eEhzJ-7cneGKXDg5cxQrdWNVo1whyLuFQGzmg@mail.gmail.com>
Subject: Re: [RFC 1/1] Add memory allocation info for cgroup oom
To: Yueyang Pan <pyyjason@gmail.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Usama Arif <usamaarif642@gmail.com>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 22C61100007
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: n8okf9tbgfn97n61y3qnm1ub1sxbdxqy
X-HE-Tag: 1755739568-978
X-HE-Meta: U2FsdGVkX1+T+JSWSsANAyZpTJORfCEcZ1KYi6eGrtpZs2ioo1UzCsxaponcPsMXvvXuFjVVH9Oowr95hXyJqAJ2/t/xoafvdb/1lLlvbvcu51oI27Dt6PhAtbiZ3mucsTzw0dOV9VL9rrOCYETml/OEQk4ngfQmOIhiWg9aP6wcw8Q40EOp9y3taPkulJsjMgz/iRxNcRKwVfvFUTP8NMjNK7pab7FOEX1KxVQKEcU+7Hw2qBPBBaMr2nEjoJDuKNuzhhb/bXY5XAnR+sZUISy7h3CqzuvKLXBqaV+34uUSMvsNhFtXvVE0s0GeG2AvTsOsMs6zJauzva7UauwdgcfRMLZSdeDyLsuo6k9WuwYz/aJzH74djyoAiEwvVhUe4xe4axO8Odw+Wj4uMLtHHDsMykxCcpgqfDYEAzgwhUasOFwvBT+jaadGWb87/oxJ/NHLcxM4iWYfKdwofK4z/gRRISEMd3MAcSRJZgFQC/3seeNru/PS/drnLOpTrB7raqxoLKjT+eIY9u/OvZvYMROevhT1DlHSvxX9z9ehsP/pJZhHOKRIw4AWiemsSAQ0gGPL65FNclEQInXzrtch3pHaiQyAqHODGqy7SX6YfxoIH5z2L3SmBI74RX6WWT8lAcVsuNsv+QToHsbirSSU+F3jy3TEoPU+6AQ/I/k1MjCLGMSVtwS8xW4qvra+cOVbCb4UWdfpSnPMOFOK73IszAwfem0yZKLBkuudJ7NcuKMOsAXCEL/SJmb6qp9WFKi9zs0i/hL9BVz9nAGe3qk5w5Yd2BaXbpVCWGBbwo9AfQuvVz6DXzMIsmOI/U1WeK5mPd4kCKv5dRgJuwK66hwbJ+E44o6FR9Pt4g9C8QrOqgJn7CO3sfN/KiqNiKC2f29scwTpo/Y2ar1xPoQAj7iJAz3mIGtbVNrcfAZxxR7cJh1wwuD+ExSbb2k+XM5MtDOH5cZ/FW6FkAmA+k5IiUG
 wCfkczr/
 MvcjwY9Jt95uawYc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 7:24=E2=80=AFAM Yueyang Pan <pyyjason@gmail.com> wr=
ote:
>
> On Thu, Aug 14, 2025 at 01:11:08PM -0700, Joshua Hahn wrote:
> > On Thu, 14 Aug 2025 10:11:57 -0700 Yueyang Pan <pyyjason@gmail.com> wro=
te:
> >
> > > Enable show_mem for the cgroup oom case. We will have memory allocati=
on
> > > information in such case for the machine.

Memory allocations are only a part of show_mem(), so I would not call
this change memory allocation profiling specific. The title and the
changelog should be corrected to reflect exactly what is being done
here - logging system in addition to cgroup memory state during cgroup
oom-kill.
As for whether it makes sense to report system memory during cgroup
oom-kill... I'm not too sure. Maybe people who use memcgs more
extensively than what I've seen (in Android) can chime in?


> >
> > Hi Pan,
> >
> > Thank you for your patch! This makes sense to me. As for your concerns =
from the
> > cover letter on whether this is too much information: personally I don'=
t think
> > so, but perhaps other developers will have different opinions?
> >
> > I just have a few comments / nits.
>
> Thanks for your comment, Joshua.
>
> >
> > > Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
> > > ---
> > >  mm/oom_kill.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > > index 17650f0b516e..3ca224028396 100644
> > > --- a/mm/oom_kill.c
> > > +++ b/mm/oom_kill.c
> > > @@ -465,8 +465,10 @@ static void dump_header(struct oom_control *oc)
> > >             pr_warn("COMPACTION is disabled!!!\n");
> > >
> > >     dump_stack();
> > > -   if (is_memcg_oom(oc))
> > > +   if (is_memcg_oom(oc)) {
> > >             mem_cgroup_print_oom_meminfo(oc->memcg);
> > > +           show_mem();
> >
> > Below, there is a direct call to __show_mem, which limits node and zone
> > filtering. I am wondering whether it would make sense to also call __sh=
ow_mem
> > with the same arguments? show_mem() is just a wrapper around __show_mem=
 with
> > default parameters (i.e. not filtering out nodes, not filtering out
> > zones).
>
> The reason why I call show_mem here directly is because cgroup is not bou=
nd to
> a specific zone or node (correctly me if I am wrong). Thus I simply invok=
e
> show_mem to show system-wide memory info.
>
> >
> > If you think this makes sense, we can even take it out of the if-else s=
tatement
> > and call it unconditionally. But this is just my opinion, please feel f=
ree to
> > keep the unfiltered call if you believe that fits better in here.
> >
> > > +   }
> >
> > NIT: Should this closing brace be on the same line as the following els=
e
> > statement, as per the kernel style guide [1]
>
> Sorry for this. I will run checkpatch for my formal patch definitely
>
> >
> > >     else {
> > >             __show_mem(SHOW_MEM_FILTER_NODES, oc->nodemask, gfp_zone(=
oc->gfp_mask));
> > >             if (should_dump_unreclaim_slab())
> > > --
> > > 2.47.3
> >
> > Thanks again Pan, I hope you have a great day!
> > Joshua
> >
> > [1] https://docs.kernel.org/process/coding-style.html
> >
> > Sent using hkml (https://github.com/sjp38/hackermail)
>
> Sorry that I forgot to cc some maintainers so I added them in this reply.
> Pan

