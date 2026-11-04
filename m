Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6379606A338
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=onbfdV/H
Received: by kanga.kvack.org (Postfix)
	id D88E46B05B1; Wed,  4 Nov 2026 14:18:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D39AB6B05B2; Wed,  4 Nov 2026 14:18:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C02FA6B05BA; Wed,  4 Nov 2026 14:18:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E24A6B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:18:00 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A19578081D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:17:59 +0000 (UTC)
X-FDA: 85398396678.06.2C712C4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id D13DE80004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:17:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="onbfdV/H";
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793819877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bp2DPgSMAVNPpocNHMMHSMxcgQhQwNKqaFQNAmEUdgU=;
	b=tjmKkHmA0znfJqwg1LDDHRP35a4VxuOTjBE76F1rudBOy17u7B3Yn2lhhHO7LpRScU0d5+
	dslwfrH5HbiAzlvjgbr+vZwhPfr2bYtoHWBjo3Gq5VLM9tHHoU8586udmAJx2B402OywWo
	nWIXMIcvf7r0YrSSkmaaSTlCd5SonKc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793819877;
	b=iokq82YLYGfczxnox/bQu/SDpGIGwxhui0j9Hqn4uq5NpbybRFdOavaDyi2iYG9fSLWVE0
	vSVgN8yzkYhn389HV9+jtTYJIFr3FV4np7D9Bw7wOZO3UBcqqCiiaQt7YWPzJglqCQQrzf
	SdXTOjPB+rRgE3SyhxOZRuhoutYjc08=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="onbfdV/H";
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 27F1C412AF;
	Wed,  4 Nov 2026 19:17:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496051F000C1;
	Wed,  4 Nov 2026 19:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793819877;
	bh=Bp2DPgSMAVNPpocNHMMHSMxcgQhQwNKqaFQNAmEUdgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=onbfdV/HTacMnVbqXJ+FWmQQPtyp9R0J4UgJy9QwpRXMNAUpXq4U5MgLOpJJmdqil
	 A0IpzV3lIP35dJV6mQZjczsBbIm16npn5PD8YgolOlJ1tMWq4drLkt1BRme9A6hdpk
	 hU7if+GjyblRW+XhOHwJUvOM5bncZ4wy7T8dJkSSmoqVJFYODR5oteYh/K8C4sjSv7
	 T90fJXFV4MCDOisGIN4JIrvvLoPWPs3/TneCCv2v3EeHxNcbD6g2Laj9xr6GhUYSzJ
	 UbZZpN0HIrsvDaR+/nImX8hLuzR+la3jElQ0/AQag/TzZMVgu2cf2gdOENudtrxOC7
	 u98wrpF2+gfGQ==
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
Subject: [PATCH RESEND v2 07/51] lockd: don't hand out the terminator of nlm_end_grace
Date: Wed,  4 Nov 2026 20:17:43 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-7-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=879; i=brauner@kernel.org; h=from:subject:message-id; bh=tKzHzMLxBoW/zY681xcBM67Jqe2y1s4JEAk9OycZ8F8=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9brz82W5pn1bu8jVTxGdEXE56r5qmzRPmKXZbfpl5N e9UmTVSHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABN5aMHwv1BmWTKrQaW1pau+ y7lc/V6hFSvly7z1GnL9Bfe/by3pYGSYdlT+a0yoMVdMgqbeooRHhxKrFq9gfqp47glfRsvFU/e YAQ==
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 7dasjwdcd7e841pt9wzhqjcc5hxf6uuk
X-Rspamd-Queue-Id: D13DE80004
X-Rspam-User: 
X-HE-Tag: 1793819877-379110
X-HE-Meta: U2FsdGVkX183JPhIc4OfGw9eGMTaHdE/Cyb6eDPKglE2V1J4cw9IHJDBfh5kRfmdkg7Ydj6feoeQ/ua5+xlK60CiYspUBojixYto3tlAmmGMO6F86jHocQ06fU0g+ao4nc3/7vjq8TCkiBKNzST/W8mkE+pyGjk8D3mc32t4Ei6RZU63tXGyOZHU02aWbYC/Taoa6EfN9ogMgr4R0IJmGfY/UTJ6pbsvNEIPaWS+dP8VCJZVg7ddbdcHPLxVOfvyhy3kHH8GzIszyxyhhJA/U+w9WV7BOd88m4rWipBKvvUk5w2OTZ3zu/VpIAKdoGR0uzZ42pRjyk2W1UxIqvRsEIaVrLoFftoS0rBwuNWPEJuMRIK/v9tTKyFWAx4uYVSCmR5oytLoKMDS2IfOiqAasXkN8AulVBejLCKnQNMkw8Cv8P0TcFNEkDQ4Ovs3qrhea+zk4uDmtAjBlphNv3xuw8tKnBopf74gzpHAiCvBE7jSAfRYEOXeXNTwVRW8n5+DdC6k4UEZpEnUGJmBIv4EVsDV0MebGAQCzn6aXvYlviv+t93y88BfrN0bSddZtCoT/PjrP3UzYW5BZ/oWtTVVnP4MffeDvVK+Koesx2QAY/xMOzNgwzy7ojg1hnpz6KjuS3ztkKN188DxEhyQSruhPEQCKiE6L+TpRMdcxes4O/Ji9kJyR7aObWxZxkXKIOdcar0UXXM84pp9y6CeJxZDr2iiirfaDfKifMeS+/zQEu+bHjjGMrcDpr4HQlD+DpxQGF67RFbGfvRrR+rfgCnEjwEZVuhIK9WZyIIHhnWcBG2c1py5M3X9twgdhaEB1p9Wnt+ILk+xB2RR/GtlgEesgdw0t9LkxnA77P6qCqYQwvOHhk9mlmppZEu4ZOw9mvpMSpzGMmXtCvHca0UwjRuoFz6hCM6elBs1l/zjMylw0uERIL4AzkjqbSWH7Ap0+k3Rzak3hwWJS4T7GXQUhzr
 AzqiQvS+
 ctjOyX0svwCAgTv5BpTnrb8ohCa7479H8CDuC72+U0LcECnPdESUoFogMHc3RP34i/pmRLt8ZwHa+akYW7/F8COmNeSPQ+nQd1xhgfZD0k+vxhw+LDfjy9jNTse2pA06LffoaNVeS40q9utSiSSIIsrx5XOTdp+M3bijgD6WXoE4JhXjvrbXeYHukbDFsadvEpqvHvga3DqZiZGP1DtvIewHiiIj4P7J/JjFqyqXaOT5R7W43qiKHQkNN1rE5E4wuoQrWjh1hiS6EPekOXWGsqzHqf/dAiJ5ugpmPzGvkUSZhUNKAJp6/PZmpKq9E3/BNSC42yaS6OoOqvd6nDK8GtPZTAoW+IW1rMacdU9cxmh0li5rKbROhFf2mU75TMzAypSV4Z9iDCFKBf8ckws7QxhQGUCUAPLnNjOl3SlJZQBjOMfLegM0OeAiW0mhmtGsGXWU48JId5c2ercY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

nlm_end_grace_read() answers with "Y\n" or "N\n" from a three byte
buffer and hands out all three bytes, the terminating NUL included.
Leave the NUL out.

Fixes: d68e3c4aa416 ("lockd: add a /proc/fs/lockd/nlm_end_grace file")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/lockd/procfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/lockd/procfs.c b/fs/lockd/procfs.c
index a01f08c8c2f3..74f7ab77535a 100644
--- a/fs/lockd/procfs.c
+++ b/fs/lockd/procfs.c
@@ -57,7 +57,7 @@ nlm_end_grace_read(struct file *file, char __user *buf, size_t size,
 	resp[1] = '\n';
 	resp[2] = '\0';
 
-	return simple_read_from_buffer(buf, size, pos, resp, sizeof(resp));
+	return simple_read_from_buffer(buf, size, pos, resp, sizeof(resp) - 1);
 }
 
 static const struct proc_ops lockd_end_grace_proc_ops = {

-- 
2.53.0


