Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 014A760A6F74
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gqYeWMoi
Received: by kanga.kvack.org (Postfix)
	id 39C4A6B05D2; Mon, 16 Nov 2026 06:06:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 353536B05D3; Mon, 16 Nov 2026 06:06:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ED9A6B05D4; Mon, 16 Nov 2026 06:06:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F1E456B05D2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:06:24 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 94E6512088B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:06:24 +0000 (UTC)
X-FDA: 85440703488.11.528C161
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id A83A010000B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:06:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gqYeWMoi;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VWUjc/lm6IOzTKu/XrjxEXkA+3TDHZe6UgBZOCqPWKg=;
	b=PLXv0rJRUHjBQFe8U9bdskUS4qWrPO1m94iuvGuv9KW1bc3KJB3FUC9Uj6AEhWdwGW0x6y
	aGn3DXJY6cz9LFBNfYg0KCMAHMgr6fJFgbhhQmP0VYpBD4e6GZdXRMe/Bs/Vs4L9DKpVDw
	DFGYbpgvvmP+j6jbrwXrpPj0W6Nul6g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827182;
	b=xDTS6ymqyZkAHKWmUsk88+68lYImsE2XUwrNWmcpr+s0ZmfFDdHJSF17mfBnEvgltNsySr
	NX/8vsIpntbJE08NHOuRe2uAvj1VoR5CyhM6YXMPyf76VQqRtG6jskfeeXmRguQzG8qMTG
	UmJOp/Gl7N7EtdkGxc+mLTas4UV76U4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gqYeWMoi;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 026636293C;
	Mon, 16 Nov 2026 11:06:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1CE11F000C4;
	Mon, 16 Nov 2026 11:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827180;
	bh=VWUjc/lm6IOzTKu/XrjxEXkA+3TDHZe6UgBZOCqPWKg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gqYeWMoiimKnvtxsZfDhW+FmTOi7BTYxF7bo1d97YCVIcFzQE/1quY4S5XouMi3vB
	 mIvfX8HLza9wbhVfQveoZSPNYa7EZm6PUCmHQ7skz2lmq1+o5ujqB3Qz/i2/xmyuvR
	 0b4/gWtXnDtYIY3WrioVdCD8nsc4XHXOdDDcY2gKhZ/KosrpWqVHiN6+7kfAXc2Ahu
	 If9E+wIs0Kg08YhaHkaKtxLqpKU3MXnTXiDfJS25gkPWQfrBhMW81NVuUjfaEMsu6P
	 vgEPDQeb4sn9onP21h80NsMHJnf9A+r8P+Co4bTECH6PFFrHeRa5TxSI1gVwQGLhtT
	 OalR/X8sFsCZQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:35 +0100
Subject: [PATCH RFC v3 02/44] nvmet: check that the file backend supports
 ->{read,write}_iter
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-2-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1339; i=brauner@kernel.org;
 h=from:subject:message-id; bh=EG8EaOiS0vQgTkKg5XSiMzmkRFf0paS6Df2fYJxqpSs=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9epzAcWr709tb5k+1mZtXOrOoKe7FjPPX93rnL01cc
 mp3sNpj3o5SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJxH1n+Ke3fG/p7vfHb83W
 Mp77jIfTTjdGPfuMqexdx60Xbl2XDD/E8D9576foPweu5yU+nf3y9bU/t+YHf7W8oOhp5cy3bNl
 qq+9cAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: dfw46ope8efnk56z4ehb9swkr5bhknr7
X-Rspamd-Queue-Id: A83A010000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794827182-381070
X-HE-Meta: U2FsdGVkX1+pagyADTJxKT07Zo2TFWYZj4vqQXtbixokx7Kb+OrUC41fRHOoosu8cYmXinAO1rQHEM1Z/OP/JoVimaQtz7v6k/hMPl2CaiB/pSbPWM+RgLjRteaLelnCPhMgJ/G3Hq0KRHHUPmiU84yKXAd3HKCTlneTpPYm16YDP/0uno3j4rBpsqeW74AJESpmrlxMb5iT6r6I36iadgPNn33VpwP58mObLKtynsJc9FNj2ZcTy1LX3dtEOf/pIakzJFu3yMb5yuF3vGMX32PzmhETy7Ja1w/ENbBkRc7+HxXFU6DKRC8iXZCZtaDVo2SKpk01wr3zeef51uJ1PSJvT+YxMJO+dqmlpqNvNJSxY83QkDK3mlevC+IEGUxB68HAx30UpxX86TAdX7kTUSbeYn8wF6QSoeggdhnxUyyvHS4ujbHvsfJL9RxNd/jEfxZMAhCNdjVIDTH4/OpCV4KowlBR0cwJGZ1ilnCgXZFUFnCXLJZ7Ed75eh77BeRXuxp6VtBsxE7SR6nJospwMAz7JvZFnW3ykDCKjnSqD7NCFBc9zoQWhxc7+wBNVpNRT7IDGnQMD6FPJjWIH9d2Urg42Ec0CRgDAPCa2HLqG61DxbwmvlxYgyahuQ6aYt0ak+YgVvf2s4uhZVxTtNGhHN9YcYbwD2IoZTA2taQqKQyS05RxdsAOdc7r11Hees/Dl5IEdOvktBfA88cq0nf0MBiBZp1tzu4LuMcBLdBBshospNngQ6L/S4AiX/Abm9DlIzpriO4BZhB5dcwfgHTVzM6os+rM7kKxAVu+JOBuS+zHpTrX+PS2CGwmjkb5XbSvuNM9P+lETPb0RZLvrE6r3J/OUXnw8HjZM+wXDryZ1eyq7jNhWxViqbd7dwsls/UM7AhPaQC4cRsOsPti1965uTOgBr7idwqcrRqfrv8J9gna8j5sSQd+gp0iT6uL2TctXb+VYRJuC9GFlO++R37
 G+lIL0tB
 Qe52fbhN1DQQNgyZPLOg5KjPAHoZ+lcWUr6zksjPUZ313mRK8nBQiuqwXhgBgFFf8iSZoANldHEUFw7u4vAvg2HvkvwDIFr+Ygs8C3xg0VS2RYqyq4sZahARzAZ4UMewXBwE4pQ3Wvce6ypVfALVAJmW+O0YJlf+62TlomvygwM6y9z1H/0/bDcJdGMKrJF5aixiM+yHoew61FNzKjoUGJMAVZUT+G3+t5cttRj49FAWXI2++R0q/bdENWTwvhV8SEZCwQgv8Ski8ft+9G1qe9tvz86TOnkmQC5e9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The file backend calls ->read_iter() and ->write_iter() of the backing
file directly but never checks that they exist. Everything that isn't a
block device ends up in the file backend. So a namespace pointing to a
file without them calls a NULL pointer on its first I/O. Only
buffered_io=1 gets that far as the O_DIRECT open fails for such files.

Refuse them when the namespace is enabled the same way zloop does since
commit 0c10f8a1a7ae ("zloop: check that the zone backing file support
->{read,write}_iter").

Fixes: d5eff33ee6f8 ("nvmet: add simple file backed ns support")
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/nvme/target/io-cmd-file.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index 695963dd932ee..dfa8aa46188c8 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -47,6 +47,11 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
 		return ret;
 	}
 
+	if (!ns->file->f_op->read_iter || !ns->file->f_op->write_iter) {
+		ret = -EINVAL;
+		goto err;
+	}
+
 	nvmet_file_ns_revalidate(ns);
 
 	/*

-- 
2.53.0


