Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12355106FD62
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 00:46:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 718DC6B0005; Thu, 12 Mar 2026 20:46:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F9EA6B0089; Thu, 12 Mar 2026 20:46:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DC3C6B00A3; Thu, 12 Mar 2026 20:46:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 494C36B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:46:42 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20D03C1F24
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:46:42 +0000 (UTC)
X-FDA: 84539199444.05.E314EE6
Received: from flow-b5-smtp.messagingengine.com (flow-b5-smtp.messagingengine.com [202.12.124.140])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2343340009
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:46:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=mRnZ0YGC;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=Viy4tpks;
	spf=pass (imf11.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773362800;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uW0rtLXFkbaBWXfGN4/JFrVlhcpfsZme8A1/pyxgR7Q=;
	b=OsrNcWYpO/H3jUoE61nqmdI5RZKDU+2MsaZgtUsZxDgVwrpdjEmWvGVHst1OC1MAufO1z9
	MiIFTZXTaI1dKm2DN9uecIdfdu3tGgMDmTJzdTC3c1dKe91LI6jy+bP2dEpPwBPTOvwYOh
	y1F3SWzCl2Vuw4cEFvRsN7GxzebEHRg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773362800; a=rsa-sha256;
	cv=none;
	b=M25QOxzkJywkqEIDdGtybWGGz62A+o3tHMQ5jpad00MIcP86YWhWGZQFgHHdtekkhnfknl
	mToGNlEJdpP0GPwYAaGCn3S76MURHXU0ylRVwnoXj6m1L6yFnxvJfIx+Aux1szDKbQ/Urk
	vK3p2GxSQUCF6S8qL0IjrBreDKZFx0U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=mRnZ0YGC;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=Viy4tpks;
	spf=pass (imf11.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.stl.internal (Postfix) with ESMTP id 36F521301B63;
	Thu, 12 Mar 2026 20:46:38 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 12 Mar 2026 20:46:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773362798;
	 x=1773369998; bh=uW0rtLXFkbaBWXfGN4/JFrVlhcpfsZme8A1/pyxgR7Q=; b=
	mRnZ0YGCx3gLm0wWBHdN72SdQLIjJRWNHgfmRzo1EeqngvhpXsIr4of+UqGu9OeW
	pUmJLqiIiGQHyeSyktpTCMTAETBXWvPA3OSWBncolVh/nheFGMbFXBXOVYOkqc7j
	FlCEobV9Mp281to+TUFV3T7YHeRK8mPY35N/T7oIyDl6/vfGeOlanFxYy27FByF0
	Wz8wZEy8G8xWc1POLg6uW+P54Kao4gR50BRmV33zpljxSDZ2XKTOWwnbzyaHHJgQ
	q/l/0Jn3R6TRw9lfxXdwBt4cADGARrgvooLknBc3Pk8nLE8+yFY5yj8xeo7zbuLn
	MvAJD9QttjXchwHdcv0txA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773362798; x=1773369998; bh=u
	W0rtLXFkbaBWXfGN4/JFrVlhcpfsZme8A1/pyxgR7Q=; b=Viy4tpkswwmJzmT/i
	EILuXqKRFNSgtS2iM9oKc6cjwsKTDd4DN8r1iNUHTfMZqZQOoA27qlLOy+aNCqfl
	scyU5vWIq+dNNVGQzb6L4jTw0gApXgrVxp0OlD5OFr2m2WRVBn5F82cAVUn53wKR
	Rh8CbSYEov+8EEP9iox4dX9pctgJyfOQIu8fkTixZcVobtZOl9otr4gzkcB2LYhN
	q62Ie+fo1atQQJKNJwG6CvWqL3NiRqbZG2j0AlP0L1gKhb7vwzLiXxVsR9jCHSo4
	JHgWRp7aaCFWITa39njjDD5hka9V7wBP3GzeawT/o7YxiSRL8CvJFxM180AOUpkX
	pAkMA==
X-ME-Sender: <xms:bV6zaZ0TCkmKV2ZwVBToDWEWC4jOzc_x0nlMkb5ni-SVAxCRUXniGg>
    <xme:bV6zaTwiRPiTv8mpE101Dr3w-YJr9yJbIee2tX-EQt8kF4ZvwO3Zlwv1PTpAtIv7y
    dWWpP-Hwshx3Zru2-rj7xWwVkSg7R7ang8JVWd7UAdgm8sy>
X-ME-Received: <xmr:bV6zaU-JZnk6IIzo2_kDBG8GVZQm_eDRGKO2eDo6ChrnCuVTi-nTfMPX7AJOwVLG82zOMWUbhwJWVQ6lhxLICbUADyYaBqXAGM4vtSBppUFL>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeekvdeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhhrggfgsedtkeertdertddtnecuhfhrohhmpefpvghilheu
    rhhofihnuceonhgvihhlsgesohifnhhmrghilhdrnhgvtheqnecuggftrfgrthhtvghrnh
    epveevkeffudeuvefhieeghffgudektdelkeejiedtjedugfeukedvkeffvdefvddunecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepnhgvihhlsg
    esohifnhhmrghilhdrnhgvthdpnhgspghrtghpthhtohephedupdhmohguvgepshhmthhp
    ohhuthdprhgtphhtthhopehvihhrohesiigvnhhivhdrlhhinhhugidrohhrghdruhhkpd
    hrtghpthhtoheplhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgt
    phhtthhopehlihhnuhigqdhunhhiohhnfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpd
    hrtghpthhtoheplhhinhhugidqthhrrggtvgdqkhgvrhhnvghlsehvghgvrhdrkhgvrhhn
    vghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqnhhfshesvhhgvghrrdhkvghrnhgvlh
    drohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgv
    lhdrohhrghdprhgtphhtthhopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrh
    hnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqvgigthegsehvghgvrhdrkhgvrhhn
    vghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqvghfihesvhhgvghrrdhkvghrnhgvlh
    drohhrgh
X-ME-Proxy: <xmx:bV6zaURQUqK7qStcEfBYEQoAD1P18ucpMwXvlr-DL_YTmyo7L2VCEQ>
    <xmx:bV6zaRliEawSSwBZEwMHHG8pZKoVeVe6fhRQtiX7dooLuJttvoGjrw>
    <xmx:bV6zaUbCx4vBc_niiX7uOGRwHKN2ZFDRChpwvluVOhl7nwRzhzSSXA>
    <xmx:bV6zaUn0KDBxgyFjvzFEL1i1RlIoxe2Y3rIXUnDbkfKcTMCUjOAtEA>
    <xmx:bl6zaTDkJoQfeWw1TkJRJdYZcxYzB-qvjzkaSUG4eGEgydjZFqIno2Zg>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 20:46:24 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,	Carlos Maiolino <cem@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,	Amir Goldstein <amir73il@gmail.com>,
	Jan Harkes <jaharkes@cs.cmu.edu>,	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,	Steve French <sfrench@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Breno Leitao <leitao@debian.org>,	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,	Alex Markuze <amarkuze@redhat.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,	Tyler Hicks <code@tyhicks.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,	Jeremy Kerr <jk@ozlabs.org>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	coda@cs.cmu.edu,
	linux-mm@kvack.org,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	ecryptfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-um@lists.infradead.org,
	linux-efi@vger.kernel.org
Subject: [PATCH 25/53] smb/client: use d_time to store a timestamp in dentry, not d_fsdata
Date: Fri, 13 Mar 2026 08:12:12 +1100
Message-ID: <20260312214330.3885211-26-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 15saji9x4djmwnq4x4idsw884aukd6r5
X-Rspamd-Queue-Id: 2343340009
X-Rspamd-Server: rspam03
X-HE-Tag: 1773362799-421071
X-HE-Meta: U2FsdGVkX1+Gu5c/CUqFbu7aeH03QKjSoCVIrHZt3fl0g5a7sBix+kBMKcaiaEsP5MdjcwbWNPkynvm4D30Rq/ygt7u8t069VsibsaGlXw667MfnDZzilIxE4+be6O3XrdFSM+JWaIP9/+tGYN9sKmX/DRDJq9TMxzZlLnPE6qfT0xPz3aXdtmrHVQMeaWxc3ijcrsEoBc89bL8jeTxmB7TbWqY49a/IaqD5Ay5xUtkH/SSzMiHFf1NIOpFAeBdJa5JTIIVzTdKTmX0GWWFT912SsbHm+nc3VA67YcEjNv3WkrDyN66aKf+enpxSCP7ijs9LPxo2vJKNQVi8t9z9CdWPPxztCveQfnUBy1xhJzLn/TR+NBHLyczRiPLmqVTCmf8dbKxs5Nm3kU7BBeCmPqYKXsEe01//k3OxFKDjrCQu4x6Ce5w/lBBQcra1mWGRiHUKQbhGsOf/Yg5bB+B4PZQ9wnCYB+hJELlinSnjpwPWHPDWKxHxW9YHeVT8A/pXIoAANlcI46cCMZbU0kKf5bd0tBFOwbT9ZWKYwYCe8K4K6abfR7LRW3vbsLLwAC50e0yLvZuZ+LbUuxZGxtVmIk4e9q4VDBXTvbiDlu/UeXzJHveTkXcUJaWMB8+UB9JC6T8fKpTvVEg/n5NNV8TaH5BzoikAegFMD0rJXZ6CBmGQoPYpFMtASAFmsntyaEbtAIv4TyZPK3OXrkX+jylzWie7qyeFqS7JMMJLhjvWtY7vfxJ3KI3j9p/zCCM2dINVVs6EgmrKU7nLfszmRYh9+LyDrSoH493FCoHyE7QbKwVuADKPtrCq8bK2ThTJQiODYt8VX+We+VfvjYr9rcj5hI6S5x3T5THc0zp7jyEvlxjS7VbWe3paoj0iSz8vipZNwB23zXbNhbl5Jv79B5cbC/1tr6Vj2fkP1NtF1kUXxFrg8aTbNgsh1891RgldBQDMCmQRoFg6H404zAmTqrP
 7zeD9whn
 GhY9mhzv4bu072xrpDgABKIp/6so/RwlDUxeBC/4MPEdnxEyW1XClvvE1khVWDmPAu9l25Wo4eD10FQmmZgU3DfafBkJofr7XzAPgNrjVGJOwpCeF+X9oV/Rn2MNPaOr9Z57EcXczB5YGJFla/RfGQ+CuBzCEZGw68Kqu0qwMqvydBT+zJVCigKb30+IrGeKDOgkcidY8ECts/Q7DKrr5B1nXL+AOFzPjX28ehvrDg7MV7kGPBMQnbE7fSxBdO9XoM562vP6aE2FBWtEWdF4RE5H67UfP3qgDm9M2VVpQfF9X5XPMKVp80OnhXHAaeNB+eavzUCoACHHnyoJdcaFP33VEvCoHELr6a30NJDhatz9a+TCtjRrH+ZGMikqAmA13NH2rs9ztfGObs78K9sNmS0VMvznZ/uBwb9/18WZt84a/3EovWb78g/qE8vBjJp3GXGbRYSM3CR+y4/DQzuy5Gtp+ZaHvluja33YfMYz4t62GokzvKTRLsfmTs9UIGDw7yeqxUuz0Tgm6IofURyCIT23DE1oJgmNIDpERNEgRBXH0gID5LPb9w+yzg6KJ1/f3TRC/qFJuWR8j+orcvEBhP6cyG8kqS2p7TovmYVySVDnlfOghXZxlsu3Y9zkrALaurYMaIjaGF4XxgS4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

smb/client uses d_fsdata is exactly the way that d_time is intended to
be used.  It previous used d_time but this was changed in
  Commit: a00be0e31f8d ("cifs: don't use ->d_time")
without any reason being given.

This patch effectively reverts that patch (though it doesn't remove the
helpers) so that d_fsdata can be used for something more generic.

Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/smb/client/cifsfs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
index e320d39b01f5..5153e811c50b 100644
--- a/fs/smb/client/cifsfs.h
+++ b/fs/smb/client/cifsfs.h
@@ -30,12 +30,12 @@ cifs_uniqueid_to_ino_t(u64 fileid)
 
 static inline void cifs_set_time(struct dentry *dentry, unsigned long time)
 {
-	dentry->d_fsdata = (void *) time;
+	dentry->d_time = time;
 }
 
 static inline unsigned long cifs_get_time(struct dentry *dentry)
 {
-	return (unsigned long) dentry->d_fsdata;
+	return dentry->d_time;
 }
 
 extern struct file_system_type cifs_fs_type, smb3_fs_type;
-- 
2.50.0.107.gf914562f5916.dirty


