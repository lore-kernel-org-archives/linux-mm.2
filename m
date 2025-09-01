Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0E5ECA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:54:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAB758E0020; Mon,  1 Sep 2025 09:54:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B563A8E0008; Mon,  1 Sep 2025 09:54:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A8B38E0020; Mon,  1 Sep 2025 09:54:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 729C08E0008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:54:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1C02213B20F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:54:23 +0000 (UTC)
X-FDA: 83840826006.30.CDE2A89
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	by imf13.hostedemail.com (Postfix) with ESMTP id 87C462000C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:54:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=L6qa3VBg;
	spf=pass (imf13.hostedemail.com: domain of "prvs=332aeadb2=roypat@amazon.co.uk" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=332aeadb2=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756734860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8FXGRJshnSKv4swI9rc/O7cu1N6KjNCj8MEEMoNffZ4=;
	b=tl2EOPPS5r7VPwbn1jQZqGc+WihwbXzIscsnu7r8LNxQBu88f4o9apvKqt45vlMLehhiLB
	NkjiOZf2pGPiTKj85GYmrMOvNUgFXEleE2icU7SKicf2xXFDawRf4IrtLjCghdF/U69SfA
	KC4UX1fdqmTN+6OeezaKPU4L6A4DE5s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=L6qa3VBg;
	spf=pass (imf13.hostedemail.com: domain of "prvs=332aeadb2=roypat@amazon.co.uk" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=332aeadb2=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756734860; a=rsa-sha256;
	cv=none;
	b=7asPR4kkfzeZH4m19t6KSAwYSktQ4WEqyL5ad0DjKfK1hSn39QjBbyJfxghINeRHCvPFld
	g1FFwz/KBOoDeRbbcDW1rpivMRtE1ZYLoQ5lAaCvVxUGP53U+12h0hWjHapzS7wAu7leFc
	qwQhTeW9Qy88w6YsRDQnm74uC/uL9pI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756734860; x=1788270860;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8FXGRJshnSKv4swI9rc/O7cu1N6KjNCj8MEEMoNffZ4=;
  b=L6qa3VBgGo4Wrug0eZbuFet7BrbBylLadR5+sL0N+EQgb57sSVE7H9Nb
   5eB1+7p6nTBpwXClbMFrolnfsDhm+98hlcXvLW6PlO2gd2tuK1IxaWdUk
   /tQjNjksCD7LL35qcGv7ZebbqxBxX1PvNiekWwppPRYWgT+fCMh1k/W6p
   QoChBxJ4SgYjPPhPtebaMR0Eyx7C+0ygcdbkBUhAqss3D/Sx/QrKpkj3r
   liErEDWv9BgVDQGYZVsqZCarB2MmmQ/Y1q6oODiCPJt7e+Nh79YLIXWi0
   WqK738bl09/dHok6gfjy6uhmHy+c6/h/Kv0zkXZ3oq1YIdPpIeH+yr+UE
   w==;
X-CSE-ConnectionGUID: gggXs4BvTVmSlkjjgWje9g==
X-CSE-MsgGUID: ND6y5eCkQmyPHrPmUhHHJA==
X-IronPort-AV: E=Sophos;i="6.18,214,1751241600"; 
   d="scan'208";a="1463813"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 13:54:11 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:18474]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.3.140:2525] with esmtp (Farcaster)
 id 6c2ba49e-6c86-45f6-b459-405011a28a46; Mon, 1 Sep 2025 13:54:10 +0000 (UTC)
X-Farcaster-Flow-ID: 6c2ba49e-6c86-45f6-b459-405011a28a46
Received: from EX19D015EUB001.ant.amazon.com (10.252.51.114) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Mon, 1 Sep 2025 13:54:10 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB001.ant.amazon.com (10.252.51.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 1 Sep 2025 13:54:10 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Mon, 1 Sep 2025 13:54:10 +0000
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
Subject: Re: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
Thread-Topic: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
Thread-Index: AQHcG0fkqK4jccjXtUKv/NLtaS3P1g==
Date: Mon, 1 Sep 2025 13:54:10 +0000
Message-ID: <20250901135408.5965-1-roypat@amazon.co.uk>
References: <CA+EHjTxOmDJkwjSvAUr2O4yqEkyqeQ=_p3E5Uj5yQrPW7Qz_HA@mail.gmail.com>
In-Reply-To: <CA+EHjTxOmDJkwjSvAUr2O4yqEkyqeQ=_p3E5Uj5yQrPW7Qz_HA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.88.180]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 87C462000C
X-Stat-Signature: e8ciu34qn88y1xn71wecenh67fuaqupy
X-Rspam-User: 
X-HE-Tag: 1756734860-367834
X-HE-Meta: U2FsdGVkX19TaNN4f1kXqRUBcfhWEoREPU95Hkg3klStSRuwaJUeM6wKXEXx8crvzuTXzuBQQgV/ZepwL61MnzMkdPGt+1+et1Qbf01m/zP8cyi+xxHE6vbpxb43dilwMz1oBiIXpRk242RETI6SV2SvqAery2/k2A16yza7R4sjjXZWw4pV21ajpyf3XSNaUNDP2PRNAweKbsyBSBynfJfL8CDgCOQLGKehT4GMlFhanKKvRJ4VJfSr1VaQgiREfeiuczSCzwN3t3bUaWv+cqaOO/pml60eoMd+8w4PR9nJKpfkryp78URGU0OT16XvpU7JRiBCf9N5u7PO8ofQcEaSNtqWhpWszLYC7xnuAhWIB8/L54Aa8l699M7Bc8YqPXdwsrZ9qzghAeg9keNaqGV7CiV41bGyxpCl8sG7t0TCHMj7mx2vcfXmFiY8fLJChBvpeBIQt7oezgpUGk8lz2/jZlYqLXAWtUXWeP0zWrlkwu4rhjypUpehiBg7A4NQYnTUw0F3RKS50J4AOrm80Jx59mY8HwaSkAgql55eV90GSRVkcavOfEvRPY4c39qc6Di1Mot6bFyePywcyCBMnfs/v5sPGM2gzqOXeUzAcpd33yVjTq08RtdGLYvDKeexL2xHw74zUKtQjiQS7GZZDNWAVwzHq2hqWjUowVK3lKEv/Okpw8iRj1F4kl2TmkbckPGUlvFsacRoz9LwIeuoxssXsm7UXI1n6Vp2jTtjpLLubLDapkOfblWQcB2hSSiYxAMyg7AiFWJk2in/ThFdJFGEIpcOIRXjvTijfSBQ+Y3yKEQGIZPPtKKF++3F3Jf8ERblMI26I+30fJLnq6TpsSr9ZUagqkQPaScdhypELeXLbu8nrlc8jiW6/yhE+CgkU3dEXz0/BDcb2EPP89+Bb4HWy9V+3OlZa+x8g8Njxg/o126qdx9w207oXvUF/oNFDfZUoeLkdt3AcTq7cwd
 GTmFgXga
 0EXqnlHb3EeiX7bD8aDveldoFlQtRCYzAhL5kTJzbm6yvXk2tHkIojIp/dU+nGmhko1/2znWm/whoqSTJG6Xp+bilnRc2OObhVZzqVxIG31ae+Qy9vIH+CRx+gEptFEdTR3shw7+sRbbXiwTzlvrGWZUEINGV4NF/U5oJNnyHh5jBuFyru6dMYr3Qn/A4MKvRuc9V8IdM3IZtMB5ghPrSBJe/y5c8pyAtgiGuqRAyrz/N7wG9QIjw2dU9kdWObEeude7V1Y61UCH0G94oZEmNY8G4d4U+J9s1tU0ULn6LBgzm9HZP/eehdb6VPO+oJyP53/SBwBrmbQ+sPBMQCxGG8z+/YGwzxw/Cc26FK31Odo/2YOjyaZxvcEW+mLQ2AtlYqWdCdZaLVqmeh6VV9B5Ri+5lUFc8mReHT3LRse/fqhvZUPffgUoEJDFz8hoqZHu5NlD0L2LzDol45P05/rDhq/c1M6vBN/M8rxX4/HCe7eYXez6JzhhYJAs0HAsmH5SxHD3LmbogeiieOrX8vNvpEL8Hid9wEgutuv+bI4PxKjku1Zl7hXsBra22q3iRqmP9IFEDtaR2S/jOra662rKWNwLYfXXGfMAgJYmZVX2162t48efMaP+2bZvE3v9V6Xdu5iE+1R3F2pte6/BdSozBBXW8T6IHib+cESjtoyAfehSWZrarax60yDf7WQNMjpyPBytCxRjKwgS2ynC3oLMUWrE40gyIZtX1YWkbX1Tl+bPb69Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

=0A=
Hi Fuad!=0A=
=0A=
On Thu, 2025-08-28 at 11:21 +0100, Fuad Tabba wrote:=0A=
> Hi Patrick,=0A=
> =0A=
> On Thu, 28 Aug 2025 at 10:39, Roy, Patrick <roypat@amazon.co.uk> wrote:=
=0A=
>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h=0A=
>> index 12a12dae727d..b52b28ae4636 100644=0A=
>> --- a/include/linux/pagemap.h=0A=
>> +++ b/include/linux/pagemap.h=0A=
>> @@ -211,6 +211,7 @@ enum mapping_flags {=0A=
>>                                    folio contents */=0A=
>>         AS_INACCESSIBLE =3D 8,    /* Do not attempt direct R/W access to=
 the mapping */=0A=
>>         AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM =3D 9,=0A=
>> +       AS_NO_DIRECT_MAP =3D 10,  /* Folios in the mapping are not in th=
e direct map */=0A=
>>         /* Bits 16-25 are used for FOLIO_ORDER */=0A=
>>         AS_FOLIO_ORDER_BITS =3D 5,=0A=
>>         AS_FOLIO_ORDER_MIN =3D 16,=0A=
>> @@ -346,6 +347,21 @@ static inline bool mapping_writeback_may_deadlock_o=
n_reclaim(struct address_spac=0A=
>>         return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->=
flags);=0A=
>>  }=0A=
>>=0A=
>> +static inline void mapping_set_no_direct_map(struct address_space *mapp=
ing)=0A=
>> +{=0A=
>> +       set_bit(AS_NO_DIRECT_MAP, &mapping->flags);=0A=
>> +}=0A=
>> +=0A=
>> +static inline bool mapping_no_direct_map(struct address_space *mapping)=
=0A=
>> +{=0A=
>> +       return test_bit(AS_NO_DIRECT_MAP, &mapping->flags);=0A=
>> +}=0A=
>> +=0A=
>> +static inline bool vma_is_no_direct_map(const struct vm_area_struct *vm=
a)=0A=
>> +{=0A=
>> +       return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_map=
ping);=0A=
>> +}=0A=
>> +=0A=
> Any reason vma is const whereas mapping in the function that it calls=0A=
> (defined above it) isn't?=0A=
=0A=
Ah, I cannot say that that was a conscious decision, but rather an artifact=
 of=0A=
the code that I looked at for reference when writing these two simply did i=
t=0A=
this way.  Are you saying both should be const, or neither (in my mind, bot=
h=0A=
could be const, but the mapping_*() family of functions further up in this =
file=0A=
dont take const arguments, so I'm a bit unsure now)?=0A=
=0A=
> Cheers,=0A=
> /fuad=0A=
=0A=
Best,=0A=
Patrick=0A=

