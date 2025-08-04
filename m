Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D57BC87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 12:34:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B34468E0002; Mon,  4 Aug 2025 08:34:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABDCD8E0001; Mon,  4 Aug 2025 08:34:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95E858E0002; Mon,  4 Aug 2025 08:34:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F5BD8E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:34:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4D79280554
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:34:17 +0000 (UTC)
X-FDA: 83739017754.15.CD74852
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6543C1A0016
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:34:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754310855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fcJzP/9/e6F+zsAx2xJXJXbGjsmtrULT3/IuUM37nhI=;
	b=UAlouFdA8eFAUACBgO+VX7fT9SKCf6XeHOoqS2lINxSFrXsAWnNLwxO8Qm+96oLP19pM2q
	qLBU68pnA2FbK8mzvXM7t/RnmnZeouxxALvT9Onevw1wrj6VPt8M/EVGsTVcRAzA5+7ELX
	l9qKbb74fLvy1fYdZYnrTV9/jhmidX4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754310855; a=rsa-sha256;
	cv=none;
	b=fllLykWLt62nCX3vKRKc5lssW8lj4AR6umqtWDb1rAfFcCyOWyGAm7ZuT8YoCtt4uQ7B2C
	Vyn/LF3wwz7Lp7Px8dAgv/VBx/s14dcy7akFcd+BpQfPiONJpiiPH1SsC82pb3K5N4OzWX
	CI14UYLyT8EH1f3YIR3SeF+munvzRYU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=breno.debian@gmail.com;
	dmarc=none
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-af94e75445dso300906466b.0
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 05:34:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754310854; x=1754915654;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fcJzP/9/e6F+zsAx2xJXJXbGjsmtrULT3/IuUM37nhI=;
        b=iA7YGJM/4d/XQE4vCeMHfGMrtSJvZg640rzDdYTS95gKXJZahInjsJEe0GnBXZq6S6
         Qz+yFmLZbrk8RrY+VJBbmR3J7VCMSbFmvkIZiZZtDbgbWohEfoccyjrh07AgHN3ReAWZ
         AKDrX9uviAEcqrwFHPvV1YgXGn4B6nrMFIn/jJsmBMM7Ax5BCqtwO3qJrbdV2aqkrai0
         13DCw44fuOY6afa7kAJJLGxWX14+pelIx6IXMoXqGxg1GXoHgtrJ2GJb7D9vvVREpN+3
         Qu52sLI1l9aIEM3w/g9BPdk2nhAWo0yEm6Td6Mq4NkufwVDA1m9RpR94n+7hVGKdu/Uf
         ZQEw==
X-Forwarded-Encrypted: i=1; AJvYcCXSDqFzI7IWLvIvW0kHNnGVjmwLR8hZ2cIkknJMqYaI/F8kHmbR+VfF9PagWwUkR2QML1vqlL6pKA==@kvack.org
X-Gm-Message-State: AOJu0YzP5Kxgjg34Q/D0zFrLuZhbll3Pbd2HxrEWdZuWELohkYecdwIi
	BykiHPGCWtV8hzXFab3byjUZziUQIRP5PYhiHCbR80k8o6yRzqpOUXe1
X-Gm-Gg: ASbGncs58Rk8C0OLBcNnmqxCCdP7sJGEuPZ2X+TFXS5G3nBGsjYJAMaWPdgH3giGlvf
	whyPv98DhpHMHF8O9mjpaHY6rtJE5mLpXNBmXhpwcCHZnopZxHN0higHqOIT3Jfip1xwdZIXEJ4
	Wd4U7PdIc3wbCkUlOqviN0KPrf/PO/CObiMQdW4xYaLrpggtYbbpqj+/7cIpSrDoGukz7Zv/j5N
	U+tNplYIDZfaDpLAXkr9ZdsZ7F192bVj2gvvj8AGLmnnnu1Z0qsN8abDiyqDYEistw/VFRAPkoz
	rp1fEUg0PLctTYW9iBgi1J6oULueks3ZSh+FlhsKnlETuRntNKmOeQvBgVse9Wf29JxvM4Vk3Af
	HeHzL61wOJ3Xdmg==
X-Google-Smtp-Source: AGHT+IECUNouT2U9h5TI6BInd7LsnZbMx7FCXQ9fV1tWe0f3xyBoO4sFI73N95UIyrcsouvL8Lh1TA==
X-Received: by 2002:a17:907:2da5:b0:af9:38ed:5b37 with SMTP id a640c23a62f3a-af93ff9ffa0mr898859366b.6.1754310853621;
        Mon, 04 Aug 2025 05:34:13 -0700 (PDT)
Received: from gmail.com ([2a03:2880:30ff:73::])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a1e833dsm717785566b.64.2025.08.04.05.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 05:34:13 -0700 (PDT)
Date: Mon, 4 Aug 2025 05:34:10 -0700
From: Breno Leitao <leitao@debian.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Waiman Long <llong@redhat.com>, Gu Bowen <gubowen5@huawei.com>, stable@vger.kernel.org, 
	linux-mm@kvack.org, Lu Jialin <lujialin4@huawei.com>
Subject: Re: [PATCH] mm: Fix possible deadlock in console_trylock_spinning
Message-ID: <o2gpvdtxqrdfrsbayorvzvjqcreb45puojpgfye7dimbuuvbdt@gxquukahrxo7>
References: <20250730094914.566582-1-gubowen5@huawei.com>
 <20250801153303.cee42dcfc94c63fb5026bba0@linux-foundation.org>
 <5ca375cd-4a20-4807-b897-68b289626550@redhat.com>
 <20250801205323.70c2fabe5f64d2fb7c64fd94@linux-foundation.org>
 <aJCir5Wh362XzLSx@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJCir5Wh362XzLSx@arm.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6543C1A0016
X-Stat-Signature: shao9qsy5znsuz4pqp7rqppegcnicmn5
X-Rspam-User: 
X-HE-Tag: 1754310855-933093
X-HE-Meta: U2FsdGVkX1/GItMGe+JRCwS3zj4ckkEbVWYJFNjoKPk0FI6D83c80idWXsaEWmPFa2m9ByV+4BwN0sYIzwWdOh1HvM6zez/dS1N6/GHedU7opEsgh+AmXDgsiGJOhVLD9/dnMBzlIMJ8WK8U9rv4UB3B16QUm9OJ8Gc1WzWPk0tUf88qoJIGgoVb9ZSQnIBYmqhHpkorHT/hEyAbZI57HJaqKXV/hnddL7sx9+LAM4yCt7s4sAn/BYHcc6FHuu4rhyw/wjjLXwFa5dLAkUM01/O6TjXfQNE4XnJjjAp+0oxAnK6wbkbDjeZF7FXTnNyHt9KPfw8Dq4g5uBhl3VPxAY0y0gmGQcO7mYu5SGdSzK0RV4onQXHT1uqLbCdfSgCuKZsjp6BtUuKeegn4uhIChQK3QSxMu0+KOCH2Rs0pnkWv/x6eWXxgfVCVq1FtbaY524bub/xm7QPr8mEH1qkhR4YjHkC7YzWOuyvawzocA3EyiaLZ8u1pVovvwRu95cEerxRWbFI+j30cR4THmKKcI2ezcQmE1iA/kJiBG/A7mLQRTtZAiMf+VZqynbjSn2SsVkbOyTZyiEcpcnLcZ9ndVbGVKCg3OJHE1ShuoRxniPS6ejaGCbChZuR4nRIr7QPe/Hs5O+MDBO7/ZxGJ4diA0fCpzcGVubqXbnkh0BDv/hF1rELdn8HHRPX1T832QNUUGuk9nNNixVW+mkRjxVIPnkv6Im7DS/aFp8wxohA28CiGhNLIZ4voWTiHBrhgXN0fQ6M48fGEP9+elPMATwB0MwN7EyOGmxfkPeri0W/B2hYIIwIqPlVUddr7KbQujJTMHl58mdI/iQvhZASJziaDaQBeMt2QuNfZnltkwL5lF9ehMa/mZrQ3qSsvWedCDwfzDlABeW3imuQDO1c5YD3THA6/eyo3VV3/Y3hF6E7ml3e5I1yRhI1yEQsIgGlYpc0r+BdwrFGdDnGRK6AyA0r
 ikx5wBEg
 cLNu3GvXvniREqknb3hmGbHU5z9RU4I4TAW65uAIsd6CJt4kPGoOiY2um9aGdOluUFokQEd84+WTFgg4YLs8+hbBYIMGQWb5wwd6WBIvdwhFPB/eyNDwJTh8jh12jZPXYT6nfFYq9sYU2l/9gIPAOUpQw0AlXmIRYjN4hN894MXgkYyqMXeHRFnGDlhG2imhOz8X3TNY8wKEUmEWy1owIjQZrFRT4SBMMSFOsklQ3ABXEIx2L/f8Fjhc37Vpf1G9aO05kzfE2zmf8XybPMnrUZNB/+IFl6RIQhCAk9rSU7IBJyULwmiPx2i/VrgI7CNZ0qF15srU7ZGtK8/gPdAwzhfN45j7j43ZLWkgWtJ1sJveU7XmQSzkrvrw2IJa6koHooY3VMIwGelqtH+7br9HamJLZUhnnLm3eZQ6KSO3dhGyn9cklULK6PxM6c98QvzILV/0YtbrK6RCGLDg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 04, 2025 at 01:08:15PM +0100, Catalin Marinas wrote:

> I'm surprised we haven't seen these until recently. Has printk always
> allocated memory?

I can talk about netconsole, and the answer is yes!

weird enought, lockdep never picked this issue, and I have a few set of
hosts running kmemleak and lockdep for a while.

This time was different because I have decided to invstiage the code,
and found the deadlock. Still, no lockdep complain at all.

