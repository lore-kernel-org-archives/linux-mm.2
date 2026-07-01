Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1706DC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 08:30:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD17B6B00A9; Wed,  1 Jul 2026 04:30:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA8C26B00AB; Wed,  1 Jul 2026 04:30:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABFA76B00AC; Wed,  1 Jul 2026 04:30:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 896456B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:30:44 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 099831202BF
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:30:44 +0000 (UTC)
X-FDA: 84939536808.16.5ADAF51
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3EE98140008
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:30:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nsi0F+Yg;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782894642;
	b=UkCBA/WZtHFCuoXqV6eZnXO8QlGt3cb1Nyr9qpEk2xOhxsQgJ3ocHLe4jeS7S1baIfSugW
	iTviRNTI6992bvb5HpaNhw1XluuHwx5HawUc4pMsiJ0dgpTMZZuCu+adYsm/AEZ5Qdg1Yq
	yfbPbZdUye/KAHerbwWuS4nsGVdSryI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782894642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EitmsFYTKYnE/CMQXtoyKcbW9g8e44qIXAGKtiQio+M=;
	b=uMZkdiNgyaWsekMRTfl/IuJOKJS8Bn/+qHE9nzgzkp1FwMSRcmI1w8YGQLuyiNbn1VjN/p
	sxqhD1Fto2tdYUkimh5IB75vDaJqyUy6fS4nq43Gyfp8xampb5X9TcoV2UQ1+JXvf430rs
	HenwD/MTh1edK4li/r3rHdqBYmCiTuY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nsi0F+Yg;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A8DC43313;
	Wed,  1 Jul 2026 08:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B7D1F000E9;
	Wed,  1 Jul 2026 08:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782894641;
	bh=EitmsFYTKYnE/CMQXtoyKcbW9g8e44qIXAGKtiQio+M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Nsi0F+Ygx4oP2aOkquf50Ol5J/VKGlycgqaighAmg0TKSVZ3PKlnCmJ3MBwTCK0Ee
	 ittaRsMuJbzHBRg9UCOcFaAvAwD/Gc11ZfEl5JM5wpMQz54Nb74/Bmo7RJKX8G9rkb
	 +ULTndpI7UoV7aKeOWd8GamVyOwzLNgQFACq7gH4rd2AUpOCoZXYyI7uV84iywtoCK
	 JXAFtNwd9RZ0sezEXaMXBopxgfiGPI1exZOp6hLMBfQqO3PPtLqIQGNABMlHg28Vqo
	 cuQ9X3V7kFC1+jyIi6qyLoa/chLQdbTKZeWvFZo9cg9nTn4HBctwKqX1beZyEs6tDU
	 F0DjNs/kuDEjw==
Message-ID: <cfeb9b58-be6d-417f-8040-5e7e66158a64@kernel.org>
Date: Wed, 1 Jul 2026 10:30:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 02/10] mm/memory_hotplug: add mhp_online_type_to_str()
 and export string helpers
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
 linux-kselftest@vger.kernel.org, kernel-team@meta.com, osalvador@suse.de,
 gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
 djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
 alison.schofield@intel.com, akpm@linux-foundation.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, iweiny@kernel.org,
 Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-3-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260630211842.2252800-3-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: oq4aaify18hkug6ieb61tzezift1gj1a
X-Rspam-User: 
X-Rspamd-Queue-Id: 3EE98140008
X-Rspamd-Server: rspam02
X-HE-Tag: 1782894642-513674
X-HE-Meta: U2FsdGVkX18Vi+xAXlhAfbJuqtZGprkBxu3wCyZlTSw3NFv3wwsLC8Er6jw/HKe/AbTpCUDLwFw5SuU8SCCbqdJZEEwquA2Uh2ZxEqqJfZq6xXj84ZsKtbbazxY1SaoI/AARXXBNOhMF548P+82AnXz8fSfy9D415c1O2IpnFnE6z7jkgVf6zStNucp+6lZfILLn507zWijjU1BWpXUUdlhvnmtgOlIQIik0s4ME9mwhjDeo7q55H6RC7jyFqpRrUNs2iACgbqCnj+o+CwZJZqZTD+FPUkksouvned9GvZt8Us//rjUUkl77ESW0Q/yhlWTmYCQt08SWSYX5qjEdVigruHpSDSIdZW4dyInBHG++wWhJupYHaMWCOxb55Gs8h/jpCB9tLojfrSRVZ8zjH8vwsUjA5kADw46ZFkXDeg7dMKuud6lp971H5SAqKN5ukOTfVkj/khIWKLdRgzIVgeQtNuwdLa6GeQljfRbJUD6kX5Jd4CvD0Y4BDZXjBm3g69i55ZAj8Z0cod6CMd4iRff5hNdRgd8FiTJYOtT+ulikHCCOP3SF0dtncp/GMTs3zR/zmPkBA3TdepMTgZDiTbXJ8XVvNrXxXel14ZE+I7OPsdUJztZ4BGUwiMWgy8acGrX9CHxepT0cQWNDp+Oo4lwEj9R/JjJZ6Rsi9hoghRQohZtU/yKKxFitnb5PjrPEnaj/46TVFzSdNsABMBhy8T5IjpBMeGrjHafq0ttImySZ1hC/zdY7nlnvZ3nZUP9M4XcbxYJI20dY/pLCAoXHgL0Z4yuaS5X55aCr0vANF+kGFyR6/ZN+wrecvrj1VHrF3juvGGHkeL7IcWc/T4fWTSks2HjgecpBXW5y8e53Luwxv8pi1DN00XaHdJSsd24sKgsw2c6wu//pB3QSoC/T4jr/k0y2y9gMoJg2f1rWjHK3Vx1TvcTI5/Q7HnENzwXi+4waJw4EfwASMzgtNtV
 45X7rU78
 qjdg1cKP3NCDKRNPm7lfQlRz4Uo9fP4RqNcCG9UXcO5erUkzVMrK/7KN1+JPOLpQNDJzwr51vJhpy3ToZSAYNmhGpEgkPpg0HY0HTcGtn1ArEaVe8aqwuqoD5pcMfLng56vO4cHwgfryy58vOjF/JF5qCm82qDQ/MU9/WMFHry4Bf3UlChdRbzNPpa74cQGoWL2NQjV/XLEHyXxN+gJe1UuJiMIMpYuvdRhksZGJ6gkWZEAHkU2byjLtLEfGD54l2tiNP7LmnP1y5WQnJwlVFPV3/Za5Vccw7jVrMlNCJ6z2i7gvXQ8ahF66t5av0/PNB1lQny/EOQUBdyg39IEmvmgKKLFXHgQetXdZlXkeet7zHZpsFFPw004hVttbFo7lpWP/OdjUSnV9cMVE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/30/26 23:18, Gregory Price wrote:
> Add mhp_online_type_to_str() as the inverse of mhp_online_type_from_str(),
> and export both so a driver can render and parse the memory online type
> through its own sysfs interface.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

