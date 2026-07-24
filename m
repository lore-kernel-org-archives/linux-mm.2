Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C975C531FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 15:42:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A7E46B007B; Fri, 24 Jul 2026 11:42:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 159246B0088; Fri, 24 Jul 2026 11:42:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04A386B008A; Fri, 24 Jul 2026 11:42:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D34506B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:42:39 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D9671402AA
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:42:39 +0000 (UTC)
X-FDA: 85024087638.19.2C1EEBD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id AF4831C000E
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:42:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SVEHUOBA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784907757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e9MBK5ih5pJH5Tkk041YfkIpZ8EYnsh61ntJ2y5AuKU=;
	b=PHs3JUeQ2g6E6WDeRhCRawVa+qz+ZrUlQ7NY5SRMRZ1rNqugrQENh2Uw6PTOh9s8G7XLCW
	Kt+XqAbcTx0E22QocekIDvITOTEcolw0AHEDV8fCTUyG4AigoWL3BiotWrN3tqWpvbaK1L
	7R4a2xZi5yXrtWxqJE9kBCYHZukDtPc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SVEHUOBA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784907757;
	b=tx/rF6xY+uPaUFQLob9yEUn1H2Mawzx8kNB5l3fwk3wNi1cXBv7+Qevmsz+YxA/FYJBgq+
	R352gAyh4+G5R9jIvLvBXOqnFIyN3IWQIVLH033VDPhVSgMGhxgRLkrI41RNsmNH9raj8F
	Njj2c8Ru8ndR/d3r13GIx6+/iOg7eKo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2D7FA600DA;
	Fri, 24 Jul 2026 15:42:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E15F1F00A3F;
	Fri, 24 Jul 2026 15:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784907756;
	bh=e9MBK5ih5pJH5Tkk041YfkIpZ8EYnsh61ntJ2y5AuKU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SVEHUOBA7CyCoOVLY/ESfqlRLqBpy+D4VC2WG7oRWQawBvKmGC6GXqF0e/l2CLrh7
	 Re42J+XY+5+BtaEx1DNNnTecrDLK6VhrY4YQn+OTxKzsFcT9DJmaWb4ajk3Ok/Q8S+
	 ndtBJlUw7rPBkHi+ita3ubgG3I0pT9dVXl9kAXvV8QdmsCyn5LhfKHVlsBNl0xSUZr
	 +nsaWW02S0oMAAPOr12qfJhAq7Q9JqV7eJ+ca2k8PQvm55YSirsY7iKVJtQKa1RKcE
	 qNgbG9zMXjzQKAFOXs9d0nv2z5fNF0CAXu517NsTlSLDWrvYA27zotLoavtsHt0oxy
	 fKXpv466jMQlQ==
Message-ID: <e3f283e3-27a4-4e3e-bc4c-39fafbcfe1ee@kernel.org>
Date: Fri, 24 Jul 2026 17:42:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/13] mm/slab: change struct slabobj_ext to a union
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-9-2fa7c6f60dbe@kernel.org>
 <amGEY5w-cBm4_uhx@fedora> <9b2dadb7-8e3d-4b9b-a870-969be9a7a432@kernel.org>
 <amHkbJsvOjcfUR3D@fedora>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <amHkbJsvOjcfUR3D@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AF4831C000E
X-Rspam-User: 
X-Stat-Signature: 73rrbsj5rsiz1qujwnqyeq5p6hswb39s
X-HE-Tag: 1784907757-538493
X-HE-Meta: U2FsdGVkX1+uGUizfaZF69N+LfaT3AgAB+DrEAfV6JrrPqMibf42jozFvdpaZ19fCrBsXxO6yFj/DreNdk+PIus2KF/uMNPFVE/NnzxLiG+m52ZBiGxi4ZOt+F1RhQcDkY8jdbyCw9OnMgpDfsHfz7qGrfVFpvuUKiV+E6/IPR2kUdU7nz4SUzf/lbR84qWPJ/0exePA73lH7OYVfVlkRQ3vEyMqmlQSQqCVlEPEVOPteYYocSK1CHWBDo2pYplL6uXNJ+r65t3Vq0wqlUCUwAbjLwVliaGojtmTxtxwpE00MErGpF2t39bk/kEtfekDODjvSTfUR9mVxDeoWerRPzSOo7np6zT3tvKtLNhSIWzkpUDtRvwPkUt4uBojUbyhdZWflE14Z9PsIVBBrkVzwxRLlzVdf3fMCG0sf5UVIBxv/6S5oUYfq8nCsdUpEMQAR9sBe1PDP08MpejOjFBoh0PsxpNdIHUiam893UujojUmO2WXityJPbj4otJcVeq9Dhrq1O2qqcTfgMwZcx7Ho0iOfm59ZFRIriIKLXkXGr95a9bW+5Zafjwcyn6awoRVAkEXspFl0bTPEGzEoGrzAtGOcWxWinkvOJNCtvTzVEFxySICuJBn26CPV1xnQUXn2SDgos7kmaNAtBnhpJFZy0yvrhG8OlbFj0sDmDKYS+Si+vZqfLEoPH522AxSUzR4fIhDtbf02DntDBxiB5c7UdYNQYOHqB5KVjjm0DJele95fNiVFfulbxbX0iF6ShQ9aO1yJfXz+omCDcVk/3JU6jp0s2pPr5HcdKXjdDYWIwmuouKFbxiqhzDxWFVVnU9aVK/AIZlakYDrk5M7aQNz1MkVso4ZaKNWk6WdNs3OjyTD3hskkA+0zOG8ZpkOhqRKkPoZuxtdmMvAYVu9JkjHuiHfPSJlAUuLWx5+IK5qFdQPUYSH3zGd6mEcig+ScSktdkFHZKp8qV/k8rXMBaK
 I1lxbwOY
 QCaPBivZsPD6K4WnFttoBMS7VnAyh3JaX60Ny43npxOiDgqeo6r1qa1FxYu75N1+wDXupfuGZjMgmEmdONN8DKY/1qk9wQJXzJI+bPFqpnjgPM2Dx7qlVneqts2Fck+tug7ZvkzO1cwLBp6QBJh2my2EVbfzTrgozSQPWc6jc9f0KYy084FK+hZ6IBT90jIZb0ui82LhpBenr2OFp4r3h7EDGmKeHtLz+GY1+u+nJaSTgcizjYNIIByFT3F3KSdRBX2BEyeL/JYekPjxkEK0b2E0C6WWkH4rJsq8C95BvFRGqddl8U4gnjQNwyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/23/26 11:56, Hao Li wrote:
> On Thu, Jul 23, 2026 at 03:27:51PM +0900, Harry Yoo wrote:
>> 
>> and drop OBJEXT_FLAG_UNUSED.
> 
> Yes, this idea is insightful and I think it may need a standalone patch without
> blocking current patchset.
> 
>> 
>> ...not sure how much we care about this on 32bit though.
> 
> Yeah, 32bit is a rare arch today :)

Agreed with you both. Let's deal with it later.
Also AFAICS the memory was already wasted on 32bit prior this series when
e.g. CONFIG_MEM_ALLOC_PROFILING was disabled, so there was just 4-byte objcg
pointer in 8-byte aligned slabobj_ext, right?

