Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50A15CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 13:50:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD91D8E0096; Fri, 24 Oct 2025 09:50:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB0168E0042; Fri, 24 Oct 2025 09:50:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99ED78E0096; Fri, 24 Oct 2025 09:50:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 89BC38E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:50:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2549F12A31C
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:50:52 +0000 (UTC)
X-FDA: 84033143544.24.5AB717F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9CF3180003
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:50:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=m5i5EC7I;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=63wIYjjV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=D87XpgBm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gwBH2EBu;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761313850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cMiCeV4oPGe3z+F3JuSiJmMNY+rTzBsfNoGW2K0kuBg=;
	b=oQwKkT9A0VGaBWndOsep2vJwDIxCK6VHTBGUpbT7e2XZddTv+uHcstnlBTFHqTr+b/ExKv
	fJQ+FIGlm8bbc7n7WihIh1CbYZ+82tgFpzGgJyBRcwYNJG5vRDdcCu7+UIxkTYhNUtVfjd
	4HCYHMW7ljf1FWRRTP8dXkLEg8Vm1OQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=m5i5EC7I;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=63wIYjjV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=D87XpgBm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gwBH2EBu;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761313850; a=rsa-sha256;
	cv=none;
	b=D09vS3RTYTqwXm2h5hStLpl5Z53tZhNfcAmAGyv7ZBkUyGOnHIgm8nCtuaL1a0DVMTPpm0
	9sCqx/PNNnLqNh5TVKTqBHnuzS7g9bim1jlm8cu4jehiaCmJGefUQSbmdVRfqyqhuBpm9d
	LWEEG2WUlMfF35RU8WwHC1vYoPN4Kr8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DAF991F441;
	Fri, 24 Oct 2025 13:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761313848; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=cMiCeV4oPGe3z+F3JuSiJmMNY+rTzBsfNoGW2K0kuBg=;
	b=m5i5EC7IFX1ep7ofPdfwjnssIkADwpuRTT8MookPoPWZh/qaLHLuedm2gjYbmvjU1+rBHG
	8As6pryYbAO2x1v+gMrt39Om4SMMqNhzKBym0SmuSjS410Kp44+uEEXT9W7izh2ygX6E+O
	cyIhHd75FrKCgpffrbKoROB2r09F6JM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761313848;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=cMiCeV4oPGe3z+F3JuSiJmMNY+rTzBsfNoGW2K0kuBg=;
	b=63wIYjjVBC1IDpGeCYux7pyRh1CJwAI3EP3yhYlZ+Mt0thoEgMWsLRtesrOzFbikqgJeJ/
	4JHlJY7zAYPBN+CQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761313847; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=cMiCeV4oPGe3z+F3JuSiJmMNY+rTzBsfNoGW2K0kuBg=;
	b=D87XpgBmCyVfyddcwlAAWrTKAM+eWgY/hmVAEP/Vg2kkcSFqdP2GBr9wD1h+x3hjMYVLfd
	Jwoir11FNdnldSx+7rFFhSxzjxM6y7B25guBd3O6fT72CWF8qwqSelCtn0bdQXftVH0f99
	pkxZGtFHsJHidyuPM9jdEcZ1Onv25jI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761313847;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=cMiCeV4oPGe3z+F3JuSiJmMNY+rTzBsfNoGW2K0kuBg=;
	b=gwBH2EBuT4y1qGdaT7auz1uvjB4Wyy5CRktC2nRhM3Kvmldk1KNYoryJBzbj7Dr9KoMRdy
	afEqH1AF3wdGWzCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C7A27132C2;
	Fri, 24 Oct 2025 13:50:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1aluMDeE+2jaGwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 24 Oct 2025 13:50:47 +0000
Message-ID: <999cee4d-93f3-4c41-b2c2-7c046d4d3653@suse.cz>
Date: Fri, 24 Oct 2025 15:50:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [GIT PULL] slab fixes for 6.18-rc3
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>,
 Christoph Lameter <cl@gentwo.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9CF3180003
X-Rspamd-Server: rspam03
X-Stat-Signature: m7paz9qkkgrdeie5hnkrpkmp9r4c9hq3
X-HE-Tag: 1761313849-847691
X-HE-Meta: U2FsdGVkX1+qqAYKIrkCiwjj6ID7Vw37HKPdyZtqkyOTHEuATsFXNoreMbvL1zhRkpWZy5E+ftIXc8H7rtve9BqHpzNCG2WZCmEBuuc+hS7RtnLI+Fso3i3IoYEnOhgX++d2AoHXj4lDPYOfYWqMrITDPReodtKhRKren+6EPVo2VCR8Y74YKE2XmR6vxWM9iZL0Oa8D9YpiaKXnwfPgfTJQ5tsY+nmJnHksbTUMXBBLzj01YCUYD+H/+efFRon8xMPf+ugaWf+7YoMtuqyjksMWTGaq+NPNi66bMI/DxluJAfSOVFUNkWbr+RifpN9UEPq3U1rOxyYMU3eb+RBb/tWvVSHMYVwgR16UcwOXif8baFWcd+VhMa3oFmx/Ar4XBs6vOozTCBHz4J0dZGL5faPP+cGY2LGP6dAJb1F00l8wQjjvtoxNC6NIi+Ks3SjtFfqKU0+J517bHBOmJqcKRnMcTakdz+17aVMvv1IKzXaCuTrsl3OM7pOVIczZmLssQ2wWXZXCXEfwCaoRSvFn4uj1W98TXdhdwgPiy7lLAYfvFHkFaIMs4YhRvIzQosgQ7cdXGBwFHxN8T3o5GdYzI04QdGKM2WxlhFk6ZUcKzq9PHYhzrd6Iw1jxSyxxli9W7sPwsNd/cfooR3zd6GpVusu05o/a2wF1PcymcLM4vzgJEQUFtfUJJqcajOlhD7/RtRoHuj9pIM8iylmRTp2yhu+/JLODEAP3o2xf9S8i11++CBkaHi92TQj62VA6MRSF4SGhfqv9do6yr77OnbW63eBkTzT0qaZ4789xh348PlRdkj6/1+aIx7bRypmAi8IyDx5Jtar31Q6nQp1kixEMaPqj5ieV9FRYjfG36S3iqUlcxEXahOT5TDOObTK8VAJWYa7/2MRtnmyZZA8MHLkJtYXQLMpCL/wi9GxIssV1IfnqomqJjjE9EWIlmT2dVLUtUjyJvDhGEXcVsi+EOWe
 jerLPTiX
 TCaZflR+1zF5tgovUaElME4h9R8dRHVyM1o3QzFme70AKHLkQGo7FfPxRaqL/hMXKrF8o99KVIaJRfQOlGrMXw8bWmnIx5mC7q7xe+D8qtOPLieEEkpOPkqmkgyt4cQTMiwnkeSFX6JhjjHmBk2VnAn0r/SaFMx4WOBLoB46pnvShzqT9J54a8DmTisCytRwCr6lYct2nAl9PWy2gQGP3clsnHsltAxPpyLUgb+kodEwiNGJHRCuIYuX5eZDqHmQUYGM6FvaLVpalpca76ASlJyYIr87wF1U1C0iG+NoJDB17cg9j3DtylWUGt04p5lE0vKS//dsz3orDCjthaORGb8JRxmRFkXkTEH+6Rs3HY/Uv1m9jDBl7v/zSYw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

please pull the latest slab fixes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.18-rc3

Thanks,
Vlastimil

======================================

* Two fixes for race conditions in obj_exts allocation (Hao Ge)

* Fix for slab accounting imbalance due to deferred slab decativation
  (Vlastimil Babka)

----------------------------------------------------------------
Hao Ge (2):
      slab: Avoid race on slab->obj_exts in alloc_slab_obj_exts
      slab: Fix obj_ext mistakenly considered NULL due to race condition

Vlastimil Babka (1):
      slab: fix slab accounting imbalance due to defer_deactivate_slab()

 mm/slub.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

