Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A02AFC982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:13:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B24346B0098; Fri, 18 Sep 2026 16:13:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFB3F6B0099; Fri, 18 Sep 2026 16:13:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A11C66B009D; Fri, 18 Sep 2026 16:13:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 871496B0098
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:13:35 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 94E8BA06F4
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:13:34 +0000 (UTC)
X-FDA: 85227983148.03.F44064A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 00DB61C0002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:13:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mAw5Ulvu;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762413;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IdDvdVBUP9dI0We8t/DLRSXpGyJGcqmjaxTczi9FQIk=;
	b=zQu5B1v8K0ucY5w9357VY2fkL/gDGLdMrcw3CVwECog7Pzst6tfXPtvxs+nwjlhlL6pSY+
	sEjR0UnNo5SjSHy4adSzSqHK45SzlBJic2aVBwawE/VEoftpEtnOz2LvE6fwZT/pOx28AS
	OVnfRLNmmoACe/TY4xbsUFufmp15gXw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789762413;
	b=xJxhbsi0NnLkOprJywtRi9ppxlQcVqu9bOASju9RM3pR84qBUX18AsBlaT7ilp//S6khVC
	y+LflKMn0qR0ES1QMJRdsix6asN0zUGrqHKYqzwVBw+zMMg1tdHKRO+qWPpC3BMHey6Tvh
	u6k3R2aVSoshduUJXssARzdA2qcOUz4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mAw5Ulvu;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2DFC6404EB;
	Fri, 18 Sep 2026 20:13:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56931F00898;
	Fri, 18 Sep 2026 20:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789762412;
	bh=IdDvdVBUP9dI0We8t/DLRSXpGyJGcqmjaxTczi9FQIk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mAw5UlvuSYKxbaxLCoAdn3B+ntHZiwR/3D2Ji+Fn0ZYKJwHYM8ZnlI2lT9lc6eb7A
	 JjVJDX7cv5qlgm8kMuylieYao30s6Af5TxWMQiJEToD9w/W8doPLT49tEFpV5faalO
	 e4dd4qJ/t0EnNhNTBjNF7Z7pkYdEurfIwnCwwR1jh/5z1uu5TJiV6qV2CDbJtowFRi
	 y4OCFgD/LrEhJJBx7yNMbEypfKALMLRBMdGc30aUkMmy+IZSKcFV14ouvIQE6Xn0cM
	 D5TpUnHhBJeSt1EhOMj9QrfXH2NLa+MBO+9DwxRHNR0liwtuGRHjPBQq/FYnwYAxIh
	 nxHv56C4VlqWg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 07/13] PCI: Refactor matching logic for
 pci_dev_acs_ops
Reply-To: sashiko-reviews@lists.linux.dev
To: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, "David Matlack" <dmatlack@google.com>, linux-mm@kvack.org
Cc: kexec@lists.infradead.org, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Jason
 Gunthorpe" <jgg@nvidia.com>, "Jonathan Corbet" <corbet@lwn.net>, "Parav
 Pandit" <parav@nvidia.com>, "Leon Romanovsky" <leonro@nvidia.com>, "Adithya
 Jayachandran" <ajayachandra@nvidia.com>, "Randy Dunlap" <rdunlap@infradead.org>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Alex Williamson" <alex@shazbot.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Pranjal Shrivastava" <praan@google.com>, "Alexander
 Graf" <graf@amazon.com>, "Josh Hilke" <jrhilke@google.com>, "Chris Li" <chrisl@kernel.org>, "David
 Rientjes" <rientjes@google.com>, "Saeed Mahameed" <saeedm@nvidia.com>, "Samiullah
 Khawaja" <skhawaja@google.com>, "Shuah Khan" <skhan@linuxfoundation.org>, "Vipin
 Sharma" <vipinsh@google.com>, "Bjorn Helgaas" <bhelgaas@google.com>, "Lukas
 Wunner" <lukas@wunner.de>, "Jacob Pan" <jacob.pan@linux.microsoft.com>, linux-pci@vger.kernel.org, "William
 Tu" <witu@nvidia.com>, "Yi Liu" <yi.l.liu@intel.com>
In-Reply-To: <20260918200640.887030-8-dmatlack@google.com>
References: <20260918200640.887030-1-dmatlack@google.com>
 <20260918200640.887030-8-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 20:13:30 +0000
Message-Id: <20260918201330.A56931F00898@smtp.kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 4tsxqysxr9tzgzxty4yau5exxsb5ka87
X-Rspamd-Queue-Id: 00DB61C0002
X-HE-Tag: 1789762412-782713
X-HE-Meta: U2FsdGVkX19j0ufBJbqKcLq/Bt9LFtqwUcCGR0MPkymo/i8ak7rS61irOHZz2kDfPRvLwFl/1Q3lnH83qisDYG+KlHzWmJR91E+GPZOnr2/EjApVZue5Njj7wOuntujnJS4G9oW4TWLDlMLsOEh62rZR9E2lP4vbY5pP5dthTC9iHs9hX2SoXVtinthxEkKiObPdXwMdFtB1mtjIuqSoeUTDA+XGyPgxKeXIAIApHp/7egO1KZqKijzh4LoFZdBHmu7l5n8dcdav4ssbIr2TYxNK46zmuuymhuqCfc1wLyPn6pLX4YKpEcYmMN24DLvh1H+dVFO2NxGXV8gju2Xp0SB+rcerhT2S0YKPO4e68NGtgcTwJf8iirr0y7ON0ZkaaPIVzVdTiM/4nRyMTLrQvhpNToGz2CCyzfFYw7MBCMA47KswSSIQWNOp5VrTrl+QX4RHLpkYqQBeszdcMg0a0GO1mCuKZu263GQ7dlR6ph7zAoc+1trPVOL0zUTKhh1xUEMwkfN/SD6Jkvc9Y0vU48eb6oi31Y5ZV6LeN17BZwLsR8OzIJBovM4IVn+gAueCDQKUL5wJEX3hbN9LCkI+qseYdmsFgHj9raZD30eLxe6V2G11mfJ+AWuk7X9K4zUxrfNSDOQGYl9F3veefA4dEiqh6f++PQKkeX39SRCjpzWGD2n4+q6wpWs07Vg6EeM7Fo+2BEougPNmH5Mv+F5AGN0jZegRUJzxBkw6dPONdgUA1WqizjmhBQRH7RBGeFRs5+VlButiaMDCsxXvuSwfii0w+VCBYxiI2E2zxkhF14NSDe+Wfdz7vggF3e188g9g/Kxgfaf5RCiL8O6fIqBLrgfcCFqdTDrp7Id6HicyFQS/sD0oTYTOBEhbxs6dn/d/O3nG62e2lRlNzNFXrewfPjWyG/oCK0BXH/Bm25Pmz9WuB5GbqzAPNhrH22OS2vL08fu8G/Xul+7rzf7MXjE
 7iUTKblE
 dOjSqoCyHZVGumPkJecyQytz+OTeKUdcwpuaOlvdX8ntSzJuY4DCeIWhuGbPXMMXyHxfeIQpevMC83W2Z4eUPWX8XkLt6Oxg9PeFAGhUvDcwH6KEAjTDlQ8euzFdhdE21jtjSrrfzQ+lKTKEhY6Rc1AGHUQ4vBYgwWQ/i3BgBozwx56k3clJVD/GolheuO1Jd44ndXpkDy2cKoJebRTHvr0kctxIac0YWLHrPgu25Jip33I0ZqpRKLMeW+SxElRfj+0otx1ligjYlw+y1KsA6sxgarAtoB22NtO1nQFb+KrU2LN/tDKmHQV3D9STbL1xqhDkX9Hb8nTfx0Io93Mt+loYNCtjlh+dyicdZ5MdoPKq/Y+ofybMsoocwmlVKmWd3MNZI7bv1jgwnQg+zlDz2r7CPGiCpR/fVKDpKCRx2tZhzbZkYc67DNkHEiO+dHMmyDIh0mglyQIQ6D3MmTz+nn0INmUQgdDVVePtrLaSs6essQXUW0OTpO9/s6OjPdX2Z7R8HII9zs3CZZx3khxea8mA48X4A1QCFTlXvUgZX9/T2Hw8wvfVIyvL5Wr207vgOvzaHMnIoVrHpZRGoJD6EIAX6VEblqviNsWLpwL4GLEWhLv+pSflFvHT+w/cH0W8BFfQlemSzBQEQ529HYWCcF2GmwYV1AJoR8hCH7vqX50n9i5s0CB1br3yQYxiwg7JXv5K8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Refactor the logic to match devices to pci_dev_acs_ops by factoring out
> the device matching loop into its own routine, pci_dev_acs_ops_get().
> This eliminates duplicate code between pci_dev_specific_enable_acs() and
> pci_dev_specific_disable_acs_redir(), and will also be used in a
> subsequent commit to check if a device requires device-specific
> enable_acs() during a Live Update.
>=20
> No functional change intended.
>=20
> Reviewed-by: Pranjal Shrivastava <praan@google.com>
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918200640.8870=
30-1-dmatlack@google.com?part=3D7


