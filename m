Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88456CCD184
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 22:20:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8E1C8E0006; Sat, 11 Oct 2025 18:20:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C65D58E0002; Sat, 11 Oct 2025 18:20:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA23D8E0006; Sat, 11 Oct 2025 18:20:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AAA538E0002
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 18:20:46 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5826ABAD63
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 22:20:46 +0000 (UTC)
X-FDA: 83987254092.25.282CE02
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id AE89D180008
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 22:20:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ludl2j9C;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760221244; a=rsa-sha256;
	cv=none;
	b=7VyFJrSqC1Q8PeX+TVHJWp4yPiwzP/seNvG7rIVuvHSDcOnBOwoEuyPL9BI6pLBEPBQnri
	8trDMsBIf5f/AeqcHPBe2PZPSFOqVK3GV0pFBSlptDz9V/QQS3Nd/ODDsNnn2rxQRd8be1
	A18Rir7xLyffNthjf2ZAQPmrtEJ3SL4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ludl2j9C;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760221244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ApUe67ktdRe9ILO//uYliBNrUE6nkDpzMv/t6tYuOsg=;
	b=ifWK3LRCAzKF76cpB+NtPWPfoRHWfy2YlVIouAOk/u6efCqeAR+qrTdw7AXqPvxJouvM9C
	wwgS99vW9QV+lDIv7KKV/hJW11OG+448k0twS+LM2ogvtvXXNBHkmaYfL55ni5xIicd7Mq
	NtqiXHcs64TbOevJHPhWSLWIV83CF5w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D4EFA60472;
	Sat, 11 Oct 2025 22:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B9B7C4CEF8;
	Sat, 11 Oct 2025 22:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760221243;
	bh=w0Ch1PGWYR23xW90AGLkDlnjd6lbrZwy3WsRV/8vBA8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ludl2j9CJrXuKwLZOFb/fPXtjvs+n7WohU3N6xu4FM9F2oSlLwH5CjQWCbrEVUP19
	 kxBjbArvGOTSsKE9P6NihOL0TA51fwUPfveoh3k7YXyuFB9Te6Mydv8ktBc4Fi5WYV
	 XIvhyrraIZYLz45PXs8hLS74gM1b0RuQrA+49ECk=
Date: Sat, 11 Oct 2025 15:20:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Aubrey Li <aubrey.li@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, Nanhai
 Zou <nanhai.zou@intel.com>, Gang Deng <gang.deng@intel.com>, Tianyou Li
 <tianyou.li@intel.com>, Vinicius Gomes <vinicius.gomes@intel.com>, Tim Chen
 <tim.c.chen@linux.intel.com>, Chen Yu <yu.c.chen@intel.com>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH] mm/readahead: Skip fully overlapped range
Message-Id: <20251011152042.d0061f174dd934711bc1418b@linux-foundation.org>
In-Reply-To: <6bcf9dfe-c231-43aa-8b1c-f699330e143c@linux.intel.com>
References: <20250923035946.2560876-1-aubrey.li@linux.intel.com>
	<20250922204921.898740570c9a595c75814753@linux-foundation.org>
	<93f7e2ad-563b-4db5-bab6-4ce2e994dbae@linux.intel.com>
	<cghebadvzchca3lo2cakcihwyoexx7fdqtibfywfm4xjo7eyp2@vbccezepgtoe>
	<6bcf9dfe-c231-43aa-8b1c-f699330e143c@linux.intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AE89D180008
X-Stat-Signature: z7xw9u6cqnmmh9ou8h7aks7958mfqoz8
X-HE-Tag: 1760221244-207216
X-HE-Meta: U2FsdGVkX19v0grqmEtDhzZE/mtv7z+HJyktA7OAt+HJsb0BZOfTvFiDhR5f/vtWE59NumiMsBptlrrZeFEJIB4LlHkpUFAFMIG8d/zg1j+BmRwGlW7j+udu2t4xnmhDcZpS4HUWx7cZ8z4sT7rWchTZCiZh35MRrnFf41yo8YJfUew8Y8jAVR6totX3eIvcPKL/J0s2qpZgIOZcg6cQu7yonpBOqw3VBa9hwG40mVaBrB7nN7SlYDigMNJ78+EaHc480GntgaA6WBY1flAqdXDwOtNz6E5HwZFI5m2PJA+tP08Ytf0jopuiyu3PO7IUGmQPCu9tFOqtp6U04GwFYwr8pc3/FPF2w2SxuabYs3IyJZu/O02DHd0lrLKhDdWj7j1WjzqRy7yNDg5SwdlILbAlYPdPWaADsY/EyNYvI+S1ewSNzWf7BoUQgAG2d+AFH6YN7bH8X89OobZ1Ue08xZbKtztB8hgijwYIj7Gtic0UCWAfWkMr9Vxp++c8GqwGHcPQd5kQ0g8mZyZCoPt5eskBQ15dmkGIPBxnEb6DjnPOd9PQcEBSVfYbw5yDj9ycBIBMeGlsCdBJXkul7unQXmW1hJsfi/87Qly0wPbk/cLKYvXGil5SIOWWh95jVoclWTtDaFkLvmFy9QPnz6zbhcinvDVjX4mJ7maRef9TccIsdCMX48mUAz+s2oelRI95UC1NWkViTCpluPJhJhHetYmCK6YK6N9nMTZH0S9otBH/7uEkdse2PIvSji51Evc9BqgirTJGE3qaD/ejFyqRGAI37k3jr2Nd6cvGbn2PNNIVSqgx28dqTuCSFMGAy9G69ckGegz93Kt2kLvJMkg8lPRITqQ9enpjfP6dr+oJavRlh16/h6zX+01fDcnwhDaIVBabMNOEpwq2q98crzlLBsRiNcVABW4uQ0hv8/bJODiWNI06/vdOnUlYidnSzJZ1kFwh9UIAggc4kkNQM34
 44cRZ4hK
 3F0/jPVtlbFW03Blvdy+NXBMypnRvKS84bx2qT5xraly7S3DIeJgCeH5ZCWh/SocUDISQpL1UrbQV0yHm1+qVvocbh8YtwtZaQ7fay3o3K/ZKgQqnrdVfG1UUEZObhic8CekDPawAmofhgWoqkR1WHnc4KkBu1q3+e85AG07Ij64Uh5Gdxs8Mw7mvlVMaryIgNcoquO++IrrH8WyKP0AYFmz36i23fpckhDG2Dkcac1Ib2MySzvkr6zCQSuHc1QM7TTN7/SWm21hvo8/zlav7c28aag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Sep 2025 13:35:43 +0800 Aubrey Li <aubrey.li@linux.intel.com> wrote:

> file_ra_state is considered a performance hint, not a critical correctness
> field. The race conditions on file's readahead state don't affect the
> correctness of file I/O because later the page cache mechanisms ensure data
> consistency, it won't cause wrong data to be read. I think that's why we do
> not lock file_ra_state today, to avoid performance penalties on this hot path.
> 
> That said, this patch didn't make things worse, and it does take a risk but
> brings the rewards of RocksDB's readseq benchmark.

So if I may summarize:

- you've identifed and addressed an issue with concurrent readahead
  against an fd

- Jan points out that we don't properly handle concurrent access to a
  file's ra_state.  This is somewhat offtopic, but we should address
  this sometime anyway.  Then we can address the RocksDB issue later.

Alternatively, we could fix this issue right now and let the
concurrency fixes come later.  Not as pretty, but it's practical.

Another practicality: improving a benchmark is nice, but do we have any
reasons to believe that this change will improve any real-world
workload?  If so, which and by how much?


