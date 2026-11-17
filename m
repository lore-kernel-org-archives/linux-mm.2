Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80300606A8BA
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 13:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V6z23Cd0
Received: by kanga.kvack.org (Postfix)
	id 4FE346B05BA; Tue, 17 Nov 2026 08:07:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D57F6B05BD; Tue, 17 Nov 2026 08:07:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 375FE6B05C0; Tue, 17 Nov 2026 08:07:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ED8256B05BA
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:07:11 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8EA80A03AA
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:07:11 +0000 (UTC)
X-FDA: 85444636662.08.4941E0E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 00C9D20005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:07:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V6z23Cd0;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794920830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sf0tw5Hzfh3MRdcLooWrdAMwONcFNvSwRTlvWrvAbYM=;
	b=j9+t2VULx12LGy3wHxWeVJIEQ1QoKJO3iRdtR7eVdThxXvskcxsJwlAOJ9KCo9zdEHsbpI
	fZd/D3H9of7gWMuNk2ihNztaC9iXI5E67DfFVpp7QfjNiIpXw8Xx/hDhwxhSQcIELYqIv4
	B8+2944FwyvS7b0f4ssixtEU2xGOf4g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794920830;
	b=SixcfsDmJa/9+fKkQTbewoq03GD7yBio7xYtccPjl0DTbXGJGnN2NtjL03fsO2cCV/z4UM
	la/vpqjJTH5QpqK3OoWvhDx77kiqdVIsPeD7DCp4Bu6Gk20AP0QlF4A8+VH8OFmylVYmYb
	eT2239I74rY3NYp+T34nUPDIqTJsjA0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V6z23Cd0;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 894CB634F6;
	Tue, 17 Nov 2026 13:07:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF20F1F00931;
	Tue, 17 Nov 2026 13:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794920829;
	bh=Sf0tw5Hzfh3MRdcLooWrdAMwONcFNvSwRTlvWrvAbYM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=V6z23Cd0SJZbooN8G5fOj/b/BTpXkTVqX+fQUHxSlAmC6rsA7Rzn2ugBrlbJOHFla
	 1KLL4QHDjdXNt5edXeipJBCKMsH4TaNtwkYz8CvJmt/xNneZ++JAzJ6tvpzOb1rjiv
	 TyL2eC5VpBgm2RouprWBinn6FfpxhpzfCYiSQS54w/eqhPACbzAE7quC8llXCb/UsJ
	 Vf6ne84k2aGHqwiBgXiM6HoxJ/9PHjkElFsjFT6kSeAmp1QLSdOX/0KUCk8XBR8Zcg
	 L5kF0SZXau6+S0FCAEIz4Fx0ZMY2ZRmtMBiN6MYdLiEAFUzITOrqa8kFaMg06VH7eO
	 Nd1Uq9S9OCrdA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 17 Nov 2026 15:06:55 +0200
Subject: [PATCH v2 03/14] s390/sclp_pci: Replace get_zeroed_page() with
 kzalloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-s390-sclp-ready-v2-3-e518c99622c6@kernel.org>
References: <20261117-s390-sclp-ready-v2-0-e518c99622c6@kernel.org>
In-Reply-To: <20261117-s390-sclp-ready-v2-0-e518c99622c6@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Sven Schnelle <svens@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: brfdhe9ta5sdr34zox4qusfybjes7z7x
X-Rspam-User: 
X-Rspamd-Queue-Id: 00C9D20005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794920829-361761
X-HE-Meta: U2FsdGVkX18CSyhc6y5Xd1EnXRtMzrvDEYIZ10runYyysUTUiW/fPAkSPUh9VJvYfHn26OjA5F23rMRbJlfQF1sjqOdR5jGnQcLlNoaR2zWm7FHWOOLmz6FFxjXgaUEolENzQxzti1N99vfbOHzrfwTQQohpHdTC00V1J2sk0tuChfthMCsVJ/VB2o/diWBxRRrI4fsB5j2rPcQnRpoxEgcjgnkaww1SAS2KFr47tBM8+CJYwJlrta5xLN1LKkiEa2WNsG3OOV8ZC0P0ZX7DLWnSSLMUnTeojpNn3QmJS6JtO7SZvdhOhY44YbjNi2Pmhepv8lfQ5Dac+Y3ZGXTgEcKCGfvYcoN0MfmPnRm+jqf3vxlTjKteG+sC1Rm66aNSndpWd0uzvVi35INVRSFlEnUOClzpcfKgGSmPkWo070wM9mBGxNP1Hz9YCe4umwyuGPXr9/RyzaZu899xd8TLw5N0WUNwM/WmX9Knu0kBKklE+tO2BR2zzPeNfjQ7Rpi6Xe+SBYRWeij6bwq687Km+VWIr4d8jeMYJMP3GLQ6VjfCIvd5wVH4vGLPDbTEoZ0vq2LQas4AvIJaB2D5Spb7BJAwcnLaqDt6qCh/AugNMdc2bgMMg1iph54iPRX0Jo0sDBWN+vg6k0rhBZuxHpheuDRQrK+Ud3HThcJYSBgoDXgWCK20qpEucDW2dUdFv1mZFcsPRTlSzS0PYqTFdyjD37/vQLd0GtNLNor3ZKZ5fNWvMgCkhdUHD5YjMA0NTVgnUCp43DXOlDIcw0bltXB3HPuoSsH2yBFxFxmtSnj+Ht0vjol3u/jLsKtDiyRKD7k2/2ahw0BOEAlgip2cgaRupl82NLS6PiUAsj8IGimB098G2frKYFd0zJnATwe9DSaD8zwQgYdr2EiXErek5G3nTyBWZVAbH6XCN3/aOQhXOZkqbFbBwWMSxVcng9VY/7GpNRRMcqNViV8fnCXcgGO
 DroJkbHs
 yjYhVs7mlL5MdhcgHK66T/12ateOwXywPopYqRrVrC5/uE/N45Ze4QTa15+tQokycRf/VymElUMD7bVXnUaBEQcphpNCvzksxHpFaFZnciIxmxpaSXgM+WpmUwjb4ldPfZpjVPQpV1rS/oiYgxoZ2zhDxUj/EXa9VJGJArcBMGrFy37Kr1nMon7EP6hPiA3A87VaZ1VhaWdmSqDnYUZqR9FQg91JxqznNJoiDRhpMDSj0DPWXsPErZ8F8kD9iYb8+Mo0OX0lGD5KsIsHA8wWJY5CeHluLqv+KkCuFDHJksKlJhmR03awOnc5jyD3oCtOdtQL7ZtGfdJx//ColeMVWcvCPTA==
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
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/char/sclp_pci.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/char/sclp_pci.c b/drivers/s390/char/sclp_pci.c
index b79ef7006e46..9e3d4b101535 100644
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


