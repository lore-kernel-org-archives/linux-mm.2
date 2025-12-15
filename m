Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24E93D5B16F
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 12:58:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 759F16B0007; Mon, 15 Dec 2025 07:58:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E39C6B0008; Mon, 15 Dec 2025 07:58:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 584766B000A; Mon, 15 Dec 2025 07:58:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4328A6B0007
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 07:58:00 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B6E9D134D20
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 12:57:59 +0000 (UTC)
X-FDA: 84221707878.02.C06725E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id 525671A000C
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 12:57:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pwB5aJIj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uhL6Wzq1;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wbudG5tR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/lEzb7cY";
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765803477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+MMpU8iu26hMrIy/s70C2uUD4P60923K9CkgBqEJuQM=;
	b=ldrT6vSMyhCVeOmQw+a0jsU7BiBeIJaJovJl1z3gEeshC7UWqbK2fKGeljlUYozhdDTKB9
	/glV3CS2v4j6YgiZEG3bQwRF7AYmGna4hp49T5OFxYbKEqguNec9EuGcCGsl7U/+Fuqj6P
	/O+eEqZpxJ4rQVyXUSDS6YMrVoUVycE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pwB5aJIj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uhL6Wzq1;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wbudG5tR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/lEzb7cY";
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765803477; a=rsa-sha256;
	cv=none;
	b=JH74T4Grv4P9Rq9g5sM59KMXHBUGFTozb8lpD5hrsmpLh4cyXxNoGPEHLFWDaYOe4pjwFh
	O3QiC28t2jVc3c/JXWo9kASJNGQ+FBbVlfL5EDB21cfEalkzht4J3CWFBmpGGfduKUQ23t
	8J86/TuYRveiufpTOk+z//8cpqMaJDs=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C790F5BDC1;
	Mon, 15 Dec 2025 12:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765803475; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+MMpU8iu26hMrIy/s70C2uUD4P60923K9CkgBqEJuQM=;
	b=pwB5aJIjn8phLTPx90dciLVvvsfvcKP4gkJ66yBeotWcB8KfB5XiqvoFO7jy2uTkyC7Yb0
	JZLMWnyBnFSISomtilFsdBk9B36BOYrswpfuNRST6oxzuo68CfSRARwKaa2cXsYIM2sUeE
	4lDFqwFwDELbInSqS57Nt+ZBmoPWBs0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765803475;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+MMpU8iu26hMrIy/s70C2uUD4P60923K9CkgBqEJuQM=;
	b=uhL6Wzq1R+PNBj6rfCcqGNMgxtVxaRnHoZyyToVvx4kGFick0Y9bgj6VQ/quRzQ0+xnmCi
	0lYA7snQbCFB6cBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765803474; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+MMpU8iu26hMrIy/s70C2uUD4P60923K9CkgBqEJuQM=;
	b=wbudG5tRrT5mSpJlFzatkqSwIBsOCTdfoHnUgi2Sq9omNJkKuKsXswef7UpkpzalsaCUOA
	Dll6hqGranEacsANrMAceL1D8/syjts30TI7weAKtY3ETHR/fxxKgSWzqbzQyiEzCS6Ldm
	vwP4EuI/mR5KXUTIq6jvDZNHMvAhH44=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765803474;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+MMpU8iu26hMrIy/s70C2uUD4P60923K9CkgBqEJuQM=;
	b=/lEzb7cYQcLGYieeI0FGHc2j6U844YUTFaZ0ICjqymlBjCArBNNka7sLpYwDMBbyBbL1c4
	SAALQB2mHJPlRmCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B77483EA65;
	Mon, 15 Dec 2025 12:57:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3lEkLNIFQGkhTQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 15 Dec 2025 12:57:54 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6303FA0951; Mon, 15 Dec 2025 13:57:39 +0100 (CET)
Date: Mon, 15 Dec 2025 13:57:39 +0100
From: Jan Kara <jack@suse.cz>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux AMDGPU <amd-gfx@lists.freedesktop.org>, Linux DRI Development <dri-devel@lists.freedesktop.org>, 
	Linux Filesystems Development <linux-fsdevel@vger.kernel.org>, Linux Media <linux-media@vger.kernel.org>, 
	linaro-mm-sig@lists.linaro.org, kasan-dev@googlegroups.com, 
	Linux Virtualization <virtualization@lists.linux.dev>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Network Bridge <bridge@lists.linux.dev>, Linux Networking <netdev@vger.kernel.org>, 
	Harry Wentland <harry.wentland@amd.com>, Leo Li <sunpeng.li@amd.com>, 
	Rodrigo Siqueira <siqueira@igalia.com>, Alex Deucher <alexander.deucher@amd.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Matthew Brost <matthew.brost@intel.com>, Danilo Krummrich <dakr@kernel.org>, 
	Philipp Stanner <phasta@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Sumit Semwal <sumit.semwal@linaro.org>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Nikolay Aleksandrov <razor@blackwall.org>, 
	Ido Schimmel <idosch@nvidia.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Taimur Hassan <Syed.Hassan@amd.com>, Wayne Lin <Wayne.Lin@amd.com>, Alex Hung <alex.hung@amd.com>, 
	Aurabindo Pillai <aurabindo.pillai@amd.com>, Dillon Varone <Dillon.Varone@amd.com>, 
	George Shen <george.shen@amd.com>, Aric Cyr <aric.cyr@amd.com>, Cruise Hung <Cruise.Hung@amd.com>, 
	Mario Limonciello <mario.limonciello@amd.com>, Sunil Khatri <sunil.khatri@amd.com>, 
	Dominik Kaszewski <dominik.kaszewski@amd.com>, David Hildenbrand <david@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Max Kellermann <max.kellermann@ionos.com>, "Nysal Jan K.A." <nysal@linux.ibm.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Alexey Skidanov <alexey.skidanov@intel.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Vitaly Wool <vitaly.wool@konsulko.se>, Harry Yoo <harry.yoo@oracle.com>, 
	Mateusz Guzik <mjguzik@gmail.com>, NeilBrown <neil@brown.name>, Amir Goldstein <amir73il@gmail.com>, 
	Jeff Layton <jlayton@kernel.org>, Ivan Lipski <ivan.lipski@amd.com>, Tao Zhou <tao.zhou1@amd.com>, 
	YiPeng Chai <YiPeng.Chai@amd.com>, Hawking Zhang <Hawking.Zhang@amd.com>, 
	Lyude Paul <lyude@redhat.com>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Luben Tuikov <luben.tuikov@amd.com>, Matthew Auld <matthew.auld@intel.com>, 
	Roopa Prabhu <roopa@cumulusnetworks.com>, Mao Zhu <zhumao001@208suo.com>, 
	Shaomin Deng <dengshaomin@cdjrlc.com>, Charles Han <hanchunchao@inspur.com>, 
	Jilin Yuan <yuanjilin@cdjrlc.com>, Swaraj Gaikwad <swarajgaikwad1925@gmail.com>, 
	George Anthony Vernon <contact@gvernon.com>
Subject: Re: [PATCH 07/14] fs: Describe @isnew parameter in ilookup5_nowait()
Message-ID: <qxbixswc7daxb3y7o7ebmy34dpa3uv6i5vc2fnj2p6f3sckulk@vcbuzldig7al>
References: <20251215113903.46555-1-bagasdotme@gmail.com>
 <20251215113903.46555-8-bagasdotme@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215113903.46555-8-bagasdotme@gmail.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam02
X-Stat-Signature: cm5fgchagrkdi75qi1ez7xtr7r65eu1h
X-Rspam-User: 
X-Rspamd-Queue-Id: 525671A000C
X-HE-Tag: 1765803477-50576
X-HE-Meta: U2FsdGVkX183InUh80TsV5pAzOwj1dps4SXA6MmuzlTK6VjFGbt/HpPmo2zl3Yhl03odP2xfzbW9KiO39ft8C8S6hqhuhidI0Qq6/W4fUBpN+4hRWTMvgpoY8NpOpNVtthFoPI2w+8K/U+cXKHpAapTWhEEU3l5GFmlLJnlCVL72z5yBoisjN+o3emOIDaUpiqaJMUZeCjK9vriLcUK9ZeJFw0GDFJg8bEFFlPOGEuWYvblrJv+HQ3Hj95FiiqexoLiA4eFnVBUTVGTQpLe6B7U/8PiGkCP6yrLzPe32RNd0dCCDoeJEJYgVpJfuP/9DmIiTdUde3b1MLKRr8XK+YIHvRN2ay66izvM9L4Z/j+U5L2ZqeDmWBbYTYROXrpQeoKNUA8mdrGMIKV4d1f+Rw6KMCf8pZQs9JiJwZGNPZzpZZ/wdYUSGHec/jPGoIoEdMNWgk90PXJYAPXGpwGoEYG46lps84U+Y7qephgD71yr5pXl3+vPPvJe7hxZ7fJec2Dw7tPFfHDjMydixHNdMK0K3rPflluOYCU9yDkikFN62yDY8v2JkWWIla4yzb3WG6bgWWjKAD1/3AkkH1mwoqBlobxzNxVJ+0YlFOIqvOk1BnigCz9jZaNiww1sdRx++ALLl75FFchUeZxrTZjTb8kDa6r8QbP4ElIvG935B9vAG9pJCZB0Cr/LMpk6aEcoZ+U9hNsk58ASCC/WQ7qdkFTI+78wD8slFWCIky/cSRbrWomcWPg2oeAmUqQWb9QfFIFhUhMRpCsTXajzesJM1lo4R0X6Vg4HyHTyhBQgOuKeYM39yIFMMLA4O9oIWSu4utzwO7cBgfqCk80v2UY/nFyEzitdMld94mB/IRAO2a7Y+GCtAWgN4WF+TAsKwATmRnpWc7gUUMYNf9MgP56+S2nOEJboaxv2nADhGPEqs6lGk5hI6+2h4++4HsZwc/9MnRAeeMGKik8vN9ZRlhwk
 /t9KJU5p
 LfHkmAwiYh/wphi0+jjeT90ZVqL6AX/3LwTqze8xKaPa/dZE+2BH/jhSpzF40RlZnYBY/psX0zrpygudBu3n+NDfYTuHHrDepO0V0/+otMuct4qSE+1rTyEm/l+cI1shD0eYdgEUgYDGUV5SVG22T1USJj5ERfN2gK8+YJVvNKM+/QBjzDZUYuBANjlP6Vbum8po/IRc6CHsXbDvOz+FkUXa9auZogGbTdOfY0CRRPvCtLK3H/nR+yHJLbtGOrzYqtHSf/IfhzK3qT6zFOj8CeVpDHiIJgRxc89g3jSbFAPvuFpOXo0+0RsjQJ9V7FARkr21c1F9ygtucXLqPC8b6twRSRBqjRFNC4hK80+zng+zm0PZaoWw4j0nQ2lM6zUWzFdwyGjEtGPse65PlMskHoLpg3pTRKAEZKFoq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 15-12-25 18:38:55, Bagas Sanjaya wrote:
> Sphinx reports kernel-doc warning:
> 
> WARNING: ./fs/inode.c:1607 function parameter 'isnew' not described in 'ilookup5_nowait'
> 
> Describe the parameter.
> 
> Fixes: a27628f4363435 ("fs: rework I_NEW handling to operate without fences")
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>

...

> @@ -1593,6 +1593,7 @@ EXPORT_SYMBOL(igrab);
>   * @hashval:	hash value (usually inode number) to search for
>   * @test:	callback used for comparisons between inodes
>   * @data:	opaque data pointer to pass to @test
> + * @isnew:	whether the inode is new or not

I'm sorry but this is true but misleading at the same time. I'd write there
something like:

 * @isnew:    return argument telling whether I_NEW was set when the inode
              was found in hash (the caller needs to wait for I_NEW to clear).


								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

