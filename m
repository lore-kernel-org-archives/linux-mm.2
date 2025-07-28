Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EDE2C87FCB
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 20:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B9B76B0088; Mon, 28 Jul 2025 16:34:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76A6F6B0089; Mon, 28 Jul 2025 16:34:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 659406B008A; Mon, 28 Jul 2025 16:34:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 587D46B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 16:34:47 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D8B3B801BE
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 20:34:46 +0000 (UTC)
X-FDA: 83714826972.17.0C4795B
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf10.hostedemail.com (Postfix) with ESMTP id E865CC000B
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 20:34:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Tcnzx0dk;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of jannh@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753734885; a=rsa-sha256;
	cv=none;
	b=HMxAbsqUkbfu6Mz7ChZTyrD/CU0pVENSb3EYZaABt0mDggfEmx5NvJobsErvS9ag60Za++
	zI/7NIZ6ihmCc5IlCAwiMM5DSh5trro19W2HK1DE2YhW+2aZ5SYplzq68YUoxg3maU4TY8
	HAIVqt3T5mU1qFnMJ0+XjrDlhfg/rjQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Tcnzx0dk;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of jannh@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753734885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5cIuEYX17XiPrfyxPlwLzcOeQJGvPzMkyLjuQxbOTNU=;
	b=ovnOoijS9pQZrlnMdRPICVagw+f5wlO7w0X1KQb/9LBxArPT9an6FF9RoL79597N1cRX0A
	SAGgmH71W6w9fkVsFexOOuq/oN5hYvs8BuFbyTsi/1DOsqOyUukPdFOaqYJCEVYG7screC
	549XiH+5ZqD97d8LT+Z+Zm2DmRSjB1k=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-61548e5521bso601a12.1
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 13:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753734883; x=1754339683; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5cIuEYX17XiPrfyxPlwLzcOeQJGvPzMkyLjuQxbOTNU=;
        b=Tcnzx0dkyGNejEuf3+bQdX/ZijOSezgN/S92cKNN9vFbMItXIswS3fXEkRlIqLpZdn
         2CshGr0s0TjpfShtDKabfqw6XkZrUZEhYr1evpPJXPRBsN2CcZVYAV5lCgporJU0ZKcN
         A595ZdQC9mX2W+l1PSjGlbPksSKzQbrarQxq3emkBdjcCkC1gIbMrAjaT8JG1IzSkGgC
         XrEbpZvdPjc/BCWLUyIG6Ifv2v2Kp8SzcnXDIbKJnxPW7torZbIVXfOLvJojhrVTo+aY
         d6uqzDL7DPtorX4f29Eju+YPUkYzm4JSOTVm3AD1LCua+gcOpL/IqACEy9mm1nIORvt0
         4SxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753734883; x=1754339683;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5cIuEYX17XiPrfyxPlwLzcOeQJGvPzMkyLjuQxbOTNU=;
        b=dYtZ1cyMI0GjbNTqZVmLEQf0DhWRFWMedaYLkDocauBzhBA/NsajFyDrJH119LwLAF
         7parm0TaHj0Yez3MU5qlMNd3FT6YUE2S9puQ7ZT0vw35tfjJAeuxsCCqgCpjffxYXjOb
         kiALexRy/VSBUW4H9kDcIVOrya2q645jmOeFCfG62kUJY5LfBGRKxaKXWB4ySHCss9oc
         kCtmwAzXfw9bqCjdJMOOsLS6RbaVkYAq/8pYoEWnfg2bSxrVPlnTTfTO/RoNrFqt4g3z
         Geb17EDKeeUnjP7YXK4FOGhioMg6C4Dac8WRHnF+BmRF0osL3cA/gc6SdysJ0SaR50CA
         fFBA==
X-Forwarded-Encrypted: i=1; AJvYcCUpA7dlzr1THn+OE4ruNRwknV0Po1Ra5Gy9aaEXNC5ovHMk8Q7H4YtZ5Jgw+XXrgdGkRKaK7YhT7g==@kvack.org
X-Gm-Message-State: AOJu0YyGE/PrJ3xg5dgHax78c0mGuBBZ105UhKEUxBvOLC04fD1KyW7t
	Zb8ww/0LYlJj1L8GwycjbnKnEoW7xObmIEQeawkSaf4V9oVIrpVnkb8qxOe5mNdJyByrMRiFlzz
	A+ruU2F/CxDdZ0QAJmgY/pzNBLKMSvur0xEFE/+fVNIHIFMRXRss1Bbfp
X-Gm-Gg: ASbGncsV7g4N/lFtVSGiSC1CnDXzuHWZQppw7V0QXyRsNc7i/niD9tHj3IOaYK5Hj/L
	CKrfqacUBxeaCzQFr0HMd+0/hKZuWtzhBZrz1tuxOLhgs1ipHTT9p9sEnzndG6Hh8wGn/kmAz+r
	3OWrh1ebx1C1LkAc+DlaL8ZeN9f6wV8VAaVEW+25QhFbAzRzOfgGUwKxutDtZLCdKRHFkaF8k9H
	omYWP/gprp3GA3b16nnfYYmuaoiA29P+A==
X-Google-Smtp-Source: AGHT+IGSwHNM1lMm6iRvrNhpLZM/44NLBcht7A9ZyhiiFAeshkQMQrkJ5OQp5Ak5DNIjWjjK+SMh7cZBKnKVJBMgOHw=
X-Received: by 2002:a05:6402:2291:b0:615:3301:25c3 with SMTP id
 4fb4d7f45d1cf-61567304ce8mr13512a12.6.1753734883112; Mon, 28 Jul 2025
 13:34:43 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1753711160.git.lorenzo.stoakes@oracle.com> <386ba8fc99adb7c796d3fc5b867c581d0ad376c7.1753711160.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <386ba8fc99adb7c796d3fc5b867c581d0ad376c7.1753711160.git.lorenzo.stoakes@oracle.com>
From: Jann Horn <jannh@google.com>
Date: Mon, 28 Jul 2025 22:34:07 +0200
X-Gm-Features: Ac12FXxZWrVG9lHiMIdLtQnur6MhrtrOas81mqHV8KcQZRHD1RU90YYt9ttm5Qw
Message-ID: <CAG48ez2rQfWJwnpAspNr8OtLXgPadG55Re0KoK5ovBKqE3AcbQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] man/man2/mremap.2: describe multiple mapping move
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Alejandro Colomar <alx@kernel.org>, linux-man@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E865CC000B
X-Stat-Signature: stwww8k4a5bpntr3xiemxruq6bu4b8ks
X-Rspam-User: 
X-HE-Tag: 1753734884-465278
X-HE-Meta: U2FsdGVkX1+VCfIXUi8QgcxGeCAf1O74yeU4ZFmc4DL1YiukovycduHfwJpr9IFM/Iy7XNo4MsN7QI6LGjWpZRl+71TNUhF0QvZpijs2vqx1UHUJBnaKjt8EMOwKtgioS1JmP14+0Zh/ZTLRcHVSYluZzdd2CQH8lzxJD5rab9L0A2qGoKrZQb8zWH4QBxJveV1pMa9PlUtzFIqi0WZDsa2uW+iYXynB6RsyS9DlWFUv+u22fRVXj+jHSBaEzWdOIOIWuWod2oaCllWve07glca/3cMqiNHZ8N6J/FOOSpLfJkujlD6ZG66289VvwHEbfCz+TnaGFm5u4Qn4QuA50tAISJLQcDfSuffy5GQPK1bq4IQ0MJ9dHT/lX6FXq4jldzDiqPzFSZPaBAsJfCONjtP/XY7ICPujnlXoEDQUcOq/kbvdD400OSTnXVR1K76pZwQ2kiDLj5aZd7lmRxjmQfY/iX8KXP8Uqq4aaVUBfrgT8WfAM96ZLT+L0HwErLqM1H9iyk7d5EZOoAZ8QBULE94tZb3SsJvMrWQSjpCHqG0mz3Jia+Q1HjwJzWwaAGVijbKncSXOXqmG4RQtzFsbTP4J6DTjbPoiNKMDYHfN5MpBMrw0dDgvnRz2lGl3zS5YkPoP3J1s/AyodKhezlk9NchesjmEo1QMobpDigF4MW8n7l+Vy89pP+Hiagd8lPDgiNc6mRglzMQfwC8uv+To76jXgUiGRh+m527qN43O5dso3lmC7C3fJYvyKV84IEE0C0jazoY4CaPKCb7S1imH6Rcf0KZdwllEIHA+5uV6V/dmpDw2znUdP5Lq9fSfpwrMAcAGoF7lorX1Jyr0o03v296GB9YmZFJRlTPVmwur7j9cN7UcR0Mu+KGC88qfE0m+V19rOJk7WNQCD2VjvX6ub75vH0cec2K9Zqc0QXszbVpOwQqlVJUdAYzMTAcnpeDcLL6IW5NQg+JSn3gpKq5
 tCJ9npgl
 UlD21QNVSK5qO9x3xAYkbk3hSrczU7+0C9gRqsrObaYTKMK4BQy2Y2Ovm2qboP/VbYRk8rXJyba0oY+xZIrbEhGfF6evXUGuZNmfm+xrLWkgCnfqfrRcwP4PlO4mFLuvuFaUJSAPjUTBX/MoBTtQT4ouJEsjSM8u0hki7CE1UvoWv8DT71RiX6wf0gDwyxV+prxcHltUhsnPnfY6SLGioqKt1ixCrub6FBIT3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 28, 2025 at 4:05=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
> Document the new behaviour introduced in Linux 6.17 whereby it is now
> possible to move multiple mappings in a single operation, as long as the
> operation is purely a move, that is old_size is equal to new_size and
> MREMAP_FIXED is specified.
>
> To make things clearer, also describe this 'pure move' operation, before
> expanding upon it to describe the newly introduced behaviour.
>
> This change also explains the limitations of of this method and the
> possibility of partial failure.
>
> Finally, we pluralise language where it makes sense to so the documentati=
on
> does not contradict either this new capability nor the pre-existing edge
> case.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  man/man2/mremap.2 | 78 ++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 67 insertions(+), 11 deletions(-)
>
> diff --git a/man/man2/mremap.2 b/man/man2/mremap.2
> index 2168ca728..cb3412591 100644
> --- a/man/man2/mremap.2
> +++ b/man/man2/mremap.2
> @@ -25,18 +25,41 @@ moving it at the same time (controlled by the
>  argument and
>  the available virtual address space).
>  .P
> +Mappings can simply be moved by specifying equal

(Bikeshedding: This "simply" sounds weird to me. If you're trying to
define a "simple move" with this, the rest of this block is not very
specific about what exactly that is supposed to be. In my opinion,
"pure" would also be a nicer word than "simple" if you're looking for
an expression that means "a move that doesn't do other things".)

> +.I old_size
> +and
> +.I new_size
> +and specifying
> +.IR new_address ,
> +see the description of
> +.B MREMAP_FIXED
> +below.
> +Since Linux 6.17,
> +while
> +.I old_address
> +must reside within a mapping,
> +.I old_size
> +may span multiple mappings
> +which do not have to be
> +adjacent to one another.
> +.P
> +If the operation is not a simple move
> +then
> +.I old_size
> +must span only a single mapping.

I'm reading between the lines that "simple move" is supposed to mean
"the size is not changing and MREMAP_DONTUNMAP is not set", which then
implies that in order to actually make anything happen, MREMAP_FIXED
must be specified?

> +.P
>  .I old_address
> -is the old address of the virtual memory block that you
> -want to expand (or shrink).
> +is the old address of the first virtual memory block that you
> +want to expand, shrink, and/or move.
>  Note that
>  .I old_address
>  has to be page aligned.
>  .I old_size
> -is the old size of the
> -virtual memory block.
> +is the size of the range containing
> +virtual memory blocks to be manipulated.
>  .I new_size
>  is the requested size of the
> -virtual memory block after the resize.
> +virtual memory blocks after the resize.
>  An optional fifth argument,
>  .IR new_address ,
>  may be provided; see the description of
> @@ -105,13 +128,43 @@ If
>  is specified, then
>  .B MREMAP_MAYMOVE
>  must also be specified.
> +.IP
> +Since Linux 6.17,
> +if
> +.I old_size
> +is equal to
> +.I new_size
> +and
> +.B MREMAP_FIXED
> +is specified, then
> +.I old_size
> +may span beyond the mapping in which
> +.I old_address
> +resides.
> +In this case,
> +gaps between mappings in the original range
> +are maintained in the new range.
> +The whole operation is performed atomically
> +unless an error arises,
> +in which case the operation may be partially
> +completed,
> +that is,
> +some mappings may be moved and others not.

This is much clearer to me.

