Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8689606C3DD
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q4oHngSl
Received: by kanga.kvack.org (Postfix)
	id C6D9E6B05C2; Mon,  2 Nov 2026 09:24:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C44D26B05C3; Mon,  2 Nov 2026 09:24:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5C276B05C4; Mon,  2 Nov 2026 09:24:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 956556B05C2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:24:10 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 30E27120133
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:24:10 +0000 (UTC)
X-FDA: 85390398660.17.3765D6D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 761F7100008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:24:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q4oHngSl;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629448;
	b=umZuMWgMxkAFxTTveTywB4yU3hJK+K5wp6GTLMQqt+0CZiWeufWBrhHQMRgZI0EVsb81Pf
	5FTTjmgUwjhBxt5Hc38K2PgbhuFZY3k82qrQmladoLNPrdtxob75VCTtN34BsWn2MIRf4j
	NaEovHb4PqmFOXUS7VzCOhqQew4OZys=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q4oHngSl;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bRUY7zR2xEebSKJvbp7QJxGSJz7lwz+abCfF6bzfIu4=;
	b=24MPKYNqNTzI9buN7HY2g8ObyRGkoOEHeg9wmo0KZXWKAWhZRx6Pt56xY7eFXiaxQyuPgY
	WbxlNTTdWe8iUSfVptnrO8wv1dKZncmSkot/Rxi4lWZpNDOZOR8M5XgwR088V9ObRg+6pa
	2Jn9VF3nmaTbE+MDHg0ZtueafjxM6TY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 236FD602C5;
	Mon,  2 Nov 2026 14:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710651F00A16;
	Mon,  2 Nov 2026 14:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629447;
	bh=bRUY7zR2xEebSKJvbp7QJxGSJz7lwz+abCfF6bzfIu4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Q4oHngSl6RR7XQvcJq+XaAp9wX4Uiv+CQ8sx4Tt2Tusi7rGELCsKtcuLcJJXnbo+b
	 mxlCgtfGksXTqY2Q/8i91T7AnVm4BEBRl137Etf0oGTFwe9D9oRBciQMWq+yTOnOO0
	 QGVsyH0LhCu7l3v2bfGJdLJnVjIV++s5b4XPu+DOSQdyfbHSB6gyfZ4k8lXOPByBBi
	 ThdJxOnufgvJDz0xi8ZTB5otDmy+J1lOLDGOMtm2aS31Wirxp4zSQl4+tL7bcGeXqo
	 dXa74lidvqboGZhY+2PrxAo9x6EY7nhYPMVAV1rpoMUok0p5Nh6BfTdJS6upH/7sTm
	 6tssOCEdNYPig==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:21:25 +0100
Subject: [PATCH RFC 10/38] scsi: BusLogic: don't return 0 from writes to
 the proc file
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-10-59422ed3e465@kernel.org>
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
 Chuck Lever <cel@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=938; i=brauner@kernel.org;
 h=from:subject:message-id; bh=7Bhyn2ehZ0sKrsH+Wp9jL6/kN1Jv4nVldfkK6knOcds=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9mJN1a7Lx4sI0u4/XFnXO+KMXfnKfYejKtbH8CxZsO
 hF04AI3S0cpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEpHIY/hfWrPRbNS/qY0/s
 /78ycW9e/DrR63iI826p6grLItn8JccY/in8u3XBeXvXw5LYlpjDslrr5YOmH3c4HBp3rv7Xg66
 gLawA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: 761F7100008
X-Stat-Signature: zyt71ftydks48zzsy7b171475whzh45n
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793629448-730848
X-HE-Meta: U2FsdGVkX1+KnoKqD6xnXUYzBP4/9qXddwyfM07gg+PtRBz5syUBmNRaTKHLXGnYN+Z35sce5730I2GVe1qR13sKIL1dtPbGEUxc++ekIC+3MSLodu/0e5X+FylIirYAzMa1I20BSrd8jmUBancucdBqUMj76szcSN6XQe9kEmYKZCEqDN8/LwvKs1rO/YdJE5yGMbdPVlqsKnEcGUIjkCcbYZtyKkQJlqS0tP+WwikfM9dJzzbhtiW6onOOuEKUAjBMgkdQXD9d0/T8TZKDQb3GOLUhFI3LV2SA8dRnFcr9MOldXKEiEyZTAVm00ZrFO1KOAX3ChN7/hG5K+3VXizT0PWrtWLgEin0dtmuCr3gPcHY5SeqRC9uNmfgn5qOvFUHL26TtTICsc3JbbtjIr489Xjk94USyalJPtqyjxlLLnrzHkxApAVsdCeR4gD1DLPqKw0om2Cm1HjxUUtuj+9DhPf9iVgu77I4vXpeIb2zqKpyu2dFT26d8yYisdn3nWyDa6xPnNINZaTw5pIMt63xQszfd+fYanoINFx7tiPRK3J/9sjbH26oaNMhI6STdu1pw5gcEZ4xdee2Hia8ny08dNlZHSPWz7S+jbiSub32JmMCN4d6RtkRAS+3JnZsrHrGqf/lg6DMfRhvD6rBKRmp/l2k4cTNe8BkbP4/Wy5njG5FlFROLEEiDqugIq8Y4WG2AjvNeeL9ZUdUSVIdCsiAi2wbFKjGmVQBVky2o70f37vxc4Nt98jF4ukAWmlT7Jw0Cic3mjTUrk15jdrhevn7CsMXT7/nL3FB99AqGGbR28AsrJyKeHo9yKLXyM8LHMppUohwgyN7g1f9ULqkrS70xyLSXTam4p7S5lUfkEq5z7qwykuMqPEx2sHEiPq48MK5LigfbdfrZU2ErwrCIIZ8kXpWpfA53eePsWNqCDHzCpP4cHIXMEkLGd4Ct9F25XUgzfwpnu9t9YQsHQXU
 IFV8qpfa
 kVUd/Ob95pZ8ByflNGJzFgL5dzyhk26+mRdZ246arIciooo8+Id/f9nVMn+O2MCHT05alApi9+GNrfrKU0Tp1gsMe3+Lptqq0Bab0sNJY3RAoM8Ld4wVWyafIuPelbkLZV6v7IPmkPXNnn+4xybndWVjEcSiuU1rjNwBkmL1jzXflzSg0h2f0HKBo6UM51bDsMIGNpWt2C9tN/fPbbh7hSCWOM/JLm6/nZSycKbYLv2yAd3RsvHHThYEvtHV6AckzxLYcKNkHQNqFs7NJQHgi670FnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A write to /proc/scsi/BusLogic/<n> resets the statistics and returns 0.
Writers that use stdio, echo for example, take that as no progress and
retry forever. Return the number of bytes that were written.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/scsi/BusLogic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 27b446c0c5d0..7ad814f549ae 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -3328,7 +3328,7 @@ static int blogic_write_info(struct Scsi_Host *shost, char *procbuf,
 	adapter->ext_resets = 0;
 	adapter->adapter_intern_errors = 0;
 	memset(tgt_stats, 0, BLOGIC_MAXDEV * sizeof(struct blogic_tgt_stats));
-	return 0;
+	return bytes_avail;
 }
 
 static int blogic_show_info(struct seq_file *m, struct Scsi_Host *shost)

-- 
2.53.0


