Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01841606A327
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 13:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MNh/Womf
Received: by kanga.kvack.org (Postfix)
	id 258676B05B2; Wed, 11 Nov 2026 08:56:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2098F6B05B4; Wed, 11 Nov 2026 08:56:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F94B6B05B5; Wed, 11 Nov 2026 08:56:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF9FA6B05B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:56:44 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C80201C2F6C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:56:42 +0000 (UTC)
X-FDA: 85422988644.23.4CA93C3
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf26.hostedemail.com (Postfix) with ESMTP id B351D14000A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:56:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="MNh/Womf";
	spf=pass (imf26.hostedemail.com: domain of konishi.ryusuke@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=konishi.ryusuke@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794405400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oRF2guphEyqLr1O9h9fq+s+FW78qBgZ0/k6wviHnruU=;
	b=A8QyH/8hROboW09BWh7hQIQ2BM+KehlDtyFNh6Jhphi5igkEvWAEVrV/8iLYu9AO8Noc/y
	xaWN/HOVANggq+Sjb6FUhklS6jt55s0pQtsLpCzfgqVo4GlXHxWKEKoGiBUJMI6zycHUy9
	GHVb6KMWtz8UR7G4gdSbg+ACuSsfipY=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="MNh/Womf";
	spf=pass (imf26.hostedemail.com: domain of konishi.ryusuke@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=konishi.ryusuke@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794405400;
	b=W1hAKEoQR6ygU5p/p9lAc3A7MUQ04f12LcG1EALaPLJTT8B1aN93Piz+ny7XolvV/p0Ks7
	Gj4HXjby5hbWamkTbHR0S9jznkZilq/svaBolH2Z8dzGEqv1FX9DA7iIBF8ES1s4rbPdv5
	s4LqzEH5Lie++oTmxJimCNP3WszoSOs=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a207b02a2cso22146935e9.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 05:56:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794405399; cv=none;
        d=google.com; s=arc-20260327;
        b=do8YkQC64BvimxX3qcUiMQuTMz89kATz2Zyk5GX3IGRyJ7EweW1rzqiHT1M0AqW70y
         x4Upi+YiEPQyjA8BFYnz+AZz5/qZFrUlYT+tuBHpdd6TMBPAgEVrJcaZBH2HHnqQTXY4
         W2/RIRPn9vaui8hWtbAKTu4ot3LePc08lkXgL5QHz9RFeLrOZleGNG4I40Kh3CF7lcJR
         fvPpqaFo5X6FPUuZZQCfEMLwMs9Q38wwj3oM6vryaRFbHcX7nKnGZfBQ3FwzGi7Mpdz7
         EFaFmM5T77ZjaFiDwD/zPBk5qpUKiT9lX8Us45tTMwpoZWt5qw3Ar9u44LAy9q1k8dXk
         sNjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oRF2guphEyqLr1O9h9fq+s+FW78qBgZ0/k6wviHnruU=;
        fh=D0F2R8E4nLWlr4i2B1BVGqC0WOhbJ8a7+jgjF+qpfZg=;
        b=QaUKCsu7XpRSldzdghlVq/boJia325/PuQBSkCZUwY6ANIO2U1l9+z5LEnXcS+hg6g
         lL91FQowyETqOw1dzbSKvireuwTkntBk9wSQF+vzYXR1Jkl6bvZ9csAv95thISbuM2aT
         sY6tOmuFi2feTGT4per8HCxCMsJ5rlWOdwk7Ozt7XVqMtFPcNMYlXOoAS76bb1bnqEkq
         a8EeW0zrP4i+5Mlv4PUV5ERJpPr1iB6Y1eu7OQkEHaBgwUgsyCCqi/3/hglRs6j2ycXN
         4JlEec5hWLof0QkaZka35ohrbEgJtRDy/Br77+TNPkS/nE87Uuu9gmAPX7PSiHXUVvVk
         heZA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794405399; x=1795010199; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oRF2guphEyqLr1O9h9fq+s+FW78qBgZ0/k6wviHnruU=;
        b=MNh/WomfKGw6d03v8hp5kNybKiga9HDQbU/n1X9HmNfTbofXAExzzPfmzQtdnAysZi
         FnS8xAZ11D0EDM68iQ9A4638YfTx4MUwuEPnAzpuWUwNUD6gVNYUgAywb0x+YqmgH+uJ
         1INc31YSpvsp64lHRg1LAqVbChl09cqoBGJkCVVNOKP4R1b/oygQCxYHglsA2DfMGqK5
         2pthQYa8Lur0NqRaT9mMYP7VrngD/cHDeNmJgxQYnn4H59jU707wZVwY7yzNHCdymUhh
         tnmATkfCNef0klv0LuGCmsQ0zu7jcoQtNGFX3dixiz83qTLT626cQlETVD7hGYySM4gx
         KZNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794405399; x=1795010199;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oRF2guphEyqLr1O9h9fq+s+FW78qBgZ0/k6wviHnruU=;
        b=hDT4KMES+9ichpn/2/r/gUknMAP105jlbbR/eawtAa96CgfDVZRdDoYucw7elNvXOv
         KQOkEDtI7z71NFPWmywtI7r1o5L4yXutcysm6AKC+RHbMNW46bVZaWCsAugDgdjm1NzO
         sKfyo/XywsQH9+hZCBh7Jz+oZRbwrmpmF/PtE3WEYXtt8grKpuWOC3oo63hZWHrRF7Vh
         QSpNeJ8kJqFJvA0NonlUzWhDXYsQLOcwXPeUvwmP/X8qw+I7deR883ba7rVzBEK61pWt
         f/nukKdd2M6SF4YhmljOjsTLZZrB25FbaRGNjg+A4pM+yFd1hxEufaKf/rhEI2Yciz1D
         QPvQ==
X-Forwarded-Encrypted: i=1; AL+hErEWROONjGIiWNkn1Ge7TQ9MWDvHetvYYicbTBRdmho6YeAYBKQwO4/FkPOCgYCE9OC0mFzR0Iafsg==@kvack.org
X-Gm-Message-State: APuU4Z/Mn2aE+YhzdkmgaVXGdGQJZa5kfint8PNXOoL85Ce1eecg5Aol
	Yi0yuv+iBChP2tAmuyo6qhRi3eL6friFPlHQ597lDwLr5z5enPz53nsy7F1k+5kq7m4ULt+GyuJ
	zXxTg3RzXd2VoWtOjrFj+ijVPK/vT+ko=
X-Gm-Gg: AYBFou3xxiD9KZ7Au54NJKdZH4pGrbhmqYgbO8+Zi52qUm9Xsbudhyym/veUR35RDiH
	A3JrFBg2MTHOzwPrJAKBEkrxm89sNjrmjVmeFPlzqQCeCqf1GW24ui5PHMef6gFLvYrM83eDTv2
	j0S8KHbXibZcIgKAaF081K2/uW/bt5pPenvOT4jRogQIqK9m4/h1DyXENVFqthHgxXzxwUqnas7
	bNYSdNrcGHkumcFeWxU8Tl2T2jZ7At3uCxZ/PrdXpTqeNVTFg4f9YuXhHY01FDZ/3LiXi2ikdHQ
	GWjjcJPotmdN3Z9JEkvRCot55XsE+klcao4ZqcAmZnJ8im9MdHftnAN/N/3UwfFzr01GdOOaItW
	gfZDcwaKqlahHZSFKgezNC/FOPN1pxowCK73Wb+cRO2PkJORgRURu5oBvcB8=
X-Received: by 2002:a05:600c:3485:b0:4a5:a5ca:de1d with SMTP id
 5b1f17b1804b1-4ba093a9321mr49991515e9.30.1794405398960; Wed, 11 Nov 2026
 05:56:38 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-6-2f44f64f0b66@kernel.org> <sashiko-outbox-191225@kernel.org>
 <CAKFNMombDWkJ=m+CjMy7qnd_yy-vZ9c-EE7R95HKKkcy-M0+SQ@mail.gmail.com> <20261110-deformation-knabe-geltung-3bb7600eaead@brauner>
In-Reply-To: <20261110-deformation-knabe-geltung-3bb7600eaead@brauner>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 11 Nov 2026 22:56:21 +0900
X-Gm-Features: AclHuK-kg_k64kD5D3ppXkSngFLDCk2NlJ0a-lNWh9VMpnIyjECtxc1ueGN5wqg
Message-ID: <CAKFNMomUbm3JUBy2GthZwAuFZWh5TSb7i0+g8u1qv1aRviqdaw@mail.gmail.com>
Subject: Re: [PATCH v2 06/34] nilfs2: don't set SB_RDONLY after filesystem errors
To: Christian Brauner <brauner@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, Jan Kara <jack@suse.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, 
	linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
	Karl Mehltretter <kmehltretter@gmail.com>, dsterba@suse.cz, tytso@mit.edu, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: getxpj8i9eqry4xign1c6eu58t96tq7h
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B351D14000A
X-HE-Tag: 1794405400-818961
X-HE-Meta: U2FsdGVkX18bN17S2E/BTtPeQp4vrpx5B5cLHpv4Li4QoZ1FUJ2kuq33vSC+dB6BipEGHRyTwHwVbClVwKEnM3BxV3gPt4OsJG0vGW0i2A1eTfwqK22ZfANF7fcX8twlI74KSYlBHS00YMmR36n9cVR/PBisHBviVHk2LvSOKgtqqcQwYPcsGPyUdhp6AHPcLDuZY+xgZHKZL5pOaa8Ig1FLkcTsoiV6aM24Y4dAH8RxtW2Xc9ThZafmQe/9v9Bm/HJ2EYQ8oDwV0UhNfo+2xSDuM7UJ6B5jZ9yjMzI/GiuHmps7TUpXyEqXzsI/nn/PJNmQwDVVHTawiUpqRHDLDqrg4jNnR1P1mA522lZGqLxirkRSgpn9ncaBGZD4PR4EO40eXH4nPjHe4D1LgeXb5M2FmRNdMMKZ1S28TlFH2uRrfR4nV+BvpG2K8Wznb7UjCCNxCkJA9t3ItEk0SYhL+4LJoumF5LwluFmkMuAjpk3liYk1POCqVe73mJsJKkMESqQgdlNTxdjQnFfH/CU3Mqfs+OpXiB/m1YmUmaYu12OmNH4kMLqr/oA1/nmaRaHz13S/GfWypZ8IeiDOofQqMWdD9cMF+lc8CYahe8s3iPDo+E0akQOk7ndmdFeLqB54CoNyjmDYof4iLt1nH1XXejE+BQJRuJ33s00qUzEtKCdvp2F7E05HcRr3ePHgBVyuzlaPN1S2Ge9gIqljHsdhUCY5N/KGMaeYe6ijt021tQmKpPXL2hLQA50S056czUquA/AJhTkQGQSK64bhxTgByB33V+L1ggmTIorITRKuB/pIDQD9PRiarp+yWr+UrJM++IGUWposCxbzClaa7ZRN8We411bNY5q0BEETyzjEuv4vJ05OKeJ0Wzr2eoVkJCbQAM6bnbHEKdA8hCIvPChRvu4qfWcqGjDe+uagF9EQOupQe4y6qoO0MbQjRWRBY3suHPoDnqTYAKI3d4lWRMg
 KrNrfDsn
 45QDfFkX72wcFjvjNANSqtEGPfBolxzhFbWTk5h/KrRgV2l6SwII2hxkMXER8dBlV53zPS9XptVgElse20IExgLclg4Al29HpyG7RGSfdQsJMbIsodR7PBqWb5h+una2/kPAh2si7JAjMwuGb7G9zbISTQTohMl1MJ9CzFHsRW1JTjbCFilDEsYQgoCPdtwp2z3y2+FCWwIaV2SFwNMPpUs6kKzSoZbbh9wq5bZ4x6ATDPeMnOMdAo5XCwMp5sVWDcNCG/AnMYlqGUtxea476ShirT1pb5uSzP5XXMg6XkuPubII6RiVoWxHxDZNTQtjXW4yKPtcYjaPTgCxkuM05xXrDEYZd2gHrxYrvvMJEErYzgbUtEJAJ3CDenfU05pPTQr4FPjxFAO8EHVq0GmnNNqA3J3ibjHgT4ngWjGr2J7987LMTdsAek+KPGA+Swg9Ql1jKV8fXUA+xpcNAsVCAYKub38AahvE8E6T4MBlX4dAdJvI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 6:56=E2=80=AFAM Christian Brauner wrote:
>
> On Wed, Nov 04, 2026 at 02:32:10AM +0900, Ryusuke Konishi wrote:
> > Sashiko's point here has a valid aspect.
> >
> > This inconsistency can be resolved by inserting the following handling
> > logic if sb_emergency_ro(s) is true:
> >
> >        } else if (!ctx->cno) {
> >                 if (nilfs_tree_is_busy(s->s_root)) {
> >                         if (sb_emergency_ro(s)) {
> >                                 if (!(fc->sb_flags & SB_RDONLY)) {
> >                                         err =3D -EROFS;
> >                                         goto failed_super;
> >                                 } else {
> >                                         s->s_flags |=3D SB_RDONLY;
> >                                 }
>
> Meh, I'd not set SB_RDONLY there. Because it changes the read-only state
> outside of reconfigure_super() which is precisely what this series gets
> rid of.
>
> The superblock can be frozen at that point, e.g., when the error hit
> while it was frozen, and then thaw_super() leaves s_writers locked again:
>
>   mount /dev/sda /mnt
>   fsfreeze -f /mnt
>   <error>                       -> sb_set_emergency_ro()
>   mount -o ro /dev/sda /mnt2    -> SB_RDONLY on the frozen superblock
>   fsfreeze -u /mnt              -> s_writers stay locked
>
> It also turns the superblock read-only underneath the existing
> read-write mount without sb_prepare_remount_readonly().
>
> The busy-tree branch does what get_tree_bdev() does for every other
> block device filesystem. A second read-only mount fails with EBUSY and a
> second read-write mount gets the superblock and every write fails with
> EROFS. That's what ext4 does since commit d3476f3dad4a ("ext4: don't set
> SB_RDONLY after filesystem errors").
>
> If we want the second read-only mount to work I think we should do it
> for get_tree_bdev() and nilfs2 alike and treat the emergency state as
> read-only in the comparison without touching s_flags:
>
>         if ((bool)(fc->sb_flags & SB_RDONLY) !=3D
>             (sb_rdonly(s) || sb_emergency_ro(s))) {
>
> But I'd do that on top.

Thanks for the detailed explanation and the concrete scenario with
fsfreeze; that
makes complete sense.

While the "s->s_flags |=3D SB_RDONLY" assignment in my example could simply=
 be
dropped, your approach of treating it directly in the comparison looks bett=
er
as it is more conservative and natural.

I also agree with aligning this secondary mount behavior across get_tree_bd=
ev()
and nilfs2 alike in a separate follow-up series on top.

So, I am completely fine with keeping the current v2 patch as-is for this p=
art.

Thanks,
Ryusuke Konishi

