Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97228606A945
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XwbbEAHM
Received: by kanga.kvack.org (Postfix)
	id 959036B05DA; Tue, 10 Nov 2026 07:10:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9306D6B05DE; Tue, 10 Nov 2026 07:10:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 823A66B05E0; Tue, 10 Nov 2026 07:10:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 571016B05DA
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:10:59 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D57EC8030A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:10:58 +0000 (UTC)
X-FDA: 85419093396.03.C355CD6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 48F7440008
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:10:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XwbbEAHM;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794312657;
	b=7/rkfvPhXD2SMOpxoutLya9KtV62v+lfHQisBskfurmSf4Z/2R7M7+EB9dSOKCHqCcOaPs
	8ncsjbAVrp8qxsTfuF4Ykn8VvD85q9v1Blfr1lDXt4BdIWfgvTS/aGVTgjmnI7udkf7PSr
	v3/nvneEqEPf+6FQ96+NKw75L3FasJM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XwbbEAHM;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794312657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kySWq79D8+4JcJHqDpdMqOzDpgJqrKwfdWIwwZ4/JFk=;
	b=qOGtOXtZaAh41cv1gdP54K+KMD/DHx2DwMyZmOa0GWWWexFF935q5DlWIqBZIckes+geik
	5m1fanGqzqeTPWPnNyC98jZOijCBLc/ifZXBWXxF7Vf8L7TymKYLXYkn0i/Te502MBVo2S
	AoUq2zcXtOW2Db1dCsqr4FbegkWEnkw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BD1C961859;
	Tue, 10 Nov 2026 12:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3D31F0089F;
	Tue, 10 Nov 2026 12:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794312656;
	bh=kySWq79D8+4JcJHqDpdMqOzDpgJqrKwfdWIwwZ4/JFk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XwbbEAHMpst6vdv+xbbm4PBRNBPJ3+Gvj7oP17KXu17XrsFeXboo3H0vTaUaZF+ox
	 5EZiUbdKVJ27+lEnHMmnv9ujd5ArTOqaPqsc8n1P0fQQu9piB/JTHPxs/m6sUL0OWl
	 ATkcQoL63OZjDX9qQS6ExJdtndMB6D12jf7RNMm6IRZyEwRjwYcwv59RoGpZIJhTHL
	 rHuTpEndQci+y3BpuXW0zdAu2uI7LuC/Tv1u9k/e+SGl7s7AXTVNETVIzV5hfsWvlr
	 UX+NZVu9kqbQyy9O2tyNv/tMxIoRJ5+T0fDlVf626BGvOl8rqkQyo3EPCNKZytcXW5
	 xffGpJJ/SECzQ==
Date: Tue, 10 Nov 2026 12:10:51 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: n3rd <18670333770@163.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>, 
	"security@kernel.org" <security@kernel.org>
Subject: Re: [SECURITY] mm: mremap/remap_file_pages skip fsnotify pre-content
 hook
Message-ID: <avMHhOHuRrvVqWPr@gremlin>
References: <4f296d67.bbe3e.1a1c54655f8.Coremail.18670333770@163.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f296d67.bbe3e.1a1c54655f8.Coremail.18670333770@163.com>
X-Stat-Signature: uqo1p58gq67acdwm6poicyoirt5bwe7m
X-Rspamd-Queue-Id: 48F7440008
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794312657-444939
X-HE-Meta: U2FsdGVkX1/1QewcMMDDmQN8gBigj4lDIhLGHUE7sZm4TQNej5z0zJhDPU2uBSq1c8Co2hwwWjawhWcfhfvCCsozz9SCk4twTqXlJadWKMIQmt+X9dcH21kxWbA7sWR/cdRVmW03WnWCSBnLdUqjOJKoqqV8v4qV+mqvG+c1rwxYpnAgyw9VN5KH4p8X9qzYuobD0aZcHuBCNwmkSuUxXViF1iwTah/8YfqhHkZynaAVz2lDqltSXMOQ+5g+maZtu26Rq/GclNJR/5s8uU/dhjWyE06EfC/Z/qzaC0TaJHh3cf00B064Lv6KD9iYZbmfbaZDSg9yXIR55T5wLr15RD0UfMRbL3BVIQLsWK0aIG4LMBn/nhzv9kOMyRaO4cn3aL2pjb/EIc2EA/hH4YEKQxa/9ZWjkF5aQ/J3JpqV5LAiZU0H7ro1lxl0sYxQpjw3SPnwXHhET9osPMgBzHuLNgc5HDZObJW0zrPPBEzJTBXeIG4ofMAmlgQC9M7BxZbv0yionKhUuO4894YjDGGm0qj2On3ObLJkRtnnqrXLDWQyd9YjX7sPH+04ltjzFm8KfFwYuUngojFMm5oh48onM6tYNF/8kzVg20DeAypm72ru+UnexvnQ3fBTNJiGvtXDdWDu1ei6n23AMENJ5y3ItLQI6JHuqGwUknRYTEYar6M7odys683GmVqroinAn/O5FwO4DLvUtxQbpUE5HKGk8Rvtbi3oigMGOinu3B01wpLvo7HweR6smgLuZod46swBiGtR6NmQkiKOkJKrzFTOvFeq413M32QN7b308MN/zYztyYZRs+CYFwrkb0+n6J2cI9+ljjsfBkeO914n1KyppA2cdRA5dkJ2Tx7j1k4yzGgBLd8nokF41vBefkgHlJMjX2/dVBk5CrGrax2ELihEZ05jyFErO31Kil85yTp0WqsOPtmnllvNHt71m4mrFyiITc18MtOLPO/U+Lz6+z2
 IJt+U1Jk
 XxEBDABGXByY5Oihon+LoNtCxuADK8pUwP8+YhhhsA6YdWFuHrjmYRT2kaud0z0bGHOduVv3NOGtNYJVmOr3+NGLzOByK+dKdk6jDEfCpbKw50We7CRhT50rPraqjXJL/KO4Wd6JFA77t7afCFVqRshLSqUZuiQ7LxZXAVgepiCgPRiJXDoMTtXqWfXWKKafDvOCUQgLDCUH06Kf+hGzEL6L/q8FNzEPvQa8uJ8RlP5c/GGUGoUU6OUwVB/oNP8hiQn9rCK9LL1TuyjGnbywyGFw0iEpHOe+MQnjohl+f3CzSigdMWpPe57XwiEDJiQrblFE+2hYe0HCuP8mieCedSx2yejHLRHsPoFgsN3ulbJAtWQqO2PeONBz5vM2wFjs5BITzjk5GorbyKeg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Stop spamming the mailing list with your unfiltered AI slop.

You've sent reports for stuff already fixed. You're reporting non-security
reports as security reports.

You're not even bothering to format your emails properly.

And what you're sending is an unreadable mess.

We have no interest in this, please just stop. Thanks.

--
Cheers, Lorenzo

