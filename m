Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E61CCC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 15:29:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A210D6B00CE; Fri, 26 Jun 2026 11:29:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D0F56B00D0; Fri, 26 Jun 2026 11:29:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C0F86B00D1; Fri, 26 Jun 2026 11:29:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 53EDE6B00CE
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:29:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C122F1C32FE
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:29:14 +0000 (UTC)
X-FDA: 84922447428.13.C7B5D96
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf01.hostedemail.com (Postfix) with ESMTP id 150D940009
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:29:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wIhePOhy;
	spf=pass (imf01.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782487753;
	b=CnxuwyMHdiE3lKzg0NtqkhK8uWOh53pM0AiFGJp2tWc2BSJK2aeqSCIaRibjqd7XHEz7ut
	V9oUHvp5UFHpkJh73uqtWUswYiEyIy5SMpOwKe4k0TZG+8k9E6w8ltDw7cRTJyoOzOYvrg
	s+GZ173hzc0jvbUm+k6UNpoKQ9SRrr4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782487753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A9yV2d4U6Iq5tvwMQAZTQglaDvuPvKN3XGu5+n1GLLQ=;
	b=lRqNNCmxDxdThHM4Wimpc0vGwvhqMkYedAPkK+ubNmtsqa9rIy6k8QwBcEbpr6T3Jq8vpO
	cMCv9ck8xcJUL5Gnj8szmo3Z61/90lCISGWuP9EMWHg0kb6ue2Z4G6PRWhEvMe96MDHi26
	RX4hDG9xdZ8XP+DRBymQ3vTEBf2MHzc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wIhePOhy;
	spf=pass (imf01.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782487742;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A9yV2d4U6Iq5tvwMQAZTQglaDvuPvKN3XGu5+n1GLLQ=;
	b=wIhePOhyn6G6N5ff0edE/tWPIL0KMu4yLFZwEwWoqZZHrBK6tCDf3vdBAO8t9df+oI6kuQ
	xLnpFgOEs4zA46/+kNEFwdQe2/mKKSiElfQZLqTo8viWrcXcy9xwbuopsxn4/7w4KV94aW
	uCiQ2fhh93vV19Hi8UBA0NS234VnMPI=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 26 Jun 2026 15:28:43 +0000
Message-Id: <DJJ35VLH2PE5.DFD8OYXEOH97@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Takahiro Itazuri" <itazur@amazon.com>, <seanjc@google.com>,
 <ljs@kernel.org>
Cc: <Liam.Howlett@oracle.com>, <ackerleytng@google.com>,
 <agordeev@linux.ibm.com>, <ajones@ventanamicro.com>,
 <akpm@linux-foundation.org>, <alex@ghiti.fr>, <andrii@kernel.org>,
 <aou@eecs.berkeley.edu>, <ast@kernel.org>, <baolu.lu@linux.intel.com>,
 <catalin.marinas@arm.com>, <chenhuacai@kernel.org>, <corbet@lwn.net>,
 <coxu@redhat.com>, <daniel@iogearbox.net>, <dave.hansen@linux.intel.com>,
 <david@kernel.org>, <dev.jain@arm.com>, <itazur@amazon.co.uk>,
 <jackmanb@google.com>, <jannh@google.com>, <jhubbard@nvidia.com>,
 <jmattson@google.com>, <joey.gouly@arm.com>, <john.fastabend@gmail.com>,
 <jolsa@kernel.org>, <jthoughton@google.com>, <kas@kernel.org>,
 <kernel@xen0n.name>, <kpsingh@kernel.org>, <kvm@vger.kernel.org>,
 <kvmarm@lists.linux.dev>, <lenb@kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-kselftest@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-pm@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
 <linux-s390@vger.kernel.org>, <loongarch@lists.linux.dev>,
 <lorenzo.stoakes@oracle.com>, <luto@kernel.org>, <maobibo@loongson.cn>,
 <martin.lau@linux.dev>, <maz@kernel.org>, <mhocko@suse.com>,
 <mingo@redhat.com>, <mlevitsk@redhat.com>, <nikita.kalyazin@linux.dev>,
 <oupton@kernel.org>, <palmer@dabbelt.com>, <patrick.roy@linux.dev>,
 <pavel@kernel.org>, <pbonzini@redhat.com>, <peterx@redhat.com>,
 <peterz@infradead.org>, <pfalcato@suse.de>, <pjw@kernel.org>,
 <prsampat@amd.com>, <rafael@kernel.org>, <riel@surriel.com>,
 <rppt@kernel.org>, <ryan.roberts@arm.com>, <sdf@fomichev.me>,
 <shijie@os.amperecomputing.com>, <skhan@linuxfoundation.org>,
 <song@kernel.org>, <surenb@google.com>, <suzuki.poulose@arm.com>,
 <svens@linux.ibm.com>, <tabba@google.com>, <tglx@kernel.org>,
 <thuth@redhat.com>, <urezki@gmail.com>, <vannapurve@google.com>,
 <vbabka@kernel.org>, <will@kernel.org>, <willy@infradead.org>,
 <wu.fei9@sanechips.com.cn>, <x86@kernel.org>,
 <yang@os.amperecomputing.com>, <yangyicong@hisilicon.com>,
 <yonghong.song@linux.dev>, <yosry@kernel.org>, <yu-cheng.yu@intel.com>,
 <yuzenghui@huawei.com>, <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v12 00/16] Direct Map Removal Support for guest_memfd
References: <aeennZlV60k81OBf@google.com>
 <20260506080753.14517-1-itazur@amazon.com>
In-Reply-To: <20260506080753.14517-1-itazur@amazon.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 150D940009
X-Stat-Signature: 5y4i7erku3p76o6pse55rz6hs9baeufe
X-HE-Tag: 1782487750-425911
X-HE-Meta: U2FsdGVkX1+ftUoOVCk4ulYkBumdE1X25Q/zHmIOBWRNUXwzIs8mN4GB5WdoM2C0AGKW6b79nckrwm4gXDFdZd25aXtkj16zSuQ28Pjg9fSs5dS6F2SIcjnRcoXXtirxgp6XuiY5dabQbMtBSqvi+9OBlErFECSNa+x9jpaMeKsoSlBcZ+MBAXA1TW9WvpuJUT4I1UVKIMFzhu9Rp6CHNEtzkw9qgvcNXTBRRTK2faFo3uULaTe7qtQeuaJ1CfJwe4myul9gda/H3JqthC7GzwjxwuAo0bGjc2U16EdnsymNUiC6bS6pe8nyu6tC5gG2o5Ap5+1nHL6lI/MyC5lkABoMbLY6/2qxWlpBIjAjCDEq6anb+ITS1p9ll4gjznmeVEl7rBv66XXaj8VsXBMyGMV8NDr/Epb7XaCupp0mt8iKGg9VR37GhNWTUD0GJgeY9cb3Th1XdO5cLDn1UvK9TKOCVMDWw9WFWK5spzIapIONlVFwBDUWngzsuIQE6aHh2LusFwOavm+cveY2Xe9BV7MhX3EAQmYCTyd9LDwxHC1ebG5040tOc5d8ObPH1keUI5wJ1EKQxPqT+Bufu43vXOQyCw6rJ3xK73mbbpBmeveA+Z1ilvJNMdZcTsapOdl18QHOrvw6Jq1OnASQdLulZSkk3WIrhy7DZN0LEY4miBue32Uw+78QHYFJojl1clf0GbdpC26pkDfWNAC0MAioeQtZ3BH+PePpDw4MAyb3xX5begluscjywbeBA1qOo/MiULkRkdItcKZ9+GDB8uNjXI8gyAyaM8PdPD9rsKgVbZPCfROs3KRsqWsQpKgMaorzdr3TxuJiXnQqAXE+b1sX4Re8ipMyXeiNg2EHL5N92lbZ1T9pvDF8SS7xBBJBGvrCRmKKdxDR+JZUO/CLVrghfIvgM5HuxIrixi5F1BqKXQsI8RHegUBpYgpGTFLy//kHC7QhdWUkgyWfrDBztHe
 22HzN4rn
 Dl+0mfE70Yo9aHhj7jye3TpLgAYpqiA8XIGcLZghDAZ9lMV+PjhkV0BMSXay8/RqVYNxS/i8ZD91p5JgyED6NQLGVKMdX2Orsa06TgpCi9wu00U77BHNIe2hBWrMv6YYjeQrJu1SffL742g879C5phVsj89yElYn6z0HyD1qoismkNKjOpSL0oJrozJWU744Ax865DkqKyyxUIskXa4Z24FrglRXJQjt/19gPuOEv+B+lFUHzpmmMmwPFmw9qWfCrUREdbQxJ83CpoRJeHWhf9PsP5oOxmOWh0Dr71G2OJSixNA96UuZz/nx3/pgkyhAXfeSNDxZTMxirzw0i42CtKoZ+4sOu+JPiR/POAkxZZ3rRSRiqUxQLRiBQ376LPNETp6V3cwRpvQKCLRp3/VkBzimC0A+8N0qakEXf3q3F2gZYjBtYyYdEhwfLb4I4GB/TWfgEnl3ij+1Jn22pFgNoF8DgpYMV+0RxqT3+hBsTlS1ykL5eRnTUDHXQug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed May 6, 2026 at 8:07 AM UTC, Takahiro Itazuri wrote:
> Hi Lorenzo and Sean,
>
> Apologies for the delayed reply =E2=80=94 Nikita is leaving Amazon, and I=
'm
> taking over this series going forward. Thanks for your patience.
>
> On Tue, Apr 21, 2026 at 01:40:00PM +0000, Lorenzo Stoakes wrote:
>> Hm, given this touches a fair bit of mm, I wonder if we shouldn't try to=
 do this
>> through the mm tree?
>
> On Tue, Apr 21, 2026 at 04:36:00PM +0000, Sean Christopherson wrote:
>> Yeah, when the time comes, the mm pieces definitely need to go through t=
he mm
>> tree.  Ideally, I think this would be merged in two separate parts, with=
 all mm
>> changes going through the mm tree, and then the KVM changes through the =
KVM tree
>> using a stable topic branch/tag from Andrew.
>
> Thanks for the guidance. The split makes sense to me; I'm planning to
> follow this approach with patches 1-6 (mm) going through the mm tree
> and patches 7-16 (KVM) through the KVM tree on top of a stable
> branch/tag from mm. I'll confirm the exact boundary and coordination
> details as I prepare the repost.
>
> On Tue, Apr 21, 2026 at 01:40:00PM +0000, Lorenzo Stoakes wrote:
>> In any case, we definitely need a rebase on something not-next :) if not=
 mm then
>> Linus's tree at least maybe?
>>
>> I'm seeing a lot of conflicts against mm-unstable, it can't b4 shazam ev=
en patch
>> 1 and in Linus's tree it's failing at an mm patch (mm: introduce
>> AS_NO_DIRECT_MAP).
>

Just as an FYI, I am gonna look at trying to move this forward a bit
while Takahiro ramps up on taking over (I spoke to him about this off
list).

My ulterior motive is that this would give me an excuse to add
ALLOC_UNMAPPED (formerly __GFP_UNMAPPED) and the mermap [0] which
unblocks various security nonsense including ASI [1]. (But also, this
feature is a good idea).

[0] https://lore.kernel.org/all/20260320-page_alloc-unmapped-v2-0-28bf1bd54=
f41@google.com/
[1] https://linuxasi.dev

