Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93AA3C55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 15:18:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9547C6B009D; Mon,  3 Aug 2026 11:18:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92C1D6B009F; Mon,  3 Aug 2026 11:18:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 869216B00A0; Mon,  3 Aug 2026 11:18:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6090A6B009D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:18:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BE6031C1083
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:18:41 +0000 (UTC)
X-FDA: 85060315242.19.61F317D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2A572100005
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:18:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zj8N5Lnc;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785770320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rnoRC8MENm6FOG7GtLgXFwQMWUgLDKOzq6eHxm1QfVw=;
	b=eIHNkYJvo9LNwYjXfWTKuinwA0C1v+t1tOvyCyMbAt0obCrN3NIHgdBy0ZgWZbrYv/8hr5
	ljV5upaza6OqNNTBwCOX+yenNMY/KxiQPG9qfJz7VQEtC/3QiUDGl+tV17LeQjRM1Gu/Qu
	umbSt9mOslea3bKVJRerO5CEQ97Pbb8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785770320;
	b=64SiZqzlmoCwOc9FAMSQXv7np6rLkAmNu9nGv+UxZ6rQiUu1znVHpUH0vrGhnGHbFL+SrG
	/n45RqAvnfnVCyeErp6U3wszC+HmpcJYMX08MklnQhSjZWWmSb4rvL7AKb3Gi1hyUznvBE
	3FeEZJwL4bAkqP457+8ganYK/qmoik8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zj8N5Lnc;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B636418E1;
	Mon,  3 Aug 2026 15:18:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE3F1F000E9;
	Mon,  3 Aug 2026 15:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785770319;
	bh=rnoRC8MENm6FOG7GtLgXFwQMWUgLDKOzq6eHxm1QfVw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Zj8N5LncJ9Cjbu5XMUCTq1EhJhO/AiPzFyqHNFzurkJUr47GtQ8m3HDkp/l8XHzes
	 FGMJRMrN9FyA92yn+PFyKoqj/mrhsy/Iajaa5GNiDtTwOkiUJbwchR4AHQQWqVF3g5
	 en/QFdBK+yasIVGbbGNIhuA4rjEYaGmTmGtEq0KoTIYE9++darnOSgxgdJqiVQRHxo
	 DiOeV8Q7XFw5K2iBu12P22D/8JPKW3Z6qH5986svjYvLka7KFcv6a1pKcMwvH3QmOC
	 kc1uPhXrkHSJ3KbSByUeKoWyYAhkxPqmvrkkRB7xAv9tKVzeUSY1qW5ljgDEK0eI7N
	 NP/d/uEJF32mw==
Date: Mon, 3 Aug 2026 16:18:21 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, x86@kernel.org, 
	linux-arm-kernel@lists.infradead.org, surenb@google.com, liam@infradead.org, vbabka@kernel.org, 
	shakeel.butt@linux.dev, david@kernel.org, linux-kernel@vger.kernel.org, 
	zhanghongru@xiaomi.com, willy@infradead.org, zhangbo56@xiaomi.com
Subject: Re: [RFC PATCH v1 1/2] x86/mm: use VMA lock for kernel faults on
 user addresses
Message-ID: <anCu3DOrXDeMrwi5@lucifer>
References: <20260802074018.73887-1-baohua@kernel.org>
 <20260802074018.73887-2-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260802074018.73887-2-baohua@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2A572100005
X-Stat-Signature: whxqmm319gy4h8rc3pezskpnd4rm7bii
X-Rspam-User: 
X-HE-Tag: 1785770320-236727
X-HE-Meta: U2FsdGVkX1+KdQ2oQwumEU157RIR32wEZJ8j2n8LhaIm2jZmZTPmuCyoyJA5cbjSy6mmnXXLxAtod1TgUwwtr7GeONpsUIyPtIdE2iOZ6ILVlX4VEv0E2WG0EVmSRlcdVT52A4ZvZojfT5jVcwFt/59thNvciCU5y14gm/Bdo4XrW+oX/Lq6+ycQEwcplp43B4LnU98SzGyTJT5M2aBU6l+QSMYliJuZobzRR5XoKg/fIpOSMSzMrz50TdSmzqm0PGj90UA7UFcvxT7RaYfcaDx9kPPFFBiPj5J3Sev2wXpcwQV8FKRxKWneSV5V8h1CQ8pQ/O0SSZVUAXto5W3XUY1f0BGoVoPpU7x78ZkHurFp9NYg3fwsB/oo01DS84mzrzQOaozRvQpQOv3KFeuPlf0A0tcHQ3sPS3hy5KUB/kRB2j6EbuaGosTimKe8dEl+yHEAakcfeXXRQNclOJvP5Z4jey9WXsMIqLBoE6KSUsgJRjajAJzFFnWfAmMQ+KdB4nZrNxJTk+H3vxENBJC8RrY7gXabt/bgQiK5SsHqPi5r3EijYjLcTmmaKrxB8inkcxwjxS89GTab3lwPM7sO5Gbs9Kg6pqxNxzHVAwMycjwVXn9piP3EtJ8muPfxHq1//fGNcqFVzKNFot79Gn+drFXnf2tyyJ/GjiOmXJdpZbDV+MIQUr19T05O7zslVdzbdPE1T5KRwIUe5dSalzJDYbOVUA6DJHcUFEIhmjMQvqoa08AJkPDfADnANTCEOcQRCUNpqiX9T01FxurZLm8VgryfB/mKSSUkYWHNMzoEnqlwJK+yRG2+k09Kbp/eRNeq4STZYBmd5ekiTxQ/8cx9TsdD9MLdi+m0fMsToMl/QXqcO7+uFY5WdQXFDS3xogZJL30hrfW0gqtbvft6rvX8fNnkNAAUEkYWPayLcdQE20gxeylXzswBmv/cIXw9vU0vXUU5AoxgtFxwZLX0wpP
 dbCbdHqu
 nkVGb+EeyM8t4E6XtaQ+I8/m46Enj7jzKcX58ik9MHWLiZiPA6jyWFOjjBukeEm+BmjdI7N/Q/kLSzA9rBbna4PoYSVDd1KKu5J6o32+BSF194uAyZ6v/sWbR1uG2ATUrrJTXzOQX4QosEtKCL5FFGECVoeC4u+uRYO19PXPqABow7F6m8Xx3weLlfz99KyNoOVB/SryeDBtyyyRLdXZwa3TzQpsv9ayCLK9S4n0OBz4XemXJ/703tF1sOCYjKdbBkU6u7bGIguOGs+3KvaA+ei1I3H/5u2EGhvlZK0/715p+cOk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 02, 2026 at 03:40:17PM +0800, Barry Song (Xiaomi) wrote:
> Use the VMA lock for kernel faults on user addresses. This also
> makes the existing code below meaningful:
>
>   /* Quick path to respond to signals */
>   if (fault_signal_pending(fault, regs)) {
>           if (!user_mode(regs))
>                   kernelmode_fixup_or_oops(regs, error_code, address,
>                                            SIGBUS, BUS_ADRERR,
>                                            ARCH_DEFAULT_PKEY);
>           return;
>   }

Hmm yeah :)

Bit weird it uses user_mode(regs) and the early exit uses the just-set
'flags & FAULT_FLAG_USER' too.

Some horrible duplication here too... the user_mod_regs() etc. code is just
duplicated in the mmap lock path.

I think you mentioned it on Suren/Dave's series but vma_start_read_unlocked()
would avoid all this and could lead to a nicely red patch.

>
> Right now, the code above is dead because !user_mode always
> takes the mmap_lock path.
>
> Co-developed-by: Bo Zhang <zhangbo56@xiaomi.com>
> Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  arch/x86/mm/fault.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 45b99c3b1442..c22b74e0eeaf 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -1328,9 +1328,6 @@ void do_user_addr_fault(struct pt_regs *regs,
>  	}
>  #endif
>
> -	if (!(flags & FAULT_FLAG_USER))
> -		goto lock_mmap;
> -

I'm not sure why kernel faults of userland memory were excluded initially
(Suren?)

Given that it's OK to take the mmap lock here and we're necessarily in process
context anyway surely it's OK to take the VMA lock?

It looks fine to me but want Suren's input.

Also given vma_start_read_unlocked() is coming maybe that's better for a
cleanup.

And finally - Willy is working on a grand clean up of this stuff _I think_ so
you probably should coordinate with him also?

>  	vma = lock_vma_under_rcu(mm, address);
>  	if (!vma)
>  		goto lock_mmap;
> --
> 2.39.3 (Apple Git-146)
>

--
Cheers, Lorenzo

