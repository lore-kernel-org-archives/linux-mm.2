Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1245C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 21:54:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EC596B009B; Fri,  8 Aug 2025 17:54:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C3F06B009C; Fri,  8 Aug 2025 17:54:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D9F86B009D; Fri,  8 Aug 2025 17:54:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 261996B009B
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 17:54:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D2071593B4
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 21:54:34 +0000 (UTC)
X-FDA: 83754944868.08.6031DE1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3EA9B140007
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 21:54:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FVVTUjxC;
	spf=pass (imf23.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754690073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sk0RhaleF2RIU09BBqLOrUl5UPl07KM3dUhbhqtgkag=;
	b=scGDXMotVW90F8cxVkPMGsxqzfKcU+06q6VUUBu4Qpxpk9YGBQxV/iiaP9FMx55pa7O+G/
	UPeeat/7Ct51jyO95ynGLiZ5wC9758yI+VQuMo14/WmIQmRtb32/t5LWPqHJDpRa0mY7mv
	pk/Vb/K+pLZ/PsD2Xd+dwLF/nZOkfXk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754690073; a=rsa-sha256;
	cv=none;
	b=YipQfnxNMcePB1VOhShdK9xziY8nxY6aot5STcI7k2aVbsjIxbZJvVnVw0KWFhZnnhtJfG
	E07LUVK1s+Lr/frnBc9NtbKAAfdWUZylNKvnRpG5sOq7Ow2VGrrTdnCasOc0u1Rb3aEcj8
	WvAUpdb9DqguVs3z8+8u/VS84wBrwak=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FVVTUjxC;
	spf=pass (imf23.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7724D6144C;
	Fri,  8 Aug 2025 21:54:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000A4C4CEED;
	Fri,  8 Aug 2025 21:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754690072;
	bh=Sk0RhaleF2RIU09BBqLOrUl5UPl07KM3dUhbhqtgkag=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=FVVTUjxCNz77vH66MSZoU+W7PXOPNb+1m/0XKTr2fwBbmvDyORIHe0M3rrJaUFFEe
	 7Usf7CjO0FS1cPleSpveZNoNbMjtbo+e+pPL413HRY8q7yt2zceJF2K+VmzkURiN4B
	 JIf2PtnjPkq0DWX6672gNEpvi6+HwrdTr4pFa+2LkPs8p9VI6z3lA0MFtNztWoA/aj
	 d3gZtjUJqKIWtmJOCzL6S9TGMc/LgzzvjFvqBN70pYe58h/EsYOOAVJeoMRnje0xHZ
	 t5sNDtTe/pVozca+LgqopzDPVyu5zaleFqDZG7vigEj3okac4+Fiai+1253xcD8OUN
	 svLXA+KH8rm0Q==
Date: Fri, 08 Aug 2025 14:54:32 -0700
From: Kees Cook <kees@kernel.org>
To: Svetlana Parfenova <svetlana.parfenova@syntacore.com>
CC: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org,
 jack@suse.cz, akpm@linux-foundation.org, david@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com
Subject: =?US-ASCII?Q?Re=3A_=5BRFC_RESEND=5D_binfmt=5Felf=3A_preserv?=
 =?US-ASCII?Q?e_original_ELF_e=5Fflags_in_core_dumps?=
User-Agent: K-9 Mail for Android
In-Reply-To: <2c196c3f-4d49-494c-898e-8a1f6249ce24@syntacore.com>
References: <20250806161814.607668-1-svetlana.parfenova@syntacore.com> <202508061152.6B26BDC6FB@keescook> <e9990237-bc83-4cbb-bab8-013b939a61fb@syntacore.com> <202508071414.5A5AB6B2@keescook> <2c196c3f-4d49-494c-898e-8a1f6249ce24@syntacore.com>
Message-ID: <86553D38-36C1-4EBB-9732-A2C593A76260@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3EA9B140007
X-Stat-Signature: t6jmkdp5kniouepmdc9iqf7zgbgptoki
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754690073-363146
X-HE-Meta: U2FsdGVkX19W5HE+sthKwJ0EM9ppbjXPzmwJkwBKJHSJZmFN8+3CObnnxdSeJXxPdfa/qPVnCkFwk3NjjmzomDDf1mGuQ/x0XWHDeX8WWf+eTd+a9EUBOAGdDUXm/Mx8RQZ2ttjgkOvJ+9lNLl4g9T5dPTF91BKJZm78rEkeoLq5Oqlw0xxFotIZR4saHr27Ffu08sBCnM9uteLIKMv8lW1kZ8gqxpQXd13mJdQ/bHLji9pxywOs7+7eOGRw6wXyoTd9901KLdNW8xHAEQ3vFZbAlJb75oc5SXPdBkDrk2kbcYoZU8+i+k0Ubg1OmLGpeBOq4vIfCvaThZu5gnw34K1zWj1Jor0f6FcdV5leJ/fIJf6/xqzfab0Ci4vt5utltOUATQzqQdHYgDiwTkSMUGFFsGGlnEQdQLjeLm/dbsRl7NDDBkh1qe31cTcaOi0/qDV5Ul7uGPTGwx0xtKMvL7iiM/tfEWDAWyH125Mlv2nD9+H9+S8SzYABBP2JykRmnQXxDTH0Eja/+KHW2lMMuQlxeoHx2FvuM5m06MXrUFYsvFaIctMA9GjNx1izX8mrVYWR7I5JjeJhQFAhIQO9oLcxsS0LriYB5fyZkbXekyZHIw61skXabVcg0Q6Jw6KaRGrqK73IgODyUw9km4LDeNTu0lbCOU7BF8/NMRHhFLIgAmmT1yT6QNwPkWiNVyhcqldnDpURX01K5HfzgSoZEn149P/hRvih0ItcT+QRj6zzpRbK7VPrJWh7V0Bo3CnGieO0axf+eh7M1EFMInEjo+Q35VHSOEEJUNNZf94qVTKIhmEBx6AO4VJFdpq5lbBsms+XH9VKR/7bbc/IxyBcgBdWA22ALa6Canyw28QQL3tOFDrbC25S/A019C6Q292b6vTILB/YXEUmp8CXIAW4KNjo47+8lHlIwbaogce1HqThDXvedP9mg/27IYkOcupWl8Ez2cqRQnRG8z8SJar
 oa/+auyA
 iSBV2tk+v548jRxEoMBBMR9YKwtvpmdiIl/2jd1iQIeDCoWq81FjTVdCX59yEjp+qG+9851IppsBD6FFFdgzmSimLKBBANMvRumDJZ8HOrch7yYvyc1w9uzZrdE5BnZHA8+Yzzet2+7LMr+EJTS/N5ZDp1WVJopZK2gkLLknnmn5G6RQIFAOQJATlD8FTosQFQS8LmQp0W1oIdl27NGLfiROS7G28CF0rgi5GCASzIleO8FCccVrxl6XOOO6fklVBLibI6JGHXR52Zw0BiWpnbFPIuuskyqI60EPGmMHidoaAosqylzki5U1aTbWvmKXM3Bi8hcUqKbvRxPoH8foDmGaPIo0/opk3tkjaWdNR3Dc8+TC7mcSW7m7yJGxg7RABJo1F
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On August 8, 2025 8:54:30 AM PDT, Svetlana Parfenova <svetlana=2Eparfenova=
@syntacore=2Ecom> wrote:
>On 08/08/2025 03=2E14, Kees Cook wrote:
>> On Thu, Aug 07, 2025 at 07:13:50PM +0600, Svetlana Parfenova wrote:
>>> On 07/08/2025 00=2E57, Kees Cook wrote:
>>>> On Wed, Aug 06, 2025 at 10:18:14PM +0600, Svetlana Parfenova
>>>> wrote:
>>>>> Preserve the original ELF e_flags from the executable in the
>>>>> core dump header instead of relying on compile-time defaults
>>>>> (ELF_CORE_EFLAGS or value from the regset view)=2E This ensures
>>>>> that ABI-specific flags in the dump file match the actual
>>>>> binary being executed=2E
>>>>>=20
>>>>> Save the e_flags field during ELF binary loading (in
>>>>> load_elf_binary()) into the mm_struct, and later retrieve it
>>>>> during core dump generation (in fill_note_info())=2E Use this
>>>>> saved value to populate the e_flags in the core dump ELF
>>>>> header=2E
>>>>>=20
>>>>> Add a new Kconfig option, CONFIG_CORE_DUMP_USE_PROCESS_EFLAGS,
>>>>> to guard this behavior=2E Although motivated by a RISC-V use
>>>>> case, the mechanism is generic and can be applied to all
>>>>> architectures=2E
>>>>=20
>>>> In the general case, is e_flags mismatched? i=2Ee=2E why hide this
>>>> behind a Kconfig? Put another way, if I enabled this Kconfig and
>>>> dumped core from some regular x86_64 process, will e_flags be
>>>> different?
>>>>=20
>>>=20
>>> The Kconfig option is currently restricted to the RISC-V
>>> architecture because it's not clear to me whether other
>>> architectures need actual e_flags value from ELF header=2E If this
>>> option is disabled, the core dump will always use a compile time
>>> value for e_flags, regardless of which method is selected:
>>> ELF_CORE_EFLAGS or CORE_DUMP_USE_REGSET=2E And this constant does not =
necessarily reflect the actual e_flags of the running process
>>> (at least on RISC-V), which can vary depending on how the binary
>>> was compiled=2E Thus, I made a third method to obtain e_flags that
>>> reflects the real value=2E And it is gated behind a Kconfig option,
>>> as not all users may need it=2E
>>=20
>> Can you check if the ELF e_flags and the hard-coded e_flags actually di=
ffer on other architectures? I'd rather avoid using the Kconfig so
>> we can have a common execution path for all architectures=2E
>>=20
>
>I checked various architectures, and most don=E2=80=99t use e_flags in co=
re
>dumps - just zero value=2E For x86 this is valid since it doesn=E2=80=99t=
 define
>values for e_flags=2E However, architectures like ARM do have meaningful
>e_flags, yet still they are set to zero in core dumps=2E I guess the real
>question isn't about core dump correctness, but whether tools like GDB
>actually rely on e_flags to provide debug information=2E Seems like most
>architectures either don=E2=80=99t use it or can operate without it=2E RI=
SC-V
>looks like black sheep here =2E=2E=2E GDB relies on e_flags to determine =
the
>ABI and interpret the core dump correctly=2E
>
>What if I rework my patch the following way:
>- remove Kconfig option;
>- add function/macro that would override e_flags with value taken from
>process, but it would only be applied if architecture specifies that=2E
>
>Would that be a better approach?

Yeah! Let's see what that looks like=2E :)


--=20
Kees Cook

