Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBCA2D4660C
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 10:47:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EF556B0096; Fri, 16 Jan 2026 05:47:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B6936B0099; Fri, 16 Jan 2026 05:47:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFA626B009B; Fri, 16 Jan 2026 05:47:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DEE886B0096
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:47:52 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 816138C0D8
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:47:52 +0000 (UTC)
X-FDA: 84337501584.02.D634141
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4945E160006
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:47:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NAigHHJe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=wAaeVaZX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Vqd1Y4ym;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7Gjt5tLm;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768560470; a=rsa-sha256;
	cv=none;
	b=lpkX+pYIKYwrdeI0rOyyUZb41xpkqZ1e6rTmZAUy/0NkNGGTbmhkg+i4tiL4WbTKk2nPa/
	mVfBQUV77CfoguMx+jgI9cFAPixDdrSRiKFwzaszhn5QOb2jriX47yiIVCv0IphOqqBtE2
	u44jfRlEpMJET3mpSS3h9Xh1PoH3EGU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NAigHHJe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=wAaeVaZX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Vqd1Y4ym;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7Gjt5tLm;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768560470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sxv0JM+Kl8CyBCRTXuvFgjvy4sy6WbuKYSBt+sEG264=;
	b=OfU2ctkx+B0PH5nwHyf6BEHwu/ek46EREEIIErG5NDUICIO0cW4ZvSyiUkjexVt89Ip5Sj
	LUmfxJFnJUI5C5CwZym8zx3jZRKyzprBf2CUoMAlmwIjL95n6Z5o3U/NF/hk73JaeZ9lDO
	f6rTiGL59f3P5DbGPxfv/NxpAWl8vlM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E9DC4336BA;
	Fri, 16 Jan 2026 10:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768560469; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Sxv0JM+Kl8CyBCRTXuvFgjvy4sy6WbuKYSBt+sEG264=;
	b=NAigHHJefgDlX6mRySbG7B5iCmL36aEduQNmXj2EvsoYBrU7/VTo8/WNZrc+jBxVmYwek3
	innlofjWnNur4gO64jxDUWQVk3pm53xXSuys1aTGTWpFtvR1Xd4ONEVhhk+B034xGJPlVB
	qicHNvV2T2n+PsShv1UvN/CV4roIDw8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768560469;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Sxv0JM+Kl8CyBCRTXuvFgjvy4sy6WbuKYSBt+sEG264=;
	b=wAaeVaZXVSmCCp/Ci8z3PCyFT3ubSWVNcMQNxpoFpxosJZqqzSMYJQTVEe91z3AbyBwRES
	hgYeQWFl3/XVwuCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768560468; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Sxv0JM+Kl8CyBCRTXuvFgjvy4sy6WbuKYSBt+sEG264=;
	b=Vqd1Y4ymZFbiTB3W7/+krX5l7W5sxL7aNuHpBkJYaPRDypTZKpWZDKux+L+iC/0RWALCc4
	Wl+guT58YT9lXH7G1B0VaMoNprxzvexhqTpUZyuh7OzKnAPdgG0Xbfk0EUDTxkORMoIq4Q
	yoxjYuhlhqs/kbTHf/h7VyrYgdeD378=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768560468;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Sxv0JM+Kl8CyBCRTXuvFgjvy4sy6WbuKYSBt+sEG264=;
	b=7Gjt5tLmv8pwoPI4+tAhdd+IkW9SPQOahLPixnGtYy+H9R2r0zQYbKm8w1G8zq15sjbdtX
	okoOuMG52JxjWaBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DAAB63EA63;
	Fri, 16 Jan 2026 10:47:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JhtdNVQXamm8DAAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 16 Jan 2026 10:47:48 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A1819A091D; Fri, 16 Jan 2026 11:47:48 +0100 (CET)
Date: Fri, 16 Jan 2026 11:47:48 +0100
From: Jan Kara <jack@suse.cz>
To: Jeff Layton <jlayton@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Chuck Lever <chuck.lever@oracle.com>, 
	NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, Amir Goldstein <amir73il@gmail.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Carlos Maiolino <cem@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, 
	Alex Markuze <amarkuze@redhat.com>, Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Luis de Bethencourt <luisbg@kernel.org>, 
	Salah Triki <salah.triki@gmail.com>, Phillip Lougher <phillip@squashfs.org.uk>, 
	Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>, 
	Andreas Gruenbacher <agruenba@redhat.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org, 
	ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-unionfs@vger.kernel.org, devel@lists.orangefs.org, 
	ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev, linux-nilfs@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-mtd@lists.infradead.org, gfs2@lists.linux.dev, 
	linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 18/29] ocfs2: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
Message-ID: <7ez6obuswq26r3fi5es44rv25motvmcc7iuv7mpj7s2cnb4i4i@di4z7eug36t7>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <20260115-exportfs-nfsd-v1-18-8e80160e3c0c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115-exportfs-nfsd-v1-18-8e80160e3c0c@kernel.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: j69p5qbkccg44mre4puqc1kunhykkmno
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4945E160006
X-HE-Tag: 1768560470-388018
X-HE-Meta: U2FsdGVkX18XeUzNOjx58WlHAnokyxc4kXRyuTq3i7c7IGQWBe6ysAWzJV5CJhnN/dccJ038l3weJMaERE+NZ0jYFi2o4rlmKk8waz91LIhGpbULzGbO1OpMGEKzA0MJ8q4XTSzROQqywQJ6zibqfL8OaATHy/P6L8LYg83kd0Or8ahe5vjzXvJa5ICJinrYfCQLC4S0SmCztgumb0iBrEZ1hZBVh+5AHtsQadv3ltewM8UjN9A64Ujzw2B2afwYHaq96gK8rS98oSsHrG1P8dBm3GbCeOWEnz6bdcU4ZRKxu3TTE9IJpAQvU35TJUrig2ERtODH8aa0SThYyyQBn3KUG98iERUFupM3m268o5+opre3pLUJjTGj8aonL5Ly5VeupOhMUu6/beRYKXAJ+BhHDRvhiYWjhEgwFHV7uv7wC750qksNllJRLV6eHuWrfFyr1oZF0CgkPddFzrw7LMGstUUuBkV7VXasXIZb+LVN6p593CZ5VA2VPYK8g83qI7+FvWARZUJZnyF3uwBdzsvp3TmIH36kArn97gPg/NPXE1txaAXUHBZVOVPzcK4lb+4rZBSEDBhuGGoQUnKSr6GseHEmSNdW0RiTCCRZx1dDFp1hLi6DPrO4k6OyWvrPOnsRuuMUgVyRcq43JzG8tuDGun9w5ZHQXkQtHymHj2MWK80xobKoAp14QQjAuucDaq6+XbA5PdGT3DkPFX2bgvvGjzKOT1VXthmv6VTcWu93te4n5UhDl+qbbjLzGBkf5uPSwmdkMmuYRnngztHGz9tweroPIhyNG5iWzf7X9FF8xb8BVj7z6x7jsxmLI20OGoxoVJ41+E6Vet5cw8wZ0KtUdEYH+53iBTTwjzfBMEETkJJQntRGF9b3vczEnldsqttd08nLcSBTSft3RPqy0ByDrNnZ8sCZuzoMgRzN1DQT9oDSez4huINw+66SKbHx7OBry+Fe+0cm7bboR0U
 0tGJgvFM
 k/dmD3BJGstGpMRV8mfujqfSj6zjRXxGo2zmGItPQtsrLtoPVo05iFX3WqbnpfvEzoFtfRbI4i5KwTar/WacvYrB8xbHaE7T32QL6PX9SNvkkGfQ3ssZk1IslKuOf4C9a3MF+eNQS+gP4YE2DadXPE5wg5Z6XJi0qinX+c8Je153PqpLocqD77yThQrJRv34SF4236YhS5162B80qjacdeF72oByL+ZJiOZhEyOEvG86dzB+nlf2Irz+lGGj3vTIDRamvjaoue2jaKIxU0XnFo1q/pZYbUiuE6WN3oFjtOsdjoe9S6wxmGnqemIiAWclRdHOCnhuZ0ncOs7qqw3ov78ulJYxaLLJf0UfaD3b3B+YJbL5S5orbBFrRAvpKuFC3Dbr0HsAyu/yJpXVq+BACYsTgSYbXBn91+0z3XppCuABoWughahniXmdknR5d8AaH8L18k5TWfMezGicIpn66KJg4Ud/jbjf/RuGw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 15-01-26 12:47:49, Jeff Layton wrote:
> Add the EXPORT_OP_STABLE_HANDLES flag to ocfs2 export operations to indicate
> that this filesystem can be exported via NFS.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ocfs2/export.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
> index b95724b767e150e991ae4b8ea5d0505c1ae95984..77d82ff994c86037c14fbf7a1d9706f1dd2b87ac 100644
> --- a/fs/ocfs2/export.c
> +++ b/fs/ocfs2/export.c
> @@ -280,4 +280,5 @@ const struct export_operations ocfs2_export_ops = {
>  	.fh_to_dentry	= ocfs2_fh_to_dentry,
>  	.fh_to_parent	= ocfs2_fh_to_parent,
>  	.get_parent	= ocfs2_get_parent,
> +	.flags		= EXPORT_OP_STABLE_HANDLES,
>  };
> 
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

