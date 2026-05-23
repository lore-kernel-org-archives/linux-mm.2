Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4BEACD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 17:56:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55AB46B00B0; Sat, 23 May 2026 13:56:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5329D6B00B2; Sat, 23 May 2026 13:56:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46F4B6B00B3; Sat, 23 May 2026 13:56:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 34E546B00B0
	for <linux-mm@kvack.org>; Sat, 23 May 2026 13:56:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 04CEF140B5F
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:56:26 +0000 (UTC)
X-FDA: 84799439214.30.513F4F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 648D04000E
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:56:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CveTOEuJ;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779558985; a=rsa-sha256;
	cv=none;
	b=oxm3Maiq/ZVrYAQU7NFN8+7IY2nnVilaiAWSrjX/LknPPjMj/VcaBb6e5mnU80lxVYfxYa
	rTfv1wwAPTTJ0o3J+mXZ4NMzM7D3VrJ7Kz4Qo/3/dF75ayFrbrGcsJQ9KuRIBd09ROeDcD
	Q8N0IHFg3ikm/Q1THM1fPIyLcR5OU2o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CveTOEuJ;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779558985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=64moEsVhgfwgI6MhFHgVhfH5MiESSq4cUiaY8/kUbXc=;
	b=19cfk29VhOhZarJPjXwiJji369xFrgTvOrjZE0OUjO3L2JvpWQpvsBQddZE6wPSvs0mw1e
	+UZCX/A1E/3abj+9ce+EtLJH0oEbjUofYecBBXRkNhdOWeoKXhzf4aYxHgja3MQMQ1Jgac
	APu2Cf2gQA6oPQm/+PnCHC5cj4bKxng=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F0171601DB;
	Sat, 23 May 2026 17:56:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9F91F000E9;
	Sat, 23 May 2026 17:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779558984;
	bh=64moEsVhgfwgI6MhFHgVhfH5MiESSq4cUiaY8/kUbXc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CveTOEuJd+8kC+bH8xjZnQAePmub9EwWAVXdLRANzb/MECJO4ML8rsBSy4pLSKa0W
	 FrVbvpSksYISZvH1Z5MZbtgs9CxiG5hrdqrLB5qb0lPXnY4XumgNVts5Zabanhatzt
	 SKf24aQMydc6/9+t12q/leOfbrgBdAYUSXhlUiHVGD/YoGeJL1Jf4asA3Ki526udT+
	 OUho1AaqLkVVrZMX+o13pw+MCa0ch38JG20IOMI7GBteAYKyB1H0hGJ+66+wJQ2oXV
	 6XzMbyLsODlr9wOMo0TqSG+134+nnOMh4L23aLFTHMFEUHc6qs/zEMUbSzSTl5JWtv
	 RScWemXv3O84A==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sat, 23 May 2026 20:54:26 +0300
Subject: [PATCH 14/17] fs/namespace: use __getname() to allocate mntpath
 buffer
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260523-b4-fs-v1-14-275e36a83f0e@kernel.org>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
In-Reply-To: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
To: Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>, 
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
 Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Dave Kleikamp <shaggy@kernel.org>, Theodore Ts'o <tytso@mit.edu>, 
 Miklos Szeredi <miklos@szeredi.hu>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, 
 Kees Cook <kees@kernel.org>, 
 "Tigran A. Aivazian" <aivazian.tigran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org, 
 linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-ext4@vger.kernel.org, linux-mm@kvack.org, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Queue-Id: 648D04000E
X-Rspamd-Server: rspam03
X-Stat-Signature: 7s1hozgzr9w4uds8m19ytrjur7c61mn5
X-HE-Tag: 1779558985-324270
X-HE-Meta: U2FsdGVkX1/fq8cgKGQre8bwI7O/kZ64VL+f7nEk4hRxw0Fn1q+HvTKuT+Pxpt5kJ+FTYY8M4qYLmgdenQjwioIMN2WfbYK+4ngEoHJGKO6CUFXMaCM/fjGD/f2V7BbtD8t9TKv8RDf2km8Vq3aIaLqXKh5cm+/ARNhHQ9RsHmtizcsy3OImvmqPfTg+qMLzc1tf7UgGpC4kkv+MOyQzmC5r/HJuCQpVOygvQ1/oVv1tilEFHMHUyiAzpNvdQcC//4/jyQgGatD+8FKVPryoHoNGBsoSUMUKZXFkIi2PXwENhyQIoG5e/P5Vf4aVcnm1OlBq52ue6L/CcMs9VrWqGLMHwpVHY93cXmPTUyP2TjGqzLOKDK0KEz+Jwk+bUm71UaoJhhdneCVDxWp1ulM/LzRbBtnpX+Mazb39b3ewxZC+d45yhc2udVp2ccTkSaIAWCpAczIL2Sep3csgIQXkEbzYdYKQoCHNfPe1QywPZXCEy4K1icZjfpuZM02n3b5YLYN5Df/FoTZISAO7/1EGK/SDND05fmnirme34zp7eJUSEFQi6iLQkPa6WJkqU8iaywJa9KIrLinAv+0dPI35JSO4ngxrPXBCR3kemWrrcVw5ByrursaGfZ/QdTwM+ll/fuEbbQCF/xOwzyTCX2pMW7UMdj7K0K6FEShTR/klN88OpKo+8MF6qFqoJGLLxZrGuma4dFon43zZxGmbx9YK7De0hdFikXM+tl57+cENtpF0Au1gFvz8Yfrgiq7/OSZvgh/dKwVYp7iEbpn1XXOnR+4PhE4cD1ZAdSIb/GyK3Fc4xpCQFcupWj8Plr1OY/cOBqKhaK63SL/kd6OGUMQgMjXGMJr3/eiP0m/OONfYYF9v/KNmXo9q2Vfr6qkSHZFnK8rPiUcqrGyO87/4auoaqM4MsP1SELVrdaxhBY4ZHpOuG1DUGc4wOsqmavyHaq7/+eV/fDVa1OiSn7FQbX2
 lFOyPpSu
 ZwXEsFIAenTEE+WyJVpknnK1MsC8Kxml8GSM9bHphHVZFjRQ54lZLWWFM3FKaIbbStOZUhOUc+3iCeWkrDfCqT553u+lukfsFURRAGovKJszzbeE0X2weG/OMfVfvXRHaCaapS7ukjCDtaCrA/cHFMYKMju1p81cCAVZNqAeI1YRyyII/+Z+n6+KOkGBwdG1DGZVSDMvom4NKIE2FBSVarSXpQ8VkrUKQADzvH2hnynmWKFMzSinLtu8uAKo9ZzfwgnN3mmAGXMJoJ7w3g/4XSgBIB97lLgWdwrVYtcP99DH3+LDzuHeKKNcs+76A4FZWpnf/slViZ+it3xh9O4rif0fb0rmsdiXCegtOjcMiGW/f3WI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mnt_warn_timestamp_expiry() allocates memory for a path with
__get_free_page() although there is a dedicated helper for allocation of
file paths: __getname().

Replace __get_free_page() for allocation of a path buffer with __getname().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 fs/namespace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index fe919abd2f01..2ed9cd846a81 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3303,7 +3303,7 @@ static void mnt_warn_timestamp_expiry(const struct path *mountpoint,
 	   (ktime_get_real_seconds() + TIME_UPTIME_SEC_MAX > sb->s_time_max)) {
 		char *buf, *mntpath;
 
-		buf = (char *)__get_free_page(GFP_KERNEL);
+		buf = __getname();
 		if (buf)
 			mntpath = d_path(mountpoint, buf, PAGE_SIZE);
 		else
@@ -3319,7 +3319,7 @@ static void mnt_warn_timestamp_expiry(const struct path *mountpoint,
 
 		sb->s_iflags |= SB_I_TS_EXPIRY_WARNED;
 		if (buf)
-			free_page((unsigned long)buf);
+			__putname(buf);
 	}
 }
 

-- 
2.53.0


