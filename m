Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42A34D46604
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:50:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A72B36B00C3; Thu, 15 Jan 2026 12:50:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A29796B00C5; Thu, 15 Jan 2026 12:50:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9369A6B00C6; Thu, 15 Jan 2026 12:50:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F9D66B00C3
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:50:37 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5194D1BB21
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:50:37 +0000 (UTC)
X-FDA: 84334938114.21.3E31AA4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9A5C8160004
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:50:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="il/VdfDB";
	spf=pass (imf08.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499435; a=rsa-sha256;
	cv=none;
	b=TXTtueR3ynidYOOMKEeKPSTgRmwgGvJINHb9EszP6hx18djA0sPGPaB8Yep/xRDckW9L5D
	/ohOGjopeHdnQ2UeebuGG1hKp24JNY52BVD25FOV56vE/iLhLI4lsPknY37CcCo9GhHz7m
	3DQNzsviACq82nNi5ETaj8wjKdUZyGY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="il/VdfDB";
	spf=pass (imf08.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RGpbpT5sGMPb1IBCPwnK7v1mkqc8AIml9XaDm8oqePw=;
	b=svQPUsR+hYCwQHlqmFuBe3ZKWKijktZhKxMMrYvOdcdyFDuc89ycxE3XuFug5eEP8Kpibx
	6/1RuNQgq1T3tyuSbU4XN02SF+dUtb9SjrXOjhxA9IuiljaXHaggHyKMfzviJbmvrSi7cs
	ng7As2rR9U1od1r5TdQwXYdzVxOKbN0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AB46A40DF2;
	Thu, 15 Jan 2026 17:50:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3889FC2BC86;
	Thu, 15 Jan 2026 17:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768499434;
	bh=Ehx/fY8sKADLaMJl7+FCvLMSAa/U8OqMGXINa886kwM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=il/VdfDB1LkGOpRnPQvrFUwdx0K2JPqnFGRJntiUMVPnRxs5PHZsfMSValtvlYy4j
	 mP/J05iJU0gPS64R8GEMOhjWoZHTdcqWYKm1Ogw222ideGX5ipm1oSmIbMKQDoynXi
	 UP645amY6X6foCDNx121QYUsH6YuE9qBLm2QyYpgyOtDMDTtrSfXKS6vvYfzeGVlpZ
	 NBXNHO0X6RoEWOVoNemGaYh4g8Rj0kVFicUqGBtTiM+GOp9CM0/rmo3WVap7u4Plx9
	 iF1KhPCMNTJlYXtmOpwM4F52XhDOSltoNylPFsa9HOjQ5jMxePli3mEAGzckJ3GyvS
	 POj6uKKk9HrQw==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 15 Jan 2026 12:47:54 -0500
Subject: [PATCH 23/29] jffs2: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260115-exportfs-nfsd-v1-23-8e80160e3c0c@kernel.org>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
In-Reply-To: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
To: Christian Brauner <brauner@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
 Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, 
 Tom Talpey <tom@talpey.com>, Amir Goldstein <amir73il@gmail.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, 
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
 Chunhai Guo <guochunhai@vivo.com>, Carlos Maiolino <cem@kernel.org>, 
 Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>, 
 David Sterba <dsterba@suse.com>, Luis de Bethencourt <luisbg@kernel.org>, 
 Salah Triki <salah.triki@gmail.com>, 
 Phillip Lougher <phillip@squashfs.org.uk>, Steve French <sfrench@samba.org>, 
 Paulo Alcantara <pc@manguebit.org>, 
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
 Shyam Prasad N <sprasad@microsoft.com>, 
 Bharath SM <bharathsm@microsoft.com>, Miklos Szeredi <miklos@szeredi.hu>, 
 Mike Marshall <hubcap@omnibond.com>, 
 Martin Brandenburg <martin@omnibond.com>, Mark Fasheh <mark@fasheh.com>, 
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Dave Kleikamp <shaggy@kernel.org>, David Woodhouse <dwmw2@infradead.org>, 
 Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>, 
 Andreas Gruenbacher <agruenba@redhat.com>, 
 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
 Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-ext4@vger.kernel.org, 
 linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org, 
 ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
 linux-unionfs@vger.kernel.org, devel@lists.orangefs.org, 
 ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
 linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-mtd@lists.infradead.org, gfs2@lists.linux.dev, 
 linux-f2fs-devel@lists.sourceforge.net, Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=695; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=Ehx/fY8sKADLaMJl7+FCvLMSAa/U8OqMGXINa886kwM=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpaShJPTKQVJtR38HPlADggm6IpGXuFgpgP+f7i
 KyE9A2oIKGJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaWkoSQAKCRAADmhBGVaC
 FXW6D/sGkS32C0CvjQ+A3ll9zy6dfI2gSXvXs2ERkXcQcsSsv5r/hSiEtw2RyBxQyx6rumNm5mE
 QyUFWXbdaTwcwSGobqehxKp5MKzzcfp66q/Zpo2jAaY7Da35SD3PyLH2KIbv+fiLrBBo7g4tDXn
 mkyY0E5I7NyoHgkD7SQ01nu7bbMi//dbuZJ6f4swfTGiZIdiCkQdMPdK8Ab1nXZBTmGes/5vUoD
 tGaMY27xGBCoU1OH0XNfDeZDjCmt0zCV1GcU2M6s5qytJFpPecsCi3g9XTpKEPAiuUVohlmUH6Y
 964nITE1D+6aDlHH/n8fXWwBcwAvWaUEd0zjh33SwdeUbgGGtpFvVIY5jZvo7+a1zqLkm/v02PD
 i8nD3PIVvfzsAadwDV0ljzI9h1nNV0XB5gAA0NYuiq2KdbpspRl3AwFGziplhIc2IfOUFi4pqEx
 SWDLkaRbFUSzetyFiUM3KqyYHrJFY7y1lO0+Rteb0YEfr2HVYP+9wA6e1xFpmUVrxVQCszE9tzS
 qbr2AirzqRv4ThIptuA5w3v8c5ZPCJiKva4Jx3gS8TT2vj8MZlBxl9rywDy5WyKKUPnoFelofEp
 giBXGcbgNMLDfX7iQ7xtrMTIY2WQNMzmLb0/QRyfr4yue/WVp+cUchExc+2VVPEi6eH84pgNfcg
 n6TOjJhVwZKiTNw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: 6335bkmku3feekqjzux3zrqpdumb9i8d
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9A5C8160004
X-Rspam-User: 
X-HE-Tag: 1768499435-812465
X-HE-Meta: U2FsdGVkX18R8jqEO5uNlqa+OfBT9uoV6Ts2OqiaTpuZIoL2Fq8mGs6j2M1rdI6ib9tOWXxsAUh5hfIGKmXvoIFMvBlUNkKNx3MRB6/7YKUKaXyWLUoWcGDV2mt8EoXLvXRsGhvrxcTQ8cqfqgvbpfs0lCDSdn+L+oIoUAQ8oP/mus+iM9mtEBOXYZjhHFM+rbMMb/G1q3/TQYKlBcraUOXkFoOOMOSn7J0XWSu4Jf/VUiOQEn9Y7oDZoVi1/tJmqLY35wV9jtsCYJmRMMSQGuUJ/2sWiKr72MTlnibTgDuRFdYw6s6xAB2D7itv9PU5h2BmUWbuuzy93vhhjgl6XzyVGCORUVKvx3NkDzPWNd2viuRujZAgFLnrkfsHnnqRP4FnozD99GYyCbIBvntDvsVVeTvYkc940nx88BezVuqwlqdIG2C4y7u9nYjYaKlq3i+Nl8YaFbMCRhSzQEW1KMf9pb2NfPK1nIrj8m+lJeHIaBAVAPRTaPQQBJLQVN6R0QLz+3vexQk7zm5kt5QGx0AgrBeOEt4c2xD03fnQbTWZW6isk1CuSJR70pGSxdYAO0yOYYETiqrsx8Ds31mf9kgpGzp7FwXzIOh+iIDOTFpm3C4GFcsnTo61TXRw+7U8tIfO1SBQnJMb849V+B6hVhxT948w264sUkc1iZRxn0nu0V78afsRwz+13llskljr6VvNuiDoJK/DrrTspZa0zlgTzF4YVSWNgN7Hm0CfzJxoSZp+gtu0di6VcChUUPoDVP3btUMDoygsWlIyOeGTrLkQPG9yuy8JvUTnZbw6qdd7qTr9rcZBivHmiUTWRxpWDVt//t46Vq997YYMxyvO87QMHhZ99qMAGnG5ya89VxICLKlO4hF5ALBVWttw0v+fxKhmZah065eImiQ6V3jgfCoqS2WrFFpcWtqRtodeCs+s7vtbNQ+mFpbpLxGb5dbzjzaIXptwRv+eBl5eAbE
 KWfsfM9H
 dHshKIfniuHOMLnKexibCyyvCJ1U0JNTrXvQMiPI/Lz3C8/0XWyM1Aalq4L9HEJw68TJaqP9rx5jpCZ4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to jffs2 export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/jffs2/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/jffs2/super.c b/fs/jffs2/super.c
index 4545f885c41efa1d925afc1d643576d859c42921..80ff5a0130603f94c9bce452c976753c85314c3a 100644
--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -155,6 +155,7 @@ static const struct export_operations jffs2_export_ops = {
 	.get_parent = jffs2_get_parent,
 	.fh_to_dentry = jffs2_fh_to_dentry,
 	.fh_to_parent = jffs2_fh_to_parent,
+	.flags = EXPORT_OP_STABLE_HANDLES,
 };
 
 /*

-- 
2.52.0


