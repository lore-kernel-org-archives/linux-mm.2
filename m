Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E3A2606A33A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 07:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.a=rsa-sha256 header.s=alien8 header.b=CEzYY/Lc
Received: by kanga.kvack.org (Postfix)
	id 4C5706B05B1; Tue, 10 Nov 2026 02:18:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 476E06B05B2; Tue, 10 Nov 2026 02:18:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38C926B05B3; Tue, 10 Nov 2026 02:18:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 19D036B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 02:18:20 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9E482408B6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:18:19 +0000 (UTC)
X-FDA: 85418355918.17.6475A38
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7D53D40004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:18:17 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b="CEzYY/Lc";
	spf=pass (imf12.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794295098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AdAheHZEWha9dAehEUE3zXja1Ighlj9AsimpUr1pvrE=;
	b=SLTADZKLsWdB2MC0tESj2rvimN3w6FMon/J8Cph6pCYZzxPLBS/rXygaO4hW7X6rmHgjtW
	gbW9SeA5kunVYx09i/W61wf7mnKyzkEyRautrpBK+5QiEpSrJVXYUHTJUwEUDjw1RBC0wS
	6ER82k6ruXkNTjAz7CXrr43Eiel6Nkg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794295098;
	b=PfTSY0eMNG6E7jCYHRYWtfZ2DV0Y9feUB3PUpoB3Qhdqtp8WYFL7hzq4fKEBddWJisk1Xp
	9E52hq2EZrw4DDvs3MmMwOUNQ2I4aFXi8vqEf08E1LlpPXDgBJOSKc0aMs6G+++i5lgbZy
	uiguJc/a0Po2LJi/n17F7CpdvtcozAs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b="CEzYY/Lc";
	spf=pass (imf12.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id B57BD40E02A0;
	Tue, 10 Nov 2026 07:18:13 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id PDmFULynP60D; Tue, 10 Nov 2026 07:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1794295089; bh=AdAheHZEWha9dAehEUE3zXja1Ighlj9AsimpUr1pvrE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CEzYY/LcNnV752DyANYxRYqCdiauzIqFBIGjeUo6JWwRh0ZEG4G+xwcjd/4/pwNlo
	 SgC1zKTOZB8iZj1SDS/bnq28O2g1F9OToZcFVfOsDk8XmfPS4hbGyaDCsf+j3VDwre
	 cIfNdj6mhAsI24JcKwHYZRwtrzkX5OPIMiEOADgkoVPYE9kyOQhQHapkSWS6Vl7i6M
	 mb5gY8CoaZdZ+voHzb/N0bjI2U7yLfFgJwC+Gorbiw+wNd1dF19wLP2Chvvb6iL4ZW
	 9G/rstRfW2ee3NRHfVRqPxakhc8UEc+U9wzDzhMh7s2y43/WqXjxNLE9DfrkXcFmm3
	 cCGJh6S/X2KwesElRDcS4WRX6Ho6mvJpKvlvmqzdXrIgJ9Gt2l1tE0zlAdHPQIPHiB
	 U9FLw9v+3qrMxvthlBcLQDnBeR0RC0+p+Z3OzvQvyoOZPyaPIfRb8jbAK6UhPmAKE/
	 LgZhE85VY0O4WoaZPUllv4W5DulETM1Liy93VIjPi59oGnTu843OfF/+B48AnUfFEh
	 O8hFwxXE1ucYYRjs3Za94QTMFgl2E3vClWk4TvxxyPp/8j9fkibhVMuffhAaw/WGm2
	 zXb+zSbVyNXx9YL5sBT3MTKOfRUbrPaxHE1wMGKsAUGzY2OwEj5uSsnEy0Vaw0avhv
	 beFVzWRvzbf05CqvkRyxK/f8=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A105A40E0255;
	Tue, 10 Nov 2026 07:17:32 +0000 (UTC)
Date: Mon, 9 Nov 2026 23:17:29 -0800
From: Borislav Petkov <bp@alien8.de>
To: Shiju Jose <shijujose2008@gmail.com>
Cc: rafael@kernel.org, akpm@linux-foundation.org, rppt@kernel.org,
	dferguson@amperecomputing.com, linux-edac@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, tony.luck@intel.com, lenb@kernel.org,
	Yazen.Ghannam@amd.com, mchehab@kernel.org,
	ashok.raj@oss.qualcomm.com, jic23@kernel.org, linuxarm@huawei.com,
	rientjes@google.com, jiaqiyan@google.com, Jon.Grimm@amd.com,
	dave.hansen@linux.intel.com, naoya.horiguchi@nec.com,
	james.morse@arm.com, jthoughton@google.com, somasundaram.a@hpe.com,
	erdemaktas@google.com, pgonda@google.com, duenwen@google.com,
	gthelen@google.com, wschwartz@amperecomputing.com,
	wbs@os.amperecomputing.com, nifan.cxl@gmail.com,
	tanxiaofei@huawei.com, prime.zeng@hisilicon.com,
	roberto.sassu@huawei.com, kangkang.shen@futurewei.com,
	wanghuiqiang@huawei.com
Subject: Re: [PATCH v23 2/2] ras: mem: Add ACPI RAS2 memory driver
Message-ID: <20261110071729.GIavLFCfLKzPx8R0i0@fat_crate.local>
References: <20260726212812.89266-1-shijujose2008@gmail.com>
 <20260726212812.89266-3-shijujose2008@gmail.com>
 <20261017055852.GBatMOnEl66YObvU5k@fat_crate.local>
 <CAG4KcR+NOKHNzg6FN-oLLHgUxeitZHKXg9cN7dz24+Ap=RrwSA@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAG4KcR+NOKHNzg6FN-oLLHgUxeitZHKXg9cN7dz24+Ap=RrwSA@mail.gmail.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: hnk8bj4foqnohcxn1yo54ehyyshhpbqm
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 7D53D40004
X-Rspam-User: 
X-HE-Tag: 1794295097-613737
X-HE-Meta: U2FsdGVkX19vcwAE/GJjXTUSI+zGnZsbfmJXX+oybSUVcEbzqioORv+VtQ+XUkSlROsx4K8n2qCSw9JsH5otrxM/dMnpGGNteyg1RSunqbSddM3ZsM5cEP5BWDd/SHz++6jugzamfhMgbJQGrx0BsTSaIgBktngeEOVfPbxCWeNczQGFRkwPrlDZMrGMVOmednrSIvzebyERyvMQNa1mSGcat1uYI93K1frdlWv6QkDkXb2w5etmBWWMtPzBuPQWUDxKKj/FGny/ybzQIoX9j7LLV3zHhg4JHZUcXRq/GMzNBVWuedVnPWxtIpAxBmJmcCNsOvfnB5mscJqGYcqrwdJlNW6kjE171J6e9qilHEj7u0Euy2lmEOggbuvqfgASmqcqeUHSSGjwSl2bM0BLpaVgi1e9YU/GJbVFf3S/3RHNg551sF63/ILdj6XwAcJ1Rx5XUW4oEgCV/Xyrby6OEMwIw61BBPXwv1f1tw9/wJs71LFvEYmhliMVf63baRBLBDTKI+riwBzDsOazM5Obs11u0eC37bK/21XnDyWrdtvydNQGA2cyF7+KE8zSsEWCD5lrWPxPkvh7T6wxYehyOEVDyoqd2PVDCn+sk34kpDp1PQ2h/x1ZkI5PLSbU34+I4iZeVdq/0HXpi06LIuuipx2BcR8ZzJzBRawEbwbyLHAjwYUUozXKx+gPkt0nZbMjLT5J10pOmJnyjj0jcntdyG+qazwZM2FE8WlcczwiXIS6eLcrgDEaVJsiPD2GuvR1vBMFgJ/TGWp6v3YfTcQeOZnKoS1Wk6mO/klkj+Os+kMeq4RPzIeR3XXLVZnzPP1oixULWQ6nYrCMVwPlSQShjeF2bobgImE9+dV5l314zVyYIRDoWk49KewojAUxeYh8Nlkr7khMqnc5+vJLBzZyfPFBKhZXgOnN3JVHsrDVbyVPSp93lxU2PlyX263uk0UTaX762xVAd3UKAbvr9Jo
 /8qNs4MR
 Nxg+y989FBN3cWT9zlumszO+UrP4n+RuuYj8tZKEmqzTbgyoicVdpfUrcwfVOLuJ3jwsBLRd07dxOrCFWohF5m/1EYLjeibk7/zOaU99knftbxIn/46EFBjrGxDuivpnrEbsO0APlTkkvZfv9A66z5B2kPpbuGxi1dtAQTdvXSf1T+BRa3PdkvkrlzYxn0b1j1/zAjFO6MDFQKYP47Gv1AynOLrCSJMO/rz4GJ58XtQRK611RECSsJuzYzvjqNblsn9HJKUY6nzRnhpKLt5ryIGnVd3EoRhJqwax/ukjTFVJx6316vxFkWjritsPFA0F6UyibOt5HiJ89AYwYjbSwPvDY0VAmLWLX+wvDMgRsRpSJjiHK9/ec7K78O1+u6QidUsWUBqlGqwEt8FyY73y615wkELozIPcc5NRFvhG2vjNri/Up5mJU3Y7FI40SVl520evyr8/notrLo4E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Oct 18, 2026 at 11:56:22PM +0100, Shiju Jose wrote:
> I have got an arm64 setup only, did not try to build for X86 recently
> after adding the following change
> of using iowrite64 and ioread64 as suggested by
> https://sashiko.dev/#/patchset/20260325165714.294-1-shiju.jose%40huawei.com
> 
> Following change is required to build for X86_64 build when using
> iowrite64 and ioread64, while it was
> fine for the ARM64 build.
> Note: I'm not sure whether RAS2 is needed for the 32 bit build or not
> and the result of the 32 bit build.

I'm not sure iowriteXX/readXX are needed here at all.

Documentation/driver-api/device-io.rst talks about all those different options
and the most generic ones are readq/writeq().

About those you're using, it says:

"ioread64(), ioread32(), ioread16(), ioread8(), 
iowrite64(), iowrite32(), iowrite16(), iowrite8()
        
  These are an alternative to the normal readl()/writel() functions, with almost
  identical behavior, but they can also operate on ``__iomem`` tokens returned
  for mapping PCI I/O space with pci_iomap() or ioport_map(). On architectures
  that require special instructions for I/O port access, this adds a small
  overhead for an indirect function call implemented in lib/iomap.c, while on
  other architectures, these are simply aliases."

and I don't see anywhere that you absolutely need those, judging by that
explanation there. But what do I know.

Unless there's a real reason you cannot use readq/writeq()...?

But those should give you the same fixed endianness when accessing little
endian ACPI so...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

