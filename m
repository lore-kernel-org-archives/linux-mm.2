Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9619ECA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 09:27:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE7696B0093; Thu,  8 Oct 2026 05:27:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A99806B0095; Thu,  8 Oct 2026 05:27:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 987066B0096; Thu,  8 Oct 2026 05:27:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 76E1C6B0093
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 05:27:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7205EA0524
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 09:27:01 +0000 (UTC)
X-FDA: 85298929842.12.9E6967D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3A0EA160007
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 09:26:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="MLPhnO/F";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uURyrTv+;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791451619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r9J/h37jwaSf9Oat6ZX0Xs/P9dCpzFnbCtqimX+FEfw=;
	b=owzY2xUPok1J4jlss9FeiTNq6pLpopWemKubgMNkjEJoVVb/g1qyOpkWjdty766vm1VkaP
	RqPCcIhD7f2UOwGrAXGLB/ZAo5Tgz67TDZFVcY6NNR8Bhu+4JStHoYjLrf3E8SYR/B6/Xk
	1krCabqF9+euvEKTzKUjrdUvmtbGZco=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="MLPhnO/F";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uURyrTv+;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791451619;
	b=Y4ZYNw5P+h8uZ4RdfaBi6GYLPx7wuUOcY5HsUjewX9m26pRHeFZ+ySSZkOAcrLyvndzBLo
	AlXcrVx++TSPeuuJLXnPeMT3AjaDZSUz4mcAHFYDYU6iPFmtUtVD9imufV6wM6Y/tIUKaJ
	olO6SbXJA+xtiB3LFL78g3GWJcSwrwQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F2C3A21BEB;
	Thu,  8 Oct 2026 09:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791451618; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r9J/h37jwaSf9Oat6ZX0Xs/P9dCpzFnbCtqimX+FEfw=;
	b=MLPhnO/F8tjDHvGqA36wUv0eytwTHqgKlBiw4KGMMqcNaY1J/c+mzBcRZZyNlIS5ZD1fyD
	qrnXZz998c/ts6+ki+/mhHP3p8bT1B452yp3zjFBxjbXAqbwaHIZbF9z8I4QQZuzZ22uxQ
	CcSPFCQ2HxP7Jg3fWfL4DOqpj0hMh2Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791451618;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r9J/h37jwaSf9Oat6ZX0Xs/P9dCpzFnbCtqimX+FEfw=;
	b=uURyrTv+nWnbSIE+uqGeKv1pwgpzPX2ROnUeXYMrMUhG4NnG0iggh5LEM0BAVyoG2JdGB4
	Y38bOEls0tLV0+BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CA4D313354;
	Thu,  8 Oct 2026 09:26:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FUxpKeFhx2rUfQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 08 Oct 2026 09:26:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 575EEA13FC; Thu, 08 Oct 2026 11:26:57 +0200 (CEST)
Date: Thu, 8 Oct 2026 11:26:57 +0200
From: Jan Kara <jack@suse.cz>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Ayush Ranjan <ayushr@modal.com>, Pedro Falcato <pfalcato@suse.de>, 
	Hugh Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, David Hildenbrand <david@kernel.org>, 
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [BUG] shmem: FALLOC_FL_PUNCH_HOLE vs fault-around race corrupts
 page cache / rss counters
Message-ID: <zlfk2ussq6ighnxxb2dl2nqhopposzyj45smrr6ztnthe6xcjy@uekwoodseblv>
References: <20260924061708.1645968-1-ayushr@modal.com>
 <arTdLsBENhrpOyk-@pedro-suse.tail5790ac.ts.net>
 <20260925053027.1998394-1-ayushr@modal.com>
 <20260925065013.3682431-1-ayushr@modal.com>
 <20261003033107.1488699-1-ayushr@modal.com>
 <6aa5a165-3ba6-4974-b549-fed7318ead49@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6aa5a165-3ba6-4974-b549-fed7318ead49@linux.alibaba.com>
X-Spamd-Bar: /
X-Rspamd-Pre-Result: action=no action;
	module=Unknown lua;
	unknown reason
X-Rspamd-Action: no action
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3A0EA160007
X-Rspam-User: 
X-Stat-Signature: jbb1d7kesmc961tcspwm8ynxouc533xj
X-HE-Tag: 1791451619-395506
X-HE-Meta: U2FsdGVkX189mIhImeskh5FW+4QxrbMEhZCTMo8xP+83PsthP/VX2Bbq12IzyoMb8FLa4zQuzatvzXgxYKJ5lI5snakp3bQlGUbcNwUFUmBcZfKpYXoiHFzsRxkjBle1OcVFXIn8QDOp8N/cm4m9yaXAqWH/qdjIX87GsUmdgtKmGMgqnjOtNmgW/iTaIQZ0gVzTewun8j2m6WBzODzFQkdbppb8y8tGiLhZoUKrdzG3WGEQUrFkZ3c9/zR8sJNLSsGKBNFFiKGLSZkpSx880iT94s9DhkdmI7RJlBfIyZlnDQpFbescpsJ6bThVXie+OYg3dJuDBz3ItJV4FoFG4obQYKn6yWRacvNurTlV5h5SBBfcl0IIyC8Lxd2sEx0pW8YOj6Q6mu6aQF2CG7xuLN/rAbs/+4mZDJcHxOPj/u2mM8LPXoYQQmAh+Ta5cFjkX/wD0nkQt1DWBKaP/hj6mlbDtFilJGT1ZrlQDa4d1CFDXWKwuNVCEIdqu7Gc80fT1sAu7t6a3581ga3D79jCvD6eqVfaA6nqB0IvMPlynTd6IpTOkOeUfAoNcv4nl7PbpxY4gSMYhpNg8zP2YemHiHUYPrLQEQPbm9dImMgUEmzD1mUva9RApKngamLyam8DRLrmeoRlWG4QN5LpnWGiP+ePTe4luAovl21Ynpj/dn5orVphNYffBRXNftjIrsJ/D07kdcOJI2vKTNd3AWPBz+94/jANXdP9gaJjul+vTLolysF6PJr7oUHfPAu7N/x2DDW60050KsgauLZMdb2+SZ2tNUB6bNzK+9JTykCvUIB6SZZCopJ+KnugYchrX8LnisnjSf6/VrBXzrdsAc3tJWg/lsKzgGQwFeq3D7L2JNva2s4rKLbkcMimtvPrkE3O7F25K93Km73SLuIDCY9hUPl1E0R1BS1UCMq+WHSf5XyBIFWHUALLahu3HKxktKl17HVvmLnuGr5ybOxRHsL
 Bw95I28b
 vytx5vbs2vFZ32g95niyyT4i5xa46wTb0QHvFV7DLh0BhdAchF8NctXZlvJU1GTQX5XRhEyxXp90nEEorclDi7tZ2yyjaF/opl6MpIln2GOVCo8L9M44bNahv0IJkNDhFq/Wph4APVMUeCT5+cfzkdsaJC2aO0rPwbks2q2a2mGocWlAety0IGT1ebzuKhaxc9C7OaajXzaJjdBnK4kzjMJ7oW/a8PNTOc8zQJ7kg7VAsNv49FRyVgkTmGMgI6E+8ncxNmYnHZm1Tn4v3tp5M8q4w6IiNmubSnwvBZ7rpQuy0PQq9LOA0uOHvQnjkj5SVWIma9E+npKHa3SZQtlt/6ZPXE3yG1vRzWjXou3LMgG9Fw68PziDgp9OWofWmYzDgvM2iW1+mxTs3Ddc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 08-10-26 15:58:56, Baolin Wang wrote:
> On 10/3/26 11:31 AM, Ayush Ranjan wrote:
> > Hi all,
> > 
> > Gentle ping on this.
> 
> Sorry for the late reply due to my vacation.
> 
> The reproducer in my previous mail [1] triggers
> > "Bad page cache ... still mapped when deleted" on 6.18.46 within a
> > couple of minutes on a 128-CPU bare-metal box, with no fork() and no
> > gVisor involved.
> > 
> > We continue to hit this in production at low frequency, so I am happy
> > to test patches or collect more data if that would help.
> 
> Now I can reproduce this issue on my machine with the latest mm-unstable
> branch, and I understand the race. I have confirmed that Andrew's patch can
> fix it. You can try Andrew's patch.

Great that you can reproduce and understand what's going on. Can you
perhaps explain what I've asked in my reply to Andrew? I'm apparently
missing something but I don't know what that is :). Thanks!

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

