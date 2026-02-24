Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05250EFB7EB
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 02:58:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F2CA6B0088; Mon, 23 Feb 2026 21:58:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A0326B0089; Mon, 23 Feb 2026 21:58:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A2776B008A; Mon, 23 Feb 2026 21:58:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 155616B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 21:58:01 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A1B06B925D
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:58:00 +0000 (UTC)
X-FDA: 84477840720.18.6D6F0BE
Received: from mail-ed1-f66.google.com (mail-ed1-f66.google.com [209.85.208.66])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8BEFB10000E
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:57:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=R6ww9mt6;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.66 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771901878;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FLzgA1VpSKBM/CA/w+qS/GgqnqDkMavIXnIRIWRQ7uA=;
	b=KGzjXQxSHF/yc16/xY7n7IuPeagCazg/+wAskqlDmhvKaDCT/6xT3QUbu0/BSO+jZhelz+
	9xetGLPPZxbq8oeycGaBMHWmcxxXA0M4cA8vZk/Tcf0vZYPoVKLBFZvYN6Bhm7a04dyVEN
	cg5rG311m4xGiBNzqRqIH1kAnKkmOvw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771901878; a=rsa-sha256;
	cv=none;
	b=Ijn+JFkk5VBoBq5l52+umwl6NK/TJ7XHTbf//FGrL4JdKpb8YXTTqcNj+MAKk5JoPpe46u
	ygRyuoJj4/9uAEIKoDQ5apQiUw7DjH5BeRjvzvIeDJ3J/Lud4rHl3c7VKDL7lWfbsyKMeZ
	TOnSpO3t286vGLRb8A9+LojnP7FcoC4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=R6ww9mt6;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.66 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f66.google.com with SMTP id 4fb4d7f45d1cf-65bebcbffe8so9477989a12.1
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:57:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771901877; x=1772506677; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FLzgA1VpSKBM/CA/w+qS/GgqnqDkMavIXnIRIWRQ7uA=;
        b=R6ww9mt6gt+PAR4W3wEUHIpyBpk88ViblpPCcic71j3F1K18+sz0FPkCbIwVf18bwB
         MNg3ZiAWjHqKYtPc3vC1AMR7+w9c5KCkG2+N+5VZD09rJRu3RlvEu/iRed7g1cVt73b9
         9OkUpuxI12lmb2qhqxr/p0euElCo5KSDxqXQikMf90TLpExRQB0lPEOeBexvGEO9GK1I
         aEBFTvRM8v1myFaxNKyMq3oQOLTwDYN8wi0g+3yBWZwptFqUAi7luf6A88h/WwcK15tO
         izlyYF0M71EPqKcYXK8sPnWeNE4OlSJI+S3H2DEJOaYpNrawuJZB6i3kH0X8AHJrdjtX
         WVhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771901877; x=1772506677;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FLzgA1VpSKBM/CA/w+qS/GgqnqDkMavIXnIRIWRQ7uA=;
        b=TEEEVcCVi59cPPlbrasAo3wHAGowU1eD1kI/s51TsdDV/5C4L1d/Zffg4Ib5m6f9c9
         OyAT15CMiedd6jp/OuDXb3gJ6Y64FitT0u/HJQhd1lylQyhTURLQbxLBl55Qvz9UuxBW
         rDyuG+peybn9S5d4tA+h3OlyBf0v5NyAOaorVxlf+tR0MPh0HerZJZInskKIPJC4eMyr
         iK/C9lZ/S/O3NpCOyL66QcJpDtjzcztIFqtq5lrYs5PezicN/qiwZgIFfvk/FKj74Ofb
         NAk9lqZbbsKoHdGC4ZRF1zXi+Zuf0e7bJnNfuB+dKOixxl/KP7WqKnB+I4Oe8L6fSoeW
         3LjA==
X-Forwarded-Encrypted: i=1; AJvYcCW48f/Bfe/YdKD4hQbFBg5yKFAJ88zY1Ni1U0R72dIqsYi+sA61f59Je4zPPbBqEgyV3Gge1muS0w==@kvack.org
X-Gm-Message-State: AOJu0YzZUSepgp5RON9iD25qU6/U5Sv3umgWIXEqDThzqKvp+P++Y4ho
	jBv4LnEDkJbL8N9L0pvcA0a0o6unCTfWSzsrTVpKdIQg8je8oYWPnIGb
X-Gm-Gg: ATEYQzx6NzH0SmAGI5eaWj41+Why7+sahChGCS59A/NmA2PN96ViZ1jESWyzQTm/SNe
	1ARsqnhagMY3pudU0r2+LWskss8jNBnfC+sCz5Ih5KSER1YZ/cRn9epn7f8Ug3cE+ygPBuXjUx2
	mwTwtmNzseuflbLQ4xU13Aw0EaQZLemdI9BcomhOfF94NltPGP83CU0SyzymNCiyzfgfYQMAI5B
	wH1PRsaAaLWyyW/LtqkWfsXli8wdA/KPP02HIxcKXrvIT1FvdIHYXhgug2BVpoMzyxBWaLs+EPI
	c/dWZyztqg3zvZZRrg87ttyb0lDNP+d0oVBhz8hHH0PAvVkLb9eQ+Gd7UOxOooVrrcIZ0gkLqXl
	7+BZyxqk9O3sMp4GRBdWTFzhChjJyeXgZ8yNjqeXwKa+wvns9SSIJyGcE92fUABWq5DXKRt/1DU
	LvvMA6FptiXiYJiRDTtmuBEg==
X-Received: by 2002:a05:6402:40d1:b0:658:e665:766c with SMTP id 4fb4d7f45d1cf-65ea4ed18e0mr5724958a12.8.1771901876946;
        Mon, 23 Feb 2026 18:57:56 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-65eaba13871sm3195624a12.22.2026.02.23.18.57.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 23 Feb 2026 18:57:55 -0800 (PST)
Date: Tue, 24 Feb 2026 02:57:54 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	"David Hildenbrand (Arm)" <david@kernel.org>, will@kernel.org,
	aneesh.kumar@kernel.org, peterz@infradead.org, npiggin@gmail.com
Subject: Re: [PATCH] mm/mmu_gather: define RCU version tlb_remove_table_one()
 in CONFIG_MMU_GATHER_RCU_TABLE_FREE
Message-ID: <20260224025754.z3g6sbq2huuk6fwo@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260222004512.839-1-richard.weiyang@gmail.com>
 <f44fac08-771f-4619-b8a4-6ea740df424f@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f44fac08-771f-4619-b8a4-6ea740df424f@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Stat-Signature: yf1i8tmjqkods4ep4yq6ok6yt7tpghdb
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8BEFB10000E
X-HE-Tag: 1771901878-561238
X-HE-Meta: U2FsdGVkX18cKxxwIB4X/HTH5QcGpNW/dTkjgpZ6q31E9dq3A9aC9u/ef1cSpSD25pt4npq8lfBXcUEg8i+kS5+ZruJPzCxtAQCMM7FZ5b2y2jJAJ9TzcU/h6XPjkl2K9jP0vGr+c/NUKGfsRZ8z3ozXGwzMzULhxQHX9hUpSk87NB7a1m20Va2n+qMc6rplDViqofbYAKrOKd5wMrskb0ze29g9bRTCO58OZBb32Qu73FactF60mYyCNKi/Dt+pUqfnjpMt0sutuwYVSJeXPsTp0/wZSFV27TUz3WQLQfd881jbZEo4c5YOdP0LNAKgtGlRXi6IfOFWYRbCDZW/tQGpuACHbw2Gc5JJcfAhBFYWUxeloUpEA33ZlQ81cvcIc/7XFF8OwgBoWfcYGhDCG7BG7SBI/xtP0EsCPTyCZJe6i3VpiYhMMrnQqjjZRW/xjUaoougVNnt/B0olO9kf3sIcfR3YY5qBkicu9B3dFolAHFlKt6ygF219SYxrnSefiYAJq6DIJSyQ50PmxRQhxbtbjhtbr0GqobCSKSJuzPZe+Im+haaIBTV0Un0VYX+4IkCVI2Q9YoZritPceuDXRjxpRhdLDG/yJVpHOibIbTnspPOP7vFmXUlCgfKVhyacQAW7hlKWV2/CA7Xc9TCid28GNsBlPlZRRSNQX0geDW4Y5J/cSvVeWv/bHS4kNXCDta41m/QRJD+NauwsnnzBxusnsoY1xR5Av5w/debKV+bMNYWchzVGzP1+iOEBlMQQkH9LybJQPm/1f+kuTvE1sZD+GSLJTQB2iLMzVoJheRwSljBrMrd7QIagm6g0sYthMc3Rf+kCrSeT8rWnn0lQaAPz79autw++yMVGGxq5JlaerISTs3NUiBxH3b9hiMsWWVglPmoUYIt0kJG4EGAxoXpzBUuId/flZAq4tOK8zhOhx4F7T5MMcXtJJXuTzu8/PMXOJ2D/tFWGLS9UHgy
 SMgzlg/h
 XnucyVLs/d1P+akcG4m5UeALLNH3OKVZ4q3MK197YEI9jcxU2vFHoCjFAnuCn7Swkdce07BaFVcVXR/dAmA20TgL6Udi9MFZAdYwBwg6Y4o4HPd6A4yX1MAhfEF83OP+TMJzgOj75QhvRIGUBDA3fS908atwqXwA7QQag3D3iQIzEfcpZ29GEsTKlS8oRzAcimi6RbyvlN9SIjlANXkSyWilLaAnU96PZKbc4C8V/uFkI4Oei1pRtZyDnm80tH5JNSO644TWMXyfbl8oynJUyiRALhbhoxcPI+9kum6+0iaSDMRM6Sknvj3XLHlK/V4Ztjd2oDDgn28QL0uJFIQmsBktS+xhpZlBPoMt1bZvAQsqFJAGqVeGERqatxocKVtTqD05ZYdXMZbVaEWuPLVy5We/Pvl9/FijVPtPF76LVgX4Qv5yiPrUv2HFNm1W7FlZF9mYQjXd7Lqr/jiGMVe/OkXovhMD0fT/rqsDXhE56H5otLOXplw8kAklItTVqgfhKCYvHR7UwhaGqEo+WyAa1Pso8ZLEFqu8QMitACnCbVaEGPBD+PisSQrAG+ChK74T7IEEwLcZGpHgCVu8UhdjqubOKPvmElkh4m2SORX1qZoxIKLTsb25e4InrJ/P+xitbjtclYE43QqQ8snFwtQTm4AAXN8TsbWbO7KhXx/9PJDWZGtv55oedIDZrGdHhtuMFLts2eqsgvlxW+Wn01yqjw352zeHbG5GSClVB523U0W9+Kkj1RX2mPpzP9oqzA96Q4JF0+TPDSC0d8sPArSYA9WY7RqwizzGudL6ERY+s+ARzfZfkne135hoqEfR5SrWmMCd3L2bCd2XdJai70LEqCzTSN9fKRAvk8TGTq/OatEClAbY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 10:09:18AM +0800, Qi Zheng wrote:
>Hi Wei,
>
>On 2/22/26 8:45 AM, Wei Yang wrote:
>> Before commit 718b13861d22 ("x86: mm: free page table pages by RCU
>> instead of semi RCU"), the page table pages will be freed by semi RCU,
>> that is:
>> 
>>    - batch table freeing: asynchronous free by RCU
>>    - single table freeing: IPI + synchronous free
>> 
>> This commit introduce a RCU version for single table freeing to support
>> PT_RECLAIM. While it is not necessary to limit the RCU version only in
>> CONFIG_PT_RECLAIM. It is reasonable to asynchronous free single table by
>> RCU if CONFIG_MMU_GATHER_RCU_TABLE_FREE.
>> 
>> This patch moves the definition of single table freeing in
>> CONFIG_MMU_GATHER_RCU_TABLE_FREE, so we have both RCU version
>> batch/single table freeing if CONFIG_MMU_GATHER_RCU_TABLE_FREE.
>
>Thank you for doing this, but we can't do it right now.
>
>See the latest version: https://github.com/torvalds/linux/commit/9c8c02df3f8742f6db927e787ab971fd0b5ac08a,
>when the
>HAVE_ARCH_TLB_REMOVE_TABLE is selected, the pt_rcu_head member
>cannot be used.
>

Thanks for point out. Don't notice the latest change.

Andrew,

Sorry for the bothering. Please drop this one.

-- 
Wei Yang
Help you, Help me

