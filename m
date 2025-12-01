Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66B58D116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 20:10:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68D5D6B000E; Mon,  1 Dec 2025 15:10:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 664D56B00A1; Mon,  1 Dec 2025 15:10:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A2D76B00A3; Mon,  1 Dec 2025 15:10:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4943A6B000E
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 15:10:49 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8CADB160373
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 20:10:45 +0000 (UTC)
X-FDA: 84171995250.23.424F58F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id BD0AA80020
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 20:10:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F1QVgUHM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764619843; a=rsa-sha256;
	cv=none;
	b=d844CjFaxTF+s8s+VCkeCfymk36sBUoEVOSpnT4pCDKjWFHEj3hnS5Zb9jUkhnJ9WBucxq
	EXJSb4AHwTziMm3yajvua9CkVTZJCUAcnJPtFbvBLCNnJas4Ww9zGvr1tBeY3FBTw9rMor
	80e0HElO4wM2FOdWYHWfMQWo2y+i4O0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F1QVgUHM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764619843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h3WYZwZcLtffrJyG06B/Dept5KwTM1Pet89eDvzETi4=;
	b=mEh0jXC+6yhtg9981jVp9tMM+bL+mwjFJr+8KBLFHscHhI9i4ImekvsvCwHAdL9y6lqt6H
	BWkmV6LeNjPlQnyU2m3YC1S13WgJW0yceMJfUxFGxR+TJ1wIeSaNP09PIQznCKFePnPcCz
	WAfb2PuEV3OecENmoKGclzCjNaL9zHU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6931542A57;
	Mon,  1 Dec 2025 20:10:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A0DC4CEF1;
	Mon,  1 Dec 2025 20:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764619842;
	bh=hoZr9ZDqrSasGQq9xDqBsQud6miZ87nkO1FhX8K27vc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=F1QVgUHMWRD99MrQdXIUYwpvo8wZMIhpPmXAQZoBiJfHgVYuQUXLMhLU17qdMQEi0
	 NZy1bOijLnnaFdsm89ArW2j4zCra6sxNc2nik11uGWKeTo5KwTxTnS+cOKXB3U2LR2
	 tjTfN/oHANb0DRigoVJ0hNLCEPkmaZbNDhagE+6nPnLByxcv/4jKfW56kF8ROYiTSP
	 1LEaYjIFbzKYK8LXluqCMvdB3x9GcCehti4X37rq2C1gF5ju2VYoqUuISlkOtO+1My
	 KWOEL2xibAh6obECR7KhRg2eNpGswQtmO2brUCDPs1BrVkqdWr7VUXa4LuSrEiQOOp
	 tZ+DtTsqQsv+w==
Message-ID: <dcccdc4b-b7d7-47c4-b1b1-a6c70edb20fa@kernel.org>
Date: Mon, 1 Dec 2025 21:10:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/4] mm: Add support for unaccepted memory hotplug
To: Borislav Petkov <bp@alien8.de>
Cc: Kiryl Shutsemau <kas@kernel.org>, "Pratik R. Sampat" <prsampat@amd.com>,
 linux-mm@kvack.org, linux-coco@lists.linux.dev, linux-efi@vger.kernel.org,
 x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
 mingo@redhat.com, dave.hansen@linux.intel.com, ardb@kernel.org,
 akpm@linux-foundation.org, osalvador@suse.de, thomas.lendacky@amd.com,
 michael.roth@amd.com
References: <20251125175753.1428857-3-prsampat@amd.com>
 <66ylzwknm4ftd6utn3nqr63jmhl2ccvcdvyi5fechfnvmfxivu@37pckhjixayh>
 <20251126223127.GIaSd_v7juUkaW4RTA@fat_crate.local>
 <m3l6gcjmbabudtnqwv6w67t7iz2mpmbjyrpnmiq5k2iyargn5d@nyf2zzxx7yme>
 <20251127181233.GBaSiUkaLzwANS_6WT@fat_crate.local>
 <beec5651-5c23-4f5e-a0a3-d1cc01a8490a@kernel.org>
 <20251128113411.GAaSmIs0kSWGhCYkaA@fat_crate.local>
 <47927c25-a317-488a-823f-ac0588f4eee4@kernel.org>
 <20251201111201.GAaS14AX18qeHN20xf@fat_crate.local>
 <052d7f47-edb6-4978-bc9a-c7eae469720f@kernel.org>
 <20251201191036.GEaS3oLBY8PEuE91Ap@fat_crate.local>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251201191036.GEaS3oLBY8PEuE91Ap@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BD0AA80020
X-Stat-Signature: q7snb3d8dknib3845nurgs9iwdhjhbub
X-Rspam-User: 
X-HE-Tag: 1764619843-321664
X-HE-Meta: U2FsdGVkX1/lFvxXf5iVoFqoQI3adkz8L2xIGMJaM14O4lYbgoe2iTskIowY6GsTWt9QbrOQtPMPUBf69ASbl/DURUjXaS18g9c3B5EuyNRqCopEoZlON6RVWYWAdEd7W05flg1XY+qqbL9xiOXbxGUzT+i98N+pO/UYSeMu8/g333Ngo8P5WofeK5zLF8+JMvFRWFPHD0kVO0VR8hpyT1/iVicJx5vT38f0CTvmYC2Uj80bTZJAI8eJd6EZXsqG0avHaJqKZOmGrr24BTwP5uVIoJ3AlHrZ7p2H78LTTecutXj3hil4XUllovmk+0Bwacro0qY0L+F/QvYojaOMivn/jKDEmWabHEi+eAoYKyUNQ0ebX7kjLBjnZNuBvR7u3+rY5cjLWqvGQ8W6fE/XmRZwNHMa5JCjpt1Iddzi/X1U56THKt++zjRda1wjQDjgNAvLT+spaIxCyagQyCB0lnRDGkoHxq+BJDMukvl4s1Nany6l8JI5vEIzKuf8AyXgYTX1QT9I+S78E46ATCHLkoHY4i5JljIw0VFxmJ/yHRiyFJ5Yqvi6gN5ymLQY36zaseH7Vsxj2CSiwa6JN8E39BDVrymsxEW2s3jjjy9z8XuLMDDMVY0dHQcL0k2ichw5vs9RAtU86P8ABrMyvoKDkUP0rlru8PkGePxt4/zqLNHbc3sUryck+RvWeJ0jG37OH1nIIBNrWr9UzRRTNhft4JJzGk0zPImhnCILe8alSooffBL/XdxhvQDFH+S+0BgV9zxJnh7jsFXOzHj0dL8zD6WHhVEBpWZTpFhSw0NLOYnxg2FV0L8i7AWwydOyZ4YWvC9gQnQFq106CYq5pdQui6+jKKBe2XZ8cDrzyJEC5Iuu6hA/VrvXRXRJ2IvCirRxmzJdgPOvm69EoqT/by54960PpFYuZblub365ZJtgzmtlZwHnz7gOWxMIiWy9VNeqoPDuHzm1wxml1prbbfZ
 mkqws/IS
 7QAzUlST1cT6t0zkggIEFcYIzVqeqw9jFVgfIOog+Iql1MBK+gvNTaDi5jFBh6xWujTp+84dD0WNkHCNY/99Ir36u1AYC6ibQCaR31fXV+nSnxtTXX9vLUT9Flesgi90W6mvZwCnu41z2J/xlhRNsa2nCk92xYshC5yxMYI3V8zAcGObSu7BUYFtTY7FUl4DlIwv1yWQhCJsS+ZjGDN825fc5F0xUycqOAI8eIlvs6yL1/fBd8sTlzXxBihGOI0qoHqOO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/1/25 20:10, Borislav Petkov wrote:
> On Mon, Dec 01, 2025 at 07:32:38PM +0100, David Hildenbrand (Red Hat) wrote:
>> I think we are in agreement: from what I recall, this software contract used to be
>> rather simple and stable.
> 
> Ok, please point me to the *explicit* document in our tree which says: "we
> won't break the kernel and support kexec with any kernel version"?

Just to be clear, I don't think it exist and also I don't think that it 
should exist.

> 
> Something ala Documentation/process/stable-api-nonsense.rst
> 
> Which says things like:
> 
> "Assuming that we had a stable kernel source interface for the kernel,
> a binary interface would naturally happen too, right?  Wrong."
> 
> Which I read as a "no" to the kexec question too.
> 
> IOW, it is not about whether it works or not - it is about enforcing that.

Agreed.

-- 
Cheers

David

