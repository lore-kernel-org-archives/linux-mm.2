Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E06AE9B258
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 13:21:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18A386B0088; Tue, 24 Feb 2026 08:21:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10E416B0089; Tue, 24 Feb 2026 08:21:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F317D6B008A; Tue, 24 Feb 2026 08:21:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC50A6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:21:37 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7E9D81B484C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 13:21:37 +0000 (UTC)
X-FDA: 84479412234.03.437E232
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id BF76D4000D
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 13:21:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bctsJnyy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771939295; a=rsa-sha256;
	cv=none;
	b=UGOyURJkw2b8pfuj8/5qC8oXd8wyyKrYbfLCwO8v26mEK9I65XpEvxY2spT6pzu6ubpRzZ
	e14QMyMhiEB1+a0wXw3OpDYwC1l3HqHBXKSagiAadGmIPXTuMtsWZV562JR5+dtiQS5OGW
	h1sboSl6w8Xja2Os3nx3359HCMz/MPo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bctsJnyy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771939295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8xYym5AGEAwFxZSBKb+Ypj+3/D0iUuZi+apmqwCQTJs=;
	b=X0yyfAXTt/VS1KwgeUrshlQyV4rdW+jhMOMBq87llrGbGI0TcKTNAb8RLHvKqEbUWjb0NR
	5SIvssHk9Zkve+REFeGHIXYaBjEd6veO6pcbrhvg3G4U75Y5DurIR3GotI+mbs+3ofCtDG
	FtmvhZjRxDgnKKn1T4WWlawuP1zMiUc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D8FB061335;
	Tue, 24 Feb 2026 13:21:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3CFBC116D0;
	Tue, 24 Feb 2026 13:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771939294;
	bh=X5lX3knKyo5M4XUmowZbt7UXczBV7awEnAyq21gL2Sc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bctsJnyyVx0cPlaGpbetUsIn8lovH8Zuaa4PovF6gxCzht/LMZmfR3rORBrj9DcZu
	 GDRR+bVTFabEnynPE6Xp7Vewg52oQz4Yj1zcMwi7zdewVCv/RdlSMf8Osk4wgqurf2
	 xrN9WAyiRjwSUbGMYU/KrBUUIMKFdzV2dmDZOq0BZNLY0DFeOB4HuLIv03cSFMfG9D
	 UbqyCFr3UtORFaNtD/lZB3820tehoVQGRD1MOSGPpy0V6Ho5ZcSe/AKC8NXhItUynq
	 8DYoYGuCuiOfqufxNVDJXrR/2P4mxi/BN/Epzcyas7oTUBcV/voQTrzNl8Ed6XdtPH
	 ZC2HK4MWtnYhg==
Message-ID: <2553a75a-6dc8-4295-96b3-58367879751c@kernel.org>
Date: Tue, 24 Feb 2026 14:21:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fork: zero vmap stack using clear_pages() instead of
 memset()
To: Linus Walleij <linusw@kernel.org>, Kees Cook <kees@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, Mateusz Guzik <mjguzik@gmail.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>
References: <20260224-mm-fork-clear-pages-v1-1-184c65a72d49@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260224-mm-fork-clear-pages-v1-1-184c65a72d49@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: oaji8i8fgg8qayubf8dmazxumsmpacy7
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BF76D4000D
X-HE-Tag: 1771939295-908369
X-HE-Meta: U2FsdGVkX19gXIXnIEE9udl2kNcH4bI8CPf3jiDZzi3GQRUKKtqkkdrQgfytOx7tA1gFGpC9Ec/mDEf8g4yA65myJ5ID4erKIB2LW46j5DD563GaOGMwzSvkCqhbb386j+BldY9VKAjV3Wi8XJCfk3GpfgsMuZ6us67b1p0ViuE/Z2YfMhiYzTdqUL8BmsABdD9M9jVuLhzFdR2Y0XbkIBknfCajYle3YcJv5bJXM2x2tOQFvAX/eH8VU7DOpKXK0XhtgsW0DJcrahu98bS0ssGjKWWoIBTURj71bu/OJn931pSFby6yerD4ZsRGHDVUBVpzdJTewAdfVlS6cLv5MQI97Qj+TuxgKVWW+ovU79/JnOPaIS+aYcXEM6okjd1xtHXEUgFgk/SjZPu/Tzp23ZqAbPcXx9/NoYTsngrs+pDqC82+i055k+vNsvp/plzIdM1eCGGAOc4uuo24+vEgPUPd3cGolC05B0erfZ0HnUkPytLd936dhVoQ+QBBj9cmT4ZmbWFT+Ar3XwW+PWgYKIJmU9w9G1pTaKoAI88/t514Ibwue8iReBTFzbdYRVlpczswGvlfeFXeVhDLEu3YYEbxz28RqdEqH6H3K+5Wh0/iYhFDJfE2zb0RfbWZytly0i5OfVJ493unhyxAuoOsSbZuVtmynqlbcnC7/Qpc6ziJeeNOBuvjSTDztBoxJLrg6tIuHg1qbRSmVfHMtOnAhwSYPQjtTtKofeQKs24WgVAQsDchXGlMt+qPmQ+XJzCITCuATpn+UhGniwBWMWuvrxCZOTWGWVf7VCpPMpszZcFEULG68V4R30mV0w2CGUxuOdLUhMo6CUybMw/gtR9tL46YND596r0kNcxA6Ja9l6ESNOtoLKapZWY3P+HxueO+qpZOMyjpXzZjJEwrdukI0eVY162ikMBZGXqif7mgOg1OpybvMzFsWMk6wETY6yo5EPnc585b8IlXOJX0LNe
 dPXOL4u7
 XstJR6LaEBecM26zaYdmkphJ2wrl9qdEy2OZF3ZHOfO5w8kl6OzBjVcjo2k8QqtoAdDB3xd0OEMUr/ItkI9TjVS4kSmg1nsO7Ne//bgwF/OAkAZTnNkM2R503g69MFt5KYVG+nEm2SP7F2c/5iFMLh1VundEH28ct4WHsoFdPlJNX6FlDzz601bhttrmZEBCW2yNKPmNg+p2ITcON0Rv02ou+mEVBa54F1bz93XoGkODntdbm8uaGJBJnf+0qJB3orI+yr0sDsuVX5fLJtUEdO7HgVWrgpiREGa5g98LH3YTJymDyJAmxq5UPa6Aee7hZTgx9YNzaGrdyX6nEDLH1wpaq/UEQx3qMdiFNLBup3N+37p5ywzna8B2JNKCFQxLnHA1niyO4I7knDYTAkmQZyOpMnOuqaWKBsVr96cgXc+y6wG4HGFjFxy3OLcKThTfluxq0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/24/26 11:26, Linus Walleij wrote:
> After the introduction of clear_pages() we exploit the
> fact that the process vm_area is allocated in contiguous
> pages to just clear them all in one swift operation.

The pages are virtually contiguous (vmalloc IIUC), not necessarily
physically contiguous. For clear_pages() that should work.

> 
> Suggested-by: Mateusz Guzik <mjguzik@gmail.com>
> Link: https://lore.kernel.org/linux-mm/dpnwsp7dl4535rd7qmszanw6u5an2p74uxfex4dh53frpb7pu3@2bnjjavjrepe/
> Suggested-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Link: https://lore.kernel.org/20240311164638.2015063-7-pasha.tatashin@soleen.com
> Signed-off-by: Linus Walleij <linusw@kernel.org>
> ---
>  kernel/fork.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index e832da9d15a4..88d78ccef245 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -345,7 +345,7 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
>  		stack = kasan_reset_tag(vm_area->addr);
>  
>  		/* Clear stale pointers from reused stack. */
> -		memset(stack, 0, THREAD_SIZE);
> +		clear_pages(vm_area->addr, vm_area->nr_pages);

LGTM.

Do we have any idea about performance impact etc?

-- 
Cheers,

David

