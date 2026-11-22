Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9682E606A32A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 17:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k7OuNNoQ
Received: by kanga.kvack.org (Postfix)
	id F1FDD6B05B8; Sun, 22 Nov 2026 12:06:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF7126B05BA; Sun, 22 Nov 2026 12:06:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E339A6B05BB; Sun, 22 Nov 2026 12:06:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B94DF6B05B8
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:06:34 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3733E40708
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:06:34 +0000 (UTC)
X-FDA: 85463383908.25.17AA0C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9FAC5A000B
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:06:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k7OuNNoQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795367192;
	b=Nh8SLFFP4UGh0DjCXKgDk1PtGaGSMElwAeLTEPWGFqQm0VJBJvK1f+gK4xqEKm4/QrmRbf
	OyWUizfLZErZfQVOb+xufqaQnFqtul4pFGP7rrq7RcV/F+mtRnbXip9CkzJ5kwxdDYzJYK
	+zVSldVxkltFzE4Pev7B4fEDRloUBs0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795367192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Iax/H9eM6bJ9OYDTw245+vI6UeqXSEZBoVBCTMrZRU=;
	b=F459Gj4ZSXrLfZ4nyuG+vo/Z8bX3vWNDY59Z8kbjmSz1KL7ZRpnWqrcrpRBmi+176GKsNL
	TKx+N/2YRAecb7NiZu3qksfN9fxHshdZs0bou4CwOJBB2uKakYsZasluOhFw8TKqX5KRR4
	80v/ixPX0WtWqMkRb33LAgy9KZJ0rtE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k7OuNNoQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F7F3436DD;
	Sun, 22 Nov 2026 17:06:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9601F000C4;
	Sun, 22 Nov 2026 17:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795367191;
	bh=0Iax/H9eM6bJ9OYDTw245+vI6UeqXSEZBoVBCTMrZRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k7OuNNoQRod7wVPVdlpf5pY0qocEOnlCldyr8WDlYVxj30CFKX61Dh+chf7KSIhiE
	 l7W8ujdWiBJ96lrdyg0ANOxAuPJG07p6WnJxmj/HqXphw0rMe0XAlE0mqMIjADcnhb
	 t3MlZ8RJdlZsVvi9d+5m3WnZ0bZdFWRCcR4u/VmeUd3bCrkPZUGOy6KidXLH6deiie
	 iEWsCP/AZxYjuKTw/0SwZPQNbNuCMPvpP30lb8t1gdI7knBmbxGIMP/6qLjAFxp/uq
	 CsLw4biMnd7WphugIj1Y/EoIsCCcPesL/nFUwxWhQaPDV0OuDg2EsVM6hBppug1J4a
	 YxxZSt8+jGKFQ==
From: SJ Park <sj@kernel.org>
To: Lian Wang <lianux.mm@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 00/27] mm/damon: let users report their data attribute findings
Date: Sun, 22 Nov 2026 09:06:22 -0800
Message-ID: <20261122170623.152931-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122143011.85844-1-lianux.mm@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9FAC5A000B
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: x8349qbh3gtjokpn41bgjixtm64q9ui7
X-HE-Tag: 1795367192-400626
X-HE-Meta: U2FsdGVkX1+sXkxFZGDP4eaLPT0VcdMy9iim3Ds4WyOQS4eYEXklbL29T0O3aqLeGLv3dLlbbFoFh3iM/+dO1j7ZoQNiW+8FUj59EGhu37aE45cCaDMh6b4ixZW/LGZTkD1B6QTC3ZNDvbQ1r7cE7reTsYIvld6/yKhuhb4aaKZlfnpHtqQrtPDAC5MsZoMY2Zovdl69FX9nmqOOY2pldCO579zrAuD0q07druqgNt9Ie+kJDTiAXTs5LbAeuEhL6edk/BxPJT440zXPH2JaprYGCMQbpZZ2gJ/yVVLlJJ5PBRAZgm3yq0RW55VreYVXyWeCK5s/GTwjOG681Q46wKaLYotabnFoElZHXSL7ZMP+x85B23O5+7vD4M/VUlRsgvrNIiFMJUbe9HuNUWcbZICk1ANhx9bhKCZhLwpvZuUIp4cqrLfjdADwK9AFQQ8fMO5HAiv55OiNIGQoHMkE+VVMjVx0ZzFeb3jhVqwyGbmJAZdw7OAnVeaXR4ejv6aZ+5tW5NofBESKbHYVEwXNyvoTXiRLFh8W/XymjjXGfAQlAqVazpWpMbzoW10XhwV8OKVGOIQTztXoqYdalUKizooulNU5zNVuK/na7hCJSmvwYPhrC1qzFxfOGZZYXPZavVzvO+rf1rw3PYO3uAV9LfLl6QgsixkAe57e4YsF1fAtFEeDXExq12MWo1lGI26HuLw2yl1k6mS6E776nCRgnwIDS8UnO2mwjQPdynxgfw6VJTIdcMR4qHI4sZYhp6gO6t/H0nr2kM+0r6M6x1PdSHs9vovNhcYyU/xSQ1Fvr03FaqkxsPHaxfuH9QNzepc2yCCPW2KzXcO0EVtK6Ead5jDZjZarfvauvPYtiCwsV+30oCYht/glUIamLonNE+9oJuM0fSja/KuP4l7NZbMT2tWmNmLjTo8PO7KPRnwtLDxv252MHa6jaM7T7ejV89IEYg0VtzHj/2Tbm6mi04M
 M2SUHSPG
 dvpwtZT/bvwXwGEt8fvxgmU43RIQDqYNe5L7CGGG1pp1ug2LJgwdjDHmC/Q2mXUQ4uwPzJSPMWAEKOonxaTlJ9F2YMUPivpPEpUuFzMF3Rz2gGsUTbzV5ViCK79LszuOiuR+sCzMf5+ECoKq2hnvFEY4pBDpLGqlHTauJ28rhBnly0DF3sB5ypN7MKukR1qwDbV4NU9Ci250PXJPduSG0IXES671eF/AHBQteuXpcbTUCVJGQp8sxTgIReziyLxY9pyxoNmKrqUPkvIcILAVYMyoUw06/I13FwWcJQLq/OLjxHI8QDk2KjW5RGm2nkJchaxxf20pJloiAqWYjT5bUpQbfTGCDqsjw94jzT9pNNBc8pnI5rvtd6nNXPqQ6KzSqdx86ISCqnc8cL61QGKKqhMV5p1+o731lRi6Ntp8ydyFyV1C9sbwrZ0qfVo+foU3h5UlXw3ztr+U6SphDVm4Gv47u3psZlrpjmaE4bjlwQ8Uqm1itpeywJu/h3E4T1EKsH+kz47z/HpLgsP2pAfacLz+XJSAfI9cpCBGWaeAhpYPLxUIaimi/pmE32A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 22 Nov 2026 22:29:52 +0800 Lian Wang <lianux.mm@gmail.com> wrote:

> On Sat, 21 Nov 2026 12:59:44 -0800 SJ Park <sj@kernel.org> wrote:
> 
> > Build a system for letting DAMON-external entities report their data
> > attribute findings to DAMON.  Let users report their data attribute
> > findings to DAMON using the report system.
> 
> Hi SJ,
> 
> I'm reviewing the series and setting up the tests. I'm also working on
> follow-up test patches for the report queue and its sysfs interface.
> 
> My schedule may be a bit tight this week, but I'll follow up here as
> soon as I find any issues.

No rush, looking forward to issues or comments!


Thanks,
SJ

[...]

