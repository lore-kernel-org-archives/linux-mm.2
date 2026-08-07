Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0BFDC5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 10:42:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C7E06B0088; Fri,  7 Aug 2026 06:42:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89F286B0096; Fri,  7 Aug 2026 06:42:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DC636B0098; Fri,  7 Aug 2026 06:42:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 547FF6B0088
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 06:42:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C0245A033B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 10:42:02 +0000 (UTC)
X-FDA: 85074133284.17.E192E23
Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [118.143.206.90])
	by imf27.hostedemail.com (Postfix) with ESMTP id 15A4C40009
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 10:41:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of huangshaobo3@xiaomi.com designates 118.143.206.90 as permitted sender) smtp.mailfrom=huangshaobo3@xiaomi.com;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786099321;
	b=kDl8laSLDs0w3AbZEZOPnWkLL+LmE+UK0JQC3amaSe6w0v1lMuPlCl6QH46ilKk0S0mjqb
	MfXA3f18EHMshNSbPuWgbkCBXSjhLi8l6wTULpcoKBOvH1iqAhdmpCPOT7CKl+Q3uPWDr1
	hVfRfMmQ4FAz2f+VMI5Dy8E++AIyR9Y=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of huangshaobo3@xiaomi.com designates 118.143.206.90 as permitted sender) smtp.mailfrom=huangshaobo3@xiaomi.com;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786099321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oztx055s5BFKXaw1XyBSNsczAJK2PcB+7xBzs4Aczsk=;
	b=VKFCEah7JQvqW+hxdB0EkOA46g9yZSeoAcHq5ugmkzJdHfyX8qiQPmkD6dKNDhFtOSGetP
	NomLykS3dz1RGGLkK22aaBPENFesOXNmYeivS5KUl0Jf1AzsEXFE4/720RW6MaXZoZi5St
	ZHlgEmnOSO9H3WbXl8IeY/en534+K3s=
X-CSE-ConnectionGUID: YjO2XvMlSoCTXOLeMbuwUg==
X-CSE-MsgGUID: Zvr1NyS0SHae6w3tESf8Ag==
X-IronPort-AV: E=Sophos;i="6.25,210,1779120000"; 
   d="scan'208";a="158567415"
From: sparkhuang <huangshaobo3@xiaomi.com>
To: <david@kernel.org>
CC: <akpm@linux-foundation.org>, <bsegall@google.com>,
	<dietmar.eggemann@arm.com>, <huangshaobo3@xiaomi.com>,
	<juri.lelli@redhat.com>, <kees@kernel.org>, <kprateek.nayak@amd.com>,
	<liam@infradead.org>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<ljs@kernel.org>, <mgorman@suse.de>, <mhocko@suse.com>, <mingo@redhat.com>,
	<peterz@infradead.org>, <rostedt@goodmis.org>, <rppt@kernel.org>,
	<ryabinin.a.a@gmail.com>, <stable@vger.kernel.org>, <surenb@google.com>,
	<vbabka@kernel.org>, <vincent.guittot@linaro.org>, <vschneid@redhat.com>
Subject: Re: [PATCH] fork: reset pointer tag of vmapped thread stack before vfree
Date: Fri, 7 Aug 2026 18:41:53 +0800
Message-ID: <20260807104153.94261-1-huangshaobo3@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <f5af86ba-e724-4b9f-acdb-2445e2ec4b1e@kernel.org>
References: <f5af86ba-e724-4b9f-acdb-2445e2ec4b1e@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.237.8.166]
X-ClientProxiedBy: BJ-MBX03.mioffice.cn (10.237.8.123) To BJ-MBX01.mioffice.cn
 (10.237.8.121)
X-Rspamd-Queue-Id: 15A4C40009
X-Stat-Signature: wo6q7rq481uep4ejhjx1nc9eja1psxrw
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786099319-456420
X-HE-Meta: U2FsdGVkX1+4TfLlTuy+Vrj3ZOl10kgEvYAbxAVmvtB9fuoiFRu3AxhK7aQADxcJrPY6iNe/jvc3BrWW3KQ1W5Ahy6T/TPjTNRaPZlHHWVzQV+B4MqFCrg5kojm9VCiTWsd202Q0CQKY+QtreuWKMiZpjD7gbTrqZ2BZ5sSnTDrLoWFLp74L9MEsw1wucYZn62c/gkQ5OkmVfscDuKHzFnFFxe2Wohv8MnVzy4eudfBRbu9FpznOAtJ76HCz5+KU91yM5P3RHPIexBEYXn1PjAJ4hxTxwuUf6HYGynQd5mNCejiZYmbBUGjQw/QA7akjZxxLsaZ4J7QJCrgenxcCwcpPEuutDeDKwCuuWHDTQ/rHY5n8B4XRjO9qzw4WFvbTrOyRV7FHhUhcFFY1ZbwvTy7D1VK0BveoNLcsbD6PN3/9V6ylLUoROYmnce7KxcSCXga/uO5XHDRfinXOO69r2NU1qr5a4E34eLfhbvnB769Vsz09LdcrJcrDarOl+zZCP4EgWr9C2D0Jd6HzsvwNUnE9JpAlO2zoDE16mQAz3s5Jv8gTQH3SlAKYzFy2W4C2Ml+lWDqD0gyo/vlz4W8aDl3r6kjnYa4sOKAHAJKsgGuoA5VysO0ey2RjTXHlAAXWvB/ozwVicY120FynRi4Czjs8u0tBxC7qiGHi+VeGBBtzkTpZFOWp+og4PZN8Rn54//17eWQcuE6DeaIAGi0KfgarquNirZ6SzBi/m7/lB//XzjglBn2b+xhdqiKGzBs594SInh6demWFmT79kxU0mP1zafOtKp7b+yqi+tQFdcwRPoIN8VuXZ6pw8PiTWyr7RQCsonEXkx8eo1XRYK6uwXuDTH0uwkUMM99l70QR1g5ZwreQgA4uuspi7cQHBbdY5kXHb6KEsQVDqWPFAKhp0pU/W555w6joH5fQ2xe5a38z6Xu73nu3YAIoPa313B/T8EplIE4i2F9kukJxLoP
 37EH1a3j
 ur3RpK4rF63YLFmGJVU40f1SgH80f6p27rAnKTCN1muDFwXrdnDOtmu8nAE2FT/u5t30YmY2ozXEaATHVK82Na6wq5gZdBMY42ANYwjH3t+PqLM7/ByYHHgNqePMmajozL8qtLr8g3DuNWa5OW50ZlgdHfU+uIb4U0QaCUWNuBYF+f3X9M00tJX+jOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-08-07  9:27 UTC, David wrote:=0D
> Were you able to reproduce this more than once?=0D
=0D
Still trying to reproduce it. So far it has only occurred this once.=0D
=0D
> Does this relate to CONFIG_KASAN_STACK?=0D
=0D
I'm not entirely sure if it's related.=0D
The configs relevant to this path are:=0D
	CONFIG_KASAN_SHADOW_OFFSET=3D0xefffffc000000000=0D
	CONFIG_HAVE_ARCH_KASAN=3Dy=0D
	CONFIG_HAVE_ARCH_KASAN_SW_TAGS=3Dy=0D
	CONFIG_HAVE_ARCH_KASAN_HW_TAGS=3Dy=0D
	CONFIG_HAVE_ARCH_KASAN_VMALLOC=3Dy=0D
	CONFIG_CC_HAS_KASAN_GENERIC=3Dy=0D
	CONFIG_CC_HAS_KASAN_SW_TAGS=3Dy=0D
	CONFIG_KASAN=3Dy=0D
	CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX=3Dy=0D
	# CONFIG_KASAN_GENERIC is not set=0D
	CONFIG_KASAN_SW_TAGS=3Dy=0D
	# CONFIG_KASAN_HW_TAGS is not set=0D
	CONFIG_KASAN_OUTLINE=3Dy=0D
	# CONFIG_KASAN_INLINE is not set=0D
	CONFIG_KASAN_STACK=3Dy=0D
	CONFIG_KASAN_VMALLOC=3Dy=0D
	# CONFIG_KASAN_KUNIT_TEST is not set=0D
	# CONFIG_KASAN_EXTRA_INFO is not set=0D
=0D
> Can you share the kernel config?=0D
=0D
I'll send it to you separately later.=0D
=0D
Thanks,=0D
Shaobo=

