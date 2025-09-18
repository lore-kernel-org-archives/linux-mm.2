Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7472CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:56:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 333DF8E0107; Thu, 18 Sep 2025 10:56:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 310CE8E00F6; Thu, 18 Sep 2025 10:56:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 248A18E0107; Thu, 18 Sep 2025 10:56:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 12DBF8E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:56:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 873061601E6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:56:26 +0000 (UTC)
X-FDA: 83902671972.13.1B0E641
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id 52D998000A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:56:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="AB/iQdCe";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758207384; a=rsa-sha256;
	cv=none;
	b=5nyF552FPRKRExjI5gXsUohfALnHRCqy9kUJ0qU2D+qUf/W57fqUzExG+BegtumNVTTJ+N
	nmceoEcrzDv1Futiu9MnxGtmESKhK6FKZBO2xDYu2Abjv5idiJgWIfqV1FILXZcV4qavXL
	HaTxlyFgCusSH1wvy2L1pGFfkD9VJWI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="AB/iQdCe";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758207384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cLEbb9OTjmJAYJqu6c3MO0OPmYmXMj1PKVs4wdeVOFI=;
	b=3zUj0MPBhqFbdd1AwhcbxrZ5+viVKWLuu35imSm/WC0JumpMMDCU4hWW+Fns75jRqvwCl3
	mdkixuJXWLeSznVogxzBDUtv003Qz9+I8sPbsdRMaVTHhVsGtDDYwoA/5stxwDIqlNFjjX
	h5Y99/BUVCQL1Tpnl/9ZE8HBtRiZYGI=
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5796051ee6aso88725e87.2
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758207382; x=1758812182; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cLEbb9OTjmJAYJqu6c3MO0OPmYmXMj1PKVs4wdeVOFI=;
        b=AB/iQdCeQx5BJdiYJmdxzrRvy1zUgMVE9PXyubT+Muy3PmreMJBQ26nu0dqL0MTclE
         L/JDXbUJIwV3tIswQKXQB5o745rNEDOxQH3rXqA+P5C2rUimzRXB02RexUbhvGTRASMl
         pRmBDaaHI/XOJqmC2PGnuMNjDlv0uhvMxaZCgABpasrmR4prA8WbsC/37++tzp07tN6w
         MkjLa04r3uq25Ue86OaJLh9KAWulY2g+ItTThZ4clqm/qpv0EEW06AA5q66hHm/hLMlU
         jhQXSu6pMtc9dyl13vyN0Qedk9MiAwBXWqy2I0Z5JK/XElTBym+RtEw+pL9JyB9ElfrZ
         me7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758207382; x=1758812182;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cLEbb9OTjmJAYJqu6c3MO0OPmYmXMj1PKVs4wdeVOFI=;
        b=CnLJElt2gWUG3ziEXT8JzD0ByOTBDr2ETDTB31FFW5sSPDsQ0TTH/Ni9GBqF70Oy1C
         4VAVKykTDR5rZlkuak2i1/u2zdzJA1ETGDK0gEw/EogYLK43w9dXSl5ny7j9+yVIXNFD
         T+O2Ih/BFqTCR8iMtbFVjQ0n2lpaPCv1XCupbjB2WKXJ0kdoryyxaw2wnpRQZe8cWFo+
         ReCpRZvmJBkkDU5DggWl5uz0M3or0shekj8cBzeXdD/olC9L+Tcvkzc3zTpQiU1XplEy
         5GJ35558ORvXraToxT9h/yenfYFE7l1q+KA8fIEGqENCA0NE1SWDqo+Y0polg0QVFqI2
         8/oQ==
X-Forwarded-Encrypted: i=1; AJvYcCXW9K74EClNuE1BTOVBaQ1zcxIHYFCMReHBiG2kgo/bsXAtEWbQAR2ofh0+MpU5zFIth7yYfCvcWw==@kvack.org
X-Gm-Message-State: AOJu0Yxt8OhIjbNplQyZPg2/la1bdkWk0nY5fQEG9Z/xt/jrdA7Y7sZF
	ciN7SeYe+9bzobTiGmwPq18z1G49K6jTUf8vUGmGvsDaM6aMeT95/MYx
X-Gm-Gg: ASbGnctPT7wTXhLbVrVQ5bioXxB1ZLWxGXDUq+hmqI9bX1n8koRpTXZZV+Eyq9EOg2y
	GuImfmmG7PsHtjbJxrE/0sQXkwJaIrfDqKhIEIeaOeQ7LIcQJ8pl+hla+Kv3AD5BggnGWY8O3PH
	CqYVcTcN/EpMRVeOOQ/3tgo1sYALMYWg/LD3GqMwIRaIas1uI7XYqXCjH3reBAIqUzHX02kXzI/
	Ty7wjMw1YxzZrNFDM0Iw847Rw9wtgdB6RP+mIpGFMF6ff7svf32ayATRG6+AIQj158GDWDMXQ6a
	5CFzkC96EQ6FGqVCAoztrIv/fqVYJlPBIBoOZrzO5jqU8OIcEB4wxm4EcgJ8ySmtsuEU/w8Thbu
	MV4BfGbwXfH8OguLhT5WtwiOhZ6pztJ12+sC/FigiTTtFwKQ=
X-Google-Smtp-Source: AGHT+IHfZ2BjCuVmOoSpDFI8qqduhH1E7JcHcsprZIxJGhRTVJCv1s/wP2yHnysogR8uwGSR2KbJIw==
X-Received: by 2002:ac2:5e7c:0:b0:578:113c:acdf with SMTP id 2adb3069b0e04-578113cb00dmr609184e87.10.1758207382331;
        Thu, 18 Sep 2025 07:56:22 -0700 (PDT)
Received: from [10.214.35.248] ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-578a994fb14sm705444e87.113.2025.09.18.07.56.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 07:56:20 -0700 (PDT)
Message-ID: <a012baae-d206-45de-a390-cddb78a5d379@gmail.com>
Date: Thu, 18 Sep 2025 16:56:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/10] mm/kasan: Support non-blocking GFP in
 kasan_populate_vmalloc()
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>, Baoquan He <bhe@redhat.com>,
 LKML <linux-kernel@vger.kernel.org>, Alexander Potapenko <glider@google.com>
References: <20250915134041.151462-1-urezki@gmail.com>
 <20250915134041.151462-8-urezki@gmail.com>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <20250915134041.151462-8-urezki@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 52D998000A
X-Stat-Signature: qyptdaapfybb37xa81yykqb3m8hzo8pb
X-Rspam-User: 
X-HE-Tag: 1758207384-541230
X-HE-Meta: U2FsdGVkX18mHIsFr5fS8kRXtLZdGRT3da/pKwmJY6yOTkfrUucpLoZnSg22QidIHk5xF31HeoNKEu5HfMgRvRXTpBpz4IIWpbaHBHuQbgfNAzWitqOKDG9aefNMivsunI5d23tEiuSKFTvpEL4kPTJyN8zNTP8tQlAy6ua6S6OANt0nIf1pdm5ON+94NlOqQweP0LJQJutW1eBuwM82gzwHktFIdwUTqivPR/MYSDbczmj5CEe9QnfvucRRdryv2nuv8FlMvO+Uu6QxoRS/ODgbZB84O4aBJ9LDvJN+/XbNkXBHM+w1AGTUhBpO+lzjMPP7sNCH1CTC5W5jNE/0snWORESwK02AtGxQ2HD8h0sDOx7+Ii2ErI8SYcOedWxKQASltMqOv+Wfdj8GxlBDotRZQRcz2f1E49zbkbVGa+0NTV+OfNXByG3ngbCCjwIuJU4WJ//m+SrRlxayelZJWfIefAKTed4jfbEsaf1oLESEbzhPwvAFb1DoNgd52qf40IyQPnMGvAVQ3lH7vcOPYhRpp4uf3jaoaYv/oMc+EUFL/Q6Y1UUY03E6Ls/YF1anNzCh5jC9p2jpebrzJg4LLPIjujCk9AgCdy4CWn7w0Ukfv9A6iI0C2bQ+tANzcVRb4TWZZ6cEOj5/YMEgLDgDU8iUXLeTwhmS434YdKw4MgdfznfCSuero5JWfkE0i506wJnVeEU0zkpB6qKWqWgwe3WY58ktOorBX2+IT2krCM8FEuAyawAvGeyqdp+SxjRpQC8uP5erD3axhNeDvp4h4YCZ3Rw3qs9gWM0URUrkWksp25FT277QTG2s09xAdG9pkDQs3ZzEqyHimvLYP6oWSrc+5tOwqguhWMLxJG6PlxdCNBUFNbNj2SUrlIFi28fQESPQEJpQ+Sbi1q/R09cqX/h9XcAwJ2x1AXS39+TnDF9UKO6hde0gl5VkatyKfKIEgOZhdus+Xhl1XP1fWR+
 utVpgsNB
 Z+Itkn0FYca5VTuf9/mk0PdvSxW6j8GeUT9Y0jgBbeJjJ++mdas0TjdKh4j3v5FVYo02KtIX6PWJ762dGiknlSjqAf8N50oHQFICJzFiIk7o1oq6I9C+Bnit+bo2zIQNGCIx64ZMJSJX6eitFM/kGBDYm+pj79UzQaoCOU2rD4fpJJtd2iGel5nNHoTiqWRn8mBaft0jcB3zzvePPZB+q10UDB85yYZr4vEUIgWx1WsTX7VLxVTjqmM7DYy0HrxpvjF8epKh126cCgkoYOp7s+xgb16IRmLyIDhEodCeUrH3G1LRN9ojz+HyMXVeQLQpsqyWTrLWyqHypZ/zK0O2bffC2+Bd0LoFqyEhD1zwGmZJQh+KgVP5qs759cWp7GPdn1En7YJRWR/1t4HwUu2v4wXuerRCE4PQHcBIqDfqZkuIZ1upgVK0TNqilvO3tD05/eC4V4AFsMmSDCWyw/kRk/wIfezt48LQwdX0sAQ/keWua7+5kj6fhQBAWr75+VB4EWImjHY80+X0Y2DZmKmfb83znQ8dmPvmXWACoISbU+1072wezsZYScSb/GA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/15/25 3:40 PM, Uladzislau Rezki (Sony) wrote:
> A "gfp_mask" is already passed to kasan_populate_vmalloc() as
> an argument to respect GFPs from callers and KASAN uses it for
> its internal allocations.
> 
> But apply_to_page_range() function ignores GFP flags due to a
> hard-coded mask.
> 
> Wrap the call with memalloc_apply_gfp_scope()/memalloc_restore_scope()
> so that non-blocking GFP flags(GFP_ATOMIC, GFP_NOWAIT) are respected.
> 
> Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> Cc: Alexander Potapenko <glider@google.com>
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---

Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>


