Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8275E87842
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 16:31:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D7886B00AA; Tue,  3 Feb 2026 11:31:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08EEC6B00AB; Tue,  3 Feb 2026 11:31:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA81E6B00AC; Tue,  3 Feb 2026 11:31:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C99CD6B00AA
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 11:31:35 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7179C139322
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 16:31:35 +0000 (UTC)
X-FDA: 84403686150.21.2C24FC5
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf23.hostedemail.com (Postfix) with ESMTP id 45B2B14000A
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 16:31:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SM+DPqiB;
	spf=pass (imf23.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770136293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DDXM1QX9aKS9kUkXf1pGpmDmgRr97TT7vac81474lko=;
	b=G9mpA/jk8jsg1fT5rAx9++aM8X5zQO45zFlP2hV97IhvsIu7y/7yOVDJUM3Np5iDK0sH4a
	7BZuf0j1JtBxUMB/MziZ927EVqu1cB5xst155IBiJcVXWs8H6vQEse7p6RqwEajGd/XfEI
	cujlfVbRfaGr+BK46Q0zRYMhHO3Rpo0=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SM+DPqiB;
	spf=pass (imf23.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770136293; a=rsa-sha256;
	cv=pass;
	b=kMGX4DPMKqB7TOFk0eGEeX3F2xnIWcTIcyILIvePqZ8ezeUv0Tel4S9zbvrtd24BFeGj/B
	KQKUW+LMb+Jxd/Cd/AMz4pNLApGxG3Q9LvCTFB+gDlG4kcyjmcgiE5tklbHs9RPU5j7aBG
	Z4A6Ftw1VcbqutWXvTZjlGN7AIzYphM=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-48068127f00so49912345e9.3
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 08:31:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770136292; cv=none;
        d=google.com; s=arc-20240605;
        b=ALebt5dQuMl1scK/AhRqUCjLPSKzTz2+xzmkF/b9GLfgfYh8U64fsyQfd+OzJ4Oyrp
         ZgMtD1xFt/+nwiOsl975MNHkOrMLqnjr9yxVGuUxvuEW6GPN4NBiyND/syj6gC5WYM8Z
         gvr0bRP3/6YVxB2+kEP91/5hK2CwMb0X06UdGtCl9i3RHxKkIgK9K3mlBnvLwTCGeq4x
         sbokOernjJEDXSqCZfsIZHaIAj80qDnz9r9yXrbOWJiLgQh/J/bQ88qoIKeYNd5+ItDK
         CZ8O9gDctoj7kD/Vljn/K58seIdfoWEuIyfPY8CMciOjDD+CWSGcNJJrUdVKcMXHqYQa
         Vw0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DDXM1QX9aKS9kUkXf1pGpmDmgRr97TT7vac81474lko=;
        fh=kZ920d1niXkDa6okL3Avh1qs+9phTkR1xlicjkQ/o2U=;
        b=gnjlfujMM7uOsC2x3SxLxfeUtdO49oq/8tibByqwy2MBznGaZ7lHfQTfV02XNsqEIA
         HxkLw3Cz25v2i0/pRVZDFiV7B9ZwVXeUAQdD7bslsFHekT/sRd8ySizby8YLxueJgH2U
         yfdHg5o8A8gSn7QjcfO+X1nplluXSqd8oNs6x1oZ+hPM+wYi8CGbfjdxSDvostOpEiYL
         fliYA16eE2SIcx1TwdV1SMQMz5epCl46LKO2GZlty/md56I04TXhRs9sjK14O8RvByxq
         W/XzZvS1MsnDq/JFGQoYtWhSlJyRUx7izYLdtDDbvDKq6uLKPXR6vCue8ftIMXQUQ9kA
         3AjA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770136292; x=1770741092; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DDXM1QX9aKS9kUkXf1pGpmDmgRr97TT7vac81474lko=;
        b=SM+DPqiBSZrQoUAysLUc8hkQw1xUfuaXZ8lImI9lNVkdpmAASjjhcO5QwcskWVPLjs
         yKulO3afP5HEuKVXsBZtwifIXRfhBeS6clf/fAo7vm81CXvhb4C3l2Az9mruEheCOK9w
         iJxXKhCRflOCnikwhrRgvLGMd5jV3bVJRkdLrfFtbMNfTiplnLrrccNBw/PisabMPdBA
         uCXqD32/+DDxSflIac5sQdKHvkg/CskDBnOCNhFEVQspVbmr0eZrvinomwc1oo3PYHI3
         FqnNzWS90W44C2wEp6gHF33lHYjUrC0jbGMEixkYtQ6EJzgKJhEutNp+NrVu2yugHEHW
         DOLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770136292; x=1770741092;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DDXM1QX9aKS9kUkXf1pGpmDmgRr97TT7vac81474lko=;
        b=DvjqTweVxWSbLnpasUwypUkAdVU3YZ8enyAiXGNF0ciDf72oe5sTLDvv/pDIt8FCb2
         d40kzP6mL7+JFN5tv81jxa32hpruAGfre7B6owHJMOhqmCdl63NH73FwgKPIoK2vEAxm
         z/Hp3CildHoeWGs203jED8tV8yrvQEaJ5Ab31U7YSLrP/P8Hx9P85xAvP0uAzk2TAYPF
         FWzhLWEi6QBWbtMdseFhfX4Rj5FmMv8MmLgoK9C8nI8c5D13DFISU0UI8cNxLUZgawJC
         WdBci8RhNeW90qLcy6vrAw+3zditJae4pntg8KFVv/aQxrTPYW/lxg84WNEAJvpMVBqz
         p3Mw==
X-Forwarded-Encrypted: i=1; AJvYcCVI8J7+TlhYz/3t75YFE2TFfDRIMbrDV6Qo+Ts3rai7w29/CHUQImkaEgRO8s0xUSxn/UupUvITyw==@kvack.org
X-Gm-Message-State: AOJu0Yxqu2w4H3skPtQyceiA9wLft/xUKyMYyYGjTPKhEu9dO55/2Csy
	kf6j2Ok6CyjnmehmxZar+Q+Nf1IN0UZDNGPQQ73POZXAGWRLbZdpTa0YZLsvJyQGYnJh3FNkuHq
	l1djw9XdkGunxWx1Tr1f+QC4F999uTtM=
X-Gm-Gg: AZuq6aKZYfs3mH8/nBr4umNSfGXwvCH9J+c+fnSNZmz+k0jQKEqCGDpiLstYBgYOjzV
	TSzXaLw9+xIOrCgFfIzgRC+jqwfm7BYFXrbgLRDPl2EtiulV/pXuWd+lb3wO83r4QvCFFH1H6mB
	zpyKPvQhpxKPeQWg9WG4t5GNpnxrXPtXZ7IqEo3nJQxnaewzRNncPhM7+JZufPD9yjSBSxls/xb
	+ZbpYR2/gCYVllj4iClYb8+lStZf/6XCeoQo5ggVqipYQGzHcBG+wZ7rvmZ/31ls559jPwjfsz4
	0LDSWEtZU1IP5mLp1fO4n2gXHMg3u0UOCD5C7lprPjmEVqs9On6dyqm5SSPQPLqMII+UG91mNva
	DD9eS
X-Received: by 2002:a5d:5f54:0:b0:435:95c9:6895 with SMTP id
 ffacd0b85a97d-435f3a72dd1mr23007611f8f.18.1770136291408; Tue, 03 Feb 2026
 08:31:31 -0800 (PST)
MIME-Version: 1.0
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
 <20260127024421.494929-11-roman.gushchin@linux.dev> <aYA4pH_nIBZ-ZhLL@google.com>
 <CAADnVQL5g8imKNGbHGQ4HA8_qNT4MYwM8P3aCTFUG7uwiuTeuw@mail.gmail.com>
 <87jywuwumq.fsf@linux.dev> <aYH21HhwNvWnFB8O@tiehlicka>
In-Reply-To: <aYH21HhwNvWnFB8O@tiehlicka>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 3 Feb 2026 08:31:19 -0800
X-Gm-Features: AZwV_QgPYD_QDDRHAxK8hl8lHjXdNa7m94_zYgqz9AxBSjsI0Bt6TxB1mrjzf8o
Message-ID: <CAADnVQ+uF4cTVYYOYBEDWrkLXJJkru_FaRttFskHRUpamktMJQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 10/17] mm: introduce bpf_task_is_oom_victim() kfunc
To: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Matt Bobrowski <mattbobrowski@google.com>, 
	bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, JP Kobryn <inwardvessel@gmail.com>, 
	LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 45B2B14000A
X-Stat-Signature: zat4gxr8rbykbciesrntco311x9pb4y8
X-Rspam-User: 
X-HE-Tag: 1770136293-716621
X-HE-Meta: U2FsdGVkX19OZpjmYccOKf/4wo01K5Fb1oqpLRsSv060a/SxD+wktfluLZwThbt3f1XKZJvYjCW8v8w/0P1BTdlcl8oUJKG8/MnlnQbHDbT2EKHrL5LBlK4jBDMtGqNH3O94w/ZXHI+yLfdvctrZSwcLHeHBZIuOTqiZy4gsQfBN6P3meZAaD+SCtX5+JoFawMD/E7+RKMQJh3/zE2h++jy0F4VRylmygonRx0MkIhJ9H6t30bs7s1AqI8gV6krmB6j1sIe//kj+mJNBZwoQxGvdpUh568wQU7DrVPZaV8UNT8iKqSINYT48Gx5sXX8/y/2TelT/XN+dXukmSXNPyenMvZMK4EkS4t7p6qx8o/uGZdEia031+jOStTypSAIQbK4uA605tsXF4RTBJF102QvL0iUXcZb84jRQaXxGQ/+veclUDDYtb7eFcMrWFjVSF9s4I0qUon3Xe8BlLdZ+r+buAi7ze8UfeEYE2Sm1dtyOvrBRQaqozod79JGNXpdfHy1zTc4//iIWKQKHj/2umnRVOur6/lX1qjZC9VmGmTI7ENeWEdmmDCtsoq1vRkgcWyaw+Axg0nfO9gIhR9jqUNNh50pVv6+pyjduTOddH0MI/303rj1pMwrCGcWUAmMIA/aYR/2AZ8f68pCrytkENkEr/86ChTxJzmCEZyxEvx+JKHJ4nh9Rx7rAI4fg5vQa0g3ERrcm/VDQqapvpfxP6vC0ZADF0/u5mhH/19vHNb4YTswem/9JuCUDRaI8GN8ClP++gOFfbOew3RCbaEzyeNDNJ4zy97RhTkGEoVOKsv6MVW1DuCMHe5VnQis0V66rcD9bahmVZPEesvUYwmFTLDBuFC3u1V6AhBP5SP3SFaJU3nvuTw72z61GUQBfE71AqLNkfGyFvx5ZIHlfTXgxOkcrtkFAReXCiVGyHpmHyw0ex+8K70htDzuQ7sudsYWgBTwugVUcjSWd/kWaA1H
 LUSnKOXB
 9QIe8th/j0hWSSHy5glagDxw+pogDisailDOJWOVWLWYFsqfpkhyNyOvY+r2+deNhEeXtFh2BcqbDTPVzs927oXVGiO+o3MQWWoH/zC9fcBxCEMlwevP9NE4GlaEXcRwZaJBO5k80Yb871VNyXxUr4AxNtAxxM9xD2W+ZnmW6reDKJjDL6Ihc2btcsb37aHBeAwFJ2F5UzmEmRCXs/agtWHAh5XqvZJdJKLozyEOauex+ZpwyMyfPUVM4EpHm/mRuNYP9IXFU3s5tYwLFqGP1KAiKlCZkxrzKiUv6f+IgS/4Qx5/azAE6EM5xvz2Ow7LUPPNYZw0PlMMkDWzB2sqyRkRnXgkNJNmdrl3adi8Jtq1Vc911NYToZFMd/3x7Md1MqjODm6NuQiihqDLOpWp76nxNvst2nE3q3h496u+MYmNVla+4DTQs5huRVCtvir6lh3BYeXdWGLKizoYDGyTA6FW90n0FUC2iUG3N8wZekHb4gDdAh3nnQ8jaad3AR5vEAaLtHbYcxQ11ka/e1Lr+6veQC6KKELnDTdGu4PtM8PD6BXipN1jmVWH3FhFm7ZwOYephPnjTmQwfJyg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 3, 2026 at 5:23=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrote=
:
>
> On Mon 02-02-26 16:14:37, Roman Gushchin wrote:
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> >
> > > On Sun, Feb 1, 2026 at 9:39=E2=80=AFPM Matt Bobrowski <mattbobrowski@=
google.com> wrote:
> > >>
> > >> On Mon, Jan 26, 2026 at 06:44:13PM -0800, Roman Gushchin wrote:
> > >> > Export tsk_is_oom_victim() helper as a BPF kfunc.
> > >> > It's very useful to avoid redundant oom kills.
> > >> >
> > >> > Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> > >> > Suggested-by: Michal Hocko <mhocko@suse.com>
> > >> > ---
> > >> >  mm/oom_kill.c | 14 ++++++++++++++
> > >> >  1 file changed, 14 insertions(+)
> > >> >
> > >> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > >> > index 8f63a370b8f5..53f9f9674658 100644
> > >> > --- a/mm/oom_kill.c
> > >> > +++ b/mm/oom_kill.c
> > >> > @@ -1381,10 +1381,24 @@ __bpf_kfunc int bpf_out_of_memory(struct m=
em_cgroup *memcg__nullable,
> > >> >       return ret;
> > >> >  }
> > >> >
> > >> > +/**
> > >> > + * bpf_task_is_oom_victim - Check if the task has been marked as =
an OOM victim
> > >> > + * @task: task to check
> > >> > + *
> > >> > + * Returns true if the task has been previously selected by the O=
OM killer
> > >> > + * to be killed. It's expected that the task will be destroyed so=
on and some
> > >> > + * memory will be freed, so maybe no additional actions required.
> > >> > + */
> > >> > +__bpf_kfunc bool bpf_task_is_oom_victim(struct task_struct *task)
> > >> > +{
> > >> > +     return tsk_is_oom_victim(task);
> > >> > +}
> > >>
> > >> Why not just do a direct memory read (i.e., task->signal->oom_mm)
> > >> within the BPF program? I'm not quite convinced that a BPF kfunc
> > >> wrapper for something like tsk_is_oom_victim() is warranted as you c=
an
> > >> literally achieve the same semantics without one.
> > >
> > > +1
> > > there is no need for this kfunc.
> >
> > It was explicitly asked by Michal Hocko, who is (co)maintaining the oom
> > code. I don't have a strong opinion here. I agree that it can be easily
> > open-coded without a kfunc, but at the same time the cost of having an
> > extra kfunc is not high and it makes the API more consistent.
> >
> > Michal, do you feel strongly about having a dedicated kfunc vs the
> > direct memory read?
>
> The reason I wanted this an explicit API is that oom states are quite
> internal part of the oom synchronization. And I would really like to
> have that completely transparent for oom policies. In other words I do
> not want to touch all potential oom policies or break them in the worst
> case just because we need to change this. So while a trivial interface
> now (and hopefully for a long time) it is really an internal thing.
>
> Do I insist? No, I do not but I would like to hear why this is a bad
> idea.

It's a bad idea, since it doesn't address your goal.
bpf prog can access task->signal->oom_mm without kfunc just fine
and it will be doing so because performance matters and
static inline bool foo(task)
{
  return task->signal->oom_mm;
}

will be inlined as 2 loads while kfunc is a function call with 6 registers
being scratched.

If anything changes and, say, oom_mm will get renamed whether
it was kfunc or not doesn't change much. progs will adopt to a new
way easily with CORE. kfuncs can also be renamed/deleted, etc.
You're thinking about kfuncs as a stable api. It's definitely not.
It's not a layer of isolation either. kfuncs are necessary only
for the cases where bpf prog cannot do it on its own.

"internal thing" is also a wrong way of thinking of bpf-oom.
bpf-oom _will_ look into oom, cgroup and kernel internals in general.
All bpf progs do because they have to do that to achieve their goals.
Everything in mm/internal.h have been available to access by bpf progs
for a decade now. Did it cause any issue to mm development? No.
So let's not build some non-existent wall or "internal oom thing".

