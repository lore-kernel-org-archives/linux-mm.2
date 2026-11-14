Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E5F4606A32E
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 03:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=aVqGh8zy
Received: by kanga.kvack.org (Postfix)
	id 77CCD6B00EF; Fri, 13 Nov 2026 22:10:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72DE36B05B0; Fri, 13 Nov 2026 22:10:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61C996B05B1; Fri, 13 Nov 2026 22:10:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4108F6B00EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:10:07 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B7C2C140359
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 03:10:06 +0000 (UTC)
X-FDA: 85432245612.02.3E43014
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 068751C0002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 03:10:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aVqGh8zy;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794625805;
	b=YjC3ZMmOXq9BJpg83GcoythxKunncsk0hRr5UA06bEIul48UAwRMH43ZDqv4TnecxsKXKB
	HDOcL7kiZ610i0OdCvwJ74xAPVD0vA77gy2MCOOxbnmwaq/xoJJdyVLd5A61pqFGdifn7I
	A/gyuytmfsUoCeVN9Yrlwy4NDmal1hM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aVqGh8zy;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794625805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WhYs0ocL7SsRFR/Pu3RA0F+kyhv3Pu7Av6qlVdHTERI=;
	b=siNTFT0ON6flfK5awiXKrqNo7qKWbVBqKhatbPiasTJqbwUAvk6R1tdXuNWLcujF0k90H9
	gGNPd0NwtNABkhodz9yauK82TJEGptVRpB0nndi7KIQTOiH4ER0/46qqUxmbszlzqpVNvP
	LANR9yJrOc6MUahli6c3O4YJoROJ5qY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E418F406D8;
	Sat, 14 Nov 2026 03:10:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8CA1F000C4;
	Sat, 14 Nov 2026 03:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794625803;
	bh=WhYs0ocL7SsRFR/Pu3RA0F+kyhv3Pu7Av6qlVdHTERI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=aVqGh8zyXQPShEVl3cgh0idkAXLy/GSl0ETBYb+2CpwKQuuN+vVIbvdKDWdfMM5TS
	 OG0GDBFKSqEqrOL9Su40Kg7jXFDeTa3P+zVlcRskhLXEMRAi1Oa8VCcPFP0p+U7kBr
	 ZGnl7M9nWH06YX9BpyIf8OSlHrTpboPcu9/fBxGc=
Date: Fri, 13 Nov 2026 19:10:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: sashiko-reviews@lists.linux.dev
Cc: sashiko-bot@kernel.org, "Hongfu Li" <lihongfu@kylinos.cn>,
 "David Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka"
 <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Shuah Khan" <shuah@kernel.org>, hongfu.li@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH v2] selftests/mm: mlock2-tests: fix fclose(NULL) in
 is_vmflag_set()
Message-Id: <20261113191002.ca262aafeb5789b0df35cf39@linux-foundation.org>
In-Reply-To: <sashiko-outbox-214060@kernel.org>
References: <20261113-for-mlock2-v2-1-f62195fc8394@kylinos.cn>
	<sashiko-outbox-214060@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uzg3oicooj7cm8mcxyf4n6144yjn5bro
X-Rspamd-Queue-Id: 068751C0002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794625804-753672
X-HE-Meta: U2FsdGVkX18i+X/xrLarwGjLPJDzKkm5TnTuHSGTWPdLVnGRn3j2fMiIKw3Hw3yqB+Nd0nfDENdaqLEuYcN3PkrzYQXMHRxPR6vKmeToBeLD/vHoMjrno+aE/oCLykOmul6h6/zgSRMg9zDP3irRphj56sJxp3TAkSWL3UOEJa8rn3YV2SrfZOqR9qf9Z2gQnEtMo+MnznD83KEEM40OW8Yn36FNFNTQKRPCk7OK3OcnNLgtD2mSpQ19GwvEhJqXkIXydIS6fTyMJQsNvyEwxxJHvELmgfEJQQU3Dhs18uOfSzyQQr3gHz+16fcf0umOJOcOLpWWMr86GAIKOD42Z7dHtIiLAlQ82Fb+ofjVInKZjg5pBEp8OQ08Hkj+DMOJPUyxfC36Txcc85L+OCYVDEm4l31Uj8J5Iz4Jz05bZj5gVm+q5sazS6paTnOWfibVnzYmDE1AGd+w4peADSh19DfspemlSfPaNmfkJFQFkN83K7kA7THoE6NGWPIXDtlQgQhqRV1T1wFVe3YpwED5x87TXcGmL/IG/iUKMhaTPPwR+sRx21W3DeFiGMVOVQISrf0OhoujV229MWjkSbbYN6QBe01+vz9gSnpTjjBV90eyaW9GQYBmc18czm4HIaiKyvn8YK1yfIb1mXrFZt8HI0XWjHH4RMXlaH/GdWYNLg2xj0qH5K14T+qojkZLouJupnAI/2zuOkVpT9L9N+HSk266G5vwbfC9oiYU5ey+TxRt3zQkLgY1tTf8zmJJfQbSOCQ0lNeRbkGLibN02JziJzDPbQ7vqEUdIx8SSgocK4Dcn1yB2Teae/S007OFA0ec0tF2Pgc1qC52H+KpkGwg0X/Kc3Y9Uezq6yN3jraZeN/TFAzw9cRvjRsZ/2oB6jG9TIqbUUd841Ssn4wcq53SQUSwIJfYl9ggKuLzcbRWfP4eWDLkZUecDiHLfogZYqzVZO3ul8osQn5dfQZG+W1
 ylicHGpd
 WSd6AOjeq1MPwSPtD8ZROtjRWI9SGabExuwGC7voRxSP3KQrydHyobdfCtXxpkIsUGgsTzcbArtD+UQONe22ikNhJKfwLwo+tTcLhq8R0gIXGjyNdgxAcokYEaioNTXymCdp+zx26j9Qr4w5/37Y//jLneRXzaacGT1HwI8yyxrcrr01nhdsRMXNq6Acf1zrVv9QoXM/tRIUkNgb2DSLNERvj3e0+LNrcZiB//zjhbxC84DkT659zg1VscRz7wJkfK0w3VlGexBwzD/41vBrojQCmT4cNnTPu4LIj4MpZWMvYId+YY2OH0jZzIfAWaIQa+eCO60SW2UoDdbksM5iGAlGfN46UDnycY/IT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 14 Nov 2026 02:53:30 +0000 sashiko-bot@kernel.org wrote:

> Since this fixes the fclose(NULL) crash in is_vmflag_set(), should this
> include:
> 
>   Fixes: b3b0d09c7a23 ("selftests: vm: add tests for lock on fault")

Yes.  Added.

