Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6A9D606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 10:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V5W1gkte
Received: by kanga.kvack.org (Postfix)
	id CB2F36B0151; Tue, 20 Oct 2026 06:57:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C63916B0153; Tue, 20 Oct 2026 06:57:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7A2C6B0154; Tue, 20 Oct 2026 06:57:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 969526B0151
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 06:57:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3321AC010F
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:57:43 +0000 (UTC)
X-FDA: 85342704006.27.51440C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 741F1140006
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:57:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V5W1gkte;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792493861;
	b=aQ9FBP4ATIKumfXQo6kJQpBZxVr9h4Hg7qbzVzzxKazQR3H6JXPPVNYjAdnlrcL10fdg1h
	bGDZllMcKjfHVSNDRXAojf2TAx84sJ2cNxuUYfzZwRSkyl1QQPcmhA2Tv/7NoYy9J8fpNt
	sf+DHYJ7o1etnys4dBijge6zTrE6HS4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V5W1gkte;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792493861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wSnIb7upBpEY/eYc3ijipLppi9VmEuP2fQKeyCDNlzo=;
	b=YK+d4C0DpJNQNMSpbG5vow5ToRA9tIGTYhKPuzzDpTpYRjcGcsjEc52hjMZ5x+goKFvmvg
	OoX8qsOlo5GCBFQeREBK1Qoxo2T80ivZdOFHs46Lmp54lhYKEkBRpAgXdYhmFhu3avOONK
	TG0pAjDhQwl4URyD8OrL6EiodC72iPY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D4DA418B0;
	Tue, 20 Oct 2026 10:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E131F000C6;
	Tue, 20 Oct 2026 10:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792493860;
	bh=wSnIb7upBpEY/eYc3ijipLppi9VmEuP2fQKeyCDNlzo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V5W1gktecp+JjOpMgu2G8S+FKs5td/FLxIxtpcn00fHEZw74hXCezETUEfVD4ju7R
	 PR97mwO2wWkfYgewh+ZUaIe9MUI8iN4fCaw7p16kahzVAMIyYD3eQgTzUwMKXv3Zl1
	 ccgN0HASBG6xglFO1pzW+e7X5tGF/e9P9tt5o5hoXEUvXaywWWq9hr2Pt6PcALupvU
	 ZnNETo6CXyMiQYuTtJkeDQ+0HphwcQDXVX4KWFrI9BN4BH0ev4xrPBEGHpsMinJEXv
	 UoHdArebb+8hupl7yMNyW8JXtXguQVkc4LTSOB6BlOZQ25ohEjmIRoK56Lkv1jWkaT
	 b1f6s5nCd+1NA==
Date: Tue, 20 Oct 2026 11:57:38 +0100
From: Harry Yoo <harry@kernel.org>
To: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	akpm@linux-foundation.org, cl@gentwo.org, hao.li@linux.dev, hch@lst.de, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, nickolai@csail.mit.edu, rientjes@google.com, 
	roman.gushchin@linux.dev, vitaly.vul@partner.samsung.com
Subject: Re: [PATCH v1] mempool: fix min_nr exceeding the elements array
 after concurrent resizes
Message-ID: <atdIhmwwhQxL3eG0@thinkstation>
References: <atTh-yyVIPQ-zNWJ@thinkstation>
 <20261018160315.1465504-1-vitaly.wool@konsulko.se>
 <atTv1tg9q9n92kZv@thinkstation>
 <F846CE95-6D2A-4D53-9C09-5C8630E2C8A7@konsulko.se>
 <3a034d40-e01d-42cf-9325-8c1e4a6db1b9@kernel.org>
 <2F07BE53-D6E5-4988-B1BD-84AD2A05DDA2@konsulko.se>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2F07BE53-D6E5-4988-B1BD-84AD2A05DDA2@konsulko.se>
X-Stat-Signature: gxqzpbj6c1f46xrfaejqcwg8mnac98yy
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 741F1140006
X-Rspam-User: 
X-HE-Tag: 1792493861-784505
X-HE-Meta: U2FsdGVkX19E5yigPD9z/fKew71UYlsnEk1jnUAX94IXzVp9c+AgwFjGj0nUxaakkITwiZAcwQ3XDdnQsg0nGoqSMsfZDyaLXVP2aoUkIAUrKyarcNzdAsHitZye9cA4RirDKMD4RappxuJoU9prQ/MXr+6OkIa+jB3JEAq9rNcdN8q2uPQIR3jsBEtp9wTd9DnT4YwjiljFBUAkXLYPrsEFak4B09EI6iKd6PjrzekLr4MKnFMWRj2Fy8fm8OQXxicKXySlu+dPW4XTqE6fY/+S3vMkt44irN7vGHpE8E7bPLXTY4nW1YaHJZC21vpuCW688MUnHqz2mUT2/raQPpiYj7Mj8xQ8dTn2v7l85TtWNwlDrq+qjbKyxEzLOgwGkQ6sCBNC2y++bKiXrl0TkpTLBJJ9fN8F8k62zNx5LG2QlZkyS/3GxHsN1KH68craLFSUFOa4NDhyZ84e/FWvj2sh095Jgu2O2o98W3bWmQ6v+OHuzZWnEUmOMEsjzifHDxNiAY7IjHZgcTmRP8xG9HUBWDv5NQk+9bqwEEOU84Il3Bh+TD3jWISjaxprX3/cC+mEC/M1sfksv6ZPM8odtVRcta8FdqnlRBFVZ7aHTE9HTWsiualQiQ6IbSaxLEiDs6N5amO3YeYOIcQ+6eNgt2LNJeKzhskPftZ6OMJ1FQNyqKraNF/nj31iI2ggT1+ek7SnqnpFR++WaMqfg9zSZnWMS6FimL1qZG5h3gSwcvZNnstOqwrWPkWOAFg7BHDpVTAbkIAUCvB1FY1LIMweVjK50TRrFoUm0phngTSdkAF7FhgnE+ltLfyUMP3dhF8SPmEslupQQ3qHvQ3i6ojaSyRmmzpNhLnlbBXx1ipQCYFmx8AYM1gfa1LCjn7eSEIS4bNYuUMBGEhN1lNSzJ7OQhmj7qqU5VS4hFBOFGRZWXZu41e6obEAK1tPAd9m+0nGnVwB3FcrApBOh+tTtHj
 pOS98Ayu
 sRg1WkoO9AJ1B5Ui8ZqPkMYtI0cna80Ldbus59H1eQVKI51ufXtkI+z4bfWL9LZ7bBjNH7W1ADyzLbzMcTHQQoJZPVAq6S9YBwz7FH7Byu6EY6OPDx8DhN1l5VbZ7wblUqdVPVS7JY0JA7OxUt+32KIb5Kl/aS0sqxX+1oF58hEWjeJZsagiWXN1BtgcfW60wqti4+0RSjyVM/8tWCoyIHJTyijzLWj35YLFBCes6Chk9RlBI/dj+50ed4kGMBUg/lcfxZSQyLSEM32YT+mKAQkFgrr6pGwO2yDjLZ5A5GwanLFE2T5cLxqSYSSTRwyfH3f/JU/PTB4A23BCLejulZhgp1//FV0hR2c0J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 12:50:38PM +0200, Vitaly Wool wrote:
> 
> 
> > On Oct 20, 2026, at 10:27 AM, Vlastimil Babka (SUSE) <vbabka@kernel.org> wrote:
> > 
> > On 10/19/26 08:45, Vitaly Wool wrote:
> >> 
> >> 
> >>> On Oct 18, 2026, at 6:15 PM, Harry Yoo <harry@kernel.org> wrote:
> >>> 
> >>> On Sun, Oct 18, 2026 at 06:03:15PM +0200, Vitaly Wool wrote:
> >>>>>> How about we take my patch [1] instead since
> >>>>>> it isn't prone to this bug and is a nice optimization to the existing
> >>>>>> mempool_resize() at the same time?
> >>>>> 
> >>>>> It is not a good idea to squeeze a bug fix and an optimization
> >>>>> into one patch.
> >>>> 
> >>>> Generally speaking, yes. But that patch had been submitted before the fix
> >>>> popped up, so there was no sqeezing per se.
> >>> 
> >>> I mean the patch you've submitted does two things (wihch is not good).
> >>> 
> >>> It should be split into two patches that 1) fixes the bug and 2)
> >>> optimizes it.
> >> 
> >> I don’t think this is a fair statement. I would say that the patch I’ve
> >> submitted improves mempool_resize() to be rid of unnecessary
> >> reallocations and data copying, and that (improved) implementation is
> >> *not* prone to the race found in the previous version of this function.
> > 
> > But it makes the code more complex:
> > 
> > 2 files changed, 28 insertions(+), 16 deletions(-)
> > 
> > without an in-tree use case.
> 
> It does help bulk-zoned, e. g. on a device-mapper table change that grows the
> pool.

Please provide data, rather than a theory without data.

-- 
Cheers,
Harry / Hyeonggon

