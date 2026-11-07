Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4367606D803
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 10:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c7xComwZ
Received: by kanga.kvack.org (Postfix)
	id 037B86B05B6; Sat,  7 Nov 2026 05:59:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00FB06B05B7; Sat,  7 Nov 2026 05:59:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6CF06B05B8; Sat,  7 Nov 2026 05:59:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C3E836B05B6
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 05:59:40 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5D682A02E2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 10:59:40 +0000 (UTC)
X-FDA: 85408027320.13.86DA2DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id BCDF540003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 10:59:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c7xComwZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794049178;
	b=aYS0CC4DvZS+NL8ZLoEe8kHL2Z3VW2qswvFL941zlmlqvTTAPL17MPvWjJkQzrigDkvzyt
	QdRxPAR2CffdtOGQk8rNMEzKJRd90M5IT4ZvZD0Qd4X5yo1fK9+IEQcv/5/le4wUDJh6sj
	3YJuDhk0+rQHVDy7ksB3YG6x4Z8XbHQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794049178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5TEXBm2KFRNPqnQrkYBN59qrTw89JkXgXnSB3fFl4n0=;
	b=AL7JZwvoYMhwXCe0VkAcVP8Xm42EKGt4HFmRfl3BJnvoBb4qOSwnjTz436HC3TeSljFE/c
	SwbmjC7XPwiWLQQbCsktfIQtvgsVFrCPiOk3YJb1N3D03JXrMlZvXf79rn+WJ1P4WnzFn5
	xBfKhk/Lh5HEytLaceAqXQhTVV+7Tk8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c7xComwZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C22340405;
	Sat,  7 Nov 2026 10:59:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A221F008A1;
	Sat,  7 Nov 2026 10:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794049177;
	bh=5TEXBm2KFRNPqnQrkYBN59qrTw89JkXgXnSB3fFl4n0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c7xComwZV6OF+So9zXFZTdI+3vnCbG6eJ02qEHBFKMB/0xcNNz25SjkLniWK32Ww+
	 Gxok6L4yb8fAp8Z/t86AOFgsE6gc7GYgn0M09D7vhEcM7apVz7tvLFH4DO4cHIkKXP
	 Erog5oZcms0xVIcPEa7MNQ/KYWD703jWQS25S+Vyh/RN0R11GXKjT/0IdumYg2qyRs
	 EcPCiZkJwM8nfpq34pQUotRGCBdmZ/hDY0tSxtMjirY2KUC5G7JdELheqAwgHSkgVX
	 TzguZpPybfcyrP/mHimdx7klbJtiQGnK4yfvag6xbybvpLSRfclwpKLaWCK9CdR/J2
	 PCN4aSo7QqZZA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Dave Young <ruirui.yang@linux.dev>,
	Jiri Bohac <jbohac@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	Usama Arif <usama.arif@linux.dev>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kdump: Give crashkernel CMA areas unique names
Date: Sat,  7 Nov 2026 12:59:23 +0200
Message-ID: <179404912276.1474561.4441607077586218375.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261106104309.3669583-1-zaslonko@linux.ibm.com>
References: <20261106104309.3669583-1-zaslonko@linux.ibm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BCDF540003
X-Rspamd-Server: rspam12
X-Stat-Signature: ubgjbwp6duxxb54cox5b8ae751ufqank
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1794049178-656177
X-HE-Meta: U2FsdGVkX19u6yXQiWIUmJMALRo96KG/rARtGPvXMLxfDJCOUcwvcuyvM290zW3iWrzeukSrtUjTEtLSa1dXUQNtp6ncHKiUCvMZXci/L5WvRYQua8oGUL3yMGBy28y2X2V4+znJv9MTkjVm/RKmnArhfwpkGOMT6ONPvEHctCFrciuLZBS7neeMb0GogRa5p9fdH/qksDv5SUQUjOPqrnpOyz4Ng6iHFS86A+QBEazAmoT8lYN2qhnpsb+hTaajpp2yF8QJsjvLdJIgbKuHwAsLBhGehMegYYhoimVJdWkoFAAo5/A/PWdxyoQBCTgbbpgTdn0lsFbj/ZxmJeosP8UaiXqGAK6V6A4I/4YtPVVyiNOo0oohWbK14pcZK8CEjKFffhY3ckRHI0nxIzI5ruDeZJ1k0Y6WSHsIvo5i1LYtGksGfbSNHTeMZBfNA0eVLPoXVHQ2obxIRQvPPZ1AwouMa2OmFyPMukdGY6IaTREgJFEqmqcclIcJvVRNv2UE/BpXqhSDPepKESbk9YvyEl+S+WyazLgWQMWqugFLab7KybQoI/msVN05L1q5zrNGlNq8oAiDlu+InvgjDo76ayAwl9t8rfE/7njt+VMY7rhi9XJqtBLclKxhP0y9GeibrNtCZ/KewRg1DJdZUt76HinuZXLk3OuAogephe5jiHMChGKlGlUh5FPiX9dv0zcOdxpqP768j50VKZKkk9pgBq7Wx5DIMYIA3JVEUjOOwpIIhjI0DdnmAgBcdr6//LdEeVvcSiX/CBj9qJAAmqSIRQT0tfR6cgq1uZdqp+m644p77rl3KAv5nn2l3bdD9ugv4aZVF/esjSyXWHjGgSEcug/HFyVDGO3jxKuxYqRDZIO3TKDshohhVVLUfK4FEu4a/826EF985fbFDnvZKtgsusTg0sWAin2dHSWe2gvCQsD5O9QxnYoWQxdV6iPYOOY6wINskoYl4eVOjo5sNSn
 96XB8oYG
 Pt3Lu7Yd0ubWOs2DJz1Ale73HwB7Bu63yLPJ43pVJwUUKRfmVqYHayAcFMzCGdPvfsOe5+QgH81hyy6todDRYbWtqSMO5whh0iYpV/55l7d7uuMSbKHV78FXoV4KZgJsocFqfDnS18mfASEJRKgCRLPepG5jSCFpGGjUlwu7wRYWfyeKlc++s7znX477IWewUoMWCB+2dRKrwvHnM+YCuliKhYY0aIBswh7YjtwW3WuQqAswTen3lH/sU7k1Tw8XQPwmCvRtw+xoiDjYOEiwJQv0NpOn8UCljQqGTVnnF5D1KQBi7f/jIEFDZkwq7dD964yPRRyJ2CNAPrGftRQd4/0ATGL3NHWJVcNKi+njXMPvAyLgIHeUaPWoOMpSpfbQN9ZM2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

On Fri, 06 Nov 2026 11:43:09 +0100, Mikhail Zaslonko wrote:
> reserve_crashkernel_cma() names every CMA area it reserves
> "crashkernel". If the requested size can't be reserved in one piece,
> it falls back to several smaller areas, all with the same name.
> With CONFIG_CMA_SYSFS, cma_sysfs_init() then fails to create the second
> directory:
> 
>   sysfs: cannot create duplicate filename '/kernel/mm/cma/crashkernel'
> 
> [...]

Applied to kexec-next branch of liveupdate/linux.git tree, thanks!

[1/1] kdump: Give crashkernel CMA areas unique names
      commit: 941aef93e9e1df74f0ef0fa8653c435613131243

tree: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux
branch: kexec-next

--
Sincerely yours,
Mike.


