Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A39EE668AF
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 03:30:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A64D86B0088; Fri, 19 Dec 2025 22:30:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A12FA6B0089; Fri, 19 Dec 2025 22:30:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F46C6B008A; Fri, 19 Dec 2025 22:30:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7DAA96B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 22:30:50 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 08B2B1A0427
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 03:30:50 +0000 (UTC)
X-FDA: 84238422660.27.CB42764
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 569AB8000C
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 03:30:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gcsrlEDN;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766201448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l+49Rimbg5lu33r/DaYgbOd2mhN16SETdATd5FhkZFI=;
	b=lgziKhhjUmOfL7/2TUlvaolPO/95Wu2QSuvxEqwBgfb/E4WPIwuGRvvIcPbzfDx25VzxDQ
	/MJK3IThXWY4PL4GiaQMiisS6ivr8wwB6F675ZViBJAtkZ81qkgE6RK8EipxTCw0K6lf3R
	L/H+Audxg2i9sNGo41/wxY+WBdtoAYg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gcsrlEDN;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766201448; a=rsa-sha256;
	cv=none;
	b=lRKELlRnZcR7RUBtdUBrRrOwMSdVYArtBySIUcuMpbIO8NRTsT84kVL/umwEGOnJuZ4MWF
	n4kbWNaM1a5t7qY2fbCUeOEtryYApruKXU+imdZmw6ZfTx/1NsnmQtKeOZvd+2QOUKS7+C
	cj9xKL4MeDa2ZR12XWwS3v9yrjlUGCA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 20D8C42E4B;
	Sat, 20 Dec 2025 03:30:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F37DC4CEF5;
	Sat, 20 Dec 2025 03:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766201447;
	bh=iUdJa3ZP1iU0bgE8m+U5BrelPEBq+tJ2Onv6xomprvY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=gcsrlEDN3DXmkvFdNY57ugc+QQe96QWVElttk9jICytrE5OUc2pgeqZlEes1FtmQS
	 Wq1OdG/EGBrFKpN2szp8TuYPDcvOgRWbL6jYBT0vfF7bKCNjmOaRSgzo2S+rBeJJs1
	 ppYT2+yZdSm0xlqRoXPtLmOVXhrqiGHvIM3ubwvFEVnHLzIyPcqqQ/whTHpGS7KmPV
	 tvvFdvUm6WFf9IqgVnfxxt3kVugGfrcHhfvQ+YB0qY8ZJjIhfsCk0He+SyfvqyhJeh
	 VQXRkZwqG/TFzY1PgHimR1e+wz3BP7JHjM4C1pFfgoIO/1tsW1vEzl8cuExCGIbWh3
	 Go+hvM1CBi66g==
From: Pratyush Yadav <pratyush@kernel.org>
To: Evangelos Petrongonas <epetron@amazon.de>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Arnd Bergmann <arnd@arndb.de>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Mike Rapoport
 <rppt@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,  Dan
 Carpenter <dan.carpenter@linaro.org>,  Jason Gunthorpe <jgg@nvidia.com>,
  Samiullah Khawaja <skhawaja@google.com>,  David Matlack
 <dmatlack@google.com>,  David Rientjes <rientjes@google.com>,  Jason Miu
 <jasonmiu@google.com>,  <linux-arch@vger.kernel.org>,
  <linux-kernel@vger.kernel.org>,  <linux-mm@kvack.org>,
  <kexec@lists.infradead.org>
Subject: Re: [RFC PATCH] liveupdate: list all file handler versions in
 vmlinux section
In-Reply-To: <aUFdp_fsGCNrFf76@dev-dsk-epetron-1c-1d4d9719.eu-west-1.amazon.com>
	(Evangelos Petrongonas's message of "Tue, 16 Dec 2025 13:24:55 +0000")
References: <20251211042624.175517-1-pratyush@kernel.org>
	<aUFdp_fsGCNrFf76@dev-dsk-epetron-1c-1d4d9719.eu-west-1.amazon.com>
Date: Sat, 20 Dec 2025 12:30:40 +0900
Message-ID: <86sed5j0db.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 569AB8000C
X-Stat-Signature: dc4i416cd4ko1i9ykq4z9ayyy5fiwe5s
X-Rspam-User: 
X-HE-Tag: 1766201448-463532
X-HE-Meta: U2FsdGVkX1+ZoRq19B76esyDoyTuOENgRpg8C5Wewq2Zj4BQwX4JCTw3g6FfHYFaIGHNMMVlBdfYMYfPw+jFJUD0iL7NMZ7/ivm3bPdYTL7jl5Ny3Ii4xnEjX5A0J8kGYmnr3MdfBLBff4LfqGfSpXBlfiYyrAG2duWGd8++MhScnUnjhYKCKSfM2kXewmjX7EcVfdCC/aDtLRY34JkL1Hoq3Rj23LRKHecsPUyQgIS7LbucOz6XdUye9XMVsjgrKQZPbJuNfc+f5of2HYJhPbp/LGrzwX52U1TCLW0l0Zmfq5V7uIUxIykDP45tBJlWQPc7u9eYIEevqs3YZaci1LT4Njv3Iyw5aiF2C3DIOM+gXCaS8iZcy4U0BB71p3jbOKVqhzqaEUgX+lUQBcOh4j+KqEzIdDY1BqfSegTMJCW9IB2RSZgzNd/BjlSudfahZQOAm+fXDUV4EBB8CHdlkyfOx1SPp4/FaPREh/NFfasZPmpFXmRK8m+XfY+AeegJdlidZ5dyVIxEbEMI9CH/mKlVSrIUvXuImT/eWzNAYeUYdMhjDUSWYkJbooKTY9L7Ay1sEMQadTJ/NadOcionu3ctc8mx09fa/95hyKHoo95q/6zB1jnjkad9WgThsacVyw22ona3YqeVyi7rTPibZUkjhwfmjpeX8flKTVTqTAYqglq9nCrRjiwABuJsnIxakla9Fm3JQqUxAA2qRx7aJ72LDaDwgm1J729yeuJRO50KPqMgo6ZSK7CG38pByKzm8TSgJnJ/YcK21TqVv3N3vZ+mK3A1Xrf3LKfPGPves7kpj/7WR2iSoZVgdkmtaSl6I6UegR+K23MNFv/jM+iJh0lMYSQVbE0ytj85EQenhlGVtSOSFtxZ16zG46pOYrecHSc1iT4gxgLRq4FOjvJ19SM9sdOobqwdBA9eNuEXCUAOJDQkH8ppjW0Zq4BCihSl0MUJkLRhqxMOTQSNlp0
 x0hMMk58
 xfhD9jZLJ19KIVH/I1IKIUIOv1Q9AGP5th7NaLus9fu9+zRG+kUBdys18G8t29J/iLXh9DK6tf5GejIU8+hUVm93zv+nVrWdTmhH5h+nuGNgcFSF5wkS4DmODqqKwiAVKM7J0vBXnwjhp7q31IxRT4u5ecL9s4ALBcfXO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16 2025, Evangelos Petrongonas wrote:

> On Thu, Dec 11, 2025 at 01:26:22PM +0900 Pratyush Yadav wrote:
>> As live update evolves, there will be a need to update the serialization
>> formats for the different file types. This could be for adding new
>> features, for supporting a change in behaviour, or to fix bugs.
>> 
>> If the current kernel does not understand the same set of versions as
>> the next kernel, live update will inevitably fail. The next kernel will
>> be unable to understand the handed over data and will be unable to
>> restore memory, devices, IOMMU page tables, etc.
>> 
>> List the set of versions the kernel understands in a section in vmlinux.
>> This can then be used by userspace tooling to make sure the set of file
>> descriptors it uses have the same version between both kernels. If there
>> is a mismatch, the tooling can catch this early and abort live update
>> before it is too late.
>> 
>> The versions are listed in a section called ".liveupdate_versions". The
>> section has a header that contains a magic number and the version of the
>> data format. The list of version strings directly follow this header.
>> Only the version strings are listed, and it is up to userspace to map
>> them to file descriptor types.
>> 
>> The format of the section has the same ABI rules as the rest of LUO ABI.
>> 
>> Introduce a LIVEUPDATE_FILE_HANDLER macro that makes it easy to define a
>> file handler while also adding its version string to the right section.
>> 
>> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
>> ---
>> 
>> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
>> index e04d56a5332e..a474c9529a5f 100644
>> --- a/include/asm-generic/vmlinux.lds.h
>> +++ b/include/asm-generic/vmlinux.lds.h
>> @@ -342,6 +342,17 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
>>  #define THERMAL_TABLE(name)
>>  #endif
>>  
>> +#ifdef CONFIG_LIVEUPDATE
>> +#define LIVEUPDATE_VERSIONS						\
>> +	. = ALIGN(8);							\
>> +	.liveupdate_versions : AT(ADDR(.liveupdate_versions) - LOAD_OFFSET) {	\
>> +		KEEP(*(.liveupdate_sec_hdr))				\
>> +		KEEP(*(.liveupdate_versions))				\
>> +	}
>> +#else
>> +#define LIVEUPDATE_VERSIONS
>> +#endif
>> +
>>  #define KERNEL_DTB()							\
>>  	STRUCT_ALIGN();							\
>>  	__dtb_start = .;						\
>> @@ -544,6 +555,7 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
>>  	RO_EXCEPTION_TABLE						\
>>  	NOTES								\
>>  	BTF								\
>> +	LIVEUPDATE_VERSIONS						\
>>  									\
>>  	. = ALIGN((align));						\
>>  	__end_rodata = .;
>> diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
>> index 4a1cc6a5f3f8..57ef75695f62 100644
>> --- a/include/linux/kho/abi/luo.h
>> +++ b/include/linux/kho/abi/luo.h
>> @@ -244,4 +244,38 @@ struct luo_flb_ser {
>>  #define LIVEUPDATE_TEST_FLB_COMPATIBLE(i)	"liveupdate-test-flb-v" #i
>>  #endif
>>  
>> +#define LIVEUPDATE_VER_HDR_MAGIC 0x4c565550 /* 'LVUP' */
>> +#define LIVEUPDATE_VER_HDR_VER   1
>> +
>> +/**
>> + * struct liveupdate_ver_hdr - Header of vmlinux section with version lists
>> + * @magic:     Magic number.
>> + * @version:   Version of the header format.
>> + *
>> + * This struct is the header for the vmlinux section ".liveupdate_versions". The
>> + * section contains the list of file handler versions that the kernel can
>> + * support.
>> + */
>> +struct liveupdate_ver_hdr {
>> +	u32 magic;
>> +	u32 version;
>> +};
>
> I believe we are going to have two main classes of LUO objects that are
> going to participate in Liveupdates, when it comes to their criticality
>
> - Core/Mandatory components. Theese components are necessary for the
> kexec to be succesfull. Think components like IOMMU page tables, as
> you have mentioned.
>
> - Acceleration/Optional Components. As we strive to minimise the blackout
> time, we will trying to persist more and more state across kexec, that
> are currently being initialised from scratch during boot. Thing of
> certain optimisation like PCI onboarding (at least parts of it)
> and the PCI Config Space Cache. If theese components are incompatible
> between versions, we might still want to proceed, with the LU, at the
> cost of increased blackout time.
>
> I believe it will be quite usefull to be able to have the ability
> to differentiate between the two.

I agree that it would be useful. But I've been thinking about this for a
bit. I think it will be hard for the kernel to judge what is a mandatory
component and what is an optional one. There might be some setups where
you would deem some PCI devices as mandatory and some as optional. I
don't think we should even try to encode that kind of policy in the
kernel.

So I think we need a UAPI for userspace to tell us what is mandatory.
That is more UAPI exposure. Dunno if now is the right time to take
that, before we know more how this works out in practice...

[...]

-- 
Regards,
Pratyush Yadav

