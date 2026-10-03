Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B127CA5FED
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 17:05:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EBDE6B008A; Sat,  3 Oct 2026 13:05:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C3056B008C; Sat,  3 Oct 2026 13:05:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D9E36B0093; Sat,  3 Oct 2026 13:05:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 146E06B008A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 13:05:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 95CC9809A6
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:05:23 +0000 (UTC)
X-FDA: 85281940926.15.53246A7
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8199040003
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:05:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=truenas.com header.s=google header.b=gFfA07td;
	dmarc=pass (policy=quarantine) header.from=truenas.com;
	spf=pass (imf12.hostedemail.com: domain of ameer.hamza@truenas.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=ameer.hamza@truenas.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791047121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V9/myqvD+Wu7dUPpez/fB+sxDbuYQxQUAR18f1smsBQ=;
	b=AiNu3t/TrnV4y+54ZIx81E5K8h8e0GU/SMos3MltNmfAAz+xS8PDDODSuH2Z5CVxASRryA
	OFmnfC1+jwim4kh7L4sRe/VQXofRlRVf31su1z7gmvFihCEAX8puOUFKEz1+MKSgmJ6pAa
	QgzpsXC21OFhbwb9lYMXYhk8KoE1sfE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=truenas.com header.s=google header.b=gFfA07td;
	dmarc=pass (policy=quarantine) header.from=truenas.com;
	spf=pass (imf12.hostedemail.com: domain of ameer.hamza@truenas.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=ameer.hamza@truenas.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791047121;
	b=VGDjkLDURj5FtkIetch+FyUUqBKon7bqXylvrdLEHaL+biQfkGb98nR3AWCE9p0VE38IdT
	eBjDlcGWBgTEUmYEenS7Y1B5vyFEFQ4akgK7xfizjRJHOqysDVQLdmsSgOjDcQMarbz8ra
	+BKOLIrLqbgLCLM32A/gFwaZCTPXY9s=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b912d8239so6025505e9.0
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 10:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=truenas.com; s=google; t=1791047120; x=1791651920; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=V9/myqvD+Wu7dUPpez/fB+sxDbuYQxQUAR18f1smsBQ=;
        b=gFfA07tduZ57iDj8o+1N8mVpvSCZCDHI2EcI8EvAzvKssGmbXbCbgclIMnKnWAC2LK
         zhzDTrMc5YCzejJHRKYHiW2SdYtFpGZNZ4aOD/sY/WshA3JJfl4KUliRjfzYx3wAYuuK
         0Kvt3jB53GgZYmGbWh7zWkcVDHxBBALvEb24gShn90iiAYslG3ua4NbS4evgpEHYBC3O
         9nakVg/rEo1sB7js6jQ95HFZ5HcWGaMkdf37LyQyB4YXLTVEbEXxT1Z2/vlkDTANgPY4
         bngfVlrWjec2fIIP/1rwoX2QBLR1XKHSlGazV0vfi0/H/jASer0+3i451+2vGwhXFQlZ
         L/fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791047120; x=1791651920;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V9/myqvD+Wu7dUPpez/fB+sxDbuYQxQUAR18f1smsBQ=;
        b=TryCMdf3YkcpxuPsONdyOEn29V8mXlIu0Fz1HyqalXd78uIQWQZo+czaeZUKUL50fs
         7Ti9+DhQMU1giVU1ZOUDDDidjW94ddplynwfRrPdF+i7SFrC0BNGiZigdyx41IPNDEpy
         koV5Tuu2DT/C2dsfCBdYYh1qdUmwEZdTOdi0+jLdtwzqffQ57O5RvpSwuAOklwDJmogo
         mcpB9iedBUuXm7kwbkfOIj/8B3jAePI+HdcMEiofYHyHV4er7b3f3qnAVWUzRJJaqF6y
         F6tEsmecybdYMeYTLTe0m5/WgIHMo862F0f00+M7EPIXYSWO/tXQTQyO1IkaU1PaVV1v
         OQeg==
X-Forwarded-Encrypted: i=1; AKwUvByJN/R3NGL7y10XCrlWP0CERrE3NzQRD7Fx7axsvO8ue73PHd8nnBea+Mh1IHiHTMNZ5wNLBAGlmg==@kvack.org
X-Gm-Message-State: AFuF++lXDgDdIdGeMzxwyL//cISlgAIovb+lN1ste5SVQLZORIKHT1m7
	gIFzOSiAlUXHJLr6/mwqL69XX3JwlLoL7+nbEiuQ/DIDtG+B+SeQrmO0Tk/aksCqb85t0X0MUpU
	t8DQBpUgz
X-Gm-Gg: AYBFou3wLaAPqBjR1R74fpkz5+sINAn1nQbfBAFTmkqWxJUb04PC9MtQ5V/jFdoDEHc
	W/4i5/YROr0u3DviGbIMQLo9+gBLy8QAlfeB3eIHFMAnzg9vjLmetLQ0kuQzE/FczqPlDTXtUvT
	WKpEWJJ5ao05IMLPWvSkqck7KIbdaM/UDNE8HiewYrXp/FxsmxG6UlgL5V4GupnBV0qFuDQT+2R
	nDIqmDQnqUqe62iOmlEOVPeTHmPMTGyuvJhT2u532mRBfkLZs0sjMTy/PsZ+uQCQJIBO97ySXV8
	4RcUZjFVX34AlxpH6wvzxC5Vn421O9kSVuMOY+iIYIiYUilHEnNDWTRI555HYMWW1PWBRPExrVt
	g6AB8SSNZLxpR1ldoHJAiT9JjzhBVp9Y2Q167URPA3GWNTmM8ulsLJz4KKd/Ch7Zz1NQO4Hovsw
	j+VV4Sl6CTO27NcypZabu/o3mnYJ57PNjRUDrWFPhWsZOvb9wlzA==
X-Received: by 2002:a05:600c:c16f:b0:49f:ed8c:6cad with SMTP id 5b1f17b1804b1-4a027594557mr93542555e9.19.1791047119916;
        Sat, 03 Oct 2026 10:05:19 -0700 (PDT)
Received: from hamza-PC ([2400:adc1:158:c700::2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a0e1afbc44sm177013365e9.4.2026.10.03.10.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 10:05:19 -0700 (PDT)
Date: Sat, 3 Oct 2026 22:05:11 +0500
From: Ameer Hamza <ameer.hamza@truenas.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: ljs@kernel.org, rppt@kernel.org, peterz@infradead.org, 
	akpm@linux-foundation.org, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, 
	linux-mm@kvack.org, linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	regressions@lists.linux.dev, stable@vger.kernel.org, 4ncienth@gmail.com, sashal@kernel.org, 
	alexander.motin@truenas.com, caleb.stjohn@truenas.com
Subject: Re: [REGRESSION] secretmem: SIGBUS on memfd_secret() pages while
 perf record runs
Message-ID: <asE0ctESLO306qYs@hamza-PC>
References: <20261002175651.811343-1-ameer.hamza@truenas.com>
 <3c5b9d1e-5ed4-4bd1-b532-39f2d4612965@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c5b9d1e-5ed4-4bd1-b532-39f2d4612965@kernel.org>
X-Stat-Signature: 86hbk97kabkymy6ko54d4au19yw1yxzh
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8199040003
X-HE-Tag: 1791047121-614476
X-HE-Meta: U2FsdGVkX1+u1g+Phm+8543fyJ2Wv5upyjiZgv74BDi6s1EaboservHr6KNy4Kwx5YK1kTpKlj3kmisrfAkRgX00uUitiRh4H6aT50mo0CRaZCMdkYOsGgicA1uF6MqZyHUwrQFLdxolo5XD0iNIYPIwLT2yZc1ABKXfKbOZ7f7rSqM4fhGmIUV2NkiweldV/Zeze6K4L8RBXGmTU9naLEp0A/gQVgdOyVGhnSXLwxFWS6eZKv8C+Rh4/lkSb1Mk+5k4vOLxHcHPrPnVzjwqn9jBkW1Pj23SGiNuSAKufVvyMYYVsX0PSMjB4zGH8T+9DZMmZBGDQH1sVzmjIWdbXFxt+dAUNuDt1lxZ8kEYJdYoWyI0PVQXM80b/4xRT6JQ83XcNsuejlC3gq0DhEcLKNcxHXqsMRaP83lA5ODxM9qar6l6K+YYHps1Del0s8lQ1MGHD+Ha9PkETSZH/JFVRbqvFlcHpJ6DmYJo5tUesLSyLoKdQQQ7VH0EjVeA2ADaqvRGnMHq5Bb2Kq9f5sp9eYCByPuP0Z+f43vVH74QbMBs71hL+dYELplaLoYBamazmZZaPRq+ZWG89rWB5rk0szrwK96ouGZ9BIMc+bhA6j7TdKFGts2Kb8rKy4KywM3PvRnUKe+lq6QhCvb1J+ePD2NqYTr5kojExuw9xJKEFn0j/zpkGi/ptUx4BUuEZA2Ed1fEI3pxEMSelQ+FtwiPVik8mCJbdpO4YmcIgwVAJhRRsqrlorYXTV/qbNBYpBbmyuKXIBMJ98iO9UjfGRNF9QDldMGU91+t2qXAKdPoX6l96zWC4sLPvJ9Ppy/crW1FPOl2au9ilTLFJ9ZEpSbP2d5/jkBYfFdIZsjykq77uyG5QxNmXUFK2rFt29FuB7LC5Ya8RC67Genk42pZ8PyAelTyqiWWwbihhAGic5HzBo/LuoVJTSpNmYyXGaoF/UbKanwtatLdrUf91eMKDx+
 cu5jKAGe
 wgPuslQUMzN05w3+/JXdBRukhNbgLWSoiW2GglwdOxmofgadfjipWb3whlAwTRFD7O4otg2b6JeGqrKJB0EXRb6/6ZqrKLUVE9nmtoVxe9AaRVuR8xr5CL7fmNS2UX0BFGLsDdelIkRw9jOBJ0ZJOFLo4cS8e055slc6jfgFaJZBJH45tqvvmb98Xy88K/ng5VMlWoF9iQh6jSTcjbHZCjumpyeaF+Z2hDTp0rJ4P6A6iJWtDa4ltZIzcIuYZ1Htyw9ZwGa+p74W9cY+mvR6o1Rv7sSIK9DEWa4WmT//YFu6pgqwWsDQCJ5Nkf7d+gaqEVK+zpRrcsMElj1AN0PeZwJ0p+3KqPUmNfy3zMrG3CUVhga8C8ROgbptbusIS1nzwNXvk66xgp+8yhHTMWDKqmfjudnI8fidylVO+neRTIKoDBXvq2QTUnz5/5QFnskzIIh03
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 03, 2026 at 04:14:49PM +0200, David Hildenbrand (Arm) wrote:
> May I know whether this problem was found by
> 
> (a) A real workload
> 
> (b) A test case
> 
> (c) Complains by some tooling

(a). A root userspace process that keeps secrets in memfd_secret()
failed while perf record ran on the same machine. I reduced it to the
snippet in the report.

Thanks,
Ameer Hamza

