Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0DA7606CFA6
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YSj0RR1a
Received: by kanga.kvack.org (Postfix)
	id 201FA6B05EC; Tue, 10 Nov 2026 04:20:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D95D6B05ED; Tue, 10 Nov 2026 04:20:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EFCA6B05EE; Tue, 10 Nov 2026 04:20:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E64E96B05EC
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:19:59 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 809531C401E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:19:59 +0000 (UTC)
X-FDA: 85418662518.13.FDCD57F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id C3E03180009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:19:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YSj0RR1a;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qJiFf9w4hToXcclP9ppmON8B46ZerQobJ1F8sM9X2a8=;
	b=4iB5gZ4pavJAb9i02oh5K4V7FJP5lQ6uAFLcgJfHsqPc/qqmj4iFJjCCB4c2sIgw/L46ll
	HjO6puMjQHrZQ7d8R5FR7YhxzOUWn72nszF4MhEtachpLuroKE/7bfKVn4YxehRjHnTVDh
	AQzsjL0hkYUQ9EJu4hyBQyNArMB4Byg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302397;
	b=DpoMI5YfW+dyIhiZbdw9j1LRtW5/b+YQ3Q3RBLeKTU7g46utP/RQ2CQEMVQyVsbHeo8ZTm
	y6F1n0VYuoJuYOKy/xkoowYhDn/qLYvdmvwvykYa49VnIocXhUeMiUIGTKrTjT0/zwU7vZ
	uCZUQaZwFRuOcpGgk6FPLOUHg0OfKbA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YSj0RR1a;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0712846B0B;
	Tue, 10 Nov 2026 09:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F39D1F008A1;
	Tue, 10 Nov 2026 09:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302396;
	bh=qJiFf9w4hToXcclP9ppmON8B46ZerQobJ1F8sM9X2a8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YSj0RR1aG6qNPyxHpaLvknjLVj91ILD+92zWFulNcS/9GzuRoaQHatZawU0nYbR8y
	 wus7ohgAGQBai1txsuKrJnXmIbOHGPu8ofJJf/FVDtHI8ClyJKzU7qfsjBbW0aZ+ce
	 zWv3AeSLtwvY+Mjd5A9NqJjMByywMDui/mH5eL6dgY9srHxtjNOSh4WuAXPTmUK3oc
	 rj74FmSQAg97IU/fPvixOSTy1hGHbrW8yJHlHbDd2o5Lngy9Nmbmsk6Ah2dyvn2OaD
	 xaVAA8ELW3uvaLp+l18HV1m2/38wuA8CuBANF9a3ezWOwggIRGtvqG3gki5e2MoaKT
	 vZL834m+QNo/A==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:51 +0100
Subject: [PATCH RFC 35/41] zloop: refuse zone files on pseudo filesystems
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-35-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=822; i=brauner@kernel.org;
 h=from:subject:message-id; bh=li+gC8cc0Mt1bD1j4gMcmL8SOHESlN2++n5Uf9tP8Fo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erDHcu21pTOZuhx19nwxdyrrCmUMb3503015p6SPw
 76FMcqxHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABN5bMvwv9AwrjaFoTvl5SXZ
 U7d+5SbufCNqdW372nkxojHPVJnq7Rn+R03u+RT9ITNnZY8fx/JF32OmNseuuiD0fVMyz/+nq9X
 nMAAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 5475zc5wz1kuyi7cxga5fwg7zdmst4cz
X-Rspamd-Queue-Id: C3E03180009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794302397-602108
X-HE-Meta: U2FsdGVkX18m375/UcFZ6cBuYZFNlKBsRpTMG+LshFvWhteETErIUjp8IvCIqPTZoZvO3xxHuqGkmCtaqW5msE9JJh7iychswjef/rX81LNQzvGCGyAMo9DNEzeI/pOjB0kftKiZP1p3QQsGgQq1MDIGl1h+rJXWCTtuiMTojNfWPKAnPPQnqamZpudgGdXKEiRgQVFx6n03/tOzhCvtixFT94dLlRuHaCniYXgY1GPaZdP5PdbOBjc71Y5UoyaFzCS4NKFdwv4gXdqpklEbtFa7/bCsPm/U393a/3wy4zthtd3HYOFBPPzq/UWGaayb62sapEDzfoaH0PhUMjeuaWdLQ2LK8YGClZdUKbLNedbz9AUB98c65iSQyRkvwyUvtTjw84SSvTpwfM631Q4jrzjE8Y71hrgvr001EMQoryX3RNRXC/yZr2lio7yHvaWXp9q0axDRhq2CI2QIKC8++6aBkLiaIZWEUCvx+jELOh4YCGEL1tkt65KHCuUiC273lyZJtdEeT6pH/Amr/fxwQUb6d7yxxcHy8XsOqsJipfhKijseNX3tVSH27w0LjtIUvA2dy3RMfeWK14AX3uiPTj6jP4UjV6yLpIdsHuj7Yll8rxx+yCKfCVGpUZ6lOe/LQGws+Xnaoki+h3hbzFdEbJBXAaRelaptulmWOpNN/g7NDZRhitwlm+5YmOcqCHUkauhAoOhvkQR/0DyPbuxJ1iFyMyXYxppFnx6pBHWGhruBW+dXsoW6Xr3BklrqCp0kgovL2t1/A1sDfann8ZL3380d6pMUmBi3fOnhZUCxUfrssLh1VxnS/9QLelea0UgMtXdMnxalwEHmHOxVJ0BfzXNQzA8FjN20jRXXYTHNjTahWowPSK23vcvtVPj0Z0NlBleB+L5HhQSPYypJX82UFUG78bk6NjJlIevzLip9e1KF5+KcxN9M6WLOj7XZlKOuwSHSs9v2VkGBLbKGcxe
 4lF5I6yz
 0GPRzqyGVkZka0yOnHs/27UG92Wz66HAaRy8ORvhUHThw8Jc/vRFr32UPQ7pKLhIGQ2BNbiBkSwR0MsNhQ4+sTXeNY6GIw+Tf5nCxlpL/DkEMRAqmS5d+IHiOQy/cplWUWf07qC1Mp9n2PBRaHS3dTPf1XERP45JgZMnbyXdBuncw8j9VTjNaHEpISLIDduv7+lTR95I1mkkYbe7gLhOWupZTHSq332EvExqwIyIZrz15NGTGIlagFTFVGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zloop opens its zone files by name below the base directory but a bind
mount can put any file there, including a procfs or sysfs file. Refuse
files on pseudo filesystems as zone files just like loop does.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/block/zloop.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index 65634a39b0bf..dcc06dd47b04 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -1137,6 +1137,11 @@ static int zloop_init_zone(struct zloop_device *zlo, struct zloop_options *opts,
 		goto out_fput;
 	}
 
+	if (file_is_pseudo(zone->file)) {
+		ret = -EINVAL;
+		goto out_fput;
+	}
+
 	if (zlo->block_size) {
 		ret = zloop_get_block_size(zlo, zone);
 		if (ret)

-- 
2.53.0


