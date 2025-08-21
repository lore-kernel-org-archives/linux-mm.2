Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DE21CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:00:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FDF78E0026; Thu, 21 Aug 2025 16:00:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D58C8E0023; Thu, 21 Aug 2025 16:00:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EAF68E0026; Thu, 21 Aug 2025 16:00:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 699818E0023
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:00:53 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 19BCF594D3
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:00:53 +0000 (UTC)
X-FDA: 83801832786.07.E4FADF8
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id 850A31A0020
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:00:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jOZZ0LNb;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h7gJCHVPk1eVDB8ZTXpaMfDlbr0NY9UdnbibKYbMlLY=;
	b=wW8xf6mTrEiOnKp6j5ZfFxLRJFHal2g/4JuRDeHYGNUs3eZwql2XbBqxm21MBgmvr8Kb5M
	5SV9nKVCEZXi3MwKptGiUt6RF+b3hlgByX8Fj7laRZniTYPYFuBhfKFU8Idc1DeseGXXrS
	pydKQsv2nZkmg//c5VBV8sj/dzbZKs4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806450; a=rsa-sha256;
	cv=none;
	b=bG/NUSUK63pNH9cuHp0ew4ZjeZKLBnlnm//Rw19wSJy53YouggVwItiL8cEGQyO/xZM8wz
	dWaYbdYZoJBWxyXEv+vP2WorFO+WRaQl95wf+uzva5p7txfLBwQj/6JblF8NEdlMDo6gQI
	XmHTIcotw8kMSUC9SnXrR7AE0AsC8So=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jOZZ0LNb;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4b29b715106so17741cf.1
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755806449; x=1756411249; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h7gJCHVPk1eVDB8ZTXpaMfDlbr0NY9UdnbibKYbMlLY=;
        b=jOZZ0LNb9t9NDWiCFrQaXmgkhYqtzgfW0DzVvdrUoSZ1W1PQw1AUQ6gm50DZxhNIsZ
         xYeCwnfEvBJ2jVZ0Azw14BFuq8ri3CQlaz6IrKx3DBRgbXuU7W6BT33CA1exMs7fpisL
         fIH/vg+Yudr0R+D1cfJnLvI0pdCtK6RFg86HS8iDn0ZsBZrLnbxpJe9JhwvfOL4wCbkP
         Iq9Y6H/2qHMSph/MZPrc6UdGjTJ7EOyR6AQHmMBT069bysGmpMIDpMa6cWMtBlQT9wYK
         wouGyKQ7Xbe8QNuzS5Gdj3DAcI4DPZppyR/X1YmxliSt85Rd1OTWSRIVfWnjmuIHQ8fd
         p/HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806449; x=1756411249;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h7gJCHVPk1eVDB8ZTXpaMfDlbr0NY9UdnbibKYbMlLY=;
        b=PE4lrseYQT4v5YVCANbkxzy0yj5UM+JBkGbpHQNbWvDI/lXbr9r20ref7crAxgH2h9
         wfDJWnWJ+t4HRf4W26wksWamQDGtIx7EV8aWfPnYhd97brYania/G6O+XfgCw5X8ZSW7
         G3IOWuADpCnxWnk/8Ht3pN9597HLVPlp9iEFCNX8za3ihUgUShqvtsv8xsGYvS/IXps5
         cf9BNAvMhfvUH9PidNC+2FDyzxnJahMCgSyEggv6Y2oDBLEwWYer6j1W/pkEeJxrFW+t
         l1NeERrjBrFFRATHv07lcKM9aAzCinORu9CEWxP4XjALNX5H/j8hATWiHlqqFAtARfBf
         ZxyA==
X-Forwarded-Encrypted: i=1; AJvYcCVtQ49bzXB8hJclbq+yunwqebQlI7JO8MoW3MeR6rSCU6POxcUDC3KqYuUFbV2q2Z9iVcYi9lI2VA==@kvack.org
X-Gm-Message-State: AOJu0YwNUzQi/Up2DNvLrP2+sIUDnjV4bQB0EQUNyO62iSpcfQiAzByF
	e47RrbO85Oyfam9o4r7f9x+1g1TEPM7xD5MN/13jXy8y5DcSvildeWtcq+cGMTKT862nkgyIze/
	ELmUzkA0vAuvIKrtGnwEPQh3EljVMXtFu3jTcJrXg
X-Gm-Gg: ASbGncuRILoL3Lf3JsUXxGa0f/q7VyNkxGYzdujgiE+JAFmiZKnjnFE255yEpPgSQoo
	4Clw9+HmiO1lFO3NKS5jiqWl9AGYGCWbtAp4wFylWnPTMtbdjCGpaSmOMpuYZ0v1Dd3WWj3Qku+
	rlFKyJxoRNBzimahK2iGNgxqo5kSzITvIbh/e9AAl/F1Is2BRabqLImMADuk7LGyMKak7TBgs5r
	S4u2zxdq+RilxVNLGhBcTTPyHt+xzoLI2zQwMj9DQ6m
X-Google-Smtp-Source: AGHT+IEzwI8DU6U71/goi7II6qT6paOqU3wRI481Im9qvHexJ8TSWQvjEUvaTQ3LFEGgVCkz44r9UzcLBG34+vGrxao=
X-Received: by 2002:a05:622a:7690:b0:4ae:d28f:b259 with SMTP id
 d75a77b69052e-4b2aae5802cmr801011cf.1.1755806448915; Thu, 21 Aug 2025
 13:00:48 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1755190013.git.pyyjason@gmail.com> <6qu2uo3d2msctkkz5slhx5piqtt64wsvkgkvjjpd255k7nrds4@qtffskmesivg>
 <aKdw6Pkj2H4B6QDb@devbig569.cln6.facebook.com> <tiwa6wnkdf6q2pfchxbbqb6r42y7moykqumvnzauckhavyemg2@zc5haja5mlxs>
In-Reply-To: <tiwa6wnkdf6q2pfchxbbqb6r42y7moykqumvnzauckhavyemg2@zc5haja5mlxs>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 21 Aug 2025 13:00:36 -0700
X-Gm-Features: Ac12FXxXz1-TZ7MbO-XRQDMLid0u_XKSnOpxwqfbdP9x7yILSDSP16_dnK5pKCc
Message-ID: <CAJuCfpFKNQrjtoctVt0N=r1cABeyPjpwrzP6M=OTpp1Rq_0QaQ@mail.gmail.com>
Subject: Re: [RFC 0/1] Try to add memory allocation info for cgroup oom kill
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yueyang Pan <pyyjason@gmail.com>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 850A31A0020
X-Stat-Signature: y9uww8fbi77hjiz7g949tixqodssk3oe
X-Rspam-User: 
X-HE-Tag: 1755806450-728059
X-HE-Meta: U2FsdGVkX18lpgKyGFhKYAO12I4OucxfQh1rbGRenTDk0jee2ntT/C4jsH292N0RQHdSHpFnuTHTnyZY7Bz+5UJiILJVxGiEGejEpUOHNxY8eJhQlT5HSDevtBVNOPlizQHtOFVGBwiX3A+TbJEaR2kTeldvoWoywIOFLTWfewX5tErpdN9NePVdHldcvtOHPjhQKr2jXyLs63WmKaO+8bO9PBAEwndVPKspNAiTnyV99x1c0JfbGCIYK3Q+3bQTFbrEDf6rmKueV9g5GO8R0ECpacIecFC29boC62EdG9z1Zf8t649LoALs5NTE1PYe9rkFQ05k1HFK/AzKtwM4oxU8Z8l1vERvsK3/XfWoF8U5bGFeFBW6ocSRg8qIMWjZMEOGEEfxtKH7ZWpMGJtU8ZbWbeAYDWOjPIF+RltYIN+xOr3Gaxn00X1+MOxDfJdL7XuuQ02E4Pvb7PzJw6s/Pfxd9lpqmUipOoAfCTJ/Poi0zwZ53u7XdJR1MVGdRAnt7vgPQQP9A2dp9+yevBi3itN5Z4CNE6JUOat4pzkpSCYpWyD9KzdaHfmR56uvOYCnZpsYdSbDGPMBJBM7BF5byZTnwjF9xQpdpQF+eSuKPrLaRqkoVbbQZM2rgMoQPP2VU0WGjFMS6BieHFvCz3R1jqlY7KxonbgxY0t1c1JoQ6YH7/z1qNzEmKTtuUgjP3dZRzHcV4ximfet4JBoGhG3zHbtPICQAGB/B5oeYzJ1Q7HfvVe5SjxizyWYEU+E2lqJIoO1FjlzCHKFJwaDYyRNTPq1AVRj+My/Wj4GEONO5uOQ/6X6YocLDX46h1wcNv/4q8lJNfd5YtMLmxl8fZmegNJnmJhnMyeU6CVAL4KkB66QHvDynJsnZDRwwWsLaqefsRkvapvFx7dqN6Ylo0WURV+CVD22Y6mQYNA7iXe13tEolXkDQpmx8BnfEKwcL1e2IatLqGKZnvkGvw5j7Pw
 Pn42BBzH
 NsIk0f6rKtOHck8eUF9LX4qYlk0VQDCyeoMptncUz/LX1IiWlXbqNTyVWEioURBYKv+oaD2GDrC/ll+yANB5Fr7+Lo7tTiCWaX3KqHtUHH9KOBD7eY/aH/+VEeENTFvCdKJbKJStnljQoqLzc7P6ql2DCz12CqUl5z+wK5D9rcgiblGHRUbRMJRK6fek3CqLoQCsGNL+luYrXP+gLz42CaM6YcBWj51+Fi6DN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 12:53=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.d=
ev> wrote:
>
> On Thu, Aug 21, 2025 at 12:18:00PM -0700, Yueyang Pan wrote:
> > On Thu, Aug 21, 2025 at 11:35:19AM -0700, Shakeel Butt wrote:
> > > On Thu, Aug 14, 2025 at 10:11:56AM -0700, Yueyang Pan wrote:
> > > > Right now in the oom_kill_process if the oom is because of the cgro=
up
> > > > limit, we won't get memory allocation infomation. In some cases, we
> > > > can have a large cgroup workload running which dominates the machin=
e.
> > > > The reason using cgroup is to leave some resource for system. When =
this
> > > > cgroup is killed, we would also like to have some memory allocation
> > > > information for the whole server as well. This is reason behind thi=
s
> > > > mini change. Is it an acceptable thing to do? Will it be too much
> > > > information for people? I am happy with any suggestions!
> > >
> > > For a single patch, it is better to have all the context in the patch
> > > and there is no need for cover letter.
> >
> > Thanks for your suggestion Shakeel! I will change this in the next vers=
ion.
> >
> > >
> > > What exact information you want on the memcg oom that will be helpful
> > > for the users in general? You mentioned memory allocation information=
,
> > > can you please elaborate a bit more.
> > >
> >
> > As in my reply to Suren, I was thinking the system-wide memory usage in=
fo
> > provided by show_free_pages and memory allocation profiling info can he=
lp
> > us debug cgoom by comparing them with historical data. What is your tak=
e on
> > this?
> >
>
> I am not really sure about show_free_areas(). More specifically how the
> historical data diff will be useful for a memcg oom. If you have a
> concrete example, please give one. For memory allocation profiling, is
> it possible to filter for the given memcg? Do we save memcg information
> in the memory allocation profiling?

No, memory allocation profiling is not cgroup-aware. It tracks
allocations and their code locations but no other context.

