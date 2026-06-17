Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A31C9CD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 13:17:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A275E6B0088; Wed, 17 Jun 2026 09:17:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D8696B008C; Wed, 17 Jun 2026 09:17:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ECE36B0092; Wed, 17 Jun 2026 09:17:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5443C6B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:17:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E5B141659A7
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:17:36 +0000 (UTC)
X-FDA: 84889456512.08.DA92F53
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf16.hostedemail.com (Postfix) with ESMTP id B5CB7180010
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:17:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LqsErQD1;
	spf=pass (imf16.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781702254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RwC8e8Lmq0O5HhDIZSANNcyMzpbq38LuCnVbAdWRbDE=;
	b=7q9p8YqQcqg7G6lbiE1BN6N8KLxXRdymsGwP0jRbb2vvr0XBri3m5vkG49FHUwri/+y6qm
	/oQyWIkVQ3a8YBCxf2UVped14cfJHaBzvE+AAPCY3+pokUmKsymamhFQPTiC40LFJFzX1e
	9QbdyGh+nL9jxqEcBFUxxjPDjfF6k5E=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781702254;
	b=j5PpPOVUXKJZQ8sCo25YIunIV2cnvSmsq9HCEqqWJnt4a4VSM2zYGdzpXbEGsz+hLNa5rr
	B5V8PnBk8SxDkn1nNXEKGmTR/qmTay4+BIltMKyWK3anlbZhouyvzO3MqJxX3nvaXhz7FG
	8vsw5IassgU9+aY4Va9jwnshnSIPOn0=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LqsErQD1;
	spf=pass (imf16.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-13986d61b4fso1923968c88.0
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 06:17:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781702253; cv=none;
        d=google.com; s=arc-20240605;
        b=cVVqXrncJbpD2lzYs6Tq6tUykKb6yWnv+wAvqYg9PXlp4UoD6FbeVcXX+ZY9H/dyFg
         gLJhOUGLagSaZiEPc++Y1LKBkRHd942t2F6FMsCGJzqOsNnDk6rqGbil55rxgNw5gDju
         iqVQYtxqKQ5i9somowedhO5GnQS9y4cBrbnK2lz0xQS6KdOGBhFf8W81gGAAY3lI+KPv
         oWvsAnKN2b7L/YWNLRwEXzs1IueW8Vie9v/qNlS7wIsg9Cntgd9CUrQA4PyQvgBm9fMp
         f8nPxxmXRqniOhJ/f+zs+XbVWVszelfFW9H9WNnnpYY4vym1c2EeI3kAG9+/nQ4hiYg3
         n4Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=RwC8e8Lmq0O5HhDIZSANNcyMzpbq38LuCnVbAdWRbDE=;
        fh=aEvYyVz6Zp+tuCmjqRiGWuoxJnQJP57+8hqsWVdfmpY=;
        b=C+3AV88bS9VkyRHjVfDRcfjG6QaL5Qi2Ir1N+pQcMcjA25Pdo/vvCEwRXAcy320AW8
         3Bh33nN/fMesY1GqtljHyTwJeEKm9Fhdkmw4svyKaeKnyhvHxc+2V+QRMrEDw/XviwDQ
         fYYeTbv6scdlmN8V2drXqH5yupjN0+uKwyqDk+oNbRjv7/djLzoSfJCzYig+VJQ5c1Ds
         Ldk7Xou946JmvUv5QyuYPFOAsf5T6gZmI8arVtbze/wwTWdAbRQGLG8R0d94UV1hN9re
         nFg31BA2+Azf+z21JaKb4VtmzJtbyzVDn6OCNgwJFyXvikSQEOx7XLGEHjiYZbKvYCgl
         CcAQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781702253; x=1782307053; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=RwC8e8Lmq0O5HhDIZSANNcyMzpbq38LuCnVbAdWRbDE=;
        b=LqsErQD1Fur3cmXtnI4913xfW4qGWyMpm/XdD/j4ZrwDOdwYoJZcJMcSpWjF0SMtba
         UMAYIqnD52Vd4iI1Ycd6QChDEZclLEJN1sBLcNV6PJK2q3lFacPNg2B3oVJzpxnmy2w8
         Pm5lY4V6Sta5Bp/SF1W0dvEduIDO7Usvb9LK8zuWc//gFCIaW77LdfVXm/qmYbpckyqQ
         oH+3bCJxCeWzaTZs3NgyuAeY0I4yNoq8oeIiEWlda4/zyuGUkz2CwQUHILmaGmswWnwM
         ntqJKBzhPglJYoUD3nH2Pc4RcaA7myO10+ch5AcPnjK3IjiMcjWz6CKmBzS5HbaQaBoA
         YUsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781702253; x=1782307053;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RwC8e8Lmq0O5HhDIZSANNcyMzpbq38LuCnVbAdWRbDE=;
        b=kLvxw20ilCdADCXfAO9/SbiHf7WPha+O/LXmVBFax7+KkMP6l0Lu+dGOT0le1l0jY+
         6vtrZF3n8lSvfAHagBRCIjzBR0/egCYzO18RDVItstriUtOosZC3c/dMXwrMcLnJXFyz
         eAD2T09tDuegP8YmCDejum60ZTFP4hPDC+tDWhOygh3g49aLytVH0ZptvVYigt3+YJIp
         RXyXlObkB9pfRAefvRte/j9+3szFnzzVeZwvuOzHS/+yJI/zGWhZdsenvxiHJR+GMaZV
         SoiTWfU8uGZc9xofL2/sFcEPEvKhbqyg5qvJt14MVOQqZ1eRyN+zM9eklxmqNmy3sSJx
         8fBA==
X-Forwarded-Encrypted: i=1; AFNElJ9YD6Mgl9AijhhXeOfFCk3T9cpS0lWJ14XrWlEmPfSQThlIdiVLs9LV3USwjj+shijUN7OxukBF8A==@kvack.org
X-Gm-Message-State: AOJu0YxgmlhTSK7i65dQujZW7TpELKkIJ74op3KkAlrcCW2r9/F5effN
	XHxEoB4ww224mTngWQjA8vMW4hdE9a0nBlffPaOom1uaZQ6UdlzUxpqlEWkvDjlrP5GQWgeSXLL
	FtkRPtbkYeN1xl+o3hEHS8NSHqMj8IwBNOS6j2NYg
X-Gm-Gg: Acq92OHzPhbOUHqXXQEoGgMAg26Ir3EYYhadQxTz5BEbxCmkaEgN69RBRlfXicJFjwO
	M37Myd4XW4BnkLOrWUMCdHqOvI+VyWPjoDvo3Mj3Tl+Flw2+kQNoWW32lAcmpo56i/jqf02PrP7
	WhtojaRgp1gVS8YCVsFwHVnCpuXnQipMxc9HHmZGpn5eLCL3fTmWcuVNF39gInUXLpydtAj/yTp
	paf+nqRAI30uiNPyBuwCsSoDYM6gp2tpY5kzrC8LFw6Bmp7Rz0QGBGLh6L3O9IE77IJ6KFw1Al/
	lLU9KWCUAbQqOaRNEO+ETcBJ0fu1
X-Received: by 2002:a05:7023:b0a:b0:137:fac1:c062 with SMTP id
 a92af1059eb24-1398f666456mr1449795c88.7.1781702252499; Wed, 17 Jun 2026
 06:17:32 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 17 Jun 2026 06:17:31 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 17 Jun 2026 06:17:31 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260602-memory-failure-mf-delayed-fix-v4-3-a5bc7db5a9b2@google.com>
References: <20260602-memory-failure-mf-delayed-fix-v4-0-a5bc7db5a9b2@google.com>
 <20260602-memory-failure-mf-delayed-fix-v4-3-a5bc7db5a9b2@google.com>
MIME-Version: 1.0
Date: Wed, 17 Jun 2026 06:17:31 -0700
X-Gm-Features: AVVi8Cdef2qXnvj8kjBvz8bXKzlY8rIYk_kwyzXVJwqQ7pJ9jLNjcBvloKBgS-0
Message-ID: <CAEvNRgE2iqYpEy8F4df2b=zegzqmJAgVJs5xz2KD-jxe+0GNMQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/7] mm: shmem: Update shmem handler to the MF_DELAYED definition
To: Lisa Wang <wyihan@google.com>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: rientjes@google.com, seanjc@google.com, vannapurve@google.com, 
	michael.roth@amd.com, jiaqiyan@google.com, tabba@google.com, 
	dave.hansen@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: B5CB7180010
X-Rspam-User: 
X-Stat-Signature: cr7kn5s7eijbtkf4ndnkaxxqpbd9k9kj
X-Rspamd-Server: rspam08
X-HE-Tag: 1781702254-306568
X-HE-Meta: U2FsdGVkX19DQaeOHlCf3vWtBsU9djwxSJF/VgXRO64Zj7HmT84egFptGdXB8xEsjzS/DVirJW7QSvSzofbO9JbjgaTQ+zMCenChGrWn2QtPP5Kvu2kY1VNBS0gbWH/XG6UgYyJcoow0xoTptCQAJpT0bNrEshzi3brEJ03t7gLwB006JiCReyGbgUuS2qMPByMLGwEd5nq84Rs01+fBRUTJGwgycS6S9O2/7WeLlVddn9B2pUUzXGyYdLjjgZBgoKcKDPw3igD3EaHM89aFPHE96xAu6zNV6BhrYrqLrj0Gh5DLU5jz/9AWaonlqhdsjOsMJuc7uM3omYGg4MpoELOMpeOqeWXkE+1I9L0BSOM1cFAO1TYj2Mn8mKn4JitYT42PvSTPCKqrRe75qJQfK0J91dYvEa257jdSlOFSdlX9g/VGdnrYx3I+HBRSfKp/fxu+fC8d6LJhXlr8VU2Yto33HT6gSBQ8JXKiGBKKOaoeQMLs5SYFqhs8PYmNyxVBmkvId6R4GEL4M6Rhx4/gzgy622rsUzZKrMB0d2adM0pnuYrWvETnmCwL5UeQl389wSDRWtBweXfhJz+TwidrcI+NB8GYXzXuTxzTetpZmsk+AOYFDHEUCt39miKtJ6oEypu0wunIAhjyyUjrdmgFBO6bEmWsuYT/wJcVVoSNAXfrv+sYjtxXIPQodroH9WmKxIpStGQHC8RTx1QknJ/p4FQU9KgNSFoXezLd/gpmVADDNbkLavAlUDWfBJzuPNC4UzJApvYgcb4k+lB4pqkC79+HMlN0SbCTCfJeAzUXbTwohhaJWxzekFXVn3Rf5eu0qC4QZIk2PGxyn5FhLwXEYCetK1hvLrEoD3DdEauYFESwXpvx8fdcUyK+N5BcmRDGqxMExV/Pv5oX2IBaPODlSKOtfLRPgdmrjgyJEQylGYnZ5anFHRkdPAtBILkvzhhca1l+K122sUysWdpA4Gz
 h0/5D8DB
 sWjVaP2W5gAj8mWAWC6gxsiRts1DEz9or7G8/jZU/YP2pXNInJp021VhsX2amNHrSD76JspAo2Rhl5XgwDUSTjQrSwCsxbUXAh0Xs+5UMHnKQHkXNzSQX6TaB8N3jArYxmJdht/5GG3UrW7OhJuO5rjurwgcjF7aLH4nDqgagPhV+u/7vMD6k17VVdE7stddV/oSV5cyyBklq/XYD6CFwTEWJzbVgVmrBhfRerGcQiITQgHD/UxdvLhxz7TZkUx44nAKdClN8h4A3wtXSywFteuzqsW1DauJXEYriwR+es/rQiz5jGpoUSQrsMYQxvGRQINA98Mq3pw2V0yI33yTwrlxMptwsP5R8jUizfJ7pjj3l4QJLEf5IldS2YeBNpJoSMxcHfydmS3AB4h9TMoPDg5myJwzvcG/CY7gHeCZEXrjYxkHX61gnmGP150aeyirx8qfy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Lisa Wang <wyihan@google.com> writes:

> To align with the definition of MF_DELAYED, update
> shmem_error_remove_folio() to return MF_DELAYED.
>
> shmem handles memory failures but defers the actual file truncation. The
> function's return value should therefore be MF_DELAYED to accurately
> reflect the state.
>
> Currently, this logical error does not cause a bug, because:
>
> - For shmem folios, folio->private is not set.
> - As a result, filemap_release_folio() is a no-op and returns true.
> - This, in turn, causes truncate_error_folio() to incorrectly return
>   MF_RECOVERED.
> - The caller then treats MF_RECOVERED as a success condition, masking the
>   issue.
>
> The previous patch relays MF_DELAYED to the caller of
> truncate_error_folio() before any logging, so returning MF_DELAYED from
> shmem_error_remove_folio() will retain the original behavior of not
> adding any logs.
>
> The return value of truncate_error_folio() is consumed in action_result(),
> which treats MF_DELAYED the same way as MF_RECOVERED, hence action_result()
> also returns the same thing after this change.
>

Thanks for explaining here!

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

> Signed-off-by: Lisa Wang <wyihan@google.com>
> ---
>  mm/shmem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
>
> [...snip...]
>

