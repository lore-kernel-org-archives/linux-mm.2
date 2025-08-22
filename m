Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B3A3CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 04:04:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A876928000B; Fri, 22 Aug 2025 00:04:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A37B78E0056; Fri, 22 Aug 2025 00:04:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94DC728000B; Fri, 22 Aug 2025 00:04:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 83D2C8E0056
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 00:04:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0BE40160614
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 04:04:10 +0000 (UTC)
X-FDA: 83803050660.26.7414E69
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf07.hostedemail.com (Postfix) with ESMTP id A233540003
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 04:04:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of libaokun1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=libaokun1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755835448; a=rsa-sha256;
	cv=none;
	b=gOXhO3daInPCi9PLlGqsHNG5TVVJsBymT8ApXqoOjoatmxpyXTsaAmp4OZ1h+MOeI9kM7q
	mSJZdn2KPcwCr+PoRU7AjFgsWw0VzYy9+sse0DuV3O+2zuDyYBeRL50G1nnzFp2QGLhQcl
	HX4rWdg55rbPZ/0tsFfDiu3rSoY6cjI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of libaokun1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=libaokun1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755835448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HqHV8cROYxDJed41Ju31wh48gFYXf2A+JyMAjK1+oWA=;
	b=A04J8PFg1y5PCB6vXEq3B24XrM0pc/1U3rhAQSnWHbHw1yz83itGHdexEXYkr9yKcr/C+S
	MwxNpzDJXwq2HVzqTvG6xfHjUnPXv2gOuXa5WVmvS0DpeCrd8gNoezacB4M/+5vp/zOg0B
	H2wsuTD9DWTfT4C+n8iUIKY7+Qi3Htc=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4c7RK46Yvkz2CgGc;
	Fri, 22 Aug 2025 11:59:36 +0800 (CST)
Received: from dggpemf500013.china.huawei.com (unknown [7.185.36.188])
	by mail.maildlp.com (Postfix) with ESMTPS id 740E71400DA;
	Fri, 22 Aug 2025 12:04:00 +0800 (CST)
Received: from [127.0.0.1] (10.174.177.71) by dggpemf500013.china.huawei.com
 (7.185.36.188) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 22 Aug
 2025 12:03:59 +0800
Message-ID: <b5e588cf-1408-4b67-b21f-04ff94314936@huawei.com>
Date: Fri, 22 Aug 2025 12:03:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tmpfs: preserve SB_I_VERSION on remount
Content-Language: en-GB
To: Hugh Dickins <hughd@google.com>
CC: Jeff Layton <jlayton@kernel.org>, <libaokun@huaweicloud.com>,
	<linux-mm@kvack.org>, <baolin.wang@linux.alibaba.com>,
	<akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>
References: <20250819061803.1496443-1-libaokun@huaweicloud.com>
 <0a5c4b7deb443ac5f62d00b0bd0e1dd649bef8fe.camel@kernel.org>
 <848440d1-72d9-e9ce-5da6-3e67490f0197@google.com>
From: Baokun Li <libaokun1@huawei.com>
In-Reply-To: <848440d1-72d9-e9ce-5da6-3e67490f0197@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.71]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf500013.china.huawei.com (7.185.36.188)
X-Rspamd-Queue-Id: A233540003
X-Stat-Signature: xwses9xui4ehp8t9hai4aqyaymo3srtd
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755835446-97
X-HE-Meta: U2FsdGVkX19bcUSMSyzTkQYt8EZVqZXkkeyS2Kv2ToMI0sLlDdldCAvmU8vIlZrzdrSLkbggZxQFhBtIy4Yei+FZwKQqjmXv/kX13E+K++ZySQc+bbXrTEbBryQDs1y1b3rSZyf6i6YIYdKqu0AUpQRPa8rXcdOe2ViINFZ/M6O8lrHWlazS1U0pbooJd7eifMRFo/PTxhGsAYaIcYP2qenoJyoUr/wOvkjvStQnsZw4HE6HEgHlzbyP7kguMmV7udZqx5Tg2oS2ibMeneLM6PLZw0lRooKv4+C7QHxr5QzzVdGbF5CTbJaFoPfaHMJeA3vRb3g2sWrERgMM97FdTyetG16sdsDLMbwZoCFj2SnZp5qw0OfiWQOtu2TOaTvXh5OCrOe+LX48wS1IC2OOBjMA8d1e+VJ+ulLO5HxYa4BKPBoh/ttlPYGguZfANICx1PxiJbUDIY6ND1q/93s030GUalj3CmKTi5te7+tSPoCYpGuC5Sd8EYYrNKHbKyhHCTtn+eZGzIgmao2PJLeB4MrLzoijQz6DTX6dTZ4xqzpeagOeuPE4cJo9lpB+0KEzaw4gu0XVQiW8BEXMxYUSC+yM3XHXeWeg3ta9iazEw0ByCtSnxeSxq9o+9yfANDhpU67H/rqwbYDnkWt1WZ467P5pZ2/sy2iH3PF3+m1WGSUXupQj61FZXy8GyZXcMdh5l1K34tg/jFe8Nm+21uitFU/bxaobxxfZF5E2Iy5OQz9T6EQ8j3jJQyBb4AX6bUV/SukOlT9mzeL4KFuBLarj/DZ1E9Km2/1ODr7QmvivBR5KMs7gHXf1hCHDRm9afuWBJ6NPxP3OddHChgwrSbi1APXJ/J9H2vc/mCydIRrb5YeYD6hlf/++RGmAPzaCEXFdPySCgYHCZJi7fD2+3UgJ6wa45wBJEWkFYCYD1z8Cy9ZxuIiOE3tYCextD6IxFPoCkekwAsxDNT9oyllqYc/
 hchIYj8k
 fAHeCcVrJh20cXZBcRcfjFHnfh5PAdsGX0Qld082H0c4yNstK1lyzqoWC6hkOYKro7+b+WSlcRLAPHGfvsT8TZK5BWPt3omjq6HtS9B6PfTpkg4VoEUDbk5GMBKadTuE1V3+sRqFoS4IIVAsgBqCo8pdXg2acTamvQVVAaznoQLOxaVlHnMcliXCFZ2fgumj9HF7HJQtNUZNySt1PefSw8ct1o4dPG+aiP9FpkxZleEvdZdGqu44+XR9kNIePvlMGFHckIaitULa5sJ5lsOwZrjSifQJvdOptulxHFU5LE/gUBvR2MZhfAuVB+oCMdVBvwdpOZN24tc6u/Dx4gpxBcG25P2y29+lxC6LrrWrRmMat8He/pVyi84dxHuGkG9ndkf6RfdA0Hua913Mk+Dr4ChdFOw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-08-22 10:49, Hugh Dickins wrote:
> On Tue, 19 Aug 2025, Jeff Layton wrote:
>> On Tue, 2025-08-19 at 14:18 +0800, libaokun@huaweicloud.com wrote:
>>> From: Baokun Li <libaokun1@huawei.com>
>>>
>>> Now tmpfs enables i_version by default and tmpfs does not modify it. But
>>> SB_I_VERSION can also be modified via sb_flags, and reconfigure_super()
>>> always overwrites the existing flags with the latest ones. This means that
>>> if tmpfs is remounted without specifying iversion, the default i_version
>>> will be unexpectedly disabled.
> Wow, what a surprise! Thank you so much for finding and fixing this.
>
>>> To ensure iversion remains enabled, SB_I_VERSION is now always set for
>>> fc->sb_flags in shmem_init_fs_context(), instead of for sb->s_flags in
>>> shmem_fill_super().
> I have to say that your patch looks to me like a hacky workaround. But 
> after spending ages trying to work out how this came about, have concluded
> that it's an artifact of "iversion" and/or "noiversion" being or having
> been a mount option in some filesystems, with MS_I_VERSION in MS_RMT_MASK
> getting propagated to sb_flags_mask, implying that the remounter is
> changing the option when they have no such intention. 
Exactly!
>  And any attempt
> to fix this in a better way would be too likely to cause more trouble
> than it's worth - unless other filesystems are also still surprised.
Other filesystems supporting i_version (ext4, xfs, btrfs) have encountered
similar issues. The solution adopted was either resetting SB_I_VERSION
during remount operations or setting SB_I_VERSION in init_fs_context().

Given that the overhead of iversion is now minimal, all supported
filesystems in the kernel enable it by default. I previously considered
converting SB_I_VERSION to FS_I_VERSION and setting it in
file_system_type->fs_flags, but since XFS only supports iversion in v5,
this idea was ultimately abandoned. Alternatively, removing MS_I_VERSION
from MS_RMT_MASK might also be a viable approach.
> I had to worry, does the same weird disappearance-on-remount happen to
> tmpfs's SB_POSIXACL too?  But it looks like not, because MS_POSIXACL is
> not in MS_RMT_MASK - a relic of history why one in but not the other.
Yes.
> But I've added linux-fsdevel to the Ccs, mainly as a protest at this
> unexpected interface (though no work for Christian to do: Andrew has
> already taken the patch, thanks).
Okay.
>
>>> Fixes: 36f05cab0a2c ("tmpfs: add support for an i_version counter")
>>> Signed-off-by: Baokun Li <libaokun1@huawei.com>
>>> ---
>>>  mm/shmem.c | 5 ++++-
>>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>> index e2c76a30802b..eebe12ff5bc6 100644
>>> --- a/mm/shmem.c
>>> +++ b/mm/shmem.c
>>> @@ -5081,7 +5081,7 @@ static int shmem_fill_super(struct super_block *sb, struct fs_context *fc)
>>>  		sb->s_flags |= SB_NOUSER;
>>>  	}
>>>  	sb->s_export_op = &shmem_export_ops;
>>> -	sb->s_flags |= SB_NOSEC | SB_I_VERSION;
>>> +	sb->s_flags |= SB_NOSEC;
>>>  
>>>  #if IS_ENABLED(CONFIG_UNICODE)
>>>  	if (!ctx->encoding && ctx->strict_encoding) {
>>> @@ -5385,6 +5385,9 @@ int shmem_init_fs_context(struct fs_context *fc)
>>>  
>>>  	fc->fs_private = ctx;
>>>  	fc->ops = &shmem_fs_context_ops;
>>> +#ifdef CONFIG_TMPFS
> Ah, you're being very punctilious with that #ifdef: yes, the original
> code happened not to set it in the #ifndef CONFIG_TMPFS case (when the
> i_version would be invisible anyway).  But I bet that if we had done it
> this way originally, we would have preferred not to clutter the source
> with #ifdef and #else here.  Oh well, perhaps they will vanish in the
> night sometime, it's a nit not worth you resending.
Yes, I kept this macro to maintain consistency with shmem_fill_super().
If i_version is not supported but SB_I_VERSION is set, it may cause
confusion for IMA or NFS.
>
>>> +	fc->sb_flags |= SB_I_VERSION;
>>> +#endif
>>>  	return 0;
>>>  }
>>>  
>> Reviewed-by: Jeff Layton <jlayton@kernel.org>
> Acked-by: Hugh Dickins <hughd@google.com>
>
Thanks,
Baokun


