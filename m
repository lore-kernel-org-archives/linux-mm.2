Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82DE2606D80D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=leemhuis.info header.i=@leemhuis.info header.a=rsa-sha256 header.s=key2 header.b=aYIqX3pq
Received: by kanga.kvack.org (Postfix)
	id AC2806B05D8; Tue,  3 Nov 2026 03:04:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A52586B05D9; Tue,  3 Nov 2026 03:04:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 912F46B05DA; Tue,  3 Nov 2026 03:04:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6EE1E6B05D8
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:04:37 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0E070A7D51
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:04:37 +0000 (UTC)
X-FDA: 85393070994.27.63A11A8
Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [46.38.247.119])
	by imf16.hostedemail.com (Postfix) with ESMTP id 820C2180002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:04:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=leemhuis.info header.s=key2 header.b=aYIqX3pq;
	spf=pass (imf16.hostedemail.com: domain of regressions@leemhuis.info designates 46.38.247.119 as permitted sender) smtp.mailfrom=regressions@leemhuis.info;
	dmarc=pass (policy=quarantine) header.from=leemhuis.info
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793693075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L4EcRlcPTyEkbIxRjhXJq9ZXvdXvVbjjYlySVR1wKYI=;
	b=s9Y1KmabXR1eTOwKQ7iq+jOfSjFEOFKvepTGt4ksL5OP2u81A9pmpKO7GhmBXp/yU0gAep
	Tzj5NHenhPTa99mZOXMZPM2zH79iazmIerT+EA6KUB+/W1RPYy/0wSJQMUUwknPvEuwlN1
	eso9GiquE4sOnb2Wf/I1uzyBieIpC2g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793693075;
	b=WS7stLsBbvbvONO6s6upXSP4aQKDlxucC7WnTH+RjV5zvTOFb5prr8rgKzRPZH58iKwcAu
	sLhU8rdM+OhUnm1hLoKB8NrU+1O4c9LoSBpQTpAijI3uDXOyHa6f3IpDLptQRYzkGRphj8
	avTBR49JAe9MrCX794McCUH/NwMsu/w=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=leemhuis.info header.s=key2 header.b=aYIqX3pq;
	spf=pass (imf16.hostedemail.com: domain of regressions@leemhuis.info designates 46.38.247.119 as permitted sender) smtp.mailfrom=regressions@leemhuis.info;
	dmarc=pass (policy=quarantine) header.from=leemhuis.info
Received: from mors-relay-8404.netcup.net (localhost [127.0.0.1])
	by mors-relay-8404.netcup.net (Postfix) with ESMTPS id 4jJh1W0RNxz8RZt;
	Tue,  3 Nov 2026 09:04:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1793693071;
	bh=yDjkuQhj8wqQW7sNON4Yy0/wXIldLBtFl12mMAzBTUA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aYIqX3pqZYRHgMXt1cl5PXhWOkl92PXD2HC6hwfkeTj6/5x0BIS58eaWF5pxMqatX
	 TVnSDqeCxgty+xcfflRxnG1ulNDV9QNGlCz226C+cE4OTYTa6w5FTdhjnKiaV0s8vB
	 9qt0yQ9MUlmKrBP3iyKHnGos5cN2NXvHDWS00056tenzilh0S+eC1VDxPrRBaP4ZT9
	 4vch9kdtN0QLp1ainTkmtSOM5Pc9msZAPwhv6ZCLIkdA4P6YpHC3nuwMOV7jlX8tA2
	 Wc3UVSBu6somilMB5IHRejzUz4jbtp0robDXbjk5Nohm8zHx37er5dizXinX/r8D1B
	 9n7yKqY4L8Vaw==
Received: from policy01-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-8404.netcup.net (Postfix) with ESMTPS id 4jJh1V6qskz4xJ2;
	Tue,  3 Nov 2026 09:04:30 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at policy01-mors.netcup.net
X-Spam-Score: -2.898
X-Spam-Level: 
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy01-mors.netcup.net (Postfix) with ESMTPS id 4jJh1S5T0Mz8tgr;
	Tue,  3 Nov 2026 09:04:28 +0100 (CET)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id 5889D5FA02;
	Tue,  3 Nov 2026 09:04:17 +0100 (CET)
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <7a1cb587-7640-4da5-92d8-57553fd00ca4@leemhuis.info>
Date: Tue, 3 Nov 2026 09:04:16 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drm/gem-shmem: Install writable PTEs for write faults
To: Thomas Zimmermann <tzimmermann@suse.de>,
 Sergio Lopez Pascual <slp@redhat.com>
Cc: Maxime Ripard <mripard@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Andrew Morton <akpm@linux-foundation.org>,
 Konstantin Fastov <kfastov@gmail.com>, David Hildenbrand <david@kernel.org>,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, regressions@lists.linux.dev,
 stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Boris Brezillon <boris.brezillon@collabora.com>
References: <20260804140403.16337-1-kfastov@gmail.com>
 <20260804162924.0268f80a@fedora-21.home>
 <CABWhNekebS6dt=Ft+74iG4YpCq-5ZcV1EvvERNxT612VUOC9Ww@mail.gmail.com>
 <18f0bae1-5cdb-460c-a147-33cd1fa2acdf@leemhuis.info>
 <CAAiTLFXd=LK93e=f3PE1f6y5m15yVknqqVNBei5rLz2AnSJ4pQ@mail.gmail.com>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
In-Reply-To: 
 <CAAiTLFXd=LK93e=f3PE1f6y5m15yVknqqVNBei5rLz2AnSJ4pQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-PPP-Message-ID: <179369305797.899839.5052632304350013051@mxe9fb.netcup.net>
X-NC-CID: 7sMBmLbKDQp9r384H0I/4YWHJCS0kWyZfxMwgublF8WzQF9lEXo=
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ey9pukyjprpxogyri5hjp63ri5qzu98u
X-Rspamd-Queue-Id: 820C2180002
X-Rspam-User: 
X-HE-Tag: 1793693074-993791
X-HE-Meta: U2FsdGVkX19KTHyg2q+a+6lRSDaXXYc5iaHVUgCkqEuOwikEMO4ao4CnMS6oKpwBRgOpdWtJFwGuUuWZQWNZcIcFZEjki2qU68i04vhRB5cXvyJsfknE0Lu5cC+fSCHLE9N+3ieQamGYeBbzBdnqEUBjjWln24KPTWeu1sm+DqbGRRZpZVeCHUoSVzHc/fYU6YgPFp/u0Lvg4CMduBY5zS5WXdwheTFOHvKL22dvAtvdtzpAzfr2gqjMfVtjN8Qtw+do0mhnNI3/8rqrBu6z1r3aqeKc5JUhJkgkSkUblS15IrtgEqiQk5WX93GMdPnkphN3VRd6BjT4J9GeJ89Ik2QFxpB5ZUuSFXBlv3nUAL1a899likH8fzCn5W89gwNxIt5e1CcPSdz6/PXNCQ8x7EsOhxG0lo9L8gW/xlkjpxdkk5Yj1OxDrGWZy8dnlviKF186FdfD+kM4y0SLBg2wiY2ZBdFfHnB7yWO+JBeaHGvPkJXBxckIx63qVKeF2NSwHFVjQJvcdN0K0o3hZBebvCJKe5qa1D1Zqg4GqhNdSEepw2cixVWnUgN+jLF6U0i9Tdc42H9QcNRDvhr6nqe/MBSGeJ5LxFBcNy9b8I6uLagdiU6DW5n+xJLylgk5HDnlopE2t51OWsayanpSknzbS7FqCl8kNE7RGviBG9Fzx0xEYdJniwV7w5oWWHtfpJDD50Ivms+I0lVHZZs1JAmARg7vnPLp2PjveL3/SIM6sObZxByv9bF/lwrTIBOxLFwSrG+Stg7UoLQ57VHViRiFc7+ANTAdtDmRGMm1zZ0QDBXGEQOVpS1ZfOGvu2lqxThESHAYejEQ+Sg8MQX2GZgzOde4YkURYr8zs++EtHC4rt3QPv9w1SNcLF0LkbXO0sfKnvpn2sa0z5ogD0n0EOiR4IUXydZ/PA4VfA05iVwa54QSnoX4D/iT33nwUe/QmOEzLZICaCUnAZDyz8ZiDgi
 a+lKrpaA
 BOlEpUvGMfl/XzQMWDmFBo76Mcm+XvtdjAfBdkG2nBWW88C1JT7jhgVh8wiu9eQEAShhO7PWwZdapZVECqse7AnRMo+KRh0K3xZgNgU5FbQFaL7VEm7Od24bziaGAUCLQQgtFb2ii1NrN+7BGUa24OdaIpNz7p5dyCrfrlxoAiQoqnTxbD8uoyrh7m3ci8Qs4wQ7WthJUestgP1eGP4K5tIuZHskcmz4lnMkahBIB27tCACFA8bpYSLfwXgfaJOWEtVuQL3nllC64TAmQb51SQ/dgXIyif5f8DIfeMClCQVURujcpC8tPoQmYZCueNfGW4pzbEXK4N/Ht7EZR3i8mB15PbecfEoO/w/vNR3fU5b2SQlXxbFnWlyJZ3m9d4h4Czm3UNd9qRX64nyDoiaDnNehdVE0rGcsvqphSCCS7vpATbTGHB+2VOxj9KfxRF9GZ9zT4y5aJ+YIXR+mYy7ZlNldHNrdnb3vp2MgfV0y1G/eXHU/QFJR5UcVjdxNblW7I+Rv4hlnoIILTWAL1HAiK7XrksoE3UvLzO/SnGtdKBWSERkwtLl3Tp79d1AMmrKi/kK3t9A81EZw1/70=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/29/26 17:55, Sergio Lopez Pascual wrote:
> Thorsten Leemhuis <regressions@leemhuis.info> writes:
>> [CCing Paolo and Sergio]
>> On 8/4/26 16:57, Konstantin Fastov wrote:
>>> вт, 4 авг. 2026 г. в 17:29, Boris Brezillon <boris.brezillon@collabora.com>:
>>>> On Tue,  4 Aug 2026 17:04:03 +0300
>>>> Konstantin Fastov <kfastov@gmail.com> wrote:
>>>>
>>>>> Since the introduction of dirty tracking, drm_gem_shmem_vm_ops has a
>>>>> .pfn_mkwrite handler.  Its presence makes vma_wants_writenotify() true,
>>>>> so vma_set_page_prot() removes the write bit from vm_page_prot of
>>>>> shared mappings, and the vmf_insert_pfn() call in the fault handler now
>>>>> installs read-only PTEs even when serving a write fault.
>>>> [...]
>>>> The same issue is being discussed here [1].
>>>> [...]
>>>> [1]https://lore.kernel.org/dri-devel/20260804120529.1730187-1-pbonzini@redhat.com/
> [...]>> FWIW, it seems that series takes a while to get polished and
mainlined:
>> https://lore.kernel.org/all/CABgObfYgZ87%3DW%2B6E%3DN%3DWwTuyYkaoKU3hqd84JDTSAvT3_9dh6w@mail.gmail.com/
>>
>> To quote: "It ballooned a bit and getting acks from everyone involved is
>> hard... Either I or Sergio will get back to it."
>>
>> Is that something you/AsahiLinux/the world can live with?
> 
> Asahi still ships their own kernel with downstream patches, and have
> backported Paolo's series. But for the rest of the world this is pretty
> bad, as it means anything that requires virtio-gpu with blob mappings
> (venus, native context, etc..) is broken.

Thx for this assessment, helped a lot!
> Since the proper fix is going to take a while, I think having some form
> of interim solution could be a good idea.

Sounds like it. Is there one that is in reach? Is reverting the culprit
from Thomas and anything that depends on it an option? Boris patch this
thread is about would not do the trick I assume?

Ciao, Thorsten

