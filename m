Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91E5DCCF2C9
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 08:48:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B49A6B0088; Sun, 18 Oct 2026 04:48:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33E736B008C; Sun, 18 Oct 2026 04:48:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 206CC6B0092; Sun, 18 Oct 2026 04:48:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E6AC46B0088
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 04:48:31 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 63CE81204D5
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 08:48:31 +0000 (UTC)
X-FDA: 85335120822.13.C0C1EF9
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf05.hostedemail.com (Postfix) with ESMTP id 82ADC100004
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 08:48:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VbaFIZUe;
	spf=pass (imf05.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792313309;
	b=W85mE9yp7qB1j1mzADqo8vcWek7zK3Gs/Wpmf258l45DSeM0YvW2jDzYCLeFHZLjCu9n7L
	v4FKaBvZNzfGWUYhgzjGWAViNs4oL4kDl7XW5cPFcUXuLMfQA7i+YUeUKfFRDOvijnIEe2
	vrZrs9dVk2/BYfD3+g3jzZVPwIZ3Ahk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VbaFIZUe;
	spf=pass (imf05.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792313309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KN/6iLwfCQ//2avSJv9DQ5CIOHPByLS1SPM2UhK/GmE=;
	b=I1BAAn6Wfjul3tCccgrU1oi34sSbS5Bg1O1qw9mZ/VliF4LeDwK+5tR3GHaVSVhbeUxMrj
	MkRA0/Vx6UGGWaPLPgpGF9Ov40un2ZVYWkz1vNHq7k3NowxVidMfHt6Nt/0ieO6egFrY14
	xrTsnzZaQsZw6LSay59RShfuTehYJk8=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a1dede3c2cso9533855e9.2
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 01:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792313308; x=1792918108; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KN/6iLwfCQ//2avSJv9DQ5CIOHPByLS1SPM2UhK/GmE=;
        b=VbaFIZUeKuCWQ6dCA3Fh0+EyHidtaloocJA3enc/eL1mK6dKwchBkwj3/qvfMtzktz
         8GZmXr6pKHkdzYs/Txp9W7PfDs4mBG/PbpodS3KaEA1XWpzDxQn+0b72Gf2bzDdSdmif
         v/+p1sum2QBai6lR/gzeoMIurMpQdDL3uIWbgcJsJDojNyPaE+8Hr1SFy8j7voCYlkcy
         ICa4YZVvMi4eAMTL0Lb/rEXlUraYrMJmtgGUK674+WKJX9ZCPJGaO99K9a1/U3t2yzsF
         rNdt+5LvFb6c8i/58A4ULpWu9KGSeA+kzeEmSsnFiKNMSWh6tHLfIxDp9G0fuxYpyAf7
         Duyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792313308; x=1792918108;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KN/6iLwfCQ//2avSJv9DQ5CIOHPByLS1SPM2UhK/GmE=;
        b=WEPHJIQeDTxSKKak+bomsjq41FsDa/3+yn9jtA4WS+eeOO7dyJK+6on5HEWQ6bsDaf
         FqxN5Pp7yDF5l1BXBxh20o7tLRAo8mPZAqFp+gE6FDsQTwl/Ij89I13w92pXvXsO4y14
         xEVpl11upefkW3CCGpW4My0VOQ5e4+3jTgFDk/HOfmZjesyF3icTSylYWRtoqQ6zZ4VQ
         VmRJrLYuEbkFOWC90Pdo6qSptbiZ+Zy2YoaSKpky+msNJl5wNHubCJ45rYP1F9h02GQU
         /e3iI9bJfWUhlbDz+SgKxOWNpJRzNkc9jr3gNN2HPf4u6mmdR180vifs0yMbx+K/oMIF
         mZOA==
X-Forwarded-Encrypted: i=1; AKwUvBzMW4d1fvMxeGFyNIctCNwP1TW1Lig5XXff9eDwETJc7P08oGirsFhcAo79sDrjNJwUaRk1kmfKfw==@kvack.org
X-Gm-Message-State: AFq9FYIELQusd735pGsbycyXj6b7mdKj3HplrASelMo92N8ReNwKZPH8
	NILfcTqiNmNhW2Eug4soOYiuVJou/MRDnrUMGY5eX17LnORVpPqlDEA4
X-Gm-Gg: AYBFou1ujc0lNnmGPi4glggo/QBGsFgq5eVtUIV3AoJpLQnHprOuEbQyggyzDETDWAC
	LFG5d719RRikMn3oSQHRfRPZ2lPmTE3gyIxDeB/Do26ny/bKiEw4vKGA4ws6sI6L6XzwAbN1IWu
	1t7zxZSrggeTchoFK408EsHqsnlrXHwHdYogRKbLmM/FnadFa6BTDEEBSQ4pu4ImPmbCJ0nFpmc
	KBD7Bz/5jdA34sjEG3G7SJAHdbBXqNDoy8W/8ciZDzS9AwTDJLYi/KhjzF7ORgoNttJGwkjJ0ox
	CN/3WS7m3PGAyfKNlQ3Iel96UDZjarNywDkaq1MUCvRbr906Sk5ci0i4c761PhnzLuPyEs4kS2V
	LE1KdfmDHLpP/CcOo5FveMDwrrHN1LcCaMqoRH8Mz41EoKUKut1N3YsRJNSvcVDGp6Cg34UhxDu
	5wcER7k+aZHBTmpidE45JeunwuMw+v5YIiNzLXIyoBjU8OgNOPO0ttSLfPFTAjLZ91AcI=
X-Received: by 2002:a05:600d:8643:10b0:4a1:e00b:a10b with SMTP id 5b1f17b1804b1-4a1e00ba2fdmr28805675e9.7.1792313307895;
        Sun, 18 Oct 2026 01:48:27 -0700 (PDT)
Received: from [192.168.1.18] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1c10fe9d3sm248499795e9.13.2026.10.18.01.48.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Oct 2026 01:48:27 -0700 (PDT)
Message-ID: <6b17c6a5-5164-402f-8d97-2b25f4f9ae8d@gmail.com>
Date: Sun, 18 Oct 2026 10:48:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] kasan: fix runtime shadow page table synchronization
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Dan Williams
 <djbw@kernel.org>, linux-mm@kvack.org, kasan-dev@googlegroups.com,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, muchun.song@linux.dev
References: <20261018043501.3257632-1-songmuchun@bytedance.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261018043501.3257632-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 82ADC100004
X-Rspam-User: 
X-Stat-Signature: i58uxbm3yfx11ayq58z1cifazxhxyr93
X-HE-Tag: 1792313309-10912
X-HE-Meta: U2FsdGVkX192Vj1S7+LjFFf18IhG0Jr5Rrhg1r1aMeLiE2Az97HBBjSxjXtQua+cwZg7s3YWhwk008xMxNq8SgIDQc7QUuplJS/xub8y6W7KPyKaweU/fpTmNXjVhTs2fVIsj3AXGZLl/k8GyTsteggB+J3cq+zu32r0k5udhvW9jcruhJY9q7daMB1MbwBpXMbjl5VifcZHzMMPVT4TfDVQgku0WHFL2S/pkZ+6alMAa6IDX1Nw37neXyHEvzYFUOzJ2MF1r2A8Qx0jCjYcwJ5cn6fARmxMqw1sAzoSyWSk7Q7xCzECLarFICb9Bz6CjdQEFVyeV36Y2eDIOTTO1J/Uhky83K5KxSrcwkdOGlM0b2/9OZceepiw3xYVJuxiyTmQc8nPUwu3B+hqPIzcWe7zDUhDdVo6bNXwvB8fTKNVwdSdv3qSZofkepPCbJE0xW/JDUWW3H6TbYmevS3YI8ikBiVtIdjMSLcKYuaL/OrAJHztuIfwlotJxpx3w6idm4yhqQvrt5yFmhz98PLgXELKcytpdExsPp8BEV5iWMgM8o/tqC/42ijKP1XfX8NyWj/HNuR4Jyabl9s2yk0Q84w79Q7GB5pQGlflWdDu2zn/QDVHvHduj4LN0kTyC2Znf9Juhj+mnhr7wL1trwxw36UWTCuPKsCIqT53Bo5Wucxo4M0cjIXkfV5mQ0O3gbUiHPFpO+m535mkvVyOnmghJsVk0BVt94J1UcTK43ZkJtds27AvoP6UZXdT92vQwUyMJ9kGANgSU4WiKRaYdb2LDh5ngnjKKvx7ysO2rGBh5zQ2bbpRThgxAONUKMFdbwxqWX9H/jOmH6rM/DliXFYtIAMWnb9VCHTY75PhBLY/7NtjvLF9lOnvR45wFvq2GFg5VH9EvhcXnyvfMfLmeVpk32BtQRSmUKiSMtF2Vx7Y1ky8lFvO6DKvuWkXyy0XntvwD3dytxbqgmLcSngKwJq
 3ZLK6kWT
 mk1beoOjz7QJkNJjDdOF0Asg85JYEcvRByo5bXi+nLIO7lxbZt8UNnO+hX+ELUHkmqyay9PnE0cbvHFpGryssC5mYXv+2uHAOcOZErhuwK0z3r+2QAlnqkSpmm8M4/TJ1lF0B8TBWH1+5z1SKyWeX1P8CgesBVoNums/4g8v7sbS21nHvOzDqbWcX0vtijR3a4+8nMK5xRWqyBShqqENl+RcyziyyRRBGQVzDFea6SJNbMyG7+xmfJsscNeVpjdPyVRvkplEbcmPMRitzU4tyCInXDtJ39r+ClFQi3SGAw8JbY8mMLw8FIjx4BXhvkmkNiHtyRgJR2N5BvRfK3NdEXTq9ZxEFYlvf1VWugHvA3aKGGLlVjF5COzUGDAZs+PiuAQyGBafqxlqbvCIRV5+1gMcvY7NFVEtA9JXiBDYi0eQakqZfKgWzU8y1ElbMKbzgqSBq8RuHt0FyGHpU3/Ma/R4NGTPvK2ymQ+cXP74164w3nzjdtF+UPHMtCGe6+eclnf6J8bQgU0c1d2HeHOpC74Knd1VWBCJVWIwL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/18/26 6:35 AM, Muchun Song wrote:
> -		if (IS_ALIGNED(addr, PMD_SIZE) && end - addr >= PMD_SIZE) {
> +		if (IS_ALIGNED(addr, PMD_SIZE) && end - addr >= PMD_SIZE &&
> +		    pmd_none(*pmd)) {
>  			pmd_populate_kernel(&init_mm, pmd,
>  					lm_alias(kasan_early_shadow_pte));

what if the entry already points at the early shadow table? this walks
down into it then, which loongarch does on every boot.

[snip]

> -		zero_pmd_populate(pud, addr, next);
> +		ret = zero_pmd_populate(pud, addr, next, mask);
> +		if (ret)
> +			return ret;

isn't this a separate fix? it's not in the changelog.

[snip]

>  		if (kasan_pud_table(*p4d)) {
> +			if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_P4D_MODIFIED)
> +				continue;
> +

doesn't this leave the range on the zero shadow, which memory onlined
there later then keeps? would always allocating a table at the synced
level once slab is up avoid that?

-- 
cheers,
jose a. p-a

