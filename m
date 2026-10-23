Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADE6A606A31B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 00:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=a6CBw2n2
Received: by kanga.kvack.org (Postfix)
	id A7D826B0A95; Thu, 22 Oct 2026 20:55:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2D386B0A96; Thu, 22 Oct 2026 20:55:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 943FF6B0A97; Thu, 22 Oct 2026 20:55:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B1336B0A95
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 20:55:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 06441A7D0F
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 00:55:42 +0000 (UTC)
X-FDA: 85352073324.07.0A9B958
Received: from mta0.migadu.com (out-32.mta0.migadu.com [91.218.175.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3BA9B40008
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 00:55:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a6CBw2n2;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.32 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792716940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WQcd0l67AxhO8WSZviozv+Pddw80RChcSdimzj7mciM=;
	b=AKRwd3BACMNF+okmVXdnicuVMI9fW5E3o4von+m+6BSWcV1zNr1yzAEpaya3Ewhxzc67T9
	gq/KBtC7TxvL3/PZgaoyM9S0WyVVW6xUfcdsIWK4hoNjjppjRxK/qpeoQefOM9fKDEcYx7
	7Gq0kG0Y1lmNnAyMILFV0tNwVbVlpGo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792716940;
	b=TKNEG4VWUlPwgrnshJtw2fwRQ4c5THLHeFckWzWMF9NpU0ktBRS789PGo4yMDHWCyX5C09
	fu4KJH7g+SZV6alhJ7BYc0XQxqR9kev8fd4MU+4yO12Pb/bTRkQ6o0xCPe0xlOMZ3mdpvQ
	VsNKEd4uJEAy2V72ZbK9qGFHqOyEClM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a6CBw2n2;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.32 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=e2fjOiLeTWrJYYpS60xcbzkTmUkNJmvgx/KCtZ72os0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792716936; v=1; x=1793321736;
 b=a6CBw2n2L5svXcNXVxtRaqzX2z6L+DOaY5/huwtiZ1P1LX3xBGlYYaTE8SZEPvmAkbRfj935
 ON0MXmOZxU0H+FS38Uxionx55+UxyHKmdGZdFJNTaUTLaOBDGvbfxYeyojI3L+H+VS3sD3+rFjk
 dotOc2UpUZhUisAI59UtmG5M=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0f9dfc49a1afc88e;
	Fri, 23 Oct 2026 00:55:36 +0000
X-Mizu-Trace-ID: 0f9dfc49a1afc88e
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: songmuchun@bytedance.com
Cc: osalvador@suse.de,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	lance.yang@linux.dev,
	jthoughton@google.com,
	david@kernel.org,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/12] mm: hugetlb_vmemmap: rename vmemmap_remap_pte() to vmemmap_optimize_pte()
Date: Fri, 23 Oct 2026 08:55:26 +0800
Message-ID: <20261023005526.20560-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261020115824.823278-5-songmuchun@bytedance.com>
References: <20261020115824.823278-5-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3BA9B40008
X-Stat-Signature: b91iatcs35ux3m8hyg15httbox6p1prt
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792716937-972340
X-HE-Meta: U2FsdGVkX187sISJTZtXCM9DbSFBIfpAeGHAFZ2CH0uv6JPVoLXaWOURhYMHg0kTpLjzWB1JYFwzZAINKmin2yvk+cZT9NlqqozlNpcD1zzlpY7R4K47V3FzM8qiEGGmmF7ICZ0tQmJyQvCpt9RVPnwpKauqKnAICAtIxnoSs2skZFfED1dhejOArml3u6MZEe5K1+aAhJ2in+9OsT/QOmziHsvi1DUshWOpTASAgC5SP8BuqC3azpF4xImEpgcl4uKVdFCLm2+u/CSF4BdsX0DxCygYmBLeRvcET3pX2ThNA1b2tIEivbpU7W3NgtgHSTSbJc2VXb4MmkWnd3Bt87EMAPC35wi2+ARnsKJ5HUmB0WcLwkVd/jTVLABUqyg2wNDqkBL7z+22amBh9EdmfNx8mLy2U/vbbCr1SlzUVoB+fvyKq2J0gdmroMll07E6tiAfxuYY+70feKCRBDm6UsxjD/k6D+zyGwNN5bhRyyaO2UmJ0Gi5LvZEIp6VvQcplcs1un23PhuUflBqU/dLzlGLxMnspdqUJI9nhJ7gCDB8HwTiEDex7QuUqP36jzt4n6Yx7qvh0/XXv4TqNLJBGgecpeZJ5kqrPc71wYHLcBlqAMLfnKPPyDRw1Z+LFTfwYXsca5DwuyPU64FObF0U5TCjkVIoEQIfuK8sWMw57PTc2M1QXmuB2GXbo74ON+4JnltW62V/l1G591AnDHA2t45TubSBsFC3aKByA2dF4U/0VnHZv8E4AyT+EgBmkl/q1U3fhPolxJH7mwmcL5K6NVRLXOuslgRUxR9jMeGbUFaytZnAgPB/VmXQMcA9wc9MAXi0egM1DErlf+pxc6KfxeU2EgPkwCYIsHEzjcwRk0G+Sj6HqD+fTHJnxWKRLfUB+RYGmAyjm+2BytbFLVIId2kxTBmHjdLQFw5Hrt6I6vNXT5T3nCAYUOuGtPfoLKNvYYU/ar3MH2V1lxZyfJi
 +9vtR1dN
 S7jrdF2OtUIyVx1FoZdqknMUMypCBFSQ+/47FB/R90evSGW+4drUVlD/GpdKPG5qIx2Rn7aAcqf0pFhV9SC8F080OD/MtyV9H5pId3pz9Fiqr1hmvOfoYOKn4DUwqPeA8o7MqjNOIumsqrmFREUG/2T9vfUYGuDOT1wmzhx1jHPDTm6eKEfR3WercDkukXDP27TyNUJRqmZ3NBmo7+FTOZtVVGbh355LK8G+A2lE/1DLOjj7lP60OInAntX60KafRVFwjQIyNbad5jKz81i5dfrVjWX+7EFweRhnWWCbOf0Glz/k4CoZLKEmGxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Tue, Oct 20, 2026 at 07:58:18PM +0800, Muchun Song wrote:
>Both optimization and restoration update vmemmap PTEs by remapping them,
>so "remap" does not identify the callback's role.  Use "optimize" for the
>optimization callback to match "restore" and make the two directions
>explicit and consistent.
>
>No functional change intended.
>
>Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

