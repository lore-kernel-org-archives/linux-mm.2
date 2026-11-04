Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFEC5606A329
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 23:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WiTq1lLc
Received: by kanga.kvack.org (Postfix)
	id B21D36B00EF; Wed,  4 Nov 2026 18:15:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD3596B05B0; Wed,  4 Nov 2026 18:15:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C1BF6B05B1; Wed,  4 Nov 2026 18:15:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FD156B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:15:44 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E5327A8624
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:15:43 +0000 (UTC)
X-FDA: 85398995766.21.E480296
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf03.hostedemail.com (Postfix) with ESMTP id 050EF2000E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:15:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=WiTq1lLc;
	spf=pass (imf03.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793834142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jw1A1CrCQXufCGBVmtCdk6Ioy3GBOtyXllOzk3wnD2c=;
	b=aScIjTLPsqVMKR+uKJDqtSVMaY9CTrqf0M6bWgHM/u3fVyVKpcgxBCe6eN3nudCP66fD6k
	tDgX36uf2pGqp4+9PEE8mQ2ThAhtVydUfT9symTrlCqTrxJdZ87pO2atSN4NHbWqM8uK+c
	k46WHjP8JUnmpnnwMYnHyxbbsJzhy4Y=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=WiTq1lLc;
	spf=pass (imf03.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793834142;
	b=3LbDtUk7E8uGc4ja13v4KHPKYJtuW9mqDWBnlD28Xuv8j+8WxTv8PZ9YhoCTBwQG5jzHsV
	AlTMTbe1c6sptzHHdbaySlEquprc1WiBDOkxKIWBtbh+Zyk2qW8dOX5BADGaL+p+xw9fER
	uuuCyfow8VgcsPTl9mVu+HDRVmde+Uo=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a2069b9710so11494145e9.2
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 15:15:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793834140; x=1794438940; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Jw1A1CrCQXufCGBVmtCdk6Ioy3GBOtyXllOzk3wnD2c=;
        b=WiTq1lLcPSdIOCKnnj5X/O0S4moH3tvzFJfqoevfiAYf+CVwKAcLsNB0Kxuphp9lK4
         +2NLkdmOc5MJcyiJ44+clkDN6fXxo/uZo0ZY6Ekd2JBj1fYA0WDAhMrpaOY6S68wqO+9
         iTephhjGgBt6B5/6lTgj4uB9Gug2MrXP8iMlQotsyN2/1rXddmPzIm30xJp90RwlyLnB
         DbgibRFvOQL+EQs5uBvofZGwXu1sWG/HQ2+BThi683X59KvBIvBTX/pS2d287NDHYcuh
         YRhnehMFMmAs8JhEKu64VzWHthfNtFLVZjqJwBki4I3z/qmOVhpAeLu+Ty+UUGIeT/C1
         gD+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793834140; x=1794438940;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Jw1A1CrCQXufCGBVmtCdk6Ioy3GBOtyXllOzk3wnD2c=;
        b=ITHbkoqXtBYiTITLQqMpHdy9xU/zOdodIllp0bFtWFQNhhdWgzkdpAo24v6clGfL8E
         vlpc1jtDnT3mcGQFodYAjNAUqCWQfXtEuG7WiNYyivYpLe4h7AOevqngncF1/cGXqyqM
         PDtOhljRifvlaRSJBGbdXJ29or+8paULomPDuQjOLXn/shvAd3qAJ076JSVezhGptay1
         yDK/a/oUUjvgC260Yn3mOXrziYecGOOOmrtMSINEQw0ZyTkE0buK5lnlRefAzD6BCu6C
         +8nErZ67Ar+QQ5Hto1kGvQtCEO6+3ByieOhWjLsol7/dxjMvxMB5yQxFDr6q6K5HO/Mb
         PvcQ==
X-Forwarded-Encrypted: i=1; AKwUvBwWD4idIi2eu5eAyI8Jc5BZ62Le/dc9GLhC2HKlbHhdkJmy/bJ1wcF0h/If8K7ywMIWMDOvXkEKAQ==@kvack.org
X-Gm-Message-State: APuU4Z/09fGLRUWXmtILlkGl+0hb2izre7gbkBn3fEC0uW3X6AV6gFdA
	aAKuFCzU4vbMDsw+Ul3vyeBm9gMGgAHO1ITgnAs9RHTEgM23xKcbgCuY
X-Gm-Gg: AYBFou1TOZwIZXaKUfdbKBNbiyKKesnKHxPfv9LuE50DVQm7T0LNt1WI+GQDyqwcNxB
	lkpJIjZNGFtzA8uMMLfqaKhaeiWMDuDeXYhgsjV6LIdSloPHGlT6iwPWsYjCl5sjGrouiDcs+KC
	0oR4BFSX88KbD3FgmTC4JPdeznQK87lAFnzXn3FYCFyBMCnCtxzrFCDqZ62qgUFuXT8Sz8maAik
	8fao3xX1GoNjeXH2hN6lJTriPAB3UFgvao63o5Tqd7wSfjghCUNnbNvCwpBJvA/SPvy0A7otvts
	AZ+YVsbXxc3GmMsnnSeQIjh+K6H+7+5TEmVQKISmwFmHbeJHP27BTIq5W07AQ1jGbp0eDXuowj4
	HJChd3bsbx8HKpqz+oPO34AXgp8rtpg9n8s6q0v1QAonB/lPRgT0Wq7vZvpa85fauPDcepj1T5r
	hDKFq9AnD8flj8kdUZ/MB959jbjqMCJuHehov61PC/ShKzmNxo/XK1TmGGxnRobpgdlPfe8U4n4
	1KF39DPVxtvWox+RVdvtVyDQIrM+AW6etMqbq2iDITB9xelLNQxjhHiKuQRU2+GQHex6hRu4sHi
	37PT3iaLilHnNJAfh9EGQ0M=
X-Received: by 2002:a05:600c:3f0a:b0:4a1:d8fc:8165 with SMTP id 5b1f17b1804b1-4b3c3545341mr83410955e9.20.1793834140542;
        Wed, 04 Nov 2026 15:15:40 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48feda20567sm6769827f8f.51.2026.11.04.15.15.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 15:15:40 -0800 (PST)
Message-ID: <ad6e93c7-203e-470f-804b-fbf7ac9890f2@gmail.com>
Date: Thu, 5 Nov 2026 00:15:38 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/4] selftests/mm: test fork of PMD-mapped shmem THPs
To: Konstantin Khorenko <khorenko@virtuozzo.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org,
 =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan <shuah@kernel.org>,
 linux-kselftest@vger.kernel.org, dri-devel@lists.freedesktop.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
References: <20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-0-c56d0d26f970@virtuozzo.com>
 <20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-4-c56d0d26f970@virtuozzo.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-4-c56d0d26f970@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1z35wppgneskgarbi3pwgnrhfdki6px6
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 050EF2000E
X-HE-Tag: 1793834141-416996
X-HE-Meta: U2FsdGVkX1+GAOfAa7bRkyovaz4h9ZMNgnLzHV0JwtlGaNvSZXsHsGcr/zIrLqjbfsyBMruygwWfXmLc9FDnVT2bewE//8KTQaODfxq7lVEB5c2JRh1yGUaXbSoAaOoKzU65BaS5KxP2f+ZQnbkR8XtKgQG2LASEt+YVjoaQh51XhOPBhAEUgZ0ksnD+YyI8M4Xiy5mVFtl9OJgbtoG1cSNRcmc0xQsBhrSWJwupygyd7imzGeFkdUyCH82f3G1gFjaL44yNx3DLiQVQs/5R16aTCNOxazHesf1AlbMVTvLIU189BUP6yD1Y5x4tDOqqrQDdurNqz8pbCGg7bkxPazOAHMh0rh4m0l9uzvLhO5YNYMj0VSWUKroT2S7zWXx6akLh1hazEH1KEKBKx3ZWam6DcxGHKeuUrh2C4N52MjfdEXnYos5I+T7F7IeFgszDQYuAfN6jjRceRZmFzxcgfOK0QXI7Dn3VjTCo1A2SsvT0TQk82rp+/gm2In9QoiqqPLjR6NtyRcARHPJhdVv4a7nYceQYZpnDL6zWQjdC1obKJPmYVolbJn+bKxB4eJtVofGOURNHlpmYserTOFcmrnjEiFI1ljZc2vyBJrdMaBVj8OaSGlvhMRKfISgMhX1uHBMMeql2k2VuO9QlLsaNmDeQ4TocU8MknAphF89z9ImNIBEm/trZ3SdAvTvMS0ppMvcTm2aO1ETypNvIsfC2AO6QAFTKtIikt/rQXHzQaZTRO/n1LA1f9xWsmJdCkAL8jYBPkopYjRs1yGPTf31R5DlHwNBWhl19qcr90XWGe4ZFLdARXOm+qFFbTAI9pEBAK2zvsURlSzKwPAxQ/Yet5LD8uJffaH7oql96IIo/qBxutO0blA7vhg2lVrPBttiu1BsmNSbos7arRdh3dSuJ6M9DveSqzqLOoYd7OIUPqKgW07jQe8inrXlYrDNzhdvPZc3ejJBlGqq6H4Zjd98
 /47ECM10
 HS5yUqjgaYyCFTxQ1mkyDZ9P0btHHaTzOkBeWtXrvLJtqB0gBpMAzqSmtrK55ykF+qiurfzYjpIssSySAHfrYCnAc82YlgAVas4vGi/JpjF6pzw2qUnzwaGlNzonPgO4Y5ZdKR+c7b2YXOc7e9B3L1JPXwhJvkaJsBIq2wPxIHb0NGq5IODThVxr1gzoHSI1o4NV9FjtnVPTPdVOlYZU+7Bck3Zqp2jyNquKDC00VfI421iZwSe5NmaKiHERG965skwhckFBp+9A5IqzV2Kj9PH8x66zt10C+AW5FLHZE4s/gzgXPsCshGg+Wk+C17i1X1E2F8cUsqeY1O9mVAfABUVlFXotCyadvKCKjt2yhy/Oq7gkh+hVP00mb6sZ4S5yOo2zFjIBeWJ7E5X5K97MT4rGYg5VhvjTkXXigUEqvgKMn3u/ua9lu2I6MDkYQhmUPBMYOPUMPDAF/0Kox2QHzAJNj0ZN21oQ3rlrHyoFbPU5CVlh+IcVK+MqublKga+OPP/2MG8oY2gj3HzM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/4/26 9:40 PM, Konstantin Khorenko wrote:
> +	pmdsize = read_pmd_pagesize();

read_pmd_pagesize() is pmd_psize() in mm-new since 5d123bb07b18
("kselftest: mm: rename read_pmd_pagesize() to pmd_psize()"), so this
won't build there, will it?

-- 
cheers,
jose a. p-a

