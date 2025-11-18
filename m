Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B912CEE34D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 20:32:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7280D6B00A4; Tue, 18 Nov 2025 15:32:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FEE56B00A5; Tue, 18 Nov 2025 15:32:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63BCA6B00A6; Tue, 18 Nov 2025 15:32:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 522376B00A4
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 15:32:15 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CDFAC84585
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 20:32:14 +0000 (UTC)
X-FDA: 84124874988.10.0AE6F91
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf18.hostedemail.com (Postfix) with ESMTP id F2C831C000D
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 20:32:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jjRdqiSz;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763497933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sBWoQMYYG9hFsTtDFMPgr7dIw8C1zg8c5nc9F57mrj0=;
	b=ZypAGHL5zkVS63nk/KH0aY0NL2r4k/yVxypXGvVmLseuulNrSxOr0znWtnYS9MOrzua+rt
	P4xMpoSDmSRtUU8XwFUPWIdP3VF6FXH3H1zsv0830H4RQcbtSU3V2uQ/PS+NH2MH+41EuG
	kZgVG3MNoS12oIoFeNQvoiIOCwUM7cE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jjRdqiSz;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763497933; a=rsa-sha256;
	cv=none;
	b=KG0suKLLztyh+z0uAB3nPHh9PpjF62+nMZiMEXuv+4U5RHpWGzr7sCh35rVe4G9r7J4UsN
	c/xqRz0vQ1gPrecBmFCkxO6VmxG0ZSTGI5eY7HxsNvxgBJKgRtDTzz7S1pFwsQy5bHcv1g
	f/tfvuRO/3rECd1uOPUO9AvshdYpJkM=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6408f9cb1dcso9070267a12.3
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 12:32:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763497931; x=1764102731; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sBWoQMYYG9hFsTtDFMPgr7dIw8C1zg8c5nc9F57mrj0=;
        b=jjRdqiSzvokBA0fKZESoraDERmbAWyH+F6LHiviAwmPBgWKJ20OC9xHJ74jWDjXnp4
         EkP4NNoqLg/PtKhgu53HcKP5tBwUF8ivAukRFGUh7oQHdrMZ0GwbDGTy8aRTMWHKLoVM
         /3MPpgLFWRKsG7rzLgNXkAle5t0z4uhYse0AAKKj1dU+f2k08QQbsKorrEP4ygkcoypN
         +7YAMjBJi3gS9kKIkkaiZldJ884ynrV6Z+UU3fy/Yap6ESCVuMwuU33L1AcZwf4djrY+
         tpiCxLn54T8qcnaa4vu8CZbfPqCPAm77tzgqnSO9lyj16BgNS30LBovyiF+Pe8QQS4UW
         Dl0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763497931; x=1764102731;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sBWoQMYYG9hFsTtDFMPgr7dIw8C1zg8c5nc9F57mrj0=;
        b=mmxsGp2NUTTSNN4HsCqQsxnXb0ymman8zJ9v3UPYMtlcXgsYH3H+/oiJ34XKy2bJvU
         eoWHJail1BJVu/mrrw33MLgNLQLWYtKKoWYth2lg41F9p4G7Kede4DB4NM1vr0wi0PZX
         1GO58bRpY4OsuGRmy3P/Ifajfeut3CP6Lnoen+IfoJYrE5UVXQTBWS4ykEcTRhYVZShF
         UvnW5Sv1EngTFl65wuWsxUpUiKQR6d0w/9LtT3sH9L183jqmk8pNqkdJVHImHTyZ1osZ
         h8Vlm5O0NxL1PdBczgIkoZEHCMIyCgkl0hwlwtLMcUR5Rd2wkl/lgAwXdYLluk04kWom
         vgyQ==
X-Forwarded-Encrypted: i=1; AJvYcCWCd7q6bPtMBd2wMdy7YROO87wmHPuOXz6mw72Y+URllYE70llQonFiTG7Tt7cNygVElh2DCVmxig==@kvack.org
X-Gm-Message-State: AOJu0Yzxyxb57BkKCOShsAJJ9m5tuvfiTHSdqZdn3i7Ro+K87kkqdJWm
	g3Wsoqj1enWsra6u1B5X7oiuYxkU6bWjYAysZqTfWA3JusQM7putp6DWKZ4kECsQhS71nB8OwHr
	KcrMFMkMP86/qYSGqmV/pfSpJH/lfXn5QXGWQveljPw==
X-Gm-Gg: ASbGncuuXrfOht7Elt+RsC9HYPZNjbX7CT1P34BllmTXW8gSRxwV0Hk8TvCXQFBww6E
	WlHeOm6dvhtRXva59uygNNwc4MbYrZ8/1LQHgcFDyrTrgObl0p++Svd2xpjAN+tS1almb3qagew
	p9CCgF+555JiJdpPS4ALKQlPUM6l+cUOr7hKrajexjRrpXquM5VohIOtbwoUXq07k7aIkIgxeTm
	dBMPStGQMKSTIX7Kvkp0sEkdWXo98lmWIUVTILQYrBVkLC2EVjXlublRXp0RzikfklWHTRXLGgS
	wOE=
X-Google-Smtp-Source: AGHT+IHP8X5K/LKC2JInbcbobi0WNd9xLFIh2mdNfhA8rQ0GEk5lHr6mWbEU3+ejjBwErY9sX3j4PxTJ2ml3UKwmUcI=
X-Received: by 2002:a05:6402:1d48:b0:640:f8a7:aa3f with SMTP id
 4fb4d7f45d1cf-64350eaa0e8mr15815608a12.25.1763497931265; Tue, 18 Nov 2025
 12:32:11 -0800 (PST)
MIME-Version: 1.0
References: <20251118181046.23321-1-pratyush@kernel.org>
In-Reply-To: <20251118181046.23321-1-pratyush@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 18 Nov 2025 15:31:34 -0500
X-Gm-Features: AWmQ_bn8okgSW3sxizgThiqSsWpq9bQwatuGC_QPhuxTvRB32K8-7pbUIwkWJm4
Message-ID: <CA+CK2bBcgn9j_jPSxXGQgfezx=UFogs-mz0qm2GQwybkFvnpTQ@mail.gmail.com>
Subject: Re: [PATCH] test_kho: always print restore status
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Graf <graf@amazon.com>, 
	Mike Rapoport <rppt@kernel.org>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F2C831C000D
X-Stat-Signature: 6g4uuonhy7n3e89hque196qxjyn5bqb8
X-Rspam-User: 
X-HE-Tag: 1763497932-858419
X-HE-Meta: U2FsdGVkX19og2ycDX6StuuECq9XOUCFuC1dHgjA+Dvquvl4KqmPDc9qxKStRETXi4X1nfTPsExNByENcGexMcw71RnCz84wMFnyfDgNR7hxvs+m+sWSDjSQqkY9QVbjXXSZjkh7metMjbpIPGgOH9g6Yzin67ZsJCE9IiPNiU1tWDCoHYuPxGNdhRQX0TthUKHZgi7AW8aB882u9YNQ3ZMonomAbXHgHTIWdKHkS3ufQ1DnKsAff11itn93PrWymYKTt6gLu/PI6bIXuxc3d3a7YY9934a/No42aSPvkuzbT6jZe0Htl2TB/i5dDLl+BwFxzBxTWLyU5+6BsKLkWAlcSwou0tFwAnRW2UQgMRu/XlIDQNznt6XgjwVxMLxGcyMPSqoZLDnZ5PMIhzHUZppJ6Ikr20utzcqwzTUOInzx3gPsLu/rtuPUgEd86t+t/vu5Nd7lwQqz9Aa9sBG7Tzk0fBdPjmoTTyFuVlecM4eHCfd0wUieiAGj6ge1/AXbxuWtbhcPFYGYPg7aElgyhaR2y80rO62IVoQbRtIJJCdlDaYa/iBS2zs6kS3eTzp8a3tBVi5KRBdkyRyCbRttt849YXGotalI+J8XaXPhh5FJuRPzc9nVzAC5j1wkFs+nics1R4fJJ9Z9dStXB+c1M/e/sTmqKjBcVPOgdo6S8MkmcdjoV/5RNASnvIVowE64AL7ZSSapIMuJ2SG44iwXgChhLgKVX9EVXeqriiW7AIfcrGjgYiwcl22aqemlITMLvbg1pDMtdKBVYJM1HbfLCfvk7U6DycpuGs6f5zkaPpTMAuxJSQPHmpRi7lQhIrziIzdIYhQHojdU4VYFIF/cd9EQgMAFAbj29KMCC8keOVA/coc4/C8LG1aI/FPeTvHA8Whqi56c4OZ7812/E+5+M3B1bYPLl03fj4UqlMw50P/6DHGiX/yLdoLCuonS8nvwwG3SfERXe8M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 1:10=E2=80=AFPM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> Currently the KHO test only prints a message on success, and remains
> silent on failure. This makes it difficult to notice a failing test. A
> failing test is usually more interesting than a successful one.
>
> Always print the test status after attempting restore.
>
> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

