Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC00060A2608
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=24m00Mxy;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=gWL5bCh6;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=24m00Mxy;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=gWL5bCh6
Received: by kanga.kvack.org (Postfix)
	id D0F676B05BD; Tue, 10 Nov 2026 09:19:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB7B26B05BE; Tue, 10 Nov 2026 09:19:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA6F26B05BF; Tue, 10 Nov 2026 09:19:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8880A6B05BD
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:19:42 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7D1061A090E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:19:41 +0000 (UTC)
X-FDA: 85419417762.04.91AC6AB
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id 324F940006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:19:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=24m00Mxy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gWL5bCh6;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=24m00Mxy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gWL5bCh6;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794320379;
	b=xanhSEc6bO8m/xGfNR8wEhp1z9Gs41MknmxPrSlU7rwN8CHp3TWARhmODVZlz1ljIXQ1cs
	udhMWHzSY6juKxrGz1UMMNYymZq2xjrF6XhbaWfNdkadWtwuQIjcS2hWQ1SrEq9xcmfcjU
	RcZ1yBsD6mhABOJFeTNa5FLgvcE2C4I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794320379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ey86SkVvx7i9NDOgarxUx2o/w+Rx/Wx0u51qrIOGmpM=;
	b=77FDMrd0ffRM5Rxg9g6NiPBsMqGEXIh2q0k/0nVKnWioyU21IS9aDoWBeE9B7Iu1fQMW22
	E2Zd9PyUZRl7Va2gSk52siJcRtOWkaykzzLJMg7TIHrw+wK5hgjLJ1Wxklcpx6cLGQ/14H
	jZ9kMWeI1BGgAiU8daL03f1dWrePqdk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=24m00Mxy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gWL5bCh6;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=24m00Mxy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gWL5bCh6;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8A12F21E31;
	Tue, 10 Nov 2026 14:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794320377; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ey86SkVvx7i9NDOgarxUx2o/w+Rx/Wx0u51qrIOGmpM=;
	b=24m00MxyS14C4kCTYYtxKWJP25EBVNVIxLRshWhDnl2XZwRpRipDNZJw4Avu/J2svsqCMy
	VTYT/SHAlqxbP0FIU7B9V7eV3/1rBXkEe/Lcm9f8ja9SENmigoj1MKRmnopRtQWBaY3OFh
	eux20BDfQ6AJqBojuMAzQiJJg3QKDxU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794320377;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ey86SkVvx7i9NDOgarxUx2o/w+Rx/Wx0u51qrIOGmpM=;
	b=gWL5bCh6bmxfDaClyKTxrGr/cthAMhYHhVBSAgTvyrROUNgpSm1do5CLIUVQzQAzFJlTzk
	zIhImlSyPcZvZwDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794320377; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ey86SkVvx7i9NDOgarxUx2o/w+Rx/Wx0u51qrIOGmpM=;
	b=24m00MxyS14C4kCTYYtxKWJP25EBVNVIxLRshWhDnl2XZwRpRipDNZJw4Avu/J2svsqCMy
	VTYT/SHAlqxbP0FIU7B9V7eV3/1rBXkEe/Lcm9f8ja9SENmigoj1MKRmnopRtQWBaY3OFh
	eux20BDfQ6AJqBojuMAzQiJJg3QKDxU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794320377;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ey86SkVvx7i9NDOgarxUx2o/w+Rx/Wx0u51qrIOGmpM=;
	b=gWL5bCh6bmxfDaClyKTxrGr/cthAMhYHhVBSAgTvyrROUNgpSm1do5CLIUVQzQAzFJlTzk
	zIhImlSyPcZvZwDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5517613479;
	Tue, 10 Nov 2026 14:19:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id I5aLDPkn82qLGgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 14:19:37 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id D0CEC22536; Tue, 10 Nov 2026 15:19:36 +0100 (CET)
Date: Tue, 10 Nov 2026 15:19:36 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
	Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Eric Dumazet <edumazet@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
	Greg Kroah-Hartman <gregkh@suse.de>, Joel Granados <joel.granados@kernel.org>, 
	Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
	linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-acpi@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	netdev@vger.kernel.org, ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
	coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org, 
	linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	ibm-acpi-devel@lists.sourceforge.net, jfs-discussion@lists.sourceforge.net, 
	linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-sh@vger.kernel.org, linux-usb@vger.kernel.org, samba-technical@lists.samba.org, 
	sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net, 
	Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, linux-debuggers@vger.kernel.org, 
	Chuck Lever <cel@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2 29/51] proc: don't walk through a non-directory when
 resolving a name
Message-ID: <okuebbxuf5q6xy452dlnxaqwainsafs5waulvn54j3vqxg2dhx@hh6ql7sg3pte>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
 <20261104-work-procfs-bugfixes-v2-29-bbf7d5546809@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104-work-procfs-bugfixes-v2-29-bbf7d5546809@kernel.org>
X-Spam-Level: 
X-Spam-Score: -11.30
X-Rspamd-Queue-Id: 324F940006
X-Rspamd-Server: rspam12
X-Stat-Signature: pxaezc3idn75fdamhjz3uyqa1xs5edtq
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1794320379-641385
X-HE-Meta: U2FsdGVkX18lISTL6HqVAxapoVw7MlArmGwzP/38sdfJjl1SJZvkChzWwOaTBaahQYheIvnIVrG71ZpyMDBolCadCJLBBlkAwhouk+EgVYoi6J+pL4rFEkemfIOsNRnjYgT7u7+7M0CKDiapLboIP4p6R1bh9U0Spr3fVOlVepel65Ozwp0uQRolMQjsfE7a5IlPflX0cqIXUCk6XOq93+R0RohXhddNighHo3ZkJm2j34bOOM7nVPL1Fkayopi1y2rtjOsP5pePY0qdhLwQdTuFyCRZmVAmFQUeile4Ll6hxoYLLZgcVi6LAod8Z09C0dRdj69qO157j7Qi+8ChG2Mr5yiEdaE4y+UUr6vFUc2sJw1tn2IokgJJ4q+Ss8+dzBgB6lbS+1tZD4CZP6C9WhWjeI+0zpTHiKsYDAt/ZRLw8abT9cP5vgMp54M1g0JWW+4ihPEbZKoWBMxwKRob1LKQcs08SfuAe5AlftYf1ma4JYLbeCsKRfnpk+XQTcTJdVJ5XH7fPaKByrJ4yySFPi4/Bhzoy5z0DjmULhcomyx5INsPKVVJX+Xhzu5h7/Uh6sov3UtLqukxwR2VixONw61ZgowVX87xzJB459eEsAqxssCRnJ5BvPWurZAir+33zqbz28Y77hFLpiekGa2Q9p889r30RUDdIsIVw18Iu62UJ+ixo8CHgU5/os631NrhdbQKpyg5uHevsQ9rnCuum6biIuLKkaEy3InEdr6xpvSNuJI99eSH8udSdNMyA4UK4byrqOJ3fZeyXIX0OkX9tUBMSFMvOveO6OKXdi4uJK6Nup4hEldx7g0vdKLfsvRGcNYb3gtKsZt5q0yVP6fi009Oi1Zz5CfrAbFv6NaJg5ml+FaDAEWq8s46w2OaQTkPmsVNNY3GRMyQYnde76Tt5mbUDJCpQxBfWBPvY4d1uVBq3ECqJdqLLtp/A2+j2BG91KJrReXALlKE+PlUGjW
 ZGG6WALC
 crQdZJkpjeLrCdHj/j+WzhAPn/A5PLTEReKGik+rdnYvVjmlS6673LXjpwdO4ZRFY/VqZ5iIBZqUoAq8q3ZdkbBVcrHHFmjbASt7ujoaVvJwOne13Gd9A3Sv37zmlQ1k4Ao+3vehVTWHGhAv11dXMM3Wt3xocjOzgfTYPJ9SVTGJnfjCD1OFg+OBpHJ1bKvF1f4U9SKzqNYDINiAiAhGK9TJjs1TOyyz1EdJF76GmehR7GdNu3nMyn1+9ykxXdQQXjWkasFgGnJ54hElHcQB7Epp6hxA/+XJnAPSg818b3esTdk9K3w+44Umjx3sPMlJqSGTUF4+5zD/8dD7Hw4oA3apKNcafJmM792TqwofiiSIN5Zf8mS9j8bNAE3zl9KEmeo+45YARWdcS3kOEf7nJkRW5wi7FYlRbZU7pUmaQu9gCRwPkqHAALec1XwUZq6VVs7b74EwsypJx2nDIfP+NCjPaFmPqtLSBSM+hKfSixucQUBhwNX3S/sLI7ApwLHnGIjeSkN/wm/lCL6UVdD66sCahlJQgSzKE9HDF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed 04-11-26 18:47:15, Christian Brauner wrote:
> __xlate_proc_name() walks the components of a name like "a/b/c" and
> takes whatever it finds for "a" and "b" as the directory to go on in.
> It never checks that they actually are directories. So
> proc_create("file/x") hangs x into the subdir tree of the regular file
> "file". Nobody can look x up there, but remove_proc_subtree() on the
> file removes and frees x along with it, behind the back of whoever
> registered x.
> 
> pktgen passes the name the writer of "add_device" picks to
> proc_create_data(), and only the part in front of the '@' has to name
> a network device:
> 
>   echo "add_device lo@"   > /proc/net/pktgen/kpktgend_0
>   echo "add_device lo@/x" > /proc/net/pktgen/kpktgend_1
>   echo "rem_device_all"   > /proc/net/pktgen/kpktgend_0
>   echo "rem_device_all"   > /proc/net/pktgen/kpktgend_1
> 
> The third write frees both entries and the fourth one makes kpktgend_1
> call proc_remove() on the freed second one:
> 
>   BUG: KASAN: slab-use-after-free in proc_remove+0x8f/0xa0
>   Read of size 8 at addr ff110001134c8e70 by task kpktgend_1/243
>   Call Trace:
>    proc_remove+0x8f/0xa0
>    pktgen_remove_device.isra.0+0x118/0x500
>    pktgen_rem_all_ifs+0xeb/0x1a0
>    pktgen_thread_worker+0x1b42/0x7280
> 
> The files of a network namespace belong to the root of its user
> namespace and these writes don't require a capability. So once pktgen
> is loaded an unprivileged user can do this in namespaces of its own.
> 
> Treat a component that isn't a directory like one that doesn't exist.
> All names with a '/' that the tree passes in as literals only walk
> through directories. pktgen is fixed separately to not pass such names
> in the first place.
> 
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/proc/generic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/proc/generic.c b/fs/proc/generic.c
> index 4c3fcaf68ef4..6ac9c4c13897 100644
> --- a/fs/proc/generic.c
> +++ b/fs/proc/generic.c
> @@ -170,7 +170,7 @@ static int __xlate_proc_name(const char *name, struct proc_dir_entry **ret,
>  	de = *ret ?: &proc_root;
>  	while ((next = strchr(cp, '/')) != NULL) {
>  		de = pde_subdir_find(de, cp, next - cp);
> -		if (!de) {
> +		if (!de || !S_ISDIR(de->mode)) {
>  			WARN(1, "name '%s'\n", name);
>  			return -ENOENT;
>  		}
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

