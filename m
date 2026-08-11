Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6BA2C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 16:26:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04A4E6B007B; Tue, 11 Aug 2026 12:26:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0220A6B0088; Tue, 11 Aug 2026 12:26:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA3D16B00A2; Tue, 11 Aug 2026 12:26:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C73D26B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:26:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5AC1680111
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:26:58 +0000 (UTC)
X-FDA: 85089517716.03.8412638
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id BCA881C0008
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:26:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kc0kfLnP;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786465616;
	b=GaZ5ea6x+ono0dURKCRIbXKMBBBM7LkoOCgrFQThCOEMxo8UDM7WTzJoqTP66hY7q3D+Sa
	51RnvLya1SxMqghe0iYrjz5U5TlFmmgweAb8WVxRPpWxoUHPTmnHr9cRdTZQ4+VVzHzeIt
	PPgyo29sMYfB15wLDyiR3ieZg0jZooI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kc0kfLnP;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786465616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OGvQP4rTfDtqzEoXAJvcK2bQDBmijHAZnmypqO/G+ig=;
	b=unvDi5Eruwg9CqHbm0WzjyBECycGoRFiEja2gxXx/iolnswBqsNQkhT20siUZ8rEV0parg
	vr47gPpBAMqsQVBEClng0735OrqDBIb0EEmwNqKcFxU2WY/NdBzTHu+KSoxpdGWtteMsHK
	+cUmbn3Hw5aWH4Yn7JXZyX5T97O/op0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E09DA41B39;
	Tue, 11 Aug 2026 16:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A986B1F000E9;
	Tue, 11 Aug 2026 16:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786465615;
	bh=OGvQP4rTfDtqzEoXAJvcK2bQDBmijHAZnmypqO/G+ig=;
	h=From:To:Cc:Subject:Date;
	b=Kc0kfLnPcphAgE8pEpNIHiPSnSgqFFYu15OAJQ7689fKkqv0uf1xN82X5BlruxAb1
	 +QVheRnjiKkms31uMeLjbXRXjCDUv1b9wMj7Jc4/37XsdoPzk0PpeWcKnzFsCskDad
	 3M5L/b1LIofah7chZsD+zQsUXHu1kuet+PjZNkK9Me6xjUHa2eJdBQqflG1+XMsM3j
	 XE5e/yHWpgYWKrwLBhPnIIRraVzU2xdL8C8PKw9C6Ij+qaXpn2jUUQZJeIczgziF9s
	 ElLR4CbM64NIqFwOnGyZ/9M+nVw8Iv9jKkhYqH0wffo9OJu96GCbogJE95ESCBYFOT
	 vJQeGUOX5+yVA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Baoquan He <baoquan.he@linux.dev>
Cc: x86@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-efi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arch@vger.kernel.org
Subject: [PATCH 0/4] kho: rename "scratch" to "bootmem"
Date: Tue, 11 Aug 2026 18:26:36 +0200
Message-ID: <20260811162642.3504565-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.679.g6767b8d81c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BCA881C0008
X-Stat-Signature: 13bijc9hqx3hgm7frnq3ubjkm5z8x3pm
X-HE-Tag: 1786465616-670960
X-HE-Meta: U2FsdGVkX18mymiCSeidZc0kwPaDL7sNFFQJzFdsxCWhfKRIFSQGyJ7BbZMcLswnW0rZkd5uhrWJ1oSm/461iupqQusXneU5bVgl3IOc4C1rsgocClQZY2HQC0Poh/4rB3goq+18881yh4eDTNXOVgDTs4j2DN3LZ4QsU/6Wo3jtBFQKy/A2nq+yM5e/yXYqHD39hqPfZHo9glenTMkZgAnXBWJyZJkZIswTvMXikEYfmWzKXRjgzLZNECr7yxexINOv9CGgSlW6HgmBVoAgoEa/+BB+1D3ZPW8XxmTDWT6H8i2O8KuZs4WiCR5jf0dGMEBk67v5ogTsb21eeAv/Eba0c7EOCFc7gPgzs1gSSXtf2gQbz73HpfXvKRBTBBsfdfZiApLQKjpnYpe9N+QkSak7XYlZwrgLV1PAEeXCchL3CzEeVu5eq7QQ/1/OjBWnG2svo/FFRIUMbErmo+iFbvb2i/qq76uDrxqam1em77VGGk5MdlEQ1DVijTIefrN7bG4wcKadUROAROnHgw14d17BHMwo2VLdGNHJD1XSgkF4dghxukiQXHbbfqM6fkQ7f9OLWveVo+ygFW3fm9xzIOWADTv+i+rCqEGwv84p1FuPBuu3zEEXL/S49K7PVLmXYR5xQrJS8An6yOffy8iJgd0x1vVgCNXI5EixrNUvGxapO/wd29J2vpP/HPxWAIfHlYsQM2hqpvxDM9e7Zhoxfi+m0Dnd2dr8ifoWPfNFw64N8XdlXkxftKQemvpOEGl1AF4QjXWsuS+mS/+cQJBF1KYPtyPVTGWnjU3BICHCJ68ew7pjG97oQJCWAOJKV4hmW21Gs11qbwhvjNNND8CDQGd/j5EZwyfkKti1OHqLJ9IMAC1mu7SOFC9TMyXVga8jYprFt6vpt/TyYYbdw0NjiD8g8V4r+uhUeSSgk3YsktxqbF35DmOgnybtyrO+LkMeOLKi83hcIFemEFkhmlN
 ay369vBh
 G0b2PKEVrYW326shDcPUQB3uTfG2MQ868kcpZmkwT1BYso+hyL6Cf/niZ1F+wK2luPmdr6ysC+xdafkrXltUChtphX8ZhVcr+l7+Wdg0PhZMDvrSBa6oFbhWPJSXWnDTiubB35TscAu6Y16Ifzswjt5UKyZ0eW5H3xV46WZVD7KJ6uekx+99C1eb+JBRf0EeWnOgAaQ8uUZKdS70qfvqu4XK8BcplzKgXsQwtgg37x+EzzOI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

The term "KHO scratch" is vague and overloaded. It does not accurately
describe what the memory is for. This was discussed previously at [0].
The conclusion was to rename "KHO scratch" to "KHO bootmem", since this
is memory passed by the previous kernel for early boot allocations.

In addition, memblock does not care about the provenance of the memory.
It cares more about how it should use it. Use MEMBLOCK_KHO_NOPRSRV,
instead of MEMBLOCK_KHO_SCRATCH, to describe this memory to memblock.

This series does the renames. It also gets rid of a redundant Kconfig.

While the diffstat is big and scary, most of the changes are mechanical.
The most interesting functional change is in patch 4.

This series touches a lot of files across a lot of trees. But since all
of that is purely KHO-related code, I would like to collect ACKs from
the maintainers and take it via the liveupdate tree.

Ideally we should queue it in liveupdate/next early in the v7.4 cycle
since it will cause a lot of conflicts with other patches throughout the
KHO tree.

[0] https://lore.kernel.org/kexec/agHGOxSnP_VraH1M@kernel.org/T/#u

Pratyush Yadav (Google) (4):
  memblock: get rid of CONFIG_MEMBLOCK_KHO_SCRATCH
  memblock: rename KHO_SCRATCH to KHO_NOPRSRV
  kho: rename KHO scratch to KHO bootmem
  kho: rename kho_scratch= commandline parameter to kho_bootmem=

 .../admin-guide/kernel-parameters.txt         |  15 +-
 Documentation/admin-guide/mm/kho.rst          |  18 +-
 Documentation/core-api/kho/index.rst          |  36 +-
 arch/x86/boot/compressed/kaslr.c              |  12 +-
 arch/x86/include/uapi/asm/setup_data.h        |   4 +-
 arch/x86/kernel/e820.c                        |   2 +-
 arch/x86/kernel/kexec-bzimage64.c             |   6 +-
 arch/x86/kernel/setup.c                       |   2 +-
 arch/x86/realmode/init.c                      |   2 +-
 drivers/firmware/efi/efi-init.c               |   6 +-
 drivers/of/kexec.c                            |  16 +-
 include/asm-generic/kexec_handover.h          |   2 +-
 include/linux/kexec.h                         |   2 +-
 include/linux/kexec_handover.h                |  16 +-
 include/linux/memblock.h                      |  30 +-
 kernel/liveupdate/Kconfig                     |   1 -
 kernel/liveupdate/kexec_handover.c            | 340 +++++++++---------
 kernel/liveupdate/kexec_handover_debugfs.c    |  24 +-
 kernel/liveupdate/kexec_handover_internal.h   |   4 +-
 mm/Kconfig                                    |   4 -
 mm/memblock.c                                 |  56 +--
 mm/mm_init.c                                  |   6 +-
 tools/testing/memblock/internal.h             |   2 +-
 23 files changed, 302 insertions(+), 304 deletions(-)


base-commit: 352ebb57013a08679788bc18c7f9af90903db256
-- 
2.55.0.679.g6767b8d81c-goog


