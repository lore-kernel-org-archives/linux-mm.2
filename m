Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F09ACCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 09:16:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69CA48E0012; Mon, 10 Nov 2025 04:16:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6742B8E0002; Mon, 10 Nov 2025 04:16:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B1548E0012; Mon, 10 Nov 2025 04:16:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 476E88E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 04:16:54 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 02D0D1A0CE7
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:16:53 +0000 (UTC)
X-FDA: 84094142748.16.624A159
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf15.hostedemail.com (Postfix) with ESMTP id E7DE9A0006
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:16:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OPK0YSVX;
	spf=pass (imf15.hostedemail.com: domain of davidhildenbrandkernel@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=davidhildenbrandkernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762766212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rK7jfs9gqvXaLNimcAlCkzrJKccO+YVTZrJh68Wev+0=;
	b=UM2ZuA8vbyUrrIFf2S9cMn3i1EVKchStc2dzXODGYxg7imDZihjAIqCQfhRNQDmR5gd1C+
	bXa9TIsmR53L5IUsNuwnw3wKFO2xRFtF2AvO34EoM5TnAxrv2IqoFY612XxEem7vPVe8cw
	EeIMAJGYc019NNdU2fpP+q+TtXCs/A4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OPK0YSVX;
	spf=pass (imf15.hostedemail.com: domain of davidhildenbrandkernel@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=davidhildenbrandkernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762766212; a=rsa-sha256;
	cv=none;
	b=ks5fN8iKWHCV1aynIxBWrMdouBuuABTxoKpzLme3LOF/2Me7GwytDRjFk276ZHhjDDTY2/
	nBwkd0+niQFxSQJZb8gCPvICLSEvSpbLYrEZv9Vs/i09ng2JaZqLz3+tVCvVQvrCQpDsXj
	RAozRHA9Lo6wB+SDkuHXwU+nMFX8JDc=
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-591ec7af7a1so2337362e87.3
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 01:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762766210; x=1763371010; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rK7jfs9gqvXaLNimcAlCkzrJKccO+YVTZrJh68Wev+0=;
        b=OPK0YSVXq42D1CuvO6GJd0AwNugsYciA+l/jE4rHMoDYmnKhHoyZvQisbJzoCAYMqv
         O6l8ModAu0xocCHJ4j03BtoSd2tAHhOaVhlIN/YpAsqmYUUdP6q480m9u0BGey97c35E
         rQppqkv5mwsf0Z+vWCu3QbiAeqSWcdj9xbMf21cq1JX4U0NDCS0xBiCzogp9I/MrvZHc
         q99VegeFfWZ+UxShU/BzRLx+TzFa89sDS2RgLrdF7vI/S4lQUMB4w7Xy9HIwNIGo2OlL
         HCB6rdC2em1sdMa0rh50DMBmYOwbWRVZi4DoMTPfiZD0XQOfQnWwzPbiUTQugDmrOS5i
         36ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762766210; x=1763371010;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rK7jfs9gqvXaLNimcAlCkzrJKccO+YVTZrJh68Wev+0=;
        b=GAhLf/jNGy2rwLk2zqCHXxQZ96uZW+WmVAaMOsf9C5JxS1AY1h3nbbuDwE/nff61HS
         6y1TSVR7l5bAJSpmtTETI0fT91zRZzVNuXx5HKKF6SiXBMWjjq1rQYBiyLpmnT2pAsoF
         QMUQRR1llVTrOPlacqLS52AX+0Qmj5q8bZqLfZTxCl3T5amBdGnxVpWbhtaQfrAr1g+X
         0Q7m8LE1dJhUn/LniTZgPE11Tbfa8OxzQS2J/GPAHtQXlzTxsVNHOEcJv28nOoK9qn/Z
         w18zDtXcBm6CAjrbKx/3vTcE8C+bU7PTNbabhw1G4MebT7rSvDmEsc5V9anh1MacWUzt
         eWlg==
X-Forwarded-Encrypted: i=1; AJvYcCVNVEyH6KXVJ5J6WtvwrAsEs1pxnXrrzaIJp6HfnhhkZ/EJ3xUBqrpPjQ0WWdLogkGge3+6yYMEBg==@kvack.org
X-Gm-Message-State: AOJu0YzzvmaPo1mW0HOW54mgMwBJHJcP/mObHJu5T1fbcUB49azYgraa
	X2V97FI6pN1k9AGY+w3zhbnq1DbGlCpR/zQuvpDs8ZSMaonbzzMnyziy3BmfzA==
X-Gm-Gg: ASbGncsQ9Bh1OZtzEz1gdDOGTZBqn+v/jbRkdK493Sno8Y/ldqzfxJfZmD8FlbfFwux
	KZNs+7W4UNSd+Sxf6fsD8A6sdKdAYhTlvuzBk9DrVL9aUv8Ggc341oYDhJXOXlqfwJz4JmNXjck
	L4/mQ1Kn//hVFu1ECmhnGSQogj48+a+/W9AmzPk3jcStEgEx+1ygqCxQ5CqQLl9KGEZO9/py1PW
	1PUJjk6CRjj0Ex4UN8IpAAE565DidD+jVYw+7bamqJezScsg6OSndKO8Vhuppe/4a9NOSUr1QGj
	WypO+Wui1yp7bFpgKlulOSF4U6TGVijrzWrrtb0CrXQz4v0fXa0dCEIVoXdtRolZLs+ss77RJdo
	4j8ivUi5rSZUHSK4gfzKE/gw3RaDpHTqq2uMT4Lt3om6Izz18dCpLiARzQEvJnJgs4elzsreKnl
	FfQ7NC4OSU/Vb7g0rR221QAWxyERk7W58EM6JP6yk8NBJAgwAa/atzOfaUVbUlIkL+3LbmHLI67
	ntGLtjGWjzShGp+HX6redTTXmh8iZ6GMm9tixCRDyp4MVRpSnomgCkecCIt
X-Google-Smtp-Source: AGHT+IE23ygUw1G6qfksLpO5n3+OUhfUG7uTHrVPDbfyBxBi9Rl3+jXpxrwjGQUt9QvW6I+tJFg1qA==
X-Received: by 2002:a05:6000:657:b0:42b:3907:a38b with SMTP id ffacd0b85a97d-42b3907a591mr2583100f8f.44.1762765773183;
        Mon, 10 Nov 2025 01:09:33 -0800 (PST)
Received: from ?IPV6:2003:d8:2f30:b00:cea9:dee:d607:41d? (p200300d82f300b00cea90deed607041d.dip0.t-ipconnect.de. [2003:d8:2f30:b00:cea9:dee:d607:41d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac679c5dcsm23727969f8f.44.2025.11.10.01.09.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Nov 2025 01:09:32 -0800 (PST)
Message-ID: <690ce196-58cb-4252-ab72-967e1e1574cf@gmail.com>
Date: Mon, 10 Nov 2025 10:09:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: restrict __GFP_ZEROTAGS to HW tagging
 architectures
To: Jan Polensky <japo@linux.ibm.com>, catalin.marinas@arm.com
Cc: akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, will@kernel.org
References: <20251031170133.280742-1-catalin.marinas@arm.com>
 <20251109003613.1461433-1-japo@linux.ibm.com>
From: "David Hildenbrand (Red Hat)" <davidhildenbrandkernel@gmail.com>
Content-Language: en-US
In-Reply-To: <20251109003613.1461433-1-japo@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E7DE9A0006
X-Stat-Signature: 545kzt7hznr9et89zhpua86a16im1sid
X-Rspam-User: 
X-HE-Tag: 1762766211-921772
X-HE-Meta: U2FsdGVkX1+6gfNaIXWSrU6a9Ong5/myBiWsYp5XmP4gJU3yQfrMa7Gnuvzz5Mo2GdZrGFmD56TygOxHjEx01pWVP8XYPD0Wk5y1PXI7cmd+UqMOJdQJDn3PBCJBqcDmLadbCzhLRBTQa/8MvUJatxh0lIcxCbX78BPKbyicxoobNB4w4fdX7SqKuL/+kTQYKx75hKIv26IUfxSxtUNrxH4V5I4sb8XTw71GuLs2ZDFpdjEk7K90ilcSDr5AmQ8GylenWsx1d9C9ci/7uZORgt670NY3Td36XPJr+wt9+Cl61DOfjjz6EhIPt038cs1OmjleGBi7g+NYAqtV+QKBXgGC0NMGRt9Yl5ZCqaIVuuXLc82mFClELT19V/GLZWiRFZ56pEh9MuHy2a03iilOle/BoF2RDcOTMbUU1doFQlZTibrLX4JXc/QrZzq/gcPPZReArdQnDqdioY8wKIt6Gwt/hKEbyopAOeg3vkBrHHzqN6hmNuCJHmDs3awB3knSpsPLCw3JxRcrS/TGUBs465qzByEjWsMec4xboSK8lb9PviQ1MJecZgR62602z4JZWIspie53IdiqYxsmHpjKAaE5hdX5AUsceCnp9nBQrMfjbP4ynxed2DSCQc3Pe6C6cQc4zkJ5EXZM0JsxiSRuJF8fFPf3s3/oG9h95dHHTUhGDcnDFIXzjataLoSFaVl7DOhTtSqQLDCjNgw0i584UbRh0h/x2dMS5V8cMFPq7nh3S3Lvacpw9Ef+V7VihsdMUTAggGJoxiE6yXbFW40nySsyAaA26USfevqds7tu/uGQTSFLh7CUmt422KJ3qMdUu+K6IrWMVgQ9tTG6aOhsHqR4cEsjgzYtMj0B8tSWDDh24YQvihRr/ewo0s0pWuSxdyVJW9QSyJ6oBBSMJBOgyI5rPvyfNyuXI/KklrWUu1ej1Ra6U0GyZ+DTQ9P72UKoztxsPQg2uS9LGBWbJyV
 DjB92hWo
 F9IelOJedigcdUp34aKiHzbz6HS8z3tABppIv9mnhLYUaYg5HoOT4wp7o8Zxd5SJz8c5fxz/Rbs8zcbpOwaQJECDBwhqfuaDQmCRFyaKg/Nj42kqioG1QxMe20Y31f6xVbhXwpDF8y7KMXC/mD25LM5jGTSeDGGQTBsQIXCW+OiJgq924y7ZkLsy2kTLDzAX+dZL7EHTI3bVyJAA2dQ3lV1iYVQ6sUWpKo0k3VGGjcgwKFUEephGE8XUQMNxUYtFu2qKYzhV37qIIS1BTuFVNfRdlvp48WN7Ub5NJNn/6gWzFpjcbmB/dwZElKOBt5D4RHPTLkvmZnlNbBXzASeL9bsBS0txZ6H9TLMnEPqJ3knbbO0nFxQrnILnI8hy5VNjRZc3z/nu4YQw0efgTgYdpwj9jhJByrgWNti9IyDvWxmw0P7GcZKHrA8c7pK0IwkT2GrswrDN9X6M4nqSzE4+YIR7wguLp25Itfgr1IkNw6Ota9cMC56ZWHm+vubdhzGkw1e90NGUGAacIa3xQdYUaPn3S/9G4l0QJ6V+GFiUuJcOiG+Ffq+JrkzGPGP9fWuwVrmKoHXMO7kc4aFJRJWHPBvYz5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.11.25 01:36, Jan Polensky wrote:
> The previous change added __GFP_ZEROTAGS when allocating the huge zero
> folio to ensure tag initialization for arm64 with MTE enabled. However,
> on s390 this flag is unnecessary and triggers a regression
> (observed as a crash during repeated 'dnf makecache').
> 
> Restrict the use of __GFP_ZEROTAGS to architectures that support
> hardware memory tagging (currently arm64 with MTE or KASAN HW tags).
> This avoids unintended side effects on other platforms.
> 
> Fixes: 1579227fe0f0 ("mm/huge_memory: initialise the tags of the huge zero folio")
> Link: https://lore.kernel.org/r/20251031170133.280742-1-catalin.marinas@arm.com
> Signed-off-by: Jan Polensky <japo@linux.ibm.com>
> ---
>   mm/huge_memory.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index aae283b00857..0c1794656d7a 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -209,14 +209,15 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
> 
>   static bool get_huge_zero_folio(void)
>   {
> +	gfp_t gfp = (GFP_TRANSHUGE | __GFP_ZERO) & ~__GFP_MOVABLE;
>   	struct folio *zero_folio;
>   retry:
>   	if (likely(atomic_inc_not_zero(&huge_zero_refcount)))
>   		return true;
> -
> -	zero_folio = folio_alloc((GFP_TRANSHUGE | __GFP_ZERO | __GFP_ZEROTAGS) &
> -				 ~__GFP_MOVABLE,
> -			HPAGE_PMD_ORDER);
> +#if IS_ENABLED(CONFIG_KASAN_HW_TAGS) || IS_ENABLED(CONFIG_ARM64_MTE)
> +	gfp |= __GFP_ZEROTAGS;
> +#endif

That looks like the wrong approach. If an architecture does not support
__GFP_ZEROTAGS it should not trigger anything. __GFP_ZEROTAGS should be ignored.

I think the problem is that post_alloc_hook() does

if (zero_tags) {
	/* Initialize both memory and memory tags. */
	for (i = 0; i != 1 << order; ++i)
		tag_clear_highpage(page + i);

	/* Take note that memory was initialized by the loop above. */
	init = false;
}

And tag_clear_highpage() is a NOP on other architectures.

Gah.

I wonder if the following would work:


diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index 65db9349f9053..56b82e116cb79 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -47,7 +47,9 @@ enum {
         ___GFP_HARDWALL_BIT,
         ___GFP_THISNODE_BIT,
         ___GFP_ACCOUNT_BIT,
+#ifdef __HAVE_ARCH_TAG_CLEAR_HIGHPAGE
         ___GFP_ZEROTAGS_BIT,
+#endif
  #ifdef CONFIG_KASAN_HW_TAGS
         ___GFP_SKIP_ZERO_BIT,
         ___GFP_SKIP_KASAN_BIT,
@@ -85,7 +87,11 @@ enum {
  #define ___GFP_HARDWALL                BIT(___GFP_HARDWALL_BIT)
  #define ___GFP_THISNODE                BIT(___GFP_THISNODE_BIT)
  #define ___GFP_ACCOUNT         BIT(___GFP_ACCOUNT_BIT)
+#ifdef __HAVE_ARCH_TAG_CLEAR_HIGHPAGE
  #define ___GFP_ZEROTAGS                BIT(___GFP_ZEROTAGS_BIT)
+#else
+#define ___GFP_ZEROTAGS                0
+#endif
  #ifdef CONFIG_KASAN_HW_TAGS
  #define ___GFP_SKIP_ZERO       BIT(___GFP_SKIP_ZERO_BIT)
  #define ___GFP_SKIP_KASAN      BIT(___GFP_SKIP_KASAN_BIT)


Likely we'd have to make __HAVE_ARCH_TAG_CLEAR_HIGHPAGE a proper
kconfig option.


Then we could turn the default implementation of
tag_clear_highpage() into a BUILD_BUG.


