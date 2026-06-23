Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAC7BCDB47D
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 10:53:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 869926B0099; Tue, 23 Jun 2026 06:53:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 841226B009B; Tue, 23 Jun 2026 06:53:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7596F6B009D; Tue, 23 Jun 2026 06:53:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B5056B0099
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:53:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C9C698E110
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:53:49 +0000 (UTC)
X-FDA: 84910866978.01.AAEBF29
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf01.hostedemail.com (Postfix) with ESMTP id F382F40004
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:53:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ur9HtJUO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3umU6agkKCMc6n4705nu7t11tyr.p1zyv07A-zzx8npx.14t@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3umU6agkKCMc6n4705nu7t11tyr.p1zyv07A-zzx8npx.14t@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782212028;
	b=Y25R3AfYWYb35G2Q8/NjO/+Snk0ryDQ8knTG7m+I7luQDOW2Y8vP5nC1bvDRm/vO/2iEdf
	RGlfb4x20OXXMIdS4bb3VkiP/RpRwuGazdMUH1pP4bfUa17aPpCBvuG1CBKucLPxNSVEoA
	hQcHlZrpZ6FZHHyZ6XgpffcL96KxfvI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782212028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Duz8Zx+8AiYnCdBwNjKZl5RmXQ31zXqUNM7RLp7vFfQ=;
	b=DC2j9wO8h3Nsa3lzSQ45MNeo2lF7U8IT+4FE1aeh2AGDmWFBKVGqAYx08OK91iVROHqFBu
	DOeviGF/4CYcOec96lOp4QKBSo+wj6BuUmSoVa+o4UHZoC4hrpC7PHafk3GeHFic7am8wY
	AzEeWp44o7YjZh3+rJP/kCEkDpFxjJ4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ur9HtJUO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3umU6agkKCMc6n4705nu7t11tyr.p1zyv07A-zzx8npx.14t@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3umU6agkKCMc6n4705nu7t11tyr.p1zyv07A-zzx8npx.14t@flex--tarunsahu.bounces.google.com
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-6973d186db0so3570016a12.2
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 03:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782212026; x=1782816826; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Duz8Zx+8AiYnCdBwNjKZl5RmXQ31zXqUNM7RLp7vFfQ=;
        b=Ur9HtJUO0558POcfB377sBd931WmW/pNbB6mVI5IWBLGRZOxkaHeLCBx4LkXqT/ZIF
         1qSr7Kfy9i59vHzOllRbHPqaHg/IlWQYuhaDHdFztyqQoiOlBL6q+y4LoQJDCz4AtRTp
         12MUABEQ5+xd8w5K7NAYYIDtyqWLYQ5aAlCQxJvbRbIpPmhQKLtHiT//W8nXxQaKYHMl
         cEsnFVnArgECI9J6/XgZ46+8ZmBqTh09NjgE9d1RmKBsUarza35OCij4V+qr5fFfjJpu
         9CQ9cz2a6EHz9xdMe+HSc5MOb+XU2MNaI0EraL0NKt/gkE61Ok4cnejB8Tt9GjyQwMrq
         sqdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782212026; x=1782816826;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Duz8Zx+8AiYnCdBwNjKZl5RmXQ31zXqUNM7RLp7vFfQ=;
        b=j8hMpq2f8/e/iS9qm9+x25G6y5n95rvvrFImVxP0TRR1WZ2Sx+Vby5khthEHLhMBDo
         IK42NChtPkIwcg8ru05HE2jeZl5VecO5swrI1OsrNzwAM9IxjB5cKFtpR8jeSV6nAS4H
         TVyYM8Dikb1OYrV/p1Y5wOpiuAGk3HD2xfxlSGuN75Nx1aaC2Nx11YsxheDNiyaffSJf
         qSRU+clM9r5XeYvn5JRpLkCgD98misd/yxRVPBrM4lrXJ+NwIw+9cUziERbTUd9dnjqQ
         1STQG1JMl9E19y1OQqXudFbhFHuZCLcNpqjlNDIGnbf3IC/7dBI8gsSAPVMYR+Xy7oGQ
         Wwhw==
X-Forwarded-Encrypted: i=1; AFNElJ8325XHI1trrPvP6OOvbgRjZuDj9/6Xb+wlIiKOufuRVbpsheho4B+2kBPFxMgtQ6pTNtLxGt5NCw==@kvack.org
X-Gm-Message-State: AOJu0Yx83hGfmqgFsmmvriB0yMtwEcpwilkVQX4CIJUKeuN1tAFr5Xjc
	UpoOxt6ZmIjeGl/+Oosgujrjkh7XXMt4nN+86gTgEYt3e5yHyEPAQsa3+U22+9dicoEXZTtdPxT
	uExVLnbkoomsd0/hfgA==
X-Received: from edah41.prod.google.com ([2002:a05:6402:ea9:b0:68b:8a53:a28e])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:380a:b0:691:b5aa:5a57 with SMTP id 4fb4d7f45d1cf-697dbb55ea4mr960674a12.18.1782212026359;
 Tue, 23 Jun 2026 03:53:46 -0700 (PDT)
Date: Tue, 23 Jun 2026 10:53:45 +0000
In-Reply-To: <ajpbHkuWiGQrUec8@kernel.org>
Mime-Version: 1.0
References: <20260622225736.2961438-1-tarunsahu@google.com>
 <20260622225736.2961438-3-tarunsahu@google.com> <178220761164.162773.6384380547612711985.b4-review@b4>
 <9huzpl1h37hj.fsf@tarunix.c.googlers.com> <ajpbHkuWiGQrUec8@kernel.org>
Message-ID: <9huzse6dle86.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 2/2] luo: Update serialized data to use KHOSER_PTR
From: tarunsahu@google.com
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Mike Rapoport <rppt@kernel.org>, Breno Leitao <leitao@debian.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F382F40004
X-Stat-Signature: qngpniitzucm7tf534oq4fjbs98u6zo9
X-HE-Tag: 1782212027-64385
X-HE-Meta: U2FsdGVkX1927ZNGOsVIYbq3l8bMQuXSeNacXFggUg/QRWlwjpVqIIodSvHtdjBg0jMwX5oGmIw3OKlwqwN2CYyfBPr6bEOvIZCvDEvYqUBJE8wxx0hSq9eUsYVfet36dholeDK2/yliYCfxm5a9WQyTFksUMTzIqYmPMnZNRuVarMU8lW5jCHKjP/U+nsh5SLBFLDTJyzbltTIozOILtU7n1BOjgnRBT0ZMejufkcG2hUt+XIU4s9VsgjBwexNQt2bCcRSRPaVhEjP+boPoqa1Xwe3jF7Iz9psRTG0Uux5HvEqBO6LIZnQC/TV/Wq5FJc0FIHPaco/eg95q8o97YrwMMTckmYKTaLI+VCDdyWxnapgPNR9b1iBSO4AdXNwYnaChbCN1jX69FsW1ke5wMxmJXMYj2Rl4ply19lXdVBVCo41vJjfVb02QP51kxWOtQiG9lB4Yy1V365qsE5sY5sGg5pDDbkAI9iEJRMFnO6CkfqnGvx4jIQB8nKZ957s2lgwsBlqgkUBiNLdAaCIPsApJZyBc4GYBiT3ckAtIP4AScXVeEApzCOrOzCOOBndhPgojbNF487zvupYRszoeKnrzQZLSofK3ejWhY2NYJF3vZSWW8JkjxBmolOYac0pP8k12OyVI4Xtni12JNwBmSXoI+8+NTynrNBcL+CPkmm9TXSuxB2vHImSARjz/rIkX5opGCSEgQ6gVFzx9OQtVdzt1amSlslRlrTCZyBLdvHz1UQyOgtUcwXqzFw6nA3iPKOauthmVcZzDAZhmot3ItGmzXkrKF7/aLbMaqNLTeKPvo+c49XQgOYHcbdrR7/Ci1aOd/BoGETHyyjHEA4lPYjgjUmsyQa8nCvT+TGUoFhF6NxkM6t3/KW79Ndj2BlXG/ZwR7xHhP7Vd/V1KJeFYkWKGPd7i0bU2Md1xIh8Y5g7EZOe+r+4wj5C6alCiaTwQ9DAwAL6fnGoTPzIc5np
 Oaavom2O
 3a692l46CqDcMw9XbalSS6k9OHDuU/azKp32XPJrcNnQSjP1p/QIrD1ocb5c94Ha+P+UCCWOxKZVLvED4mtH3DJ+CECsD2Gk3fqX5g140D64JX4uLSMPIyuBh5PNe5MzCR9Cz485ig7578+fvYji33a1T+Zk2ELqQskhgDx3rUFZdIFE2qefALJesdKrTdhS4Skb5l9D2aIWFlV8nHKMWBzKzCLZiXj7DrC5wZv3LFqI5/gQfjo6AVVEAYE4l+Rm4MMHKaiDgJLdx2U8mVqfvdoJ+02fTYsgvyUQzINrDre/YomZxaCfQYAxA2wayJruK46cYa8W9dAIfu6gXjkrYii/ROmp9Ur+PQp3CI2qgTNujCAVJO7HohtEScvFVj80MoYtqmzcEPzd1wQA1oMPGrGSbKrkw1Q5zITyqfa7MBEODm6a03WIOpPRGjBqbheU0gBf/4ZcmFkuQFgq3X7amCQMRQbVOMsnFu3i37sO1h0OktgdN9p0cMZtQkvb9orgI3a+mOwJxaC39DBSTMQCEtd3f6NF7u1bfZ00Gdu5L0eE8/yHV3NIJZGPjjO7TIpECSJm6dDKoKruvckZc+GaPTufSaa1AlKLLpTTX+YcylKQpWeDng7fVriSngQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mike Rapoport <rppt@kernel.org> writes:

> On Tue, Jun 23, 2026 at 09:56:40AM +0000, tarunsahu@google.com wrote:
>> Mike Rapoport <rppt@kernel.org> writes:
>> 
>> > On Mon, 22 Jun 2026 22:57:36 +0000, Tarun Sahu <tarunsahu@google.com> wrote:
>> >> Convert raw serialized_data to KHO serializeable pointer (KHOSER_PTR).
>> >> This series also takes care of resolving the bug with memfd of using
>> >> phys_to_virt before checking the args->serialized_data value.
>> >
>> > For easier backporting the memfd fix should be a standalone commit that
>> > comes first in the series.
>> >
>> > Other than that
>> 
>> It will break compilation for individual patch. For example, memfd_luo
>> changes are hard coded dependent on the args->serialized_data
>> conversion to KHOSER_PTR?
>> 
>> Maybe I did not understand, Could you please explain what you mean?
>
> Sorry I wasn't clear. 
> If people think it's important to have the memfd_luo fix in 7.1, the fix
> should be the first patch in the series and shouldn't use KHOSER pointers.

I dont think, this is critical issue. But it will be a good practice. I
sent v5 with these changes.
Thanks for the review!

~Tarun

>  
>> >
>> > Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> >
>> > -- 
>> > Sincerely yours,
>> > Mike.
>
> -- 
> Sincerely yours,
> Mike.

