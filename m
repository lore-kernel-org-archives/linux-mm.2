Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1F89CE9D74
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 16:05:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 231E56B008A; Tue,  6 Jan 2026 11:05:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 209536B0093; Tue,  6 Jan 2026 11:05:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 115596B0095; Tue,  6 Jan 2026 11:05:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0240F6B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:05:52 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A12A5C1B00
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:05:52 +0000 (UTC)
X-FDA: 84302014944.05.78A709A
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf27.hostedemail.com (Postfix) with ESMTP id 903B040014
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:05:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=QFkH1ImA;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu;
	spf=pass (imf27.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.160.182 as permitted sender) smtp.mailfrom=miklos@szeredi.hu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767715550; a=rsa-sha256;
	cv=none;
	b=pRILQbzSiy5ozmr2+GNySXg2Nofhvz8k9hCGmRB2PmH3hzfUQ22c+mM9D35zbxenbdM2nA
	V5s3grQk9vo36TtnRGJRUMl8JhT4YvKMG6Q0AipEQ3/eV7LcofYpHEuLFVg8hknnEhX6fm
	+/ig+/A/25IIbxaAetyrkXa8K7+O9Gc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=QFkH1ImA;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu;
	spf=pass (imf27.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.160.182 as permitted sender) smtp.mailfrom=miklos@szeredi.hu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767715550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bxubu6bhf1aeIofDmdnq3Yy4S+a1o4zcmmWzD9LU3qU=;
	b=BBc94AR8yQS8Kvw1JK9RZrHMhyIk0FC5Vgqi8B7c91NDKLU7OdDh6a11sm/PwTVT3NPQ5W
	9gJ9J4Qkcx++WBYsymlRLswLXsmgPN7hS0JmP/FxZtXQ3T5D/7D3p4rtwmbDlu37cQg4nO
	bmeG/6R83ZRD8Sqowbnx/9h6icJ/nbU=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4ee1e18fb37so9826231cf.0
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 08:05:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1767715549; x=1768320349; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bxubu6bhf1aeIofDmdnq3Yy4S+a1o4zcmmWzD9LU3qU=;
        b=QFkH1ImApW7rbhwi1BDurwHcMOZ+ySpWOO9WlCKmbwvxsRsaWs1B5CFYsq+cGJJgdF
         5ivI44AyMuDwuA4T3VrhV8JGGpkzJ6oSghFKHcK/16tkjQqfqo1RdWA9U96Iq2wCTpez
         ru2KFBzOkQL7UuKnMrvlgAr1G+YhdYcQIe7Kg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767715549; x=1768320349;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bxubu6bhf1aeIofDmdnq3Yy4S+a1o4zcmmWzD9LU3qU=;
        b=B2Mrfwzu9cCpRozlwoht1gAOqu7M+jA+PG0L/sk57nHI11lNVJLvtOiuZm18cW3ggl
         ZkTDFq2xdad1bHjntaMSjeZugyCmIvm6Sba4xMnE/kj6H6oJltvxPyfRRwMX8V5lNBxv
         WEri2YeRfbpMckNeQ8AYpsiT+19EO8jiZlKsm+6vyd9T5swvtizLrwkVWjv7W+ERR7MU
         soPUp7e22nvPB47+PXgbv6reYYLCtvTzvC3ck453KW8ZUFEC0NoUEpwaT0aSJMqBgN9I
         TracxDXl+oar6wK8IqwG+J637MiYhizXOBuAeAIYKX0v4RMx+Uo2NteNc1GA4yGcgjwp
         Z7lw==
X-Forwarded-Encrypted: i=1; AJvYcCV2AsR4UbdnQIuQh7PUKLlZCTNkHwHdN5iruz4Rb8Hi3NbW5xqGwNw87MzyP2tn8meScsS5JU6byA==@kvack.org
X-Gm-Message-State: AOJu0YwFOoU14VYzDmOKtHOo2NpU3YwzypZ3cVe3gsSZq/GD8sNN/iEN
	P20muuRigZIlltlMblnsR/8gAqsMdPYqbMF/XaA3zdJGlqeSs5oNKyIl4L5p3bBcS03/Un7FnC+
	sB4t4Yfm1hiAtyaulKVT5ooqLgvGlUO+Tju46bfihGA==
X-Gm-Gg: AY/fxX6WyBlhGIQL1x3D1lBl6QmI8TrcU9BqTXukFX0z+sdD7odoYHBuakL+hgSTzJT
	LdW1gWVJaWhfYcSYfdw5ZbL77tQ9GINB0tHjynkAe6eC3xmB+eIuc7wqvO2RlIMQHP7W3DFoScU
	Kl4bmKr8oa4UHuHEVUNrMmJAiX4Kmx9Upks+129YUjjVyJFEe0FUNfM7798jSGySVLYpD83iZS3
	SUdA5YJjWi3hTWlFpCigScpnqTyo2UivMSdYlMaHqHCX6M9mTIFxCPxNzd9SZ9RRvdotw==
X-Google-Smtp-Source: AGHT+IFCiBafqUgtl2raN6GQUVNDDPPvtFF/AxT7TW768dFtVoExGBHENTdsULyggB6RdI6ZLBqSAqmAI5g+2iJa/go=
X-Received: by 2002:a05:622a:4c0b:b0:4e8:b85f:8a7a with SMTP id
 d75a77b69052e-4ffa77a5584mr38480931cf.41.1767715549416; Tue, 06 Jan 2026
 08:05:49 -0800 (PST)
MIME-Version: 1.0
References: <20251215030043.1431306-1-joannelkoong@gmail.com>
 <20251215030043.1431306-2-joannelkoong@gmail.com> <ypyumqgv5p7dnxmq34q33keb6kzqnp66r33gtbm4pglgdmhma6@3oleltql2qgp>
 <616c2e51-ff69-4ef9-9637-41f3ff8691dd@kernel.org> <CAJfpeguBuHBGUq45bOFvypsyd8XXekLKycRBGO1eeqLxz3L0eA@mail.gmail.com>
 <238ef4ab-7ea3-442a-a344-a683dd64f818@kernel.org> <CAJfpegvUP5MK-xB2=djmGo4iYzmsn9LLWV3ZJXFbyyft_LsA_Q@mail.gmail.com>
 <c39232ea-8cf0-45e6-9a5a-e2abae60134c@kernel.org>
In-Reply-To: <c39232ea-8cf0-45e6-9a5a-e2abae60134c@kernel.org>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 6 Jan 2026 17:05:38 +0100
X-Gm-Features: AQt7F2rb-cr5B2gKtHwtRDiTVmalqmfCL58if05whOX7dHeEO4sH6ByS6QMbH6g
Message-ID: <CAJfpegt0Bp5qNFPS0KsAZeU62vw4CqHv+1d53CmEOV45r-Rj0Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] fs/writeback: skip AS_NO_DATA_INTEGRITY mappings
 in wait_sb_inodes()
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, athul.krishna.kr@protonmail.com, j.neuschaefer@gmx.net, 
	carnil@debian.org, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 903B040014
X-Stat-Signature: d31zu5w31w4w1dyt81wgysa8tkwc3yip
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767715550-538966
X-HE-Meta: U2FsdGVkX19cCoKZH7ppKJeWZ8T/Gz27O/eap0Crle9PGvrAffLVOwtW16MlpGBE3/HMhaWtBHLo9oRzDhF4vqsn0M9dZihnuKL3xShoyP3Y17DWUamTz6gcK2TbdfSTM64HfWIonkhWhHfrOSNzEmhdxxYm4DfqMQ7NSpjSCgu8/EeqSS0Zvhq+c8L1gtDAAWM+qm/iMbeH7pGeTQLiZ+/HHJvhQ8QoFpmTCrBcmmjqjwec0KjcWAkboak5H1pCJkSIwpWdampSa1JtxAhGFXebe3H1wUyIHOP0XeJo1Rfd1uGRBGjMu7gKxqNfvY6EcQxow54HlTiDnZ1P9xGgq/QhAB1EepB0o5tLONr8mZ9eOMewl11SuCLFT4wK52tHWdJzycIFVkJNhdSik8vGVK+jkfHoYF/9QmWvFsXrHQe3iqmmWgHRDbltso588US+zvPtL2eigMB+k6WROr8C2ZIsJlI3utTCOcqjLqTi+7+BRIN420llsOnoPGwtRuxiP5d6Ms3L1RUKrR4uEdoGGiNBvuhROmJuo0zBoykIwrVZscK+wePXVd9nZNxDw6ZAsNSgvU1CTU1muHmCM56DtdEqyl37fwkB12W7OExdCJCwmuCnfnZ/ExLRNtBXrbhR4tLyrxIzzgu8raOKRLYRJ/csVza93ym7ZUPGVOUqtkh7dVGQQCalYFJpwe+IZiJkoD+OVCBvh/5csoH+9WbICiw1Ppp0wNwqm2kQvJ2uWJZQwksVPOHKEPxIelFFUzg6RVKkxWsMrXFdOAo/n5AeN3wCa+0JZ83aLzO/lbFAVD9KCJYj1tqGDc/cXPC3Z88MqxfS3J1uzJTZ9/PnMU0W4vTZjkxpgQWjewRFo8z+g6bVe+AOLYRO9UeW8QoDEU1bn8tTYz7gsXRv/UfQZCdqGFSjKMjKBhV9OAquJ2oN5VoJJvlvpJmVSosvfVTFFKzp4C9v0E16/K6ed/NutPy
 ssI58TI3
 13mH4MkoMnELj+f9SmPpOTvZKGDzct/WMkB884a/ncq6ClRXFygTvjY2VdCMa3Q7V2mYp9jHNypkT66KDUkiwYPQ8ItY60poFzl4lZecpO4tDDQrz7ml2verzYRgj3deGhmvid/UhsiVBUqOM3WeddYWpQJmqLN2PcN/gbPdBq5jkoFNf8DpwOeNsxvqN7Y+J0tLxpiK+HzGL4mXo7Jby3cb9xbNhG5tG3wYiS2ouUGjUwFpxED0o0usLqf8wVNLfbv/b+ec8HEeZspI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 6 Jan 2026 at 16:41, David Hildenbrand (Red Hat)
<david@kernel.org> wrote:

> I assume the usual suspects, including mm/memory-failure.c.
>
> memory_failure() not only contains a folio_wait_writeback() but also a
> folio_lock(), so twice the fun :)

As long as it's run from a workqueue it shouldn't affect the rest of
the system, right?  The wq thread will consume a nontrivial amount of
resources, I suppose, so it would be better to implement those waits
asynchronously.

Thanks,
Miklos

