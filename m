Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3431CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 07:17:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58FE66B040A; Tue,  2 Jun 2026 03:17:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 540026B040C; Tue,  2 Jun 2026 03:17:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42F116B040D; Tue,  2 Jun 2026 03:17:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 334506B040A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:17:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CFFD41A03E5
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:17:06 +0000 (UTC)
X-FDA: 84834116052.30.0D121F8
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9AA86A000F
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:17:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=blsR3lo0;
	spf=pass (imf25.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780384624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p50DgJ115/c2k9lCONJvF062SqeHxHHdcjhkSa/vml0=;
	b=Ml7rExeYXNacK2oPnL+GTBzS4DpQOh5ZMnhxtcIJUHdKgYIm1jrE0U8Vl4UaY5YXJJl4Wo
	XOa5f5zu94/veMR3O/Rg26cwxJx3H6QB3wFL3c3YdHbOxCvMe0db6NjR8VPZKHouN4BmsC
	lmCAZ6XJXZtfRAEVGjbkxJXzOUy2Kuc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=blsR3lo0;
	spf=pass (imf25.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780384624;
	b=RtxP5pMSpeMMD/cVhhmxLg5DJ5ITyEXYq9wg8Hq8X+tM5zssMZn1gnQJzqPwuWWh1ZPUso
	djHPAXHzEXd5NJWKRbsen91S/ZBOAx8BhLMVgdp/+NLfJ0Y9+NQdTIlpqX4VqveSwrtFCo
	w2emd4BK12L7OyiB3ykAIFkazlafib8=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-490b12270b3so3145525e9.1
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 00:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780384623; x=1780989423; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=p50DgJ115/c2k9lCONJvF062SqeHxHHdcjhkSa/vml0=;
        b=blsR3lo0Z3j89VGd4lKea80YBiAHH3hNbxJJAcGIjYy16U24fshn5AD8cY1o7OhFGE
         n6m7UFVJd2JZH5zTQTKsQLdfIR5u+0bIiQxu806JxLb+ia1fmySeky4b8YOFzqRwSe1Y
         uqXOqWq3TCGy+U2dOFAlsMgiHMy5kqj6rkgF0xpNq0eLnqNId7KrOoHmf86V6XO2tgwF
         l7vFTydq8hb0yk9fuOuSfajvSqHOgBO7xMO61lGfHizPKP+InDinIo4cEnkmkQbkxAGh
         g9u0skIQjG9O8uVMDM7mnenwf1nyCTp2OePmMjeX8hZjh6qkQJ92BxmHifQ05sGEiQu/
         Od8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780384623; x=1780989423;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p50DgJ115/c2k9lCONJvF062SqeHxHHdcjhkSa/vml0=;
        b=rPV0ZrVLI6Y7PIErftRk1rexXUgaZUUyhVKwMD6e/6gy05Uzra59it+C6NojWSZ2f3
         klIHVnofOtBqUUPxdsND5XHSOagHhvAx4KjzyHKyUnl909gZnC9OirhDdIo20wEvkV89
         3Rgmz5ypSa2m9TKMH8J1vxxKalqdTXhHqG1psqsKKbmH88jFmHDeZNw70aF+vOSWWazO
         W0SUTM7eBLCQsnQPb1nBKve5ChnoBo1k9CjvDL4cXxrA3UOcGYsbWuDrdU7IqJdGYDC7
         aKdW4wffmMhNRVuSu/SHWQ8qAIc+ZU09VpPUwPRcRQQ7ZajapGv4rmeuJP9RnC/iJ9IX
         MExQ==
X-Forwarded-Encrypted: i=1; AFNElJ+yIOq8uyAI4cuQDIrpcG5lLPUBoSLzTG+HL9jyqRCyRlL+UktdLdeNwrgs4Y5B8sUrra44Bl+sNw==@kvack.org
X-Gm-Message-State: AOJu0Yw3xu5+BEHssepRXlhqxAVbdRU7rRKowjBeTt+Hq2EOBXJwuC2x
	hoS/qOUTfoonOPdGOfkEbmrpPzwE9kg5t6n4x/ps4jG62SlgMm4CI+aBq8DOR8oSLwI=
X-Gm-Gg: Acq92OGO5X27w3MRtMmLyCeoujTDPDNhqI7L6/SSFqJzwbDFnBYoUb5tcyPNfPGGaYP
	/1VUF2lhRMdRuyTP+aD6aCieBdNRB7tMNknobFTgV3fUexApQfu+dAvW5A30gDOp0rkT1sgYRA5
	wyCT5ebnwon1Pb5JPGg4OgvxKVwiPMplQc7FcwMK7hgaJswan4QXXllNZy/KJy6BXnmHuWP+cIh
	XR0iUcrjbFI6GUc1zgKY+f2KFtUXPPu2GXhhmCzNGh1m4N39CU9TKyU7rjE27HrtxjFvIqEcQtk
	KLt2zJScJMZOrvhZWfv4oPXJ7qaL9bg8ZcLF+v86VavLo85lc27R0NprVX36vuE+HQsLryPLmgE
	9vdm6x7/9ytWx8ZbDhSZcxdl02t5qMrcXdFlOCOugHfBLS3oeL0+aBM+cC5crmxdTXu2UoTynvn
	DBCLxs9unNWAqG74G1/Dy3gxT7dlXR1huyOG1cYo6r4sJJLZo=
X-Received: by 2002:a05:600c:4755:b0:490:3cb4:f1b3 with SMTP id 5b1f17b1804b1-490a293322dmr249691305e9.16.1780384622865;
        Tue, 02 Jun 2026 00:17:02 -0700 (PDT)
Received: from localhost (109-81-85-133.rct.o2.cz. [109.81.85.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909c0e8c1bsm127891955e9.3.2026.06.02.00.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 00:17:02 -0700 (PDT)
Date: Tue, 2 Jun 2026 09:17:01 +0200
From: Michal Hocko <mhocko@suse.com>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Dennis Zhou <dennis@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
	akpm@linux-foundation.org, tj@kernel.org, cl@gentwo.org,
	vbabka@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	muchun.song@linux.dev, Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH 1/2] mm/percpu: Preserve NOFS/NOIO scope during chunk
 create and populate
Message-ID: <ah6DbTcuaNZX7mHv@tiehlicka>
References: <20260528132917.81123-1-kaitao.cheng@linux.dev>
 <20260528132917.81123-2-kaitao.cheng@linux.dev>
 <ahlameE6FBEZj_gt@pedro-suse.lan>
 <ahld5va1b9w8j659@pedro-suse.lan>
 <5a4aa532-77a0-436a-8f5e-1bbcf2db6bbb@linux.dev>
 <ahrm4x2ubbjs4An1@palisades.local>
 <e315d2a9-5069-4a8d-a0b5-7c0033ee46ba@linux.dev>
 <ah2pD468y1LCIe3G@tiehlicka>
 <7e913ba8-fa91-4916-a871-66de7c80cd29@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7e913ba8-fa91-4916-a871-66de7c80cd29@linux.dev>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9AA86A000F
X-Stat-Signature: yqjadg4n7yrciuchmyg865af1wg6xqqp
X-Rspam-User: 
X-HE-Tag: 1780384624-121168
X-HE-Meta: U2FsdGVkX18AKAtpdDIMcabrxEhyhXL8t2w/I1fDg/E8ndVcflSNt1a324Nnqp2lxdskndGJc4GmKlF5BWtV8MkDh8Zl7J3LafpnZOpW5yzybG6+YRrG5YL4VtIUoe4be4G2F1K42oHKyVb+SLJxqZaU44iV/YBjURF7KZTrZcX/8dykiSxwuVGL0BpNpoaXODm/M5eFUOLfJ/8ML/z3wMo15YnPzZiDxxdKCVnIbzr4TGewpWb3smc5gcmiSDrbizr+UsurWyXpNYTp/+v+EgJ6+sorRhZOkbI4+UQ4zno3qmpUJm8z9VI5VaDOj5g3WFwvie3pL9kpIblGagBZ2Lyz0JNZb9q5em+xZL5mxzvsQTQbnkG/NWM1wUHel1NZgZevppmnsB3PxVSQBsOKM0Z/WDCCyvggrNshGehlsOFxGpgOaBEoRSiYBTzpR9dBh7VXN63Z57+xeJwAa3NF0SLT4rxA0WWTeRh4vpZe3s6aaBnrrvOzFigf+wMThTVKy2Q8f0PJLY4CY0njcD/fUlmHdxEEdJXN7aoWwev5u23aslZ3ve9EIU84PcFToezwMWgiS8Ik658MFGsmjALwPWddr9SV96dQcIr+DEogKUzbC5dTo7ZfkHBzMvv/r4EPrewqqc0EesN5Z2lVHvCB8MJdsifDzMxlRAOwx+WBfe+xW/sITZZ2ayhwYlpmd8o1kkMWMzIqdCaziwORsZjmnKBxNpy+ELWvj+TrmYmQCKXccajvSsvXVe2xAVGSGkIY83vZLZELj07J9obcTkDxGDHle4d/dE8TSXTXIDOV37IyBYA9eELhmjmmw1L/5oV0TRa62gzfUtW03CST7dZwea0G+lzG4JNymEGraU6WwH/v6yICJ6WQnWCyNi8BNReZNmIiQuGCDDTTKfliJLqY/M+aC4w6cyCG57fRo9aiFJ1x/t3pfH6YOAHpTZhK7SYLaXD4TPW+Bh2VTvb9td4
 VVVAqLiz
 44edQCaoJpEC0NWgoBWzhMkUTdAi8+uZIHg0fvnWDuDe7BiBCfkQK3CN5DmQlvGpSm+2fCzomt/CYxL1IDKXpFT0BaBzK/Z2oxwXLkN/1TdPNWJxdW0OqRO6UOUd/JUvGnGaYQw0gUFD0QDxRgqyTegqEZqHZAqX0YoLRcXcXgunEjoykFwJaQA/yU/cUZXkh6LK187D5K5ewTFa3s8U8iJHsT5GC+x6dPQACsNAZmV5kv2LD8y82IO5vdIEb/Xsstt/eM4bAqI/68SAXPs62ZieWxd1u3/D91rD7JudwPxLDFsX4Jtz4iIJ1wWyaXTRoNZKY/HedWV0QmF8fvuyIRauN8vVdDo5GPz7MhsjklEWoomD2A+DK/JXfIyJDCN9sPB8q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 02-06-26 11:03:15, Kaitao Cheng wrote:
> 
> 
> 在 2026/6/1 23:45, Michal Hocko 写道:
> > On Mon 01-06-26 10:27:53, Kaitao Cheng wrote:
> >> However, if we revert 9a5b183941b, it seems that all of these issues would
> >> be resolved. The only downside is that the failure rate of pcpu_alloc_noprof()
> >> allocations may increase, which might be acceptable.
> > 
> > That has practical impact on some versions of iscsid which do not have
> > PR_SET_IO_FLUSHER. And maybe some more so I would rather not revert
> > based on a theoretical concerns which I believe is the case here. 
> > 
> 
> Based on the previous discussion, I think we have a way to address most
> of the concurrency issues around percpu allocation.
> 
> However, there still seems to be one remaining case that I do not yet
> have a good way to solve. For example:
> 
> Thread A calls pcpu_alloc_noprof() with GFP_KERNEL and takes
> pcpu_alloc_mutex. Since the internal allocation is not constrained by
> NOFS, it may enter FS reclaim while still holding pcpu_alloc_mutex,
> creating a dependency like:
> 
> pcpu_alloc_mutex -> fs_reclaim -> FS lock
> At the same time, Thread B may already hold an FS lock and then call
> pcpu_alloc_noprof() with GFP_NOFS. It will try to acquire
> pcpu_alloc_mutex and block, creating the reverse dependency:
> 
> FS lock -> pcpu_alloc_mutex
> This can still form a potential deadlock cycle.

Correct.

> Does anyone have a good suggestion for how to handle this remaining case?
> Or should we simply treat all GFP_KERNEL/GFP_NOFS allocation behavior in
> pcpu_alloc_noprof() as GFP_NOIO?

Yes, weakening the reclaim context would work around these dependencies.
This seems like a viable option as long as pcp allocations are not in
latency sensitive paths and stalling them under memory pressure is
acceptable. My insight into pcp allocator users is very limited so I
cannot really make any judgment call here.

-- 
Michal Hocko
SUSE Labs

