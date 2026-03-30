Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2D3FFF4934
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 02:59:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CD726B0096; Sun, 29 Mar 2026 22:59:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A50C6B0098; Sun, 29 Mar 2026 22:59:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BAA66B0099; Sun, 29 Mar 2026 22:59:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EBF686B0096
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 22:59:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 65F938C1BD
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 02:59:24 +0000 (UTC)
X-FDA: 84601223448.18.96ACB0A
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf18.hostedemail.com (Postfix) with ESMTP id 650A21C0005
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 02:59:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774839562; a=rsa-sha256;
	cv=none;
	b=6UtaxaOpYnjn2PzO88I17+EEJAvZal8tkU8GkETAF9xXwBhqMHmsQxEhyU/MJOS9IDrELf
	BBUqKysbPRqB4QRBfXlgOltrifuJc7/d86kFu7moKm1fmR3UNvRM1YRu+tnTv6SickFrco
	GJhzoMXgHelsz91tLJBZi2i9Xrgek2Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774839562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XWhnsWOKd6Tr/4jzFvVHSnV4VbGJKWxcDGLqzwmPqOU=;
	b=blpBf6koENJdCZ7x7iaRfj2VGcsFAR6dbSDez3QUv4V7nb+gQ/W0AOhycMWqfTKMBJqtki
	cWeTplSoYyz0nz9SI1ZNemO7BrMtAyqhKU+ojWL5VnwQ/GTLk7/6ovZqNuA8IqoIgAJCNY
	NxygqrwBBQiztsCYlrzD8npP/++jSrc=
X-AuditID: a67dfc5b-c2dff70000001609-10-69c9e705e243
From: Rakie Kim <rakie.kim@sk.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: akpm@linux-foundation.org,
	gourry@gourry.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	dave@stgolabs.net,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	harry.yoo@oracle.com,
	kernel_team@skhynix.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	Keith Busch <kbusch@kernel.org>,
	Rakie Kim <rakie.kim@sk.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>
Subject: Re: [LSF/MM/BPF TOPIC] [RFC PATCH 0/4] mm/mempolicy: introduce socket-aware weighted interleave
Date: Mon, 30 Mar 2026 11:59:11 +0900
Message-ID: <20260330025914.361-1-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <66c7fa22-5980-45cb-b1d4-94446231a6d0@intel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYRjHeXfOzjkOh6dp+TYjYZVikPfoDbpIUJ6PhhLdIIee2sE5ZZs6
	RUnxgpdaZpq1iU4Cr6PZ8pJiLWU5Z4Ij0XSgVrrE0EgLMyvMaYLffvyf3/95PjwUJhrCxRSn
	ULNKhVQuIQS4YMmz/hh/3s6F/hwKRDUmI4GmZh0E6pmIQ9VVDoAGJ/MI1DppBGi+Yx2gX1M2
	Es00fMaRxTWPo5b6cQLZOmpJVNE/DlBX7gcSjeiGcDTaU0OgaeMGH9l1zTha1fqhGW0Uspq6
	eOjBOwOB9HlagJzlAzzUapQh/ZtpMkrMdOumSMZgTmPKikZJpsC6xGee9C7wGHNLCcGYVypI
	ZvDRb5zp/niSuZv/lWCWXU6cqdLfZkztYzgzbLCSzHfzwRivq4JTiaycS2eVIWfiBbJvtYtY
	avE5TbP+OZYLTAGlwIOCdCQsbZzi73Dn6zpQCiiKoCVw4OV1d+xDH4EzplmiFAgojC4m4EJJ
	z5bvTctgeeMG5mZ8UyqprdzKhXQEnPvk/L8zCD595sTd7EGfhs4+PelmEe0Jv7RZwLa/B9of
	z205GO0P8zv0mPsYpAspuG5e420v2g/7mibwcuCl29XR7eoYAK8FiDhFerKUk0cGyzIVnCY4
	ISXZDDY/3JDz59oLsOKI7Qc0BSSewlDCzon40nRVZnI/gBQm8RGWVQ9wImGiNDOLVabcUKbJ
	WVU/8KNwia8wfDUjUUTfkqrZJJZNZZU7Ux7lIc4FrP/FjYK2A2UXCmP3LYph9nLd2wwhP6Cs
	yabuteREK28Szjhr0uD7va6YtbAT5ZfsD7PyNJbs5LTjRYZhRb1BFSEJVL+yjTqudF7Ospyf
	ETZzGSHBmoRhbU2QE1OO+QR7s7pwRXb7vb+H5uLv3LdEo7Oxh30bRl1g5FJl1w8JrpJJw45i
	SpX0H5VVqkbdAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02Re0hTYRiH+XbOzjnOLY5T8KSIMEizi1kZfWEXqaCPiJBSojJ05ckdnFM2
	FZUsLxFe0sw0bTNdCOZlNl1NcyTm8ra0lETL5a28ZRfRDCGNzCmB//14nof3n5fCxG24C8Up
	YlilQiqXEAJcUOQZvJM/beF89I0iWKzXEXB4vJeApg+B8G2+hoCFBb0Adg6mELB6UAfgtHEJ
	wN/DHSQcLZ/C4cLUNww2T07jsOrRAAE7jCUkzDMPAPjqoYUPG5LHSNijfo3DPlMxAUd0K3xo
	UVficDHHFY7m+EPzwDQftuobePDeOy0BNSk5AFpz23mwWieDy/UVq6hthPR3R43qYRJpDbEo
	61YfiW62/uCjshczPGSoyiCQ4WceiTqLlnHU+OkAyk6bJdD8pBVHix8RKvsyx0MFmhtI/6wf
	R93aVjLA4YLgYBgr5+JY5a7DoQLZXMl3LDr9aHyl5imWDPQemcCOYmhfpv5lKcgEFEXQEqa9
	KdiGnegtzKh+nMgEAgqj0wlmJsPEtwlHWsbkPl7BbBtfjTJK8te4iN7LTHy28tdvejFP6qy4
	bdvRhxhri4a0bTEtZL7WNoP13oGxPJhYazDanUkzarBcIFRvUOoNSgt4VcCJU8RFSjn5Pm9V
	hCxBwcV7X4mKNIDV55Yn/bn7HPzqO2EGNAUkQpEPYeHEfGmcKiHSDBgKkziJsgrbObEoTJqQ
	yCqjQpSxclZlBq4ULnEWnTzHhorpcGkMG8Gy0azyv+VRdi7JgO2aAkPOd87X1XSHl9VV2hcr
	xtLGhqoTO0tproWe75kdP+s43BNsij2lubRo6nIKikkt8TqmXW6qvfpXo++397sekC3qvJ1y
	/0hbuWdEfVKFW279yPvjhjPGaws1ymW3nssy8dbAfN8aj+1BO+rs9/uNpi4JJ0P2vNl6MW+T
	dfNpCa6SSXdvw5Qq6T9+TUmD2AIAAA==
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 650A21C0005
X-Stat-Signature: 9ece5iafm8gxkty8pkd6c79iq3e3xhhn
X-Rspam-User: 
X-HE-Tag: 1774839560-932358
X-HE-Meta: U2FsdGVkX1+uo/l/nN7ncPiTROeesQo327hypD62RCKqAmUvs/mTrR7z+mByU3tEodyfcFyEPuPsBXw+Lrvso+7EE7Ec8SQ9dmqWydwQtzQ5mHB5D6IxjhifimOw/g7WdyGtY5H+3ttWTsrVm9ALOsY1Y5xdzmxA8hktwZLUuJYuZCdBQ/oD2yE7oAXZkumg2ds0fHO6DxVklvusBu35Pp8LI3AQ99rSi77opSjDnxJCDKWGkvOvB/BjXaQC11KQDqX+0N66p4DXjzVIwLg5+IkS0uujZf9fj3mM1BJEn3QogYWlGPi8lb3ho0jFy5vTJ8dRX7Ah+QJHs1i32kBzyPaUmPHTBvfLhp5w9rGeB028hmpeJbJ8kChVGallPE+x0fqpVQHprx5eU5+HHXZcTc3ssp2YYYT00wpiLWKq3lqtzCvIuqdgMCvwwrGn2KTnyVigAoun5Ar9vc97T57j6tHFG88iseQO85/5+cPL8F69heuJnCJn9AWBEtYfFS7JgHJhrgprXDg/HykEIzv3OuKZfeb16jhZNlutptOr4MYIJyZBOMmNqC0XXb8B9OmXTrPO0z1p2u2ceOMslEEwxpR0NiEq4QokgMjjx6cRJ2Bb5mj1NDazIsihqXR2rsN5JezGVmkSrNnn+9NipryRPkCZg+xXlAnrBHOgcU70SHpBv4vGVSnpI59sNTbaqe1ycyrcD00vO/gH5SUAr4GsxTX+z8I5a7DoYGycue/JFUNLqzWlmQbGjNfgJU9LOFJLQkNhB/INiBPVLjKAB0uHGIZ8ytlExUuc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 15:24:26 -0700 Dave Jiang <dave.jiang@intel.com> wrote:
> 
> 
> On 3/23/26 10:35 PM, Rakie Kim wrote:
> > On Fri, 20 Mar 2026 16:56:05 +0000 Jonathan Cameron <jonathan.cameron@huawei.com> wrote:
> >>
> < --snip-- >
> 
> > 
> > The HMAT latencies and bandwidths are present, but the values seem
> > broken. Here is the latency table:
> > 
> > Init->Target | node0 | node1 | node2 | node3
> > node0        | 0x38B | 0x89F | 0x9C4 | 0x3AFC
> > node1        | 0x89F | 0x38B | 0x3AFC| 0x4268
> 
> Do you have the iasl -d outputs of the SRAT and the HMAT somewhere we can look at?
> 
> DJ
> 

Hello Dave,

Posting the entire ACPI dump would be too long for the list.
Instead, I have extracted the relevant structures from the `iasl -d`
output for the local memory (PXM 0, 1) and CXL memory nodes (PXM A, B).

Here is the truncated `HMAT.dsl` showing the core topology mappings
and the latency matrix we are discussing:

----------------------------------------------------------------------
[000h 0000   4]                    Signature : "HMAT"    [Heterogeneous Memory Attributes Table]
[004h 0004   4]                 Table Length : 00000668
[008h 0008   1]                     Revision : 02
[009h 0009   1]                     Checksum : 6A
[00Ah 0010   6]                       Oem ID : "GBT   "
[010h 0016   8]                 Oem Table ID : "GBTUACPI"
[018h 0024   4]                 Oem Revision : 01072009
[01Ch 0028   4]              Asl Compiler ID : "AMI "
[020h 0032   4]        Asl Compiler Revision : 20230628

[024h 0036   4]                     Reserved : 00000000

[028h 0040   2]               Structure Type : 0000 [Memory Proximity Domain Attributes]
[02Ah 0042   2]                     Reserved : 0000
[02Ch 0044   4]                       Length : 00000028
[030h 0048   2]        Flags (decoded below) : 0001
            Processor Proximity Domain Valid : 1
[032h 0050   2]                    Reserved1 : 0000
[034h 0052   4] Attached Initiator Proximity Domain : 00000000
[038h 0056   4]      Memory Proximity Domain : 00000000

...

[050h 0080   2]               Structure Type : 0000 [Memory Proximity Domain Attributes]
[052h 0082   2]                     Reserved : 0000
[054h 0084   4]                       Length : 00000028
[058h 0088   2]        Flags (decoded below) : 0001
            Processor Proximity Domain Valid : 1
[05Ah 0090   2]                    Reserved1 : 0000
[05Ch 0092   4] Attached Initiator Proximity Domain : 00000001
[060h 0096   4]      Memory Proximity Domain : 00000001

...

[078h 0120   2]               Structure Type : 0000 [Memory Proximity Domain Attributes]
[07Ah 0122   2]                     Reserved : 0000
[07Ch 0124   4]                       Length : 00000028
[080h 0128   2]        Flags (decoded below) : 0000
            Processor Proximity Domain Valid : 0
[082h 0130   2]                    Reserved1 : 0000
[084h 0132   4] Attached Initiator Proximity Domain : 00000000
[088h 0136   4]      Memory Proximity Domain : 0000000A

...

[0A0h 0160   2]               Structure Type : 0000 [Memory Proximity Domain Attributes]
[0A2h 0162   2]                     Reserved : 0000
[0A4h 0164   4]                       Length : 00000028
[0A8h 0168   2]        Flags (decoded below) : 0000
            Processor Proximity Domain Valid : 0
[0AAh 0170   2]                    Reserved1 : 0000
[0ACh 0172   4] Attached Initiator Proximity Domain : 00000000
[0B0h 0176   4]      Memory Proximity Domain : 0000000B

...

[0C8h 0200   2]               Structure Type : 0001 [System Locality Latency and Bandwidth Information]
[0CAh 0202   2]                     Reserved : 0000
[0CCh 0204   4]                       Length : 00000168
[0D0h 0208   1]        Flags (decoded below) : 00
                            Memory Hierarchy : 0
[0D1h 0209   1]                    Data Type : 01
[0D2h 0210   2]                    Reserved1 : 0000
[0D4h 0212   4] Initiator Proximity Domains # : 0000000A
[0D8h 0216   4]   Target Proximity Domains # : 0000000C

...

[140h 0320   2]                        Entry : 038B
[142h 0322   2]                        Entry : 089F
[144h 0324   2]                        Entry : 09C4
[146h 0326   2]                        Entry : 09C4
[148h 0328   2]                        Entry : 09C4
[14Ah 0330   2]                        Entry : 09C4
[14Ch 0332   2]                        Entry : 157C
[14Eh 0334   2]                        Entry : 157C
[150h 0336   2]                        Entry : 157C
[152h 0338   2]                        Entry : 157C
[154h 0340   2]                        Entry : 3AFC
[156h 0342   2]                        Entry : 4268
[158h 0344   2]                        Entry : 089F
[15Ah 0346   2]                        Entry : 038B
[15Ch 0348   2]                        Entry : 157C
[15Eh 0350   2]                        Entry : 157C
[160h 0352   2]                        Entry : 157C
[162h 0354   2]                        Entry : 157C
[164h 0356   2]                        Entry : 09C4
[166h 0358   2]                        Entry : 09C4
[168h 0360   2]                        Entry : 09C4
[16Ah 0362   2]                        Entry : 09C4
[16Ch 0364   2]                        Entry : 4268
[16Eh 0366   2]                        Entry : 3AFC
----------------------------------------------------------------------

And here is the relevant extraction from `SRAT.dsl`. As you suspected,
the CXL memory ranges are indeed statically defined in the SRAT at boot:

----------------------------------------------------------------------
[000h 0000   4]                    Signature : "SRAT"    [System Resource Affinity Table]
[004h 0004   4]                 Table Length : 0000A1F8
[008h 0008   1]                     Revision : 03
[009h 0009   1]                     Checksum : 54
[00Ah 0010   6]                       Oem ID : "GBT   "
[010h 0016   8]                 Oem Table ID : "GBTUACPI"
[018h 0024   4]                 Oem Revision : 00000002
[01Ch 0028   4]              Asl Compiler ID : "AMI "
[020h 0032   4]        Asl Compiler Revision : 20230628

[024h 0036   4]               Table Revision : 00000001
[028h 0040   8]                     Reserved : 0000000000000000

[030h 0048   1]                Subtable Type : 00 [Processor Local APIC/SAPIC Affinity]
[031h 0049   1]                       Length : 10

[032h 0050   1]      Proximity Domain Low(8) : 00
[033h 0051   1]                      Apic ID : FF
[034h 0052   4]        Flags (decoded below) : 00000000
                                     Enabled : 0
[038h 0056   1]              Local Sapic EID : 00
[039h 0057   3]    Proximity Domain High(24) : 000000
[03Ch 0060   4]                 Clock Domain : 00000000

[040h 0064   1]                Subtable Type : 00 [Processor Local APIC/SAPIC Affinity]
[041h 0065   1]                       Length : 10

[042h 0066   1]      Proximity Domain Low(8) : 00
[043h 0067   1]                      Apic ID : FF
[044h 0068   4]        Flags (decoded below) : 00000000
                                     Enabled : 0
[048h 0072   1]              Local Sapic EID : 00

...

[A1A8h 41384   1]                Subtable Type : 01 [Memory Affinity]
[A1A9h 41385   1]                       Length : 28

[A1AAh 41386   4]             Proximity Domain : 0000000A
[A1AEh 41390   2]                    Reserved1 : 0000
[A1B0h 41392   8]                 Base Address : 000000C040000000
[A1B8h 41400   8]               Address Length : 0000010000000000
[A1C0h 41408   4]                    Reserved2 : 00000000
[A1C4h 41412   4]        Flags (decoded below) : 0000000B
                                     Enabled : 1

[A1D0h 41424   1]                Subtable Type : 01 [Memory Affinity]
[A1D1h 41425   1]                       Length : 28

[A1D2h 41426   4]             Proximity Domain : 0000000B
[A1D6h 41430   2]                    Reserved1 : 0000
[A1D8h 41432   8]                 Base Address : 0000071E40000000
[A1E0h 41440   8]               Address Length : 0000010000000000
[A1E8h 41448   4]                    Reserved2 : 00000000
[A1ECh 41452   4]        Flags (decoded below) : 0000000B
                                     Enabled : 1
----------------------------------------------------------------------

Rakie Kim
> 

