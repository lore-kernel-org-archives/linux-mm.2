Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BA0F606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 10:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CVNFSdox
Received: by kanga.kvack.org (Postfix)
	id 48D856B00EF; Tue, 17 Nov 2026 05:41:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 415066B05B0; Tue, 17 Nov 2026 05:41:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DD596B05B1; Tue, 17 Nov 2026 05:41:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B0ED6B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:41:19 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9205F1C3AD1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:41:18 +0000 (UTC)
X-FDA: 85444269036.24.355EF0F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id EF940C0005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:41:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CVNFSdox;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794912077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=imUJWBchit9SuVHDzuMNjlSPoobNZbAUtuLMrGVWVHg=;
	b=K4DRtZWmKvU4zhFAS8krlAb7p0odzF6pUbFOh8vIHxEOekuwVTN5TMBKwljBGOMb0T84Vi
	VE6u+shchycQWPJwKzI6KIgyvjSAcKu8z+3KGozkvrOZ+ClsVnwU0wI8ST/H/Bfl19oWAQ
	wuOjDF0e6cpKLctuR+Pf3KKKx7qvDmA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794912077;
	b=oLr5sE2vIgWjZeZwfMbwWCw+XNhKGSvrdUgkeCBzAXDLkx3g4xiWG1LTEnkEEoNJnx3Mjl
	NMHAfFuNcdOFmp1WY4I98tyBKngrVdVWiMi1H5XBhI+bw5Ma7wRhF7Tt9yMYpazCRrnsHQ
	YVIMpSp8zJOEdffmIK9FE1UgWKKdpTc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CVNFSdox;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A40844DFC;
	Tue, 17 Nov 2026 10:41:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A95B1F000C4;
	Tue, 17 Nov 2026 10:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794912076;
	bh=imUJWBchit9SuVHDzuMNjlSPoobNZbAUtuLMrGVWVHg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=CVNFSdoxu4l/nj9Mm2t0iUMPrhaOa4wgFFHGazUP4pNZG3iVJogqLdJRtgEQF9czH
	 m4snTDqFKQ3MkIbWzh75EhHd7RnhaUXlGRkmsSWK112fFsCxKPzMuuvptHfqjccnnH
	 tnzU+NfrXZvW1AvcjOKxICz+exYDTNTQ142SIYK3sfM2NPToO2s8hPj3GUpd5AOGUF
	 1NUYkeSmlrz4EDqLtJXzjVXoH52BxzV3TDyAvmeSzGON/Bgtc+8wbu8p94EZ8BP/l+
	 IwkQq2f0NbmR4zpxS7teFcFqKIhRYFA5/ELcuVo73JX7yC2H+qT7BbYZYlTwqY4T54
	 WQXZrrz9MeoBw==
From: Pratyush Yadav <pratyush@kernel.org>
To: "Pasha Tatashin" <pasha.tatashin@soleen.com>
Cc: "Pratyush Yadav" <pratyush@kernel.org>,  "Mike Rapoport"
 <rppt@kernel.org>,  "Alexander Graf" <graf@amazon.com>,  "Jonathan Corbet"
 <corbet@lwn.net>,  "Shuah Khan" <skhan@linuxfoundation.org>,  "Randy
 Dunlap" <rdunlap@infradead.org>,  "Andrew Morton"
 <akpm@linux-foundation.org>,  "Tarun Sahu" <tarunsahu@google.com>,  "David
 Matlack" <dmatlack@google.com>,  "Samiullah Khawaja"
 <skhawaja@google.com>,  <kexec@lists.infradead.org>,
  <linux-mm@kvack.org>,  <linux-doc@vger.kernel.org>,
  <linux-kernel@vger.kernel.org>,  <linux-kselftest@vger.kernel.org>
Subject: Re: [RFC PATCH 2/5] kho: build KHO objects into a single kho.o
In-Reply-To: <DMWWRQTLNYH6.1LJ2K5HT60LK8@soleen.com> (Pasha Tatashin's message
	of "Mon, 16 Nov 2026 15:13:23 -0500")
References: <20261116134013.1636689-1-pratyush@kernel.org>
	<20261116134013.1636689-3-pratyush@kernel.org>
	<DMWWRQTLNYH6.1LJ2K5HT60LK8@soleen.com>
Date: Tue, 17 Nov 2026 11:41:11 +0100
Message-ID: <2vxz5wxvhha0.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 94t6axaiqzpfd44qfgrpj1c5i4kxxzww
X-Rspam-User: 
X-Rspamd-Queue-Id: EF940C0005
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794912076-270904
X-HE-Meta: U2FsdGVkX1/i5tPxe1AKw/COP0HdRXOiJLAmb9KAH/kPwla9z1XA0sIkBDeepayv39MDYe1stlM0P4c21mVI92uEbCK5q+VAK+GtteLGqwXvLrkhuehMoT2RIHq8DTxfYAMm4Oocivm0eO+m4wwp2ZL/7JNHjTXZ/LrCxkymHmbOGgN9CG2Dz3woRCtvjFFfPvJ5J2IyReSZdHy0qMrBGZm5YP8h09Emj1c6DwBlw4duQLa9gGF/jrPCuRLVN5zAQL/YcZfR+dQHP0WsFaYhPIQ8eLZazt9oQyjBnQExH6bq/ds77WfvIuZmU+R7vUYyuOLPOBdq6Ky8bsW6OjYJRJ9OFqNVAjqi8DWJ1pjDK06Bkyvaa542sQjSHtbfu7Zt3i+31GXWdfdFc2rf3V4YrvZffIde6VEKb4DsgRBbk1QjtNGw3FPgcPleXVtilBVOFypYJPb6gGaCS8Gn5KBieSWHbxi/D84xHFJ2X+q1kXShFRq9S0PSQX987RygmLYFl51nZY86ZIxKtWc/15JhQhk4BRXi74+Mpw/ADYbPp2FB+yCzxhhigoK1F/kF/Oq+Wq6r3bmT1dtfFX4iSa4NpPvZmnN4tun3rmz1WxDcmwWT9mzlq2/K1wh3tbavij/Z5O//+gP7JWfdpp5eIAGv2RxxYy+zE0Fu87jDeAN41ymBvvFYRx0HCMDz6MQPdlHZt+VC0aEY68VDSD6OG6Km7m7OnfvzXKdUnDR1o6UoqPm1BwenbUJXAfkrOIQ152DzJDM4jYR3IQHCvbEWX8HXJKQGlisgO8cjWkWtaYFEcJgqcXi56nrZy8+0zkd4jRISmUTwuhgRZUpIQmuIPHa/5z2AwP2qd6sNA3oYaE+6xLFIK+6VtF5d70FKp6Xj2TbP1H4uEbO/iVulddORInBCHi8m2CPRCnEXS/pGZP2Zmkb4Crys+bF7LGTjuaENr2MbZvX9jzm93eu/3Qi742L
 hTlj4inG
 P15QYvmNeqiw6pNg8MPzJJx61YDdp8coN7lDOHOH2Qouwp5DisMqW0tzjSdGryFPJ4tbyhXg5HEgeHwRDFAjqOj/EVQXYyDUPAarcw0tLw/N9hemAInblhG96nPU96yreX7GGQ0FLj+zfafO85nLYCx3LsnS6a7eG62Pt8wTn1+af2r3Wk3yS7yoX/SS+cW3SH2loZ18xMonPN9UPtt6bHmZT8MlxTv4WrSXLr7QDh/22U8k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16 2026, Pasha Tatashin wrote:

> On Mon Nov 16, 2026 at 8:40 AM EST, Pratyush Yadav wrote:
>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>>
>> kho_block.o is part of the KHO infrastructure, but is currently built as
>> part of luo.o, which ties it to CONFIG_LIVEUPDATE.
>>
>> Group all KHO objects into a composite kho.o, built for
>> CONFIG_KEXEC_HANDOVER, the same way the LUO objects are grouped into
>> luo.o. This also gives a single place to add new KHO objects.
>>
>> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>> ---
>>  kernel/liveupdate/Makefile | 12 ++++++++----
>>  1 file changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
>> index d9f4694625567..bc679905ce3f2 100644
>> --- a/kernel/liveupdate/Makefile
>> +++ b/kernel/liveupdate/Makefile
>> @@ -1,13 +1,17 @@
>>  # SPDX-License-Identifier: GPL-2.0
>>  
>> +kho-y :=								\
>> +		kexec_handover.o				\
>> +		kho_block.o
>> +
>> +kho-$(CONFIG_KEXEC_HANDOVER_DEBUGFS) += kexec_handover_debugfs.o
>> +
>> +obj-$(CONFIG_KEXEC_HANDOVER)		+= kho.o
>> +
>>  luo-y :=								\
>> -		kho_block.o						\
>>  		luo_core.o						\
>>  		luo_file.o						\
>>  		luo_flb.o						\
>>  		luo_session.o
>>  
>> -obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
>> -obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS)	+= kexec_handover_debugfs.o
>> -
>>  obj-$(CONFIG_LIVEUPDATE)		+= luo.o
>
> Please send it as a separate patch. I have the same change included as 
> part of the kho-ro series, but let's fix it outside of both series 
> instead as a standalone fix. Also, maybe rename kexec_handover_debugfs.c 
> to kho_debugfs.c and kexec_handover.c to kho_core.c for consistency, now 
> that they are not shared with the rest of the kexec_* files in kernel/*?

Sure, makes sense. I have a few other misc cleanups in mind like
re-organizing some of the KHO headers. I can do that all in a single
"misc cleanups" series.

-- 
Regards,
Pratyush Yadav

