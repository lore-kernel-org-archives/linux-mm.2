Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6105BC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 12:38:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 123CD6B0108; Tue, 30 Jun 2026 08:38:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D4856B0109; Tue, 30 Jun 2026 08:38:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 012B76B010A; Tue, 30 Jun 2026 08:38:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB3B76B0108
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:38:33 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4D5938C915
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:38:33 +0000 (UTC)
X-FDA: 84936532506.01.95511F8
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6C1FD18000A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:38:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jgSEgznx;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782823111;
	b=DTY1JM43w42/hEb/qRcvfOYFIqIz2lkUb6IlZ+Urwv0lvvSaba12FHx5H3dcIlDuOSVdm2
	J2Nxa28emdkk17uGwjBQPo72PYwEsMZZr33drB8SDAqhFX1D/wWyhaaKhB0IwxmciBj08z
	VN3XxEXaVOWLlTDmWpTTF2ucAAaQGjs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782823111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wwukuDKbyljD7hId+oIoTVO7P14eUg01P4v4+Ftn7VA=;
	b=iL7rdavs8WxDfvI9VtOCLpBGn4OVgNXobgR/YUrw+ewBIZ0E6dhUaCkhjMissjBeWlywGe
	kDiAAtW1VsIHznJ2QY3G4YF1+sx+kR1cCzcfxd1kB2yqm+leajY1SysbNaPDABxBjLJsGE
	RAQVhE7MVMghWy8Bcp0Uo9SAxAdSX0U=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jgSEgznx;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782823109;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wwukuDKbyljD7hId+oIoTVO7P14eUg01P4v4+Ftn7VA=;
	b=jgSEgznxBiHGQaexqZhJkecqo2BuwDaiUFnh5YpQFZ9C/GoUdN7hdqIrEOAZ5aNblcamMw
	iv6u9XKMGSbVfvZf1nt+cwmRBML8NyeguYi/xGsDFnS3FC2QqntjZ20gltPoXsMtN+lduw
	QjDRfgzcPuAoUoCiHCPJEf6RyCceCXA=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: davem@davemloft.net,
	andreas@gaisler.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jannh@google.com,
	peterz@infradead.org,
	osalvador@kernel.org,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v2 2/3] mm: drop pte_clear_not_present_full()
Date: Tue, 30 Jun 2026 20:38:04 +0800
Message-Id: <20260630123804.10313-1-lance.yang@linux.dev>
In-Reply-To: <20260629-clear_not_present_full_ptes-v2-2-96089871a1e7@kernel.org>
References: <20260629-clear_not_present_full_ptes-v2-2-96089871a1e7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: wiaf8y4hpp84qh855ygywhyg1yf6xnhd
X-Rspamd-Queue-Id: 6C1FD18000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1782823111-640302
X-HE-Meta: U2FsdGVkX1+hB/FXAq9VN6+6eR89fkrc+gYIEz67ktOl6q6QNbCq+RaXbUqD3rBYJSmgLH27g51vpPaHMGFec/PJu+dHlWbw/GZTD5QiNUGsLztfV2qtbM0oRloUN60wJVxJrAIXAhHfJ99rmwiO8KdU2rSsdCSw+2C/QwiBRIEnf0seoboIpnXKycXsxQmLZcRJHHrCH4GhWqU64gnMDw8Jt3Bx9PH2ifPLaTCnngxrPGGgZ9sxncUql7M5jvKbqAK4KBFR9XMsO6FRBhwqCVEvZ/TiwQI4pMi3LtAX/vzcSi1W+xlLiJB8gtBCRUthhYvv/2wVn07RUDvVpAFycaI1HVXnwVz2yAHaFw7BsThazO7+i2/FpYmqPYUronPTNcKPtYKFJzc2q/ZOKwlCjMlPEr8O5yCpsKJeRSDx4HSMV3Ub94hxIddcmzxCZwvz12ExGwOhFOCR5ZQqL1gXYd/fhJ6VKBWDqgtdT7MHIAPugADTaqwBwZqjhajjJCB1tpiDK9lO+7djCwwAhHft86l91Yl/cPFuptc29J5P+AqWpeg8XTR2xSYCYaGq8syAG6yGgwh8GzljHGjkWzCMUapVifomKfV2p42WkaoviXVk5fgvZ+M9aKGQB1xyL/fwmeI42nIJY4yYakDHEY5tTEZ5+KgRfw5w9s1S2dqZNBEnv7Hg2JqGISRgdngpAHqgpt5BQBtSea9vZYJdYp+TwRi4eXzftLy+O1nPE/WcdeANWC3OhpiV5tvYekFNpOzZIMszpU2TLcbg+7JIXf75O30LX2iABFaPa+1PN84oCJLwDDEKllddJjhtu76G+JPzkmmNSiRmHpbl8JVcaWZ4ockz/zWmUbUZ7L9eHL/6cX0eZitvXaXflorejFI7tIPWeB+sAuE8GY+4Mlz6DBj0tNXzrsabXiOvo3pPzf62bNDW/KBp5r/iebQR3W79+XqoVQ4KgH1Kmm3gVF++Xy1
 t2nnoSll
 1Thqc6W/67H0mMXAXAg+zlFQ3PcEu0APUayAqcBov3yCjDZ2z6MVpl1JNhQAp2KRKwBvC1tE1UuOxLcXCpUmxqV5+yz+lrZiutMsEQ4cwaV/nBnAgmqKWUz2DzotzYxrXjvhc4KBLWDVkFQfClz8OIwQRAzg9wj6tz6S5l2awehftEVaK9EeGdNNCQ4BF4Fk91E2P1B6yFne6osQ0yw5ZfXi41/QuMSUBHuO8kgShsrTtLoJxLthW6u0NnIG5JNGc8gUrvxLgRFb6oakdYxd+1ruEU+eALsBsEnCQsfU6sx8lxzB88Ktb1uFZ2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, Jun 29, 2026 at 03:49:48PM +0200, David Hildenbrand (Arm) wrote:
>In general, there is no good reason to do anything special when clearing
>non-present PTEs.
>
>In theory, HW that does have to invalidate TLBs for non-present PTEs could
>benefit from a "full" parameter, but fortunately
>pte_clear_not_present_full() is not wired up anymore ... and there would
>have to be something very convincing for us to care about that to re-add
>it.
>
>So, let's just use pte_clear() directly now. To avoid the compiler
>complaining on some configs about unused "addr" parameter, silence that
>here.
>
>Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

With the sparc64 override gone, pte_clear_not_present_full() is just
pte_clear() :)

LGTM. Feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

