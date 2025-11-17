Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E8DCCEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 18:26:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE45F8E000F; Mon, 17 Nov 2025 13:26:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBB0D8E0002; Mon, 17 Nov 2025 13:26:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF8538E000F; Mon, 17 Nov 2025 13:26:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ADE5D8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 13:26:49 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7F6E9160238
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:26:49 +0000 (UTC)
X-FDA: 84120930138.05.0BCFDDE
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	by imf23.hostedemail.com (Postfix) with ESMTP id 848F4140011
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:26:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KHY8PnBG;
	spf=pass (imf23.hostedemail.com: domain of avagin@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=avagin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763404007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=alGbyc+yBrDtnDx+oU6ypOXsxlSRyXRgXCJucetSUPg=;
	b=fJYD7QYPRuG5RyevguGGrigCkp+dGxkwNLQSlolpuns4WwOXhHBh7TvAz+MqCQB3H0PPwB
	LdFetlUoYdGSUisogDxyShYfzT2JYKg97VpPhK3ZNQNji7dSqBMLaokTO4XDiiwXdpaKbM
	UjL3YnIH0LU350LNK/YMR1XEZaZRBKE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763404007; a=rsa-sha256;
	cv=none;
	b=Moox2YU0iK2XqbYFCEVAGI/WUOIjSCSMTf63HBVJE8daS/ebfROhA8UiZdWTPpAOpFe9qI
	qtRqkrZWCgX5xRvGsDuTasR1+hXSYSZrhK4BKUpxeWxuEJ0s0nvTvRrqhyxscoSMZTV950
	21/9wLzRGoMnMXK7dCPjl8bQ5x/5YoA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KHY8PnBG;
	spf=pass (imf23.hostedemail.com: domain of avagin@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=avagin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7c750b10e14so749040a34.2
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:26:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763404006; x=1764008806; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=alGbyc+yBrDtnDx+oU6ypOXsxlSRyXRgXCJucetSUPg=;
        b=KHY8PnBGcYEu6P6/XFUfAdDe6M/3cIgdIrIDTJbrtrMpkoHZNBhzji5Jw0jMlV+k9d
         WLn0gOc7a84a6uVtJ8XeTITHAkJhnZS7wTvao+vHRzithWiPM5wrROsu2xCG13OuDFnW
         TmgUDDDWA99xJ+NdqRrdJ/9a6AB1wtTotoRrNh/FaLG1JBKrrlUFgqTyo5wc0oopJC4W
         nGLKVyXvsgkDrPYEI8PFdT5K0ZQVmrrAStAEf3qWPQgYAdxKoAgDlFhTIlI1iNqGfeWi
         20c1jsLi4evcKzIfNYxBB6OJQwHXQCfoVwg2xF4faEHx8r23TydKp2tE1JeRw/jGIsxq
         qQng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763404006; x=1764008806;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=alGbyc+yBrDtnDx+oU6ypOXsxlSRyXRgXCJucetSUPg=;
        b=pwXEn6CvaASrLI6040gHMJE8cbk4pE9RfQOZ1vTpjZyDnnKJOpXqqb1NPFl/PW2chN
         /dOWekE8/+vNR4rID5NufV7rQoVAUjmSloTSlybuBBN3erI/FE9BdkAgr0i+GqwRqx8g
         VnpT1vLVNWr5eJUin76T1BQMYkifZ0I0TESc7PIUbE/8R+OJrRoX+215weXfVPlaKo8B
         pNMIMgndPv3kuRuaNBt8LmLCQiUH5e+KjXPoOjwHZGhNY5G7KG8COFUV2baOSdaZojmN
         wQagy932UC22xYqOQQ+mO0mU9HTz9tm6G8Lnl69GU45IQDqwpcp7IuPmx9Tdo2uvHS4j
         2DlA==
X-Forwarded-Encrypted: i=1; AJvYcCV5aKGVWadvA+AhiNAUJWGiayFgic0JgIwbwiu+NVRQSG1KETzHDyN9H0GZJXcoQ+c09x6GVIXVcQ==@kvack.org
X-Gm-Message-State: AOJu0YyXGJihNezNCFrqqXhSqMxSEvgvz/UStaLLrPjZ9yNrVB06Suit
	970SLGH+y+PWVZrnuXGQ6HbNXidnjUa6+aBJoMYZ2p8lwcURa3HfwdN/54j0Ek+Paskfz5cV9cK
	sbj92UuYgY90XtEM0c7xmKyr2+5JDKfk=
X-Gm-Gg: ASbGnctl8FB5N7FgmH4SPm0FM6VsdWfTH93sBCV8DfV+vPon0K1Y/vicrZJRr33SOrv
	279FEAVnl7vcZKUuvvVp/OR9tYg/i2sJPKlJEQlUWfTWyjCV9iUgoU+8/nTeyU8J0zNw6TcGpe0
	oRdtIokFRQT05aRZqJ3SZe1oLCVrTQlHp/gPEGeFDvNbRHTuLh9We87zxmPrAKAdD2ob7pBwdSe
	/rpM0prqdc3aAs52XZGCL1gTOrghQ6/0uALjqDb0MUe/FTta/t+l0K1jo/Bzw==
X-Google-Smtp-Source: AGHT+IFF61CUQlCQyuFHaJQCHfCMYrdPrh0r5dTlUOQtn7WQOt1YdjTPj9U5FmvA/UbUQBPmyGv7Ji5FWFKgePiGy0E=
X-Received: by 2002:a05:6870:e9a:b0:3c9:895a:d9ec with SMTP id
 586e51a60fabf-3e868f17bd8mr5239920fac.17.1763404006346; Mon, 17 Nov 2025
 10:26:46 -0800 (PST)
MIME-Version: 1.0
References: <cover.1763142412.git.lorenzo.stoakes@oracle.com>
 <CANaxB-yqsphFXvY0diEaHL+Bg4eJ+z_mqezxen9xVyoyL+4NMw@mail.gmail.com> <1c20ec44-0775-47e0-aabb-e1cf1f38ce94@lucifer.local>
In-Reply-To: <1c20ec44-0775-47e0-aabb-e1cf1f38ce94@lucifer.local>
From: Andrei Vagin <avagin@gmail.com>
Date: Mon, 17 Nov 2025 10:26:34 -0800
X-Gm-Features: AWmQ_bk15XTDnUj2arkWOdO7K-a4XlaHRTnUWQ9fD4al7Mgd8GhoD1S1ts7TM_A
Message-ID: <CANaxB-zPuxtbpt7wcjDE1X5nv4yWp=JTq_MqWSfDce2gx-WKiA@mail.gmail.com>
Subject: Re: [PATCH 0/2] make VM_SOFTDIRTY a sticky VMA flag
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, criu@lists.linux.dev, 
	Cyrill Gorcunov <gorcunov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 848F4140011
X-Stat-Signature: 6tct78ca5wikbt9ixtwpxbehbwj4hrkz
X-HE-Tag: 1763404007-196587
X-HE-Meta: U2FsdGVkX1//vfUiYudS+2GkU6g1REQFGh6R6xPvNZ2cu0IFbBJskmpxd8SczswGWvF2aOc1uHsR/ixJVSVI31WwN3A0xoE98EVHoD/5mO5s40Xkli1f+iGcAc+mmwsu4SmNKAheZnuBsnpCbqPLblJ/yOzFAHygwlv0OPA+mduPYX/zOiDbVsBMht39xK4nvwC9huwoBzGf5eaHAyyuojtcpqnSCfoXgrUhXSLQ0EVCEjkmJp/XriParCwlGxDYx7wYILKlkpjDB4quJ74Ylkghghch3OmhWe8NpAb2PMXJ/7ZK5GQ7JUjkMfs3h+T4PXhKq4kjE+E2nCryttXuLvZZTzsPiKYIVFx47YdPS77ptLglgD/h4eZGI/tisGm7kXnD/p3Ca1Qc6dQifw5H3169n/pdsZ1ejwjPlAgRa4rlR6PGWqqKVvKzb/nU0uBaqk8YKyfD8oQgP+aQy37etZqf8vj6V1YmZlGPVfISx+8q9QncpAz2G5McNqaHWGXMMsh9WHJ9g7EbWbxVFmtgLeNnFDqDFcRhXNLaGcKAz+8CHOiOovJFitEtl+ejgaW/WwmJBzFCMZzvHktlm/YW+XCFb2Y9a4AKWVOhFVwH4GnAs7e/lyaflyqoP7DhirV7SmusqgsPT+pY/2Ar+qGzD5ww6PU6UedsAMx9rVVCAlbjvdcqIu9KLajmC+JqgCIFS5xR69WBKXn1npebO9z0dIDOSXPYhdu8i9WZTqr8CHDMvsVDX8iWoMbGrW8DcYSeWHTs2JEQTdDNj74o0DGsJVHkppTWizLqXmT7fmqN9Xd0106a/QQm4uk1lqIDhZw3gBlqKJcL4dFwMX5YtLa5lrSu7fqaqlf+sj5Bip0LdaMT49LSeEgfIgxnsvrbfUB9ac9MQDljxhbvgPEHSAQQI6hnZiC68YmpcTPr4OGLsMmx1qUrTH01f2fkCwoPnpaP/9KwU+Lo1BNCwsfPBme
 1NGOTMgW
 NB8Q19zjGJHbE0IEEPPttTHjArw8hlybzfRK4M6gFatC3c0c1wcH3hZPcHmJ1P2O1gdXBeSsKGGG6xC2Kl9RT+yOIwxJY5NAKXOND7LETlXzCKStQymnSYIqLDpretx6A19JMt6ytwv8Vgi4iIa7BSHjfElRJTFVE3/bZfQc1Ibt8ewy3U8BVfebtSTEvwU1r62GTWUgjFWtKsuU7txrI95LPcSKPs8O1dZbG5h1UEbocqkHpyPiA1Wv5dljFFerZqVcKXPLUq+Vcwzjh2aGNV4O6x6G+5GriCz8CaR0kCvO6pNjl3a6geFpH0t38oJ1aoQ9OZy8GOQub28ls+L4TTGa2bJbHyCgpkolbE+SD9RWDQAm/8ctAjndCWg5/3YhWPP746K4AsSGCRE00Ql7ziDszKq0eteZF2Pax3LrYkRJOvGg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 3:33=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Sun, Nov 16, 2025 at 04:53:36PM -0800, Andrei Vagin wrote:
> > On Fri, Nov 14, 2025 at 9:59=E2=80=AFAM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > >
> > > Currently we set VM_SOFTDIRTY when a new mapping is set up (whether b=
y
> > > establishing a new VMA, or via merge) as implemented in __mmap_comple=
te()
> > > and do_brk_flags().
> > >
> > > However, when performing a merge of existing mappings such as when
> > > performing mprotect(), we may lose the VM_SOFTDIRTY flag.
> >
> > Losing VM_SOFTDIRTY is definitely a bug, thank you for fixing it.
> >
> > A separate concern is whether merging two VMAs should be permitted when
> > one has the VM_SOFTDIRTY flag set and another does not. I think the
> > merging operation should be disallowed.The  issue is that
>
>
> This patch doesn't change anything in terms of merging, it only _correctl=
y_
> marks VMAs as soft-dirty where certain, very specific, circumstances migh=
t
> result in a merged VMA being incorrectly indicated to not be soft-dirty
> when it in fact contains pages which are.

As I mentioned in the previous message, this patch is correct, and I
appreciate your effort to solve this issue. My comment was about whether
we should allow merging VMAs if one has VM_SOFTDIRTY and the other does
not. You are right, this is a separate question unrelated to this patch.

I recall correctly that initially, merging vma-s with different
VM_SORTDIRTY bit values was not allowed. It was a bit surprising that
this behavior was changed by Cyrill in 34228d473efe.  Cyrill was an
active CRIU contributor at the time, so we can't even blame anyone for
breaking CRIU :).

Thanks,
Andrei

