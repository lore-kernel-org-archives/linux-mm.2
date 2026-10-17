Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01AF8CCF2C9
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 18:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA69E6B0096; Sat, 17 Oct 2026 14:41:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D571A6B0098; Sat, 17 Oct 2026 14:41:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6D326B0099; Sat, 17 Oct 2026 14:41:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 927546B0096
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 14:41:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F0B9F1A0290
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 18:41:13 +0000 (UTC)
X-FDA: 85332985626.06.32F44F9
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf09.hostedemail.com (Postfix) with ESMTP id 17C7C140005
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 18:41:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pONYI30m;
	spf=pass (imf09.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792262472;
	b=sUZRFPQAClxVgmQz3/cmXYtOQdbS/o/6dtAkhDvNgDNQVmiZogaxJjT9ZHbTYFFkRsTh3d
	uqdtPlvgI+aTGMDFg2J/vsWU32DvQBApjlhWT48vX8uHe6R63y0lpxsS55dLFIErYHLEWA
	ezAECqiNew352e2wirNZ+9b//g62T9o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pONYI30m;
	spf=pass (imf09.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792262472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k5FNedh0SyvKi+ARXY2mJft6/hxvUajq1URxM9wpjPw=;
	b=XyltVB10+nrW/X9in+IeIAEBJnDPgOreJTTSkFeov62/AbtrOdvKl7CjdUqozIasje0n2K
	y4IdiaU4TIdOfwSLIIerKCU4tHGFkKYQg8smDSS5JSLdesaf9O/S63lf7iy/L0SSRsn83H
	nXAl9QtWayt1YnW8F034PwYcPkXsJWc=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a1e1dade31so245575e9.3
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 11:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792262471; x=1792867271; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k5FNedh0SyvKi+ARXY2mJft6/hxvUajq1URxM9wpjPw=;
        b=pONYI30mvAF0Vaehv91wqcdQ14gLmw49FZg/VlbYM7uSXWMCVB27Rtu+vbu1cXKQbK
         8YgcC+YhWQVM+k/w26OTkTFrK85casTa8W/OELVYV4kZdB8GYSuZHxsSvZl+8orvmk0w
         MSw/2pejZ2vqCektBK1VR/1vjJaEnuvMsApEWKe5nRdvPQ+abaU6Iu4oAwdQmxubwPUO
         4MK8Y5gbK2SCFC3zLayUMFdQT73DYXcePGNdLBGIfFwP+UHzSiyU0ifQBqo+wu7IPTha
         ZyLI2x3VxEwb15U4qx2kAGhBP0Y74SoOFtWg8kYEh3Xat2zgOuu1w/J5BLEmWEJync2r
         TDDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792262471; x=1792867271;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k5FNedh0SyvKi+ARXY2mJft6/hxvUajq1URxM9wpjPw=;
        b=gzh5kliQAzGNx6YQFFugC2AYpX635bfSvXjXwxeMHbx/I5L34M4sxb6hYrj3Q3Oprc
         hhWyIwppLApUzmbfYzNPPjTTaNZxLtcu8XoAh+lJ7xAx4jI4BDRyy0azkpcvBSj6Di91
         oi1btJa/wY0HZhLOuqZ8nXWaakTIM0jgTK/7g6SaoQK7YzducEmxm47AtZsjepCE0tjO
         Z10rHNkDoSUhsObfnAc9DOweFI3Yevp32LxnMKkIVz5sJ1tdlrct/HLsFMnJGQcXveRi
         wcj5KdQ8J3YDOkoXD2hVqhcjGw8FD15cgs4HXu6CELWyWaLRd7TK0qNv/WpwcfYbamRi
         ZnLA==
X-Gm-Message-State: AFq9FYJ6Eo/zQNWbTzmyN88RjasPaW5L/Kguw11nO7lS7V3ehdJR43Am
	GR5y8p1Q6Tc7LAadnPtc0IptKh6ACUXkOl/1JjLLm5paH766L7DVrZ69
X-Gm-Gg: AYBFou3WihMBvAWCP5MM1FYE/PYZvJplcTA0tAxoCM8V4CRf/KuBKQSP2bohPDmDai7
	p+3Z6xjY7G3e8g+v0+mwODsxnr4+3L80Jz4eNDmIZ0V1eUqZ0jPMfK1bOiJ9rPLY/APTqqeoOqN
	8hKUR3j8itANrOIraw+a91s6680t7PLzNEvofoOReM9IjQy90Fn1OOjhTw231b89A+6xs62s4JW
	7T87ybvSa+QO8gJpyYAR5Qdmo517F6bOhmpe1xGg37SVyDbd+8RdX63MmQdS5espuX+XYPKfwZ0
	Ib/4dBpqn3NLyVEokGJTupjBq+tnLdWCYSlMc+susUPNDsM21gzGcxssO1bxGuWpF9BdwjUY8e6
	q1d3EyW0w3T34A8nzg4idiRbVD9DyyLBPoE3vpIvuIs+4dfRWJdvxMS/XQlC89ELO8jVItTKsMu
	xUcsTY2kW9QuUhiCwDWIiU4XIqIz6r47uAF49ftSRfQSVxBCNdDqymCQDcU3EUzuhGYQ==
X-Received: by 2002:a05:600c:1f8d:b0:4a0:1b14:d00c with SMTP id 5b1f17b1804b1-4a1d75ab306mr81479515e9.3.1792262470338;
        Sat, 17 Oct 2026 11:41:10 -0700 (PDT)
Received: from [192.168.1.18] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1df164777sm49895585e9.5.2026.10.17.11.41.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Oct 2026 11:41:08 -0700 (PDT)
Message-ID: <ac34f212-2e51-4298-a281-9380fb0d073c@gmail.com>
Date: Sat, 17 Oct 2026 20:41:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] mm: hugetlb: track CMA reservations by page order
To: Qi Zheng <qi.zheng@linux.dev>, muchun.song@linux.dev, osalvador@suse.de,
 david@kernel.org, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1792136742.git.zhengqi.arch@bytedance.com>
 <57cd5cac5e2749cba24c502bcd9682ad8b9f2bcd.1792136742.git.zhengqi.arch@bytedance.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <57cd5cac5e2749cba24c502bcd9682ad8b9f2bcd.1792136742.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 17C7C140005
X-Stat-Signature: f9kro96d84ouj3mcnoi1qi8146fzmks9
X-Rspam-User: 
X-HE-Tag: 1792262471-702773
X-HE-Meta: U2FsdGVkX1/4CR2ryvbio+cOg1Nuyb/iTtWCBSpVmM1j8TxEe2LzglbS7gFV+YI6ltvbM4P/EUHfVIIfN/39OMVlfUS3na4hn1kmnNi6lTgnpet27lrOdBCY647NIpJbZ2joblV8Hr3u9O/VFq1KxPmUbYoKuCUo4FExKMcrLsaXKEtV/eIYWeBjotL8r9Znf4Yj5DGduzqei+Yc5u+Cwo5Jk87Cvhf9rOUSKfqRWZ9kgluCWyARMq95wWxQei7pq9Esj4l/AXhKBhbCqnzQolWPEgfdREhvIicZPZhF3lqP9cqLR3zB+Orggr/h37k0nM2X62CedZJoJZhDA3J3o+sRW3a5tYXiieDjhfeuo8AT9rkXqWvADe6SS2VChiR/glZAIPieWBLXla4kdjpXf/1vLKNJ1lMFom79iSU/0eBFHanhInk61GfzzIdEwAN4iCebgn5Vi/8VxrKZnWmrwpepLz7zRBBUd83bmkcNxQq2lo2mCmsEkiRX83ckZwJGlbGw2/s38/evsAPMteeoNyYFXlEzEK8VUCdNPot3RDm+wQc5j2jWZS1dlKSLjtx29GfvGHsfwry0nqHFfPH1wJDT3c05GDUOAKRFKlwglfrSRE/gaxnEUxKjwcrvQbxAUGxkM7RAwba/vFo3NoNtJdcMDC/xqnVR0U82PGwPQEAdHu0D4SOmI4+dEPHYJbby4zvQhGXxgDt8OsnbDLz3Dc/Dtenndt/iK8AiL9RABN+n2rTkoYqpyDpgu+ZnzCKlNtELLMP+CvAXY1ecEgJoz2PnBUZxiPLLBxji759/+J0oUr06dZQbExOyDsR3h0ozDzQluQNQw11Kg24yDyGS24iroYjSDuuhaO7UBRewkYkTGzoqBwcg6wvWqjhpziBAORLkqf6VUorJlO4O5mlhAxI9gnmN7Y0+DodILcPhKH/MOxxAcUuEHTHt/x04hTaVreeTuVIqcoqKYMVq9iW
 c0mIBqyq
 Ql3NelgXJI1wdahbbc/PT1ffrCD2cS4Z+D3LoJu01KuzIIrzr/5PjhDh4dHEqmaQ4L6N76L+/inP3NJIzLzOH1yQc2G7ZS1sn2m1a40l+zXItHllO6Lh7k2T35TeClOTK7SbrwPkMlGebj9EJPHpN8ZA3+DlrSIBvA9TFeXoklLplS+qIPXL/Dnip/SRrVqNbzr7+KP8/u5JFM0/BigrLu4yuvN3hoW/bhFFQ+wTBOpQsIfulbgn4AEKcN1owUUHMq5GRy/XL2PZhdx7OIOM0U/5KL/fXvA4ySAbSVQAkbgrS6WjEFmrGiDPD7HQwsLM5+bbuQ6SIie749DFuJtw/DpbKbLPg9H8FPnh6NzgRooeZvu4p88KJGApSyJHCqlxjMsrJ2fPyIRZcY8B60T1IHSHUA6BrxV7/hClHiB30R4XkLpMsnlNzHWCpq12y0r21U0d2xA39Ka6HqVsZw15KfP86uQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/16/26 12:07 PM, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Prepare for a separate CMA pool for PMD-sized HugeTLB pages by organizing
> CMA areas and reservation parameters into pools identified by page order.
> 
> Select the corresponding pool for allocation, CMA-only checks and
> boot-time allocation decisions. Release folios through the CMA area that
> owns their physical memory, including after demotion.
> 
> Record each pool's successfully reserved capacity. Remove
> hugetlb_cma_validate_params(), since the per-pool CMA-only check already
> handles missing or empty pools.
> 
> Continue accepting only the architecture's existing CMA page size and
> preserve the default pool's use by all gigantic sizes. PMD-sized pool
> support will be added in a subsequent patch.
> 
> Assisted-by: LLM
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

[snip]

> +static struct hugetlb_cma_pool hugetlb_cma[HUGE_MAX_HSTATE] __ro_after_init;
> +static struct hugetlb_cma_config hugetlb_cma_config[HUGE_MAX_HSTATE] __initdata;
> +static unsigned int hugetlb_cma_nr __ro_after_init;

the commit message prepares for one more pool, the PMD one, and
hugetlb_cma_pool() folds every gigantic order into the default pool.
would a fixed pair work instead of an order-keyed array?

-- 
cheers,
jose a. p-a

