Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2597D116E2
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 04:14:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 003F36B000C; Sun, 30 Nov 2025 23:14:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1DD56B000E; Sun, 30 Nov 2025 23:14:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E32B96B0010; Sun, 30 Nov 2025 23:14:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD06F6B000C
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 23:14:17 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 11DF313318F
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 04:14:14 +0000 (UTC)
X-FDA: 84169584828.18.D22DFBD
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id 46B0B1A000D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 04:14:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mxnv+GkE;
	spf=pass (imf19.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.217.51 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764562452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NvqfHUMOZNX470bp1dryFycFk+/R03rrhA62xaGfUj0=;
	b=yVFk7IGFiTTeux2BwheT7EIcI9wrQgOJ5o5tCotLcIhM2Xo4wi9aBcEf3YeNy/Xut/jJsB
	Mi7+H2DfH+ln/v+aejcpHY10tzaDE0xp+ZsIfT/p5MtngZNxsbuLnKBq3Bm/h9AvZA/+t2
	aQdgGOLnuy5Wh5cyVYf7z2I/VtAMOGI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764562452; a=rsa-sha256;
	cv=none;
	b=USwzWHtbFXUlnW391wcD7P91lhGUR+Ov9Q1hf56kEUfJxhCcsCwtFPcOpV6kNjLRmx9FJX
	BVUIZvwdVDIJixBDWf8oZjKkRDzNubwdiNATeg1W9UJsNAiblRymDeG9e7KBvB4TPJyq+H
	o/z/IEI52dE1Kz+VHGIS+X83mkBEaaI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mxnv+GkE;
	spf=pass (imf19.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.217.51 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-5dfa9e34adbso2952090137.0
        for <linux-mm@kvack.org>; Sun, 30 Nov 2025 20:14:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764562451; x=1765167251; darn=kvack.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NvqfHUMOZNX470bp1dryFycFk+/R03rrhA62xaGfUj0=;
        b=mxnv+GkEsDAe9mjueeiLuesqtwKFJgDF+sOwqwz/9oze8md9Dx4ligSRFs9fy9A9ic
         /zQnSFdnItaxa/0VsN6grMeSg19VnPfVvKOzqUJxHuGKxizsG0mjSysbBt0rzmCQVugU
         jEzekpOA9Asy51pw3lsvSeZV0aQyIsKEVMwpDg6Df1sYd3qAwlu/K7LoeWlLZ5WwL3rT
         eHuWBkDNt/e2bXk2zlcfh/tyNp1QxWyR2HUjjXq9L31BUzCzmlh4Qp675UyaqaYSt3kS
         ukl7Z21DB3sdoDKtxb88/Ym3ap6ztQ2NsGoo/cNXeHbxlw4CDNpeuGhtOJPbiKK6oHVQ
         ts1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764562451; x=1765167251;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NvqfHUMOZNX470bp1dryFycFk+/R03rrhA62xaGfUj0=;
        b=YFfi72A9lofsZVp5Lq8pOOYwhGoBmiesquD68Yw5RDTKjAg6KmCQCt9zwThRej2y3J
         +RjgvxX+aHqC8cxnvLkq3RRuCkQC2CF/6sKeuce5x2B8n6SluRTC2O7Y2KHtJtAmuHqh
         iAMwZPCrNm3akQlH1MZTUDUO6kh+Ia+Bv9RJWRRN5cyCslqAYqCIeOOsd7Om1yx9QrBI
         k7sEKcqKXz9YjrwZn1Y/hYRMfMsmyL1EJrt52XItAwGjuBQMUJ1Awwsp+YgjxM+VkqrQ
         JMuW8zBKha5iOKl5jv+oHutcOEPX96iBPaGekkODkrxlw1emHgVsSMCaEh/eU/rE+dQz
         8HRA==
X-Forwarded-Encrypted: i=1; AJvYcCVSkEbzHlr2oyuQrtHpvzMjzhZ+uxnPGtmqMjVmNOPuId6OD9n4yrfBUwOEmURULgxqdnYxPn9eBQ==@kvack.org
X-Gm-Message-State: AOJu0Yz03gTaSarqxrKDaNLySAcY50kw7v/g2Aiw+ZaV2gFIXAMRqcTv
	NPdAhYHM7pe9YtrL9uapdRTBgbAXPiYddhtkmVZXje4LpjLsIr77WqAp6gWNHEfWkvB28UCoAAq
	NQVh+dJk4Y0oZU303sYP0JPUAB56BJ0Q=
X-Gm-Gg: ASbGncsdIp+aSlPC+ZEKx16OYFMvo8mYAHm5rmKAxOP+QWcjS0Z5soNZBhdwO/agzuo
	LgHthzJuA5hwFZXmcRBKT005fptyru2FnggGGgnqceZrBfVDZFmN1oYa+RkQ7e2FcPGnQ3OqMIl
	1ZaF447C1YHc7BaAqkcmmD3NvwCkrfilfbDmGwD6Nv3TneZWnv9HUrJBnD9cKJaCBei6//6BgIW
	cifmkT2n5E/kA/w/pLC26HQeWDvQd7whakrwCrmww224kG85/A+NVSUq/pApG1t0VKLeg==
X-Google-Smtp-Source: AGHT+IFQFaTlSgrkPrDF34ZzuXXc6tRWv7IWzSI1FLwFBEaeyfWtvk4amHL87+8261TG5sC/U7niA6iwfCoFudViaSk=
X-Received: by 2002:a05:6102:919:b0:5db:f15a:539d with SMTP id
 ada2fe7eead31-5e22423f36emr8227948137.7.1764562451234; Sun, 30 Nov 2025
 20:14:11 -0800 (PST)
MIME-Version: 1.0
References: <20251128025315.3520689-1-wangzicheng@honor.com>
 <aSm800KsCAptVZKu@casper.infradead.org> <ti7h5cbrg5s3zf7surof3zmxb6supnl34x7hsbziqutm7r2laf@zuunap5hwsbx>
In-Reply-To: <ti7h5cbrg5s3zf7surof3zmxb6supnl34x7hsbziqutm7r2laf@zuunap5hwsbx>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 1 Dec 2025 12:13:59 +0800
X-Gm-Features: AWmQ_bnCsLVtTt2xe_A-3mmx3kROTPC9EO7s9FoipJAT7VnWafh4GCqMSpp-xoE
Message-ID: <CAGsJ_4xJ5qMght93FQOYrk1OiJTh-wFC4e8Nd4K0A156N3ZEBQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm/lru_gen: move lru_gen control interface from
 debugfs to procfs
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Matthew Wilcox <willy@infradead.org>, 
	Zicheng Wang <wangzicheng@honor.com>, akpm@linux-foundation.org, hannes@cmpxchg.org, 
	david@redhat.com, axelrasmussen@google.com, yuanchu@google.com, 
	mhocko@kernel.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, 
	lorenzo.stoakes@oracle.com, weixugc@google.com, vbabka@suse.cz, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, corbet@lwn.net, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 46B0B1A000D
X-Stat-Signature: o7sr617xxbuksmpnqymix8roxo8399hw
X-Rspam-User: 
X-HE-Tag: 1764562452-56423
X-HE-Meta: U2FsdGVkX19mMetDh9NLufTB55Jr1wULWBtXYWwTkHFW7zYKoUcfxF7zvnNXnnjCUH+RRKkfNi3bzXbKaAaBJJdvuvJKOC1OjZAib7h1L+TaRWn0J55dTFgmx5RDTak4nUX1HGAuO/MvRv0lswdqKgcG5xuYy51oLo8jzZ04DqC8XJz571her/8cNZRTUcIFcuj4FCPK9Vi5cSRrKDLpCKF6GAVv6x2DWV7Fp3LxYti+jgD7jgP7gAG9zgINORshTGwjhqxqfJ1oLrLKPydW7I47OzdfcW2IJiNUKBMM/bhNftRpI4v1Ore8owRwNE89Wp12yJBnXEhX6qz8aw39o2aXw2iQOaiyGJbfTOiN6XrjdGD0snHci5NxAqS8pa7FWrCtRUw4RMX8JlHGJpMOcOkHEprN/wuoBEMcGssd02S2eMMi6jlcGCnZb3myizvmkZJlcJUwRA/7ZocyaDBMSfNUW7Rm37E46FgW849rIRoocgC+hj090piZepwjFFYCBXb+ctqQcvFdVTxjQDjMRo/J/qk3tbSwiumIWzuyhKwPtjQgsEkk38LOPwNCRk0zEGlYFL/N4rTCa1YF0giHNdnmF1B4o4sivryqTcvC04IdJzyTPg+XrmG1rRf5oe4oMyW9LAw4tLlGKBYxw9bktvHz/CBsn/tgSeL4QK/MM8bKqe6KzvzGsgRtiH2LiSwAzEOPwv2bD8cYSo8PYZWPnoNu096he51kKgyl8OcrjEW45BKWsWUc9ktJ+zv1bzW2yzOkGE6oZJG9cSH5AH1l60sO9Y/8BoLuQ3CZj9Zxi6qaxRA2aMvYA2ZSKbaguZ2WeUbkdmVO8YH4aIbiL3s3SwLbGr31+/ota0+1kaBwbO33sehHe/qC4dCLYG5x60EKRByA5TCQT45B6PEXBgEZxKaahuVzi72skqFPZlQIsI0pRVpu80Pg8rBKeubwuDAa8zanWFXdU1I9OGDdLq/
 w3wKHo2F
 qD278bHpKDt4PWru3b84j2Q3MoHIqrU6Rfbm3Hl7jADsOz8RkbXlsBkg4ywmbQ6uXBkmZsiUaJyfJRdJSMzssg7qFC7U+kPF1Hxzt+K5XAfJmhFPkSJV9Ztp5/CBI6pecCX/yCb38/idqc8LryONdrtXGJVgzKw2wY9vgl5tF72VAEfIxIO2qKpx62BLBkbOvO7Cb5sl5o8h/8TmG/WsObGKYJxKISQsEmjh6KErwhR5/YLj83mFOfGEgdVPCNeeGWMdqipV8CHYE6vKR/tzyh85KyR3o+eAy1ld628GzmDnGFIyyrbEMu1G6DFaLQckJjWEIl3Spbdm3q5suiqQsYfjr+D4OjDeZIxfwT18tAhNPz5FKCIA6cEt4NmGMOhfG+5iD6vdGNp8Hu2wlwT25lGPXHDsyd9rXugG2a6fjuY9mUdImrn7OODjVPk1UlMddhUOxAlCmdKt4thNX14Up3TdKPbH1mvbdzaJSbsQzKKZse9VDsC6I2gl/MaTSdQAQu4WKzR3aB3vpMXrUcaG1oO6Lcg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Liam,

I saw you mentioned me, so I just wanted to join in :-)

On Sat, Nov 29, 2025 at 12:16=E2=80=AFAM Liam R. Howlett
<Liam.Howlett@oracle.com> wrote:
>
> * Matthew Wilcox <willy@infradead.org> [251128 10:16]:
> > On Fri, Nov 28, 2025 at 10:53:12AM +0800, Zicheng Wang wrote:
> > > Case study:
> > > A widely observed issue on Android is that after application launch,
>
> What do you mean by application launch?  What does this mean in the
> kernel context?

I think there are two cases. First, a cold start: a new process is
forked to launch the app. Second, when the app switches from background
to foreground, for example when we bring it back to the screen after it
has been running in the background.

In the first case, you reboot your phone and tap the YouTube icon to
start the app (cold launch). In the second case, you are watching a
video in YouTube, then switch to Facebook, and later tap the YouTube
icon again to bring it from background to foreground.

>
> > > the oldest anon generation often becomes empty, and file pages
> > > are over-reclaimed.
> >
> > You should fix the bug, not move the debug interface to procfs.  NACK.
>
> Barry recently sent an RFC [1] to affect LRU in the exit path for
> Android.  This was proven incorrect by Johannes, iirc, in another thread
> I cannot find (destroys performance of calling the same command).

My understanding is that affecting the LRU in the exit path is not
generally correct, but it still highlights a requirement: Linux LRU
needs a way to understand app-cycling behavior in an Android-like
system.

>
> These ideas seem both related as it points to a suboptimal LRU in the
> Android ecosystem, at least.  It seems to stem from Androids life
> (cycle) choices :)
>
> I strongly agree with Willy.  We don't want another userspace daemon
> and/or interface, but this time to play with the LRU to avoid trying to
> define and fix the problem.
>
> Do you know if this affects others or why it is android specific?

The behavior Zicheng probably wants is a proactive memory reclamation
interface. For example, since each app may be in a different memcg, if an
app has been in the background for a long time, he wants to reclaim its
memory proactively rather than waiting until kswapd hits the watermarks.

This may help a newly launched app obtain memory more quickly, avoiding
delays from reclamation, since a new app typically requires a substantial
amount of memory.

Zicheng, please let me know if I=E2=80=99m misunderstanding anything.

>
> [1].  https://lore.kernel.org/all/20250514070820.51793-1-21cnbao@gmail.co=
m/
>

Thanks
Barry

