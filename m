Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65AD3F013F2
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 09:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B2276B0167; Mon, 16 Mar 2026 05:14:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47C736B0168; Mon, 16 Mar 2026 05:14:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39FC46B0169; Mon, 16 Mar 2026 05:14:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2451B6B0167
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 05:14:28 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BCA028725F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:14:27 +0000 (UTC)
X-FDA: 84551365374.02.9088A09
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf15.hostedemail.com (Postfix) with ESMTP id 01784A0005
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:14:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KkXX62ub;
	spf=pass (imf15.hostedemail.com: domain of 38Mm3aQkKCLcXifZboveidlldib.Zljifkru-jjhsXZh.lod@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=38Mm3aQkKCLcXifZboveidlldib.Zljifkru-jjhsXZh.lod@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773652466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k2x2io23Ni1twKL4u8xriZ4A7jtPDDRWW6RQ292OVzw=;
	b=Lkg4KJLeSticcNRiBJ6R0PCbjHFc7IXpBXomicTSQ36+bkHJOWE56oprVQhsw5jfwZ595c
	sFSESUF3ACg0cRAr0e1HufNDFADaXbO5jhsTxaPJz4ee/8QXCuVkQP7ptIoLvKGuZhpWmu
	a9cN+NG5o5sp1RSsW9rECAzi4YcDtAQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KkXX62ub;
	spf=pass (imf15.hostedemail.com: domain of 38Mm3aQkKCLcXifZboveidlldib.Zljifkru-jjhsXZh.lod@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=38Mm3aQkKCLcXifZboveidlldib.Zljifkru-jjhsXZh.lod@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773652466; a=rsa-sha256;
	cv=none;
	b=Fw8NzxtTmieJ65gQq2D4givOVI+vEJXNLNjK+USYOGl13i/3vTdQFEGwzmw8ZC9a2rrj2S
	xE5iBnZP1G5lcnaVawABpKteRmuRxYOSPg47g9ZIEwSXFpaPbq61MTMfzGX4boYOqgCvFb
	d/brKCs1fINYe97cjnvp6wTW8P2D7PU=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-485389bf0daso29550005e9.0
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 02:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773652464; x=1774257264; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=k2x2io23Ni1twKL4u8xriZ4A7jtPDDRWW6RQ292OVzw=;
        b=KkXX62ubuvMYpLAhzlPUdASPZ0acoQ0Lar4JAhkhj+MTdLp8KLXswqg3B7j3ehb9Dj
         FG7e4JLidGFzyLLS2x8XisEL6X1G0Jo7cVdPFuu+xX0Kr8MrRJEgZPjpfdQPyIFX0wBz
         ro/2o3iKxoZmc1QORSbKHbbIfdHqI/Ue7VUAnM8BcsADqqPNAYfJLhH3xZysHPkP73O8
         VBMkPQAxCSkfEWmYRuZ+HYq2XIiZbUu8uXlXsb95VQxEfQwn/Pr6pBA6byKiLZj7Hkzn
         d6wrM33ryR3rWfmOS/RQnCYcja4EadVZCKDd1+J+T+gfUQuiLBzkQb1kwkCYW70j9uZt
         iVQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773652464; x=1774257264;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k2x2io23Ni1twKL4u8xriZ4A7jtPDDRWW6RQ292OVzw=;
        b=h6fKWonIA+Qbtf38nWZBtGE4YDVeijFvGczQ1uYZw2wSg5SDD37iIm6KZFnIxHrskO
         5oYH3B5IE2JWBCou1yLS+Ba0FoY3YvXiI0qbFyOptiBz98BIYPxa+yYATmjz4+CO8TNU
         KbcfgVa+W1kbS7GUVI1WjrtY37GCklYzUbiHxP8mgamCTuc3lDQ5xYMkR2cLxerbok2N
         2NWhj+pNU7jYrN70luF+Vpm/vUrc0ZK42RrS4D9FQOjSOkvSzS7szllBXpHx1Hc0v9NB
         l47SC8/zXzWqdmKr9YQJ3oYzjw7//in1MnLUbGkOaku4ZkgoixPNWzTnDMYbjCgywuFT
         pg0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXJn0/mpqEVVHPoLslgjC3QzI0heVog/41LapGXFitpqVArxwo/g0wq8EeJdBAZSaezvhNq+a95MQ==@kvack.org
X-Gm-Message-State: AOJu0Yy2yW9VQOBgwVpHpk+m7Qo55mH/i9jzTtVZyfDYwHHdBL3Qairj
	nR2vxq0+2z/GkyAMfMhOnFYgMcDrolDp60oxabcYfFymJkL8ZDsqY99U8bsFP8p9Ab5wlE0/qnP
	RPBKFS4qYp7KSgkDYGg==
X-Received: from wmbip40.prod.google.com ([2002:a05:600c:a6a8:b0:483:7f25:eadd])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:644d:10b0:485:30d4:6b98 with SMTP id 5b1f17b1804b1-485566dd75amr146115915e9.15.1773652464242;
 Mon, 16 Mar 2026 02:14:24 -0700 (PDT)
Date: Mon, 16 Mar 2026 09:14:20 +0000
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-1-de9a7af4b469@kernel.org>
Mime-Version: 1.0
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org> <20260216-rnull-v6-19-rc5-send-v1-1-de9a7af4b469@kernel.org>
Message-ID: <abfJ7MRwufOS2sxE@google.com>
Subject: Re: [PATCH 01/79] block: rnull: adopt new formatting guidelines
From: Alice Ryhl <aliceryhl@google.com>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
	Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Lyude Paul <lyude@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, John Stultz <jstultz@google.com>, 
	Stephen Boyd <sboyd@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-block@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 01784A0005
X-Stat-Signature: cf7woqo5n51rse1o71mstdsimpdebxhr
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773652465-426513
X-HE-Meta: U2FsdGVkX19UhLZsvjraNV7N7LtHzbSF9ifydK/c4F9gEVofws61nvLcLfdG5GY557fYSDmR0kBXp5Okl+HcL3XqOLGGUWPasBthWmK9PF2VTxzJDXtrCqKCvDJyNMS4HRcfg8YrofjJ+36j89yE8017Z1kbQL8t2ZwzNQCt4LvIRWcslHOKo7AOEpGnpDs8ViAC0b5aNZuNXBppvAx+wdZgYfm4XDHzVpyZofcLjzYjvSjw0boq/bRyVi+vv9EkPObNjjPOsdsm8fnaR/QtSOhXPqpxum4ewMrP2hdST0MB6a7H+3ZY2xcNBUEkioCF97x0hzYVCtXDX8sM9/9JpUTZbwA7+wmckmIZNROH4DzAIHLXqptWT6NP1uesi5jg1CTQFCco0ZgbViuS3n2beqnffrOtIr+R3Z4zvu3OypeFMrq+SrKCpXzkAtkWTm5EkEJOVvKJXvAUZUbkMrawN+mC+yPL6XreRZD8l8qYdLD6aO68BvHmcvk6ZzFNyOd6MlRQ3kKBXttfqotEcTxPlsQ6EEhMlhgWuhLRMMDogaMmAQ0F11/7uloxPMl/0gd5G2CzXFP68F+EkIwyIxaklcPlLek88Qcn2Eck0UYjOBQ7E/8DMKnDubqnlre0YTPsIasbWU3cmhxzKMICa8uE8UjwdFUzaFxjxPdHuNxdhiYo0nwJVwRhsJjrB4Fj8RZaNbc4loLQyZTYi4vdlHGPMLwonPyRUFkS2vrnbu3pZ0Au6xs31BiTgeaABuWWKhxb3N5ghPlFOOdCiJoIXaVOhXu0reR1mumJ7gIeeJztbYtmSDlrZ8akb7O9OQXCDgZfGpcn1n2IKAZqlTbVqfP9ne2MZm6+EKIppVoR6KWazQnXy4HV2cESIU0e6mpf8KM/evXYuv+kE3fC54N0PWtV8o/DA12bbMxWVUkSdeElkCfftRSvWvhFLZSd2jNlv96w6BnoW5rOmkbtBmBiYik
 U22EsoCz
 QyJgLv4HymehvtWQqQhfM5YAftIg4DPJxOPhkG9gT2wDUHLnB7QbSrncbCU4cD8wNazzRaWwP5am9kdDNeLEMZsDaCHAwnCxJX9Du+GkNod5UpaP2ontko3McjMBpK4ggODuScx2VOFdfHdJMjNtegcbIHwZZ89Bk7mbUHezZbFwnrvI4V7bJdCiDq9KQIUBCSB8Eb4f+jsSH+ZEJ72+ynBmK2kJZxFpSXCHbZJEMs9Oxxbs+/XmgROSsACKxvDMKJZsor+6nGCxNeUZH2AXU/9v5e9RTTyVNbgTn0b7R8xmPx5MYYD/YEt36obX09eG1Fu9Ofv5f/3N2qrKmViUKLD1wW2XeHzsAaoZ2B6W8lkRTp/lwn3Wg+JO8VbIVQD+C9ejdnrSb0WqjZwXw4RHVDOT0XrxKbxoWxRDloL2bZKTb8gMvPUDH7XwKulvlKvlaoiNR/Yr/2bnWHhXMi1mSvS7Lqka+Mk7xgXXkpeKwoLEvRsSqKogUaq7d9t2BBdx/E9GLWKFJi55TqEDKUIrCScX+mCmuP1yPuos1LdRtD2ZDsfsbbMtmxe/8/fAIgxy/fmDmnTEabVMEwfaQ04+ECh9+YOHVmxDymsf+E/1OpgrCQD0MI4LIxdRN87YVRVosE3lLgmuEZY/8+R44W6XaG9G0GvLR6ayUKySSVcTKJLM+6aHEy+LlbsmN4y/37J07QtJjaK1g6eQMME51caDwkEI48DvIZS4zWFGAx/NPnhcB0SoJ0bKqbaxK+yrPV1yGsWv8jRaE4sjtiNqDdtG1ceOBMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 12:34:48AM +0100, Andreas Hindborg wrote:
> Reformat `use` statements to have one item per line as required by the
> updated Rust formatting guidelines. Apply a formatting workaround to
> ensure `rustfmt` produces the expected output.
> 
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

