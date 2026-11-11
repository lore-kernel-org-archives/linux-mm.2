Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BCF7606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 09:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FmhZfTAo
Received: by kanga.kvack.org (Postfix)
	id 3F4786B05D2; Wed, 11 Nov 2026 04:36:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CE656B05D3; Wed, 11 Nov 2026 04:36:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E35F6B05D4; Wed, 11 Nov 2026 04:36:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F25036B05D2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:36:54 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9049CA024C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:36:54 +0000 (UTC)
X-FDA: 85422333948.18.71AE876
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id BF64F140009
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:36:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FmhZfTAo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794389812;
	b=YhDMw5IheCgZ4w4cK2mIfpnsoxRxuE+8pneGaamH4DEQTvCXwdFiRbCNL9pidxJ1wk4nLf
	2D5R+ZfcQwKdDHHxiApWBhsqQB81UZ2SFC2PvQwEkWXBCsVptFDYpMibFAoHGr4MRSTjSe
	iwuMF5vjY+zEFPCbZwuIvJevBfYlkxk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794389812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lO99n0mBXUzzZNB3zbmr0k9smIe/f8UwSrXdGVcTzcQ=;
	b=yYWm0DcH+TI2yn6TUErXVdvgmWpczD2ow5AmWDUTsWSItcgrtLpOn/0BYLxFgEG9/2ESnS
	AWwTOkI0PuF4k/Y/W3RKqfWyPSMI5P9c7peuL9GYLOSrLLx2EAs7FTA6CXWDXk+kT16GCm
	i8gP2ox9pV181LUilG9IdTwAibze6SI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FmhZfTAo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 645FC608FB;
	Wed, 11 Nov 2026 09:36:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E41A1F00A05;
	Wed, 11 Nov 2026 09:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794389812;
	bh=lO99n0mBXUzzZNB3zbmr0k9smIe/f8UwSrXdGVcTzcQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FmhZfTAo1X3X3nFSSyzD8frnc24Y9FbVvba8A95uU6qmtT5PRbmLfFC7voQTFDjkX
	 hCNouXYuHBhZH1e41jreW3yR5nJUJGcyVoBwH80C7Xvg7qsmjz3apEnn31zvJgzHtF
	 ZiFQTydKCmtQlmlryMiEQJoMK59Xl+9kgai1vaBuWoMIqZdmf7sMsb41/JBCjmIzeR
	 ff+hsJtKrJrVcqCXzHPa73frEXjQMVTENjEYDK+4jl1YcN9a0crZoi8aGQgo1Gh+DU
	 qjV0eJZQENUMAFAFXbpEhIPJwSJ0IJ4l1VxOhgHx+X13U0kTeEvyK33AbKfmrxmWsH
	 BiK7CCEW3H4UA==
Message-ID: <16cf88a0-6652-4276-95fb-12306e417701@kernel.org>
Date: Wed, 11 Nov 2026 10:36:40 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/highmem: refuse to copy hwpoisoned folios in the
 !copy_mc fallbacks
To: Yuanhe Shu <xiangzao@linux.alibaba.com>, akpm@linux-foundation.org
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>,
 Kaitao Cheng <kaitao.cheng@linux.dev>, "Garg, Shivank" <shivankg@amd.com>,
 vbabka@kernel.org, ljs@kernel.org, liam@infradead.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, linmiaohe@huawei.com,
 nao.horiguchi@gmail.com, ziy@nvidia.com, wangkefeng.wang@huawei.com,
 tujinjiang@huawei.com, mgorman@techsingularity.net, chengkaitao@kylinos.cn,
 muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>
References: <20261110112641.1196786-1-xiangzao@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261110112641.1196786-1-xiangzao@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BF64F140009
X-Rspamd-Server: rspam12
X-Stat-Signature: 8dxrguw8dyq6gy4w385k33us36f1dmjq
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794389812-776724
X-HE-Meta: U2FsdGVkX18s5Fb2OkfHCpyVOpjuIidi+NGPBWRdOk8OsFlOq8R4kQj2O34J4YvcSJNpXMdAYU77U83HMk5Pje0ycXgn9exrVBRt8iS7QK/rdADWSIKc1qlG474MugVjGmDIjjZOHv3VT+aRIXZ04cvKgofm0NEd8M2cRi0hXdSSGjfsUMrzOtGo8tJ8eFZyrxZG8JXKWMFHH4j0lr2GNxmaYDUDw0s853kLnmXJcWOYwly1P7sq/lxNzMm9np3Y8o3HcTas6/Z0mSp8SbtoajZAtfR0u4nY3LbrNXbKNNCDlCSSNL89S+eAsi+RxZ1/oA6h88O607WK1/7EvA13Rp/goftwRD7zEq/IDSPqW6ImLmakdz1o5tz2utlHkwuPdKVzZbts+g/Zo22I5SEQudnEe4FErHwkYmnDZxdpjm7q5Ykt8rlEyeZdEd/PV0J4NAkkP7IHjGfq2Lp5/tQ8fa+ohZgzTTuJIUz39yvouzYii9kkXWiH1ST8cQUx4LLbkRsHOnebsyBzQPL1Dcv0HGOBK7NOKuXF3VcQCcMOLrZptScELaW3Jilej2wba9KCLPn4uyo7mp+lQXbJJdFe+hyBz0ayiwv8FK7+yxndlUb/1QnKzDueBrT4gYpweoo0BJmXyDaSZ5Nm1f6G0JLpt5rc9PvP8n3iAiH3n9zVw6zPqSUzJs27IAN6ItlAX36jofTi4mRNyJgaM6wdc7RRIbDsz8f1JB70vnQjNjzsIyXyEBR4VjPs/Ep6PLXljX3iKWDfN9ZsZX9pL4agMI8WmkN7/aKb1Z/UBMJBjWVaWZaWQVzV37zkU8cObLPnnPjMZXpoGfQ3zS87UeZFL5VY0PMtxeFsXmQtzQWRlabuWzCZhiIoaAtZd9gxTfUeMaCdJLASkEgep3kvC6cfq68cxob7hJiUkzRy7z8B7zr97dZ7fSvSykbzV/Tn5accPj14WpfG5RZXSkZGevudlyG
 3MMSoXfV
 /Bp9AFbDnPwXdStA9TIhhpu6mfLekki/lpXVamKhDCSMd5hF0WxXMbvlMrjEgBoCRQ1TIcDphU1OLeJ60LLN1b/TePkU0q65vxSKc/5ftFrLHw4qfwd6LmoyN3E2gPUhcKpCiyholQfA43dPaomsPyb9mze/AjyEGkQoIgantrPvK2uQp0WH4aMVGf7esGj6RyPLR9Xq7T/Ei/IGfg9vuDErZWhdvOR+LoS/8hkSIf99KUfew+iM4ceiTbc/JpDIn3KsC9/IM4mWQzzaFXhRLb5YkJVA92FXgyZHb8jawScDTW+n/4Pia5IT0uCwJA+564xM+UK69TcX8rNvxcY7btOstSO6johkwOYSnPo4yVBvZoG2z22czAOO1J5Kp/Nk81ch6q84W9sWeRIbnMfvqoosZrQxDruYvv5yMiElpV5PLIU9LwG7BPlY923QmdI+87byeL63loDj9nHzM6FgxV8yjYQhYPgAnSKFROF3enYogYxBOVEeeZRpMOmZSfrpHeea8GeVsVDd2DV9eoSsQ8GFRvtolmxYJ9ygya/d2uDfnvMGJnDaCFqSilbiF8rV6uVPj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 12:26, Yuanhe Shu wrote:

While the file touches highmem.h, this really isn't about highmem at all, right?

This really affects any architecture except the ones that define
copy_mc_to_kernel (x86+powerpc).

Or am I missing something? Would be good to clarify that.

> The !copy_mc fallbacks of copy_mc_user_highpage() and
> copy_mc_highpage() return 0 after a plain copy.  With PG_hwpoison
> set while the data stays readable, there is no fault to recover
> from: the copy completes, the destination folio carries no poison
> marker, and the poison is consumed silently.
> 
> Check the source page with is_page_hwpoison() in both fallbacks,
> before the copy, and return PAGE_SIZE, the not-copied-bytes
> convention of the real copy_mc paths, so the callers take their
> existing error paths.  On archs with copy_mc this code does not
> compile.
> 
> Measured on arm64, where the fallback code compiles: a
> kernel-space microbenchmark measures 90.00 ns per copy before the
> patch and 90.71 ns after, 0.8% of the copy itself.

CCing Catalin. I'm surprised that arm64 cannot recover from a copy from a
hwpoisoned page.


-- 
Cheers,

David

