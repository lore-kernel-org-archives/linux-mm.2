Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C8F5CD4F4B
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 18:37:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2A296B0099; Sun, 17 May 2026 14:37:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDA826B009B; Sun, 17 May 2026 14:37:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC9C26B009D; Sun, 17 May 2026 14:37:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AA4746B0099
	for <linux-mm@kvack.org>; Sun, 17 May 2026 14:37:22 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 71C13A06CD
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:37:22 +0000 (UTC)
X-FDA: 84777769524.18.C937964
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id 92213C0008
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:37:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NzLfJwkv;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779043040; a=rsa-sha256;
	cv=none;
	b=zW2JLissBykQtrWdsJghcjKumq/b2Lrj1aWTutyFnaGkwbAeZCmKLjMMunVdUKdvxN8TxT
	Q+qG2oMkP1ESNJi+SOXM8sTM3E6UDqFCJGq6kqrLyu7IEGlUs6Vaee0lPMal/s1YK8ipP3
	85W06SFUZkUEKvY9O93+ylzhEGcQ+Us=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NzLfJwkv;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779043040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qSvR3pUa7/2OkCu/xeQoYakjb0Jx3U+q13XWt8GPix0=;
	b=Jud9UuT1kBavO9eHwYFlP0IL1SG0HzBKbyjyRPk3JS1aWp7d5iH6E0rCh6qPYe22PovF+Y
	l65WZBKo072fErL66vng0dhkzs/fjLqBBB0cf4zTK+HASPeBEicqT1qRwkgU5x/5J2pQj1
	UDrYCMDALq0tasqsZTKdE2zxIpFrSN8=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-910f734b477so210914085a.0
        for <linux-mm@kvack.org>; Sun, 17 May 2026 11:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1779043039; x=1779647839; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qSvR3pUa7/2OkCu/xeQoYakjb0Jx3U+q13XWt8GPix0=;
        b=NzLfJwkvofKCiG5ANRENpsED+/0c5vSk6C9JwRtNaAW+ROv7aoeE2+I2IXJxbnP6ZP
         awV/O82tOqtQ+lqujFKBL3fOyCErAVndtsZqIZtA0j4Wu1+o1HNwdDDDbFq1rjcbkmD+
         iWy7HsLZTrZkHU3IfUTi8+yud4rqPpU01fr/qZPNRK6CSBtAPobgx1aZFWmIb9gcGxWg
         CgPPZP8kbfzYTVub29OxyQPZ6aTnqrPlL3x5Z3ayqKH1tMv95uq8iDZNLx1XuQ7KZYRT
         q4h9UUWxcqFIthIX3Vc5y8QahSeC+qoKreYVNwCuFkXzs2me6hPW1nLwSGWOwhoCOFsu
         FMbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779043039; x=1779647839;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qSvR3pUa7/2OkCu/xeQoYakjb0Jx3U+q13XWt8GPix0=;
        b=frN9pyyGQljzv9Sg7+o9egEVXCn0cxFuTzV6N7QWNR1+qhZbiHCRDm0RqaEEbl/oCF
         ytXi7frHINK/to6+LuBDukKGjjo730mThcSrRb6JuO1KVF2ujkgAo5bmsbDXMkYWFmdC
         ECaUo6bgg8TNCMruX5+gLB87JluwrMlj/AYEWMeZE3oK5N3mn61tu7IntnAUQeIAQasS
         tI0YCOovdyX5ha3pOwE5H2Dkh3MAyGJC28jagvYRSAxOZbIDhTXHFMXYy805itWoP9fG
         FSc/2kj15JAfW2Orb/Jhi4X7Hkkhgxoz49t5Wr7JYnLJrMoXq8oZrbXu+aKW/utglCIn
         1N/Q==
X-Forwarded-Encrypted: i=1; AFNElJ+A9KXLt2KkJ1nD7E9o7VQDLX5qSpL84IXJBFZV7EOdIwobhJQHEovtKMDe04guKGedL5kh3LWKwQ==@kvack.org
X-Gm-Message-State: AOJu0YwPdAT1iHVf0grwIcCoSFDbOqTcePt9H++eKSARTmgLU/vGSZOO
	/oLa+ghz+f3t6ddDl6E0eHmNLl0NEqa82DJFWtZG0QzyvVbEhpkl+O/D4y9EHejWUL4=
X-Gm-Gg: Acq92OGNLHZIL77y7T2XynC9qv06EIsIWycCkz7Iq51h4GPc2ISy5/DyFZqHgea4tUJ
	NQgBqKpguGP49oz5Y9W/jxb4nbB2JLjCWu6IxRmDz3cP61GxC6u4Fx2ZFUp/qRQRqRve6SO0Ysu
	vscIH1sJ3WVHzXbxHSzatzMsedxBdbSFAnh04VI9iwpOVG0xWl9Bj6cujGmLjoCXsaW1TZxPNM4
	/BCsdHLZn1ITgAc/JxgJk0+G0d8eHVO3nCKMM6DqvpS0g4Ld6eOGndyp87Tk6/xy9nnxNFuBeXy
	zqgpMkwj1L7r3+qS+2UfTMY26X+f1iB4/Gqgr7u6KAvfc9ZoJmr/1UvOgWFLWJixJWHfKEXf27e
	lal4KyGpmjt5qykk8fp+OV3yYQVlpUvz/Gxg50nRpa/FD1UNwmjiVnpN/Xh5TwHp6tgLnca1Vol
	b3PwslfkY5+lw0THnGwpaS+yJuZcEP6Mpu/zyAeRlOEKsWmEmB1Cc=
X-Received: by 2002:a05:620a:258d:b0:8cf:c513:349c with SMTP id af79cd13be357-911cdd431f7mr1842710185a.9.1779043039579;
        Sun, 17 May 2026 11:37:19 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910ba36e1acsm1238613585a.3.2026.05.17.11.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 11:37:19 -0700 (PDT)
Date: Sun, 17 May 2026 18:37:18 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	linux-kselftest@vger.kernel.org, shuah@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	corbet@lwn.net, dmatlack@google.com, kexec@lists.infradead.org, 
	pratyush@kernel.org, skhawaja@google.com, graf@amazon.com
Subject: Re: [PATCH v2 02/10] liveupdate: Extract luo_file_deserialize_one
 helper
Message-ID: <agoKzw8mR21K7cCJ@plex>
References: <20260514222628.931312-1-pasha.tatashin@soleen.com>
 <20260514222628.931312-3-pasha.tatashin@soleen.com>
 <agn50TRvhDpGm_9v@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agn50TRvhDpGm_9v@kernel.org>
X-Stat-Signature: k37ickodw5rah9cj81yditpwripgkt49
X-Rspam-User: 
X-Rspamd-Queue-Id: 92213C0008
X-Rspamd-Server: rspam07
X-HE-Tag: 1779043040-239122
X-HE-Meta: U2FsdGVkX18gh/z3amlWTWePQNcqzVC5xWdVvgvkDI4P5z3+Ef9bhdVZmgK2yX06oPgOsdZQ+WRWrCRctNYuix6L7tOQokAiwKYIFXWswHwHEOql1D9kpHh7HIoAmLJmFEDiexUS6/9YB+x3HuX6UOZ9vORThwF8tYnOnaqveKUXo/xPUq8rLfX4VPEDOvq8L40Zd6htqIhp35P/txb2b2SdwrAPWzMZhluHv8nK9gX0pN/zkKQSNFaB7IRqZlVh7STCV37bcMWzCW4Atr7CkK0lrs7t99eIBXNCoBqNP8bbrBa2QIqDxyyDjx2cXyfLU4ca09J39CWt8UDNaqC4IxQrqPpdMenkT1akv2p3dMN8ygffOK6iLHDDiBVE+8+/OQAnDQ60+iA9P8vMgzkXz2YGJQJaw1k5/l0Vza6zOqU1LlNCnirUDJhgot6eoGdKUEZ2BVIWzVML7ti2EwI12uXYvWQyhuVVtgRJjnB8EuZcJaes22DNWZDglRf00UPSpev6qD9sj5RdPVr5wzDTFYVUZgmKa748aE9A4B5zlY1Qs6Cu4PAY/U0GZAmeYQLBeSBxXWBPBSu0iSueyRTr2kN+KO+rpKmFWS0UwiDPWjdtSkIa94uyw1A+zYGBstVN4AaOPnLUjFHdOmSZxC2EOk71zuDHEJj66mMX0mRwv1xxN+Pf2XH7RKKKCh9mRdehLzZmzOOaQULxIN0IpCrm55+sDiWwcCbfjdeSxMnJ/gxe9Yz6gOTHet/5Iov/Bz6xRSUGW6bgLfSEeykylNs2BOjh4yZ2iU44fk0pT09wjSGygj0FfChmRuELkgWxEcaTp7akdSgUUDYJsLgUeOOszmDPZiHwrhGeBHKge5JrYXJULm5zqHnf7msw8qSMqi++20k+lxuja6+sZA8AUoo/ggDtd+80zg+fpSbgxPfd3gA+D/27UF/kAchWJ50AplNnqIYyXyqXHG3xdt3LBni
 duE6uO/t
 Iy9yO8bN8dompo6MAs/3CRQ/pKksFVFeD0APfpd9F+j3N3jVp2R1/jFsytka0L74SPrT3wyYO/twMHdj6gVtlr4fh2eio7fOcVyUHZFeOs1L/kQJkZvP5FcYHsmJeMs/IaVYVd0/87eojVev1xH8Gqpw59tmGCoKOxNBFvMbNuxRx/9fVwPXSFDZt3Bd1gxeBHn2Jl4lbOqhZhoqF9y4HuS14Q7TAzWVE3VN6bGidBeX1EQgxrkVukdutMX4GNtT74mE++KjLsDW/MABe5sKvygOfnNx+GcY51q4vL0gsZAbJFDHFBGBBzGzaqIZw3hdQBBg/9r4/k2qNuzAIBlA5UOA8OfRqj7ipl2gkGeX0rWoZ6oZQTz8X4gYJIpvtGwWxd+pcp1fjDFkZWXvGz+4C6qNe4omod51LR9pJyB3kVFfcc3aIyl6rAbn9tTA4yMU+c3IVFAAoAsEwkoHX3x4LBqXHi8Puom8lJPz/xs/wvEQbLzjihQIY978RetHQ8zFEimFfPEqyFjQCbfWqQzgYJPFOqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-17 20:24, Mike Rapoport wrote:
> On Thu, May 14, 2026 at 10:26:20PM +0000, Pasha Tatashin wrote:
> > Extract the logic for deserializing single entries for files into
> > separate helper functions. In preparation to a linked-block
> > serialization for files.
> 
> It would be nice to mention that this is a pure code movement without
> indented changes.

OK, will do that if there is another spin.

>  
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  kernel/liveupdate/luo_file.c | 77 ++++++++++++++++++++----------------
> >  1 file changed, 44 insertions(+), 33 deletions(-)
> 
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> -- 
> Sincerely yours,
> Mike.

