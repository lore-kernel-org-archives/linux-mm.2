Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1515606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 14:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m5RF+lzm
Received: by kanga.kvack.org (Postfix)
	id CEBB96B0616; Tue, 24 Nov 2026 09:03:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4D206B06E8; Tue, 24 Nov 2026 09:03:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEEEB6B0616; Tue, 24 Nov 2026 09:03:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF99E6B0707
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:03:26 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 18DFBA7F81
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:03:24 +0000 (UTC)
X-FDA: 85470179928.04.29BD09A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 240CD18000F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:03:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m5RF+lzm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795529002;
	b=qg/R7d62h/HwucjZ3FxWt7f7eIGzE0Nfh0KYia5lfADOQWo1YsdSPpl/0Shx3JMhj/BJWy
	hP5wimbXtHs2QEfoKZNH0nwVvWj69wsB2NAoYg8Z3Sqha5jYGLR2HMvHi3svjjgg+Q4von
	YQDkYHNt1gdHT+H6purmfpsG8Izw71Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795529002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Pcp6KuvRcMiXfM74bIVPa/vEkoJOU8lTqnsRQrOb5o4=;
	b=Omr/YNy7D5Qqb7uLCKYULT2m6nnvg0AVKKnMkJWwuFYgym6Mm+dtlTJ/6S11ez0YzELsrL
	lfxrY4KSFXOy5Q5XQoDDdAi2kfBriZUOvcONk/H5R17pQbx9wvG8hAD28YJeBiZPaIkJnZ
	/jkDI73aFVmE0i0tWexRcbdfmJBcgto=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m5RF+lzm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 470F941AF3;
	Tue, 24 Nov 2026 14:03:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9741F000CF;
	Tue, 24 Nov 2026 14:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795529001;
	bh=Pcp6KuvRcMiXfM74bIVPa/vEkoJOU8lTqnsRQrOb5o4=;
	h=From:Subject:Date:To:Cc;
	b=m5RF+lzmoV0KlfOio0Dl2o69dI4rgtq9fEDM529z18h4bvXVByTYYPIrO3nfq66Al
	 S7b0xt4Isk2RZvdXlVCnJO2H9ApRMebR+cuuc1Mh6rszX9Zhla035nI0F5C6x/MHLD
	 XeitIh3tzBgM7PxhrmmkTyrk505660hD/3k2opBfr2SrNPC1Zqxuz4rugypmvl0YHv
	 L7i+BrNOy0yloakdV4vIbbD9MhDsYIvWUGxQp/CF8ICGFRPZrqEcGhx7b//ugJyzLI
	 jvC7NpeW/ds4v/oSUDD3cFClNVL2B4axAeKCDrEKLPDhequ6MiNoo2JytLwjxnVOOr
	 e+11WXxZ6coOA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH v2 00/13] mm: convert further simple mmap hooks to
 mmap_prepare
Date: Tue, 24 Nov 2026 14:02:43 +0000
Message-Id: <20261124-late-2026-mmap_prepare-v2-0-0b0d99d655f9@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/3XNywqDQAyF4VcZsjZlMkUrrvoeRUrUqEO9DBmRF
 vHdi0KXXZ5/8Z0NoqiXCIXZQGX10c8TFMYlBuqep07QN1AYcNZlRJZw4EXwWDiOHJ5BJbAKWlf
 nt8ZdyZJAYiCotP59wo8yMdD7uMz6OX9WOuqPTP+RK6HFOs2Ym7biKuf7S3SS4TJrB+W+71+eu
 Pr9vQAAAA==
X-Change-ID: 20261101-late-2026-mmap_prepare-02c87d23101e
To: Andrew Morton <akpm@linux-foundation.org>, 
 Juergen Gross <jgross@suse.com>, 
 Stefano Stabellini <sstabellini@kernel.org>, 
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
 Jason Wang <jasowangio@gmail.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.com>, 
 Paul Moore <paul@paul-moore.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>, 
 Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@codeconstruct.com.au>, 
 Ryan Chen <ryan_chen@aspeedtech.com>, 
 Billy Tsai <billy_tsai@aspeedtech.com>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>, 
 Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, 
 Scott Branden <scott.branden@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Richard Cochran <richardcochran@gmail.com>, 
 David Woodhouse <dwmw2@infradead.org>, Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: ljs@kernel.org, xen-devel@lists.xenproject.org, 
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 virtualization@lists.linux.dev, linux-sgx@vger.kernel.org, 
 selinux@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-aspeed@lists.ozlabs.org, linux-arm-msm@vger.kernel.org, 
 op-tee@lists.trustedfirmware.org, netdev@vger.kernel.org, 
 linux-mm@kvack.org, Kameron Carr <kameroncarr@linux.microsoft.com>, 
 Michael Kelley <mhklinux@outlook.com>, Jan Kara <jack@suse.cz>, 
 Abel Vesa <abel.vesa@oss.qualcomm.com>, 
 Jens Wiklander <jens.wiklander@oss.qualcomm.com>, 
 David Woodhouse <dwmw@amazon.co.uk>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2820; i=ljs@kernel.org;
 h=from:subject:message-id; bh=cNcQh1oes+NuXX/SLhNhorMmsomyqOJdE2nbt8XExvk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZZ4rIHtHcwB4V8Hin/yxTxk7PB9MvbI3XXNtvsWVPh
 GZ0tPrsjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEykXpmR4T6L/n7RH25zgz5/
 uKz5oG9xyJmgPXZrlS4HfLedtXeZAz8jw9ZDvbcNpRcv4J5c+V/n8+cDm1NbX87R834vLWG3KFv
 2OzMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: rdbhoyu3u3estxii1h1bykfw65j99w9x
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 240CD18000F
X-Rspam-User:
X-HE-Tag: 1795529002-665478
X-HE-Meta: U2FsdGVkX1/dC0y+Qsjm5vGgFzVNNd8E50z8I3iwocjOx6ELdUHlkwUWXw3TTlPdLSROhf3/xD3ixsX3RZ3E13vOBgVCNsSTm3d4gAmT6vtVIeSV+w0CxcYoxmfIDyYuNNn3NJ4lc0TOJv9ml0MRSTeI2PMU3YNypkXnCjYRSk59sIJOoLpQhSMHzaKJ309WQu6TlWivlGTYyLTkyJmCrUV76PwH2Bs6+9LxKNqg3Z2wjFPYI58wzcYGbOPLc8gPWTLM27m9qKkyVOJ5eSLBAcaDCGVnZjMn4xbEfE+oy1+QIRiCP13PWClDX63x3H0kFpjm0wLOjIMYPuvpKvd5AWinzACdt96mF1cvkmq623+zRhEDpV9MnCTyVv1FJa1A1N0S6ocAwDiXHjROgFWbT3p3ateuYO5bt/7FSyQyX2QKl3rf+pMxedAn8InMYGhqcZ06K8Tx982m4HbhP9jdUzlWK5cxhodJvWo338BbWkYlDlk6iO8tH2IVFlT03uXzWI3ObKb8gpV/i7Fy4qtmb8mSsLu0mkelKw2TbyZw/xxsPnTBBOMWHWWoqEo73RLYZik9wM3hFxDDdikNf4oZy2k5unu1QieUICZHR6OsbpPhFngTyBz3aq25RR5a3YlnYBmXGFsxuKAHOOoL6kGeu2kpD4S7Kj1Q+6/Ajkosl95l3/rXIXSFs/THvgCTkV91TDlUKUxp46IPVzXf8NOMW2WNkCJ4N7TrfFSlPiLd87LkP0Av6cYMYzLPUogPBAvcSW1U/xNIPODbT5DLXNYkvIRQZojvKZy9biGWAuhdr9RemhCVqlKCED1Uyv64DZ9qJtHnfM9yIBUZQwAHEACQzeF3+0RwuXRtsFU3kr6Gj5jPoR0zEA9nbM9E4cVttXHtLuOZtOMZVVltbhFTRgZbJCfTo6tJ0uZXMEF/ipwWbAKn+eXqPtJBMFWG73q+uhgkdCaFgKPPz8DPLdVd3c5
 RG1a4LuL
 UhbLagRdUFiBlHFbttLQ38+fjr3VfPG9DORpELzjNOALPQgJrfWsPoGgfttPAN1Ew4s6HvrCd0jyEerukIIET0bL0M82gtzVf9nR2kfbSenjsWO03ASOyZrre+W0oH8QmeKZTytVcFXp/lW9t0qVWN/KybC3dlykFZvU1kWQtnVqifeiBz9tc+KgUpw929l9ViKFlqUn5BQf7tmwi69nGgYUg1jm58X6qPqNiQ3WMJObwR2MnScq7bpQivJrT30B60wAaWdcsjm1QUMAyEE/vJhZiEMPTbjvJR+a3ZMUWqoQ4tqJIHbP/gLQusOlL4Pv2fJsoQB8eisSkftgdnI3mo4lW3mH+xBYerYzJsQ73i9HSiia0r/8yulWOQShbogddkUTsFNjjpJDtdpbMfue7SQFBFLqsQOTFttE30EIH/xqjknnqz/jkSDncfYJOFAvMSTh1/3Esl6CW5LZJ4ON094fsf7YaeldLile0HHjGwwweEHVpgCw+OmdGwUuQOCEUHBT3adX6eveP+wRtSWelLoMz9pf3ibBgc/9SBGxJQ0o1YrL9tvSQmfTXRdmhLEbFIs10lHBgHHfk9eTHp8axtzFddjaQ2YI+ZVanqbwTyGKgVNax6X6Mmdoxpr+xrv6r8szu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Continue the conversion of users of the deprecated f_op->mmap callback to
f_op->mmap_prepare. Keep things gentle this cycle by targeting simple
cases.

No functional change intended.

Build tested on x86-64 (allmodconfig, each patch individually), i386,
arm64 and ppc64le.

Andrew - could you take this through your tree as it's a kernel-wide
change?  Thanks!

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
v2:
* Added tags, thanks everybody!
* cc'd linux-mm, Andrew.
* Dropped the vduse patch (was 4/14), as commit bb2e6f166547 ("vduse: fix
  VA/PA confusion in the coherent page fault path") completely broke the
  driver and was merged without testing as a hotfix. Conversion can wait
  for that to get fixed.

v1:
https://lore.kernel.org/r/20261105-late-2026-mmap_prepare-v1-0-c56aadfbab8a@kernel.org

---
Lorenzo Stoakes (ARM) (13):
      xen/privcmd: convert mmap hook to mmap_prepare
      KVM: PPC: Book3S: convert spapr TCE mmap hook to mmap_prepare
      mshv_vtl: convert mmap hooks to mmap_prepare
      x86/sgx: convert vepc mmap hook to mmap_prepare
      udf: convert mmap hook to mmap_prepare
      selinuxfs: convert mmap hooks to mmap_prepare
      xen: convert xenstore interface mmap hooks to mmap_prepare
      soc: aspeed: convert LPC and P2A control mmap hooks to mmap_prepare
      soc: qcom: rmtfs_mem: convert mmap hook to mmap_prepare
      tee: convert shm mmap hook to mmap_prepare
      misc: bcm-vk: convert mmap hook to mmap_prepare
      ptp: vmclock: convert mmap hook to mmap_prepare
      vhost-vdpa: convert mmap hook to mmap_prepare

 arch/powerpc/kvm/book3s_64_vio.c        |  6 +++---
 arch/x86/kernel/cpu/sgx/virt.c          | 15 ++++++++-------
 drivers/hv/mshv_vtl_main.c              | 14 +++++++-------
 drivers/misc/bcm-vk/bcm_vk_dev.c        | 20 ++++++++++----------
 drivers/ptp/ptp_vmclock.c               | 19 +++++++++----------
 drivers/soc/aspeed/aspeed-lpc-ctrl.c    | 20 +++++++++-----------
 drivers/soc/aspeed/aspeed-p2a-ctrl.c    | 22 ++++++++--------------
 drivers/soc/qcom/rmtfs_mem.c            | 22 ++++++++++------------
 drivers/tee/tee_shm.c                   | 14 +++++++-------
 drivers/vhost/vdpa.c                    | 23 ++++++++++++-----------
 drivers/xen/privcmd.c                   | 11 +++++------
 drivers/xen/xenbus/xenbus_dev_backend.c | 14 ++++++--------
 drivers/xen/xenfs/xenstored.c           | 14 ++++++--------
 fs/udf/file.c                           |  8 ++++----
 security/selinux/selinuxfs.c            | 24 +++++++++++-------------
 15 files changed, 115 insertions(+), 131 deletions(-)
---
base-commit: 5bd93e4b0b357e9d0a13199887aacbf04d1ce216
change-id: 20261101-late-2026-mmap_prepare-02c87d23101e

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


