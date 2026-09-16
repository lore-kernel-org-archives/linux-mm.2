Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D720C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 06:11:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 105C66B0088; Wed, 16 Sep 2026 02:11:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B8676B008C; Wed, 16 Sep 2026 02:11:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE76D6B0092; Wed, 16 Sep 2026 02:11:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C32B26B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:11:18 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AC2AD12061C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:11:17 +0000 (UTC)
X-FDA: 85218602994.01.79D011F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id E60D64000A
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:11:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YztrGueW;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789539075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UGrcU1xSal3PMw302kzTs+2eIWDoDzFKnNibjdAgJcE=;
	b=EvRPhnWp/JuAR+5vWeN2vbYYqot6Pd99nFUtdcmd1oEhrmm8YkkoRAZy7JeKswX9fM8Eka
	AXubZ2d2UUE9+dOgED83mXBcf2HCyTxm3lbCE1hqrG/TJJb2xDvTd7VTmCSGJGpYleElqE
	sLx5VyknUE+ki+KNA2Zu+2LZPvOaGyE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YztrGueW;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789539076;
	b=h9vOib8Bxm+XEU0xb4KI2GvWcFrvnoo50Dg4HCrWhMpMJlqUe3ZfkzpZn1hLkKKPpzrNru
	suwezXtiA86Fq1F3X8+7ZPDSvwA1pjdooRkWBkm20q0Xii5pQ7NphJed7EL+F2iCp1Yw2F
	et7MYH5NghB8ZdQujzmEaYKVE34DKLs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4BB7060214;
	Wed, 16 Sep 2026 06:11:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128601F000FF;
	Wed, 16 Sep 2026 06:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789539075;
	bh=UGrcU1xSal3PMw302kzTs+2eIWDoDzFKnNibjdAgJcE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YztrGueW7S75vJt5/VwfFwARA7pYJ7v3ID5aNQncwiRJg/UbDd65z1f7dKsFv2oRa
	 nTV2enQ4x/rn4yQoPDzHhrKdlgJLS4Esp/fVznHhQaPJv0/2TRTpZkm8PJ6N8FKgXk
	 SbDPpalSmpZLD7Yi6ssaCXn65z6NeBhjtXKMH28bOYZz8i+BeyMfpvGeUhwZME07L7
	 JtyhyEjkd9f/ME9bNLXAMZuAtf9ow1vYXwZK+04Qf/kWqMOBoAbdsQ0aT7ZeSkShNb
	 lR6FXQuL7K+GX3QkNzD49Sd4U+Lo81nZ8ki2/0LDDzjJtoqwwhmSNC22W82nanyBGm
	 Fv4HsxuYHyxdg==
Message-ID: <f784fec5-7261-4ebe-803e-eb26141a0fdc@kernel.org>
Date: Wed, 16 Sep 2026 08:11:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/huge_memory: fix pgtable withdrawal for huge zero
 PMDs
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev, kas@kernel.org,
 ljs@kernel.org, surenb@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <83a1287b-8589-4408-96f4-4f78dfca1bc9@kernel.org>
 <20260916044142.95044-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260916044142.95044-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: dos9ps5pesjr7sscb74zwi3zm3spwu56
X-Rspamd-Queue-Id: E60D64000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1789539075-784026
X-HE-Meta: U2FsdGVkX1+Z1AFd8zuyD2bef7pNbdM4QHcdD0SzhB0SX/j0ONsYhgRH0cLPdxdG0w7YHH7AUcCm/ZY5ZIrWgR2oU2bMM1DXcXRx6oK7h0FyKKZLf7kENmop7HJWpVqMoV9rHTHlJuQRyEiDLjS66ICzm0telGtono7rIhu99enqu4j9qgujgM/KCSnDO8E1G+s3dAnvHySoul0TiKewluhra9BTd52646MireJBpCVblLod3+2cCqhGOiDpPN5agrE11BHhFWJ9mbKh+TcZbMF4BHWLcXi9AtbY0mLFNpZVi+Ki2eiJlWE7TjNUtmR2n2XGJqwUgJPm4NlosPrkCXN47GJq7MojrdT8BXxwsQOSJoFgogJ+ama5stRG5jb+ZgmoKf4VlO3DsS199F2rRlamqQjgEOvaZ7Mb26wY1cCg4I1rajVJsdqEMw6oE7gmnTXuW/1UIwSb3I+O4nDE+TcGmWa4cL9FKRKHlVmm6XTEzTyKiSxwqdSlbzOJH17GU3YyqpKme2BOOhdEdZOw/D4xo5jruMKubMERYQrpzncAITfs8Y2Bsf6qnB9NTdKdNPGnDIPKHeLI60FFAhkf6eWeT+pcRn5efzZtpLreO0O+PV+WIpyXNxK7/iqTeL8lAny9c0NlP9nMHu6iekf+GStXmZLxbitn4MDAiwbrqXvWa63b3THTk93hTqBG+E07VRnDN/UmwUwNby6I0/x14vsINyqraA2xJhqt3uLYMcCqLECqzScuhoSLliMwwpjfLpUObCDbYc0iPQKTQvE7KZTdz74RMo0wl9Y8pSbepziQ4l0xKoSOovI2D1ILMa0LcG/pLzXmm0f63hsN2GoFBhr7jBXGczbkhYvszahgN/EMccxcBzIlZuWLwpdb/8WAaBAT3ETDaMUeKbhmQnLP+0eUJxSXwIYya7e0EagVuqCXuyOFkHwsGTD18+ye+qw424OINNkoe6ie2DtMFwB
 PGn7SypD
 JUHRUrULlv7E0uh9/bmKQk6YOjBkqN3udkdjwnNhlD7b3LkKAxv62zBqSjRzIJqUtZ7LGf59kZfzBZHGnwfJoQ5nv7yoKL03hb/aiPT30fyXnB4BluFkfILSF1J59/HI8zSdgTSPl7Ep0EmlxHar3E5Sgx0eTNyyqZDbM8WY1f97uG8TMq0CpWy42mnsxf5bSjunWc9MIZ7EiMwdc5yJSrs5WPFf+QK2av7yf7Wc2NOiSxfFhXttEhg+ybv5buQFLEfWyHOldeQoC4YRwDXkhF+Qw86sVO3aa4QE/xkMxINLUvD2oPRvjemqcbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/16/26 06:41, Lance Yang wrote:
> 
> On Tue, Sep 15, 2026 at 05:13:17PM +0200, David Hildenbrand (Arm) wrote:
> [...]
>>
>> Ok, it's really only DAX and anonymous VMAs that use the huge zero folio. Other
>> (module) code would have a hard time using it, as mm_get_huge_zero_folio() is
>> not exported to modules.
>>
>> DAX uses dax_pmd_load_hole()->vmf_insert_folio_pmd()->insert_pmd() where we
>> deposit a page table only if arch_needs_pgtable_deposit().
>>
>>
>> So I think the rule is simply:
>>
>> arch_needs_pgtable_deposit() -> always deposited
>> vma_is_anonymous() -> always deposited
>>
>> ?
> 
> YES!
> 
>>
>> The trick is that we don't have anon THPs in non-anon VMAs.
>>
>> So could this be simplified further or am I missing something?
> 
> Ah, cool! I hadn't thought of that :) You're right, anon THPs cannot live
> in non-anon VMAs, so pmdval and folio aren't needed here. Will simplify
> it as suggested :) and add a comment explaining the rule.
> 
> static bool has_deposited_pgtable(struct vm_area_struct *vma)
> {
> 	return arch_needs_pgtable_deposit() || vma_is_anonymous(vma);
> }

Yes, that's what I had in mind. (while at it, maybe call it "vma_has_*)

-- 
Cheers,

David

