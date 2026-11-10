Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8535560A2600
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 17:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T6KcfDPv
Received: by kanga.kvack.org (Postfix)
	id A0F556B05B3; Tue, 10 Nov 2026 12:59:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9984D6B05B4; Tue, 10 Nov 2026 12:59:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B0C36B05B5; Tue, 10 Nov 2026 12:59:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 63B756B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:59:07 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 004C8140A37
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:59:06 +0000 (UTC)
X-FDA: 85419970734.14.66B74A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 76FD840002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:59:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T6KcfDPv;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794333545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UdWoH3rxAMjJSmiMO2Z1kLng6PSZrZDHaGMrDeYLQBM=;
	b=lQyjO/5fQgwi4P2IXdQeb0Tvvv+HXitc39quWV6YQPfbeivujMx0Aeo3grKRLiQ3fOv39V
	3XwlcVciyyHlat+WOc80iwNk1G/G2h71DFuWqFELYsx1F2EeeeiUppmAk3WZIBIBk5o56P
	nUHuIY3hC/4INRNQMUG+J3PbcmjSGiI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794333545;
	b=h3I7EOe4JDIYKN2Z623Im/G4QuxBZ4FNvL1KoKPVZcsJuskSoKOPKk5JmipOt2xL78KAGL
	RjQ6I66bMIWDvE6++x8TVEhyLWGBXv5iHJ5YKE6ImhjaPmWx2O8xAaiU9fFL/l32mq3fGL
	iOCi3LC4gDhQ8Oxya06/aNBRXM4c3/U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T6KcfDPv;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EDC3E63ABF;
	Tue, 10 Nov 2026 17:59:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4101E1F0089F;
	Tue, 10 Nov 2026 17:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794333544;
	bh=UdWoH3rxAMjJSmiMO2Z1kLng6PSZrZDHaGMrDeYLQBM=;
	h=From:To:Cc:Subject:Date;
	b=T6KcfDPvuvhcTh5izdDR0sRVp1z64wkzniIfscq3Bjhm8Xpamtaq1jCi92FDfB945
	 U9Fn9MGufVqP1b3mA5j4TaX3UcqvQVa+PmVM/elB57keiEcmVGrmFPefDWP8V/My/+
	 LNqjiNLKRInYv5ofbJ8G4HO5WgsGAAKoN0HsixJRw1zSfWthS5OEojSb7BOOwXRoYZ
	 QU7QMW11vn7ZPWqk39nQqauKgvlzzoD3p92E73oVIq1Hds6Z9C5kdsRaBDTT1hJh8D
	 AZHDC4uUgeZbI4K2M0OmYN+5wyVW3NwVI8oGHCgGa5ZETSEpNij4PTIR3RDPYY8iiJ
	 PvFbFJ2F8krxA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Samiullah Khawaja <skhawaja@google.com>
Cc: kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 0/2] memfd_luo: keep memfd frozen until finish
Date: Tue, 10 Nov 2026 18:58:51 +0100
Message-ID: <20261110175855.2437084-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 9xeciwewdsmnzyux93h64kmuqm4nuoka
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 76FD840002
X-Rspam-User: 
X-HE-Tag: 1794333545-93502
X-HE-Meta: U2FsdGVkX1/va1I/3WeMCPvdj9NXRaqLpib8CyfSxf0IoRn2GWzJP55+xTLfVML1ChH1j7zhqBWdOnnCaCRyTBdk6lQ8WpqP5HlapaB+KaYhw0ulZCwJbhiMMlTBTihD4w7OFZa7L1o+QRFnCPsPHBwci4KHVqlbEE7S0xoEQK6P0ZfYv3iYjxFXh9kewawOkQdEwn86qzezyhL79FJ7apY+DSD+PaiR4eLF0/0WJGajj6C5kOz+C4iT29vAsbGSP/cw4J1Tor7d7IVnufHM6snM+gmMLdnL2YRiq7Lmfw4v5AFsvpUL4Ktg2ALQgIglxovbOg506bBQRZryYmaX6276p0kOSr2QC2hSSnpPV+vKTm60nH+4sZ+nrD5KqNnOyvE6hHBw5kz7qYjw4TGMvI8P1ts2fvud8su3DEiqIvT+BlG4CmXXZkee0DcqhS/HbhI94sCUFcKGUVlbFf3+kiJcynoU3LuuNTnJ0bccdH9SFk5G0BYR2cfiGGSPffxqLlItEkNN4wDGh4j/XQVegxZqJwGPcOtbzG2VpQSRVxdo/K6Ns4LoF6kGaBV/mbN3/zIyorNyUkmQ/fpTRhBAgO/rrt5Ob6RO0x7gq5T2Rve7yOw+ycUxwjP8tX0dRxEI1OSpCshzz9P64auyKAxdws7m2zbR7f+KDKRUeY5trOiBPzijCysB0SpXEi5SYwFuqbHm+BoZbw3VRamvxEJe6cpMrYHCVQfb/hO3QUVpXxVThKaoBX6Q1UPqQXU//zNCfDVzhF4nV04cTPOq5xP5dmrPmkPkA3MbaXTGNPSgR7/r1zzqMeSBZ9wTIeCgDavWLoCiBbLD+lKcYKPbdu2FCtArUCqbmVT2ITZKHYiiFJYajF6Rjkx1LpQULgtUVIA+1p+u8JVKS2IFzydGxa2v0TgoPYuB9u5hklYmx1gYbskOomSHvyYhpUwBfgKUBCZKTpWQWKbPM47IJiCvPvs
 ubPXqLgI
 pHIRS3QCEdGXjd/vBFXReBU9FytNfrNsKIZxjx5xfbuP0I7Xo/8/a7OHxOYdGlUINf2cOyc0egbsijrws5Wwuf5d1gQdJDuIpoxhvladDGsuMyjav6bB0yBg2jGhi4U+aW/pdGac1MEGo21IAz7DFoK7UxC9lEhaAcAAlREXdnBqAEd8cFgLPcLlQ9sUdEZbU8f9QnCUJ3t682xeU4DxKtqJL5L99FlMpJBJLfJj16kRZbp1aWmHCuNnBUG6MSo3Onw0UGu/VYIewBxcOZBTkZStfRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Hi,

This series keeps a retrieved memfd frozen until finish. The main
motivation is to let dependents like iommufd have a chance to acquire a
reference. It also fits conceptually: finish is the point when the file
should be back to "normal".

Patch 1 allows keeping private_data from retrieve to finish. This is
needed by memfd to keep hold of folios_ser, which it uses to give up its
pins.

Patch 2 does the main change.

The series is based on
https://lore.kernel.org/kexec/20261103172251.2348370-1-pratyush@kernel.org/T/#u.

Changes in v2:
- Replace the stale reference to the 'data' field in the struct
liveupdate_file_op_args kerneldoc with 'file', 'serialized_data' and
'private_data'. (Pasha)
- Collect Reviewed-by tags from Pasha.
- Rebase on the latest liveupdate/next.

v1: https://lore.kernel.org/all/20261103181916.2462825-1-pratyush@kernel.org/

Regards,
Pratyush Yadav

Pratyush Yadav (Google) (2):
  liveupdate: luo_file: allow keeping private_data from retrieve until
    finish
  mm/memfd_luo: keep memfd frozen until finish

 include/linux/liveupdate.h   | 11 +++--
 kernel/liveupdate/luo_file.c | 11 +++--
 mm/memfd_luo.c               | 87 ++++++++++++++++++++++++++++--------
 3 files changed, 83 insertions(+), 26 deletions(-)

-- 
2.56.0.542.g3ef89b7020-goog


