Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6140CD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 22:30:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7CB96B00A1; Tue, 12 May 2026 18:30:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2D8E6B00A2; Tue, 12 May 2026 18:30:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF6226B00A3; Tue, 12 May 2026 18:30:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AEDE46B00A1
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:30:29 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4D9D312060C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 22:30:29 +0000 (UTC)
X-FDA: 84760212978.21.7C44130
Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	by imf05.hostedemail.com (Postfix) with ESMTP id 34582100013
	for <linux-mm@kvack.org>; Tue, 12 May 2026 22:30:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nkypGZO6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.48 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778625027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7TPT8725vjJaWzYD56fEvXZ06oMkvP85Hz1/t121+lc=;
	b=PzpEAiFvY2l1qf6Yw7E7RWICCP+bcHEqAetJiqRRUrsLmWsYu5mLTnOShLfolgbbjTYcsW
	WS4mdXSGZ7OM9DKBlv+PADyITkkGUepVj7MUOjft5t6SV70E1a8W54Fu0muSEUg4Sm6vjX
	nOZlj1DeP3vz0EfuADc3myZejDi7nug=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778625027; a=rsa-sha256;
	cv=pass;
	b=NkgsmhfJygajp+UggK852Y+LFOFppDSLxrV7rQjIWUpRIewg3sLQ32SS/0VBJhkYMInI9X
	B1vCwQhEn5glGjH9AW4dyw3uh/d9ajoslRKgvIiohsc8DBzFAI0UW6qrJZUZ76nReNMaWc
	VLZc2T+utf6F0/yRkBFNu8qtNarev1A=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nkypGZO6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.48 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-95ce0cf2d4bso3542928241.0
        for <linux-mm@kvack.org>; Tue, 12 May 2026 15:30:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778625026; cv=none;
        d=google.com; s=arc-20240605;
        b=YmyTXV4kK2rKbLtv84LmgEJb5KSPvjMLlf7ot3NV4WkGSVjr4Aw9h6hoi1b79KJ/as
         PoIe8zace8nxmFkWTSUF/0gjmscLLlPs6wPDk0u90rLegOH5koBSSJ1eU80C+SiKNFTS
         Z0VMGAw/yB4OVqgQ0f3TuojGbQFYLlPTBu7MEM8y+94zPjQ/3s4sF2Lqj0r6atYnvtuS
         V0vAoBTgWw9ET7a5O0e8sIbhZT4NeNWQzUtShwMQ2/stjSQlSlLLmHXzpcWDHDE7kIYh
         tnucLKgPsdOwDLnBSzDW+1HavxYQ+XjbfGPxKRt44KDOh/BjWJEeGYZmVR7v7rjKVCR8
         1zqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:dkim-signature;
        bh=7TPT8725vjJaWzYD56fEvXZ06oMkvP85Hz1/t121+lc=;
        fh=YuMkdnH/VLTAdLpxiEW0VLVoVpB9aN17zAndNLWIigs=;
        b=Nl77qHFqvirNRtY5XZ0zcDZ+KfNcNH2cBD08OmPfoc1/9PwHpspzQ/gl/Fd1D6MHv0
         imv7UTHw2e1IePjvq6HxPZxGu/UoEz0FnPtnyAnutPwLAy+g7lE73GsBjnYCkyRKMASc
         CntiNslrkkhmQxuv9UCfqGDf8krQEYz0zsjpFMbYLX7dTulkERpPHy00KvhMKqWz0NmS
         rGUzLXudxuaExPtZNbfLjfd0OnV32USGR10PzTnLHspuuuEdhyJs0JuZ4eCLYwWK+Byc
         Kn4JojkY36bnxrs0szRCDfboCLqGtIk3uigpyK8AkglkOX9JY9Y0lEXhBdoUiut8IPpj
         hUkg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778625026; x=1779229826; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7TPT8725vjJaWzYD56fEvXZ06oMkvP85Hz1/t121+lc=;
        b=nkypGZO6ZLVORXYK359eOjYNlhPLkoiOxvbC+vqcK3yQK3AJ684D1f3kDePOmTh4wr
         akG2TSJofnOVSJSNtpniSxFEal/Hc5km/e1uLVzvm0Tr+6VeBtSqoiwLRIxNIU0RGZYa
         xrcM3ohHgYbi/EwWaVGB1yeoAPwm2C2KaqGIwK4f2T4HG80gR1DHGgD9qJcCRsvG11DQ
         3n3cbaGKzo+iXj8XbwhEX9MebRGJzCMjxVCXpk3L7U5Kj+IkGvVayJIFnSk0QyvGPYnF
         Uulnuo2ZscQpfpb4CwLgRoWestARj+pEAgT/g1Y1W3J/85z2BdsrmRdZTWLVrMD1bbXi
         0Log==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778625026; x=1779229826;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7TPT8725vjJaWzYD56fEvXZ06oMkvP85Hz1/t121+lc=;
        b=qWRAiLVLdkxTHj44yEcXi2yxnZc5Lg0BO05Zo1KPh72V55AEw06PWUcFdLMUJuCF7Y
         r2bpfpbC9OmDjk9xk0o8gcbJBMM3fg6QQhuP471JeiaYSWQrT33aF1ysjFFlBaexJ4Ea
         7JVGEsRjqYom+FvW4K/pMTfnjsc9hDOjxyv5Ery6sN5SdfWz+cwGDEqJbAZlg6VSCq2A
         wcYB0wscBOK8SFaK9nLl8B4I+RbHBAryvOKce/3XvzDa1GTBTMlDGj9wtbY9c9GBVUOB
         5ZZGMzF5yZIK0oqHQgZjzEi0kwA3jAVmw5OPMK2OO2erfjQDacj/8f6/KLg1r3AtvFyj
         KOPQ==
X-Forwarded-Encrypted: i=1; AFNElJ+mfedvr1N0/IQfoDXNzX3kDgqrt2woSn2ZcZ35p/iAKDaQDccxJ4kCl9RS9IRMmwii8MIWkQ0UOg==@kvack.org
X-Gm-Message-State: AOJu0Yy+FIR73130vh2WFgYpFQPRN7CDurTDLbUptPbhAA8f1Hg0UQfD
	cVpSuN2WyB3bo57dqocLCgB7VKzSYLlUinLpPJ6L5M6E7W0TTeR7zS/BHa5hH04MDFJ8HkFFESL
	pgh3URt0ug0K635FtEYD9b9vGrlEtJZkOysLA1Fc4
X-Gm-Gg: Acq92OFUUesR65WXdW/lme7kRCaBMkA5VLkIA3hYZ7A13CMJKdAGCWH3ZF85e+t5Uj+
	487ks/y3DOP+a32rkKwpF9U7da0/hqJP7kfs0hZozjTTz8rxl+jvdu7SArJqeEjh1tejNK7bcYo
	GhkkNETciCY1dMTHve+O4ASckRkwi73sODC2AXQ0BJmU2yqVgFQW5Dhkz5O45mFi4qcADFVrsdd
	oNPeizTRBzc+U/rdbXOwqVqoB2Bs2+y65ZjdJqAb0UiTx4nJzv+ueUFHXOj84/tTAUx0so9aSYh
	lL4mzDciJ0he8CTxGIH1kFIRipsp2phXl22x8aPeAt10j+PBDpQmMXdUUsoFgewZfDJZgUJ+kWc
	ONZ9o
X-Received: by 2002:a05:6102:442a:b0:632:3bd5:d57c with SMTP id
 ada2fe7eead31-635ced54981mr2555380137.3.1778625025472; Tue, 12 May 2026
 15:30:25 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 12 May 2026 15:30:24 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 12 May 2026 15:30:24 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <1DAB05E2-7F30-45D7-B155-B66C59D31AFF@infradead.org>
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
 <20260428-gmem-inplace-conversion-v5-10-d8608ccfca22@google.com>
 <n5ce32wumzeiqqyqutom4apy2kqfetbvusc6j4k2xarsska5mw@klp5bmy7qhfm>
 <CAEvNRgF9+Gr7UVEq-E2SQEb_XOQQMOXy9F_A2tA=DbNV_fJ0EQ@mail.gmail.com> <1DAB05E2-7F30-45D7-B155-B66C59D31AFF@infradead.org>
MIME-Version: 1.0
Date: Tue, 12 May 2026 15:30:24 -0700
X-Gm-Features: AVHnY4Lh8UobS4TfgaX3AzC6MvTUmkcUL18qAWSQRch3a7T6C4hmHCpmi3zo20A
Message-ID: <CAEvNRgGgggCPKRzd0=r5jV7stxFJVGzj3as_awGytonx9qdfLw@mail.gmail.com>
Subject: Re: [PATCH RFC v5 10/53] KVM: guest_memfd: Add basic support for KVM_SET_MEMORY_ATTRIBUTES2
To: "Liam R. Howlett" <liam@infradead.org>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
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
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 34582100013
X-Stat-Signature: t7tg9opafpu53ku11k1fm9858yhtocey
X-Rspam-User: 
X-HE-Tag: 1778625027-616717
X-HE-Meta: U2FsdGVkX18bcpSXS9N+HMdJi8nruTt+ZhShUSzmglMn+jd58knDW7D/zqIin/rbBhF1TGFRhdzTKHteDudG3tf4rox2G/yjmplclSLBzphoEdC1OYHLSoGOSSeCvwcLWvO0d6QPOvi84+6DxwJv2XOIzQRYZwhob2EA3vncbr8Kb24aW7zWm8mpUPI9vfBop02XzeY+AP+m/3+hu+sF6PJIRfUrEGd5w09NFYFwtAVnI2o+IyQlRYn2N86QNUayOB2L9UMexYLOD1+PfzUlPrT6dc2VVW20c9GhUU/AFKPxxQ8AR/pZswTse3/A1ZslAoKyDZOHE1TNKFEhR4pRH6ppn7IQdrE0n0/X0Y3fxj+qRXP/17KAvf0dkXQa+xCjeAcx2dXO7QqIPz56qQERPHaSRmpzSL8LYcxKbwwjT0Izdk217y8GiLrnG3keWSHlCvf9uF00zpCm8wp7vADl31OT0rEoeH/lzIYP6lDSiRFn69z8cg2UEyS8MtLUaZLIbdQLz5MdlhEZclyMKTkzzqWGrSr9Ng0/dGxvZ1zfzEP4mgkDB7S4R0og9G72rxxLp59emApTtNN+wjn3pNTqOqXXwDGYBxr/n45Yx9+55vFYMBjAqzM9Ft7Kw3SFjERccbwgXYjx5tv2yEiUBN7JfHLVWCewY44tP5k+IwvzsjgyuAgaSjy00W4XL7G63LQkK9tRtWVUD5pOjTxWD3ZaECnsKEs6+2fPzrGZX1XYL8LeF7r1CkYEaHhWT6IJUGLmZxz9lErkaIqycUtd2qjtjpoRGbUrcj08Sf+VQqPKRmECKYibCExz0Oy7x5+njZcQj+K+JGipONBD2V5txyP6QYg8AcEh4gEVKaf4gUPEWDvQEeXR+tsDJ3EliyhEdc0CCWyp9AHoZ0+UECRCv7XyRVyUipjSr5Ktm8jsMEBB//tb6dRfEEj2oqsqnTWAtVvVU9SsLzoYilB7L37L+cW
 c/new2X6
 NwIU5fbly/8P0eLN7YKu1RbZf//qKLrsqkqxcg66XIX10IOX8plen0egkkAQYqNDAtgUKyMGTNgqeDEF/AJbmzV6imqt+Vxn6bdTCLKo22SFNEoJ9eXBnouMvVmt0r/Qyv2JK5HDTaozyGXHT0t38t6PBsBQiRBzCUOvkppPJwWqmms7dRjGRv2LoITNGfyAnijdaIJuswLGrxtgnYjsIa3gK5TI1E+qMYZ4ff0X1Pe8sm3e4/wlTJOyL1THM6jGN8Bqc+wdG6mN4GCzdc8xG9wyRaIM8VclwNSJLB4LL3KzU0jdSCHGDXg+UIIEryFfdlyYL5EH/MECLUcnKdoERbKFUpmgiR43E2yfYt0JsDqNoiarXAjHYnSVu54527EdjeNFz8gfE77nXHk5MwllD6G671jHM/nPGFpuAWD8lJlMRVQ1uzDxYUkWO7W8NizwDXxiKqdrDb1zxLMEVLhV+Al/TFLKhdD6XtmN1pGdCHjcwRd5Qfh4ELFBWC4yi483jxvA4J0BESNMisYHQxqMaAwgfThRrkQwB9E+6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Liam R. Howlett" <liam@infradead.org> writes:

>
> [...snip...]
>
>>
>>The invariant in this maple tree is that contiguous ranges with the same
>>attribute are stored as a single range.
>>
>>The goal of this first part is to get the entry at the index just after
>>the requested range, and see what the attribute there is. If that
>>attribute is what we're about to set, extend the requested range for
>>storing to the end of that range.
>>
>>If there is another range higher than end + 1, with the invariant
>>maintained, that attribute has to be different than the attribute stored
>>at end. Hence, we only want to extend this requested range up till end.
>>
>
> mas_find() will look for an entry at the given address for the first sear=
ch, and if it is not found it will continue to search upwards.  Since you l=
imit the search to end, it will work as you want and there isn't a bug as I=
 was thinking in my sleep deprived state.
>
> Since you are searching for exactly one address (end), it might serve you=
 better to walk there.  Maybe walking is a better API for what you are doin=
g here?
>

Thanks again for this tip! I'll try the walk API in the next revision
after v6 [1]

[1] https://lore.kernel.org/all/20260507-gmem-inplace-conversion-v6-0-91ab5=
a8b19a4@google.com/T/

>
>>> Do you have testing of these functions somewhere?
>>>
>>
>>GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(indexing, 4) tests setting
>>attributes in ranges. If test_page is 2,
>>
>>1. [0, 4) starts off shared (4 is the number of pages in the guest_memfd)
>>2. [2, 3) is converted to private
>>    =3D> so the ranges should now be [0, 2), [2, 3), [3, 4)
>>3. [2, 3) is converted back to shared
>>    =3D> so the ranges should now be [0, 4)
>>
>>I verified this by inserting some trace_printk()s and inspecting manually=
.
>>
>
> Thanks.  I find the exclusive ranges a bit odd to think about in the mapl=
e tree context, but this test case makes sense.  This is especially odd to =
look at a single index entry, at least for me.
>
> I generally have a set of test cases and append any bug reproduces to tha=
t list so they are unlikely to reoccur.  My testing is certainly different =
from what you'll be doing, but this method has done well with the quality o=
f code improving over time, and limited (if any) regressions.
>

I've not worked directly with the maple tree tests but the xarray tests
(similarly set up, I believe) are a joy to work with.

> I actually insist that any fix has a test before I accept them.  There ar=
e two reasons for this: 1. Avoiding the regression. 2. People really unders=
tand the bug if they can create a reproducer.
>
> I hope this helps.
>
>

The maple tree tests are set up to directly test maple tree code, but
KVM selftests test from the userspace interface, and it's hard to test
this invariant from userspace.

>>>> +	if (entry && xa_to_value(entry) =3D=3D attributes)
>>>> +		last =3D mas->last;
>>>> +
>>>> +	if (start > 0) {
>>>> +		mas_set_range(mas, start - 1, start - 1);
>>>> +		entry =3D mas_find(mas, start - 1);
>>>> +		if (entry && xa_to_value(entry) =3D=3D attributes)
>>>> +			start =3D mas->index;
>>>> +	}
>>>> +
>>>> +	mas_set_range(mas, start, last);
>>>> +	return mas_preallocate(mas, xa_mk_value(attributes), GFP_KERNEL);
>>>> +}
>>>> +
>>>>
>>>> [...snip...]
>>>>

