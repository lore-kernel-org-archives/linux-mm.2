Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04A15CD6E5D
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 20:46:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42F196B0088; Tue,  2 Jun 2026 16:46:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B94E6B008A; Tue,  2 Jun 2026 16:46:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 259B86B008C; Tue,  2 Jun 2026 16:46:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F41A6B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 16:46:15 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9D8D040161
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 20:46:14 +0000 (UTC)
X-FDA: 84836155068.02.BC63D32
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8E5D916000D
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 20:46:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rlno5ZxA;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf08.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780433172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fn/J8d++vhy7/fERHcDXvB1WBDLFupuHbck0qB3MoMg=;
	b=Y5hB6FvY02AIzyG680sVpZT1e5Ey/1/WuGOokgaNVv+QIYBWVAy54PNvdzoNfTHZo7zLe/
	HNprXJJHO22btqhiIEeF3AKZOYjgUc+xKh8dFTUWFQmXJtiyku2dIYJgXLl0+IlWsIZvGO
	mLbKN2l19QHqQ/4LUorJtBU6qwgjEnA=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rlno5ZxA;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf08.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780433172;
	b=ZwCGfHLqzkCLXAxlAUx4rRs6iyIKp/6fBdK2hYUzgJvcX7Gs0lJF1rlq6gJlPX1WZwXeka
	vEpJ3qndZc39RyJRrtqI0iQg7myQ5jxXnHFnkaXpg5HqJFueTUZ0ebntil3G4Jq5YDPmBO
	ziw+EL/IbVTHZVTCIglYdVUV02/+MqE=
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-1370417c01cso11878348c88.1
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 13:46:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780433171; cv=none;
        d=google.com; s=arc-20240605;
        b=HKH3uF/Rdi0uBZKpB5SPQf8b8xbNRK8I9NJcePDOioVL2ijVMT9zKN/MHCDkFJU+Gd
         dMD+fJz+Isne1qaU1/x1p3Xu/Y3yDxgsFotkNE7SbRHw6tdIi2CB6KfVEg/Vj/yJtLFJ
         F2nokFnssMnJWd4AWdKp5ki8Ico3kdvQ+lqrez9cQoQwXRIRpVvQySagGEIqLtsO5Cj0
         28HA9R67Wfng1UHoGCtcv3nwD7+eNhFmrpFiS5utQpQp9xSpDuS0Jwalbx/l6FlUvFLz
         2FqqPBMUyuKc5a1TCO7CZNtobZq9fJnegy4uNuZBC0FKFRBW3pfw8+7N4c4lF1eTFwEp
         BTZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=fn/J8d++vhy7/fERHcDXvB1WBDLFupuHbck0qB3MoMg=;
        fh=nXWM/6vfOHUF2iNXBa6ptUqpPPGA2Jc1H+9H/ATuSqQ=;
        b=EMJ2o7kv0Jh5koA2B3PhsTuMka8u6Jdg770XhO3/amahcSBzle+kUac7wK7Jr0CZd5
         2xGC+OgXop7IFaM0p/OiScjktBdx1fZDqxxp6g252yqU4eSjisYitQL6sqOzPdSNbxq0
         NiSGSq4QpTfUlXpEUe7MTzhT7lqDMqMJap3/onMVhSfhGP8kaRMaOA1Kr4wqPWlD1+Qz
         soyFSiyngtNc5hg2t9NiwZfmcRWPLaoLRZMPVzfghlD7X0MI5Whmf0NX6GU/eoIJNkCF
         C6UlvGmuXMwIPAJ3hikwscatmCTn/fOOyRpttewj5++9qzWCz1lDzDsNKnUOpeaJ0BsJ
         Ijbw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780433171; x=1781037971; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=fn/J8d++vhy7/fERHcDXvB1WBDLFupuHbck0qB3MoMg=;
        b=rlno5ZxAATTH3XVl3Bs922nMmbu3QR6cqGzptKRLap206KPsGI11b/FPtnpZyZbDBx
         7n5nWL/eliwY8K3bYQv/Vg5RgBKIVdgLWw9DO1qZsPU9nMQfRdPi1ZWUcZw242KbJU4y
         TEei4NkYrsZ/TrcuU9l4DO5SSXV/+QJJko19cumQzm5nUk5tBb8kcP5WfHur1VHrNNp0
         ZAfd4PeC6iuEVaSbZgfoUhCRLIadD3v6Zbnd+mr+TxuctDMmn0+F8wlSXp1HzuM7ZsOg
         9hlm4XrxvS/zj8quq1kFBIYvJKJYrqS5fmtVex7ApZjNY/mx2K44MRbS3ASturAXstSE
         VyWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780433171; x=1781037971;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fn/J8d++vhy7/fERHcDXvB1WBDLFupuHbck0qB3MoMg=;
        b=hC8/3kbayMNq/cHDDfky/3PTqBMEp6NxRPr9R+DapksQTCnglIY2AbTBt/+vH2M/cZ
         haAQO1XwAFMQSh44bAl2AOPI8DO6VQvNXqpoOCLEJ3R+EJf4kaNu+KJbb7RLYR3IawGk
         9+HdhHMHih+c1T7zn5++q7V7xYkgV5g2S8crb+GD+H2lFqtIv+BY90ndPFmn7HNC0uIu
         DqpK3ZZ/Mam0xfm8LsgkCTr4hmkc9LxbS9a/VrSiKQlro+Fq+aYzCGp3UmKEIAq8F0b6
         w2Ir8EROeKf7fS6aJrgsmfJvqnbYYFB9l7f6FBAuhE+Q6N/D+zoK2GYZakGkKW7/n3w4
         MnLA==
X-Forwarded-Encrypted: i=1; AFNElJ/Z/jWr6By+FMQZvTjdcZWrUFk0GKfhGgkOmQld2E3hn0isreFoQqbVv+3xrhWQ9XRbXc6O8GSdeA==@kvack.org
X-Gm-Message-State: AOJu0YxUrZbRgd7iWV7G0FT2/cK2F5193Fk3I+QNQcveeUP/N2qUcZJW
	q73xbLR98smWozHsr7NtEXliCjZ3swlmQK+BqSUa/F0qJEsfs6aOJ0l0WgRdzIGzX+5bpQxWjNG
	XunNlgYAmAI8aovdUNGBDolxrMGWl0sONUB2qq70w
X-Gm-Gg: Acq92OFQbhyS6oMywYhJR8qjKh4yNjyBYYtkzffk4zEx4aaYNxeDkYOZh6681T3pnOo
	PhrCN31b0n5amGhI5zv7jnUGkJrWRMH7quVRmUtJFG3uHpE3oHZ2uSxwmZKMtXXnhcue1xOW1CN
	LbHfpNLB5glHrj36WZRVqtto5wwvWvHXsNyroWwNWn5n2BcLUHN6PeS7kBidDMvlIJ5lxgCG5Rj
	HWNzIzAcRAIuTlJWwcGeoAHUFvhSqo0wqKro1NS2drMtd/Tk6b3P3U/ZyZnJUC27gztU+2f9uJe
	GsIKjgj5Tsavhnp8Gmgu+nxa2s95NGUFNJx5RZrcMw/2CMoGh0hxqQAv7WEEwP0yML4llQNDQWa
	fIZG7kahzrXYpwiY=
X-Received: by 2002:a05:7022:ec86:b0:128:d7a7:5271 with SMTP id
 a92af1059eb24-137f6bf3cd0mr110847c88.28.1780433170429; Tue, 02 Jun 2026
 13:46:10 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 2 Jun 2026 13:46:09 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 2 Jun 2026 13:46:09 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <d01cf1ec-b85d-4af6-9810-8107c0e2a4ec@arm.com>
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
 <20260522-gmem-inplace-conversion-v7-7-2f0fae496530@google.com> <d01cf1ec-b85d-4af6-9810-8107c0e2a4ec@arm.com>
MIME-Version: 1.0
Date: Tue, 2 Jun 2026 13:46:09 -0700
X-Gm-Features: AVHnY4LuAokUCPsMDhhGv1NZjrPxAfRb9eFwDvC0vBskqE74-aUqfHm3K8vBqpY
Message-ID: <CAEvNRgGzOnA34WyOHtkOx5MZDZhOHaXAe+nD75AiJsZ-PsTSFQ@mail.gmail.com>
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8E5D916000D
X-Stat-Signature: czkpjhmaofobf4ctgmqijghpo5qgbdt3
X-Rspam-User: 
X-HE-Tag: 1780433172-425105
X-HE-Meta: U2FsdGVkX19ysupgL6pksH6CoxL8V3aK4cSH9Af5QzkzkkHW88CYAYzA288WRfenT79yP20TizLNUiaWCUvbVlNvazP1K4HCTNFzgtUd9lYT1t6RsJdviTq4AfMJogklXJ/KqIyqcQZMHz1TghzxzeptDKei0eHxoYS0Pl12a3WJ002CJjoiQGFVqOl9jQcYUy86tzSe4WOJgBhC6M+g3ECvaAJTm8XZhEjBaN1QAb3jixH6ZeYtttdGFqHIlAeD41L94jZmXt0kQHfxFDmkErivCsMyE+fxZ7cBWaZpwyY1+hF0EtsmckWMllCsU/l9o/zWeTS39G4qmD2krwX6pnsLHWkpj+gchiYn5rBNdFtCdI4+BiHCb1TzH1FOzTQVfxy92poEfN49WV035k9r05I84dTn057xI56fQW+zMWm8Qm0cfr6P6htkKv0sMaTVD3ltoZZ3IpjioSW/lZll+fLNY+0wp6VMA0mWEa6M8sVfwX1BEixj3RbhUSqRY8/dS2R7kmcKuWhO9eJq3j5OxQAIvt9skjF2lC1zNTlRitiB0YGR1gETGxNwBxr6nGQ0tle/ZtS3+Q/cNoaANpU87TI3HNm+LkeFTiaJVvCOeRlwlNUJtHd0sZrezEVuhgxSCL5WPB21E99Y7PvqT4UxKFAAY1yxdH5sa4Xt0nxIcj5W/5DBKZzDe8hjJEMutZknvuODxKaDaUgoe3lqJXCzZ+ClTITnhqCL/Za8e7lNS2myhjx+gwuCoReTpkFXus3adANcrZhvgm/FY+ot1zFxrxLZWYAAA5mHVgjCLU//fUY6D2XAl04+rDUZsLf+yJWnCoWNoF08uykeXcT1po5oy+Lj9eIK5VpC4b3gQ87Z3wYyCrejS05KsmA9jHhnqb3OLUk6ysBrSBzV3z9IHwwQI2z9z8nzdh7Nownax33eYwCkfAA2CaCjbsM//jeru/CqeCCgNKTXvXYNOwTevA4
 av4OK4+Z
 BVYobcdeps9ntVtcj7CgvH8hj0VXXDEFIgXB3OmRE/lRLV8ANrLgvBflBlY4UR1obCDTeiW2hVSmprPnrEfhbrHNFCPL4Iw7r5jpAmvEOrcvX0R8bJBQHung2ihr+7pB6VagRgw5ITMhua+zopdVwxjIQuhGzrXsML+aFkI5mrNgFFy0WNqGpahlQbAzb2quvi4k+/rU2Pm6GMmy3RLtK9Lb0jnnLUml46cJhpS7T7iWsZxNp1XedOqHQxfxb8+XWOL8ZKesuWE5Hmirmlb7pa+h3VD0mWN05cyqVaR4wfViEQgXd8IY0GbxsB8VAqOZau/QDy2l+7cfaVSp2VbuKuxvWzboLJTFjojQB9dUUDwpd52WKG6kUDM8xR5iAndBofZg1N5GqetE2w4jWssgOhUXDHPUSpEShzRC2zyJNapR//m8xhdJMrU44h8QR6ECdyxQD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Suzuki K Poulose <suzuki.poulose@arm.com> writes:

> On 23/05/2026 01:17, Ackerley Tng via B4 Relay wrote:
>> From: Ackerley Tng <ackerleytng@google.com>
>>
>> All-shared guest_memfd used to be only supported for non-CoCo VMs where
>> preparation doesn't apply. INIT_SHARED is about to be supported for
>> non-CoCo VMs in a later patch in this series.
>
> nit: s/non-CoCo/CoCo ?
>

Yes, thanks!

>>
>> In addition, KVM_SET_MEMORY_ATTRIBUTES2 is about to be supported in
>> guest_memfd in a later patch in this series.
>>
>> This means that the kvm fault handler may now call kvm_gmem_get_pfn() on a
>> shared folio for a CoCo VM where preparation applies.
>>
>> Add a check to make sure that preparation is only performed for private
>> folios.
>>
>> Preparation will be undone on freeing (see kvm_gmem_free_folio()) and on
>> conversion to shared.
>>
>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>
> nit: Missing Co-Developed-by: ?
>

IIRC this should have been

Suggested-by: Michael Roth <michael.roth@amd.com>

IIRC Michael suggested this on one of the guest_memfd calls, Michael
please let me know if you remember otherwise!

>>
>> [...snip...]
>>

