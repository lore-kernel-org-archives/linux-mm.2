Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E34E0CAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:22:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 493EA8E001A; Wed, 24 Sep 2025 11:22:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 444D58E000F; Wed, 24 Sep 2025 11:22:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 333558E001A; Wed, 24 Sep 2025 11:22:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 201A38E000F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:22:20 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C964611AFAC
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:22:18 +0000 (UTC)
X-FDA: 83924509956.15.FBDFB9A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6D4C818000D
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:22:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YBFTC4KJ;
	spf=pass (imf16.hostedemail.com: domain of gmonaco@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=gmonaco@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758727336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bg2MsKKDFmCYY/YDryOM8vGO4DqIBOZHKhqnpmhTQOE=;
	b=2lGC8rIYHQn9/N0Rw2O9Sk/nnnkHLYa5hFS4YUkzoKTF/qB3OkQKhuM6BhmD/JoSAaR96Z
	AWJedxTjdsrZxq4V3CGdPB03oqa+Sd5MBwbTnoYCwQuEhXYGoDrLn9V3WaaI5a+iT1wo97
	TDswvDYyIf1mwRy45rk/t142JmZwI3U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758727336; a=rsa-sha256;
	cv=none;
	b=qkZqgSEQOBSOuxRHns+HY7+zB71QQv5ZYcyhQYuJ1VOl9SEOzeQtRtkTUhL6m90+NZIyY0
	NUAM3BHcCulSuVrIR1eBsmSpIq9LGGP3yOG3SYfN+rrSdlpIUBWv0K6pFSNRzW9oR04PJn
	+EprpIq3ZlbF3m/gCqwpTEqgkibHkeg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YBFTC4KJ;
	spf=pass (imf16.hostedemail.com: domain of gmonaco@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=gmonaco@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758727335;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Bg2MsKKDFmCYY/YDryOM8vGO4DqIBOZHKhqnpmhTQOE=;
	b=YBFTC4KJ5D230joRZWMGVTIFe1dySJcTS2nk8Bgtkhcm7wWHSFmxfinxDoNX1garEJ/klQ
	+0Yi/DujCf+EWcwGvMPY8/YDyCe19QThpZ47I4jDWY+tj3sOckGw9ShnZ1qyOVP11cXRHA
	D9cYaRHNzPojyu1rX1b6l067e1l6W/k=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-672-i1X_p6s9Pu2nOeGXbhBWyg-1; Wed, 24 Sep 2025 11:22:14 -0400
X-MC-Unique: i1X_p6s9Pu2nOeGXbhBWyg-1
X-Mimecast-MFC-AGG-ID: i1X_p6s9Pu2nOeGXbhBWyg_1758727333
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3fba0d9eb87so1413f8f.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:22:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758727333; x=1759332133;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bg2MsKKDFmCYY/YDryOM8vGO4DqIBOZHKhqnpmhTQOE=;
        b=S9zlw1l/TY5xpz4tJ+otIWBoxaEj/UF2YpE3ly7qEgclfbttw9faFtaksXLUKSPPSo
         suk3mUOdghWaj979sK1ZfJa8BZ/4nqqiPEj6SYay4PZq51P9nt1q1iM2q2HB/mi1qr/y
         KzgfUpRAyoSHcCwAxrtegUzSdMCKMbqwGtIsq5M5qTh9rFvMJ3tqNo24iy80BsBOS4cZ
         MLkpKucG3qwFA1fCRKQovmDdBP/8IqE7GF+f7qh4UcBJgFA76mUNT73/3EFAs0doDXmB
         w88p417qX1+Ri230bNCmMqBHP4cwYH8jgY7i1seQSZ11hq1z5rroTCWijPkgb/7Lkavb
         sg2w==
X-Forwarded-Encrypted: i=1; AJvYcCWziq8BkHwH3jGXvL5PU/kb8LkdQlmqtWD/oN9XH9ncfh01GtC2Jkz89a1+3KZr2LdWRxiZ4TffEA==@kvack.org
X-Gm-Message-State: AOJu0Yyvghh/Q0287Do9coYQkGfJHL9ADtd3h0h9zckZzakZRoPVho30
	Pe/wPAlqa0IzsPGpnbBUPcQFENMbzpVK1MamKXgZ7p5lfyL0TZiidl11P1uLqyzhk7HIUya6U4A
	JnnerIhvT4H/ZSlnxR0vPm+3mkm5n46csiKTJEpXxWAgITTQU50sV
X-Gm-Gg: ASbGncvxLsXXGMd14/WxefU2v9YQZ16Fuup0MTO7FzFqSHguAUgPEOJfUrxtJfXsUkL
	QrLGRYOwZZGA5J0XPrvkNlZayHlDTyd0RlDcN7n+8BIhaYma4QILYop4I/Nn9bCItfKXqfOsjjo
	y7FkjwxZu2l7yulYqMF549yvcaJEp25FMgqxMhUyU9Epu00PZm48MIMKsC6kNqT2jPPoRaJbq2k
	XpeV9Yds+YcMOoVe0XXxS2dp5Tu6BA0eKwfmsrpAE9An0wypkG5fpWQGDnxksmUbq+lgasU839V
	cshglBCXjjBIW8HMPMDhHYP31axJmtNc1rVV6sj9CQDI188Ywsj6+JC+fD1afZp69g==
X-Received: by 2002:a05:6000:1ace:b0:3e7:6418:247b with SMTP id ffacd0b85a97d-40e458a9caemr329739f8f.10.1758727333012;
        Wed, 24 Sep 2025 08:22:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHyXMiav/N/da9iJwE0NmEHYfqO6HQalEGMq0ozUxtHZDCD4jU1uW6JDuQDhvzuX2tQxnrSMw==
X-Received: by 2002:a05:6000:1ace:b0:3e7:6418:247b with SMTP id ffacd0b85a97d-40e458a9caemr329704f8f.10.1758727332529;
        Wed, 24 Sep 2025 08:22:12 -0700 (PDT)
Received: from gmonaco-thinkpadt14gen3.rmtit.csb ([185.107.56.42])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbffaeasm28554615f8f.62.2025.09.24.08.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 08:22:12 -0700 (PDT)
Message-ID: <8e51adf20a9eafd3046c1189989f87734576bd57.camel@redhat.com>
Subject: Re: [PATCH v2 2/4] rseq: Run the mm_cid_compaction from
 rseq_handle_notify_resume()
From: Gabriele Monaco <gmonaco@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar
	 <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner
	 <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
  David Hildenbrand	 <david@redhat.com>, linux-mm@kvack.org, "Paul E.
 McKenney" <paulmck@kernel.org>
Date: Wed, 24 Sep 2025 17:22:09 +0200
In-Reply-To: <d5183516-92ea-4a76-9506-2f7e4da0b0ad@efficios.com>
References: <20250716160603.138385-6-gmonaco@redhat.com>
	 <20250716160603.138385-8-gmonaco@redhat.com>
	 <d5183516-92ea-4a76-9506-2f7e4da0b0ad@efficios.com>
Autocrypt: addr=gmonaco@redhat.com; prefer-encrypt=mutual;
 keydata=mDMEZuK5YxYJKwYBBAHaRw8BAQdAmJ3dM9Sz6/Hodu33Qrf8QH2bNeNbOikqYtxWFLVm0
 1a0JEdhYnJpZWxlIE1vbmFjbyA8Z21vbmFjb0BrZXJuZWwub3JnPoiZBBMWCgBBFiEEysoR+AuB3R
 Zwp6j270psSVh4TfIFAmjKX2MCGwMFCQWjmoAFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgk
 Q70psSVh4TfIQuAD+JulczTN6l7oJjyroySU55Fbjdvo52xiYYlMjPG7dCTsBAMFI7dSL5zg98I+8
 cXY1J7kyNsY6/dcipqBM4RMaxXsOtCRHYWJyaWVsZSBNb25hY28gPGdtb25hY29AcmVkaGF0LmNvb
 T6InAQTFgoARAIbAwUJBaOagAULCQgHAgIiAgYVCgkICwIEFgIDAQIeBwIXgBYhBMrKEfgLgd0WcK
 eo9u9KbElYeE3yBQJoymCyAhkBAAoJEO9KbElYeE3yjX4BAJ/ETNnlHn8OjZPT77xGmal9kbT1bC1
 7DfrYVISWV2Y1AP9HdAMhWNAvtCtN2S1beYjNybuK6IzWYcFfeOV+OBWRDQ==
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42)
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: P_ufZLXXOSXVcOlS2AMFW1H12X7LR4yRU48dS1dmZIE_1758727333
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9zcxoxk3e4tnwhkaryiafwcjubrgxuzk
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D4C818000D
X-Rspamd-Server: rspam10
X-HE-Tag: 1758727336-196787
X-HE-Meta: U2FsdGVkX19qKjZawXTSJg59VtcP/rTl/92JDvr55oUjVbbbkVgM6TTYfI7iIuwe3rz36dmjYknI0/aDx7NgUjibrRiuIE6qvdsCkCluRT0pdNlor46/hL4dyDifWrtjtz2UXSEB89s1V9g7ZHPzRC2GWRYulrW7ZYCpuunqPgFz1zL8mqKk0OeM9MuFFcOfRht9R9ewvGEPFrKXsI0r2PEMoXV+DF3SNZ+1SP7zfea2h4p2iXwLMwJ9M8yqs4J/pajR6WrjaQYKnupo8/rqAAvO7yraQRXC/eUZR3kwqZq7UtpXOFv4NUf9Z+g0S35dTGIeHXtee0m8HThy5yujmTIpVo3cfsGFtD1a5/bZgdjK9zEdrHmJZmjZBfTxdqjQ4YzxSkEjfHoYcho3eji7yEuv6eIN6tlllllskhH1QkTb2SkReBXTN4yrRiAxQZN2nW5rMFXHF7+rbF0MFiO+4Yva+DEKfMRgHgS4VWYqP4P8k9frcgH9gTc1qjFziOdN08Wn2OWklSYTFHV0N8f58fnXywinbe8IzOfLTX9vykD1fhMdrtDrbEYSSlb+cnlVzkJUYUFoNbsSubVWgos9HQFCE3M0sS8xVkEkMpLyGo1awdsxa/P61ag1v0VYU9BhUGXE4Xra/uG6xxrqi8jDsw00EzzVvXTCgWCDbz0KnxSMyLviWWuQwCN7gzJC/DKrnygV/SVmVh0NU/4RuiYZ9lCpYIHBVEjg0bI/tObPrrVvNGCNdREzFqLztCdZ6Bp2BKHf4QYZkalGvFqsq0nErnMyuFR6NCUwPu4bOuryUUZy55Kt3KcQKUuxpONklCV3YYic+dcTJatJd9/0Tr5Ap++b8bCjkmSzdqHGnhIePAQDWXqlLpFO7kZCFi7wsIE4ZruenzeZLUXjXxzfzLguSLTG8Yu5bL6y6vy32aEki/goYDV2RgqkKR2bEmGAsAL8/2DqFsmRKK/0eKPIape
 qMa/n/bv
 7oQgYMgYarN23hI/9gN1P90QcDo0Ia4Xj6rbQ1GbX+ry1pi4bE+0x1xsq0P+j1R0nH1IZzVPfQnPahR1zrdU7bQk+OwDtPTr5CewYngR7OPDhn42GNQmAVfPzMLWA0h0I9w4k/zC5E15MxBVPMbpQmsICqXAKS8phJiCDE9WgohKR49DxJlEaxszt+uaJHw4ukAhvJD/9tWiFZAJwuRiY/Es4MaTpqw+HMPLWf0mpukUWU9XbhqjBlLEoctJXHFiyczqHibjT0E2DOxZLQiyWv8Pb5rrbMJppo24jUeYz5rS1dE6JNlNGBgO1JUnGquhMzuAvPZzfpp4fwhn/r5zSYby05gps3l9xnkZE5BYo6KyQwZ2YeBOVcYUzCTVFYcUgHEvQ+JZ9UimcY0F6usQOXnno6+1Xbbz8+THZ6gsxjTFN2M1DZrRtkJCv/HYm+Y6ABR5DFVOEo96EnJLG7OOK6zlq2dd5dbKvDXpBc/LpLETlUELghUYPeftYMKpYG0BLLh6dLPH5xg6UIO5OjdO/l/UZAlxFVCZ6RPC0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2025-08-26 at 14:01 -0400, Mathieu Desnoyers wrote:
> Your approach looks good, but please note that this will probably
> need to be rebased on top of the rseq rework from Thomas Gleixner.
>=20
> Latest version can be found here:
>=20
> https://lore.kernel.org/lkml/20250823161326.635281786@linutronix.de/

I rebased and adapted the patches on the V4 of that series.

To get close functionality I went back to the task_work and I'm scheduling =
it
from switches (rseq_sched_switch_event).

Quick recap:
My series tries to reduce the latency caused by `task_mm_cid_work` on many-=
CPU
systems. While at it, it improves reliability for bursty tasks that can mis=
s the
tick.
It reduces the latency by splitting the work in batches. This requires more
reliability as compaction now needs more runs, which is achieved enqueuing =
on
switches instead of ticks.


While this solution works, my doubt is whether running something there is s=
till
acceptable, considering Thomas' effort is going in the opposite direction.

My tests don't show any significant performance difference, but I'd gladly =
try
different workloads.

Any thoughts on this?

If the approach still looks reasonable I can submit a proper series for rev=
iew.

You can find the series at:
    git://git.kernel.org/pub/scm/linux/kernel/git/gmonaco/linux.git mm_cid_=
batches_rebased

Thanks,
Gabriele


