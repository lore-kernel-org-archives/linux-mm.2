Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73E0DC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:27:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A82246B00C2; Fri, 10 Jul 2026 17:26:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0B506B00C4; Fri, 10 Jul 2026 17:26:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 949B76B00C5; Fri, 10 Jul 2026 17:26:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5F7306B00C2
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:26:36 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C0E85C3283
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:35 +0000 (UTC)
X-FDA: 84974151150.13.0AA912A
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1FB1540009
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hapNIt3U;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3iGNRaggKCO0SbPiaPRZVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--dmatlack.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3iGNRaggKCO0SbPiaPRZVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783718794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=INpd5qJ/nDERayrqFlF9TRfffxREvDfF4kxC1qPOhOg=;
	b=YTmIU6IhmfUhNtIiiekCf6sh/zg4QRAWrWUA6aE0Kek0e6kEBiLLiTswcpvqCE6CrBnD1u
	KahLnw9zkjGbvsz1BSQerG1jzFrBxFN0CFwJdfAWvJqllC8NjAefqe9DA8Wr3GNl8O8uHa
	TA9pVkfK7idhvRKok4GqlO9FQYS3AbQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hapNIt3U;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3iGNRaggKCO0SbPiaPRZVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--dmatlack.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3iGNRaggKCO0SbPiaPRZVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783718794;
	b=qbYJBcQJkWb3yMMzmZIk+xNqZz8aIUohlNR2+Yp4Enr6DYva9PYMaSVKfjEwqiZeJQqwk2
	/UhkO+3GvTS2dROnG8oRErVdNxB8zhKRxZbU0sQcYTEL0BV897ne4w6W01rgNO7l+YFmKn
	aH1s0FMXvkdXDRLaCeJymozcjK8LQIQ=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c88aab7c1fcso2552044a12.3
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783718793; x=1784323593; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=INpd5qJ/nDERayrqFlF9TRfffxREvDfF4kxC1qPOhOg=;
        b=hapNIt3UuNdhtVtgbTIGJ5DVk2JYXJDcceAJ5giC2GFcqDHGkBFTeAfcfRK4Mabt1J
         Z+EWzO7FsDWj7PMic1hqX7XGXrsj/lps5z7XSNqDqkzt4VL+boRwwpKwHtQG/VvU/YlF
         bDYzBGPto0RK+FQf2BK8hA6haaj0ima4gCtPCwOdMbV6/C/s05Iw1Xxt7Rb1YvwXMEV+
         R9J4/aDK/+eHuW/Cq/1xN1sRTkg0uP5N2zhMLm2HK/4bINiVtuT75QzO4t+dFx+PnM/V
         Amv6lY5yvVVkpRqfwQpjW6UciyeOx8liLQZoRtW1kzHfjRbu7g8EJREjS+3Rxva83QDD
         qniw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783718793; x=1784323593;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=INpd5qJ/nDERayrqFlF9TRfffxREvDfF4kxC1qPOhOg=;
        b=jMLV+FhpEgHgmqeEF8mlJZEZu6ZNN/50Tnr2KEvRwoLi+EeTkGHXqfnd54lEgOPKIx
         orN+5b5d/alBhZ5GjMs5iLk6Az5vPIqIvJvN7UW+6oxHV8ZS+k5+eIXMVVqZJy5zY08k
         iMMP1ffLs66ybYh4yMOi8qLnLgmaRJeFWVPzm0QqScpawrL06Rx1Ln0E0GVoSItQzVwf
         FIkjD3wmBH8neE8LNojl2iaNIJ7nrf0ByEHg1Mj6ue17deyybmgaPnnuFU07vJludZJX
         j92pH5+a7NR7eflQnZCMMOm/+mYE1fAR+it7xPhn0egtv44UEoSbFTYmieGxINyTgNJY
         B3/g==
X-Forwarded-Encrypted: i=1; AHgh+Rqb0RTFKqQ4Rb4ZFYCVFBhNRyNztbBEu1FYrI0k+VXS5FuWdxWxlCojPep63IaYpaKYSRn1ogpReA==@kvack.org
X-Gm-Message-State: AOJu0Yy5KiTpYfhnWOzokRixXtVzdDissr2FRT1evmxDeL7HzeZ+IAKX
	IunllizjANX8DpnMth3jS7XW6bVINJhC4k6vbZc+xAMNYfhZaAIfnbb74srYtNOENyHZXHdKYkp
	h7BVunIj7VgB9EA==
X-Received: from pgnh4.prod.google.com ([2002:a63:3844:0:b0:c99:aff5:7085])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:e293:b0:3c0:9c18:d5a2 with SMTP id adf61e73a8af0-3c110f61b7emr693546637.63.1783718792786;
 Fri, 10 Jul 2026 14:26:32 -0700 (PDT)
Date: Fri, 10 Jul 2026 21:26:15 +0000
In-Reply-To: <20260710212616.1351130-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260710212616.1351130-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260710212616.1351130-13-dmatlack@google.com>
Subject: [PATCH v7 12/12] Documentation: PCI: Add documentation for Live Update
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 1FB1540009
X-Stat-Signature: n7354dsdk9o1ozbpaf5temjx8dgxiqic
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783718793-579505
X-HE-Meta: U2FsdGVkX18pzW9U8PpeYfEUGHikd/jwa9rgr4G8/lr5wEzrS4dL1aFMog7u5E9jJKyXB2TbgHN5pmHNaejH/HSOV0VIO5zQiPaMRMbhS0p3yLxKSOiQAd9u5AqCWw2NK3YGehfDQCW46yGczOPdfMwVyBLobinU9vkIb6yhmSORswMycEFPp2tEeSaGjzvIXL/awyHep8ohgrZNIrOs6nR4744nyhkT9djhLTDLeOBrA/CUPsZtKgNBJYWpHQHZttWnMk/Bgika2D66W6fK1+1OoZ8c1kCbcA5JirsXVdDJQFOkw3gyS73XhpC8q3YUAe/TrguwVe5jo0RBIJD+nIxGSqGBTgHom7BWyJyjQBKBTlmuL6cxDkBLd+V61dZiW0Y8wmmOGZ7cqU1/FK6sGXm4qgUaeOiZI9B7B0LJKskPxUxWBRFsYZee4CzikIFQcAq0/NVzCt2elyWVjX27oAkN15KJRyyg9xhUOJQfqY9aZ5EUmbB6Zo5wCL/VrKe/fzeQwPMcA+1Xn1kc0zSQqtP6llxRzxqI7VmyqpZWP5aPDRS7LmdmMj4jd9i2UrzLgTrPWdxFaTZVvkWFXVG9DWHHa5cTaUP8TaXcbnpYU51tBnDrcbnHlzajH35KcqGW7aoYOkZvKm6jpjGCsPtbMAP6HrR9qcM2AkIN11jveTVwstXjBkKE3ihpdlC+gH2LxSKWtEDqtaLgp+Sx/1jmHkqegWKg1uyx1tLpa5Y9jgJVgy2GpTzRRrNwxPDTVTZyXxNtUiq+GfJuhbNwU0MNG7mQfXMaZbXrY2Alfq2zeuBsNnbyHCFOA52mUROwRloVdyLdfd3rPOQaKNCCsjmJkk8cL/fpp/l9phBPjpIQFaHw9wk8PezHXRGoODPRVBEgJxuZIilvRKR0w3rd29A1RIUH4ObKyB4oilB+gsUjWx9ZuxfGNk+j1MROT6VoCO9biMOAg9MmJVv4fnwzxEd
 ET7kpwhn
 ErU5H21qU4I8E1xeDS76ZZsqNS5WSodVOSS2I82D/dvf00dF/qM5NjUIbnOFFuVxg4HyFJGCcsdp0fer4CO/fcPlB4XXiRJ+4MUctFdPRMe1SWzupaONsOxOZvN88EDdZIHVisOZj/ox0KHqXJA6xSoLe47Mf1FfjYBBLHHrZBaT75GIlkxcCoHixFROwUyjctXtd1WgL2kDg0r4kftZMtLPwFGYWvmSK8wlCW0Z55m+V5kWzeoMfXTd2ZU9iaJPFxF0CJPFjReVTGkKMGSDvnc/9tIgAX8b6tPmalzkv5wJSYm2QuFl+S56KxLYVrheOE4ABvBW6j8knZ3ZNVOJ81WP57RcK3LxwuHhklT2E6vujJ+19TNhrEYnqGrPemzjMTstNZSRVw64X7+cIG4Ug6t2dX9wVbVNjXEE7mY57UDv85Mec1uzPCKRTKY+HlBJl8y9SVO5YqfHtru3GAPSgtru9RtPCsPnEqUE9SBITlwUS+LlItchU18+XVAy7xteJBiosErK6gGhCRgjk0dltIX8bDUFpf8BzBRH1ZVek+2o9FkDqqRKhxEp+c3uuYufpPhrP1afdzntg+Dth/68d4ZVV+aA3axgov81aOV4ugXCjHsaWiRdxtEhK/bkX5QEknL///7EwDK0veU2WXITPAj2SMOPTk+ytw+eq5kki5NpmSq0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add documentation files for the PCI subsystem's participation in Live
Update.

These documentation files are generated from the kernel-doc comments
in the PCI Live Update source code. They describe the File-Lifecycle
Bound (FLB) API, the device tracking API, and the specific policies
applied to preserved devices (such as bus number inheritance and bus
mastering preservation).

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 Documentation/PCI/index.rst           |  1 +
 Documentation/PCI/liveupdate.rst      | 29 +++++++++++++++++++++++++++
 Documentation/core-api/liveupdate.rst |  1 +
 MAINTAINERS                           |  1 +
 4 files changed, 32 insertions(+)
 create mode 100644 Documentation/PCI/liveupdate.rst

diff --git a/Documentation/PCI/index.rst b/Documentation/PCI/index.rst
index 5d720d2a415e..23fb737ac969 100644
--- a/Documentation/PCI/index.rst
+++ b/Documentation/PCI/index.rst
@@ -20,3 +20,4 @@ PCI Bus Subsystem
    controller/index
    boot-interrupts
    tph
+   liveupdate
diff --git a/Documentation/PCI/liveupdate.rst b/Documentation/PCI/liveupdate.rst
new file mode 100644
index 000000000000..eba55f8a92ae
--- /dev/null
+++ b/Documentation/PCI/liveupdate.rst
@@ -0,0 +1,29 @@
+.. SPDX-License-Identifier: GPL-2.0-or-later
+
+===========================
+PCI Support for Live Update
+===========================
+
+.. kernel-doc:: drivers/pci/liveupdate.c
+   :doc: PCI Live Update
+
+Driver API
+==========
+
+.. kernel-doc:: drivers/pci/liveupdate.c
+   :export:
+
+Live Update ABI
+===============
+
+.. kernel-doc:: include/linux/kho/abi/pci.h
+   :doc: PCI File-Lifecycle Bound (FLB) Live Update ABI
+
+.. kernel-doc:: include/linux/kho/abi/pci.h
+   :internal:
+
+See Also
+========
+
+ * :doc:`/core-api/liveupdate`
+ * :doc:`/core-api/kho/index`
diff --git a/Documentation/core-api/liveupdate.rst b/Documentation/core-api/liveupdate.rst
index b3c689e633c1..2bce2644eba2 100644
--- a/Documentation/core-api/liveupdate.rst
+++ b/Documentation/core-api/liveupdate.rst
@@ -74,3 +74,4 @@ See Also
 
 - :doc:`Live Update uAPI </userspace-api/liveupdate>`
 - :doc:`/core-api/kho/index`
+- :doc:`PCI </PCI/liveupdate>`
diff --git a/MAINTAINERS b/MAINTAINERS
index 08a724b860dc..347c435ca404 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20833,6 +20833,7 @@ L:	kexec@lists.infradead.org
 L:	linux-pci@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
+F:	Documentation/PCI/liveupdate.rst
 F:	drivers/pci/liveupdate.c
 F:	drivers/pci/liveupdate.h
 F:	include/linux/kho/abi/pci.h
-- 
2.55.0.795.g602f6c329a-goog


