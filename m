Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83409606C94C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 19:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=uiFgOFMw
Received: by kanga.kvack.org (Postfix)
	id A5C2F6B05B2; Fri, 13 Nov 2026 14:58:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A33E16B05B3; Fri, 13 Nov 2026 14:58:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 949E76B05B4; Fri, 13 Nov 2026 14:58:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6909B6B05B2
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:58:15 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0B124140291
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:58:15 +0000 (UTC)
X-FDA: 85431157350.02.626C153
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf19.hostedemail.com (Postfix) with ESMTP id 03C261A000A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:58:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=uiFgOFMw;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf19.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.43 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794599893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mK+snQ9Frl5VxzHZ6tx3RVh1smAcvo0rFgfFkfaD5gg=;
	b=M1OlCJrnLfcyRZqGh1+8f+da6haZyv+Stk0gseRJ0kITvrFSSoEDXe9ce6YRmK2wecAD7Y
	N6XunVy0Bi/jLRQXZBw4i10WkOsnRK8y4xTf8ULRCZxRx/+QQ2mxo6vmrM/BezLKP8950q
	7fbk32moXgyNGrBWzK+YbHPjZq8nu/s=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=uiFgOFMw;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf19.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.43 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794599893;
	b=AVWOMHtZT0bzvywvJ8t7XBj8agoq9+GaTiv8lDbTc8F0hHk22GySZ/jm7Fag5vS4HOaMux
	qywkNX8VUYahBNYGrYZJ+OWIFfewBQBtE00oGOzO+ZTvIeF70nZj16GlqZG0/FbCRuxFdq
	dhgVWqJqEHgE66ZhztIOVBAbOVXIzoQ=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3ac91ac8924so742592a91.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:58:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794599892; x=1795204692; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mK+snQ9Frl5VxzHZ6tx3RVh1smAcvo0rFgfFkfaD5gg=;
        b=uiFgOFMw4bt0WYBMiiwlcjrp6YRLr2plPpdkBNrwD9hB/rIY8XEBD6yIHm1N+0pKdw
         EW3XfHO/lon0GaCqtjk+gYf/ggxMKumD6PSgIWVWPYOjO15ON0Og0PeTV1DFNOzh32+O
         jc/5Vzdoa3AhCulrvloDur7aRsJtIuKgojdUg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794599892; x=1795204692;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mK+snQ9Frl5VxzHZ6tx3RVh1smAcvo0rFgfFkfaD5gg=;
        b=GrHIIl1Clxw5pHDXYavieMInALF8Nt+iUNOm1sQyvv4qnXJO3JdUbeBo1bJpHx741K
         91wdkiVCDYbkUniWnxUPRNwh1o+jnAn0K3IN60vQBzF6h9otDYXhUv8khZdzGHch9BHH
         1U44cWpCj8fCW2h77DrM9xlAfJDkLCeCMeCkjUh9Opxm4KqSea9zLyTnyEBKlOnu5u2q
         JSkSTmAHVATLkdEceYi680IqZ4ic4MKnBiT1DyNakotwcrB46jiU2tGUggTQ3lSONCjx
         PRuKT3t8ONXOYnMqP98AjlUT5eoNjmqFNvLQuMVpYojwfPr53isjR8aaTbExtyzStRGe
         BCdA==
X-Forwarded-Encrypted: i=1; AL+hErGTRc6nCJsikn6SV2Xeridh2aoF5NO68Raq7VnEbpn7vNE6Loy9glEe4eKuIwJ1+nxX7LjQN9HXJQ==@kvack.org
X-Gm-Message-State: APuU4Z8qMIX/p3LLaguur7/xsbk2v0fSi8YawBKAQazT+gliH9/AgSMI
	8wmfegq2/3Tn9ZcywbTvfvONcFG5xEnqMXk4/IQ0Y5/CQotHNM/5dqi2L6nX6m1KVd0=
X-Gm-Gg: AYBFou0taNlc4IbQlJ9fTrRpKxnXY8SOtGX6vBBkHzVL7M384m5uEQBqZVteEy4Ls8a
	DC2LwwkaX7C0u2wf1CGcMYIPaS62FbTcsQrrBQ9Hijzt2N8Y1WJkBYgROjhLY1CTSF81Bo6J0FM
	Mk2iT+DwYpAsBAuRhjZe4oz2f9zyS4x8nU1TAwzxy45/ZAZvtsahyJRvNfvTqmg1U3Ocq+7bQ9E
	0wdtQx+tQ8dTKTDJLWQHPPQJ/TZwaQJykpyHaX1i/kK1+5OIBiSFXV2fWAz5zr/IYG+zMQ9PmrY
	ST11AKCm/BtrFzIFjzris0g9fVCkMDupd3KzSz1bnTcsVquiUZN36B8K47HxzEJzIuWwGCS2yjo
	qQBAypUEVGSWfLIJ881e+CMxB2kNSkCqjYg56StvgVNwSCCGMKVnh6gpdRAthJ38ctGFgtavZnI
	cA5Ka15bj4+aPKmnVAjx/anL4m0W5KJJZxYFIwngn0ENGdb3qdR0S63vEbf6IQrPVnZVBscpMDL
	ynlAAP3ssh8ybPpUz/CxXISJaCxaLY6lFnfN9NLOUdJDZyXkxxocGcYdgwnEKjPCU9HrxL2goGa
	xp+fE2PEM/5k2Ffj0WF4MGye4PA6pUsIjrtOi/QWpXlyAoLQ/3ZTuhxoyKtly5C274C1pCHf0HA
	x6Y/zDw8eXNYKBBpAztlE+iRhNKp6lbQD2oyCzgdVvvOE5Co3xZe9Ck7urbQIdrVZz6FVE8Cz1f
	tqbgPZ/NNjutWNJN9U7bUQ0U74Vm0qNXIYQNFn6zLJ50bp9/hzfjmPqr3VPYI=
X-Received: by 2002:a17:90b:17c7:b0:3ab:884b:65ab with SMTP id 98e67ed59e1d1-3b1b0ba4fd8mr3495026a91.55.1794599891728;
        Fri, 13 Nov 2026 11:58:11 -0800 (PST)
Received: from [172.22.0.2] ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f7e5055sm14868305ad.39.2026.11.13.11.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 11:58:11 -0800 (PST)
Date: Fri, 13 Nov 2026 11:58:08 -0800
From: Chris Down <chris@chrisdown.name>
To: Vineet Gupta <vineet.gupta@linux.dev>
Cc: dennis@kernel.org, tj@kernel.org, cl@gentwo.org, peterz@infradead.org, mingo@redhat.com, will@kernel.org, boqun@kernel.org, longman@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org, andrii@kernel.org, daniel@iogearbox.net, acme@kernel.org, yonghong.song@linux.dev, eddyz87@gmail.com, martin.lau@linux.dev, nathan@kernel.org, ndesaulniers@google.com, morbo@google.com, justinstitt@google.com, llvm@lists.linux.dev
Subject: Re: [RFC PATCH 1/2] percpu: do not put btf_type_tag on per-cpu variable declarations
In-Reply-To: <20261110012235.1024461-2-vineet.gupta@linux.dev>
References: <20261110012235.1024461-1-vineet.gupta@linux.dev> <20261110012235.1024461-2-vineet.gupta@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261113115808.87a52a7c74e293ce@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 03C261A000A
X-Stat-Signature: bbhfocq71j6k3g1ms1puf8cibc55gbim
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794599892-680824
X-HE-Meta: U2FsdGVkX183S2khfsoa0kbvQ6OZQxq1lUFIWCcf9g3MLO9o5kJmtgFaoylmI+23zZGmKJ59MBAgY5F0x7QKuhsX78BoB46z8YrZVaBifQmwVbLqINFC1cDONo9AI5oWxgZ5e4OTZ7FM74uF/GiTIqg1xxGAfnplWwYqKRXEvjjqiLNE5gqkiwVL1/Pa0Z3YLK8obRuOHKH6VnFaQnj0t97bz+PgHyhoGVgY5u04CPj4QbJilRFWLI9UJRDsGAzQbYDhcZYdhqaawYmDl0AUevluwwSp41gHM2X5DDbTRklyuArXSFjDDzdn4HyCzEIzK0oII7+CdQoYTy8ZotBakFNOwZjyQh1J2mgXJAovFHQfTWjdWEGgZFmmbcO6Epv7ghPfWMwlmMsli2Ra4MojaDZS5LQOZhIEI5odK+Jadn4RY5mxc9nfoPWJkiftAYG9gqLX99svRoWIRMQXsQi7+rMxusc3G1ff8dBY4OIjDD8+wLd4u1TanklYzwmrF+uPa29dhunS75OD36v/VSo+sePn4QC97hRvutMu3B37uipgvUOkR91jbs7G5IU4XBTX4OWZ7fEy6bfBFFfhfvJfSsCZHyBArJZt8RaXBCI8PdwqvuxzwZeV7VTjeK2SeDWDxxplU9/OdzvJ9xufEzvBT+QkEAzIy0g7+YxrqcuWxGrZE7aA7eaz4G1bp47/FCthq7yxTr76y/XplQQsEhE8DK0PBDuazAnTIlvc3hsyJBNeUJqbE/XoNmu4+BQB+U6GB5ky1bdqNVkL6KbpsDJif+PVFnkgZDh3PtgYVToDFKcCAfAmlcQlBfkYmMZghns7x5n1ZgrkJ6e7CoBx9XPC08kmMCYLwHC+3VOUgs0nkJZgJxGX7tjhX+KhBIT/jybULAVj8RYKHv6aT2QZkZQ0ZGmn4I85N488KflPhHxGeaG8aY+VIC/iH/1A+APoG5tJpq37M7X27hnH9JuQXjv
 a1crPdUS
 MW6FhptcI633h5S0Bae42zfKKE3KmEflvAWkx3QV957O5aNxSjAO6PN2eG1F7KDA7s9pIrvKogM+4y/eqy1xOH+jNjEU+f7c/a0SdW0RC726+Ud9qcqFFcuhrVDwlaaMPF0y7h/JnGPgkqmRz8EsfolVwE9FED20oT7qRTmU9TsyCXgn2bx2Q7U5fb8OGd1ueH8VC9b5c02el+X98iV8V9jEP0ZeMVsh/HGfbtomxVjngeG8MA1Ypp78fO+kZAywT03MwnW2u2V4OLcpD5etfZ3fsFcz2Aft7W4PVDVKunUEm4oxxMKp3PMExPSSubT9AFB3YBmkWEq0U5laPGTzYooJjca6PtZZnkc8+TIZKhFZfLRGDf29Qa4Tn9dfKu47RAhDuGd6Zp++72d1VD1lrJxWdpcUQwJZ4oP+p/GVrB3xxUqNQjvShOvfAT6SIhgkmWVGcuGwfRRmokqfC+MWQcIl6AQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Vineet,

Vineet Gupta <vineet.gupta@linux.dev> writes:
>The message is confusing: this is a declaration, not a definition. But
>the compiler is right to object to a type tag on the aggregate, and the
>issue is fundamental: every variant of an aggregate shares one DIE, so
>there is nowhere to put it. clang drops it silently and GCC warns.

Not a big deal, but the definition in GCC's message is the definition of
struct cpuinfo_x86, not of cpu_info. It's saying the attribute is being
applied to the struct type after the struct was already defined, which is
accurate. So maybe just drop that first sentence?

I've tested this with clang 23 and GCC 16. With clang, the same 280 types
and 3360 bytes of BTF go away. Likewise, with GCC, the per-cpu
declarations no longer warn, and the non-enclosed address space errors
are gone.

Once the commit message nits are fixed, please feel free to add:

Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>

Thanks!

Chris

