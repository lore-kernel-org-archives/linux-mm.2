Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C37C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 14:56:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2247190009D; Wed, 13 Aug 2025 10:56:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FC7B900088; Wed, 13 Aug 2025 10:56:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13A3D90009D; Wed, 13 Aug 2025 10:56:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F34F4900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 10:56:20 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 82859117350
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:56:20 +0000 (UTC)
X-FDA: 83772034920.27.B423DCD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id EFF4CC0010
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:56:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of chaitanyas.prakash@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=chaitanyas.prakash@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755096979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=CR8OJi3JXIri+XClYP7WQmxe44jd5Yrs5TLJ0dX0NZY=;
	b=RzMD23GaSoz66oIwzoiCjLTMPTuVGOzaF9/U59tlcyMhqI4Bh5b3tGU/+9ADa/iAjv/btb
	rwU5qOdzJiNrYhFt8Xbm0psBin22jXYKYsMBq2VrCG8hKqR/aK5iKfOPISCPLJefYBVWht
	7NURsl8w182DpIBY5udX+MiWtfEYvYk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of chaitanyas.prakash@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=chaitanyas.prakash@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755096979; a=rsa-sha256;
	cv=none;
	b=E394T6giwkOHRSfFQ8QabIgC6BjmbnAdpm0NTU2RaJCtnL6/52Zmd/Vq4vtaeSMqzklbTf
	4mN4URZuwq3La9Svj31AlQAZj6rGqObbN/4oRr5+H7/s4+f/nhfAB95APXNjJvNiVlC4kk
	MKkVS/uJfXP5k+6ej6bwK+D753431VU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AE2FE19F0;
	Wed, 13 Aug 2025 07:56:09 -0700 (PDT)
Received: from a079125.blr.arm.com (a079125.arm.com [10.164.21.37])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3B0EC3F738;
	Wed, 13 Aug 2025 07:56:13 -0700 (PDT)
From: Chaitanya S Prakash <chaitanyas.prakash@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Chaitanya S Prakash <chaitanyas.prakash@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Zhenhua Huang <quic_zhenhuah@quicinc.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH 0/2] arm64/mm: prevent panic on -ENOMEM in arch_add_memory() 
Date: Wed, 13 Aug 2025 20:26:05 +0530
Message-Id: <20250813145607.1612234-1-chaitanyas.prakash@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1sju66mgckj477y97qxp5huo5sz9dw7a
X-Rspam-User: 
X-Rspamd-Queue-Id: EFF4CC0010
X-Rspamd-Server: rspam01
X-HE-Tag: 1755096978-508736
X-HE-Meta: U2FsdGVkX1/pEYYmr0eEWmqDFgwIy1CrtKVywRq8BtQubGmXkPmm9OasNpJOHSUEsXJYnVuSatVWoTbSYLcshsJt53jSs+1AQmnyGLdhoiHLpjx7BhGsRJ8SLz9njToVddUB6cDfKSGMBeyVO1dwMKj/uXnD1tnFvN8jCulgNPt8+C9qWWQ46H0dgNSWfnGFmjDMaXz6vOwjD/940Xi1TYSKSq0YTkO8pK0Eqnw2bfSgLppBm8iFxPV3JDE0ggyLaIQzXh/4zpr2mMevvIwFQ9QDxMk+j5lQWtOxOk3nhnuIxgATzdnfJEauknv0qB7X5gdYi4DDRN8JSVrM+QXZ7WK8vkQq4YAGYzp+jeTVKVfrg4C9yBCEJKqgiaZfiypUq9CLN8swEg6gZLWAIUf/Z3flAkmpv4UUiQjoxpKC9yqZxKAe+eCBpLD2U4X8mb2hWzvzTDKYl4o3fp2nac2SksCcRUxMv95xJfTFGZL8IhX3ik369wy+DNTYazV3VnT8IdOM9s+9IllHX6CDHjnJ/AdktYyD0fRJUIwXFrEyPX8FqoZnHaR+W46JW4g4E2VjNUWCznq9h9NzqqnytNBbUGofiJWZbe8DJf07vu1qwDRRt1PN1beYlz5ujKs5gUmj79Ol7j5BTuuRTvS8bhTTzQqe1GQNNhZm+bF+9vCZ63qSCLoT4r+5lXFNWPypi0cv0DGFRzagQZ1njeK/tIamWtnit/eyqoUf5MBM4GQH56nJKukXU0ko+POKTP3ihSG/7ZEh6zX6iqTQQOB1BTZ6KdSrIvDQ9hUTZP7mmWhQuxjY5iA4CKijQFYl+5qlrUzmTUiSrRTXEG5/oqDJETbdLCzkD+/xxemxDvyPFdckNQdEM8B1OcoJL9b3YHlgzcS4wZXeBXV4Ww5S6FXKF/n2Slnu5re57kSq6zq2qDfnkFpeXyK3ZL1FDwQc1SKKozPUuGM6Sgz6/r8AazloGFp
 gA1ad1kY
 tKc1a7MbrASyM6MnZdOckxYwc23OX5Yh9fxEVtD/krAvCvrkBiKB3vbFONa46LRhGFdJi+N4WHrrHwNOfopTRch0cXrrlq8gjvXFWhsJNcQZQZwxNgT04GzYOW0Da08MalRoTiDAPNd+7X6Bt1Ss9FP3xMNwfEzAlmRjOO4cOSXlAXTmRcr489f0TOcJdAhzTtXVaFi0VII8hFukQdJue/2CAfblclAcS6O1nIB3wSzrfURQfTLLGiCkDoVI/yd9n64EFjCnZ0iaqCJ9Z+NEpColi1ZNIR/XHP8BTTFz8ykVsebFnO88R8buXAseINIP1xH8cZkj+4kAyk3LFRmtoggGcMtflCacauFOx/iqUolz1KTEJuvTDFyrrlgda9W4/V1cnfjhOt7C1N4dHCfRAevsxjlgw+pIvBnpqmKPt2wu87tYcQkFlnGmjQNPQXqCl7/QpP+2pmwa1mao3nmUOjnh94IYInAhHBeVt179KaUEEE6NRCMRVDTvdkTAujib+kkhQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

arch_add_memory() acts as a means to hotplug memory into a system. It
invokes __create_pgd_mapping() which further unwinds to call
pgtable_alloc(). Initially, this path was only invoked during early boot
and therefore it made sense to BUG_ON() in case pgtable_alloc() failed.
Now however, we risk running into a kernel crash if we try to hotplug
memory into a system that is already extremely tight on available
memory. This is undesirable and hence __create_pgd_mapping() and it's
helpers are reworked to be able to propagate the error from
pgtable_alloc() allowing the system to fail gracefully.

Keeping in mind that it is still essential to BUG_ON() if
pgtable_alloc() encounters failure at the time of boot, a wrapper is
created around __create_pgd_mapping() which is designed to BUG_ON() if
it encounters a non-zero return value. This wrapper is then invoked from
the init functions instead of __create_pgd_mapping(), thereby keeping the
original functionality intact.

Lastly, create_kpti_ng_temp_pgd() which originally acted as an alias for
the void returning __create_pgd_mapping_locked() has now been updated
accordingly to handle the return value and BUG_ON() if needed.

This theoretical bug was identified by Ryan Roberts<ryan.roberts@arm.com>
as a part of code review of the following series[1].

[1] https://lore.kernel.org/linux-arm-kernel/20250304222018.615808-4-yang@os.amperecomputing.com/

Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Kevin Brodsky <kevin.brodsky@arm.com> 
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Zhenhua Huang <quic_zhenhuah@quicinc.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Chaitanya S Prakash <chaitanyas.prakash@arm.com>
Cc: linux-arm-kernel@lists.infradead.org 
Cc: linux-kernel@vger.kernel.org

Chaitanya S Prakash (2):
  arm64/mm: Allow __create_pgd_mapping() to propagate pgtable_alloc()
    errors
  arm64/mm: Update create_kpti_ng_temp_pgd() to handle pgtable_alloc
    failure

 arch/arm64/mm/mmu.c | 174 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 133 insertions(+), 41 deletions(-)

-- 
2.34.1

