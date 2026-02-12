Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B57ADEE3695
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 16:33:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CCEB6B0088; Thu, 12 Feb 2026 11:33:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02C716B008A; Thu, 12 Feb 2026 11:33:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF1106B008C; Thu, 12 Feb 2026 11:33:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CBCAA6B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:33:51 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8A75C1A024C
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:33:51 +0000 (UTC)
X-FDA: 84436351062.07.4E8102A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8DE4D20016
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:33:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BDG93oYq;
	spf=pass (imf03.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770914029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xXi4H0Jq66OLHcU6m/KdB+pSxwS1QdAsEeayWF3YRA8=;
	b=jyuKHhznoyWZLi7pTSFWDP7w11NPSa46ojA0mW4HUQE8z7/vpvrLEsE3R/bXqslvPwYDpx
	TQQh5VjystdiozeNpSCkJWFLWfEb2xS3qWde6z+h56WSAO6eALw8mbVBsXT3rVE9/yd1a2
	OGuGpkvxmlMTEHFLX0L5/3IQfAejYws=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BDG93oYq;
	spf=pass (imf03.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770914029; a=rsa-sha256;
	cv=none;
	b=yD2hiHCHjhg6CiSKKIavlno/pV5ElLymbpn/tNcdBCEQMoBM2eI2HTR7Z/QqovcyyJjgpj
	Fs3sMN25mAJhTe38atwEYO20RtyPidphyFakX9JQevQ1mwf0ZYnJdLPMDtf/SwXNohhAcA
	GBrILrE8u6Ie0rx41vFkv9BjuXC2NYU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770914029;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=xXi4H0Jq66OLHcU6m/KdB+pSxwS1QdAsEeayWF3YRA8=;
	b=BDG93oYqkuwAuSE4rXUvme2bvgHMyzLsDKx2kCrVrD4UoauCyl87JYtXuQy/iDE/3u9sCV
	a3RL9802S4p5sVRv0f29MdxvKy3pT1f7TmfMBh2bGFpbs93Vrlkui/AGjbsDD6oQHLGEmv
	tZvBYZjrv/SyG7jzwRNavGT+EDeyN2U=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-392-qrRILHvlMSaFIakZuTTmxw-1; Thu,
 12 Feb 2026 11:33:45 -0500
X-MC-Unique: qrRILHvlMSaFIakZuTTmxw-1
X-Mimecast-MFC-AGG-ID: qrRILHvlMSaFIakZuTTmxw_1770914023
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 93535180AED4;
	Thu, 12 Feb 2026 16:33:39 +0000 (UTC)
Received: from [10.45.224.59] (unknown [10.45.224.59])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C5A411800465;
	Thu, 12 Feb 2026 16:33:36 +0000 (UTC)
Date: Thu, 12 Feb 2026 17:33:30 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Vishal Moola <vishal.moola@gmail.com>
cc: Christoph Hellwig <hch@infradead.org>, 
    "Uladzislau Rezki (Sony)" <urezki@gmail.com>, 
    SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
    zkabelac@redhat.com, Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org, 
    dm-devel@lists.linux.dev
Subject: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Message-ID: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7L56aalL6n4S8iG5kziaVy3pChHSuP0i2S-lttGvf2A_1770914023
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam11
X-Stat-Signature: kqphmesd7rfcw6jm9zueacxrow6bznrt
X-Rspam-User: 
X-Rspamd-Queue-Id: 8DE4D20016
X-HE-Tag: 1770914029-631980
X-HE-Meta: U2FsdGVkX1+fT2pmy93cRu1QpIPntFmOk5ipDD/Su5FsAK5Ev3Ee2IPj7qZFA2qh1MMnPUvBNbq6bpJdexuyULzbqjmcD7SC8lOh/gLITxyUZC5b26J6gU34tEir6Sa/SB2ujEkNkkmwVVLGDMULc2kVXl8FHXyHdZoc3waFkdX+sWI2ZMpE6MoBHPdhwpMIPK5EYaYf/QpcKIOI7XYPQUZt974FSR81qwgCW/n9WqRSP7Y1f3H1SH1OXWDwL1bAifvUyIU5JzFVIWC3b+cei0QZVHgw7wZDhY0LysbJvbTP9eWlVqMt9+gevkV1MlxRXxgpmPgYGVKapo7MgxUmJcBVYS8KseQ3DAKA8jthbn/RmZTPdWrkeO2p5gsekmQE2K3V5IiUXeVXBnaFVfmShMZViE6xQu6rbu730/6EN91bAz+JrL271Cviw1L9wOLYB3lV2weFOBy0/ZY4XizJ9rh8oLc6p12QUh1od+PQI7qszP7lboSmQSi/b7akYNmMQxE6KToJ94bKspioryUtCefr5Bx8VtnFeWA0aUzcP1luNJ7+mX+EJ7KDzfYzmV0NaXWHVgRQHXHLmAVxMAiWiJBnk1aOM4RFukIljOh1c1uvdb8oHUJLtVYcDOQavFQiajj8Q5YOZ7x7boRWIiQVDK24X4H0Y5D5QoAWMRz0MnMxu4jFHmWJ5vymvaM241o960a8uV35IUZNBpt37CpZu0QmEoQmx2lS5sCwp50IegC2v/IEY+E1fy2QsPyaEOmGqs/7Nmc6XTu2nG49mLcVUABMRx1hvhP83uy7uUsnoBxDRFdQBwvEmi5easCWel3q2ZGB/Z7v340pOsdOEgL+ekj8tOb0uShkPNEtw4J0Qtx4YoXUx/APDOOQnLl379sCilxNjcODW8ENe2Mw9hcwejl2a5XpPyx30We4d3cPZ+wzA+V9CExYl/ojvCpuTdJcoHN+hz9wQQ8fFhjmICo
 cXOuXAtV
 dC7fOejOtAWOHPUFXyoFtvH9JVZsyR74DWzhPrjk/YpKTT8QhV1jC/zpkMYeIQYDVfcQiV+McxG+SOzQufqg5n98zKgDZCJVNt9cmWYPYJ38urF2mVDQzF/B8o+fpzwEkci+wY/Z6JDHTJGzUD8JpJIxznPkbhIhHs9k2xuPQKQ2fyXWr6snC6cBMMEpcltOyu9ZOp/Y6KoL18MrGmE1/nyp97rKOvKJcb8UAv3s7MxdiR3y/5lDr/fM6CwT63OPjBij2zGBBng9FpqgdcESmu8UqzbAgl96xzq7jhBtxW2Io4zN5xHzr3uU24dXC+OrgBWKGlqJls3sY2G0z1NTTz8WVf/WO3PM2cedPRIVp1fzZxYhPGRgwcKuBw2Q9NYaXOo7WqYfrF7O5f09c3z98C54nYKdqipSA7xwF01uvSwuuPTqUEu2pAGfukaP2HMvHRGdT3u9wpWurKS79Uye6JSTuSN/Mp4M395s9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The commit 07003531e03c8 ("mm/vmalloc: warn on invalid vmalloc gfp
flags") breaks the device mapper VDO target. The VDO target calls vmalloc
with __GFP_RETRY_MAYFAIL and this flag is not in the mask of allowed
flags.

There is no reason why vmalloc couldn't support __GFP_RETRY_MAYFAIL, so 
let's add this flag to GFP_VMALLOC_SUPPORTED.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
Fixes: 07003531e03c ("mm/vmalloc: warn on invalid vmalloc gfp flags")
Cc: stable@vger.kernel.org	# v6.19

---
 mm/vmalloc.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/mm/vmalloc.c
===================================================================
--- linux-2.6.orig/mm/vmalloc.c
+++ linux-2.6/mm/vmalloc.c
@@ -3928,6 +3928,7 @@ fail:
  */
 #define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
 				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
+				__GFP_RETRY_MAYFAIL |\
 				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
 				GFP_USER | __GFP_NOLOCKDEP)
 


