Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ADF2CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 17:30:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95E218E0025; Mon, 17 Nov 2025 12:30:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 935818E0002; Mon, 17 Nov 2025 12:30:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8727F8E0025; Mon, 17 Nov 2025 12:30:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7521F8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 12:30:21 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 23E0B87869
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:30:21 +0000 (UTC)
X-FDA: 84120787842.09.724B9C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8500040015
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:30:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vQBqyY17;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763400619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g5AiyBzCDFGeLYBsO2E+I5LeTR/SV7qyYvmw0HBvoy0=;
	b=TsKLYyM6mRE0Fd4il2RG3IHffrHKWLPPB+CGAFvKbRQelVlH6F2Un8iQTjXiLa9KxbskR6
	50D8oKzOdCyuTcNexU/gHUReHLqs2BEBk/RCzEFlWCux7LvrfFZb1YGobiCMhjX9YF6kwH
	PNON6btV2NJyAIche6L9LyD+fxD8Qas=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763400619; a=rsa-sha256;
	cv=none;
	b=amRiMlgwjuILOs3QwkTifpPRD8V8smaX+k+7Ddt77zgtlbwKnrI7XQluDdy5vQMO+CAVGq
	lNM1pokGshfzc0fzm5Vl7G3kbRsINtNz74mD+07gbh+IGSrBr3Rh3/E8sIQJAIqJ6E1LZg
	ha+pERSC9s3bjqOa249XI5bU1bHKKjA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vQBqyY17;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E99E9601EA;
	Mon, 17 Nov 2025 17:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83573C4CEF1;
	Mon, 17 Nov 2025 17:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763400618;
	bh=Ky2Bqm1GzEHmxnMmaXlwbKn6f6wgJEVKqgI6UTZ6Nco=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vQBqyY17/Z8ywTeDYuBxczsTVwi0n2RIJQKG9Cl/i31HW8BITOuHbNqVz5fzfnztP
	 eCfD28VxUoA+hHKi7NVFVoHfAwk1sAZfXnnttQ06tR5r1Bk6mZAgBDy1WoNxwiMj27
	 F7NbbzcrT8edW/pXOCABJwzib/AI/c9a3JOl/7sd+dduMfy2xtPdNt0X4cL4EKoaS4
	 xhVT0hzW/aD0bkHp2ASIbsPZe+3bnJQsB7IlgHY+OT772vTDxqqEqZ1AHHP4Z0EtqZ
	 pvLKt3NJUco9niAdhM/lLjH1x+v/4yHTM4VHqXfOeHAmX8hETkYOyaAg7iI+USIUVT
	 wUBvzybgVai4A==
Message-ID: <8c745e54-1cb1-44d4-abc3-00e6511cf67c@kernel.org>
Date: Mon, 17 Nov 2025 18:30:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 04/10] drivers: i915 selftest: use pgtable_has_pmd_leaves()
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1762464515.git.luizcap@redhat.com>
 <297c6fa3dfc50c28c05c0974c86a205984d752ed.1762464515.git.luizcap@redhat.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <297c6fa3dfc50c28c05c0974c86a205984d752ed.1762464515.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6tttmx185ujyx4jm3be94w4ag7dmno1w
X-Rspam-User: 
X-Rspamd-Queue-Id: 8500040015
X-Rspamd-Server: rspam10
X-HE-Tag: 1763400619-230354
X-HE-Meta: U2FsdGVkX1/zykVeeUrKlngJk5x2BprfxlQfjUdQGkoHlfoqXyKvfEMHtIHCwzTSHcaiuJxiVA3nO5W3FwfWXrNHzYd3IiKGdtIkbM+LMrHd40mefSpZQvgBTfkT0decTKCNuMCCo0MvhHVUSKJQocVvYkweFR2zvfRModtB729BtzsNGLxJebQ6MT0suxYd1FBtLnovkDCMeM007A3IcOHy6LvDCvSRJ30wW5bErD2eHQqio9P4VGvix7ilf3cqWEkW7xpr+J5YFeiXrOvGwJDyarz9XOFRsorAWuYZdj3DYZxHK1q9NyoTXng5aJTmtn77N2RqWFx76jmc1CEKaiDFvB6o1hViUs1B5hut46F3rlNwSb8Z1OSHOm4XFbTUG5Emn1ujL3uPnjBAeFHtIrVRlNVrDLpTSe3a70wxEHDCxXrDW4MrpK1QbjPXvA6FBjeEZ12h6a/8o8c3HLjraGHZSbHrAA5Jx8L4Wm9OICgPqH/xAapdcewE3d5V7kavhtsf+EW8zOZ4EZuZftkbGpZ5WTUA5mOxHq7Mif/mkFTZ0KI+nZC9a8+JoUmGtTtD/ZsqzNEcZ2+egl1t3F6Qwsd8hh7CKfNLGzqsfasdrov+xcNEhEjRhr5bx6zlmqW7rj/mgofap9ZJVrxPbiFlpb81abzO6GZwhlSLFu37tbvuYTYxrx2W/OLcnDlLZt/r9Bv9whqpbFgUibgnkTErshGhtc8R9/yKehXkz8L8xse5OhsEyQiXMgTp1PkFIGndumEi+s5i7eBO+uFmRWsE0xxEIah6v6nLQS4OcOmKGn1idcNDirlJ7zgCNvGE8QkGiJrwmbgVvxFgjey0OxfC7gtkhXMfRB16E4YIYvobdUDWe+nkszQlWcXvmN56kLNZglk+JAYFaAR75e3oKnZzBlfugH53Y4PzN9Wm1XxrFuB9Q8Y6Lrp4D3O90UJXKLlOjpvw5rhbAlp1soFiwKS
 XQ6Thdxw
 6ENl3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.11.25 22:28, Luiz Capitulino wrote:
> igt_can_allocate_thp() uses has_transparente_hugepage() to check if
> PMD-sized pages are supported, use pgtable_has_pmd_leaves() instead.
> 
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>   drivers/gpu/drm/i915/gem/selftests/huge_pages.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
> index bd08605a1611..c76aafa36d2b 100644
> --- a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
> +++ b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
> @@ -1316,7 +1316,7 @@ typedef struct drm_i915_gem_object *
>   
>   static inline bool igt_can_allocate_thp(struct drm_i915_private *i915)
>   {
> -	return i915->mm.gemfs && has_transparent_hugepage();
> +	return i915->mm.gemfs && pgtable_has_pmd_leaves();

On second thought, is it problematic that we might be losing the 
CONFIG_TRANSPARENT_HUGEPAGE check? Should we check for that separately?

-- 
Cheers

David

