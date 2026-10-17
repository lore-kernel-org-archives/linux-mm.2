Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5507CCF2C1
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 17:53:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50F116B0088; Sat, 17 Oct 2026 13:53:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E6846B008A; Sat, 17 Oct 2026 13:53:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 423DF6B008C; Sat, 17 Oct 2026 13:53:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 192986B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 13:53:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 94F47C0320
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 17:53:25 +0000 (UTC)
X-FDA: 85332865170.16.BFD6E4B
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf13.hostedemail.com (Postfix) with ESMTP id B623220009
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 17:53:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UVxyLhu5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792259603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w4U2BjgqQMIyASOu2f7QDzW/sels7LA7kZfnUoXucck=;
	b=YS+AVMlOCTwl8nyjh+83rB0fUIIXab7tB+djQuf96d5N7RRIhnFRlJUIMQSEJ8AhPIKDH2
	ZfxrfaBJ1So0mAxCO3v9+k3FTOsC9M/m0HGYwoByYQ39r7RmGzwbIAbfpKPH1WPn56hj3A
	6p4Uo0fdEFSt4Hb3yZurkvdJEUo2yZ4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792259603;
	b=13eMHi5ybR+r/jntI0PB2YNfeVXCSwph7PZmkJarxTYzHgNra7YllKpcDJ3GxQjwM42yDR
	ZZep7ok72b5U45SHktxWdslTXAc2wsjjsM/nqAp7sy0RmtW/E+VqOozPdgP3emp58EnRkl
	jy36NVQM0Ff2wjrlR/dmRFOv8lwIYEo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UVxyLhu5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=azpijr@gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48df0fa43c5so621542f8f.0
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 10:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792259602; x=1792864402; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w4U2BjgqQMIyASOu2f7QDzW/sels7LA7kZfnUoXucck=;
        b=UVxyLhu5IJMF/g53xvUFwAJeTG+xdc0aAgw29pOAY0agIflq/bHQEmeWON0qcIv+iN
         kFD4d9oOMRsa/X1OWvfwH9ZLWKCzt8BvDe8GgLrJsCmuMIQPtV38I7WnZdlE7RXjHAhW
         JGdF1Z5uaeioy4AefPZyWN0rY375DXJKbn0Y6fqSMsFdFGMMYzgXf/42qdP9Ur1Q2bNe
         N3IUTZX11eddPiLbLi/T7cUQNbAeSSZ5vg/ri3LyS1nHcdhQo/0i/iJ+ahDUnFedWb+U
         pEXino48Ps3iF7RZN8S3q/Gh+HsSBPFzF47nuNqoeSujY7H9bTB+lBUG4gMsnDo+aMs1
         IoMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792259602; x=1792864402;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w4U2BjgqQMIyASOu2f7QDzW/sels7LA7kZfnUoXucck=;
        b=taSxCdzyriTSZqzO7v61HGklUyUbzW4MZBFFhQw2/OndlmK3+IGVSTw8Fljg6dOxZ4
         SYV6UrV6LqGopCbhnX7qCIM2zJfkcgJE5CbqXyvyF5TPKlrnPg0LRvVGG8BMU/HMFB7b
         u1+d2xsk0AQmpNvgmEJuTejjL92FtOthJFZHLjANPUGz0t4sJi9it9AwwuiQilsQd6WM
         QPl0vshIh3+pNs9Fxmknl49OJjjotgcSbP5MNUQFrF7ceUnT4VAk2ik5bcQDh4PxbMcM
         0vdr/gnanorxtRYXx83SPIddVlX22AGj9Vjp7nmmAcXksx2KkPf8wkSWPwAe9/P0IVY+
         pYSg==
X-Gm-Message-State: AFq9FYJ0aqZz1LK2mMnAt+0UQwe7N8iI+lWKpuAUOY0ILDOjxrKw6yyu
	qtu4CVx1nEo/nzo9aOOCUGC4JpoVWUozphrW2FHmKuN85F8E5mAmZFXj
X-Gm-Gg: AYBFou3L9uOTf395O66AHIq7rKADAcjIw/04WQdb/VFpCj7AkBhrtyTNbQcxIDJUNR4
	6sa1VxOuzJrhxfSjTOj3HXj+DOIEfr10KgSVQ9aeHOmD1meQZepc0HyMarWL4sCKJKb2Ci8AmEh
	C2mvPi4yxlxF3FwpMPvWpB2swblf/L3/LvYIml7Q20+QuN2NUyxIsQ/NuZuBcj6FvHNxwZcIMa8
	iS2IwAgmhsuGyARy0eqO4PU1DTjDQnXl4o2tB+sw9W4C8WC/mq0WGhRmf00VlFfZMvWeb5Ad4bz
	rSW6KZ7cPi3kJOe4y1u/7rgysUyJ265/ZEdb6MFLTcbCu+WiQp5BinrAzIRTmmv1Mi8oNp7Va7z
	lHcqOadNAG1gKwrLN+MYXdZWxObCo5v/xnvQxFqsHiGCma1Qyi5xSF92TLXzivMm+7TLuf4Fsxg
	V29SOUmI6c667KpU8MhlR60z56KEsCB5EeUo2pe8KD+4AUak8usgRjs9DSuebs6O6qDg==
X-Received: by 2002:a05:6000:4b1d:b0:48b:437:8fbb with SMTP id ffacd0b85a97d-48dfae72117mr14846838f8f.19.1792259602249;
        Sat, 17 Oct 2026 10:53:22 -0700 (PDT)
Received: from [192.168.1.18] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd5008e7sm12247801f8f.43.2026.10.17.10.53.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Oct 2026 10:53:20 -0700 (PDT)
Message-ID: <85ab08aa-9ab1-4f32-b16e-10e778669e24@gmail.com>
Date: Sat, 17 Oct 2026 19:53:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] mm: hugetlb: group CMA pool and reservation state
To: Qi Zheng <qi.zheng@linux.dev>, muchun.song@linux.dev, osalvador@suse.de,
 david@kernel.org, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1792136742.git.zhengqi.arch@bytedance.com>
 <100b5e1400e692086b1af70e88732faa5a638be1.1792136742.git.zhengqi.arch@bytedance.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <100b5e1400e692086b1af70e88732faa5a638be1.1792136742.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B623220009
X-Stat-Signature: 6tgoy9j1w1y5x64g3qya1sod74pkpbzb
X-Rspam-User: 
X-HE-Tag: 1792259603-753318
X-HE-Meta: U2FsdGVkX19oV+07wyUFUd8QDdSQTD7yRsJ7CnMwAQSPpPKks5qwh0bP3OmEN4tj0tkI89cc2PP25NTBZ4U8N+WNfKyeJ9YQ5c3OBA9sXgssZ+JO5A1QarANL1DjPL340oqE9V223Ww7qGNzhDyP6E67/5pxUnC2Mu2eBK2Ecu79hRL/HKnBPsjloHOjJtEzMQlbmjSqBfeyiJ56f+FZNzjmqByKutqnTYfOqxA4OjDB+C/sINc9V59PAEI4/XWxzimZsehKHKdyjhkK1fpSkjw0O0zaC90HeHbQDhQcTKQ3XCsJ9qK05gs9YQDkpxctCvbtn/d+TkebLZhK1hI/bJ5mKi9qAkGrewYQKPzz2UuX8Eyr97Ie1o2LIfJJmFEz1OvEyd/2O0uyR9aDZVxSo2fgWB/XrTrNFE+bURSh9zjcR+2ifGKGu+Z2sijwpvFdS6rJvqL9/Uenq6+Az78K9/fhNmC51gTCF2g/jBEP5bNlUtq6rXTBq4+dPJCLh2zLlylqAdihmScG8ePi68o4fi51kGLjnE+kvmZsYnHWtUzL4MlOrATQzwdPgVUIYPEdGJyFgcrxmzpogSxfGWNchkWikxs6vw9/0YZlfAgzS4RhNVkbdXPL3PGdcqkHT/Q3ZEhk863+jLntiWZzZY8WC5ioG4UMT80Et6RMSHzTbO3eA47M47APlWtVktrq7Ew8czf0AAfdCB9Y1Gc7iJWmNiSAvrP8brDbvUawdQ4mPJkntjDGBUwC33MXBWnIvDzrX4gI0gv1G8c6mIazFUmOArXgNnYfSCf1opaHl8IDPrnlSv04btVzEb2O6iGvVBP/npZvQ6AGkNr3YwpLLuNXebqTStTX9/oev3MtpOoTfqi3X7VOe8kJhntrRaOOshZWetWJcjZ4Opt374ohdxNjZQpRAIWyfQ/32Er+0+UJxIBSqFZZSG1n7h+yivkcxXpDCGxActYhAnZmj7GB9f0
 rPa7eJWO
 tz7TMKaSNnG5ZH1e3YD447EVugdEpn0ovet85nGuXRUMNXHEExvKnAy/PxjDQbulJ4gbtPcjgGtwbs7ffRCg3hdkUxWw1J9PzJVX5/UAvkbFgbzFWh5dG8Tao8BkWtSiZHPEypGO+Rx+4cwa1/0m8F/SZBUHtzUqUQb+eKRjzAEZlu4DiDBGU+uhIRadv2fQubcQ2Dqph2Ygnl+oQdL0XV9985FGuSsV/RHThqrM9+Ak5NDpnUzSG9KymxQmWqmrZizPmTH2HRVwDC+bGqygbRTjYwnLTGUSlpygKKZ5iWfi+NcG3OO8JANw4GR1ktbSGb4ggwCQ/fvsqpNMm6V1r7/pEsvF+T0JrOApZZ9w2ReF1x/fsm3Nm1uVxdx6i5kpfhiVS/bKEVxIyyRpOazD/tcLvKzDcajNhKffga12n6L2I+h8+fzgHvZCrm6pZVNKHA1qjBF21858F5tkl1QVUR6a8NcuOHL1WAUanCEImalA4yOw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/16/26 12:07 PM, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> The HugeTLB CMA areas, total size, per-node sizes and percentages are
> stored in separate singleton variables. Group the runtime areas and
> size into a pool, and the temporary reservation inputs into a separate
> configuration structure.
> 
> Keep one instance of each structure and preserve the existing parsing,
> reservation and allocation behavior. This separates the mechanical state
> conversion from adding support for multiple page orders.
> 
> Assisted-by: LLM
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

this LGTM too so:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

