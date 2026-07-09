Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0495FC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 03:11:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6AF56B0088; Wed,  8 Jul 2026 23:11:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1BDA6B008A; Wed,  8 Jul 2026 23:11:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C58936B008C; Wed,  8 Jul 2026 23:11:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A5B0E6B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:11:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 37D5F1C80CF
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:11:10 +0000 (UTC)
X-FDA: 84967761900.29.78265D6
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 11473A0002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:11:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf25.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783566667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sHPhS/qIh0dzI4I/69SQP1bQ0YbV9IEPqCaJ4dT29X8=;
	b=bpAnfY5ZHyOTWTvhLDt7EPmGW2TJHbhhUSCZPiLlpu7qIgczTqNnZzrXe5vDfhNiDoVnrr
	dsUF0KzIau1UGPgXX19+IwpOrJTAdUYHlupjITBzHCaexagwspunnONpmI/fC/5ozSLYxx
	ltsY41epjBLSxbFydSZE8jV451w4K9k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf25.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783566667;
	b=7vtdFukvwu8E7oVhFUIyejKDtaLy1beDTWeS4zaRF6T+tllDmJHT8h6RZOml1x4IPdtTHY
	+yVZrArbf+Pka7DV+874d3PwznrkbAXIqCZj0TtSDFroA32OedDWrDajVb1deROtKeCQqz
	985n4l9vWhreKCBaaA2ONaMY+Buah9g=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gwg2v4P6Bz5B0rg;
	Thu, 09 Jul 2026 11:11:03 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 6693AsjM011176;
	Thu, 9 Jul 2026 11:10:54 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 9 Jul 2026 11:10:55 +0800 (CST)
X-Zmail-TransId: 2af96a4f113f700-f4f4e
X-Mailer: Zmail v1.0
Message-ID: <20260709111055267XMDer8X5AKmOhy46TRjwa@zte.com.cn>
In-Reply-To: <bd190dd0-fbe5-4772-aa7a-a4ffd2c925b6@kernel.org>
References: 20260708122218298hWVcT2XtcT3UnK0QdTwuA@zte.com.cn,bd190dd0-fbe5-4772-aa7a-a4ffd2c925b6@kernel.org
Date: Thu, 9 Jul 2026 11:10:55 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <david@kernel.org>, <akpm@linux-foundation.org>
Cc: <akpm@linux-foundation.org>, <chengming.zhou@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCBSRVNFTkQgMi8yXSBtbS9rc206IFVzZSBwcmVjaXNlIGxpbmVhcl9wYWdlX2luZGV4IGluc3RlYWQgb2YgdGhlIHdob2xlIGFkZHJlc3Mgc3BhY2U=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6693AsjM011176
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Thu, 09 Jul 2026 11:11:03 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A4F1147.002/4gwg2v4P6Bz5B0rg
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 11473A0002
X-Stat-Signature: k18y7a1mk9y5w5hqymn9169us7b3wkeq
X-HE-Tag: 1783566666-385521
X-HE-Meta: U2FsdGVkX188YRI0x58S8qNr4eMyY4rdB2o8UjNxT2az58zxc/eGGVdRsSt/JRK60xql0ys0tIdpzmq6jyj1MKAV0cPVb4PZlmlkarki8zouemSa5o6+pSt5AbeUYV1+jVZ+IuznJIXTgrXzQwoiIO4VCHl5+Z3fH/UCXuVqxLPbbfT5DLZ5YutuZfwQLA9ScAuBkYswsyqJbRbKGQ4QLmHhMp+HuW5a6qaVXhcUcgGG+uErSrWyPnwdubr/7VCfF8p223du6Mv5VSqSgrkJfT13h2dO1Xn89GFkT27FQ2PT3YDxcJw3TbqQkh/WIyKqGxYwdFy+cjJIw57qzEIHgtCcaZM67t69bVpd0zKDeK2WeKrB86V/Ivn1eDhmVoE1SONnir2BzOkwuPge7NmVLpeQO+dqd5XG8g8qetIN+IYe0lIaCzQOxZEVw3pXUiGr8Rzqe+Vgh1GzvxKpdw5LlLYKueR62NemF2N3vC1L0p1ipULG6KwDHsQkwqCs9cG1jrnOljJRsTQ17KheFW4fnNwivxmG9dsr+h4++FfwJNV/IweezjWr/le9BtpIe+hQvwXtQuPEK9Ckv3So+yZwEoJc2nCA/DFwp/I7fM5B+GjhedJcWrfN3+qe0Bh6filYRhy/i0rp8OaW3FOMnFT71nMFKyqe4fcD/TMj4mMf6wpn2R6b4n6ujBkE6fWOLv1Q8h6fRLuU5+Sn7el0F8kVipcPRIKJ8qLdDEBoWi7GHCAgFqNgNYEe+FDj/7EalXw6t+dT8oF3y9Gxz8o017q84OxklDXgTD/yy2bK6uYs2GnmOSScBg+8jSRxwlhvZh+PEkWJCa3rntDGmI0rw3SMDInGjYbV3ypGJxF/Xn8RnLS1iNA+9Oo/9wSiVvzP5Oku+RDsItnkoSipYPRvvRtOCpbEQz8JU8ymuZw3ng1ucAdZWhzj04J6hqRf5LUs1uFuFKNvBZprKgnlMpkJf5I
 LSMWOHqD
 xeUwZcbZ+T5H7OkIkNr0mo6X+X9YO6ePxR1chhG8qCEeu4HsnDNiPtO3oIE6BsT4vJ1fMOy1pGrnUXsaaMWTKmhUeorr7qNKGkdc8l2ct92huU22kgjBhQMbgTl3u+er9LAqwMh5Ca2ViHqnlrVxMkU2MHfFaLWlPO8dVrIfHzxQnfZuxFCOjtD/loNNe0R5+En1rKSdP4bjtEVFeMhlD1s6e9ez4LcKnqnmLbkHqrNX5wAyhTPi+pKm6w5U/abkb3cbG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > From: xu xin <xu.xin16@zte.com.cn>
> > 
> > Since an earlier commit introduced the linear_page_index to struct
> > ksm_rmap_item[1], allowing for optimizing the RMAP walk, we can use it
> > to locate more precisely all processes that hit the KSM page, which will
> > decrease a lot of unvalid iterations.
> 
> It's awkward to reference a commit by a mailing list link. The other patch is
> not upstream yet. Best to wait for that to go in first, so you can properly
> reference the commit.

Ok, I'm going to resend this after that referenced patch is upstream.

