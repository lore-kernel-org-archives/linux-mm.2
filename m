Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E9D9606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 05:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=S20clYYn
Received: by kanga.kvack.org (Postfix)
	id AAB876B00EF; Thu, 29 Oct 2026 01:38:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5C026B05B2; Thu, 29 Oct 2026 01:38:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94ABF6B05B3; Thu, 29 Oct 2026 01:38:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 71A1C6B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:38:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DF8151A029D
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 05:38:34 +0000 (UTC)
X-FDA: 85374558948.20.FC9FE96
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7FCE3100002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 05:38:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=S20clYYn;
	spf=pass (imf14.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793252313;
	b=cCbhgS6gRRyxN4JwUsNoCPHch5l7xZ9jsyOpPayU6IqOomiN2a/aONA4i1qT7n4ntwB1lo
	opGkieB4ZQr2TUk7pGpsGuZFjH5zAFzwC2BEHaU64YArfYffjee4RGHOtuIS/LYryuS4+b
	EW3F1ZI0mTRfATKg37ZiXlQvNe1dAV4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=S20clYYn;
	spf=pass (imf14.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793252313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dt06N7Moldm7Z/u/s5SX1+R6nTMYuYoZ3LKTzoi2+Uk=;
	b=MtSyXta7Os1mcxf4Nso5Q7cluo1nrS574ZkP2x3hh9lS3LcjKNoG8CaaP7ieI5qwepBDON
	FZQYILZEjQw/murDHNrU3fHboclegLxNchbANCXoKrXCXkjDkMpWwJV+79opmDLkltN147
	gD0FvptSh0RmLUZTwBGXPex4PAC5N9U=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Dt06N7Moldm7Z/u/s5SX1+R6nTMYuYoZ3LKTzoi2+Uk=; 
	b=S20clYYn23JF1MoxXFuYgEJDrhKM7XJWQyQas8KM6Aglg8aWfuUuH/YEG/aXX6hcdoOUyV6zuL/
	WvPWJa9GWeAlELgnIcq0QBpWvlQXcovC3Vf7JE9PmXcmA24wdk3tTHVuhw2TfxMZSiZg4q45s0DKX
	kn7Dp8c12wq2KkN/D2UjFO4dWzuopOQoZCYBXYZuY/Xd20g+qmi1ezJgzaIrPNQFUaY/kgzP4eRDu
	kO8jAQi44eQVUckVTEkbEagQMExelEGv0H219yDmvQbUpUhYai6+98PwkElbIsH6RN5SMcmZ1ndjQ
	FQn0STARNDYXVRXPapygE/vhOjKHbnM2xseg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xMIqA-00000008dbR-1Mqm;
	Thu, 29 Oct 2026 13:38:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 29 Oct 2026 13:38:18 +0800
Date: Thu, 29 Oct 2026 13:38:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: sashiko-reviews@lists.linux.dev, hannes@cmpxchg.org, yosry@kernel.org,
	nphamcs@gmail.com, chengming.zhou@linux.dev,
	akpm@linux-foundation.org, linux-mm@kvack.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, rientjes@google.com,
	willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v2 3/8] crypto: acomp - Add trivial segmentation wrapper.
Message-ID: <auLbyon-KaV5Sw5_@gondor.apana.org.au>
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-4-kanchanapsridhar2026@gmail.com>
 <sashiko-outbox-188655@kernel.org>
 <CACpmpodu3C=uYH6dmFM-xkvdJxiRDjamRKs1Q4jU6_KKjFWNqA@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACpmpodu3C=uYH6dmFM-xkvdJxiRDjamRKs1Q4jU6_KKjFWNqA@mail.gmail.com>
X-Stat-Signature: z3pfu8ti187a59sibrmgwi6wdkseopzt
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7FCE3100002
X-Rspam-User: 
X-HE-Tag: 1793252312-975427
X-HE-Meta: U2FsdGVkX1/opzm+s6LcMC7pWWLLsSyXMfX09gw8hfYlZHBskaShlkBbnD/nh2YHuhQ1/JwqN6wXhFHHtBd/bPf4h4kIa61LkhvLB3pHcJ8dtuLCEZbxYrnRTrGxRRsb5dRqDlRJnV21QlYIb8CwvZ+5qqYtgyRPkIaExy9V3+bOOhfP3WkdgV5/ZYmJfMNrC/4z51XE8P6P5LLsYBPA4ill4t2AU6ChxYpw+bIFu0X/MAYNl/RGxNUmf91AGZrauP+43Tvez3i1LWRfofFJ2USzgjkzTYUs1EE/TLdAq954aJTifYxhiClbsHi4c7m5JdqASAyb97JSMdIAS6/1X45SLqjtfGTRP6Y6xoa2dt8xr1VdwyVmBAeA+a9xgMeLv2d5/zJMA7jseDUyVQNOObWIOkedRt7mOIPVR2UXLj/2rtF4MNC5vl5v0TOkN8fmT41EOBM8d/BS+cWACKLoYXNNv5cFgRg8Hw8Kzu+YU5CpuHX4eVp6IyLeGXD6R6ZI0p6T7YoOTrEgBeCMCQkbIfFjGVR4zcLwOjxUSCaULtpIBFHJjxNQfpAQKjJRmbM1HOTXUjZugW3K3DLVbAf0haOSBHQFdQj8nu0Pcagxgc2Cell6DKRTrbv+mQBGpGnQ1HDBTq1h4Mv2hGyEdmS09gwWjEn0xNseZApZ6Xu1DPQKHbz4TlkrD0xnIdQ1yv3WqCgWmuYSdcBeR2fMFZQ4LWKiNHKMlIrvQ7GZMJbCAO1P/qBrKt04pjL5wvTLuaEEtBMF/es5doyfV7eGcgOTEIanQRx8SeJjUJOyJEQ+ClpTvB3bJPmyTETydd1WQsWblZ/RKpX1xo8VbSNKPaVqmwAecKcpo1bQlFr2gJbPrNsaJ23Nbh840mctfg1EzhoAV6VJ/FvpqjLUuSQE9jRmpg1006k2v/pok/y51nzsYK+uWXaasUKbypTViJHYFFxT4x7B1Wf7UCyadpmtqMu
 kepx7tyB
 y2EaFEgHkF3VmYUkQqea1vm62gOKTZ8Q/m6skiKEp3QR22xmTvm7pZmONI23g5oP/yGOdGMDHfdmp8JLHPEXyTDGq0UlRJB8Fcja0YeNY7kCcfaAYEpImCl8wODFUYvQU5feo4szUQx0slTT5C9MkE5lXSVxVXjJdxemLG/ozSkb7/iECJnCE6M4uhIgApAObOKBgOb8v+vYNDXbIkwIZsdnWkFNBT0HN4wILJWmmWEcDMnAlI3+fPWUsQK2jcnX8YuiEgFDMgyynycgjMC3UIFJM+aPyr/GfUp1k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 10:09:35PM -0700, Kanchana P. Sridhar wrote:
>
> Herbert, can you please take a look at this and suggest what changes
> need to be made here, since you are the original developer of this
> portion of the patch. Thanks.

I think we should get rid of the changes to state->flags in
acomp_save_req and keep it in acomp_virt_to_sg.
 
> Thanks for the catch! Yes, I will add (!acomp_is_async(tfm) &&
> !acomp_req_on_stack(req)) here.

Why do you need !acomp_req_on_stack if you know that the tfm is
synchronous? IOW, how about just testing !acomp_is_async(tfm)?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

