Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A9D9C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 14:38:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFA896B00C9; Fri,  3 Jul 2026 10:38:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAB626B00CF; Fri,  3 Jul 2026 10:38:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A72E96B00D0; Fri,  3 Jul 2026 10:38:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 79AAC6B00C9
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 10:38:19 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0F9811C0CD6
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:38:19 +0000 (UTC)
X-FDA: 84947720718.14.DF9662F
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1D80C120002
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:38:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=e0wg0dLC;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783089497;
	b=7RZVs8raxHdBh3q2W+tQGrjmd0GIoM/3jgm+YGU4R+GiuouaRbRSmasm7nk6YqgxgK25FK
	yIuKxjWgLz9BHV9ZG/D12TDAP60aAYbzwKXHE6tqqq7eXsJpbJUYWBSt1Q4ZuQ1EEavDf2
	SjpI3dzkpOv3rhlXGXFFAioicaxoYEw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783089497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cYcKnRNBBATcFMmYjoa8x8AgbZncnZb+6A3fuAeXiUI=;
	b=l4RNwDuHNNc/HX1yHWCYLcKJGKr+ZlzQCYjVIIfSZeKqIuT8qnlPwnG3SymgWqetm845EN
	FTY69j+sA4Kh8e0fBrgtaqceadJpFTtuOfFcIv+65rVRffEru0OCsrmb+mDqjMvwat1tQf
	ENb3qTXORdq++lRteQTa4Y/BMe4lgho=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=e0wg0dLC;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-46cea75d96cso76622f8f.1
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 07:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783089496; x=1783694296; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cYcKnRNBBATcFMmYjoa8x8AgbZncnZb+6A3fuAeXiUI=;
        b=e0wg0dLCfUZFbHTjaFk5Pb9FBYJwxQ8E7KIgJo2ejMWU5Ict1SoxozugwjK+II8U7t
         W9tvNeFhR5soGRhRHHzicSsl545zUtjM7tOq9qR5CWNwi00lijHMVGbmJbAvQW4VoHab
         KNjxG9tjGdQzw+6HYKWOvwMOAUopnSnnRJ43a909ir0SdxT5uAIYgj5bvcqYYp4IWQxo
         AcFhw9oujRTKyhBSa6vzta19hVs3qnRurLFWkHc12+Ty/GkUM80jXOahNelU0JuhQlXm
         CITP15wJ69LeeXsE0l2CZzNQXme88xKho4N0kytQsSxuZb2l8uLB/tSJBYIzEydVU9rc
         I9vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783089496; x=1783694296;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cYcKnRNBBATcFMmYjoa8x8AgbZncnZb+6A3fuAeXiUI=;
        b=Sdh4/XNivIUPUTRQrFH0HcVl9THtFI6sXxWVyqUZrLDWnL+eAply0VHofgZTggCjBp
         EuFOH2L2v3m2hQUzuwG/xvNiMAPuf8Qc82lKO1uDXrJ3GdQ4ZqPF5DKofjt54NLCgAna
         7lV1gXGwdQtywv6nPnrq3oti3EWj53/0En8FSSqixHUMB4UOWezKdWyhxr3OgG0+Coyt
         Jg4Z4xk1eD8XEs+b3uM2CIU52zjSMeDwrcV4V7qkt+Oberv8KQEih1MCWWNW4TaAioIe
         wam36ZwwxAnqKRECVnmL6MALbiSyIH+CNCMXSLAlmVqYPc59G/q+LIWiYwQZnRCgUqWw
         Ms/A==
X-Forwarded-Encrypted: i=1; AHgh+RqyQ8ONFMZ0h3S5Zx9nTlBOU7wuaLx4At2IgaHs41Wh/96Tq9VH6u3koVRdE0V53k1DzIHy1A2rdg==@kvack.org
X-Gm-Message-State: AOJu0YwKXFAtZM/iuR90ZKWxAjlTSLNq3RBf7Sp5es4ZHh++wbG9hSPz
	DF20l3+c/7om4jWTrEXFEiAaGkmn8vogSOxV+i+7eQ9/G5uCk+66C+a64/nPAO+QmJ4=
X-Gm-Gg: AfdE7cnFHsZt8E86k02jjOiaFwn4onLug4gMwvcjjpl7jVPNvu/crx/zRQP+z8CJkCA
	TUJ+Dehx1JrKWGOR88ExsCGCFmkdCFgRLXKFutrvhvYJZlUzsr4solDJugwygjQJnIMPGhN14Dp
	ZJrmDQssxYIpBTgAtH0zEHzQsdq3AUYAJiF7CjHUOALcEIzdbVbUsJPp3X/k9QIFTbjYTWuaM2F
	8TIt0Q5X9rbuCtCTVomE9KIyLvZEsEknjj9YtKCdfrhf6nf8MM5PL+UtEKKj5enFtRsw539Si+6
	mRToX6sMbZpheiVYiRdv0tzL5RUJI/aYhYjhcT47zGMvSccQuknDOakgRdmO4YKziHNjS3XUQI0
	m3CNEo6dkzMZSwUJ1t6aKS3BxfOC1rLoBhcpH0fylo3hoTYxXDIgTjHMvEn9hmVyELoBGSL24yP
	FjrarU5mE=
X-Received: by 2002:a05:6000:310a:b0:474:2b24:8dcd with SMTP id ffacd0b85a97d-477554e264amr8372343f8f.0.1783089495690;
        Fri, 03 Jul 2026 07:38:15 -0700 (PDT)
Received: from ?IPV6:2001:1a48:8:903::e14? ([2001:1a48:8:903::e14])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-477db3db964sm17544462f8f.8.2026.07.03.07.38.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2026 07:38:15 -0700 (PDT)
Message-ID: <86a2b2ae-5c5a-418f-a944-4c8d179aede8@suse.com>
Date: Fri, 3 Jul 2026 16:38:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/30] mm: introduce and use vma_end_pgoff()
Content-Language: en-US
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>,
 Simon Schuster <schuster.simon@siemens-energy.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Ian Abbott <abbotti@mev.co.uk>,
 H Hartley Sweeten <hsweeten@visionengravers.com>,
 Lucas Stach <l.stach@pengutronix.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>,
 Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 Rob Clark <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov
 <lumag@kernel.org>, Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
 Thierry Reding <thierry.reding@kernel.org>,
 Mikko Perttunen <mperttunen@nvidia.com>,
 Jonathan Hunter <jonathanh@nvidia.com>,
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>,
 Ankit Agrawal <ankita@nvidia.com>, Alex Williamson <alex@shazbot.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Dan Williams <djbw@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, "Liam R . Howlett" <liam@infradead.org>,
 Matthew Wilcox <willy@infradead.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
 SeongJae Park <sj@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
 Hugh Dickins <hughd@google.com>, Mike Rapoport <rppt@kernel.org>,
 Kees Cook <kees@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
 freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
 kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-mm@kvack.org, iommu@lists.linux.dev, linux-perf-users@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
 damon@lists.linux.dev, Pedro Falcato <pfalcato@suse.de>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>
References: <cover.1782735110.git.ljs@kernel.org>
 <e379a1cb6a897126ad96e3a263fdb91d6c11f6cb.1782735110.git.ljs@kernel.org>
From: Vlastimil Babka <vbabka@suse.com>
Autocrypt: addr=vbabka@suse.com; keydata=
 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
 pYekxJujNeEDkUlky0Y=
In-Reply-To: <e379a1cb6a897126ad96e3a263fdb91d6c11f6cb.1782735110.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1D80C120002
X-Stat-Signature: boku9ogdz4ohqg8jd3rrs71th64uxdmu
X-Rspam-User: 
X-HE-Tag: 1783089496-892320
X-HE-Meta: U2FsdGVkX1+kTeHoOHpl5Cxplm7Usc9GZiSTWJe0ZbgT389oiLcX6vq2JO5eGCVQFhfVhSVJyOLqbZ8Aop8r9uzWmSO0KP9GPAt6yoLBVVvX+uZwGCyiu5muFOw+waHHSC67XeWBvexa3TLeksyyxNvZhfeVZ4XeiHSv94IUfzb3ActXHp28fb4nxY08IAvUlPu2jl4OHWkRr8TBdmkGuBZLpx7P826LFTBfY4YWh9bP5ghOaQBWPvvsTXY01nj3BVeePz0qALMJ305/gMlxIlhkCWag2Y1LxRsE5yHqlKuzgVY3RXxR19HovuuaFqDMvZ677gFkD9kUsBlEwyQaVvZ1woOqDyzjGMDXDQ/8uBl26X+n1cRjF+mZ0StFdvxbeavsa2ohEy50UCVETa27TK+1mPEcpceyNdyKASDmLFuSXkYczzcTeXRW0IgKdrtosMFQGxqZoQvW3mdSm8iVKkhUlTM9AVjGdWyOyaTvXYIIt3khYS/2+Q97A9C8mq2yypsMYwyRXsaeYA+41s6plxWRNRWMht9tzhx48ZYgCUDcs3xmA8heIorqqW6L1wwF+WyHMRST/OTp3QvWAbCQpsEhCTFmGS/RVhU8Exx/mQzSM3iNvHi/fgtAUBmWykbdbqoUehcahSB3Q24YQ8Ce/aQ3C2UkcnwW6/2s8JQf6ALvsYW0CNgKuMbMQTIEh1wUmBY8JlV7sbKBW8vM93EBUDgYmOyFSk6ggn7OEphrqIkkpEhQTFZsVOCBrAoSFIfCHYLukE+2FBddIGiHK6Rrl8MbMw9p4n6UMpkDX6rUsjtBfk0xwsJBdIENwtWMLqEiOfz+dbME/3YxOF6SkLwXJBh+eYLRCKaBtwLiVmdCqelZ2kOshP8nG7+rsuHiLznHR9eXrEeaYCtUNgGCGXSnHJHVMmdzpbE4Rg9GbeYMXrenl+Kh5LM62NtO3cPV0zDxvW3W0JlrNApP63ikQ9L
 oLULkiaC
 /W0iLyGiZf76MKFM9qA9p/aMvwn5pPUzen0LT9xEwqACOUUVw10NlI/gd/5zdq/c8jK7qLAnjNP3AGzdmSvIjkSba3RoSqzDYg9AYdmzocfy/NxJSj5NASUPMvDGPpLzRuhfqKCym1bofDgWwN3ImCGPsNN1OS7dKp1X4QwrNRJ4tKlLi2YlgEQFIrsh4jeKEJAhzrGeLbr9XLqFHSn1XDgs2XysP9vNIgzCfl3eaRtVji4f8jEHl5CJcHLrhbHA8E86MK/H6PSPMh8vHj6JJ8LIBwGfZDQuf3kWJcrw4tF4gkmfs+U3VR8yjrauQZZIJ5+WXErjCcPsU1HJM9UusLqpX/sAFxj2kLSlD6DEUCuMJtW2UEYCWK7LvaPcbnlILs/xkfF3AabgbsEFBC5sgDkqhLyfD6Gkn89VRFKug85DU/W8a0t6UUm5IDT/ddn1n1b+T8yEjquGgG8bUIi/VeIj+cZmlqkje8tBRzwWRsAdBSa6OmLhSB54AuOO7GB9SUFsB6FWlll1Q7Sw4ihJTkoDjhhV+SH7SNFOIi8r60MQv71o8EIHvgFJE4ajJqFxGRXYm9DWjXLCOXYTEcJEayPcRF8Vb1iRY6GC4Z1OrU0lPyx5KifvgmQcPXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 14:23, Lorenzo Stoakes wrote:
> We already have vma_last_pgoff() which retrieves the last page offset
> within a VMA.
> 
> However, code often wishes to span a page offset range, which requires the
> exclusive end of this range.
> 
> So provide this in vma_end_pgoff() and update vma_last_pgoff() to use this
> function.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


