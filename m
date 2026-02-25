Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ADA4F357DB
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:20:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D99D6B0088; Wed, 25 Feb 2026 02:20:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9836B6B008C; Wed, 25 Feb 2026 02:20:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8936D6B0092; Wed, 25 Feb 2026 02:20:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 75F016B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:20:48 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 22F0DB9150
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:20:48 +0000 (UTC)
X-FDA: 84482131776.25.187340D
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf11.hostedemail.com (Postfix) with ESMTP id 220544000D
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:20:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SSsSFA3e;
	spf=pass (imf11.hostedemail.com: domain of 3zKKeaQsKCN8BDLFSMFZUOHHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3zKKeaQsKCN8BDLFSMFZUOHHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772004046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=d6TXtnvwLicbHQpLQAZLl5+hwl+mc9lbUmp9ZzO2MHE=;
	b=pqxknAtdvJIzgvPd3I/IPmooVwaOe+eFd8VS1oumU7cDqE+ggTa6lP6KgMh5WrD5j0qkBj
	mkcgKOyWjq3uVg2oziLyGYv1xd2zaqc3nI/CfjoIP27vxa0cML6E3YFo+uQuTx4Wzjbwqd
	kpLaDgl930OAA+iEoy64YWZpvXvjv1U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772004046; a=rsa-sha256;
	cv=none;
	b=EvK38YWwcL6aywao/OGHMc2VR/HTsBhiAd3+aYWvfrr0aaFbXmBr3hFlzJBxBrAf5awGL3
	lukLIFOihoI/gPEVMK75WE5n4EJ/Fcldu6ehW15oLcZJSZPg5QPy5GsEQ+LpQSzcIz8R8t
	Lt/gkaWLH10DmmlH3NUHM6NeaGEGe9I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SSsSFA3e;
	spf=pass (imf11.hostedemail.com: domain of 3zKKeaQsKCN8BDLFSMFZUOHHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3zKKeaQsKCN8BDLFSMFZUOHHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c70eb4d56fcso169525a12.1
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 23:20:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772004045; x=1772608845; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=d6TXtnvwLicbHQpLQAZLl5+hwl+mc9lbUmp9ZzO2MHE=;
        b=SSsSFA3eFCAk/N6cj3PwvxxwoFkDIrDNXke/PNjdNk3cvhLdGcC/LYvlUbQoYhMpjI
         IuBoVtzJIEQuP8Jtjptj5fo+joCSSx7MxdW878SFGaqKZTK52h0hu8IICB6bSWSWUCJv
         d8hHSSUqEZR4yDg3CvKo5GKEasVzaWtiilcitKp/YhIPBQT9liwn1irusbxJI/F4FWTe
         cGoxab+AMmtd6nTzMYBhVdvmylNoAizlCoVOp6imI0xmEtnUje7+sOsuywn+Jft0QrDT
         iPwI0DaMAUXZDGPfnY7m84v0ZY3beIDVLPNwrTTM0GLWBjTL5cBKG0DsrZX8tnXwqJfs
         QwfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772004045; x=1772608845;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d6TXtnvwLicbHQpLQAZLl5+hwl+mc9lbUmp9ZzO2MHE=;
        b=Utum/JPRSg7nA15KWQ1WA0zIcxam8c6bMLJokVGeiazY+5g9qppQysBa/eafmcNJT6
         95/2l2oOZx4qccsN0rkiYhIFuBDe1DwwES/gMeTp5kH1cL3DqDCarLYbzDExu8VdcPry
         x4JKJV+mbpWP3DqpcxjPKC8Sbf+huWbFDC2lkidAwgWtwWXuIVTXSakc2TFMCgC3Qrzu
         51seXtw30qWLifP+jKGEA+/asYrhiqC1wXthiOjVlH5qircEWsWdSRn9F7UoqFU5WdzA
         AmLWYY5k/UrEmmdMjBrt8GcqoPNMgq7SJSU4/PPB8tt/YsPHF3RXSpoV5xXiEXibv41b
         f+FQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJW4trGuvLBeVjLS4tQwCgDPWDirU151vH7K/zLsUWHUfXtxJPGAf7OKboPtdLTKNmC2+WPeRsUA==@kvack.org
X-Gm-Message-State: AOJu0YyGH5ShavR2I5nydk2sm/w9RLuWq7nBALYRKW/CzTCwp1acQyl8
	RUnXdHGvod1GAZk0VlGH2he5HXcOTwEujjIr9fBK6VD5MOnCM4zQBYrGQnLa2QwJXLQlV97q4od
	Qd2VemYN4PVwnzLheMUQ9pjG/vA==
X-Received: from pfrd8.prod.google.com ([2002:aa7:8e48:0:b0:7dd:8bba:63ae])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:4b48:b0:824:3cf6:3fb4 with SMTP id d2e1a72fcca58-82724ad3d76mr1244872b3a.32.1772004044566;
 Tue, 24 Feb 2026 23:20:44 -0800 (PST)
Date: Wed, 25 Feb 2026 07:20:35 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAMSinmkC/x2MQQqDMBAAvyJ77tJkgy30WugDei0ekrhqsImSF
 RHEv5v2OAMzOwjnwAKPaofMa5AwpQJ0qcAPNvWMoS0MpOimiGrsI0eUBd138qPg3ZjO1K1WpDW UaM7che0//MD79YSmSGeF0WWb/PB7jWu8Jt4WOI4T4brp3IAAAAA=
X-Change-Id: 20260225-gmem-st-blocks-733f35d10211
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772004043; l=2746;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=1KBuBd+iCF9NBYsLqHZsB0ZWhDlklDnzPDb6M6VWVQ0=; b=Zz87QRaHSCeDiOsHB8ebvN65q32EcPSJmRS6Ln83VHPYZkFWp0MlXR9c101r0+U45Euo2bPtx
 hkGErWsyijFCg09E6FZl6oFb5HuZujG5xLp0UOWWG/tslIKNb5ZEzQL
X-Mailer: b4 0.14.3
Message-ID: <20260225-gmem-st-blocks-v2-0-87d7098119a9@google.com>
Subject: [PATCH RFC v2 0/6] guest_memfd: Track amount of memory allocated on inode
From: Ackerley Tng <ackerleytng@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	seanjc@google.com, rientjes@google.com, rick.p.edgecombe@intel.com, 
	yan.y.zhao@intel.com, fvdl@google.com, jthoughton@google.com, 
	vannapurve@google.com, shivankg@amd.com, michael.roth@amd.com, 
	pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com, 
	tabba@google.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Stat-Signature: csgs86eee7x896kftgfx8j73to1apw1x
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 220544000D
X-HE-Tag: 1772004045-833674
X-HE-Meta: U2FsdGVkX1/xRAHRRoaCAU1oLTT2cWi0LuEb6/CSq6sON5E6jTQk2SjUWDzwo9yc+4NQyGSR0IfJtgy3+f3AIST7X8HTVCfXIiFw81aSqYNlH8SSxLRGeWud5NGijFl3cW0GHeO/eNHnpUg6cy1L5Ni1xF4CFUEX0Etv2347/u+R0Hvm7QLBmt1CdOi+WvrxNG+HkGf8enza6d9fi9iltVgwhFMa7zgDuFZVFN5LHKgnB/mJL0JtvZUxpafbFd96QxNcD7NsKurUyr/8WMpqXC82D9Og7k2kKASTAjXl+Z5xg7eXUN+xhyOXenrOkY7zLwq47qRBDb0sDinbvxQ4u3a+h3vrY3LWrmvZfG30UpjFk8TZVf84v7KhRMHAXO31KQKHaSjAarV2h3ik2OrpclVA+dK8MeDHqE+7TV0x4Wb3f9EgMwThbz1i2dL9UHQMcPL1BH0BAX7lUM3eVg2VYvLo3MhH70nOC4ZfFQN8UrzMv/NyHpXlxTBEN2AfZsRXZnbk8mZE5WUVE9NE3gr5b9X21sVRvavn+ZyLu7kHuYnOWFlucZRdhABWZ4kRqKbd2kAGSNzu/TtQeTteeb+JlMFgVT2AvYDSJmP78na3rZDpZOrDZAxeznSC6RFrhQbxS3+TaZs0+yzkLeej8WQcSSQPYJQr7LUXUDdAvKnTqga5fbloQSlBOvOlRZn3F1Nmj3ppo4YzVYd7zLLplCOyzs1+3ztr3uAfEEWFhUevKD/1hYfKPv9dmGV4s9WVS4vMRKz5h6JjqZGMNX2MYousMQzNNvgz702YdpQIxOAoZZYzk5rAZxhiFKr8lYpGH2UyRH0ZN0jZbmF4LtVg8X+xDic5u9WDBOATV8jlYeknDty99dvXudY7kd63ahixEIpZz8Jyp3bdyuO61JAZ29wPCyk4teESU6LiA5bYHw7B/ex+ki9vBKqCtRTQBoMsBk3DLNTJepJlJJBH+chkKbS
 h0J/oKBP
 SRveblMpmVZZHLY44q9sOIT6GpMGGMNRAAJez/+SIoR2gp2PMQ10s3OOnkaWj4lH5bqBa++7f96CoWhKa2KXJNOg4TNww8JMLyNMQkV9+y64EDEkxsu3UY73NSWrNUwTTs49LfPKJdPNYgsu/5ur8fsknYxL03gt64u7yKn/YsMqaJ1QvsSOAa3lHtnJEJpF3sSg+OvJxXhbyZ9nxlxuep3guK7GKZicZuxPX0VsJez8Rf/uKTi6mtRZDp/I2tzIL34qwLIopk+LEoKiVNan4n860DuZ9SMnI8zvWH51AMjxA4CIwAuDRym05u8SbAo+ZPzIA8QJvR7NeS0i+acKrYQW8aglDAa4Ac/N/pucfamfU9iTm0Q49Ik9nlMZ+w1Ph9A6Itl2RWOhyWLfLGAUqD7+A4fQEEPzz49YVkgzTErm3LTJYBrlJK49GqINnjpw+os4YkqNeJ4aX7cz9bNksexMFLOubwfFjCewnIMb5Hyg6bD6B9sygbsGUEhzg9vxqLv/56SjZB6pv9t1Klg5a3M+hyi5stlbeO2HtX0jCyLewr+X2niPrJCrvhQ2ZyxXO8cYJqcUbO3bwOd2aS9KVN9v9KzLUgWmISSseUeqBrYmhJy7XcGC/88UBZHYE4ZXDKAVCI3b2ktSEIRSfbM7sjb0iosXrhqQKU/tptKacCFcaKq4qlg1dSQnPHUendzTc8Lysd+K7wmPGetzDzkYiUhczURfQK6mtWB2RjQCbEO20GPM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Currently, guest_memfd doesn't update inode's i_blocks or i_bytes at
all. Hence, st_blocks in the struct populated by a userspace fstat()
call on a guest_memfd will always be 0. This patch series makes
guest_memfd track the amount of memory allocated on an inode, which
allows fstat() to accurately report that on requests from userspace.

The inode's i_blocks and i_bytes fields are updated when the folio is
associated or disassociated from the guest_memfd inode, which are at
allocation and truncation times respectively.

In RFC v2, to update inode fields at truncation time, this series adds a
new .unaccount_folio callback to struct address_space_operations, which
guest_memfd uses to deduct the folio's size at truncation time.

The second patch, to use filemap_alloc_folio() during allocation of
guest_memfd folios, was written as a debugging step to resolve a bug
found by syzbot [1], but turned out to not be the fix. I include it
here because it cleans up the allocation process and provides a nice
foundation for updating inode fields during allocations.

The first patch was separately submitted [2], and provided here since
it is a prerequisite simplication before application of the second
patch.

Changes from RFC v1:

+ Removed a full custom implementation of .evict_inode for guest_memfd
  in favor of adding .unaccount_folio callback.

RFC v1: https://lore.kernel.org/all/cover.1771826352.git.ackerleytng@google.com/T/

[1] https://lore.kernel.org/all/29c347bde68ec027259654e8e85371307edf7058.1770148108.git.ackerleytng@google.com/
[2] https://lore.kernel.org/all/20260129172646.2361462-1-ackerleytng@google.com/

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
Ackerley Tng (6):
      KVM: guest_memfd: Don't set FGP_ACCESSED when getting folios
      KVM: guest_memfd: Directly allocate folios with filemap_alloc_folio()
      fs: Add .unaccount_folio callback
      KVM: guest_memfd: Track amount of memory allocated on inode
      KVM: selftests: Wrap fstat() to assert success
      KVM: selftests: Test that st_blocks is updated on allocation

 Documentation/filesystems/vfs.rst                  |  8 +++
 include/linux/fs.h                                 |  1 +
 mm/filemap.c                                       |  3 ++
 tools/testing/selftests/kvm/guest_memfd_test.c     | 32 ++++++++----
 tools/testing/selftests/kvm/include/kvm_syscalls.h |  2 +
 virt/kvm/guest_memfd.c                             | 60 ++++++++++++++++------
 6 files changed, 80 insertions(+), 26 deletions(-)
---
base-commit: b1195183ed42f1522fae3fe44ebee3af437aa000
change-id: 20260225-gmem-st-blocks-733f35d10211

Best regards,
--
Ackerley Tng <ackerleytng@google.com>


