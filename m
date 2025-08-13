Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39445CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 11:33:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FB8190005F; Wed, 13 Aug 2025 07:33:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D356900044; Wed, 13 Aug 2025 07:33:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70FF890005F; Wed, 13 Aug 2025 07:33:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 60510900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 07:33:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 132565871B
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 11:33:32 +0000 (UTC)
X-FDA: 83771523864.17.9513448
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf18.hostedemail.com (Postfix) with ESMTP id 30DE11C0002
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 11:33:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=impRtPL1;
	spf=pass (imf18.hostedemail.com: domain of 3CHicaAgKCLUeVXfhViWbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3CHicaAgKCLUeVXfhViWbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755084810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oc9in2Mi6mf5HpHVi2qkhAwXsYPHgkrLdyS0CqhnHrc=;
	b=VXWOFszUKreyNybKOqGJFKYljhbY0tAVOZXSMp0vYAT2C6Tala0T7eTFGcnfoXmXUqyUjP
	FDjal/mBwbFVEJGoUrRSMYfk/P/Dm5GRMJSkmgPHMFSreplg+J0H6XWOfXvnnZPFnoiMXj
	JCDKalwpjSvLUPZoLvRPr+ZUYKL08GE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755084810; a=rsa-sha256;
	cv=none;
	b=X3RFa6uywFHYYboYmr6ucOn6znobdOv/dhp09b2QvdWxVHsflac4dLtSghsPdr+/f7d4JJ
	3QyJTRSZ1j2IRfFwXohbAx94D2VXvFoIX7mE9iF9pTf4DCr6f/vHR6ixA2vyEh3cd9y3Nq
	umvMVa/QS+/vRG4gdvJOefGxKhonzBQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=impRtPL1;
	spf=pass (imf18.hostedemail.com: domain of 3CHicaAgKCLUeVXfhViWbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3CHicaAgKCLUeVXfhViWbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3b7806a620cso3623561f8f.3
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 04:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755084809; x=1755689609; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oc9in2Mi6mf5HpHVi2qkhAwXsYPHgkrLdyS0CqhnHrc=;
        b=impRtPL1tApUyGed7lUouALbc6k9/xlMCIQ4jZOTqGStS3uLr+1zwhnIvgOHqLecVP
         WDvz4m1XIn5H/2Rbl8iHxFh52wKMTUXrdJf3UkyDasVraaAwnh9Cd1U1ob/l4kfQaaYW
         YNd/tYqkHMqGArgy1At/Gn45x/TZhYIiVwUgP+sxDnkFJ0ZKLySr5Xn+BYsTrcdsn05o
         oTmrL1C6ibhukxpfA8E5jixA18k87u9bZ5xkXd1fPSb6U5mJnthdwAuNTNz/coGkepuy
         MYdD/ldipVXHu0juiRxKXpSstAed0YdlZ47voOmUK5oRW/pUzo6ySbki257ZFEWMnPL3
         vHSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755084809; x=1755689609;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oc9in2Mi6mf5HpHVi2qkhAwXsYPHgkrLdyS0CqhnHrc=;
        b=v2yH9riVhaUjcgTwJj07A9rnjy611LkEGp0uMOhoMMjNbXqcWuGUnl0Ze3MJiivoKo
         dBnX+dNlvBd7KuAc2Rju1VMkKTKyzgQnwleZHB136Fm9hHFOS1Lm/EnM/+0gVeOygYw0
         YKLTNJMZdw/FhqLpn7zLwu9YNqURuGa6ingxgIyUVuj3O3P+Tw8AxaL9RCwyVZIlmD8o
         hZZYY5K+ETXOn5T/9eJlGCVwt2CpR0Ft6d608/rPv87pixboDIC/lqUHnMZdaoy1qvm8
         2ehtj1rfnUSh+zRwhclGJ7paRH5Q/Dod2sZ7jH1zY2slIAAsh6ArApH1yiTx31yPItQe
         EzfQ==
X-Forwarded-Encrypted: i=1; AJvYcCXCVmckc0mHqvt2RgQ5MLJHfjp5wwKKER2pJa0hfJI+lypKtXVfAzv8vaZyaOBJ7FSxGgirYMFwRw==@kvack.org
X-Gm-Message-State: AOJu0YzsuR36SHgDuyFJlmAvPGqsUIjLszRlYfbdsBOC3RGGNbydaAjO
	fdJWn8W4Yh2QCGwK6IO9Eag0lJLTOkqibmL4Wz5zyUmKE5aE6pISF1ZHJdwbfE5Ubi34cl+Psfe
	qty79OcrXzbRE0w==
X-Google-Smtp-Source: AGHT+IEOU16JJnNS8DhWDwtXItrP3lqHsHHp/ybxdPD7FIOs5yLSi2Dy68rYeST/N/WH3SvPANrd5RZ3hKcQGw==
X-Received: from wmrn40.prod.google.com ([2002:a05:600c:5028:b0:459:db4a:1e14])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:4102:b0:3b9:1d32:cf2f with SMTP id ffacd0b85a97d-3b91d32dce0mr307978f8f.38.1755084808709;
 Wed, 13 Aug 2025 04:33:28 -0700 (PDT)
Date: Wed, 13 Aug 2025 11:33:27 +0000
In-Reply-To: <CALkFLLLoXfTNtigbcyD4RdJfY+b5Rh5-5Zta1QM9dBQxZd19cQ@mail.gmail.com>
Mime-Version: 1.0
References: <20250501163827.2598-1-ujwal.kundur@gmail.com> <20250702152057.4067-1-ujwal.kundur@gmail.com>
 <aGf_W_ZgIf63dmAz@x1.local> <CALkFLLJua-LeS+S5GpiXORA-3wNSR0DTzbh2bvU=Vg-Uzd2VFA@mail.gmail.com>
 <CALkFLLLoXfTNtigbcyD4RdJfY+b5Rh5-5Zta1QM9dBQxZd19cQ@mail.gmail.com>
X-Mailer: aerc 0.20.1
Message-ID: <DC19N1YGQP7J.1MH8WV5KHUHFF@google.com>
Subject: Re: [PATCH v6 1/1] selftests/mm/uffd: Refactor non-composite global
 vars into struct
From: Brendan Jackman <jackmanb@google.com>
To: Ujwal Kundur <ujwal.kundur@gmail.com>, Peter Xu <peterx@redhat.com>
Cc: <akpm@linux-foundation.org>, <shuah@kernel.org>, <linux-mm@kvack.org>, 
	<linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 30DE11C0002
X-Stat-Signature: pmix98moy764koo19rmyg6b63bthe3hw
X-Rspam-User: 
X-HE-Tag: 1755084809-373577
X-HE-Meta: U2FsdGVkX18OVcx11PBqCJEds6c2FkfLx0+wopYRF7yy+1kMF/X8vIdKKMh+jIVrfyiQjZmPoURJMnz8EjRIF0WK6yZYhZucyFO+6Ar/Augf55S3UfyMxeYvg/ITCAVoslpWwXnho5Ul0Da4wv/RJgQ6gRPH4OjCKARkdK0pqo2Az4n2I0xIR6LZRmgBtQgINR8HyZ+lJXSfEmeC6TGOvnufJvEWmPc1IjbwCSL6mkJgp3n4JuUyjpAvYN9BuTHJqN6ql/s5yICxnSeZCTsoXrpdlRO9arw9Oem/e/q6bOqpkgV0xBHpljVZevlA9n8pzLMgisvYqsE6MZvA9YRil8XOwEqaBpgBUqJYnZsLV8HR3CxD/KB+rlAQcoc2TW+WmCzzqDMaDbTB8SxwhEblUfR3dY0jLcoK4MQolZemZhnKH6STvgRcZNH2piiMG1UDwsve2VjUMaFrXkn8vJLdfX3lY3LPDnWJYLeG39cFSWOEUkH6lT6ThYavv1vJMTQdSG23csm8YBGTzi/kIby9QpY6Rg+v3ZzJluZwu0KtXBppGAJJMBK2mXVj3RxL67u1LUvbtv0aXDRJpB1SWYwHc3XdmC5u/TsIBNBvGt5XLpzzdyLvOWhvYa03XG9o0M/r6MOhQANC/H9UI1CnqDFzJBkUGQCLpadRovh4Faoca/byuDuGdNAuTwnHBFta3VRcrbbjHwYE4DyND2CEKrP/qB21qvW7oXd1QRbISHA75BccI7T5F3qsxbnlnOWbS8UxD5n9JAc8VoGXr7mgn0E1mCAPr5ihr1T8k2HbU1TrDmlAh50iaGs7Tg/Hfz4YRFYZUj+Jjl6IXBEU9+3r++fdf6kO3RsHaqIZTHQo5sRMn+ZI9b/vXPcoch3kJn4T3mJNC9nyikaKOnNGxPCkZ09VkNhr6SsyHjwBzTMqRlD9oJvFbmzkE/tBpBWJebH49r93wzxqZAoA4r5ido1zQVw
 N7IH92yt
 T1iPYkBD7ggyLX+P8x2uLWlVA43ABFIZ3jtqMZARwU/Y+xoXqMX6VdB3dMlP94HtAX78tKpF40rzPVZDuponEY+J3/uKoPCFSUp91giwpq8Lgai388dweJ3jpg21uEN9LuNIUrtbvgH+XFkcCN4uFL4WZ9wYvUbEte7K9jP2OiFJCIH4iEUZr9cWqxLq6HalbUNk6NdCEnwhjQOFJZoSCkKb1L0vv/cXVsyb/ZV4AketVFVeNaCUDpvIizeJy5IneKsM3hufkdVRtNTwFT7nq/Mcikq4a3SZgEMVf6jy/Z6kOYVVUJft2rI8zfSeT7rHG92YosiMwPUmmUyAo7KnjcWdtqt5qw/GreB0Hbc0Yo1qUmUmQ2gt4Vw5b7n2D+hKW5KXfY6J0nkFFl3LmALFF2NFaS0feoF02SBEQ3rzujXoZf+lwPm/aoCVciwTK7Hk3rpgEQ9JX8pJpwKXXxzeT2CBsNU+BCdgYz25946yL0sU2gRj4ZCi/xNSpXstYrYC3d6V6sXOg0wlMCcpz+NFrLdnLgj9kWTxbiFEJ7ZNTP4NbKF/98OyOuczrJv1K9Xee9pl97o09G5HEWCkkBeIwsH8raLQF8LdKmjzkM97QONJIzRPNMHmUF3YGT/i0L466kJIfNNrLNKOqBfMlw07G6f0CQN+9yIeQ6nnf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Aug 6, 2025 at 3:03 PM UTC, Ujwal Kundur wrote:
> Ping -- please let me know if there's anything else I must address.
> I've ensured v6 still applies on mm-new.

Hey sorry I've been on a nice long holiday but I can take a look at this
soon. Just need to get out from under my other review snowdrift first!


