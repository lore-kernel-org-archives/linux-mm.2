Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80FE6CA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 21:00:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB2CD8E0009; Mon,  1 Sep 2025 17:00:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8A5C8E0008; Mon,  1 Sep 2025 17:00:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC6C18E0009; Mon,  1 Sep 2025 17:00:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B83698E0008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 17:00:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5630C1A0A03
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 21:00:47 +0000 (UTC)
X-FDA: 83841900534.01.47A5A69
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id AA7E180011
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 21:00:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hfLf2hOE;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756760445; a=rsa-sha256;
	cv=none;
	b=cvmE8dOABzThBsDbNkbl6DSguLr54pbZ3pRc2v3PyvqVERtPBldKPiN/64HHTwvBpKuWZ/
	GF6kX12BoC3pMWgZqnlE+JgNQAzdOdal66FJ0ahl4ni4sV5zEgcO0ZiK6xSdhFYB7748Md
	xJfQVHVopMKd9sS9VV4Q9t+k3HB+1mQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hfLf2hOE;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756760445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OQ8am+EMIDoHEW89D1JZq6uW4xaBBQPett8Pa0sCPUI=;
	b=pa2o7/puP6Q6ekrFES9Y3t8BQPuPfI2wg7lT64CkpPluy3R/GBHcp3OlvL7aQ5AyGitK4S
	OrFC8izCS1NDwMG4nLjW9IK98E4T6swMoxIYfNsOtpTyl/rV3vpGONcC2h4st6iTQh1RKr
	2wqm/1XnOceRoQaNCeM+dMjBl3nQZrI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CA3D8600BB;
	Mon,  1 Sep 2025 21:00:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A17C4CEF0;
	Mon,  1 Sep 2025 21:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756760444;
	bh=17SJeLM5fHdTDc3zgAfNajvnMi6wWr6jMtsEc6PBlXk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hfLf2hOEF0oj+jHfP3yfD01ar9MdRtJdsr/q8XxmC3MbUE7+D/XOlBVPBXKGHguKM
	 YIX9iAp2M0a2DQHNHIN8w6vLU6gJprz8pEwHh3Thl4nqsuVP6DaFd50OC575yrAtzu
	 VqZTY/oypQqsUizoupg9miKFK2wruEWwiO/z96Rc=
Date: Mon, 1 Sep 2025 14:00:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Ruan Shiyang <ruansy.fnst@fujitsu.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, lkp@intel.com, ying.huang@linux.alibaba.com,
 y-goto@fujitsu.com, mingo@redhat.com, peterz@infradead.org,
 juri.lelli@redhat.com, vincent.guittot@linaro.org,
 dietmar.eggemann@arm.com, rostedt@goodmis.org, mgorman@suse.de,
 vschneid@redhat.com, Li Zhijian <lizhijian@fujitsu.com>, Ben Segall
 <bsegall@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3] mm: memory-tiering: fix PGPROMOTE_CANDIDATE counting
Message-Id: <20250901140043.b522b4f16cb4fe52566fe516@linux-foundation.org>
In-Reply-To: <63a6962f-6ffb-47cd-806d-ec568f0b2df7@suse.cz>
References: <20250729035101.1601407-1-ruansy.fnst@fujitsu.com>
	<20250901090122.124262-1-ruansy.fnst@fujitsu.com>
	<20250901125917.e9792e5d0df12ba1c552c537@linux-foundation.org>
	<63a6962f-6ffb-47cd-806d-ec568f0b2df7@suse.cz>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: AA7E180011
X-Stat-Signature: 7nwpgecf7y6cs78eymuyh8p6ed54p1nh
X-HE-Tag: 1756760445-654249
X-HE-Meta: U2FsdGVkX1+/JtuMTN3lPcssmdphKGU3LgsWOi7qDXMQIXt6ywqHkbz/iodcy2Di4jtt2Rpa2bzXm1lr6JzYXzUIlDIPrD2frNt24bfPbf69muWownvSnypOTLfof6sIqEVeqhZty7IycZ+BXzHcRjGiUvGxpSWvgmTLrpxtLIPVwfEcWX1rb453yQFgrUri5rDN/6Md0pQA5YbosFj4A/nIuz9qdzDErgc5ByvYT8QSmihuocr7toSFGbpotGBl9XJ+V0TZLLEq6yAhpQvZrMmzlZvU2nUrBPkiqZf6YXN9PYAM8OuYmeO8L9x7SBr59zXUHklwogp+J7CeMK5K83KPodizTbMBDVuX8KFskIT/pgfoPbEkTl8+sfT+IN3BkLjffWY32jEULUubndGFkfjKSxLk69rPBrPLceG2f6/xsnhX3ypIC2Ny1BwIUFGvvLO1RmdOE/ntau2siDExjun8QPeCpSh/EDBvBmF6N4SmG3vEtRYOILFMoPwJu+LoKPG2R/+fJQNolTijofyrLGqJH+lcJLMLXRztdSy0bphX+xjbuKMOdA9ZTrvQhj7aPwBmti5sGTGSIkyWmu82/o6Be2bgBSq3ey0tufsHpMMeufW7jLVif1+FlKBhU8h1Du4TmKE8MApWrb6lf7/h1gd580PnIjXh9XQpz5zofQF9IGIBYRTKBj10WrVTpn4VeLnNtzJL56ClgMu/FWSiGMwptZxyUiDpah002f9ZKUlx0xX89PxldbG2VCBNRCc23KLuRfxiOJtfSyHflU6R6T9j6HIlkKqkTAsCl3PltkpE9A8g/s/K0gUswzE9yI3/FkEsejwgk8qFTxvbzTV1R1iZXsYZdipqGTz6AcV8a05EhJh0k5XyQqCkesM6+lCrdpgP+k6Q3YnD+ATE1CfKor3Te/qmzhZXzhpBBfRDNgD67RHB56AiJ5iLeJuBavQt6Fn0ot6D9ptGXG8bUmQ
 YU3qgHwn
 vCCE6Q1F2qL2U48n84m2yHbm3NZr8dwMuZRXTLlOd20g5aipsTnKwfKXlugMoCYZIyATaFWAo2RB8KCHKlSvmHhP43Qpylmu2jOlyuMxJTu79/7MH8ap0hJPHISTfdu79nlq8eQMhwPtNpxlxemA7T025jaK0ODK9xzAofRwvdch3EXoRq0MUA7ADCyX/AJeWODpNGb3vhnkVvGytMtqiPgA36htW1AtLHLHZ47ggKnJKlwFhGnnKOXgWD4pXnvmXGT6vjscNiLkZqzgvekMyElbrOQnQySUZreyHNgr/8kk9rOQObBlXcvABvJhVXoEvGxocviF2BLKKheM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 1 Sep 2025 22:34:32 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:

> > Could be either c6833e10008f or c959924b0dc5 afaict.  I'll go with
> > c6833e10008f, OK?
> 
> LGTM as a helpful pointer, but I don't think Cc: stable is necessary for
> "admin might be confused" kind of thing if that's there since 6.1 and only
> came up now.

OK, thanks.

