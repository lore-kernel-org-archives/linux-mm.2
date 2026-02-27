Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A6B2FEFB51
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:45:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C79496B00E2; Fri, 27 Feb 2026 15:45:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C404F6B00E6; Fri, 27 Feb 2026 15:45:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B461A6B00EA; Fri, 27 Feb 2026 15:45:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A22C56B00E2
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:45:19 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 288B81608D7
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:45:19 +0000 (UTC)
X-FDA: 84491416758.19.2A6DE1F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6C59A40003
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:45:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hMTGAwtP;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772225117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X8+TKvzIegwtZODWiMAZutCkTguWVZP91GIUbiHPa3g=;
	b=tFTY7ftVi+G0yNYJnr2BNNUwQqn1LllFXk3FPs7YqZT9O/G5ZufEXjlGxKEeBEpyVmxYQp
	MB74AiIYdl2BZMQViZRkbT5HzNzsy7fuLQy6OeF/LEWfyj0S+C8xTOq+VvpIg4R0ybBthO
	EWRBCUT8+LIaO4waY6LrP9+zWjVzrAI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hMTGAwtP;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772225117; a=rsa-sha256;
	cv=none;
	b=VCKMt7BQVQUAwvirji4dFOgxtlJU2l1Qsfo4xfBAaclRsNBltksbckuwMossbUP5q51wqA
	qr9F9/CRwrw1s1YFYEdGkBlBG16oHSuKRPhkd7Gjy5RSaxZMJXugVbRqrEjOoDKuObHMg7
	oufSNDgCrpiEsL7v/dO4jJOahXSvShk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6110740766;
	Fri, 27 Feb 2026 20:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94C8C116C6;
	Fri, 27 Feb 2026 20:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772225116;
	bh=pYQSUC5jATh6DNwnolOOAOo17Nig2BgeHN6u2v19K7U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hMTGAwtPBNfebE/Z+l5VugFscaEc9S9I2bu5ydzPY/uWCWI9MSBPqjQEhQHfFmgs0
	 LxMIdmM5vycoWY6/euBpDzv94By6NVToYu7ziitEzxbRukpSI2TMHTCrwpIhC7ZpQr
	 jI8XZA9Yi4g9PvzeaEVhK1Xk8ky0FTDZ3J5jKRR3niPQuJrVAHK25OEX7urtGK25s6
	 jfu/yAA+yLOA9sYGO0BOkpYsiclYBqfOhGUgmVk7frmqB8JQK4eXXOiF5LlP2Hx9Sb
	 LEPvlo9zKZqZYMFSoDPVDCvHQFL8qlL+tJiQ1m+7fTr8TKf89HH3QHS+KZtZ3x8r0k
	 mV7pQWXpxt6Og==
Message-ID: <22faedef-99ab-40ff-aa8d-c3627beb0b3a@kernel.org>
Date: Fri, 27 Feb 2026 21:45:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/4] page_reporting: add PAGE_REPORTING_DEFAULT_ORDER
To: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>,
 akpm@linux-foundation.org
Cc: mst@redhat.com, kys@microsoft.com, haiyangz@microsoft.com,
 wei.liu@kernel.org, decui@microsoft.com, longli@microsoft.com,
 jasowang@redhat.com, xuanzhuo@linux.alibaba.com, eperezma@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-hyperv@vger.kernel.org,
 virtualization@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260227140655.360696-1-yuvraj.sakshith@oss.qualcomm.com>
 <20260227140655.360696-2-yuvraj.sakshith@oss.qualcomm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260227140655.360696-2-yuvraj.sakshith@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6C59A40003
X-Stat-Signature: a5iyhucwhfg98wzpwkw7sn5f3q9gaaxm
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772225117-730522
X-HE-Meta: U2FsdGVkX18QDCp3wLjvI7d3RCh9S5qKIeLR2poiLaIkLaUJwJSeHFUTRKMWaEO2GBWo2PMijQYSCqzH5f7VA83p7GiVIGumNf/tNMR9t/l6/sjSjW0fplMXpvMzxvJzaTHXwWwoJVWHQKBGY5c/6GAwG9NJy5Qbl0l9nUybd5ema0oyqd5w+PwmZiCBrJbkaDJKyMywEg9SgDAto/q1JlNfxJQxGA+XeQnG+CUHiOub06WGkCwp1mImXjvG3f1+2YfpO5rXw8830ixhzBut0cgZ5cjtUaQKGTTL9waudg9Ms62GHvLwCniB8bJBfw4hHGwOhF9UWAzLgsyljrvJBh2R9bVTXL4x/SXKvmJruho9ese9j/2ATUr3cGLxjeqfMv446xdy9r3m4Ed3lhDAsCdV1DlH/yJmdfdNYYp9OtFWSzYBMYHntS/TkEDz/qhkKMUp5j6pNQe4QCaPF3fZG4UG0xCmv7d2xi0Em76mjWfBs+FjsXrU1KYUPfF6sKgwP1hVq/4V0mY978W3WnyL4AMGQmYVME1LfY2e3c7ARc6HSQmF8t7ei19cvkLM7EIjy/oliV9Jlm5J12RJSgziKyXo9w3xlnazi+FkOk6t/QrJCdvzRZO6N8vG1PBT+k/O3a9DBEODv3tGyZHEauUtV0d2ama9HTDSRjpEAFLvF+p5j9zS6dYy/zxFq8E3waI9gRu1vyPsF2EItX2WLJAL1I0HN0W7v3tO83cmS60eeChx4YVn//y8bbfAb0Wc29v5SUrOLddlsvQu20TZkHcYcVpMVpVK90CCA0lby7GmGujcSt64MCx6RCmaJxWoydsfSy5ES3Zd0EVORp6bJG9K4jF7oZjaSYN3l0YjaFtGk28r3J6Wg5hdORh1VSlClYtGJ0djt4gYEZlXVGn7kO12no3/kH3DJpAnUrCXzXm1alRs2AdDYT4mcXYQZoEG198Jl+Yg+9XxN40mT1dyxrQ
 IGhhk5iP
 dnOnKzPjJXFxBF/w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 15:06, Yuvraj Sakshith wrote:
> Drivers can pass order of pages to be reported while
> registering itself. Today, this is a magic number, 0.
> 
> Label this with PAGE_REPORTING_DEFAULT_ORDER and
> check for it when the driver is being registered.

Patch subject: "mm/page_reporting:"

Might want to add "We'll make explicit use of this define in relevant
drivers next."

Acked-by: David Hildenbrand (Arm) <david@kernel.org>


-- 
Cheers,

David

