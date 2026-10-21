Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 161D3606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 02:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=b03RZIbc
Received: by kanga.kvack.org (Postfix)
	id 233416B0193; Tue, 20 Oct 2026 22:02:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E4AC6B0194; Tue, 20 Oct 2026 22:02:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D3936B0196; Tue, 20 Oct 2026 22:02:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB6D56B0193
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:02:13 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6264EA7F83
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:02:13 +0000 (UTC)
X-FDA: 85344983346.19.5EB8281
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf20.hostedemail.com (Postfix) with ESMTP id 857901C0004
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:02:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b03RZIbc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of hwenwur@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=hwenwur@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792548131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OGwi9n/sjudDqRr2GLNZOw5hXvKMm5llKrzOU2BnbmA=;
	b=hh4pXJY5TDF8nbphzbVlfGtwG+1IQAfdqZJKZ38EIYbrq1nqegT3qCYsr5fmGhfkKwYmmb
	tMlAcQJh1cKB5OOmR+ZLVCQFdHXNHrYJuFWgNyHduk0FP1gtEyigZFKVUX1bX0BcWLg0uf
	fLuR8quCEXZMMV5suVFs+er4K3CraQ4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b03RZIbc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of hwenwur@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=hwenwur@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792548131;
	b=2oIqy5OFwT1r7Lc/JritwwOkS/JYu9/S+k1KmbYzEjvgLohPu7TcMFpxGOTeY4njR7AZRc
	6JjGp4/9d38oZ2y0UN5iLCttnNyjhyz5hTT21M6elVOwSyon886lTbmA6KipuDYGSrBWNs
	GTdfKjT5cOWQ9T68u3R6ESwFyuQTHrQ=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cd69aa46f21so3365a12.3
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792548130; x=1793152930; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OGwi9n/sjudDqRr2GLNZOw5hXvKMm5llKrzOU2BnbmA=;
        b=b03RZIbcYUuYUApi6f2wEkurXX8mzAYEePHDHXVs29ggaGNG5Ou7L8NeS371wrwVUE
         MQgSJdU+Q5kBd4NXyTBgHi/ZTSva0nRiemJYI8B7SZuLODiZTLwDxFYR7GHRZF7cooqG
         j3k0W8L1kE4Q8wWu8jCyinLIG0ChjEILw7V11fIHrKsA41jRGCph0FlE5Tey/5UT+/dW
         mjF78jcSBJN0FgrOiJ+2Ct2Xn8lV/j1PLPqNyC+9iawXiXBRqIOIJBWFAWpeNqGL3zVT
         cCIuGtiTvWtEyHAN6FRHuVu/lgksRR/JGeRuXYJMUI4ykzuAFX1/yzvGADsv2UDjjXaW
         hy7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792548130; x=1793152930;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=OGwi9n/sjudDqRr2GLNZOw5hXvKMm5llKrzOU2BnbmA=;
        b=LeC52SWPoAJecy6bVpijUZPXjGWkyJ29Cv6SzpmFIV20mCNrgQCartIkmqUiDnPRld
         D03kcPVrm6irIVM94D7EbAvFdGaUbnFdC/dklxJcL0LXR38EzT1Jw262U0upWC7eWL+b
         UntbbY1h8gLmLfLyHoU06+Qxpp5H+8EIudrFpKp3nQhyh+DPhB8ZMucFtFQp0sw4Pu5u
         HQIujPjlRMgDcuw8rNAdFkJ/U+Lx1hlzZUjCed6XRcXnDKpLmKosWSkHfHKRfyUHv/5Y
         /74ZIfmUHwmkT9HkGt7dAUiwwMuVFnkWZKswvf1IsIHbS39/sKcHFC1dacSn1Xty+Tok
         xQzQ==
X-Forwarded-Encrypted: i=1; AKwUvBx/6x30v5pyhT+QcTky4jCMsWk7mvHq3Kfb4G1mI/w0+gUF8mZ5i+yrT8gps5ejIEhvkRt/ntDA9w==@kvack.org
X-Gm-Message-State: AFq9FYKuS0Ieps5SW9TyPHvwusQrKFl3iQ2WKapihJUVQq8T1hEKXfdv
	DX+YVvJIZCupIZm3wkmHBl0tja/n89uOppNWCuMpnOATLZwHc14ycZva
X-Gm-Gg: AYBFou0i2MVYBn5XPCuCEQM8G0OKSHNngX/t/vLiMuG+Osf0knndoZs+JQLL6UE/eVi
	PpJR/9Cw2oIQjiYDayyE6ZPKp61LJ0RMS2WVREtSoe/+URg9RRswX59UaQ4jfFoPAWwLncrQkhL
	QQfiIKfqfzsBFnNj12K96GSQb8tzlFc64FxeanjHMvmlWO8aF6JlKRrzmeqMZ+0iPPoXi7Xw7Ay
	vtgn7xKbkKbQ3CEhiUEsEN2P/ijrjfW0AEe0famAlzGGt7oykbPglKg4zN/4NrUKZqrM29FDdov
	jNrxa+oze5sBxHvEVbVQnouno82CvWkhK+iIzw+bro2K9Qbwhfg/rPdrYGmF8VjUkiPHuGfPuFS
	04AihelYC7c269z4/TLeZeqTxSR9Rd6t864hXDzaS/hF4WfSaQbxUhwaVis91BB9Yf4kRnkvaWn
	DEYZibEi06iDJgIsaGNk8KjFZwsYZexEahAvkwDCPro8E8qexTKO9P4d+CoryVfR4eRSA3ZMpzm
	ppXeAd0vt/YeXncrXJnbUf9NFTDr2DLaQAdS158d6G449GwMbw=
X-Received: by 2002:a05:6a20:7350:b0:3e1:8890:83f1 with SMTP id adf61e73a8af0-3e287c9f7b7mr925934637.1.1792548130163;
        Tue, 20 Oct 2026 19:02:10 -0700 (PDT)
Received: from gmail.com ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a0895fa6c6sm219573b3a.48.2026.10.20.19.02.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 19:02:08 -0700 (PDT)
Date: Wed, 21 Oct 2026 10:01:35 +0800
From: Wenwu Hou <hwenwur@gmail.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: zswap: set zswap_ever_enabled when enabling zswap at
 runtime
Message-ID: <atgc_4y2dA4egqXs@gmail.com>
References: <20261020122942.3477541-1-hwenwur@gmail.com>
 <CAO9r8zNgnt=9UXN_FJ3zByVtC18MNe94-tXssAS-eAQfutNXRQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO9r8zNgnt=9UXN_FJ3zByVtC18MNe94-tXssAS-eAQfutNXRQ@mail.gmail.com>
X-Rspamd-Queue-Id: 857901C0004
X-Stat-Signature: m6enxwabw73kupbd8msmhzspttsrejoe
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792548131-681093
X-HE-Meta: U2FsdGVkX1/GXS5MgnXSjOkY0Xro8p9EcCygDsQNL/S6laErXhwTI1EnycMFvQVyffI+mLkiIeCQnC6HHbDGFNMyg2bqQa+OWMU84ZzyC4ugTcpiSMzfFUGbRBYMzGwRFpwu/33VpELmDw5u6yJi7Kp4vsbmoBM+56gjabDWDt5zqmNynWdEtAsQS94tcaN2xYPlRfsvwzqKHYfVBaCDzz4ShoUlL7qQLQFxQwlS2BqDs0cLE9S7F+AuJxy3aT67GfELbD9EHVKFV2ZBxKIbJtFR4z8VW6H7xKo0iT0bjWiKbFfTI9cDwBYuWtvpi8GJ9OJmPF28RLTrMeNpZI/wT2Fz/Cvp7irW2otGj9q/XON/AMt7DBZKFgr5qrAE9eNSwvG3K+krwbs47ETROA3ePqNS1O8wwaBl5ZxZ4Cd+juUHmv4v9Q6bVsJnH1HaYpHXMWlGHigEu1scKfZJ1fBVbqdC7Qy83sNY6C1spJFYX9lNm4qpQV+pTXE4UYapJgStK5EtwIjTqt0+Qsa71gMpAlRTfT+4pstSmsfAHZy8UQzTnEOLxQPT6ge7zdRm0IC38yrJVE1+V72QIELdmQGKdGKz5zLrOrDpKg2OA04ByOd7YtTYa4CUMnqSb8Te1Y/Qn6nqwxCwgvN8e20QXvSyOLDrWdBruBdCYemK7YQJytlDsnSrmlAA2nWprdExsWwBK3cMxs3Zvn4iGbz2X9eEgUJH0PqQRDNVutYanxycPrAQzjZgmhWpZAu8SJV4vOdvzKRiRzyDW9JkRynpqGE/IfjBLhkoMYeqTqU7nYDZk/PGcEutxw2cMnQMD3Z8QV9UNdkIRdTHfdylIGuWdQe/5ShIUbBlNSIZJy17xgf0RbC8i/vE0CbFc5TyZgpOAw3U8xQ23uFmPSlNqtvexlgxvQvVQYcuzdEz1Xcgt7D5LKREXMRQUU4QS68S6Z9f0ne5jvaq4dW1unSTuY+Nc2v
 4IGNnE5m
 IBuhgLah8uwEPMcvNYtNzxb4ArNOEkGxxb+urPUb1x1OvkfoY1bo6NKiNoA/q/zulCHCrp5xmgMhzUs+H/yk/yg/S3bdMpgLkoog+ORazmeC4ATVk3A914qfA4CAqbpbHppHQ0McMgymXxezFIoXOFQceQMAFtgC8zp//ysCcalcKYjvCeLko8K+W+9n14Fq8cmprSF08V5YJkxz9F2YQdbpiMU/qricHOhV0yYj7OAkWEkiGULRmFfHmWvwgL1o66CjRIardtkITNTxmy6g4ZErcxY/YIuiw4/7bH9va6CLwhNlm43xvZtCvatJqNHhZE4uc/CTUvckqZFWRwT2olAH4oxqtTWvcvpohUuxBoVtqI/QPi7L7ApSyhrVLxLExubst4SXWSUh+QfT3QEjCuRI+s59u1EuNRK/SuFe07+jsRRPHuquh2HZr+x0MO5Vfya7Fm3wCcVrH/5wSYV5OkE2a1XOMXw/OUZ+4be2uZC0GFvMQKO2z0hd3GOcvsSzJOaE4JM4HQOCZAfUvWgHjApJUXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 08:57:15AM -0700, Yosry Ahmed wrote:
> On Tue, Oct 20, 2026 at 5:30 AM Wenwu Hou <hwenwur@gmail.com> wrote:
> >
> > zswap can end up enabled without zswap_ever_enabled being set, which
> > leads to data corruption. With CONFIG_ZSWAP_DEFAULT_ON=n:
> >
> > 1. zswap_setup() fails to create the initial pool. Setup still counts
> >    as successful, but zswap_has_pool stays false.
> > 2. The user writes a compressor name to
> >    /sys/module/zswap/parameters/compressor.
> >    zswap_compressor_param_set() creates a pool and sets
> >    zswap_has_pool = true, but never enables the zswap_ever_enabled
> >    static key.
> > 3. The user runs "echo Y > /sys/module/zswap/parameters/enabled".
> > 4. zswap_store() now stores pages in zswap, and swap_writeout() skips
> >    writing them to the swap device.
> > 5. On swap-in, zswap_load() first checks zswap_never_enabled(). It
> >    returns true, so zswap_load() reports that the page is not in zswap.
> >    The page is then read from the swap device, which holds stale data.
> >
> > Fix this by enabling zswap_ever_enabled in zswap_enabled_param_set()
> > before zswap_enabled becomes true.
> 
> Wasn't this fixed by
> https://lore.kernel.org/linux-mm/20260906133601.3563324-1-xialonglong2025@163.com/?

Yes, please drop this one, sorry for the noise.


