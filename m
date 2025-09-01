Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7CF8CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 14:33:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A3C78E0057; Mon,  1 Sep 2025 10:30:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6540E8E001A; Mon,  1 Sep 2025 10:30:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 569EE8E0057; Mon,  1 Sep 2025 10:30:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 39DBE8E001A
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:30:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F01E61DEB77
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:30:15 +0000 (UTC)
X-FDA: 83840916390.02.CB85EBB
Received: from fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.65.3.180])
	by imf27.hostedemail.com (Postfix) with ESMTP id 74EC54000E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:30:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=VuHQf2G3;
	spf=pass (imf27.hostedemail.com: domain of "prvs=332aeadb2=roypat@amazon.co.uk" designates 3.65.3.180 as permitted sender) smtp.mailfrom="prvs=332aeadb2=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756737013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dLl1oyt4RUhXcYIWGbyNXvmAubTcFciHIOgmTgsswPk=;
	b=hQcH+1pfN1dkHH6IZsZWDVQ4BMyPlNdheCxMQlrh/LJhGD3I6rauC9HrEg61X/ec8A0DtV
	rNU5fUMAszdZuIVYWYGfYUl4+E93OJ1sEqCszMK1dCJ85YXmh2hsDRkcKn+KmfkAwUG7vH
	fkrUN1VbDjsIjxC2ETcEY8Ioi09hhQE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=VuHQf2G3;
	spf=pass (imf27.hostedemail.com: domain of "prvs=332aeadb2=roypat@amazon.co.uk" designates 3.65.3.180 as permitted sender) smtp.mailfrom="prvs=332aeadb2=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756737013; a=rsa-sha256;
	cv=none;
	b=A7hbSVx5oNHvaS8fTWRl4gvpY9ZOC5u6b/lOj93AX2C78sIemi7gwWIFoKIIPmU8zJ+/lD
	dk4E25EidpJnTMYKJd74KBjdmfVdSQgpwIj4tGFv+v27AbIgqWUcx/buW4+OrtsfGPBXGI
	7kFrQg7zb4GY8fJUSQ2j1K2OAYLhCAc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756737013; x=1788273013;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dLl1oyt4RUhXcYIWGbyNXvmAubTcFciHIOgmTgsswPk=;
  b=VuHQf2G3X+O31P03imHyX7UqH0pxCxOzJQru0BCLtCvVGv1MziPREAuV
   ZFjjTawKZZRMRxC9ZkgvMfwv8LoMafLl+0rcHcHsJByCO/m+uoXUV0anS
   PJCLWibnHgdAvYjDf7+DD6deFZHcxMWArmJi0WgmlwX9RA1flIhpRL7vz
   pjhFZJe7c715lCVSCOV0XawTr8o22DeWOG9XmLTvKNJW58dgaITH/oDKc
   Lg+MznA0VjhOFsSiwhka9tWET4+5aPBT7mN6UlAPKDHfEoubaBq2OK4oU
   +E+MUABMraRztQKs07Z7XFfM7OB96Tpx8GwaYY3X0Ut9fLYP5zddwprKn
   A==;
X-CSE-ConnectionGUID: 7B/ba3PkSy26ZXnwYQdRbw==
X-CSE-MsgGUID: s/0fbb7eT56B6Mg2WRcDHg==
X-IronPort-AV: E=Sophos;i="6.17,290,1747699200"; 
   d="scan'208";a="1466996"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 14:30:03 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.234:23216]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.18.194:2525] with esmtp (Farcaster)
 id 24b98d19-0a60-4c24-a3c6-c81ad810034e; Mon, 1 Sep 2025 14:30:03 +0000 (UTC)
X-Farcaster-Flow-ID: 24b98d19-0a60-4c24-a3c6-c81ad810034e
Received: from EX19D015EUB001.ant.amazon.com (10.252.51.114) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Mon, 1 Sep 2025 14:30:02 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB001.ant.amazon.com (10.252.51.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 1 Sep 2025 14:30:01 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Mon, 1 Sep 2025 14:30:01 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
To: "david@redhat.com" <david@redhat.com>
CC: "ackerleytng@google.com" <ackerleytng@google.com>, "Manwaring, Derek"
	<derekmn@amazon.com>, "Thomson, Jack" <jackabt@amazon.co.uk>, "Kalyazin,
 Nikita" <kalyazin@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Roy, Patrick"
	<roypat@amazon.co.uk>, "rppt@kernel.org" <rppt@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "will@kernel.org"
	<will@kernel.org>, "Cali, Marco" <xmarcalx@amazon.co.uk>
Subject: Re: [PATCH v5 05/12] KVM: Documentation: describe
 GUEST_MEMFD_FLAG_NO_DIRECT_MAP
Thread-Topic: [PATCH v5 05/12] KVM: Documentation: describe
 GUEST_MEMFD_FLAG_NO_DIRECT_MAP
Thread-Index: AQHcG0zmqnuL2jS1NUKSUglbGWh4mA==
Date: Mon, 1 Sep 2025 14:30:01 +0000
Message-ID: <20250901143000.5017-1-roypat@amazon.co.uk>
References: <786503d6-e58d-412a-a17b-f5e4e481c3fe@redhat.com>
In-Reply-To: <786503d6-e58d-412a-a17b-f5e4e481c3fe@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.88.180]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Queue-Id: 74EC54000E
X-Rspam-User: 
X-Stat-Signature: i6eq4k5so6h3ob93hedbbm711fsttfwi
X-Rspamd-Server: rspam09
X-HE-Tag: 1756737013-161961
X-HE-Meta: U2FsdGVkX1/HOmQQZJm7MLISw3AIQcejZp7sQ9DixvqMdhLDQawgfhd7SdpQb2W3D7JbvjW5/DZUGG9rNJI0gnxI56FArubZzEQxiiwCcQfCLO9gXPJk5qRz4T4A3yMW/dED3CsvmHlS6yNUQeVotFsWn7BOooMUEUW5hz7TTZXQuo30on5b0aIrp9D1CqdRiRQe2YUV0lIGBGrAiSgqEUPZ3p7MhPTjg9Z+dla1FvlZZ118nDhWyCm7n9XCfojhbds3ywb8CDgsWCFqJ8W3A2cSTlmoD7pP/k+vhLL80RlKxVdVtkHaGBNhPxnWgWzRfFweVuGedX1Q5pI1nUpA3hE8TVBJV8oQVfMo2euyNHLPvUCh55xPlESj+cVe3nDDU2MJUpjsRHCetflVBQ37XPPsN4zElwUqCmnt5Wqc4ZgFcIkhqtD5F025u6c6ikp4GHFd3qBkH9QQT1YXEsQqTL0vNNOQL7hsjtByRTUF9Xxt5zongaykFnWiENWU2yelLV6H0BIzG6ui7hJAHOnwd2Xim/TsYdvVHLynW0ebTT+0tY/XN+CQ4wJHyFL6lr3VsygKxDiqcRRBSHhyaqck4CMUTXA9GqkU5kdzE02QxjV7yyNv4H7zNvKnsrhLFjv0G0J78b5lQ5ul5qolcUcwt+QirkyEnjEKlUdZithLMWy1HApv4OG4XnSMDBgP5A68O5cGTrT6KyH2jyGH1N1S7O9h9/xlNUvt/OIp+u+Po8f/434RkhbSyjrWTkxl96EhFRUgut/Cgr0VbcNz89kXD/fdR0In/Ca5FHPE3/siDwxczNudBq2U/7W4ywDufUBb0qqwBg7DCZWHGADf1SSx6R528umCktLd/FFw+Ar+3fIo/cEULUbapKgW/L4YZea+/OQ/WS8xaZ/cSprbliML+9wi+wXYrAQIo1K75GXA/o8eTHZUDGzObVwkeWY4aEho/whUSMp05/+QeJp5WjL
 39eGBYqI
 xT/s+0u0xas5VYphl3VCsVZoUzbv5xfhlsYi3GYXEVV/TvTghmsWwbrfrVAIs0yKJVjr6L5t1aD2xavLnFqp5Yx/i9aFNnxhKIVWroALiF4RndY7/C8bz2RkLkM0uRGARn6cqbQo21TClQl32+sCO9VcWJjqZ9PtYrcL5L6WA/XWSL8PrPVyEfD3N8uy27OHAJwprSdzfMyKLETJJ7c9YW7FlHV6WQJFcOBu4Dv56o2/iGtuQT1XNZVAB2ysMTCHAPYaM1ZMJ4V+fPh28awemOrImaLhkTrWTMQ3txagiCbJOWZ2o+m6gbBbgR7CVImO+j2cH7pQjNI9P6PXAK5uhjr1MGzLF8CFMG3xgv6tt1LtF23+HUBZ3gN2cJfdpGaHnB6A5PyA5KCwc3FuCAcb4fxuuSEa46upveTzr8pmzbUHEinHNAiMyM3hHDSslutXH0HTXa2lc05RR1GkW2wThTHXndjyNmhIPOqi5cT1i+WTq7iJSPQYqR6xKQdJxJM6EDPOK3HBpWXn6h9ft09zDQ+DKAzNTU7A1tITyDm3gBeUUM3KkQbwoxlI5hDkfnulqsrJ9zdyUwu11p9AQe3iXTZaexg2tuDUZpWQOKhnVMu2fA+a0mqyG4kyr3A1z5nyTqa/JWn79Z4hvhoiuorG9GGQM1rs3Wp0vCc7r+9xdhbJjI7yDFJuW11FKstJN9bRgbIUxlMw7Xk05UsPs+pRbhyAJ50u7BS8jwZD9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2025-08-28 at 11:27 +0100, David Hildenbrand wrote:=0A=
> On 28.08.25 11:39, Roy, Patrick wrote:=0A=
>> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
>> ---=0A=
>>   Documentation/virt/kvm/api.rst | 5 +++++=0A=
>>   1 file changed, 5 insertions(+)=0A=
>>=0A=
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api=
.rst=0A=
>> index c17a87a0a5ac..b52c14d58798 100644=0A=
>> --- a/Documentation/virt/kvm/api.rst=0A=
>> +++ b/Documentation/virt/kvm/api.rst=0A=
>> @@ -6418,6 +6418,11 @@ When the capability KVM_CAP_GUEST_MEMFD_MMAP is s=
upported, the 'flags' field=0A=
>>   supports GUEST_MEMFD_FLAG_MMAP.  Setting this flag on guest_memfd crea=
tion=0A=
>>   enables mmap() and faulting of guest_memfd memory to host userspace.=
=0A=
>>=0A=
>> +When the capability KVM_CAP_GMEM_NO_DIRECT_MAP is supported, the 'flags=
' field=0A=
>> +supports GUEST_MEMFG_FLAG_NO_DIRECT_MAP. Setting this flag makes the gu=
est_memfd=0A=
>> +instance behave similarly to memfd_secret, and unmaps the memory backin=
g it from=0A=
>> +the kernel's address space after allocation.=0A=
>> +=0A=
>>   When the KVM MMU performs a PFN lookup to service a guest fault and th=
e backing=0A=
>>   guest_memfd has the GUEST_MEMFD_FLAG_MMAP set, then the fault will alw=
ays be=0A=
>>   consumed from guest_memfd, regardless of whether it is a shared or a p=
rivate=0A=
> =0A=
> WARNING: Missing commit description - Add an appropriate one=0A=
=0A=
Admittedly wasn't sure what to say that wouldn't just repeat the commit tit=
le=0A=
or the contents. Maybe that just means this shouldn't be its own patch. Wil=
l=0A=
squash in the previous one (same for PATCH 11/12).=0A=
=0A=
> WARNING: From:/Signed-off-by: email name mismatch: 'From: "Roy, Patrick"=
=0A=
> <roypat@amazon.co.uk>' !=3D 'Signed-off-by: Patrick Roy <roypat@amazon.co=
.uk>'=0A=
=0A=
Heh, my git config only ever uses "Patrick Roy <roypat@amazon.co.uk>". Not =
sure=0A=
where "Roy, Patrick" comes from, could it be the mail server mangling thing=
s?=0A=
=0A=
> -- =0A=
> Cheers=0A=
> =0A=
> David / dhildenb=0A=
> =0A=
Best,=0A=
Patrick=0A=

