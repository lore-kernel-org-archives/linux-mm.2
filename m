Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96C74C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 08:52:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 978346B0093; Wed, 19 Aug 2026 04:52:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 929166B0095; Wed, 19 Aug 2026 04:52:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83E266B0098; Wed, 19 Aug 2026 04:52:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5F9C46B0093
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 04:52:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5EC91A04B9
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 08:52:22 +0000 (UTC)
X-FDA: 85117402524.08.ED7EDB4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 93F0D140004
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 08:52:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lcPJ0O2C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787129540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jZI4offE5WoxR6EMeCVcpsyDREl1sgoUCN9PBz2GkfM=;
	b=tgCeY5bxyHr5pLP2bBDuPsdMfPtSsYlWregvZc24AMLx/qLrzzoFTb/N1AjP03QbWAYeBq
	hcvBK3MQ8OP1NUx+MHL94z6Vu0dHLEIfXrZ0NR3u8TOq9X8R5NYio4jmHy7e9JAfLkf7gi
	HFtSmYd4R0G136LCC4ZcVVZcqBHW4CE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lcPJ0O2C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787129540;
	b=sices2CDk5tHIWotOqyfvFFQXx46dH+f77i1EiyhKUrJ7KS2oEYiCpXbASZFutmP3RvAff
	30bldQpiHvYTxdYoNBjlUCnG/XP89NM9Z2Lu2HN7/N0UR7TCUGc5OjCsLiAP+ETnlQ8sRm
	hYHBT18Z3kbh9YvnbMz0dQMaD/j6Cg4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D4AE6020E;
	Wed, 19 Aug 2026 08:52:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1501F000E9;
	Wed, 19 Aug 2026 08:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787129539;
	bh=jZI4offE5WoxR6EMeCVcpsyDREl1sgoUCN9PBz2GkfM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lcPJ0O2CtA4m74gXkH/+Iyua7pASmkdKrnCwlXwSWNuTLcOUBk62ZfzhZSzhE80IF
	 +WCy+AMjcf40XHPXFilSdUxHh+IS++czStwkvZmFu8pcvYMwIHhTPBPyCXsKvbIDHU
	 X2IAwPa7fu26g+beKAjFvJi4H9CRas0KKzKYmO9xca3+OXB9cLr3CgKz4X1ENmjdy2
	 0Y6RXFVO7JbTXxzTs/MnxAPiVsxolveaZ4DHt4yiCPBm60+m/oHWpgtVsi653VYcLK
	 oV7eDkbWwKO2G2BEX9NPH1glf3jkHoTEgUau0yYuMDIsk+RCgaM2BOxAR4AfcR/tw9
	 hvoPaoF7d3VAQ==
Message-ID: <206cb1f2-b66c-4b7b-b0ad-14cca9d8e0bd@kernel.org>
Date: Wed, 19 Aug 2026 10:52:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/hugetlb: do not dissolve gigantic pages without
 runtime support
To: Longlong Xia <xialonglong2025@163.com>, muchun.song@linux.dev,
 osalvador@suse.de, akpm@linux-foundation.org
Cc: mike.kravetz@oracle.com, mhocko@suse.com, linmiaohe@huawei.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Longlong Xia <xialonglong@kylinos.cn>
References: <20260817162039.1511838-1-xialonglong2025@163.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260817162039.1511838-1-xialonglong2025@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: f4y45qhiu7m67k3t4gsrncdihxcb6a75
X-Rspamd-Queue-Id: 93F0D140004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787129540-347621
X-HE-Meta: U2FsdGVkX194zAqEsCFuQNBS6V1upIuSaKB1as872YOKTUqt5G2JsrddqOMqh9gt4o1N6lgfTAtnQMh9kxvFw59rV1mxqWLFP0B6Q4CDvdD1iGP9I4rrqu5mNELPdbarcj7MFlQsmWUPzkmENyWkQ/QcLcDHBrtZ3sbjd88dVvZjiTdtRQ+C6xW4YaOxaffzLPyEpSVdaOy1ReYItWOKxKIyovMggtJhP8auuU877r/rxMnxptwTEip1xE+NiL79pB4CGtpm+pP96vrsF21eXdSRvvAmu3dUnEJ2N9KTBndUwmzRLQgRNAq8vkPrftLMb3SF/cepnXj2B86PyCkTfY+tnD4L0iYy2a6lyFJOjIp1A/HBxu0Avk4IB0la+g/NMvBxjllo6GXGfjRyEykWzjqay8i78cW4eBxRpXEyvj04dA9HYMfs1w+waV3qvElOmB4eDIiFSkMix13C7kPgMfjfZ7XZpa6dZpVsNtFUXlLBDKvPj6fKsv9mBNQ8ezBa+zi8dA1Iw16nuz0IrMv9lXUpFwSSFoByhUxIxkMMbQuaeJC8lIIafNyy0IDrPv/j2YAYBn6Ostcwlw7GCj0VppP2uXFGLPZzJ1C6NP5DtBLMCRgrZcgTkeBMLCWaNZYabVypuNMe96rolG1w/1pgnu1TlJI0RG7oWR7s8Zp33oOfwzCZLE5rJCMIOjhZCXr2OWY0svOeM8Q0QgJ2Z6IoUfrRWY7vbntXa4ZoZvOBQ0zeb0Pk+dlpt2mEXTojIa7P8ro1U5/BJL74HBTSBhgi8DxxnA93LOH5GKJ6DvdCCsqLyu6WmDe2omqy6hWh82XTul5mJAtNiJIDBO8gsp0C+mnseE+RFeAyaZu7oaXW02OIDomWDtV6MW1bpPdKlS08qBuUBpZqX93q/TTSgRyGDzfg5+k1EYylk5RYwWSudgS3qwiE7KHE29TqhLUc++KVH48+z8tTmCMYu2Ojyh+
 riSmlC47
 y5xaAdw2s1opEwzFJDBVYlYyCE21Rl5pRnMXbT/ON8nH17YVjBQGzy1QIw+n9pOAnXXhijdpv2VG3D1M5FmxQeh/Vz62N1TXRo0s0EQoiOp1b63Av+UBBhMmRcpjLZIm4DXOQGOY6OCP/DFYvBQkNgec1EUTUfE9Ca/Qz6E0ilX/j0pd7V4tOaNp5HC9Ri44wKGuFn8hQ7oVrIQecjkpoRoD6ReYuDDZwiLYhDxbZbysxEsA1OPWpDW0ERl0nsUA3Q631
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/17/26 18:20, Longlong Xia wrote:
> From: Longlong Xia <xialonglong@kylinos.cn>
> 
> dissolve_free_hugetlb_folio() doesn't check hstate_is_gigantic_no_runtime(h)
> though remove_hugetlb_folio()/update_and_free_hugetlb_folio() silently
> bail for such folios

That's odd. Why do they silently skip such folios instead of warning that
something unexpected is happening?

This screams for a cleanup unless I am missing something :)

-- 
Cheers,

David

