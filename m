Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFBF1D6CFA4
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 20:41:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 360CF6B034F; Thu, 22 Jan 2026 15:41:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 339386B0350; Thu, 22 Jan 2026 15:41:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 211476B0351; Thu, 22 Jan 2026 15:41:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0FF0E6B034F
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 15:41:14 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7CCF591BDE
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 20:41:13 +0000 (UTC)
X-FDA: 84360769626.15.FD7B803
Received: from fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.74.81.189])
	by imf20.hostedemail.com (Postfix) with ESMTP id EA19B1C0008
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 20:41:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=YN9tHGCc;
	spf=pass (imf20.hostedemail.com: domain of "prvs=475c5ed80=kalyazin@amazon.co.uk" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=475c5ed80=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769114471;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L060fUvGttxYBIHa6eLU8Z48SLaOwnhKGvQs72E5QZs=;
	b=KhTp3HJsEv5AoP+VYXPg73JyQ+kNVWgpfKnywOjHX9o9aRPAoFD72bbW53UKr6c91igiXB
	OmQak15Av6+hRW5J756H4IKYDGW9uLfj9t62Rq8+SJ7NM6LMdfewATMhDocFay4PTk3cYX
	SBVFCh4Yrx7xw9sj01+pGKZINo81Coc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769114471; a=rsa-sha256;
	cv=none;
	b=t5GHIC3aW9J3hKlbGJnO6futnT/RRPK3nhbVpS71VnzBl+/wHAJUJ+JHMTr7Y/Scnkgs+F
	7lBxBzYDwkGWZRPHPXfI+qx1dqfsubqQfbtWOGfx14WhqbSOuhsdjAOn6VxtnGYhFE0w8T
	1Q7jleNUHskCu7sPKRs5NHLCBrOLsJk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=YN9tHGCc;
	spf=pass (imf20.hostedemail.com: domain of "prvs=475c5ed80=kalyazin@amazon.co.uk" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=475c5ed80=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1769114471; x=1800650471;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=L060fUvGttxYBIHa6eLU8Z48SLaOwnhKGvQs72E5QZs=;
  b=YN9tHGCcJ9HPQo1Yi0ySaCvzEdJAhC9rAjCF7X5pGOeFrLBl5RevrwP1
   BkXhDYCKIL0/Hhq9Qr7HQAOJHGAh3BdXy9tcCFroA2oQQjLNWgMh+Qz2S
   DFId3BL7l1/0kbZr2STJMyYqNRc2qp1mOphLbPcb6I2rEb30KvCYylexc
   XIfs08HZhwbpvmx+B1l5yJWp3HlFCcn4bSIjGiwY08FZO0k1eaKkUtWaH
   DJUBxkMdxWc4JyyJ2r+giDzI8oJes9CWFWI+P3L3vy8dRVu4RJ2KkZw3o
   x7y/y2x8KDASgBervAaQ773HpDPJeVV21BvTFqVqx/0LviJjScM1Ns/4w
   Q==;
X-CSE-ConnectionGUID: Eq/qtYVnSJqlAvEbKUczXA==
X-CSE-MsgGUID: JuRcDWNSTV2iEyPOM5D09w==
X-IronPort-AV: E=Sophos;i="6.21,246,1763424000"; 
   d="scan'208";a="8319239"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 20:40:53 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:3034]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.29.47:2525] with esmtp (Farcaster)
 id a5dd7989-855e-4510-b2e9-5fd9107a3c02; Thu, 22 Jan 2026 20:40:52 +0000 (UTC)
X-Farcaster-Flow-ID: a5dd7989-855e-4510-b2e9-5fd9107a3c02
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 22 Jan 2026 20:40:51 +0000
Received: from [192.168.23.186] (10.106.82.17) by
 EX19D005EUB003.ant.amazon.com (10.252.51.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 22 Jan 2026 20:40:47 +0000
Message-ID: <0635e64a-2194-4a6c-b772-28af54d58e3b@amazon.com>
Date: Thu, 22 Jan 2026 20:40:46 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from direct
 map
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
	<loongarch@lists.linux.dev>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net"
	<corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org"
	<oupton@kernel.org>, "joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com"
	<mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org"
	<luto@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"willy@infradead.org" <willy@infradead.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
	<surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, "ast@kernel.org"
	<ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>,
	"andrii@kernel.org" <andrii@kernel.org>, "martin.lau@linux.dev"
	<martin.lau@linux.dev>, "eddyz87@gmail.com" <eddyz87@gmail.com>,
	"song@kernel.org" <song@kernel.org>, "yonghong.song@linux.dev"
	<yonghong.song@linux.dev>, "john.fastabend@gmail.com"
	<john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>,
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>,
	"jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com"
	<peterx@redhat.com>, "jannh@google.com" <jannh@google.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>, "shuah@kernel.org" <shuah@kernel.org>,
	"riel@surriel.com" <riel@surriel.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "jgross@suse.com" <jgross@suse.com>,
	"yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "coxu@redhat.com" <coxu@redhat.com>,
	"kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, "maobibo@loongson.cn"
	<maobibo@loongson.cn>, "prsampat@amd.com" <prsampat@amd.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jmattson@google.com"
	<jmattson@google.com>, "jthoughton@google.com" <jthoughton@google.com>,
	"agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, "alex@ghiti.fr"
	<alex@ghiti.fr>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "dev.jain@arm.com"
	<dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>,
	"hca@linux.ibm.com" <hca@linux.ibm.com>, "Jonathan.Cameron@huawei.com"
	<Jonathan.Cameron@huawei.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>,
	"pjw@kernel.org" <pjw@kernel.org>, "shijie@os.amperecomputing.com"
	<shijie@os.amperecomputing.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>,
	"thuth@redhat.com" <thuth@redhat.com>, "wyihan@google.com"
	<wyihan@google.com>, "yang@os.amperecomputing.com"
	<yang@os.amperecomputing.com>, "vannapurve@google.com"
	<vannapurve@google.com>, "jackmanb@google.com" <jackmanb@google.com>,
	"aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, "patrick.roy@linux.dev"
	<patrick.roy@linux.dev>, "Thomson, Jack" <jackabt@amazon.co.uk>, "Itazuri,
 Takahiro" <itazur@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>,
	"Cali, Marco" <xmarcalx@amazon.co.uk>
References: <20260114134510.1835-1-kalyazin@amazon.com>
 <20260114134510.1835-8-kalyazin@amazon.com>
 <CAEvNRgEzVhEzr-3GWTsE7GSBsPdvVLq7WFEeLHzcmMe=R9S51w@mail.gmail.com>
 <a2b79af7-e5d1-4668-bff3-606f57d32dfc@amazon.com>
 <CAEvNRgF46M1jp0+eBu2wQMO7P1afyo00SOkENFwvB2KYX3dnFA@mail.gmail.com>
 <f2f2a6bd-5cb4-46c9-a0f8-3240670094b5@amazon.com>
 <CAEvNRgEd=Uh09dU_P7_vvzRpOyMYd=OKazpkxzr=VLe5HcQhGw@mail.gmail.com>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
Autocrypt: addr=kalyazin@amazon.com; keydata=
 xjMEY+ZIvRYJKwYBBAHaRw8BAQdA9FwYskD/5BFmiiTgktstviS9svHeszG2JfIkUqjxf+/N
 JU5pa2l0YSBLYWx5YXppbiA8a2FseWF6aW5AYW1hem9uLmNvbT7CjwQTFggANxYhBGhhGDEy
 BjLQwD9FsK+SyiCpmmTzBQJnrNfABQkFps9DAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQr5LK
 IKmaZPOpfgD/exazh4C2Z8fNEz54YLJ6tuFEgQrVQPX6nQ/PfQi2+dwBAMGTpZcj9Z9NvSe1
 CmmKYnYjhzGxzjBs8itSUvWIcMsFzjgEY+ZIvRIKKwYBBAGXVQEFAQEHQCqd7/nb2tb36vZt
 ubg1iBLCSDctMlKHsQTp7wCnEc4RAwEIB8J+BBgWCAAmFiEEaGEYMTIGMtDAP0Wwr5LKIKma
 ZPMFAmes18AFCQWmz0MCGwwACgkQr5LKIKmaZPNTlQEA+q+rGFn7273rOAg+rxPty0M8lJbT
 i2kGo8RmPPLu650A/1kWgz1AnenQUYzTAFnZrKSsXAw5WoHaDLBz9kiO5pAK
In-Reply-To: <CAEvNRgEd=Uh09dU_P7_vvzRpOyMYd=OKazpkxzr=VLe5HcQhGw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.82.17]
X-ClientProxiedBy: EX19D004EUC003.ant.amazon.com (10.252.51.249) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspamd-Queue-Id: EA19B1C0008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: a7gyxkzeuji5h668p3r4nnqmfxhc1op4
X-HE-Tag: 1769114470-531015
X-HE-Meta: U2FsdGVkX1+YaWcYvj8qAFoKTnexDe6Wh23VByfEHkK1rhMRtxhg+FqxbCUCBIUt/adJ0Fj7FjDL15uWj2XDTij+yhaDoxB0n8VmwBmGxHVoTY/13LNDXcuUjXbDPB9xjaJF9llZ4l2QSd7TV9kIpL5sDi8q+Afxd/Gf/InXbNQGZq0+CjpHm+mnhMYiHwbaSGmDxEq3GFOQjHM7sMTSCjvV65/Fe2JORlOP5THlmxzqiwmgWF13/Gd/CFraib0DhkBjMQrSmPeAoE36VDvc9sBh/cgnxCuiW/1caJqPPHUdMDk5L8PeHo08B0uXJ12o8dRWzhpDzzhb2rwAB8PGF9NffDJhGjs4ttj/pAD9BY06w5G+7cVStuyoFzCJVi1v/1yB+NMswOXwVbPN6SvvLHLog6inqQ/PIC21DhuI47ewabtdK2CENPQ2aZkVR2jtEvHqWy6ixkPFmZHpC3TfxjqHBAC8ShpcfQhDWJ0kCdvoOqQ/gvecM31CzJUbAkZWS81t1hoYDbuqvTu/F/t92WYCc1A0iqI0GAey8F6Ay+M5NlR9a1Biz/UojnbIPy8NqooT2ky2JXYeU6nSPiIRHFRoc1t0TbK3YXNfhR/fpUIh8NVqPkut+wKv9fwGzEMGWYY7UEppORuvczfbsN04McuUBDE8j6WbWa6JnPWB3BUs5KzNIJ+nQMlfwQKOlpeIMjOGbTDmzFwaREWucvI5IpnvShyAjbklrAAy8Z3N7WSa/0PQuIBlJYB3DNFOH+qpba+P9Mu4yvH9DDPn8nHKHavyExapHGb5etf2soHIdzcOZOYioTAZLyB4HgA097WBvipG//NnenDgFdyPvuDXq9ixdtqOXHOfXH4/M3+IPoKIoyQpnqyMyxIebYmKZtTER9JZdmqB9RxMzhaKSoqD1McJy+qZ88LZMpL7u4QW3sZdwTd4fGNgxoJp/sUuFpzY/z+PE04C7td8zHVFwIl
 xkTmJwor
 ScM8I+4SGuRqL8xfBcSv6S31wOGG28Oh3HpVPiN6KcXFNnjgjEEEIMPaaZ4znxPmfwC9DmH0j7p1v/yk2WDL1qXYQJil8fLMbwc5PAq0vLujJCp2/eSvLARPg8w7Gu2Z+frrsEd5iHmnHXH59eKvm7fHvjTV7DLTQiuk3h3zkEiwQ0xNKle3xGhNs0UyauIupMpkn0rgHo0IDxA0crrBCoOrdyVCn26LjMuEEfyIJ9KxDfWDp6cdy4jHRcbJT7OwXUzgCq1Lletrr+ncix3yW+NvmstLbhVBhkF8Op8giVRmaMcYvRzvk2lE3WwAQ8HMIUMtFc5pzcK7Ied70eksCSwU//+Zdkdr8U49cGst4eHLkrYfytYjl0/bnDAs2oPfuIQbH36I0oTQFeU212271+l6t5QJl9tPD0m/d8eeqio3FwNLCrH+11E3yPGKzTNn41LCGG0UVSkmIQIkeTuY18zJSucrEmELz/VLsqzBoIoSzLP8QplhWAZZJQw1PJtTTiWrjJWG+MMGmlgcv/6EqEiDDqqmLN5bQKlrMWNcHxMRAl3S8CUJTDx2Rc9Y6OqYNc2HCUHc09E3/XIs07gyWb0fmwvPilXi6tPbzKlIBJZz5Ue/a6VyshRRLEbg/yzaXa9SX4I8jPa1nfsnefPcrK+Daq9jQ3Sz0NClX/B6xTOTrpAtzIrVwVAuHDgJ833Qsxywoq6+ZVPRLYcqiVV7EXbmJ2Gr2JeI7QvyrtdrtKfW2bq/x8d+AzhSL+u2KuN9zX5NUYu4v1++7qBntzQWPq234TZhPbLEHIckhSDhVDXFfeL+sHrG0xSrUFJh9DBMcXBMaSFkVWviNJ19zUDRt7tB+q877F3fMtlRS3NMBFGY5wnrh/2TlhthPr1wdClWIp2JoUTHp6c1N69SQUIe4J03kn0lceERRtqWcvnId26lxTNRkZ8ZCnLgmBDig6XFIzBc7AnPlnmYqUai0N2XG7kFsrxXV
 w7Q7HU91
 ILh+AT+kFMen4rhu5LJe+pX/bxBIpemaCOa480KU6jSc4t1z65tD1pR+OU+Ac9WF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 22/01/2026 20:30, Ackerley Tng wrote:
> Nikita Kalyazin <kalyazin@amazon.com> writes:
> 
>>
>> [...snip...]
>>
>>>>>> @@ -533,6 +580,8 @@ static void kvm_gmem_free_folio(struct folio *folio)
>>>>>>          kvm_pfn_t pfn = page_to_pfn(page);
>>>>>>          int order = folio_order(folio);
>>>>>>
>>>>>> +     kvm_gmem_folio_restore_direct_map(folio);
>>>>>> +
>>>>>
>>>>> I can't decide if the kvm_gmem_folio_no_direct_map(folio) should be in
>>>>> the caller or within kvm_gmem_folio_restore_direct_map(), since this
>>>>> time it's a folio-specific property being checked.
>>>>
>>>> I'm tempted to keep it similar to the kvm_gmem_folio_zap_direct_map()
>>>> case.  How does the fact it's a folio-speicific property change your
>>>> reasoning?
>>>>
>>>
>>> This is good too:
>>>
>>>     if (kvm_gmem_folio_no_direct_map(folio))
>>>             kvm_gmem_folio_restore_direct_map(folio)
>>
>> It turns out we can't do that because folio->mapping is gone by the time
>> filemap_free_folio() is called so we can't inspect the flags.  Are you
>> ok with only having this check when zapping (but not when restoring)?
>> Do you think we should add a comment saying it's conditional here?
>>
> 
> I thought kvm_gmem_folio_no_direct_map() only reads folio->private,
> which I think should still be there at the point of
> filemap_free_folio().

Oh, I misread your last reply.  What you're proposing would work indeed.

> 
>>>
>>> [...snip...]
>>>


