Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4DE4CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:48:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94BEF8E0057; Mon,  1 Sep 2025 09:47:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 923888E0008; Mon,  1 Sep 2025 09:47:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EAED8E0057; Mon,  1 Sep 2025 09:47:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 585B48E0008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:47:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0647D1A0717
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:47:15 +0000 (UTC)
X-FDA: 83840808030.13.7EA59D4
Received: from fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.28.197.132])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8523C4000A
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:47:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=Q9JC1tDG;
	spf=pass (imf12.hostedemail.com: domain of "prvs=332aeadb2=roypat@amazon.co.uk" designates 52.28.197.132 as permitted sender) smtp.mailfrom="prvs=332aeadb2=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756734432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+FO6rXzJ1OSaPqvoH5IT1CQYrfHskP0PMe12nrwxRLg=;
	b=S50BKYLe7aoqjSR4intvB7tCg9sbui7WoxLgBIp/LG2JU7pTaghsMx11ZjDg0ln3eKUggL
	iIveIO8t2yfRwSvYueDgK8ZfiL7BkX2/yt8tzN+Le+3+HTiOTH5n8qUTpKbgtSIpDbsbPw
	wCYvzpe4D4l+yyspgkW9SSiep2QO5CE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=Q9JC1tDG;
	spf=pass (imf12.hostedemail.com: domain of "prvs=332aeadb2=roypat@amazon.co.uk" designates 52.28.197.132 as permitted sender) smtp.mailfrom="prvs=332aeadb2=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756734432; a=rsa-sha256;
	cv=none;
	b=kWkIFPpD2ZoA2wMyltpMdbkgIICK7trasXZQxGeAz1uXR6onnavmBVJrDq3XhZl/lOWaj1
	McbS533NjnmUUSqHksUZDTIa7ov6apophYN2hrw2wsO5iKX5IslAecpkPjl1B3CyvphKoQ
	jnVvvbG29Huf43qnDVah02zyQtgRyr8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756734432; x=1788270432;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+FO6rXzJ1OSaPqvoH5IT1CQYrfHskP0PMe12nrwxRLg=;
  b=Q9JC1tDGGmQa8cbTlrJeUFILAHZVn9hv8HoPCtoYm5T2eHgQ9R8CBpvf
   q/+ojK3nXCvA0HBRFselha6Bm9s3mslwgU4T+5bzYjZoHQMhggFc/JPuJ
   PyudG0+YE9ShgQJ5WRgZCGiCq0/2AAKSRlPowtWabB0+iT19U5yHSTvJb
   EC4ps/QZ0UdwkfHkkQ5YZTgQBEiOUXzgWoeY4eTP+iI7ARJAtPBh9aSm1
   eVUdtP+lDPzuQMgY7EQ/2p+ku0wj5Y82sEoU3FEstufT0kiO9cMCvWR5f
   ekeWAZ9AqFLki2cCdePAqoXSr81uZsfLm/7a25v0z3jHpJYvU0EFiN+jS
   Q==;
X-CSE-ConnectionGUID: m8ytizq0Q1qu8e8vIjnAEg==
X-CSE-MsgGUID: iRZ+qBh2R/uOhlJ6+f0jsg==
X-IronPort-AV: E=Sophos;i="6.17,290,1747699200"; 
   d="scan'208";a="1359904"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 13:47:02 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.232:16772]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.42.3:2525] with esmtp (Farcaster)
 id ca3958c9-cdc5-4794-b45a-6e9b3384e54b; Mon, 1 Sep 2025 13:47:02 +0000 (UTC)
X-Farcaster-Flow-ID: ca3958c9-cdc5-4794-b45a-6e9b3384e54b
Received: from EX19D015EUB003.ant.amazon.com (10.252.51.113) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Mon, 1 Sep 2025 13:47:01 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB003.ant.amazon.com (10.252.51.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 1 Sep 2025 13:47:01 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Mon, 1 Sep 2025 13:47:01 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
To: "tabba@google.com" <tabba@google.com>
CC: "ackerleytng@google.com" <ackerleytng@google.com>, "david@redhat.com"
	<david@redhat.com>, "Manwaring, Derek" <derekmn@amazon.com>, "Thomson, Jack"
	<jackabt@amazon.co.uk>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Roy, Patrick"
	<roypat@amazon.co.uk>, "rppt@kernel.org" <rppt@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"will@kernel.org" <will@kernel.org>, "Cali, Marco" <xmarcalx@amazon.co.uk>
Subject: Re: [PATCH v5 02/12] arch: export set_direct_map_valid_noflush to KVM
 module
Thread-Topic: [PATCH v5 02/12] arch: export set_direct_map_valid_noflush to
 KVM module
Thread-Index: AQHcG0bk577bUdlDRkuvvFVSrUyVog==
Date: Mon, 1 Sep 2025 13:47:00 +0000
Message-ID: <20250901134659.32171-1-roypat@amazon.co.uk>
References: <CA+EHjTwDZ-FRV2KfC5ZG9SJYeeMRVUHQ8rVtb9dx2AQwCriPQw@mail.gmail.com>
In-Reply-To: <CA+EHjTwDZ-FRV2KfC5ZG9SJYeeMRVUHQ8rVtb9dx2AQwCriPQw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.88.180]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Stat-Signature: um1iciyw6hbqrb4coze3yhdx681ixe8o
X-Rspam-User: 
X-Rspamd-Queue-Id: 8523C4000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1756734432-675681
X-HE-Meta: U2FsdGVkX19h1T3euOhIkSN/iEccHbslRzj0/9hS+sUHAo3Qpb/oNUEoAoYEclqJvwZ0/+qhe03eVJXr2x8p8YFRPBtTCHlleodR1+YiCce6rP0sYI3egNZ01pYFMyKRt39aXgpAA3ciPXrVNGHCD9XV3K0kPG05Rfq7o3DD2CUhQCX7KxJlOQx0vBEVZCN1z1qe9xUVw0xJBnWXpdsg/BgnEvArmNekm58Y+4hqaR1F0y7TN1fy6SlVtjtIAEu+wHzyDxqqHpcQ8V59omURJI39KDhOQuo/NGfEtF5YCY2KouMh6/eUwhekYpYlbLU8PPQpUC/uV9uTJLJl3ZDCKX6fuDsWok4m26Q5qIVEk2ofGpfsw+xFacxQazjB7jVOXVyYM/r4aPe4EdYbeELhwkIpBD4Axkdh4zaU+oBhskjqvn03sLvICpTIMrmJim1Xu02E39w12uAk6dUSb2syrqnGs9jBgmvlNUI9XFD2mX33mQlGbIKZOg5uIPW5/yPgV4kpGjUyA4KFhD2KjG84mjgV5LsHMF3bIB4dqJs5dyyhMbpGW7nV+U3v6hbH2MN5wUgXz7h2P7jKv4EBeMY3QRqe27cTxzI6Y62JcVV/on+L6VtByv8lDZD1vAOZPBzc3zy3JW/eoKCMtYvnx+rrRToxGJ2eSWBKEaztmXSwImIXYhqrFhrSdmfqXzqCYU7eeW5XK6dxa3WCHbz6qsSWQYnw0322sXFYN0DNVDm5//mligsd7XGr9jc5+Uy5kUaF5Vh+D98HVqRaXcMBx5JfrjYrjZckSshI5zTpbf04A1oVxE/aIeLLeccISaACNCasy7aU6eCmF9FfHFMgzFTUQV8/Oi2ff+yWU34qSb5oEUyh8/GYjN2kWNF9WwBXPB2+dBkyFGBgTnmx1Oo8dRVDQmEtIx9647hfQCtIQq9+4jZSDhaO2obn/t/520MdovVqxyL7k8FBuRnOcYcNaIP
 4594smcC
 YUbCvPtivNR775TYaKBUVF/xeMkXcsEUmvjmS/OVmGSeuQ8gni3hxmir6QWrerodYhlPPeR4xGeCtz00m38n7MPpJtSkQjVP+B9WUzJ61U3OnauSDMY/RzC6WPhcwZ4o2S67B4DoLAykf7YbGF/adKgN7JmfAnSc2CdFECHsJRhthlWgV7+DUOYp4IkWHv0fv31rTQpHw4Kh8Cb49AD5K5xFXblJv7ajNOEbN2zA0paCIhQ9U+7IY1GOhZNdhlq/EVaP/iH2V4+KS726B8QE9gm7DSHdmU1uMz3+flGQHV9jD2vjWW3yo5lzy5YvTK/w3KLPE4GAIvbQFCLCgN9qRYKw243a117TbW7xfSJ7aTVasDNJDlUD+cxfljE6uvLhg8xn5vC1bmnhGivvldAt2Q238EWR1fQIE1EPUZo0xdIUlRbHtxXdYBcJ7XLp3h4yTUDOhg7GXw/dbIv5uuaMrXtEHnphbhWXePLzT//JGtF/4bENDfvyiMmsb4OYay5tk3dM2J+fKDUSAytjNAN2as1AvHSVlJMW1nlpfpNcIxb1eh5WZXXa0ljrHb32nPyHa0HPCqqgiWjgnCG26Lk3PdRJQVkNwdo3h37Tmy6zAwN3qJnUlDK5d2BQOqiPTaPnO6amhkSMg7GNMXRM3jaLX2ueu4pMFXGcdjQHiLIBu1j4fzUDbBpfJpHY06qtK0TIl4X0S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Fuad!=0A=
=0A=
On Thu, 2025-08-28 at 11:07 +0100, Fuad Tabba wrote:=0A=
>> diff --git a/arch/loongarch/mm/pageattr.c b/arch/loongarch/mm/pageattr.c=
=0A=
>> index f5e910b68229..d076bfd3fcbf 100644=0A=
>> --- a/arch/loongarch/mm/pageattr.c=0A=
>> +++ b/arch/loongarch/mm/pageattr.c=0A=
>> @@ -217,6 +217,7 @@ int set_direct_map_invalid_noflush(struct page *page=
)=0A=
>>=0A=
>>         return __set_memory(addr, 1, __pgprot(0), __pgprot(_PAGE_PRESENT=
 | _PAGE_VALID));=0A=
>>  }=0A=
>> +EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");=0A=
> =0A=
> This should be after 'set_direct_map_valid_noflush', not 'invalid'.=0A=
> =0A=
> With that fixed:=0A=
> =0A=
> Reviewed-by: Fuad Tabba <tabba@google.com>=0A=
=0A=
Ah, yes, good catch, thanks!=0A=
=0A=
Best,=0A=
Patrick=0A=

