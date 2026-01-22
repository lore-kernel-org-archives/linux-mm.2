Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97CFDC44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 08:59:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB21C6B0120; Thu, 22 Jan 2026 03:59:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B89F66B0121; Thu, 22 Jan 2026 03:59:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6BA76B0122; Thu, 22 Jan 2026 03:59:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 965B16B0120
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:59:35 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4B2E113979B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:59:35 +0000 (UTC)
X-FDA: 84359001510.17.F8D1342
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id 52B2E8000B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:59:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NvH8e+Ql;
	spf=pass (imf02.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769072373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wi+aiksRUdYPRu7nOjHBlGLDUjwQ5QAqfYPQCOfFmHk=;
	b=aF2ASnOx51x7m2fbtSf5v2Rq1Zv0XRfjlRNy50Yf3cjN1c8HT6+h54z/WgCRz+KgKIBDcI
	toGIyufCOQTGoBlzrCqhITPhXxhT8CD9lh82kPT/8OOOlvAG7z/rF2tK5QimTOKYy1/y1R
	GDx/myPjenTUoZDlcFmSFP5R/yKL7YA=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NvH8e+Ql;
	spf=pass (imf02.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769072373; a=rsa-sha256;
	cv=pass;
	b=8V/AzXpqqb+n5wmGCOgGAghI4j1QVAaon66fjPDxXQOq4XhXMfqyvl/UxhOk98XdCjEtMU
	xCh6vYojGZpTaYMHUrYsgF/lo5KW9HGOAl02Ri+QJacHLSXlfGiwRlKXfMgQEYHnF0L/u2
	kPKXfgV+/zAE7CANdlnWHKgvEMXa1J0=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-78f9b964c3eso1794727b3.1
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 00:59:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769072372; cv=none;
        d=google.com; s=arc-20240605;
        b=CySMO7oJPxHQ0fLTWQ1emfr9RTEm2YkGeVP9X2YaQEXptZY1OIN6tRaBcxlafPXgAc
         /mQjetLCFsfr+rWXPUEvIInBcHVCnldx3FQYZXoYjU2H39Uw/xVQ9O9tX18ItJXV3u1a
         4yOqHqAVlO1shd2GT5B8eH9Tg2sDL+NG4bNjYANVzzpp4Kooj4MMEWTnXPVNUc1nukFW
         4KP74WNjDA79Nejh3PeOFFUoBsb+5I7cUqg0LrlSDzanf0K9Q3CKzxykj8yP1OcKodT6
         tY4ZcmubwtlM5eu5vfbvOFOL2dDnwoyLipeKf9AihY1LHIxt9Hz7m0BUNqXfkIh6OybU
         wtWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=Wi+aiksRUdYPRu7nOjHBlGLDUjwQ5QAqfYPQCOfFmHk=;
        fh=7N8+CggVGNZOKCfr56Y240ZeQv97MYXNkSNS/hIkOPk=;
        b=in4Y/AQ8LLDivNLbQEqEwB2xrzm+l+pfltzuuBljSBp9vu+KcOd2XoizAtFXTr26GR
         ml/2XwB/pQ9NMWmmDyE/hdG2Enwe5qGbN1fWDGxoWIYuHCP2Oj353nYqNT5yOdRlt0qC
         rPfGHrlYhuCL13+WozeyqOIRc0cLA7f5daWpwKmKBx7kio9Okp+IT/hHdS7PSIFPO3it
         WowP1elmn2pRI1FHYN0eEPjVr6G2XrsRbDgQzufeMJ9auQvpi6qfnbmb/HDPxrbsVbOW
         K9XAgAmMiSq41qIJfONjlPIuDKyvLm0RvOFx+9heznwdFOGm7PgxpZrwloJt3RqPi5UY
         eR5A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769072372; x=1769677172; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Wi+aiksRUdYPRu7nOjHBlGLDUjwQ5QAqfYPQCOfFmHk=;
        b=NvH8e+Qlv6HAI1CelzMLqflwxclx1jETbbYMUcIwf+TFbhUYMmGA6DT3Py36+aAEmy
         +sdjduOcOsbTIi9c99VvWHNOVhcFY+RGLTHAtiAeSmphndyHuCYMabtxb7FKJRmsXZe0
         S8Vlc2NwxOzYznuYXiup0hMPIPL/8xw/w+I6Ni6/whWa6WPWgzI0vgaogu8UpXJCFWYv
         hyRlBX4dmCx25XFoe0/W2A4LOpIH0wA6ekPnnDqKX/hY51k5RiA/AQEcjRT+llxfXCDV
         3OzddcUB0VYXhETR3Gf+iMjcjwZW09yXsdxcsjb0ug9XUmrcDXxXeCkxhrrm/L5N3Qsz
         mtbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769072372; x=1769677172;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wi+aiksRUdYPRu7nOjHBlGLDUjwQ5QAqfYPQCOfFmHk=;
        b=B312k0On26sSabtWF7XmfdYR0eZBNRK6bUQMNAKGeJK6j08Cbu/JmaHX1HP0i8gL5x
         A3h01Q4CqfbRy608I5gzDvg3NoYbqweWB4nofCg7NEhghNvWCmzUoSlNT61iM1VDwR9S
         peETlFNJmKUjav1aHjweB/m8h9mxgxXpGSllHeyh60ONaD2gd+wZcRgtkKmqWrFlGjpD
         KVzK+WckWgU6jSyA+0GfIefk1FWsW3eS2d1alGOQ0HP896NyuI1TdNd9eCUjIzH6Qn3K
         QnhUV7fpPiWyE4wSYl0zQxBygvm/Q1Gr8YkOjPC9Ki+HBXyiH4Go9fBOHFKu4uSU5yX4
         NneA==
X-Forwarded-Encrypted: i=1; AJvYcCXv7KnEEEH80JPsEUDzM4JaHGx+qjJuJRWOfSX07rfAFfAYrygVgomwP+74mZOOmXjquFYzJw/00Q==@kvack.org
X-Gm-Message-State: AOJu0YxUgU6/eCDM2mF4516pGKGrXm4rhjXSeq7UydVuFRFOp7VdPd2c
	0goY8CYJ/t0e//xrJSx7cV4vnrbYfPbMt6gl0yGwuVrVTMIQVvIONU3u8CwfY2M/rAMQGd70tcJ
	S7Z6gOotbiQ80E+qUvNMxYoHwyoqbOYY=
X-Gm-Gg: AZuq6aJODfvRlMFBdnp4klmTesREK+30pOeJmvHHEzNkCM+J2dTNvqAhzf+3F4U2iSW
	5ToUxZDc8SAFEJ9HjH24YLBFES0ppMdq2Uik6IigHPWDUaKJPse3kDpLycgggKB3xfEm7riJ915
	oXWmYy3AzAVglAjj8QJ8kcNLcp3jAypP/b6zZtcDC+PO4znCdRozdaKHaPjTWWeE5ftCVXuOKhI
	lRsYlY6U3eINmVZ8+Fd3plqr7catlAnPy3AVa7lLGqwEnc+QWDJ/LJ9EqylGNjHPUJBVqMB
X-Received: by 2002:a05:690e:190e:b0:649:47f1:26d8 with SMTP id
 956f58d0204a3-64947f12a86mr3259191d50.6.1769072372283; Thu, 22 Jan 2026
 00:59:32 -0800 (PST)
Received: from 95991385052 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 22 Jan 2026 00:59:30 -0800
Received: from 95991385052 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 22 Jan 2026 00:59:30 -0800
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <20260122041556.341868-1-maninder1.s@samsung.com>
References: <CGME20260122041606epcas5p4fb3f5c418b79bf19682e60022d7f1718@epcas5p4.samsung.com>
 <20260122041556.341868-1-maninder1.s@samsung.com>
MIME-Version: 1.0
Date: Thu, 22 Jan 2026 00:59:30 -0800
X-Gm-Features: AZwV_Qh0e4MZqYcnvCKaN8uGthW0KvntY5zaxHw78pviBg4F1BIOJs3rDhFDIDI
Message-ID: <CAPAsAGyhr+iakYskfFXhOFHv7VBqhzD3sb51_MHMxDaQA9cZnA@mail.gmail.com>
Subject: Re: [PATCH 1/1] kasan: remove unnecessary sync argument from start_report()
To: Maninder Singh <maninder1.s@samsung.com>, glider@google.com, andreyknvl@gmail.com, 
	dvyukov@google.com, vincenzo.frascino@arm.com, akpm@linux-foundation.org
Cc: kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: p4rcy6ooy3saj8p86m3ip7mksm7roydb
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 52B2E8000B
X-HE-Tag: 1769072373-501042
X-HE-Meta: U2FsdGVkX19mWUflBnIOhnXXaJLe1y76jqM7cZb8Sam3jI1E9WEtzVLrU8orRmXk76aewOMCNO/6ar/nk4zjzZAsWMLCgi9F9y2s5k4b/7xJn+BCqRzqPdutdt+F5Gf5fQ1azlMVfj/6/cP8lHcUUFW3rrmj6O/N2u8298lUZqhYzOi5wiZuDj6hzWHgW3ma6TO9MndVhZhR9eIxMdrrX00fVOqSlu/VrVAc91RQjUcf0x1hQlcqgwzyp/T9ep6rbSi3w/TuA3VmBjFDTbLSIwJjX0OQZ1JL8rVLQ0aoDxpUE1vlfQRkIX9mp0jCBHTpnwzvV/UWzUw4goBia99/SQ/kYd4PXi7TWaWkEYZmBT5BE5RBUmlssPmWNT3wCJ3I5USv/h5TWoKiGH0Gx3J6zmfatwxA2Gsh9XtVLWTlBJ8K4apfBLnRLvPcMmxT3rL+Uu397UAI4Z8VQds2LP32S/qTpgbWx26Yijhl3wKypQ+2A2FOmAFHMEDvNJDUR1iDLXf5+SPIuM4NvEyPZpfUB7+0puHA2Gar4k6SCUVkpxk8pCmR1pBb2krQYC606JtkkD3orcGHG+qprDjPRNCAeBxKdBzkJpFXMx/da8T/owC+tSzLkb5wYMZelyA3kCH3RyGHh1qJ9OalyVdKN0ILVLgDP71Rq5lIRBXkxnI0k8rGing0JTHCzKj5orZXlQTA5IEieeO1IkwP/A4ZCOMtkMer7tpATieaVXaErrIrrxr0+g9xam2nxBJR08dr8ZP9x7hl+NVHasXyQRdO+vBqc7pqdtD4Qy7TNVAdAQ8O7osE2DeYN6cbxa/gX/fj5iFEou7/vLHjvqrUG07x5t7xonp9s0KbcDExKncgYAKGj0aIoR13wM316kDNQJz0XCM9zqpRI2+hZWa0yLjs/WGhLx84jPZXcuiVUc0BR8LN83/GbgwAfedqWQwewfHGBbaDM9q18wcrwQEMIxja+e+
 fZgqdO8l
 oZXumQxBmE4+adPAwjii7KVfSyTwywKdyrEAgzEy07kD3t+MpDcbdcO5bNupEuEoAmjMx+AEj9nw6CAcF94HzjoTgZ4ZkeoZ5Lv0S1pEwmj/u0+bHFEGyxan/qIOHsL6drFLMkZPvUryfSVWTohlX55RXeUvytnUaQniQMAFW8dtxUwGQQZmDk65rvETYR4iTMaQ9sQRZen4e7L5Vvj/Vq9IYJ+JRWe99ch66j6G5v7SQDPT1MjK0EKdU7MjR+blsdMQYeVAFDiBsXVbJy3vSC4V1W30iRMp+yZ90PnwkzM9b/i9yqZ/oBYHMwROQhaypHaIxdjNyvHlbECIMcwmXOQi7Wd/hTQ1QMfPHG4bPuhAPAJEunX4Kal0m/E8iDXM/jWok1BF3Mjp5bdPlLPhfPHA5OTr6NaoNmyww+EIme5sDC+sdZLwJzCDnnMDyodQ2P+kwZ6RuQ7e/atAiIsNOLF6G54/dwliHIzbKddjCYRuB8YhpzIfDPstuNeGhq/3EnN75tO1sANkaQuqGRhoP0Z6F/8P5653WB040K4AVrqyZ+uQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Maninder Singh <maninder1.s@samsung.com> writes:

> commit 7ce0ea19d50e ("kasan: switch kunit tests to console tracepoints")
> removed use of sync variable, thus removing that extra argument also.
>
> Signed-off-by: Maninder Singh <maninder1.s@samsung.com>

Acked-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>

