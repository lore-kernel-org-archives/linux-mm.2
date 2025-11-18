Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC6ACCEE341
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 17:12:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F0616B0089; Tue, 18 Nov 2025 12:12:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C7EB6B008A; Tue, 18 Nov 2025 12:12:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B71E6B008C; Tue, 18 Nov 2025 12:12:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 092FD6B0089
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 12:12:32 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B5DC313862C
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 17:12:31 +0000 (UTC)
X-FDA: 84124371702.17.778F8CB
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id CD7152000F
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 17:12:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P8fhswi1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763485949; a=rsa-sha256;
	cv=none;
	b=lGmRLLCHamjyDeF9n3QW5KJ8OQ4GAZ5xGwimYgTww58vU0V1t/3nXixW44Y4eTeXuKDEdA
	3OJ9m3mA3x/Cxj1Qjiyc2zsYFmoSDkLsRL26HqL2cNryBgpGjtcHDcMVmxZ/NT/lz0Eh7/
	k+LKOcfc5gTT8rgHbMS9T89xSuOCHr0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P8fhswi1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763485949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4y7c/pUe2lZzCT0WD4KXTZ8Y8+apAqRGrFNn31Nc2Hw=;
	b=i7EbD8oPWJ1LvG4GusoIVdEk1rdbOSJDd5+Bq1cq1kNg7kBugnWdGSPSEPebOp6ofFGbpG
	vfT/b6iYSRUfjXtE8h7eQBp6iR0FeTtMo74T5T7nLUXckouKnDPRCtNx3fpGESwKFmxJTC
	c0AomsKWPsuzFUPkoYKYEZbClaoDDJA=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7aa2170adf9so5001934b3a.0
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:12:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763485949; x=1764090749; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4y7c/pUe2lZzCT0WD4KXTZ8Y8+apAqRGrFNn31Nc2Hw=;
        b=P8fhswi1sFZDnHly4NrlqYsun/MJJO8YnPxsLjJFy7aXk6IcbRlMmcg9loELoS+fZg
         O5lAgQDtbRTMpO/r80uA9ocLa8XhFyLTBdLuQsTJDYBfbWYEcXRl9/0zwr+kjIaeETwu
         OYbYj1AWrgrCYb5MQ4FtvGeAiI5SDmOl+AjU1Ba3OjtkAXgFoA/feVXEnAtvTmPwMT1B
         RRTjGfBNjkng+uDuejJGVsZ0bk3tLYiFHuklE9Zms5Vyr4wLmJt/5DAUzXqicd2ID36B
         6TcUknTd5oME1VEDfbwnPDEx7PmjF6X7AwR8OlzBLfmpH3NjrIZU1RYvXn1RV3Y5w8rg
         ByIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763485949; x=1764090749;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4y7c/pUe2lZzCT0WD4KXTZ8Y8+apAqRGrFNn31Nc2Hw=;
        b=wIjKivKWq6U7zJVQPaDM4RVEZS6vmprwVk2N4NxyvOn9oPKTXxoO5B3zhxwLEhceVP
         6EC9EDb2XYs6Yz9IH4R565tooybtFHl2WLdmHwngGwLHfPe6bLUAA1rYlcXLhgDZQwNb
         +mIExLlF7HmIEgW8F1tW119ptoRQrVqojq2/c+8CQW9alerZ43AWu5YDhxxlo7vb8chr
         ncnS81/t27XA7KzlOU9IAKIOAk+cyfWrGh83oT+GAN/8lGfih++DJxQ+Q/hwG3FQ5919
         po8jXpKOF1zPbteRyQqnrB6ZPbQM0DPSEKj9rnKPJ9HXuaRHjtlm7D2Uk1uAuVFxPGhf
         k8qA==
X-Forwarded-Encrypted: i=1; AJvYcCWBhSUVLWLl4SvJEQxGMBI5CXovfw+siNGHaWNX7mKVR78A3MB8iiRWaN6lFNSf6XlfEK6xeyJ5+Q==@kvack.org
X-Gm-Message-State: AOJu0YwWFNdZs5v+zCxPOfyX/qQ7wjiD9Czfh44BpwPFBBoKnxpsN0K+
	ZPecj4ZW0q8rzC/rjZZGxOGvqPOQJbZuCcecfODJKQSB20b7CHFeZbdL
X-Gm-Gg: ASbGnctxNR74AXyXsod2okq81Ww1fUhbKsQDF+llEGCYvvytJ77Rk8w0OUXiI69Pvg4
	Ic+kr1HYK8vBdJKJurowfRyyl1e0W1Pd7BhGJOsjB3bBQ6oPObHcyIeLlUXblzPLSMFO4Ksbi6i
	9Zl1CZXdazVoBog3+y74BTE0GO5nUIgZ/AWTDEbxPpjicZe8VMUYipf5ht5+STd3KI8hOSE3+Qy
	uJy6f5aH9ZNNixepXXIqcE+CgqB+CVon0Kd3b/Yig02CtY4grM/+WKH2Fyq92RSJ8DKgjbWEU0B
	MAoW2/zExlfGX1XHSwMtI5+yQukbhSIJaZSDxPcnWlOfkZotSYBkayvOH8yGVs+31RDnMUN71jY
	mbj/5f5/XtMJWtmTVpjD4RpUEr8mq26w7cV9cjzAtXHXRJk49rktN8K8tZnMtPpjx1kkfoUh4MS
	5XYVkMteSXG5i5xptg2AplT6NBsMxffHnmeEWBYQifPqk=
X-Google-Smtp-Source: AGHT+IE5NnaqnKmma7kD7B9aShWAhvkMoh5NKfXnJg0HqNhBeM3bMSSc4oe2QBLZL1k3KXgz3JVCTA==
X-Received: by 2002:a05:701b:2514:b0:11b:a36d:a7f7 with SMTP id a92af1059eb24-11ba36da94dmr2687889c88.16.1763485948511;
        Tue, 18 Nov 2025 09:12:28 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11b80fd6790sm34781822c88.10.2025.11.18.09.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 09:12:27 -0800 (PST)
Date: Tue, 18 Nov 2025 09:12:25 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: david@ixit.cz
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, phone-devel@vger.kernel.org
Subject: Re: [PATCH v2] mm/vmalloc: warn only once when vmalloc detect
 invalid gfp flags
Message-ID: <aRyo-d-Sj8i0Trtp@fedora>
References: <20251118-only-one-vmalloc-v2-1-fe702aa68d8b@ixit.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251118-only-one-vmalloc-v2-1-fe702aa68d8b@ixit.cz>
X-Rspamd-Queue-Id: CD7152000F
X-Rspamd-Server: rspam07
X-Stat-Signature: tb1g68a7tzfr33t6sf65uo8ah5ogn87a
X-Rspam-User: 
X-HE-Tag: 1763485949-482445
X-HE-Meta: U2FsdGVkX1+sO/p5R76U7/05vWZRO4maYT/duZ11jU8i1kssw7hANIbP5aG81yivd2gCWNyJZ7ejTAIk+uViQAyTFB3dtlLy6DmNJXPD/WARmws6KCK6sw4t9OxqHOi2+5CAUu0HLI18VcgnjSbYRKO9Py3krzmn/iBfdzX2eJLWIz1MUma44bb1bc7ltDeEnKeuHGM4dGlPvMuCTEHI8atRVscP+p35VhbtJcYqUy4aP9B/dUdypZw2fyeg4kKN+Dmz1cdUfqsFIBQqBNPekNPLKtF1vHUsVh14Yir/oF31xcvMZG8zCieulNg3GBBYCebqkNB/s6yGmkZ3kDf2FVm3Y7guKA/vZP/Mf5LQ0W2vqZNN4DBMsCXPWDFUFR/dTMLQwf7fVX+5UO4jpPy4CuP//VApGAlJM38/HXSWPZ1n/tKjpIz42DaY6L5IvIOK5/Sdv2PG6CyMIdOMgMnphx9h1G+cS6yFcQYN0OPUIpzMC7JnfBeHMmaA3wESMXycYkE5vvEEov/jqESBND6JpWaS3hrVby02Ij+eqpdeqQgXjPPqm1IvPDFh9X9JJVA5feiDmhzlhted8zdt14aqxKHP5tC9DXAyoT6F4JW3B9QbM+oYNKw6rsCZCpBy0l7tKrhZ6tkRf/nDFnkypGxKOznFkV/2xRiu7ncPGnfNoP6CC4yNWSHchoziE9EnRz8LexUx1YKGRZptm8/WWLDsnI8Iucf6IaP50FTuPvO4lHsmL2BtRRxmUHMjT4wFM+aSPLZ51ljOkyQ58Zw//TgWxrSARvUhMaF6rhmvOl8XgbqHzxCBOUkx+Q++pf2YWQoSdWHRy3FhXi5lV83YXXbe02vZCVNoUAPjW0Nq2qveHgsHTaCBKlq9fAQLMzaUuMJDCYmHikXhdAG5fbgEch6pIWg8NKix1QVkC53GcAXB5z8cT1ShwemAXvmxFprIi5PhAZ82vYH3aRf1VLX/3XA
 2nqQSJMq
 caX7kuwAqBJibS9Mn0bIxrMr6FKJQvXDT46r+rPC2q1A0AvqM9ZDUqlWyh/Y7S2izJum6ZnTu4taWF0GS71hL7O7Oh8kq9Ct3cV0nOwYLxmEb5mxCQvEiM/pIuZsdksc4wz2PJ+EqyPRRjSifhq6jj9EO0AjEa0XsWSQq4oDTFCR4y0QMDz9TOba6Et1P1o7T3bWsl4NQLUNXE7Rp4i1K25t+zlrPxA3uUyDq0EsDqAvUcn/ytAQ5XSEpKAQmsTUr3ykYwnonskDe2PuKQJHsbEx8WV+2AlAvCI3KVcvHRLGvnWydtWleBgWTqGR8X9mOQt51xff5De36WOuDaPPieAuBMN13+aIMPL93btF0bZyYeUEQDd9p3DwCT7oNdAr5mNjJ0LpbS7qXhejjAE3x66xzrjM+M1fA0Du0m16EZOl4e/tgbBMkDEWRVsPZ5/90Zkwh7X6FqO18APWT1fxDYKMtJNCzcv4TfkyroclfZM8swqE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 12:37:16PM +0100, David Heidelberg via B4 Relay wrote:
> From: David Heidelberg <david@ixit.cz>
> 
> Without WARN_ONCE, the logs get spammed immediately after the boot,
> on devices as OnePlus 6T (Snapdragon 845).
> 
> Fixes: 7179b2256315 ("mm/vmalloc: warn on invalid vmalloc gfp flags")
> Signed-off-by: David Heidelberg <david@ixit.cz>
> ---

Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

