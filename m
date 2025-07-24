Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D960DC83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 09:32:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 764876B0251; Thu, 24 Jul 2025 05:32:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ED446B0252; Thu, 24 Jul 2025 05:32:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58FD66B0253; Thu, 24 Jul 2025 05:32:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 458B16B0251
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:32:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E8891C0311
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:32:02 +0000 (UTC)
X-FDA: 83698641684.14.14614BC
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1450B10000E
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:32:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N1FgAUZr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.217.49 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753349521; a=rsa-sha256;
	cv=none;
	b=ZNCtFemL1n8zsZeE/YvHB4qpGqUKIWFI6y7e5VFXbUGSwV7kMbiwIByB9Ki3hWlz4/oWSG
	mILC85Kc5k7M6tZCPsjpann4q55IuciBNyN47NSayXPLlTWPTgSZBIovhfMJhfjHmcL9zl
	cFvnLXcyEPzwzE4pfQsC34FKbfJEWYc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N1FgAUZr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.217.49 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753349521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=he6tpUSNHAGrzwZLLtdLElJhZxZKcPpVbnsfG1MF75k=;
	b=fLsrwxDyIBYfwnbI7eStHnJ4UJOkvKkvDROCZw/gstVMIx0gOV7jVr0PaF3J2dJkhAgH0V
	ENlz6ypuYvHy7WipQ5vURqJ7l4RdX3q/GRHm1gJ0PoDV+JDdV3qaTdPfqBYfzQbYNSM6iV
	9/XkRHw9y359DdViwm3F9qB+V9SzMKw=
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-4f2f2f22c1aso486523137.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 02:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753349520; x=1753954320; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=he6tpUSNHAGrzwZLLtdLElJhZxZKcPpVbnsfG1MF75k=;
        b=N1FgAUZr3su4JzVGgc6Or4eoeviKHpareqzE5GgG4Xe2kIu1l7sNEU9v12EH6Eet0D
         SFWQfQT7f+ADqNECTI9/MD7ikgatQL2/t5ap4juT5RYdHaLIjpqKzdJ8CLitCgPQbNGm
         ey1rDdZiiU54Yoec2Z8LwPOejqValkmZ8o0hlIEPkjz4Z4fQaXJTVypLEmPF54feQIMB
         EZM2SfBwuOnJLd/s8i1mEplJ252f169gLeH5lUgamYOxoRfLzcw3Xl+WZcJlYQYq46jp
         oSrdDsrPAZpV7Uk83TToYa71FY+NoVNYSXdNscEh1aB60Y3zo1xSD5biKYBKnC7XcWwf
         H3sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753349520; x=1753954320;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=he6tpUSNHAGrzwZLLtdLElJhZxZKcPpVbnsfG1MF75k=;
        b=Si5zA5OCy/T1OX3btJG7ISMi4388mA/KPg9Osmsm42aAndXyY2Zi0blpMQ1ak+F9rB
         j5bHSt8TK8L137nay+p0jIQeKwDoxrJJVRwW86liFOBncUlBH2TITNobbqCyUX0yCor7
         yrR3lK2MktAsZfOhptQ9kwNClw0cDe5V/MJpGjYemLFJf+zNv+A6YYNWIT5rjEnBJaBd
         hhw3y9jn4bIGSx321SWgeMqTogt0m9kDpmca1/W5EI9yPYKfyOY9W0soUgGRWImjbjaK
         KIMExAMifyJ2yumcCtXst3ULLOHaHE+7fUOTPKOsj/awSPGOcgzNwrl18/oIaZSkKmpJ
         drQA==
X-Forwarded-Encrypted: i=1; AJvYcCWo8X3i3D3CeivLmiifv/n8f64VPA+Z88tckSi4gL/UsV0pGEKxgE3obTtXEbAMPBqjSUegSAjTxg==@kvack.org
X-Gm-Message-State: AOJu0YyY/ooEroA53mchsjthN6hi497UJGExRQI75KAcPTnM3W4Y3rRC
	SeVFT0WI0SJNJvhAglwgRgHJR3pCdIl5GyrtjRarwCX7C1ze8EE2FXp654Asre5ZL/gXtMOCR1c
	adOOHF+Je+rtdyayPer0mKy4D9/SDvLo=
X-Gm-Gg: ASbGnct4hk1fmpdUfju/04f2/PHUKrrOfH5e4b3gBRcFrQViOkBV4j6hJKFU8Nbtm1r
	UNSz7MRROTH83pbwrhKVpUAFg9lYsMmAPAiwFWGJ9Q4fV8S2lV3J8rzFyvKd7aTu8DA5Gu5atvA
	VaXwOQ627pjFXyY0byAaruUA5NfbA0/S7Q5VTIVUGEh7uRqw0EGI7wP0eOD9zKnfYYeJ/myHm/z
	DjQ/olmjLl14ztuFg==
X-Google-Smtp-Source: AGHT+IERDcIbZblal/0JJXmwYHJNCS0XtjeF6wbnGcqRuyq4UjTwq33fQQpDdIpxKMFoLLbh2hYEhXu2cpFlMGZqD7c=
X-Received: by 2002:a05:6102:458a:b0:4df:9281:5ec3 with SMTP id
 ada2fe7eead31-4fa2eafe103mr361567137.2.1753349520018; Thu, 24 Jul 2025
 02:32:00 -0700 (PDT)
MIME-Version: 1.0
References: <20250724052301.23844-1-dev.jain@arm.com> <20250724052301.23844-2-dev.jain@arm.com>
In-Reply-To: <20250724052301.23844-2-dev.jain@arm.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 24 Jul 2025 17:31:43 +0800
X-Gm-Features: Ac12FXz_gl7Q_9U3tXMQSMYcmWWpGLT-2j1IcNdZG7435iNjCJnxsvZokZWlwAM
Message-ID: <CAGsJ_4y3zXD1i+g2bt0s1v0h-Vap-pXzOO=bQNf3=68-dY8h3Q@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] mm: add get_and_clear_ptes() and clear_ptes()
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1450B10000E
X-Stat-Signature: ikkggpk95boqifhzt35ry3xaqzr33957
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753349520-9971
X-HE-Meta: U2FsdGVkX19SjaI5+bs2a3NJ2GgnBkP4LliWvk/HiJEiAtoWobJf5UX+pUeNKbX57MIdjgmlwcw0oMUoHC+/MW2MzQbuwNXh/vqWt0BvSXH118qyKbzMezQgoeVk73SMvAtagkg9kJ/NKBVuX3qLg6Fiuo5uhjDJmbA3pik8S9K2KHy7qgGr1VvR8xzfyF5c81TN6YFsLxjOYLKP83uzv8NsTLeRLFoQ2Dfx+m88fJrZvmdNKExj+OqYCePLFHFkZI3EP9ZtqrIvEJF+7C3l2s9vEgialrip30lxM1HW1Qbuo9fChaGazFtjWc9m3jaeJj7ffFbO0OGbh+o0jUrltWMcMvLrAt4v2kxck2S6rCkuTjzpCTENsz1KBiiBMYOolCoPMrTq6eAnqWmRguBlOh9iDYhr1bJyHZ2WgIgrjg65ShMsD3+LNNJkxBREVD8WhbeQFuZGT07+FHthp+zpxlUmk7d4WjAnWGL/ATmXjNnW7I+baOaADlPJZiRErlYHhpg4I92w6kOZrgD40oibcG11Am6lUO0f2LBE1MOh1EnjN9L2iYDmi0/8SBQHMSgkiugomG1XvlX/fel9JOaGx/eFIX8rTK69j8OGFXrZgfZg1dpm7Lt4WFXxJr9+2715hKQK4zgSnJSkAozl4nDo4o4mASiCWNaUobbG2AlnRvgq2ZbfCHqp/gzEY9kCdzWXo6aeozy6DKiPvWqmOqROm/pXmEkY+aIa8ZRyHp3KH/DNjwTcCfYNYrsNrEd2suIPyo1769Km29/tzE1bnukaAaaR+fB/+SX/tpqhhePvHx96vdtcDOyq3Z51jC+TCUp8Ikzu1pXkuHyAW2Xx0fj0nKiHnMqxvrAyAlR/wU3inKw6D5X5zC5bz9eacvQogB92cjC6Wa+M4y8SrXyam1DG3GIzJylGF9ZvlnE+iYsKJomnb+rXlwRRlzKdw1UzUZjc3Adcv5vLkZfLB/JBxSW
 qyse8gQa
 /2dBMMcPrqHZc13QE7Ocb1wkLUTGwRFe7QbtUOLKU9Bj5zp2JqfVkiGSksdPNnn/rSjZsbz52JTp/Q1QvF+GGJMxfXzs3K8lwJL1YKE8XMAkh78A6rnHSLI4eFSUjuj/NJR5B2wdfrUGnngyScw8YCL8WxQ4CVS4x7oOLEI8+ntpBe+XEGlcrY0bX56uOYWjGp9X60vQA1G7BiiBsM1A6cy8ESVJ6vwcedMqSm4XdbuHACAAT2y0BdY9jFh/Hdt2aBHdC0fsIyVpZMPJxBQou6jbAb9wvm9hebQ1gxsMVHMORFZ0wUn3kMMIL9RV4QGxgvLYPjtLRA9kjBF5vy+8sWBZVsPq8Cng1OJUfavuy31C71OxMTUregEc7o1ma1IHyNa8IxLA7p2rshI4O871n/RYLEGrMSmiHoWdYkTcXnbHA8j6xyRu+ug7gBjI3CQkjBWC8BL8iTWgfs9uUI0UknZzS8kZJiimjBDhq/RsPNNMH1TJhVamlpZAdVeY1FYSikwJOaSTTN67Lmrd82yJxB5F4Fw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 1:23=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
> From: David Hildenbrand <david@redhat.com>
>
> Let's add variants to be used where "full" does not apply -- which will
> be the majority of cases in the future. "full" really only applies if
> we are about to tear down a full MM.
>
> Use get_and_clear_ptes() in existing code, clear_ptes() users will
> be added next.
>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>

Reviewed-by: Barry Song <baohua@kernel.org>

Thanks
Barry

