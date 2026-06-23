Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FD37CDB471
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 16:43:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F9376B0088; Tue, 23 Jun 2026 12:43:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A9F96B008A; Tue, 23 Jun 2026 12:43:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 599E46B008C; Tue, 23 Jun 2026 12:43:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2EA4F6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:43:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC76C1C5AEC
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 16:43:39 +0000 (UTC)
X-FDA: 84911748558.04.E437837
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1E02018001B
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 16:43:29 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782233010;
	b=bbpJ+VDRs7daG1oDq6V9WA1/gRmBvUSnK42tnVGKxaIFXa8xf11pUJh0JMN5jv5JL97f68
	HKDV9qUBeR6ZwYRcLJ+FTEach3upMzZZNRfS8oLmfh0LKomk/1wXBQRmnenXPe58iJnNSE
	Ktdl3Blkgjwnv4vAFdUCBMLXPwzSD1I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782233010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rUCXLhb0bwQI5jAi3AeGaL2pacxrrvJDt+WvFjr4LkY=;
	b=kdcl2yzPyDWZKT9chlMuysBF0It2WYtYVHwMjxrpJlIkhcRg31T0DxFFK6WaOegf+Z0R3y
	RtsZb/NsF/JiHMgNjJk/SIVnQkPX+9gOF2oZ4vLi6JnMfpV2G53Cr+aMiH+rjyBVscHI1b
	ykXKr2LbS27R5pf99P9Xstp1vlEGt8Q=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rdNLn0QM;
	spf=pass (imf16.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2c73cefe192so62545ad.1
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782233009; x=1782837809; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rUCXLhb0bwQI5jAi3AeGaL2pacxrrvJDt+WvFjr4LkY=;
        b=rdNLn0QM0Rlm+EWD0a4A5kO/mQw5jYQRKPJTdmd1eZR1eR5Uf/hlDt/MRrf9B2A/bC
         k88fPMeZVanMzWIfoCXEmCMEYQqzi9YmbrJ+/ALIghtONibxhCsBEoriIhmRjEucdd+b
         sQLqC+OvrMcwtJ/MyU2vYZtZvNeomFswh79FKV8+5R6rM4sbMDurbaOk16jeDP6xN83b
         roH19U+gVHasOMa/WDss0PYWbKODzRZHCT2E+cx8mAk860oCV/OAyAssS9dnsxhm17C6
         orXAcoILavVc48QH/NV5lKhCPgJ5ut7aUaHEU18f9dQTD6HW7GewrTXy0NilCxBmoMe9
         41rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782233009; x=1782837809;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rUCXLhb0bwQI5jAi3AeGaL2pacxrrvJDt+WvFjr4LkY=;
        b=Lf1NyRTA2sSAorPdt5M9y9wjl8Yr6Iv/wE2nH1z15oTeZgqbf3yxTg3JC11qOU6YXF
         y1IaBA0Df1GXZgDCKGmsDZ6iGuvpxcIQuXtb7QWD1jVmX6yFtcnmDHzWLXGOVCKqaJ96
         4o7yuZUHka/HNN9xKyAUBcCtbFbGDX0iP46QaprsmaFf2Htnse0SXfdzixw3k6jqay5Z
         78DhiZx/HTC7CSomoRCOu3jK+P4f6P5B1W0bLQNdAvlup9k0/J7dhUkkFcMwOJ4YXMZS
         SvJMM6iRLZBOxcOvmhgGqRZVCuhwbRrerSgyxrJFXU36U33p38INqL1ZAgCo2yem0Fmi
         lY3w==
X-Forwarded-Encrypted: i=1; AHgh+RoaQ4MHHQxUiEtE0UoUqaPZo/v9xKTE5Ve/TyEh38Hfh4diQ+HBzoJRczR4qVW3nicckxbRb+JmAQ==@kvack.org
X-Gm-Message-State: AOJu0YxQMfMSCV40pGseRtD/AgFcFDgYhPeQZZ7X+BqkjIcUsudNeqaP
	h3WT4NwI93ME8Sm8vbmDGUdJyGDaIe7cSsaH9kvqTFtLny4s2ce2Zx/zF8hevWqJNw==
X-Gm-Gg: AfdE7cmdoA4PYYzPGC7Y4q3LusqNLT0/Iqc9I0rW+2LjCc9gCdgY90gsFraBM+8uiSV
	0j8xEndb9lw5LaTN6+pXrlB+Khkg5TDTiPYC+mn/crlPsvIJj7GjjZxWpopaS6KpVs95ME/LPGo
	kicWBSON79lw3oUpJe1v4EpLZpwsNtp8NmVAfBO8E/8s/2PhgEqasRFb5A26UidRQkALBRs62sc
	goTgQAFPzbXF+K4NqVZlyhFq2/4R5z5OtqgZjrDJ9dP6xJF3COYnzdnvuJXld6x7x3WD6/hFyrS
	hJ9nCd/3Vb5H79+N6qS1AweOhmLRMLioacNBv/mVWDCiZNufRU+qgHuTsNEOXo3nIKP2fjaMTVL
	PC4kMGy1NcLf8LAHjbLdft0T7ZiPTKi4j7lJQqUmI93RrdTQv+L90l2M/qDbX3q4lFGgwSwVb+j
	6EstS661zxCILvun04QFdYAgEVaATx35REKVUJ3f/btDzDWHlvV5h+SoVrJTw2gcX7f5EQuNrHA
	7HRK3rw
X-Received: by 2002:a17:903:320a:b0:2bd:6dad:7ccd with SMTP id d9443c01a7336-2c7c7118b8amr2140445ad.25.1782233008303;
        Tue, 23 Jun 2026 09:43:28 -0700 (PDT)
Received: from google.com (25.75.145.34.bc.googleusercontent.com. [34.145.75.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84564d6c5dbsm10669159b3a.12.2026.06.23.09.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 09:43:27 -0700 (PDT)
Date: Tue, 23 Jun 2026 16:43:24 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v6 04/12] PCI: liveupdate: Document driver binding
 responsibilities
Message-ID: <ajq3ohoU2hJfhsp5@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-5-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260522202410.3104264-5-dmatlack@google.com>
X-HE-Tag: 1782233009-965674
X-HE-Meta: U2FsdGVkX1/tRNjNOPSHYwxIO8CehI/wxXWRoxya7hDOxahXxLdmN04gjBzTaXchMhjaQd4g19IXm2qcIaqnH8iTjCJ1nYRREK1R213D2qJh+CswgD8IxTM5a1F5yt60WBMxbI56f3n6yCACY0nuHzjALb+vMndlw5uYLSrI6Ksy4cjn0nRxYiXRy20ap+o6wfeDmt4cF7IgO45SpE73weCob2ZVYwbYyDTr8VIDkg1m5fzbZmefM+a7RzPTHC9F3X6siFjJUJFBpEvkMBybKgeAh8mEB7ELSJM1xnElLtZF0WpTXy1DQzBQoQVkXXY/gpXWWrmHCwpOFsQ5OMkrFCA12R708AElXlNGfHqyluX5cIjU0RGfrRFmvRJKIVnvfPNHmN9uS12U2spcJ/GQkea77bftVhpJ1LQxNZCwbVQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 08:24:02PM +0000, David Matlack wrote:
>Document how driver binding works during a Live Update and what the PCI
>core expects of drivers and users. Note that this is only a description
>of the current division of responsibilities. These can change in the
>future if we decide.
>
>Signed-off-by: David Matlack <dmatlack@google.com>
>---
> drivers/pci/liveupdate.c | 16 ++++++++++++++++
> 1 file changed, 16 insertions(+)
>
>diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
>index 96c43b84532c..4f2ec6ffdd16 100644
>--- a/drivers/pci/liveupdate.c
>+++ b/drivers/pci/liveupdate.c
>@@ -70,6 +70,22 @@
>  * preserved. These may be relaxed in the future:
>  *
>  *  * The device cannot be a Virtual Function (VF).
>+ *
>+ * Driver Binding
>+ * ==============
>+ *
>+ * In the outgoing kernel, it is the driver's responsibility to ensure that it
>+ * does not release a device between pci_liveupdate_preserve() and
>+ * pci_liveupdate_unpreserve().
>+ *
>+ * In the incoming kernel, it is the driver's responsibility to ensure that it
>+ * does not release a preserved device between probe() and
>+ * pci_liveupdate_finish().
>+ *
>+ * It is the user's responsibility to ensure that incoming preserved devices are
>+ * bound to the correct driver. i.e. The PCI core does not protect against a
>+ * device getting preserved by driver A in the outgoing kernel and then getting
>+ * bound to driver B in the incoming kernel.
>  */
>
> #define pr_fmt(fmt) "PCI: liveupdate: " fmt
>-- 
>2.54.0.746.g67dd491aae-goog
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>

