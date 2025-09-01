Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AE7CCA1000
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:56:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BBA58E005F; Mon,  1 Sep 2025 09:56:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 392D98E0008; Mon,  1 Sep 2025 09:56:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27FCB8E005F; Mon,  1 Sep 2025 09:56:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 047128E0008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:56:32 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A047BBF2C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:56:31 +0000 (UTC)
X-FDA: 83840831382.02.EA22C2A
Received: from fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.156.205.64])
	by imf15.hostedemail.com (Postfix) with ESMTP id E7956A0006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:56:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=nN55qao4;
	spf=pass (imf15.hostedemail.com: domain of "prvs=332aeadb2=roypat@amazon.co.uk" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=332aeadb2=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756734989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ShuxvqvDerzcNDGyxqNGPvo4DRrl5n6jGqzZ1svVTj0=;
	b=sjNaKei8nQEL1O656g2nFfwNo6POJwdwlEvFQC46668g5SmARNXir67j8TkN1Ysbkwx7I0
	4s+5eoiH+v57jFiLMjquBG7t7X8zyxO+yCBdsOgHxv1w1WiCEVc4x+o4UYOomFAiTx4UrD
	n8H5UqLwLlMn1F/mJ8jiiqgtax9alfY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756734989; a=rsa-sha256;
	cv=none;
	b=HAZfdeDscuBhzsDZZ8ViGNXA82rVTzxNdAj5ebAapV/olUppGZQpWhA7lgvkfEXsx5qxYq
	NaD/FsbVPmB+HEDvT2r+unVw4kZLL++vE7dm2mAsGZ2zifLRNmTPdWttjoaGiKJmfzk65y
	Pm9GKUvVGUTP4HSIOnEU0zIjoUIdVgE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=nN55qao4;
	spf=pass (imf15.hostedemail.com: domain of "prvs=332aeadb2=roypat@amazon.co.uk" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=332aeadb2=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756734989; x=1788270989;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ShuxvqvDerzcNDGyxqNGPvo4DRrl5n6jGqzZ1svVTj0=;
  b=nN55qao4HgdRMWCFPd5/RcbXigDTarfAgoEZtOFu9ZGGivWzIfJ9NDT1
   EFXXEXRwGMJU7njUFcpriXljfpdI+q0H1EJZZDMSTV+iO91yxqG+nJZYy
   /6D+WitpUo5skByOd9zr7Wj9JWvfet3TAl+RTwL8CfBr1XzTVrJBBFJkZ
   +cxx5aEQtX1i/+eoqBi46YxCfhfjI48Dq/0RMk1wBKNhWtODD0SjZThS+
   l3XaW9IHZ8F6HkGnXSBA40dVuKtwE0k9oG42EXejLdNSf2MGc165WzTN3
   1vnfAiLu4Vnvxz83NtJgL1fF52pg5ch2YmUlyAzOAY8J9VWHl0J9jD9T2
   Q==;
X-CSE-ConnectionGUID: W0SVbbBGRzWj4V7tZRsvSQ==
X-CSE-MsgGUID: 1UgY4F0/TxuSRxd+6VB0Jg==
X-IronPort-AV: E=Sophos;i="6.18,214,1751241600"; 
   d="scan'208";a="1464002"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 13:56:18 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.226:27204]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.18.194:2525] with esmtp (Farcaster)
 id 3007a2af-4f0d-4c19-b4ab-3118cbde73e5; Mon, 1 Sep 2025 13:56:18 +0000 (UTC)
X-Farcaster-Flow-ID: 3007a2af-4f0d-4c19-b4ab-3118cbde73e5
Received: from EX19D015EUB003.ant.amazon.com (10.252.51.113) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Mon, 1 Sep 2025 13:56:17 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB003.ant.amazon.com (10.252.51.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 1 Sep 2025 13:56:17 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Mon, 1 Sep 2025 13:56:17 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
To: "rppt@kernel.org" <rppt@kernel.org>
CC: "ackerleytng@google.com" <ackerleytng@google.com>, "david@redhat.com"
	<david@redhat.com>, "Manwaring, Derek" <derekmn@amazon.com>, "Thomson, Jack"
	<jackabt@amazon.co.uk>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Roy, Patrick"
	<roypat@amazon.co.uk>, "seanjc@google.com" <seanjc@google.com>,
	"tabba@google.com" <tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"will@kernel.org" <will@kernel.org>, "Cali, Marco" <xmarcalx@amazon.co.uk>
Subject: Re: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
Thread-Topic: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
Thread-Index: AQHcG0gw3raZWQR6+ESSIUK7nFklbw==
Date: Mon, 1 Sep 2025 13:56:17 +0000
Message-ID: <20250901135615.7601-1-roypat@amazon.co.uk>
References: <aLBnHwUN74ErKVjX@kernel.org>
In-Reply-To: <aLBnHwUN74ErKVjX@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.88.180]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E7956A0006
X-Stat-Signature: 19obxoxk8tjkbqird4gte6rywwe767kc
X-Rspam-User: 
X-HE-Tag: 1756734988-100761
X-HE-Meta: U2FsdGVkX19puVvHyIUJuUmMqwAfC4SRIXkq73hwRanE2w+0H13+2QJWMyTLxFfsyOzSwv5ZZp2bls8vSf0ztK3b9eIjC0VaCWaogzMiv7enpFzVerekmUDGijkRNFxQIg3bikI8b5hC/zWFEOfFT/Bek48rGdbUIfitc/bU5FPqDkIlbKxEfzn0h3TsJV8qxUKKb2ynJVvRhNGsAkK+u7bSUcrN5Um+2RYhIHM+yHQC8eOzwnq/xFsMVNo5GJhQxA/wH2Qe3QyEF6XdK0+ZfblRK5VH88KAMicqOc2xCnFSm3Pg23OF7c3yZ3rZ0VjYt+cgyRLdLEEwhXfjL/WbeEsSFwFztr1I7FacgTqzObf6ty56NDWLKSbolThAZBma3G88FU4HNzEC6RMEyUqnZCSv0z7An2GQAm9HvI0/KNgVhPaHEnIE8GiBjKJ8oFcSm+5bjhul2x0cRQBVOkX6tU6KQj/kwFXnLcjerkaNJ33ECH8Ys3UC9ltWLpvSlKxrVmZ01/pNGNI/X1OLjqYMVxcUkWwXlLqjT0pOWlhs/6TGJV5/Jr6j4Aw31o7/Gy2kzUAqBw6cJcChCe+ae0dQXarGTgaYjApL0+29Pl1XhLukttPrLKN4aHqfyRSMXION04l1GbalJE+ltoEIvV7sgRfS67HW1yJ17ERNrW0RqoawPp3oSmC/pbfRPopRTD93ewK4qsTJdEP102Lusy3jjxJ3a+lbIHr5c+iQ57BPc3UvFpN0gD2jNSRS+8OAj88HwhrUnc4Z0n1GCqb+AsKQ9R1m5ujzhepon392efIJ/lcA02r2gxAe8MzXchQ3n/GSRwRqaSc1cITNeYvNcwobvwRFwMRj4ATX5JDjN27XqwhcrdT8vnACmE7Su+pXN9DyiauKgRwIZAs1NaSLNBKxuiXoQTKezbi2a4TIy2JT2Eugil2GUnaci7VLyNVBL8obNjMJW7D/SXTci1nX1r6
 xZ5Lmkxu
 iVEpAg1p2LQgbpnp/NgKMZwcL0xdiYMMCeozAC3RyrHudSnzD74WcNLMe6sL04vDW1E2P/rdXUzsUz4CyxUR+8w/pojAQFmgxm1KVsa/ZhBT8spYCMgSjr1QJTLv6b+lRwq0CmYSBjQuiooLGkbvxm0vN4L95gm3JD0S6gvryDEbpBo7GTUPpjKgka0KJCIopnxJGvOiNklTaYoLf+pZk3GCP8Lj60Ihro88lqUCZCFglfkNVNQaIjvLL/1a8wbDW8tWsUFtrs08TmxbVSZ/T+2uZC8KzlzFOlXSiMDdg/ebuUzTf4Rz3w4e2GsX5hgwIeO4YrVrkWrbBGHUSX60Y2l9JUe8llih3N5geU5y13gfMwW6zGSerTiZetSIQRhBD56NSekA2f6lxzYEasM4nA8xgiddr7gZoKAC3m1/AYULS6mb0R4qPaNmdrcOl+u9mFighElYlwSPvFpia4Ka231hQCxUgRiUz+Oip5EEqiXDqsUYNLqa7TrsCTLguVlKhhvTdtsa0ElEz/I7Ide4rdkr9n68ZpoK8+6ZHI9o8DcnVuZvuLAlYypZb3m7QiSSCidn+mWnP03l1AuVBk/0YjuVsneFrku19tlZglb+oNcCmRGAHd6CVR80EoxTJRg4OXX9NPq4fbhjnH8UC2jGuuyp6EFavl8gasuAI4qJyG0B6l/uTt56wvWyw6JCskAYCZX6C8e58f1Xs0g6BXk5VwilJFJaT5lAOETg8eBGWb3SKYOo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,=0A=
=0A=
On Thu, 2025-08-28 at 15:26 +0100, Mike Rapoport wrote:=0A=
> On Thu, Aug 28, 2025 at 09:39:19AM +0000, Roy, Patrick wrote:=0A=
>> Add AS_NO_DIRECT_MAP for mappings where direct map entries of folios are=
=0A=
>> set to not present . Currently, mappings that match this description are=
=0A=
>> secretmem mappings (memfd_secret()). Later, some guest_memfd=0A=
>> configurations will also fall into this category.=0A=
>>=0A=
>> Reject this new type of mappings in all locations that currently reject=
=0A=
>> secretmem mappings, on the assumption that if secretmem mappings are=0A=
>> rejected somewhere, it is precisely because of an inability to deal with=
=0A=
>> folios without direct map entries, and then make memfd_secret() use=0A=
>> AS_NO_DIRECT_MAP on its address_space to drop its special=0A=
>> vma_is_secretmem()/secretmem_mapping() checks.=0A=
>>=0A=
>> This drops a optimization in gup_fast_folio_allowed() where=0A=
>> secretmem_mapping() was only called if CONFIG_SECRETMEM=3Dy. secretmem i=
s=0A=
>> enabled by default since commit b758fe6df50d ("mm/secretmem: make it on=
=0A=
>> by default"), so the secretmem check did not actually end up elided in=
=0A=
>> most cases anymore anyway.=0A=
>>=0A=
>> Use a new flag instead of overloading AS_INACCESSIBLE (which is already=
=0A=
>> set by guest_memfd) because not all guest_memfd mappings will end up=0A=
>> being direct map removed (e.g. in pKVM setups, parts of guest_memfd that=
=0A=
>> can be mapped to userspace should also be GUP-able, and generally not=0A=
>> have restrictions on who can access it).=0A=
>>=0A=
>> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
>> ---=0A=
>>  include/linux/pagemap.h   | 16 ++++++++++++++++=0A=
>>  include/linux/secretmem.h | 18 ------------------=0A=
>>  lib/buildid.c             |  4 ++--=0A=
>>  mm/gup.c                  | 14 +++-----------=0A=
>>  mm/mlock.c                |  2 +-=0A=
>>  mm/secretmem.c            |  6 +-----=0A=
>>  6 files changed, 23 insertions(+), 37 deletions(-)=0A=
>>=0A=
>> diff --git a/include/linux/secretmem.h b/include/linux/secretmem.h=0A=
>> index e918f96881f5..0ae1fb057b3d 100644=0A=
>> --- a/include/linux/secretmem.h=0A=
>> +++ b/include/linux/secretmem.h=0A=
>> @@ -4,28 +4,10 @@=0A=
>>=0A=
>>  #ifdef CONFIG_SECRETMEM=0A=
>>=0A=
>> -extern const struct address_space_operations secretmem_aops;=0A=
> =0A=
> Please also make secretmem_aops static in mm/secretmem.c=0A=
=0A=
Ack.=0A=
=0A=
>> -static inline bool secretmem_mapping(struct address_space *mapping)=0A=
>> -{=0A=
>> -     return mapping->a_ops =3D=3D &secretmem_aops;=0A=
>> -}=0A=
>> -=0A=
> =0A=
> ...=0A=
> =0A=
>> diff --git a/mm/gup.c b/mm/gup.c=0A=
>> index adffe663594d..8c988e076e5d 100644=0A=
>> --- a/mm/gup.c=0A=
>> +++ b/mm/gup.c=0A=
>> @@ -1234,7 +1234,7 @@ static int check_vma_flags(struct vm_area_struct *=
vma, unsigned long gup_flags)=0A=
>>       if ((gup_flags & FOLL_SPLIT_PMD) && is_vm_hugetlb_page(vma))=0A=
>>               return -EOPNOTSUPP;=0A=
>>=0A=
>> -     if (vma_is_secretmem(vma))=0A=
>> +     if (vma_is_no_direct_map(vma))=0A=
>>               return -EFAULT;=0A=
>>=0A=
>>       if (write) {=0A=
>> @@ -2751,7 +2751,6 @@ static bool gup_fast_folio_allowed(struct folio *f=
olio, unsigned int flags)=0A=
>>  {=0A=
>>       bool reject_file_backed =3D false;=0A=
>>       struct address_space *mapping;=0A=
>> -     bool check_secretmem =3D false;=0A=
>>       unsigned long mapping_flags;=0A=
>>=0A=
>>       /*=0A=
>> @@ -2763,14 +2762,6 @@ static bool gup_fast_folio_allowed(struct folio *=
folio, unsigned int flags)=0A=
>>               reject_file_backed =3D true;=0A=
>>=0A=
>>       /* We hold a folio reference, so we can safely access folio fields=
. */=0A=
>> -=0A=
>> -     /* secretmem folios are always order-0 folios. */=0A=
>> -     if (IS_ENABLED(CONFIG_SECRETMEM) && !folio_test_large(folio))=0A=
>> -             check_secretmem =3D true;=0A=
>> -=0A=
>> -     if (!reject_file_backed && !check_secretmem)=0A=
>> -             return true;=0A=
>> -=0A=
>>       if (WARN_ON_ONCE(folio_test_slab(folio)))=0A=
>>               return false;=0A=
> =0A=
> There's a check for hugetlb after this and a comment there mentions=0A=
> secretmem, please update that to "mapping with no direct map" or somethin=
g=0A=
> like that.=0A=
=0A=
Ack.=0A=
=0A=
> --=0A=
> Sincerely yours,=0A=
> Mike.=0A=
=0A=
Thanks,=0A=
Patrick=0A=

