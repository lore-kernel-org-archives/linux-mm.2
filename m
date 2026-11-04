Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2527D606A840
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PMovg2oc
Received: by kanga.kvack.org (Postfix)
	id 37C026B05CC; Wed,  4 Nov 2026 14:21:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 333946B05CD; Wed,  4 Nov 2026 14:21:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F5E06B05CE; Wed,  4 Nov 2026 14:21:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E51496B05CC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:21:08 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5596E140837
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:21:08 +0000 (UTC)
X-FDA: 85398404616.11.E89F52A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7AD2FC0006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:21:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PMovg2oc;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ayyh3GSY9IX8l/NxmtUwOJrSt8ohKQ1xsnTJeKuAZFg=;
	b=OHRnCDT7FPCM1Du1xaRqHHCPGhjN4rOFJKvq8Xawb3/4zPijrmCAIt3lDlrZQ3jGna8oiD
	Y8FMShQCEhpGo1Mr9zw97OkSTMuiTlTD+Cn6RqY3Bk7+gAJNDfu7Piye84UEILaEl+yqqu
	BmmrdW1Jixud/K+Iyqmh9qBy/LRx8Ho=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PMovg2oc;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820066;
	b=4EpxU/MYA//xTIiQH7rmVAqIis78skdnae4+nJpSNsAb6JV+qu6eaNFxCKEjq2NEfyLiMR
	VOmgeKX2xaq7miaRgzxbDrMvBWnGzcLyaUTm3B/DtTkh54erGBdm4QGW88BaP31Tnmd+8a
	yHNk21IBao80lc1COpdZZd1m09FivDQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C2A7140DD0;
	Wed,  4 Nov 2026 19:21:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806C21F000C1;
	Wed,  4 Nov 2026 19:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820065;
	bh=Ayyh3GSY9IX8l/NxmtUwOJrSt8ohKQ1xsnTJeKuAZFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PMovg2ocC+6+72mN+MPUqHUmY8Gh6jGtgFhxfGrbKQmCA+LwwQyl3c6SAd7ODK0Un
	 TeSpRqADQ9Kqhq1oQjD9vPlOAPX0N4L6G2Yq972WfVK0QyS2eoZkVjrC7gXV2Wp9AD
	 CUv1f8DxJzlMPkll9V0KMpG8czJ1Cdjc1NusWgGh651UisUDwupbe65VXluiYLVRKq
	 bmTGqSa/cBkfg+tO9lwTlkqyyX8ntnHu3rqhgeRlRLNSz2FtgHHB11uhlH75pZze0J
	 a0y9Qbx+5R9AkShgQfuaWjn2D8HWZ6fFJZRJfSSM3b8p5Slumunw5NJkGXiVuTlwsj
	 o0bkzl5ZAaHdA==
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
Subject: [PATCH RESEND v2 20/51] powerpc/rtas_flash: don't read past the validate message
Date: Wed,  4 Nov 2026 20:20:51 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-20-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1303; i=brauner@kernel.org; h=from:subject:message-id; bh=7JHU1Fe1PUKfNakrIeb+3f7MU5rT/9SRwlQjBFg57NM=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bnzclOH/9YSeueXTgCsviu6+YT3ptfO90YO+xGe3o vXy9vC4dpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzkEwsjw/ZKfvGdFYG8TydZ OMpPUCz4mPFg57VZEq4Ws+oPejxnmMPI8PHqDVmb3Q9X/9/a4700i1N297SNPI27n4dcu7jAKU/ qBTMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ec8dchdj4maukxowp4jqemofhxofjyo4
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 7AD2FC0006
X-HE-Tag: 1793820066-321112
X-HE-Meta: U2FsdGVkX1/M9RRXLLQn0jZeothnX8xa5VegKK4aWSgxDnJJDQG8UtHoqzbSIQJ8WYqrrWWZtRZi2n2J6Y13NITyA3MSeixg2NqrJ1cWrFY3HgIne/N7CFPPkBtqs06yQyk10AVd+7ILDKDszcDjEFpOY78SOKVz4NvCiKlzHzcF84o/2BZ5vzOUYUQAJbxCg8YFrQrNyRiu1/HuCL4kxbIMagxByJJD/sTLBh83AT41w7J/us2rMzbdLmUB1g7bABI6ISveyiRc8Ci3wS2nB3omFESuTGEBZsrwcPKr+aKClwiTj8jn2WJllJAJMe3mz12Eqdaz8Rby8boeafXSYisRvbLP5O1/4DaebC7p5a2oP0IkajvG6Acng7QKMTdNaN5KwY9i9qrDw1pAwwA7vTFpuuRRn194P+6NeCp/6ZA48TQbNFwqSDnwIvAVynWLZ8tGv90P6UX6pspQ+/9HnmDkO3y8i6+XBxUIxHhmO6aCRdwWXiPhMgH0isW4NTEPpW1kvSRJe/9GF6MjWwBKdp6TF7/V6z+H+pO9AO7syP3kapkKd5Yf/3o72TOTNbqRmFzieBnaa/M/hp8jxUfO6pNsNw55Ty14FfCAOW/nRu30MCZR+sd2keGXCKkEA43QlXmO9HjLspq/JpQYhzBxFu7Yg9q4xUX5uJYEVsdK3gz91hzmr02/Fj51K3ekOB2kdS9R6jbsu04LJRzxLTeP4eXJxEf1jHa6g44XUKjYHTdn0q6njP2s+PJNdiMCebS5PqKW+D4FPv1BW0xgaTUzmRO7cdgUlzd51GCm2dfNY0KZxdP8oUje57Xc0tsoTwg99gd/EhN5ZyK7SNucEmc296/1KFHC4PSrElg0eyoHn/S8R4I0AUULZAJo6Io6M6c3yXmO4bXQ+eOVSbw0qje4XiObp4sYyavn/8aCMBLlp2/yPQyc53fWOXvDI5eE1Yey2mV1GaWk0ITbiYAcP8h
 rOViJ23e
 iaqGgOHNK7bRe/8IAkMy9ZTfcxUcFot6pFAY5Y7f08HZXOSpYOWN9/NPeqNsGq1nUhF/MR9urPnXrXrvmAINU3scqq1xGwOWGxFxurrcooW7SglR0THz3faYQH/+s1c5fwQKvGF+tfCmWBPA2Wcx9+jaPxGswukklR4H7TnMwuIDZBYxMxXVWjojKm+MG/Uoxq2OZSx76CiKv119OiCM+fLd3RSZ4NxjLTvYMsq65sWGOOX8JzFXyhq8Svf2H7NcQQP8fI0lhu/GmwJD8mkZGimNWjz66pnvucQUoP+Bxps8cas5kOtnFe3d2AciDw/x48OiHTeRV5ubcrFVmVHJ3OHpxZwm8+xp30T6IdGikBXLE8XCAGdWkohfgBQM89brHIp2EmdPT4Vw9reHVFCn224Qei1q+SCb8kuH5CKTwlUuT1fghAPidGdCSBh1t0VdALIbd1WAUVshjxx8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

get_validate_flash_msg() adds up what snprintf() returns, which is the
length of the whole string and not what fit into msg. If the update
results the firmware hands back don't fit into what is left of the 256
bytes, the length ends up larger than msg and validate_flash_read()
copies whatever follows it on the stack to userspace. Use scnprintf().

Fixes: a94a14720eaf ("powerpc/rtas_flash: Fix validate_flash buffer overflow issue")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/kernel/rtas_flash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/rtas_flash.c b/arch/powerpc/kernel/rtas_flash.c
index 722dbfb6fbf8..f1cd105f7426 100644
--- a/arch/powerpc/kernel/rtas_flash.c
+++ b/arch/powerpc/kernel/rtas_flash.c
@@ -448,7 +448,7 @@ static int get_validate_flash_msg(struct rtas_validate_flash_t *args_buf,
 		n = sprintf(msg, "%d\n", args_buf->update_results);
 		if ((args_buf->update_results >= VALIDATE_CUR_UNKNOWN) ||
 		    (args_buf->update_results == VALIDATE_TMP_UPDATE))
-			n += snprintf(msg + n, msglen - n, "%s\n",
+			n += scnprintf(msg + n, msglen - n, "%s\n",
 					args_buf->buf);
 	} else {
 		n = sprintf(msg, "%d\n", args_buf->status);

-- 
2.53.0


