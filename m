Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43B9BF459F5
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 15:27:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF7C36B00BE; Fri, 10 Apr 2026 11:27:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACF376B00BF; Fri, 10 Apr 2026 11:27:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 997766B00C0; Fri, 10 Apr 2026 11:27:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8DA926B00BE
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:27:07 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 35366140345
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:27:07 +0000 (UTC)
X-FDA: 84643024494.26.E951FC1
Received: from iad-out-007.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-007.esa.us-east-1.outbound.mail-perimeter.amazon.com [3.221.209.22])
	by imf12.hostedemail.com (Postfix) with ESMTP id E25B840008
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:27:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="A/ZYTMV7";
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf12.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 3.221.209.22 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775834825; a=rsa-sha256;
	cv=none;
	b=RBjHUXO7mH/AOc2pRD3O8Cv6x9IuzA7WFGTnss0OpgSEYDW+FHZ/cnmLLU8d1C/YnJZE4U
	1nm0FmJxMPj3Ftd/nDfpqhbzd3i2VndRppWWjxkprfVoBWLhpiP7r66dCvq/ijIA616wVw
	kQ3r5ITgEuAQ1k5wRYMBSQAOKN3jvVo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="A/ZYTMV7";
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf12.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 3.221.209.22 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775834825;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DewD7DK1ob/bc268SFd2/qF7WsGADICns3g/XEuN0nA=;
	b=2jZvGOw7RRGer9vgj6abrjgTv7IJLAG8gTYh/gZLeotGrHo1UJlFXitvBEORj5+92ERo7A
	tDbxDzMopXhzGDYsJDw/6fDhxDlytNdFIM80n6OGk0BoUra+1On3/OrXnqzI5mKEjlfGhT
	e1rQh6/MhwkzcY9vFuPAIhHp+2yqg+o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1775834824; x=1807370824;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=DewD7DK1ob/bc268SFd2/qF7WsGADICns3g/XEuN0nA=;
  b=A/ZYTMV7Zgk2rq3Fm2pGZz56m12bqJZiBLpnu5da9SoyjD0SKaAbMbmZ
   fYx6/DqmMCYcY8QyiLxK8s2JASPZdaX6rlL1AAV3lzlpFGRwp3izDleFC
   7euykBdZlWfy/BVIQIncGykZI6LvmzLlmfl+YwaBJlxVyJikl4CKKmRPi
   962d7YBrcZnJazxme5DEE6at4zwP474DnWl8iwlTytzMOBUF+iMbhVVrk
   WZcjozT6/WaxPZl8VWhPzWzVPBv5FU4v9h5EEtmo8U7sbCqmWlqGhL+Cu
   Rk1UdC5KdnuGxMIxbCfhO3+5eoKS8jGvCEwWrVjmReklqLywc/+OMgeJZ
   Q==;
X-CSE-ConnectionGUID: gI4/W2RwTOG1O7PgCTUhgw==
X-CSE-MsgGUID: BLc77vy4SnqTbMYl2NOT7w==
X-IronPort-AV: E=Sophos;i="6.23,171,1770595200"; 
   d="scan'208";a="15990465"
Received: from ip-10-4-3-150.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.3.150])
  by internal-iad-out-007.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 15:27:04 +0000
Received: from EX19MTAUEA002.ant.amazon.com [52.94.133.129:20620]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.46.155:2525] with esmtp (Farcaster)
 id a191a26b-32aa-4efa-af7e-55c66dfde52b; Fri, 10 Apr 2026 15:27:03 +0000 (UTC)
X-Farcaster-Flow-ID: a191a26b-32aa-4efa-af7e-55c66dfde52b
Received: from EX19D027UEC003.ant.amazon.com (10.252.137.250) by
 EX19MTAUEA002.ant.amazon.com (10.252.134.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 15:26:58 +0000
Received: from [192.168.12.97] (10.106.82.30) by EX19D027UEC003.ant.amazon.com
 (10.252.137.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Fri, 10 Apr 2026
 15:26:45 +0000
Message-ID: <453fb48d-0f68-4947-bf9a-c2c9b017162d@amazon.com>
Date: Fri, 10 Apr 2026 16:26:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v11 03/16] mm/secretmem: make use of folio_{zap,
 restore}_direct_map
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
 <20260317141031.514-4-kalyazin@amazon.com>
 <CAEvNRgEBdi49ZkfGo0xmM+J1yzKOzfT2ThAXEN=S0j7vC7Fu3w@mail.gmail.com>
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
In-Reply-To: <CAEvNRgEBdi49ZkfGo0xmM+J1yzKOzfT2ThAXEN=S0j7vC7Fu3w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.82.30]
X-ClientProxiedBy: EX19D005EUB004.ant.amazon.com (10.252.51.126) To
 EX19D027UEC003.ant.amazon.com (10.252.137.250)
X-Rspamd-Queue-Id: E25B840008
X-Stat-Signature: gigqx88t1cz7wwsdxp5s5zo69i4uacp5
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775834824-381065
X-HE-Meta: U2FsdGVkX1+qkFbJ7/cFXL5GmAEM27RsiyOTmckh0+LN0mUqasxF5ppiMfuNskFe0YHNOXbozdoIrhOVdJ+prYDdNWm83R0Wh7TFCzzh0Dgfov7U3/utVekkGZB3z7VfYCkEDIfoNil7e3iiu9ff3zkz76pxLbP0R5zAiFMJSN2WeuhQRNYjg6vSNWwJiPEJOFIsLEf5KAsHibAb+vDLrfU33RZWRh3ZwC4vcK8EiOSgUGVaWjb8PsXQdOIHujUOxvfstLDW7zdnhT9gyCNXApxNCkHX3obqNCnvLJlMkiSOIKzYkfdalpFTSZZBr2yCp9Hy7q/VVZdZCYxTvW/dwXEHG6PR1C5TL/5O/d+gGXaVAWBNb/we0wcpe0Ej0wvfsfKvrkPkqV6d4B7m++n6/bkT9pZ8ybNluIi2qsHZQ4+qfM/1f7vls6wPVG3PKwh6Q7bBb9ELOTLf2jAHS+4FKj6CfuAV0zYTIlh2eda54JUr46LsOMQCMVP5ArEqmfT6AKWqfCAy3wBLYKcZo7LiN3mBqlPg0t2dFWOxCb8QhZjIFJtwEAgKHOWjP0eLaqBxzUSh+KxP0yttFRJzVpvkviD+pkpVDZQq90wfPEzOQorQaXpisuXHUyBAktoSqCZ6WZEeOFedpE96j1sppM80rN52muYRzpr3MeKt8S0frmosqpLWQaf0VXi/iAblFQLeLNV5OWrQp74gQEYwY+d+OHhquI7g2Mjiv+YPfX6Esp4KL1uGei3hesib7IRcCpOpOPcjUTFGaFPC15hV/lw4+0vGwx2bVRnlmJpQIuxR55axUisZaXq+4sAFmlgamw6MYClEbgrBHcKfib26tq6xP5VLu5bDGNJwyiradfVCoYOXyAVafYVmvOIuVUzEsGWzUI3SX8CyEoNCWZEypZstGeOOViWQWLDGGSyxwHPLYu3UVFotTHVuUVkcQ8bd3wGSLuw+90HCyGETLM0eJiw
 qudx9SMW
 4/9V2BrEYbEvXHYp76uZXfUu8vkK+9Sh6cirtmHxKqmXPTvLTB11ylbz2Ihp+6TO7kbBNbbhOmBI10qOIhFzXgmxciPP4LSU0rMpd2u+hEpB+YiVt4VexOvS9e/lmT+qN2mSyzKlmkA+cAPpNFS5a3q3bp9ZzY7wlGmL0JnLEWBEfUjSQnK4a3+FtDK2HenFlfqvGGepNcI7O7WTyqJbda7SsTpwmFrpQTfozCnxEi30Rwez0qtfuCKV8S39HOVk7QlCf8thOyyYJiR/CCO65rAzvlS+7A+RQTS/U1zNtdCisWw8RBgkuStQkY7Z65QcsPOP/CCOu1y/XM/vH8zFCRNB2WyXg5c4AAeq9gdP47+crIaLwBi+DU+GmYY87fvcRf/25u5pwQw9xUPOFE3dJq6F6U8ccVuxOeD0jNVrCgfm0MOmDNf4ICvTMGOn1OPJaFUzIXHo6iDfyrTjAQZI2oG9Agp1/ZWn4aJ+zIMi2hiOapqAs5xdKu6VtKJ7YpXpZhya+YqzDD4dp3lFWotfaRUVp2Nw4fHtBN/a8t/jwWZRnUTCmoDIJZ11/4W5jb8OjikOPbYDskPNy9qarPJQb3ZHgKbH6muhD2ib3iXb6sjeBf86b+zdkIfbMM2ZPa54SsFYcTvgyNzfqnejDhTKa1OcsmVJSt60N2HyiPAAtA11jXiLr/KtkTE3tjSPaYaXkPYq5LXsLi1we2VzxwG+iI1r1dMz1eeFbNVInHUl2gMvXbzSGmWBEEA1oZQ75MueJ7O53OHeERMo6IeuuzlTGjeUrkOojfc/IW0ofmlTSIW7g5qop2TlKhiCqCqOsfO3LMlyo5qrj0YjrYbPqXBGvVITKj6I2D3m8T4dkXEnwAXJi8cezGdJBa/k1G2d2KSZuHel2LyQJcylJnsrZWnJBP6MRU/UJ/V29lbqdwkdSnRgkJ0bnlfKdV4LBoCtHVCvCtole8GhUo2aPCFshXPgrdkXlIi0m
 o+1fzR6B
 OsY1qLQZU8tqMXrZzDfMiP9csyXHQKVJlC3F7tn0pdYHc+Ys5CpgVOEaJmu9lYNobVb0gmJFAsYmrw39fzsTWqWatj8/Wo+WQe/s4ztGhho=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 23/03/2026 18:46, Ackerley Tng wrote:
> "Kalyazin, Nikita" <kalyazin@amazon.co.uk> writes:
> 
>> From: Nikita Kalyazin <kalyazin@amazon.com>
>>
>> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
>> ---
>>   mm/secretmem.c | 8 ++------
>>   1 file changed, 2 insertions(+), 6 deletions(-)
>>
>> diff --git a/mm/secretmem.c b/mm/secretmem.c
>> index fd29b33c6764..27b176af8fc4 100644
>> --- a/mm/secretmem.c
>> +++ b/mm/secretmem.c
>> @@ -53,7 +53,6 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
>>        struct inode *inode = file_inode(vmf->vma->vm_file);
>>        pgoff_t offset = vmf->pgoff;
>>        gfp_t gfp = vmf->gfp_mask;
>> -     unsigned long addr;
>>        struct folio *folio;
>>        vm_fault_t ret;
>>        int err;
>> @@ -72,7 +71,7 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
>>                        goto out;
>>                }
>>
>> -             err = set_direct_map_invalid_noflush(folio_address(folio));
>> +             err = folio_zap_direct_map(folio);
>>                if (err) {
>>                        folio_put(folio);
>>                        ret = vmf_error(err);
>> @@ -87,7 +86,7 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
>>                         * already happened when we marked the page invalid
>>                         * which guarantees that this call won't fail
>>                         */
>> -                     set_direct_map_default_noflush(folio_address(folio));
>> +                     folio_restore_direct_map(folio);
>>                        folio_put(folio);
>>                        if (err == -EEXIST)
>>                                goto retry;
>> @@ -95,9 +94,6 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
>>                        ret = vmf_error(err);
>>                        goto out;
>>                }
>> -
>> -             addr = (unsigned long)folio_address(folio);
>> -             flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
>>        }
>>
>>        vmf->page = folio_file_page(folio, vmf->pgoff);
>> --
>> 2.50.1
> 
> Reviewed-by: Ackerley Tng <ackerleytng@google.com>

Thank you.


