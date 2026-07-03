Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BAB8C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 09:43:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 342E66B00B6; Fri,  3 Jul 2026 05:43:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F3906B00B7; Fri,  3 Jul 2026 05:43:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20A096B00B8; Fri,  3 Jul 2026 05:43:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA84D6B00B6
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 05:43:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 72CD51A04AD
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:43:22 +0000 (UTC)
X-FDA: 84946977444.17.5781A72
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id CA09CA0004
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:43:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C9D7+C5Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783071800;
	b=H77w2WsZBBbaNYXL1kbIgES20CsfEZpR/NTnOrLbwLKoaMcMV0x4OZFmV85oMb2IbYYa7y
	GOTcYOEvqjuxJ0hn5Rt7cT8JzHd7cJ95hR9A3FAeGx2k3HOiX5hDzrWsCBvJmVOllE15J7
	vXtoJkFDF9yQiNPBVWbXtczZX0Uk8Ds=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783071800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jl/LNX0F9c5ZLakltcdxkRYciVZAqidRH+eUQNM3t2s=;
	b=sQKZzE9lFBzWNQHslxaWly/KESRYkE3se72SOlwS6KE7Ubhm2NbVxKHGy6oejV3DNVKqIK
	qy9sKGluxN+jb+owdX7TAy6vMdPbG1Ho6c5N6YpYptgwEVBuOGNDq7FNSdwVYz741IhMfm
	lAi+POvF1zY5iSAx0jfM2DwiNG8YH1Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C9D7+C5Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 316A36001A;
	Fri,  3 Jul 2026 09:43:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4711F00A3A;
	Fri,  3 Jul 2026 09:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783071799;
	bh=Jl/LNX0F9c5ZLakltcdxkRYciVZAqidRH+eUQNM3t2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C9D7+C5Q0gdfl7m1VND10s22intgyJT3XKAN5kYdO7kL73GTDOwJ07LLmRW7PTGo3
	 VuIc3B4pB5Kd2Pe6zqvT0nQAqhufTgiAVt9dBuPgW2b8CXfuZs+fJUaDatfPjdc6Ae
	 dhi7jYRLUfGyXSynFyKiHDGNlizp20A4aXwQxQxkGSnkhdlYsg1b0rR0H0MkxI4zVC
	 QLgbV48qSBbz5kIJHncusJ4IM0y3FvhkUdfE5N3MlYePRfsQzuz3mAal5FYXOOgNmV
	 z4ioTcAU9v94PJpLh6iiCxTaLsx8mHaLD63VXpWGExklA3P+ItS+u1hI2W7AaMQ9CJ
	 zwMP7vo3Bn1Bg==
From: Mike Rapoport <rppt@kernel.org>
To: akpm@linux-foundation.org,
	Andy Lutomirski <luto@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Danilo Krummrich <dakr@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org,
	devicetree@vger.kernel.org,
	driver-core@lists.linux.dev,
	"H. Peter Anvin" <hpa@zytor.com>,
	Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	WANG Xuerui <kernel@xen0n.name>,
	x86@kernel.org
Subject: Re: [PATCH v2 0/9] treewide, numa_memblks: remove redundant work during NUMA init
Date: Fri,  3 Jul 2026 12:43:09 +0300
Message-ID: <178306815065.2173096.9480193260074524906.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260703041329.2797584-1-ekffu200098@gmail.com>
References: <20260703041329.2797584-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 6rnfz487pgq8r79pg3nqetzarufyp98x
X-Rspamd-Queue-Id: CA09CA0004
X-HE-Tag: 1783071800-562592
X-HE-Meta: U2FsdGVkX1/4an9tG/UcSHnpreJZsiOzyycDaM3h64OLwd8KV5iW76sqaf4jj5glln0OOKSmvP4Oh5uXa2p9obU/gdSFx7NKSFQTFhBt1esVPgMTW1LYB7JRZbS8nUSKrs9zXev0y04F4mQTNulQ4Bezf26jbLD73+w6bXW2GMcAOVgjjDwNLe0fSzhVcL/pgAQwy8GUSkcsArxWjteUNP2rav0EtttLOg81I9L+czETwigz6mxi1LnNNunirXJwrKKxnIVLhPt3fzwt+q3Tp8AD850N1zJdIwOlcjbLfnl1BToKeT/iRdrQiFtLxPL2OMYzHdzMAyh5fstAKsAIenz5iMLc6gHngyuFHty+xVHOO38LO4f4fM2mA//mi/diQU0+3QIpf3O4omArB5EmQ9BHDERFiB3fx7omTQWR5ynFwaRSrm0mvf0elAcoLQqcO+sJFADjcrcyFCOqfohxEdedi4EC2LpZjDjgAW5r1djPeQuuS3vkPXpVlpgzsBg1Q7NLGfD16vOVgokDDQTeXKtt1jZu/7aizl0UJZNNkf+4XHMVCLCo/e9khotJYwUWMpjxfVUdDrkWFywA7PGUVI6oisWqwaN6Wbafplfrm8Q6dbMX6YNOSc0tLt5K83s4or7bEaYyJuhINJ1omYyvu80YLK0Yj/AKXSerde4/JZrou8emOmDLgD2ha08MJCHpV/mNPL30vxe6vZLVjLfpF+eSrz0itkyMa0tSvDSWDMz0oIL30zouhIpcS/or4N4DtabQgvN6XfVD1SfVVdse3alqBfuybmxKvqF1iJBS1FGraDecpIX20KZAV3ayJEnyEnFBIWVQjRdJ5HbgZyFnS8kMi48r7PsTqIZlMQX/FGdodByaVwj4Cta3X79nDh3UO2DxErmOiDqll08+/tigiPlsuPSWniVBwQZJGQx2LObUVdr28oxVCOxXK9Dh9/7mrx3aZHyZE4u5UXJNVfT
 RHaad8oL
 iJO0BPEfXbIWrrEW8xQVPj+yrqxXV/2wkkEnGtwLAzA4RfhygW884ywJnegvzKkqT10HzK+vqfckgcBxH+vXAimGpqrk867TpuzbK0YhNCvWa1Nx7GI65nWriud2kTtf/nRk2UPoxxkfigGbXjPRR9/MmOZtMNsGOU9qjo46AxDZNG03/Mfm5w4l7ab+29m1NF2rV4dMFDUn2fIdi+2buRyZ4QnSe/OLm12+EQQw5U5kiPQZzw3ndpSwi1TNDDIxezBFPG/z686b0ekmmigAqKCUOd6JPTFMOrmEP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  3 Jul 2026 13:13:20 +0900, Sang-Heon Jeon wrote:
> Every existing numa_add_memblk() caller passes a valid node id and
> separately marks that node in numa_nodes_parsed with node_set(). In
> addition, numa_nodemask_from_meminfo() recomputes the same "nodes that own
> memory" set from numa_meminfo, which numa_nodes_parsed already contains.
> 
> This redundancy implicitly depends on the callers' node_set(). So, before
> removing the redundancy, make numa_add_memblk() set the node in
> numa_nodes_parsed explicitly. Then remove the per-caller node_set() and
> numa_nodemask_from_meminfo().
> 
> [...]

Applied to numa_memblks-redundant-work branch of memblock.git tree, thanks!

[1/9] mm: numa_memblks: set numa_nodes_parsed in numa_add_memblk()
      commit: abdbd8329281f40afd381346410d6d43604af82c
[2/9] ACPI: NUMA: remove redundant numa_nodes_parsed node_set()
      commit: 7cbdade40fb8f440c13ccd7a02d104bf32285187
[3/9] of/numa: remove redundant numa_nodes_parsed node_set()
      commit: 3b1e5d902dfa832e4b175cb1f5a000236d45ceb5
[4/9] x86/numa: remove redundant numa_nodes_parsed node_set()
      commit: 63fa742bae02f0d2ffe95ff540a51837815abc5c
[5/9] arch_numa: remove redundant numa_nodes_parsed node_set()
      commit: 8b9cecbdc78c5a6cfaaf3b00ce7ebe05cf5417e7
[6/9] LoongArch: remove redundant numa_nodes_parsed node_set()
      commit: 3aeac07c5b1c3399487f4b38182f8cfbc3dbbd53
[7/9] mm: numa_memblks: remove redundant numa_nodemask_from_meminfo()
      commit: a9bafc1832d2db97813069823821ed333b8ecda6
[8/9] arch_numa: remove redundant node_possible_map assignment
      commit: f5a77a50a14dffb659ee8f550c824f8280e37fce
[9/9] mm: numa_memblks: use numa_add_reserved_memblk() in numa_cleanup_meminfo()
      commit: e55424c84afd48aa2f0f761ae0c006128ef541cf

tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
branch: numa_memblks-redundant-work

--
Sincerely yours,
Mike.


