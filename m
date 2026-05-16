Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E975CD4F21
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 16:31:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 131C86B0088; Sat, 16 May 2026 12:31:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E2D76B008A; Sat, 16 May 2026 12:31:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F13656B008C; Sat, 16 May 2026 12:31:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E03766B0088
	for <linux-mm@kvack.org>; Sat, 16 May 2026 12:31:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7D6751C0ED1
	for <linux-mm@kvack.org>; Sat, 16 May 2026 16:31:26 +0000 (UTC)
X-FDA: 84773823372.01.FC7B65B
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4456CA0003
	for <linux-mm@kvack.org>; Sat, 16 May 2026 16:31:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=aqTBUYtd;
	spf=pass (imf25.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.46 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778949084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MFHt3WS7pPHky8hdFM5dT7wdhV8XvIh/WfyCtsbWs3s=;
	b=Wkr3cRu3TczwgOBOIa/mq7ZU9Oq4QDjdJk5CfFqJFjUrlrtVoaqXItWqA/JsEQHqYSOONo
	t5TcrOV1JuWL0dY/vyb4DJVefENqYiZDcZL+AVlgxuC2hBG7V220fUcTJC4JI6yH3oCK/A
	fMpfaVdLuJFVI//OeIl3fg34t0yBE5A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778949084; a=rsa-sha256;
	cv=none;
	b=Nrvatkpe7kr9O6TiZTfa1vtaUFYbMMsMb8EDK7n8RH5NdCepUX1mxriWrazuK9u9XOE7Xu
	ygSVe8I8Dr5xxex+VAn5XYMXRp2Fh1U9lgvBSS5uWZYMTLiEP8+mSgOH0gDSrF9WiuewYc
	YMBHfnaNZctCfMfbBQwkfQPb3MJT5UI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=aqTBUYtd;
	spf=pass (imf25.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.46 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-bcd3c190f71so167330666b.0
        for <linux-mm@kvack.org>; Sat, 16 May 2026 09:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1778949082; x=1779553882; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MFHt3WS7pPHky8hdFM5dT7wdhV8XvIh/WfyCtsbWs3s=;
        b=aqTBUYtduaVWyXFzC9e7weAEFyRuiePhZVfzZg8j0J9JLHD2A88x1dgqS7jpU27T+a
         YAphGFJSfyr3Yi8D5065KPhEOhH4b95oc9O2EPzaXHz7J3pBIqXJ5mzcEG9wN+z1Rtyh
         0hONlh5QegKtSuxUWgLqsZGiUegjaQudtqotw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778949082; x=1779553882;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MFHt3WS7pPHky8hdFM5dT7wdhV8XvIh/WfyCtsbWs3s=;
        b=qxkLCrNmP/Xsy5/iQIUlb33BnKv4efg9q+fJXSlnTZhfrBtKfzmxxu5361QQO9AwKZ
         oHa8ifO7yB53/H94DbBweQSOT3hbPb0lFu2vmrinb6oCuENb74dxAddX8d3fHgC2LMxK
         W6vRVynNPjD9HOdwRmpTpAyOjB9uUsWhYtzyLDDn+bWxiYgk8se+wIpe4OVn9THC7R31
         VvOjrLMo7zmOhPGbQSapn2eUInvr6NRmSncZTyiRHBn172NG0nOvQYts1Onjn03h6Ykd
         0a+kI+c1oKUIyMBn8G6un1iqnJIiLGiY3AUqPOW2WHzVc5Nj4/EARb90pbTemmW2sILj
         YpYw==
X-Forwarded-Encrypted: i=1; AFNElJ8v13UCgbAl3eX0vhxmgrWU6PopzWomvJWtzGNIK1G9oO3VQvxX5Kvy2S/JXDKAW728BJPWQBlBEA==@kvack.org
X-Gm-Message-State: AOJu0Yzloyzq7P8uw0iPdH8byPOY0smBjUNpXWl8XWS1hRsRwZ8mP9mG
	JAkwGpiAIvFJKtNi1+2lIToTty7F6ybGy2Zg7DovId9vXNJFqJMzP9XW7Xm2At9dJbwOgLA93T2
	lnbrLQDo=
X-Gm-Gg: Acq92OE69LAHF3bAx0QWN6OwnjzQAl/oGIEw3RXuJN2l7QtaKur1cE6FoLfJwac5ic3
	75cWr1YwSbqD+CKFFKf+GFdwr+qfJVnfjYWIJdDhM8lQeX7lcPdLtdNUrFZmCpvxEfL33lQJhie
	4mlf6bs26cLH7m2I8N9LW9HHPParbhJoNeV48nWbSml6u2JIo8575MD0jvCq7ppM0K3evdv1nqI
	EDnX+fChri4y1meQOFOtCHPzpacZMbXOkxr8EreD+eY2F7tHHfoUnPVJeC2AlznkrzUsGXs1FH2
	Sh3FX9c5r+fHRYQtBNQ9mTcLc2HbjBGNxOa0E5BHAIvtRnx5tOue6Fop386r4HcYote/I99B+SI
	g8px+cosNDjTZ8yriLM9AXvbRicHLBZ6ns7UmBeUIW89LW8h6+Qnk/qvNk5YA59G+jgEXGGxKsp
	a6tfBepPeFVCzD10FgptomC/TrEwEdPSr9Egi/EkZCzCm4/DGtKGW/jhbfxHsoYrE6azqXn3zo
X-Received: by 2002:a17:907:c8c7:b0:ba8:8c8c:1c67 with SMTP id a640c23a62f3a-bd5177dbacemr481869766b.4.1778949082309;
        Sat, 16 May 2026 09:31:22 -0700 (PDT)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com. [209.85.208.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bd4f4bd0a24sm364362266b.11.2026.05.16.09.31.20
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 May 2026 09:31:21 -0700 (PDT)
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-67e2498f3a7so2246869a12.2
        for <linux-mm@kvack.org>; Sat, 16 May 2026 09:31:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8VcKMrgEt8SZvoXLtVTxjUCv0BW7MMBoZnEJeBoJy+fJrkHsrJnk14Xt7WwVxTUjSzOwP3ox6Swg==@kvack.org
X-Received: by 2002:a05:6402:4515:b0:683:f485:c63c with SMTP id
 4fb4d7f45d1cf-683f485c93fmr3646745a12.1.1778949080207; Sat, 16 May 2026
 09:31:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260511214226.937793-1-minchan@kernel.org> <20260515-nachdenken-umbenannt-a90006a46e14@brauner>
 <agd--WZpeTq2iKFW@redhat.com> <agefLhQeWpvil14M@google.com>
 <CAHk-=wiHfzbufXD2nuc9BhOVp-pYEmnVUYeThKmfZRXLU0kJ7w@mail.gmail.com> <aggE2haQ7yGeHPeF@google.com>
In-Reply-To: <aggE2haQ7yGeHPeF@google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 16 May 2026 09:31:04 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg08=sZb=hVa22KjN2pD3aNk-diGmKQnizCgmoMMfrvwQ@mail.gmail.com>
X-Gm-Features: AVHnY4KZeaxgoWY4xTggm78AB2OXkk6KHZZ0t4P5460-SnjHdn5OCruGq4QgY7M
Message-ID: <CAHk-=wg08=sZb=hVa22KjN2pD3aNk-diGmKQnizCgmoMMfrvwQ@mail.gmail.com>
Subject: Re: [PATCH v3] mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL
 flag
To: Minchan Kim <minchan@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Christian Brauner <brauner@kernel.org>, Jann Horn <jannh@google.com>, 
	akpm@linux-foundation.org, hca@linux.ibm.com, linux-s390@vger.kernel.org, 
	david@kernel.org, mhocko@suse.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, surenb@google.com, timmurray@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4456CA0003
X-Stat-Signature: ooig8hebpojzow465jmqmo7us8d6jxqp
X-Rspam-User: 
X-HE-Tag: 1778949084-439115
X-HE-Meta: U2FsdGVkX19AZuVBeXga6YziJaFP50OivkoBrLe/rmoaWVChlObG33zUEN1SKZB8IfhcwwNZcQJ8thFJyk7pUZHkaXf+2hTeuntyaXkZ3+WZSCZ+0jfjYhIC+JLx/OgMmFgUQvbdVAwBZjMLgNFzFK+OgtXx2QNRUV5XIZeGhK4AYrVGu9Fj+9wA6CCCD0au0D7455hLb7RCtlLse3XPNbME6bdzYpWXC25vSma/nWsuR8M0kGYyvcXoBLDvWlUnA3UGRwPsDtJom8vOX0ICJTNWOOjicX4yRkChSdLEmkqa9cio4M2CE/nkra/vRuiwIg4hyBUprxJrrU1JV0JGvYKDuohsxd3LKE7f07QNeK61vCTwDq6frQ4++eJJ3pZjbyzUNuPcd79VPC/XhcaDUe1CV3ltCh4pA5ZQXcBitx/EufnAwvAIpt+qllA1l8IxbINDy2+MrJZJhdLAQRdN7qN7hmsqm3BC9zS0JTrWaBAZXhPQfLQb5yhjdsKJFHNuuTpgKDvkj1nHwkU5wOcua9ks704XrgGqYaBA9SG5yJ6ZGtVfi7yX/IcH9yc+dLJ7ptzFlg0yEC9np6mnQ1yAC5iFcWaPkrOCr7WNTRENTiduaA1D0MGaEs7d1I7yCtZYNavrFdUBXVrIWN57o30MoRhZYg7OQRIkWRqp/FcmZy6gF7itL467TF46rxsGkhqOaW/6OxBRYFcbEgRkCt3eHyA1jNTqF1H6y+Yt4hva46iUIvcfNHQbv0/ioLWCzaOPDZ6d6AeTTuYNOhesFIkhmwc2cyPeSwrxZrVFSOO3Vcv94VBHhc6WntyAL4KJlqRHtjLw5A1XmXKk6wILHU2ibMWZGBT8QLUihuPVMKk7wO4rFKYHK5E0YtLYhQTIZGdIIX/RXtXCJXNZe0KRBk0sHM9KxWCvFrXcp2/sokFF4D9RiRlaKCOTzUrjdE7foWfhwFJjFW9bR6HqElquylh
 l6HMsEuR
 gFsWbCzmmeYQQPhyIDQuA1rJcjQ70P3Nkgs8B61iUuasiSXh1I9+pVMqai+9zOWAXyqI8IH+oqScTdVlQqe6JxM/quKlo8XuRkhg0tZTO4vrv2Q+isChrE2gj+QH1isH/mdv1/8R6BrE6jRQCbxAGbvUkggtplT9HPhw8dc46QrNxc5MUgVD6/YFZiPIuhYIqlKFCS0Ef7LhY0E5iMWb2OxN3gFow5Uz39aQj1I8XrQugsHi2+8x3pSwRIq1UtFq8SjTShy8juptOFJgD7KIQSdH9q8ax1vzbLkk2v+AuICKRPb2uVdTlAz7xbAqbtZ/i/64crXE4eShUwjqNsGxYMb8Y38hZQ8pbUvIEnJQaK4Nw3ocP9kGVLkaBSphy55TJczP507y+14flByU877md4+wb/pmGeN+npKQksrSQFfNtOmG6bYd37WNDlWptmN3vDKrHvvKBPcmQrHL+nPYtK7T7++PULVFIRaT9DCefiptb2u0bhl5+5lR01diw6q9dwmpGLDokflyoIKOUw9QHNke/Rr+hvy5S4X/giRT+G6ECcXEdUADj3uFLScliz9QkTbjPOWGitvMnCC4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 15 May 2026 at 22:47, Minchan Kim <minchan@kernel.org> wrote:
>
> Regarding proc_mem_open(), it actually operates very close to what you suggested.
> It acquires a reference to the mm_struct itself via mmgrab() but immediately
> unpins the address space memory via mmput(). Thus, no long-term mm_users
> reference is held across the open file descriptor.

Ahh, and we've actually done that since 2012. How time flies..

> The latency issue occurs during seqfile iteration (m_start/m_stop) in
> smaps/maps, or during get_cmdline() and ptrace_access_vm(), where the reader
> temporarily acquires mm_users via mmget_not_zero() or get_task_mm().

Ok, so it's that much smaller region.

How about a completely different approach then - make exit_mmap() just
take the mmap_write_lock() properly, and allow walking the vma's
without ever grabbing mm_users at all?

IOW, just a mm_count ref would be sufficient to hold the mm_struct
around, and then the read-lock protects against exit_mm() actually
tearing the list down when the last "real" user goes away.

[ exit_mm() is currently a bit odd - it does take the mmap_write lock,
but it *starts* with the read-lock.

   I'm not sure why it does that - it used to do the write lock over
the whole sequence, but that was changed in commit bf3980c85212 ("mm:
drop oom code from exit_mmap").

  Sure, read-lock allows more concurrency, but that would seem to be a
complete non-issue for exit_mmap(), and switching locking seems to
just complicate things.

  But that's a separate issue that I just happened to notice while
looking at this ]

I may be missing something else again.

Also, I do really hate the smap code. People have optimized it because
it's so piggy, but that code is still just silly. The "rollup" case in
particular knows how bad it is, and does that whole "unlock and relock
under contention" because it knows it's a horrible latency pig.

Oh well. But it really feels like we *could* do this all without mm_users. No?

                  Linus

