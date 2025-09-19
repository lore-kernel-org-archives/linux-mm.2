Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ABE9CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 08:30:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A48E88E005E; Fri, 19 Sep 2025 04:30:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F9A48E0008; Fri, 19 Sep 2025 04:30:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E82B8E005E; Fri, 19 Sep 2025 04:30:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 76C9D8E0008
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 04:30:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2C6E9BA41E
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 08:30:27 +0000 (UTC)
X-FDA: 83905328094.11.8F74213
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8F6C14000F
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 08:30:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b="gQM/Ahhn";
	spf=pass (imf27.hostedemail.com: domain of "prvs=35079eb1c=roypat@amazon.co.uk" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=35079eb1c=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758270624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xQMfSE2j0e0kXW7iy6dzBiNtwDQyibH0F14unNsZxY0=;
	b=nvehIqSs0J5aVtYWyMxd0oy0z8q5TqYcdNqSmPB4ua507GFxobpJFv7QKxKL0RMtoNZeZr
	1vUyd0UL7qa8dLxClwOnv8efLCryyd5KCAI1G4EN4An35pYm/bSaXE//YuOLt+21ZsLa+H
	4PiBcq2ffBCAJOnqK7Q1QQo2/i4EqOI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758270624; a=rsa-sha256;
	cv=none;
	b=2MHLBfJncxkV7VOI7bsv4flDxPw1USW5DocuW2DPBt5JcOF8jVAKezeqeR6f7JKLiixfi/
	TJQFsipGo18STwCPAM/hTF1Cqy9yxSw0026x5wbL6hj0Kclsb2/fvk7/jj8e6mnzZUn9K/
	4sl5EItz6JvcTsMuM+Rsl8RSeNL0xfE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b="gQM/Ahhn";
	spf=pass (imf27.hostedemail.com: domain of "prvs=35079eb1c=roypat@amazon.co.uk" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=35079eb1c=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1758270624; x=1789806624;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xQMfSE2j0e0kXW7iy6dzBiNtwDQyibH0F14unNsZxY0=;
  b=gQM/AhhnLA11xXwPwvPVjfHpGfx1xrOvSrzrMajRE0EUCcn+kgnak8Tj
   6QKe5crg/LUDvUI+ZOwoWqtUaZ8QPOtFSeDgoiat1eS9Fr3AILEUCvfVk
   EdougMAC8gcAjWUZsX+R21CBslFr70BCkeCbN+ObsfX0r3jCcttM3rYC+
   o27znBAV/CjGLv86pPCCHRRGm/e9O1+/cVrzz4h2mJlRnnpNHvi82//+B
   muwZLrewzUybhnWXIqAXu/VrrdYAV8BgfLDLEAtQ4UXyqFGRjNgwRUBKV
   NozhgrHUY6xUtrn54U4GP702tRkBQHb5n3syxX6zgs+/+zNjKZvnUT30K
   g==;
X-CSE-ConnectionGUID: vUeZyQaIS32WfGrBH8LBqw==
X-CSE-MsgGUID: 7ubyqWN9R7CraB91GGKOuQ==
X-IronPort-AV: E=Sophos;i="6.18,277,1751241600"; 
   d="scan'208";a="2361382"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 08:30:09 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.232:2610]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.36.68:2525] with esmtp (Farcaster)
 id 2e1ccd73-6c97-437e-b0d8-729206f284fa; Fri, 19 Sep 2025 08:30:09 +0000 (UTC)
X-Farcaster-Flow-ID: 2e1ccd73-6c97-437e-b0d8-729206f284fa
Received: from EX19D015EUB002.ant.amazon.com (10.252.51.123) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 19 Sep 2025 08:30:08 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB002.ant.amazon.com (10.252.51.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 19 Sep 2025 08:30:08 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Fri, 19 Sep 2025 08:30:08 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
To: "hughd@google.com" <hughd@google.com>
CC: "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
	"agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "alex@ghiti.fr"
	<alex@ghiti.fr>, "andrii@kernel.org" <andrii@kernel.org>, "anna@kernel.org"
	<anna@kernel.org>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"ast@kernel.org" <ast@kernel.org>, "axelrasmussen@google.com"
	<axelrasmussen@google.com>, "borntraeger@linux.ibm.com"
	<borntraeger@linux.ibm.com>, "bp@alien8.de" <bp@alien8.de>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, "brauner@kernel.org"
	<brauner@kernel.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "corbet@lwn.net"
	<corbet@lwn.net>, "daniel@iogearbox.net" <daniel@iogearbox.net>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"david@redhat.com" <david@redhat.com>, "derekmn@amazon.co.uk"
	<derekmn@amazon.co.uk>, "devel@lists.orangefs.org"
	<devel@lists.orangefs.org>, "eddyz87@gmail.com" <eddyz87@gmail.com>,
	"gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
	"gor@linux.ibm.com" <gor@linux.ibm.com>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "haoluo@google.com" <haoluo@google.com>,
	"hca@linux.ibm.com" <hca@linux.ibm.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"hubcap@omnibond.com" <hubcap@omnibond.com>, "jack@suse.cz" <jack@suse.cz>,
	"Thomson, Jack" <jackabt@amazon.co.uk>, "jannh@google.com"
	<jannh@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com"
	<jhubbard@nvidia.com>, "joey.gouly@arm.com" <joey.gouly@arm.com>,
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "jolsa@kernel.org"
	<jolsa@kernel.org>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"kernel@xen0n.name" <kernel@xen0n.name>, "kpsingh@kernel.org"
	<kpsingh@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-kselftest@vger.kernel.org"
	<linux-kselftest@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "luto@kernel.org"
	<luto@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>,
	"martin@omnibond.com" <martin@omnibond.com>, "maz@kernel.org"
	<maz@kernel.org>, "mhocko@suse.com" <mhocko@suse.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "paul.walmsley@sifive.com"
	<paul.walmsley@sifive.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"peterx@redhat.com" <peterx@redhat.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "pfalcato@suse.de" <pfalcato@suse.de>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Roy, Patrick"
	<roypat@amazon.co.uk>, "rppt@kernel.org" <rppt@kernel.org>, "sdf@fomichev.me"
	<sdf@fomichev.me>, "seanjc@google.com" <seanjc@google.com>,
	"shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, "shuah@kernel.org"
	<shuah@kernel.org>, "song@kernel.org" <song@kernel.org>, "surenb@google.com"
	<surenb@google.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"svens@linux.ibm.com" <svens@linux.ibm.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "trondmy@kernel.org" <trondmy@kernel.org>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "viro@zeniv.linux.org.uk"
	<viro@zeniv.linux.org.uk>, "weixugc@google.com" <weixugc@google.com>,
	"will@kernel.org" <will@kernel.org>, "willy@infradead.org"
	<willy@infradead.org>, "x86@kernel.org" <x86@kernel.org>, "Cali, Marco"
	<xmarcalx@amazon.co.uk>, "yonghong.song@linux.dev" <yonghong.song@linux.dev>,
	"yuanchu@google.com" <yuanchu@google.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "zhengqi.arch@bytedance.com"
	<zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v6 01/11] filemap: Pass address_space mapping to
 ->free_folio()
Thread-Topic: [PATCH v6 01/11] filemap: Pass address_space mapping to
 ->free_folio()
Thread-Index: AQHcKT+bvwDzyVs1WEGX2DXFZiV07Q==
Date: Fri, 19 Sep 2025 08:30:08 +0000
Message-ID: <20250919083006.21171-1-roypat@amazon.co.uk>
References: <7c2677e1-daf7-3b49-0a04-1efdf451379a@google.com>
In-Reply-To: <7c2677e1-daf7-3b49-0a04-1efdf451379a@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.88.180]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8F6C14000F
X-Stat-Signature: zxizjs5eq7efc3hwedrcpbp8nn7r8bq3
X-Rspam-User: 
X-HE-Tag: 1758270624-505446
X-HE-Meta: U2FsdGVkX19EiVArZbANlEa4aNbl4f7EmKyi9G56c9Hh4TCwflrBBCsFre7gb0Tr6n80K+88fTha7ejoIcBoJYHM6y8eDECDCzFqBfTt0WKOR8f/1k0LR2ovsRyZcAGZmcVbR5dx6X/DgBo+FQeLueZSD6pSercGR/baJaM48kitH0wTi3bLnnHshXr8/gEXnyhPU26j6Vr1qSdHNHiK1Dr+A+gqsMhhkmIILcCsJeiR7yS9FsgiSCvzZkJnJKoMvaftUhQEhYhBKMrQsOeJz3L4cVdp0SSraQxsjYU7+gE93Up5wp4l9ufgSI4qEn6k4hZrLngj/pcE8E+Krsy1ETIo7JWG1b8e65ep4awB/LJrDuJpJKA+ZvI2uOsivQBLudaVpCH6U1WTRfE66UPzYW1z0x21aUsrH1qgk0FcsvKyLhmTcm4uIvfyLKb+gVXAJMrB7QQnCFyMZkdrxDCA15O716dXvj6lS4gUBL3Pwv0xv/rH8LqEK9+mmPYYfBsUf6xoMxYQBtz7eMm723gZGe0EVyYQpVjDEUaONlCFZzBB7u24cf6DT5bZWFNQP1qm9eHyMDx8xcdHGrXkH/JwLkQw1KIUoOANMTn3H3Ql/tfYubP+50T+KQAFUCPkONb+hDEppe6aSdymTKg5kQqMrZVkF6o/NyqEjJ8qfxZ8txJKYQJF/cOdsbDNBAF/T3KW57w2UmmkqDGjynbD5hX5TxR/bPQTE79uo+x+FEv4VyFfxJ0UyL2QDJssys4OL8+p3ErJRUoObWUKjTmDxvLjawSala1gwWjxb1n2f5r8IB7qvuFqfvMRpopZlbPnu9S85VmrSs6l4rVcb+CVQb/scFMBRfmH7HP/fVYZzE93aJpScVwk2P1xp6BKQjfC3ubGCle6ew8OqA+9kuqx+OOErDY3y7d8qo03J59m0kh1Hcgt82+Yn6kV4/8Z3e3FRjUDZkidzSAOuqkGnsstAzX
 MrIndz+u
 SUZaeaI5Gv9dBWkYC1Ii2NvuXq25YoHg36uz0RV2vXEdZmnkGqJ4CEP+lSgWB8ym/CtOgm4SRZIMhZFgkbqqFukBgQLTGubuxNod3IpVbka5prcOuiw0qlVwF7Sj6fpChwLu9gicZVQZcnd9hkhsNaz3Nvw/zVPBsMroFZGqcyK2dlaDEr+g01/rhocbT9R8G0w/miidh97SVBaHaqemN6ApXzLtuYB944EO9ks5qNf7MehnN/sUjpvXfFaQen70KHcylyZ/NoAbXst69ThVaLKQF0Mbfh3r4jUTomIS5U3Z9x+oFmdJ4n+TumteVAV0EeF+uWNMhsplM1MwZYClEt+lEvi2aAanP8R07270iER/QriSZw8Fz/LWZ+7pDAbqSGeSEO7wU/J2guutnKzRUMjL+l6Qp3+vcAEnpLUKzO3FTa6/Vp4q1xyGD7FMiGKJKS27ytyMLNTbbBN8kpx+Ucngk5o/h78VXVhvRN71dJEAStqGgLStjimt2/2iUWl3ct9jkme/+iQmVomQRROmUEPXuZ5vKV8pLoco5UY07bPk9jRqYbrJBS72bnOtqv7+X9L6a49VbyW9BvE9DgmsUhZCUJ/Hp8m7gduukSY1AP6RfCbnspIpn2R7zcxoqZOm5JfaGizHJTnUIfpcVbaoiIYzwAdJKxgJaRSdqzpjpEmOJSHqbOj3OPHH35JtqZfScOXrPvIKR9h8wInLTXjclsjwJObsDvkTQcA+V5KIqXCvQ9Dr0pb2Srrw155H5UJTtcxII7Pz0T8V9mlEVCLtlyfv+Jco+luosX9nrEBe0VtMe5rD8Q/NnbBk5oPe82d5b/MfXe1BQj4NNB2U00NnO9gTKH2dgiB58kNDBjcXpW7wgskP9K33NgthIyQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

=0A=
Hi Hugh!=0A=
=0A=
On Tue, 2025-09-16 at 07:23 +0100, Hugh Dickins wrote:> On Fri, 12 Sep 2025=
, Roy, Patrick wrote:=0A=
> =0A=
>> From: Elliot Berman <quic_eberman@quicinc.com>=0A=
>>=0A=
>> When guest_memfd removes memory from the host kernel's direct map,=0A=
>> direct map entries must be restored before the memory is freed again. To=
=0A=
>> do so, ->free_folio() needs to know whether a gmem folio was direct map=
=0A=
>> removed in the first place though. While possible to keep track of this=
=0A=
>> information on each individual folio (e.g. via page flags), direct map=
=0A=
>> removal is an all-or-nothing property of the entire guest_memfd, so it=
=0A=
>> is less error prone to just check the flag stored in the gmem inode's=0A=
>> private data.  However, by the time ->free_folio() is called,=0A=
>> folio->mapping might be cleared. To still allow access to the address=0A=
>> space from which the folio was just removed, pass it in as an additional=
=0A=
>> argument to ->free_folio, as the mapping is well-known to all callers.=
=0A=
>>=0A=
>> Link: https://lore.kernel.org/all/15f665b4-2d33-41ca-ac50-fafe24ade32f@r=
edhat.com/=0A=
>> Suggested-by: David Hildenbrand <david@redhat.com>=0A=
>> Acked-by: David Hildenbrand <david@redhat.com>=0A=
>> Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>=0A=
>> [patrick: rewrite shortlog for new usecase]=0A=
>> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
>> ---=0A=
>>  Documentation/filesystems/locking.rst |  2 +-=0A=
>>  fs/nfs/dir.c                          | 11 ++++++-----=0A=
>>  fs/orangefs/inode.c                   |  3 ++-=0A=
>>  include/linux/fs.h                    |  2 +-=0A=
>>  mm/filemap.c                          |  9 +++++----=0A=
>>  mm/secretmem.c                        |  3 ++-=0A=
>>  mm/vmscan.c                           |  4 ++--=0A=
>>  virt/kvm/guest_memfd.c                |  3 ++-=0A=
>>  8 files changed, 21 insertions(+), 16 deletions(-)=0A=
>>=0A=
>> diff --git a/Documentation/filesystems/locking.rst b/Documentation/files=
ystems/locking.rst=0A=
>> index aa287ccdac2f..74c97287ec40 100644=0A=
>> --- a/Documentation/filesystems/locking.rst=0A=
>> +++ b/Documentation/filesystems/locking.rst=0A=
>> @@ -262,7 +262,7 @@ prototypes::=0A=
>>       sector_t (*bmap)(struct address_space *, sector_t);=0A=
>>       void (*invalidate_folio) (struct folio *, size_t start, size_t len=
);=0A=
>>       bool (*release_folio)(struct folio *, gfp_t);=0A=
>> -     void (*free_folio)(struct folio *);=0A=
>> +     void (*free_folio)(struct address_space *, struct folio *);=0A=
>>       int (*direct_IO)(struct kiocb *, struct iov_iter *iter);=0A=
>>       int (*migrate_folio)(struct address_space *, struct folio *dst,=0A=
>>                       struct folio *src, enum migrate_mode);=0A=
> =0A=
> Beware, that is against the intent of free_folio().=0A=
> =0A=
> Since its 2.6.37 origin in 6072d13c4293 ("Call the filesystem back=0A=
> whenever a page is removed from the page cache"), freepage() or=0A=
> free_folio() has intentionally NOT taken a struct address_space *mapping,=
=0A=
> because that structure may already be freed by the time free_folio() is=
=0A=
> called, if the last folio holding it has now been freed.=0A=
> =0A=
> Maybe something has changed since then, or maybe it happens to be safe=0A=
> just in the context in which you want to use it; but it is against the=0A=
> principle of free_folio().  (Maybe an rcu_read_lock() could be added=0A=
> in __remove_mapping() to make it safe nowadays? maybe not welcome.)=0A=
> =0A=
> See Documentation/filesystems/vfs.rst:=0A=
> free_folio is called once the folio is no longer visible in the=0A=
> page cache in order to allow the cleanup of any private data.=0A=
> Since it may be called by the memory reclaimer, it should not=0A=
> assume that the original address_space mapping still exists, and=0A=
> it should not block.=0A=
> =0A=
> Hugh=0A=
Thanks for pointing this out! I think I can make do without this patch,=0A=
by storing the direct map state in some bit directly on the folio (in=0A=
yesterday's upstream guest_memfd call, we talked about using=0A=
->private, which guest_memfd isn't using for anything yet). Will do that=0A=
for the next iteration.=0A=
=0A=
Best,=0A=
Patrick=0A=
=0A=

