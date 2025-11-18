Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0B61CE8D6B
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 00:34:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3C288E000D; Mon, 17 Nov 2025 19:34:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F13818E0002; Mon, 17 Nov 2025 19:34:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E51158E000D; Mon, 17 Nov 2025 19:34:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D1FB38E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 19:34:08 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6ED2F1A0207
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:34:08 +0000 (UTC)
X-FDA: 84121855776.26.59C22DA
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf02.hostedemail.com (Postfix) with ESMTP id 91A6980003
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:34:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="i/MHTvfW";
	spf=pass (imf02.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763426046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X9AZpi4rt1ui+XTsMMyozDrxAzlPBqocMCdUZQhvEGY=;
	b=HQbolNXghpQkt6MggQRio5Zv9lJFXA+0VuW9nBuP2+XkSgzvLXaBWgQJzcqCYy0fd5YIeF
	Lfj330CM/xRoMBAbH4HcLz7wm6G9XSoWYQN1Wmjmv9TmoeTq4X2tvE6EYjMuqlohkWTw4T
	ktxHkiJqTLTqrTiZc4xWstzjgnkt7tA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="i/MHTvfW";
	spf=pass (imf02.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763426046; a=rsa-sha256;
	cv=none;
	b=go9LHuWAn66+hHs3Sm8kqZfos1P2IQDV6vwGt8CqlyIH4aoDa8iUHZQdu8AmIaQyDIOwld
	TR3M3gjc4Ef+gvrdCltpCY1skmOMaB4nzHT3rxW3vaJK1L67D36YnsfF8/2WqjTMrkOe7J
	ji3zJfib62mUm+biMc/wQcWiSHG41DQ=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b8c0c0cdd61so4359463a12.2
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 16:34:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763426045; x=1764030845; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X9AZpi4rt1ui+XTsMMyozDrxAzlPBqocMCdUZQhvEGY=;
        b=i/MHTvfWE47unoTdc5SXRoroyZRNUX9t+mB0f4GlsxCXX5YrIPY9zak1jEaX4oVPKA
         RsOh9n3YokuycN9YC8B7fqKr4JlfPD5dVbWErImF3F5Vt5FQ1PMdhwF0iQ8KaBC2SK3U
         g5wd0kDO85fDfKe3ie29v8SEW1iq378QyEL2VNRKVvWvkTwAwGO/41CZ3XeCa3A7pBti
         asXqrle5/tZLSQz1gvPkATN+MqQ9GuB7GijkRd+dyg96oqNWnfNR1zUbxA+g49XteRv9
         6Y+gp1TPwgjyk6i+OdwYIfTw9AsQ6pNx50a54tdEtom9awmQanXBvBiqzyat2dxHspNB
         Qs0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763426045; x=1764030845;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X9AZpi4rt1ui+XTsMMyozDrxAzlPBqocMCdUZQhvEGY=;
        b=tcV7+vFx+f9Q8x1NMiJXBa2iNlso6sBdL/GJS4/x9leboIcytbFxBFyQ5c5n+E2PmN
         Uq9o5HknYfmyNjVayHq2RWbfuZ4y2/TfD50WL9717WrStFpco9ninoTbEL2Ek01bWN2F
         TOlw+kAL7UgqNmownbVxcSPpjOWpTbaxMT4+V0bRlmqPW/01HtaCfyzXZA6RF+jDcDsf
         +QDyr1zgV2mAYk7hibfc9SfXHkHXZc7Ep0BQh3eTtcG6QoNXcjeZiDkN8VnnFlKMG4fZ
         meL5kMvRgjAvieEyJDux96WtitPpmBffIyZv8pXuBl96BmJ0/QsNwSYA7xgfned3qXXu
         PGQg==
X-Forwarded-Encrypted: i=1; AJvYcCUlKEoYQguAEkdd4euPACMS6uQkMy8clIu2DSfeKlsf93l+4KZPJ6RwG0e7q9j/b3rODjG8CFc5gg==@kvack.org
X-Gm-Message-State: AOJu0Yw9+1YoxRTLIAy4EmFM7prAbqfS1vLSkKRK18vaUrWcznF//SJ0
	Y2kUFezK6QCpivCj1XjVef+ONP149J8mHne8zUWBVMoV89Gl5AoJXN3u
X-Gm-Gg: ASbGncuELj2VAtRMPSN7X2wDpMlfXtRskO4fOTNYdSb2m4m7EyAUhrgyZs/H9vqdjvc
	uVVstSYHOHeiNjFlDvu5CNscxKP1y2BMZiREP7l2oMP7v1E+oxHigT8Iiitdm6L2XLucHTy1Jhf
	gldbvkR6VCKlE2LwTF4L8JswL/4U6U3UYm6r9mcE978DHrjW9lv0i9DwwtzWaod2klFthaaINiM
	NFUgZlPHHKg/5zoGOoMVNwb0cqfupCoHi6Jv01lrME0RIzLJmFQ153pGJeW04EOCo0GijWtrNYS
	NuQAtVigMnlcgIjBt+PzO/VDyCndlMjtAf+dDFvjB5uzfid90R8M0BQ9qVvMKmOkCjwEWNCqJ8y
	9xwtu3q00MkyuNBl4QAgxQQYpvG03iiUn+8fBF/JXDZpcmrdhTChWS9c4tHuYI/u74YYLKBo9tT
	jPz1paAn5BiLMBhzLgWVkcxoY4UB4VWNofdhsNidvE2mE=
X-Google-Smtp-Source: AGHT+IERhdfBGNNDmKwPm4AkzEyQK0Uu9QznZufddn/c8xEntSCPx/v/Mh1bHvhpFcZEPkiU22WElQ==
X-Received: by 2002:a05:7301:a28:b0:2a4:4527:1f0 with SMTP id 5a478bee46e88-2a4abb30665mr4073482eec.34.1763426045123;
        Mon, 17 Nov 2025 16:34:05 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2a49da0662dsm52726368eec.2.2025.11.17.16.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 16:34:04 -0800 (PST)
Date: Mon, 17 Nov 2025 16:34:02 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: david@ixit.cz
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, phone-devel@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc: warn only once when vmalloc detect invalid
 gfp flags
Message-ID: <aRu--sVhXRWthmhe@fedora>
References: <20251118-only-one-vmalloc-v1-1-29f8eacb4605@ixit.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251118-only-one-vmalloc-v1-1-29f8eacb4605@ixit.cz>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 91A6980003
X-Stat-Signature: uno9z1w6ofpxwuseho4erkmi7w1a9361
X-Rspam-User: 
X-HE-Tag: 1763426046-464591
X-HE-Meta: U2FsdGVkX1/CKAF0lzsKbzc+OKazaPuilrUzZFSQWjxZEZkKFIQbhjAzh7TZw0r5ooQpE3xBI5BKjsfFhYseQlEESTehRWDO9uIkJLkhYU+Q18RRrZhhxyQ8vqbGEy/iNkrMTkNqNHSwHxbbNRHNr1SpM1wega9HS4lZ+QnSaNy03UmAR8bliM0drt5t2wirWcyir1Z3MTFB2S8zGHLvJFlU4ByMUVo1HxOpbFTRWRtK4/jib490KKNgWmJJ8qZ2zYJeGAOMXd7MpFt6uU6zKzqeFTqiVeezcO/dzOW0rBxkfxEPHP9J0n7OqOpBpArTBDrpqe0nHEEADV2k7cauyym99PXdfrqWRTk29HKMzrTcesDacCgKnmF/PvbrPuR16lMANBVhU9xolj3hP0AIltBalkY6K8sKwCzo6GvszgVro7ZZNoBHcN3WxGfZvUOBZBle9p+Sl6tnRi4E/d5drbQod33VBHP4qG1502M7u6UiqUMf6viYdtlppcUYRrQcNKFsGfnL/GvpT6tAJ3tnKqN1ZJCjcBts1tkwWBWIt1Raw7YsoPqlhposVokq+MNzJcEe7gKL2wtJ152CyxaPKsqQrSev9XUiHjLbriZk9eMrHFC2zCz/SZxjmZj0ZWdm3Il1JIF12tiIchEOYNVq7niCPp5yFTXRrTXTA7ECkoiPy9rkzGYVmxHARwof8DQyGhABPhFFWF/PIRq0QEDJY59K0pvkemrg20BAHZMVDpeFu9rtxFc86vscTMmAeYr9Yl62xvZua5tNKyq8fUt7PQD2Xr82sFHaQH6kCHJeNoxzUakMqpxDISURSa5tyTJFPtiTy/79IqjqoGjs3ENdJntlEo0V8bqNqqe/0/603iRSx3sxp8UUhPjRYhH4GUIRLX58/7+LLbmUGNBequMYUWdnWIcVGkK3V9dymoF/OmKUMS00ptkPw9wvkfDdfSIc0iUGIj6CGuQWMhzoHyE
 GLursFRg
 HzRGBt0uJpDvPbVCr2oZw2KvwoCCwi9eFc8aGcbwtVcNkmlcC5Aiq+qY1Rqu9CP+jTQUuYKc4yG1UJmdIMQh+i9R1oebGWMU7BYoYiq3IKdTtJtMTN/xFtAWKfQr3s0F9GAbTBgxcg0YPqoHfdxTtOchjLmINo9cbgVR2mdQjuqlqQjqM1T+FQxOu1x2OOW5eAnMEU8718SoZJqNMzB0gDWxZLBXgRPscDQq15zKZJY6xvQIAJ0n9PfIfFce+p66X51Xg/YGBreMXuI4p1t2BcT3u8jyixn7nguJPlV9AQtYPQIwUUf6yHTnFEZMZP2AeIjhFk9GTFNq2pCYC5DV+56jUR3jhSFSo1VrWVs4gNCwA9HwyRo3L8N04h4RQPT8xIXQt9OqC1uFGVtbh4vKeZKcZLhmC8Qj8ri7bCm/ztaCJ36hkO7L/SZuMRbjJcTbux6BXPgE72Mh6tv4i/6/+M6MpOA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 01:05:57AM +0100, David Heidelberg via B4 Relay wrote:
> From: David Heidelberg <david@ixit.cz>
> 
> Without WARN_ONCE, the logs get spammed immediately after the boot,
> on devices as OnePlus 6T (Snapdragon 845).

Do you have any snippets of the logs? There'll be a particularly helpful
section that says "Unexpected gfp:"...

> Fixes: 7179b2256315 ("mm/vmalloc: warn on invalid vmalloc gfp flags")

For some context, this patch begins enforcing the gfp flags passed into
vmalloc(). If the logs are getting spammed, that means the device is
calling vmalloc() with some unsupported gfp flag, many many times.

> Signed-off-by: David Heidelberg <david@ixit.cz>
> ---
> I'm not 100% sure this is the right solution, but having WARN_ONCE or
> rate limited warnings here helps a lot on devices as OnePlus 6 (sdm845).

Can you check if it still happens on today's mm-new?
I just sent a new version earlier today that also masks off
__GFP_ACCOUNT, and had an iteration earlier that added
__GFP_HARDWALL.

