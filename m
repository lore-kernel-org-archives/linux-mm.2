Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D565CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 07:10:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9BA38E0009; Wed, 15 Oct 2025 03:10:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C73598E0002; Wed, 15 Oct 2025 03:10:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB09F8E0009; Wed, 15 Oct 2025 03:10:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA6AE8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 03:10:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 783D51A0B2C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:10:48 +0000 (UTC)
X-FDA: 83999476176.08.5D7679C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id BB2A7C0006
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:10:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OZx30LAw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760512246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nyu8SUXyNeo6aL/7MLinZA4GRx3d1j2MtiFO1gCCobQ=;
	b=trYdNXlmcrHCaXcfS1PZIXI1TZvnOAvrE5999Fnc0NdIQuXJJLjYcmH4IyNAcBgd6GEy7q
	MAWYl8OBoWKdSJsQ+RL6LJJZ1Ndw4thjsbz/sPdLqGlNgh+Ig48dAODKbmU8EFAxGn47Nj
	Ax48aOyjWGQdond+w0B9UCQXqsaYv18=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760512246; a=rsa-sha256;
	cv=none;
	b=PSFSWWuxddcEGkKfVecP887TuOpa66gqUg5o0J4U89xMr+MRUAQRB80xQxG6VHtb7S/MRD
	BPKMAX7Tsl8zZJam6y3qimoBTsC8G2LgLSMA2IdvzxBpqtvABOYq3l88e6rcP1QzOGbz2W
	SVmVzQ7F0fC6PgobMwutsW6UdogS3p4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OZx30LAw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3270560298;
	Wed, 15 Oct 2025 07:10:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1DEBC4CEF8;
	Wed, 15 Oct 2025 07:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760512245;
	bh=F6XEA9b/WIuMYIbxBjEHDXJdabmhas9e25A+k7+TJMQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OZx30LAwyJMjpxckQ/FquHzM1LwSmGYscCGhcbdgfRJIOJ3hCFaAW2ElMNehp713c
	 /X2oaS29okThe+nrgPPoHulukEOKJA98YYZ2mCyQwU5mZz4AUJ7pokRGMaPKYSMce3
	 PuVhzcN8KnEtTWhoCtJoaCQbcpfOdGGcbllVuMiLZFtMRG2cF30wgWprtT5JUesZ80
	 DtNT+UKcoIhY4TV/qF7n5AfBG+bzHDEk3zR8fjAtKlU59NCMpPvSLQTQ7v3UZQ+u22
	 nwYcF/HsfZESoglixG0NXAK57mEA3uLNbZba7TLyyUdYrWPYS9Uv0Qd8vOYeuyI9qE
	 MBnlMKKDEJsKA==
Message-ID: <ed5fdaf9-f813-4b47-8f4d-7f2988038402@kernel.org>
Date: Wed, 15 Oct 2025 16:10:43 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] xfs: set s_min_writeback_pages for zoned file systems
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Carlos Maiolino <cem@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org,
 hans.holmberg@wdc.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-xfs@vger.kernel.org
References: <20251015062728.60104-1-hch@lst.de>
 <20251015062728.60104-4-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20251015062728.60104-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BB2A7C0006
X-Rspamd-Server: rspam02
X-Stat-Signature: woxi7si7e8usa1ynb9w8my1qs843aapq
X-HE-Tag: 1760512246-862481
X-HE-Meta: U2FsdGVkX182nHo+B51kiq5p3lSZq+zq+wirkW7kFrbrKhRJIMENBwVDvNj4dwO0jipjjJ6LtFCBRh7F5y5e9fJvYAQvpGcqwyLZwy4C+T+1F7f5VtoXrZ7CULjKru88jaLoo0AUNOuUJ4lbiE2vibzbFwRvGYCYi23q68jImcmGYd/zzIdsTSln6C7eY4pA7EB9WJgQgqRnTrKAEKvWEYyXL5supeWK0UZ9yAUaMCzfiglhDUVrX3ZYSe4nrYoKc6ZZYqsKzMMLZV7QTZQ37aXJPol28DbF2Ey0av2nrXiKEhBmGkEqGB+l8q0EEOo+nzpcYWDnKqARUlYG7bu/c4I4xOjDSNDm4GL/v7rVM84H4N0h4CLS+uxjfVyY867OVwLCAE59D02MADlyAgJ25u/Dwmfgs8a+Ij1oPXmYx1k0WDDj5E+AQfOb+/OwvW9uBnkP7yfS6JxSUjnhAGNxjd9nK89E/GJZzlV9BdnPt55K56ukJyGvLbxJj09fUBSUaABfzdCAem2rDbrtH7vywJ0jFYUt9ZhTfx+spMVXgwYyP82MW7mVs2m7oOJnmkVBI79rZMa5bSLNP7D6iNvp6rN+qoBOURm6VE6/27maaHdFCrwaMyjtOZvW8L5lIwQKu/wV3qC6isOM7xAENfBGS6Y1vpkpf1zlgIAxC6MXdETK+mhrr6HyfF0l7O9rWLxQdfUq60y3+ZzXgvnOdSU8Ya0IVdnNEQmJ0YYlTN2KjKVDd4mLxDeJPz1s12Eorq4vgZW+PldLomzqUDahNXjuvYAudfqG8WiMgKCLUvOk43jPqBMJ88qh/DLdL4JmnF+LVVudLMrHoyRNyRmnmfIBdIw0bqRfyeQrVBIMt1ivmY4WJs2y1zM+k0NPm1MUaDOZUfTysXpikwRpYfYPSb3KNL/yMzKZkU6l8TvdUQNci1S5nX/nPL8BZlQnXsDNJrrV/igi136Qh4eh83ioh4C
 BOGg8KrQ
 soDJ0CXbDbvECep7PPhHkyziT25jb4CT9q0gFaHCxmex+2p6HreKmOkXS+lVvPHGEORVeydzZymRjf+FbQMQFPPjfngDad4RqKrg0RTM8b9NX1tqDo5uwZB/3H3SnMFyx9WhhOr6lVT6SpXIt4tvrDza/m9SssXcVJ8kZ1QEBZVP+NsEN0ZyWuZMB1Vba2WxJ0OLtXM98iSgzajC6X1h77b7OUqWaifyQ6FAs1GvP6nU40IIoSb/gge553wOjDI0ANdNFLRRMl0eKUvF8WlmpkZmM6yNDapxl+iZqrDZyi4DwfiTYaIoOOgHReUbLRqJZymgZlOLHbiWiqPgj1/CocUSqHcbO9bAyJY3WPHAinzdl2bQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/15 15:27, Christoph Hellwig wrote:
> Set s_min_writeback_pages to the zone size, so that writeback always
> writes up to a full zone.  This ensures that writeback does not add
> spurious file fragmentation when writing back a large number of
> files that are larger than the zone size.
> 
> Fixes: 4e4d52075577 ("xfs: add the zoned space allocator")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research

