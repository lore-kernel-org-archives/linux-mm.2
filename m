Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F897C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 06:13:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A420E6B00B5; Sat,  4 Jul 2026 02:13:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F2A56B00B6; Sat,  4 Jul 2026 02:13:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90B8B6B00B7; Sat,  4 Jul 2026 02:13:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66D426B00B5
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 02:13:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DE07B8C46D
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 06:13:42 +0000 (UTC)
X-FDA: 84950077884.27.C584684
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3B6791C0005
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 06:13:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MWX88DRk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783145621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ws31OmbOfyl6nG5V5F4r74N/O/5v/oyarnt17TdEJgI=;
	b=Vxwf1LF0Qc6dP0D3UjC4fV7/x/kWWEd2HfUrEvuYTllhd4vykX2Jw1/8zD7ktlZEsOx3fI
	eUbxhJl0dr977bWZEd+TLmC6ztPJQzmvekMnEYgKJyJQnLBzvqufqhwwu1osHwtDR+Fp/j
	kwusufkbE3xCCZwrHJcweWgovGJjkpQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MWX88DRk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783145621;
	b=8qRz4TfLuxImpWXBe5MDZhO9IiQpkirhjxwF5kK0hIUgvNYHfZkX8ksSeCmT6PStNDFQJ3
	XBmCRceZUEQbFfPuWPSxLuM0TuKu0ZRiCoUgkS/3H3xX31aJ7WYN5OTrmMvqBFedXlakvf
	Qbo581BvPhCWlrLMKJxSocncwnMhMXs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8EEE6600AF;
	Sat,  4 Jul 2026 06:13:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8791F000E9;
	Sat,  4 Jul 2026 06:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783145620;
	bh=ws31OmbOfyl6nG5V5F4r74N/O/5v/oyarnt17TdEJgI=;
	h=From:Subject:Date:To:Cc;
	b=MWX88DRkGxlLPON9lrKAXoGQa79xdBX5lFfhacabPYFPrPz34p12iRiw+TNwZZqFl
	 eHWwuUoqzxXQLe++dTq/rqQRlSk7EuxD9oiJ1dCQcNfOcDveHiOk7tUMsyxYZ5JPo6
	 CHjCWcvK6EAdykMI0ZmaO3SF4jFWciHhfsAjez9CqPeEQLiji4hp6N3PrG6Bggj2Dq
	 Nduf44gCIxmxfdvcRyFB9AgPD4yYK9Ff5mN6uk3HgGBBx2V0qqFgk6vMyILXOii0+e
	 90nKN3JZ6m4Dnotxn79/J9AWOc3kyt/FrEsuoj9QFjmD5TLkVoUdM/Hq2SftGjY8/H
	 bVjJwFTtDqAYg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH v2 0/4] scsi: replace __get_free_pages() with kmalloc()
Date: Sat, 04 Jul 2026 09:13:33 +0300
Message-Id: <20260704-b4-scsi-v2-0-7d2d21a810de@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAI2kSGoC/z2OTQ6CMBCFr0JmbU0LFcSV9zAsmDLAqCmmg0RDu
 LsUjcvv5f3NIBSYBE7JDIEmFh78CukuAdfXviPFzcqQ6jTXuTEKrRInrBqNmtAey0NrYXU/ArX
 82pou1ZfliVdyY4xHB9ZCCkPtXR+liFHuWcYhvLcHk4nx31im/2OTUVrZ0raYFYRU4PlGwdN9P
 4QOqmVZPlrQABPIAAAA
X-Change-ID: 20260611-b4-scsi-d0b0eb4895f4
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Brian King <brking@us.ibm.com>, Hannes Reinecke <hare@suse.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Matthew Wilcox <willy@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
 Wen Xiong <wenxiong@linux.ibm.com>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, Hannes Reinecke <hare@kernel.org>, 
 John Garry <john.g.garry@oracle.com>
X-Mailer: b4 0.16-dev
X-Rspamd-Queue-Id: 3B6791C0005
X-Stat-Signature: rfqtmffhp3zga4dt1dozcwnnez8krcgq
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783145621-923817
X-HE-Meta: U2FsdGVkX1+6RvcylemYFbZKO6efXmb1STKz6XdfKZF7w2e/QbFauaeaTaSJ1I8a7oBFIucOI47SlGMp+bvNcmdoOWsRd3k8TSGuRdjBS+H8wJLtUhjawfpSPjMmkQgbRvsamvPber3OeILmMU1mENSAz4HXZSoLgVrs+zpqIj1VNUeD3eVkGBY7BW91vSHD0n6lhyfneO/6mJKfTRNIw9II7RBobizWcY3yyAhAzQNqgGhVWMw17aIQ8RuVxBNmQF4Dh79aZfzKltfx4voCZ9VkdwICOyggqw+oZcx96MKqY8lvN6TY7e4NmJ7ZRMdk54iLW5AT5F/38YAobd/G29NtWgeUTFTj3lFtUpod6ozJcFbKNDSjr4nQDVO00X8LfQhnTkcM6WG+RIYP8xOtYkeGzotmLj6JdckkiOS3W/8aBasjFqC7FVoYTh+6ym9F7fQO4W/YlPIonEz/dGboth/Pt/QkZlJUtD1ooUk9QzHhvo7gC08LuygkaiKZwUT/ootswGHqM54w8g7jUu+Jh5C9XrW981evbqg8rP8RYUZIKfHAI2zgCYYqPuW/Osa40oPBvDXxAHRiYFNxdQ/TlEKJGM03TjuNqd0D9CdzbEEqNxsS/l93qte8FLmGeXq7q2x4mdrV5uc/lr8eNPGzJTtPGwS+CniVBRO0zds2Fz2PDQTKVfMqF6dT9LHrFU5albwZcPypIqMwqm5Ve4c5Hd4MMAURcKx+Ey7j7Mmq88gQO8gxWEPVywTl6Eg5S5YE83Y+Rhk3MdiMhAQn7+5qXmJNZpM3Lb++rp93+a4ZV3qfFKOBhNsDIA78HNyYNQloPDcDu+1CyAgpueYGmFy4aIyq6+MfCidItIuI1QvA45VUb7if77iokADQl07ji5BLXVuO8X921ygSos3RRNBul43Llj3l4TYjLpUcTE4FJFymbWbPlZEduBAwF2yMb73mI2X2VB58NjfYdeSolSs
 lfG0oqBf
 wB2TB7u7stmf7jvnrcs65imVWVuHXroYBCjnXNXN2pffn305LUjj/j+iYtYaT7eMQosDeNcZ4NhgzUjkIpD5j5md1r/GJ3TJT4YASkTG7lysVbfS2yo1V8nj6BLN58qKK22fl2thDCygchiwTZ+lRV4/KEVmLZ7gh7otsrtzf9C+tIC8LcaOi9k4b5dH/AesVAVzBXZs0dnmo+WkmhA7dKR+MyVAO1xNXUTHwluSiYpP+jCWkKS/NEP0UWFaPk33myC7PFZET4zBtzYWuOrc4/XBLyBO4Cq4czHQSBG+dv/mlVNsu5dvPhuo1oUv5bR7V4pzDJPY0PKJPbP1YEtaXmujIxuUXVjnu16qr9Amd0ljTzJ0Dbo7W8Fhz38lMdQEViprP64oLkdu/8vmEFR8/X3IVqcxZr1T4XbOQ3tTbIcHctcH97qrqjY3G+CNbAIrOU0BRyxnK131DB4DRNZk3CRQeqAxLC0cQLtG3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a (small) part of larger work of replacing page allocator calls
with kmalloc.

My initial intention a few month ago was to remove ugly casts [1], but then
willy pointed out that Linus objected to something like this [2] and it
looks like more than a decade old technical debt.

Largely, anything that doesn't need struct page (or a memdesc in the
future) should just use kmalloc() or kvmalloc() to allocate memory.
kmalloc() guarantees alignment, physical contiguity and working
virt_to_phys() and beside nicer API that returns void * on alloc and
doesn't require to know the allocation size on free, kmalloc() provides
better debugging capabilities than page allocator.

Another thing is that touching these allocation sites gives the reviewers
opportunity to see if a PAGE_SIZE buffer is actually needed or maybe
another size is appropriate.

For larger allocations that don't need physically contiguous memory
kvmalloc() can be a better option that __get_free_pages() because under
memory pressure it's is easier to allocate several order-0 pages than a
physically contiguous chunk with the same number of pages.

And last, but not least, removing needless calls to page allocator should
help with memdesc (aka project folio) conversion. There will be way less
places to audit to see if the user was actually using struct page.

Also in git:
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/scsi

[1] https://lore.kernel.org/all/20251018093002.3660549-1-rppt@kernel.org/
[2] https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/ 

---
v2 changes:
* replace GFP_ATOMIC with GFP_NOIO in ipr driver

v1: https://patch.msgid.link/20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org

---
Mike Rapoport (Microsoft) (4):
      scsi: target: file: use kmalloc() to allocate temporary protection buffer
      scsi: proc: use kmalloc() in proc writers
      scsi: ipr: use kmalloc() to allocate IPR dump buffer memory
      scsi: sym53c8xx_2: replace __get_free_pages() with kmalloc()

 drivers/scsi/ipr.c                  | 4 ++--
 drivers/scsi/scsi_devinfo.c         | 5 +++--
 drivers/scsi/scsi_proc.c            | 9 +++++----
 drivers/scsi/sym53c8xx_2/sym_hipd.h | 4 ++--
 drivers/target/target_core_file.c   | 4 ++--
 5 files changed, 14 insertions(+), 12 deletions(-)
---
base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
change-id: 20260611-b4-scsi-d0b0eb4895f4

--
Sincerely yours,
Mike.


