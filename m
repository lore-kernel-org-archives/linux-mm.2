Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0EA0103E18F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 14:30:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45F366B0256; Wed, 18 Mar 2026 10:30:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 436E86B0258; Wed, 18 Mar 2026 10:30:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 327216B0259; Wed, 18 Mar 2026 10:30:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 231C26B0256
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:30:45 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CD6EF1A07B1
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:30:44 +0000 (UTC)
X-FDA: 84559420008.01.B1B8D29
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id D6B3A40017
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:30:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m8fwNDjF;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773844243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MjJYI73KRUyiT7R5JT62KvQuMFR2WXwTixv4//GgYYs=;
	b=HuVdEryM39jvRbqm2pHUFeMhTZCvEe1CrP6B5RGCfSDHlrcLKu3pNRYMcjogO5+yjNO3o3
	KRW9QKW/MOTsVC+zIgUlQeK/ZuZmi/4UkVfLShGER3hYBDe6arzgceEAatXQMj01BPNKGt
	q3r5J2e6b0E54DVr8V9k86vcrjHrck0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m8fwNDjF;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773844243; a=rsa-sha256;
	cv=none;
	b=NiK9HxTVGo86OL8L3M23hj39Unt4Y2sZS59u1rcW1WL1llRnrJrf+4f3EppirFHi+rxaqr
	hUGwuRVBNF7PslS/e/5zCRuEnjYsUvRwv0IDrxWXrqQG8BjCZSae/GDWtpZmvLKXkd4EVI
	naYq+3xvD5ZiKhEFUYa0OlDP2YLEhlw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A05D417D8;
	Wed, 18 Mar 2026 14:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52293C19421;
	Wed, 18 Mar 2026 14:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773844241;
	bh=Ln6LT7iFsbHfiIGSe26VOTUzsYHtrwok3OHHecWCI6U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=m8fwNDjFt5Q32cP0ZpC20xuraNT5i3GesrdVH3EhZcR70UzJXuxfLoxaaUUWOJ77/
	 Q/biyjU+dJIfdsDTbN7Ktb+sIeUQliA4lKM/YLG8Do2vVeEHoJfzYnfBVImGHuUIDE
	 WI+52JNbFmGuFqLehWCmP7U+b3dfkAQ/32brMrNYuV7Jhmn0pFa6nwb6XWmM49sMig
	 o7Nr7xr7Aw9Kt1EjIw/pm76UAC9Pf2kYbvRSqm4vKPx8JvWLCdQPkBqKg079yyq05N
	 M6vtlNdccukKeHCrQ8uHPq/T9T93tyj971CWSOL/VHOZh5/47rrHsEdql0uzzqAohV
	 +wO/45aCvS0Ow==
Message-ID: <70848e13-b272-4a46-84b7-d5f217f82be9@kernel.org>
Date: Wed, 18 Mar 2026 15:30:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/pagewalk: fix race between concurrent split and
 refault
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 "Boone, Max" <mboone@akamai.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20260317-pagewalk-check-pmd-refault-v1-1-f699a010f2b3@akamai.com>
 <7ded426a-0cb5-437b-9634-8d806b704db6@lucifer.local>
 <719CB417-F511-402A-91E3-8A696ABCE0D5@akamai.com>
 <789b4585-7542-412a-b9ab-3f7de8d8dc89@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <789b4585-7542-412a-b9ab-3f7de8d8dc89@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: s6ryrwih3bhgnmi893kw8i63jamkmgq8
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: D6B3A40017
X-HE-Tag: 1773844242-568976
X-HE-Meta: U2FsdGVkX1+UyE1NHfhNJ1ULmI5DI/Z7eJBz8aQTwunAR2yQ8SRTJoGvHh6If3wDJiQHOaBDQM0WB+DxWwgblSRR89n5L/3Qx22UDBIb96sTSWHcfuA7jGfTaQvYJO+NkWcoi1yPx/zfMCkNckLhytwQ/vQLcU98r+JCpf0AEbSE2eaCsZuacqBP9AGbCZIaQArMDiJtX2RTGMBQphATMEqJooSiRi4q3hXORG5j0fOauIRW0RpWYVWL391GPEpXJpnr4nY9hD1TJjgts7So3htS071YybQyJfq1wdPJIfS9ZOosnTQlhpvtBaHHpomx5pkclPW5dqkEdLv9YOIc2Z2NwQ1xqvgB7s4qosKV76P63ORWrOuTkDLT2x0mHHkwFrs0zyh6KIUC0zpI1/29YLdMipmzIn3c5V2ZW2fc6H/60EG4D5guSp7kpbC0BXPONf3KaJp9mpY/+LJ03NYTwBZyBXz6g2etcYERX86JTVn1QbZYG4VQXfdBw5qz36B97u34WZ5NGAK14tsqoS8wh1cYuJP6HbkU4YJ00EedHtwaRy8by0xJovB7UOEsOmESDCRwi04a7yHKUkbOxWiDfmeoPPk4IeGD7hZhEsV+kQpghwCeZFG7N5D4ueoBOtQ/GDZOLns/JApMaGGoI0CTCDAUcj9fVxAOW3gMfM3qT0IlMcQimvPMZ7J/N6Aly1JfWfOWHdmRnZlYmP6XV1d8MtWED3YmJQwxSBlCv9V6rJbQgSUISSL0AzupbHWjrDD82d+WgPJNI9b8wjP3dFX/11BvTZV01j9aIQrBi769FvYwacb3AA2cOAz4duKPn/d8IM15mikklPYlw5e/lfgqZGrL8Xi/U9Xp7Q/zw0Fr/jclFgkx74GGQl5IL0PSIPaTQcR1w/YdruWK7JzfitAvrRe6GflZ/gHfI+JNQPJcwQWnkJ2DpMw93CWq4+FFG9s0UdZMsfbkSOr0M8OKrXs
 lKsCfkSF
 ohT0HZeCEFnixMWqoEcxh+9SinMtmKW83Jvn/F1Ku6wUH/hgZtN6XrqB/sdocANCJvgSm1f4Em7wDK39mzWAK50ujLtJUNiZSLJONDVO6Aq8RCJqQlOXc2AkSgaOTePqZJq825xsnsbdtSd4Hi+Ad34KVSX3vb/28xAHhAb1qBivfYpXn31wgImK1y4tlerZivTT0wdLfbqe0OSxchE4A73ubmMuhwdc+naBdJul2dzwIjilp/5aAcVgOnt31uEB49LbvPJZBwjD/QbBge94oMAEVD6MaQdEPcQrlmsM6ddrYBg0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>>
>>> Yikes, really? :) This is from 2017, I'm a little surprised we didn't hit
>>> this bug until now.
>>>
>>> Has something changed more recently that made it more likely to hit? Or is
>>> it one of those 'needed people to have more RAM first' or bigger PCI BAR's?
>>
>> Yeah, frankly, this is the first patch where I could find the splitting being introduced. It might
>> be more correct to refer to the introduction of 1G huge_pfnmaps?
> 
> Yeah maybe that makes more sense? David - what do you think?

I'm not sure whether DAX with PUDs could trigger something similar?

-- 
Cheers,

David

