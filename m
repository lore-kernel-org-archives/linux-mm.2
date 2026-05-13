Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E74D3CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 15:36:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3513C6B0005; Wed, 13 May 2026 11:36:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 328506B0098; Wed, 13 May 2026 11:36:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 217DC6B00C3; Wed, 13 May 2026 11:36:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0BF866B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:36:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B6268A019C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:36:47 +0000 (UTC)
X-FDA: 84762799254.16.C468831
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id BB04CA000B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:36:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JoqGxTps;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778686605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pbb1CxMxvMyaRe8uHaX58NTSI7G8dCxH4nfNgzWLO4E=;
	b=UahMkqErthZUI3nUgzfFqkAGcYboUkcwfOIg5jC2JoHhXrRtMqscYnpvqlSM/ZTM5z75tw
	+Lxm9Vc79asLQtOadmwfeoLs3Fh8v0eGwON9Ga73zZoPJd62pkoxYiJ2Stlwwq8LGEjlEh
	xIgErA8y/pPWhdwQ1Ukoim7WzlN9T0o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JoqGxTps;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778686605; a=rsa-sha256;
	cv=none;
	b=VBdrc8Hllko12b8SB4pyRMeWon2JN+L9QYiXDCxyy8D3OboQ7mv+xZ5qDHrKWavUSRqMuM
	WC/6kZFOOl/+FgzRg8jfGbkdfKkFgt7yzmuPdvg9P36TahI7+B4joaDIhVRIp3gQ9tWk9/
	+lsRQQhQb+HF2DMh9yGuGXfaM5pgZmM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A90F443465;
	Wed, 13 May 2026 15:36:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316D4C19425;
	Wed, 13 May 2026 15:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778686604;
	bh=sUXt/WyEgbFbw3oYWwC0Bn/3r/fH9eIvNxYTdG6JUgs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JoqGxTpsdH4z489Esvh4AzxVwhzhPfJhljlsDpfmCTo46a8h+2AeB9bm501UUlrLn
	 pWqBUaihIoZsWn0uMZjHzVNmqWsV0j6eb1hLihR6scvj6q/T0z5wkuUC3iIkK7VxL1
	 9a0yx/VNMrb9snjta+UbOn1NiodK8nEWty1sLF0KnBnd3aOQYMyAZiAjbCY3hBVX9d
	 ZfimuV3Md6T7eESTF0p4Z04xJkR2nGj7mQ4ZB7aYhZV1poqsij9lVf/sJcwdcmBO4+
	 fzrCi3aOoqDyAC60DzYD9rG09yVUvvpPwqsztEnkTeZFvZ5J/iUqGiIy6dxxkAZikD
	 KN51r5rTE+n2g==
Message-ID: <07f1039c-cf9b-4b97-a044-9d5771ea54fb@kernel.org>
Date: Wed, 13 May 2026 17:36:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/9] mm: introduce pgtable_has_pmd_leaves()
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, baolin.wang@linux.alibaba.com, ziy@nvidia.com,
 lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
References: <cover.1777663129.git.luizcap@redhat.com>
 <2a0bae00cdd2b6ef6b962610b523ebfc97806ba7.1777663129.git.luizcap@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2a0bae00cdd2b6ef6b962610b523ebfc97806ba7.1777663129.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BB04CA000B
X-Rspamd-Server: rspam06
X-Stat-Signature: fzrdoiuys19k6ytzskfbogts5f9bfxgh
X-HE-Tag: 1778686605-601995
X-HE-Meta: U2FsdGVkX1+S4iBe7CX7zTSJLGgbSwrmidPmrYKIiSvNts/YkZPu0mPpsdUUacts7dFp71ErTyhA1et3lzl28kUWBPTloMc2/fdle1P23bH1kLNKXqz02CK+NgpmhT3oGFsv2uzRJLg2jcr9MbSE+O9TFU208rQtJUzSRQxOWq/6O3d9Bpf2FuAjqVZUOuVwZGfP9WAQqbCBTdciWqPUX4FQW2WFC5kiTsHF7h8Wcegy+dpi909Z0x+LAec/nNOm/uPjEcHLUJP9yYcspEGAE5evXqlHRC3VrV8NOKD7ECwlx7lvkaVhBnXRMQDDUsPxEkSKie+4OKZoH3jef0Jl0NAYDulivzkWk6oTgrx6jwZ+xFcIzGO7QtlGGEsvt2L8jZ4w8FvvDYFriNJvEpki/VS6dQoOQlvuI8zXkiamCm3RXhc3aYWJrfTnPKWzq1004cRdgFgfdAzcz1OdiKLc7zl8c/lR2skKjJMlleqmSnLKYRBGQuR8Oc/m8C81aDH8C2ARenj0NoCgSy+9+nTwYDXwupEoIEpIKFgS94rv54y08UdjIg1TmwItBjt09obQ3scw/aH44wGlAm3zK52ZjSj9r71O4NFHZPv4u7zKv0nP8Uy4pi0CbH80EhQybu8PyrU+YdqZtszeo5XhQTiKRVJdBAIxtiVtlszhoDKTMRmA30bCf/6NljWg8BJNPBB+2gFPDte+qhWfTEzuScSSslAzgNjZpm/FXNrQ2n6kgIuF+nY+P1c4ovj+jJfrKlXQBOWoTsjYeuODdxRMr6J44SvIoD9MEWQGAtjtQVl1sWt9QTGtpKQtWhfxFwfPpfjv1fIwDlLgnPWmLpmw4LCUwlKXqbcIVGSAotWDDaNBeBvVGbJoD0ql19XnNr7XagbXdnk1xqcUN2rVkcfDhMnNVBI1fxGFDK5lA3YT5YTER5IadqLbeK4StwbxCws7hFRjq4zyqYBrh8xhruzzHNJ
 sW2OWdkE
 B5zQqgJywCqU5+MtzaLmcB+CNcgMJxKSyAwilrAy5DZiLumTSltrp+METVdKLJ9pdzmwu0eLAU8Qj5UxniSHHRG0xLYgbRs4ygh43vnCbnSCXAkhc5Kx9NMgEE27eSh8/YroaRXRq98WczGZWs12P73NjqjbgL04PuygMiQTOIf8hmw95Kp3+aTVBJfO0XACVs/fCX+SFnnPCubSKI1FOOQSV98iORUdWxb71vBNvYFW8alpFQ4e+IpA6SoWoOfvzpv7XbLHMhDr0oCyjKqr6vuJ3mh4E4s2YPf670DwomheJ/npI59cJsRFLjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/1/26 21:18, Luiz Capitulino wrote:
> Currently, we have two helpers that check for PMD-sized pages but have
> different names and slightly different semantics:
> 
> - has_transparent_hugepage(): the name suggests it checks if THP is
>   enabled, but when CONFIG_TRANSPARENT_HUGEPAGE=y and the architecture
>   implements this helper, it actually checks if the CPU supports
>   PMD-sized pages
> 
> - thp_disabled_by_hw(): the name suggests it checks if THP is disabled
>   by the hardware, but it just returns a cached value acquired with
>   has_transparent_hugepage(). This helper is used in fast paths
> 
> This commit introduces a new helper called pgtable_has_pmd_leaves()
> which is intended to replace both has_transparent_hugepage() and
> thp_disabled_by_hw(). pgtable_has_pmd_leaves() has very clear semantics:
> it returns true if the CPU supports PMD-sized pages and false otherwise.
> It always returns a cached value, so it can be used in fast paths.

Oh, one more thing: what will be the semantics regarding
CONFIG_TRANSPARENT_HUGEPAGE?

I assume it will only return true if CONFIG_TRANSPARENT_HUGEPAGE is enabled,
correct?

That is, for example, relevant for patch #2.

We could later change these semantics, but for now we should be very clear about
what it means.

-- 
Cheers,

David

