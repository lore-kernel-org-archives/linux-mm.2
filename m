Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6383CCD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 09:12:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2BFA6B00A4; Tue, 12 May 2026 05:12:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDC5E6B00A6; Tue, 12 May 2026 05:12:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACAE56B00A7; Tue, 12 May 2026 05:12:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 980D86B00A4
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:12:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 27250140432
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:12:25 +0000 (UTC)
X-FDA: 84758201850.30.596CB15
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf05.hostedemail.com (Postfix) with ESMTP id 622F610000A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:12:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A44CAG5a;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778577143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IrktwSreI4nd5+Fs73VimoFCZbSPT0Gmqe29WLI9ydA=;
	b=hg6FGLrLGcqcdlV+wj20uyCZBCm0dVZoJ7HyZ0VwRC17G1ndJCFQ5mYyqSwGzr4iMpxLZo
	oG36ZwTJ7oDZqR9d65TAYdPGs3bsHmRhU+R6gp/GZrr5ky1g47iOacUdnW2ELMYPRdMWG9
	YzXC9iRiHriBU7u/TR4wMRted2djrBE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778577143; a=rsa-sha256;
	cv=none;
	b=SOSeUfMRGJtzVm+I/TF+lHSdUGfjpBjIWpZq2ZfesbjSoYa+K3EjpnaRp74EbyltBWNfVk
	oQX4B6/DaRNCp3iFj//roY0veSPAUkdOaxaGgQH0vObineNaBpZB3oTGMQywJl7cKisVUR
	jrXTvuraMFghXBvUnadL5yAHJNOEj8o=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A44CAG5a;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
Message-ID: <ecdf28d9-b44f-494b-93db-b6f3006c30a8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778577141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IrktwSreI4nd5+Fs73VimoFCZbSPT0Gmqe29WLI9ydA=;
	b=A44CAG5aQY2MJ6w7emAua2oqA8MthDecl72KpoJkvlBOeWNU8Nl9YlcpvYihgUuQQVznxZ
	OITPLmAYlKBMB7PBVNjH4QCUHx69Ri3vjVL7mbdqM1L70HFEaVMOvKHvtY2AWj8hCvRm1N
	1A0JPha0Mhyb0YxjHGVHmNTtKE+O7FI=
Date: Tue, 12 May 2026 17:12:15 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v1] mm/shrinker: simplify shrinker_memcg_alloc() using
 guard()
To: wangxuewen <18810879172@163.com>, akpm@linux-foundation.org,
 david@fromorbit.com, roman.gushchin@linux.dev, muchun.song@linux.dev
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 wangxuewen <wangxuewen@kylinos.cn>
References: <20260512085546.368911-1-18810879172@163.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260512085546.368911-1-18810879172@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 622F610000A
X-Stat-Signature: p7h31w59qxsifzmx81bmju84n5xu7hyi
X-Rspam-User: 
X-HE-Tag: 1778577143-181664
X-HE-Meta: U2FsdGVkX1/tGjbGQsdRdaU7tmMR/kTsDotUhmvhI8ryNtWuDjNgqgLWnopttyhZumse7oG0hpz5DjTwM7BT8yI/AASPwvhDxr2PPy0eTwsOzb1y1CEX62jSyi9XUrQamdrW9OymcaOpAX1lbyOfXHR2DXnpgfkHJjSxeWKPQyb76lLFxW0WVBZGpKu/4hfbfXC8UedkOhr03FWb+5voeivPeUHF3tryVG7ySTkdNIyCGmuSXONLux+jP6jBHUEt06uR2ckDKvumJ/twU236e8ZkRXVRG6HCc0wG8To1aAsYKbQQFTVZazcEGKRGKKR72ZNqQzf5eyNBvxXx0Flt9gZqX4c7R8TFtNisS6cerXw3aUyzPBW0vMwsWQUBxRKdlUFx1F0+x36Q8hobAmxtJ1ppXMpWbUWa+UoTmFfuMNEoWMTHevuX+8D+cWXDbIzxdDo5r6vGkU7XdgAoTH8vkVZgkV6svj4WsbPsVuaGLqH7rQh1jL7G4z4sJQaSOhTisEtdxzVLH+rPUT61r5QVkDvMwDvL7sOjDDkcrXK5rOpYQl4r8/kp8o3a1jGWd0lxk2too3RqPgN8MTB6zHqk+JhSKA5nt/2tYr6HlOLUf/CtjeWSEQBtoJRprvqXInUXo3O5suK2tS9ACmua3NlEYxB+X5Xx+zSraBnKJSstTsJosNWWrIokXsjF8q/7TOz8v+Zip7DNOuIhGTXoFevC3lJyfISx7N3iGZBX2ekBaTzBo5XVMjg3P77gIgvsEaECF7OO3dQDky3eGM5VvSn7Mp0cNtDLafgV6ZeKzlPTAKu2FEozbOFuCPTgA82+f9xyF275mcQPODxkW9YwA2t4NAfcFqWMySejxleLdu9UJN5H+1pQ8vlpMsTZXh0UMph4OmGUmX/6OVVl9l23rn0ePXh1Ul63+eJUHdb7ncZ4ZRQlOgAGZ1OAHPgbBuTQaAF+5Xkek1xgIwjUmR7l3eT
 MyerSHf0
 49BN7yDYzVlkVGcFw/71oQQ9lfoAS0i49EW6YhGpCyEuslkA6nRgdJ4avdN9O99ZzfhTIPEg2d7PWPsACZv8NN0CNMZUbZwNAkOsEe45c5v9Y/R4O8OPQOF1b+7yY7sTdc+k+p2g8mOqlc2NcLgdUmhWyEuG0k4eg4EJVLdY2pHsdnhogjYLIZC5C1/WEtU4qSUJ8Ekbr5McIcze9kBGrB3n59pL4DRnIoCQ2A06NCJ22aCGAsqXC0grI5moMms9vO4pT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/12/26 4:55 PM, wangxuewen wrote:
> Use guard(mutex) to automatically handle shrinker_mutex locking and
> unlocking in shrinker_memcg_alloc(). This removes the explicit
> mutex_unlock() call, the goto-based error path, and the redundant
> ret variable, resulting in cleaner and more concise code.

I'm inclined to use guard() only for newly added code. If we were to
convert existing code, there would be countless places across the
kernel that need updating.



