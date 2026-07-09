Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C2F5C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 09:31:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3574B6B008C; Thu,  9 Jul 2026 05:31:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 307E36B0092; Thu,  9 Jul 2026 05:31:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 200D06B0093; Thu,  9 Jul 2026 05:31:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F2C026B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 05:31:17 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 881E5C2D82
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:31:17 +0000 (UTC)
X-FDA: 84968719794.28.E2A58D2
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf21.hostedemail.com (Postfix) with ESMTP id 408851C0002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:31:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf21.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783589475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=x/EGu7G+/A/IxRuvDOLe7U0uq5738Gy1ysqyRWS/Aw8=;
	b=IHRydP3MvAIKx1OkeKjYe54psahXK4XvkJzt944dACP6/WEr+7wGLUcQ0tLnQqjVFn/HSi
	t0UobPxuvrIrJ99x/pAsYUo8bnHKiAEzxEQ6lN3RQMlDXtnKUVXaz8DiRj4o5ivXLk9mLI
	eY9H+fpFWhJQYybuRayvnfO9b4RFM8E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf21.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783589475;
	b=oQkW0/7BjvHdFF3WNdHj8/D2PfdcSXOlBer7EfcYWkPV0mNax8J2VqQCydPTXMWvxXYzAK
	6uMHn6qXl64tF5jT+SuPS43RZ4sY8U006dWiBCKualcv0XyB/PDs3rUnqTMR2RSGS0ChPN
	Xf5mDkcXNIpUOjg5+eQtmrutM53Wyu8=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gwqTT2Yn7z8Xrnt;
	Thu, 09 Jul 2026 17:31:09 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl2.zte.com.cn with SMTP id 6699Uw3S063800;
	Thu, 9 Jul 2026 17:30:58 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 9 Jul 2026 17:31:00 +0800 (CST)
X-Zmail-TransId: 2afa6a4f6a54203-537f5
X-Mailer: Zmail v1.0
Message-ID: <20260709173100998Kw7ZktK638ED4oZ5ApjHb@zte.com.cn>
Date: Thu, 9 Jul 2026 17:31:00 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>
Cc: <xu.xin16@zte.com.cn>, <chengming.zhou@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIHYyIDAvMl0gS1NNOiB1c2UgbGluZWFyX3BhZ2VfaW5kZXggaW4gY29sbGVjdF9wcm9jc19rc20oKQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6699Uw3S063800
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Thu, 09 Jul 2026 17:31:09 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A4F6A5D.002/4gwqTT2Yn7z8Xrnt
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 408851C0002
X-Stat-Signature: p8b58zfdz3iiyix7jpc16im5cqdyssyp
X-Rspam-User: 
X-HE-Tag: 1783589474-833436
X-HE-Meta: U2FsdGVkX1/4YjONQfIgt5UPDTTB21sQp1rUr2px423VoZbu+OxfC/PLsp2mZ7O6GI8nZqBPmzW3UgUMqcHigKj4CDooFs0GufV/wcF4dUEtEOkB74N8Gj1DWEMW6f1+kLVRvG0uzQqtOiI80c2+0ULpiYhD3MryvIr9hc6AsklnhlUX1MnDhw/gsYkU+5jyWrHQGRxF6XjholpORas3Nxb5KHlJE/WsDiHgZFE5ZDXL6EIkFfto30Tz0SFgr9bWlY9YINLcVgOft3tJaGwrmKAHqTFZ7u7qKXaj7xOZZ0nHE0iQo6MLIgqfJpJZlzp+WoYtkqXVyKPXKmdtK+pOHi9brZofkxVNRqL5xBnFUCS9MM21lQ87AtqcA0wnEQTnyoh10+kmpdW024ApzCCy4YqRy76dBOHaK5Kn+/skM0o+yX5V27n7327g7bEgCnUyhgyA88PGd7hf7PUitolwg6t8JodWA1yKu0dk9pMe9k2qAs14/ZdhuYxQjzS/ClM1mCEJ6pQdsb6mkD8jjy/QDwneygzlo+YXq0ONj9uGTNPmQQ/i8esZ4RGi6GmwVcQ5mvUMEZJ/TqqWU9RkZFjCqv19vTN5QcsRfDPRgb9nmTwZxCPDUfCtlAXNYS5ZS93+lyySdPoHIqaQ9FUpq+OTVSUZ3ocJJ8dY2PHlnj3lTiIQiziflaMBt9BaSad4wSVL1GCqrZj2ftfv5w2Ox1/Q2fINKzub1p87TvKLm4we5ks0+v5o25x0B/APIEom4ympBbkZBo1buiLFbO2YR5cQOeeIa6+1PlicPXpPfmCsLiV9gR/8ZVUoE0v8pFvmGmNrlVIMvfw+iEA2lMrg4POHFyCOXl5pFUE5yesMJgbhzhAdWH/IlicqS+YTCkqKzZ6370lnAPAJHK7LP1AipilPffWmU0eySotmiycahARVh2mf2P51jOpLGs4Q4+31ZqYGahdU9MlddCpmZZQcP8F
 6TN9NIpH
 ZZWD7YbvvQDw2In6G/rptkB9s7XBR5Pc1VW+IcMNj/twiKH7z6NAffxtz+l+PChKRkG+diCmtvA0phszefsK5xfZ9CyseOJparwcTpidIGvVi2Ml0rFF6AAd019HTHZbDyOtnHtUpgRYHNq+ZcVMuFw3aR8Y5+TQ9hXuAj20iaeaj1h/kusVr93gibDBUCZLHE5R+1my4ZSeYKXXp8iekQr99Nz2cGgZqgCXmwphVdUHssLRWMSurW/+ksq3FItGY06pL7MzSnkaA9Rxb0yUJTL6Ol5P51pmPNZ6s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

In collect_procs_ksm() which is used to collect processes when the error
hit an ksm page, there is the same issue with rmap_walk_ksm (see the
previous discussion at [1]). So we apply the similar logic changes to
the collect_procs_ksm().

The patch [1/2] move the initializaion of addr from the position inside
loop to the position before the loop, since the variable will not change
in the loop.

The patch [2/2] optimize collect_procs_ksm by passing a suitable page offset
range to the anon_vma_interval_tree_foreach loop to reduce ineffective
checks.

[1] https://lore.kernel.org/all/20260703162253688u8Str9eFLR8TGCmo7nIOF@zte.com.cn/

xu xin (2):
  mm/ksm: Initialize the addr only once in collect_procs_ksm
  ksm: Use precise linear_page_index instead of the whole address space

 mm/ksm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
2.25.1

