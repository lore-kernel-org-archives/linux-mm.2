Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FC06606A885
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=O2KDHPXD
Received: by kanga.kvack.org (Postfix)
	id 8D17E6B05C3; Thu, 12 Nov 2026 04:11:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 882286B05C6; Thu, 12 Nov 2026 04:11:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 797FE6B05CF; Thu, 12 Nov 2026 04:11:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 554F36B05C3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:11:51 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EA51F140534
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:11:50 +0000 (UTC)
X-FDA: 85425899580.21.B1F6B2B
Received: from mta0.migadu.com (out-125.mta0.migadu.com [91.218.175.125])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0B02D40003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:11:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O2KDHPXD;
	spf=pass (imf07.hostedemail.com: domain of qiliang.yuan@linux.dev designates 91.218.175.125 as permitted sender) smtp.mailfrom=qiliang.yuan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794474709;
	b=oAO2PVnM6n9EeByokU7ShR7CfyW5ZAiaroBczVw0DH5WRLovBbUgl9jZAbYTQaOZvwckF8
	2rFkwT4ALU5zMWCekBsQFZaQVCpW+Js3NxAPVsYQaK6uEk/9oxSovTeg5GavmSpr/LUCaR
	+CcRjqh/mnb6fkvXS2ICdzGD0YnBzeo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O2KDHPXD;
	spf=pass (imf07.hostedemail.com: domain of qiliang.yuan@linux.dev designates 91.218.175.125 as permitted sender) smtp.mailfrom=qiliang.yuan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794474709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lqk/lzctgl2EnU9POHNhSvyxLWhw+3C4u7RGP3+BPUc=;
	b=odRPhl3dH+0NpR2bRxyDnvppR1eN4+3kKqbB9USrC81H5FMjOJbvb9B0XEQTLONYPs/DK+
	VkstcEtM4XcXRcCqC8RCN7FdJh0TZYmLtCr4wq6s2Lao4D0T4itw1aMHQP0UOTYv3ofXQA
	yhX2ZLlvw46ntIunFWQam3jArLw8avg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lqk/lzctgl2EnU9POHNhSvyxLWhw+3C4u7RGP3+BPUc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794474707; v=1; x=1795079507;
 b=O2KDHPXDKTXPdjQpssoT7uq3epoWF5BoE3Pm38apQQwc/1A3Cp/arx/yRF2LLYiwrgx2vGVj
 EtoFtHHrLdI3siPqe85N2NhIPuQyQfkIWQWw70qBcarXKlm9r9rhIMibH9cfLkxRfPkMfPYP1xi
 6Fdu7q2VvE91eHPtvRS5DjU4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7cfd7655f2e19544;
	Thu, 12 Nov 2026 09:11:47 +0000
X-Mizu-Trace-ID: 7cfd7655f2e19544
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Qiliang Yuan <qiliang.yuan@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>,
	Qiliang Yuan <odys.yuan@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] mm/shmem: drop the second folio batch from shmem_undo_range()
Date: Thu, 12 Nov 2026 04:11:35 -0500
Message-ID: <20261112091135.4142199-1-qiliang.yuan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <8fb62131-db10-491c-9839-a3835d7aaf32@kernel.org>
References: <20261111-bug-mm-shmem-undo-frame-v1-1-e50a95b8f9b2@linux.dev> <787a1ba3-df93-45f9-abe1-3fcdefbe41cc@linux.alibaba.com> <8fb62131-db10-491c-9839-a3835d7aaf32@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0B02D40003
X-Stat-Signature: 93y6ubzfgkdeojyo68kwhhto4ft7em6f
X-Rspam-User: 
X-HE-Tag: 1794474708-7349
X-HE-Meta: U2FsdGVkX18LrGSAAE+MTrs1ggF7oTF5dGkof7Bc7C9LsXTwpQvs1and02uLmMslKpDaiypkPzTbZj6MOBADTb0sEtQ0KmixdXdc4w+LdU+amko39DUsNeAmydPVkrPJ2mZYQARKqF+5Z/iSbpJfpUow0A6qOx6dsfDkVRvhZlLXrhDyJPWwlBbFUD5BOtfqsao6fPo20dRhiEGotl9zggWmQxB0g7lj/5gKl8zJ+6omoyz7Bpen+1xARjBoHd88pXSNiy3RgmCzWvsRLNauKUpyfUNgAugSyFEpJ+4GowKmveR05knPPQNGQmziMu+lGW9mTpmYX/yG4kbDvS4QJLCzm1kkCGMkCfwD8t933kpv9ktKUQnSMk4PekXd+k95jrAokmgD53Z5fIlringAyAF71zefXYGDEMKoLPUHpve/ERu247jwiT4G9jfsehoNrMX67exZC4bV3LjBC8Kw2xAWXmHvP8oEMqHLVdt24NPi7OkJgjf1Tgq1AkLG2mUAH9pGKhtUzhZSzkSRylC1f1zwgBThKMX77UyMVx9yqY0Nwphq0Qo+4oqFaYoZEe3EbdzFAzCAGOIA3KRiiBhrLXKN8ixsWL3sQGi1k9EFLc96LjGXxpeSerwhodgqJ4fzZy+J+XGdw2exiQDwSDRb10g2O2K/F+LYA7MKeUAo4V0AziyRMl6xnd15b5TEjUCB+0AbWUD+lKGdPpt0NphHXGGupomTT3jqEn1yNB8We0bNBjhMHdr9zbXmMvAY5BjJbHqvW8Oi6Rk1hrWuTVwoCQkYnA4VrGO/XQX6z3cf1q6Tnh/dHl/nUH7Dcm5LBQKx1COCpwR4DR520VoK80Y96sZ63ujso+hMo5E74N0uOwBtZVIbsLDgatrUz6w2BMCuw2Em+4PpBb9Q7IlPeshgHE1c0wiAMHaxQNrS+Zbt5yJywxhbTfGYnc/wDBcIbdNR/oCfyL4JCA7m8vU246B
 SJ6gHomi
 eMZYa1fQ6Jqf78k8NcMgX7N5tcG2XsC9NKywjs0WgRQG8CQaQCAaRz4Jat1zyPYmgFZGQ+xP57+Z8VWlrgg+enKkEu3idxcFqhE2YeRgnvqcHMkdelznjRekFQwFYjwSzPwPnyQh5fr5o/lhenHF3TJevIuiML2ZzweQgX6DYO/EX43aOFMoJ/1yGqNevdbANaE3ltSL1mPmyRhBc2sIwhbuRJqOdUXNJsFVe2jVNHSpfFw7b7iaxzZjQud3tHGothwwWlYTvcS3Dqp/+NW8E9l+ciMw+Zsz1DkvAkuLAqGivovETQuumng97AsbcFlMuJ4xZ8ERYgzWUmenWDK5Ec/+vCGfQ3bLywBdvsxcyQq8wA5iuVJupW9YjO++jwSSRgUxgTUJpkBvxTYU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 09:33:00AM +0100, David Hildenbrand (Arm) wrote:
> On 11/12/26 09:05, Baolin Wang wrote:
>> I think you should send out a complete v2, and David could queue your new version.
>
> Yes please. I'll drop the old patch from core.git. Should be gone later today.

Thanks. This patch is superseded by v3, the complete patch rebuilt from
the v2 in shmem-7.5.misc with this fix folded in. It fixes the stack
frame warning reported at
https://lore.kernel.org/oe-kbuild-all/202611112032.TMyPU6Rm-lkp@intel.com/

v3: https://lore.kernel.org/r/20261112-bug-mm-shmem-undo-batch-v3-1-212db8c24058@linux.dev

