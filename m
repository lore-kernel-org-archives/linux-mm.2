Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC69CC5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:08:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF73B6B0191; Tue, 18 Aug 2026 10:08:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECEFB6B0195; Tue, 18 Aug 2026 10:08:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0C7D6B0197; Tue, 18 Aug 2026 10:08:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B3AEE6B0191
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:08:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3486D1402A8
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:08:24 +0000 (UTC)
X-FDA: 85114570128.01.97EA758
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5C46F20008
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:08:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=K5aA0OE4;
	spf=pass (imf31.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787062102;
	b=DCOFQRyzfoinSJCIhKq8vjFlr9atCddoVTQbVcRkvwYxgAPgv5kcdZC+6SAPKJQKd4OopN
	IMjjMjqyyvDdQGJHz3IUj/jfkm/HPtq5jTATMVbC5HQmyYXqH6r+jiSg6i6U2exaPQmDCW
	uS5mhvhDYEtmil36avDhVIaY0yO3Otg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=K5aA0OE4;
	spf=pass (imf31.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787062102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MIbU6RCAysXGTpiqsbxIiRINbcDHCsMbZAd9JSG5n84=;
	b=T6y5UAYEksLQq9dp/6nl8RLhbjZMEM/gawkR/bxmmjb1fp3Biv/IYzBIpeyAeaBqynsukf
	v0NivKKhfSMFVMl9SlemAGYhTarboL3mhpQj7PQ5aOxa+ODY9cEmY0UUalKdOEYMzo3xUb
	CHAIq2uZGT0CoiR5/JIWyOPoGvsFpcQ=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4953de5be0aso37616085e9.0
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787062101; x=1787666901; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MIbU6RCAysXGTpiqsbxIiRINbcDHCsMbZAd9JSG5n84=;
        b=K5aA0OE4sQx1Ne5sdSYEGAag1qidnRduTCnCTRselrPRiYMD3tBCZ4oZ/FLU0wVxUO
         mVh31tOZsdCH6z1+negtVYrZ6REvZ6uzygACoFWOkbpIdPtp3HA21rveqCH4JflU/4S0
         fLoh9AZWa7UgE+FEVDcbha39F3GUPZbItaYnv5pDR5eabW8jPFT+OSugD1KBXeVgwDBQ
         VWEyLgHJv3yEnpBniaSAWU+Mse6OA965XGS0t2D5APMy7tObqIJufbGmxxgVpVKvAriB
         jTCJfjdWML3SMYQCrqeCv8nUbXjXWQbGIyPzhd9zw7M4/a3pjav8s98sfW7O6Hk1HZ98
         F55w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787062101; x=1787666901;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MIbU6RCAysXGTpiqsbxIiRINbcDHCsMbZAd9JSG5n84=;
        b=r9mFn0mIiV8uALo/2xM1JAlhPNItIK0zeUpjmSGxSaWRmoRbqAyf6DdtlvszLHlAvc
         SlkQxaVurwoyepHWaTLLTlXxf4NYbExM6/pM7999lnknGQ+Wk9xGFrsd9pf9RTqOf2X5
         LGjNdukB0wMNM/DRSWgHCZKFzJHrNNG14sBFHEfg7vHOc8AddjL8DOTUkCa9JJiCKi64
         8L/QaOM9FgLt7SLBR1YTqTH7/FonKTN/R9Ujycohgb675C2ANY4LvXvSmmQSp/3uaDxd
         V0Zsc0RBUltZSMdX0bBkiGViI+zs968FWUD+QO3Wd2heObhDbrUuPb6L772D+8dUqgzg
         UE8Q==
X-Gm-Message-State: AOJu0YxonpecgVMBXlZzwhyLp3G+G/pwtG09O7oHQKuYjI1q6jGKOBM3
	AkIFifmi1aRcBe8gvV8ZSHVBAq//wTbmtFnllG8ci42kPc0WQNPux+alJTMUSAsa/w8=
X-Gm-Gg: AR+sD12voMeCg/Kgo/a02qIol/B59yHkTwLncVHl5FpcWae0n0PajFRy1yK77+DnVK7
	LVCibpITtX7vQ7bPmvbCH6elINwv+7a+fs1KC7wcwrOMBlhFjKtR8W1K6LbYl1FSpN86uKsED12
	MdtmbBrzIFLuPgHGz6/QvvAIy73DY00wuLQXeEH/N3kjphCZSWOhgYdLJxCkcOjl+32PlB6EkiD
	2WIzH6P4qHQj+Be7xzUixbHPJPtDkuk//mio04ts+5e0TrJoSKqQFggiplla94AQRVAxMnXUIGE
	sV1f4TfN1KQyfFIq5z3YOkJrgx3S9XqrW+S5eD/vGxCFLqmDcemg3E+NfE1u5Ffx1joSRg2BcG9
	hJa//IFV8CZrZJk9z4G2C+pxFSTwlWIynbzyKDo0qcCYMSi0vL0lkex13XnfAigOJX2b9hIJyEP
	Q3QVkjK9TTRTBCfKjzkrgjB5S1g1x14GEe1xMdMBZKGUVjBVKpWsH2PFxb5MAv3Tcw5JNAn9rtx
	A==
X-Received: by 2002:a05:600c:828c:b0:495:3da3:beb with SMTP id 5b1f17b1804b1-49989345963mr567071855e9.10.1787062100854;
        Tue, 18 Aug 2026 07:08:20 -0700 (PDT)
Received: from localhost (109-81-87-166.rct.o2.cz. [109.81.87.166])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49996100184sm300612795e9.1.2026.08.18.07.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 07:08:20 -0700 (PDT)
Date: Tue, 18 Aug 2026 16:08:19 +0200
From: Michal Hocko <mhocko@suse.com>
To: Leon Hwang <leon.hwang@linux.dev>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-kernel@vger.kernel.org, Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH] mm: add cond_resched() to free_pud_range()
Message-ID: <aoRnUxUlgf_kRlm8@tiehlicka>
References: <20260818134934.92354-1-leon.hwang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818134934.92354-1-leon.hwang@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5C46F20008
X-Stat-Signature: d1ykx3ns3iqdswi7rorsok5hz9jdrftp
X-HE-Tag: 1787062102-970669
X-HE-Meta: U2FsdGVkX1/Fxnk+30B2NR5h8q4NZi9ditfMwK13ugyyitbzGJ49hBYtoNcBMZttwofp1FI2OHXKuZr9LU0k8i+uLsI9/E4Rv5od4zh7iFu+4dewvca+4Vim59qNoVVLHb7NaOnsNwdSfxEOhCUskVW4wqDa9q0k5qBqiVHNyl93Svhetvb2akZEsBYKa7yKMyUx1+T2eCCsbZ0e2jfb0CxR8pr1xYU/3DkBW4p6kvoiK6hrzzTKjZ75XT0naL4pSxBbj2z/XeJlSkuuMiNOBQ9gWakl5F5sW48IX3wKdStg7EtA0JZr6EKSOYffxQG808RKv3MfEOC3hI1okVhMWYIF3XclRrWwy871A/X3D60BmBFueQb6TQYQ1XoGPrKM8GKU+LvKAknM3OFtjkpTFm8rorXRvu9Sw6M7CWkc0xSoM1M4d9UsvZ40mFdujyTcViZZGWVfjzcwHm3pHYGLtZRGpW2cjq3T/udrFEQKlkp7sqdaW2NcLIHRQxaEHLZrAJs/5nq1hLW6OwPeXvVZKd49o9LoUpmxxeQssNzSYA9+NPU15qocUfLmNRC6tbQ5j+FC5YW86U2OPIamPOJXORPImFHTe7NB9qFkwbwZiXk5/iF1m5VfeuJbmJO0D8io9gKBGmQQUDSfFFLmnkT7/H8htlzPCOaw5ERb6EaTIRHlSBM6EWP3YGOndD7TafyrHgeIAzjLDfC3guzjDw/QdNS/drJXJq+SdPNa1DLN3BYW8nm4FQuyvxh9JCW9VGamxnZecW98gC15vZARVK0ljqzzlTlle2HJSsHlFZj+x5tLj9Uvo5iZ5XFD+Dx1TVukaC0zWRSOuWoGkkmxwxBclPapD8kji7ZYcIaASrr6UFVQy9UeOkwbhzkyCmVtwDzBDeiMKwHp8RZjRM0MSPpkhLe4O3MuAIL6ePDNG3SUZt0tNmEeTDaROqs0+Bjs5823UTEwsGXJy7FlBrEW4bZ
 AkADo5ii
 JLpuOzhW53Frp2BwmyUtKg+ccTdfBq8A18ZXBu/5+Ec4KQpMWfu8xoCna11N7xaOfmwhg6z2XEOZeUAHPheKg75Vu19WlJY9UkQP1HVQc/hs1cuOKzCqTRsCR9lBU7WccgBu3Hs0R64fIbdS5a1Bxahufd3lynNSksC4UFK6QyImfsc0KF3On0Y71mI8Cr3yPEIVZpo0KW5hwhtAWVVirJ8RlmzCxS712VnnxXbt+nAbmHeydhaRicd7HfXF/Lmx3sZHg+FWQaXPwBefACc8iNjsVrZSM5dzgYZPV2B5jRIDSG8ZoWQcvY41oOAEmc+wgys2bE46vfxsAvTA7H+qwmnVCbq6EssHLuF7DB3LiR924tcFJN2UrXeoc4XCMjtJESvkfilmwOtz/77i7n0MAbNARtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 18-08-26 21:49:34, Leon Hwang wrote:
> Packet receive timeouts were seen in production. Tracing showed that an
> exiting process with a sparse 2.5 TiB mapping could remain in kernel
> context for over 20 ms without reaching a scheduling point while
> freeing PTE page-table pages. Hard IRQs could still be handled, but the
> per-CPU ksoftirqd thread and other runnable tasks could not run during
> that interval, delaying NET_RX softirq work queued to ksoftirqd.
> 
> Like zap_pud_range(), add cond_resched() to free_pud_range() so
> ksoftirqd and other runnable tasks can run between PUD entries. Testing
> with PREEMPT_NONE showed that the maximum interval between scheduling
> points fell from over 20 ms to below 2 ms.

PREEMPT_NONE is effectivelly dead and most cond_resched will/should be
removed. Is there any reason why you are not using full preemption when
requiring low latencies?

> Reported-by: Lance Yang <lance.yang@linux.dev>
> Tested-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
> ---
>  mm/memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 4134ac607ee0..68c15449de07 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -231,7 +231,7 @@ static inline void free_pud_range(struct mmu_gather *tlb, p4d_t *p4d,
>  		if (pud_none_or_clear_bad(pud))
>  			continue;
>  		free_pmd_range(tlb, pud, addr, next, floor, ceiling);
> -	} while (pud++, addr = next, addr != end);
> +	} while (pud++, cond_resched(), addr = next, addr != end);
>  
>  	start &= P4D_MASK;
>  	if (start < floor)
> -- 
> 2.55.0

-- 
Michal Hocko
SUSE Labs

