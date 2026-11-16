Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E33DC606A330
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 17:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LWj9kUC8
Received: by kanga.kvack.org (Postfix)
	id F1DB16B00EF; Mon, 16 Nov 2026 12:49:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECF076B05B4; Mon, 16 Nov 2026 12:49:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D72586B05B8; Mon, 16 Nov 2026 12:49:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A42076B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:49:26 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 258FCA7487
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:49:26 +0000 (UTC)
X-FDA: 85441719132.04.BFF1109
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6D4CEC0006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:49:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LWj9kUC8;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794851364;
	b=55PFQteajYOqPDemuRlnw6qiM8zZrmmnm7nvdjICJ/gPGKXU28eojpU0mW3XpbmsePzTeq
	Fy0BdoBWnxPRtBfdsnmddbf61DoV199zu4R6hrG9mYE2biiqLZX8vvbgbEuijjE6T1/Xaw
	bvH884pI/5XPc8yoW6hG2whO95LYwxk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794851364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ED8m1EUNyZbVy60KlCH1nfmXFCVOvYy5WXRoQrkl9dY=;
	b=rhJHhe3ToN7flWkcY83SwKjvFqLpfckYAOwFDbbuUufmJxIzXsXZ4rFI+kqeiJbD7TuecH
	uAlf0E/NlJMJ2/TnHK7xrYRkhwyLQb2td/AerMUrqrbq+7/gz7KqxhkBSmBLN7EZitUp76
	JwVEt1UcvifhmsZHC/L2+wgjIGKn9gI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LWj9kUC8;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A06146147C;
	Mon, 16 Nov 2026 17:49:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A261F02813;
	Mon, 16 Nov 2026 17:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794851363;
	bh=ED8m1EUNyZbVy60KlCH1nfmXFCVOvYy5WXRoQrkl9dY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LWj9kUC8kQFC5SfD1vjbud2HBFDNnZqFBwsM7D7EkixcrkbHslvvXUPplnT67OEDa
	 Ojxvc/9bBfh+7M7IgMwLe0/MW3vEZ7MNK475jdjW9gzIKFiwKQYtp2o3epkEHr1OUY
	 ut8wZMtQ6WwDI4R/4NjZmngdKNKdP+t6PoX5HnYwVJTKEbOQrvDnGzw7NTHVCoa2iV
	 Az2pSjHFx32LhMnzCRrFLDjD1DXtR7qLBdQXkQEuVAl0z7iuGlB/eKvhfmNtzTqNut
	 eiuM63/QtPtS1+8sCvNSNotSJGDSOZKb/xcO1WCvyJtafHJlrptV+MYpMU1CW9c9N/
	 f6aB01Y3d7oMw==
Date: Mon, 16 Nov 2026 18:49:14 +0100
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
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
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC v3 33/44] ovl: refuse data-only layers on pseudo
 filesystems
Message-ID: <20261116-kriterien-getoppt-kauern-5a0c1fba70cf@brauner>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
 <20261116-work-loop-pseudo-v3-33-8cbbea1cf34f@kernel.org>
 <CAOQ4uxgPerkkG4ie0SyHVXaBD9VZN2wYfQpEAEi4hytn=ara3A@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxgPerkkG4ie0SyHVXaBD9VZN2wYfQpEAEi4hytn=ara3A@mail.gmail.com>
X-Rspamd-Queue-Id: 6D4CEC0006
X-Stat-Signature: ifgy5geog3y5wxy35gbcrd7hiqgge64k
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794851364-399832
X-HE-Meta: U2FsdGVkX1/fQ7AlxYTaK4XBPlZZ66OzN5kFEpmoHS6Fl/6H/iwU7VmoHp9n3YoPaHiyfY9m3BaIz13BGAjhrhAIwMdXpiP8natU6e6a5+MX4QqNeeVrwChHGvXZy+IZtz9jKhKXe8EjBfM2M8yflS7SbaK+3QbILY3Mk4T7HKDeGWPnmBRSZQpt0bIhjC7lX5KLNxiGmTQ1XQ7+R3YYpWFYdPKmyKOGWFFaTOCcTQ4OMOTq75flpH33h273LQIcQsQLPtRrAeiMeNPS0Q0K1RNisc4ji28epSlQv9z84wemb3R6t67hdl01rxke/DropHBvXDaCXWD0L3hei4stU6A6zSXgq6AiwiO4BNSyzxoD5af5AgM37SAzii4XI4ZjneBtRl12Sek2XQVGd0sZvb8K3VJ9Yz010GVrZlUmcudtgLQp+4ftQpzcq7BiUUzAOEa6sfaLgp8dWTEJiuc2fieLhaVY6kEV8oMCx/XfSpSjfl3Uy8hTaaQ2Ndbn3NSPPdlcwagD/7Iq++J8Uj3Ejl5RfISvh5Q5RjjeDKprwDC3b1FDH9JukHLk+rzuDyg0gsmHkNriAEZymdDKPuaS78/B5DzuY99bAVdPGaC53iSl9v23JFi2tvrn80Jon480wtvs4O8m1cW+nIOEwOa8FGAMBPhqRuB2F+vZ+A2mntcLrSJOMXlmcoMum0yHftfiPfd0zqMqcm3a/qNdatFzeLmVLuK5osaYpPfVBf3Dc9csv5344pxybZT5z+QvPBLl4AXi8x4suguIVb1yp4nILMhj66pIg+FKihlBmiCc8P1XHQms958IrOscN3y0elfx8efVB/sZoBVer/fR3/1TpDeVhxPRJIq6eDHOxiJUfQZAALzX5w2Xa3RG05tkYqmBbr4Dr5VPUCHt7cmha6qXrETl9J0LsrU8F/tHLiUrBRnzj8QAVxIZAeiDk/rhdXQ0gVDGjke3KCjXADYFfv4
 Qteptevy
 GW48uHPUSmwsKQLd2QJkx54hR9sZk5+Div3KNZJnex+E9/m6sfdxTKBDMroLN7MQBksfXmaX3Az3qHy9nW3sTi40iYmhyECCg3SQ2WrIqjHcYOMNlqiNRBp7EGuEG2fWY4uTMj0EPtVXX5/O8YTtk7xtSonPafPagNAU0itDo9dv04jm5WON6dizD3KkcFTmzkqXYEdG7PshBla33XyEEhs07i+qtiPcdTXJKigwRbvWJnrYgamZCZNnGpromf5RJjLFzq5EarkcUTTgoYb8uWcl6/XfxNnCyiblsR7LjOI3VXhvKZoLvrBm5eJ/hu7IfuOhgPnb/QQ20Mualqhmo4dzN7EfrtcVF1R/w06VMR3BzQSqdBwHWBIrGXURm7RHbWAPr5VkWGDh6jzP6tmOgYPcn//ZFCAyzK3DR3JefuMvbFmKns+2u8gdC3EwfG61zCNPZcKubr9lvKr9vaSVTTwQ246FJdh7I6nx7EkwgumIvsiI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 06:37:16PM +0100, Amir Goldstein wrote:
> On Mon, Nov 16, 2026 at 12:10 PM Christian Brauner <brauner@kernel.org> wrote:
> >
> > The data of a metacopy file can live in a data-only layer. overlayfs
> > doesn't look that data up when it looks up the file. It only remembers
> > the absolute redirect and looks up the data lazily the first time
> > someone needs it. So until then nothing can tell which filesystem holds
> > the data of such a file.
> >
> > But a data-only layer has no business being a pseudo filesystem in the
> > first place. All it does is hold the data of metacopy files and the
> > regular files of a pseudo filesystem are kernel interfaces, not storage.
> > So let's refuse data-only layers on superblocks with SB_I_PSEUDO at
> > mount time.
> >
> > Data-only layers can be added via the "::" separator in "lowerdir=" and
> > via "datadir+" by path or by file descriptor. All of them end up at the
> > end of ctx->lower. So a single check in ovl_get_lowerstack() covers all
> > of them.
> >
> > Note that regular lower layers on pseudo filesystems are left alone.
> > Stacking overlayfs on top of sysfs keeps working.
> >
> > Suggested-by: Amir Goldstein <amir73il@gmail.com>
> > Link: https://lore.kernel.org/all/CAOQ4uxhGxpBtMZ5kfuzR1tQAewiecoX7UjXQRo91QjJHH9T_Yw@mail.gmail.com
> > Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> > ---
> >  fs/overlayfs/super.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> > index 39d4d57dec230..719c2569dfeaf 100644
> > --- a/fs/overlayfs/super.c
> > +++ b/fs/overlayfs/super.c
> > @@ -1237,6 +1237,14 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
> >         for (i = 0; i < ctx->nr; i++) {
> >                 l = &ctx->lower[i];
> >
> > +               /* Pseudo filesystems don't hold data for metacopy files. */
> > +               if (i >= ctx->nr - ctx->nr_data &&
> > +                   (l->path.dentry->d_sb->s_iflags & SB_I_PSEUDO)) {
> > +                       pr_err("filesystem on %s not supported as data-only layer\n",
> > +                              l->name);
> > +                       return ERR_PTR(-EINVAL);
> > +               }
> > +
> 
> How about we make this just a tad more restrictive:
> 
>                 /* Pseudo filesystems don't belong in composefs setup */
>                 if (ctx->nr_data &&
>                     (l->path.dentry->d_sb->s_iflags & SB_I_PSEUDO)) {
>                         pr_err("filesystem on %s not supported along
> with data-only layers\n",
>                                l->name);
>                         return ERR_PTR(-EINVAL);
>                 }
> 
> I could send this as followup patch, but since this version is simpler
> there is no real reason to have the intermediate "only ban datadir" step.
> 
> Only the commit message needs a little more flexing to justify this.

Just sent me the diff on top of the series and I can fold it with the
commit message you want and slap your Co-developed-by and SoB on it,
please?

