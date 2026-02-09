Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9365E7E0D0
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 19:03:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05E106B0088; Mon,  9 Feb 2026 14:03:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00BB06B0089; Mon,  9 Feb 2026 14:03:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E25CD6B008A; Mon,  9 Feb 2026 14:03:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D0E5D6B0088
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:03:15 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C96114025D
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 19:03:15 +0000 (UTC)
X-FDA: 84425841150.17.AC47F9A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0BC83120006
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 19:03:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aolfs34n;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WBF1wx9P;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PmI65mGX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=86I0eajt;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770663793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iz+3BgP0bUY1a1YqCnKkZ46exy5/MLoyATqZT2mlts0=;
	b=oo+LVvfj2+NiOosfH8dv3t0vALzZGwM52YUmYvowW5ORgUQaRhb4vsVsxs+qbwfq+axh3Q
	9fU2IRBMgILnnS8dqvZ8lRE38xqxY6E0dVCkL6nhXI1CAjumEvpubfPDLCiKWMnHLJPJRe
	/OXhIPhjSxvOOogSUeCW0UKbfX9PLj0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aolfs34n;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WBF1wx9P;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PmI65mGX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=86I0eajt;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770663793; a=rsa-sha256;
	cv=none;
	b=I5mbU047rYqh2/GVanBDKNASq7H+OH5kl+Ms7NOO9fe8hoSAl9eqflwYd9h1rc2SsV+bQr
	R4o5jQyRrD/9BGJz5HZuhiEAiZlFbTzz4XdnnGz/QgQsV55ph8eW4BGk2UZgks9++yQtj3
	zfs+7zb51kfLFLIvu2KEl49whHtM2Y0=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E02415BD12;
	Mon,  9 Feb 2026 19:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770663791; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iz+3BgP0bUY1a1YqCnKkZ46exy5/MLoyATqZT2mlts0=;
	b=aolfs34nZyKUzXupgYGcoRDVCpAudWTz8c2Xr1IP0VXvqdn6qRs07Ui/MO4PvpzKHxqkbq
	1+GXFzIW1BWY7OBSM0F+R1JoeVQFU6ePd+/kdRwfbvvoF46AVAXvtL4Vo/5pKt92uMpRcm
	uGeX9D2lKT79nwZATpFYk3A8zFOkbU4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770663791;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iz+3BgP0bUY1a1YqCnKkZ46exy5/MLoyATqZT2mlts0=;
	b=WBF1wx9PQ0kRqzH2E5FiK3Nekp3Ml828AhYqWoIcgZMJQT8uo/bz+LApFg2Izg1AdnPW5D
	3m7sAANGSyga0rCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770663790; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iz+3BgP0bUY1a1YqCnKkZ46exy5/MLoyATqZT2mlts0=;
	b=PmI65mGXE8i5aipFmCsXi7mos0qOxexkU11yaIkxW2MREo8wrXll8y1IO+PaXG/w3mxE41
	k2OsOUHxv3wNPsKDSQ4Y5dMAQHJGxzDmBWmpAmRuZ24I7yUXQ9BvHcDQNYqe/NSkONk8N4
	RNHUxz9ij+69Os+4YB4Xx7pWvvPRXAw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770663790;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iz+3BgP0bUY1a1YqCnKkZ46exy5/MLoyATqZT2mlts0=;
	b=86I0eajtAUfslRNiV5i2wWcbx+EDnhEhomgtFu5uuqBkUaF5XRuMgu40aUIBmv7zkyDqlX
	SHWSlEBxssHbQYAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BCF503EA63;
	Mon,  9 Feb 2026 19:03:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WShULW4vimnsTQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 09 Feb 2026 19:03:10 +0000
Message-ID: <e37a697a-7670-4f92-848d-9030712986cc@suse.cz>
Date: Mon, 9 Feb 2026 20:03:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm/slab: fix lockdep warnings with kmalloc_nolock()
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>,
 linux-mm@kvack.org
References: <20260206171348.35886-1-harry.yoo@oracle.com>
 <aYYm9ICnlB_yu7PS@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aYYm9ICnlB_yu7PS@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Stat-Signature: rmrrk8jx3xs1zbxuaskcmxkt3oq1tbgd
X-Rspam-User: 
X-Rspamd-Queue-Id: 0BC83120006
X-HE-Tag: 1770663792-623870
X-HE-Meta: U2FsdGVkX187P5/PKLywSJ8fSpdYhTuOO60Rm7fvA/+/Fefa1VUtOkbvaZ5WI0FFDQ1OMTG/HQhn8FoiHKrOAFPpfWrgoI21PfE+XIE/3ylSnqF6fgTjZ5kfEl0SeINZPKcPMIwOpVTpddvpNFvYXDWbO1jjiYih+R6ec4N/ZFrG+GLslBbPEIVgnaDeWC45cs+8J1ybajuJKbRkVGDsDgv23xkDNkuGurIwEaCXdsA7+56q1mmyrs/aSA1ea8Kf42dibBONWqmWvx17uchVEylpGBaFpOVOByLMt0hsj0TC5OXmJNAbT5XidX2Ha4f/FiMenSKfpk5xQNJM6Hjch8GdD25puphGz2fDtLBnEz4085OiFlBzx2SToSTGLh4OLLFyMX1IRyUDsPOVlQV4k5stv/JaACjL/NR1xMJnoT8Cvi0HWlvJeSi95V9+Owtpzn5RqgD1DaSS4uCRiTxQTTVX2ECFSMhHbVb0JXGVw48K6Fh/Tt3+k0XTO2vnMS/WmYbVIFK7Kdj8RCTAOrW1E1bT0V9q02DP+3rnA7Sk4EeCAf/xTIgnigOKpgklzow19iGClRbIfC7h3VfjLbJX8Gt4m8qoHZQncRSiiirW6HZOLAKf7Ep805u1B2bttv9R3ig36VBDdun+imm4uh4km/T42MKE5HE0JGjErPB6T6fnMRsGPsr8PybRFUCI/MM64ZQgwrpgo9wa6GvK+SWvEm5aJ7Q7dY++oGEUMq6AitnyRno6VX1/AGSwsFSV9tfkEoVn+oh6nITm86KF+4jyzmer4Mlp+uL3lmSjQLkDaxchLOrx1KCt1wbSk3YbTOCME4RSePYFRDXm7gBsMru/nGJu5XzYvQFxG6kuHvJpJTwtxraZ01GZVU/kmRXWlkzISBU/9RaZYemxPwdeaBAM+EH/oR5q8yfDuTVzKVZkCbjmEc4E1mc+Sm23UDy8XdbNipjVsb0NQEkmffJVHgu
 Nk1JcJ5v
 ovsfO+oEBwyVxUTG9JaT3Bgwq8nBlDrjKTLNcjugyEmwKuM8mw23tC/naaf0+rC15XeUVsSvAy80uJWBZeZ7PrymfjnLxm9Vc45dwZgdH/hT+Py1Nt/fEhqUI3PaDiigjUE99zI5rj+fevD4uppSgjzWRIdRGleXhaKBXVUF4ip4Hqw0Zt+UvZLGK7Hkxxzo4bwTTE+n/IzrzTfJcu/5h1lP6dy2DyUxjAzhTrMo+S+LZsUYqOXjiqs66f5vtHfmZdljC/TpPSf7qerr+qdnk57ZlybtfcwHAg+HCgc29BgRHCkoCRTNSad8ymvu78UVXRkqRhCVeJr+N148=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/6/26 18:37, Harry Yoo wrote:
> On Sat, Feb 07, 2026 at 02:13:46AM +0900, Harry Yoo wrote:
>> Hi, I've observed a tw lockdep warnings while testing
>> kmalloc_nolock() in NMI:
>> 
>>   1. Accessing current->mems_allowed_seq seqlock in NMI isn't safe
>>      and lockdep complains.
>> 
>>   2. w/ CONFIG_SLAB_FREELIST_RANDOM, get_random_u32() acquires
>>      a local_lock, which isn't safe in NMI and could cause a deadlock.
>> 
>> Let's fix them.
> 
> I think we should probably add some sort of
> kmalloc_nolock()/kfree_nolock() test cases in lib/tests/slub_kunit.c.

That would be useful, yes!

> These haven't been discovered by bots because (I guess) it is very
> unlikely for bots to somehow trigger those APIs in NMI.
> 
> Also, I forgot to mention that this is based on slab/for-next:
> 
> commit bc33906024eb5955294e28128c3d0f492d2ded5e
> Merge: ec15c383fcda 40fd0acc45d0
> Author: Vlastimil Babka <vbabka@suse.cz>
> Date:   Thu Jan 29 10:10:50 2026 +0100
> 
>     Merge branch 'slab/for-7.0/sheaves' into slab/for-next
> 
>> Harry Yoo (2):
>>   mm/slab: skip get_from_any_partial() if !allow_spin
>>   mm/slab: use prandom if !allow_spin
>> 
>>  mm/slub.c | 36 ++++++++++++++++++++++++++++++++----
>>  1 file changed, 32 insertions(+), 4 deletions(-)
>> 
>> -- 
>> 2.43.0
>> 
> 


