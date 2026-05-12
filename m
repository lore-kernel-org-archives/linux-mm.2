Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6A0CCD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 12:58:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E86B6B0096; Tue, 12 May 2026 08:58:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BF9A6B0098; Tue, 12 May 2026 08:58:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FCDE6B0099; Tue, 12 May 2026 08:58:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 02AAE6B0096
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:58:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9DA928CEDC
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:58:25 +0000 (UTC)
X-FDA: 84758771370.08.51211B6
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf10.hostedemail.com (Postfix) with ESMTP id CB6A5C0004
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:58:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GGZSCf3n;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 37SMDaggKCJgB24CE2F38GG8D6.4GEDAFMP-EECN24C.GJ8@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=37SMDaggKCJgB24CE2F38GG8D6.4GEDAFMP-EECN24C.GJ8@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778590703; a=rsa-sha256;
	cv=none;
	b=n+zzCZoGaU9S1jw+RFEzmkf7PfDYVm+5oIlWNJvVySolYer5w2kYsdG1KIoZ/fLUrQTLJb
	HbGqNLHFhXcXwqP1QP1Z9jRr/IBzH+f0gVW+wxiLjE89NBE8woO/tEl6J6WGJ2fR3hJbjz
	Qt54kCIz/CFknWIJRN0ciJjgZqW72bI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GGZSCf3n;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 37SMDaggKCJgB24CE2F38GG8D6.4GEDAFMP-EECN24C.GJ8@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=37SMDaggKCJgB24CE2F38GG8D6.4GEDAFMP-EECN24C.GJ8@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778590703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vDWMnr041UI5ryil+k7XvoK/2F/EkGtTQwaeX0kDxi0=;
	b=WxTNQ1Yk+D5n7c+PmY8gX6cUW7rQjTeQ22EsG9EDmI4lFaSTnbDyTi/aDP6Ic0N68VFuA5
	g9BHG1CJmV5FAFCnw8amVFSu8w6WySPuK0zkRvzTwrqKvDFfV69Lt28ARN10YSsHNdzGfk
	7bFS+7Lato9KKq483r+3winN5Plts2Y=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-44d9ace59efso3653621f8f.1
        for <linux-mm@kvack.org>; Tue, 12 May 2026 05:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778590702; x=1779195502; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vDWMnr041UI5ryil+k7XvoK/2F/EkGtTQwaeX0kDxi0=;
        b=GGZSCf3nRenSodB5J9lPeP8Mr7y8SaUPxnJF2PfSSC7SRMR6M1ofmSGtU/6pUi1M3O
         ewslnRQLZBUqd0ESuPHP/IjHChGPnFOel1waumah5Nlb2AepTlp5ICEHlGRX3vR0Yu23
         IqEJ8sLzFP6i1relKba7yxIcv/cYId1G88Pc/sbpPQMYUJK7L2aXGz44WaD11Ce3e1Vr
         4C9HNGJEjL4aSohdWgGSO0MhWYwlzhElrKE6tf4nvGSXQ9fYMsOmBlzvtnVZZrlNgu/W
         mFH+6BUQVkPtf6tF+NFwZJ63ePgEA2GyZQRa1LOWGL3pwmtjSknHofyzMGFpoMutRaQM
         viWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778590702; x=1779195502;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vDWMnr041UI5ryil+k7XvoK/2F/EkGtTQwaeX0kDxi0=;
        b=lUHmAdMiMWpyZVtcf1jyzYH74/Ln0PKCUCwFY7go9hN3npkwhl37gtwWJopeDxeREH
         dtdvyZw3Um7HeNDAJ2Z7tIac9m9I3O4ggujLfHSjrIe67Q4lN6SEWPboWymeGk5l5fZ/
         UPCk6FWGoDqpF9Jv42XJ5nzzK8/RegvPTF8RWDuBFVmCfP1Q/UC2gGoUEEOQANkUUMPN
         9B72qPdcZJX1fhS4PoTd2pAL76wAjP4bRJt5fhQ9DCL4BxtuPPq1D+He3luBO7j0MiSO
         bKyeD49sLyOgPQTWDd4xbFC8ecEUkWazeVURXpaQ494IbL/APcpW3UhUa6ZVUrqlb5BA
         cTSg==
X-Forwarded-Encrypted: i=1; AFNElJ/ifIsvH+e/pE+usdKEZmPKSJtGWBzWDc8dfRTOOqOj0Lu4+RSVkTDd4DmdAAoWApMhQsjm/jj/Lg==@kvack.org
X-Gm-Message-State: AOJu0YxkYlIoTxNWKhYcoFACujb89h1VMDZa2K2NqZsF6vdg0Dk7XUWj
	xRUKsggiO72Qbktkn+nHLYCqIrYg7HaW8D/MpfDv4jPF0LXbTZb41z+Ar6FF/gmr0j4O5Olwmnt
	+lvXzjzgioVyabQ==
X-Received: from wmby19.prod.google.com ([2002:a05:600c:c053:b0:485:3aa2:da59])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8010:b0:48a:5339:ef0e with SMTP id 5b1f17b1804b1-48e70687eabmr216165565e9.3.1778590701567;
 Tue, 12 May 2026 05:58:21 -0700 (PDT)
Date: Tue, 12 May 2026 12:58:20 +0000
In-Reply-To: <20260326-gfp64-v2-0-d916021cecdf@google.com>
Mime-Version: 1.0
References: <20260326-gfp64-v2-0-d916021cecdf@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DIGPS83BGEGA.5I7VLH8TV7XE@google.com>
Subject: Re: [PATCH v2 0/4] treewide: fixup gfp_t printks
From: Brendan Jackman <jackmanb@google.com>
To: Brendan Jackman <jackmanb@google.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Stanislaw Gruszka <stf_xl@wp.pl>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Allison Henderson <allison.henderson@oracle.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>
Cc: <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>, 
	<linux-wireless@vger.kernel.org>, <kasan-dev@googlegroups.com>, 
	<linux-mm@kvack.org>, <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>, 
	<rds-devel@oss.oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: o5bcq5xze3midsffdpu9jimsjpio3wpi
X-Rspam-User: 
X-Rspamd-Queue-Id: CB6A5C0004
X-Rspamd-Server: rspam07
X-HE-Tag: 1778590703-30139
X-HE-Meta: U2FsdGVkX18l66Wez6fqgispubGUAb9M/QT9ZgG5646ZQbHMLHDXYIVa1SQXvxD55ONXCasEvzq+Gg++5Fu+7SfAY7f0dt0WszUEXpm38uSZRooTofR7Q/hr6kXe7/BU+FNl4252h8R1cqEvJLNzOjLeRBn18kLyQy30pZj5I15DfwCj25mOR/ilVkH7QJdrojgQEwz8f3KFqMtqfr1n9dWNwXgPoCWLoSVH286IpvM8UCpzRl+h4OaMzhkrykeLP0g+3VCk47OkLOuHXHHhiiwAZoAIfCIlD9Ze+UedSIorGzB2JzbBFLtr0NNYXXUHxxyWJM6hmNFqhIjKFBtZl/hQVUNb+H4vtrnCAR90ZE1tvi2mMhADvBXXYGzVDJreTBER2AxOZcF8/sG71pBEWdtgfB9XpNi+oxvQ4mEgtPdLwrsSp2QqE3tm8cIInBMIzHvwk9cmp7L8/WwGdaDRZF5dc0WIGFhjvx4R7E1oDY60uNZ3/5hFAbWyWND6SlD6QVtGV+1UsOOSmb9bguP2oqxIy358EhAxRqyCqsqr68XUVF3Su6p73Ac1x4REiP4CkRrnSfhs0Fu9muTHoEQfCg9Ww/h8JuKx7Hjhw2HP6Yyozue7dmbVQ7UGNOKejRre+Lt2gmipJsgmwfJfr/d8/lI9Tvtmb9Hzc/5xjes9kEeNIwMF9SEYaFD4VL6MiGo8b1rcP8s40oeo9CwDkI2LFMWhKz2OPVnICpQThoVHhgXNKf9LhUJf7+9xDRPl/cnimJUJOlL3xsOijGEg1uGOyCBFE+neLIYVbIQoZIsLVlmpmJbBnqh/cTqfeqcsTk6vAy9tVAsZAYI4gODci5sCe/rLG1Ua8/cD200U5HDh4eurwbKzfpgVcQPhQIC9q+8bXt41/mMmQbsd5icY8rL50Jppg1feD4Y3OHS3e17kH3eGo/vs6DodPOHWnHEkuIoTV4SzCy1GrgeNUDG9kfq
 zzqiNo2G
 L/Du3aC+PRriTk1LVNGd9f6Y6Bd56qMb5qabKUEkFsvKn/H7YH71CW2s/8ygGAdaJwm7akzfzAxjdFADSxme87v2HhN0fQMklHTt+Gs+9zYtrGb4o9sVyHZdkNOUDJXvvd/5Xky6eKO29X+YEPBe8lKL6MjxMRpGDOSnFz0u8owl6K3xRAFFeV73+ZX2U0LOAPEkPz1E8uoI4c3Hmv9+tTKPcf0RU0iz6sA1u/PDHRZ/ctnxGgpy46zLhjUcGs3vyU161S3sfsEELkgW/wV+PO7rvJc5HqhqqLOt5eWivmrugYGwvYUqZk7aIaj7GaScaxLEQx7jW5Iu7ASrEqCFuNi57L8CUYkMSXQaX4CFRXdg6lGTL2N5A8hR7LLZ+KC//PQ6MjwhrP4NJN4yc+L/VUDTeE6x2j5w+jUiKcAk6aRPxEzhYwZnZ9Z7uwXgqYJJY+rmY3s88Gq6ITXRjdqHPxSOzYU8fXHP35vjeqRzPCmjYMUgnbRssv5XWJpqH5nUkVmbLA6UIc0K9RmgbGXLyNY5JiGT6UW075cE5jxD1rWffj7WwPNY5v4xv1hHamrpJiFyY2NlNCd37yGHoXZqwCy8coIprCMNKkN0W3VjIxSIyfGG7qmSv14oQUv5GDSOmdgzX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Mar 26, 2026 at 12:31 PM UTC, Brendan Jackman wrote:
> This patchset used to be about switching gfp_t to unsigned long. That is
> probably not gonna happen any more but while writing it I found these
> cleanups that seem worthwhile regardless.
>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
> Changes in v2:
> - Drop gfp_t changes
> - Add correct CCs
> - Add minor fixups to preexisting code spotted by AI review
> - Link to v1: https://lore.kernel.org/r/20260319-gfp64-v1-0-2c73b8d42b7f@google.com
>
> ---
> Brendan Jackman (4):
>       drm/managed: Use special gfp_t format specifier
>       iwlegacy: 3945-mac: Fixup allocation failure log
>       mm/kfence: Use special gfp_t format specifier
>       net/rds: Use special gfp_t format specifier
>
>  drivers/gpu/drm/drm_managed.c                  | 4 ++--
>  drivers/net/wireless/intel/iwlegacy/3945-mac.c | 4 ++--
>  mm/kfence/kfence_test.c                        | 2 +-
>  net/rds/tcp_recv.c                             | 2 +-
>  4 files changed, 6 insertions(+), 6 deletions(-)
> ---
> base-commit: c369299895a591d96745d6492d4888259b004a9e
> change-id: 20260319-gfp64-7a970a80ba4e
>
> Best regards,

Hi all,

Any chance someone can take these?

