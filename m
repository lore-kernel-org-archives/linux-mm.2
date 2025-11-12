Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 959C8CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 07:55:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E24ED8E0016; Wed, 12 Nov 2025 02:55:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFC7E8E0002; Wed, 12 Nov 2025 02:55:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D398D8E0016; Wed, 12 Nov 2025 02:55:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C2B828E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:55:40 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7327412D8C6
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 07:55:40 +0000 (UTC)
X-FDA: 84101195640.20.DECF3D5
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf11.hostedemail.com (Postfix) with ESMTP id CCD214000A
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 07:55:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=K53I0qRQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of hughd@google.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762934138; a=rsa-sha256;
	cv=none;
	b=SiXZWoRhgAXNovBklFSNpOE48gu4nzoSpF9vNLyJWQQuwjTc60sYPjAbQXPiH5WO3ATtHE
	f08O9FfuK2sXUExwIZNTiZvjBP2sxQelIRfQVtG5XMwYDJ1fhlvkzcQdajECaba15s5xSb
	1ID1sy2c4pfWSAD9FFMNd9Z23sPwRQM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=K53I0qRQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of hughd@google.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762934138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sl7gNLb9e1XNfHZ1ke1YgjbEDtdx1ds8TquivJFZA5A=;
	b=op5LroRT8IBRyy7YxsTwUog7a3e3ABtw3Qp6KJP0WmPSSsBphrVkjr4nTjzV4ZP+Oxme+4
	cTSfAA4OKzqwkyp6/YM6VQemGNoEzT71Q2NQuL9RrYOZ7oIFHBp6yDJe6fQ97bAvNzMaC3
	1sRdXDPoKVaDQkrNGOYJR2YHS3o/rlI=
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-787eb2d8663so6864637b3.0
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 23:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762934138; x=1763538938; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Sl7gNLb9e1XNfHZ1ke1YgjbEDtdx1ds8TquivJFZA5A=;
        b=K53I0qRQcOYgXR1Dm77ksWtxDtbLMLNOxBn11iWb68gmhapIJtHsjTu0/tx/hr4f3/
         l09wH/vSBw+BSwz1yrJUlIixuYP7zn8iJs5fOOnc9kdjtGJ1oXPqxvYhV/j1qsRaWx8b
         Mm5dJxLHHRFwJ47KoeBOWLhl0UrpLIYaPwQBh4CrSHprhLBqwV0E97XZMwZHhBsD3DiS
         L4SFxxnvW6L4pZvqpq1m0oQS5qrBd6HDbzk6fDdjhK0qR2h0PrYqnE4nDqq1DWPUv7+7
         DLNhbJt3IuLIWBMG1+Q3eD3+HHm/teCtJornWIOTH9+HFvj0Wd6/cZiLQo3wTo22EzPP
         XrAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762934138; x=1763538938;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sl7gNLb9e1XNfHZ1ke1YgjbEDtdx1ds8TquivJFZA5A=;
        b=iW+ACRkziiZvapOzg7Iw/Qf9weUwmALD3XJaN170HpW2JbrUaIv1G7SPVbhYxYMYRg
         s1mxRLhuWFJO4ZzCOmD/gIsKz6XC7rGe94Ehb1fdWby0E4eoY9sACWmXNeUsPNPxQOOe
         MocLevRVR74Dn11C+1bGhY4Fy7I+Wva1dIUVlOmSfUo4q5ExoiFv7L0G+fz2xK8ouOLU
         1i9+mTAizpwypjzu7DpN3iue6aCNV/9YDoO1XWoajZsJOkGf19reP/lM19b68MbUJ+J7
         3ETNhfckpdWyihC9cpGKVO9+Fhvd5lvAISrC8c43I1ZBWq0OE+IdMfyVQqQ720gKaJ+6
         iZSA==
X-Forwarded-Encrypted: i=1; AJvYcCUatLQFAixuj/r2gnpNH/OfBfV5olYeMxDynNAlGa4IuaPeHwSo9GB+cUJzbezfg4kHf/00fQcMLg==@kvack.org
X-Gm-Message-State: AOJu0YyGKpDnYfdeAZ5QKAQOEYGSVmzGhWnSmT6lFGu/cbN8g4tKtr6C
	pbKgoj1f9y2DOQFTBi/7W24YmOrewRmBUE+7VqxDyQTb6erEsoCcb4EVCIurTbl/Jw==
X-Gm-Gg: ASbGncsr2ZIPnScfsP+0zIw3hcMlAYnMCFiwzS8Kvvliq84jmpJ5w9I9PqrBBND4g65
	cqKxkoYyZLaXy1HxQNMNqoSukjzv5rV7rS0TfmLCoxM5JtfYWDghNLPtlJypqTRtcoUvn5rWhcw
	sJIDTqcGR/k88GVFmbb2bNlciUzxSxccSEa+weBPwqtTpsuo7XbtIdDdUjejIGFoj1eCSXnPhxI
	IYvf148sPt2WhUsk4fYbgoHvvA9GxN/fnYCvwqd7XdGHgqWruxYj+r4oKqh7RGHIFj5K+TIM6qV
	H4xU8DyDAsTvcnnKo/2nbSZLyg8UCnJRdU7b+rTLFh3nF38NJDiDSZkW4v+3E+meciJMvcACueF
	1Qf/rjFYBzKIelZ50T+k6AD0MoaegPe8I2+kfTJIETZMq1AL1FDwUlejPsNYwVxuY34fmcxxGR7
	5vAAgT4EMiyIdmA1ZLeOwrXnZxk03fYBgMws7qJhQ3kSevZKlhgc1YzhoImKE9ByDYSVpfG/CwS
	Bla/UltVw==
X-Google-Smtp-Source: AGHT+IGjXmFCn3shGcJBm4bkU5Nd/oIYOdwifgyIyaTbMQ+yB+EiuQ//lL4hWR3mfTV88/f2KB3tsA==
X-Received: by 2002:a05:690c:6c03:b0:787:c44d:4b39 with SMTP id 00721157ae682-78812f5873fmr19686587b3.4.1762934137651;
        Tue, 11 Nov 2025 23:55:37 -0800 (PST)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-787d687e26esm39783697b3.27.2025.11.11.23.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 23:55:36 -0800 (PST)
Date: Tue, 11 Nov 2025 23:55:17 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
To: Deepanshu Kartikey <kartikey406@gmail.com>
cc: Hugh Dickins <hughd@google.com>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@redhat.com>, 
    Vivek Kasireddy <vivek.kasireddy@intel.com>, baolin.wang@linux.alibaba.com, 
    akpm@linux-foundation.org, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org, 
    syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/memfd: clear hugetlb pages on allocation
In-Reply-To: <CADhLXY4qMvBTqirNmzgiPszn8vCkCFV6GGeDkNpxVDi32uhzEw@mail.gmail.com>
Message-ID: <a6d0156b-5f65-9426-f27f-8a1af59bffa0@google.com>
References: <20251112031631.2315651-1-kartikey406@gmail.com> <2a10f8c9-dbdf-7bac-b387-e134890983df@google.com> <CADhLXY4qMvBTqirNmzgiPszn8vCkCFV6GGeDkNpxVDi32uhzEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CCD214000A
X-Stat-Signature: 5cgdqcadfqotsxoocnzko7bnp3h3oq93
X-HE-Tag: 1762934138-602316
X-HE-Meta: U2FsdGVkX1/hLYEw2i8ZQDXJNLOjS8BYl8wEQaqD+egxGzJmGTMSkpJC+2+InUQAzHHFqx+MEuicwKF/Eyb3VuZ7d4UVbf7oSsW/S9/iOft5uVsfkOz97Pl25zulDsQObrO1YTqZXmIUuI7SKVfPNx22wum+syKllhFT9fkO+Blzuh6fLjr8mPfRQ50Zv1x+MNlqBSK5upnIHZwjIAFt7JBI2zWsgo7ne5hqt48eHYqjZ2Xs2vvg/oSsDP1x+TibrpYxYAU5J3Gy8/ZWpdbtgDg8ewiRVR+K3IKdAhrPY4Yo9aAM4Xhbjzw+jb9FEmGCr3twRIMiYk2Y5/4g/6k2sXySiM17Zxo9UJqidEZNKWrdKWGc1nnYyqAkM4c2ie0Aj3b7ICLz9wTcdcsj46uCUGOvXiDgdNFXWQQzGj3WkrZqCf6VVoAI96oFicY/Q/bwGvrbde5uobRS2y7zD6M3/5B0hAhQI2h4csGEI7L4ZqxkO4zppddU9QlTPR+eanJZZBLIiCf+2+W2S8rmheNklmPoyEjfKprx+c5roCfIbB8NJURwycCWfbJfA1vbZ09n1rnddA8KJu4G4oBLNBgL/v1D2xuHgCBT6f3ew+tLzzsotjheGeYO+9q0DAVCpwo6sby8/clJzRzebxbP1L/FFqe5bfjfMaJynQ3xhWOhuFFw83d+QZQmTSdraea6T1C9p0/YCetI5DH35khmRMLgwaexPvqYM9bDdrIXHcILEDBUioODKD59p5K1//PHWNnayRAwcQEwk52lotlvhBrej8359gHJQSyq5+xQCg8SRxYeBzmc7blXuGxSQFl6tiX6Ii/NbBqAWQrD4nrRQsZS60h5Phk9BZK+qjNJ5a3XpiL6h81PDtTEeub/+m8vSWE+W8Qd7J0gMqw4xuEZrXadDw2SAsQMcPLAhJzWT64vJt+BCU1l1aaNTRaVp2u2Lmsy46sUzJ8Dnl6CU6lRP3o
 CnKICo8c
 X/bAVlDKMYcmPd241wiMfpJggOdz2YtAe7RTSl68nZbxjaP1c5TSGlyQ39R7zqROtvmm/0/DMSzR1qd7d9gM+yPA13efxSYqIi8s9JvvGcugC3v+/IGxXTJJCqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 12 Nov 2025, Deepanshu Kartikey wrote:

> Hi Hugh,
> 
> Thank you for the quick review and for looping in the hugetlb maintainers!
> 
> You raise good points about the approach. I chose explicit zeroing in
> memfd_alloc_folio() because hugetlb_reserve_pages() can allocate pages
> without seeing the __GFP_ZERO flag, but I'm happy to revise if the
> hugetlb maintainers prefer a different approach.
> 
> I'll add the Fixes: 89c1905d9c14 tag and Cc: stable in v2.
> 
> Should I send v2 now with just the tag added, or wait for feedback from
> Muchun/Oscar/David on the overall approach first?

No need for a v2 at this stage - Andrew is very much more than capable
of adding in that Fixes tag and Cc stable if he's inclined to grab your
patch for mm.git in the interim, but let's wait to hear from hugetlb
folks before finalizing (I expect they'll say __GFP_ZERO is no good).

Hugh

