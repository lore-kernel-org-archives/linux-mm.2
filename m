Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92291C982E3
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 17:51:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2EB86B0089; Fri, 16 Jan 2026 12:51:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC5176B008A; Fri, 16 Jan 2026 12:51:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 979476B008C; Fri, 16 Jan 2026 12:51:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8427A6B0089
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 12:51:53 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B20B656EB4
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:51:52 +0000 (UTC)
X-FDA: 84338570064.21.35EB4B7
Received: from fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.74.81.189])
	by imf04.hostedemail.com (Postfix) with ESMTP id 471B340009
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:51:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=PRSNgHoh;
	spf=pass (imf04.hostedemail.com: domain of "prvs=469074ca4=kalyazin@amazon.co.uk" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=469074ca4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768585910;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n3dU03TxGYY3gXB5y1WjelwjMhwgBHF8SdzzakH2Vf0=;
	b=lIlU3exoiREFmireDkVkeuAtCWbtl038FunViY1bbJ3l0nDt0sWtWsMZrYbgUca76xo4gX
	q1DT9KGkQjZxWwok+e4+je9/IHGTibKWFD8aZoqb2yDa6bg08sLlLCchWMcUoXJOsVPzD3
	ua/eXvpNdhFtLjegK/aDwAEvoSDj610=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=PRSNgHoh;
	spf=pass (imf04.hostedemail.com: domain of "prvs=469074ca4=kalyazin@amazon.co.uk" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=469074ca4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768585910; a=rsa-sha256;
	cv=none;
	b=pg5Bl36irf4DLkqoQTanQa09tP3iax7mgD6yZLzhGnAfYj1yg3r28JsXbYvNWb1RpKjE90
	bLHPx3XG+n15H0mITLlatiHK83BsVY+BmjYN30k1JgVCdO59LQ83zB1eqmv4cgQq1Xnyus
	qS96rlH/FmDLhky0MD6G35InDOrYGko=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1768585910; x=1800121910;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=n3dU03TxGYY3gXB5y1WjelwjMhwgBHF8SdzzakH2Vf0=;
  b=PRSNgHohNhmMRJBylfOFrBfkpdzJ7mJ0WBRMuVYc7f4cV/m8uXbILM/h
   YKy5Qw67P6BUi/r5/cwVzcF5P/4Na4bRzw3uZhhGGm++Xsyq7CQ8IvDSR
   5IUG9fMWP/3AyPOujFkXTjLLu/BzOkqrOgq+PEIBlcWnTs+kkyxmqdgMY
   L9NXMFobsVbi9yNwNCqDCYHh3Zm3V3lEDgO9ta1yAh4ZHmf89ROEP5wFE
   l2OoIRfaOBEUOMC9MZ7Xht6kBfZjdYQzdb656P0Mne6gskZNR61sfzqki
   XurOLS2hkGKVcdF1Lthxou3drojQG2VklrsIFvzOqKwwSv2mEMRmZeaMB
   w==;
X-CSE-ConnectionGUID: 0QIKAWpmQ6KIzk2q7ONlfg==
X-CSE-MsgGUID: 557UGuZhT/aa8eVdXv+XUw==
X-IronPort-AV: E=Sophos;i="6.21,231,1763424000"; 
   d="scan'208";a="8036550"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 17:51:32 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.232:20138]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.45.189:2525] with esmtp (Farcaster)
 id 3df24bb3-7aa4-4217-abc1-e8fb9f5e98f8; Fri, 16 Jan 2026 17:51:32 +0000 (UTC)
X-Farcaster-Flow-ID: 3df24bb3-7aa4-4217-abc1-e8fb9f5e98f8
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Fri, 16 Jan 2026 17:51:30 +0000
Received: from [192.168.12.13] (10.106.82.9) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35; Fri, 16 Jan 2026
 17:51:25 +0000
Message-ID: <98b8ea1e-3bdd-4987-8acc-58112076d451@amazon.com>
Date: Fri, 16 Jan 2026 17:51:24 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from direct
 map
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kernel@xen0n.name"
	<kernel@xen0n.name>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "linux-s390@vger.kernel.org"
	<linux-s390@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"kalyazin@amazon.co.uk" <kalyazin@amazon.co.uk>, "kvmarm@lists.linux.dev"
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
	<ryan.roberts@arm.com>, "jolsa@kernel.org" <jolsa@kernel.org>,
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>,
	"jmattson@google.com" <jmattson@google.com>, "aneesh.kumar@kernel.org"
	<aneesh.kumar@kernel.org>, "luto@kernel.org" <luto@kernel.org>,
	"haoluo@google.com" <haoluo@google.com>, "patrick.roy@linux.dev"
	<patrick.roy@linux.dev>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "coxu@redhat.com" <coxu@redhat.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "hpa@zytor.com"
	<hpa@zytor.com>, "song@kernel.org" <song@kernel.org>, "oupton@kernel.org"
	<oupton@kernel.org>, "maobibo@loongson.cn" <maobibo@loongson.cn>,
	"peterz@infradead.org" <peterz@infradead.org>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "lorenzo.stoakes@oracle.com"
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
 <318407ba-ecb6-4691-8911-645fb8c20250@amazon.com>
 <c42cc00f3902673b1a964c3d098b8c3f236cf9a1.camel@intel.com>
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
In-Reply-To: <c42cc00f3902673b1a964c3d098b8c3f236cf9a1.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.82.9]
X-ClientProxiedBy: EX19D005EUA004.ant.amazon.com (10.252.50.241) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspamd-Queue-Id: 471B340009
X-Stat-Signature: uwwpoyn4cb6og8j7so89ar7ke4yomzkc
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768585910-488060
X-HE-Meta: U2FsdGVkX1/FEybEagXvUMx4/wVGfChZKtDmaTlhdAJtyGcIal12c3atIDzpzn8K9jAEwr/FxKp6vX0f+fX9qSh6VnVfGL3N5gRns0GhoQvYZyd5xvDGl8oL+Aqw9q8AEj3KXfABhLuKzOe1Ye2608dbVyiVnS9wVPIzE80K73gy81+UI7OMCKjuArCw9PyBntIEQNZllpXAX2zT6A89oQDEo7edtHCT84WCjkgGeJFzN/0zVymvjV1dK5opZ8bV4kRVcNSKpKbYfoPVbGnOKp+cz/N3JPnipYD3lajpcsiZTV9dJl8P9gbH996I71AqrA0T57F3ENijvOYMqa3TwkISIQS3y61y3bm8XNYlT6FPrqiCpJjcLawO8ePewApZmKiiSuCQohpcT9+mYdPXHDVaMDVrpl2lBWIslLoL+eBiNsDERGfLBJBgN3r8tKjRWy7MWWj3jbPpiLlvrTOfk1PiUlRslp5ojd/CabjMrl/x+MxOUJQyVIqXbUqH4pESM2HRt0w3sxTAbelVkyCFAz+QrqFmge2KxRLIwTHmSwxKyWdcEf+oL4eYmq4JcFEKUyVq43RKMPTynb+RddtM+FogoMst9JywffBrckdbCIkOBv7hUILav5opV8qjlifLBp3MFRklbyOPb5MAb2lRZdGydfwpAxWG8ScxTbcMs1OLbDrjAjMdFxuADh9kYXZw1qMy+nHwQhdAZRSepFJNzo/sDbUMCYKWpB8kOXp4kTg0W+c0n0FlEENmDvnqrIl5yuc2PtjP7DwyMBLwgN8iaiqL502EqrO9x36YVEw7g68SHgLAPYoU/AwTfQMJBcpsQmG7Oy3lBOmlhKjw0ZCL8y7e/YcOY16BxbrnTzLh0SPkubUIMOVkziDympRMvzu/IxrDn99kbk0whbLkEjpfbQkVIqa44/0P/capn5rqGEQtdliLcxMbvYdl14WK5LIEK/669UKSeR7oa3z15g7
 FGE+0aon
 yykmVH9u7WeD8AgvxJlA4ZBKv/I4VWeDhPBDxOV/NGte7xX8AgtngaB4Yi1UZhnJ+mRGY0EkBqIlIkS6Gz9O9Fg7LJVWzyhFchr9JBRwOsijeVuIV1v4LPMopb9Y8Fko4GjFokI9160xrVyTpQR/fUjTQy1oJpmgWtoLJrQQ/CvqqxCdoPXnsclCHrI/cht8LhOZKL+nER/Y71dEDEkRb+tzzl+ZQBTPohK0j2D4qKww9kKbmCMidx4mjar2NQLNmxbU74KkeFF1tAu+aTHqQC+HxQ7Axd5fCyECxKQrrXbWe48kflwneQlS8YEGxIj8ou5xujP3EUbHDVTFhELxFK2gzz02VAp9PUfH5p1+xYhCcXDZ5zpYagqyc3O4Yq5Fn98B6/NJl04xqiRkRKxJfiR1p8pSAuLxLkG7BHmR0feIEYXtPTKF1/IpbdVtaH0LsBoYMtAu95VXi0zhoP3lgIQBNp7R97olGjhc+RpfwGM8b4Bjtj9PLByPF7QEUQR5gz05biKFQRTUK+Z0kDgQMzhM21w7/Qq0C/zXJqzAbYyaTDtskuwVRvpAwUiS7gnf4qj+GsjITAKy7Z2BkChLUQ43bV85mUJjwSbWOZXMDW6toE3mkr+JYojGLvZhLxQYKOME1MdEivpGQ8I+pYslWebsJn3cVVorj5gRs9t6QspcnYINfijsoxv7hYud9ZAtB+3b+VV0LMdI8M5a956aj+LsKg5qIgf2zz6KXDKmEuw4tCxIpIGx9sczEDY3nFfPBS1zNecc5jEBnKh6T9sDfAA+eV4Qeq0btFn1SndIdToMA0I3mMAzl3Wrk+yHQ9VCVFezhy9CS/3E1Tk/aiZIECQJ29j//4ge7TarGRSyOl2pn3EFUncvb+ibcmCS9M0mnZouA9MzxMHebpYg+UPJQsP43RGP3lse9mCvtK78HeINGikWWXkNHgfLfTelaiNzrcX13S3/fIhoSwHggxvSGshO3ByMg
 jTJhPdbD
 ZdqaDtWhkYpQ4Moz4DEREf0t9p+QstdEvABpJVQokofM2TadeYxblSIUMk5X6Yew8rSR4BYn7aisvp2GbM4sFCCW+njCyrPyoVw5InjZ6hs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 16/01/2026 17:36, Edgecombe, Rick P wrote:
> On Fri, 2026-01-16 at 17:28 +0000, Nikita Kalyazin wrote:
>>>
>>> I imagine this feature is really targeted towards machines running
>>> a bunch of untrusted VMs, so cloud hypervisors really. In that case
>>> the direct map will probably be carved up pretty quick. Did you
>>> consider just breaking the full direct map to 4k at the start when
>>> it's in use?
>>
>> That's an interesting point, I haven't thought about it from this
>> perspective.  We should run some tests internally to see if it'd
>> help.  This will likely change with support for huge pages coming in
>> though.
> 
> The thing is, those no_flush() helpers actually still flush if they
> need to split a page. Plus if they need to clear out lazy vmalloc
> aliases it could be another flush. There are probably a lot of
> opportunities to reduce flushing even beyond pre-split.
> 
> Just curious... as far as performance, have you tested this on a big
> multi-socket system, where that flushing will hurt more? It's something
> that has always been a fear for these directmap unmapping solutions

Yes, this is a problem that we'd like to address.  We have been 
discussing it in [1].  The effect of flushing on memory population that 
we see on x86 is 5-7x elongation.  We are thinking of making use of the 
no-direct-map memory allocator that Brendan is working on [2].

[1] 
https://lore.kernel.org/lkml/d1b58114-9b88-4535-b28c-09d9cc1ff3be@amazon.com
[2] https://lore.kernel.org/kvm/DDVS9ITBCE2Z.RSTLCU79EX8G@google.com
> 


