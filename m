Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B860CCA465
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 19:01:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E42B6B0096; Thu, 15 Oct 2026 15:01:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 794576B0098; Thu, 15 Oct 2026 15:01:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 685096B0099; Thu, 15 Oct 2026 15:01:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 459556B0096
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:01:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 899D0A4F63
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 19:01:12 +0000 (UTC)
X-FDA: 85325778384.07.A8C2FA4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id AAF511C000B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 19:01:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YCmCeyWQ;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792090870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O6YGICvRqo5ZX7Fs34PHB2pxcAwJ+U8wwEjavmBhres=;
	b=PTxhqh3CU3zoeSMvx0UIwAe31simURt3kB7x+/xGWxCE7BHMDTyRRuie91eMt2/CKwy/pY
	/o9UVBQDAiu1JLYxueNJOflnOJJic0vy45+gTdRlZdJPIVmi1k1XUcRo50BXjxdA3tjvvk
	w0K2pjbLl+VhsLDZGXgHX1rZpDVTZYo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YCmCeyWQ;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792090870;
	b=UGsXEbGQoD0bvGWG+jCqGcXwaSmHZg3o4fuEX/I0q4ti5A6GFidnGKmsu3ORCOMm+YANbq
	Q7jT8eGy2WsHn4a3cf2jWLWOKX4Rq0HySkyVC4kz7SJDASxJkRrLWKiXz1QvuSvDbBtnMa
	6qoC98XZJVTvVfycbvI2IksPurrIE+Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A392043FF1;
	Thu, 15 Oct 2026 19:01:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F221F000C5;
	Thu, 15 Oct 2026 19:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792090869;
	bh=O6YGICvRqo5ZX7Fs34PHB2pxcAwJ+U8wwEjavmBhres=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YCmCeyWQ8yReS/GaK13Kzq1NgNhsv4MPuXFY8WAV+sAcrXekzPCqKU28EGPoZyzun
	 1IWAp52aBdG6ux/e/XCbcpDcCc4jGgl39/JLF0+pkGmsQARBWiuyHOAA3LD1XJiygc
	 78DH1wCbimpiIOMtQGS3CA/v20HKLJAH79Q1vC7lhezfZYyEQhynFrLaLVxJR9Kosl
	 h4y0ulhQzJniIAijReW4Q82YStoBU3wELT7AEr0oFujp4WguhHDWK/adUd9Ojskzfe
	 vJbEBYn76QydAwsG9BL2UEeCeqC0OyKl2W6l8uNJ8Y1480Kf6/qre5bUvuvyxRFhlP
	 nMb4AnhKbihVg==
Message-ID: <f7f0dd17-d7ec-4829-998b-5e8de564fc38@kernel.org>
Date: Thu, 15 Oct 2026 21:01:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: exclude DAMON docs from MEMORY MANAGEMENT -
 MISC
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, SJ Park <sj@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>, damon@lists.linux.dev,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261015-maint-mm-core-x-doc-damon-v1-1-226decb5cd0d@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261015-maint-mm-core-x-doc-damon-v1-1-226decb5cd0d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AAF511C000B
X-Rspam-User: 
X-Stat-Signature: q4mm7e9mxp9r9zy6on735epi863y9dpf
X-HE-Tag: 1792090870-68273
X-HE-Meta: U2FsdGVkX1/HIqdNkdcWH24/4kBUaWZYN/+aD4bsvL2ARA8wbD7OEpVmzmnwWjaLp4kRz2aa4t+1aPlyskFeUhhnxoBSW3jKauTdqW/KE2Fn0TjcuRflOaX+pYTHOr9Xa4gNyzDpyEQIPwVkmkOwLOTy5f+Y+XuVnj10SSdHCr+JDRpgiOzjCnQjBO1lChx4sJJzP3V3TKm0za52FjejNFWfM84Xx94yyqhXH04u0nXK675pCQUlcAUeRHedzJr90DqeaMVrsagUDELtY2VpLirzxa7S104wWsa/mRf9YEMB7OS/GCo3eHxDGZoIxIsbEpt2pXyDlS+WAr+t8N4tLMP4Xp9D/xnwzODwvSuFChuAOevE5VHrP3Pa29B8rEAVl6EaKowiUjBFH3qSQ8+v9Krk28+k0ZPm3e52BVvqk0DOYoWMHwfQSuqeD6QLdiaHxwB6bh6ynh4epE/NIwH8OKvGSJVVqqcJHdNG8bDJL7aGTIvYKqAmwKE7nv5WzfVJrxXob4sBWPaCUUThyk8RjgFx3kJzYMwzqPUMXVWTOzvh2EQW08R9YxRSV+TpHDh8G+2aRfgudil2zJxZtKHix4yfl+nBP4aLwfk+31bSw0RERrEm/RK+/bgtC01O7s1PZjIbkUuuwsQZoA2ghOg+eh88lDZeNtDXjo9uQqprws5coHsbO3PGR5toj4DZ/4cEkN55D2BLR2Ha8HoGNTnnbGtv6V3Zra2BmctlICUg+8QOCmDD3LVplM1mzF0tw3qAkN6Hh8P4PyIWkrrIW31zoV1je7x78bfJgpVImJLwxadyWz17k5Si8XHtDRF/wx0EAp87rP4t9pFQxORXDofC4TFZWOLQaghbROZADR+aFAfDGu18co8bGKREglohwqxaiEujJGKtf3MiTPY1pShNuPZDbPih8jSBvzlJlhwvB2a/J+fMbWp7VJTsXTeh+1ihEC+PbO5keyLPHxDSVh7
 K7U8rMob
 VudoUOin3vz1+tsMfxJkAkituwDDl+oZwsetV63db43P4mEGDfcm/nYJb7z3NNg7xBtHvcBUwoiheuy96/A3lsDOjw5p7jl+nUa7/KUuNcQeXHPrq2Z0U7cLWr0RaAWo44W/pSrDfKG6GEb3Oq1selNcTbSHg//q3vKgQTn0qJ7hWQW7KH9gUxUmer5u7X/S79+QN4qfnKdgsC2/isPYAAnVbLlJ/2duE2tU3eGJOaHkhNtiTc+dYrVJN/ARS/7oQdBOEPe4woc4s/pvUzycWFvEIcyKcKNdoPSRY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/15/26 18:31, Vlastimil Babka (SUSE) wrote:
> MEMORY MANAGEMENT - MISC is a list of misc mm sources and also acts as
> catch-all for the mm Documentation subdirectories. Documentation for
> DAMON is well maintained within its own subsystem and also actively
> updated, so there's no need to Cc all MISC maintainers for them as well.
> Thus add exclusion entries for them.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
> I'd love to have the time to check the DAMON documentation changes, but
> it's simply not happening, so this will save some mail traffic for me,
> if others agree.

Ah, that's why I was getting CCed on them :)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

