Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41E4DCD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 11:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2AF86B00AE; Mon, 11 May 2026 07:54:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A02656B00B5; Mon, 11 May 2026 07:54:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F1596B00B6; Mon, 11 May 2026 07:54:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 78F4D6B00B5
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:54:07 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3937816070B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:54:07 +0000 (UTC)
X-FDA: 84754980534.12.01C1A5D
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf17.hostedemail.com (Postfix) with ESMTP id 466AC40015
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:54:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nwdNbTA+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3W8MBaggKCEAlcemocpdiqqing.eqonkpwz-oomxcem.qti@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3W8MBaggKCEAlcemocpdiqqing.eqonkpwz-oomxcem.qti@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778500445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cza4Z/lwAM7MKAd11Ut5nmuc/HelVwrVJ6eLmm0U7zA=;
	b=tqEzHPwxaSJe0XBNftYw1EDzs7uVBrtYmcfx/MHLbJfVhSWtvPlxR3TgT+330chCceUnEn
	O9x1mqG6akToWp2TjhtExx0ubMUzTqeBTuQDkbrcoT2jmkMWTgpFLm3wRrczsBEKG0WlNm
	zNwIjxknzpz7APO9+En3olp9xdxW8g4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778500445; a=rsa-sha256;
	cv=none;
	b=ikdnuDYLCh+S15WNRxpPVH7fvzfTFR+dcf+0wIsV/lIfjMZ2Q6M1RcbFfk0eqVxceUbvO8
	Gr3z5WuqdwKzoDr/CePYYJZ5Lpm/sfsKaQrzLN+T5SQuY7/4B6O9nBveQcKcMopQWpgrew
	DzGWe4msiN3iIjR3m4NJgE5JRvO23Vg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nwdNbTA+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3W8MBaggKCEAlcemocpdiqqing.eqonkpwz-oomxcem.qti@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3W8MBaggKCEAlcemocpdiqqing.eqonkpwz-oomxcem.qti@flex--jackmanb.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-488f973ddfeso30295085e9.3
        for <linux-mm@kvack.org>; Mon, 11 May 2026 04:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778500444; x=1779105244; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cza4Z/lwAM7MKAd11Ut5nmuc/HelVwrVJ6eLmm0U7zA=;
        b=nwdNbTA+hrOPC46UBOclrAGsYgCUub7KXgK8VVKEbm9ClFNAu/jGDtzqpm15scsHTJ
         HsP/EoBZextaskpmfC3Fj5utloqiBnV2r0nExifDfJL+7hFIe0A2Hmk5XsgwSFph85/9
         YYisBemf2BY+bsgJ7dIUw2vogn3Ph/uCIvkdEnWG3mB17d2OhM+PmO3hXFgCKDrpkyh0
         Lzx5pCYhnPfHXFkgdIIGVXS5fmJSxordTutFrVgxjeYpK3d36zPbiUrh6DxPgIoo5+Pu
         MMgku2r09DN4ky81HQppHuc2N1BXeDz61dPPhlN919AsZL7c//iszkD/zGEwJMRq7OXH
         dfvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778500444; x=1779105244;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cza4Z/lwAM7MKAd11Ut5nmuc/HelVwrVJ6eLmm0U7zA=;
        b=c83CGeZbQ1sD3RMToTfUtIKqjdYceYCsydJESZU57WlUFl0JFV6yRNXvq3eh9N7ef4
         UntXwCsKk7pM2B4/MB+/RHmknnlR9Z+N3T1jPBdEMsPJ5uqaSDuHPch6YcgF+4mGdCsP
         HNPNnDo9SDjhiHwJhnQoNqA1QVogqg4/NLFcVBD2risSgfT+of8xbQ0XhpQlftHVNv5z
         bNpPrK2jF5r9J4egKLcrZ3wX5sOhHsDAIojus7rIiZJ1HYm5WbOpbbqQ1jxkXZzUkbQk
         pcC9Vjd1ZpjnUl/cdNFWIZNMGAKf7AyM107K4WTcGmlHwWng7h031/HkUeLbAzni6psR
         /Ysg==
X-Gm-Message-State: AOJu0YycAGA7A93g+7ZcGBZmj6PAacMj68+RP+J8DRDVXPqQgWE1//+D
	nlnaC602vaCHytQ3kWX7JB5XEPYlY9dYaLdWVeGlKae/eYk+F6/sICyv9NwJmKLNru0MyVR5OtO
	iZa+qICCNWVVn7w==
X-Received: from wmbdt12.prod.google.com ([2002:a05:600c:630c:b0:488:b96e:9939])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a30d:b0:488:a2ac:a334 with SMTP id 5b1f17b1804b1-48e51e08228mr260139065e9.3.1778500443660;
 Mon, 11 May 2026 04:54:03 -0700 (PDT)
Date: Mon, 11 May 2026 11:54:02 +0000
In-Reply-To: <20260219175113.618562-1-jackmanb@google.com>
Mime-Version: 1.0
References: <20260219175113.618562-1-jackmanb@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DIFTSG6BV7GO.1FZQ3YQF27KTG@google.com>
Subject: Re: [LSF/MM/BPF TOPIC] A pagetable library for the kernel?
From: Brendan Jackman <jackmanb@google.com>
To: Brendan Jackman <jackmanb@google.com>, <lsf-pc@lists.linux-foundation.org>
Cc: <linux-mm@kvack.org>, <rppt@kernel.org>, <owner-linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 466AC40015
X-Rspamd-Server: rspam04
X-Stat-Signature: 35iz957s9aninqou6x398iurntx5cmt4
X-HE-Tag: 1778500445-162176
X-HE-Meta: U2FsdGVkX1/WY1MMjo0772N4KsSOKuc+oMvz7R0eTfYMSBmYbA2hwHtVZAi2pp5OnU6/qLpKM2e/gDAKsiLbjGZF3AHXwyZhRKg1EP6/Vot3XHzFxsaxROEsCLiH3TX7icZSo3T8qXdbP9iNbPIrlt4wMPMXUp6Y1q580Q6QHmNhsIlR8zgZsfYzjKhAwFgSPEJgSGVYHod5TjQ5IJ3Z6991M7WvqcTXvTKiGxfbOi9KP5fDEGUxMIZ7dMbOdprquAE69MOs4Mmn8NswIy0aWfJRIYtAs3DKdgkSs3dpG8jMOc1aavNUobmQyzeJroLAwk5kqj5mbtjdNf4b2ydIw3ohzavzaSSuA5zIn8b1xPE/M+odd1ZBRFRe0zh+DClU0DgHfKnS6qQh9HflxZl8jppo6hn5xTLDddAYqgVwmwvqxsU9HmUx8wgu0rjR5E2UAt2lISReEc7WeVr5lHvRaoN/QTIXc8rwX26D3eKJ02mBbEUEBYF9rKgzhjUsFB97RuEHHP0oglWLjZC8M9li7gI2Ap4EUb30RGe4iTg7huiJHlHS/seSCcfmEKbtxe7dmhm9qrNfFVksL1+ix8TDDSUFiiiPIDNSL8J0qjg+zTUiUrcW+Z+caBmP0NkZjbxLM2/YMIwC50DA5k3MOW7hhu7sN65sLKLi72Sr1lS9J0z01jCWIZy06iPjwz2q/tzJrd0gnQGmemtVdkZz9vrNrVoX86ywTtnsHr7j4cMA+hxnizhqWN1fkG1SikNfaFzaRXDcqNzofjX8Xiz8EWfam1pVoEjBUvxc6Qy4hiTZArLn9cn7bdCj5W7QPURe/IPkXIsnR8lF4ECXxAHAnPELraRuRacz4IwD3LFkvVFYlClRq4sqZ5Ja41Kx+jjO9PeW4c3bcYE1ZupiLoQVND6AynDodkN8b7X3l/A9vK/vyZaiQTsal2DAaMa4tgSJMeidBzLu24vcmi+PH5OGgd/
 SK/NPa6i
 irYiVNzpafbNPPtX5njas9QZTdemPzKB+MusyfF/Pzk4nG2KqTumiXRfXS5uo7nePQyLUOgHveasr3x1tvGgp16/FszMqotqPTa4NahG2QKVkA4ohs5XeKdA+fBubOFgNmw1kVV212FBVTSO8svMCNDk9cVKKmUQcAuQZ1PVtFqSiSFVVNZjRu+OOg3UMf1OjCgqbS20dgv9je3JBy8tYT7q2Zz7NuUVjva08KV+R/7AdObnv8mrIxHXWI5UgyFRAKzwE/FirS+QS9kxfD0T1gc8YVzRFfl9k1S7XGb1xYyY8hd+kOKQjCkZufmU595BmDGqjBdirsX0sGwjKjHIHmxinXGA6+Wp1h2yhAi2MdSYF5KQlu5UbjZi1jYA3+dYzqmvw4wgjxkLx1lA4IQHuoysS6hkUzWYRjZl3s1UnMNUztgCYQTg+2VuG3Ov158HUydjkK+KjyaczFFyoRDwv8IWyUGfHngdngLRqJgR/KIztMnjLDHyBKPip7Z1ere7fb+sSL4RNRSPARTBqs7sfHwXhW6bwtd0jwSPn1AWFjfRYkIx9mjcaqJ1X7poXEjpD8R4fa6k57RoB1CNnDXghEBSjFC5aAF9OB1lmBpua3uSs7vxriIttBR0vud1Jei8TMuQRcuLLTIz9/q0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Slides: https://docs.google.com/presentation/d/1zcqEqRrpPR_K8LwcNIH8XpL7mk7mMcI_N1jJ67OWpYA/edit?slide=id.p#slide=id.p

Recap: We did not actually get onto the topic described in the proposal
at all! This was partly because while preparing for the session I began
to realise I don't think a grand vision is sensible here, instead I
think we just want to take incremental steps to share code in a small
number of reasonably obvious cases. Therefore, I allowed side
discussions to run on as long as they needed to, since I think they were
actually more interesting than the "real" topic.

I think these were the most important points of discussion:

1. This has a certain amount of similarity with Gregory Price's proposal
   [1] formerly known as "private memory". 

   I think the most important overlap was that both of our proposals
   involve adding GFP flags which is quite unpopular.

2. I proposed that in order to avoid __GFP_UNMAPPED, I would explore
   trying to make the unmapped allocation feature "private" to the page
   cache, giving it some sort of "side channel" to the allocator
   without exposing a dangerous API or consuming a GFP bit. 

   People didn't seem too offended by that idea so I do plan to pursue
   this, although it's still quite a vague proposition.

3. Although there are issues with the interfaces, the core page_alloc.c
   code is in a reviewable shape and I would LOVE to get some review of
   that. The relevant patch is here: [2]
   https://lore.kernel.org/all/20260320-page_alloc-unmapped-v2-19-28bf1bd54f41@google.com/
   (also the subsequent patch to add __GFP_ZERO support).

Also, from the hallway track: I am sorry that "mermap" looks like
"mremap"! I only noticed this after I had already sent proposals using
the new name. But, I'm not gonna propose a _third_ name for this thing
(I originally called it "ephmap" but this is extremely confusing when
vocalised), but I'm happy to return to the subject when all the
technical challenges are settled and we're talking about actually merging
commits.

[1] https://lore.kernel.org/all/af9i7dkNvGGxPHzu@gourry-fedora-PF4VCD3F/

