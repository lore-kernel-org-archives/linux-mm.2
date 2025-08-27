Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA77CCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 02:32:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C9E86B0326; Tue, 26 Aug 2025 22:32:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A2398E0105; Tue, 26 Aug 2025 22:32:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B7D86B0328; Tue, 26 Aug 2025 22:32:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 08C016B0326
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 22:32:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A75FD1DDB1D
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:32:31 +0000 (UTC)
X-FDA: 83820963702.05.ECEE4AA
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf13.hostedemail.com (Postfix) with ESMTP id CE0DE20002
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:32:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Q9j2djnN;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756261949; a=rsa-sha256;
	cv=none;
	b=glQtNchWuXfWcwAp1ya9ypkqPu5Ba42Xok/05io0Kji3pta/cweBOwYL8ftj2btr6X8A6C
	WAxBUArNtfUM4/kY+FJTaUk2aNTUtVc8q3NqGeSv2UDYpd5omsnKd4CgVJBfjZ3+q9zzdF
	Z1p2H60gGwVYS5/miovHMrEIne9AFuk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Q9j2djnN;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756261949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=phLICMoxD4JP6sKT1DeC5mUYYErOOuHJsUqnVc0nu0Y=;
	b=i/WF1RBrP6yxSCU7LdsPzdcnqyaE8sVT8hHtXmWjfAxqFB5YriatRASqAFukdsKZBY16Pt
	jzBc5oevJ8NsSaY54tj01j6P8+JiX8EJXkDsw9GIpifKMRjPqAC/0KF+QjHPb2hxEjNvxG
	JWNAo5KMoCC3haJAoRE9XNYqPoosybc=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4b12b123e48so159601cf.0
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756261949; x=1756866749; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=phLICMoxD4JP6sKT1DeC5mUYYErOOuHJsUqnVc0nu0Y=;
        b=Q9j2djnNL/u0qQ6MvUejRX5mf/7JNR+iSUv1ljuIIppN7G0Ey8ydHf3sba46vLsPVY
         Ir48XKECxlcj0lWPvLlWMS/kOLjnOSTPwoQEXElZLOefGZZsXaCNhDMTFtvEQ5Nct6MG
         slT2ovWH5QLqzCJPiYUvsiTp/DnwRSorJFe6kWiOpZfptdfiuFOsI0bEkY+H/qSvQTC4
         PomwA3NyXC7EoimH1fwCTe5T+Pg2PoqGywJc1xNWbATZPSpXXHO208gHxBYmWakCnSPS
         sWDzj8wEpHVZs2OXG8C7AYn41TbOo6Wuoa1vixBaD1hzdxeEv372rT4iDfAqGL78AE8d
         gzjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756261949; x=1756866749;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=phLICMoxD4JP6sKT1DeC5mUYYErOOuHJsUqnVc0nu0Y=;
        b=s0QsevcUjgHE3bFw1gcsNdZzb2iORtO9NLnDN+zSAviGyw9SER2ojwyETkEAv7d65K
         OYQgkgUK7BjyTPUsoubhw2KMHXf5SqI6IDLEiZBF6ncTiLdASR8Vof+2xKcFHqGqORRH
         2qNiUFpfa8GNAgWGG5oX4irDKZ4BCDYeO1jzTR2bgebTOasbTAs3ZxK1nyx0+AgaVUbV
         yFVdVP38+Z84Ow5XjXYW55tmsusX1DMuXJTgt4T4cefqYY8NINO3M39/9U6HkVLIRSND
         Q6G0eHXGRQUV33tO2kW8tbGUOaidKhvIfCwooHP10OsokuoE4jNShwVk4mL6OwTu8931
         aHfQ==
X-Forwarded-Encrypted: i=1; AJvYcCVHUUc1NRzSEqNfDy7qQXljfK7LSA9edK3/hB+xbYBCn1SSK2GoGIQaHIioCPqU4xKgMpkJbwB31A==@kvack.org
X-Gm-Message-State: AOJu0YwwQx3tHmRF9cb4g2szBPH5mTacJ8Id6GGsi5GjvmTpyymUywjf
	5xTuCOM1wu2RfPpVHgYgllkC4aSb+W7dx0YnFhWOGMJP0ye5hO5T9N0Y8fLKIScPD1cTL8ibZW/
	uP9pxzvwsHoeAykrfygCwB0jjYpiFudBdyl++EMmtgjFUmJDYL3hD9kVtzso=
X-Gm-Gg: ASbGncuH1g9j9GNr6QvQ8m8stGw0H8LL0QZWm6ggfzu5kwZu/9lvvk+y73hs0OrJZvE
	LjRSx5CCP1GpjcVAJDjzPH8qotLnJPKPo0efhqOidUQYrSQnaJVvLl4fnHdWQVrXGUU1njR9cZQ
	+6BS1Fa67DPSIhMIysLKIhmfO5FO9zTeWI0N2JJt5RyN6jwu7rcqBO8kMBYJQLTu2fE4yWjM494
	2xP9BK9q9BL
X-Google-Smtp-Source: AGHT+IGEkFxoIeaU31PPrER+XD5lzwwgqgu6SIDi6/2BzLmU7aGrEqvMu3SzdfymXhnaZAVtazALtqj98L/HKOhu2Pg=
X-Received: by 2002:ac8:5a49:0:b0:4ae:d2cc:ad51 with SMTP id
 d75a77b69052e-4b2e2b6d63dmr9758151cf.1.1756261948495; Tue, 26 Aug 2025
 19:32:28 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1755190013.git.pyyjason@gmail.com> <6qu2uo3d2msctkkz5slhx5piqtt64wsvkgkvjjpd255k7nrds4@qtffskmesivg>
 <aKdw6Pkj2H4B6QDb@devbig569.cln6.facebook.com> <tiwa6wnkdf6q2pfchxbbqb6r42y7moykqumvnzauckhavyemg2@zc5haja5mlxs>
In-Reply-To: <tiwa6wnkdf6q2pfchxbbqb6r42y7moykqumvnzauckhavyemg2@zc5haja5mlxs>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 26 Aug 2025 19:32:17 -0700
X-Gm-Features: Ac12FXx-amMNGfYthUlKXoV2KJV8Ivl2glrfWFB94kYjwtAlLlUunZcwpQnXXCU
Message-ID: <CAJuCfpHyXWwrKkFmmbHTGtG9L-JK2eCt03ku9364i4v6SJKFbA@mail.gmail.com>
Subject: Re: [RFC 0/1] Try to add memory allocation info for cgroup oom kill
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yueyang Pan <pyyjason@gmail.com>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CE0DE20002
X-Stat-Signature: u18q8nj7e876epo757u15nuwatjwp8s8
X-Rspam-User: 
X-HE-Tag: 1756261949-892100
X-HE-Meta: U2FsdGVkX18T/g3+Cvjj+FDmnonzWvXECJt6bgbawAOKvsJj5mT9mou+wO/iRe2NLJCY5jwUmav344gQzUc0yRNVfXfTZoWBx1GnQP1VsCWnQIXXgHECysSjlGArhipotH+Tb/+wdLN6DI01qpcA/ZvIOjsoSFFfszEdTmFA+pV9RmrnW6kgkOxaj2jf1CzSEoU7+ES4/RU7GSM48PydzgUsDjkZJg15tyFYNK7c4HmjYOEu9xMJofQySdLUT6X10hFIiAgzicLaSpOM6kvbRDRGImCUc4pLJHQo8PdHB0I4rN6r/BuZpwvmC3EOZ/Db/G6NmH3BZbPvqHiufRn/kEbAxKiHr0zuRoAYg4NHFfobGy8bS9noFA3s5mIfwMj48jn4hveSyA5HqSDBSZ+8o2ibWmEJDbRtw7OK3V3kqNw85J1Lj/oIoshhfQdxgKmTNp6t6wKTtbfwFz2+4Cwo0JD3I71+DMohFxuFh+YC8HObW+zBX0OdeSJEXDZrWa6L9i86mqOmqemIBuPYCP5BCcsAA91QrMtrN5PZrc8U/1zh9FV8ziJmPTHEnUf7dISYJriFw5iZQ8wj0/FTeASg6XeVqavICFw1UaGNq92Cq+eM+Klv84/oJg5ZzObltFuE4fbd84viDpmGJ5PlN44SIqh1DwNyF6e1pBcws72QFD/e05iTGRFDkZYb2uWVDbcPZDaw2o01Ihl9iBYSZoFmZFhBmECm1c4bFs6GW84wDWBDPvrpMbzrCVPK2/TdkNGkQNA06eNQ/d/tKptNr4AJxek63zehKaYMl1iakbxu4fNN3Nd5UWOR+cSHlPyXFAYranNCDQjqoOnq4p6+EagaWRkjWicaDM9Qt+SvIZQsbFVoTxUdCKWxdnCBdNeQn7J9YEBnEDs/VvNcqwLyvHxDYDWXgnx/mB8kgxWKufkfkbV4KgmNd/E9albv03Gyiei3RQx+Gdhf3LwkvXCw4Rx
 69bzSV6Q
 IT3zcccKzt66YFZrbEGVMuGzNSfma4BnNvV4RrU7Gf7NfZx7e7t33aYaUl+uHBCtOuJ8KFsImKpIfxecuOcDu1qLnZJvrTsqn0rj2PQBgnLWBb7kN/t3wkyqrZwIGooiclBjCrXNJdjr9g9BzCcVeoljaOwdGfKtMGew4p9Y29ha1qF/oviRZPoQomKhmSTPnGrKbzQXhkqoll9GYaWS+rA9BvIqn/TUT/Exc
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

Actually I was thinking about making memory profiling memcg-aware but
it would be quite costly both from memory and performance points of
view. Currently we have a per-cpu counter for each allocation in the
kernel codebase. To make it work for each memcg we would have to add
memcg dimension to the counters, so each counter becomes per-cpu plus
per-memcg. I'll be thinking about possible optimizations since many of
these counters will stay at 0 but any such optimization would come at
a performance cost, which we tried to keep at the absolute minimum.

I'm CC'ing Sourav and Pasha since they were also interested in making
memory allocation profiling memcg-aware. Would Meta folks (Usama,
Shakeel, Johannes) be interested in such enhancement as well? Would it
be preferable to have such accounting for a specific memcg which we
pre-select (less memory and performance overhead) or we need that for
all memcgs as a generic feature? We have some options here but I want
to understand what would be sufficient and add as little overhead as
possible.
Thanks,
Suren.

