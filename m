Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D5B8D37E33
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 13:57:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5C236B00B6; Wed, 14 Jan 2026 08:57:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D33056B00B8; Wed, 14 Jan 2026 08:57:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEAAC6B00B9; Wed, 14 Jan 2026 08:57:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B0C846B00B6
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:57:17 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 65B121A0516
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:57:17 +0000 (UTC)
X-FDA: 84330721314.21.EC0D56D
Received: from fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com [35.158.23.94])
	by imf08.hostedemail.com (Postfix) with ESMTP id 088EB16000B
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:57:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Ei4qX3mg;
	spf=pass (imf08.hostedemail.com: domain of "prvs=4674f03ca=kalyazin@amazon.co.uk" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=4674f03ca=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768399035;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X0wS+NExQh+M8KgHpz2Gdy3x5KfpNxu9ZGrCLn5oS58=;
	b=aBTLmShplF4g+xe8CtBdmO341A1L2jVNpPj7A1AB4QvTrrYmYNvunGvgIaKup1fchEKLsT
	zkRpwPQP1ZkRAm0AI6dxThKw5MhYMun3mU7+KZkq096wIuTwl2LGoTsTzUonm5CNAV4Rkg
	mOB9Y7BzUv2fAcRJjgsXtnaz+nFuDMQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Ei4qX3mg;
	spf=pass (imf08.hostedemail.com: domain of "prvs=4674f03ca=kalyazin@amazon.co.uk" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=4674f03ca=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768399035; a=rsa-sha256;
	cv=none;
	b=ASHHpPEL2MAQxqmLnIy+o2VomlBMSH0diPKYyLNwv4KCcuaxZVa0Jwjo2DpcjgP4T90JjF
	9DvkRUQcwF5LJGYYdURyaTNGp/LYohVwnRrW7us8pKnGhXC4WGY/Wi6Uq+PBIgqYOp7qSN
	VhnPEzbsxZhjVOXXgM2KsC/s8B6xs0E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1768399035; x=1799935035;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=X0wS+NExQh+M8KgHpz2Gdy3x5KfpNxu9ZGrCLn5oS58=;
  b=Ei4qX3mgd81vByPvrJVF8LH+edpdxnl0uRQN3FXC0J+hSJbw+GADzSyy
   hNbftZ4qhXGm2QC1dX7RtUFhGKWsc3tcsLUm60RYoEFnhnqm0H7tJ4diI
   o59VkTvIMMvoEWNzZ7rOUmUccCFxkBRFogjw8HDWz/okw1jnPcFRmjDOx
   q5ORCa8ZiBB71e2ByYqIGNRQa2DQkMvqCcKVCxa69kByNVwIZTbOYrxBY
   85NmJOn+r1NzWVMPNFwoPOth47X7HsLYgYBLKFWMhyQ8ZYJD6mW91PDzC
   yGx562qM+wtpBzEHKNLTpw7TbaWIWbhWFxsb+G81BwvLqHWzvFrUUcs3z
   g==;
X-CSE-ConnectionGUID: iO8DhPxBRPuaaivOKTdJYg==
X-CSE-MsgGUID: Xpamj4VgTXmh9bqFPpAB6A==
X-IronPort-AV: E=Sophos;i="6.21,225,1763424000"; 
   d="scan'208";a="7900619"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 13:57:13 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:26534]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.30.60:2525] with esmtp (Farcaster)
 id fbe8cebb-b0d5-489e-8423-36b49c4d2af0; Wed, 14 Jan 2026 13:57:13 +0000 (UTC)
X-Farcaster-Flow-ID: fbe8cebb-b0d5-489e-8423-36b49c4d2af0
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Wed, 14 Jan 2026 13:57:12 +0000
Received: from [192.168.15.25] (10.106.82.12) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35; Wed, 14 Jan 2026
 13:57:08 +0000
Message-ID: <e402f9b9-84a1-4234-8caf-bb9f2a1e9a2f@amazon.com>
Date: Wed, 14 Jan 2026 13:57:08 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v8 01/13] x86: export set_direct_map_valid_noflush to KVM
 module
To: Dave Hansen <dave.hansen@intel.com>, "Kalyazin, Nikita"
	<kalyazin@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "bpf@vger.kernel.org"
	<bpf@vger.kernel.org>, "linux-kselftest@vger.kernel.org"
	<linux-kselftest@vger.kernel.org>
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
	"riel@surriel.com" <riel@surriel.com>, "baohua@kernel.org"
	<baohua@kernel.org>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"jgross@suse.com" <jgross@suse.com>, "yu-cheng.yu@intel.com"
	<yu-cheng.yu@intel.com>, "kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com"
	<coxu@redhat.com>, "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "maobibo@loongson.cn"
	<maobibo@loongson.cn>, "prsampat@amd.com" <prsampat@amd.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "isaku.yamahata@intel.com"
	<isaku.yamahata@intel.com>, "jmattson@google.com" <jmattson@google.com>,
	"jthoughton@google.com" <jthoughton@google.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "vannapurve@google.com"
	<vannapurve@google.com>, "jackmanb@google.com" <jackmanb@google.com>,
	"aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, "patrick.roy@linux.dev"
	<patrick.roy@linux.dev>, "Thomson, Jack" <jackabt@amazon.co.uk>, "Itazuri,
 Takahiro" <itazur@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>,
	"Cali, Marco" <xmarcalx@amazon.co.uk>
References: <20251205165743.9341-1-kalyazin@amazon.com>
 <20251205165743.9341-2-kalyazin@amazon.com>
 <9409531b-589b-4a54-b122-06a3cf0846f3@intel.com>
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
In-Reply-To: <9409531b-589b-4a54-b122-06a3cf0846f3@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.82.12]
X-ClientProxiedBy: EX19D006EUC001.ant.amazon.com (10.252.51.203) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspamd-Queue-Id: 088EB16000B
X-Stat-Signature: pxrfinjqhz7db5kn5g1m3r5tymu7i6ou
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768399034-839276
X-HE-Meta: U2FsdGVkX18h5mGMx11S3rXBC/fkZD3H3lITDlP0km4M1LHZuTste6yceXGaSUk+idptx4anzW0h/NrZRM+bxXQA4nneZiW0WV6Bh+HVCOjvtRHNrzs3i2GIK+SeYO1Jj7TGA7AGQlvqhkLRrB0gf/hbYw3ISEb1AkHmww+5/jBC5C8mOhLMJTdBPljTGIOHzBc1mxbZ3G+UV4LfskG2CCs93VpksHa2NYi6rBIJSfDSPtisRdohGSqTew3YqK3q4Q4k3RK6NsiUVSx/QIjAQhoKWhl+h/45LgfdBXh0XMbZdVFJPmzYn2Jxj158OovsEr0Ulb5iDctd3c/BfpNNBVZR0wNdVIm0Z/UgCtRIFhHhudB6JiJp3O+uJ65MB1XfbBRmcNSFpOLaq+/SdvAVa0erX3Z2mUzxUbbhbmG7EErWeSb9yEw+IHT7mcDZPiAkP5da7VDYHeDlHmhMcLC/qnoofclNfGPE+53pbYfYDiaEpDRIje9s2Kw/r9l+0iy6V5wDyPEA+ReEvRaUBzSCm1RQe2T5bXzetYA7kzdGy8ONwCy1XBkNlYR44QY02OWw/CpyLK+ShL43qykWVfYC3g2Nip+VYwydt441uUl4rGR1ebp/IBYqGKLqiZVg9AEHgYvTlh8DcGL/pckMGIvFYCszsmbNnxsJ+hSyXodS4eNym56ql1nuf4LEs4VF/xvES29qK3mhP+JCLf3t7rHLS83nVeuChqyg1ReRBBePHFDNCf+Gk1UtOLdXAY82x1u+9TOr/uNEvYs3DaNU3wwvoZJZ8SOKiRnLRwaQBnVsBOp7qRElMJciw71CE9t969phP7x4hXKwE7ZZdjQUUNgXPtJN4cBu10OmomtjE2fkYh3jtLYCD0f8Ni0PD7UqYsFgi9mo+Od46kz8iSK3FhrkkerACrkqPDfFO5zdeUo/47r4jiXkZ+0n2oB/vU4wvWwEn3RczP4dfmoKmi+wOh4
 pX8PSIIu
 4M0rXsGNm45YLyTxLaAxRZPUz+sxpQd78F8oLKAc2vYhXQjvPafM0UCYqWlCHYrpRCYOuv13fRSXCzHjSx3XuhGPafW2nTSTywWZ9SH19eCLbRmr0KaTPw82JcOlB3buP+TPHOV4UYMh4gZVSaoNXtKilr6NJg/j0SwQLU9wcgxUgASjP61LZrTjoyHE1qpVb/znUlESH37ICTiSxLar7tmQqS2tmPYhhQwEvz9QoXzpG2CyTA1pRTuA17kK2yfH/8XVN+H0Ebkp5lOESeT+bcAsDSdw0QtO6btoh6l2n1PIisBLSnDe6VynfOiNvvyuZtp51KWCEix+YitpLgZvLCQRttZ5WM6xq7SXNQb3sHdB/jDRbHETUek65FJNEE+aIH6/OqQYI8R+3Pqz++yPqYMyMnJ2Yc2ewef327L9UcrfVrmIcPbRUYJaGUgZusPV9HdoddwY2nITS9DzTV9L+4i6t78aApYs7DlF5qvbhkp+U+x2XfGoFzhwouSBvHYu+FsVaeZZqVWzVfKlMMyRv8UkOaueSe01tl4Oi9zwXFVUR8S5bh6J9cIdatKch18n1QipNG38amLa4lrZ0BUEmBMGnyJ/AfpciHYlcsvtxSaKkxue/LpnCBDCjH1MbNxlgKS8W5CG+gvtM9UWxMEAhXOs6H2nvEIL77mVmSdAK7RO+A+CrdVNXpYGUmfDNBnsctQ7kzZjcqKtL4ebOhg3xlqTLDAjGVbLTLIjZfe9GAaB8E844iUOXy+f1EAZMESA/RjYThrxXRgE+tDcn5b6HDNYZognilV64KpH1MjqSzFnb+DTxe/u62deBtocNDVbCYvKam2PRtYJovojB3l8oaRVs0EOkWSwoWTFKOl1e1dpgK29PUgqAQARXyWX1tRWCiQYaakgqTPQJVVTAqLc3XgEyw0/Kn7H5j4tfvi84ScBmmysZLPutRyZDcG2SNrbBq0JInvg10hKILFB3CYPeDhpK1/ky
 OQImTnl8
 KhHax1pSAjjpmTo5GYL/hmE0Ej5VQeht
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/12/2025 17:26, Dave Hansen wrote:
> On 12/5/25 08:57, Kalyazin, Nikita wrote:
> ...
>> +EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");
> 
> I think this export is a bad idea. The interface is abhorrent enough,
> but exporting it just invites abuse and bugs.
> 
> I think what this really needs is a pair of helpers that are just:
> 
>          folio_zap_direct_map()
> and
>          folio_restore_direct_map()
> 
> that take a folio. *Those* can get exported to modules and those should
> internally flush the TLB and not expect callers to do it.

Thanks, implemented in the v9.

