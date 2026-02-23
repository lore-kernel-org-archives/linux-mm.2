Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14368EEC287
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 21:37:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD53B6B0088; Mon, 23 Feb 2026 16:37:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B75D16B008C; Mon, 23 Feb 2026 16:37:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A76ED6B0092; Mon, 23 Feb 2026 16:37:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 839DF6B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:37:50 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4156689140
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 21:37:50 +0000 (UTC)
X-FDA: 84477033900.08.13ED54B
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	by imf17.hostedemail.com (Postfix) with ESMTP id 76E8040004
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 21:37:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=Mh95Bbw6;
	spf=pass (imf17.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771882668; a=rsa-sha256;
	cv=none;
	b=WfZV6oQo6wzFQaEcPgtpRDFh4MbYYYjjL0spv/I/dm76fCzWfnIXd6/kvYW8ZuDIPWegx0
	S5HRMlsBBsohwrzMF36dYS2mrvEI0nRGPq84+pfdXBmjKBX4vWMwLhmZIF7oQDbWqVBLbf
	7lhl0rB2VQ9abPt6S+s/jPznIz6En6U=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=Mh95Bbw6;
	spf=pass (imf17.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771882668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=tOOO+7UkvOP8Ofk6vSKLcQwQC3rue4XRieND4PdhQfk=;
	b=epQIVyxOK23C3OJ2kFovboJgqcvVMoBXiaNhJIXXCWYvc4pQzilIqfvXdDfR+CFJKIVSDl
	/fTfUJ9CQ0zci8Pq+yhhuuVKmPigQe2fbcbnVhmJrhDXyC6uHUGqsijvTDXsgKTVlVEtGE
	zNNdn9ChHS0Xr9qVJFi7CukUKEJiDDg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1771882665;
	bh=wgq0klt1PqWmfH9WDO6I8fbaaUMhCQRjjwtiK16rPKk=;
	h=From:Subject:Date:To:Cc:From;
	b=Mh95Bbw6HhcXAfl43BAod/s/Ke1ZZ6cGQI6urO8ikZHOFQCiZ43HRzA22AOToPfYF
	 cUuYIRvI6dAsyDKVc+e5HPHALRAWl3ekYAuXrVV8OzQ91uA2RKdAbE56YDVU51lyvX
	 gaNKCXhXjJPHJUfTB7CRgwAFEw8ppqZMQ3A8xnJw=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Subject: [PATCH 0/2] mm/slab: clean up and constify sysfs attributes
Date: Mon, 23 Feb 2026 22:37:42 +0100
Message-Id: <20260223-sysfs-const-slub-v1-0-ff86ffc26fff@weissschuh.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MQQqAIBBA0avErBswDYWuEi3SphoIC6eiiO6et
 HyL/x8QSkwCTfFAopOF15hRlQWEuY8TIQ/ZoJW2SmuDcssoGNYoO8pyeDR+cLYOxnnrIWdbopG
 vf9l27/sB05KPCWIAAAA=
X-Change-ID: 20260223-sysfs-const-slub-3bd764c37b6b
To: Vlastimil Babka <vbabka@suse.cz>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771882664; l=513;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=wgq0klt1PqWmfH9WDO6I8fbaaUMhCQRjjwtiK16rPKk=;
 b=c2iZ0bv/+uVXeyeR+jtp48+/b6rvacLASC/2T32r6ddVtKtUdchncEHargcqajKNKn265gZ0U
 4vD40rflyyuDRROtLkbjsBuNKdHwAgELfsXoSFkG/t3s2l7VcCdqmfN
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=
X-Rspamd-Queue-Id: 76E8040004
X-Stat-Signature: id7axbpose68c4itb6ihq3pnxiof8hd1
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771882668-368554
X-HE-Meta: U2FsdGVkX1/e6h6hwB7gf01mz3I4cxGUK4Ga0WRy1JGLejoCSkaLItMHBN6Q5DLDZKgRbOkSU6BmtcHYUHdn7vGkVUptT1INb14bOvQ5/bY7l610id9jhwDFQJHAFA7uykZGJAOgc9RkCdelutIdfmpuTHjsaQNYrr38ijwppm0ULZFW1w6LvW0wilkPuFnFIa5O4OZOxG8fs8HuVMMtVFjuKNwRQfrnTfATVkeJggV6UnSSSb4UCnqMIbxOWgpUOjFr4LPgRr/b3Oi12kPEJOXcXIPo4sC9MwVqYC8HFgM8KtmI6C3HAUSwshqwaKvPTn7ocKDoCvVmC5HLUXJGIzyblBWzPhMa6G1veOl1nNt5zrSfcMfE7AbQx7OCaCwBcDCAEPCNVr9oQB8aHdIPh/WUbgH19wyn/J/3eaeh8AxgeTWEshYL+fWxMk//aHve2fHEbAR31KB90ZWsEw85N8xp9h/4uFaDBduk9qPoQwCqBkYwRgLTi5soX9/AN2x9vyAcEy3A4/0nBOGSE1IqrawDepxm4inYE8ll7uoQq+tCXAMbL6q0mrOviD0WNVMHGHZSzea4T0JY5FGMVEyKsjKoLVHoveDnD6EJjLDfz9U760ne4VhQNVwqTzo45zZBgIDAeLtCGLlQluH1E2qVo1nzmEv8phz5TUrAEl+D50bv+ElcU2SNrrzoX3g5V5li4uOFhdQ0KDM6RsBYMWvOAsz3ReYFRMyw8TSpFru95uZt+VHIntXU4BF/jS3zJ2VkZE4Pwl9TqhUbe85HX3lKqtYUNYFsq/74an0pQveJyl/E3v1xrCUgpLTYtFPyWmC5xF2BbWBjNVNPG750B/O0x0cMXQ4cWY6iI5MHVbTPHozKBtdzPVF+S91L6/Vhuk+F3zZY1cSliqM+Z67wCM0xV59umi9A3l7L3VuJscfobi9O03e5CX1S+NJhmeajFeiiOEAuUJM3I51oY1q66xt
 CQUknig2
 sHBnGyHTQru/kB8ltB7XbyN2iH8TbPb6yA+OiqGw4Z4AvKooka5DIqYY03jIbJSZHZyV/wic+VGhniEjNYCtpUbdtQTxtHno3aUGfrZIsszCWAm/p31e3bHDAxlpOCUZY26QL5ulakSB7Y3WyFFFQ+lTyiiBaNfwMJ/jvyUrXNXoYhccOFBmfeCNbhC3FtvSPGckfREmGSzbTVk0z8Jloizn/xuT+f4uHNs5L4vFlQxGnXRMWwqkF6eMbiw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some small cleanups to the slab sysfs attributes.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
Thomas Weißschuh (2):
      mm/slab: create sysfs attribute through default_groups
      mm/slab: constify sysfs attributes

 mm/slub.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)
---
base-commit: 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
change-id: 20260223-sysfs-const-slub-3bd764c37b6b

Best regards,
-- 
Thomas Weißschuh <linux@weissschuh.net>


