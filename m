Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77CC8606EEB1
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jRm+kuQX
Received: by kanga.kvack.org (Postfix)
	id 6C52B6B05B4; Wed,  4 Nov 2026 12:48:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69CB06B05B5; Wed,  4 Nov 2026 12:48:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B2B86B05B6; Wed,  4 Nov 2026 12:48:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 247226B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:48:29 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 90BEB160808
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:48:28 +0000 (UTC)
X-FDA: 85398171096.26.CF96F9A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id D909D14000B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:48:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jRm+kuQX;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793814506;
	b=2FPbrUPgjK+eoRy2utpxnS9zxBI5lILMz6pnv6teSfQIe5ClJWwecvgAPyDj5mVNdgF3yK
	3pOl6wkR0Fpt1YGcED5p1rHLuTo2RMHnVQllcGZ7/vJanzYVDZh8RpZpz+EkUupR0NwQ4R
	UuUa/sJMVQZncftljnIf0buo6gpMhVs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jRm+kuQX;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793814506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ZyIQLij17XFBIkY/FnNnjbp2RgAs/rkMBTgRuVD6WA=;
	b=tb0UrZkQY+SY3Ax1+0/Rfee0ZW5Qu69esVBQnrHE1We7BvmKRzZoeywP0aZEKwWqJOshjl
	PbduWMshq7rkvocx623yFLNC9MwloxCHji/NfP8+MuOCrAH0ROeBbHZKxwx1AoDA7J9EXw
	51pe5EuimpY30cVPSd1IykYxSZl5KgQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7438560A58;
	Wed,  4 Nov 2026 17:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512051F000C1;
	Wed,  4 Nov 2026 17:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793814506;
	bh=3ZyIQLij17XFBIkY/FnNnjbp2RgAs/rkMBTgRuVD6WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jRm+kuQXLx3HxqJQ/pjoWlYGnOb5R2cVrI0BxZjs1H9Bw8isgylYtekF6fzwCYam0
	 GpULB5lXQbyTK/Edh9b2eC4kps+uu7bCEsyidT0bHm7H2HfmOVOP/JWR98p8XKggDV
	 gbR+sBOa4/o7t63orB3vACnwFADp+bNRfAOdtU2Yc/wWPiuGQBbek9DZxI+EgwmNgG
	 KWLc3uoF26LdC4oCj9qcMJD06sucvBwbhfn2X8BjLVTXyfWCytbRIvS8esUEF/ocEj
	 eFEobff+fM/wQhcYScZQ5sJRBVHN2AlsYRDXbqaRDoezJ+0bPS0RQxOsMA9AvIN8D2
	 a7u52gum9t5KQ==
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
	Takashi Iwai <tiwai@suse.de>,
	linux-input@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v2 14/51] proc: sysctl: don't stop readdir at an entry that is being unregistered
Date: Wed,  4 Nov 2026 18:47:00 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-14-bbf7d5546809@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1722; i=brauner@kernel.org; h=from:subject:message-id; bh=6hLGzd3ohIjIvoG2NrLKRAR6DerSlran3UFG44ON0F0=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9zrvAWu/kaD6x96PK3okTN85e99fjn1Pl3U3bGJtnN F1XMW6+3lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRfk9GhqVlT3f9k3gTlZE2 2Sl7qnRP89Frq6PEfR/pxi6YuOo16wdGhrWT5lf5PEid/zYw+uqn/MXSBi/y5i736erf2r1Ls/F ABg8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: op6ghxnoyi16ts5yffyudap54oogipir
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D909D14000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793814506-950683
X-HE-Meta: U2FsdGVkX1/2LsC+DgIy3D4pIr764ID3f9rZE1r2g5eJvDFfe+1Qjp5Y7c6VSPKG76yzxtDINAFdnS7SRsT9T4Xp9CfNf0+AenDbD6vP666sKeZ8YEauPPkLhFerk1HZwqcA7FCc9CyjnaOPy9SKf2rpCA7lPmS3SbcgHHOEE+k/0uycOv0q9fMgWJdrBw/AI6sAGZaHf0pHV7s7WeAKGrUjSjVTYE/iF95UQ0w37dfshESHp5Hst5yjF9aSUamJM6NbmyrM0Jzy4XkGKRm1cX0dU6hZbPQoPsghGpURYBEZxWStKJ0lVbj4qGZhrKkBmkjXbaQZ5BqxSpYGmU3eF94ocO8reIJElJCd3grDN0SLBQX3ISnOG+beqabFFGkRSJs+15uk3B0WcruhkGdwbHxxteIhOj+27b1OFvUWyzk/yG7R2ZecRyAz9qY+XhUUkz+rcpW8wOrs/GAL/Db/m1gBH7NBo/kRAUw3MXLG7tflozyuhPVG+5BWXPvOh6KJ6m68BWlGU5h01X5oLd7Rdq8CF489SSSOexzCtzOp1po4LnTpdE9abxTtYc8e2SUUqBeIgIdXGH0RPvJFsWvTlr824AUE7/Q4Oie+PC94kCKpaKrRwmHLyyiFCJNjkyFvQTdPE18RnMOa4d67qagDXMufZ1+OPrLFVA/kyWO/cN60zvEKZBtARUoDqK+AYW6cOWOQelPBGS9hEfGECg7ohZvTjpV7qoj2RZ61guf/YB1arbvBPQ5Q5Vpg3lTwmD+fqiX+RsLHVoVH5CZh0EaPTQCMGUHhZEFNfM57Ip1VflM9vdpo4MWTXVDFT0gJDepDnyq6xsEMjrh3lhUbbl+NRqhCd2Sz1F3qXEU4OMsegtDHkvydcLpTaxZhCHj0XdBC8lBdhfSJFdKkCLwMafAgfzcCa+Fqn1jFYdvlJsV6brXnVXaf7+n08ojxszM15Hj/tUXO4YaTZ6xGINUaTAZ
 Shwe24KV
 DpaawpZDen3nlhpBy11kqH8SPpcw6AkM5wEZ9GXdNVF3nCO/bGS6RSfXoeMBQRzAnh/HCGtQa4dVM8vPZCpfGm+j5GN4eWWN6P2159D2CETMjgKwyfYzEYm8//xyzvopgFgJW2BoNX9aL3uKPnVispwRmii0Xh/Tt9C5IX4wQpxjraYtcoqb9yTJBMmwkEUvfSrVcUM/iRFYBjRhwBCbzYnA+iKN40EGpgZ3gq1VSWZwHRaGkQC4UHuIQFZhZ/O+YjSKyM24che8oYAJn/14fRJ6FW0Wn+HyQIrInGIT6HNFsuQCer2cxUYeWrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

proc_sys_fill_cache() creates the inode of an entry that has no dentry
yet. Since ace0c791e6c3 ("proc/sysctl: Don't grab i_lock under
sysctl_lock.") proc_sys_make_inode() refuses to do that once the table
is being unregistered and fails with -ENOENT. readdir takes every table
it lists into use and unregister_sysctl_table() marks the table as
being unregistered before it waits for readdir to let go of it. So an
entry that is unregistered right then makes proc_sys_fill_cache() fail,
proc_sys_readdir() stops there and returns 0. If that getdents64() call
hadn't emitted anything before that entry userspace sees the end of the
directory and never gets the entries behind it. A listing of
/proc/sys/net/ipv6/conf can end early that way while a device goes
away.

So skip an entry whose table is being unregistered, like readdir
already skips a link it can't follow. Lookup treats such an entry as
gone too since ea5751ccd665 ("proc/sysctl: don't return ENOMEM on
lookup when a table is unregistering").

Fixes: ace0c791e6c3 ("proc/sysctl: Don't grab i_lock under sysctl_lock.")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/proc_sysctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 6c0859c66563..b4a309d49698 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -704,6 +704,9 @@ static bool proc_sys_fill_cache(struct file *file,
 			if (unlikely(res)) {
 				dput(child);
 
+				/* skip an entry whose table is being unregistered */
+				if (res == ERR_PTR(-ENOENT))
+					return true;
 				if (IS_ERR(res))
 					return false;
 

-- 
2.53.0


