Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D7B460A5BD3
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 14:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oCh0V0So
Received: by kanga.kvack.org (Postfix)
	id 59A2D6B070D; Tue, 24 Nov 2026 09:04:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5722A6B070F; Tue, 24 Nov 2026 09:04:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 488FB6B0710; Tue, 24 Nov 2026 09:04:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1594D6B070D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:04:13 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9E9B680BB1
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:04:12 +0000 (UTC)
X-FDA: 85470181944.10.15C4B70
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id A36781A0019
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:04:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oCh0V0So;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795529050;
	b=3vVmKovjULIZ++Rd8BtT1s1+JMHyj8Wqo3RXuS7b/uOMjnxnpjmrhrdBl0Ceg6GIm2iF9x
	bkggSF9VYjTKTmr9Q7A4PLL1IEGqhQInrijOX58fzQwp47j1/LZetLiN74BeEOmr5IZqsd
	AgV6qKoQuJAdkEKkQGBX23c3tgzaPOE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795529050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q5EZNv1hoZNsO5LavIHZOtKGm9yaPJJ0vpR/2Fm0XAo=;
	b=6sRjTrBfK8JJ2Wsy/+V0a40kyksIDJ03rH+bZarqmCF+0K6ciw4390fkxjfxg+HoqELrP/
	JbaWasCfSsa9zU145w+5vEugKWxa4rKz6ynGu0pL9kJ9yJxkB6UTZTpxxqA7Rh3kqxq5Ll
	gYAUkbJVtmSiT1x/AllLPPDVqCV9dfY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oCh0V0So;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 38DF36266D;
	Tue, 24 Nov 2026 14:04:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2399E1F0089E;
	Tue, 24 Nov 2026 14:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795529049;
	bh=Q5EZNv1hoZNsO5LavIHZOtKGm9yaPJJ0vpR/2Fm0XAo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oCh0V0SotsrCn9TWTvx54DUqWZ9E5lDYqEYTa/SkfK/tDZ1vzOW7K1B+iPFhd+J9N
	 IMBPfgrvCJBhLO25ivWueHZaBO3todJlUJ0FWSSUg0jzV/v3Kdf01vHxWwiC8NT3KE
	 ajXML1m9831Htpg68RVCN87q2izRhoN9KwgCRK21KifWLU8cP4xS+xyd/1jjXEispa
	 aqVYHhHGm2uNElvmmoTqoOj7YxZlaQQwUJHKVMrL0iBjaGly4K77/on649tqcw+0IA
	 JY8UEIMdEo+PH7RuljHaB/bfBS1rItq08+6Dk419a5HID7kx4JwCgJhAo1hyslk2fg
	 PozyX57TBWNCQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 24 Nov 2026 14:02:46 +0000
Subject: [PATCH v2 03/13] mshv_vtl: convert mmap hooks to mmap_prepare
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-late-2026-mmap_prepare-v2-3-0b0d99d655f9@kernel.org>
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
 linux-mm@kvack.org, Kameron Carr <kameroncarr@linux.microsoft.com>, 
 Michael Kelley <mhklinux@outlook.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2186; i=ljs@kernel.org;
 h=from:subject:message-id; bh=JYQK3wK0K9TDfgdH5JvWWtvXfv1ER9V1zmvapkfLQMQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZZ4o1PGpWtp6mWtz06svzJY2dja9sXqWeFlqRVDKj9
 f9fwfsiHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjICl9Ghr1n6kyr2U7mXtq1
 vXBDo9yCMwtuvVqu9PjO+TrncsbFO5cz/Hd3+BZswOIzW06xUO7ljlVNq98b5kUcm9Fu0HT10/m
 DSowA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: c6bt76qcodpscikcug961nqwzqezgbcb
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A36781A0019
X-HE-Tag: 1795529050-836251
X-HE-Meta: U2FsdGVkX1/TYApYkO7+nba5mqFSEKUD7iE5qttadNvY6qoMLR9nCvJksIM+vE7nyrOIKNJaeZpgJBM5uFexor0++hs2SN1/kaAQWJpE4+ambxDLAyy/4J3CMOdwpPP8EAhQqTIhSaX6vqVK+WQ6a80rOUhUQ482DRaKlKhTAVg1rpRsS5oQi/AiTrqZErNVYd0I2pvIIrTqMqsoKktmTR/snkLGXqrTCRAYCOQH10blrqA1WxdW/89AwyFPZKmJgiihNV5Kx5uMmCOPIZHJ5oFP9JYcVNVM8956S++Z64TMiWuPTJ+i9xiSzOdmmIiAaWP6dmdDJsxmh9TSG/gE5nVy5ZqY7QZcgXN1Zj6WgRexv/dDPRAHO7YfJrhJMrRxB03FyBzLFUTCDtygQI4whmfG/OzZBdAcW0imvu3uIG24Zqo6/HW8MNEWuzI4w3jMrzgOn9X6FrxmFmfAwxkX9e/Mimco/SQXXxagI/OHJKF/gdO7jLtF1wrSQahjbNbMflroi1M/zG+mFeTAax8SJpHzqBg3/CvjeAPDyfiarERcTpqe1UYddukcfip2hR5QVdvAZdr5ttvluYAi57SWiqD69C096SEL3UAdnkfGFKguIy6Tv3TVwue8PtL3N+nMnt49wmzMG7phGyWd5/7yZyzymxe7p3atBrdsrbruljyu7t8VziXQx0WPAzfVlHn5UbV3VEBobprHwqhe8vVJaNX6gUs1Xtkd4te7o69VpPPSS1u4go5HRVBfoXd7vFSWaXPJzZRHuup/+O9zG31r0wlBWJ23v2c+THr5mvBQyuMcHq7x7D6DWYVAKYcMiibeWlJFTajcLjMt/t71+g41f/izA1Amjz44rT7PAWxiudp1hIMYlkGn1MfMEFnhomWWaJDiWhKzMlnm99ehWei9hZgjH/zYmxdZLDEsBFH98Xe7jn1Hd3f4wuxqMDtYfKHZ4bIMKPNJwAXD54Opr1G
 Yep/ElI/
 gv0OMQ1O/LsS96zGpBNR7VkYmP6DzhzG7LcNMDGrDkKJiqd+NDnfxT1r/YMwZLrpDJC0uM4ScNqF3cc+W9WRaYluUVtP5MefsNK06RfQIhBpIJl7niLJOp9i8kTAMV1QrdAQd+IVQM9JcioVGTZzBeU2EOuqw/s89A5BN2jlPoKqUAi0OiFR04rUooBuSvV3rVDEe3KlREtUgephpqLTpF3FWLFB/zWSLwaIVOJjP0poxkjSOgHCyleiMe5+/25d1dLGfUMLX6E0UfWHcgovLwqFUr29sdbC435JPK55F57FnHHJS0o0UDxrwxAJE7JFXbVmb+ZpXm3AnJmucZfbnKsF3pzx2xOeaY1/qRsLun2vJTdC0IG5KKQQC/m3a3jO8PdgDpXJO4sYvUJtLGUgEoA+tBtXIQ9IckkpvRpEGW/RBNSoqVP6/G9zw3dNtqbWfJn+IdJUjonqdCAB5+5/meb0f9Zy4Opmg8xmed7lSCRrmQUeSPxg+6epbBQdhKkiFW8HuVgdEY3FKwbteW0iV+rZTLTw0H3vUeUYyEyJjYrvyKems2VVvhDmI//sMGdSHmZSR2RB1evSdYxgEoYIBMpjrt2oed5cUu8l0gGLZg6VnuJUFkXmi+6g51KZsKoPgzfhKb7l6OTnh8hSmfYsgerxGdI1RHvoUfgzVCN8j/65mnho=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Move from the deprecated mmap hook to the new mmap_prepare hook for both
the mshv_vtl and mshv_vtl_low devices. These only set VMA operations and
flags.

Tested-by: Kameron Carr <kameroncarr@linux.microsoft.com>
Reviewed-by: Kameron Carr <kameroncarr@linux.microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/hv/mshv_vtl_main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/hv/mshv_vtl_main.c b/drivers/hv/mshv_vtl_main.c
index 2d4fe24cecbf..9bfe808f71ed 100644
--- a/drivers/hv/mshv_vtl_main.c
+++ b/drivers/hv/mshv_vtl_main.c
@@ -873,9 +873,9 @@ static const struct vm_operations_struct mshv_vtl_vm_ops = {
 	.fault = mshv_vtl_fault,
 };
 
-static int mshv_vtl_mmap(struct file *filp, struct vm_area_struct *vma)
+static int mshv_vtl_mmap_prepare(struct vm_area_desc *desc)
 {
-	vma->vm_ops = &mshv_vtl_vm_ops;
+	desc->vm_ops = &mshv_vtl_vm_ops;
 
 	return 0;
 }
@@ -893,7 +893,7 @@ static const struct file_operations mshv_vtl_fops = {
 	.owner = THIS_MODULE,
 	.unlocked_ioctl = mshv_vtl_ioctl,
 	.release = mshv_vtl_release,
-	.mmap = mshv_vtl_mmap,
+	.mmap_prepare = mshv_vtl_mmap_prepare,
 };
 
 static void mshv_vtl_synic_mask_vmbus_sint(void *info)
@@ -1324,10 +1324,10 @@ static const struct vm_operations_struct mshv_vtl_low_vm_ops = {
 	.huge_fault = mshv_vtl_low_huge_fault,
 };
 
-static int mshv_vtl_low_mmap(struct file *filp, struct vm_area_struct *vma)
+static int mshv_vtl_low_mmap_prepare(struct vm_area_desc *desc)
 {
-	vma->vm_ops = &mshv_vtl_low_vm_ops;
-	vm_flags_set(vma, VM_HUGEPAGE | VM_MIXEDMAP);
+	desc->vm_ops = &mshv_vtl_low_vm_ops;
+	vma_desc_set_flags(desc, VMA_HUGEPAGE_BIT, VMA_MIXEDMAP_BIT);
 
 	return 0;
 }
@@ -1335,7 +1335,7 @@ static int mshv_vtl_low_mmap(struct file *filp, struct vm_area_struct *vma)
 static const struct file_operations mshv_vtl_low_file_ops = {
 	.owner		= THIS_MODULE,
 	.open		= mshv_vtl_low_open,
-	.mmap		= mshv_vtl_low_mmap,
+	.mmap_prepare	= mshv_vtl_low_mmap_prepare,
 };
 
 static struct miscdevice mshv_vtl_low = {

-- 
2.56.1


