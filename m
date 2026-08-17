Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A418EC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 12:14:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B11EB6B00CA; Mon, 17 Aug 2026 08:14:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9C026B00F7; Mon, 17 Aug 2026 08:14:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93C846B00F9; Mon, 17 Aug 2026 08:14:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 685FB6B00CA
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:14:55 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E9CB880622
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:14:54 +0000 (UTC)
X-FDA: 85110655308.19.22F45A1
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf15.hostedemail.com (Postfix) with ESMTP id DA817A0003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:14:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=RAQEBQUg;
	spf=pass (imf15.hostedemail.com: domain of nik.borisov@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=nik.borisov@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786968893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=01zYHu0teBLcC0seY0nFh6OS3sPomq7wlr9susi30oE=;
	b=bjiKLO7Ro1zhe1qN1V1ewGVYS6uHaBx6I267X2gQTgADS04bnQSP6p5bgA+gy85Wa+VpMr
	0vmt14ZcjTvlq22oYxrc5D7x0FJ6hiLEKLuGqhs418qz68WZrtZccELI8UrgF5KJ/vI4mD
	ygQwY5kTPuUcyLrGlF7tW7gorUMwCRQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786968893;
	b=Eps+ibSTqeAlNiD9ZV7F/ZBLX/7flkgZUsAcTsRkYeBh00zqZ6QlBDeSkWawZKDrZ1tZJZ
	DB/jkIiewVwMmPY3Gae8+inb+kvZwJ0tbeilfhlkkRLZlFlfGz53dltG37BRN45E8o2KLA
	qR0oMxOVL+uT8mCmhpZwPKg/EEH9ECA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=RAQEBQUg;
	spf=pass (imf15.hostedemail.com: domain of nik.borisov@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=nik.borisov@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-496bb7cdf51so41427135e9.2
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786968891; x=1787573691; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=01zYHu0teBLcC0seY0nFh6OS3sPomq7wlr9susi30oE=;
        b=RAQEBQUglFfKVDEM/EhU4hcjorCkr1wLbvu4Aj9Fpj6zIMZYARqONuQ+X3Qq8iePrD
         auvV5J2T8At5iOSl1R2IoUfEb5rz+KEAMGPuqQn8KefVtNqjGKcNxILcWAWjvTcJglP9
         ks53Uk2aSFjdcLlFMKWreLWDrSWJ2PFnIPdORgX2BYr3NDIcHfpxA3MnsGRp76FP/MlL
         lHYmNo5gpR1zSXC/c/n74a8v1O/RRrOnEDGZj+Mb5CF7mkyoZi5jYeVsEPZyFLXIs3TS
         80K0Db4GPhuQuvjJgEvKgy8/4SKChzU/L8wqBnyYiNge4JWFJVnxPgLDXJw2Jmoar7Tc
         F6Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786968891; x=1787573691;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=01zYHu0teBLcC0seY0nFh6OS3sPomq7wlr9susi30oE=;
        b=aqd171swF7Sj02e4TwGcEHcsMJ4+eywQlupE0ircMMZRmOSQi+nG/IAUyWYObd8IXz
         v9oYdjLv4UThXsbjSv6xc9W4UO4DSOfgI/9kZH1drxEjks/c6g80WDlXA7gnKvu7MHwN
         r8oKNJP8peQ5Kq6KNfRI5Mjn+UY0NZGCiOn1Q3zbya8HOqaX3z4bBDGBhtdmBBkmd+HW
         Vat24WqA9wL/e051VmMDOgcjiQ5MczjQUM9S6UyVRMdhSjrj0rEtJHC+uumfmXNTwRgp
         aeIdnx5sItUPMqiIkGZ3hZpsZqqdB0Vjpy1axjPPmzBAY+Nc1TKXcdMYHdvE8Ia3n+er
         KaZA==
X-Forwarded-Encrypted: i=1; AHgh+RqUyE955o0a5vDtn92tUKP+Ei6i871SWK/qaBfZh/901aTGWYcAfuw1MT68jvA/EVajXD6HYoq9kg==@kvack.org
X-Gm-Message-State: AOJu0YxsKzs6J4T7QHZVXvcx/SQEOjNV38EdjBx4WAN3yingrnOj/83M
	7BLejV1CdFwM3smLtoVGXwS1En6wtbJG52VQUpV2iH9qSjXpANE252IzP7ppm4n3Mcw=
X-Gm-Gg: AR+sD12zUh02jDeHFbLNQuRCz3yWQ4pVRZJPfEz0EeOKcphMqs9bnXOInKEvOIlXzV0
	WdDaLXZxpUmwMf9lpQqeTk/Yulu7CWVfMgIr4t0ddtr2TwtM2gmpaKdMtohbQPO+GeizCIdvEQk
	ZrwlmrN8RT8iR+l4VmUHLQvVcbmZpB0IzXN+Pr5aSVjPOP/0esgfwTyDFWm9jye/1O80/pdkAIE
	1l9ooJV/AWJXh13haLIcbGMgqVfvO+kqkeuiGs2ij+zsZPfzTz3zcI6/uGiuYRojJj3+dH39HHt
	IXQ+lyBfj7rgn/aUT8Q1FkLut5SmGVgN6zShAnzYFUT4R0UkqNNXwSHDTb9TLQQv0kgxGfquQwM
	FBOJMOq78SImNCbTj+IFMp8GkHus6LqfjflYuU/6/icOLzqqTlYeeIlxeAQD+wHmJrjJitkemfN
	EkTfuzM2wonS5CYCqQNPDG/DvsMMhqGRvrMepGmuW0CJqO2kjFndeiKkFUcqkUMuI=
X-Received: by 2002:a05:600c:4e13:b0:498:11b5:3ff7 with SMTP id 5b1f17b1804b1-499879bd2e1mr385420895e9.18.1786968891419;
        Mon, 17 Aug 2026 05:14:51 -0700 (PDT)
Received: from [10.20.4.146] ([149.62.206.129])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49996100082sm193773585e9.2.2026.08.17.05.14.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2026 05:14:51 -0700 (PDT)
Message-ID: <7daf8a03-c803-456e-8497-5f37050bcd6c@suse.com>
Date: Mon, 17 Aug 2026 15:14:48 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] x86/cpu: Move 32-bit SEP setup into identify_cpu()
To: Ihor Solodrai <ihor.solodrai@linux.dev>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
 Thomas Gleixner <tglx@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, "H . Peter Anvin"
 <hpa@zytor.com>, Andrey Konovalov <andreyknvl@gmail.com>,
 linux-kernel@vger.kernel.org, x86@kernel.org, bpf@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org, kernel-team@meta.com
References: <20260814235134.3461435-1-ihor.solodrai@linux.dev>
 <20260814235134.3461435-5-ihor.solodrai@linux.dev>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
Autocrypt: addr=nik.borisov@suse.com; keydata=
 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
In-Reply-To: <20260814235134.3461435-5-ihor.solodrai@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: w513kj5i175tzec1tqnudn8rocqdmdai
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DA817A0003
X-HE-Tag: 1786968892-710003
X-HE-Meta: U2FsdGVkX1/60NSAG4qE0E7oSoijcXQbi8VCjf4q3EJCt262tbbcCfEN1BQoa/wqQBUsnU0rohYetw+C+xX4l+d+DSalGzRA4s+ydxvEuNXlkotLOKyl2kgyvmIE1UjUO6Kr840jpMk/zcg3Tmm4a+U9Y6Gpn0FpYtG0HJJkG4wA0zn/0Idd8cPEShCP686Mp5jD+nuClgE7Q1g5APWCGoIqY84aFZ8HfcKwQ6IItpwH+bAgguuXyNLGEgUjDJzxVGEgGiILppXOaT1++0ymM+GK6oynq68CJvwY6DFph1z+H5qwZI8tVf+1J8HHeTJXi7F+syO+Evm2pXZLjI9LEESajLL2IQe5Wzwqrwznu9EyQpTdZMwUtB3qbyZfO+PQqOhv0ANLwbdYBsJEYmdIjdU8E8NFdAFbuQItHc/84+CgjlNz+IRZWNi9Sf9etQ/tt7qHgXxusnMU25jpukfFopfNRplGNUxZshfrDRn5KJSAMiY9ujLaGQMmhr05AfkFlwNX6OhRzY3giFYi4R3mMjsw1n5Z/tktQdkVv0wFlRbsWzwC5qtYdMBH7JgIGVnmnNImO3KUo6Hxkhv87QnPE9nhZmT8FPpkLhemFHEvPplpRt4DbbK5GwyFZnYbQ0+GHdCtBh3PB74wU1YKsqiPJ+9PsaJqhsJadiIXw3le9Q2GDv1gUbjOkFWSFdBaKRNVb3daRa6WGGJdFbyfHhrOA8I/e5eWsVpZanKKHZUUDGiuRvoVtVHnvJsrYImtJkA0Pjvfaupon1tD5aJkExzMOh8vDfxN3698RCMnfhR06bCcAu1nCpBAAZCICnKlQAqh9JvH5rsooig2JSH1Wb6MxAUyBFP1UaYaddmTDTu7ccS4G74/gWF/yeuLaeo0FSZd/YvINHwjjwrlpCIHycO330Ra0U5v7FSmVFR6gy9vB2LFrJAhgj0L1191CAnRHwDlNyJqeUtwqr9VeeBIFIb
 xO+TFhJ1
 xsujAxG5V7t6yLPvMdF2LL/3VAOaEooPtavyheRN0iLjQaq9KtwZ4I2WRNb9JCB6Hv0KFv7TJWKgObl3/83s5pqZHlpHMnxlSV7/eBCNsAdJElgYqW9dHJTQc00f0csOjfNMKQoui3+Sf3mW7rrp7a/oh0BPkIQF4UYiMn6iS6hLeaox/4fMtdQE0apy04nIVUkoQK910MqZ5PHXRKV44zUxFzjIa9huiSFqwPbWfyozDlId+IUX6L5FEjXjaJMMd6pMQ0luIxEbQ5WNgZNaR6J4l3Kzqqh1WL7idyt4NE1HsF6YyG43H7fB/JFllz79+6HdVDA13V/u0uoatIqw5quc7PN7eiMCkIAnk2C2nB5JJmhKlHbDL9ktWP0YYwtUOJfDILYv/FwxKziBwMIa/KZWx9zsLJidIUT3C+zFbgD6eNXS1OC4f8NTcxdWmhAS6/bwwhq5uMmv1KY/O1BkpFqBmtK44CYI6b0cDvopdz+MDk7t086R0hkJ/lA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/15/26 02:51, Ihor Solodrai wrote:
> identify_boot_cpu() and identify_secondary_cpu() both call
> enable_sep_cpu() under CONFIG_X86_32 immediately after identify_cpu().
> 
> Do it once and drop the ifdefs while at it.
> 
> No functional changes.
> 
> Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>

