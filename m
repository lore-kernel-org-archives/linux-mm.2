Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2222CDE00C
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 23:13:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80D676B00CD; Thu, 25 Jun 2026 19:13:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BE426B00CE; Thu, 25 Jun 2026 19:13:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AC136B00CF; Thu, 25 Jun 2026 19:13:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 408EF6B00CD
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 19:13:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AF5651A02F0
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 23:13:32 +0000 (UTC)
X-FDA: 84919988664.06.3090545
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	by imf16.hostedemail.com (Postfix) with ESMTP id CD62A18000B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 23:13:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qWhLKzYj;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782429210;
	b=DZX0ILMDDoo2BOg0NmByg6xFR/PtN/q9qkRwFOPVmeTT+SPk5CeXXUhFH+jOwEEgVD5ytB
	28hSjw4SHLK+try52HW8kXQVvr5MX8CFKfm45SKEYQ8bZv8DCsFrlrcCnL5P5aV8/qzpqB
	Huk3SZ3uvzPtSoCRtLsrtkl5QEZCHNA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782429210;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6jEB+64CGO64L3vQ/fQFpSQV6VR2aG1SudNPISzly3Q=;
	b=b6jvXieD/H66nN/s7UrYBCPXOx10ZqHKrOJenPkuQNg1PK+t+ZeGEtUxeCW94si4FavFGA
	sSE3+UMWLuBTn5V+okOlEW87mau2lb/4QrR0Dus4a8W8GKMsceiRXbmtA3QVwj6/1Fvg+C
	AHE0xGN5QDvZEE2xHJ68z12eXo+9Jek=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qWhLKzYj;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-1384eb94d20so976701c88.1
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 16:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782429209; x=1783034009; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6jEB+64CGO64L3vQ/fQFpSQV6VR2aG1SudNPISzly3Q=;
        b=qWhLKzYjUnbh2/CNgMyvXyiY2SbMpsKX21BvEr5gX9/oOzLk29tRVqo6RbL1UQg1MP
         mBMSUqLc47Ju/cMl553rhpXRI/+D2EwN2QbZkOdYG+NMaVmMPV7SNUoeOIERAA/8kSJ4
         0doDDPzV/rcshZZYU6XGC5WPCtqX8DAoLrg54GXWjOMATD6KSlsUYmIJHHkVKhDPYLWz
         Xq3H3lWF9qlJ3McaNvZE9AAJv0fUOIpebOzOHRowpGxe+7vyPsi0f9U1wvEIly0GV/If
         YebAOMwqD2K1GWtqpKcQT5TEDD00wCNdNb7yP/qcoJOhJ8ULrSJLMyDOnddJEnxWlmhz
         1V6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782429209; x=1783034009;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6jEB+64CGO64L3vQ/fQFpSQV6VR2aG1SudNPISzly3Q=;
        b=fkNpr81JCVcwF7ULb3d+MJ/lcKuD0JvG9EJEnPQXd/EOPP9jkosO0az25iTXdUlHLY
         bvuKLsfBog9cPQgWeOFcxi+2YHbka9ABXADQ4im2XGckmco+OU76LT31lfM79YOkZuA8
         whO+ywr5BXunfPoXt5lbEzG4gWIlICvcXFHoNR++LI89Q+BfSxlORvjM+FL0iJ2xwEFx
         nFrdv0qWblOZUqAe6Af2Ad+8P0n+YOKoZmU76ySCddKXfY43K9NRh3WYU9lRaXthHHZI
         qBnc6uB0c6BqxBuCkVJbTWbCSdROaKORBlQkwunLv7muMZCH1x2bbX4tyDvlZdFZO1sH
         SirA==
X-Forwarded-Encrypted: i=1; AFNElJ9xnPDb6ptBFbEheiv9DpH5z4jZ0Eao/j3b/sffG30SmEa/eomRFkRmCLRkJm5rZpG9cBo24dIIQQ==@kvack.org
X-Gm-Message-State: AOJu0YwrpMaONBfVt5Dk8WXAAsu5ySmbCu3UgPEp8oS4s2zji24W3k3W
	LOqdkt1eNUFrKwf/e4lnJbEonxeoimVXaGtyqxBbjOnq3pdpLsTL+zu3
X-Gm-Gg: AfdE7ckH0wEXbR156DF48cN3iDmF6zXHznEPUYcvHh4QQs9mQGqmaDjbrC6KM28S37q
	AD7HCkHx/kg0v2cspenIlGa9TXoqlQsC4Z3+T7WadJxEB/CAAGUV9eglyppg5lh4V90jEqx2N65
	TSl3GHEGZ8z1Pym0HL7ezaPsCXY2QyeviDtmvIcMC1irS2PAP2NsJYKoeIJx5mzOqxndgDGxF1U
	LJNHav4WUY5cy7mwAR6NHo9TNAqgpw2JBmfpbV49gZwG+E7iyRoRcFwVPA+XjmHLr0vRdlPryww
	mMq1rC9+1HsrKU4gxnOhrVCv67CqUm2eD+ziiJPXdGOnfz8D9JZydtcRhxhiD9OvifDH0ZcOdY/
	m3yFD9oPYPktFdkf+ee5pWHZCHNfZEtIqE9swLYFh/it4teeIE3aDm1ZQkzgydXbpkkDJe5ZSY2
	Iv9/ZwrjE4UUgdBray7OIR/Q==
X-Received: by 2002:a05:7022:41a0:b0:139:b977:9bc6 with SMTP id a92af1059eb24-139dbb2eb4emr4665417c88.18.1782429209413;
        Thu, 25 Jun 2026 16:13:29 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-139d8f6acf9sm11960489c88.6.2026.06.25.16.13.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Jun 2026 16:13:28 -0700 (PDT)
Date: Thu, 25 Jun 2026 23:13:22 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, akpm@linux-foundation.org,
	riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
	harry@kernel.org, jannh@google.com, willy@infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	lance.yang@linux.dev
Subject: Re: [PATCH] mm/page_vma_mapped: guard check_pmd() with
 CONFIG_TRANSPARENT_HUGEPAGE
Message-ID: <20260625231322.kjy34skivinqdtck@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260624082359.2869-1-richard.weiyang@gmail.com>
 <aj0vjdBN-oNMI2yI@lucifer>
 <c66f4bec-0933-401b-bf2f-a1b2e256023f@kernel.org>
 <aj0zDKEJV35V4kMD@lucifer>
 <dd395d30-acf2-4467-8b30-cdf2532f585e@kernel.org>
 <20260625161820.bkxl23ugqjd6tcld@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625161820.bkxl23ugqjd6tcld@master>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Stat-Signature: hs7a74m7yezm41bcz5s8mx8i8n9tcx4f
X-Rspamd-Queue-Id: CD62A18000B
X-Rspamd-Server: rspam06
X-HE-Tag: 1782429210-207154
X-HE-Meta: U2FsdGVkX1+BmZMktz07SYwiNL/R2ufLn7+WLDXMk27cY39+QzUpEYHW/CYH4+T0g8hspjmIKNk5Zq+t3fHiXyxyS88A3EGQua0ytAOtlbp8UNVxQgkTVaSEqk855TsN2WMFFH6L7AVxTIMo5U09EdDaP6a16lWMlwZbjWuMwFc0YTr7/iMg2jfu+tTDsyB4FGsMHpfOboV+VM36omzpZayJU8xBf6KRHn+K96z6AUKaqxoJc7reJUIdOwZ3M14QXFPmhnG3LY044Ug6J3zBhd4NYeY/xCcPYwzD0rpOp9jfT85LJy4kHu7NXz/ggDkYQfKL/YCMjEHDjbbQgJk9ZxWtn713D5pVWRlXH+0XvrrkSdgyFktA8wQTCgFm+fyCXHqm1OT9F7w4bPq1eMppI0v79ylnRLSHs2/PM8+TFfDfwmypvNLbkQMrU0Xrxs4AZdX+SkxuZBXdMKKRReqXD0DZ6wDyBKr011KESaVKplzVius240IskdDZTcZ+iIfVrWy+78UNeqSghpubuMoGIBEzMeo3RQbNLNe2mtCGF9dGiEG9+PWbj0Rnaa+DS8MVzSuGaqBg/EVO1SgX+E7vMG9ff5THl8gwcb0sBtfwcm7w5+5Tqr9S0XNT3nPsrodNhw2XYEBmp0hiCbS42mxp7ywmI8+iT8ZVlf2FiolKOdd3E3NXwjA+6ek0NKdrYkEKYLcZhS7eYBK7n0Dsw1y3Tv/AHxyapZ3SSAsJ4A6W9r39w7flrGQKye3a96tx30/N7J5J39XqE7bHRABc84TQUPbMiQtm5273YT6PCe6mOAslAztKWqHk5cAY80XkqLeHMmDVHkaA0EJp8TmXAhiyuwa4p8S/dQkaJ9GbnI8BllDY48dUSC45WD9ZJAtRz6G2ITUYY62fSxNalNjFOeGHbwbCaEWB/3h9bti0Sox8AHRNXrKf4qSPRJneVsrIztWfOzHIJADXG0UNE8L4ULI
 h2t3WM1m
 VDQNTUu0OAU+8cnYiBeXjkXP06+EY5d0GL0HVvNkarHloRuqoHrga66reDu8G3f9m4es7h390cWGMY3iclfYvbFcs2UBXwYM3MJ8fg9RSZItD5X85TqTttXIhsqP1nEoHBeduzHDKIr+VBUigeeyo6XkwhOWNgtNkPt1Bhpv4+rNNBy2zuhM7cyLALDhKVFPnm/tsyBuqYgaLDdUi3e3ytayTLQx5D9FLCPVB8zKFBRkOU40jQM8Fj3E1VlIy+HoUbo2rerg/lgoYqNHTERKaB3NLZjWXEHlWLp9AWMyfXCM1aq3yBD7lE0mILdcmLXGu0iPJIGOE4s4CT0CM/ct5FcLETeYfDg1R385gqySsATP0e6w1uzf7P+mwkKUcJOjip3zwGybCyWz0R5QXiwu+x7/Q7Y3xOvY/jAWuMUbMV7yYHABssilp83G1JVxo5SvDqIloOb7e0rp4uSzChR1vgcRkcGkPHJn8jkkRWfAAN2Jy6TSp/Von1Wu/TpzWNEClU2LmrokwZwkaEG/P1tv71ia+98hEK4lUGWL8kI/RW9V1MJY4pMNsS+9QhMOjpNPrvlGuzyS56RYk+FOoDm9PeHEUkK8E9jOUEVCGKOFC05ttk/YQDhw6oEZvXp2Ozmn8s41qMjw/1EP1xI+BXtfTuCKCl/myV9EAznCaen6y0+wkcno+9fb3gzp3aFdqYJcsR++d2G3N2BqIj54APqLLlPxWO0RP63jyDYhidwdYZ9tyGs4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 04:18:20PM +0000, Wei Yang wrote:
>On Thu, Jun 25, 2026 at 04:30:33PM +0200, David Hildenbrand (Arm) wrote:
>>On 6/25/26 16:02, Lorenzo Stoakes wrote:
>>> On Thu, Jun 25, 2026 at 03:49:59PM +0200, David Hildenbrand (Arm) wrote:
>>>> On 6/25/26 15:45, Lorenzo Stoakes wrote:
>>>>>
>>>>> Let me first say that I absolutely hate that we continue to support museum
>>>>> piece architectures to the point that we have to make changes in core code
>>>>> to accommodate them.
>>>>
>>>> I wonder why we shouldn't be able to trigger that on other archs with
>>>> !CONFIG_TRANSPARENT_HUGEPAGE ?
>>> 
>>> I think this should just use CONFIG_PGTABLE_HAS_HUGE_LEAVES, since that's the
>>> property that literally defines whether check_pmd() makes any sense.
>>
>>I stated earlier (when motivating a proper cleanup of this) that I detest
>>pmd_trans_huge(). And yes, like I did in foliowalk, we should just check for
>>IS_ENABLED(CONFIG_PGTABLE_HAS_HUGE_LEAVES) instead.
>>
>>Long story short: Wei's fix needs work, upstream is fine.
>>
>
>Ok, I didn't notice this is caused by my fix because pmd_trans_huge() == false
>and check_pmd() skipped, but the newly add code doesn't. So I should merge this
>with the pmd_is_device_private_entry() fix patch.
>
>And should wrap it with CONFIG_PGTABLE_HAS_HUGE_LEAVES instead of
>CONFIG_TRANSPARENT_HUGEPAGE.
>
>
>But one more thing, I took a look into the robot test config and notice
>ARCH_ENABLE_THP_MIGRATION is not defined either, which depends on
>TRANSPARENT_HUGEPAGE (where pmd_trans_huge() depends). This means
>pmd_is_device_private_entry() == false on this test environment.
>And in theory it is false if TRANSPARENT_HUGEPAGE is not set.
>
>So check_pmd() should be skipped too? Hope I am not too silly.
>

OK, I think I got the reason.

The error reported is against v3 [1], in which check_pmd() is just wrapped in
pmd_present().

But in v4, the new added check_pmd() usage is wrapped in
pmd_is_device_private_entry(), which is defined under
ARCH_ENABLE_THP_MIGRATION.

I have download 0day test suite and try to reproduce it with the instruction.
And prove v3 would trigger the error, while v4 doesn't.  PS: thanks Lorenzo's
suggestion to put into its own if branch, otherwise the code would be ugly.

Interesting lesson learned, thanks all for taking a look.

If so, I won't post a v5 for now.

[1]: https://lore.kernel.org/all/20260622130651.23359-1-richard.weiyang@gmail.com/
[2]: https://lore.kernel.org/all/20260624065353.1622-1-richard.weiyang@gmail.com/T/#u

-- 
Wei Yang
Help you, Help me

