Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4564C606A320
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MwczF84H
Received: by kanga.kvack.org (Postfix)
	id 64DF06B05C5; Wed, 18 Nov 2026 09:58:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 624426B05C6; Wed, 18 Nov 2026 09:58:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53A7C6B05C7; Wed, 18 Nov 2026 09:58:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3064A6B05C5
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:58:34 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BDDC3807D5
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:58:33 +0000 (UTC)
X-FDA: 85448546106.26.D4E3504
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 04B4EA000E
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:58:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MwczF84H;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795013912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dqXB8FmYXoh4P5N1qFhBQvWcpQxSsM4l3kh9IdnzUlQ=;
	b=6N1D7hdRjpyB9Z4hToBuDdUC/nY+wGo+yYtA/7V9nXgFt2wY98rmk4mQ8diH/yaz0WD3Sm
	IpdXZJRrVvPsJKAcqDPtuPQWClURKjcx3qxHO+TW4jJmKg/K1vNjM7BA1u0exJO9zSHTGH
	Zcyfd7qtDUuE4EpaGoAvW5nD7L9hW38=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795013912;
	b=vb9uXRP1ikptxVcrlmuMzCJohvGap1yyZqFFKp2PzIzG7DB0rU9oSm6t0g2p2AFUA3pzBs
	nzzv/Zshu/2pS06o2MD+2v2Flo1I1tBz78owBh6DHVgdL/dk79iXNbE3zweRgbiK+cMmDg
	newLy5Hct0qUyY+TqFVEVnJFJS/eWRk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MwczF84H;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8B71B6228B;
	Wed, 18 Nov 2026 14:58:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8851F000CA;
	Wed, 18 Nov 2026 14:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795013911;
	bh=dqXB8FmYXoh4P5N1qFhBQvWcpQxSsM4l3kh9IdnzUlQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MwczF84HRC/Tm8O7BleU9Rzm7eTKd1mAUcYLg+rg18w8/Hj1kVcVQygxks50kuwC6
	 nqoXzSWz73Uk3svnZmxqh8rMzFfjH2LVss8qripXZbTz9Lk5gAYleVKN9TALNz7lCK
	 utwzYTNVgpYfetpclic7aKiz7o1u+gNUnXUpDPfqV3YaXlduVprJnpuD7SRlR6YE4J
	 Bs8D135YjF7pdNdl568PSjzT/rhYmk5S+5/50c44/o2S2M9fLgGituuEmPtVf1J6R0
	 8XbykaRP/8cKvrROM+55gloV9MoF9KY0WQ2aVR8S819EX2sdKsiMXyluW5LrdP6DO/
	 1h1xRHi3StNZA==
Message-ID: <5879c785-d2f0-481c-8fe8-5cecaeca0071@kernel.org>
Date: Wed, 18 Nov 2026 15:58:24 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm/memory: merge __vm_insert_mixed() into
 vmf_insert_mixed()
To: Sang-Heon Jeon <ekffu200098@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 "Jose A . Perez de Azpillaga" <azpijr@gmail.com>,
 "Liam R. Howlett" <liam@infradead.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
References: <20261002160535.661399-1-ekffu200098@gmail.com>
 <20261002160535.661399-4-ekffu200098@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261002160535.661399-4-ekffu200098@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 04B4EA000E
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: z8dj8po5i69tm3nyqrp46zt3bmw4p77u
X-HE-Tag: 1795013911-998302
X-HE-Meta: U2FsdGVkX18bvUt9nJ4Z8GLun2VrTjockr8hmr2eYjVQJ//3dMWEDzAL5zqJs71D798Vgv0yvG4BWrZdf4AEKNYktVl3Qy5Z2pMMMO9Kh/V4Gcuxvdahpd/lXerPiHkCz5IuTUFFrbTpYp2snJ+cKDnDnU6MdYXPHGpgHeDsv7iLdmDQjGRf8W0fY95qG+mGkgWx7Z0qIuParmfPJcKaPq1ZMbcbOnc+CpORN6xwOhU6bgOS2uALYLT4babMR46kLX0qNYLVeRz0bu8ouxRSGebkrcgR7hszKFz9MBC0ZPPs3dO+PFOPNrtToQ3A9mJMiilh7mXM2S5D8L/6SoS1VBdI+Rlwk7h7F8LmqsmWVtc6XYwOgP10FzrBtJwH/g2Us2XI65VXIAbt/Sc8wg52fd/MBKYKj1Xtz1Zu4HCsgRKEp25nWR/+v1T/sLcvmzd3eF6aL3vCrqpgjNaXxPuch2JlKgHZSCjdqa4tDxogpbSFjyLaQUDpcczEZ3CGkM2JUMeISjzhPF78EmsmoM4HgESKjJh+wdedaZEkebs+WAsnhVCAG8ycPheVsfJVJB4RRGhb91jupziC60Rrw0RfQzllrqv0T1vkmb2HK9AsTDfzNkWBbW5VQwNdxtQgumSjRnqrQREvf+te1fYjab6l8Fe7silorwfpyE4/PeLkI70qG+c3ubLG14WnG/9bXITe3Sg3gufgMD3uoF8KKJ/0V6GzdDt22gK3NIqFyk9V+xiS3oK8+Zc38yfGHzkzyHjB0ezLA/D5w/gXaHRPNUKPnzmpZ+cEJ2aHpV+N9Vbsr9FmmSqoLUasQXoILPPJJJ/sZFjEWePqCGK3Kix9d+mP5XSGBFMYy3o8vXmPLkd/fkQYL7Kj2BCfuQBvmMs9yHgQoE6g2bowD3kugB5RCpPI6Y9UT6pOCZAKl34bPuVJLMsxLd8AGei0ZygYkWrSwsmIAeDzrw9Db0gyjSKpqlW
 MS6QkJS+
 t9l3cp3Jkh97kO5ghh9Ud2ZBNBEBuc6cdzL7eD8hK68zH6G/OjZSEaI3Q6ZXV35t5nwLORwV6grmxd4wmNH74e7bZKqngjEgeGcMTAzQDiBqojDZU8YyCCGV9JqPLab9Y/EPwY12an/FlEg2HTYDUGCQpfZdZLgJy8+JmQ3Z1IhMhTrvUeAoNhSkDzBmd6B/T7qy3aq1ymO/Q7iKmlo6OXr6/qBQ2FOPLqijEGJooCIV/Twl3k/d2/jLALuq0QJ4QfePlLq+L6GFquIuDBqHrIwFGdY6Qp0W6ecyR0wjolh45M+vro/NqYUoVuQDLQ+4y1pWxzA5ry6HBwok2F7El6XvildBfrlajWEKX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/2/26 18:05, Sang-Heon Jeon wrote:
> vmf_insert_mixed() just calls __vm_insert_mixed() with the same
> arguments.
> 
> So merge __vm_insert_mixed() into vmf_insert_mixed().
> 
> No functional change.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

