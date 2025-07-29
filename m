Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB280C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 06:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 358426B007B; Tue, 29 Jul 2025 02:23:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 309C56B0089; Tue, 29 Jul 2025 02:23:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21EC46B008A; Tue, 29 Jul 2025 02:23:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 12D096B007B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 02:23:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 86A5659386
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 06:22:59 +0000 (UTC)
X-FDA: 83716309278.21.E441167
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf24.hostedemail.com (Postfix) with ESMTP id 67470180006
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 06:22:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=PCDwXUNu;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf24.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753770177; a=rsa-sha256;
	cv=none;
	b=d/K0LrziQ3JVfHjUdlGsUgu0FoEREOc1dytCmhLgjCWmE5aP9XXSoXkUY00cjySduxzTqI
	DrncbvMo6JfcqKuvX/fZTMTGXdgA1XPyNvn1br60dsHS9Wp2rQfwTTMcaUvjkAVcytsDFR
	5+zTJ+KqFHao62NfoiMljEVuqNzbll8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=PCDwXUNu;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf24.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753770177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=F2yOpyt/YqjoKcmqvqIBEL8aDBHvJPFc1AXuZ7tPAYg=;
	b=L+2UvjraI9OILIiHUE8fymidvkrD2cjcnP4+5ve4vNqZ+5EGS27rfD4irYtVxpqD6RfN1b
	bbOnnSOCAIq6wVSVHnv8Z6DKQ3Lr3ZMB14v6DImVpiKnhRPuob5lLl5rPilx59Guz8bL07
	EoS28Y42y59Kf59+ltJrxKxIocEsgt4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1753770173; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=F2yOpyt/YqjoKcmqvqIBEL8aDBHvJPFc1AXuZ7tPAYg=;
	b=PCDwXUNuJ5Nw2d50dCN8NkikB1hqrah/VJ1DXFkXpbh+BpoNXdnkzluxCjqLyWw0pvHKvTUDXhgMSwKFplEiyLmW/Y2wwPD41olbONx5fz1h6ACRBw3rgvlY0jZYp1jTsZ3RRecQFGoGMlROymFhH/UkXWjQnp2XV1nOS8WH7dA=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WkP.haK_1753770170 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 29 Jul 2025 14:22:51 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org
Subject: Why prevent boot memory to be hot-removed on arm64?
Date: Tue, 29 Jul 2025 14:22:50 +0800
Message-ID: <87cy9j1pol.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 67470180006
X-Stat-Signature: 6aqnn9wxdbrroacy3hw99qguoa7mf9xw
X-Rspam-User: 
X-HE-Tag: 1753770176-434221
X-HE-Meta: U2FsdGVkX187mTTv5NetS7wTY647tx95Sgb8cnnjAXmmq8cJX1ROhX7SeioMwhWJfvX0YBa9H33kwoeuteq9XQ3q5QYFv55XYoyLuEyFxAvKDd6MRTpVzv26mTMJh6S3q+/Uish17uf9RjFY7w9IVCvakLrVR5lQD3tSIP2tVTU6LEhi8/iK2Osg09C0p99FFejbuRkhfHr3GC1WvSzWE0atfL/7ZpGlEJQbcs070KUUz0cbXfz9Mvy18gz5h8c0fqivOAq3wsDwIMn+PuCsF93xKeEp7MRbYMumeJ9vKv5qK/4uSStuCZBKG6T9+UFPuBRfjpTBGxIAi5wrUGUcjT+BNg2OzGt+925PYeRoMpbJdHBlenA0em/MxlDUwwmO+Uqn4Y+3k+oTCgE2YnV6uKnDxABpXtAa8OHutRV8jVB0vywK+XHjuuiIQ00ssyHcYy81r5NOiPJR0i3zXVU6+3/I4r7dZOf6kcmFAh+2CqexQi4jGxj4Hro3d5VLcj/a00QoWH+sLpDorHK5kvCSVpFEPXXr0uhTzgBUVxDAyqRYUsUc0HMdImUCP8UMrSpBTBVxGfCW0FopCsw1XijY5YazvgMEXvCSk6+MsoowpfEsEO85jxzp3hhQaUyjOtDVOIV6Cj3vhIucb+kCOpxS0Ny85otiiHjyFc4/fRsdEv0NYda0AfvLL5p2U4UWgy74IHTX1z6UnkQNFhVjEp9bXqJIWcSGrC5Ukv8LF+IJh1Y+rT7CvB7HpfctERIg+uxEDelMakK8bngp0uqLXQOJx0i5m9iW0sLLa52bdsDNC/vZMKQGEnh/H7IGa/AHBFkGsva4Zyom2jsos3BJuRqs/mK7Rw3+lcsLg5IOgJz3fPI0vcyltnkskgI1XwBgTio61gVV2utMItpVkwVg8t9fowX7wJoxisZHARgWBngdYSTHE6afZHJKHCj+IvlaDziVpp0hQYldXamAUp22Prp
 nUn9RWW6
 c+FGFuHs3uhqft2swpBaSDtg8AcPs4jijBc4eatZENuaWZkLUEPnFlLl+tkdmN8+PQmJDv380Xj+1P+KeRp+ck+l9NID+hBH2BaPRpE4lHEKQZHcuUkkpemcOZQfkXcv77TyWBieuda+asPGLvRnYOo89tMx9zDT7ZOOJuV1gtJEI+a+3YUct2LwjeZvgSEtS1ZAck+oqX9jDL0ENQI1ugZ0TYz59G2BlcrN2m4/kU7+4z1FXsPBvOTe8B6aVa5EbYMrgw3Ssle/ffOv18oZFT7KCLqQuYBHeXSJiIgBymoyWiWq1rLl4WwZMoA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Anshuman,

When I read memory hotplug code on arm64, I found that a memory notifier
(prevent_bootmem_remove_notifier()) is used to prevent the boot memory
to be hot-removed on arm64.  I understand that some memory (for example
the boot memory) shouldn't be hot-removed on some platforms.  However,
after checking the code, I found that the memory can only be hot-removed
via ACPI (acpi_memory_device_remove()), CXL/NVDIMM
(dev_dax_kmem_remove()), or virtio mem (virtio_mem_remove_memory).
IIUC, CXL/NVDIMM or virtio mem shouldn't be boot memory, and ACPI memory
hot-remove shouldn't be setup by the firmware if some memory ranges
shouldn't be hot-removed.  If so, the boot memory cannot be hot-removed
accidentally, prevent_bootmem_remove_notifier() just makes the boot
memory can not be offlined.

Or I missed something?

---
Best Regards,
Huang, Ying

