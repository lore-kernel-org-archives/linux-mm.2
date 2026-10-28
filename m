Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D17FE606A322
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 06:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=leemhuis.info header.i=@leemhuis.info header.a=rsa-sha256 header.s=key2 header.b=fAiBo8UL
Received: by kanga.kvack.org (Postfix)
	id CFD1A6B05B4; Wed, 28 Oct 2026 02:03:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAE1C6B05B5; Wed, 28 Oct 2026 02:03:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC37C6B05B6; Wed, 28 Oct 2026 02:03:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8F7BA6B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 02:03:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8DBEAA0A01
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 06:03:00 +0000 (UTC)
X-FDA: 85370991720.25.FE8E57F
Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.63.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id 06352140004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 06:02:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=leemhuis.info header.s=key2 header.b=fAiBo8UL;
	dmarc=pass (policy=quarantine) header.from=leemhuis.info;
	spf=pass (imf23.hostedemail.com: domain of regressions@leemhuis.info designates 188.68.63.174 as permitted sender) smtp.mailfrom=regressions@leemhuis.info
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793167378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=grngWBuiji8lwqsdeZEwLlbBmKPklRKaERiWSs5Ihh0=;
	b=P1tV6giB08pO7NSjVhAztbKW6usiutYx51WYmMI9x2Ct1zjHAhI5mtgYnyiMV1oGyB3lZw
	vRvivScxjA1gx6KIro+97IfR3PG94HzzkGoGTsvbpQrR4wvqss8xiBQLG2q+emb4d4GJiZ
	PTCAAZn1xG5loMF3mC2v8Dgxs7dE5gU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=leemhuis.info header.s=key2 header.b=fAiBo8UL;
	dmarc=pass (policy=quarantine) header.from=leemhuis.info;
	spf=pass (imf23.hostedemail.com: domain of regressions@leemhuis.info designates 188.68.63.174 as permitted sender) smtp.mailfrom=regressions@leemhuis.info
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793167378;
	b=67/YGDFXIWqwp7hdwQfmCpKy32Io/hDw0g72mg0t01Wyt4csu+rvyLYmvSc/iv1WeiVV1M
	GrKIr0h1/aA49rxNNw8PNPE5Wi18Ah08gXK4KE9YHKeaSW52eEcMJSY6VE2r1nksIcWqqK
	12uBhtQAm+eDHuvuhud0aX5RDygDXqk=
Received: from mors-relay8204.netcup.net (localhost [127.0.0.1])
	by mors-relay8204.netcup.net (Postfix) with ESMTPS id 4jDxbz4T3fz8sd2;
	Wed, 28 Oct 2026 06:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1793167375;
	bh=1okY4/WQi99J7SX0kElMLxT+6AgqYCI7lGDlpsDqa+A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fAiBo8ULWstc9LQnFor1eWiy9y2h1iQVBO8Ml0nYw6NgYJnJqC6CGNvDeInwQN8DQ
	 K/YrYmEpEvGvaNzav6FPa5YpGSFFWenbu3xepK1f1bkfTIHzW+20rTMxeI73biav6y
	 M+44CEY5xcXqaV3moEIwbgQqnWRW57EaprPF4gik9Hsu6a3kBzvsapzk3HDaSqdpZF
	 AQb/kspy+U6e4/LRz0TkqBt/D4nMPaIUZXTbfrLqwnzMGzzIvzLXJ4UNsyevgyZMpZ
	 e3gmqrJU9K2NoYF4ALm1/AVhyF8s3SNEbDSyyQjpREHg3AjcNaNtInSzeLWpKo0e/v
	 iqOx/Fgzi/Z7A==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay8204.netcup.net (Postfix) with ESMTPS id 4jDxbz3mJ9z8sbb;
	Wed, 28 Oct 2026 06:02:55 +0000 (UTC)
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4jDxbv1pfpz8sgW;
	Wed, 28 Oct 2026 07:02:51 +0100 (CET)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id F2C265F9FD;
	Wed, 28 Oct 2026 07:02:43 +0100 (CET)
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <18f0bae1-5cdb-460c-a147-33cd1fa2acdf@leemhuis.info>
Date: Wed, 28 Oct 2026 07:02:42 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drm/gem-shmem: Install writable PTEs for write faults
To: Konstantin Fastov <kfastov@gmail.com>,
 Boris Brezillon <boris.brezillon@collabora.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 regressions@lists.linux.dev, stable@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sergio Lopez <slp@redhat.com>
References: <20260804140403.16337-1-kfastov@gmail.com>
 <20260804162924.0268f80a@fedora-21.home>
 <CABWhNekebS6dt=Ft+74iG4YpCq-5ZcV1EvvERNxT612VUOC9Ww@mail.gmail.com>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
In-Reply-To: 
 <CABWhNekebS6dt=Ft+74iG4YpCq-5ZcV1EvvERNxT612VUOC9Ww@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-PPP-Message-ID: <179316736461.617485.9239835948581871887@mxe9fb.netcup.net>
X-NC-CID: zzZh23SNCmq0eCiirHBvMPb1mMm7zOOn/wv4ZUvO7omB48g47ew=
X-Rspamd-Queue-Id: 06352140004
X-Rspam-User: 
X-Stat-Signature: 163a7dobmpmphun1m36sg4yptqexwign
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793167377-422037
X-HE-Meta: U2FsdGVkX1/dpal74GsYESLQNZVH+GC0+ByYjZgm0kKwUMScV6JXWgm/pwIn9QSH3P13Wa/EL4Hf0tai82HwxyVbvZUB1p5UIZB+8amIHXDypxjDWiZ0lhfJjyujI51yQ+svmZvebSiVHKQOFatFWXn3VUwBbqNODsjAOKPEgv0d+xyjs7eyvHYSY7L1XZKQYkR8t/hf62O57iVZqNNj8uv/ZqkjojbREQjyKZ8cXG4qNx5M25T8OhJ76iKxKpzTyYtE5/l4Wr5lZspELg96z7qGEUHKCiroKifVzUauHEstJLCmBySihMZNMG7VDule0atUJ+/tMOkac43N2pZabU5Tx4YuqJ/A2tqGIAgmvAVpd29rZxsrWFQGulYzep5zaN/tJ1h2ngEMDjKc9vso8iuLPahOd5FcWVFmi8GKsVMLBZHCLJqdBJ1XLIIMU1D8WueCqw/F4chL4u5HtLkFb+b4K/HsTpPpe+mXTCQF6lWJBC3DCICWXFWpnUUa7dVuEQp+mH8SdyJhXPIj+QitGEoZWr8I6I0xJcejxaymlzutCHRff1rFBpKEauydmicdTBuv6VJ08O8xWLwiIKRbTnUA8bhxHJ8IBYQI6bHx7c9q0cEnNck4gbolMBaHUT4s1s3KdcI98R9o5TMTXoD0P0DxdzibjtvAbls42LXgNoVYoBlK9sO/KHFkB0lwPriincaRRwBkeA7Pomi3SGYMJ3ognZe4Qg6jNf1UOFH48Ar1aR0BDj9aqiKXEIzmUCTiTVkdHO3gays4y55vdrq2phX+BxlLBSArdBoZG1iXqJN2JZREnE2zkZMC1zrnpwuDpdHJ58H8hLTWwNAd7zb/twxQdCf/D6xXIMyELFBzdMEjuE5oWKnQWs9vjyWKsnIJij3RlXuJZaAu+W0vdiQuiZGNjqnElJklwgqqWK4TtLmhIGDVzMsDrjswU/BuFV7auOQUMrsZ+KCp3KyqHV8
 R9/tCGdp
 lRgUJIrBy+gZd5nUGct09LF2oY2jHXQydHvxc+aCGhTX3qHvu99ATeEzc3yKJkxNwFtWr1bqUsDZIB+5WY/cxnX/QkVLyVXknNo6+/tA5ncrCcnvEk6ferDbMQN9KXLS1s327Wr6CyI23BS+X4gYfKiWh9qXMhZDoTMsrfUC7HXooBnJ9PVMJskBmyqxH+P65MrvK90zqpgTpRKoAkjMXuA3b2YIAQ0ZGQA18xGtvyRnA4Plw6G7wG+weFRJIjXlwNW3dNGh2vmojtut5WQbLBpbpy7rYy7Wi2hK9YrJBJ6/Z9uLjr7Kd0SmSOtxoCEyKOdUmH5Kbm01zFk4hHcYjXbpUW9WHVHtZQE8VOp7MwcWrBp9CmJU+b7dRmQNXXsKEl9VDjsBD9TB/Hl15d86pOLI/9GpgcNq+2ZwjOD/Rg/JeRLTISzVSca1Of9NE8NveW5UmyYLxPVja5D/XfQTWSBRG+4R+Cnil2pQNHPT8MUx+qbkiDx19Vxcgc5dJ3ox+xRMCoX4YuvBx4Q5wf7/Nhmk8wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

[CCing Paolo and Sergio]

On 8/4/26 16:57, Konstantin Fastov wrote:
> вт, 4 авг. 2026 г. в 17:29, Boris Brezillon <boris.brezillon@collabora.com>:
>> On Tue,  4 Aug 2026 17:04:03 +0300
>> Konstantin Fastov <kfastov@gmail.com> wrote:
>>
>>> Since the introduction of dirty tracking, drm_gem_shmem_vm_ops has a
>>> .pfn_mkwrite handler.  Its presence makes vma_wants_writenotify() true,
>>> so vma_set_page_prot() removes the write bit from vm_page_prot of
>>> shared mappings, and the vmf_insert_pfn() call in the fault handler now
>>> installs read-only PTEs even when serving a write fault.
>>>
>>> For regular CPU accesses this is transparent: the retried access faults
>>> again on the present read-only PTE, goes through wp_pfn_shared() into
>>> .pfn_mkwrite() and the PTE is upgraded to writable.  But consumers that
>>> resolve faults through fixup_user_fault() + follow_pfnmap_start()
>>> perform no such retry.  In particular KVM's hva_to_pfn_remapped(),
>>> after "successfully" handling a write fault, finds a present read-only
>>> PTE, treats it as KVM_PFN_ERR_RO_FAULT and fails the vcpu run with
>>> EFAULT.  Observed as AsahiLinux/linux#560: muvm/libkrun microVMs
>>> mapping virtio-gpu blob resources die with EFAULT on first GPU access.
>>> The traced failing sequence: [...]
>>
>> The same issue is being discussed here [1].
>> [...]
>> [1]https://lore.kernel.org/dri-devel/20260804120529.1730187-1-pbonzini@redhat.com/
> 
> Thanks, I missed that series, I searched dri-devel but not the kvm list.
> Paolo's patches 1-2 are indeed the same fix (down to the same function
> name), so please consider my patch superseded by his series. [...]
FWIW, it seems that series takes a while to get polished and mainlined:
https://lore.kernel.org/all/CABgObfYgZ87%3DW%2B6E%3DN%3DWwTuyYkaoKU3hqd84JDTSAvT3_9dh6w@mail.gmail.com/

To quote: "It ballooned a bit and getting acks from everyone involved is
hard... Either I or Sergio will get back to it."

Is that something you/AsahiLinux/the world can live with?

Ciao, Thorsten

