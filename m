Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FE6BD2D0EA
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 12:50:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 045766B008C; Tue, 13 Jan 2026 07:50:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 023756B0092; Tue, 13 Jan 2026 07:50:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E725A6B0093; Tue, 13 Jan 2026 07:50:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D78BE6B008C
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 07:50:37 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A677B16012C
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:50:37 +0000 (UTC)
X-FDA: 84326924514.14.C964540
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4688C4000B
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:50:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PtKODF2C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PT3EfSwo;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZSqy1HgV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EG7JhaQ4;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768308635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2njxT4444vBXRDjwl5oV8xG18I9Zx+u69QZ0TThv5yQ=;
	b=rxRwt3ClHBR+6NLFUOzjUPkF5i98meiqXn2nDRlKUczB8bIjnoNZPLdXkQF/e6nbbZl73Q
	WkZID4eDg2OS7GacpaiGWs4BmzPs9xKS0QQf7GqluKtOaV7fEgahKX7p9q3bzMqagfPWo2
	klRITuO6OSvazR5IZovnehcWk0sTFHs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PtKODF2C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PT3EfSwo;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZSqy1HgV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EG7JhaQ4;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768308635; a=rsa-sha256;
	cv=none;
	b=RBSgtum/jGiKp3cP3PsIKEjCvXVtO5XKoJLQEB+WrxQdr2YSsQ9MU2TwmVKopfO7FU2UTF
	J7YE+E9uwE/E3TKBoa602yUFpmV7YKRGcwjFM5LozMOYE8RULmx3UXBH/juvFGkXSeQcFK
	M+zSfZ1V6/LXTG3F4I08n3ntsGCRTkM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B86A45BCDD;
	Tue, 13 Jan 2026 12:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768308633; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2njxT4444vBXRDjwl5oV8xG18I9Zx+u69QZ0TThv5yQ=;
	b=PtKODF2C89mNQqZDnNW2Ix+E9RLbAX94raLi8h+W9Y1olJTvTw0oa/89eqwUySXclG1WBW
	95G9xw46Y7qgGlCVcEZHRvbSaStEd48FmkoXPKREfZSz/EWbmGkkm7qgCSi0icYohGOa32
	c7hJm/eHvi7soMeADZNFEmsoVYLRLs0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768308633;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2njxT4444vBXRDjwl5oV8xG18I9Zx+u69QZ0TThv5yQ=;
	b=PT3EfSwoctTCsX9vB1Ictmh6xkEmd0eEmdzyC0Jr2biwYKQCtE8Q44XvRPgSkP5fP5bkPb
	Klk3Cc+i/j3wyADg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768308632; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2njxT4444vBXRDjwl5oV8xG18I9Zx+u69QZ0TThv5yQ=;
	b=ZSqy1HgVgimt5AtDjjv8i7a1DInik/wFsJk9b01D5CW4aY7HKqj+ofIOJmYnmdTGo3C/wP
	OMBE4bITRvIaFw3JaDIF7MvHEqBV+5Vg+2NQXDBinpjGsHpXAJ7euc9fc6AXt06y0Y9wJv
	w0cr5u1+rpleAm9sQ0OdrIV4imqElB4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768308632;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2njxT4444vBXRDjwl5oV8xG18I9Zx+u69QZ0TThv5yQ=;
	b=EG7JhaQ4NfhIbtJG05pU1lrvSj3BJrfB5/DXov0pm1cTgI+VHZxvL3YqbPo8oLov1Ue4+6
	RAOVPfao0Q82/KAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6D3B93EA63;
	Tue, 13 Jan 2026 12:50:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kTzPGZg/ZmlzagAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 13 Jan 2026 12:50:32 +0000
Message-ID: <fecd4166-618d-4d69-be02-d9b3e8f0f271@suse.cz>
Date: Tue, 13 Jan 2026 13:50:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V6 9/9] mm/slab: place slabobj_ext metadata in unused
 space within s->size
To: Harry Yoo <harry.yoo@oracle.com>, akpm@linux-foundation.org
Cc: andreyknvl@gmail.com, cl@gentwo.org, dvyukov@google.com,
 glider@google.com, hannes@cmpxchg.org, linux-mm@kvack.org,
 mhocko@kernel.org, muchun.song@linux.dev, rientjes@google.com,
 roman.gushchin@linux.dev, ryabinin.a.a@gmail.com, shakeel.butt@linux.dev,
 surenb@google.com, vincenzo.frascino@arm.com, yeoreum.yun@arm.com,
 tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, hao.li@linux.dev
References: <20260113061845.159790-1-harry.yoo@oracle.com>
 <20260113061845.159790-10-harry.yoo@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Content-Language: en-US
In-Reply-To: <20260113061845.159790-10-harry.yoo@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xb8z6og6hospq4a778b7aawe1ucj7mkj
X-Rspamd-Queue-Id: 4688C4000B
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768308635-300804
X-HE-Meta: U2FsdGVkX19Yfk3wK8wkqNhUJKskdWDTqPFdZTU7KQtilZmMr78YHntsnuy5u+ebW/kMXcOsHhPA2YObzihQ0hqI+bC5QaekN6qR/y91U7ZiM/eiFluExJ0i6X2RAluaRnlqEJ5dW+dPzVi5PitCant3MWWY/d2gav8E6CSAMNl7WzXAFnNW3se2PM4HK+konQTJ0T0xBQk1I51oqOSmPG+SUKYXr2kdgF5cZ7Smfyftc/w5LTbMqFlSzgD3kj3GgEyhUmq3rTTi0BqWrtH2nZmat2AHfjd2M53eciEM5VjHA6LlXe2VyDNbONVuZWFHggbXynkgpU/OrTmWXc/UH1QMO1uXNtTR+yVxx08Ol9EA+G+uUv8YgXe7x4HRlpZ3vgss5f+aUBglVfTt4aO4Z2ez57lBUYxUi8gdvskJEkVx4IgsDn2SbdONa1UMYSntUGuXI0r9+oYqjtVFSn/sHhdyFf3o9vd0Ap3D06EfZZCD6OYIqOZ1Eiqq597MaD1Cm81aQrl+iTMkr3xsiMFZfZTNGyd2CVg1vw7iLoumT7VFX8PpEs6snyHlUxYnmVhtsQAPSupcdHmAWfhBWge/lfqPgT2dL6hGNaMGfoK7tbAL/b8A9Er41abAGrMqJbONjrp/BzBVzt5DzepF+77TmFnTEWEejVMB1UvUGoDv8tAk8eG9z+7A7tLV8oBqA1qmm+oLj3czoN8PmD2hpT5uzJRKvNxK1OL8k3T5Y+dL3TJDmFqAJZnQdYPQ3hbV6CKLbhIoiZrInzgUPFU487o6oKZ/jNK3qb9RPx4uYMAGx1XjHunfBaYHj72YTD6tv7ot1OiXF4Rn1NQQXl6St0DYC+LLdAWy7838tOW+D5qm/p/QDB6dWG41sgJVY/E8/homynYCeidsKIxf+Ipv6ccZNWIrfUddZ1tn0yoaTJB+3vi4HT1beJkH5RfKNBtMG2m/EGFPWU6SCBVLsnUajVu
 1KjA6fGp
 nBeXnfOFfX0b5/ATLGcj8KDkVwu+x+Qj4d2RCHD6Z4wj9MDR04AutrPKH5N52Zx5114G9L7UUzxOqLZ1WD+JB2DX5G9xYPAs17l2o177qcLYfrRXUvraAUvwDDQZXT0AaLfjDYjvV814dKT75rLkLjKXyHER/M0RZCpViJIWhB3BCfliaRr6xJWWMR9SaJGi/fee9XDh+eXiSqYzq+t1wULme52V4ZKziM6zC2gIYYonXyeBpW+yGVcHc8FaCwNara6Web3G2acslMBF53P6JOM2a40103rdbOnd/FGo2UkP9GpyHJplN916ZBThzDhdX0hciDd/4jzi8S/ZsjklF/9LGZFYHpgQGh2yNpb/2MjexXHvHkuK0ph4y8/ELYmu0xQfelkDYMz3xo27Gj0viLl/ZjqBXugedJdCBK3EgM6RIJjU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/13/26 7:18 AM, Harry Yoo wrote:
> When a cache has high s->align value and s->object_size is not aligned
> to it, each object ends up with some unused space because of alignment.
> If this wasted space is big enough, we can use it to store the
> slabobj_ext metadata instead of wasting it.
> 
> On my system, this happens with caches like kmem_cache, mm_struct, pid,
> task_struct, sighand_cache, xfs_inode, and others.
> 
> To place the slabobj_ext metadata within each object, the existing
> slab_obj_ext() logic can still be used by setting:
> 
>   - slab->obj_exts = slab_address(slab) + (slabobj_ext offset)
>   - stride = s->size
> 
> slab_obj_ext() doesn't need know where the metadata is stored,
> so this method works without adding extra overhead to slab_obj_ext().
> 
> A good example benefiting from this optimization is xfs_inode
> (object_size: 992, align: 64). To measure memory savings, 2 millions of
> files were created on XFS.
> 
> [ MEMCG=y, MEM_ALLOC_PROFILING=n ]
> 
> Before patch (creating ~2.64M directories on xfs):
>   Slab:            5175976 kB
>   SReclaimable:    3837524 kB
>   SUnreclaim:      1338452 kB
> 
> After patch (creating ~2.64M directories on xfs):
>   Slab:            5152912 kB
>   SReclaimable:    3838568 kB
>   SUnreclaim:      1314344 kB (-23.54 MiB)
> 
> Enjoy the memory savings!
> 
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>

Does this look OK to you or was there a reason you didn't do it? :)

diff --git a/mm/slub.c b/mm/slub.c
index ba15df4ca417..deb69bd9646a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -981,8 +981,7 @@ static inline bool obj_exts_in_slab(struct kmem_cache *s, struct slab *slab)
 #if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
 static bool obj_exts_in_object(struct kmem_cache *s, struct slab *slab)
 {
-       return obj_exts_in_slab(s, slab) &&
-              (slab_get_stride(slab) == s->size);
+       return obj_exts_in_slab(s, slab) && (s->flags & SLAB_OBJ_EXT_IN_OBJ);
 }
 
 static unsigned int obj_exts_offset_in_object(struct kmem_cache *s)


