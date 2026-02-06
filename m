Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D780ECD98B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 09:56:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC9616B0088; Fri,  6 Feb 2026 04:56:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D60356B0098; Fri,  6 Feb 2026 04:56:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8D456B0099; Fri,  6 Feb 2026 04:56:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B64886B0088
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:56:28 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 674BA8C537
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:56:28 +0000 (UTC)
X-FDA: 84413576856.09.2807F50
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf21.hostedemail.com (Postfix) with ESMTP id CB8701C0012
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:56:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770371786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=4ti5eHSpJwAhjGyLH6X2zh3ncl1NzaNHEG8iE7ddd9w=;
	b=nR9cisyjErEQAKDiloTVdPyB5Wi3j9nXxX2NYNVUVJE83EAxF8PRpNYRK8yuc5cui2s4mE
	pA6pGIo1IiYLcLJX7N3DnAb8cTy4J8lgmX18MQggx3IwjsqIc3wCoVHEDmgLkxArbf1P2U
	I4r02fbWS9mZykWw0A3BqIzjFOHNU6k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770371786; a=rsa-sha256;
	cv=none;
	b=TjYg4pvjUN1JUV5TfQX8RiSpxc3yOM1vn9tr+zlRdyIjfC6TjCiiveArqpESVBQWkxJbKr
	UQZnGC+VDAt7PGD14WSXi74ugS9t5JmBs51KCQxqB0IBlws7cnH+lJwnw8yGkEbXBeTIaI
	RGTU8fozF9Wl/5G6eemuiBkIFo73aCg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4f6qHB2R0Mz8Xs71;
	Fri, 06 Feb 2026 17:56:22 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl1.zte.com.cn with SMTP id 6169u7ib098978;
	Fri, 6 Feb 2026 17:56:07 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 6 Feb 2026 17:56:09 +0800 (CST)
X-Zmail-TransId: 2afa6985bab9b53-1ae81
X-Mailer: Zmail v1.0
Message-ID: <20260206175609696_A7uH3a1F7VmQN-iTzjC3@zte.com.cn>
Date: Fri, 6 Feb 2026 17:56:09 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <david@kernel.org>, <akpm@linux-foundation.org>
Cc: <chengming.zhou@linux.dev>, <hughd@google.com>, <wang.yaxin@zte.com.cn>,
        <yang.yang29@zte.com.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHYyIDAvMl0gS1NNOiBPcHRpbWl6YXRpb25zIGZvciBybWFwX3dhbGtfa3Nt?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6169u7ib098978
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Fri, 06 Feb 2026 17:56:22 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6985BAC6.002/4f6qHB2R0Mz8Xs71
X-Rspamd-Queue-Id: CB8701C0012
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: f6tkybh1kkenmh98jcfkkmgm4quqyn83
X-HE-Tag: 1770371785-373815
X-HE-Meta: U2FsdGVkX1/bNsXplAsXFaGiQQMAP+VwaqRQLmdCskVZyD0KPZf80zCGoqgdZvL59vdyCkmnpSwCq9Ik5B8p3/n+c6OQ4HLWUyt5tSsp39fytAWoUSpPitlBjYrMpGPy8iFAeXxTVcj8l61kcPxOr/0QQUF8/kWMQiZHoNYxT3HKXuphCjYmYObpFgtdWq8Q7AcU+0El9X/Hq3lJYjbkWQMH1Qfho2aFKagS4NUL2f4+yDipA8hV5kQxTRKp/sqtZGTrECeaKybrDaH0T41Ya4HeDB9s71EKoMjMrwQ8fYyHJJ6LESwACl4kmQ8/5c4xm2a9sWkRimexb2hPbUbNUyvWT+lrdAkGpZsnENgCGfoXVjwGprqLYUqYRkCtSrEwztgzPiU/m+IOxH4RO7trXj4jtpC87FJstgLutTSxVxd554BYaHa6X9G5fNEPR0ICI7WeEfIsehrtxtHy1SJFdCQ/EobfwYGIVGqnoQ4212utwEJvc8O5jxt0nWtJCECdOu6OufSTqRxkjU4d3bSPqEW6YQaECuHrx8Eg9r+//03cvf1a/yV4JbgshMFLiJcpK9iMAQgE7DwmxiiXi14Qo8hxa9ZuoLQf0Te/7Btys7nWGWARvGduQDZzzT7lE/8MOJ1jqDXZOpG06+2xbkn1A0QxTSXkPX9X9cAFw9HkG/53UNS6lZwvKqXD5HnbzhTwmW++0NJ1IOcbsrjlQyxsnGRauGB5AoQbCitDnsvB2dME2mOVUTlyuV/pVBKtKzU4aOhuB4Hh+m+djgUk6o+rXwfVuJka9vHU+PdlebOSubtwOfvBmOE7gBzmHnkncFsXEecdGcmQFzzUfd1iYP9a5a1RXW9h4xEI4XdfRDPa+eNJ37xMdopPCKfatzop2sd9ZIvGay3lMpva/hff8xpnIldTS+wobcxcVWRS0LTuvXS9JDh5Md7G35tvpH2OJl+SgJ4AWu8iv95jsHqdT2Y
 KL2HaKEJ
 Y6RQRnuSwB5b5PWGg7B5gd8FIaLMyaL69TSxf69yW4LLiu3Fp0ouv06SElfU9aGcCxG0t6LGzSu3arNxMWYsF1Wr5kKEbxl3EW98GEUYmxyZWWdjFo8ZyHHe8RSgcQW+0qzLJ5xU1AA4ZyR/4bnFuhhDprHMyeNcThUsqmN2LG9eqg0gzdbM+a+vLClkHsw4zvqMFwPwWNGr7lLUiGu/2onIin4C2H7YLlrUyUhog99T2fKjhNMxxeLBj4mst6h5afx+V
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

There are two perfomance optimization patches for rmap_walk_ksm.

The patch [1/2] move the initializaion of addr from the position inside loop
to the position before the loop, since the variable will not change in the
loop.

The patch [2/2] optimize rmap_walk_ksm by passing a suitable page offset range
to the anon_vma_interval_tree_foreach loop to reduce ineffective checks.

The metric performance is seen at patch[2/2].

xu xin (2):
ksm: Initialize the addr only once in rmap_walk_ksm
ksm: Optimize rmap_walk_ksm by passing a suitable address range

mm/ksm.c | 12 +++++++-----
1 file changed, 7 insertions(+), 5 deletions(-)

--
2.25.1

