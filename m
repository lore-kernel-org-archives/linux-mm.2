Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04FB5F46100
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 12:57:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E1116B0088; Mon, 23 Mar 2026 08:57:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B8B66B0089; Mon, 23 Mar 2026 08:57:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F5EF6B008C; Mon, 23 Mar 2026 08:57:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3F7246B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:57:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DD8A4BCD78
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:57:10 +0000 (UTC)
X-FDA: 84577328220.03.20C9747
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf08.hostedemail.com (Postfix) with ESMTP id 227D4160003
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:57:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qT4QR1tZ;
	spf=pass (imf08.hostedemail.com: domain of 3ozjBaQgKCG4VMOWYMZNSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--jackmanb.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3ozjBaQgKCG4VMOWYMZNSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774270629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PLdNQKNpJfNXYzn4cpAS0Z9lYnfTUb7+HBLinvV2mSw=;
	b=QheXcv0JGE/y8S1PhN5Fnt/bkuyDRyd7PGDFdF71CVS9H8e7QsBqQdxHupOtFJ/MpYTlAp
	4NpXTZxpfckaypXFCiLEwVJ20odU6BjdRIcytIR8G1LnJzjlNq7i5YKOqHzPO0HMw612Eg
	mW0oLYwU30Jo+O/OVbMlLGAmGfd4/UY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qT4QR1tZ;
	spf=pass (imf08.hostedemail.com: domain of 3ozjBaQgKCG4VMOWYMZNSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--jackmanb.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3ozjBaQgKCG4VMOWYMZNSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774270629; a=rsa-sha256;
	cv=none;
	b=8XCRWd8jd7/rxQ+24FhFxJSxnBLqjXoSpVwiKc/2t3g7pVfnqm64n4xcoehPLugY4fvwYY
	HaSSQ6m+OqN+DLz333pZ1WfXUAN2ImCPWFKe20LjdFteg720FATkYX6ovMI1DXSVvWa2fA
	ub0WoqZkVLV2P4Bya58tYofaEDrSKts=
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-669010da954so85052a12.2
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 05:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774270627; x=1774875427; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PLdNQKNpJfNXYzn4cpAS0Z9lYnfTUb7+HBLinvV2mSw=;
        b=qT4QR1tZ25zKcos+zt4yhSdCOi+INg8BbFUAxUG2cFwjur1KbRwCD/sV0GYDZ9h8lH
         grvT7rXIC4jMTqCB2KisXoRt1wJSStD7Nk27YFNXT3AqO31tnLrgIuo1kRSJ1B2umA8U
         rDVuaCWH6VG2OYYz8rcmsLsWzQn2WNzRbR8K9ouiwRnIP94M5Te8bUcJRBiTxQlmlJi8
         cAAoK7acbC1/84OxMoUYC8gkX9MCcPQAebUaBxaqvuSQcOW1Syw2/BflPCCYPpJ/HsOl
         AWH7B19z8jgIjma6CHehi0KfAy3qoZAr1mp9kphuchnr11JPyd8zxzgPE+PhGZVut0SB
         7vug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774270627; x=1774875427;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PLdNQKNpJfNXYzn4cpAS0Z9lYnfTUb7+HBLinvV2mSw=;
        b=rMO6qzPLdEDCzGKN5djNdKakcqwkuMmTBD7IYKJ7Kl1RbMC763nVnTJqvcyGfd+GkT
         wiqwnS2rA5ScGORmB9ayK8qAAM1EY4UxNEk0Pp2E0GhMkBrvNKp1F802PmYgt04oNwVy
         aufbwDz0/wrDM61zTYZrM4th4RZuICh6jMID9mpsTegxfltxJhn6Bd5m5a5agkg5ZfSp
         Ef9eY+TiS7y+CcvIxEQi5fqiyLMUc/XUWBu7RK14hRbN8m1euIwAsW38cSbEfZHft+UV
         CR8ICExndtDPk3YnpQEO7rR5CqVdHDzXkxy+GXc2xSPtsdW8Zy/7fCeoIgyNC2plshIx
         2aDg==
X-Gm-Message-State: AOJu0YwnpUl33shOqf/nrt89kojxpylp0xp9oqFtI01DeNsjDBOBhRTS
	HrWwjzP2R/itRRtL8F/FIA8euv2bYFtBtn7yDmYVgw9BUAuYg0OGDCy3Ys56YLKX7RezPqeQRXJ
	WVF/QAlNPconxZQ==
X-Received: from eddt7.prod.google.com ([2002:a05:6402:5247:b0:668:7e92:2c09])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:a58c:20b0:66a:31:17f9 with SMTP id 4fb4d7f45d1cf-66a003119demr990706a12.14.1774270627244;
 Mon, 23 Mar 2026 05:57:07 -0700 (PDT)
Date: Mon, 23 Mar 2026 12:57:06 +0000
In-Reply-To: <DHA59LJ1UQ1H.10RZVJ9V4X5TW@google.com>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-2-28bf1bd54f41@google.com>
 <17e58542-1221-48dd-88b9-236128515ed2@intel.com> <DHA59LJ1UQ1H.10RZVJ9V4X5TW@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DHA6G1E2H5P4.2D7JKTRKIBE3U@google.com>
Subject: Re: [PATCH v2 02/22] x86/mm: Generalize LDT remap into "mm-local region"
From: Brendan Jackman <jackmanb@google.com>
To: Brendan Jackman <jackmanb@google.com>, Dave Hansen <dave.hansen@intel.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>, 
	<kfree@google.com>, <clm@meta.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 227D4160003
X-Rspamd-Server: rspam08
X-Stat-Signature: z6bs5zgspg7c5caw71qd7fq59wanx9ba
X-HE-Tag: 1774270628-751935
X-HE-Meta: U2FsdGVkX19N3Ku1MCJsHCOFFe7fwwb6rQEpLC1Nnb6nyw1X3P4OcVPf3yt5VGgObExzBBrxiiVFkUeQS550C7Y7b+KO4oX6b3hn9f+r3uQFo3BX3bvMv8VetA9KBndwdvG+TTM83QZFExZi/hKfJBczLU7/FHdaVeTzJREmRZHMfEG+oZJxXHfIuimBZ2DP54M+79QPCrhKysbX4A1jyY6FNbYzrWJ/+zTAl2zm/4QTfbuZf9ryRLvRVeQxpqOrGphASwldkU+UUnDOKqrK8VtDyCMSo5SYdV0Z+5ubYmUMDol81GJdbcDO9sufTobhC1TnTlGVSsmWnlTr2yTH4roRSqCUPXjgWwMbhtyKO6tEANSECoxAHlmBfL/PXHT07tpowx28jSsjH6aiTra12y+Jf/AEW1wRB1YOVggcy6hRmBovEpOoxEtBQL3Gz8/XhF4JBR7Sr0scNpn/YSj4yX16tXy/NVcPkN19TKtDT6yjrQg1nn4fAQYiN/A+uOqqyGuAmlRpSJVbhp+QOghQy7ZbvyHTX+DTzoHKHGT9qTuRhkMo+Xb7BKWX0UhN5doDZqGSx1sde9ufCDanrAxk1HczbAnFhuqj4eDDcEsZQDTWdKO+Ncl0Smfnwv96trWG7GgMtm2+vLk1zDmnRBXLJv6J5GDV5A/zlKC3HlugMdahNd4qnyOjN50MUBWWqx8I2CK3eUa78c2h0p2abnxC/yVIlAg+XMn8OVkqR+VVXssR2pwp/xna+lQUDSKcmNLb6vxHjL4C1TBrHOqfZXfHC/a/JB6KJ/is/Lv6nEkMZBe+5q1UiP0UgnvpdKW9KBiErMW5O9jZ4fbedqw3erf8QhWWVgxz0eon8UhxOEJCtMODEoSyyMZeOTtuHuDRJ6ZWMjI1N/SkhRW5Y07jr52oIZ6CRRwG1juQJg9sgaH9h6nJEMd8ET+u8Gkg+8zMcPAqaLxzLEkVJtRjSTQG5FA
 3jbEIsLr
 h8yXwY5Fsvta50Iz/4UiBJkuhuq7lUsHHEdKPMWNV/JKnh14WLfcOJKGdfjmdvE2QWFETedpISX6UoEkswdJofv9+TRZW1PkNJg7bbLcuip1L7CPnOnuGOTiZ4LXHr4Gy2rBL/JySCilpswhth3/LbqA4JdAGprVptq9Jqh7U6NMGH8gOGW9+i+HBiAqIR/dTinSrHMWcOCKoA0hOiCzkzhZmph3vCbL3LNEblJHD+/wkMzwBVF50W3xhPUcg9PriP9MN2TKF6lp5og9shqJNwml0B8tr/g3aFARxhX1zxl6l5vqt7+bRg1jzAfEffOuH+bNSjAcdSily/a5IFXE/NLN7nYsrTtgu4L6WAV9Za51ZPRrKuYz0b3m39nmENgh3VEFyT20Z5i9QXcEEFLsyxyvN7ki1k1z/Rqk6+NstSUg/ortypPxBjbPSvW5Gq+01TbCn5WCKoyLRPWJ3hdIwozZnawxapWpa0Fzgqfl8HWoiBwaIurUU9X9raliJDFT2669dnKU2GxzroiTqpsPmfCuud+J1iwJduTotlzNjw47BpiHMFZ6gv1kSVo+x29V3UYpNJMGtHpqWgYAvg8ZQNb/kE96YW7iOOv5qlz4y5xStYFm8l/gCbuUv3PHzqIhlVs6b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


TANGENT - off topic, removing most people from CC.

On Mon Mar 23, 2026 at 12:01 PM UTC, Brendan Jackman wrote:
> On Fri Mar 20, 2026 at 7:47 PM UTC, Dave Hansen wrote:

>>> +		 * We use tlb_gather_mmu_fullmm() to avoid confusing the
>>> +		 * range-tracking logic in __tlb_adjust_range().
>>> +		 */
>>
>> Imperative voice, please.
>
> Yeah I don't think I'm ever gonna stop making this mistake. Any LLM
> should be able to catch this for me, I think it's time to find a way to
> get that into my pre-mail workflow.

Just dumping what I learned from briefly looking into this:

It looks like Sashiko [0] and Chris Mason's review-prompts are not really
well geared-up to deal with trivialities like this right now, they are
still evolving fast and focussing on much more advanced topics, and
AFAICS they don't have a standardised way for the agent to "shell out"
to a cheap model to do simple checks like this. So for now until that
stuff crystallises a bit more I'll just use a dumb standalone script.

I wrote a quick prompt to check for these particular rules and found
that the "pro" model worked perfectly but took ages (and probably an
obscene amount of energy) while gemini-2.5-flash-lite was instant but
very unreliable. Then I asked the pro model to rework the prompt for the
benefit of the small model. Its version made the small model works
reliably. 

I'll paste the prompt below. The command to run it using Google's stuff
is:

gemini --prompt "$(cat check_patch.md) $(git show)" --model "gemini-3.1-flash-lite-preview"

I assume open models that fit on a laptop can handle this task too but I
haven't tried it as Google's tooling seems to be hardcoded to funnel
you to the cloud service. Yuck, something to figure out on the weekend I
suppose.

(Alternatively I bet a plain old NLTK script can handle these particular
rules. But that will run into limiations quickly while dumb LLMs are
generic).

[0] https://lwn.net/ml/all/87jyv7a1q5.fsf@linux.dev/

---

You are a strict code reviewer. You will be given a patch file, formatted email, or Git diff.
Your only task is to review the English style of newly added code comments (lines starting with '+' that are comments, e.g., '+ //', '+ /*', '+ *', or '+ #'). Ignore all actual code, variable names, and removed lines.

Flag a comment if it violates either of these two rules:

1. Avoid personal pronouns. For example: Do not use: I, we, you, our, us, my, your. Other pronouns such as "it" are fine.

2. Use the imperative mood to describe what the code does. (e.g., Use "Return the value" instead of "Returns the value" or "This returns the value").

Output format:
If there are no violations, output exactly: "LGTM".
If there are violations, output the snippet from the input where the violation occurs. Prefix each line with a '>' character, followed by a brief description of the violated rule.

### Example 1 (Pronoun Violation) ###
Input Patch:
+                /*
+                 * Although free_pgd_range() is intended for freeing user
+                 * page-tables, it also works out for kernel mappings on x86.
+                 * We use tlb_gather_mmu_fullmm() to avoid confusing the
+                 * range-tracking logic in __tlb_adjust_range().
+                 */
+                tlb_gather_mmu_fullmm(&tlb, mm);

Output:
>+                 * We use tlb_gather_mmu_fullmm() to avoid confusing the
>+                 * range-tracking logic in __tlb_adjust_range().
Avoid personal pronouns ("We").

### Example 2 (Imperative Mood Violation) ###
Input Patch:
+ // Initializes the counter and prepares the struct.
+ counter = 0;

Output:
>+ // Initializes the counter and prepares the struct.
Use the imperative mood (e.g., "Initialize the counter...").

<END INSTRUCTIONS>
<BEGIN PATCH FOR REVIEW>

