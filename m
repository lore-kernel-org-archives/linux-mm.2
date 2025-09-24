Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3036CAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 13:07:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 168F68E0008; Wed, 24 Sep 2025 09:07:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 140F08E0001; Wed, 24 Sep 2025 09:07:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 009048E0008; Wed, 24 Sep 2025 09:07:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DC9F68E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:07:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8C9111A0812
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 13:07:41 +0000 (UTC)
X-FDA: 83924170722.08.812E3B3
Received: from mout.web.de (mout.web.de [217.72.192.78])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7EDC4A0022
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 13:07:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=i3MxGX53;
	spf=pass (imf15.hostedemail.com: domain of Markus.Elfring@web.de designates 217.72.192.78 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758719259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OdGjjsFfxm07FUwZBmeZuXP/mxTZFmQCW5oypD8AB9k=;
	b=MA62HZu38Gi28ebGPVSHjZFx4bcrbFUO0U5TZeZIJkkGHQxsGrtYTSDkKhW4ny30zMizOV
	Yy47ozfEnNHloG4zAjST13TzEHqLDJbVD1/h1qNnd3OsaFdhGpZqryv2K1t7gLHLNsOHye
	9aKTfS2ngPjjHsLQASTLXlpjjxJQDUk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=i3MxGX53;
	spf=pass (imf15.hostedemail.com: domain of Markus.Elfring@web.de designates 217.72.192.78 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758719259; a=rsa-sha256;
	cv=none;
	b=hX4NbFBeCOSz+VaZahod3ow2DxByBNCH53Q8dFzS/HaIvZEHCh9jeno2yFb6qiomYV0g4Z
	x2jR9lbShpAtDF11nzLHvLB+SPco+HWrfshFYaDWbbUw9d2SmO+2aeEa8vFsTqO5TezzaV
	dSeY9nnwp2hoDEMRJ6hdADVZl9FbSng=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1758719245; x=1759324045; i=markus.elfring@web.de;
	bh=OdGjjsFfxm07FUwZBmeZuXP/mxTZFmQCW5oypD8AB9k=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=i3MxGX53nIE1KF7Ukcz2qMt/D3fuZv3ztHwwGzha47LxH/7FaNDZNcWn5ZgWjhS8
	 RaGw9FyCGudK9HO1KPMbrrPxIr3r8hZES96Ax2IDnZsprWWIEbOwNpsL+kifh0Wdh
	 eUSj8/+czvXFh+0ULZ1T9Aq2DqtKWGQx8p2ZiC9bd2maI2iD7PMBziy+GDGHdoB6I
	 V6OycaMPvsNbNJw4LoiIopJipRzdAdzNn0FmdxJGgBYnOhzN7a/7FykzNR53oREcW
	 B2+SW2N+AJQtsNfBuinPpIyUhe2xGOwjFGKAHBl/DfftQu73gq7XKhWTgwhu7QgOp
	 BrSgBLWIIVvFVHkf+A==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.191]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MRk0W-1uu9At2VjO-00OPr1; Wed, 24
 Sep 2025 15:07:25 +0200
Message-ID: <a1eaa2bd-3e0f-4871-aa57-d7f9966178a5@web.de>
Date: Wed, 24 Sep 2025 15:07:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Alexander Potapenko <glider@google.com>, linux-mm@kvack.org,
 kasan-dev@googlegroups.com
Cc: LKML <linux-kernel@vger.kernel.org>, Aleksandr Nogikh
 <nogikh@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Dmitry Vyukov <dvyukov@google.com>,
 Marco Elver <elver@google.com>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>
References: <20250924100301.1558645-1-glider@google.com>
Subject: Re: [PATCH v2] mm/memblock: Correct totalram_pages accounting with
 KMSAN
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20250924100301.1558645-1-glider@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:SFNX8XgpMpqmZ8DFGyqHU/flC0dMddIahNCKi+wLKgzOcsrK+q+
 VEgkUaBXW6MC6RSJV/hisVggNpvBdfIFZM4CDwB1eQhlhNM339o8WZtj8AKd85CPq1fE5y2
 LaQTHPvlE8g/k6+vQrkJ1IXVWJHqZqozhVc1+GeGF9q2Lpt1uSW3hihtGCxVVeJgvt265Vx
 BI5TVmS11apeqEBt6M/TA==
UI-OutboundReport: notjunk:1;M01:P0:EuAIvhGxH8c=;L+2hPOxomEmsD70I1x5BNSGi48V
 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
 I99lVDE3+0CJlmBw5cmhEcQewOvqMGXoW4Io3
X-Rspamd-Queue-Id: 7EDC4A0022
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: pbbgb5dnewmjbr3imjmj6x6bwyswep6u
X-HE-Tag: 1758719259-963644
X-HE-Meta: U2FsdGVkX18PgIMkUk+BOU2yargyO6iqdEK1GEaAfh372CR4CrWTAGvZd36EIo/awhrBOTwQQq0ZZDG1u5AAoglm6VwLA3ZGl8NTSwXtfCWK3iXmJ3j4sbVbR3ARpTUxIi1DG+u+3JLuQnUuQW72SDOZHozk4nSXfuN8WqmDabKXNjVLEvhnzQFWo8vfZ0fSfkN7a5arUmWfvoMWJVAmPIJdUEOhMkotASwu4Fc6FfUujPs4IZaqrusAzsv/0tGgVxbRU9QQAz/EY7u6h9CbL5rhN7RkThd0sqP/MaplDi6eRYimuEvrWqITOe1O3Lea8+f1FTsNBWTqWuaViEWo7j0LGX1GRZjZHQuxbf5lTXASLjCs0ZGa3XrFLFM7vmPmwccFbsQJsowMCeXiM6gwsv/w4jejSXi4sFgYE0Q+OUXijwKMhYe6OEhg0e/Z3woaYtitiqAunjIvB+5uM/SdaDhh9P3/Y+8SazqxSteC9wpmAVF5nCqJy3kUwNdcjuYiS2tCYJJdog6n1BUPxtI01LUZt4WwHxqCllMg/dOS6MEr52A6FR20cCRUWGg2EhAjbkuaZUwO6eLnc3QLakFf0jU91uAKtcP1lf+4aicW48CbPF2TOWkR8iHRPTq6+FeFWHxX+H6YDREZc/ojsg4ihfrkjBH29rCqHqGEso3OPJ6fq/JdCJZ+SSFRb23a2me/3H4A8E84kJgPyncLPUP6wd7eCdSaNZ4sSfs6v7uciZKM/tycx5SP/X7HhUCTAp+irTwQ40ESsNhOdvbcrh17A0wXBh9DNBWToXDowcNKf+WcRrxF+Vdo0u2UF9tkSOn6ttZlwfeXNogzu0WTNcpkoEwehVkTaTzpYhVK4e9LoqbG41uQnSO/iHkjIVfWF5nB8KZvdC5uzYjWWy43YygTRnQXw/1oWqwIFcHA/bYhsQwevSdUekpFoLxTWh2c99E052KoGLgvuSKTlIVgHCW
 u5Nfqm2u
 GXJsGlwtK5LdrzDjjTyh5ReLr+RY76a+JBfAIvV4i8ybsGV/Npr2mkhPW+c9fc23EmmABpgfMzPj4+zYOmpdDtRXuoDcd43RpLcMOHdJzmU2dInEgcc4jPCO00D+CFeX/lVS5il9+Fju2EWydMnlfRj6yC9u8rVyPlDSZbMjws0nPgU6f17ICVKC1+7aWiY6/UqMWp4wnDzHxo2EuscHY2ET0NC/pdtA9zltmQmZ3hXQEH3Bbwb6Mt0rywad30Ln+X4287v4ySe7hVpC4vCMA1FwhsLWWMpsHBRowPLcOIbP4GCMzgInNoh7NWdJrGRvwQymVF4CjvBjniVT5yTHBC+qBCgGLlVHQL2iG9xiMaEuT1+AA8OTlViUj85qhoSGfAzeF9f+mtYHhTjhlOTwbxnx5Z3Oc09fqWfGqcAV0pfzQ6aU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

=E2=80=A6
> This patch refactors `memblock_free_pages()` =E2=80=A6

See also:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.17-rc7#n94

Regards,
Markus

