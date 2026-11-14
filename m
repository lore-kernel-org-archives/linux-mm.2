Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0331606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 17:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gBaw/DQH
Received: by kanga.kvack.org (Postfix)
	id F3C656B05B1; Sat, 14 Nov 2026 12:24:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EED126B05B2; Sat, 14 Nov 2026 12:24:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2AA26B05B3; Sat, 14 Nov 2026 12:24:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BD8CE6B05B1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:24:42 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7295E120407
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:24:41 +0000 (UTC)
X-FDA: 85434399162.09.D0EF71C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id CA47740004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:24:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gBaw/DQH";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794677079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KGSNI6t1r+TulC/SiKfw3w2XYf50+KvxOFXvkwA2+b0=;
	b=wh/kRbAw0AwjnngdCRz9AmU2d6Rliovi9WyfUF0R/qtOe0Egya4YvXmzyTrPK88nBXTdan
	HmQp0UXIpGOjGQ7lLY2A0y8fhBDOeUHPYVr+W1RrRnQb6s9rCwv32feSmmeJgNO6Jzc3mG
	zRpVm5Ey1q4VMddWgoIVyzING+ifdR4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gBaw/DQH";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794677079;
	b=TEsIDF8hjm/C1IufztXeK4rmK2iPShU+V8aU96xLLln2fQeLd84eiz793cX3USsvdJdTDk
	ibajeVmq/KpVGJmp03/8VdWPrAxmbTjuq4b8LHEFyyleD0qLQ1R22A4sbxaKvR7x8xWtE5
	xThIN7BHYenySGsPPtr6JlkuNgeJFq0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B5A7A414E7;
	Sat, 14 Nov 2026 17:24:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465281F000C4;
	Sat, 14 Nov 2026 17:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794677078;
	bh=KGSNI6t1r+TulC/SiKfw3w2XYf50+KvxOFXvkwA2+b0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gBaw/DQHE+HCt6pgA2K22JnPxufqmdmb70RTz6zh2rh6lcVOvYytTGcYnND/l19Wn
	 OYpFhHDZgUkF/qRDpnS5wakWtsv1IrEWO2Tx82L7oopmkW1vHH3I8Wry3t6GB8EzHk
	 K1DaLmCizuUM5I4uwa/xV5CxGICy3FOVV1cB1Tr7cpvP++FmOejT2gt+S1MJp9qNYn
	 NDrQ2kLGCuJx01c613gbf+TNsdJNKNTi//4d+gqHHXb94fPou4M5QRAQ7Hvbel4f4I
	 8H8QppBMlDCxPoB0HF9xxWB5Xbjv24TB1ybA56gIHhhwrzDdL5ArR2ySyDFey6RDPo
	 pzdpJnT4Qugbg==
Date: Sat, 14 Nov 2026 17:24:33 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: shao.mingyin@zte.com.cn
Cc: akpm@linux-foundation.org, liam@infradead.org, linux-mm@kvack.org, 
	vbabka@kernel.org, jannh@google.com, pfalcato@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mremap: enforce the driver's page size on resize and
 move
Message-ID: <aviY3AWCYlTjHHSv@gremlin>
References: <20261115004700194_SpQtdnE3JL6bzx51l-a5@zte.com.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261115004700194_SpQtdnE3JL6bzx51l-a5@zte.com.cn>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CA47740004
X-Stat-Signature: d48wqiqdbmorj4swuktqr5koyyxh8wcn
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794677079-67302
X-HE-Meta: U2FsdGVkX19zC3w2U4ULgk4M33Khbimx8KXki8nTZpC/FgumAiCYcSSBZ8E1RfDa4Hu5Hjq95pshr1MbaVYvi4VOPhF/nNX5eSRf4bdmR+scNpm3yaLvuBY4yyB1hwIT0GGrE8Qvu9PecgCy/w42u7fyr167ndxxcF96+9unuuXgJjnlo6NEdUW9yWd32/Bkpan6y0ZtgO09VtORT3AC+4IGjWPd3+Ad/7/9PtmaQW8pDTkAVA5MqQqnsDz8PebHNE3uYNcPBN3FwuspX01T9MvaI3FUm3rsrY/u4Qa4qBtR9im7WnCgbAtVzW6uGGzSh8u56kTpNZp8zJoGJywolMuKsAzBzG8tFWJMiYPZwFf7mqC9LjG5BwbzYP0Wws5nGHqBoROfPjDrbpdOsyox/NyYRVqiS4hcqSvuKayya1SZ4zBlg9b8NhKAO0HohpHFNdtdoN1VAb5ChRTIre5EJaHAhrdRmdY3RExThPtNpAA7jtSwj9RdtpEqcbIhzKUkZYkYyNKxCLznulB2hnOU7DGL8XhT7IFUvknd665xZLs1EJH4Haq5XaVDGePkMjR2OK1KNMb9SQs3PQ8mqenCELCoYk1jkFq+ePtfxa3r1fzY95JXGHOQq0UpKmyxKCTx+4FHLdQg0FlGPCwbXme1Ql7ZreF5xkUzAv14klhuaoBKx97Z5Kwl+QgIFTwQ4C5MCC+EOZzSauNKxAiIqhuhwN5ktEoXRa+v8CoS7TN64ZXiUjLs7MlcYxWmW+faYmArBnc+FdnBEf1lHOFXGVZdX2cEiuNWz3q/I7ysAXsn9mm7MWR5t08+ToqNXEwKTMz8fIqPWnEJ3ps7H+FZi4bQ8f068nHiZoB+zUsdxA4psoD9kUZcWGnqoSgbmj1mfA/QJk3uDkWSfshT81hauwTb02xgdwqseehiJIAKxQr5cp+LQdRKIvWxV+SxGsv77thAXrGQtQJ+e2Uvw6/KVSQ
 qyZI7mnn
 Pxt+9WATTXwzmQTpUuquBJKoSFlpG181zWL6KIz6EXVGRbpXeuT++Pvr5rxUjttB243BJaSaS8Rpt4BpC6A3BM5T6kHocYfJuuyIEPW9BiwvD6Wl+DmZSQJRPoVYUrpd0JwE5lcpC1dXW+fCNyomJ5L6sHOI7PLmXlf8WC2TRv0AZtue56D0n++SqdmrpJo7zNXt1zF2yLJ4VkTmRpmqrlZw/gMlWxjPWCq5JLVwb4HOyNlxKw4TT5NFLgn9sW8APXMqIZPGQE886q58aOvwAQNqNdsZO1tPSMnmNeMnCt14Cr88DDfMUHvM1C9CAaWHNRpY8X3RYDXNx/ZI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 12:47:00AM +0800, shao.mingyin@zte.com.cn wrote:
> From: Shao Mingyin <shao.mingyin@zte.com.cn>
>
> mm/mremap: enforce the driver's page size on resize and move
>
> device-dax exposes its mapping granularity through vm_ops->pagesize()
> and requires both VMA boundaries to be aligned to it. mremap() checks
> may_split() when moving a subrange, but does not validate the new end of
> an in-place expansion or both boundaries of the destination VMA.
>
> An unaligned expansion or move can therefore succeed and leave a VMA
> that device-dax rejects at fault time with SIGBUS. Check the final
> new_addr and new_len before moving, and check vm_end + delta before
> expanding in place.
>
> Checking the actual boundaries preserves an expansion starting inside a
> VMA when its resulting end remains aligned. The move check also covers
> equal-length MREMAP_FIXED moves. Existing PAGE_SIZE mappings pass both
> checks, and the existing hugetlb restrictions remain in effect.
>
> Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>

NAK obviously.

This patch is broken, wrong, and it's not even a bug.

Also, you are flooding the kernel with patches, 17 series across 7
subsystems over 23 hrs:

https://lore.kernel.org/all/?q=f%3Ashao.mingyin%40zte.com.cn

Please just go away. Nobody wants your AI slop.

--
Cheers, Lorenzo

