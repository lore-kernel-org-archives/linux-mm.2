Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AF6BC561E6
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 20:39:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63A926B00A4; Tue,  4 Aug 2026 16:39:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 612A16B00A5; Tue,  4 Aug 2026 16:39:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B28E6B00A6; Tue,  4 Aug 2026 16:39:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 226C66B00A4
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:39:29 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8E635140287
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:39:28 +0000 (UTC)
X-FDA: 85064752416.30.C407041
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf17.hostedemail.com (Postfix) with ESMTP id D82A440011
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:39:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B2x5fsct;
	spf=pass (imf17.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785875966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zX4G9KtIkLWVCOjh6ITiwbytCOR5Bx+nS96H45NLpYk=;
	b=3Qah/VrS4Yvo5H/Q2QBbNCJQHxCt0lAHVq6e/AL32VGP8LhqJp2I9hSeZidrwJ4DWk1FYO
	bmaIDmoci3eJZadv+mxPlEhJCB3dJyn4kqCv21WRbvZrgBNTZahdy71CP7UM//+TFHL0OS
	yASN26rSh9Kf42NOVtABri1toDQdTnY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785875966;
	b=hvVdm9KW5fiVvhdu8yfrc1Oe5b4xwOJNksE4PhiOAzm8zZlUBtPwOGNFwT9Ht5zu2OAd8q
	N10WmgKtQ4GxG0i2+TPKvIxU0axyLzW/kKPvOlLI11GXK2hCs3j5tx6p2MLmqcxcNh65uX
	ZFsavQBrFc5bTqzQi7z2RuXvHDqRFTg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B2x5fsct;
	spf=pass (imf17.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785875965;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zX4G9KtIkLWVCOjh6ITiwbytCOR5Bx+nS96H45NLpYk=;
	b=B2x5fsctVX5UOg6LWiPPPuknHansYyABd//bMP1rKjwDDQK/7MI0hKVoM8E5NKgMLX3s5x
	uS+dsTbilTjSLCIiGLLAa8ePjYqWjSZwsX285EUhtKmP5V4+RWPuGTLgz56T7hKzLcI1TJ
	zwHcK8PsmcGQhJtpfSNPcjs11RFedGA=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 4/4] selftests: mm: add mTHP collapse test cases
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
 ziy@nvidia.com, liam@infradead.org, nico.pache@linux.dev, dev.jain@arm.com, 
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
 usama.arif@linux.dev, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <dd8013c1ddada90913876e3bd912c07e613fba8d.1785564857.git.baolin.wang@linux.alibaba.com>
References: <cover.1785564857.git.baolin.wang@linux.alibaba.com>
 <dd8013c1ddada90913876e3bd912c07e613fba8d.1785564857.git.baolin.wang@linux.alibaba.com>
Date: Tue, 04 Aug 2026 14:38:43 -0600
Message-Id: <178587592371.79283.4567177442714493894.b4-review@b4>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: D82A440011
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: m54oijhh3cedb63j7dqz77159fz5c5bd
X-HE-Tag: 1785875966-569332
X-HE-Meta: U2FsdGVkX18H1l3tgvxHzo3OlA1s/TNuw6ybaf7YgFXMpMs57TUiICQF8tpbTsbYG2bDQ7RpmochCmQsQCQzBK+ofLYPe93D7rII8gYuF1TP12JjI8pQmkj79MvfW9QcsbeQVFDrCj7tVJHOHZOvd3Q0N1dEqYfBmZiX9rcnBaUiZYeY849xBmYxMgdof2e41Yz/omAXVGu1OygWJh71g4xEHdUKXRkBxM2Lz4EFb0SD/JPbNEHQxEqQNIVgGptYwmN2xoZMd3wZVDXrVGpD6pb2K65bzeDM8ZkoqS8GGyRvSJ3eZdhEMrqpecLmK5YXHETAuoeKfrdhiyM7/yk+AqwbNxmO+ydISayReumsx0P7M4gTOOmcPgHu9Frk+CE+p4GZ8GdjfwVcEa+6NA60Y3jO/uGe69Wmocfkojcddj65NkXAnBHauF4Xihr31iWTI7tNQ8ex/8eMyvMt6f5F9Xw+N9bAiKNK7YXb33kVxsfEo+hL0VugsnnIethjQ/tk2HzdEyRIEF4eF2pq+mqoV+ovqSOOSlf0TzAMYq26VkCIcQeblOIUjwuQH31eEqA5+ZYBuqJzU7Pa83+l5THiAWgH60pL2MRiem94avCIDfmrjKmF82SLQyk+3ujDt4fs062Pupu9jisoLVQsb8jKi5aQvLlk7Tf64kBwxZxPHCOAO84terZfWPUGiyUMGQBpbLE75zAHAyvIE12m8C71XT3hpcloCl9OmQ7nGFQs/k/06XY2fp19bKqSxxJZpqckPF6NCXeGExBUECDHm7SDUbf1UZJNXb4v6C4vQnrPXPM9nUaa7Oikh9SLH1p8Dx/WFlNtglEswuzWADA5G2FnUyeZBcFZA8ULzcbe3j5sAucqKX5KTVpTHkBk0FR8+srw851zAr9AKUdY7qOGM3NvR3XmXfToZd+efxkP30/neOlwZINEAEnTqJl8AajmKAJXEaS1ncs76ay02lKzrkl
 8AD5m2Nh
 ItNWxJ7jCCi2F4uFxzzZgJU7AP0mPSFuM56sLjA3xCMUz4svuNUzivDOgtzLb0RlxJOC/IsGlg3s/CO4PfPukGFH7rjnMTmusVsOpX/XsWF1JpHcsxDXPhMhcwR0bbJsWIVkkiKFo+Wxb+pW86vVBhlaGOSszt036W2kL18NFmjqO5otDdK0FPWebKOiU9r+Ym8vsPaaUf3waOuowUDPWiIVAGNrPu/JKm4GmUhhdawMnceQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Added a new command 'mthp_khugepaged' for mTHP collapse, along with the '-c'
> parameter to specify the collapse order. Additionally, added mTHP collapse
> test cases for 'collapse_full', 'collapse_empty', and 'collapse_single_mthp'
> for anonymous folios. All khugepaged test cases passed.
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

LGTM! I will try to come up with more test cases, and send a followup in
the future.

Thank you for working on this :) 

Reviewed-by: Nico Pache (Red Hat) <nico.pache@linux.dev>

-- 
Nico Pache (Red Hat) <nico.pache@linux.dev>

