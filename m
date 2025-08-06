Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86D2AC87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 23:48:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2967E8E0003; Wed,  6 Aug 2025 19:48:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26EC78E0002; Wed,  6 Aug 2025 19:48:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ABA88E0003; Wed,  6 Aug 2025 19:48:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 09B0D8E0002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 19:48:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AB0A5C02B6
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 23:48:18 +0000 (UTC)
X-FDA: 83747973876.09.C5B0D24
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id CA42AA0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 23:48:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vVgwlcQB;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754524097; a=rsa-sha256;
	cv=none;
	b=sKus9+mGP7+IO0tW+H/YVEjyVdF+JostEwcSgDRmp2Fn8lnh+DpfysbX6rGvWXNs8yd04F
	MVIP98xL7Cur3189g6qcOXDr3jlUXArIKxqDRPHtqcRnT/7uAR+3lcRDI1arD2MKSLfgZr
	DWxvHQQe3Gap92H21/Dqw0En/qtwaFk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vVgwlcQB;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754524097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LrggOZQVWbsWMeGrQROI1WKi3B0AmMr1G31LZIrH2yg=;
	b=ktZmdgnu8lyiOtpu1en5+FD9EVTnZBm3yHJV5Ywc44zYt2WUmqDDqxZBC12nIqu1MecDqw
	pCF9S495lmPsJ7SECs2MNVELztyJs9X0Nn2pmqh0jhI40drHtqnTzB2pJc5C/WzjMFLQI2
	HExLA2gUR+oVXDCF+I22Ny5ASPEgvRg=
Date: Wed, 6 Aug 2025 16:48:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754524094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LrggOZQVWbsWMeGrQROI1WKi3B0AmMr1G31LZIrH2yg=;
	b=vVgwlcQBxuJauzPDtrnkF9B4Kv7hNR31S1SVfnBtlMTyLL55uWI7HT/XmOlpWjQHtzlDRj
	X7OzTpytW0xYlZzm9gyBAvpURhUZHVpBCOqZ0cG8azZLlkX5VKMXu+mvU3D7mh5MQHQqUL
	7+iJJaJtkwTrRYhrfADnodnRgViOzUI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: David Hildenbrand <david@redhat.com>
Cc: Nhat Pham <nphamcs@gmail.com>, SeongJae Park <sj@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, Takero Funaki <flintglass@gmail.com>
Subject: Re: [RFC PATCH v2] mm/zswap: store <PAGE_SIZE compression failed
 page as-is
Message-ID: <jn2fzoodgcxmyld5c7k6jifigkmbhmq2gftvxx7k4ei2kz6r72@vlrndnijfgrf>
References: <20250805002954.1496-1-sj@kernel.org>
 <761a2899-6fd9-4bfe-aeaf-23bce0baa0f1@redhat.com>
 <CAKEwX=MVBJ+Okfsob4Z30_5Y4P8c2DWoS1dYN4dF5dgp4+CexA@mail.gmail.com>
 <055a8a69-731d-43b8-887e-54d8718877cb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <055a8a69-731d-43b8-887e-54d8718877cb@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CA42AA0003
X-Stat-Signature: cfisqn4pyme3n7t4ezp53usy4xe1tbxn
X-HE-Tag: 1754524096-197690
X-HE-Meta: U2FsdGVkX1+h3IxD3RJpm5rPuhVtE9smbnSjsOBAxQ1joZMKFvSjRRhnlBLUjenKNbRXhgbH+aq575PZ9Kez3X0HWR1/KHvEUCw7+O44l1DuoMRzk931Lt4KsMTV6P+KxBpaOuyO9c7iHLdomRNyS7bpBXVPYvd+UJjSzd/yLl1tO2adGA8suPS233yyQ5rXKdlNNyazKwqhld6uR+n+5kUMWIVlYL46/+hOLF1LlqqHWlUAEr6wOBelGVOak0qeB0azCu2K0b9VVDFc2mxCEB59J8CeCxcItNu0Lnd9D8PfDo5xCl5U6MKXFF4EByRjjnRNJFgfKfUrfuvBMa81QccVn15tML1WvmwpY6PuXaMrvCrK8jS41uxGknsPliJFRmADg8R8xDuPyU5vxKQSJENx58KqVmH8RaOaMzQNQFTulENsbesBu7TBnfs4KP+m5FCtF9cqegf6d9Cd1xz0objGUNIXDyJJm+Ngt08s5qrtT9L//QV6tLuvgn1TjgnDSrdUwPnrYfn1zbOPJjrTM5BPpuu63sKOkqoG7EHRVH0MRY1PkOz1eoOsAWk0F0knyLiGrjN9CNDEuYBgRliy9b744/33Wdb7bLtR29lUm2M/6o3BguwUzIqVSmKbBxJDXyPh4Vv/id+rxx2f8u/m/GjBtUQSeG974XLEWhzxiC2y6ZbRWkKUODWMjRnAB/Iu/mx1/xJ1GK6eii1ExXOVd9GHB2GuxSS87Qgk3+5NH4UmUMF1IX5ZilCB8pspfurw6sV87S36HtOO77aDjHYQ/+xEJHZhQL32eJdaRiN8T6n2ZEg/WM5L+QfBnVgh3xDuFLuvOKMDXPnZfEE4+2cAHRfYsZYYcrNEbjIH+5aHpjrcfwQ3EmdcIAck6ZO6qBqfnYZBszEtacyLCs52HYvvVHz5C2HGOFZns4LpLe0ADLV7p8QJnna/AGFTlyZKsRnA1Ykul9KQ4iUDkyhiKdA
 DUH0ClHW
 XWmlEgjh7N2qVPLU6XpFxM/Rt9oMjmVFsQ2DWyBDFNQP3NnU2dEQw1EqJHer0qe/sBAXuhTakCdKND/kt5Gd27W4ZEe3+dKhoUdxh8jp5AIn7ygUj2fK6WVr6ShSnzvHIQEkP/5XO5aaPxlIrU9ewAa3AcWk9QyBQCFz1O36UijyvOvsWGbxEHhUokYroLBYNa4S0aspN2lcGTxDkUHlgFTiT2c8IDhpQlpHa8S/MRCO+U/TKhInHifZ4KimOzUrkmJsI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 06, 2025 at 10:14:39PM +0200, David Hildenbrand wrote:
> 
> But yeah, whether these "as is" pages are movable or not is a good question
> as well -- in particular when zsmalloc supports page migration and the "as
> is" pages would not.

By "as is" page, do you mean the page which the reclaim code is trying
to reclaim or the page within zsmalloc on which the content of original
pages are copied as is? Most probably you meant the page which the reclaim
code is trying to reclaim. This page is on its way to get freed after
[z]swapout is completed and this patch is not changing any behavior for
that path.


