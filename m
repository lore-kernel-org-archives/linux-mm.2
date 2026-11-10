Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B8E160A261B
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=esCQM7vh;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=oSEGdPnx;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=esCQM7vh;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=oSEGdPnx
Received: by kanga.kvack.org (Postfix)
	id BD4996B05BF; Tue, 10 Nov 2026 07:53:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA5266B05C0; Tue, 10 Nov 2026 07:53:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABB0C6B05C1; Tue, 10 Nov 2026 07:53:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 804C66B05BF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:53:48 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2C89C1404B8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:53:48 +0000 (UTC)
X-FDA: 85419201336.13.56C5D8B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0E909180006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:53:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=esCQM7vh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oSEGdPnx;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=esCQM7vh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oSEGdPnx;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794315226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bC8M9j5KysQj3/tBg6i5bs7GJQfbSn2RIhhiTaj/uW0=;
	b=PGY4FZDrMvsAJdekz5pjOslBonGKB8c3MZNfKp8YliiMy7NERF3NzZFTUfJTZQFRi5yf0Y
	EYeV4HlameJVxhdKruVpub9CfcLgWvhHw1wEvEShWYZgvZ20SAYJ+8pmlA8rpZVi7GjLp0
	KxqCqBI8KLaaPeGyRnqF9FKInAMa2KY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=esCQM7vh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oSEGdPnx;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=esCQM7vh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oSEGdPnx;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794315226;
	b=RXtHC59D7vGpeMhoC+2UeC+ZMgW4TuwSboogdYLnJgpoMCez7nsNj2wFRu8xe5wfNDfv81
	RJDppQkYt/1Rt8DjeTKEug5MMWmi+X/HJZ4LHqytjkGka8z60aV7BDJbYRXWt2ax356jc3
	tzPw5yXnHhKDDksJHZWIlinlotZ2S08=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C21BF1F387;
	Tue, 10 Nov 2026 12:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315224; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bC8M9j5KysQj3/tBg6i5bs7GJQfbSn2RIhhiTaj/uW0=;
	b=esCQM7vhwtFDlR0XGu4BvbeJKkz5yWIkyBoCAFmsMjaesvd2xzTBQ75GstxjBGyvm+uTc3
	zbsPxyyuvivvpTctk9VGrw5XL7jzea4xXXiQ33KgF1MkCOuagUmIs2QoSpY/RNulRuLG5X
	2mokPeCKWxi/pNmsgHI/oRHbYwi1nhQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315224;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bC8M9j5KysQj3/tBg6i5bs7GJQfbSn2RIhhiTaj/uW0=;
	b=oSEGdPnxsbYWAcn6+XCX2+zc7aIbagOCqMu6PvH5TOZ7jB0Ipn+hjsjiYRXirvRo7if16R
	Tl3jPHzwufDb9cCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315224; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bC8M9j5KysQj3/tBg6i5bs7GJQfbSn2RIhhiTaj/uW0=;
	b=esCQM7vhwtFDlR0XGu4BvbeJKkz5yWIkyBoCAFmsMjaesvd2xzTBQ75GstxjBGyvm+uTc3
	zbsPxyyuvivvpTctk9VGrw5XL7jzea4xXXiQ33KgF1MkCOuagUmIs2QoSpY/RNulRuLG5X
	2mokPeCKWxi/pNmsgHI/oRHbYwi1nhQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315224;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bC8M9j5KysQj3/tBg6i5bs7GJQfbSn2RIhhiTaj/uW0=;
	b=oSEGdPnxsbYWAcn6+XCX2+zc7aIbagOCqMu6PvH5TOZ7jB0Ipn+hjsjiYRXirvRo7if16R
	Tl3jPHzwufDb9cCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 91DED1339F;
	Tue, 10 Nov 2026 12:53:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tmqdGtgT82pBQQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 12:53:44 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 32CA7224DA; Tue, 10 Nov 2026 13:53:40 +0100 (CET)
Date: Tue, 10 Nov 2026 13:53:40 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
	linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 02/41] nvmet: check that the file backend supports
 ->{read,write}_iter
Message-ID: <shrwrwia6jdxrryror4d2x3d52pwwtfve2pu5ql2af4oo6byxo@dkcq5tu4k4l5>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-2-4c998976c6c7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-2-4c998976c6c7@kernel.org>
X-Spam-Level: 
X-Spam-Score: -12.80
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0E909180006
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: 5rrqd9wwagb6hg58owgxdynfwr1nbt6t
X-HE-Tag: 1794315225-58836
X-HE-Meta: U2FsdGVkX19kw3+sJTFRw2j7mxvXdXbbqLIGYOMK+DOM7E6AyWTjRdp84EYhnqrXFcYq202Mon3pHP9kDgPLw/ree3awdrP19SEpm67XnYIBcqycVeTycWpiXjdvOqXOkAM3O9N1MoS3aWsC02iZux1Rng7No85sgi1ZB2p8yHVMWt+kZTbogRDvLr5bWocuKLBj6uKWlwNmIRgtjf0tHJ/pdg/GbOp8Z+b7PfqWkjcarVEag4DWnDZyoI8a/FHhUckTXWIxu2TfyVoLk+r3uNFdtzR4zLKlPh3gziBJ/5lXD/nS3VR7U8O2XlUErjtnvQTow1kzFXo1kO3woox4vGgYjO5D3+x32e0VSmliT99Xn9MRgysTN5jtqWD2LnFmH39V+aVH28FN1lmV9q+uKQGpcHE21kjg342tHca8eENsoykuit5hSRcvM6u79A9Xu/57dw+3j777hY6l9CJS46fZEFp1gZfcJ9+YUl/pLEjuDb7hPX4x9wkJm2DQtnXGFJ9IQrrbhxcynEsSPonbsk1b63a1xjBr1u3n9IC1q6x3vgVc5HUvuEneeYK0LlLza8zJ9JGLQGiLWTlp+qqXfYAmCZoozNQejz7dE2YdnUHYS5EoGVoDaTVGHHWQgHX52yQTj9nCkstL+wADxwa7eAGmiquo5w1ZnU3qO7GGBVhQLeWsJVdWcbctZa/fZRbgG8/HsUGdPoDfP8KpYwmyVGyhpwWK0n8H2d2NanYfOxK3X/Q4vs0cTDmlogj04TFuonDOzeSJohBwL/frLdXRNz3ooHOvh1qfgkjzdnH64F0d/La7PkXn/n83pHEYn9HeT3vVZtvrtcKsm9kSRulQQLAa1P5R1GTvoDm5tuj3HrXtAABOoIDiqxT7D5u6DRABitzNNCkUiTZM931iEffqQJlovxZlsSJLhy0PqHO14QriwQefiw6qkmq9PXnD7MZ6PINpWNGcSXwOdzMRc1R
 ze48WFL1
 B1UE6p6bqeFS51dWZptXtiFYCU7rSC6non9VdfdAq+OtozvURY5BSYQP/uzGcaLomBs85Hq2RWNT1q5N42UqeMERqbUatmWwTln0JkHh2wxfKQiQrwIfuWrrP17rlw/tqc097Dg4etg6gW9/P1353GhJpOuojsJvaNwysdFTSpqGTrIhbd2MgDnBNKj+CkQmudWBE41Qy0+Neq3oi32xx0TlEhdOvW2D8jwTl0cp7JL+blScUCBLd4SyVLZIayUUZGjLWWZwNYXouNv2/GBbfkkHqf3i2hx2wDddakUo7iNfgUQKEN32AVT5wpOeJjKwaUm/HJz6F6zzOL4VZsgIcuzTgBYAC4EHBquSMvSK675E2EpaOUDEo5UCjIhwfBfnS2MDC1x5cBsLRVRb4lbWKVT/Eriw1rWcL5Oi/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue 10-11-26 10:14:18, Christian Brauner wrote:
> The file backend calls ->read_iter() and ->write_iter() of the backing
> file directly but never checks that they exist. Everything that isn't a
> block device ends up in the file backend. So a namespace pointing to a
> file without them calls a NULL pointer on its first I/O. Only
> buffered_io=1 gets that far as the O_DIRECT open fails for such files.
> 
> Refuse them when the namespace is enabled the same way zloop does since
> commit 0c10f8a1a7ae ("zloop: check that the zone backing file support
> ->{read,write}_iter").
> 
> Fixes: d5eff33ee6f8 ("nvmet: add simple file backed ns support")
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  drivers/nvme/target/io-cmd-file.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
> index 695963dd932e..dfa8aa46188c 100644
> --- a/drivers/nvme/target/io-cmd-file.c
> +++ b/drivers/nvme/target/io-cmd-file.c
> @@ -47,6 +47,11 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
>  		return ret;
>  	}
>  
> +	if (!ns->file->f_op->read_iter || !ns->file->f_op->write_iter) {
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +
>  	nvmet_file_ns_revalidate(ns);
>  
>  	/*
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

