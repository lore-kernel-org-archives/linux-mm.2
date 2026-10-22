Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 552C9606A31F
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 08:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=HztEBxNy
Received: by kanga.kvack.org (Postfix)
	id 7D9A16B08E1; Thu, 22 Oct 2026 04:51:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B1CF6B08E2; Thu, 22 Oct 2026 04:51:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BAD16B08E3; Thu, 22 Oct 2026 04:51:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 46FD26B08E1
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 04:51:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 544A9C07AB
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:51:47 +0000 (UTC)
X-FDA: 85349644254.15.A4DE16F
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7BF35100008
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:51:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HztEBxNy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792659105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qcPKKex8SUB7M7x/WtM3wT/+W+o+Q7epNmz/1RG6sOA=;
	b=TyqKDeSsdSKiaxFfXrYqj/HHdXX6JCjP1EIet3MYgrtTHGOMATFn0G3odeDM588tIJKOxq
	qP8XmhnZlVEABNpv8xPAFEfYWK2MnjBDTBwPv+GwzCn0UGXJlICO/voMrFdqA6yzd7p1AQ
	lQpG50PwTe0QA53ib2KumVfrDUwcGPc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HztEBxNy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792659105;
	b=0lZtOLrNg/r1Z5jfTH7OlZ8v8ePlzPlWvxlVBbCQyg8t8qDVWdkn74lKYxXNY9getTKh1L
	VaIDzlLSdJE3eaq/SOxVRkuaoBGBbi9FuAZprar7tiW9cAk85aQDC7qDPokCUGzcJnMzCL
	c368Oj4t66mN2Vet85v5lnm0+GbFPls=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a1df4c0966so3851345e9.1
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792659104; x=1793263904; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qcPKKex8SUB7M7x/WtM3wT/+W+o+Q7epNmz/1RG6sOA=;
        b=HztEBxNyxISMCSxgavG+hZwg9fyDYhP9tHuyndCZO0YdnJhqwifn0rXaBKXFcLge1T
         TvPI4HgXysMSy14e7UossTp2TaTrgaDeDESmHUCPPMsPVPZFzcS3YQsq7r+TvDn2F05S
         WqLLyvQNdHzN7TzVj3cITAAFuSXykkG429STWfKh8aNnn++7dR8df05jIuUkIMSSVO1/
         0FwrvRPo+XZThGBh2KrQ5zTA+pVjHjgVDgtzy2ZkryRdGN7amdO9eOCbgeHvNfgAKptq
         5xQSScPqXtXA4JQbiEBVMwoq887rcEZuwc1KPNDEUi8RVUpOgmXplkJyxThe8sOT0sfH
         /xCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792659104; x=1793263904;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qcPKKex8SUB7M7x/WtM3wT/+W+o+Q7epNmz/1RG6sOA=;
        b=SfVZ5L/xDcu0p4EzgVxblLj1e34nsjC+92l0MjbFXB3O1Udhr1/SWrhoOj6FkzRDNX
         PTxRepA5KeRgNTkzzQEyVBBzFHNtDhVBnJ0NMi+bQAPKW9I7nRgyYatI50LAMVAECxvU
         Rxofoy7N6GybGKWlPZ/1lEKDi9KA4t8n/ga8ES42cufe7OctE0VuNVEuJ60sfP81Obyw
         HX9X+k8fHdABfzglNs3P+4sj4iU9oP2Q9Oz0GA7opGKQGnK3UwNOnDjrV5zXAp09JIvc
         Af5pENg/B7f5OaVwyx+jDUkXtsKa8hWOXM0CEKVlKaNvTWvJSd+PrZvFRA2GzMnN8Lql
         7gUQ==
X-Gm-Message-State: AFq9FYISdSMeHXwk3rwzbo6TbWkIPhvWgxzHxBJlVHIQHn90qYejwGXy
	BKgWizYUDKZL2kYtxu7rLAwhxl9bQuTUpZr/Kw4Qz8Orqv7KXT3m6Lb6
X-Gm-Gg: AYBFou1cp2t6nAG/eNJmLQQtP1VjxhhJJU/zUrQ3SChWVMKR4zhzPApumOVfitjqvPD
	PoKlFmIL66CB/VOvBwFwu5kZSrxS5VEZBTzz/4ozC+f1gGUpjfW4L9ibKrBtdlLc6NGBoZq5ACb
	KBwy4RE6vOgD2PXktXR1VKCbhbbdjllZmNjDbJxNo6aFNoADkJj3xmk1zY5Jqnd4pYS6CUmhLgc
	sjPfRRKdfy+hIvFek5PDXTpBEKMkBKaThIp8moADDEASBUjdCsaSx7t6wRA65MHvYCNKedCued0
	Pc7UwqkM2wQSU2iuOL5MWgbJDKfbrsUI1rwYPihF6/73bH+OMh4U5N9ny0vNTnE2WX3qoLRO3z2
	MtjbuMc1nVrg+/BptlCzeB5WcobpPAjLf472pLh/56UYM/FaqQZN0VdthgIzId/Z217trxE0fT/
	EvtgnzkBlmoW7/rjtyl5vXU+aTblK7kLxiDIb/KX1Oikxs58WnKxAhgpkKoHJS7aXAmrrTdeO/H
	67sJTBy0JB86PHjPoixMZDBvUlEQe3k340E2z9CUnaQYIDWVZ8=
X-Received: by 2002:a05:600c:1c1f:b0:4a2:b73:d15c with SMTP id 5b1f17b1804b1-4a20b73d260mr7139465e9.3.1792659103854;
        Thu, 22 Oct 2026 01:51:43 -0700 (PDT)
Received: from [192.168.1.18] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1fd0f4427sm101767255e9.3.2026.10.22.01.51.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2026 01:51:43 -0700 (PDT)
Message-ID: <5b17b4ae-0db0-4998-bbfa-51bbeefeb551@gmail.com>
Date: Thu, 22 Oct 2026 10:51:42 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] mm: hugetlb: avoid recursive CMA allocation during
 migration
To: Qi Zheng <qi.zheng@linux.dev>, muchun.song@linux.dev, david@kernel.org,
 osalvador@suse.de, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1792651104.git.zhengqi.arch@bytedance.com>
 <35120f1e65b135ebc7885a85bb39baab90882820.1792651104.git.zhengqi.arch@bytedance.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <35120f1e65b135ebc7885a85bb39baab90882820.1792651104.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7BF35100008
X-Stat-Signature: 3wydnyjqdy8qcycfxg4zmboxwbdnd6b6
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792659105-239176
X-HE-Meta: U2FsdGVkX18VgnEn22WeVe1DMgTwGc5h1DHmmySfCKzlXBPlbaCWgrvXx4IT3u/0r8q7ghmLtm7wonV4z8LiOJE54QB3ILZnERvBBzrBs1o7Mpold3g1TgRUkyl4SCm7zaTaNw1qwP5vhcmul+vQfJgwQ1F0wtzoRxVHR4pNYu62cpu9zPuOBO7I6zyWPUygibSeUlGXxVCeRwDGY7FrMAODHSz/L2a+AtNrhPMUwN1GchkpxK3CA2k6Giqb/VvRTGO8nZmHKCtqiLySDbYIZhauL/EKJYTVbnZVnzk9q64uAI0sV1anc5BqTU5cYVCXY+KsWWkQz42PMTGRB/rvRuI462HTFt1wTzNhqK1idlyFKWvMuzD2VpPmkCKJqqlk10nI8wvAVwbxn6+SZ/N2nqRU/RwaPb4HCRy9yrvgMY7ChEOikxWFrfrzuPv/mVVwBzrX+3E+bUV+YiqyhwI7cJp94fC2OxBzgnTyNIhb6P7mHBzUSIDCnChGXZIFUaP3yJ9EqY7mYkTndPnhLrKHouperd3+tgdENax2jZ0hQHenjvV96FgJCrbCzH9b5H+ETwlqXQdo1ihfq8wDHDy02pF3sePZ30h1YGBmHF/8t0P+YwbD4FTJbjGpR/4XcGvFUAIh3xG8xDq43Uia53yh5Cq53gR2aQaXRL+zuwN7UjGtDuXR1QEfyxzDYuLAorXHtLgGyZMMGuwn06U+ThBz97k53logFs6808XVIaHxPrVJ8F3AqTFMta+5/WZ4P3Un7cWSRetfaJo5Hu/Jz5TaNB0cd4H+BrD5huSqZV3vlH7PiDn3vb6RXoBhzjwS6CwnL7fyfB5rh7tknFmbiZeYvbeUptCCINL2OrtD/YGO8ZkjHf/nm9VgA3hhzJSany5hQWce9W4eZJVG5NPjR8V67XTMXEDvaBD4aSGLAyAYUo77MzosWu1ui67tNJydUeScDpzY0OHvHMc+XPezr54
 QM+4d1vL
 kqdyWObjbMsngVqSHWIpwQ7hGftmLrdqgfi9IjdSHj0dwYrxv4izfCDCNGO2UU+jbttvc0ofFsolaCya7m3LRdMwItltd0gVCUdhkS7pwKX5QOpNkqP5hA7GiQDt/09f4KimhWp5GQ/EE1fA3Pq3+FQCZ3YLe6fcLzxiRENDeYAaGdI66LroKw0PYhv5juq7rfQDjt0IJvJalqAnWayBHxLtLLk1+zpELemnky6HdskW4/BjuwG7Ei0AOW7QT8vlbGLyD57MXi99S+nqoeSXxbZPaibJDwxiD2hOtLGfMCu3YncluMnY6fThBgj106MUffrpLNBMREGsP6fbO2PNrMKS8PLH9rJ20CIKdXf7CH/aQoCYphiaoBQ3N+Jw0E4MQPa4lmX5Muq+mNjAA70Snb1HMvanpDw1EAM4oFdfcZ9Z6cB2PC03KWSjmB794dxLLS9qFdfF/Ns3o/3HoVimkY/V98g/C6dxb0iQEHBSD8EOkHiMq1ChT3BjKutqdl3LXL3QD5DVEH/Q7z/jkYNe8bB4Otsnb5zfLQjWU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/22/26 9:31 AM, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Contiguous allocation can migrate allocated HugeTLB folios or replace free
> HugeTLB folios while holding a CMA allocation mutex. Allocating a
> replacement through CMA would recurse into that allocation path once
> non-gigantic HugeTLB pages can use CMA.
> 
> Pass allow_cma through the migration and fresh allocation helpers, and
> disable it for MR_CONTIG_RANGE and free folio replacement. Move the CMA
> attempt into the common allocation path, retaining the gigantic size
> restriction. Honor hugetlb_cma_only even when allow_cma is false.
> 
> The existing gigantic migration restriction is unchanged.
> 
> Assisted-by: LLM
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
LGTM so:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

