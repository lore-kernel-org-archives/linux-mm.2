Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A452DCD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:15:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14C746B0106; Mon, 11 May 2026 05:15:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FD116B0108; Mon, 11 May 2026 05:15:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2D806B0109; Mon, 11 May 2026 05:15:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DD6B96B0106
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:15:42 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 68E6F1A066B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:15:42 +0000 (UTC)
X-FDA: 84754581324.16.F6607FE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 36DDDC0007
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:15:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YXv1Nkm3;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LvsyJ1hcvb1jj8T9yOjlWWnq8ugvuIoSIOqfx/tOceA=;
	b=iogcE5X1DXDP3ptoszc9z5ah54+s8DjII7RkvpAqQywF+JN2WXjFERur6q9tpFJwF+ZZZJ
	Sr12nQgdqDFpEbJFO6kVjpwThFZGvLmKyTT1Vy4EXlD2Ar55RL0LOPA2vbZ8j/t0XQHNhv
	J2GlkW0lqDRQdDrdD+EbvnHHis2O1Jc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YXv1Nkm3;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490939; a=rsa-sha256;
	cv=none;
	b=5yEYrUmWaNIuV+woWTVYI8n18QlUSohQCyjWwFXwbXygnPQxsBhxBKusKfSZ/05FH2v7+d
	aZrFxywk5JyYeeo52W9rR8Q86h3hXBPVRkKzeIjtwtFbwvD1KRi/gbCSHmTnlCj5LFWxEY
	0QD5jlvVi3itEkC1oeLWRoXJ4sh8pww=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C51244390;
	Mon, 11 May 2026 09:15:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D363C2BCB0;
	Mon, 11 May 2026 09:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778490938;
	bh=UtZQ2M+zSovzc0lXuXD92/mA5wpJzOmMGuyvzsAw/UA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YXv1Nkm3xbY6GJx8oQhu2MsMgulMHa/cQoMnyJw1P1KEgOk/H/al3/FHoNEDlhm3C
	 dizgRDOwzPBdRREetZv+k2tzchrbJ5e06Gh26ci4WJZFzvtWYKhtXddU9Slgu/xmon
	 X+mM1Y0hEdfrQjqkw8x9jvIRY1ASBq5lAWyxE0PCPHZqDqGSlVOwtGkFFJDK4W9MY+
	 ok4YO2iZIzBJqOtbfpEFr922lA4R9OlgMjkS9WvYERbGzP8FTBKcomH6anAsll7FY2
	 qXBtdy4Bhj9iXZ+j5kfgj8iqKfNTABUgAJNChvmy66GGpEudTfKBxwVE7xoQ/9+oIl
	 /hQNGn7OAISxA==
Message-ID: <3a04ae6a-049f-4d3d-b5c9-e60e86be8e5a@kernel.org>
Date: Mon, 11 May 2026 11:15:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] userfaultfd: ensure mremap_userfaultfd_fail()
 releases mmap_changing
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Peter Xu <peterx@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260501145433.156211-1-rppt@kernel.org>
 <20260501145433.156211-2-rppt@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260501145433.156211-2-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 36DDDC0007
X-Rspam-User: 
X-Stat-Signature: mr7gb1z58w35ku9tse4nmip8ky8ouoor
X-HE-Tag: 1778490938-49350
X-HE-Meta: U2FsdGVkX191P4gMikP2GGGjSwGLxT+cqXY8ae9CVtkSBxcMfEDJFPJeqT51N0ANkPM3WqN0sXvWkDlC2PRitG7ATvExxf4Ef82lujfYFRB56nEgLZsyyANbf1LFPz8prgG6XdBCDq/gvy/mbCFEJ28bYEZY4yZNMVfCc0USq4l18IzptjBhE/ZzsBLvagRg9XpDXp2W/xD8i1XgSFdFuiXtSg2TQWtAjMXGc9d0xbj5BwsLmM0OPD1Jh9acQH3QV5dxHZ30I4ZdNFAeD+V95oM/0wL5NWNzHuA6uMHxdjA7lgCdp+wNetSRRkcg8VcKkSQpmjb1ht+4Duke8z7kum/sdz5Rk98BC0La5qhIxD+GztVpKtF1kubUKYgUBYuXT3P+SPUJO47GulD8xrvS8ls2RMNFLmcKSQrCGvxmmDrCP36EN/pWrYL5CHM46869ckJOIn0KnL6SRT3zjFi5COBI4VbbpKXW/7a9uPVOmHsmOiJgD/u6k+EB936MeBAt6Kjull/LHtoQcIjWgXOpIGm18eEcdzlhKqECWbveElcCy4Q0JhM8uihKpCIfsJJWaAH3nWxonD1txwV4ltF0HOkpJ6EsQLgbDipFHXp1x/oVEfTZf4zXvrDPIL9ghtpGtseB66hPq4ycgExAWzribs5BSFRzHNXOUcUvlAI83r1h4fmdlU670YDCQWzDnf9LZo0gFnAZVtRZdIc7Dc4DcNjUg+p/ZsKVACCHLQAOswxE+6cRBIR0iYOZwRlCv06XT4MKxev1LZEyeCTML/PwA41sj25K/yrXYQwv3OcqJ7o7TX5LEVBnv4yHgFB1EQ2l0/Gs+0h7iaHWUoDDSkSwotxHejTyQR09C3LLb1gSpdBj32SGuW5O0XOjXgylHAvkYvI0wUa8sQKY9MEHp4uH7TONtkicmLEH/zdtGvzZnX8bRaurmHqnBFkMbVxQSL+RxN1R9Y8bwxb/yPhAyiG
 dL1Xrwi5
 ZpIt2AJT+LkmiVRRf3eQaQ9oRrspXZQQNVp8c7efkjsS9PMMzB8wBoSB8TtEb2rZO2wbs2SmWnPm9b9EqsLBEufOXSUqtyqxgOYTMIcSYj0if2oetG267gfG9GB/RS3rx6biPcKWCRozzad4Tk0cDLvo1Q2U+quc6BzYz3DihYVo9sgog6VbCW/bS9cj5A1LHKR9g6i9KTYC/tpMsGxif98Lv9lx66h87ZX+eOli/3qh4sTQRTR3PpIdqiXbYw5ThsW0jOWyQYY798U8rAsVhwDZtCW+Ne9QRiOFlv2IdQsghPzg0OQoD5j0JiF0mtzxFnSylSTfWg2OlFoeRlogGAnBXtN2bqXNZEpUJ/kfQ5gjatDqK6BYq6UzsKu0XUZDAtZBb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/1/26 16:54, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Sashiko says:
> 
>   mremap_userfaultfd_prep() increments ctx->mmap_changing to stall
>   concurrent operations, but mremap_userfaultfd_fail() does not
>   decrement it before dropping the context reference.
> 
> If an mremap operation fails, ctx->mmap_changing remains elevated. This
> will causes subsequent userfaultfd operations like a UFFDIO_COPY to fail
> with -EAGAIN.
> 

Sounds like we should CC stable?

> Decrement ctx->mmap_changing in mremap_userfaultfd_fail().
> 
> Link: https://sashiko.dev/#/patchset/20260430113512.115938-1-rppt@kernel.org
> Fixes: df2cc96e7701 ("userfaultfd: prevent non-cooperative events vs mcopy_atomic races")
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  fs/userfaultfd.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> index 4b53dc4a3266..ef963a58f1a1 100644
> --- a/fs/userfaultfd.c
> +++ b/fs/userfaultfd.c
> @@ -786,6 +786,7 @@ void mremap_userfaultfd_fail(struct vm_userfaultfd_ctx *vm_ctx)
>  	if (!ctx)
>  		return;
>  
> +	atomic_dec(&ctx->mmap_changing);

I'll note that other users have a

	VM_WARN_ON_ONCE(atomic_read(&ctx->mmap_changing) < 0);

In there. Likely we should do the same?

-- 
Cheers,

David

