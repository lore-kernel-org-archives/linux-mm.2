Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12EC9106ACEF
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:55:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61A2F6B00D5; Thu, 12 Mar 2026 17:55:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 604FF6B00D6; Thu, 12 Mar 2026 17:55:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D41E6B00D7; Thu, 12 Mar 2026 17:55:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C20A6B00D5
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:55:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DC08558D5C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:55:26 +0000 (UTC)
X-FDA: 84538767852.27.FEE7EAB
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf22.hostedemail.com (Postfix) with ESMTP id E28BCC0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:55:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=H9EUTHF4;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="mgyMS/w/";
	spf=pass (imf22.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773352525;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3if7F0C5AAC1JbkpbjSMCxjLy6rTA44JQ48V382ux68=;
	b=OTCeJtyjBGPKose6kWF02bZwyXTbNCdw29EGioOGV85N4qWzxk0m/tSA03xf5w/L4LUuOT
	hzDTwL8jEhL9wYsKT8gZYr8nM7uaL4ftJzbAlumOFLZQVj8kIRadTEIH65fMcnKW6vDyr1
	Vjgxr6oTvJJV9fHpZCaZ7l9N2LRPCn0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773352525; a=rsa-sha256;
	cv=none;
	b=IYLuKC0UGqf68m8DJeZyj12nbohDCxcb4RKKXW6lcRn7XD85/BmgG9nqrOPTx3S7jsHVxT
	suxuuMAiEEjnY2x0iY7MU+92EUbn4qKum5yQcOKVlSVKqGgA5XpsyyA8oCOoYX1ILJM/AB
	YsdUuG7cs+dMMllF1iBwq/l29dL/KEg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=H9EUTHF4;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="mgyMS/w/";
	spf=pass (imf22.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailflow.stl.internal (Postfix) with ESMTP id B10021301BB1;
	Thu, 12 Mar 2026 17:55:22 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Thu, 12 Mar 2026 17:55:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773352522;
	 x=1773359722; bh=3if7F0C5AAC1JbkpbjSMCxjLy6rTA44JQ48V382ux68=; b=
	H9EUTHF4r4ntt850sUfeaQwtq1wg4xsapXTK+Bmbed5aBY6rGmecjBhkdb50KJJw
	yozmTs8rF52SI0/+6uErAmNlGCje+eaAeWizSuONzzKl6bXgUCbXrhvC50Ypb7Af
	BuGa9IVDBtnD0iI8cWgMLPEUvMmEROZjn+AsiwMbv31vHNMtLCOR4d07pF0F4Lhg
	SNbbwsak0t8uJDaZE9lEde5l/a/YGjv6Xm4eNNckpbnB0IlGBxn/KhnzKdHNNzFZ
	knquaTl2pgOiMYO5E3YdT59XdMgZ0B1OMFY55kq1VrLl65vHBs54fKiIaiYZmgZO
	fqr3ecAc7MP8Ib5llOeGMA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773352522; x=1773359722; bh=3
	if7F0C5AAC1JbkpbjSMCxjLy6rTA44JQ48V382ux68=; b=mgyMS/w//zLJozQuG
	iBMTVjEfl0NOrr7Zw66UNwTwbYxizmZhVHmA+lAQV7/jBPswUdXTZ/qZkmNM0DbI
	hKs8be9mTKQLa70XyuohH5vgJkcJ1Lf8CHfRHjX7K138+x0nvdCHx2JEpJOh8Q9K
	b7tWB+BgUW+qbsdIbWL49y0BSSPZZBWkUT/0NROD3UXKrVMw/3e1jvhZvGmRDQPf
	rIucBRKYZcMMA5TWkb9RLF9azs/HYd20sSGyOiiSqcmLp07MuJSg0uO1QiHA+HDc
	kRdsREoMdkfSJ28UBPTNkNY1lteIgQBwopJWj/nyyb32cXnM/7f4uBkmUlEFoI/+
	ZjyBQ==
X-ME-Sender: <xms:SjazachlAWJOSN8lEQ87olBQ4THW8YdF9RlFWlc9v1XRyDGCmGTfvg>
    <xme:SjazaesTvDYRW7k5iGIwjm9wIQkza8VuF4_UiMEvTBY5e4FYpn8LFq750dz1l4Dbi
    5jkSM07bgIUuiPmW8hzI3cpP5dADZ3FHZwwfkLfWGcWx44OaA>
X-ME-Received: <xmr:SjazabB8Fiq6DqmKllIMxsq_KLyOsejW5MZSugEFwbVXYgw_6r5d_7imDhHWM-mTZXu0THro99dT64wYsu4Hzq_iSBjowV-xxI_6AyXiDiTE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeejleduucetufdoteggodetrf
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
X-ME-Proxy: <xmx:SjazaRVUEVbr5DICwZBK751qOvfjCumW4QjiWYsKS2grgUvd77XOSg>
    <xmx:SjazaZIyen0EDW-Ii1W8JpDgpqmir2JNlPjLTK8IUePBHyms0uCV8Q>
    <xmx:SjazaaUMF9hRGxMFgBbvbfSm7iXGN_MPHRezxnabrg7dw7H8WZk0EQ>
    <xmx:SjazaSR3lRAk_iK5JZ_cuPeri7l3gQKqEqg_Vuzki0vn4_fQDAwXYw>
    <xmx:SjazaXyIFx6sW7VqeUJx3htwVItRXiIok1LvXEF8SiWSLKfBtXaSuRZS>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 17:55:09 -0400 (EDT)
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
Subject: [PATCH 41/53] libfs: stop using d_add().
Date: Fri, 13 Mar 2026 08:12:28 +1100
Message-ID: <20260312214330.3885211-42-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E28BCC0005
X-Stat-Signature: q4ht3q79hh1qynh693kokyyhw1mrgyu5
X-HE-Tag: 1773352524-607477
X-HE-Meta: U2FsdGVkX19A9nvfT8KEllc+MKGGaWF5m2ZYdFSFdmGwcj4GrAnlDKnQvGE5QzfdJiy5snFGQkCfjh+61QRMXz0USdp3Pzo/B+ETKIgc05Z37mSvb5DAzD/nZhjAM9NFKxjNNckgy6Ca0k1d38WRsz241odpSkuiEveCe3W/XyusfUjLx72NPcDuZk0qF0nAa0p61/TFOYPOGKlykId8qZyrobwpThqfpjmPRlwNA319U3Rnd8cInL3II6rmo8/7UR9M/HG63UX0KGJVVONo7P3UZw9f0ftPCyB6QeoRmcZzN9DYXGlxuSRG6kNGZ5vzv0CdlIKgIdWQ1dfRrNgFGojr3JXIembrkAsNoQIhvYKQZyMG82kopg8qxinh7g2kAYGb/skt+eao2DDnWCHpYfJ4pxjygvcknsRJfVB3WwcouRejW4Eieu80Sxqdv004h/j2I95b/78D287phMU3x6kzV1bd6osBoUaPZyspl2UOegCeeWIJ9ER4BkPVB/V9IS5c9rwq6pkN0LflU+56f4FcUzeGk9fVQ96+jS2+kzkWTaspjsvtcBmcNQy8+nXGl/uvA7Z5UGj0QdKvz/aEe1m7lcVOKaglDiuvHj2TW6/Fom5O06t3F18DcSjFP1VDwjaIN2VqnH2659hNEKmsbUO+IW92pCy2HIbDH+vgPF5nmOeztBaAIoDCRaVG6pMyCmVrDLNomH6FA9fFEsDumL3VwtQIEAI/CxCPv0keBQPE1l+J4h6kFpRNKyS8GrgHJjaQoW8ayBi6CSNAek/Af0ReRVZ6EwQ2up7A+7p1xkiad4LgPA9Xs2cEDTRS15sBmSvjVeeK4mTAvv7h3aQwW1sAjQjKcHhCTWuRvV8vsJCc7AHCG85yovEYkaQpRmncw8/oK0MVKrUYdE4ihUJYyd7T8evFQmcqLuT5faAw11CYaENPjS0YpuF+VjA8vMblgTGoY+i9OvTcZ4lTCBb
 Hk9szzUt
 YnRIdF0RefKsWKoKdLbSq8La0fRFuRQKdvB9tBYNigiefgJ14YuqGqICVGyKa5yW7DLiolk5H84ZdPlYPb2Opw3gkPDRCEXjE8W6OGRRGzQfTCAHsUq5NxknEI+lSPw6A1XkdjXtFzvqbS7Nt9m6V7cEW0+vePB+Ps5G8iZFN75UbGCojyNi2G4CEtFq5R8D4AuiOtwRemLsOVbKm5sS9wLz0EqS4CqfviiI8crb51LD88w41A6zAczC46w5h17xWU7viRDbQuOqt11XnJlc0B0Sdiddv2HZzkCfWvEdr62I30nX781KaTFQlSvVzTM6NNqK23TwibqmcgwFHTXFx/NZ5Z1+40FMZyDzJdzI6Fb8eCM9BqK4MT3SvEhsgCQXKC2Qop3yQr2V5j2tes0Qur+J6i3KW6C7D0+gCaC2NFqQL+l9pKxPKxB/cuU8yg2sKeX+N+2iJ+aWw+99TyrU+wVC44UNafMh3EIR/sTd2Ef+RyJubTMjhll9veGHqwwn3ZbxgmyLbzQYkkzJEMzZKig0aEmPjkLW5C/vDamebDT0gbLq5Hh6eXTU1AnFi1i2nI6AgL72LgmNxmYujtF0Xa99x8p/pzTZmr9NhQQ2zuvHhBfjQHUWwQEExOu5P3f5Gwqx2Q+jmwGAR1ML/wSG4M4GmPMrz+6f6eG9kzOi8z2LQkcM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

"Best practice" is to use d_splice_alias() at the end of a ->lookup
function.  d_add() often works and is not incorrect in libfs, as the
inode is always NULL, but as it is planned to remove d_add(), change to
use d_splice_alias().

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/libfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index 63b4fb082435..75f44341f98b 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -79,8 +79,7 @@ struct dentry *simple_lookup(struct inode *dir, struct dentry *dentry, unsigned
 	if (IS_ENABLED(CONFIG_UNICODE) && IS_CASEFOLDED(dir))
 		return NULL;
 
-	d_add(dentry, NULL);
-	return NULL;
+	return d_splice_alias(NULL, dentry);
 }
 EXPORT_SYMBOL(simple_lookup);
 
-- 
2.50.0.107.gf914562f5916.dirty


