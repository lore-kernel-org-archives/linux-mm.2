Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2430CA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 09:09:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C8BC8E000B; Thu, 11 Sep 2025 05:09:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A0B18E0001; Thu, 11 Sep 2025 05:09:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1FA98E000B; Thu, 11 Sep 2025 05:09:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DC8008E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 05:09:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9D40D16030C
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:09:58 +0000 (UTC)
X-FDA: 83876397276.02.989D038
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf25.hostedemail.com (Postfix) with ESMTP id C24DBA0006
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:09:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="TNKl/PUc";
	spf=pass (imf25.hostedemail.com: domain of glider@google.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757581796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=110hIxZl/DIKAtkNXDUZdekwbiGKdHIJpSsuT6OGVlM=;
	b=Zb28UXOqMiTSudpCiCJfaS5F3HNVYUNJz0onSlnMOH9GD59gxn04lMeZ6N3KY9e6m9ulTZ
	Gxhl0UFs8pElvymYgGwOeyv+QtMg5rsIPBRCbb717PzgQPqolWDBCGzbHtwC8WwiLRYTzF
	OEh/1b4GBDtfCXILET6TJTr9S5f6g6Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="TNKl/PUc";
	spf=pass (imf25.hostedemail.com: domain of glider@google.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757581796; a=rsa-sha256;
	cv=none;
	b=LgsEnyja6y3WtCRdzRCzlqYThY58qVdmLPPIlUciELPRTW4ClBvIVbknzTZ7dmIRzb5T2T
	BpBM6g51rDlCgX3KZgsqPtyliHG8mQSYx5LUSaA/lxM0HXQ3Ad2M2sP6OjVq2cXEkNkKeY
	KmxYSgTx+t3qt03u8C9nMKmS3A8THfw=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-726dec342bbso4565206d6.1
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757581796; x=1758186596; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=110hIxZl/DIKAtkNXDUZdekwbiGKdHIJpSsuT6OGVlM=;
        b=TNKl/PUczl7lDbcdhyMkrkUXLlYz3nj/PNi9p60gmQ2szHSO7QuxrDgx2DVcwdOHLn
         fKW9OqNYHEqb9ZVry1qXeM/1po9NPmmsX76//MVuwuXuTSEsZKlysDqSc8mQpFLxirfG
         F+GqWu1L2vX5h5D3gDT27piPp6YRiKRCfDdFrvHIk1rDrmIb5pOVdesDaEpLoepJRuf8
         fgyD2lXmHK7+UXfdNnx3V2nyINgECIaqLL5V/3utclkE9h16S8zVOlwTyWy5ZRmkFr6t
         vGVWTjwTWEiqkGaUBRQlvbafcShq+2VV08Odc6FwNZ8nWjYKkfOK6SOG3Mc02AjNKQuS
         k97g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757581796; x=1758186596;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=110hIxZl/DIKAtkNXDUZdekwbiGKdHIJpSsuT6OGVlM=;
        b=DwknMCP1GV6nQ0rKBZlGoL5FpId4ie83tyTAG9WQJoORhzLEH31RylYA3qFCizIeYR
         b8VVr52/RYMfvAJv1DZSBlIu1FFl6cvgS9UCTS+V0sp921N9SRemjAvKtMpxl87QWdpl
         0xW1NiyGKwb5gBcIGFwlOt0O47pFORBhzAUNUy1MdqVBnVkv2lctFvysDR/k9nBud5sV
         mlCb1RdogM4V/rGOFHfR9qge92Jvx4SBPsILP+8fMfMMamMj2z6CphXg/BGlEYwGRVnQ
         a2DDnYiGtQ+7by+wTsMyuYMABDv9grMxWg1FLXaTcRo+fU++zhiO9RklttPezzsN1G+9
         cLfQ==
X-Forwarded-Encrypted: i=1; AJvYcCWv636acwZVMRi89Fa5TMLL6FPiqEL9N0U6UySwVucKI62tnSLr/ZJEtaHuOAtH1QBpiPevuWS6Qw==@kvack.org
X-Gm-Message-State: AOJu0YwNjwf+DflO/xti3HJNbsaPe6tz3X5Zu0I8Mo4J4g2U7o39vknq
	m0HC7OmH8GTfoqEH2nyxoS9mhn8CFBeNuDky5Xr+9LHd6u67q+6dQWecKS8kJezZkseSYc3ecwS
	yjHKiDmmMISBuDl+Jg2w/9mhT52/SSxJ9/Nj6BBhifHJUHZSBZ++dSE12oWQ=
X-Gm-Gg: ASbGncuf/HQm8ii35L5AUFJcKZzb/kuaW0ryN7+Q3Y3s9tfwCYA08HmdCxDEfrG41J/
	98pzrxSJGQSuwp0S7XYogdTqG5bNpH94uMMs4uAZYzIb53MAJBfYsRVi6WYDJ2swg1HmHl1bXct
	ev8k5B43/NXzj3+vUMh2ekMEoLYDoE69LK66fl+4MNa0l8vxqp9H3Ay1Gy08Hx4oLNE2J7oaNCt
	LcaTxNasuo1wr6HY3GTHfhtGxqh9tR8WdIqOHS/aqbCzvU1x0uggRI=
X-Google-Smtp-Source: AGHT+IHgGWXglu0DsqRQzQThUm92HQPN78KOj9YY4D2b+CMNT6C+6XgOPmNb4DnIeOzj1OW6pcFMvY1Iuj4xjLps2oM=
X-Received: by 2002:ad4:5ba3:0:b0:70d:eb6d:b7ea with SMTP id
 6a1803df08f44-73940411c14mr198047276d6.33.1757581795396; Thu, 11 Sep 2025
 02:09:55 -0700 (PDT)
MIME-Version: 1.0
References: <20250829164500.324329-1-ebiggers@kernel.org> <20250910194921.GA3153735@google.com>
In-Reply-To: <20250910194921.GA3153735@google.com>
From: Alexander Potapenko <glider@google.com>
Date: Thu, 11 Sep 2025 11:09:17 +0200
X-Gm-Features: AS18NWCx4E3OdC7mBgPGgVUBUT-xLxLcqqp44Vqxj-OTHUNQdAnrn9pPMhbFdkc
Message-ID: <CAG_fn=W_7o6ANs94GwoYjyjvY5kSFYHB6DwfE+oXM7TP1eP5dw@mail.gmail.com>
Subject: Re: [PATCH] kmsan: Fix out-of-bounds access to shadow memory
To: Eric Biggers <ebiggers@kernel.org>
Cc: Marco Elver <elver@google.com>, kasan-dev@googlegroups.com, 
	Dmitry Vyukov <dvyukov@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 47e3jh9sgmuaqnchzp4kzfjbshnxxz1g
X-Rspam-User: 
X-Rspamd-Queue-Id: C24DBA0006
X-Rspamd-Server: rspam04
X-HE-Tag: 1757581796-180068
X-HE-Meta: U2FsdGVkX1+UDZxYJyQf3XLpKH0B+/K99W1c3qeTyNJBgNRZaeoulqdHZD5sKQRINLST8QOH379EjeDBmX8thgS1WE8lBidzJvbzOANcR6v650rU1V7eZBchS3Vm9Bxf+nKCKsITI5f7oiQJvcSzY1vXZSBZSxn0sjcgNjt8XGcuIUuccIjLqzWXef+kQjXAvCTYAv/ypwJMtSfezu7k6t1EEdptLbIY5knWhmHxSnVi+ajFT6SCOFHzTf0w7sunkpUp1S9JSacZW3RWukHyuItat5lk6LCkNJTrz5WL2/a8wz3Vtqlh2EmT3jaPWSZhpv9hj/2gFJjcA+3sl12O69In+1uVOG1ZJIePdz+xX6p2e0Pt6Rubove/Ma+4/exWdt0gGiX+G94HvwFBzupKRJ82GL/yVU1nW2+rVTaplYKxxlMBkqK6gwpP5M0u4fC7UPeTxDR7dEMvk0h0I0hq2jf6UdiyRUj3D8KyGGUqQFiVlXAefgq4F4keg/mzp1nNSGToU3Pam389a7XpS1QPvS1Awx4Oh16hF1l+EXduXD///HxE1Nu792nOUHRMGixRjDU1or55jcTDO0N6MaYd28cA8H55RJbvjZlqDlzqqNUFrNrt6iZB4ueWrea2Dilx9M9s19cCmzG/DYSTqG6Oer5m/ALtpMFOOHlQSq60rfHgEmIeUK1pM8SplGVo9oIKKmPWGP2sBB6lRKQvhjpCoDH8UdwACvfLvcgzS1ZC6SFWHy8KGcbrHwkzuipXC+XkDy+L3s2DGsu0ioeMbnnSVjdNbisqYsYKaRkQOxSrFJ6KqBvV70NL99Khg+H3YZjRPJTrU4AqfpXD3pzFt8tGTtZDGg0lUqQFwTOWXyJlW1jp3X6SySkcPbh3ks2a+sVYh4xr0z70tR52qpvSQu4M0LQJHhg8UHMI9tzXdC2B5VbWmVy3DsB/pPuJCZ2O6hWDPmyZIdXeKIRqm0yCw1i
 MBkdAvYD
 jHouO/yVjvLTSoCKHvAQhIRl/JSWSvbSjS4kSZ//1C2HaX3N5wQwuTmuS1ZD2fn81Fnc7Y1lDfCaM4qu9FKUEc6jSnWY7IzzdoC/to+1fPFRF7oVSaoH//xhH1wL+xQov6agUn4iXU+EdZN/aNufv5IDpqng2nK+/mXALZu6S49nx2148gh3mXbzi7M3Ej8RC5CU8OtufWr13TKiA+x6BReSx4iaPAQEO2nB+v7niSR3N9GX6OMoHh07NY4KsYFldJNh6bKo7NsoYp+Me05UufXmf5w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 9:49=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Fri, Aug 29, 2025 at 09:45:00AM -0700, Eric Biggers wrote:
> > Running sha224_kunit on a KMSAN-enabled kernel results in a crash in
> > kmsan_internal_set_shadow_origin():
> >
> >     BUG: unable to handle page fault for address: ffffbc3840291000
> >     #PF: supervisor read access in kernel mode
> >     #PF: error_code(0x0000) - not-present page
> >     PGD 1810067 P4D 1810067 PUD 192d067 PMD 3c17067 PTE 0
> >     Oops: 0000 [#1] SMP NOPTI
> >     CPU: 0 UID: 0 PID: 81 Comm: kunit_try_catch Tainted: G             =
    N  6.17.0-rc3 #10 PREEMPT(voluntary)
> >     Tainted: [N]=3DTEST
> >     Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.1=
7.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
> >     RIP: 0010:kmsan_internal_set_shadow_origin+0x91/0x100
> >     [...]
> >     Call Trace:
> >     <TASK>
> >     __msan_memset+0xee/0x1a0
> >     sha224_final+0x9e/0x350
> >     test_hash_buffer_overruns+0x46f/0x5f0
> >     ? kmsan_get_shadow_origin_ptr+0x46/0xa0
> >     ? __pfx_test_hash_buffer_overruns+0x10/0x10
> >     kunit_try_run_case+0x198/0xa00
>
> Any thoughts on this patch from the KMSAN folks?  I'd love to add
> CONFIG_KMSAN=3Dy to my crypto subsystem testing, but unfortunately the
> kernel crashes due to this bug :-(
>
> - Eric

Sorry, I was out in August and missed this email when digging through my in=
box.

Curiously, I couldn't find any relevant crashes on the KMSAN syzbot
instance, but the issue is legit.
Thank you so much for fixing this!

Any chance you can add a test case for it to mm/kmsan/kmsan_test.c?


--
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Liana Sebastian
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg

