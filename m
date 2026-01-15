Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C274D46624
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 21:09:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE79E6B00DF; Thu, 15 Jan 2026 16:09:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBC146B00E1; Thu, 15 Jan 2026 16:09:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C94666B00E2; Thu, 15 Jan 2026 16:09:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B84AE6B00DF
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:09:39 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 85162C1E4E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:09:39 +0000 (UTC)
X-FDA: 84335439678.20.8B881D3
Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com [209.85.210.196])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8615B80002
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:09:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=M4z2pxYd;
	spf=pass (imf02.hostedemail.com: domain of david@fromorbit.com designates 209.85.210.196 as permitted sender) smtp.mailfrom=david@fromorbit.com;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768511377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9qNaS/mHG0CWRhBXyo18LMgHGDC++HAHg2FdEUDjFsI=;
	b=iQSrJL1pvywoL1rg/x59IJIpPT8bz7ADsz6XIIVD2iwcta8EbtjpUV8TbFCNbC55bKaHL+
	pGfGxZz1Y0xqxRGe3gQ5QdptF/IFVkY/8/s2gqVdiFJ2NOYYScLEuHv5Poxf3e4lAdq9s8
	PLaZVQZKjBLoJyldyusWcZwDubotBz4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=M4z2pxYd;
	spf=pass (imf02.hostedemail.com: domain of david@fromorbit.com designates 209.85.210.196 as permitted sender) smtp.mailfrom=david@fromorbit.com;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768511377; a=rsa-sha256;
	cv=none;
	b=aWZgldoOhupjQ4SnTkV3jNOiUapaN2O08exop4G1YW1rGYFZAfOrpB+flbp4PO5tgWzElm
	ON0p+EtbdzUmpbtpxbUI/YLHRxijBeP+grzJe2WO102uhg+FBLIuIHracVQT7o2y4++JUs
	EOxtCJBQm+SMO65stuwO5NJwD2Dh8X0=
Received: by mail-pf1-f196.google.com with SMTP id d2e1a72fcca58-81e821c3d4eso1155402b3a.3
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1768511376; x=1769116176; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9qNaS/mHG0CWRhBXyo18LMgHGDC++HAHg2FdEUDjFsI=;
        b=M4z2pxYd3/z/8O9ivd0gCgyq+Ti1kB/6X01PLcpsw4LYaWj6CwU5D7s3Wrr+dW+phv
         Ejs44c9JVYAgYDbLQwjlBBI1EgwaJJBgtrn0eTOP9OIjqoFiSYlHGtPW+AAGe2L++CI+
         8wVrTgzVHb9rYbUWDu52XaegawLIT5bTgFNOf0BXEbNKxSLkbZoctkIE4dPS7mVYLmiP
         l2blsYVO8XnEIY8w7BLNQY1f7BEFU4q09bJH/CFZ/GUta1yW3+vWBTwIl8E38xPuM4Rj
         hD9NzPdzzFvi9YK30HXH4wxV/A56bNdjXPKKmu8nA8CAXh4V+AAolskTlj34w0WDYGtr
         2gng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768511376; x=1769116176;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9qNaS/mHG0CWRhBXyo18LMgHGDC++HAHg2FdEUDjFsI=;
        b=cqpMyiNNKiRCNgWWxD3FmI5DJUeQLtx97jJSW3fuJUhAUA1rHTDDbyvy7BxfEy6b4E
         bkyNPM72NvtmJeQHL3TJ6MUEkEKOLUCg954HtpTPB6zIGgk+9XgXKHkFjjHSfvn70Bp9
         +Ib6hcSwRtC6O83CSGSjZlHzAn6vAMPbQnKedVSoQCcS1brLRnUGrcaQWFlX2RIWaSIS
         I+sPNWWdrdMSH+mesg6eLFL/KLDONLrXyvZ2uyWnj31kyJg2/cryrEvx2uQQujGyZrYO
         miG02em62vo4igbUNCflTFqBlqgfs4C2Z7dOvZaIP5Z8AJY7jWK3N33I1H2YKsncfK/w
         dcyw==
X-Forwarded-Encrypted: i=1; AJvYcCUeBev4nNEPvNVsTmnFyF8A3iH4PnnH9lZqOjacFZU8kJ1qtGKFW7Ilb43pS5gAJxR+zrFsPoEknQ==@kvack.org
X-Gm-Message-State: AOJu0YxhviaIqM8OaiLUY+dT3X3Oa3J0e45OKqfnzSfbu4WSa0DG8xwF
	gCokCHHIBtuzfPb0RWaexV6RvEglKDDUbD0h86FPAHDsxJRhCZXaTPfUbPvqljoEjU4=
X-Gm-Gg: AY/fxX6rtk6RhtTNOckh+EEEIxCNk4IrW2dRk0IC86JPgj1yqrjLcSpucab7+s/2hFF
	wzDz4HUWtIT9MTBB6OLBd0Yk6ZBPwlQ/LZDI++fv88hIu3+OX+7oiOd/z0JI3QfFUDG6jd4INHe
	kM1e+/qan1Tht5sty4m910uCst3VRlBnDe0N3LzviocyO/WVDLonF2I0lAn64IJY9H+jSTBx1hz
	/DBbCbf1c4N66MZmzCW+A67jq95+jq9tytXTkLcu/15mVE7PdY6HVgVqu/GoAVRReV9jGobiPRE
	odiRlvDUoPCyh8WPZ45fIXVuTlTSIG7bMbOwmo9cH5Yd1WX+oGjs1viOqouVo3D/iun48XcM00T
	mZJMxrNfKyFcwTudss6HnSt9DBodngI/5eHQEe7NL67Oz+Y3U0OKt242NZd1311tGmYi76ih7Y+
	F8UPJrJQyIYIsNposc/MCI1xw/nW+EgPISu4OW+z80j1MA/PRPRQHMJl3Nf5IwBvQ=
X-Received: by 2002:a05:6a00:1c99:b0:81e:5d52:53b9 with SMTP id d2e1a72fcca58-81f9f7f61bamr693898b3a.8.1768511376156;
        Thu, 15 Jan 2026 13:09:36 -0800 (PST)
Received: from dread.disaster.area (pa49-180-164-75.pa.nsw.optusnet.com.au. [49.180.164.75])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81fa10bda5csm259171b3a.19.2026.01.15.13.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 13:09:35 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.99.1)
	(envelope-from <david@fromorbit.com>)
	id 1vgUai-00000003vHn-2AU2;
	Fri, 16 Jan 2026 08:09:16 +1100
Date: Fri, 16 Jan 2026 08:09:16 +1100
From: Dave Chinner <david@fromorbit.com>
To: Chuck Lever <cel@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>, Carlos Maiolino <cem@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Luis de Bethencourt <luisbg@kernel.org>,
	Salah Triki <salah.triki@gmail.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>, Dave Kleikamp <shaggy@kernel.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-ext4@vger.kernel.org,
	linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org,
	ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-unionfs@vger.kernel.org, devel@lists.orangefs.org,
	ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev,
	linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-mtd@lists.infradead.org, gfs2@lists.linux.dev,
	linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 00/29] fs: require filesystems to explicitly opt-in to
 nfsd export support
Message-ID: <aWlXfBImnC_jhTw4@dread.disaster.area>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>
 <d486fdb8-686c-4426-9fac-49b7dbc28765@app.fastmail.com>
 <CAOQ4uxhnoTC6KBmRVx2xhvTXYg1hRkCJWrq2eoBQGHKC3sv3Hw@mail.gmail.com>
 <4d9967cc-a454-46cf-909b-b8ab2d18358d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4d9967cc-a454-46cf-909b-b8ab2d18358d@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8615B80002
X-Stat-Signature: 6e4xtcztpmx4u86bdwxczsesc34w9ccf
X-HE-Tag: 1768511377-2491
X-HE-Meta: U2FsdGVkX18iciFBc7SXY/hwownubBMqw1Iz5qM+l+ykdn9nGjtK+LofVJhdzC5n2YpBZ5lkKxS5xXjdvM9b60hYdrxpgdyAr/MYYVmmKbHU97bNUOmfiMsBu8S+DCmTQ0ETX0cP8J+7hw+zmc8PAl2pQ99trFufJ0QG1TznTLzWIkpOAeZuTs6SMlfyQRi2qnJ110exMYQb4x3u4pGpp7lSTPYOfl7pR/XF6DH0MdtP1b5GMFGpuT2QPVL8hiF3Dy02aV31a3MrOWpu/4CwC8Ii+TMl41Tr+DAjI2b20M2emr1iPwO7Xd9jcHTHruJtQkMDuo7be+WCBQO0b/OqPmTQ47fx1j04fPndeb3xvpq4lQ30hrkpSpaiINJ4pfmWB/r0qyBnnM9SNiTs5QBJQNvCGqEkvVAzBY+d836dqzBWKIzCZJ1DeaYsRVNsGDvqzN6HT0bX0Atjvr/AfHwjZVu4VS9T/M3xVJXQAYmzGMEt/2WlAFcL+jUikNkoFdmaO6NLo88ofYTN2WqsE8EPmf9+3rtqbkNaRN+3ktHwJJGZkp9ToATYS5hkf6dorQJ8CQjekvRhXHts0F9gw0/Gt4dYluUfMkouaHZzZRfsRRKK/5Zmw6JX7gMfdBt4fOzSxbS7C6Xh7/pw8yky9HAIAyxQKrUaQfsQx2HAqN3oQiIMOEipkPct+nlCPhrrZSOSeOKMFTfWY/8sJzgz7Gz4Bi5iNd7MPQsx7R/nt6mFS78JT6Ivs/jiU7aXNU717M5mUK6nuKR59xc6QmmTGb3k8ragiMhJ+ux4PXCSqu9kPAT0zRbIGxq133W0pL3s5S4GfLBsMXdl8N6dFH0lUn190RO+qp638ZVxF3VtJVUuDIxDThx6XsiBUM1lkVrwYXIBQzcoc5izMHS+JQ5/bcBWaXITreTbYtVMWbyM8Vz2Ool1+fTsd/fRJir3QOZq9xacLkXASoDTGaU7iTtbKR6
 cxWhU1V/
 5jmYkUqWd1jXoscCukOzcd7Ij9tsJD314Kku76jL0Q4Dd1Hv3vwJqFbgJu/pggwKHCLhnsMxCYxX9w0ssYwBkz+6TLbqpVk2Hg0oiDh3ts3r0W0njj3lcgAU+P6bxBSbee2HKfzaM3+M14izaH+TQyUgrxAS4FMMZQ2oJGCGdxJpkS9twd4RYKSjj+u8KRuAS0kJoCKHzuIRQjosYtxdqolFQkuX6hZNAHV1U+A7W4wE38xCVbXIk7NW6TJGOJgVrlZF8JU2pgL07G5YfBsRP/6iMwHzN81FZl4UULW7MJ4h90JV00QJwY/F+S4imraZ6lAML3K+xi9n/HKLyuNu4FHtxozhum8zmSARYKe3hanQrDOPBMBj9IGUwS5fMBRMxAyhODR2IBwMIftSCfvXuaMpoC3oQV8eWlpWAX8Sqm8OD004e7tvQvYDBc9CjvCglNHyIsi9aQgkBeNvk0a8AP0SQa9sj4A+Dm+3+pznGOERhPzMy5wrIG2kZGDMxOeqI111221TpDM/m7KHDxUoCZtxlaebBE5c6B7cFRhGLo2OH9uLtZbH0mXXe/sC/CDY1xZPDRZvSgNXV/l4tqtkII/X4oh1jqoASOa9YnlPwapdscZ4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 02:37:09PM -0500, Chuck Lever wrote:
> On 1/15/26 2:14 PM, Amir Goldstein wrote:
> > On Thu, Jan 15, 2026 at 7:32 PM Chuck Lever <cel@kernel.org> wrote:
> >>
> >>
> >>
> >> On Thu, Jan 15, 2026, at 1:17 PM, Amir Goldstein wrote:
> >>> On Thu, Jan 15, 2026 at 6:48 PM Jeff Layton <jlayton@kernel.org> wrote:
> >>>>
> >>>> In recent years, a number of filesystems that can't present stable
> >>>> filehandles have grown struct export_operations. They've mostly done
> >>>> this for local use-cases (enabling open_by_handle_at() and the like).
> >>>> Unfortunately, having export_operations is generally sufficient to make
> >>>> a filesystem be considered exportable via nfsd, but that requires that
> >>>> the server present stable filehandles.
> >>>
> >>> Where does the term "stable file handles" come from? and what does it mean?
> >>> Why not "persistent handles", which is described in NFS and SMB specs?
> >>>
> >>> Not to mention that EXPORT_OP_PERSISTENT_HANDLES was Acked
> >>> by both Christoph and Christian:
> >>>
> >>> https://lore.kernel.org/linux-fsdevel/20260115-rundgang-leihgabe-12018e93c00c@brauner/
> >>>
> >>> Am I missing anything?
> >>
> >> PERSISTENT generally implies that the file handle is saved on
> >> persistent storage. This is not true of tmpfs.
> > 
> > That's one way of interpreting "persistent".
> > Another way is "continuing to exist or occur over a prolonged period."
> > which works well for tmpfs that is mounted for a long time.
> 
> I think we can be a lot more precise about the guarantee: The file
> handle does not change for the life of the inode it represents. It

<pedantic mode engaged>

File handles most definitely change over the life of a /physical/
inode. Unlinking a file does not require ending the life of the
physical object that provides the persistent data store for the
file.

e.g. XFS dynamically allocates physical inodes might in a life cycle
that looks somewhat life this:

	allocate physical inode
	insert record into allocated inode index
	mark inode as free

	while (don't need to free physical inode) {
		...
		allocate inode for a new file
		update persistent inode metadata to generate new filehandle
		mark inode in use
		...
		unlink file
		mark inode free
	}

	remove inode from allocated inode index
	free physical inode

i.e. a free inode is still an -allocated, indexed inode- in the
filesystem, and until we physically remove it from the filesystem
the inode life cycle has not ended.

IOWs, the physical (persistent) inode lifetime can span the lifetime
of -many- files. However, the filesystem guarantees that the handle
generated for that inode is different for each file it represents
over the whole inode life time.

Hence I think that file handle stability/persistence needs to be
defined in terms of -file lifetimes-, not the lifetimes of the
filesystem objects implement the file's persistent data store.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

