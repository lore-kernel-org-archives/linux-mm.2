Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6769D606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 18:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zPo3rfmf
Received: by kanga.kvack.org (Postfix)
	id 48EC36B05BD; Sun, 22 Nov 2026 13:03:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43EBA6B05BE; Sun, 22 Nov 2026 13:03:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 354526B05BF; Sun, 22 Nov 2026 13:03:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E94636B05BD
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:03:21 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6E483A8218
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:03:21 +0000 (UTC)
X-FDA: 85463527002.02.10F89D9
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf08.hostedemail.com (Postfix) with ESMTP id 742D116000E
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:03:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zPo3rfmf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795370599;
	b=2em5pNwG2f4FE+lfJiq7uesjPEqZgVZlYTKs59fjCdyZAd6zUstAW+/8NTHqmlPfo1YCBw
	qRE8Gx63VCsXZI85+GxiTsEw+zijSZDWNIkZkK8kWm1Skwu4Prhp/9jlxVT84V/J+jY68y
	xBRbJubOEd7hdG6evruLVcWxwEpSXyg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795370599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rqLv/9YNKuSPNEbPU4wgT4+9l+6I6n4mJ71J8IObdYo=;
	b=T0v+ZXCu1819H8P1ZDWiTmz/TbFhh5b6YciqZtUOwuCI9ckGgfLeB7mvMyWs0sZySuAc7B
	Gq1XQIagxC+MQ4ALSAzqgNHiLrEJbb2e52iY8w29AbrA6asSW23rbsTKd7G9n8650uDwDU
	nzkiJgHO5TKk/r6zbRXK+vOALMAG1m0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zPo3rfmf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=azpijr@gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so30789095e9.1
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:03:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795370598; x=1795975398; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rqLv/9YNKuSPNEbPU4wgT4+9l+6I6n4mJ71J8IObdYo=;
        b=zPo3rfmf2tHWY82iUD2PZ1LCCpQ0u3l6mylSE2CD5b65zi+GrA2w97rgxmClxOtN05
         gbVh+5QQr55OhR6NLWUBjrEtbhzfvQGg3eISc+66/9tfllpS5os50LvV3/7Y8rKihHhP
         7IKp9XEeEQw5OovG+hkUpv/U8bkF3nWQey6jyk/NqBm5usAeKaI+qqif2V4P2U9wOZlq
         XshA7qq1X1YdWFpuns0o9QG/HUf8WPmfp81iVp/Vh1GaUKdI1dOvQ6S8LkC9tzV8NnvF
         j56di+Dz1CjFEvo/pQHosfc9C7p+9niQi4GRU6QDAg0uJ7wvX7+whOd+1rEIDe2pTn4z
         VYKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795370598; x=1795975398;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rqLv/9YNKuSPNEbPU4wgT4+9l+6I6n4mJ71J8IObdYo=;
        b=25BFF9SVzdo1mldsawHahfeYGVuGpHh6L2Hwt5BVzVB1NsRa6ds44+i7kXPMk1vGMQ
         xJ0pXEryVtwgT2ocAlauTvmbD4JFxOwlS4SkzJeykuNBD5v4eU7kDZK4BQ1ws8i952HL
         QURi4WaLvfrJT7jmvYzWf7xnp1T0DGb2hadCLcUhTZBcce5G28BIJ6DgKAdXpekTphzR
         131qkD1j8nFM8l5qccYUZF70nNXunFe97z4obp6h/OPBDrBpzP1wGLRTFJTQWECTncM+
         zGput6ojOXN5Hmv5rhw/GeAzTaALqpF2AEu1GAa3NU8zagqnS7d8oZIcf4mO6fYQuVge
         4E6Q==
X-Gm-Message-State: APuU4Z+ulIAx7T1PNifv6EpaElQp3xED6Oql6Dl1ti+CDpzlWu8taas6
	bBZH4qgyJyM97xfpEciGFVIHxn1b6dd7qNAFLhZxN6i0tNnkBbCF+yRv
X-Gm-Gg: AZFdTZdPwe9GMZuql4j9C9roKi7ACL7A8iOVwErDegaua4N0mvgUFwelWdGwuN0Qbpa
	2V/8oM5Wx564A+XmthW9i9wAHYFCuZPDrU+WbJ8spKP/MMxcxBQ3IOUqoDToySvfAYqFlPFNGoP
	wZP9/qreJ9mJhiySfXjkjvXbBE+zANUAwcJH1dZdnso+quK5IUXiK6nyaXKGSlfKXYswz0RjZCO
	m9gNd49k5H/MtCvsV6nhv4RN1YLZ6Ox6p2Wp6QqiYHLxLYBw55U5jc67VC7uDkQhl0Erufex/in
	PCVEWM87CdxKgDZB+WGNy5NtPv2y9D1vvGK0rusZ8yJrgAeVeMfj/JA7C7hOmbZY+otR5JcYwb5
	1sfiQcTyKl3nBag2214fs3XaH1R3AFB+zb28AX1vVPCS2aL55Vnt4g8D1H5DQDfczGGGzWCb42K
	XTuloEqOme+ev7j4UrBlB11rAUvbWq9qas7m9EdTIKrXM3tSPr8zFgkcSKieUim0cbuI0cfUj7p
	qG/KmGEw7k6ADm850aohCleqxlAP2h7/uOOrY3AKWw2Cwvqg9Wr/y99gcpWK1pIcXnKyfkuCPJn
	Y69Wii7Ni83WD+w0Yiv67MQp
X-Received: by 2002:a05:600c:1d09:b0:4bb:66fd:ad68 with SMTP id 5b1f17b1804b1-4bb888160cdmr206483615e9.14.1795370598069;
        Sun, 22 Nov 2026 10:03:18 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884b7515sm383064735e9.13.2026.11.22.10.03.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 10:03:17 -0800 (PST)
Message-ID: <eca89988-bf36-4d41-996c-1d945be4faf1@gmail.com>
Date: Sun, 22 Nov 2026 19:03:15 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] mm/vma: lock VMAs before taking mm_all_locks_mutex
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>,
 David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Kees Cook
 <kees@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
 Ollie Wild <aaw@google.com>, Adrian Bunk <bunk@stusta.de>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Joey Gouly <joey.gouly@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-mm@kvack.org, Chris Mason <mason@kernel.org>,
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
References: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org>
 <20261121-some-more-ai-fixes-v1-2-236e925d9b64@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261121-some-more-ai-fixes-v1-2-236e925d9b64@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 742D116000E
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: b6d15bjk65aubqzcqj41bugjpf86f8n9
X-HE-Tag: 1795370599-350785
X-HE-Meta: U2FsdGVkX19A2YkAeaZ/GcCSGNzg9QaXUQybPtEwgT7DUQrK9T/xPO7T5ZE1RHwjclRjSmRokA7hPFOpyxxQrlk49mXRLMzecArWkF51ANfcuvittMebxuLkQFvcjSDNLObKZbv9aFBaKp010Cc9zj5M2jQBwvB8Mvn7yhEPfgA4xt4fvBHTOHrog0fFLFt/IpMJre8Y3iWSPxn8KxTQcdirST+GLd/JyOygB5gsWks12xo1WmXXPwOKJS+sXK6iN2FfTN2r5WNLYahHMPBY0v5HssspnJsD7Ia8Y3BrNtKLlHnWr9tOwzqgQ439dbMunHmDwWei+OeR7MJKIGBpzlsu+cJFAw1hkM5w7L+b/lVkJomO6P0kRCX1jjX94ZCokzoVjGVjLEewUHH0UpZIwTQc18NLkhLDmwXcjzV9qMqAYt4MevQVXrSBokU/lUWvvyWezQ3UsdZgmdFADvqU7v7/HH9CqYeGFnVHf232reDmHhrxBisIc0yddAcSmPqhAAGUJ6EL+iTbpBr+iq8BX0sDRfMnaH91NEj7Q10Cl6bb0r7HEZN9WdFlIuQFYbOBFJTeeRJk9XToHOZGgo6dZfbYvVixFgUSbGj0wIFPihlcRyWqDRXYcCxq3lV3EeidoeUI2qp7poxhLVBuouq6Tf5dnRrYkNOt9TKOi55XyRAHt9mPXQ4r6iVsyHmrXOwmOpgyCACdzoRAFZigYIzhNW3Ml9yccS43H5OnrXjkuRa4oiKSi1AsQk7ngEzu0sBzjRQPD2PD71+SyasT+WMkG6wSiO/GE0AoQWtE0Dtz1Yxm1NKohVLRhUbkNpSoRiIsCgQffVcbP/dSeFVwpbJ1p96L2QLt8X3zX5ca2jElNx2BFsnHg0oD3WALOghK0j3Dpzh/G/7Gdr1sAytT37aRvcViXAA8hrQv5TBQLFlU/85nzrzi4Vn2DgkjpUJqFe2YH2lhHfSeZrrT6eEHI1e
 3FTNa85a
 f8ODvdyIyOo0PPComPumvQBLctrT26swEkFxlmDBI9zI9+wTYJjGvB2QNDMuahpPeI9HbWaqt1ImlwW71Zx6gzY952pe+aLaYPqp5WL4+eoKnCt/AskMuqcS9MLpCdV/UcK/M21TjDQEWupplxQl3ztxtK52ITvmuTXdk47HWBHstScAuR+p7cx5G0s9R+RJyP9XmM9pPHdyRP91H8PFAOOj2yjsyfo+wr+JialtMmBrh7eBIQ158w0ZvRFrb1whAEB4ouJuOwjNouRUw9pdHaGXbR60jfcx6aH41qaBckMFe9O0PkSvImLWDlxMM0ASuk7re20wX18cdFoBqUwT/0Q2INYCuzn5H/oLXwsRv+HZScPa6CAVUhphGDR+FT6Yfh8x6JklsmdYL29GKrcczZPRH0IDuJTf1smom+dtISaOOyPYFMJEhV0PiNNn7AF29dKe6EafG53I7tekExGHuZy3/IM2yRy/zvk1SP16P5vWAjOhGIYz+ikd4byf/U74tVo3HskVeKFliD7rC1wLXTww1a29/WncWhsTjGCjAX461dCsoqefDYUdz+aClrcHO9EBCygfej9OiQZJVFCLDwG2Yfjw1uHPfFxBOb4TZuBLOparTjkyn46h+SCrpD5B5lm4JkRIQnLGT0hNqcwGHd0CegY96t/uZMvyK6GcvMBL1UQ5bAsBqbJsvumtU632ZnY8XZVzyM8oydM3RObXGF6pPzPtIv8FtwfCuWKGLZBRsuk4A2yyP1tzUU/LdNckgXigW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/21/26 5:02 PM, Lorenzo Stoakes (ARM) wrote:
> If an mmu notifier is registered for an mm while one of its page faults
> sleeps indefinitely under the VMA lock, the registration of mmu
> notifiers for every other mm can hang un-killably.
> 
> mm_all_locks_mutex is shared by all mms, so its holder must not wait for
> something that has no bound.
> 
> However, mm_take_all_locks() calls vma_start_write() on each VMA with the
> mutex held, and thus waits for the readers of the VMA.
> 
> Since commit 4ed4379881aa ("mm: handle shared faults under the VMA lock"),
> such a reader can sleep in ->page_mkwrite().
> 
> Consider fuse_page_mkwrite(), which sleeps until the FUSE server replies to
> a write request:
> 
>     mm A, thread 1          mm A, thread 2         mm B
>     ==============          ==============         ====
>     lock_vma_under_rcu()
>     fuse_page_mkwrite()
>       folio_wait_writeback()
>                             mm_take_all_locks()
>                               mutex_lock()
>                               vma_start_write()
>                                                    mm_take_all_locks()
>                                                      mutex_lock()
> 
> Fix the issue by locking the VMAs before the mutex is taken.
> 
> Additionally, make the VMA write lock killable so a fatal signal returns as
> quickly as possible.
> 
> Finally, update the comments to reflect the change, dropping the lock
> ordering list which begs for bitrot.
> 
> Note that the lock order at the top of mm/rmap.c doesn't appear to be right
> - the hugetlb locks are taken after the VMA write locks. However, this was
> already the case, and can be addressed in a follow-up in any case.
> 
> Target commit 4ed4379881aa ("mm: handle shared faults under the VMA lock")
> as this is where it became possible for VMA lock readers to sleep in
> ->page_mkwrite().
> 
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: 4ed4379881aa ("mm: handle shared faults under the VMA lock")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

