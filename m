Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02B6FCA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 19:25:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 440F86B00C0; Thu, 21 Aug 2025 15:25:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F1E56B00C2; Thu, 21 Aug 2025 15:25:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3078F6B00C3; Thu, 21 Aug 2025 15:25:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2027A6B00C0
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:25:15 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 772A21404ED
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 19:25:14 +0000 (UTC)
X-FDA: 83801742948.07.74707EC
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf06.hostedemail.com (Postfix) with ESMTP id B9EEE180007
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 19:25:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755804312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Wit7p2EUM1bs1hD3ePlBQbP7SkBYA/PoDl+ZaP00zA=;
	b=XgMZBeVSeoJ3YJ1zJMZteMG3sBkXzolF15LxaeINcswX2JEWQlJ0LI8SRUFq85mpM1QhhJ
	ncQ6LVhKZS5ANiOYeGN9hEyNaBjw03pIWG4vMqhuHSJHBu5cn3oiGyitkeEdkn5aayMF3X
	wbuXTcYsAQ2DK6OoR13ffUFCl7H4uuU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755804312; a=rsa-sha256;
	cv=none;
	b=gJVpeTUcjEpFjIrGtTrlhHiEG4y/N9DtsZgZLDKYM2IUuTpWmm9zZSs6SvZaiXaOzmqtAd
	jGpnr8u9EPphF7fK3KjppODGW9oRLGORrFbcH6n1wLSrxSy7XyB/SU/fMnvuT5DY+hRWk5
	RhKE4Ww6d7VEf57iC2kIBN52com3JgE=
Received: from omf03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DFB08591EC;
	Thu, 21 Aug 2025 19:25:09 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf03.hostedemail.com (Postfix) with ESMTPA id 09C846000A;
	Thu, 21 Aug 2025 19:25:04 +0000 (UTC)
Date: Thu, 21 Aug 2025 15:25:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski
 <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, Christophe Leroy
 <christophe.leroy@csgroup.eu>, Daniel Gomez <da.gomez@samsung.com>, Dave
 Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Liam
 R. Howlett" <Liam.Howlett@oracle.com>, Luis Chamberlain
 <mcgrof@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra
 <peterz@infradead.org>, Petr Pavlu <petr.pavlu@suse.com>, Sami Tolvanen
 <samitolvanen@google.com>, Thomas Gleixner <tglx@linutronix.de>, Yann
 Ylavic <ylavic.dev@gmail.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-modules@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v3 8/8] x86/ftrace: enable EXECMEM_ROX_CACHE for ftrace
 allocations
Message-ID: <20250821152509.391c1ebe@gandalf.local.home>
In-Reply-To: <aKa4otIF6AbhD2X3@kernel.org>
References: <20250713071730.4117334-1-rppt@kernel.org>
	<20250713071730.4117334-9-rppt@kernel.org>
	<20250820184743.0302a8b5@gandalf.local.home>
	<aKa4otIF6AbhD2X3@kernel.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+CMQG1BETxfdgNxC+cxIEgpiTvO2qKdGo=
X-HE-Meta: U2FsdGVkX184fcxufunVUclfn8DfVrb7JSHS5xeDl0+1DGaNCkqXSAQB78+nX+M9qFzJ+XEGE2xq2wEmhekhDhz0ls29PxPTia0KyCKj2DS3zUHhUKuOG29rvKqA+da4TRvTzYXkmRMxM9yYhP18JaBtbtIBqbDN8KtB5JlbHT5fUu9woGnAPIAoY03eAKVC7nP20wT5veRaNV7o/14O3bY+RR1I2T2s4pkHB1P2h+mTipvoybEfHmn99WxpnapDf4+skh9FOH6Xu6SLdfXz2koCvyMhzz1Aqg8laodsKkDWG+QUPEdGygjNSu+CKwtFaktA/6OzKZRKcuRIwbXZLnWXVDAgIOzhUUC3b75/yXlYBgamghT2isHwhNVCZfb5pWzA9SRRaB2BrM3UVRUBdg==
X-Stat-Signature: cyn6qk3us8ocdtde5jpyb3zckzedttjn
X-Rspam-User: 
X-Rspamd-Queue-Id: B9EEE180007
X-HE-Tag-Orig: 1755804304-494471
X-Rspamd-Server: rspam01
X-HE-Tag: 1755804312-905189
X-HE-Meta: U2FsdGVkX1+CGWwJgblq0nx8gYIOlb+ETlPnTWTafFRNMc4YDJXg+5HyMgAs8e811HRhUKuhozcM2eZWmq3evqVRf3D0kte/9jXViSw09pQtJNcrAXXs5vYjemhT1kOwTRfjEEjLH+1JepyuGY1L8wFJBueQ85VZde6PMlYemBkCKNdMMi4XiaCujgp1UWWjOpbBL0q4ovY/F2fQS7CBgy/7lETpKi8/LICOladwGSgdS7gv63EbwnDsvgiUY4zgpNHm9Y06uUFyyuaqbqf9k9+nRF6SnRsjJhS3kUaYi3R/ATiTlp2FKM4rK5U8wtBusr9plcfznGrIxwrRYvkSpj3YBgt3ZXPC9AeK7qg9j2Evve8mcE7kpeAnxiVAZpWpJK6PECGwfl4OZLFqn36IkyOF7O7j6GEQO/EwJNKethu+wZLBPnb76mtFaLFJ5AVfaRLsAV+qvudNxu1JKFwsCd30MUJIBui1cwNmN15Se5ytpEzFZKco2rneIBepbm56HIHi1A7ay0epqDDyj68iez1tF9Se45xQPhOuNkoX5EG/6bOKK6QkKCM5XBb7p2YInJM1iqzfw333s9kHdKZPQXZ7467Sb4PJ8jDZ9emjJwm77W+gDsajSfhhGhp9ft/A6kv9iOJCEBXC2B5UIgOv9JC9u4CFxJGONEM3Hr10ZPuho+TEncjBbAFKKTles6IeG1IEQsOCl0IFOjS7Cyhhkx3ghj20//AHu1HBsgSQFhX3y3f8MJSdeJpq0RFm2BcMqdVbLSfFZyl0J3B8v+7Wjqk+o2Bp6S2nemM9mGFvp7Sf2kPJtwT5MMEyXEnFBmy/+Q1lGGisYHuVR/8jJnBAUeGqYOtg2SSQEntctJFDdcQZRnn76+1DqhE8pBeiYN00U0uqu3vIFuk+0mS25tLit7t8WbxeY06t22rvtET8xEY5V7KRa8aT5JBh1vu7op2Q/Bc1MMzOMacT5i17i8p
 5DLDsYao
 Vty+eDSn767a09w4exdPvmPQgBiD7Ck81MT45Uel7vEJ3qObmJuYEKofi9ugkFtHmCC2UgOm4OvOZ8LtYpk4SO1I7yx9IgAjNsQ5fYw3j3Ukj0L5UbmmbcSTx2ZBJazEyvWQw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 09:11:46 +0300
Mike Rapoport <rppt@kernel.org> wrote:

> maple tree is initialized after ftrace, so the patch below should fix it:
> 
> diff --git a/init/main.c b/init/main.c
> index 0ee0ee7b7c2c..5753e9539ae6 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -956,6 +956,7 @@ void start_kernel(void)
>  	sort_main_extable();
>  	trap_init();
>  	mm_core_init();
> +	maple_tree_init();
>  	poking_init();
>  	ftrace_init();
>  
> @@ -973,7 +974,6 @@ void start_kernel(void)
>  		 "Interrupts were enabled *very* early, fixing it\n"))
>  		local_irq_disable();
>  	radix_tree_init();
> -	maple_tree_init();
>  
>  	/*
>  	 * Set up housekeeping before setting up workqueues to allow the unbound
>  

Tested-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Thanks,

-- Steve

