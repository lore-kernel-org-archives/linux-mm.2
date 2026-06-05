Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFC71CD6E7B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 11:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D9556B0093; Fri,  5 Jun 2026 07:13:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B1486B0095; Fri,  5 Jun 2026 07:13:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EDC76B0096; Fri,  5 Jun 2026 07:13:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 43E6B6B0093
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 07:13:56 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DA6E1C16CF
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:13:55 +0000 (UTC)
X-FDA: 84845599230.22.55CF756
Received: from lankhorst.se (unknown [141.105.120.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id ADEA9C000C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:13:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=lankhorst.se header.s=default header.b=CEexm4Sd;
	spf=pass (imf28.hostedemail.com: domain of dev@lankhorst.se designates 141.105.120.124 as permitted sender) smtp.mailfrom=dev@lankhorst.se;
	dmarc=pass (policy=none) header.from=lankhorst.se
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780658034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2KAk5fsVGqt5HRP4TAQleYj/TjjN6+qkBGxgDqlgfD8=;
	b=qhvzUaRSQCYbPWlOAsG5A6r/SyFqGTroYohdWiE0D/VEN4COmYt1HysTp2LyXXU6Hvj7mU
	A54Ubj85LOctYVuqGt4tvBbfOIh6WcT59TEE3my5Nd7M8eLaoLJZZF9PmlaeSmc47uI2Ag
	Mce4cem3295brSMr1Fznr+qi3HUuayU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780658034;
	b=osYUFPVBG/dzAs53YrDDeYeXGyNLpf6+B6VmtLybsojhZorl6Ip8CANB/7EKhNKxT7NofF
	EhHu0eJgr+cJkpIg309ZOCh99JTcqmpgnssMRTbbg1mscSJqa3pc9kBSfhlYapPn+znbU7
	PAoNa7BTd3cnGwpeg7G1muyB0ATC0jU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=lankhorst.se header.s=default header.b=CEexm4Sd;
	spf=pass (imf28.hostedemail.com: domain of dev@lankhorst.se designates 141.105.120.124 as permitted sender) smtp.mailfrom=dev@lankhorst.se;
	dmarc=pass (policy=none) header.from=lankhorst.se
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lankhorst.se;
	s=default; t=1780658031;
	bh=ZMIjWts6XvJ/jhRFZHvdvlkNH+2yiGMbLQW8gHV1kwM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CEexm4Sd9mFFbUW90LsMcO3+Mj3TbO0dZyBWnLyaExoVg9Nx4w1NiQFwerSK7AEVa
	 pUXW/dRqapt1pg4raMvsX2k9eCYQSgtFEOKWEb9pGTWBgSM5Hs/yVt30aCOCUE8Icq
	 0kC64phG1c1l0dR5LD9hwJlb8JB/eo4Cg0MqJoG8CowI7XJO5RoJWSJ3BuFmgnN4ty
	 CM5A9c8bml2t/C9wrJ40Ovyp6RZjK/KLrbv58d/4Gk9eVJdthXa/losttEAXScNfCt
	 i2W5MmIQCrs9H5ctSLwh3MsX4BwuSISL2e96oeF0Jr8qxvZ0bVq4sAzbtpCPeTxOdJ
	 BK59XHVm4B/vA==
Message-ID: <fdce637f-703f-46d9-91ab-05fe3728393e@lankhorst.se>
Date: Fri, 5 Jun 2026 13:13:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] cgroup/dmem: introduce a peak file
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Maxime Ripard <mripard@kernel.org>,
 Natalie Vock <natalie.vock@gmx.de>,
 Tvrtko Ursulin <tvrtko.ursulin@igalia.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 dri-devel@lists.freedesktop.org, kernel-dev@igalia.com
References: <20260514-dmem_peak-v3-1-b64ce5d3ac38@igalia.com>
 <ahCISfTlN10gD8e6@localhost.localdomain>
 <89901220-0a43-4668-9d20-aaecc72c58dd@lankhorst.se>
 <ahmOBo02TA8u8RW2@localhost.localdomain>
Content-Language: en-US
From: Maarten Lankhorst <dev@lankhorst.se>
In-Reply-To: <ahmOBo02TA8u8RW2@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ADEA9C000C
X-Stat-Signature: 4m9tp7oiet7hn6cgjeaejkp8oxb9uphw
X-HE-Tag: 1780658033-978422
X-HE-Meta: U2FsdGVkX1+E3LYlYhFpObrxZHsfUpLVe81RdAr20aL25se4fMPCrp/na2WesqpV9xnVIjdso7t8lq/0EXNm9qzUedB9MATKNm3kJNJLNz5ei+66RirmGzzV9oxrPSocxi6Vf9O0XI+PB1FZto0nd5PUpOE4f6A2HXIREtK+QFzs90IkpnHPMXwjdzysWrgyCOr6b0KtB6PKtzjtFHucQu8AKR56GoXcuyu07f4dERrSNCyU69j5P9zc9PdbQwHIcSkQZc3wrK38gyt1ruIa30ByQCAnSqDowNkyjhNbPBnaopfRuEBFG5nmAfg5DCrdYeEyRB9bvqeCxz/k8TOTtYHJVshT9DSB4hDGb98bjt6aYIego1CnRAB3FRJusfMVQhpoweLNzH9gmEwaqa5kZwaZODHLhtfsdXATj8rJLPB/rt1vw6p4dmr+mqZr2yPgkQw9D7IcZb0qdhrpIwFpQtV900lSCPcKFiceYweELjXDIqdJreVuTpOgnRW1qj+++ARgqt8TZTNXs3o0ezdke5qpv0bKvB2seZwyIS67MkiCeB/B39nHqeh5OG9l1CwGxSB4ngTrGp58izzc3u9RNK9b4snozr/VD+TadLOwe9p7+MyNI4IDLNyXEulmE0lag8PJxkZPIDveoQpkKVHiO39DmF66F6fTrS2v3qBwvkEFgWbz+DDyrGHAfC15Z1qUGCuUmS3l/ytLOe0d1rJZlAQgYCeLA/7vs1xVYNW6KyBLQ/Hopxcbsx1llSkXgzVZ56vz/nyZPQlY8yfmRiiAhMIwCkaV9i7lIw84RQyYgwJeKgCPPqg7e32wnf3QIEBhOgIa0gICcOsNYyMRsoL63glUc6RDVedxMW7H3Sgq9NM/VJyVon4c47y9OivEg3kW4UNAYCz0NAIZTlXIjwy8PpXBIHWN5/ePdE3BOAPJOvsry15RHVx2JhBcP6Uu8XG/AYvd1gTPa5S04k8j2BQ
 eGd+obcA
 P0J3nNCQ32a3qHaCL3XdHLnVDxCbBjibzoNCG3bSbud7GPI6hw5sjbztmhkHQZOyBIDMHwxxO8dJ7rfpKUI5Eyou87++YBKptMqiPY996Gdpykbidi5kiNaKZIpW7qujK1ZFfiHHBw9EJe+QYRsJJgqJJJNT5MP89THF9qJZrabJAulH142zTPAQtzG7G3X8x2pVQQupAS6JoZTUlLvf3AhPRU4tArVUkBOyaouAbKy3Oon+vfUcWm523AXDha9goE3ey
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey,

On 5/29/26 15:01, Michal Koutný wrote:
> On Fri, May 29, 2026 at 09:34:28AM +0200, Maarten Lankhorst <dev@lankhorst.se> wrote:
>>> Reviewed-by: Michal Koutný <mkoutny@suse.com>
>> Reviewed-by: Maarten Lankhorst <dev@lankhorst.se>
>>
>> With your r-b it's ok to push it to the dmemcg tree?
> 
> Please go for it.
> 
> Michal

Thanks, pushed and queued for v7.3!


