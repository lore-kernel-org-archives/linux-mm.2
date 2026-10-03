Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B245FCA5FEC
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 14:17:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80CB06B0092; Sat,  3 Oct 2026 10:17:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E4B16B0093; Sat,  3 Oct 2026 10:17:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D33F6B0095; Sat,  3 Oct 2026 10:17:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4FA286B0092
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 10:17:57 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C88A71A09B8
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 14:17:56 +0000 (UTC)
X-FDA: 85281518952.08.7F8BD7A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 01A17A0008
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 14:17:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CI2bAzS7;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791037075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n8AIQwl2OrZDgj7oT0ladgcZH3iXGu99gQT2AXUqZ54=;
	b=gIa/JF9NAON6neWDfIdeO17FwtiAGshLNk9GPazi3u1Ef0aSnVTaZ6lCKz5jGec5td5Qna
	/Dd4ICppp0MGhUkd75ToiReLumnw+rHmKzJO7QAarLt5xEvderj8bVO30MfOPKejw9OLEb
	bkh5Nx5mPU6UW6Fl+qOxLHRXBnRFux0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791037075;
	b=rcOHS5IPS+srFFnTU+QA5VT1UAWYd68dPsZ3ufmkw7uVS/ZoYD/nww+cMFwvK/TFJTpXhr
	2jF9zDm8MBn4imqi+3Tbe1eDja67HUxrsweixjNq0O7VmfQmL1celbKStYJkP1TO/2eXIQ
	7JdWgwz9ARhWxl10XvHPYH6/lThGYnc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CI2bAzS7;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2DAFC444F7;
	Sat,  3 Oct 2026 14:17:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800A31F0089B;
	Sat,  3 Oct 2026 14:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791037074;
	bh=n8AIQwl2OrZDgj7oT0ladgcZH3iXGu99gQT2AXUqZ54=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CI2bAzS7VGFvm/jMj/IP+6khSVm+FAzXr3svn6kl94i9lyrxO8UFNipR/leP3ec1h
	 zBldVpw5UekTF0+yEwuyKmALPgrduSQ0AZEmmrQ7p51JWZOJT1Re6DCejhkJ4t4VrS
	 XtiV6Fa1AJFyvhgduN7x3zLcqYqKTyS7AKVNePXA60nUiYAx/+g4iADsSSFR0Wfq16
	 sWDBEWP2lyoH9DLNt/pLlT1JlNxWS22+iA7mu7ZfUDTr6izhaQlg0J8eTEJQyAjG6a
	 YYAJqn1A3RH93XkdRXYgfbK48r66vot9LOqmpj0vkpNrOCu756QsBl8D8SyHTeTjrn
	 0lYrzWcP0Tejw==
Message-ID: <f6d1d42d-a234-4dba-9891-058b96d67ba6@kernel.org>
Date: Sat, 3 Oct 2026 16:17:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] MAINTAINERS: cover all hugetlb headers under
 HUGETLB SUBSYSTEM
To: Enze Li <lienze@kylinos.cn>, muchun.song@linux.dev, osalvador@suse.de,
 akpm@linux-foundation.org, sj@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, enze.li@gmx.com,
 Joe Perches <joe@perches.com>
References: <20261003060029.2152489-1-lienze@kylinos.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261003060029.2152489-1-lienze@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: hwaaqn7gmkubkzceybcnisnqpptpm88g
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 01A17A0008
X-HE-Tag: 1791037074-938445
X-HE-Meta: U2FsdGVkX19qcNdjXyIoX9e9PBG0YhDLPwyhcordXC6VHA9FglHG/NJCDvyGD2d/8/E0jDP7zqbDJH15jNwGhfV3KUfOYI2QaMPZ4dRHHcc5m2WiD9oL7aWcarIxiA+OK207yrED0xdc2Sln1Hnr/J+HFn/YpH2+q0s9dJ6goGwnJkMvzF/+SmyLQzsBorHq6mJXJVhCZ0UCY1rYdnRcm40t9bN0JSiPaPbXwmtlquNdeHq0z0NLmX9cm7PisRml0F4OQD1PDH7N566ISaFiWJrATh/lEvAJDmwx3dG0qir4PuSfLmo+OvvXpYk68iQ7D2Jm/Ck5YbOdMiRbnWG8qGBfK0DWLuFE08R2WhL6zEgFfHJLrU4Yf9K7UTSGkcO5PQkxM6keOF6FxMsZZk7IGzC/1KOEsDNmPMW6mQABK7vPXorjcJ366MXC6Ltf0+C1BnEn3h7l4K/X21NsjzzjUur1IsrMb+q3PAFYVF9/Cvi7M3iBP+X4DFHuAJ1NfkD78Y8ZmuaFkHHv/rD+GXRXJQteL8sGWtP9wqWLfLSqTJDeD6smRRQwy9MWzUz0DBXHU3KPsLrYItkBcpJbh0B6C8P9Vp19XXRe7P+KMsinjitNGtXC/uMaPvjfkaLl0q1eYYedkxAuHc9NpZtFl4CXhRwYz7VS3dtNntPrNveiIy2lI7pdNt+9qck1mNOTkSEB2fvVX7Uu2vdBQDpEL+sIX5FEO2Lfr7XYdcB9eoJkJHwb2R/XzEPTtWLIvdYsdIMwoRnapXG3ImLgficar/v1Mh2VPM5M+JgqmgiG7RqRA3d9QCotNs3x/2Q9G0CTY+7wDW/M0m/FP/46FFAyoNGkP/9YRme/+e8oJBDtHc9sOVnyLWxUK2RFqOxiBln8uV/CKGznFG7OgDgDr+rEKyx9eOdKG2NCmiDcOPKWeNm1XU81W4WZgfSfA1MAviZ+buwuK/8wokBrsaay66u2WWy
 PnVstsgq
 uwrAJSYyXeH7sVg8GUq2T4gyjC459C4Iluom4tGDIG5s3b5zYH3OhPoRqd8b7rqFyRaO9wIPXP9Q2egGiBJQW72wzhf/zhVNh0PHRUJF8PzhAQUukhz7pWOM2KioFxdrUVKq1uK1DE7c/sccEM66UJOBincT5FTlm6WgRrQ6x4YQQ9wh8qc5CWbi4QB19Q3rteeewUVu3c9sM7uR12GNBSy2stj+vNFl4GXIfFY1hWwIVAwd4l0kpvrzfVwsAr0IS4BMiBx2EPu8etBn5mFT/xDHMmXixdGDqaTyMPWko+dNCEcM2Ed5ViIp5RfWiUthPT2VIcYpL82Sz9zA0FZX0YnR9Wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/3/26 08:00, Enze Li wrote:
> The HUGETLB SUBSYSTEM F: entries list include/linux/hugetlb.h
> explicitly, but other hugetlb headers are not covered, so
> get_maintainer.pl does not attribute them to the hugetlb maintainers.
> 
> Enumerating headers by hand is also fragile: any header not listed (such
> as hugetlb_cgroup.h) falls outside the subsystem.  Joe Perches suggested
> using a glob F: entry, which covers all current and future hugetlb
> headers in one line and avoids the gap.
> 
> Suggested-by: Joe Perches <joe@perches.com>
> Signed-off-by: Enze Li <lienze@kylinos.cn>
> ---
> Changes in v2:
> - Adopt the glob pattern "F: include/linux/hugetlb*" as suggested by
>   Joe Perches.
> - Drop the Acked-by: tags from Muchun Song and David Hildenbrand, since
>   the patch content changed.
> 
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index fc95062c7e38..5c38da7090db 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12097,7 +12097,7 @@ F:	Documentation/admin-guide/mm/hugetlbpage.rst
>  F:	Documentation/mm/hugetlbfs_reserv.rst
>  F:	Documentation/mm/vmemmap_dedup.rst
>  F:	fs/hugetlbfs/
> -F:	include/linux/hugetlb.h
> +F:	include/linux/hugetlb*
>  F:	include/linux/vmemmap-optimization.h
>  F:	include/trace/events/hugetlbfs.h
>  F:	mm/hugetlb.c
> 
> base-commit: 763ad0211c7b587344f03bc4d1299810aeb736f4

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

