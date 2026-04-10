Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 144ACF459F7
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 15:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E9C66B00BC; Fri, 10 Apr 2026 11:26:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C0846B00BD; Fri, 10 Apr 2026 11:26:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AFEC6B00BE; Fri, 10 Apr 2026 11:26:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5904C6B00BC
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:26:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 074131A02AD
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:26:18 +0000 (UTC)
X-FDA: 84643022436.28.37D7689
Received: from iad-out-004.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-004.esa.us-east-1.outbound.mail-perimeter.amazon.com [18.207.52.234])
	by imf16.hostedemail.com (Postfix) with ESMTP id CE0F8180005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:26:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=k5BRJ2ek;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf16.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 18.207.52.234 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775834775;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=myGuGGgnR9AJ65k7Tpv29MZkBqAgZAsukBFpDCDwAPU=;
	b=NIsH0yxfnJXtrUvQuovRnQWEv0Pgmq8y8LZ9mlRgY4DlReMjB5kj5o60eWlhfAaqv2C2fY
	DLhU/YpS0jX41lADLamailMl0CPBzpw6kvEg2Zd0b9f5Lk2pWbbJHIWNVXvQdDNPVkg8Iw
	q+BQ5QFQl157AG6pt6JV4jTleZ27efQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775834775; a=rsa-sha256;
	cv=none;
	b=8dHDDuxyBcnDh81jIHTJjSjm8rWSwTg3igf+70CGfd5oDnIOVOm2wbdwlMbG0tc8nX/rOV
	6I4EmVoKwpqBqucJ1MqV1f+zaYAiAY8pjcci2F75HHR07z+uJapRL1RoZfzTcikEFfI850
	YTGhDzzvE1D/tvX53mRQiS3m2QcTMuU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=k5BRJ2ek;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf16.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 18.207.52.234 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1775834775; x=1807370775;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=myGuGGgnR9AJ65k7Tpv29MZkBqAgZAsukBFpDCDwAPU=;
  b=k5BRJ2ek7nhHCvJcRPbzdNZ+eCXbjj2NpG6jDg1ec/PtsTUQutckCZqD
   dZG/xuXcsM5yYqiO//Ce6ctiDC0UDWeAQ9in3eSMG1MHrW3GxQeYMnXjg
   riJP/0sUAAass7UYhOhE3kWiPvLOO8/WwvxJSwzrym52VAie1EcHV7Qps
   cTWbqVaVibS+Zdp0A81bCugypSPL5Vy174+g6fUd2mI2B0EUqZ2bZpOvm
   Kyal7CRAAVKjgxlQXVcMGchfEGkulFyY7SO7rCjpgv1tnynBX3gAqRB9q
   eEKFB748tX968Hqizvb3j8R8JdMlwnttHoO8ZFKQGi7rgORkq8j9d/mgq
   g==;
X-CSE-ConnectionGUID: HmWevmEkSyyaD2dsMEmNow==
X-CSE-MsgGUID: VqWwaZmcTmuZzfngn8n1+Q==
X-IronPort-AV: E=Sophos;i="6.23,171,1770595200"; 
   d="scan'208";a="15971227"
Received: from ip-10-4-22-235.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.22.235])
  by internal-iad-out-004.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 15:26:12 +0000
Received: from EX19MTAUEB002.ant.amazon.com [72.21.198.67:11072]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.59.187:2525] with esmtp (Farcaster)
 id 7fbceef4-e2e0-48cc-89a3-9e29bae5d585; Fri, 10 Apr 2026 15:26:12 +0000 (UTC)
X-Farcaster-Flow-ID: 7fbceef4-e2e0-48cc-89a3-9e29bae5d585
Received: from EX19D027UEC003.ant.amazon.com (10.252.137.250) by
 EX19MTAUEB002.ant.amazon.com (10.252.135.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 15:26:12 +0000
Received: from [192.168.12.97] (10.106.82.30) by EX19D027UEC003.ant.amazon.com
 (10.252.137.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Fri, 10 Apr 2026
 15:25:59 +0000
Message-ID: <532481d6-f137-4666-b2e3-77aa1b5c8177@amazon.com>
Date: Fri, 10 Apr 2026 16:25:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v11 02/16] set_memory: add folio_{zap, restore}_direct_map
 helpers
To: Ackerley Tng <ackerleytng@google.com>, "Kalyazin, Nikita"
	<kalyazin@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"kernel@xen0n.name" <kernel@xen0n.name>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "linux-s390@vger.kernel.org"
	<linux-s390@vger.kernel.org>, "loongarch@lists.linux.dev"
	<loongarch@lists.linux.dev>, "linux-pm@vger.kernel.org"
	<linux-pm@vger.kernel.org>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net"
	<corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org"
	<oupton@kernel.org>, "joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org"
	<willy@infradead.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>,
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>,
	"ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net"
	<daniel@iogearbox.net>, "andrii@kernel.org" <andrii@kernel.org>,
	"martin.lau@linux.dev" <martin.lau@linux.dev>, "eddyz87@gmail.com"
	<eddyz87@gmail.com>, "song@kernel.org" <song@kernel.org>,
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>,
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org"
	<kpsingh@kernel.org>, "sdf@fomichev.me" <sdf@fomichev.me>,
	"haoluo@google.com" <haoluo@google.com>, "jolsa@kernel.org"
	<jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com"
	<jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>,
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>, "riel@surriel.com"
	<riel@surriel.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"jgross@suse.com" <jgross@suse.com>, "yu-cheng.yu@intel.com"
	<yu-cheng.yu@intel.com>, "kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com"
	<coxu@redhat.com>, "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>,
	"yosry@kernel.org" <yosry@kernel.org>, "ajones@ventanamicro.com"
	<ajones@ventanamicro.com>, "maobibo@loongson.cn" <maobibo@loongson.cn>,
	"tabba@google.com" <tabba@google.com>, "prsampat@amd.com" <prsampat@amd.com>,
	"wu.fei9@sanechips.com.cn" <wu.fei9@sanechips.com.cn>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "jmattson@google.com" <jmattson@google.com>,
	"jthoughton@google.com" <jthoughton@google.com>, "agordeev@linux.ibm.com"
	<agordeev@linux.ibm.com>, "alex@ghiti.fr" <alex@ghiti.fr>,
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, "borntraeger@linux.ibm.com"
	<borntraeger@linux.ibm.com>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
	"dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com"
	<gor@linux.ibm.com>, "hca@linux.ibm.com" <hca@linux.ibm.com>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "pjw@kernel.org" <pjw@kernel.org>,
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>,
	"svens@linux.ibm.com" <svens@linux.ibm.com>, "thuth@redhat.com"
	<thuth@redhat.com>, "wyihan@google.com" <wyihan@google.com>,
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>,
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "urezki@gmail.com"
	<urezki@gmail.com>, "zhengqi.arch@bytedance.com"
	<zhengqi.arch@bytedance.com>, "gerald.schaefer@linux.ibm.com"
	<gerald.schaefer@linux.ibm.com>, "jiayuan.chen@shopee.com"
	<jiayuan.chen@shopee.com>, "lenb@kernel.org" <lenb@kernel.org>,
	"osalvador@suse.de" <osalvador@suse.de>, "pavel@kernel.org"
	<pavel@kernel.org>, "rafael@kernel.org" <rafael@kernel.org>,
	"vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com"
	<jackmanb@google.com>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>,
	"patrick.roy@linux.dev" <patrick.roy@linux.dev>, "Thomson, Jack"
	<jackabt@amazon.co.uk>, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
	"Manwaring, Derek" <derekmn@amazon.com>
References: <20260317141031.514-1-kalyazin@amazon.com>
 <20260317141031.514-3-kalyazin@amazon.com>
 <CAEvNRgEFBexkZCjOMFHJRQFHOpiUezD2jbfDVFrGhYXODdpMjg@mail.gmail.com>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
Autocrypt: addr=kalyazin@amazon.com; keydata=
 xjMEY+ZIvRYJKwYBBAHaRw8BAQdA9FwYskD/5BFmiiTgktstviS9svHeszG2JfIkUqjxf+/N
 JU5pa2l0YSBLYWx5YXppbiA8a2FseWF6aW5AYW1hem9uLmNvbT7CjwQTFggANxYhBGhhGDEy
 BjLQwD9FsK+SyiCpmmTzBQJp2NfjBQkGQlIzAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQr5LK
 IKmaZPPNDAEAvsw8vEWj8ArWQ1QJNufjrvobU/cE8MLKdBxbSE8CyZQA/0BldKxNAtAwG4qw
 wCLxsZ5vBL3Zkh/PdvtFCj/VGscGzjgEY+ZIvRIKKwYBBAGXVQEFAQEHQCqd7/nb2tb36vZt
 ubg1iBLCSDctMlKHsQTp7wCnEc4RAwEIB8J+BBgWCAAmFiEEaGEYMTIGMtDAP0Wwr5LKIKma
 ZPMFAmnY1+MFCQZCUjMCGwwACgkQr5LKIKmaZPPQKgD/f3FtERbJ+LYHLSG/ZbLNAOLngUlQ
 qo5VfIyJOzeLzC0BAP2PIUFIHo7vmia/PXEmT+ve4c5rx+EkH/Dx1GRpjWoI
In-Reply-To: <CAEvNRgEFBexkZCjOMFHJRQFHOpiUezD2jbfDVFrGhYXODdpMjg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.82.30]
X-ClientProxiedBy: EX19D003EUA001.ant.amazon.com (10.252.50.31) To
 EX19D027UEC003.ant.amazon.com (10.252.137.250)
X-Rspamd-Queue-Id: CE0F8180005
X-Stat-Signature: s6qu9mzf9mcad94cwowgs6uutwsowm4r
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775834775-282305
X-HE-Meta: U2FsdGVkX1+P6MdC/mOsSmPpqGS44QfbzdPV8w+g9O9Oq5t+1cvW4lKRKkV/GbFDb28SDOUDtb6pQtKkXo/nzA+XfpB33MVW8j6/0u+351pNKUaCJfddTsxfhw3obKociV7GubUB6K40Ddj1qRqgbJIeiWhwUecltRf4kuT7T5LeKgL1Xf30E7dFtGLfJwELlfngCE4tIz2YxVrujoDCCWlc/lhYUYRMoiY3QxbpGG8Rq5WFBgVJcD+LQHTMQlSyB4AvS+qXxa5sIMGDaFIVKtURX2vE5CPbu687HcrRaGHnC4i5okXbqZwd9bKoVguTZL1//XMOyH2BxcUvjyfhP9w2pgRrrL+ov2IyNOvasUWZs3N9kmL03CGrpTzMkV9fLVyYBMudY/vfFgd/biofgkli3c9FP4iGwRkLfWVfGem5C4Zoi0izmbA358GlW9eI4QFCueXpVVQ+Wu59wW5L6A5eb0wiw7szIl93fmRLQs6XoKxf4+4fJg1lJVQpLcjWXlMlbJSuyzG33xrFGlfGqpOeBd4m0n7L/3LjKU6Iw40b4cNFFZkWwyMEiSYd5hjLx7YZapSMMdi/lCKdT1y3FkRi02AHFsGDWMNZKVy8++rWxHBeaBl9udo8OSVandCcp0FCXup4Vn2o219EZnTrjFZgqNa4JDyf9JBfHhsVAlmMwC27nXrHRyAMOH/bBXcvXQxQHyySu7VdTQevuofOXUctJPv0f4aqWL6vmbq3DmvSGkxHGbL0RPPrrZPK3aeBFk/4FSpF78AO3AXbPPN/Xhj9+LVdD8W3G6zHadrt+1Pb27yh+BntIoy46UscyPBZNBgZJ3ZdeAloBIrRDBFNlyG+qlVGBZtZXknRFLsoD67WVqhfLrS8eRUxP4ksmAuy9ocnDkHL7AlceF4O0M4cGvuEmVAW/yxKWoYhYMqoIwI+IyfFQ3YRdymktV/0XfULj+oFfSMA2B1izfZLiTf
 ebpMUumx
 lzVd1eFW+D7WWwgZ9pDbMIbEDRU4g7Gh1oG6lvN6RUd8EO4MigYQcfjtXWdMxu4oV6fnSUUvMZZwtelGIWgfe2BI1R2VxKU5noRSzWe2vVyyFpzy+0YpCqbASCT30Nw+zsby9utfJzQQYDUp3V8/L6thnVkTK8ZrSvSDMOLuEpJX0oWztN8AEaHHYjIotzSpvl6zZr6iHNXjvFelWR3PU8sPgCUDWGRLIlVOkuDNLhzYBGZTx1fYE+OU/4SDe3OIFpCwnGIBxAOOGlfJev+vZlidzHNw/ivw6YLeMrZdB6Sah7Y/4p7dhS8QI61BKj0sPb3u0cIatdpiji2/c4PdzKOql1e2sH5V53ZRgWRX0AoQovLBw5DrBmO7iR3UopQbECMeSDjjwZPyaagCgrY+GBkr8csR3kFEN3rwFq4vpwY0S5JUTGez26qGzptrb7d/ugVw/jcKxMz8vNJJYDUdmpzb5sA5ck8vL/bWPz1ZJg4uTPfhw+dA5r7apS+5utkbUNSjMH5nki3m2MPs0NS3T7NrZm2VFXu842cN/C412HHZ+U3aAmgsoY2i2mOJ8GIXBSInCjQ8W7T+5/csdwsrO/Sapj64+iMwdfFPoNDG/F6qWuf836pzCDRrFJ9gL7osdEetJ/Z1ffV65pcdirdThi2hHQmSkxWKU03u3tELKuXffW4klo92eOoMQ7XhXX7g1zGd0lgHimAxkeVdf/YR3dV8eScjNN7PwGPXSsLTOk8rWuyJJf9mq5G98MMh6DLeuBdnChAYTI8XuFXXZ8AJ0YX8hwovsIcO9SOiq5FG5D2J83ET6AL9LD8r2c1klZ45nQ00Vl6EFOcJgRrEM+FOyfedbZuJfECKigiaZ3lyNKvdkSYcNU+j20NCAOGYCxXMTBcfJMbNEAW7DjN0eQEhmr8P59l7+ur50vIitrp+jKSfvTSGmM3Ghfa8bHnDV9dE2ywVBmAk/XqCe8VV0A4RSkm4erV1C
 O57660Kz
 CfF/FtD8XWtY3Z0oyN6l2Xwqi6IH95OlL8lGezSAKM0OfS/d0Bi1YW3j6pJM+LPlRCwNjLJ97Hzd9gaOBUM1aQMYXXB9lQaZ9dvNnno0zRkaqESJkhxB1l7dEY9m/8DQMYIkgQYWwy82xKzylOnyXYY2T2Lt96Mhd303/tUkK10=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 23/03/2026 18:43, Ackerley Tng wrote:
> "Kalyazin, Nikita" <kalyazin@amazon.co.uk> writes:
> 
>> From: Nikita Kalyazin <kalyazin@amazon.com>
>>
>> Let's provide folio_{zap,restore}_direct_map helpers as preparation for
>> supporting removal of the direct map for guest_memfd folios.
>> In folio_zap_direct_map(), flush TLB to make sure the data is not
>> accessible.
>>
>> The new helpers need to be accessible to KVM on architectures that
>> support guest_memfd (x86 and arm64).
>>
>> Direct map removal gives guest_memfd the same protection that
>> memfd_secret does, such as hardening against Spectre-like attacks
>> through in-kernel gadgets.
>>
>> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
>> ---
>>   include/linux/set_memory.h | 13 ++++++++++++
>>   mm/memory.c                | 42 ++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 55 insertions(+)
>>
>> diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
>> index 1a2563f525fc..24caea2931f9 100644
>> --- a/include/linux/set_memory.h
>> +++ b/include/linux/set_memory.h
>> @@ -41,6 +41,15 @@ static inline int set_direct_map_valid_noflush(const void *addr,
>>        return 0;
>>   }
>>
>> +static inline int folio_zap_direct_map(struct folio *folio)
>> +{
>> +     return 0;
>> +}
>> +
>> +static inline void folio_restore_direct_map(struct folio *folio)
>> +{
>> +}
>> +
>>   static inline bool kernel_page_present(struct page *page)
>>   {
>>        return true;
>> @@ -57,6 +66,10 @@ static inline bool can_set_direct_map(void)
>>   }
>>   #define can_set_direct_map can_set_direct_map
>>   #endif
>> +
>> +int folio_zap_direct_map(struct folio *folio);
>> +void folio_restore_direct_map(struct folio *folio);
>> +
>>   #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
>>
>>   #ifdef CONFIG_X86_64
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 07778814b4a8..cab6bb237fc0 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -78,6 +78,7 @@
>>   #include <linux/sched/sysctl.h>
>>   #include <linux/pgalloc.h>
>>   #include <linux/uaccess.h>
>> +#include <linux/set_memory.h>
>>
>>   #include <trace/events/kmem.h>
>>
>> @@ -7478,3 +7479,44 @@ void vma_pgtable_walk_end(struct vm_area_struct *vma)
>>        if (is_vm_hugetlb_page(vma))
>>                hugetlb_vma_unlock_read(vma);
>>   }
>> +
>> +#ifdef CONFIG_ARCH_HAS_SET_DIRECT_MAP
>> +/**
>> + * folio_zap_direct_map - remove a folio from the kernel direct map
>> + * @folio: folio to remove from the direct map
>> + *
>> + * Removes the folio from the kernel direct map and flushes the TLB.  This may
>> + * require splitting huge pages in the direct map, which can fail due to memory
>> + * allocation.
>> + *
>> + * Return: 0 on success, or a negative error code on failure.
>> + */
>> +int folio_zap_direct_map(struct folio *folio)
>> +{
>> +     const void *addr = folio_address(folio);
>> +     int ret;
>> +
>> +     ret = set_direct_map_valid_noflush(addr, folio_nr_pages(folio), false);
>> +     flush_tlb_kernel_range((unsigned long)addr,
>> +                            (unsigned long)addr + folio_size(folio));
>> +
>> +     return ret;
>> +}
>> +EXPORT_SYMBOL_FOR_MODULES(folio_zap_direct_map, "kvm");
>> +
>> +/**
>> + * folio_restore_direct_map - restore the kernel direct map entry for a folio
>> + * @folio: folio whose direct map entry is to be restored
>> + *
>> + * This may only be called after a prior successful folio_zap_direct_map() on
>> + * the same folio.  Because the zap will have already split any huge pages in
>> + * the direct map, restoration here only updates protection bits and cannot
>> + * fail.
>> + */
>> +void folio_restore_direct_map(struct folio *folio)
>> +{
>> +     WARN_ON_ONCE(set_direct_map_valid_noflush(folio_address(folio),
>> +                                               folio_nr_pages(folio), true));
>> +}
>> +EXPORT_SYMBOL_FOR_MODULES(folio_restore_direct_map, "kvm");
>> +#endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
>> --
>> 2.50.1
> 
> Reviewed-by: Ackerley Tng <ackerleytng@google.com>
> 
> I also took a look at Sashiko's [1] comments and I think that the
> highmem folio issues should be the responsibility of the caller to
> check.

Thank you.

> 
> [1] https://sashiko.dev/#/patchset/20260317141031.514-1-kalyazin%40amazon.com


