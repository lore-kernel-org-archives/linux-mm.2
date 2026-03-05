Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F940F30955
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 12:41:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B73936B0088; Thu,  5 Mar 2026 07:41:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B20CD6B008A; Thu,  5 Mar 2026 07:41:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2D1D6B008C; Thu,  5 Mar 2026 07:41:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8FFA96B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 07:41:46 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3AFB1160133
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 12:41:46 +0000 (UTC)
X-FDA: 84511971012.01.BA77018
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 70CD8100003
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 12:41:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BBtTsoRZ;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772714504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r6kTVyaqj0G1O6nV4vmYiyM60P/DuKY289QlCUAIA4Q=;
	b=wVRapblXYuWzzd0Lp2RI5fz0H7BRzQ80noXi1WDl3SP8A3u+0/4+gOo37kMlA+4kEncBAd
	VUKIijt8ldueoaTaYAypoiNDJmmklOTthOd22AUOi9PKpDxYl8nv5qoxRHZFSULfZ64G3i
	RjvGJr6k5DH/ui+vTjE4k0VxDst1xxg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772714504; a=rsa-sha256;
	cv=none;
	b=KbixGm+zgXqTfplkTz9V4KReWTlBhhrDh71GOIkao/RdnfQFdhbBDy8SJG16aILcAwUk1V
	26x/GSIWwpK2x79Tdkz1fJxO3/Kp0CVHp2/pdiR28hqpt47XvvQ1j3Pk2GlC4ZBGDRXcSu
	MjxseVAag/H8Az2ZpJVhw/F1E8opCpc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BBtTsoRZ;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CC5CC43C65;
	Thu,  5 Mar 2026 12:41:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E010C116C6;
	Thu,  5 Mar 2026 12:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772714502;
	bh=GSpJjDvuqvZZWtZxS0tUNmCUsD/z6lCfyZgI5ChtXhA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BBtTsoRZI1AAa5AhxDFLr6PHb6nNNCx2tgnSGXlFaEbr5z6NXjUVOL0BoVVAzaVwj
	 HXtj5IPQpiNaVH3E7pCfEDNJVbO2lLqPCQv4R2X/U5zORVGFXOYKSYPOf3D9OQ/KTv
	 ufBN0SLx6hP0VP29P8obMF0/amalcG6a+qDmRSEENU6p1O6CsBxX1GiomALgiBkgme
	 MlcsMZILGWpC9c5Eqf2MjyXAiC5Pd0U+MB16izfXkWNk0W/Tk2PMy/lT/ABue7Xd7k
	 wuxou9PUvzQABvILzfdbL5aXwXk27bByo6UOdCE3ETHCXXCXk3C+k4m/Hdu882EFFv
	 CL41ohw9G5wjA==
Message-ID: <ae48168f-c88c-4f74-8cf6-ab90f6c97c68@kernel.org>
Date: Thu, 5 Mar 2026 13:41:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm: thp: reduce unnecessary start_stop_khugepaged()
 calls
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Kiryl Shutsemau <kas@kernel.org>
Cc: Breno Leitao <leitao@debian.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, usamaarif642@gmail.com, kernel-team@meta.com
References: <20260304-thp_logs-v1-0-59038218a253@debian.org>
 <aagSrIwiFM7GaL1m@thinkstation>
 <e46c8bd6-9f6b-4985-bec5-fef6c8f33dfe@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <e46c8bd6-9f6b-4985-bec5-fef6c8f33dfe@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: b4qjocmx8w3ptbz9woett9dnxpjdxrgc
X-Rspamd-Queue-Id: 70CD8100003
X-Rspamd-Server: rspam03
X-HE-Tag: 1772714504-95702
X-HE-Meta: U2FsdGVkX1+hHNNJ+Yu9rVeHN9b+oiKBIM8YBl/AN9G18ABzagpkrDdAWLSIiivHRW0uHZKQl4DHRSCwTB3LVJkxmJ9AQvp+N2GtyikY1Q3yJTAPHfnEsP4dv98OJJVufhUUxlsTOwzxQ9aiehF01DM0gK0GqEk8T0d8doYIm2GhCxXuuGysZrLusmZWHaNFrckYx/MLpdZ5OE/rcZG99UaqJG8HFI1es5DwEUqzd19G+CS7nbJ8LDTzWMGS/TYmz0vse3Otfgx2R7sEwkbcLjgBoMWbt6HPeX5FQCZ4FTqCpozyhJcdRr1Xn+yUHXsRVliKyVIUZQ8KoZsf1ryoM8zyEib6hGMtI9u9oWmVGoG53SPGRr8M0Ew1tgkZo1koqQz7E8Z5sp0fTz/3R07fO/1yEyBUC0SNCRj7MZuwVWztyzhRaQU3pWBFv238crqk/FHMm8+AQ/oz2IuQsOK9D2BGA9XppXnPJau0yoOD0pkBwenaGpTEcncXME5794O4RvXgFXtq3DHSXOiWoXJXuxT+5NcgoT9Y1T7X+F8PsTnvsvMIDyxx44j3GTjzcA0h/B4hfTmDQ8Vbekn1KBTcLZ9v9p1BmBtD7KkHV2CcI4mcMM9H2b7+MWAkF7nQvDd55+SuVyZ0JaTBNSeCwiTJVvElnVt13TWMcTxwHbZpyi+wpLIW9P0WtNvkxqIBW7UPwE2wqRMDRdln+/tRlUZg7/dhBV49ymcv+Dwrt3r76k8VQOv/8Pudc97jiEELDRzIB80eYEK0h5KJJrZh6sjPJtebKT6oT/8oMWaWMGsliGRQk8t9s09NmTF6U+nkxoxADCoyt0bh7b50YfLL5Y+23UEGtyOmDLrjv+VHKayGVt6DpFWWheSasetlZD754ffTNoaWWUSse5SYSVUceAmMqofykwbuwL8Me3lwj6oArgP4UG81SIURj9itnbDZQE7OL8MAtRcrhRdSlRvDcli
 eiwbUG4S
 BB7OqwJWnPJvcghg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>> +
>> +	/* Check if anything has to be done */
>> +	if (hugepage_pmd_enabled() == !!khugepaged_thread)
> 
> This is horrible, better to break out the latter expression as a small static
> function like:
> 
> static bool is_khugepaged_thread_running(void)
> {
> 	if (khugepaged_thread)
> 		return true;
> 	return false;

return khugepaged_thread;

should do the trick, given taht the return type of the function is a bool :)

> }

-- 
Cheers,

David

