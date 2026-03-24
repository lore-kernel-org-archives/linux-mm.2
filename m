Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4F2EF54AC1
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 14:31:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E69DE6B0089; Tue, 24 Mar 2026 10:31:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E40BE6B008C; Tue, 24 Mar 2026 10:31:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D57356B0092; Tue, 24 Mar 2026 10:31:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C496F6B0089
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:31:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 222D1B5042
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:31:29 +0000 (UTC)
X-FDA: 84581194698.04.7B699FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5684C1C0010
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:31:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="j/iVyRqo";
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774362687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pY+i8+xQCFc5PDeHGmx/cfYhF1ynFikjFRl2TZ/8zZY=;
	b=KMShpNz0f38XfX35nB0C4a4PUMPLoD6HLaOGS7i18PnlgHG0CLIFAxdDUbkRhWWLdbP0TG
	tRx9cw5gG6IR/717e9jG8MaNY6fscilT/O84sm6h41MO0Pwb/iyIrmi6CzsiOgI+luzWcz
	PXu5Wrt3QiyayuaYqAq/3LdDZOmeHfU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="j/iVyRqo";
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774362687; a=rsa-sha256;
	cv=none;
	b=g4eWTYznluTd2KU3xfjgNVZmE1C+gYc2DS7NabmVSjUD2kI3hibyyVgKABmNMehVFSJzHZ
	xnB6j+yG6UDQE8NkSGE+wjYemf2P54DCeSiI6RZNDiY+4vg0EdP6IjGu83N+6mK+ZdVSiY
	S3JbIkmui9ES+bDAE21hFR4Hip8iww0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A1F53600AC;
	Tue, 24 Mar 2026 14:31:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DCDC19424;
	Tue, 24 Mar 2026 14:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774362686;
	bh=0oYopjVJ5FfZx7yBJY5biK1wFueGF1ISoTXTBTdvEco=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=j/iVyRqoAgsG15GdgKyoiArd2eFqRcIl7DXzGaGTtG2Y0o7o+tjV70May3h7h7RLT
	 V7S2RptNUFiSvB3YL9Arvd1/5pUSBJrsV385XLYdp8ncPFclpr5NciQAWxqxmbnEiV
	 oGusSnopYimqq5x+nEGLkPHfJfSrph+4t9ZTsmakMF24m+DuJZinF+HwwBv0F6oXfj
	 8Ajb3LcvpJ0geiSO23cTGq4R54D5xwU781bHvtDBiy0/W+L+jGnt1gku6YsbTLI6qO
	 tBqw5ZSz29d6y6/PZPYtjCgDpggJ+d1BrWbTeduVQTASS9C9lGiBuYSSdwtQJAyER5
	 Iy/3msdCCKs7A==
Message-ID: <82dc0ffb-a0e2-4358-b182-94af71ceb697@kernel.org>
Date: Tue, 24 Mar 2026 15:31:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/21] mm/vma: remove superfluous
 map->hold_file_rmap_lock
Content-Language: en-US
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "K . Y . Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
 Bodo Stroesser <bostroesser@gmail.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
 linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 Ryan Roberts <ryan.roberts@arm.com>
References: <cover.1774045440.git.ljs@kernel.org>
 <42c3fbb701e361a17193ecda0d2dabcc326288a5.1774045440.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <42c3fbb701e361a17193ecda0d2dabcc326288a5.1774045440.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: su1gy6wzduzsscqpigprkd6wee59h357
X-Rspamd-Queue-Id: 5684C1C0010
X-Rspamd-Server: rspam09
X-HE-Tag: 1774362687-39960
X-HE-Meta: U2FsdGVkX18Rn6O95XbBFuM+3x3epI6pbhRUstefVgpq/6uFhpYNm38PKOQVYXNJ2Yedf23xyarcHyFT3q2lcnSNatX2fOj9GQUD2Mhc3T80XIBIITezUOgQkZjL7RuVjRfn3K0vlaN8m7FG0Uyk3GL08IQPOcX/C0cKkW/db5ols0uYbGHV7ZO6J7xK7YHNHb2Xt2wL9NH1Jl/YuuP37a6pUer2SA+0NkdwwKy8bqm50SRuGW4EDA5kCojQbXttEq+nTAO17YDo7RkwYc3dxZjZ7cGEAjmeauPHoaERbZxsCXVo26HmmKIloQK081URf3ds4RkU+lJVAJWuYpkmkgDW9cdQ1b3YENOCB39fnwwsOV41y1OzgCOdXpD4tm5gCi38BUYHW4ELBkteo1WKQ6a5uY5n38WMRj1pE+toIaezX/AZ9qe2FWHsaKnaI5DoBhFjbkjLem+hRzftoxweAOcAnr15U04dsnBaRT2EF0lw3hcZL6+5bRAP0alaWZX2WuQb14UNdZAo2yNeVxKZf6s/nXA7hSbkvk/O2OW0A9XkgEsHKc2qKHMwHmXXbXhuYSaqBPcQxqdw+f9gxME2TKszZY7sseL4ar+NIfox7roJKgWZeQUMeztXcIyR62zaxNy6Zc/3dd7MxM6XljWUPfZ0AEINwufpkzqwHiFtck0hRbNZ/Ca1zTyC3sfIpw5Qh1955gpr/5ukS+4kHhn2oISSGDBRKpu5TYX9ak77VHR9mpUT4IFcicQTgkN6AJ1JjN2a43PkWfCWQJJKBcZLy1V6J8q8uv0t7va9OA84YjwPB611/uhIeJHj/nGKeBytRewcAaUVO8Wo+GG7VkM/B34JheTV2rie7OV4fV/6kBIDkBGXhp59+le0qo6AelR5xPX+5pwGUcYGjdYyWt1LJ9aj4T3J8bpkpe5OoFllu1ImaWVrxWs1ILE+LrXIchNPb6dYGUy1UgNXNfjnvIB
 HxLAgTGq
 uQxVY9LOr7FH9JLD2o7N7MKCuhJnhyr/4rdLuvpsF0nE/SYDRdFaeUjiKEbBQKZO78PevUZkmMQ9cl6OUiZzjuLRZz3d9C+z0Ja6VWt04irNwgX423fXpjfhBv7SK3Ve+ev6Fp0oUCylT3i5OGxnX0mqRj2sbaHUR9Y0DB5S7fTrOfPu19dOI0n/Yd2Usbq4vTm7rzfIu+kM7l9izgQ3YpIMgVaqqcYoB0zKFPAlIjDSPHE+8nPjhIzycUXb9G/mOWUe/4J9WdiVoWGDVlLW7VGdy2Q9vR81ZAOAU3Th2HgmihpnaDTx5DbqEb/zTt3gMoDQC4wa5xZup/aS2lFtiqiWLt7x0deHkMrM/PDte6JulpGtGRTUWi9dWOv/Qr2zyl+9zTUvd/I79657UtJvizBPddg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 23:39, Lorenzo Stoakes (Oracle) wrote:
> We don't need to reference this field, it's confusing as it duplicates
> mmap_action->hide_from_rmap_until_complete, so thread the mmap_action
> through to __mmap_new_vma() instead and use the same field consistently.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


