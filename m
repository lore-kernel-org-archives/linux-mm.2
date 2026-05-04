Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95A69FF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 08:50:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 084316B00A1; Mon,  4 May 2026 04:50:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00DB16B00A3; Mon,  4 May 2026 04:50:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3DEA6B00A4; Mon,  4 May 2026 04:50:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D463C6B00A1
	for <linux-mm@kvack.org>; Mon,  4 May 2026 04:50:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7CD2EC1AED
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:50:27 +0000 (UTC)
X-FDA: 84729116094.03.9AF77BA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3C8B3140010
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:50:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vugjd43c;
	spf=pass (imf26.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777884625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rCGUloykHYiuCuZEtw9fiqIuDOMh4v9mTor+YU1AuXs=;
	b=AejHM74J5IhNd9hKVtG6Joe4EHhxqilUipeS6veDLTP5j/QfVVfmE6FiH7deXxNfD5GcJP
	6UcKYVJrRVl4Ce1G1cXwVjBrrVReK+ZkuiWkJwMV/2UAWrxhU4lYESKTdft6HdlpANLWbd
	tUAAeyJkf+whXfbm/i+1dk2XJimWJSE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vugjd43c;
	spf=pass (imf26.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777884625; a=rsa-sha256;
	cv=none;
	b=Uu5QMfg74hbOgBLGl9m4PCapWl7+ZYqc2pAz2c6/xWDGe+T++0fBkWFBHRLGPVq9BNQ7EU
	st6j/gUS2H4Per6YWe0cbF8J6jAVC6DibTEXMNTkS0MKhF9D8AcTycV7jyZoTk8IAR6gyz
	Q3CrZ+Vjlh+8P8yd64jcVXYutevLqeY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A83531713;
	Mon,  4 May 2026 01:50:18 -0700 (PDT)
Received: from [10.57.34.72] (unknown [10.57.34.72])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C6D133F763;
	Mon,  4 May 2026 01:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777884624; bh=FCMkZ9hkweao0c59LeiVz688RdDZQ8lSc3hEZVLOErk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vugjd43cPy1s2or/IKdw/90It0UtXRePbtH549/6cttjMFAgm9Gdw5rlF0k8TrWC0
	 6z8xwVelspAzl3e+lQ+ekhrPmZ5vMU0D9K2Wl9nCbaJCCexBDwY0/8LBrXBEpFJPOf
	 gEIFSygQ8vdYubxqMBnzuD3iSgcy8OysDOF8lTgQ=
Message-ID: <49eb450b-0045-4add-b993-a8b518514c34@arm.com>
Date: Mon, 4 May 2026 10:50:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 12/15] arm64: mm: Map the kernel data/bss read-only in
 the linear map
To: Ard Biesheuvel <ardb@kernel.org>, Ard Biesheuvel <ardb+git@google.com>,
 linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>,
 Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-hardening@vger.kernel.org
References: <20260427153416.2103979-17-ardb+git@google.com>
 <20260427153416.2103979-29-ardb+git@google.com>
 <a8740f95-e167-48ae-ae65-97c6701d9c94@arm.com>
 <9ff1d19d-f3f8-4106-aeeb-66c4c21742b9@app.fastmail.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <9ff1d19d-f3f8-4106-aeeb-66c4c21742b9@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3C8B3140010
X-Stat-Signature: m766kqybcnjsjgyqgosot3hopygkpa4y
X-HE-Tag: 1777884624-464513
X-HE-Meta: U2FsdGVkX1+qleU1Rcf/s4EliokZf0lpTFooY7cqfXgPFWWWTVVCFN+zUYZI2Fdrv03NaZbyTDwryuEtvAeYUl2/PgSfMfF06pJk4b8KCW4FxKzAIIlb82sxVF25+NPdARtixMr577kZiDEAc0AlvwXmCdvXDdQfSFQfIu1GYe0P8sqicRv7gpbVoqjSjitaWz3I19Dca2vagb14xkg6nzNAvw9pe+FdnFuLgaSCLd9hU7eBcdJ0Us8QuBfzJNljLUs8fe0hLwgAhLk3+b/B/DJ7qMUboXNUjVjg68l4EEoWlvkuFr0IzDHXjPwbYptzA/U2HIbIfAUCQIKrUiJxGMGVI0RKX9tkaoGmaZURmWXY8WfeP/yWFQM3aIlZyUxiV5M0FKSFz2GLUK/RlJ8Ymlw42RV6y39Tcsz0DzBsSnZXoLI4Uahhjc4zM+RHIX1HlDS/eOXJmUPCk9dLnh9D8fySmiw4qjhiXPCZgLCVbD8kScWkq/bSNG+dJbmaiVgTOb6cKKd1zmkX+Fsq5CdFcTResY9B84Fx+W0+0Wm9lMEgt2e+qf2RyIFb5Ky2jm+4ajG/6KZUYF9YzItRIn/5y95Tkcx5M/vxUFbwK0J6a9KZAVP+GFdul26O87al696A7PxOnSfeV83fDoycZfb/wqjPfqx2R4dfS4jB2x69N6JX6/wyGj3RWMbfTwyAXC6Um/tl7QFm59gXDn73MzF8n2/Ir5ra3jZd4k8/CoKIzs5YJZRBjQuMLarCyUfWDwwunBMR8FsA+Fk74VVA6yFLrrgXIJjAehT3L1ysCn8aHnyU2xuVnSCSEsP5CAF6tOPpsi+oQHBdUJuQSdyUijhe2+bG5xAelfGhSHgI++9ZLVDTBaGno5mhfFIGMLSdtwYRw35abnFBXa3htxTsFG33EuKapOMYSK37LTYNIXlH6bqeilW64CfbSATvf4uHhN2h1iDwpEeV9eX8+19Hu3E
 q7NUnts/
 SIV284ZontiQ5i0YZ0GNXegIxm2LjbDxLGZaRWR9RJ3spCTBqUOyZMBiQ9fCKKRTJi3uk9L9YaN17yQ1zQqWi/oM7PQrHSgEdIgHYRvP6nEUzP+qnHjUo7ftQCSB1Y3a0ZbM3AnVCjzh8OPxYJ0ujLY5VC2cOgf0ZlQJrZEfOZVHv3hfIi/JFNYIhHuQyAGBJvID9QCeH2k6kUP9yh6Mp1D8H8gH2/VjJ84YicVGVdjdbrZUJZVtNNe6s/UgTJ3Kg5fxGvU73Ejan+ao6I/lTp4XA/94mxJ/HLk6uF99hoRyio1NGx0Q9Ju7b+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29/04/2026 16:46, Ard Biesheuvel wrote:
>>> @@ -1155,7 +1157,11 @@ static void __init map_mem(void)
>>>  	 * of the region accessible to subsystems such as hibernate,
>>>  	 * but protects it from inadvertent modification or execution.
>>>  	 */
>>> -	__map_memblock(kernel_start, kernel_end, pgprot_tagged(PAGE_KERNEL),
>>> +	__map_memblock(kernel_start, init_begin, pgprot_tagged(PAGE_KERNEL),
>>> +		       flags);
>>> +
>>> +	/* Map the kernel data/bss so it can be remapped later */
>>> +	__map_memblock(init_end, kernel_end, pgprot_tagged(PAGE_KERNEL),
>> Maybe I'm missing something obvious, but considering patch 3/4 couldn't
>> we directly map the range RO here?
>>
> After 3/4, __map_memblock() will no longer combine new mappings with existing
> ones into block mappings or contiguous ranges. However, it will still set the
> requested type and permission attributes on the entire range, and so the second
> invocation is needed to restore the read-only bit.
>
> IOW, we could also map it read-only twice, the result would be the same, but the
> second call is still needed.

Got it, thanks.

- Kevin

