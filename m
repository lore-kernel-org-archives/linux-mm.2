Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6D89C61DD6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 01:37:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9723C6B00DD; Wed,  2 Sep 2026 21:37:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 922656B00DF; Wed,  2 Sep 2026 21:37:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 810A56B00E0; Wed,  2 Sep 2026 21:37:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4C1836B00DD
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:37:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 240BEA042D
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:37:00 +0000 (UTC)
X-FDA: 85170737400.25.42D473E
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1267614000A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:36:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Xi+G5uut;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf26.hostedemail.com: domain of joseph.qi@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=joseph.qi@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788399418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e541pMb9oMqhXLTyZBftOnSifT1JVi2i2ff57bVED4c=;
	b=7cx3i3B/Qw2jRQcV3zK/t4re1/s8kZ1UIsA7bqgSOujFu6DcDrn66LQpkpSiY0IkEBtteV
	ZZjVXGULggA11mQ8R+JjYOJV5Vkyna/E99pXat0uRYFYCH/0oRUBPMHe3gOOrTZ8uLj+zZ
	0PVxBwyP+4UYp8lNWSkoleU8/MoVzc8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Xi+G5uut;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf26.hostedemail.com: domain of joseph.qi@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=joseph.qi@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788399418;
	b=kGbSY/pyxdLv7p1VMSwkrEWY0+iNGHypuNx6gGfiwirNLHH9q/XY2xgC8YzQQXGB8XPjOo
	Z7wBVtDfaSD8oImwv3kE5jq0A1neB/tsR2M3OQxLTnhLNnp45OPIV7k/tPbSLDlyZPUVza
	TzWxPQUB6FoDl7eWwJQySaZX5V6Zel4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788399413; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=e541pMb9oMqhXLTyZBftOnSifT1JVi2i2ff57bVED4c=;
	b=Xi+G5uut+AJDQNkvLZyBkcSMfM28p9ORQ3yaTodx/LvGGOk89zMyBsyAYdVRLhqp/9KdQJxhQ6XQ9Ncv9afZDLXoLnYwbyD94Mu0kDffOZcXwL2JyICaQMeNcFLOLaHCFFslIEvw5uS9iFmoxckZMi9bvwyuV1viv7+FDbX2gw8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0XAEOibv_1788399411;
Received: from 30.221.131.71(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XAEOibv_1788399411 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 03 Sep 2026 09:36:52 +0800
Message-ID: <8d78e72c-a7f5-4b08-a249-34e924bda588@linux.alibaba.com>
Date: Thu, 3 Sep 2026 09:36:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] ocfs2: Refuse to enable ocfs2 format for another
 filesystem
To: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org, ocfs2-devel@lists.linux.dev,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Farhad Alemi <farhad.alemi@berkeley.edu>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20260902132458.23590-1-jack@suse.cz>
 <20260902133702.1313635-3-jack@suse.cz>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260902133702.1313635-3-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ebb1x14exg5jup4naywiwttxuins9oia
X-Rspamd-Queue-Id: 1267614000A
X-HE-Tag: 1788399416-319705
X-HE-Meta: U2FsdGVkX18teVEeWI3j/cngKgDqSL+12SsP6I0cTqG9oEYPZCBUZqQ8bgTnMIQ9NVrY8JAa3lixg01YVJo0U299/RH8YvooomqRq3Zv1NTLxDnhplWiPmh3ZR7eqtfP7jGbc8l4wZtwHv2VtezcdAeK6knPnb1xYuR7ce9pDYT2PoqT9pndTrtjPJrP5T7HHSU+D7lkg6R9tAG8YsuwW/xwbq54Kl8LTve0rX+zdSssElBHduxyiyureD2Fp5huPEetW8E/r5brfacOnIUAZ96nMxJNivVEyK76Uqzp3FatWJlAY0l5ZjOHyqI2hd8reMEKFkYv4Tx14aO3p8uc38XRpsWOASijGiLitGfvjLkbSoBv4VJJKEt+XM4Ko/aErf/EdLVGufcBJiPycYS3lnq4dICw+oPheuhzm0m/P4g5n97Yg7Jo7F7N9kyNcKANOR6ONB5Yv4Y93oRrDBOKms1Y+ZoE72jdHEwL/vh7ICrnt2k2qt5WSoE0zeSLuTPvjgHQ1vqpqXzJdyzRKGDWTZ5ZxNln1VRi9isYCCf+zDrscP7KL7jaVdDGFo66Iz07GUsYgbpvNDkaGBA/l/q+efV3qbOlntQgS58ntLH4+cvgLyXaRKGhSwvvQQQi3tkwk3Xcx9Yvx/b5M/dtO/wiKL2W1/W3zsqMHFZXBheUTXtwPZarQCdhS3IowzxJV3tV8mXPbu+030WD0qd//GjNJ+wp/YI0uxv9hFmh8dax5YFeY6oET3ucV5bWUlL7pcPhuEf5lnfJ43xk2ZaurpqIjUe0MWeJDGVzGGr3PPcQnA9crp5PzltapfEjZpOsa1AHVFbxX4wPckeGibfUPhRuaJeGUBNNUoNzI31wWRM2Npyd10Y6aCq5/SVWWuGFcMO79dDkt9c30w2psmmJgsBk8UoW0cH73EUfNNPNlaeG4nITkNdIw9iAGsB79As5lnw/AMWAEimfpWkcZZVWe2b
 pR6Jo5c5
 gNz0+3xeKQH7bzcb0Usf5ADJFwyl+27lD5MGhkA83BK2DEV9StMMcoeEgZq3Lv5quIoxQo8ojiCPmooMm5RDfUIVdppHx5pK+Kkip/KlyqSgXV6sUsUXq3JhFVyUqlpB+R1Z11xTP5nIBt0sebxGcAj2CBlOcZOFF+qTb4Ws0PV8jUIDwj0L3mq370HF4N7LUJR79k+EXlreIkeDC+BNLxaXOupFwT+WhJ4ApyMjkyQv8Wt42LSBz7GNvmT+ewD6Da+zEFEQmw6l3Qf3SpdyAkzDCDuQz53ScPZ2KfZIGGM4DHOM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/2/26 9:36 PM, Jan Kara wrote:
> It is possible to issue Q_QUOTAON quotactl(2) e.g. for ext4 filesystem
> requesting to enable quota using ocfs2 quota format. With suitable
> passed arguments this can get upto ocfs2_local_check_quota_file() where
> the passed superblock is from the ext4 filesystem and that can cause all
> sorts of interesting things, most likely crashes. As ocfs2 quotas are
> specific to ocfs2 filesystem, verify we are indeed enabling quotas
> there.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/quota_local.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
> index f55810c59b1b..97dee8ee6096 100644
> --- a/fs/ocfs2/quota_local.c
> +++ b/fs/ocfs2/quota_local.c
> @@ -171,6 +171,10 @@ static int ocfs2_local_check_quota_file(struct super_block *sb, int type)
>  	struct ocfs2_disk_dqheader *dqhead;
>  	int status, ret = 0;
>  
> +	/* OCFS2 quota format is supported only for OCFS2 filesystems */
> +	if (strcmp(sb->s_type->name, "ocfs2"))
> +		goto out_err;
> +
>  	/* First check whether we understand local quota file */
>  	status = ocfs2_read_quota_block(linode, 0, &bh);
>  	if (status) {


