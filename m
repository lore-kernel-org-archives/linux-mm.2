Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60390606A32D
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 03:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=f0hDW6PV
Received: by kanga.kvack.org (Postfix)
	id 3B8476B05B1; Sat, 14 Nov 2026 22:16:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 369586B05B2; Sat, 14 Nov 2026 22:16:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27F0B6B05B3; Sat, 14 Nov 2026 22:16:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 060296B05B1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 22:16:55 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7E3B0A7FB8
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 03:16:55 +0000 (UTC)
X-FDA: 85435891590.09.D0FB94E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 119F6A0005
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 03:16:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=f0hDW6PV;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794712614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=TzufViWEiCtJUEBmIDg3DdTQTI4Adeb8R6m3s+kliHQ=;
	b=vA7iGqYVKaOIq9GN6Lj7EIEgKCWCb+ohZSkUxnwyz4xya2eswtXyAy2OPO4AbcGFZXpqCr
	IpDHfW68h/U2efZmoZH85MjXP/petfQht5c3olzftJ1ZSqYxnrrQXiHI+bxeAAwpjB8s39
	UMYu3k7kctEiJDl4lcsls2mo+B42MoI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794712614;
	b=CwmZvBk07q20DpfdH3J2WSqb9APIn/WZu34U9uaWJnIXrCkbnoZow0UWkbVh/gRpOufX8R
	g3nTScRaV/UfmqcTWH/RAmUYOS1xZWpRad77bqL6610kRA0Saj0WCuJ6fAF5EO7p4kTx3A
	fHbJkzRfiM7MHXbWyrNW4RLC2bpFwFo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=f0hDW6PV;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D17D6060C;
	Sun, 15 Nov 2026 03:16:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232851F000C4;
	Sun, 15 Nov 2026 03:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794712613;
	bh=TzufViWEiCtJUEBmIDg3DdTQTI4Adeb8R6m3s+kliHQ=;
	h=Date:To:Cc:From:Subject;
	b=f0hDW6PViaxHBwEUrsI1C0KD+B32h9lsvBR4/0H0B3vdgJ3F+0QFdyYh8syyqtX8E
	 U9sAVTQb9hla/xBN2C/YaeGSRyCf944YhwhcP5De7zOUtG+CzVut5cMukl6XuMoU8z
	 LhOJQp5jse/wTnAE9PEgv+Q82vy2EGI0QKhMJ8QY=
Date: Sat, 14 Nov 2026 19:16:52 -0800
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Shardul Bankar <shardul.b@mpiricsoftware.com>,
 "David Hildenbrand (ARM)" <david@kernel.org>, Dev Jain <dev.jain@arm.com>,
 janak@mpiricsoftware.com, Jinjiang Tu <tujinjiang@huawei.com>
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <2dfabfd9476542e39c7d5473a6597208.0@linux-foundation.org>
Subject: [PATCH 0/2] xarray: free unused spare node after range creation
X-Stat-Signature: cdhzh9tjkxbro8x8hqhwe7khiuwdj74d
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 119F6A0005
X-HE-Tag: 1794712613-180307
X-HE-Meta: U2FsdGVkX19Vf0E/CLXfJxbnahAd7lkX+2CdbIeBnNiVl1T2vLvsXGwvC3YXC0WhBwz6knqzFOSopXHaMAgSIbWGmwXPsObZBSlX7ZGxcbaQLJ9YaPwLAK6aGQSDSPSAFsfbog4bwDi1ne0yT5Lp7nCr1GDzrBbu1bowL9PKcd4CifT3QnXGUjV6oLGHvyV8A3h1zClyhiLmD0TUDrXDnrZTDUKrD9WOcP0V4pUf8nh4R7TxiJ2gHvyFCWgCklMPSZnPujUhnZ5qvaoSE2julMjW9JEvz2g7a2jGUIgJLALHao21YiJr3q5BsyfovgXhzG7Q12xJg3mGDbnjHw0tDdJyx78UuOIGBPbC63FAx73c4LwsKzf3XlAdtdCJZU4RrFEYl1CN4Px/xupqLN3FXQ4xqEQUIDQDdmQgxw63QA0Evng7cKGRX77NhKzgOIrgOznlLCErfO/q4kOpTpTmp/gec1u4JIWI01Tb3373kDD3KiOUegSMGL+OhYJ1Lpk25Cv9COWrEjwswlVNS4O8P6F9ctuCYxAalxOCb/IX2A65w9EHorMe0i2N5nBmyr5WqVPpbqkz8BCFqqKn/EbOqSxYpaxdME2cKLvlQLKenII4vVkJkvVrum03vTzobXtebm7D8hp5mjDyTQWZIn24BjOzOLT81TADsZDJAjqnrVef+R5sGSwsGW+FrpsDF2bYG5OPjzH/yIotFkfbv4ERr2PMt92FLPsnIJHNLmpO2PV8wIZz1dKQSEajjTLfFiqqgNT7chcSmZlMAPmNm1QWHIkPtChQRkuL+fwYXQbsmKwS2KnouzISOANFIT+uNpMYRS0VGd92rRqpZIO0PcAhX/Cnl9DzJNRMBw7+iUlzeG2Z5U9RZhPvndhDhUBZy0KBJq6vSjBnQQngS3PCB2IYDByoC6AcJCDSD2Pso0VVBao9YNpnf24jjSTf15ZTqkrvIMjiNQii0TmoeJIhtB9
 O9yJ8iuL
 6CKos94VapfCNBq7ksKD69DP7cBd6gmpXDmH6GCBf40vtVe79T7iDeMVrIAnUloKAylbZGiMlm0eWRFdA4M8nlkDm/MvbsavWHTqpdswxavKsZqbw9RNAhRj7d8rC/klDPVkn7Z7HDQ7EDuZbDLPcRJRJj8PseocmzJo6nL5hPAAzdTPW4TRkLxtH6rOoVOjPLXhTS+2hdJeRReK8NIonLTWER3Nd0qWxetbTdFAEBeStSi5S/lW1Qvlt8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

xas_nomem() can leave a spare xa_node in an XA state when another user
populates the tree before xas_create_range() retries.  Free an unused
spare at the end of range creation, and add a deterministic lib/test_xarray
check for that path.  The fix is first and the test is second.

The test patch was held on both sides of a kernel A/B run while only the
fix was removed and restored.  Without the fix, its spare-node assertion
failed (158825705 of 158825706 checks passed).  With the fix, all
158825706 checks passed.  Both runs used the same verified guest test
script.

Shardul Bankar (1):
  lib: xarray: free unused spare node in xas_create_range()

Andrew Morton (1):
  lib/test_xarray: check unused spare node after range creation

 lib/test_xarray.c | 31 +++++++++++++++++++++++++++++++
 lib/xarray.c      |  7 ++++++-
 2 files changed, 37 insertions(+), 1 deletion(-)

