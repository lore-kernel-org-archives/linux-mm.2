Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 964D9CA5FE6
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 13:54:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 818AF6B0092; Sun,  4 Oct 2026 09:54:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77B856B0093; Sun,  4 Oct 2026 09:54:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61CC06B0095; Sun,  4 Oct 2026 09:54:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3AEC66B0092
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 09:54:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3D0AA0B42
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 13:54:54 +0000 (UTC)
X-FDA: 85285089708.17.E8E7541
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf17.hostedemail.com (Postfix) with ESMTP id 08F694000C
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 13:54:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="R83/nPFF";
	spf=pass (imf17.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791122093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fhp5DnkyxmIbQeMkb0zkaihvYpCxHKcLI/0AXytW/nE=;
	b=4/9V7cfRaPbE2uhVA4w8m2t96U/nM6mxum8Wh72vX5zLnqMhWqr+EUwe/1xaL5MX73DOYe
	FZs73jWPvSN379Ekgc+/OdAkQ6wFi9U3QSKtnMC4tbCE+hvzWKYAlfiC7RC3GZL1Vc47FE
	T3nz7hapCfjpMrpe8ebCHC/DizxmuiY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791122093;
	b=uKuBZY3Z6CCiqAodgnj1l9+sKkdqRzcz2WKn9C7h/70vKdNseS3eJsRsGYEBTOX+U5mv3r
	qMD5k00AOWjYSfwf2IJR9szQUx0HMg1M9Z142QPUVsUw2ki1FqWIiGfYJ+BR+AQcMxaE4I
	dM8+HYxK1QpVEqe0hdzhU/mwxfOl0dU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="R83/nPFF";
	spf=pass (imf17.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49d1fb0cf5eso9061715e9.3
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 06:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791122091; x=1791726891; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Fhp5DnkyxmIbQeMkb0zkaihvYpCxHKcLI/0AXytW/nE=;
        b=R83/nPFFFIfkZr3EMpBJ0EVLR+Nav/ffcLr6dZENvJ8xyYeOEhwkDbKPDaqcFExafy
         aYRFa2XH4xHnn/Hh2EZQjT6Yacd5wNFnRuv1/wzn4UXMaiBc/4WSRzo8wQsNatYRVfMt
         15wezIFXgzRoVy449hidFRPFFyR0SV22sJTOcq9X3HxP2I3pbN/kCHoy9gZ2mYyi0voH
         RPIRuTAXHU0CSmCsr0/8xHKRQfBXAsUEDoMNpTn0g2wDLY1swyCAglSNlpNLse8VdalB
         44+a5OMOIEtKu2uwWdO7/9KRBFyaHxnLVfKK9s97DM6dqJB2CjwyXfaL4qc0dg5alRpj
         qHvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791122091; x=1791726891;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Fhp5DnkyxmIbQeMkb0zkaihvYpCxHKcLI/0AXytW/nE=;
        b=cAzCCU3AaTaKrFuNVcMS0dCS3ABKpo5C41KMi4kIOa6dFoQRz4Ez8n9/yrhIfgScD5
         Igk6R40aekH4eGaKHcj3g/JHDHKGL3LzsyEXYmi4XEnD3Y0meNnE2Pq4WbS4uEWPe/pS
         FbWfLnpD26rToiabbECalgCUCbsnIsE3bQkPLG4FFacn/vXUuPJJW57XOHHaZqV5JKVa
         R1g49KV/RSn6Y/9xzl4s4nki5PQrat4rUHvQfuwoWp7ixORq3UYaHpXhdG8Tenm2kzBI
         ZZzwWZxanTT1DggBdbpRtmZtgbQ7HIhVsqE4OXnuD4HcEO5LLKu71n6vuzh3UMVJ2WRe
         2XAw==
X-Forwarded-Encrypted: i=1; AKwUvBzfPS7spgqxLQBunc0CDMQUeqCtaJFJG34J5Me1iFL7xq0CdTOO/02LOIN2cTWSvWx/gOrCDopp8Q==@kvack.org
X-Gm-Message-State: AFuF++nuvMHq/rl+NTTiZ/QVqz767UTmbaBVhNFVNbIMjKlTOZ+CCDuy
	7mBj8mT7AxGl0vS+FsIPm2RZTPWW2j9Ozs3xrpFZ67joEiyeob+k9UZ+
X-Gm-Gg: AYBFou1QIk/tqYC0I714cs3Huz0F6sZHgnsLzTLXIoJpP0JL2xmUrfU2cLeKCYIgfID
	eDb0SQl37vAzZ/+iYIFpvqcCWrUMJzyWkuwaAiEFJJxM0hyX++gBoWCRreiobyGPq+m2zj4bQQo
	6DwkpGlFvYCOCzKXBRdiJWaL7Uijw7Ad/XN/UxPsYKsy2/4xZDAPYaTEquqjXZxn2yotsjQBifq
	6Ma0OnInL76k52r7BYDSnEXsvY8CQJyRQNl2nKu+aqrr5dOC2+NRtK+p/YeTKytkP17h4w4Ok+C
	Y+SIXe+ib5XX24a0qEtOVuh0B1PR711umcBEFmlPwszsQJd9NHJXrIT+xzTTy36nT6bcac43cpL
	aSugsl+mRuRqYguy3ZaAJEEV7rImTR4QK9k0f+EBTLtqgDXrb5K/kSL9B1bStOdCwXMUD3REW5J
	Gnz1lWlU6LbicaJ8MzCqQ2130189Lljs9fF+AqSXwCLMQhAYCCORso1gmqCnVJDU5HNU9uaI2dl
	dvije8+AQydcvGBINL1kpIQTgGMTOzCMicx6sqnmuTzt9L2Geev3OZ5nK7YPnXSlVLE4G/IcWy9
	MA/4JQ==
X-Received: by 2002:a05:600c:1c08:b0:4a1:722a:d2a3 with SMTP id 5b1f17b1804b1-4a1722ad405mr478315e9.23.1791122091276;
        Sun, 04 Oct 2026 06:54:51 -0700 (PDT)
Received: from C422HJQPQG-Fractile ([185.143.37.27])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b380f04e2sm16321311f8f.15.2026.10.04.06.54.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 06:54:50 -0700 (PDT)
Date: Sun, 4 Oct 2026 14:54:48 +0100
From: "Vishal Moola (Fractile)" <vishal.moola@gmail.com>
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: akpm@linux-foundation.org, urezki@gmail.com, dev.jain@arm.com,
	baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Wen Jiang <jiangwen6@xiaomi.com>
Subject: Re: [PATCH v2] mm/vmalloc: bail out early on invalid page_shift in
 __vmap_pages_range_noflush()
Message-ID: <asJaqCyt1T_j3FWU@C422HJQPQG-Fractile>
References: <20261004071639.119857-1-jiangwenxiaomi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261004071639.119857-1-jiangwenxiaomi@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 08F694000C
X-Stat-Signature: x3ezgimzr4zpkdhpq6kzupr43ena9nkg
X-HE-Tag: 1791122092-188301
X-HE-Meta: U2FsdGVkX184O7MZNQvx02TILtegUUyuwHsdvpY7oDW0jn6Rh29XMqMqjEO03wHtMPTx6za+qXcnRPAAGPPDqgDDWG4DxMzkfYvTjQ71R00xORETuXA1GgnjdT6gvibevyE7rnmJ2A6Hhlf8pq8ThcMqNeTkbXwKVgM/OpTv3UDgCe9Aqs1Ji/2ikrq5LsGPkJr3NMPrwJrQSx9mGmSFKV6dYs2+IufkDym7/2ZzPWlaXNx70tvjqwbVbJFh1VqvaABQ1JcddPoBLwoDQN+R5FosaTLT4cQ4DP5IqPMv/9K3WiVI2PxLzDbk+iwaCaDXeMKXsx29T1A50TUVSIgUpFjEHkyFgQmjNRw/zHKa9/mjf5+HCaHT7v+LH8yeV6NtC7KCRDOj5wK4MqiLeVjJrcNfBZZnV2QZ7GUCBPJIG5UYyedih5pa6baaImj1ub60OaZ8AnIfYYYzI6HVCyZ6Gm4LwxtvwQL8Wd8M8aWksGaYDeS1Jg6GLtyUGRUUKBjE5djOAITgW5pN1JRu3Do2qOgbyBstef9zOJZhQcaF/0TBW/7touj3nNprveGg0JivCv85fvNsxGGZSthILUu/5UfoBV+L+aDqwE4EV0I+zLWqeb49W8iwK0xTStUtVoaeSBtWDK45d3g2Tbk1ia7aAWD5bgcdVFtflQBukMM29m/2qQAvBztblfyIZRlH0GtK1QsclYjnQ9BI5T3muqHZ00JyTc3k8dpauMq9o7z614qbE8P9uqGBcarJPhRZ6+2/sOkVNlVzRAyI/wzAwocdvtAqv+IFxdomoRgXUUngi3Urqynv1iUSdhdmPWdC2Zb/D6ZpY43/1rm9EpcbfPO9m/PXd/+4gI0N4liCizEnGXM0maFUAyQKvYGeAgZLXOsu7y1JSSMxKFG21m2fQTgA49UpJZkUhL0Ob5ENWQl0xMlZNeT2B2xQ5wWwJR1KQ+9eDUwf63G0WD0jVQ4d5cs
 kSIxl+b9
 XAaanYRRgPNnJHGXprR04XQATo+hrDFsh15V/S/7YDa5tFLg28HPet4b4acGDp5keWf8R1olHSqQj/G6+m7LniRAoxcK2FRc0Rpw7VsAaB+/3Z11j+QAZw6eZfHnf4wPcf1G0uG4raWU9NdH7rf7SHbcRalzOVsSSaxat77zatBVmmiTbFVpcYT4nSeRlfwXdzMruDxKjrx/iqi4v1gJHR46mnKgI4KFc9b3RqoZIO/zam5QeP0Fojmi95gZEcKMryh7JgcXcQXUzDBV3ss4dubHlZ1o49truAejnJU6t8uzG5gxuV/pl/8ss6Yy00W8pmkNBMR/0jQnh9vdESPNrrRWmP0Cvxe6JWi24a6ZbT5mNCFF5aYonQdnUwXAJTwLICWryO+bEZ+bUp8dLFCA3AifW+z/EujGd3DZn24AuXCORnFNAdhVh+uATtoGbZWVyUpD8eK+VnTVPpUhC488qN/DfgvycxjlV0Ys4FMsBQyZUSCBMe6aBshnvyxN6yh0tMxJjllxNTnACCx47G1hsBHnawjum9I7kufPy0iiotOGJj/eFdWurtK47wiKglWMB2VFh3DrJjipAXWAamZ4qR5HAbSVJi663zZHnzLIAPSGRdZ2KF/MOK6iYyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 04, 2026 at 03:16:39PM +0800, Wen Jiang wrote:
> From: Wen Jiang <jiangwen6@xiaomi.com>
> 
> __vmap_pages_range_noflush() currently only warns when page_shift is
> smaller than PAGE_SHIFT, then continues with the invalid shift. Return
> -EINVAL instead so the bogus argument is caught immediately.
> 
> Suggested-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

Reviewed-by: Vishal Moola (Fractile) <vishal.moola@gmail.com>

