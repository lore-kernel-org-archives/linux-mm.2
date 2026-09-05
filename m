Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF185C79F82
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 02:43:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 936EC6B008C; Fri,  4 Sep 2026 22:43:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E8386B0092; Fri,  4 Sep 2026 22:43:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FDBC6B0095; Fri,  4 Sep 2026 22:43:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5808B6B008C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 22:43:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CEDCDC01FC
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 02:43:20 +0000 (UTC)
X-FDA: 85178162160.06.34871B2
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1157980002
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 02:43:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LI9txNpV;
	spf=pass (imf30.hostedemail.com: domain of sef1548@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=sef1548@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788576199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nN1oOZhHFA6iOMNOJ2Qu+h7C5QPyvLKsSkfURb8yDX4=;
	b=u8mWqlBgpCm9dmqeLI6/UdXnbiisOgarPGxCzNxp0kgEQb8ccbkVnQZQ/x+4i7/G42jWxb
	1IQu51A4N+73lkocMt/zL7OfYFoG4nW75xwC5mDhJzR/pG7EUodFzN1728B3jNdJUUjLnv
	R0UrzqJMdZ72GCHAJd0/p10VGfCGXHU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788576199;
	b=T84W4iu3m8uwEPW9rgf8tFjR88W69H25jIl7vztjhFDG7WZ8W0OyNIjkYXyZd/JUptjeTf
	vk1PRz9UJjBxIcw4r7t+3vEyl4Q4rK/Oc9Mr+uRhfJ9kIyp/WHUPGaC0cewF3gIrPhLWXI
	jLH390GjnogZSHfzno3/3qeFmtypg30=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LI9txNpV;
	spf=pass (imf30.hostedemail.com: domain of sef1548@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=sef1548@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-38dfe7eb825so1359804a91.0
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 19:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788576198; x=1789180998; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nN1oOZhHFA6iOMNOJ2Qu+h7C5QPyvLKsSkfURb8yDX4=;
        b=LI9txNpV77ZmrUSEBoTyEHcOV0xULhigi0ijlOmEE1aUSEmRR8rCoSgM18t7DhIvI+
         W+QEco/6rv8gXSPY0vXOk1c4xwV4T76p1PzXRFjfH88Vze+vSPkaIE+mzwbLfVsSC9Rj
         K3WQ8MWpjIMLnK2BZFraUQ/dHvNY06H8gqvH989ejpl3O15VRZYDFeg5kG5Qsb5BayVq
         gTReq4qS2ehCpA2lCbs8OVC/PxRgl481oW5GJq35sb/6y6KJdl1IaJOpZzeDn9EkLoAw
         l9NkT40bIiFh8huqAYwAUHINuu4EtV+UAORaJcAzsTlfoxsq5+LR6jA6Zo19gDOcG49r
         vS6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788576198; x=1789180998;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nN1oOZhHFA6iOMNOJ2Qu+h7C5QPyvLKsSkfURb8yDX4=;
        b=QsiEz1YlH6SC9KreNKAHwhK296r8Zk7Ycu5dsz4Uv8ZxhGX+UXzzNjabtXegdCt+vJ
         BwF8Yz3kc8TJA4SgGZHqg/q6xwyl3/aepE069Cm2dvx3s5h3I61LDQEHtUKWQ52Kth8S
         t4oBq0HsIUdjQUKgxbRTFnBtaf8dmsaI6QB6tfCJzpvH43Vju1KWHaDcHoa6fCmYg1dX
         gfcw1CQV1srat97tiiAiCukPiaOguBKqdoPh2V4FiZGjNlb0dtU1TT2JUicHN3mVQ8Gv
         0iytaH9diXfImYG/77KKA6+EfK96pLfTirKAGiwmmSgZvaUmdgG3/OgxlPfkLA5rsL1/
         Q6xg==
X-Forwarded-Encrypted: i=1; AKwUvBw0GNVzJMPxR+gJWZMq/bQ6BhF3CBZThrTbP08aUrqebOWXwttjeepUPjIgWCz9bEoyApKnGi9veQ==@kvack.org
X-Gm-Message-State: AFuF++m447UqycgH5VUbxgio5dpjmo9YU776Dkb4fhIEVJLVubyhS+r1
	mK2cdb1iWXkCS5a4TKCqlL+tvx8/29yWG64KZKpSSqKrsn8lNg1RHCPv
X-Gm-Gg: AYBFou2w4BAx4VMsFLA8ptvlSBQvJT9hRHocgB6k5tmmvXDn7BMZrEvwj/ZEAcC0GcT
	ly3lCbXV/74UtAHYhU1WGc9ICpK6Z3X2RMbnz1M6Utan3AbRQgs0D3FGQ88QyEsfzkuBAk7Sbf7
	az2dHdGRE8LVxKleMiRfRqrD6pOybkHiqzJLXaseTAgsDKsB9DbwQfrY0WNpSu1l0+euudf+IdI
	S/tpwFOjAczK92UURPfv5UDDehrkV6HOHrtl9/4upOg33464jN3e+F2RfCNpOD3aoLUjzb6iTih
	i0mjU2Z5Cm1b5kFJACo30hMkboFzVA/VuiRXscaTNKD/y1rdgnEHRQLxgKePwGaD3DnBiZwV/cB
	So6xJCjRNdDHA/kScS1j/63W2L+NhHpy5Jy4Uv0PebbvyH8XN8I1L0olQAX4UgW6e2JdN3z4Mdj
	RWcpxU9haCSHqRxw19Xn6bf8+SQMIHOHbOUqmCcf3fvw55N9gcH/mPUIBD7NqFY0IJVz6QuN9zn
	qkJUaQ+Yp/epXmDnXwtATcWNiEJBBdVQ+whqrsjzvgsqgJXc4Jgr4g9QertAT2s/nbV+uxUWJfk
	BJ6NNf25mZw=
X-Received: by 2002:a17:90b:5807:b0:398:9be9:ab8c with SMTP id 98e67ed59e1d1-39b26229bd7mr15729029a91.17.1788576197758;
        Fri, 04 Sep 2026 19:43:17 -0700 (PDT)
Received: from nickhuang (2001-b400-e206-2f43-77ca-14d0-ff57-9965.emome-ip6.hinet.net. [2001:b400:e206:2f43:77ca:14d0:ff57:9965])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08d086adsm13735453a91.15.2026.09.04.19.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 19:43:17 -0700 (PDT)
Date: Sat, 5 Sep 2026 02:43:10 +0000
From: Nick Huang <sef1548@gmail.com>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, maple-tree@lists.infradead.org,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs: maple_tree: Replace removed bulk insertion API
Message-ID: <apuBvv2sLEKPHlQN@nickhuang>
References: <20260905015509.76265-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260905015509.76265-1-kmehltretter@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1157980002
X-Stat-Signature: wwj3axr9fwjmb8diemof8msssyjzet86
X-HE-Tag: 1788576198-379104
X-HE-Meta: U2FsdGVkX1/mbO83kx4QhPoa7d4amEPK3EzZGJkvWd2XaYrYKytUhvn32osqMYjvlXFnSK5s/QVVToQswU1Xf67kVTe6yaV7Gdo4Vi8DDxXHyOVv75lL4PRJqpPo9+EDay2z1Q7PdUQcTCZZ3JWV0gvqvxsTx/lU6J+6Y8d+bd2mViz8c/8W8SGcI7yXx7wFihQx0oR9NIguxiymv4g/27D+eyexkxGILgxcpOQp8vDZ+NGneZjPjcu/rMq3qz78rK7qWDxHE2QEnqTA5oi3J4Uffm7aMOb/6/DZKvWCATwYdw5bfzAUAO7ceqmMBTdzKAqo+vE7ri9mN1uOcYsfBpTIjJPHbDoAKgvTnFAeh3KP6acBqO493pDydAbrcPDLFMlXngIlDgOzkhyMJhmvHZeSqHPN0ShM16jdebHigkRwAYtwlQN24VOZUph2l5yHF3kIUL6Nb2GWJ1A5ulmzTHS/NzZVjnO0NYUVcsOSnt0e0qoypLRCuNRcE87y+ANfXaO+CCp5bnm2uzfnzhUjUuxPI1/ZnD921cnCuBolYGYnVVw/6+1nFIEXeSeym7CAS/ebx0og4eLVMFsMq06C9z9d+o4NHbW64AWC4XF8gVSrpxknoc2Wl3ROk1C7oxqArQw45NZhbc0cq/ML2YyvUOzD/pkI5UEUzHGL+t/FAUxp72O0jRRtIEH11KxQ9BlfytFqAWieD0QRV12wOQcUjnaFlxcr7ry+m6FlENkO+enyt1a07DOXVd2UN0zzLg6WqcfAfGS6YWw8z86nCmmXf+u7eRZTj3/XgroWlJooI0zvmPM33nyAPLIx2NqZjs5mnmCNCuKKN4IWhQwvbOpeoARF9B+jngm59a6YDnFRczCRCM7zUqg0Uis09IKe60ZW8vux24XClYZTJfEOjpXIVLPmKCtgVPfpeAkcDNPtkWCSAmFAZvDZ9LhxxXmCyrWG7mJIp81eGRRBii6IThD
 fb60gGKT
 I+o0dnUs8Lr6iM1RrpeyVp7Z3HiKW1hDIGrdCRDe7VbNyR2n55Q9Sl50civBziExM4RjKIEh/yMFI7lG3HdGVAAYh7O0bXROhp0UXIYrRJPOvke77CYzHK0dCQgZLB7p1bLh++ueIEgO6tzBd264gsRFXLWwbLVJoPfWfvU6CtGmrZAJm69mGvIb16a2+zIBmkehI4ezwqtOzug/qmHXRzEL+0MOxE2ilko+knsJx4SlKGDA2fz5UI0aAShjdf5sfPHFYws3toy+eEDYq2Ihqm7cahI+grSdrWdsoUnA8blRFjxYuDJkse9x1xyt9+6fUztp3cnDsim9rY/ZYyCTo96Vqgqyrvqb051wPZcvpHpZSoafiY44XmT7A2GcNvcYs6RtFSRLNHdOKXotkYUNVvKOH1PP7R6BJ43g5/mVYsYqVEFp41T3L4m3DGOduzIiok5us4C3qk8A7GWxqfd4In80eqekZdIO2zhVhFPPyUnNeQl8vCvGEaqdqu1EJ5JFL9A/drMMATb9eUVsozoYURV7xwYX8q8np7sJbtVbCBvkjPue4AiIQtk4Fbm0ftwx+awfn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 05, 2026 at 03:55:09AM +0200, Karl Mehltretter wrote:
> Commit e3852a1213ff ("maple_tree: Drop bulk insert support") removed
> mas_expected_entries() but left the documentation describing it.
> Document the current preallocation interface instead.
> 
> Fixes: e3852a1213ff ("maple_tree: Drop bulk insert support")
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
>  Documentation/core-api/maple_tree.rst | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/core-api/maple_tree.rst b/Documentation/core-api/maple_tree.rst
> index 12bccfb6aac1..836342fb1eec 100644
> --- a/Documentation/core-api/maple_tree.rst
> +++ b/Documentation/core-api/maple_tree.rst
> @@ -214,11 +214,10 @@ Advanced Allocating Nodes
>  -------------------------
>  
>  Allocations are usually handled internally to the tree, however if allocations
> -need to occur before a write occurs then calling mas_expected_entries() will
> -allocate the worst-case number of needed nodes to insert the provided number of
> -ranges.  This also causes the tree to enter mass insertion mode.  Once
> -insertions are complete calling mas_destroy() on the maple state will free the
> -unused allocations.
> +need to occur before a write occurs then calling mas_preallocate() will
> +allocate the nodes needed to store the provided entry.  The entry is then
> +stored with mas_store_prealloc().  If the store is abandoned, calling
> +mas_destroy() on the maple state will free the unused allocations.
>  
>  .. _maple-tree-advanced-locks:
>  
> -- 
> 2.53.0
Hi Karl

The documented behavior appears to be consistent with the existing tests in
tools/testing/radix-tree/maple.c, in particular the mas_preallocate() /
mas_store_prealloc() / mas_destroy() handling around lines 35173-35185:

https://elixir.bootlin.com/linux/v7.2.2/source/tools/testing/radix-tree/maple.c#L35173
https://elixir.bootlin.com/linux/v7.2.2/source/tools/testing/radix-tree/maple.c#L35185

Acked-by: Nick Huang [sef1548@gmail.com](mailto:sef1548@gmail.com)



