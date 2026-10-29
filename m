Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E11C8606A32C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 15:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bzfuVvTM
Received: by kanga.kvack.org (Postfix)
	id 0259E6B05B3; Thu, 29 Oct 2026 11:03:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3F806B05B4; Thu, 29 Oct 2026 11:03:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E55726B05B5; Thu, 29 Oct 2026 11:03:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C1AE46B05B3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:03:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4AAB81C3BE7
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:03:12 +0000 (UTC)
X-FDA: 85375981824.28.435B27C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id A4F3CA000B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:03:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bzfuVvTM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793286190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fVWr3OM+U06uicRq1p/6iVn+dk2JPaOEC0k0vVXrOLs=;
	b=kWtwOlhrvGNngsW9EH/jlP1rDENZg1Yd3OX0CnXrr3EQav3/t1Ij+Vy/OiTHiGOpOWw1b+
	3OJMepG8R8aWTYzElzfdM5c67HTK0NNZJQ9HJVcnJVUohYe4URgh4o8AyDNBhcT9BO8Ffa
	S3XpPjkbL0pTms7UuHAKUQ7xCqdAPJs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bzfuVvTM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793286190;
	b=Q832VX6BUqo9gqwLQGlpm1EWbHXIC1OakPe36OnPkicb0KENHlWuHne71IXAo2t00skX9H
	m7B8paGeCDfsB6xZkV/0v4i+ucKNgNNioOp7M94bkDqt9Im6S5jVzBjk61D7lzQcDcYjvr
	7joU8j5wJHAbOebaTIIlOJh0wJYk4Mw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2811960219;
	Thu, 29 Oct 2026 15:03:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD771F01825;
	Thu, 29 Oct 2026 15:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793286189;
	bh=fVWr3OM+U06uicRq1p/6iVn+dk2JPaOEC0k0vVXrOLs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bzfuVvTM0M0f9XhXZZmeaUL6iJWrBO311hwhO58zgryd3MMm9nEJtRn+vvU7KPewF
	 wnINkxYdbteeY3zjAR2b0AizoGxarq4nm0pWaJaF9nt+DLKDePDhsGOBwx7azSTkis
	 1nMIyHi09/qboB2C708ArhYuEfReIZByBl8tjy+uFfWYm2CsFUM+pycTusgMEgjDLW
	 l/vRoArv7v7ddEuqiyQmf8qIONCMTw4ITtgH0HBfB1cUfO+uIdAdhpSQGIOIQFvLPU
	 GU0aLSYdoQYjzj7RHkqtklMHzxRZsVdMJmQSIva9X1u3FagbnYt1InkKvJ+ZioZm5P
	 VrmUsnC+6q4Ew==
Date: Thu, 29 Oct 2026 15:03:05 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] xarray: clear the new head's parent before freeing
 the old head
Message-ID: <auNdNjH4zo7OYbe-@gremlin>
References: <attzI4sj2Pagmvkd@casper.infradead.org>
 <20261027192014.844878-1-nickolai@csail.mit.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027192014.844878-1-nickolai@csail.mit.edu>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A4F3CA000B
X-Stat-Signature: cu3d9jrc6u5ws8ysr77rigjeou3xb6ju
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793286190-386244
X-HE-Meta: U2FsdGVkX1930YGfkqyd5QyTuN9by5rGlD4JtZgfV7/bMYhoAx9xf8qZDRMqcfuKYszxBzEu8cAE3iKrszty4s4HH8tIKCXilzwMcsAeuyoWAMKlgj/6hLRrJVSPBaQzMTDgeSAvkTOJV2F/5BGVRlTO/IsZsjCis1GWiIuOEDc4tJjP5SE5fdV6QIs63FRBYfobJKSm6++0FF+5xydFlJ2BjA9AhM0C93Mdfc22NGFQ5QGGXZDrJ0vMnJs1YFV7oYWuWTtnvgBW7gvRNPtxX1BkIiBuuMqwR3C9UAULGB0ahUi1PW4087fC2AH4VlDPR6jiNwTp0+YsoR+rzKAmEukIQAjW0ttlqubNKeQbDiC3Q33ODvn2YURGETNY3lZGtz69B4IQp2iFI1n3Oz4QaGK/kOr+XnC7cGZ0CpTTYwpKAZd51aijc7SNlkHemkIj7m1quU//6IFET9AGKkpa/VEWYs2U6CmeQsxG9vpm1jkLwPtMs7eORUi3WXaeMPP4PHD5YUafsUUFu3UfUwNaFL6IES2wV/gfoN0TDP8hVs6BBtlO0mB7ckwImNHIv61fECoFrL9NO3l7+A2mH7t13kw9KMo9pvH5n4WElvrVyt/LWQDwUF1qIDHiqP8+0+tK+C8cyEHeWvtgg/ad8bwaNTeSnRuzli2ae2kYGeUQ/DaMivaSh2fjYkQyOybaE95U0gOQMv/YV2svoZR07uZ3OobHBAu9/IoJMPQSxrdJwGCaxpBe57qbt93M2IRMB1ujSiOyJ6JDLxe9CXbMvqYh9S0HVL3NmMgVQSI8S7WnbEbuJwU1cdDm3oXkD1m+V1j6fkz76/yl2XFSCtpL5aQGEaxnNb/6BP2SG+rV7sZ61V4J4KDX/k5Jhu2U4NYmt+lW0ndcPymkq7dngIRpUMYpL4TFQ3/sbRu0ptJ17RYLEo+SZRpiNpgjuAQRsfwz2E4+Ik2lyb0HtagKUNa6KJE
 PdsPgPPj
 7LaFkF1siAUDShKgvquWqEEsu1a0aonCgiaibVE6aQHtpWzoeSh+EimegOFZtVfqbNJXOJ6CMw4l0+N3OXbeQVh/5dGOB8Zpre3gw0QHDKTKlMq+pfzfiPLAPGqh0BWf1qIHsWbFBMOmLKKi0di5lf4+oZ/W3tPVg8k0z1C1R7F2Kvod5X1AIPO3z1YVMoPEVoEB/LOCnzyoqcsLoUu/QojIWF6l5gQO3KSjF2yfYmpEthuOVsTQy+OVJK31ubo2Q9CFpe69W+QCHIM3ScLzrHbMxUb199JJrMVghoNLBsoBqD0E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Nickolai,

It's pretty 101, but please don't send new revisions in-reply-to older
revisions or feedback [0]. Also, if somebody replies to
you, reply back. You, not your LLM.

Also, you are flooding the kernel with patches, 5 series across 5
subsystems over 2 hrs:

https://lore.kernel.org/all/?q=f%3Anickolai%40csail.mit.edu

I already asked you once to stop doing this [1]. You've carried on.

This is not how to engage with the community. Please contact maintainers
ahead of time and ask 'do you mind if I spam you with slop?'.

Only if they say yes, carry on. Yes we want bug reports. No we don't want
people like you running scripts without permission and sending out dozens
of patches all over the place.

I'm sure you're acting in good faith, so can I please ask you to engage
with maintainers instead of ignoring us and treating our time as valueless?
Thanks.

--
Cheers, Lorenzo

[0]:https://docs.kernel.org/process/submitting-patches.html#explicit-in-reply-to-headers
[1]:https://lore.kernel.org/all/atYQW_lfJdRZnU_n@gremlin/

