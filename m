Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28FCFD2168E
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 15:33:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A8C16B00C6; Thu,  4 Dec 2025 10:33:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 859E26B00C7; Thu,  4 Dec 2025 10:33:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7700A6B00CA; Thu,  4 Dec 2025 10:33:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 62EDA6B00C6
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:33:03 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 278AC131F88
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:33:03 +0000 (UTC)
X-FDA: 84182181846.12.BE8816E
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf05.hostedemail.com (Postfix) with ESMTP id 57AB8100002
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:33:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KXULYHta;
	spf=pass (imf05.hostedemail.com: domain of elver@google.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764862381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ynmi+F4tSnwM3VjJVfL6w3FFtVt6Ah2F/7BtxBtZ4r4=;
	b=0C879Mw6Kd7TscwDNgVIJgVObHro+4GSriExZtR1r58KYYeT+iGd199qdCf6y0KBn4njOr
	64rPSnRHY6zOZjQ8iDh7ywW/h4VTpnz8c78zrEUM8WosDc1BtSIypIY9ZqEPI4JW7bhmS5
	ZxhSDDme9PI5wapwMOszpSh3VQnLCwc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764862381; a=rsa-sha256;
	cv=none;
	b=AjnzZvKB+vgesJmxX/XWHr+7b3eYThmdZUzc3jdSCVBCiq2lQichpiPkFmbF04jl187bkw
	8CBZy8LzKLchAy8l1nTeWrYDIMLYylyBJT4IWuSBfGJIOXNHbVNmo3a5Tdt3VhuzuukGsM
	eTKMGxc2NpInYRdr/i84v50w3C+3qEw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KXULYHta;
	spf=pass (imf05.hostedemail.com: domain of elver@google.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7bc248dc16aso806685b3a.0
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 07:33:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764862380; x=1765467180; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ynmi+F4tSnwM3VjJVfL6w3FFtVt6Ah2F/7BtxBtZ4r4=;
        b=KXULYHtaYCUmBuTmLoeYkf6s0j+k53y7pBAFP+yO+ZHBsWwdCBVBOEQl5mB9R3RrS5
         zdgiESqh/oXZhtk2/ACo7tc9kwJjutROzOTEAeUVfEIc114JGeCZZgTZg5FnxoUWGCUr
         fOCrbHj890YqH5vKCQ6b8I2ncbSTCkeoGJm4FOMHAVcwWYjlokO8qhPXPUrD14XHBcW4
         PNxORTrftv+sveW769GzCDbIe2MF5+Jh2lkQ8hWktj7jnaMCzQhxz+r94fjrustkiQpd
         7yGXkHWuARB+JphUyYTvUzWVRgFSGjW3Q2xss+QSblOYO3Q1Q+eq5SfQQqO/vbNcafWw
         d70Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764862380; x=1765467180;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ynmi+F4tSnwM3VjJVfL6w3FFtVt6Ah2F/7BtxBtZ4r4=;
        b=nSA7ZWmoi9F1JxrJxJ4c0SkutUL7UI0XVtHE6LP/o4+dB8qPjdVfKmTSWvmg1zJUO7
         r08r/6udvlommBcY/AJ+aGDSe63oIxxm4PycLkB0n8Rju+gwtTauviJ6a5xzvt6wfHHN
         GKTZvuJ8onr09FuJ0qYAA2leFkBT9DT8deJED74WjUmHeEYYv4tnjE6MBjWC9B1ryaxo
         dpwdLwnrv8jDLqgch4/blYhy6qB3V7svTQ9jMfyjb4q0ymN/xjsA+6gEJMq7s5QHftF8
         aNz8+tFVg/wHDyAUXwoVQiVzvZD7ZsClg7uyHL2rkygDda/VI+xz3lrKKOSdDoiVrQRs
         Ti5g==
X-Forwarded-Encrypted: i=1; AJvYcCWt89al7zwWKqEJTA20Gx1HX5SLIW1L9kJGKjUCmRsIkCyqxb3uU37wb2PUziaJHjsyKXMQXFNncg==@kvack.org
X-Gm-Message-State: AOJu0YwGR8JDLK6nDZpwyAL9p2vBr4/yBwcJ2Z8llYZL3ilORlUz5O6U
	/78KnJXgGBXAWSM31/3OaWB8jr1vKrwZyXpuRAM5alOW9Rg3ILmyPCsPQmBISxWD0xiUOF96M4E
	VFusEDc2gbsM6XoUjED2E3f5kdp5/Cw0Or8D0CH+a
X-Gm-Gg: ASbGncsgKlTZ6TL3yXoZuhhre5cb7tSHPdFQ7Bjs5LCjfadH4pKjrQV85uHGMEevvQO
	CSMwp4IredxWuPo1+rb8WibL8GCskN8KSwyqQpWo3XUmQ7WBKCsTtklmI0A1nQwdNDh1Zgm1Woh
	CDNjlo+wzo46MmVUSSmTAhnN4QcG/ZdQD+4XcEVxtLYeu1FP+MzywmStOHqRIaBoUibBf2hImg4
	VxEzvYMqNrt6AxIdfcwR1J1HEon91jKN4yQ0WuU2xoHRN94f75Svc3hfzd0yfgOsGMNKiCqmiK7
	1/CN0uMMH+8A7QPLMJg2881jprnqez2xww/O
X-Google-Smtp-Source: AGHT+IFSJu1kx2gV/3kzOFNWf16TP3D39qXN+kNBoxGpDPrlsv10XRPk9OEjnEDlT2YnChI/oMVZm/G/JgVX43H7mrU=
X-Received: by 2002:a05:7022:3808:b0:11d:f037:891c with SMTP id
 a92af1059eb24-11df64b94b7mr1985453c88.44.1764862379392; Thu, 04 Dec 2025
 07:32:59 -0800 (PST)
MIME-Version: 1.0
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
 <20251204141250.21114-10-ethan.w.s.graham@gmail.com> <CAHp75VfSkDvWVqi+W2iLJZhfe9+ZqSvTEN7Lh-JQbyKjPO6p_A@mail.gmail.com>
In-Reply-To: <CAHp75VfSkDvWVqi+W2iLJZhfe9+ZqSvTEN7Lh-JQbyKjPO6p_A@mail.gmail.com>
From: Marco Elver <elver@google.com>
Date: Thu, 4 Dec 2025 16:32:22 +0100
X-Gm-Features: AWmQ_bkpU_UzkQY7REuOUbS7OqCEAS3jlYqZDjlCZ9VHlEzHr8ON3cmhrcpo9_c
Message-ID: <CANpmjNMQDs8egBfCMH_Nx7gdfxP+N40Lf6eD=-25afeTcbRS+Q@mail.gmail.com>
Subject: Re: [PATCH 09/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Ethan Graham <ethan.w.s.graham@gmail.com>, glider@google.com, andreyknvl@gmail.com, 
	andy@kernel.org, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com, 
	dvyukov@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, rmoar@google.com, shuah@kernel.org, 
	sj@kernel.org, tarasmadan@google.com, Ethan Graham <ethangraham@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 57AB8100002
X-Stat-Signature: 8uk569pf3sedoejfwu6xiz8apuxfsahb
X-HE-Tag: 1764862381-412859
X-HE-Meta: U2FsdGVkX1+Zf7xloNS8r1QgTKaDKX4abZw53ugNja3VPxtAcrgIajLPANKxnlAG61JSUeJ2Db0gZ4st23fJCZfafpjclrmijKXfif9I+fvyJrEmFkrjCzfnZrGyD8B9USJKY0AlLW2q0G/lnA1SfMfE6SuEHWPwSkesAYD2L8MUFXUqrUirjz+zH8pHPcJHC8jW5Dq88uOuvMYrT6/KNCH4uOuoAZ7zjwvD9/Xu0UkCKamhD6T6eVIU0qxLTKLM2GeaVzueLlkZ0+4K3qNiuTlgIXq7NGfEIHBN73A/DUeJ7LTvZLm4xJDraAG6Fs1SAgobQ0tAXD+FGtqdXsHQd7MUUmiZInaI1Ofgy+H14nISE0jkXOUZXSaAGE+uVhiT+Xqnga58lhkJaZrQVvhbkYhf0L3HhcRqs4tm7/jU373bVa7MpQO7lNHx5vy/mUzjjBW9u1zkzh2PNiincXf0XC1ikrLtynEk0AgQ6aVE+DPKSI/gZ0Ym9RJ6gNokcAf10p5eFzTUdTUFz4yHiDy4izl40kbUW6/fzYvUuTiqk+tpMK+RRUTpYR7c893vykpW9ZzfAYH2O4yyeGHQJN/bHoXZ7Jk+fxpbXaJcgfQbpEcL041+1kMCcKTX70Z+cLXJ7UfSMeDP7U25oGWitS+8UmpBSChdlObdU6h760AFQBqSh0DwgRuC84jRcHWRP2vQTJXnyHWvVr80MaO4c0z3ebvQAmJVlBo1ksOtlrm7LHPeQuwXeADudebxqhru88zEdVybdfgJWnhdPPzBenSdt10UaCq+y0ojvJ9Rg849pMJnt3lyKpQ2+AvJItqbIXkHThm+9vB7+ptJmOzCPUI/iH9yDy01TesOjfsLUDY8O8PjrKzraymWXJzFwih+E/22MSRlGmHYXKHt3wyh/at+XPiRAcgFr92KvnBqD1MQDFQvb2TAR3TCJvYXsrFfRoaVuwOoFezpLrej6HfMLjR
 00VwZEar
 uU0HXnEhNkN2AOH5ReRnhPR9E8dlALtGivbHuA++bEMSkSMjEAkd6jIgwWsHs8QWNM0PDGh0/QAZzrTjs4eq0vEDnfMq3ldoM2jqIk/Zz4D87rVgONSQ0nk/7uDnx8TzsR0fgJs9DDhSbw9z0cTs8amRN/3F6cnm9M8Q0mEmgSgxwpujvjmVhuB574B89QjZptbfYS78jwMyeEalpmA+/Kh4zQVg7qYNKkUTWPoA+rmes5Usb5ya7YtToD2fNQKtOfelHbE18BWXepWp+nHgkVSBb1GP9UuK2cDScqLkf5bDjsS4gp7mmYWCnGxtxGQL9edL2eMuY+SQ4s+da0hEle2hXD+7Puxa7XKAElWuCxIu3JMt+9eX9phxFuogI68+TfXWHRAcTg9+ROPLzIr9xhorpvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 4 Dec 2025 at 16:26, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
[..]
> > Signed-off-by: Ethan Graham <ethangraham@google.com>
> > Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
>
> I believe one of two SoBs is enough.

Per my interpretation of
https://docs.kernel.org/process/submitting-patches.html#developer-s-certificate-of-origin-1-1
it's required where the affiliation/identity of the author has
changed; it's as if another developer picked up the series and
continues improving it.

