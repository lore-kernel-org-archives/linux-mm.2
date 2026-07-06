Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0772C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 18:17:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9614F6B00B5; Mon,  6 Jul 2026 14:17:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 910D86B00B6; Mon,  6 Jul 2026 14:17:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D8976B00B8; Mon,  6 Jul 2026 14:17:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D1D76B00B5
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:17:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BB5E8C0F16
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 18:17:45 +0000 (UTC)
X-FDA: 84959160090.16.895EB44
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf25.hostedemail.com (Postfix) with ESMTP id AFFC8A0002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 18:17:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uG7lOtbg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of ackerleytng@google.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783361863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c+wxJ1Yd1HSbDSoQd0ZgV/xzQAnAHKSd8sgBz4R4ZFc=;
	b=RVVwXOuxnXyJUGQLkc8Rs3sfcR60l9ObMgGX6pSqxCA8VtR7ep1SxMyqY/QthWbeIhDes0
	Q+CTAjj1H0x2S1hQymRxUJXfZmhh7ANVpHn0hngUCHCOgcH/hE7y8Xe56gSdu0WqZeBmlh
	piLAGSQ/36/ReBfFftcQMWeylOqHZCk=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uG7lOtbg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of ackerleytng@google.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783361863;
	b=KkUOnwNutsL5yVPxePiLfKA5N4XyH8fgNDJU69V32IPPIJHzPQH3oexjGk/Fs/yl1m4YBl
	YTOqMlvemnZpTi7RGtt/R6JdipQbPfrglFdu1DLUUcWZ/IOO3XGVVUUxZj8ey0X/6wEE+D
	bNlxFPZOoqz3ls7ZrVaVKj36/nIPF/0=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c9a20f70263so83116a12.1
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 11:17:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783361863; cv=none;
        d=google.com; s=arc-20260327;
        b=ANRiEWiWBXRBxyiH3RNCdoV1Ugs+paQAN5cttxRvlhya8PrLwhkBqW37MTbtd5cZ0w
         L/llN7KBQAOWe4NccF0CkYDAjkXKmplAmIJi2jLDQ1uPjfEqyaE9E2FVPXMeSmiIqxvx
         xwVYJ8dUA4M+Aia7Z4QRLLWG2EWn5vKbHINNZu9h0M4oR118IanteQ8FM3kqXp5OUvoR
         sio90Qqnwhrd+4Tz36zyeDE++cV5lX+1uqTnlFyRreGw35A9nASTypK6UWhT0D1DNL3E
         +oGI5Ww+hiZHby8Th87g5n/Ag8r+aHNvV9gxgxDLD1J2pxyOVJ/u1YS7pYu6igxTNhvC
         CCTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=c+wxJ1Yd1HSbDSoQd0ZgV/xzQAnAHKSd8sgBz4R4ZFc=;
        fh=qPynZrTw+R4VjoJRdTOY8tvsQrv7CnBiq8Qi6+3Tcyc=;
        b=DdETt2dube0s/xudqM2U6LsWVQf/yXyZThiXAhdf61m7b9AD2/uqwufh9SCiShrxL7
         F0tNxNSSmRAd8Cw9g9ve+69slLEKEiliWykuBBCEUq0RYVl1148BJ5ZraFKGnjdMSsFe
         ViDMz9do8NGMmjL64nqJ1t1lqnI9IYxaMWx5ehXq2sivHD0uttUF+yR+m8WtlF7CLA/v
         DPLhnLE6HIMvSGzLuiZizw/hLEw1n3TyyOaEQUgLdcw+5cmd7a0st39XJmJ4Q49v4zVY
         FiC+d9bJaFPtj2jBEAe2OGUugb7iYd0rRQo2WsxaLE7kq1xcwBJYbwIOLULQnKEEs+rf
         himA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783361862; x=1783966662; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=c+wxJ1Yd1HSbDSoQd0ZgV/xzQAnAHKSd8sgBz4R4ZFc=;
        b=uG7lOtbgY5qzobo7UhjtKoKbBAuAMsaLj/yUSKqifovCtCyyS6+SfSO8GUzr/ci7fQ
         Ktp8s7HjuQWgjCtsSMGZG3S64cDDf3dGOYi2/KRtEqQrTvorSzguJ+a4LnW6545fpJ3D
         EyG/OF7XFpiftXiBqnwll+f6xGePNl8tVszYhwn6fEazNXr1okWZPdk2mFWJ5rV+sG6i
         JD7c7ca4Y9/oi26trODWMrSUAr0pUVOGphnDStr8JFn8jtiEKcJAqWK+zuFvDP0VoBZt
         zvLJxwYbRbZOs5FRnP59lq0uCyiS+Hrs/tr62IJF3vQK6M2ZgnBq0ojjom1xpTnrIixJ
         wygw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783361863; x=1783966663;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c+wxJ1Yd1HSbDSoQd0ZgV/xzQAnAHKSd8sgBz4R4ZFc=;
        b=cZwuqPu5eLKDg4MosCn/qyMMb5n22hs/9ALkbxx5vqXq9KxyF9FbEKbghYSwRcaFLm
         n8uTSLvse2ZvdRq3ZTGvygGwa9cCnXVP67Zl/ON85n4WAhboHgfgISxunlbCDO9Y7YD1
         vf19UU7TOJIn/ZU4c4pJ0tQVvcgREbb3OaNNFxtQSzLzKua7i/wNPEfibB2zED4vYjxJ
         CHViTU2yYJVpY67LDMD99UB+l7u0GX8PAA0DYJk3frKUaGCJ/LFmtsfVmPHVsS4QbTQK
         AEylo1+bIMqqL3Aq7FtoYEnOrXu0N7lkSxaOg2gxWvC/tlykiIX7XFPSGayGTNMtEmOl
         DxnA==
X-Forwarded-Encrypted: i=1; AHgh+Rqf9SqxljDEu4I1Js0zlDFB2AL0SfJS+kAF2NqEwVUcfUP74wN9JRWIlOlNDY24lu2blvPKaDKFCA==@kvack.org
X-Gm-Message-State: AOJu0YySvXETzbrNMsf/Ps62E+0VJulfQQXbH6dk/oQENuAB2RLhaoqa
	ugvVBYUjtZd6iE/gHVeRavqAwWj27RqqyQdP6nO5m9NKqxGaf3sSffFyW6P0TNUr8j5qq/g4WHv
	zaY/gimxwcqEuDWtCW3NlNL5fZGOYEDgyrQSeYw9v
X-Gm-Gg: AfdE7clTTOf7HF7TaUTnjD8KPChFsvFD5L98971i2/vUr4LB1rXwBBDn1kWmIzzyzIJ
	Gog60V0K6K1qumCwAEg/BthR9ovHL+1E4Ob3Q7VbdFd+nSN9FVofCxqLTabTOGBvnGkjtKqJ5hW
	4iNAXie6gNNuW2rlc1Ao9qEm+cE/Bs0QISLuZp1fCDiLA0JdUEf/d+c920zAJZlm9FtpfLZLH0r
	3OPavDyS7T9Cc9AA2+gjlkbc1aeNhWaqh42q+9iNHdzeFV6PmzqVh1bCKTV3v9Rhs49ZgbgRyR1
	Ydv6TEDOmTtZ2lIttR+/k/g+FtbA3mCITr0uZdMVZtQAHK/0M5yfpfDRgoLI3barfEPCaQ==
X-Received: by 2002:a05:6a21:6906:b0:3bf:79b5:ebdb with SMTP id
 adf61e73a8af0-3c01caab306mr16907533637.21.1783361861894; Mon, 06 Jul 2026
 11:17:41 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 6 Jul 2026 11:17:40 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 6 Jul 2026 11:17:40 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <114e2488-97ed-4740-a8e8-1edd991f26c5@arm.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-13-9d2959357853@google.com> <114e2488-97ed-4740-a8e8-1edd991f26c5@arm.com>
MIME-Version: 1.0
Date: Mon, 6 Jul 2026 11:17:40 -0700
X-Gm-Features: AVVi8CeLpju1khujHSRbueqIxtdXRIsffiKvTI6S-exNvUblyDgAMTgWeujtT7w
Message-ID: <CAEvNRgFKbKfTMkqh_XF-igm07qYWfRwYJ5SH7wHcLZnqesCzTw@mail.gmail.com>
Subject: Re: [PATCH v8 13/46] KVM: guest_memfd: Add base support for KVM_SET_MEMORY_ATTRIBUTES2
To: Suzuki K Poulose <suzuki.poulose@arm.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 84xhf3u5t7motxna6tphgcosi5xb3em8
X-Rspamd-Queue-Id: AFFC8A0002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783361863-424612
X-HE-Meta: U2FsdGVkX1+oQln7nsuA0C1Q9dCX2DEGBw6nap2Irbeeu/UDspoWrxxoIsDpMJX6v4yCR3zJbNMQDcv+7r50EA403r+gauWlGRPdDPKr2QHl8RYr/uYth6WtjjdmGaWPOEzWMJOHU5AO/OH+uF5FKvdSJudKONZlOgZoJvKW25uExNNjwoQ4x+BX6veULygkKn5GXwyLbVPWnHiiij8ScxpzQ1NcdStP0O/bidUrQaLwT47/Jcr152ZK2bFqfnFXp8B4VRSFBHfCFqlo4MQ3L+1gQUGGG6c+GH6mZcsBGNoUcsIX7qdrfBjtUhvl8dPS9Vl7R31wbZxuBBXfQXZPsXwFpMcGvh/EGGs1m9O/SlN0t0VVfbYNZyLk2hnXAeSwESseGXw25StKSasssMQhU1fOVvmW9wjt9Ws6tSoSyErT1N7ddHFuP46pUjv1/bD6JUFb5IbEza2Q6UPjuThBcdt9BcnEZ5EhUeJ86VyEqgYbt7FIvm7SuaBsRfEISiXX9rKV3bISGWEsGnAG9l0E5p+GOUGtOeQQc3Zw9ayBYgNNYC0eJ5stYyPAV/WcTRSC+/NBuEqhPG/gLwosMdcqC4d45x5KuEoKdmkpCOHuCKAhesdpqkevhNh+SIYvC2Urb5aTzgkP7TYMM8WqfYw/vqACjWKNpAmexBEsh6PFCg/JznzRRXzXTpUSmZbyyH3X7FVFOj+8p90MpAG02RFy2/ux+yfyey0dOkkLGKI8vBzlDZgiQ77Tg/Nh06cVgRWDBqWcKogB/yxAXfjWK+ST/bFCJjgDgxcnYNvzR1dR7UbEMx004p+FEk9jgJWC58dGFUnI4zsmFGzDVXyUijHJDfQAJtiR/cYMD6C5cAb0Si634U83iITcehmUMfpXr6I7CEMRgLilUMdpoGO93NIoSq4qoT5oJJBOTXukj2xbd0nPhs+TKwFYcJbdOnRxuKqR8+yxJnlOs0i9UjFJAED
 toTg9f25
 3gUYv0YXcnsq7K3jY3vb7Hl2Ee1lXeTW2SafV4PXDM6pc9qluXgUIoSLqsE9foiKuEpBROJCd/OxtkY7qN/LakwUVOYZ+BIIgzfT7tWx6cbSUdjc2mT0gHro8g4FsoJWWWDY/43qN3zs597dcjyDOd1xcedhFy+U5rNYJzg3hXtTai5ym7KOC/uj4mlYVcqI5g8du5U19/dv7g9WTYJtjI8IZ6tle3JP7B85kXUGlyz9P/22IR24h4IpjTDv+K8Y76jgYVj5D4xioMFVNWb3/T7BfgDtulgHJ6S+E6MkT5w10jFkcfoPjrC4hdJZwnkP4n3p3xRIVXyk7rTLjIzR0MkP+0mxA4BO2+M2l6B9IFRXWaDHqFQ9Zm5PXGnoCh8NHUrnKeVeate4yr/uN+I9jCCShq11nTcMjdKwotuEI+T8YhIKtVSxJyQFxtoC3sxIRYv8xq7qozDqJcNWjYFP8WKMaQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Suzuki K Poulose <suzuki.poulose@arm.com> writes:

>
> [...snip...]
>
>> +static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>> +				     size_t nr_pages, uint64_t attrs)
>> +{
>> +	struct address_space *mapping = inode->i_mapping;
>> +	struct gmem_inode *gi = GMEM_I(inode);
>> +	pgoff_t end = start + nr_pages;
>> +	struct maple_tree *mt;
>> +	struct ma_state mas;
>> +	int r;
>> +
>> +	mt = &gi->attributes;
>> +
>> +	filemap_invalidate_lock(mapping);
>> +
>> +	mas_init(&mas, mt, start);
>> +	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
>> +	if (r)
>> +		goto out;
>> +
>> +	/*
>> +	 * From this point on guest_memfd has performed necessary
>> +	 * checks and can proceed to do guest-breaking changes.
>> +	 */
>> +
>> +	kvm_gmem_invalidate_start(inode, start, end);
>
> I added support for Arm CCA KVM patches with the inplace conversion and
> I am hitting the following issue.
>
> 1. I am supporting INIT_SHARED + MMAP flags.
> 2. VMM creates the Gmem_fd with both the flags above.
> 3. Uses the shared gmem-mmap to load the initial payloads (kernel, dtb).
> 4. At the VM finalization time, Populate the loaded regions one by one
>     by
>      a) copying the images to a temparory buffer - Since CCA can't really
>         load the contents in-place.

Sounds good :). I see that you blocked this in the kernel by returning
-EOPNOTSUPP if (!src_page) [0].

>      b) Set the "region" to Private in the gmem_fd (via
> SET_MEMORY_ATTRIBUTES2)
>      c) Invoke CCA backend to populate the private memory via
>         ioctl(KVM_ARM_RMI_POPULATE,..) [0]
>

This flow sounds right.

> [0]
> https://lore.kernel.org/all/20260513131757.116630-27-steven.price@arm.com/
>
>
> 5. Additionally, VMM can mark the entire RAM to be private before the VM
>     starts running, again via SET_MEMORY_ATTRIBUTES2. On CCA, this
> action is measured and doesn't require the Host to "commit" memory to
> the VM.
> Instead the host can lazily donate memory on a fault.
>

For both TDX and SNP, the host can also lazily donate memory,
guest_memfd supports this.

> But step (5) triggers the invalidation of both private and shared
> mappings of the gmem area, from the kvm_gmem_invalidate_start()
> above.
>
> This is because, the entire DRAM now has, some portions PRIVATE (the
> loaded regions) and the rest are SHARED (from the Gmem_fd creation).
>   Thus, kvm_gmem_get_invalidate_filter(Dram_start, Dram_end) causes the
> invalidation of both "PRIVATE" and "SHARED" regions, which results
> in the destruction of the already loaded data and things go south.
>

This destruction will happen for TDX as well. I think we managed to get
around this because we didn't apply conversion on the already-private
ranges.

IIUC on SNP, zapping pages in the stage 2 page tables doesn't destroy
the data, so that's probably why it has been fine for SNP.

> When we know that the kvm_gmem_invalidate_xx is triggered by a
> conversion, we don't need to invalidate the existing pages that
> are in the requested state. i.e., the following patch on top of
> this series does the trick for me :
>
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index a97fcac34a0e..62e0427a49f4 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -250,16 +250,23 @@ static void __kvm_gmem_invalidate_start(struct
> gmem_file *f, pgoff_t start,
>                  KVM_MMU_UNLOCK(kvm);
>   }
>
> +static void kvm_gmem_invalidate_start_filter(struct inode *inode,
> pgoff_t start,
> +                                            pgoff_t end,
> +                                            enum kvm_gfn_range_filter
> attr_filter)
> +{
> +       struct gmem_file *f;
> +
> +       kvm_gmem_for_each_file(f, inode)
> +               __kvm_gmem_invalidate_start(f, start, end, attr_filter);
> +}
> +
>   static void kvm_gmem_invalidate_start(struct inode *inode, pgoff_t start,
>                                        pgoff_t end)
>   {
>          enum kvm_gfn_range_filter attr_filter;
> -       struct gmem_file *f;
> -
>          attr_filter = kvm_gmem_get_invalidate_filter(inode, start, end);
>
> -       kvm_gmem_for_each_file(f, inode)
> -               __kvm_gmem_invalidate_start(f, start, end, attr_filter);
> +       kvm_gmem_invalidate_start_filter(inode, start, end, attr_filter);
>   }
>
>   static void __kvm_gmem_invalidate_end(struct gmem_file *f, pgoff_t start,
> @@ -724,9 +731,14 @@ static int __kvm_gmem_set_attributes(struct inode
> *inode, pgoff_t start,
>          /*
>           * From this point on guest_memfd has performed necessary
>           * checks and can proceed to do guest-breaking changes.
> +        * Also, we don't have to invalidate the regions that
> +        * may already be in the requested state. Hence, we could
> +        * explicitly filter the invalidations to the opposite
> +        * state.
>           */
>
> -       kvm_gmem_invalidate_start(inode, start, end);
> +       kvm_gmem_invalidate_start_filter(inode, start, end,
> +                                       to_private ? KVM_FILTER_SHARED :
> KVM_FILTER_PRIVATE);
>

I think this makes sense. Thanks for catching this.

>          if (!to_private)
>                  kvm_gmem_invalidate(inode, start, end);
>
>
> Thoughts ?
>
> Suzuki
>
>
>>
>> [...snip...]
>>

