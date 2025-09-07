Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C339ECA101F
	for <linux-mm@archiver.kernel.org>; Sun,  7 Sep 2025 07:00:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 293BC8E0009; Sun,  7 Sep 2025 03:00:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 243DB8E0001; Sun,  7 Sep 2025 03:00:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E4F48E0009; Sun,  7 Sep 2025 03:00:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F2E1E8E0001
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 03:00:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8E5D611AC2D
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 07:00:42 +0000 (UTC)
X-FDA: 83861556324.15.99A52A2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0609440011
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 07:00:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HgDPUEr+;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757228441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aIyksWTmF+WPRQfDWNQ3wfYCg86aJi793lKO/e/geg0=;
	b=ttYT6p0OcKciSMI03d6N26+W09fxc9Lu8DxXw4j408kBLwa+SqvJBY9zaXy3OL7IsGt4WU
	Vxl+i48mKP6sf3FL2438XP7vocTv31apcPK23iTBWOzwYGKF3nmM8Gkn0bjhwGyV7fnOpv
	dxS7jJHCiW4JVknqvKTfFzneHWPxAo4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HgDPUEr+;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757228441; a=rsa-sha256;
	cv=none;
	b=UxAazRq5mwLoF9MNDWYo+4QVdzPN/r+cBFN5xUN0pBXUJ+oOxtxbh7TGbHjQTbF0gNyM4U
	qZqlJayXe8esb8DrnU3V/gr12Gj86gZDDbgNh7lOhnWOg+Mw9TIrJZ2tLXZLoGWWhOQSI7
	4JiuuKyfncfl1a3LaLoiIY5cPeq2MG8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 334E3601F2;
	Sun,  7 Sep 2025 07:00:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA2AC4CEFA;
	Sun,  7 Sep 2025 07:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757228439;
	bh=Y+6NT7qGhfiYpIQPVV4I0mtOFqnghk5yu59oPQEuT2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HgDPUEr+nACQDYmwMPpNxXvHoZoDdvANiaJUMpLW4tS3GcSp1/k3Pr84+5Ir1abd2
	 ckZUS8wUb1PmH7Dx0xqG/nfAHPjouj3pTAUA+haMisAuuWYnFQ1wT2/AYWvB2v26KE
	 S35V+vdyN78ZZe3plraMPrn6JsR9rgbvow7wUihUmt+3HHQGhsbsChl2udCBjwI5dd
	 /l5RZd25dlfVBMJavzboaaOCj3jon6FeaLKNVqUMP9RaK/GsX/uEfjs6Fwx1VR5Owq
	 kI9qX3VN3ikWNkolazVK/3V3iS/3skSqXIEyYpb2IozltdgiFhmHQERtPw+wqhB18Q
	 r/2XppbwT6uGQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Graf <graf@amazon.com>,
	Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Chris Li <chrisl@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] kho: add support for preserving vmalloc allocations
Date: Sun,  7 Sep 2025 10:00:20 +0300
Message-ID: <20250907070022.2177974-4-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250907070022.2177974-1-rppt@kernel.org>
References: <20250907070022.2177974-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oaqfu8zx8y1xdzqf3xp3fqad1nmko4ri
X-Rspam-User: 
X-Rspamd-Queue-Id: 0609440011
X-Rspamd-Server: rspam01
X-HE-Tag: 1757228440-322264
X-HE-Meta: U2FsdGVkX1+9jfBMn+hmyCR8WpY3rOGkbxDhjjU7tF2aLuTJz+j5hZWzrkPch2e95pbIUwd4t8VERDzVNotIqAPwAjIpLIOaroKXPmQOCa6lPdeTRnFHIhlbP1cCcUqNQm9expvWYYAVUPf/uLCV5KTMzT49aG+eoVJsGns/eeRX/uWOKWTuAqDCuaYmUUwnMd6loqMoogKQDxe6rzkajKcHtEMifErQw3V7nvVUfU5VXs2vEMNqSBHST+8RCzVbvcwbgJ53DS0SlXjIh7RIszhN2X/RYMZd6K+sN8cd5Q8MENsEoW9CKoyWPiNF/r7PDCt4XV3eaJSuGnlIBL2rqlqJ/YfkfKWed21GJhw0qnA8QigxV0qDorAnakNY8vzryeFCuZkXsGFtlkGRN1cEbcINAqixSiWLwrUEUUeJ3enWGlqUCVl0TTIbhksJam9CUMEucw9PWfT0YdM73YGMDm3DSLJPrS5aTUZWDVoSy/om5Cn9ZEiJW3TSjM6v5EzQ7IZBLaomVnzUlaLGieJJS59jCyfzn7sXu5FcAbMqY5jbif8MwS/1IJAuijcnXPQMB25kgg+GMMyWma8047pC/upjNplP5FIHT/HWOJT0q7+QFbCqUEA+I2ijrpVzh6KcKiXpf5ptACJPYf/V1f5c54RPEIM+CYC9tyQnskb1TWorK5Rx3kzNE8WGJk/9MgQXEhKz0GDmyGQcuBiOZKt/JggudGtVy666Vd3p712oMAPdxh1gaYiyW1+lOAaCZ9OR+D9+KwaZB8UMV/n3Fak3615+39K0R2NmN1O/uR5dOPmJHa1ODLTCAXzkyo99lqGowdiV5DE6cnHoCsko9DY8feUsrUJc4/94CSNzycDC6J7U+6r/hN3IK5OpyOsCqQVPW+8GycXT2Aw+dileGTICxPutSPUPx21St0rG1BTnDfDwq18A7wS8gftgrKkzBkp6760i7WJEqGVgrGm2iXW
 SxGiYm3a
 qMG0cED0vIXUggKnd28uEToLwJbZQMXMJ5NFrYrZMW6zwRxfxqzW4fqoiivpXmPKXi1Po6HaHVkP1ERRdD7ZaSlr7+q7WcrNakUfK5J4RR4tOn4GFeUKsuIiH09SAyfqYiNRQw1LRj8NtN4tnQrcaN8NE4bVkjtvxQgR3EgeTmjzHYDzpRegILEGAlXW/oJZKFjYHMgpBFy44KcDPHeQwTspNzkIlbNMupf2kBRqA/IHOOPATuRuoed2pP8QTooV0BJKG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Hi,

Following the discussion about preservation of memfd with LUO [1] these
patches add support for preserving vmalloc allocations.

Any KHO uses case presumes that there's a data structure that lists
physical addresses of preserved folios (and potentially some additional
metadata). Allowing vmalloc preservations with KHO allows scalable
preservation of such data structures.

For instance, instead of allocating array describing preserved folios in
the fdt, memfd preservation can use vmalloc:

        preserved_folios = vmalloc_array(nr_folios, sizeof(*preserved_folios));
        memfd_luo_preserve_folios(preserved_folios, folios, nr_folios);
        kho_preserve_vmalloc(preserved_folios, &folios_info);

[1] https://lore.kernel.org/all/20250807014442.3829950-30-pasha.tatashin@soleen.com

v3 changes:
* rebase on mm-unstable

v2: https://lore.kernel.org/all/20250905131302.3595582-1-rppt@kernel.org
* support preservation of vmalloc backed by large pages
* add check for supported vmalloc flags and preserve the flags to be
  able to identify incompatible preservations
* don't use kho_preserve_phys()
* add kernel-doc

v1: https://lore.kernel.org/all/20250903063018.3346652-1-rppt@kernel.org

Mike Rapoport (Microsoft) (2):
  kho: add support for preserving vmalloc allocations
  lib/test_kho: use kho_preserve_vmalloc instead of storing addresses in fdt

 include/linux/kexec_handover.h |  12 ++
 kernel/kexec_handover.c        | 200 +++++++++++++++++++++++++++++++++
 lib/test_kho.c                 |  41 +++++--
 3 files changed, 241 insertions(+), 12 deletions(-)


base-commit: b024763926d2726978dff6588b81877d000159c1
-- 
2.50.1


