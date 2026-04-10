Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87E6FF459F3
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 15:27:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3DC36B00BF; Fri, 10 Apr 2026 11:27:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F15856B00C0; Fri, 10 Apr 2026 11:27:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E042E6B00C1; Fri, 10 Apr 2026 11:27:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D09E26B00BF
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:27:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 83B5813AA51
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:27:29 +0000 (UTC)
X-FDA: 84643025418.25.1A78D47
Received: from iad-out-005.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-005.esa.us-east-1.outbound.mail-perimeter.amazon.com [3.211.80.218])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3624818000D
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:27:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="My+gKh/W";
	spf=pass (imf06.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 3.211.80.218 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775834847;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rovGhSsMqDjdKRria4qsooPUUeVYimq/a+x4dfkE5PU=;
	b=BYegY712YYf96JYsRyyYhRMNrJQviWw89RlLB2MnyEIxYpM2W0Lm/zmRUB+tS+CYM79XvP
	3Ohd0RaukzS2b1MeNAuihyBnPuNL50KxNtrzIcFaESUsE7GFPuPE+MxhkmE4dFHBcFRYOa
	p5vbZ9Z1ZqWuYr48jawzP8CC3Tm/a8g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="My+gKh/W";
	spf=pass (imf06.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 3.211.80.218 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775834847; a=rsa-sha256;
	cv=none;
	b=XEvEseQg/aC8uYrvmcfPzB/Najk+QPpcDiAg4/sU8DDpIVWhamOdiJNMIpXGI5xNvGiget
	Yd6CkdPsSFKkd0xC+n0rnqVuLC+7DR274+4oovmU4bOKgf6xUyEGhRky5NC5fizXOZVpJh
	WHDKdU78/WcDj+uXUWMAFmOsuZBu9Z8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1775834847; x=1807370847;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=rovGhSsMqDjdKRria4qsooPUUeVYimq/a+x4dfkE5PU=;
  b=My+gKh/W9vydsRad2QU1Hm+zad3YSwMn1KMiAmuVgaeNHOMTobjhLFjY
   rzeZkcNE+OxkUlGbJBOiKHeiv1iDdjkvxIeLEixvAyHDVCbYKDWfqwV3N
   yCkRqhv0DtK2IFHfbe4UTQid/SDi2lVj99ppKHW3IMj3A6q+EztgwQCZS
   +GUocFZkL5Rm1Y/S0lSI0CtxpW9DiavEqM/Uyq2qJCTqwsEqBKQtnsxZv
   htWJwvyQ5NjXo/+1nkReqSpKiPd+d5lgJTvsKj1miH0ZlsTco79g4BTOW
   Mj7inLu9C1r9OJh+W4RkzWZZ4OFNLK269W36/lTe7blnpjbeK5/L90mRH
   w==;
X-CSE-ConnectionGUID: 2g/AnlwpR3uYQPrfjosQTg==
X-CSE-MsgGUID: Qj5tzU7pQg+kFw9g6MP9xA==
X-IronPort-AV: E=Sophos;i="6.23,171,1770595200"; 
   d="scan'208";a="15966566"
Received: from ip-10-4-22-235.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.22.235])
  by internal-iad-out-005.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 15:27:23 +0000
Received: from EX19MTAUEA001.ant.amazon.com [72.21.196.67:10936]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.46.155:2525] with esmtp (Farcaster)
 id 0adabb76-9e17-4c0c-bcfb-c40d0e8bf47b; Fri, 10 Apr 2026 15:27:22 +0000 (UTC)
X-Farcaster-Flow-ID: 0adabb76-9e17-4c0c-bcfb-c40d0e8bf47b
Received: from EX19D027UEC003.ant.amazon.com (10.252.137.250) by
 EX19MTAUEA001.ant.amazon.com (10.252.134.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 15:27:22 +0000
Received: from [192.168.12.97] (10.106.82.30) by EX19D027UEC003.ant.amazon.com
 (10.252.137.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Fri, 10 Apr 2026
 15:27:09 +0000
Message-ID: <a26825ab-0c80-40a0-883b-6e6ef8b7b6a6@amazon.com>
Date: Fri, 10 Apr 2026 16:27:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v11 04/16] mm/gup: drop secretmem optimization from
 gup_fast_folio_allowed
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Kalyazin, Nikita"
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
	"ackerleytng@google.com" <ackerleytng@google.com>, "yosry@kernel.org"
	<yosry@kernel.org>, "ajones@ventanamicro.com" <ajones@ventanamicro.com>,
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "tabba@google.com"
	<tabba@google.com>, "prsampat@amd.com" <prsampat@amd.com>,
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
	"Manwaring, Derek" <derekmn@amazon.com>, Vlastimil Babka <vbabka@suse.cz>,
	Dan Williams <dan.j.williams@intel.com>, Alistair Popple <apopple@nvidia.com>
References: <20260317141031.514-1-kalyazin@amazon.com>
 <20260317141031.514-5-kalyazin@amazon.com>
 <76f14d3e-c8fb-4380-9d12-2375f199b53f@kernel.org>
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
In-Reply-To: <76f14d3e-c8fb-4380-9d12-2375f199b53f@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.82.30]
X-ClientProxiedBy: EX19D006EUA001.ant.amazon.com (10.252.50.148) To
 EX19D027UEC003.ant.amazon.com (10.252.137.250)
X-Rspam-User: 
X-Rspamd-Queue-Id: 3624818000D
X-Stat-Signature: 38r5z8ub5f6cpzu37b58jizhbqnzqu4t
X-Rspamd-Server: rspam06
X-HE-Tag: 1775834847-478482
X-HE-Meta: U2FsdGVkX19ODEkJulb+1YvfXAIiPf+6S/kKNazSez/VMccII19tATZvph3v8WZ7lV+NednWW4KuwSCRdyp3vaUpsX3UoukHt4iky39WoydyY81lcQNM5CSglk6jUu5Sm0rpXxBhPzJnV8QsCdm5HNAf9PpUultkQu0SNejpE3XKTL+kZjFYmtY/WcM32TFwylpYKKoY02UAu8eAbSTB0QNTWPpy8Vg2wmrq43wa1f0cCFr7tyUnbhxtPwxeXo1SwldVtfKSTjFeC+a46kjgrs3ewRG4tde/g1YXH7XvCRCYFGy16cmvDj7fwN/3cJeppnnsc2wuvra3o91H3jGDhM7HrdUkfVX30Ta5B6SP2Kn23WZOFJZLpR4C5ijTrmUf6YSKWdVE6zi9TzwbaJBxUdHeQXWQW/1vhp15UcWxCSYhxyrIQ6lr8LHn0XQhkCq2TnuO7UIThIsZwgeQJVhu6MdiqSO3uMrrVNOzgCO0nL1vn1SEf+167ko/v9bLdofAittS2WqIDkam+PN3hDnRKOBSRNLS+UOYR4VSs5bZf/56KQ+naH7h9GgjOzgthBsyBFC/c/6sVSz/SMf7UNqqvHLgE/8FQdBmwRfMo/12fkkTwZgujkfAuLfTp19wlvJt5FnEGdzLnekDGDtGPyvVrX7w++bnPYNZ5/IF5E9vFJUABc4MyxN+ChwvUaWKHuyzhz6yU030Uxd05midR/gVoqIkq/NpnV3cnc86mENpLb6yWAay94705TB8lrlgt3HQRhT7fSEHMdgh+JQ+NjKkzBaN2WRAdWqLdrb94oy9MXuo7Ksh34th2bSV7Dl9URs+xRktJf6FhDr5o4avTD9wfQil2bOZlJifA9xq+yx1tDQycHQQgNS0YOGve70R28sr0VwMALOwyZFyHsRJJ5InNwhHI/m01XiabI8uv6J2+84jhOwrh/VHkYL4Rmd2U4671NqaUWOl1lywIzbuS8h
 rEekdziX
 mgEB8Uq+oGw9m5sFcbJqKNmHUjG7z+Ik850GuyDq29NNErVUBC4QsY5pskjRRV8gLX/gP6h+TlZ3Lsu2imaDpuksGHzTHHA0h+lQ1u73z60dIy1QSAmPCepKuBCnKaX+2DJF1Aoy9Lxc3BrjSWIZ+tRH1dNvzYNmndIGnRoJkwGAN60lTZmDLK8UNnIlVx7vyhRk0Cf6qTPHr1jgbx/fzH+AZbhrbBHoyBG7gFwMaWroxsBs5upp2O/J0ouQAUyMlg6qvymnP9gMQ8r+sUN3HNocvKAQ+ATAS+H6srIFgBmHYp8p0Z+cD+Mv266ckMOJ66Nc8wTZ8jwNdbnWl6tSG+b9UmgcdJINlkpNkxUfSbFvNikF53ZGfeZxKfanfQmnMkCGHfgeuphXNLP3WcUwwfK2g59PthCBeYkOVcqHeosU8JaSroMIrSomdWqYeSYsI7yau9AxtCduYaiHXRabWYrGGNjVVZrX8rh9hav4lut28UKWtmG5kUXwFkCYtVE/W+xc7wjCExxoSt3LTIE+tnXDdmArOiShav8A57D5cVbDccV4Wmvo7EBHwPJwDfdfRioRALuvq/6c1Aq19UhfMw95aoXlm1H6Z+ZY9C9sE70rhggd9k7WSK8jvsTXiEo7iAKQJPEuWHazyDixjyFESWWpqYjdXyR0FJRPtwONsa3jDopJHd4J9cCue/h7K3OhZfLY8ZUv/7aRSCyxJaDIVsEGOxUcMuVuCdadwl0BW3kRh+E++9/V2XJKN7Fq+yZDR9Dg8F5BXnt84QX8/3xnAqEZVf7eiUfvk5fq5fw3O0j7i8U7BBTKAVIimvRkv+gdR4jEe+t/SmRZyFrYp6kk9i4grOG/AY/h6KO3mEXg5DcCUA5GMV5R5TT8743b4uYxKa7NmXA7k0aB3CyqKUMH7snu7RWVtRWzchuxpNEYTd9vgzcR6LuCwsm/0d4wOI5tXI0lmRETOZSDiM9obclJZJVaoJkuB
 wJ9QvSrw
 KyAMim/eiUmhQJCkr5cKPM5YBLbj4clxMUCCfb1va3GclEHDDhkLFSZWA5mvMxQqFZp25oRzINj8ul81klbdWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 23/03/2026 18:31, David Hildenbrand (Arm) wrote:
> On 3/17/26 15:11, Kalyazin, Nikita wrote:
>> From: Patrick Roy <patrick.roy@linux.dev>
>>
>> This drops an optimization in gup_fast_folio_allowed() where
>> secretmem_mapping() was only called if CONFIG_SECRETMEM=y. secretmem is
>> enabled by default since commit b758fe6df50d ("mm/secretmem: make it on
>> by default"), so the secretmem check did not actually end up elided in
>> most cases anymore anyway.
>>
>> This is in preparation of the generalization of handling mappings where
>> direct map entries of folios are set to not present.  Currently,
>> mappings that match this description are secretmem mappings
>> (memfd_secret()).  Later, some guest_memfd configurations will also fall
>> into this category.
>>
>> Signed-off-by: Patrick Roy <patrick.roy@linux.dev>
>> Acked-by: Vlastimil Babka <vbabka@suse.cz>
>> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
>> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
>> ---
>>   mm/gup.c | 11 +----------
>>   1 file changed, 1 insertion(+), 10 deletions(-)
>>
>> diff --git a/mm/gup.c b/mm/gup.c
>> index 8e7dc2c6ee73..5856d35be385 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -2739,7 +2739,6 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>>   {
>>        bool reject_file_backed = false;
>>        struct address_space *mapping;
>> -     bool check_secretmem = false;
>>        unsigned long mapping_flags;
>>
>>        /*
>> @@ -2751,14 +2750,6 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>>                reject_file_backed = true;
>>
>>        /* We hold a folio reference, so we can safely access folio fields. */
>> -
>> -     /* secretmem folios are always order-0 folios. */
>> -     if (IS_ENABLED(CONFIG_SECRETMEM) && !folio_test_large(folio))
>> -             check_secretmem = true;
>> -
>> -     if (!reject_file_backed && !check_secretmem)
>> -             return true;
>> -
> 
> The AI review says that this will force all small folios through the
> mapping check (which we obviously need later :) ).
> 
> It brings up two cases where page->mapping is not set up:
> 
> 1) ZONE_DEVICE pages (like Device DAX and PCI P2PDMA)
> 
> 2) large shmem folios in the swap cache
> 
> 
> 2) doesn't make sense, because the folio cannot be mapped in user space
> when that happens.
> 
> I am also skeptical about 1), especially as large folios are also
> supported for device dax and would be problematic here.
> __dev_dax_pte_fault() clearly sets folio->mapping through dax_set_mapping().
> 
> 
> If 1) is ever a case we could allow them by checking for
> folio_is_zone_device(). But I am not sure if that is really required.
> Sounds weird.

I went ahead and added a check for folio_is_zone_device().

> 
> 
> --
> Cheers,
> 
> David


