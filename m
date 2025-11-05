Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 538AECCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 09:27:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB79C8E000D; Wed,  5 Nov 2025 04:27:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A412E8E0008; Wed,  5 Nov 2025 04:27:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 908D28E000D; Wed,  5 Nov 2025 04:27:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7BABD8E0008
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:27:17 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 37B01140263
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:27:17 +0000 (UTC)
X-FDA: 84076024914.21.CF7E53A
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf09.hostedemail.com (Postfix) with ESMTP id E13A9140004
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:27:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762334835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6oopl3rnEC27OqMXL8plwbRq1JSX2M+l3j8nKcRqlpk=;
	b=LP3sh/K80+IfiTTm9X7VVYIBPvKr0wbrlmqgjU9AT/O/LOgnsatR8/IHuwupU0ZUOZeIzm
	x7ad/D1Uk6vAW3ZdkN2brdbTe2fuw4dzXukwmx9/k2S04e/kklK/Xks41YOmM+CQIjSwNU
	3UQMCkf8D9LftjD1UyAOAe7A+/NDmtE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762334835; a=rsa-sha256;
	cv=none;
	b=Q56dw6uvUxVEwazjXxgFJsscj6EnHP7Z2iwVhEHS6jRwt4zC0s7FxipiJzYHr5496p/2B1
	0WSvuJ2BHQM3BQ6zBi4uGTX2s3GNAFlU5QDAmS37T8OLinBVEQXJ8YWY2I55bTyJiqnknf
	5clzZLTnk30CNUQ317ELQZ86gTh8+QA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 5 Nov 2025 18:27:10 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Wed, 5 Nov 2025 18:27:10 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Chris Li <chrisl@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>
Subject: Re: [PATCH v2 3/5] mm, swap: Remove redundant comment for
 read_swap_cache_async
Message-ID: <aQsYbvpPweyWUl3b@yjaykim-PowerEdge-T330>
References: <20251031065011.40863-1-youngjun.park@lge.com>
 <20251031065011.40863-4-youngjun.park@lge.com>
 <CACePvbXO8oSH+-igG1pNFueB5JdoDOadV0n9DNN++iMWgCDiPA@mail.gmail.com>
 <CACePvbVydfq5DFP4R3tKXtN-UmZNQJMxm-p-4+fYFwyPfLR9cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACePvbVydfq5DFP4R3tKXtN-UmZNQJMxm-p-4+fYFwyPfLR9cw@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: E13A9140004
X-Stat-Signature: 9rbd5jsh1jn4bk4fgcjx5rhj444eekwx
X-HE-Tag: 1762334834-235574
X-HE-Meta: U2FsdGVkX1/Q7HGrkSneTZMqkM2xlCUdq1SSZGOtyA2aXMh8VosAhakJ3BWPtouYmVrOANO6LdJMNH6frdWPAdaIncwqNaqkTuXeBSc5z+XW+aC+2nN5B3b7HZCg9+lhD2SFqkANWoqNakWOTw0JlEuHXXLYjiMzU2xB0Y6CMjwrg7uxjNl8wVBF0iIfFGmAzVI8jWhtxSZnxkINV+XRf+DIescI0wIohJSKcWNsjOlXXRkDsPMgsdj88zZncUaJdqSx+KgBMLg422sEG+ic09h+pCwRmnn3lYbn6eEWxoJMk2cbLwGWcsr5ejECiFQ/40flv+qUiAOAOHAlm+O+4WYf/0yGyudHu0s1XGcBjaBlC/UNvqd7dhLmazHh91bmD/6EukFjfoTePi8Q2lzgjnI828KkKE3Yh0xjJ7yJWGXkwxzvBfBdoRRtRiVY1kpInZAcckBrQ2/WRPu2m4myMnVNhQ0wx7m9nDJdtfT9VskG/W2M4O+cwxdyZulFk87yYNHBNiMIehwuTt59/kfJclkVsy9lz8855AYc+hGFLYTJkYC6rI0ICYcKW4WjGi0e3wlqrCfzuFzFPX+R6CDEC/sRCn5S6zNZgMry+3ZNmjbsnp6wMRHRM5N8zuLqHwAdbOYYAw/fL09Z/mZdUHtAPoXKfS8twzBYKifbHlTcaQnl0aTcpztgZf+M6Fq3eP2xLfaBOLs/uRtNulIl4P3crXpi47JMNQq9GXnIhWjU7iTiLaEMIgf0DNLqwjjqcS/v4EdlyIfvYuXLSeA14UUt/Yh8YTveQuEMtl/01zNLL9MD8vcp7iXFT7Lz5AsLCu1Do2CrpLxyt03c8R/AJ4a+bGwNDG9uzw7cYRo83n9USM3ZLRN47ettdlmFzdDuu71KKXAx6lkjYRz+VBKMKM4qD89F6tx35Wxz2djBz9trqTsLrzXCzAfO8Yy+ft1TEpP5MtDwjP17mIZJluMcqM5
 9kTK3Utg
 zlVkIzL6+Y19S8oeQgOYMPH+3kpHEv02G0C+tuMHl/QwaoWQo4IahBEGsnjLtJn40w1qEPckBeodmAw0zizfBQCRsxAl6Uyrh9IUcSKHiX5E7vo+RtWYiMBPrh99Ipzfj92QamP9wy/EgyxCso7cy1vyj/OCo/RWa1bWh45wju1VXL19LAZxfkBx/da/LIye3ULRLri+21g21W6kpv/bCVu1+HfCJv5+A+9ECMu04sIDv+zWNQmTwprSK9FC9ZhtobHtA12kBZTx+g7o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 04, 2025 at 11:58:17PM -0800, Chris Li wrote:
> Actually this patch can be dropped. The swap table phase II 1/19
> already addresses those comments and fits my description of what needs
> to be done for __read_swap_cache_async().
> 
> Also, the comment adjustment is much better done within a series that
> actually overhaul the code rather than out of series pure comment
> clean up.
> 
> Hi Youngjun and Andrew,
> 
> Do you mind putting this 5 patches series AFTER the swap table phase
> II? It is the comment adjustment anyway. If there is a conflict with
> phase II, I think phase II should take priority.
> 
> Chris

Hi Chris,

Sounds good to me. Happy to have these queued with adjustment  after phase II.

Thank you,
Youngjun

