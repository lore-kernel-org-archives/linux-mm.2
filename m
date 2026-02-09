Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 195C2E7E0B2
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 09:38:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 821C96B0088; Mon,  9 Feb 2026 04:38:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CB286B0089; Mon,  9 Feb 2026 04:38:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A3306B008C; Mon,  9 Feb 2026 04:38:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 57A926B0088
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 04:38:49 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 244CC16075D
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:38:49 +0000 (UTC)
X-FDA: 84424418778.05.BA3729D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id 984E1C0006
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:38:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QMazHPSc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hjPCs1Si;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vpgyqBiA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hLPIN9MU;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770629927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JAf3pqkFnwq+zdsxVQQtCzWCRKHcpfVHtUf9wwuLw4I=;
	b=7/Av/wy89pVoAtxZSotN4mXG1kwgHkkU5nCrMypkTF/QP9nnf+vBXLf0DRsqiY5hgWd8a2
	HBcJ0BZZW81GjSdGzEeUdFyOaP3TBUiJlzmhYws4cDQkMg0Kk0A0xoKXY9bp6qieXuC+sk
	CAxUqMWUnF97tBRmn2bp8vvNB8xC/mo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QMazHPSc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hjPCs1Si;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vpgyqBiA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hLPIN9MU;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770629927; a=rsa-sha256;
	cv=none;
	b=Ta/MdR5Y54HEe4argAYFJ6w+7Z7QSRMjW9m3gwjD4MfkrLXf/lFT17HpzSIYXEIiE+jxv9
	QPOf30Rs4wmj7zYjIyXMgDoZ74R8vJdlcdA/1MYggmCEWinz0MTnKPkSDdpLOq7cj2n0xI
	u2frc4q6ilGcxgC4zrTL9jXvUi/CiDM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 865AB5BCD8;
	Mon,  9 Feb 2026 09:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770629924; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JAf3pqkFnwq+zdsxVQQtCzWCRKHcpfVHtUf9wwuLw4I=;
	b=QMazHPScT78p8/A5LSY0zf5Gy+ntNYaAa/KDEvAaZOnAAMMo7cMO1AXhXYu6fUzeYfudkA
	ohbandRiORga0tPe56Gl4jv0lN5ERKxGJeARGkJg9DmD22NGNsLlHcdILRVF1lelq6W5ns
	8D7PfWHjLJHkc0YxX3BosNzbOvdznDQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770629924;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JAf3pqkFnwq+zdsxVQQtCzWCRKHcpfVHtUf9wwuLw4I=;
	b=hjPCs1SiuZlmsnRmm4WuXxzlgIWtcI1+FwmskJMUwsahkuoZ2KgwDN+BGXF9pQu6H2bo4r
	c4cnzNXKNe01/GBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770629923; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JAf3pqkFnwq+zdsxVQQtCzWCRKHcpfVHtUf9wwuLw4I=;
	b=vpgyqBiAF59GS8TN0tj1Yw4gD3AFubW2+nvp95OMWMNE0RoW4gl8GaHjOMqeILjreb20hq
	00ZGgX5153b9c8kxfXq7QfLWsg1laWcWqFoW9AFUjp0SlZhVETsWU8YS2GZLWAAXa6vqs/
	L2U14MsiN6/8NfIO/A/QkNJybl2XLY4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770629923;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JAf3pqkFnwq+zdsxVQQtCzWCRKHcpfVHtUf9wwuLw4I=;
	b=hLPIN9MUGlpFuBJIypL8kyMsuSxsVGSzMW/nK9OcuWkkG/N9PFuCMLKLUFB/bduiIe0pHK
	G0jxZU53UMZRAVCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 438E33EA63;
	Mon,  9 Feb 2026 09:38:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QC8kDyOriWnnCgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 09 Feb 2026 09:38:43 +0000
Message-ID: <ebc2eb77-722d-4966-8376-f11607de53c2@suse.cz>
Date: Mon, 9 Feb 2026 10:38:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 4/7] mm/slab: free a bit in enum objexts_flags
Content-Language: en-US
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, Hao Li <hao.li@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Puranjay Mohan <puranjay@kernel.org>,
 Andrii Nakryiko <andrii@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 "Paul E . McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>,
 Uladzislau Rezki <urezki@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Dave Chinner <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Muchun Song <muchun.song@linux.dev>, rcu@vger.kernel.org,
 linux-mm <linux-mm@kvack.org>, bpf <bpf@vger.kernel.org>
References: <20260206093410.160622-1-harry.yoo@oracle.com>
 <20260206093410.160622-5-harry.yoo@oracle.com>
 <CAADnVQ+rNYeb5Pu2aHRVc+hYDeAF5t19MVwzXsyn2HkOuLPNLg@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAADnVQ+rNYeb5Pu2aHRVc+hYDeAF5t19MVwzXsyn2HkOuLPNLg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 984E1C0006
X-Stat-Signature: 93zufw851uhrfy4atyge9p55uz3zoxsi
X-Rspam-User: 
X-HE-Tag: 1770629926-314261
X-HE-Meta: U2FsdGVkX1++lthPNwHT3La+hL3rCpw33EcJH/4ShzSZXts0cjXKhYw0Zq7FzdvGE92piOS2l0HhxGHPLl5oxdDLPceI6jCYYekfTAaq+/Aay4rpauKS53QiK6xyCaHeGIvW8TqjW0GP2+hJluJWR4yu9OHH0ogKvW+wlOSEvDIb+XzR3Q55Gx5Ux3ecgnXR110QbGLsWJphMVcHu/mEyV0kMnOViQ9c87wHP1wD13E9fzSD5fwcyxdzMx1vAkYQKSmX2GPVFn/xuX14tleNTNKP4EgAJAKCUTkL4Sx85hy+8l6WdeB6LSAXecgqNnvqPwgmDCWg/PzScBTf5qrgfVD8vn1vN/QwF44OCAq5nxN4Pob7vty91VJ0yBGCTjOq4FYi11/QQZ4gcwmpJu3GGmnURYqv9oKiUHTwkEaXmagNWn/GgkJxmZhFvHr8/MTJwPBbOmdvcQWTLslEC6XAw3XJUS+E9Thu83sIFNe61nvjo/5Z17zqnd/nlqD5FakbepudrSxJeqSKgpu4qNsLqLs1XM45aeiU65bQIjr8purTBPURBOuyE/JkHUABxX9uCxena1vqTgGZHMMlGiOiS71qdzKYfPq+wELnn5t2MT5YB0RNsXfQQUTHrl3p7UaLUqkaxppa/EOLZl4K3UAxIxFGkS3KItW1Tm7iU5dpg/sN3NCO7jgX4OEtKRxCKnJvz8wytT7nPKLnkvMYxk5QNj6meXH8yE2g5MN6GQPHOEMji0ROEOVkb+xLFrqZHeVhjeUNqw6GzRTaH2cK4doGbs0nKSVGuw9U9kg6CF2zkKIL/8dp3c7hXK4V6ssfhzaoaUxSD2WptMm92f8jl0tbhWbEgxwdufjXxJoWRiDfd4lso4dIbEUufLve+roMgsgGFgsToegr6PPgRfxnyFUwGKdm+rkXAO6Q9TwzfWGBqyb8EyMy5Rao7mJ6rOckJMllMOB3iIcLMcNBoN6fVMs
 GT3u69Uz
 DiQatIF2quy8HRs1CONoi8xhpTFhERQRNuqICSu/YvcHKradfsA+6hcURNj5kf9/ADenCgIkmSGxFyRdOGCGxxY/RvJnD2ePN7LPvPuEdJhMNXwGkQ0BEN1hKKC0mTQQpWlIOWjRLoo94bvRJeKcD5RLWzc1moPsC1orsVbMU/ixzTGIRizqKIo7Y7PvTemL/FI04kyOh2umUDU2BNsr+vKUjfEzsm3jy1dzW5rIVTYMEewICaSvI2lBGjq/HuAylF6np7A1iHwYbrHR7A0XYh2qkAl/NX4eCG/TP8hgf4V4kJg4OPVmqXNA78BxNHD1Q8pgdfCpVgWsbA4+mo/Ipc4FLIbsS3ZXnawK6hoSXSccJX2HaeWbJ9a/MwjQlayFRhpvkkzUdSdPh188zdKlT8cI1u/vtEfthEN3US3aLLeqVJRhycS22Hp7DLME7fLnfnehN2Qrszp5cfoVBbmutZeWCnhA79cKfyb6P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/6/26 21:09, Alexei Starovoitov wrote:
> On Fri, Feb 6, 2026 at 1:35 AM Harry Yoo <harry.yoo@oracle.com> wrote:
>>
>> Since kfree() now supports freeing objects allocated with
>> kmalloc_nolock(), free one bit in enum object_flags.
>>
>> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> 
> For patches 3 and 4:
> 
> Acked-by: Alexei Starovoitov <ast@kernel.org>
> 
> I think patches 3 and 4 are ready.
> Would be great to land them for this merge window
> (if Vlastimil agrees).

We should have an ack from Catalin for kmemleak. Also better take them out
of the RFC and send as 2 non-rfc patches first, with cc list reduced
accordingly etc.

Then I can put them to -next and try sending second merge window PR next
week. Can you also point to any bug reports that would be fixed? (that you
had to work around or delay merging or something) that would help the
argument to not wait a cycle.

> Patch 3 is tiny, but the impact is huge and
> patch 4 is a very nice cleanup.
> If we land it now we can start using kfree_rcu() on bpf side
> in the next release cycle. That will help us a lot.


