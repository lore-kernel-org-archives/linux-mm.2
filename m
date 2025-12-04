Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94DFDD2CDE4
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 23:23:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F398A6B0032; Thu,  4 Dec 2025 18:23:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEA966B00B4; Thu,  4 Dec 2025 18:23:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFFF86B00B5; Thu,  4 Dec 2025 18:23:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C97A36B0032
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 18:23:40 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 57DBE5864C
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 23:23:40 +0000 (UTC)
X-FDA: 84183367800.11.4686FC3
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2785D14000A
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 23:23:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=gB872J4J;
	spf=pass (imf23.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.53 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764890618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GAMF2P1zYp58T4w3wjWAVp8ef3GzCCouN500xAHns+k=;
	b=el5WSHTJI/vC04N2wv6C9Ic+kGC/WXGpyNUO/FLdJsjdfUBAjLDI1glc6rudK/YOy/Cu3I
	N4PbXqFVTaqLHwQ7YLd4x29devx679DZ0PxkgmG86RiDFNw2zC3nTNbeSE8+k+xf0MTfBh
	twVdHPla81i2rG/CbBKAYBtVdCeu5vQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764890618; a=rsa-sha256;
	cv=none;
	b=iO5kf6MYsXqOkhTwl9bXODCRso6bJQwdxCpgS5X5CK34dSVyZaesAmLVB8ejH4TBAHSSpK
	JA62tIgu5cZtEYdAWNop6Yrympz4AXq5rSLUSd/VCNpq5SW5I/sn3mej2iEYcnMS4l6mOk
	sSMYefoekKRwdUzhR1I1wDK4E6TRaqU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=gB872J4J;
	spf=pass (imf23.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.53 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-640b06fa959so2585555a12.3
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 15:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1764890616; x=1765495416; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GAMF2P1zYp58T4w3wjWAVp8ef3GzCCouN500xAHns+k=;
        b=gB872J4JmOUbInggR20Q8s3S2gsoFBtcwbi5vyNwk0TFtfLbd9O46hQI55kj6AaCCv
         kee+SJzapmp+RQlJDpUNGGNfCBej748a2NI0PY5/foa/eaqMMHqGdi2u/uWTGEV5Ro8x
         IzjxNgRLskukpysIAYhtxSNs9JauCWwDrACNs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764890616; x=1765495416;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GAMF2P1zYp58T4w3wjWAVp8ef3GzCCouN500xAHns+k=;
        b=lx+UnjAe5gAFDvzpscqtBuF06u0XL56MYSIP7mudqjQKGO6QgxfbSPeMBwDZJ/dXZv
         fyEz9HGcx5qXWJILeGHkZbdl8gXswdcRgTvk6I0kwSNuwibCA7IhIW+zTTpc7+ri4u5b
         RHN8XeJqu2A6wqDn4dnTKqUggST2BisQXq8I2C12O3v6tJnldrQKdieUAMw9ltvkHhro
         014h15e43u19GoYmh1nU7I0vE1YWIU/K9TuCVfDlpBLatgYAOgsCdS/on8XWlgQWYq/O
         uo5KgvqXjDYFdGfttcKG6d5nPWnVmGefg3/NHDjX+626zw/uRNw2hUMqE4ox+tO2pb2R
         twqw==
X-Forwarded-Encrypted: i=1; AJvYcCXD5+4R1YT1TjnD9waf8KmdcPlUS8aZfayc7MK1qo5vLwF4Pj2d8dhvW+oGb4gZmTaPAjRQdki8sw==@kvack.org
X-Gm-Message-State: AOJu0Yx5Tkthsf6rIujWYThsY7zEVmc1PL7VUKfzLToAmqVpS/gt3v+1
	htpWsBzTFdLm5l9dRDP54UKY8ZqJbMOsWd2y0QXGxeZ4fblHkQ3KGrQAi+LqZMZBFfxTkhQb5Mp
	DYIwQjSE=
X-Gm-Gg: ASbGnctfOLkZx45UT8RDcacy4Y85Pq4ZaXNco8zSSQmxNN+8IzekamlJdhpK87OK5fR
	zDjYrs7cYuHuC5yH/2Lo791LEOM0GAhKkjjJhHtmGwRJlQrafiCzdYOVeBemWavfzn8fbBQS2Wk
	fl442J3yNReUmVx+uNfxdsG0uLp+TGGdV1ivO5FUT0s4XLTvUbYT8c4r3G4D1bnlcTBbmfaYVXq
	cOYn8vQ2Tul80Y+oG2V8WDfP4szZbNf+4An0QiUl993KC6cToFE4FwIAkhh7EAfp//Vt8ZlRsye
	3PA8G38PkrsEFYOz7fv7f90tJ3XiTOJACFzquhzOQdsQt9xt0OJDK7RnXN/Rx24H9rqaf9q1ZQS
	YTbh86rvGzTewY1Kz5ak7hZmfqvglyR5hLo0BkFuiXPFu/pgWn+cBkDdW4+GUT4ijLao8kn8YIm
	/ceA2HDouJ7cB5PXW1J2kK+3himN+WCIUGWZAJJdZp1VzzOiKJTgvXJvFjCraDdf1GownAr1U=
X-Google-Smtp-Source: AGHT+IFZzlXJDaek7k6MaXByEIvkjP+gvuXO9FgujRvEuv0tHP7zbyuxpCAfEvjwBsIhkkIkOsLHIw==
X-Received: by 2002:a17:907:970a:b0:b04:c373:2833 with SMTP id a640c23a62f3a-b79dc51b077mr721083666b.32.1764890616118;
        Thu, 04 Dec 2025 15:23:36 -0800 (PST)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b79f4a53b39sm237680866b.67.2025.12.04.15.23.35
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Dec 2025 15:23:35 -0800 (PST)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-641977dc00fso2024065a12.1
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 15:23:35 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXM+p6D5RHH/yAqE7TGeqPc/hOAS04Nlx9473JkRVSg4F2LfHw6RukKrHoXZwl2IWTVaBUQ0JbnJg==@kvack.org
X-Received: by 2002:a05:6402:278d:b0:645:c665:56bf with SMTP id
 4fb4d7f45d1cf-6479c484fcamr6984906a12.24.1764890614735; Thu, 04 Dec 2025
 15:23:34 -0800 (PST)
MIME-Version: 1.0
References: <74032153-813a-4a40-8363-cce264f4d5ea@linuxfoundation.org>
 <1eb24816-530b-4470-8e58-ce7d8297996c@roeck-us.net> <0425d7b4-76e4-4057-83a5-a7b17a051c54@linuxfoundation.org>
 <ec77d11a-7613-4b75-8c9e-f2bba1595f0f@roeck-us.net> <9d520a1d-0b8d-4d30-b29f-230fc0f92b8a@linuxfoundation.org>
 <1f31b86d-283c-4878-92d0-ab90aed0c58d@roeck-us.net> <5af4522e-30ab-4eec-a861-c2760cdabd4f@linuxfoundation.org>
 <2bc690ca-fa57-46fa-949b-28b5441cd364@kernel.org> <b24fc85c-0e6d-42f9-a6b9-05136409098f@linuxfoundation.org>
 <CAHk-=whd-k3GhNGvVmP7W2p1d0d4ctqJ8iCuG8DbyKzgNqCL+g@mail.gmail.com>
 <3b6d6e50-91ac-435e-adad-a67d4198a5b5@kernel.org> <3cd2240b-ec2c-45d0-b73b-b66c83e75b9f@linuxfoundation.org>
In-Reply-To: <3cd2240b-ec2c-45d0-b73b-b66c83e75b9f@linuxfoundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 4 Dec 2025 15:23:18 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiEXy+7Gd3ONQ-v0e61e6qAmrtk+WE2dpW_61p83nMgXw@mail.gmail.com>
X-Gm-Features: AQt7F2q75KScWbWqgcI8F4O4T3lWb1voNa-u0o71vR1GfvutFdi37cFnKktDY94
Message-ID: <CAHk-=wiEXy+7Gd3ONQ-v0e61e6qAmrtk+WE2dpW_61p83nMgXw@mail.gmail.com>
Subject: Re: Linux 6.18 amdgpu build error
To: Shuah Khan <skhan@linuxfoundation.org>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, akpm@linux-foundation.org, 
	Alexander Deucher <Alexander.Deucher@amd.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, amd-gfx@lists.freedesktop.org, 
	dri-devel <dri-devel@lists.freedesktop.org>, Guenter Roeck <linux@roeck-us.net>, 
	Linux Memory Management List <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2785D14000A
X-Stat-Signature: ihtspff8c198zbciz9cq5aeu6aste4aq
X-HE-Tag: 1764890617-775679
X-HE-Meta: U2FsdGVkX18zD4os4oVQEYwrONa1BAv7GI36Fmabu5RgnsVNzIkrj5sqyEa8qlMrXQIjb4NtJXQzrG4JrWwJHjW6ltbSNCe83S9GbuYZ6W5271Ljuzm7RB2Dw/Drtyi2De0eR1KI0lzp0VB1jc9jAJeyVO76m6/CQGSp/ogpUyx94K9P90oCNoOppJ6aWGCIwlWCoV5vKvDEbmFJPBpWLSsLjNkq/5xL+2tW8i53KW8R4w7CvR/BVyORNPjDY+Kt4LEzPyAOY039V0lq02LIfIMIuwHu/tpfpJC8eBgGj/L8XyY9KSvJb1F4luTz/P6xB6WCN86rww3TDA/u6tN1vheZ82RDSMVzul8prPd3p6Z52TxJqVR6E1t2ZTOh3bup+j36s2Pn9bJg2gwMr2ZaY2sT32TNQiXUowd5rsfaZrvyyjZ+3C/CO/76Hlp7C59xGf0+NLE9O1/Z9UxSbYc//KQcL31hVgUwMSXV/JQpzd5NfA7Ev8tvpK+oCPdxnjKC/nNSe/rlzLgd0IiU7B99DmflM7P+DYSod6GM6m/yteHqKHpXrUywLdisrvZDGrdVFiCJ/UqEcClb1w445ZCheYC2gwlqq5uuN1ChaqiBWAAMQzwZH6QeQFs5aVBnNMv6jyPJk1RykNVIW4uEsej9LRCkHKSvVQw1+Me2NKsrLPHc0l61Umh1U7FQz0HZjJulMrX3Su7JorPacVq9y/pXYBdIrvpKDPxy+Jn0H3QXAfs6Dk0lYDQ4cnai36xdo9u/4OyVzIifKE6qHIMkoA6x2esP8ny8YbPIGAIuH1Fybu1KNkOMWphysCZNXn35KOeJFe9bRniWsz+fNxuWHJpdaSOiTKGKnaogsseaA8xD3lJBJw7P5XQ8q/Dj+hsuibwwhAzicKQStga5TRpL+f0Wr/p6X7LnB36g2BiSi6SK0IePDeqv9pw7mHyNFi7y4h4CRyg1zeiZ4sIsjutHLYh
 nBPWfQ3b
 jcIHWb6Y7OtWvTLUWyvj13ObaefflptW0PTPk2TMMZj8XfQujz9EqeEQIi2NDjeJR+ZA1gxICNURhX9vVEAWEiwIIJVL2X45ROtY9eASN8s+/0hItDhk94EfBEMDGAIAEZJ87v+adrB3lkPT4L4yuNbiVgc4XoWqwvaLGPVLhYLpq/ZA0/pVS/lWoDfBSWqCkjkzBwvlCChmhD1q+QdI3am4jW5gA3xhNSGzHRqecyMkRKAo2qSllFCJ/epEBon6Awp+MhgZJhajMDJ3PE21dguRiYuyi9NQWoyI6HzQg+bjVwhJTEg3JzcPR1J+fjSMFJU/YA2Gwtf1goBERNcB/jPz8DogmoXcmL/emKQ+SOkm1/6eR1OR2sSJylnLYNCUnw0p5FnKgNA9qVCfLKzmvbDEs3bcIPp9r+wudQ8vLVokLKsojCFYcdHPiGtz+sFCLvhV2nnySpAak452/dRof5Ktrm1DIkRa+6sQEOUlWHgQeBPtWXAfQNURN+74wPw6xNR45jMV54fC/xpWYtkmVw4OkRzuPkyj3R+uxAxkzgNFj0jP9TWfjtnhPaOIZrF+OSH1juAZruZjpTdeR22v2UPM4HFFUsjbJ07btrpnCluYDG7xD9WzM0mlLob8TQBHOUaaT3JDeFY4NE3xegf7EvRKzp1wywSjGo+NfbHNAlYfBu3HDGYGwYfGMxg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 4 Dec 2025 at 15:20, Shuah Khan <skhan@linuxfoundation.org> wrote:
>
> I didn't see any problems on 6.18.

Ahh. So it might be just that buggy commit adfb6609c680 then, and the
fix already being in rc7 (and final).

              Linus

