Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78DD8F33831
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 10:00:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68AD46B0005; Tue, 17 Mar 2026 06:00:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63BA06B0088; Tue, 17 Mar 2026 06:00:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52A3A6B0089; Tue, 17 Mar 2026 06:00:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D7B06B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 06:00:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E6110160612
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:00:51 +0000 (UTC)
X-FDA: 84555111102.20.1C99560
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id 713D9160010
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:00:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="oZJ3/cY6";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=z8+9L0n+;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CX35RV4c;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="t/jEKk2C";
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773741649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3NxxYZ0Z73C+D6nMp9RM66Emm5gr807GrvA6Zh/dc0A=;
	b=hoZkK69tmiokUgfjks3ul01aWfY1d8gJT67Z2dshXhmiOlh9EiBVqoRtSnZYCJ4gbUTWAR
	jfcqHYrJDseS0Q8DZOBoXrKRvfDTQOAGNUYknJNpf8GhVCAgp7lAG72TaOfBNZnidIqxfU
	/yCXREa94rRBsuUSPikrJnO5tlJ8GuM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773741649; a=rsa-sha256;
	cv=none;
	b=acHeesCv1CTts6/ECl7ziCiQEWApTRQ3cnxGMTo8W0k8wjBxns3Klau5pwWy8iZCzxDORR
	RoZuxacvJEQmLfecObpvkfGAqS7MLlozQKOLA/6Z2FeZiyDRbsA6eU5ZSvJc28kSDsISEM
	NO2xk8ZMA3ucCd03ZtkrfZvoj8pqzHA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="oZJ3/cY6";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=z8+9L0n+;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CX35RV4c;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="t/jEKk2C";
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9C3725BDB1;
	Tue, 17 Mar 2026 10:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773741643; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3NxxYZ0Z73C+D6nMp9RM66Emm5gr807GrvA6Zh/dc0A=;
	b=oZJ3/cY6ydGUBsEkcn4dEP5dVa8+6N5TCpbl/uoiRyk4zmmW7J9KBCWw5LYg5qJ9sSUBYN
	kDXicji+Mmuu83eTS1GuU5bfaeUnybdFqqkL+Jwnv/gBugxmNyvsnLCjytkBMSabdBzeo2
	pLuxV3JV9Bq7GlVOwyPPk0QMnb/TzHw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773741643;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3NxxYZ0Z73C+D6nMp9RM66Emm5gr807GrvA6Zh/dc0A=;
	b=z8+9L0n+2BvyNILizCEGBPcuF7FXAXX68hzMw03OLmlBtux01ucO78gQQUP6lspoRnVAHU
	fjJTL+Fs+WzbkkBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773741638; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3NxxYZ0Z73C+D6nMp9RM66Emm5gr807GrvA6Zh/dc0A=;
	b=CX35RV4cPd92rVX9pIFlpypFdx5RdDbqy0m6JgL3N9BAb1bDqCFP/C0Zs6abuDaJbL268b
	RKMPUfa+HwHLtaL4MRvpjsvnT/cJx39tZuQLpkJt2PNatB2G8g6k6iWLCggoPL5w+fPupt
	OQrs5XNahoIFDxhNI9Hmnmsh9lYPs30=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773741638;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3NxxYZ0Z73C+D6nMp9RM66Emm5gr807GrvA6Zh/dc0A=;
	b=t/jEKk2CCIPbv8gHZqK1jU4ncUvF5g0vCKqzpoNhRGjc3w+LQQ99i+VJ4D9TTFrf362JNo
	vbna+wrOzVfO1uAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 833EB4273C;
	Tue, 17 Mar 2026 10:00:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZhkGIEYmuWn0SwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 17 Mar 2026 10:00:38 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 40DE4A0AB1; Tue, 17 Mar 2026 11:00:34 +0100 (CET)
Date: Tue, 17 Mar 2026 11:00:34 +0100
From: Jan Kara <jack@suse.cz>
To: NeilBrown <neil@brown.name>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jeff Layton <jlayton@kernel.org>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
	Jan Harkes <jaharkes@cs.cmu.edu>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Howells <dhowells@redhat.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Steve French <sfrench@samba.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Yuezhang Mo <yuezhang.mo@sony.com>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Breno Leitao <leitao@debian.org>, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, 
	Alex Markuze <amarkuze@redhat.com>, Viacheslav Dubeyko <slava@dubeyko.com>, 
	Tyler Hicks <code@tyhicks.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Jeremy Kerr <jk@ozlabs.org>, Ard Biesheuvel <ardb@kernel.org>, 
	linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, coda@cs.cmu.edu, linux-mm@kvack.org, 
	linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, ceph-devel@vger.kernel.org, 
	ecryptfs@vger.kernel.org, gfs2@lists.linux.dev, linux-um@lists.infradead.org, 
	linux-efi@vger.kernel.org
Subject: Re: [PATCH 32/53] ext4: move dcache modifying code out of
 __ext4_link()
Message-ID: <imo3cvhqtvginngr2ofsotmrsxixutn2jagbkj6322cfgxm3lj@wosdq3xvlym5>
References: <20260312214330.3885211-1-neilb@ownmail.net>
 <20260312214330.3885211-33-neilb@ownmail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312214330.3885211-33-neilb@ownmail.net>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 713D9160010
X-Stat-Signature: sfmj833jbdz9yofnaaoq4riwue547uph
X-Rspam-User: 
X-HE-Tag: 1773741649-315429
X-HE-Meta: U2FsdGVkX1+nvkpLfBU0/pwrC+cp+OLdm3i2bUHnIWMtfzGn5RyME8qBV5IlQtDTl+OZK9aiftoYGZ24HU6L5Rt3BLyR84OCVgbKPKIQVNUwIK1H2dkkuFjtszA59mGhgsxAy/gthBQwnh1UIVgC39Y60XMnbbvliL8hx+ZQFlb+tjSMhoQ43xjiE8caJvDrsWl8SOTT2QPtiBd6J8sakfWJgw3FvuIGbzRvJWJHPWsdSV2Fw6tGHEM9QEitJAJIxbH444aKVLSkrofn9p9Clz0RdSAVovLyrCIs8hYTaMNrItK3g6PZX+y6/xQz1ykaySutPGwcUmxH6AZ9VRxna2LDBvKmxih/0IS2tn41gEukFWarRmdz/71bgwjSIYA0lPrFf+VZOH83IVZ7sfXbDZUlxbX2Xjsjql4bHsZ5YncLIn0Blfcgmo3E1VeAKkReUwN2iTJacK+HPz3OJ0iNoMrbou0kslOxegb4npdH0UfmmoG5MVUTvQ4mTYVi1o5Xw1eZTAjqz4ZYHQ5/BavtDbgHriReSsMyBa9505tB4tjvyWgAeKeava6N77iOum4/XxIS+N4h1RhojVxsRn0QzDsJAPyk++5qDt34+YxUnj0senmbtc6WxxQhQfma282YgtEpmOMqiojjTKrokRzK5eWcwIPkFeX2bWFUoTapTBOtccQHHQsY43umOjNRYxVc62QDq+1ivrMc9pX6XC406x2T6FEfRGuYLjiFxzPVa4VmXkcZPbDgflqZAkWAjH2S3lMDmws4xJDFHyQHRwdfcVQfQyvqpcieS4+nAUhkztC1f7AycYZqIRhSlAc/mj/rUEOjbE39hAqJsHKa0AjvLS+pMpNWs8/CpDHLEK6Sk8jKRAwetcf4MwmSCdnv0P/Cgvf9gnSoLpktdYmF7UzIR3vl0Jwjh15wvxQ8A5/jPyO1u+mH70tVt414sK+1Nqk7ZpPSNBHURf8sO9oeBCb
 2ZdGFtSx
 fSYb9IABcoX4fy9LIzYLvw2ii/+if4zVnhKguHIiB9xZLM/Q8y4DZY3H7S3MZ7NnGcEODAiXMnxIsxfmuCIyI71QuGvJcVVygEsN+7xHkfouufOB6GzOiZskdwNyYTrNhwOKIt64WpfC2Wveu62nzkf2PBJuKV/08DPhDy4OUXt5dPTOOKsiXRRHbyM7sR8BPyvm7BZw+uFSB4ljPqYjeOwhhGuCDKGsTJn4c6KXBwMRLOZTH2b7/erAq8zlJBvj7NQYsm1w66xpB0E+AGHd6xjEvjA9BoRB7QQKklzhOYIa7JdGZvPW2UlMrcTB/qH84tKzRfNfMtBwxO7HMcThBp3SEm4+FMNlCym5xu5vRf8CcOpS9xkYoo7ZOqBN3ZguzYaqeEa4m8l1Tt7h4P8cHAj6vgt0+Vg23vchfF/ElN80RW2g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 13-03-26 08:12:19, NeilBrown wrote:
...
> diff --git a/fs/dcache.c b/fs/dcache.c
> index a1219b446b74..c48337d95f9a 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -358,7 +358,7 @@ static inline int dname_external(const struct dentry *dentry)
>  	return dentry->d_name.name != dentry->d_shortname.string;
>  }
>  
> -void take_dentry_name_snapshot(struct name_snapshot *name, struct dentry *dentry)
> +void take_dentry_name_snapshot(struct name_snapshot *name, const struct dentry *dentry)
>  {
>  	unsigned seq;
>  	const unsigned char *s;

The constification of take_dentry_name_snapshot() should probably be a
separate patch? Also I'd note that this constification (and the
constification of __ext4_fc_track_link()) isn't really needed here because
ext4_fc_track_link() will immediately bail through ext4_fc_disabled() when
fast commit replay is happening so __ext4_fc_track_link() never gets called
in that case - more about that below.

> @@ -1471,7 +1471,15 @@ static int ext4_fc_replay_link_internal(struct super_block *sb,
>  		goto out;
>  	}
>  
> +	ihold(inode);
> +	inc_nlink(inode);
>  	ret = __ext4_link(dir, inode, dentry_inode);
> +	if (ret) {
> +		drop_nlink(inode);
> +		iput(inode);
> +	} else {
> +		d_instantiate(dentry_inode, inode);
> +	}
>  	/*
>  	 * It's possible that link already existed since data blocks
>  	 * for the dir in question got persisted before we crashed OR
...
> @@ -3460,8 +3460,6 @@ int __ext4_link(struct inode *dir, struct inode *inode, struct dentry *dentry)
>  		ext4_handle_sync(handle);
>  
>  	inode_set_ctime_current(inode);
> -	ext4_inc_count(inode);
> -	ihold(inode);
>  
>  	err = ext4_add_entry(handle, dentry, inode);
>  	if (!err) {
> @@ -3471,11 +3469,7 @@ int __ext4_link(struct inode *dir, struct inode *inode, struct dentry *dentry)
>  		 */
>  		if (inode->i_nlink == 1)
>  			ext4_orphan_del(handle, inode);
> -		d_instantiate(dentry, inode);
> -		ext4_fc_track_link(handle, dentry);
> -	} else {
> -		drop_nlink(inode);
> -		iput(inode);
> +		__ext4_fc_track_link(handle, inode, dentry);

This looks wrong. If fastcommit replay is running, we must skip calling
__ext4_fc_track_link(). Similarly if the filesystem is currently
inelligible for fastcommit (due to some complex unsupported operations
running in parallel). Why did you change ext4_fc_track_link() to
__ext4_fc_track_link()?

> @@ -3504,7 +3498,16 @@ static int ext4_link(struct dentry *old_dentry,
>  	err = dquot_initialize(dir);
>  	if (err)
>  		return err;
> -	return __ext4_link(dir, inode, dentry);
> +	ihold(inode);
> +	ext4_inc_count(inode);

I'd put inc_nlink() here instead. We are guaranteed to have a regular file
anyway and it matches what we do in ext4_fc_replay_link_internal().
Alternatively we could consistently use ext4_inc_count() &
ext4_dec_count() in these functions.

> +	err = __ext4_link(dir, inode, dentry);
> +	if (err) {
> +		drop_nlink(inode);
> +		iput(inode);
> +	} else {
> +		d_instantiate(dentry, inode);
> +	}
> +	return err;
>  }

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

