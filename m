Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60E1C606A33C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 09:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kZWEYrvV
Received: by kanga.kvack.org (Postfix)
	id 07E7D6B05B9; Sun,  8 Nov 2026 04:04:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F22CE6B05BA; Sun,  8 Nov 2026 04:04:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E125C6B05BB; Sun,  8 Nov 2026 04:04:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B500A6B05B9
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 04:04:34 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 462B3A8044
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:04:34 +0000 (UTC)
X-FDA: 85411366068.21.695B160
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id A17BF80005
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:04:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kZWEYrvV;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794128672;
	b=dD1XDPSVdsY3eq/9BwC7pMdGASI7XBMhFMmeThUF68x3Ca3/EZjnMExqr5sP711wzcK/ur
	/U4vT6DGylu2EJ0Dsjk0ZgyH7RTqfHBMIZMLGNGfK0K++l+TY51XzZFkSGYqLKo2vRoWKM
	99cBqrLqMo6dGbii5Kq0bc3YNIXp5CE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kZWEYrvV;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794128672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1OKxj+jZn3tttfq9U6e6lzT17ukOWVUXm62oh5PZV8w=;
	b=EFpejearmUYT3cw0Xp2BzcnNzfgJUVFQJiUdvBRYhEaaPiSsqp3yFIB2l8RM3LsIwQfiMI
	UJ3Pb027L/UQri50mlVRDI+tIi1IxFXBldmOWEyhc7lA8BqY63Sf3QE6N6+m33/wJ/NQXO
	2R7Uh764Mh1c7r/6FG/2GyjYA2i+/Cg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0BA0044614;
	Sun,  8 Nov 2026 09:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5945D1F008A3;
	Sun,  8 Nov 2026 09:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794128671;
	bh=1OKxj+jZn3tttfq9U6e6lzT17ukOWVUXm62oh5PZV8w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kZWEYrvV7d5iUUnLUXeW+MxNjndjmOabN92/4q7nAjeB3q/XUK7amoJgLiY0aMN3o
	 n622W1TS6wCjmB36bNGvxNIPyvfrvaHZzu93sBO2eNrJJwObUY35JZZOqI5FNOIwqb
	 CHjO36iGGIt7Fg3hBFFgvyzu9xwPR0XxuRQVjCDFdNdOvaqyI/QlioozQU6/m6MqNz
	 VrCE0pFTuvOa4G8+O3sU2H3uh6kZ6tj2It4TijtyS8LhyR01jzLLqLIi1LIuJm37Te
	 KbNJRR3aHt479eacCmqopgXMfp/EU7uMI4mn9HCJtga5Smd9VVU8IobGcEJm1dLZTl
	 bfIRo/sK+ouFw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 08 Nov 2026 10:58:34 +0200
Subject: [PATCH 03/14] s390/sclp_pci: Replace get_zeroed_page() with
 kzalloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261108-s390-sclp-ready-v1-3-3e7c90eb6676@kernel.org>
References: <20261108-s390-sclp-ready-v1-0-3e7c90eb6676@kernel.org>
In-Reply-To: <20261108-s390-sclp-ready-v1-0-3e7c90eb6676@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Sven Schnelle <svens@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: k5h8t6pgmirbt9xyd1ektbsqaefs3xae
X-Rspamd-Queue-Id: A17BF80005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794128672-129889
X-HE-Meta: U2FsdGVkX18Wz9OohI4CZivTZSaH0rlqfI3PDsC7ZZ1SmT/y4Ldo7W9c8QCZT7f2D2VwLTNy8qFraHlrRGx33VmY0fmmoDFX9IzVUANfh53AkLXCPVKZyamTvhe+KsAEkDILLQS90ACd4XO62DbUdilbK3aQftugNYQytHrgTGygHNmhR0JDr5QLe+2anNpcKyPlKthxepudz5WtPqMk4fh9qPaotf49EpbbS4cmBmJ49AR6tjReBXAvxM+Ab6OlVbSzeikL1yY5bc+s4y8LNFNRojD+kC9KrtxIBTQ6Eqr5SnL61BHPnSaRLqyunags1UKFCyb9XConTuxEKeebRsx9icyVJm9c8JusEeqTEq6p0CPmikFrGO8b2YCTPWZ4lG3/vDYRWFFREiDKSxZlv0v0dnc1S4kD01SUtsYS6U0jV4Ju/ZtI19Yn+sArBwe6lLwJMgx3ad0NA/WxODmFlGEqzH8ijgL4l/3C6/uUYI2P3kMhTck2F34Bu8/EteFzmXy8Qa61ukeD7BXKSmt6iQ0MkwYX4E7dngI2pK8ya+U77bkdfZ9/c2kb66edgDefTCWgUyFSxE64WPLg3s9mrsSCDA1Qj6ezYKWQ6XPQ7OhsEUAxtoiVOIuIpDP618dSPh6j4OH7qaNLAz9ovzHS9tdKl4Hcmo4M8w3a5gxM/DfOKv8OP91enlJpU0QYvU2SOcjU24OBzMWv0hDP9LIiE/onK56EgUuI2uEZD+TIZ1Cpp46H9dfBCz1l3GrY5ihXRH5vHllnV0PvXoDvUBSfJulb3Ft7Ytln2utfjfFXcVvzg2vUvQhAoc3QnjT+5qeWyfuWaME0j8KuHcgWAlxKZfxUlyIfcyiZGwQDV+a6/2DWj1F9l0nJvZ5SNQ8USX5u8k9uNg3n9xgc5PqoPR4HScgYuJ/+UPX/fsMraNit6Fub1VTKB+wmowRwvxgffOyrn1qDaoqD0e+XW2LO+pp
 mcN70HcL
 yWt/DCwcFK8VDR2iHAAsJEd+7NH52M4yJ0GhGWT2Qzjn3HIT4U4N/jQCxuAhNn+hx7kClwzV2g/Ijolbp/2vu45xWjeYj8kNdecABaiikrjc1hwCt1PZWa5YoA5csDvgoLxr5hc5ZqSP6CcnAtbn/IAZJ1HMmXxd8fXMCKGeIwwl7z/T/yYFeWIEYzkciXKM20f3sNUoxBBkxwJTwL5QMFpymQK98RW4H8+/R+QpixWfYH0SzH+tX+T9wnHgG7o67QKaR543V900jJFbEgeYCxAhypJx9isieiqRKlbs3KAkl93owDJJpl8cT6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

do_pci_configure() and sclp_pci_report() allocate the SCCBs used to
(de)configure a PCI function and to report PCI errors to the SCLP.

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/char/sclp_pci.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/char/sclp_pci.c b/drivers/s390/char/sclp_pci.c
index b79ef7006e46f..9e3d4b1015357 100644
--- a/drivers/s390/char/sclp_pci.c
+++ b/drivers/s390/char/sclp_pci.c
@@ -44,7 +44,7 @@ static int do_pci_configure(sclp_cmdw_t cmd, u32 fid)
 	if (!SCLP_HAS_PCI_RECONFIG)
 		return -EOPNOTSUPP;
 
-	sccb = (struct pci_cfg_sccb *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sccb = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!sccb)
 		return -ENOMEM;
 
@@ -65,7 +65,7 @@ static int do_pci_configure(sclp_cmdw_t cmd, u32 fid)
 		break;
 	}
 out:
-	free_page((unsigned long) sccb);
+	kfree(sccb);
 	return rc;
 }
 
@@ -134,7 +134,7 @@ int sclp_pci_report(struct zpci_report_error_header *report, u32 fh, u32 fid)
 		goto out_unregister;
 	}
 
-	sccb = (void *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sccb = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!sccb) {
 		ret = -ENOMEM;
 		goto out_unregister;
@@ -177,7 +177,7 @@ int sclp_pci_report(struct zpci_report_error_header *report, u32 fh, u32 fid)
 	}
 
 out_free_req:
-	free_page((unsigned long) sccb);
+	kfree(sccb);
 out_unregister:
 	sclp_unregister(&sclp_pci_event);
 out_unlock:

-- 
2.53.0


