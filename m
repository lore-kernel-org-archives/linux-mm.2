Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0E74CCD184
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 17:10:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 322278E009B; Thu,  9 Oct 2025 13:10:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F9CC8E002C; Thu,  9 Oct 2025 13:10:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 210B08E009B; Thu,  9 Oct 2025 13:10:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 106868E002C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 13:10:12 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A8C05C0AAA
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:10:11 +0000 (UTC)
X-FDA: 83979213822.16.61AC52C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id A346C100007
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:10:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Y/JueeQD";
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760029809; a=rsa-sha256;
	cv=none;
	b=T6CxLM7uvZYgCMdY840ibztqgCSCrimowNdGhl26H+g196jMrlhHc/gXc7zgqPc6VfgeKT
	Jmnlwvo4ekMYHPe4dgW+dFaEMOEWlizuRVDPYmMd9KlZQsaSAE8tihTQRLR+W1UNudiYjS
	e3p8zJe/T2ry1PQiFs7ZfV2vJxJqaQ0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Y/JueeQD";
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760029809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IIKXn4ePk3SQqbi0PlwinPf5QnwsCpq4S1CJQJv2bTc=;
	b=oQFeO7SQ3YAsO0HXW1zPQ5nANPDKugHbdF4M5qljWPT7DdL7ysgj+nsmm90Rfs/FeUwsJV
	rNZSg+QnhJwLh/8mLdHBTKynp5evjMWJBGZXTz01uQ+8VnRcM914BMEv2dPWssq8qrR7lB
	V2CJYC+hmuh6eS+Ej1VE+Pt/J/+xh3Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 965A348F39
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D18EC116C6
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760029808;
	bh=IIKXn4ePk3SQqbi0PlwinPf5QnwsCpq4S1CJQJv2bTc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Y/JueeQDPuIac7dXnQP/GHsjhWHSdahJtAagggm3nsorasoKIx5ANKvhcvlDCIEv8
	 2vNtg5WqgSrhi+DX7KSfo1SkAD6noeXaizfI7OaJzcIDG7ap/rxM9pWfz8O2IAfWZz
	 YWgoadja0MhNFuG+MQQZ27BAJKJCncEAqFhrYMhU3NGySprx3uJalTfEAkESYWVkAr
	 lmker3L71wglqSFLQPx+sXlhGWrRt3N3yzkYRouz+6+DGOYH3s5I9onYRbs0XJaw7I
	 GV/jmaoCYP3iZCeoeq70HsPrDzCw1ALMtIJq7/FVq4UN95PUb49psMMVp8i6jzLp0V
	 +Drw8SZIX+5xA==
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-72ce9790ab3so12380537b3.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 10:10:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXgm7NeFbw6iM/FxPK9aSxFCHYXPu37p5rxviH/1p+mMwIxVxRbAZxikijDxvbFjH12HIqut/o2Tw==@kvack.org
X-Gm-Message-State: AOJu0YyZFYk7FL0MI2LPJx5qS3dOvObNuayq+114kCRtgaauU3N1JkDH
	8RzUEXAxHajDUz/jEKeuTiin86h7ODAiGWwmGSUDGq8i+hsgxngbC4iFpw18NYg6qA7Fj2MkvV1
	c+VY3aZDlBIeySlj910FuifWptC9qsONXHC0jIRv37A==
X-Google-Smtp-Source: AGHT+IESmvdI+wo2qPLPAl8feXroOBtXMmphyTSFhCo4VWf1pboVS1FK+NW9kwkI01HXVlPeUSTspTX+9Lb4oQquPso=
X-Received: by 2002:a53:ca4b:0:b0:63b:8e09:7a47 with SMTP id
 956f58d0204a3-63ccb8469b9mr5754393d50.19.1760029807713; Thu, 09 Oct 2025
 10:10:07 -0700 (PDT)
MIME-Version: 1.0
References: <20251001043436.41338-1-bhe@redhat.com> <20251001043436.41338-4-bhe@redhat.com>
 <20251008202623.1ef2ac29af9b9c3d53aca4b2@linux-foundation.org> <aOdoehPH1O2vJnqv@MiWiFi-R3L-srv>
In-Reply-To: <aOdoehPH1O2vJnqv@MiWiFi-R3L-srv>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 9 Oct 2025 10:09:56 -0700
X-Gmail-Original-Message-ID: <CACePvbVV7b+o4x04JS_SiQv1f8=gZv-fr-EhFT=AjkEsfg35qw@mail.gmail.com>
X-Gm-Features: AS18NWCYjlfw7B5uBEtk0y0GCqzCWB5PteOLZ36HLChKgZRn6PEsXIsOAja-XIo
Message-ID: <CACePvbVV7b+o4x04JS_SiQv1f8=gZv-fr-EhFT=AjkEsfg35qw@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm/swap: remove unneeded swap_active_head
To: Baoquan He <bhe@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, kasong@tencent.com, 
	baohua@kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com, 
	YoungJun Park <youngjun.park@lge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: z54wr7x6oniyoff45r87jjq3nnt5iobn
X-Rspamd-Queue-Id: A346C100007
X-Rspamd-Server: rspam09
X-HE-Tag: 1760029809-988759
X-HE-Meta: U2FsdGVkX18hJ4YR/TwObmxVfGzjwiRknCK0sHQ8wr90H8ojWEl9TlSmmKNlzG6io3/TtNdQ6QaHs/9GbhmqE0GF3M1z/uD5r2rB7X+6tFo1KeTABfOZqhMWriHFkhbwIy8cr/ohXD1NesIobEfexnfdWs3v8y9MbAHR/jhGteWH3nl4zyXbsmJMNRuh80BYAaRB+zRiPH4n4wVk37jhllU9iYY3B6rHgu1alOnIRxOUrr3m/h3elYrMNOrL9g7wVlnqueHFhClDHXUCzqE9T/AlR4w4HTsV/QHwrGZ+qIYmV23N33dlLY7ZAq9K8W/j4RFRUKIkfSQ1nntgxC/YXLxBADgS7l0Lahkntdngx3U6Fu3LXOUCMxrH2YlTA5BB8Uq0uYsclQ7hkNTPrVGlIEPpAtj42b4bvphx2Aady59hTnhHSl0FhgfoYbSfRdUzH9ANOMyS/9F8/hPXv8b1lJVr5cTRab5taJRQoDGupXJicstcncfOtQadmK1KAg+tMHLdEZ+L/CRZxvZt/DIUJbBuY4SAdiK/CwQ1FrSNQJF45TI5kiAzbbaPKn+zr+tXZuNmHGqAnnB5VSOxS0qXehIvmnSRr3YOzTUnIdpXJMVQwEl1htkNr10Ll3XMGsP/bTh+HUgKvVGN1CD5iSii+PkbUnjDiw2EwH7JzxVml3t6k339va2bZH+9M0KOtbnti67toYKjrXTkEFR1HuqfUqoRkW4lIFvzuY6qsXOGp6mzKWkDh/hddXrzPUxwvhn0aS7hV6Yso5BcAE4Y7p/Jl249GGdDkXWnnk/3qz3MzlLSh14mGGTACqpx1BC2HfdYN56oysnRXZVUjSTUhUDwan+Zd6ZSDhN71GlISVtiobBb9mXiy4D80O4mfQ247Mty7lMYzHKgrT+dH+9wM64MGUZ1bYzv/SVl5kz6wZELS6QFr53M18o9vHh422j6qGY8EfymORqk2e2G+7NFSeI
 9s8pDEII
 gSCkHlIbuW7+fEkRVZI1Z8PnSrckc9o9lyKo98QNN2Ne7sAi+NARykLvh5lmlwemz5ps7qdFtDkbWSEUjPhGpXmKqKsRmxCUth2LuMN/9620spvfhNCtegQiFQFdtUQZXSqg0u4Iib1kb5z3rNLcz3bnVeEsjH7v6adcAvctYKYkB3nc/gYMg3BqfCNrjtHKwtbrfdZQWv4zJpbS8pPU1LRz1RCMMpC65lw8eqlPcayltEByhT7coeYHtH0GOKmRzQXQvkyp0X6MPZIMbDUoyU5eKRwxivOw30qgnHi5nb9/6QcFRqAJoJ+bamnnlq/IeVyka1MGtV3iaAtMuBibEoHkrEK4xynOFWDZz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Baoquan,

On Thu, Oct 9, 2025 at 12:47=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote:
>
> By the way, Chris worried the plist swap_active_head could be reused by
> the ongoing swap-tier work and suggested to hold off this patchset till
> swap-tier work is clear. Now seems it won't impact swap-tier, I will
> send a v2 against mm-new.

Sorry I haven't made it clear earlier. I withdraw the NACK because
that is my misunderstanding of the code behavior. It does not mean I
clear the swap tiers will not use swap_active_head yet, I actually
haven't done that investigation.

I still suggest deferring this series which deletes the
"swap_active_head". Wait until YoungPark's swap tiers to be sent out
on the list. Let's wait for about 1 month or so, we should have a much
better understanding if the swap tiers series needs to use the
"swap_active_head". We are not in a hurry to remove it, right? The
earliest this can go into the official tree is 6.19 anyway. We still
have some time.

YoungPark, do you know if you want to use "swap_active_head" in your
pending patch series? Even better send your pending RFC patches to the
list and Baoquan can collaborate on it.

Chris

