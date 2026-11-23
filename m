Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2035606A331
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 15:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=seJP6l53;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Uu4VCqg+;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=seJP6l53;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Uu4VCqg+
Received: by kanga.kvack.org (Postfix)
	id 07E2B6B05B3; Mon, 23 Nov 2026 10:40:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02FEA6B05B4; Mon, 23 Nov 2026 10:40:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E60D16B05B5; Mon, 23 Nov 2026 10:40:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C27366B05B3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:40:26 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 538C3C0936
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:40:26 +0000 (UTC)
X-FDA: 85466795652.06.F5B27FE
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id 496BA4000A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:40:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=seJP6l53;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Uu4VCqg+;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=seJP6l53;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Uu4VCqg+;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf17.hostedemail.com: domain of krisman@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=krisman@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795448424;
	b=aRqJPxQlxNKd74jZ+9EUj7bQKPWr6jan/JGabvkIU9/u9kPXJVeyfQVcNIbIWBxY/YuWK0
	qy4y9R1WTzvRrZMSX3RtuDREqsmR3G6TTBHNKkpLmpPe+TFrQ6Q0QTJqAobHa06O8B7Izi
	bm32rzjNnfUXKD+SNghgAk7s3dP6rr8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795448424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TRg73PCpmlZWbc1zT/pf5WUhMtuFRSW1UJ9K9OaWjM8=;
	b=R2zMXeQZSWLq0Y99uhHe7Nxwa2+flVfkgFUmOVdAtjLcJLukridMx7+8JJNogPxNrEvScp
	U1aPd89ln+b5yUKVF7dIXfSwF0/XvAUJLnqJYTr6za4VDZIJVvGLZ/yCPymS7QCumjfKZ2
	Uc/N2uYu5KI2C2m2Wgw7iKKqqlRiVoI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=seJP6l53;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Uu4VCqg+;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=seJP6l53;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Uu4VCqg+;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf17.hostedemail.com: domain of krisman@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=krisman@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C8434220B5;
	Mon, 23 Nov 2026 15:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795448422; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TRg73PCpmlZWbc1zT/pf5WUhMtuFRSW1UJ9K9OaWjM8=;
	b=seJP6l5362qfLy2H+0bB24QAjb5CTCS231Rn+mUgJfUtsBD3PaI4xJGDmyuFIaTWKxq3b1
	3bmTCbZFtbdcgQknNloc49mxgrZKYleR7R6SWqBzoN0Wvow98wQmeATFs+EHoCmtmMoMXf
	4DkaXl84nIjxl8+tISAfz6oxoiIY5aM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795448422;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TRg73PCpmlZWbc1zT/pf5WUhMtuFRSW1UJ9K9OaWjM8=;
	b=Uu4VCqg+7C5pqg8AKtLNMV9QEJah4IND00ADWLDA+JuizHl9q1MoWO9Y/n+R4EveNxywUs
	dM7t72dkjgGKlyCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795448422; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TRg73PCpmlZWbc1zT/pf5WUhMtuFRSW1UJ9K9OaWjM8=;
	b=seJP6l5362qfLy2H+0bB24QAjb5CTCS231Rn+mUgJfUtsBD3PaI4xJGDmyuFIaTWKxq3b1
	3bmTCbZFtbdcgQknNloc49mxgrZKYleR7R6SWqBzoN0Wvow98wQmeATFs+EHoCmtmMoMXf
	4DkaXl84nIjxl8+tISAfz6oxoiIY5aM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795448422;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TRg73PCpmlZWbc1zT/pf5WUhMtuFRSW1UJ9K9OaWjM8=;
	b=Uu4VCqg+7C5pqg8AKtLNMV9QEJah4IND00ADWLDA+JuizHl9q1MoWO9Y/n+R4EveNxywUs
	dM7t72dkjgGKlyCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 58F3F1352B;
	Mon, 23 Nov 2026 15:40:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LUpAAmZeBGvUJQAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 23 Nov 2026 15:40:22 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Tao Cui <cui.tao@linux.dev>, hughd@google.com, david@kernel.org,
 akpm@linux-foundation.org
Cc: linux-mm@kvack.org, baolin.wang@linux.alibaba.com,
 andrealmeid@igalia.com, linux-fsdevel@vger.kernel.org, cui.tao@linux.dev,
 Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH 0/2] tmpfs: fix casefold flag inheritance and document
 mount constraints
In-Reply-To: <20261123051629.2547645-1-cui.tao@linux.dev>
Organization: SUSE
References: <20261123051629.2547645-1-cui.tao@linux.dev>
Date: Mon, 23 Nov 2026 10:40:16 -0500
Message-ID: <878q2jeeu7.fsf@cartola>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Score: -12.80
X-Spam-Level: 
X-Rspamd-Queue-Id: 496BA4000A
X-Stat-Signature: moiod8ctmk9grgb4naxupg4atod9dek4
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795448424-87936
X-HE-Meta: U2FsdGVkX1/fMvlIX0BeaaHN5D48QiKaOQ9vNDPuJoFwqVbUcguE75dzw+glAHYVtlMH9Esg+OFA/JuADSAZ7DZfWxNQGhpg5mM8anb/H1RBNHj76SFZ/MDEjJjDlqHi0OWJBMfzpOqrijDA6tvbcQPorLTarFCrZjbeyS0rvuhYhaWUCs00sh1+s7xg6gCD6aa0dtlwoRUBwQsPezKo8AesEj3gT/ZoloDEs9LLec5JrgrZhdp+mkEFR77tr616hIAupuPmdFqEa6agJmofvWqVk0Kfvu9E1kD6wV+ZJskcjr9BDLApmyKYfbqF0fkVSSxFV1MpjW8uXlSfNR1sXIMAc3zoyiXpmF7L309OHg1yixFqzaXyIv5XvPcJI9fVE1JX9idO9bRsTqlyjNe/FwgzvYztIkmxYV/9tBU/ogtrs7YbTNCv8g4rkUAMVmVUzOuyNsciZQaXgapgp8UvT+H6Fj03m9jtiIEvZ2VTM3JeshDFevwLe9BRAjuOGtbDTuSS63pCWyNAhoRMESSpfmm5JIq6vs+A49WqeCNeIS56gjQWu1jfCxLZghIqbPtwf3k1FOrUCDzMruG/vj33k7MEnQrAD2gaXAHPyhV4xTxFjUiF/2QnAMzEp8kGe6x3cxztc58A9+olMT8uphzs3jggVSzb8yJO+BlwCjFZzeO+TPyr/PxkpvGN+/rfTXrWM+n8hJcjjTB0OriAx9Ro4aOIWKn/nTJuxm8NwsQL+SZxNOTt+CAL7OnDZToAhYiy/uUcnziF5/N08SnCH/QVffoFVmDmo4dZZYYYnpdvZhEr4ZC5da28/8dADVPrUF5CLU0HADBiog595fyGYdXDiBCb38MvvGE1llwUymEbMZpXkXCDH+eQLy3JI2QmBZ03rJm+dTNndTVHu3v02jYd334qTgvJmz1B80zM1CBU7CGsdLvjt0/sx4asZQqV9C3LTun8+kbj8PpKtYia9AC
 gEPzsX0N
 YK+nnFEJZsp39DJX2fgk/IXOiED5GqGID3DeQeM9meUpnzhAfdnWjcVO3D0kthkGLlE4BezEinYMiPqUbVyRYh4FQySjhStHQRE+8DYOJaDFsIQgXXVBjmTEWd1zQ1LJAFjgAgkfl6x5e/Iy9HtMEc3yo2tRfoWAHnL9LQrAWcNktoG/wpmAVnq5g2L361jlK0v0/Yhb8RD+5et55II4ngxde4AjPikPerVr47ndk7MgA2D6VpTLIcv5+utlBFWz+8PtTeZdSvofitP8WIJj0tP3+VUZADLxnYiECQNmMYu8qcGDyqGdpeWl57NMAfDq/ce7Hcgf7X7vVBFc1l8dYKfTuLlSpp6cfAnqw1sphn9YsrhINXK71HdFH9EFl0GBRfdCZLV4usphuQMPxqVs9XeiD1O7JmEg6iLmmo/GmkuATmL+3A+niplvA7LsTQdUQrRz9lbsuyK4ZVhJhL8Q+eLZFoiluxlNsy3EcaxrRSdZbbas=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Tao Cui <cui.tao@linux.dev> writes:

> From: Tao Cui <cuitao@kylinos.cn>
>
> Files created in a casefold tmpfs directory inherit the
> directory-only FS_CASEFOLD_FL flag, which shmem_set_inode_flags()
> then rejects with -ENOTDIR on non-directories: the inode records a
> phantom F flag, so the value FS_IOC_GETFLAGS reports can never be
> written back and attribute changes via chattr fail, dropping
> NOATIME/NODUMP from the same request.  The casefold mount option
> constraints that commit 5cd9aecbc72c ("tmpfs: Add flag
> FS_CASEFOLD_FL support for tmpfs dirs") landed with are also
> undocumented.
>
>   - P1: mask FS_CASEFOLD_FL for non-directory inodes the way
>     ext4_mask_flags()/f2fs_mask_flags() do.
>   - P2: document the CONFIG_UNICODE prerequisite, the
>     strict_encoding pairing and that both options are ignored on
>     remount.
>
> Testing: on a VM with CONFIG_UNICODE=y, before the patch a file
> created in a +F directory advertises the F flag via
> FS_IOC_GETFLAGS and chattr +i on it fails with ENOTDIR; after,
> the flag is not recorded and chattr works as usual.

The series looks good to me.  Feel free to add:

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>



-- 
Gabriel Krisman Bertazi

