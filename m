Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A79C6CCD1BF
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 04:45:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7986D8E013A; Sat, 25 Oct 2025 00:45:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7485D8E0135; Sat, 25 Oct 2025 00:45:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65E5A8E013A; Sat, 25 Oct 2025 00:45:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5300A8E0135
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 00:45:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B58C412A6A6
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 04:45:44 +0000 (UTC)
X-FDA: 84035398608.21.B80B5D0
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2E010180008
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 04:45:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hDX9dsBt
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761367543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mQjSkC3ua7dzjDBzte7rrQ5nRmVgH3qrTQ90wWZPPLY=;
	b=WpekyZolYEnJ5lK1r4BL4x09RuZrdya8TJLGK1eo0FkZzfEzdGe7wt6xu2B9LBl+1xnDpB
	4c6pHABGYTtXPBVvaF3xGUvD7cRsm+Uz4vWMFuo79SbuUPyGJ5clk/hg4BoA6P52U8Djuo
	XEwawywxA8eYloYTStp3/en3FvfQKes=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761367543; a=rsa-sha256;
	cv=none;
	b=VOter+/QzWo8IzVptBx37XLTXOBw4se+Z8LPC+FpsE9g1MTWlQah0gy8XFELZIXtRvOeZd
	z6uIey2B8PNcPMpma+WXXj8F3itdAUpaQ2oYkYTZL37uG9D3zOhQloxDBK5M2oJjG7jMRv
	dkXRMIiGJDVWcl8VGNl5bI5ondpgkKc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hDX9dsBt;
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mQjSkC3ua7dzjDBzte7rrQ5nRmVgH3qrTQ90wWZPPLY=; b=hDX9dsBtzcXQhmANie+AEm0YjV
	vQPj5MEpcoB8AwXFuNdkmltwxQ5HpiwG1cTqtkVeoePAILnF3KENpgMIAzd3/DVFo/IiirZI9Mn+0
	fi0ShxIRMGcTV7vg4v0Xf15vjyffKlDO13+qyKY1LLfJp2bFl7UNyPofCg8ySrxnbDuOSo7nHmGoF
	5KtjMg0mCDSzvbPwLKHm7wtbOWD1igBnB4XsrR7UGfgPsro0Y4H0KYqBKZe8U2fJ5YJlXw+OfEVJg
	+Y8fR+CrgkgR3dYM/4QfOjvpRU2OEwjiQKHdRtPdlth+lEdJKvXaaHiJJm3zh8SVkJ9FBxJuOaCKE
	K7m1Gnjg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCW9i-00000002hpY-0vxi;
	Sat, 25 Oct 2025 04:45:30 +0000
Date: Sat, 25 Oct 2025 05:45:29 +0100
From: Matthew Wilcox <willy@infradead.org>
To: libaokun@huaweicloud.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
	jack@suse.cz, linux-kernel@vger.kernel.org, kernel@pankajraghav.com,
	mcgrof@kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, yi.zhang@huawei.com, yangerkun@huawei.com,
	chengzhihao1@huawei.com, libaokun1@huawei.com
Subject: Re: [PATCH 22/25] fs/buffer: prevent WARN_ON in
 __alloc_pages_slowpath() when BS > PS
Message-ID: <aPxV6QnXu-OufSDH@casper.infradead.org>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-23-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251025032221.2905818-23-libaokun@huaweicloud.com>
X-Rspamd-Server: rspam05
X-Stat-Signature: rpiogemmwsag8bzwedfaeta1tbidq3ya
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E010180008
X-HE-Tag: 1761367541-168431
X-HE-Meta: U2FsdGVkX1/daz3WzxLP81wqMOO3ZOLn2/8dOu3GcWiN0d5SvJbx13qvIs5XV+3KlCl6jr94fnFSaeWbdjvvfMOAwcJpUaY/VFFjokUT+Jb92JbnJ8M7YTgcrwTrOYyZzL27eamkspRKVt7aE6o+TuFtUD37M5Vv78QFhe2wCK01Kh868uqHSWji+484t4of3AJIrMxiJCNClT5R4mk/KUg7Cdwva3QCdZcgdpGIdfwzgblAb0FkfeTxqSsrgMhGOaZMc8ff23zqzZvFEDxqMp9Nk3X+HEQRHeaAzAL7sp89VsQT/nxB36YHW7Il9gUtQ4zejr9OPE43spegw6q6Aa9XhQLWeMsVpGdXb52JZKN+3gb0+cQWcixZb1WVcnWooKkDHLB4Kqi2E/oCmuhoqz9r8ngMLRhX3TD8lKhYZ1rphy38VdcJcy7srIJ7l8iZKp0q/t+kJFTNbeVrO7ujutkajYYNlE1sD+4qOGJM5+knOrpGPGKActjJXSuTf/vY+PUPOILfQk2zjyWCrbwTqEpd8JJNkJIrK7mb+rwmrMxmLPI+sbafyZV8SQ8NVURR7xAI8TIgmxSSGmLEQ6Af+BxLq+RtXF5bgZJlh0yYg5J5KP0x6uE+R4RR0waqU4vqgaQozuApvj238QMNdrvyfvgr1SX0/2H3/PKpT3f+ZtGiXRctXwY+9bHJq9p1uFR9/tgvsw30DYVXRWxNK7KzkxLIq04LVA28UeW36nwLWIBdWGyc1cWga9n1qb2Y/ft3WJV+FSaOE4oF/N/IaySTH0ftW40x2d+qY7dQx48bB6y/PlmZ6140+N38u66IqZmn+ty5wuWbXDuzLhW5jsLjcPkrQQwfdhRqQJyTLKR2C+EwpkGrom1jcH9iD3JURw8+cfcuLSdBqLuSfOE6Hb9UpcGIIu+EC6exdQaaqyYQmkhoTAsh4eHk3RpL9t/WxtSOPLrd+Qnl2TOD99kpRt5
 iy3sXYoi
 zSTzDBpkhjVr+V0cn5OeMV80GmP3LsDd7WyJGdX22XNoO2wON4i+dpj2lTE1RV8dfFoyIcao2Si/9A+HY08veOTjWIqZ5y7iX1/LW3ZrZv6usm3atwYVXYRnnHohBHSnAfcW5g/c7fRmANjYWbE+IYAnhZSqR2mlH/6J74rQzlEfjBthcI9Rjvvoalauga5y4+siQ4C0LupXsFXFKVjg85HLjPLxPc5zXpscxtX24KOZhSai65bylnawrQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 25, 2025 at 11:22:18AM +0800, libaokun@huaweicloud.com wrote:
> +	while (1) {
> +		folio = __filemap_get_folio(mapping, index, fgp_flags,
> +					    gfp & ~__GFP_NOFAIL);
> +		if (!IS_ERR(folio) || !(gfp & __GFP_NOFAIL))
> +			return folio;
> +
> +		if (PTR_ERR(folio) != -ENOMEM && PTR_ERR(folio) != -EAGAIN)
> +			return folio;
> +
> +		memalloc_retry_wait(gfp);
> +	}

No, absolutely not.  We're not having open-coded GFP_NOFAIL semantics.
The right way forward is for ext4 to use iomap, not for buffer heads
to support large block sizes.

