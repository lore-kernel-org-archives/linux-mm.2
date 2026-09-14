Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 657A1C88E69
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 05:20:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 199286B008C; Mon, 14 Sep 2026 01:20:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14B086B0092; Mon, 14 Sep 2026 01:20:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 039586B0093; Mon, 14 Sep 2026 01:20:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D39936B008C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 01:20:30 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E707C1A1092
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 05:20:29 +0000 (UTC)
X-FDA: 85211217378.15.219A79F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 43AA0140007
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 05:20:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CkTExBz8;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789363228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o779dzepK0mFhzpZscdSpSvYUsF1kQ6qSiTkadkPzf4=;
	b=gZtMjEtirXzb9PY/QjEttj2wNclnN06cgYWsOkRsIg+CeG44fGYWk6PC/z6iRII4VMRjNW
	oS82NfSTWHa9qZWHiHgKAUi/biyMxB6Lv29gC+6tb3JoT4K22QROnhYyk3rHrD/NCtBrTY
	szGpLG1ulrxINVCtBIdxPB9MsT7WJWc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CkTExBz8;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789363228;
	b=sSab4MGJwvPU8rjGWTqUFa0SA/7M0TUGe8Np0e62Kx7ExZSniNFXaCocc7wO5IkROvL6Ep
	gZcEdoPoauT5SgFdNzt+KvEUnzBSfie3xyjxIGWdp7aCuXK4eNyfMo9a9AvnEe66Gogoor
	F9tNWBVjTca0Ya4AAJqeQW/fjUtkcK0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 140CD40278;
	Mon, 14 Sep 2026 05:20:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998861F000FF;
	Mon, 14 Sep 2026 05:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789363226;
	bh=o779dzepK0mFhzpZscdSpSvYUsF1kQ6qSiTkadkPzf4=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=CkTExBz8pPEMBf1jk73HqRy9cRVhv5/C+/iPCXbOYp6XW7Lzx+sQ1dPL4vfhzGUKD
	 1Qo4YLuCVLvhPKTxzUqjNbUy1Uvh7gG1I3nHUUqHzs/WEJuNkr9qBqahooT/6T5ZVm
	 oR6CnuJc3DGdo2E3oDlVtXriiCz3rzEwiOys5VH0cgx+ZEDK5FyJNz90827TMmdf6G
	 W2CcXEXQKcYkcl5oqdBHkuIsqpx+QgJgJl5qBheg0r2tbsTh9PXCq9NF/SX2bSEv/+
	 2xV2YnJfUQF8bV7GrpUBqRvCECLrzr3MeGPvYWJKa4h381dPopjrSfvVE5ZktcPrKV
	 K+Ef5ba1feaow==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v6 01/10] mm: memblock: add missing HugeTLB flag name
From: Mike Rapoport <rppt@kernel.org>
To: Wandun Chen <chenwandun1@gmail.com>
Cc: catalin.marinas@arm.com, will@kernel.org, chenhuacai@kernel.org, 
 pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, tglx@kernel.org, 
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
 robh@kernel.org, saravanak@kernel.org, akpm@linux-foundation.org, 
 baoquan.he@linux.dev, rppt@kernel.org, pasha.tatashin@soleen.com, 
 pratyush@kernel.org, m.szyprowski@samsung.com, mark.rutland@arm.com, 
 kernel@xen0n.name, alex@ghiti.fr, hpa@zytor.com, ruirui.yang@linux.dev, 
 robin.murphy@arm.com, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
 linux-riscv@lists.infradead.org, devicetree@vger.kernel.org, 
 kexec@lists.infradead.org, linux-mm@kvack.org, iommu@lists.linux.dev
In-Reply-To: <20260902073116.802752-2-chenwandun1@gmail.com>
References: <20260902073116.802752-1-chenwandun1@gmail.com>
 <20260902073116.802752-2-chenwandun1@gmail.com>
Date: Mon, 14 Sep 2026 08:20:16 +0300
Message-Id: <178936321614.3691424.10386784926753862087.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 43AA0140007
X-Stat-Signature: f9f3i4hhj8n5nc5jbyu5yk1tbdrrw6dm
X-Rspam-User: 
X-HE-Tag: 1789363228-41085
X-HE-Meta: U2FsdGVkX18LG/CN9g2KfW0dEEtRPERkkcLnNZ3YAepIdDDbH1L1p7l9NEXlF8MmdARh3E62z1B+ZyFJQvQtY94eu15UvLLSKp27z+iASyn696xia/+zKtj4AjrVdvDyTpqEYmV+rSnvAbFwUdTn3vD4Pf+7M1HcfvRKnwuijG6PcqT+uaA6mxHuPtg4F4l/YUsxjR1w38Ltv8R0yp+AQ+sH7eW/HDpcKxQUyYmjVvcNYnUk/kMK0FBzv8raOCkeoosPSSNYUbjBRF26M9m3xNjDIK1OfGaTLS2N/S41Hn//C9Lz3XMqzD+fvNfMA93eu52HDS9B0hmFg6kFC52DwEdIxI7lWDm89T355UZeXWsh5dx/q9nc+NjopMDYX1zr8ee+DuYDQ+Vr3EX41VGRcLwX5vgh6nQMzWT+IQg6Ui4lwqeo5ifG9+kWO6bWhZqo7GhlaWyb244SQFJW2mxlIA9InPHRThF6miC2avdgu04Ubvn84HYnFmQL/5AYYOPNQXyMsU84+BieERNSG+Lu4xW7/vmD8FYVQxg5hBH+Ny6JZGFBk34ckbUPmb8byq1cy5eeozEwpmmP7zjpogW/fvI9EHG4X6xKFgsFyEbJHjafXI4+trwCSxOdvnZ3O612eSJPXxEvrZsnEINwW1ituwmGF0YN9Z6Oxb/mQRHEq4NRlqm35oXOenGtmd+9rdDJBr5NXPwlI6ipoplXY5I6KzInFC0cZ/bqw+QRkEZe3Lyjpo32KwQlMU6GxA10WoGU/HuGWJONjtG9kD/j817wiSgSvp470PVq1CU4wV4fGvrkqMpqdV9XI9syq2kwJMft9xdOnveANS5TL5tRqAbJ+CFQgDsZJTF/qQe4QN4sG6Fx/v7NcV+th+awpUC4TWS3PZWcqDMmNbv4SuTRaUduXQt8jSwKv01ns+SxIMyJ29qqG+BYnPd9FeUjQqQCFZozWSQHV4jPY8r7SS1IRJA
 GNMFZT7h
 1uXpUMReymjfe8icSsYErIGkAxOPkUfgeZBE6wuwqykAWoQo8PEasWD2c5TVMofbSD4ChRrkxFGxsI93MJbJPO+YjEPj9kxrolT8M9BQ/uv0CWbIKuxf3vO5VpkxGZe5axr8gErdHPwLHbHEhcYVvxBhxP9FY2u7SrevJzEr+B+cjeekALGPjnumL9Lc2YEmovCceroZhwIRK1x3zZX7mrZS/tB1otKyS1trZkuJge1UP89Jw1s84PnYkBbx23UlbUKrpzr9jkE07zGU13K7wfFYC7cEG+vWjMSXVLmzRLDJeNTl0HLybxD7gVdOntxaOUIevNDFbuLha+Jk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

> Commit 7d163a75f821 ("memblock: make HugeTLB bootmem allocation work
> with KHO") added MEMBLOCK_RSRV_HUGETLB but did not add the corresponding
> entry to flagname[]. As a result, memblock debugfs cannot report the
> flag by name.
> 
> Add the missing RSV_HUGETLB entry.
> 
> Fixes: 7d163a75f821 ("memblock: make HugeTLB bootmem allocation work with KHO")
> Signed-off-by: Meijing Zhao <zhaomeijing@lixiang.com>
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
> Link: https://lore.kernel.org/lkml/20260821020910.3428585-2-zhaomeijing100@gmail.com/

Can you please send this as a separate patch, I'll pick it to the
memblock tree.

-- 
Sincerely yours,
Mike.


