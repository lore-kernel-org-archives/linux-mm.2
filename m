Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D655CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 09:54:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB8FB8E0022; Mon,  1 Sep 2025 05:54:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E441F8E001B; Mon,  1 Sep 2025 05:54:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D31B38E0022; Mon,  1 Sep 2025 05:54:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BAE998E001B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 05:54:33 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 86595160757
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:54:33 +0000 (UTC)
X-FDA: 83840221626.20.F544FEF
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4CCD7180012
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:54:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="JgS/2ofN";
	spf=pass (imf06.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756720471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AtiBYuO38BwZPKf5+lGKWitSMYCT01XKTDpZYzEyuXg=;
	b=cnF6QDIcvVjC28Vzi28PNOQoQGevI4fLr16IDBsQtgd9L6CZNEXrMFvgfSXozEMWQVPVuA
	AgCxyIfzSbXByoN8rxtcT3hkR7eUoWFXz02lgVQGqFgWEOqJ+UgHOaGd8ZuNttma7fSVcb
	2bVbVuUDC8dOQAYC7ubpzfU+r6SGSSg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="JgS/2ofN";
	spf=pass (imf06.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756720471; a=rsa-sha256;
	cv=none;
	b=cp3OpQ1WZZsBJRt7RwsG0popRLnurUzUFyvITlWQ93wPCnOod6YdTv3OoYdqF5e9Z7b6Vj
	TWILWPcZXYjB6BwRFxRt/ebJ3MP7dwuZfVFoT3JGG+rwps2gXLbTObRC247su8v4+fFEXI
	AXS/M4xIx1HyBJ3RoLhdqdoPodVI//E=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-afcb78ead12so668206766b.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 02:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756720470; x=1757325270; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AtiBYuO38BwZPKf5+lGKWitSMYCT01XKTDpZYzEyuXg=;
        b=JgS/2ofNGmlcaFt3Q4zef3k5wzx/g4lnbH7ad/jOxuOKG/PmGTtwk88gt0uboedFH0
         Ng5QGiuJrfB6ToDZcZqelF+XwkhnmUQGsnV9QatdjOvlM/pCTJinQny9VIv3XkVJ1qH0
         0tarjnPYkODTzNhNtZrK9dVHgkWV3qkcCN56H30mUhKvEcuhXPKsWAbT82iSt5OCUg7N
         fMdvoYtw0JXJWoZ7bsg66j6Lm9qSlfdQNcQ6cafWsDOJM0zXqWrmqUbG06/UkvI9h3eC
         gW0Mw2TGK2uAgelLEiuP7hRDS1584hZ9uLMdch8iIPoVhi/Sd0XVnKArP5NE+f2aMD4G
         6TYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756720470; x=1757325270;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AtiBYuO38BwZPKf5+lGKWitSMYCT01XKTDpZYzEyuXg=;
        b=VmtDvYFWK/juDbjif+VUtAl+/Apb3yTARaUlp6bzdKNnwItSDzbOkkR4RVSs1707ED
         O51dMKVgtABdW+X5Xh/mr2S0vyElcmuAVqhNvbuVqgYpSZz+xK1ARF490CmIsRRYf26q
         y0aMWhmb7xjFYQ48crbsq4MRW2SeQdClBctycmiuWSgKnegU5ARzcpR/dsTUtHap007v
         g4HophkpECecKfP4ZP/kqNxlY5OxYjfcK+6uPDZUj5yt9X0V7sqypG6IIy3xf7e2Injl
         zQKDmOUviELtXk7I7MS9wSC9xAIjltu0H51aveutHN67c5NP0blmlTT1jYIbDf2zcanv
         3/Wg==
X-Forwarded-Encrypted: i=1; AJvYcCUG2b1248tT6gZexbv3r4jOembBxEZ8vMn+ginwmsstFnII2SIQjcuSlcznL22UZqI5hhm0GH+T3g==@kvack.org
X-Gm-Message-State: AOJu0YyIHX4SSRRgxhQJDb01JBVUBFGFQIgeLCNQojk8ubdtKzBVGAJM
	ubZz/wA5hXhRJmOas9pYqSLcIFVNCQ6Y3J1JfD8jJKaLSAHu7lLoD/kSVstGDgX/F5JZnd7z/Yd
	jHNNllgP0hn/l7hJGBKw4sOfc13F34WPhJyehV8d4hw==
X-Gm-Gg: ASbGncstOVEWWxYJzHxQd7QSDgaihyrJpK6MQEIqpKOqg0v4XOOSndOH1KHpvQe/9C9
	8x9v7K14KmNTZhJWM48xbcSS1jyJhTnJbOftMTme2ohKpdfVyR4np17cgtQVph8AzSwbQwWXZYN
	TaMOUvEnzc5UjRvQ1jRy2P3GrHny787XKDHDBqW4fLH/1dlxGeTTFiJa/QGd7shdTKiwxnPlBnu
	zFitGOOsPl0CbQ6j1cTAPaBKQ8WSIXoj8Q=
X-Google-Smtp-Source: AGHT+IG926akpOzWZcf5N3mV7elDZw28XggHb1wmpA4WdWitXiObkp2qNMaOn7Rtqs/aofUinFciyRkhDtIhzXPOX5o=
X-Received: by 2002:a17:906:c11:b0:b04:f8d:bd7f with SMTP id
 a640c23a62f3a-b040f8dbf99mr446115966b.65.1756720469662; Mon, 01 Sep 2025
 02:54:29 -0700 (PDT)
MIME-Version: 1.0
References: <20250901091916.3002082-1-max.kellermann@ionos.com> <f065d6ae-c7a7-4b43-9a7d-47b35adf944e@lucifer.local>
In-Reply-To: <f065d6ae-c7a7-4b43-9a7d-47b35adf944e@lucifer.local>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 1 Sep 2025 11:54:18 +0200
X-Gm-Features: Ac12FXw_rNjhcoFzQKi2bXoe_2WtlXZb2wNk3G9XO3JBfL8ul9lEEea3cb4eO1Y
Message-ID: <CAKPOu+9smVnEyiRo=gibtpq7opF80s5XiX=B8+fxEBV7v3-Gyw@mail.gmail.com>
Subject: Re: [PATCH v4 00/12] mm: establish const-correctness for pointer parameters
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, axelrasmussen@google.com, 
	yuanchu@google.com, willy@infradead.org, hughd@google.com, mhocko@suse.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com, 
	linux@armlinux.org.uk, James.Bottomley@hansenpartnership.com, deller@gmx.de, 
	agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com, 
	gor@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com, 
	davem@davemloft.net, andreas@gaisler.com, dave.hansen@linux.intel.com, 
	luto@kernel.org, peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, x86@kernel.org, hpa@zytor.com, chris@zankel.net, 
	jcmvbkbc@gmail.com, viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
	weixugc@google.com, baolin.wang@linux.alibaba.com, rientjes@google.com, 
	shakeel.butt@linux.dev, thuth@redhat.com, broonie@kernel.org, 
	osalvador@suse.de, jfalempe@redhat.com, mpe@ellerman.id.au, 
	nysal@linux.ibm.com, linux-arm-kernel@lists.infradead.org, 
	linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: u1wb1w4p3fretfe3iao11sgnp13nrcek
X-Rspam-User: 
X-Rspamd-Queue-Id: 4CCD7180012
X-Rspamd-Server: rspam01
X-HE-Tag: 1756720471-299433
X-HE-Meta: U2FsdGVkX1+ZcA7v5nSM0Geg4BjMqj26JPY9CzmgBIGxJ+FtE8UQs5+sTNn5EZZAFHi368espjqGgUsnDb4nuMQ2Xzb0MYQhAoy0Uljrgp3ls3V3w7ZQb16i2C1cfp6zbR14sbDI/EnsDT7tUbSBhY9YNhq9chX9g4iHkkly/u/aBjRx4bzOk8JSjz0CdN30hMdhxGXz9oQs9yUFUUd+jTezN0SJagd6qCg2aIpOYlUEX8EBotXoEPwLlvRlp9nsFe1VnQPaUZZhk6aGRsJeOmWumt3FfKnAOpe/t/VbsS53bghpSDBFbPdTybmMDD9r8a3DVZjG/buGeTEVuLnadRgB0dlqWArfEPGL5nd/gKhmA1Ez5BiO7W9xTN+e9kSxDNT+eVWoqfH1xrUqq8PN2/R5OOrMsVxNDv1YeSISRwe9tmc+Pg8cg7LhQhyolTIyNMBjc/fDQVD2zgeh78B01xRJtyQHDnFGZj1fzH9rYnGvXLiiWIFkQJKIGfU61g1bvEzddRKDpWxh4z1pLQH2CArZkmlOZNlLDGyHKeZsxT8ZT1S6vfY6sMVMsOBaWmmJXMKF2iesTQ2qJOHeSX0Ll+BSfsB6Tc5S7OakFwNsnVRmYyOUR1jfyvwCqVldXR7gVXeZQE+sL/QtBIKd6/baZwy8rQAfuBpjBWEhem1cEAElW4qkENsf6INRvWcVGf3FUTaNlEFW8tHgUVWz0w1SDSyQQrY/AOxoufMSZSrfHjCSou8RWQn2vUl/AAGZ0RIqe0gL7nqTAf5rz9qWkS2VnmYOpbjocoMvYPvTBUMZIb9DOSVDTm4teNr8siq7M5FkPNanA3/iPA5IoEftCncO2Tdo29sPYiG4UcVkvQqSfso/eXy2zMLU5mkIH61AOj2D9kTIQum5/Dmj7u9ji4qv7fEJ0yipF4y0GIxmIDWfLcG1zlyFSW6vNhsTWs2q0HsOb7NWx3nAlFCexurbfIF
 J+tc0CFJ
 XJgLLL1OLAVfx0/m3nJZCgadPWig618Qw9Ho/O2XhTbtpufTylF+eBciPuaZR9VclH75xiJ5lFtHdAWVSyCmDwVd8fBA6gCg/A6Q7Sxhkr9EvAK0NFwO3fJsAf0ztcCNQgwu72cyCiWP68aCVvwFdH8avfJcvZ6SSZKOZq/nMObSAWbjcZ0rtWC7uMwpegPbuKo3o58kgTnEBWXIg+H75Oplxzmb3eAAcxAruXrcrflzWlOw6fp/wn9+hhfBI6ytq/Vy4u8ffMHRjdjNKHSopZsGpt9ZKAxkGEgAgEkuOjwc3mgxL4Y9ODfUjdoqbw6XRFfEldwoJ8VvDr24=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 11:44=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
> You are purposefully engaging in malicious compliance here, this isn't ho=
w
> things work.

This accusation of yours is NOT:
- Using welcoming and inclusive language
- Being respectful of differing viewpoints and experiences
- Showing empathy towards other community members

This is also not constructive criticism. It's just a personal attack.

(I'm also still waiting for your reply to
https://lore.kernel.org/lkml/CAKPOu+8esz_C=3D-m1+-Uip3ynbLm1geutJc7ip56mNJT=
Opm0BPA@mail.gmail.com/
)

