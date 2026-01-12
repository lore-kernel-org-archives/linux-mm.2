Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A887C9EC6B
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 11:09:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 842416B0089; Mon, 12 Jan 2026 06:09:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EFC76B008A; Mon, 12 Jan 2026 06:09:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70F606B008C; Mon, 12 Jan 2026 06:09:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5A5756B0089
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 06:09:57 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 13C42D0E74
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:09:57 +0000 (UTC)
X-FDA: 84323042034.21.CAFC08D
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf06.hostedemail.com (Postfix) with ESMTP id 379B6180003
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:09:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WcYpAnkm;
	spf=pass (imf06.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768216195; a=rsa-sha256;
	cv=none;
	b=QRfzJZyvjaiXXeWSXgnsfS8XOn/IddWr/dJy+cKbChBnBDW8tK+A+a9VjagWs1NA61LNVP
	BdjcYbeOCO2ynqc/RrxG3C5fMixhYDte2n7eq5joCsW87F1PubRzJ7bEJMKqbTr8FIREz9
	6s7h60xomyb9Znw1YQL86Vmc/Fzt79o=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WcYpAnkm;
	spf=pass (imf06.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768216195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hJnK/ei48zDVB0dQO8DBPDRFjRo4ADnGxtGvkG0ch+E=;
	b=pbs8Cg3pQofCcXjuch88uV/yFbJnwGHfFlfKx/jWVfz1DLsPwoHgDTLX49IBhsimRi0i8H
	ASRbcbqsaYQSaCllN4MXsDZcx6furkb3jVihs6lzk50vH8fa35BTVwpUvcu9f/7qpvl6nH
	MYCkKFzf4rRyFRYH0MUoUnp5vY6oWg4=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-59b6c13b68dso4424756e87.0
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 03:09:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768216193; x=1768820993; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hJnK/ei48zDVB0dQO8DBPDRFjRo4ADnGxtGvkG0ch+E=;
        b=WcYpAnkm467jNkANlODZvltsGIAbA+acpwNj6zK1g1b+egiAueyfHk3YB8eOpst6uC
         zIlfte3J/Dx3PUTovvEGZKSUdPRWsd3eJxF/ljIdsRXbFcWi0Rm+8zZ4IPHFo33J26yb
         kqUg4qRCGbpn/kgzZvXD9C1qpVT0jZExfGIOB9lljRO6nirzzXAbFXoVnAG0bBuGx9ol
         Rls5ZrHwPCL+P/tE6meEEBtEqUsbK79JWzUUD+ODXsQcA2881WeakTYkpdh6vQYofJf0
         ItF+Fmhj7EFMTYFkUQAEv+48tmjv2bN4MOpzzwbPyDgUpDGmAb0e+qu+DIRqKBjNEZTD
         Zwzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768216193; x=1768820993;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hJnK/ei48zDVB0dQO8DBPDRFjRo4ADnGxtGvkG0ch+E=;
        b=m5Ut1g/dMbqqzvZrtmrnyNW2k/89QojKuLOo6cPvuA59ysCBFOhXZ+O1kznrglnqht
         oR/8vEzdr+B9FiLxYA7jwhULU+gJdp53kRkD2RoLRXiUwqXemv/W4xd4seVoQICYe24U
         D1Ms/agZCiBvcPVN0u7Yzr+cMN7e1KNbFqny3kSA2szHXGl1ekk0yYr/9YzgLrvRxNM1
         TujFjrUisX8utlPOM5pnL/nUtiAUihW+gNO4HmF/RLD4W4rNJTFovhoq0O/RqtSfY+Y/
         jr74r4T2eRtCGG4fvgMDfTlB4twrm0N7a6ZP60G79hINOmTAn4myHBdDPcb+a15NRBaG
         DYnw==
X-Forwarded-Encrypted: i=1; AJvYcCVNNNrmhweK/WYq21oFQNtwZqErYuhDtTrybZiX9DRZ0ExAXCh33Mg0Q91C61Lt0Sj5P6em2tivhA==@kvack.org
X-Gm-Message-State: AOJu0YwON4w8QbQnd+QYcORL8WtdUc0iQinnBj03Yh4vZ6OmHPJuHg4D
	jcSl7qz47YDkueIRgKvKerQx3cJRbYpHOF5MQiXK4RTPA+3CmRuA6ZHAYTTroQ==
X-Gm-Gg: AY/fxX5OEf+FL5BTBna+7L7AO36evPWqz9n7/MWTpMoO/peT3xQgEyOTjKQU9jGOXUQ
	1Fltlb5UFVj5jsg/kBuZx6/5M/Q0IvgA4/illpDbonIXHv4DNRvUo4wyMLZ4hkV0yFundkN7LiM
	UClf6rlLH1CwnBBdiudV3Pj/lKQD8JKb6p7jCnHGjwnCwdbxxmwfvPal+jKL6aQ1KKtGMxklKDF
	cmRmo3/v7c0/tS8EHeHpDNASt/KGHepLo9avjXjquc1LFhMlRZkpliRhF16UDnoulEvlFsxfckt
	4Jmefd0TUIr2tZbNiVruKMeMI+IKFd1FI2uPrDPZqulxzgXNYmDf49oXEQ1hc4MQyoQkHOk3AWg
	F4yVFo5IpYSB7C6efclwkd7vDlWRdkhraV1OOOYo69++YC8DGTlpvx0aaYNfGHvIl2BOLK885By
	z4XI+otFkuCox3OuTTYErXvdL3wVP0YE7wjLdCNw==
X-Google-Smtp-Source: AGHT+IEp/se7xsBn5Zy5m6ezN/he+DrJVk9vJFsoad8vBJwhFX14R+WJyNjzHktCAH5Re/onvRS+Mw==
X-Received: by 2002:a05:6512:3b06:b0:598:e985:21ef with SMTP id 2adb3069b0e04-59b6eb6b363mr5513280e87.24.1768216193127;
        Mon, 12 Jan 2026 03:09:53 -0800 (PST)
Received: from pc636 (host-95-203-18-139.mobileonline.telia.com. [95.203.18.139])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59b732da1e7sm3696067e87.18.2026.01.12.03.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 03:09:52 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Mon, 12 Jan 2026 12:09:50 +0100
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: akpm@linux-foundation.org, urezki@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+d8d4c31d40f868eaea30@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] mm/vmalloc: prevent RCU stalls in
 kasan_release_vmalloc_node
Message-ID: <aWTWfri7PTCbcu2r@pc636>
References: <20260112103612.627247-1-kartikey406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112103612.627247-1-kartikey406@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 379B6180003
X-Stat-Signature: o5gywk4mg4tz4a3oxcjoowxdx3ijj3ir
X-Rspam-User: 
X-HE-Tag: 1768216194-169830
X-HE-Meta: U2FsdGVkX19doHca2H5aGnIh5aW0WXL/DQL/8EqkkoZXxdKDTqKXy1mXbZZfHXvq/yQnkmY2a0YAjKTeFNBoXNV5JgwOrFmeoNgUR80BcPXratb+Ef9sOwJBEym1c3Tef5/yvLCoows8Umqn++8QXbUJ3g7Kjla2M+12LojG7hSYNHbXm2+KwIeJ3/uJ9X014AVzRUYfkp7gqDyPlfRZsgp1BN3VdxvzkfMYiiviEOjzZ8NTZntA8Vqczsl0uXYSOcVTfU2+NrMeyvLaXqwTkkqOe8x6i0Pkmt4NE9wsRsw3rYjLZ6Pr3nTbjgIuaCUPepazKQU5hcKoG+fcn4cX31fgccKB/Ty/N92GTcS+zCKhbIV2lNZDMoF9vdPtv+P33u3HdJ14D34Uqii0YGPvlhuSEhqF3VpUf6rHRHjatqR8AakT9wGYfv3z9uHJP18cbGet+x7mUifbH2TaaNlxEhK6Giur9twqCMlISqxjTmhBaMTdIT2n0oevS/jK1HnRJCfoo/jTpeKxLiPp9AsNqmF9Muhe7GOsVO5yUG23fDQ16bRE4RLoK5F3iR1iGovt8MA4Y3dNeKdyy5Kn+zs3EB3Wmai1WyH+J0vwQ8xLEqkDr3HsebUBJmKGgbTDQBGbPsUzqgWe+c4YdNhkgPRxs+5BWAZSpDPkGAPHAWsMcEPSnPXaQmSC1es9e+SXaM63zO2RXoPrQYWw9l2wVURB+za2s/usWLGZp/0YY4IBKHvdRv94bIsWo7bF7l+1dmt2x3lJTdyh8kiOeRZ2ipye3MpepgvKQi3IHoyC4oUDx20qIezV34BTxSpkMsETegAccLgFx69XCXmDgK/b+tDcT/UmK6yi5+FOUuqTT1ho396blZzs1AO6crbXxdrprnZ1EXA7MIIa5CrI8adLlLzoZxH+5PSk7BjCf1RnWG7VHxriqa7BLxglcV3NE8nEjsiZ9/rJOpjXJ/o6eoweRNi
 lP4zqdGG
 O58uWLiU/lo/LF5g7r5RtxzR6MLk5T/s3j2VYASroIo4Az83j4c2rHnES3Jv9piYg6l0UgTeZI6wFrwAzHBicXb5iUPmTnGVsDYDGT8+7fwZ/BaLa0aNZR1kOYzgqT5HxOTcVQAWy0LDUF5duyr1bSJlFCj0gOdWo8qwLFe+wTQpW67fwU0cJN2t4o7YQF2RFQEJm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 04:06:12PM +0530, Deepanshu Kartikey wrote:
> When CONFIG_PAGE_OWNER is enabled, freeing KASAN shadow pages during
> vmalloc cleanup triggers expensive stack unwinding that acquires RCU
> read locks. Processing a large purge_list without rescheduling can
> cause the task to hold CPU for extended periods (10+ seconds), leading
> to RCU stalls and potential OOM conditions.
> 
> The issue manifests in purge_vmap_node() -> kasan_release_vmalloc_node()
> where iterating through hundreds or thousands of vmap_area entries and
> freeing their associated shadow pages causes:
> 
>   rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
>   rcu: Tasks blocked on level-0 rcu_node (CPUs 0-1): P6229/1:b..l
>   ...
>   task:kworker/0:17 state:R running task stack:28840 pid:6229
>   ...
>   kasan_release_vmalloc_node+0x1ba/0xad0 mm/vmalloc.c:2299
>   purge_vmap_node+0x1ba/0xad0 mm/vmalloc.c:2299
> 
> Each call to kasan_release_vmalloc() can free many pages, and with
> page_owner tracking, each free triggers save_stack() which performs
> stack unwinding under RCU read lock. Without yielding, this creates
> an unbounded RCU critical section.
> 
> Add periodic cond_resched() calls within the loop to allow:
> - RCU grace periods to complete
> - Other tasks to run
> - Scheduler to preempt when needed
> 
> The fix uses need_resched() for immediate response under load, with
> a batch count of 32 as a guaranteed upper bound to prevent worst-case
> stalls even under light load.
> 
> Reported-by: syzbot+d8d4c31d40f868eaea30@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=d8d4c31d40f868eaea30
> Link: https://lore.kernel.org/all/20260112084723.622910-1-kartikey406@gmail.com/T/ [v1]
> Suggested-by: Uladzislau Rezki <urezki@gmail.com>
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
> v2: Use a macro for batch size (suggested by Uladzislau Rezki)
> ---
>  mm/vmalloc.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 41dd01e8430c..51e58701565d 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2268,11 +2268,14 @@ decay_va_pool_node(struct vmap_node *vn, bool full_decay)
>  	reclaim_list_global(&decay_list);
>  }
>  
> +#define KASAN_RELEASE_BATCH_SIZE 32
> +
>  static void
>  kasan_release_vmalloc_node(struct vmap_node *vn)
>  {
>  	struct vmap_area *va;
>  	unsigned long start, end;
> +	unsigned int batch_count = 0;
>  
>  	start = list_first_entry(&vn->purge_list, struct vmap_area, list)->va_start;
>  	end = list_last_entry(&vn->purge_list, struct vmap_area, list)->va_end;
> @@ -2282,6 +2285,11 @@ kasan_release_vmalloc_node(struct vmap_node *vn)
>  			kasan_release_vmalloc(va->va_start, va->va_end,
>  				va->va_start, va->va_end,
>  				KASAN_VMALLOC_PAGE_RANGE);
> +
> +		if (need_resched() || (++batch_count >= KASAN_RELEASE_BATCH_SIZE)) {
> +			cond_resched();
> +			batch_count = 0;
> +		}
>  	}
>  
>  	kasan_release_vmalloc(start, end, start, end, KASAN_VMALLOC_TLB_FLUSH);
> -- 
> 2.43.0
> 
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

