Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22520CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 01:58:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B0306B008A; Wed, 24 Jun 2026 21:58:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 161176B0095; Wed, 24 Jun 2026 21:58:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 050DB6B0098; Wed, 24 Jun 2026 21:58:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD7876B008A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:58:28 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3E98B1A0518
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:58:28 +0000 (UTC)
X-FDA: 84916775496.29.45AA11B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9A5961C0005
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:58:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lVNMmqT0;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782352706;
	b=lzVQ2aezYrePgJsFDrq45mjqHpeGtD9BWIKfQxFZ9w2NRAEuCfFeYoabDLsrPTJ/7hGe+v
	5SKZGDRDCSDignyP4bfRsvPpcLPsahZofcrM30LMgNa1yXJ1Mu0dvblo18zJiGDYeLt5lz
	oY4RxgEpI1xTwmel9sA2VoHa72eP7wY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782352706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wQICN80wmISSO42bSj3qCDWDRspRJwLjGgDPUT3kM1A=;
	b=Y5MPkuzJ5AhFdKgIEqZKfTMNNa2rDvsfiFDwY1cytdsOS/oOqxOCox8FSjgQ2X0G9NqG/U
	HvJJOYDk4ka2elt607ECThHKGA5SmVHYlQxX3cT3DASUHsh7LGv2OkOgf/MZhfiKQrtTeD
	EbAvGze3sH+yR4XxYOjHpKUV/afStkI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lVNMmqT0;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DE30660018;
	Thu, 25 Jun 2026 01:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480391F000E9;
	Thu, 25 Jun 2026 01:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782352705;
	bh=wQICN80wmISSO42bSj3qCDWDRspRJwLjGgDPUT3kM1A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=lVNMmqT0XJQ/hWnrAroEdYQPCRMflmMYlJJ87gyKUWoEujRoXPoME7VsQwMe6fc35
	 lLoN0jpRo1RJBMuBNT7Hh4TgVEx7h9mwyOH/E/6xvZ6Mm8vcofKSs37oFb6sjLfToq
	 qIDtHT4Da7EKLM7gL2MOpteO0AGVCkumo3Ts9UMs=
Date: Wed, 24 Jun 2026 18:58:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Hui Zhu" <hui.zhu@linux.dev>
Cc: "David Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes"
 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka"
 <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, "Hui Zhu"
 <zhuhui@kylinos.cn>
Subject: Re: [PATCH v2] mm: avoid KCSAN false positive in memdesc_nid()
Message-Id: <20260624185824.f052e7b8f97ee20794e476aa@linux-foundation.org>
In-Reply-To: <20bd8bbbd5a8cc52d267f550fc0314cd0d81a223@linux.dev>
References: <20260623084432.701120-1-hui.zhu@linux.dev>
	<20260624140104.eacc15e291eec123bc7b3349@linux-foundation.org>
	<20bd8bbbd5a8cc52d267f550fc0314cd0d81a223@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9A5961C0005
X-Rspam-User: 
X-Stat-Signature: tf5uj85i15xmfzyoek7cd3sfmitk787q
X-HE-Tag: 1782352706-525146
X-HE-Meta: U2FsdGVkX1+ET/TWr8Uld6tXtqOsE4rBcWDcyjzx/vOTotGXXIKQjQAJbnjJLSY/o4qztNjvFgpzzILz7CF7uIT79jE1Hj288X7tkluDW8V/Hy1vSgV59ZL+Nye0V76OER2OSE1+rht33LwmYr9vPB4OzyN/lKV05zH271NPVblWkiCdN0xAMvrsWSiSdgeGYNkeXJ+RqMimvlO2qIyRh7XO0ywzmlLw22Tq27aoXbnEC5G0GNJX12ufakbOaWHDBqJL64xI00A5Ut9Vq8BVFFy4d80IoT1FgSpJ6mDXXOP44sh1IODflGXb7IPUHP8uqCNeC1dkzwC8h5YbKKbIKm8R4sN2/hEgKU7+n92HKsH3pbkugG7dzo//FjN9F8aDQwAS1CwN2+Z2VXDEZMRzljKkW5rW41aXX8cgBnRLrz84esNqyMeCn11VU0cd4A+fwGSb8PwIyMkBsH71DOSEnVPoHGUaU1Mk6WBtU9eKp7kkQgi6/2Axg8BWRajVqhAb2JJm6V+KsnAV+7IkD+Rt+zH0klGcwLakepJpFIAMw2xeOdwG8ieS7VPbTZ7u7I4iStRXJF3bjxQnsc7KZ6j/rB15c/TpHFbnYtTnXq8mLwzbAC8cv+DwjcMXlMsZVmTSjWxC+ptpCYbZy2X4JmBZVu13beUZQbSBQcrqpRFF3Tlg+lVCzQYVDb279WvvseRKUZVT7IylOuryNkabZ6olXND8bM5sL3j4jMlXcEdk6NHZRFBzet+3kciV1DE2aj0qdRXgdlo0Ep8nK9b7Cg4YIXFJzjbRaJEYfEPPPTZ0LlLO4bKGAQUKTjIFFNOZMOpmh4Ewa6S/stisVwH/zzcM6l0N+i3ck4Ygqpy4tXCO0QZRsg/tc2IzS8HVn6Z64QAGHeBJImiZggmj9YZ7gtrtVZPlrC9LXITFkU4OCq1oE8k6LYe/VejeHfviTRLIqYT4P9ZeuAR+kBQytu/OnhW
 3APsghq0
 RvHvxuX4heKzOJyLHeLSKNWQA+vjIOnY2XkSQL69VbxTZfFDjd6vnoWQn152t+z61ByW2eA9QuL8rEU3tL0WeYqMmYxRU31OhtoWiBVAhgXikIqQRfxKWbsAYYIJ2zHf9Jij2orvbwm6ZrSvJN8bDCLjtj6voqNbdP/aewziQw32LtECqZT8Alqz1GwUS/E65pEQ93qWeXWgq5uGQrlbqYvqwWKMYBtKk357FnbH0uLysCRIoL2kZIQ1ppV19L2VxldkNNKvEA10l+2/wzl+2p9WicqqauDLYxvi5jv5TP2oKvuQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Jun 2026 01:32:49 +0000 "Hui Zhu" <hui.zhu@linux.dev> wrote:

> Good catch. ASSERT_EXCLUSIVE_BITS(mdf.f, ...) is checking a by-value
> copy of the flags word inside memdesc_nid(), not the actual shared
> page->flags/folio->flags being modified by folio_trylock(). Whatever
> made it appear to suppress the KCSAN report is likely an artifact of
> inlining/codegen (kcsan_atomic_next() happening to land on the real
> load after inlining), not a principled fix - so Sashiko's pass is
> not reassuring here.

Yeah, I was wondering if the inlining accidentally gave the macro the
correct thing.  Which seems wrong - an inlined function should treat an
incoming arg purely as a local thing.  Maybe we fooled the compiler.

> I'll move the assertion to where the real dereference happens (at
> the page_to_nid()/folio_nid() call sites) instead of inside the
> by-value helper. This probably also applies to the existing
> memdesc_zonenum() pattern - is that one actually verified to work,
> or does it have the same issue?

I assume the memdesc_zonenum() code worked, for the same (poorly
understood) reason as did your patch.

Yes, moving this into the sites where we officially have access to the
shared storage seems the right approach.


