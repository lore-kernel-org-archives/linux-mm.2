Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C29C0CA0EE3
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 08:28:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ADD490010D; Thu, 14 Aug 2025 04:28:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45D44900088; Thu, 14 Aug 2025 04:28:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2897B90010D; Thu, 14 Aug 2025 04:28:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1374D900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 04:28:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BC26D16056A
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:28:33 +0000 (UTC)
X-FDA: 83774686506.07.C8EF09B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2876180011
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:28:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bZVWo0dg;
	spf=pass (imf02.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755160112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9SonojsdCUBAmjlRJzGJE/Pvr9wCqSKE21X33sPI+1o=;
	b=E2vqfVu/1nmCdRHqsANchQdRUoY1BbysVY5dCpUih0zQQ+np8xsKCz78meGpdhAfriKT8Z
	H3uLcBSancfFxtQsJQPhopfdJsXy6J58uPhK1fVV4A/LVsng/cU6lrJcbbQbgXF9G3fTcw
	Ig9qR6xd3IeDxHzurDMYgFXV7hILTmA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bZVWo0dg;
	spf=pass (imf02.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755160112; a=rsa-sha256;
	cv=none;
	b=TyYjgWvGqTexCA+mBc+q8+RSzOsZiPXni+0fpNbIGHYe4qt11kVORmNJCY54h7B+NEYHGB
	/fKTKEcrqKgJKfW1ck6KMk8eNOfcFyI7a2Brp3Xg0qSLaE/t/FNyitFAOv//LNDB/keXZ5
	VX3mzz7VcPPeyQbbjiwDtxJvSwgESas=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3ACF760209;
	Thu, 14 Aug 2025 08:28:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB5DC4CEEF;
	Thu, 14 Aug 2025 08:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755160110;
	bh=ciJd1n2DPoSoC6rfnWbnvNN4xgBsSfqT2aex2mKyrU4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bZVWo0dgRI8Ht6uxw1/7FugpjVR382NzxZ3qM53yTT5T81fbi2Z0asTu14Hxk+j3/
	 PSAWpmIBKwdnN6tip3d/DIXCb6IY8Vfv/j7y29zdFhZpC41ygCDLuBxySGhP8qwesp
	 LduVuTlki3UQaseXcbl4JS/EM7hxaqW+aXvoC6lCnCdTb468iKvuXd/KpvSXG9QXpb
	 lPeYbUysk7o8pdusqS0B//UWYIVZdYEeGgQPyxQuZBeZodSN95sr+5sX7hc71oX1/O
	 HjKlhZ9lNZUQHyM+Y3oNYHJBws69H3v1PLPfn4abVyOYYPEoZFC38eRxPdmxcJ/n7T
	 xesg1QyiyO2bA==
Message-ID: <5b68f042-c457-4ef5-a36d-d00fb431ad54@kernel.org>
Date: Thu, 14 Aug 2025 10:28:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: rust: add page.rs to MEMORY MANAGEMENT - RUST
To: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Uladzislau Rezki <urezki@gmail.com>, Vlastimil Babka <vbabka@suse.cz>,
 rust-for-linux@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250814075454.1596482-1-aliceryhl@google.com>
From: Danilo Krummrich <dakr@kernel.org>
Content-Language: en-US
In-Reply-To: <20250814075454.1596482-1-aliceryhl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2876180011
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 7zmwpci3jzyujpg3h51qo7rxo1k8wsto
X-HE-Tag: 1755160111-415445
X-HE-Meta: U2FsdGVkX1+dI7gp8+gnnc5fAZnaR3onVccQyH0kKENkm6/7CdAwyp2/tBZxeVJdfTQFuFxgs78z2/jv00BwDIx4aK86KjBFR1f7DNoeR+GMfHcUomMxBnaM5KfDEtu9vznwMT+Wut5kE4xCuee7dmaj/7SsGP8eEPpkpTWAf7XZVjsEf+NESNgcbX3Q7wwhKAA/RWqLkS3oC4fZLnZU2061oXLES+0SBPfQs8kOdsYBKITwFdGywW+Cs68nyyfALhoorVM5TJXIK1HDMklAwH78WHNflf4jANL2WQa8iaTxObaNgemYf9lsrwzVccGFPoOkQ16Ph3Hh/bHEb0rW9XEIvA8Enj6em/1sZeJ/dBFPPvaenucv/c9umssn2LJGkXTw0FNAnIKgzXSnS4yRY4woPVL1z8A4DdmKijSpizlbUoPFe/+Oz3Rkjp1+T3+yMeCAxCJClFGuAgptqLy/hXYsCSv546VQ5724ag7qQipyNDEjJT2E58xX6Tps17AF26yX0JQwpZlc7cKtYjxtp4iTjCnVmA15/G8vupS3RqosIdPJnjphlVWSpTyOsN3w/RihFpP/BAxqnHaHnuKB9Mfoz+x6at89sIC3P4RFVSCG61B0nugHC1xXUaCBJzc0XNqcieT4+7KdCjABI0gWsPfRRAVy0krrRfI3cokIvaiZbNzOppq7jS6ajFbgP1PMoTOeS6sUiQyMAbGU7ZC+tSr4bl4fNldbJ1Ooq6UjsnUOO9h5djvP9xFiHFTnYyY92wQ4GlgN5/7Ei8pZqkASI9Mw2+BbDhZvpb8zbBFR6OKVgf4cqmYp653BoZqK/6qM85rDT/vgp0a91UW3PMCTorAVKxUncFHQJ/e/mQEz/+HTt6NecCQtWED/8n+Rlfu3LPspKK6MZR/19x+WkhaKkbTJ6W/cVm8TUh0zMj7xudLf0Kw4BSFynw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/14/25 9:54 AM, Alice Ryhl wrote:
> The page.rs file currently isn't included anywhere, and I think it's a
> good fit for the MEMORY MANAGEMENT - RUST entry. The file was originally
> added for use by Rust Binder, but I believe there is also work to use it
> in the upcoming scatterlist abstractions.
> 
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

Acked-by: Danilo Krummrich <dakr@kernel.org>

