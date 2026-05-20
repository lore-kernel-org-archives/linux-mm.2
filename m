Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A329DCD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 08:19:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1381A6B0099; Wed, 20 May 2026 04:19:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10FEA6B009D; Wed, 20 May 2026 04:19:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04DD26B009E; Wed, 20 May 2026 04:19:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E87266B0099
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:19:23 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A68DB1401F5
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:19:23 +0000 (UTC)
X-FDA: 84787098606.29.D2DA27C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id EC60A18000C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:19:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fcgnwf+N;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779265161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zQRjpjIyAer953PPORKHqLJlFZ+L04n/ATscYla4KeM=;
	b=kCHLo2DD6faoy59L4cvNnV29ScPNZKbwsTcYpjMXBek4JU5QUj5hqzqxZE/YeltFtKQs6I
	J+Dx4Wi0cp6v6zht4oirDecAjxJa/nE6AYmbZSCpwfICxX3q8+1vPks+/OZk12FdPty4+Y
	vVEVcgyZGEF3PRQlzvXtvt4dPhWjsxs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fcgnwf+N;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779265161; a=rsa-sha256;
	cv=none;
	b=xY5hBepP3+kec+G4YdawSeunknuo7KEqfw+gzDs7o0NIilgkLbIaz6z/CWr+lfOJnUdwdw
	zNg5h8p7LoaKqWarKJJpN3P5rcFSSola0HtyBTRlmgTdM4Ydw4NPB4+C1jnSvrRNX3OjSX
	nKZB4NAyheLwJ03JflZp98ASGZVHAUY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 69B406012B;
	Wed, 20 May 2026 08:19:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BBAD1F000E9;
	Wed, 20 May 2026 08:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779265161;
	bh=zQRjpjIyAer953PPORKHqLJlFZ+L04n/ATscYla4KeM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Fcgnwf+NkTvhc7Mit+rAGitTzJZDlSEN/uHXD+gkXTB4npyMOpLlukZugq5ohxYtX
	 lp6Azi92eVPhKV2Of6k/TAuTwG5evXZE5iWXANKE368n2gb20O7Yk1D8poK4bptGLN
	 gKe8i674mGmddBOIeCjCdBQZB++cVpQ3pABKGDDtYv1sDVGuBJybOROagMRccDcSYN
	 IOJ+03oCmUzYmIeuCTV917LSALVXG/MOjKC37dj+ruYComBK3Zm/MddcvAxEHycf0d
	 5NeR4M53U0lDs0Dt7niUyxN8BHwvrWRr2eCyzFovqPzYoGX+jRtPZSSK5eflbyRre6
	 JMGR0/leTjL/g==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 20 May 2026 11:18:56 +0300
Subject: [PATCH 2/3] selinux: hooks: use __getname() to allocate path
 buffer
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-security-v1-2-831bd8e21dd0@kernel.org>
References: <20260520-security-v1-0-831bd8e21dd0@kernel.org>
In-Reply-To: <20260520-security-v1-0-831bd8e21dd0@kernel.org>
To: James Morris <jmorris@namei.org>, 
 John Johansen <john.johansen@canonical.com>, 
 Ondrej Mosnacek <omosnace@redhat.com>, Paul Moore <paul@paul-moore.com>, 
 "Serge E. Hallyn" <serge@hallyn.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>, apparmor@lists.ubuntu.com, 
 selinux@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-security-module@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1022; i=rppt@kernel.org;
 h=from:subject:message-id; bh=F5N75Y8mUQYU1TgbgAwnzxz6xj0Y0zUFBQbr3qsftFc=;
 b=owEBbQGS/pANAwAKATkDhibLDv2RAcsmYgBqDW55/xeAuypW72Duwu823AN1y512GZtlik/jj
 f9D/szH8CKJATMEAAEKAB0WIQR45VhVpZkvn3TRr+k5A4Ymyw79kQUCag1ueQAKCRA5A4Ymyw79
 kZuWB/43kQ89qeDN/5ULkrNOC7BisGyehYajp/+I5dGOiekEQFVDn0eaXHd2QTlf2f+hnv9BbpS
 fupeiqIj/Ou0trjtruRc0roPfmTRWNl9OxfhUuaSxc9GbFpfOSSmDFlvcmAvuVfqHGwLIFMFssG
 8mm454MTwB23N3EFSGJSY2MNo4gGywEW6qmCrvBydmM27UydkD17stPOyxleOIbhjcFw9EU+Tbb
 +ElbtkFJ9OCCiKpoaEQ2mt0A6m1jr7ibLlu4TaUUYxaBcV2k/0oDtw0F6cQCRfH5oKGirJnU7/p
 mu1k/3MeSbO7pTCcTcyGil3l1Jnug1PwZNhjPyZbODCzEwv3
X-Developer-Key: i=rppt@kernel.org; a=openpgp;
 fpr=B8E96E880C4A40C3C1255AA8C532392DE6DA7CE9
X-Rspam-User: 
X-Rspamd-Queue-Id: EC60A18000C
X-Rspamd-Server: rspam06
X-Stat-Signature: mr8acqte8c3h5iogpbqp9sbfckzzyno4
X-HE-Tag: 1779265161-577080
X-HE-Meta: U2FsdGVkX19Pyz35E9q8c/EvU0CfQ9AvLtmtK+WploU89U/1LKDY0O/1IWNs/Qb52dZFLPcj6n/4It2A2U1pFzMrbZWME21UyoN/Xi42KG1+9FEkItgn+I9cKHT5KZjCjaS7AEP/aFF11vk3Mf/qzgk6Sl49u1L9OBLSUPpU2Kvi+q38ADXsisVZtadFvcey6amq83nkLhdK2uv7aBofVfhQV7ExmfX4N5/9s22fV6JEDN/ibQJA9TLEofGOKHV+dBjA/xaCTBR07j+960vzbpjtCmZJlSKEWyseENT1VYE+7sCGhqT8qzGj6YMZqbl2L83+bcLgkec9MlPpr6mek9aZr9vKDBubduitgF8P2ZzG6jgvQwQ+8rBxz1b/GgjhtJoFvBv/PDBeYeNgu0fX+4dAVrQUNGO6zlxr1xFI8t1RlSYxo6PjWNvysfpY9wEe/tgASICjOOEzmkrZY+tEb27RWoN2WIGPPQkeBuV+9kcVch2fhnLNaMhUWEbu/XlG+DCCfOMF2oagww7Xgb48PsviFw8CRqN+J5+jvlo2ji8pxg68R5tuXT3MqgRcyVD04b/WSXHk+/7DHEKnLnO44v4cwR7dBEIhKkvaErRg2zDEE/763my8+My798k+seEJWamC0z/aikkEE/ulys+SlaCP+6Wn15PV4I9qyVuiUZHlNyva7VTj4t6UETgNCl/uiX0uYF1+Jzq7yZQYFTYIovio8Eu4JkpSat+PfTxJ8iiMXvzdxtTmZXDERDNZm0JjgW7Nk0zhyshEeyPv9zpaCxiSjItSMC6LJX1AYcZVqbrU/IyADotx/glNmJhY5+9i1bF9sMi4yKREkdTGvVCyuCT0wy9tAJhfAUaDXEHF1gwSSoJfN72vAsQA6QSc9fh4fxWQ20XlRnnRX8iDOQ68WO6aPWicZT98y740dX32gJNvIshM4vreUiWfy9RUqpvs9tMcN+5z7T27N4uQeC3
 F4mLB/p5
 wEGojBM1T1l54054abg8FOa7rrV3q6up2KNUWCNkTZcXtN01Zt30F9CGSMx5w/NcnVyMrXoq7zvlruQL++azXwujm+a+FjHHnq8Kfp+/mp1Ck9ihFwMGZupfMOLr1e8Jksv6RiSS1FLr/xZ187ElXhRnw+TkJVSqfI5YnAwXxw8Xk4w86lYQNOH+w/3JxKYNA3ljZnOu4V0nX77OGP16+fKPP/pD+bdGYX+MjVP2R0AjdvtfPtMR8qRZ7GIGuBjjb4vb7Z1XCbTk/LrsNXXzAobvnW68tL3M9QL1XZRZdqhDs6dBT1Mjfjq6YDXMa00+MeKbFgJyFeK9S/xBVvu+Rsk9VXMkJDl7IeF0GavQdxO5ZNgggXs25zOOdXRiQTayLDHSEnOVzXPSHGOY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

selinux_genfs_get_sid() allocates memory for a path with __get_free_page()
although there is a dedicated helper for allocation of file paths:
__getname().

Replace __get_free_page() for allocation of a path buffer with __getname().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 security/selinux/hooks.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 0f704380a8c8..05b84b3781e0 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1336,7 +1336,7 @@ static int selinux_genfs_get_sid(struct dentry *dentry,
 	struct super_block *sb = dentry->d_sb;
 	char *buffer, *path;
 
-	buffer = (char *)__get_free_page(GFP_KERNEL);
+	buffer = __getname();
 	if (!buffer)
 		return -ENOMEM;
 
@@ -1361,7 +1361,7 @@ static int selinux_genfs_get_sid(struct dentry *dentry,
 			rc = 0;
 		}
 	}
-	free_page((unsigned long)buffer);
+	__putname(buffer);
 	return rc;
 }
 

-- 
2.53.0


