Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A89F606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 20:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=outgoing.csail.mit.edu header.i=@outgoing.csail.mit.edu header.a=rsa-sha256 header.s=test20231205 header.b=HrM9z9La
Received: by kanga.kvack.org (Postfix)
	id 3DCB76B05B5; Mon, 23 Nov 2026 15:08:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ADDC6B05B7; Mon, 23 Nov 2026 15:08:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EA7D6B05B8; Mon, 23 Nov 2026 15:08:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB7AB6B05B5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:08:11 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7FC65160871
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:08:11 +0000 (UTC)
X-FDA: 85467470382.24.85FEA06
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf06.hostedemail.com (Postfix) with ESMTP id C2D60180008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:08:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=outgoing.csail.mit.edu header.s=test20231205 header.b=HrM9z9La;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf06.hostedemail.com: domain of srivatsa@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=srivatsa@csail.mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795464490;
	b=1WraIMReUqjM1jPBJQ+NWyXSwZIcj4RqyTI8ukfrOam374ssE/KWq9u2CZlzhk+gK97bUt
	WBkwBXh+2vaHzwO668fIiFC+AyirAs3ow2QynbNfqB4zwkC4fxjJNQ6AJAFWSDfBi+afY6
	ecGSTf4P8cICNEXuARWZvd+XUpuCX7Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795464490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OhsoY+g6owXOc1DL4OmeSM9RwI0X3DHSQa1NGA0YGEg=;
	b=gg6u+mPbwgpNfkGgpRrZb2Izdbrp1qGL1d7ItA3FCX/ah0pqatHpcPkogACCKZ36Jeu0tj
	S0XHe0YxcpJE5qeEP7Yb2EuwpvfhGXIfapX9vbS06nV3DTV0n2VmaJDK37f3olLeXVhfib
	Fim1vtMXySDHOXoRIFUqEqSEtW3eIVM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=outgoing.csail.mit.edu header.s=test20231205 header.b=HrM9z9La;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf06.hostedemail.com: domain of srivatsa@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=srivatsa@csail.mit.edu
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=outgoing.csail.mit.edu; s=test20231205; h=Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=OhsoY+g6owXOc1DL4OmeSM9RwI0X3DHSQa1NGA0YGEg=; t=1795464489; x=1796328489; 
	b=HrM9z9LamvDRUcf1JsYApHfDDADp/w9T7NP+KDvTa8Wi4+QO+qchZQteWMCnkpWDMImEBbiAkR+
	moH/WRsBd18/XWbD/ivipC1O6YvoeX4e+FX7C+hGQpwe4qq9gEt6JMAVK/V6E6MpRdETtLJtDr7uq
	IksCBM3Nc7vLYHI5MhtSKQSXfr1kcFodTnQ9tRS3IYGt00b2+c4AwCr/iEc716BryxUCIRXFIjcIZ
	ARXcSVDj3Hzg0Vvb546L/bBN6b0GUkJyyZs+Q8sS5VlvXctiAjXnfdIvMoqR69qeM00JZRcChMdEe
	5WgOpeIeehFKagVTfXXlxg0kGCHC/iD7i0Sg==;
Received: from [49.207.211.146] (helo=[127.0.1.1])
	by outgoing2021.csail.mit.edu with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <srivatsa@csail.mit.edu>)
	id 1xVaKc-006jgv-OW;
	Mon, 23 Nov 2026 15:08:06 -0500
From: "Srivatsa S. Bhat (Microsoft)" <srivatsa@csail.mit.edu>
Subject: [PATCH 0/2] MAINTAINERS: Add missing files to KEXEC, KHO and KDUMP
 subsystems
Date: Tue, 24 Nov 2026 01:37:52 +0530
Message-Id: <20261124-fix-kexec-kdump-maintainers-v1-0-79c6a6144de4@csail.mit.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABidBGsC/x2M0QpAQBAAf0X7bMvdSfgVedhYbHJ0h67k320e5
 mFqmgciB+EIbfZA4Fui7F7F5BkMC/mZUUZ1sIWtjLElTpJw5cQDruO1HbiR+FPhEHFy5OqGqHK
 2AT0cgTX/713/vh8jKNq+bQAAAA==
To: Andrew Morton <akpm@linux-foundation.org>, 
 Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
X-Mailer: b4 0.13.0
X-Stat-Signature: ktyr55fd8pezxwtuc53sty5uoadkq3ah
X-Rspam-User:
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C2D60180008
X-Rspamd-Server: rspam03
X-HE-Tag: 1795464489-423271
X-HE-Meta: U2FsdGVkX1+kBPMpOICX/lOXgtfODP7uRoUbrwZI9NfwpcIFqafU1HvO5QgjDuha5mtmAPFGw8nWGfQk8tBaikmcLfrVaCxBdTOClQIN9dIK+95DyT5kKrt8uiYrBI9d+hb+AgB654ceTxDpCRFiX1zk2hZJjDRyeffUEKZkgdIn/0/IUsBX3kDab+ljqgfRFJ3zL63oiGEg5sc65tZmgVNWIJSuWztrcHx4fZOkUosjo9/YBMD+RyGFgHm5ztoF62QuIfHN8A+4JFIF+LbGGPuPbviIc3Hm6tlAxqdeJgnNEvztxvedJtjuv8Umnih/wVWMArhmmLVJvm1CZUICEyTkczAbTlecW6P9Po5hVvSIoyzHPHQ/Ki2FNY2KLZQPTTlTr+3R+jpSCwPxluDTaiWdxcsYBKAjkyXfh2m9hn2j7OHeLC1l2vuglDhFK4ViL4ETK+rMPgdT48ZmH/c1Li/Icbph+trpYRc4QUYxOmq8EvMjjQgfYySei9vsEttRvEwV2hjlNh+QJ18RzXvRc+fowyXLWRKWOVgJlufd7RpwMm6YXONjRPAGKx6xGAminq7w/kfWBCfXyduq6G2GAfpVl+pMS2Qy1LrdAS+guglYpcfkU8vZc1nNMa01QycQsVxTDC4HmlyN/sUgitYMQNFrWppqRwHVsZrnMJj70r8aPUnnby2ZLWYiv5HF2HZJRkxtuy9Tl7wcMh90BS6hKpO8Zu4SyPgEfzYxMq40k0ljntU4eGZbGl09Nc1N2GQZbAkmQKZSlF/vP/CWo1yNZHs1BbimW+uz/LA65cZPCtkgxp+pSdYPzesKHFErbvHHGz9zr4cTuJ7wLhbAO5UN337MwvBHjgXMSpRr1F1Dw0cv8jbWOzJF9w+fUyi1hmhaPVLB06ARICTqLg7Ldl6krXUx21W23s4JGmC+BMUf1f2aT9OT7uwj3EwTvqgJO6PhkZ4am4G0IsuPF355dfY
 Lb3fBNXw
 s+EirFonQ9UCt/Gr3BDLcvUcvp8g0qNGdE5wb6fdyfLvGn9pWPXOxyOq/Pz08FmtTq5DkbnMStnOPTEN01KcLNdO3nZGeOF12/VVgivgzrxv+Q9/PVNX4SSaqtkZGqibokKKZA15ujj77XJFtOc1QdXalPm3An0vOKcNVuT51ti+4IDqW7nVBaXo1uulN5d/fYKYTYPx97adxOPKPGHI3UL6hZ+bHEDokjRrWmTBJLLIrN2G2QRRyFX6HgJxZnRdejfq2Y1hkAu1WsWVFCUYGOK/ZBto0a9/c8y7ziBbPgCPxDBc4FNUyBlMeTFBp+vpTDl4zfmWw0/hLwPItYp+TxvNHsTqh8p01eOMLMiDi7H9KSmwvLdQRMueskuTFagHIw4cMU7xhSejMyEEDAsey2kgjoX/jRep2gPa96Cen7BZo1VpYQ+O81eTVrf82Lf8DXiO+0m8G4vuv4ZY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Several files relevant to the KEXEC, KHO and KDUMP subsystems are
currently not listed against them in the MAINTAINERS file, which would
cause scripts/get_maintainers.pl to miss recommending these subsystem
maintainers or mailing lists for changes to those files. This series
addresses those gaps.

These patches apply on on top of Mike Rapoport's series:
"arch, kexec: declare kexec and crash capabilities in Kconfig.kexec"

https://lore.kernel.org/kexec/20261119-arch-kconfig-v1-0-37c276fe4d26@kernel.org/

---
Srivatsa S. Bhat (Microsoft) (2):
      MAINTAINERS: Add missing files to KEXEC and KHO subsystems
      MAINTAINERS: Add missing files to KDUMP subsystem

 MAINTAINERS | 13 +++++++++++++
 1 file changed, 13 insertions(+)
---
base-commit: 3e14cad9ff9ece9c0115ee1d80eef398659db0e9
change-id: 20261124-fix-kexec-kdump-maintainers-f3a389aa6329

Regards,
Srivatsa


