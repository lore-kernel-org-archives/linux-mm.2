Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD76760A2609
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 06:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=WjGorvLn
Received: by kanga.kvack.org (Postfix)
	id C82236B00EF; Wed, 11 Nov 2026 01:33:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C598A6B05B0; Wed, 11 Nov 2026 01:33:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B97166B05B1; Wed, 11 Nov 2026 01:33:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7FAC16B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:33:47 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 043AF120212
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:33:46 +0000 (UTC)
X-FDA: 85421872494.14.14A3048
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	by imf08.hostedemail.com (Postfix) with ESMTP id 39085160002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:33:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=WjGorvLn;
	spf=pass (imf08.hostedemail.com: domain of 3Rwz0agkKCI4Bs9C5AszCy66y3w.u64305CF-442Dsu2.69y@flex--tarunsahu.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3Rwz0agkKCI4Bs9C5AszCy66y3w.u64305CF-442Dsu2.69y@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794378825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N2mgW6LEnNu8wNmnoa3+p3F6g8tYE7yJEu2kZeiGcR0=;
	b=iILQ7zjlhJY/6Y+q77tMhT3sXj+klGu5JtepMqfQwQWwmgIPi+kT9OwvXbzkD3zzjCxi2j
	gFXNmFQiC/7Ttdkm23zDQQcjVcXV4Ks0Sd81pjIPcmRnyAmTWWedYuH4Tbbj9Hz2hto4EZ
	mPovM/e1jjuoay6oIRIQf135yzx2eSc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=WjGorvLn;
	spf=pass (imf08.hostedemail.com: domain of 3Rwz0agkKCI4Bs9C5AszCy66y3w.u64305CF-442Dsu2.69y@flex--tarunsahu.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3Rwz0agkKCI4Bs9C5AszCy66y3w.u64305CF-442Dsu2.69y@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794378825;
	b=5qes2MjXvo4q5HfxE1QL1vfIItNj8tPvT70pIhLF/hys4LBkfDlNEHpYONrb6aDFhAqCLn
	ssm2AecBr1p6nB96jKnTpHaWcF0X0+Yc/Hu7W3lRWBlRvXfpLb0hJX4NUXm1nIr6eiOdSv
	HzTg5r6A2NY9yxq/84z7/MDaKgJZpKE=
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c505eecba6cso70632866b.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:33:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794378824; x=1794983624; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N2mgW6LEnNu8wNmnoa3+p3F6g8tYE7yJEu2kZeiGcR0=;
        b=WjGorvLn/OgTvn6tyJB9G1DLszPzAVhouKc02RI6/iP30JFxXfd+TGZwZHkBMKvLbq
         0GZYl7IJ/kHkjAR3HKDlkKq7q8u+7gi3EYI2n6h23wvsqud4QjgDHbIbVQSIP5g/5hcL
         0+EqXEGuKJCZcsQaXgngoiDIuw3pN6TsqrywNylnEnJmPfqflJNDWXp24/+WdxjLKrhc
         mDuT2szyCmOdyXhxLWXqBBc+JsNAKt9VBvqkJnK0LHlzj/3yMYSy0nP/fxfMkiyrKaj4
         XGjRGI4Qb8voMmcX0geVZcI192PJq0JN2Ox9wE4//CHcgu5es/J5T+xv9A13jYNCSd4R
         EGKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794378824; x=1794983624;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N2mgW6LEnNu8wNmnoa3+p3F6g8tYE7yJEu2kZeiGcR0=;
        b=19sY9uP8wUwmuUmZOjQYiLy3YFQbzZqhyHcboKXVXvkJSmvWRt7Fdto/gfph/GztXi
         4Y9GBVJHXDg5TvsQWtzHQAFVrl7vSMKI1XNXCoJQklc+YcL/+eWdrOqCatADgDayLp9t
         dKgSSDIekS8ODSimBZikhBfIPNXSr+lkjplDW00UD2PXcBRgdOXrvLY0llxTyfhlX31d
         YKgZw4LaHdh8+h9g/a4tbODhiiP4oQpe/ssjqlaw11uRw8aqB6l2sLLQP38POLNJBrqb
         uujc07MVB38YTayrimiZpt65qwvsaWD7vhRc8calCZ809hXWkrgzxEmtQwA7GGRSOZR7
         uVOw==
X-Forwarded-Encrypted: i=1; AL+hErF2FrWV2JL5c3tCXkmDAxBVcfmtFgkOT8WCRRFEKUdKu2EKT+sYTLRKVFnGKcRmV+2Eu6SZQuoWiA==@kvack.org
X-Gm-Message-State: APuU4Z+Ge6cv9aK4tTxvQzvObn9qIE7nANKTrBmzVuBd3d0xHGZIVYaJ
	xWT6nmAc9yTBEsYp8U/oqq1l4II/wJeklZ+YkJYgm2k2eLiZEmahScDxzI8cmaJRVjAtYER/w6y
	NUlpwCl3d7Ylue+x/6Q==
X-Received: from edgi9-n1.prod.google.com ([2002:a05:6402:a589:10b0:6b7:8226:b2f0])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:613:b0:6b1:ce0f:eb6b with SMTP id 4fb4d7f45d1cf-6b777700516mr806340a12.31.1794378823419;
 Tue, 10 Nov 2026 22:33:43 -0800 (PST)
Date: Wed, 11 Nov 2026 06:33:42 +0000
In-Reply-To: <179432329215.2329176.14453669404153142360.b4-review@b4>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com> <20261110050202.529473-7-tarunsahu@google.com>
 <179432329215.2329176.14453669404153142360.b4-review@b4>
Message-ID: <9huzv763q3ll.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 06/19] kho: kexec_metadata: Add the feature header
From: tarunsahu@google.com
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, 
	maz@kernel.org, will@kernel.org, David Matlack <dmatlack@google.com>, 
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, 
	arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	Bjorn Helgaas <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, 
	gle.com@google.com, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org, 
	kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: fkmqcjwbfrfsxqnnsrfq765c5qe9d63k
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 39085160002
X-HE-Tag: 1794378825-157470
X-HE-Meta: U2FsdGVkX18iMWncTMKfveLj8bcXiTbe3WXVGZSQq6oA1wy7w426Hh1Ufk+oaKDHGLXlfbwUy1ulRpaj1fhG4uHheVjG3vxa8ATw5QeeCSHW5Skdsih9Bao9Tg4QZ95WhC/MpPFtVVfcUKzIDDUtRiQEVMhRK7Iv/SBu1eAnrZ2xoDqs0mfRNYD31cEikgsO6mn5m7/i1r5xCp24HH2kqNFIcRZH023AMPMh6BwmNzvaJTGUP7ozvY1CA9xXmVx7jmfMQDv3phAwvTQnoYXLC/sed7l9SyzMb77cmixF/QWZrTpU+e4lpoMjwEA5T4kzXSwGqnyIEkIy4yWF+SixPxZlFy7PJSlqLhwlxDtzZY5RrvofUE4IcKkjtxFEwtetORy0XMe0SYwYzkJn89s6N6Gi7MVE6HMp1IFURM+DORk+h//jHwscrKMn+vyg3jfmhn1Un2yNAp2JXFpUmUheDuYMadKCoT+p+D36mjle2vbW+t7Rq/WflUekiAZlZscM1aT7AU/6IJjka/DJtdKvmE4J4ISuh8JQf3wZCrl23VD5pczphH1YLSRNYn6WcDevMuVR3Rae82h7zOXmpn1x3zjoKafXiel6yYGf7w4tKTsze5Mz50q88J0QDzxB5kDeXzB2pMFpVwwTf44qdtUe7jvDdKxnHs+rqxQ9MHBONVCDfOY8XUhbbIb3wu5vIOAbgZU/70dKGrE7AbPVprVwDJBPrvGPZxV/UxORmc5QjH0KegCv5+ZfEBQWO/g8+G2+9nKtW/TjpYcaWZ8bPSAXxRQmYt5OG+X4ZS73JThwpFsxLPe3tuJLtuKaln6F4hx6GjEEt59Cx3J6L3Hn5k8+uBJfp2OL+lbAD1KxGiK5i1q3WEC8aEBx0loLRuHvyaARKlsQBblzttJ67fs6Wo5GsQfRRpxxRJeGBfUf3QEUFECyLw6gIICwUNUiCKRUU52b5N+xe7mevz2eKfWnMSL
 VU+Aox4x
 yGTY68Mhh+C8eMh+s/wTF9/xT9r9AT2ZZsXoZB1StjQpLLNc61k2QxgPDAxZ1d8MXkt0Hkb6RgfMC2sqdfc6qmWCPAjvERagrzfLKbihZiiQqKm9XRQTx4GuF9tu8Ghj8V1Gh7s5kUubNjmVPF/PH9uF9SzHfKY4G6bthLWtDk2xvK8dnBLX09udCHpfHhX4OGWGO1wPwylUXjbYjOAS9NY26Cb4U0+vw3ihdKAQvh1MrzMKTYTbIhHnTndCf0odZO7dp7Or63cu1GUElz+wtbPdii1lZh5GOSJ7jnBOZvDM7LGvAhE2J0t+0PLphWFeTQ/rcBMyn+Zxx2rdMzBjODP31Jq1UbokbXV66pSZYqJugIzXZxUmvh61tAM+Qy7+ZTKmGuXnOKp6TMIyQWnlgIja+5YvJaRXwPX02XUzTr6NBlo353TU5kV7VCGzfvxXkMftAZ10bLpCsNB1wsL7DMrtAzYjqGA8WsZ5oeOp2ajb+rW9icTBKdeT0rdCI2VBSHin1176KFPGCGTxelyjxiq8bzQhOUxD4pPl1KHb74by2UNRf3pz2LooZO5FooW1kH8p6xFZJTvzx96ZxOC+318k3xLdqycdcx48HQbIAhgvb+qDF0/NenX/eqxse6s6uRd8QHBR7bgDos7Eh9DfWw/+SRKdetv0exieDB+6FS6HeCKuyiy2UPU7BloDXQwYrkFMq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Pasha Tatashin <pasha.tatashin@soleen.com> writes:

>> The kexec metadata subtree currently uses a monolithic u32 version field
>> to identify the metadata structure layout. Any change to the structure,
>> even an optional additive field, requires incrementing the version and
>> breaks compatibility between adjacent kernels.
>> 
>> Replace the u32 version field in struct kho_kexec_metadata with
>> struct kho_ser_hdr using DECLARE_KHO_SER. Later fields can be appended
>> under new feature indices without breaking compatibility across kexec.
>> Also make the 3-byte padding hole between previous_release and kexec_count
>> explicit as reserved[3].
>> 
>> During deserialization, validate the blob size against the header size
>> and reject unknown required features. A legacy v1 metadata blob is
>> ignored with a warning.
>> 
>> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
>>
>> diff --git a/include/linux/kho/abi/kexec_metadata.h b/include/linux/kho/abi/kexec_metadata.h
>> index e9e3f7e38a7c..316b3e5ad01b 100644
>> --- a/include/linux/kho/abi/kexec_metadata.h
>> +++ b/include/linux/kho/abi/kexec_metadata.h
>> @@ -18,28 +18,31 @@
>>  #ifndef _LINUX_KHO_ABI_KEXEC_METADATA_H
>>  #define _LINUX_KHO_ABI_KEXEC_METADATA_H
>>  
>> +#include <linux/build_bug.h>
>> +#include <linux/kho/abi/feature.h>
>>  #include <linux/types.h>
>>  #include <linux/utsname.h>
>>  
>> -#define KHO_KEXEC_METADATA_VERSION 1
>> -
>>  /**
>>   * struct kho_kexec_metadata - Kexec metadata passed between kernels
>> - * @version: ABI version of this struct (must be first field)
>>   * @previous_release: Kernel version string that initiated the kexec
>> + * @reserved: Reserved for structure alignment; must be zero
>>   * @kexec_count: Number of kexec boots since last cold boot
>>   *
>> - * This structure is preserved across kexec and allows the new kernel to
>> + * This structure is preserved across kexec and allows the target kernel to
>>   * identify which kernel it was booted from and how many kexec reboots
>> - * have occurred.
>> + * have occurred. Preceded by &struct kho_ser_hdr.
>>   *
>>   * __NEW_UTS_LEN is part of uABI, so it safe to use it in here.
>>   */
>>  struct kho_kexec_metadata {
>> -	u32 version;
>>  	char previous_release[__NEW_UTS_LEN + 1];
>> +	u8 reserved[3];
>>  	u32 kexec_count;
>> -} __packed;
>> +} __aligned(8);
>
> Why __packed was not removed in the first commit? __aligned(8) should 
> not be needed, given that it must follow DECLARE_KHO_SER which is 8-byte 
> aligned.

because this structure is not naturally aligned and we have o add
reserved[3] to make it aligned. So it will be ABI breakage. Adding
the KHO_SER_HDR is also ABI breakage, So I kept both changes in the same patch.

For the __aligned(8) part, yes we can remove it, I will update it.

>
>> +
>> +/* Register kho_kexec_metadata with KHO serialization accessors */
> here and in all other places, please remove this comment.
>
Got it.

~Tarun

>> +DECLARE_KHO_SER(kho_kexec_metadata, 72, 0, 0);
>>  
>>  #define KHO_METADATA_NODE_NAME "kexec-metadata"
>>  
>> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
>> index 6f1f55fe3181..2edd772bb6d3 100644
>> --- a/kernel/liveupdate/kexec_handover.c
>> +++ b/kernel/liveupdate/kexec_handover.c
>> @@ -1740,6 +1740,7 @@ static __init int kho_out_fdt_setup(void)
>>  
>>  static void __init kho_in_kexec_metadata(void)
>>  {
>> +	DECLARE_KHO_SER_HDR(kho_kexec_metadata, *fhdr);
>
> Please don't do this, use kho_ser_hdr directly.
>
> -- 
> Pasha

