Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31495C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 18:31:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF2E48E0008; Tue,  5 Aug 2025 14:31:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7BE48E0001; Tue,  5 Aug 2025 14:31:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91D238E0008; Tue,  5 Aug 2025 14:31:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7E48B8E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:31:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 10B711DA444
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 18:31:43 +0000 (UTC)
X-FDA: 83743547286.28.B6D3526
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id 15D4920011
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 18:31:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MLk4wrN5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754418701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bjc0knauv+Bmu5GSGfndO4T48Q0/DzlvZeIE5Nk+Dps=;
	b=2lx0VmFvE+F2D22fsx7kyBW+vXQqCIehHKP/Lm4ZIqJwFBFIsB8Gy+0bfvNIhsUS3dPXTd
	+UdVpNINt91Ooi18/YVbrpKyU6MheB6wyycktxGvEKNyMOEOoi9Isq4IsfT3SdCt4Ple/m
	xbbPrX1GvuPfx6Jm6wXDFeXZ/4rBP84=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754418701; a=rsa-sha256;
	cv=none;
	b=IeEhjrmg2xwOpJS9pPsYN164+QuLRNwc0QusawAdztbiH+Fz28WaMwNRJOVDxoc5ABH8gd
	vsmpVaI0Teu67waP2w9dWGKimXoOwovNW5GEzKLWPbaL8JTYbEYytvA8VYFaUPtBQwMkWp
	6b9SMo0nOfngiJAnXGRY5/erjCo+tY4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MLk4wrN5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-88180b57db7so68251439f.0
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 11:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754418700; x=1755023500; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bjc0knauv+Bmu5GSGfndO4T48Q0/DzlvZeIE5Nk+Dps=;
        b=MLk4wrN5ABWuz/IJOrjsQTYa6rh8AqQ2mCKuqBi7hv+j3jFmL79rPucVas0/iWax7x
         uxD3DNEeyd/BiUx7/q3m3B5FMYvMJoTmyxZ3LBxjCxbudPgDWmREuJaM9BXpjQcj7Y4/
         nSwADJNcR9oqOj9qFtRIsAYzvR/CR2QgaSORgkGusYNGFir1HesCZcBYJni2jXknOzrW
         lBla1BAdS1GmPTCswKwzQCjbrKuF48qfsi1UqVtWEePTk0BfYHfk/Fzs0xJqhyPAoZwF
         u83sA1VMXmEXctIslJ1kGMP5/iFoyqxfXRstLAtfjiHNwWFAr+PI1LTHr2y7O90zChxc
         Wn/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754418700; x=1755023500;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bjc0knauv+Bmu5GSGfndO4T48Q0/DzlvZeIE5Nk+Dps=;
        b=YDN1W0uQTbM5yQ7BrIfmc8Mxgx6M4ut23pNll8FFy3o8DQsN9MvAfwwe1ld3MTa3XF
         VUKTQPBocTB+WwNiOvfEMDy6XgaJzge0UJhbfs5/4bR4J8PXSzPvK/HsGworE5PcFN+L
         frARu/+Slgicx0Nh4q2snuG2MpRZAdarLogyLKY35elvxNwD1+kcu9/aBDD6RGZer9J7
         4rOglWr6SHANRr5xWQEqM5VKqAjTv34MvGNS2dIoLE7et1s8Thy2QpgZRsb1EeY4w8Sy
         x1aG0tUkRbe1dF/epdDJS3dVxl8YWtQKzp8SFsJBAvwStgtdE19XCMiazYQsF0P8bMSQ
         vSew==
X-Forwarded-Encrypted: i=1; AJvYcCVzcrKF8g6f6mTSh4zSb1lTXdsAjBUHtpsetsRiYagXAPKgVrlYZX/wPk/Zfvr+E14FGC+Ww/p13w==@kvack.org
X-Gm-Message-State: AOJu0Ywk08bSas/wjBRLtQdOHJJ3imzocNWzhsWmrN339gFKErcrvml1
	6TqzUwAcV+EdST5p4TPp/IfMs7EVohyb/OyhftmVnL7VE3g+p2VHVGWHkyEBV0D0RFoiiFeNKCS
	nH7ZtgyrdLkZzoIHn5lKJIeKZz6S+I3U=
X-Gm-Gg: ASbGncvXBDDoeFVy2x8p5HAJ1x9FXx2RqhtPbgFkRKTuwTh92AURx0dzLe4HVmuaYZe
	42MXQLfMUvbLGT8CMjNfWxO70R+IQfEO2kbLBqMFr4iZGVUMtA8HRp5zwnW6RRIMj5SBArB14O1
	+9FfUKd/dgdVQTpuNFcX4p2KmY79bLa95AU7S2EBwUMvRSEl4nhWsxVzCDvFETlKUWoL8uJdm69
	2BHQKQ=
X-Google-Smtp-Source: AGHT+IHG+mN7Qkf1e9Cg9MWqNuOrziaV/Yzsn/bv5ix/Y0IBuWtrVCZuKuskhq6RO1pfOyj05WB6XR4XfQ5Iv17m8UQ=
X-Received: by 2002:a05:6602:2cd2:b0:861:6f49:626 with SMTP id
 ca18e2360f4ac-8816834f432mr2621376839f.6.1754418698559; Tue, 05 Aug 2025
 11:31:38 -0700 (PDT)
MIME-Version: 1.0
References: <20250805002954.1496-1-sj@kernel.org> <CAKEwX=Pv4+nhG5j=qech3ox6CFKJL6Ox-xy_Tb+cyyXgZU1oPQ@mail.gmail.com>
In-Reply-To: <CAKEwX=Pv4+nhG5j=qech3ox6CFKJL6Ox-xy_Tb+cyyXgZU1oPQ@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 5 Aug 2025 11:31:26 -0700
X-Gm-Features: Ac12FXzPb23oAQJzLJEHmz2qXgO3Ui0nt3GuISZT5x069o-WuydMv99Uh1UWt0U
Message-ID: <CAKEwX=O-_J5Z33XGfUOJDBk8hOsBkgUpDhHMM6rPvP-cu7QASw@mail.gmail.com>
Subject: Re: [RFC PATCH v2] mm/zswap: store <PAGE_SIZE compression failed page as-is
To: SeongJae Park <sj@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, David Hildenbrand <david@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Takero Funaki <flintglass@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 568fwsdthp95o7kxihznkat9i7z4bii9
X-Rspamd-Queue-Id: 15D4920011
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754418700-723489
X-HE-Meta: U2FsdGVkX1/HFNA6Ooz9VA8AsQBUUqbDB0oWXtTGvc9efMI7lrGQXdFkRIXjMy+pXOnHoHoxi4TK64C2rP9kxNMwy8IB3BxFqHvnKcacBqVvxP6T31/kbcZgF/5tKZ4HD4yZkeHk3xJbeo480+EBOZx5EhLmlTM5Eqt1uNpYgmW+9xzuMW2cu0dF2DHOIXfgOg38DRr7jtTh5V6PmLv14w6tzstt8mY9hmDB1y/D1MWJb3lGcj9AQg4B6lBCU86o/mqOZI2Tw4uWoGNHU1YBieFTYesw0OjqvVWecgwzRVYDHnbrh1bjUsLC4DWyUDfjbxO0OTFJ/vHdf3bJjGSx2OaquTpN9njKsZmiBSmahm8w2YMaK00S80wsl6lkUdvgkhVLLMzHPPyfthXmXcsWJ6FuCcXBmrLPzxEj+jZQ/yJNl6jfeBMrwg1pfI5RTjl2vF3Q6HrTY9AtM1pFzRTwAOY6+PJNQqATy3gGnsASEvYUjDdnB2k/Xp9MeZoUvBeOFrHohphXzZC5e+Hl8SKdnBIus0Wk0F3132TXNXdGhAip9U0PwE6cwxYbF9b/nAiQGlTFqpwXa9ZPIwxzTF0ZmuqliLv3p559MPlCzV48ZGSBBPaH0d+UsG4xyiiuyaeucYRyExNuAbzgvI3tZfug3a83C0S5Exzh25GclHzHS0J2pZJkaoYH4RVQN06lDzzs+xr2YL3RkgTtibIzhcza4gB+qeoW04GMVhVRGG0oM0kERrLE8K5c3wbI4KsoPEnidr2W4RmNxEZ73f0wDC5KpUP4au20rD87uuuPYd3PHP2oG90qoAiO+9g+A4dluAnsnO4/NjiBwWhsht1+PAx1Sls/2hNOgYnJnFW6mJ7XQ5IxgkQaSj9LvcHZfwoQXlPpXfwiFZ1hAtvGAAiLxmtnjbLnILIiZ1CdcBXWgPYmy0QEXapymOfQa/yw8e70OKxuPZJPMA92SKXrWWD/cjg
 93wZWW4b
 gtPVNYiywhQJ4uBxCzi9NeTtaT+uq/cWdSrYpP2IxVdOCg82Vg9oJ9x6g5N1v5pa5gk5JZuDEWDLw3HXVmiZQf0lzC138YQc7Fj8rA/H02/6nr1KLRutIqtipAQ24iHpGdg2k5os2X4XO81CojWSlv54KaG73IahH9WX9Zb6ASUZtV35Ne2oZpNEtmk0vJOA/iqATKa8AkJa4UYuCh6quEPwYlBmT98Gepwks251xZtkJZj5rj0hWV/15G9XjC/BNJqjg6QFPxhv6uJEk72vj8LmroQOI3XFWFR/MPuWopyTT3K8PHswa+ddtVPAd0XOfGPpcqiT5XSgusmXqmIpOqxAihu7N2ufWYLZKu4qZrH3d3QsGK9nLqJMCajFNM/I1dEfegU6k2w51zfZpj7GQZG8VHztrh2t34EgnpZXd0M5oPho=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 5, 2025 at 11:25=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> 1. At store time, if comp_ret or dlen =3D=3D PAGE_SIZE, treat it as
> compression failure. This means: saving as-is when writeback enabled,
> and rejecting when writeback disabled. Basically:
>
> if (!comp_ret || dlen =3D=3D PAGE_SIZE) {

Again, comp_ret || dlen =3D=3D PAGE_SIZE here. Not sure why I kept making
the same brainfart, lol.

