Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1BDBC61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 07:44:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E9D56B0088; Sun, 30 Aug 2026 03:44:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C1FF6B008A; Sun, 30 Aug 2026 03:44:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D7856B008C; Sun, 30 Aug 2026 03:44:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 446656B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:44:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 58C8B16024C
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:44:25 +0000 (UTC)
X-FDA: 85157148090.06.4CA9778
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9226B1C0003
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:44:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XCjjQJtI;
	spf=pass (imf21.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788075863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1463Nua5rsy1ZKhdUuK5314KEKn538+dBkzqnDChMps=;
	b=fIQYwRBkDLiKoxMCcZ/cQ/Ga46neOqTI9qYmjOp46XaKPBzOKKJ0YVE32qpGP6elW+ePwz
	ja659u2wjec5qvIH3FKm45l5vY6lmtZEkZ10GXrxHoFKhrJeIPPOFM+4HP5C2ek0jbEyRR
	meYayNCSXKZJeb+q4uStEyY33h5oJfU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788075863;
	b=QUnNr14BDcCq6P5gB702mFJv7AfPvGhKi7IJvbCaPs6zzTtYG4uok1NkNfhrehRM0zlPx2
	dvPQNTsAzyyUHDXRWlOoqRlINlIWzXNZWJxqi8hy8psfISjoLc2kjEO/QOuBoxaIU4+v30
	EV1uQ2vow/3F6PkWoqYPCzChQGmDB1k=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XCjjQJtI;
	spf=pass (imf21.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3969e82ff8fso2597091a91.0
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788075862; x=1788680662; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1463Nua5rsy1ZKhdUuK5314KEKn538+dBkzqnDChMps=;
        b=XCjjQJtIrZbhXj+IqeZdToVWZDmP+PJAGdbd573J1+ahafnIG1gCdu8QNNpwDOrvj/
         ivQfxNOLexOKLUqcsv/E5gEachImVIJYW+e0mvxr2LPcUwiTBYDAX5Dolp0SMwF4c35f
         +I7aSB13NjMAlV6+a/fqO0xAUb4y2JQS4H5WkHfcRKCTlx3pfg2XUWAM1d8TcJ0739Nz
         0K0ZiMwRHR+Hi2U5nsXvSm7CZhSPhwx9WKQ+umoCcPUy7JorG4XS2ki7jx4/xZlFO8lQ
         eddABOLo2G4X0QpAgxgifCCq2ehs//+sW11iBo950lFDzNMgTpA1R0uFxUGCeCOBIjQ1
         hHdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788075862; x=1788680662;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1463Nua5rsy1ZKhdUuK5314KEKn538+dBkzqnDChMps=;
        b=g4aj9mTtuuDNJzPoW6k8svqsdX1VLKezsdBTBbKSFSfvk9U5FiONUtmq4rOPc37zH2
         yPMyGfwAoitgLBPgqMLLaH/IAXr78mGFJK2In2sXNrUUAGavuGWAbBz3dfMyRZSR7B25
         e/tuXi1ZwjxmSFmWNhr5U/anOI1NkLFMISMMFWzNXTbIszCjfsvepjsM5GyEgUwnbmTp
         zIjItYV0NIaq+i7Q6wJA9v7uMBHeb5+ZuP0/9zJiy6MFyZlJtmmC1JrCNC5qfry8H+8I
         QSOujI4e5M8Va8yaPqeKJDc4f8UbnpCnHNe2C2lOA2uk/Pd2hItHMxA/qZIcPa1JzwqM
         aNBA==
X-Forwarded-Encrypted: i=1; AKwUvBzLo9qytbKuDiVsJSU1Drc5BdPD4rRro1WAD1XPYn71CvelGbj6sSmrhYPb89d9upvMGSD75ZLtfw==@kvack.org
X-Gm-Message-State: AFuF++lCHMbd8UShvaTW3+5PPOiP9DIjnwIuMnEZRGOIu9vcWO5V/oMN
	BVkyO29g3eaLKh4/zk67KqA8YbQNtjURZpsxL9Rrz7LzG9RGqvu9jkXP
X-Gm-Gg: AYBFou3G2qYuw8TnudSv+75Zq4G7PDBqCkakw7KYXjdfQO1JddYICvO8D1ARR1lV2Jd
	jwqcH1zuKkO8L9iHQg67VKGpI3oUh+29rUt5x6MiCG/O06qF4PaK15F/V3zOXRGwpXsOCEzX1Ub
	OlR+B3gHpqENu4LAHogdOzAf8tXL73qM0c8yL7FHnAIJPp89704AVADUOlKNsgT5SOZd18fZLd6
	Gr+VFu/hPzUSp7bF/1jhUfwdTNCG+V+TYxu/lZyuEeVOQ8VEQfmJZ+estwjEVt6gwUGN7CqERsF
	SMbzJ894srq11bw7f3KDd1yLyahg4DZqYIDjKdPWoZXXn7J9lzljEzm2O7iRjrUcRqXu5jikwps
	4Yt6AWkwcQw69ndB4DeoNYexW6eFpL7IylufQHB+vfmsleYm2My25URcNm3E6F40OxEvSHLaE4g
	OpOTmlPI2zA7YAWrAdZK6kO+R/DP2CyKiIbqi4EKDZQNiqfA+9VLwJpIx53DgencEbVa/cPtyK5
	vTPgaKsHyOQl+pvx9TIPgAfffWt6gr1BNIgArc=
X-Received: by 2002:a17:90b:2243:b0:398:9bd5:490d with SMTP id 98e67ed59e1d1-3989bd54c26mr10681172a91.20.1788075862358;
        Sun, 30 Aug 2026 00:44:22 -0700 (PDT)
Received: from localhost.localdomain (vmi2317720.contaboserver.net. [84.247.152.65])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-398bd356f80sm4527719a91.9.2026.08.30.00.44.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 30 Aug 2026 00:44:22 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org,
	lianux.mm@gmail.com,
	axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: Re: [PATCH v2 5/7] mm/mglru: make LRU folio prefetch helper an inline function
Date: Sun, 30 Aug 2026 15:43:56 +0800
Message-ID: <20260830074405.79857-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260827234704.63163-6-baohua@kernel.org>
References: <20260827234704.63163-1-baohua@kernel.org> <20260827234704.63163-6-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9226B1C0003
X-Stat-Signature: 1sop4wtoj6gaatipwic78gbnngw5ynth
X-HE-Tag: 1788075863-517582
X-HE-Meta: U2FsdGVkX1/uFM7gXTPnxGcWiPVBbzBTy9JiNf1D+SeI/VFoxikNzYc+o6Cc6xwQO5l3LCh3NnaEHuiSq+Yhgpbvdk+R7CeKknjJM2yP32Ihzu94zh4mZfpJndQis0SoNa1o88CvNwZmekEeOhBiYqkAM42KsRQC3fPTQNi4+AptrBTJ0EA1l6js43VBS3XLONYxtWUB76kEKgn5x6Tyr1RuMo6FI4OHnKK/fKyVsWbF1tccgJwUy2/nLK5Jzq1m+zBj9YhbhgkumPaificuoqvec9N/USEnmhNzM1NIGbNiK6081UkzObGAe+GQTj2x4TvAJ4lpWf1og5ztDiZNT6O+6fHTdzf0kyWZDY4SdTMkrVaMMKxCYzb8oZIjGCDia/X8Ee67RA+HL5yJVdDaTAXzOEtuYyle4CwUvE8hStRQDQzGiHiOhTos3eD/Od3j9Bk0ZsWWdK7KTr1QPrk9ysNdh+LpWeN5U7fCstZXqwJU9cL5v/V3209yz48htTDwmscPra8+xZiHYLBNPVQRcTYTxBIZCmLJC+v7Nd2qOB4WfTm+Xvv3eV3nzkctcsMz+E+w39AirWHAT9Lf0A/YmVCEu4nAafnaKPXobPOFF9ZsuFkQFO3LE7Xmfb3UcTYD+zNcYF7YErFkYyCatQldB9Tg6iLvfqEdafdcm+iDD2qdydtI1fG/4z/AlBWM64Wr2QFanl4OsIu7i04R5bE8RvliTjqYB2gTbhkdDj5684TwH3vGdB9atyd+ADdvMueJfCVeAgYf2sFthuFBg+ONFJ/Sy8ShG3+YjP2E5mBZm1X5X8oUEcC8cIkobWK3OTWxtFYazyuUAQMfWZR1BmVJXDuph23teBHiqvDhSmNBvuTEDUcLEtkSJURrw7Jtv1797QYgaa+Be5fRqguEz06ySLRihYQncwuI9kCG6oKdGYV/fC4cBENJozm9HQlMvcLXDkRtmh5H7NeY3u4Epdx
 0Hvb/L5z
 20f3xU8kOIuzrce7hAJPDFYmy4WIWwvZyIRQwZ33dvl7inw2Hc786XHBeIJShSdma+Sjy5Rh2K/ggk9EDnBcEnfa2eEbuA/stj0LtXGU8PqgZtZCr7iW5mNh9IgcKVW+OiurGLOjzoaptM3i8fGIo0wmd+bvbXrbHhlXpHPbnIA6AAuh+5eBiVzM6TQ2y7nG5eURXqSnJjG/hHTMvNoPHMMY0fGsoGcvRO4UDOKvQTqTqIY5pJA7L20Nt5UdZed7KiCSYlmBGnEQ07t6qmqWTz7jv27gRo+3j26BVuOMoxEMGIW6Up0FcTn4mZv22FoLinJVlWDiuSDEhHWSgYy6gvB+xkxuFqEUPYtNHVZ3XX22YXeQ0xpWdTI16zG2PERI/UkxxqwqyGblZct3iy6OwuLEvG7+tEnkYDEqLLqUWV/FFuo/GDwqkcFUeJ3OUh0rv7l/1YS5YaerYFi4Oj6V7sQMPHOiYYMtBT9GsIAe7ObJgcFeqYHSRL5mZqkVXDtS/nbRV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026 07:47:02 +0800 "Barry Song (Xiaomi)" <baohua@kernel.org> wrote:

> `prefetchw_prev_lru_folio()` is currently implemented as a macro with a
> potentially unused argument. This makes the helper harder to read and can
> also trigger checkpatch warnings about unused macro arguments.
>
> Make it a `static inline` function and remove the unnecessary `_field`
> argument. The helper always prefetches the previous folio's `flags`, so
> there is no need to make the field configurable.
>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  mm/vmscan.c | 26 +++++++++++++++-----------
>  1 file changed, 15 insertions(+), 11 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 2b33d3f44682..81f95a968447 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -182,17 +182,21 @@ struct scan_control {
>  };
>
>  #ifdef ARCH_HAS_PREFETCHW
> -#define prefetchw_prev_lru_folio(_folio, _base, _field)			\
> -	do {								\
> -		if ((_folio)->lru.prev != _base) {			\
> -			struct folio *prev;				\
> -									\
> -			prev = lru_to_folio(&(_folio->lru));		\
> -			prefetchw(&prev->_field);			\
> -		}							\
> -	} while (0)
> +static inline void prefetchw_prev_lru_folio(struct folio *folio,
> +		struct list_head *base)
> +{
> +	if (folio->lru.prev != base) {
> +		struct folio *prev;
> +
> +		prev = lru_to_folio(&folio->lru);
> +		prefetchw(&prev->flags);
> +	}
> +}
>  #else
> -#define prefetchw_prev_lru_folio(_folio, _base, _field) do { } while (0)
> +static inline void prefetchw_prev_lru_folio(struct folio *folio,
> +		struct list_head *base)
> +{
> +}
>  #endif
>
>  /*
> @@ -1695,7 +1699,7 @@ static unsigned long isolate_lru_folios(unsigned long nr_to_scan,
>  		struct folio *folio;
>
>  		folio = lru_to_folio(src);
> -		prefetchw_prev_lru_folio(folio, src, flags);
> +		prefetchw_prev_lru_folio(folio, src);
>
>  		nr_pages = folio_nr_pages(folio);
>  		total_scan += nr_pages;
> --
> 2.34.1

This preserves the prefetch behavior while making the helper
interface clearer. Looks good to me.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

