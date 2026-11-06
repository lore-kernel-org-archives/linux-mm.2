Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CDE7606A32C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 22:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=G+sYl+39
Received: by kanga.kvack.org (Postfix)
	id 384EC6B05B1; Fri,  6 Nov 2026 17:29:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35C8E6B05B2; Fri,  6 Nov 2026 17:29:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 273916B05B3; Fri,  6 Nov 2026 17:29:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E98CB6B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:29:14 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6AE11A7B3E
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:29:14 +0000 (UTC)
X-FDA: 85406136228.30.209667F
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id 84BF4140005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:29:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=G+sYl+39;
	spf=pass (imf23.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794004152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i6wtLwteYwyUZUWdoRocIhX8iiQGzMdlm5waC4g0QLs=;
	b=CCAEy80m8RMXKvhiVwo1+01BcZ7QHQIBIohL+Mdfb/x1TkDY2Eo0+P8IEfcebyLwr7w8k3
	itbk7iTTJB7y/qvCQ3vgf+dDmJSA0Jua/ZKbjr6CEp3Z73Ttcnwc2/TTVLmLy39j/KKKgs
	+dVY2jfECgDRsBxJ/tF4AkUNjZzeQUQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794004152;
	b=N1zRLDGxDAM6VJU+eZGOm46Z1rLQ9kLMZX4bgpdhAykFQwmE8gPRBU9Mdo/nWMLnRxgt+R
	nHyW78t/6pq/pQXCIll6wR/p/EzgLB78rWAzpJhnxVNio6cbJPwMYrBV5GaUp0phhqALh6
	wxF+E6Zigo/pLBqEUi3NXIbNTRD+D5M=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=G+sYl+39;
	spf=pass (imf23.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ed3f563739so11545ad.0
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 14:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794004151; x=1794608951; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=i6wtLwteYwyUZUWdoRocIhX8iiQGzMdlm5waC4g0QLs=;
        b=G+sYl+39HT2utvMR3xcWqegGEn2g321VDRAubZpeU5NTc4Ri0LM7g42f2/RDCf0Ewc
         w8Orz2GoUXokljY6mClnY0ZZsHEz/60V3J30rmRTFjQs7c3xwxXsfRCLDD7gRR4m0z9K
         NcOx1VYSbyQ9XQqQTYGEJO15hnsSVDda9XEG9fkRy+FJn6GHVIS8xA5rRUgy19SIiirj
         THjOxNHiUKbDk+aR4IBckCsktpCaUPOr/FNrHvuJsT+cj48ym+K1toOqIvjUsMH6LL4f
         NfTh0kEkAyQUONSBVhUz1C4CeEoV+XR+Qmz6EMEB0/D/GqwTiF/SxoDzUMjvExX42XaJ
         lrbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794004151; x=1794608951;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i6wtLwteYwyUZUWdoRocIhX8iiQGzMdlm5waC4g0QLs=;
        b=nhOrmNxuDhWrESKBKhcZD63SVJEiW7NF1bJimD8cLLOc8CDJ+7lPq9VT0iwuym25bh
         NwgNz2b9NO2e7crIUQ2DZ/Gehc3BLpRKTYrf2p08niLqIGwW/qbCfHiRoVpfFQCq9AQA
         nGUqlhCuKpvktaVolDAawWwGu37h7Uznqrl4Nbo1iC8zzwIM7IOxI4lRBgMgR4vOv5df
         QjrJ0y9VA8sV8t3qQeRTvGkNZeXEbIix8/tVCLDJCrskQqBY4mlgq/5w2I7zbAf4iyNp
         kd5tUPjlXqD80func2DmyJ5jIZmA9P/k6ZONwQoRdQNp3drtvvAwEhP0kqaSDXr+qBWV
         AjVg==
X-Forwarded-Encrypted: i=1; AL+hErE7tysx49dSrbE/RF9MWwHo/wzB09XHNR4ZDIimViFriyk8nb99zAj4HjSR2/J2smGup9qzNfJvOw==@kvack.org
X-Gm-Message-State: APuU4Z/VbRCShn3gOc7liRSTdjQBmH5RPzTeqiF9ww4ZCgt6W0/7PphR
	aWWQvKkxR2QctvhrZzbtpONCUpFr8LoNzNhjPoBs+lT+yp0glVYCcXqRUIVJtvbRuQ==
X-Gm-Gg: AYBFou0uze0ZtiqUk2xC1qDlAstzziwM/Zqu2M1pRvpC+0gXUdeQ0ipgfqceAVaFD+D
	BiN0TQenRGD1J4Hbua70yYHGkqTkWt8BXadeBY8yP4ZI4/L/kDM8c21zqInapWiSM2zf7TzZYXz
	8NHX/BBZ7i5FmVzwF8H9zfyqYZBU7A8gA4uQbb2mQ2eyzBD9a9AOy+BWbarQX+ue4JXT/bKZvMa
	ou0okWORbMzdRTYnCwVNMBjB2GQyFxPpIMDQYb3uJwSrZ8bk3/lPqi6+DSvW51t63FPrrZY1QRv
	VBY//EUqUX0+JDjq6MvQLGLS1kRUeJPJTbhUop56ppzBB7WOratir++kD5k58d1m3DVM4R1cu3s
	1nn3tP95HdX3Y4Ftu5gBqjzhGV5mri/QCzE79aZFByJQFHkGl2GFQFIRg/ejKyfc5q93nI9+sKA
	vq3G/bs1ibPyJklRwNkAKrvMEKwEacnWmYv6JsmEjkH7ZhXcd1Jhsnyyl06iGHC4U+FQDgj0M0z
	BY6wrJ9Pg+FQOfLFiW3vkNQU04OvZU2sAFTfj+onytcXabb4B9TjRxP3O9Mpu9HDBdOq3bI+/e2
	yGtrBrP/tnGph1i7Bj2uY2sVxs3mgxVoAzcMlNr9dOOnOkIqUG1itipK5O3LP2dqUwr1p5qLvL7
	m6MBtjxeugEojis98k6ulzEiCitNMZmS+mV7aRT14HF0=
X-Received: by 2002:a17:902:ef11:b0:2eb:188a:1c06 with SMTP id d9443c01a7336-2ed6a865b76mr263955ad.9.1794004150728;
        Fri, 06 Nov 2026 14:29:10 -0800 (PST)
Received: from google.com (25.75.145.34.bc.googleusercontent.com. [34.145.75.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0fc27e829sm775868a91.0.2026.11.06.14.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 14:29:09 -0800 (PST)
Date: Fri, 6 Nov 2026 22:29:06 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org, ajayachandra@nvidia.com, 
	alex@shazbot.org, amastro@fb.com, ankita@nvidia.com, apopple@nvidia.com, 
	bhelgaas@google.com, chrisl@kernel.org, christian.koenig@amd.com, corbet@lwn.net, 
	dmatlack@google.com, graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, 
	jgg@ziepe.ca, jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, rananta@google.com, 
	rdunlap@infradead.org, rientjes@google.com, rodrigo.vivi@intel.com, rppt@kernel.org, 
	saeedm@nvidia.com, schnelle@linux.ibm.com, skhan@linuxfoundation.org, 
	vivek.kasireddy@intel.com, witu@nvidia.com, yanjun.zhu@linux.dev, yi.l.liu@intel.com
Subject: Re: [PATCH v6 04/27] vfio/pci: Register a file handler with Live
 Update Orchestrator
Message-ID: <au5T7qouVfxJSDmr@google.com>
References: <20261102153656.1431701-1-vipinsh@google.com>
 <20261102153656.1431701-5-vipinsh@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20261102153656.1431701-5-vipinsh@google.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 84BF4140005
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: 6qtsteumh48xgk5sm5dqaitbd5uahhy5
X-Rspam-User: 
X-HE-Tag: 1794004152-970786
X-HE-Meta: U2FsdGVkX19Zu5EysOn86xpPioTQWpHGoiunxhFdHxHJraq6rTNCN2354hmW4tSAXkdKHGgGXn4/vcICD0r55vsh5cU9jRRTWBV5kXj5LKr7eUjMbjLaPTIeTXlXt+oceoZPge5aqfskOQnW+y43M1rhl7XeexcX3m9PX7hl7/3F/6+cnqbz/m+DQFMMP7TD4fQ9GgryTnOOGNJDp8Iq+GHgU9jN799ppY/5+IdLYVg8mTqUCK7gi9AvmqpwdnPVZ2RX/WG80GFl0Z7rDFtpGrqWxxZ6Rhu41/MuI/uCj3WKaRHMPM3JFluKe62sGCsBBsuGGI7z3RNPjrr67FCkCWqZBbcS2rmtOkhEnP9mjIkOgoLgOrSaqA46VTrTswSG1nS2fEFl1cxce36fpOcKJVGAp3evcxBKI30SCvTZ6yQl2qD6wLe5qH+qnYMzTWPo+n57SDcZXNWjH/OjINadZa91Mvm0bhwCZxbAFJ/BMsvs7DcNJO7CuTqiuuanEZAIRNTtDRjQBn+WqL/xv908Oo1fQbBqOR+wqS59qNQd5n7PBa45YiPfaBSAJ8O2+i/6ZnmNyZMzTf/qIy7A/RutxOKvXovifWEf0yLBr61bXv9Myk3VYGJqlBXNoU9Xl7zOuoiXNbJ+9VAP87MbDn70eUCGPW3fFfHYK4skF754wUfNA2SESE26LkDo9HigOltp/hXsLRiSK0PMfUCjK0oLxUiKC2pL0+gWy5Ichioj0acoa7QaGcZyj8JN/cCeOKEJ407f5KWlcSGTes9S/IM1twC9PNjw78sJTpYmXfSqDew1lDslyyTB4LRSIVoq5Ql1xwN7EwcSkW1iMx7TlOS/wcjCu7KxH4odxDZ7Nk4Ak2alm53/m9zkqvCwRkErCXV2cLOq5CjxDc0OHXinVD1ojuv/CmO7qYviTuuj7Y+d2JAqLvt20K0mFv9t6wSsasJ5D8eMt4+jkcKe3N8g1Xl
 x+VMsjS8
 TDYVaWoj5HmUKevKLj9OVTIS04gvduNiilFuK3Z9gzVj5+yObuaBk6xT3E+6+HmdqxkftrjiZMNZseu8ZXozJbXognxlTJwBno5WPbDQuwMmMt77q3YUWSFIZS34nFw0kAo627KcWqyZqoauRevk3Hyy5/1vrCMVWka6RvZOOdxilqzSH3HhePD/+W1E75OuhK3MNqzhfVkD81wBUX5nvoUz6KpoylPbSuqzZiTzaCMtqx1uMzG5aYnOYIbiAUllwt0ytKa//jVP9V0lIp8mJQ7D59SenHeIKHUa/ConUE44odMcYW71g66eERvz1FBRZVdrM/RASpOjmbVVfCpo98zwddoZRKO+lYJPY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 07:36:33AM -0800, Vipin Sharma wrote:
>Register a live update file handler for vfio-pci device files. Add stub
>implementations of all required callbacks so that registration does not
>fail. Register it with both live update framework and PCI subsystem.
>
>This file handler will be extended in subsequent commits to enable a
>device bound to vfio-pci to run without interruption while the host is
>going through a kexec Live Update.
>
>Put this support behind a new Kconfig VFIO_PCI_LIVEUPDATE. Initial
>support is added for no-iommu model vfio-pci devices.
>
>Co-developed-by: David Matlack <dmatlack@google.com>
>Signed-off-by: David Matlack <dmatlack@google.com>
>Signed-off-by: Vipin Sharma <vipinsh@google.com>
>---
> MAINTAINERS                            |  1 +
> drivers/vfio/pci/Kconfig               | 11 ++++
> drivers/vfio/pci/Makefile              |  1 +
> drivers/vfio/pci/vfio_pci.c            | 11 +++-
> drivers/vfio/pci/vfio_pci_liveupdate.c | 75 ++++++++++++++++++++++++++
> drivers/vfio/pci/vfio_pci_priv.h       | 14 +++++
> include/linux/kho/abi/vfio_pci.h       | 28 ++++++++++
> 7 files changed, 140 insertions(+), 1 deletion(-)
> create mode 100644 drivers/vfio/pci/vfio_pci_liveupdate.c
> create mode 100644 include/linux/kho/abi/vfio_pci.h
>
>diff --git a/MAINTAINERS b/MAINTAINERS
>index 5d1b58271989..167aa9d66ce8 100644
>--- a/MAINTAINERS
>+++ b/MAINTAINERS
>@@ -28662,6 +28662,7 @@ F:	Documentation/ABI/testing/debugfs-vfio
> F:	Documentation/ABI/testing/sysfs-devices-vfio-dev
> F:	Documentation/driver-api/vfio.rst
> F:	drivers/vfio/
>+F:	include/linux/kho/abi/vfio_pci.h
> F:	include/linux/vfio.h
> F:	include/linux/vfio_pci_core.h
> F:	include/uapi/linux/vfio.h
>diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
>index 296bf01e185e..e8285ad93a69 100644
>--- a/drivers/vfio/pci/Kconfig
>+++ b/drivers/vfio/pci/Kconfig
>@@ -42,6 +42,17 @@ config VFIO_PCI_IGD
> 	  and LPC bridge config space.
>
> 	  To enable Intel IGD assignment through vfio-pci, say Y.
>+
>+config VFIO_PCI_LIVEUPDATE
>+	bool "VFIO PCI support for Live Update in no-iommu mode"
>+	depends on PCI_LIVEUPDATE && VFIO_NOIOMMU

Can we handle this dependency in code instead of doing through
configs? Are there any build dependencies on noiommu?
>+	help
>+	  Support for preserving devices bound to vfio-pci in no-iommu mode
>+	  across a Live Update. It enables a device to continue working (DMA)
>+	  while host kernel is going through a kexec live update.
>+
>+	  If you don't know what to do here, say N.
>+
> endif
>

Thanks,
Sami

