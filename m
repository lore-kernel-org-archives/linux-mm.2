Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A73876088F37
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DH3WWfas
Received: by kanga.kvack.org (Postfix)
	id 1458F6B05CF; Fri,  6 Nov 2026 19:37:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11C276B05D0; Fri,  6 Nov 2026 19:37:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F23066B05D3; Fri,  6 Nov 2026 19:37:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B06966B05CF
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:10 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4930FA027B
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:10 +0000 (UTC)
X-FDA: 85406458620.27.BBCE40B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 29D1B20002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DH3WWfas;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011828;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gk2cfa76K7no8CMo3L+lgNXbKBncI0WegUISZ77kabk=;
	b=tf9RsUY3AgLOS7J9E7i1Q0k5epu4F2k408L/lx8bDWZv1P5As8BOD8V4IgwyLBY0i7+NwP
	rfEW4YG8ZEHzwI6KFtF+dkFYY5X6XpSi4gz4JFwt7rsNrPYtOkqHzfhDfODfnuHeHC4Ps/
	26VHWR8a8eArYN7tovMRT294ZGVxXt8=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DH3WWfas;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011828;
	b=p5OBk3NP3HQcYOoMmJmVAMouuRF8f7bgwmStNxFSePnFQoPU/2ECAIA5pkvPJwsUAnwPJf
	zumzuaGl37BDTODr6/OpRsJp+1h9krrJUdiCsB1ytWauC0xVCdNT9K8ljt/3Qm7PFkrz2c
	iyk9LBFYK+TSctkV+QXHQhjQQ7UgfiU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B9A944082;
	Sat,  7 Nov 2026 00:37:07 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011827;
	b=mcEZurotoTGb64iRyoCWiMi4CMxhAn5e10H4rLOnEn4TicyDhmvmzAkEufymJgPxxJZm
	 xM32x+4V3wD+DxrLNcchy95aLgtHEPDN7+w0KRqdtWe6V3YvAt0E5gNOr4GosGJE9w2GW
	 4K2LMEQpQxdWJzrHnzwxJIeCkNRQfqI9OHBYKLWHLEhGM5XHtRcFdVLQYnTja6gPTk5qd
	 4E0HQO6d8Pfmy8wMHcMmY58b8LKkGpMJDb9Q8l7D985B4Uj5V1lX5FfHtf1RBGnM+QS5a
	 d7V6UIoc9FVxpLK+EQPeH1oie2XoG7GzGLwjk8XIKK7DxDCFfofDaMc9x1NZhnDFvew==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011827;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Gk2cfa76K7no8CMo3L+lgNXbKBncI0WegUISZ77kabk=;
	b=2ACsTiQ/ldUoSvf48j02V48Gv/bGaBUy6OwZF8Qj3WRNbUBTMnFUAnmVmYgdnTa4QRFI
	 jTZsr5vXDB+PoyDB9ct1QCYLaBTU9y7DFl5owd+fcrToJATt0ae9t6g6Vjtt5CmltsbVf
	 JJUS4V39w1H3JDNSyC5p2kgbEFYE4DBgWKIbCuzMNp3TdAbxtMIkGLDC55nk3K9b4wWfX
	 M3PI9+PiIm4wHX9lpPdvurXZf4hHw+VfJ9CgAhm47H8w1RQSu/ckvOhP7lVPA9g0lDUha
	 Zi2FHsNbdYfFFS716qYpvc1sL8uxgC9+RClBwf/1F61lmomHxpItyal+WfgO74UMaUg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 23DB31F008BE;
	Sat,  7 Nov 2026 00:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011827;
	bh=Gk2cfa76K7no8CMo3L+lgNXbKBncI0WegUISZ77kabk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=DH3WWfasNX9pU6d7+5nZbKIKlHITxk4F1lol8+uHbsv3C4SeAQTKuwC4NSxr1hkwC
	 WOPzLbe8hS9k3ohbvrSJKemeUSrj6WGBMZtkeg3dpbOiClVc7LIhhnm+M/3qkQwqLf
	 ucGG8JcSCBpmEG85PCxbw+bh0J9iJgon90Lfbemsa2/2zYhyrNHAEIKVJEe/gZhQrI
	 FDltKnrLOBDnc15SXXwssyEB4hQBKM+ZMW27G0iFs70QcZag980Sv3fUD6ur2OvUmC
	 5BSp0svcy57z6USNpl9t+7UGDnRR+xFnFdeQqzHbjjfMEyG4nKC0h9BIi/ZQ0z+hTv
	 jKNNjUaHCN0NA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 774AB479A5;
	Sat,  7 Nov 2026 00:36:55 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:11 -0800
Subject: [PATCH RFC v3 37/88] KVM: guest_memfd: Support reclaim during hole
 punch in PFN mode
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-37-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
In-Reply-To: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
To: Alexey Kardashevskiy <aik@amd.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Christian Brauner <brauner@kernel.org>, 
 David Hildenbrand <david@kernel.org>, David Woodhouse <dwmw2@infradead.org>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jianxiong Gao <jxgao@google.com>, 
 John Starks <John.Starks@microsoft.com>, 
 Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Vishal Annapurve <vannapurve@google.com>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011809; l=2960;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=A+lPi/p3Z1v064hQ39rLQoc0mJDvEqRw5dAJ/Tf0TGA=;
 b=6VCGlYPnFECRKbsAYmAxaDdiQTXZkKjRUn6KFTvTXc0TY/u+JgD3lmHTmh8qRzAJPogSJ8NYY
 STV4EajIPm+BAO+vnnyua9N/mlAtLGXUkAoZ9GqrdKnUInexv9GyoVd
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hfiwu7jak8gdjc8cyy5gooxywpr6xbkr
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 29D1B20002
X-HE-Tag: 1794011828-614289
X-HE-Meta: U2FsdGVkX1/YL1rsh/7sk2YeDSuHPUT5zTK8r4DLMa1DT9chlJM2+4355TPDbSnYn3ZZzNKD2U1lIMO1nb73MjaSsK08COVhNx7EA7MPVtR5IdrO+yFd1IdrN5dCuFsBqQJ2l84rFigSNybcS9Y+YZcJS6KNdgzWcsTaXsSVtJ0CpUac+9xDoVZ3oJOS+DZ5r+8f2BgT6lRUN+lpPuOxRRqa2kEeCjcqJ1ZYbiPbCm5QjiTljDBdkw4yL7+w3kbNkw/yCL7NwYNMsb+2H7hteWlP62dcSOCWVL0452m8wbd3VTcqFrFmgJlKRq+UM49ikrfitAQbJON8vXyGFRcqBMs/Po+11i1W0gx/LKM368/e06Gw4xPNaJMK3+F7OFoY1dml9eqlLGh8NYIBOpfowPv9OiWi25bkahcjFYxqeWpOtpBvDqtfBnj+GC8/if7pGeypH2fBOZTa+Er1kelkf2Dmdk+iTYv1mZQ+zfXaTAQOR0CRBj8roYpqTtT51Scm87blszqa4+u0ypG0tFIAhl2Tk+BfldsYK1ek30K/RmgyE9l9z0TO9kl12QWGQxeaIkZ35kkcTL1zDcfPRg3vBr1PgqiWgg00Jdaq3+3LTLUvCegTm6CXnJI4ovBpYT0LQ4zJ1Kt50s04u6g+Eq37lcehPXKTTta/H3wGALfVXiOqZdQg9AtnOjddJDFXX2Y3X8CKOfsJdCkkX3duvnp7mbdPj1bckvKDcj/k2Y7rnhEZe2Biwe9QyppepuE2VzwBAQd+8A6+ZuXxHTAEld400qY/Qk3iKjAaGkPGBjpBH9S+Driky74DDhgLAjW5Rl7VuquX/GzbbSXBfPVfFzoOf+xQPKlTklq8DB4vYFh8mz264BX47vTrErJ8ncK+fl/4wOgACUyA40AobKYbxwazcFo/91SpvTtWlxRuxxeLg+p3K9HNysWyXgLyNaqePZ7MSedna0hGL2bKKDSm8/X
 /EZ7o7TD
 AaxZ3LT7patUXkhcov10Fs5vhKd8IFIdIZg0L+I4EbjRjpwzjvQRrFRJSH44WuP0vRD9Hazf2CjzMK8yH52y3Xnmpm9y+TMpbeikXDgIvRP8IgTSma1tiqyXboTHhfU2/yXKSrL3Cfub+HKA+He4031DFK4Pk6YLZeedi63DZ+rMLWcq/YU4X4u1pxXdiWb0G2rCvGBJs74J1H1mS1lm03EoLXbjnxe2TCBBBmNAmA2G97GerB1MQwcAuDM5oPKJKIW8YyK1MEXHC6o3e5uYpcjFrV3IeYwNmEeUFsVkVyA+krhtgJeg/vi1fcCvelOE7GvfRmUKPaoh7C/92Gje6K7l1k2dF+/A5si80XpC+GJPXDvlngE9YyJddR7hZU95kpR5GPjdZgffyZsyBtyDXFzKtEiGX7hOvOxGhCxM5BJwLEq7yEZgm9UwmXBzFIpQ0kVgXvvJHnx7aGD/c7Fcv1mWmgQSp3vdTz+whn1ydSTshDI0iygT3abNjHPfo0F8jTshTm3+UEAoNJN7MWDwWzNDpIX2MpOXyL7Wj7CSA/h9+RbU9S0ZMtKtugiSGXDebRww/djA6Z74f2Xdrpbzs1osS1TsNb4j5Acfpm7vTLen788s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

In PFN mode, guest_memfd does not allocate or insert folios into the page
cache (inode->i_mapping). Calling truncate_inode_pages_range() is therefore
unnecessary.

Instead, call unmap_mapping_range() when in PFN mode to unmap any host
userspace PTEs over the punched range, while retaining
kvm_gmem_invalidate_start() and kvm_gmem_invalidate_end() to zap stage-2
KVM SPTEs.

Reclaim any confidential architecture state (e.g. SEV-SNP RMP) on provider
PFNs across the punched range via kvm_gmem_pfn_reclaim(), querying
.lookup_pfn_range() to skip unallocated holes without allocating memory.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 9e8204f5c2588..567735a564c7a 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -149,7 +149,7 @@ static int gmem_provider_get_pfn(struct gmem_inode *gi, pgoff_t index,
 	return 0;
 }
 
-#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
+#if defined(CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT) || defined(CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM)
 static int gmem_provider_lookup_pfn_range(struct gmem_inode *gi, pgoff_t index,
 					  kvm_pfn_t *pfn, size_t *nr_pages)
 {
@@ -385,6 +385,35 @@ static void kvm_gmem_invalidate_end(struct inode *inode, pgoff_t start,
 		__kvm_gmem_invalidate_end(f, start, end);
 }
 
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM
+static void kvm_gmem_pfn_reclaim(struct gmem_inode *gi, pgoff_t start, pgoff_t end)
+{
+	pgoff_t index;
+
+	for (index = start; index < end; ) {
+		size_t step = 1;
+		size_t nr_pages;
+		kvm_pfn_t pfn;
+		int r;
+
+		r = gmem_provider_lookup_pfn_range(gi, index, &pfn, &nr_pages);
+		if (!r || r == -ENOENT) {
+			step = min_t(size_t, nr_pages, end - index);
+			if (!r)
+				kvm_arch_gmem_reclaim(pfn, step);
+		} else {
+			WARN_ONCE(1, "unexpected lookup_pfn_range error %d at index 0x%lx\n",
+				  r, index);
+		}
+
+		index += step;
+		cond_resched();
+	}
+}
+#else
+static void kvm_gmem_pfn_reclaim(struct gmem_inode *gi, pgoff_t start, pgoff_t end) {}
+#endif
+
 static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 {
 	enum kvm_gfn_range_filter filter = kvm_gmem_get_all_gfns_filter(inode);
@@ -406,7 +435,12 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 
 	kvm_gmem_invalidate_start(inode, start, end, filter);
 
-	truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
+	if (kvm_gmem_is_pfn_mode(GMEM_I(inode))) {
+		unmap_mapping_range(inode->i_mapping, offset, len, 0);
+		kvm_gmem_pfn_reclaim(GMEM_I(inode), start, end);
+	} else {
+		truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
+	}
 
 	kvm_gmem_invalidate_end(inode, start, end);
 

-- 
2.56.0.455.g6c5a503b38-goog



