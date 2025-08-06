Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B59FC87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 05:41:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F3936B00A2; Wed,  6 Aug 2025 01:41:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CAE66B00A3; Wed,  6 Aug 2025 01:41:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 207816B00A4; Wed,  6 Aug 2025 01:41:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0F1FE6B00A2
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 01:41:10 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7C69B58B58
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 05:41:09 +0000 (UTC)
X-FDA: 83745234258.30.68C71D5
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf13.hostedemail.com (Postfix) with ESMTP id D970920006
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 05:41:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of liqiang01@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liqiang01@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754458867; a=rsa-sha256;
	cv=none;
	b=0FdAAfqIly4Fh7JVt0pJDCWoPBmRYJrc5KuJl/AtF3XGKAokOpuJxQ6Kjp0Jo333Wsxu8k
	MYwMNfMZUMu88Upj4JQqUQHC/7UwMGAtR4eAxj7/8Tvml4MNcl//dkNy9yhbf+JjPMhaxA
	2cGqDzth2cJUaXCp6P/BYd04Tt9Kb8M=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of liqiang01@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liqiang01@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754458867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RNrXQ4SK+A2T5fGIxwzVTbRE6c6F5YhjuBbfja9nRIQ=;
	b=Udy4JnXdVDpRkc99OMIVYhMKQtGjpi8qcKcjW16c7CyRPUo6ckTXIWUWkatYRPX/u2Kqdb
	Lhr58Rfemmtl6MW/uvGO14ndv42rk7oMUZcyHuVpODRp59j6XqnXP7+SRIvWDnZdTB/gLm
	aeVgmmH9ym7iend6zKXAZt3dUiKyrcU=
X-UUID: ec780c02728711f0b29709d653e92f7d-20250806
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:fe23d0c5-1d92-4def-99d8-9d1f4cb7171a,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6493067,CLOUDID:690d50016041c7436034199a39a039aa,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|50,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: ec780c02728711f0b29709d653e92f7d-20250806
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <liqiang01@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1259630706; Wed, 06 Aug 2025 13:40:56 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id D6217E008FA3;
	Wed,  6 Aug 2025 13:40:55 +0800 (CST)
X-ns-mid: postfix-6892EAE7-70206937
Received: from localhost.localdomain (unknown [10.42.12.14])
	by mail.kylinos.cn (NSMail) with ESMTPA id 90841E008FA2;
	Wed,  6 Aug 2025 13:40:54 +0800 (CST)
From: Li Qiang <liqiang01@kylinos.cn>
To: akpm@linux-foundation.org,
	david@redhat.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Subject: Re: [PATCH] mm: memory: Force-inline PTE/PMD zapping functions
Date: Wed,  6 Aug 2025 13:40:53 +0800
Message-Id: <20250806054053.1507456-1-liqiang01@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <a4491b54-4e08-4bcc-bcd3-3bae20a490b2@suse.cz>
References: <a4491b54-4e08-4bcc-bcd3-3bae20a490b2@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ujwoan3paqq1hjfj1kjenzpiirhgdu4x
X-Rspam-User: 
X-Rspamd-Queue-Id: D970920006
X-Rspamd-Server: rspam02
X-HE-Tag: 1754458865-711587
X-HE-Meta: U2FsdGVkX1+9WSEXrMNOrXlR2mdEHiFfYCGKf5x8NrvWUb95U52r9amRouqhMZf3qvBqnscpLFKEKIKMhgYW1Lvu2ftA08zpCM3Wkwn/M1Eqk3+oWhdP3msJo9v1rt9qvjCob/97mq79HnJrE8eGWVu7IzwHWvkp87Y/dgeNuIXBj2Yw0mG1Q6wna/mzuVzGShO2u55kMA9af8RZ7aen0Cg9EPqkokO3DJbnG2Ll05sSxzoM31QMyh1zXLcTte8MsFxefprIsrcGK4+hHKbh+vfPNksqcC6qlFve3fY07z/UtcQfEw6+UQTMZ+iR04XFC0hf1fC9QEu6bZSXSWaAASOovj5UO/civyRrp6H8wa2lQme2FVDIVr3WJo4sFSgc0b9TAKBRiYpDYr9cSyHbeTJI+OabsughMKP1z+p5Mrg5xkP1mogy7VTHBYujN+moRpRQf7TlSlmG4v+Uv21IpbStYMrZuT43GDLNm2yhDmTHXkifTKogc6+CkoW3lYT7POUnqm6nefMXkGBZpb0d2BaSdNWtYZeTt2zuJJiSQRKhMu3Rg8aigPTV4DnI1ggrjXbtK8GmklkD0iBNIug82w5PNzEvzZkJ6TQ4HghWe7GDT3+Y4cLtMG7SLDj+Sh+8gq5jnWmNseAnFmTrOONMGZZUDSGDNTLSGEpXSpgZIR0fhfmZ9zl08spioAZo44ZvwzH2Mn4gvcD/EHxWhNrAi2pYpMlnxnCSwvk4kRWC7KoKkwjjzyknoCU1gT9Ox22N9B8ALrWeWDvJaSTSwxn28sTkO5RfCtS01uaalsugwAJ6GuV06ytpc3inhxBycBraOSQSY3ioLXxLA5/RWnv5Caoegld39vUAJymC3yHoXa+6c+4gmVVe1NQW1zoxk+rlZktQT/2BPa75sdkxdpvDCkulC53mURgBUkDSi9vLvvclNkfpUhdyVL4THbQdNXtNaHsXYTGteBp2woKGoCX
 gfYRxOef
 8eDm11CjHhBadBwX6QCwI12hf+cCHrDNHal9wssUgwpDrLfg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/25 13:15 PM, Vlastimil Babka wrote:
> Is the before/after swapped here? This output suggests some functions
> became NOT inlined.
>=20
> If I'm right the output binary becomes slightly larger. But it doesn't
> matter.

Thank you for your careful review. You're absolutely right - the=20
before/after columns in my previous data table were accidentally=20
reversed. I've corrected this in the updated measurements below:

[root@localhost linux_old1]# ./scripts/bloat-o-meter  befor.vmlinux after=
.vmlinux=20
add/remove: 0/6 grow/shrink: 1/0 up/down: 4747/-4569 (178)
Function                                     old     new   delta
unmap_page_range                            1018    5765   +4747
__pfx_zap_pte_range                           16       -     -16
__pfx_zap_present_ptes.constprop              16       -     -16
__pfx_zap_pmd_range.isra                      16       -     -16
zap_pmd_range.isra                           589       -    -589
zap_pte_range                               1236       -   -1236
zap_present_ptes.constprop                  2696       -   -2696
Total: Before=3D35379608, After=3D35379786, chg +0.00%
[root@localhost linux_old1]#=20


