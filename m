Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BD35CA5FED
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 07:02:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DFA06B0092; Fri,  9 Oct 2026 03:02:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 990F26B0093; Fri,  9 Oct 2026 03:02:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 831236B0095; Fri,  9 Oct 2026 03:02:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 49BF06B0092
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 03:02:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A156740270
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:02:37 +0000 (UTC)
X-FDA: 85302194754.23.E4082D4
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf05.hostedemail.com (Postfix) with ESMTP id 71109100004
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:02:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=MT0jLKEg;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=vbabka@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791529355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TPxOKHJ895l/zZBrxoHbLiI9IaPlmjfGv9C/U5YFa/8=;
	b=oOQsOTYrDSPT22elgAKgDCYwwgbz8JTvBp5BrUqHEHC9KYxi1ZpZVKzh4DR1g3ZdUekAz0
	YqDtDmN2eEoaChbH2xGI184FrxQP0QO3H53m2pbe9PHawIT3SYUBAa+NKnBlAU6miMCwE4
	WpIPGmU3ZT+QmK+0P+rFBUYJ9W7zrVQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=MT0jLKEg;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=vbabka@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791529355;
	b=Lu4IUKtC8m1GTjLJnAonsLDFsb3t8d+CbEEosozyuP2xVVyqvHAUUTbFGuFcWlqQUs6m88
	yvPKx4cB03TdXp8maxOVEwf9E4oDWONT/3U5DuuqQofI7O3BtibSV2VK3SbeVQskcAmmDQ
	E05aiuvu1DhJ4F1g0eh0g2rRaciVZYQ=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a005aa0838so1408405e9.0
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 00:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791529354; x=1792134154; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id
         :references:in-reply-to:user-agent:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=TPxOKHJ895l/zZBrxoHbLiI9IaPlmjfGv9C/U5YFa/8=;
        b=MT0jLKEg2NcyA1dakpzF/WFeG1RaS+5pyBYiBKZwuphqGoso5Bmree94Y7kZS2mbYd
         scFwYVKQm0VsItyNu4B/Y9qCiuLsjfwZ065yZM9TEjQy1OHQ7flYJpVT8BADY4IQVs3g
         9//BmotAyiys/FX/ZpXPHDZMYM7vqiOhO/9EOe+lU1u4CX1VN+aNkYYmvnSKS31txvNe
         Pvdnt1uN9YVnBMAVNcf+HYMI8HnHY5/Gg+Jf3dLLpwH8BCQW4k5NESoMdoXmm4c9P9lR
         +GALGtVbGhrtrUhNnqTNgpF2f8FvElAlF+jiyOhnmZ5ShnskSCsDpq+UXKey7tkbnOAX
         AbEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791529354; x=1792134154;
        h=content-transfer-encoding:content-type:mime-version:message-id
         :references:in-reply-to:user-agent:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TPxOKHJ895l/zZBrxoHbLiI9IaPlmjfGv9C/U5YFa/8=;
        b=oI57idd4fPGeLUD9/nukk3AzLtRbro8rCQkFGXOvwdhuNSpqIPfxq6yi/YuvLg9Gd9
         0V9yQYUm7hAYpHdV5cleNvMHmcL4/dSPGzF8oLEUnb2slid1ioEcSHfdO1GdfFp/53O3
         XZ9ISLOHZY5uId7e+MMN4cikp0mg6RW+GuyBBcLGbO+VBQj876sfItIQCE8lnhYDsEU3
         w8BeyEah9sGvBOiuO5X3i1bFU5/iuBfL2WjwkNkBbVbc6A+pd1IqfyPjO0fwJXMQ4FQg
         SsbNocrUArPRTGbKCEuvxSQQcNP6+OhMDb3gjCW3c0wPGQX8TJs3Ad+68T7fFKYhBFXM
         zXfw==
X-Forwarded-Encrypted: i=1; AKwUvBzdVdlpjoHgaB+tOWxXU+5Vol/gVVBHqvrNbYGrG7KzrmZItd3U1/wsUAsb85GjgODBst78A0OxyA==@kvack.org
X-Gm-Message-State: AFuF++nssAdHwedjfETvbR8GPB/zr1hNO7rS9p9JgAforRCsY1waener
	LmWzqGHEzNM2jwSlDSFyV3dzJQWdnTeFFVbXqGWMsk53hmw+Hq3QYRE9iSrMcgB0PQU=
X-Gm-Gg: AYBFou3ZbX79U1VbnhbchlIaR4aXJbRYQvdoU2FbUxH4K4yJck5Gpx1Am4AOxHYnBPW
	oDxYsfT1bt6v4zxouTKBFTc03iAYU/FtjMYKJAxC0Ny84f6szlKgUuWiDNOjRD7k1lITl20bcpB
	6g3Wq1sxIaJTo+oH5ebYf+jQqyr72bhY0x1sTDZb4Qk4KB9A54hPWciWTkXbmlmUVreez/Ej44S
	o78kIS/CwERD2GP0eb091qLInsfkdSGwNe721ncgO9UcaZeMkEoJhklQS/l+XSJLJb/dctJi17e
	Ok7LkFm931wdFbHigG2JNACTk4R3I9zZDVJb1wFJW6ICY853tTplJGLSLpnseqQoat1Pgc98TCM
	ibOyYBws2VVnqNNea9Rei4LuuioK8B4I9Vh/YoGQwNgsv0Kldn85BBL16asTx8bnCbNmkfgLZSk
	9T4UpupRZiKXbSt8pyGZko0mj7Fhx+VDMFSw2PSI78UoQORzi3hTeJyp8Ds7dXDwNu6x72MFJMW
	4ItWg==
X-Received: by 2002:a05:600c:a086:b0:4a0:1f9e:5f78 with SMTP id 5b1f17b1804b1-4a18e3ea887mr15384705e9.0.1791529353543;
        Fri, 09 Oct 2026 00:02:33 -0700 (PDT)
Received: from ehlo.thunderbird.net ([2a00:11b1:1081:dc93:96ae:ba90:5787:8bd2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18be96549sm52255005e9.6.2026.10.09.00.02.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 00:02:33 -0700 (PDT)
Date: Fri, 09 Oct 2026 09:02:31 +0200
From: Vlastimil Babka <vbabka@suse.com>
To: Harry Yoo <harry@kernel.org>, Kees Cook <kees@kernel.org>
CC: Vlastimil Babka <vbabka@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Pedro Falcato <pfalcato@suse.de>,
 Kuniyuki Iwashima <kuniyu@google.com>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Willem de Bruijn <willemb@google.com>,
 Jason Xing <kerneljasonxing@gmail.com>, cgroups@vger.kernel.org,
 netdev@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_net-next_v6_0/8=5D_net=3A_skb=3A_isolate_s?=
 =?US-ASCII?Q?kb_data_area_allocations_into_a_separate_bucket?=
User-Agent: Thunderbird for Android
In-Reply-To: <asgAh4mrr_yd622U@thinkpad>
References: <20261006092030.got.500-kees@kernel.org> <asgAh4mrr_yd622U@thinkpad>
Message-ID: <70EBD8E2-6DBA-4758-9CA3-D5CB661CD3B7@suse.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: kfg7pkj9ba49j3ooeg8bxgeq16pzo3ak
X-Rspam-User: 
X-Rspamd-Queue-Id: 71109100004
X-Rspamd-Server: rspam08
X-HE-Tag: 1791529355-889154
X-HE-Meta: U2FsdGVkX19G27l2eF91cji/5I1HQm0fwqLZ8NYq8981zNfiewK+OU/dmDtm/CvAiu0ifbEqhKjW4KGUyLJIc6Ee6pQyMIljXVhrHf+xY+IR+hFw+CQS5ZQEvnhn5uSpf3vkaXFlTWKeRh487kDO/Is0ZK7rPZvF213UlPoHzsmQ8EAR/EZSmbf9ND2TcXE4uChJKCQt+AutiTdvXiz2hQCFREVOseNWNmnA2SJ7S9FtJ90dGEXY62Yu2PnVIMFEJ7gQMfXq9RiqixcsbSxFNRX8aboJaG1E0UIVow04RRgiH6I0t5nNLjYJXQzBHoyCCE3NNDh49AYOjqwIJvveGXKYJ1oE/OZrmoYHr899js/KLPX9Cz4INY26h1CdSpLkozLWSeaFFKYHhRru01CvTpJNQb1z3BO4ouwzK5ziCsfgVT8iFHVCNn24gh5ZyRNzUV5ksElS4lwbqp/NGAt6RW48DnbAnzXTiqQP8N7vk841Nr5mafXPoEy2tDAQ7kGMPIMrXz0At4Z08k/hmOG3CZPaYlOrr04WSRG/q4gSOdw+ll82eTvnFWzSiPQrLqdGKYe4PpXEBJ5OaNPsd0joJOnVoQRyVnuBgAL9y2WqrmpqkiIgCr475VTi2WGXvE17b6/1csoKDzkopVe9Cnv68yAkgYbGWHcO6YGGa8kXS88VxIJ749S+DwOMy11RiyFCfDCVhyr/ZRc7D39rQYRPtHQYMZCOWllfq9kyMyZhjQAkt0+PZKyP3LnwBXeAG/eP9vlsvNFVECzIIMx18h2eAoFOr3Y1q/W3hO62FSFABxrLPNXH8udCJGp0eWKDwsS3REFnVwQf0EoOZCJGfo2mEd+7idyecCxgjNIcEcr/G67Qe5s+WZ17A0/6uF9MVn14fgodmyqzGmLqreJqjtaPAJ/Rw7YKRcMp6IZSczcNPyWPn0YFfR+y2f6WSkE2Uz0hurtfXiCsp4Wcsn9IsSu
 Q5WYjGre
 hLN16090C6L4FhSG4GCqj/VBQUvAvYZqZxdd9Eeh3eRH/nImarbataDt7BMT7CeCEOnwCuZod0r+WR7xZot2gTLmx8GTrD6a6yWFgUbMEODlMYyC615wcA7Lo4NsAsk52T4u3kEzrqpBVa0GfYCqc18UhbNpHj3VB33YG3X9NVn1XdzndEYiTXImIe5ve9lYNk3zsgw7llqBpUJn7XIuymd6jGgJcb0VfQBynhGxMP7jpkcQPc60qS83JsJCHYcm5qU93cxF4VchqYkmNr/je1Q6FG8gWQnvosdB8ufU7dBa/iqxYsJXgA+2tZz/thHr75MLqpMaUVqKxdGrs2FQ7kTiOskwCilCdZ9/864DGzdhBUwOzxMS7TaYA+1eLDQciexT8uQhDg1vDp0P+CeU3Hkk55gTvnlWMYwi/LH786lE76tJMTdEd3UCPfEkXk01PFppErrB0EB5kk3x30RVbaqlcu6p7wsw1mTJ10QAcIKIaysInf7EXEnPzTFkx99eUPo2X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On October 8, 2026 11:25:13 PM GMT+02:00, Harry Yoo <harry@kernel=2Eorg> wr=
ote:
>On Tue, Oct 06, 2026 at 02:20:26AM -0700, Kees Cook wrote:
>> Hi!
>
>Hi Kees!
>
>Was hoping to say hi to you at LPC but I missed the chance ;)
>Maybe next time=2E Safe travels!
>
>Uh, my mailbox stopped working for a few days as I forgot to renew
>subscription=2E (Kiryl told me it's bouncing, thanks!) Hopefully I didn't
>miss too much=2E=2E=2E
>
>> This gets the buckets able to handle memcg (GFP_KERNEL_ACCOUNT) with
>> isolation (since it's common due to AF_UNIX),
>
>Cool!
>
>> and GFP_DMA with fall back
>> (since it's rare)=2E
>
>> It gave me an excuse to build out bucket kunit tests
>> too, and that (and LLM review) found a couple other issues that needed
>> fixing too, including msg_msg allocations going uncharged to their memc=
g
>> when CONFIG_SLAB_BUCKETS=3Dn (fixed in 2/8)=2E
>
>Oh=2E
>
>> Harry, on your v4 question[1] about bucket users giving their own
>> alignment: I tried that in v5, but a set's allocations don't always
>> come from its own caches=2E With CONFIG_SLAB_BUCKETS=3Dn, after a faile=
d
>> kmem_buckets_create(), and for the DMA and reclaimable fallbacks, they
>> come from the general kmalloc caches, which can only give kmalloc()'s
>> alignment=2E
>>
>> So v6 goes back to mirroring the kmalloc cache's alignment,
>
>I might be missing something, but why is that a problem?
>
>For kmem_buckets users, the reason* to specify alignment is because
>they might need less strict alignment than kmalloc=2E
>
>(*Perhaps it's nice to document that in the comment)
>
>However, because kmem_buckets can fall back to kmalloc on e=2Eg=2E kernel=
s
>w/o CONFIG_SLAB_BUCKETS, it should be fine to fall back=2E No?
>
>Creating kmem_buckets with more strict alignment than
>kmalloc doesn't make sense=2E=20
>
>> and drops the ctor and flags arguments for the same reason=2E
>
>Uh, for ctor and flags, yes=2E We can't have them in kmem_buckets=2E
>
>> And the whole
>> exploration made me realize I had a completely wrong understanding of
>> how memcg worked=2E :P
>>=20
>> The bulk of this is mm/slab, but the final patch is netdev, which Paolo
>> acked in v4, so I'm hoping this whole series can go via slab?
>
>Going thorough slab/for-next sounds reasonable to me once it gets
>some reviews=2E
>
>Vlastimil?

Sure! If you review and feel it's ready to be added there, please do so=2E=
 I couldn't yet due to conferencing, should be able next week=2E


