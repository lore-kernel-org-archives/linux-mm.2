Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 358CEC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:29:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CF8B6B00A5; Wed, 29 Jul 2026 10:29:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1802E6B00A7; Wed, 29 Jul 2026 10:29:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 095796B00C6; Wed, 29 Jul 2026 10:29:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D96496B00A5
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:29:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EDADCA15A2
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:39:54 +0000 (UTC)
X-FDA: 85041317508.29.915EC4F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4BF3A1C0003
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:39:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HhLKHVjc;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785317993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+nrky1cgT5+f4Uy1JJ1xdnc45IJ0vARIkg+zWCn2kLA=;
	b=iBjsFkjDU36EOtw7o0btR9rU0VexxmpIvzM8P/owmJ3GbQF1ii4g74kN/dbvbWNRQI7wTG
	EbLajGYUwRRmmxjUqFKBZFY/taWF5dsimDklp0CioPiM1g0S+VaRdfk1yzJjXZWaQehjdA
	REbyKvr7JEdFtH2r4k7Eb099PjTgjAc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785317993;
	b=7Z95Xfyk56lsZkP8AG3X1vS69IeZqJ0ouKg7u2jxk7INaCuOXnsL2jWWSq/hegh5PAXrCM
	Z2fzB2fLlzuTALux3QNh5+JHqleA5N6Bw3KasAriNuznHErXBNk4vTJRIl9sDRSg3TJzNm
	+zvHu67hnuapPeHphvZh872qd19/EO8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HhLKHVjc;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CFD1E600B1;
	Wed, 29 Jul 2026 09:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007131F000E9;
	Wed, 29 Jul 2026 09:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785317992;
	bh=+nrky1cgT5+f4Uy1JJ1xdnc45IJ0vARIkg+zWCn2kLA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HhLKHVjc8Pd3eKZXXS03U3h6DVkfrQq8WfAsUwVtWuBAsgBY0KTMj/yC6X0PP6jj+
	 ahvp86l+/bTssHn7wNB88Csbmquc2seFfLqdRXfpgKpZy3aT5NWYt5jqjwf0dzA46j
	 XzE7MpLan9HumFl25doxNQxPeDeQAXGr0shWfuYLZjfOH0EbkPXs0frvsXkclcgfnF
	 9/ZGtGAZPGaNhMZ+9Eshs1yAQePNBNkggrP7oCA2B7Q4Xsyf1v+dssJUffK2ikljh9
	 TVFAFrgDXcBFm56Bsf/VmugS5Bet2EqGzLCH0JAb1uRE/hWaoDA4wJgwDbeqU56HQ+
	 9qb2oTU86weIQ==
Message-ID: <f688974c-261f-4f18-8867-da65f616d0e6@kernel.org>
Date: Wed, 29 Jul 2026 11:39:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/7] mm/khugepaged: refactor per-scan state clearing
 into collapse_control_init_scan()
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Usama Arif <usama.arif@linux.dev>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
References: <20260715025941.1571316-1-npache@redhat.com>
 <20260715025941.1571316-2-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260715025941.1571316-2-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4BF3A1C0003
X-Stat-Signature: 5wjk91fgapyab4ikkybkkudu33cdkbd6
X-Rspam-User: 
X-HE-Tag: 1785317993-8085
X-HE-Meta: U2FsdGVkX19MJt3gN/aTESCK1BmZ4S1mc1o+EQEIcuoL4RpxvYRlm1ruodRjgPW/+QFsIQNo5MKb9AlCAznQ7aLlVC7oOdPrW44Wx3dlFC5KuLcN+TS8EJw/y6d18+tS+inkvDgn++6QO4AP0Dp8SXJY5JK8bx6hUlj8UhpCMkFpoCJktG1M7YraLbIt1Syk16Y5HsMHPld7/8G8vjYnmLNq5rg2dn02dHkacLypOgHSXA9bMFEC0sjkQySp0XJsY++R4zRxAW5cqncCXGbPfkV1ifL8IdfNSAHSd8wafPBOOOKgiiMp8e2IuE9IObGyOWGN/f4i2JvYxMNIjO84sukiDf9Uod1tcZPBxujp+eMYIev1VDyJuN54ujnv44bX0JLnHbOjU4QEPngZe8MrnH5rPMn+rsXSibNBsQ7U5H0J+iEeXrWVtNp4bCv4c5MCCzrJOzXa51Hgfht//S4tRd7a0VUrDZZySoNWDRQWpdc82m6URqIwaMYUBHTVnNQHh4aBdtba4y1fYG3hRekRtGJ8qQBdQofoYjDJFRjUDghZPlR7y+mWLhwfHYovjEnuwjx/4sg9X1RUmPqoAghZVd/exdwVXsH5LM7GTgiNUqcgEB/UL+TI0vTanQYj8lGqPSffcN7taCRmuponGpSEm5kq/cuYJpcUhkjwphD1qFzyGKcXGIrxl+nvdzirWnAPNZGt2dOFn+7rjN9nn+NwjeQDbs5rAlveDGIkoPmAlPTAiibhE5OHqK6iWa5QIWsmo29vKQcTx7xk/acQZ03xYp6s/SqURbWv013InidMADwSFa2pv7xLVBCY4YaldJa5NcZf0gmw2/2Vb66Eg23NRtj94jQVor55rHGDzdtqgygB+EIOFLavqOR6gu+nurdbaU2hk/O1VJ2FRUvQx0bP7IxPj04VnQ2QKIRphQUTBA9B40Fhbp8dHH/uWBU+LGDwCh6k99k751yNNxvTY8J
 lv3hljgS
 7+hu2dGVzK9Z+5x4xmHZwNmuZqoRo4hgPtxjbkVTJ+vQrt7PuZnOMpCBr4/BAx/9rop5SgBV0EujWokhg0jofj4V3QAJLlGar/YJ5vMoSykBWK33IdmHgBvoMn04GDTv6ixrgoyhCixPb/9p6y084Z9OKXEKfY5u1iUIvYw7AyFN3uBvv2K92nxGmEU7Fu1s/WpBqmLr5CjQbNr/Mn/zhnqFypxSdz4wznX+vnY8vBQh4akbYpzzZYAnpshAcEE6hQos+xDExIjGyitHdPXLKuHSVQfhV4HNZtE3NeOpCeYRka3jdaZSruFGRT6ZHK/jTyJ0JhMi6tIBjtPLR7cwJFECh44jfHcEWAdcYgViPERZrpAJGKsnCNURrDKTIpKZ4wqRL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/15/26 04:59, Nico Pache wrote:
> Extract the repeated clearing of node_load, alloc_nmask, and
> mthp_present_ptes into a helper to reduce duplication in
> collapse_scan_pmd() and collapse_scan_file(). Althought file scans do not
> current use the bitmap, they will in the future, and clearing it now is
> harmless.
> 
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Nico Pache <npache@redhat.com>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

