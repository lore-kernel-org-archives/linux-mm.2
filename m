Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D274C982CA
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 15:02:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4D8A6B00AC; Fri, 16 Jan 2026 10:02:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0E3C6B00AE; Fri, 16 Jan 2026 10:02:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F35C6B00AF; Fri, 16 Jan 2026 10:02:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8FD246B00AC
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:02:49 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6333E1A018C
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:02:49 +0000 (UTC)
X-FDA: 84338144058.18.4708810
Received: from fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.199.210.3])
	by imf30.hostedemail.com (Postfix) with ESMTP id D2E0B8000A
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:02:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="qD/fDS5P";
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf30.hostedemail.com: domain of "prvs=469074ca4=kalyazin@amazon.co.uk" designates 18.199.210.3 as permitted sender) smtp.mailfrom="prvs=469074ca4=kalyazin@amazon.co.uk"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768575767; a=rsa-sha256;
	cv=none;
	b=DNQPFrrOsMZPCUfrx5OdBPqgWaAOUlRxIpdM1AzKtWPCW72w9M8ufETpvAS04d7EUhnlYb
	oetFUipG4lXVomzYzX4Xgk3T+1a92rTpRlX0WcexCxUnLzy5bbl4BIsEuiISFXKnnkgH7A
	kXUJGsUGJhoLUMIWGmG/aOVw+gPZrog=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="qD/fDS5P";
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf30.hostedemail.com: domain of "prvs=469074ca4=kalyazin@amazon.co.uk" designates 18.199.210.3 as permitted sender) smtp.mailfrom="prvs=469074ca4=kalyazin@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768575767;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vgEOcPvSDFlnojIEi9fDkTiU/IY1eXjcDPZz2p9VuaI=;
	b=C37Wcq67TJg2pMR1GJkFvnxY/HXcySR80vwSsFaefHGMzWkfrBXUxo4sAuCILiZaPsBtsh
	ieGAZ5LPSxKv9r8GvYhWACxBzNk7usiyCSHNbpPJhyv0jS4NerM7pTYVnraWYnnrr28dMR
	rdrDMihTnnu7ASPy98uSiBfSf5fR2JU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1768575767; x=1800111767;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=vgEOcPvSDFlnojIEi9fDkTiU/IY1eXjcDPZz2p9VuaI=;
  b=qD/fDS5PfUjzdz+bCJJvJQAtjwsoTfocr0iBonUrkMprfmawFZ6VBdy7
   JJub6/fgnqt39BMpRhqsUOLSoFGmIXAMiRK/4eb9cPFEuaamtLUtHnJ2a
   WWe7Ry5w1GIEc1Bu9FZ5wEs7pYVVyBZq+XWSBrnsyMhKHzYnoWajG1uGw
   viWxqEN0iVojTyuwr+NhgdKzieR5PP2C8fAW4V1MAZBtg7uZI0ZMB4tW5
   cCGRoKiJRTI1v/NeOBC8ovCnqzJfQt6Wuv+l+Y4kegc2sdFnjzQgUo9/5
   7TDQjl/HC4wQBg4VOX9LesHW+cqVatjYdc/MUMBrjOCSBqraDpCd54e28
   w==;
X-CSE-ConnectionGUID: 8rdRYcCTR8imomIXxqbd0Q==
X-CSE-MsgGUID: EJyP+fC3R0m9epUUPjXDgw==
X-IronPort-AV: E=Sophos;i="6.21,231,1763424000"; 
   d="scan'208";a="7920549"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 15:02:45 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.232:4746]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.8.163:2525] with esmtp (Farcaster)
 id d396bcea-2275-4311-8348-ff7e15490f17; Fri, 16 Jan 2026 15:02:45 +0000 (UTC)
X-Farcaster-Flow-ID: d396bcea-2275-4311-8348-ff7e15490f17
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Fri, 16 Jan 2026 15:02:34 +0000
Received: from [192.168.12.13] (10.106.82.9) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35; Fri, 16 Jan 2026
 15:02:30 +0000
Message-ID: <208b151b-f458-4327-94bc-eb3f32d20a68@amazon.com>
Date: Fri, 16 Jan 2026 15:02:29 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from direct
 map
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	"kalyazin@amazon.co.uk" <kalyazin@amazon.co.uk>, "kernel@xen0n.name"
	<kernel@xen0n.name>, "linux-kselftest@vger.kernel.org"
	<linux-kselftest@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>
CC: "david@kernel.org" <david@kernel.org>, "palmer@dabbelt.com"
	<palmer@dabbelt.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"svens@linux.ibm.com" <svens@linux.ibm.com>, "jgross@suse.com"
	<jgross@suse.com>, "surenb@google.com" <surenb@google.com>,
	"riel@surriel.com" <riel@surriel.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
	"peterx@redhat.com" <peterx@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
	"rppt@kernel.org" <rppt@kernel.org>, "thuth@redhat.com" <thuth@redhat.com>,
	"maz@kernel.org" <maz@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "ast@kernel.org" <ast@kernel.org>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "Annapurve, Vishal"
	<vannapurve@google.com>, "borntraeger@linux.ibm.com"
	<borntraeger@linux.ibm.com>, "alex@ghiti.fr" <alex@ghiti.fr>,
	"pjw@kernel.org" <pjw@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"willy@infradead.org" <willy@infradead.org>, "hca@linux.ibm.com"
	<hca@linux.ibm.com>, "wyihan@google.com" <wyihan@google.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jolsa@kernel.org"
	<jolsa@kernel.org>, "yang@os.amperecomputing.com"
	<yang@os.amperecomputing.com>, "jmattson@google.com" <jmattson@google.com>,
	"luto@kernel.org" <luto@kernel.org>, "aneesh.kumar@kernel.org"
	<aneesh.kumar@kernel.org>, "haoluo@google.com" <haoluo@google.com>,
	"patrick.roy@linux.dev" <patrick.roy@linux.dev>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "coxu@redhat.com" <coxu@redhat.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "hpa@zytor.com"
	<hpa@zytor.com>, "song@kernel.org" <song@kernel.org>, "oupton@kernel.org"
	<oupton@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "jthoughton@google.com" <jthoughton@google.com>,
	"martin.lau@linux.dev" <martin.lau@linux.dev>, "jhubbard@nvidia.com"
	<jhubbard@nvidia.com>, "Yu, Yu-cheng" <yu-cheng.yu@intel.com>,
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "yonghong.song@linux.dev"
	<yonghong.song@linux.dev>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
	"shuah@kernel.org" <shuah@kernel.org>, "prsampat@amd.com" <prsampat@amd.com>,
	"kevin.brodsky@arm.com" <kevin.brodsky@arm.com>,
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "itazur@amazon.co.uk"
	<itazur@amazon.co.uk>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "dev.jain@arm.com"
	<dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>,
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
 <ed01838830679880d3eadaf6f11c539b9c72c22d.camel@intel.com>
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
In-Reply-To: <ed01838830679880d3eadaf6f11c539b9c72c22d.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.82.9]
X-ClientProxiedBy: EX19D013EUB001.ant.amazon.com (10.252.51.116) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspam-User: 
X-Stat-Signature: eon5fj33yr1pmpqde18mzwb9dhzgh8po
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D2E0B8000A
X-HE-Tag: 1768575766-480581
X-HE-Meta: U2FsdGVkX1/nIUBio+WtDjCirl2L/H39/NUztozsKacTr1orL+hOdsoosPx8i4f2l9Z8THjr2Wv00mRTPyF9QVYN2/f98B9j62E0ubYm0YPE+oy7XpZ/ikVhBz3C1Q2OJdXVz6BEGuXqEvci+oD9RSqnx7QoUswB0RKEba6DhHZ5crEl7YokbwnSsQkbi4ABG4ASSn6hHGOjELtv5j5JLIR8G/k8lLpTWNwzty9BVSqhB8kXRrbOPRchxI9ZDI7167cKhOmv3/wCQE2KcNR2WQ9YwYPEUCJktq0v/Eq/jjfFHDRKbG0IEVu4GlY995drVS2gX1oEp9bCrRg/9wnVCwLFo7Brp6baUAqTJscoNqFZrzRy4CyN50j+QPhH/9u6KyKRYxbHcI2+Kx6VdzHB/uQPLuOsLvEdvj1iEuId1mdEKMIDn9WHN+cxkGvIfbKTnjfcGKALDpUuHWHX019XxtGIq8TcICPEyg602uK8HP//y7PcZoSOmF6hqNm/Ja3X5fJShdAqz2foP6STBefLE91jmCbiW3ZJD1qy9kt1+9ZTI8pIbHuHLt61FZ9Yt77icswXvDHm4k32JcYBKKiVpyin3JiGYLmFvA/Whp4fdWbqlE1x+sOQrmXDnqVKjeFzGAEWgCh5nz+8ZygjS0jO87ANIyObVozl9XIqsrfC+fSWquNQkdERI9O6bo/HIJzDZTMmNYNW/c48chX9PlrrH5v6nWtXw2JqPa+Bs48RBBTK+h5BFs0DZJVD60nmhHO3U9lcmY0PBLlQYSjlFYh8eYV/Xu7q/YCntneabQYVsnH4I71J1S1rE4Q7BsozbKYM0QU//SkC76YG/rvmJExrysvDo19Obddn2NI940wUorRIoOgb1VN+wWddp2A9ejvbkx6tgnCroropYnn009oqPMHoGT7NozK4HWe5auxMknBzLGuqVdYuESf5ZOYpH6Q050D4WB17aTUU6Ae8EwY
 l2byZEP8
 Xox6gVSkMDKu8Y32lLFPewKmIUqhP1cRz26N8TNjGj2IGNSjoEeaRRd0vio5aivWWD8AA91K9Hje/7x1Ctzh9Jpfw5TTOaq2B6zZP7gHkeQGkUAROmbkSlYOHnrOuouhyUS8kKRRV9nFkWehX6lWyj02PwqYaWc162Iu60hrSV4NKnj4ryWF3xPZMrwVXOzQCd8zRfS3benTnA9FFWycr01f20NndMcJs66hPbZpuVWqbvlr5yeJVU0WuBZncZaAnkqTpES+n1pt/o5eog9q6U0A0TBVAtWnnB4FhNl/v7E0Lq5BVAExdr6mgiq94DmOw/JwZFrn6E8p4WSo6dmwanVVmJ6VRkqmEkcQew6JIyUn2s1hNdyPnU6jOW8ZB+FN0cfyYqWelwIT7nJ6YaxAfwk1lkJLWoivhibWrZ2ZrY4s0nimrHBhzqf2AkocMb87yRlbIzR/Kpp7DsxYnX0qHvs4nHxF4rsnbBXW+pCHMrLflcBIFOn4kdbbI1PFLZS2agmbUNyaKV0zhbtNb/qe11a5DbzjGU8dnqDVWGdu6BHOpr9LcWhBwGoCTyBhQ3/1f7bTHvkCzvnxvNWj3YNb1C74JiGDZdUQ7u6/Sa26VI5BxREYE00MOkyxQoociBR9l2rGZsnaD4Wf7CjftnueRbrOOT54OCftApj7Wi72gBrj58DyHTluRvFlAW9Qhk/+yRP4baOe2r35mpcg+n1MkYq8N1i4Ss064RBBIcXdVjLJGMpMstHNCNiv8/nAQ7o+fVIONZDPtn0KeIhyp8R1wDvMbMPre6cduypSZhm+R5KnlW4cpJZHR+p5Jsoz7wWVvnTWAmElvS+POSX19sHkhvG86JN0L3LNoVg5z6qrRHId16KmSiTxeD4rXef8FdNxdnQIfiER7Ing3jjG7DejJHEBu5oDKpy98qa9AdmvpaXKjaBWChtJuHGFBU2NmfGh2bY97aT1NWreqSbWrP6R7/DXqNMOr
 D8BbgALq
 144zzZ2S3R2Nl3LJIMNp54iEqfVaWXna
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 15/01/2026 23:04, Edgecombe, Rick P wrote:
> On Wed, 2026-01-14 at 13:46 +0000, Kalyazin, Nikita wrote:
>> Add GUEST_MEMFD_FLAG_NO_DIRECT_MAP flag for KVM_CREATE_GUEST_MEMFD()
>> ioctl. When set, guest_memfd folios will be removed from the direct map
>> after preparation, with direct map entries only restored when the folios
>> are freed.
>>
>> To ensure these folios do not end up in places where the kernel cannot
>> deal with them, set AS_NO_DIRECT_MAP on the guest_memfd's struct
>> address_space if GUEST_MEMFD_FLAG_NO_DIRECT_MAP is requested.
>>
>> Note that this flag causes removal of direct map entries for all
>> guest_memfd folios independent of whether they are "shared" or "private"
>> (although current guest_memfd only supports either all folios in the
>> "shared" state, or all folios in the "private" state if
>> GUEST_MEMFD_FLAG_MMAP is not set). The usecase for removing direct map
>> entries of also the shared parts of guest_memfd are a special type of
>> non-CoCo VM where, host userspace is trusted to have access to all of
>> guest memory, but where Spectre-style transient execution attacks
>> through the host kernel's direct map should still be mitigated.  In this
>> setup, KVM retains access to guest memory via userspace mappings of
>> guest_memfd, which are reflected back into KVM's memslots via
>> userspace_addr. This is needed for things like MMIO emulation on x86_64
>> to work.
> 
> TDX does some clearing at the direct map mapping for pages that comes from gmem,
> using a special instruction. It also does some clflushing at the direct map
> address for these pages. So I think we need to make sure TDs don't pull from
> gmem fds with this flag.

Would you be able to give a pointer on how we can do that?  I'm not very 
familiar with the TDX code.

> 
> Not that there would be any expected use of the flag for TDs, but it could cause
> a crash.


