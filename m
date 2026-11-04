Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17923606D829
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DiXkLasn
Received: by kanga.kvack.org (Postfix)
	id 1B0506B05C6; Wed,  4 Nov 2026 14:04:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15FAC6B05C7; Wed,  4 Nov 2026 14:04:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0785F6B05C8; Wed,  4 Nov 2026 14:04:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CB1EA6B05C6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:04:42 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5A0891A083D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:04:42 +0000 (UTC)
X-FDA: 85398363204.24.45884BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id AFB9240006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:04:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DiXkLasn;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793819080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lAdqJZq7DckAfewXRPAVCUONZuQAofOCOPOWHFZTOPQ=;
	b=GhacGq2yAtO4yQyVJLIVNIQCQwrqLoEjBzyd8ll/h5IHm+ZXwC5eb3MYbYu4vmXD0KhLFo
	03GDfWhawrn+p1oXWpEB25IXjmt2O/SCuxep7g11qRXOK4bHqdPkv0crJUhRUpzyBAuIzK
	oOWlECHgq+5o5NFDHhnTcN5Ybe7XsDo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DiXkLasn;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793819080;
	b=3dXscrNorzzOengwLvgOuS4kpC4iv5NgccbEr60U5FOcO/LxtkoYt2//JBq1vPgYUfEpiv
	NS0AfRL2nDUJO8u7kux/WJEYmfoURRtdChhf06Ze1KGW1N3Q49gzHpl6tkpoUDNiAFZaqA
	fUab23NlGIjYqdFdfBxjDjk06Cu5DlU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2EC7360ABF;
	Wed,  4 Nov 2026 19:04:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED65F1F00A1A;
	Wed,  4 Nov 2026 19:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793819079;
	bh=lAdqJZq7DckAfewXRPAVCUONZuQAofOCOPOWHFZTOPQ=;
	h=From:To:Cc:Subject:Date;
	b=DiXkLasnKkCazgXjtl0yo39sGV+Bs41jy0U9vc9qazA5CkiKT/iBgZ8fEt5z2eEi9
	 oolsufKOcX9//0g1iNEISwDqdj0AJv/jYiRaklcfSgZPROKW3M/UHZ5YJlCQnarqEi
	 2HOIRavJO+g9paB/C2YYlAYVqmb2kgiut60CyfNdCFnL6BADsAW86gE+rCJv3jhKEU
	 xhyHkA5QFEeZxb/jz3ezU8fpueKF4UZ9OCtOjslPoDhqLrhjroAW4ZVXzKIkJz9Hyg
	 6s+UivkH9tasMyPtuGG54ILYcFnrqgSpO4qCMaV233B/QiysszNJThZr4+Y++vVfYT
	 4RJQDhDv+jwNQ==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jann Horn <jannh@google.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Chris Mason <mason@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Eric Dumazet <edumazet@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jonathan Corbet <corbet@lwn.net>,
	Christoph Hellwig <hch@lst.de>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Joel Granados <joel.granados@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jan Kara <jack@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	netdev@vger.kernel.org,
	ntfs3@lists.linux.dev,
	platform-driver-x86@vger.kernel.org,
	coreteam@netfilter.org,
	kexec@lists.infradead.org,
	linux-pci@vger.kernel.org,
	linux-sound@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	ibm-acpi-devel@lists.sourceforge.net,
	jfs-discussion@lists.sourceforge.net,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-mm@kvack.org,
	linux-sh@vger.kernel.org,
	linux-usb@vger.kernel.org,
	samba-technical@lists.samba.org,
	sparclinux@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-doc@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-atm-general@lists.sourceforge.net,
	Chuck Lever <chuck.lever@oracle.com>,
	Takashi Iwai <tiwai@suse.de>,
	linux-input@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-debuggers@vger.kernel.org
Subject: [PATCH RESEND v2 0/7] proc: move procfs to what kernfs does
Date: Wed,  4 Nov 2026 20:04:22 +0100
Message-ID: <20261104-work-procfs-v2-0-b45cd5789ac5@brauner>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=6699; i=brauner@kernel.org; h=from:subject:message-id; bh=vwrWu4QhJtoloSbOepgjr6FTno3vPTd4Ym/VDTikOkw=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bnTbzPPv56/PPZvrYp9W3z2QLB/JVrf+pVOeIXfyv BPyhavzOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACby9y8jQ7vUhZjCtt8GL9Re MV4waA022Jc6RTTePbMrWSRxcvj9NYwMH5UzLmm1J8flNhaGGEtmzxJlNtGal3R0vXBtFP/N2H5 GAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yjzkmrm6xnezuztutqfdpq53dig9ay95
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: AFB9240006
X-HE-Tag: 1793819080-233919
X-HE-Meta: U2FsdGVkX1+l4K42TGE7D1HIX53Be5rLpfKaKTQXB0De2/i2tn7kxgmEL1/tyjTaK381oMDxqM++/2rEEX3WahokNCBzawshADdXyp/t50/1SIoo8VOwRwch32aVIa1IYLL4tlflU5mmvyGF0ssf56w/0jnANbE57jWmt91JQdHRaaY0eUy9U+Q1u397C8VSE5OU8vcC9v5ZvyUCwnDINTUeGCJ4LbiGWtjN+dr/xyzR1CaWsnsdV+/LLhX4/v7kkkpafcqLN7rYSn4ThW/j8YW+Elz9Jb9TEBeetSAomTnW1N4AczngCirHl5X52r9JQhe+hv03FeysMfzvl3Vpww3737oVnta6I8twT0Yj11sMYlVmWu/IejyNZUkAJN/zne9QOdL1rivP+jEkjKRvie8byFMO+AfdLWyuMpSjgBxMhNXC6vZpFRCYHqrBfmq9Ly4FoTCdQQznhvF5mFPH4uwhA/vi9aePV2tNvZcrP90UsxoByKlduU16qryeADdo9t5a5Dl/YLDuRAymrKzBkmbLDB/PjHNFaArsCugrnFCVLUSWJJLZlMnyIchxFf0xWnyHfBpmbSh2Lo+14wzQ59dIDGya1qiD1ZdjhGyJ3bJ1xa8K8Y2IFZEeeUqBSXAdims4YdLNAvZ57HoGthnYF84AkxGFf2+dFx7GxZl5vwMeC3/p9Y9lEc2zaC7kOx1Wv6hj+CgVyFKMgTjh9ZSkG3xEB5pxI6quPGlmmgEcmPvHv7/olAOSe0S7XSzBuF+SKtIbTOx+Ko2Yapi5J34XOYjReoRHYXij50gUcGv1Jf6OdB99uSeQwINKOFw2ectK62BDkNAPywlxXauc7kelp1bJQupo8WaGi34YeRjV08rSovJb2bcRlM+5wp30ET0y5PDahFf7davkVhEncvYdeEEX72js6bTlF09lis4PkHHZ1hhBSmgK3CiOAsX7WX7/S1BOp3ZZ2A6sbLOf4kT
 3n0mllEk
 4y/vEETxfotmlKUarrV3NvvCGOEjwaLpvr1UOWbHER0IZQnkytsnH0+UgajoDrW+Du7BIgufsvg1FoF0oDsQTUzqrzXCauOoz8UOY128p84Bxgs5EvFt/xrvSjRdtZ07vW9B/v3z8VjShU7WYmf4hwD9sBVe3ralKY2/1FlZewfZxiec/P09vXAt533xSseLMN34vqmt5efzZi8Ei8CdBexH4dT/TDa2am2E0bHmO7HYxzcU923vO4lQB2M0RieVUIMW1/qbQ3wVf824k/85FGQ29+UCLphx3ZYxw93cGi2FA2aNlwcVk4jhiiJ4Q/siaxXGLE6vXDHo+HfDDTo1nbz73666mCmPzDTb6PB4iR+TDQD8e8U6/bvruHWzidVxiltNCpkp1OAHiNtvN2Hodc6aMRA86pqdhIY0mGHo72bjITDJkR92bMJaSJgctoDelImtC4tbC3PabjkHKmfUg4/uAcH9qSN/X7D5CPxaFLF5x5D0ORYh4XBMfQHgHjO2rgfpXtGMF7foC+xbOlE/GjdY1CZmA2B1nuEYjzOOXlp/OEvNodbhCUDcvra6fZZLyRWanFWGKWAcsErWMiW53Mxwo8HYqX1TKtTunTnNX/1HbBKEKnXc9ePvDgYRO9J8jyR3OeegPTrALlbcR5Q85bLv5DA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series aims to get rid of copying to and from userspace while pinning
procfs entries allowing userspace to delay removal as long as it wants.

In essence, it aligns procfs with what kernfs is already doing. That
gets rid of a big attack surface and a whole bug class in one go. The
bounce buffer will come with some costs but luckily some codepaths (like
readdir) have been so criminally slow and buggy that massaging them ends
up speeding things up or at least leaving them on par with mainline even
with a bounce buffer in the mix.

There was a hackish and very narrow AI solution to a small part of this
bug class which was sent off-list. In essence, it used a second
buffering mechanism on top of seqfiles which was really nasty. It also
didn't address any of the non-seqfile users.

If we want to get rid of the this whole bug class we need a bigger
hammer. That means reworking how procfs handles data. So I tried to work
through all of that. The series is now in a decent shape (I'm not saying
"glorious" as there's so so many warts. If they were ironed out it could
be a lot nicer but that's for another day.).

I understand it's big but I think it is nicer to be able to look at the
end result since we have some transitory states that are gone at the end
of the series.

I have polished this a bit more and have sorted out a few more bugs and
tried to clean up some codepaths given the current constraints. Again, I
think we could go a lot further there if we wanted to but I think that
blows this out of proportion and at some point it becomes difficult to
grasp the scope.

So, remove_proc_entry() waits until every call into the procfs entry has
returned. Most of those calls copy to or from userspace with the entry
pinned.

A reader or writer can induce a page fault in that copy take as long as
it wants. For example, with userfaultfd or by punching holes into a
memfd over and over. Plus, the callers of remove_proc_entry() like to
hold locks while they wait. For example, addrconf holds RTNL when it
removes /proc/net/dev_snmp6/<dev> and xt_hashlimit holds a mutex that
all network namespaces share.

So every network device with IPv6 gets a /proc/net/dev_snmp6/<dev> that
everyone can read, and addrconf_ifdown() removes it with RTNL held. So
any local user can keep RTNL for as long as their read stays stalled.
Until then no device can be registered, removed or renamed and no
network namespace can be created or torn down.

If the caller lacks privileges for userfaultfd a FUSE mount in a user
namespace whose daemon never answers is enough to stall the copy.
Killing the reader ends it, but until then whoever removes the file sits
in D state.

xt_hashlimit removes the proc file of a table with hashlimit_mutex
held. Every rule insert in every network namespace takes that mutex and
so does network namespace cleanup. cleanup_net() runs on a single
workqueue with pernet_ops_rwsem held, so a stalled reader also stops
every later network namespace teardown and every module load that
registers pernet operations. xt_recent does the same with recent_mutex.

And of course, it's not specific to networking. remove_proc_entry(),
proc_remove() and remove_proc_subtree() have over 200 callers and plenty
of them hold locks. For example, a stalled reader of
/proc/fs/ext4/<dev>/options holds up the unmount of that filesystem with
s_umount held, and every sync(2) with it. The same goes for PCI
hot-removal, for freeing IRQ descriptors, which CPU bring-up waits on,
and for unplugging a USB sound card.

And btw, syzbot has hit removal under locks before (cf. [1]), and the
xt_recent deadlock fixed in (1) below is another one.

Stalling the kernel in a copy to or from userspace is a well-known
exploitation primitive. It's why unprivileged userfaultfd can't do it
by default anymore since v5.11 (d0d4730ac2e4), and FUSE has been used
the same way.

This series touches just about every ->proc_read(), ->proc_write() and
->proc_ioctl() in the tree, so I've split it up into seven series. They
go out as replies to this mail:

Part 1/7: proc: fix a few old bugs in /proc handlers (51 patches)

    Bugs in the handlers and in procfs itself that are a lot older than
    the conversion and that reviewing it turned up. Most of them are for
    stable. They come first so they can go there on their own and the
    conversion doesn't have to bother with that crap.

Part 2/7: proc: let procfs own the data path (23 patches)

    The procfs side. procfs owns the seq_file of an entry, copies in
    writes, copies out reads and copies ioctl arguments in and out, and
    only calls into an entry with it pinned. The open files procfs has
    to know and the wait queue a pollable entry is polled on live in an
    open node that only those entries get, the entry is pinned around
    the vm_operations of its mappings, and lockdep checks the pin.
    proc_create_seq() and friends and the plain seq_file users are
    switched over here too.

Part 3/7: proc: convert the arch and platform entries (23 patches)
Part 4/7: proc: convert the driver entries (26 patches)
Part 5/7: proc: convert the fs, kernel and mm entries (30 patches)
Part 6/7: proc: convert the net entries and the kfifo samples (13 patches)

Part 7/7: proc: drop the __user methods (6 patches)

    Drops the old methods. kcore, kmsg and the kpage files, which are
    never removed and keep reading straight into userspace, get
    file_operations of their own, so nothing in struct proc_ops takes a
    __user pointer anymore, and the new methods get the names kernfs
    uses, ->proc_read(), ->proc_write() and ->proc_ioctl(). The last
    patch takes the poll_table away from ->proc_poll(). This needs all
    four conversion series.

Parts 1 and 2 are the base. Parts 3 to 6 go on top of part 2 in any
order and don't depend on each other. Part 7 needs all four.

The series should all indicate cleanly what dependencies they have so b4
should be able to pull it for review.

With all of it on a KASAN and lockdep kernel the removal selftests of
every part pass, the proc, pktgen and allocinfo selftests behave like
without it and the bugs from (1) that reproduce in a VM are gone. Every
patch builds on its own on x86_64 and i386, and with W=1 on the
architectures it touches.

[1]: https://lore.kernel.org/r/000000000000f24f4705b6988f3e@google.com
[2]: https://lore.kernel.org/r/20231109212251.213873-7-johannes@sipsolutions.net

---
Link to v1: https://patch.msgid.link/20261102-defizit-jobaussicht-kurios-7016c6e67442@brauner

-- 
Christian Brauner <brauner@kernel.org>

