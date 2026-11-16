Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9403606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ndmzvTxe
Received: by kanga.kvack.org (Postfix)
	id EFE2A6B05C9; Mon, 16 Nov 2026 04:51:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED5C36B05CA; Mon, 16 Nov 2026 04:51:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E13366B05CB; Mon, 16 Nov 2026 04:51:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B2A7E6B05C9
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:51:13 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 114401608B2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:51:13 +0000 (UTC)
X-FDA: 85440514026.04.B4C0ECB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 39E781C0004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:51:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ndmzvTxe;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794822671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L1lZ5wfKib47+5cbYuK6ksYT98WTq4lYB0XvmtFMUsk=;
	b=d8d//EJu1+X0Vyj3AU2hGPW5szhoUunMEt2n3KU96DPMTMCHtJTQT8/i6Mh3PBrHoFmxMZ
	N3RaWOe/6VGTCS+Z/6dY84vyzwj7FGIkKu7WK/DSG6g9Df0yWGzX0lEF/WkYMsnpelU78G
	l7YMwrQqghGzOv1i4syhhTJ64o2gpfg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794822671;
	b=iLaGMhRsAaYxb3Fk3vM0R4tENP8RJiqRcWOyTbYKKk9UCydpkYIWa+Ue9p0AYjlZjN0CvT
	BOduWOjAfqjH2ct2/LtNfBJizLLjqneybH8skwnuP14WYWpvfJpvW3DaBMija3LeZJ1zMz
	5oNV2xemckJ6PDui19e0ty3hduOVyrw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ndmzvTxe;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 973B344F03;
	Mon, 16 Nov 2026 09:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD3FB1F000CE;
	Mon, 16 Nov 2026 09:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822670;
	bh=L1lZ5wfKib47+5cbYuK6ksYT98WTq4lYB0XvmtFMUsk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ndmzvTxeL7W9/Jdvz6YxY8P8py51Wjc6qNExCmjwvS+9JImEf9epaC85hzjy9eYR9
	 uVUDbSmgWHfI5S2ZpnyUY95j+V+6dUc4x/eYgmcYHu6230ISr7IQbxB7A14/qh1SKI
	 z/tb+w3N095FxQ0FXm2/FU4pUUqM9RlWmH+HUlWsxVqgM3WeZNtSwQQrNUl/6m6qRh
	 pcxjjekvdoG0jkzcO1CZNWORgA41hbfuqMidkny80LdqROFR2yYY9l3tEwpYUDW1B3
	 90dJoUAo/iHmuVyrQsl3XF0DD0Bz1kpLrlqVa624COZ5W1omJ7iv9DbKGwbhBw+vM0
	 xBZY/TU+9NFfg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 10:28:31 +0100
Subject: [PATCH 2/3] exfat: keep the volume marked dirty after a shutdown
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-fs-sb_rdonly-fixes-v1-2-95a25ce917ad@kernel.org>
References: <20261116-work-fs-sb_rdonly-fixes-v1-0-95a25ce917ad@kernel.org>
In-Reply-To: <20261116-work-fs-sb_rdonly-fixes-v1-0-95a25ce917ad@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jan Kara <jack@suse.com>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, 
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1218; i=brauner@kernel.org;
 h=from:subject:message-id; bh=IuQsw0bjMfs69fKlB5zik2hJtUUfvF+Vp2c63qEi16c=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9uvhPuTT10dTm9V9DF81rmlGTNHO/a0zqhAtKP+fGb
 i+6d0DjQUcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEUm4zMvwL2pdfVbTdiSvs
 MMdFJu780kSe1jUN1zMVOM8IHBO6uoHhf+KNiUcqlSdfkfxX1DlX5Cf711LOF4I9HiELIqeWdgu
 WsgEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 39E781C0004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: nmbpzz4w4mg7dwxp8sxw7t98tah7dowu
X-Rspam-User: 
X-HE-Tag: 1794822671-317072
X-HE-Meta: U2FsdGVkX182oK9tmRmHtQ76nnO3AjKzWIqiIZDDbvv7zrIxx1wpjkHxhdmFbbeQm90779zTGFYaQ4oZWL69BJPKx/87+mnTaWeUbsjL88DdOscskm7xR0ls69K6NgWKNM1LixnCD/EPJzR1ko5PcSxI0S0lceGPw7jrkak5l9m7wemNcL4qmbd+KBuz2H1854THJeQH7Fds20qugHg71+/Dpyg7TPsgk6cpvtQNGqnujROqmSvqevWRtuRh+tOpwP0RcNpsoq2x+sDQMBLYYHDaqSfsA9aYyfvbmTfFXWvBsGjyodazeNC+qG6wC6Npz9iQfwckj/LZgNUfTCeP7gofDS06Mx0iz9hWwd53ewvDMbwknWPd77/rFygkhYYQsmTMdpJTUxljzt+wd9fdVq4EnrkGmYzwMVeU7cl0YzLAp+3dSwVrT/puhK0kpEUp0meZ1gEvYcACPTq0ST1dGPQ9Fe1a94nzNNKRwpBk+/IsvdPstdzQ9SHfIIBlgo+BPZw1TxuhINInyqtzRh85kxaY55rQN3BlW9tAGr20OoB0GbBJlALSnITItpxi+kTpYYiSjy51GRirFZmDq5+tY9Vrl0YbjKuK7m62vC4SVoquNt4cwCqF1F+IC4uSQXtizJzv4dHPVf13UllhSnsshVaG0AYR7urvtoyRR9Jxg5KsB42rde+lCf7jrb5EEQOjERIJTIEnrDTMBNmTbwKkhm2pxjo7LahfGHf1YSX5QwedEvAUzBXLHpwYU6mx+omHu6l7MK59GIKc6DLvLiPwz/ScAHOsTNvemC4sZqaVslO4WJ+O82FIHFYmIIH5gHFQu6EG6tpxj+OZYK2a/R30rhSn3wtqcnlIlcEudW5udYHhKFe3ZxfhKFE9ziBJLe3ybmaygJ4T4ny3LNUfjleIWWT+uiCDdKNOzeit/vxKIOk+aXSR1EkqrY4S9xXXGVmkk+uIw9Og2hwNfZ7422f
 BSXbWcn6
 sec7lnBrMOOBoXfa0zH/Yvs0D9n9EX62xlLWVvqmmF3d8vJtZsKYIBDCc/nz6+UbyFp/n04GNeF+/FhobNOoxuAHhNrrCQSWs9WgX8WGVucQfNmjvUZdAn41/GDFFlJO9P/sejhgoCTyyGUWRe0rs5hyIc6FWvvwp5aDI7rDhjKBYIcKExluIeHHcDEIvvbMLSh+HblIVXAGnBzj8wrvAHaSLFOlTPumURewDHktI1eMQH0DVQwx7w8eW5o0UBR5LlUWXlVJNxuFZWy72bJqfPyLU4VqAHywhW6z3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

After a shutdown exfat_write_inode() and exfat_writepages() drop
whatever is still dirty. But exfat_put_super() and a remount to
read-only still clear VOLUME_DIRTY through exfat_set_vol_flags() which
only leaves the boot sector alone on a read-only superblock. So after a
shutdown with EXFAT_GOING_DOWN_NOSYNC the volume ends up marked clean
although it may be inconsistent. Leave the boot sector alone after a
shutdown too.

Fixes: f761fcdd289d ("exfat: Implement sops->shutdown and ioctl")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/exfat/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/exfat/super.c b/fs/exfat/super.c
index 4943cef977418..eef7c159d32f4 100644
--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -98,8 +98,9 @@ static int exfat_set_vol_flags(struct super_block *sb, unsigned short new_flags)
 
 	/* skip updating volume dirty flag,
 	 * if this volume has been mounted with read-only
+	 * or was shut down (it stays dirty then)
 	 */
-	if (sb_rdonly(sb))
+	if (sb_rdonly(sb) || exfat_forced_shutdown(sb))
 		return 0;
 
 	p_boot->vol_flags = cpu_to_le16(new_flags);

-- 
2.53.0


