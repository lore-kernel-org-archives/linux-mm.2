Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3693C98321
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 19:25:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 767F66B0096; Thu, 24 Sep 2026 15:25:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CA2C6B0098; Thu, 24 Sep 2026 15:25:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5925B6B009B; Thu, 24 Sep 2026 15:25:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2315B6B0096
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:25:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 76C1C16030D
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 19:25:18 +0000 (UTC)
X-FDA: 85249634316.03.4B08EE9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id CF49FC000C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 19:25:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uk9VLad9;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790277916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kTOMC78hYvS4j1N/2zdXN2BOuarPzYcebqGM60fGb1E=;
	b=gjzilFlOtejA7nfxULKAU4s3u4yRvCTBMAUNIS535A2gq6cbphwHjCNvWGHuPdqVX8b1ns
	MqAn4PgL6mpD1jHl0wJY29zUDwejKirVUuvlHfvBBrFI2FqXGaRLAPQepOCsutzaGPn/Ip
	Mrj/kt5xq2icJngSmTu3uhEMOyFgp9c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790277916;
	b=4TUC/xOuSNyuNSFxxSOp6a8tjRKIIIbF2AfAoPsWQUF6fqS+yfDIGO2fbRMoo/DYLDXZN3
	l9kX2Zm5IYBUIY4OlSM86hW4eCeUUnS1nT5JOyNv0W1s3VlkIDjWANln41oi4k1ZGsgby2
	TetpvoO0by9JKCnriBwR7aNouxCZqLY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uk9VLad9;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 55390600D4;
	Thu, 24 Sep 2026 19:25:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33111F000FF;
	Thu, 24 Sep 2026 19:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790277916;
	bh=kTOMC78hYvS4j1N/2zdXN2BOuarPzYcebqGM60fGb1E=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=Uk9VLad9LzwzSjWcD4uq9aAkxNO+ukDyV9bQn2Vanyv+1K6CW0pemtuWvev8LDwVS
	 RJfttSYCp9KRyHOOeDaITobw0TOq3HrRqUm6Ba1rC8nrQD7eYDYTPgNQae6d3Xs/gt
	 7aJjb0GhtrUzkl7+0yTDybsjsJhhmDMPr7ZNb2McOlCp1YgGncHkCmRkz3qkKQUBdF
	 cT/2UkHXuOaJW+/7OV6p3LJxh9xLK7JaDBnN1Y3vY6ZXjgfEStyhOLVo5lEigBetV1
	 z3LozGyd4eDPkbdPQtCxVBWyJZvNz5+/10XJqM78NqjWWpXPMErX4Yw7yGnYWodAB3
	 vSIelN++i5ALA==
Message-ID: <f6f3a109-efd5-4371-9442-f87e73367521@kernel.org>
Date: Thu, 24 Sep 2026 21:21:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: remove the unused zone->unaccepted_cleanup
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, axelrasmussen@google.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev,
 kasong@tencent.com, liam@infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, ljs@kernel.org, mhocko@suse.com, qi.zheng@linux.dev,
 rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com,
 vbabka@kernel.org, weixugc@google.com, yuanchu@google.com,
 hannes@cmpxchg.org, kernel-team@meta.com
References: <20260924191103.3475117-1-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260924191103.3475117-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CF49FC000C
X-Stat-Signature: i9m83hwfnjudq7zpuezcftqzbgq55nmf
X-Rspam-User: 
X-HE-Tag: 1790277916-613703
X-HE-Meta: U2FsdGVkX180D4BTMux5Bx4/pne5Fzsywqpo83M/FbPi8pNosiMEIVvJIFt4fuQNTKGlpki/tkAJJwW9gYKOvYkqOOgYK0GaZcJo+6MnA0L6F3V00ABNKXI4Zs3F1gScK1pFqSrb1eFR0eM7DuZn810tMyk4KNE25Ur0eSZbeHbVrDoFPSkdCvNXvmhsybS4YUz87tsmtAXxLVLo0HEMXUb5TcP2f+cxYmUH2oxjIV2IyDgd8TxKf/7vJvHb5/ZTas/NJ5ShhInyBoV1Ph7ox6e2qHONbjELRKFDcQjj3ig0FCVXWtqphNPWr/GEwmT4Dh+qsBR1gbKy5ofGS52b4yidCTAfrNW9LJLUOZ+gqVIS1fgIQBl8RMpQfnCQANeuTULeEs94DjnapKNulBCT1zVKIDFLGAALbJQSREhs/bg2JVbYkMXV0W0kQw2nqJ4cq35c8ZRjvob/jTZ8tGLWG5ubAcQam3DKNlBS6YeDJ5FZ5Klg0bkVQw50gBZjcmZPbwABGQvUnf5dGIo9P3mk4iSeh+dge71C31peN8CA3hKvcmM+Vam3nu2IKLK8Oz2HSbNGnvbaFOCw9ZZVP02SIplLL4c1RqkRdVz9fvzs2KzLByTNZ6I4PNEkwli6vqqSyeyYMKLv/kOAJoK0mfHkW5Tr6EX/cahR54c5RuqyYM+Mzw5iIpZJ5byKNmaGtM9Sczm0Bf98CQU5TX6hX+ooOHAY6qFZtzQ48c2B18tm8n2ifLkX8q917vXqVHwhAvmGTYXxcqnRUYDvGr8uIo4WMaZK/D+092ieCEOP3LVKLTHU/6oGkfVI9uq6DDl26VuoalENkkp/c92fKegTFIAt0S1MPMVgEqwAJ7zxulB/+3bpiRTqnOsATxfqfoEpbwWaAmj8ESYW8IKc7VPqlUa9zay9J+tlYNfNwDx57gtiaObL9ubKE6mZg8GALt8L877O3kGK96xc/cRZauOsheu
 cgItqSZF
 hHgpj3E7d31n4rW+X78mwswJ1E23kIz/XMGhcVX6z0NZ+oVEZ3okbcIUxZO7dWUkCnKS1+urtJLY8kMZ+hEam7bqEb/x+KS5gSmj6ZQHpeP7bre2Dswu4mRQrN7YIhCfD4sH4ufu+p8Fm+gNT2dsXOdgVaQjIHKW3PmxBgA9vSzGAnv6ZdtHnt4JxPUz+vpKxxKCqiTfHE5FbeykmGS+xJcHogFABrKdW2jiZgYpQjHW9DoDHKj8XXLtULjZ0Ckxy1SBe90ZPUe9JarBL4kwiMMa7torUkv32SRIqOHQ1Pv1CM5uD57EV29ZcruM65EaLXu9R0yCCtW6Ygrw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/26 21:11, Usama Arif wrote:
> Commit fefc07518227 ("mm/page_alloc: fix race condition in unaccepted
> memory handling") removed the zones_with_unaccepted_pages static key and
> the work that decremented it, but left the work_struct behind in struct
> zone. Nothing uses it anymore, so let's remove it.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

