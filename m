Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BE15C88E77
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 17:30:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83B896B0093; Tue, 15 Sep 2026 13:30:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EC6E6B0095; Tue, 15 Sep 2026 13:30:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DC206B0096; Tue, 15 Sep 2026 13:30:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 404236B0093
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:30:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 43BAF1604A9
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:30:51 +0000 (UTC)
X-FDA: 85216686702.20.6B23F34
Received: from mail-lr2-f12.google.com (mail-lr2-f12.google.com [74.125.230.76])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4E338140011
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:30:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="VgpUxRb/";
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.230.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789493449;
	b=VpEQQN9taM56cRTaWWY3jCRGzGU3raCp7k83kC95cvL6e8kWXtYRuAEoHVnhPpj7nXF02K
	tPv+L3O3mZQwJ3CDiSDSI/hm+XnrGPCJG3eEVXz4IVIbeuYk7AOHLMzGBWfZ9cqs4fb0Z+
	Rqee8UUykAJ7khIr2LgGwDY1E0cibEk=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="VgpUxRb/";
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.230.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789493449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eAukwx8JnJI3cGyI5uMY8PGJs7GR2oj88tMoLLoGPII=;
	b=yJWC+hfHoCWzLynMDTBo4mjZ+YpQJA/S+/g6iWq1ZOKfMbVUABzie6+IOi1mCKUEo7XfHs
	9ZxW5xgpsV9Y0b/rHPS7/TJv21DDa+xETsVmeVwFXDRtW5ZGt0XNqn9dw4V9VJRa2kNEgF
	9xI5wefwmMZNBgifCh5FyWIUiakZ3DU=
Received: by mail-lr2-f12.google.com with SMTP id 38308e7fff4ca-3a2ff176d7eso738031fa.3
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:30:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789493447; cv=none;
        d=google.com; s=arc-20260327;
        b=DPkWKLr6ixlbwsSYz88LEeIpz3XtokkSUc9BC1RuiWwxQpCQLCAMQ7L4tfl7OgpTIJ
         0c7HpoNTjY+L5nbCY7nap06izY6wN8huL/r3K5bJT3vJcVLrKEW5pbYwBeug32BCy31V
         b66t3eVBatuDcf6tyEvUz93F0DZtL5n1PQPNLnJQPtl1PSObMmlsh57J+/RCLWN8mlAI
         vhat77ex369Iceveqdd4zJP6tJr0qtVBpGw2dDasTcvgEobQaeHG93SpT9ra38ASEky6
         PQBzoxfrLGmRHDnvYBUFmhp1J5Kp5CBJAH8PJC3DLczwCzg/Nwgfj8j8pboSUJqMjNSG
         O78g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eAukwx8JnJI3cGyI5uMY8PGJs7GR2oj88tMoLLoGPII=;
        fh=fHN4/sTw5qHS2bhgxTNM7ey//8yePiSqVRQ0Q61L0IM=;
        b=i1I6khVQoqT12QG7d/DRsaEmDDmLBozGlj39wGmxnIRATbfayIfiNDeJnPgAB2+p/U
         RwkzU6pYtMHW4i8f+Y8sK1XVPQ6CCMsoNOS/WPyhuriNXxeS82gKCz0R5LB2KRO1LMAn
         bKdW1SCp/Eu1q7qfdS55bGxXrhcdYfzoxfUv+83yoKLvswvF83UWsV2WQhMUx4JwRQjn
         +fdJZ9OJ/SS9KcZXWvZ/qmvXYhI89hfdYwF9vAJAtfCxJ/UEpJ3jWJ/a/qWIKxOkcIlT
         kRLTtETFzGaDicXJypW7ONCIFd+EdKoDYVP0WWyDcwCFhgwO1bE0SwVmBKjca/vPM7fX
         pn0Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789493447; x=1790098247; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eAukwx8JnJI3cGyI5uMY8PGJs7GR2oj88tMoLLoGPII=;
        b=VgpUxRb/IdsXXXLtOWBQfRsXrUNDgl5q4gNkMaONyI5NIJybPUtwWcneq+OgTztZ7N
         vrg6u3SyyotSO0CXcppcrdBzxIa3meMQrw/OqyIrmrzDaUG2Ak2a+qRRpxEZht6WhpFL
         rDahyv/QeR+XZZ2syK4gyZk99PJVKQ5Fq1k60Hn1nLyFBDcdO8DCHdII1uL1GivxjO2r
         WitrS5cre1q37rvwkLnUieI3ZoqEn1cLOlUXA6forxliWARRcjj+J3Z5F2JOD38wVk9/
         2ksGrTWVIzjM7+l4jWxdfekRPgrTl2HwAY0CdM3Ij5yiGTTWJyAu5Eq2BZf8tLC0dUXy
         1MCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789493447; x=1790098247;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eAukwx8JnJI3cGyI5uMY8PGJs7GR2oj88tMoLLoGPII=;
        b=bVwcearZ1tsNRHe6TQVO0A0huJRFF3OOfs1ls7U3hljFcCtytKnh0h3oI5/vZOboR0
         aP+m/fG5AylQBJCOhknYUhwXt6EUSbydXQe9khntmAC7oPQs9hb3V+5jaEUWZp5Fx1GY
         UITGhlNKAQqNlhaVV6fPdRMKiHy5PU0ki+7HVfC104ANsc07BbbyhNnTx5s4BXEqRpZd
         B/lD8slNlGwqd85Fqlz6p3xUPQHRyWfyJHt/4KR7K0hLhmfnIl+45N9l/lwKkJAX/w2E
         zR+YLdx64rgJWepSA+DZ0xxk96YeSA1hz1IjjSwB/WMjjpbxpfcSwpliByAuVVVAfVrK
         3QQg==
X-Forwarded-Encrypted: i=1; AKwUvBw7YRqXWyVzR55KBlWkVtwu81IJy4Q3DIIVHfOnl/A6C3PUf3WZL5GyRtLsVFF5S7uZMj7HoonkxA==@kvack.org
X-Gm-Message-State: AFuF++n7b5GHuiQQyqiSQqkkzE1+J8dwCPBKLCr649cLMD6yccjhiiVI
	eVGblc/4LRdZJgCXbYxPTYpI6qrIq06hcG3HIda9biSEJzNXsXHeVXeXfLIEmS9XE8f3QKUlhEW
	KE8ATK7p9XEIsSPZpngtNtTGSbjf5X+g=
X-Gm-Gg: AYBFou1xE31eJxeHzvTiUbmsi3QJdgxrvRYlG0WQ+9iU4n5q19jXSr7btYv90pDZB3D
	NCewx5pjfUpF2zrHw8aCz3ipc0KOdbchUXUENns1aUjoVQi9ZiqpJZxNllMuBM4/qSitkB0Bly0
	o43nF510OOr1wpD/pdlfEjVD7vUFntfcFPnzq2dppafigB5MeqNuMzpMrFMrDzQ0A1iH8omb8XG
	Zgyx0RnSIxx7P7qgRnTIsgzhwV59lHlsVrEiV7gZU2oi4wHZaxdTYx0qmcpKdJ2cloKxxXG8/1H
	m8dQOi5Mf/TpGDHIMKgOVN/k+qlanKVyJYVnIFYbfJUuSzGKrswElkzk72K8semRNPFS0J8nHfd
	D6fU0HXqO+XRbhryzQpSKgA==
X-Received: by 2002:a2e:be9a:0:b0:3a1:ab57:ea2c with SMTP id
 38308e7fff4ca-3a5c887ed99mr24859181fa.2.1789493447239; Tue, 15 Sep 2026
 10:30:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260914-test-zswap-wb-ignore-eagain-v1-1-6fb715c22cd8@kernel.org>
In-Reply-To: <20260914-test-zswap-wb-ignore-eagain-v1-1-6fb715c22cd8@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 15 Sep 2026 10:30:34 -0700
X-Gm-Features: AcwNN1XbTKjkghV6cjRHkn5yooQUMbPEmMgoyX4OeoEMM6gp36nDsHu1A29JVbc
Message-ID: <CAKEwX=N=e+x=S1qq=9fsNgd63axDjjSWgL7MF1pJFEQw71TOVw@mail.gmail.com>
Subject: Re: [PATCH] selftests/cgroup: ignore memory.reclaim -EAGAIN for zswap
 writeback test
To: "Harry Yoo (Meta)" <harry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Usama Arif <usamaarif642@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Tejun Heo <tj@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <shuah@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4E338140011
X-Rspam-User: 
X-Stat-Signature: ehzi8f3qesp1yidk6wij5nh7gtsw17hq
X-HE-Tag: 1789493449-259160
X-HE-Meta: U2FsdGVkX1+NNXQ6uODRJH5y8Dhhlb0OKiFmcYmXs8b4yyxq7Pn3+6UJR5WB729aVgl+avZ3IQo8eda0z2varc84K6dEk7mn9sonO765D2e8buzk3ldI8qKrlpyUIs9CVns8xNWrVI//mfNKTw05odI9vSuzjVwQuoAwCzGxvUT6FBOCFiAlvsFzD6UUpDUJYa8lQwHP+6AtQXnE1rWspqp0/SgpBa7hLlmQYaX9ksrcUZgbMx6EflwWD7/Fu/0GaJpqhfBdLdVwz/yoYNAPvUhSCVljJQVJ7PNTtUVJRDdggtENeBAcsVwZGRxF5cr/BsoO8pCNBq5ZoYEsppvkB0bYrzKAc8AHU7YMv2AFxckjFGNcQzGeKw5gPvJzOyD6xneSh8f+ZmKe2EN7bXSY2YFiKD2be+m6rTSajqFrJX0N/oBXUHQe/BBMD35ucl5PKc9YV9Mi+Il4VtOdZ8CskD3BB7ScLU7cbyK9t0V0KlC+ycHsiAHiF/I9YHXFd+T2+G0rctDyQgvt7T5WkxiQal2z8lj+aBLbVW+0auYIm+ZY5cAy52tZNks1zRyfSq7yD1QaYEaT5i1CtHUI2vlpRMkkrNMn8Yvj4zZSjk1A7vpMRvWDF2PqWGXDiepParlrfH1g1usLiCG8KhbuoHGeptv9NxPX+jxYxugtl9mEeejfJr5pSy95uYAxrB5dm9fKmeWyHpt5axdQwdtyD7gUIVnIMHLBgEfmNUf88Ak2qfBWjRY6GsBYYDrAvKI0b5PdDjiClgHXIQJUFBGNPXriqKTDreQmf+YK31zbU/pmU9P5LVa6wiJD/Eh/Rm1gKzg0OV06HCJPmZay7Sv4TBgu7F+YMzNpQX//FeuXEUv54IqvtkQbd0QXMvbOaHEKuVMn7oZs8TQ/Qq8bV4kaEihtoMC4UBYAFQBk8Ua1OTVja+Vw1RwdqoX/DOhv9WXO9KY2lQvPDSNf2IxHZ1JI0vR
 ZmIXNN0d
 zD4kXOk4f9/Gxk1RXQDloVwMrI3b3NurJzpfrLs/B06dYP8neUW66BfhIRtATYBJX3EK0En/qrK5YvhCeOEQ0jy134etrq6BM47NQJ6U0cZRM4+pJ4I1CO7+fterCGAOKRHqd4SB2Kqfvx8j03Avqx4hJcEF69bpP1WS6OXCj7dq483T3WHFc2Nspk31ZDSVw//+1MEvrGJ3fYemjaZtfLsn8ejUBbplNJ4IyWQRQAe7WB0EsV5If23lO74mAvWwI1dLPDaYojdEM9Tdtsj/jT/Ckq8clC3SyEzi3J4+DZdUH8EZkEGCR/E55L2XRJS4vau9TBwuiGCqiT4pnUuPnqDNuRizSJQgh3MqN09F4I9rj4F5HX9ZBPXcGMMisNKhsyaPlDv6/16K4ft2BEF4+pW1UpYYZjx1OtgbFlBydVxflmsamqU00bpjSB2dG3+VZd4dGXxAJbBeN/X8MWVyLy+sBhDqj0FLEXF6NRphOI0SA8IGL5scagHgmp95uh+oHJCzNGEVKobNjVk8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 1:36=E2=80=AFPM Harry Yoo (Meta) <harry@kernel.org>=
 wrote:
>
> The zswap_writeback_enabled test fails when a write to memory.reclaim
> returns -EAGAIN, which means less than the requested amount was
> reclaimed. attempt_writeback() propagates the -EAGAIN to the caller,
> and the test case is marked as failed even when zswap writeback did
> happen.
>
> This heavily depends on the performance of the backing swap device.
> Reclaim does not wait for writeback (on cgroup v2), does not count pages
> that are under writeback as reclaimed, and memory.reclaim gives up after
> MAX_RECLAIM_RETRIES passes without making progress. On a slow device
> where reclaim does not make any progress before writeback completes,
> a write to memory.reclaim fails.
>
> On a VM with zswap enabled, where IO delay was injected via dm-delay,
> the success rate of the zswap writeback test drops dramatically once
> the delay reaches 11 ms: 7% failures at 10 ms and 79% failures at 11 ms,
> n =3D 100.
>
> When zswap writeback is enabled, ignore -EAGAIN from memory.reclaim and
> determine pass/fail based on the zswpwb counter because that is what
> zswap_writeback_enabled actually wants to test.
>
> With this change, the test reliably passes even on a slow swap device
> (tested up to 1000 ms delay). This makes the test resilient against
> the performance of the swap device.
>
> Assisted-by: LLM
> Fixes: 158863e5d7cc ("selftests: cgroup: add tests to verify the zswap wr=
iteback path")
> Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>

Acked-by: Nhat Pham <nphamcs@gmail.com>

