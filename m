Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 339B8E7E340
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 08:31:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71C3B6B0005; Fri,  3 Apr 2026 04:31:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CD996B0089; Fri,  3 Apr 2026 04:31:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E3196B008A; Fri,  3 Apr 2026 04:31:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4BD726B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 04:31:29 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DD61C8C070
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 08:31:28 +0000 (UTC)
X-FDA: 84616575456.26.D1980C9
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf16.hostedemail.com (Postfix) with ESMTP id 33D9F180005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 08:31:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EOiUhSgU;
	spf=pass (imf16.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775205087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vPHnX95L4zARAb9iKb7/VH3eLKj/XM5UcYBpATOx7fI=;
	b=uYAZ5SWU7rfPe2KwqlpEPYcvwOFWqsQRnF+VXDv5QXNS+vjbnYn1OigdDF6MTDbZpDv12K
	yZaxMzJReGTLB0mbQtzdxeA/iQllvjurK2vvTgmhInzrNjJkmDJBPj+dEjCAdqiC+7SFdE
	oeo8L3Tl0Cj1O5uRzx2eF0YpTtZBQQU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EOiUhSgU;
	spf=pass (imf16.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775205087; a=rsa-sha256;
	cv=none;
	b=2UtIx+e39JrO59vdnp3/0WLFBLOSBxGNxAiaPc1KuIVOQVh6EQeemY3O96xq4+vZjnRB4B
	htWUxxfrocyft5fkpHQgA3Abo54O0vH/SYEOSCkNRmXAQSpwFOj3kFWi9tIV3/zSZQfTsS
	eMpFt7iPIkEKZiBGTzxldoOH2L0V27Y=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2b23f90f53aso15940305ad.0
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 01:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775205086; x=1775809886; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vPHnX95L4zARAb9iKb7/VH3eLKj/XM5UcYBpATOx7fI=;
        b=EOiUhSgUl1pmteyDEIMSQolvqQTlMaxwi8bhj7DN7Hr7MwK//kwp3cUvMq4OXvqjHg
         vSIN141iWNtHYnEy/TvgPbsrxMCbegNuUnn9W3egmqLDYHsf950GTBOMr4NkMdKSSba3
         oMdXFUFUA2G3Ekud0lBxwDlcLgakQyobGvQD0rU3judwI+FSaQKZ5KnXHjaloy4zM+3S
         KK0yf+yOXdttEBePna79935gkLAFNwQIYRc2mheOd9Z9p7WO8wVN3oJHtqiQYScNWTXM
         4wPQr4d+KwT1YRRVzpmqPYjOo6icMyns1iraruCqHpOjz12/qj+aXA8zoPirZjxPaMZR
         dqFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775205086; x=1775809886;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vPHnX95L4zARAb9iKb7/VH3eLKj/XM5UcYBpATOx7fI=;
        b=f+68bX5mlGbsGgFmsbQUop7l5CO/qTD8+yrICCPsyribSMQ4GTMVKLU6VuEnJWuQOj
         EQf80mxFbdkIX5h4nrSs0fl4z80Ihb0aFivg9yGPPzyk6OH1383dhxfKRqRb62QKujXd
         eoRuWFR/AUoExZWSAQ09XmVnHQPoQXQYdJP5o4GVvesA84fKPaRUC3q1JLGok+owDBUu
         DRU94Dt7aY6r1nhpdjSxxxrAumVbFx7iCT9uxdFIZXiCt/qAX3QrFONiV9TzI0GuHs8C
         6PsN8p57TEeq/IEcn+cwoUE+j+cjwIg86B5kpQRPFTApDEYGrtgrmXO56CCpgOrWtN2J
         wFCg==
X-Forwarded-Encrypted: i=1; AJvYcCXcaQJ79C+Bs7l64uhAvbzfcNh53B24UdzrayL8RcJoxRibWdY4u3SLIU5aDLcgbFMrLJYhOMtv4Q==@kvack.org
X-Gm-Message-State: AOJu0YwzV8/lflDOnS5xGseTIjRoM1f7inglB1Savd4LDLKmwpniLkl7
	AhgmnD2L3JmJ0UaeNTeBqN0j/bf1cSxVhLZk3dv0Y+0DNFC4WrMCXlmH
X-Gm-Gg: AeBDieuGQbexDdmG5SUBZ9trTfiGkBhouWDbD66Ol6zb7LmptwihSguzU3Mv3sOd2fn
	CSMdO6D0eVEPEFTmQWH9GNNcuqhgd4INY48ld2GnyC9KeKzk46lcSnCUFZnXcVpcDRFYmUtmsjh
	stmw6I9XBtPI4vcy/+7hH/b4ocVbmxsaskm94zrmkTfZsw9+IJeLK+C6yrXJJK/JlurPICUJeFc
	d3JDs52x+iUqIi2jnWILwJlUt9D2WRxg1Vi4TIHM4Fml2KU31fGH5eGp+w4aqFtkPo1q4KrTbnZ
	y6JqpXKGXP/jUwazKOX0jE3lVNYa4D+gpPXHdjZ50CmbFPR1FnI5aqREElp1cbDDuT4OaBxf2PG
	waznBmooedwm80vTwISbeuJR/N5Jr9SFzWcbkCtTu1niz8RmRpxh6VIIb9id5NG2TlR7+i+wzKL
	HPnihjr1y8VXePBeid7OnAnlI0Nr9JNGw53W7Hlr3EZyvPzvrQt/A=
X-Received: by 2002:a17:903:4b07:b0:2b2:51ed:4522 with SMTP id d9443c01a7336-2b281833d68mr24607425ad.47.1775205086057;
        Fri, 03 Apr 2026 01:31:26 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b27472d280sm54193015ad.17.2026.04.03.01.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 01:31:25 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: aethernet65535@gmail.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	sj@kernel.org,
	stable@vger.kernel.org,
	yanquanmin1@huawei.com
Subject: Re: (sashiko review) [PATCH v3 1/2] mm/damon/lru_sort: validate min_region_size to be power of 2
Date: Fri,  3 Apr 2026 16:31:25 +0800
Message-ID: <20260403083125.5654-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260403052837.58063-2-aethernet65535@gmail.com>
References: <20260403052837.58063-2-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: fmgkdmfph9izemzyzofo8y6op3a4ho6r
X-Rspamd-Queue-Id: 33D9F180005
X-Rspamd-Server: rspam09
X-HE-Tag: 1775205086-902159
X-HE-Meta: U2FsdGVkX1/wqjqHcutI3RvEp7257kU8F+59G886BaSKfKVFM9Dk9sqKdwIsoNe/P76qEFBQFvFlvWdaHLaIM1mRhuMTO2WE4p9nFD9ZAX5LO0PsQtRxTUvVWeICjOQP6mKyDX/UjfvFGNwSvQc9kmmDlfDqmzEfezhvFLSntV4PXcerFb+zOYals0vC9egalphA7/2i6xc7iOTunC6f3VvycbRX9Rk4tCCqepJD7agD9PtgFutPP7VjtsGHIY5YCHkxAxkZO5oB5ay2WqDENZOSMuCjxE6GVBCfvaqaL866tr1N9Ocg5br1EtJ5nr4LcNb5kyfdn4BdhgF3rR383ez2mGYEMiIR6f+jZF6Q51UZbwxafNxOwpnuxzidmY4/CIyQn2OTsxg6++7nKR13KQFUspSgbbuf48UdI1yQjMYtP6C19ht1r/9VQUUp5f2BDSWlwfChbe8opqMylu245qyOy5y/3yaWmiK6JBMXk23iEpglNVb/giBTZfKzf+pSk8bAX6NWXZzY6w+h8nQ1rZcFedrUQoOLrd+KMJfCucH0nvHK10afr/xnkmwe6wSSjG3lKPZ9SLt8ZGZjJtqYTJYmPCmzS5CN1n+5oocoNyXwXwv1OtV3WgttPFJdXTQ/WnQl7Fnnchqpe2tkRfz/3cfGWaZEMX3/PXlafrU4/Nih6o8TvQCZM+/VzuWMFReg1w7W1qJTYeopeMCe9+LLKA6MCvGRoZbppGcEa+QAg92E/ZOg16/X1xCZtsPnARE+9GWDd6S56AHofta0Z+FEz4aNK2UJbqHb8fIpwAvHHHcOkEPWWak8zDE0GKlgv9cYW3P2dDwIki2MTUPImMPI1zkzYAHEC3+zodocjYR6wbr5aHbKzZfQ+IcaE1VcOUB0mtvgfNvoIZvFXR+qkCoMRRF/z5rfv99uqHCkhvSTR1eMm3Nk8led44ORXpk57xWFunm7nxxLrlqR0/ugTHW
 mI0sNwW9
 MHfma5fj6vHQpsNLBDZkcND4Mhxnq62Np2RsBFkuFPBXTRs1lp5x5a+byiMbNH+jw6DkW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260403052837.58063-2-aethernet65535@gmail.com
# start of sashiko.dev inline review
commit 525a0116b6d91612e679b30ae84e489a7540edbf
Author: Liew Rui Yan <aethernet65535@gmail.com>

mm/damon/lru_sort: validate min_region_size to be power of 2

This commit adds an early check in damon_lru_sort_apply_parameters() to
ensure min_region_sz is a power of 2. This prevents kdamond from unexpectedly
terminating when given an invalid addr_unit.

> diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
> index 554559d729760..3fd176ef9d9c1 100644
> --- a/mm/damon/lru_sort.c
> +++ b/mm/damon/lru_sort.c
> @@ -294,6 +294,11 @@ static int damon_lru_sort_apply_parameters(void)
>  	param_ctx->addr_unit = addr_unit;
>  	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
>  
> +	if (!is_power_of_2(param_ctx->min_region_sz)) {
> +		err = -EINVAL;
> +		goto out;
> +	}
> +

Instead of adding this early check here, could this be resolved by fixing
the stateless validation in damon_commit_ctx() directly?

Looking at damon_commit_ctx(), it currently sets dst->maybe_corrupted = true
before checking if src->min_region_sz is a power of 2:

int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
{
	int err;

	dst->maybe_corrupted = true;
	if (!is_power_of_2(src->min_region_sz))
		return -EINVAL;
...
}

When this validation fails, it leaves the active context marked as corrupted
without making any state changes, which causes the kdamond thread to terminate
permanently. Moving the stateless is_power_of_2() check above
dst->maybe_corrupted = true would resolve the regression for all current and
future callers without requiring duplicated validation logic at every
call site.

Does this missing validation also affect mm/damon/sysfs.c?

When a user starts DAMON via state_store() -> damon_sysfs_turn_damon_on(),
the code calls damon_sysfs_build_ctx(). This calculates min_region_sz and
then directly calls damon_start(), bypassing damon_commit_ctx() entirely.

Because this bypasses the is_power_of_2() checks, kdamond can actively run
with a non-power-of-2 min_region_sz. Core DAMON operations like
damon_set_regions() use ALIGN() and ALIGN_DOWN() with min_region_sz, which
perform bitwise masking that requires the alignment parameter to be a
power of 2.

Could this allow userspace to trigger incorrect address boundaries, massive
unsigned underflows, or infinite loops during region splitting?

>  	if (!damon_lru_sort_mon_attrs.sample_interval) {
>  		err = -EINVAL;
>  		goto out;


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260403052837.58063-2-aethernet65535@gmail.com
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260403052837.58063-2-aethernet65535@gmail.com
#
# [1] https://github.com/sjp38/hackermail

