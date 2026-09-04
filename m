Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99D60C79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 21:58:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FC376B0088; Fri,  4 Sep 2026 17:58:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ACE66B008A; Fri,  4 Sep 2026 17:58:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C5A16B008C; Fri,  4 Sep 2026 17:58:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 47F5F6B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 17:58:39 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BE1D9160242
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 21:58:38 +0000 (UTC)
X-FDA: 85177444716.01.E454C3F
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf27.hostedemail.com (Postfix) with ESMTP id 51E0A4000E
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 21:58:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=DEs3y3UK;
	spf=pass (imf27.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788559117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XzksWWU1MUewC/BGGGBFcbL92cidcE2lZQDMH810em0=;
	b=776pSA3pNokZd97LE6Lgji5WjH+lNrYCft1k9ND9HfvRatdAT4ZooBQ9BjSuSByp+MU5+2
	8lCKkrhpxGEWs8jsjMGyjJjYPl8ObMjRxzbyHnVwCZ/Id6nDpqXoZrCmzxpUszACy+T8og
	9gdU6KnwxlCHXlGhEPdJ1WIaiAZG6cU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788559117;
	b=lpp7Wm1YyZja2IlcNWSA7Dzk9SaBd9ctm4oi96M9SJ74ruHxRqJCHEpT3D95RMFaC0ORpc
	ZT3YP9XluYUgTOPoiKxum0etmq+SRdYMVpotGi/Iq7zwJE0q8DLXuNWk8QwRmc2in7NCno
	yRg56pg1PX8gCK6JT7wjlOY0Knw/goE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=DEs3y3UK;
	spf=pass (imf27.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=XzksWWU1MUewC/BGGGBFcbL92cidcE2lZQDMH810em0=; b=DEs3y3UKSKMtC6+hpG42uJJrxK
	nNwf1sy9HeWqgaQDHiRkVEDSiamQWh5BXeT3EJdFuQGLJI08iYFHKJP3OtvFw26vslDqZLWkTpr5N
	0JbaWi1KUCxAoiMkDEWNXR0rugBYMGV4rlFfK7u2Nwy0lozHNnipNxscf0L0jV434+RGmNGUmZdeF
	P2sMfhObKnxBU7IuHpbz4vbcVWZ2lcRQN5Z3a9b9TQUqW1hNIVca+B+BIiFK+wunioTm8qPTbkqZc
	TelBW/MjVOrpYaMI+VLJbMAsC9zVOz6pXXJmwj0vXIU605lTKycs4rzdCpKcNEMQ2gRXt6wrAkRPD
	3LJjHOgQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x2bvc-00000003MUF-39hx;
	Fri, 04 Sep 2026 21:58:32 +0000
Message-ID: <bf0048cb-afa0-4830-b453-4083680e6534@infradead.org>
Date: Fri, 4 Sep 2026 14:58:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] asm-generic: fix typo "explicity" in comment
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Hemanth Selam <hemanth.selam@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, David Hildenbrand
 <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Arnd Bergmann <arnd@arndb.de>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org
References: <20260904104854.25272-1-hemanth.selam@gmail.com>
 <20260904104854.25272-2-hemanth.selam@gmail.com> <apqsBpALCmN8S-qw@gremlin>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <apqsBpALCmN8S-qw@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 51E0A4000E
X-Stat-Signature: p8ftfioc7ocu94jpobozaodomgwpc97b
X-HE-Tag: 1788559115-910783
X-HE-Meta: U2FsdGVkX1/lF/JJe4APshgUWBkf8pzWMP/GS7eI5TGYQ1EWaCgOwPeqDy9Ng7/ahtE2ulM+suNhAyNk7bGSYk1zJ9ayjQZVHR25fLJxgQudPJVM2C29TW11xLoBqFaMsaIW7uUHsq+B/iEweqd7PQj8mWq32672bJqYCYegAu604xCE3Uae4rttrWKpboGart2G6BBdet/+ygCbhOtqH8Bmzjh9pgUd2BNEkR1SAP8GtxWLbvKE+M6GUl61C0/3bk4TsSMjmrLugr3YNca7ZO6yS63JeOR7+umx4A2PnQEOwfYqqIkLEHxuQ+Qyvaw5rotn4MYQN+V0JZvRZc3Xc7VV1XmbXsckecUyGFj02sUugu3EFfj3p0J+gB8r9NHlSgM0jzvpmxTrodjyl+YiYQ+DdtCVtCLjpIYVKbIDKuKK1P+0Lg4aPj2oBJ3XLjglgQe9ZsaJjZWa8Jl9vdEt7EO8KKxvfwuqJnryCOApCd7z28z2WdLPWJ/6MSh8VtilsTblqManlDbAemqPzHC/BdgqT1S9HjQqXFj6/M5C7vLFsT53ZMNPDOoiZp2Y12jNENKYPEZ4o6Y0n5Qd42AVeIbjeND4QQjFFdZCzJwe4UVVEsz9t6g2CeBpKFXb3t3DV0Uv1YVVwTO3pnZelAKDoi9E6UsSO2bzHCSE8efgoYxSvExHkQgkWFq5LqOOWFreL1IUJEAzbtvEcgBxCn0846T/qKj/dSz9kQZDV2RaTU60j/jCQ8Jnt9RXtyruL9l06Mc0mmYYeFx1poV7L5U/vUe2GcqAUwSJuoMOkt8hYROkNG4xOHW9DOTTWyPVrwpojiRbiIvoeYSEaH+o2eRc4ID+0sasXwISU+lX+BMub/CIx4/OfOgWKoBdFlpafNr3IQL+TuM2VgsAWKchVkHw8NWYMr3uiwQJX2myc5Z8huOFvYuXMF54aco3ahUWe/S6W3dGvL/1hTk4JfgcX0F
 AI1eC4mw
 5yOrLBsBWWNNDsUpzb7II7USDu7XTljdZPMY7SuhwEz1/d5w0Jb5LpuchKpn0xPe6apWaTVzjKOrNnp/M+1hiDFScRkSF81owqsFP1yqt1J5S5VSG/msY9tXchHMJUQPCS8d2UhfKyzP1ni/ziigphi+isBN5rkpIbWZbUmpqSXqvIl22oLu4AmqzVWtBVnTADZZNazP0iAIfhuM56xGo2bdRmWVEs8eP37jlOoVEpimKh7OH3guVOZpWjudJFn9p5ZICbCZ3U28h8+wkyXmTMye6kkHLgopibat4ROvhx8WNlIZHR/KS10VKlKTg0yqPTQhaRGarRf9J5iUIDPoE7tDFRWiGI8CP2JrDN8pkTvej1ol+H4/DnREbbh87RQ37Cs2Ct6Mp2y3gjsh5gj/gb2cfu/BKIvQsFiUYTEjChwyaUYt4ngjpO4/iYh4WqDy3PCTjTGf/inuhoScFF8wmeMQ4rA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/4/26 4:33 AM, Lorenzo Stoakes (ARM) wrote:
> On Fri, Sep 04, 2026 at 04:18:46PM +0530, Hemanth Selam wrote:
>> Correct "explicity" to "Explicitly", reported by scripts/checkpatch.pl
>> using the misspelling list in scripts/spelling.txt.  Only touches comments,
>> no code changes.
>>
>> Assisted-by: Cursor:claude-opus-5
> 
> Thanks for acking the LLM usage! Appreciated.

I agree, but I find myself wondering what the LLM did here.
checkpatch reported the misspelling.
Does it take an LLM to use the correct spelling?

>> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
> 
> Please make sure to cc everybody on every single patch. It makes it a nightmare
> to deal with your series given the volume of mail I get.
> 
> I may have to write a bot to auto send this :)
> 
> Anyway LGTM so:
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Thanks.

> 
>> ---
>>  include/uapi/asm-generic/mman-common.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/uapi/asm-generic/mman-common.h b/include/uapi/asm-generic/mman-common.h
>> index ef1c27fa3c57..cf1418649b3a 100644
>> --- a/include/uapi/asm-generic/mman-common.h
>> +++ b/include/uapi/asm-generic/mman-common.h
>> @@ -62,7 +62,7 @@
>>  #define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
>>  #define MADV_NOHUGEPAGE	15		/* Not worth backing with hugepages */
>>
>> -#define MADV_DONTDUMP   16		/* Explicity exclude from the core dump,
>> +#define MADV_DONTDUMP   16		/* Explicitly exclude from the core dump,
>>  					   overrides the coredump filter bits */
>>  #define MADV_DODUMP	17		/* Clear the MADV_DONTDUMP flag */
>>
>> --
>> 2.48.1
>>
> 
> --
> Cheers, Lorenzo
> 

-- 
~Randy

