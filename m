Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8009A106FD61
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 00:43:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAB8C6B0005; Thu, 12 Mar 2026 20:43:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D82CD6B0089; Thu, 12 Mar 2026 20:43:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C585F6B008A; Thu, 12 Mar 2026 20:43:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B67066B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:43:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 77434160543
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:43:50 +0000 (UTC)
X-FDA: 84539192220.03.ACDD610
Received: from flow-b5-smtp.messagingengine.com (flow-b5-smtp.messagingengine.com [202.12.124.140])
	by imf13.hostedemail.com (Postfix) with ESMTP id 62F9E20003
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:43:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=HjfBkdDo;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="OJg/U+At";
	spf=pass (imf13.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773362628;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hkrbz7rqb+Pf2fLQdUTn4dR7TTJgxGfMaCdEXnGBb3Y=;
	b=XizTAHu0FjAWw1Jge7gJDG6LxyDRBOS/WY9U14ZF1OXMR6YOyTbAT4jdhk/BVT1ga7paHA
	/ipDCrxw7AW7bNLW2f3JD1lA3gFZu6+lr6lHo5jNYfd0y0Zsu+rId1PAACAYRwC1tEUqjc
	U9X6os1UuPtNeAdM1gzEgWe6L0VVRlg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=HjfBkdDo;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="OJg/U+At";
	spf=pass (imf13.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773362628; a=rsa-sha256;
	cv=none;
	b=0715ISAK1Z7HIuijuIAcUEH4QvVarfeBM1RCf20Z7OvUmIqXVgrchjGWm8Or1DCeHUelQE
	rib0f4mLX3Fv79h+ykeXIVWoM2MVt44PIW7/V3eaHM3lLccrRHdAZ8b6LgNg4du0G3bLYn
	fPVa2TF8lJyCju7RfdwbuIZlNJirHGk=
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailflow.stl.internal (Postfix) with ESMTP id 7B8D91301B2A;
	Thu, 12 Mar 2026 20:43:46 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Thu, 12 Mar 2026 20:43:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773362626;
	 x=1773369826; bh=hkrbz7rqb+Pf2fLQdUTn4dR7TTJgxGfMaCdEXnGBb3Y=; b=
	HjfBkdDoAYwQQJLASCTx4N7D2Oi1gBPTlgkcYOo+WwQly3gu8BxcWETej8E7Y+vC
	7v0fubBGopf7L6qgpale0ldkZ1B3u5NVTNvg1/TUjoqYZU5l0RND/fCU926UE1Cf
	dU52J1R3IvMMwiwCn7OkqthnAbmNeQY0wfFveismXYFlK1lQkp1m9AISmvS7p8Ph
	2303a7f6K5Jlx6zDz19ofnGSqPmwovGDcXYodslmNv0d7WdUJtB9eTYsL8UW0U11
	0GUIOw1bNhAiMgqZY0i4MGRQ55IZgV8SiwsyP0fNcsShifYyYJOt+wEA1ov7f0eD
	PdnJa8hSTogxexnc9oafsg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773362626; x=1773369826; bh=h
	krbz7rqb+Pf2fLQdUTn4dR7TTJgxGfMaCdEXnGBb3Y=; b=OJg/U+At7OucCvylK
	iUzd6DL7jCUcyjQlX78GwqJ/I6vv5ihkeS435nBM5355zdePzGM36LT4OexR0MRH
	4lFKw8lzT25lxABE9ocUZMJqYrflNdpOeF742itP/1xqaMnbimOGJbINuPn3DCB6
	78lFrxBVAc+TEEOa/aL4peQFYcNfkDvkayfMDVZVCJTVMXnAR+QqmP+X6jPGUX48
	4eQs5VFQkcGcKjiIlmezH2hMkyivHCkm6/sZZuVlnduqKbI9sW3ivQ1XUkRrPQMs
	UX4u0qKhx023bdinP+vM4JzLq51NNl99ZTh37MUoQxcyxT2cDqefqczEqOVUaQb9
	MTpFg==
X-ME-Sender: <xms:wV2zaV802bTgJpgWGm7m58j8ialKu0Zt4maKIV9i4YHWWaGwICxAlw>
    <xme:wV2zadZgu2XwPg_o3YWrT5Anv88yZ7bnYqGCtV0_V4WJBvt4XpxYLozwCXYSJ1Dru
    hY-DVUIj8R6Y0RkLBQtcBmkmR5oFpyZ9WR_a_sQSkuqNx6Z4w>
X-ME-Received: <xmr:wV2zaeGMYnl9QYZx90hgpCUlWxvQ1rd8mBQO5-ss5KhrcVNyC2PIGpsH8rtolKGh19qOuChHoIrcz0o2s-anm5mlsN-kYi6yfy57pp24OHOP>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeekvdehucetufdoteggodetrf
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
X-ME-Proxy: <xmx:wV2zaW4BbfLTb9uqAjy_X2cVeXfLP5nvICabjW1EC5wZ_-63JqfrEA>
    <xmx:wV2zafuMUoHnM_LxJ0SjB2wIbOy3qY0O87D6n9Ur7x1RFFWg_aJHtw>
    <xmx:wV2zaYAQZmmbH-UHw-cQ8jEX7A7Z38PfFVmYuiTDjpSLuYRJQdmsCw>
    <xmx:wV2zafteUDDwcmQNw5yQwNwpG9lEyX5qJBk0f8Bik16DaVWpZokoMA>
    <xmx:wl2zaTKap7N99sDnE0QEkre4DOsyOIg54jMHgmGQWKBxlmwTU7TXbmgm>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 20:43:32 -0400 (EDT)
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
Subject: [PATCH 35/53] cephfs: stop using d_add().
Date: Fri, 13 Mar 2026 08:12:22 +1100
Message-ID: <20260312214330.3885211-36-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 62F9E20003
X-Stat-Signature: gf88s45pqwcmwo6ew5fp7d8kexdn37h8
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773362628-748622
X-HE-Meta: U2FsdGVkX186HfNxfh4O3PryMS7jxL1pLfUBhD6cDwaG+TOPDXotOConhhtqyztn5ekkeXqFFA9h7ZRjkEbQXbWnWMTbcW0eTeIJq6g0WHV6bokoXVNG1rJWvNbdKb5QsqaVFp4JhmSvPSzejwRMdsuIKD9dWFTbju/GaegHwJB9cRRWLUyC9MyNsLdcCehZvEUHHkO7HsRZAzrNAJNlHx51HmOe70S7+r3Qxk3ET/X2NJAHDYZny79pr0KrIoVO8tB1G+KvfPYLjxIh+x/1Cx3VPIksPnP1x4cDGTUwKgpWs+TzYwkubmzWs7Kj0x7lEH8OBme+FCNEyhuFd44020uNylnU4WEJOM70guKIir9Xdlz3wedsh89VF6Q61jwAmy+Mzc9v3ogs1xFYPFstwE4sWejglKbgclOImzOkqph2+cWAnDID/S5w6QfQkm7EFHPKBVP8OaCFlAKiSjmkyHFPyt0RcTKLpcToS2D2Ix6C2kNA7nXDZf3T6L8FOuBDWDhZKZtwFLW7ZZ57lHDU4wUXu9nPyvPQf+U28WnQs36MSrA8dJSLCl/7bkA4O8J/rcIyMzJ1G423eGVtU+xuUXSyKkxcSysaoWw/kGq+ntDHsJaeHKw82Z5/PEWWjwSXRZYDGXuRJJjGJfPi/51lfYs6Q75Onk4QeH8RvTxdcn4UELzyaLnelL68MW4siTrLixYlu4mDzFFb9PHRW34tYv50vruTS+NJbaAXC7fqs+CW+BCU4o1Yri7jZ/lXuAVF/QLMOc5cfenUkQ6g6IGiHVn0dlTVxvhBb4rj/LUGrLrjE3Lw4yWiCco9afhOzhbuyEwQ1Cz8Vv8mP1GCw8ZO5zQM83vWFq5tKI+RjtCYL1S8vI52rD6jfZty6iNNfKJ0Tt7+V16UQFBlKiz4GVH67K0cm2+9Z4/v056jVrbqUrDkWupWCVMqLrkvQvnTBY1RigxKljonjOYgEVC7yA9
 5S9nVllO
 BSdpWpb0gz1HGSOGQ+OHkTLaGkD8HTKVO9v8u34HreL/lwI7S0QkUiHGY2+O/X+cDp1H8dXxBDTlBXykLS9H2+hqTXceieYiLzurdLLQEo38/jzg2vPNVEyuoG+gNL+C7WHIkuleTUiGA2A9jNf4BdBOscIm377kqnJ2uC37k4J5ZBzkw/v+bjh1Rz2YO+PItTRHXrx9YMG8YVJg36LyVXsHkFE9IPrcHrnUb7YqsFXob2R4EIBhLfx49/q/KNS2MrPWZIx0eca0kehRK/GcCGcfS2CZlPgRGM7c9fVTGQ7XSkaKrb3S4idaVRfJEhT7XmsxvMnjqAU3MycU8riirfpOArlm1JkDW+ORUYojJfX9I94XZAU0pBE7qdUAh/rUsxgjcBSC8p+F1TEqzLegsrsVtFA4w5bHi3E1YpsQTcOeJqNKIcQLx77vugCdP6mT0rz+7e33QBfT043KQzunkdJ7oAh5hEo6E21budEksJFiRgQTNqk7L8ZUvLcmNe1I0j/evJcQ307EwlwQFK590fMzWs6ZYbDn+qIXqseybari7ngQ+XmYnYYxGrYH7j/H/DQLH2Hotk1BvezdkfWNfElCP0oaq+aI3sBii/KQdp16qbyUg2mreKoSrsZPSOgZuloKb/WTjtUHvcu0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

"Best practice" is to use d_splice_alias() at the end of a ->lookup
function.  d_add() often works and is not incorrect in tracefs, as the
inode is always NULL, but as it is planned to remove d_add(), change to
use d_splice_alias().

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/ceph/dir.c   | 5 ++---
 fs/ceph/inode.c | 2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 86d7aa594ea9..c7dac71b55bd 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -769,7 +769,7 @@ struct dentry *ceph_finish_lookup(struct ceph_mds_request *req,
 				d_drop(dentry);
 				err = -ENOENT;
 			} else {
-				d_add(dentry, NULL);
+				d_splice_alias(NULL, dentry);
 			}
 		}
 	}
@@ -840,9 +840,8 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
 			spin_unlock(&ci->i_ceph_lock);
 			doutc(cl, " dir %llx.%llx complete, -ENOENT\n",
 			      ceph_vinop(dir));
-			d_add(dentry, NULL);
 			di->lease_shared_gen = atomic_read(&ci->i_shared_gen);
-			return NULL;
+			return d_splice_alias(NULL, dentry);
 		}
 		spin_unlock(&ci->i_ceph_lock);
 	}
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index d76f9a79dc0c..59f9f6948bb2 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1773,7 +1773,7 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 				d_delete(dn);
 			} else if (have_lease) {
 				if (d_unhashed(dn))
-					d_add(dn, NULL);
+					d_splice_alias(NULL, dn);
 			}
 
 			if (!d_unhashed(dn) && have_lease)
-- 
2.50.0.107.gf914562f5916.dirty


