Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2016ECCF9F0
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 12:22:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 416918E00AE; Sat,  1 Nov 2025 08:22:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C7988E0068; Sat,  1 Nov 2025 08:22:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B6718E00AE; Sat,  1 Nov 2025 08:22:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1B63B8E0068
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 08:22:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B5AD212B9C6
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 12:22:51 +0000 (UTC)
X-FDA: 84061952142.21.7FC1C22
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0FFD3180002
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 12:22:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UQMSLWUr;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761999769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iR1r/3xhU7MVcJwVYZUltUXo3c7eUSFIQ+pGKdoQg2M=;
	b=zQ+WsYS3gBZO99YLz370OSNmVzMLo36N+IOwkJWConPzxYtq+1B+dqmaBeeK2Cr0HLzQKG
	Sukx1NQTuMAoVPE/HeV31Yx7MV+9vnfFKhnLVV3ykcnBkjVHY036A+CN1T2whqNGM5rpsh
	zeThzamYT6EZC19T9R7/WHOXW5RsK28=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UQMSLWUr;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761999769; a=rsa-sha256;
	cv=none;
	b=hdqvaAsmdvm3/TRt6DDVw4vvhsVeuPwVdFJ8MHQHRKf4jhEmeHZQnlBX6WTOERnSei7oH8
	tnVggiKAQ4HGVPCJlVnsxS/Cz3mquFR8JT651/svPDwm9vJkBKYMcz7dpgu/vypfXuWmgV
	ewBy8d2FwvebCUoE3JoNb6oXLAnEzXU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761999768;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iR1r/3xhU7MVcJwVYZUltUXo3c7eUSFIQ+pGKdoQg2M=;
	b=UQMSLWUrkXO0pRNmu8worlMcsAfloA1RfS0gSaJ8hYaZrQeHS8G6qzI1H6FBWx3ObyL3cS
	FP3g4/q9KDVDqqaiOBnF9y7k1pshb9IlvbnKxyuZPllG2xIEbguTmAy9IVadJDjBlPxbpB
	5O1lVBWdk5ES8R5IQRu8hDJhyI54HmI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-U-MU_vmjM3qXv6FqxiXm1g-1; Sat, 01 Nov 2025 08:22:47 -0400
X-MC-Unique: U-MU_vmjM3qXv6FqxiXm1g-1
X-Mimecast-MFC-AGG-ID: U-MU_vmjM3qXv6FqxiXm1g_1761999766
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-426ce339084so2435522f8f.0
        for <linux-mm@kvack.org>; Sat, 01 Nov 2025 05:22:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761999766; x=1762604566;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iR1r/3xhU7MVcJwVYZUltUXo3c7eUSFIQ+pGKdoQg2M=;
        b=KVVY0p6j4cQ2+zJ3A5czwMXp5I+xH/Cf+L6zZBr9EGYf59U58sfJXsC0eX0lb5i05k
         I/KqLPH5BrWB7excQ6yDEuw7JtwMgP29wgzyuUrByS6qDyFNWSDBvRhmoyR9LNb3RYhE
         /sztv7kc3KY21hUIg0kUcr2iHAnvRt45+PZ26G1zsuApBbNBjaldneORFQebHAzHw4oh
         6ch8z1FrLatY7r61x7xh3kCMQPmAMqhH7df2o6SatTGXaF1B7hb1SBhfxmpy6vWH9+B1
         XXzJB9XOkSg//6oyExdoR3Tm7LRjGfYDG14kDVN+i8AdhXzmAyLcpshamXDRopoWEo/o
         eeJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVbRF6HzlKJxzotSSgIteaa73GyCH1wtuXIG2HyKqRP9K5+IzGaOzfZ3fDr1LFsiV396HDiwWocKA==@kvack.org
X-Gm-Message-State: AOJu0YzN8a4inlm3xEsdwbdk4o8uWu2dOZM3UXbLdXYnFW4JyrWzrJZs
	/wuEUFrMFnguLPctoBN4PXmgcBcX/Kah16HlL4y+kezWm3Ao48pzdnLjp6bhNH9LOyZa93rmRIj
	URtfntXBF9Lzj35xOoVwHFqKzRQiVAfxeFiafVRvpXuK249P0OB9S
X-Gm-Gg: ASbGnct93apK3Qq3B5FZmb6oPyl1tmLtCRBU69Nk8QBdjNYV6ymf1NbZztjJ/xJDimG
	RUwF89gqVkcibE2VYUQao30QlKCnEylfmqDaZDLvLWCppPlqechhs0kScWCoxiG2PiniMLgq2y8
	cmaD6Z74qSQjkm7PmqFK67RFK8Y9j8Sx1PvzDpBv3kl6l0j+jdF9HxWQrcWrekp2lawucAvTiRJ
	Tk927W/S5ObDKshJDqP8FEO4zMI5Vy+8mbYgTJkukQ+nhbUoeKJulQylleOTu25evjeJyAdQZ4/
	ToAkO2ObvjOYprYNSEwfOgWXuOOviCahHr1qnDZlvl3XfGsTSK7M5zmYB4kZHRNQpE6xomhD6bt
	a+yXijGpUrB4PswI6j+Bk2/3RewrWmwMj2nfXKBSFcKmUTOgSlBkPOYuNcZ10LgQp1PMG6sN4gY
	PKPlyERwHAxbios8+aXnOu6GkGW5c=
X-Received: by 2002:a05:6000:2f86:b0:429:8daa:c6b4 with SMTP id ffacd0b85a97d-429bd6860d5mr4833009f8f.21.1761999765967;
        Sat, 01 Nov 2025 05:22:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFJ+TTH/VeYpEYhd62jH/WbFLaTQZ/6xytSCDTH7QTl8AfN9d4nyTXPMxG2nY+bN2wOvpiPqw==
X-Received: by 2002:a05:6000:2f86:b0:429:8daa:c6b4 with SMTP id ffacd0b85a97d-429bd6860d5mr4832980f8f.21.1761999765533;
        Sat, 01 Nov 2025 05:22:45 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429c110037asm9461926f8f.3.2025.11.01.05.22.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Nov 2025 05:22:45 -0700 (PDT)
Message-ID: <ae1236da-2647-4d53-bf4d-ff8fc32eb734@redhat.com>
Date: Sat, 1 Nov 2025 13:22:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/12] mm: enable lazy_mmu sections to nest
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>,
 David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-8-kevin.brodsky@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251029100909.3381140-8-kevin.brodsky@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qiw-Qez_vyGPgtZ5K94LKkcq2vmkkoDWPTZPBg8EgEk_1761999766
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0FFD3180002
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 3krf9mogyfb7fjmpxqqnbotdbd4kjps7
X-HE-Tag: 1761999768-593083
X-HE-Meta: U2FsdGVkX18svXBbbtFxxuKysg43iT84l8Eg1FKNX6DUxPnkJycHO1XqnzZXfA+BHK5N0nkv15SzQK/fGWtmR/SAIweN9IrmWJe5Vtc9QcKXa+nd6/8atHrDuAKsEnciLMjq2/tWHNWX0csFmilsTD5cdgNrv9TDz5O//lnFWjvPqn4KtdRRs3MwngAEYaohBoyU+4zjuRsjK+E31bfbKn17Ha5fLSsY/sXnmEnmBsB+LUnEBtrsceEbBbE5Fny6jK/wPW4ZwuuxGwYaSt+djY6mmeLSvQcx5yInVaBCsV/ZjRtQGjXknmzNYm0taDtkwyiZ/utO+CKpO2lIaYJ+1rt2BanTcU1XWoWZMKaSDpkFur1XwRFnBH0LskK0boTzSq2dZ0m9J0CQskQ532NJgoLAK4kdd3AjinaU2XFsKUTTJymIXd4fJKD2OL8nmRlpDSTJIfUijWsYJfHPfGDfk0Sv+9/D1Y66DNXdyAA2nQ3w0QlsaEMeNwb0tFJMARiR0wOQWhPQhwaDd0PuN8y7Y2IZZEyJVgIokk4iAC5nzu/g+EAlnzP695fjmiP47kx+1bTC1JlKSsLmkJpGvrXwi5Vo3n5e+ZJ6TAZDN69T1Gw9+n7ZiFUl95v0hH5wzBY0Afrm7P8jWyNVfPPEJCWkWT4+SapaboJdVOIrlep9MfPRBg7gvwALiNIoPhzo/EIiZLy0XtS2XLV3gARdhWamB4X2FrxOLcoA4+nq6qC4fPJ+gRxDrE+ejidPYCdmYrEkcVOZAoNLMAWF02yhMxankVSLogLNv+7nDe87227qjvP0hxpk9Mmghapr9CGEyQm6skUFEaKvrM1As2Ay2Nt5ihNR25bTgLF5jtNrDb3TEgnrtvI0JGkrFrmXx60JnHDJLhMuWkNpc+5VkfCrnTwzUfcmVsBkqF5I4vxJxB82jVUbIlSOP6oU00BgGAE5LcjhbHT+hlHt+htjWHIljnm
 IHskmFh0
 YCpCkq4JGo4kyUlvwF1iFQ7xnAe+tKDatfQUfR640HWth85WS+ELAYcuRhX3t9aDmr2PVL0QO1uQyhMqeruDLdvogsxQm7ZggQypsomOastuIQF0pbvsnFvHv5tQGcwwysg3Y+gSMtIleR2Bov/UMfgj4WKHSFqKEVq4S3Iu9MK6aRfAv1e8H5qZu5JwqWJn6ZG5658BMAmAOfQuAyHnfIphjKXeTF8MOBtAbXCNqBLSrBdrJOgbpx/fGgnvJEWW70QK0d5pITdHt5GWiBtJjQPFP6/XmUf0dM+xyUOLqv+sITTdUl1esz8ZBDGjyRJZbu3Dpq4/LOtRFxow3yMKGJl+eDaU9WSyNfvYy92Y8cdqOYWCOJNrDBOdBAprpp5wU9dPkYi+1QqmHUQ9Ry9z+0iISJ5sO4DCZXR/yRFMwx+4kJQ7bvq030Vwq80n54Ubq7gMc8Q3JLxYdleDiQxt/fCX5IluXbTxsxuYowGwgC1jmSyOUjYsS7Km9TVgv1fblnK4mXjIrXDOxLZnYgVpGunko+qRFm9CANXbsk3S2yaysrFtLUG2VA0hFFu5p50BnZlh4jOey3RT65sP7MtH86fnFiO5+5egRayzP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>   static inline void lazy_mmu_mode_pause(void)
>   {
> +	struct lazy_mmu_state *state = &current->lazy_mmu_state;
> +
> +	VM_WARN_ON(state->nesting_level == 0 || !state->active);
> +
> +	state->active = false;
>   	arch_leave_lazy_mmu_mode();

Just one question:

Don't we want to allow for pause/resume when not enabled? Would seem 
valid to me, because pause/resume code should actually not worry about 
that, right?

if (!state->nesting_level) {
	VM_WARN_ON(state->active);
	return;
}
VM_WARN_ON(!state->active);
state->active = false;
arch_leave_lazy_mmu_mode();

-- 
Cheers

David / dhildenb


