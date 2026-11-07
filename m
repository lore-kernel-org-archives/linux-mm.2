Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96FE1606A33A
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 10:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dTWOVJsq
Received: by kanga.kvack.org (Postfix)
	id AE6FA6B05B4; Sat,  7 Nov 2026 05:59:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABF086B05B5; Sat,  7 Nov 2026 05:59:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B5336B05B6; Sat,  7 Nov 2026 05:59:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E2F06B05B4
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 05:59:36 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C6C8580313
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 10:59:35 +0000 (UTC)
X-FDA: 85408027110.18.DDF0259
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 238BF160002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 10:59:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dTWOVJsq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794049174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rDic6n19p+tKm6gJFnHdWsLjkBC8J9A48hzVn2p0tWE=;
	b=PB0X7RtUZEpm11eaZZdw3VsSLva8Xb3CcMHd7ZhZioa7Aal36dLdBpKZwAu0esCAbCA6Jq
	Hlv4mBUCm1B0ArrzM9TYxYwvr7m6+3JiptE14gCb4dDJDbUdYQG57qY2vbfYixZp3C8GYg
	yEFxj8UCtWMBaWTghUWpMhfwBc2Zc9c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794049174;
	b=pn5sGVpKbTqoK1qSEAufvh2pUD9wYk+UZ+cptALYw/j5itaUdA2kdBjD0dUuf7am6jnZIw
	tAbYCrhEq0WzXPkr8Op4U3NCoKGG8Ma3xkuwuXwBsoClcvuSShgG4B4nrC3l6ZWiaM7W0V
	DAtxA2Y9oYxVUkJ9GtM2KVufnVsVoq0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dTWOVJsq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 966016111F;
	Sat,  7 Nov 2026 10:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB361F0089F;
	Sat,  7 Nov 2026 10:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794049173;
	bh=rDic6n19p+tKm6gJFnHdWsLjkBC8J9A48hzVn2p0tWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dTWOVJsqhmVHIkNdc9lhq8nOLai44lu0V2WeVfW9gl6t3I7xD0yUIQwDEr36UwZSi
	 1790g7LlB9CVojVs/V0Xk8rk+AZWZ4lgLVJOfUz+xe2Vf/YapPByxkmWZvcznfp7td
	 yFmcnA/YTioNEdIvWa+qeOyWMO4zZsze8dETZs0/jBKMMYZv496Y0FW8CCU6OF2OeJ
	 ycKToyQ8GqcUc3l7caQsFHWgfETCZGqUTvqL9p2wuUNL0S2EwhGISaUA5CKTTEvLa0
	 ilurnve3o0c3suUa41vAwtpH+00CS4z5dPQQmcB8MNb9WWu4AiEo24pw8MZCmCbljy
	 k+B7NOE+I1liA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	baoquan.he@linux.dev,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	ruirui.yang@linux.dev,
	jbohac@suse.cz,
	david@kernel.org,
	hbathini@linux.ibm.com,
	leitao@debian.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH] crash: keep crashkernel CMA pages reserved if activation fails
Date: Sat,  7 Nov 2026 12:59:22 +0200
Message-ID: <179404912275.1474561.15279136626327905378.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261104145600.3708886-1-usama.arif@linux.dev>
References: <20261104145600.3708886-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 36kthwg5zypktwdmt55uauaboxjk1ef3
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 238BF160002
X-HE-Tag: 1794049173-818876
X-HE-Meta: U2FsdGVkX189+sPPWqQLrZI1iRnfjs97dMV9HL7YZ1X681Mo2EhcPNdrJ8m1FGqZ06cgalIQXEThOFMGRrbnesUCeQU9IsuKVqR6SuWpIrMYB4bTjYOcBIn7GtdySAIs3b4cFBsvWc8ko94CCOEQq4FBRyv0LFOwriUI+afTU8OTFQ3e6sWrBvabX76CKjA2iDdoEA2smn4EDaPf8I3keW7NJvVS3E5lpJ2ErBqEtJKA2LzNxhZ1xV1uM/zMDOsytHc0eSXSD0YDHWAjkf6Bw0i0MWjJoMT1oShZ+HWDY7A7CTldFJVjTEojjeJG/qOvzz3uPpalzQ1EQV4oE6lw61JeExzMt72HHKNzINRWUEFNUsCd4pQ0iKPBMwFNRT+dbNQ9FLzf/rjb8rDYySH1Fcx9rC+zuGGaWOs1eBgJFQ2lMlDra604YlvwheCUTe0exdWKlVRh5QzKy3j/LztevCp2cNsJi8mEWfcPK21WKRjPrjMDoeGHqTtw7mkMI/Os8lBDZIYym13W8x5X14T4J9u4pkP/R6sw21f+CqurbXOBPZrkk7OAM0vLc8ojeOLA7+sk2ZsTXRg2taMYMhfHO5bogcH8fBIcQSPGyK3eXCP41EFJtTdaf8AqZt+42dBYcwqlVX/A3lQqpSwQPOD8Mf4vicyfQwtrXqDt4rY1m5HVKZf0t2ipvlWPt5H2Obmskd7Kd0XTA4X8lpw+egGaGFFAU4TbZ6O5GzB5rFWVq+Quvvj6cGOKVbNAanKqkJONVnAOQOKeRc+wptXiMJu72CdGTMewHWMQVqTIL3a40YZjI6KYfFz18yOTazOh2gRJqIZ7Zv1Ojr4Wrw4M7DlLeL+D3RmAmZjTqLGvlOiZ1GHDppf9PUT39yRed4PO8upcDRBfSH+927rtDidHJalMNwVq10EG1FT6bJCU5bjvoXocgUfZ2dqa/uxcwSrMwsGVm2fea7g2J3cqe+dVS/F
 65JtWEXy
 O78UBTWHd5Dc3Xmzp4qc+Ea+Z/dNsWsl5cGHeb4WUKUTHdUGaCxFJwPeUrIqsoUPm2DWMxlh73XLcWShkL+tyueMPHmp1tpB5A1DnJ0stq62pm3hZXemaQUP0FrxwNs5zAV0x1Omyepu5YG75iUhlZTpwrUUuqNt3OWmYal9KI03ZLMLelXjedED+nA9BvsAcNok4+joHEbUD0brIkVnVEC5eoo9M4PN6pIAB1rrsmbVHp6AMzNlyj+TjAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

On Wed, 04 Nov 2026 06:56:00 -0800, Usama Arif wrote:
> reserve_crashkernel_cma() adds each crashkernel CMA area to
> crashk_cma_ranges[] as soon as it is declared. If the area later fails
> activation, e.g. because movablecore= put the ZONE_MOVABLE boundary
> inside it, cma_activate_area() releases the pages to the buddy allocator
> as ordinary memory. The range is still handed to the crash kernel and
> excluded from the vmcore, so kernel data that lands there is overwritten
> by the crash kernel and missing from the dump.
> 
> [...]

Applied to kexec-next branch of liveupdate/linux.git tree, thanks!

[1/1] crash: keep crashkernel CMA pages reserved if activation fails
      commit: e2b6a999e1df5bda2100262397260664655cd47c

tree: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux
branch: kexec-next

--
Sincerely yours,
Mike.


