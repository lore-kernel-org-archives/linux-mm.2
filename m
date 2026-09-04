Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66E6EC624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 11:33:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F5DB6B0088; Fri,  4 Sep 2026 07:33:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A6A66B008A; Fri,  4 Sep 2026 07:33:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BD276B009D; Fri,  4 Sep 2026 07:33:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D3D06B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 07:33:34 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CC69280D99
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:33:33 +0000 (UTC)
X-FDA: 85175869506.29.84E7FB5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4473740007
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:33:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ArITN7yA;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788521612;
	b=i1oKQpq6dRHQcklKtRtNCCZpU/PSLk4V2u8fbcJQa/JbIGhlkdVaqQT/EmLTqLbjJqB+Kd
	+rk8WMrEGFKxg5ST8Avqegr8/T1rZ8KkNb9bZdk/vJpjgvTe+ZVFk9VQKRZcBtbCbgNIAa
	UCZzQXS+9voooA6xGs5vcibaGlHiw0s=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ArITN7yA;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788521612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FeajS+4YaPDd6gty4X9F+WxnhBoIVDGa6h4QptmunEE=;
	b=QicLezcgtI1YKbBHZLWpkNML6hdMyWq26ayPQhfvoOzEHIVpEDmlyGYBWfluUm48xqXKCO
	4kbc/m1++z5qz1LtMf/KSZBiZ4ygHK5zHcU4HsNtRHGvjgmkRwRLMZZI5S81YDJj8sEucP
	gwA9J0Bcbmv6G/o6m+JDlBgzSbYM4rI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C085B600CB;
	Fri,  4 Sep 2026 11:33:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA091F00A3D;
	Fri,  4 Sep 2026 11:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788521611;
	bh=FeajS+4YaPDd6gty4X9F+WxnhBoIVDGa6h4QptmunEE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ArITN7yAfyimGYK3B7nopyWFl1AACUToH1JFjRSmV5dnLZV0CInD0dtkdXmr3qp6O
	 nlJxUWjY/3zPY+M2Mt19ThZSZjqks2APzxYCFwTdqK0KwloocXooB7KBi0IMOIS5xe
	 g/YOCRo6P8RUNV39v60Mz7H/iZaQQ/A62mGzqtvkg7VNz3XEmziSp1FxhNom90vl0N
	 yuosb1BH8MzeXsivAh9peF/fzOG/2FZuXVVSFiJiBvUKuQqsCe+cK/0zeYR13XIvUw
	 C3EmtdAxmT8zdGIoHSmkwabn+o/mcZjVAdlgFnUlN6ngSHaf+WzrU6N0e6gmRnSyBi
	 NMpohIJqJXecw==
Date: Fri, 4 Sep 2026 12:33:26 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/5] asm-generic: fix typo "explicity" in comment
Message-ID: <apqsBpALCmN8S-qw@gremlin>
References: <20260904104854.25272-1-hemanth.selam@gmail.com>
 <20260904104854.25272-2-hemanth.selam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904104854.25272-2-hemanth.selam@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4473740007
X-Stat-Signature: nmkf8reai8o63hqbbkawn8yxhd6im9rw
X-Rspam-User: 
X-HE-Tag: 1788521612-308788
X-HE-Meta: U2FsdGVkX1/mB/n7ul49rB4TfDpEJgmyTRyvUPmn10QF83wNU0H9ekLOHGHHSKkqqeh4omvTngzTsORrnQ7c47OSOe+yvYqvm5iZVezPKI0sMJcMojYy3fH6QonJdzXkhxHd+fMR27q2YjxKg22UcaNc+ANBR8n14YCU8zRRqqSHUSL0+fyExhD3hVN3AEzjpdDI+vSxt6o7F5uVZedvUlYpohLJjKJ+PsXDERziQCrwL0SmELyJI3hA4FN5w2ZPKBf09u7GCHkLAIlYxRUxK57gId+TWFkmLTqsZ1gozHOWgduDHzhWzNq17vZCHPNaXgyQsLtm2tC+xJaeiOMbvbYDtcOMzwrki9AxY539niLL3noMV3WflD/8oXkXbDach6ZpkY5PMEFptA6/0/mQD8x4qd9hOsdWW4w4laOpHNB3hhhBJWpFPd8bDkdCjKpbhrNlFTf40/Qfl0B7g3Nwb7+jaJrajtAoWw+QJriNDXcnA+pHp7ZPd9E5GI8o6L3afNrP8jn5ftTFRh4Q2SFqRxJ2pp8lU+md7u6UCz53rOy5vvJggkurlAdma9D5KL1f/BEtR2Dc5fk85tgUk5A+G1igP6IcW9ttgJRp9S0vucfrntzmMyXVrXQIrdGLphB+hhd8NlXrHGMse6mBRK4bGw8YCL3YlTGsgA4qNWW+zmd41d9xBdpoqU/y3ogUeJHupi/nHDHmYe6vTA+Cy1b2A/Cu9DCagrqHS4FtMxC8QpJFxxu+lMW8AM5jt1VXqOFvBuBbtEKG7Yvt869rPnVQ/BBpYjyS3MmI74J8Rhswzgqa86QsqjrBWEvIpvt+THohl4C4PQmDwW4FiC5hj9Tk4z/ls6i7qkhFtggIxsKFyRnpf9dAE5dEDUnSGWPRDANGvVoiHGnXD4t04gZt3ds2IQkXFhTfmocOIjLXMmlG5we/R8j1WTxnmehPZtGFAS0fxJkk4UiUolRm35Nm9Yk
 RB36I7PC
 lzXAifWKKjH5EQNeuI/bmxQ79fyYVaWWD1Gs59D0dI7V4edu4ghYUuz3ZvBkza4RG1IUVUroTwRiLo9n1Q0NBXWiU7ZslIitJjHMtLBp76aOk5xkBmS2rpwbfl6RGrhQ/2dDYPiA7i8O+fDw0eZAoSo+lUOUo0iUz6IENaRieah+BoJoDLEwsEo2fY0hDr5+FpnRZSd/VTpUNoglVy4+/rGTP3gwdlam5mM/U+1xSolzzUVoQBzpDppTIxFCTMlNIJ8uDuZJX0cN1acJLEqWjDZ2Fr2dO4ucbwl+b/wn/VZNMfAU0RGCFzEsAduxv2KpA3wYQyi3+J+aMvLBb6VQ0+zT/PEVRdkAVL6x0lKbmbXWs+6dAgI1WxgTPIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 04:18:46PM +0530, Hemanth Selam wrote:
> Correct "explicity" to "Explicitly", reported by scripts/checkpatch.pl
> using the misspelling list in scripts/spelling.txt.  Only touches comments,
> no code changes.
>
> Assisted-by: Cursor:claude-opus-5

Thanks for acking the LLM usage! Appreciated.

> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>

Please make sure to cc everybody on every single patch. It makes it a nightmare
to deal with your series given the volume of mail I get.

I may have to write a bot to auto send this :)

Anyway LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  include/uapi/asm-generic/mman-common.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/uapi/asm-generic/mman-common.h b/include/uapi/asm-generic/mman-common.h
> index ef1c27fa3c57..cf1418649b3a 100644
> --- a/include/uapi/asm-generic/mman-common.h
> +++ b/include/uapi/asm-generic/mman-common.h
> @@ -62,7 +62,7 @@
>  #define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
>  #define MADV_NOHUGEPAGE	15		/* Not worth backing with hugepages */
>
> -#define MADV_DONTDUMP   16		/* Explicity exclude from the core dump,
> +#define MADV_DONTDUMP   16		/* Explicitly exclude from the core dump,
>  					   overrides the coredump filter bits */
>  #define MADV_DODUMP	17		/* Clear the MADV_DONTDUMP flag */
>
> --
> 2.48.1
>

--
Cheers, Lorenzo

