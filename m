Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56444CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 08:14:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F50E6B0096; Fri, 26 Jun 2026 04:14:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CD716B00A0; Fri, 26 Jun 2026 04:14:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F26B96B00A1; Fri, 26 Jun 2026 04:14:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C469D6B0096
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:14:03 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 373301A0375
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:14:03 +0000 (UTC)
X-FDA: 84921350766.21.9CFC155
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 737ACC0005
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:14:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WR+M1DMJ;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782461641;
	b=i9C3/3g7VyodFxiJrDFnSFH8dKdSWahHEurld9vsYTRrRaYlG3YuIrhQJJ/cqvcb3iDvQ6
	vpf7x9LFpKC8fIR/WRfLuDBvOatW52YRyrQhrRGwbrX26Du+LuQ7tLxyj9zvGtyze9SP1N
	v1xQsPfFVim8UNNmTh4peig+gGqziqc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782461641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JxHcRJ/uAa2Q++f+570ob3TPntbfaPHmCgZ1Tbd71eM=;
	b=FkH6dAzcNnA8QXg5qBgvM69WD5lw6Lk3ey4wgGIjs37/QXV54crqRF1ewMSsD29ezysSLF
	yjiF6W4GQHAb7FDRVcmkhbyMKbygDbbUJioXVu6ZzSlVy3nbFwMxd4z5yugR4ol2rRsH0E
	2CEeUsoXzxZCBqLk65gB7sCIF0vWRwQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WR+M1DMJ;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DDE6660098;
	Fri, 26 Jun 2026 08:14:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B9F1F000E9;
	Fri, 26 Jun 2026 08:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782461640;
	bh=JxHcRJ/uAa2Q++f+570ob3TPntbfaPHmCgZ1Tbd71eM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WR+M1DMJgMM4t2+ge79esnF02O9RFDzaN6Hg8/fc7y546zi/NwZiYes6VYI3/aBQZ
	 6+Cw59NKIvzfa1B4ozxZkKbjLc7j6HSSYkNPdvMHm/WwrLhlD5u9pyfmcL0iADABaB
	 0k7M86I1isVsPIC/MaNzA3UC2A+FUq4nADUmz7WVOj0d7V9Yq8Xvfmajw9/fdd05cm
	 xlI/KfbpzFD5DqWZ+Yj7UZzacj+kd6zs8xhQtc8COgTHV2DdXtZYq8rB7rSxanFLXF
	 rOtRMkHz3+SHSsoE129fOsCYrbYAdXchLobLPk4zHJuj+nXEJL1GhbDfXtv74uhd5A
	 pheE1SPsjoetw==
Message-ID: <a63b7138-617f-46de-96f9-e56528aee3aa@kernel.org>
Date: Fri, 26 Jun 2026 10:13:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] fs/proc: fix KPF_KSM reported for all anonymous pages
To: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
 ziy@nvidia.com, luizcap@redhat.com, willy@infradead.org,
 linmiaohe@huawei.com, svetly.todorov@memverge.com, xu.xin16@zte.com.cn,
 chengming.zhou@linux.dev, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Cc: wangkefeng.wang@huawei.com, sunnanyong@huawei.com
References: <20260626013252.2846774-1-tujinjiang@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260626013252.2846774-1-tujinjiang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: u55uknrb75x3uguf8h1q11d9dg6hnoho
X-Rspamd-Queue-Id: 737ACC0005
X-Rspamd-Server: rspam06
X-HE-Tag: 1782461641-117067
X-HE-Meta: U2FsdGVkX19/CxUwsAyYeoTdhjmooxOefEpvJODvhAckiSER0OgjYajKFCrl8r7KIZcVfTnpi1XeewxkABkI1LFUHXMvrNgi8GMA50gLg3F7IwFYhNW/1ax/dUMdbw0ZIzwmJUQfIyfX04ljesMwyzSG0nzAgDp7L/uBK9DWYBkC10XHqAuekpk/H+FYrjRIV1ajYVEMtVWWZIsUUpzeeMi0GTAoHTAd1EzoYmxN6E93X536uwy0emqz//FbRRZHjEQo0Om77L4mf0RmKIMw3aTPVXQxUZiMUVWvrW+Q/tKm0QxR1Ca45PR6rxbWILE6DwvCo5blUUfxmZ9nVsUZm/l8X7uaCRDcxvb2aQYQ6OAIP0T3cqJRzRPLP0zo7nO1mzbBwx2SJoS7ePAyMV42iURhKU7O+0IVemvturmdOGiSjz/q8wO0vCZVn35JoUODH48h0P7FDkPvxZjTJo72FnHiHzUmZ4EndX88mqEaQAcNtltdCaoIshYh9hW6X1CyudH3a8mgqPd+Jy6v1kdm920aQ4FRo8kMYCi+rD8Hl6oEGI5aLmixivIKL6MVRFsuomJnkD0TmFVL9qKfrqviRmRMV/76B6uG7IpNTsX90H1ab4VMMjOSB5wNXYzO6M0NfSVTVrZd2wH55r7wUt2VTA7/YsIEPtXO3se8rTTOTxGrByYVid7gw/8t9IMqhmCF8gceHWudw0cJODBiMpNrl6qhyt8Rhit36LNqQPTpkxmHqLjYElHYm7J27cLJ+gVLLVai0EVW3dzNidtQzL9/5EbmThRSfHj6moDzJ0lJYJCozCBu5pdP1Q0dTSMUqo93M61fJrTwI0Il60DeDSo7NqckoWKcQT7ubrCLlvmG6XK1pS87magVc9uHx9Hg1Dgz5AH2dyfQIbvPG3vMwKUE91Y/k7BC+uyjgsC368dFurXPnGc0pyRf6oGFBFeHxzBbeg6fi2/yHgdzrRVKqXy
 Edbaoips
 TFKDlLUgJzqpxCzqbAv0cJmlKTRiy69lxlpYBXX6LkTWE4wRvmApuWDL3wnfuxnuMA7aqdD+ZAU2IOJTMelxIoXrz7SlNjxgPP4DjlGuvZjhyis1WjIE2BIocAucT5eyZTmeE1NjvMYDDs4ud0Y/EDp1gjcjiXpjZ4+JOoYE6nj1a1LFrYphso0cs3GlH3kN9glWMC69zFywkr7QCd+rRIb8o3qowtVpECMqYMCUyH+RAfoU627TONEHRKy4VybdxF3PPr0lZYiMVm22lrfOfrvhipGyBLqjYBfW7LwGK/w7PO+txecsG5L9BGD+s8i7282htenZA0dFfph/apYHaGXgOswhAEapxvxAk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/26/26 03:32, Jinjiang Tu wrote:
> Reading /proc/kpageflags for any anonymous page returns KPF_KSM set, even
> when KSM is not in use. As a result, tools misclassify all anonymous pages
> as KSM merged.
> 
> In stable_page_flags(), if the page is anonymous, then use (mapping &
> FOLIO_MAPPING_KSM) check to identify if the anonymous page is KSM page.
> However, FOLIO_MAPPING_KSM is FOLIO_MAPPING_ANON | FOLIO_MAPPING_ANON_KSM,
> (mapping & FOLIO_MAPPING_KSM) check returns true for all nonymous pages.
> 
> To fix it, use FOLIO_MAPPING_ANON_KSM instead.
> 
> Fixes: dee3d0bef2b0 ("proc: rewrite stable_page_flags()")
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> ---

With spelling fix

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

And I'd appreciate if someone could look into cleaning up the code to switch
back to folio helpers now that we have folio+page snapshots.

-- 
Cheers,

David

