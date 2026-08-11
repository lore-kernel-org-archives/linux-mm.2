Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F731C5AD7B
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 02:28:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89ACA6B008C; Mon, 10 Aug 2026 22:28:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84B216B0092; Mon, 10 Aug 2026 22:28:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 714FA6B0093; Mon, 10 Aug 2026 22:28:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 437176B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 22:28:23 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B7BBCC02C6
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 02:28:22 +0000 (UTC)
X-FDA: 85087404444.26.16A9C06
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf30.hostedemail.com (Postfix) with ESMTP id E861C80008
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 02:28:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=jgw1Cwft;
	spf=pass (imf30.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.169 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786415301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gi+z0Sfoxf7HH2fFrc33xdgvFQt641flXsi+XK17J90=;
	b=Zuf38phNf1ydIFqR9mvWbvR5ptjXkkF5y+Vmfz7Cz1ME/getOZ42PySzr+ewiLS6s5XNY9
	QRgZViPJBOZ6fhH7BYKjWwsE8FLDf/twX1mPZtBrQn7Ip2J7oSzgSZc60axnsxgE3a4u8G
	8EES1Ph9gE0yWZP9er6sahvsBw4gmOg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=jgw1Cwft;
	spf=pass (imf30.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.169 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786415301;
	b=00gyRF3XZrDAQUxRI2S6sNF0ugwaBvpbnUW5yyn8XeGcJQb8kcwj5ONH7jt8ZnFGFc+Kvh
	hpAd8tlbDmibUaHPbxUgFd+Ni2PukxgSLM6sgaWRjv2k/kP8Whb6XOw4ZriqHvhZjdjLf8
	+yu8OQGv99q3zEcnFKUXvvrkK/E+b/U=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-84a2dcede83so3328743b3a.3
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 19:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1786415300; x=1787020100; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gi+z0Sfoxf7HH2fFrc33xdgvFQt641flXsi+XK17J90=;
        b=jgw1CwftW4NjwMUxMhkgoCwtlxfdtXnn0AjNsXHc0pJx1OqJ0i24T++Jt7LAilgaPr
         aXCicAQAToTzdBmiHEwS7rfvBbxeebjt/cqjFCL8URhaVoxMlWB3e9fdP3LtIdxJL1ND
         nno8SnTpJz6LiXqnyyXzVdRlIlmduLOkfbmOs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786415300; x=1787020100;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gi+z0Sfoxf7HH2fFrc33xdgvFQt641flXsi+XK17J90=;
        b=qwtAqZrnrk0GsHGeuuWJbB0CY1TKvQseMbkTcVirjgb5rS6qoGtbi1QLjPdgHpN9an
         AnlVmFc81rh7fRJ/YUXa6iVW+5m7bPiRIlqFfYZ2Zm5843lcqhpBsptXt9XgG3JFuhnN
         ETn6MW846wezYxmGnqARtnGHDh+eLxBt9aFWg/sN2rfREF5DxL4qd1AzOkBTRIDnMHL7
         27wt3huB2I2gJjibb4qineaYE2Ciw6y6MQI7v8ItjASyIPtpfrlgd7ymkwxl3p2H/Fas
         vYR3/Ji9iMEKSOZK8xgqd8tmrCH+7whsF7iu0p7gUdBe43+LmMWbjtLMRJCBFASbskS8
         9RiA==
X-Forwarded-Encrypted: i=1; AHgh+RqrJ3GYA0RAGA5kAxkqynYi4tAavRmONyu3YsU6eQIxAr31CXB09YCQpuii0b3ary2zXFS1UteDRg==@kvack.org
X-Gm-Message-State: AOJu0YzKTh7NysgCSrh/fhQ4AoXRnCnpn1HeiMt+xuc7873jIs/FBahW
	gJ7g6gWrORgFINnR8HcXASm4k1c8+2kbxIa2zZOn8otE5JFj9L8NCz4ijLC4tJ6sqg==
X-Gm-Gg: AR+sD13kNkBqZ9sg9zJgFWp77KsUR6q8V6CR4S4HMY+9FtPy9t6dcNzcc1cSm6sEEKl
	CI/V7eNdzZllVZ6YUWv8VxaXnRZfDMtrd6ywjaBSKYhk272IzD1+UIRrEbTHJeG1qw64V5I8OX2
	4Ds89eFo2BzxIALweQQLQKM/M+hJccx/CMyZPR9K4zAorZk9avc1avmO3VFff10dokhnuOlDdCP
	SLHvSl7PEVdD0rYt3JuVJ8F+BSKc6KkGjI7cF+HsBwQmIMNe2fbOHYtec7A0p16odnshpA5rkqI
	FaHQAVWI4Z0o5+73FVixIHAsapojoluQJJ9Q44occVe9Mh2y+L7i3xMQw0bBKw9t3tOQURD8VKa
	v85L7OIVCWo/JlsFU7NCaNR/dYsd5V/1gNdKh3ZaMGObjeYoYCi4CRKH4ZRLavsP+p1vXejfqBE
	56d9A1eQX5p3OMZvXC3Yqn1YDVwNyO5ZpOrLBwLQjlhNha3Vmu/KndYLYKS1EaO2A5sM7aUbQuf
	ND4W1faWMnf8UrxeFCinDdvbhnLqw==
X-Received: by 2002:a05:6a00:2394:b0:848:354f:4f8f with SMTP id d2e1a72fcca58-84f5e0688cfmr29315940b3a.22.1786415299781;
        Mon, 10 Aug 2026 19:28:19 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:ddfb:e755:8f7f:81af])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f5a51f192sm4499377b3a.30.2026.08.10.19.28.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 19:28:19 -0700 (PDT)
Date: Tue, 11 Aug 2026 11:28:15 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Longlong Xia <xialonglong2025@163.com>
Cc: minchan@kernel.org, senozhatsky@chromium.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Longlong Xia <xialonglong@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] zsmalloc: account for handle size in class lookup
Message-ID: <anqIohlUBvDhlwt-@google.com>
References: <20260809115518.3791787-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260809115518.3791787-1-xialonglong2025@163.com>
X-Stat-Signature: 5t7tq195t9gkatyk14yrik6z7ichutou
X-Rspamd-Queue-Id: E861C80008
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786415300-898936
X-HE-Meta: U2FsdGVkX1/I9iJbNBYjQvCBpv+Oj+ROO7zEjaNulePiW3dE3AZnSLJUTR+Z73ya95SIqTeLOSMLEb5QH/EUTQMSzg3Hwgf2yQ6WiGbPK/z92RLTt+BzLmkxOq7Edz8TyLaovmdBlsp/A6HtzsInYd9lIFPKuJL62vWxA2aL+qSjYGsQVLRSaa4vqjQmDKTUIeIAIJyBi/3blv9Hpa1ZWjqqsxUT8Ifmf4o1JrOdUksattGtsBNUkDtPU2t7MZNnMwviqsuGZWB3mRNwkQdvlXx5RHUEJ7TQs2qgzmzOWx5qo6g1jTg1mb5lfDgSFMVHVcBot5/StMDBaSAza/lk/YI6vSGnKWS7PR+bS2rW2phbbDV55cEhPVtbHMECX4HZMe0r0l5FQ/RZF+6IgbotuxIkXXQrjKW/iLwcIcQPU1KLYz/MBKAILgHEb4AzrHZT0R+1/THvJXmsGX+vtYDMy7kbhCbGk8YPvkNnGnV4mWFvCEwnWITfKmI6YAH0LLOlZLAa6A/0KRVwV9V/RVYKuYBaXLmHf97uKIxww9irZv822hIIkQNfcz+yWNXPjN5MYapTATsk+FPKCrqwljOyYfwYMwPAnssg/YTqvSMGk0JXd4vAvUgP465HQEjbL53S7J7glLIGXOgHelh9K5ttKS48iOa8pTgm3ZtfqDIl+qglAkiBc/0OeaL2LDA1IPgUV5bHumWIeFY+Du85De0eBs5+EnwtFz2hbcBeTvne4CDCjvDl4wobUiJJW+nDMlMiciijDhDzub3V3srGqnM7DfxKTLwdJQR/AvxXLcE06QzHaAW1DUJybHa+cG12ggIAVr3KbBpfV746imChl5A66MqslS8LXUdR/o+Y2X7QndeednErqn5bcr+OJZEMhnDOeukqwrJjw0kNqK6VDDKabnw0hD3eSgl1wW79RRr/US/UJeLeMyi6MSZVOnuYzqOjQnnIi6pomspzcjmfweq
 Qu3sNDoK
 LTr4BWMu9gjC1mXVIh9eFp7fah8D1v/opymAcjdXlEGKhZSafeBFuRJ1WyM5ASTLqOpUUz0Q8OI7XtTjJwVXlAanyd2ZsN6cSASuTDFRfiewqT3qHzNU6JnfSPxslsDjyzrbJIB1LwXy0G6ipIgbWNbZ+KsofXr2QYSlCMhp7Ga3nip6wp1DLBbfwpjvV8QkCOgfbd/W8Pd9DlR2EGzaNRbQJuBaQyuVVEzzEKSpHvY8ckYmUVa8E/KFeeP73Yt34109vOO73vphXjC9PFcwTJKCjGjMB1nMqpV1yAzaUt5TbFdyZqwV0biIixhKW5xcXXOzOyA1XGEQ4McAjuTsdWTJZMNa6m5qtqkYxhUfbn7zcelxSnGjXx7C4Iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/08/09 19:55), Longlong Xia wrote:
> zs_lookup_class_index() lets zram recompression decide whether a newly
> compressed object would use a smaller size class. It currently classifies
> the payload size directly, while zs_malloc() adds ZS_HANDLE_SIZE before
> selecting the class.
> 
> This makes lookup disagree with allocation near size-class boundaries.
> With 4 KiB pages, CONFIG_ZSMALLOC_CHAIN_SIZE=8, and 64-bit handles, a
> 1025-to-1024-byte recompression appears to move from class 64 to class 62
> although both allocations use class 64. Conversely, a 1049-to-1025-byte
> recompression appears to stay in class 64 although the allocations move
> from class 65 to class 64.
> 
> As a result, zram can accept replacements with no allocation benefit or
> reject ones that would save memory, potentially marking the object
> incompressible.
> 
> Factor size-class selection into lookup_size_class(), account for the
> handle there, and use the helper for both lookup and allocation.
> 
> Fixes: 7c2af309abd2 ("zram: add size class equals check into recompression")
> Assisted-by: Codex:gpt-5.6-sol
> Cc: stable@vger.kernel.org
> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>

