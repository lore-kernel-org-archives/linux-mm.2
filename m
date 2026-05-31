Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11430CD6E56
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 19:31:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 363A16B0177; Sun, 31 May 2026 15:31:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33A726B0179; Sun, 31 May 2026 15:31:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 251106B017A; Sun, 31 May 2026 15:31:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1732F6B0177
	for <linux-mm@kvack.org>; Sun, 31 May 2026 15:31:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AAFBC1404E1
	for <linux-mm@kvack.org>; Sun, 31 May 2026 19:31:41 +0000 (UTC)
X-FDA: 84828709602.06.71A90BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id D059EA0006
	for <linux-mm@kvack.org>; Sun, 31 May 2026 19:31:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YsBb5rGZ;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780255900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eblzQlHm4oOugOyF3LKX6wnd3wUruGdjyINpmbI8UYw=;
	b=4s+zhlm4lnH+AzSyBL+u+5EAbEcuPVU/Fuh7tbDBex93LpHMNxsgE4CsLzRR3RfChSGbZc
	SHsfh+HhNURfA5SF6KiqgFOFVoOn5T3uTv7ltOvC9G8W7PQiKJZZWChFXlIJQSABo10l9E
	Y7D7Eli2n7IClKtJAoPIAHF8fZIQakY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YsBb5rGZ;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780255900; a=rsa-sha256;
	cv=none;
	b=1ZKpaMWP+RQ+OickavGoIkX1aA+jeTRZ3L4+WqAd4Vtg/AZ3//FOYJIsjHolH46ILkeFQe
	OigN4ZakIuOd2vtY9/o0hmmxkBSx+55Vknl553Vdwk6WloxKck6RL8loEpdLy+Jt6sShKL
	MpbDidO8y/UquqzL0oBlxnHOUk/YOu8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EE2AC40DA6;
	Sun, 31 May 2026 19:31:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A54B1F00893;
	Sun, 31 May 2026 19:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780255898;
	bh=eblzQlHm4oOugOyF3LKX6wnd3wUruGdjyINpmbI8UYw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YsBb5rGZSEEW1ukZETMd0KNSrFDySISTPqhEu/WpPUTH6ObggVr7nxGNd0Nc2ZSrG
	 sojZNqFRtnshP9pqFaUjhmhaLHLmUmAZc7um/gDHgQtB9KuxD9hrJHRJOPBNqDsQ6K
	 usCzE3lEjZVz4rMQeSCYzv7pwQmGx0WRPTaSAPWL7KCF4KL2vucHyzygsoeTAH4Uds
	 cjO1aUeX1BC2aUs1uM2JZmo0+ysKbC8rbh89ly2yeTyjNSwlvT7fNLz4YAXvX5orc8
	 0PR9VVQedT041AV4MeAY2wplG66KWfbj0xXNAXYqqYZjRG/ZmCEPzcdPg8nJ/b0EZc
	 ZE+4g9hNkZrKQ==
Message-ID: <122fe9c1-c953-439b-96ae-8d9a1a2e901f@kernel.org>
Date: Sun, 31 May 2026 21:31:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: add vm.rst to memory management core
To: Brian Masney <bmasney@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260528-mm-vm-rst-maintainers-file-v1-1-306631c0a610@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260528-mm-vm-rst-maintainers-file-v1-1-306631c0a610@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D059EA0006
X-Stat-Signature: h5qb6tsdtt6m7zx7nmomzmqdedrsfyab
X-HE-Tag: 1780255899-389617
X-HE-Meta: U2FsdGVkX1+1jgU8OH3S9r91SaykyN7iNUSEsD9/3xAYAUQo+94ZPBuNojmbEMxZlgOIfnvQ+QdjjBqbRxMSFzbuzXEK2/7Goou1q+DnAjRKHPfAcawmUHQZrzO119xdRBENqFBtwMRxXkukn/nIDGMbAFy1J7CrqaOhWA7Nd1uZJQQ+a0z4QTSf/TW08Tfc7SDN6D+QhX5F5CMcjhNah1QX11Ol556QAPpLWg4Ex+JTcb1QfbATMvQ0bOVdUZyzXS0kU624VQKCVscHaOCOPgQz9QCAqjRhv74S7o0gXW8IGLP2GXN08x0mm5vk9YHFpQ7WkyuwtkGc7RxS+MVipXeYVLG/jttcakOMgnhYzcYb7kUk4QWKIGxb+P3FsILdnPPV3kT+f+7WW+0RFhFmV8Vhp3rfEOk7rkWUGT1YA2qvCuCX8WsEJYRQ4YALXHVWlZX3KvixyCI0m4GZPILdbG3Pk05jbl0sE8VFOXNtkr/SmjpDR65A7/l+mLQR/CFKeyw8gG+C4fr1gIUgM2mHUl2bcy13sqw/YfB6s7z03V9lnloz2GhjVQMYEYDiVcvaxinmtgumvlmrGg1DYYUd+tKEIPZ/9jvv3NAF0hjQ4AByX/2PBfEXQMOe/fhOX5XjUOZkotnNW5kGjCNxkmKuAL09Mb/F09JDcPzidA1YcTVViDhIS68dlAfQiXkucGI8w5cyoUpO7kss2S2plrODgqbmRYDmZgs4Nh/yrKGDwkr4RiaX0yLxov/R2Z0aFq34hcnM4qFkALkK8fJWY1t78joUxp0OcvHCG1zL+6yhBwf0+8/4uiYL+ZPe4dGnLi2AIOYRMAw562oe/Gk8uHygI9DneaI3UF9S1U/FgjmB/FOEVMy25q5dbmajAiPnGkyb3uLM3pPKEtn0iR0JiHfIU8G68xl9VgHDu+arIp4xL6cLjsC/hK0zRTIQPhtavNkWTmoRxXQkdNhYAxtJtWu
 zdwCZ5wO
 6yC+Jy14ZNAOgdcxtEQrnaVZ7HYdPHD1FxJw+uBYsd/4jBYkdFZtiAVXPF6J0Iv6HOg8iUmXBN02a/wtQ0VDHY8IA+7ry9fdfiRf5ArVIy2sdSYOlBG/1vFksoY0q1fWuFVeFK+mdrvOV1pwcrNfqONWh3Q6R3ix0o87U8qN8Dk9bvrlN6O939WVzp8CQ0ZiOmq51gOAm7TyKECiuafR3ZhdLk6Oqew5OuoNvONj6QarCRwLAPQXXCdY/4LLMzcSOtCqX60vRSCQTaQJLLemAgosLlKzjr3TYrDS3sVvaIBNhf3wBMt5fxeBDWWuT3Aki8rbultXVVk6fApb/d7Mb0PX5fEPc6wUwvO9Ir1zqyb6SxlZ8Muqq/F5E/Ui4HgXP0HFaqiWRgKDBeJXDq33i0u1acojm0BPB14kkN5Mh4ymPalg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/28/26 15:56, Brian Masney wrote:
> The vm.rst file is currently not listed in the MAINTAINERS file, so
> let's go ahead and add to the MM core subsystem so that the maintainers
> are CCed when changes to the documentation are proposed.
> 
> Signed-off-by: Brian Masney <bmasney@redhat.com>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c99f0650b334..d8dcc4f25ccf 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16923,6 +16923,7 @@ L:	linux-mm@kvack.org
>  S:	Maintained
>  W:	http://www.linux-mm.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> +F:	Documentation/admin-guide/sysctl/vm.rst
>  F:	include/linux/folio_batch.h
>  F:	include/linux/gfp.h
>  F:	include/linux/gfp_types.h

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

