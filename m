Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78AD5C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 17:20:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D9CA6B00A3; Thu, 16 Jul 2026 13:20:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 389A06B00A4; Thu, 16 Jul 2026 13:20:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 251F16B00A7; Thu, 16 Jul 2026 13:20:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E65EE6B00A3
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:20:10 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8042B1A0274
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 17:20:10 +0000 (UTC)
X-FDA: 84995302980.13.82FB3B1
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8EE1AC000E
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 17:20:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=enHa4MAu;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of ackerleytng@google.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784222408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hDpH4vLaInenlGkSSwc32ERdxUXfDeJnyW2zrivGsV0=;
	b=7gw98FxkNJPyTFErjv31mzyJjG1Q9ZZ/cIFcKAyolzvjuC7BnM0dNza6akW/bhMZM2qYtu
	mS07rokC+/PqVBisQJbtKd137odlY+N7P1s20oyJrmG9Chy3iWeUlP3+z7shcbEMdxLSwM
	TpbWcwXXK/YG+8ZmP7+c+0+JWIf3CX8=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=enHa4MAu;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of ackerleytng@google.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784222408;
	b=eJFPtZNDvC3heNVEwQznIhCUjgelsDiXionLkcE6MU5WXzr0JoVEk6z317cG1HJjrOc+dM
	CW9LTnh4HA2uYHaosmu4XaQ89y5nTOqRvD8HfR+2STRVdY14/ZgqvvrsJQtD8RuNSJ/4By
	2741enzurkqkhqmlYIT5UEa+tn8yMSY=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-c9e607d81fcso2313552a12.2
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:20:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784222407; cv=none;
        d=google.com; s=arc-20260327;
        b=fZlAv60DI/92St/0NPdCZJZfxdY19VJPNU/si9OSow1HtS5rpCn5YZrtN9HFWC+kwm
         LXtFIr3nAHi8No3ElkdpjIvGfyu26zhNKe0ApfvltIDLRWIwpGfeiGvbQ0YMFq3+q4Ob
         eo0IDKZCgxaKU2DwdeFtbqzMUHpq1szToWPnqcFe0oawl4RTRdNEqMjI9lhpmFocir0R
         7rWvRZrSAAqgCcbqJhA0gctyRXIcb2sfSh/veNZaHbOvBXy6Li4fLUBvuW1e/b7bl7m7
         zowR+9oKn7+d1T8iEX5UkbIAC+E5futhloFihhXSnU+dzHtqlxKBQydBBtA63KI1PErp
         5ZHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=hDpH4vLaInenlGkSSwc32ERdxUXfDeJnyW2zrivGsV0=;
        fh=FRRJ4RqIh40/RicqYK0bYwcbED4gPHN8NzOTetkaigw=;
        b=WaDPVYV2XVL8Me9VyRsZr88Awoui15YBHAjTeg0sBPvhHzh05QJR9auVoTHyAA1dYs
         43PpYcxZ6yEaXtDl9yz4UFDkaQxG46h85HiBLhnkH8vtIsLsf6FFTLIhRSh91NOL2EA9
         BDH4lsosXqkr0c6GVlkXO2RtJzIrdhYpmZrAxrN5M7mEXmt7oThykw+3B2xJs6YziEvp
         Tpyyncwa+0jSJ4l5zkvs5NKpNK4W9+GiSlRS8AQT/41ndw7nnieIsn2lj26Hh+uFAt4a
         2D0ovhNHAoLwIJz55bFiy8tDNi8CmGhZQSV1x9DurGW0Zt4ncuYvoEqGaHoVYumWJR5w
         q28A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784222407; x=1784827207; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hDpH4vLaInenlGkSSwc32ERdxUXfDeJnyW2zrivGsV0=;
        b=enHa4MAu0dN2dNyRF/NIDL8qu4XOCLKTvlgUY+VJ0nAc4pr3I3iaxaNuYRjjoX1qgR
         m6WyIGjyXMY7rHI8qFwuyuJLkqRQMLb2I7sgy7Z60bwyQC7sXKgi7KVhX7nUeg4vyErx
         jLVPFRm3ddlCUsVNCWu6FVc0nYKhIgiuCEcdmz0lkxo2db8csafT7urFwfHsKIHQhuyB
         NgBulGt66d2DO6+eg3VGh3MtApdFHmN0EfBH1kfWEnuHAIO7hv4f+aYFyz3ONqwxJAwv
         9pR17sHgTxFlg+v7c7G0rK3Ez5r28FtbcAaVaN3+j6C0RlJnTAU0w5pdIJuMLgMuISDu
         3WhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784222407; x=1784827207;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hDpH4vLaInenlGkSSwc32ERdxUXfDeJnyW2zrivGsV0=;
        b=S6awER3JT0X7jpIXH/jH+43rvJj3/ke2keTdnsKNhOYXKIW9S0+J2OUIvSkwQfrcxw
         72ZVYEZ2twW1eVK58jfwvvd8U1G5KL0p+ZtEL+gETW6UCk/yRsVTb6SHodZOj8q/yR1F
         rROYN03Ksqn1LYeO1RqaecvG0iEepJ/Dm5NQNpLg4ICy4lsVh3mkbln2ZYeQtXOLij9p
         XP59RosiBFGR2fBrHbEN1wtNYqL/bU2wuGvNVVTBQHh7pEFeXFtyJmViKC7xn2/lWSsq
         yY0QfauhsCP+vbh+u4LNVqh7L3fdt5SWXJQs5XHAXuBp1eSkaUg946WgbLMoEtrhs//x
         dhJQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpj0hKPMN+U8FAgeS2xbv1owpSDqzkzC1iJn9eGmp6fx5oyAVBUnY+lBfp33qsc5uMlp868hRvqDw==@kvack.org
X-Gm-Message-State: AOJu0YyAplKCTnH/1RnFUVRzbejR/6HyxcK0dJjgc1cOBMdTtyGCR5Dz
	w3nxdki7wMrJeZTxWFpYOaarT+MeaqFQCwYgAoRlMNUg4k0ocd7jvWDEwAq5/oS2o96WomPIovu
	kPfYmMvpIxrEwdyG3GmM6hbJTPeo+I7a/LLQgqDPK
X-Gm-Gg: AfdE7cmb+jKzU/WIL0Nv/ixmVDowDBkwdfRIlcCC6D15VtvB5QNZQnCOLOtt+oEBXsM
	sLus+C4z5W1BCRFwmhmhUlPsZ9CK0iTiIvgubRDnXDIcFfnT+sm8aouUsBZ/p4+nv4cAche7wvA
	hc0rjxBakF1AEtVhGqn4T7L7WwyECAKOKBxJwCFS8LjYWydZngFEFSmzHP9wh5qvmHPqXmt2Nwt
	BQmx77cLG911D/KgYQ3/WLE9tLT3TnUjThn0p05pJnIeRP5sL2tY8h/T3xXNBO3ZoXwVMBZhoTw
	V18QvZ3bOVMFlZVFRU2TJKp7VleN/aKV6lpPYua41fEQT9ql
X-Received: by 2002:a05:6a21:7482:b0:3bf:6c08:2b2d with SMTP id
 adf61e73a8af0-3c3a5e7a4fdmr21247637.53.1784222406715; Thu, 16 Jul 2026
 10:20:06 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 16 Jul 2026 10:20:05 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 16 Jul 2026 10:20:05 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <1b59fec2-a464-4429-8532-880394912af5@linux.intel.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-9-9d2959357853@google.com> <1b59fec2-a464-4429-8532-880394912af5@linux.intel.com>
MIME-Version: 1.0
Date: Thu, 16 Jul 2026 10:20:05 -0700
X-Gm-Features: AUfX_mxBIq-fm92f37AIysrX2Jjvm6RrlF5jRh7Q3ctlrGsM_3yjDZToekOalgI
Message-ID: <CAEvNRgEjPA5pi1RqpQWgp_hH2HmSnGhWaNiXtVBJb_VVdKD7qg@mail.gmail.com>
Subject: Re: [PATCH v8 09/46] KVM: guest_memfd: Introduce function to check
 GFN private/shared status
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: aik@amd.com, andrew.jones@linux.dev, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, liam@infradead.org, 
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8EE1AC000E
X-Stat-Signature: xbjspy9nxeue4bqh9w4g6qtcomdqd679
X-HE-Tag: 1784222408-638490
X-HE-Meta: U2FsdGVkX18TMFYVNePxRVwhOcHrNyGqmoekInOL9QUUxSjebtln50NLZclDr46xQKxx5sNMN9jaBgcvvUaH4hmiVjkdCR7xaQQKFoTf6cjOe+KqeaBNXnZqSkcuZCfeKJ5p27HlaDssObUWoNivOSDkznTylQ0M9TwWi5ERPfwH6d0MthQCRsQQfgDLMadHSRFRPpylBQXwkpqXlYdbs+yqh4+lrg3HBz7A/oO/OnOyzbjyo2R1SwWOIm4ljy1bzroz1RealkUgF5n4b732gi1UsyilkuJ0ZJtBKmb6ftwi1Q6tp/Ec3VYPIsfwcCNuyiNYMs6NjHTwR5io/0sLBdcSH6jKULv5p6PQiHniiBe/EICDetUGzfPGSUQQiqvz9aJTfFX/NK1tZi9/zxG7soWjAM8xBtbSpNW/a/ofxK7vupZnNg1F0VoITajBvkfDPrJHZxdSFjJ5UsARTyhUmoZ5vdD5B7a2OctPkWG0fOadAucSaqiz4KvG1FrvK9nUNQKUqJyk+OYGYsWAMACRP1LY4AtTkdBDNhcqoXLLh9IE1f6wRbgOCMdpB+mzSue+KOlvuEk+FH5etJO4HP76+K7MLrwnRzE/mZiTP5vUzittKLbQxsi9h3gnEp47y0fHDT6nAPZ2YDXUiqAEgczeIzN+k5cdRjUScsw50xTWSR3owSTTcgrsitWpV0/R84vAgQnuAORp02U3i1u+JlJOilKIXG6blaOStqdhXSVKT4h3BPXSDh6oxb+0YtwGPfCRMYiEkilO7sGtruTaEftkYhj92skyfoRVuFEkW5mIiL7VEXC8s2xPIMdtmtTwB6IYe7oCDYpZwWWg/suHnI30BA+fJHydLAmsI6DN9oejMyRgO6tp0njGhYZdlQoLG3P2bnL0BXKeE05g8a/jvbXZ7Hwn4cVyvUwUcE/opsrTqgLOUBBwCdQZzg70jhLCTiJYPNMaSTcYKfSqkchUju3
 WVTyar24
 WbfdhAREZGfexCraQ6KQrNmTxBMNMqmMz7zNGOJWxoBDGeZgT1pGE3SEvhS0DPHSG81tv+5YyRdY3qsphYj4CjvG0/yYPVPdSaBAp+/OBniL9Q3DBrBSkB1JiIyWyLER4fbOm2WH6x/AEa2LJy6EnqcaeTKZOqUVIGoK7SzW5LmBpk7Qp7sl8Jt0JkBgUhkSnUSI873gQ0C2Q/l1XEoXuVWESy2b6IXmvb1OsCUddK5y1JZSxaHQ04DTp6V1QjFYgJFspDxgqarGZe4RhNrTAFc6YhQFxzWQ19d6VCNFua90I1IanQFX32p5sVO6NnWjsyAyMydc+tlB4MOh6B1sIlcaWnvy0oTfkT9kAicnwAHG87zOYVtRqAFDGwp4FNF3C/GJ3cAmawEULGvM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Binbin Wu <binbin.wu@linux.intel.com> writes:

> On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
>> From: Ackerley Tng <ackerleytng@google.com>
>>
>> Introduce function for KVM to check the private/shared status of guest
>            ^
> Nit:       a
>  > memory at a given GFN.
>>

For v9, I added the "a" in the commit messsage body but retained
"Introduce function" in the header (save characters, and make it sound
like a headline).

>>
>> [...snip...]
>>

