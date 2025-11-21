Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80850CFC28D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 16:09:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6C256B0022; Fri, 21 Nov 2025 11:09:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1D8E6B002B; Fri, 21 Nov 2025 11:09:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90C6A6B002D; Fri, 21 Nov 2025 11:09:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7B49B6B0022
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 11:09:23 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B8A38130277
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 16:09:20 +0000 (UTC)
X-FDA: 84135098880.23.2619746
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id DE7E0160015
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 16:09:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DXrPBIfz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763741359; a=rsa-sha256;
	cv=none;
	b=3jYSjHI8jBR89cKmO+w+Odim8r3v/FFFprFs2X1TJ7dggqfxW6cNHQe0jbSmTT7DO9UrnM
	X+GUmB8jVFgJg1dzZSJx/DEBK/BF35z4ro4dBRIHqM5fyf45zVGWBybTGYsqXnJLz3ZlwH
	g5dZCX4BAVDr1Z0qL5cnIF8dIm+0z3U=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DXrPBIfz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763741359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ePW388oklA7FMns8MHWa6eByXoeTMRetMmV1+DxnMiQ=;
	b=absupK4IpOMU6DJi6ZmxyGee3O0g+UfX/cyO/7+P/+rYn1WYaNzpLNRltSPetwOx8rb+ji
	jpdpMSEUBQJbVrdzjwsJ1eMSCEgVCsfhwfocAonkap4tKHQkuoG81jWTOAz6H3abu+ZCXp
	ddMZJ+V+0AHzGMatDUq9yqz5KcVNtkI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 89BC843E4B;
	Fri, 21 Nov 2025 16:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E86C4CEF1;
	Fri, 21 Nov 2025 16:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763741357;
	bh=//OuOvMXeDV9xgqjwXYfwljPeKEYUBLLHfpTkq6K8+8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DXrPBIfzI0rxVmeV3dm4FH1BWca0aQOsApup4El5ebC7/Wnbgl4eKyhSn1TIGGat+
	 vzz/NrU+jaItZ8HFmGhr86j1xgwmOSYZSNYke4wL/syHqsVWZQukAqEhNqa+YNeBPk
	 31QsKCYCoAkM38ieBYVKK5PUc7SbGf1eklyzn4hbLVOVv03psyu/FsTvwpQUJc32fZ
	 7tY90oZuYPnRk61KoNosla/msm9JvWELMKFOGQibL0zU59vuJTMgJueCkMx3/vpyuS
	 7FE3P69FI738zFjFu+4J6UR3L8bSD7oVpcGOKZ1Fj9BmljA4Dxgutytafxy0PEhDdT
	 FX70hzkqbeyzw==
Message-ID: <f8669e93-24a8-47e1-9ba9-66df9627e998@kernel.org>
Date: Fri, 21 Nov 2025 17:09:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/9] mm: implement sticky VMA flags
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Andrei Vagin <avagin@gmail.com>
References: <cover.1763460113.git.lorenzo.stoakes@oracle.com>
 <22ad5269f7669d62afb42ce0c79bad70b994c58d.1763460113.git.lorenzo.stoakes@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <22ad5269f7669d62afb42ce0c79bad70b994c58d.1763460113.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DE7E0160015
X-Stat-Signature: jzb3ws3ywpx176j8gniwd76hprrkcant
X-HE-Tag: 1763741358-452854
X-HE-Meta: U2FsdGVkX1/lqDn7VCzJ/uAzBZH9oCHnmGOrk1GteLx1RV+Cw4yF90uiLwTrHkVDyWGO93bzkhv6HEDaaJ3JNiUjdaA8Y5el8YVGz3H51C3dUxhcof+hissLZ12h+NwWm4qRrofaQHBp3a8Wc20YnxFHRI0AJIzSZiRRnBnIcn9pCWn8idpFNcI7YKqtJkc31pAhhTydxILBYNb8heefH9Q+im2lGmcll8QxMriOPf445hflu2ifHM9sR1rxErYdcStAVWjDtwzOq8TYFd4daMunVcvSOIbiRdxxF81RVcyU78SI4ZFUL1NnUw6oEKJvHQ/M2pfO8o3764n0bwrCpnKqv2cDToPThGzNlyIphNoaQYLCs459cgq0Aoy3alVNZxazhEsdCZfLNYADlTFEvCCA93xRsL5vUB2A5J2q7X4BnHcR0v61ctn9sF6RBJrig5TXrBF/TLPLrp6Rf/Fum/edBnUO/jkOHI07RnkcPktSZzOb1KzSHqXhUhCFf8fcJsI4LZ2EstGii4WZI1KYNBr/95mnv12jj7LRlInFpnC/3CPqrJoIn3bWdIDotCCZyHEQ42R4gRN3ApMQYP8aK7F0r94SRRSllwhbxR3QZnsISRl96pgmhBRjMAi7XsVWMqvMNTVueohqgayJd1jyGOsZ2Gnm/qruiIBHnOecnwUOmMXrSDsOzOV3UzlUAj4SZ+9quVaFgKCHiarR/hR0QcnUHvh8BxKVeKSuG30SXpgD/ZwBDCLIa3wNazVKsfm1eQJSsgEKQJwUI17+U3vdHOHfLzuwA1UJm9iQJ9gpX5yn7jh1zcCx3QDjB2L6lrdgQiRJ/qsANjuOgmCPFzd4UpAi8PkTnOuldojVRQDZ+pi00teSCysNxvxxPrAL395hqR8Yx0Zcn8KDhFCN0y83P6tXvjldFHLCmlHUmDsMv8ESibqAgqAqZzZHn/dAp1c0gwHuIwCn+fQLcxqdN9K
 P3Oj7gms
 mY1LJwrNxVh5lSW6LoLHrYdoieFdc4JzLwEVDH0KoQiBaH5/Alz5iJ/g+PIJyml/DroEMveHmpd6sGx7r9+T0pgOb63aCPEMndQNeJzFYfkHvN1+5HLQPTe3aaIwhLe5p32JyPwevXvWmy1z2JJV707FciM2dMSHpz+Fz3LGoD2PI31OWPyf6UhwBm+Xp+zKa3xAHkY9hZUmjGFpl9qFpBs1w90/k+0oDMLmYaHOiaeixB3ao+xIWHjv8H/bindeULJyygvVfmvC7cMimjCFyoixJEDRCcan3jxrb7fRkDDgrqGcbjQK6rQMyBQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/18/25 11:17, Lorenzo Stoakes wrote:
> It is useful to be able to designate that certain flags are 'sticky', that
> is, if two VMAs are merged one with a flag of this nature and one without,
> the merged VMA sets this flag.
> 
> As a result we ignore these flags for the purposes of determining VMA flag
> differences between VMAs being considered for merge.
> 
> This patch therefore updates the VMA merge logic to perform this action,
> with flags possessing this property being described in the VM_STICKY
> bitmap.
> 
> Those flags which ought to be ignored for the purposes of VMA merge are
> described in the VM_IGNORE_MERGE bitmap, which the VMA merge logic is also
> updated to use.
> 
> As part of this change we place VM_SOFTDIRTY in VM_IGNORE_MERGE as it
> already had this behaviour, alongside VM_STICKY as sticky flags by
> implication must not disallow merge.
> 
> Ultimately it seems that we should make VM_SOFTDIRTY a sticky flag in its
> own right, but this change is out of scope for this series.
> 
> The only sticky flag designated as such is VM_MAYBE_GUARD, so as a result
> of this change, once the VMA flag is set upon guard region installation,
> VMAs with guard ranges will now not have their merge behaviour impacted as
> a result and can be freely merged with other VMAs without VM_MAYBE_GUARD
> set.
> 
> Also update the comments for vma_modify_flags() to directly reference
> sticky flags now we have established the concept.
> 
> We also update the VMA userland tests to account for the changes.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> ---

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

