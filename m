Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EE7CD30CE5
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 22:01:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 846B56B0089; Tue, 13 Jan 2026 17:01:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 811D06B008A; Tue, 13 Jan 2026 17:01:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FD016B008C; Tue, 13 Jan 2026 17:01:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5FE676B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 17:01:25 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 210291602AF
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 22:01:25 +0000 (UTC)
X-FDA: 84328312530.01.3C1816B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id B2E86C0011
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 22:01:22 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HysQdAdU;
	spf=pass (imf22.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768341683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LFZYRedxA/dOfRqaPpVPaG9kpYZqtR6uMO2q1QSkh70=;
	b=Q3lafy+W9gsOzc0vDulHC4ENnflnbVohdwAFO+p4mDYdtUAVQzaiCbcX+vKjWxEKPlRqQB
	Q/d7Bw9VwF+D0fDDccU5FtVSMfeum1yYt7BMJGJZjBdAYNFNTbrlwXZArfPDqa03YfCSG1
	cwSb3KQCzia31dyKfz4xYI8xKabmns8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HysQdAdU;
	spf=pass (imf22.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768341683; a=rsa-sha256;
	cv=none;
	b=6c4tInLVa+JEO25IVX9UqMvW0Qd2wYpX4MPqmqg27iUo9Mb3/ulC5O5oFDnb878DJ1itAG
	bJHcZtygRsNXRBqLqLH8fqEWBsrZG6P364XwESZmO0oZUqB0BZqi2GWdpIgpeJ7WfhfztH
	W6B0d63KYBEvrpjJaR4xUbeR7RJdqm8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768341682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LFZYRedxA/dOfRqaPpVPaG9kpYZqtR6uMO2q1QSkh70=;
	b=HysQdAdU/MypRGYDJ0RnhOhmTdaow697I4vPs8Qf0l/DuLBu8envB02Hz/Ig5bBEpMBK5O
	oaUxTgOIuyVLvX3RaOB0s39TPnmqLwlLSi9NbjhV38+MVsScWtxto3FfGgQ44Y5rKaaTs5
	uRI6UG/DihQ9kxWJxrQd+hsw3/UxMDM=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-KWRAqf2jMnK5cf_if3w3-w-1; Tue, 13 Jan 2026 17:01:20 -0500
X-MC-Unique: KWRAqf2jMnK5cf_if3w3-w-1
X-Mimecast-MFC-AGG-ID: KWRAqf2jMnK5cf_if3w3-w_1768341680
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-647119b06a3so11142845d50.2
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:01:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768341680; x=1768946480;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LFZYRedxA/dOfRqaPpVPaG9kpYZqtR6uMO2q1QSkh70=;
        b=PHcgvO79hnBiIkVe6/RBOqvy9F032t3tkcnsMb3Y2Shx/QIABzAKj8c5M1t8wkLYP9
         r0xZfz/oQrGX7oBqJB00t1OAlLW3U7LjxfYaateQNrMOaI8KMdp1Y+fcMokVVeHm0+fU
         TIC2r49MhErwIctIXgt3CpSCjBm9/CxsOdPYwuf1maOnoJ6JDeDhBR/vOHi9Oomf3KYj
         WIdCqtq0IPfi5YK4aEACXuUZgysaLRURfDjftYjGgN10ebEop0KgEJjJEeV2DLkNrQEI
         MciddC8kc+nLst8uRaz+NXb2XTl/uy3Kqe/PxU1J9BhLJm9gJKUmW/0BfjXsNEn9p1xN
         +DSw==
X-Forwarded-Encrypted: i=1; AJvYcCX7v3XtvNEvlIS+pu4wQ35BYyTlIGBSlRDWPuhvQQeZ2Y3ny5jQ1h8FSf/zra30vtdO1T0WbQBiOQ==@kvack.org
X-Gm-Message-State: AOJu0YyWGCB/bbd+iVBQ7kAoLZ/3dl5apgP1ixFwpUcVgHFfR+1FLS9Y
	O/PMHYproIhG+2y5wd6FlFXknyK9cuG4NX3sRjQHWdP4QoPk6z900Upzd8UiCITwpyEkPI0ob16
	EjHXRemzVGmDkHl8NCBo+uLqpHi/E+VbyXm7HBFuLLDPiewRHa6DO2IqRRddLrQALOn6y0B5ske
	FWf99ioEKI5JgZcvifB8x+bYuuTZU=
X-Gm-Gg: AY/fxX4O0hhW0de7byWbIxhqOnMiD9iNXiNJCTOLl6Uz1f+D3+hhmLoJIZDXQFAFSIN
	hvm1a+dwnr0isY5q6ywlaOt1AtuJ3w9nNXtSfvQOCGdxtUU9YcDTeK5G5DPIqANj3YdRxO8M5s/
	G6SrVtBJ1Vd7rez+hM8qH80qoSq+I3qJ4Jr0RZSrya5jkTR+KEfryphfniUi0zO9h/ME0TbeqPM
	JbaFAVR
X-Received: by 2002:a53:e21b:0:b0:63f:55de:63cc with SMTP id 956f58d0204a3-64903b0533dmr47279d50.31.1768341679500;
        Tue, 13 Jan 2026 14:01:19 -0800 (PST)
X-Received: by 2002:a53:e21b:0:b0:63f:55de:63cc with SMTP id
 956f58d0204a3-64903b0533dmr47240d50.31.1768341679129; Tue, 13 Jan 2026
 14:01:19 -0800 (PST)
MIME-Version: 1.0
References: <20251201174627.23295-1-npache@redhat.com> <e54b6ade-e2a0-4a68-93c4-23af85479567@lucifer.local>
 <4cfb49a2-f0fc-4796-83a6-91db3a0f2a97@kernel.org>
In-Reply-To: <4cfb49a2-f0fc-4796-83a6-91db3a0f2a97@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Tue, 13 Jan 2026 15:00:52 -0700
X-Gm-Features: AZwV_QhqB272ApR0iCFfYvM28UwTr7qE89tJbFmOhDFMYK8UOvjuB2zu6RzyXUE
Message-ID: <CAA1CXcCP6yrYNAWjo2vsXC959Yi7GPq11uWB-eEv-Qvv+zmw7A@mail.gmail.com>
Subject: Re: [PATCH v13 mm-new 00/16] khugepaged: mTHP support
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org, baohua@kernel.org, 
	willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com, 
	usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, kas@kernel.org, 
	aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com, 
	catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org, 
	dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, jglisse@google.com, 
	surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com, 
	richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz, 
	rppt@kernel.org, jannh@google.com, pfalcato@suse.de
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0x-kAm7fdcdsJDiFnZFXNhoU36V3Yr1yT364xKVqkzY_1768341680
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: yfx4ghwqzaiw5tp97tgn5wxzqxkta9k9
X-Rspamd-Queue-Id: B2E86C0011
X-Rspamd-Server: rspam04
X-HE-Tag: 1768341682-273039
X-HE-Meta: U2FsdGVkX18WiUKfTO0IzOjPqF3Hj2f34KqlvVvmCSOEWlogoTvMKezvF2Kh7rRqQKMA1LYLw/A/FqHG9Rh2Ysopt9x6/zb0/eHsGajvpZgkBODVTl8zze64h/n5niZ5y8CQckJzwrRM+w0IVCoLfAIf5oUM8JeGcaCPU6pw++okUAPQKAZThMb3wnKPHitjxuF65DYLAtfxA9tzblYqhrWZzm7KSVKMH+3mt+avOQcL0xhV3qiF5P7/r22IlYwFpvZzumfkAHbkNwMS9kVU14xIieryF+mKOzDP2/3C56wPnHssPpvzscxv6oxS3UGU5YpOex+xaDDLsX9b8Wn0mw4Q0+qE9SyGbwZQzCAm84GoQH6Qy3/FHoZCm+9JmIXIGCKYdfy5TQ6JhZvaMqXNEgHz86zysfsLhz2AOIWudNs++lY4Hn9OziYARS0+64vFRZBRzDe69J7hVL6ssThL85xi4uHZsyoC+YYk0wgn6sE64tRaJsh5YkwLYTwMWEgu4QSWl9O+xQy4204YXrI0PNCGYSEd1V+faJoNJVmP2jlbT/+Y0YcgomJdJr36Q+YTzGP+u5802y+2MirPFgjld5xusEwYBUcy1Bw1QLg5daoN5AqHCm0RcRmIlQCgJnT59qMvXjlW4UjI4AET1yZS/2XRjmSl2LzZiIbC8VVaq31DlZ/UcNA4+5NdKG1hGw7KbhzBWywkkwPtaOQFZsu3UB4397q61HoUe5a2NixK4Pf7lh7J+YsRpPshgAfchDY1YcAVXUL63F3a+suDQieywrepsl1UQFqlve3jIme5F5BPMmnP36ExQ8u8MaH6t8FtXf1EPxCxgD9b6PIarN2KxFEKAME85mRqmvJDuqIRRNSfXumI5WdwzwOfzGRdGJ5wUFG5DU3APqAAuHAmLkcC0KugBZMKHJ5s6raO4D5EAJLlbNW/aTAJgixG6U11ptQ907kGy5vbCp6wwo/05NR
 nI1TUBkz
 /iRuj5Qo1fbXAEjCjLuz42SeqdtKA8MIjgLfcz1dCqmB93s4OB15Emp6P643WT0iLS+VY8L+iSVJYF8ygSFkKRsY473QSu3jyHhIlU4LY89RmJy7rzydv39s3dGUy8CB0YDWbRpq6oZXXoT+VCnZYdTTb9Q7DRVoVRPlI1DJF7klRfqumPLdp7sr71k/CirioSIhC1gULQ2GsW2oLQgKxrJ56HDhTUR8WuvxuZBomWeTBo2TGy8Pd6v4klYGBBleugYpxDC5rLKp3L1CGS/iy8gfi1UjKvWfr8rj0ta8IYamDrq5PV9EiCu/i6HCVfjRYVJrJPpNJnQGDr4cJCtcnC6YtRljfbCuAZodUIHp/2Q9NCI3BoOr293RhlsG1qRyoldVZqMEj4pbwG4U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 9, 2026 at 6:57=E2=80=AFAM David Hildenbrand (Red Hat)
<david@kernel.org> wrote:
>
> On 1/8/26 18:19, Lorenzo Stoakes wrote:
> > (Sorry for multiple mails replying to same, lei/lore are broken again s=
o my
> > setup isn't working properly).
> >
> > I tried to fixup the conflicts here to run tests locally but there's to=
o many
> > and I messed it up.
> >
> > Could you please resend this series rebased on mm-unstable please?
>
>
> And maybe send out the two cleanups that can be applied earlier separatel=
y?

Yeah I can do that. I'll just add a `dependent line` when I post the v14.

>
> --
> Cheers
>
> David
>


