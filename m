Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A86FCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:18:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 946F66B0419; Mon,  1 Jun 2026 11:18:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91CF56B041B; Mon,  1 Jun 2026 11:18:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 832DC6B041C; Mon,  1 Jun 2026 11:18:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 722056B0419
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:18:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D79E2A0703
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:18:38 +0000 (UTC)
X-FDA: 84831700716.14.0C5380B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 08F80180011
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:18:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kkEUr0V2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780327117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yhxL+B3rXnmSX8NjuKL0+DcKMdJRNJScwbLF3k0f+w8=;
	b=aV17BqcByXsZI4gt4+bkk6LQLqJ5fw30pw6hSNVLX3mAPg/Itc/wXNUms4/HG8bH+/kFYk
	WXD7SvuNRpP83DsZAqCuSv3v8SuUOt+L5j9xMnRuC+tNny4keY8fytvsYAlqpNbjpceya5
	X6kseKdWukP+Jtk5qW7/4z+0oHuY3kI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kkEUr0V2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780327117;
	b=T90RTThhjNwyz8F94R1UzuqksSpAUEULD2hWxcKzGihlyPgnvWukslUFFM1rE2quK2QRTC
	gMFU9hnZUhmpRYzT85atFSNuPhMcqUimRxxA97zsVaubolR88SyWu6Sbqizw6/LYQXXU8a
	N8JLghwZipHKPLa7gb2UIw/GSE0+R6c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 40BDA40390;
	Mon,  1 Jun 2026 15:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA571F00893;
	Mon,  1 Jun 2026 15:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780327116;
	bh=yhxL+B3rXnmSX8NjuKL0+DcKMdJRNJScwbLF3k0f+w8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kkEUr0V2AJ5aUGWJ26qqBkKoYbIpl2CCC8o2o4j6N/sz44UQpInGQVv4BIqoCQ11U
	 gYvTeEixjtD+8nzuAq6QWSQmjq5Z/p/rvhUWNxT6ghrOKtjANCo9iDfhy2x6Ou1tiv
	 kDrCakI6oJafF9c81M6kHSTgFgKjF8MowAdFEhvxx72jbhdw8G/6s2mU+EnECIy0Ae
	 JkqZzYkqzGJ4PL0yN9qch4lNMI9r1PD3XiLs4tjFRLdlT7m+kjSIQYSUhrcQYuWkS3
	 71xnV+IduTRjWWEJDymDT0UcjqeYXlAt8Og0c97zCv+YK0UMPuMp/j6BqR6RX2/AlU
	 e8spk9T4PYU1w==
Message-ID: <a730328f-7bf9-4424-8e83-01a67e72950d@kernel.org>
Date: Mon, 1 Jun 2026 17:18:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] drivers/char/mem: eliminate unnecessary use of
 success_hook
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <cover.1779462249.git.ljs@kernel.org>
 <5d1e8bd29d6e070218ba7a03461df562e372b91e.1779462249.git.ljs@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <5d1e8bd29d6e070218ba7a03461df562e372b91e.1779462249.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: r4gbyeuyyhxezqtkjgj79c7owb33i36p
X-Rspamd-Queue-Id: 08F80180011
X-HE-Tag: 1780327116-52663
X-HE-Meta: U2FsdGVkX192ZrKBkI6OhaHk3H3Ym+U/XxlF6CwhW4nOL68Vi0sWh1GebWoyT2hff8KRZEDZzCZ6LzDn+7SUNKlfoFJIiMlGy44Is/YCzi4fBtYbjd5e1NRa9VyJiPykFogK+Iksuue//HRl6pyNLQlCvMKs0N+5vt4m8JFTCsZGsyksYIJEj/lF0/KjIlpuMWiPwk6d4f653Lm8cnD9I/m7KU8Q1+aB1bnNOmnqG2hEzAm3L3EGJ7sluwizg8PJh7FGG1mmu0Ty3RXbe7QFQYSYEEoyT5kkwyaIxUJAgmLgWz0NTLzbnqhC23T4dLiGScC4AfFuAyJFJdzPJjayp10hiPpenxh/B1lYe3IYiKsEl5f12qq+P6zPPYOJok1WnqFwIYeXWZcob2FD5VJ7/pRHu2Lny8t8t3zKWSHfuLhUeOPahUyqznRXz+gphJOk/f6r3qXbmz79vF4V6inDZN0bwsx2S702RyzSOZM1hsIbT33i6uPzdmP4U3kHb+8bQelpvNzFyVHfrT4Q/HIzHLa84a/9Is3NN1TslhmYYYzjY6/1xi/mJK5LLNHudLuOqX7yrIuddseirx5a8tSlMBtq5qUvMGN5u9Mkg0Q6Y99o5C2Ps2aUbpQsY9mw7eAZovdbX0FRBgdObg7bQoVop1ODuaCvE/zaHKJwjDCLJ4NS2TmVxeTersqSyB5DffMmbjL6oRVmHcOZOkgC3olB1j8N92U1h4+Z/a8b9N1BdcDjNjbhAGlcnFmfNP1VyGLKh1ltAl6JQUIVKUxVvR1pJK1BB/WtkhuhTXg+ZJjdJDbY1aDiPpJMBZzzYm5gSIzFMOm/cKoATGYLrm2kn3kmYCUZBOPhVSdndJoQjQETb1kw9JLkk7CdBDNxOfBUQNNjlOzAfgnRPXZDkVWz8zppB8JcRNFPzfLBtM094Qtw8Px3XqD1QFyaXEXtA61ilC9NltddH6ts4Yl3a4AQpEN
 Zgag3hx1
 MXPxPVSfPsxjQKnfUH7ksUmF6/WqWhkMqY57qhUVIJyPTOCkHcVgmdgvWTPGV7RMMgxzCt7TBtQSqG7t891jEx8pDxHi16IEGvpyKHFmpg0naSg4IsHK8KPngIiOV9Mpg9Z6CT/DVNOPjCiPuxW6cRcRV6wsv+GdXfarT73XOtPzQskuBWAsy+J0jBc5lzglMdsA7TImXPWk7d9ClZ4MJvdnPOHXHG2xeL5L/Q59+lBenLUDPHV31SPOglYMl0ybHa8h9Xn8Yk6o9svnjt4RR24gM5FnydCkbqPHV8z0/qQuAXWQOf4ZwaRzJI+cgKLm/MmSkW5oLVw9cRss=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/22/26 18:00, Lorenzo Stoakes wrote:
> /dev/zero, uniquely, marks memory mapped there as anonymous. This is
> currently achieved using the mmap_action->success_hook.
> 
> However this hook circumvents the abstraction of VMA initialisation so it's
> preferable to do things a different way.
> 
> To achieve this, this patch firstly defaults the VMA descriptor's vm_ops
> field to the dummy VMA operations, which is what file-backed VMAs default
> this field to.
> 
> That way, we can detect whether a driver sets this field to NULL in order
> to mark it anonymous.
> 
> We then introduce vma_desc_set_anonymous() to do this explicitly, and
> invoke it in mmap_zero_prepare().
> 
> This way, any driver which does not explicitly set desc->vm_ops, retains
> the dummy vm_ops as they would previously.
> 
> We also update set_vma_user_defined_fields() to make clear that we are
> either setting vma->vm_ops to what is provided by the driver (or defaulting
> to dummy_vm_ops if not set), or setting the VMA anonymous.
> 
> This lays the groundwork for removing the success hook.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---

Looks good

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

