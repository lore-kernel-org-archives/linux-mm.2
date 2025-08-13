Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EC33C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 14:25:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F26AA900096; Wed, 13 Aug 2025 10:25:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8935900088; Wed, 13 Aug 2025 10:25:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7812900096; Wed, 13 Aug 2025 10:25:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C0B0A900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 10:25:40 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6E25282C5B
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:25:40 +0000 (UTC)
X-FDA: 83771957640.21.CD75579
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf06.hostedemail.com (Postfix) with ESMTP id A5DC5180012
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:25:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ErExK45K;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755095138; a=rsa-sha256;
	cv=none;
	b=6ONyKVVzQjBXV2ZjcaG1ok3KudD09QdVenTwjtsOxD8nsaAbMBHLsCZ27BTIXF86JmOFP6
	6WSnG8u2cyIqEXElOayTXoBpiMIU+jufg1VYPYBKJzB98bcjobGYA02jRSDpShXaSex9Nr
	8cu+cejCMMqZ5qmSBlcCpcTILbftqWk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ErExK45K;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755095138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HRNTXRYfcLW654zREqydzcRC5UuFcZMiCEgImG3T+ZI=;
	b=GICmlkDMQ1FFYjEV8L8OlYtPRnTrSeYghUN08WSTiCPRjShoqOhh2U3FYRLxtECaOMt5lS
	R+8kYh1L6tjzRg0h+/wTNVuPUmBcqlG2IpQYkU8xDMTQOdQKSzOkQlhf8EAgB3IiHY52my
	BTNhga4nVuvbKnZQgJ7bxokfOn4dfm4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 883925C5821;
	Wed, 13 Aug 2025 14:25:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E096C4CEF6;
	Wed, 13 Aug 2025 14:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755095137;
	bh=s9+rxMFL44IKToOutqxDtZw5jz/ESi8pUno0QbbD/hc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ErExK45KAh3taU5Ay7lJ7MJ0BMkjWDiD1DN0JR/zuy5xUd2msBop/vOSselq0P951
	 xqaTacLr4JhC6juOA4x7iB/ICnUr91Z6DOwtkW7YEBLK8BOn6VMNdPLf6s/gJAyqDf
	 wz9mpbOVw45GKbGKmjoqBkjluU1Kbvsvyb6kJTUtCyZcPX8JRc1HxQl06bXJNhzkER
	 ce9WafJQZ8HSp7R53BwGs/NZ53f2B42giPZrrJllQc+T8yfZx9Ko5Zwzg2Alnu/cJR
	 Grg83L4s85KTn/NZGLzo8tA2ilXtoRL7JIw9wePMzXiMSqBRw8ZumQmP0uYiEH8+oT
	 jgB7rSEXyuNog==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Alexander Graf <graf@amazon.com>,  Baoquan
 He <bhe@redhat.com>,  Changyuan Lyu <changyuanl@google.com>,  Pasha
 Tatashin <pasha.tatashin@soleen.com>,  Shuah Khan <shuah@kernel.org>,
  Thomas Weischuh <linux@weissschuh.net>,  kexec@lists.infradead.org,
  linux-kernel@vger.kernel.org,  linux-kselftest@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH 1/3] kho: allow scratch areas with zero size
In-Reply-To: <aJycKRCEqbW0pgwR@kernel.org>
References: <20250811082510.4154080-1-rppt@kernel.org>
	<20250811082510.4154080-2-rppt@kernel.org> <mafs0349vwd1i.fsf@kernel.org>
	<aJycKRCEqbW0pgwR@kernel.org>
Date: Wed, 13 Aug 2025 16:25:34 +0200
Message-ID: <mafs0ikiruwm9.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A5DC5180012
X-Stat-Signature: 815sxmkq1wb3di8ukoy99ajyrqdw3sxp
X-Rspam-User: 
X-HE-Tag: 1755095138-346617
X-HE-Meta: U2FsdGVkX19Zy15N50DIdYl9wgGskkUO0+aC+7yGBwcivG6jn4ETm8XOD9rcSUkc9Uf/1gEDVmE2Bp9Yy0vOPih9eWC2BDmPjCDcdDlF+f2R0T5VCz6hsKk9hxggzVmwtbFR6GHdGC7tPhftJx2LoFwRqp9yvvzVT2KEkmscJBKmZJW6nZFbrutqIkt0C2fctwSgDWF3O4kv5ZRJG0gEjnQKw6Qj4hnpHsi4Fyytw2X27HC5eBcLrRIU+z6UEYmA2Ex1KJIKoANYRKBI5jiqEgpkc6EdeIEdlNvSRBj6rENItuKMj2cpLInZFxrWZkZIIeuLgk3JuT27aOH7R7o6WLWcmNpZHheRL5C5dw8Q4tMO0nfpTcl0luyNIPrlijIhu/6anQBrPsBM8k4HXF4Nomat8wsaecPb6zGxOB0yp5DObfFBgCGCBCZBcBE0/RTyHCZLWUivrwFu2FBds9nGTzAd138ETzSDHpXx3/iX7WZwUzHzc5KswMH0WIEXFs5yIw6ItRP75RMnsfRIfbjmQBQ7zks+GJa0ML3Ooxh7MdkaI8dO2CIWnIPm8Qjm6ROMRwhJj8Tyy3HJpPbbzxISMioWhMKV5PqH5/T+5ApyARm5Axpgs2Fa9WJnRrKXotqzobzagofsU7dPbhKnW/CkQFYVrf+G9IDrX1lYG+MdeFy3h+i6gIZX32gtkgTyQod+P0mbZIo7XIB67//jdmzqVDYv3nt9TV8HurOCgJSpK+DOfBVGCP5e4wCo7XAI9O4qzxNAQRhNVjR6TUcH0XVh/t0JF0LmNnQQSU9L4JvKKAGQ89uzSl56/97/4swDS+qvBWOpqGIX0FTR00DhalHgPfvrdq7XSjIbGqlmjZ5Bei7vFiz0hwdrmYMXm4Y3dcPhcTBuamLGd80n/VDYN7PHguShJGtgDg+kE3ve2QG3Giz5mS1FKKWGy3rR3pp+3xpy9AvGux1b48YzaIjP/mt
 nSSJxyI0
 Vxarw9sMC+O+09ldg9Uod2+FHU1oW+ysB/X0cFjVQgs6sKOjggF0vvGnGXmf1blQiJGeWdYCUpuSg5edd2vV4BQkyLCrH0gBcCB1l3ip/vHpmWn7wVmi0hdgbh2tNPwAI0Z4Tds/MyqZ/erWpnDpUX1Tdqkj8/kxUolUJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13 2025, Mike Rapoport wrote:

> On Wed, Aug 13, 2025 at 03:45:29PM +0200, Pratyush Yadav wrote:
>> On Mon, Aug 11 2025, Mike Rapoport wrote:
>> 
>> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>> >
>> > Parsing of kho_scratch parameter treats zero size as an invalid value,
>> > although it should be fine for user to request zero sized scratch area
>> > for some types if scratch memory, when for example there is no need to
>> > create scratch area in the low memory.
>> 
>> Can the system boot with 0 per-node memory? If not, then perhaps we
>> should only allow lowmem scratch to be zero?
>
> In most cases yes because most of boot time allocations have fallback to
> "any node".
> And there's also an option to omit the "global" scratch and boot with only
> per-node scratch areas, so I'd keep the possibility of setting any of these
> to 0.

Makes sense. In that case,

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

>
>> > Treat zero as a valid value for a scratch area size but reject
>> > kho_scratch parameter that defines no scratch memory at all.
>> >
>> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> > ---
>> >  kernel/kexec_handover.c | 7 ++++++-
>> >  1 file changed, 6 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
>> > index e49743ae52c5..c6ac5a5e51cb 100644
>> > --- a/kernel/kexec_handover.c
>> > +++ b/kernel/kexec_handover.c
>> > @@ -385,6 +385,7 @@ static int __init kho_parse_scratch_size(char *p)
>> >  {
>> >  	size_t len;
>> >  	unsigned long sizes[3];
>> > +	size_t total_size = 0;
>> >  	int i;
>> >  
>> >  	if (!p)
>> > @@ -421,11 +422,15 @@ static int __init kho_parse_scratch_size(char *p)
>> >  		}
>> >  
>> >  		sizes[i] = memparse(p, &endp);
>> > -		if (!sizes[i] || endp == p)
>> > +		if (endp == p)
>> >  			return -EINVAL;
>> >  		p = endp;
>> > +		total_size += sizes[i];
>> >  	}
>> >  
>> > +	if (!total_size)
>> > +		return -EINVAL;
>> > +
>> 
>> Looks good. BTW, unrelated to this patch, but should we also check that
>> p == '\0' here to make sure the whole argument was consumed?
>
> Care to send a patch? ;-) 

Will do :-)

>  
>> >  	scratch_size_lowmem = sizes[0];
>> >  	scratch_size_global = sizes[1];
>> >  	scratch_size_pernode = sizes[2];
>> 
>> -- 
>> Regards,
>> Pratyush Yadav

-- 
Regards,
Pratyush Yadav

