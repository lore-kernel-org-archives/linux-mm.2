Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3526CCA471
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 07:14:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D50A58E0011; Mon,  6 Oct 2025 03:13:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D01778E0002; Mon,  6 Oct 2025 03:13:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C17138E0011; Mon,  6 Oct 2025 03:13:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A9A3E8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 03:13:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 44F6785F2A
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 07:13:59 +0000 (UTC)
X-FDA: 83966824998.26.6363C2F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0895740008
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 07:13:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759734837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dM6AireCWpmghegOMgxxS3xde3Bz/Q//gg5p1kh0jdk=;
	b=s8HOtQ1WgzdfTZBHSldgs777Ed3hBA2WOToojlhYDwfjYAf6jHRW3NcDpMQDe+iBNt8ZiK
	TJKc6z/CD0hVZHeI///TmPPwj4Lcmt/ckBThfLw2E4HmbyLI67j0AxcZg3YSDsp3oqzdWc
	PEpjxCeWjINWghZkg55VvamDgjPK/5E=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759734837; a=rsa-sha256;
	cv=none;
	b=WEQ0plXfCWrohCc+Ynf7liO99dn6IFYHOoyJuZNgxRrfRl+u6TwJr2ISd81nn/hp06ePhI
	J7rbCa9L/d+XCNu8sje8Kkv2oVJTllQ+Be1YtJzuBTC1C+Qk8RGkVtq3wIQm81UYtUA997
	tDIAGSmrpjLcXDh/T8oiijiL3IxjDUw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E6BD41515;
	Mon,  6 Oct 2025 00:13:47 -0700 (PDT)
Received: from [10.163.66.9] (unknown [10.163.66.9])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A14F63F66E;
	Mon,  6 Oct 2025 00:13:53 -0700 (PDT)
Message-ID: <0fe62944-34e5-4ef6-adfc-bbaf695e41e0@arm.com>
Date: Mon, 6 Oct 2025 12:43:49 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/dirty: Replace READ_ONCE() with pudp_get()
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
References: <20251006055214.1845342-1-anshuman.khandual@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251006055214.1845342-1-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ckswmmai95pshugr1xki5eeu6913mkoq
X-Rspam-User: 
X-Rspamd-Queue-Id: 0895740008
X-Rspamd-Server: rspam04
X-HE-Tag: 1759734836-531209
X-HE-Meta: U2FsdGVkX18jgInJ219QD7QZ1CkR8mt7tbve+7CZjOweFzFk26TKvE8SyEDFHk8wThUvPSq0PPIy6Q++LS924kX4aN4cKm6Aedn6W/9g8j8g7NN4IEGnZuRJEXDlK+uFE3b1CGmknDhamL8Bci/DMMeiDilQJsiy0THXodnZuQT+cQwDW9i/F5o/9sWDW043GP5Wc/IG3+35/7PYdih/DqhgOL+qKkTGBP14jhyNcZ2tpY4IF6wFYwGYCSpHOGOl4eknqdxteJCynY0KzuvxzXYHracF9jQ096sTzWIsQLLhas5Ppn5L+qbpN0qr46cgIehIXngEAcELaVMxt1yQ/25A3ZDcUe7BDiIn07/11643HI/NlF13Sp4OmhjR3oX0gdtYYOeJ/h+4gjzZAdxpAFssyOdMhd696li9+6thNdnc33pgrJKfZBOwnWNMBgLZDoEmxukfqRacif4SFQBeTNnaiWJ2NvH2yP80qG19ycohrLYRQBEQ88Aa6kjvk5/rrCF6oMTZHWmLgMbeVZTzmZtbUiRnUNuugf8zFPCen+fzihikDy1RKXFQJc3wS4uRAJqLWmx1cDnKYqfDPRcx6MjBop4woWUEohPeKnkxUeCTqJizzOy/1D+VZ213H1IZ5TnPA0wubNHWPjc4cefTYPeDI5DIclayIwZPSIsruu24bwNVOXOEw7UkdLEQIXRQzOBZHfwQCC1UB0am3wtZvzbAhydLp6eueTiYTg3O2L7vKorVonutksUBBR5XWUvpZMxpXO15heBu6Fnvx2YB3Ll1zlu+uy20rzlP8hj4bQJDgXDUIA5ghZywQVYITPeOjo1fjRGJhqfRqG0qCa9NVwh2UcbtP+J5FiKoL/+AapMZqXYq1al4UdpzPos0uS/h3Ld9jggMgBt3Pbu4GFeE/T/v0phPLjNJPBqXsB/XDng0HfkTT+IsYDTRThn5UlYtznl8R425fQshC4uOxs+
 i5gpn9c8
 Zy/IyZNj1Xl0UybBZIVAnQ4lYxXh3+mxI186YhqLTt7DgDS/xigJxHt1/G9kOSvJEVR3iX/0KDih0b8TD3J2MWO+footUwhh90KusVUfY55zUc2s32KoYMIHyOuXlgtWxHi0zID7Nidjre5rYFI69IDrtUMEMomnjdoRh5yFjemoWgN/WNK728+jTKJ/PG+cpjHkJfH5NrfuWdlSllyNt4IO1/fsVXffCMHbvvGpkKdLViuAIVRW2Mgy5z8x4C5uJInfpl/Dyz5m2Lfor55onyJKkggNVHLZAMc7YacqauIm0DhuWFWRplUbSnp0irOp8Yw6nr94kK5S73zoNn/cO7RjZinSe+aBuk9fZ2YRsMzrTdBbSYgeqsNUaHxNkIW1+WDiPIlDclW3tvCko+IZiJyUPWAxGDzEvMm5cL56HiRC0SWD+Q511NBUMHApB6p7uYIU7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 06/10/25 11:22 am, Anshuman Khandual wrote:
> Replace READ_ONCE() with a standard page table accessor i.e pudp_get() that
> anyways defaults into READ_ONCE() in cases where platform does not override
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>   

Reviewed-by: Dev Jain <dev.jain@arm.com>


