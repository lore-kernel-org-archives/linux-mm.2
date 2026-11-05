Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE4A0606A330
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 22:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=FZL/4bYI
Received: by kanga.kvack.org (Postfix)
	id A69166B05B2; Thu,  5 Nov 2026 17:13:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1C346B05B3; Thu,  5 Nov 2026 17:13:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 908976B05B4; Thu,  5 Nov 2026 17:13:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 68D9C6B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:13:38 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D9612140531
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 22:13:37 +0000 (UTC)
X-FDA: 85402468074.16.9DCDD16
Received: from mta1.migadu.com (out-239.mta1.migadu.com [95.215.58.239])
	by imf30.hostedemail.com (Postfix) with ESMTP id 957E380002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 22:13:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="FZL/4bYI";
	spf=pass (imf30.hostedemail.com: domain of jose.fernandez@linux.dev designates 95.215.58.239 as permitted sender) smtp.mailfrom=jose.fernandez@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793916816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4KVE0mlIb8Pa60CBHZvDD8qqhUD9QNgg/6EGkqm9L1Y=;
	b=GPCUy8D+OUjUaJ/4ay6tIzWoSTLzh6KCRGCV1D5kU7TIbNty9g19xGPwBvYfP1jk0mvudU
	LJBwtlzcg20YWpRQc2SwXlM8XJ90ywbfo7X9Ic/awLUlTZZfPV7ChrUKLkGVXFSTqR5+lB
	F+JPsu57ZqkymU5wyseYTtjPt9rYPgU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793916816;
	b=ebgs6KYKJjDZrNMrOUdeR2WXU1osXKJ4ZwAJcOD6xg6K/GjDxuTV3sYeGx8+Ad6l0IEijg
	4WezHvMGu976k9z7v4jRRjPLbTiLY0/6FyjrBf8LWmP868r7LB9EeqtaJxm01c1DgD4gpN
	tLf82+4B2lWqKg8mY7gBbOaUTb86mTk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="FZL/4bYI";
	spf=pass (imf30.hostedemail.com: domain of jose.fernandez@linux.dev designates 95.215.58.239 as permitted sender) smtp.mailfrom=jose.fernandez@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=DkefybD1i8xvQ56jyQ09h/HTM19UexBk7u12ksvN4Ok=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793916813; v=1; x=1794521613;
 b=FZL/4bYIYtPOxgYb2t6NdTInSEADFu24zE8bVTWhV8d7DKiaTGawM60fbUJSi3opG7QUYT7r
 5UnBWjhj0KMKMEeoUUIC+NFwUUQIA+EkX4eLPy8KMDb4oSee8lfUntIzswfHl5C7tAwIKFlgRV/
 vpx80WMwdwnvpLm0xvNOTR/c=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c3dbcbf73ad53fc4;
	Thu, 05 Nov 2026 22:13:33 +0000
X-Mizu-Trace-ID: c3dbcbf73ad53fc4
X-Migadu-Flow: FLOW_OUT
Date: Thu, 5 Nov 2026 22:13:30 +0000
From: Jose Fernandez <jose.fernandez@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, David Hildenbrand <david@kernel.org>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Krystian Kaniewski <krystianmkaniewski@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/filemap: stop fault-around when the walk steps back
Message-ID: <20261105-jf-filemap-v2-akpm-testedby-reply-r1-36ef39856b46@linux.dev>
References: <20261031-jf-mm-filemap-map-pages-lower-bound-v2-1-21029744e589@linux.dev>
 <20261102092750.e53073b2c7b872f9d70c0711@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102092750.e53073b2c7b872f9d70c0711@linux-foundation.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: 8z5uqxhq4y18c6g5x8ra3uyr74rr7a7a
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 957E380002
X-Rspam-User: 
X-HE-Tag: 1793916815-64637
X-HE-Meta: U2FsdGVkX18C04Lt2Ls28cVCJYdl/PabQDewF/QyglbpFiybXrJam3N6xbkKH7S1x8pt0x+g25NndL5gXGUXghykKR1FzJm08IiqDcHdM4ra37RMml4XUv4wSwlWncfz97lRkhw032zBX4q0SuGi7YQaV54hDNPhkhidiMqfQFn03mkiJIO+03aw3rumeeDM8X+Kytu1Qj+iXFBD2fl8qSrXIusjFZ6gIlvCUyZRSYtK81shPKIpF3kbmVQzBpRXODV8+5NFarCJm+eKWcw1QuX2vvTTQwkCpNxShbgVxmFaz2OEXv2uqe2UweG+re0g2oe6eupIy3IbiXWx+hmIKNooqq28ST1aZUQk7s6X+86qwZwxAqQ7XGqQrKizaBRc7aSjPzn8XdoVCz4TJnVBJwMCwOInoj1GEG4khYO6e6Vek1xqZJ0w++NGJjxts2PpIELfYKgE6uAum3EaFDQcCrSFrblaQiKFhoFTLTLOlZQwN5STg70mdef0VCG0CTKcb29erAw1uvfiwjtJUMpV1jjcVhDQ8qRPk6il+P9T31NXVkmMAQHaiS1LZcNGXclrtU+ENp4vkT0q95u7i6L/KbBd3hDv50rptA3babeZluv7A4tpiyomslBxuP352G3bwu49LTUZJqyxPS8SdTrwqbW/rUQl6qkSScln1hwmPhp0voMXo0brSjs/Jn6T8T/GW3IbusCa/sUxe4Xfx/SfzfteMoVQrrdu311eiKkJSIp+lWvSCdFoJsbvNmvcRvIMDiumYkoID/UWCFg0CiwbD+V6PeE0WBDcDw82sFxWoGbUDMrIE5IMuaO2veJkLSO/ucUJU7IUkjtvmYKZXJYCdh5MTcdx7GJICtLQLiGPAlxBD2Qx81VaRZ6KdX3XdzLo87+2sWrxgzA3eiHzS/gyLUMHsubR+Z3T9VhDahxwQ31Geh8hN8RsmnrTmU17dWVLA6yp/ziYEKe+FByp7WA
 rl02Iyp4
 D32GdUeMI8sSpcAuAvJ7HnFmHuSGT3eI5hKNyEd3IjUj17e6DtML/7ylsbtrGaMGQuEWeASwQTZsOVWNfMaIUyyZhWOCSIBgkacS7GQjh8a4IXjFcqn5Y6ZgiAD7C7nJyKQWZ8DxWgdj9M4Y+25fypbEf9ZnAD7WNGDhSRlbcu50ecX8V4ksVlR+CJncVlmf3nPzqom6KypdTMvIbDXVjZfmGArLWZImnI72QBrNBOmuBpOwLjhoqF9hpuo/RdayzGiavkL9vhtrIYPY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2 Nov 2026 09:27:50 -0800, Andrew Morton wrote:
> Can I add your tested-by to [1]?
> 
> "xarray: fix index jumping backwards in xas_find()".

Yes, please do:

Tested-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>

I ran it under the stress test from my reply to Pedro in this thread.

- Jose

