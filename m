Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA4C4CD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 08:08:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF58F6B0005; Wed,  6 May 2026 04:08:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA67D6B0088; Wed,  6 May 2026 04:08:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A94D66B008A; Wed,  6 May 2026 04:08:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 991A16B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 04:08:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3984D160477
	for <linux-mm@kvack.org>; Wed,  6 May 2026 08:08:24 +0000 (UTC)
X-FDA: 84736267728.08.9E5AB81
Received: from pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.1.125])
	by imf18.hostedemail.com (Postfix) with ESMTP id CDE551C0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 08:08:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=KLjtgzq9;
	spf=pass (imf18.hostedemail.com: domain of "prvs=579c0b465=itazur@amazon.co.uk" designates 44.246.1.125 as permitted sender) smtp.mailfrom="prvs=579c0b465=itazur@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778054902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bfdMAsgvM6p8hWk2sdmIXhE1O1tOVF0HFNlReXBroqU=;
	b=OT4G88IwPERPD3JK1vZEVSbWb2eMF3+mT/HjiX5Mo4dCS1PKb7dt9D+XkuiJyCPNjq0sWM
	V68RsXPCXKzujcNbe55LfQcH+rqFcRROkao/xX7pM++HfqymWkn0iC3hx1hsusN+uI5EuE
	0i3zhzxNLqtWFvXmvMlAY+miEQ7y+u8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=KLjtgzq9;
	spf=pass (imf18.hostedemail.com: domain of "prvs=579c0b465=itazur@amazon.co.uk" designates 44.246.1.125 as permitted sender) smtp.mailfrom="prvs=579c0b465=itazur@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778054902; a=rsa-sha256;
	cv=none;
	b=KHvXQ/+4i0WXW7H41GFePCLVyiH/wEewMwULdzTb5F0og3PeQtgE/AzAPw79keda8+W6oi
	SOto4DAK1isOIfIcotIABqRf+uXAHoOQiOd1zxe9x7AKTRCg6fx8CpwlhHKoA6jlEYaztB
	2OpwXubswWx8IJFAsU7V1Lru0r+T5t8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1778054901; x=1809590901;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bfdMAsgvM6p8hWk2sdmIXhE1O1tOVF0HFNlReXBroqU=;
  b=KLjtgzq96uZZ3vi14Pc4rfSyiIfWqqiRIRzMPPMVAl8jaRIs4SzQY7+T
   IrWjkcz93K53sEd9Hy23dXGBpiIgvKfuFK66+pk0OG10AhXjnEr35Kvyl
   TmnmlmoAVInfW3iyK5imUXMqPuS026kwApXRtb9Act5nISx00Mn13EwUG
   T1F4yGx/nXIAaFZ+5OCbnCaoHSyDvQzWbpCBwLMRoq0OcsStHglqSAN1V
   zNwQj/pASx5NBjDqmlvxP984ITxuk1QaKrcKZ0u6sJ0dUfkO9c7DGFlyu
   b/B6Plp8oCrM6gqQpxyOl3ba8k2O+808yChm70lyi4jLczZP5oYHNQhBn
   Q==;
X-CSE-ConnectionGUID: MmMFvwZCQLewcyBwlWjNrw==
X-CSE-MsgGUID: dKPa6oOPR+SZmZUz/KuDQg==
X-IronPort-AV: E=Sophos;i="6.23,219,1770595200"; 
   d="scan'208";a="18975878"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 08:08:18 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:20934]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.20.153:2525] with esmtp (Farcaster)
 id 4c3798b6-d4c5-412e-bccc-51de55c2e359; Wed, 6 May 2026 08:08:17 +0000 (UTC)
X-Farcaster-Flow-ID: 4c3798b6-d4c5-412e-bccc-51de55c2e359
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 6 May 2026 08:08:17 +0000
Received: from dev-dsk-itazur-1b-11e7fc0f.eu-west-1.amazon.com (172.19.66.53)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 6 May 2026 08:08:03 +0000
From: Takahiro Itazuri <itazur@amazon.com>
To: <seanjc@google.com>, <ljs@kernel.org>
CC: <Liam.Howlett@oracle.com>, <ackerleytng@google.com>,
	<agordeev@linux.ibm.com>, <ajones@ventanamicro.com>,
	<akpm@linux-foundation.org>, <alex@ghiti.fr>, <andrii@kernel.org>,
	<aou@eecs.berkeley.edu>, <ast@kernel.org>, <baolu.lu@linux.intel.com>,
	<borntraeger@linux.ibm.com>, <bp@alien8.de>, <bpf@vger.kernel.org>,
	<catalin.marinas@arm.com>, <chenhuacai@kernel.org>, <corbet@lwn.net>,
	<coxu@redhat.com>, <daniel@iogearbox.net>, <dave.hansen@linux.intel.com>,
	<david@kernel.org>, <derekmn@amazon.com>, <dev.jain@arm.com>,
	<eddyz87@gmail.com>, <gerald.schaefer@linux.ibm.com>, <gor@linux.ibm.com>,
	<haoluo@google.com>, <hca@linux.ibm.com>, <hpa@zytor.com>,
	<itazur@amazon.co.uk>, <jackabt@amazon.co.uk>, <jackmanb@google.com>,
	<jannh@google.com>, <jgg@ziepe.ca>, <jgross@suse.com>, <jhubbard@nvidia.com>,
	<jiayuan.chen@shopee.com>, <jmattson@google.com>, <joey.gouly@arm.com>,
	<john.fastabend@gmail.com>, <jolsa@kernel.org>, <jthoughton@google.com>,
	<kalyazin@amazon.co.uk>, <kas@kernel.org>, <kernel@xen0n.name>,
	<kpsingh@kernel.org>, <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>,
	<lenb@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-doc@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-pm@vger.kernel.org>,
	<linux-riscv@lists.infradead.org>, <linux-s390@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <lorenzo.stoakes@oracle.com>, <luto@kernel.org>,
	<maobibo@loongson.cn>, <martin.lau@linux.dev>, <maz@kernel.org>,
	<mhocko@suse.com>, <mingo@redhat.com>, <mlevitsk@redhat.com>,
	<nikita.kalyazin@linux.dev>, <oupton@kernel.org>, <palmer@dabbelt.com>,
	<patrick.roy@linux.dev>, <pavel@kernel.org>, <pbonzini@redhat.com>,
	<peterx@redhat.com>, <peterz@infradead.org>, <pfalcato@suse.de>,
	<pjw@kernel.org>, <prsampat@amd.com>, <rafael@kernel.org>,
	<riel@surriel.com>, <rppt@kernel.org>, <ryan.roberts@arm.com>,
	<sdf@fomichev.me>, <shijie@os.amperecomputing.com>,
	<skhan@linuxfoundation.org>, <song@kernel.org>, <surenb@google.com>,
	<suzuki.poulose@arm.com>, <svens@linux.ibm.com>, <tabba@google.com>,
	<tglx@kernel.org>, <thuth@redhat.com>, <urezki@gmail.com>,
	<vannapurve@google.com>, <vbabka@kernel.org>, <will@kernel.org>,
	<willy@infradead.org>, <wu.fei9@sanechips.com.cn>, <x86@kernel.org>,
	<yang@os.amperecomputing.com>, <yangyicong@hisilicon.com>,
	<yonghong.song@linux.dev>, <yosry@kernel.org>, <yu-cheng.yu@intel.com>,
	<yuzenghui@huawei.com>, <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v12 00/16] Direct Map Removal Support for guest_memfd
Date: Wed, 6 May 2026 08:07:52 +0000
Message-ID: <20260506080753.14517-1-itazur@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aeennZlV60k81OBf@google.com>
References: <aeennZlV60k81OBf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [172.19.66.53]
X-ClientProxiedBy: EX19D037UWB002.ant.amazon.com (10.13.138.121) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: 995yujon8qdjd6rygubakw3jm1m1topt
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CDE551C0005
X-Rspam-User: 
X-HE-Tag: 1778054901-943832
X-HE-Meta: U2FsdGVkX1+oobgm7VO20l9i7+uepyNDGs7OW7j7qFqogLFz1JZE/RN3w42ciZ/sm7vu/OOzYWtBHCGJCs/DY8zk5RYtI2i/rKEbKA3wTwU0S5LQTmKsjeNn6MTULF5BDp6rYrIK6yHcLNcfsULm0FF/KM+k/hjsUJYRtrpSrmD1Pq6NPCjdnqC0ATt6A0w1ZtCabOJ2VxKFsAhcd060V2wr7nMfR0DJ0J4c+2MQSWIn9TluqjsPQQhcm9nk290boRvFNDfUQmachnHgj/sUMhxIrgEbWX0bm3FgR5Kv6VMYOVoxDg9cNTCTQkTih8jQ9Bl2gSUHmguehXFzq5MlBIpUdUIidyLgMm/i6gxVCe1oiS3oTOE7YZT/sDKKN0WhRG7cqjYRtokNZW+hnaFZic8iM+q4fx0wcSMrQTanTwltJoHDD333Aj+431Zc+dpCyaTPZCmp0OpIPbBumkVSpZv40u6xYK/2XVBuoJd3gyulUEmwN8WTh9Ci6/0gV4CxcX89PRKHWQ9RR9Jfr0jKLiJSXjG4G1QnWe1MdTdOnX88XoYhdqZd39WocL8gz7/+lNROq15ujpT8RG+nqdz6Rg7k3l7t03BbUkl2Ef0ozoW5zyMK4APRx5EG5Sdh1j9PqgHOza4xPzi0lNn5x4usUkWilJC1/vhIfYvW2BJwEx5d73Zj9Z9+TqWO/1aUEj0ExCFauBMFimCzjtVYB6MCwLpkIZT+k+5Du8wtsg1+fLtz6Q0DozWhbiqmzXpTdIDgwUH2U2fh6xrY3OcSVrHnx7VqC8tqXMRZ0o3NV8qADsPnRrHCUF5at34eUSqIKR1ynTQ2S5YLU7jvnzugxDlCnyl5PfO0SPSEPZAyGWi1hRpsCF7W1t2bO8ze5Kk3qhMI7sjdFlBJxGSUpEACiHM54tMLo56NF+AJWf7e34Pe3LW/CBy1Qlyin4FUcrQDaOZFFOKJyoohlq9xVQXHev3
 DZ1XMLRM
 /WdhiXm4nkqXD3BwLyzA9lgbZbkEFa0TUN+Q3puYm+5GLxD3iQ3EwZgqp9z0fr/3IY1fdTMglA1szo5xjAAIIT3T8hPEj+zM6u2ZSlddLt/VOMWec1rZgcfpMuYG4znBk8AbeqZbRsdy7pw+ixlieb6b/YSoezHA9IbsnSxy5353J9WyLGCMbVrCqOjOmm7c47ZuUkJtuFqYFfYvNs+Rzj7EJagDk6qtIzuQYz+xkGIgd8nt1/5XioAS69P/6GXvhnu4FCWODGF44TzMU8t8GolsS/ElED1vRXTMQ+onmq9O8BlfqKM5S/msb4LRDjz68T4I8/uMpYQp5FruxYiDHTo06oYra02utpfYO+qGr9Yx1vozLfi7gwxmUBbhoL8GxoSzlFvDqgzxxD3cnftM49vlTS1c6PEZT4g+oxolkdpVddgVIBZwJgCTje3IPkRpxUW6usX0kEIf8Um7e4WSagdrKsktAoAJvk3A4m6rLrLiXqgJwa2JIRQY/2YKVuGFka16qcMk4lFnJGCg17/j+XplnExyDvjh2tbeR/jBgczeg+ByTXKw9LY4ZM00PEcz7XIl1ubovkbreNBrps4p6uhCuzgT7Z7OSpuwiJqqTa4456vjRxTEa0L6GXXBrgaz/hubnG5eaeYEQit1AsYS3hCxokTxYM8DP6ehZrgHJco3YVkwWXjMa2L2aPchkDKqtBLBU3bjjOE3RMVGz81ed0c/7I3XQzzhPr4ZKZVTyJ3EkwCdC/+ilqoPWgDuwS4GucZZQe6lrqOfFq8EVC9yi7hsqj143hbhUqYjfSajxTzZ4bjNNi2OmQB4B9kiuX1I3OxcR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo and Sean,

Apologies for the delayed reply =E2=80=94 Nikita is leaving Amazon, and I'm
taking over this series going forward. Thanks for your patience.

On Tue, Apr 21, 2026 at 01:40:00PM +0000, Lorenzo Stoakes wrote:
> Hm, given this touches a fair bit of mm, I wonder if we shouldn't try to =
do this
> through the mm tree?

On Tue, Apr 21, 2026 at 04:36:00PM +0000, Sean Christopherson wrote:
> Yeah, when the time comes, the mm pieces definitely need to go through th=
e mm
> tree.  Ideally, I think this would be merged in two separate parts, with =
all mm
> changes going through the mm tree, and then the KVM changes through the K=
VM tree
> using a stable topic branch/tag from Andrew.

Thanks for the guidance. The split makes sense to me; I'm planning to
follow this approach with patches 1-6 (mm) going through the mm tree
and patches 7-16 (KVM) through the KVM tree on top of a stable
branch/tag from mm. I'll confirm the exact boundary and coordination
details as I prepare the repost.

On Tue, Apr 21, 2026 at 01:40:00PM +0000, Lorenzo Stoakes wrote:
> In any case, we definitely need a rebase on something not-next :) if not =
mm then
> Linus's tree at least maybe?
>
> I'm seeing a lot of conflicts against mm-unstable, it can't b4 shazam eve=
n patch
> 1 and in Linus's tree it's failing at an mm patch (mm: introduce
> AS_NO_DIRECT_MAP).

I'll rebase onto v7.1-rc1 and resolve the conflicts as part of the split.

Takahiro


