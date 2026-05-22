Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1570FCD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 22:14:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 370F36B00A3; Fri, 22 May 2026 18:14:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 348C66B00A5; Fri, 22 May 2026 18:14:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25E366B00A6; Fri, 22 May 2026 18:14:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 117D46B00A3
	for <linux-mm@kvack.org>; Fri, 22 May 2026 18:14:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A8B90406E5
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:14:47 +0000 (UTC)
X-FDA: 84796461414.15.6D81F4B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id F3659160006
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:14:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qc4jZJ8Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779488086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tIHM2SDYUQGBiuGtP4tCOfNyFN+Zz7oqimi0+ieZN8E=;
	b=LfJh/kbKr6H80DONaJZk3/kiM2DJsYldVZBFLuKVPlkE4R4hTg8QpfOIRNDvXMTjh5o8QU
	DUGpAPL7jK3RkWqgmcWs+3vjeprYdmKnRgqllRRRL8WufzT3FeNR0wEzQKfDY4S5NxJGx3
	4x46y/JGFHj86K3VTV9dn6/fLfiJtVM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qc4jZJ8Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779488086; a=rsa-sha256;
	cv=none;
	b=VmeVDm6w4llIOxFdZkR87g/xMtxKba/8DarKve4KEuRAh28g29jIOlIDa8neJmWLsp4sHo
	QB8grlvIxDPNixUZS713TQGOJKddRlStSFTNgLsoQECZqJonShcd97qVA+ekxIx7ZuLqRC
	jhiqeMBRGlhNA4M5JqOHpaxo6DPOH0E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6BF1760103;
	Fri, 22 May 2026 22:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E1431F000E9;
	Fri, 22 May 2026 22:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779488085;
	bh=tIHM2SDYUQGBiuGtP4tCOfNyFN+Zz7oqimi0+ieZN8E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Qc4jZJ8Qkk35pAkFxc9VQFpR7Q7nC6BV6A5trkKmYoVwn6ZyQD20vBJw9EDiiJR4V
	 8qGnQWTl77oDEJczbpODXYiRKZA8pO1VkOKBAGv0LDU8GnK9jkRVJRB3kgOsoOAoCq
	 sCEf19QtRrHUdjBd8jj1uw8tfoGIxwYP5i5X0MjW7j2MC/JLj5KS0fZ0357N1OqUsh
	 1JDTJj9BGsYizLcjsbsfgZKl81PTHWBU2CGLi5mUNC3/WE3h3GV2QmYcXZ8RlGuuaI
	 o7kWKLZUnzi2AzyfaWC012VEmyLgTnwMEp0i7e7OBkypHNbODUcsZ36JI51Ik+4dAN
	 4CGjDLczXHnhA==
Message-ID: <84a88385-f892-401d-b191-6fc2012ad575@kernel.org>
Date: Sat, 23 May 2026 00:14:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 1/4] sched/coredump: introduce enum task_dumpable
To: "Christian Brauner (Amutable)" <brauner@kernel.org>,
 Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linuxfoundation.org>,
 Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Qualys Security Advisory <qsa@qualys.com>, Kees Cook <kees@kernel.org>,
 Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
 Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>
References: <20260520-work-task_exec_state-v3-0-69f895bc1385@kernel.org>
 <20260520-work-task_exec_state-v3-1-69f895bc1385@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260520-work-task_exec_state-v3-1-69f895bc1385@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xk4ctak675ca9xu734pr7efofpmejtzc
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F3659160006
X-Rspam-User: 
X-HE-Tag: 1779488085-730167
X-HE-Meta: U2FsdGVkX1+AQVawmP9WVMvSppU1I2LOPd1L/ii1bjqcaU5Pp9mBcDvAbXztnrTYreGYuKW1CZPQfTsRdxFFfWtCIDoH2c/F7H1j18nCWrIwCsnlIj/1g//b1uoLjXYsNfZzDtpoL4fvkcdR2XmKTU56OItB/SnfNuxDOceGr5fYaEQkAbjEgZsFrW3klgJ1prhhIwcrRfsXihOBirFuaZXWepW5Bbms10sZfNtZaAOYGejbwySooRQb6rgQTUW0lXB2LlKjw3r32PnqzzQBE+ZglLyS/5dkpRM5kizBWltHA+M3whkxkowuOtAA657Vbq4dQRB00o6upXYy+jw8qrV1SxxzsSNgZLQ+Q3UauMwtGlTnifvhuzf26drsC8mrkMm5oP3QlGdiSGZc3zvfq4HMtFdwoPIQ710tvcxkLv/VwfZE2bvvpIKv45tyCYJfyQ0E/s60pzr43DrSbClGYqfRr9hN2YnMJEXe6amS0/59MvCh8pYJVACUhF/vRJwC5nTT95nDglw382SeLGtmo6SkRNaF91me23xTCG5YJzFpiSEMrAhBQRM8nS+L5HijZyuIdfnroqh6TDIBg3xa7o8XmeP8a2NVThM/yWMG/UreDLpmUoQWFDM6ZpfNPQWHIWupUGT2W7WXOf2i7OdA8bxUDwXTmdxVSSy/WwV0vzCCeA/3+wJGPjhW5XlG64P7Ojuwy4+PvdhXRI6Vj7kql6/Fb9VC2Zdaurn+iziQOGo55UYH/O5yf94OEWMqTF9x9unSquuJMQRBwqq3Ty9mqgnk45bzXju5oiIdlBKqY9A03+SrBFWSfR8nIpW2VCoPS7dvnPbDWu+U65gOs6rVjDlASP+ACsOXPD0aZroBN/NFETnYQsNlSNMMVKKqLl0qP6R/M3IggWNkZAUF4BheysuiN+yaXkI605Jyu6xfWbLsMmB38LIRg/Tg/g+DqKzu3QzfhgZU7asJQfuAweg
 taXHKgJf
 6CUoxlGEK1Zr/QBHoK0YJduAA4Vw6p+OzBEBwuCT5On+Y64+uI3z4Lajp5idp2Bb9gIkY0s0P+sZTAlsvJPWTslLHhtT+SNQCXvp1r7mbgnNuHKT7p+VHkPdIaz8C8KegWGp/NnziMyL/p4phEnhX2bIYO/ZZb1LShtFoZjog7ug1KyHBBn49/0osphshIz9ZWVOaUPZO+NDMGd4WDPqTkrH6+4uwy8ka8XkyGUKIyaLjGSnaClGD9xQS0rNbrTpnVj8Im/Gww5/BirYzZGP31q1eoyXnYSvpAfxqkHHnTBJVmVTVRVlrgmRp/Gzyap2VHWD41cBiuZh5Bgj6p0w3SPmNEmD7GFO5a6z0Pjrh29O2a5j3NsD7R83/6AmWTLlmcgPc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/20/26 23:48, Christian Brauner (Amutable) wrote:
> Replace the SUID_DUMP_DISABLE/USER/ROOT preprocessor constants with
> enum task_dumpable.  Numeric values are preserved (kernel.suid_dumpable
> sysctl and prctl(PR_SET_DUMPABLE) ABI), so this is a pure rename with
> no behavioral change.
> 
> Subsequent commits relocate dumpability onto a per-task structure
> where the enum type will allow stronger type-checking on the new API.
> 
> Reviewed-by: Jann Horn <jannh@google.com>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---

Reviewed-by: David Hildenbrand (arm) <david@kernel.org>

-- 
Cheers,

David

