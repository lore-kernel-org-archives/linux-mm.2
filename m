Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCE74CD4F2C
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 08:46:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E03AE6B0005; Fri, 12 Jun 2026 04:46:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDB936B0088; Fri, 12 Jun 2026 04:46:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D18E66B008C; Fri, 12 Jun 2026 04:46:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C32186B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:46:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4FECC91CF6
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 08:46:02 +0000 (UTC)
X-FDA: 84870628164.22.9841CF8
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5B076C0004
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 08:46:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wmN6frxH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781253960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ltQFTJtKxmAP/Mx3bHfZyI0mrUvG17L9OOTT9livw44=;
	b=Con0kDU3zhH2G4Q8mTYxWlH9/jNit1bZxJpdyDFsyuGyyx+UIeCA+v+WsjTapJVq24EyMD
	HeYenJ5npx4Hky0zrNF8yGShDlsTA7P9CYcgX6PsChh9L3gElOPxSs7r3MOqiLEZa/FeBn
	4X0lcPMPwP5271vR6SYmhiVQ5ytm7Pk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wmN6frxH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781253960;
	b=uVunXHBNgBE2G0VR+/IdOsb7Fl+hfL/nIlPiOoN9BVHp4j7516408nSBBEgXnMsFE7xRRR
	mZuyqf+l9whtPSGBUKo0eIrH1MULEa2J6CXbl/2uY/8c3JuRurTbggipZKpDssa6TkWQts
	GxfxkYW17jPk7wJpeocL2UPcI95ToO8=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781253956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ltQFTJtKxmAP/Mx3bHfZyI0mrUvG17L9OOTT9livw44=;
	b=wmN6frxHPiUp0qIZpmRX/d3jf72vrCM40dbRKikDsNZwwl7mcZ+AZvQ9ekUD2yGazN98Ak
	ktJpV22Wvib7Z3qpINpx4Y89ErxjWlEtrzgd+Bk5oDlidNsTc1SqZcczN5aodsknsGzulI
	xXCtcpvHwYLljPkKnvggjD8xb6VbnhU=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] mm: use mapping_mapped to simplify the code
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260612073032.33228-1-huangsj@hygon.cn>
Date: Fri, 12 Jun 2026 16:44:58 +0800
Cc: osalvador@suse.de,
 david@kernel.org,
 akpm@linux-foundation.org,
 zhongyuan@hygon.cn,
 fangbaoshun@hygon.cn,
 yingzhiwei@hygon.cn,
 ljs@kernel.org,
 liam@infradead.org,
 vbabka@kernel.org,
 rppt@kernel.org,
 surenb@google.com,
 mhocko@suse.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Pedro Falcato <pfalcato@suse.de>
Content-Transfer-Encoding: 7bit
Message-Id: <3B9467F4-669E-4C43-85EF-B57C3CED8B66@linux.dev>
References: <20260612073032.33228-1-huangsj@hygon.cn>
To: Huang Shijie <huangsj@hygon.cn>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5B076C0004
X-Stat-Signature: wzthfsq4re9ew811ub9c7q1aqyajewb6
X-Rspam-User: 
X-HE-Tag: 1781253960-103639
X-HE-Meta: U2FsdGVkX1+UGD17E3TYs6VAw0H9InkxEzkE1R7lRKoeBG3D6w8pujwTZGKpAAmw8fYDltsoedL30IrWgN96jZ4gYhZp+7kiagzpYfRB2zKOEsvi/LOnRvQzKwR2YgRcwGQuhllLBHp/7BMLne4lgwAA60bP/nJ7gBvsmLqrc4HN3k/aBFv4uWsV0mVLi3YYByx7JuEfc1rxh00rsdwyq8gpBdM1DckE10Dg0/SZdzH1cz/g8s2uqp1SpI0vHM8eOa+4gDM4XUgVCSR1e7A77J5nTRIxQyXJSQVrkGruKM1o/RONtbQYDYadcH3JYDmASDMyHraZtIySdOfz/hdzAklG6hQnMIYwsbSRXxyV3jpxo8SwBnfO0Uxb4yUoOZdAFT+vSJGfQqlYSVGR+OoJ/k+kB5aZ1WCm8Lnp9epYu/ILKH8XMurE7MtT4/Koewl82XiMl8fcyPhtkP3DTTKoCJadkoP7xKKSynC48pTphcprPrPRe7cWWpaqpVzGpCyReU8Q5niyhEocsu2I28KYAz0e3irxSQf34QkEz4OQG62stC+KEaWFzfNelbqm8NaAdYJQSxnaTvtSHcteOPc+kh/1w7lI6hEokDRjabe0C6oa+oH87i7RaPH7Krp30GNrlyd4MwV17IzL33YhPyq7Wh4jwS3XXX3lgKR3YN1Jvb5RttisYjeLE/svDyPRVblsqJcjKxpBePCpMDNkWTWke2YZNAdMQE6hj3ocMU3GhpwxRinvEVt2rnfBruagMof0K/n/UpZolx/2GCwXB5U8mwlw4UKXO7IVCYEVEv7UtNajYqXbI4woCfoAOQuYwsdBTJ923q9R8XrvLcgjD+1yUkVDQg8jH86NecOJMa7gZBm/ptSf/o+z1owc5qBTVsA0mHS9FpknoK6vJmn6UTe9DN8MMtmwAPopsZKMTMoJijCygc34Ut5/FNq4I+JbL+yRCiiAV2YA/t/Xatr0/W8
 UVh9R3NU
 vgMQ3/yErcdiybwRPzdDxepu4Nw9RWIYOJQERGuFXEjdx3pLtNisUdjP6BSlGGtKAoPLP50ntuloeuJbF14bGGA4MQOxsr3F/qHxJ5rBE148hWN+7g86KcNeJKCX03odznauSGy1vqPAbaUN0Hyj3Wd+emIA7SnMkfQMZgl1bngeMEM8HduiJcSl3IKZNqzE/bjjGuJT4i0T3Ym2xPbTUt8zUSU6L6zXOTk/cJZ1uSWLDBKlYkAK4rx4GZfFsyDwAZsXraZu+4OmebCEdo4ceTLDJ/IeWGjzs38JQRNbrStcg8cHLGNg20Xli+VgE6xdnzG8JSTe5XhygfV0SxeWRba/6HJVVbyAewVJmuG2L9eo5qcoVOtTrBrFc0u2sAY2Oy2QwnpxLAUwGTDIMHcAzpnkV8Q1b9Xv9K9Ru
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jun 12, 2026, at 15:30, Huang Shijie <huangsj@hygon.cn> wrote:
> 
> Use mapping_mapped() to simplify the code, make
> the code tidy and clean.
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> Signed-off-by: Huang Shijie <huangsj@hygon.cn>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


