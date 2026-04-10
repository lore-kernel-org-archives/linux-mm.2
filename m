Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72DF5E99059
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 09:03:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD2176B0005; Fri, 10 Apr 2026 05:03:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5B6E6B0089; Fri, 10 Apr 2026 05:03:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 922DF6B008A; Fri, 10 Apr 2026 05:03:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CA8B6B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 05:03:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0BA9813AED7
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:03:32 +0000 (UTC)
X-FDA: 84642057864.13.83F2848
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1AFAA140009
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:03:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=gUaOeiaq
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775811810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YFPayOsjb+5+Gcxzh+8/PY1jTqobcZZS+b7OL2QzsT0=;
	b=dQstzTB+ORk5b4T/KyP8qKQL9YBjELz7+DPFh/AOqF56mSWGsLcSJBxX2W7Iru1aBcQlUh
	rwStUXoh+K32eK2DUEJsfFtvKlVLpxlBqjkRIBQADZtSPO2lKus/oTP7jhxVFjWpPHBmf9
	DpqjVRp5TFlr6PLJOZCefTUYzN+E0i8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775811810; a=rsa-sha256;
	cv=none;
	b=pNW5HrY0pu0a0Y+HSUsw0x6tdwwHQ/J/XjWVDUQfJrPWwkWQbph5PN9H1gNi3fhGqlWVr8
	mFF7y3nDfv6CHE/tTabIVgsYCCBlaGAlKXhZDqt9WogrxOpvF3jYAk2Ldst6Wy929hayMH
	ZynhX+uJ0rkTsOMSSrmNhMd7EbK+bnU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=gUaOeiaq;
	spf=none (imf09.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=YFPayOsjb+5+Gcxzh+8/PY1jTqobcZZS+b7OL2QzsT0=; b=gUaOeiaqFDXf+8LIJE7yyAoW6N
	xXwIVuCcbfNoujKS/rO1JbWmXERoIZ37FxvzSkstW1CES37nqEi7r0wj+GOtHVx0wWyE2Pa6LnKOi
	XIqsTPxpvNQRwzYc7GW6xr33kHhwtqj+0m1z9/sC5aaxs46PET+w1mid796X2/XlCW92gqXKmwD7w
	wf5/hZWaHFnz+LBtD/P6DXAF+nNna8qmLTt5n1SjnYgOJAXI2MQj/9hUnHwIy1Kyds3kl9s112IoS
	e3EZ2js1uw+3fD/BWb+Y2ZLAxfXDhqlKu6yug6K1j3NYH3ydWWeMd9ZjtM8IsH4ZTcAGB7Yu9gO5q
	ZD/DH/wg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wB7lp-009rsi-1U;
	Fri, 10 Apr 2026 09:03:22 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 10 Apr 2026 02:03:03 -0700
Subject: [PATCH v2] kho: fix error handling in kho_add_subtree()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260410-kho_fix_send-v2-1-1b4debf7ee08@debian.org>
X-B4-Tracking: v=1; b=H4sIAMa82GkC/3XNQQqDMBCF4auEWZuSxNagq96jiBgz0WkhkcQGi
 3j3ol13+eDnexskjIQJGrZBxEyJgoeGqYLBMPV+RE4WGgZKqEpcheavKXSO1i6ht7zHsnSysvo
 mFBQM5oiO1pN7tL+d3uaJw3IYRzFRWkL8nH9ZHt0fOksuuVGy1tqhqStxt2io95cQR2j3ff8CK
 wBLibsAAAA=
X-Change-ID: 20260407-kho_fix_send-ae33f16d7502
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kernel-team@meta.com, stable@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=3308; i=leitao@debian.org;
 h=from:subject:message-id; bh=JQoMRroQGqF2IMGaWv58X8dTA6DCS66M2isFxCvTs8s=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBp2LzWNIW/4bf1GUexjkGfxmnk43wQDHrtZRyl8
 eiiufwcuKGJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCadi81gAKCRA1o5Of/Hh3
 bcOnD/9VQ5mEffCzXxXjp3D1jEz1BDnoezdxK4uOGDQ8Wq5ZIMDtwHfIFm7PPIcR5OT4g4XW14j
 9J8SRV4Qf4L+pnIj9NZjeOX1ik2GF+TUNOX5EnIAb5fghKP/BmndASTWVGJ0CeHqljcj8nvVmru
 r+KHfdpbapwtYNCzNiWMeytcziPDEo9Tgg9oL3UjmnCe+pZfGo0JLxyaza3zt75Q/sxbi5PNgae
 qcYpzECpDhROV0Ad364GmXnhWeZ+OBhhI5cSbBEzNpvPANS83/UFJXVB4FakpzBWvmfGN9mvM1q
 QzCNDKtRnnNxqfaEuURQl2gF62pO4vApZoDgfVqIViUUyLe88Db/KjsskUH4MWRaUVuQ8Oytlq9
 47u5/v4ROdHqYSc6TpdsuvJZqieJMlahf6KnepxC1/UOe68REWCoQQ10nkpj1oiYP+eVyNNdyhI
 BpW250VQeRWVQKEB28r0QLxya8Bt3dcroCH8WY8kcE02PgRn25LnyCcWlTUmLuiwjOjDrYpN0Kh
 uWxj+gMypvNea1Ia4a+236iVNb3qQk9W/t9Xa+uE/KwlFBejceHNs4a6UZFaK7GR+2d7JldZoQK
 G6wUaVrZ6wlcZ4gDICVGSkavPDu8eoJClms2x8SAskKdVV7pwXZr8TZJLxEmdW8al6Xs/HjMZhy
 3qZJnSNTZUgUubg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: 1AFAA140009
X-Stat-Signature: qcb3s3uqy3bz61fspaj3rhjyjs4hr7gh
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775811809-331415
X-HE-Meta: U2FsdGVkX18hQzUHin/N7jNF0YrbZioJbpIEf0QUA6xhl5L3EROHxtS7QUW5WZIYfIQNpLuBtvTTrH9kzZeAUhRAX582PzNFWQ/2Y308ZxuF1DR68ZQzfBhjW8iEJHYVEOm3306l8vb23r6fPowbMESHvRtWSxoYleIA9D0VzoYf4iFQSKSylmP9orRiuDhZb0NLY8o5kViOb0qFYwWO5/yOsBHNB5diw2xgKyGXlgU4T+ceNrZ3LM8PMTdeq1o4Iyp0prwdJSVPpzzvxx7pbScJo69BTGpsBhTIZZFPiC3+bpvFcMIJwHFfneYmRmqp1YblASJQPfS0JXRI8dEtcJ/W2rY3SA/J8ei6iYzqb8cEo9QVSbqNTn4W+VLWTI/FUfQXYHsUw8CxVERC7W6XToxjEDNc29lvE6hu2yVxUemnH2C9XFBYvSoTD0gFrblIGeT3U7Ng2lxS/xzbwvZH9BFWHIJ4BS3UbeLLhaTEubyzFbVtzPRR+eC8zHuE537KnDXq6aNDyk5T+TUF9VpNPXdS2rz9SxiYH89eNDWHfyDvGcj5UyT+Tz317GOB/0jF+y/+vjLJP5SslfMiGZCloPc4AIHOV/jWo72owmCcuR1Idmvh3HP3ccQL7mGD1woqIIVY1reVs2ZxWYeJ6b8zTB9dnVZLQwXHxHb1pR8RBVyT6rNz0Brq9VKIH5/3ttLtF2l3xn0IGM7bK4tIp0kBcmJJ6HuW8TLLa3F1QOEV3PhvGor3nn1+ja/8px3WwM//b95efJ2ID+xxwtlh4KPX7XFHKzt2ZU1oHyCsOB8WsD2TZTnTaeWTjPZMbTJoCaaBuFW4VcQ7PTsZzRUZHyWtgtW9Yid7e/Ftorsvrw1qVwl3jb3dfBGd2xKixJsMrEFYLkpeSWqMQm/igKayG7bvoPjL9B9UV7FbT4fiMtdI1c//dLkdDB/322O3WeZG7GlQr13uDKMdKRGsJCSwwB4
 IjbrpHmZ
 ryyCHGsENh6vgLWH7qlYfyfE1SiXRyczGI4fHZ6WGLDzpJgF1fGPFLy0SqgK9GjnEduuI4OVZ3zQmB5tyQgPjD4ddlDtN/Vj7HnzXa51srUEmaElvb5hXlV1A1TNZTpOuXw1gNSv9s2A7YTq1vq2eOp/LSONLsBtrkJMEvVvRQeHMympEj1qQ1po4AjpqtLbLwnF32ZqMK+NSI+p72XQAG24fHExjclj6+kK36sRT3nLybC4nF7/QL3BdrTx3HvQDT8xg0l+nev9XQLHHJmNvP+d+qtWX0oPs48XjehfPe1C4rGSH0qsmw1wEj/OK3UWtmL1P+NJoZrbqzyEMQhj5cNnH/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix two error handling issues in kho_add_subtree(), where it doesn't
handle the error path correctly.

1. If fdt_setprop() fails after the subnode has been created, the
   subnode is not removed. This leaves an incomplete node in the FDT
   (missing "preserved-data" or "blob-size" properties).

2. The fdt_setprop() return value (an FDT error code) is stored
   directly in err and returned to the caller, which expects -errno.

Fix both by storing fdt_setprop() results in fdt_err, jumping to a new
out_del_node label that removes the subnode on failure, and only setting
err = 0 on the success path, otherwise returning -ENOMEM (instead of
FDT_ERR_ errors that would come from fdt_setprop).

No user-visible changes. This patch fixes error handling in the KHO
(Kexec HandOver) subsystem, which is used to preserve data across kexec
reboots. The fix only affects a rare failure path during kexec
preparation — specifically when the kernel runs out of space in the
Flattened Device Tree buffer while registering preserved memory regions.

In the unlikely event that this error path was triggered, the old code
would leave a malformed node in the device tree and return an incorrect
error code to the calling subsystem, which could lead to confusing log
messages or incorrect recovery decisions. With this fix, the incomplete
node is properly cleaned up and the appropriate errno value is
propagated, this error code is not returned to the user.

Cc: stable@vger.kernel.org
Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
Suggested-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
Changes in v2:
- CC stable (akpm)
- Comment user-visible changes in the commit (akpm)
- Link to v1: https://patch.msgid.link/20260407-kho_fix_send-v1-1-b21977feb960@debian.org
---
 kernel/liveupdate/kexec_handover.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 94762de1fe5f0..18509d8082ea7 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -762,19 +762,24 @@ int kho_add_subtree(const char *name, void *blob, size_t size)
 		goto out_pack;
 	}
 
-	err = fdt_setprop(root_fdt, off, KHO_SUB_TREE_PROP_NAME,
-			  &phys, sizeof(phys));
-	if (err < 0)
-		goto out_pack;
+	fdt_err = fdt_setprop(root_fdt, off, KHO_SUB_TREE_PROP_NAME,
+			      &phys, sizeof(phys));
+	if (fdt_err < 0)
+		goto out_del_node;
 
-	err = fdt_setprop(root_fdt, off, KHO_SUB_TREE_SIZE_PROP_NAME,
-			  &size_u64, sizeof(size_u64));
-	if (err < 0)
-		goto out_pack;
+	fdt_err = fdt_setprop(root_fdt, off, KHO_SUB_TREE_SIZE_PROP_NAME,
+			      &size_u64, sizeof(size_u64));
+	if (fdt_err < 0)
+		goto out_del_node;
 
 	WARN_ON_ONCE(kho_debugfs_blob_add(&kho_out.dbg, name, blob,
 					  size, false));
 
+	err = 0;
+	goto out_pack;
+
+out_del_node:
+	fdt_del_node(root_fdt, off);
 out_pack:
 	fdt_pack(root_fdt);
 

---
base-commit: 8f8e4b45225ec37b0c69aace920e97148b014956
change-id: 20260407-kho_fix_send-ae33f16d7502

Best regards,
--  
Breno Leitao <leitao@debian.org>


