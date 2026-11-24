Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62095606A6BE
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 14:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n4vHYK3h
Received: by kanga.kvack.org (Postfix)
	id 8326B6B070F; Tue, 24 Nov 2026 09:04:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80A416B0711; Tue, 24 Nov 2026 09:04:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7201C6B0712; Tue, 24 Nov 2026 09:04:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 466896B070F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:04:29 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D13F2120B93
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:04:28 +0000 (UTC)
X-FDA: 85470182616.14.9AFB06D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id E529E1C0012
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:04:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n4vHYK3h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795529067;
	b=yCetihaAggNiNKhPb3ggmJQZhyMt11yuxL/ZHd8BAYxEDVytc29jHsEAUavBA352H4gBIG
	CzNUn467iv6OYrBAdPm18tdMu+I+Dx4hiiwcd4fmgBiBAE0cjmKahb3Sdis9efO3tID1It
	kOOyqnHQXUfaFyxuMgHmKJ9kuyYuw38=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795529067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uFq9iZYwqLr+1Gr6UEwgMrMnckIbLB1v4c17MlJoT5g=;
	b=c13A8lKooKFcFG8nj7KikUZxNdCP24nTL3D90whIgmhvvP8rq378SepbcKpsr54Lo2+LuU
	iFXRnHQaGzTM3iBU6RehqFd0ET7wzi/Zdn8ZyxsvnypNHbakoQwmueVm5OYM7ihYHBJi6Q
	jEoxOS1QWIBpgJm6GJOkCnhZCsK+tEE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n4vHYK3h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 097AD41826;
	Tue, 24 Nov 2026 14:04:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2F11F000D8;
	Tue, 24 Nov 2026 14:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795529065;
	bh=uFq9iZYwqLr+1Gr6UEwgMrMnckIbLB1v4c17MlJoT5g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=n4vHYK3heastXfUTv5ny6Odmn4GhFeJjsWDMvoOM4rq57czIeBM1uX2HwsKI+5Of6
	 cWfdqCZutIWrR6o55wcXmgJrwrdNSktSGUMRKVoh80VBsF4YY+clnUFeJleIQ5c0MW
	 0+b9p1+KSNZLSUsm22avuAek7Op1+S83SkVZMJWwhVOyCJY32gIwdaPgwZ+ALwflXa
	 gqUlui6d+xapAgBLj1odarv5GFRZCzZgdga7a5+A2vYj1SnTurtnVRV//J72baeZNd
	 hnTATXOXy01iGcgrYea8kx6/WiYu5rZpkGu5B1iSu0OsY2oRoN9yYVGK42FF/VOfnw
	 Vxw0CovUU3hTA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 24 Nov 2026 14:02:47 +0000
Subject: [PATCH v2 04/13] x86/sgx: convert vepc mmap hook to mmap_prepare
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-late-2026-mmap_prepare-v2-4-0b0d99d655f9@kernel.org>
References: <20261124-late-2026-mmap_prepare-v2-0-0b0d99d655f9@kernel.org>
In-Reply-To: <20261124-late-2026-mmap_prepare-v2-0-0b0d99d655f9@kernel.org>
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
 linux-mm@kvack.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1716; i=ljs@kernel.org;
 h=from:subject:message-id; bh=otXI3L6hiu1+e3GUvlFZNkY4uUSscpdDKkVudqTwPU8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZZ4p/3pO/9eQqxrjic48NLedd6HjU0Ze0iJ3x4YSX9
 xZPYfpv3FHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJ1OQy/FOan/Ss2I01Z1aq
 Tm3p8tSlu2uX/HXc82DW92nefIvKc48y/BXZvkmrJpdhwW+N/IYbwZ+n+Uc/yGi/WXC21+nEKm1
 9X34A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E529E1C0012
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: ggrqhuowzisuc31djdihn5aqhzqznhhg
X-HE-Tag: 1795529066-506974
X-HE-Meta: U2FsdGVkX19ms9xqxvciz5X7z5fCwjYKjMrUS5qQhjmSplzF66npbQdZOVnvji7DeD+UVITcDvesUSsd0pYmM5LRGiJ/abYya0rWj1fdbNLYikrAKpjHypwyyRf4yX7IXUQSlz6QKRrepe/H44w+AC2Jye74XUerm8EMfz411ihS8SvTaxefs8Dv4Z/YaBAuYq5AZThxxLjt4lNedhlSDz41MTt/u1MHqojZH52/C077oBrz3lAS5OZZP2r8Pz45yQ1fXp4wgQchS2PBPOPPumRH0rccReQBASgJD1sa+ySHZSJ9zWv2hbjFAvkGTCxvygQjuy6EzuJ/F6ywdXUKjcjWThBEL/IkfP04z6KYF950hQjwQe9YdC/TkFkkcWN9LSjYPGjDA1bfQQ1/7PAtsBfm0oUSv3lv5N8w2p4uVizCdtuxeIyZnti1dAeDFcWKzKFfTaJ2K7w0cmIe5oxQSZnep4iUVYb7xsbmPjE3bXZ6HbTM1kQnrbMdmZIWW0comr6EQU90rLq4GRGUTJYoPvNRytjj2k2OGX+gdoOa0TDolUdyXigv1XPEIw8DVIdh3hpxRvNG7Tsbn1ZPQja9TQYLSUVhqKFM74Hn73PWWWPhdxw6fFMgss8bbgPmzms8qn3kngxE8pskgg+Q5MFpXtzJZIM4+OKItiB+AT92NTJ1s2CSq1/LxokqMKjVhIPat5Ey8zC0ZxeLwnFcX7YjQd3JDvhD8nYyULRLvVPngcyf0lPJdwCb9WD01JieFepilYALEtEdDJeUFVkFC1oi9G2zuCmREw4+LPBxjXymzD/4+otWdZZiwczsgl9JGZJJvCxdlgy3Dw1sRYgWdJQsAMt/hIgKMs/ii2layv2bgaMpAfgeNb/F4dZVzir2YlXdt3OjgzVlHhM50FOXI0czuCty4+gUwKu00b4oxIKTRh3jg9pQNc9Z7E+iA/2vfDaF+Q0ZsmgI/U+FHnhMCSe
 yADew9p1
 JqrIOa4LOxFaBCWGFpf93AGI9gn4m2SVuZ0PLcaE9Pbt3mq7xxwU0RZUiTaarO17J8eesGBeNFDyiZEL9QWsgcIjLhYvyhMsbfKW0kzF2Gnk03wPR6yX2pCPzUASd9tNTluZoCr0oIZVEXsQbe64atetdE8Pnj2o7VsLnOuHuTf/6RXA6XcbD6mKpNtORq/Ih1w+OCTJZOLWQJjEgtjECYIzS8p4tc3u920AXpHQbpkyO7iVOdHyMLAZhQdqYq6etBJnwF/jHYaaFChqJae6d06VN0TC9w53ggZokQEJu9zQJgqUxdIQas7buMt5x25OgMeFYZIZmPI5Uzz/ALSuO3jDqG6xg44ora29JrbT2YCSzQG900wDHeLww2+wRt4hqS7k51UoTXT1zxAo3/4KhrO8SV8lrVaAAaxE5ESzYaTF5krXbcutslkiyWplbQSRR7EjnSYiZkEnG6VjWU+O5ExPG6kinUGPOzZDovhD30VwQA4e4NjBma0bz8En0Ty13h8FEiveDf0YkHlI8X4aH3/UilLLkppTK5s7HudsjECs2HExC2WgrDp1xOkxR+4ExTc9jeyu0NvV2LcWHSzx0JUz+23f0PsC2hBrVTrK0kDdqrrhJBjhIP883dEnF0LwU4dyS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Move from the deprecated mmap hook to the new mmap_prepare hook. The hook
only checks that the mapping is shared and sets VMA flags, operations and
private data.

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/x86/kernel/cpu/sgx/virt.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
index 6a1933ddc6fc..850990519ca5 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -98,17 +98,18 @@ static const struct vm_operations_struct sgx_vepc_vm_ops = {
 	.fault = sgx_vepc_fault,
 };
 
-static int sgx_vepc_mmap(struct file *file, struct vm_area_struct *vma)
+static int sgx_vepc_mmap_prepare(struct vm_area_desc *desc)
 {
-	struct sgx_vepc *vepc = file->private_data;
+	struct sgx_vepc *vepc = desc->file->private_data;
 
-	if (!(vma->vm_flags & VM_SHARED))
+	if (!vma_desc_test(desc, VMA_SHARED_BIT))
 		return -EINVAL;
 
-	vma->vm_ops = &sgx_vepc_vm_ops;
+	desc->vm_ops = &sgx_vepc_vm_ops;
 	/* Don't copy VMA in fork() */
-	vm_flags_set(vma, VM_PFNMAP | VM_IO | VM_DONTDUMP | VM_DONTCOPY);
-	vma->vm_private_data = vepc;
+	vma_desc_set_flags(desc, VMA_PFNMAP_BIT, VMA_IO_BIT, VMA_DONTDUMP_BIT,
+			   VMA_DONTCOPY_BIT);
+	desc->private_data = vepc;
 
 	return 0;
 }
@@ -315,7 +316,7 @@ static const struct file_operations sgx_vepc_fops = {
 	.unlocked_ioctl	= sgx_vepc_ioctl,
 	.compat_ioctl	= sgx_vepc_ioctl,
 	.release	= sgx_vepc_release,
-	.mmap		= sgx_vepc_mmap,
+	.mmap_prepare	= sgx_vepc_mmap_prepare,
 };
 
 static struct miscdevice sgx_vepc_dev = {

-- 
2.56.1


