Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52180C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 15:37:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 227CA6B00A1; Tue,  7 Jul 2026 11:37:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B1F46B00A2; Tue,  7 Jul 2026 11:37:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0797D6B00A3; Tue,  7 Jul 2026 11:37:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C33E96B00A1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:37:38 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 332791A0386
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:37:38 +0000 (UTC)
X-FDA: 84962385396.04.6ADD500
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8ABBF20014
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:37:36 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fXNT+cTb;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783438656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y75kpJ+tFrxirHC72vKV0aIMRozRPgHfcnVZjN/92uA=;
	b=p1XSMjXXg+7vjByhgzNrJ8kce1WPLIT/NteVjJlMrXrHcb324BIP/YGTr0WJmfgqoJJBcN
	Qyyw8cc6Ddu5TDS1hbu0m7co9WGVxKXRr0at7iTGiHzWoG2A0q9lFo1xA1VyNPnv09ls8g
	JgDl9KJZvO9XLytf4fOgfoKyjqZ0yCY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fXNT+cTb;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783438656;
	b=BF5oZmODe9domtuof5LVm52f3AFY1u15UmhL1Cf+k5GyeKQQkx9qZ7hT7b3+c1e+gkLxDh
	3zzRcIWrSgY/zdKjnMdQ80WVBDqqkqr2nLLxrxZ9jzJWoP2No4uQqQAMWIddjMM1vWqTIK
	P0pyBxBmanBOxCt49uRPcR2sPYcoXr0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0C98861384;
	Tue,  7 Jul 2026 15:37:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6E21F000E9;
	Tue,  7 Jul 2026 15:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783438655;
	bh=Y75kpJ+tFrxirHC72vKV0aIMRozRPgHfcnVZjN/92uA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fXNT+cTbB5/UMbrshX9CQfgzbVSvTg8ddBu6d3RhTEpaXq+brilU3F978obef1TL0
	 UQQUwbA0oDxaci4GswOr+mzOpfQHmQKSeZaRdjdrRDVXywezR++fzbrAISBj5WqNwY
	 Y3Z9Tix9CIBB5qIUaMbvqo1JtDf8PSDZjP1HNwjH06VI//Trq/X2Y5lFScTjZo6nQV
	 QZKqLFqpee20ulcJiTp2XMGIEGtnepw64EaCyBKUkpqa/Ps/gg3iXWN9FW3bIy50j6
	 m37T0cBEdvKpYeLJNSqnCCBkJtNbTLZUpOCcLp7ckLL8npg1qviq/nf3555UPYbVvv
	 JuWjyDhMrogOA==
Message-ID: <5a933ca9-b3d5-4824-9aba-85f70f0702cc@kernel.org>
Date: Tue, 7 Jul 2026 17:37:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 4/4] mm/page_owner: document page_owner filter
Content-Language: en-US
To: Zhen Ni <zhen.ni@easystack.cn>, akpm@linux-foundation.org
Cc: surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260707115411.1714314-1-zhen.ni@easystack.cn>
 <20260707115411.1714314-5-zhen.ni@easystack.cn>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260707115411.1714314-5-zhen.ni@easystack.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8ABBF20014
X-Stat-Signature: m4kq6osh6k68ez4csa71nuxrwpuyzx8s
X-HE-Tag: 1783438656-697087
X-HE-Meta: U2FsdGVkX18xPIZRp1PEkJ9y/+5tHhZ+BPsVlAEehCkqjRZemn6I/Alb5SUi9TEU55gtKTvDWYX+9ZAxEzr/rnmPtcoqm4aGBVnkAn/DoDBQdh5zHbTNmIyAEMdxmINraE/OdJhrbxEddRhcUbpubppqTwU+890jGIuSnsDwS3DbKqYscm5OYkvjMU6Ub1+n3zf+pJVdln4acNvJb1kOxlTOWwEd3hPO8+n2k2QHCQeGAmV+dNR3EozpfK6t/9m5CMk4B9s401hS0EFWYLdfVn1B1cQSig7jna/jdpwRTNdrEJPzFL72rIWDgebMP95IDABtkU42hq98VEEu7INKfVXoeJ9/KXuYfe4a5Fc9XrnuJBxw9cNShUSWf7m7HK/pM57dRfDTJ7Rb1NzTBN/2XYFc6Eg27fKAZ+5r4LicVgfwfZeh8M1LfbkHpPdDY3FESVb7QmcdzQF++k/bA1R4FH9BxuFuOV3AqIK9hfr9t8rVVYRPKU6SEKrFEyG6Hr4Ntj+7Srs/7SjQuO9TOl/D5XiNxNPfpCLMXeP6sDrSNUivuI7KRBEgT6uecbX7IJ5I4UQlyHdKEzapsYgksy3iPskZJ0NCv4DnSMe0Y8BpTwQ8reEC6+LL87ZYnqvMFvXyEBE4uS5vi8qksM/+kE4/2VLc7R7OOo2qgMYbTyqNMoB1Z/O4Bw7vstIzbhCOvz7Oa4xl0QQj8j+WXIAV6iCFnrBCNM/3jPkvFBHRKH2+vUP7pKkM0vJ1zh4Y3ipVyAP624u57h6/g8yYGT3hU+on41PM9QE7waeRV/6+vi4vRfNn+EZR/9b/Zrj2z/DHyrvIYsSeLViXr0Kh3No5xd9jESEm1y02YzprKFYxotV9Cjr3fRSLdsXz0A2K2YwLm6AcWQEMEu7BKyA4dCc4YMLlnkXlakdym8tRm9s3fkC39+yO4GR+Z9aaPuZ9TymDNxmoS/wCH1lwVj5J/mJ3mW3
 cAps8eUA
 Nx6MW+VVqWARtXsXEQjJzWDSnFvCj2oAY8iW3iOAoSa7j6VG1tNQCIaZGEBKJ52mY4AgMHUz7MquY84TgPc3wMvuuA9NZko5detgvEU4oxv3E/h1H2iLviiRs52mPGZkpaLaGxP0LZjl1189IcgB9FMAg6rPA5P2vRRuWHJLINFYZe+zlviAiIcC7B4Oigllzn0yoIU6jkAH+yWcySijZDhfVG8ci/qMz/yjZ2A+uDrpODB9E9zhKGdt/6Ax5P8P4vY01B+eCK9isfohxqxuyZWAh0iuE15JIg5/0yyzemFrOYwG2razTy4fwHTH7cGmD8IToki9mf+l0DNO1fQMuLrpi7QysSKNls3QFoFKf4bOjLjZ4cpYPdc3m5V75hb5BmVAwUIRb5/dZGJNsrBxlPGe39trl0Vtg7BDpYLFbN7qymA0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/7/26 13:54, Zhen Ni wrote:
> Add documentation for the page_owner_filter userspace tool and
> kernel-level filtering features.
> 
> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


