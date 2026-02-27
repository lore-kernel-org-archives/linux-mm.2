Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26BDEFEFB56
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 14:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 866306B0089; Fri, 27 Feb 2026 09:43:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 814146B008A; Fri, 27 Feb 2026 09:43:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 713526B008C; Fri, 27 Feb 2026 09:43:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5A9A46B0089
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:43:41 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EDC6F13B8D5
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:43:40 +0000 (UTC)
X-FDA: 84490505400.04.636938D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf02.hostedemail.com (Postfix) with ESMTP id 97DB98000D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:43:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZoHzfiTE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=J901+09n;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZoHzfiTE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=J901+09n;
	spf=pass (imf02.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772203419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y9LKCiBVL3H1H1O10DFdcwMW83GWaN+Qa6e2JLqtQoM=;
	b=EqzRpR2MMJgB9z9M9Tke0XO0ef+O5i4eZ8Bn76OLDci5a4WMc9UNg+iGd+V6g82qXb7J3O
	ukL1pGlN2HnpJ2TKO471N1Gxe2StJJSLBWgVJldnHHu0aprRS4JLCwvZnIPIUuzczw4zpE
	T8fEwX8mojxG9l+HpJ/ZFYZyhILtItk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZoHzfiTE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=J901+09n;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZoHzfiTE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=J901+09n;
	spf=pass (imf02.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772203419; a=rsa-sha256;
	cv=none;
	b=69HY87mAFkvceFgv3C/l+qv+FgNEQvgyQesLvPrxpZyVygu4JONFk9vut8DwfxemOkUicO
	xDu0yjoPgu5VHizd3rkL7Lac4g/wz7VqqeINDz014OqlJhoo6whgRYcrV8oEkTWKCVjNDb
	Rb3MdbnwEgRzU8PWnadj5uOqV0b07UM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B2FDE6B025;
	Fri, 27 Feb 2026 14:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772203416; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y9LKCiBVL3H1H1O10DFdcwMW83GWaN+Qa6e2JLqtQoM=;
	b=ZoHzfiTEUZFC5kSAbwWL0Xdwus5dTFIKH7DBiFmndaRaiWZedeixp6+B6wSgJmqUU2w3JX
	sOYw0zH20DxH4UMAduA4kIE5kcau3NeCPqz9hgl3wGLRZfU2Wt/YUpIIL5WY/hTY/ZjQHj
	7pH4iGvTPI8u3F6uxyq5eeHMPYUL8pE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772203416;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y9LKCiBVL3H1H1O10DFdcwMW83GWaN+Qa6e2JLqtQoM=;
	b=J901+09n3K5/8bTE8FLKROZyCMy8zTVNsMgbi60qMgdgQcwwUNLd/CDiJV/mRZXWmM8zf3
	9yETEUKOXsb7M8BA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772203416; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y9LKCiBVL3H1H1O10DFdcwMW83GWaN+Qa6e2JLqtQoM=;
	b=ZoHzfiTEUZFC5kSAbwWL0Xdwus5dTFIKH7DBiFmndaRaiWZedeixp6+B6wSgJmqUU2w3JX
	sOYw0zH20DxH4UMAduA4kIE5kcau3NeCPqz9hgl3wGLRZfU2Wt/YUpIIL5WY/hTY/ZjQHj
	7pH4iGvTPI8u3F6uxyq5eeHMPYUL8pE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772203416;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y9LKCiBVL3H1H1O10DFdcwMW83GWaN+Qa6e2JLqtQoM=;
	b=J901+09n3K5/8bTE8FLKROZyCMy8zTVNsMgbi60qMgdgQcwwUNLd/CDiJV/mRZXWmM8zf3
	9yETEUKOXsb7M8BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A82CF3EA69;
	Fri, 27 Feb 2026 14:43:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PVwDKZitoWkJeQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 27 Feb 2026 14:43:36 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6BD42A06D4; Fri, 27 Feb 2026 15:43:28 +0100 (CET)
Date: Fri, 27 Feb 2026 15:43:28 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>, 
	linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Tejun Heo <tj@kernel.org>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Jann Horn <jannh@google.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 01/14] xattr: add rcu_head and rhash_head to struct
 simple_xattr
Message-ID: <vk7mausaumazk6iho7f2z7ld7byeyjhyczietf4rdi3c4dt3ya@ytbqtfdwvmfp>
References: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
 <20260216-work-xattr-socket-v1-1-c2efa4f74cb7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260216-work-xattr-socket-v1-1-c2efa4f74cb7@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 97DB98000D
X-Stat-Signature: iai3frsjtq1hjqxgzrmg1p1rbu45o9an
X-Rspam-User: 
X-HE-Tag: 1772203418-993681
X-HE-Meta: U2FsdGVkX18YkoZx2mlEvJps2+jhjpHV4e7tNrK1xx3oj6jJUobIjdl6Lhqvz3IFoPgWpPpUCzXcKLJp3dHZF0lheqGBoabQd40EQXCFrSBwOsK2D/eEofe1BQrjsMV99ThwNXA4s1DaO9WQzcav8ddfE0SQya7BmkH5mibiNWn03g2n4XPFL7zAO9js2qNR0z05hIUTST88Jh/fLj9haveGBOWhq7V3lxFqGmR9o+grxkmVCc7I1yBfWWuCiHlpZUMPmL5FsPB5ZsNBEY860xLBo6ibAbZUzq04v9biPa2yw8/1/ttQm2oyce8CGksVf62pei27zG4+GgtCgJ33omVBSyYmOQk28u/wKPeRVcmnyUHUjV9GUCvysTKnob/whrdjQv4dve5BiUqFSPNOIro3ydtX3wNIaFXqeCda6QNfk8LJR3N5xgYWdHOvWAcIe+OqwdHrCJDuYW4kCQCW3S0yNZ1SPLDeWoYFhA3ZCKfKyYFsTPyzP5FDSlZjx3T68bVVTpcVOMIGAwMf+Pi04cljJxFRcv5QlBhacWjv8Zh6OZaA+aGtO9958z4Ud2+3+zMJFGqmc8qzo34vJhs56y7T+udb38h2FwpwNH+K/xiEfJTH1WL0pFCwHdeMcJTD+5u16UOFfKrmWOHBgPqaltEdZO76gpksDLNt2JCCXHabGza3fBdETR12olQW2OE2cVEzGYRab/mHAsDjLADlb9KoETNL8preMquQ47l0ufqboEeRvZvgJnd3e+htYWW+mLlWKW+6GFLuBLCxktHDPof12aiamoCpfTa7/640/iCecEu6kCUQ67PA3xZNm8/iGIyEKxcsLce7Fi/s3HUp1xVTT2ud8egqilZyv60jTt6Wo3AFbAWgq+OwfHtgBWHnLWnojTseU+Tu3ZSIyJfo8xchv5DSWKN09m3jhS/v53K3XEl76fqCMUefWLGoe99Z/Sl/GTSz3tnHqoeavPl
 6dU0IX5j
 dPZb9+p6aMnI/vTB3TK8gkLrnkejAYKOlvSqYnDhdZxwq8I0V3BDfnrKliObdkXJgLbZias3gylNmED9UCBc2qOIeEp8aTG/CwBNnFVWr0zBTmDQdPxVda1qbD372YrYQgjU9Yk5g7PVPhghL3NvqHTMuZs8xDXbTvkceFdk6MCT+gSF7t3eMpRP6xHUS7DAsPxCNjXIlQ7taytGIsGlfbLeOLvJsWl6PNDAxZqaj0JANbWD0V0qs7UC7h7LOkyObmC55OqpG2xpFbGPZfRYF6OqN8Cj3nGl+9HzUaxSMIYcwueaOpcbaf8agdlFUapO5cz9iVfuLb3ihVaF6J24uTIxfyqPqZ0uBivn7QrrEX7tJRqeuTR2zMWTA0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 16-02-26 14:31:57, Christian Brauner wrote:
> In preparation for converting simple_xattrs from rbtree to rhashtable,
> add rhash_head and rcu_head members to struct simple_xattr. The
> rhashtable implementation will use rhash_head for hash table linkage
> and RCU-based lockless reads, requiring that replaced or removed xattr
> entries be freed via call_rcu() rather than immediately.
> 
> Add simple_xattr_free_rcu() which schedules RCU-deferred freeing of an
> xattr entry.  This will be used by callers of simple_xattr_set() once
> they switch to the rhashtable-based xattr store.
> 
> No functional changes.
> 
> Signed-off-by: Christian Brauner <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/xattr.c            | 23 +++++++++++++++++++++++
>  include/linux/xattr.h |  4 ++++
>  2 files changed, 27 insertions(+)
> 
> diff --git a/fs/xattr.c b/fs/xattr.c
> index 3e49e612e1ba..9cbb1917bcb2 100644
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
> @@ -1197,6 +1197,29 @@ void simple_xattr_free(struct simple_xattr *xattr)
>  	kvfree(xattr);
>  }
>  
> +static void simple_xattr_rcu_free(struct rcu_head *head)
> +{
> +	struct simple_xattr *xattr;
> +
> +	xattr = container_of(head, struct simple_xattr, rcu);
> +	simple_xattr_free(xattr);
> +}
> +
> +/**
> + * simple_xattr_free_rcu - free an xattr object after an RCU grace period
> + * @xattr: the xattr object
> + *
> + * Schedule RCU-deferred freeing of an xattr entry. This is used by
> + * rhashtable-based callers of simple_xattr_set() that replace or remove
> + * an existing entry while concurrent RCU readers may still be accessing
> + * it.
> + */
> +void simple_xattr_free_rcu(struct simple_xattr *xattr)
> +{
> +	if (xattr)
> +		call_rcu(&xattr->rcu, simple_xattr_rcu_free);
> +}
> +
>  /**
>   * simple_xattr_alloc - allocate new xattr object
>   * @value: value of the xattr object
> diff --git a/include/linux/xattr.h b/include/linux/xattr.h
> index 64e9afe7d647..1328f2bfd2ce 100644
> --- a/include/linux/xattr.h
> +++ b/include/linux/xattr.h
> @@ -16,6 +16,7 @@
>  #include <linux/types.h>
>  #include <linux/spinlock.h>
>  #include <linux/mm.h>
> +#include <linux/rhashtable-types.h>
>  #include <linux/user_namespace.h>
>  #include <uapi/linux/xattr.h>
>  
> @@ -112,6 +113,8 @@ struct simple_xattrs {
>  
>  struct simple_xattr {
>  	struct rb_node rb_node;
> +	struct rhash_head hash_node;
> +	struct rcu_head rcu;
>  	char *name;
>  	size_t size;
>  	char value[];
> @@ -122,6 +125,7 @@ void simple_xattrs_free(struct simple_xattrs *xattrs, size_t *freed_space);
>  size_t simple_xattr_space(const char *name, size_t size);
>  struct simple_xattr *simple_xattr_alloc(const void *value, size_t size);
>  void simple_xattr_free(struct simple_xattr *xattr);
> +void simple_xattr_free_rcu(struct simple_xattr *xattr);
>  int simple_xattr_get(struct simple_xattrs *xattrs, const char *name,
>  		     void *buffer, size_t size);
>  struct simple_xattr *simple_xattr_set(struct simple_xattrs *xattrs,
> 
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

