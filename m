Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F32DAC61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 11:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E62D56B008C; Thu, 27 Aug 2026 07:24:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E144E6B0092; Thu, 27 Aug 2026 07:24:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D02FF6B0095; Thu, 27 Aug 2026 07:24:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD1876B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:24:12 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3F88B1A03AF
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:24:12 +0000 (UTC)
X-FDA: 85146815544.04.556288D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 69B0FC0009
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:24:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ghq5N55T;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787829850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=msnrvx8LAnGtyTEJd5pnZspkDeQKGfyI1P9cpd8MuMU=;
	b=kOROTeNf13Ybgxs16sUenAwKudLfzSV23gxU3q3m7cyQByFy7C+h3h9W3CglBAPB+oaU9R
	98uzUFmfWlkto8iH6WO+mc7Z0TuW8F0e54DWyXjgc+QUsfW7PxpST6Cehqrj5W269i8d5y
	m1nn73ur0gwU34+dqUwvuSI1G3WG1DM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ghq5N55T;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787829850;
	b=HapU1rr6IpMRgdxJOmfHQx94fwZyTTaB6SpGJlQnKANJkbgw2pOvjn4a1qJfZ1R7F1Xtg3
	06WTH0yWZdWCKCG87O31c2bIyEm5FHcBtF3w51E1sj3D7gA/IBnsIDr1nyZIIqBQQ6PYQ8
	VZTcepXpsygCpd37P+RCiL4edRv+cD8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E0CEA600D4
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:24:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E8F1F00AC4
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787829849;
	bh=msnrvx8LAnGtyTEJd5pnZspkDeQKGfyI1P9cpd8MuMU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Ghq5N55TXxTo3GYPbb9WpAyTPm1WQenwDZLll4AY5nD7gYnwMXEQ/Adyyx392v1fK
	 HnQ1ndpdvjLr+GBt8nS/jndKghcvFEgvXkO8h/l1F4W0+NaFjTb+N/PtWpbo+TyfyG
	 RBSlNf+yNOEFqGae2IU6q4eyeHCcZlDsOki9WbxIarlbMbmEKSbF7PgiUW1KT1OwiP
	 2rqAhsUDQYzb62VKSs1bsNg4TIi0r5av7m8HCcLGDKSkjBm+nSH87d7f/h+dCuD1S3
	 iIrx4ALenpfUd3rtISAy/ZMNSA3zuWicDipqQxqtoRCzh5BWy7NcooorIAvZHJbhIn
	 YwVlGCg/KbG/A==
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-92e7632b193so112611285a.2
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:24:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqMw61HIVATsFhj6RtTgZtOsLXbcAgVRCJv80yuH8+hElJWs5pFm4ilNq+bfHD8MyXDrbtXs2w5Zw==@kvack.org
X-Gm-Message-State: AFuF++k+Ltu2T/V3Yuob4d2OFYA4vkDis8frbLNxfGTs1O/tfh9WrgQX
	S+VdBuySKKEPb33r+tuF0CPgTxR5SdyRCqXhC4lIYXOF9BmSG1wP2JlIUWQVkTHR738XyPcUKdP
	ktcn5BysoeAGloIHnh5961iOQ2t68v/8=
X-Received: by 2002:a05:620a:2255:20b0:92e:4bc9:6ea9 with SMTP id
 af79cd13be357-9377fe2fa36mr1030747285a.0.1787829848970; Thu, 27 Aug 2026
 04:24:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260827103435.1371882-1-kas@kernel.org>
In-Reply-To: <20260827103435.1371882-1-kas@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Thu, 27 Aug 2026 19:23:56 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4w+eFiu6PvVDekmo_qSiRfoH-YJ=XfqvCoRJFZV7wfTSQ@mail.gmail.com>
X-Gm-Features: AcwNN1VxQoDPZPuAv0nEmdx88eOWIrEn4l6ErRMl8bIF2cOB8XKs_Few57OFOR0
Message-ID: <CAGsJ_4w+eFiu6PvVDekmo_qSiRfoH-YJ=XfqvCoRJFZV7wfTSQ@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add myself as a THP reviewer
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: xaeepy73ktw5yxr1nem718sf8gcgmj97
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 69B0FC0009
X-Rspam-User: 
X-HE-Tag: 1787829850-731889
X-HE-Meta: U2FsdGVkX18MOxYCtD18gLfe6TlFEpQNsVwX55lGfAVtQmUgRnbf5wzmWRp2kLccToh5YC7Krcibt5c6VViMLnWb9jlG5qfk5lD98O49ZzujBIn4XXJSb6IdqhlQg4nEg8IZzw8AgWvwDeE4/t1CnF7LYrzBYEj7vzI3l4+S8HSucuUUGQsZiSYTYNLMxNMCecMqCHTm/Lt2yGnUJsd+WOgXT/vaQMj2IHUOe/trJzRPxrRhssMzr3NLWLobG/++kjCvzX4P7WT2uKF4gcIQijKST0JDqzHwmuJwJxv1FrE0alN+K6DKaKE3YDCS8aygMFqOVc4tsmGjscbK2xz8w1ibvnBvUwnFGIftJqOrsPcoYYiwj6JpMOMqqxX38So8xxU1V5G7j0y6FysqPXLTyjgxq7Dl8HWjetxZE5yWFYUXd61xLeVYRQL3UcS25GCumBsvI+awBY3cEximZlhggSb9yNFp2YjRpCtot8UmYBJ+hxmgQuDQzgHOonYYt+x/Nm/PxNMnRmjHdc9aZvL9ZlNoIsMdec3eBdGTlkfKZXImn0KVBtyEmniF9I89NW17FfhDyo1ggKgkzwxkJfSkzfiT4HY4/oxiHASCSrI8oFUFE+/Xo6XmcxoAmK6YGnpk0vOAin1NOEGu62a6KDb9BQle7bHIQL0HKrXtN7sN5CxVhKWEoOiFTX5xoqr4Vm2gWAA9ODwCc3GOjnin0kPl5hsAZPwZ+npij/2VfY9EXXirf6me6ilVXeEQayzBDdgJtlL8TUqbwPMHzHthFHBpv9Q7BsztSOCp5cCjPJpr3NMOU8fvhdJZSLqH0yJwQ8uWTqgc96dN/Fcf3WvkCopi+HqAoE7f3Wqy+VSto99bmn2lcolh5mxUcAM66FrcjlAPQYrX8LWtaQ1paumf8U68X8ch7Am8Ni1BEpcnR6oBEuq7YSLG6uiyupf/qSwhAJe3Cq3WRZXxJ0WDTcqP0d4
 jTjho8V9
 5filZnefdAZhiVI5HJWlxfXeVuVEXLrSbaKop2+TNVYzAKpQ8hE4XHbGREHwqa5zW7aTUlPZrpCIr443SwUKUnJW1rJtJXS78gZBgiSQ+YwlwuJGzHt8FZStWCKjuqmMRU7UPRKHUYGbDk37vrzlSnqWnSYopu9ztJoeFK1e2ASQqDKocgLzOznJmBu/TnhYd9MU/wQvnGVk4qfJigbiHNlXuOeEOwaQErqGhXehtDHNSSF8l33KRwGJhpeREhWfcjPhavpfBPnkgK6D+pvcRH54YkqkEsFYCtrraoJuKPJQjZXhOp1a8MO3NnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 6:34=E2=80=AFPM Kiryl Shutsemau (Meta) <kas@kernel.=
org> wrote:
>
> I have been working on transparent hugepages since 2012, starting with
> the huge zero page and file-backed THP.  A lot of the code that causes
> pain now traces back to me.  It is only fair if I share the review load
> for THP.
>
> Add myself to the reviewer list so get_maintainer.pl puts me on Cc: as
> well.  It is also my commitment to be more active in reviewing this
> code.
>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

Welcome !

Reviewed-by: Barry Song <baohua@kernel.org>

