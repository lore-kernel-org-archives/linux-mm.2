Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECE87607816A
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aKP7JyYG
Received: by kanga.kvack.org (Postfix)
	id 211316B05E2; Wed,  4 Nov 2026 14:56:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C21D6B05E3; Wed,  4 Nov 2026 14:56:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08B496B05E4; Wed,  4 Nov 2026 14:56:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D96A36B05E2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:56:35 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5A48280855
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:56:35 +0000 (UTC)
X-FDA: 85398493950.02.C592F87
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id A2B3340007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:56:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aKP7JyYG;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793822193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LBl2/qBMA7OV4BMTYua5kVHXByvRuxQ8RJbkH2xlEeQ=;
	b=CgeqyrVxK7jrJ9QT/vHFQgoPZWuPfHPOCNUNLziYVRwkpWF0kZm7T3WPl/uLaMLHCta/qH
	7FGeMRB+COaRyrAezF/n2+eGuUcKcROL7V1599edLK4Ukv+b1UZkZxYsH8G74DwULmRPjT
	WdtdIqZQzq6wIRMTjtmVDfWBwkSztyQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793822193;
	b=Ur9YKqtgwjPnyEFmdcVkgQGORMwYm8mg2+XDcbe7ny/W1gV/ZKWdZP3JZy8hizkjSkGouw
	lt0wXxic9xaaZD9cPJ1plg1roL9a634IVWa3etsTNI7TUZWGy4cbaUqEQTGR9NbJCyK+ui
	Mcp4dMDQLKjP/J5xrOyP0ZnRwdbVZEs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aKP7JyYG;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3A74160F1B;
	Wed,  4 Nov 2026 19:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86BA1F000C1;
	Wed,  4 Nov 2026 19:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793822192;
	bh=LBl2/qBMA7OV4BMTYua5kVHXByvRuxQ8RJbkH2xlEeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aKP7JyYGkDXXcZgiOMyJDOMnJ3YKXipcdyKMOhnZ/kDushdocc5j2aUosHVgdFjuG
	 W8NqrAjXIVJtlk3D6BRdnDPijmdfnyH55xY4/5GIe8B7ijNhQWuqM7VHbGTChu/S5p
	 bjawb6WUZLBB8pnefyGL4zorD4j/72K+4RlaEoOxwLWCBU80eFeiO+LKNoVR3cDXsM
	 3PJy33mjWSy8B1p5T5flpR5Cr9VBJtwZuxs51UHe1Pt2cbGiY3/+T4y9EH9bSAjyVG
	 E7eQOJVTxndTF1qhOS06r3zzRaWFs4kd9ALYhL3GOdUn4eRB1X31/INX4f8HZSXd4y
	 I59kxqMTzVXsw==
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
	Chuck Lever <cel@kernel.org>
Subject: [PATCH RESEND v2 27/30] mm/swapfile: let procfs own the seq_file of /proc/swaps
Date: Wed,  4 Nov 2026 20:56:18 +0100
Message-ID: <20261104-work-procfs-fs-v2-27-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1169; i=brauner@kernel.org; h=from:subject:message-id; bh=xP8svTINdkdtOq03sFDyUkKM00LKGtRsGg97ENBLGtM=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97vHhXJd8Kth7+zWufRt8tZu59658dXe75H+F8xvTV ml+XhRg2lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRqbMZ/kps+sao8ittxlXf /G8XPGKtjMsDSyLXBR7ut+jjuGbTHMHwP7A9pOPMY4eI2fw/JsV8unzukJPgecs1+ql+y/k/6SR 1sAAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: p3ryfo851t8owx8y3fqutfh7nc4giegn
X-Rspamd-Queue-Id: A2B3340007
X-Rspam-User: 
X-HE-Tag: 1793822193-801359
X-HE-Meta: U2FsdGVkX19jIAUR7A3bhFrxyCiPa74ae001N5cyfaR90ce/dyRORcayVKnJ7Ndg7MBmVgKuuw0I0Z8CV7dgequhAHjhrmBW6KJ5CGrHrWi/e8DP1I95DJXNe6FlvjLA+nxhB/cQrxbeXyrhid7aVnJVE39uBVlz3jHNTLYTYmsrcjxF5ThDus83E916vSoXEUH9jY4vpibOKCD92JB8O5mRDhjsbCrreHJ7nDd5Y6sWD4hAM7qbDnj0vp12yDrntVGxUeQ7wBug6QsDgKbA43jaNOg1ebzlasr5QJ2yU8sVnzc3J7y603xp5RCMpIyyfNgC7D45yuX14q9+EwS9yDpv5cHAiplfFthpm2vZHQ/1WtKoCpLg4t+J0RJQ6ZLocict2Zvxqwq/nGaZ1GrDX82Kvln6ydmoviJdQwNwL/KEdEdaHE4g4PvLEHRDFjdqgNVwUw679XCzSpw+FivvxljWnITSzJ58vVKSK7zQLPcrVSx6HjO7kuisl+pnQM1sfOjK1wNpA/wY5V4H1jWWSjepVeveVDOIE6Aod/99oR6Eo6/mPlWfM6ZcmOcoyTf8Ec5k6RLXHtN+NG+odqJ9YSlw6ODCVmeAl6t6G2PCFGINjR0BIqR1vY9c2jGczFWIPFnKXlLW/grMMgkiDA2ak7QudEj4qjo/3jx23qFkeC150kajEUPtK+XvVYE0u5mi7E81ydbCmpLdybHuTi4e05i5Vf+qnnA+H0yTnVLzPV0cbjiVBk2GWfJ/8cXHGHaWQhY0eYTWHk0TVvYWCVof/bkHTj/m1Djmbn85aRIY9XpT5YwEv+stnkN5+XzipmwLSvdyskWTvGx1WrsscnPFMO3Bduv4ipjRvNc74WK2K7j/eSVGsdGezewWekhgTQFq22mIJP9ebLk6oBdBI94tt9ncL0oir8r6yIDoc6PEE+okPjckxg4gTNgTzC1fBWPt2aiBgbqi7n5YiGTdQl/
 Xz8qOuKB
 l+xuOmA5NXPSY+ZomTZx/bFV8m4Zs3t+ry7NNBprqKUqXugz6ybKr6rjn6HVYrRjFmBYVWD1A1FrS0VMQdCGUSv1hewuFqdgXlSPGoGvx4JJi+l52uadG2yOJ+jX8TCb+zWXstrIr4oEGOLUT8SPYnt56qLZ3KKSa2KwvPkn9sFcZQPmuK9kOK3Hx9th2upT6GoArwYWE3MAkUdNX2iYEDPtDr5YfF5EmPHDaPEJ1anAuDAlzDnWa0urY1w4v3qh3yaHMktylFGvTx1KZJAOhD9NjanAPQa8mGaLg229xXKf75Zgts9NJ+7EzFrnErnPzHEq1sqCK0TCZ6JH8Kqbb3anRe0fzlpZQPh1lqYl8WZx/W8+rnJyT2qLqCg7KVnK5fdXkllGJu3qJQ92ixx+wnIMnqjmIyDP2mrNs8Nx81ewebOXW97hvmVQ5yWWMp743peoe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Declare the seq_operations and let procfs open and free the seq_file.
->proc_open() only records the event count for ->proc_poll() now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 mm/swapfile.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 254ce86fa923..ee4868ecc3a7 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3410,26 +3410,19 @@ static const struct seq_operations swaps_op = {
 	.show =		swap_show
 };
 
+/* procfs opens the seq_file */
 static int swaps_open(struct inode *inode, struct file *file)
 {
-	struct seq_file *seq;
-	int ret;
-
-	ret = seq_open(file, &swaps_op);
-	if (ret)
-		return ret;
+	struct seq_file *seq = file->private_data;
 
-	seq = file->private_data;
 	seq->poll_event = atomic_read(&proc_poll_event);
 	return 0;
 }
 
 static const struct proc_ops swaps_proc_ops = {
 	.proc_flags	= PROC_ENTRY_PERMANENT,
+	.proc_seq_ops	= &swaps_op,
 	.proc_open	= swaps_open,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
-	.proc_release	= seq_release,
 	.proc_poll	= swaps_poll,
 };
 

-- 
2.53.0


