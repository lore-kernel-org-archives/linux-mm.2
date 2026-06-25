Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8C12CDB47C
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 00:05:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D2696B0088; Wed, 24 Jun 2026 20:05:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5827B6B008A; Wed, 24 Jun 2026 20:05:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44B766B008C; Wed, 24 Jun 2026 20:05:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1D0616B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 20:05:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7C5BC40512
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:05:50 +0000 (UTC)
X-FDA: 84916491660.18.EDCAF0E
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8AE1A20009
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:05:48 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CB+3owSE;
	spf=pass (imf31.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782345948;
	b=kGma3cTxeczTnqz67Tyyiw7u0oiNmrVmzYQmofPUF1D2hE4wXmxGAZPRBWyItt1v9UHGpb
	/Q7gO6P/N/HTDxheQmd7WP2xfpocw8Tvo1rBM1hBBtuuAaa2CIKL4s3n6d+TYL0vhjkPtQ
	QAHhF/3UN68eu3x9njl2gtyRlGW+6r4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782345948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FpepC4xFaJGVnjf18g1C8zYeq9gRMdq/7IlUInDggZs=;
	b=lETrACao6JWuXVnvxZhARMMor7BbPTD4Nkfz25Ig96+XRRM8ghRkxBVvhxmko8XvpCcktb
	RJM9lZr8ZKk9v+2hcALM4+3yCV2POEOApRdIz8y+C8GgiQjOVY+yQszn0qSxqQPe3kzVEN
	XxqJtqTKgYn17iKTN2O15tjp6oax+Xw=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CB+3owSE;
	spf=pass (imf31.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-139a71baa35so4316979c88.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 17:05:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782345947; cv=none;
        d=google.com; s=arc-20260327;
        b=GSHL8+G3BqX+dRpf1f+Q/OyBcaRa/kDS1kBryXASuaVPLyemBzYI4qn/948eW8uA3P
         nJGBoJQJjduzFwlIKnkZL+LUc7GCqkzLE82JfQLEXF9s6G9Ec6/lRisN5oc0C8fmWDkI
         9EUTTTAvfqcPQ+An1tj8Gwl83ESYNkB1tbJ5jkv2CIe+YI3IQL6HYDdJ0pa0inFmEQF+
         IRfNJfgSYHpq4ZLUQiyg1z+/KHbya4Q1ttsuF4ZhZ47gkp8ubbYMPs+BLhYfVhiN98Vo
         TpAHah3mLH1F1u9rSqxMpE+so1ZhjGA+DzD6obJAW3hSZG6ApTrpfeOz+Gjx3MxXXnkR
         oHzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=FpepC4xFaJGVnjf18g1C8zYeq9gRMdq/7IlUInDggZs=;
        fh=04YqARkjyhlMtN00EhA8ioIZ0lcQOmFtuGP/UK60N4s=;
        b=dGmB/IzYK3t8t7w9FGt9IlTpUlEp+9ZQQpQtG5couvSoLUzkmeXQ8pGMv4hAVhu6V4
         vZWIcU5oY0Hh7EESKabEgvI3YMz5xwq/LzI3j0GC76WLRtaGOB6wmoUDqeGFUBOLtWgG
         rtSuTUd/zWYymtDl7cOr2uhkXrV9PtiPVuxyQUKosqWLADMWfxtTxi1HbSRLfJWiJV6L
         4Ly9XTiS9mcJTpYZqJ2fpf59H3avWgjMgLd10FMBd5H0dRusudAHPfbdFwfrEKc9L6lm
         7YxUB2SnFFdSqUqD33R8CuMZOeH94Si6bxXp3XkpPEl8nv1/v5B8V7CfabV5lYVaa7UZ
         TwqQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782345947; x=1782950747; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=FpepC4xFaJGVnjf18g1C8zYeq9gRMdq/7IlUInDggZs=;
        b=CB+3owSE52R+YRqBEcoaT5/Puq9Nlqm60y2MAMhBl+hrBlFfSU3fSCrUAH6vHPOoBc
         5bdKVSlX5NmqCjrfF56wPcbw3PuYDnLWH+lyMfwmkrq7FkD2YQcVy2kECwMYj+Y6nBKr
         yhFauCGknAyvKspwlM/D6sfuWtpvKaXEdSLPkXgM/XkaWuAum6b37htFL8Dil3YWLf4z
         5FPV4Gf9umt1ErCgqTS3jEYKu0aKwbQRQkeQNgihgZgwVP9UF21j65ANLwYWW911CYkz
         z9D1+XmH8wqhxGjFVkS8t+3BCbhP5gWft8IIzvozuZOLkCy+9/YLq5Mus3sjmww/f6tf
         Ojuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782345947; x=1782950747;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FpepC4xFaJGVnjf18g1C8zYeq9gRMdq/7IlUInDggZs=;
        b=q+ElyyAuAHIVGp/yZYO773aCNJDIaGWJtgCb91S3SJvyCB5n23EJK/bB4CQ5eLNzC9
         ekY79zR+MFr8vYs1tgvEfiFdDsdFIBFpnPobRA5Le7E37+ZDDLFECTrRvjF+7HaaP49x
         msec5niFOL8gt6HvYRRi8nNYzBvD14WCmfyysH9PtTrd4mw1qGR1SDV6d3wmadjWqh9a
         qAWhwecT9PYsVfdxW9ZJoDQWiheYthdouDh5Qx/Z6Sxci0C/NFyX0P67amEd/JJctEL+
         Gxc4bufR1KddOn8shyqk2xRugIWUGMJqJfgqLlP3nareU0Yia8AKjEGeOExSk0Vq6RHG
         3lQw==
X-Forwarded-Encrypted: i=1; AFNElJ+Tqtmr8D+H5KTNtdYGwkhcJNB9poSme8zSLYOLE/JcWDlOpT3AL6EWXJwwzzLsJJk9rsNuNVTyww==@kvack.org
X-Gm-Message-State: AOJu0Yz1XbHxOJV4xxRMOp+o7zRj/n4YCbbMlStc+QzS4QT0D51rZLK6
	V1PbSHi6jIyD/tneX8wVVNxZsj636Fu73/soWvZ37f2ODdM22YFLMYicE0idlhB6O3MNhOyQMjJ
	x5Lv0nP7N5/CUEkbWdW0Rhu00vP/eghFFqWVIlg6Q
X-Gm-Gg: AfdE7cleuCD/FqQjut/CCcsIXQfimg7eSRxEiViwmaynQy51cV2D4CnoTjSb+hMbrb0
	O2vTr8Ksz8SKY2vG5LXCXT920IPlzMYtKS/MzVTH3QxhWb0Hdl03aoDdjdaVC81dDufUPko00QL
	06bycpbvHcvI/bFHPahkiZDr0xQXRAElBndHI/RyNJlwfquNHpYGrj+xoYSEL+8HkNzNtq4dRXJ
	BEF1ZFgu8koL5O0pS78UhWZdMFHqaif39sjlLqRUkUrC5rMO+S5bZmv2qwrNTEpZnwYZSaZ/zXQ
	07D8X/6NW1h7DPh7tQ0gKH+YKUZ+/RAo09kfpzYY/u4b17ygJ7UU2yqwNhs=
X-Received: by 2002:a05:7022:e01:b0:138:49ea:f463 with SMTP id
 a92af1059eb24-139dba54880mr251235c88.16.1782345945708; Wed, 24 Jun 2026
 17:05:45 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 24 Jun 2026 17:05:44 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 24 Jun 2026 17:05:44 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <aji/2svhcc84rn5w@yzhao56-desk.sh.intel.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-24-9d2959357853@google.com> <aji/2svhcc84rn5w@yzhao56-desk.sh.intel.com>
MIME-Version: 1.0
Date: Wed, 24 Jun 2026 17:05:44 -0700
X-Gm-Features: AVVi8CctoVihMuJ7SOXsg73Uq4ZLzDcGYZqps3qpfVHZ_IQN9jIN9AXdoFf5CH4
Message-ID: <CAEvNRgHYTFnHbsLLgMTCSitmnp1_j9Pomikm9qmpGTh1w8YE5Q@mail.gmail.com>
Subject: Re: [PATCH v8 24/46] KVM: guest_memfd: Make in-place conversion the default
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
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
X-Stat-Signature: mazhjs89tbsz8asetdytbo4q1bmsjnmt
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8AE1A20009
X-HE-Tag: 1782345948-255290
X-HE-Meta: U2FsdGVkX1+TkOQAg9dfcnFNQRSmJ/QbzS+XH4WZla9kYTgPwdLlcxZ4Mzx93Yn8GUpwud9o2rgmtypNpVndtsoLQ8UjtV/Biw6Zoc5+Nd55VbuVRRF3xqSQCDtrvrSboywcAWQP3lHZ9khC2a7qcQMTy1DVAl+OjME3/at1qid0im8Y0CwmaVPEUw577M2AJWEPC/yTawymtr+UykGMrpfIJ3HWZluLaAMewGVOA9Ym15EldgC+uWhdPiuBC7ntCLOBqM8yqbxsNehnV/gW21i3xmiZF6tBNCTgRLqdnJCx56z7OjNu0D2O6hrzI1C/sSAqGoYoGl3jcUTLUIF0OPZBdLWUgQYOqNOSnwuMmhoykG5dmWd8IfefqaaKTNrzgKp76V4JllsLr1hruq8qNw4un/omrFQPiCeayZ3ZQ6gd9gAI2gSmvcQIWbbKBCus7Z+lZOW/imcJHW/weKLnjxBSUEh+DemwpWaz0YBD4V8hC8tLLVoKhHE9FCVxJO6TjkMj4ztABl2Ezhkm/D/7nWIq1tfhdTpcktm85gfSUjaT8wF/SS5xhbtC/25tThdNY1PdzRQMafKlntr1AaQw91umPtVxVK80FExtpyl1Ye/3HIaIG4gd/Gw8VLRr8wU3WzHhCREezCbj5KXudBON8eFwvDgcnrw2wC0MSLj/WnGxb2/77MvRmvtO2SF8Ac6VPoa1g5hTUpOXucnq9Ri8INuyPW7RuBYo7eyArl4TCoUvX/218jE4jgU0udeUz6lkPJsiOH0UrMtbVKCFxfZ6d0aQfUZHxQsdW4xADYh2JRl1Jsdt1pNddo02kOHNRGc4KJiILgIqCK7v5CB+eFfnoy+bfpNIF2rnRswQ1jWirFEzlULGwP/FQbAmvh2TfpYkk9jXinaLkwXbB2thGwneCOPFXKY59b3ZeG3u1Hqo5IlT3zUE1s1cL2F6g2W4da1iK+6R7TZ52T4S6RpYMBW
 //y2gaMZ
 DHALAOrHXq0pDUgjfka/TUDeKnw6bnE3ocgxtSVE9mrkuW9BAgkyNgUB0RED1+DoIGwj7zFOdMfZHsnBOcHDfBL/J4rqwHWlLjWkZ3fGmgETQ0jJV7YXTrDmFBFYnC7WPuA195W1ceBSgSACGF2L8YNSGPUC+evUpXZwel4ZRZTtJCQiA9cMkEWQ1T3InYagXUHQXwFyTknAGJ7BZ4yrKTRizISWgrFiovrQ7BCr+rAs1F4s46h2Pc4EK7FjNzjFJ9F6x7USrqezT8XuHeKU9rIy+PPaCEzrldYj4kGa9ZXe6afeES+YTCt/DIn2kZzaTIHAi13qFDxe8u7GtPs05GtgXSoOxHADEGnXjMj4GTxj4KQerOuE7i4q/bC19e4ARcUOJUWadjB1+Dw3q1Y5Gvp73EQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yan Zhao <yan.y.zhao@intel.com> writes:

>
> [...snip...]
>
>>
>>  #ifdef kvm_arch_has_private_mem
>> -bool __ro_after_init gmem_in_place_conversion = false;
>> +bool __ro_after_init gmem_in_place_conversion = !IS_ENABLED(CONFIG_KVM_VM_MEMORY_ATTRIBUTES);
>> +module_param(gmem_in_place_conversion, bool, 0444);
>
> With gmem_in_place_conversion=true, userspace can create guest_memfd without the
> MMAP flag. In such cases, shared memory is allocated from different backends.
> This means this module parameter only enables per-gmem memory attribute and does
> not guarantee that gmem in-place conversion will actually occur.
>
> To avoid confusion, could we rename this module parameter to something more
> accurate, such as gmem_memory_attribute?
>

I asked Sean about this after getting some fixes off list. Sean said
gmem_in_place_conversion is named for a host admin to use, and something
like gmem_memory_attributes is too much implementation details for the
admin.

Sean, would you reconsider since Yan also asked? If the admin compiled
the kernel knowing what CONFIG_KVM_VM_MEMORY_ATTRIBUTES means, then the
admin would also be able to use a param like gmem_memory_attributes?

There's the additional benefit that the similar naming aids in
understanding for both the admin and software engineers.

Either way, in the next revision, I'll also add this documentation for
this module_param:

  Setting the module parameter gmem_in_place_conversion to true will
  enable the KVM_SET_MEMORY_ATTRIBUTES2 guest_memfd ioctl and disables
  the KVM_SET_MEMORY_ATTRIBUTES VM ioctl. If gmem_in_place_conversion is
  true, the private/shared attribute will be tracked per-guest_memfd
  instead of per-VM.

Let me know what y'all think of the wording!

>>
>> [...snip...]
>>

