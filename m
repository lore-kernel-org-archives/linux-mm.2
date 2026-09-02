Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20BFAC624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 18:00:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E01306B009E; Wed,  2 Sep 2026 14:00:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB2256B00AD; Wed,  2 Sep 2026 14:00:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEEB46B00B2; Wed,  2 Sep 2026 14:00:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A83A46B009E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:00:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3E8A5C033C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 18:00:50 +0000 (UTC)
X-FDA: 85169587860.11.858509B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 659824000E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 18:00:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dpUKb6vg;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788372048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=uSMmb+kfJTMPlxjYlJoXiurwKIDliS3SuSxXSlhbt7s=;
	b=I/WmBEa1eWd8FchnNB1HlkZCCQjSeekBccgVZ6ZjEqldp80cWMhQHmzJIPQhC7aQTLSopf
	zM0rDzsFQuN06XawpS/6HxCZ7e6hwD9VTHeyJxYvyaxBOZXjhJrdgmKdWueXB6q2QSImIh
	DVR1+EaGhd7W448+Fsgqz+crJvAtG+s=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dpUKb6vg;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788372048;
	b=6WmWTueH5pl27awMYQ0+gnNZDq0Jj8ykV9zHsEB/rG5v8qKbNTLbEwWqQK1g19EEyd3+nR
	Jl6NmGpqaI/ch4jRXJQ9KY0P8pm30jBZQrWhDB/DIG9q/8I4+mX6Exyydfb0LSpJZizOnP
	W249jdEu6v+3S1YskolF6v8gOu555Cs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AB4FB600C8;
	Wed,  2 Sep 2026 18:00:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF271F000E9;
	Wed,  2 Sep 2026 18:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788372047;
	bh=uSMmb+kfJTMPlxjYlJoXiurwKIDliS3SuSxXSlhbt7s=;
	h=From:Subject:Date:To:Cc;
	b=dpUKb6vgP2/HWC3ChtG3DKV2jDQAe4+uJSbE/B/JTnBmbGbOJKtqlLdNvGqql1s69
	 n8bSF6W+ZPteSRhG9aMc7ZhSjJuZnYaRiurtclbAjBt0GGJ4tO+r3r6XO/i4wGeIXK
	 hFccG4xK6Q222Lp61icC9dmGWWh605lnpnf3s+iAZzIu0LO+/9G28x9xnYQwnSeA7S
	 /VBqTbGSuvRQNdCjTnAdAM8hjG9J4CyHcaZwL5rIeGFZKLN6VGrQC9RKevYnonHZDy
	 gY7S4vZiWxJ5YadY5w7wM+xQDSA/gbLeuMrpT7gnoG/vS9nRjzun98M6s3M1NOYpSi
	 ZybN3e2eE9uvw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH 0/6] mm: make MAP_PRIVATE-/dev/zero mappings truly
 anonymous
Date: Wed, 02 Sep 2026 19:00:17 +0100
Message-Id: <20260902-map-private-dev-zero-v1-0-a578c730cec7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MQQqEMAxA0atI1hPoVKg6V5FZxDZqFmpJpYji3
 S0u3+L/CxKrcIJfdYFyliTbWvD9VOBnWidGCcVgjXWmMxYXihhVMu2MgTOerBsOVLvQOLKjb6G
 kUXmU4932//t+ACthdghmAAAA
X-Change-ID: 20260902-map-private-dev-zero-ba36d76a2fc8
To: Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3312; i=ljs@kernel.org;
 h=from:subject:message-id; bh=1L/zlo7wrdYf4Yd6FaldLAsYq48K4TcYjMn1Y6t0DjU=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJmpLhLLs6rWh5/ft1KnRXxsS47Ntq51ZmwJrY7P06Sj
 P69XiSxo5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABOJXM/wP6SbK/Rl1Nr/+60d
 spnS/jGz72V+ffL/a+t/EVMX+Xz6n8jIcO9JYvOinGu8GxN9Njis8zkUOpkxZ+aD+4dff7162+s
 4AzMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: 47em1edjc3qysd3o9sb58ts5iyxg68kn
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 659824000E
X-Rspam-User: 
X-HE-Tag: 1788372048-760192
X-HE-Meta: U2FsdGVkX1+1DOrE/nghuCxs+d9LAsG5X5aCZL+7hwkI44MBGX7cOeLf3MqWVjVmdsD+ATE7khVJnSdZPNWm/Y90X8buDCMc4fCIbkeDY3FIKhgOffEO80C3p1Y+6aCqaV8vbC9/1zSSPDEcS0Ye3Ie3RvdPslKrV1x5jX4Mi57w/Yw2lBK504+0vovjozZ9pw3iA4uz0EBXZSwR/1QrE+20wTSpT0Ar7s5T520kHNWm2HSo+jNSgQuAui7FSIwRJBAqURBhAd4+IVRdNHuk3PGtzf05fGufr6kVD4ud6sBiAj51Y1WM4GupGg+7EJDuTI9hYqmnbYpAoFHhjDCXbru7PxrGbfm4UBcHIsY8RjKkhTYmWOPWZ2oI2JAaVssSMJ940YGyLDva2Cnlo6XMvMx4wk5MWbqYmQV9YGjuk0laoQJtPDl3gSaVSJkmb/+zFDtjT8cquuwIdTmRriDwxfLm65hY6i2dL8p1vQGhnURs1ygeTlDEG7Q5A1419Dy2EXx6VvoBfUs2Hzp9i/InbQKU5Iy9YTFE5lkJkRODFksvTaGKI6n3cPFL3UiylO4wUA75W9dKRto3coknZbeKRik0ySVEySUFGQXbCDGe6fSnmqUl9sZF450erBZKMNxofe2kxWgelMe6v2tevt2vjz1TVmcXemtgypDie7b5NH4Em8DzwF4Xu90sBv2oL1zFBgXtrYCYm6DiKJ43XFGMbO9HuXW+66/4DJg2ak9/R1AJZzCTfI9FWERufeVgm82Xut8D01UIlxwXE9xApBdByADvZ2ntKcF/EpcCG2cjSGncaWkB+uzvjHjg4ICIUlVJpdEEFfs+9+Bne8LVbp4RfoMeK0S7z8+Ol0EFqcltplGWySRjVuQ3EezM57uaol2tWwLXSTShxvbRrydiaYmwi/xAzQV9Zp5p+Z3RZEGHBOMxKUVKhlwjzx/jXQRz+4d3xGcyUZFeSfeRhOSipvQ
 ds641mrW
 CvDEDnoGsK9756uzPj1+ukiNV+Dy2WpHUEUcPheiAtQehmRIxs4+PRayP7QSpqHKWBfyuL9wj8Lxv1TQB+/NV4itd2cEzzZlD6uayAV020C91C32rgVFR9PP4jKcJibHe8xwus7qwxW6nHKE0V05i/nkqeJtW7FDXtsiDUwd0PxIrA4a1NEIy80DL69QfpYom8HqtVyHFBnHsbW6A4f0dHE8+ec4Xnu1XcfzKWTpof7YyNYoOsHSLAv1bM9W7OebVEBT1YYFIH7iz/tKxjeWrPfqoNhUTyyoQ5kH7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Historically anonymous memory was obtained in linux by MAP_PRIVATE-mapping
/dev/zero.

The canonical way of doing these now is mmap() specifying MAP_PRIVATE |
MAP_ANON, but we must continue to support the legacy means of obtaining these
mappings.

As-is these mappings are an unusual edge-case - they satisfy
vma_is_anonymous() but have non-NULL vma->vm_file, and their page offset is
the offset into the /dev/zero file.

Commit 93c0c8dc87f6 ("mm/rmap: use anon pgoff to track MAP_PRIVATE
file-backed anon folios") causes all other anonymous folios to be tracked
by their anon index (vma->vm_start >> PAGE_SHIFT at the point of first
fault), leaving MAP_PRIVATE-/dev/zero as the outlier.

This series remedies the situation by making MAP_PRIVATE-/dev/zero mappings
truly anonymous with !vma->vm_file and correct anonymous page offset.

It starts by bringing the memory character driver into mm/ - this file
implements /dev/zero, /dev/mem among other things and is already (as
clearly indicated by its name) within the remit of memory management.

By doing this, the file_is_dev_zero() function can be provided, internal to
mm, which allows for positive identification of these mappings.

Using this, first prevent any other mappings from mapping memory
anonymously, then make these mappings truly anonymous and eliminate all
code in the kernel that previously had to account for these strange beasts.

Finally, it adds userland VMA tests to assert the behaviour and selftests
to assert expected merge behaviour.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
Lorenzo Stoakes (ARM) (6):
      mm: move drivers/char/mem.c to mm/char-mem.c
      mm: implement file_is_dev_zero() to uniquely identify /dev/zero
      mm/vma: only permit MAP_PRIVATE /dev/zero to be mapped anonymous
      mm/vma: make MAP_PRIVATE-mapped /dev/zero mappings truly anonymous
      tools/testing/vma: add test to assert MAP_PRIVATE-/dev/zero is anon
      tools/testing/selftests/mm: add MAP_PRIVATE-/dev/zero merge tests

 MAINTAINERS                                        |   4 +-
 drivers/char/Makefile                              |   2 +-
 include/linux/mm.h                                 |  10 +-
 include/linux/pagemap.h                            |   3 +-
 mm/Makefile                                        |   3 +-
 drivers/char/mem.c => mm/char-mem.c                |  21 +++--
 mm/internal.h                                      |  20 ++--
 mm/shmem.c                                         |   2 +-
 mm/vma.c                                           |  39 ++++++--
 mm/vma.h                                           |   3 -
 tools/testing/selftests/mm/merge.c                 | 104 +++++++++++++++++++++
 .../selftests/proc/proc-self-map-files-001.c       |   2 +-
 .../selftests/proc/proc-self-map-files-002.c       |   2 +-
 tools/testing/vma/include/dup.h                    |  10 +-
 tools/testing/vma/shared.c                         |   9 ++
 tools/testing/vma/tests/mmap.c                     |  37 ++++++++
 16 files changed, 229 insertions(+), 42 deletions(-)
---
base-commit: e3b5239afe1b8f0194db7436b17c33e94c1988c4
change-id: 20260902-map-private-dev-zero-ba36d76a2fc8

Best regards,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


