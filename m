Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DB82606C3E8
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eTKJcNWG
Received: by kanga.kvack.org (Postfix)
	id BD9936B05E4; Mon,  2 Nov 2026 09:28:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B89AC6B05E5; Mon,  2 Nov 2026 09:28:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC70E6B05E6; Mon,  2 Nov 2026 09:28:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8B9436B05E4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:28:45 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 340F5A0136
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:28:45 +0000 (UTC)
X-FDA: 85390410210.15.DE09C29
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5532D120009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:28:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eTKJcNWG;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629723;
	b=TBxbAsgpsJlNaJEuXrIsGxyV1+10GY+JicJMLn+f+Tj3t7X5tk/uuu7dE1m9W/k/kDypw4
	OzsJyt23c9gTizqFoqBBMRSZ7r4TMSGG9/WWXzhulHVQGWZ1uwKSfAA5ynm9DpJEsw8CMu
	5SMlw61OZrZrEWxCb4FEWZ3u0XgV61I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eTKJcNWG;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8QCucuYZDNmVJaqyrDFn0TUDlr5eGhlHKy/r+vN8wLA=;
	b=pKpfWZeKKOoDxyFUh3igvyRjpZ1Fw1iNC3QOOXhLL1whtoLSHJlI803BQ/15qom3U8PZib
	vXrOz+kZWanwTufuCDoqtApE6O5MvpCttYnQoqwavY87ghN/N12CZ6eGW7s4gGTf7y88L5
	KQuAzFXVeUPafaDEk/veMkS5LGq/yfI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 90DC74386B;
	Mon,  2 Nov 2026 14:28:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA321F00A18;
	Mon,  2 Nov 2026 14:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629722;
	bh=8QCucuYZDNmVJaqyrDFn0TUDlr5eGhlHKy/r+vN8wLA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eTKJcNWGC9V6irm/9DKKTQuZ13M+/P1en2BQ55yGY+lnmUDRqciw/Rf2PsHx9OoY0
	 buVb9lCjc5j1j+zVE00+8lE+7EIBrkA/7gY7pAiXO36HsFOR8TPuUiDrZTExwthr5Q
	 g2ntrsvA0FRDkX0DqkVI2R0zq637sI1kyS8+kikVTIf/hcY+oSRxJ/YR+1Xg+xR/Sp
	 aqNRXFGzdUJn5XBZWThM4MbuyB2ZEPnFIDc98ztB3FY2A2pzEfLhWTVFohA37ZdeKD
	 CBtYkQwAlSwOguLYUrqoxdDzbhzJby7zBKRKI64hRz0r7REL/5ePc9HqUQM4L5ULRF
	 akeGwQAgSlDqQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:21:45 +0100
Subject: [PATCH RFC 30/38] powerpc/pseries/lparcfg: return h_get_ppp()'s
 status as a long
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-30-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
In-Reply-To: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
 Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
 Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
 Greg Kroah-Hartman <gregkh@suse.de>, 
 Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, 
 Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
 linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
 linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
 coreteam@netfilter.org, kexec@lists.infradead.org, 
 linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, 
 netfilter-devel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 ibm-acpi-devel@lists.sourceforge.net, jfs-discussion@lists.sourceforge.net, 
 linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-cifs@vger.kernel.org, linux-fbdev@vger.kernel.org, 
 linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-sh@vger.kernel.org, 
 linux-usb@vger.kernel.org, samba-technical@lists.samba.org, 
 sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, 
 linux-doc@vger.kernel.org, linux-serial@vger.kernel.org, 
 linux-atm-general@lists.sourceforge.net, Takashi Iwai <tiwai@suse.de>, 
 linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
 linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
 linux-debuggers@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Chuck Lever <cel@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1639; i=brauner@kernel.org;
 h=from:subject:message-id; bh=KaAFx5Z9JEYFTwMkBWfFQWs2ORbRuBTJUi5MCRtyyf4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9mJOTxjOPK/q1b2ZgvpS2omCxgaLdOpGttm2Lmc8Xv
 BU/7jG7o5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCJJ7xgZGrU/qMj0nPKcWMLS
 d31xjeSx7XF/+lkE6y6zn7F2uXs3h5Hh2IQtWpWPJy1y5bu073hy0q9fd7PiLBl/7MisOXdm0pI
 kLgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: 5532D120009
X-Stat-Signature: yw1crw7ogyd7gu5szamqrx4in4u9brdf
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793629723-691226
X-HE-Meta: U2FsdGVkX19QBEJobfIVbCCun7mynJE/s6a2VKG3sy5GxERb+LOEKp3dNFRVYDZFgK5hbZm2XjDcNatgjzWWMQOaAVN1+ClP3IlSMYGBshyuAeVdXb6+XtDekn8WR5PhcZqF9tj5Ky2Ji8WjqDlwXGEhPwXwxF4qBljgbH+yR8PsDXZfNvBDzru0tszzvph2QLP2iNJe4rjvX1Qxs4h2jlaTkv5ZvlBbVhWbqCqNOFVRz2FKE4fOeT+8iqIHkw7WgsDbnNQCrND+CDVNY+loyklBVjMQsvAl7COgvLucs67iyheVMgqqLabR5NXaGlu/by6ypbka+x1sR2tijOGv5z9MXzQ7pLC2D5kX9V+kkriInHYgda8d1kQ+yNdCI5Rbf3QO4eu+zBGjiV2hNg7a5R5AATmyh8M+eNW22tff8Nlg0sAzlcI8U7qFwe7pxLzvoIwif5ivuMSgk0rEnxaRf0kIQJxFxAABNSw5hx0yFAPOJPPEs0UVfIxeCtfkNQs1tiC20IUimzlMQO+nHd8vlNV2S9uJgukpJOBvEeklcZoFaL9Eh12MhUzizrk7WoEmC1CO+3+6VfKDOOwoIo2J7HQBNLQa9z1Y9nALwITUIJbfB69cLdNugQfOybIM9vtkbUdXSdQJ2eqEHHA92bMuqST3HCIO6pz4erPKSunfhzOVOCvNBstr9cIrtMbpUXoI0tMw+kzfVSeLUjDVtldejM7fAcyhztWvw81R9e5utbaAF2eoAlBHShnXFmq3KYjmi1EW4Jy1ulMYCSctX6OGdQ+bW6bMmQGWLmhOjIrwo77OnqbCBh7C905Lg0Kmy+aivN+fvLIJebj+YfHyNpLFMiqMOTpK3GzIrCpSAbXygCQRvQ5zxkQKvTcc1K//uSnRcHqDUKbOEDXB53cH5culIJlu9Bm0z5MvqSnZ5vnMRDv1oBpy9utiNK9OzsH8Mbw4+2fe3tJgTGc08RgxQeM
 gBSd41oy
 L2NG56ErRjjaphgF6scT/kc5+/d4dPyjbcosx9O15N8rvL0dPxHWy9wB0Ogtrn8ayA7ZBmwUxycz79ot0V42y4nZGGU2hfXzLu7WDTYy4xQVRvn+kvKXcecNHT9aQqjlQ48jayld8EPcGtBQ3mE3r+oRFPlvCS29joHzJO1n4Br10DOUAejxsry3lfNlfInI0lspN1QE22xD3L5+hicTsz7TbEPKuWg92lM26lff8+wYvM9TjNpfLXNG+W1/cZBNN/mRQX4Z9tekYWwtvWx+jHnGCE6pcbpZ4ZooQrctHD794VTeBajcLvd66jeWSNj73ClTCKLwFkd6P8BU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

h_get_ppp() returns the status of the H_GET_PPP hcall as an unsigned
int. update_ppp() hands it on as its ssize_t result, and
lparcfg_write() turns the hcall statuses it knows into an errno and
returns anything else as it is. So when H_GET_PPP fails, say with
H_PARAMETER (-4), the status comes back as 4294967292 and a write to
/proc/powerpc/lparcfg reports that many bytes written.

Return the status as the long it is. lparcfg_write() then treats it
like the status of H_SET_PPP and an unknown one is at least negative.
Before commit 11529396ea31 ("powerpc/pseries: Split processor
entitlement retrieval and gathering to helper routines") a failed
H_GET_PPP turned into -EIO.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: 11529396ea31 ("powerpc/pseries: Split processor entitlement retrieval and gathering to helper routines")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/platforms/pseries/lparcfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/lparcfg.c b/arch/powerpc/platforms/pseries/lparcfg.c
index 3280b7968cab..aa9b5b141434 100644
--- a/arch/powerpc/platforms/pseries/lparcfg.c
+++ b/arch/powerpc/platforms/pseries/lparcfg.c
@@ -113,7 +113,7 @@ struct hvcall_ppp_data {
  *	          XXXXXX - Entitled procs capacity % available to the
  *			   partitions pool.
  */
-static unsigned int h_get_ppp(struct hvcall_ppp_data *ppp_data)
+static long h_get_ppp(struct hvcall_ppp_data *ppp_data)
 {
 	unsigned long retbuf[PLPAR_HCALL9_BUFSIZE] = {0};
 	long rc;

-- 
2.53.0


