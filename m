Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5AA7C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 20:00:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEB536B00EE; Tue, 14 Jul 2026 16:00:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9BE96B00F0; Tue, 14 Jul 2026 16:00:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8E836B00F1; Tue, 14 Jul 2026 16:00:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9DE8E6B00EE
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 16:00:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1E3ED1204D0
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:00:35 +0000 (UTC)
X-FDA: 84988449630.14.5DDCC46
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id 694231C0004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:00:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Quc44Btb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784059233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A2CBkxlbhYJRAR57C5mndFI8SavuY0NkUB+CXiuOB5Q=;
	b=gEE44xXXvWY6fjGIBx43ltbdEa6601WhKvxM5pSs2+eBGt0wQy/joE/GxKSmC2iGaypzb9
	cD3IGo6XespnJch7clCfE5+71V4k8yYzQeGYuH4/KNgFb0ZlOAKF5w8dGJdsccIFF8KZtF
	HIINbpm6JU3vFOQ07KzceosLUev7c48=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Quc44Btb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784059233;
	b=ixFZyTl5sHtQUaE1YSoqB8cEmVCdH9zZ5LlBMkDL/SmvOoZWFY4aBKUNZpukNaYR/elm+a
	I0A0w4zm1RSJciG448yQkcrf6MwCTjNbyig5C/4pwm0y6p7qQRgn2eSkL87O2KyI0FQD1u
	GNUKXvU6o1JnshUokfeK0YzA9lWtaWg=
Date: Tue, 14 Jul 2026 13:00:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784059231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A2CBkxlbhYJRAR57C5mndFI8SavuY0NkUB+CXiuOB5Q=;
	b=Quc44BtbaXKf68dgZXyNGf4Aaf1q5Gtl78Y/HbM3BOo5WFEfCY52DsJbRCm3Ml4EGvIDnP
	wy9yqHgiFs2biTETmQPI1yz5Zb2dVinvOw1bf4v4ujYQgbaNmWnZmH1xaJ+JvIYnG6Q8bd
	HhhBs5kMLWTFPX8D+5v3iyNo/zjD4i4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcg-v1: fix wrong linux-mm list address in
 deprecation warnings
Message-ID: <alaVR6KxkQgdSADJ@linux.dev>
References: <20260713085756.2973549-1-guopeng.zhang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713085756.2973549-1-guopeng.zhang@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ouz34ij1f3ryk8dt4of1ubjnzy47u1gt
X-Rspamd-Queue-Id: 694231C0004
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784059233-623568
X-HE-Meta: U2FsdGVkX18Xi/DAz+ZIrTe6Ke72lyfIX/U7cgKBNEUUDf10ScbpR4f+SFivwxKxfdPXnuF3H/u0dxCkchuUthjWLw+mQV1mlLRxqcG/n1DnVhH9ZKCObJjsc/qTm5GyzwNecOAfKqkYjCsPtYqYInKGHa3QvqRVwVVYr5qWOU2JdK36snz/xO/V8BX/odJ3VPnS+0cukmeokQDGOTAmegzN+JYGucE4E1PG6B4rhCCus92mZ7GKY/8xn7LSPiNSyd8Xk6iB4QyeQY2eOQW+b7bCfcoeyiFWfsmWM/4B4Pd9FF7sZReN0McGRRU5yoJctIHJbNO4FrX3OsOyc5gLskdDWCPw8Snh1uL42dOxV2vyg9gs9QKSpoHQ0pzH61CPIVY1HO3v1rXfmkimcj74jKwq0d1hQNAHtFN4wwprT05Ifqa4tX7If+yYrAaAsa1KhJlWOgLE3L76utPmNG+dReM/aTBuxGP+0YgGKnjyK4rpWGyHS9nKXbp2+v/UO0Wh9SmV3BiL7bqGJVdACw0qVq82nimJ1q+kuOVUVO1UPILdiAvwkCE/tw9VzluOmtqhl+j0sV1083orduE9cbEAHVMU3o/nIB8Gv1aQDLEfgG7gpisgkCbmR/xzYkfBLMxR5kOWaFkWi2DgqLRrFe+uWWjJIK0q3rBUMcMFDu/qYlzj34tOCYHT6bS4IzLzNA/JhyYRPdcQX8U4O3FXaGsV8yD1Rj4T0DbnXfiX9Ynf1jSEWh9UF5+qOzZrYy//6nmvbOIBQZagfydwEoro470VQ7OPGTY5uQlk4JmrsGsB0y7IIxHZ+bgo1VthYCPGSb7xkJ+oZ0AyY21hkRxh6kkT4bLl/9jjIqKHg6eNaWZyKzY0uKz0FJQsEZE1W22G5E0xcJYvWeUd2/lz7V1NmVkBrNBaimExiTntjsks3F8QGTDySmw7zNaZeuCOBOUKLKd3uPZ44yFlDOJ1CRe53YT
 G3vF9DY7
 i7G9hjeqCROU32CNybAt+n8/F6styap3Zhs3bwZ4rUq1DzSNihhq0+5JaVYFwdvP89MMkv/2XiNvWK3cmCH6eCzcQ/HVa+toI021GxVMOCLIgoV0J1pwTQE3/5ItU6tlwb6aKi3yrOwO3+mnXvQ9L06YOAt9WfWxF0CfxPzNGoUT9KInfyePqiqnVC8mlqDOHS46Y6+j4beVDEDKhr7AUwgTTKhxVbp7przK6C9c8SI3oka0hjxM3YoSIe5W/yfUHi+JGEN3goHN4Qv9Mm0WepJN59CJ+Vbwri0WXWW1ebuWtUebW7gDS6a5yHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 04:57:56PM +0800, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> The deprecation warnings for memory.oom_control and
> memory.pressure_level use linux-mm-@kvack.org instead of the linux-mm
> mailing list address. Remove the extra hyphen.
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

