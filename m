Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63CEACD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:45:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9CAB6B00B2; Mon,  8 Jun 2026 04:45:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4DBC6B00BD; Mon,  8 Jun 2026 04:45:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3C4D6B00DC; Mon,  8 Jun 2026 04:45:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A3DFA6B00B2
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:45:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 46FE11209E4
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:45:58 +0000 (UTC)
X-FDA: 84856112796.25.42AE64F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6D2161C0006
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:45:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rg+0H1P6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780908356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XuarSeLN78HVSV2cIgbzTlP+3ajrwTiQFsYhkjJgQjU=;
	b=Q+Atids55jna7cAgLo5SIF7he6H0WfE27bG6DA/nsR0LsvwYoPx2Zlbgexq+Zm97LN5IDc
	joPUw/p/Am4iho+bFvF3z6FAndE5LeVarB34Q7qOWocL4GNXd8J3zcspxbEVba78irjAC+
	AIzLP5+0+z7mG9pY0IIzQlx59In36GM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rg+0H1P6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780908356;
	b=hMzTuKOuGBfUjoVJNuB7cMv2cRJFRNFAXdXrAsaaNNY7Fc6pSXO4ZbaRpKWFIbNJ/B5zBG
	cKeyRmmRa4/H4oa5htzBvsUnkW9xxpcG1OdtxHGOnDzR1//8voJcL1Qrmq3HSunXKQ59ve
	+RGe/znv0TPN46dUxQ8o5yITLepzCC4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 81CB542A5E;
	Mon,  8 Jun 2026 08:45:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E7C1F00893;
	Mon,  8 Jun 2026 08:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780908355;
	bh=XuarSeLN78HVSV2cIgbzTlP+3ajrwTiQFsYhkjJgQjU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Rg+0H1P6GbsUsqwBUMQLth91KISm3oK8bATyCyasCZ/lmHFNBI0q13Ke0sOQFDI35
	 uCyrOY5QpDByDZ7XOw/08kVwZyMLV2/n7kD7vOn7Dd+jl8hIUY2bRSXup0b0XQa1x2
	 0qzfuUd1axp3VTbjdNYpCqbl8rCndYHH8DGFMdQ5eFYLv8x00yBet47bXPorw32JCR
	 U05aqtV92bpp9yMrU7MI6TW2BYmGPrXRlfwBAJyw4ksSUGbJfG9c+CYLGXowfelT5+
	 LZ1/eGbk7Iu0NtPpClo0paZxEAH8x8uFX39on25mRqArScVJLus674PVsQnqA1RALC
	 zxypmzn5TlWwg==
Message-ID: <79a8abe4-ea1c-456b-b438-44213b042287@kernel.org>
Date: Mon, 8 Jun 2026 10:45:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 14/42] KVM: guest_memfd: Handle lru_add fbatch
 refcounts during conversion safety check
Content-Language: en-US
To: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 david@kernel.org, ira.weiny@intel.com, jmattson@google.com,
 jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org,
 pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com,
 rientjes@google.com, shivankg@amd.com, steven.price@arm.com,
 tabba@google.com, willy@infradead.org, wyihan@google.com,
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org,
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
 <20260522-gmem-inplace-conversion-v7-14-2f0fae496530@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSNWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBrZXJuZWwub3JnPsLBsAQTAQoAWhYhBKlA1DSZLC6OmRA9UCJPp+fM
 gqZkBQJqFFy6GxSAAAAAAAQADm1hbnUyLDIuNSsxLjEyLDIsMgIbAwUJGtCBUAULCQgHAwUV
 CgkICwUWAgMBAAIeBQIXgAAKCRAiT6fnzIKmZJIUEADFx/tREzUImHrEwVHeSvDFmA7tJysI
 UVrlvrM09E7GIuzphzv7jYmo8n3ANpCczLEVr4G0syYQdTigaZgv3+FQDIIzhKih1IHhu1Ei
 XHlywNWKnQxxQEUNi5Mwx43wQz5XVw9F1A7gtKBKNtfogO511hAbrzagrYajyQacEJ/+sfhZ
 9Da8ltHIXD8pcYaHUfQgEusCgmEd9+KrUwrTbckFKmYq5chuE6yJ4J0EmWknL096jIE6CnzF
 FRslQ3B1UKDjxVsm1ZHfir5NeWszLkTvGFsddFaWTgh8UycESG6VQzKXjjewXu2pG7YQYRpj
 QKm1W5X2TkwWkXRBZTmfmbhxIUMh3+zf5wQ463rSmDN/8v81tdqBtAW6rH/kzg1GvkaTHXn0
 507yEHFzBksk2viAuIxxr7km8+/KARYLIdGtx30EG8cKzAUZOK6WqxtNCsXUJNrVE8CWrCaD
 icoNu7Fs1c5hmPHdSTnU48ce67449DdnO4neLSNhRiGlMHJgfJUmgrxu/hcYeOZ3haWmEQ2w
 uW1Mh01OHi8QZHCEyAbABrPs9GUgccc/4eYXX9hIgxfSkYzn8f+8NuIFPWl/0uTvjgqU29FQ
 SbzOLxHq9439Ox40G5mS5eZXRGxITYR+6TXvRGI6P/264jvflnr/pDGUttaikU+0W+1uxgKH
 cmYbEc7ATQRbGTU1AQgAn0H6UrFiWcovkh6EXVcl+SeqyO6JHOPm+e9Wu0Vw+VIUvXZVUVVQ
 La1PQDUi6j00ChlcR66g9/V0sPIcSutacPKfdKYOBvzd4rlhL8rfrdEsQw5ApZxrA8kYZVMh
 FmBRKAa6wos25moTlMKpCWzTH84+WO5+ziCTsTUZASAToz3RdunTD+vQcHj0GqNTPAHK63sf
 bAB2I0BslZkXkY1RLb/YhuA6E7JyEd2pilZOrIuBGl/5q2qSakgnAVFWFBR/DO27JuAksYnq
 +aH8vI0xGvwn75KqSk4UzAkDzWSmO4ZHuahKtQgZNsMYV+PGayRBX9b9zbldzopoLBdqHc4n
 jQARAQABwsF8BBgBCgAmAhsMFiEEqUDUNJksLo6ZED1QIk+n58yCpmQFAmfIHFQFCRYU6J8A
 CgkQIk+n58yCpmS2PA//bqN1LfcotmArgElsa+0EGZSQlYgK48pm8WAeTXTngudP9IJ4SuKY
 HR5RNjHcBeqN+Me0zxRqYzRb8nGanHEkDyf4Im8DQM8d6vbyU+FcPmG4skud4kgS1zMHnlVd
 SXfSIwKC/hKgdHG8aBV7545Lz9X6Iohea+94wneD0aw/hqF+QWewGZhWJriWAZtvEkzNjQOi
 4U9F/trLten/x7bpphDSnDMKJtITbtzATT1Dq7o7VpIUK1nCTQALMuMjKCdi8OdU/+V+R3O4
 0PXWvX8qrvqYapVbZ+9KqT74FsuB0Ya9uXwgBF2Q6cRuETZk5vqaqKxzqoQZCO8AOz/58j6O
 2RHNy/mZEN+7tJ5Tsq42zVJ4jxsT8b9YplavCMsnBgDeRWhcbYhCyttoL7nYISyWg4kQYZ/P
 wIV3OuNv2f8iKYsxNsRuClOAF82+gvqOy1/1pprFjy8uo2pkoOrb63aOP3vO5VHnRKgra6dq
 NcaZ+c6J4H+nEJGi2SkHAUJz5oBzuThvPudLvPA/SK8sKoM01IRxSihev/S/5WLazXB1PGem
 OCbvzC1IjWJJraxiDJ5IygokapUa2RP7+WBR22skQ3SSl6G107QgWKSyTOGWEaRmV53vxQLV
 jXuCmzSSasTL60zq5yGrT4/DYQVSNEUiUbG4pYekxJujNeEDkUlky0Y=
In-Reply-To: <20260522-gmem-inplace-conversion-v7-14-2f0fae496530@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 8udeg5h9ptyehp5dzyiyuq4ifsx1n9uu
X-Rspamd-Queue-Id: 6D2161C0006
X-HE-Tag: 1780908356-769597
X-HE-Meta: U2FsdGVkX19752M0tv3aumc2N8kQAqOFZ7KhC0tMtruy3JT6j4FrRiRF1zzNQNvcdU7wUXoDrMYc3oAt6axzGCYVl7h+ev1miCrJOKWy5kh0qu2ee6Pk4EKXHbHILx5JlsMCYZ9Apfu/Z8LNHM/2VtJhXKKyJBSy1ihVIZe4KJ4Xi0M+/eBSHIr1mgg+cHeUuP5YOkSJ+CpT3sHzY9C1pNXLQ5zQgRXLo7jar7ruo/txSUMY51A1p6Kv8a9ByHPgPVAKnFm1W6DP+vQzd/SGeXmixMrZA53wMpjAlFMj4ybqJqKLBLAw/6L8WVgpQRfkbnESq1llV/vorEyxjqdmf5MbnTSVO3BobdXNV4+2CcQJCpnY0lETQ1MwfwgR8hYsEOXyz4UwE3IWDB2d+WzrxY7qE3NFMF7T87gqfkW/fBbORR86RSdwXBimEfJzIP4uh2t9dqTGh5wZfpDGLFP04B5A5rI0T8TXTFjNEfNerwfxzPvED1dlZqAplslc5mJr0ABN6UdVal2iP2/M4CIXo+m4d3ORlgMFLPJ4k8f2dmiyqh2ufGyubmeP0PSBQR1GKcMJSqveiFEZKXCbF9RUSpIYDzuEcOIGJBehGBXZUjJbNbT/IUiUFdWUXaix4YSxQcTSO+JEUTnnyCgcyz5JECgpNfxv9Jn3sgc5YXyUPKZQzwFUbwNRe147Z3kD8Z/qcEt4LcgRu6rO6QqCPjfoXq3ZXrH9JlQZZPQxqB8AW3oslJRTCQYkmg5lDZ7YNIc6EUMGTi+gBE+YLDxqxyqMGiycU077/vCx15MDiw4ywGAZ7Y6AEUXPnzzJ8e5f2FXFhep5wCZpruBQ0VxDE0e3XUc3jVEp/d9xQkaj2QITTGmqIHuA48xyd1BRLa7uYETgAnnwKCTr3CVspeaigTkL9uNZjXeVavz4uJ9KnSr7Albgue4+gF29aFNsdjEDqy8hY+e4rooH56Yz99mlxAj
 hauOgmLp
 6r03Z4g43deXylaxBcGWqp5+IRQSoX5Q/GO3MVUI/OmV4b21B5r7qMoDW4S5UFg91sbOmCmS1FW7nnJgWwkAUITiJ8YYiqVCRwy5xAfgK6UInt0liAGomaYwh25JeawF5t0GTgNJQmDSGdnODsFwCUrFfn1+wlb3LuppsnH9nFSUoBJM58HVq7NgE/ed7HZTs+Rx5gU/Wck7sYd91Kvim7vtH3t7Z4C5K7FdwhyHCM663pUsLqgWugViAidJsfxmlI4FXB/ZPEIe1zPBnRhjQqsWgXGz5sQTDoE1Wxsv1PZMgGeFkoZzOMcoKzP3XRNLN9lB59zc/0iPFK1bZyfe/Y4WxuWXrgmAj8/Ot
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/23/26 02:17, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> When checking if a guest_memfd folio is safe for conversion, its refcount
> is examined. A folio may be present in a per-CPU lru_add fbatch, which
> temporarily increases its refcount. This can lead to a false positive,
> incorrectly indicating that the folio is in use and preventing the
> conversion, even if it is otherwise safe. The conversion process might not
> be on the same CPU that holds the folio in its fbatch, making a simple
> per-CPU check insufficient.
> 
> To address this, drain all CPUs' lru_add fbatches if an unexpectedly high
> refcount is encountered during the safety check. This is performed at most
> once per conversion request. Draining only if the folio in question may be
> lru cached.
> 
> guest_memfd folios are unevictable, so they can only reside in the lru_add
> fbatch. If the folio's refcount is still unsafe after draining, then the
> conversion is truly deemed unsafe.
> 
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


