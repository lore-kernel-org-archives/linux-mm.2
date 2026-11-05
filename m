Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F563606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 09:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q80U/Jse
Received: by kanga.kvack.org (Postfix)
	id 4603D6B05B9; Thu,  5 Nov 2026 04:26:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 410FE6B05BA; Thu,  5 Nov 2026 04:26:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32D036B05BB; Thu,  5 Nov 2026 04:26:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 07FD76B05B9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:26:19 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 12E38120925
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:26:19 +0000 (UTC)
X-FDA: 85400534478.13.1161EB8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8017E100009
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:26:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Q80U/Jse";
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793870777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dPKDQBCBYQNiMfvrFyD8dFjYAwa7Jdg7sOpNKNrqofY=;
	b=gIP3UAr3LBmRDh9apuWAy5BAmL04aWtWDRctLCmejzPYtu5QSo0wYcxBG6edX1x1AbH/K3
	R4bgDZTWwR6dbSnxvb+ZPnGH4vaXXSWz47wOWoFCFuDE2/vPg184xDuSMTuhcYgG9V8A+Q
	dqtmtlTvEPOyHZgdQvZS6obXhrTARfE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793870777;
	b=w+RIAyLgrG153x5s/YdbBwkgak+LWrYcP7xbSFuj/udOcAACd3OEHbPiCVG4wF03s9XJCq
	doAGxURiIstceuZcTP581bE0ovWx9QPdSIcsAQr3IcwtKi6lFileRsoe4rV0qHN6xGuWCd
	1+ZLZ3xLL+2oDNYjiuZSqnybnN+uvHA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Q80U/Jse";
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 08F41605FF;
	Thu,  5 Nov 2026 09:26:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A621D1F00919;
	Thu,  5 Nov 2026 09:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793870776;
	bh=dPKDQBCBYQNiMfvrFyD8dFjYAwa7Jdg7sOpNKNrqofY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Q80U/JsetB0EGKNlhWAcY1cZ1tYtokLqJ+h6xwcw+jOr5gyZcw9/4tQvSIhTM/KpN
	 cZJ+dUR7XWwP74J1yWKuFgMMtpArg4ZXiWdUEayzYfx9+TXmQycQcdp4Wr9Fy6dqM/
	 pY9+hmLZbu8HnyPDdkMOYKeOVI6BXNEFxrAoI57F26PUd2vqYsPwYAshjzx+DJtN6B
	 yXX9uurlUAQOJgmMAZJ+G2fzglJR5LzaU1IVo7W7XaA84eAFhJSXvssj5DMShq1KGX
	 AS/AyLlA5yRHvzbHPZdTB6YC6Q97/Igw54dI0RoGTag/do/m1n6nAX/4shIrbluaWj
	 AVVyfXJ+30Wkw==
Date: Thu, 5 Nov 2026 11:26:10 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chen Pei <cp0613@linux.alibaba.com>,
	George Guo <guodongtai@kylinos.cn>, Kexin Liu <liukexin@kylinos.cn>,
	Sourabh Jain <sourabhjain@linux.ibm.com>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 3/3] kho: fix bootmem sizing
Message-ID: <auxLssVxRqlgMFRt@kernel.org>
References: <20261104-kho-bootmem-sizing-v2-0-b0d1a834780f@kernel.org>
 <20261104-kho-bootmem-sizing-v2-3-b0d1a834780f@kernel.org>
 <179381862329.2089669.11972657670874869389.b4-review@b4>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179381862329.2089669.11972657670874869389.b4-review@b4>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8017E100009
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: dtyy9b5qa9swgd3spbtojn6sh85xegrs
X-Rspam-User: 
X-HE-Tag: 1793870777-368833
X-HE-Meta: U2FsdGVkX18ojGcR2vLZBpyH07br/NvXtLnHM/qbnDB72RjK0PLDfIU8LcCVrSVxDQSpqn3pE7TDJsocTh/D1PIlCF4b/AGByJajdlXtBwQEXjg5+CEiwtrbukxBhtwbRULG3asRIZO1KYumtmvoP837HorjkHKPyGFRVaM1hedgZJ0Dki+sTLqUCmPjQuuBNEBhIYEGWdgG/yhgtMZOT1s5R1Cc+hGoy1D9JBRYNYdnMAaqC85SO0XD0kDr66ChA4XmplMQUo5HTso909/WpVENc5j0Yd/QbFwcobwsipZO2PiOaVSR9Z8VWeAuwoZ5WLXp8DIBxgOaTrkMfrA68sus+R1NCxHOaCTon+/R1+xOyKaozhyzER+8T5YbzTm42upK5gZ0D4roPEj7ecnlSv+SrS2UTCc1nq5loVudloiHmNEwb644kZdkMHeJAYYVmz141YBlMzeDH16keHjpOaDNNmIezffiTxdLtDeF2waEbwvfjEE2NGzmYF+o45j2kB07EMuPGQbEf/Q2q5LEH0GaiKV6rgoUllrC7XL729bW8Uxofx5UNiinYkbg0KK/C8kLUe2vtXpMfGGURiNHH5hRAuyJI9WO9/pP9u6dvNhdsofnOh8WTGHEkLaF7g58P9Se4/ycPBzFQU25lSeBte34Z5NgAyPMAmQlTHeEzlJvISUDk/ktt5oSmm5kAy9P1fDomWxSA8CszLffDeothLib4HmLiwUAFbaBcWVObARmaQDs8BjqlB6TPRgonm3HzMD3XNQk/Vov2PVC1Zp4hEXkPeVUnqJS7RZzwHXiSxVztT7paSXc5MHD0XsDxyOaQ1T5h/RmbnFJPTABX8cCOFGkTJpjqeqI9NP+LIFXcMCXcf81km9YOkfj1SHeCB1KA51JxHJL7ckrFQtho1/KRyEbXWjLvTrAd6fxYSFDYBjH9iuB/qTP57rPuvlkCqCaPrKmXpf7YeNpOIeU+EZ
 17ehPiju
 CrZY8QtnfZVpYS3QQF1KIiu1yH/6brcob1HyX9exK/VINKEmPu1KnAwStK2vcVnK5iOqpntp33x15wzwR9Qoo1NDRxQJfd4u+tkyYYtWPD3RgqTluu0jTO5teGH4LX4A0cui7dME4vTHhHqvl6SRlbzEeYfsYdkJzTwSKGK539rLLlhffN2uAbW2KnroUQ97gjlbOSqSrEm6nQLp355fzWwHNeEkGgiJGhhmY8L5vNbU8Rxt9/TGJqzmkVOJTCDHRfTuiiYqumQrHvx8sP+jMAnlZTldCTeYR8CyH6ermo+pbgeFSjeNYiaFsy//PC97btjMpQ52o3Km34AuOu7q7iFHkRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 01:57:03PM -0500, Pasha Tatashin wrote:
> > -
> > -	return round_up(size, BOOTMEM_ALIGNMENT_BYTES);
> > +	for_each_node_state(nid, N_MEMORY)
> > +		bootmem_size_node[nid] = round_up(bootmem_size_node[nid],
> > +						  BOOTMEM_ALIGNMENT_BYTES);
> 
> Nit, but I prefer to avoid multi-line indented statements without 
> braces. Just put a braces around the above.

Yep, I'll fix it up while applying.
 
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> 
> -- 
> Pasha
> 

-- 
Sincerely yours,
Mike.

