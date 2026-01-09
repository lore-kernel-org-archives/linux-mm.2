Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92D7BD26D81
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 18:10:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1EDB6B0005; Fri,  9 Jan 2026 13:10:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCCAE6B0089; Fri,  9 Jan 2026 13:10:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAD796B008A; Fri,  9 Jan 2026 13:10:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B78956B0005
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 13:10:46 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 671128C1AF
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 18:10:46 +0000 (UTC)
X-FDA: 84313216092.26.F680427
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1137C180005
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 18:10:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qoekjSOL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MFEZn5w7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qoekjSOL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MFEZn5w7;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767982244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w6/wsXYX938ohIF3s3mdg5VDGmJXosks78mhgth3ppw=;
	b=CMdt9tnPA+Y0ReyYIm8lY6ttAWXZ6a0Xdk9zjG2WYA9SLfilx8tZMkvy3CiXq8WKLDp3cf
	t/WNeSQaf2n0ZNd/1ZqJJKLhmPNPcAAOi+5mN5vfbjFtvX3TasQN/uuGAAE7vHnfpyCMwh
	PJeDqIAY6U+HTXrQx6rHNo8ozizVikc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qoekjSOL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MFEZn5w7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qoekjSOL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MFEZn5w7;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767982244; a=rsa-sha256;
	cv=none;
	b=R/aPu1IFdyRZkETUm0qMJUsu+TeBSPZe/voHO5Wm8hu2kMkklSJE0DuZEmvWMkm5i7zlEz
	EICtc7MHqxt46H98zlB5MuTp5nHlRxCkqRkRem1YhSuIGBQaFQMjCFlgszGv9l/6JSzMZ0
	trk6/bdpvvj4+SuISjDHTpcZiZUkYJ8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 44A085BFD7;
	Fri,  9 Jan 2026 18:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767982242; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w6/wsXYX938ohIF3s3mdg5VDGmJXosks78mhgth3ppw=;
	b=qoekjSOLBupCxgTztQcxdJqRCjJ3T1OAtdS/9zXXI4+gQ6o3nQ8dIb75MzMVBGxJHTS0ee
	WUxjoECZjJlQnzsAC3gtB1Yw9yaEjrTRa5sXTuqrqBLe8IrTjfuakrlwriC103RkCXKjVu
	BEY3JgrWURy6nZ0KRxasg7SbuWSMl8U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767982242;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w6/wsXYX938ohIF3s3mdg5VDGmJXosks78mhgth3ppw=;
	b=MFEZn5w7NEQZ6ejWM3ZPWq3gnJYjL1U+40hkO/91o4n0hBT9BX7ge8pgbVZ9UQJYZF5f7R
	a1sqZM1dYWtTQsAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767982242; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w6/wsXYX938ohIF3s3mdg5VDGmJXosks78mhgth3ppw=;
	b=qoekjSOLBupCxgTztQcxdJqRCjJ3T1OAtdS/9zXXI4+gQ6o3nQ8dIb75MzMVBGxJHTS0ee
	WUxjoECZjJlQnzsAC3gtB1Yw9yaEjrTRa5sXTuqrqBLe8IrTjfuakrlwriC103RkCXKjVu
	BEY3JgrWURy6nZ0KRxasg7SbuWSMl8U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767982242;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w6/wsXYX938ohIF3s3mdg5VDGmJXosks78mhgth3ppw=;
	b=MFEZn5w7NEQZ6ejWM3ZPWq3gnJYjL1U+40hkO/91o4n0hBT9BX7ge8pgbVZ9UQJYZF5f7R
	a1sqZM1dYWtTQsAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2AD933EA63;
	Fri,  9 Jan 2026 18:10:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BJ0nCqJEYWnxBwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 09 Jan 2026 18:10:42 +0000
Message-ID: <0cca73ec-00bf-4ff3-8b6a-48c723d01c35@suse.cz>
Date: Fri, 9 Jan 2026 19:10:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] mm/vma: enforce VMA fork limit on
 unfaulted,faulted mremap merge too
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>,
 Jeongjun Park <aha310510@gmail.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry.yoo@oracle.com>
References: <cover.1767638272.git.lorenzo.stoakes@oracle.com>
 <6e2b9b3024ae1220961c8b81d74296d4720eaf2b.1767638272.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <6e2b9b3024ae1220961c8b81d74296d4720eaf2b.1767638272.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1137C180005
X-Stat-Signature: agnwtu53pfzyf5kose3fd71ete5d14ry
X-HE-Tag: 1767982243-534041
X-HE-Meta: U2FsdGVkX18BBziz+qJiJHPKuEiN5agCQPpF2qbDYJNJZGpOrMhXg2ZfFpR03+edyd5efiJAAnnmwsIFJ3Lf9V3uXOxvvzFAqWGAgf+rpqGcNTLcagtFoyFPaPJgdUkClxBbzbL50Lw202sIgIk7cb5YuAniB9Nazx/roaV5wu2o5DKmzT7iH1al+hkJxmxZEo/L+HXwWUspcQ2tr+UD5sseHLLmhRImJy725cXFfQGnIJ0FJlJM3/m/zjxYQKR/k3Hhm1hSnNd9pOvWNEZhuVRQ7iZuzwm21NAb11tdrBeYHjfxU07bK2DSBEu9hMtsdfB3UqUnH+Qvees/9Dc5+UL9tawHubgWUA0zmkZxNbMuGjCdYuOMOQb73TcpkwqWA4TgppM0AKra5S1LHW0HvVmaOe/0V/isXrNhsjkDwurRvKLJ0kRJqqomdAPKMARGEL2G/+ZpID31iX2cRbE2XBmDzg2yaBop1nTDjkzFKwS79M2NLZsu1RQ7atjx3NHVis1mrbO4vG/QBaxlNCaSORtrn4PpFSAOazKTVbBCDnJBjdyZwd3Y5TnwwPnMCZPxkWTx78LsFtff1iQ/5hoLsrE5ESBsBn2cN6gqQtu80Z6odiP3SGcoDbE/ojkgovRr1Q1R1etHr8pJ3V5bhwsg6NeDVSbpoa9qFOs0hvpbsYtNXH1jCuRUNVZc7cpQCXk6POTuBpox3aexxpyP5U8w8QlXuIa3IsrEproYaO1p6iZnYlxTVzrrdz6z1eHUQMG5GL/cdT3boP1o8KHE13oLTo0ysCuzs+pZn75LWLv9lS60UrR3fDx36zrUi8qic0nftpYMWC8SSynGzoE8lcFabeAwLz6iG7OedqYXbOsHDy6yMFHeGLBnD7zdc2DKP7QO5pJ8hTJti8aFPTjmsoYs9OnizIeg2e+sAWGF2kdPbA9PXhewM9r/CQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/5/26 21:11, Lorenzo Stoakes wrote:
> The is_mergeable_anon_vma() function uses vmg->middle as the source
> VMA. However when merging a new VMA, this field is NULL.
> 
> In all cases except mremap(), the new VMA will either be newly established
> and thus lack an anon_vma, or will be an expansion of an existing VMA thus
> we do not care about whether VMA is CoW'd or not.
> 
> In the case of an mremap(), we can end up in a situation where we can
> accidentally allow an unfaulted/faulted merge with a VMA that has been
> forked, violating the general rule that we do not permit this for reasons
> of anon_vma lock scalability.
> 
> Now we have the ability to be aware of the fact we are copying a VMA and
> also know which VMA that is, we can explicitly check for this, so do so.
> 
> This is pertinent since commit 879bca0a2c4f ("mm/vma: fix incorrectly
> disallowed anonymous VMA merges"), as this patch permits unfaulted/faulted
> merges that were previously disallowed running afoul of this issue.
> 
> While we are here, vma_had_uncowed_parents() is a confusing name, so make
> it simple and rename it to vma_is_fork_child().
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Fixes: 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA merges")
> Cc: stable@kernel.org

Acked-by: Vlastimil Babka <vbabka@suse.cz>

Thanks!


