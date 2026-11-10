Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94F0B6070FF3
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oIOs/EM+
Received: by kanga.kvack.org (Postfix)
	id AAEAC6B05C5; Tue, 10 Nov 2026 04:17:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A86166B05C6; Tue, 10 Nov 2026 04:17:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99C006B05C7; Tue, 10 Nov 2026 04:17:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 75A456B05C5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:17:16 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0C7FB120414
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:17:16 +0000 (UTC)
X-FDA: 85418655672.01.D817598
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 800CC40003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:17:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="oIOs/EM+";
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Aeiu3UyUCzSAfqYn5Q8bZyz+wYYebjsNU8IIX+ZzMDg=;
	b=Ec+hmznHmAJj7rMwamJVV/UvdqiDGg5nwct0hvR+mU+bTZVLh8AIsDa+YP2Hm/2I2ULPny
	35+1TQcqPocLtQciuKRs8y1pGJVZC3+Q6y4Mum1dONC3gVI/vvu0pEBsGedJ1TNRg83BXt
	494X6IqVGK9sNb51nQ6gTej8lqNKw/o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302233;
	b=l0WLTYuLJ8Bq18D5ioRAVbQ3McGEYGlHXI5QE12CqxTe5P+leKoLcdA4DZkgOi3qfxc78b
	cmYMS9aq6Urjrj+8/YN6dpsEFKdkvv2mVa5SASH0CPliYBgetyGZrf7VYrs5bMLN7N46cG
	XC60B+vTXyXnYe2bX41feJ1Kkdn+jV4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="oIOs/EM+";
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E24963804;
	Tue, 10 Nov 2026 09:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A3D61F008A2;
	Tue, 10 Nov 2026 09:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302232;
	bh=Aeiu3UyUCzSAfqYn5Q8bZyz+wYYebjsNU8IIX+ZzMDg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oIOs/EM+KXYJ1grlTivKYR/ku8jTJ0m+cIlI+pG3YVNmGlTgU+6mJXjsBjanfGWq1
	 8T4XFq0QNRg8zsAR7ESB+aTONXWP2FVgpzDjvL9j6/UuounNAWxRDH5vAS4BK+FriA
	 AfJ2mWd7w+XhNvm479SKkBvm8bw9ZW4l45/S/N6hJoGcFILfLfz/Qcj/WnSIAKKHlR
	 aZu74imaFzIlgEUKmwdk+yZz0BxAbckL3QBgudLh+hdwVCHz4VM3nz2NTqfxr8RO87
	 0wJDp5SY816Gwv6wS5IRgzFg66syGlemxNOlITSZvr+VV0w4yn0U9xfFOWxx2iUo1Q
	 ypT2aD1Wz0XJQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:27 +0100
Subject: [PATCH RFC 11/41] failfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-11-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
In-Reply-To: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-mm@kvack.org, bpf@vger.kernel.org, 
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, 
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, 
 linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=879; i=brauner@kernel.org;
 h=from:subject:message-id; bh=jMBLnsAt3YLGCzcD1+vp96riKCztRaww7Mw52ZY6Vqk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erDgSsTlaLm0BaZPb2g9zFBdk3jqJpvVSZWp6w78u
 SDN++zJ2Y5SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJ6BQy/M9iFhSuKGdsOHT4
 K5PvuWfptRIcgVqXrHXW3VP44fKMUYvhn/I1R41K+fPTD11o4sx5ED/hfMxLg0sltflhfgn7d1b
 yMQAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ghxchfyhx1nuwt3kzacepu1yrrrw656p
X-Rspamd-Queue-Id: 800CC40003
X-Rspam-User: 
X-HE-Tag: 1794302233-383412
X-HE-Meta: U2FsdGVkX19roebITLrhqiDW6Sbgv0TxRgmC+7ZX2Gmaj5vPO5/eukC1dcf1HGY/8Jeaw0gamW6KrKD7PM4KeVT8GWgSrfjlIm3fkob3gvesA2OIEzKhfsPa6PYfiYsbHU4s+xqPTN0PiWVJ1/0asDk/qH7wwA4x/x2Ue1il+sIfMV0CY5n+njoYqzjHBniPf169NF6ooQW4sDXnZHH+icWHQbYj5cEGgO8pifbxhCtjpanXXsytIXwVD2bBu+nyAP6hEnFnsQHDZQvOSZir9cCn//rTTzj8FNEDm5zz/zj5oMRPL08rI9Qfd+t9CNv4+lt5obyKXJQj2mwTBYw9M3rDzEZWqnwVrRX7brIfAMpsSiia1XMNb+11SZ2HYrqfL8Gs6h5kLFca/3IvlyoCNNeBja4bwiwu1hr99ZcjSUa9FPdNgy7gWuG0QndPzqWGs/lxU5zJVu1buW6C77DKLzyWivJcnes4FlUaBMGXqHf5CU4sPB2wa2cWqJx0vB32Ewsfh4Q8BaE6ewq6jeHN0Y1gHjVZ2LNBX368Cx3I7TVe9LVyGtNlmUeUMSVJkgfW2NhjMTrD1Js6lrNjQ/PoiW7wf9c/IwGZC2q0kYyE+2D1NtgRvBj7stRIbpmQ8YaW4pqP10ah620CDb6Yk3vNWQtt2tlxCsdHGan7EGEoG9gQ9E6sIia7m8NlnD159yL20apQos20mnrS4hlVTRCX9uwgwXKzEkG5P+GbhCYMwj6Y7F0nJarlBl2rmhsYWL+YEKIIAbNlBVyaFAHm2fnr9DRasBTEMT9XXslQSamE/5hPTw2PC5kxEd6l2iNS/oMb2PfiN86cDoH9VIzCYYffIn22ClJww4PQMs3VuJCek3W//gTKkqvGcd8bQ5rS+6aCekK4mcsPxFHkiKSrBIW3xcqsuI1rebji+mpT/CVtDPxpakvq+V0u1SZDuyx2DoOQvAcBIaEGIRPjgGrIjHJ
 usGossIj
 FTEPQV1SOdlgitzwLrgBDHJDZ76+rkXsBYqSI4UZ9j0Nosz62JyrAuSGeIArNExjM+Kjvd5yfYozw23vrzTB/7mAhEcMIhcsZvFZo27dkXg6L/kR5KlwmBIGmE9fP/2ZeJBQAmORmnsx1OfYgc0ebNiz/BMLkR/M3KRdxwhbl6Gm7bKoSM+ALoZ0bKl8TK1zthS9wmp++kTCP07q4w3bTp/leG/aT04GxjvRr1+QoIIDXm+LMwfsiesvgGq5x7NHNopzjVYfdT8msClaQCG+u85ZobKxhnnxHUl+7OwzBJjduFDXmFD3vxFhCUvL40bdTCeGdYFzwa3GsZ18=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize failfs as a pseudo filesystem instead of raising
SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/failfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/failfs.c b/fs/failfs.c
index 437cdc981c2d..f03334f361c0 100644
--- a/fs/failfs.c
+++ b/fs/failfs.c
@@ -3,6 +3,7 @@
 #include <linux/fs.h>
 #include <linux/fs/super_types.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_struct.h>
 #include <linux/magic.h>
 #include <linux/mount.h>
@@ -132,7 +133,7 @@ static int failfs_init_fs_context(struct fs_context *fc)
 	fc->ops		= &failfs_context_ops;
 	fc->global	= true;
 	fc->sb_flags	|= SB_NOUSER;
-	fc->s_iflags	|= SB_I_NOEXEC | SB_I_NODEV;
+	fc_init_pseudo(fc);
 	return 0;
 }
 

-- 
2.53.0


