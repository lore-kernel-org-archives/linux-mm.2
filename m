Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D0AC606A32D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 08:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ihA1tRcN
Received: by kanga.kvack.org (Postfix)
	id 555C36B05B0; Fri,  6 Nov 2026 03:47:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50CD36B05B1; Fri,  6 Nov 2026 03:47:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41C946B05B2; Fri,  6 Nov 2026 03:47:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 25B956B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:47:11 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 10BF11C47DC
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:47:09 +0000 (UTC)
X-FDA: 85404064578.25.9E0A695
Received: from mta0.migadu.com (out-61.mta0.migadu.com [91.218.175.61])
	by imf19.hostedemail.com (Postfix) with ESMTP id F19B31A0002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:47:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ihA1tRcN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.61 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793954827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bod0wQ1Y32vzPfGkk+J190Ahz4pyqncpC1bhlTQSvU0=;
	b=PtCD7QHrISF+Z6c619mIQGtzf581+eoVFjIdLMOb1XkTZgRMtzFam8Z2xhuY3DReQWauPh
	F78JWGT2hKRYMfqKgsGMbmC4JPa4LesBTFkpHPREFuH11rfH435BcorUvtNNdWC1zLlxwR
	zRi4Qy59wb08A+eCA+D0DCL0z/JiAig=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ihA1tRcN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.61 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793954827;
	b=BnE7PBkbWVloOBn98JkGrxiM6eD3PtdOh9HwCUUTw1ybwBPqwgeUqmTNVmklSwlYfKm1Uu
	3LzpBQJP6tQeLcZkDGpP2vrMwfCDjL7/oet6JFCDK5qShW1aoZA1HkS9OTiZpAfCfP9GIe
	Kb/YCRgOhYHc6aAlTj3ynExY8omyAko=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=bg7AofrHyvpskABOf/lTzGvfabQ1puZ2h9SWe3RErvc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793954822; v=1; x=1794559622;
 b=ihA1tRcNLVdv6lSsQne+ICYc0kK/iiZZlg0LNl8bjCqjEX73LRgH6kZcLvkeE0foCEJXOS//
 Nkrbows8A4mNSdKJlz1sHRZzltFOTL+uLu0g7zRHX5TDcA2/oM9A9zguyj4Q5S5QC1vN9pDbpuS
 LSUS81liQEJHniQ0SBsi5peo=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 01fb3402e03e395c;
	Fri, 06 Nov 2026 08:47:02 +0000
X-Mizu-Trace-ID: 01fb3402e03e395c
X-Migadu-Flow: FLOW_OUT
Date: Fri, 6 Nov 2026 16:46:46 +0800
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
	david@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, chengming.zhou@linux.dev,
	liam@infradead.org, ljs@kernel.org, vbabka@kernel.org,
	jannh@google.com, pfalcato@suse.de, kees@kernel.org, ziy@nvidia.com,
	gourry@gourry.net, anthony.yznaga@oracle.com, linux-mm@kvack.org,
	wangkefeng.wang@huawei.com, sunnanyong@huawei.com
Subject: Re: [PATCH] mm/ksm: fix ksm_exit() deadlock on exec error path
Message-ID: <au2T9iCCt9VM2IxN@dgvxl46587.localhost.localdomain>
References: <20261106013906.2229780-1-tujinjiang@huawei.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261106013906.2229780-1-tujinjiang@huawei.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F19B31A0002
X-Stat-Signature: s7p1sdtrtc4xacews6ja3uegneck7k6o
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793954826-870199
X-HE-Meta: U2FsdGVkX1/M1APFLgvlyATW+vRKmyH1ZgMjp3jPpXkWf7BOb+7SMxQUCa8fuj7J+JEsTPkMU+0kMPod26UNpHx7dUUNTfoWZDmntU/LSFTZ2fY9GDIzGeb65SnB5HqkFAfrCuRn9X9qgYqhZ1PibQ8IjPY7vaOP6Ov/9XBBgRuQOuoWdvUdleaOL7klay58R+YpBm2Ds2KDmANdmdss25BCi10PQx21tjjeBWYJstmi//JwTv9wuk3EkpusnOlghT6yIL/Bn7otqPk35bp8xF9YtQBjRoSZ5HhxbBP8HgKxApVs6VUJcbIFCQ+L0jn0YcyGDXx5h0CvgmMi27U7s+5YFS22auNMp6clOnWLkgpxsQUIRSdK5mZhd6xQJPH80japvJ0vZ4r1HsrRJxoeh0yTAMhjEXlZZW0kD2v57fO8zi3HKQmDSDVASGiGCdxI6QOl3Vzd0JwSpFgektm2CqUMt3+gC7PLwqBCwUCIjtKg2p25XueVkWd8G2CB7AXvDEDsQpIElj5kfgBu9X7Yiz9lwLyg7n4diTplgDNht7545sY/Rw/H2EARevQQ90XIswZ+GD/E4p1kckoUM/LAgComRXXeQBZFuAXi5yfT0m9gn4Ak1qhOK5aAvopk+CNosEyEsyb5Oy/G0s5ApSkbYUhUAGfGAK/+Db1G/bBqtb16Cwgb6b2ju/UlJaxCykCwX7vBFdjbrurNBvISlIXBNZNTMAviELoONNi1OxChPgT3+usTEBSoHvzPOrmG0EPdmGgliSEXeNsGiZNoWIHLi9azCCrfz354GYnaixNSiqLd5uDiju3zJA3yHCv7rb/OWos18ijqtj5gcWSi4DBsvQN0diQddean02Qtt2z8PAEvdIV1JppxUD1h3BWbL3TJMb/U8ltLLjvaQLs5xZpaVM6L7FodOU12GZP+nioBk2844iNnyTooQhF3GjdHYtTjwA4NvP15SXk126taI0v
 MKvq4WfE
 d5BBldcCMOgZfdCEY/+0pV4jD0F34tI3qFlvjnodZQ2wRaBKDP4vQYpnA4EJ5azk+hg6SRZPr6GSM+XY8ay3mN2lnMt/dta3uip6AE1Jk3X4TUCsgKeOBlnegyMo+ZZ7+BQ2RosFzRG06s3Ld8vua/iUJaFvy9al3+Jh84/YhaadBJN+AEaCDSqaPZkJrfLljrKLOb96AYk8tRnnO+JSKn/72IzQZIMlXw3VWDrnfhfl52wb66CHEpK6OGokSJp4Rdo+J1BJDD/wXv0CvhYrP3mjaKg0ifSz1dTv5uaoZBTUGhapv9EIO3WRHeQWGgHSDI3mqdluivS+gDCBfcXvJl4LnNTYghhg0HHRFuRLHbJzs6eoxO90mEvSUyVYVI5/jEYpRZRFXZEhw/KQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 09:39:06AM +0800, Jinjiang Tu wrote:
> create_init_stack_vma() registers the new mm with ksmd via ksm_execve()
> while holding mmap_write_lock(), and calls ksm_exit() before dropping the
> lock. When insert_vm_struct() fails, __ksm_exit() takes mmap_write_lock()
> again when the mm is ksmd's current scan cursor, leading to deadlock.
> 
> The early registration is no longer needed after commit 590c03ca6a3f
> ("mm/ksm: fix exec/fork inheritance support for prctl"). ksm_vma_flags()
> calls __ksm_enter() when the first mergeable VMA is created. Remove
> ksm_execve() and its stubs.
> 
> Tested with ksm_functional_tests, all tests pass.
> 
> Fixes: 3a9e567ca45f ("mm/ksm: fix ksm exec support for prctl")
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>

Need to Cc stable@vger.kernel.org ？

