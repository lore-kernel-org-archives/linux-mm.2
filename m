Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA241C44532
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:34:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EC2A6B00BD; Tue, 21 Jul 2026 10:34:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99CF66B00BF; Tue, 21 Jul 2026 10:34:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88D1B6B00C1; Tue, 21 Jul 2026 10:34:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4DC326B00BD
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:34:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CA092C01C2
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:34:04 +0000 (UTC)
X-FDA: 85013028408.18.9824B5A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 112D280012
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:34:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Wxp/mt8s";
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784644443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+5YEfpnT2oozYCnmAI9PBP18Duhq3Tk/K6j/fOF23yk=;
	b=O/Z/e+rrEde2HdCvLmmiwOsieSXqZxG/82pMuS2sHGRSutXWraU1XeWM/kGf283OQ2E0xa
	mT8rfG6fuBlbeqTJG7ceJ5ZTgvOyu9+jO4RkJD6MNBheU7E5i+nxJfn2IqzuJi/lBuIlA3
	l8ARfdyP5iBpQtHqOoCF8wUntEqfB90=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Wxp/mt8s";
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784644443;
	b=CGi2LtBBKVh0Gkes/UccGu282eIuwwFfVz2U0b7gJ0XODScboqAzwz48aKZmy5UEGlJrJM
	2RyfKMlJqve0lu/LDZOuRzFk4OYW+qIXyvVL11LqLg/mxsQH9tCeSzAMYB4ueVtXWWjoCY
	XpO4l5SucDTbaAlGxNJ5q6mrD8Fb3GQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7074C60054;
	Tue, 21 Jul 2026 14:34:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE2C1F00A3A;
	Tue, 21 Jul 2026 14:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784644442;
	bh=+5YEfpnT2oozYCnmAI9PBP18Duhq3Tk/K6j/fOF23yk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Wxp/mt8stG+Rc3giQdEBOVq+M0GGJSxpatj/AoGDI11QtjXS++ZO3wst/OIYM3b+r
	 p9xtA5OgnMxY8dIyiwhcIvrkRVCBOBQ8YBmY3DksE6a0d5zJRIS/HAauMMyXw6oMkq
	 +sz2KJK77Rzf5Jt9gxktu0YKZM2amQS9iECJzzhW5wNRrGP+vdSAecoik8quLZwLqt
	 vak91HwBcii9zp7Z7lkEDw8ech5OBrEC04OC185A/7SqwhOB9iWLfQRuc2beb2oLrP
	 G4O0vSF/2WUqDAhnU9fglU6QjsrTq+g32MQsBhN7FxEY9PFtiwPp69FWML+JwW/TSS
	 GKjDoyaD/YOZA==
Message-ID: <5766bfae-8dd9-4542-bbab-324dbde0e2f5@kernel.org>
Date: Tue, 21 Jul 2026 16:33:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] mm: fix PMD level mTHP accounting bugs
To: Nico Pache <npache@redhat.com>, Andrew Morton
 <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@nvidia.com>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>
Cc: Barry Song <baohua@kernel.org>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, willy@infradead.org,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>
References: <20260717064502.1980173-1-npache@redhat.com>
 <20260717182947.534af296aaa1831d13f8ae6d@linux-foundation.org>
 <CAA1CXcCrA9nrraxVNTdo19TRONvqM-fndSbDaCib4tZCmQC9tw@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAA1CXcCrA9nrraxVNTdo19TRONvqM-fndSbDaCib4tZCmQC9tw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 112D280012
X-Rspamd-Server: rspam01
X-Stat-Signature: 697ni1jpjcjmdrpsnfs6ro74o4rbq9jg
X-HE-Tag: 1784644442-429658
X-HE-Meta: U2FsdGVkX19R8d0YsF9/q7ejOjPdudIwj6WmoyP1UoVPKXkb1YnLzPoc4HMFMJueRemAZVtfIJ9jlDWXF9qc0EXutHBZvx1QlwQDRVFGkd4Z7q4cAM/Hgkzz6iNQKheBbrseP4w/UykS1SS0+jhSV/t02X3W4rnfcyB6xGHESCQFskhZcRKQqlj1tjv1yQTdTvOpNIhA+MKEnWj+zjNhenX9yHUpMB2SUxk1f7cNyvKUVCOzA+9mA/1yXOJL0MKsaKzhGUlUwOanO7ZvbcUnlIBWFfnKf0UUi8/5AyIm6yuf94IOSx6gPSlW1Dh7K1Et3zcr8dDBwrJPyUPZ3IIO9f1eOoRsYF3xRyMtreOBQM1W5/Cohm3yy8+VBpigQ4c3LPkVTCLnj5zUcdlD2TLJHnIRx7vBCTQkC2QKrBYDIGLT+m2D4o7bOJocCi0GV2hPlDc8kXLrdX/9vj4Dv/BibGMA5g01BN/OmvG77zBSCj66nfUgF9T+hnbv7LfSdYgEUwty4jY49oTOBy1wKU6BfW5M/iUrCdXL0vJRTW3S4d8t34kgPpJzVM478zVGGwPotZs0hDwa+U5NeH062IKYnxRcjSLdkqwVI1bhFOUYvkQJsY1SfPjAzXiNCZUG0iJYUS/nLli3qvGou/VueVFwqV13N4Gq0zD/yJKVy4otwGkrgy8wzblKm52x44VkBikdO3sRFm+895Cdgf/nUTBNEQ+mgOfh8fnyACjssVvFydQi0YJ4KIcP42fmRv56aFqy/kefsaSgMFplLEqtHpCQ1bdmcduJR4OA3VKS2aSIyVzhfgFx/r90OEvK8lp36m4hBmqaCVZgxKTvR88ECdzqfEC7uwqsKK0e3qmPlRZS1Ok8Qye2G9uG2nTCdwfb+Sv3euGDt3SmNf6xJMHfbragntJPwrYF445/ja57tGqzTQiw1WPZ98Nq2NNK0fduOV1rVUznzeDEsKvfUqBdafo
 Rv7zJJlP
 Z4XP/GF5d1MZjiwb/SZXxCHaqEu4O/1Fgt2CD3nHHHK7JEB69IrCes3Ps+RGRO+05cwD4nmMQMMkrJFWPNlpnzEQy4rqDEN6+g3V0+KqZ/dOgcCRZgNVanedSpkJGyuVEjrAit/7JFkJu+gHSUInkJHXhxw0P9fvFfkdRPJvY6Vt6lKawJYvEcuCc1XwUfRHbWBHP5GAC3EzIB0SW+xyovce+vqbBBNFWrn39cFNxBs/ZI9La3oBhptUd8sphRHXr9xfvxC5giyLdiJFi1s4F0WVPWpCvjUPs8K8z2MbTNpwz+Raf1GLuIT+ZtYmfGduQgLcV1St0aJ89W5uA515tu+mDTKzeWc7sn0JrnUuSe9/7cOl2MpkdWAYMNEFFWsZ7Hp1y2G9ylP9aZitwkY0cD4guBBFPCJVjcIfMZSvf9jkYJ1uWllOrchR38yaqnQVRwPitxxS8fSHndoh/KH7xg83INOHAX741iaaYJfVJiNqAbtS7upnOFi6Zgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/21/26 15:57, Nico Pache wrote:
> On Fri, Jul 17, 2026 at 7:29 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> On Fri, 17 Jul 2026 00:44:58 -0600 Nico Pache <npache@redhat.com> wrote:
>>
>>> While running selftests I noticed the PMD level per-mTHP stats (nr_anon)
>>> remained elevated after each run. After further investigation I noticed
>>> this accounting error occurs for both the migration.private_anon_htlb_test
>>> and the HMM tests.
>>>
>>> In the HMM case this is due to folio_add_new_anon_rmap() incrementing the
>>> mTHP stats, but never containing a corresponding decrement in
>>> free_zone_device_folio(). We solve this by making sure to decrement the
>>> counter when freeing device memory.
>>>
>>> In the migration case, we are incrementing this counter without first
>>> checking whether this folio is a hugetlb folio, which relies on a separate
>>> accounting system. We solve this by adding the proper hugetlb check before
>>> incrementing this counter.
>>>
>>> With these changes in place, the two tests no longer cause elevated PMD
>>> level accounting issues.
>>
>> Thanks, I've updated mm.git's mm-hotfixes-unstable branch to this
>> version.
> 
> Thanks!
> 
>>
>> Sashiko is worried about the existing code ("list corruption or a
>> use-after-free panic"):
>>         https://sashiko.dev/#/patchset/20260717064502.1980173-1-npache@redhat.com
> 
> https://sashiko.dev/#/patchset/20260717064502.1980173-1-npache@redhat.com
> 
> I dug into this, although I'm not very familiar with device memory.

In general: Don't let a tool waste your time on unrelated things if it wasn't
you that asked the tool for it. Someone else asked the tool to find unrelated
things.

I thought we only support anonymous THP for device-private, not device-coherent.

Maybe lib/test_hmm.c could somehow trigger it by selecting
MIGRATE_VMA_SELECT_COMPOUND?

But in migrate_device_coherent_folio() we have

	WARN_ON_ONCE(folio_test_large(folio));

So this would already be pretty broken and I wouldn't spend any more time on it.

-- 
Cheers,

David

