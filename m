Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8E94606A89D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=LhM4Fldr
Received: by kanga.kvack.org (Postfix)
	id AD75D6B06B1; Fri, 13 Nov 2026 05:57:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAFF56B06B2; Fri, 13 Nov 2026 05:57:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99DC26B06B3; Fri, 13 Nov 2026 05:57:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B5886B06B1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:57:03 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 02B0D1606D6
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:57:02 +0000 (UTC)
X-FDA: 85429793526.20.59E7A4A
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id 25E0A140005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:57:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=LhM4Fldr;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of elver@google.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794567421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h148AzK7ulcLWc0NU3jZpboHW5vO/KJ9aeMyUmTns1k=;
	b=gBSnqVKbcycjc0bp3jsVcE52jkljgc+XasRGlmE4MrnIw7NYKcM9q4bVcZUmGaHjQ0zpuk
	5gNs9/xrS67QHcqCRq4QlUDn8g9MIBHCvu7RJ6lVX7xXshpCVe8YiR59j2mMCkOiJdGBN2
	+uEt/JR9rMPmpbREd4q08eisZuhjxJ0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794567421;
	b=l4K7mzpoD2Qy1jZblTuNr+DUHz2Iv/h8rs8oZnZZXQIC7LljxYCTTVQJrNTu6rWNy82kr9
	wd9UHnOV8afer3AUfWO2PPjc4NmfW7Apxz5bpSKVEh1AfeAyTMlpyjQjrwKD5q7zLxD6CS
	zuRj7qtqGnE4xJADJTOwa3A4Eh8FRZA=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=LhM4Fldr;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of elver@google.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=elver@google.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cddc597d062so691554a12.3
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:57:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794567419; cv=none;
        d=google.com; s=arc-20260327;
        b=r6MU0mh66sLMFHEn5iMxVyjdNlavRv9TN8YfDEKrwQnT5uhk2SL6qT7kG9fZQ8n7Nm
         U5pErsivBc8ZzOZeNLn6gdWK7SSjbMh4pxyDP+dX28cIuQUTMw7JQ8WDFAY3EZSYf2wB
         TpPFfmGW9fF/BzODjb2ZSiaqm+yYpEbzatvKjU8190eXHulqYQQ1z777xCIaYgqJRi0m
         EviTGqlaXhYBYoTHU8qbrI0km/Xi9ouPWVbgVf7Epizb6ubhB+x9x1hPp6Ih1Qs+Mh6W
         I86op7ssVIyEfrN8hA5FxghC9qs/h0uy29N0mjluqDelBN/M0ndK+c7DP9wUyHyx3xgu
         Ugyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=h148AzK7ulcLWc0NU3jZpboHW5vO/KJ9aeMyUmTns1k=;
        fh=wz6J5omm4keNJU6wGZqPHwUBPx1c+7RL6YdDHwnTMa8=;
        b=eZN62ji1jBPB6ZM8nulqauRCS+EUww8PNsQVc9KQPtV04stcLV4AWtU1GYeSt/fOiD
         cYtolBNs1YK8sLRrVSBpDQzaD4ZzRJcgTH9fWeADmm2PGeiz3/xMMvYINBzLYmMgn2SA
         MxiQ/9tBawe3sqFZM3O5VxqtWmVA9GF+9cpBfsIQJ4SLOcEbQCPdTQO7rIMxOmYMoa7M
         vkDfKusjGTmpphSHgTqxHSU/PztPyedqgkzybPFfIdh2bwWZkDmZ9OLNDGqgMhsxPdti
         cJ9G5KxZUYscX7epMQHWYlGyb1Op9vBj3xqGF+kSwOW7qxfapGaU6bJtAVxniCZldIRq
         2Syw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794567419; x=1795172219; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h148AzK7ulcLWc0NU3jZpboHW5vO/KJ9aeMyUmTns1k=;
        b=LhM4FldrWf1fkIxvM2cWHaLRRLCOLB4zGCDyzIeYnSygbiJ0cgtN767Yi6K5F7ar3X
         cKYce7Cii/QIgoleaQvfHx260DUlV/v1Flwn+tA3SxTb6JP7CAi+fUHwAu4fZ7yFyjQi
         7k+2yxs5gUtyQjmfQAM8Z4C2pEou9kth4Du/4DFfXK66r8RvOzZdw/D5/qx57E3fBIYj
         F5SAsUvmYF4ZpyDG7QxVn9pJAMNRuSxYq4KGjcv5WGhWI6jds5D1xf3VQaLAl9OJvta7
         D0DG3zen2mC1stqRCtracPSFbG3sCxIpvyGhss5tSm6v/Cdt996uDZDTxubDCBHrY/ZZ
         fdXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794567419; x=1795172219;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=h148AzK7ulcLWc0NU3jZpboHW5vO/KJ9aeMyUmTns1k=;
        b=TenktwbcYYWF5P1MKjJ3/zqI63w1D+z5cIFaZOnaF2fmyT0rKttYK68p35ys/J8Bxg
         1rKOczJi2sHWdtu1YjTKP4zFNrfhkcF4zqVtnuxAT6w+52u6pbUPdjGADf/jv5q9WqH8
         upXi2eNTxidy7gtvIw4pwBPsU6TikN1EypD87A2Q9d8Biwi5R69iw6YiIZA/xqJgaovJ
         Sl1zkDXv2rCYuDp1porYfdWUYSbOZXF7nh8sHD0/AeJqaVap7Nu6zA4dSTYrBiyH0W8M
         VzVcKrzB1SwjmTu2jG9ysL07tRqqlQomt113OiDohTq9oQ1VG6/KP7M6/QXgVglviead
         N0dA==
X-Forwarded-Encrypted: i=1; AL+hErGLSjA7eDku2KlYDsWZchrDxNRsH7xVT7ItS9D7z2U3p9nhVag+MAs0+WhlBX8XXNVcN54LxE6I2Q==@kvack.org
X-Gm-Message-State: APuU4Z8Gg29tvALQ08wQN4jtnhJmjn0Qq+CKhjHzlGCb+JT/cNwaZhna
	PrFnHU4nqR3GhK5xFTFLo3S7gOk5+UADTBYiYGduIKI+HKfERNBQDmvBDtlpfOse80yIjAUS8vK
	IP/RtF55o7eCKrtmO21qkAtz1J+Y+FC0kiKnxSBia
X-Gm-Gg: AYBFou38AQD8KmR0lMjvsDSmu4uW/Ypeemn/rZJScZOq86wSL1kF9Vy6RwUR29VPV5j
	f0g6ThdDX9ZoDVpTJUx9S1cdAI/6kj06QT3iI8OUKYYGZsj3By3SbWlwvJbITP24G1Du/sAwbvR
	k6bEKbxIN3xh3Btgc24ikDkoIp3i6vUCz87a5R5JfimUXP+65ZEwxks/zz0PIplzsjGz8bY3aos
	8B5DH9lR1XyHg3VXHRkwUVY26zFB4hGvjCm8DlfMiWb4tJJLeF8BBjZ0sLagEEwFFJj7kgzKp82
	3LC1CdaIOX+DZ+CJqBS1SN/fPEiN3tvNap2ECKmeon1PRof4JWM4v0b8+QnQg6ET53qJZ+6FtqS
	s6ZNmOjtPz09mHyl9C5gpai3Bmnp0vw5tzXnunBZtUFD0kHCRCyfV/dLc1K1prLFFdz6A
X-Received: by 2002:a05:701b:2810:b0:1af:2ba7:e44b with SMTP id
 a92af1059eb24-1b503068de7mr2114022c88.3.1794567418689; Fri, 13 Nov 2026
 02:56:58 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <cover.1794506262.git.chris@chrisdown.name>
In-Reply-To: <cover.1794506262.git.chris@chrisdown.name>
From: Marco Elver <elver@google.com>
Date: Fri, 13 Nov 2026 11:56:20 +0100
X-Gm-Features: AclHuK8EymS8R4ke35k_Ts4zDwGVpBzqd0W1daXPPjdA8aiWj2M9LBxfbR3z3Fk
Message-ID: <CANpmjNP0cWB_670hYj7p+Dd=do1qEu4XHeW+c7sTv-MXi0UBTg@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] mm/slab: Support selecting slab hardening features
 at boot
To: Chris Down <chris@chrisdown.name>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Kees Cook <kees@kernel.org>, 
	GONG Ruiqi <gongruiqi@huaweicloud.com>, Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: fpap1qa61emjwb6hhfhms5y5ds83x6oj
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 25E0A140005
X-HE-Tag: 1794567420-666697
X-HE-Meta: U2FsdGVkX19jQYTkXdg62GSNIGg3LUZRkWvNO8vZCbGqKIIDSp44sKHD2uHQljXIHESqyRD9WhCjq0LyY4WwyIALwSh+mr/5fPy69PlxkTEzLwLwcNzAa12uEBB+dRo1v0jqIPML3XFlI0UomIKJMhXW9AG1fGdvAJiTS1qdPLbqVTgiiOOyroFzBWC6Jra3rWypKzouOqyUOrflzpaoPOlaTdIrNa/5wUrfxgDvJ0K3CMJBbEu2Be/y4Wg890hJFQ2UNobIX+QqlhiQ8cR6Pk5LZuXCb0FV3v0VlZGVgpc7oHc8IhiWevjC4uV+cxNJ/DMlwpASoNnH1iLIj1UN1zkciUtfOwrjG161ufEdy29FEkHP0UGLFlMGhgxXpC7Ntl8T8WoBQ8/f27bLTGOqePD80w+FCQUji3Rl5q7emHEOJ3iTkHjvbAgGbHivZHo/n8BYZcu6/iRhQywH5a9xpSlJH9idJt10f6bwa4qJ4TAe8Qd64zqpoXJoCocWlKK1C/LzrD+MEDgOBrw4PdoMwhPV8vD0kmRtjPpZb8lXqcNuLYOi2L59o1lbFtUy7ra+FZUesy4FjMqK0VQwXtSXXGcJJtS3BMqRimqBSSrdPX++OIOSuXAXk1tKTZCopzd9XTNe/Yus/ZMkk10Mxgw6EqSqU7hvA1WezyTxu5oMImTbzCBGnfLFp3uDN08eCCDHuYh+dtYMO7OOEXPLwrY2vlZcepASopJtKTum9EZFp9XifcE5sL4EYLtaDW5cTROBeFjrvjAxHOScgomWtBSQxpMovs9p9RMEJebjluo9dG9gZMairrOex1j5WswTTn1GN1B4+lHOts8+8dWiq5B76RdBMv7jherCceFntCDs1PWx0ht7dy6057kwel1DRcljQaRIRRQthCcCv9JEdrSk8xItrV0Y/pxOeqXD3Djlp+TSz9lUWYoefcia51vR3UPe4eRfZAu2KGmlFkm+jnL
 jgQXMDcB
 x7bFt0G2BByPJp2ZlBbge3qJwIsBXm7r9/8+aSS5P28gscYSm75lbYOrlPIgx6R8UyCbeR6FcfiMx2QtLFNje14uJ5/Va1xGYIuxFy0VU7Np9vYOU0KcEq5xR9vKNnALoGlbdmoWerGoYvr5FFI6upQ5WUxM/1tKZbcV6dvmdUDvSjTrXahtmOLSoBu0rgdx+BAL0BXDVqIv5okZgx0AqrUCCkmghNNuJ1Pzb7T7CWdAPuuo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 13 Nov 2026 at 09:51, Chris Down <chris@chrisdown.name> wrote:
>
> Slab hardening settings are currently all build time choices. This means
> that, unfortunately, hosts with different requirements end up needing
> separate kernel images. At Meta, for example, some hosts are built with
> these options and the rest of the fleet isn't, and that's one of the
> things that keeps those kernels apart.
>
> This series does two things:
>
> - SLAB_FREELIST_HARDENED and SLAB_FREELIST_RANDOM are cheap enough with
>   sheaves that it makes more sense to just enable them by default than
>   to make them switchable. With both on, system level benchmarks didn't
>   change measurably, only slowpath heavy microbenchmarks did [1].
>
> - SLAB_BUCKETS and KMALLOC_PARTITION_CACHES cost memory (Harry measured
>   about 1 MiB and 18 MiB respectively after boot on a 64 CPU VM [2]), so
>   they get slab_buckets= and kmalloc_partition= boot parameters, which
>   default to on when the option is built in.
>
> Whether those two should be folded into a single slab_hardening= is
> still open [3].

A coarse slab_hardening= option can easily be replaced by
documentation. While less knobs is better, an intransparent coarse
variant of slab_hardening= just makes the admin wonder "what does that
actually to, and do I want it?". They still have to go and look up
what it actually does, and at that point it doesn't add much value
(alternative suggestion below).

> > > light: "I'm willying to sacrifice _some_ memory and CPU for security"
> > > full: "I'm willying to sacrifice more overhead for security

Who will decide what is light and full? I think there just won't be
any consensus reached.

One thing that users may want is an "all off" option, similar to
mitigations=off, should they wish to get max performance back with a
single option. So you could consider slab_hardening=off. But at that
point it may be more consistent to drop slab_buckets= and
kmalloc_partition= in favor of arguments to slab_hardening=, such as
slab_hardening=nobuckets,partition. This would mirror mitigations=,
and should cater to the usecase of slab_hardening=off to get max
performance with a single option.

But I would not add options such as 'light', 'full'.

Thanks,
-- Marco

