Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8521DCA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 14:56:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E40108E0025; Wed, 10 Sep 2025 10:56:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEFA48E0022; Wed, 10 Sep 2025 10:56:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDEC88E0025; Wed, 10 Sep 2025 10:56:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA4968E0022
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:56:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5BC4013BA02
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:56:24 +0000 (UTC)
X-FDA: 83873641488.08.30E54AC
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id 806FB80002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:56:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rrYSUMaB;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757516182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A16G7msev3POt8MhMV8+fmCV6RQoltrKiKjwD56M3og=;
	b=09DDyV51WRXDmpvV+HqJTjFegsR7h7r7h0guUbvkPKWmt9GWTrpLPqZoUXklknM/F2njS7
	88M0dFksAAyWkrBSuMQ/u2Z6Ht6eEV2kl42YgjFAmVzbm3ljTGl2kY2DdlZusamxHZjIe0
	lB5ZewyGVQLxeF7s16yHJi8St6IEOMU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rrYSUMaB;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757516182; a=rsa-sha256;
	cv=none;
	b=FipKNvp65Tn1M5hr0QX37UVeae2mcCCYrt8rBrd20W4+kvIj66wPicjmYeN5BVvxSc2T96
	0alfkj8M/aL6vTYuwezvZzXTXNFdZ8KaIMdrCQ6s6MMPKRvo8WrbJuTGIRsbmmMRQs8qhy
	yTv6UD9tLqxTtBIUkJvW9+yJ/FshZTw=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4b4bcb9638aso593181cf.0
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 07:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757516181; x=1758120981; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A16G7msev3POt8MhMV8+fmCV6RQoltrKiKjwD56M3og=;
        b=rrYSUMaBwkqEuzuEKLb3uSiPRoGZxqYMBzyqaM57yFhVAiV0HK8Zr6dW00/ElOaaj8
         gGvJPW/DUBJo2/4LRAfe8Sp61fV9zTI9fhBE0Lt0zoqDKqv08nhTaWp/K6R74COQow0O
         kZcjZJWK68whwdYdatwiAHOrjDyvZTYvIkM1iLfUlD2D+nDmjYKrD+k9ejKVQh0iyCLO
         yZW1P10iOFMFDHRhT4Nsry+Y2s5cuWxG+tIKzb+nO812/UpAdqw1KWY6MLGU97MQ4Edi
         PuIJLFcJa6Ly3poVmH0YNzH7l62H+q2NIC+grBzIZRyKQWSkliEpKNTabLZBMTFvjf4S
         8r5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757516181; x=1758120981;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A16G7msev3POt8MhMV8+fmCV6RQoltrKiKjwD56M3og=;
        b=Az5QI3xsukeZdGQctNDFYZOJphM/P4b7fnoszveKyD9mhftwqQxrL68DZOoufeCa2X
         plgHcjIegatleE3rCn+Bb9OMP6wwodyYUDZoyD6OfMfsxp5cOAJwAlHLOfBKoz8itEdK
         nw6Ul36rHnPVLYs1WoiJiwhdWI0mMLBu5Dg1buUaHBxMraG+ZydwcpfcGe2yHx/Dxcba
         vYsm+iQxn4jQj2elSOHVT73f9MA7iROHkCZb2PdESsLtn+FPhaVcauGOVY9E8pj5QMH+
         OzKPPK62HCUk4LmyklW5OT1jGgKtO7wnfxmS6cQ2p23NRzMBgGnw9V5EgvcIG1uv/nn3
         ZXig==
X-Forwarded-Encrypted: i=1; AJvYcCXnZhLZt1HsGB3vxSDo7l6ISiAKPDUFDFq/Vityx5B/buaF/1xDMqO+n1yfHGS2DgEc9Jfs+YpxzA==@kvack.org
X-Gm-Message-State: AOJu0Yw7y0EJRgLvxJITdmPdoCJm84xaxJ94afM06SEZINIm0yHthF6A
	BYyWZplP8avyJuwYtIhl+omG+4u35fr5as9KMlkKskDOrDRq0aRiBwW48b5K5i7Pcw3kGXLRVA3
	CCsITzDJ4yLCM4ezvSVeqKKQ8NWCFMkBRicesxbsc
X-Gm-Gg: ASbGncuDphv66pZFb818doGCuees02V7srTQKxbf97BsQM0ssOB1o6IkDlC8DiQgkcT
	U6VA4TLF+cMYxRX0M6BTHDDR/NPcuQE4TGp0YpccmayHQ8lPpOmCYR+uJu8PvnoTfr6WlSXgVW6
	xEkemQRMK4jaW2FUJr8GDW8X/bHie8hUl+g9ubeLvVYQ2Rzg0EvtWfYq2WxV+3WmLCe8zfAhY+0
	Q27oiLbqD0mmBhwV4Lgjq3p0A1dYfV+BJpeLc4AgMIHbBqKnnsBRA==
X-Google-Smtp-Source: AGHT+IGaaCo3evsn7RGNzMZzR6JhniZdVW9a85shLUbENP9DBHr6Mi63wI05PWTCudwIISeltuesuE5/JBo1OoWg68g=
X-Received: by 2002:a05:622a:199d:b0:4b3:4947:242a with SMTP id
 d75a77b69052e-4b625236043mr5421861cf.12.1757516180932; Wed, 10 Sep 2025
 07:56:20 -0700 (PDT)
MIME-Version: 1.0
References: <20250909065349.574894-1-liulei.rjpt@vivo.com> <fszpgct7ywqy6qq3qnjflol3theovmgnau2wgdqqdxin4q7ezm@zumgw533hxon>
 <CAJuCfpFaTj8PsXkoYRQKQ0sOu+mKikUAE8Wbcx+YpZXZ4M7cMA@mail.gmail.com> <b74b1e28-8479-4b14-9210-5b4334d3ce22@vivo.com>
In-Reply-To: <b74b1e28-8479-4b14-9210-5b4334d3ce22@vivo.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 10 Sep 2025 07:56:09 -0700
X-Gm-Features: AS18NWDh7ZJPWGaScD2chXrEfeSkcnJTIGCOkVmB8eEUGK_Q5MBQiEFvWnW-pIg
Message-ID: <CAJuCfpFVUOLtmJyo_B+Z6HAaDOfuZhYZX71EpQW3+dpQhm3EQw@mail.gmail.com>
Subject: Re: [PATCH v0 0/2] mm: swap: Gather swap entries and batch async release
To: Lei Liu <liulei.rjpt@vivo.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Chen Yu <yu.c.chen@intel.com>, 
	Hao Jia <jiahao1@lixiang.com>, "Kirill A. Shutemov" <kas@kernel.org>, 
	Usama Arif <usamaarif642@gmail.com>, Oleg Nesterov <oleg@redhat.com>, 
	Christian Brauner <brauner@kernel.org>, Mateusz Guzik <mjguzik@gmail.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Andrii Nakryiko <andrii@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Fushuai Wang <wangfushuai@baidu.com>, 
	"open list:MEMORY MANAGEMENT - OOM KILLER" <linux-mm@kvack.org>, open list <linux-kernel@vger.kernel.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: c4i4635zmujwmm6mricryoro8xxfrjzd
X-Rspam-User: 
X-Rspamd-Queue-Id: 806FB80002
X-Rspamd-Server: rspam04
X-HE-Tag: 1757516182-897132
X-HE-Meta: U2FsdGVkX1/HQrGm4uUfIFqqY3T79C+N9ZwCaGCRG0Yt/OyVBMXGA4kOlhic97HDDKoxaEYuE114Bb8WjXGy7i8BQstxZrpmxUH+CNvP9+p3Dd/0YrOHW0c5biQKhNBHQ8XPjCvsbtoSEYVEGH7KQyLhtFVsXPxzdY4lEhRwotS6+RAo+tG0pZ8yjfABolpoxZyfOMbANx+PNoZoyN0RvAo0yRwiB8aWNPW9oGLCJN5WA0Oog+gjl//9yKfvfCsNcf0WYM1sLEAUBNnHdZdcHLFaM9UVb0GRZ/e5Hec0Ef/rgadUAqYrbOBlzCYqAEV8sR4pKKYXK0koL88FU/iJLIGC05+NwZ8DGomvlJJjIKJIOz8P9sMQkL6OrnUXBdW5cheulbvn9z9G2MkwChIbYHg6o3UDsOldnoM11sfL19WIJfjHeuLXmzqnRKtlB4SmqYa/fa8HGzsd4QbLDTrOtW05L1/KMbTJhWp3J8DgqFg0pUktFmZq+X+PE5Rn6TDOts1but4BXmPd0jm+LLiFNSHxDEO2jPgv9c2g4ZpYTlCh3MnY7eqll3zZLAN9QSEYm6MGjekpBYxNw6bZxbhIaOnjivTClqEAj21aP/i57gtJzh0YnG2m/YSEntw3kBAn7oKRMj37Mb+qpYrTlLHLDkvzwDESitBY6xKDlP6vns+GQbY0bJsw+Sr7SCoffznHZ4KmTDFk0DTrNSzellaZEXmvvleuHHKpRp3HwOYIn1TWg8VO8yKZcgWYON1IxrtmY20qozbGRHDgWhbUagMOZtNq0TsWA5UJz0zBhO6yq1SCIhMQBNr54ErIhx8cfikXDPR/Mh2Nm0CHs4xNIQxG4/L2YQQYUWH2yOZ15+S1X8+2UeLZeaOHI2uZMU71NsZMisMRBDWF5LIgkMTWhj/zuITkTS3sGHJ/K5y8pjPH5EUSifaJzZze63VfOqc5UNBnJjKOfqq36sUtZSd6SYD
 bIAO6YGm
 eaQprogYKxP9zNFDxRh+Af1RziYq6dw2+LS3e9PrO582mBi0nKA5v85ff/OehorSCt+Rdc8h1pJt3kuyRxXreWFqdKu3f5qNzcHAHVtMQ1puEsxlw/fmvTGXRzO/pIV0VapYFYW4YbzYQJ3/iPBy3xJlI/Q+x3OWfLUIABK+7qPp8NmX8GyGWa+qi2zMEdf1hfYLC948Nl+XTJaKdAXMxmf3OqxB98ta0VkDu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 7:14=E2=80=AFAM Lei Liu <liulei.rjpt@vivo.com> wrot=
e:
>
>
> On 2025/9/10 3:48, Suren Baghdasaryan wrote:
> > On Tue, Sep 9, 2025 at 12:21=E2=80=AFPM Shakeel Butt <shakeel.butt@linu=
x.dev> wrote:
> >> On Tue, Sep 09, 2025 at 02:53:39PM +0800, Lei Liu wrote:
> >>> 1. Problem Scenario
> >>> On systems with ZRAM and swap enabled, simultaneous process exits cre=
ate
> >>> contention. The primary bottleneck occurs during swap entry release
> >>> operations, causing exiting processes to monopolize CPU resources. Th=
is
> >>> leads to scheduling delays for high-priority processes.
> >>>
> >>> 2. Android Use Case
> >>> During camera launch, LMKD terminates background processes to free me=
mory.
> >> How does LMKD trigger the kills? SIGKILL or cgroup.kill?
> > SIGKILL
> >
> >>> Exiting processes compete for CPU cycles, delaying the camera preview
> >>> thread and causing visible stuttering - directly impacting user
> >>> experience.
> >> Since the exit/kill is due to low memory situation, punting the memory
> >> freeing to a low priority async mechanism will help in improving user
> >> experience. Most probably the application (camera preview here) will g=
et
> >> into global reclaim and will compete for CPU with the async memory
> >> freeing.
> >>
> >> What we really need is faster memory freeing and we should explore all
> >> possible ways. As others suggested fix/improve the bottleneck in the
> >> memory freeing path. In addition I think we should explore parallelizi=
ng
> >> this as well.
> >>
> >> On Android, I suppose most of the memory is associated with single or
> >> small set of processes and parallelizing memory freeing would be
> >> challenging. BTW is LMKD using process_mrelease() to release the kille=
d
> >> process memory?
> > Yes, LMKD has a reaper thread which wakes up and calls
> > process_mrelease() after the main LMKD thread issued SIGKILL.
>
> Hi Suren
>
> our current issue is that after lmkd kills a process,|exit_mm|takes
> considerable time. The interface you provided might help quickly free
> memory, potentially allowing us to release some memory from processes
> before lmkd kills them. This could be a good idea.
>
> We will take your suggestion into consideration.

I wasn't really suggesting anything, just explaining how LMKD works today.

>
>
> Thank you
>
>
>
>
> >

