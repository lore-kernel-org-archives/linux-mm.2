Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C259CC6B2D
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 02:12:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 406906B0095; Wed, 14 Oct 2026 22:12:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DD876B0096; Wed, 14 Oct 2026 22:12:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 319BC6B0098; Wed, 14 Oct 2026 22:12:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 10ECC6B0095
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 22:12:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 26AB9407BA
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 02:12:16 +0000 (UTC)
X-FDA: 85323235872.09.8237CE4
Received: from mta1.migadu.com (out-160.mta1.migadu.com [95.215.58.160])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2AA6420006
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 02:12:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=anJHCpp9;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.160 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792030334;
	b=8ksviMXL9SpN/oQpE6XqNsU2VGlm4/maOvZJM8+f1ri+ip5apiTVDnQAqn5zeruOX/YeH1
	h8NS0STFqHnumjTDtlli7WbODMOB46BpO11Xcqblh5l3HqPwugoUakqA9qhgBKQOsQCalo
	bltr1fA28zB5FiG0cPlxnqlNofdo3Jk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=anJHCpp9;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.160 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792030334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/EzU1Gh0KoAjxxeW1xrXzRl0nXjI0bud2B70cL8Kev4=;
	b=0ZxrJX45gw++6lAhf5smnWS/2lad4yGrcnjljLH/O7Tya4AtQ0ZkEK7yFoZoaz/mAtQcil
	vyrbBJGxIRgkb3uSe+uLy+gCOa3PVC52fve5OAhLO0OXkF5fO1wliZuGcTRbm7n+93PTfK
	mjiEXaghkFX3srYkQybnanh2fMHtaHE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=WoflgdutCHX+75m/8u4RqTEViaYItTF1x/KEbFMWUDk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792030332; v=1; x=1792635132;
 b=anJHCpp9AormFyhTpIgBPCBgDUBQTPwHY00sub3Mn0GzAHgGLalCsbOWJEtxqpJ3309YkoOg
 RIvt8wgCmEdmSHC3BEAKSiy7eI80/jDHFSI/RnwjRPxLCEL7aYxjYzgkV7Nkbq15GfP4SyERvgN
 cKfKqqTtSHTCGIjCDQlliRh4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 7aab8d1b515bf6fe;
	Thu, 15 Oct 2026 02:12:12 +0000
X-Mizu-Trace-ID: 7aab8d1b515bf6fe
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 1/2] mm: memcontrol: remove mod_memcg_page_state()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261014-memcg-unused-page-helpers-v1-1-240b37c53831@columbia.edu>
Date: Thu, 15 Oct 2026 10:11:21 +0800
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <B55F574A-498B-4E97-8CE0-CA975A23A5EC@linux.dev>
References: <20261014-memcg-unused-page-helpers-v1-0-240b37c53831@columbia.edu>
 <20261014-memcg-unused-page-helpers-v1-1-240b37c53831@columbia.edu>
To: Tal Zussman <tz2294@columbia.edu>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2AA6420006
X-Rspam-User: 
X-Stat-Signature: 6nohw9uq4jej971hnf95p1psfprxeijp
X-HE-Tag: 1792030333-570005
X-HE-Meta: U2FsdGVkX18sLfX/6iix/+12h90rlSfXdDvTYUvHgvOrd1cISMuc85InA7vHRwH4xygYCTVUwouY69hTGLJSuwv6+VNqGgOrvwPyNiyQLM/vPjJfzgQMRh17SKz+tvcqebz+2NnJJ4Ftmtypo6N5w6iykD5GUDPzKJ9XeujFtExlCdnybhGhClxl1IP/9QwLBrwThc7N91peIVpHCFIWVBnnxflBJQvz3Kp1rn6fdo9eJHBzrIkPse1/zSf4g5OrlHygJWDAUJxUzGbveyABcyqhHX6XsfO8Tfj7Jz9RGxl+yfV/pGo/KjahKaP2vET2vpJ8JgMYcU8nqTU/HMkmEnB5orv13VUL72hWGKHx3QKLW/l+nF/im1c186OpNWnA5HPenE38lXaXZlukzUDViBGwhHiOwr/ABv/+SbPmmX7CyAea19JYKtOXM3N/S/NqphSCvoDUupyEqtAc7WcXeCH2aGTKX8uvF8GB+mYpF7gAGjLIPUPpa6qAiAg6mMYkF6t7qQ+vtrerNt6VT+s4wDQMR2dxXOk1jPIeZ2l9dUMOzCMIyTLcAJTCDxgzdd01nlQkcKYSgiLLIpD/g/ONyAUvX/9SyfUHLweukW99Z7v2FzavexNMBCmu8/C57CdwB7YCJE4ZL5jgEuPvaQUAsrNqaAWGwW3v3rs3JCItaUy19aKi0Uzf7AFsYQRXRMKUeZvI7LfWhe5R8ETq5FwExDZgnXpERze2/XvJyEjS/cAK3kbUFawT320mh488dLPnxI9AR3236hoxfU+X5mWQH1oSelWfRJXSTqnPzRvRXVUHTbmFDp+mYKHbmM/hsuYGSxbhqT0gcfc+V1oS4JiVYqloV/nUN+Qxp4sCUSjZkYdVS0QgVowLTqyyCrbgH1A63+dZWYjQSEb844mU7IwmiSAEd/DLle8D2641Lpj/AVo7gtVUakfgByMIttHXg5a1VeZdDQcTou8NKg5lVJR
 HYtEfQj5
 R81G+B0WTiNPTwIojC9r25ED0buZzWPOYW1gYJewp4FKrDV02ArLwbNu0Af4yIiymi3cKKqro8Emji9ZeTi/nh/a6tU++AApmQS69w+fuA5TLoN53NZanmOlr9v3IfyrNo1tsRBwNvXukxZkNq60yqu/jbWL0qwwjGGVdZ4HOLqX8gGjhA1LUr1Kohe9QMO17p2fNehWV1F/Wg9qG1SPSeg+XbsX4Hc0x0BMtFMjOS1dQb8F+BBgyelrC/cL6WjLsosbpQHz2nXW7ia/sW1vxZj6HYgD1ReVlWMPELIu50eYEV72zZ9RvtB9udg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 15, 2026, at 01:08, Tal Zussman <tz2294@columbia.edu> wrote:
> 
> The last caller was removed in commit c466412c73c3 ("mm: memcontrol:
> switch to native NR_VMALLOC vmstat counter"). Remove it.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


