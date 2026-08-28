Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6596BC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 16:57:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07E8F6B008A; Fri, 28 Aug 2026 12:57:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 030516B0095; Fri, 28 Aug 2026 12:57:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E63706B0096; Fri, 28 Aug 2026 12:57:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C049A6B008A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 12:57:20 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3BE62A3F1E
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 16:57:20 +0000 (UTC)
X-FDA: 85151283840.09.0D8EA7F
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1BA4EC0010
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 16:57:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=bmWouooj;
	spf=pass (imf22.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787936238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fqWP1cvvzzLBgenvSOHjdbQzbLJm8dhm2YNn3syViIg=;
	b=zMw0XuGV3/Z20hb1fmA045WK+aZMTvR/yFTuhKAqAtyj1YZ9IR9E9m13qzP/w5DDp2W16f
	btLIBJJxTVS1lYwuUJJc2kApbxnYa9Q7mX0AT0rn8RhR4fgKaPIOLJ8mV5PtFsCeofAD2i
	YGnTDkZUV/DgLv5zTqF1RmJTYM0Yhyc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787936238;
	b=7eWA3bxOZU6RUEi3GEkuwryzzo7j+rN2vztXI3hC9AzcE97nbnP9oT7vmIKmzpRFZvI4RY
	st71v9ff6QrHqV0bqsCTLay0T21L/m8KTvavZ2DVgfhua0BOI2o6V5vwxI40FJSQbX6XZq
	jugqgaOQ9svRkdxixRaAdLxeIN0tEg4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=bmWouooj;
	spf=pass (imf22.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6a623987d32so288011a12.1
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1787936237; x=1788541037; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fqWP1cvvzzLBgenvSOHjdbQzbLJm8dhm2YNn3syViIg=;
        b=bmWouoojU5Yc+3l/Ru4l+vXsIOPDt7eJgNfHo5DizFmrmqJL2rlLq6ZT1EWzpzekOG
         E4W8IU3raWdgDDxVUmF9xIJcXhizcP/6BejRwr3yPcbkxuWVBV6Y60eFFI63HD8UzsK+
         wnHboVAl9OxyBk5d3yzXsiifvVtbmOrsD44fw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787936237; x=1788541037;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=fqWP1cvvzzLBgenvSOHjdbQzbLJm8dhm2YNn3syViIg=;
        b=JnXMIpTQFF3E3ymgcA24T5QQM7eoBnLU3sl+k9nryQbBClyhFzt4j6fTNoMrKVItbr
         vmd+PgulUnxmmIjnF4/DyN/t+0nEtfuGS7VVFvaJJM89YJYeseSym6WevDadbgGdjmKz
         IpWK0nEFuEyPdirZ69aihJg/UpHcdtx0r3uVfQqXApV6gyzEhJEN3jqcnhM6XRQTX9Jx
         17cgwoD35Boz7dmWLBw+ehU8IAj22hMc4vKp087ssENcxRf4Wgztea5sVULY5/2PvbVS
         9jwwIC2YoOMqjd3Y4vjsaq7kKOp7izJcckXUOWTOdgA7CLirt4p7WJg+K0KiWH5D/lG0
         sw3g==
X-Forwarded-Encrypted: i=1; AHgh+RrxMXeCLelTqx3QM2bt6zS/aJa4PTALC4kmm3u1KpqaeDUI3iPf2OcH5cyZs6tanm7C0coVAzRbgQ==@kvack.org
X-Gm-Message-State: AFuF++lWNaVPLKD8fThe1JMvI8Lph2JLMkSovbyYOkjYvGSMiz/BwrKi
	ztzua4NYwsZnFgqTVPwKrUTuCRCcINh7EELESAOuhuudRal+5iPh1MFABwnxjiONfDfehYzwryQ
	vcgb2GTQ=
X-Gm-Gg: AR+sD12/AcISLykSO1z4zGlmuIBnYIsVhsKAgPiOkc2Ywh62NMJmSFWTgQlaQwppnHK
	Ob8avD/7Mwm9yApGJevetjBWt+7OIvBY7FjqoUUglhpyw0B9zwxk74nXdyVyHkMs2KVJr48hkDg
	8veHY47IAW4UkMcOrYcOsXhqc2PI5DFwfa/VuuPQhzD/owh8R9REYV8a/IxR/Rvf1FxiUxoyfk7
	X7DCU+2ubjhHk4XugVVR2LVa2SstMGRh0ExboDYny9nY0zpWCuLLFLkINjXQz6NDGN3iUtLFKWk
	MJlIByEiCzjcJJ43EfbdFIGX2ozm82cdjNrGwz1o8jOE6JgipFX75CrRKwJ5eKdmJoHU7Wsl85P
	IxCvXzBmlLTViDvyg0MDhysuRnb385D3CuBBOQ+RsjavFlr6EmrQq2nXF/F+C2F9892T+vCnIcC
	HxDhQWb1FDwnX1m9/cYm2zUNbiFggf3laltRU3qQkP1c+40/qw5qiAzmO6ArXbgJwK7fFcDzA3x
	BzvcTNU5vEyc8yVM8mST+PjvelAlfmtjjuRmfAZTrWM73bC
X-Received: by 2002:a05:6402:847:b0:6a5:d7e0:626f with SMTP id 4fb4d7f45d1cf-6a60d35e94dmr5417905a12.6.1787936236544;
        Fri, 28 Aug 2026 09:57:16 -0700 (PDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a611b5c3f7sm806690a12.6.2026.08.28.09.57.16
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Aug 2026 09:57:16 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6a6165b4402so1158216a12.3
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:57:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RogdKYN3FzdUqoonRQQOdymU7noX6HdBUHzSc4OXMrMap5lqCTCkMLLErvlqlnXZK4ZkF5drNZEgA==@kvack.org
X-Received: by 2002:a05:6402:24c9:b0:6a3:714e:f5b4 with SMTP id
 4fb4d7f45d1cf-6a60d3a5f5cmr4955636a12.9.1787936235799; Fri, 28 Aug 2026
 09:57:15 -0700 (PDT)
MIME-Version: 1.0
References: <apG8g-5krNRUFUuD@casper.infradead.org>
In-Reply-To: <apG8g-5krNRUFUuD@casper.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 28 Aug 2026 09:56:59 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiY22BnQkAMMc8-h6xaRksvVAbASpg=pj+=kVaXXQYo6w@mail.gmail.com>
X-Gm-Features: AcwNN1WR0kJ5fa4772K72bkb1NaLJxumbwJKKrqGtowAymofDWBsxumI0FifkBg
Message-ID: <CAHk-=wiY22BnQkAMMc8-h6xaRksvVAbASpg=pj+=kVaXXQYo6w@mail.gmail.com>
Subject: Re: [GIT PULL] Remove dependencies on pagemap.h
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1BA4EC0010
X-Stat-Signature: rtpjkpb8icp9uspgqo3imyncuj8tg7ub
X-HE-Tag: 1787936237-141194
X-HE-Meta: U2FsdGVkX18Dys4SqefRJ4fGx8KahETZiqwvcbzauEzGbcWXqv6vASqYybxcxYmbo0eVw7tmzXnwlQZbODSAJ+Vo4w2ThtwvHK7gTck3cZStV+xi8kSYgceo/4pN8/Ub2y1c5UTZbVtir8b4/12v88RVWS2pit7PWWROIjO5OaxRDg0dA1FQW2yoSBvF4ey4UP/V0q1EE+K271u0nDWWqgVX0RnydM6mpAJnuUsABRghXO6Oa5SNSExaifdWBjkqBWtPV124v7sCStJhu/t6WCeWH6NJFVFfv/6KKF0zqv+hbFrO7qnLMhfJnSJjrWrthj38bB8MUbgwh5tob9XPVgvZB1w3Q2AqpPXameWcRNl+uXMXWrqtU/3u1PgOLmir6NiMcRX/v9wvH+FhEqL/FCn/7qJ8pWaFLykPEU19VEbR/xlYyVWAFNNeCT9ke5a+x1F2hly5sqfgV4N5EHuFzhNRu7k6kUNlNgLeuqd9lJ+HDETNeixMXyjWLE7ANErBarQCAmqjRmHYL8QxhGY2dPRBViXZWqor/W2p8Mb0mGBMU6eQnsS+EAKgwlOggqhVQX4VOETBo9zUsB2ppmvq9YgnyQedQ3cHOZ+PsjpmswMwN7gicYN1esJBLg2Bl3Vln9bz3yiHRUAa7rm8KGPVOio0WselyocfDvffnmXpDLze6OIWVCr2qriFKwefNTUCL92jIkKN0SbKkkf8S6a2WaQgDdxUqAh9DwfuewG6kIQeYlXv8AB6T0DLiNuYXXN4F1TNTKVCb6KOF8x+EbvqyyBLJWOteE5/OeZyAUY5zIZw3g7RWnjjeJKmHhmPncxu4KNdesmIyJ0NY6EihDuG4f3EB/rtsVqswh6rKOMsbtgigSjYW8m7AJV7zR4cYDUgcU/z07CzUG2EYoHokx55irSnp0k/JivoTFkgpqL/fpGR6dzkBkFS1nPpDOVwkXrBGFVq+NaKhegBtGD5hv/
 0C7qaE7V
 Wwondy1OWE/9pzYzfIVsMxHnHRtxbfwsiPAa/9a9b6D9+ky3dhOCSZbFeq0THdC7ERLU4WD4jNT3X5W7x8xzI2ICoV1epA3bDZ8VTHl+IPAQ8B3KY7BWeozEt1uCdhhtxhlTuuCEf7S0RJXDTkottVThyLia8NJgc6qD9X2Ycwr7RjQp/Z+hrrmYYOT1hMvFstIpZJ/3Ff3v39x9buT5aiKb1ZiOEQj7SqzSOFjugkiQmnRJ522gnp7B2zBjR5IVY4X68l0PRaNyd/VFLf3LrISpo3sQjGMJGKdUWP4a0+lXFdIsFdYTyeJBjARS5vzwBxk3b9mOhs8IQ4K6gg8HyUx9/NWw3vyeBBqc0nO10Aep42h1HSzzTVARceX4w4wNVisfQ5RCkuwBVTF4dJSt2GgKEijeLbDoxICtFBU0ddfBqF9KeMnrp9IDVycERX75vWuxmE5cYRfkPy1AcYRt1oOLwV8YywGcy0Nu6OxfNq1p01ejW7QLZmM+Ovp5tXUmPt3oolVkXDVfMb7K2vGZiG/bvSW2NvSRfGganAzVneG48VwKRSKiQcMuT3MkZbYLYOe1/4Lc76LPqIBAJoPsXsuZxBo1Wrl3wD9TTEOGYHH4HpN1zCLL5oRjX6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026 at 09:51, Matthew Wilcox <willy@infradead.org> wrote:
>
> My apologies for not sending you a signed tag.

I'm not pulling non-signed stuff.

And it's way too late in the merge window to try to fix this. Make a
new key, and we can do this next time around.

                 Linus

