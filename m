Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1422ACAC5AC
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 07:31:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B5168E0002; Fri, 26 Sep 2025 03:31:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38D528E0001; Fri, 26 Sep 2025 03:31:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27B898E0002; Fri, 26 Sep 2025 03:31:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 166468E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:31:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B733613B71E
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 07:31:30 +0000 (UTC)
X-FDA: 83930581140.04.090D7C4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 72B8810000C
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 07:31:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C6K6JIY9;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758871888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zN4peVxWL0zSknKb/nxU8BZxb2xqfgd1C45ub1DITH8=;
	b=Q/d9ij41iWsYn+Uw3pOiFPwrtRmn4siklWIoouDkxWBRCU3bXTzp6gX2P7Hx++jI6iH9iN
	PF2xbyUoBBIdc+PiyazWexIrQWR3+9Zj3J3p4XjQO3d/U6n0aRLo1fVZtlLG4XS+YX0LV0
	mEVg2eNdzkyik0RxnZg9rK8WF4jmtDI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758871888; a=rsa-sha256;
	cv=none;
	b=cGeisq2c+RnfacU/+C/viK6Njk1eI6tc0xPIDvMGYTTy/+vs49uH1osDVU3WoFDwXwggdP
	QHUh007drmY6ybIcM6vLhF9D6dF3lI13Q0oqcw/2Bu7iYZmyJ3qYJNIg/myoH1kSZqmbFj
	KM/udB9DxL861RkOvWE1Pge0WinVEcQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C6K6JIY9;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758871887;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zN4peVxWL0zSknKb/nxU8BZxb2xqfgd1C45ub1DITH8=;
	b=C6K6JIY9uJPtNjlhYFiJW74bil6xsRncDiBoNbtCMf/1OS8SQMkPMfZzoXGDoMRrKx5RR3
	USu+P+thlLncZjbscdTukSFO1WYwCclQfJl8bJSpjHxwvkC9actWPNYx/af46x64IcFAVR
	bnjc4v0rWDgdLOnz3dkIu6m1FXwaTI0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-215-Cw9beDdQMPKKJA77z6wKYw-1; Fri, 26 Sep 2025 03:31:26 -0400
X-MC-Unique: Cw9beDdQMPKKJA77z6wKYw-1
X-Mimecast-MFC-AGG-ID: Cw9beDdQMPKKJA77z6wKYw_1758871885
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e3d9bf9e1so1668615e9.1
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 00:31:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758871885; x=1759476685;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zN4peVxWL0zSknKb/nxU8BZxb2xqfgd1C45ub1DITH8=;
        b=DZS0CwKc0oWhNyFV7QPRdbSapzULt9Fk+xWsv9AjDLEjzAhTSUW8pnUuBxAVV90ugt
         gEq7plunIito0rLbpocKs7Koi7KtaLhT4BQeiQY+5xIKt4KUOZJIEFhJSE8YxcbZVUTw
         1rjdD06tbKLFqpRmh2H4/GQao6/qEaKkhuofQuuOHgBz/Fqw9H+0IQLTW85s6VTKsVaI
         BGH2wv13vKEhQPe4GNN4iKfFatnshkYCDkT5rGsmnFkZMSGrPn1myHDij5qsAFtL2+93
         OTmMnzM7+VhvlTZ6RgO7BCworHoKeg+AP8CCZGzlA0Lqf2tK+rQivkc5Ghba2DkGJ3yM
         QD2Q==
X-Forwarded-Encrypted: i=1; AJvYcCVg1O+AgOodP5VBX/nmEmg04STzCxZmo61vPaG2z4+9xbPivXLYFYGo8V1Li4q8HjuBF2th4FiTHw==@kvack.org
X-Gm-Message-State: AOJu0YyL/0OSCcWrMkwuAEGNp5FJ+11Tf1noGg00wCEFhK6+154mnrEI
	0tLFeqf6516dweK5RqXmgA1nvh/OThXeNb0nGqVF+eWSgrwOEJ/4U00VkFC8n7gYY5i5HcksW5q
	XRMSGEyUgmoyp010s8Y2+eJ6AJV0zcnb6lBy7ew7trEC+gRX/tQ1/
X-Gm-Gg: ASbGncu8+H134ApBxWzzLbe8PJtcCDSCOERpCaDUJqYTgl5oJl1ZnNonxV+9V5+pWUp
	O4LuK9Gz+UbhDLfYPVqNtoSKG1Gf3QXHu9LNQpqNYrVkIYw/IuIiQbi/bMcxV1uR4yzjERa1t5v
	oiy4EtAgW/6iXznJWONo1BfC+ls74+wsBOcOH7I33WlPUbSF59Te5cf1xomB8wJLk4MkkU1HdY0
	JcKzmaeRbpma6v9RVf0/7Ylaur2pZndmdSScrfoB2ezBUtwAwS0KGtXg40ABimwyaZZtsnfRjOd
	EZkTacl2ajVNKe+pGRXuCDtu9jP+OiGcsKiHEOdYUfF81cKcTd0tfHmolBGMeJMrvG4BfFDEVMy
	+OtlQtNZM6STTQa1+rLhGtbgZM3/A2MB/rsd2vm+HrF0EDiwEUssDg5i9Y9TOaymH0l58
X-Received: by 2002:a05:600c:3ba9:b0:45d:d2d2:f081 with SMTP id 5b1f17b1804b1-46e329f9c61mr65568825e9.20.1758871884794;
        Fri, 26 Sep 2025 00:31:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEdCFTWN0OMV/8re7i7X1C3LDq1oeLqj0b7w/lVtU1L4ASh3eR7s8IXfpyY0kZjgB5RF7jO9w==
X-Received: by 2002:a05:600c:3ba9:b0:45d:d2d2:f081 with SMTP id 5b1f17b1804b1-46e329f9c61mr65567615e9.20.1758871884155;
        Fri, 26 Sep 2025 00:31:24 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f34:c100:5d3c:50c0:398a:3ac9? (p200300d82f34c1005d3c50c0398a3ac9.dip0.t-ipconnect.de. [2003:d8:2f34:c100:5d3c:50c0:398a:3ac9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2ab61eecsm105756545e9.20.2025.09.26.00.31.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Sep 2025 00:31:23 -0700 (PDT)
Message-ID: <95ace421-36d2-48af-b527-7e799722eb17@redhat.com>
Date: Fri, 26 Sep 2025 09:31:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvm-next V11 7/7] KVM: guest_memfd: selftests: Add tests
 for mmap and NUMA policy support
To: Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>
Cc: willy@infradead.org, akpm@linux-foundation.org, pbonzini@redhat.com,
 shuah@kernel.org, vbabka@suse.cz, brauner@kernel.org,
 viro@zeniv.linux.org.uk, dsterba@suse.com, xiang@kernel.org,
 chao@kernel.org, jaegeuk@kernel.org, clm@fb.com, josef@toxicpanda.com,
 kent.overstreet@linux.dev, zbestahu@gmail.com, jefflexu@linux.alibaba.com,
 dhavale@google.com, lihongbo22@huawei.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 tabba@google.com, ackerleytng@google.com, paul@paul-moore.com,
 jmorris@namei.org, serge@hallyn.com, pvorel@suse.cz, bfoster@redhat.com,
 vannapurve@google.com, chao.gao@intel.com, bharata@amd.com, nikunj@amd.com,
 michael.day@amd.com, shdhiman@amd.com, yan.y.zhao@intel.com,
 Neeraj.Upadhyay@amd.com, thomas.lendacky@amd.com, michael.roth@amd.com,
 aik@amd.com, jgg@nvidia.com, kalyazin@amazon.com, peterx@redhat.com,
 jack@suse.cz, hch@infradead.org, cgzones@googlemail.com,
 ira.weiny@intel.com, rientjes@google.com, roypat@amazon.co.uk,
 chao.p.peng@intel.com, amit@infradead.org, ddutile@redhat.com,
 dan.j.williams@intel.com, ashish.kalra@amd.com, gshan@redhat.com,
 jgowans@amazon.com, pankaj.gupta@amd.com, papaluri@amd.com,
 yuzhao@google.com, suzuki.poulose@arm.com, quic_eberman@quicinc.com,
 linux-bcachefs@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-coco@lists.linux.dev
References: <20250827175247.83322-2-shivankg@amd.com>
 <20250827175247.83322-10-shivankg@amd.com> <aNW1l-Wdk6wrigM8@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aNW1l-Wdk6wrigM8@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xYae62keoxILYrQS2f8VfTZmZkceyRpj4q4X7VYma7I_1758871885
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 72B8810000C
X-Stat-Signature: zkaccqxwc6d74ro8o3yfkh8o4yedoghx
X-Rspam-User: 
X-HE-Tag: 1758871888-676425
X-HE-Meta: U2FsdGVkX1+Jhw8B8FF9P9trhqMWwyRY6ji9itjsZ4Z7BejwC1a2geP+xxFdqHQfrEE0mASdZ6Xhm/FrEo0kepYRjKFiNDP9s/yPv2QNRa0N3U4EynnmQSsjh/EnIV6seYHQKS53xogTIBVGoO1iuUpFmJoaAnkyplK724I3DITkdwpwynbXIvcuXzIK1pLLkpOpl5efCJKlHMIu/4APO8OGgL51OJkxI4g3IllYP0w/b8OvSagVfDsdHslMNZ8pPSpbKRz6jzUo9N+wRrxDCm9q74reKFdD0Wsw/1OdP4psWlSkaC2TAmLb6c/3fxNdogO/RYXNQc37EUloRec41pgSiGnDj+k9PwmWr3I8qF1ipeumhvQPS7qPP4ns9A7Ar/GuZZo9qPsAAEAQu4fZbPEelKysXaCfplihyk8DDOAQ3EHEfPUTK3lD7Lty3Qx3KvrFhvC+DGoKAXvuLMRFGqcy/lceBbqMIbyq9QmMlBCkYCBCqD1brVMWvVWSl28HbU32KrqhJE8PmKhHSLo15AJGGZlQGcVWt0e48yV0UEU5/PyaRDJGWx20BLczoX3Due07qQZCHBrcWsRt9dfhr7CpptKJO/B4hYk9VkbmBs2oBWvb4V9/Vl+sZvDMIGkcYuqn2xxyPl0hZ2w76YvD+HZK6UQVIGUHe3oOTaQOWAtOF2q4ijJoElcdZv71P2oZ327qoVSSHFK8NgixoafVyiE64ZKUE+fLozhAnP13A3+8Gk3w7wVVXYWIafaZDsPguRpAkPSj2D3BeJ6xh+0OI147djhzEnfZ1dT0gPvnO4lokCNLQ85VwRYnmQkZYy7PMY6+uk0/gmnWyjcxV4le1wuy55XozDfOXDgFnEpSATM5VDKnDEkWB+5KK9TksC0HS3IIvAZExoFzs6sXbiub566bwYk9mrDzb+z8cD0wfiPhU+67FomImbekIH9OcB4a6yl650jdXYmyhdUkwlf
 yjFGylcI
 re5F65WgE5BHGur52xYI10FrR9eSZjYSEdOxT9HijcXFqeo9cu0Mm90JO+pW25D6h9P0Se1YKre87gOy7GNLU2rwOD+SRGI+IXbTxFZPDFVshkKuzS+C7L6FUmNrlhGbu/Gnf7fj/eaCKbEQTZ8U+NSnpnDvNpVHcOj15
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.09.25 23:35, Sean Christopherson wrote:
> On Wed, Aug 27, 2025, Shivank Garg wrote:
>> Add tests for NUMA memory policy binding and NUMA aware allocation in
>> guest_memfd. This extends the existing selftests by adding proper
>> validation for:
>> - KVM GMEM set_policy and get_policy() vm_ops functionality using
>>    mbind() and get_mempolicy()
>> - NUMA policy application before and after memory allocation
>>
>> These tests help ensure NUMA support for guest_memfd works correctly.
>>
>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>> ---
>>   tools/testing/selftests/kvm/Makefile.kvm      |   1 +
>>   .../testing/selftests/kvm/guest_memfd_test.c  | 121 ++++++++++++++++++
>>   2 files changed, 122 insertions(+)
>>
>> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
>> index 90f03f00cb04..c46cef2a7cd7 100644
>> --- a/tools/testing/selftests/kvm/Makefile.kvm
>> +++ b/tools/testing/selftests/kvm/Makefile.kvm
>> @@ -275,6 +275,7 @@ pgste-option = $(call try-run, echo 'int main(void) { return 0; }' | \
>>   	$(CC) -Werror -Wl$(comma)--s390-pgste -x c - -o "$$TMP",-Wl$(comma)--s390-pgste)
>>   
>>   LDLIBS += -ldl
>> +LDLIBS += -lnuma
> 
> Hrm, this is going to be very annoying.  I don't have libnuma-dev installed on
> any of my <too many> systems, and I doubt I'm alone.  Installing the package is
> trivial, but I'm a little wary of foisting that requirement on all KVM developers
> and build bots.
> 
> I'd be especially curious what ARM and RISC-V think, as NUMA is likely a bit less
> prevelant there.

We unconditionally use it in the mm tests for ksm and migration tests, 
so it's not particularly odd to require it here as well.

What we do with liburing in mm selftests is to detect presence at 
compile time and essentially make the tests behave differently based on 
availability (see check_config.sh).

-- 
Cheers

David / dhildenb


