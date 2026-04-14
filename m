Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18E36F9D0CD
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 13:14:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F8CB6B0088; Tue, 14 Apr 2026 09:14:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D06E6B008A; Tue, 14 Apr 2026 09:14:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BF3D6B0093; Tue, 14 Apr 2026 09:14:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4C3B96B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:14:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D6AC11A058B
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:14:05 +0000 (UTC)
X-FDA: 84657204450.29.7F1A4AE
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id F1814120015
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:14:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rEcgUPaG;
	spf=pass (imf29.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776172444; a=rsa-sha256;
	cv=none;
	b=MeatsqC7J2Im+slZQziX3kvw0JDbURHrd9iGUwn2CTp6z7vYMNXWNZwPn/1GjtqkSGXFuV
	+ajjPJ64o1gwfFG/reCarPaQVNFpusyBxSLFZ1qEESCcS8Xg0kXEOoKBVBx0YJUqdBKIOs
	HF8mBtxBnV7s/GxLezgNCk0ffGuE7Sc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776172444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p2yQNWWDsx/mIlUloKDUpE0HbqZx6yFU3riRkk2FowU=;
	b=wpsizVqvV1xlFd2qe75UsqTgDypUDSLBENnlQDoTTHULskEcf7agCwTv5fzCr49LNuTQ2Q
	gGjp9J4CHuKEiVIPIxsWJ9eXNEmdkbLdIbqTYIrBlN2eJWuNWHqaj1YCcW3KKVZXhTxsPF
	D7celumLGEE8VrWiaF32oJU9W2TKrsU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rEcgUPaG;
	spf=pass (imf29.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-827270d50d4so5036777b3a.3
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 06:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776172443; x=1776777243; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p2yQNWWDsx/mIlUloKDUpE0HbqZx6yFU3riRkk2FowU=;
        b=rEcgUPaGunCMSGrdqYOFtQuVe2em76JCcVEcYE8+TkoNZdGLAgegs60ceR8N279WIT
         HlGlscCJzCIftoU3nmHoK7xwce6K2v3NrM35pI6EGjZsELY/LiCrd7yrMhqSFNTkqAEg
         kEfw/xuE9LPZtKa1qavMvH0hpwkhO5gB+48/Bdg8/7SJeeIRZJweNKXYrYWrxb5hqahp
         b6IzPPFZFqDxbMi+ehXtSveOzNds2/wQgCWIs+Dow8pXTNNa7FJr+5FLVixc+ANIvuaL
         yuCgM3QoljyDV2m8CdIcix2ECknaJA3dsAl2i03U/9vXxIkfiU5okeUllXMSH1JLmoiI
         gtqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776172443; x=1776777243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=p2yQNWWDsx/mIlUloKDUpE0HbqZx6yFU3riRkk2FowU=;
        b=XewLyShPCCvGtPXuAWEQlrDJNzfXCWzXwO6+sn5P1mc/7Lfk3wzt+NPG/BT8cBNlBw
         1UfLsSQRYQnEXEu116nRfYVvhVwiuGDOLZxh1vuCcguQ/E7VB6NnVsv9vUWMcWV5tNuF
         68wQfWhYJopZZsBQmVPwpzSVjx8kxkPUcLxGx2666kVpiHT8iupAYaeaSyiUCI+sZqPh
         6HUsPXCxA6HHjRMxPrazQFayLN82E1iCPuGhAW/GSF+Vhhh3E01uV3iD/NJmrFy7a/sX
         gYGrI0sdLfU1woUyeoZai10+NAkn1VuLj6Qer/6bvAhhfcImRHN95PP9Vz93FnjdLs49
         LgaA==
X-Forwarded-Encrypted: i=1; AFNElJ8lY+Bhl0GuWIYGZT2N7h7YtxPMWdA5I0qnEf9o11JPVA7o5PpE52/4mxrc41SBg+xwWXnEXt7/7w==@kvack.org
X-Gm-Message-State: AOJu0YwwDhAnTY7fBWqJOz4AIxsOya3irGp1eNTR+3NO49gxVteygwVZ
	IsC/k/Awe48vfsItkqljcNXJT6drnYJpJ0Mpg2pGwQ0JCJO1yBzv1zgUHvD50Q==
X-Gm-Gg: AeBDieu3V86IPltPOrWfdeqI1WD4e2XT4Xw5QGSu7xStCRXkXrgPPeXQ3k8Jgzo0Jmr
	jSZ2ujgc3w8mLGFW9P5vN/g/1ks/QMu4/UKF758HZdumSIfmkCa7o8f6iMOjhko4JLQtMnuWJll
	rb6d0YeA05TFWY6PwwstVvodesmU/F4BF1r2HpEl/J8x/S+Q4rY9TJHU2BvHDbvqllTj2ruqwMS
	KnTRG1+NtcrRbtRWpFPV9Zn9cUaT0cZ+rZenzVmAzq4OkCgZ8N/0nNw8j3MXfwCatJ2Ei+wkGeq
	qc74bY78lvm6QLNzH8OrzUDl835/1t4WwejLi5i052c+K12AWELXfuyAOwKaUlk/0k5jXZ3Wq53
	dGyDS/ytQ1UJu+JQuJjwJWjLWCCHBslsfudVjfVfaMxDsD+MWvAQl0krPj8M6eCgh8UNKyEqHRO
	GQ0e6njvpX+4Wh1uNy0DNg411WoYV4Vm4qmGyjITa1T5cs9IfoW2vR50Q=
X-Received: by 2002:a05:6a00:400e:b0:82c:9f7f:3495 with SMTP id d2e1a72fcca58-82f0c351b36mr17153382b3a.45.1776172442703;
        Tue, 14 Apr 2026 06:14:02 -0700 (PDT)
Received: from tech-Alienware-m15-R6.. ([122.171.18.84])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c4b5a79sm15269008b3a.30.2026.04.14.06.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 06:14:02 -0700 (PDT)
From: Sunny Patel <nueralspacetech@gmail.com>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	apopple@nvidia.com,
	balbirs@nvidia.com,
	byungchul@sk.com,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	matthew.brost@intel.com,
	nueralspacetech@gmail.com,
	rakie.kim@sk.com,
	stable@vger.kernel.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com
Subject: Re: [PATCH] mm/migrate_device: fix double unlock
Date: Tue, 14 Apr 2026 18:43:53 +0530
Message-ID: <20260414131353.8543-1-nueralspacetech@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <2c0c00aa-7fb2-4d7b-90b3-0309c13468ce@kernel.org>
References: <2c0c00aa-7fb2-4d7b-90b3-0309c13468ce@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F1814120015
X-Stat-Signature: k9b7rnw3iu67yhkd1k7osnm6eqnxqtoz
X-HE-Tag: 1776172443-581456
X-HE-Meta: U2FsdGVkX1/99sOw1ewr8qF6rGWhERGJybptC60Qot2+MfMO15CT73OsIsamL6tKiReZn0300yosOYWQoqJauPqmbkVnZzD0qJ5l21UATBXLStmT0Hic0aI7OjpaJlJVuhPgslEcDiE1hUL7Es0/7q+446m+JJTO3rUdipAovBwRA+TdZ5mDuT+hHppYrWN2UzljNUmLYMlq+a+2pGlLqGJq6/EuCDAOjEslLlF0xtbJrcflAgn+zevX4+RYHK5PiHv0syVnCLS5V+v+wfNHdE0wO/AKawaouWs4vMHrbITDVskzsfGwtTF3Tbjteeb7hWnqLVJr+P2D6roG2ujCXdDSkQ+33eb3+Cz/ltaoz3TD0iH2lJHKpxDfQnWl6qOLIsjNKyRIbDyLuvjLCaaWa2ovRt5fBtJSOp6hI4wJG2k9b1pXvIn0U7RZPIaGAR+Y7+pfbUc4mBXeoXP7HYQAaHdgR/DVSff6QsUrvysiZW+ZAgDjhUI+qXusx+cLCcaUaI0gH+CnzCHqgldQWl6Bj7/L509t+UIpyzXAyGvc44T9QQUCv9Tr2nulQTl1c1MqsBYnN9+REWtl2A4abP4+sd7Hb9gbxYypXmT9rzs4nOZfDW10aeoq6YF/pT0rA5tVJRB7Ut5S4qdxGMwldcSQcLLTTyTJkl3gvmu5khczAiXR2xWDSs/wLlbihCFgxHVfcyYxnDVv+Fa0fj29BF8pVuKVIir4e9YSXMHq6DEnz2xflKu9jVBxnO+zjCIAzpXQjesbV9FZc5VOOzyl5RynSiWJSC51nS/b6xSkUAj3b5DZWNvGOiOPV9Rla+JhSTSPjPSZ8hutVReHuvHsTg9X+Znklk+v97GRcEJ34ZkQKmlTWQgACe5RjARb4vpnJcB8oXmSQtTQeE+aqe5C2hxDZlwkp02weOD+d8vdTkDEbNuUwStYmz3cnlwj/ssruM25aVyM0SmmMJYnRZYtHys
 iI4bolTA
 /pHskhH+cDhCFcjkM0o66RSm7n4nxEevxS4fMokRP93clOiIgZ/nn21sdAxldiKekbMfrSackW8ijMtqmSwpxKeOsG8c72pkITwI5bTF/DSZLTNQ5OOfEK5q36yAJLejj9pBu69S97LhRfew7F3GLaNFXg8Iqj3UVg7KSzWKS5K+vAvGzRKKPuXfulD3Uyc4qkA9reh3Qxco/Nbe+ZUcGkOpLWoeVWIyEniSS99rQwzYeq77DY9wAWJRvbuuOtqtrck4S1Wr/xgh+bN6vzOKym9OCb47L1oB7Nfg8NI3kMfkq6LmndpBin5cXRJ+NWg3F7STwDgkOnNYf1dFxEpii8sODQWiA/D9cOXrnMG2qxxOM+mGGhNlh794xtGGyTvvCOgivjG0Q2I8BgHowdw30z+V/WqTBMns+IXMS5/xicO3+l+5wRBwlrmQ4EsyA99SLqSyLYevbHW8L059zsmwEIKDV0GXtsKrh219no3JEVo+5cDkjOYe/puxxBoQ52cwCj5Kiz9FH6FWGPU/cWjuqNlO7Tf1887agki+RLsvuOVDWeBTNeRGnWmFVZKYo0zYBCq+IoGPYYC/dSOnXl+6OK/FDMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/14/26 20:03, David Hildenbrand (Arm) wrote:
> As raised by Matthew, the entire code block is dead code:
> https://lore.kernel.org/linux-mm/20260212014611.416695-1-dave@stgolabs.net/
> And I even Ack'ed it /facepalm
> So we should take that (cleanup) patch instead. Thanks!

+1 

Thanks for the pointer. I will drop my cleanup patch and defer
to above patch at the above link instead since it already
addresses the same dead code block and has your Ack.

Thanks,
Sunny Patel

