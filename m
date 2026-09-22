Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09E7CC982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 04:13:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0E7E6B00A1; Tue, 22 Sep 2026 00:13:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABF446B00A2; Tue, 22 Sep 2026 00:13:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AEBF6B00A4; Tue, 22 Sep 2026 00:13:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5E1906B00A1
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 00:13:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 15078C0382
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:13:41 +0000 (UTC)
X-FDA: 85240079442.20.CA9EB79
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 74A38140007
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:13:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UIKqt4PE;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790050419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JtaSAfNZWJ/23JZX4TX1si8kmJS1+YCVEwp8EWMG/RM=;
	b=C38swiNTHv/rA91aR+Agsw/hqnbNGcF1Wyas13Cwl5Uk1O5U2JYSNTmvnlEFnkwj12AtAc
	5FDXRJKY2iWJL0Gq8wHhd6Xnq/neCIQIJf3buKOxWvWkPkfFdr8beqpbUit/G7JeAvCSLS
	njPNE9+2kIue6O7DFQKYJUfzDVPs0+o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790050419;
	b=CPqPgPQatmGzDzZBiI2e4l0GM9XK+RpCUqjYUNOypc3fgBp8kl3QzXxKYHrdsrLNhitOUz
	RlvL1zJQbYuHmyNlZomCpWm5gjq33HpWY1Qk+6PJ2i1Tgd/WFeoRpBAB6hyLZeaymbWDwC
	GultIMunWZ9A1n2IUIxANwT4H4B3GS4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UIKqt4PE;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A091640840;
	Tue, 22 Sep 2026 04:13:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A081F000FF;
	Tue, 22 Sep 2026 04:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790050418;
	bh=JtaSAfNZWJ/23JZX4TX1si8kmJS1+YCVEwp8EWMG/RM=;
	h=From:To:Cc:Subject:Date;
	b=UIKqt4PEYrcADAfd+X2Wgtg6yh6AcL9MgOaTuTIKnSsq4LFg5XqQR2zHe9a/ZbAZv
	 m+enA1NTkG0SjCXRCFXP0rEzr26MhL5V9/DlyS0N9M+dbPcNkfjfbI6qxWLrV3AGcQ
	 F3m14qPPRKSTGOHRe1Wc348dK9bu5BEQLL4QGi7fNaC0EKz/MHjyOpaPM+j4PY7CD9
	 dEZsxjewEOy7CriZpl8V2yde9l7wtfE+/It8Xuw7X2Fq7zl34avEJRhdc/imcFaBc7
	 zT0GYqf/8DrAL++a16JNCp3QcZJ1dBhofzrgoQP5HvM3CLTXkUKuncZvjrzY4x/kWh
	 BaKemxUoYJoOQ==
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
Subject: [PATCH v3 0/4] kho: rename "scratch" to "bootmem"
Date: Tue, 22 Sep 2026 06:13:12 +0200
Message-ID: <20260922041321.233986-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nj18q5iigonhmd5io8nz5qxjtrkem6zu
X-Rspam-User: 
X-Rspamd-Queue-Id: 74A38140007
X-Rspamd-Server: rspam03
X-HE-Tag: 1790050419-895137
X-HE-Meta: U2FsdGVkX1/ehAjFuR2jCGgdAvwFZIxVQyF7cj/baCDN4DpVW9XFWGqSXn7z5ttjC5KovOwYH9rTvgAqKoAALDFTgGdZ/yYkmwjW0cBRfzG7f6Uy4tIYtW+UCejP0vZwalos5XqLTLsnCo8ubkSzzMxXcOjlD8jWn5ZN54MijvHPTg+qj1XXUEhTh5phIqeYp10TthRMc7uhMrIS8r0N7O2iPpsSIqUnM/5NQQdy3ii1ulePpNrZSgvphIgRJhr1MDIbWOyxsiNfzlXdVm/j8mNMv8YonJN18VSsQz2jtQu5NGfbaAo0Kp21SBCzoJqEzH+LaHAglOFF/Buq20SaVMxbZqqz0n713v3nPjlB9AmD/GXp3eWloigPxEmyl+VFLxco9XPRxPJ97JP/7OD/z0Ly34jila0xI1H95xcAxSM9O/wgqMFofIt4nyz8vHKkBTFXr7q6tkK4wVDjvKYGBnlbTXETYCk9ahTeeJV1WxqNjcOj894o2A0PpEz+Kbje7ABzhXyZ78oSEvPWXzCfzQeYRDxSpUGmxp64ZjUvmxOsSrbU7Js8hLXaWBxaXqCFNKvmlxYZZ1A7s+6QNRvSF2w5RUpY6lE7oRz5nqOQFzEOLt+N+hTej9DXa8dYxmkUySAD6V2UpmoLWZu4/XsciUErsN+PA60TISWUr3+ZFyUUmJCQc0EIZdsTwJ6r7CyVSjp2ZAoawvgta3NHTRZmmL17SKJRN0qQYAIr+xZf6nfVOFjmCQOj1YE3toH0cH8sDLykkWgy3MNYtl9xiu7ewaDzZ9t8/6/+9heQTaIqFx5jHskvgQ+Metyi0MzsgGyp9+nBREWbvf9irMI6QVtdSbawCDoBYzAW5StYQ4cCzu/knoWCMiquVCk2meCb91vLkx6bmLVYbqK/uXp6ZaSZll+1mYTfHhU96RbhXoKjbgIWWl7ugDZ6evI2eOVDB+yv0WvxEcxpxU8ZBW5B+NR
 pqrrhMhH
 ZzFztf05uQgc9+Pi27gb2BoHad6rtSIoQ3kabJqDBi77koJic+f0dmR693QFbRR3R4tDzo/B9eJKKpL9meT0UfmlNoETsiXLxHfVLbEDrwmSsKvWnqPL7U1yAUACxQ5g+a9n4tr0IzJLwTp0an6hE/NO7lZarkxBTflT0nYhAxq0jy2t84qDg6LfiHh7EtFx2kSqD94mocINLNYacdEZb+WVWsPhYi+A79JVIH3AvpFcCIuM=
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

Changes in v3:
- Fixup some typos and update some leftover comments still referring to
  "scratch".
- Update early_init_dt_check_kho() to use bootmem instead of scratch.

Changes in v2:
- Rebase on latest liveupdate/next.

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
 arch/x86/kernel/e820.c                        |  11 +-
 arch/x86/kernel/kexec-bzimage64.c             |   6 +-
 arch/x86/kernel/setup.c                       |   2 +-
 arch/x86/realmode/init.c                      |   2 +-
 drivers/firmware/efi/efi-init.c               |   6 +-
 drivers/of/fdt.c                              |   8 +-
 drivers/of/kexec.c                            |  16 +-
 include/asm-generic/kexec_handover.h          |   2 +-
 include/linux/kexec.h                         |   2 +-
 include/linux/kexec_handover.h                |  16 +-
 include/linux/memblock.h                      |  30 +-
 kernel/kexec_file.c                           |   4 +-
 kernel/liveupdate/Kconfig                     |   1 -
 kernel/liveupdate/kexec_handover.c            | 340 +++++++++---------
 kernel/liveupdate/kexec_handover_debugfs.c    |  24 +-
 kernel/liveupdate/kexec_handover_internal.h   |   4 +-
 mm/Kconfig                                    |   4 -
 mm/memblock.c                                 |  56 +--
 mm/memfd_luo.c                                |   3 +-
 mm/mm_init.c                                  |   6 +-
 tools/testing/memblock/internal.h             |   2 +-
 26 files changed, 313 insertions(+), 317 deletions(-)


base-commit: db3db4c33a1cf89a201ad1a11c63f503b248ee32
-- 
2.55.0.1082.g2b9226bbc0-goog


