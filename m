Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB527606A81F
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YEXgJipU
Received: by kanga.kvack.org (Postfix)
	id 7D5456B05EF; Fri,  6 Nov 2026 19:37:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7852A6B05F2; Fri,  6 Nov 2026 19:37:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FE606B05F5; Fri,  6 Nov 2026 19:37:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3156C6B05F2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:19 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C7593C013C
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:18 +0000 (UTC)
X-FDA: 85406458956.28.6E55E42
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id CC64C1A0006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YEXgJipU;
	spf=pass (imf19.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011836;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4UScqvpHbvwhPXhOC+pGujyyRV2Vm9+YOOe4hjQlTSs=;
	b=lfrH3TdDQcHftvPrDR/8CfP78vjX3w5Hp+KY9IQ10rl4JPbm21F/KCLzfwXw4k2iBo5J+M
	DsNkWtuVpWe7HnZ81koWU0Zo4wzZ56KF1ME0HWTyYeOOs97WpVQ1BkxfhosJmgQfIXzWSh
	FEjcDY8PLblboMdlOPTZf0FnNz6AgjU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011836;
	b=HR5rPSvGlkWn7YDTNmiDMCePyQAIC4vSkC0WeZpvuH7U8+H9UWO8ZhIqIYrqjn6usnYc/n
	NSUlzeVZPA2R0ouI+AiIWN15HH+ci/iMSy84WMHctDYjomPbbamGMwmyNJde7i25SSzQ6z
	JplDl95OJsuBjBA57jJ3dAGawfNeit8=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YEXgJipU;
	spf=pass (imf19.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9F4EE60E0F;
	Sat,  7 Nov 2026 00:37:16 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011836;
	b=jTC3oAAoY+yPgFxQmwwyYhKIPdch1/fiATv7pdrPs/9H/PbFt86C9LPdDPukPagJib5z
	 ii8Um0uegDuIiAefBG2xK9tpjByYxqr/RdaYzpkjXJUTB2gfE0SjijitGVFQXdBpBS7iA
	 abmbV2YC2WeC0eF8b/QpnNtnc4wmOPb+CV8iE40wa+nED73LI2YFC3CSGdFA1tSrp4/xI
	 JYk2hJ90Vz/N1BTmDdAWmlZSQC6+0FI7O9w9xNLJGgOYTSTmJb6zBFE5OCOO9BT1vCwDL
	 yyzPIVd/eWu3keIZab2ybeax+T489k1mj+6LtX+QT5Ryadc4Ly43lxdg7eo4w5GXLfw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011836;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=4UScqvpHbvwhPXhOC+pGujyyRV2Vm9+YOOe4hjQlTSs=;
	b=HDIUQDobIvemgf+BIWga74IK7QG2WH7iBE0Ws6kqCqoyzB5DbagErY6duQVqoDIXsNbY
	 Fj0BelWnMFBXiBqRLhNbLNL9iuA5ScYXPeMhS4pl6ztdSV28mGo4ca5PvtiU9TjZf0TDu
	 Z55q6RodEhwfmTLL23OyUAuiyJt9my5aDRBppgP3lzYdKRHueDmUCJlYmqC9XZNryMvLh
	 VwuU+lTKtoDPywq13IpyzyG+5fiHlhSmztqfr+UwoOaIR+fBhpet3met/OcAhnXmQR7+a
	 GWyWfj1topXtKTAHxw7viCm4bJWgkqeajO/s/RUFJEWtFaSc0Y301KIip09+6EZOA6g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 818021F00AD4;
	Sat,  7 Nov 2026 00:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011836;
	bh=4UScqvpHbvwhPXhOC+pGujyyRV2Vm9+YOOe4hjQlTSs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=YEXgJipUDsxc+shw4qFdKswehd6a1WuJk6fLk1NDYzhAmkqd2x+ZqeW3COYZQWd4k
	 9waBXcxK+fGnrA+6aOPxKljfkIKzuoNY8hfLl3yVFgC7EEtLks8XFawYt8Ke+zSC6B
	 X/nQb47vvsKge3FTQDKGt7cYufQQKxDMqk5QLgzIHxqFSGugg/ZsVEA5CoEPvZIE7h
	 djZW68PoogF+2+/A2chdYeRcEWwywOwNsfBXGNhBr8PSLpYvdtLzNuJQXjn/zWkuuD
	 ZXJGH5rIpVqKwUffxz/P/wvcwSVA3FNZegZ7IQlMHFrqWBKP2yK6cqZBRaKggjRFYC
	 WELSa9krLggoA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id EADFD47929;
	Sat,  7 Nov 2026 00:36:55 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:18 -0800
Subject: [PATCH RFC v3 44/88] samples/kvm: Implement attach and release
 provider ops in sample provider
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-44-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=2754;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=wGkwYGWhWpUEbPcNoli9OVifhRpY95s9sJaKeYRfDoU=;
 b=2zBY4/UyvI/wD4fxk5n+1zA8wC8jypJ2hvfyGQousryL2X4dafvdKSl/QarQac9uuatqZ3yC7
 cRyw4A4lugaDN4Zps6HLSpdgi7cq6SIJHYldFyY/s718nvWW4wv8kWz
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cdkr7jicfz8eus9fnepwabk1hoej5e9x
X-Rspamd-Queue-Id: CC64C1A0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794011836-296361
X-HE-Meta: U2FsdGVkX1+te44tP6gaTyVRHIwi5eT47xNK81o+i6ClYIV1qepZgsxNotnKl0pXH30i+UaqDS1RxWdcMHmIyC9VY5qazVJ6ILtdVD6MoTfKaRfml60K29JtYgBwuiYN/bvsgKbh+Z7slu/r1INs/eRXBNkO4wAL0zBNWBvcQgxfWoK3ggV+bbcfumYEMcPfEB1fMqe8dab90dWtrmUTjFwVc3BI8FtibOFbInXNfVUaPUlO9kSB7o4E85ZwLf9EPeuinlRdc/SZ5wpZpSQIrT+4/iDgE2b0TUav3htk+7q7zzzncfgQ/79YCfbb6nzexirS2XOJe/ppk3++bv+xBbLiE/570GMXYgdmdSG/3xc/8qmR91WASzTcGOHaA5GIRbscgl+3d1bd8xeXFL6mJfAydmQLZuzJ01p3yaghBRUdBueDXk9W7JaPtjUSvV7tHqt/uyYx7Y8ngfgANmxOwKEX0rSN9XcyHuRTlNGEqN2lABrN3uu9km23xZEclq40FEUgOFSwKfDoH4t62lhsFL2VgqoCIJYOHqWxeSbZ+i3Rc25m5hxESP7tcHvEuQKSt26ewsLONr6i/wADsOmDb3UeNUqoH1CPaN3KnPwlPw0I93o2vz4RgPSgJTpE7FIC1lkK6Zj3Sl1uBrstYxbTQDreaHGfOJk3sUT/4aY1yMCmmjpvDIcHuUk8QMCRBJZHUBIsr8H0pvCYB2B/VUG0JIP3ij7zNKOuHOp/8pCbsgAq1pShfFnYgXATADCB3fKKFo+9eLppGEMjqaQ+s2dUlpbqhm+m5MBo7DqDxNZhV/6/V73og8TOGkD7qhy4kmNBrOEOnm/nhAek+odRIOwmK3+r+3SipKstv21Hvoar6rlD0rs7MH0jgDNu3PjAuBoR0VoSrtMJxXKXXeNdBG6Qs0hntybVPYdFKPXHAgYWNqEyl6t7vp/y2Q3s74mBMc9ubXU24GMd0SOPR/v1gFV
 ZjR0utQi
 g1xSIlDOTJZXu+q7Z8SMnnKgAlsrizNWDZgMYUgeo1GbYHAWtfBRW0CBxCE221anvJdmFkvKLgkLMK+xu5a0sOsl2nvwk0Q3/2kARfVcLaU1W2EIBRChkfOGzehG0s9mPHeOqd92uMa0rJrGbOxkFk0VUVKFkah1JSrc4FjPWD92mQfJHqyzvnUQNOWY8kcyZNOQz0l7G0wg/588/0I+aJrvlgV0vR91l7Db0yGJueUCXb33appIL192eWOBbxOZfjgdSzNZyfjyfI7L+8xHzibshsqX95S79wsupCWcy0DrIl2povcr9WOHa/HQIaCyPszRw9ZawEVFW0f/zWJRXvnOW/G+Ag1pWDw9w/Co2HlPqOgxIKac5l6Or6QlYuYSPnG/T+/PkkZ3BEHWLmaEjlPcYysYruN6wgRwpjKxTOSnzJ1f29tXbsyJqRRnPbs59Cha4qHi+NWwXWvrfos5LOX4TCU0Fn3CcPR7HvY06WHZg+57no7mghm4Rj2kOmoRFptRm5WHeD8uZ6GrISkrrEO5DfBOvbskXQcPo1WKCGO6lbSY9S0vcFmIV1Id+2dBpvAySGpVCLqXKQF/fVHQE0umIxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Implement the guest_memfd provider operations in the sample memory
provider module, providing .attach and .release callbacks.

In .attach, take a reference to the provider file (get_file) to keep the
provider context alive while attached. In .release, release the file
reference via fput.

Attach the provider operations to mps_file_fops.gmem_provider_ops so that
provider file descriptors created by the sample module can be passed as
resource_fd to guest_memfd.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 samples/kvm/memory_provider.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/samples/kvm/memory_provider.c b/samples/kvm/memory_provider.c
index 81ac94ae1a4e9..6f86e3e3262e3 100644
--- a/samples/kvm/memory_provider.c
+++ b/samples/kvm/memory_provider.c
@@ -17,6 +17,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/gfp.h>
+#include <linux/guest_memfd.h>
 #include <linux/miscdevice.h>
 #include <linux/mm.h>
 #include <linux/module.h>
@@ -34,9 +35,11 @@ struct mp_info {
 	unsigned long npages;
 	struct page *cma_pages;		/* from alloc_contig_pages() */
 
-	struct mutex lock;		/* the bitmaps */
+	struct mutex lock;		/* the bitmaps and gmem_inode */
 	unsigned long *absent;		/* taken away by MP_SET_PRESENT */
 	unsigned long *readonly;	/* marked read-only by MP_SET_READONLY */
+
+	struct inode *gmem_inode;
 };
 
 /* Byte range [offset, offset + len) of @info as page indices. */
@@ -161,11 +164,45 @@ static long mp_file_ioctl(struct file *file, unsigned int cmd,
 	}
 }
 
+static void *mp_gmem_attach(struct inode *gmem_inode,
+			    struct file *resource_file)
+{
+	struct mp_info *info = resource_file->private_data;
+
+	mutex_lock(&info->lock);
+	if (info->gmem_inode) {
+		mutex_unlock(&info->lock);
+		return ERR_PTR(-EBUSY);
+	}
+	info->gmem_inode = gmem_inode;
+	mutex_unlock(&info->lock);
+
+	return get_file(resource_file);
+}
+
+static void mp_gmem_release(void *provider)
+{
+	struct file *resource_file = provider;
+	struct mp_info *info = resource_file->private_data;
+
+	mutex_lock(&info->lock);
+	info->gmem_inode = NULL;
+	mutex_unlock(&info->lock);
+
+	fput(resource_file);
+}
+
+static const struct guest_memfd_provider_operations mp_gmem_provider_ops = {
+	.attach		= mp_gmem_attach,
+	.release	= mp_gmem_release,
+};
+
 static const struct file_operations mp_file_fops = {
 	.owner		= THIS_MODULE,
 	.release	= mp_file_release,
 	.unlocked_ioctl	= mp_file_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
+	.gmem_provider_ops = &mp_gmem_provider_ops,
 };
 
 static long mp_ctl_new_file(void __user *uarg)

-- 
2.56.0.455.g6c5a503b38-goog



