Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D55F8C982CA
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 15:01:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 494416B00AB; Fri, 16 Jan 2026 10:01:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4414E6B00AC; Fri, 16 Jan 2026 10:01:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30EEC6B00AD; Fri, 16 Jan 2026 10:01:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1FA986B00AB
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:01:20 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E75AE1A0189
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:01:19 +0000 (UTC)
X-FDA: 84338140278.29.D1065D9
Received: from fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.197.217.180])
	by imf01.hostedemail.com (Postfix) with ESMTP id 39FB840010
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:01:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=BNjYuW99;
	spf=pass (imf01.hostedemail.com: domain of "prvs=469074ca4=kalyazin@amazon.co.uk" designates 18.197.217.180 as permitted sender) smtp.mailfrom="prvs=469074ca4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768575677;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aTijkiEgAEgLfBD3f1GYfjv2OO1D0EQ13p+mBFzBwWI=;
	b=lB6URnNfhC82wKCBK6TtakT1PH412vBs3Gn3mi9L+fJX71EYW2ziamGFGzC7wk8F+ci1ja
	Y36xqDCDuSgxBwumbS7qz/tdjVKicJDQn+kj45W242hGJFnthiGiTtZKW8rV7GA04JfuV4
	qcjJq0/SN6Gr8q061ja4nNODIcpAe3I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768575677; a=rsa-sha256;
	cv=none;
	b=X5WZIVIdh0G3J+2Tw/44URUdWsrBS9Tbsc1t/bc1sA30S/PD/FhVKN9gryb9yUHye7Qz3h
	M0PITrxJ/HhA0bG5CvwxeYBnlWLfJdoQuN3Rd1H/7iBEmqT+Pqyivxt7YqyQhU+CkUOHTz
	J3W6Qtd+jLz8oC2ghWQuLCVL43Fy5BA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=BNjYuW99;
	spf=pass (imf01.hostedemail.com: domain of "prvs=469074ca4=kalyazin@amazon.co.uk" designates 18.197.217.180 as permitted sender) smtp.mailfrom="prvs=469074ca4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1768575677; x=1800111677;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=aTijkiEgAEgLfBD3f1GYfjv2OO1D0EQ13p+mBFzBwWI=;
  b=BNjYuW99z02amYsP/jN2C4o0IneXHQq8TR7/G2HAqJ4vFiLUU90bEITP
   nTwltO/GD//S0DJLmRZ8y8nilG/00dwt5HkKDp6u8dhqkwwM5Tk4ncEXv
   ZzQwTCLXCpVyU+DgiLvy0G393SO4zly9U5vTvskUGU9v+cMhYmZ0Xf3Tx
   E1/t6+lfzPqYGV5RO4PnlxBPyUlEhxVAtv8DZoKBplzQJRTdOQuUkCOsM
   pKpWRJAtm6/DngTTMlLsaB+9OzQJ4CgZZ5HeDh4Uh2bLQP60ln0oCOJR2
   004UEZjSGrtEsHn25F/Sbzz9721c4WWlWUUQZ7HA9n16XcUEpxX0c3mDM
   A==;
X-CSE-ConnectionGUID: Lgi63RilSou9/V8Gr9JAeg==
X-CSE-MsgGUID: ZoyC9RCmSGGaLDhTiRhoog==
X-IronPort-AV: E=Sophos;i="6.21,231,1763424000"; 
   d="scan'208";a="8022697"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 15:01:00 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:5028]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.30.60:2525] with esmtp (Farcaster)
 id d65bbded-3f2b-45ea-90e0-dd1ca16777be; Fri, 16 Jan 2026 15:00:59 +0000 (UTC)
X-Farcaster-Flow-ID: d65bbded-3f2b-45ea-90e0-dd1ca16777be
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Fri, 16 Jan 2026 15:00:58 +0000
Received: from [192.168.12.13] (10.106.82.9) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35; Fri, 16 Jan 2026
 15:00:54 +0000
Message-ID: <04173297-518d-460a-be9f-502d32cbe509@amazon.com>
Date: Fri, 16 Jan 2026 15:00:53 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v9 09/13] KVM: selftests: set KVM_MEM_GUEST_MEMFD in
 vm_mem_add() if guest_memfd != -1
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
 <20260114134510.1835-10-kalyazin@amazon.com>
 <CAEvNRgGz2gRu2i+OSxasuyZudqsRGXijbDES8uXVe_hH6QCK4g@mail.gmail.com>
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
In-Reply-To: <CAEvNRgGz2gRu2i+OSxasuyZudqsRGXijbDES8uXVe_hH6QCK4g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.82.9]
X-ClientProxiedBy: EX19D010EUA004.ant.amazon.com (10.252.50.94) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 39FB840010
X-Rspam-User: 
X-Stat-Signature: dzpy116dmjttq97mq313dzz4dsq7dduk
X-HE-Tag: 1768575676-375651
X-HE-Meta: U2FsdGVkX19O9gM0tQ/jTvInVHb2bH2R4Eee3ceGw5PDheK1zukZNvJdqaPeCwwXCKFyBcv71xJPAYCarcsYDr0ecbRVAi3x3dXT4Ao4znTFtsewyNatQ0lclUQU+VC4m0eQB/dg343Sk4EhJwdRV2J5n6Gn33TYAnSfjslJWnneNavxizjkCtoAhJ+RXSNiT1T+Afp4QAlHDrUO7+2HkkeleNX2gkHi1lCtCH0bBKhkLIZOQDAdUqbRyEy29YhvPegesFAXlxaunFQVFcCm7OvDp6OyOlkR9qWJ+L8Ni3t6p+3f6DpHkDvg+YR42oBQ6lFC7HJXJriPfaQtluxf1twOKr0Fp3bHwB+ytmM4lKZJ4rcNwsK/wpPd9kiBUXW+bLn7/qRUuYGQse7yBKWUXjQQJA5sMJJfVFh0uuL241JJjmcvtWqGD4/rNhvOiv0uNsnWtWqgikAPqLTkUwmS2xauhaAo58QajH4jnF6OaBHPu5cs+Qa0AP9Kx/VxhMFs3rFCAD8/rEBjcGvquyaFA5zHkn1NW2h2v4n6YCC9DhFpt8ZptegJAVwfWgYuOFTr2sZm1L3cFy239a32WgQufIxfXD7yGI0mZ8ak3lm5WwRDoZoJg+Lr5l3pZ49EhUravkDPf60ZQ+5j4FVDJFXi8YuGXRZpajR8vp+p04wZ2H4PDqXgqZ9rrsf2aneeMi13QrkZs4v7LLKhgptG3SNyQd0lNLTtqAAMDwP9/TKh75qhw4Xmyrj655iDBV9uw4kXua7LGRHwGjYVrNkqw8tGviUFpYwi4sD6Oq7WdXa9/l8d+53GhuSCKVcW6y+teYbBVKFqxwDnBQEwgN6vFKEsjFq3BWinn2Iuw7S1MTA84L0ZvLs7PF1J1Q0ticcDffvfX4SdPrLeYhtfsdu0NZ+J4z8KRF9w9lN67kQYQYocd59bQ6b8ks51YZNkqzCc0SElNUAS59KJNT6QViLgXaB
 C7VSawDF
 CSsZ7VZ8WRAVnUinUhLyCHZcUZlPgH8h8Emr+8fUKG6j/A99Ce/Eek/PKcl8hPRHUoK2d1+Scvnz56WeMnJM88QUx1Si9mdbm2YkFqloAblW+sbHq09Axz/qxsQU9khn9ypsu08KbW9OJPyA0uPe1EeYpYK1zJKmrAJs1hMlvG0DTo8NW0OmRN2azeLo8rkeq3a0pRwVePYvyn0Klg/SwTBQchMXgZ+LNeOpCfxMRLJ23IctqruA/rkQTCEIsPtpB35uhkr75hd7pbB8FfzdkbFb3zHaOOqVwg5ez97PAtYZAXVyyzajplJjyxi/eeqIhw8SMoyVqn9uetyaj1xaMwErhVV4VWdR/BKFMCUEbrlredDfxZGy1iXMdBWgqN1kaaS8+DVbPfbvg4hGHnAMSO2tBkQkrnwjnWDXA0zHK+5bEy9gSsFfU6TQGUY10XhZjSh96ZCWoQVQoyLQ33Aum7wUWj8W0w+m4QUML+TfAcguyP748ORTqEz9O25PaUYQuYDkE5HqfiUNCJp87GH9X9jiJOg3z68+F8w0F/+d7JquIk/VOgQRu4orIR77siRCMCVH6JjtfCk4g+QPbPROAotze8upobdnFAijOkvVM74G2XfomtylF/ujTOuUS9PdW/BEj++BOz+9mABXjU3lJUJXbqebUBUB10SP5iVp17r+qBLP7DrM2NnnUERbPl3Rwimfv0F93GSyvqZZRvsCAAw4W7eaxMFKleJcWL6FWI4Smz1qDbnsGMhGCoOJWZ7EgIOSoy92ONycHpSuBWvJ6COuhvp1s0I5mNNaldTh36EGRYyGX+yTS0K0sY4ly3l0HF0TQhPjFKmWCu49bWkziqcvDWwQ4DJ7+7u2X4PMR2uAxLm98hTSXTb7zH6TMyqKuO6eyHlQm6miVihQRI0NYeM/iTc3PeFwDQ+gxLzqjsVE0oM5JrvDnQ7fPIH3DNU0YBQ3GMLxchzkKo7Qr550N50J/HtFk
 V+EKYnjN
 Wq2282o9+9kqwTr5fwGlEcPWi70KkgSCf+Y8ANdaJ9wVvHBanKFGU0WkULxZbG35ef4uEk6NZVgzgoOR0MTKNhZm5ielnj1y54ou3P6ygpQteTVCXlUtP6xcaSRVUz16
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 15/01/2026 19:39, Ackerley Tng wrote:
> "Kalyazin, Nikita" <kalyazin@amazon.co.uk> writes:
> 
>> From: Patrick Roy <patrick.roy@linux.dev>
>>
>> Have vm_mem_add() always set KVM_MEM_GUEST_MEMFD in the memslot flags if
>> a guest_memfd is passed in as an argument. This eliminates the
>> possibility where a guest_memfd instance is passed to vm_mem_add(), but
>> it ends up being ignored because the flags argument does not specify
>> KVM_MEM_GUEST_MEMFD at the same time.
>>
>> This makes it easy to support more scenarios in which no vm_mem_add() is
>> not passed a guest_memfd instance, but is expected to allocate one.
>> Currently, this only happens if guest_memfd == -1 but flags &
>> KVM_MEM_GUEST_MEMFD != 0, but later vm_mem_add() will gain support for
>> loading the test code itself into guest_memfd (via
>> GUEST_MEMFD_FLAG_MMAP) if requested via a special
>> vm_mem_backing_src_type, at which point having to make sure the src_type
>> and flags are in-sync becomes cumbersome.
>>
>> Signed-off-by: Patrick Roy <patrick.roy@linux.dev>
>> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
>> ---
>>   tools/testing/selftests/kvm/lib/kvm_util.c | 24 +++++++++++++---------
>>   1 file changed, 14 insertions(+), 10 deletions(-)
>>
>> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
>> index 8279b6ced8d2..56ddbca91850 100644
>> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
>> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
>> @@ -1057,21 +1057,25 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>>
>>        region->backing_src_type = src_type;
>>
>> -     if (flags & KVM_MEM_GUEST_MEMFD) {
>> -             if (guest_memfd < 0) {
>> +     if (guest_memfd < 0) {
>> +             if (flags & KVM_MEM_GUEST_MEMFD) {
>>                        uint32_t guest_memfd_flags = 0;
>>                        TEST_ASSERT(!guest_memfd_offset,
>>                                    "Offset must be zero when creating new guest_memfd");
>>                        guest_memfd = vm_create_guest_memfd(vm, mem_size, guest_memfd_flags);
>> -             } else {
>> -                     /*
>> -                      * Install a unique fd for each memslot so that the fd
>> -                      * can be closed when the region is deleted without
>> -                      * needing to track if the fd is owned by the framework
>> -                      * or by the caller.
>> -                      */
>> -                     guest_memfd = kvm_dup(guest_memfd);
>>                }
>> +     } else {
>> +             /*
>> +              * Install a unique fd for each memslot so that the fd
>> +              * can be closed when the region is deleted without
>> +              * needing to track if the fd is owned by the framework
>> +              * or by the caller.
>> +              */
>> +             guest_memfd = kvm_dup(guest_memfd);
>> +     }
>> +
>> +     if (guest_memfd > 0) {
> 
> Might 0 turn out to be a valid return from dup() for a guest_memfd?

Yes, you're right, it isn't impossible.  Thanks!

> 
>> +             flags |= KVM_MEM_GUEST_MEMFD;
>>
>>                region->region.guest_memfd = guest_memfd;
>>                region->region.guest_memfd_offset = guest_memfd_offset;
> 
> Refactoring vm_mem_add() (/* FIXME: This thing needs to be ripped apart
> and rewritten. */) should probably be a separate patch series, but I'd
> like to take this opportunity to ask: Sean, what do you have in mind for
> the rewritten version?
> 
> Would it be something like struct vm_shape, where there are default
> mem_shapes, and the shapes get validated and then passed to
> vm_mem_add()?
> 
>> --
>> 2.50.1


