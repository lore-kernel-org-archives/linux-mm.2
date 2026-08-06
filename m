Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F79EC5AC7C
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 17:40:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76C106B0093; Thu,  6 Aug 2026 13:40:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 743A36B0095; Thu,  6 Aug 2026 13:40:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 635C76B0096; Thu,  6 Aug 2026 13:40:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 45AEB6B0093
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:40:23 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D5D231A01A4
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:40:22 +0000 (UTC)
X-FDA: 85071558684.06.FE556AC
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf19.hostedemail.com (Postfix) with ESMTP id 100541A0010
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:40:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=I1aTjgYc;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.214.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786038021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Feo6lVP/vwGtNTDD9TuyJ016BERxdUgz54aHIgm9aPU=;
	b=BQhVZNMcRk8+t+Hso4OyCMh1B9jSWT+0EwdEqMd1xj+hmwqCvRC6RHWboRa42iEokoQRIN
	f0kIEWVNpDTP43H6T+i32m4J1z9EUkt7cC6ndLbZuWVvsn2dTSlGGDLmji//Zn/kdcQ4Ra
	Zta8IcYoOyiDvXWN1FlfZClhUIBu2uk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=I1aTjgYc;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.214.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786038021;
	b=nhVuXSXEYwUVRPevC28mIOmfX5oIs5daaU3Z2LFGqjHtIftgbXaXfMx3jHdWl+5o+TeFkF
	LL3Cg171DrgJ4FBp0ouN1IJeMuOTPUsMvNivi11FAWhKhWDQNfP0tq91TJ4XX3MnV1nNfA
	rXJVuyLrxSZo0CTpKkLiJNNhsFnbcM8=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cc7e86e7aeso27273515ad.2
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 10:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1786038020; x=1786642820; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Feo6lVP/vwGtNTDD9TuyJ016BERxdUgz54aHIgm9aPU=;
        b=I1aTjgYcyj6i7vDxibW70YOLwPdtzn1Jcsd6Ai0QjMIQHfKpSUcN9BYpo4QV8oKOxH
         hnf+hx8Ik9PKbQ3nf++96sVN8ZB9BkotM/OcLgd9RUDRutZMbJq3p6C5/bZXIqkPlkl8
         6SjOucdCxXrg7QCmazpbYunKbwjakJ432UDlRZLRjb7MGBdpi/t5Kz3yALDXStMrKzWe
         vbFxibZUHj/lZ4EZiW+dqQsup6QbF9bAXYymNSTh+tk+XlE2ihUZb/h225loEbWB87oG
         VhQCIrkY8H9HKbCupNRtmBct772NpMeDJN5ZpW0snIGfx789KJUO1IK9+vyOPqszwfSM
         n/ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786038020; x=1786642820;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Feo6lVP/vwGtNTDD9TuyJ016BERxdUgz54aHIgm9aPU=;
        b=aJ9Jrh2w85XPfeJMdeXmUOA43SkLw7Z2LMdteOminTq/uzEbyP5DYB6E10UmwOazMK
         NcABVCIxOVaOjucz/Pe//PceWEzlzR722DnSDFdBOfvO4xHkFpHE+0BLBEbcYSnvp8lT
         68TVIFZoB2KvU9oUSjz+r3wYifOLen1WkIpV/GGZPsuiwlmAWkXdAB96p+/0qSr/lxjf
         OdmHOoPoeDo7SZW497CDMxUHCnS5SKPIV1TOGnaaZPcyTO0XlXIwh6SAckc08E/bRZPK
         TugPsbyKsPHwIF67QbHdfLhG3OrZq9p8KRMAk/oAGnu7szDHHzaHGF8HQHCZLOucdSKj
         N/Sw==
X-Forwarded-Encrypted: i=1; AHgh+RoYJNU0WD85WMS6I7epw2RczFCXRfTen6O241xy/j+vQ6kMV6Q0BvcFztDRupMAL7NEB6U0GIEnnA==@kvack.org
X-Gm-Message-State: AOJu0YyQdE16Sb6ydTh3CkNQ6lwcJA5jCzddPex1a/YZInl5MUB2Toth
	lAL+y4jBGl44upguo6lSGLPG4035yjABkfOecl2sseA77oru7eAVB4sdfZMB3i0HJ2c=
X-Gm-Gg: AR+sD13Srs1mNeVb4tTkMfWUDZPOvd/vgpnwgoYNBDXUMEz/FOhlgnn8ODB9KTtkHdO
	rcTH0CQ+rBaIkqx2z/FgIeY+Tu8gTw3PpQsaE5pntUkMeGwa5MgnMkHkApElM14VJ8e+nvmlN+c
	wfJgk43ZIDGgneuzbg4GUT/f5Tda6Sbk4x9ltagL0sw8Lmx2/MDXDZWp+QAx1v9TSVkdB9SPeBp
	CSKBpUYEoQ9rYlA82YnpLluvpMdBa3Z8PxBp1hEuHSB+WBMtuGTZJQHycI6C9CPtghI62OTsvqb
	Cec6ZrYNDhzQaMtuzN+VgScv3rHs2fXiM04de8JTDxL7tmL5iv3DnoHt4kPhqFTpIgYZ8LGK2vN
	sGrm2g+FveZxf1l07AzM+rc7xf9DB+VFyVYo8oIcfFmqx9D5OEnuylMOMmBFkAAaaDiebEllH3O
	hXxgNFRHp1yZDLk2cXhr2pRmqwwXx7vFDlcBMRNmz5XL28GE57XE7N+Q==
X-Received: by 2002:a05:6a21:3117:b0:3b5:489c:7bb5 with SMTP id adf61e73a8af0-3cbadc97c22mr4782265637.28.1786038019967;
        Thu, 06 Aug 2026 10:40:19 -0700 (PDT)
Received: from fedora ([2607:fb91:201f:cebc:3a68:390a:144e:1b87])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31586401627sm35801147eec.10.2026.08.06.10.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 10:40:19 -0700 (PDT)
Date: Thu, 6 Aug 2026 12:40:16 -0500
From: Gregory Price <gourry@gourry.net>
To: Zi Yan <ziy@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: AI slop (was Re: [PATCH] mm/huge_memory: let special huge VMAs
 bypass the THP) policy check
Message-ID: <anTHABoAYVUn2XiH@fedora>
References: <20260805055544.1568534-1-clg@redhat.com>
 <0e52d0b4-064d-4602-8e7b-5744b05f24ea@kernel.org>
 <anSZpAjt84Pn7O_b@lucifer>
 <5b7e84f5-2007-458c-910f-7a6e1e3d3eab@redhat.com>
 <cf533fc1-db58-4c6b-a206-a8dac3fff391@kernel.org>
 <20260806164517.GA140051@nvidia.com>
 <anS6hcgMkEJocbDJ@lucifer>
 <10b07d00-57e5-499b-a136-f2148e870d9b@nvidia.com>
 <A403B054-108E-49E8-BFF6-BE5EF8E61C02@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A403B054-108E-49E8-BFF6-BE5EF8E61C02@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 100541A0010
X-Stat-Signature: po43bjqfmtfkbgi5b77h4b94b3poe6eo
X-HE-Tag: 1786038020-100249
X-HE-Meta: U2FsdGVkX1+SRA9pIKi8QfuNiMUm6qE99ky5KFf4psnUPY0e7JOhPMSNx8OZhcPGRfLqw+m+IpSH65ucdEYKuMR7LOuhZcP0bluezIM9KVaEyWh5yU2JvQEYJSkoygxpUl8KFs/4BNebGnGDTNJHR1GyPb4hD4lAViBpMAmbDMk1SB0Fe0ut5rDV7RCYkkCgdZeYSWEeV5dZ61mzf973BARDE4xTapOVfs/jWevuvjbM11nc604i8mOPIcAF3DkFuhylcsrvYryA6hBQbjO5bB5wjpc47+R7bkSn4MnKv2ZnAg66FccuYHq7HQBmT0Nvx/aDFUu+MzztyUYATKTbkqJJH1Wz8Ey0lRlPX6T2zZYpBQ/SMi1nfdDKjiX+2ZDcaFRL9mOt3UKB/0cCGPJN2uW3bqPePcITa1WihKnEKaLlG/8GMHJneGyI9g6/tSyh4NVGvbu263/cmIgF60NkLYxktwO15ouFFzrnfdL2IRnKD7N0b41cwOzki8oexGqThcnX4Qm0n4zyPEpW0dbGeMPzwI4HIC3t/z/fC2e8vZe9yvkAU8PJ/BbFrtXKxC7nOkfXj3jWm88Yydej6Yzm5s/afUoT2xEwBQpVsZe2XBMAs0UHtNeIUMbrvqv3te6EUzq5zATGpKktB9hNz4cuqmxFSnk1Ig+deeUTV9pvIY58peGnEWafZ3arxq8ZMPHkdJsEJET0a5EhPWunkL3PZUQGez6123ThDeyNENmtAr8ZHHTXc5A7Ly+DTbcjqNteW/xjMMqRLnWxwwjrTdOypgF7XKAuol7t4sLRJZsdat8jiceDGqtThOUyMh0dbktOmxLuS7U/0bUmIuNkPLIghhC5qEiFRGkhVxVYhzDMLeEGHBnYPMsOVfgA43Oi1E5+UxnhWvpL5dCRvxxLnk1hXMXXgIUKPYaeS6dTa3F71RWAZPoxVrnJVEHoyhIHRHeCIYVv8bhunzXAJ8M9Sr3
 KqvjN1jY
 a4NG+iJN3Bs2Q5gSEj3XcnYOz34BFBl5PAiv5ENt8TsW0DXgsYGIOQABeGuIzuQRh4fXmjQaPV9rFahZ+2If+eg6CAaMB4ucqYn+YvMpeqbpqN1c6bzULd6itIluCe1cu4+8C2LqoIV5s2k6y1nlOZl0rJ9X/YzXKpN0nAhhqvh6q56vm+l15M9MvbpsPwzOvUfjChqrUZgiUE/r/pk7lk24pXE3cRKn9Rc3s9KrLyN0NWqvWW3ky9qpIPp1FndeHsP4dEjGVBUEADQzt1clmU6i6Bmdl2AUbMeNQxfaYYSWC+43gHCNjhfw2KC7iHcrx/hqaX+fOtUB8TBxGchSEIVjLI5mVUXp1C9VDhdIG5bnxwHDeEOcFH2PWCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 01:08:15PM -0400, Zi Yan wrote:
> On 6 Aug 2026, at 13:05, John Hubbard wrote:
> 
> > And furthermore, that's not even a change in policy! Because traditionally,
> > that's how people started anyway: with small patches and patience. It's
> 
> Patience is the key. Seeing patches refreshed within a day is killing me.
>

some kind of 2-stage filtering mechanism maybe?

mm gets everything
mm-review is curated from mm to reduce noise

Maybe would have to leverage a model though to surface critical things.

Just an idea.

~Gregory

