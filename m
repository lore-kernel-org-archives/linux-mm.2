Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB119D374A6
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 21:49:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47DFE6B02FF; Fri,  5 Dec 2025 16:49:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42E906B0301; Fri,  5 Dec 2025 16:49:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31EAD6B0302; Fri,  5 Dec 2025 16:49:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 191446B02FF
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 16:49:46 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9644712ADC
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 21:49:45 +0000 (UTC)
X-FDA: 84186759930.14.42B5D3A
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf13.hostedemail.com (Postfix) with ESMTP id A0F9D20006
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 21:49:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JvQ11Cau;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764971383; a=rsa-sha256;
	cv=none;
	b=BseC2bdczgdgn6jEIsTjHwJhSPpVyt4itMGoTKGkiDGCRbRvgP3fs3h01RJkeZ3wf4g/9D
	za9VH+AQjsPG2qNVYSdeKbiLr6JatDhzgI0EFDbwqTjYp3PkVvDsiz4fFouhvRrqu2MimN
	WYOUdBvDkMCzJ9GgZEs+pBFmDZAK9L4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JvQ11Cau;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764971383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jg2IlBOaipbx+REzjwQxo7FYRDY4dPE4UvMiKLmPXw4=;
	b=bno1Z18KpcPfo4VpC3D0vSjd29TaNXJx/c0zzO/fHdZamBfXDmQ/qJIpwW+FzYdmRGx26c
	jL6+pw0M/PxsMcwMjayJkELzw/1z+W03yiraCU3kHKNklH5mS0+uKOoaLZPQeIGBb6oyNg
	Sp1GhVTT3Uy1cbNpmRY55m5XMpH//xM=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-42b3c965cc4so1247164f8f.0
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 13:49:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764971382; x=1765576182; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jg2IlBOaipbx+REzjwQxo7FYRDY4dPE4UvMiKLmPXw4=;
        b=JvQ11CauPToZJ9c9ptAj9XpZ5tTfrE/2UUSr43/vTnlgSM1wklpDASibhBKELov2AA
         C5uLJozskYitGiOuZDrA7nkUaRY1RvmyYUKeX8Mmhb6i4vXlza9t4yufW5/EpEZ/jjTu
         tIBiTVjCKNqAZXq76xfhBX2yCX+TaMmR1+SKbkn3qemDHr+yC1bulLMSwrpS66lO7FUE
         VFazuNQp1MLgtkPfBWj+fZb/tRxjr6umrs9W0F2Avjh9kvKtnuPSlGPbtUkcCZwQQyVh
         s8yTbkvlaxrGzY9UXO14mAvPaLzdC7gMeOLkWThFzUQPxB/6j8SzqUo9g+G37gXF3nrn
         0JCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764971382; x=1765576182;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Jg2IlBOaipbx+REzjwQxo7FYRDY4dPE4UvMiKLmPXw4=;
        b=n1rxrDgW58L+/9fvKmUp75fNLSAgbsfM9eSQQOtcNvoBqDbMyRguxYPfrwDrcEpMK6
         1IawKIOUmw/IN1YTXw3oxIzIqz+5tZ2UDAP4864W00VJK8yb9iF+hmvyJ17nQ6qXzwSY
         kwxAEF6CU+B77JsymnUUK3AjmDgMaOH9EtrCu0zokG2uG/KQKBRKrrvpsOaCTuLCHm/B
         Jb8IWUpbM+iCiSCE+jsIKE7v+ISNyvFNiENjk05pO/2xQBqh2t5U8pWZM0P9pVJQO683
         ED3I+a/CJ9FOtd7JGembFPpGOVsYcGymzTn+cMaIRnVAfKnMY6VXibJtkcH7AZjW9V0H
         ICQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWmRPc0PhBTkLmUMZH1uPWnKQIyAgzZ5Sou/qeaapgnMJwKJWP7V+QQFD1AWjd+K3W/uk7YOF6CQ==@kvack.org
X-Gm-Message-State: AOJu0Yxm0H3WDFRnHA/A/m4IjDcwPeWX6E6NwAtMwNQHpc7/xA5K/lsl
	hGlv0c1rYgJd5ehvdiBs9o0G25ZPJafVo7Pu+OpKzlDmX4U+JLbsAY9d
X-Gm-Gg: ASbGncu5wV6e8QUbZmN6J2ekpuE45oP3EyTFZ16qrK9Tky15zW1K5DEkPJMWtPugM77
	QZTcYgoI0c4lDgW6wyRvHFuBtBVNgYzNbp1Rf9vpH2vHfb8VIX75uJOq41u9NZxVsVbr4ipCsnu
	CGZyGc8rO/1bXRRd7Gww+ZQnirOBHsN7EFrYCJ6Bzt84ZtAOStb6q91jvtfRdfbWpEiK1gewgel
	QMrvv1KZG8gyJrD/YFHTKwPAY7gP6rDzMHZJ8AAV31ReiXLuD8dMsAX7gLpP1wX1b5XgyyFiClO
	J9x/SO+/n6cTYmRvHCG2ZwfMtK18RSdELinXBbA0X/gHN17S0HK6oRr4BrXsPpDlL8fsFFVfRka
	JmNZXTw0x6d+zeK2L5l7qSuNMyCp0ifXPwlSEJMhl7U/eid5tn+89qJxueFTAoqRwX41wjuWkE3
	zTlkQwwB1FpCL4G/lBWlQSvAO+W4OV1vX7aFVvjHxCpbpE1bO6q3qy
X-Google-Smtp-Source: AGHT+IEXCZuoM84HhNS1eLJlWXekMpaS1VlrpCR/D7Zc3iaqO3aJpq46P8vsFICE49WYqTzV9M9fsg==
X-Received: by 2002:a05:6000:4308:b0:42b:3ed2:c086 with SMTP id ffacd0b85a97d-42f89eafab4mr836299f8f.4.1764971381797;
        Fri, 05 Dec 2025 13:49:41 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cc090bdsm11152502f8f.19.2025.12.05.13.49.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 13:49:41 -0800 (PST)
Date: Fri, 5 Dec 2025 21:49:40 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
 <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil
 Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, oliver.sang@intel.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: avoid use of BIT() macro for initialising VMA flags
Message-ID: <20251205214940.211a2de2@pumpkin>
In-Reply-To: <4eea9138-3853-457d-9113-e3caa7f00437@lucifer.local>
References: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
	<20251205184342.2cfcc73e@pumpkin>
	<4eea9138-3853-457d-9113-e3caa7f00437@lucifer.local>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A0F9D20006
X-Rspamd-Server: rspam10
X-Stat-Signature: erw76qgowokegufgqf4y759ucszwkgja
X-HE-Tag: 1764971383-704673
X-HE-Meta: U2FsdGVkX19ABGn/lF74Xwfxr2rRaLxwEWqb4JOdTxDIw8SZjS6FOOUmoMeIhEbBVSRjpy7W/zG1CByBlUqT9hiKTxnzqqHSVK3mwJQOuekPfI8rWxsYnYjztTOSp7VL2ZwdmtoaRnxB4m08blKo0sIkJuYpf5cjcz+OHpHwrRzWZoRgVQnkTjl70chuSumtk14x3LTyzyBq/vWMuRTSIDBvrci5vbxkT3QfGxrH4KmrTYMtz6R3Wbcf/6FS3effU9H2xWra4kW+ge5U5H8F6A16EWN+8DyoWpUcf83dNlMJB1Od3VaviI9J5/iQWIvNS5nfxrmxGdA4Zor5GOnomQeyk1fy3mlkqZN+DVer0ZRgFwvQjdkNLfGarQL5o1AvUoENZp1paxLbHDdl2jWlC5GWBeYh5SCog4Ju3FWc3Yk0HQEWLBPTkbC/msUbA1q22uQjCQrQAzDLItJryA2gVj7Igi5VWDOpfU9R+IX98tdoigSIsqXoqpM28yqpSpjurcBeN2XWbORbrUoaGNWNAhnVQGzOxoq2Dd0Ja0t3gD3bmqbwC04AqetNayGx9UZrjDnJi+A3JYbJVC5pk7ZPSOEIg/gPxq81kfSKUIhnP3+t8iXpcF8UA6XZNyuf5BJoYGkV/Vj0z4enATQKwg7WiMOO+sPsM4GhwtvbNYwC7XzJvtMPb/OGA4795kSpDqxqJXMLLeMLVtO/rabwfx12GBfyqy0mEsCPpzlIjwhI4sRhAP7cLYwhitOdD6t0C9icqD22kAbUxXz/7zfE9MGN1XV4txIEUw7lVKo7r45ZLtYl+Gq2I323xTIMVPvHo0gTGV0CkonzhSAKx7709kTzOcYB8GY+3l/DAEjQlIj7y4yEJpi0l4zbVA2iE4ybjccsV7VYbnSLznOSJXFRMhJNmY/pNFuxQdL+8taFFipSd50IpUxYG2HivOmJl9Z3t3obJLPpGbqpqlFWURhtt0D
 EJ9ytGCp
 Sb5i9xJFtVGB5HKCk83jPBY7+I2eLQPN5qxEU0Ufun/cGGVOPa03qDyx2RndCh9jo7ucf/QpG/VjKCqUvJk6GJF05vpvmYw1ZnWfBLr3Izwwzux8Q2i6J4slnC8e6JeORX8gEal5vetbM3twQOuuMG0KVd4uVCXAYdbSdNEGJuFu95cjMPwcHjHsfmTliYHyojTOl42vvEdd01bjEfq1wh7R06QL3U6p1MRwD2uoYWR5Xay9NNjVoPiaoL5M76MVEHYrdqX80Y/nKslNwqsq2rEAE9d5AcwYyxsnPjpgPBYImlkT2OMqS+7lRqpVKkvOpMw+8vr3Ke0i5P1JYISNG2jULUL+t9RRe8mohFsrFN55jQS9Bhq2S10S8ZHxuE9nXDNuOCOQJhjzfVPD26XXvTd08bJZR2Js3fBXdoP5Jiz2LE+dQiAG86Mlz2Po+lkIsTLs0pXqSLF8gqtU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 5 Dec 2025 19:18:56 +0000
Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> On Fri, Dec 05, 2025 at 06:43:42PM +0000, David Laight wrote:
> > On Fri,  5 Dec 2025 17:50:37 +0000
> > Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
> >  
> > > Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") significantly changed
> > > how VMA flags are declared, utilising an enum of VMA bit values and
> > > ifdef-fery VM_xxx flag declarations via macro.
> > >
> > > As part of this change, it uses INIT_VM_FLAG() to define VM_xxx flags from
> > > the newly introduced VMA bit numbers.
> > >
> > > However, use of this macro results in apparently unfortunate macro
> > > expansion and resulted in a performance degradation.This appears to be due
> > > to the (__force int), which is required for the sparse typechecking to
> > > work.  
> >
> > Does sparse complain if you just add 0? As in:
> > #define INIT_VM_FLAG(name) BIT(VMA_ ## name ## _BIT + 0u)
> >
> > That should change the type without affecting what BIT() expands to.  
> 
> Thanks, checked that and unfortunately that doesn't satisfy sparse :)

Oh - it is that __bitwise that causes grief.

> I don't think it's too crazy to use 1UL << here, just very frustrating (TM)
> that this is an issue.

Did you try getting DECLARE_VMA_BIT to define both the bit number and the
bit flag and put them both into the anonymous enum?
Or are there other reasons for not doing that?

> 
> <insert rant about C macros here>

Add rant about the compiler thinking anon enums are doing anything other
than defining constants.

	David

> 
> Cheers, Lorenzo


