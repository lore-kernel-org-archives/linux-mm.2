Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E51B606BA03
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NswRMcqB
Received: by kanga.kvack.org (Postfix)
	id 616506B05D2; Wed,  4 Nov 2026 14:22:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C68C6B05D3; Wed,  4 Nov 2026 14:22:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48EC86B05D4; Wed,  4 Nov 2026 14:22:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2953B6B05D2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:22:08 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 54B4B140840
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:22:07 +0000 (UTC)
X-FDA: 85398407094.30.61ED944
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 93C6E4000D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:22:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NswRMcqB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E1vD3O9CKVYh6HjmlrAgiThE5xPMlSXjct4LkBIJ4ZU=;
	b=ZCLVIIRN0F6Rs4PwxYcOyrW2tPmoRNKzwA/9ZpMIFRzB19t7qFqr77zhgChiyLX2gObpKn
	QIJfUwXaUsU/8xh18fZOuJDfl90Zzg4SfNhZFLVfV05UePlYV3GgggMWLTyQnNqjhVgKf5
	v1miAwXurYBQbGlJ6AAJye3v6o4DGo8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820125;
	b=XeACQrHm1umiDJ9Z+o6TF3g0c5VWp4R7Zm0fbdjN9eVf18ZrNLPuAbHmtk7m6fmxZmFyZc
	LfO1lSTL9MCb7nhqYfynMSqo6wW0RYDjz7fGDQLTYrKkwnq7o5lurlO90UnFx6AbF/LXxM
	/qEhoBMCgp+qrP87t6Pc3LpohbD+Lxw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NswRMcqB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2CF7260BFB;
	Wed,  4 Nov 2026 19:22:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87571F000C1;
	Wed,  4 Nov 2026 19:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820124;
	bh=E1vD3O9CKVYh6HjmlrAgiThE5xPMlSXjct4LkBIJ4ZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NswRMcqBfCW7Yx+oHzm7X7x3Vx4jEKmXruK32+U47DYkhN6rM/lfoH6AjN/SxL36f
	 PgY3FjroHKYvb5ZucZtjjxfeMesHu2aiCu42BfFriOzz2a4zJcMYsY+q/uNY/jVlJJ
	 mQbA97oSkcIOHIdNHKCmo9rGnj+/+FM6G0eHvq02j3TpFo9jYjkaTorhB3ZPVCn8O/
	 KrKgum+HPtAyA1T4+n9pWNsjQ+Y0I7sn0Fwghzv5FJeoW2kBqDX6BHChClQ+D48khG
	 NOJNO5qh2fzt0fT/JulzaUiqzxtJvpPURLPvwRRXNWlyCu69pQW8Kq49mWs0Mw5ust
	 pZrAkn/r9fpNg==
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
Subject: [PATCH RESEND v2 24/51] scsi: ips: don't return 0 from writes to the proc file
Date: Wed,  4 Nov 2026 20:21:50 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-24-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=745; i=brauner@kernel.org; h=from:subject:message-id; bh=M56s+R4IzmhMvI79F+bEsnRzyAX8hD//ktSOts+7Usw=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bnzxmUHw2l7pkLsqhYUfQu3abymsV/u8xrZmTWDq2 g3r1DVfdZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEyko5aR4VlF9Y6Ezj35Scu2 1YjO/m7UtL24teDezKI9Ly4oZn88c5fhv8cv7zNNOrwr0iK6hZPXPQ1f+pT5o1tFzHcBAQ/F8yd /cAIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y85zrsrkqnejqsfpaw9wsinxs44my5r6
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 93C6E4000D
X-HE-Tag: 1793820125-627634
X-HE-Meta: U2FsdGVkX19cQ3ygA2U70sHXZ03Ix4pMLtac2alQk7FwrKbVLpdLoWfSisgqUQdQnOYVzBECev1ZliK7b4qbnFa9/8UtJKnsPPAxlU7LtL7LXEn7hhF+vS9J2h2TdzZVepn57VQKdqn3xXXVNIfgOiOltF44WBioB189xJT8E7VaUMO61jF4wpyV5P4PumTFbw11iVrNeAN42g30P+iGjI/pU+rCCL3gpEAiGBuE9RNENsXGaQFQeGmUjiBLaPcZVIdPU/bFKiiTfnAfnWzx8rhrf3WfVsT8As+EoV8ELX7jToXdvLkxBGqLgkM+TjCtA1ovKYTm6HwbMPb+dluIdbQrqlsN0QBDBCNs6fsszcC5j89fuygwujI5ttlE6ZNTKplu6kbcqdDI012GyTroCRwdqcUWhSAL9mJYN242q1/BjRD/dIj+AHscIEskxmgx9fJQ/7KOQPLKDZ+I3y7EIVBstGsUScwFfGM+MYFfw+JZbPKlDS7cIAdH6q6Bkb5dtnIo9a6R0TT77+E3H9tp+gRz5aVDjYm0vCpp25ftSfbIiOsb3zZa1qfoeZuESm4nV1KryVSNXNsGHW3EjYBEWDFAILFgrTz1Z7iAO175tQWgLsu0KZ3LQL35EO4LDld1BRu/F5vLPdtwmxktlSXOISzBr3puo0HDAY8/qaZwu7q4bhzReW7+SqThmL5TPuljhbIk8HduMELpxXIgeb+Q9Ds79KhSmNPqRlOdpAQ+YUWt3oRPYfx/0MgaycGVmitThXvtPmZ+b9LIcWHMO0wI1B18YtgrGPB10NI+uCI2SVxyy3tBu5mQy0AiLZqZMwZzJ1GYpExYkS6Go7El8cEg8ur1VxWVbz3uw/BulgNTXOezdHqfkSf3ozn7aeb6OR1i8+Q4nR5SO8WfIeeUlCoM5bTUnVEaV67VPj18yBGg2B/NKIGw8wAkj3ihmrB60uLOSidOKitv3EpIx0M4Uo5
 HoHoAOlG
 T7c3TsdRVmKpUeOzp+jSD8NAcOJ4SDnRuQ1mzVauuAXWuMlUguUZYjU4ZfAFRnSJnLZMV/sNa3iWiz3m2DovzlCJkT1VfeCUCyJTTGT/E53j0AsEhgEvp2dC0R+LObKGr3x+vTCzIlxdmueRGMcigOaa0G46R18KsQ1y0kJNiSfC9FuC5kVbEQ4W93fVtRy4uShrrRSAo94lhwTCLb7Czcwoxh8EPakiAHMWXw+9mn41Jlq622+JCN4s/hooCMj1irZbN+YOa6LwHno3nEmlyWYtQr2c7LiOXGKz1fz+BrEqIHVQ+O+zNm8syxJojaqkzZBvaN/H3N62C1uCvwrorGNsTsUJvD/8t7dbfmVxFKmPGrep9P5F8IcsIzY2nEEP+FhylM2GbHPVqDv/X/NQSxd1XNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ips_write_info() ignores what is written to /proc/scsi/ips/<n> and
returns 0. Writers that use stdio, echo for example, take that as no
progress and retry forever. Return the number of bytes that were
written.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/scsi/ips.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index c7d6c5aae340..85c4fb164743 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -1428,7 +1428,7 @@ ips_write_info(struct Scsi_Host *host, char *buffer, int length)
 	if (!ha)
 		return (-EINVAL);
 
-	return 0;
+	return length;
 }
 
 static int

-- 
2.53.0


