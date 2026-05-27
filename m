Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE235CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 20:07:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 846386B0005; Wed, 27 May 2026 16:07:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81D226B0088; Wed, 27 May 2026 16:07:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75F626B008A; Wed, 27 May 2026 16:07:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 644DF6B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:07:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DFF34A04E6
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:07:00 +0000 (UTC)
X-FDA: 84814283400.11.B9864C4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 11B65120006
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:06:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=10EY5CEp;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779912419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t24yiIj3iGfqZREtbmVnrduVKwQ03r/frcUxbwRtR14=;
	b=BGQrNqmAZyvJ8ZdzSPf2gTrr+u080i7gav3ue/ucYReqr6JQYRM/oGJAH9O7B/q1/bGQzh
	Fqo+W3kvtNMV17/sBSG8OjoSsM0/pqR0ZcUUqhQWAcX5GPPgjYsGK3DCDmAMrNt1ZCXn6z
	tZgR/qgKijGNBoajZSYo99Rw+reeNb8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=10EY5CEp;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779912419; a=rsa-sha256;
	cv=none;
	b=rCuJhiEM/RyKcFBST/oO157DgaXcJfAcvOOCCDxKuqNE36UXji+Hn+essZkHLPa9lcsrmq
	WLkAzP9vgjpr4/nTsaI4mmUSleX6oMB1A3uQT5Zpt+jz3PxmwJbty8C7/x9ulezsxgW9mD
	hJ5GCLyR5gfqK//0Ht1od7dfAoK0JYo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D801642AF0;
	Wed, 27 May 2026 20:06:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E30A1F00A3D;
	Wed, 27 May 2026 20:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779912417;
	bh=t24yiIj3iGfqZREtbmVnrduVKwQ03r/frcUxbwRtR14=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=10EY5CEpYpPR+7kkjM5ExyfirkKrxnM9VigApFLCRHTylpQaXI94HACcmcmNfRbdh
	 NbOL8v1sFIii6M8jzCoJOXh+uJWxB45ycXct4pqee3O3+CmSsC4AuYJ1aV5u63vW5a
	 98ianTyuplHWq18kMmur+rH4qtaY340JL/dvRQCE=
Date: Wed, 27 May 2026 13:06:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: lirongqing <lirongqing@baidu.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>, Vlastimil Babka <vbabka@kernel.org>, Harry Yoo
 <harry@kernel.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, <linux-doc@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH] mm/mempool: use static key for boot-time debug
 enablement
Message-Id: <20260527130656.a448e84a30dc44617b51b45a@linux-foundation.org>
In-Reply-To: <20260527104634.2434-1-lirongqing@baidu.com>
References: <20260527104634.2434-1-lirongqing@baidu.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mfwtmp94r9njkwauu89sfffx3twcr8co
X-Rspamd-Queue-Id: 11B65120006
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779912418-857069
X-HE-Meta: U2FsdGVkX19V1S2+t7BAkgdGVVulcK8VnHp3opV0bmx1oJ3PeA4S6JAVSzGeZLvOCM296sxDxNIIxjIqSPQpA3WtDBqdKcEfozxa5KxpHRAEr5qJpQtuBJRWidaQ7axq6yxFERHbJEpM2yBs8Qk5LClOgIEND7O0jjzxlZml3q+8/nD9Nl/wxD+DE2SrZTRillwO+JBmhevL4NSCWpoEKCUBWzCDBDPP0XQ4zR9TvP1XDY2HGsh+WCq7RU3NCKq6m1lOvBnHJ5mX6uK2JMca2Wio+iVi2z5GHx7uDLHxv2tz7H9ixFP0CLqciiSYjkaVYVN+Whu3EnCQDAVFVO0h8k2EcWiuStO7mwN96F9eDA0REzzyYXkVnrxJNf9Pwt6JkSESuqnTqX0Fp0po6DHjxz2AqTSzES2fRThLHZHV3IIOXiYTInmPIr+nhXL9KkXan3pPtDqdZauH9BG2muvrQvs5IQ/59pN5uQ6LaBMZ9SjFL72+JsrNActBBMtj9cpqpgUn8n/idQX8Y85xmbkkiuPOc3gOuh+QBTMmWSGhRQfPd4Y/5yAd3k8nsLpZ9SB9oqr0Sw4cAq4zOoQU3KO+dVh2DdeUQu/Vxb+/2Sf81iHLMuzgxm9nsEA9lbDHNX5c92ThDC7ViG5T1+Q5gPI8i18N1Y+1UqVNB7G2MY7uRhyG7E0IIeHsX55QuVKTkp8vId1C54NwGtQlpDvZGMVgdSVrTPy33pg75EBsTWxxySnklLtizh8wrqDKgSkeQ6f9sLqwnVrp+m7Bj7rhdebkqAC5iFfPXvttIcquVp2sfvNuOV3cR4FOg+eiNEjJD5pBcSM+g5l7jW5uB33bWfkElHL3JjXk8EuirD+Le308IS9bc4VCYBGWuEAMN5gz0/fIF8eaFQPmJ71Vyi9507PXeuBM7hJ5aUjMZoE3tiqQTZUgDdSCtlaipKEtx1h/adI5DCBKkOyWF/sAzNegxYj
 ZtYQyqKI
 buhHtZacOiw3sljPjW5gPno37cvQKggd5mFea4CPzWNY6Gct2R8vIlrAzbo5Tlfe6tykDexzV8cGbzlh39bJQe9Jsm6n8z1Ur3lFignV7tLYNfSu6sO31Nk4teD3woJjuECuUtG88ESVjX+P5vpBtdEWq49QazEpqNOmq7393mFdHeP7WCmPkz6jJCFUJlOyR5cFflJJe19LWSitbzkhWpHVxhoUiXYME62z9KFOP4Abiy5Ode7Z+I7mu54S9bXfc7ptdihai7IS22y0CKTw+lXImEcviCcvRtKv5Jm9/SU0iJLrSWy7deM5Senvj/vMjRHbDQc1epPfQM30=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 27 May 2026 06:46:34 -0400 lirongqing <lirongqing@baidu.com> wrote:

> Replace the #ifdef CONFIG_SLUB_DEBUG_ON conditional compilation with a
> static key (mempool_debug_enabled). This allows enabling mempool debugging
> at boot time via:
> 
>     mempool_debug
> 
> Instead of requiring CONFIG_SLUB_DEBUG_ON at compile time. Benefits:

Sashiko is suggesting that we use mempool_debug=<...> here.  Which permits
mempool_debug=n if for some reason the kernel is defaulting to "on".  Which
we might choose to do in the future.   I think that's a little better - do others agree?

Same goes for the new dmapool_debug.

Sashiko asked a second question:
	https://sashiko.dev/#/patchset/20260527104634.2434-1-lirongqing@baidu.com

