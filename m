Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E43AD606A339
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 20:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=pRHjY3Fd
Received: by kanga.kvack.org (Postfix)
	id 08A5F6B037D; Mon, 19 Oct 2026 16:53:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0624D6B037E; Mon, 19 Oct 2026 16:53:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBB2A6B037F; Mon, 19 Oct 2026 16:53:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C57306B037D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:53:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5825CC07ED
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:53:03 +0000 (UTC)
X-FDA: 85340575446.29.DC51C4B
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7A7FD180002
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:53:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pRHjY3Fd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792443181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DKddisKzxLuVQIaXtLpNXNAV8kvVeTeFgFk5M6wbup8=;
	b=xhFEy9yc/rPU/c9PlfwH8GaKmi/ppfFRYCM3OWgeIlhuxVnvb2vqulkVuDyLoJDOmBD94C
	8uzw+sfCH4OIxkA0FqVr/c2pv1zxYBAwzMupv2FznPsKMY1E2GzrxNS2AyBaY2MPZFEebw
	vSpXtxfUCA1RLtDl9CB99dLj9jwh50Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pRHjY3Fd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792443181;
	b=fe+7BgE67m/VzC04yeEcwPTv7y62KKFfP4110hJfdfRGQfXrUvovxcDAyXaPPTi49oypJS
	rPhZNCdHk+sO4uOFnZENZvcd+kiDzu7ghIAgDTPjGcu/7+xRV9KW4oDIWtEHUiVpfeB+bD
	TcovIMBTitSIbrfS4J3TEh1lpLcAJ6Q=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-49d05d51553so17717565e9.2
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792443180; x=1793047980; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DKddisKzxLuVQIaXtLpNXNAV8kvVeTeFgFk5M6wbup8=;
        b=pRHjY3FdWeigguHSM1TMUI03LAHGhKOIg4BPVAj4KGtAvyj22WBuSsQBEV5JakTxJ2
         J+TyCrJufhzlvfQkMYylaz+5+hU6qYMJ3au1fD3K0Zo3bTx3sukDTWDfjtG8rhfkWbiz
         xTPkuBXDj5rHXq53Mxe46+GlsC5WtHYom3zk7FWYGtqQUATfmzq6wRMMLTmA7bPql/4k
         oK/u5PgkDa/DtnAdAq5kpZfIsSPHa0XLUYWUPGWL0ZlF9sFkTxGeHWTS/ZyibYxqF7Xk
         zEWcdWEwywRzxzM/k/nuyLfziaGWsyVmuH0CIDKI0ZQQ42HjzbsvtDLksh5CP/zSkqKm
         xTDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792443180; x=1793047980;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DKddisKzxLuVQIaXtLpNXNAV8kvVeTeFgFk5M6wbup8=;
        b=i/N05rXHIEEdAfET6ASmE+3zNiNKV/eBo0MqT/BxYKMnNaDF9QvXqCCjHI6VmF7LGN
         KNduPkXQdQJlnXOIgNJHj7aB721/e+H6SV44FikJFDG6FQsKcB+xlCIgF45f02+LpV8x
         ZPGzAcUjinKAPa9rAtTPs2idESZ5Yj03XveewsFlCMbcakAJGzWrHQt6aev31iSEcx9m
         8IP1lpNAuH8aXt9C61O1/6g8gLGJ7F5BPn+P9F1LBS5exCKdezLZzy5+S/FQoCxRssl8
         ZwWcd9O2DtVd6m8RaGVGcHl70IE4DAMZFMH/KhbKAGVDndLuTe4apJpu7JIlOYIxN5u6
         16QQ==
X-Forwarded-Encrypted: i=1; AKwUvByD2VvdRX0SmaaBJV/owZTdzIY044S7mOrUi+LtK0IkKX1E/vAa+TIevjwM6uifsxw1lVN9q98xZA==@kvack.org
X-Gm-Message-State: AFq9FYJTG98kbi88SIfMXnHALsxUAoAUGYVtK5GZh+MHcGaRj8l7GGgn
	Zg+4Xhw7QzX4FLuu9/cvaRK+qFzdPxKPJveT0OLSSCDEJuK9clGJ/9ch
X-Gm-Gg: AYBFou3XfNMyobYVX4mNqwytu/DLEnIvjUtba3VhVgsZ2m5+C2ca/Utxqxifm6mcUrq
	wToAKazdJljdRArVDq7K5nh3xF8rQkkTpNlyRbtno7VFu6DsKJQPJrrxcHkvAy08/GDrRsp4up1
	P7BxqVGiv78ZULnNKuYmWzzkTfRcvVvUQ+xjli8rG9jCSqm6hejQ4WXaJ88nApNePughRCY7TuG
	DTCj4H8kpgGNH1+hWZa/3aI24YzPTQmviQg8wCzgVdealpd7QPtSa2y+tR4hLMXk9CrDhh2DNAO
	sWtc4ujO8i0Kao3KRhcrNtARH1LEsu70ghNREWdtfeCD94LUm9eXhOWZrIWkpMG6p+aol750bdP
	TZdmoZQKR9Bk0BL8gq7TaTDiedHvQ9bBuFj8l1hrsxi2s5nOqZs8Pjm0S6lHG1ASxU7frwPe+Ua
	HEdwLxz9YrVTtrcxYOJqSZstvdeD3J2NspGHcju2Mvx3e8kuC4nhU2VoupMsNogpsEY+TS4pRYA
	CthrH7kWRVkK6Z4TEl5bIWZR2VoDZnA3nhbvMui7B7uZIF6vtZZYzTsWSCwKG/aCF+O3qFem03X
	9nUP3Jbpo/stm3Tv
X-Received: by 2002:a05:600c:4e8a:b0:4a0:4a8:d444 with SMTP id 5b1f17b1804b1-4a1d7630cf8mr199302945e9.33.1792443179571;
        Mon, 19 Oct 2026 13:52:59 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1f2c9f301sm16245455e9.2.2026.10.19.13.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 13:52:59 -0700 (PDT)
Date: Mon, 19 Oct 2026 21:52:55 +0100
From: David Laight <david.laight.linux@gmail.com>
To: "Garg, Shivank" <shivankg@amd.com>
Cc: "tejavojjala@google.com" <tejavojjala@google.com>, "Rao, Bharata
 Bhasker" <bharata@amd.com>, "rppt@kernel.org" <rppt@kernel.org>,
 "ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "vbabka@kernel.org" <vbabka@kernel.org>, "akpm@linux-foundation.org"
 <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>,
 "mingo@redhat.com" <mingo@redhat.com>, "surenb@google.com"
 <surenb@google.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "nhuhuan@google.com" <nhuhuan@google.com>, "hpa@zytor.com" <hpa@zytor.com>,
 "tglx@kernel.org" <tglx@kernel.org>, "liam@infradead.org"
 <liam@infradead.org>, "Salunke, Hrushikesh" <Hrushikesh.Salunke@amd.com>,
 "bp@alien8.de" <bp@alien8.de>, "mhocko@suse.com" <mhocko@suse.com>,
 "ljs@kernel.org" <ljs@kernel.org>, "rientjes@google.com"
 <rientjes@google.com>, "torvalds@linuxfoundation.org"
 <torvalds@linuxfoundation.org>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH RFC v2] mm: introduce copy_mc_highpages() and batch copy
 in folio_mc_copy()
Message-ID: <20261019215255.17455ebe@pumpkin>
In-Reply-To: <b22a59fa30183e13043e69ee91dfc77eca4d4a26.camel@amd.com>
References: <20261019-batpagecopy-v2-1-d75e7d0dfaae@amd.com>
	<20261019131901.7a8fae90@pumpkin>
	<b22a59fa30183e13043e69ee91dfc77eca4d4a26.camel@amd.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7A7FD180002
X-Stat-Signature: 6onodcd8wjd7ytdempy11enxij3jkw4w
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792443181-374672
X-HE-Meta: U2FsdGVkX19rtwp+zyXY6jaom/xy97SH1JU6ytAQcVzjvQWEIC5IuVlWifXkeq7lGO5Qay668bFPM6GW5lb2P0JyVtSAJ9ub7P3FiD3GnMgI8xHyq4oVWRkV8s05rMeRKygG8uwSeBkxs2awdIeb8GOaCcoNqSgb6UWy8NFyG0UG15OjysuFVjfBkvf+YUEAlzOXXAC6hBn5r1P03i7T4unr/2PrCfMKp8oPWEMRVtdqwf46jL1ry4sbG3Qa+iJ5MitjYUNyZJl/Pef1CKRUOrb4iuiUCHoWKEzgmyNNtBcbccbH2QRSt1XEhI9Vqn4nXufhCXlZWFDyE/xY2cP3uG+1tJQn8ZtgezhxhaLuqTflOMj+T6zzNf1bj2tDoYjNokM3ZUxoNf/KBEJTV3CyciViOcFrDil+emVbC6yQGUQaegSTt3HO7k+GzNlBeKEFZWkJ27K5Ewban5dNb9CQpvEtsRvmZPcHYbrd5me/WyC8RwmG1ylQSS52zJcfCgDjFS5z0fDn+y7ErTcxuvmM/klEs/KDSTiTxX8jamJ8N9W4229hn63sZI68rIJdPYftud4RRFGp0qc4lgvIjT3F2CDql23t7f3K0fX+bRJ0tx4MgmGQ1VOdH0FgA5onqS3NIsauUKqwnHft1N1nYgpQCuCGXfUo0wtrWw867U/nfY72R1PAA8lLYiC2Qo+DD0knKXoyXi5vOB/iNP7fbNv8ZM5/I+pni6EK+tGNIhwGUDiz9Rtatcjv9m5p8AE7oyTL1oVHkO+MpMAe8v1SlIaWL0FqVzy9nSS3kCyxzHlUwviWCzWbhZ81RBd2o8GJUJKS4l9oD7Uz6JoD1FF59tqpOe0mccLCoqV9jYJqqsrVDQ8L4OBcnLmZe0YTV7L+Qudw4op0l9LEZS27+hV2P5Lmunj3TLdiffCglW7NpJiAuWw+wkI3s6ylJyTFOfsyDLaL4B2yIUyutH8D9gcwrCl
 FqStd2wi
 em/ze1SGBXGWd/tF2TLepr5o2bQtmkMT+FpDfAdzovcf14XnUzv1RnCwOKZJXBhCXXpTmEhf0X6zd9PqmOtPvKIVWxXCR4eZT9A89VgR/htWP5QP/cVJh4J9+cR0ADZiYGwCdFQzn6QJs57CUWhSkRYoE7Otly6884G8+9nf/baTFtbJxzNPWL+6mzjjk7rlBp/wdvV4q98oGy21MHNf+NtEFy2nvjx9CyzWUeNSOq7SrChg4xMX9gzhUY72v86tREhTu7g4UIX0hzR8YohpRksM3AEQ2sD8mDZHIi42GTkFJL37z4g7jIhNyeqLFOfOabd4CMFbuPO4+nBj153KH/2WPMtww1J2kz/AqZJXsBf1AZuT7ejjqHgt5tyS5nTKWZaqwEpK0LEfF6EDSLQutEZ+DAvaKxS9LU54a3/286Ye89c3T9AOQ+op1Ek10oZZXuim+kgSy5x/C20UOXLEVjQlsuLScbF41gID2gMvntK9J9M5stpNU/EHWL2TExR63UE9/Z6hxTxKoVs+BlaI2Ux7S2GKsmHD+a40Y538n6/mtXrWN97cZ42O1jUqOSUJb2MD7jmNyi2+1FXY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 19 Oct 2026 18:54:26 +0000
"Garg, Shivank" <shivankg@amd.com> wrote:

> On Mon, 2026-10-19 at 13:19 +0100, David Laight wrote:
> > On Mon, 19 Oct 2026 10:06:49 +0000
> > Shivank Garg <shivankg@amd.com> wrote:
> >   
> > > folio_mc_copy() copies a folio one page at a time with copy_mc_highpage(),
> > > so a 2MB folio makes 512 separate copy_mc_to_kernel() calls. Each page
> > > pays the startup cost of the string instruction ("REP; MOVSB" on x86
> > > CPUs with ERMS) plus a cond_resched().  
> > 
> > Don't you always want to use 'rep movsq' for these aligned copies (on any
> > cpu anyone cares about).
> > I'm pretty even on some that don't advertise ERMS. 
> > 
> > The fastest a copy loop is ever going to run (on anything but the latest cpu)
> > is one write every clock - so 8 bytes/clock.
> > A 4k page will then take at least 512 clocks.
> > Even an old sandy bridge cpu will (IIRC) copy 32 bytes/clock if the destination
> > is 32 byte aligned (not much later cpu double that for 64byte aligned destinations).
> > So the copy part takes at most 128 clocks.
> > That makes 'rep movsq' faster unless the fixed overhead is in the P4 netburst
> > range.
> > (I was using lfence when I did my performance measurements, it hides
> > the fixed latency of rep.)
> > 
> > I've never measured zen 1-4.
> > 
> > I also suspect the slow part of a 2M copy is all the D-cache misses
> > (especially on the read side).
> > 
> > OTOH the longer copy is likely to be better...
> >   
> 
> Thanks for taking a look and for the detailed explanation.
> 
> In my measurements, 'rep movsb' and 'rep movsq' perform about the
> same for aligned, longer copies.

On Intel cpu it makes absolutely no difference which one you use.
But some of the older zen do handle them differently.

> 
> Since copy_mc_to_kernel() takes an arbitrary length, always using
> 'rep movsq' would mean adding an alignment/length, etc. or adding a
> separate copy_mc_pages() (or something similar) for page-aligned copies.

If you know you are copying aligned buffers it really is better to
have a copy routine that can rely on that fact.
I suspect it is only x86 'rep movsb' implementations that don't really care.
Pretty much all the others are going to have code to check the alignment.

David

> 
> I think that would be worthwhile x86 change on its own, independent of
> this series. Here, I'm not changing the underlying copy mechanism and
> behavior other callers.
>  
> Would it be okay to have hardware specific changes separately?
> 
> 
> Thanks,
> Shivank
> 
> 
> 


