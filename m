Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A709D262B7
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 04:10:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CA376B0005; Tue, 20 Jan 2026 23:10:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 577CA6B0088; Tue, 20 Jan 2026 23:10:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42EC66B0089; Tue, 20 Jan 2026 23:10:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 330556B0005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 23:10:53 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D863B8C473
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 04:10:52 +0000 (UTC)
X-FDA: 84354645144.14.3B3C7BB
Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	by imf13.hostedemail.com (Postfix) with ESMTP id BF76820008
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 04:10:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm2 header.b=k3Rxmu5u;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="g AJ0npO";
	dmarc=pass (policy=none) header.from=ownmail.net;
	spf=pass (imf13.hostedemail.com: domain of neilb@ownmail.net designates 103.168.172.138 as permitted sender) smtp.mailfrom=neilb@ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768968650;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VHtydnr8fLS7IJeEIN+Bebc9EhZyuKs8Mrygf/E6Mwk=;
	b=fgLRUdyZ6hFaidCZLAFz5Nel5hPmfVuXkUkRfz2SrpRtockHNeVijvWeEVqtaalPGkcozV
	c89j/IWM7G8uMgV62C00Pk0H0crUutEv+AjJO7bQ+segmh48TRG3BEgeem2B8Kbr11UmxY
	c+2OYki8hRXtJ5LIqrdarPapVRqXztI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768968650; a=rsa-sha256;
	cv=none;
	b=JaPYDfYHrsC6QFgIwa0JZFNe7+Uq+5l4ViF0oBm4s3kGO2eU7hbCA1lXsvX9sdUizKbOWA
	0RrkXssZFtrPjyMt/bD38AC2bgTCnGsqYWqovUArHJQCh4CJqcSrtzRcRmGeOz+Duv89le
	xDCCfvXwIPb5Wgy8nDUY8qeB4vN66/w=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm2 header.b=k3Rxmu5u;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="g AJ0npO";
	dmarc=pass (policy=none) header.from=ownmail.net;
	spf=pass (imf13.hostedemail.com: domain of neilb@ownmail.net designates 103.168.172.138 as permitted sender) smtp.mailfrom=neilb@ownmail.net
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.phl.internal (Postfix) with ESMTP id CDA9513807C6;
	Tue, 20 Jan 2026 23:10:49 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Tue, 20 Jan 2026 23:10:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm2; t=
	1768968649; x=1768975849; bh=VHtydnr8fLS7IJeEIN+Bebc9EhZyuKs8Mry
	gf/E6Mwk=; b=k3Rxmu5uR9LzcxYLB3t0g9OZO0rJkXHWHzZwWU2baOA0T+BauMb
	JVwdNn8FXLcfJjWpT/PesgXD8rWNCNVfalot0ujFj+m9iIfbTfXgug2Q3yJqrVyB
	8eJIYj37xg9eo1bP9zpmammhxmuGoBzvKOGPf5Qihx0i4Xtur2zoOlGt4VqfI2Aq
	VcQiUYFS9VLDwzq7PFAV47UiRi8Z6ewfEdkzCtfuUcbBtYGQ4REwO/NQfx0wGxZa
	zaqsbkKg/7unaAaTepYNC7FeekN9e3dyldZZ6WnZ81ri0JmX1JvDTDOyA9r/um3Q
	0UTk91MwX8RKLgf76R+Fpg0kqrT6VIZzfKQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1768968649; x=
	1768975849; bh=VHtydnr8fLS7IJeEIN+Bebc9EhZyuKs8Mrygf/E6Mwk=; b=g
	AJ0npOh094R5rlQ+lB6V86VTqskShc/USfs9jmX1TOsWUZfsPdWnx0W03o0QsD0J
	ole/Eq8d6vjOz/TwgxXAi4GUViQNE7aP9SFrw1QS88PkqsRNgUMpp2Dsk75jigEL
	Tq3UezOIFJ8hQFHcKj89Ey79saQSKP0MwkW63MgMtbV/mnNXN/xKVwew/W1KuJOB
	UtSIMWwNUT/KJ08KW4iRnFlHq35eiupz+giAs+7ptzAfWnDBN/iL/8qtRpNmSEaA
	7+qwUSVwzkTj44zrlBWH3L4VcAF8ddte590kdslQTISEXKuf5ZNRlxQrYy4fTjd4
	+bXU8lH/3WUCP5TODW9mQ==
X-ME-Sender: <xms:x1FwaXcQqjPpSgnEH0JKgQq9qBmBgEL4xriEE0RJAFk0DGbOHo3GJQ>
    <xme:x1FwaRGn5TWEli8N0_6q7i-Js7HZaHfbVLccEQrr6Mlj8opNJxVvGV2IOF4DACpZJ
    67k8djIbKVq6CJIz8sMWvyebtGqxQwHb9fq0iYg9h6RLbhG>
X-ME-Received: <xmr:x1FwaeOCYluQbHVqHC0b8yb2QyAzu4oYGvwgfL3Rv1YcRePq4NfK1L8su9uzG-K39Rf20ZSVJLGZZZsgDaJ4alcLa9ozRYjqUp45LbFlfXWe>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugedvvdejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurheptgfgggfhvfevufgjfhffkfhrsehtjeertddttdejnecuhfhrohhmpefpvghilheu
    rhhofihnuceonhgvihhlsgesohifnhhmrghilhdrnhgvtheqnecuggftrfgrthhtvghrnh
    epudetfefhudevhedvfeeufedvffekveekgfdtfefggfekheejgefhteeihffggfelnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepnhgvihhlsg
    esohifnhhmrghilhdrnhgvthdpnhgspghrtghpthhtohepjedvpdhmohguvgepshhmthhp
    ohhuthdprhgtphhtthhopehvihhrohesiigvnhhivhdrlhhinhhugidrohhrghdruhhkpd
    hrtghpthhtohepghhuohgthhhunhhhrghisehvihhvohdrtghomhdprhgtphhtthhopehl
    ihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinh
    hugidquhhnihhonhhfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehl
    ihhnuhigqdhnihhlfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplh
    hinhhugidqnhhfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhn
    uhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlih
    hnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohep
    lhhinhhugidqvgigthegsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:x1FwaR8X47pB82llCoOnx-_tqfG4Wgl__nF7iR7DTsvnBKEgoxWWLA>
    <xmx:x1FwadL_4AgUdEoAdrrjBUzKm_QwvAZ5_vABwDi-yZXKOEZQmRVN-g>
    <xmx:x1FwacjsPmz0p5xJHKbK1Llgy6XHSkD5sIUV00neAVndqU1R0osl9Q>
    <xmx:x1FwaQ-U7Yh5HcQNL5v5YvAtJgbgLMSzKZeFpndI7b9KPjw4FZERdA>
    <xmx:yVFwafa--UBBDa_lEtTQJ8XgCJ_3LeDDEGWDRnQKAI7NA5gXIajXqhW->
Feedback-ID: iab3e480c:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 20 Jan 2026 23:10:25 -0500 (EST)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Jeff Layton" <jlayton@kernel.org>
Cc: "Christoph Hellwig" <hch@infradead.org>,
 "Amir Goldstein" <amir73il@gmail.com>,
 "Christian Brauner" <brauner@kernel.org>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Chuck Lever" <chuck.lever@oracle.com>,
 "Olga Kornievskaia" <okorniev@redhat.com>,
 "Dai Ngo" <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>,
 "Hugh Dickins" <hughd@google.com>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Theodore Ts'o" <tytso@mit.edu>,
 "Andreas Dilger" <adilger.kernel@dilger.ca>, "Jan Kara" <jack@suse.com>,
 "Gao Xiang" <xiang@kernel.org>, "Chao Yu" <chao@kernel.org>,
 "Yue Hu" <zbestahu@gmail.com>, "Jeffle Xu" <jefflexu@linux.alibaba.com>,
 "Sandeep Dhavale" <dhavale@google.com>,
 "Hongbo Li" <lihongbo22@huawei.com>, "Chunhai Guo" <guochunhai@vivo.com>,
 "Carlos Maiolino" <cem@kernel.org>, "Ilya Dryomov" <idryomov@gmail.com>,
 "Alex Markuze" <amarkuze@redhat.com>,
 "Viacheslav Dubeyko" <slava@dubeyko.com>, "Chris Mason" <clm@fb.com>,
 "David Sterba" <dsterba@suse.com>,
 "Luis de Bethencourt" <luisbg@kernel.org>,
 "Salah Triki" <salah.triki@gmail.com>,
 "Phillip Lougher" <phillip@squashfs.org.uk>,
 "Steve French" <sfrench@samba.org>, "Paulo Alcantara" <pc@manguebit.org>,
 "Ronnie Sahlberg" <ronniesahlberg@gmail.com>,
 "Shyam Prasad N" <sprasad@microsoft.com>,
 "Bharath SM" <bharathsm@microsoft.com>,
 "Miklos Szeredi" <miklos@szeredi.hu>,
 "Mike Marshall" <hubcap@omnibond.com>,
 "Martin Brandenburg" <martin@omnibond.com>,
 "Mark Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>,
 "Joseph Qi" <joseph.qi@linux.alibaba.com>,
 "Konstantin Komarov" <almaz.alexandrovich@paragon-software.com>,
 "Ryusuke Konishi" <konishi.ryusuke@gmail.com>,
 "Trond Myklebust" <trondmy@kernel.org>,
 "Anna Schumaker" <anna@kernel.org>, "Dave Kleikamp" <shaggy@kernel.org>,
 "David Woodhouse" <dwmw2@infradead.org>,
 "Richard Weinberger" <richard@nod.at>, "Jan Kara" <jack@suse.cz>,
 "Andreas Gruenbacher" <agruenba@redhat.com>,
 "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>,
 "Jaegeuk Kim" <jaegeuk@kernel.org>, linux-nfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-ext4@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org,
 ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
 devel@lists.orangefs.org, ocfs2-devel@lists.linux.dev,
 ntfs3@lists.linux.dev, linux-nilfs@vger.kernel.org,
 jfs-discussion@lists.sourceforge.net, linux-mtd@lists.infradead.org,
 gfs2@lists.linux.dev, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 00/29] fs: require filesystems to explicitly opt-in to
 nfsd export support
In-reply-to: <9fdf7a8c04861306b453a78233f4bd6004c465f4.camel@kernel.org>
References: <>, <9fdf7a8c04861306b453a78233f4bd6004c465f4.camel@kernel.org>
Date: Wed, 21 Jan 2026 15:10:22 +1100
Message-id: <176896862299.16766.6206046829320088529@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>
X-Stat-Signature: fid5od75u9xs6w69x6wjp8m79mdkdzn9
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BF76820008
X-Rspam-User: 
X-HE-Tag: 1768968650-792735
X-HE-Meta: U2FsdGVkX1/9rxDhWX9UNKEFK+q1Du3UNGUIfe/IiCyL/mdWn8+GPu2irygjEQj1TA9nG+U2xa85T1Ir1RQ693LPYf45I+fy5/fMYmopIRSuE9rb0HFDBpCPH7LFOFMGFd0JeC+TvPoG4fzD+9QO06+Z5hrhAUtncqZ3l3qYeP5j3x6RC5jADnauiHKi910e626UbnZe2G+v8EP5n3nzzzsQR1UkvnlQ3jp207d6GoXUjzAwT8XzT68EdBBzpPuGMQz6wKZD/voeKuPhWMqO9q8Ysw7D7UGgdpXFJP2PvqN5gOWOSnNIGQKeedg09WL/WeMi1DIb1DXKVFkdRZQqBPcoyoHO8BulttfOprNJWWi/B/4rQk+8VUp6OXZSXXckkqUzHZoTzQhAfY0pyJozzKDuEZS0sec3EtCYrdE57LN7lBcCboxyrZOadjRBPmB0Puy81yjTow++lKfjVhJwOT2I/Fv91muzaSau2DYU4JicQB2RuaxFLWVkZOqD9wFa3KqeGlQAR5KsUHgZuQrwq0y6aroc0+FigfX+esTx6OYpLKI8chw7VXKjQZArQTfhZyl0l+wRC2Tx65DV0sM0Jpj0RmXJ6zNIMmJpM3SzGZ1bZ8FRXZZ//Nxfvc90HnSm/dwLbg8GKxx2IM5T09g2evM/6xwAG6W8CtnoBAfiiZMQI+BcEo+SNrfV1IykfgPxp2qw2eby5MVm6FXyDlxndKesVfpW7TldUIY+q1JlJWx01Mdt7PKk8DnxwlVu9prMd0mK1NCD9d+OAkxkF5KyhCJUtcK6gbGu79RWecQHN9vVSwC/eIEU0Oyp5Lb6jtbjfY5l3pKBNapnPevXLOVlv5LXvr2kPSE0aEow7HVO7+hlZymT9s1oozhmrE72TgdS8uPrmP4ZE5IKe2wd9AuatfexEJ2qrxZ8ZwopKBYWVjOeG0XMWkSFP3oavHZlRaQDW+FXUUqYGHCYF0ZeSWr
 iappmcPs
 ntMqCb8OqSO27w0DwBux8Ip2JANlY1t1mVZbkkAa/34mRQE7M4cao3+LIEmrbkROMD0ldRHHV6yLqDATof7PUuKFSJ7InZdb5rki28AvfwzX+BCvLkY4aNNlxJ5fW0OS8i4yoCl2wVuXQ7r+TGEh7ksZ3/EwCJaxGgj/6kHwfk50J9F9jfg7kh6JZs4WmoXeT239PzxaODThC1QFxwYM3pHfr50PPnZMrjZX0AuZq5Q8WYgHWR0Agj0iK1LAPAcgQykiBLphX4TvHaFLd60osekifiK+d8Mg/hhuRl5ixxkxNvsWBm2XbdKrlhuw9oDmX8lQMb5VTohxTwdxERkIG9CUmiflgY+yhcOx1niKQMhjLBZTqTrxBxf/M6SFbnFT8Bm9Q6BA387ml4ejRuEAuw24zoGqJ8iTVyuExPwDbuq4xkIRYlbNGckc6uHx/NCvSfUZAZegKh6O38nSRFfMovQ0UWwWmi+oUH15k9NSi+Db3gLsxKOl2tzVIw58ajvcFvAaAYs0ZzlSXgGL1HWobm5v4T+BCSpxRusmlqY+R9O8xMOCCZgDh6sgkuHWtEJZ/zAhLP7AngIJBvEeFRvT40dyKC/wqiWzOrNyRkqGj1W813KCNXVn0sDOVhYAaEM1XrW9l1s+TAR6VeNhail/j5teVxffyl4JN6AwuBF+WiH0h+RhVQTNoC2+s5Z/BGPc4VmjceyHggoRlmHNmq4xHxEr5zw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 19 Jan 2026, Jeff Layton wrote:
> 
> There is another approach we could consider: We could move the
> export_operations that are needed for local filehandle access into a
> new struct filehandle_operations or something. It does mean adding an
> extra pointer to the super_block for the new operations vector, but it
> might be more intuitive.

If that sort of change were seen to be valuable, I would rather not
create a filehandle_operations but merge some (or all) of
export_operations into super_operations.
Maybe then the existence of s_export_op would return to mean "NFS export
supported" even if it is empty.

Thanks,
NeilBrown

