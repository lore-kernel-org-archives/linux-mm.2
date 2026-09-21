Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B89EC982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 18:16:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4D686B00AF; Mon, 21 Sep 2026 14:16:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFE936B00C8; Mon, 21 Sep 2026 14:16:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AED136B00C9; Mon, 21 Sep 2026 14:16:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 86C466B00AF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:16:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1EF4014025C
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 18:16:31 +0000 (UTC)
X-FDA: 85238574582.12.BD436D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 791BDC0003
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 18:16:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O3r8zX3r;
	spf=pass (imf10.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790014589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l4EJvxSj/BJsRSgpyFNvCVzIpp4EruN23HflkMWdmXY=;
	b=xtp25Uy9q61STsEfv/j0tiJOzc1IKA8cDB2o3ELAYHbGpgblp9F7R7zRBalvm+kxNduuhU
	KWe2/yry9C9EDa6zBRYjlp0tVBed+RbxvgA2jE2Ulb9u58UW9xIHEIr/5sJEPAYwCCG2Sf
	vOVUmWwTkHiFH6CshiHpg4Rboa+Ba6Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790014589;
	b=1TjQi9j1KQLb9O1ImFwnQlYtahvh5RUj0al/dirqKUqJszbG1wEPAQTrr/Ew23LW3Mpkqk
	Sw1jBXQtN0P67+5+2OssqIPLgktaddlFjtxNXo7B3ei2HYiM7I06qApVnreDakpxK/co6g
	GtU63L+fkY9FizTD0W57JaGrjUSsJH0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O3r8zX3r;
	spf=pass (imf10.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 90A0F43F8B;
	Mon, 21 Sep 2026 18:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5761F000FF;
	Mon, 21 Sep 2026 18:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790014588;
	bh=l4EJvxSj/BJsRSgpyFNvCVzIpp4EruN23HflkMWdmXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O3r8zX3rRAdTh0tZ7rs6DQexuLgO9QK0vtOA6kKeN8MadLlRZl/xbGDhgQW1w9lLr
	 RIMwyajFNVsPe+RnDMMptexa7Z+k3f+aK8i6Wlj37NMZ8VtcfTGeDp8IJNnoMqI8nf
	 23lATnS4SrmJdOkZpjKxmuDOeI3HwfpP3FYOgOLS4l1JlEoQ74ksPe2EPombWAmaub
	 i0BPGA2SU2TmTWn+l8hwAesNTCiAzu0AJTgWPzfgXmjRD4GY6zCyoW8sQAgFR2JOfZ
	 cSYaC5nq11ykUAUAqGSBD9FbdPahivlPZaQYvxyGMz4EVzYyXb85FpKYMU9aRTh/h8
	 ObdTOs2AVvpyA==
Message-ID: <7e555045eff532576b56daa4e023be1b@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Qiliang Yuan <odys.yuan@gmail.com>
Cc: christian.koenig@amd.com, ray.huang@amd.com, matthew.auld@intel.com,
 matthew.brost@intel.com, maarten.lankhorst@linux.intel.com,
 mripard@kernel.org, tzimmermann@suse.de, airlied@gmail.com,
 simona@ffwll.ch, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com,
 natalie.vock@gmx.de, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev,
 thomas.hellstrom@linux.intel.com, dri-devel@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v8] cgroup/dmem: implement dmem.high soft limit with
 proactive reclaim
Date: Mon, 21 Sep 2026 08:13:47 -1000
In-Reply-To: <20260921-feature-dmem-high-v8-1-6371fa83d6c3@gmail.com>
References: <20260921-feature-dmem-high-v8-1-6371fa83d6c3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: hk8q6d74dbpd94jap3iabx8a8fji5eim
X-Rspamd-Queue-Id: 791BDC0003
X-HE-Tag: 1790014589-163076
X-HE-Meta: U2FsdGVkX1826lhLP0HcIpcABCMIQDhD4xJSWWAAb9aSV5F2sOtEl9NoEl7QJo5ckncC5OljO8yios9GP/y5pwFqM6wQsaz1U0wL/s0loLRY0v3/qiYOVpiL7iXwDnzLKJsbj96yZoHY3ZOtDlM9QcaCgBH++d+oYAE1w9PIb5X4rV3mKUJS5AVqBNStHhNcXweeCKHdVEWxgC0OcGpUkNeFMmUege575cPQgMWoN7v+qlF4KEdaybQ+nCOyQbCW2t8acd9dmXx5++bTzUBgPKjePUP7F51sxX8pGhpiGKGAX90p3nJfUC7pTpH085JokiFh8Zq2xqVFOhubuOuMnp7lfJL1buue/H4FgXTsxgaVaQoNjuX3H5QijqoeNIPcBFXZ/Mn6+e7iWNQOCKLGfVFJxG5YSxCq/9YiUg4w6TjqcsExStZGdN2F/1cWEGwEzqzeYHkzenRel9d7fF2rCd68x/uyw8D8em7tyMLUINiO4h6NixLERWTLf92c0DwXZdICmnX8tqfsOUrMdjh7SeAQfPpZkN+msUAu6u8BK4mxHMOS7Zdz0/T4Qz497jjqEf5RmOX4SG2DwEbIUmEkYZ0Kqk1aXw2aXbXcs5w6hZq8J2eZccN43G2wk6iH/9HbLxL4Vgk913PCkd6eIhngZKxJFHfYC1sWirDz8fPpeOpZTrfKbytHB+pwcmNa9Xqzv4LA5heFN3q4+vnnsBm/VuN0Iaz2SKa8AQIK2HXRvH0AF39q1TIovruccyhKVj4ip6GF/2wAMMKdWnwgB7BxMc1XaqHlDgESEN3fn/f4SuHCXEgSf9eGa9nBhrzivHNymjhQXGSoh3FSrINnmIdCCYhqOZTMd0DoAWaOFNwI6HzodUKsZcNU7W9qF1eU4MssLJaX3ATGE2Ako8t8Qr/8jQGJAMxj5Y6oETtuFF2Qg4saPTyYSPJYtfCD0wIUIsPU5dfBmA6ASNe6tnOkp3j
 I8DJuTi4
 TJzcRPFikdHS2sX460QxmnYecmcZooNpVJTTB7gg2ISGwKNyQL6sl02L+u7nq8TrYa65dzEVbHPz2Y0A5xoq1+wVg+WoiRwk/kcRT1TM5tlFRPdp1QD1VAGpFl2z3AXORGqinVKKXmD32VNUBGjOt3rCHEjD0iAgX7/BOB2NU2sYqaJTVZCWACpcepJPqeorDuuLfEQmUvnbIjnAwvVEr0lVmXya4Os55e31oO/C/4WItr8uqn1NI92eMya1oiPeUp8WU+J22b86ETpmZWpaIoRs6ifwseh3/uqNp2nna2RqpbAsDcDpB8BqlSCWM9lcOLu/F0SSXncCjl8qeo20oYyRv+NcQMBNLDnvb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Mon, Sep 21, 2026 at 03:02:48PM +0800, Qiliang Yuan wrote:
> The dmem cgroup v2 controller only provides a hard "max" limit, which
> fails allocations outright once a cgroup's device memory usage hits
> its quota.  GPU-bound AI workloads need smoother over-subscription: a
> soft limit that applies backpressure through reclaim before the hard
> limit is hit.

That's not how max behaves. A max hit makes TTM evict and retry before the
allocation fails, and since 747c4bb450ad ("cgroup/dmem: Add reclaim
callback for lowering max below current usage") lowering max reclaims as
well. So the premise doesn't hold, and the patch doesn't show a concrete
case where max reclaim falls short and high would help. Without that,
there isn't enough justification for adding a new interface file.

Thanks.

--
tejun

