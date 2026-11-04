Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D575F60AFC6D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LE2xhvlf
Received: by kanga.kvack.org (Postfix)
	id EBE4A6B05B7; Wed,  4 Nov 2026 14:36:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6E516B05D5; Wed,  4 Nov 2026 14:36:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D346D6B05E0; Wed,  4 Nov 2026 14:36:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AAE516B05B7
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:36:38 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 501C6140836
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:36:38 +0000 (UTC)
X-FDA: 85398443676.25.68EBBC8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7BC064000E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:36:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LE2xhvlf;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pQQ1Vs9Ggdq4tGJpsZZ2KAKh5WKICEOKhSgV+25xKrE=;
	b=BsJMYKRsbFRLCwqUunY1HE8hEd/sxL3/qnsIzTd4lHY9ezM15gYPhum5CvBP0hAwBXKSaQ
	sKU3k8GUIgA9A8WuG9mqjnG3hGWELKXSgpTEO9SeiogBVw+bZEWjY21CooDu8eYSxXijkO
	0ycbCl7YrF09Vu6+mHEBZZYCLHthG74=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820996;
	b=u2q0ey117LeLOku32P2FNGWVMKUguQL8tRqyD6fNSdNlReh3h9ktWBtWDVn7HbyrUjk+Ub
	vPfr/YyLvi/h2bGNqMSMFSoKbjj7ojzUySq5TVvy+xk8HKq4wDIJW87eGfZhiGU90sH79k
	onOzo9jw7Be6Nl0PVDKKNyt6h3HFlgk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LE2xhvlf;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C0A3A43C5E;
	Wed,  4 Nov 2026 19:36:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6AC1F00A17;
	Wed,  4 Nov 2026 19:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820995;
	bh=pQQ1Vs9Ggdq4tGJpsZZ2KAKh5WKICEOKhSgV+25xKrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LE2xhvlfg0ggjtQBi7k/yBWe0FPcdQ+k5fjG+wAjpCj+7mLg+pQWGjB8uBtCBJNXU
	 1hm3hiNz0BzNx64SJ+0v+umYt/gvnmwmjNeM7eZmZjkMKK3r7ZsY2rCE/cB6Vuoyyh
	 hIm4cNe2e5X+iWpnmRoQvIMbMtlTbV9ryhFiKp2B2qAh/B+heLylm9TXu09jUtvetc
	 89Djht6RVz/zMTf2pNKVsSpvsCd9UrC3EC7He4FCRXcjO86xQhz9K0fnAZaQmRvf1V
	 LQvwsJ7brRbuX4lwrdJ3+wt3Lk3D3kEIgaBKvZYk9sv9eiUC/NwIjt9LAfL6Wez6nR
	 7HlhFAAkWGJPA==
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
Subject: [PATCH RESEND v2 03/23] ARM: atags: let procfs copy out reads of /proc/atags
Date: Wed,  4 Nov 2026 20:36:21 +0100
Message-ID: <20261104-work-procfs-arch-v2-3-2aeb952c9597@kernel.org>
In-Reply-To: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
References: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1063; i=brauner@kernel.org; h=from:subject:message-id; bh=T/gtJK8LVC1DZFUM73wYroC67tSKwFUXW93lvLyJ5ro=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97vgw51B0y7b3epsi2Y5kbPn1fPGCaewfFUu+1k53Z JidtfhtX0cpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEOMsY/odG5F5OSDr8hjPk wnRp9d45CfqTm+89/PDpwqGEq92fBBoYGf4+yNE6FyxcodQt3qaa4nQ2ZtEpUeWA3P6OmgtKL/Z zswMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i1bhbir1ouzqs9bq1897mz1u3j8hdn44
X-Rspamd-Queue-Id: 7BC064000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793820996-149303
X-HE-Meta: U2FsdGVkX1/y9jx2XuLMNVATgyWMlitT6xo44L1wg7iSV0Ini54F3VyF6lc+VrSdQM+/Zznj8BmVx+/RhikD2ZvlZaF93HkHGycLCr5ZAcH3N6AT2iKS2RH6niwgKn/GFZTsekbmijTalZ1UADgY3dAnAg16vzhJuHdtkaMtvMgHlYp9AQyh46i39mlDSTuI7YyHaewe5tCUBrIgvDTOVGQXhBdYWLxPQHinFpQ3Zwl77/WTGbmf7UkeFiVhJFAWFvbSDJhznY52dXmBDPqSnPrPsuO0Bl3670C1WTyD1UO/OD/sLCY6/U3Ijt2/QXUkT37bI+tBK8gz6mcubrqKMSQUUd8qOLrkKQxnxKalpRx+GXWl0j9/osi/DZNyX2BEP6gAagO8KltgJYAcB+V0cT2rSPCMlnJHq0T3T3WTTN7KRngaBxSU61fLu7un7XTop/GDywj45HuXlv1HhalHi8ylvqJE/jOkJ7fGk3R7DCYBAWiBEnkZv/FxQBRpQznghW4wahYNJimNByZ/jTCtTVDkj9YPnVqFQInGx1BrxosRlVqjYQ6MMwLSqRRFQW+PcS42ZWvLLdhh596If9ZUEsaLaJiM7oY1ST92tAuo/ZaXOJ8ojMH+v7qkuwNHnmDNph9YL6w+nKS9zoPWas76MgNrN63Mr+kpqe3Plzk5sii1YXTaun0YiFslTIjqNlWCTvw39ux9LeQTEfrW4OgJ3OZSJV7zHwyVunn2gpvpdTq+2RN3FQuzlLPo6xZSDfHBUK2E8RLGEsjR6FN97KxqzAmLmqwEGnIezvgAwPuz8VXmCt9M/qTj1k9tS2fmzjrYXUIyG5aG5W3y3kHerTu31DXBA4FOe9f9vCVufeVDz9+lhJqNMWk8QeWiyb+wMe2WE0Gw05nNKdj5LS+oEp4KBklGnA5VUnlvdvprJW45S8yQf84xkWPTpAtLr/4jFyK8C6blniqCqk3J4Pm4aWX
 dE1Z9SI+
 orUtaSkkVlb2fzGHb+WLlRDFgY7UlgF2ChwzEQ1tzn3dMM5+6TX+Vsf7N2Ah3UcuZ/3ZZZ8hBU5lGJlVRIbbZA61avhkbGNpMUYyqsM4YY3dMaihc52yd3GXqVY1WfPijBF4uRS6WnbSwrm3QbZKDAbV/yLcjqNxdSa+iqzjirLHIvP+SZInjWb3PcGL6IGWxH2SE7pqhG+P11iFYMStgi4Gsffq88qKWh8ZrUZFZyY384qk6GuRPKzz5LnsUlGMxl4jVpPapVd3+MVMUszXii+9Cd3rodd5CIEOtAQWwmbcpJloFeg8CVYKa8OC3LyaYfLfseyCNaKkQlhYP8bcChbBEZqaqd1sXn/Fk4uhmskmUV8j6QUS8FnyLsnMbUKWBcDTLkMdmcvIccsNx9xV2EmA3eg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_read_buf() so procfs copies what is read to userspace
after it unpinned the entry.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/arm/kernel/atags_proc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/atags_proc.c b/arch/arm/kernel/atags_proc.c
index 8411fbfbcb8b..ff28bf24dd30 100644
--- a/arch/arm/kernel/atags_proc.c
+++ b/arch/arm/kernel/atags_proc.c
@@ -10,15 +10,15 @@ struct buffer {
 	char data[] __counted_by(size);
 };
 
-static ssize_t atags_read(struct file *file, char __user *buf,
+static ssize_t atags_read(struct file *file, char *buf,
 			  size_t count, loff_t *ppos)
 {
 	struct buffer *b = pde_data(file_inode(file));
-	return simple_read_from_buffer(buf, count, ppos, b->data, b->size);
+	return memory_read_from_buffer(buf, count, ppos, b->data, b->size);
 }
 
 static const struct proc_ops atags_proc_ops = {
-	.proc_read	= atags_read,
+	.proc_read_buf	= atags_read,
 	.proc_lseek	= default_llseek,
 };
 

-- 
2.53.0


