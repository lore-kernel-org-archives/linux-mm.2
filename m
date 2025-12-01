Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54CD5D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 20:25:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FC516B0098; Mon,  1 Dec 2025 15:25:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AC8C6B009B; Mon,  1 Dec 2025 15:25:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79B876B009F; Mon,  1 Dec 2025 15:25:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 654BF6B0098
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 15:25:41 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 12F9A89758
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 20:25:41 +0000 (UTC)
X-FDA: 84172032882.29.DAD6382
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1C886A000D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 20:25:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=WTvztY8M;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf25.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764620739; a=rsa-sha256;
	cv=none;
	b=3lftpDRKgbzS55O95yxP1wDHFBJtAqNKelgjGSIP/Wk57qPc/O2DVD8kghLJPVGx3r2lls
	FcBlYt3LZ7QXv/5nMjtbS4zuRxGhnIzB4FvWEtRfIYW5LGe0onLwJqB42ZbyAC8S3DhbvV
	4uyHRzkzCwDa/iF+WelGNNRDPbOX7FE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=WTvztY8M;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf25.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764620739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f8RYmMAyCBEl5ERgqHoDL1DaBIqwkQHFzgoqQfZgPew=;
	b=AQFqG1mkmOas+fKoxiUZwjrfGeELY1ZYEvcxbC+zr7EwIfObXIgoAC3ofoeCAfjBBRxz6L
	bdpdQjJROCWmoWTNnl6cgVcRmwRXi+f5yeLTTNqTW1eF747nmQOhFZK4EUNHFeVp/xOj3b
	u/c2N7nO3Lc1qGVV7L/+EVMRjk/K/Es=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8FA9840E022E;
	Mon,  1 Dec 2025 20:25:35 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id SbUUuFlYM96k; Mon,  1 Dec 2025 20:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1764620729; bh=f8RYmMAyCBEl5ERgqHoDL1DaBIqwkQHFzgoqQfZgPew=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WTvztY8Ms6/lrhMjl9vjeD/SJr7//Vy0DAOs09aBOChza0WmFgoy+nkJKSi4XRjdY
	 qyZh5CKksusOx630nwoHTYRh0lnzBeN6L2Vw9O/cGC+R4LDb5whajhhQyKG3EFOjBE
	 zwoJ3dZr4Wi8YxCXMa234jv01RqvVJO9EoReVxCRU9WXgxCwKY2uULg1aQ0xqUuFHV
	 g4SNCQSme0dUvkCa7gtDV4IF8RuBokjTcxpxWExmm6647FccF9axFB6NUhneTjef5U
	 3Id/VpTWmFU7bCnytCJuPvxvy8gkE0ZJn5EsesmquA4h+l3JY4iGh9qYZYe+FFHw6q
	 HSrwwqO5MyccIoN/74kP1s4vxCkWItfvipRgoOnmQd58ycsWVBoCHTEi+8jyToyVAC
	 fH6uPazn5plfzQYxMY31g4otfTbqI/+2aLMqAn67kTPpJhHwr7DRHi+16nIqNAnsDv
	 jtpAlZIXB2lw/gn8tu5OK5Mab9oECGWsf41Ps1pd3lER9KsBRCqsM3Uo8QSi4noPSE
	 1KXVDw3R7L7tK5btyiVqaV9czP1QpwDwrJu4ls6mOG42bqYJChOh8gw6tND3VgOP6E
	 8VCfNp80ZIxIQ0Cr+3NKYmfAuyM+VwELu2SpKvCyju19aBqMdPYUGsFVNhZ75W/OhN
	 dGKHRZ5X25iW+EjT5D/lp2f4=
Received: from zn.tnic (pd953063a.dip0.t-ipconnect.de [217.83.6.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 72DAB40E0253;
	Mon,  1 Dec 2025 20:25:13 +0000 (UTC)
Date: Mon, 1 Dec 2025 21:25:07 +0100
From: Borislav Petkov <bp@alien8.de>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, "Pratik R. Sampat" <prsampat@amd.com>,
	linux-mm@kvack.org, linux-coco@lists.linux.dev,
	linux-efi@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, ardb@kernel.org,
	akpm@linux-foundation.org, osalvador@suse.de,
	thomas.lendacky@amd.com, michael.roth@amd.com
Subject: Re: [RFC PATCH 2/4] mm: Add support for unaccepted memory hotplug
Message-ID: <20251201202507.GFaS35o7WtLJOM0_jh@fat_crate.local>
References: <20251126223127.GIaSd_v7juUkaW4RTA@fat_crate.local>
 <m3l6gcjmbabudtnqwv6w67t7iz2mpmbjyrpnmiq5k2iyargn5d@nyf2zzxx7yme>
 <20251127181233.GBaSiUkaLzwANS_6WT@fat_crate.local>
 <beec5651-5c23-4f5e-a0a3-d1cc01a8490a@kernel.org>
 <20251128113411.GAaSmIs0kSWGhCYkaA@fat_crate.local>
 <47927c25-a317-488a-823f-ac0588f4eee4@kernel.org>
 <20251201111201.GAaS14AX18qeHN20xf@fat_crate.local>
 <052d7f47-edb6-4978-bc9a-c7eae469720f@kernel.org>
 <20251201191036.GEaS3oLBY8PEuE91Ap@fat_crate.local>
 <dcccdc4b-b7d7-47c4-b1b1-a6c70edb20fa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dcccdc4b-b7d7-47c4-b1b1-a6c70edb20fa@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1C886A000D
X-Stat-Signature: tcnq33w88p7b54oaajyqr67od1x3cwrt
X-Rspam-User: 
X-HE-Tag: 1764620738-541573
X-HE-Meta: U2FsdGVkX19ZuWe/wZdzM4SQKvM5OS65y7h9v7R8gBeNSY/l3KKa6K6weXhHlv5etMTaTmCBPlApb35X0Eh2DQvm75drTk6Qcu+6i0GrCrD4qG+3k47AR0v/4IF5Hgo2v37acMi5/Z6uHc54zvXd4GBDHE3QontE5JBElRXJjw2wj8X9DwWI+YpS1U5b00fQTXsh6R6u/mrj30p9CQOZ/Uorb00zz5u7veT4GRkipjlcU69EBmHVTFLnvqnpGerBxqLVv556VcaRBtaHwupFOu8p1YMAkzBZblB3XcMfobfNw7LAcE41wm37NjlCiclrPZ4Dz1z+i1/nFsHzeVUWe2HJQz1Asf3bOplPpTxaNr1F2O8RiPGp/k3wdCNQ5GganlQ19B9oFKdS4feOemfjfsOiE6DROoaGPB26gLJWhMeti+VKvpM1wlIqIYE0WErZ9m+sGCl7BZ3Ewdj0/FpeuZD4/MY8MTHM5Y6ts64fVMaLcStmS82Z4D2B4MvvTvECsxR4LeVwC3lbMHECUSmDg4hEO1TOD6fKCaLNFDIBvWv3AJSIdtpiET6Jg4xMA30ArKvtlsFQrQ9UiF5AvzuxHgm+B4DBPuptVMvIsytcbEwfc/+RDc5LwadoksqhbsmlfvMuETG02SpkQOQowhrn+6BS83/8unity4O8EFlHhCaNbhszg1dT525o6vOjkoFSmwbd4gQE0l5ipVp2rQ9Kf9BmZszFfkEpyzoTBF3o18q8p20aqvKRYuaRk7CtH6zTb7XXQDuPoJrq0mU9hWzMn0JpvJE59JbxQik/XhatTgtkfCfDTIWt6tDKrTT+P7mKkMOYQQbBbrQvZAl/CZJ8qR8c2hPINWzrSus6na/LtwL2F1CEViYwbzo+gw2FTrgNBQLS4X8LzqEPC8zpchCCo/EFIEcV5ZxK3zvPzUgR8XOv+7mgtgJq1Zt/ZZDyG7XznytrrKQHWvIyuMdiLJ8
 IBMkz6wj
 Qa6WOEFPxwen24Ym2O1pGXf+B7oCuCVjFuAc8RI8ho0uPli0k5JUaXYVqNkD73JxStryBXkWoQPRGGOgc3b3CXtRJJFJ4n56ezUyXFan1D4KWpgX1gGnVsOMSGoaLuf3zxIJvzSBq5NTgXsZbqVblg/S0eZqDcs/abQxYnAuq+P3tMb5wZa3rT35sGW+NicpnB8T7auqG/ncHB3SCDZY1nYF1rsdNSybKbEb63sJWm5D2RVI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 01, 2025 at 09:10:26PM +0100, David Hildenbrand (Red Hat) wrote:
> Just to be clear, I don't think it exist and also I don't think that it
> should exist.

By that logic if it doesn't exist and someone sends a patch, I should simply
ignore a review comment about that patch breaking some non-existent ABI and
simply take it.

Well, it certainly works for me.

Unless you folks come-a-runnin' later screaming it broke some use case of
yours. And then we're back to what I've been preaching on this thread from the
very beginning: having a common agreement on what ABI Linux enforces.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

