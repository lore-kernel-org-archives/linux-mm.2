Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A280EC88E56
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 17:35:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D9BD6B0092; Sat, 12 Sep 2026 13:35:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18A8B6B0093; Sat, 12 Sep 2026 13:35:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A1206B0095; Sat, 12 Sep 2026 13:35:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E32796B0092
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 13:35:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 804E21A052F
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 17:35:48 +0000 (UTC)
X-FDA: 85205812776.29.362D285
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf11.hostedemail.com (Postfix) with ESMTP id D347040008
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 17:35:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=qVdsQMhf;
	spf=pass (imf11.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789234546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SkHWeSKclNj15GV7KAPfWvuOJ9MQh29mBLhr/+HSj8Q=;
	b=4JLVFhsGxiYKUeuJyFwe7xuv9w0cScrgQBtAMtSMe9arJNgPUzBH8zEkwrtghc3C128iPD
	ZEL/ncuOfYbWVYSNlBIqkuaM+qrVFhC1wQfKNnVQZeWSrciK2HJ945/+ucD7/KG3gJ5Q6L
	j5EuFEiFVqlREuDuhXc5dsAKZYYEB4E=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=qVdsQMhf;
	spf=pass (imf11.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789234546;
	b=3V2Yc3mBuRIrDaQe714u+9frgueKOB7vNJDTII4UBrlbwamNBlsGYcFymO2ZuuIBIEcNg4
	lN1QRfsNer4x8ykaQATrjSLXhhD3y32FOLsfud5MGuPlEnL92/Aqvo7tSR7MR5fe5JhjMF
	Zv/sHRD3p+I8nTNCKCZnqZeCnr/YX0A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=SkHWeSKclNj15GV7KAPfWvuOJ9MQh29mBLhr/+HSj8Q=; b=qVdsQMhfQoh+HOVWoQCmMZ3kpR
	G0e0CrRtUTUuUYDCePSWAqwA/0IW9XulYz+aBuVBS6eVcxKN/hfsvWMgD624omXZ8rqV2RihIqALl
	sxNE9+fxDRLtVEzOF87R8QZJZVYwWWN9kUSb9IK2KwHYO2P/CQQ6B8BLvfaNl/TwSs76NLG1eBhZ2
	e0n861bUadhrd3GpVtUnfapY6ifDreIk8e123644wxKvqR27RWcvMEyvNMV2O/ca1L2FcpQ2A5dd/
	KAlrvvEvMGoSBvcv1HxmRr4O+MKxxiH5bcaHbeZ9ZR0jmqItdQYvhuEtfWWI5rUIKXPdGgsjUxmCc
	66A5Z4NQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x5Rde-000000012qD-2dww;
	Sat, 12 Sep 2026 17:35:42 +0000
Message-ID: <01ae4e36-cc13-4420-a46b-69de5fd37fb5@infradead.org>
Date: Sat, 12 Sep 2026 10:35:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs/vfs: Fix the struct file_system_type copy
To: Karl Mehltretter <kmehltretter@gmail.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>,
 Christian Brauner <brauner@kernel.org>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260912073250.51074-1-kmehltretter@gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260912073250.51074-1-kmehltretter@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D347040008
X-Stat-Signature: tmmx6ucj3rt6ir87br9uo913j41d4bya
X-Rspam-User: 
X-HE-Tag: 1789234545-205290
X-HE-Meta: U2FsdGVkX1/fKmf36nhgJZyBqTB6mDK55OlxPMPcW5iSpmaIeCwpEbs0B5DvoYk4XkO4KpF5oqtVrXPZ8EOz627ZjDI+d+me5VdHZBx7/iNG4hy7nnBXVw/YuhDs/tEq6xLtjWXOkx4dSjf7OBqNzoJghUIJr6qDXHSNbKkNx5CofpVj0HrxBBxSiJ9N2bzJHr0e+gyybZ6oEamRtnahOQf0/jYR3gG1DugVgggy5JJ3nTWG62EOtGDz707weM9E24WjZ05Sailg09sMFui/CKfNi14BMiYf77E+YAfQGWIeTl5rs8G5Y3bIhxRCYYUac6IBF2pz2mhG3ub6jSuP2gndslQ8twbo6rIJBJzWxynXO3Npkiz6Ax78PdWTc91iBCIIgd2fsNVUVlHqnzYSxHwaMT3HA8zPHJtJugBUyYkWPE48DNoLDnnbFLzMvPuR6USvr8k5TZboO4Q1LiwB8E3Nwyl79WEdItSOETAVvUUE3AfJuxernTUA8AmrEppKD6KOzJvknPvzrm4M128Z3re9F4iOUR175zQmV0lFjOss+hOV+zBIiHm6XtTHQb6/FxNEcH3LAv2dZz0JhISRiuiulu6oYeTVMNZy5TR+k8rO4Mbvd4rD3hvezQWJiT1Nt1Xvjiy8QEMssWBnehd9UbK/3ir3R9p3H0M2s12Zl04ZCi6Ll2vK7w3iIZ6Wl0pbcyoDrccVj3p/zU4UBI7JkEG3Ivs5jReAeJb89KFvNuzbleg/v19Fh7JekD82Ix2x83WCO6L6Xc9FjJFKt/6durlyF1ZFk19XvflH+MCk2GQ9lgK8qDLWHs4dPTBKu7xm0thYx/q6c9Wf8Qm4JzCMpyC55fTitl+hCULyxmIWuYkrNZMsu0bumzVET3TCPs6mQvogsf+iLyyBrcqwOc5BNaE6344Mwr7v4k5pj2nQEgPoquWiu9L2MqtUY/BhxwT9ioMzIX0rRrXh3xKPFwQ
 ZZViQzo6
 CCywJlGO4ZsY146NRBnORAncgKa8YWhBGEwAOlpsfkIHDf1FeHxqw5apwcNY/a2WmcSwNpWOKS7VdTjbzOIz/JCe1bcndZ3PoJKLCt8IulZBpLpztBym7Ef40lpt360gkbRQE8mt2X6QYin/aDDj7JBxXFX4lrCQ5j7IBRKMgQFrsGkZFFxgOY/jiAty5C4RsLW9+ukiHdBvr4R6S+bk6JYspi1FsZo3lInBrUazlqgcBbucx5zNueTtyTcriU6WU2sBXpHzaLz//a3oL9ODur65mNfCT2UE8BcTDojOLlYv4MHBLT9T7Ae0fztDCcKKKt0DPeHHmyC72ox6//DQr/39wKjaGAmQvESzWlcoeRQxufFXjIAJw1v8BuxgQmsTtPrXm0hZqq5CARiVf4TCp3f4Ab9LstGDNZONs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/12/26 12:32 AM, Karl Mehltretter wrote:
> Commit dc651e25a6d2 ("fs: RCU-ify filesystems list") replaced the next
> pointer of struct file_system_type with an hlist_node, but the copy of
> the structure in vfs.rst still shows "struct file_system_type * next".
> Show the hlist_node.
> 
> Fixes: dc651e25a6d2 ("fs: RCU-ify filesystems list")
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Thanks.

> ---
>  Documentation/filesystems/vfs.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
> index d3a93eec3945f83e057fbd6bc3ce519da03ea66f..56c68f4aefbac6f7be979f5ebc2a0aee886e13ae 100644
> --- a/Documentation/filesystems/vfs.rst
> +++ b/Documentation/filesystems/vfs.rst
> @@ -117,7 +117,7 @@ members are defined:
>  		const struct fs_parameter_spec *parameters;
>  		void (*kill_sb) (struct super_block *);
>  		struct module *owner;
> -		struct file_system_type * next;
> +		struct hlist_node list;
>  		struct hlist_head fs_supers;
>  
>  		struct lock_class_key s_lock_key;

-- 
~Randy

