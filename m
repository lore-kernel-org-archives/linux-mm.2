Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9E26C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 15:22:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3E756B0105; Tue,  4 Aug 2026 11:21:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D15B26B0106; Tue,  4 Aug 2026 11:21:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE08F6B0109; Tue,  4 Aug 2026 11:21:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E92E6B0105
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:21:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1EE6F1A01FC
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:21:59 +0000 (UTC)
X-FDA: 85063952358.11.911E367
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf16.hostedemail.com (Postfix) with ESMTP id D339A180019
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:21:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=G4iENgtj;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.41 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785856917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=olHXb2geGlzeL9y04Jg6NOhgFWnbCV9DjEXTlnJrZf8=;
	b=OdhzkfI8ruPryNz3GKpE84fROXwksrTNHudES9X1B8t0k6vZSdHbQ4RZ5nmlxIHCR5V/N2
	ghONr3ZeY3LfMm8OcBmxv5uBqSQuFpOjusAqbCYEtcI36F7SYhABszwO2wsgKAO7sZhhvo
	aroJCx3DDQ7jbbMkdkc5ob/TwAUK+A8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=G4iENgtj;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.41 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785856917;
	b=GQx56hjfk4O2XB9E2TVMP4Wzw13KdaqJUnGLtyMFWoIVcOYoQWDlKbNAkukmyGfG4FCDYa
	PXAYuRXzdbzWs+BiIzEBZCjYsF94acxmdytxbW/4545HnyAcopLfjh93IVXxDjF7uyqI6q
	C3qwY0Y8ZG0QzGoEEJPT0lXrNsYdvaY=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-69c5fda04a8so8189122a12.1
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 08:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1785856915; x=1786461715; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=olHXb2geGlzeL9y04Jg6NOhgFWnbCV9DjEXTlnJrZf8=;
        b=G4iENgtj4HvlN8CRydpIIJSx5X7phfbKddMYXPVNunJ7fPw05Gs6cOLGdshBIb6Ikh
         sIsv7i2lN1Yu5VRIZOcjY36jxJupP/a5hYNI2W2xFNqr78FZtjfvPDbwYQ5n1ZSXbCbQ
         UkdMpxObOYFe537ON7TzFhnNc3nOTdIYyfbCI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785856915; x=1786461715;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=olHXb2geGlzeL9y04Jg6NOhgFWnbCV9DjEXTlnJrZf8=;
        b=FM/aouvLI4ekeHGil4kml1756clYX6giIHPjsythW+tEnIBLL8ujTYMHm0fYjzkpcB
         XTaAEHs8kebinoy8C6FCo1qEQxsJHG1uD9zXLQehpeIbrhsEJA24P14SwnCTxyfc2LFU
         wm7QiflATYrI0Hy4XYlxryNIXX0UNuabXOpGyK6ytUr/ujxrf0Qc67P4n+MlayLzWjLd
         0XIQe2TiIxVc20N5+WiFEC9pRLa8XnUlFwGKgQagesJQeoufjcsNtvH4LjpSLAkU17I3
         T/qYvP39IESnh4ZRHgvkDlOxbY5pjhgQC1YtLQTPvJQP/7KNqcsPV4M15y/Gos9LfXBa
         tgjQ==
X-Forwarded-Encrypted: i=1; AHgh+RpmJg+rqmoS442KPVOGLN69wFSCzxNT498Uhvnu/pFzB+77DKk3W63Vhw3Q98mL0LyF/cnj01LrNA==@kvack.org
X-Gm-Message-State: AOJu0Yxwm3saWV0qsgJHVBC034EwfumsvVEDw8RTvxLi4mz3SqWY8Mm+
	zwMMwFrcoanbXk447ytPlE1p7BdDi8zv6xQrJ/bwBZQsW/oasXwWWzEqPehqs5JIryUOGuk7H7w
	Upe0nmmk=
X-Gm-Gg: AR+sD13ImQSHGhRLpuOle4dKmt9+xS9+WUcqoeohE5Y8TCMv1B/JyEkM/x+LKH31Obk
	VknT2zkSf68KwXCVQUCwk2KL/fFtBq9F6HFwmrI4FsO0+EU0vBv/0wUG6kfrszwaJ4K38H99PiP
	ZJcFK71yPtmRXhiCYhPU5tqyy5ssyRtkw2G3H0ZK0y6Fuko65qcS+fqB/yNXyrqYFajGlvV0FPO
	kuNjyua5MRtjfPKqAYjl3tW1/F2tBbMXr74etdrncehgX+lRnj9sIemPZ6iUHojg1PotJRORJvx
	SkAAy7rsyEtqLERbpXl86Ko5jVgFkFuLHfkN6WAaXryD4dQ6wCFMlncS18jf/p3RRqEtQsJJ8NP
	VKBpH1+MnEXfqgpmCBfrxH6nysN9SwJzBmp30kxLn7cjittzHHXn9tEXfdDDBd3tTRbnCB6aC8d
	/8o3Z9YY2pGuVFaO3AuGQjfp4pAjt/pD76TY04F1a3/mf/9E/qlBXludhGqJPx42Egl/LyfgDRp
	CP7a03sQO0jUanOeTl81ymuoE9uEEj/LHbISkg96WQpledt
X-Received: by 2002:a05:6402:1f0e:b0:6a1:23f3:26b7 with SMTP id 4fb4d7f45d1cf-6a123f32de1mr5004469a12.14.1785856914610;
        Tue, 04 Aug 2026 08:21:54 -0700 (PDT)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a145c61883sm262189a12.13.2026.08.04.08.21.54
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 08:21:54 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c15ba3a2b4bso2287166b.1
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 08:21:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpjXv1IZ5NStEKMDHUCq5WJgAr6oCFwdyDiOL66v4Xy1RY0lf14u4Zk1sSVuiMkYa3Df1w7wTL92g==@kvack.org
X-Received: by 2002:a17:906:b17:b0:beb:133d:cf02 with SMTP id
 a640c23a62f3a-c1fe7f4820emr985414366b.26.1785856914199; Tue, 04 Aug 2026
 08:21:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
 <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com> <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com>
 <amCPBrdltFSE_fEf@J2N7QTR9R3> <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
 <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org> <anHuLy52o5S9Nlwp@lucifer>
In-Reply-To: <anHuLy52o5S9Nlwp@lucifer>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 4 Aug 2026 08:21:37 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgJ0wO=T+1G5zJwoeE-N4bAptCNo2TFirK364iPhnGG6A@mail.gmail.com>
X-Gm-Features: AUfX_mwOSZaa8-SU_wYYQrsqsCtSQEpSAzadouc4bRT6EdTnltAB_HFZw_konW0
Message-ID: <CAHk-=wgJ0wO=T+1G5zJwoeE-N4bAptCNo2TFirK364iPhnGG6A@mail.gmail.com>
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, "Christoph Lameter (Ampere)" <cl@gentwo.org>, Mark Rutland <mark.rutland@arm.com>, 
	Yang Shi <yang@os.amperecomputing.com>, Ryan Roberts <ryan.roberts@arm.com>, dennis@kernel.org, 
	tj@kernel.org, urezki@gmail.com, catalin.marinas@arm.com, will@kernel.org, 
	akpm@linux-foundation.org, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Jason Gunthorpe <jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D339A180019
X-Stat-Signature: pfj17pz9mkhsg467aawni9aar81mwckw
X-Rspam-User: 
X-HE-Tag: 1785856916-471856
X-HE-Meta: U2FsdGVkX1/ZjKzOTAhZKlTXXYKNsrp3+J6Q9Rj7I+x5hw1CnGgoqDQroiW2wIFXVenEPehCiNlF01YfVRwJw1tuYy6QgZIdXo31OAAYA8tE2ETDTPE6gPvqY6iz/e7C322u16Yl58lfpGkKzXAx1kkcZsK9JRED/JhGid8cVPKWqKd7tH7LQT8FkfZdY3+8kRiVeTzu/01lRG2XkWQrBDZFzmdZ1tIlFaTNdQvVz1lRANE9pdL1VyAq0OKJE5pwOXBuHtLcIZNtw1f0zRheu9vVO3peLQYrd3AyzE6GYyjVvtvqNKxilz6H2ti3gHBJm5MHjJ780m1Wy9r1hUD/wEYBSObdB+yIn13xfQU1sWHN72bPTCIzKDGDlx75gvqTJAP6UcNc9SrRlZslvG+aJC1zyU4XKdSLH1pEYy1WvwWFP7CssMnHguOeJRVf1o8vfbcuKVwTdrLJDWsnMqeE8LEQoHNAAAyX1dr4AvjczH+++ilkyZEuKg1AY0LRAuSKF13CEDQcIcArH54SJ+IP5qDne/9fsceU8+yH5xIzoY2FIZaRzgnyMCu0ypBlyd4B4aFtRUbAQKnhanHT4INdKIGn/viFqpvbxICICNs0+Tfi7swo0AQO8Zv71YPyC5Fn6O1I+lRSwR8ghNFOEdDM+hgvp/tWODctlUoCazF3tPEgjP54KSuuCVyMYvxW2n9U14porLXlAw8Dbt1cbVbrOVpbJnobnZREOZguZwo8jYdG9yieHR7yz4cSblsJmnSew/7BzTp+pa/aLJxtFPSbg64Yn98F/PjZIsSAtEHB1udVkFLD35AHcvkAGRJpMeUTY7GJhRUetUWNeGjWsjEtvmEoXDjBat1xKX7k7+Su8AFKO5y6Fo4aqi9WIq2QmFG7gTjpAg/6p76iloV30nSHaaaZ0Z6c8gbr6CLQS9eiYIzvf/zzEBdPewmEdVRLEDcJkyRcB2x20Bfv2aH4cwi
 DCOLXlsD
 DWchWA8sDU/RmcSoqWQz0PJwemSDzj3d4ogLu3oFx6Wj8IRLZe7l962ml3Rl/TmBw5w2i6xeY3rKKSqfAn5X96L+dhuwpsnYQi88fCtoKOfYEawSh52nKV2c/6TeozmwQHuxX4eXGoOIZFRx16iaalYF9tkeGH148rEX/kDGA+sjWm0wuLiWO1LuHH6VsI1OUVzQBocRQTj/w6hzTs9jtPakp2euA3ZQhtPAFXTgy09IXe7aSZs50Y42Uf1DeeWrjTWpR7Farz8v1wJmkLGJsX1A6umZbWt2voDC99U8QM5GG7BstCvUSI6E0RbiYQ/8oADWHg2gO8c6HqGptKwMtbyeGysWsHyibB/iBqCClZ4QoHWNrQz2JF3eEemP8vFMEt8WbqzCLkZ5jmJWUUvDk2ESgttt4qajQq8qS/HLJqm1KAmP9z/+qDitSlpYKBd4iRrMR6WnKVHpO8YANP2eNSL8Pt9RkvrMcM37X1a1nvcpEAA9QubuD+mFpsax1pYfm1cAK6GZ0JPW4QGS5euMG6BXucK30sWbDFPWH/Vz9Kirh5M+RCr1wp8j+Jl70OkXWh79+YAC9QL35rXY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 4 Aug 2026 at 07:15, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
>
> Linus - I assume you still find per-cpu page tables totally unacceptable? (had a
> look around to see your take on this recently and found [0] which seems to
> confirm it :)

Yes, I still think that per-cpu page tables as some kind of
architectural design is a horrible idea, because it paints us into a
corner where you have intentional duplication and then end up having
to have coherency issues where you need to lock for updates just to
keep things in sync - and may need to do extra work on hardware that
may otherwise already have hardware coherency support.

I honestly think that people who think that cache coherency in
software is a great idea in general are misguided and should not work
on kernels, but should go back to eating crayons and decide if purple
tastes better than yellow.

That said - per-cpu page tables as some kind of internal architecture
choice that limits the damage to some simpler case is not necessarily
wrong. We've obviously done things like that for page table isolation
etc. It can be horribly expensive, but sometimes that is the price you
are willing to pay - and sometimes you can avoid the expense entirely
by knowing how the particular hardware works.

Very specific example: on 32-bit x86 with PAE, the top-level page
table directory is fundamentally per-cpu in nature. It's just four
entries that get loaded into the CPU on page table load, but it means
that you can do things like having one quarter of the page tables be
per-cpu, and the rest be shared. Several other architectures have
similar "regions". So it can be an architectural choice to have some
kind of per-cpu TLB. But I absolutely do *not* want to see a model
where the general MM layer dictates that design.

And there are historical reasons to really hate it. Plan-9 had a
completely broken threading model that depended on per-thread page
tables. It was literal garbage. It was broken beyond words exactly due
to coherency issues, and I still do not understand how otherwise very
smart people ever came up with such a stupid idea.

We are not making _that_ mistake. We have made enough other ones to
not neet to shoot ourselves in the head that badly.

               Linus

