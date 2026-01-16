Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C48DC982DE
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 17:28:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD0356B0005; Fri, 16 Jan 2026 12:28:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7DAA6B008A; Fri, 16 Jan 2026 12:28:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B56426B008C; Fri, 16 Jan 2026 12:28:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A52BD6B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 12:28:34 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4B609C0BEF
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:28:34 +0000 (UTC)
X-FDA: 84338511348.23.70E1CB0
Received: from fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.143.178])
	by imf21.hostedemail.com (Postfix) with ESMTP id C314B1C0011
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:28:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=DrmU9FY+;
	spf=pass (imf21.hostedemail.com: domain of "prvs=469074ca4=kalyazin@amazon.co.uk" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=469074ca4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768584512;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iixAuY6QcleXCDLiS0osecYXCL2wD+IcnkmdhMNMceE=;
	b=dJdtv/wOupm67Q109L9x25p5v9QEkdyzJSm0umEFBT7oO9tStcgXGRaFEg0mO+seFwp9O+
	fGp6mGqXJDep41r5EJBlSO249qe5fbsCvAsHmfkTVvcnk3LIXZ3tF/YJ+KN5WHOGptc1Nk
	zo6fmKrTwebz5e3v6lxGqGDDDt8+AkY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=DrmU9FY+;
	spf=pass (imf21.hostedemail.com: domain of "prvs=469074ca4=kalyazin@amazon.co.uk" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=469074ca4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768584512; a=rsa-sha256;
	cv=none;
	b=qEtm1XSQXMc91AZMPvvVQXs8TaZLc0UU4DIQa04rInBagkIPGrgNHOFJIM7ADgJyUcwxfE
	J0OyO7dCeWoH4LkFQfR6JyAnUIFw8PF0w31DYq5aDFoYnThIaGi6Hm2jqcoM7S+dVMJ3Xz
	7XUGcgVRmRXEg5BbIbkLywLa51/2PJQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1768584511; x=1800120511;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=iixAuY6QcleXCDLiS0osecYXCL2wD+IcnkmdhMNMceE=;
  b=DrmU9FY+w68bbI5eLdHAfZOhUHqyM8XCloqme/HYlq5msrzbZ0imwUYO
   xaRCTrdNOam2tvimyxpNJePQjWXVlXNyC1qRPoVAMcJOB/BHuSLDm+S8o
   LOxHIEPitk/FF9ZIxnUxN4RBnW2JrjHYkxVxM9GfzTKxJhCjAMiGxmWYB
   Hf+IIaOKWxdlvIPLBP2FU4wFBBtSqpnTRRtAR8nsVCHJGM5b7m5+sFRNW
   hs7OHecg1MDnsbEyOn3hyHWqZN9ricxhW0PUN4ocmsx7DS74aid2/k0i6
   m3k5TrgPbHDEhtGLgINX6cn/KnJaL1a9M0yV4f3mGBSeynvNtUd6gVsnT
   g==;
X-CSE-ConnectionGUID: Qy9RLilmSb6mwlMCH/r26Q==
X-CSE-MsgGUID: FqlFUMb2T4mzbA9VY5PHdA==
X-IronPort-AV: E=Sophos;i="6.21,231,1763424000"; 
   d="scan'208";a="7924510"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 17:28:13 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.236:17818]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.21.80:2525] with esmtp (Farcaster)
 id 2ee969a8-f047-4c24-83b9-0d6192b592bb; Fri, 16 Jan 2026 17:28:13 +0000 (UTC)
X-Farcaster-Flow-ID: 2ee969a8-f047-4c24-83b9-0d6192b592bb
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Fri, 16 Jan 2026 17:28:13 +0000
Received: from [192.168.12.13] (10.106.82.9) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35; Fri, 16 Jan 2026
 17:28:08 +0000
Message-ID: <318407ba-ecb6-4691-8911-645fb8c20250@amazon.com>
Date: Fri, 16 Jan 2026 17:28:06 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from direct
 map
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kalyazin@amazon.co.uk"
	<kalyazin@amazon.co.uk>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "linux-s390@vger.kernel.org"
	<linux-s390@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"kernel@xen0n.name" <kernel@xen0n.name>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, "loongarch@lists.linux.dev"
	<loongarch@lists.linux.dev>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>
CC: "david@kernel.org" <david@kernel.org>, "svens@linux.ibm.com"
	<svens@linux.ibm.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "jgross@suse.com"
	<jgross@suse.com>, "surenb@google.com" <surenb@google.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "riel@surriel.com" <riel@surriel.com>, "pfalcato@suse.de"
	<pfalcato@suse.de>, "x86@kernel.org" <x86@kernel.org>, "rppt@kernel.org"
	<rppt@kernel.org>, "thuth@redhat.com" <thuth@redhat.com>,
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "maz@kernel.org"
	<maz@kernel.org>, "peterx@redhat.com" <peterx@redhat.com>, "ast@kernel.org"
	<ast@kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"pjw@kernel.org" <pjw@kernel.org>, "alex@ghiti.fr" <alex@ghiti.fr>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "hca@linux.ibm.com"
	<hca@linux.ibm.com>, "willy@infradead.org" <willy@infradead.org>,
	"wyihan@google.com" <wyihan@google.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "yang@os.amperecomputing.com"
	<yang@os.amperecomputing.com>, "jolsa@kernel.org" <jolsa@kernel.org>,
	"jmattson@google.com" <jmattson@google.com>, "luto@kernel.org"
	<luto@kernel.org>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>,
	"haoluo@google.com" <haoluo@google.com>, "patrick.roy@linux.dev"
	<patrick.roy@linux.dev>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "coxu@redhat.com" <coxu@redhat.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "hpa@zytor.com"
	<hpa@zytor.com>, "song@kernel.org" <song@kernel.org>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "maobibo@loongson.cn"
	<maobibo@loongson.cn>, "peterz@infradead.org" <peterz@infradead.org>,
	"oupton@kernel.org" <oupton@kernel.org>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
	"martin.lau@linux.dev" <martin.lau@linux.dev>, "jthoughton@google.com"
	<jthoughton@google.com>, "Jonathan.Cameron@huawei.com"
	<Jonathan.Cameron@huawei.com>, "Yu, Yu-cheng" <yu-cheng.yu@intel.com>,
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "yonghong.song@linux.dev"
	<yonghong.song@linux.dev>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
	"shuah@kernel.org" <shuah@kernel.org>, "prsampat@amd.com" <prsampat@amd.com>,
	"kevin.brodsky@arm.com" <kevin.brodsky@arm.com>,
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>,
	"itazur@amazon.co.uk" <itazur@amazon.co.uk>, "suzuki.poulose@arm.com"
	<suzuki.poulose@arm.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"dev.jain@arm.com" <dev.jain@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>,
	"jackabt@amazon.co.uk" <jackabt@amazon.co.uk>, "daniel@iogearbox.net"
	<daniel@iogearbox.net>, "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
	"andrii@kernel.org" <andrii@kernel.org>, "mingo@redhat.com"
	<mingo@redhat.com>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "derekmn@amazon.com"
	<derekmn@amazon.com>, "xmarcalx@amazon.co.uk" <xmarcalx@amazon.co.uk>,
	"kpsingh@kernel.org" <kpsingh@kernel.org>, "sdf@fomichev.me"
	<sdf@fomichev.me>, "jackmanb@google.com" <jackmanb@google.com>,
	"bp@alien8.de" <bp@alien8.de>, "corbet@lwn.net" <corbet@lwn.net>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "jannh@google.com"
	<jannh@google.com>, "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
	"kas@kernel.org" <kas@kernel.org>, "will@kernel.org" <will@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>
References: <20260114134510.1835-1-kalyazin@amazon.com>
 <20260114134510.1835-8-kalyazin@amazon.com>
 <e619ded526a2f9a4cec4f74383cef31519624935.camel@intel.com>
 <294bca75-2f3e-46db-bb24-7c471a779cc1@amazon.com>
 <bb58a21f91113ca39f8888d718d4450a5fd72808.camel@intel.com>
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
In-Reply-To: <bb58a21f91113ca39f8888d718d4450a5fd72808.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.82.9]
X-ClientProxiedBy: EX19D004EUC001.ant.amazon.com (10.252.51.190) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Stat-Signature: 7srqetiams6x8e6fuhr6jhoe9bf4ga9e
X-Rspam-User: 
X-Rspamd-Queue-Id: C314B1C0011
X-Rspamd-Server: rspam08
X-HE-Tag: 1768584511-211988
X-HE-Meta: U2FsdGVkX19FY8BTtF3PjL9RMfy3N8boIarpisoJMI9KK9bj12Mh612klmOJ5tQkarHbOU2zdxnwbMKbfOo/fZaJCx83hWUzE6freeBRqxz+NaK/9cZG+xVZ7UUir3dtgJ2xGGmIEd1qMLXGgVF2/vsT5eVgDhh7v4t91xosuReR2xZarTR2w8lPHbAIipAN8j/jwOJu8aj/xf12vz7KP7VZGfg8LLeEqk7U1Qo1i7Tl8LYbPJ27juR0FVupa6VOjrHNedxaSzhmB4b+wj5eDq6zscWyoQ6DyPgmO5CfkHB5gM+dX6a/PO9PQxcuLW8TRag77+9bG/le1pxCTCD8vtymnD1kfcid+ui4d4EzgxU11tjUkJHoczJ30LVJo6PKDdzdWDh4DYuH3fUL4rD8cNn3DAekyBI+X74w2rs0mhUch8N4GPYiPA6VPVn8XGYlSCFIWjbz0oFtnszmQOgC+TSZDwdsvAsT89Vu02yps/nP92eTDh1O3b/K1DedRkq/77xauq3Bya7cZe9qZq2c9ASJxCatmf0wZL+3krShGk7lGnCzDcTL/DXFJLTDZCeVzF6PBV5YNzAKUwfMQNVwvbIv55aNM55XtlF3rk0iPina1ESJvnmFX2RvBfEv0tuGqNQ3f7KtrLAs8vnknkBuFQ2lp0IsKCuZ/hERbssB49irgBk4k1zLKIJlRbHD3Jn7TyobULuuqwJKvisg/TQjl1oOw2V6C7NajEyKDw1jlgieHkm7f/TEzZ/y97U/iAXqBzhoNEH+tdCE+F54J+nq2xnFII+2Tb8yQuI5q/3anObPFqt0QaD9IwHKtnnEJDq5OzDwTnH+9SOKxpSNH533qq7mw/lKErdQSSHakWA9ilTSMeFiKRvVubiDRokGOlsSNEMHDhmU0Sj08tY4ytJQ0JTy1l5kMtm8i8IZwAw+MYRLDB4P4DRQ5GA4nF53YHAe78qoR5yFNlTJDlGxQ3p
 EA4sWncz
 YP0R2BTP/WzlHIowkrb2zPb1JCmXELPHX1LSaRSZZU+UO7xVKqa/iygIFwUMkSvNifnC7iv0ih640vwpQs+Pb3N2MwhqJdkq37PNmWA9O1bB8gEN0GHqmNF83h0Jqwg9+E6fL9FpcZ/PrIIqDuK8Z91TRowvx13jEwgsANH2/EU/smbHcNYIS141d/g4f9W1uIPTOP/SXiW5hyakh2i05ql9YCrtdCA6/WufX1AuBBa54jbJ9YJkTJ6Ep0sgQ2psFdVdhnRif1QswMgFw1qYZqX1UU+4NLmlgf5NzIf9XzPxWd6dCXsCM3fJCjOzZ45ul4HWDfttsv0DodsiBY9SkAq68Y3a+xqeq6D/cBqgwA0jqM96URI16tPNDQz5M4CbglYqmhI3ju5ehm3FJHAPD0sBhA4ib1Pxj4CbWZlPy45SbyM3otGS14xbtFc2e64Iks4OZw4cB7w+cumhdctZZ0h/FTcHbSsDmWJIov12aZBX8mSQcNVdvIwlxOntT+cR4cQxqyJRgG81gTnDB26e906PfCUGmfV5iSNy11uFNYoZDtQiV6BM6WmO98AUGVX+j9V4eNjYGfvCy5Cb+wUL8ys7DVjU/ehpzD/VEUvPabwkiqgZwUFmEtgt1uriU8V8kKM1whM32oJQ/q6hNtgTuxX/Xa0FtqReMLk3p8Aroju4gu3RjM3VTRsvisEHJIKWs8VDu3bqVlC1Az/S5OqUVUGufHuzc10SP1jv+Txib/RRGonlDLqzlUSfoGfSQYitxO2kSCkwvtmVu0R312kLYNXUcJ0Iz7Mvo7zFbItmPvWjKqIg3gil/djsrEPDGt0Z24siLt7msDUQQGfUxxCtsW0nZml4Z1fYaXw0+Xp2hnOwZRAprhNcIJXrycuDZrixQ7b5nzFQVFC1s+2rGQyHcz0jrZP5fRCIjcudDTilBwcWUoWAcEPXx0y/6G7mqWD8Ci6MtvdLhAaYABmIBmOEDoCs1cj9W
 GZd3SajG
 Axz9uKuGzJOrhcbDjQ0GgBVYrXCOxsEYkXNNGCdipyQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 16/01/2026 15:34, Edgecombe, Rick P wrote:
> On Fri, 2026-01-16 at 15:00 +0000, Nikita Kalyazin wrote:
>>> Does this assume the folio would not have been split after it was
>>> zapped? As in, if it was zapped at 2MB granularity (no 4KB direct
>>> map split required) but then restored at 4KB (split required)? Or
>>> it gets merged somehow before this?
>>
>> AFAIK it can't be zapped at 2MB granularity as the zapping code will
>> inevitably cause splitting because guest_memfd faults occur at the
>> base page granularity as of now.
> 
> Ah, right since there are no huge pages currently. Then the huge page
> series will need to keep this in mind and figure out some solution.
> Probably worth a comment on that assumption to help anyone that changes
> it.

Makes sense.  I'll leave a comment.

> 
> I imagine this feature is really targeted towards machines running a
> bunch of untrusted VMs, so cloud hypervisors really. In that case the
> direct map will probably be carved up pretty quick. Did you consider
> just breaking the full direct map to 4k at the start when it's in use?

That's an interesting point, I haven't thought about it from this 
perspective.  We should run some tests internally to see if it'd help. 
This will likely change with support for huge pages coming in though.

