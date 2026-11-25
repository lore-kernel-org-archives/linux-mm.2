Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C8DF606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 16:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fVme2v5e
Received: by kanga.kvack.org (Postfix)
	id 866006B07B2; Wed, 25 Nov 2026 11:59:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 815B96B0A89; Wed, 25 Nov 2026 11:59:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 705216B0A8A; Wed, 25 Nov 2026 11:59:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4FBF86B0A87
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:59:22 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3E4791C4A4F
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:59:21 +0000 (UTC)
X-FDA: 85474252122.16.CBF05EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8F3E540011
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:59:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fVme2v5e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of naveen@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=naveen@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795625959;
	b=piP3G8HIbbgq46Huacm1wXjyKbsBfxLTK55DyHHrhVdW1VyFR/aVyLis/MEnvisr4j/A71
	zEuxoSTRww+OWwbok7RmTJaX9yKYqgoVIxPf+SCokW+HX5nqp8vyx4JbPgX9eDNO9Or8AF
	DBaQWDdFiTq/EyOye7YRoWki1gJAdjg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795625959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SQQncmT/Wl6HjAYO86rxtIdewDLZRTGF1ImjCznbro0=;
	b=hHzrz0PEVU8Ttg908FBDDgg8Bq8W4S4nmLt7PgCDNu5Sz3aGtBa37okCbdDuqCk6iUZ3kI
	UzZBcs5jeTwck3YQc0lqlBVDLNb2oWJk6vyV2jO0bcQRJxnlu9Rbx3QD/kb05qNS9SFe2k
	pRlk7teIMKzN0FgrFvb/eZHaTznIyzQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fVme2v5e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of naveen@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=naveen@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BDF5B6357B;
	Wed, 25 Nov 2026 16:59:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8781F000CF;
	Wed, 25 Nov 2026 16:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795625958;
	bh=SQQncmT/Wl6HjAYO86rxtIdewDLZRTGF1ImjCznbro0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fVme2v5eVWqiLG0XGEngRTj1/NVlH0UMgFocxlSeVjVX2ycDVpQAifztQ15Vq10Z5
	 U8xROKTCan77H2WbJFVeTgociB03xuPMESscTC9KZ3zvET4zsNw/cPWxuz3bkjeYZ4
	 NItB50dhzTZLjf9Asc+cxUQbsBcZpFCU9qrKIFLXR7hqdpCar5sF1M9kZXpLL4XKtr
	 C0hWaq5rt13hbQy+zdChaHdxiiJ2Q7luPsJ/3b3S1soL62j8ZiTznhixvNZEedvygh
	 mIe7FgvX+xQAVN5eGLOQ7s4CxuCzIvZfYCnE9WXt8V638MeR1b/LAaDFP19o4QSL0E
	 nk2IMpW1gGFcA==
Date: Wed, 25 Nov 2026 22:21:38 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Nikolay Borisov <nik.borisov@suse.com>
Cc: Pedro Falcato <pfalcato@suse.de>, Dave Hansen <dave.hansen@intel.com>, 
	x86@kernel.org, mhocko@suse.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@kernel.org>, 
	Vishal Annapurve <vannapurve@google.com>, Kirill Shutemov <kas@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	David Hildenbrand <david@kernel.org>
Subject: Re: [RESEND PATCH] x86/devmem: Drop /dev/mem access for confidential
 guests
Message-ID: <awcMnXKDWjTvxumG@blrnaveerao1>
References: <20261124160025.738362-2-nik.borisov@suse.com>
 <0dc6759e-ada2-461c-85de-809c170abd6a@intel.com>
 <awXBtrPSHfs51Y2f@pedro-suse.tail5790ac.ts.net>
 <8500860b-d2ff-45c1-8604-28a2b3d66382@suse.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8500860b-d2ff-45c1-8604-28a2b3d66382@suse.com>
X-Rspamd-Queue-Id: 8F3E540011
X-Stat-Signature: 91ighhdjhgqdb6qx6bmjhszwmtz6rooy
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795625959-522608
X-HE-Meta: U2FsdGVkX1+iN6v8hnzdQBhqA1Hr6xdzMDcOlTj8tO5Wo3xkEJzV1WleoYQ2fX7b02k0oQtiSacoXJEVRKXvM96pHekbd+NnxVdl1rccWN8JfKUIh8nzojlbcnWjI6YjSNL3Tn7N1k3UzFAURoYrv22IZGuFko63r/MUm2bdRvxOGrosDooLMV7FZBl0MYW9B1XJGDRrHAN/DY6T1z1rWgBvng+b1GfRbfSThCQUGC4NWS7jWbs+hUbPyDAoo57BCrRcSUJL8lSoBCl9dBo8V0WKI1C+aYQpbOu0QAaMCUI2oW9bxQid585wIlW+pjuE7BibPd9fv7RK72TLNXMdZBQSK77wSA0e70iSP+w3t9aLivxJ+CPIFgLpJ9EJ5AkWBuiN65p8J45lJaj4PMRneEKz4cmqZMUA6azGsjwQlb39s98XcO/bWszg6DwqIDerHqIARplH9+vUDxH36me6sQUs5Sm81kXIzOZ5U3+I4L3tE99v0SPbgaF8k/yDVN08cc/5SfhqRVv0bAoUC9ynsDTzRPZmGxhRtBeZ+EQvHzpBBMP1x125JgO/cBSDSTUAFeD+oKB9Tlekx4Ov7vVcdkTclVcy5dA/4yukecJyFpafVI4SV+QNgHYN5sNiwFqhQhlivBNifXqhxH5Au6g0MNPLMzat893lcql2i21qex7SB2QlnPYrsgwupsVbxw/N2KwtAma/73bhHNiR8AdpupV3dxYeR4jEI09+p1qjRg9Otw9lb4xwkzZ7nkBvp4jGeKhuz14BNfP7h7RbCcgNxEYfxkT3PEd1yl4ucej6i+reZIu5Hzhdf9jI1MoTgDpTGDcLE8lk6SkYvQAdZjMRMDMTypGbYfPueHfPEvPiSQvUS0w8d9AI4Q1V5WdJDFbX/aIno36OF8Iv0zjWtyzzDOdsLfcOBofh/vIqdEt8m11UPqFo0D4knZw+TRdmmcHIyBLtF0ADPTiy5UlH91a
 QgiMVRGh
 K/7QxIZRWtcaoMH9DErUVFaoAJKNzlVfcBjbquzPTjxX5qSDqjDQPiM2Y8YzalQTvYGQUu/J1sjt0D1LCkjBWOZ82xij55AEKzHUm3A6FVdLsOMhgYV6ox1H/gU9jhb5TH4n5pJWK1sGoW8mXJMdtsWWgqEkcEzsEdi6JDEwCuFw9zzTKRtsGyGAWH3VqOdkSX1Gn50KvbjEODDs5pMJh5k/HfijL6rEf7/NhLj134mjKQlACikeV5IpCg83GqqvF/o+sDyynjizdNbepHD8bx3UT3d+gNQQUSFsMInVZILMq2T/CiWiJ9kVct9guAz0ng3//TzaoCMigStZTS46pTnpNOkPCqWINk1f6VqIrBUYUm5Fkp8mfkei3tzUWCGlUN2pQzFzprrrxHUBZoHlZdEKJYSCwOC3ofsvvfHGoa2uep/ouNUUSlxAu/wrae+vmo1xQ8mfQRZDVOmF9MJw8tjY4GVwX4oMxalv0sn8/VtTz/HwsuEwERUcR92nDRW4fj83dYCOKkcqn4+gNmJ9avPM6kg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 07:57:05PM +0200, Nikolay Borisov wrote:
> On 24.11.26 г. 19:10 ч., Pedro Falcato wrote:
> > On Tue, Nov 24, 2026 at 08:36:45AM -0800, Dave Hansen wrote:
> > > On 11/24/26 08:00, Nikolay Borisov wrote:
> 
> > 2) open-codes random CC checks in mm, which is kind-of regrettable
> > 
> > OTOH, it's unclear to me why that CC check is needed. If configs select
> > STRICT_DEVMEM and IO_STRICT_DEVMEM, shouldn't it Just Do The Right thing?
> > in iomem_is_exclusive, etc. If not, could the CC awareness sit there
> > instead?
> 
> Well, you are right that if we retain just the select
> STRICT_DEVMEM/IO_STRICT_DEVMEM it might fix the immediate issue. I don't
> know why eventually Dan decided to also add this check, I guess it's an
> instance of "fail fast".

Actually no? On x86, devmem_is_allowed() allows access to the first 1 MB 
area, so STRICT_DEVMEM alone isn't sufficient.


- Naveen


