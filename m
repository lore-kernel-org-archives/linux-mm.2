Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C3E5CD5BB1
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 12:11:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BF0C6B0095; Sat, 23 May 2026 08:11:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7488D6B0096; Sat, 23 May 2026 08:11:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 611156B0098; Sat, 23 May 2026 08:11:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4FA656B0095
	for <linux-mm@kvack.org>; Sat, 23 May 2026 08:11:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DB43193041
	for <linux-mm@kvack.org>; Sat, 23 May 2026 12:11:08 +0000 (UTC)
X-FDA: 84798569016.01.BCFB862
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 438F02000C
	for <linux-mm@kvack.org>; Sat, 23 May 2026 12:11:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F734qm7D;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779538267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UjlwWAFQXurCmVH5SfbVuNoim1TKpkRokW4Dr7IwTnU=;
	b=Pljo13yWoz0ijBELEN0Huwvujw7GLPM2dff/8ggiOMFOvX08MFx31CDAzJ3lhYPJuXj+Mw
	TP1gBRCk4n8iIlqXbKJBs7CKrr3UEC3dHCMOqXj7mAeK18rmOXKRBb6oHiNmDdE/iTQt8A
	z6wYzHrws7RrB0wQJndXxlToK7zx2t4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779538267; a=rsa-sha256;
	cv=none;
	b=oqHVboehGURAOzy8kRnar2uHwpNKCLjvopjTfHjNvR57wITexVRrLIaPuAJBrQsvOENVqX
	3pbg/mslC+L9GmyD6dMIudxtUGN9J8VfNn6GeuhGmraDyhMlqllkt5K+1BIvZ2NHlWChEW
	pKEo4Vq3V6ZU+hc2IlM+lyzwFfoPTM8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F734qm7D;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9309C60209;
	Sat, 23 May 2026 12:11:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8691F00A3A;
	Sat, 23 May 2026 12:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779538266;
	bh=UjlwWAFQXurCmVH5SfbVuNoim1TKpkRokW4Dr7IwTnU=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=F734qm7DZYLMFADDYXRhEEKKvO0INAdvAbkN3rksN41lQDigKzrgtYo8Xxv8U5Vmb
	 ek+euMDdHxoneKhlPmQ8h0ublMO3gxujCiGTYt95AwTYrWCPhFvhrEJ71asYrSMutK
	 ep1cnw6iHy5KNzi52qKENsImnqUWMjaIgPPLxoSmdcEwtrfQ+U0baumO6HN4XmFWf+
	 nkfQeo7wJbGsZjrTn3yN1beMZgeMovsd53Kc5NGoUHjtZo3UW1COTSxcL0M+IZ6pei
	 7WHpYS1KrXGdF9AUHcV2q6viwuDXwQnnNXuGBYP9cQhcrTSNioWbj/dLfnQfROaBwT
	 6BCRx+xsG9Zng==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 2/7] mm: add a set_page_section_from_pfn() helper
From: Mike Rapoport <rppt@kernel.org>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: apopple@nvidia.com, akpm@linux-foundation.org, arnd@arndb.de, 
 bp@alien8.de, dave.hansen@linux.intel.com, david@kernel.org, 
 mingo@redhat.com, rppt@kernel.org, tglx@kernel.org, kees@kernel.org, 
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, x86@kernel.org, linux-hardening@vger.kernel.org
In-Reply-To: <20260521040124.10608-3-lizhe.67@bytedance.com>
References: <20260521040124.10608-1-lizhe.67@bytedance.com>
 <20260521040124.10608-3-lizhe.67@bytedance.com>
Date: Sat, 23 May 2026 15:10:52 +0300
Message-Id: <177953825217.3959652.5821431794861471690.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam11
X-Stat-Signature: rfynkz6d48bgtm7bxp8c6hwznkpb1f15
X-Rspamd-Queue-Id: 438F02000C
X-Rspam-User: 
X-HE-Tag: 1779538267-264831
X-HE-Meta: U2FsdGVkX1/ESo5yD/NURQZ5+agDLpBrmHqRnuRUgutxkj+HRKq7LHrIXwvCFRq/cSrz3BPDuj7CcrLgvRkZd7XAjWp/z2FeCw4YAqd3r41pkLwOJnvchhA05t+bMYFlWmB8j+KOuwjISJVXBt64fVKvdH4ijCy6lwuivkga0y2jpcLmXOgguGKuIxkBwdikHP0MyDHuCAdM8wOP6ckxaoo0t05VRcupBKfJ4ItQKhBWXG9Jb0C5lmEJ7Rg+ql+kwboc2zRtDuOFdhABNI3Sxq+2APCPdPgQXK3vd4r3EbbFjkaqdPlPaVQ8VKC9xNaiLZyq6ktr9+i864X2v21PvKYIvdt8l0J5uSG+kLdq6TEWRGyezT5vbCtTzd9bPUCXhWYEG57tEokV2m7jQGs7Og1/apPtqu9lK9i9fU5cWdHHegG6mS0dpNYcEcD6Ss054uI1JTAUbVWIDP5JiHDq+SBBXJFukpIGS939ynvGoJA4IFbi9wR0BprkxjoeJAX1HWizr/xgjOAp601V7x7ap9pN+PUGGOoTypnQYMyPZCt5G62XZ/r5C0wDjWbjY1fOKteNwTqcieMQNrjUDs8NesE0wJK3IO/NoDGLZZkZSQDVYVbMgvNMqO5TW7AuhYHQ0khuK+oOIWFoDnXz3KWeDN36NslWwcbBLtR2OA2T713iAuZLZqFyC0H/7C+adq/RtvNoxciNv/bffSokKfw2f04/vL0o5cQykk2opUf1t7rLZXI+bZ7YALpcK3I4PFAsvW1GSCFv0594456+c2QQAUjVTmnd5XAWVDIrunxCQnfqH5wKZfJsnCnPFftJFTQmg2dVA4gwluRwIaKcm4cv3+9OlEqscpiYJ59lPigU3pjdFZRljvUjASccv0wkCrP67zBAja0lLyjwvYwnNCbtr79+iOeUpAxyiloUaeDzycdpDXV7mhTpGSTtqcCu16zxAo50n/xgP3gstqPgL04
 WkSsfEuI
 XZ9Zh5mj1kYoHVfRChSzrIaQ8uxWTWj7EhwqANmxKPYO6KqDgDmbBwTN9O9rSmCfEb6fK85wvJ177rmD484jBNgk+os1ZJ0dC3xXrR3Gnj1vUn92ZN5eNWK/LV9vt/Z9L0uo184jl8hzdl78/18HDPGbM2Ogw8+dNchJ1IoA64u+7/QPj5myxP1HSs79ZHp0CV7JxME5EuE7m0Qu98i42DIoYgc3oS//251lgPrNwJhXtNsxTZvDMA4utIbVS83ZTV/DRaKTil8af1w4ocq6+HT+0z9SDcnkEAYe678a2gkDlvx8kMQzr9y87hKED9CjsTvNtNrVuUpn0B0IHaXpItJSPtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 May 2026 12:01:19 +0800, Li Zhe <lizhe.67@bytedance.com> wrote:
> Callers that want to update section bits from a PFN currently need to
> open-code:
> 
> 	set_page_section(page, pfn_to_section_nr(pfn));
> 
> and guard that sequence with #ifdef SECTION_IN_PAGE_FLAGS.
> 
> [...]

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


