Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 981D1CD8C8C
	for <linux-mm@archiver.kernel.org>; Sun,  7 Jun 2026 08:38:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 669BB6B0088; Sun,  7 Jun 2026 04:38:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F3726B008A; Sun,  7 Jun 2026 04:38:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E1E06B008C; Sun,  7 Jun 2026 04:38:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A28A6B0088
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 04:38:53 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D95551A06C6
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 08:38:52 +0000 (UTC)
X-FDA: 84852466104.25.368C291
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 463561C0002
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 08:38:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XahCIgSf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780821531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NXFgpgZtmgGyvqSFzwfkAaFL3jpCX7D1eIvkr3SRPGo=;
	b=MjR64/cZxoUwv65b8qYmrtLWM2Da3tkTNP//SvKK60T30zYMXn1qffe/lmbkjJpY2zwQLA
	gir8WTD/YCHTcf4jwZvN7gdjd2y9wy5GITFSF6p3YY110BXH9I592NL1z0vMSMdZqwL3FY
	9+v0niHrrTs7Bs9V2RGMXVY3e5M6m9o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XahCIgSf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780821531;
	b=N+2C3PM7/sgfkubnyXp18SmYdXGyBcjRymXmVACVJ6Pc8CD/aNmLqraNh5gRVqQwDv7HVB
	mdD39/rLl0gkH0m1BaaZEkWsNMZ/mBYUxTerIcDQswRJl2+6J8+pEFKt3vy7eQDMW5hoGf
	24tC7EkbUt9aUEph+rtn18iLAQ20RCo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A587960008;
	Sun,  7 Jun 2026 08:38:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D5F1F00893;
	Sun,  7 Jun 2026 08:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780821530;
	bh=NXFgpgZtmgGyvqSFzwfkAaFL3jpCX7D1eIvkr3SRPGo=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=XahCIgSflUlzl9MWnz+cVVrZO791s3shralebfA1ZscwPQBWMV3lOv6iiqKQWv29e
	 PMBtpmj/XvsfZUQ12mz6JHz5MztoQUmNtHwN5fBS9k9un17alPkeTS3alohOG/TgvQ
	 4Z3JL91qpTkvpVykTqVfrd6CyIdEBECULF95rG3CyUhe6CA+MaEival3LEW8TXQrGV
	 +/xUJQFd2p45QrgM6wSB8aRAQunmi/JJtuyzJbv1AkUruuR7x5tOspHr3g2AEh+WIh
	 yiID2mj8DEC1GYMAuR21uvwZSU6f1RJ88QjRmjgKO+Ia8jlYqIMaQ7jala4td/Zsss
	 VqZauw5+EPSgg==
Content-Type: multipart/mixed; boundary="===============0148180687452261602=="
MIME-Version: 1.0
Message-Id: <5f68f44310d4878185fd5ebc52d66530b99f174c6d04ab1170dc53cefaa54568@mail.kernel.org>
In-Reply-To: <088f52fd25860ca961449d53f91b214a@kernel.org>
References: <088f52fd25860ca961449d53f91b214a@kernel.org>
Subject: Re: [PATCH bpf-next] arm64: mm: Complete the PTE store in ptep_try_set()
From: bot+bpf-ci@kernel.org
To: tj@kernel.org,catalin.marinas@arm.com,will@kernel.org,ast@kernel.org
Cc: david@kernel.org,arighi@nvidia.com,memxor@gmail.com,akpm@linux-foundation.org,rppt@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@linux.dev,eddyz87@gmail.com,yonghong.song@linux.dev,emil@etsalapatis.com,void@manifault.com,changwoo@igalia.com,linux-arm-kernel@lists.infradead.org,linux-mm@kvack.org,bpf@vger.kernel.org,linux-kernel@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Sun,  7 Jun 2026 08:38:49 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 463561C0002
X-Stat-Signature: 1ygm796dqwqzcfo8tpux5ff4u56br1bc
X-HE-Tag: 1780821531-150072
X-HE-Meta: U2FsdGVkX1/nh4Pk4i6BciKjJOrJ9PkitsUXfykZ6VESBv7f/eKY/Jis71+K2y1EF7AYwMtS3zUjmPOSm/v0IYCSJtKPevDepWMpVBRsedDTESWp8e2HQ3YiX8eh4GbblSsBcPe3LkN5MqQyBoG7atUZ6qvR/r0cxgA4CbmGrXyGAb2LT8J+j+vGIfZglyG85sgYOErOnFUWGenAW0iaVVoUlBIvONQ9q67nBOQkWBHuFt6wFW4p+LJf54Hzywq+mGvaMvs4NmZ5zjYpBezQoW5Rfl/QC+S7PG61K29SanPYTmxAuDfCFf+y9sUxXwhDhI8jKEt3pc5qod1h46aEoQt2DfMI4MYHWuX8HryWtCv4r6orDrDW5LQfi4oilnZyhpoxix1e3nV2LgKh7Wd6KjJT+erAxTIew57qCgYx6mlUzj0jD6MsB9HFqzObLNIg3H/zZqQs/5oB36NpjS6mpKXs6LOPCmjFRaeXWK/JanFK5KOTAvSeSCQD345rQnE6zQpNfmDDzpem7b4uPW1WnwGzUNvZf+BF7kT5rEGkAcZqdzuxCH7e5w+p/AbEJPVq/tj+J+RwXCzsqrwmB4m4sDFjlbM6gE815M0tw7QHk0gNwnVzoVwh6hO6iyvm+IKd4JOJtAsnp1aWiiGzoO47ZNFZJo6QSnlfjkN6wwzGCUd7AAqyeZpIcE7ltTUAqZT7EyQLd/uBL4ncEcHM0v7VHcA8fAgqLp220gkfPi0oKSXx5Rp00DsBJ95Z/EzQIw92/at5u70GhWU42JptqIVScoXDpaUtWZwMePYv0gefIFz+l8q/ZAgWl7Ky0LCLKiNOi6CcsNrWQuDwXjEvL+Fi2B1Pe0jLJ0m0pcgEpoVs9DVJCq0op9/wAHD9kFCrqgqkLf3SZA6hyDpTttNZag+khQbSGIxLIZ9qabZGO+ioBSwSvuGiKH2c419hP6WZVmpTMy3Iw+Iqjr8thiFm8ni
 rxCHIoil
 anJVsnhV2DUzHU9viHL/71CyYOAPoYtfDRxN8HO4yYjwf6dSBLIzIwRE7joncnFU0ZwatyfaaS81jUbswo3yzc9ZA/jBjpFmsPpu0qQoruONuUBVDaDEr9MPZacQC2GxoIAN2UN/uTTkcU8prKvSP7hbGQK31pasPmIKQ2LqQIigSpGgs0kRgRcQALiNk/0ie1vp6W/2KL5qxZ8zxvBAN55hwmy7XftpU3ZFhCcylmKL9pRfvNRaOUQ+qGtTnk3h/yaXRKD4NL7EbzOy48+1xJp7/SKZmx2TyvGkljp902qDPJQQ7LgUxHR8N9fA4mTppLV8FizMY0883qNEi8UBZHtavYFWsEjVpRTypS3Kp1+Gl1dXKwDicjQdvZIoPOhAXo/EpBmG00+6KDY756KkcqLbooIU6bZydPdQFeUCQhKeYl7pesFSRPTus/dfRYaBIDGRThu7tCUn0QtkaObCHaGLECSm/T+lIDYclfxikLu8m1s12F55rHXnFmjUwdFGwGW/BWyhpBapdrt57UXYakzDviTvJyfT9jw1D7npZ7F8i7th9hN8F53MeBHlNflTeF/Aj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============0148180687452261602==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 3ce0f2a6cab6..dc8525431273 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -1838,7 +1838,11 @@ static inline bool ptep_try_set(pte_t *ptep, pte_t new_pte)
>  {
>  	pteval_t old = 0;
>
> -	return try_cmpxchg(&pte_val(*ptep), &old, pte_val(new_pte));
> +	if (!try_cmpxchg(&pte_val(*ptep), &old, pte_val(new_pte)))
> +		return false;
> +
> +	__set_pte_complete(new_pte);

An earlier posting of this drew a question on the mailing list about
__set_pte_complete() deferring the barriers in some contexts:

  https://lore.kernel.org/all/20260607081229.12BC21F00893@smtp.kernel.org/

The concern is that __set_pte_complete() delegates to
queue_pte_barriers(), which only sets TIF_LAZY_MMU_PENDING and defers the
dsb when is_lazy_mmu_mode_active() is true.

The scenario raised is a synchronous BPF arena fault (for example via a
kprobe, where in_interrupt() is false) interrupting a task that is inside a
lazy MMU block such as zap_pte_range(). There is_lazy_mmu_mode_active()
would be true, so the dsb is deferred, and the fault handler could return
before the memory system observes the new PTE. The faulting instruction
would then retry and fault again.

Can this path actually loop, or is the deferred barrier guaranteed to be
flushed before the faulting instruction is retried?

Note this deferral mechanism is the same one used by the existing
__set_pte() path that this change deliberately mirrors, and the comment
above came from an automated review rather than a human, so the scenario
has not been confirmed.

> +	return true;
>  }
>  #define ptep_try_set ptep_try_set

---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/27087148382
--===============0148180687452261602==--

