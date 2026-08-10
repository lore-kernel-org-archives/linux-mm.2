Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33F31C5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 21:29:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D469E6B007B; Mon, 10 Aug 2026 17:29:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF70A6B008A; Mon, 10 Aug 2026 17:29:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B707C6B008C; Mon, 10 Aug 2026 17:29:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 749346B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 17:29:11 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E03F58029F
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 21:29:10 +0000 (UTC)
X-FDA: 85086650460.18.42C552E
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id DFDEB10000E
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 21:29:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=d3YnkDxX;
	spf=pass (imf14.hostedemail.com: domain of ackerleytng@google.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786397348;
	b=BGkumDFEovyjCV3oX1jeawYQR2Y3pkNkVGDi+8qk7raRIEFu0k0lbCisIY/RQ2DI6xl9Mg
	CH3DYcCHLOEBEa18lNL6RjNlaUgFl65LuFL1HrUTfKmFlxH33BQ/xcGwoBzct3fEpP20OT
	XTG5BQhq+UwxpDYKgeJ0aVg87BAbWnQ=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=d3YnkDxX;
	spf=pass (imf14.hostedemail.com: domain of ackerleytng@google.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786397348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wN+q38rdlKIr22xrGQOunHcrcy7dQztjwHhaozPCfDU=;
	b=TCf4FUNqEG77EKKMrPzKiPqZvegDIc0RaZpvqtNzKfg5cmETdnjcp1W/np6Jf4fXheQBAg
	mfYx7HwGpEchW04ZAC43YoZByMe6FLXJRNPJphL5l57UY8MMnnc/X6nKlh+HcvypHp0nrG
	0lfqVXkfYJnlPp+BKEfVNULfmjl2bhQ=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c999f162c9aso153460a12.3
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:29:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786397348; cv=none;
        d=google.com; s=arc-20260327;
        b=l54Wd3ax655wbohHq09u7CRy+j/JzS1SpZgYxHjUVW8cybaEBxIpdvPTomhXywz3kw
         8q8wLFzpgzpMFwUxSeX9wRhN6zVCCFLsmM/A3dG2yHwER1I3zvZqo4VsHNjy5DeWMjOX
         MbayIOXBQ/6y+UX1JN/w6lipUmSupEHa+1vnwYfOcfktXSWy47aPUyT1ZUXB8hV+SRXm
         9curI4YW7zM1YC2FjK2LYdJ6taUwOpzAPv6RVuTl92wzQPjilfMBE+xZuO/y0nccPPyv
         uBzNh2X+mq3mg6owQV3mkd1TA/USDDq3xT7fJkmI67GSjupZ2DJMI9rlNnpG0IAeY3/t
         3Spg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=wN+q38rdlKIr22xrGQOunHcrcy7dQztjwHhaozPCfDU=;
        fh=hkyIqdVipPcSebddPV23F5eUvMJIQZGhQbVP/cBG64Y=;
        b=H8QYlMbCKpPh940m/lyQl3WdGyuYl+epXhlWkqJtRMQuk8Xn5mPLSbj9+BWRBN1d1g
         DCSZ6N62FWbB4qkUOowddsGP377z2aH4KKi2ho5hacRgZkVkduETyYESyaXU8jhSNi28
         nyAJlzKmpyNnEXXx7CsDPE+SUeHRvHmg9QgzFCJWvfpdOP5lLi05rvBOMeYnEQilLPbb
         mYQBWBJ0I6npgegSXfU92JFqG7Lu6eDkVJimtLaXVL6KN2/fB8fRaglzBinctQApP1gx
         yodiHt36MFWYSdypJOPeI/Trz3f8OS8GpF4RhmcIM2MxrqKF3gNmLL0qps5WLJYxvEet
         D+hw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786397348; x=1787002148; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wN+q38rdlKIr22xrGQOunHcrcy7dQztjwHhaozPCfDU=;
        b=d3YnkDxX0/RJ/IN02ENply8+rTjiydwoUc1wi8tAV2zsiSAc3WtR9mvRNUZpF97gmo
         WpAcM4gPGPj8JkPqHZtf1s/5cbOJ8MD9inIQmImO3Rm5Y4cTVggtsjGPjF/PS+CsGw+i
         1WaJICvnNz3f1blBkZXVh/Gaaa61CqyR/SISTrs7mdxRvwK9RIrXACSh0+kY/OfG+18e
         IvXQJGRB97fbsX9Q8aceZRtzmkmd2UWLnqgQtlBMh5XIXM81N7hgmGAvSLXslYQkWjFd
         C8/2meZDRqzlcXsfLnUFFQ82M6MvFfLzLfVszZh0xbpxqGl17rosm7KpIIjKQ66LOoU5
         nvAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786397348; x=1787002148;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wN+q38rdlKIr22xrGQOunHcrcy7dQztjwHhaozPCfDU=;
        b=dSuM88buyvcLK8p/G6Zf2aU1uNdepeD0wf3WhG6q3bOFD9i7IRnOgvHMS/HH6wvmq8
         gWalXzG3UPQNSa/jlC3VSsp1XpkYr069h361G19msrcYihpQIA9H61qn+1LLONvHwfKu
         Rrv6EYsB7Mwa5SdRrxogmKS5oXdsE0QsLjHTdYl7igKWo9dUwKYVDhLTCAW9bePOLAli
         +s2341v9CvNmrJc8PpPIR1ApQj+ZSLsQWGXYzZlcKSzylj9Ae7ISKO3y/mmuNMKbNv2u
         cLOUeZqEoZTFVCnaCjQn/Vnfb5RKbkU774iUzA9lqQ9pntQsH6t9OAxqUSPiBmsBLdWU
         cOiw==
X-Forwarded-Encrypted: i=1; AHgh+RopjcbDXNop1qUXLcJxyBt+tIp3PpIekKhVjxkL2oDOH7W5Xie3tgsC37fy+UeRZGY8Cdd5O243gg==@kvack.org
X-Gm-Message-State: AOJu0YzOR5PK+1il/dn0evuDoP4YHbdqPEnl/XccMg6GoraKwX5HagwT
	vUMOVvmCn/QG+w/Wu745zdpzgQb5woKFfx+Db6uNJ0sLjUOZDSAFR4/UIM4KSeScZ6YLfoDSHC6
	STJJs5RbCNwIMQWRffmj+IQY1O0L5wFXSM7BEXy2M
X-Gm-Gg: AR+sD10b8y9Z63yYOlCOszipHMP+uGYlYZ0kGvKd+F2B4vuAKZOXh6a63FV6j8hA0q3
	D3CgLtBsITXrZvlSdIhXQAHTNhMjcEKIa1naw+9MNZcrw+lMhX9RGrHhHFEm+geXNyDii7hbeU6
	FrCgP0pa8r6uDwU9TyBoSq3WY9BZN3LIZTQGxB9zVa1ELqRm7webuhRCObpyHCK8u0oHUfId2D/
	Az3TSpnuKrsKWOflOOgPNDgxhsqkrcqXJGWPAUkQd61qhnKibXP1uFcM6FzcxZjQ4y3Vi+b3Lha
	H7suN9/+aX0k6u4iQrdkxaHZ0LDBs93H2fpeXx4nonSd3yTpIgLej7DnQxzcZh0BIZNCWH+7MEQ
	iPf3QUuuxz2EIPtZN6Q5TLrUTQ33oSs+ykI0=
X-Received: by 2002:a05:6a20:4321:b0:3c3:b57b:6291 with SMTP id
 adf61e73a8af0-3cb85e6689fmr49405061637.18.1786397346906; Mon, 10 Aug 2026
 14:29:06 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 10 Aug 2026 14:29:05 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 10 Aug 2026 14:29:05 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <aa545680-2fee-468c-ba34-cc9beb16f4cf@kernel.org>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-15-2fc18ee6d3ba@google.com> <aa545680-2fee-468c-ba34-cc9beb16f4cf@kernel.org>
MIME-Version: 1.0
Date: Mon, 10 Aug 2026 14:29:05 -0700
X-Gm-Features: AUfX_mxwV4sMMEn8xD5iLtETNHGAZsCJNscksNcNQT60_O-j0WNrenHXqsrVJ0k
Message-ID: <CAEvNRgFSdddvuT8ZJUPOC9BCAtBgx6Vk=UbbPZ0nTAz8M52dSQ@mail.gmail.com>
Subject: Re: [PATCH v10 15/41] KVM: guest_memfd: Handle lru_add fbatch
 refcounts during conversion safety check
To: "David Hildenbrand (Arm)" <david@kernel.org>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
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
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: DFDEB10000E
X-Stat-Signature: 3516p3xxcfh1uosr63gep8xi3eej18wt
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786397348-128330
X-HE-Meta: U2FsdGVkX1/eWWNXiKUpulLq+Lh1rB9GGlsC7DN4q9kctlmNld8u15iEuYNqLA4e6vF1id0v9ucSHvYCehF4HHxjK80mx3RX2lqNnMuBV1KHy4zlX4Yg9/9Z1iJcJLv1dx71Ci/mMQYHkJ13aFCnQWIayMBo+XOPo6TAF7eHIjsUYUhPkQN2oWbHk4R/2+bGk87JJfDh9hHMOEghdFGQwvxekv6XfxJFOPlKKYt8/w3Z54bKLgf/wPMVI9RRtMyB84J9FKkWuNgmQvI/fPVZDXHc2w9LDMv8cpjhj/VN/GKRYgchv2vp95aP9DyOP6dBNJiqScUlAbB9xjzh1F31YH1gkYDMeWuN202LE9KtXfnthatnHyw3EWL5b7vemFgg4CbCuHERfY/u4jGs2uQamxLdsKuMAs91kDOP9DEshgMPW+2CPQeAx+loRb36rfAzENSjRj1KTm8XamIwjhqvMRHDgZMSuumyh8pQSfMXSGVIy0HghW6o0UhnPwuh3yzfseKNEC15pja5g5KndlpDMr71Ww0TvWX9Mmp/w6j58/UvxSALdxZAbKhUEocge/9qIP+HaKZM5CwaCKDMWvDfe/Yy5hzCXqbUiZSmR4f3lasJTIaynTjila3ubvQqQmBhPA289MvYi6fUE4XnIrd1Fr94fbf26I2mqg3S+adFhmMuJlrBtBpaqDbrr/xtvu1ABPpqd9Ur/VYcOEtalu/dUu+CY6/3a7az3DF5v8TuKo81X6j5Uxxefc8Qjvjyuec8A76DahglfDVp0iDLkSiNpfvz3CDsH8dhZofI0wxqTyMjrxJaVY3YzfG8i1Vry3MSEmSaFLPbL4V4YcoCqxVUUwjbzMQRPSt0kWiL8JNkxUrzJdXGnIS1/60A80CTw+ZnHE+vH0C5hwYfQ8zaUvZI4OXXlZVrY3TGh9p7bYnVl/7JBopaTLRF/sDwSL2JfS+d+B20IWABoBc2rrA9H7c
 HePDtj8g
 PzG9SnyQgGS4f6RMiA/S3OEI//+a8SEI4m0pisyUfUfQIXMKjQiASHIMnOY8hbvhm/wiYvnGpB5CIc35NGcErx7iZHR+Rop1IF6g0hUGG71SHiwGlQFzGMqxBrRtlzZ1puWLDAbMox/giWbSputh5iTcltchq/6JmZ4yag8/fKxZeP+TKv1NH0fNUFi+aOIAnPKp9rRnYsOi9eB7Kb6qvazpX63ylluFBFF7A7FK/zjunUDpnT/f1jCpsbDpZj1wC/K0+CRSqD2Vyy7sXIWt1oODM0+Nyowa84G5PFW+muQjrv12e7RXCnaoPMFPwoT/7F0SOfXF2ilzZAE10lBSr//7DMaUvMO4IeI1RBp8a7kIzZ6CKN+p6aPhNr/nLcbo/0a8Fqit6kfdyBvY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> On 8/7/26 23:52, Ackerley Tng via B4 Relay wrote:
>> From: Ackerley Tng <ackerleytng@google.com>
>>
>> A guest_memfd folio is safe for conversion if guest_memfd holds the last
>> references on it. Any other references on the folio may indicate another
>> user, and guest_memfd cannot convert it to private if there may be an
>> existing host user.
>>
>> A folio will have extra refcounts if it is present in a per-CPU lru_add
>> fbatch. guest_memfd does not actually participate in LRU, but
>> freshly-allocated folios are still added to the lru_add fbatch for batch
>> LRU statistics processing.
>
> As discussed, what would happen if we mlocked gmem folios? In that case, they
> could also have been added to the mlock cache (which we treat like an LRU cache).
>
> But that's just a comment regarding the text here.
>
> [...]
>

To make sure I'll get the wording right, let me know what you think of
this (will replace the entire commit message for v11):

 A guest_memfd folio is safe for conversion if guest_memfd holds the last
 references on it. Any other references on the folio may indicate another
 user, and guest_memfd cannot convert it to private if there may be an
 existing host user.

 A folio will have extra refcounts if it is present in a per-CPU lru_add
 fbatch. guest_memfd does not actually participate in LRU, but
 freshly-allocated folios are still added to the lru_add fbatch for batch
 LRU statistics processing.

 A folio may also have extra refcounts if it is on the mlock fbatch.

 These two known "usages" of the folio are handled calling
 lru_cache_drain_for_folio, which drains both the lru_add and mlock
 fbatches. After draining, if the refcount is still elevated, then
 there's truly some other user of this page, and the page is not safe
 for conversion.

 If the page may be dma pinned, DMA is obviously using it and hence not safe
 for conversions. If the page is still mapped after guest_memfd tried to
 unmap it earlier in the conversion process, it is also obviously not safe
 for conversion. Exit early to avoid unnecessary draining in these 2 cases.

 Provide a drain status to only drain once ever while processing a batch of
 folios.


> --
> Cheers,
>
> David

