Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44E1ED49C9E
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 23:56:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABCB06B0088; Fri, 30 Jan 2026 18:56:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3D076B0089; Fri, 30 Jan 2026 18:56:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 969BD6B008A; Fri, 30 Jan 2026 18:56:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 87EF76B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 18:56:03 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3E8E21B1B14
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 23:56:03 +0000 (UTC)
X-FDA: 84390291006.27.8CE909A
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3DF7A140008
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 23:56:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="AO+G3MI/";
	spf=none (imf26.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769817361;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WunDx0fb3GW0z9IYkcolqOlpoStL9vS1z9b/3h7/9sA=;
	b=HazXmKm5E8Ek30ybPPkuMhWRgCl9IPi0pdkDoC0UC6/lcFKdTSFFbCxjrRNR3BAxn94xo7
	o7CskTpqCE61FGmwuLvDGI3jV7+oUegy2gaXN+jz6fD3gtFbOC77fAEeKVp6eu9XD61paf
	iJs/9PS1U/AXllVwUa0gHjmwd7W9oac=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="AO+G3MI/";
	spf=none (imf26.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769817361; a=rsa-sha256;
	cv=none;
	b=oUS99k6orWqQ7GB+cPAIbThjJp5/aD8S8mkeskIGi1Ed/svnbkVgBsxfIQOZWsYbwVvjSL
	oSF+jrKMt1cvFHICf537NRlt90hE+n9l/5j+Dikv6/PtcC28Ufuo8qIKWAlNn4LcSCQ3pW
	RgduM0eIBg21IbqzYcFSZaH4xeZojvs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
	bh=WunDx0fb3GW0z9IYkcolqOlpoStL9vS1z9b/3h7/9sA=; b=AO+G3MI/5/op50vRQvZ2KSjky2
	o2ePb5Zukk3sXqeoNldFFJbSdw+Qp7uPktsF7JIRKDMKPcu/acltZPsnYWSewa2lLpyc2Gx9MlnMF
	O3a5gu9xLnoZ1RZqF9iA05zLoPaHp5rsq+K1gR3L76DF8WbF9zlg8f6xM6E2G1VQAn9TaPm+Tk5Y2
	s5bwYJffBoYET1FOa8HR7vJwT9oiZweshSD1mXBXH7uapwklcxfNchd2/QTs+ZWS3FHEhaI0q2NAO
	4iOY76PwJp8GPEtE84eZvCDEagFHnDbFvVFgCapOv8se+c1FU82xSEGXvHZNGQbgXWrdNVN6O9s2V
	gVLXLJfQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1vlyMx-0000000ChF7-0kg1;
	Fri, 30 Jan 2026 23:57:43 +0000
Date: Fri, 30 Jan 2026 23:57:43 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Samuel Wu <wusamuel@google.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-fsdevel@vger.kernel.org,
	torvalds@linux-foundation.org, brauner@kernel.org, jack@suse.cz,
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name,
	a.hindborg@kernel.org, linux-mm@kvack.org,
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	kees@kernel.org, rostedt@goodmis.org, linux-usb@vger.kernel.org,
	paul@paul-moore.com, casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com,
	selinux@vger.kernel.org, borntraeger@linux.ibm.com,
	bpf@vger.kernel.org, clm@meta.com,
	android-kernel-team <android-kernel-team@google.com>
Subject: Re: [PATCH v4 00/54] tree-in-dcache stuff
Message-ID: <20260130235743.GW3183987@ZenIV>
References: <CAG2KctrjSP+XyBiOB7hGA2DWtdpg3diRHpQLKGsVYxExuTZazA@mail.gmail.com>
 <2026012715-mantra-pope-9431@gregkh>
 <CAG2Kctoo=xiVdhRZnLaoePuu2cuQXMCdj2q6L-iTnb8K1RMHkw@mail.gmail.com>
 <20260128045954.GS3183987@ZenIV>
 <CAG2KctqWy-gnB4o6FAv3kv6+P2YwqeWMBu7bmHZ=Acq+4vVZ3g@mail.gmail.com>
 <20260129032335.GT3183987@ZenIV>
 <20260129225433.GU3183987@ZenIV>
 <CAG2KctoNjktJTQqBb7nGeazXe=ncpwjsc+Lm+JotcpaO3Sf9gw@mail.gmail.com>
 <20260130070424.GV3183987@ZenIV>
 <CAG2Kctoqja9R1bBzdEAV15_yt=sBGkcub6C2nGE6VHMJh13=FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG2Kctoqja9R1bBzdEAV15_yt=sBGkcub6C2nGE6VHMJh13=FQ@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: i1957xmky5syhmenjsn45difwgwp13jr
X-Rspam-User: 
X-Rspamd-Queue-Id: 3DF7A140008
X-HE-Tag: 1769817361-302602
X-HE-Meta: U2FsdGVkX1/f88PE1ohZdCKcCg6K9k0qKGl9BO1tU2DNQV0zQd/6wgjxnXUIZ5LRV5tsGR3rzVx+oBP/RvJ/zJ60VLnvb2fdhyP1K5Ey91QUyNXAc8d6rB4gMgmwbRN312skeipe4H8VQns5S0pbYl3+3FbcGZDnbKYY3TvND6dReUiKp1QiWpfDYq0b+iMG6lBnV71xYlWXRZQkvW/od29012hLStARCUFgB6Ml+q+RPcGpLQD/gKcr1y+TsDMN02+0AvW1/z1g5UEAibIy/9HaJFvS/XYQ8D0W7vaGl/dAFKeyYBUvjd+JovCpUUvuTgPibDQAEIdaywyLbY6txRMjsbmzzmEPAENSbp8jomxxB53zKtLiar/W6cwF4x6/C183maxgE0hCZyHs/IjXjsRMgceUavlV6HPewRQRxCcEC0EdI7pay2a/oGBcxE1wLRS5k2QJZhTYYinNCSUNPqTLbWboILbyedDh9W8Y3C+7DhPIMfxjE6Vsw7N24acJSKcFRmtRFHZiKNuSsT0Tt17dLBwbz+Up6xKIH6RP3Quh7Foqd2zNNkrYQKbqc+lydqJzrhCCkcU3O7+uT0gT6SB5pvm0SZ7VEygCAu2uC8kpGgDQ2N5eKyW+DcqZjIIrIbpbCtipK0VvckUfPQqFCQVtRHGy2iep011Xt4NDLSltdsc5rjDBQgYtNPH51uxo+ACmDqkBtivz3h4tYyGab/+lsz8PAE54bInnBRgd8aoGH5/CssrQujRPk3OD/hYQz0Abx01fRUtKNlH5IqRMpZeUnScSujEaEzdk4/7iIrpLs48lIXhL2ybWpc1NddM9V3tgeUGv/iEKAauKx9iN+EFgE8v5M+5vkv/+QBBs/qL6bS/lorQ0T3UAe3oNyu8MfIzFmjZlPiExhoYT81W11MnDiNH8+zV0OuA5Rlrrx0jionHIqn0nJ6sdsDam5x8n8G/2AMKB88jc+m8ex5p
 z5DBJOQC
 zua1C5+auOiudwhSN3QZ/YV/N4G94zT9qNGSSvqLkl+AS4LUqaTgTmqHfDuDo9IcXin9koOWaJjLB1W7D8OYRUaMWyyEOOO02/zwgABHo9zYrM07lSFCK5/tl+L1f2QWNMYZVBbXXLT71Fs/sL2JrsYV/vChHw2wHHFCx9js3/mFPTbAuJhfstWvSaznkkNsLRstn1zhbSvyp5hENXPkKgMrGj+uUkPyx5dgP/dkxWzMv0lyfxJdTP83wG6AW73Ohsi2xe8+C8ciJG7OmumOhCVJnrMzrjWvN4+SP6cfVbgwGJpvnbqJ5aoNi6oMV0CLegIGwUr0CVMW2kFRXltEuvxTwV6flDV42qLfw85l72uviFO44FvyaWU+/AYUz/TLifeOI1sGjHVJq7N8QsO/dPrLnCP7HqdPOrx+x8S3J6VDHRaPUPvne24eMEVowAFr0eYhJwOujMzh9sIoMnWBq0QUkPHHJ8NphLLiAh4Ry93P7n6QM9o3DixjaB2T6MDcg2LP+y2FWvfGVr7F0vgLohHcqv/cWsCKJe+F8xOWYYRCaynI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 30, 2026 at 02:31:54PM -0800, Samuel Wu wrote:
> On Thu, Jan 29, 2026 at 11:02 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> > OK.  Could you take a clone of mainline repository and in there run
> > ; git fetch git://git.kernel.org:/pub/scm/linux/kernel/git/viro/vfs.git for-wsamuel:for-wsamuel
> > then
> > ; git diff for-wsamuel e5bf5ee26663
> > to verify that for-wsamuel is identical to tree you've seen breakage on
> > ; git diff for-wsamuel-base 1544775687f0
> > to verify that for-wsamuel-base is the tree where the breakage did not reproduce
> > Then bisect from for-wsamuel-base to for-wsamuel.
> >
> > Basically, that's the offending commit split into steps; let's try to figure
> > out what causes the breakage with better resolution...
> 
> Confirming that bisect points to this patch: 09e88dc22ea2 (serialize
> ffs_ep0_open() on ffs->mutex)

So we have something that does O_NDELAY opens of ep0 *and* does not retry on
EAGAIN?

How lovely...  Could you slap
	WARN_ON(ret == -EAGAIN);
right before that
	if (ret < 0)
		return ret;
in there and see which process is doing that?  Regression is a regression, 
odd userland or not, but I would like to see what is that userland actually
trying to do there.

*grumble*

IMO at that point we have two problems - one is how to avoid a revert of the
tail of tree-in-dcache series, another is how to deal with quite real
preexisting bugs in functionfs.

Another thing to try (not as a suggestion of a fix, just an attempt to figure
out how badly would the things break): in current mainline replace that
	ffs_mutex_lock(&ffs->mutex, file->f_flags & O_NONBLOCK)
in ffs_ep0_open() with
	ffs_mutex_lock(&ffs->mutex, false)
and see how badly do the things regress for userland.  Again, I'm not saying
that this is a fix - just trying to get some sense of what's the userland
is doing.

FWIW, it might make sense to try a lighter serialization in ffs_ep0_open() -
taking it there is due to the following scenario (assuming 6.18 or earlier):
ffs->state is FFS_DEACTIVATED.  ffs->opened is 0.  Two threads attempt to
open ep0.  Here's what happens prior to these patches:

static int ffs_ep0_open(struct inode *inode, struct file *file)
{
        struct ffs_data *ffs = inode->i_private;
 
        if (ffs->state == FFS_CLOSING)
                return -EBUSY;
 
        file->private_data = ffs;
        ffs_data_opened(ffs);

with
static void ffs_data_opened(struct ffs_data *ffs)
{
        refcount_inc(&ffs->ref);
        if (atomic_add_return(1, &ffs->opened) == 1 &&
                        ffs->state == FFS_DEACTIVATED) {
                ffs->state = FFS_CLOSING;
                ffs_data_reset(ffs);
        }
}

IOW, the sequence is
	if (state == FFS_CLOSING)
		return -EBUSY;
	n = atomic_add_return(1, &opened);
	if (n == 1 && state == FFS_DEACTIVATED) {
		state = FFS_CLOSING;
		ffs_data_reset();

See the race there?  If the second open() comes between the
increment of ffs->opened and setting the state to FFS_CLOSING,
it will *not* fail with EBUSY - it will proceed to return to
userland, while the first sucker is crawling through the work
in ffs_data_reset()/ffs_data_clear()/ffs_epfiles_destroy().

What's more, there's nothing to stop that second opener from
calling write() on the descriptor it got.  No exclusion there -
        ffs->state = FFS_READ_DESCRIPTORS;
        ffs->setup_state = FFS_NO_SETUP;
        ffs->flags = 0;
in ffs_data_reset() is *not* serialized against ffs_ep0_write().
Get preempted right after setting ->state and that write()
will go just fine, only to be surprised when the first thread
regains CPU and continues modifying the contents of *ffs
under whatever the second thread is doing.

That code obviously relies upon that kind of shit being prevented
by that -EBUSY logics in ep0 open() and that logics is obviously
racy as it is.  Note that other callers of ffs_data_reset() have
similar problem: ffs_func_set_alt(), for example has
        if (ffs->state == FFS_DEACTIVATED) {
                ffs->state = FFS_CLOSING;
                INIT_WORK(&ffs->reset_work, ffs_reset_work);
                schedule_work(&ffs->reset_work);
                return -ENODEV;
        }
again, with no exclusion.  Lose CPU just after seeing FFS_DEACTIVATED,
then have another thread open() the sucker and start going through
ffs_data_reset(), only to have us regain CPU and schedule this for
execution:
static void ffs_reset_work(struct work_struct *work)
{
        struct ffs_data *ffs = container_of(work,
                struct ffs_data, reset_work);
        ffs_data_reset(ffs);
}
IOW, stray ffs_data_reset() coming to surprise the opener who'd
just finished ffs_data_reset() during open(2) and proceeded to
write to the damn thing, etc.

That's obviously on the "how do we fix the preexisting bugs" side
of things, though - regression needs to be dealt with ASAP anyway.

