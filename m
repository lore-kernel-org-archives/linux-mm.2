Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACA7CCCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 13:44:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD7878E0095; Fri, 24 Oct 2025 09:44:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D875C8E0042; Fri, 24 Oct 2025 09:44:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C75FC8E0095; Fri, 24 Oct 2025 09:44:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B0AF18E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:44:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CF793C0EE4
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:44:28 +0000 (UTC)
X-FDA: 84033127416.16.7E57274
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2EF6DC0006
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:44:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=KHRd6md2
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761313467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ffcj2jilQV0mH7721aCemvuNywIj+ADnf9rulKDQShk=;
	b=rlvPASTTlqXR2kb8a6zn/eQC0P94SBewP+CWypNIZludqGeOcM3f7H5SSaZY3iJaq2W7b1
	WxRgc2Ut25fN5vzJf0I/UmRi299XS8Eti0mOg7fndwRuUgen164I88gpxksJxe6o3UZDxo
	Go2FAv4asi6APQfEMLor3iL99NvPb6Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=KHRd6md2;
	spf=none (imf28.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761313467; a=rsa-sha256;
	cv=none;
	b=t28YBPYR8gNtfh6rhqrCyDCJz5OX0YDRX+BqBu84p6l25XAOJgCnxRu4tdWl8Ct6k6lLRd
	NbRWhXc6kdD6ciBoQMgSuPjtXOuA16kRpSoDE5qc2Pw2yL0mvBfR4C+2KT5VTaEdusY8mS
	ZjMANk0CXto8Z3WABbMj7BdJbpUronI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Ffcj2jilQV0mH7721aCemvuNywIj+ADnf9rulKDQShk=; b=KHRd6md2YVWeoXFeMmOWjQOBva
	hh98PWr8MR1nG8zt+X/s6pNq8xiLExucjDp3JcN4aiatOzqJUNgvQ/KXmFQ7o8aCO6EU/gzmFHN4J
	Be0zoP4ogk+i21sdK+niWsL0z7p50enlf4qEG8yQCXJHbDN6kAk7dVQfgziqyu7kPRpTlSqQt9E9Q
	wGRNbOnpdhRIV1kmPH+hE+l9at4KY/wj1129/zMzH6nu0h3oFQ4glOQsKZgjAfDc4E3WoD9po659j
	UNyIyGukE3AA/jCEbu384/JafPxkcxYI90Efy8nuNuLJoyK5IFbaVDRSf0vI4xv8IYuGNSSqNPKgb
	J0+2JBww==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCI5W-00000001uJu-3O11;
	Fri, 24 Oct 2025 13:44:16 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 0A030300323; Fri, 24 Oct 2025 15:44:15 +0200 (CEST)
Date: Fri, 24 Oct 2025 15:44:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jens Remus <jremus@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
	Steven Rostedt <rostedt@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrii Nakryiko <andrii@kernel.org>,
	Indu Bhagat <indu.bhagat@oracle.com>,
	"Jose E. Marchesi" <jemarch@gnu.org>,
	Beau Belgrave <beaub@linux.microsoft.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Florian Weimer <fweimer@redhat.com>, Kees Cook <kees@kernel.org>,
	Carlos O'Donell <codonell@redhat.com>, Sam James <sam@gentoo.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: Re: [PATCH v11 08/15] unwind_user/sframe: Wire up unwind_user to
 sframe
Message-ID: <20251024134415.GD3245006@noisy.programming.kicks-ass.net>
References: <20251022144326.4082059-1-jremus@linux.ibm.com>
 <20251022144326.4082059-9-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022144326.4082059-9-jremus@linux.ibm.com>
X-Stat-Signature: o76efcxqjy5pfshoonwk5j8b7154c4du
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2EF6DC0006
X-HE-Tag: 1761313465-921059
X-HE-Meta: U2FsdGVkX1+dng9Y0dwe+bHkACjfIhNX3Mi2Mlvy29GEv5+wcR88+JZsSQtm/L6iYUqTqZI5tC+rEzl10v36mMqsWwsTJr2PUmIC4KmYstqRcmdlkX9x0BArk4YyhcpYXJAWfPuYJcKPDO3fw/hR2qyDZRH1oa5ib+0uSOxRgcyyDbcHQTm6tDbe6vS20pCi7dpQrLn5A9nZ9zlDbJooSCdviJlz6N1pMvQoc2IXegKYRmq6+wE6lpYSW8xur5lmncGGzKql2O4ZuWBeOq9Q+t//0b5D3P0PK5eHdl+1z4FASjuS0twI/aPU9ODn9kOkNaM8bEdwa4AA52MpmvWihF2fLe3YyzpCSdP94aWA65YKoLp1lCqh6Qo2nNBj4AtkLPpes5xA7E+AaUjI6bDvziZ9i9m3qFLl6gi06kvTIyDNpWeoPoM6M1uxOOd8Yrl5hzWqvc168nU6+/DC7yT0ccdpUH1Fr+pz9RgGoGURw7t8avL7ATM5TXaQ3uUPSYxvMrX10M5XVdViVmbFjtHZ4gBuDvBicGyBA+qSSlqAUiXyDz2ixGsPnn0ovoDiqjK4S320F39tfB7KXuqXfcXNm9sghxiuJ7uq51QcOOTocxU+t+V07tLxDMm+nRWWM7pLfR54Wj3qqZKMhUvWs3+pbt538V/8gE13wxHIVE6Q0mHDMIoK+85BuoXw015KdHLzTdWMz7Bz7Uc+0KMY8T4lzS3KdBl7pMmJI1SJAZfubuK/rBv0nUW0GiIWEml2YfsMk1uS4m2bJw5MaP0OJLGG3w3Ih3+D070UD1s3knUaszFuhK6+g/YaeQ7viTOegnlG8LTVH+aVl7RPJk6PfJBMCpnoG0VbWW424beOdNyghHp7fgp/X3ItU6J31h0ocDotefDdvI5sIxRgKCThOMmbL2Ck9Y1OatC9BkEaAFLm80Uf0uZSo5j/DQ27sTvH+844OkAfSf8LOTT+0yrr+Z3
 FWxqt5An
 C8dw9H4PFdC8WvOZPEmK3BlmwHThP5x9mAk+8m4iI0UI3JWj/FNyiqpJM/KdPrwtUHUJ5xhgklqUMPIccgqbv86gyBoEQLFH6uHKOLCPTw2ExLxUSAvDMOSBK864w578zq8Ck6kZ/ZJM+/X0jnD2cSGh6pYyj1jO1pfWnGmp+zMeLPTO14wos4CBw/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 04:43:19PM +0200, Jens Remus wrote:

> @@ -26,12 +27,10 @@ get_user_word(unsigned long *word, unsigned long base, int off, unsigned int ws)
>  	return get_user(*word, addr);
>  }
>  
> -static int unwind_user_next_fp(struct unwind_user_state *state)
> +static int unwind_user_next_common(struct unwind_user_state *state,
> +				   const struct unwind_user_frame *frame,
> +				   struct pt_regs *regs)
>  {

What is pt_regs for? AFAICT it isn't actually used in any of the
following patches.

> -	const struct unwind_user_frame fp_frame = {
> -		ARCH_INIT_USER_FP_FRAME(state->ws)
> -	};
> -	const struct unwind_user_frame *frame = &fp_frame;
>  	unsigned long cfa, fp, ra;
>  
>  	if (frame->use_fp) {
> @@ -67,6 +66,26 @@ static int unwind_user_next_fp(struct unwind_user_state *state)
>  	return 0;
>  }
>  
> +static int unwind_user_next_sframe(struct unwind_user_state *state)
> +{
> +	struct unwind_user_frame _frame, *frame;
> +
> +	/* sframe expects the frame to be local storage */
> +	frame = &_frame;
> +	if (sframe_find(state->ip, frame))
> +		return -ENOENT;
> +	return unwind_user_next_common(state, frame, task_pt_regs(current));
> +}

Would it not be simpler to write:

static int unwind_user_next_sframe(struct unwind_user_state *state)
{
	struct unwind_user_frame frame;

	/* sframe expects the frame to be local storage */
	if (sframe_find(state->ip, &frame))
		return -ENOENT;
	return unwind_user_next_common(state, &frame, task_pt_regs(current));
}

hmm?

> +static int unwind_user_next_fp(struct unwind_user_state *state)
> +{
> +	const struct unwind_user_frame fp_frame = {
> +		ARCH_INIT_USER_FP_FRAME(state->ws)
> +	};
> +
> +	return unwind_user_next_common(state, &fp_frame, task_pt_regs(current));
> +}
> +
>  static int unwind_user_next(struct unwind_user_state *state)
>  {
>  	unsigned long iter_mask = state->available_types;
> @@ -80,6 +99,16 @@ static int unwind_user_next(struct unwind_user_state *state)
>  
>  		state->current_type = type;
>  		switch (type) {
> +		case UNWIND_USER_TYPE_SFRAME:
> +			switch (unwind_user_next_sframe(state)) {
> +			case 0:
> +				return 0;
> +			case -ENOENT:
> +				continue;	/* Try next method. */
> +			default:
> +				state->done = true;
> +			}
> +			break;

Should it remove SFRAME from state->available_types at this point?

