Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D42B7C83F26
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 04:48:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32E3F6B007B; Fri, 25 Jul 2025 00:48:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DF856B0088; Fri, 25 Jul 2025 00:48:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A6B96B0089; Fri, 25 Jul 2025 00:48:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0836B6B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 00:48:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 807851DB62B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 04:48:04 +0000 (UTC)
X-FDA: 83701554888.05.72D786F
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf06.hostedemail.com (Postfix) with ESMTP id A6BB4180007
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 04:48:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vIakjefP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of hughd@google.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753418882; a=rsa-sha256;
	cv=none;
	b=37yK6EaBGBZx6zb/YxGg5y0eLTloCdd7zJBW3TiXIgZof1trnjq/941ewk7i2X4gBXgaYk
	v9XOE4/mMBub0LiTBK6p6Wq0tYl6hYCSTMavO4AKSgPmcvIK/WEBbqaWKwyOpBeYtbYzZe
	ZFxtib5hHI/vj39SX4/3E9J1WPeOQrU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vIakjefP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of hughd@google.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753418882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xLUVxgiyjA+iB92FNk673g8aOEv0XZnAG+aEo7Rdvdg=;
	b=jCQiXoE8HJh2ONYPwq+vVISnltbMKwa7Qb5vXgQWRkmmgAGD5171M9SP5TkejspS6Duo+4
	eVT+KSpMdZjGEabKpy5pStTzIIO6gdzOVI15OeI/Autq8Pv7+E+fmvELszSoJAYYMk6mNl
	NUljZvRD6mFMHdGonVjBgazS1pSlF0U=
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-711d4689084so17884627b3.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 21:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753418882; x=1754023682; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xLUVxgiyjA+iB92FNk673g8aOEv0XZnAG+aEo7Rdvdg=;
        b=vIakjefPwlbjSF+5OVJQXD9hr3DTPrxO6QwqEafF0BFleqUI2Vh4XxyIKNRnkjq+sy
         vbwHXuFXwGJKTsVqGkWV9/AeT01p/unFyq/8nbCJ6Byp8zOT0U8/tfeBZeONiEMr16Yo
         hsMGRR58tu2QPcq9ObycnqqnckSZuG7/ANU/pEbW1Ko5HsyYtMN3BhA+nzTK6rt3zUjz
         WYICMBsTAR1R+Swm19Zy/dC+ecFnIQAqH8jEVPYkR4PhL0pl6RJ8x7rffYAK7kwLQOZF
         RPlx3Df8zB5/RtFLE8r/xThBujRNoM35z/eUTz5mzEoJk3EM8+/7MxroMDwBtGOwwIq+
         Parw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753418882; x=1754023682;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xLUVxgiyjA+iB92FNk673g8aOEv0XZnAG+aEo7Rdvdg=;
        b=bcB4np3nqIh4T/j6X1YQJQtCbUGsGIFZUaXKiXQPa4MYTYPsEEsIyHEJS8ZwUK1UnK
         7sVvgHExxRkPueoolN4aTvogTpLK1bF57bDzoB5S+lkqDkFF4/IvusZ6Chlxa4bK+q1G
         TZmP5ZdyPRZJXLOM3FbuUahPW88zzJAmibrpbC6KZ4q+yNOpQFdS7MiU4JA+xJvaN1aW
         EG8Dg+MkgqKmps90u6Evw2fua52f4R5muGFsviITdMZkT1rbhidyDFTueKqI95BXMuG2
         mnytVyXMJpICtBsRiH+5wtzgNjmWtntnJGW2Ms/8cqBs8qJyjTp3ErT/HoTAJWVp2akE
         kRIg==
X-Forwarded-Encrypted: i=1; AJvYcCVcDdoqvXkJeD8x8IcDmSFqKFIDAzbHoObA7bkbHCp/xNqSgEZXGY0Mu2QTnu2G7Wy8evCAls7dhw==@kvack.org
X-Gm-Message-State: AOJu0Yy4BhqiRVg2dtj2VDvleAjrf9o0Y5fHGDzrshfgxAKQVF2X41fP
	fGer/xl9V9uLPQdtVKxxw5odsmTCWRxO1l46i+8rIEpe4/Gm7crkonQ47Epl+8kfEQ==
X-Gm-Gg: ASbGncsR4B2/FlFzs6qFf3hveMXgVeCSN60AluuJdPbjLsgXyuiNMa5FNW9wH8H3eN9
	3vs1XK7bfd0+dxM+OyxJ+Gg4gspNAvAerteTvC1cCAhczgzzmM9/KXTAo65amgu/PBGsu9WHJU+
	yW3MxU/+CPBmqYF5bX7Vll6jOb7gtZB2rMADjBgiEiICy50DY3J9AJ+zTkTtPcWW+FOmzG9bt6g
	rCyeB+fdwBsEiOm9eI7YbL2TrDDFZA1NUkOV/nUoyTbxZtfcV8TvFs8Gt79oXVIYS5EdQZIbi4M
	Ln0odfQHbigbyJ0F2FpGpibcNluddaAv5jsw3U0DfjBElI3KHjWZUg8qSmqy4ZHKQKIxnkO4ARF
	sUPm9FVbKjdXwoCJ4tstWchb77pJ35Z/MOi5vp2KS8w/8MuGMFsU3xS4d6DHBLM5r4a4tOPEtKw
	7IFEPUD1kbJwjHGVEMhQ==
X-Google-Smtp-Source: AGHT+IEWT3yEd8ZUhvbio3ChJ2D9iGiW5ZJrqrQMLSto8eOpGuD3KY3f6gSI0Np9ZzL2+8KHxLhtqg==
X-Received: by 2002:a05:690c:6384:b0:712:de91:53d4 with SMTP id 00721157ae682-719e343946dmr7128997b3.24.1753418881443;
        Thu, 24 Jul 2025 21:48:01 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719cb9aebddsm7110287b3.91.2025.07.24.21.47.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 21:48:00 -0700 (PDT)
Date: Thu, 24 Jul 2025 21:47:48 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
cc: David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>, 
    Patryk Kowalczyk <patryk@kowalczyk.ws>, da.gomez@samsung.com, 
    baohua@kernel.org, wangkefeng.wang@huawei.com, ioworker0@gmail.com, 
    willy@infradead.org, ryan.roberts@arm.com, akpm@linux-foundation.org, 
    eero.t.tamminen@intel.com, 
    =?UTF-8?Q?Ville_Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>, 
    "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: regression - mm: shmem: add large folio support for tmpfs affect
 GPU performance.
In-Reply-To: <da2ab844-98c9-4eb2-82ac-01d01bec30f3@linux.alibaba.com>
Message-ID: <dab283bf-a9cf-30be-02ed-da0d7c8ffcf0@google.com>
References: <CAJCW39JCDX6_S2Ojt1HMmX-h_qAKm2eBRzxX5kOHNJz60Zu=vw@mail.gmail.com> <d5c6ac93-1af0-4093-afea-94a29a387903@redhat.com> <63b69425-2fd1-2c77-06d6-e7ea25c92f34@google.com> <3f204974-26c8-4d5f-b7ae-4052cbfdf4ac@redhat.com>
 <a8ac7ec3-4cb3-4dd8-8d02-ede6905f322e@linux.alibaba.com> <da2ab844-98c9-4eb2-82ac-01d01bec30f3@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: A6BB4180007
X-Stat-Signature: 6g17s7ghgnrip4uxj9gebenp5s84hkq1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753418882-458432
X-HE-Meta: U2FsdGVkX1/vB2zy6pmw/je39PS42X+XUHFk+s9qIUawyeu/iY2T2aE5uBVG7Xkz55c3UOW8WPQ/tGcP4i7JohQUlXMatQMw6XU4FAGJwcOsbOBgQC8fq1m2Lt76HwNJYQ3C+EBE1VJDgVGUt4rEZwVuZbhYAKbAmIOVUCLjEDQ6k0Utq5BTm28D7rF/vQ/Qa6QjI5FiYP3CMmAGZmILHybvZkYu/m1rHl5SIzrgHMEzoCn+1JAndkolZrnYw6K8kPciQzXEK03wVJeN8vp2TkiRPTjZ5FUHoPWfRO8RHrsEdZ2/ucpgsVzlmogSwE5HzcoLIv59iL+0L8UJhMeyChCYzysSWhYFOP66tbeqdOufessCh8WQTXU89dHcqe8q1n2voIygkdr2AGngHJLgBiIRjENCiiSr0fJrsTFo25fdOgJm8A8rqipssImjj2d81sxFDTzbJSBRBrv76pv54IUkcYV8NoJzGoqHtM4a9fGiMcSJRzfrEpig/89dR2at0ymWXUIcI9wDHlXjUGTK80f65dIwzD/CSSDtkosnDuT/t0skkV4Z7ADQGxxN1BBKt3kxJ51NWMvetbYJpoAwGMG5fZ9rV6qtW2ur070BYrmmUU2iiSr7/SBts5tB17r2qB5hUBry7smjBCEk3psKyD+6bAm1lXGYjGWJpbxelGI3a1XzsqzrDSg0PfI9pcr8Zchl19OzKjgxxXY83fhudh+T4fM5GmpK7JgTi+qfix2M5oejkOgHh9cTyy+yhOJlAiG5uRa0lEjkNN5WOhDvwAo358bRmVoZse6MdM4u3jid8OIs/Kge3He4lPXzBE2Gv+MDLwBiOnli+1fe2Kuaxg2eE4OsGWEZ4b/UV5ycJzTPoenO3G7WPHq4HpmE4OKxXPqnu4bXOUu2l/be6lcq8AETp5N0COWoweB8cfqJKXsSLEANQp9CgT9hq00NelMSdP8pYdcZ6lFngWG5jcF
 dm6nGZW1
 DlP9X966sgyhYdVFhtrgTkJCN+kfufHbfstvKJRbcRvPRetzICii+C8TWDgAlrfOUXt4H4dFX7X+wnwfAjlrNZLFOZGCo0AWwdD8y8AwTbpIoFIwX5rEvldPQ4NaIDdS8qVHaHcN6oEbPssXfnKzGc3UcESGMZrXgJnmJDWosXJiBb478waWDxeULmwnqAMI4wAp/nqujdlQAM13ORsjx0iE5Y1pIrzX8X6n5onNoGLxcdDr3jbyY8IWBp+padGWFKWasnkKzOAPm+Ay32TuH6ONSy4Qzfryjal9PvKf6sN8WfYelXh5xsmfnYrI28QrPPv7fc+QOJRfYJ/H/MPAoo6bo9vGmrDJ/zRn54/S8HJdWJj31IXQFrEB7e0vJGqv9TUM/mKQNrA/4g4iCpPWYOGgwkg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 25 Jul 2025, Baolin Wang wrote:
> > 
> > I hope to correct the logic of i915 driver's shmem allocation, by extending
> > the shmem write length in the i915 driver to allocate PMD- sized THPs. IIUC,
> > some sample fix code is as follows (untested). Patryk, could you help test
> > it to see if this resolves your issue? Thanks.

This patch cannot be the right fix.  It may be a very sensible workaround
for some in-kernel drivers (I've not looked or tried); but unless I
misunderstand, it does nothing to restore userspace behaviour on a
huge=always tmpfs.

Please reread my comment earlier in the thread, in particular,
Passing a new SIGBUS xfstest does not excuse a regression: strict PAGE_SIZE
SIGBUS behaviour is fine for the newly-featured mTHPs or large folios,
but not for the long-established huge=always.

Thanks,
Hugh

