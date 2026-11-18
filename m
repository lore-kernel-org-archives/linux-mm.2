Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F5E5606A9AD
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 22:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=UktscjLQ
Received: by kanga.kvack.org (Postfix)
	id 437636B0610; Wed, 18 Nov 2026 17:37:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 380616B060D; Wed, 18 Nov 2026 17:37:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 210996B060D; Wed, 18 Nov 2026 17:37:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D76376B060D
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:37:15 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 486E41A08EE
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:37:15 +0000 (UTC)
X-FDA: 85449702030.23.5B4F2B5
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com [209.85.160.70])
	by imf24.hostedemail.com (Postfix) with ESMTP id 97FB1180009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:37:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=UktscjLQ;
	spf=pass (imf24.hostedemail.com: domain of 3mCj-aggKCEEgpdwodfnjrrjoh.frpolqx0-ppnydfn.ruj@flex--dmatlack.bounces.google.com designates 209.85.160.70 as permitted sender) smtp.mailfrom=3mCj-aggKCEEgpdwodfnjrrjoh.frpolqx0-ppnydfn.ruj@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795041433;
	b=FZBuu16LXlyMBo+RB90CrSwzSbJcDOU0tfbm7lMUJuX5uNtJHLKRiq4mko6kjWrL1cIWd7
	kc7qzvOYi5snH8qXaMZFNfWnMCBWUTP2hJQ0LpjGDqa61DaxVxYTb/DhYp3zasuwlFn7c+
	alfYJnE7VjorYb9L5KLmZRnbmccVdJc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=UktscjLQ;
	spf=pass (imf24.hostedemail.com: domain of 3mCj-aggKCEEgpdwodfnjrrjoh.frpolqx0-ppnydfn.ruj@flex--dmatlack.bounces.google.com designates 209.85.160.70 as permitted sender) smtp.mailfrom=3mCj-aggKCEEgpdwodfnjrrjoh.frpolqx0-ppnydfn.ruj@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795041433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ad5b7cD20gHMOhZMyF8+WzruE7aQOBAM0dk/O+UacAU=;
	b=N0LO1pBMCjBkEBhAiRcNfoHF3U9XuK38X08Qo6zCM2wyT425kDiSDnfvUdbvTSXFarE8bx
	GUvPkzKhkdJzF3LigbmDySyUzmMd1rbGfqoNc9RcqACnX334fsdsFcsAMC9TD/XG/eYbTw
	mQG0MLuMuZw+46NWUgYpAj5aajSlVWU=
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-4943ed99826so1128323fac.3
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795041432; x=1795646232; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ad5b7cD20gHMOhZMyF8+WzruE7aQOBAM0dk/O+UacAU=;
        b=UktscjLQVFLNIt6zXPmajrIz846gQ3x6m/2hQN/ujuPr/+sEMXGB3GrTBXzhi1YjNE
         UIOQu1SqfJJSvUjAe8GQd3bM2xwo+CCkCPi7geFJtoDrtBMDy/zOM4aPSgC3GDAVmh0E
         +2BwdddcXJkJgv79/ejIU7tyBpgAHJZaK95mo+eXh+fCcRshq3tNa34Gj8f5nqn8YIML
         mf/P+v7fpbqInce91rO7kLVQXEbk+mJj38RQIvG02oOsHMCH5v1fISAvGYuOfRzpVqsN
         xnesZFu2psKBN/apUMrTclCejTlMa12A+nrufoYInX/Y0j1Z2SlT3hl3so323sOnj3J+
         dNJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795041432; x=1795646232;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ad5b7cD20gHMOhZMyF8+WzruE7aQOBAM0dk/O+UacAU=;
        b=23v7NZ5cog+3KitgGN1TM9vQGP2LlgDTr6c53nqAu5yga08mvQ/QyzCU/84jLbYxnj
         Y5ba1slSPF5d16xZ1t3kCXgc/QUmakyjxh4PJaqXRuzBeRsMV8eifF35U85kniDea+BO
         y19M+rvKJX5ft6jm8/tO2nefJubmwX9bXwU6kx0T6FkBwqYVpjBXqT7vCMWJQdjbSzmb
         zxEuTbMG5j2W2g7KgewT1NWY0N7S68nO9EZTMwvFwuWAYDFgjCrMupEfEi0oRKq5wfex
         qKkABI7+tfRVyHNdg9klh8w3Hql2y/eN5ty0AHG+ttPOpHRx0lqEUaKBzl3PrbSbjPMC
         8Irw==
X-Forwarded-Encrypted: i=1; AL+hErEnX69iJv6QUQnjnf96KFyDJLVG9IEZVB8z39Lsn36gaGCCknpDRWOx3bdhNOOWTpTcqDKmBOHahA==@kvack.org
X-Gm-Message-State: APuU4Z9Ph9MNHx6XYV74lw2T/V+uD4vvpFUpmERP7gMr7/fNq9hdjfn2
	ubRaxbeIwpdZYkmdK4997PGgto40sXYyAxcifHgM7NHE+P3voA0ZsVtJVtEzFYpSC43ha7PAH+J
	p/Lig0t+xutXctg==
X-Received: from ilqe2.prod.google.com ([2002:a92:d742:0:b0:53c:2d10:3af1])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:6401:b0:572:8a:59e8 with SMTP id 5614622812f47-5773d72c450mr4859784b6e.55.1795041432243;
 Wed, 18 Nov 2026 14:37:12 -0800 (PST)
Date: Wed, 18 Nov 2026 22:36:55 +0000
In-Reply-To: <20261118223704.3286085-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261118223704.3286085-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118223704.3286085-5-dmatlack@google.com>
Subject: [PATCH v11 04/13] PCI: liveupdate: Document driver binding responsibilities
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Alex Williamson <alex.williamson@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Down <chris@chrisdown.name>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 97FB1180009
X-Stat-Signature: cagrb77gcb54u1jeirdcpm3x1wrgdkxo
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795041433-798585
X-HE-Meta: U2FsdGVkX18iUFKRtHcWN/usW1JloMWzf7fywUSXu78qq/4JMx22tQdFrUzunu6FPhGiIxrS+CiuhQdZA0QZ96cX4zQM/z7LZ9FkBM9xtnB/RVSNv7Rar+puQKTdDlafibzWoN5GCIZwwwEhZf+yrVzrUXB7FfJQe2sBGTK7oF3vNsqyxPxJgn3Vt63xdpXk0kkg0El9qipErywbGfbDyu2pQW6jaBdVOBgtCZQHbzsYPjcEktKpiRnHd34pBHSoNotUoTACIvSbppq0A7OIvd+BN/GZIPfkqrvocrlPF5udTEs/7IPArFQli++Rvwgjzywlz6tDdykrNuW8VzHQPZ4SiU/Kfz7UPMiZ3lSbdpGxqKSVVvg7jU2LihYOUaiOXfQjKq2f4OV18Bc+QduNVlkb5078scM+w8MRu3HnEXjPtxVjKnYgmv34e3sLxnU553cc8kIbFU6U4ok+kP9VBZnk634jIfXTlmQleQ/Va1rFlZPVgvNq746mKeEe8fdeMBmKjy8+dkVnaEktEyVn9SWSkI3UBTSrllsRWh92i4BkLplR8J3SLJ33PKR8yXtYduxtET5H82ksNhlHjhmcMjUsUAcR3nCtF24pTZQIbdP66b76Lt+szBrGrG4xTl3PnBiJin0oVUAzetsQbx4XXQt39tfNy1w6M+fk6+4jKvF/VWqxH28YpzDUVb67WPGABPFBUVuvYa8UXH7V4AUrrzXfH15674IuHyaoxqSbEg/B0wgZgg3su8LrJmRNQoLiQlsBe32u3s9RXeJGkzLeB6sOat9JwFbUqu4G7U7xRyggUn6lt3JhTZEXl0ZpH2ffEZ79lI8DBaCW3znr160qwG6NAxbVUF7RJpb/Y4w2Slu9c6EjNFQERVRuM8VdfMlBiWlq26x6TRsNIQU4F/qrlUnCzFwvMSC8NopAkwFi0PK9eEkAeTuetVRlZXk9NBlp+Nd0YY3QNLNbx4JT8ms
 uC+gE86x
 m5g09HuchQHC09jTnoxYbLFzTlmC9Nfc8BC0RHGxQ4hwXGYfhGnzhac91CzhIn6oJzCkzMb9gAhlouMf8MYafR5bbs4uZ9V50B3qcmm3dYr5+jVO0PAV1DyykuC8LrYijg9gxhiS7INjoI0dmas//hSydkdnvnYvPsMefID6iKh5pbCfjbvolz1IAZ1BrZdyYB8eaiVUU+A+NcaptW19Gqvnbz7UhFzgygNutAGYsj2yNbH1C34SNQyfcweI2Xcv9anNhBS1sNWtDRWKyuqTZO+sa4Nckm+MPV4b36BWNEFP7VP7slpkoQwRblqtYnT7zPYckrOiGnFGG0i8xy7IKxOHPcSad+LDSRHt8bwbjRHBhpOpo6PG4Ccp8Ntpffp9DeDlLmYwPDfpJSeTknLNLQvTltYjuwlS6HNNzJXx5yE0dABiCEZup8NEQYhjxIcAfP9oi32lb4sUK3maxiK4UydNWJZp5VpgwcYeSNwq/b3c48unTw7pYs82qUHkW+sjF+uyX/+KegZqHhC+jSy10MPCh5B8C/FDsVNmVecJ+n9Kd0DSHFuOsbUDWODxK6OjRrHdcw3FG7RYTkOYimwoVfEqvrRnjQauxZmCkUdNoM8mlfg4YxkdvJCgXRqq07asWvQwSNZTuqemHUEhW87V5THevdF/x5oIXwwW7sVugkGxpNtHuB4J/HHdyGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Document how driver binding works during a Live Update and what the PCI
core expects of drivers and users.

Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/liveupdate.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index b569093bea75..d1b4000c3e78 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -123,6 +123,20 @@
  *
  *  * The device cannot be a Virtual Function (VF).
  *  * The device cannot be behind a PCI-to-PCI bridge.
+ *
+ * Driver Binding
+ * ==============
+ *
+ * In the outgoing kernel, the driver must ensure that it does not unbind from a
+ * device between pci_liveupdate_preserve() and pci_liveupdate_unpreserve().
+ *
+ * In the incoming kernel, the driver must ensure that it does not unbind from a
+ * preserved device between probe() and pci_liveupdate_finish().
+ *
+ * It is the user's responsibility to ensure that incoming preserved devices are
+ * bound to the correct driver. The PCI core does not protect against a device
+ * getting preserved by driver A in the outgoing kernel and then getting bound
+ * to driver B in the incoming kernel.
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
-- 
2.56.1.703.gf848ed807c-goog


