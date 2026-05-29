Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF3B4CD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 07:34:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA1056B0005; Fri, 29 May 2026 03:34:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E50786B0088; Fri, 29 May 2026 03:34:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D667A6B008A; Fri, 29 May 2026 03:34:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C60206B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:34:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 74CE9A0CA5
	for <linux-mm@kvack.org>; Fri, 29 May 2026 07:34:36 +0000 (UTC)
X-FDA: 84819644952.10.A27262A
Received: from lankhorst.se (unknown [141.105.120.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 46C1D180006
	for <linux-mm@kvack.org>; Fri, 29 May 2026 07:34:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=lankhorst.se header.s=default header.b=njLFIoh5;
	spf=pass (imf16.hostedemail.com: domain of dev@lankhorst.se designates 141.105.120.124 as permitted sender) smtp.mailfrom=dev@lankhorst.se;
	dmarc=pass (policy=none) header.from=lankhorst.se
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780040074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ObUgIcO/XwOdy9Ia/Ih5aqaGEVhk/Sbue+xZGoGAl0=;
	b=oQardW9lC+MLF8Gvn7w+IPUo/KbmLEGIvnQabvkeaRcTtqFvbHvw573c5Yj2/pDCdAA2mf
	MtZJvv/4VzT1BejHGCJeZBR8lR7vjT0XaToBh7+MTdE17tgn0S7cVvW2T1FGPP+EwW71J1
	LxIS+Q3fWffJuBzVaqRcriyPVgyD8dg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=lankhorst.se header.s=default header.b=njLFIoh5;
	spf=pass (imf16.hostedemail.com: domain of dev@lankhorst.se designates 141.105.120.124 as permitted sender) smtp.mailfrom=dev@lankhorst.se;
	dmarc=pass (policy=none) header.from=lankhorst.se
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780040074; a=rsa-sha256;
	cv=none;
	b=T/TD+sUmO0iiBRmK7NX/Yvatbk1/5lRq7L1N/uyCzCX/bWMVAvFQ71umcK/MKENDs9vAZZ
	S+cTGJO/eil5PUmCvHocrMYbhHgA9EWhCVs70RHFalN4znYHRcBxJnFsk+3uRxNUUPLfd/
	1f9zDbhSEnGeRcniLwN9T0N/lYsaNx4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lankhorst.se;
	s=default; t=1780040071;
	bh=jQMKoFxjhXOg58Gu2goSrIvcgitzJfXOyS065eiSQOQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=njLFIoh5+QF8qO2yk3lhUuM/T3YGzqoJcLI545XszXAraCyn/vqzqXbQpztEhe2qp
	 TvvjZJh8sITmgxaNvTUvCrCWKTxfWZ5H1t6ucIVSwHpWHzYJrJ8zxulTWmtYdQuf1D
	 S1iDf5BZX/zV0p/epJhWh88rH8FjbA70aH6aSBWLtYah/vlXYhULlnKNsLubUkU37E
	 7eC5Et/rBQnmvo5b5xtczea6RnEY437dQfirB8BhtMrcEPhpaL015Dxlh69eFMoueV
	 Uz25Xm/jB+pKTjyCi8f7ocYa5b9mJEfuoTwizogiCCJAbev4ZmKHjn5+RxJNWFSD8p
	 6wFW6wpwDZIiQ==
Message-ID: <89901220-0a43-4668-9d20-aaecc72c58dd@lankhorst.se>
Date: Fri, 29 May 2026 09:34:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] cgroup/dmem: introduce a peak file
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
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
Content-Language: en-US
From: Maarten Lankhorst <dev@lankhorst.se>
In-Reply-To: <ahCISfTlN10gD8e6@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 77eezpsrjatn3jagncgweowty1e6rrzz
X-Rspamd-Queue-Id: 46C1D180006
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780040074-345776
X-HE-Meta: U2FsdGVkX1+MQEFjYF46mXA4VGINi+veGi4ST41INjrhB2NI0k8NKp8mAmOM701hPk3YO18wDSzLucGnpF/G/F+Vg1yrlHvfSXpDjuLs9BzMPI3T6KWsm3yJhxdntRaonwBIT07JdvsNx05F+zW7MupDhcZEwdjHYtttA+B3oP4SKQEiNIPw8yhyJj+0FIrCPt2tpXxo0Fs/VZtImy6NcPfsjUuy8zk3MS6p0KQ7AUbfi23G+eTy2g7hZf2GenST0YNCMke5PgmoVBodkkdD806zzGRdUFvjPPBaUbttzcR/4RH5vPmdhQbnQXzV6HjTlOeOPpiZUBnR4lpjBl18s06HsnTruQolZs+KH2579/qcL/BhVYcnHUoEsWOkr4DNA31RLmDFvXGCNUIUJ5CEw1JKz8ADtudrBdJET+hJdoVwRUZjg+Fm2k/EOUH/6W7NVMdGpKWr0qybHCrnK4cWZ9OPOByubgtVzOyrJU8S3yGiGYfXfkkZUOrlRdk/FYrrbB3JNHQFzLgJoMrmmctmKh577wmS0IwaDBxNXUTkqLkQaQlqjjZoYx/hpcgo0+HYp9i+gHKTwjaYQitZYTFCE1S4qHH4Mj4BjFLE57iixG1WZ2TMZOWZxT2mJdtttcVtdY07oNuuOK2YhWsOeYLTHO7aD9HIo2E0YgjrpMqRY02iX54Cz62exytIKumoQjRehrJ2/YfDKMZoK2KSiPZ7ilORK/Ltt5lmr9o8SCN3Z9x6WHIHq5WLthpu5irBIIjUd6lcZahR5+gSPI3XzbQtsX1gv7jyg16bA/0C796tIqo7V/1Ru5qlsJ53Wa32k5w0j/cAkS1MqQ0TJxKqPRGGe9y5zamLjZjAr86V5p0yBgp9NMqQX7GrqSfP7fMjCxAWscZYu5Q4B0YVeHDcwiLxl7MisHH9s+4ayt3F1/28150vmS8ODHAJ1TwlB5WMUIg7Vq5QT0RED0rM5AscVXK
 fwEmiOEL
 U9CaQ2N5omoHV+zv2Qr/8beOpLxejJlultK0raNCYnLxvrMmz+uJA8nkKBnMyCqKkTZuR34/s65fnGw+xHp1l9D9kyd6aw7UF+yntolccUtalcRDMPfe2tlBelMITxfZrjm/xUc9mSH2H2xgEmv0QlPpdT7BlrIef7aL8YjAfYEce0aOV/1NcNLVN2mo+eghoPnnJM64nrHoYNFJgiHhcn+YAnEQ9cmwkbxDvA6EbpjXmZlT+uXXfdlK0uQ7Ny0ljook+YBVlZmtlE8TV/pcXzKrIzMh4Xt5qv2fq+s1zLssL1kOhBRVMeALUKlUN0CPK5V5Q6yJ+XCqpA3koLu7RHvCKyneJWzzfxCUY7apS1HyZ+xE3ruoPJ2PATclKxBBBXiQggnRNkiBRZr8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Den 2026-05-22 kl. 18:48, skrev Michal Koutný:
> On Thu, May 14, 2026 at 02:36:08PM -0300, Thadeu Lima de Souza Cascardo <cascardo@igalia.com> wrote:
>> Just like we have memory.peak, introduce a dmem.peak, which uses the
>> page_counter support for that.
>>
>> For now, make it read-only.
>>
>> This allows for memory usage monitoring without polling dmem.current when
>> the information needed is the maximum device memory used. That can be used
>> for capacity planning, such that dmem.max can be properly setup for a given
>> workload. It can also be used for debugging to determine whether a given
>> workload would have caused eviction or system memory use.
>>
>> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
>> ---
>> Changes in v3:
>> - EDITME: describe what is new in this series revision.
>> - EDITME: use bulletpoints and terse descriptions.
>> - Link to v2: https://patch.msgid.link/20260513-dmem_peak-v2-1-dac06999db9e@igalia.com
>>
>> Changes in v2:
>> - Make it read-only for now and adjust documentation accordingly.
>> - Link to v1: https://patch.msgid.link/20260506-dmem_peak-v1-0-8d803eb3449c@igalia.com
>> ---
>>  Documentation/admin-guide/cgroup-v2.rst |  6 ++++++
>>  kernel/cgroup/dmem.c                    | 15 +++++++++++++++
>>  2 files changed, 21 insertions(+)
>>
>> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
>> index 6efd0095ed99..d103623b2be4 100644
>> --- a/Documentation/admin-guide/cgroup-v2.rst
>> +++ b/Documentation/admin-guide/cgroup-v2.rst
>> @@ -2808,6 +2808,12 @@ DMEM Interface Files
>>  	The semantics are the same as for the memory cgroup controller, and are
>>  	calculated in the same way.
>>  
>> +  dmem.peak
>> +	A read-only nested-keyed file that exists on non-root cgroups.
> 
> s/nested-keyed/flat-keyed/
> 
> 
> With that
> 
> Reviewed-by: Michal Koutný <mkoutny@suse.com>
Reviewed-by: Maarten Lankhorst <dev@lankhorst.se>

With your r-b it's ok to push it to the dmemcg tree?

Kind regards,
~Maarten Lankhorst

