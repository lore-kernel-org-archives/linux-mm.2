Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF558CCF2CF
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 13:58:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B97076B0088; Sun, 18 Oct 2026 09:58:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B47916B008C; Sun, 18 Oct 2026 09:58:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A35476B0092; Sun, 18 Oct 2026 09:58:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 672426B0088
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 09:58:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C7C40120533
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 13:58:28 +0000 (UTC)
X-FDA: 85335901896.24.4ED08AC
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0CCCF100007
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 13:58:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Vad0u5xX;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792331907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ayMWfGshO3UNwVYFCcSN2BNh422miW8cad5xrtcnUvg=;
	b=rIfatrUt/cDIsNf2pY/cnTQM0u2ks2665+M2ROWJx+Pj8xCoazEMouN68YM8bXmjmP8po5
	0fS1ncjS2GbTvkCC2x4fJoFoqM0vsc3jqSHffSAwewtrTPjiXm1zxe17gAAgEitKlmPoUl
	xT6fXRkxMZDfTOWuLO8lubG6qgz0Za0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792331907;
	b=wECwVhORBUwd/Fh0YfskaCYiCmKOdHG3c5vo3Uyj6cbInXmva7eVWG/smLe1V6R8DXucdV
	NwpXcIbw2NWSJvSK2B0dCVzg65O0AGuGAGSS9mibpNiYJE8TB4GL3sYqqVhAPe4Cqmh+r+
	AohsjGqhsEhbDTHhby/hxFg2OkYO+6I=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Vad0u5xX;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-7cc0892f92cso301114137.3
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 06:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792331906; x=1792936706; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ayMWfGshO3UNwVYFCcSN2BNh422miW8cad5xrtcnUvg=;
        b=Vad0u5xX6JCEbh4FH9/L9KrQ7AbZYTZ5Lfzz/U/eEi0b/qSq+I9JcFB+5t5qKHDL2K
         iT+s7g2z+Tb/caLikYWCiUlESiRLy99Ia9m+8mWpOJKWhgH3TMT+aYPbTeA9fQwXoWaP
         UIMWRwvNFMuQ929JDNGQUPFP4QobOw5xC0nPG9qZOUQK0xeDBNS1aB1RGy0uCKVwfthy
         L51SOz+ZCJDk8WVIf8ZRX9BGcWvYPm95DKOCAIegroyCIkRZwJAcmy9US0afeSwNK2/F
         k7Q7DoBvz98umiTUU/6Qay4T+DUlTTZvdMff+7Fxi+hwqR5onI+yprbQNeOrs4PxYSYq
         fagw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792331906; x=1792936706;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ayMWfGshO3UNwVYFCcSN2BNh422miW8cad5xrtcnUvg=;
        b=Imqv6tC5946eIY9Nk0cSGAW8t5bTF8iqyMY5flfgQmubg2+tYVHTjOfzYgBVvkZ07s
         aLFdKRHaGUlxYqgoWh8orjxnKuUc/5aPTGy1sB9RiJdHLmaCxp0gk9jDVXZCBEGg0gM1
         aCS6puElgVDfTKgPcr1c+e8g8OWzwnVC0LxwnaRSCRiMSqsWPa4zl/GdBN+O0aXJ3+pM
         +SqGGH4Yc+wg47nJWgNPwpNIf0Ds+I0rL2JeEgUSTlAWli3E7q25njbGJqmRsIVYTb+H
         ZdvpNG6FoZ5YX2J6cYXsJsorY7lorG0SbZHnUJX2SYSDTT/dhh4bhc9N64DLeOEtAh6w
         bRFg==
X-Forwarded-Encrypted: i=1; AKwUvBwY4nhUvmXV0wk5xMcm6U1KLHjDW5Jo/8ZcPi+V1fzudP4qs6vQY/Urba6lrYjIpjKKworQrzf+Mg==@kvack.org
X-Gm-Message-State: AFq9FYKbZNOESZe+VawpMKQ8Chi2c8d+PQqJHszCMrZfP+LsLWDpRuZ9
	uSKXBN7kTw2x0VXQ0OimByUnU8QMt0TA9IHMAbiwzilZZfZdvoRrXZDfxxHfx+6TjMQ=
X-Gm-Gg: AYBFou2FrTEWUmlgU2xQY/6qSnLktPzL2mKYPZbqM48hbenKDtvErw+EUOedHBC9pOP
	uib+/qsHUXy12sptg+yeVTx9UK9Y6ghydeW951j4OtIGC4jDu34NAme2ya33V9S+MxRo+ujPAiA
	9YcWYOMvhK4pdkCcI/B1eGdt5rxvSqXzPlmYv/9//jFuaNmCmxWn3K1+Aho0djIF1tayJ9SY0qm
	h99jLCGNZtZNeA3rBvMQD4yf9n20gjMd6ME1KkK6JxPRikr4hvK2D0jj9qgZGkGAZkDNWdmOO/G
	82hOQw4hVv+qBNO9MPJ1gWh9zaTq4eAypN5XGcqMP/ope2mrTBrl7RkvlOlU39e0chlRFjhp7sA
	Nvxm6NZdWG30JGAbqFQo+mml6DQzS28jl6HtQkFMFzT/PEEdffPZZlha1x1ktU1QBJlMMJUgKs2
	86oCmSSAQL4zwvnvXMfxw7pjrfLv+CFsvh+kGmVrl910//tEY8BRH82Fov1jYrfW49QhjW1zSEy
	GkUuz/p97m3/3GCu7Hc5yO0Dw8oYCNIgZh9D/xJLC9XJG047wfX1ODWRmTujie4hgZsFhtayRQ=
X-Received: by 2002:a05:6102:5809:b0:7a7:19aa:f0d4 with SMTP id ada2fe7eead31-7cc36af7150mr1191922137.33.1792331906038;
        Sun, 18 Oct 2026 06:58:26 -0700 (PDT)
Received: from google.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-9908366328dsm6405154241.12.2026.10.18.06.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 06:58:25 -0700 (PDT)
Date: Sun, 18 Oct 2026 09:58:24 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, kees@kernel.org,
	rppt@kernel.org, juri.lelli@redhat.com, nik.borisov@suse.com,
	tglx@kernel.org, vschneid@redhat.com, kprateek.nayak@amd.com,
	vincent.guittot@linaro.org, bp@alien8.de, thorsten.blum@linux.dev,
	cgroups@vger.kernel.org, david@kernel.org, mingo@redhat.com,
	akpm@linux-foundation.org, linux-mm@kvack.org, seanjc@google.com,
	ljs@kernel.org, zhangguopeng@kylinos.cn, dietmar.eggemann@arm.com,
	mhocko@suse.com, vinicius.gomes@intel.com, tj@kernel.org,
	vbabka@kernel.org, linux-kernel@vger.kernel.org,
	peterz@infradead.org, surenb@google.com, hpa@zytor.com,
	x86@kernel.org, dmatlack@google.com, tim.c.chen@linux.intel.com,
	kexec@lists.infradead.org, pratyush@kernel.org,
	dave.hansen@linux.intel.com, rostedt@goodmis.org,
	gmonaco@redhat.com, jgross@suse.com, mgorman@suse.de,
	graf@amazon.com, linux-edac@vger.kernel.org, liam@infradead.org,
	ridong.chen@linux.dev, longman@redhat.com, bsegall@google.com
Subject: Re: [PATCH v1 0/8] x86, sched, mm: Speed up CPU hotplug on large
 systems
Message-ID: <atTQgM72TWSFZ0AX@google.com>
References: <20261015153331.1872641-1-pasha.tatashin@soleen.com>
 <atFGxagFo50iG6IS@agluck-desk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atFGxagFo50iG6IS@agluck-desk3>
X-Rspam-User: 
X-Rspamd-Queue-Id: 0CCCF100007
X-Rspamd-Server: rspam08
X-Stat-Signature: d8owdqubaz4j1mi4zxqekf8ahhtrpg8h
X-HE-Tag: 1792331906-39772
X-HE-Meta: U2FsdGVkX181+lwik52wYoHSk4WgYeUL4pkFxFixjxkTQYMtFxTGDLVUXPPmybRbQnHOgCbLJYi6vbUMTZXM6Qe9Co4pOf7CLFaOP/uUe7dgYZ3EbMesompQ4c4+OYcQvM1LHOayiQUBRsnmZofX2xsrXppsaydlEoNssgQpZfdLfXYwKkoQ/MaoxMFWtQ6S0doGYLnOISFO7nzo8dfzWN7z7gHg9YjBRCSMMTMvLFIPSMIcigJUJlYRQphtH+0zn7X5+WmSDYVdieOVRMYwedFQg6F57FV5NDeUDgxQHeg/AknZOksQv3BDKuFtf/Rduoqx+PgGmJPZ1IQ8Xp+ZWxlkxR8IkTvGCmMsctkNVpklP/2ec5m2g11gLeYmgLQ01fqV80hOZbjnLPqtysTST2vLGHtdL29U7rgvvs2ri3w4gT9M68lowoq4IEiGa2vpOfmz/5q6H2qvAFJWPZ0u4pbUaFs37zRVSLS6mG86vCjrNulxmRIfHdWaEhSNRCnLdfuRSWpuQLQkh7LC0TgJp9snxCs5a0lMNcP5KhDNcb5QfATIAECE6uFM46UjXEO+W8iPcZHNCd41rAlSU8cMzpeUGG0oXnnJgGd5OBkIxMFry7wukPqMs799S9qjj9cwMH1s6qaUgG2mUaQKzBOUI2OC7Ie+fAsCQSO1tJzj49pyGThFK/OMgbFehEWUPWHilRCefR9O5rFysyQ/nHMK/717oku9m3wrYIQyzuSIjw0Lbd3kmjmseIcxsAWjcxuvqZhBHmKbbXA1hPqYpEq6kNHXYR3IFCCPW59fLnu+YDYBWwN7pDE2uZLDilHN0LbprGZkLNwhfna2N0/y2gRvh/CUNowJcgwlU31sbGZ1mTLqMmszWdDhCV67dtyzaqTNFmzO+9UtYaQay20MefVsSQuZdJqJOqvh46pstEe1+heiJTYClsQYQw9NRkkhZYiQsDKg4jRvz4Ux4EMN/JM
 w0L+A7lK
 Q3fC9j3HXsmHNX/Ed9NGQLRTa37KtOhbbNY8QUpZXYt0Jeb3qNRV9bLmgDm4dGvdvrD32/spnrQi+Dsa75Xjev3/z8HkRkztKkieHMl0loDwNnORDaeNepfON/iHqZunrIrhY4zYZABnqsXWRAamy+4hpaUiTLfLwYlHkxioBfz7ixjDPXo5g2EpKXA2JgIGZogN8MwbzzlTX9fIU78cZ6TeLvZrBMU4UXmH4Anh1tNlEC2J7FiONObgTt/HAzmD+BD2S1YgoBsZ0QqTSLLjy/1Pz9WNvyseC0UktWWC3IkaiEBKLSoQdG2oJUwcBlWLXgptutLyMZIcKrMsAOSldVFKF0MuKLn59Td0/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10-15 14:33, Luck, Tony wrote:
> On Thu, Oct 15, 2026 at 11:33:23AM -0400, Pasha Tatashin wrote:
> >    - Patch 3 bounds cmci_rediscover() on CPU teardown. Currently,
> >      cmci_rediscover() broadcasts an IPI via on_each_cpu() to all online
> >      CPUs, serializing them on cmci_discover_lock while reading up to 32
> >      MCA MSRs. Because any disabled MCA bank is shared at most with an
> >      SMT sibling, L2 cluster peer, or die/package peer, probing a single
> >      online topology peer via smp_call_function_single() (or returning
> >      immediately when no shared banks were orphaned) reduces 479-CPU
> >      offline time on Intel from 11.42 s to 9.63 s (-15.7%) and total time
> >      from 22.50 s to 20.74 s (-7.8%).
> 
> I took this series for a spin on a timy 2-socket Icelake (36 cores, 72
> threads per socket). My test was to just offfline/online the 72 logical
> CPUs on socket 1, and I saw some good speedups:
> 
> 	offline: 4.833s -> 3.17s
> 	online: 6.157s -> 3.796s
> 
> I noticed that your cmci_rediscover() improvements mean even better
> offline performance if you work from high to low CPU numbers as the
> shared banks are assigned to the lowest numbered CPU within the sharing
> topology domain. So working from high to low avoids creating as many
> orphan banks that then need to find new owners.
> 
> 	reverse order offline: 2.984s
> 
> I haven't looked into the code yet. But the general direction seems
> good.

Thank you for the data, and your point about the ordering is spot on. 
However, once single-thread performance is adequate, my end goal is to 
parallelize the operation so the number of CPUs won't significantly 
affect the total time it takes to remove them and add them back to the 
scheduler. This is crucial for the live update work, as transferring CPUs 
to Caretaker is part of the brownout, and in some configurations, the 
blackout of the live update process.

Pasha

> 
> -Tony

