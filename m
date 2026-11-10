Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAFCD60A261A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=cleAenUy;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ICAGaDTX;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=tbbT67pL;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=nKlZx/FD
Received: by kanga.kvack.org (Postfix)
	id CFBCF6B05B4; Tue, 10 Nov 2026 07:28:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAF026B05B5; Tue, 10 Nov 2026 07:28:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC4796B05B6; Tue, 10 Nov 2026 07:28:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 887D66B05B4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:28:00 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 810A9A8486
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:27:59 +0000 (UTC)
X-FDA: 85419136278.27.29F8C0E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id 24B771C0005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:27:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cleAenUy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ICAGaDTX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tbbT67pL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="nKlZx/FD";
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794313677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ODg2UFDqxMR4SMBKAdSOXIf/FKBdj9ahq9IsfjbokI0=;
	b=WAVrMO4L/oX9vPimVZXEzBSbpYzV5GwYDgvGmhBoiJfA5KXmcwDR2QyjlEe/64VkrvK0X3
	kShmAvJ9GrYUoo+6eqg0mEa26XPEquXxJMDhXx3LrsivB2nizcOhJ07wRyGHhVAYyjJXvh
	Ai5OGCU7TByq0ZFq9PReFRaWGq9UUpQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794313677;
	b=oqoxhWz32Zms6Z4jYh0gqUOLbAUyc1gqfam7puMRCTz9KojZM489RJWGwOHiCniPdDnTOc
	v04ygEGUC/FcKEc1/a3fbV2FcCkmsTFkcPaFQqLS8IEn1ChenVRq8qRP60K9hAsI7SNP8B
	tA7CzD7uLkfys8xoKt/C5asX0QQ7A60=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cleAenUy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ICAGaDTX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tbbT67pL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="nKlZx/FD";
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 37BE61F461;
	Tue, 10 Nov 2026 12:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794313675; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ODg2UFDqxMR4SMBKAdSOXIf/FKBdj9ahq9IsfjbokI0=;
	b=cleAenUyu82p7GD2IkbdhyP20bEeHiv9MCWGsm0Aiv/f8LEImD1EvWdBTTdO9JhtisjXHR
	ExxdXPXAeV8I+EnWyEpZiiorURtwH2Wm4odZQtTfPPreXAa67LmxZ1HmvN9E3BM7QNtDcU
	4KeMJBseUJizkUTYAQLMFuz3T3EOtBI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794313675;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ODg2UFDqxMR4SMBKAdSOXIf/FKBdj9ahq9IsfjbokI0=;
	b=ICAGaDTXmuJrmJVNM+1/WwP4pezIcgwixY/McCKZSI7w0N2Fyl80B71aqLiIo0zpyBKBbr
	jXzswycp8CRKgmDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794313674; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ODg2UFDqxMR4SMBKAdSOXIf/FKBdj9ahq9IsfjbokI0=;
	b=tbbT67pLRwGjbhPH67eiBvLFjHHgj9x2wstTb9NBa9OaUxb37D7EZAkGnDI14lQO6x7v5E
	fyUNB0q5BkqRx+7qHhfpoALjnq2e6piJEK/U+4PaTMI1QhVIgyyPNKVx/yJNRXaq9+In+Z
	FgKHeymPfWh+iDjotDpzeRlK2dmWcko=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794313674;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ODg2UFDqxMR4SMBKAdSOXIf/FKBdj9ahq9IsfjbokI0=;
	b=nKlZx/FDPCcSP2B+uAAFIXqbyoTZqWoQrwC//XF2bdGeUsQy78M9To25spcjkF10avjXfa
	d4YharWvNjkfutDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 05DAC1339F;
	Tue, 10 Nov 2026 12:27:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id h7E8M8kN82oVJwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 12:27:54 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 7C0D2224C5; Tue, 10 Nov 2026 13:27:53 +0100 (CET)
Date: Tue, 10 Nov 2026 13:27:53 +0100
From: Jan Kara <jack@suse.cz>
To: Andrea Righi <arighi@nvidia.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Quan Liu <qualiu@nvidia.com>, 
	Lee Trager <ltrager@nvidia.com>, Seth Forshee <sforshee@nvidia.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] pipe: Prefer mempolicy node for metadata allocations
Message-ID: <hbkxlhc5y2jkvuov5o2kjgpisx2pavuo3ad4c4ydixeic7vaq6@mpzzfmhjvtof>
References: <20261110065219.894219-1-arighi@nvidia.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110065219.894219-1-arighi@nvidia.com>
X-Spam-Level: 
X-Spam-Score: -12.80
X-Rspamd-Server: rspam06
X-Stat-Signature: 963ticom48gpdwp8gmbww93a4iy89g6s
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 24B771C0005
X-Rspam-User: 
X-HE-Tag: 1794313676-402910
X-HE-Meta: U2FsdGVkX1/u97e9ARB3jgFI6jMJHQzTlDuO50za5ToxFigHNLfXR6iLr4ReO9/ynjGJx3vrFWqG3DJdenUzALOH6TseoepK6Mnz75scRsdTIsuHDbb718FSfehmxoz5uKZnLpMNMeyOaleOL+wsbJPxUuOHEd76vii0jh/g8z+LgCrMV87ag9lMQJ1soEI9LJX+9f0hQRPs5CGXwjiyOOkoIqrSaNf1iydHYmTxuuZPwVgy1lzF9za+h0sIAsKXnPfbNMMFb91ZCYtcS6wtb6TFpag9s0uzFxxPywaP5ZyR3dyqX4DMp1o4cVvLo1qdbTEw7ceevw3hnMUSo+PUFXz3DjRGFhiRReaBXEyl9QfPouQESNRzBpeGFpwE4g/2Y/Q939QsUrgn9MbMx3jeApfD4DZcW2s1DtlPI3R2cme7YqoBf8JnN5Clutpx8zqeJjycNfmD5tTGmT7W9ujclTl4w9ctWj5KqeOBvEOQgRenpKeNTYdnrFrmESyJjzV2MqxA056wmlAzyNwdSewRqQi4QXuEQ3ymUB43WUf1bEVjGUDk1qbJdmQd01+ioWhpi7nBR+EzwO6jL+Fb2mWbBnna6cisO0WzmSIOUQrW/WcuyKqXn9nnbGLtI/Y/Tc880d4V76tX5UlBCnenYHIV8UxugT9u76g+jzqsjx3ZVGQsRyJ4w8i7oXRBTIaWGx20WjgGW6jyFgtYXmbsdiVs/QAEiH9/ib61NfR+U7w5h9qSorWpD6K6XJYyMmI8HxrbLniMXXUbxYMFnIAkVzZrDa0fL9/zEp06yQcOrdsx17Y3lCA2Fe77aUKPR6tnAMwP5WXj0JveDS/8jF9SEQbZOp9a4n20uHqsgDGrxtCBypIHgmzlH4l6OcC2AbsKLsaEqPrmzu3FpgRtORuZvEHMYfsznoi8El2Q2tvGdWLSDoT3xmlJ1B0JwXRWXq3IPozt0YsKMVbxV9gi+eqdoz+
 Fx1tLLUz
 f0Q1D0B6DftflM/V/IkVZtRLj/PiOxRgkwN9d7MWHMppbxkIvvLQyb7/Nm3dxqCMqNlWJTmgl4Vx3kT0pofMYPjCAOcMqg02UQuE2GVy9xxiWt0yWj2lpVe0bgKyFDmAkA2P2wo0upqEXxJ4W5m7ZPYhaisHukCjRjKVXPThQgZ919JuWQko0Xz+6F122OSx6c0bdSLOxunOW9JLuVjHeRfhyzX7/aw9JhzhkVdjnCP4br6SQDiNvTzYefsmvvJBh4YNXP23LkRTb1e+09iHtZqdMGr+6zUgoJSnr2NpEg0iAbr2FTSTpC0MFRMvbOBxZMSAY52fgYeffWyGImiXVSbPsj8oiMtCb4srvuECZ9I/+IQI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue 10-11-26 07:52:19, Andrea Righi wrote:
> Generic slab allocations can reuse partial slabs from another NUMA node,
> even when a pipe workload is bound to one node. Pipe metadata is shared
> between senders and receivers and accessed throughout the pipe lifetime.
> Reusing remote metadata can therefore make an IPC workload pay remote
> access and coherence costs on every exchange.
> 
> The target use case is a workload that binds its workers and memory to
> one NUMA node with numactl. The policy node is then a useful placement
> hint for shared pipe metadata.
> 
> Allocate pipe_inode_info and its descriptor array on the node selected
> by the caller's memory policy. Apply the same preference when replacing
> slab-sized descriptor arrays during ring resizing. An explicit node lets
> SLUB try local allocations before reusing remote partial slabs.
> 
> For descriptor arrays larger than KMALLOC_MAX_CACHE_SIZE, pass
> NUMA_NO_NODE to keep the policy-aware page allocation path. An explicit
> node would otherwise lose the MPOL_BIND nodemask on fallback. Select the
> policy node only for slab-sized arrays, avoiding an extra advance of an
> interleave policy for large allocations.
> 
> Moving a pipe's users to another node doesn't migrate its existing
> metadata, so migration can still result in remote accesses regardless of
> this change. Generic allocations may reuse remote partial slabs, making
> initial placement dependent on allocator state. In contrast, preferring
> the policy node leverages the workload's placement hint to improve
> locality when users remain on the intended node.
> 
> Testing has been performed on a dual-socket NVIDIA Vera system, covering
> hackbench, pipe transfers, pipe creation and resizing, pipe_bench, and
> targeted stress tests.
> 
> The primary hackbench reproducer is:
> 
>   $ numactl --physcpubind=0-87 --membind=0 \
>       hackbench -P -p -g 10 -f 20 -s 100 -l 100000
> 
> Results (over 10 measured runs per case):
> 
>               avg       stdev
>    before     9.811s    0.130s
>    after      5.770s    0.058s
> 
> Before this change, allocations could reuse remote pipe metadata. With
> this change, both pipe objects and descriptor arrays are allocated on
> the requested node, improving locality and reducing hackbench runtime by
> approximately 41%.
> 
> Reported-by: Quan Liu <qualiu@nvidia.com>
> Signed-off-by: Andrea Righi <arighi@nvidia.com>

To me this makes sense so feel free to add:

Acked-by: Jan Kara <jack@suse.cz>

But IMHO it deserves a look from MM guys since this is more of an MM thing
than a filesystem one... Added to CC.

								Honza

> ---
>  fs/pipe.c | 26 ++++++++++++++++++++++----
>  1 file changed, 22 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/pipe.c b/fs/pipe.c
> index 4fa69192e6fba..2a8f9e9f70f84 100644
> --- a/fs/pipe.c
> +++ b/fs/pipe.c
> @@ -24,6 +24,7 @@
>  #include <linux/syscalls.h>
>  #include <linux/fcntl.h>
>  #include <linux/memcontrol.h>
> +#include <linux/mempolicy.h>
>  #include <linux/watch_queue.h>
>  #include <linux/sysctl.h>
>  #include <linux/sort.h>
> @@ -874,6 +875,16 @@ bool pipe_is_unprivileged_user(void)
>  	return !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN);
>  }
>  
> +/* Prefer the policy node over remote partial slabs, retaining fallback. */
> +static int pipe_slab_node(void)
> +{
> +#ifdef CONFIG_NUMA
> +	return mempolicy_slab_node();
> +#else
> +	return NUMA_NO_NODE;
> +#endif
> +}
> +
>  struct pipe_inode_info *alloc_pipe_info(void)
>  {
>  	struct pipe_inode_info *pipe;
> @@ -881,8 +892,9 @@ struct pipe_inode_info *alloc_pipe_info(void)
>  	struct user_struct *user = get_current_user();
>  	unsigned long user_bufs;
>  	unsigned int max_size = READ_ONCE(pipe_max_size);
> +	int node = pipe_slab_node();
>  
> -	pipe = kzalloc_obj(struct pipe_inode_info, GFP_KERNEL_ACCOUNT);
> +	pipe = kzalloc_node(sizeof(*pipe), GFP_KERNEL_ACCOUNT, node);
>  	if (pipe == NULL)
>  		goto out_free_uid;
>  
> @@ -899,8 +911,8 @@ struct pipe_inode_info *alloc_pipe_info(void)
>  	if (too_many_pipe_buffers_hard(user_bufs) && pipe_is_unprivileged_user())
>  		goto out_revert_acct;
>  
> -	pipe->bufs = kzalloc_objs(struct pipe_buffer, pipe_bufs,
> -				  GFP_KERNEL_ACCOUNT);
> +	pipe->bufs = kcalloc_node(pipe_bufs, sizeof(*pipe->bufs),
> +				  GFP_KERNEL_ACCOUNT, node);
>  
>  	if (pipe->bufs) {
>  		init_waitqueue_head(&pipe->rd_wait);
> @@ -1375,12 +1387,18 @@ int pipe_resize_ring(struct pipe_inode_info *pipe, unsigned int nr_slots)
>  {
>  	struct pipe_buffer *bufs;
>  	unsigned int head, tail, mask, n;
> +	int node = NUMA_NO_NODE;
>  
>  	/* nr_slots larger than limits of pipe->{head,tail} */
>  	if (unlikely(nr_slots > (pipe_index_t)-1u))
>  		return -EINVAL;
>  
> -	bufs = kzalloc_objs(*bufs, nr_slots, GFP_KERNEL_ACCOUNT | __GFP_NOWARN);
> +	/* Keep the policy nodemask for allocations that bypass slab caches. */
> +	if (nr_slots <= KMALLOC_MAX_CACHE_SIZE / sizeof(*bufs))
> +		node = pipe_slab_node();
> +
> +	bufs = kcalloc_node(nr_slots, sizeof(*bufs),
> +			    GFP_KERNEL_ACCOUNT | __GFP_NOWARN, node);
>  	if (unlikely(!bufs))
>  		return -ENOMEM;
>  
> -- 
> 2.56.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

