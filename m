Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C843CCF9EB
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 08:09:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9817780020; Mon, 27 Oct 2025 04:09:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 932018000A; Mon, 27 Oct 2025 04:09:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 820CC80020; Mon, 27 Oct 2025 04:09:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66A188000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 04:09:07 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 069AE13B245
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 08:09:07 +0000 (UTC)
X-FDA: 84043168734.02.2693FF0
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf14.hostedemail.com (Postfix) with ESMTP id 416F1100003
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 08:09:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BHQiDU1h;
	spf=pass (imf14.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761552545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yvxeQRhhg830l0sanhrt4dj9VmhvTVyDa0jNQUK1mG4=;
	b=ZGVB1iWlQiIjWhaFcPIPqjRhJJviAGMfIEAV+dLA/HezajMOHXMYoTtbaTC7s6vcdL50qE
	z9vIRwcoJTOjxV3LLBWas9FpcrzNT6y7qXtz8e2MsgkN6Yasf02rCt0uIb8EAXOGmMhMK/
	JtuKgk6g/i1/9mB15m+D9A/0DlJDUeI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BHQiDU1h;
	spf=pass (imf14.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761552545; a=rsa-sha256;
	cv=none;
	b=rSqbJdlwWHPOB8WHBDH8ce83UHoSdL5ZdEd2cbE35iwC+8WNXvqDTdNG83K01Y34mhV6NJ
	vuMEhPx9M1dQPx2EfbpfSgMhdUQwBGeutZ38dqcYflZbh0TMNEf332kuFbZc9+IGk8Jhpd
	7lmTKzRyn6JlbVKEsVdF7ZXMurlsoTg=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b6d53684cfdso973539566b.0
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 01:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761552543; x=1762157343; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yvxeQRhhg830l0sanhrt4dj9VmhvTVyDa0jNQUK1mG4=;
        b=BHQiDU1hn7zgL9U1SqE+VzntDyLrSJq635cdsKUW0gmuW1wVPQt5qjvXzLzlxAadJj
         G+dHOF/k9RTfkxdpJ+tmI4tYa+EmsoMbcUcdwyjONia3ZgPIvUsHYXpIfNc6KPp7BORV
         BTxZ1Rn0Rz6HSErFGZ/rdOV9dAXcC1SQoj8uLBQWfQrmESaNl7g1lf1Hg3199IEbGpis
         x+PLt7ZlwUlxAEVdfjhiR8AE2PKvm1obXXUN8hiTvyT3T9HXNxcgQx2OeIZfeoxs81/E
         yah9dPmi0PnoGaxxlkbJHWx+ncS0T60NLD9WqoWGerzlPSigPXcpqLagtTtJP97Ec8t/
         jYPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761552543; x=1762157343;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yvxeQRhhg830l0sanhrt4dj9VmhvTVyDa0jNQUK1mG4=;
        b=QJrJDXqc4clFc5/hLMvn0v43QbgxTe7lw4Pm9WVT+8RK8up9Qv4WBP4i08s4AFhS7v
         QRhLmGw+LIkrRUkr6L1s1ooG8Uo/xW0Jc7pGWdiuT/zwCbqs7Q5yai3hY20LGn3UAJ7+
         cN2U3Zf3whXiG9XvZ+mdDOB+gAADIbCpW7OVC+QEHFtXGRPL/u0g+FFxBlu9CjK5IYeh
         6GzX/DalNTejlx6gezdCTN5Sk+6j2El4H9r0r69jJXNLhiWPAxa7uAebojWAEJFAeAPL
         FA7GjJ5UZ2nKJtU1bt1qsU43cfb0BuQNhEBV87vVWy6zscwXJLlbp9+8dITGLmKITLDb
         fXIA==
X-Forwarded-Encrypted: i=1; AJvYcCVqOb91OkW52Q6spn5JKLTrzDJ5hvws0cZCqY68TuIv4Z9T7wbeJ2nNUPt3ad8LGcyNRyWEaAeNhA==@kvack.org
X-Gm-Message-State: AOJu0YzzWhE65xwHh0mKCMKG+kWX2GvXzbjw5veZrr+nkXikSP+fkyjY
	ENJ1KWetkkxPu+/DOkVgJ3eAj/MUvPXxXw0pLpIs05rTqKs2XW9nqUgp
X-Gm-Gg: ASbGncvtwJx2l5kKMXJIL7Y8kOavbLnA5eURH4MKv9a3TJGNQmrMvwNPHoL5RYQ2cNU
	2nUBN/kr5RxaTn9LuEfmSw7rg//ks+VLS76cmYOXJylxlAuxSarOi+E4hRzBSZ0XZSWIF6gfF3+
	1G9WCStB+SGmYFzFisiWA+RFCI/F8QLX5J9Hkzyj0w9dfHcDEQJBSjxoFsFnOz9cFZx5DpEpxHO
	a/oyGY+DT4q+9JL1oIp/mlaExXTbFqrwkx9Bw7ZpAaIGoF0CpExPDN/MbABeSe4LKsw2D7qMUZX
	fgAPuJXN3sQH8cmir73LMM9Ohs5dO9XkACkhygZgLV8ucPZEGN+z1env74sJNzkReKQrrBWb/61
	PnUPg9yUZhZXIiGi3bgjPeKBcBmMpeOUawfhe5M1CnWL+WsfB8ThTtCqGX51vaFIB/NrPXIR83A
	4p
X-Google-Smtp-Source: AGHT+IFijVOlnEStwgdV8OnlKBS1QW3pyY3ndH6Fj16lvbKA8iEuH12vqflityGstfLwZ0jBGpQJHQ==
X-Received: by 2002:a17:906:c43:b0:b6d:7e01:cbc5 with SMTP id a640c23a62f3a-b6d7e01debbmr639439666b.53.1761552543311;
        Mon, 27 Oct 2025 01:09:03 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b6db1c84813sm53108666b.19.2025.10.27.01.09.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 01:09:02 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: gmazyland@gmail.com
Cc: Dell.Client.Kernel@dell.com,
	brauner@kernel.org,
	dm-devel@lists.linux.dev,
	ebiggers@kernel.org,
	kix@kix.es,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-lvm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-raid@vger.kernel.org,
	lvm-devel@lists.linux.dev,
	mzxreary@0pointer.de,
	nphamcs@gmail.com,
	pavel@ucw.cz,
	rafael@kernel.org,
	ryncsn@gmail.com,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: dm bug: hibernate to swap located on dm-integrity doesn't work (how to get data redundancy for swap?)
Date: Mon, 27 Oct 2025 11:08:56 +0300
Message-ID: <20251027080856.2053794-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <a48a37e3-2c22-44fb-97a4-0e57dc20421a@gmail.com>
References: <a48a37e3-2c22-44fb-97a4-0e57dc20421a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nyhrwso1stcura73c7e7j3c5csaf7wxy
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 416F1100003
X-HE-Tag: 1761552545-855141
X-HE-Meta: U2FsdGVkX1/h7TLkXwsMk+BjtDKBDfdH9n3K2uGwgjuyVF4bNgma4MYm0DzIkmAKbqaTGxpOsuUFbV36M5GjB45C0/12MHRJaNq1GfSPpJ7xl7QetVDY1mZFUyVkU8qu9TNuCi6J08mzwLPVrJ9Od5j2eioKXokBXn+mxIBds+6dM0CCHAXF90uTHTw60uEOeDLDuWrka4xTyu9AiKCpsSGiTw9PSXY7rXw5U8jYUtWQxFf/+7gzRYWz9A2mw6nrgslF2D8Y4cPp+MRR8TL+LDgmrRn6djXyUl02q046QXvgi12cJ1QIZ7b8oWD1YWWv6UwJ6mQR8THZlQ0vrvJQkseiS54Lf9rIIi0Ym4VKUxYUGAZ4ebau3fsHqwhJdvWLY4EHPLfmP7BO4hehAcKqi/H1gYyDtUKa37GAnDX7JcCUgFZVjKxx8DUwsSD7Tp1gWZaUePpjjcIW/bRv9Yfaq4vk4yTRZh36WWIGGkKSKBH4DR34Y+ky1LElefOypcJlJvoDdfnlbw76QQdd6osBMynowNoI9kRO2DiIHkFsZjAeL/K7Y6PnCSJRO2uDb9E8ot8qyLCCxPLHjnJCk3P4JelZ5Ir1herzXQ9Y7Uas4bf7vzo5mENVXSpC8bLKP9EOE+vdmg8YQd4v7Ni8YeXqKeald1J7kcGg/rfohESiP9ZwP+UMOqMSgci1MBKi9SKHrukJ8qF45uLA+5qGpIJ8t+a0aFaX8ZcxZre7AAjXnthlHF/Ke33Jfgvsbpg0o8G0jmAipHOV44qgIIRjWXHes1TflZ1rhGuRj2xQuxygfJP/fK/tq90xCB/pa8y9Pd1OipQADrhaG/74Ev+L14luQoALUB3MCQ/IH4dv6AJK6pVwcnn+wliHZBkijc/vWDqSP1Qiuc2DN0hIzvST36KCJ/nxveovBpxY3wEHu2QB1METXMxBZctU44ht9GS1SfdOjV4lcJCmRHZZSenfVAo
 qzRO7+35
 CoCqt9LEfWg+JkI5J/OQQHMf250irqQNDNhOZyFmYs3veY5WgCxPE+043mlOqrc6Zp3Nq8iyez6De4hil9U/c6rkM5cP7RlocTPNySMLsEogsdTM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Milan Broz <gmazyland@gmail.com>:
> Hi,

That patch doesn't fix the problem. I will send more details within some
days, hopefully today.

Also, I just found that for reliable reproduction you need to do
"swapoff /dev/mapper/swap; cat /dev/mapper/swap > /dev/null" after resume
(assuming you were able to resume, of course).

So here is updated script for reproduction in Qemu:

https://zerobin.net/?0aa379bae218cf92#DDVFMvfi6S3ydCQLSrL+us1lHjXQJIZasW55JI7gEfU=

This script is very easy to use!

Try 1-2 times to reproduce.

Here is result of that script:

https://zerobin.net/?3d9447900052f9ce#ng0htJDAdSsvqVunL+BnoLHXszM6ardt9R3wkbO9L28=

This results are on 43e9ad0c55a3, which is current master, without Mikulas Patocka's
patch, but with this Mario's patch:
https://lore.kernel.org/linux-pm/20251026033115.436448-1-superm1@kernel.org/ .
Mario's patch is needed, otherwise we get WARNING when we try to hibernate.

Again: these logs are without Mikulas Patocka's patch. I will send results
of testing his patch later, hopefully today. But don't expect much. As I said,
his patch doesn't work.

"log-def-1" is output of first Qemu invocation (i. e. first boot) with
default integritysetup options. "log-def-2" is second Qemu invocation
(i. e. when we try to resume).

log-bit-{1,2} is same thing, but with "--integrity-bitmap-mode" added to
"integritysetup format" and "integritysetup open".

log-no-{1,2} is same, but with "--integrity-no-journal".

log-nodm-{1,2} is same, but without dm-integrity at all, i. e. we create
swap directly on partition.

As you can see in logs, hibernate with dm-integrity never works perfectly.
We either unable to resume, either we are able to resume, but then get
integrity errors when we do "cat /dev/mapper/swap > /dev/null".

Swap directly on partition works.

Again: you may need 1-2 attempts to reproduce using this script.

Also: the bug is reproducible even if we do "echo test_resume > /sys/power/disk".

> Are you sure you used --integrity-no-journal both in activation before
> hibernation and also in resume? If not, please try it.

I'm totally sure. (You can see script above and "set -x" output in logs.)

> You can verify it with "integritysetup status <device>" - it should say "journal: not active".

I just checked. It indeed says so.

> And if it does not work, could you try to use -integrity-recovery-mode the same
> way (both before hibernation and later in resume)? This will effectively ignore checksums

So I should pass it to both "integritysetup open" invocations, but
not to "integritysetup format" invocation. Right? Okay, I did so.

I. e. I did this:

integritysetup format --batch-mode --integrity xxhash64 /dev/sda # when formatting
integritysetup open --integrity-recovery-mode --integrity xxhash64 /dev/sda swap # before hibernate
integritysetup open --integrity-recovery-mode --integrity xxhash64 /dev/sda early-swap # when resuming

And something completely unexpected happened!
"swapon" failed immediately after "mkswap"!!! I. e. "swapon" was
unable to read swap signature right after "mkswap".
Here is log:
https://zerobin.net/?ebe34fc9ce94be45#6DWKSXvgUDKIrF4299th0ylhQNEcdqeeBfxzSJjROpA=
This seems like another dm-integrity bug.

> You can verify it with "integritysetup status <device>" - it should say "mode: read/write recovery".

Yes, it says so in logs above.

> You can also try to decrease journal commit time with --journal-commit-time option,

I just put "--journal-commit-time 1" to format and both opens. I got the same
result I get with default options: i. e. blkid returns "swap" instead of
"swsuspend", when I try to resume. Here are logs:
https://zerobin.net/?c5f8320eb89b1cfb#drrxRgnGk817oEDUA8idhn+WEQgocWjtbsAYuEHF5rI= .

> Redundancy? You mean data integrity protection? There is no redundancy, only additional authentication tag
> (detecting integrity error but not correcting it).

Yes, I meant integrity protection.

-- 
Askar Safin

