Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7F52C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 12:09:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFB006B0095; Fri, 10 Jul 2026 08:09:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD2F56B0096; Fri, 10 Jul 2026 08:09:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EBB76B0098; Fri, 10 Jul 2026 08:09:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7FA886B0095
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:09:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 153788E13E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:09:58 +0000 (UTC)
X-FDA: 84972748476.19.88DDF96
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4918C40007
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:09:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OABe8URE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783685396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2rHI4BKRrXXV3UNk+8yza2eWB7NJmGYuyDD3S0+ngBs=;
	b=eHeRDLgjsmuFo2VLTZ4IMtbFaKpnkUR/LvMiKizWuebySTZm6qocUC8pcvsKbbInqfNRPN
	7WvrqfCMoh9lj2Smh+eX9tC8N17jwdg7kQCdd8tE4Q1e7uIz9olnzE0ymLr3OP+j3hIckI
	5+yuJDgqFFGSw0TWvOVGwayB5Z9RhRA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OABe8URE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783685396;
	b=2hBRmVgoJfw92WD3gDKRV+S7g8BR2AdXA/W3UOmHTJx2DZDyPITpMcqqyks8Fe7oIKiOxX
	/6xq76KmzWHJVPG/nBsixRvLUZ+U+03aQ28MCRorDVfs83hlmY4LC04BqeTimZO+vvOSWP
	Hu8ZhKW4hv8gdf0HAQiPEOaxo9hPn/g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8950642E62;
	Fri, 10 Jul 2026 12:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D2C1F00A3D;
	Fri, 10 Jul 2026 12:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783685395;
	bh=2rHI4BKRrXXV3UNk+8yza2eWB7NJmGYuyDD3S0+ngBs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OABe8UREGE+tu5QrOf1Xr1N4vokLqMZTRPXNhnjIJhFPfNpN0H4rziG2jVMjuxmK/
	 ir8pnUrAcuGbW5qpXIazZaO/b9auhJnEquCXjMLWG4ziRC9n53juoVSfjpGG/7mDUX
	 OVB4NzamT0HwtfaAxVj3PGzLDMLSGoUtbcWwxYuUPpDevfCYklJ4dt6S8Pw1ctwk78
	 XjcJ8dk4XqNHHDc+pXsVLjGozJLnXL6DIokAo6DUxE+Nd37GR8Qz6eRhmnszVQW4O2
	 EMnIWyvn8aLP1DDmob/BDwRIMGqj50qWMTuoMEmOhIj+hytlzkxFBxCKJHlRStvGnt
	 oMAFODvQmhLeA==
Message-ID: <5bbfac93-6cbd-4950-a33a-ae5a816d2c3b@kernel.org>
Date: Fri, 10 Jul 2026 14:09:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] mm: mincore: remove xa_is_value() in
 mincore_swap()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, "Liam R . Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Zi Yan <ziy@nvidia.com>
References: <20260710120052.103886-1-wangkefeng.wang@huawei.com>
 <20260710120052.103886-4-wangkefeng.wang@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260710120052.103886-4-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4918C40007
X-Stat-Signature: 5k1cexz9f8aqzuugocjw7ced5d75rzoq
X-Rspam-User: 
X-HE-Tag: 1783685396-937650
X-HE-Meta: U2FsdGVkX18mPdPwM/uEmjbaIcAWCZx0naEBDq/rdFfG0mk54PyxwVhYPHQ0O20OIDG0Lyk4jeWyrCL+HEXamZu2EU+LiGgrjjYO//ptqP9Vy5DB/aHDQVbUUPaF3HcXT5G8BWwfqoX9F2VScwCEMwsO0Vmv7hzNOG69ZA+Bp/k8wBmcJV+kX37aqVYDfgFoNLXb3tdQhrDwfkuSL5OcrpaNkOxhUgVK9VJTpoAP5VqNrbBHv0xZa05kpLm5e0wCTcd14KuuzTEwEYYDu7CI6YvjF/fhnYxfTmljIfrdIkh78Rch0j9kTGA2RHmBY8CHBy0R6TVbZv4miFqL17gruD9ux1jJ2HnFzxbj/XKojvbmW03BAPKLM5XrwBeSLqXou0sGk1g8PcVYIVS3TBiP/reIgg/STejHgjL8tFBK3Tz/tG/RSVE+kNODIfADYSzBjSC7+RFUqTrmZsgZvj308wcVdfAdvC9XHHYF6LVZG0DbfJdF/OW6uQ2nz05IPvvrkpAvfQx20HaKsYJm+lP9Q8AsUKadH5p9t2ewm9g+8g8MlDQlDnbJh2sbYkcUbjEfuxn2ksRz3YtCVeGPTG2Ksfd1yefzEKXcIZqxQtJ0RYw+WMRxp8pC2o6KKjjbyhyvcdi8hPms8RZdlcmwkWLg7EH4qzCXleZobz8BL7wu5op5j+r8rplaFeYf8UodVsFc6qw46MhAUmFUueio4bcl4zhO3vfI5jXAObqOAVyLVsv3kuNGglPGH1SkR1kYvgc4FeuP3GBdXpXnUBdUwt4XTUVvuUGlWTsmw7jxl0n9DREQf1J1typg0rQs4JOFhfEb2qjXde5gYc6YVzLRBCEBMAjOXTSjoeFdTmEv7G4rMuSxSMaH3hgmdWxaJ0fKQaqb8Ixn6PAsiUica6BDLmPQX5w4+hGnE5AbMnSkLRRYbJf6z6qBgQkcjAjObeEQm0fPxzga88vNyurmRYANIsL
 YkOJ0VTd
 vEuytlA/YDEHkTA6PZK4x4dZvC3BJewaMBkmGiaPAJPx4i/lQcnOf6bnfNDrq/s1Z65fA5I/o5yoyFq5gGnAJW1bkGiqnisqd+Dp0d3O75aiY3t7bsXEJk1Ct5rN0KSQXkdsFc2y+e74mep/XeN7I3l5+Dx+QRlpkn2D7yCWWGGrUbpr6FUuJUReLCbu9NMfcMUnx2ZRomtJP9yEtgKHmH2iLENDcg+nMNWpMwJ65f0KVYSyagZSGshBlOXp3Y555E5p4zZm9jLILNPmjNa0cXNM051UgIJwAa84s/9Tf1macSJ8jQw7VtcIc5R9dNDu26MmU7Sbxi1bMcIkIWA/kmSGup6Y+iTlwyqTawK4UvQCO5ib02DaF7+xGyOUXBgW5CrvCEYQu/KV9DPJ5HabT5s4pD0lKqUBeVomTq5jjQW7rfZA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 14:00, Kefeng Wang wrote:
> The swap_cache_get_folio() no longer returns shadow entries, so the
> xa_is_value() check is unnecessary.
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

