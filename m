Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 958B0CD5BD1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 22:41:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE0E76B0088; Tue,  2 Jun 2026 18:41:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B91806B008A; Tue,  2 Jun 2026 18:41:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A80656B008C; Tue,  2 Jun 2026 18:41:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 986BF6B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 18:41:25 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 15CC612016E
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:41:25 +0000 (UTC)
X-FDA: 84836445330.23.E204D9A
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	by imf13.hostedemail.com (Postfix) with ESMTP id F3A6C20004
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:41:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=q5MeWUwu;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780440083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Zpj3jj8aTNr4p/iPSCl+ydGEAQL1021/sdQMyQbGis=;
	b=5OVJum3IvN9pSUwYSdbFPMed2BHqoMC6nbARQMKIf68VBYwujPckA5qQdlMFXW4LVjp80e
	2nzNOCkXSCmonyED4dJ03wsW7PEZVx7M6ypbaXHhkCBH2e3Sa/mFMnQOyqu/XmPmXloSlz
	Lps/baGzbYhdOBlywmHxNPAXhjk4Oz4=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=q5MeWUwu;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780440083;
	b=JxvdV01ge3en9lvmDlAlaY4C1ClCpP2BwqT9a4cLp46q2S20gnCnOnu3M+XClQwrI6By0k
	GBWXpZd+F6VAJ/IZgUNpzi1NNGtQFVfd+uwBmmaxkLHZqQmw8/3stCuhghiIoJTQmtFdeB
	PgSJay7dXG9wVnTM9UWYXv905sRX+eY=
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-137ed2e66faso1598016c88.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 15:41:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780440082; cv=none;
        d=google.com; s=arc-20240605;
        b=lvC9Q59unvPVcYBmqhHnEP13dbtxxnSoXdaN5mRnIddfkDobVUdC5xCkytc4VEieuX
         8S31JmgE8+WZQheqEgrCCRmH99M6L/NAk1y0Kt2MqBs4oqIpxTbHN2Ta9zHMJinEHeQy
         RpbQ9h91EhwV5sDL0PX4knfx1TvS6zptmrdz8GGLoUHTqYBE4ASY83yEgImS8m+pdKJB
         XRUrOwzHoDE/wr88T5YqRe7PmvpclxUoK0+pwCIiH6SJvqlIb1wQnSkhWUsun/8l4xmG
         42BXCZ4PnJClJ8y4EHBUYYPX+Lm1doNuqL4N2LrA7cE8t2H+6T3fJR1bGXsZecRjNjAZ
         LyOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:dkim-signature;
        bh=9Zpj3jj8aTNr4p/iPSCl+ydGEAQL1021/sdQMyQbGis=;
        fh=6xXQRvMtezh7aO6l80+Ty4QtK6dGZAzBkpJ60SxnODo=;
        b=gWpzhalBZwjK0UifsBm730Y7yqSs+mMRfk/8aQHFoDItHC2fWv/2szcwtMwNs5bFSh
         VhSrL28hLIJRuJZECdlka7zPFBgRo7ibCrMPTcNHi72ACl7iv8ZJVqL7YXCTjgZKbLt1
         bEyP7Xpuc2zCZW3D4JPOxYkvFVWnZYCNvCSVkEp2MGdXb9w3mLNVwCGdOx31Wbaw8lzl
         +8NYLETqBCrQc++I3CETYzBx+LAjUw32elb+Cy7te2aIW0vNaa9mNWl3qdx6MiReI0l0
         44uiWYwip2/04McbhjNEOFeMvS18UkbGOf0DPOQ0Xh6LFnb2/7Q9lx610GOrJ98PPoEq
         SsAw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780440082; x=1781044882; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Zpj3jj8aTNr4p/iPSCl+ydGEAQL1021/sdQMyQbGis=;
        b=q5MeWUwuv49P/2rdpgHkwPs4ec6sNuupeoSE53Tyg/0+6JQDjiHqZZNMxb9d6TwbjC
         Pywz4sWq1pYY0+VnypKPd43uAlGggdyXSCtTEhBniT+M1UY41Rr3rjusfsmIWQuh/G6/
         A6Z8KdJ3kAk0DwkBLuChjFr9Y57p91KU19B365vvJ8on8SIKnS/SWsoqZgXCLbZO1iJQ
         jaVZr5fpnZYhPM2NCcQc2EAeupKaYmV2L+wlShRgow6hM6qaXzh3Q6fzJWSPu9m3m00y
         1dQi9XbA4AVGn9kwth0wLtdSRvCmrhe1nOhyHTWHzQ9LCeTciu/1ZqTNZxfCXnscpQBu
         u6OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780440082; x=1781044882;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9Zpj3jj8aTNr4p/iPSCl+ydGEAQL1021/sdQMyQbGis=;
        b=s0L84Kig+y1SbJyF+1jq8g+t7FFIyCLNBA8WqGkHVzqoBT8Z2dNWXAytC0cufxR+jb
         5SCtf9Q1C0GvNXxutKCVDAgoUX/Jdk0RQdS+W9NCmUhGbcClfm56pxhOiP/M7il3olES
         qRR3t6tNolsvqJ2yzKkS2tzadiBL4rNuGZEtz18fzFq0TWWFRUwF86fu8n6NrEa+9XDy
         Vqlys4ipT/hIY90P12FMWubRzA7yUofiUyxuDcFfM4CKdY2+wEmEi1xMncIEUee5vVCj
         aVsNxH2f8MppabeM9sSm4m5jefuBGyC2EOQEIhZUnaQFYSKJ7pX/ReC1z8Q8ambV5GWw
         +4zw==
X-Forwarded-Encrypted: i=1; AFNElJ+OZP1IwRkPmmw/R1xgQ7/LV7GQTZWKnTnMbiC3jvcbmgXGfJ0cHBhjTJGKHf3n5N94F6plyuXzKQ==@kvack.org
X-Gm-Message-State: AOJu0YzSuOIaGq65EuyC1A2keZbJoefSsc5iXgF7w1Ye1/KJiMoZj//T
	CM/iTWiUKH8bXPp+uRhBZ8U3DRekCeMkjtap3/uBd6fO+qqUda4Mfw/bK2dHPkYc1z+VP55UGDh
	hAqf9/fsOCvjPL36UcIxpr5d0qaMpuxhy6Ag/lg/q
X-Gm-Gg: Acq92OElJW1BA0w/yPcqpviQ7kths+HTfLLhnL0DDL/FH0QU/QCD16U416QSGdrwB26
	aZusWmS0UzR4goxs5fwCDEVKEiQ+9d8iFmN5k1e+XWOoEwLNjnTma2b3dfoeDTenRjN1B/bXNbw
	Dhbkgit2s8YCEnH/di291JCKaY6ZU25UCbOq+q493y4Y9OCWePmV+KyNq61lbs9KCb02Z/aHAwq
	mr/9bB6ori9GFLMrnxfhI13SoogpV8A7tiMkpbwFa52+EcvgIc61ISOVorWrQeAOAR6y2dEKqzD
	aJP7c+dsKt4EYI1Kh6fiI0x83WY/DUkWwEiIoGgGjte+XtBToeSEgOn+XtKM1B6RMQ8qdsa6DWs
	jS0WwOWwzCA5AtsY=
X-Received: by 2002:a05:7022:6ba8:b0:135:5d4b:2096 with SMTP id
 a92af1059eb24-137f6bd71e0mr275458c88.36.1780440081068; Tue, 02 Jun 2026
 15:41:21 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 2 Jun 2026 15:41:20 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 2 Jun 2026 15:41:20 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <144bbb9f-39a2-4c90-8903-51521e022da0@arm.com>
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
 <20260522-gmem-inplace-conversion-v7-7-2f0fae496530@google.com>
 <d01cf1ec-b85d-4af6-9810-8107c0e2a4ec@arm.com> <144bbb9f-39a2-4c90-8903-51521e022da0@arm.com>
MIME-Version: 1.0
Date: Tue, 2 Jun 2026 15:41:20 -0700
X-Gm-Features: AVHnY4Il1A6xpCFYh9Ccj4ryfsVj2nvlEe4xvqbfHFojqcjHjss1rOCXb44vh2I
Message-ID: <CAEvNRgE1dCVAxJWd_hyFa8N=m9JLfn97ip9tAmvHxspWJ50oGg@mail.gmail.com>
Subject: Re: [PATCH v7 07/42] KVM: guest_memfd: Only prepare folios for
 private pages
To: Suzuki K Poulose <suzuki.poulose@arm.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, ira.weiny@intel.com, jmattson@google.com, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, aneesh.kumar@kernel.org, 
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
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: q1fujf53wpib1h6w83xbdptke1f5c5br
X-Rspamd-Queue-Id: F3A6C20004
X-HE-Tag: 1780440082-522003
X-HE-Meta: U2FsdGVkX1+75FWgWab56vZQRxca0qL51emw84IDJq8jpG7tepkjGPsE1+21Rtbxf2zfBAn3q/Ph5aJ33NCf/yEK9lQDW2DuGvZTvYsYmhHGTKWvyW0JNr/LE2//uI7QqW7qbraJzKvSXnqbdr/OMwGtr87EYAPDzHaxVIsnIi0mNed0uC/z9QIK60A+2aZzHudR85/0A9j35cucb8RAR1sd8SMztmFfqu61VzBt54r5K6HbseIDy8KKzwTuomIt5fjWwPJvC4iQsidhhMDlGNssovdOkoGwH6y62cabQV7R4kvYHeo6fH8mZ/5v2LhFPwsp6VcnLHU5y4bakn1NjmwUInk6usn4I4+urcFQLgYp9qVh3aHK439Nxu0aqlIpqk6sh7VsMEcEx1BWO55PJ8+pZvUFDGCYjtSj7q0OazUF018KejZ/dO8bGyUNlbahwrhvoaBVku1+WjktYUTTQVbw18XfsjOaSsrGU5HEI+Bra8gss5ayREs9opskxq2xQsu5H0c1h+7e2tymLfum6BDy7xHfAXIUS4qv3tueodSptT5LGv4eZa7un7f8V2wcSwSWa/vT3puFLUv3pLxs7yjcBkwpactO5NVKi0vqXJYwuWYFznd+9x7pAAkrj3H47eJx2z3gm4UfaPfrXKcwdvcNrCjICY/+3sbGmXIfrnNXxo8NZOVais7REwYB2exhCHRS3iDHZHV2R3Moi/UWjfgdMkqWf9yCAyXkrwt+PaAqkeuhVhfo+ThHsZYYOsSmLi2S8PBvJA0rTia7w/C/F2TY//zOy9lssV/Z4a1RCQjp0GghgIFrTfH0Lp5ZLdzM49YPf/rkSv6LXmPnLRsZPVYwqoRr0lLVIzYmiNawn5jdASpQt2vfGR+sf4ajvzMHxk1giWRyteA6UpMOVlKXQvMxqfOkHYbYWvXk2hMF734hcxt/5nJUZaRTNtIdQViSxJAOBtgr8vAkWJ43o+Y
 R6lC7weu
 Goqy1cHVibBwI8Y8voCW7j8bUJaQoNeCgI11NX3/Dy5BI64zpQZU5fLFFqWbLqagnMuamjA/t+dz+dFEgM12DRLczDewo3zMkrt8ngUZhDfZf1Gc8uxckb2SEPhvWz9X4kxrosoeM8Q+5Ls8JwlQ5TYrciNy2E7uDi9eZdOPsvA73eVT8ev0v3RvTqV8zZFGhLeybJJJC5YjJ4LrFQlWgX00sYfPkmuZhmm5yKU3MAleJ3Kq5r+0oi7mqvZAJT0EyGPF9y2IfWisQQNCGHWzGq03uGPLONPLOxYaz+W4P0TOpHxJqwNDjzEIoNedLdJEWU7nWFltwgI/tRtcc0MSZha3MAXOrzqzUxX3QZhI6SAgZdKLNv8PAk2tJ/6xBLerptNbcw2HFLVR8LzDNUdbTc4ff9fHTJgjvwPc6Ni4BMmtyl7a4z6h3j7fvqg==
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
>>> @@ -914,7 +916,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct
>>> kvm_memory_slot *slot,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 folio_mark_uptod=
ate(folio);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> -=C2=A0=C2=A0=C2=A0 r =3D kvm_gmem_prepare_folio(kvm, slot, gfn, folio)=
;
>>> +=C2=A0=C2=A0=C2=A0 if (kvm_gmem_is_private_mem(inode, index))
>>
>> Don't we need to make sure the entire folio is private ? Not just the
>> page at the index ?
>>  =C2=A0=C2=A0=C2=A0=C2=A0if (kvm_gmem_range_is_private(, index, folio_nr=
_pages(folio)) ?

I was thinking to fix this when I do huge pages, for now guest_memfd is
always just PAGE_SIZE, so just looking up index is fine.

Is that okay?

>
> Or rather, we should go through the individual pages and apply the
> prepare for ones that are private ?
>
> Suzuki
>

IIRC the plan was to make kvm_gmem_prepare_folio() idempotent, as in, if
a page is already private, just skip. Currently sev_gmem_prepare() does
a pr_debug(), which I guess is technically still idempotent.

I'm thinking that the information tha needs tracking to make
.gmem_prepare() idempotent should be tracked by arch code.

Does this work for ARM CCA?

>>
>> [...snip...]
>>

