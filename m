Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41E2B60E6020
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=baGuBWSa
Received: by kanga.kvack.org (Postfix)
	id A137C6B0642; Mon,  2 Nov 2026 10:37:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C2366B0644; Mon,  2 Nov 2026 10:37:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83D6A6B0643; Mon,  2 Nov 2026 10:37:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5CEC26B0641
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:37:06 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F29FAA5C94
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:05 +0000 (UTC)
X-FDA: 85390582410.18.A8286F8
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf31.hostedemail.com (Postfix) with ESMTP id 843792000B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:04 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=baGuBWSa;
	spf=pass (imf31.hostedemail.com: domain of 3Hq7oagcKCHsuhohmrgfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--vipinsh.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3Hq7oagcKCHsuhohmrgfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vop91WdATuHzNe6oB2d844wTZCMgIxCkWovun1wskQ4=;
	b=6C0Hos8fmiCADzUME+cRdUU1pUAI7SxbHcwpXlnBCIzvXhil8byT+JbKXuMpTveC1ynZOp
	hgaovxG+9GhPJHvVPbYASsDLGsYwUI+8D+6kp97/OszoLiyMDqK7q0+GsOZyYXrgQjPkLM
	pJvtdJBVnAg6GppxumEyywO2ZiSu4dw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=baGuBWSa;
	spf=pass (imf31.hostedemail.com: domain of 3Hq7oagcKCHsuhohmrgfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--vipinsh.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3Hq7oagcKCHsuhohmrgfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633823;
	b=5nDNUAKvJcmNM/7O5B6oeoEZ00DRuF2LlKOrt0fkp3Vo0y9m+H4rTQzIDivwPl0CKMi7IR
	sdjL3mkj1eDLRzhWLYo+lIPlOfMvkY5RxmvNFxCnYBC9OfxiALvfgC/4ozZ23/rjrgfwFD
	rJRcEkf/2hUaLfjy7eqvQdJXMapGAIA=
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3acc98e3b3cso2498667a91.3
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 07:37:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793633822; x=1794238622; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Vop91WdATuHzNe6oB2d844wTZCMgIxCkWovun1wskQ4=;
        b=baGuBWSaLby9CnLs33nmhLUDxdAGGb2TIuBNu/Kd2kN+Nd1Ew0FucooXZpC5jw9Eqx
         88bbdz6D/Fpy4+EgL3vId4sCc8X57FTPacdUYPJsHzbABAeNqBldO4uJP3eYIPk6STPR
         nZmdipCwzWSV7XH+tJe5jFKZE5sqWyyqZ63lHcw1vAZ/fWc8i3rW9Qjpsg/kLiSKscjs
         mdMe6nwcmZm0Pyk+IevIa+bMV1mlXDI6d/Ui3UY2NEnHFioObwXSvMJ+RgKxWspD9o5P
         q4if4A97wAXeR68aT/f6AAXq8QptOzS10CJcSzMXiQ+WoRKQfSPqRJbAbMraNrNt+JWd
         QjnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793633822; x=1794238622;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Vop91WdATuHzNe6oB2d844wTZCMgIxCkWovun1wskQ4=;
        b=cvc4HLX7skjjThGNzPEFA1LYr94j8uHl0wzRkTA23o0ILfQmdmDivgFt0emRp2IWQp
         +MBOAzZA//oDuJXYWKnRXOMdkx41BTPYBjQcU7MnrNS4aQyVOU0crrCU8SS6lRHqaYRk
         0N40nSTDXbjfFN8wLRixeX3JDCWEO0i53vNs5nKZ+LzNwht+sNXx0GXMmUH1J04agP6Y
         7U0joNpOXU34ymrLpWTVHXZFIsLNp1LqpZkuMpNIXt3D2/fP2b1rNklCt/3AqCOE+3a+
         7hiQqPtyVShx8RUCVjsUsHeEFKVkEN8XJ58Xsre2M0P7FecQjeUpX5DYPFh8L/yDz2rw
         jMqA==
X-Forwarded-Encrypted: i=1; AKwUvByCndyfKeQkl8r+LUXDuE7tH+rviDTsU4d1ZEeJ1EY3pEvn5hZfYV4CtHebfQW4NyxVdM8Fb3vlPw==@kvack.org
X-Gm-Message-State: APuU4Z+nasfcEo3A03Htl0/k3mFSUO3TTiD1kHSoCVHEGx3sdvHN08hb
	8M+7LT5Caw89pWSrYg3w6yEq5AXyyVY5cLnkNrBmjqppqVw7A8pAN5fiHpWA/Gl6aBt/L26z8kj
	CqYQE/ctHXw==
X-Received: from pgr20.prod.google.com ([2002:a63:1154:0:b0:cd8:c6e9:7c0a])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a4d:b0:3ac:9e5e:d19c
 with SMTP id 98e67ed59e1d1-3ae897ccc1emr8773759a91.17.1793633822052; Mon, 02
 Nov 2026 07:37:02 -0800 (PST)
Date: Mon,  2 Nov 2026 07:36:31 -0800
In-Reply-To: <20261102153656.1431701-1-vipinsh@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261102153656.1431701-1-vipinsh@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261102153656.1431701-3-vipinsh@google.com>
Subject: [PATCH v6 02/27] vfio: Export various helpers from VFIO
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rdunlap@infradead.org, rientjes@google.com, 
	rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com, 
	schnelle@linux.ibm.com, skhan@linuxfoundation.org, skhawaja@google.com, 
	vipinsh@google.com, vivek.kasireddy@intel.com, witu@nvidia.com, 
	yanjun.zhu@linux.dev, yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 843792000B
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Stat-Signature: 31jcu61mmhcxzute614i187kc1485uhs
X-HE-Tag: 1793633824-42563
X-HE-Meta: U2FsdGVkX1+Dityi+6yIZNzXdKUvD3juxOD8oKJKYcatyo9k07clbK5hhT8ORln6Co8QJAO1iR9WjODNwtjSeD+oheG8vOn0NCVstB9uihQbGPJnmrGA/NiJILC/laciF0DwJZRbCa0QVij4Ldgy+D+YZfOaQktSJNn9peNNy7XfiEmfdqt3pFPkhxcW2VHhshDymoum9H3MugqvgRBaQEnnLKFvdvGj4vFH70o5mq7IaA3TFZ75xYmVeXI54P6lfjOC7O8Ig+l0LLxaEuoEBair9JVF9yHgUNASe4rc8T49OPofi6CpzLgdTzmJ8qzS0gAr1PaIyqIppavKvGi4x6CjK1fH0RExSCIpMhxRPaOe2CfBqJCvDAQewZy+JkZAK03p92tDlWlYxJHGumHTnrthGQkOwiyDM6mF5Nt4loAgqYMWSBvVJC20ytWQ2rdRld4PvmraxjbjXlrqY5NplriHJDllUmnveZMxZB1etulK1X5ELvNFM6ZshUQYbKWmtcWS1mTTovfLGzvtFjeMT2pN1k1aIrIt3WXbLwkYJTP9pTJtvDX7v+bH8931icJCVRwrLVDvLa7Lcjg1aBx1VvyMc3ExuXXg7SXb4arKjUl4n3nN6Qq/cw8yuzz63rnEA3JMaZQKc0+3dwQY3sqZgjAQD62xcw0aJ54igTPRhwsxX0X64Fapy4YtcfhgwTaJVOxYFwpSVkZXrNyKZ00871rEeCHqbBATrgVuIz7bBuRsKXQxupQZSnXIbvBDBfhPQfakV7u+Bu48JfQZLihxJCma+RaX9/k9m7Kgfp+mcxbamjC5TRwlMUwKN4zxpW2GJ/ldD1CfWbjAgrz7FIvBOLowzuX7c/exdojZhfcUEoy9Oeuej+IlckIizBBYLWFwljy5kHLVpmy3OtcRzvQtGswXKyUMCgGfGP9gnejM70WaOicrKMKiTawTodeE63ui9NtLnnhfLT5PTyZXA1v
 VSwbt1Wa
 WFm8tASsY08LwyouWroRpvPLbRZkyBGmKVc0fY6yhuT5gw1KybrI6fv2H+KnPRKljjxQLgaRWeAIPbVV732k+3uHem0P79SD8nECpxcAGdmXDHxJhuVX78CxtZiC+3BikceWFwtM0HBdyxtfdHC/izqsWJX/s4lzzBQYjFLabYyHGGc3QfpY03eRCLcj9AEbkz4zIeg1EpYcwKKdRgLmOuUT/2r/bHEc78YhdFKMGw+N/HsWSEBHsK4o/rYUebqJj/jeX/T9DVMqHE2aZ9elm2GLkG8sgaJaXRdUdh2DKOLaCHh9p5z5uqBegPgURQyHogTtusPhYOAdS4hpCEdUv2QO/+68ZWJIdzAot5IjxOcRYaRI2MTbPceeb1H9p8TqgAeQYZ7Wg8nAtDf08MWExODgZS0M5DUgiE2c4C/xWGHr6hIZPwniB7BvwwOwAwqiwzQw0x9SV14gh3h5DqMcHSX5eYwCDyJxAxJv4AarOFpLT9vK6jQQf0c3PPQFc+fjgqpv4VuHEMFpg8Geh7UJ7gUCfCpPtfiJdhQMaAt0hOd6FluB4HxjeYuKyotEFZU1+fCJMv3DE8kYKB0pXabPV8aGU2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The upcoming VFIO live update feature needs to access various helper
functions for its logic which are not exported by default.

Export vfio_device_from_file() for other modules to use it, and make
vfio_pci_ops non-static so it can be accessed within the vfio-pci
module. Remove static from their declarations and add them in
include/linux/vfio.h and drivers/vfio/pci/vfio_pci_priv.h header files.

No functional change intended.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 drivers/vfio/pci/vfio_pci.c      | 2 +-
 drivers/vfio/pci/vfio_pci_priv.h | 2 ++
 drivers/vfio/vfio_main.c         | 3 ++-
 include/linux/vfio.h             | 1 +
 4 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 830369ff878d..2ec600768007 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -146,7 +146,7 @@ static int vfio_pci_init_dev(struct vfio_device *core_vdev)
 	return vfio_pci_core_init_dev(core_vdev);
 }
 
-static const struct vfio_device_ops vfio_pci_ops = {
+const struct vfio_device_ops vfio_pci_ops = {
 	.name		= "vfio-pci",
 	.init		= vfio_pci_init_dev,
 	.release	= vfio_pci_core_release_dev,
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index 4e7162234a2e..1634135de3f8 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -11,6 +11,8 @@
 /* Cap maximum number of ioeventfds per device (arbitrary) */
 #define VFIO_PCI_IOEVENTFD_MAX		1000
 
+extern const struct vfio_device_ops vfio_pci_ops;
+
 struct vfio_pci_ioeventfd {
 	struct list_head	next;
 	struct vfio_pci_core_device	*vdev;
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 423ead48aafe..73a5c4f3751c 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1497,7 +1497,7 @@ const struct file_operations vfio_device_fops = {
 #endif
 };
 
-static struct vfio_device *vfio_device_from_file(struct file *file)
+struct vfio_device *vfio_device_from_file(struct file *file)
 {
 	struct vfio_device_file *df = file->private_data;
 
@@ -1505,6 +1505,7 @@ static struct vfio_device *vfio_device_from_file(struct file *file)
 		return NULL;
 	return df->device;
 }
+EXPORT_SYMBOL_GPL(vfio_device_from_file);
 
 /**
  * vfio_file_is_valid - True if the file is valid vfio file
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 45f08986359e..de3fa6e6bf2a 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -379,6 +379,7 @@ static inline bool vfio_file_has_dev(struct file *file, struct vfio_device *devi
 bool vfio_file_is_valid(struct file *file);
 bool vfio_file_enforced_coherent(struct file *file);
 void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
+struct vfio_device *vfio_device_from_file(struct file *file);
 
 #define VFIO_PIN_PAGES_MAX_ENTRIES	(PAGE_SIZE/sizeof(unsigned long))
 
-- 
2.56.0.317.g454f8302e1-goog


