Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C8D3FF885A
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 01:35:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49A326B00C0; Tue, 28 Apr 2026 21:35:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44B0E6B00C1; Tue, 28 Apr 2026 21:35:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 361D06B00C3; Tue, 28 Apr 2026 21:35:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 27F356B00C0
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 21:35:21 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B74511C0BFE
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 01:35:20 +0000 (UTC)
X-FDA: 84709875600.05.529E38A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id DDE0040007
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 01:35:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ehiW3hcK;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777426519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yFTUxqS63o9Sbc74QuYqPH5dkbR5Zlk9xcXHLLglMEo=;
	b=elLe//7Rm7/vnxtZwf0clmW7a73aYpvkN/3gtP3z5Kt/W9UrAZF3MT30E1mG1G7PY6eSl9
	IwGvkYXrkwlZsrG/fVXD0n/Y2fnxsbURcRzvAH6TWJCa1uRm0fL6ufrBuPvFXFlqO2Wj3N
	jp3qI/ocdYezIc76TKpwfAFDvDRUcRk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ehiW3hcK;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777426519; a=rsa-sha256;
	cv=none;
	b=bhBkatXbCiSSBa9aWUKfmiU6mDHc5Fw+CWfBCwww3rxxY4hl1MKECXhtxF4+HAIY0+wclS
	pvLOsYItdgLL+lvQlJ6P00z7UvNmjpJ9i9zXE5N0fuRCua13UxMODLvpL3rOO7EzRy9eRs
	G3I4Zv+8Wo9jz1rWwcwn4E013s2k4gM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C59AA43234;
	Wed, 29 Apr 2026 01:35:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365A4C2BCB7;
	Wed, 29 Apr 2026 01:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777426517;
	bh=zsz09Fh4ZkNYvNa/EM9uqYuuGn5g3d5yHSgaE+HAkvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ehiW3hcK5usEjwMir539AUX6Ta8F9pPK4R5M2qPBBUKPcfTkXpSx8Ydo+DmZ3hVKF
	 aL8W68NDTvx0Tzleh5WTNoMEQcRg7iDNm3hi5W1aRBjP1dAJA4IXGzIFWWk2m2Ug+3
	 ORZH+CSE4ujGfTnglWseL4BYrtij933eKGtyrgKFn6+pJ2iF6FNrNGjp6s6ssAJMT/
	 3BGNqmmZi1GRkrZez393niOPxbbo1IJCQ03qXRBDVdOSWNdHvNvi98cC9RFjZmdGJJ
	 JvDfLvVhQ4LJy9m2EUtUJPtNBgoy3kLAxVHKwcPtlY00r8aDnmS4lbPMUSMyhKsa1g
	 dQT98eXYqp6+A==
From: SeongJae Park <sj@kernel.org>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] mm/page_owner: document page_owner filter features
Date: Tue, 28 Apr 2026 18:35:13 -0700
Message-ID: <20260429013514.88985-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260428071112.1420380-5-zhen.ni@easystack.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DDE0040007
X-Rspamd-Server: rspam06
X-Stat-Signature: 6ygph9zfbgs3wqgp3hit6zxktu7nzmri
X-HE-Tag: 1777426518-430931
X-HE-Meta: U2FsdGVkX1+woScGGK6LqZn1fwfK44XYJ2YZK8B4oLEiWvdBxxeE09SZbbU3UKCYB0QAoCYfwo+qvo6db6jW3exLRZ+lPtFi4xlJDyb/8Z1/vNUYTwQj+xKxWPioLE0SUBzvpWiuTpxRDGSnRXFNRmNi7pFLznr+mM+JtsDuOJL4Y7POAYmoZyhcRmgPnsXEqZAZgvGuHThGcOxh/j3e4d4BPml05RIc0yFond7iDRjPfWIe/NyW6odA7bMbbfsxQtz5MWf+Sj25pbueQx4CNUkdD5y7IcI2m8+rUDry1lAn85hfw1ZdxULGc10k0snJYJ+QHfwzKk/Y8vkmuMJvqnhJQ5ZZ2Bv/ivA6Dk0qMg0o2M5qa/PXMCtrLgA+O8+wdfip/WRy/oqzRmXDfHsA0nh5eJePGjv4Bs1Stm0OXVe3aPjePunyxzwknopVmWSvS8F0FRIJte2uxoTa/QliBsTczbqrj+77vvvtPPRbKc71kLn9QgcBiPRQ0tbdiRoSJjTQ6ljS9C7todYbpzPwCGW9sl+GEe4xoBh460OXa+FSgPTfStF7YXIQVa9+t+7qq5lh+lDePoEKdMx8IW/QagltiGCuZbXUmrzuJ9Uq5t81cDoMzFcvsocZw0Cw5PQrUVQ4jbHqH9vSlGjRMo+E1m6WytetiH7wODa9EYI+hymSYfC+EEA47zxPXzz5E2O4WkU2LnEg4UmAPZmzpZPGkkKA4zmJb+Oc8gHwgqIlYdMW8Il31/HaVg8evWoW7rVyGxRJnZgq48OI2iRCU9Rl2uklLnPu3GOhWSU7ExC3umc/BgGOzvy8ILR1WqjvtNU135YUSH+PTka6aRPRFPHYwo/Q+s52vxcV4iUhVs/75AMlY52Y2D2zTo138q4sn3BF1VHWWXJ2cbIFIdQgkKi0J7JJo6VZ/7L/vfXIIkIulwH18q5k+THWvnwyaGsqZY9u5lmr1WFadG4ihHWVA8Z
 ISko/BFd
 KY6ytnozqnocjWMJFxYkf6vb+KzRUw5zHiBSdqXQ966TgW+neZbf9cewU90J7Rumn3kP5TCE9UoA+Vakr7+Jj4akpNkVSWlhWMqPRdSA37zIg3lodK23Wh/pZoGY9o/GWID2AWeZNDIDiat2W7hz9VSCxtHw35ga3cs5VBKpA9uY1yg84P6cLkhmVmkHDy9WjgmJl7W4bfwtoA/JulNs6ep6+7LJgjS7KYqIdjMnZ/7ucwFkGrTGd19TE/gBZaAsu+2Ng
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Apr 2026 15:11:12 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:

> Add documentation for the page_owner filter functionality, including:
> - Print mode filter (full stack vs stack handle)
> - NUMA node filter (single node, multiple nodes, ranges)
> - Usage examples for both filters
> 
> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
> ---
> 
> Changes in v3:
> - New patch to document filter features as requested by Andrew Morton
> ---
>  Documentation/mm/page_owner.rst | 55 ++++++++++++++++++++++++++++++++-
>  1 file changed, 54 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/mm/page_owner.rst b/Documentation/mm/page_owner.rst
> index 6b12f3b007ec..6261366d33fe 100644
> --- a/Documentation/mm/page_owner.rst
> +++ b/Documentation/mm/page_owner.rst
> @@ -74,7 +74,17 @@ Usage
>  
>  3) Do the job that you want to debug.
>  
> -4) Analyze information from page owner::
> +4) (Optional) Use filters to focus on specific memory allocations::
> +
> +    cd /sys/kernel/debug/page_owner_filter
> +
> +    # Print only stack handles instead of full traces
> +    echo 1 > print_mode
> +
> +    # Filter by NUMA nodes
> +    echo "0,2-3" > nid

Nit.  Other parts of the document uses tab for the indentation, while the above
new snippet is using four spaces.  How about using tab for the consistency?

> +
> +5) Analyze information from page owner::
>  
>  	cat /sys/kernel/debug/page_owner_stacks/show_stacks > stacks.txt
>  	cat stacks.txt
> @@ -238,6 +248,49 @@ Usage
>  				./page_owner_sort <input> <output> --tgid=1,2,3
>  				./page_owner_sort <input> <output> --name name1,name2
>  
> +Page Owner Filters
> +==================
> +
> +The page_owner feature provides filtering capabilities to focus on specific
> +memory allocations (e.g., by NUMA node). Filters are controlled through debugfs
> +files in ``/sys/kernel/debug/page_owner_filter/``.
> +
> +Print Mode Filter
> +-----------------
> +
> +The ``print_mode`` file controls the level of detail in stack trace output.
> +
> +Available modes:
> +
> +- ``0`` (default): Print full stack traces
> +- ``1``: Print only stack handles
> +
> +The ``print_mode=1`` output format::
> +
> +    Page allocated via order 0, mask 0x42800(GFP_NOWAIT|__GFP_COMP),
> +    pid 1, tgid 1 (systemd), ts 349667370 ns
> +    PFN 0xa00a2 type Unmovable Block 1280 type Unmovable
> +    Flags 0x33fffe0000004124(...)
> +    handle: 17432583

Tab for indentation?

> +
> +To retrieve the full stack trace for a handle, use::
> +
> +    cat /sys/kernel/debug/page_owner_stacks/show_stacks_handles

Tab?

> +
> +NUMA Node Filter
> +----------------
> +
> +The ``nid`` file filters pages by NUMA node. This is useful for NUMA-aware
> +environments to analyze node-specific memory allocation.
> +
> +Supported input formats:
> +
> +- Single node: ``echo "2" > nid``
> +- Multiple nodes: ``echo "0,2,3" > nid``
> +- Node range: ``echo "0-3" > nid``
> +- Mixed format: ``echo "0,2-4,7" > nid``
> +- Disable filter: ``echo "-1" > nid``
> +
>  STANDARD FORMAT SPECIFIERS
>  ==========================
>  ::
> -- 
> 2.20.1


Thanks,
SJ

