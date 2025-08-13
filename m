Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5946FCA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 08:14:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1990900045; Wed, 13 Aug 2025 04:14:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC87D900044; Wed, 13 Aug 2025 04:14:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6A37900045; Wed, 13 Aug 2025 04:14:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9244C8E01B6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 04:14:16 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6D7691402A2
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:07:12 +0000 (UTC)
X-FDA: 83771003904.28.B9F964E
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf02.hostedemail.com (Postfix) with ESMTP id 74E2A8000D
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:07:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Jvd4weYr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755072430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=maMRjoqJXCK/+GFkp6ApW3O21rIqKnM3FTWwDItdMGw=;
	b=X+3mO/ZL3jZxRJTTSX1tori9b93cccg1niPenNeCgYWM2l2SOYWFyFEKx6byO/2JiHNdvh
	iuONLMaz4bmYf3TMzQ9hopgA+8tDriVW9B5F/T05RbEuLmOPfq7v0NzWub7TIbDX2kafb9
	+MrW1FsX/kVY4Q5FvJWikW7nTJUsdcQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Jvd4weYr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755072430; a=rsa-sha256;
	cv=none;
	b=x6SecC5JIUSajk3r+Wjl2OhgJHjMcewetJ6Y4ckFQLvbyA/g17JrKevXm46puYW2McnwXK
	FXBnE+hfmBQ/kvRW1cDozhBFvLn+8qWjIh6FX/Ws4b4e5fCNOa57kfZeeS2YjxUWxihGQ1
	y6ZeUJwU5VoAJOwSv/pL7BXRl29QnRs=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3b78127c5d1so4099792f8f.3
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 01:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755072429; x=1755677229; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=maMRjoqJXCK/+GFkp6ApW3O21rIqKnM3FTWwDItdMGw=;
        b=Jvd4weYrqMnZADcBPbW1I0cbaOTg4FLN8RglX/BB6oU3dOrmcDYdD/xwdIeZf3OCVw
         e6r6Q6XZA9pzOWhdO88e39ZuVHNMWzVonclkFBYhJyEfkEA5kOpqAX82AMve72s/kbzq
         LFblBIS6LuOeWCVYuqdTnlJcUtVP6ao9SlhHklx1sMNPYxxe37nCRX2ifXCjiqd0vZ7r
         1ToCAealjXZv0xcQjduPGdifuzquhZF0E+0iHeoJVg/0JNQ1Nz5gm9uJuOLyXC7RbF9O
         E41cQsf0FvTrDF83231M6PYkfaboEPqb3UHyjZzpOKoPdjt8BUB7AW7qfUnGL8jVRlIk
         NuCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755072429; x=1755677229;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=maMRjoqJXCK/+GFkp6ApW3O21rIqKnM3FTWwDItdMGw=;
        b=dbxno/5AsgsBDXgTsC2z5myygaPwDZYkaPvPgROmdKVGsvUNiqmU3TntxdTwyu/qCn
         eKZU52iOMzg0DZMZWkVkApBgIvPlYChjArqnh0AXABDiU+cS7aX0Gow8R8AvxjYNGJq1
         JhNQ+f2cvFOAbuDGl82FmCUioEY8DT/Hm8B89H/03RkIEK0J3bGrr9DGngo34Ok4I1Lj
         xoZeybgPMdXanhXX727fSj21Eb30Xf7N3R5vXE9lXTu4Adve0y0ckltpohGdok13PCou
         mOMhZ2zuW9YdZgonjITXyoR/QxjGJm83EhDsrYwluNFPMgOieb9dWmizqTJeSJUkgRTP
         ISLA==
X-Forwarded-Encrypted: i=1; AJvYcCVUwg8WGJlH637Wnq0UMzuAXzF2VL1Q8qQWa5aEygWKBuBldB1shy+7418+yqK7OGr2aoBy+7BloA==@kvack.org
X-Gm-Message-State: AOJu0YwpHD7ikgZy9+Md3xASGRvurGq7ZSGVDrugYpOHk6rmPz5ndB94
	Mj94heORw3VAfyp6qmyL/vkhzvRuevLCNn6XUaovO1NTbuipPpbVZKap
X-Gm-Gg: ASbGnctJJrKMhuiIvDbHa5VHdmWQm18TYr5caGkRTr20k4vtTYv8wmIAn/J5i2bxKE+
	gJLeovgYh1/Xjan/lQaGqb3wOmjYlfdF8oyBkWKhQQN+0/5GcgfyYwQNhf1Jiogj/m0f9hJN3+5
	lBtApCIYGTDO9cMNZHQ6+VeIUXB7U6HN9t0uvZdqS9xmaYk4p1uU41EZh/mHiPzjTsFdHoF0US/
	zyuJD5SQjWLpgvGQUSEwtsGlaWe+tjUiASj7+5lSthEspuXE8BDUrNhDXv4OK/SPsWns0TnX60J
	eWrzFRIPpSoPMFXLtf6n2rIDajneJc9zcxvhpqAN+wFV3pyK1M+7UCIn+SK/q/5Cuy6Qm+VHI8z
	99YR/YKwRqu8csoBZ4fgCDRsZzLk2SaTHGWheCmENlTSOeASelaxv6Qapf+xZTrNhsXIgfdeOs+
	4pFNdEkNHUwWLVTP9ydpKP
X-Google-Smtp-Source: AGHT+IG21U8BYsNzqLWav/ytlWcEyoyWQmL1EXaTaANw9uatg14wjY4T/4or/U27usDsLhFE+I8vug==
X-Received: by 2002:a5d:584e:0:b0:3b7:dd87:d730 with SMTP id ffacd0b85a97d-3b917ed493bmr1488118f8f.52.1755072428736;
        Wed, 13 Aug 2025 01:07:08 -0700 (PDT)
Received: from ?IPV6:2a02:6b6f:e759:7e00:8b4:7c1f:c64:2a4? ([2a02:6b6f:e759:7e00:8b4:7c1f:c64:2a4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c48105csm47122956f8f.64.2025.08.13.01.07.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Aug 2025 01:07:07 -0700 (PDT)
Message-ID: <d3d1b812-066a-4124-83ca-df96fa75e3b1@gmail.com>
Date: Wed, 13 Aug 2025 09:07:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/6] prctl: extend PR_SET_THP_DISABLE to only provide
 THPs when advised
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@redhat.com,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, corbet@lwn.net,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org,
 baohua@kernel.org, shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 vbabka@suse.cz, jannh@google.com, Arnd Bergmann <arnd@arndb.de>,
 sj@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kernel-team@meta.com
References: <20250804154317.1648084-1-usamaarif642@gmail.com>
 <0f8b7e64-d08b-44d6-8a1b-2b4b8d64cbe6@lucifer.local>
Content-Language: en-US
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <0f8b7e64-d08b-44d6-8a1b-2b4b8d64cbe6@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 74E2A8000D
X-Stat-Signature: 6z43ne8c9ni1bxjtn49cmu9yjabra4bn
X-Rspam-User: 
X-HE-Tag: 1755072430-154848
X-HE-Meta: U2FsdGVkX1/Ad1uooYx800ldad7/C62Ns9GLwy2NweC2o0q4CtBTtapexMg76Ws8FgCVDIhuhwWmgGRu7mDY/qOmh8jOmfLSwPh4BT76JE8Dr/kM+80EwWB440zj+ezFxe6iCntmFhDu2/YnHYJA4/QnCNbNVMfowJBpUIIYXNrjcBAbFeTdzuKhZtqy6C9EQYqgvLaxjcfLVqdun6DPHr2pSvH9lOf0GXoJ4Vz6zs3yEDr+kGfA3IhTVmRn7N43EDEPXeAfaKn6xDCN4z8xK7OuUUPZAeRd5VhBiRRmaWqi9TmYBmh/8w4+C3LZDYpXNDROZfZvgeLtYk3MaAlTtESXGjgHCLK/6XxLc9wcX+hovy4uKuXZaRMVkpsjVMjLzdg6DftadaCH1Zna2QmGB5wM/lltnNG+N5zVcyzeTHyJYhELSykt6rVsXpQkhaqYyUc69nlOVqbpNFb9tsMPah+DcczBtQwWiG4gEtIZUTZ0znJDutMErcIr3L2M9XKNlubpaVm406LbxmsAnLJJ4Zf/fm4tjQKQiiDA7vQDVvrVYZWd+DiE4FiA+SahlME64mOvRQeRXE+uu71AU6LHZC9K8L8Zpc1JgJK+G996LImo19lzg2mkGjHMdw3fFeEv/zUpnvza0z/ozlQ/CsmEQhqX94WgqEctA3pK5+mFPPA6tCO7iBGCD1Ci4+EcR/fceCE1l2Q1fW65edwe3WFgDCYSDLvF8eBoZmQto3cra43hu50NS9lNy/J+t0QEFV00J1oCGPGKTf39Cyjld9xvzEmrpKGKyTEMZzRD/U89x94rkP5wNTwWc87tC636R62sgpJE6DS+dHmPVAEFgeyTa5jnW58QsQGBZSGEGFijutli4B/ivxZHz+6MHVP8hbtAxiX/pC4UsIFG4e53ZCPaX4LFF4pA271urOpKRcp7VZ0Cuy8Ykq2amdzFm0MFbtVgE2faSTXFWyabB2X4yce
 HfibXEM0
 HvCsJDlfjbZjZMWgmQNpUeUxceodGo1MDUnF36Oo+UpjC2RrnlAqe8lLSli3pc79YHoQmEovWQsmaO6UN3vTlV2zXTuD/hjFhOjMeLzoVjRkXJ9O7Ig+KNSnD12iJPGuoDEYTbp7yUBcSnd9am0oaExaizjdmeyO9Seh1sTeUGhrf0a95m7N6KoD0yaqhyXliEk8wykNxVq9S9bQph4BJoy+hlEM3AujY+8Z2yLsK44Wt9JTuN1Cc4lX7xHLROW+YY5FbZG/cKW17c6XRS3YjpUgU16nh+Z/yBb4xOAUBjRAqdC2RrRU2dHNljks0ezGmGVwP9d5URype3Lr2t86kM98OEGTgpq/wrbmBmX0vB10a5WeNr6JFr6ORMNNJIUtbi5tTiYpXZszlmKHWdkUc/8B9mc5nHjnW2mVZ8TBnFqx65K9GrTbDQeKPjpKLq3XBcszZm61ThUivCDRR9IwlLIceWd9YNyY1u/Y5TDxz2EGYgpj96iE3U+8oKizXTIzeK5AAuJzprHhp5a68Pwp4QMq/bRq1/LM6yrmanMxcYB+McNsB1Zx5NkwCj41IEJX5n+vsob82uXSp+cygThptbql2gdfivPhqTdVW/rGIExpsjArJtiZT7tP/Hwaoxrmbn2XyxzYPUeajugBzWQYiBAnFIdvwxwNQDh5n
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 13/08/2025 07:06, Lorenzo Stoakes wrote:
> Usama - did we plan another respin here? I ask as not in mm-new.
> 

Yes, I have the changes ready since last week, was just waiting for a respin of
the selftest cleanup series that David mentioned in [1], but I dont see it
in the mailing list. I will just do the cleanup in my series and send it.


> Also heads up, my mm flags series will break this one, so if you're
> respinning, please make sure to use the mm flag helpers described in [0].

Sounds good, Thanks for the heads up!

I do see this in mm-new, so will just send the next revision today tested
on latest mm-new.


> 
> It's really simple, you just do:
> 
> mm_flags_test(MMF_xxx, mm) instead of test_bit(MMF_xxx, &mm->flags)
> mm_flags_set(MMF_xxx, mm) instead of set_bit(MMF_xxx, &mm->flags)
> mm_flags_clear(MMF_xxx, mm) instead of clear_bit(MMF_xxx, &mm->flags)
> 
> So should be very quick to fixup.
> 
> Sorry about that, but should be super simple to sort out.
> 
> Cheers, Lorenzo
> 
> [0]: https://lore.kernel.org/linux-mm/cover.1755012943.git.lorenzo.stoakes@oracle.com/
[1] https://lore.kernel.org/all/eec7e868-a61f-41ed-a8ef-7ff80548089f@redhat.com/



