Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79114CD5BB8
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 20:24:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25D036B009D; Fri, 22 May 2026 16:24:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E0386B009E; Fri, 22 May 2026 16:24:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 032316B009F; Fri, 22 May 2026 16:24:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E123B6B009D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:24:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B36F1161733
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:24:18 +0000 (UTC)
X-FDA: 84796182996.16.76B8079
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf30.hostedemail.com (Postfix) with ESMTP id E872480002
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:24:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=K2n6xpRo;
	spf=pass (imf30.hostedemail.com: domain of 3b7sQaggKCIAhqexpegoksskpi.gsqpmry1-qqozego.svk@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3b7sQaggKCIAhqexpegoksskpi.gsqpmry1-qqozego.svk@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779481457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lI5mS1q2qOObabKUBbKfb1QQJkZ/uNYoefmzXL5rBmg=;
	b=1d08gKtTd6QsON+8nVbaPB/pmoKNSuXjb1xfC6TOQW3oXFg8CIc3UBHBabjV29sBupSEVl
	MvB8il9+FK30k2MujG4SLlQHdP14yeXg8KrYnGXdTSCjGnlyqs6gk0pHaEuzmKPPY9Cx1d
	w2ntDX6tLq3uEqxZjSPNCNjTPDHfMlw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=K2n6xpRo;
	spf=pass (imf30.hostedemail.com: domain of 3b7sQaggKCIAhqexpegoksskpi.gsqpmry1-qqozego.svk@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3b7sQaggKCIAhqexpegoksskpi.gsqpmry1-qqozego.svk@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779481457; a=rsa-sha256;
	cv=none;
	b=mTcnrKfcy9JSVS6BpjHB36YFjXUNeq7+f4n57TWNRwQnO3/79+4wjjJn1HtYB4wHGZBknb
	H8U5QBpsRLVuul86aBz4W1z0BMtqvhDKguNaiq8+i1ZRuQNSdQ6AhnKae0i4RO06GVnqtD
	m3rtif8CxTJ9Ne7XupjqirhOb67HUpQ=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3663d5e9bf4so7327401a91.1
        for <linux-mm@kvack.org>; Fri, 22 May 2026 13:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779481456; x=1780086256; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lI5mS1q2qOObabKUBbKfb1QQJkZ/uNYoefmzXL5rBmg=;
        b=K2n6xpRoCSuuikeNHeckxqJ5OIXpjuTQfS4XLJ+NwlToNlao1sO5LBMVdgzM0XC1m2
         d9HmZideMVmGyYbxAh88UMSy8lOnJEFJqyr+9InqFjCNKZsPVaJphyORwz8/WTZnoWgT
         7C3FmKKWgeBbn+7a/RB4xeTavdmbZEbkhtLFW7Z5lPPbSMyE91Rvdfc/4uRAz9wzIbrL
         SYkxoqAH7scU+GUx9ovEPmhinSyoconwqafd3lxEW5qNvPbaNy8dp5g70ZnLcFSVNxRQ
         11sP2RRQx1DUXdJCMeSrmiGtsbmiFF8zHX2h8zHBV5/UPd0lWB32ybzt6t2LC+1MPi+P
         Keqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779481456; x=1780086256;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lI5mS1q2qOObabKUBbKfb1QQJkZ/uNYoefmzXL5rBmg=;
        b=CfwEkknfJsEQbNtCX0gemzZiz/zFE9d+P1HJw+uf4ymB1vT6z5mGv7yT6+YCZnqrkI
         uSKHdx3g/9rjcc6Y7sbComF0RX4rqLsghqVmgygeHurlNQ+EOQJ+PM7FeBtmcu9AH8LG
         GPYOhnzT3Ko+sB0wU7dWY4jCr8lZ7YU+e2CucU/8OXBDBDiJVdu7GRaFtGw5Oxwxv4C/
         d1FfG8PJcX9bAFQNVaMZ8I/UwnWv0mYxiE8ICJKKEOLwzo7efc3fLtDnsyJLnA09YoT6
         xpqaIuZ80ZN2LmozVlkY762KAee+VgG2lTjF90ZFikjyuef7fiJVDShTxX3dPCa38n0/
         8hCw==
X-Forwarded-Encrypted: i=1; AFNElJ/AV+DqaDr7trwe6HcvNZ2h4gAp6s4gQN2mVA4y5YS696p6W4v6FbyCikNtN+L9euAztYA969vrzg==@kvack.org
X-Gm-Message-State: AOJu0YwAjxYEFAzSYJSRvn75A1l566Uh9LvaHCvQ7nApMg4naBcGdV0D
	XFcuAJGgjBXlg3qsrD12l5V2jJNsgLAbvC02AcFJ/eP5Uz66ZCI+qA8ULjjPTKajMpk81WjvX61
	3Q3lT4MU50zVj5g==
X-Received: from pjyv15.prod.google.com ([2002:a17:90a:e98f:b0:365:ca4c:7afb])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1a8e:b0:368:78da:803 with SMTP id 98e67ed59e1d1-36a674f81fbmr5156953a91.12.1779481455496;
 Fri, 22 May 2026 13:24:15 -0700 (PDT)
Date: Fri, 22 May 2026 20:24:02 +0000
In-Reply-To: <20260522202410.3104264-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260522202410.3104264-1-dmatlack@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260522202410.3104264-5-dmatlack@google.com>
Subject: [PATCH v6 04/12] PCI: liveupdate: Document driver binding responsibilities
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
X-Stat-Signature: pw7ed5hptn4mwnepwwwqyr5uhqf3toum
X-Rspamd-Queue-Id: E872480002
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779481456-703867
X-HE-Meta: U2FsdGVkX18WS+FESNuoc2AtlKGzp29bYHrsycBdKgm5Xb7O8V1I9Q7q6XQozS4ttqskCPMNMVlhb6TQftOdpJc49tjUH3e6Uag9FOhkcb6svdnkL1NNol3m6YBsh40iDSU7XBC1iu7aSl34JjNgZFN+IMx0zCAQXRLHUONHno6xzD9xu2RyHhDxri1B7qF0BziLhPmP4r+kOePCRpB15eqKE9XxeYKJJEY6/XwkX6Qi2uMA9o+01lHL06KHMTb+r5symPpjqNXGInqPntswQIgkrxP5gwROSvtSqvF/T1VLqTEDnQ2LurV3gykM+MacOsg83+bZPDhVePr1jkVr2LM/WtRUiUa+QsgMhuIUqpdu86xsOlXod56+i7VRo50kkz7heKWe6yAhLeD4rIqa9oUIciN08IRvc01NevaQJUwsN736y4yf3X9t0Ui5+H2i/Sj1k0YF0Vf9EzmHCfaJWKIjMJaGiyNU0Svu0iCx2a4ZQbYjAsnseJjPcNsrt7fCivcu7p/7XVTaGYAzbIGYgQJ7url9OemulijfeQdOwbrju5/N4xyPae4TJkdErEpgraxp1IDHNu5ndmi0FpaTMu3Xg9reZHrHiP4dnFa5ios1dYq/JUB67+D7RcmIdmTUKDmGnyK9SQ9kp24s2UirUH/TbRl8ysS1qIqEUzmSXYoJBBUm4mS4jnP5ZhM0AXAaRkkHR9IknHRPaq0mzov58Blge2KXudXqIUsDglmHJObm+9n0cXAIzzxeff7Eb1PF2LAGBwMcfmDvaGS+RPuVshYiXi1guvG5XYNIruemHgoVMVZF5ib3uahRlPtanKYyYmA4V34lQ0k7HKO22kLE0o1l+kku/TSfXJ+OYbjgA5lRoFUh+jkeQMO3lLoc/7KoMQ9jRqyWKZDEKRTa7NgaCHJv4nOejwaaM1Gk2Iz/Ep0NUf5yAgvkbdtTA2wpKh24fawCZYw7qqq/PNDZYcn
 2WO7B99+
 sx/m9XTcujirB4JwcqDTKmURYZbCyVeb4KMidQbsgr//S2Nvl1SCHt4eOOcE3991zXAWy7us86DJ6Nro5DvexOngct3fRA5uEbSPUFMVJJBydxWjH3uMG/Scn/cSzcpRO686REM1VKfKlsrqo+4SiNDcyetZau8mh8pI1qFa6prZHL9tLLBWxZfp3B1Hc+mmO0OUn6R2zzv+VP0EUjbD1N5N2I3/Jq8wKSqkybxUcoCf9PfXcrtNSXWkQ4BkOvx32kZcR5Qa080yA7VtJVj9Q2D50+IsJN4Tt8r/PJ3gGEoObvvtT4AxQ0H9hvIQ+jdeugsScz2DYu6vqMzrEM3s5YEzR8cERYUGnUPPXmMxteuAHz/62t2/JgucsMtyTEMM8sn3pZzr96SbnhI8Pz2qfx63YOvOtEnhC1GRI8yg/mAxjm0OBNcTP07eFUOUe9rs/4F4LzQkY1HKy0HJxOZI3KQZO3UUZfhPQudYwm7X5uiLqIPKfTqAG150G2TRA4/CoimoNb1V/unHFWTQVsksjdUZgb7Emm1X6TptOHzrbWfKXVauuL+smGu7IYvjQt3Ckcr4EWrxaFlnNgt8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document how driver binding works during a Live Update and what the PCI
core expects of drivers and users. Note that this is only a description
of the current division of responsibilities. These can change in the
future if we decide.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 96c43b84532c..4f2ec6ffdd16 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -70,6 +70,22 @@
  * preserved. These may be relaxed in the future:
  *
  *  * The device cannot be a Virtual Function (VF).
+ *
+ * Driver Binding
+ * ==============
+ *
+ * In the outgoing kernel, it is the driver's responsibility to ensure that it
+ * does not release a device between pci_liveupdate_preserve() and
+ * pci_liveupdate_unpreserve().
+ *
+ * In the incoming kernel, it is the driver's responsibility to ensure that it
+ * does not release a preserved device between probe() and
+ * pci_liveupdate_finish().
+ *
+ * It is the user's responsibility to ensure that incoming preserved devices are
+ * bound to the correct driver. i.e. The PCI core does not protect against a
+ * device getting preserved by driver A in the outgoing kernel and then getting
+ * bound to driver B in the incoming kernel.
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
-- 
2.54.0.746.g67dd491aae-goog


