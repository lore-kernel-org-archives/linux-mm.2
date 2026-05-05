Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9250FFF8855
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 15:52:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7DB06B0092; Tue,  5 May 2026 11:52:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2E396B0093; Tue,  5 May 2026 11:52:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D44816B00A3; Tue,  5 May 2026 11:52:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C14516B0092
	for <linux-mm@kvack.org>; Tue,  5 May 2026 11:52:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6FC0940532
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:52:09 +0000 (UTC)
X-FDA: 84733807578.04.26DFEC2
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf21.hostedemail.com (Postfix) with ESMTP id B79941C0004
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:52:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AfLDTa79;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777996327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wLO+oFX+VEmAp0NkxBY3iUrTp6rCqh1ePNe0pTi1JJ0=;
	b=PtV6etjt/aQCZ8RArxFKZIzLBSJloIu4WDR9i1EJs5i+US6VcEVFvWQnw3baVNribr4GXS
	WZknGHA47tTgvEUJFIPBbQECqv7R55IV/6fW5Mv67OhBKh1vawvgEwFBabf+vLCvW+lsv5
	LxCPjW2wuzTa/q9A3gf4hQgznUTb9Oc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AfLDTa79;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777996327; a=rsa-sha256;
	cv=none;
	b=ZCnD615Nmdwr0Vc/SAQnEk8/RH93CmMNG/ZpnLaxfZW4Ck+Z3cqU4L7ue56l90Buq32mAc
	hxXgbqysARLRcT/WuRDFfD5sgqGMDh/evOGUrdqoN4qpip4mucSQOsgPIRjSxcFThTpTG/
	ZOtiQQssmv0xp8Z8og95sILDW7DG/wI=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8eb5ad01402so581203285a.2
        for <linux-mm@kvack.org>; Tue, 05 May 2026 08:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1777996327; x=1778601127; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wLO+oFX+VEmAp0NkxBY3iUrTp6rCqh1ePNe0pTi1JJ0=;
        b=AfLDTa798P4DYUIh9frycseCJXYdySkAZK677TL8uZ49rDeWY+yNefq4UO1Q1K0Fiz
         0cOdJsturHUkI+Mt9jA4gtwnZfcJVxOkzY+aJtzP467EmZOnj2EzQnM6xIV/W7qjLRaB
         byEzaCVlwHMtcvZteBqTML/K/WfbpxAqToMWWBDyyKA8QbgYLtT9kQ+JMWJoE1W7/yLC
         4vEYcp2sL+e33wZQ0vhuqfFinS87JtFbEdohe02ga3u4G5QKY0CX3A0rvb5DuW54oA9z
         WQhpe5hgyrQJmvXshtoR5Lc3RE3lxADojU2paljuFmdK+iiQyRVC6m4zWejSLEwj2mrD
         HN1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777996327; x=1778601127;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wLO+oFX+VEmAp0NkxBY3iUrTp6rCqh1ePNe0pTi1JJ0=;
        b=T9ZPKcNzuLNJ8+xdUhrWQVdytntyPFyovYWLUY7TMUU7FBQcpeb2onYZvl8R+iK8xU
         FZncdwBVtry44K/Fi10YgsBqaGpa/0s00mjQfGzG1E93hxouc+OhK2/WtMdMwjEqRtqF
         GChCXiJcAtweVeQqI/8fh8bUDzEaumHaPTmSPZ4ok8DbUmEfP/gAblQ6RZXd835AImdi
         honWJeO3yc7vmqwGELR4AZqVppXzO1HQ8nge4ziE7C9S99QIABhon1Vkzx0jUePjkY5i
         lUmBv0XRawlXrsC+73D96N+m/CVgx8aYynKCfAkHqS+p2wS9IImO33H6k7PTf8yw9Ek8
         DKgg==
X-Gm-Message-State: AOJu0YwF/iHfIk1Tn9Ws9FFiYlfTzjlh9i/FoTJ0H88ildK+oDLuEjzO
	hlcNiHhLdCyLv927a8MeYx00V9Kxl140puDEhpGH91pX3r1hdi+izUiKrQK2MuWqD5k=
X-Gm-Gg: AeBDieslJzrytSylS9iIAlW0rVinaHDPCYpBTqbJ2TdWKU4Nx6+auIm6mfWEZ0ZVnCk
	vf2zTAXjiRjblhqjaCEFyP6e1AfKTtdndQy5jhtRxB3upkqxYKXy8z1WtbkkOVSP65yINOowY69
	tWiPGnI9Ci1QjQ/NaHy0Y5ZqEewynt8pT+uqlDfZ0aN5hhEa5nq1ejxZGzYq9GDadciuzdZfbO8
	XywFlJTm9dN8DckxrQh1QLqjLrNobrB3GRF3ABR8fKHpXvWZhz+SfDozhys6VU9CzTHNaxgU5Lm
	WPFzUekyydTd8kCbgGPwB7mfZeZo356Q9km4wiu5UxvopUV49O/GfKmSCHmqxh9Xmtd7VeZgFhj
	ucJfTb9RQsPtrV9NY5anlwSVLmEGbtV4Lv3QvX8U7jp2OovWD2+NOVs9yvxy42i3GhURbDx6m6E
	WwuSFGO4+pp26KWbAmDKLF9KKsHKHC4BO+eurZvmcYtGzSEvaMfnuM+8y+S6RlTPnpYUSHtapv
X-Received: by 2002:a05:620a:1981:b0:8f8:5905:8291 with SMTP id af79cd13be357-902e4cbc8c7mr616480185a.47.1777996326739;
        Tue, 05 May 2026 08:52:06 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8fc2c91fb3bsm1353612585a.41.2026.05.05.08.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 08:52:06 -0700 (PDT)
Date: Tue, 5 May 2026 15:52:05 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jeff Xu <jeffxu@google.com>, Kees Cook <kees@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Brendan Jackman <jackmanb@google.com>, Greg Thelen <gthelen@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] memfd: deny writeable mappings when implying SEAL_WRITE
Message-ID: <afoSC5KUhNwfyWBT@plex>
References: <20260505133922.797635-1-pratyush@kernel.org>
 <177799542165.635180.17809433268620237886.b4-ty@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177799542165.635180.17809433268620237886.b4-ty@soleen.com>
X-Stat-Signature: abnow7pmdqiqpb4ihcfay75h8amjnhmb
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B79941C0004
X-Rspam-User: 
X-HE-Tag: 1777996327-395513
X-HE-Meta: U2FsdGVkX18cq2rxPrvda1Y4dKLdwKH3Ot8KncjjdNyslXKiCyIbPgCMH9Sfk8vilTfC+SiLLToGuDvz1b9zGXtUeL+BG3CBRWLjJtHx/0HeNpXwg49E9B4DA2tg7Z41vwFt5cfn+Q4DioIN2T682A1t+XpgZLQpqhh+DmuYzmwe7Xd+xv1o6JSe5KrRPhzk76nsKpCAs/4N2y5QrYa4HRKhiB8gFUhubEg5ey4gaqGk58UG1AC07WXeDEAvGaSlqUZDkSt/fUOFMk1DHJTpZBkFRrFhVHLvT1cKCZM188dtdA3dPrKQn21IIwl6bdJsC9i7awsjvumSHUjEuNqAGtjM2g2B47oYonN6jjbFqwERJwlmeTHV7OTCReyZhGm4d22WRWLxDSkG1oiGwmwxg5PhCXMkhTBuGpWhoWrupdetTxA6yHSt9ziXvEiu/cwyknrWIgF/scP+wBp00ZGR2aED/MCK1XfG78TK+blhxPY5q4Oif9OKWKbM2L5MCA6oja+OOZUA0+sBh+9V17Dvi8GN6Z3oHlY7y5zvBPkKpXtbw1jDauakzbWhfT/kaDKlpnlaqR63NE9LYG+3cVUATImdYnptvQEwLgWoCdBfVTN5OeO0uxAG6jYu8+x/m62/oYRCfW/WaPEv0wPg/z3FUH3drPwSIcCpXZLDEOm1GNp4j56BC7Mq8ZlIaJxhoNa1h9JyVcI9HESuJj2+zny6mbUzrtc4/Lpdga08TaQUA6OVZPEsweLLcA6qDS5Nhsog7iBSqNLzTSSw59cAhrWmwHL2MY6uMzsU6CkM6DLPZ6vPe5h5qQtcW0P8UkKzB6jVNWn3bs4/RDyrg1+BsJ/FeD1yQ7zFP6klB77XmiMH9o818+zenLSfDIx1vW6kHwwCZZ/MWC+vHH0auqnVsJCUpoGAPFZBruFK5+h/gmkvBkuiwNLIO5sGXBbYRyKK6mxtLXt0upR67Zla/Akcly2
 5kTXRfIM
 R9yali1b0Bd61f5OABnhAMksEoNCWq8BczJRxpg+G00TMQeh8gzbArk9fo/tInz/vn4RMVxMf+p5gpjGgpONCEcBH+5/OADSb28jw6ZRnskV9kZur/CGDZ4x5Bvt0LZRUUCJBwk3ykWb08e1Qk8ubOHdZ9y0dxhVETmr2IGiYUof6vEweg0l2bPINKd83bYnBbCtxKCoeB79BJveCsN9qkAJCeozWSye/a7LbMizmu9oXsBOaDwtEBr0N4uhAD5zQgeTrxYqkxPRm5SFgtVJIv4Cw3gTvq6cJQZaWM0+kNzIGY/2ft+J2hiYkJ1eCDgieBe2/nDPIXu0ugk/Po2daMBPOAI5bFdLpoVlRmd1JqvyCTK9tyoYAaPMBI4PJpl76MOT3ecbvJBRkJqoXYYQrpVRx9AMvHXEwyNxXsjw21rEBjp6qGF2IFrBqg4+04aj2AYZ8uTUa0QBG4431do0DWaCwF5FGaUS9wiqnbhjMmIZfAhQZWZWeJMCvOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-05 15:37, Pasha Tatashin wrote:
> 
> On Tue, 05 May 2026 15:39:20 +0200, Pratyush Yadav wrote:
> > When SEAL_EXEC is added, SEAL_WRITE is implied to make W^X. But the
> > implied seal is set after the check that makes sure the memfd can not
> > have any writable mappings. This means one can use SEAL_EXEC to apply
> > SEAL_WRITE while having writeable mappings.
> > 
> > This breaks the contract that SEAL_WRITE provides and can be used by an
> > attacker to pass a memfd that appears to be write sealed but can still
> > be modified arbitrarily.
> > 
> > [...]
> 
> Applied, thanks!
> 
> [1/1] memfd: deny writeable mappings when implying SEAL_WRITE
>       commit: 73f496662a9848021e75742a69a3239ea850c3ee

^^^
Please ignore, this should be Applied to MM tree.

Pasha

> 
> Best regards,
> -- 
> Pasha Tatashin <pasha.tatashin@soleen.com>
> 

