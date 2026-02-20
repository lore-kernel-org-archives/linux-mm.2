Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3877BC55AB9
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 13:06:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FDDC6B0088; Fri, 20 Feb 2026 08:06:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28AC76B0089; Fri, 20 Feb 2026 08:06:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C0A46B008A; Fri, 20 Feb 2026 08:06:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E65C46B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 08:06:43 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6A8911A0104
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 13:06:43 +0000 (UTC)
X-FDA: 84464859486.21.D691978
Received: from mailrelay.tugraz.at (mailrelay.tugraz.at [129.27.2.202])
	by imf09.hostedemail.com (Postfix) with ESMTP id 133BE140013
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 13:06:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=tugraz.at header.s=mailrelay header.b=eaazT5cT;
	spf=pass (imf09.hostedemail.com: domain of ernesto.martinezgarcia@tugraz.at designates 129.27.2.202 as permitted sender) smtp.mailfrom=ernesto.martinezgarcia@tugraz.at;
	dmarc=pass (policy=quarantine) header.from=tugraz.at
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771592801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TI6pL5l6NcVbZgYUegCvNR9UgHAy5UP25eLtZeSKxCI=;
	b=57r1VL4t5GA3QuB75Pkvqw/0sR6vY8oZDQpwRBhULcg9PxiC5DgPc4jkfXEKfU6usb9a19
	O3HleqMXnCAlKq5q55j/SE1YlbftnplMKFy9V2T/o3qrvY7w33YwSeWtwYeAoI7g5ip+mu
	jAn9mdCa981opcQw/46UtV6birP5O2I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=tugraz.at header.s=mailrelay header.b=eaazT5cT;
	spf=pass (imf09.hostedemail.com: domain of ernesto.martinezgarcia@tugraz.at designates 129.27.2.202 as permitted sender) smtp.mailfrom=ernesto.martinezgarcia@tugraz.at;
	dmarc=pass (policy=quarantine) header.from=tugraz.at
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771592801; a=rsa-sha256;
	cv=none;
	b=ggd7dHO1AhGUvp5+jej3cbuREAqWb7oU8OZiZU83dyNsC9sfABTPwLib2xLJUC704Q4ajK
	Y2fGLxnPTC0N/N736DdpMXhq7A0fzIuSzpVmHwBfVy4/pe0kje2VSChE8G7eH1udAxs2oZ
	5AUht02bqyDhtK01zvbkbSF4Ao/mGTE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tugraz.at;
	s=mailrelay; t=1771592794;
	bh=TI6pL5l6NcVbZgYUegCvNR9UgHAy5UP25eLtZeSKxCI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eaazT5cTRW+EmP9R7NcUzYa45LVOLatiiLUOcMzvdWN9lfGzeX29bdLd/qNpldzjp
	 H4k/GSXyuZm4J45UVCM9WU9kn74dILYyfVBtb1sf1Dt4wLm3tiTSrOTpgS3JqnJDQK
	 X62nEBE+FP1RbCCCeqd1oGpQylYoQhte6/o1Gfqs=
Received: from localhost (unknown [129.27.152.14])
	by mailrelay.tugraz.at (Postfix) with ESMTPSA id 4fHVr968vzz2xP0;
	Fri, 20 Feb 2026 14:06:33 +0100 (CET)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8; format=Flowed
Date: Fri, 20 Feb 2026 14:06:33 +0100
Message-Id: <DGJT8E07A37R.2GC7KEDWEI7R@tugraz.at>
From: "Ernesto Martinez Garcia" <ernesto.martinezgarcia@tugraz.at>
To: "Marco Elver" <elver@google.com>, "Alexander Potapenko"
 <glider@google.com>
Cc: <akpm@linux-foundation.org>, <mark.rutland@arm.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <kasan-dev@googlegroups.com>, <pimyn@google.com>, "Andrey Konovalov"
 <andreyknvl@gmail.com>, "Andrey Ryabinin" <ryabinin.a.a@gmail.com>, "Dmitry
 Vyukov" <dvyukov@google.com>, "Ernesto Martinez Garcia"
 <ernesto.martinezgarcia@tugraz.at>, "Greg KH" <gregkh@linuxfoundation.org>,
 "Kees Cook" <kees@kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH v1] mm/kfence: disable KFENCE upon KASAN HW tags
 enablement
X-Mailer: aerc 0.21.0
References: <20260213095410.1862978-1-glider@google.com>
 <CANpmjNPJV-aQKnQ7Mtr6e8_12UR3C2S3abJx_ePFWmS1WV_UVg@mail.gmail.com>
In-Reply-To: <CANpmjNPJV-aQKnQ7Mtr6e8_12UR3C2S3abJx_ePFWmS1WV_UVg@mail.gmail.com>
X-TUG-Backscatter-control: odR5CN6y6BwYAgRjfEtHZQ
X-Scanned-By: MIMEDefang 2.74 on 129.27.10.117
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 133BE140013
X-Stat-Signature: pak7jxyptcs58timwk8nemin1eetyf7d
X-HE-Tag: 1771592800-780339
X-HE-Meta: U2FsdGVkX183MaB/N0BZVJMfbF1xzfFdJlm1IgT0TKuHRs2Sh6bL6OnJ0b3bWQ0AsdLoUhos1wzPkS5lDsJSIfjaU0dVLO9Qj2cdd+c4PEMKgiOCszsUqnCMKseKNxvQgW+QeVtSGa0j+vM33zmFbijkMYzA9RZg4SzhPoWGx9FtFDj2mT5aQf2rw7tDVPpZorPGX45h9y0T22pElkxhjOxPmqEfo99y0i6YMC00A+tCXrkRJtLV9cGmq7TRkOsRaG9DhseWC0tgAdasMM2SKXzwZ0lyDcif4ijkRsNKEFQimoNf9PMpgQtjUHJZvNzriExij7FkXPEa8/5bx10/mxm1/agQuoNBvnOJDLJg3CIf/2nlMoqOaf4behk1HngN8T+7RfRFr7RGvRbbuKxCXk0UvlGgl9+JfI+Dhd/9arKBD4l6ywatrVbzb47mUBxOIK6hvazAa8p+Utykhpf0JT91zA6WbpoJLiXLtWxYLk++tGFSjf1oZvmPgYrZsBAacWvWWLUUMoQT7Y2igs1VfKFoaSFY7wV0DQzGFY/BXleHGYz0nut9n9527O1KMfszaupIxaFROBXRfFlfrJ4IuuVIrEFRJnVDqdXU3jc6dKwqdfN8pXdJ3DpyqS6HNdIi5080tUUeZ//koH27lLMjtDFbihK/VchHrG0vNAyVkU2OKV4Ggdmn411TN7Lc9fTSszNQ76MLrZ+CSRutq4yXCVjwhu4QLX5t9CoAr1bTMYhcmbaHYLXapxAT9O4XBiWmW/VSlEHjeXzPpPER+sRngjSIGE6Uu9+a9AuEjdkQX4lavxeRJ9ICoNhbzlErW9CJDG/eNqimVXoTLz2crH9LaHoaMZrFD+gjeF7v0dpISVgqyj674ZGFwYoQuqlL+27PwUIBjScluhf6B3yqZV2ncxQ+2iGytreocnxx5jjx4za8+VJG1ubhMYOxKnlfH04so3LyW5J0MdKXDDzYABU
 j1nUWpCH
 N8LJeqnM1NWENDvmUT4WyRxiFDc1am5WRuLwMdeSV/qb24NnG/RQLNC5z1usU3mpilAuxQGRwTsyhm2QvoGjfNS5QnE5sxv9Vu7+qnFgo4mHIveLadewLYLURpgG2o3k47govvr2eKGLJAXh5avsoRh34UMijK6qE8x8Xe/bxTYLCLjdtuNIw9m/9rdicnr8y5/ZrtVEGDtTuTKTNh2wazugZLxnOdTf1BTPju5qO/34r9iRC7N966FEFbpwsYjE7OknBA/+xNIpJVRX6VZKrMSLAjPO16pMmiH8jB/imEi0vOqoJJAF5lVqT7gkP2KhuLZ8pDOBwoRtmWsRszGtT9Ux+d9CNOClbnDi4xF+UBMg5C79gRWs4ztMK+Yd7bIj+Mn0q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Feb 13, 2026 at 11:50 AM CET, Marco Elver wrote:
> On Fri, 13 Feb 2026 at 10:54, Alexander Potapenko <glider@google.com> wro=
te:
>>
>> KFENCE does not currently support KASAN hardware tags. As a result, the
>> two features are incompatible when enabled simultaneously.
>>
>> Given that MTE provides deterministic protection and KFENCE is a
>> sampling-based debugging tool, prioritize the stronger hardware
>> protections. Disable KFENCE initialization and free the pre-allocated
>> pool if KASAN hardware tags are detected to ensure the system maintains
>> the security guarantees provided by MTE.
>
> Just double-checking this is explicitly ok: If this is being skipped
> enablement at boot, a user is still free to do 'echo 123 >
> /sys/module/kfence/parameters/sample_interval' to re-enable KFENCE? In
> my opinion, this should be allowed.

Should work, as the late enable codepath is:

- param_set_sample_interval()
	- kfence_enable_late()
		- kfence_init_late()

While the check is only present at:

- mm_core_init()
	- kfence_alloc_pool_and_metadata()
		- kasan_hw_tags_enabled()

However the late activation triggers BUG_ON or KASAN invalid access
issues at the moment:

	~ # dmesg | grep 'disabled as'
	[    0.000000] kfence: disabled as KASAN HW tags are enabled
	~ # echo 100 > /sys/module/kfence/parameters/sample_interval
	[   30.440993] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
	[   30.442418] BUG: KASAN: invalid-access in __memset+0x10/0x20
	[   30.443275] Write at addr f4f00000c2e34000 by task sh/1
	[   30.443420] Pointer tag: [f4], memory tag: [f1]
	[   30.443448]=20
	...
	[   30.445742] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
	[   30.445946] Disabling lock debugging due to kernel taint
	[   30.459644] kfence: initialized - using 2097152 bytes for 255 objects a=
t 0xf5f00000c1c00000-0xf5f00000c1e00000

Likely because the KFENCE pool/metadata memory is allocated and tagged by M=
TE:

	[    7.590336] kfence: initialized - using 2097152 bytes for 255 objects a=
t 0xf2f00000c1600000-0xf2f00000c1800000
	...
	[    7.710112] kfence: initialized - using 2097152 bytes for 255 objects a=
t 0xf1f00000c1600000-0xf1f00000c1800000
	...
	[    6.627959] kfence: initialized - using 2097152 bytes for 255 objects a=
t 0xf8f00000c1e00000-0xf8f00000c2000000
	...
	[   19.137156] kfence: initialized - using 2097152 bytes for 255 objects a=
t 0xf3f00000c1e00000-0xf3f00000c2000000

Which seems to be an upstream bug of KFENCE+MTE, as I can reproduce the
same issue on mainline 6.19 without the patch applied:

	# uname -r
	6.19.0
	# cat /proc/cmdline=20
	root=3D/dev/vda console=3DttyAMA0 rw rootwait earlycon debug hash_pointers=
=3Dnever kfence.sample_interval=3D0
	# echo 100 > /sys/module/kfence/parameters/sample_interval=20
	[   45.555499] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
	[   45.556989] BUG: KASAN: invalid-access in __memset+0x10/0x20
	[   45.557844] Write at addr f8f00000c3032000 by task sh/148
	[   45.558063] Pointer tag: [f8], memory tag: [f4]
	...
	[   45.560695] Disabling lock debugging dHey thank you will take a looksie=
 and tell youe to kernel taint
	[   45.574599] kfence: initialized - using 2097152 bytes for 255 objects a=
t 0xf4f00000c1600000-0xf4f00000c1800000

Disabling and enabling won't trigger as the KFENCE pool is not freed on
disable. To trigger the bug it is required to go through the
kfence_init_late() path: KFENCE disabled at boot time.

	Note: Tested with qemu-system-aarch64 -cpu max -machine virt,mte=3Don (10.=
1.3)

Changing kfence_init_late() pool and metadata allocations to
use the __GFP_SKIP_KASAN flag fixes it:

	~ # echo 100 > /sys/module/kfence/parameters/sample_interval
	[   19.488734] kfence: initialized - using 2097152 bytes for 255 objects a=
t 0xfff00000c1600000-0xfff00000c1800000
	~ # cat /sys/kernel/debug/kfence/stats=20
	enabled: 1
	currently allocated: 1
	total allocations: 12
	total frees: 11
	...
	~ # echo 0 > /sys/module/kfence/parameters/sample_interval
	[  778.414494] kfence: disabled
	~ # echo 100 > /sys/module/kfence/parameters/sample_interval
	[  784.215866] kfence: re-enabled
	~ # cat /sys/kernel/debug/kfence/stats=20
	enabled: 1
	currently allocated: 2
	total allocations: 32
	total frees: 30
	...

But this requires adding __GFP_SKIP_KASAN as allowed in
__alloc_contig_verify_gfp_mask I think. Unsure if there is a cleaner way
of doing it, or if changing __alloc_contig_verify_gfp_mask could break
something else unexpectedly.

I would be happy to try to submit a patch for it :)

