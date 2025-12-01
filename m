Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DA17D111A8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 11:31:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79EBA6B000C; Mon,  1 Dec 2025 06:31:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 776896B0089; Mon,  1 Dec 2025 06:31:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B35B6B000D; Mon,  1 Dec 2025 06:31:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 564206B0089
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 06:31:27 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A8E1A1378AB
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 11:31:24 +0000 (UTC)
X-FDA: 84170686488.01.2579BE7
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id B372D40013
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 11:31:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IPOQG39T;
	spf=pass (imf07.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764588682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FCjWn4JyZ0MIQxuYrrv1+l2KU3/wPwCMbrlzyLXQJOQ=;
	b=UpB64bBnsaOj1zikMvrPSZJv70Twg6mYdzqmejd1npSeNbRuEegkXNebcoJrHzaQ/mx/Sr
	ElAwv1AN1mm6T56IdK8DqrMuYwvJtAFZgPu+mRAoA+mWiJLAd9Gw11G7Fsspkdpgr6s7is
	rtMRHGKUnfBQsbEdnau85I+WCRhHXUA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IPOQG39T;
	spf=pass (imf07.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764588682; a=rsa-sha256;
	cv=none;
	b=T4e9o8B0Uh8nAEF8lUgorfn8JUe8oN4d+YQ4RM+oXkiT6FVr0es1ZXKKqAqiaL3yldlgGI
	W+d0XWA/jsPyjYlvlkEce7+BZDyhcuWCmHMz6XOdB/HpH0spEAXVAxh5MXZqks67ebLILE
	8P5ECTKmmLqMfFeKfrBpa0O8MNlDCuA=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b73a9592fb8so1056345566b.1
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 03:31:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764588681; x=1765193481; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FCjWn4JyZ0MIQxuYrrv1+l2KU3/wPwCMbrlzyLXQJOQ=;
        b=IPOQG39T+0w2xFaGSd6JVDXQrzQy9+O7NRb8A7XDJrZfJGMRcjQTp7/cY+wya0Nusa
         SFZ9l7tNoKmEtBFKnfzCWJ6XZ9QIhFY3NUHND+G6wOevZpRZX3P/eiB2b0r+xwCvii53
         5RbO6oIJC74wu2aIMb3gEgzBKX9AQXUFhICxORlCi+Wq4bPdQb/Atlj1v9EiQ2U+b4jF
         z6My8z73s1W/8jQXcLWgkhQQaPmF0kYB1eRr+FJ1F7LlynP9IGzQ2NhjKiFeJkHQ6YWW
         Lcbxy+SPNng1InWSs2N3sd7JwVSF1Lp2zZ49AcLjdjwEtbHn19lhwML6Kx39dEEP1lBl
         284g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764588681; x=1765193481;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FCjWn4JyZ0MIQxuYrrv1+l2KU3/wPwCMbrlzyLXQJOQ=;
        b=pXMPrbvvusViduEAER6PDcXG+DyMKHIzlA7OIT+PH7ZLCIvZZAM901OsPJfOgoXxzO
         d8zOMD/7rpaFHZYkXdUfxiFJps1JlgMGlwKhvxBC7luLdWdpHb1yGgBfwpFoRatKfjW7
         Idl+zdKAQ2mA+4iNsPAOjBj2W9oCYGluhaH49qXj8zaBwf+pWukb9Vvy4ZEBNMb/Q1mV
         Xkoj3kOjInK+eTOjh7rhnj8imJbsOvRqN9AaKXOq5wTHdH/Dx02s429MsrUl8uo7UvAl
         0lyOVveckvaWLg3e95XBVap8qSC7vaCx4N2uP9lSQ2ye4O44b7o+Q+A7gWg+GfiAZY5c
         TCAg==
X-Forwarded-Encrypted: i=1; AJvYcCXGjzJbKGZqZ6Ne7UiABuJrML60Lb3sc2WvfEyb+ExGhjkmyxwNFdjKyC/KT32QxjRO8xdiSp9kdw==@kvack.org
X-Gm-Message-State: AOJu0Yxj2Em1Es1ERP/01ucP8nHuuxKbdcKy3xBE1rhDQVz27dcMY5fA
	SkW8XNHjEQgIE6UZFCpc/Pauom54Q/zGFIxq5BX7CcIxFVB/3okBlqjm9Aokmgc7ThUOFLzwbUB
	uFcwMz5B5FL4L/UkHcoAPw9MUSpOG6ro=
X-Gm-Gg: ASbGnctwjdSCyEfHb71YugXqxB8LiY43CElhubIelcsveR7dRKGCUXo+rTkc2UyLd+c
	1ggZCehY1fMgQRcJsZfmhIyLhqzfudXJ/MR5jQtjW4qPwm66Qo4ghYZNo+v8viAFZBwHWjhZNk5
	DdfDs99CZmgW/RhovN4cGoong79rnOSUcqegr6GhVL7IRb+UAKl+FkxiNXxNnRcxL+hdBK9SGoO
	Tk3f7VHyMBcjIeFyt8eeCGyc7/bODKP75gtBzEBL5Z/3vWPfXY0t1CJfFxdtBpPPCd7IUxqy6sR
	iAIV70+9pCty9JaIDLRiziV5ig==
X-Google-Smtp-Source: AGHT+IHOdTLkZJaswibA76nq2FRhhydcxFsHanS8FUTomjBpYfSjGae3n+YsOlr5b7VU1wvEW02U1+HtyjJPwL2UzUA=
X-Received: by 2002:a17:907:9811:b0:b73:1aba:2ebf with SMTP id
 a640c23a62f3a-b766ed83649mr4703127466b.2.1764588680966; Mon, 01 Dec 2025
 03:31:20 -0800 (PST)
MIME-Version: 1.0
References: <20251127233635.4170047-1-krisman@suse.de> <f1a1b7ba-c084-4e41-9242-8255f2664b76@efficios.com>
 <yvghqmbugs3oejsvbh5rrw76rvtr2wfwqysjd7tw67z4tzpdbp@6zehhuzumiez>
 <CAGudoHEyX1gdwG_MVf-M2KMHBE1Juo6VbfSyp3rbXoS+5JaNtw@mail.gmail.com> <aS1wPxSdd-WcU__K@hyeyoo>
In-Reply-To: <aS1wPxSdd-WcU__K@hyeyoo>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Mon, 1 Dec 2025 12:31:09 +0100
X-Gm-Features: AWmQ_bkxdLFdVJUC3WJDrFMVPGHgCPpiNxbg0GapfU6O7pQ69z8FW89lt3WqPd4
Message-ID: <CAGudoHHeqvtK83ub1FPuc4JYk4XMxPM+Es=Pp3V0Zq-EKGBs5A@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] Optimize rss_stat initialization/teardown for
 single-threaded tasks
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Jan Kara <jack@suse.cz>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Gabriel Krisman Bertazi <krisman@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B372D40013
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: qf5ziok4mux6i3dbn58mg19yqzrsm8f4
X-HE-Tag: 1764588682-796287
X-HE-Meta: U2FsdGVkX19RaU9jd8WUWyPr8xLFYLfGks3bK8CWJ3GBL7C/r7MO+4qa7FzKfOs008dVIl4KWeBHmuDY4yYCGowr0DI8RaLmhcOoAr0uKNmLLPwU4EgIRRjbAkQwJJor5l113zcNvSCVZPkTkimyulSDx0hR9VUgMudpy/gvjFOz4qkFYqkNdN2qfpc5GV54z/fgF5Eu9R/a2fdt5FOwlaeIzo/B7UT1E4uxPAu6U0nU9ujD23vH555pWvP42EEubGKmZwW6xyAzd9S1/Mdu0ItTbu1lVrQzKDQtRG32iTCQ6X2SibVTvUwn6R9Pwr19w77yad1/v9/MRCbkjzT5GKkAoldIj0BwbuPuJI3ri5aP2ZyGbPjDsHxKgGQddB5KHeriRPQkolvdiGip07RZc1gUMhDv0jcsdeFN1jXNON/xjsFpwQCpb4eJhXnFle57mVAW2MT39Zirb9fsPlXJod9RQi5kub3p6VVlfNyyZX/oxp/MKTgf/HBe5MaUIV4oHOYJOWb7g/SSa/3Mi9+y+AxfzxerxQkfOpbn4p+/vfwncaZy1P9V7C4ju3LIngpxsYnrgGN1EzzS5k9RtQoYHRP4/I+EjypkPdhZF6DgZ0pZvUH9c822xwu/FE0bEPqPmmt1LGjUhmXCL4bdwevm/HFlPHlQGtexTTBNDg9oMr8WL8OmCBiGh8Yt3qVsxGpDTbfIFV+aLHCAgWS2jbuV923qqscHuQFgova6Nq0/U9irhrtIysEa8eGHAAmkuLj0JJo1vigCjxvj3soiKC7WoOuvpzUSt3hIloIPDkvipmaB4sIpu4pOKFKeRNGtDHsjIsuyiPJvtj6dGOwqnNibuEPob9JEi/o7U7c00PQyNvdrADGfgSX3XSlO0cXglzw+FIkhtQPynPixLbE7qlsfV3xbu069TLo1OMjKGXFqewrfv1B6qnvaWK0NS7RTKOZeQ6ziQsdvF/5ltzGBxzf
 qGuknm95
 R6Y6YlzACjTBanr+BKQeX5KGt17Z0eyvYKB3BnkTboi+UbvcOXsbxXtXU8n725hulSzre6031Kp6jOjSGgmjbZMnv6c6n7EWgQckI699HOk6dDJ39sUZ1X55MHiggVtj+TYnXdG/zO3BE3BIfvYQ9SMWe4oJ9AYhcAZGSmgIL2FozKWzygeOB8sPobl8MvnzLmEGvXppZvrqMTCTQEvrkFkXJGShNEsMQmvhQMDEG/RUYVsQDpdhRHGKWZBhIcpfTcqmpd2dIP/U09SW+SVUS86ThI0rj6PCJ0IS18BzoPuyqbReD8/Zmc44jLsF2ZAXOztNz/dr8fWE5C3YEB81rMf+vxvTPK7sCAoZ8hzpeIRNo7N/cGMH6zcUVT7Y167a6Tyj13u1KTGziN2EwODj+5lrcMa615XSSKXXCv/WUGKUZ1ymBs4ny0yH7HZdlsJwTFLa+zkvRBxoQxgk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 1, 2025 at 11:39=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
> Apologies for not reposting it for a while. I have limited capacity to pu=
sh
> this forward right now, but FYI... I just pushed slab-destructor-rfc-v2r2=
-wip
> branch after rebasing it onto the latest slab/for-next.
>
> https://gitlab.com/hyeyoo/linux/-/commits/slab-destructor-rfc-v2r2-wip?re=
f_type=3Dheads
>

nice, thanks. This takes care of majority of the needful(tm).

To reiterate, should something like this land, it is going to address
the multicore scalability concern for single-threaded processes better
than the patchset by Gabriel thanks to also taking care of cid. Bonus
points for handling creation and teardown of multi-threaded processes.

However, this is still going to suffer from doing a full cpu walk on
process exit. As I described earlier the current handling can be
massively depessimized by reimplementing this to take care of all 4
counters in each iteration, instead of walking everything 4 times.
This is still going to be slower than not doing the walk at all, but
it may be fast enough that Gabriel's patchset is no longer
justifiable.

But then the test box is "only" 256 hw threads, what about bigger boxes?

Given my previous note about increased use of multithreading in
userspace, the more concerned you happen to be about such a walk, the
more you want an actual solution which takes care of multithreaded
processes.

Additionally one has to assume per-cpu memory will be useful for other
facilities down the line, making such a walk into an even bigger
problem.

Thus ultimately *some* tracking of whether given mm was ever active on
a given cpu is needed, preferably cheaply implemented at least for the
context switch code. Per what I described in another e-mail, one way
to do it would be to coalesce it with tlb handling by changing how the
bitmap tracking is handled -- having 2 adjacent bits denote cpu usage
+ tlb separately. For the common case this should be almost the code
to set the two. Iteration for tlb shootdowns would be less efficient
but that's probably tolerable. Maybe there is a better way, I did not
put much thought into it. I just claim sooner or later this will need
to get solved. At the same time would be a bummer to add stopgaps
without even trying.

With the cpu tracking problem solved, check_mm would visit few cpus in
the benchmark (probably just 1) and it would be faster single-threaded
than the proposed patch *and* would retain that for processes which
went multithreaded.

I'm not signing up to handle this though and someone else would have
to sign off on the cpu tracking thing anyway.

That is to say, I laid out the lay of the land as I see it but I'm not
doing any work. :)

