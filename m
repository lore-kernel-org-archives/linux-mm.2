Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4D36CD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 09:28:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA2DE6B0095; Tue, 12 May 2026 05:28:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D53CF6B0096; Tue, 12 May 2026 05:28:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6A9B6B0098; Tue, 12 May 2026 05:28:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B87926B0095
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:28:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1B338160433
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:28:28 +0000 (UTC)
X-FDA: 84758242296.27.095D561
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 65D74180007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:28:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qpi4KKNX;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778578106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FYduscr5QlVF6ZIksbhf6VDNAzqRqYlQtm90OnBKR4A=;
	b=kZrjPdIS5qw56puZ3UdjfM3qViRRfnVVFowHYtg8xPllXgPXl9GsL+BGrlGQA4JqapMFYP
	O3+UuMgZaOMa5vkhKdYO3clZtzVDdlbJi53abt5se0Unuq27pkH+lGiMAxEDV25InTXM4H
	q0JmYbazQmjh6z/b/SWvzgcUW6UvIs0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qpi4KKNX;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778578106; a=rsa-sha256;
	cv=none;
	b=xVj+h5F8z7+O42WE103MrievSaWejGGRbOq1cQS7gauCQP36VBRajpSjpRp18dQavKiJlI
	FC3wKxKkg48TBg4kIJyL3JW3Sft1BwN8f4mwNzxqaX7OoDQi0GLpDDn1f4l4oRypZuLnKs
	dHLob8O3xhVvx587oZ63oN5VxepwXuY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AECA6600CB;
	Tue, 12 May 2026 09:28:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E7CC2BCB0;
	Tue, 12 May 2026 09:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778578105;
	bh=0E5IxBKbz4u4hg2v2fd+BVV/esRQq2aK57wXBGGDo7g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Qpi4KKNXGcN58BJXlD58i5Xlxu6vbfqPhXibd9sFp/0BeN1+aY+vOK/C7xbEORQaN
	 FnguCTSycv3dR2Edh4bCbAsdRtGNZfITNUQbrjSg+xBlrbyRwP4HxtX7kMqFG7hnk2
	 ZCGA8oeP6h4wsfNS7+r/sueekLbwjyiaUMw1Ku6Ko258CF0sH8Hcc54/lMdR41A6e/
	 qNhiRD0kinDKblm8pQ50/n6nDC+G/dQ7Zd6oK7PEnyWgADOBXlcnV+oI8R7WumXMrY
	 tAcsQI9wexgSOWBDj+Xqo2q7xtfRNEkLmUke5JHFhIdB38YFbGUv5S2axnYAlcXoLV
	 oI5JXgBRH2brg==
Message-ID: <a27344e1-6f0c-4686-99ac-fc2cfcc5bb06@kernel.org>
Date: Tue, 12 May 2026 11:28:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] use vma locks for proc/pid/{smaps|numa_maps} reads
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org,
 willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de,
 shuah@kernel.org, hsukrut3@gmail.com, richard.weiyang@gmail.com,
 reddybalavignesh9979@gmail.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20260426062718.1238437-1-surenb@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260426062718.1238437-1-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 65D74180007
X-Stat-Signature: 3y5fq4uou3bjyoiio69y1681ebbe6dhw
X-HE-Tag: 1778578106-608361
X-HE-Meta: U2FsdGVkX18wKtDJQ7Uq6qvncC/LT3A9FkF34ueSEUXfcvXsAxh6ciYcG7B6wLTohlSm3RdykjqTwR/UyyUyxNe4q5eW61TYq+chS5Le1gDS0RDCfhb6XW7aG0MVLbQUe095YDxKRCPbfQOsHfr3AenJUkOayOrOB0OffD6GZtL405lDHB+OpzeXLpQCAz6e+2yaowWrzD8Duh06T/2Ufm6acx8ayD6qM2SQhJjFAUTfugtsOyBVs8ekhUaZXdXbwCO5jWGtDxcrpevthEoJpdm+HHBcro9huMcqcpkYaKE6IPBZcIQVUVsE4HdmmuqvqNLkqRQcnd4SGKhy8uT6NtJTMBuFBy7hN+5pZqjplERSIR0ZNCR7UrM3ujs6zC4XQUyUGcfHlp1SP0VhAWgo6QTgdxbwWWAcSMBO1vAdBcZ3+sCnlAaIpePEp30VXNXhtfUy6reuvWJ5ku6oQIFamncj4O3nt0k7ZR3rBEjlgYnIWTRI9Qoj5CfnHdtdyTd00nwMEVZbIvx2Yg7QicsML9JeP2TE+POLRkqeDDvwc9JHVZvtUIdtuW1AKaYF85ka+i7nLWB8b5QjUF6WFUsIaQLVbacbEA0LTnFUV72x61wRD14ku75FQduJhSsLpMFJmiEikSRor91y+BAkLoqYybWBzLufTNBdjjjUFTeO+HKhyJASHGHHK2G3vwjAWvXmHsbo+j2V3ZfXf+NFr4UGLc27U5Fw8uSolr0jFzgkOBGHiL6uvwS5pOO9l/eXYLNkpi1z+WT1hCDVZlNYikU/aMHfXLwPEU/KryQEMXeDqpb2feaZYjv4Fe6G0s4YmZYNwFxwfhjx6RyV1CdWYJe1mPhrPOzZO4HVhEGooQ1GijkGTIBYH3LB5RwX7cDJ8mynQS66NOsx5Ts5L/5iecG7mFq0d72IOusRHkS9LDYiXhCHYKganXMy//pvFDtMtOIhKVFzECSf9LfDS/pc6H3
 sSNDg1lK
 xzsFKmJTX7YDrd7j54dn19GnGuD0rWh2NuUOYyhU3QyniA4RhbOA5PT3plRt13bCALdLgcOzWkhWNIFiXfLaLbaxYlCrP7vOCNgocW1Mb+oml3Epdo/9G6CqviXCKtuzuPP8f/rKPgiIakjwdo+NjOUYEwwwI6znGNIVTRKTyc4gsPP1iNQYRUf/nkHWwvF06XM9dnu3AIk5UKJIxuZsSC2U6jPqngmcq4wpr7xS7psnkbVa0+rvvsGFEaSO0YntTJ5Natw8t45FicmVZyUBwL4soOFpH/3nSVzydtLwDd+J1FY4QMEovQwbF8VGZQv62uXqeaWFAiO9psZW68GB/LuhTMaDDFm65YqMjz/2vLUsmbe+9kPkBEapDHNhnn+j4OkEPbJKUdYbNyJRWfaWI7cfTww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/26/26 08:27, Suren Baghdasaryan wrote:
> Use per-vma locks when reading /proc/pid/smaps and /proc/pid/numa_maps
> similar to /proc/pid/maps to reduce contention on central mmap_lock. One
> major difference between maps and smaps/numa_maps reading is that the
> latter executes page table walk which can't be done under RCU due to a
> possibility of sleeping. Therefore we drop RCU read lock before this walk
> while keeping the VMA locked. After the walk we retake RCU read lock,
> reset VMA iterator and proceed with the next VMA.

With many small VMAs, is that overhead noticable?

-- 
Cheers,

David

