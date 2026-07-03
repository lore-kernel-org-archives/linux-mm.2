Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C459C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 13:36:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 001FD6B0005; Fri,  3 Jul 2026 09:36:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1BDE6B00B6; Fri,  3 Jul 2026 09:36:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE4606B00B7; Fri,  3 Jul 2026 09:36:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A9C3B6B0005
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:36:07 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2EC1C1A012C
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:36:07 +0000 (UTC)
X-FDA: 84947563974.15.4C54CB9
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0AAB71C0003
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:36:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=AglaEvdD;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783085765;
	b=kAZ0L5oAPQ9JaqsLNbZyXfrA9/HXmrEHZ4Rmzrty0kb9xoY9QFqW6Zob1obLTPko1BFyBl
	XWzd/xBNeZlEuRPuiUzF6bQSTdjFYG1ZehTXcfciflT11INldbAqbGAKCqYB82agjjY0QL
	lwI3ktawNFB+FKvqf0MNhvHvodlw524=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783085765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FNBtslBmkdxYY8pJaB+biO9zOY0LMt3+psd/OnIDrZs=;
	b=epPBVhsbNQJHt3fAH4RXRREWyVmz7zcNwlsRhLMI7/xMnhW96cjGLXFwhy20rgxS4RYvnJ
	VN0jBI7huM06SNHLk+Oehtlt6AGs2kweZOTOYLEkVfVoML/a1wuOT/GCYAl/7vCrfh8rXW
	tLepm5+SQNf2NwzSVsE6Ub6gNNO17t8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=AglaEvdD;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-493c564ed4dso616385e9.3
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 06:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783085763; x=1783690563; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FNBtslBmkdxYY8pJaB+biO9zOY0LMt3+psd/OnIDrZs=;
        b=AglaEvdD15IqfDgegNXrnFZFpWdtM7Ho4se+dWeOeltLCNELDC3pdO9HunsCLoXfDO
         3HnXAAsyuCBgBREbUg5cVtFl3ArOYu75oXKYZNRXN0Di3ZKqaP7zRgW2Mim13rSpgDTa
         Qjb0Pr3nuhavpxHPTOLAgbeCZb0F22LaZ9cmrEQmwVGBfGKzfmqxVgm1RoZpcTHbIRgI
         z5BuLRP9XlhetBR8VGG/u6x1jHH4NYSsseTYbH+NOmu/mDyhI+eXAYS4KnwgScLlTOMo
         ALR8iq7FbtZrp38h5jRZ4S/RrBtOrQyPIEl1EIPCh9JEjsFIagI8r+2iGWADzZqNAGrN
         t/Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783085763; x=1783690563;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FNBtslBmkdxYY8pJaB+biO9zOY0LMt3+psd/OnIDrZs=;
        b=FhIJbOwdZKQiQxToqzbdfQgyf6kBYAiy3bC4JWW0ug73g8Fy5W3pYsdtv7ZoH4SFPR
         4k4IU9+dDy6ocX0slsQtoty0G57WSkeU2ZP5JSjHHbmfVk21Sh7qIU4brzSmjVfa5T85
         Ni9NPzX7WBBcMATMbu8vtxs4wHZXSY+2zMWqVgTcDZq8Ex/LHDSEy21JzKnEYxD8Blio
         cwm3NofiaKW9/sxukdBD5XaV8BcbZLOVle+YdKWfhdiUfTpCpUeWhpz8AiDx17X83NCo
         1ZArJZidZRclAxQtjj4z6daakD1GA4aFqRzYM/nT5X+GKIwoj0xDuj9lhCxhKWg17uod
         Lbgg==
X-Forwarded-Encrypted: i=1; AFNElJ8MevgTSTBFwxzyAmDSQa1Q93ImnDX4P3/SqBQXkJ4stOEGbP6uO2y5tJOAJtwDvyCfuCezuCMdwA==@kvack.org
X-Gm-Message-State: AOJu0YwL5SssHr9TCfN4fJB98bhVxKf2nnyuNGXu/G00eZPvzHL1ZTjR
	0uFpWYyWv6epJ9Cj2sEdvF4tcCQ7VaELM1TEXSmJCu3eE6ku9b2rLQ1r+pL5m6nQK6w=
X-Gm-Gg: AfdE7cnweN6zUVc5fNJ+Q2a4KJIlhmXFSIT5Yu74MICHBBzTK9DeSOk0265tQ4/Lk2f
	vS7eyJs3WmshaOYII86jDmkJpCxePE5tZkW6xfS2vIn0jkuUtFuFtX9fCAhpz9SNk2ue0hASvY3
	HOAY/tkmaY763THXQWq32G6+ReRXwo6dEXEHfir146py45zSncjIqajsbJ13VkLCVFpI4MK0Fdy
	NMPUdwNdaxrBev1G/56hd+bx9CLWXFtTYf9XDXuUzVyktfcNQYfQqxqzjaqqlxWNLKoLRey5zE6
	5LKKKObZcMQ/U0hh5XJjla5Dt0UNM8/Wkug2xcEXoENr8/Q9V0pety4bCuhw88WFkXrqWgJtJna
	mtPXRLT6EuGzYw83hRH+3EE3UsYo9ZFVarjzEixbfI9qyKwh8OLu+dNvdja/6+TsQh7Wb5tGZ63
	IJYS92j1A=
X-Received: by 2002:a05:600c:1912:b0:493:bd67:315 with SMTP id 5b1f17b1804b1-493c2b91fe3mr73724125e9.5.1783085762867;
        Fri, 03 Jul 2026 06:36:02 -0700 (PDT)
Received: from ?IPV6:2001:1a48:8:903::e14? ([2001:1a48:8:903::e14])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493bef11338sm202929555e9.1.2026.07.03.06.36.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2026 06:36:02 -0700 (PDT)
Message-ID: <f0110241-eb12-49f8-81ce-3acf12939f45@suse.com>
Date: Fri, 3 Jul 2026 15:36:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/30] mm: move vma_start_pgoff() into mm.h and clean up
Content-Language: en-US
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>,
 Simon Schuster <schuster.simon@siemens-energy.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Ian Abbott <abbotti@mev.co.uk>,
 H Hartley Sweeten <hsweeten@visionengravers.com>,
 Lucas Stach <l.stach@pengutronix.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>,
 Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 Rob Clark <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov
 <lumag@kernel.org>, Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
 Thierry Reding <thierry.reding@kernel.org>,
 Mikko Perttunen <mperttunen@nvidia.com>,
 Jonathan Hunter <jonathanh@nvidia.com>,
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>,
 Ankit Agrawal <ankita@nvidia.com>, Alex Williamson <alex@shazbot.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Dan Williams <djbw@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, "Liam R . Howlett" <liam@infradead.org>,
 Matthew Wilcox <willy@infradead.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
 SeongJae Park <sj@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
 Hugh Dickins <hughd@google.com>, Mike Rapoport <rppt@kernel.org>,
 Kees Cook <kees@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-parisc@vger.kernel.org, linux-sgx@vger.kernel.org,
 etnaviv@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org,
 linux-tegra@vger.kernel.org, kvm@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org,
 iommu@lists.linux.dev, linux-perf-users@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
 damon@lists.linux.dev, Pedro Falcato <pfalcato@suse.de>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>
References: <cover.1782735110.git.ljs@kernel.org>
 <b28b698df4c009e85c4728446ca5863d8e633164.1782735110.git.ljs@kernel.org>
From: Vlastimil Babka <vbabka@suse.com>
Autocrypt: addr=vbabka@suse.com; keydata=
 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
 pYekxJujNeEDkUlky0Y=
In-Reply-To: <b28b698df4c009e85c4728446ca5863d8e633164.1782735110.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: scrk9e4btykae8bhz9e5izirh6cafn8x
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0AAB71C0003
X-HE-Tag: 1783085764-417503
X-HE-Meta: U2FsdGVkX1+DY9hVSr9xf4cRPMNKLRmI7O4KZ/6GJnZbdaDKjqzXGzSyrFezObhzR0a8Y+iUJCLhcIGKnSsoz9IQiZvj2nmHWp6ytbOKvy0kFFfmPCnIwDQqhtNnx9ApvtMTHZU8IHQZslO1Tbzh6QJZl6L17N+++jkEbgviL/pSTcOuQhV+OkxnxzOt+u82kAwQVJNqFAyZaDVoCVxeK4WJBHdxti/bqtdyO6dlBtjuYHTF5Z/PihmqQhsZwbmn/9aUaiuprsjnbTyR+uoOooku2i3x+6780tIfWQHbepeQklGhztx+0BvXQF9LhBwodCh7w5Olncti/raPeZmJeihaa4U4po7iR3JinKmr4KH6T8g3jM/TlTpaKR4HgLxNKKi2f07Gq2edF8SGaA0bTmqcGNDnEcdZbRR8dKKGdvBkEmxn/hFQQyb/3t6qqJNzC9APiXJ2VsdWdExBUQ9AIB5lhjQevPlzSetukQgR//r0hRnN1uOusShqBnGcwbxY4KLo9KVkAQwL1VczRY7oV/W9N2oWXE6v2V5gq7mfHzle3O1DKvSt2OQP6dpeIhuISjFFa5I3NF3Rfnim90uPrNapgKbdDISvwAff5deXYm6uXJELa1HZ+DMtNHILNkZ3ficNzdd+743ZHZcT754HpRWRboY3tO2diLrqsEWprgYvSsfB+fqMkVVSc4S6cssHFYts387RXsTMlc3exaBK1y8A6mh689Et9/xpkdxJuLQNZfLZPnSjGczn15O/jr1NuTyGMXpBGJVcb2xnH9iAXaf+Dqu0KUEaL15RsQz3Bckjl1kmd1P26NEFjvL/qZuD9Q5PIqZpevZC47OQZ0MYXRLyze4iL0veDySmmbU3eoWDnXAznrxS23nsPlY8XZDUGUegx5dQOHWEeZNfOCMDZUZtKYt+zQAUvMshtsw7Df0WqZdRkrP9eMq/m7epssRPMKECfAXDVCNzIJnGsHm
 qX2MGQ26
 DyRAD5oXPNCTkYxR8qMtyK+fj6+K7GQsu7s3xbNdQn3Z7ROsPraMMrjOmrpxcLo+lytfhfdHM7w9tvvHvZ6fbBS16TlQUChnCQ6NpFdU3GpnTo3WEHXLMup+egIFbxCxmlb/drWZY3d0BNPinyO7gjcV/fNLtrOkikygmjT2di02o3a86Vs0vSJVWEl4gzuW03mKlkS2kcc3nolmlAdoEjXscVk6la4W+rviYirO6l4hc/7B74phrjbWdR2RH+CiAhiugO4UfkjdfzaRR5gJIuoR1i17LM4Xz6gRJleeA1E/z6sUM1B7UmL6GcLQy3dJW27aBjGxCWLsolDGQzmUvE/aBVuqhhEezj0plO5vcaaI3pzKMFZBszOxMyivY/gUfU94u7aoNh/C9f83NXLaZgWLvzdcjPOiH0HPPFv53ohstMciUys1qjFpGJMhuxTnDPwjrnrR7LKLxu95gE17kfht5jzQdXbGyHU8nexjFx4Yn+zNEd+5220ObfIn9DjUVvy/EQUpUNmkS3G+7qdWdxgEkSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 14:23, Lorenzo Stoakes wrote:
> vma_last_pgoff() already lives there, so it's a bit odd to keep
> vma_start_pgoff() in mm/interval_tree.c. Move them together.
> 
> These each return unsigned long, which pgoff_t is typedef'd to. Make this
> consistent and have these functions return pgoff_t instead.
> 
> Additionally, express vma_last_pgoff() in terms of vma_start_pgoff(), since
> we wrap the vma->vm_pgoff access, we may as well use it here.
> 
> Also while we're here, const-ify the VMA and cleanup a bit.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


