Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53DFDCD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 23:02:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C9D16B0093; Fri, 22 May 2026 19:02:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73B766B0096; Fri, 22 May 2026 19:02:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DD036B0095; Fri, 22 May 2026 19:02:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 482E86B008C
	for <linux-mm@kvack.org>; Fri, 22 May 2026 19:02:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EA02E1C04E8
	for <linux-mm@kvack.org>; Fri, 22 May 2026 23:02:41 +0000 (UTC)
X-FDA: 84796582122.13.5A97C9C
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	by imf14.hostedemail.com (Postfix) with ESMTP id E54BE100003
	for <linux-mm@kvack.org>; Fri, 22 May 2026 23:02:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=S4QMIQUP;
	spf=pass (imf14.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.176 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779490960; a=rsa-sha256;
	cv=pass;
	b=g6GCSFoASpi6nXqS1DFywsf9tzOjA4dzzWDz4lMhtGkzXyuWTxkPP4htZMVI8K6QgXjGSR
	G8siJlCulAX+r833/K09ab4MlIApnCvQ+Xi3Tg9TpTDa9SogmizIUk6bHBZByYmaNAvudZ
	44YFE3ROB1uNCpJv/qi8e7ghme45EGc=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=S4QMIQUP;
	spf=pass (imf14.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.176 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779490960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+lqWW5xTN76UwAfrRbxGlO2NBxcf8RIbZZTDif3+3JY=;
	b=bM4eNEYsckuxlyveB3tpxvQA8jlYQPuxTXXlU1BEgT/BzGsBTsXemjtIX/He0ETAPvWuEW
	CRGgosxfhPEt8fCg/RwHYi36xlxoXv0k9fZ0DVi8gvHt3xlE16zM0Adti0ivfPfTeAjh9m
	JKtBvGiXoR5ISnxlOHJOFMafxPWSiZo=
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-575171b1ce7so2575653e0c.1
        for <linux-mm@kvack.org>; Fri, 22 May 2026 16:02:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779490959; cv=none;
        d=google.com; s=arc-20240605;
        b=ORbL3EQfDlu9CPWIhv9TaPMqh48ywsac0UbTl/y+RckZmsHcrw7+I8uhk0Ur0sMB3i
         pPjGG0hnfGdG2wmi0rSAkE5O2l0ZvOIsFqzKWbHBXAj3SbgDcCmdYu8Uo1llakAdIIad
         jUAxOnm7ZtSBC/q9kiNaecaspmJvdkN40+BdghE6at908GCGEVeCDCSfA/ERxza5PI+x
         IsVk5FFRIxg3vPBbOd+7/jTSpBhMZN6ZubaqK0io+Ai+mvByKcc8Jjg0BdAEga8zEu+F
         yD4tKB4jdGFdeKvFcKRB0gn5skv+2bV7FO3TTsGEzaiKlF1R4fW8plNJAbaNNQhTCtmX
         VfuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=+lqWW5xTN76UwAfrRbxGlO2NBxcf8RIbZZTDif3+3JY=;
        fh=NmKEB7Q+t77YQc3UKMWZi/r1d4fega0dA9kgnpTkrAA=;
        b=GGtbDzlfMs4cDypXtwSinS5aPBWFD60UcboHWYuve5sKtwjf+FQAitmkhIQ59Ow1pG
         7aC8ubqySWtmYtrkrvms9XO1EBwkTNmsAUMTTCd+O9TNtZVNnep70fWOZ1Ll6X93VNie
         v9ui7gVv38K8Jgp0i9SVUYX8A3irCcpfMKV7Ju4ooTB/E3U0t474brBmeQ6kYmFqwa6S
         Jan+YexvXPN9YtlWiS/GjeoNiR/ymSQKdxxJTyNLeG6CiLJ2t8FH71mkqocMhYvUmG9Q
         l+W24O5A352dCIOGgAn13Ew4GdS6sHB9BY+2GAUm09Z0oiE/9RkN31Y4g1/8v5l6/IHa
         Fvzg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779490959; x=1780095759; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=+lqWW5xTN76UwAfrRbxGlO2NBxcf8RIbZZTDif3+3JY=;
        b=S4QMIQUPAxpJP+qx4RW5KCQ+IJxdtDp3OnM8DZzyShunVDeVbH0UTYHBl0bD7RW1BK
         SZXqxRvGFkkkWGT/Vz+5a7tLJXUFZx7jqOdV+JACqcWRuYeL79BIiYF/bG2EFCcC+hDF
         O19r9wDokjcTmRXOprN80AS8ey0W8nkS5ni8FSM1DVA7ep/WAp1byX/vd03Ji7XSgAJS
         FxDfjXfT9VjklXGUKD1dv8MznquFSWH2nlCEtVw8ZGA0S9LNSyCKUsGFE9kc+qiGrt4s
         SKctwLFcCE1++EcU20PMm78NwBvY+JPi0vbmuJlsEUxnyu+8kSfHLlIRHC5xIrBgQ6fk
         DOXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779490959; x=1780095759;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+lqWW5xTN76UwAfrRbxGlO2NBxcf8RIbZZTDif3+3JY=;
        b=BgBpGeFSciGTn8Tz5T01KRO+GH77jN4FqvyzkZwD9EJwWfaB4Jgj9pHurOu0pTB4vz
         KM76MYIKqo5isvuUgAreQh/r96r9SlZ5DvCdHExBoyJX1YWgWIS9NFIqRavtmnCRsZ2u
         wpatCzMjuosvuqwNX7uhbcOmFGrOLKAafHxRCPu1VnmHvi/zgu3ryDpxl3Xgm6siFKOp
         FAGHhOQw+TnJ5Q6kflSFuqMSyl9KeRRKSqvfZ+FeGnTjX3urj/5Lqb4u9M2XIYDivfGb
         EsAEihug/arXvd+JbmTStAe+YshfhYiALNNiTjk9cliz4kQwEqu/EQ6112CPmMyme8nd
         sZTw==
X-Forwarded-Encrypted: i=1; AFNElJ8gQ8aWfuzHvsxeHFe23tnGbRmnqFKqba5Z4Dbxv64ySSN0zFtzz7tY3VIg4HDi0XsBp0Aqny1x5Q==@kvack.org
X-Gm-Message-State: AOJu0YzF/IYBwUytAvCTD1pnnisbnFTuIIigmgWFR2si6WLQ2Ee7K9/6
	LZdAwpglm5Geq4SA8NI1VM1wsJ0XeIdk2QyZVppWJg8jNsjeIPvM/bTJzUaVlVNJeNu4fbr1Vng
	oRqILm5jUkW0O8p9mocQhF3/GTtzi5aIM9QmjUtXY
X-Gm-Gg: Acq92OEV2Kq+cwmiEJhDaO8AyFPkqYQOqSmBKibWlXhFFBH0GzYRDlizcXPcZQEpN/z
	e64Dl0RnOy63jSE0aAcJc+fvFIRyl5uFtljoYuQZCkwPDW1cU1LnjSHvLO3HBI8jhypymOC/wur
	IfvWl7LqFgfRhpreoqVTXQhf2CYQGUz9BQHXUiwdogP/9FmJuuu/EwG/xT5cSMdtsfoIBoi3nlB
	hXTHWl/NaSXDDsKFqfZuyzca52fDRwLWFz3ZQTG7qz8IyqBm4HQ3TzjwYjCpi5Rx+uW6FcYWUr8
	G/TD93cBWsqbYN5xWVAitwUVt8oST++uohjTIGp6+5vuDmit4FK0W0+fcbWFV6HiXqEwSW0oCfh
	agYLI
X-Received: by 2002:a05:6122:1796:b0:56c:db8b:504e with SMTP id
 71dfb90a1353d-58663966692mr3461861e0c.13.1779490953839; Fri, 22 May 2026
 16:02:33 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 22 May 2026 16:02:33 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 22 May 2026 16:02:33 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-25-91ab5a8b19a4@google.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com> <20260507-gmem-inplace-conversion-v6-25-91ab5a8b19a4@google.com>
MIME-Version: 1.0
Date: Fri, 22 May 2026 16:02:33 -0700
X-Gm-Features: AVHnY4KLpjLWXQlawB-gZxOwicuZUmspmndJ5b1mQf8zRUUhG2Ao-NrVmxpOgcg
Message-ID: <CAEvNRgEHf67kpLtNyET7cvE5hWfXHqNrwv9cP9bRUgk_NKb+0A@mail.gmail.com>
Subject: Re: [PATCH v6 25/43] KVM: selftests: Add support for mmap() on
 guest_memfd in core library
To: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>, aik@amd.com, 
	andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, david@kernel.org, ira.weiny@intel.com, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: E54BE100003
X-Rspamd-Server: rspam03
X-Stat-Signature: 9fkumwqisg46easse1xo4dnj1mejzcfg
X-HE-Tag: 1779490959-251749
X-HE-Meta: U2FsdGVkX1/xy3ZrL5J2oTaeli7zhfBbmn45HF46O4YenEYj6TVYig8R+GlHfDmSdh/ETVuFVuiHoLjos15NE5uCy7kk9VJ7qnnsO97k4B1AbN7ks3TLFTjBIsGMRKrquyNPiOtbDFeq0ct4xBeAOvxliQcTS4PR62OlXNhizRpmwYg1EZwB+pAvGyEkv+qCsOVtYIZfO3kC5Qr3MnjyGJ5GTgmmEgHOrPYk1fC8T9OcGL3NqeO7TG2uvqnTaynjFSHi2vQJWa/rxtrg3n26Dd/BoA1839GqrM5GCnbHaoWJLKdCj1w2WBWxhchy4SZoAy5isuuSIuYjVpGMqdi2miXoMMcOfZ6IALPbG4NtuPW6zq6ZBiinb1fOEmMsa2Yv2GZ5YtRrQfKyq/W7oI00LCh3t7dB84ckgUc1t+DrgM5wXBMLRzV+7LCSHjIzoeGWsHkSspbegLhrqqlMCbrTsWYWJ2IWR15jYOc6mmbKmyov4qVhJZwGksI/glKx1u2NqpnbgtokvE4wi+pqqvCyxetn5vZ2wM7OX7xl/d98XtLhIdgnzwgAEQifjLZZ3+2CS9aTvs4yinjYrUctF2XxZyQFIy2YushNo5Hg7WiNf1di8WnIg2icyNYFVzeXGjsUC9fYclV00AU/nVnC/Vp3hpWyEDxELhm5APdeIB3Llmu/kOhR8+tFvNE0CsB+iMxbUohOQUc0xBpLVKeHEl9vbr5jNdTMF4mYXrKj0rfpNGMgTsRGZHxu29PpWtJp0KqE1Wf5Z7+GolLYtd+FdhU7izB9zGGzdxUtoLuG1PBQfJ5DbBjKydKFnEP0igyZsN6bXaikP3NF++SmNmRb5A/U2PnsLWK34LUxUwrR0HtGXeE0Km6sVaIiObozV3eTxSANoNr4BNR75Diyjw7t844Z5GjtIrm8Hva4+KlUOy+t0WOaii8EcGzKtNbQ1OPYuKUldRnwoDuWHY+w7uaqmLG
 W+S7nxQo
 00u4Xfe16PWJGqcATJloLnDij9mdmAsGGDujnw/Gy7ZEFatPP/geoM65bS1QC1G8z205elkSS3pkxXXaSi5mtew6SpkwI9CY53Lzlnlc9JG3PB8eFS9MplHnbkhHLKbvfJTe2/BvWvASI+Suveg5yq+KbPZl6IqEgENE5PSdj81DJr/JyR+DF3CP7+Sny1AEQNdxm74AcTz7iwm92BxgrEx+STIk8hWbyZt4wp0dv5nEUJ3dGV2nKtFI1lwvaRgT20RA0Jphlz76XbxunPkV47xAQRnx1ErRKOULHiN9RyZdH6vrtHCd0xyKlIxAFLtvJzVTZBNov47D6wwkoncfDvtNkKY+u7AecjHcA16iwbd89PgATrsXYyVctlixbpY88CX7/q5hefHvn+CPntWnRYIEItmj51aVUO08V0aJe9lretixOC4VwimGk7aUF0OW/JYeB6fzoewLwfm06fNzf2+yaEklx/BiB5Ojc02Rx/+xmYwOrPWrEaeoj1p4GTuYwl9c4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
writes:

>
> [...snip...]
>
> @@ -1078,13 +1077,17 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>  	}
>
>  	region->fd = -1;
> -	if (backing_src_is_shared(src_type))
> +	if (flags & KVM_MEM_GUEST_MEMFD && gmem_flags & GUEST_MEMFD_FLAG_MMAP) {
> +		region->fd = kvm_dup(gmem_fd);
> +		mmap_offset = gmem_offset;
> +	} else if (backing_src_is_shared(src_type)) {
>  		region->fd = kvm_memfd_alloc(region->mmap_size,
>  					     src_type == VM_MEM_SRC_SHARED_HUGETLB);
> +	}
>
> -	region->mmap_start = kvm_mmap(region->mmap_size, PROT_READ | PROT_WRITE,
> -				      vm_mem_backing_src_alias(src_type)->flag,
> -				      region->fd);
> +	region->mmap_start = __kvm_mmap(region->mmap_size, PROT_READ | PROT_WRITE,
> +					vm_mem_backing_src_alias(src_type)->flag,
> +					region->fd, mmap_offset);

Sashiko pointed out these:

1. When mmap() is done for region->mmap_alias, it doesn't use
   mmap_offset. I'll fix that in the next revision.

2. mmap() may map past the end of the guest_memfd if, due to alignment,
   the mmap_size is increased. That is true, but I feel that that fix
   should go with a bigger clean up for vm_mem_add().

3. vm_mem_backing_src_alias(src_type)->flag may contain incompatible
   mmap flags. This is true. For now, when guest_memfd is used with
   vm_mem_add, the src_type passed has to be VM_MEM_SRC_SHMEM. I think
   this also falls in the category of doing a bigger clean up for
   vm_mem_add().

>
> [...snip...]
>

