Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71511CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 06:55:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC9BE6B009F; Mon, 18 May 2026 02:55:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA0DA6B00A0; Mon, 18 May 2026 02:55:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADDBF6B00A1; Mon, 18 May 2026 02:55:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9C78A6B009F
	for <linux-mm@kvack.org>; Mon, 18 May 2026 02:55:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 48A271C1D4D
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:55:24 +0000 (UTC)
X-FDA: 84779629368.08.996B7EE
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf09.hostedemail.com (Postfix) with ESMTP id B6E8514000A
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:55:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JM9d4r3u;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779087322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T6Q6narBBfa2DFEcAhiLjPk+kC15poLsjndhE7THPe4=;
	b=SAZTmalwlZpXaWk6V9RGiW7Fa7NR/Tvv+1gf4RFuEsVbszNrR2yMsK5d5vz9WwXh621EXw
	cPRyEPkvQkNiMjF38ZhgHwRN40igJB2NI/6hzxqe1Fo8c+Bah3V4+RC++qhwsgNmwyFf6J
	0x6fvTDvm4AVxdYMcYEDuPtc7Mz4dxw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779087322; a=rsa-sha256;
	cv=none;
	b=ZrG1a7wvWxUEQqCBu25H269Vv1jh5VsiwqFae8jG4LIMd03uKlZ8rImSrBgdwDrUmjQeVm
	5y2/sWu6Xv3dCzxZ0MOW+cw+cAzI2JgSJs/GYUZgMw+pBVQ+AyBjmxJu/vhDQP97dCXrG7
	WxTamvT5VLbDRRuSWBX4dmL8NPhga30=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JM9d4r3u;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779087317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T6Q6narBBfa2DFEcAhiLjPk+kC15poLsjndhE7THPe4=;
	b=JM9d4r3um6vkgkiy6daR65WR78qA1MrD9d2QcfRAVl6Vzhs/8XY97LYGKJl4fqdLxvpeuH
	YEir1Mr9Ev7fsq18T4jdnS1xPmdwaStWTxOSPu+T7af5NwJa/Cjb9FifpXmLXh/R1qLVtG
	219UPF+OKh7SlV2vRBywuN9O80W4b1Y=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: davem@davemloft.net,
	andreas@gaisler.com,
	rppt@kernel.org,
	akpm@linux-foundation.org,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-s390@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH 1/8] sparc/mm: remove register_page_bootmem_info()
Date: Mon, 18 May 2026 14:55:06 +0800
Message-Id: <20260518065506.79263-1-lance.yang@linux.dev>
In-Reply-To: <20260511-bootmem_info_prep-v1-1-3fb0be6fc688@kernel.org>
References: <20260511-bootmem_info_prep-v1-1-3fb0be6fc688@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B6E8514000A
X-Stat-Signature: 371ikm4i6c9ywo6afp5oixwz3u9cauwn
X-Rspam-User: 
X-HE-Tag: 1779087320-669059
X-HE-Meta: U2FsdGVkX1+kSqXNj/sFSs23I9Qr0Np6OA57/OvScOU9wlU55hOVwIIl6e+7NYNAZ/Ckv1QhYFRathzDywqI1GQydqsUsGkM79k0YXsl+du3ddLypyu4maaJTuC3asjljP0090ZP09ZkSiqrjj317kJj5niKO541fklo+eSBqXFXKZFaBGDJydBZOLIHwiKnXroic1YTIEISGOw/w3icxIl2bKFfKNOs8xih8cM0FI9TDiQSMQfDYhcS6718JdtlOgGvkEPQm6igjWKtBwNkuYKidHn45iPQWr4YtGbUKUYAUJsPWf/t/4YpiraSNkB9iLAef6pXw9Q7l9jz5EifmxHcFSRCvp3rRc8vEj04o2Wv+lLKUfdn7spuk8XQ01WJvf0KEa7/9hhQQmp2xfycLzmtZDalEX3hSLiRZv8PF0YPYlXyrX5c5fgaBlT1ATwKhB6zjJrIrLRFmu8wxixpox10/rIX5qmJ70V09zycFyoubLFMuO2BYQZNG6LDgbqrA2fF7qn/+CTLwAODHf4vciauoMYD3YjQcuBVKoKUd6U6Cbhb0h0Cxq1HEG7bSZbkBndFIwAMplBO+XbwR0W5GS70hlPO1t/n+sj2Y4Y9f6wmNpaXgshNtIL4NKR2mwxqPwx4Xiod4U7N1M+LDnzw+bn9tWayze0stex5wzRqHFcDqLzBVeaDFzPDuk+iktsgY0YZX+uZ1SmfhkSoHFQ4XG4lZICZHCB6eu/qgMyF8LJlRkrJdFq2JLXIFYDxWpnHElWVAtGjtFf1xeXyDlzQHqt5VyTj3DpMRSNwcXD5TUdDqHuoqtVEW7yqhsbATud8+YxB26NP+OKZQzNdARZM161xKq7P1HQOZeAK96k+fcwFxMvGh/tCtsfZiaSbwCDhmAJ3BSIbfZbVWEOsPJf35YTc4ctM+OpAmRZfYhW/MBN14h/slVoR7yFEbM2WBvyi6vlOH82UwskDxztHrIp
 AjC/Abzs
 wYP5MFaya8EWaunO4jA7bycH1fGwIA6b+R1/ZYepl1zBDoVf3NUGm78dSvy4YoHe+stPpIjPZbrMDVHtbunHnENqvJ7FZY6xkZ7GPab+HlAevaachuyO5t80v1zJ3M6D6wCVPNfh+SEGC0ewc7JqzjTgvq9ck22Mz2tqaoLEEGsdn4oGOZ5awTzsVjaBDzZpQvZnBtJBY3z+msHSl7Cj+ZL5EBUclltMPdJrtOns/I0iEP//dlGnlSJj+cunN9dw9+w6oCp5tunusWcUrbtJzsxLvVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, May 11, 2026 at 04:05:29PM +0200, David Hildenbrand (Arm) wrote:
>sparc does not select CONFIG_HAVE_BOOTMEM_INFO_NODE, therefore,
>register_page_bootmem_info_node() is a nop.
>
>Let's just get rid of register_page_bootmem_info().
>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Nice cleanup!

With CONFIG_NUMA=n, the removed helper did nothing.
With CONFIG_NUMA=y, it only looped over nodes and called the empty inline
stub.

So, feel free to add:
Reviewed-by: Lance Yang <lance.yang@linux.dev>

