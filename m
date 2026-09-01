Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8A53C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 07:37:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B49E56B00BB; Tue,  1 Sep 2026 03:37:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFABF6B00BC; Tue,  1 Sep 2026 03:37:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EA736B00BD; Tue,  1 Sep 2026 03:37:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 736726B00BB
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:37:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E33F21C1E09
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:37:11 +0000 (UTC)
X-FDA: 85164387462.14.BE1A286
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 63A4B40006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:37:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fZxogu5o;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of pabeni@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pabeni@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788248229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sJI7b9uIFuaHf590ZX0b+HvWZoEv+dLMUmfbEqRC6AY=;
	b=XH078A5gWrN3K7LcGQCAyIOT2R4le9Aa/rqKv9nvomqePNKhsH4RjEJqUCpurvmGHkd4+1
	dvFeIltyXasmRQ4ZJxLJ1wcYa3NlEMNF1b12skff/EuxThA3dBsx8bnGh7HhDvPyJIEnoD
	MrKdALG0rL+F8N5bGgfJvVZtfKsFrLU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fZxogu5o;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of pabeni@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pabeni@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788248229;
	b=A7CNLHjJn/WM6lBqP8njGfgiwClnwkjqgNfFAd9+9Ajx3ZZIwaGl89cld8q/X2V+9jGsys
	yJ0QA/ec2V0q6lp/E01iYwfSQ6Iw5vLSnBjqEt7r14/a3Pe3+OiUHdhXIDxDhqPWzTgeE3
	FeAy+UiB7w0+U8eJuWcb2YQ1EZPg7dI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788248228;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sJI7b9uIFuaHf590ZX0b+HvWZoEv+dLMUmfbEqRC6AY=;
	b=fZxogu5oE2aq5NYYULtqjbn72COhduwYhUY50e9I7c9eIvnr/bRH3gEGJEa/TVLnSHpwJU
	3lkwSoGyrOiMRbHMW4CDoWx04uuN6W6BoC98hfmOJxyaz5h4XOcTC3CUD1MsT6dYVuHk6g
	xomXJANBsZvt03BKSTwUtjy8t/RbRlE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-118-uMEOxYRBOk20x4mjgZ9Hrw-1; Tue, 01 Sept 2026 03:37:07 -0400
X-MC-Unique: uMEOxYRBOk20x4mjgZ9Hrw-1
X-Mimecast-MFC-AGG-ID: uMEOxYRBOk20x4mjgZ9Hrw_1788248226
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49a1b4ea633so40246175e9.0
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 00:37:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788248226; x=1788853026;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sJI7b9uIFuaHf590ZX0b+HvWZoEv+dLMUmfbEqRC6AY=;
        b=FFKAR9NgUS1Y0830Js4s+NTq8Yp/KYdZJQ02VUGj4JVkKNWAxjeX1oBkYRWhmgIRNW
         Ofb2WEP2pgKy5D67xRnWYuHZUvr5y8X0lZw+ivoq4+shkWrRwI9prDe6xCXPd87Bxnc2
         lDdtc/WifiH40R5FfNwTeMt+ftsCMWmy5/YG40wbTKZpyH1z/3qAdFp3Sb9agQ36C2d9
         8e6q+1NOMjG8dNGN8j8Pnb3t95DB6bnOR6cogHfbZYAdxTzN2lyVLoWQ4UjFqYjTBMgG
         CvK3AtWTNVd0YIT/fAxTVg9GmEIj9/0Qy0NkoDPctKp0yUU7z63WVQ4uz0Idq1QEjqyA
         UIyA==
X-Forwarded-Encrypted: i=1; AHgh+RpxbiXUVydn6YPt88nD+RLPubu9luRjBkVntUijuB5XSJlj1Qa1m0hFnSGo0Ym8qg9YIe7d/tUofg==@kvack.org
X-Gm-Message-State: AFuF++kV3Rp9SXa3ccUP+6sZCbZe5AYdM2wo4oMbQB89hEN7h4VPr/zG
	/FA2CGUbZ2TZIUn6xaWm6ZrS+8dDVl9YvkHz0hu+iJzidEhzOvE3Zm5zYx/BEKuILOZLM/cVqXG
	CT6L6uLoWYEwFSTDZrjdAN+GHEeqq8jBsyMC574gksDHWBmWYEtcr
X-Gm-Gg: AR+sD13X1v6F38HXLPNu62792zHworD0gC79Sauyq13lF5lKdpiT9ovguc9KoTRs3D/
	pX51djdwJK6oXPpgxnMv0qmrsZVmc41N3zR7xiZ0weH/7hh5/QRfk+6wleeMeCq3xgUClF5vOtX
	paXzR1Ev9JLZDofTYo0YXQMd2mq2yjr+M9x5MPKi2mvjJWVrSdaG7O7jMrIwwTHQXXY5wjBlGRc
	VCosX502iIKbfjlAjs+HiuNl4r0fiJi2hjMvnTwI0rp9O2iSx316ppKXuVVSNLvslgZqnoWp8ux
	ACpgSnGlEUsprh9qtqZkZ9at/+cdJznUwVoW7dYAo9XmqVqVOcsD34DgV2ecTzzVNCxM82/GuuD
	/9qDa1z5p07Jf09pNvHUiw+Ipte9ybZ+tA+8YvF6SzQujxVBfnER+tWzMwF18P1d7SJBR905WnA
	==
X-Received: by 2002:a05:600c:3b2a:b0:49c:cee0:e7c1 with SMTP id 5b1f17b1804b1-49cdc57d1d1mr95574275e9.16.1788248226264;
        Tue, 01 Sep 2026 00:37:06 -0700 (PDT)
X-Received: by 2002:a05:600c:3b2a:b0:49c:cee0:e7c1 with SMTP id 5b1f17b1804b1-49cdc57d1d1mr95573025e9.16.1788248225616;
        Tue, 01 Sep 2026 00:37:05 -0700 (PDT)
Received: from [192.168.188.103] (ip245-45-231-195.pool-bba.aruba.it. [195.231.45.245])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cdce3e4e7sm45045755e9.9.2026.09.01.00.37.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 00:37:04 -0700 (PDT)
Message-ID: <3e84c09f-d760-41e9-a99f-0d86239b5ebd@redhat.com>
Date: Tue, 1 Sep 2026 09:37:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 5/5] tcp: Remove mmap_lock fallback path
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org,
 Eric Dumazet <edumazet@google.com>
Cc: dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, ljs@kernel.org,
 david@redhat.com, willy@infradead.org, shakeel.butt@linux.dev,
 vbabka@kernel.org, jannh@google.com, aliceryhl@google.com, arve@android.com,
 cmllamas@google.com, christian@brauner.io, tkjos@android.com,
 dsahern@kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
 syzbot@syzkaller.appspotmail.com
References: <20260831203056.838265-1-surenb@google.com>
 <20260831203056.838265-6-surenb@google.com>
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20260831203056.838265-6-surenb@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tUmzvbQcJ9OZBN0dVLwOwr2BrIJ_CNNA0GPBygK1zrQ_1788248226
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1a1rxpccpq89gfkybbyfuadhayu3fqo5
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 63A4B40006
X-Rspam-User: 
X-HE-Tag: 1788248229-164430
X-HE-Meta: U2FsdGVkX183ALU5gmxsWUY7Ehd6W35BYkTJj+igsZPTsCWXDI5wpHm1tE3KTuJHdGjzhSRm0B1thvJ0oGJcYK53vpcZ+SvpjuK7vQx4xaqj7SiCnBH+UmxkFeePNHxtw3x+cUBwJUNbN1f3t5SQeA+F89VzQiOLl85D/gfmYdla3TMy3u9+3DmSMA6ymPULzlAAefbuQ4l48FAXIIE9rPzVl+n9JS/NRfH/C7bOmnahWjxH/bRbCues3qglOJ7YUXYOZA+grs7WewmMuMDMEd0FnwsCppoxqNe0MPC3Z6YC/4LXK+gh7plPEw+4QRWEP9HTZE4fu2kEzjkes68p9PDBevsxOrW0d6pHU0nvRT178Ywz6WMi6sxqYwLYYu+f1IC02EGtObrKPPkZ8YmfjRXNPsKUDjN8ko/WRC9IaDsmlmoYnCa5neqaX+Vx8m83BPpcb229tlrLK2ud9OYPU0CkmFpDgs/hNAaDVeviq6+JC1UJxIPEDXhOtmipmj6ed4GIQWXvJDzvHFGa7DXu+9LgLuMPuHbdf+PcxK8756fGPTDWOnoGnZjsJ8XudQO3ARWMZCkIcNSKq+Hf4d1x0CSiwU5Ga1zjRJCpTByhCZXVIJahehf/i8NCGxeawV/FnX8pSPD4hz2QGf7sC8b5eRmjfDdPQ8T5F42LM+0K0+ZD7lvzyPoVwNDYLWZHat2dyVGIOVmg05+fjrcHllQYDyWsK7Rftdr85z48e5/Bc/UXp+5G/1j65AWnTeBFAhjMpeSR61fM+TW+zRMLvTAztMcwyDMw/1a6mxlYkbsqkDjcA+PN9oznAo5Lb+BrOE4oOLPBTLwQXcaItVBzdeKZ01ZOavwEEpiX85KUJdDVd0engsYvZhVzP7c8bUXOfQmXqjXdy6wub+5WhZGwUb/s1BQcjgOwl8Q8ra1uviGo6amwbW09sVyfTDtFOzc9oD7VjYoBpvysJg101iEAbwb
 KN/mLj6e
 3l38uno+hvSLKuqVMFN+9OI6bktQb8QBzVqrnZdRYOUKGFjaE4E3D0b0GKTeL+faiOXGo0k0yhU8KVAQKxQmhLVh5T5MKXo43JNw9cprYP9mPbcV/NyPWCW97O8y/AoULPA/svSnT3OauNBtABryjejju5JpcfCUDbcvDpY4P7Xck5OnP+uQpZGAkPRCQqiSqAW1lCqZ99QsIW8I7PxKAuD59zL0TxxVc6Fi01zRyTW8moCcVfNP7NCS/Bfe/6Ysjdw6uVT1v8vodCeXda0TbT6l0hTiMjpzl0dQ/b9bgqzuu94PIyzoR1DEKXmXH+gRdBpsEg1irT/fG4uN55uSsqZkwVmyeEpzoABSnmO9VGag+3e8Hssu10g5w2COgevoujaP1T02lF42sV6201LNFJVxFScu79zz+3eFqKfRh41ia8/YJP4Rykeg947j1zH4di1YI/dKmHWK+UQanuWjumElloG075rEknayWrzRNywOr6Znj52hWCWWHvFcLwTx68GU4ZuSQxG1wSFi6sz2YA8DJOjsK1kNHqpg/v10UKJka4YIAc9fT0N3gzqu6scziHH4zGdeV5NaMKGj1rzm5vdFc9MZESV6PbizKN13ascIoC1baeTypoC0k7Jxpt/KFWdhNeGY7K+fsT745zvKVINWa0lobdVsk+yNPdohEye/Q0hrp5dd9penx5URlenkt3sxINFusNO8TZLgMQ76vCIM0HIKTKKVmzEJfQk+U5fN0PX8vN+X4BZSsE8j9EEqUEdeG1xaJ9DWyvD65td93kTqjRTfTAAiKlpCR8fG4zxst/2jSVJ6dvYPkPmz5BMu0+jtqnvRXqkl/61WQbRKEzSKEpUZ28Dw+5LB/lb10viNm4I8nEjgVRh3AQGtuR7XEy5TSiktjVctyZNs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

adding Eric.

Full series at:

https://lore.kernel.org/netdev/20260831203056.838265-1-surenb@google.com/

On 8/31/26 10:30 PM, Suren Baghdasaryan wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> Previously, the per-VMA locking could fail in the face of writers
> which necessitates a fallback to mmap_lock. The new
> vma_start_read_unlocked() will wait for writers instead of failing.
> 
> Use the new helper. Wait for writers. Remove the fallback to mmap_lock.
> The fallback removal does not affect NOMMU case because TCP_ZEROCOPY
> is gated on CONFIG_MMU.
> 
> This really is a nice cleanup. It removes the need to pass the lock
> state back and forth to find_tcp_vma().
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Acked-by: Lorenzo Stoakes <ljs@kernel.org>
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Tested-by: syzbot@syzkaller.appspotmail.com
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: linux-mm@kvack.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Arve Hjønnevåg <arve@android.com>
> Cc: Todd Kjos <tkjos@android.com>
> Cc: Christian Brauner <christian@brauner.io>
> Cc: Carlos Llamas <cmllamas@google.com>
> Cc: Alice Ryhl <aliceryhl@google.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  net/ipv4/tcp.c | 31 +++++++++----------------------
>  1 file changed, 9 insertions(+), 22 deletions(-)
> 
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 455441f1b694..62defe70f3ce 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -2167,27 +2167,18 @@ static void tcp_zc_finalize_rx_tstamp(struct sock *sk,
>  }
>  
>  static struct vm_area_struct *find_tcp_vma(struct mm_struct *mm,
> -					   unsigned long address,
> -					   bool *mmap_locked)
> +					   unsigned long address)
>  {
> -	struct vm_area_struct *vma = lock_vma_under_rcu(mm, address);
> +	struct vm_area_struct *vma = vma_start_read_unlocked(mm, address);
>  
> -	if (vma) {
> -		if (vma->vm_ops != &tcp_vm_ops) {
> -			vma_end_read(vma);
> -			return NULL;
> -		}
> -		*mmap_locked = false;
> -		return vma;
> -	}
> +	if (!vma)
> +		return NULL;
>  
> -	mmap_read_lock(mm);
> -	vma = vma_lookup(mm, address);
> -	if (!vma || vma->vm_ops != &tcp_vm_ops) {
> -		mmap_read_unlock(mm);
> +	if (vma->vm_ops != &tcp_vm_ops) {
> +		vma_end_read(vma);
>  		return NULL;
>  	}
> -	*mmap_locked = true;
> +
>  	return vma;
>  }
>  
> @@ -2208,7 +2199,6 @@ static int tcp_zerocopy_receive(struct sock *sk,
>  	u32 seq = tp->copied_seq;
>  	u32 total_bytes_to_map;
>  	int inq = tcp_inq(sk);
> -	bool mmap_locked;
>  	int ret;
>  
>  	zc->copybuf_len = 0;
> @@ -2233,7 +2223,7 @@ static int tcp_zerocopy_receive(struct sock *sk,
>  		return 0;
>  	}
>  
> -	vma = find_tcp_vma(current->mm, address, &mmap_locked);
> +	vma = find_tcp_vma(current->mm, address);
>  	if (!vma)
>  		return -EINVAL;
>  
> @@ -2315,10 +2305,7 @@ static int tcp_zerocopy_receive(struct sock *sk,
>  						   zc, total_bytes_to_map);
>  	}
>  out:
> -	if (mmap_locked)
> -		mmap_read_unlock(current->mm);
> -	else
> -		vma_end_read(vma);
> +	vma_end_read(vma);
>  	/* Try to copy straggler data. */
>  	if (!ret)
>  		copylen = tcp_zc_handle_leftover(zc, sk, skb, &seq, copybuf_len, tss);


