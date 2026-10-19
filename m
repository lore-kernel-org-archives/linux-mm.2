Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32071CCF2E3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 12:48:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47BA06B00E3; Mon, 19 Oct 2026 08:48:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 451E96B00E7; Mon, 19 Oct 2026 08:48:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38EAE6B00EA; Mon, 19 Oct 2026 08:48:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1B3A06B00E3
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:48:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A71781A012D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:48:52 +0000 (UTC)
X-FDA: 85339355304.19.B2CEFE8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0D889100004
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:48:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DAL0Wg6/";
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792414131;
	b=PV/YLmAz+S8TSLc8kKrc2d41acW1DO4fZsmeWc/e9WI1NxHYmez+MnzilTDPPiuHwYeCsJ
	Uwam/mdvun5gUASWHstNawfZJK1COg8naEsYsAguUYOpMbA9bopvu0U9CIMYCPf3c4ugDj
	q7GYVUZKM0k4OEhodVTF/aVKHAS1p00=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DAL0Wg6/";
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792414131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=82tscvJQeALvTjkOiogQrI9DMuVsqZ8C8KWnmNFXNYc=;
	b=YNsrvDmXQLYU8VI866tiD1oX+gtrzXh8P93qq14/yvFn1JirCN61WTRALXkbqGjsQfarGU
	g5X72a/PnIYIB5bZ920YLBb+dGo9QhNyNUHBHsN8qTVIZhmdsJMIj8T7J/n7XH5US9HFis
	3iZeqle7PV6Tr0QJWrgPWKUJrf+5lDk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 95E34601F9;
	Mon, 19 Oct 2026 12:48:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33601F000C4;
	Mon, 19 Oct 2026 12:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792414130;
	bh=82tscvJQeALvTjkOiogQrI9DMuVsqZ8C8KWnmNFXNYc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DAL0Wg6/9CAY7gjHSBkAIkZf4BBRLeX/6ZZt7JE3LLky3y4IS8d7a58QHpZBfaSB7
	 TslxDHWWf1ZqKCJcZ0ipcVYij3tquqIkl/+kqoSrTXhVpDBydYN6+ToqvvP4Uwfh0R
	 zsIMQckdj6m0knPgc1UlxUtutdlGQmKFGDDfjheKS1zqzsdSnaeaMnEdP91F4/fil7
	 4EV7aJHIfg8CKSeWLa+90Kfm+Y84ZWDJEjnC9X7K+J0mNTKqc4nrNvRLIMBX/M0Ye/
	 EADLl6zZnPR+onOPKGcSylhtfcavSqIIZte65E+s6gIomP32z5xiSZ0fcZX8E+BrEK
	 +DE9/BZfZBehA==
Date: Mon, 19 Oct 2026 13:48:46 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/vmalloc: read vm_map_ram block regions from the
 requested offset
Message-ID: <atYRUyFHca-giQcw@gremlin>
References: <20261017125244.b2d7134fa9697b2982cb8cec@linux-foundation.org>
 <20261017231325.796986-1-nickolai@csail.mit.edu>
 <atSM69faDNgmLNVJ@milan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atSM69faDNgmLNVJ@milan>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0D889100004
X-Stat-Signature: pjbw6gwznhq84z6iy36ma78d9jkr3s3u
X-Rspam-User: 
X-HE-Tag: 1792414130-971863
X-HE-Meta: U2FsdGVkX19M10T7oBf46w/gC4eVc24S9+BF/ldk+k780e1s7Fy0aPGcEHbxsNuBQZJUIFoNmqk+nAAsFxKLTp0KX8URgqzIJOMA29748+HWY88qBT7sT+ZLHkjYvIs2ReT7bRyiHiNyPY5U+ALW79VWRBivi8WVW+Y9kWqfQbKuX4bsAAqSziDZeXsvYOi80kjYNyIlAVxIam+6PYVG3L1Q241Tr0CPM9zG09S75ut3D8WwVuwtA0R2wi8aiqNbWZVYBANOWKgFtAUquB+9DS/Esf6LNa6LjHX7q3VNypPs9OzMj1MJ4OYONoIDrDd6/m5Vtch5T1XdrrOei13jcjqEQH7XOWd5ITg+rBoNCnjjoz6LHbIusf1mFMRN13lGIn/QlKUEgcIhpz4SGAW9ax+0BW52llsr3mj13a/AbtZdfpHb957I5AQbhqPi1D4bif7jlQHBzHVl8TnYrwfCgVUAKYzBpZ7Z++bM4ZlzNLrhfO5Co/5fZAkHxnq0iJahOvPu1STyu4WJZ+W3Wf+OOIUyo6jBZUF+m0hVxFIouTdDbktB5uS9Rzs3RKlwXHPZeJEFL6yu0PVmpz/ycyVAycpIjo4TFValx4TZHXQwNZ14loFRqeuMeNyxvVFSm+9jfV5sugr4KGgfzSisx6almbxrvFOG8S2trVHXUfG83lc7bPiVoOS/w1G/6LzP+6PUU7mIZIc1vpQN5VzeYO03DZQ9emzW4whfjerq6s+nSPxzaB+YfgR3Zokiymvee5cc3cCo0A4k8iOx+VKkHWmDKi3ZIhaBGnqeRQ03YEwa82hLqmmtt7mQr1UQYQD2VGcW6yQZqXGW4bv3yqryPCzYBN5iis9fz9nbKQYDTWpC6tgq8BiD+AFgqpcjPXJ6a7xcejuWm/CXEX+uBdFZerTzgHXL6O9Ti9MLbnMYKfxVMxVyvyNguMEzAVOLyLKxXejVTZY14OM4OaWDodaIoBW
 56IumN5U
 eNghueps1bCPOPEBn4H8THGROEE8LAvHuWCHfu32G4S9/lWbaKqaN2WSirgoNWPSdEv/gBK+WVxUoF1j1YEfHdI7qkLa+DF0jK9HfevpjTX2HOj74DzN8ULTN8aosGrIamVcply6Ad9+GSn1JHaB9FQXHWH9I344hPm/rawKMjrsPbPs3h3MzoceyY+TAxP5C+8OnwrSZ70Cipt9bt1td0sYuyPU+yD0vU8lOjXO3exJwUNXsKaAPYrY95VWVzk56lfefRgpKFpFkpgr4gvHxykxMn536irvqbRi63KhoC9kooc8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

-cc slopper.

Keep in mind that this individual is flooding the kernel with slop.

We should be wary about encouraging this kind of behaviour. I suggest taking
over patches, 'discussion' will likely result in having to deal with a meat
proxy.

--
Cheers, Lorenzo

