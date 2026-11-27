Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35B20606A6A5
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 08:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bwj3PE43
Received: by kanga.kvack.org (Postfix)
	id A582F6B05C0; Fri, 27 Nov 2026 03:49:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A088E6B05C1; Fri, 27 Nov 2026 03:49:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A9C36B05C2; Fri, 27 Nov 2026 03:49:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 53F186B05C0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 03:49:08 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C806F1A0240
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:49:07 +0000 (UTC)
X-FDA: 85480274334.05.1D29254
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf28.hostedemail.com (Postfix) with ESMTP id 04C87C0003
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:49:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=bwj3PE43;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=qwjhust@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795769346;
	b=Uy39cRILE9jOgLcBfevEFNIxtbDTwwjB0iybgHTAWmmdKELZBAj3gvrA7z2EeZ1rsdY/y3
	Zgjri11teDX9mxSj4lOFP4Pk1iY8mp87a/+CdTSiO1k7pfMLz3fLP2JcTQXqVDU3AJh8Hk
	i0boI1FD/Cr6s65O7zW1LWoocaSQT7s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795769346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bAYchJLtcmu0eim/PzW1trsxh4rvw0msXXKEd2Gvip8=;
	b=xITi5NQ1pK+nubyA/hWvL/uCPs87hYXri+/zGQzeHiN2jkAKP89ZF5QYSgFCgIx8Edb+Mj
	iSTKyCjUvTIFPIaDDCOGw8NJDdONvsd7xz82YWGFUA3W0IBwi4MoLNTqZc+a4UC08fcm8x
	gqyuoaj40uDCWauCKfGGb/onHEV3FYo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=bwj3PE43;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=qwjhust@gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8d1aec63541so574794b3a.3
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 00:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795769344; x=1796374144; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bAYchJLtcmu0eim/PzW1trsxh4rvw0msXXKEd2Gvip8=;
        b=bwj3PE43vUetqwcaNfYcVIMmLfPTL5yz2yqAl1wOyolk89OYbiLvOZJWjjIPD0ekN5
         hPEI+xb9IcomDZu3HJlzyNudiM15GuYkfkZ+Qdcduznci1UoIJnJOg6615E2z3jJSuX5
         vMoi7cA1peHdGIiRmJpuT1Aetriph1vCWddv0WoEdO2cEJAmaFLlfPLM3OzDvGyPSR8T
         bOfr3ICmL49kABKQjHr0oooBgzEj/GDWCwvAIqhFCw69D7yQj0EtWRwvc+SNQnEi+xaO
         ZcEPBAZYvq0pNjOL4pE8nI/NSkEAuVKbqDe2VXG6njsVqWb/j7g3+A/AwX2TOtjrV72f
         1yRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795769344; x=1796374144;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bAYchJLtcmu0eim/PzW1trsxh4rvw0msXXKEd2Gvip8=;
        b=1NtVKuxXXuJSQPCy/3vwos7hc6TJIhNsufezw+PrVWgfIIUsrsNmHf2Wsu//FhH3Ra
         6tVi4qWAQEf56P04gqRDeb9wsCInfYLu9HTHm1NKfMOhKbulm3WAkp15oSmZyQcgwcYd
         7pFd2fAVi30tZRFcBBDBdwImygk7kh/Nwr3gaOEav7pBkIh+LWxTVtmFM1dG1GBcWQJV
         tVu9ep4nS9zZv5ZCTkFccEqWHwJ/lMjKHHpl3mPkgHk5q7BxO5sOpy8s09EPMWBq3Oyt
         ecSq8qbdJlsc03tKdWhLGD8XITC8FBkxarDgmf/z/+lTyiVXw2ELDzJNhbXMcSXMOBZN
         WquA==
X-Forwarded-Encrypted: i=1; AL+hErFLEU2Zuy3Mf2MRlr5pOLzx0oySHfRU2ZwAdrdC4OcJGdtAI7L30ZBMg9rM+cF6UlCxS2cZZ2rb4g==@kvack.org
X-Gm-Message-State: APuU4Z/G9xORBe/6pY+0+qWLwqHzLbeCrVl61xvcayJPzN1gKQrsMXMU
	N+Jc1yC4i/qbsz1U3cgUALOzGOvaC26UnBM5nRUwLpShzGF53R/3bTWV
X-Gm-Gg: AZFdTZf36l3sQ1v5VhuH3vuuDfc50FQl1ztb8BPN4Qf/sPwC2i4aspEkpn3Twn9Im8o
	4Zj5sewq0qDGii0oSSf3dRU/73ZFi+IoffeXIDCceSEZ6Jq6NV3omgYCtf1HtnYIWG4jB3IyuV9
	a3bxziwjviDvQnkZhfVaJTo6N08bl6hd7P2aWKHgHt+NnWWNppApuPlYOT7KINWI5EeBs7Oz93D
	k9GyRbBQVWif1CAHzlfDYxBsqyEMD532UXafVTE9ZMulcui7o5ebUSLoFBfGVFQ7K31lSx+QTeA
	d1uvJZHT8qQZFUiwbqbpJFqiKJzUpZLB733cwJl5ayzQC3DLP5zS02+jCw2FoCeDndH20ZDATdW
	ujzbLejdHPfKIhX2aDoWLyEjHuzw5cHRdQBsNip2GSvW3zyAp3ovYx/tgzsl5rB0vJPY+3gCNs7
	IPcNPD+hfC16HRX72zGqDsIukd8E2KedecOX1fS+TuoXdAmqX5U6dCKI0NIHsWID0Rc04lwJpLS
	U4hriIhJ+FjwHLp1dCG8IDgINs2o/hnMZhmcqW3mSlH6LdLelWpfY51y3IiqhRiHqez9HpMZNWj
	Ry2VqzbMJ7VgMYMD1WRhbMdxuDABPK4wH5BJv+4yoXBiy2NXjPLhcReGCNzCvIfNced2V6KDoXJ
	G/VgV5hIj3u8=
X-Received: by 2002:a05:6a20:db97:b0:3e9:176f:ab86 with SMTP id adf61e73a8af0-4014bc4b23amr26347756637.44.1795769344544;
        Fri, 27 Nov 2026 00:49:04 -0800 (PST)
Received: from qiwenjie-ThinkCentre-M760t.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6d0818c1sm12289058a12.30.2026.11.27.00.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 00:49:04 -0800 (PST)
From: Wenjie Qi <qwjhust@gmail.com>
X-Google-Original-From: Wenjie Qi <qiwenjie@xiaomi.com>
To: jaegeuk@kernel.org,
	chao@kernel.org
Cc: linux-f2fs-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	hch@lst.de,
	jack@suse.cz,
	axboe@kernel.dk,
	tz2294@columbia.edu,
	baohua@kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	qiwenjie@xiaomi.com,
	qwjhust@gmail.com,
	syzbot+cid5582b8164122eda@syzkaller.appspotmail.com
Subject: [PATCH v6 2/2] f2fs: enable buffered RWF_DONTCACHE
Date: Fri, 27 Nov 2026 16:48:45 +0800
Message-ID: <cfdfaea72b21b8abf58cb250495150d92e73beda.1795746008.git.qiwenjie@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1795746008.git.qiwenjie@xiaomi.com>
References: <cover.1788438786.git.qiwenjie@xiaomi.com> <cover.1788795700.git.qiwenjie@xiaomi.com> <cover.1795746008.git.qiwenjie@xiaomi.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 04C87C0003
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 7cx7d159mhnia3cz17g8sj3wbh3q8k3d
X-HE-Tag: 1795769345-652412
X-HE-Meta: U2FsdGVkX18OW9ElzJcKwWSvlyOdwp2EN+GX845ZTQGeirVIhkvALLgTUC/FokHYyIho0QMBUcg2+O2+xHdgqqK7Zk6wrByHHCK0CLs7aXhar8ptksfaw01L3Qa38kShpYo8dxQ0Ro29A1aCN7nrLCl1UNMuWWgYcIZVt9FkN5jvqPSVDRLNbXwZ5XUSkLHEVdCOdUKMmMzcbAx25a4oI/lUjpM0Lx9Ix76Ink864hxbnr+Tydo9Il8WZN2ZstZylkPuRlFhHKj/XHgiGIOxTCWEs5zSj8Vxpo+hxMn6ncgSOQ22sk05cuacU+/2W8CLdMpVo4G0EJ0aTEMWqWhksRNU90XYCt4GMv50fY9UJ4669KkTfV7rgzYPcr9I0L6QntPrakLCga4lZVeut5vHVOqNcu0G0pOiUYzcrpzKFzuoWsUDKNIQ8/H8cvllHzdjdQ8yF3jqH6lkMdXidKlf/WCqayfAPbDbN5uWLFfEhvcgpq5Ufd0WdBaBfEgacCwk5D8iFeyWEWt9mRSkiUuee1qonlvTFIDz+s09zG5KkEAv8vgP4mQcpl/cvPg+pD4LtWJaUFDTlFJ1NI+gJSvQZ0wCIQu0YUV72Xc9uaFAxYLa7PxzajfqnfQJRx8AjdVEAaenLB9raCKAWX2wwkTDUB6B4TNXmJybdPJnvmGPHsmD0kE4i/iA2uU9m6gn0wZ6gob68jGWOtO1TpRPbSe+cy/UeL84iwQCR6rOY6sN/OSx/USb+JrN2Au3J5pw3bKLB6CSz+x1I2s2aTbHLuFxgaXdNYGD2mj4HtnnGJ3cawW8yK0NqnJBBN7PqRgAKSWlQd7teWs3aq8DbblLJWutKrOoCe9+25ilooNqYF0604UGtPfjUGQzpH9smiETwxJLv51QqXnqEG9/2xayyYTDivMO55zR1s28/jDMRPmfBooDJYOVbBzHdoWg7cqJIY+be9e9jicNZ+ypdyr7mZi
 GUD39i9A
 JixR0odu4WXx7mRE+kugMcohF/C8mA7JkphGwCtpTRSyIFVZLY6GBQc1lJn0ZoQX9wSQVb7Na/cFXVo7HyhfGJISe1g8K7HT2kxhKsmY9nUmHbt62+MueG4bYN7wPaY0ruRaPY1vTWvo+zXcXYte+cjFO3NOxDDWuugp5fgpVw6XiyLjTbvZ/mX+zs2NDp1Pv+fV3A895Y+tQkbFv4x6vzZF+V439oXkb2iSHlNpa+XdjEd4pgarnkXjtkSinYolZWwOwagluRB1GCwH9Z738lVPz7qnkmN3qY1eZCajoAAU4pe/QmIr9rAvHImtzAh5ql7SZcfUfRUVCkrkdo+eIuf6YuzGUvYT2Px7PHZMASomXO7n4p34Et7gxyQaB8x6TNNvmFZpZDZ6OfSg2GD9kQ0sJV+vg13EGMP9yN+O3SQa0uKKp+ys8m8FD9UQzIJue+GkrnGK4N3tnavhHYxOam9mMKHM4dcim4ORvRcjRHXaTXcsQdjzq0nEWIEKI3iZMEvkv5c/+59ov/ItcVataPxCcaRp0F21K/RzuZWN1IJJPrUl5bkpIt1vf+SksZHRGxl/J7qoajFmvn0yxSezmVNLCjkZpgBvWkdYG65qLvr5ec3IpRVVGr3La3q6JJo9FEf649d4QylZHHz4Gb1RcRsQzilYm2GLw3Hyo8Cn3Rm1TrTcyri2hSjjR3zX04/LxoB0UVAOR0ATFE0pw+IiXsBCe+vIOAhodrKwgvJnGOdG6NN5fsIOldgLM7Bci4WhQuTHP/QLy5AgQNSBzJY/JUz7XLF1YNe2I5rp1DGLGfXPu9565RLMmtEAUHsElSYETYtoIuD9lqXmVbAd38joRLugdjXwjR4jQqs4h6Zd/G4QPHhrXBtqIb2tUdzbQMjMY/Du4cxvKjsRTwFY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Pass FGP_DONTCACHE to f2fs_filemap_get_folio() for
IOCB_DONTCACHE writes and advertise FOP_DONTCACHE.

The address-space write_begin callback is also used by internal
callers that pass a NULL kiocb, including page_symlink(). Check iocb before
inspecting its flags.

Keep the F2FS-specific lookup because write_begin_get_folio() adds
FGP_STABLE, which can deadlock here.

Reported-by: syzbot+cid5582b8164122eda@syzkaller.appspotmail.com
Closes: https://ci.syzbot.org/series/cbb9ded8-1388-4a7b-bfa7-44082b04025b
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
---
Changes since v5:

- Rebase onto dev, using the existing fgp variable and preserving its
  folio-order handling.

 fs/f2fs/data.c | 3 +++
 fs/f2fs/file.c | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 37d74afc8b26..f3559c27d44c 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -5622,6 +5622,9 @@ static int f2fs_write_begin(const struct kiocb *iocb,
 	unsigned int blen;
 	int err = 0;
 
+	if (iocb && iocb->ki_flags & IOCB_DONTCACHE)
+		fgp |= FGP_DONTCACHE;
+
 	trace_f2fs_write_begin(inode, pos, len);
 
 	if (!f2fs_is_checkpoint_ready(sbi)) {
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index c80dbbe76f8f..571a848c6af5 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -6274,6 +6274,6 @@ const struct file_operations f2fs_file_operations = {
 	.splice_read	= f2fs_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.fadvise	= f2fs_file_fadvise,
-	.fop_flags	= FOP_BUFFER_RASYNC,
+	.fop_flags	= FOP_BUFFER_RASYNC | FOP_DONTCACHE,
 	.setlease	= generic_setlease,
 };
-- 
2.43.0


