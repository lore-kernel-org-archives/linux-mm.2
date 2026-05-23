Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 470A2CD5BAC
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 17:55:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A89E76B009E; Sat, 23 May 2026 13:55:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A62586B009F; Sat, 23 May 2026 13:55:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99EAC6B00A0; Sat, 23 May 2026 13:55:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 88FB26B009E
	for <linux-mm@kvack.org>; Sat, 23 May 2026 13:55:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5304A93CA8
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:55:27 +0000 (UTC)
X-FDA: 84799436694.14.EEA7975
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9B4F840011
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:55:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lSKIMgV4;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779558925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KmuweU/KpiHBgBQmq/LYn9YmIagqoe1ON60urAlAxBY=;
	b=oskE2dyQaNFWNlc1nGwOMdNKbJRVbj9czLV/g9MmDP4+VkF2qduUhPhN+na0NU2IYcofJ/
	6JMB567vzGu+ihu+D3wKYLATUE6DcMMjGH7rLDorGXJQU8gvSrvmSDVVimIzMX5XvOzDz8
	brL6UrMoD3NORjzLCmpp6RRYPEbBXO0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lSKIMgV4;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779558925; a=rsa-sha256;
	cv=none;
	b=ZoneasCnIWPudshEViTCpQEAkyoGRFM2pNhYuCKtLj2fCK3BoHRcuEPuM9xKfMsQfl1IlA
	U4fr8UpWhXszqyckpqQQABTJTuxO2EjyqGLplLwgYbgJbxnL6dFhXww6K/Q6cXElMnxqcZ
	AjBrIf2P4s8595+AQgySN5Rb41xzqqo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E778B435E3;
	Sat, 23 May 2026 17:55:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9901F000E9;
	Sat, 23 May 2026 17:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779558924;
	bh=KmuweU/KpiHBgBQmq/LYn9YmIagqoe1ON60urAlAxBY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lSKIMgV425Pk6eUE5rd09QAtj32QltS3Ct51p6+09BGTmdEQiN5fqWWbJ245sUP40
	 fD+9vsAUhHfZiBF7kZk4yyCoKjlty4W70KXoxE+Ngbl0YdsNhSPh3mXM7spbkSdT9q
	 FW4lT+b8U7o+ks/hQF/nJzYdKq1MUjcxvvmOuC/5iwz6Q0NcqfULhL2m2G2Q11S6J9
	 o0NVR6VLe5fABPC3cen+hZVxg0f3wxU+YECMqnVyK+B+MhAGByBix7x+POvJzfsX4C
	 4YbA4pwrEQu1kMJT2ze16r1ZZ7qSXRvF8GvvHRFRVrT1Q4+E7RfGIzP+/4fdoFv+I5
	 DZtpEIhLt/Y5Q==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sat, 23 May 2026 20:54:18 +0300
Subject: [PATCH 06/17] NFS: remove unused page and page2 in
 nfs4_replace_transport()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260523-b4-fs-v1-6-275e36a83f0e@kernel.org>
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9B4F840011
X-Stat-Signature: w9kdnwcwas54uy5kwxzkr3ir7dwzisqn
X-HE-Tag: 1779558925-527807
X-HE-Meta: U2FsdGVkX1/EX4L4r9O32MGizOIM9gkfTeDa34aJ9dc/3bWY10Y45qlbO4TD9Hz8WNbx6M28YkekDsoUF05KAilXI/N3vI7J6aDGJEWb7i06WpDL/RIi/Or6efcCVJVHyoLyBl3cRg+9MXHu1R572TYcpd3cwWdhBJPagMn7hzT5pxtjJ5b3fvfS7EPcYTZyG3Dhl4llOQdYD1yGdvXP+ry/DKXWV+D1CYnrHIW2YDhSj8v4knLd7ZB6w1uFlc6gaDsuP6ckJRmMqVOuRU+IO/j4hCsqLFtFCpd1gqCpsroDhqaN1uRzGSJLE5/Nci7OFafYZftF33zTlkyK84mv/NcfKU7ZnLgd1yfzQNT3VhBtfkElATpkpQ6Yd1MVizzhd/5Y0NvmxUsx4J9rbToYPXVqkVkPuKMLZ3m4mWdGsKc2d542kS80Llqx84xggc0KmvUq64KHdHecSJQWx/tJIKmFMZJPLsUyEy16lHVE+QvPNXCvbMIi2Z+GIaG8WLjW+XJBkaFTFmkJ6F4vPO7R7++lVAjubTuh8LIGEAPuFw3iB0JLkokgi6WupvhaPHlTVv26is9sNq7r4xsqiXedA00l95mT0bPCzE0VfID7JOswab9nTKyAbAq6z0Viz9YyWSZI7ip2VQpdV0BxlJJjQWZYow054ips8RS8tOz7WeQzAKudn8NleUDauHiRi6jPh6Ap89526cCJYfLDGDh3t//M/a2GRgSNcwEPjMauf7ZutSB7Ppdk45wlUQ5zCcug5zAOHeB1r1GmV1Pg0ZOjg3EqRssEz9NZXDuFZ2GE7f/HOeZx2m0SPAthZoTQBNlH5Hh90R9DxwpyzVeB2Q5pAw1ocecyazaGz7MTOZnUpEhIW9/78q4sGqR1rnyk+d3GrFWC8KzZ6P8+/7JmfF7+Nfe/TCQeCOqCrtqP4UY8Zl0Xt57SBBa8v9cmLzI4kIc0Up9CFvBEZXeWcGu1LQp
 esv1q+YQ
 ZH7C57E8jHAXTHSrlnLeb9e2ou7P3DP4g7olFqRxfrRvCTRCBvVaq7dxkFbHJcYuiKbnyAK6wv/i8UMFo6Jf776sZEfO4cY1WfHHYsOArPukAZQgMRSR7kxZFCIu/9I2ARft/nbMr7jto3SKD0pbDMIWuU9o0GzEmmmpYjI+lRcSkpCK3lzcyJm4mL2vmdOt4RArWKPhP8uFR1e8LqXwSD3JzoUkpsH7Hh163wgtbwZ7I+xE6NCUpBB5PWqBQpmuJQFTvSPeFdTzQGp7uJ79aDEa79/EsMxQbz+bxcD3RJK7pNVMLVJu7Y9H0lQa7/MKJDp16xNKE7KOhGlmJ/3NRc/NDqtlrtdTKiigAQlCqlkcfVq0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Temporary buffers page and page2 allocated by nfs4_replace_transport() and
passed to nfs4_try_replacing_one_location() are never used.

Remove them and the code that allocates and frees memory for these buffers.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 fs/nfs/nfs4namespace.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/fs/nfs/nfs4namespace.c b/fs/nfs/nfs4namespace.c
index 14f72baf3b30..2a03f02bba7c 100644
--- a/fs/nfs/nfs4namespace.c
+++ b/fs/nfs/nfs4namespace.c
@@ -481,7 +481,6 @@ int nfs4_submount(struct fs_context *fc, struct nfs_server *server)
  * Returns zero on success, or a negative errno value.
  */
 static int nfs4_try_replacing_one_location(struct nfs_server *server,
-		char *page, char *page2,
 		const struct nfs4_fs_location *location)
 {
 	struct net *net = rpc_net_ns(server->client);
@@ -541,21 +540,12 @@ static int nfs4_try_replacing_one_location(struct nfs_server *server,
 int nfs4_replace_transport(struct nfs_server *server,
 			   const struct nfs4_fs_locations *locations)
 {
-	char *page = NULL, *page2 = NULL;
 	int loc, error;
 
 	error = -ENOENT;
 	if (locations == NULL || locations->nlocations <= 0)
 		goto out;
 
-	error = -ENOMEM;
-	page = (char *) __get_free_page(GFP_USER);
-	if (!page)
-		goto out;
-	page2 = (char *) __get_free_page(GFP_USER);
-	if (!page2)
-		goto out;
-
 	for (loc = 0; loc < locations->nlocations; loc++) {
 		const struct nfs4_fs_location *location =
 						&locations->locations[loc];
@@ -564,14 +554,11 @@ int nfs4_replace_transport(struct nfs_server *server,
 		    location->rootpath.ncomponents == 0)
 			continue;
 
-		error = nfs4_try_replacing_one_location(server, page,
-							page2, location);
+		error = nfs4_try_replacing_one_location(server, location);
 		if (error == 0)
 			break;
 	}
 
 out:
-	free_page((unsigned long)page);
-	free_page((unsigned long)page2);
 	return error;
 }

-- 
2.53.0


