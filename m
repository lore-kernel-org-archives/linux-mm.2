Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B9B2D0EE0F
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 18:14:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9E886B0098; Tue, 25 Nov 2025 13:14:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C75B46B00A7; Tue, 25 Nov 2025 13:14:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB2966B00AC; Tue, 25 Nov 2025 13:14:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AA9726B0098
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:14:55 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 813BB130DB2
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:14:55 +0000 (UTC)
X-FDA: 84149930550.21.EBF4ACF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7C145180013
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:14:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ooyJhdZU;
	spf=pass (imf06.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764094493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oHrfhTHvouIlniOK1JX44Y+5qhnt3yJ1/3rV9t6ojrY=;
	b=25Yhq+yp5xJko7y51+D+mkPw+pV2IXvw84LxYJ+WDDKC/gp5HqsKRWPCkOkkhdlyRCF+xw
	02rTSUNIPLNab7xwZw9qW50j7/Xbch3i0V7fGDT/QlhJutNXsKvuYIAvpbnrtbwfE7CG+V
	pNKc24qZuK/5vN5p6em6x0dY4dmkwVI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ooyJhdZU;
	spf=pass (imf06.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764094493; a=rsa-sha256;
	cv=none;
	b=FlW6r1nqZslrPdULMNXBROsjHeD+quHL87HmmQYbYnGzSmJUDMYiAWoLFCvlIjFQL2YaiR
	vKnbSRSwZmd6e2LgOCY6ra86Ssc/J+MiFKU9KgoUhXdJdD9NwN3LEaYrdOH/KFarb99vBj
	A4HQUmInBpUm5xDIdVxnmm+EHhAfMNU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D1159601DE
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8700AC2BC87
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764094492;
	bh=oHrfhTHvouIlniOK1JX44Y+5qhnt3yJ1/3rV9t6ojrY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ooyJhdZUv6MRZr6n3SvCbOnRnaYZNxus6YrFQ5rmfcdbBgRmjq+x08lHafKKENEfY
	 DwcAXVeNZ9uv8SqKfeAxU/uZxrOLX3/2BOHV8TulbZsB14J1dsX0NCW9zdwSVje1ri
	 urLBQ5loypqsBVltUmoBr3lZ6N0rpCN3ZN0a2KitNyuaiO0e4EmQI/CoXr23GzE217
	 wtWzunvFNQiaqTsMRFSlBHTl/kulp9Ey928lt/8SJ8+k4pJ0iyb5cREFtq8InDqJ7/
	 rY7j8szvMWPxuAbmP7391r79VfCd0Y9LpBa8GJqYSZoUWcBEl4wiQrHCPOgxrSTIUW
	 I9yUzTbIDX4tg==
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-6420c0cf4abso5197933d50.1
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:14:52 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWH0Zshw5ZaHKw2whWyFjmWBtHlrawoVwQ6zkdqf6n8xAk+eB68Z2zUDlRIF05N6NtGi3rgEHN3Jw==@kvack.org
X-Gm-Message-State: AOJu0Yz9MkZAiEZEGehkhDrb/i+inW9PqrUpSt3egbjrvikLZz1PMGqa
	i67yMU6TVEK2ytw7tcq+fqAdzf+gkuRdjPSHuiWP2KpcL4J1JnMWgQSra3oE77WogwS+c0KdDJ+
	0njEq+koVeYGZb7HwggMM5hAROVdqOLjXhII+c79Y1A==
X-Google-Smtp-Source: AGHT+IHiUaQheL8C8LB06OM/GNG3ohiri8qCEvNdVjLbnRWtw62Up+OFETwSgD4SnpIZWUEwme++GiAqWEVlYmrDAkc=
X-Received: by 2002:a05:690e:2459:b0:640:dda6:e957 with SMTP id
 956f58d0204a3-64302abc2f5mr9760631d50.36.1764094491704; Tue, 25 Nov 2025
 10:14:51 -0800 (PST)
MIME-Version: 1.0
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org> <20251121114011.GA71307@cmpxchg.org>
 <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
In-Reply-To: <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 25 Nov 2025 22:14:40 +0400
X-Gmail-Original-Message-ID: <CACePvbVNV_JRRY8p=dXj8YntR-0nRq3dbrBPz1G2bEmGH0jxpA@mail.gmail.com>
X-Gm-Features: AWmQ_bmZExy_DoMw9GZPhfyTnvx9Rw72jrYTd4LVwD4cPz8NozoSkUMSEDIbcxA
Message-ID: <CACePvbVNV_JRRY8p=dXj8YntR-0nRq3dbrBPz1G2bEmGH0jxpA@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	pratmal@google.com, sweettea@google.com, gthelen@google.com, 
	weixugc@google.com, Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7C145180013
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ue4ccgugr943ir8z4oh98kpzwkg14o86
X-HE-Tag: 1764094493-12164
X-HE-Meta: U2FsdGVkX1+h+pa/uPGRY1hB5uZrDdzIyOHABx9eYMLYeXeR/LcEnz2/j3QCP29xvCyXu881RuzqWDQSnTkPUnDuI4sjUwDoUyZeDl84yTZABvg4hxTM4ZK0xMoLAS3czv5VkrzAaVSk/y4wI0vJpGbFp/AL1gbRjMSR3NLGddwOt7xGYllm9KuTHsp4okB9hsG5oO1AEZGnLcF/fAqGBUZ89LLqsZsyQ+59FuL8C29PDjK+h9pP9OlT7V9fvrPwfKz9hrnndG2HMw15AI8A1IzAUs59dICvmKqjAU96YWle9XHuELFepojUpT0y1TrwqBO+uF2np2Gy2QVMP0nPCXaNhyONqMrGfIP0RccwHb2jT97niB3/TZ+8XnV0Vny9GiKZDp+wfh5UzhGl9Ine60U0H8FbgDTQKvelCNoo1J08OJ+/dy7Qcc6fTh0siAdUh3UziQfxuIW4rk4lqEIOtBpxCQz/USD7egQMWVLWK3GrYgKWPQzSrHHxBAYQ7J7GrS38gQwD9hrb/Ncs62Az4IF57A8ugEqo6oU/C1my4fkg6Z6r7SWM3OKRebT7EXfn+UUNxxElDBT6L+uSoICKLU0jAabQJ+l1tPXQaUZkz+o72JA9U2Xmo5nVaoBEXtQr3k3rYeEHxl7bQeGsEtadB2BFg/u3qVLKufoluJBXO1MGlTsVM///cXnyHIe6FabPOabzc1+kCVRew/HGHh3b1TfwM0o4mBhgwKi2FkhoMnbPbkmNkxhs1VlIibwbcz2jAZbW2IiwRaw0P5cyEj3E2RBz1AKxIxtj9g9YIETkA6JUvQcviikzk9E3MFN0x2vUlyiAapO74+PZnyuQOBMy+7Q9NZ9EMGt+TS6e5Km5ye7ymNqW7D2Z4Ka630tPUAT5eNVZKb+A9IXOu4svK7vJQN0NS817gcZIwngA0xjkDyUJ1HjCq1smq4jiNuWpgVrs+pfL7oue6X/4ZeUxzZd
 aoXqaTVG
 0bZkMGIgjppL1Dj2Bsn+RC/hmquyQrEpeC9rzdn3to6hLDHN9Mjq01RmVBPOzq7rQS+DIG3AjBlSKtikDH+K/K7p0FxsSNRl7H/GgwslXo81WdSk6co/GlQlgYXujHQmuVtck8ZAtIeC5TRiZ3qZrox/ZqiCqYUfkNkjt/7yG/Wx8RlS+1hQO9qfiYzJVDBIG2QLn3NZ1aLiVWzI91wiA5O2M9bc/bHfteTwm2QR5hvCEswxtJoSf6E0Svtdga0AuIEhTw5uJiwIomrBe0yf6q/ANShmzTmFqb0BlosTju1QlRrViQtg05WihQ+hcZcCpX+qkqtgJz+Vc1t2eEycqvHZjj6EvxQfFFthurgE6Y/SWSBWOIOxhU/d8vA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Johannes,

On Sat, Nov 22, 2025 at 5:52=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote:
>
> > Nacked-by: Johannes Weiner <hannes@cmpxchg.org>
>
> I take that the only relevant part is you are zswap maintainer and I
> am the swap maintainer. Fine. I got the message. I will leave the
> zswap alone. I will find other ways to address the memory base swap
> tiers in swap.tiers.

I am sorry that I have said that. Let me take back what I said above.
I was upset when I considered you and others blocking the more optimal
solution and in favor of the less optimal solution. That is my short
temper, as usual.

Now I can see that you might not see one as more optimal than the
other as convincing as I do, or I haven't done a good job explaining
it.

Let me offer my sincere apology. I will reply to the technical aspect
of the question in other email.

Chris

