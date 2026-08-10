Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62018C5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 23:41:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D35D6B007B; Mon, 10 Aug 2026 19:41:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 180336B008A; Mon, 10 Aug 2026 19:41:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06FC86B008C; Mon, 10 Aug 2026 19:41:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFFBB6B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 19:41:36 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4639D1C0C32
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:41:36 +0000 (UTC)
X-FDA: 85086984192.19.52C211C
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf05.hostedemail.com (Postfix) with ESMTP id 40C24100010
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:41:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cHi8YFfz;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786405294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dp0b2gqcZ26DbJ9BVPOHI0R6Nl9LEyZ50URFATgNWEw=;
	b=cowDYaxsGvsK8uPmMT6OwuEVDb3OO8FnPDzDHdCq+huvt6SN2CoNfaRVsWtzYUQAYEDY7y
	ltkmWuL/staTQFRz72xIp42rEENbQoDIIoN23k1WyN3yG3PHK/6vMeppgWZMov1I0HNFDO
	omAd9Jpe0roStEfaoNnOlZo4Qh8RSuw=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cHi8YFfz;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786405294;
	b=7XY9O5kFDnC6CrEkH91Ql6JzNrGVTIsy/T45DWx72a1C/bHO/N5WELy/NYCg/d4gl1O1ei
	Eev3e6pe77bCUGgoG4vjm799B7vf6HSdFTJl8OxaPxkrXActU3R7z8EzrezzSJf4ln3CR/
	2rcK+sk2iFOUDFS0w7HebaTAYWvAZyY=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-38e69bdb0fcso2190800a91.1
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:41:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786405293; cv=none;
        d=google.com; s=arc-20260327;
        b=oKfNMHVr0SgkFu9Cwt9axB1Tvtw+ORc708Yp/UhfjlDifdvzRazFj6t25LE+8rkAEz
         3CHFU+6kn7jq4DYDXsHxtzayIMpfvAvKheKXHP4e7JiaHB/v1hCatQUrFAbR0xqyHSKM
         ubovyT/+ZlrMygNde06QFMa4Y0I+rTU3318Bb7Y/LI/Z100eblDYDVqUxb9SY1d/GKpF
         9Tpzz+9xhK7itPym/lpRYnbUR4duUh0FOYvU9bgTRdY+YveUm4/KVNHBHFtW5wuCSzU3
         pewKbeWKaWmsDDOvFpGvaiDjuEJCpmESXX+xMLCHAB1EXPH7gUavkHn4ceJbd+SpAls6
         XBDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=Dp0b2gqcZ26DbJ9BVPOHI0R6Nl9LEyZ50URFATgNWEw=;
        fh=WzURIH/JvUBvXDoxKdWPKD96KYDnYlaRailc637FI3I=;
        b=DJzjLT1RSnJ3zccNGlewu+xaPSr6I9440y+KtY6ahTjTDtEZgbkalLLoRA2VMV7LLp
         YBHxxvlNVmshYTPm4S7+erY1OFs1XkZz8qwrEM6cX9hWSKuEEcA0ntHhuV6TnK1f1IT/
         c3Sob+IPpOW7WuySKeYh85g6vUDQJIyanuWP3oWEleab8EkbfR1z1hZNPltqALAspG2J
         H0oejLGodR5bllQhOlQ8U5xs0jDDDU+Qx+G9EcZyo/5CxgEWvBGX9jdtGpICObmAB3oz
         312cx7AMBZjn0lzbUirOFSJzN276o7z7BWlfKGZGOpxBYgqGAfol8n+dcWRAgSe7fGk6
         v8Yw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786405293; x=1787010093; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Dp0b2gqcZ26DbJ9BVPOHI0R6Nl9LEyZ50URFATgNWEw=;
        b=cHi8YFfzfAFSTDmQ/X6TszpbOYe62/ISCJpsHMCgSwU4viCuWSBKJAZ7XZlLbBAvMa
         LVbmNGOO3m1n8RVuidlxe5WSdhyxwPrZ0Fn8d5qBXdH2zC9AkVN+PlYciaNu+zd39jWS
         KWzunxW+Mcv1E+y7qH0KNie9+YdovM5axRblcUZi2HzgX9jFrHvnFe4dklbBUrGmx6D+
         wDj8m9lW/EC5iFibwGG3t9OcVU7pK82/4vDJER9nx+vSWGCS3Wl/cmmpuJwjqxMIKBI8
         LQ2vLEGujaX3zOV+R48MqJwoyTbVyR4G+WpdyW/67oE49UyCfRvXCFeTvqraEfIdeG1Y
         7owQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786405293; x=1787010093;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Dp0b2gqcZ26DbJ9BVPOHI0R6Nl9LEyZ50URFATgNWEw=;
        b=f99O9Lcx5EGEbRJyh5BEnH7VNh/XGFAcsn2622y6olAySgsFwwW7uhhMCZFRAcFDAB
         aFRN/lo214nvUXIF8BQb2TnNbKMnpOZtrvxFcl261FjcfFMXXAhiln8oOqFiwS+6n87a
         95kQprBnWFjzf3B5riiBzne0SDCUGnd7LavVIOWZJFM31wffWUKBTtiHm3qb8/UfeCMF
         cK3Xiif/omTPQ5AaOUPk0PVLhU1YR4nJa7ODmuS4oW5HRiXIAKRxbi4L3+9OEC0Lg6BL
         RVx7FvCTuvpYhKOQ129q0cfz9ZCAWnNtrhA0dKQUmP3Vtx6M9bop0cHR1Z4R8WokI3GW
         xR7w==
X-Forwarded-Encrypted: i=1; AHgh+RpsNVl30NMUgw2lB5BHTss8hFe6rxftAvUaCNIndw0hDPcYKahRhkxkIzyiHlvtukAkLspeTPdiCQ==@kvack.org
X-Gm-Message-State: AOJu0Yx4U3ypDEybpEkx+oHDsqMU73FKg4y3gjJj0yehSSZuF2bdj6E/
	61WV95miHDIEsrYsbn2uoPI+cy+OZ4UO4NV9IQx3aDp5GJ60gApJjQoIrJOWixFaNeHEzZ7H+mF
	K3TAheiSxQ45niqnf8IJJ66fLnO1dm109Rwjs+BH/
X-Gm-Gg: AR+sD11QHGcu3NefVuoifFU5Rz439TMeKThpexeJd8+wZoP5kibgxwaJoBfnI5xXPuM
	Fyp5IORmUvVRNnckALhktu0Fq+UnreCr4Rayg1WztWEPcqe4p32qB3duCNUXjEWFB84u5IMzgi/
	mfII1RG9DCiICe1e/4I0i0M+/VCWDwt1IQF78NOSHPMA64CIncb62l+AXZlxQviK2BrPRdmMSCd
	qINpFTYUNLqR9YzkBscAMrcM5SasVBI4jkF5fZkrDKLYTb0zRZp22s0ArQPE1V1/XeITkO+/3gX
	xXV2OdS+3UzwsLPuHDSVlfZjc8l5J5liSi8ZH86ZYIPeWkiwfXR13cMg+LfJZz7R0OSMV7Ge3g1
	Zf9mXY5lLFq5pvj5Ag+vAJU7QGuvETOiV2Mg=
X-Received: by 2002:a17:90b:268f:b0:38d:c74d:29c5 with SMTP id
 98e67ed59e1d1-392cca64db7mr5320468a91.19.1786405292124; Mon, 10 Aug 2026
 16:41:32 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 10 Aug 2026 16:41:31 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 10 Aug 2026 16:41:31 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <dd9ebd52-7171-4353-8c83-9363019d55b8@kernel.org>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-16-2fc18ee6d3ba@google.com> <dd9ebd52-7171-4353-8c83-9363019d55b8@kernel.org>
MIME-Version: 1.0
Date: Mon, 10 Aug 2026 16:41:31 -0700
X-Gm-Features: AUfX_mw6OlaGLLkL3HyJwIpviYhrAvoZYVarJDuu-bVxocdCtMCbumdkufhLAM8
Message-ID: <CAEvNRgGSK9tO_-TvQvXoMwVwGygh5WjjBUOY-zLOA5yP2DwS1g@mail.gmail.com>
Subject: Re: [PATCH v10 16/41] KVM: guest_memfd: Zero page while getting pfn
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
	linux-coco@lists.linux.dev, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 40C24100010
X-Stat-Signature: nefqnxbsof4d1mpwxnsfwnc6swbkrww9
X-HE-Tag: 1786405294-66068
X-HE-Meta: U2FsdGVkX1+GMpxWsjAw+fX13kY0NFByRbTf3c9g47qvifisRF+HucQhdaqu5Z1v/k7tdbgHyshzPim7BnqaYDQ0NpQAxqNuASJ/kIHSY/wBhohLfL4FSFiIKl0cSndJNaWUz6v02BcQyGVeIIRhfMLjzQTmw2c5ij1nGkYSz3D38YPueu1Zuch+uQKmPfs2OY3CKrjOwazMR6rJNOdWfpnHVQJQW12rPqGynY+zdQPrIPPDHRKi6NThqykLN4rZ8KaXUcW36cNE3ecm+O2UQLWjFq18H8qYnDkbaCNtk0wi1G20cH34H9CW2Sog60wIHgV9nlh27eUujdasWN3fbnENzv8P8XjxX3aAWuDJrPgP4y7Hj22LuP5fVHjoH0NtlWLczMj1JCx1WQ68v2AktPiJYjTnxzszCfIMw5eI8LBtRVoEXLN6ICpV3OR42dLzpGvNYntCerAw0XjLDaY9hAjy9A11V5Roy4EGflcREAr47W/jJ/d2pLo/b/EaLALvLRgA7vnkfkexsWeoXFgOX4Qui3yy1zrpk002MYoASMisrEhTRVQ126RG/JsIolFt62Ukgl2GxHih8RoLtKWT3xlAVY9bvzkhGlPSkltdxymokEqdJHmMPoGLlWw7IOmLan/bC1RPSzpE2RcOUDbFP/14dp9A63y9+C+T1Cv5UHFpmsi+XsZmK9S6pPPO8C8ttUZ+xnpv/WpXsJpHGV8MbNZoC7h0/mfVhOcCkx0IA4kZs+1EIRO4UDLSHf+Fo/duJ1P5l3YoZ6/HQ/9WVnkac5BJZJUJKwECS1gtjo4LcvnOGkPRnX3uIiKx7vAFzHydU0OkYhmDesPv/jBA9PQ22P2ZEmQEfi0KJha3YFjBoe4lGSgmy/aYod+Ig7utdkbr3Yam+XeDjZ+B4YvqBm6YlMWOFjtSaRwy6+jkQ4Gq9GhiFmw+SnOs5AZJh4ukgYaGhcUMFJxW+MOINFys0dP
 daK+QgrQ
 WJhJU9Yy0UYOlj88dYQgHeozSt6mUbbbgVX6NB6hXGHOe9lGRB2VWaMLmhw9oxwMXwcfDEUEHdd2oQmjlX0rVD0iSC9zuQLAjQL9h3+17kPEej8A3Y0g0i+nOuuAKP6xX/QdLZTAd9qwSyTPZROsRuB9SrcE7+eipdz4Ot4W2t5q/dO7EyoeXTBe3GPoCElSoFLXNzEvQ8D5JOJU1LbceJMMIzhPYDlvnQA3g9QM/bipa7WdqiU8DXgihNE3DRmvLLYrfo2sCTogiqp47u47unFl2Dpgy5rqEMbkpQfKS+ElGg9dkOG2V2FlTk6vJxgq+Ihk6NwSH49x97reHGP0NkGDvVe7mu+86At1MT/xTvWtEdRZHoBLWyDfMdy3C+2Q80dC6sGCE1kqWd3f8RjmS/tXdPhvbfizmh8H2oFX/PbwhCKoaqR9yO2KT8LdCzV2MwQUn
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
>> Move the folio initialization logic from kvm_gmem_get_pfn() into
>> __kvm_gmem_get_pfn() to also zero pages if the page is to be used in
>> kvm_gmem_populate().
>>
>> With in-place conversion, the existing data in a guest_memfd page can be
>> populated into guest memory through platform-specific ioctls.
>>
>> Without first zeroing the page obtained using __kvm_gmem_get_pfn(), it
>> might contain uninitialized host memory, which would leak to the guest if
>> the populate completes.
>>
>> guest_memfd pages are zeroed at most once in the page's entire lifetime
>> with guest_memfd, and that is tracked using the uptodate flag.
>>
>> Zeroing the page in __kvm_gmem_get_pfn() is chosen over zeroing in
>> kvm_gmem_get_folio() since other flows, such as a future write() syscall,
>> can get a page, write to the page and then set page uptodate without
>> zeroing.
>>
>> This aligns with the concept of zeroing before first use - the other place
>> where zeroing happens is in kvm_gmem_fault_user_mapping().
>>
>> Don't mark the page uptodate again after populating, since the page would
>> already be marked uptodate before the post_populate() call.
>
> The downside is that __kvm_gmem_populate() will now zero+write. I assume we
> don't care about possible performance impacts?
>

Would we rather zero in kvm_gmem_populate() only if !uptodate &&
gmem_in_place_conversion && src_addr == 0? That could work too.

Previously, without in-place conversion, populate never reads memory
from guest_memfd so there was no danger of leaking uninitialized memory.

> Worth spelling that out.
>
>>
>> Reviewed-by: Fuad Tabba <tabba@google.com>
>> Tested-by: Shivank Garg <shivankg@amd.com>
>> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> ---
>>  virt/kvm/guest_memfd.c | 12 +++++-------
>>  1 file changed, 5 insertions(+), 7 deletions(-)
>>
>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> index 030af0855f8b0..41950c8105b5d 100644
>> --- a/virt/kvm/guest_memfd.c
>> +++ b/virt/kvm/guest_memfd.c
>> @@ -1079,6 +1079,11 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
>>  		return ERR_PTR(-EHWPOISON);
>>  	}
>>
>> +	if (!folio_test_uptodate(folio)) {
>> +		clear_highpage(folio_page(folio, 0));
>> +		folio_mark_uptodate(folio);
>> +	}
>> +
>>  	*pfn = folio_file_pfn(folio, index);
>>  	if (max_order)
>>  		*max_order = 0;
>> @@ -1108,11 +1113,6 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>>  		goto out;
>>  	}
>>
>> -	if (!folio_test_uptodate(folio)) {
>> -		clear_highpage(folio_page(folio, 0));
>> -		folio_mark_uptodate(folio);
>> -	}
>> -
>>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
>>  	if (kvm_gmem_is_private_mem(file_inode(file), index))
>>  		r = kvm_arch_gmem_make_private(kvm, gfn, *pfn,
>> @@ -1159,8 +1159,6 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
>>  	}
>>
>>  	ret = post_populate(kvm, gfn, pfn, src_page, opaque);
>> -	if (!ret)
>> -		folio_mark_uptodate(folio);
>
> In case post-populate failed, do we want to re-zero the pages?
>

I believe we can't re-zero the pages. When SNP fails to populate it
could be because SNP didn't like the CPUIDs userspace set up, and after
the error userspace is expected to check what SNP likes, then
retry.

IIUC zeroing will destroy the message SNP wanted to leave for userspace.

Michael should be able to explain more here :)

Btw Michael may I also get your reviews on this series?

> --
> Cheers,
>
> David

