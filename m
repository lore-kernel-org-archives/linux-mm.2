Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AAD3C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:57:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD4516B00AA; Tue, 15 Sep 2026 08:57:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AABDD6B00AB; Tue, 15 Sep 2026 08:57:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EBE96B00AC; Tue, 15 Sep 2026 08:57:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E62F6B00AA
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:57:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BE748402A0
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:57:56 +0000 (UTC)
X-FDA: 85215998952.12.F7A56AB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 19529120004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:57:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DPMTw43P;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789477075;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GiH3GbpixJxWQZTib2/+LhbytIGDPVlvBxFpYNkmPeA=;
	b=qqf2iAsRE0SHs185TXu+6fnOftOkoYLqKZLS0UjQlewSnHin5HKnqX/mzmbQL8ac8wTtPH
	ISCxLyca3fU/6eO2TG4q/2CgKzwZbZJiI4ZksMiaCHQSB6YdplYSGcVXZoc3VdyXUntGqQ
	qLMpceg4bvbmsy2P691BPN5Dpx9tiUw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DPMTw43P;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789477075;
	b=RGtaGDrWVepbAGQqR68Dd3kaq1542yBeekc8gc+Xcyd47CrdVN1/Lh2LG2rTLbobEPU3Ek
	3Ju7cb1Z2YKx5WA0wZQou2gW9g3yZFBL12x1KnmluDIhimvKICOYSnstqEfFb9olp1sRPm
	W31WPZizuEPp2RVYEcDw7prHT4g2Heg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1EA4541AB1;
	Tue, 15 Sep 2026 12:57:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277B01F000FF;
	Tue, 15 Sep 2026 12:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789477074;
	bh=GiH3GbpixJxWQZTib2/+LhbytIGDPVlvBxFpYNkmPeA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DPMTw43P1rwYTS8P0EXbdxH9rXiDRFb59gyNqvlhle+JxNlmfssYbTgWzntdEf8+7
	 0HO7EWNVGdWxkTBDOHq1HRl8fY4n2eYstKC0w1Nh4TQI3oaBKFXDRd4wJPWDsOsn5Q
	 huukrddzTV6Q7VCVcibqr4n03efIgjVNpxoXY0xT3J+xttCaK1YUDQAMuDshsMMERT
	 nlpwvUx0EBXwTs7xXGytKNk1Bvjj+WZm0uZZZSeJx5bDBk38PzthI+jSrEw1k9g2eQ
	 BrKvM56sdUGbqDgKQs6p9TfLTemtacuOAhA5E+UXITXM3zcHyGF7hIrQAgKLHH7gDz
	 qF4Bl1KsOqzmQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 1/9] mm/page_alloc: factor out the accept-and-free
 tail of __free_pages_core()
Reply-To: sashiko-reviews@lists.linux.dev
To: hannes@cmpxchg.or, "Naoya Horiguchi" <nao.horiguchi@gmail.com>, "Breno
 Leitao" <leitao@debian.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Miaohe Lin" <linmiaohe@huawei.com>, "Suren
 Baghdasaryan" <surenb@google.com>, "Oscar Salvador" <osalvador@suse.de>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Dave
 Hansen" <dave.hansen@linux.intel.com>, shakeel.butt@linux.dev, "Johannes
 Weiner" <hannes@cmpxchg.org>, kas@kernel.org, "Danilo Krummrich" <dakr@kernel.org>, "Michal
 Hocko" <mhocko@suse.com>, "Ard Biesheuvel" <ardb@kernel.org>, "Borislav
 Petkov" <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, "Vlastimil
 Babka" <vbabka@kernel.org>, "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, "Zi
 Yan" <ziy@nvidia.com>, "Rafael J. Wysocki" <rafael@kernel.org>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Mike Rapoport" <rppt@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "David Hildenbrand" <david@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, linux-cxl@vger.kernel.org, rmikey@meta.com, linux-efi@vger.kernel.org, riel@surriel.com, kexec@lists.infradead.org, harry@kernel.org, driver-core@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20260915-hwpoison-kho-v5-1-3bc7a57bd503@debian.org>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-1-3bc7a57bd503@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:57:51 +0000
Message-Id: <20260915125752.277B01F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Stat-Signature: pg18rqinqisaepm4oqsmfqduiewafzdh
X-Rspamd-Queue-Id: 19529120004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789477074-104690
X-HE-Meta: U2FsdGVkX19i9qO5Dcn5kCnbo7jLHb2lREkJBlKBbttLI1earex/ehNR7DGoQIu0xMMqhuJIMgEdGQdoZNzL0gBamUtM2BIxDkYqRJlBs8hDmWQi3WsS+DKsXg71ZRQU/WjBjOrK+nE7R7m1C/lYhcNPvHiS8whJdh4i4cll7+V8SdynH3gy4B4Zo+klUTKzcJnELqMJUo2Knee7zQFWcUoPXj5tgdSZiv1ckU0sv3yiuL3m9ZMX1ggbm2o0nxp0ErClhapGN4xCVpwurMn9IgXvJLLpZJgXp3jCIhnQoE4bNAKS33A+EEo/cXtianF20/03qayN/ePNIHivKAmZfUwlgu1C2eQDU+1XfhqZbBidtk7b3FQYGf8gjcJt+oUz19Gbrtp+Q3rhEpJuIeP8cQF+3f3HhnESusQ0C/UP763lGJ515ODn0U7EgJO8X7O+mWUpIK8amxMdA40GvH6O35hpDgmKoQuqY0aRNXDOph9/uHzhhTRUdV3FAwhUlN/np39onktDnmr0Md9xkHFdVPJd8aiD7NR71rCf2UM9DQRQyFI+Tj3rJU6IF49pPE6hO/6X6W229CQ7ii9etp9ne/0OGgv9630/fmmXGZrxyJMLe8vrqIMUDFLmW44QEE+CmzPoNEfkamc2GjFVIUofniUqBWor6i2DTK9EIsdsepjkJZWqrUqbGCDg0xQRqbRVdZiDSBbIg7NsFi35D8VzvWSz8t0qOokw/eLbnOLBaKZZqKljzCt6XlsaheKPyc8ufFXwKUzU5iemba/4TiFQLSnLr1XGNbxVj5xdKlKuEwPIKcCyTMItptq7ilvIz18HTvX5+5eaM75ycL/g1ks+qfjehUkojK6TMpkQbFizPXvyztH+Bu2AvLErN4c0lSn7iFRF175+OiY580GHcAHhynxdQ4SZKixVbINK1jrIBMmC47jEyiiWnST7cvG27oPzyz1w4rEULq2VTcnOVMJ
 aPZu/ScT
 qH7tKrhBVkQ15jZEH4Wm+pYtP+HwoDmYJqj0bpGvGF+iC0bm+s/RCIRDn1VfeKecInDbrbYvf/W+oOnu5SogGSCwbbW0ovVaIED3A4ekPf8YBLpZsOOPj9fQ+VUORCCTqqS0i9wq7DcjpMv5+bViaJ+coUoYwNx6SWRn5XdXWUZW4CKFl5xLrbh1Mym1/Ke9xt5vVldOQwmwv+LmUPoijF10bOkxruDIh3YBxnYRXK7JGt4sqh1XOaJkA+kx8HuHDKpHaigC+BedOP3QIMu0GAXiQq2N+6rxeiqFDyPPDdFJLy0UTN/W1FNJ//O7VhT+PotK0lC7xdaK/BBp44CzfV3neKLcXzlsvjwRxgyisiF/TUdhGd+J0Z6x8DfrXO/1RBYbpIVMuLWZft+hJJL7sTRCVJAn1lzX2+GkNxFK+lU2z9GOEkSZlf2mT6/vSy8ygNTRZjVvJUKigcDci8OKKSVbXyby6089njXOUQdwf78DhifipT+A63ySd9kpMA0RsBCpLbAKsLxaNGpI4jUdb/D7RvdsK4jCbRqVENGuaGwt8lPuLNVp5+nVGci3XVKG5KsGHxXB8bN5RfyjRJKnfF1hUgdkQ4xbOjRka6y4IzRJFkOSs3ojRaRBxLttF5NK4riiAImJJJr5Pu1rtSd++VD3q2/THd3unFiSbugtPSJThXX65ZH+4weeMSL61t6O4CDfaEyfymULXOVqLatVI4s8p7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> __free_pages_core() ends by accepting the block if it is still
> unaccepted and then handing it to the allocator. The poisoned-memory
> replay later in this series needs that same tail for the parts of a
> block it does not withhold.
>=20
> Move it into accept_and_free_block(). This will be used later, when
> we need to accept and free a subset of a order-block that is
> not-poisioned.
>=20
> Signed-off-by: Breno Leitao <leitao@debian.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-hwpoison-k=
ho-v5-0-3bc7a57bd503@debian.org?part=3D1


