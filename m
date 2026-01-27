Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 820FFCA6CB8
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 09:29:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D15BE6B0089; Tue, 27 Jan 2026 04:29:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBD316B008A; Tue, 27 Jan 2026 04:29:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC9616B008C; Tue, 27 Jan 2026 04:29:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ABADF6B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 04:29:51 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 55101BD2C4
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:29:51 +0000 (UTC)
X-FDA: 84377221782.30.DB7EA2F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id B63C1140007
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:29:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="aqoE/WeG";
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769506189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LTCrav6xCkfc0BbQ/U7B9PNL46cvtBsbXaZCd/pJxww=;
	b=AZEXNvPzjsJj1wDDWjPZJ4PMjlFvWq+3uGOMUKJKI1D+uhqs/aOYFzURXB1S7gdVbSJ6fR
	bt50rkh8AbQ8m9GLpmtv1NMvK+w/ZBBJya0QSqF201lTSws6Fg5gzIYBy9hEG5YlHyMhDZ
	UhrHaHqpnymqtrCQmWIo6rFA09SxH6Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="aqoE/WeG";
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769506189; a=rsa-sha256;
	cv=none;
	b=mBUBlrJdq2FUX5hfW2nFLYKtvS0iBXG3YgtFme046SsG19helvaV51MIuTWev8yf4YoIt3
	RWwieGOH7cWThodshNL0+/fqMAcFicjF+QCqMaqQ5/g8e1RAsT8aLJarH0VglKInTsGcba
	QLUU/B2Yc/8xDWhD3RHmCtwsmC7bbAU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F3BB43631;
	Tue, 27 Jan 2026 09:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD2CC16AAE;
	Tue, 27 Jan 2026 09:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769506188;
	bh=KbuD8VI9qE2RW+UjdlUAMiWNgxpjBHRyOL2IKLMpQ/g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=aqoE/WeGYI8SXZM/WQsI0BrG/uffO9ILMR28rlcvE1XrVbNfp6fD2ql4csfZg3mH2
	 NiCKlSyMu2/lppn+f3Tj0iOQcTx/y9XGKV+AxvSL9tmr4C/LF2CUXDC5yXKdBso7c2
	 dx5uatyuaYMnzYgvhzkbiSegWlZBpUkygCtt1L3drPX/mUreCsccyWb6HPx4Rt/fXp
	 FcCqvZ2hWNSjZ3S5Fat9r6kLPF9REQG8/Jxa2pcXD1e8MIXyjkXC5gBafDQBTWGKMv
	 Lb9I0baBSkFpSVv9qKYAo5v/RN9pVWgx2zKu5Ngmr/Wg6BW0fGzhYKyhVbHUFI8mN+
	 LsM4gvb5CV5pA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Alexander Graf
 <graf@amazon.com>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <ptyadav@amazon.de>,  kexec@lists.infradead.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org
Subject: Re: [PATCH] kho: cleanup error handling in kho_populate()
In-Reply-To: <20260122121757.575987-1-rppt@kernel.org> (Mike Rapoport's
	message of "Thu, 22 Jan 2026 14:17:57 +0200")
References: <20260122121757.575987-1-rppt@kernel.org>
Date: Tue, 27 Jan 2026 10:29:45 +0100
Message-ID: <2vxz5x8n9zee.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam11
X-Stat-Signature: mu8mi17hftpskxwfncgghnnn64a961ib
X-Rspam-User: 
X-Rspamd-Queue-Id: B63C1140007
X-HE-Tag: 1769506189-449478
X-HE-Meta: U2FsdGVkX184mjjHhgMAWyVjeoCwcde8uH49d2+WJxFbsHsbVhUMkauXF5ae+XWDTmJUrag8zw1lsISNjzRfcFfNrIq09PcZDz9BHRgjbC/geRmGo52EOvyBzoI/KLQBfZqJlfKZ70ziTs/uS9bJMuu8Wm/Bwp1OBrnpMdnSPE24BgDhwXFQkhmUkDwyj13qfgMLLST6APqPqmBk6mMrLkg+HC2yn/IC3blxPtbUsUd7I2fRWc7e52pFkmeQY/G84Znp0pLrdtKA3gnm/hib1K8dyjYHnr4mIG0VlP0al0rLO3jxi/5DN9DtyJ7njnbsHuv02jrs7KAVwCVC8vnhJtdWDgJVnbhE8bHe/5hvUBIvu3oEuJWyP9DarKXyZQBc0j2nhy0+B+SuFmRxJ71yQVXpx4YqZrDpiKB2gzWCKR24GxqC3M6MTCFJweb6GQgbJL0+19mR/1UDhvuW3qYcLX4Ux0sahbrak/KgNF2qJRKVUDX12A5DFn57+0mj7Z3/BG4koWUfunX35XC6omcJdzwdpYeGXnsgh2DuBKJ1hc+GIkGdHQVOJ/xv2qFsZjNY0Y7Vdd66fS9st0VudXFvnz1PIqA10fWx2czxo23yHScpyOUPUpjMvyojHZ7bLyZ3n4bjzWybUo1wKDWzTeqnbsb4m4RQtuYefolTDeRLuftS3v/MdD+vYosBj7UCWkxM8e5UNrNXoEtA75hOcL7bqyQBaAKR7N5b6w8vP+ggrRMq3E1ZOMSNksnZ3WwQCGIr3CtZdH88TZb1PNXsqyFsakZlJjaxjkbGn1X1cvBoQJuy0I1CXw6qcOBSY6TwmlkUp/ly258F+eKWEn1HUOYonU5UMT+huWLTwBWA5bgX22BxtXJFeXXzOyTKlAaow6HACIpJvfkrQ3tYOmRXVdAoG3BHWX3b3qNnjF7vkoNoLk15SCeedyUw/Si49ks/hkBZ7bPA8XWrN01rqWneJr5
 0wMvTQtF
 SfvGCidGBfHao49qdiGxMHQSZfUstFiILjpVkxcvtmhPeBh7EHNb0E4xmnMR+8uOPKMgnD+SCyzI8wPgdu61b/gZpSff/CEyNrrJV5ihvk5vBt/ro2E1krJ2AoN3TDVFh9PpZw4+hNk7l0uW1HYnYUdKlScjbJYfYVvWB80AbUzo/hBimv/yAO7WUcuPeJW+wKGflKdm3GxDK6vGKfL53T6cUuAsbdA7KtZK8KIlk+fhaCAwuvPTMa8OvicjRSusqbSnkJeZiAAQ3Y2s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22 2026, Mike Rapoport wrote:

> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> * use dedicated labels for error handling instead of checking if a pointer
>   is not null to decide if it should be unmapped
> * drop assignment of values to err that are only used to print a numeric
>   error code, there are pr_warn()s for each failure already so printing a
>   numeric error code in the next line does not add anything useful
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

