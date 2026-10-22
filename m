Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48CF7606A321
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 14:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cloudflare.com header.i=@cloudflare.com header.a=rsa-sha256 header.s=google09082023 header.b=N58GUzyd
Received: by kanga.kvack.org (Postfix)
	id 5BC306B0957; Thu, 22 Oct 2026 10:25:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 565B36B0958; Thu, 22 Oct 2026 10:25:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4309D6B0959; Thu, 22 Oct 2026 10:25:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A3CD6B0957
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:25:41 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 181A116012C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:25:40 +0000 (UTC)
X-FDA: 85350485640.15.931FE12
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id 93E111A0006
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:25:36 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=N58GUzyd;
	spf=pass (imf19.hostedemail.com: domain of mfleming@cloudflare.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mfleming@cloudflare.com;
	dmarc=pass (policy=reject) header.from=cloudflare.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792679136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BLPsOYsY2Fo/8WqeAuLv7fNXJKo5hs+vI/mKlVqvfTU=;
	b=YLZp6EIJrd2bVwBZ6EtkOwTdAnuTREIi+mwhN1GpMSBlMJCLod6J8xKx9Q23tjdZgiBI1T
	GtgCzdruF08wmC07zlNocMk9tNoOTqaQ+MU03cHZDjFQs5JoRLs/rX9iWxIxW3ljcRvYom
	lSqDjnd8abBNGOMbI0u6R0aQczR4wmA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=N58GUzyd;
	spf=pass (imf19.hostedemail.com: domain of mfleming@cloudflare.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mfleming@cloudflare.com;
	dmarc=pass (policy=reject) header.from=cloudflare.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792679136;
	b=cscdCLC1nONgs/Z0dHkBJqw1H9cjW2TnWthFatn5nx/m71AXjfRlBDNxJu/pbnQucFIi47
	Xq1tyc28apu5g+Df6I2W2+I16Wna0Z1tuX+fFtYSwFbfh0pup0dldCWbg6YPC5mVycy+RQ
	/lCKeM4nD2kB5C6zBQxyIq+bGyPNqbU=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a2074a66beso5992535e9.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1792679135; x=1793283935; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BLPsOYsY2Fo/8WqeAuLv7fNXJKo5hs+vI/mKlVqvfTU=;
        b=N58GUzydKbd19HkKblLy94oZkQjg4JJvCnnABipsp2NUf+laad1rkD4ud1ZQ4it4fI
         yRXFTMWQp0SYg1VLpTaUEPyCk45sTYeVpLBJtSGJYRVmUtdhiG3IwvMI5F9ZkL2Q1/bq
         s8lAm35WSSNkC8YDc+A2dirVhs7L6G6+pzZRY9VqNykv9I/9fqvRI4bTxMblALAMz/pJ
         ovKWAGsA9ah1SzOOjSxFRGmK9TGm8I+mHDd3H0EQC5qw7OaDk16iJ/ymhZ1qniTUrxcL
         DmQDkn5U4siCagZi3+21vJcHPE5u4QVp3Z1/cfT/uyG4HzaMumfHpXu3NNwsJii2LOR6
         36Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792679135; x=1793283935;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BLPsOYsY2Fo/8WqeAuLv7fNXJKo5hs+vI/mKlVqvfTU=;
        b=EMbAILSdfC7gsCGOEICDzzABA7vmqRVideiv3JZVUOu/xCGhRIOkfoAiqO6+Q9h0j4
         e8EM/Y2tTRpVcNBunvODJUk2m5WKM1iEQptxW8NT/3Bh+gVquc4nOCmPUv6KHpIHDXMW
         MNNVzhKMv860CsXYU81bEzXNFSwumyZs+Fykt1fioI5Wvj2hmMP7vPoCg9IXc8YlG8D2
         WNjVw09CYCrWWKlwvPV5SqDfNQF032IkxvNK7wyXf+jARqr/LPdu8tFg5S0H7HU27rR9
         c8wgEK6JJYlyEESiN8x31OkDKM2hXfB5Yobq/yyNk/Lw93Q5cB3Gb7r99zOaluVJ1xaj
         Va3g==
X-Forwarded-Encrypted: i=1; AKwUvBzbx1jUt4BFZy5vIVNaB/YUJDvjsKbeh090hnh1ZUA4mz7TH1TTUZi1QND3krSJEerdEPTocifSzQ==@kvack.org
X-Gm-Message-State: AFq9FYJ5YL6zlw2GtASSJdV+BbyHCb9s1SVaHABXgXP96Q73p0qtSXWr
	BIjQYgHP1OZVgR1kyf7eMc09Lk8WIiZJBRpDw+6rcgHWXglWx+8dkpzItKPu25MNGa4=
X-Gm-Gg: AYBFou21KJuuqqB8gJdvvMwdfKcFp97KB3BjRUgznatU9b4vzySHKVbJw27QfHGGrhg
	6E5vB43QcSMRwUzW19FZNH/jnLxoNukbGKCz5k3L6bO36l/NzcxBgZcRRJzIJYBE0dS+ifQpQtu
	coiKxlZNl1RDgRy0Guqk073+hAEdlOZV9xEXvD3Ff1CXoqDN3CFyNZ3MjvTIo/0rG/QnkWSUA32
	pwDodZ69agTPKNXZ/XKM3hooLeYoHJPtYBUAiCka1W2Ya7iDTPm/1gxI5Pa7tnd8klSwSdXzvJ1
	GDlNABaRHy5QRfC2p4pMBCUwLXyAxeC/os4+vQfZ3Yx6j0dbjAD0fpR5ar37+EZSL7eRfyvVcFN
	M3IFjL8TabbAaoJee7EZpe+gS2d8lU1u8MOEZdwoI3IeYzdtIpXGp1cwutE/c+GfnknRRgCC6JP
	QcAuMrHfyZrEV4T7DVlFr7PSc9j80g+iPhEXOIxKdgCycauA2P8/XfXiHox5yAzW+MMBIEehSFN
	rlZ9PRKES/+DGN2E5bJjfz03avbJvvg5o6sZXlP69ko2HW5bUEmRDj719S5oxG9
X-Received: by 2002:a05:6000:260a:b0:486:e707:42eb with SMTP id ffacd0b85a97d-48e26495969mr10185612f8f.33.1792679134760;
        Thu, 22 Oct 2026 07:25:34 -0700 (PDT)
Received: from localhost ([2a09:bac6:37a8:294b::41d:9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e258213cesm12905886f8f.11.2026.10.22.07.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 07:25:33 -0700 (PDT)
Date: Thu, 22 Oct 2026 15:25:31 +0100
From: Matt Fleming <mfleming@cloudflare.com>
To: Marco Elver <elver@google.com>
Cc: Caleb Kan <calebkan1106@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com, Vlastimil Babka <vbabka@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	Caleb Kan <ckan@cloudflare.com>, kernel-team@cloudflare.com
Subject: Re: [PATCH RFC v2 03/11] mm/page_owner: preserve accounting with
 countable stack depot records
Message-ID: <atoIzppNHvUGlv36@matt-Precision-5490>
References: <20260908-stackdepot-trie-v2-0-1996d5cef732@cloudflare.com>
 <20260908-stackdepot-trie-v2-3-1996d5cef732@cloudflare.com>
 <atdMXELJWveehYmX@elver.google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atdMXELJWveehYmX@elver.google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 93E111A0006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 9yh4msfhe3r8rhnsxkgudr375gjdqpxd
X-HE-Tag: 1792679136-646525
X-HE-Meta: U2FsdGVkX1+atRdVrDeblGnvMr4XdZntG5hXJOwfibfO6T+PTxnwZivL2ptsYe50bNPtY8jEl75EGRh+BejRiBU2cDJWkDGttaEoMwP3DXIDxT3zFuGOK6SGf8VqF+Vj6aX6OAFMgmo/BTu8iqyb5aLvrGTsGzbABl9Af7+26IdPage5OaY4XKhds3PmhwYdfQr6pKoxhlRnmFuVrgUVlu9apcaKBC1iXXhlaxL2w54eKNY/84S3T+W34jwSF6EB6iGMuxV4Pr7M4x83lPtBn7w5xlwZTTpSBEf2EmLRrgQCqOf5PEEPfA6ryX/zlAoRpOF1ElsOVsl6eDdtgUTn9Rgun12WrBe3qg65a+AzfGFvBbVO1kVytit1geIj6YfByAMiDsLvnhdog8bipGEYdvxJ6uNGU5ygwSmyrxp/JOqK9fr9wQ+LKBOsMYvKC1SMO91ANRdY+XBWUj3E0WrarHeew1ylByfFqQBnjvhxMHYdVQ3TifT7Mq3UcoSbUVxi3JQenYI2R1l8lgIrLqD0pYWOeurTRC0DegtnXJLj+5IIbN9zYtxS8fbb0FjDqzJWKE/5vFNC04S8+UgXSE5ItXG6yiul16OfC12cqhkILSeHn75ssDb+IiLf1aW2emrxHtSIRO7xGF2lBu6ecLIqVJc9mDX9FKpoX+VG+bPkr/r10wgYMv7Gahm4i++1EzcqpyeVr3cpZatH0/eA/wspnLHPp9uhoAt24TppZoKsox8mEqbH0pG0xNPdtc1jk4JCRfdZdVF+qT/Q+Jp8FdBDHAAC34QLaLfmPyjk6PxxnXAkiPwr1ZwKGEgaaxFY3ZXk2E679+NCeecdFp/PQosqBS5loIBbfJiN1iGaFviWOn0sqyJ843Hon1uLJkCHAbBpA1QQWLhvwMYFjo7nnDvSSjgLY5/VWm4OPOGizkHKk2NQE8UEbsa7XEhJy05AZTE/cNnxvus5QyapZJP0oHt
 6pCj81X7
 VfSpAr8rl6jsnq+OQ/0rMkFk7j9PJJzE6+i10s40U+hyh/F5LdJFvXOhZk4yNoPbHuqSM6BnpBx7uF51qiD2v0oJudW6WP+AztYT+1sblMrbMlqFYE6X7ndLANWCHyLXqa8nDKcBPRwqZuHlMi1D0GyPpcYGWwW/+Ku/qqii5GpiEwL3f6kqOcXexLpHcDI/TDUTC/vpAcTH/IRMSs80hjOjEyRDBsWY0gC2eq9aPux3lLW2BVe1+MKbKnzRCgi921r6KZJby9xBqfLpzEjbyQ4BNpzqiun+BywvacZjcQpJgg1R9J0bkMDJcZdyM4MS6UK+BOvnzNDkzfmkqXtMx9H4IjYF4NfJmAigr3/BfppfYkdpwER0LU35kiYY+8z9KVO9FWDqEqLJaDR+YdPq/L7BueLzLQ494rZGAEbnf4no2HVzkYNuBYFp85ipG2ixXR29ttKGWqhBzCV5eNwQrIw5aBbUXgdQ/tMlgC6Cu3iUoVWli2Y1Kb7AdfYYI5CQgc2TxytFCEvwIVb4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 11:11:24AM +0000, 'Marco Elver' via kernel-team wrote:
> On Tue, Sep 08, 2026 at 02:13PM +0100, Caleb Kan wrote:
> >
> > @@ -609,6 +611,9 @@ static inline struct stack_record *find_stack(struct list_head *bucket,
> >  	list_for_each_entry_rcu(stack, bucket, hash_list) {
> >  		if (stack->hash != hash || stack->size != size)
> >  			continue;
> > +		/* Page owner countable records have a distinct count lifetime. */
> > +		if ((stack->flags ^ flags) & STACK_DEPOT_FLAG_COUNTABLE)
> > +			continue;
> 
> This splits hash deduplication unconditionally even when
> stackdepot.trie_enabled=0 (the default), and even for page_owner's
> free_handle traces (__reset_page_owner()), which never touch
> stack_record->count. Prior to this patch, persistent hash records had
> refcount_set(&stack->count, REFCOUNT_SATURATED) and page_owner safely
> overwrote it with its 1-biased page count while still sharing records
> with non-GET callers.
> 
> The interface looks error-prone to me.

OK, fair point. I think the best course is just to make the trie
backend work with the ->count mechanism too so this whole problem goes
away.

Thanks,
Matt

