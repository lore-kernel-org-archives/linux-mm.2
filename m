Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B47E160A3816
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GRiIgHwN
Received: by kanga.kvack.org (Postfix)
	id D24D66B05EE; Tue, 10 Nov 2026 04:20:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFC0D6B05EF; Tue, 10 Nov 2026 04:20:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEB1D6B05F0; Tue, 10 Nov 2026 04:20:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D0276B05EE
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:20:06 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 40076804E8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:20:06 +0000 (UTC)
X-FDA: 85418662812.10.C5812FD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 802D5C000B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:20:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GRiIgHwN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E+IOyvszTPpv67WVfApXcw8urPUkzwLhKXwxrxd5Q2U=;
	b=VTwEPUD8byMX7/ujhUtTJhrSyEL4mLIn+oWgEqm1StS7EsgBpSr14Ywh/uL9ug2zDiHJGJ
	gA/tC0JJrhKN0lZcfjk4KFpz3GQxvIb5iLuvn3EThV46R4X2Kpts4W8SjCIz6Os1oK9htN
	NlxSAbWeFiRYI+5MCGB4maudFMTNHZY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302404;
	b=FiCAxfW2IWsPcCsuL/pJfFIEl7deUhe7zXB0RxdLZLc+tqbyZCGSaE71/ume9IGt9WuaQL
	GHuHTHqj7plpsa7/SunIYHZcQgXAZpo9TcdTS59L93gEwfWTgF+SKaSQ3AihNMgOl6+UdD
	b/eAtmvUZajrJmJcWsTgE/zVKd0xqlo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GRiIgHwN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 270A66381F;
	Tue, 10 Nov 2026 09:20:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5968D1F0089F;
	Tue, 10 Nov 2026 09:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302403;
	bh=E+IOyvszTPpv67WVfApXcw8urPUkzwLhKXwxrxd5Q2U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GRiIgHwNZvImcyL7ZrhwcHTim1Tcg8ha0BAVLvCt63eibDuBdqoGnn3+IZ3T7OBIq
	 kT6r8YMuTD7me3jVVO4LuvwQYkPqosPEVX8f4q9eZuJZsQvKrNsIgO5JMMLqqeNIuC
	 5Cpr1r58rbzBBX6KMjeREg5OUsa/9eOU65Z5i70WZg176K2uk1tQ1kAhA4U0o0Rctw
	 xZ/y1A7h5XbjDTP8H3oewDpTzB4kJ0kw8bjZG9JUpDxnNRmZc91S3mqwbwSIu6bKQ1
	 710KWpylBRJOXcVv5bGIBzE03omQg/l6rlLylLNvB6cAWjRRFZkeN1M+920TaGjY0B
	 2UXvy+J5ImDmQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:52 +0100
Subject: [PATCH RFC 36/41] nvmet: refuse files on pseudo filesystems as
 namespace backing files
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-36-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=834; i=brauner@kernel.org;
 h=from:subject:message-id; bh=agqenJdWQq7gypo76jkCFbW4mXy4h6l0lNCXX+ASm3g=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erDvm3yLxwpNhn3Vf/xC/LZIi53fJ7yLL7tHITliz
 91kU4+kjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIm8FmJk6Auyf5jNeWOi0OnH
 C2RnbHW9nXtha/oTsYTE2efzD909cIzhf93azF97BBdfrrbP5nki8XXrjrDbU/+oPHgTKJzVsWp
 jPzcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: aou66bek5335cjpkqxwbkkro3xh4bdw8
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 802D5C000B
X-HE-Tag: 1794302404-20652
X-HE-Meta: U2FsdGVkX1/5gj0WMjHWV/CQAykw6vXT09lZ/5NaLoYv3B+Yr5sSgL2NOqZvxw+9TAxkBaIwjex+62mtmB/OW5esINHVMuF3uBCRT1s/C1WWu+GN132rOWCkokZp2NdcyJCRNQL98wOCZjG/tGwaUJf7MU4IQ3VNqBxOi8UCVGbVx+RmANfbNYorCqNA736QXD/I9HbWs7OoMaoRzuY9UW4k9P0PGpWD3EysHte6d6TVE6DRvju0xcuVW1lLLf51z2LKGr6m9rybKGWW76kYluygY2uXXGXFPYmEgwv7kwRkwZKDb6UOOlulkI/c/dB2L88XsvDpxhk2eeYkH7CvRKYtpCFj1x+2A/TKeVZXIhn6SPZr8zPhqwZdUr9ZHYoGs6PngtubtMRt3dJySB2MqmdM4EZ9rAUtFwrz7WGYqVs/Ir5CtUlZv3oGsUDPDXyikKfdB4axwm08unRAjY1MqVcLXd8coUt6gL+oIAL6LEIB4xaOG08JCEuZLNoNAV1GVjCzsm+UtLEufJMCsA1DvNYoTVLEaLhJDgBRCEaXLOAkFJW5pY6uNZELH4ZixmAtCoxwDpS7tSezJp4sYREmmh5eF+0zVAoqwNnbNexssm+d1rhEXvCMbZjD6NKD8YYFynK4bbCf7ULOTE6B7ork9NejiOOhHRzHA/TaI0wpBCc4DFiEW1A+u0PyBMZbXWzInfJ8tqYJDXHiYQKkjFnuQUC99FylaVTgndjor3u3r+IBWADqAohbE0JoJnTIyCDqYgxsuJBRyS/FP20LpmEU704szL5UlW8Kj+YIN7CdpDUVf5DIFU888K4ndm8SXaq/EdlFptMDLvnhmBs6kq4TbTFpTsAV/nQX0D3J6RELvZrA331horW/DEA7hb/9I9A+FJDv/EKlUHf4G2UpMv1A4xUBrBPfu3iQfPHmTk6vzutDXuO8md9tbea0jM5S7dijG3WdHcRv4sgjtMqQrZG
 IjOZPgZ3
 t9LAJW63/gaDa5vbDvlekF7gAlliQwDQGJjzCCOtDdLUfrLgCVjodM9tEAh0HDegUC9zvu5PPi++MRjSsKWt2lGksfLsZUcjjp4+f/VLnWFzLypWh8GVB+hnfnRXpA7M7a1Pc7SkZwpYfIl6E47YILqBr8NgMcpSt+CG8fDD0uSd9ZpcHqOUBQYY521JSwlo6VgXYuUR26XFDlzTVJ3SxEYx0GNl4COBHOR5zWrvwddipu6wTg6KpLrD77g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The file backend takes any path that isn't a block device. With
buffered_io=1 that includes files on procfs or sysfs which then get read
and written by a kernel worker on behalf of the host. Refuse files on
pseudo filesystems just like loop does.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/nvme/target/io-cmd-file.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index dfa8aa46188c..71c69bac5394 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -52,6 +52,11 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
 		goto err;
 	}
 
+	if (file_is_pseudo(ns->file)) {
+		ret = -EINVAL;
+		goto err;
+	}
+
 	nvmet_file_ns_revalidate(ns);
 
 	/*

-- 
2.53.0


