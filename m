Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D229ACD6E6D
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 14:59:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BEE46B0005; Thu,  4 Jun 2026 10:59:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2963B6B0088; Thu,  4 Jun 2026 10:59:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D3136B008A; Thu,  4 Jun 2026 10:59:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C79F6B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:59:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BF71388544
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 14:59:51 +0000 (UTC)
X-FDA: 84842539782.26.977F3FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7CD1810001A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 14:59:42 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780585182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XOqQyI3gZmKvelsdA1mwzglKHOSKd9JIfd039oOU6sA=;
	b=Ye1+2jT+uUkd2xkuXWOoJ47scvwwNGbdfKXW+zxvQa/IM8bceirS0QN+JuemuPZyBzaf+h
	0B3ziHRNgxva4OAF9x93zibSmYOsxfFqiQ1KAqg4A+UVDUb5itdVkb6I1IFuUMV5Kn+j9C
	13KmpKzz/45Fk6JdkE5HfKiCY09UPp4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mOTGQ04g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780585182;
	b=0eRkkODZ7barwl8wwZjeojbDCUzMi6LsJvXp95Z6PHqOd9gz+FdEP35XTTJ73OCqmqIy1y
	HFNRoEUHGENBhPmEe5p+CDAhQp8/phugWPJgH73TAabS/56cYcQ2/y7BuIudRDHiFoNcLC
	dWC2P0BfYpQmEPfwBj6SbhU6pWv2H6k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B83A9404D6;
	Thu,  4 Jun 2026 14:59:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1125F1F00893;
	Thu,  4 Jun 2026 14:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780585181;
	bh=XOqQyI3gZmKvelsdA1mwzglKHOSKd9JIfd039oOU6sA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mOTGQ04gfuV1tU91ShWH7puQNjDv5Y2mgiZZHX7RpupDx3xftNmdy8PXdS/7foNSe
	 ye6JT5PnUoFW9CEFsrBfhKacEQ1I6iKHUaAWliWQIBPWjYQvZjZtejSWNHf3+Me4YT
	 y6jr605lyPbCuJOMwrSj13hW0ZgKz0KX9ywPG+woChgEB99MMlVDgj6ucfm9RFcX9g
	 rUlq85OIqjt6OOhTotQqIOi3At3YGRchWMf3IQtErsHS5954UTDpty6dia83by4UsM
	 tmiHPw/P3hmS1C5eUiw0Jxgap7JCXOlEz9GjFtpjo1iPyIq5CNGI4FEoRO5gzuUuB0
	 Z7Zp99Gorhr7Q==
Date: Thu, 4 Jun 2026 17:59:33 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Vivian Wang <wangruikang@iscas.ac.cn>
Cc: Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 0/2] riscv: mm: Avoid spurious fault after hotplugging
 vmemmap
Message-ID: <aiGS1e6wMwcwC-sC@kernel.org>
References: <20260604-mark-after-vmemmap-populate-v2-0-ab6a7d03b434@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260604-mark-after-vmemmap-populate-v2-0-ab6a7d03b434@iscas.ac.cn>
X-HE-Tag: 1780585182-603852
X-HE-Meta: U2FsdGVkX1+sxcEFuT/ExAaPCLhUxzm4uzsi8CI+/PWZwFJrPw4cp40/EwLUDV8DQmM4T2VPrLajc1mJk2rKw8S8KIazYbt75Gni2miqcOJlAo/kpEinsAn/CYEA6AY/iw3Osyy1dU3a9H7KmXQq3xt1jitgfDFg4x85QPnZck4OFMoY6lW2uKzAiaFKs6JPPpAPtAA7Kn31FW87v6mBUYPidIVWRUgc6iPJevHQ16B/r/U+6/R1MwYLnTUr6UwhXomZ3Px31ez7OKkD4xPeFzENpQ0xa6Dr0DeA+4D/VZ8k1MtgQcC9t1ouumkx9yyQhsaELjDkRrRwbMZBHFLMG+AZE6RHlHLsWOeKaRLCGEGW1CTJFjXA8G1I1LN11B//aX5LVazHmh+ytiR4YKdeUojF3IUwUlBCx1G8rvgd2P+JCdDG2drd904niHGZkiXMyRr6eEBEuTLDivgUscrhJPD4eK0iGA3f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 04, 2026 at 07:11:53PM +0800, Vivian Wang wrote:
> Patch 1 adds a hook and should be no functional change on its own,
> whereas patch 2 is the actual fix, which depends on my earlier kfence
> fixes for mark_new_valid_map() [1].
> 
> Found while testing AMD_HSA/ZONE_DEVICE on SpacemiT K3. Using
> ZONE_DEVICE requires another fix [2].
> 
> [1]: https://lore.kernel.org/linux-riscv/20260303-handle-kfence-protect-spurious-fault-v2-0-f80d8354d79d@iscas.ac.cn
> [2]: https://lore.kernel.org/linux-riscv/20260309-riscv-sparsemem-vmemmap-limits-v1-2-f40efe18e3cd@iscas.ac.cn
> 
> ---
> Changes in v2:
> - Split patch in two, hook point and riscv hook 

I don't think it should be split. You can add a hook and it's riscv
implementation in one patch, anyway this should go upstream via the same
tree.

> - Explain hook necessity in patch 1 message (Mike)
> - Make hook #define based (Mike)
> - Call finalize hook only on populate success
> - Link to v1: https://patch.msgid.link/20260525-mark-after-vmemmap-populate-v1-1-e698d859ba16@iscas.ac.cn
> 
> ---
> Vivian Wang (2):
>       mm/vmemmap: Add a post-population hook for architectures
>       riscv: mm: Avoid spurious fault after hotplugging vmemmap
> 
>  arch/riscv/include/asm/pgtable.h | 4 ++++
>  arch/riscv/mm/init.c             | 6 ++++++
>  mm/sparse-vmemmap.c              | 8 ++++++++
>  3 files changed, 18 insertions(+)
> ---
> base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
> change-id: 20260525-mark-after-vmemmap-populate-68bd790839c9
> prerequisite-message-id: <20260303-handle-kfence-protect-spurious-fault-v2-0-f80d8354d79d@iscas.ac.cn>
> prerequisite-patch-id: fdc42f2647e21d111f44a6532887a6705cd470a9
> prerequisite-patch-id: 096fa339c84c36643ae4311fd8362dc63e23d950
> prerequisite-patch-id: 305c876a5f4a23a840a8142aea79b796ed297545
> prerequisite-patch-id: d78cb55d6a616b1170f06a401c8fd44acd11e5d5
> prerequisite-patch-id: b02b4a76e94f3e2821291d4c23b46f6e5ecf5203
> 
> Best regards,
> --  
> Vivian Wang <wangruikang@iscas.ac.cn>
> 

-- 
Sincerely yours,
Mike.

