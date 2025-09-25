Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8027FCAC5B1
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 14:26:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C22C18E0010; Thu, 25 Sep 2025 10:26:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFA328E0006; Thu, 25 Sep 2025 10:26:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE9608E0010; Thu, 25 Sep 2025 10:26:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9D5BD8E0006
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:26:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5D37B1193B5
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:26:46 +0000 (UTC)
X-FDA: 83927998812.26.245C0E8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id D371280017
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:26:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aeGsI2vZ;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758810404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7NbQWxxCkkna6kPG5JPAnaAdZblXa8Jj1l6IA0HQVeA=;
	b=nQ5aPsohA50+rY7M/AdkeDTozKleoMhXpGL2irPkVaE9qrI8Yk46Kn0IKQmfDpyiC7eLef
	4tX5dteTgrrBwD8N20M1X5UswYZF/e7+boQsSvZU58QH2NKO7M7viAcpJEHg101KB28gAO
	PG4XqWpW9uCEgkacKYXZHeaXSb9B2Bs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758810404; a=rsa-sha256;
	cv=none;
	b=sBCnzk27flweURHkPObW3kG7sFpKl7k3Ymht2kZgIwR+sabDaAHL6VFp3VwLwPPfxq4QUh
	yqhz/A12YUqGag2WKY0+zQzoOXxCobJb0IM+FLUbJHfZxEj8k5VNgWE/wXxLtuZ2p+55Cv
	9A+5yw180YWjZdrwkI/8YHako5HaOPY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aeGsI2vZ;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758810403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7NbQWxxCkkna6kPG5JPAnaAdZblXa8Jj1l6IA0HQVeA=;
	b=aeGsI2vZtbDIyy4oG6i7/ylQ5KCgQnY27Nvhir0iZTzwthwGZiZcH8bw8YjoQ4do3s+5PA
	Jp7XLY3N2GjkMv7Ccf/3AQ852zcZ1EVgtGjHrHrmFwZkwoPiV3boQeGo5Oi96+NaxkvRsx
	VFTXY/8ahk8gaH8OdrVP3tTZl0RV3FQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-xjuquE2QOCCHRClWNCRX_Q-1; Thu, 25 Sep 2025 10:26:41 -0400
X-MC-Unique: xjuquE2QOCCHRClWNCRX_Q-1
X-Mimecast-MFC-AGG-ID: xjuquE2QOCCHRClWNCRX_Q_1758810399
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e35baddc1so5938025e9.2
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 07:26:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758810399; x=1759415199;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7NbQWxxCkkna6kPG5JPAnaAdZblXa8Jj1l6IA0HQVeA=;
        b=ez3TyQgSk2pgEyWjm+eAubCV7wy+FEY+Q8V4b+36HjKLoFnhPshE1l+fPfa71xDulK
         kKBuXmvyJ55pMRBrFpYyzn1RBNqPY2O6DyFq2Jn88DzQeWexm8HQuz51OXLxItYsZEmj
         V4RNg1u0TkEjc+TnE2zBdESfSapTdCtkkrbcghWMLye6AbxKaVAWU3baPrB4z9mnLQ0M
         bBxQhw/TkXcnu7CgmQwYakkUzrnuWu2Xf6K2HGqIuuaLsC4eix3oaWlUQFJivp4/wjFW
         ktJyGKgxP5Qfumy7pdc3A8jPwbTluUcmjyd1xoWh/r9gFkKpyPjMuQmsfCW6P3mpCmrR
         ZvfQ==
X-Forwarded-Encrypted: i=1; AJvYcCURCnnmUtxNGmTdUaDbx5/FHMlOtz+DP74e1grkmMn3t93GEyL4jmb1ap4D42E1et6Y4stwcvJ/vA==@kvack.org
X-Gm-Message-State: AOJu0Yz75NXwhksstVDv3QqZnCrdPdT2z13aMePQEZj2OtlFN6SkoA0y
	XMqtTppkOXmGVYqZD1Q+cUI0MWIFHvX9Jm06bILSv/5FqyqXtFBOgy+RKK3KgAIwMRHfMkMInDd
	+yJglygLrA4CsjGJHLCqjvGVsbu5lTXHILRl9jUefYLhTOFSwvTvl
X-Gm-Gg: ASbGncvDago0pYPKMOKVnkCbwNBp8/22WvplsNpCSFR9pIDZxuh7/3Mc8jLbJslN7Fs
	IiLHgEoZEDDlwtRttfOpT1K2oVMS7FefD36ggtlfNmMht+EmxX9/P9WxCwPVmuOc5r0ll4ephiY
	yfgcR/hPyXk1rT+ur6xxcC+LYmFigwPGOweHJ2iuNA9fS40Xt8SUcXK02RYMLuI5Gan5tq9/wlG
	bRqITM0jqRw+jqXZ0LThC5crZAx9bu/joCPn4VA+fmYb4Fw9TupDokOWGjX9fzLXKEGVVKPbo7x
	IOzv4xMIyupJh73Bx1FtokkJZJ1EMxdBZa7e91RFJhkkuuuS0Furrkq+2LvFnxKWrmmKPeieJW0
	3x+eaO4NnJQwvBef64IkcSpk1WhcSgtPY8mVFctztSFUAcQICTfTyQlEhqPXesOmrtm6F
X-Received: by 2002:a05:600c:4e8b:b0:46e:37fc:def0 with SMTP id 5b1f17b1804b1-46e37fce148mr14763405e9.9.1758810398146;
        Thu, 25 Sep 2025 07:26:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHjZJ0WBMi2SLpg5brCAPP2ix/UVmUI6Mp8N0XKACsUKpJXXguXTVe5P/uAzXY2rpR891e88g==
X-Received: by 2002:a05:600c:4e8b:b0:46e:37fc:def0 with SMTP id 5b1f17b1804b1-46e37fce148mr14762275e9.9.1758810397527;
        Thu, 25 Sep 2025 07:26:37 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08? (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e33bf6ecbsm39061825e9.22.2025.09.25.07.26.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 07:26:36 -0700 (PDT)
Message-ID: <3a82a197-495f-40c3-ae1b-500453e3d1ec@redhat.com>
Date: Thu, 25 Sep 2025 16:26:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvm-next V11 4/7] KVM: guest_memfd: Use guest mem inodes
 instead of anonymous inodes
To: Sean Christopherson <seanjc@google.com>
Cc: Shivank Garg <shivankg@amd.com>, Ackerley Tng <ackerleytng@google.com>,
 willy@infradead.org, akpm@linux-foundation.org, pbonzini@redhat.com,
 shuah@kernel.org, vbabka@suse.cz, brauner@kernel.org,
 viro@zeniv.linux.org.uk, dsterba@suse.com, xiang@kernel.org,
 chao@kernel.org, jaegeuk@kernel.org, clm@fb.com, josef@toxicpanda.com,
 kent.overstreet@linux.dev, zbestahu@gmail.com, jefflexu@linux.alibaba.com,
 dhavale@google.com, lihongbo22@huawei.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 tabba@google.com, paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
 pvorel@suse.cz, bfoster@redhat.com, vannapurve@google.com,
 chao.gao@intel.com, bharata@amd.com, nikunj@amd.com, michael.day@amd.com,
 shdhiman@amd.com, yan.y.zhao@intel.com, Neeraj.Upadhyay@amd.com,
 thomas.lendacky@amd.com, michael.roth@amd.com, aik@amd.com, jgg@nvidia.com,
 kalyazin@amazon.com, peterx@redhat.com, jack@suse.cz, hch@infradead.org,
 cgzones@googlemail.com, ira.weiny@intel.com, rientjes@google.com,
 roypat@amazon.co.uk, chao.p.peng@intel.com, amit@infradead.org,
 ddutile@redhat.com, dan.j.williams@intel.com, ashish.kalra@amd.com,
 gshan@redhat.com, jgowans@amazon.com, pankaj.gupta@amd.com,
 papaluri@amd.com, yuzhao@google.com, suzuki.poulose@arm.com,
 quic_eberman@quicinc.com, linux-bcachefs@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-coco@lists.linux.dev
References: <20250827175247.83322-2-shivankg@amd.com>
 <20250827175247.83322-7-shivankg@amd.com> <diqztt1sbd2v.fsf@google.com>
 <aNSt9QT8dmpDK1eE@google.com> <dc6eb85f-87b6-43a1-b1f7-4727c0b834cc@amd.com>
 <b67dd7cd-2c1c-4566-badf-32082d8cd952@redhat.com>
 <aNVFrZDAkHmgNNci@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aNVFrZDAkHmgNNci@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: l9z2A3TSg7t26OOqZIUUp5tMLizzqzZIrgt2OXg78gk_1758810399
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D371280017
X-Stat-Signature: kqfrg3s9bpqti57d7564eks59c3affuy
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758810403-47622
X-HE-Meta: U2FsdGVkX1/TMgYCp8uRkdHWWJp4psIMlCbZP2ituzKfL+5eeLGnYrptUR4k61dsOdSQcLIfGWIYcYaC7mU+56L0LhQ0qTJjCUXDgfmOTIdnFFbvT9xPf+u83GcdAYTCHDqfoi9v1zprc3KIRvxvg2LPxMM0djRiHDoQvOhtjWYnTdGDQXyQYjYaw5fkfjnzP7W5Tg1m9Wp1cg+CXduzsIMCq+w2Ac9yWxQNyrMehhdqqFZgzmb1Fwdub/7e/7dWkMctGcWyLSnxSTtXpg56M+GxfF7bpMEnL1jUWm7O3CgBzqYccFtW9UFdlWeQKeAM53X83SFTLOWySS7Lf4ElJKj7eyw8rKQUA6A5BrrVWkrhR23boRc9XwaXo60NVrfw7ac90r/cmNOtYQGwct4IDGr96WQR219HWBCgxLB0WSODj09Y9EA3RhFHunRYGRbb39q0qVmKbcJy4JaNde6JRAmBhHtiYdOQMmJMh+SbkcNIRvcudKc9FaT2/7d3i2z4+diK9bEuSsmafFgbcNpn4dHFo8yve4ljJVICVVBRgiSdjvZ5ACyegrdsrGJmBTgeF2bNV/OuvzOGCZjwnh7p4eKfGFdPvM3k6wfJqpn2/U/ZAjpOyr1fucNCoLx8JYymZyvhi+/wxydKzdT7ZewlLkmgm/EO8NXR+3wFjd9KHwvwSiE2jMCv69OR4YMk1e8+3Mg1m8THrCZcokfrEmihsq0Wh5uhABytWv/tsm2T15XeANIq7L4eYKqT4C6eOIAt9u7qsuAGVBv88OO0jeoIet8lBrDYc/V6f2hinDBGN2/6vpke8jKjUs7HBCzTsWXC8RdGnJmL1M7E6QHHTVi0n7qF7ZXx+YitlyR3c9/IopqjCcXjnJKFfqPhyaK0e6U8IgwW0GTZzNwnpSdRIFJ9zX2QnjYSY1YEplE6Zm28e9RzFyNina8HYuRU6E5tlsgGd4OMLTxgjUNfDseuVGb
 NE/VoukF
 kYFc1KHb1CVJhn0fGeBMr3RMxyMevkcgM5CCbnjzAWEmrEDCsrdDF5rbHTV/lkj7rZP4SlMF0f4PI0inYjniiPr9Le2Q4yMtdeQkewfop2Z9bHIbEkyZpfyby1ZlQEpct44IDjDYW6VSxmrOORjI2BteSa+6cM9t2cMrRb28dOv2jbZvwBfO6VRHtRKxKkGbbJnIhziOsXRtQ6TPOIlfATVw2cKxbMk9IdjFc5Hdzy33sitlcAtJPF3vC74mxKye1BWXD4ZsVIa5Qoi7sTQvl+f3+Ir7dBwcTTkSzxLhLquwWUvpTv9jhE25xdMNXeqJKxLbgLX9Xu79KmWxxmZsommqbZ0qmbg2WmR9yWCBmI89qGQAi7eHJSqyk+yenX0ZEqYuyziKxOPG3ca25jmWSXOiqw0+IgheJJGQiDw7uN6NQ6E/kgez/BV2b9YqIOJghc10VnC+ch74usRxTiGqR0G7vqXlw+TWqKKb2RbSY+hQQS1dY/74wfE20Nb9OvfVbVouANZ3SKt0qFvuxBFRAZky058a69yBxhTIPinlr0Of+Hn4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.09.25 15:41, Sean Christopherson wrote:
> On Thu, Sep 25, 2025, David Hildenbrand wrote:
>> On 25.09.25 13:44, Garg, Shivank wrote:
>>> On 9/25/2025 8:20 AM, Sean Christopherson wrote:
>>> I did functional testing and it works fine.
>>
>> I can queue this instead. I guess I can reuse the patch description and add
>> Sean as author + add his SOB (if he agrees).
> 
> Eh, Ackerley and Fuad did all the work.  If I had provided feedback earlier,
> this would have been handled in a new version.  If they are ok with the changes,
> I would prefer they remain co-authors.

Yeah, that's what I would have done.

> 
> Regarding timing, how much do people care about getting this into 6.18 in
> particular?

I think it will be beneficial if we start getting stuff upstream. But 
waiting a bit longer probably doesn't hurt.

> AFAICT, this hasn't gotten any coverage in -next, which makes me a
> little nervous.

Right.

If we agree, then Shivank can just respin a new version after the merge 
window.

-- 
Cheers

David / dhildenb


