Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C45DBEB4913
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 12:37:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB6EE6B0005; Thu, 12 Feb 2026 07:37:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D64516B0089; Thu, 12 Feb 2026 07:37:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C71266B008A; Thu, 12 Feb 2026 07:37:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B46A46B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 07:37:13 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 343BEC04BC
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:37:13 +0000 (UTC)
X-FDA: 84435754746.27.B198AF9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7F0D0100005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:37:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PKgthSt3;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770899831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5IBaI/xN2RwalXLxXIXZcg5k9EZ72R/t+mQIdoqW+rg=;
	b=TkWINb6UpbkLBnCFaFgIaQZHgY/o7wGVSRboOSFaGrKtUAC185yD9rt7z6sIcqXfg5aJR0
	cZbxNay1AWnnuh9wBBkPYX1MuX+6A/qre4+QT8zI5WN73bvgeKKct/GgpXWK3n2S79K4l0
	e9ItqUR25w6e/9YiHuS8PDO6ckjNIuk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PKgthSt3;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770899831; a=rsa-sha256;
	cv=none;
	b=am/R0447eiJvFdSpfk+635bDWliui0JYrSFQg61y2thXoVQOLMG+EfLR5NA0UjhAv7+uS0
	/V1FIHhFcOMXOwKHAmHiCzPrTzaEiCD3TFZq7e/P4LTfqROb8N8H/zFVV1q91z+JlP8nof
	XC2mdIMLtldT2ESrGu6dmyWdv4atYNE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C751E60053;
	Thu, 12 Feb 2026 12:37:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001A3C2BC86;
	Thu, 12 Feb 2026 12:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770899830;
	bh=bSJNiGDtIO7gmKyV6UIsgVXzM5Pv0laYkkle2CPZTw0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PKgthSt3E8o8pqjdnOyxzUuTztBCUsZiIMgBbi2vMyCWb0oI/Plu+rBUpMHj8Ju5c
	 /GKyxREMkIYNsleOdmScGhhejPrK1DEWfY3Oj5c9ChJOm+bBJVoejRSTFadlgw6lYa
	 PsL9UiHFUdnrk34NvcO+11AMp+8ISccjmwOLA0BaglzAYFMfVnlBEmh+jWj0iPsX2+
	 dOEgjuMrotOiTIDX6yfqZlPxGwVe9g0xvWnHEWh/ZZozjr7E9sRdF4H3qEfSQ75Euw
	 2UtLQwsel6N4Tk6phuq28CgU4p49qUDWGEDR4H078LtJlRN4jTe2AsPb3BoUZrM2xR
	 h/bopfMvF8uMA==
Message-ID: <a456f6e2-0494-484f-bc93-dea2b2f53ee5@kernel.org>
Date: Thu, 12 Feb 2026 13:37:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate_device: remove dead migration entry check in
 migrate_vma_collect_huge_pmd()
To: Davidlohr Bueso <dave@stgolabs.net>, akpm@linux-foundation.org
Cc: balbirs@nvidia.com, matthew.brost@intel.com, apopple@nvidia.com,
 thomas.hellstrom@linux.intel.com, jhubbard@nvidia.com, jgg@ziepe.ca,
 linux-mm@kvack.org
References: <20260212014611.416695-1-dave@stgolabs.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260212014611.416695-1-dave@stgolabs.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bb1s14aypeubnp9e58suenmwbdtpuws7
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7F0D0100005
X-HE-Tag: 1770899831-533001
X-HE-Meta: U2FsdGVkX1/HW+Qqnw5hoP/TZVuT5SZXrqWEK0ClsmzNu6MvlSQ2lLKhii5+JQ3AwBVz6nRbGAPdKKFVN+jUqulIaIVYgtfYqwPUd42mDggdDeDkwh2xu+xfJxr6lWkMVKE/zNxVoa6mw2qFcy6ehDktozgFjjPuFXjmAMMCEtUGhtlY4CQiF1WGb2Z5ZTLC9X9qjne6reFV5qc8meCQtA2Z5wW3fkbNrQStxPifiLwBZsqFQtm1KhL/I4Cf2nnJurkYZrHlXM7Lkpi9gNPqLPFYcKfMcdtV9xW9BM/kp5n2dMNJPq2dxLFb3cqevp5qmC3pm4dWP1y7fmf7Jg0+dtEK9acA4fCtkiKW8Lk7grd060gfu9ZD0qjNwR3Jq8vgT/x7/4JIC5NRLj5W2N2Dw5k5H5A/+Kk/453jMnAHiGQhmkRBz6B36aBdHne4a0kMhp+gxJvOR4Mslgf/oaeo2rWDyDcUE5k6F+JAsbTHMzig1UPlLRHSHIexvNcz6LUeFHOmGmD9pvRf5vm8yS3KUR4xuie0pFIagB63FsYaaPibCGInGysKZUrOKUzO4YotQVXior3WyvQ15lhkadpALgtTmYWwElCpzNQ0nWl3qfgwxnHO/rR6K0TTVmI/n2PN8YhIdjkTEahEEHtKeR1rf9Wph2jRAfhFSry7GBVBlRtz65m/fbSAAJp7a/nMmWY3YDgr0UNcR5NnRoqmPLxGf0B3OVSEYXwrDGOTbBUQO7SgMC2qLk2wu4H5iA2/4+RJqXQfOUyqrCUuxIKWd2pAKkA2limpyybv2O4nZ7gtc4emqRAv5MPFUHXRXXwd/BsWjMOlLqMPHqUCRH65BlcD/imvpbzrZD6bmuZwgNC3fgfUugLMZebPP9m4xlbArlF5K5ZIRSnE9ZfkYibndXdRj/bONGCPkbFPrnF4HJWTOWUcR0SYFsenD6SrNdwG8DO+/Lje14qDamYQ7i5inza
 la3qqD1K
 wH/ipcVM9hJEXZz+BElkmol/ZjWQsMD4JVKs2wfdpqyQ7MWoLmhSvDrDloydOZeP0yZ5cuphy9mBjUi6uuY4V6kCuw7WfCFSlstBBwQ8Fwnxsx1vcAKzEdVBq3G74TwxfdONSyG89pQROkIbNXRexGGCFjlTp0rEd2dSTdfU382WlLYOw8ZqrXX8QhPfsW2EEHOCLhTABNZDzZkvuUTAv4gBeiGfkV/vUdui3LO1FiKTSQXVQVu/i79nKOhV9t/5K71drp6zI2Bsoigk9KWf8AoCkXC8+yZqy9OIWN25v2I0uKVHBCi+e6WFOJLJvO0tMuPVcHy9K03h0HDYzhigJOtYeCKQMNNJyopE/v7bcXRqH9XyyiWveWmR7SJB92qdaQd3O0pLSTWknNiv+722XzKg1IA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/12/26 02:46, Davidlohr Bueso wrote:
> The softleaf_is_migration() check is unreachable as entries that are not
> device_private are filtered out. Similarly, the PTE-level equivalent in
> migrate_vma_collect_pmd() skips migration entries.
> 
> This dead branch also contained a double spin_unlock(ptl) bug.
> 
> Suggested-by: Matthew Brost <matthew.brost@intel.com>
> Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

