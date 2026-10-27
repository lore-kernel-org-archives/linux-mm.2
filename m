Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D51C1606A324
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 18:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jjxHiqsF
Received: by kanga.kvack.org (Postfix)
	id E05B56B088A; Tue, 27 Oct 2026 14:31:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB6ED6B088B; Tue, 27 Oct 2026 14:31:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7F946B088C; Tue, 27 Oct 2026 14:31:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7AAE6B088A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:31:42 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0F07180AB3
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:31:42 +0000 (UTC)
X-FDA: 85369249644.09.186C7B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7E07A40006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:31:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jjxHiqsF;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793125900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zy1XjAvFE8Nfo7sM1UI6Kgc6ORVuqVDmnIjZZndivXA=;
	b=8ZC7g3GmW9GyewZVtbw8+OCTwfpVnL66ijfXmUtqWXUy/ruSTX/xUgmbnVbw5lCVX6W1Mq
	MJdHyI3/Jb0warTTG7tJCLydizbLeu73w/WY/NfJMBFvfdWe1T2uYqZNdm29eQYiF28TcD
	ECXVkiC7OCbPFtmDaB+7MPLW4YxFlD8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793125900;
	b=UKqzqYvppzWiR8rgA89A6GaplorXB9rNlJpBTH1VmEgcK/bbZIFgj1doccUQkCTqHjYik2
	t4+lGW10h18t3/aJZM5WjXQVOFDTC6jNP0Llq0KOqcwxQy0n/KNXi9jlFwv2z/KeBE8faa
	55DDg9HGE+zHrY/lqPporgkSPc76XBc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jjxHiqsF;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A4E760136;
	Tue, 27 Oct 2026 18:31:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475FC1F01825;
	Tue, 27 Oct 2026 18:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793125899;
	bh=Zy1XjAvFE8Nfo7sM1UI6Kgc6ORVuqVDmnIjZZndivXA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jjxHiqsFMUljw0mFy0rB3mF05wn357Z5Avshsq+h6/XJ+4wWpRHRWyb4blIhsmyOa
	 dEjfVWkOOtDn+MAlzmBhiqXt0FR7Tb86gkV3rz6HYv/N9xl5s7FL7x3pZ2gYnFFR6b
	 mQj/RcQBOlggEz0Zfy34bACS6vwVemN8bDvDSmV7pv987yMD47L4Oio9ssZsVtO/Tu
	 ErnOaGJU62MD/T7ZIaOUvVr8vlxFjJCDq5Mxh/bd2y2XzlTd7O1kvt+fme80GsO+ZD
	 o/Qh4uVMfZy6tTb1oGCG8dJewg/YoXn8q4Fg9UVrfKnSoq7V63IBZJFwMENsHqxfSv
	 pvp0q9nw2hWww==
Date: Tue, 27 Oct 2026 18:31:37 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Chris Down <chris@chrisdown.name>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Kees Cook <kees@kernel.org>, Marco Elver <elver@google.com>, 
	GONG Ruiqi <gongruiqi@huaweicloud.com>, Jan Kiszka <jan.kiszka@siemens.com>, 
	Kieran Bingham <kbingham@kernel.org>, Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH 0/8] mm/slab: Support selecting slab hardening features
 at boot
Message-ID: <179312451613.474906.1475329637924619088@kernel.org>
References: <cover.1793086056.git.chris@chrisdown.name>
 <16121542-acd5-4727-b64c-f8d519145b63@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16121542-acd5-4727-b64c-f8d519145b63@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7E07A40006
X-Stat-Signature: a8oef3jtfsurdoebs6wkp64dka3da6ba
X-Rspam-User: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793125900-597123
X-HE-Meta: U2FsdGVkX1+ozVHsTbn8o6dP5XS821o0mGITO20qzrW2EVhpw1gQaOXJVkLkPiExfFbP7G8PLHcWmGH1w9fr+erw2ct2InBJojSWzK9G65ksMSpy1BJ8UX2PGOLTOK4EblQlOWjmNpHx8f7HLRvKXmM9SLFKWI5YXaVYHqSnVgrV5BzrcPQ5Lyl0lyp4po+sl3cwDvrVutnVSaQ4LY5T2R88XpGq/AVdh+V2vQlg1h0mL9LVm7eyJBXqzrJ4B3RPVDeRNGq8qW3xAbwB7I4uXpIhEnKE/munf9/EQrHxu3QzPWUD7YHuI//IqOae1nwW2MFSSBmYWA3W9CtbMnV4TDaxykkIkKOysxDTQyVCLD9owTynPa6mPGexB06fmlJYT10MDvuWMYk0oIyp1l7PMz6r/RXTeQokKgk79z1bOmk2ExgCWVlYflAr5TZQB9HBiecknsmZz/0Q5BX3SFM+CyzpUpLh7mynijIsbNHjPwE4YeB6bj8iwNOq4Sty+xMkvcB6PQuJ6rpHLFN4qRhVxiyHOYdeQ1IXWkis7YjQOrpaZrywNfsZFuQH8d1r0d+DmJS4c8Uu3NujeGpknNbgNAQu8S0Tig1O2n8GjGwBfFs3YOsOOabSWb7P52aNkoKQjI032+/3uLcmZq/EYJkCyzOF42psoBsQjw0wXHxPKHPtLqhG143EvZMH07PmjNfkOMSnhX9Kb6uZiPVqeZW22awlybgduxQXRGovpyvPKASt1p42KnjXSBPOPBFkLtv9Aa4Abh+Y3B0cWfI55oZY5aM+t0PtZ43zsMEmevRKBiijIIxnOkNxKYTu+Nqdh29P59Ier24TwkJbhuZKi8iicfZXlbH/dC+464ZJ4mmZ1HdBUC9y9v7xuwMQQQAlF17u3zL9IGYHE5uMcfSlnh/QbLhLn2i7ome/qP5kcA/iZN2GaHCrV8j5+7pSQNHDiqcPc3eLeoMBC8S8Y8t8JvK
 96GK9Hs3
 B1+t0O5CJ83uIIOPDLWAQaUNmSLz6KPXGyBv1bOEwDPPk1RVlQESoXD62va+C4nC/7JroKFg8TBfZTWEGm5KveIACoqf5UxzGG+0NnjfojXE+IpgO/cBbtunVs7K8qNpTw3tKiV/kmWYQdkL7jSysGqG6eXnumMFfvo3TBh79uF5MUlMZ2q020CK2BGxYyH6YnhWI78FooNurT6qMkHMI2KbRZvzVXXEIafHADU4GHAeKielc4ZcGTuXwr61tr847PqqG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 08:10:40AM +0100, Vlastimil Babka (SUSE) wrote:
> These two should be only a small cpu overhead, which is why distros
> generally enable them [1].

Yeah I'd expect the impact on them to be small enough.

> >   slab_buckets=
> >   kmalloc_partition=
> 
> These are more valid as there's a memory overhead tradeoff.

quickly measuring it on a VM with 64 CPUs and 64 GiB RAM:

w/ partitioned kmalloc: 94.0 MiB (235 kmalloc caches)
w/o partitioned kmalloc: 76.1 MiB (~17.9 MiB diff) (40 kmalloc caches) 

Mostly due to a large number number of under-utilized slabs after boot.
(per memalloc profiling)

slab_buckets had relately smaller impact, about ~1MiB after boot.

(Of course this is just after boot, and actual bloat depends on memory
 usage and fragmentation on production)

-- 
Cheers,
Harry / Hyeonggon

