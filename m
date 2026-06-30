Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3A45C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 19:50:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66E676B00BF; Tue, 30 Jun 2026 15:50:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6469C6B00C0; Tue, 30 Jun 2026 15:50:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 537576B00C1; Tue, 30 Jun 2026 15:50:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A52C6B00BF
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:50:29 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7ED7E9019F
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:50:28 +0000 (UTC)
X-FDA: 84937620936.11.50329B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id C5EA51C0005
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:50:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=le072lq0;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782849026;
	b=YADwiLqhGGiTRQ52zX4HpTdGD0D21inthXYVGIIiAvLDDXYjNyL3iXi0kazTQuhZGTyNWy
	TK2GpQwRxfrLqkhasI/zPFCNLm6/V3qG7bwZZ7hU7XFWK6hgT4mGL9y653MTNPVoyyUqfs
	MqxGUbzrOPEHktJvOjr7eLcw33rs4F4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782849026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FMxmVQrFcbWBi9W6ES9lijana0prsiuY8ycjOWzjCwY=;
	b=tMQ/25RVnVnQGHNhMCKJVviehsnGqRPjmumphpg6AzUa/B/On8fyUGuzesNt9tICtnuzc1
	2tzHwXh7VUEKpW37jxrGWAyaAqLwnpa9HtdNHUYQ7dNn4tP50GWmcqmZzaDboxJ+BU21QI
	GqA7fKXQ+V4TpNYVN/CIXoQQnPk2vvw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=le072lq0;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D194600FC;
	Tue, 30 Jun 2026 19:50:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3F31F000E9;
	Tue, 30 Jun 2026 19:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782849025;
	bh=FMxmVQrFcbWBi9W6ES9lijana0prsiuY8ycjOWzjCwY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=le072lq05S11cthELKbk6B5NinT918q60jWaE/wqstt7IXJGysONgpodmnxn+0d/U
	 zy82u86XKgQsazaCVeE6QmjyZQC9dUSLOHggftvCtSAadZXZVq+8/SdoBWzmAvqvGl
	 e1nUYigYVV6gYyqi0snij/xCYsi75KhgqV9+EE6k=
Date: Tue, 30 Jun 2026 12:50:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: david@kernel.org, chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org,
 ziy@nvidia.com, linux-mm@kvack.org, ying.huang@linux.alibaba.com, Baoquan
 He <baoquan.he@linux.dev>, willy@infradead.org, youngjun.park@lge.com,
 hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev,
 alex@ghiti.fr, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, Liam R. Howlett
 <liam@infradead.org>, ryan.roberts@arm.com, Vlastimil Babka
 <vbabka@kernel.org>, lance.yang@linux.dev, linux-kernel@vger.kernel.org,
 nphamcs@gmail.com, shikemeng@huaweicloud.com, kernel-team@meta.com
Subject: Re: [PATCH 0/6] mm: preparatory patches for PMD level swap entries
Message-Id: <20260630125024.6c079ea708630d99708e26f6@linux-foundation.org>
In-Reply-To: <20260630164143.1595669-1-usama.arif@linux.dev>
References: <20260630164143.1595669-1-usama.arif@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: p9pb819s33coasoe11uddthx6z6ru8by
X-Rspamd-Queue-Id: C5EA51C0005
X-Rspamd-Server: rspam06
X-HE-Tag: 1782849026-195990
X-HE-Meta: U2FsdGVkX1//iN3B2J2OflPCLz7Ia7JIsgZieuH5DTVweNTj4Q+o43BUooQyKvoJuvdsjBZTe6IZN4ZA9qwl5BKbO4ZGX27lVskJgNKEZhA1Z/0kaiIRc+UhGdAZH8XM1KhuiBYPatI2IH3sOCeW6yNMM7h2Zae7r0k1F3JR0EnTxQfU622O4d3Z+jyutDEe/uU4W3H1EknLwe9lCgWZiycWImyGbASsyvZft+PVybE/ZIAHBBdevxffLBo+X9ocBq4EWk2Ne+iS4p3a0WVqT3b8g2/9cpDoJfVI9ZeRYxkOnirvtUokvk9X5OQkriA31BUzxuEZCfIXoq/zCC9uDX4WUnSJ61i+xNkHkJFdLI+VHJdQTo7hWRgF4ZVtVfJrKkh7ngnB6ek8a/70wJCZVvt5kdzYpAJ1nwb3Qn4QdDiFpXecRhILd0YuNK9bMrhCV19aYi/7hLPLdaXU2d+7msQtqLX9wyl1spBCevA9eaRZKk+MQzKc4ovM4aMJp6tExVSlYqxgjaAXdW1rcm9+4WSi0vvEUa2A4EYRl+IjibbBBpU78FoSZgdtK5U/AA657TCCa2r6Kn72am20jbKG5r9LWgkzB6h06BFtwxt3mMRHUdWLv2ArpIHYtpNXqpKsA1NTlQa8wekTFEZk93GsYow8Bncc2Yvm/G3B94lIf0TqRBwqrx72UGfxJ5xm3ryDfc2W2qsQYxVpN8lVBzzaw/W1DvOmRVqaB7Rs5notq2uHNoZB4hH7BunRspP1Bm+VX+sZwx9TtL/++uDO4o2oAQ3EPF9vKmHpZHd4ogItE3ASj3d8OxGB9WGxMxFG/FePm85J0s9lkmMMQxvaC4Ejs/Eyt8R0GziFFR44Gwf5+8vMtoq+hSZYnYG3KcA/UK6UMmGcF+qSzV16ydboKpChVHLU2W8FOOaNGIGNMH8jZB8v+ect4SA6Ekh4U1Fb7wsPOJ+gX+aIUgnSWVjWpJS
 3epsJ/H5
 D2pIAL6n/KAVDYwWPw8O3hfbJ2xsS43DB3he2RlPbsT2lR30TNfOF+oM0SiYoutGPDhgGI7j6tHiQsIew2JvmRl8vMBOSGN62pSsoyNh5DsOXKDIIDWM3lBd4kp3acBF/Cw3uoKmNKBQUejf2DFaxsSFPHUsdJtqv5R1qbFfaJd1iF8aC1v5O2f3dJx4ZgYGi/Z0dR5fwbKXC4p7nN0ePdOaAxf32MslD9eq7RNidh/SGI/61KfTF8qTenG8MJQuZoKkBr//ljn7YUt9pjLSOqZ7+e4tim8Hg1wIvbj5ulLp4ONOjZ9zNIaHAUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Jun 2026 09:34:37 -0700 Usama Arif <usama.arif@linux.dev> wrote:

> This is the preparatory part of the PMD page table swapin work. 

Thanks.

This comes reasonably reviewed, so I'll queue it in mm-new.

Why?

- Human review coverage and AI review make me believe this isn't the
  final version at all, but I do believe this is something we want in
  7.2, and getting it under test early will help to push it along.

- Getting it in there early means that others will base their work on
  material which will probably be upstreamed this cycle, so this gives
  them a more accurate base against which to work.

Sashiko did find a lot to talk about, some of it pre-existing so can
people who work on this code please take a look at

	https://sashiko.dev/#/patchset/20260630164143.1595669-1-usama.arif@linux.dev



