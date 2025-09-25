Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 054E6CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 11:55:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A3468E000B; Thu, 25 Sep 2025 07:55:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52C488E0001; Thu, 25 Sep 2025 07:55:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A6328E000B; Thu, 25 Sep 2025 07:55:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 243548E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 07:55:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CAB9611A220
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 11:55:36 +0000 (UTC)
X-FDA: 83927617872.13.77E28A1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6205E140009
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 11:55:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NJkX5mhk;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758801334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SCbRU8MveS1pgXPDEzPy2kt340UB03o/vXxtaoaDWAc=;
	b=JFshFDlD1AaGkYyqfH4W8ff3rTTXKl0iuUxbigOc7wwvi+EBhMt/x6X3QvganamkKmsjwc
	Lj9oUPNRNJOXiIGl6zJsaLbm/VR5PLHZcj2CfCBpH4woagMj/4/zJrzh9yzozzYcdOXIYz
	W9b9GDIihn3eEkhzIf2DGK+ejZuEXmI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758801334; a=rsa-sha256;
	cv=none;
	b=ha9HZv5okhU4eovnCyXJ+haeM73Oo+zP2uS4BxJYVHNPL9gYrlWh5SyWw0qG8yGStLu9A4
	QwdQZ3TWh5j/LXxGQf/bPz3nHvP8G/SqgzcDd6BguBxJf14qlpC4Wzr5OB+mmVhIGKo8B1
	j9zTdWDPJSgGe/SShPiAA8ERzgLMJvs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NJkX5mhk;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758801333;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SCbRU8MveS1pgXPDEzPy2kt340UB03o/vXxtaoaDWAc=;
	b=NJkX5mhkzxPQya2MmhiH+5FEF5FrSa/jZgUe0ZAhDzuxe1kxrRIy7OCxkqaQPJvWGNIy2o
	Ln6ICBCKbDUORdGzzvRKmYcNsmJMRT0hegRBfMGEQkzmnflfaFeXerfNE0c2O+Lq5XktxX
	KX5yI6nOhq4tmUqpUfNjulCHks6m+4I=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-426-9xXiyawQPoGTd_HMmXCNEA-1; Thu, 25 Sep 2025 07:55:32 -0400
X-MC-Unique: 9xXiyawQPoGTd_HMmXCNEA-1
X-Mimecast-MFC-AGG-ID: 9xXiyawQPoGTd_HMmXCNEA_1758801331
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45de18e7eccso4732545e9.0
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:55:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758801331; x=1759406131;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SCbRU8MveS1pgXPDEzPy2kt340UB03o/vXxtaoaDWAc=;
        b=OXPauhL0XtTCFlyi+JVzj5xDonIb/YlDbJBGmCVc0xRYicoWKckfaw4t1hlZkgRpNO
         UV7BiRUOZP7HiGTpAo13/1469VEpkct8bDGSX6kFFoh2JpmO2Vf/qL/zT07CLBrVGr8L
         tS/e8OYFx/g4XLR70NzCdD1HbaB9IOuzdPDXaS/iZnSgjg5T28ljT+wlsJaxQQIRgoEI
         auCYt1xtiMtiCIc2sIvyeQDkWzL1YiruBqX7Tixg1rVseZcBV+4tcFCesYyjj5pmc6uV
         Y/FXb+/aJunQhYtPBBznx33TRtd2CPZ+Q/zd5y5uPXpayg8QEjcVKJc2LrbqsGOoKzbn
         5Jww==
X-Forwarded-Encrypted: i=1; AJvYcCWmmw95hKz8MVxmTsu3ZYLcTEANlLilLEiH3+aAcCzGlDbMQFyo/m/Op/xihFZazRndjZ5jal/AQw==@kvack.org
X-Gm-Message-State: AOJu0Yy2ixFNfzFlmq7oVltxsoW4EfOFxIVItN3idhKMLROfQtoOM1/0
	E/OTIv4FrsqmFfKPawW4IHQn82ZilAJoEmqK7Aqryh5t+iCd+YA6zySBavCGMROmPSsmmpMWXjg
	OvvE2c80YV/Gf0Q57qe88VZJfWyspRnOCfnWhCI2//nzfqoljWZyV
X-Gm-Gg: ASbGncvIHNwFOvtgB52VPV633oiX1zTHYtG/I5GG+DHpUI5fJvXNEKlnuYlzZtdm4SW
	Or+n1odZTyMQTodvE4ahrBS4GohMUFaaw/f9Gnu6SC1XBF20yloaEyCaXjCz65xxOAJdqHPvEu0
	tTRjHepYdugw9OYpE6OExJnM9MOZkZL4szUMEJQuqx08EJDwkscpMtvc7Ik7cNxfHfZEDL1mYfn
	poftYw/2hJCq4rf8tylUxojKCRoKzz+/AVNV/nvj/dnsWaBLZqxJvdrw18CQeJLT0fSP7dfP1ae
	Y5kiugsu6z5jT5+ckIJnCQyUzAJWZfEsQHcREMkEfIDAZoSHhjK7aJKo1g26Ia4GCUIToO4uCV1
	Ee8TWy09Xebgf+oGyNTnr6ZuQDjCd+7uWsmVdU1Y/HNVY5PovM3ZFpBZGLcP2B7TBxN8D
X-Received: by 2002:a05:600c:c83:b0:46e:1c2d:bc84 with SMTP id 5b1f17b1804b1-46e329eb10emr33699275e9.17.1758801330669;
        Thu, 25 Sep 2025 04:55:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHt88AWAVfrsW7XtYeqx9eAlzDx2ZLFWRXrQuLhkskEblyKaQxcWglP3fS9EKwD9xW0YpDiXg==
X-Received: by 2002:a05:600c:c83:b0:46e:1c2d:bc84 with SMTP id 5b1f17b1804b1-46e329eb10emr33698205e9.17.1758801329980;
        Thu, 25 Sep 2025 04:55:29 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08? (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e33b562d8sm31593705e9.0.2025.09.25.04.55.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 04:55:29 -0700 (PDT)
Message-ID: <b67dd7cd-2c1c-4566-badf-32082d8cd952@redhat.com>
Date: Thu, 25 Sep 2025 13:55:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvm-next V11 4/7] KVM: guest_memfd: Use guest mem inodes
 instead of anonymous inodes
To: "Garg, Shivank" <shivankg@amd.com>,
 Sean Christopherson <seanjc@google.com>,
 Ackerley Tng <ackerleytng@google.com>
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
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <dc6eb85f-87b6-43a1-b1f7-4727c0b834cc@amd.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 03weN8bqgMK539GMKoIOWEsazTZtCpXqHlnC5AsfKw4_1758801331
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6205E140009
X-Stat-Signature: xu1onmbhmhk569njx9nryq7ewig5ag1c
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758801334-917498
X-HE-Meta: U2FsdGVkX19oeSwhwpUObR7K4ktoXsgrZBHeg2qKMZU4anxdVAEPFTVJX1nj3K6RZFhm8lpxuai0is941ibYid51aaWxPDnQwrAPHao2c6IPPxVJ3Ut8PqScGH8nCrrr2wFxevgjh/U9JVqP2HQJIc4ZKy3xwHdmKqb0YR8NXecU+gdU50gHPIRLZit46L8nm61jbLCaRU8ZshGokQRQ2nL8HUn/m7p1WSq3yv9LSJL8Xnt2ZGYgPN8U+lKzCa0PkmaAAoSG+tRcvnkhCRaZiKYyYwZropLef8ZI5AR/jEDLRBoGHnU4dTz9pGW0m7qb9atdPgDYYG7CMEIKCLUNBu8mN+RKyEtVRnRGjrP1Ss1gEkv0nYBvIk0MLNCQLvz1FcCgDvYCw0fc8cfBr2M02VDFJfcH0DOJi8itJHjYN1rhngC+HzkDCBXATScB+KNsZLirfJUqxI/pagWdGU043ng6TMmXoIQYRfnfAbhXAOF+JCsK7CYsfhPseQluUsSKiDPP6A2gao7K4y7W2+4s6QfcoeTesy+pi6PiaXRsAaS8e40b7a4OCS3GfIUaudknCJsppIXEyctYLfh23Ro9+DfoZ2ovHsI7PSaF2TWauXxxuSjxRTui00+7EmtbxxtRU0tbcHdoPlaDuBE/VZQZCmnhk30n6YunZrSFmYvIvMQxx011Hyw+qIrKHljwb/5f+FBJSMKdVlsJgwtiXJjqrmbTIITeAeSv0soeLG8Xjapq8ByMixECE4yTqfh6uGEbwu4QyZMGtH8d4qk3Nnh38m4WdFieuqhiOBloMutL8HwxwGnWyDeUGKg690sDaqDg3NJxurKaDA+2PHqSksQlsLMsSTWl7lNfIBFPjBLYH+YJeJaD7evNIQ8JuR38DIYTBRSNuoJvleSUAhJZZoeaYtKtO1K1QM/1gjncHW3n+/zG06O8ehsPjqmyY2lgz67L4nqZxTJU1vQN+76nbQ6
 rDbWc3Og
 hVgLtTgcZ3PHYTWIF6pPuYziOfi6L78GDnUVcvgSWOMxoeWzb7xjznYhHuIQHVDtEIjSfPffY4vU9TDRfxVXV3fJkdAAd2WBm+i95LkBN160ybDtrcJPDGfJHSZP2qfN1CqByP2UijXIxsjp9W1MBRQaymMRvdOInJ9iMfCu29u237k4zX4ggQIe6P68ekPvFnTPxyFTSMYzVSOXnVTtMGrbbiXP5t2aUBXi704xqk7Lk+ecZr0vLsyjPYIVkKTzDqf++ErU9dVoRn1qUhy5BTFtZT0339Rn4lE5kxLjNcUjmmm3mP2Yic1Iw5X5U2DmuijPOuhtHbWc1XcoeuHMoQ5V7Kjc+PIiR6Iv0T4BngoAigDj+3g93O3WYQ8ljHmXqt0pBMpOrZIk7d0dX9+MK4uyvOnDIAVt4lVM0z6T0+gjAaJ/T9CfGLyW8DG8VWiBts4sBxBQF0Puztx40JbOCjG4moyaIVHrsN5U2Ot+o/5nw6y8O3eECmnXc6bAwjnSWT6lWPLQHygp21ryH6pXOtK2YxEmXPY/BoAlpKcQuIGNW1H/+bgbXIt1Ah1ni/ZMtvbc0A5NheJpGZ6w1F0/SwRt9XUr3CvkdNsvn9/IgqW2bRO+0MjMft429rRBWf84M5b8nkVQzDxYPCbCqTLvyVP4lHFsxgKul0xRwZ9qYbHGwY0jxKBIdbPmcPBdh70bnUZBK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.09.25 13:44, Garg, Shivank wrote:
> 
> 
> On 9/25/2025 8:20 AM, Sean Christopherson wrote:
>> My apologies for the super late feedback.  None of this is critical (mechanical
>> things that can be cleaned up after the fact), so if there's any urgency to
>> getting this series into 6.18, just ignore it.
>>
>> On Wed, Aug 27, 2025, Ackerley Tng wrote:
>>> Shivank Garg <shivankg@amd.com> writes:
>>> @@ -463,11 +502,70 @@ bool __weak kvm_arch_supports_gmem_mmap(struct kvm *kvm)
>>>   	return true;
>>>   }
>>>
>>> +static struct inode *kvm_gmem_inode_create(const char *name, loff_t size,
>>> +					   u64 flags)
>>> +{
>>> +	struct inode *inode;
>>> +
>>> +	inode = anon_inode_make_secure_inode(kvm_gmem_mnt->mnt_sb, name, NULL);
>>> +	if (IS_ERR(inode))
>>> +		return inode;
>>> +
>>> +	inode->i_private = (void *)(unsigned long)flags;
>>> +	inode->i_op = &kvm_gmem_iops;
>>> +	inode->i_mapping->a_ops = &kvm_gmem_aops;
>>> +	inode->i_mode |= S_IFREG;
>>> +	inode->i_size = size;
>>> +	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
>>> +	mapping_set_inaccessible(inode->i_mapping);
>>> +	/* Unmovable mappings are supposed to be marked unevictable as well. */
>>> +	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
>>> +
>>> +	return inode;
>>> +}
>>> +
>>> +static struct file *kvm_gmem_inode_create_getfile(void *priv, loff_t size,
>>> +						  u64 flags)
>>> +{
>>> +	static const char *name = "[kvm-gmem]";
>>> +	struct inode *inode;
>>> +	struct file *file;
>>> +	int err;
>>> +
>>> +	err = -ENOENT;
>>> +	/* __fput() will take care of fops_put(). */
>>> +	if (!fops_get(&kvm_gmem_fops))
>>> +		goto err;
>>> +
>>> +	inode = kvm_gmem_inode_create(name, size, flags);
>>> +	if (IS_ERR(inode)) {
>>> +		err = PTR_ERR(inode);
>>> +		goto err_fops_put;
>>> +	}
>>> +
>>> +	file = alloc_file_pseudo(inode, kvm_gmem_mnt, name, O_RDWR,
>>> +				 &kvm_gmem_fops);
>>> +	if (IS_ERR(file)) {
>>> +		err = PTR_ERR(file);
>>> +		goto err_put_inode;
>>> +	}
>>> +
>>> +	file->f_flags |= O_LARGEFILE;
>>> +	file->private_data = priv;
>>> +
>>> +	return file;
>>> +
>>> +err_put_inode:
>>> +	iput(inode);
>>> +err_fops_put:
>>> +	fops_put(&kvm_gmem_fops);
>>> +err:
>>> +	return ERR_PTR(err);
>>> +}
>>
>> I don't see any reason to add two helpers.  It requires quite a bit more lines
>> of code due to adding more error paths and local variables, and IMO doesn't make
>> the code any easier to read.
>>
>> Passing in "gmem" as @priv is especially ridiculous, as it adds code and
>> obfuscates what file->private_data is set to.
>>
>> I get the sense that the code was written to be a "replacement" for common APIs,
>> but that is nonsensical (no pun intended).
>>
>>>   static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>>>   {
>>> -	const char *anon_name = "[kvm-gmem]";
>>>   	struct kvm_gmem *gmem;
>>> -	struct inode *inode;
>>>   	struct file *file;
>>>   	int fd, err;
>>>
>>> @@ -481,32 +579,16 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>>>   		goto err_fd;
>>>   	}
>>>
>>> -	file = anon_inode_create_getfile(anon_name, &kvm_gmem_fops, gmem,
>>> -					 O_RDWR, NULL);
>>> +	file = kvm_gmem_inode_create_getfile(gmem, size, flags);
>>>   	if (IS_ERR(file)) {
>>>   		err = PTR_ERR(file);
>>>   		goto err_gmem;
>>>   	}
>>>
>>> -	file->f_flags |= O_LARGEFILE;
>>> -
>>> -	inode = file->f_inode;
>>> -	WARN_ON(file->f_mapping != inode->i_mapping);
>>> -
>>> -	inode->i_private = (void *)(unsigned long)flags;
>>> -	inode->i_op = &kvm_gmem_iops;
>>> -	inode->i_mapping->a_ops = &kvm_gmem_aops;
>>> -	inode->i_mode |= S_IFREG;
>>> -	inode->i_size = size;
>>> -	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
>>> -	mapping_set_inaccessible(inode->i_mapping);
>>> -	/* Unmovable mappings are supposed to be marked unevictable as well. */
>>> -	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
>>> -
>>>   	kvm_get_kvm(kvm);
>>>   	gmem->kvm = kvm;
>>>   	xa_init(&gmem->bindings);
>>> -	list_add(&gmem->entry, &inode->i_mapping->i_private_list);
>>> +	list_add(&gmem->entry, &file_inode(file)->i_mapping->i_private_list);
>>
>> I don't understand this change?  Isn't file_inode(file) == inode?
>>
>> Compile tested only, and again not critical, but it's -40 LoC...
>>
>>
> 
> Thanks.
> I did functional testing and it works fine.

I can queue this instead. I guess I can reuse the patch description and 
add Sean as author + add his SOB (if he agrees).

Let me take a look at the patch later in more detail.

-- 
Cheers

David / dhildenb


