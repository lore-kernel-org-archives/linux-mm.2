Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52A9BFD8FD9
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 17:00:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE31C6B0176; Thu, 26 Feb 2026 12:00:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA3BD6B0177; Thu, 26 Feb 2026 12:00:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 972F86B0178; Thu, 26 Feb 2026 12:00:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7AEC76B0176
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:00:47 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3C7388B02C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:00:47 +0000 (UTC)
X-FDA: 84487222134.04.83CADF4
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id B82FD1C000B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:00:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XJGRYCvU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HFKLpE5P;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=P0cj5v4E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qDd8WHtq;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772125245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2UqxE3+lcinVC8tUtPMhxZS4tV0HDyUFUfF7VsRmpXg=;
	b=3AIf87KeL0UN9fQOIkEK3C0p1zQebAnVqa4TdXKfYImqqUsPDiY3+NL3RKLdb9ElijZ/O+
	7Sn7h20WLNVkqq81azXZ3xM+nZzeT7ZN0eEBrdNQ4kVJCxtNiOS5H5qSUCee1ltyFhO/Jp
	Np1RWV+vb+DyI+RS7+ZkM60YEPT8Ov4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XJGRYCvU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HFKLpE5P;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=P0cj5v4E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qDd8WHtq;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772125245; a=rsa-sha256;
	cv=none;
	b=l1jKMWl8IDfuoDcG9mVo/GgFWMsAM8S88HfLNk8KKldfC2nDmLMZe+6W4kzTfF18zIwFGT
	GBOEbU4NQr3nHqfvdNBqnPft3vSicxKspOZDrqC/0foNgDDrmHWYNFuVABL++rWLHnS1f+
	XLFi4JTFWJwOD2t3sYkQzuBcxRIKero=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BD9CC1FB1A;
	Thu, 26 Feb 2026 17:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772125243; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2UqxE3+lcinVC8tUtPMhxZS4tV0HDyUFUfF7VsRmpXg=;
	b=XJGRYCvUQEtIavuwyI0SAwKPiy3GZ/OGVFA/HK00Zt+6pITIKUpnRL9qJli9zFinAkD1W7
	Vxgy8eY26i46GzNiwxgtrpkXkYptZJCqiB05xpDR2FfG7+w4FXN6zZ2zwKUXqTSCs2t/PT
	iRkQO9+ZXTTMOyySveoDk4AAkQYE2SE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772125243;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2UqxE3+lcinVC8tUtPMhxZS4tV0HDyUFUfF7VsRmpXg=;
	b=HFKLpE5PEy48uwFKGnDhcBt+zN1U7QXn1+eST5YuNecl5/9geGKgIwMhoURm5MEd+cRRnD
	Ek1LpwK7K+IiblBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772125240; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2UqxE3+lcinVC8tUtPMhxZS4tV0HDyUFUfF7VsRmpXg=;
	b=P0cj5v4E6hRE7j8RzUgxGJPn1i5piS2UxiIx1ItwZ56RFolWcP2L5iYRpfabk3xpxJajdy
	2cskCjRdF1qAxrAvUUWm9uDlwOb5uzOicFHIkGNUOGU2xvBSrsDYnKZwwsWhpkbVWNZGW4
	nC9jI1iVB3z8PRq+9A6F/BRSx4k26yM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772125240;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2UqxE3+lcinVC8tUtPMhxZS4tV0HDyUFUfF7VsRmpXg=;
	b=qDd8WHtqgMZ3g7j76If0cqNMPcnUnXUjZYYYy50JHWmm2+96xHsEXdjzAcqO2Nfud1EwU2
	UYQIvBB456QifSAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A90923EA62;
	Thu, 26 Feb 2026 17:00:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Cg06KTh8oGmpPAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Feb 2026 17:00:40 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 545EAA0A27; Thu, 26 Feb 2026 18:00:36 +0100 (CET)
Date: Thu, 26 Feb 2026 18:00:36 +0100
From: Jan Kara <jack@suse.cz>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, 
	Eric Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, David Howells <dhowells@redhat.com>, 
	Paulo Alcantara <pc@manguebit.org>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Jan Kara <jack@suse.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Steve French <sfrench@samba.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	Alexander Aring <alex.aring@gmail.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Eric Van Hensbergen <ericvh@kernel.org>, 
	Latchesar Ionkov <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>, 
	Christian Schoenebeck <linux_oss@crudebyte.com>, David Sterba <dsterba@suse.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>, 
	Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, Ilya Dryomov <idryomov@gmail.com>, 
	Alex Markuze <amarkuze@redhat.com>, Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, 
	Nicolas Pitre <nico@fluxnic.net>, Tyler Hicks <code@tyhicks.com>, 
	Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@infradead.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Yangtao Li <frank.li@vivo.com>, 
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, David Woodhouse <dwmw2@infradead.org>, 
	Richard Weinberger <richard@nod.at>, Dave Kleikamp <shaggy@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Anders Larsen <al@alarsen.net>, Zhihao Cheng <chengzhihao1@huawei.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, John Johansen <john.johansen@canonical.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
	Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Casey Schaufler <casey@schaufler-ca.com>, Alex Deucher <alexander.deucher@amd.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Sumit Semwal <sumit.semwal@linaro.org>, 
	Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Simon Horman <horms@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Martin Schiller <ms@dev.tdt.de>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	fsverity@lists.linux.dev, linux-mm@kvack.org, netfs@lists.linux.dev, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-nilfs@vger.kernel.org, v9fs@lists.linux.dev, linux-afs@lists.infradead.org, 
	autofs@vger.kernel.org, ceph-devel@vger.kernel.org, codalist@coda.cs.cmu.edu, 
	ecryptfs@vger.kernel.org, linux-mtd@lists.infradead.org, 
	jfs-discussion@lists.sourceforge.net, ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
	devel@lists.orangefs.org, linux-unionfs@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, selinux@vger.kernel.org, 
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
	linaro-mm-sig@lists.linaro.org, netdev@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-xfs@vger.kernel.org, linux-hams@vger.kernel.org, 
	linux-x25@vger.kernel.org
Subject: Re: [PATCH 01/61] vfs: widen inode hash/lookup functions to u64
Message-ID: <cmxf6pu3xuwvbhg3alu725hd4b3dheowoumd6drolde7pypwor@eplss6764uuf>
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
 <20260226-iino-u64-v1-1-ccceff366db9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226-iino-u64-v1-1-ccceff366db9@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: B82FD1C000B
X-Rspamd-Server: rspam05
X-Stat-Signature: zbopkydz5m61q9xhc3861g5k1t54zffc
X-HE-Tag: 1772125244-686737
X-HE-Meta: U2FsdGVkX19BVhE/w1X3qM1Q9yAZcM7p/BxzebsFM+IreZdYWmK5pQrZGtzJBFi2kyEhskxb33ynyyxbDcjoLFBB3MqxQ0+3fu79nsHIIrXzA01oO5fBUqwePdACvkOthuTPIlzAH6SIf8OJGgpvqUAp1U6NWDc3N0coKhQQ+XyRxOc1usS4/nIkYRxo8Ioxs7klRONoPUr+AcoYcJhs6Ej4+N+c7zmY6jKtAcfH+piF5XCMjFXKuFvl3xk31E55PkY8Ox/sWvdr3QyEcb1MMNP84yy2S2Nad12WB6E/ZJhYNvwWv6QJJJZ3kCgAxYoMIlSVujn51+8rGB7dxJytlcxskgUtRQO3yGoTX53YXb6+WQYPnVIvaslG+eKv8XdNeXHL9NLiZdtjNMnlN7gz1lQISaoKEmihcNJWfNOzKgkRLXMPWnTBuqs+JpnIj37aHEygU8CnbgDZq+tc0yOnNAVm6l7us8UeGCIhnIkz4xKg+qUFLD7envz2avJaAaJOK8vhZc2nz1CjC957zeJsFovZcTy2lzS0h/2JZno2dJSp4t3cWCLcWNw0PwTFJY51ZPraelaU3pWlNFGj79UGV4bNsgUOk/2YG7uYfjmsjz885B4T85VtLn4xH2GQWVHJO20XFAySVNDNYBzJHapbXp2RIlkYB5XWfSJWIFReLeh+wRiLldZoqSme8UfnGt3UqcB/PsL7tnK14Q7deyJUByOCWlswhLUBekv7Pf/D/LiIlCI1adm7T+VrWY4rvu20EaPXZs2gvI/00sS9FPms8M6Etul84fHE/0g79aq5amAnH/32cK7C5TX5qOeXJt1Zvk3aRDnKvkbs83SxF6kR2tvAY8sFO9dkNmyPIiFC78LfkgetEEysAZBWtXAAv9ktLnKa1RH7ZL6RrgRyFflQmZ5dEOmVJPNe8OLjR4bh2OPmPW+5F6ZE3UF3Cvt7GsRSNjSp7BDx4k6Alw6e+O+
 N80ArbdF
 U4tFUpIeQ+SzTcsOAtfI4ioPZajmbo8wUtTyCfr4ulxNGFSwLvlq5UNNnITeqqDgTh+J3UBAxY9/r6R+HctFxnmbK25DS672fc15kUxaLJWmPQIZghyMFIZrzBtgvvgRsX5X6ZctIekL5iMNSdOsE6a/3K4diyCDCAMlQuWItHNktDbRw0ku9RmyQ0fgeRxqwnwVXWPNs7MPXsEisTee+fQbgyDA6C71dOmuFEdM2SpmJZIFjwifena9jhHf9S0JxtHjPmJEr7ITmK0lMVS3pT72BX8mK2UDiukyGGa8tqJdkIc33GiSRlXxxelex2DGatEsRGjlTOzvM8JlIAhEJWVJvb8rvk0zCoY343aYj7tC7L3DlqMFIY7EQPR7lJFlZKLXK4knwkwGlrDKJhYZh6qbn/eDN23cq65IarFhbaLm8QO/CwXR253RoHDzE4t5nELi5OhB8EbvexqDDNF4fQZE8sCXqQLBLqhc0tkqykWXesdUxv2BHAZgQ4rA03bHg1ZyecJeQCp2EiH0iLWavGyDHzhSuWe5kaEwRxW65snNvlB36QFEpj8UniFIdmT7MwieBjEkRj4sJ5MTo6OWprpAikGcj3kekUPbsgn2AB9x+NQtiPXLbTBHk5tnMtNjWOHQR9kSQG9dOLiYNkSgVVT0k/fAZL1nsbGRlKq+dChlmyjy8GdpvwdGwnpuOLaCXpepzr/sSNEuAZAF/1h/gbKBNPgjpvn6cQjmx3WV0sVMlc7vhan0qKloQ8BG2cZo3KB08pxapKWMnMbdGzDoFY7FsWERXjUa26lEIhFkFwSjd4WIdpcNzWUpBAINUFNrsYNJsoaJFbLVNZ8jTWns+dA+T1twRk7VKU9L+2z/ojZBddpItwFpVI6vwXrzblzui7lF5KFhSVyz0Rmo64WLNqyzK7o8VTbMgzcIP16Hi1589fgoJhlajdDbImF9X7YaA/fdPoWT+675Bb77By+pzzXcYVU1B
 SYW7bxQ0
 cNimD+bK8K7p5SZd3arQCIHi7SA+ENj25lneNwUpjtsSWWvFEyKkKtN5neH6Z/7v4vIROo3Rp9Qvq6gzbDvY5P3PHhA9GzqZnenhHNJcfx+HPjY5JGzZqNTSiS16DJDye9HSavu1n1k2OG8xFhnt26tWWO0od2mPppagzP+4U+8J65m2KADMC/jRcMtW58Te0Hl6gC2SaLFeSoYUg9/nrqcIgMnyXX8Z3+6eXB5TjIJVouqj0NmH77xB8RVDYCj2EXwtLjGVJF0iNq6ngWlal1yn/1P1vntyzEiP3vvjkdUGf/sEekZcG6QQK1wsxkWtLV0HyN1ohXXuG+Su6xH9JpNNhd65QnYyzHBkEZWkGjmT1dCvZE1tnWoLX+jqXfp8un1W7ALpu9BoMFF2599Jn/D6oLfoeHhw/V5VuNVzhDoL5pJRlnMeo6NgHq4VuuKYwuYcDRuU+3rRnotDIis6PHOej9wD//CtlaUtN2uIu46Pe8Pe2SI00ieyvgEjFzxCuUxuUXHt32S6dMDCgvY9CCHESrW+3YrDerUROG+n9N1B8hq4kQToAaIO5WspjQtDrZwHr8u2u2qc4mUOn2bHir4rwCiiWdbmk8qQJx337/XfszQCR3b+AFor8yG3E1WfAPXw9qFLqFgU1Yh6EM5qWPvM9lpo08Mv4AOd/yPD46hnTwWGhkYwh5lJYm9Tb+rmcUcHR3D/z08mJJQZ1Yvybr8JQeGZegaEmRQla+hP3y9TRKBrFLSCEt+XM+dmrmv8AjMhjInuOOvIK3XwMzehw4EKsqLVQg0fwQ6zeDN1mYxPQgOSCH2mG3pmnll2XZJlWV/LQgeItnmeGmG3AGvDa7yItHOl2kkIRxTf4lagbHdZC0dk0TxMFO3rLyXF08k/X0h0v6JQQOP1ou5xyOMdMqEvqCDoY7KQlAj2pxTKNYqY5sPl98W7F1plXdf+Fs48lF537FHJ7S/jffVkPjBfMFt2S8JI8
 S5YvQNZw
 2rRfOw3EnVG3p7STBBJuVI0vWugv4LAKQgTx3bcgRQkvKXUw7a2912DfePKJ/5k1v5EoKRDaJQNJWFMjeWISfJ3RKE2ppq9QniQH+Zlvb6gGTBZiSscvghZbji14owUbeVL+MprWCP+38MZRgc1RBrdnUc9TmvyYP9EachD8UXUm3Afimwpx1hdnv2jEQOQFWdAhp7wD3Z5AonNThGg0GHH6fZJe7LHiy6RImVxGrsKUw7Dnes+tZePmWKgDxissRMuaakvDIKAByx3tsiUpveHh04MlazCrHBuwfN/Z1zsRJoSngmQPCoaxb+BmMAlPpiNzjh9nBcC0mw57aSkmbU2sxkwH7r56ypZE6Txc+ydo+GFhq1qIW28pWBhMxXMYUI4SahWGeQP37yE2iUOzBSvFQpNPUvImgG8ejcHv0iuAt3CeUQO2LZIQ542tOaL65o9sHraUQV0lc9Kl3YTHvEilo1Zmu1O8VA5vAQR6Myk8LeKPJ04JCTKtw7BWXc7uqlL+FuGTri9Xq6w3jKpedJnGHJBFTSjavlcxWjMqplHliMcItug4kGFRzy/MWwwUV1Y2S2qP7agl+CrCDKLcOfyf9FolyNeTeDv7up2AkhRchxg+mvNb7t4B2jjHmTzHzeUiYsqJVHU8/VZshwXZ91jHSZyCdWp0AfSKGCcGfXhyXAbY5HpwUInjgX7a+Of98Q2yW5nuTEBpOgy1GntW9GBZCD9bcV1UsH/fP/Vk7XC6l4ieq5jOR/5uM3y34jzxMnBbc9V5slGXKNHgMv+RiZ5YM2RL9YpcsMV71KKK7Kmumimso5qvu+8G8q4lAgvnX/UAA8IZf6egohAGlfPSXEaL99lJThydgC0GsD1PfkdOYxmJTeZ0na5DCA98fcwjlwzexd6HxsQKALBX98Ijj6cKk7vjBP1/qg2Z/QYAn9i979UFnw3Vwn7AnKr2XuRi4c1KMUAgpykxsEjnrqoMkTNRd8bM0
 aMxebBnZ
 NdR/IYsV0QWLJurPv/GbI7ECO2OxkSFITpo5m1xAJobVlGATGAaywIL6r39qnWdbakVTfGFV0pAFiFfVWH5GovpNwkBlysAJUFKTRE6Koxn/7VlOImPlK8CeuXZM5AKionNy5XSWr57QuNcylFO/aE+UsO3JH3YWNlzCZc3AMqYPZ5G+e/s0RPLULFuk8XnPaujGOTuM5k/lYbtvhqrvdKRA3hCfzfPQyA1548b3f9kP4ND2a6qOtJsRFMlx5N0bRWK0x4eqUdEOk3yCMP4tEHr/yRb49mgWaSR9qVRQjz400fuA/7k3BVQLKTVYlaH4iS8Li7imJjo8p7nRCfP8t8ZFzDdRK8ok0a/n5GGKue+V72U/7QDt5l1SusHTtFrvs/2FdSOH8n1uEU6G5IKmExY5FniwyxNf7JlEMORreXQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 26-02-26 10:55:03, Jeff Layton wrote:
> Change the inode hash/lookup VFS API functions to accept u64 parameters
> instead of unsigned long for inode numbers and hash values. This is
> preparation for widening i_ino itself to u64, which will allow
> filesystems to store full 64-bit inode numbers on 32-bit architectures.
> 
> Since unsigned long implicitly widens to u64 on all architectures, this
> change is backward-compatible with all existing callers.
> 
> Functions updated:
>   - hash(), find_inode_fast(), find_inode_by_ino_rcu(), test_inode_iunique()
>   - __insert_inode_hash(), iget_locked(), iget5_locked(), iget5_locked_rcu()
>   - ilookup(), ilookup5(), ilookup5_nowait()
>   - find_inode_nowait(), find_inode_rcu()
>   - inode_insert5(), insert_inode_locked4()
>   - insert_inode_locked() (local variable)
>   - dump_mapping() (local variable and format string)
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/inode.c         | 46 +++++++++++++++++++++++-----------------------
>  include/linux/fs.h | 26 +++++++++++++-------------
>  2 files changed, 36 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index cc12b68e021b2c97cc88a46ddc736334ecb8edfa..2cabec9043e8176d20aecc5ce7e0f276c114f122 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -672,7 +672,7 @@ static inline void inode_sb_list_del(struct inode *inode)
>  	}
>  }
>  
> -static unsigned long hash(struct super_block *sb, unsigned long hashval)
> +static unsigned long hash(struct super_block *sb, u64 hashval)
>  {
>  	unsigned long tmp;
>  
> @@ -685,12 +685,12 @@ static unsigned long hash(struct super_block *sb, unsigned long hashval)
>  /**
>   *	__insert_inode_hash - hash an inode
>   *	@inode: unhashed inode
> - *	@hashval: unsigned long value used to locate this object in the
> + *	@hashval: u64 value used to locate this object in the
>   *		inode_hashtable.
>   *
>   *	Add an inode to the inode hash for this superblock.
>   */
> -void __insert_inode_hash(struct inode *inode, unsigned long hashval)
> +void __insert_inode_hash(struct inode *inode, u64 hashval)
>  {
>  	struct hlist_head *b = inode_hashtable + hash(inode->i_sb, hashval);
>  
> @@ -726,7 +726,7 @@ void dump_mapping(const struct address_space *mapping)
>  	struct dentry *dentry_ptr;
>  	struct dentry dentry;
>  	char fname[64] = {};
> -	unsigned long ino;
> +	u64 ino;
>  
>  	/*
>  	 * If mapping is an invalid pointer, we don't want to crash
> @@ -750,14 +750,14 @@ void dump_mapping(const struct address_space *mapping)
>  	}
>  
>  	if (!dentry_first) {
> -		pr_warn("aops:%ps ino:%lx\n", a_ops, ino);
> +		pr_warn("aops:%ps ino:%llx\n", a_ops, ino);
>  		return;
>  	}
>  
>  	dentry_ptr = container_of(dentry_first, struct dentry, d_u.d_alias);
>  	if (get_kernel_nofault(dentry, dentry_ptr) ||
>  	    !dentry.d_parent || !dentry.d_name.name) {
> -		pr_warn("aops:%ps ino:%lx invalid dentry:%px\n",
> +		pr_warn("aops:%ps ino:%llx invalid dentry:%px\n",
>  				a_ops, ino, dentry_ptr);
>  		return;
>  	}
> @@ -768,7 +768,7 @@ void dump_mapping(const struct address_space *mapping)
>  	 * Even if strncpy_from_kernel_nofault() succeeded,
>  	 * the fname could be unreliable
>  	 */
> -	pr_warn("aops:%ps ino:%lx dentry name(?):\"%s\"\n",
> +	pr_warn("aops:%ps ino:%llx dentry name(?):\"%s\"\n",
>  		a_ops, ino, fname);
>  }
>  
> @@ -1087,7 +1087,7 @@ static struct inode *find_inode(struct super_block *sb,
>   * iget_locked for details.
>   */
>  static struct inode *find_inode_fast(struct super_block *sb,
> -				struct hlist_head *head, unsigned long ino,
> +				struct hlist_head *head, u64 ino,
>  				bool hash_locked, bool *isnew)
>  {
>  	struct inode *inode = NULL;
> @@ -1301,7 +1301,7 @@ EXPORT_SYMBOL(unlock_two_nondirectories);
>   * Note that both @test and @set are called with the inode_hash_lock held, so
>   * they can't sleep.
>   */
> -struct inode *inode_insert5(struct inode *inode, unsigned long hashval,
> +struct inode *inode_insert5(struct inode *inode, u64 hashval,
>  			    int (*test)(struct inode *, void *),
>  			    int (*set)(struct inode *, void *), void *data)
>  {
> @@ -1378,7 +1378,7 @@ EXPORT_SYMBOL(inode_insert5);
>   * Note that both @test and @set are called with the inode_hash_lock held, so
>   * they can't sleep.
>   */
> -struct inode *iget5_locked(struct super_block *sb, unsigned long hashval,
> +struct inode *iget5_locked(struct super_block *sb, u64 hashval,
>  		int (*test)(struct inode *, void *),
>  		int (*set)(struct inode *, void *), void *data)
>  {
> @@ -1408,7 +1408,7 @@ EXPORT_SYMBOL(iget5_locked);
>   * This is equivalent to iget5_locked, except the @test callback must
>   * tolerate the inode not being stable, including being mid-teardown.
>   */
> -struct inode *iget5_locked_rcu(struct super_block *sb, unsigned long hashval,
> +struct inode *iget5_locked_rcu(struct super_block *sb, u64 hashval,
>  		int (*test)(struct inode *, void *),
>  		int (*set)(struct inode *, void *), void *data)
>  {
> @@ -1455,7 +1455,7 @@ EXPORT_SYMBOL_GPL(iget5_locked_rcu);
>   * hashed, and with the I_NEW flag set.  The file system gets to fill it in
>   * before unlocking it via unlock_new_inode().
>   */
> -struct inode *iget_locked(struct super_block *sb, unsigned long ino)
> +struct inode *iget_locked(struct super_block *sb, u64 ino)
>  {
>  	struct hlist_head *head = inode_hashtable + hash(sb, ino);
>  	struct inode *inode;
> @@ -1527,7 +1527,7 @@ EXPORT_SYMBOL(iget_locked);
>   *
>   * Returns 1 if the inode number is unique, 0 if it is not.
>   */
> -static int test_inode_iunique(struct super_block *sb, unsigned long ino)
> +static int test_inode_iunique(struct super_block *sb, u64 ino)
>  {
>  	struct hlist_head *b = inode_hashtable + hash(sb, ino);
>  	struct inode *inode;
> @@ -1616,7 +1616,7 @@ EXPORT_SYMBOL(igrab);
>   *
>   * Note2: @test is called with the inode_hash_lock held, so can't sleep.
>   */
> -struct inode *ilookup5_nowait(struct super_block *sb, unsigned long hashval,
> +struct inode *ilookup5_nowait(struct super_block *sb, u64 hashval,
>  		int (*test)(struct inode *, void *), void *data, bool *isnew)
>  {
>  	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
> @@ -1647,7 +1647,7 @@ EXPORT_SYMBOL(ilookup5_nowait);
>   *
>   * Note: @test is called with the inode_hash_lock held, so can't sleep.
>   */
> -struct inode *ilookup5(struct super_block *sb, unsigned long hashval,
> +struct inode *ilookup5(struct super_block *sb, u64 hashval,
>  		int (*test)(struct inode *, void *), void *data)
>  {
>  	struct inode *inode;
> @@ -1677,7 +1677,7 @@ EXPORT_SYMBOL(ilookup5);
>   * Search for the inode @ino in the inode cache, and if the inode is in the
>   * cache, the inode is returned with an incremented reference count.
>   */
> -struct inode *ilookup(struct super_block *sb, unsigned long ino)
> +struct inode *ilookup(struct super_block *sb, u64 ino)
>  {
>  	struct hlist_head *head = inode_hashtable + hash(sb, ino);
>  	struct inode *inode;
> @@ -1726,8 +1726,8 @@ EXPORT_SYMBOL(ilookup);
>   * very carefully implemented.
>   */
>  struct inode *find_inode_nowait(struct super_block *sb,
> -				unsigned long hashval,
> -				int (*match)(struct inode *, unsigned long,
> +				u64 hashval,
> +				int (*match)(struct inode *, u64,
>  					     void *),
>  				void *data)
>  {
> @@ -1773,7 +1773,7 @@ EXPORT_SYMBOL(find_inode_nowait);
>   *
>   * The caller must hold the RCU read lock.
>   */
> -struct inode *find_inode_rcu(struct super_block *sb, unsigned long hashval,
> +struct inode *find_inode_rcu(struct super_block *sb, u64 hashval,
>  			     int (*test)(struct inode *, void *), void *data)
>  {
>  	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
> @@ -1812,7 +1812,7 @@ EXPORT_SYMBOL(find_inode_rcu);
>   * The caller must hold the RCU read lock.
>   */
>  struct inode *find_inode_by_ino_rcu(struct super_block *sb,
> -				    unsigned long ino)
> +				    u64 ino)
>  {
>  	struct hlist_head *head = inode_hashtable + hash(sb, ino);
>  	struct inode *inode;
> @@ -1833,7 +1833,7 @@ EXPORT_SYMBOL(find_inode_by_ino_rcu);
>  int insert_inode_locked(struct inode *inode)
>  {
>  	struct super_block *sb = inode->i_sb;
> -	ino_t ino = inode->i_ino;
> +	u64 ino = inode->i_ino;
>  	struct hlist_head *head = inode_hashtable + hash(sb, ino);
>  	bool isnew;
>  
> @@ -1884,7 +1884,7 @@ int insert_inode_locked(struct inode *inode)
>  }
>  EXPORT_SYMBOL(insert_inode_locked);
>  
> -int insert_inode_locked4(struct inode *inode, unsigned long hashval,
> +int insert_inode_locked4(struct inode *inode, u64 hashval,
>  		int (*test)(struct inode *, void *), void *data)
>  {
>  	struct inode *old;
> @@ -2642,7 +2642,7 @@ void init_special_inode(struct inode *inode, umode_t mode, dev_t rdev)
>  		break;
>  	default:
>  		printk(KERN_DEBUG "init_special_inode: bogus i_mode (%o) for"
> -				  " inode %s:%lu\n", mode, inode->i_sb->s_id,
> +				  " inode %s:%llu\n", mode, inode->i_sb->s_id,
>  				  inode->i_ino);
>  		break;
>  	}
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 8b3dd145b25ec12b00ac1df17a952d9116b88047..dfa1f475b1c480c503ab6f00e891aa9b051607fa 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2935,32 +2935,32 @@ static inline int inode_generic_drop(struct inode *inode)
>  extern void d_mark_dontcache(struct inode *inode);
>  
>  extern struct inode *ilookup5_nowait(struct super_block *sb,
> -		unsigned long hashval, int (*test)(struct inode *, void *),
> +		u64 hashval, int (*test)(struct inode *, void *),
>  		void *data, bool *isnew);
> -extern struct inode *ilookup5(struct super_block *sb, unsigned long hashval,
> +extern struct inode *ilookup5(struct super_block *sb, u64 hashval,
>  		int (*test)(struct inode *, void *), void *data);
> -extern struct inode *ilookup(struct super_block *sb, unsigned long ino);
> +extern struct inode *ilookup(struct super_block *sb, u64 ino);
>  
> -extern struct inode *inode_insert5(struct inode *inode, unsigned long hashval,
> +extern struct inode *inode_insert5(struct inode *inode, u64 hashval,
>  		int (*test)(struct inode *, void *),
>  		int (*set)(struct inode *, void *),
>  		void *data);
> -struct inode *iget5_locked(struct super_block *, unsigned long,
> +struct inode *iget5_locked(struct super_block *, u64,
>  			   int (*test)(struct inode *, void *),
>  			   int (*set)(struct inode *, void *), void *);
> -struct inode *iget5_locked_rcu(struct super_block *, unsigned long,
> +struct inode *iget5_locked_rcu(struct super_block *, u64,
>  			       int (*test)(struct inode *, void *),
>  			       int (*set)(struct inode *, void *), void *);
> -extern struct inode * iget_locked(struct super_block *, unsigned long);
> +extern struct inode *iget_locked(struct super_block *, u64);
>  extern struct inode *find_inode_nowait(struct super_block *,
> -				       unsigned long,
> +				       u64,
>  				       int (*match)(struct inode *,
> -						    unsigned long, void *),
> +						    u64, void *),
>  				       void *data);
> -extern struct inode *find_inode_rcu(struct super_block *, unsigned long,
> +extern struct inode *find_inode_rcu(struct super_block *, u64,
>  				    int (*)(struct inode *, void *), void *);
> -extern struct inode *find_inode_by_ino_rcu(struct super_block *, unsigned long);
> -extern int insert_inode_locked4(struct inode *, unsigned long, int (*test)(struct inode *, void *), void *);
> +extern struct inode *find_inode_by_ino_rcu(struct super_block *, u64);
> +extern int insert_inode_locked4(struct inode *, u64, int (*test)(struct inode *, void *), void *);
>  extern int insert_inode_locked(struct inode *);
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>  extern void lockdep_annotate_inode_mutex_key(struct inode *inode);
> @@ -3015,7 +3015,7 @@ int setattr_should_drop_sgid(struct mnt_idmap *idmap,
>   */
>  #define alloc_inode_sb(_sb, _cache, _gfp) kmem_cache_alloc_lru(_cache, &_sb->s_inode_lru, _gfp)
>  
> -extern void __insert_inode_hash(struct inode *, unsigned long hashval);
> +extern void __insert_inode_hash(struct inode *, u64 hashval);
>  static inline void insert_inode_hash(struct inode *inode)
>  {
>  	__insert_inode_hash(inode, inode->i_ino);
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

