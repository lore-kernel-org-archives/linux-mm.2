Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30EF2C44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 15:54:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 270036B008A; Mon, 20 Jul 2026 11:54:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21FCD6B008C; Mon, 20 Jul 2026 11:54:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15D056B0092; Mon, 20 Jul 2026 11:54:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CDEC96B008A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:54:19 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 476871A0210
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:54:19 +0000 (UTC)
X-FDA: 85009601838.29.B601125
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id E2B121A000B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:54:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jWSM1UBC;
	spf=pass (imf19.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784562857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8dKvZsK9bN0vSKT1EWr07IiR1IRjCYgsoqnq/4PrwdE=;
	b=6lLw6WpsPsAi6ERG4L5tkkHaoOXYJcXdqefYHOv8kmKOse2eYiRsrv5ZgkfOMn23Oyp3iO
	4p58tV/xVGfAN343u63ZUVNZgSlb+xG9CfB7F2q01JOEwQmOLUCcJ6zKngkt5r30VpJ2Bb
	hmtVTS66Hx9IxtjkJI0Ki+x2IFn5+bY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jWSM1UBC;
	spf=pass (imf19.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784562857;
	b=HBr5Pge6fA/+YA/Lfk6xH2bildFRUG5j6o4VGNXXKseYHPhwXnJwOdCjuQpF/Y8JNwLuxz
	X8G4noiOt0Wc9Z8fEnUGrYL6L395t925rV3twxC7ppZiWUQ59/8NXgqLPHU+iq03R1jmJg
	fw41Ux6yjXX66H6UptHTqhsYefQ4rrE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784562856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8dKvZsK9bN0vSKT1EWr07IiR1IRjCYgsoqnq/4PrwdE=;
	b=jWSM1UBCnv8WR9HTZ3JIkJ68E72aBSNEx8u7U8rGS7fkwVvtG8IP6BQmT+KGs2MA6omTKA
	JQR7mQVvnyzsMsaDio/duGSEzyHRQv2hy1UUk94cTCVItGe6Xe2gjrnrTxRYltmJ7UGySu
	BmxjqUH2xpRYR4YiRgMKaSFwbclc1c4=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-VD4z3KtiPum25TaVxdnrgQ-1; Mon, 20 Jul 2026 11:54:12 -0400
X-MC-Unique: VD4z3KtiPum25TaVxdnrgQ-1
X-Mimecast-MFC-AGG-ID: VD4z3KtiPum25TaVxdnrgQ_1784562852
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-51c21c01cf3so152557441cf.2
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:54:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784562852; x=1785167652;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8dKvZsK9bN0vSKT1EWr07IiR1IRjCYgsoqnq/4PrwdE=;
        b=HtC8fLHSkluwoBSkFI3h0dN6yQ9jun1CDxk/Hw1b1FtZITp3RWY7vSkgOxxfhJa3xm
         0vkyJJ6b1+tAPh6d8UScNthTHp/81WPLFe0XO4f0Y++jGCfFjZ0k+umMBbaqqZTcKkzC
         X3UJ1USJnwagr/h/HlbXHofQF5ZjV2+UPjLQzuEGWc1Kw8AMYWI89z91hpjeqi6viKQa
         rC9rJ9qJef9dc66KTA06FIACC7GrVUvSo6tEt0ndk1I53MphlSIe3IMVk4P1eP/hltgS
         IlJgguB4/xDQFYj6XDswGvYyzytwQS4nP0w62VSmy+HJRvRIz8hiDjgijwpf5ErZKIFu
         grQA==
X-Gm-Message-State: AOJu0YzRSLGerYrxNrJe9EggJIqAy09qBOpbguXxz7czcxTKo96ARnOp
	NjB6zR/PNuQ7du4Uup6G+KbniTt+73mfiNaIuEFTqBKp/lcIU9Z5A/Hj5ykRI2bbQSpYVVRRxwX
	94f1N4xcuq113vGYlfGLrJdja101MClc/n6tLaZU3v5boIYWANSgn
X-Gm-Gg: AfdE7cmb//ZnBXbr3fIEgTALwrem5TiNKBHR0Vv7LMa01gjZOgJPvT6Ya4AWELutcVu
	dtU0FzCf1qkv/IRP78a3wtT5YemsRvDM6AotxtHoI+WPK+ib8sroYbNVaALKkFUvwEn3Se+3+VC
	9gwZHKBh1DKeKANUfFTrc1I6yWKcoDRQCVFT8aqURc/9sS1uZzF8lQxrLRbtHrpKwXs0WIszE2q
	d9Nq/uhLUFvFvrvDosGsFdWiWvLek9hPQKkLn63CPe7XcDizjIoDD0NUtgdezEkyVmiE8IOaCTo
	dvvdJ53uiOmmLElyYoots4EuXrPQrVFhcjpYtFDirKW79mLZTCPzRCyMIS6X0s5GBRMj1j4RWVS
	s
X-Received: by 2002:ac8:7d07:0:b0:51a:6feb:dc8f with SMTP id d75a77b69052e-5213d2b65a7mr137422891cf.9.1784562851599;
        Mon, 20 Jul 2026 08:54:11 -0700 (PDT)
X-Received: by 2002:ac8:7d07:0:b0:51a:6feb:dc8f with SMTP id d75a77b69052e-5213d2b65a7mr137422281cf.9.1784562850813;
        Mon, 20 Jul 2026 08:54:10 -0700 (PDT)
Received: from [192.168.2.110] ([70.49.81.60])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5214cda7dbfsm75357561cf.9.2026.07.20.08.54.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2026 08:54:10 -0700 (PDT)
Message-ID: <a8637ae5-1796-4dea-902d-1ae1238261e6@redhat.com>
Date: Mon, 20 Jul 2026 11:54:07 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm, swap: Move setup_swap_clusters_info() after
 SWP_SOLIDSTATE initialization
To: Kemeng Shi <shikemeng@huaweicloud.com>, chrisl@kernel.org,
 kasong@tencent.com, nphamcs@gmail.com, baoquan.he@linux.dev,
 baohua@kernel.org, youngjun.park@lge.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260720071342.50742-1-shikemeng@huaweicloud.com>
 <20260720071342.50742-3-shikemeng@huaweicloud.com>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260720071342.50742-3-shikemeng@huaweicloud.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PVWqhhX-X3h4YfjpSmF_T4mH4LqgnG6NdGBQ5nJdcyo_1784562852
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E2B121A000B
X-Stat-Signature: 5ucpiziz9ig64d7hpr8fhe41i73s9x37
X-HE-Tag: 1784562856-719283
X-HE-Meta: U2FsdGVkX18FW/deDW7NlMwSfBJi0zfc+hgUz6/Lde66xKORb2Z1xkhwnICqIswWMTI5LaVRZjQGxrqPkOr1eqIWn6MqeqPTcfLDkqhJuRLCggxnNaIvgvj0PZPDEghiO/wJz1SWM9HXX3hQHoFvrqOSjG0zdsgjEIHtR4soQmIWJ9dR1aEvqrLoAQUfec2knOBGFK1LipX2LtRUn9XoPSCkI+gh/wxAxCvIDCazC/SJVLBNzQ2JmmGBH2jQsLGU8wX9WPWVeEX6scii8gV4XW9S0ipTXNvE1LDow48AfHpf5bxHBsJKKSJ7G/hkjE3kaLniZ7RDJPPPQFkmqwxK8y/mlPBxyY8OxLfbcUX+C8RdZXdopJiMT3vLefGiuFiuA3mDWTyGFqdQE37myGNxmn6UpdwqEFhBHWECfQoKIM7uzvgx9nUMTQSalt6deuJiJJxFCkQyKCtQp2SZGcv8Vg+MeSamolsQoCg2RdhUvNPmVs4P7Ko7BDsLRSsJid4yu9tkJbNT2On54C1x76r4kNocpg7TMk+eTtxCsMht5uEi2+CrmNmytINum0XzMYAS6BGSOFUCJyxGbfdSCeO79nmRg6T4UsQMJ2Rf6zDhhVZ+7A5BmlPm3mT5J0SB82z2Rvw3rT2/OT6Ep3VhgwLuX7kzpzGozaDajHYFNEXnrnAtgRKU5ok/PCDNTU1xJYUi8H+2K2/2fWKGiBeDj48/Kv/3o563D0TWbp7WQOxUFGLunh38fp2e6Fe8fvdKms6snaLObcAz+1ls6QxFryArFlEUA7IjgHZao7DhpU5QqjxRtDSl0qZGp3sod08AOGqt0evtl4+0IgJq+Btj51uOG+zITHewsvpaX2Z/SbSQo280sZxq3/2V2bToJwxKMbcdiEBPkBGmxgDy4OxQN024BXmcD4zx+zjBEqc7tpITB8AdCYRG7Yj6xlfX7kzDkmtOkw3tfP2tuJPqy3+r4Wc
 jnB0FGFx
 1nL5HKLePVn8qxEWMZfV8QD+OOCz1rUX1Uc1VBYeTlkmyLPTQhw5SLB/Cp1TCCITwG7pvugi91MXpuMJMQEp4aiHoc3B2cuSSuB+pxh+qKaifnzvmXXPTBH71UE48wKZrnU5rz7QDpAlNdIR2U+1sRkTL4yCiXks28f9RNkKL54pra3BppE7hf4cKhsDt7Oq7WKMVOg6+MzjPI/QhqQdJhU8yI5VcoPVsAiKctlvPlsHTic46QxsOCqsU/eqol2tavhjmVtm7jht0KMjzYaP+Fi7RaXkbDr/y+lBFnnO97Z6Q8R9sGGi7c54jhEnnlmvN3hbg6FWF60tKawgq1ovU/j59uEO54DqnIknYeYvttFcly+QFx6aEW5VIrwmnz8hAcn8+wUC0/D+g+dHKhm2Z6R/xhCdHd190hhKdLPylMAdCNMNbuuoWy3pB/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-20 03:13, Kemeng Shi wrote:
> In setup_swap_clusters_info(), SWP_SOLIDSTATE is used to decide
> global_cluster allocation. Move setup_swap_clusters_info() after
> SWP_SOLIDSTATE initialization to avoid unneeded global_cluster
> allocation.
> 
> Fixes: 451c6326105b2 ("mm, swap: clean up swapon process and locking")
> Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>

I was about to send the same fix :) (one nit below)

> ---
>   mm/swapfile.c | 13 ++++++++-----
>   1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index d29062d9c3cd..81c4040912be 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -3607,11 +3607,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
>   
>   	maxpages = si->max;
>   
> -	/* Set up the swap cluster info */
> -	error = setup_swap_clusters_info(si, swap_header, maxpages);
> -	if (error)
> -		goto bad_swap_unlock_inode;
> -
>   	if (si->bdev && bdev_stable_writes(si->bdev))
>   		si->flags |= SWP_STABLE_WRITES;
>   
> @@ -3625,6 +3620,14 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
>   		inced_nr_rotate_swap = true;
>   	}
>   
> +	/*
> +	 * Set up the swap cluster info. SWP_SOLIDSTATE is used for
> +	 * global_cluster allocation
> +	 */

Maybe something like:

/*
  * Set up the swap cluster info after SWP_ flags handling as
  * setup_swap_clusters_info() checks SWP_SOLIDSTATE.
  */

As it's minor:

Reviewed-by: Luiz Capitulino <luizcap@redhat.com>

> +	error = setup_swap_clusters_info(si, swap_header, maxpages);
> +	if (error)
> +		goto bad_swap_unlock_inode;
> +
>   	if ((swap_flags & SWAP_FLAG_DISCARD) &&
>   	    si->bdev && bdev_max_discard_sectors(si->bdev)) {
>   		/*


