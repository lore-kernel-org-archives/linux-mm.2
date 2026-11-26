Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AC27606A692
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bkLM8O1n
Received: by kanga.kvack.org (Postfix)
	id 59CFD6B061D; Thu, 26 Nov 2026 06:23:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 574776B061E; Thu, 26 Nov 2026 06:23:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48A5B6B061F; Thu, 26 Nov 2026 06:23:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 229D86B061D
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:23:19 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1541A1C4ACA
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:23:16 +0000 (UTC)
X-FDA: 85477033992.02.3AFCB92
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5D122100007
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:23:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bkLM8O1n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795692194;
	b=Mqdnq/VbfR6tGltZgGrRYLZ7gH8ooeIboVZT+3aopZ/8hMrGGJJDzVSiwol8XjL0rZKgbZ
	tZiYYAIYQUbq5J41FsqgA5fQGD1HuOi2vM7U+FKhPj9BDD4ayrLhHgkovpcC/AUAb2V0yX
	rJrzrJI8sepohOmXvSZuTmfe7IvyVYg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795692194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a3e4QFsYpmZUFLHg70CxSmzC8v6zA8Z/lwmAeE9uapg=;
	b=jUVc7KhsFylKAGvPKOc891Am1ebSvRevMrStBB0CAB56UBekpEcDkN/fC5P3MSe4t7xT9D
	CiQTOd1foi+RxS3PEzXCKqCHSOvhjgHwR4nU2NUYNg+2p4F/bRaDqZU1KtaFaqEJBopscd
	hsSrhhL1Xj9Ut9mSmWvibh8ecPNXhfQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bkLM8O1n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 00F216203F;
	Thu, 26 Nov 2026 11:23:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3454E1F000D0;
	Thu, 26 Nov 2026 11:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795692193;
	bh=a3e4QFsYpmZUFLHg70CxSmzC8v6zA8Z/lwmAeE9uapg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bkLM8O1nLWkwNeVBdYvyyJjRi4HfmxZuIDs5FcqfJ2J9xoQ7jQ9+/vgszicJCwK0I
	 Ac4q6eTJvE759zpj2fIwEVgy0FvZxVn0RgO8uWztfeRvZQuGZObVEYCCXfTlmFBJ+/
	 rbIfa4nuxBcPZHfELP4LjM5YTCje82iIyZCIiL7q839LFx03b0AAo2b+dM00mfWMI2
	 rVJHZ+cmFiJ9tlRxs+OpDu2duGGopyiW8RAEj4h/E0eeFEimYVh4m4oIcbGDEJS2b8
	 yvRBerwjYSlAMjHkGPgLhdPFQK2urFY+X4e/3zkbBeK6DgHth2I2LBQvjE5dhckfUh
	 /xzwN4gl9EnUw==
Message-ID: <53788190-634b-4766-99ea-92f1b54c0964@kernel.org>
Date: Thu, 26 Nov 2026 12:23:06 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: check VMA end bounds in insert_pmd() and
 insert_pud()
To: Elkin Cruz <elkin@google.com>
Cc: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
 irogers@google.com, stable@vger.kernel.org
References: <20261125221911.1425213-1-elkin@google.com>
 <6afabd96-1888-43d2-9ccb-73ca6702a004@kernel.org>
 <CAC_6YktVNFdtDLsNHgPEy-8_2YfZ42mUsuXJ6OKkm=T7zFnxHg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAC_6YktVNFdtDLsNHgPEy-8_2YfZ42mUsuXJ6OKkm=T7zFnxHg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 46gibwxbdnbxqt5obx7ackkycj4ttou6
X-Rspamd-Queue-Id: 5D122100007
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795692194-754681
X-HE-Meta: U2FsdGVkX19CfR/kTq4v/9C86MDRaaPi2xLS5xu5rpj3rQ0FZowQ8ISG0Y4U7C5jbnZTj2WC1+CmeR9n79KBSHeZs8Pp2HjwapoHOtLGLNTSGTKSxm/YrrIIxbgoOJf8cNmm4bIY2CG35ywWN9PGIX+BrAiXfsKhDk1hJgwwvRdOUQp6rd+ay31AlJUFzo6jUVtQ0VY4DqkZ8Z2OqUlM4Hsedt0clo36MUAXhO5XhgsKSdS+/q04ePyLBfXR6v2qt+FEF3ToioEQsNMm1fRjQFcC1mtB0Cn2jsHbSba22lSQW+dBDxCjM1dmI/olSy68zwwkdWGseHmUYiZHM88hoR0rhYVQJgWLPDPXyhjI6E9rZURn0eVmIudOantadx3F80PmXrhrIF9GUPbPFIlICKudlOrZOlUG0iX3lUcEI7Ds9q84KgFdT0LKv/etByq8Wb5+TmiSvO6YPucjrie/goEEAhxRp3WVaDAwIQNcx1z5lSO4/XVYKo3zp+eStRpP4xRwfJjdM3cTXIHVa5mULbwNMi+pU9IRKpgm9t2uZc0d6s3wXhnt6nIcZynl/ROizoxrC4Wd/AUkrLr8Zm1dnzIs6qMY7fy+b6JNqZ6G3Ri5gnYzyp5p9Lchz4rmLoNbucbtJN6lh1LHU8DUIfryXe2nlpnrjoi7zN1uhDym6KB8YKUnnQAYmo6THA2pAK4fANt/N1S/jgy13FCmdGSAg8N18t5YfQ53bdvFUywimPdnFMsbOmQX2X+Rj9MGHgMDRbxwvv3HRQABr6cFLGhEymqtvAqCwduPvnNiSV0PutQ3d0OmG7o+jRnmrARcvmIfD+orLEGjteYWwIgnNTwyqAvXx3gV9GurTc2wXZS6I1DoykjGdDcJCQc19NPe+5fwS/xZ9ZyynhcOCtozlJpS1/NTMJmMTvI+2fj7ktVkwcbJ+h+yOdpRjcXrKsYZT5cxgnkhAlwXZg4GwUDPrVc
 OTVuC+ux
 4TTEenyGLi8BgY617uihbJ6Ziojzl06C7EfK1BzzvIgoFKKgunhvJRK80Ffqh3l9fnB0ddO7gUm4CwdevrZV+UCAM4s5k7w/DeF1dDwN3lYKFJEt7La4ALnzGPvZMxAttSpjcYkQhbj6a2qHrbdTzrtmrrGx7E/iYwQZKacKLOVZs9kBTAxhrKAys6GuiRMnwxnRwNUAzVKmOC1vZ9ux1mwV2OBfpPLFT9PsTVL3aOVAPIrA5g2/RulMVLVP7AcDIgO5YsvnAeV61S7rTDpW6VwnD09oc3t3hq+DXEh4+oeKbGw74s+Mv+B7rj6G2iLx0nbecJWIBe9O09vcNx48X4vRdjj8x7pVMw7chxRZiIZN1u0orKqZitrl78xfJ+rGKkxMg33QcBWSEwWp2k2RDKZC307JVskrL2VN96yi3FBkNzOBqXAJzYW7AdV+/4uicDi3B/hfdFkBDkeZN8CUxy5pzGWw1A9Hb5Y/OrG176FQc8FZjFnZP4+i56zHnO7mfHytg6OU0rtn3Q4Z1VI4g8HmprykOUTvnJTBZXT75zLkCry4b7Jk/MoIY9lCEtqjWPKksBsTXkA0B5XCe3aeK4BbVcPslvCxzHPdN66kREO82ZLY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/25/26 23:57, Elkin Cruz wrote:
> On Wed, Nov 25, 2026 at 2:40 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> 
>> Which users in the tree trigger this?
> 
> Very fair point. After a quick check, there are indeed no users in the
> tree that can trigger this.
> Back to the whiteboard. The linter is still too noisy. I will hold off
> sending any more patches :).
> 
> Please ignore/drop this patch.

In general, making code more robust is good. But then, please don't use Fixes:
or CC stable because that makes people think that there is an actual problem.

For the code here, couldn't we do something like

	if (addr < vma->vm_start ||
	    addr + HPAGE_PMD_SIZE >= vma->vm_end )

... not sure if we'd have to care about overflows.

-- 
Cheers,

David

