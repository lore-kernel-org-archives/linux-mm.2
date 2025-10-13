Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB49CCCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 08:09:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09EA98E001A; Mon, 13 Oct 2025 04:09:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 076D28E0002; Mon, 13 Oct 2025 04:09:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF5738E001A; Mon, 13 Oct 2025 04:09:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D98948E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 04:09:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 989C486CD1
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:09:09 +0000 (UTC)
X-FDA: 83992365618.12.94B3A91
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id D1E2C140005
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:09:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iJ+uHNeP;
	spf=pass (imf26.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760342947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MZvcUyE/3rm7XVjVfA5sB0LiuyxoL4N5gYGG3dyEWUo=;
	b=BNK7zkb6rrksWRuo7qUwt837wkzD+6c84cUe/Vrxoi7rKa07j/eMZfRh9gF90AqCw9pC3b
	QKJ0VRyfUvCwwv1Ku64ybcQk/MxSHcqsoszYhdME8X96Yy5xHtatzInYGRBezlqVFRKoOW
	ZnRtMIULSFUBbahNozH9DFkcvsKcugQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iJ+uHNeP;
	spf=pass (imf26.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760342947; a=rsa-sha256;
	cv=none;
	b=XJgIpGrtab8C04m2BJ84HR4SGEsu57FZtV3bsjnftOd5T3cEL767R7R1pBE3rQhQRG4tGj
	HQtcLLmM+VI/dwy/cgUsnrjll7/NLUsDUVlkMju1qOHdDI4QyawU18M81xgk/sGzi+2x4u
	PxrsYkS7bwRJmNQhvVzqKguqZjPfrHs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3325861139;
	Mon, 13 Oct 2025 08:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F32C4CEE7;
	Mon, 13 Oct 2025 08:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760342946;
	bh=gDCK0s48HW2hUV0Q7ClAR5lIhUaH2d/9Yb/F3zIIufk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iJ+uHNePZM88j5ktJ5Bn1podhcv/yo+c/xoKWvmJCMV2YxHE+DNLDoI56qVkiCpTn
	 TxoscpmAdTgCxdgycT4KHSRE3r70iCpIgB7T7rI+1qUaM6ZZ+nt7mZjUbSA4b7Lrux
	 lUjw2K+OcCGzjj/6Ls0XCbV18L5FC4//4YoTGf/NMPzI6P1qWPH60TtfBA4kJShdjC
	 iqqE20h+7G6vYXYQLxzOsnRt8mRSEdjloLa4cbPqMDozwhAdJFn5cCaxx1RclH6zYT
	 Ysxe5J51HpSdoRXr4GrxLj69WDrKliXSJ4D7ff5TWJkpFEP96aTqY2YXjNkXI3Iwox
	 H2lbji/ExBBBg==
Message-ID: <e0fa533d-c3c4-4a94-9e22-c379d69cb640@kernel.org>
Date: Mon, 13 Oct 2025 17:09:02 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/10] mm: remove __filemap_fdatawrite_range
To: Christoph Hellwig <hch@lst.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov
 <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
 Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, v9fs@lists.linux.dev,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 ocfs2-devel@lists.linux.dev, linux-xfs@vger.kernel.org, linux-mm@kvack.org
References: <20251013025808.4111128-1-hch@lst.de>
 <20251013025808.4111128-10-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20251013025808.4111128-10-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D1E2C140005
X-Stat-Signature: zqmtrhkjeusd4qg9ps74gfs6zjmk13qp
X-Rspam-User: 
X-HE-Tag: 1760342947-770140
X-HE-Meta: U2FsdGVkX1/42YC4B83r73wNMj25fQq0N2xEwojuDl6Pjp+P7fwyP/bAqNSuul5RObdfF2LgV/Grq1A5pKnFwqaICgLYYgpMU6rnlIbB0eC4XKgMjyXwxwjNql0nE84gpkamyzvXlQTp4o26LhfHJ2m34R4fkz+XZKrXRmGl8A+s/MHpMlLWQPiKaxsj/0TfAusQoZaltddZb+wuujD8d/d1RvF0zmKeJoJpc28ijS8r7g0g8Up07COOseUGYDewHOcPgPIBjG5ZBs9sG7BrXcJw61Cn/6TZmxKb+Z5wVp0RnFTtApjQL/Ry6isDpjzMv/MUagLkncATxUlbDNXyf/d+Uy1qzjhMCDYFakIIl1h5Zzfo0Lo1ACVM2GddI/D93JZ8zURLt3aW0C+BGOzzsGKAbxE8G7xY12MuTMAMbIOo5BBYHvSdkBCAWlnTRJpN78NqLVk4zkkbID5yP9h0shcTF/VFdP7vpHbeRIj+r0Xlm5y19oUFEmGT3+K3bRDm8Vd0LM4x2684NRmq/gv5UyJh89QhG5+vX08nR330sXQDe4gvN/0Yw2I8KcLjbyPMbQZhglgfyozgZoZ4T1/fZHuu8BLpGNWEfuRwnFFK8X8I4lsUFW2lXLLfFMBmSt3StfOyTLX6HRJvoRpXZZW7ZyG8j75NUXpyH7JMKgg1mxudFvO4RQaWf6iSHbIB8m5ASP3HTPxrqjjUcGG7jbYiBIvOJjmI5a4RfEuYUFSrK4VMZUnOkfsOaUM+PuDEZ5VebO/tJqjeTRv+hq3xPqqRUkYEJrpn0t0NEkeZZF4EBx1Ldxe2p6bkWHqK6sipiAWcjElI6etq4qvHIlX7Nm/n93iq4Kp9xS6FtKZ4ZIrm2FJgw9DnTVJvaerqtXydwyQvqtGmAqumZys60xcFsJ7o5ZhKDwCpYQf1BsJhEI8VOvP4Rc+0RTebXL8Djz+iCWZUSr0c2J9ZXRLBfLxktsX
 lUcDWVgP
 5vD1U3UB5OP7S4ASFkHYgSVB4aa/BhyCb07h3vx4YlZ7Ff0YBiNm8Akjco2+78C6jidBtyfm6cpO+00376LkPFYEgiHzCVGeWnixcjlyLJBom5PcRPTHUtqCE2MFUyjXbmBuo3PzPbVpHCqi6TAugP3btoNAD2Ad7uEFv18X0vio4wt5l/6XOPFMDIbz0ij0EEj6hwNeYVZfjenJZ6CJggqRGHvsGEeoeYYdxv+2lB/01xuqH0AWHiPqc8yWAmfZZ1SnN3kfL9siESRTpK/RUytFOKvq/ppSpKQ/VbbcbrR/U48znMWqp3g81xnNJKNmZR4jJEi/Yz0GwHsT0BAOcne/+LAH4BBLVz0MVAj04PE7iyJ0iNMpruhqSTrsuff71uN+gxKGzPpHP3Wc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/13 11:58, Christoph Hellwig wrote:
> Use filemap_fdatawrite_range and filemap_fdatawrite_range_kick instead
> of the low-level __filemap_fdatawrite_range that requires the caller
> to know the internals of the writeback_control structure and remove
> __filemap_fdatawrite_range now that it is trivial and only two callers
> would be left.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research

