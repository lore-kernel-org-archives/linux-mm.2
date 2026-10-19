Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9704F606A31B
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 21:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=g8J8njJ+
Received: by kanga.kvack.org (Postfix)
	id A6F386B039A; Mon, 19 Oct 2026 17:31:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D13F6B039D; Mon, 19 Oct 2026 17:31:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E4B26B039A; Mon, 19 Oct 2026 17:31:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 674376B039A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:31:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EC6EE1C41DB
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:31:31 +0000 (UTC)
X-FDA: 85340672382.16.700B37A
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3A4B62000F
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:31:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=g8J8njJ+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3MIzWaggKCAEenbumbdlhpphmf.dpnmjovy-nnlwbdl.psh@flex--dmatlack.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3MIzWaggKCAEenbumbdlhpphmf.dpnmjovy-nnlwbdl.psh@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792445490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ZTUYHR3qxY+N6QVtGUbGLJTaBCbudf2foNyHLXy9bs=;
	b=0JlyHgw+MDk+bVCDByNQKJQ6du3fKktzZ/KXw1lMa2GqI0n+B3qCX+CegiTT5gpcucWD6s
	mQK5Lcuq2Uo/3sFNkuLQ3NN+xVZfO+z/GukG2xgJ+u8uTizsazM0ILgHegq/KSVKFwCo2Q
	n9S9cWEQ2BNw5FjE7VP0lgd5VmbAxxU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=g8J8njJ+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3MIzWaggKCAEenbumbdlhpphmf.dpnmjovy-nnlwbdl.psh@flex--dmatlack.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3MIzWaggKCAEenbumbdlhpphmf.dpnmjovy-nnlwbdl.psh@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792445490;
	b=e9ePr2ijWhihG0KodbG+wvLZI1afAPmM5S5bgmFv+5hV+UvuFIKZiWmpApCfXJ5hyu91ye
	opZEMQCMRuNmubgKFngGIWlr7YbUCOAJyg9EBVMko8XqSJGbJMZNfmdyfNs8burVd3Q3bE
	0LMevRckM5K9LLSbAaAR1b0zMVpyLPs=
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cca35cf9f77so1549605a12.2
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792445489; x=1793050289; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4ZTUYHR3qxY+N6QVtGUbGLJTaBCbudf2foNyHLXy9bs=;
        b=g8J8njJ+nuqGALQX4JuSQohHh8UliWVYf+zeChV6tHgYk9JjkVihxwdy8tgEzXhgCi
         mOMpeO5MS46FtL2MsOfqjijpWE8YfGJWNV7j4PpYTR9RFvFVMZ2cf+jupgKt85/0s1Aj
         qcdr8AZuMRRs1wVirflK6ybBRi+d2iBOODit99yqOgbzXTuc9Y1LXeslVTTnHFpRmMqE
         qsWLGfJ/bc5vDld2ObtA6nl9Vo94v5/h+YBzH9/nOyZGBWAXLxb+aQeuSVAdOJNH7gco
         Rlr+a2Uf3ikLD/yje2MDZC684i9T4xcaJXwigoM/+L8JRJKBQWKt1zr+XMs8ViXCgUaf
         zH8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792445489; x=1793050289;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4ZTUYHR3qxY+N6QVtGUbGLJTaBCbudf2foNyHLXy9bs=;
        b=yR3qHHLHRCvraCvXY6uQAx6XDTY6a5zyShbWRYaJkpIWMFQ6KDJkQ24ZylgIVBapWl
         JKFKupGdv1M3qeaqFvw7OV+w8hcbqT6GdYctV2JV4lbDnz75YZuGFTD+mYklrKaskqFj
         j/u58zR7ILIhmZRUbFn25IMKUhuESiP9hikqv4c3LR2YtMHvC3MMT+plhdFPwC1xdJjh
         0sTXkgPADa7iiQHll7zrQ/Z49T9eTK1vDg9+UgA/WnFQa35xt1OwQxo0ntqdf1rEHc49
         VNOjWddCg0nYQ7RiKnIEQn/pq2aQ4cuuziNO9yog1ZC3aBEpjdkyFblgT0lSgoNZoCgZ
         e+wg==
X-Forwarded-Encrypted: i=1; AKwUvBwmeWfEzAHx7SLqCtTcsvKurKWmcnTjzl+/ihWrwRqp345fdFTh6l8MU9YbjeBRQZmvyi898L8DfQ==@kvack.org
X-Gm-Message-State: AFq9FYJlJgiq5k+ll7/80ALGgndCUILEpPVNy82IJyB5u27ywg3tQJCV
	NGWaAiYA3S/QtiYRsSUX68BZ0NJazQrm+pytIphfYfUEJsKh50D1sD1nQCMI+92NAa700Y016GO
	H9o6CIo6Gz4dWqA==
X-Received: from pgmo24.prod.google.com ([2002:a63:5d58:0:b0:cc7:a971:1982])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:2983:b0:3dd:a195:dd55 with SMTP id adf61e73a8af0-3e2260eb858mr6959751637.55.1792445488899;
 Mon, 19 Oct 2026 14:31:28 -0700 (PDT)
Date: Mon, 19 Oct 2026 21:30:53 +0000
In-Reply-To: <20261019213054.3157159-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261019213054.3157159-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261019213054.3157159-10-dmatlack@google.com>
Subject: [PATCH 09/10] PCI: liveupdate: Don't realign resources of incoming devices
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	David Matlack <dmatlack@google.com>, 
	"=?UTF-8?q?Ilpo=20J=C3=A4rvinen?=" <ilpo.jarvinen@linux.intel.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Logan Gunthorpe <logang@deltatee.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3A4B62000F
X-Stat-Signature: 6ioszep4q3xtjb44xz8bradk89hm1wjw
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792445490-31968
X-HE-Meta: U2FsdGVkX1+ZEHqYVP7BLwnic8p/BC1BOxe13VWDh2phuRrJKI906zGTGXuG3iSk1w2W3/pXw9WZwYm/Nmzw5Ccut1H5jLUfI73k0zAlQEZsrazRkVnphPGOTRv/TP3SfWaSkjFWiRbQGQfe9fNrch3ZNBGx4h1WqLGkJ8NAX3R12zBbQrvFIAcenCy1brOh34SD/bEfb1Pg2jpHc/dHyFaQXAtxd/7Ses2BlvwMj1sUTEJWq2YP25Wj087HcZoepPQaYj47UHshmwNKzcrrW7bZocWhmeKOK7nUil9BrbFu7+g6eKZGi5ddDAAp98j9h0YPkvbbYr1A9naEHlpvl4PaYjDlqxZWTX2xFjzrlpByKUj5kqOybwQnmDBBSYx3xjFxhp8pWdjO8QvGqkgHSU1sw/aFTmCdRGm/WaOWNRI7Rngm+zlyWEdFS7Fsu2ve2452ym0c+lQB7nFqFtMYOi831U7+rCSYN8/CL+e8S9taP6o90IJdRXcyCQKgQq/y0Tg9vIMIGLpZS8ezuwUjXYkmJJQUGYnTPJUXIHdetHIHg/TXSsTcu92UpAjt2jn+1INmDAh3caGHOhROx70G6yhu15/bPQ3/T9WThm4SxQbg7MQouGdwT3UEGPb1pfHDd+RSHJ/1uAi9J7qUcExJF18h5mJL4i0IkGSknr7L14ehhJ88y/LSGmJrS6pyJHSuTdvU1eiD0m5vO/nm2jtT+fYy8JoS+FTf6xCHob5LIT8KYRLIhEr7Lg0Af/B70jz9USeT3LyqPcykCscrXVfLM312O+sxV9e1z69RwvaJ9N6jpXCae6ZrHKXB9SlMygveCY/WzJAeMHXzk1V/zddLV5ZuedU0JhYKQCkDehrmjdKwLQt4hUe4+hbZ50OIr5G7zfvsoCLDEVPQXl3gzlT5EI5s64bCsWw3ontu5fMQUndcCTEEZPKXckIrHomkIw1Cd4UZ+kDyQAdwMxaV1yf
 nMLxOrcL
 XQovTlkIvb+0DFRcTEqCZxVPluP/lOFbgVBPmTm9o/g8Sb8tawFbmaY5gL1xReT2FKBoIofQ2AceHt8zNP2MiMKnYUdAXjDnao1v8eV2tHJeUzl5akWn3ry0Wv2mpo6yj/Orm4dYz4eRqEhnKJG2WuKlenFCMjSkI28tGNJZLxWHyAvU9cC1kM5xVOb5v4OPOBwT6sk93gMOlMWdTgwuaB7jhUN8SWS5CvpuoGeiGKaa3BonDpLp2va6QaOERF3Y1QM0ROdju3w9bSl98ihlorCi8PyOwH2zKzObkC3gVuzSXNJvn+KJL6pwHcHHNVB/n7eoJxb8ezaV6eYDlTbDhAlCggmaEan0uTR5rj/YgPVRj8uNELnddCA08iUKY+zHLTV7kwuiWaDX9kQiiTGLb+sCFd8mZ9p0Z9DR7xqPJg/tBGLB65U9H0HNt6C7I6IuzXEuQSJXy7jFhI4TNJGWttzWuIvD32Gc+D93zWIDSgGhomW1BiRU1BeYoP57Sv8YN5hAhRyW40wwkkrJnRiIPowU+Bd1YSotLWecny8GieRwvgSz0pr08Kz2VzJlLrR/Wc+LxEI7zBqhJlwgdOvd/iQELEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Skip pci_reassigndev_resource_alignment() for incoming preserved devices
and log a warning instead.

When the "pci=resource_alignment=" kernel parameter matches a device,
pci_reassigndev_resource_alignment() disables Memory Space Enable, marks
the device's BARs as unassigned so they get reassigned, and disables
bridge windows. Doing this to a device preserved across Live Update
would disrupt any memory transactions targeting the device and change
the addresses of its BARs out from under anything still accessing them,
such as its driver, peers performing P2PDMA to it, or VMs whose vCPUs
keep running during kexec.

Assisted-by: LLM
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/pci.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index e5b960ca26e6..853c84a2c782 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -6750,6 +6750,16 @@ void pci_reassigndev_resource_alignment(struct pci_dev *dev)
 		return;
 	}
 
+	/*
+	 * Reassigning resources disables decoding and moves BARs and bridge
+	 * windows, which would break devices preserved across Live Update that
+	 * are still performing memory transactions.
+	 */
+	if (pci_liveupdate_is_incoming(dev)) {
+		pci_warn(dev, "Can't reassign resources of device preserved across Live Update\n");
+		return;
+	}
+
 	pci_read_config_word(dev, PCI_COMMAND, &command);
 	command &= ~PCI_COMMAND_MEMORY;
 	pci_write_config_word(dev, PCI_COMMAND, command);
-- 
2.56.0.212.g129ede20d9-goog


