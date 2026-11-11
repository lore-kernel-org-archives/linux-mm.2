Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9386A606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 01:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=BNlwdDE7
Received: by kanga.kvack.org (Postfix)
	id 78B116B05B4; Tue, 10 Nov 2026 20:31:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73B996B05B5; Tue, 10 Nov 2026 20:31:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67BF36B05B6; Tue, 10 Nov 2026 20:31:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E4E36B05B4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:31:11 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A68CA40167
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:31:10 +0000 (UTC)
X-FDA: 85421109900.07.9AAFA2D
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9F19720006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:31:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=BNlwdDE7;
	spf=pass (imf31.hostedemail.com: domain of joseph.qi@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=joseph.qi@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794360669;
	b=aUCj8MrmDkabK6EEpiB6oLhUnh0Jv4qCaDMOFFU2u+KD822GNpWAYSPCZBa5/wDbqQB4jx
	aGK+0VZhLXiBM4ROqm16plFH5El3/7CmR+dQ0eBmbsVFabfANJEKG9hoI7HNIsClh7cU1C
	4r8RYW+ZgIWxLtUtGmgPjabGYr40Om4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=BNlwdDE7;
	spf=pass (imf31.hostedemail.com: domain of joseph.qi@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=joseph.qi@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794360669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fz7Db6YPpucPps2P9eFgAPZMsl4Z2nZBpO1+iQqdPhM=;
	b=fEWBNoUkW7XhDbqb3bswquOv/IpZ4kXnDVZZBxZ8mbCWlVA5t0WH3hDZwVnzzbtAwg4V+b
	uja5DArw44ge9kGa07VM/4qvv5/SCJCr7xvugu9ykzpeOh1+s4hvYQBRDu6efe0bJvVKIZ
	izdxfIC/c9cTO9v0lXn+UGetcxXrjrI=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794360665; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=fz7Db6YPpucPps2P9eFgAPZMsl4Z2nZBpO1+iQqdPhM=;
	b=BNlwdDE7qV9jY0jsTjdvSLiR4R5Gt5bkOifwnmWW3kMZ/6Frva0l6JrxMIlYIS1tXZoofKA5UcLW6FnyvaorVOn5LrNmepzCI5LPn8fkafAYVfCS1NZNmML42EWOh0XSid//F/oPXipXWCzr2WdO0axi/aFdOn9hJkCBUv7VC1g=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XEX6F-L_1794360662;
Received: from 30.221.145.127(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEX6F-L_1794360662 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 11 Nov 2026 09:31:03 +0800
Message-ID: <f6cdf5d0-9468-48cb-9bfb-0cc41b46c7fe@linux.alibaba.com>
Date: Wed, 11 Nov 2026 09:31:01 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 19/34] ocfs2: keep the current mount options on remount
To: Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>,
 ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
 exfat@lists.linux.dev, linux-mm@kvack.org, ntfs@lists.linux.dev,
 ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org,
 gfs2@lists.linux.dev, linux-efi@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-19-2f44f64f0b66@kernel.org>
 <0a8576a4-e397-4a49-ab0e-8f0f32bf2642@linux.alibaba.com>
 <20261110-zerfallen-meiden-wacholderbeere-a90ac157e063@brauner>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261110-zerfallen-meiden-wacholderbeere-a90ac157e063@brauner>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 553qbxgao77qtd77gewsop3wa687bt8e
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9F19720006
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794360667-536171
X-HE-Meta: U2FsdGVkX18dVi/LI11gtov+k8wPmnULYb+w+653EX2fxk8U5shq+hRz/DrlNh+HqrPASRpZRXkF6zql/XPpW4gSGj/42ok1bRIJBLk6iwbC2ZtBq4TGc2CcLz6BrZymun/ay0WRTj+zJIJxtlz7JnHBqiz45RVfkpYORWpLm+VUKiRG/NdpSw9mx+o3tdqBDd+c1xQd2p+3FD/WLQRg9s1vkIRXCsKWYpMNPznCZn9+5KHXUr0Vym92XHPR0DMK8JGuhjl0AzrFysGBnQ+Af0yIBdsqA1ygmsMgDP5ToocKTWRlsRMfG7ZdJmOnbi0P34A9krWbVTkLe8xBxWVC95XeZoFhJbybFIwifQKmT53ebHr8kc01uOo0uD6UlE9QbSJxXlSRDsRfSH2CyxB89Hbr/gYFoRkHfRCyIpdC1CalVhH2kfnCMvzziGytQTzqp/lVNw7qbG8G7ajOLvetUiRlqcQmu1pfQSm/duNt7Y7TH0UBr2eJWWKmf8ixh6lnGX6zF01Uy+L6D700sGAs0LKr+pHxzmbwjhNJCbGpI/fTSxSqe+c+kBM+zDm1KOLXDhCpWJVWdBNBMgxPf5EYmaSDJ9XiN8T8EL9vEuemgNgysvQtrFPLAcFLJPXMLOUN1Blj1PPDcQa3aM+cBnptTK022G7vKivCgc/vgsRv4cWqC1Jc0dOQo+0fzVevn9CYGrNfBI6/bQE+OyWCpfoEfP4gYzSkiZi15dA2Ie/jO9+BLs1Vy+a9C4HcgmFzkjv5dVzrWh58VwrxYMmNEf4AkJ4ZDNKGTyc6SqJe7oWmULMAtzKjNY8hNv2zQKdninj111wj5k5fHn//L+X+hC5Fhg8Ly5Y7ie9wXM0ORcdjEjQ4qOr5j8rJVTbT2n+xzhjsUDEPsWqUEWUFquS+Wr5CxIYMqkXqyQpyhkgS9JJxPjFwcsuUHyClOY5zzsbqhA2iWy1ZO5Geiln2SxAO13U
 vzh/S12L
 IT3Dl9Vy9r+JlZTT+Oed0fqwsSK6Ois1Q1vsy75+2KL/iv9sx6qw8q9WmLKbJgEcPDXtWg86MIsNh7z68Axxu164nnBqJ0Y9DUOIXcW5S6HJwTqXZiFDAcmpYKHOOGLZs55QofEQvhPqYITdgiWPgBkMRLB/EowDaAvGDkzHy38yugCZzqvk3YKxFQmx7bEs6AHSQT06s19rD09qEN0IcfH2f8HgKS3s/Xh3C201j7Blm2/TgOeh1msFG9jxk/3iwZdSyo0HIUIWhnM4i7QF2xOjE8y8LLXe15+KG0YDUKFA9jODY8z5y3u4q4LXduFRp3O9EqzwB1xzY7K/C0E+JTWUnwkzPfeBohCKKLs3wNNeak1A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/11/26 5:52 AM, Christian Brauner wrote:
> On Fri, Oct 30, 2026 at 10:58:52AM +0800, Joseph Qi wrote:
>> ocfs2_reconfigure() decides the transition from fc->sb_flags alone without
>> sb_flags_mask test, unlike reconfigure_super(). And fspick() passes
>> fs_context_for_reconfigure(target.dentry, 0, 0). So on a read-only mount:
> 
>> So it seems we should test sb_flags_mask as well?
> 
> No, that's a generic bug. I fixed that in reconfigure_super() with
> "super: keep the read-only state if a reconfiguration doesn't change it".
> That is in vfs-7.5.super (cf. [1]). This series depends on that work.
> 
> If SB_RDONLY isn't in sb_flags_mask it fills in the current read-only
> state. So ocfs2_reconfigure() sees SB_RDONLY and stays read-only. ocfs2
> is one of the 23 filesystems listed there that only look at
> fc->sb_flags.
> 

Now it looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

>> The same falls out of a legacy remount whose flags omit MS_RDONLY.
> 
> No, do_remount() always passes MS_RMT_MASK which includes MS_RDONLY. A
> remount without MS_RDONLY asks for read-write.
> 
> Thanks for the review!
> 
> [1]: https://lore.kernel.org/r/20261011-work-super-fixes-core-v1-11-c727176c5b53@kernel.org



