Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6713DCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 17:42:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BC7A8E010C; Tue, 14 Oct 2025 13:42:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 693868E0090; Tue, 14 Oct 2025 13:42:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5822E8E010C; Tue, 14 Oct 2025 13:42:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 455758E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:42:13 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E89FF160A13
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 17:42:12 +0000 (UTC)
X-FDA: 83997438504.06.CA72CB3
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id CA0441C0013
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 17:42:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yDmoKVMt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2WM08dl6;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yDmoKVMt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2WM08dl6;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of dsterba@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=dsterba@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760463731;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AAlEg30Xh123ICsXxHR1i8eLACocDbvHskeA1BeozEc=;
	b=U9L7AU5W3hSKsrJd/a7Fw95NFFPNoo9LjcbB3RQbcnJbSKx+VDrM5hzJFMKwMM/5V/r/9U
	MBiOsDMAoKK5TgJelh1gi5amyy+vljs2masbQtEGdNQW0ZTJUr05TX4zHrCT9DjuO1bysj
	2TRuXRy0suLhEZcXWfdYyoBFVovO7Mw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760463731; a=rsa-sha256;
	cv=none;
	b=eMzDlH9A6Z+uTXP4wbV7XxF/IsmozP8Tr9IoAJvimA7eWY7FhhF4XL4swv0BaHOCBZ3BFx
	uIbpVtDRvmSJcTtBou+susAN1qgHuhTIUwiA8yuaxvBtpBpZu5RrfNgRzDfdmi7hXfNxML
	K/+q8AYrEgmqDBWr9mfjDGD7q7XTy2g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yDmoKVMt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2WM08dl6;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yDmoKVMt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2WM08dl6;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of dsterba@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=dsterba@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 76C2C203BB;
	Tue, 14 Oct 2025 17:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760463428;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AAlEg30Xh123ICsXxHR1i8eLACocDbvHskeA1BeozEc=;
	b=yDmoKVMtwLRJOBlla660Ag05yHaNOU1W1IV4a81qJLQLwqxGC/tzhmPsEY7YTuWQLSSusc
	2291jCfcaCjyFff6ysHIWs13HLYVAPOEznX0vps0yRRO4+BBD3fZAwaTxqQOW1HbUGxcjb
	+ZEbO3Vcv2kGHiKZVUmyXj5b7OVr+N4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760463428;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AAlEg30Xh123ICsXxHR1i8eLACocDbvHskeA1BeozEc=;
	b=2WM08dl6lr7hfNBq0u+y+9D4Fb7mJE8UhxacJqdxQbZMxWliQxqE7oANIJuKqumg4DkUsY
	rcpsVna643JvdGBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760463428;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AAlEg30Xh123ICsXxHR1i8eLACocDbvHskeA1BeozEc=;
	b=yDmoKVMtwLRJOBlla660Ag05yHaNOU1W1IV4a81qJLQLwqxGC/tzhmPsEY7YTuWQLSSusc
	2291jCfcaCjyFff6ysHIWs13HLYVAPOEznX0vps0yRRO4+BBD3fZAwaTxqQOW1HbUGxcjb
	+ZEbO3Vcv2kGHiKZVUmyXj5b7OVr+N4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760463428;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AAlEg30Xh123ICsXxHR1i8eLACocDbvHskeA1BeozEc=;
	b=2WM08dl6lr7hfNBq0u+y+9D4Fb7mJE8UhxacJqdxQbZMxWliQxqE7oANIJuKqumg4DkUsY
	rcpsVna643JvdGBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3BFEF139B0;
	Tue, 14 Oct 2025 17:37:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5/kaDkSK7mgpMwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 14 Oct 2025 17:37:08 +0000
Date: Tue, 14 Oct 2025 19:37:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc: hch <hch@lst.de>, David Sterba <dsterba@suse.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Chris Mason <clm@fb.com>, Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>, Jan Kara <jack@suse.cz>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"v9fs@lists.linux.dev" <v9fs@lists.linux.dev>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"jfs-discussion@lists.sourceforge.net" <jfs-discussion@lists.sourceforge.net>,
	"ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 04/10] btrfs: use the local tmp_inode variable in
 start_delalloc_inodes
Message-ID: <20251014173706.GB13776@suse.cz>
Reply-To: dsterba@suse.cz
References: <20251013025808.4111128-1-hch@lst.de>
 <20251013025808.4111128-5-hch@lst.de>
 <aae79ea0-f056-4da7-8a87-4d4fd6aea85f@wdc.com>
 <20251014044421.GA30920@lst.de>
 <57d7136c-b209-4f8f-bb6f-8ced354d205a@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57d7136c-b209-4f8f-bb6f-8ced354d205a@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Rspamd-Server: rspam01
X-Stat-Signature: 4k4nyzxot5kqike784eyceif13d6yef5
X-Rspam-User: 
X-Rspamd-Queue-Id: CA0441C0013
X-HE-Tag: 1760463730-229456
X-HE-Meta: U2FsdGVkX18OMBZ3+CJPofk41RCess7uHt51HaMMQRQPUlaETzMUpx73GCY2zPM0IM86jwroiSMUu8Qx4ONpj8Xm5az3GVaEs71DYELxdaIuA8tgZUY9nD5WYSRd3AcoXuWRAwDyfqs8sIUS3toCRhHgYOG67dApf9Mmvvt0RI0gN3fZzG5CYbQ7L9Rigud+zXciSEOA4nIxoaEzI/cW/oBtJO57sO7ZKmXf040fb/rNAeB7D79tzwpYbVGp1xr+viSNtUpZAkO/7U6po8WiBdrX/EjYiF/yELa4ZaO0sdpYb/W2ZTXy2tn3mNNjLY8J78kvV+6mCEktED0o/iWl8hshXGcEw6zqpXdEy3/g0pF0jxKuH3GSx3KYajQDrY4+RZXhvzILHrhzNjY2NHC8xsgGOYM7VBvMyKhrqipODMXSyC6UBKrEmhAIBBDwtMamFUMAuG1vmtX6pIciNTpr7hXY3M78i7UQbtgKhjAtHUjh9dr5GJv8UCnWNQJoNTcg3JoFK52xAnpPG/eXB8GiJNS8D6GWyfo2vWGAOh05f2oAXWGN7FgNLNZYT42xcR4DK+2QNzCg18tWGgr5uGIGX9HtNu145yKEVFPVUyf2QHu6YivDfoxwX88u2A55DVbMZv6h91j9MAvi2+ck9ScnUfGP9Yw1DkdxUqiCuQtUCdyUgmpMEFzc9SzvYFYvq9y9wn2FSz0NNfxw+XN0zqmgphvnje8R5Nz5BeJqe6zl4LYTh49RHHHJCpn3CrnUzqywIIozMH06c8bLBum6GaNgsPQ+Fyky5hPEigaGemTRz9FmAJoCX5TLyczHGyAo0CvXYw6U+0OK/yBFmA3FX9RnUxG+eQsaoonJUy4w8ZtJUgWqYg00heoK8vC2Mpd+GXbUi43h/8caAVLt+vzj4l2zjc1u4ktbigLnVaGDoMr5/ES7G0q3RllASNF0Eut6ichnprxVphIg8mg6iPCQk1t
 c8DAvY77
 InEbUJiPbGvZ+rrfmHlKK5TsfeXshDaY7VIz5fdOv2928hhIkzX6y40V4uddosRTkraVHnHwr2FcXq5GLzzdeQI07VrqPFYWZ26UCeZVLfQZUIPY9wX3k1RUw8tOxvVEkNici74+SLvu9sK77BlrVDZSpHm0f/v48pWph
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 07:02:11AM +0000, Johannes Thumshirn wrote:
> On 10/14/25 6:44 AM, hch wrote:
> > On Mon, Oct 13, 2025 at 08:11:35AM +0000, Johannes Thumshirn wrote:
> >> If you have to repost this for some reason, can you rename tmp_inode to
> >> vfs_inode or sth like that?
> >>
> >> The name is really confusing and the commit introducing it doesn't
> >> describe it really either.
> > It is.  vfs_inode is kinda weird, too.  The problem is that inode
> > is used for the btrfs_inode.  But if there's consensus on a name
> > I'll happily change it.
> >
> I unfortunately don't have one :( David?

For this series it's fine to use tmp_inode as it's already there, we can
rename it later.

