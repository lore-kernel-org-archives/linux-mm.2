Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F07560A6F64
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hoFWaj8p
Received: by kanga.kvack.org (Postfix)
	id 8A3A36B05EE; Sat, 14 Nov 2026 08:09:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87C066B05EF; Sat, 14 Nov 2026 08:09:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7908F6B05F0; Sat, 14 Nov 2026 08:09:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4612E6B05EE
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:09:44 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BF7791A03D0
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:09:43 +0000 (UTC)
X-FDA: 85433756646.05.27269A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id DFBAD180002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:09:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hoFWaj8p;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661782;
	b=daoEcXccEmI56C5TkIbdd2fVuoRs6U/JvNZL2iHxfC8HQprn1P+tPHxdFEKVHPvlXc03wk
	Blog0gJbbe6xOBFH71UfvUJSHDfPKF88djEf6pzxXaRPJdwkC6Iwl3TGXaJE1hAbQIqEsp
	m/YWIUtDN8g48Vmw4lVH9f5huHnr5z8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hoFWaj8p;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NDK6iLGoU71raS2SgqQLHOQWV8qCulebQnSVWkxP4N8=;
	b=XyerFV/lRc01xQkRihbEQuHV0TSXIDXvxDplc3fj3RGbDOpp3wfHqwcQXX4Mio8Er9ZTVI
	9Zxt7tTprLJx/62IEOA3sfkGz4OexmGJmbT8BdIWqmFX8Fw8WeOjFeedDX/vtLM7srDQOd
	+YpQ4YhUO9NRE6etTIvoIZqjaMxgMf8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A0EB627AF;
	Sat, 14 Nov 2026 13:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A26C1F000C5;
	Sat, 14 Nov 2026 13:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661781;
	bh=NDK6iLGoU71raS2SgqQLHOQWV8qCulebQnSVWkxP4N8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hoFWaj8pvuO5W4IMFMMHBQHXMNLjNH8JHfJrDEmFAYaD9asZ5QMfu4dOUECaNFmWb
	 f5k0eyP7Kyys7O1qt1H853aLKDmH4CIdCdqekph1EhrZbDKl0mxNkgwIVT9HDOt3XC
	 O3bGQDa7op33lAEoqksi8s58BT8ulOMAO60OcbJMkq0yL+u5csuTYRPB7smWs86ksl
	 ospRai6EuGNd+GhCYkKlfBdmljxPJpsYewArnoRX5o2L7xJTjyoZG5c+NVbvTvPVPv
	 JUbdkCHF4KynQMxadnOeQj/61m6YmnVQxmfl/9pKanW0zQl5nFhfpaBX+TBYt4fp5N
	 X2KWpck2qoGkQ==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:02:16 +0100
Subject: [PATCH RFC v2 35/42] zloop: refuse zone files on pseudo
 filesystems
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-35-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
In-Reply-To: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1408; i=brauner@kernel.org;
 h=from:subject:message-id; bh=FWktvag3hP7CxJ2aHsFycQWntpQ2NlX5K0UkpLEDOgs=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iOmTbNEV636a62R6kHG9SdDEX8xMuUodXbnngjbwb
 l/iW72lo5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCJWJgz/E+5wxiw8Ms/ho0RZ
 slhBp+vsmI/Z9zf941dJmu0vfvbnSoa/svdmna/i63v7pKntle3q1EqNfZxyTU7nC55fEOXNvXy
 KEQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DFBAD180002
X-Stat-Signature: rqgotsmngkz9d7ccgrstoy4xnekaoncc
X-Rspam-User: 
X-HE-Tag: 1794661781-19320
X-HE-Meta: U2FsdGVkX19f+y7gQSIiXsY8wbOjeLSoVf7gdNPeZ2eBJuAZLRDF5v8qXupBYyXWgVtzd5yBRjH3l9wTuiQeLCHC4OXM2G6RmsUwxLydKjMhiSvxAo5+47rCqxe2xeZcDu/MmIJbYieDnFa02lyaKbnCRpbQWXWdd5LsMtz79tAbEJPN0vSvXIDvt5i0kivK1DqL7ADAFFT7D3WQab2/PAiGKwsvgyjeuaNqWyuJNhtF2cSEPNJDr0YgSIs78s6fwPtzAKAh5t/M8ShxflFEB0y591nA3a+RTghR4vhnLmwfQksqq7x5Ngd1aC48c0YDp3cDo1aNuYZ+jvh3Dw3TkE85hIeOvltctcV9W+OAl/RUttIdWmkBrMFF+MOO+K9D1QPTp0mckGtD9Ng07f+lwTb94lelvA2W/oNYkuh5kM8mIGrBs9g1AKUyfKrgDzDNHKZ0b/cKz2zcVGTgKD8K0BaeWOv+xH4iZbASBSt7cdisXfhcdjtiNc+sJbjoUPxnjaL9i0w5B+JWz/pevSxhlz+MkQ1K+5wJZe56HgJjTHnLlE0zzEG3uZjdCUeZ/1220/0EvzPab0KJsKL6JW1u4pvWX+u0u817S93hpR3SsqE/4tGAMJYs7yqxrDqO/B8AQOU1jjNKqo7uUZ8GSreaujbk6/gSPw7OCmOpm3K2o6jg/5ARZeoiDVmudrOxX1tsM4ZsIHx5KwyZ4RTkTh9oGIzH3vWG93tU8HSxVNeiMfzjNxJn+P9MLTXipGa43Y7HMDxrEAEGuP4KRc7AdFV9kKDUxmi1CVJz29iklQqHmBlLKsF43G2T9+HbVoHtJQO5Y84zQOjMqf/Xy7YbuQVRCWUt76Rp7XPBFMLiqnT6E33EH/Fw/vjB7PxkmvS0U0/oL7YC8DK5YX1teSPfqma5j6tOb5tip6utdg+BXysHiBZ2C5S/CtXqAU7sWjoGA9BuwhJ/vgJM8ch8lNYNgyl
 1rxEVcvK
 LNwVG5QZX3QsuwX5HvTnMvo4eCyC6FaXgmm2ozABRogeGtoY1Mygp18Nfq5edn33t59L8w1pxjjFjSK7eP+U59LDNEthZmfoMqKKqkleS3ce68L4BLYWTlZGYyEqVyoxuAWZiOtlIp9OBTp/5sKTRnRgHKv5KRaXkZWiWJp3M0ASJ0iax7MCSatPmnB5fO74VAxAZtsdY7Q/4uAiwC/PsjxReOv6fGBj3vqoGSChIhkOtHnOPGPpgwAtIpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zloop opens its zone files by name below the base directory but a bind
mount can put any file there, including a procfs or sysfs file. Refuse
files on pseudo filesystems as zone files just like loop does by
switching to file_check_backing().

Note that the helper only accepts regular files. So far zloop took
anything with ->read_iter() and ->write_iter() as a zone file. That
includes character devices, FIFOs and block devices if someone put them
where zloop expects a zone file. Zone files are created by zloop itself
and zloop truncates them to size and to reset and finish zones which
only works for regular files. So refuse everything else.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/block/zloop.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index 65634a39b0bfc..6f79b9ddbbe00 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -1132,10 +1132,9 @@ static int zloop_init_zone(struct zloop_device *zlo, struct zloop_options *opts,
 		return PTR_ERR(zone->file);
 	}
 
-	if (!zone->file->f_op->read_iter || !zone->file->f_op->write_iter) {
-		ret = -EINVAL;
+	ret = file_check_backing(zone->file, FMODE_READ | FMODE_WRITE, 0);
+	if (ret)
 		goto out_fput;
-	}
 
 	if (zlo->block_size) {
 		ret = zloop_get_block_size(zlo, zone);

-- 
2.53.0


