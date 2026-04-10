Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF66FF459F3
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 15:27:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 245A76B00C3; Fri, 10 Apr 2026 11:27:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21DBF6B00C4; Fri, 10 Apr 2026 11:27:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10CA86B00C5; Fri, 10 Apr 2026 11:27:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 021436B00C3
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:27:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AD48FE04E9
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:27:47 +0000 (UTC)
X-FDA: 84643026174.09.4EE47DF
Received: from iad-out-015.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-015.esa.us-east-1.outbound.mail-perimeter.amazon.com [44.210.169.44])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6D34A180003
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:27:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=s9czcw9d;
	spf=pass (imf06.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 44.210.169.44 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775834865;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9o8hF03EAteJcxO+ztYPE0eNUqVudqJ5+FMe40ZmXyc=;
	b=11zGzxxKwrVifNT7Qaa442gERgb0eL5m6yEtMUakqdmUoTuG3VoxtO8vpY7xk5/4ZGquTQ
	E9DA3bPC1weyt64bc1AEZHtFBTuYr2ZjfbvRSQ52wNPoCxUEgNtN5M63/N48LiJepNowWH
	2CL+V6H0rXTZuZAxs98WwFFuPdwciPM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=s9czcw9d;
	spf=pass (imf06.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 44.210.169.44 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775834865; a=rsa-sha256;
	cv=none;
	b=Et+lRz7TobBC8yTBVynxacCPqpnyAi0mE1Q6ejh3iqtsmCa2lKW5ltjeBcow7XvTddiCWE
	sDgW9vRHPOAA4rGgRlO490hYOz+/Of6HgOIJepMzsp92gT2OMOaEl5kXXAlXr84cO9IGKm
	CBaZI6GKqgjf5iKhYr/75Yt4YG1eV9U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1775834865; x=1807370865;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=9o8hF03EAteJcxO+ztYPE0eNUqVudqJ5+FMe40ZmXyc=;
  b=s9czcw9dUvlWIDj9BTcqPNHAP0VavDNBUVVKctyaaK+d/as99k3a1/mv
   w4Ju4zi/tFNhY8Ya0aBwyRCBgvufDfBtvRZbfuw2GodgevxGsUZzv9m+I
   31RcbwrqW61cv+VhJO+TNttt3r71R4e8GXklLT8rw5elRW6h0DeiZFfLa
   8V1B106rzcOIwR6xpSHYwwyNjIRnldUvyp909ih7sE4mEQh9GNJTW7BT5
   drVEKlJOBUtMDAJE57WDgkDwr72d/88sXD4L++layUw3jvXGafLxJW+Om
   CedyLo4HyggVcEbs38PWirK2RdGpVFSVATfAdxKVl2j7pPHyjGFrexMEl
   Q==;
X-CSE-ConnectionGUID: yBao2GgVSJWVWmju2N8usQ==
X-CSE-MsgGUID: y2rUWQDASnCMvlD14S4uKA==
X-IronPort-AV: E=Sophos;i="6.23,171,1770595200"; 
   d="scan'208";a="15420134"
Received: from ip-10-4-13-79.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.13.79])
  by internal-iad-out-015.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 15:27:44 +0000
Received: from EX19MTAUEC002.ant.amazon.com [52.94.133.130:17740]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.46.155:2525] with esmtp (Farcaster)
 id 675e78a9-fd73-4b67-b9dc-b2724822a679; Fri, 10 Apr 2026 15:27:44 +0000 (UTC)
X-Farcaster-Flow-ID: 675e78a9-fd73-4b67-b9dc-b2724822a679
Received: from EX19D027UEC003.ant.amazon.com (10.252.137.250) by
 EX19MTAUEC002.ant.amazon.com (10.252.135.253) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 15:27:43 +0000
Received: from [192.168.12.97] (10.106.82.30) by EX19D027UEC003.ant.amazon.com
 (10.252.137.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Fri, 10 Apr 2026
 15:27:31 +0000
Message-ID: <28ecd1c9-184a-4514-b91f-e57944861641@amazon.com>
Date: Fri, 10 Apr 2026 16:27:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v11 05/16] mm/gup: drop local variable in
 gup_fast_folio_allowed
To: Ackerley Tng <ackerleytng@google.com>, "David Hildenbrand (Arm)"
	<david@kernel.org>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
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
	<akpm@linux-foundation.org>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "vbabka@kernel.org" <vbabka@kernel.org>,
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "ast@kernel.org" <ast@kernel.org>,
	"daniel@iogearbox.net" <daniel@iogearbox.net>, "andrii@kernel.org"
	<andrii@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>,
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org" <song@kernel.org>,
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
 <20260317141031.514-6-kalyazin@amazon.com>
 <0a14c10d-0dab-4b9c-85ec-e0ee25cd0db8@kernel.org>
 <CAEvNRgHqJGwmAfS8TuGBbUoQehpqY9GdtjUS=+Hc1ViK79RL4w@mail.gmail.com>
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
In-Reply-To: <CAEvNRgHqJGwmAfS8TuGBbUoQehpqY9GdtjUS=+Hc1ViK79RL4w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.82.30]
X-ClientProxiedBy: EX19D004EUA003.ant.amazon.com (10.252.50.230) To
 EX19D027UEC003.ant.amazon.com (10.252.137.250)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6D34A180003
X-Stat-Signature: 19n6aujc1hy3h15shyzbw1d915oy9uot
X-Rspam-User: 
X-HE-Tag: 1775834865-787528
X-HE-Meta: U2FsdGVkX19sTI0qo61falfeLu0lAXGnepk6bHMlbpoZhDYQ6DqVPMIsfHAQqOQggouRA2kiTOPqYMsAPWyLto4hswNg8msq9EXW46fhbakw/x9gRyc5Ao+Z1KppGaovHEaIPPHZ+Yx3uQS9Qnh3ZJJXJkyYO5hv+TirWjaKFRvMD5ZGrH0oeeXtLDLVYBHmZFEIJksL05Me+Bl0ipXL/+XKoaxNbTVzMt4FA+2SgGGgFwbjssh4G8obhAK7yFvYgLFxLl6i7EjpG5yr3s82SVJfE5vr2puJ49pRwA2QY6GDY8P4inGqvM7UhZdSR5lEiYNZUVHEKAhOu6gScWMaQKvfg5ciAumsFfE0ZzkOwSz2uvVLdS72HjskErrLk8Kc71ehF10jg5NPoUXQ6q0zW0QH11ctb03z8nWskhc0OSrVGSR4Ld8edHmCm+xdZM57FSnrtOVat6bhL3e5aMzuecM9T5Yp7uRg+sS7tyYEdL7xT933GCy2e//bv5554BCPGubHVnfSAKYm/fNeR+h0D0J9Q0v0o5cD4aFDpNdf7oLcQ0gwPsSXpcnSSQFoq6YG5XVKgkoMZSmyAFQgi99rwVAEuj0fa8qZg+/eCdby89FudpaZfKuOWVP1RPm2ZomcTTYucU2oY9QzpJPOpvl4GsTbkXy3tcRLfeaPuPENLlyhWomD9aaDuqEm5L0IRoPReXkOEG+DYZhb55sJ+IJE6B4lxDKZ5JmphRepgOEOnjxsnfOFQAmtLixcX9YoxIkxARQlesJsB2+34XW61QvQStBA1zg0mOeiFLNGk5aEuZbbkIk29IiYozv/21Aoadrpzt/YeRugtxC0lrvx/r8FyrW86VjyPm8ZnIu+VGITWZ69NaAmJledXbki2Gv7QT1P52zfMKOZSn7q+//5Ra5wHzRMHAgfa5uDWdjtY71eq5UXDFTzDgTd5uom7E4DkzNUWVl49YNrkARFyscOTl+
 3D0C5HCS
 5BdJFyX1wvh9Pcmtnh9QBX/+4vwQS+r5N7dfr3xVnFXknU8Btck/AKNkG0FJwmvRxc6e2v183UcTKupX/bak22Jj8KzOdnEK5MnxeX7whIGZNTWFiZ0rhTrvftRLY7Qr7Rc87/ttmHWuNtC6afSjV88E2H3tTDaUB8RB8Zjm9wBfcMund9kvKWZYOSVJIlmhZfIRUcOSPh5DiRdtJX1G6OHjWg3R3iZqgLKEcf6BgW2JByTkFPfhHwKEdaG24yq1Ky86H27CaJBd8DLFVC13UzZTga6w9Y53AvxI1GxXGJyqTZNcuL9fxvjs1hXuqko1jRmMAE/dqTrE6KHX2dCj1OY0I59MOU3d0nnKKiq1Qsg6tL++0y4UxRDSd/HaWEwfPC23AejSgtsmuXDFD7zPIBUwyz3/aN/z3RAFzA5cmyh2Zdw9X/HjWL4YsR27V5UeZROtAkDgVeaHsRhrX9yQ1pb39ehOk/VSjUog57QVU2u0MqTzVyxfRuZpsoAQhDW+Gnig8+6Dyp2+Ayk4lBbALNpIo/TsoEBKXOrbtAR9FrJTm5jBdH3wDHYQACdMOtrL8AF4UF9nBGXtuOJ03mBFYZBV8JoYBxQbOO++9HFaRnsSpzqZoBrubhMcevhiZ4vOQGZRGPin+dGfxFF+BaN1e+dBxMfQKjAkfvCrUHDDpyC9DRNJgh2meBz82W1yqgllk5FIfkEheB5XK/eVgRSUJThpJp6QXs2rKx3BMwc9eRnEhbQPmPeV3nODhlgBN5/qAnl07oSAbX1z5P0RzJwhX3mj58c5tct2WOJULGGDf+2ccW8mctbqdEL5/OV5IRHr2hgW9w98zdru5VgL5TE+hLot6GGgmD48cvFJ/OZ5NgvNOprGzM0dCg+rPVMjkjmjAhe7jW9gadlhigBfu1/UKnrjeBGlnZkz74i4YDdteH6HQ1JJ2ery4+1sP+ZFCdNas/5JWE+/1pqXLR+F+AARDxP8ZEoCm
 YZhEXg/a
 V7u627NrNoqROMtRV4gs+1V8VhJbEdk6FqR/onk7c7lBzPrZaR4QxZ0/EgpC8Te9zU/LvCGjz3DInw8IlA/+Sw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 23/03/2026 20:22, Ackerley Tng wrote:
> "David Hildenbrand (Arm)" <david@kernel.org> writes:
> 
>> On 3/17/26 15:11, Kalyazin, Nikita wrote:
>>> From: Nikita Kalyazin <kalyazin@amazon.com>
>>>
>>> Move the check for pinning closer to where the result is used.
>>> No functional changes.
>>>
>>> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
>>> ---
>>>   mm/gup.c | 23 ++++++++++++-----------
>>>   1 file changed, 12 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/mm/gup.c b/mm/gup.c
>>> index 5856d35be385..869d79c8daa4 100644
>>> --- a/mm/gup.c
>>> +++ b/mm/gup.c
>>> @@ -2737,18 +2737,9 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
>>>    */
>>>   static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>>>   {
>>> -    bool reject_file_backed = false;
>>>       struct address_space *mapping;
>>>       unsigned long mapping_flags;
>>>
>>> -    /*
>>> -     * If we aren't pinning then no problematic write can occur. A long term
>>> -     * pin is the most egregious case so this is the one we disallow.
>>> -     */
>>> -    if ((flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) ==
>>> -        (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE))
>>> -            reject_file_backed = true;
>>> -
>>>       /* We hold a folio reference, so we can safely access folio fields. */
>>>       if (WARN_ON_ONCE(folio_test_slab(folio)))
>>>               return false;
>>> @@ -2793,8 +2784,18 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>>>        */
>>>       if (secretmem_mapping(mapping))
>>>               return false;
>>> -    /* The only remaining allowed file system is shmem. */
>>> -    return !reject_file_backed || shmem_mapping(mapping);
>>> +
>>> +    /*
>>> +     * If we aren't pinning then no problematic write can occur. A writable
>>> +     * long term pin is the most egregious case, so this is the one we
>>> +     * allow only for ...
>>> +     */
>>> +    if ((flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) !=
>>> +        (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE))
>>> +            return true;
>>> +
>>> +    /* ... hugetlb (which we allowed above already) and shared memory. */
>>> +    return shmem_mapping(mapping);
>>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>>
>> I'm wondering if it would be a good idea to check for a hugetlb mapping
>> here instead of having the folio_test_hugetlb() check above.
>>
> 
> I think it's nice that hugetlb folios are determined immediately to be
> eligible for GUP-fast regardless of whether the folio is file-backed or
> not.

Ok, I'll leave it as is for now.

> 
>> Something to ponder about :)
>>
>> --
>> Cheers,
>>
>> David


