Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E000CA5FE2
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 18:11:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96AB16B008C; Fri,  2 Oct 2026 14:11:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F57D6B0092; Fri,  2 Oct 2026 14:11:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80A346B0093; Fri,  2 Oct 2026 14:11:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5A5A76B008C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:11:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AFBF4120849
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 18:11:50 +0000 (UTC)
X-FDA: 85278479580.30.C833380
Received: from mail-wr2-f42.google.com (mail-wr2-f42.google.com [74.125.225.106])
	by imf06.hostedemail.com (Postfix) with ESMTP id C4D3C180005
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 18:11:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tBzPjxno;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.106 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790964708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UWCAH005lKYUXfe2OCMNLFgIqFtAt9HIoWhdWHE78ZE=;
	b=yQlB9XEzbOSGWYqrK3d1nIu6Zv+li1bBy6LSz76eAem5P8K0lu9CtZ3yEti6m3yPP2p64G
	o7IwKebujUTMc3m9tCjXx5bXDLPDiJDZv9TaMDj8awvThOcwO2/3P2BFzS8Otn5qqY/GEp
	3utJkqS10RCYnHv/rpSHTpaQGzNpt3E=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tBzPjxno;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.106 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790964708;
	b=s7adwt5wCdU+sEUl3RePsyBZrwsfEayCD8PrF0oUzD6Iejk4OLkGjjwEdo4wNdE6d/FRWS
	lsr+9fARKQymEbIQ4yr+Z/smVywn7RU8r5r8kJqzzrN6USP37BQLUVx1jH6DrYQ6ael9A7
	jVvZOnb76BRMhjWf3aQs4NkvEO9aEsY=
Received: by mail-wr2-f42.google.com with SMTP id ffacd0b85a97d-48b0622cc90so91181f8f.1
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 11:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790964707; x=1791569507; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UWCAH005lKYUXfe2OCMNLFgIqFtAt9HIoWhdWHE78ZE=;
        b=tBzPjxno4X/M46EyxlwY388OEbryV4JtF2Hc/09kvf+haAmcCVM3s3ik8Hb+CVnRwN
         6e0YAi3nyHkEQwBUbBdvhfxHg14Aa1xCq/cJB+zJrP1/Ug9xZrT/L670gpYZ6oIncnf4
         3EaFa1SleHyp62V+fTsjwPHZIBav/1sKNm8mRB3GoV/Iuvmzq5Hgv8AIwPd/FUEep4Ie
         YhpRdaBcGsJyq3xNL0L42S8Ey7wT+Zgge96jnMRzjM/AkfNJ9shSrftppjQO1Uo25bdh
         pruz0v97a7tL2zExS/VPD1Et3UZ9BJEJ4Dhd0ofX8Eyzxthx8gblIqZGnNcr2dZdUTCW
         HX8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790964707; x=1791569507;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UWCAH005lKYUXfe2OCMNLFgIqFtAt9HIoWhdWHE78ZE=;
        b=zGCv38m1227j3G+KuKZZWiGSDzUhO/oCEIRAAKKQspfJb1+Q0nJEZkMUEH0wwVZOPC
         yEpuI5vFCyLykNu3bvfXfAPoqnepL8T7Ik2pRW3qkvVkTkzMWNPieDq9DbC63F6+OpBv
         83MIFaDW6oor6WLoD+GFhiu9P14lSLz25EHfDGdq2rdTzBP5w11dMSUrdZGdgeqHsbCv
         5tzkKbJTzERlQ/lxwiB5mY6tm6rYXg6xp51PrWvv8ZV9E8yjKALCUcC+oFxrvSTOvF7n
         S+rW46ghPseSYmeJypFZPdB+dwXfPvsQqo5hFeJh2zbn/3pb1aSFhd7nWGbdgP3e5b+1
         LGcw==
X-Gm-Message-State: AFuF++nQJyu2dYyYURWMrM/Equ//kJcp55VnI95KWNpISar212GbmuNa
	JQAvzYVT5ujYcQ3yK72fqqKn+7oTPc1F+FNnSaZ/6xNsJ2dJBD0hvRgi37lT5WxO4Ow=
X-Gm-Gg: AYBFou2lT69TVN8LBNSJWZIlWmGCRzLiRcRiJLanlUeNBeQ909LNekn0VAxXoWa8bpu
	fHm/iKrgqhM7Yd/KkO/t6zCBUi58l0baOpeBfeyX34jPPkHBAatTbN6CXVYzPEpJj3E4VzQyuuG
	QvkJXiapB4K1IPDkbXjtOEMq4o3rynd8JhatPwZaLv6KjM7OZkbc1GqndcIwNdm7il5KH1HHk7e
	MAoJklu2+T2ckikrupH0OI0P0428svqVA+OqPTj+FXAZQwlmA9e7vIJMUtH2wG8sjFsG9PH++P1
	yPu0mLhXWQTRL1cVe4pHeeRMGViD7oQfLuocOLp0ppRtM5EXeugx70wW6+b56KRIVNdIilE71Yn
	Z2LAlwyz0G4OQtGF8qTHx5cPuX3eTTxMuS57zhYnMU/6tjJj6JLE0AHQ4kl7/Mji1GFDAlXksbw
	wlauP4tRbA8Ix7F1fYLXedfkhsOrhr+280kkECHxng4eQl63fqNAp74we3LfUSftWIedU=
X-Received: by 2002:a05:600c:1546:b0:4a0:1c43:3c04 with SMTP id 5b1f17b1804b1-4a02756e5edmr62895155e9.13.1790964707327;
        Fri, 02 Oct 2026 11:11:47 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c092:500::7:9b19])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a0280bfafasm104420865e9.8.2026.10.02.11.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 11:11:46 -0700 (PDT)
Date: Fri, 2 Oct 2026 14:11:45 -0400
From: Gregory Price <gourry@gourry.net>
To: Anton Gavriliuk <antosha20xx@gmail.com>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org
Subject: Re: Poor memory bandwidth performance between NUMA nodes
Message-ID: <ar_zftIk5caN-5uV@gourry-fedora-PF4VCD3F>
References: <CAAiJnjqz+OB+PmUQBENS8ThnWHSAFK=p3EA7KPsy5UeabQCn-A@mail.gmail.com>
 <ar_rPzLhXRSA0AfS@gourry-fedora-PF4VCD3F>
 <CAAiJnjo86U27YwFNSkQNvqxDyGMZomoqHToH3GqWuzqD2+V0Vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAiJnjo86U27YwFNSkQNvqxDyGMZomoqHToH3GqWuzqD2+V0Vg@mail.gmail.com>
X-Stat-Signature: xzijumcyg9jixbrek5feqoox9yzy1aog
X-Rspamd-Queue-Id: C4D3C180005
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790964708-552895
X-HE-Meta: U2FsdGVkX1+UjsQWXGGKL14zA3LhKifFvp7Swm1H/DKHuYdJyy60QGtUvHIm0T4PNHKpE4ji8AOEK+aVrLsEgWevqXJFhzJlhfAEprCKZ7C+BreKJk5f6w7/BRjWkV6kmNyln1P7rAN8orU+sRB9PTsXlCDZiRjky4J9EWds+A9xYQ7qFMmli4Hl3y6Ju99RWHM4s62x1TFDIru/+5pt+WQMza1+fx/9cn5jidqJWYwF7SONJu27NZB4QSRR1as4D927WPF1NISO70qOi1DPbOKLAuP/Pzr/vu1bC+ywsIqpWc1Q9sOAx7fC3gSxvAxf6ivb1+Uf+URCWXv/BlqDkQUEYZ9RyjYSxoiR2WfNQfEvZkcrtKMfE/b8c9VxSQpo3WQKhVgA+rXPJ0z0pTYPOi+h24a1t8yhgNEU4+9Nlary3M/f9Eyf9+54ouZ/P7uSWXdrMyXSrnexonBII2vYpRfuc/PxDfhdSMz4+AJlen5vMqnSwHhfHci3I8XJIPf4TzmiEiq8LEiEAn3IB/7+GrZcYIVwNj00X93vsLXAW668Rn9GtG2MEGUB5DawcwdLNS0DQYpwUNWLPOub3ud2C8hSerLy+58P6wvRDJDmPHST9VRA04EYv4hOAEr6gQcLgOW3P/tqU5YanY7CbCmz9tmJHYrfQhuMLa6OMMKJDGGDbHL8A6CSFEr95CrxbIzCtEk+clFW+okd/fA8RK2LFzG3ufIilpgJr3TBD6ALn6pFKaNJ0bUQdHCes1Vac/A35oCLn5x0LNdHoKWsZSxVm5EGaYuJ5aU4S70YxrHq9juE3JonFWwbyiHh2eyIXg0oK1NHUjct7Rr/1CvtMfiMZ0Uys8Kupp8SH/oEoLF2z7DONj1y+OxrW089jKhN1Kp0tvAgMs/bzMdpNmxhYSP9mVfS1Fo+yEUxsUiFMgQfD3clvC98WpMsSXzIwteJrZqevgRADQB2hxmcxLUlUZb
 rwY3q9N3
 WjtbcFW/Gydpwb4BIE10hsfUfONIHDBRoOKIOE8detdOA0oBtiIBBtKNheVzOgHjExcUajc9R8Jza0CyFesG6ZwdOaMJSshLc7OOpeU+7UCasTxREAsgBMZ8u9Mocid0MGOxXCZjOZrXSAqI0+TTIeqljeIR3jclBONjz5+BFtKpoaLHcDPn+jFCPenBx9tD62TpTdcdOk+KchqbNCYCeVs3eCZitBbE+wwk4CeXnTiIkqjBtEuM21PJOgUprYNPwufQRcFcldin/56qVawxNWfdfR/sbNCCK3r9D67oVvl/iuPAAisEFn7I5rY294jiL3ZKbJ+8deaAg/5vqve7fHDg5M9OEfNSKpVZhgw40GXnLHjpEY1go4xEVhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 09:01:27PM +0300, Anton Gavriliuk wrote:
> >  - Optane has like a 3x worse write bandwidth performance than read,
> >   so expect it to be significantly slower.
> 
> Single Optane DIMM (1st generation Apache Pass) has sequential write
> bandwidth ~2 GB/s
> But each of two namespaces is interleaved with 6 DIMMs.
> So I would expect sequential write bandwidth per namespace ~10+ GB/s,
> 6 times faster vs observed 1.4 GB/s.
> 
> Lastly I migrated (by migratepages command) Valkey pages between DRAM
> NUMA nodes 0 & 1, and got the same 1.5 GB/s with the same profiling.
>

I'm unfamiliar with Valkey, but you may want to ask how contended those
pages are if they're actually being used during migration time.

Do you get this same behavior when migrating the same amount of memory
allocated by a toy program? (i.e. known idle pages)

~Gregory

