Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95A0FCA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 09:38:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8B016B01A0; Wed, 27 Aug 2025 05:38:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3BEC6B01A1; Wed, 27 Aug 2025 05:38:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE27C8E0105; Wed, 27 Aug 2025 05:38:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A97466B01A0
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 05:38:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 53E5CBA0DF
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:38:26 +0000 (UTC)
X-FDA: 83822037012.08.692636E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0C071A0010
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:38:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oSc2dwOY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0hgJ6JyX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oSc2dwOY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0hgJ6JyX;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756287504; a=rsa-sha256;
	cv=none;
	b=yWiEecIXM3fHbF72wovYogMTrVQrDQ53qRCJ/u3KK8Gb4k/D8owSE1Kgi6ZkovAtIMaGH4
	hXBb4k+8uoq+h4F9s3tFezOs3B34h4IScr28zp0Tq1n8bED9UHn14kvB8qqUI2HZEx5z4+
	jAWVxvR8UUQ+mm790IL8P00UyMHg/jg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oSc2dwOY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0hgJ6JyX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oSc2dwOY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0hgJ6JyX;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756287504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KJWgO44s06wccYVolA1EQBaeBYg5Fl8voqWyOGe0NwQ=;
	b=FY8YfIS9Gtkzg5tk8fZSZPWCxKj7Rz0D3mOzTjQ/fFVQ0BUr+Y54jR25CDiLhTYufQFC+a
	NlfHzrnBERlLHLy2VeI9Oykc8Pag3g24oPE/O/b9FsHsuYj7yfZyQ3FE1z+Pvz+bif1VRx
	sICd3KiQZPCafzAV95YNJpJrDT7Utjk=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7272B1FFF7;
	Wed, 27 Aug 2025 09:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756287502; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KJWgO44s06wccYVolA1EQBaeBYg5Fl8voqWyOGe0NwQ=;
	b=oSc2dwOYy+0PVUQ2NZPetZ/enoZJYJkyC/+/+Bl+zGGBaoKDEjDxDA6Bnsn+PHE9YSgedP
	8I5NmkYRtFodTaecDFIaHnS7T3mHzlb43L3LlRyxUnb33yNyvORiIV1eCUzZbvQAFBEuQd
	0kKdzCloxqZ2SYUbVlCVp5UUvavQI8E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756287502;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KJWgO44s06wccYVolA1EQBaeBYg5Fl8voqWyOGe0NwQ=;
	b=0hgJ6JyXSOc6VwbQROzSI4h8UClqJtBzbJv8vSnLm8qmzBRnUk0hNmTMrbSNUD+Ldu5vbB
	MLTPtZoEAM02+8Bg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756287502; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KJWgO44s06wccYVolA1EQBaeBYg5Fl8voqWyOGe0NwQ=;
	b=oSc2dwOYy+0PVUQ2NZPetZ/enoZJYJkyC/+/+Bl+zGGBaoKDEjDxDA6Bnsn+PHE9YSgedP
	8I5NmkYRtFodTaecDFIaHnS7T3mHzlb43L3LlRyxUnb33yNyvORiIV1eCUzZbvQAFBEuQd
	0kKdzCloxqZ2SYUbVlCVp5UUvavQI8E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756287502;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KJWgO44s06wccYVolA1EQBaeBYg5Fl8voqWyOGe0NwQ=;
	b=0hgJ6JyXSOc6VwbQROzSI4h8UClqJtBzbJv8vSnLm8qmzBRnUk0hNmTMrbSNUD+Ldu5vbB
	MLTPtZoEAM02+8Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 637D113867;
	Wed, 27 Aug 2025 09:38:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JQvmFw7SrmhoGAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 27 Aug 2025 09:38:22 +0000
Message-ID: <78d9c50d-c243-44ea-b9b8-81eca877d619@suse.cz>
Date: Wed, 27 Aug 2025 11:38:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2 2/2] mm/pageblock-flags: remove
 PB_migratetype_bits/PB_migrate_end
Content-Language: en-US
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com
Cc: linux-mm@kvack.org, Zi Yan <ziy@nvidia.com>
References: <20250827021121.13645-1-richard.weiyang@gmail.com>
 <20250827021121.13645-3-richard.weiyang@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250827021121.13645-3-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 0C071A0010
X-Stat-Signature: 9t91o4yoab4p81k9dbcujuuuj1y65y4p
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756287503-482044
X-HE-Meta: U2FsdGVkX19WTSq5gjZN49eaMW8tpce13gRgZirhWUywLQL/Wy6W4KJJIjRT6IXEjTuBiEKSvX0rzX4kHN7UHO05BQuWziansMgYjJ2ul6a/uvWxuHlwCpg9Dzcr3t55+lU0nZJ5cnuPEcqXGGGUxUcHhZwvXqkf41K4DDJREkysyT9GCRkFSBH8Ugit33NgLN/MHrhtRi9dtonyymh+iKl9ngMXIlcRKdaiPmMxdYQ88nHf7D9ND/sQ+Fv9eGyxm6ZSYGXsddqaWybT9Q7AcFWwJAuaEqBpB2cPueYjn7y/hkRiiTTyKBvBcUIWsHc+mqkucyA5wU62Gr0Lfn4H0WK23Zv2nljK0IvlJPqaQWIpFMrgH5dCApiNmRWp2Rpd1dYNeW7ruWNShhhrQpTco4VlxuF6AoXeWrV7mSmi4nmnj6JFVsMvXUX03mIF1fpRsEB3JVK9YyawNkzpbGdgtotwjS0PymyOH7Hwpy7Bv2fVvWYr8WjbYB8Nd24vc5PEZnVx8QKMqqglB9/zzFTExBzUvz1JDFJbHq6XDw8vzgeORMp1b49hw3gdUVYy7XalUWtNNjomqZqKkIjzuG5Alj+CS1k2uLZ2kqxp6484gwePRpoFghElspN7bRfvHZnX4G2jCa0ub2MBgeQH8aX2MynWQ7NrhIhIALKAeEj/T6E4S1bldzmeR3C2ZszC/LleAwGhQK0NFTnUNzZXwVmdihxbBSKDZRhxrMOarhXanJqNIzauXiFhLAZMuuC0k44GFsIk0xAwaiqan3O7dXMMserYjY038C/sGHWwGqZDrAbvf8AMDKbPAlGpKK0W+b1JR48vv7LE37CRX4rkVWEp+0Q+T7fuDsJnK6M81/Th2hViObB9osGTKAswv+tfwu9hfZlxDauTdGV58GklRTVoDWT15i7TK/1c1uvhxtwT9GGsovM51cTzH37e4pkQPR6+/t61hT4jzKdLer5XaMi
 BnLSkJ5t
 4wD2D3qxmr7Ib2h1R4dYUoDU3pkpOX6ZGlI3+ihWLMOKZs/A2iLbbTjZ/q5I0LKV+YT30a7KV5+DSWnAye6UXnW3d68gxHQ7DAPPqUKYnBK59aejarQTUvkDu2XiCiRB7Mt0JS7l/DlPreVuZarr5IfP8yH0jyzV8d6z0n9x8/twcHCM3cyYtwsnotJ6NKPtNey7kxiskupT7CwAK9jzsBQz6GIy+AU8vkMTSFgxMCE1YIXOv1cUfa3G5DJBb/jfL+r81M725Y6Wu3X/wD2WLK1gCkzO5p+Nsy9m8Zf1fofnv/PXyAA0FHOGm+2tA6EX+GSFCnz8lW5hP4mm2OOqwIGUBUB+JiY21/QJkd1RpB5iKcbwoucQA8YqYACAFYszUKb1CBbbtxDyTnmCwy9AWCHKuMpr2uUrq7Ij25eCcRSaL2D53nrSsOZge/6nlf/EZlw4QLYFt27YvxdBnIYgOyhgb003ceUIaGEcR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/27/25 04:11, Wei Yang wrote:
> enum pageblock_bits defines the meaning of pageblock bits. Currently
> PB_migratetype_bits says the lowest 3 bits represents migratetype and
> PB_migrate_end/MIGRATETYPE_MASK's definition rely on it with magical
> computation.
> 
> Remove the definition of PB_migratetype_bits/PB_migrate_end. Use
> PB_migrate_[0|1|2] to represent lowest bits for migratetype. Then we can
> simplify related definition.
> 
> Also, MIGRATETYPE_AND_ISO_MASK is MIGRATETYPE_MASK add isolation bit.
> Use MIGRATETYPE_MASK in the definition of MIGRATETYPE_AND_ISO_MASK looks
> cleaner.
> 
> No functional change intended.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: David Hildenbrand <david@redhat.com>
> Suggested-by: David Hildenbrand <david@redhat.com>

Once fixed as suggested,

Acked-by: Vlastimil Babka <vbabka@suse.cz>


