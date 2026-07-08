Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D57FC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 13:17:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F79A6B0092; Wed,  8 Jul 2026 09:17:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A8FB6B0093; Wed,  8 Jul 2026 09:17:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 098176B0095; Wed,  8 Jul 2026 09:17:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD6586B0092
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:17:52 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4478A140153
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:17:52 +0000 (UTC)
X-FDA: 84965661984.23.E1FC287
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf21.hostedemail.com (Postfix) with ESMTP id 75A221C000E
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:17:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CbCFShmt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of thehajime@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783516670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j5RZEo+P8E5xC+3Aj9wmMlL0rGp1x8P/zFfWqOow7No=;
	b=csYyhB7y5nK7U5e72z4MCJ2eGUGaeXtioP2TIprySZNI1Xtwp+cQdq4OOwcFUfvlVAqzPt
	AG3nPWu6r/kVbcRl1Q9h17vgRddPDQRcrD/6cg84RZYr1u+U4sruIQ1bhxc4cMskOUM5tY
	19TOsK0QbSTh1s7LrRJam1/ey5AeAGU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CbCFShmt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of thehajime@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783516670;
	b=3Kxf1CjnsN04lW6Owz0JX/l2OY6gnonGBCJpteyVEEVCi+e8a6uaBcotHKSWmH+BJ1rwY1
	7z27AbCMYoWJ2ij6iT7ZXcv2XQfKxNUOK6ngybmIKxyBdOJWZl9FVhK8c4M6eyKsKMs7ab
	/0GSq5ghkAOjH3pz0VJuBNDhv/fWLx0=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-847d1e9db22so678870b3a.2
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 06:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783516669; x=1784121469; darn=kvack.org;
        h=mime-version:user-agent:references:in-reply-to:subject:cc:to:from
         :message-id:date:from:to:cc:subject:date:message-id:reply-to;
        bh=j5RZEo+P8E5xC+3Aj9wmMlL0rGp1x8P/zFfWqOow7No=;
        b=CbCFShmtBI6KpL4OUK+yAxcE1Auc49wUlmnXFn6DtHmR5dlb5sCBBIAcQA60VhlvG8
         q4qwlIcfr0uZWEpMVX9xpECZUGhcWP+IAKOE0ui/Hf43nzFHi/btCsUfYyrAaZoYFcQq
         WINC/eX9eO727899p5wffpPSyJO1f005Ye+wBhETML6BHmYgtdBaosFOIIN6MAo5alTe
         1jfN9os1S2NDJBwAi9c6CzdtfUzl1sQl+ncni2bEaU7CY+2TRbH7paUpzdaV9tdaFJ66
         J9uHfYbiyA67JUZbrSfh/VVRyQiRZtbTIX6+qn9n+5GX4Dyiom6EUXrtRD3ef2KFT66r
         Rthg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783516669; x=1784121469;
        h=mime-version:user-agent:references:in-reply-to:subject:cc:to:from
         :message-id:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j5RZEo+P8E5xC+3Aj9wmMlL0rGp1x8P/zFfWqOow7No=;
        b=TRiapSyU0iIbajXOYUdY0t6Uoh2W2Fs3II8/cUrOf760LA6x1oNBTTrNLpOWSZLCyS
         Tj0/v6d/HEEdBLSACFm7Fbh2SwKodRp7/p+CJUntFv6EMHmojP4zz92QF9hHfT+Us50Q
         ebBpfoqqzhM6lCVynDKFnJm2UtouY5JqP3eJqFPbiogwKgUOcgFowHn7NKsA+CFq1R5B
         fUkUceKAR/8y8Ovi2lpWUSvwT7soWZ1kDFVYrsGNLPthJyF6eG19T1HeLGWihUvEeIih
         UrmsjNY8/ZywfAm0R3djQDovfwWKSrKp89sr2bHM1ilq0RbzWjgj5PnmQABlw1aNiAq+
         Lj2w==
X-Forwarded-Encrypted: i=1; AHgh+Rph9ywF4jMehE5G7mIxdZALfPnnRijBkGjbKJ3GgTPbHqLT3kHw6txBb2+VEeHE5Y596aahKnBThw==@kvack.org
X-Gm-Message-State: AOJu0YyOfTByxOj5tCb/zzk3/JOAFnnAye1GPSuqsRMNib4TqT/hWPvf
	46y+Q4xnMhRzvR3iu+YutZ5dJ3NPt8nuYH8CdDkCdwWEw1f+RrgelQab
X-Gm-Gg: AfdE7cnqxWxWNcXcDEBAWHd2xU6vWHAir3qhXmhaOXBbNZ5e5Sy+R0XrSzf4NgdkaCK
	Opatu7zRV8fJ2e6St8aRkt0pGWzL7nTC3p7vigKXKyYsAq0drE/jd4T6sJ90rz+PSyi31go1uRT
	rDYm8JQzxNLH1LEGrKvghpt1UuaFagt2pb9uVJi6rwHwlRq+6Y1omA1A0ZiwhZEs5yGg7nuMDlN
	bYH1G6oRSj8Jwe00jiXFf8cPYrirCSZl2uQ7Sn3ci9Xg3KBcaBkX4XaYHuNEu1zCp080C6O9Vfp
	grXWOK0XrlyXK//6lfQ3l++480QHP11ig3b4x5tJM6j72y11CIwiFn+DUM0s1OviDPQ2DtNYPVR
	DBV/Atmot4FrMHgaP2lJxVDvUeXTsfvb4GoUxsf4nOwZKeCcfCB9uhe4we0EqLpQM7oOV7BcCYw
	Y/UH4ir5b7eEptlBT+4QnKrlhZld41JqW8h+zU83uNuW5t/K7UxffbPssDdoxLFjcrmG/5HxdkD
	bA5ZHa8RD9rLacyEc4lzzYvxZONNdSxSw==
X-Received: by 2002:a05:6a00:99d:b0:842:672e:7b5d with SMTP id d2e1a72fcca58-8484302405bmr2286640b3a.17.1783516669248;
        Wed, 08 Jul 2026 06:17:49 -0700 (PDT)
Received: from mars.local.gmail.com (221x241x217x81.ap221.ftth.ucom.ne.jp. [221.241.217.81])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6b9e12csm7083750b3a.21.2026.07.08.06.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 06:17:48 -0700 (PDT)
Date: Wed, 08 Jul 2026 22:17:46 +0900
Message-ID: <m2jyr5tybp.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: nommu: point to the write iterator upon split_vma
In-Reply-To: <20260705152708.582fd8d87561f600da23c0a7@linux-foundation.org>
References: <20260702012546.665383-1-thehajime@gmail.com>
	<20260705152708.582fd8d87561f600da23c0a7@linux-foundation.org>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 75A221C000E
X-Stat-Signature: qsadnxjmrhukg6dnjd9uorbejccrsza4
X-HE-Tag: 1783516670-821543
X-HE-Meta: U2FsdGVkX1/Cxwmd+VVyuowm9xwYglg4CBZifzdn881uyDvTeyXOmPWYCNSiOf32QU0lv90c8AfnAAL3+5LmFkAuxV+bSxXAcgF7a8nJG2H0I8hJsme8hPSeee43r/dlmWA6+LDXu9CnCcj8nZFyhxX5h8Y4TJLlsVJT+04/TxS+Yw1ZVv4KssEv0J/E+/GGxFcEIjiRXXGlbGz7ur0g3Vn8iZ2CkxW50EA2tumCtDkC4DJ3PfmwTiwRGPsOY/cyA0eP6VstsWAdumvJPOZO6KEbeBF0U+o+wDpsD6sFw+t68iVLy1KhTPZmewkp+WvmxRmzO72fhgzBQvXBFh8fHUqW0R8aRr4Kt66M1UeFVIU6Nt10CwMm0GKgW+hjBN1m3WpP1avHA9gMX1zgOxFKqgUTlaBCv5IzYe//m8FHwSKh6vNl8lASZcBvxaksLFW7igeLeLlpM90WgB+8bxYmPxaomGvrx/BFKooyTrclTlulEGNhYsym9t+/8EZ0bdmKMEY7qM/lTtQwAq7zg6DEGky1+Xd3eppiOZH+Ah70okivPgA1WBypXUU3Eg81F/a5mQDo78A51zvN8Hq+mR0NeFjwX6kQuQxGViUhftdhbK0iwhK1MMGfR54glu1Lul9FLPtguJZiuw6dIrEQCZVptQKfIoik2eh9WDT+E+EkM6mj+THmFGr9y7idj9bk9buRwz9Y/cGFs4LuUtI7gLEIWAZ5NkL3nu9ebXApkn3fUgbyOCYypapKWg/Xe6+PvneaYdmmvAayR6P+VQ42HqFylZrH3FR7w5Lpeq0434ZntxJhTFRKh/S05SIJpNzWOQyBybZCWMHHWs+ksbsPK1fdYq6508nh48i5mW6jjhi/GFScRur3vjcQ0i8dT4rLEL85yBcvZ0uK0Zk1Rn7KKX+yQifLSz+h4pUn3vhKhiiDLhBr7AlfZvFyRMO6wlq0FX6PcuIY1iykYnTPlg9u21K
 N7geONFW
 2Cd/yT7gY56jQzSi6tRfs8ua5c+Z3FJOAwulI3j42hDC8u5jz1jl3XegiwwxVc7UjQKF/+VOzbp++O10qLnTQ+612b1kz3mG0QnEo1jUm/tFiLHc8kg01PJ6MuWnOEsiuwEI4EKZ1aCqbIDKw6W3kO5jxI7O4SKdEUDIFUpKk2p9uBM3QE44Mp7KidQ0j/zQffXxsXdnwvFL7x9O8C9H+rAldo4Qlugv9/AmUkkLHXLL8taqA2xf2NAuxHMdvE+ZHpO5m/nbbxHhHkEqGDFihWupF64wBaS1neTBx8QljFT62Nd2mUfZ4FvJntciHzU5h2nOB635XJBxRNLSQ8qmMokkzRS+5EgxvKM+LK6OFmznu3Gcfd/aI/CLGIVftR2q9hHIlOBC9AQ6yQGMGQu5yNyczffbp9+BxqEMCLmC2YFY5iHQhlmGUpDyDqk27wnV83TWhat5hLlGTJtoHBpxUgifjaPL3g2x8+mZu+wDdmvS1Oa0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, 06 Jul 2026 07:27:08 +0900,
Andrew Morton wrote:

> 
> Thanks.  Unfortunately we aren't very diligent about the nommu code
> (are we?).   Perhaps appropriately - clearly this code doesn't get used a
> lot.
> 
> It appears that AI review has found another issue in there:
> 	https://sashiko.dev/#/patchset/20260702012546.665383-1-thehajime@gmail.com

I will also look at this.

-- Hajime


