Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FC72606A322
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=zte.com.cn header.i=@zte.com.cn header.a=rsa-sha256 header.s=z202610 header.b=D9q8JT8D
Received: by kanga.kvack.org (Postfix)
	id 70CB36B05C8; Mon,  9 Nov 2026 07:33:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E5D06B05CA; Mon,  9 Nov 2026 07:33:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D2906B05DA; Mon,  9 Nov 2026 07:33:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E9876B05C8
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:33:32 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DC39F40678
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:33:31 +0000 (UTC)
X-FDA: 85415521422.08.C75FEA8
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id 71ED540003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:33:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=zte.com.cn header.s=z202610 header.b=D9q8JT8D;
	spf=pass (imf11.hostedemail.com: domain of shao.mingyin@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=shao.mingyin@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794227610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4M5v/hY+kOczd+ysevcmCc3bFFIgJbCT2vaUCNfx0mo=;
	b=YEjB0Win85BP/U42CXqCamaMmLkwaelWi+zOOr3MDaARNfLxZdJTl6ByWURrL4Nyx6e0Ml
	curSwgoAs5+0MHV6dyFI22EnrZq6ty4/1U0q+jSMEJHPWjrtfZI9a7oDW2voMuA2Qi0kol
	TEPb8FK8Tq4hHedm9fpuGMwFxfwYBzw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794227610;
	b=e1CwOiSjX2Y2+DGg/l5vCZdzB+AH0CzHFlx7dmZN8w2lZVUq9pavSUy7hx5alpTwdd6UxW
	dtzpP+7irNeW6oQZG5/K/GZgsjoLND9P8tCOlm2sIfMf6mL2XHyuqlbyndnaAbcVZDFm1X
	XnO6l8uWs92OC57zHmuqIiaUPgorJlA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=zte.com.cn header.s=z202610 header.b=D9q8JT8D;
	spf=pass (imf11.hostedemail.com: domain of shao.mingyin@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=shao.mingyin@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jNTj029Snz4yjSd;
	Mon, 09 Nov 2026 20:33:24 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=zte.com.cn;
	s=z202610; t=1794227604;
	bh=7kW5/iwLHrpMe+gbCylgUW1piFSCHLbOCGCPJrQrg5g=;
	h=In-Reply-To:References:Date:From:To:Cc:Subject;
	b=D9q8JT8DuAWXDjWcC89uERCcCfC+MLDCWmvj71QmjpRLv8dZb0umVfFZjHUrfh5bT
	 TJfZsrjNGsl9pd+hLzYKoHyvHcSpegVOgdtrkoTkfWwFM2CXJZ4sT7NkKModcfr//1
	 kwVQTi7mazZ3rIqojeWm5EdKAHzfcEtgSARI3RxOMpiFg/wrPVvH/qoAGkt2zqjQHz
	 U9GgykQy01Xd9wumDQUwg2vA2yTEu8HQdCIt4swMF0yTrM19BPCVj5cmCuxJZ8Czvj
	 KWi3b4vX5YlC8xcvrebKPLhL4kPWektgRsIPxZDjUa2j3VWvAHkcQLSnvlcJ8zfSQy
	 ugm17/iscIeLg==
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 6A9CXHx7000110;
	Mon, 9 Nov 2026 20:33:17 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 9 Nov 2026 20:33:20 +0800 (CST)
X-Zmail-TransId: 2afb6af1bd90e10-bac93
X-Mailer: Zmail v1.0
Message-ID: <20261109203320542JEYrsjSWEO22mMpmG7U_n@zte.com.cn>
In-Reply-To: <3b00799f-2fef-44bc-b798-79273c5c0ca7@kernel.org>
References: 20261108142831046W_fbNCAFfuY0BjHPCCHgi@zte.com.cn,3b00799f-2fef-44bc-b798-79273c5c0ca7@kernel.org
Date: Mon, 9 Nov 2026 20:33:20 +0800 (CST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
From: <shao.mingyin@zte.com.cn>
To: <david@kernel.org>, <akpm@linux-foundation.org>
Cc: <linux-mm@kvack.org>, <ziy@nvidia.com>, <matthew.brost@intel.com>,
        <joshua.hahnjy@gmail.com>, <byungchul@sk.com>, <gourry@gourry.net>,
        <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2Ml0gbW0vbWlncmF0ZTogZml4IHNvZnRsb2NrdXAgaW4gZG9fcGFnZXNfbW92ZSgpIHdpdGggaHVnZSBwYWdlIGFycmF5cw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6A9CXHx7000110
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Mon, 09 Nov 2026 20:33:24 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AF1BD94.000/4jNTj029Snz4yjSd
X-Rspamd-Server: rspam06
X-Stat-Signature: 7jponb3tz5jwadoje3pujyzaagfcwtk6
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 71ED540003
X-Rspam-User: 
X-HE-Tag: 1794227609-180812
X-HE-Meta: U2FsdGVkX1/+w5xVWY4Xpe8+JPvBkFIAVWh49vIm6xS6d6rlp66F8WHXD8FNr6izi5Fv07Imb6nc3gqYKUbr2ldP73nmRdM/J5xJC+AU9buqQ2DDeMt4t9ASnE5lx9ph0M2rGH3VFFDpFiOdDO+nhcCg2mhrNFagowD3rN9EmJOcwHJi5ar+s7HsVDJIG7gQTxslY2MS8cAU4C9qg9/PNjrAcrbnvfAB2t1mZBZtHY8r5jPFvP+ywhq/ELyEuziKzlzn10Kiipd6UTH4GDN1q8sRGcTJ5jPhRr+lDFHGl12VHBWWkTXn2VoskJbLnTd6Fvus/0s9k3hU9TA0pFM7QQlx8+VaAd5lH5zk740rHCTG9gEbCkcN9rPsMF9YyqofsXNVVVYr+WXq9C87NdKafe9GI1fvmUETnkIW+lJfKvJazi23kwJAo6wcLso2lGJqqum3SJe91r8gcZ37X/XDEqG4OX0gzVZUqbKTn8xmp6hdkVKsYF73N9DnI/ZG/7Ehq5e2sqyK3RcWEdrd4YXufCg/FCxEdzwpxyEGS8bdST/y9qPqPzzCzciNoVyE/4AcwSkkIfovRduH10ajtwLm9bbfyKP+s1pX1WLzPcgvBuZf9vVstXlRCbrHR2TpBVxzQQEPwwdcmg6U5j7/C986rprwfm2W7GcCxVeCQ1Rx40cRUDziCl6/Yahom+4xF8BjgyS9E7eGyV02GWzE7rg6TZ61rOmbdSLrtnaSWIcet8UyZlXlsVsLlhpCEOJOOqMMngIjRDIkVzKguj6pKgUb93g8MShNIHNWAAfeVbRxYc1aYQDKvj8SV4wN+x99OeF22DgDyAimU9FGbCgQqVj41APJ9rwKrRPdN4dIjSom2VLAWXFkvskcrg1aPzoUC7ZFH8KcpM1nxStD6ihs3wiX3w8MYS78ffFtoVsfJfdfQC9DDIgZEZXl7JHyxwcz94MHoqHyJJSKdWtWCZGGhfl
 fW+Upd1F
 E84aUKOgp8j6f0RwLETaft6kjgaIwA3IoLa8QrnfRnXNEdDMerI0Zjrqb7zV8Zv4E5uBmaqx7KylPfeNxcAWMEaig6zxXGbD2jCfVSQgfRhK9Y+1RaEiK7aYMjJ+LZCVf+miOERQRkVtU4mmyI1AkMJjS5/tsFBrbCn+v20nKDKs/+RU6iYI/vqAsUohf/TstYcxVBvUBQUp5I2pet2oRrsZqxzxi+g0VlTefunVPDrQAf4MbDRKSsMXPTWAH6kCzRG568vqxXiXVjkzySGl/0FJQD/mE3aXv6HvTMmzvFbCyOr4yzV9t7BzsGD5O5E5kfRjoTDi5gbB1kjfm+ZXJpb6Kde1DkpJcugLChyfCDWw4aVaO0jvcGqmPvPSVjw51poR5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

fair enough -- and your reading is correct: preempt=none is unselectable
under PREEMPT_DYNAMIC, and the arches that can still pick PREEMPT_NONE
have no NUMA, so mainline cannot reach this path.

I was aiming at the 6.6 LTS configs that shipped PREEMPT_NONE + NUMA: two
lines of cond_resched(), no behaviour change, same as do_pages_stat() got
in 8e934ab44389.  If you and Andrew would rather not carry a stable-only
fix, just say so and I will withdraw it.

Thanks,
Shao

