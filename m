Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D67E3606A332
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 00:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=KQQ3P0yK
Received: by kanga.kvack.org (Postfix)
	id D67AC6B0601; Thu, 19 Nov 2026 19:16:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D17C66B06B6; Thu, 19 Nov 2026 19:16:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C08136B06B8; Thu, 19 Nov 2026 19:16:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B04D6B0601
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:16:22 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 020FA160C4D
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:16:21 +0000 (UTC)
X-FDA: 85453580604.17.F133FEB
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1488D1C0007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:16:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=KQQ3P0yK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795133780;
	b=Jqz7yJC9pPdTWMOwVyOWT+BwYwXPCnH2kVOwfV8wHKAW8pOY0SXk0ZagKZQpCZv8ZAtu2r
	2f/i922LRMufcsM4UclQ9/5w/JGal8qdxdiPxYCUJLLZSd28y7/rzocuBQjzYMtUO2dx+S
	UGhfns6SmThrunX0DkmSSLiUm+Y08Tw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795133780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hAC07b8lFLojHV0Uml6G9ei5fnLsVAdumfXqcmefGN4=;
	b=ZZVpSEqDjnGSx39f01+3mF6K82n4b3UKg/bRUtzYN1Jk+UPUy+IcPpmWDXrXSrza0Owjax
	hfZjE0Z1EYDrsuYR3s+FwBJbRfqbgJpypgdLRRL+MogTohrI7vjf53cBXBsO2fa4dItsHP
	4qQqnLP1isn+Cu6PVHUFak3U7iLYNL8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=KQQ3P0yK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=dmatlack@google.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2e98798cbddso1369745ad.0
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795133779; x=1795738579; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=hAC07b8lFLojHV0Uml6G9ei5fnLsVAdumfXqcmefGN4=;
        b=KQQ3P0yKTYm8IycDA+GW23lF/C88cS+gsV2AFbtLT+KpngGIQ3mzKOQ8w8YbbDJl+F
         WOvF74Ft5diM/IsyYS8Jpeza8Mif2FBNnFIyOHpCP1llqvxbbKjJkHDmkQv/pH+uwxsr
         h+mQVYYy3iQ+47tGfs1JwyHgdBoBTY3vCnoIasLgZMKTbPOgCuye726KRcyLVNlI4IDt
         EjBUbPDtFQtOBubKprKzCgD/JtOyYY8cQVQw4FNhXIFLUkrbLq4faQlB+RrB5ww4qI+o
         lUCyOOCxec2GP/0vTkjksVLzWmthcoYvQ/npOBwsLLDTU34+yhx+Y37Vd6HsF1jq2xGQ
         ky3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795133779; x=1795738579;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hAC07b8lFLojHV0Uml6G9ei5fnLsVAdumfXqcmefGN4=;
        b=lWRQ2xtEQeJw/RrGN5y5sfSomgVI6DzuAyzLa9oXSYgTBq5xD1fS/B6A5E1o4hpSMM
         BlFrP95DaVzRFeaVkWFP8sMDisacVziP7MZX0d4L51t9jvzKIJA5MUl2zuzpSY/Sm8Qp
         LezZZdIaYrvH0fSMn0wMd+tcumX//jkvm91Cdz7hZxnAuxyukWgnLhlrvWMRBJIYL0bT
         TQUI99m5Fim550fLVg1IcF21Gg64DD/y7lbKsbP8g79JHAHbHtKMXeBo8I5cZ2p6S1Eh
         TayrZyZniZHRUTFOzcojaWmJTlU7fI7OT1wo3S3BKgM1dlfGylrKMyLZiPlord4IcYut
         FGag==
X-Forwarded-Encrypted: i=1; AL+hErE3KXCk8qcfkYtOw1hZ41IgPnI7bPKrYcjDKzQoz2bULMdqClWTxKyq3K+Tegf+gB5BudPwFvIJMA==@kvack.org
X-Gm-Message-State: APuU4Z/YeZmro64tlBNiuWtkEn4Rq0G5zoLyCKVD4bCypqSRXJ6nBN1J
	iIp3Aqw91sMV6Bn15+1bsywzVWvg8hnVmQ/ieUimWY5/MmKS0GG4Q1bBHAazZ888tw==
X-Gm-Gg: AZFdTZc/vwF9vP438IimUUBOKJI7dJp6WsGW8BVUlvbU+kwk2kR4HvtK5CPKzf+ZUjI
	Jmx8IFzU2DvAxcdvi//2wJCmwebdowlWDlrpDXk8ierJ+nNuwAU1QdOaUGKSXDKa5UY7REvDOvv
	GqAa6+eGJ2b+odWR20jcDfbWe2bCX0adjdwKe26sCp4rmp7DsNRHoqdPFkASkVBsi9LTKihll7W
	1Tv5tpialL8ZVzSGJ6XOT8o4bwSxHpuqbto9+AYadVpTTgKIUtK+7eJTJreKRkAT3j/zxay7Mx3
	4GGC7iIcJZHx7N1bQgT2u7jvnhnH6+w89AdME3rumULWryBNJCwr+lxjpwAEUlvDvgNascru/Me
	h6teziKlOJ2yWapN0EYLnPUdQNBEZHIUZRzgZI7Gj0Lu+WWHBIN53JvFk5zDKJee93yuZKZiGtQ
	UcCQ3Rc34/1g6E8wzPL7aUm8zCC/b1xgBdDCkY9wEYzh7dVE7k9HfeQrBYAqIQ4ugaSQHewfu9H
	thvIBeFwQ9X/EN58qBL4o5m7lldCjXVDHtLkW1TFh1BmNpah6raOEUK5CMVpfZu9cVpbbXxjUV4
	11/sAgevVhrPBZEfLajHVlFK2Oq7K8VIQETzhINIAzs6NME2p2u5W2aNzeTv4YEt
X-Received: by 2002:a17:903:2b0f:b0:2e2:dfb8:818a with SMTP id d9443c01a7336-2f03f20f8c5mr14954585ad.62.1795133778058;
        Thu, 19 Nov 2026 16:16:18 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f0c6e50sm6072095ad.13.2026.11.19.16.16.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2026 16:16:17 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 19 Nov 2026 16:16:16 -0800
Message-Id: <DMZLTC9U6DBX.3FR19X5M2IT3W@google.com>
Cc: <kexec@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
 <linux-doc@vger.kernel.org>, <kvm@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kselftest@vger.kernel.org>, <linux-pci@vger.kernel.org>,
 <ajayachandra@nvidia.com>, <alex@shazbot.org>, <amastro@fb.com>,
 <ankita@nvidia.com>, <apopple@nvidia.com>, <bhelgaas@google.com>,
 <chrisl@kernel.org>, <christian.koenig@amd.com>, <corbet@lwn.net>,
 <graf@amazon.com>, <jacob.pan@linux.microsoft.com>, <jgg@nvidia.com>,
 <jgg@ziepe.ca>, <jrhilke@google.com>, <julianr@linux.ibm.com>,
 <kees@kernel.org>, <kevin.tian@intel.com>, <leon@kernel.org>,
 <leonro@nvidia.com>, <lukas@wunner.de>, <mattev@meta.com>,
 <michal.winiarski@intel.com>, <parav@nvidia.com>,
 <pasha.tatashin@soleen.com>, <praan@google.com>, <pratyush@kernel.org>,
 <rananta@google.com>, <rdunlap@infradead.org>, <rientjes@google.com>,
 <rodrigo.vivi@intel.com>, <rppt@kernel.org>, <saeedm@nvidia.com>,
 <schnelle@linux.ibm.com>, <skhan@linuxfoundation.org>,
 <skhawaja@google.com>, <vivek.kasireddy@intel.com>, <witu@nvidia.com>,
 <yanjun.zhu@linux.dev>, <yi.l.liu@intel.com>
Subject: Re: [PATCH v6 11/27] vfio/pci: Retrieve preserved device files
 after Live Update
From: "David Matlack" <dmatlack@google.com>
To: "Vipin Sharma" <vipinsh@google.com>, "David Matlack"
 <dmatlack@google.com>
X-Mailer: aerc 0.21.0
References: <20261102153656.1431701-1-vipinsh@google.com>
 <20261102153656.1431701-12-vipinsh@google.com>
 <DMOAT4VV939P.2DI8CEOMMSKMY@google.com>
 <20261118065653.GE2250529.vipinsh@google.com>
In-Reply-To: <20261118065653.GE2250529.vipinsh@google.com>
X-Rspam-User:
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 6et3zd68ce65wchsttdqnahcrc3a7cze
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1488D1C0007
X-HE-Tag: 1795133779-629327
X-HE-Meta: U2FsdGVkX19ENLVmG1jOJNuu8wjMAtFtSsU4Q8aj67tLb+MGZOku1ORhdoWY/d3aamSNIBBEOXcV7uZbCP4dfK7VbAEXMdk7iSf8MapPryOAHfWcNvXVnOGzYyPEMoDEnf18+coicRxeNrfGSYcSwwl1lSNXEx21edyPkrIbBznG7ys/hqzontyKlapLq0OkBEdpG4uF9G3MaTa2nJbQBoFHgk88QFjxMVDIgysrC7dv0E8prWJM3NqmIf0t8fql83SQ8/4MmmSawRFPXwvH88wcWLqO0WMUduvy3TlH95Ji2X6JzB+q6WKMpjJPkOrm4evfqqwzJN0uNX2tGr9UDwKzVkF4uArojIu1YhjXbKfh8sKKwSgtU0FI9mMYLQ+OW0yofmPwoD9Q76SszDrwx/KrJJD4qScL2RBeXC0aSX0/1ZHvn5TeTHlHaamT+oqWihKg0rqp9CiZLXElJYmnobbCpDQiCXMuE4k0EkNt8qlSrjXfg6hPacIEZmLuFN1RWsXe33n1DtObzxGCIcngSgruUSMKJOrK2CLbOL6morx1jky5Mia//nTmVHypA+OBgSbWf6Q/Pe3cx0sarqZeBiVTKVLCANJCISYexIj8wtkZD+ViJBfPoWxiveVxt5ComqKMqLOMfFPw26htD0kQvUFuJ1/p5sPNs3uahjPw6tGymyEqiavKzW9MvVMPupywHRolaWQ/ohEY+s3uzetxLRTQTUUVUl3aVDJzeUoXnvoOGxqVzEsgiF1s/XX334eCFw6gXO75M8pABptGx+X/NwbVkGNCc9pSR4kbC9Fh4r4uWeIRNB1FJVV/wITO+Gd/gEPEk7OthM6OgI0sk49c6BzNE3YWwkh1J3OTuX3retde+tOqME0FEh8HCEMAaZ/LiMSvEE+zNVF9jjEaNliJYS8x+8Sj3rzz5HCLkWdrMxVN60wBSrYfNxFIQaL1YaGLDrQXyxXJcZH5eB5S2n2
 3X1yWA+p
 MQ5125bNAHdyRs8E+uc5FMgrfQYbah8R9mlAyqSuVoceLuYHkrTZcuBow0lNB7xnQUVEc4Dkiift4YEHskRRyth01ePDRqCGzhUiUnfZZC2+TL/3Eev0aZ9cWLkItKy2V1OHM7VtoDqsnddLJ6FLundf/WA7ZCUeZ8gMvW/L9dQROk+S6nHUcbCNNITGqjwfZbh8dbeDivBRZg+CgtCi3BykOx2FmPNiMHzkkKG+q97Rd14Daa5QFO4PKLvm8kfCcdHcK/5Z7qhQxRnQhvHF/LWMwAhpHROt1buJ2bkoQ0WCiHVpUqCBqUjZq0djfr8kSM4j8xXeqPO0OS54na6lQn50RZF+QeNQCWeGGCJZns8dmYkxzgr3li4R9aCA7Eg+ofTt+gvimul9SVQTryZBRA2YMHOqLJwZ+JJvJ5bShFh1HHIHHQ28OBCJJ2dvMEOVQPu5PYb2hbSLnwwkQlpKqv9I1kgqNc/WlxNOzpgdiVKxRCFReaCOBCJnpX8WbhXlqsSvZQ7KmCKHmCjgRsw9FCoo+0yDh81kVp7BBFxTF5SgP9ARH5QGYdMWHA2N2LDGAaXXD7Wh//kpAMfZWxagD11EgZXUI9ZjwWcV2ATNkqDwNvuyc35u35TIsbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue Nov 17, 2026 at 11:51 PM PST, Vipin Sharma wrote:
> On Fri, Nov 06, 2026 at 05:19:28PM +0000, David Matlack wrote:
>> On Mon Nov 2, 2026 at 3:36 PM UTC, Vipin Sharma wrote:
>> >  * Open and return an anonymous VFIO cdev file via
>> >    vfio_device_liveupdate_cdev_open().
>>=20
>> Here's an idea for how the device file could be created on retrieve,
>> which I'd like to hear your thoughts on.
>>=20
>> The patches from Pasha at [1] lets userspace pass a
>> file-handler-specific argument to LIVEUPDATE_SESSION_RETRIEVE_FD. In the
>> next version of the tmpfs series, I'm planning to use that to have
>> userspace create the file and pass it in the argument, and the kernel
>> then restores the preserved file into it.
>>=20
>> I wonder if VFIO should work the same way, e.g.:
>>=20
>>   struct liveupdate_vfio_retrieve_arg {
>>           __u32 size;
>>           __s32 fd;
>>   };
>>=20
>> Userspace would open /dev/vfio/devices/noiommu-vfioX itself and pass
>> the fd. retrieve() would check that it's an unbound vfio-pci cdev file
>> for the preserved device (domain/BDF, noiommu, incoming, cfg_size),
>> attach the incoming state to that file, and LUO would track that file
>> as the retrieved file. VFIO_DEVICE_BIND_IOMMUFD would then take over the
>> device as it does now. Since VFIO preservation is new, the argument
>> could simply be required.
>>
>> What do you think?
>
> Overall, I agree with the strategy. I think VFIO cdev retrieval should
> happen as the flow you mentioned above. I want to hightlight two things:
>
> 1. This will lead to lot of code changes happening in vfio core. This
>    means VFIO PCI live update code change will spill in vfio core.
>    Should I create a config VFIO_LIVEUPDATE for VFIO core code. It will
>    not be visible menuconfig option but selected when
>    VFIO_PCI_LIVEUPDATE is enabled.
> 2. List of other inflight series that this series will depend on is
>    increasing. It will be 3 (reset function, pci saved state, and
>    restore into fd).
>
> For '2', should I send v7 without changes you are recommending in this
> patch and future version of this series can transition to the approach
> you are suggesting after LUO changes are landed. VFIO liveupdate series
> will go through more iterations, so we will have opportunity to make the
> change. WDYT?

Sounds good. I am not 100% convinced yet we should switch to a
retrieve-into approach. But let's keep discussing it VFIO and IOMMUFD.

