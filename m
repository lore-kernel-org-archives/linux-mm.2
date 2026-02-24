Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21A35EFB818
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 08:38:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 426386B0088; Tue, 24 Feb 2026 03:38:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C9B16B008A; Tue, 24 Feb 2026 03:38:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B64C6B008C; Tue, 24 Feb 2026 03:38:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 167496B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 03:38:41 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8715F8BA5B
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:38:40 +0000 (UTC)
X-FDA: 84478699200.11.D79EAD9
Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	by imf06.hostedemail.com (Postfix) with ESMTP id CD114180002
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:38:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=w6rz.net header.s=default header.b=QyGDhfmd;
	spf=pass (imf06.hostedemail.com: domain of re@w6rz.net designates 35.89.44.37 as permitted sender) smtp.mailfrom=re@w6rz.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771922317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OQlmPat5vODZcMekhvrzC3F3DNNMoFwwYGwvlTT3A4k=;
	b=dGu0U2gzIC0Dak2BtzIQiHVnIxH2w2IY2jV4cqb+q/pkHVL1VQSq5DW/AIa3AkTtr3yG5N
	9BChqx9WgE934W9k636r3bfYrekhI0Fa5SSBeaRUFVYGuS9W56FzmOQiXvyAUKToOjjsur
	OQMrfBx/Nc1hYXXuqoxE2gIRmQj2pB8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771922317; a=rsa-sha256;
	cv=none;
	b=xVyL+AQCghZ3Mz8ODd2iwVvJeV9rb51MVGtgYP5fzbAea9K2oJGB3MfgG8RDPXrdkyzMyU
	LuNfMVuDBPD3d5m9If5xJ0I7P/2kB9A0lXUw/fGrgbW4TLx4RctiOET2IS7VW6z3hUNjkZ
	cDmJmTLqxWXahR7X24fIeokJULzeu+A=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=w6rz.net header.s=default header.b=QyGDhfmd;
	spf=pass (imf06.hostedemail.com: domain of re@w6rz.net designates 35.89.44.37 as permitted sender) smtp.mailfrom=re@w6rz.net;
	dmarc=none
Received: from eig-obgw-5001b.ext.cloudfilter.net ([10.0.29.181])
	by cmsmtp with ESMTPS
	id ud2GvBqIPipkCunujvWPSx; Tue, 24 Feb 2026 08:37:05 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id unuhvfAmUSqlVunuivmoW4; Tue, 24 Feb 2026 08:37:04 +0000
X-Authority-Analysis: v=2.4 cv=I7FlRMgg c=1 sm=1 tr=0 ts=699d6331
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=fXqMav8GDGqUIRHTLxgA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:Cc:To:Subject:From:
	MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=OQlmPat5vODZcMekhvrzC3F3DNNMoFwwYGwvlTT3A4k=; b=QyGDhfmdE2Q/i5RuXLZlVfHoYi
	YTFBup6shNXTkBdnz9zvECke+jX7tyxq0AeRqZA8NkpDrdodSUpq4RU6COiJAn83J3o744fECubo8
	vg7JQcJ7kKFxq7T/NQH6E1lF06Weorv1emWwMKICJ/sROy2WU1DZXdeSFPqHTtM4UbtRYYxGeTY1i
	hc9fg9oPXM+Ufavb9YvZR5ahnDClUvrQ9rV9cW/6JAPZKe2RDJQZJIBBt+Jm88+EV4KKHRECiZusu
	x01HkfQ0vS3gFQWcFoqkIZV9YhLdXV2YmLUmeAFKGrvlbFOA2dhLBKuDOBIKk82rDpQ0mCsmLT1Ud
	Uw+e3TWA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:50818 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vunuh-000000048SZ-2Ff3;
	Tue, 24 Feb 2026 01:37:03 -0700
Message-ID: <1b17c38f-30d3-4bb4-a7e1-e74b19ada885@w6rz.net>
Date: Tue, 24 Feb 2026 00:37:01 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
Subject: mm: Regression with v7.0-rc1 on RISC-V
To: wangkefeng.wang@huawei.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Cc: ziy@nvidia.com, jackmanb@google.com, david@redhat.com,
 jane.chu@oracle.com, hannes@cmpxchg.org, willy@infradead.org,
 muchun.song@linux.dev, osalvador@suse.de, sidhartha.kumar@oracle.com,
 vbabka@suse.cz, claudiu.beznea.uj@bp.renesas.com,
 Mark Brown <broonie@kernel.org>, akpm@linux-foundation.org, pjw@kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - kvack.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.162.206.103
X-Source-L: No
X-Exim-ID: 1vunuh-000000048SZ-2Ff3
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:50818
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfDkWfd/gD4JvflUMqeFYQw6Jbkx7EQh4KazWnfLP3OF7QF2arlZOJa9IJqEt6i+0Zct/7EEgYu1hDGfDpXryjD9S0YyIMWo3e35NF8CUb3RilN0O5y2R
 VjYLDpVPYqJMdET70AU1hzihTasuZODPVBc8EJNmQl70FhVRPZtdxA437XqNgagxXnkwx8T7mbSQow==
X-Rspamd-Server: rspam09
X-Stat-Signature: 3huk4tm43fuywjqizqccfpru46acuzho
X-Rspamd-Queue-Id: CD114180002
X-Rspam-User: 
X-HE-Tag: 1771922316-521478
X-HE-Meta: U2FsdGVkX1/Qudfm+BHTL+HxbEAnt66SCWdTqceVxEmM8eyxp/bi9mJBJ2m2UnAX8+8ACKkJrE5MGCJWEPmdoiPP9mZ56XUHaTryeBtJXB1YqfYM7AWuWJIwcFHCuXvaYc/pikrgMQmnrV7poLfUm6oAJ0za6Ez3aywlxaFVY5QYjgPlecuVVIROg/y3xuJe16xznd+8SNI9VjRhrcrg0ypejyQB6KAe531xJZqYpXPL5PcrUSVk9Qnknu1wbYuPOWgJWKHS5RmxDC8wPrsBG6htpw832HWlnqWE7JVbksxlNNxkpa4trQGV14tzoQG2QI2LFWqu5m5+AIt7YyMw62nFnoHjDfQjPcye36wtzBzHB/NjmozsnwnTOoY2DrHVA1J8x7u0sJ8c9AZ1ePPkwyO9itthY/GrQ/nehrKxWV+D4i1IUX578Q6a/SQioSWqjHTotY+PKOCmWt2ukgVxndh/Xnq5StizamfPDZuz8akz3Ah3PhSx2BPQdkMSsNUmEPblk7nrRJbhW9I46HwxGqS1eRAbdpgmZBblxfltwUi35/7WEpSTBLE+2haEqxJI3wAkLgzrUd1kzCZj3MjF/9Ev/y9du9zN1dAp+MBiK9wVTTCbupqjpMGGbCmo8d115EYD4zE+OZ1t9XpCzs7WIwKNNZkXsExu+lYwt0Im8uEuVUkxnehbMgTV0cO58fZ1Dah91qBsl0JWSPrerHoabHWQ+F2fJl7ghf3m7VRvB61ywKby1Rt/Ip57tM6LPYXl71jj/mbc01R8469kvKq70Ot8Uw5soYJHHsr/k+lQSAbNyNsY1syb4wJnJkvFJKCMFDE1osMP917qllDjf/3ac56eRqpzSMDHKqCBOtNOjXC0gZjBBBqxllXa5toZVxoLPA6+M1dNbQkUNZqT+AVEVwAofMLe7q+XTsoXwm+mIcsxx4GZTgy7lMX+2Frvvh/I1RfrmpOrosI4VevW80j
 vYxeBVFA
 oygwPpgH7YU3jokhqZdksr41R11szNa5Ow5EL6IGN+erBk3yBaf1YZ6nxgboa5b1dX50bwpxKLShWZj7w1mgTqRGxHlAhb2XyHhA4qQB92vLsvmrBig119u82yXy/uUOBp5AF3wj7krNiPH3oTLD266ATadz7OGTi6x4uEy/jG2jJN/omzh47B/+5ygYHhF4ZsbJqEDp4HkSHj2+vgGYi3Dq9LhjWNglXrgV1VGmHehdY7QhCKnYqx5whKfDpJTRNolRmTJ04n2RK9q5wtvHlEtmufjQahFviBk6nD6Qo92eqyYK36ti7aH3VXuG+a71sXOHojzjNTYMkC7cNK/XX8/HPNijBHGzCUjxfBLpKZ7aQiTOZmgWgb7Yrzf8cb3Lfp4174l4IxHOC3enstprQUH++kXYJwnFoYGEljCmfv9whwjXaFZWK/55uL43jl6BPbMOIjPUshBLMDUrL1eABmHZmwg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I'm getting a BUG dump during shutdown with Linux v7.0-rc1 on RISC-V.

[  OK  ] Reached target shutdown.target - System Shutdown.
[  OK  ] Reached target final.target - Late Shutdown Services.
[  OK  ] Finished systemd-reboot.service - System Reboot.
[  OK  ] Reached target reboot.target - System Reboot.
[  173.985249] BUG: Bad page state in process shutdown  pfn:f8850
[  173.985311] page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0xf8850
[  173.985336] flags: 0xffff80000000000(node=0|zone=0|lastcpupid=0x1ffff) CMA
[  173.985365] raw: 0ffff80000000000 ffffffc501e21448 ffffffc600f2ae88 0000000000000000
[  173.985386] raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
[  173.985403] page dumped because: nonzero _refcount
[  173.985418] Modules linked in: qrtr cfg80211 da9063_onkey binfmt_misc at24 lm90 nls_iso8859_1 pwm_fan sch_fq_codel dm_multipath 
nvme_fabrics efi_pstore nfsd auth_rpcgss nfs_acl lockd grace sunrpc nfnetlink autofs4 btrfs libblake2b raid10 raid456 
async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 raid0 linear mmc_spi crc7 of_mmc_spi rtc_da9063 
crc_itu_t da9063_regulator mscc nvme macsec phy_package nvme_core nvme_keyring nvme_auth hkdf macb phylink spi_sifive i2c_ocores
[  173.985802] CPU: 3 UID: 0 PID: 1 Comm: shutdown Not tainted 7.0.0-rc1 #2 PREEMPT(full)
[  173.985814] Hardware name: SiFive HiFive Unmatched A00 (DT)
[  173.985820] Call Trace:
[  173.985827] [<ffffffff8001bfd4>] dump_backtrace+0x1c/0x30
[  173.985850] [<ffffffff80002522>] show_stack+0x2a/0x3c
[  173.985861] [<ffffffff8001395e>] dump_stack_lvl+0x46/0x6c
[  173.985877] [<ffffffff80013998>] dump_stack+0x14/0x1e
[  173.985886] [<ffffffff80317fe4>] bad_page+0x12c/0x170
[  173.985905] [<ffffffff8031bb14>] __free_frozen_pages+0x634/0x830
[  173.985919] [<ffffffff8031bd88>] __free_contig_frozen_range+0x78/0xe8
[  173.985929] [<ffffffff8031bec0>] free_contig_frozen_range+0xc8/0x1e8
[  173.985940] [<ffffffff803a15a0>] __cma_release_frozen+0x60/0x1c8
[  173.985959] [<ffffffff803a27c6>] cma_release+0x26/0x40
[  173.985969] [<ffffffff800fcf96>] dma_free_contiguous+0xde/0x178
[  173.985981] [<ffffffff800fbba4>] dma_direct_free+0x104/0x198
[  173.985990] [<ffffffff800fa19e>] dma_free_attrs+0x66/0x1e8
[  173.986002] [<ffffffff028780ec>] macb_free_consistent+0xbc/0x160 [macb]
[  173.986132] [<ffffffff02878274>] macb_close+0xe4/0x120 [macb]
[  173.986169] [<ffffffff80cae9fe>] __dev_close_many+0xa6/0x1d0
[  173.986184] [<ffffffff80caeb94>] netif_close_many+0x6c/0x118
[  173.986193] [<ffffffff80caec98>] netif_close+0x58/0x70
[  173.986201] [<ffffffff80cbab84>] dev_close+0x6c/0x98
[  173.986216] [<ffffffff02874518>] macb_shutdown+0x48/0x68 [macb]
[  173.986254] [<ffffffff809bc9c6>] platform_shutdown+0x16/0x30
[  173.986277] [<ffffffff809b7126>] device_shutdown+0x11e/0x208
[  173.986287] [<ffffffff80070f26>] kernel_restart+0x36/0x98
[  173.986304] [<ffffffff80071276>] __do_sys_reboot+0x14e/0x230
[  173.986314] [<ffffffff8007136e>] __riscv_sys_reboot+0x16/0x28
[  173.986324] [<ffffffff80f26d6a>] do_trap_ecall_u+0x1aa/0x578
[  173.986339] [<ffffffff80f37c58>] handle_exception+0x168/0x174
[  173.986359] Disabling lock debugging due to kernel taint

I've bisected it to commit "mm: cma: add cma_alloc_frozen{_compound}()" 9bda131c6093e9c4a8739e2eeb65ba4d5fbefc2f

Here's the bisect log.

git bisect start
# status: waiting for both good and bad commits
# bad: [cee73b1e840c154f64ace682cb477c1ae2e29cc4] Merge tag 'riscv-for-linus-7.0-mw1' of 
git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux
git bisect bad cee73b1e840c154f64ace682cb477c1ae2e29cc4
# status: waiting for good commit(s), bad commit known
# good: [8383522821c6fea6bbb4bc0317056c433a482a95] Merge branch 'net-mscc-ocelot-fix-missing-lock-in-ocelot_port_xmit'
git bisect good 8383522821c6fea6bbb4bc0317056c433a482a95
# good: [37a93dd5c49b5fda807fd204edf2547c3493319c] Merge tag 'net-next-7.0' of 
git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next
git bisect good 37a93dd5c49b5fda807fd204edf2547c3493319c
# bad: [4cff5c05e076d2ee4e34122aa956b84a2eaac587] Merge tag 'mm-stable-2026-02-11-19-22' of 
git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
git bisect bad 4cff5c05e076d2ee4e34122aa956b84a2eaac587
# bad: [fde8353121aa304ee88542f011dd5dc83ced47e4] selftests/mm: report SKIP in pfnmap if a check fails
git bisect bad fde8353121aa304ee88542f011dd5dc83ced47e4
# good: [743758ccf8bede3e7c38f3f7d3f5131aa0a7b4a6] Revert "mm/hugetlb: deal with multiple calls to hugetlb_bootmem_alloc"
git bisect good 743758ccf8bede3e7c38f3f7d3f5131aa0a7b4a6
# bad: [2f5e576598c915db18b7ccd0003be52458959ce7] powerpc/mm: implement *_user_accessible_page() for ptes
git bisect bad 2f5e576598c915db18b7ccd0003be52458959ce7
# good: [6c08cc64d194dc5cc3dfc785517098d3b161c05f] mm: cma: kill cma_pages_valid()
git bisect good 6c08cc64d194dc5cc3dfc785517098d3b161c05f
# bad: [4bdd692291275eaaabe993e1c4a7b5b01cd6dc37] mm/damon/lru_sort: add monitoring intervals auto-tuning parameter
git bisect bad 4bdd692291275eaaabe993e1c4a7b5b01cd6dc37
# bad: [fbec8a1e4fa4daf2611c9a3e3b29d03a73acbd0c] mm/damon/sysfs-schemes: support DAMOS_QUOTA_[IN]ACTIVE_MEM_BP
git bisect bad fbec8a1e4fa4daf2611c9a3e3b29d03a73acbd0c
# bad: [14f270761d3374db24c84630f2aa7a3c732fed4a] mm: hugetlb: allocate frozen pages for gigantic allocation
git bisect bad 14f270761d3374db24c84630f2aa7a3c732fed4a
# bad: [9bda131c6093e9c4a8739e2eeb65ba4d5fbefc2f] mm: cma: add cma_alloc_frozen{_compound}()
git bisect bad 9bda131c6093e9c4a8739e2eeb65ba4d5fbefc2f
# good: [e0c1326779cc1b8e3a9e30ae273b89202ed4c82c] mm: page_alloc: add alloc_contig_frozen_{range,pages}()
git bisect good e0c1326779cc1b8e3a9e30ae273b89202ed4c82c
# first bad commit: [9bda131c6093e9c4a8739e2eeb65ba4d5fbefc2f] mm: cma: add cma_alloc_frozen{_compound}()

It doesn't revert cleanly, so I couldn't try that.


