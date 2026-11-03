Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4AF9606D825
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 10:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZlYeFbhc
Received: by kanga.kvack.org (Postfix)
	id EF2AD6B00EF; Tue,  3 Nov 2026 05:53:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA3706B05B5; Tue,  3 Nov 2026 05:53:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6BD56B05B6; Tue,  3 Nov 2026 05:53:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B2C9F6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:53:51 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4FDD840368
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:53:51 +0000 (UTC)
X-FDA: 85393497462.16.C16E1E5
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6802F40005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:53:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ZlYeFbhc;
	spf=pass (imf11.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793703229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MK9NWPvS6d1n21gUZXzgThjSx26OkyuSUa6tZ9qysAQ=;
	b=553yIzIrlMcgsLFESPwFAcgpFO9d6vRDNVOkhFV9PoZEycYGY8gGrs1bXbxJX7T4XDYreD
	bGRcQzP9/+8Ly1FhdCzwUgbA6VD7W/JYQD/6qFe4gIest9KEisznYgdkJg63lzQCrvrKEw
	V2i28xjlhel178CokaweVHhR01zQyaQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793703229;
	b=ztkPyUlRS7L6uRioOYqZUbz12sMsYjSCiNcJ1A6WvWc8qzI+mRM8DAKRtmCMdeEHInl6Dc
	gDor97DuPqpny1AokKiADkKhPxd2/XxhQmlNNiAKOuWXQvbGFVrxmiQAKDIbrR8D/5tAEs
	WG51wzaQ4QvLDlfwmDXqN75MfXoNqU8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ZlYeFbhc;
	spf=pass (imf11.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a2167bd087so33762655e9.3
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 02:53:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793703228; x=1794308028; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MK9NWPvS6d1n21gUZXzgThjSx26OkyuSUa6tZ9qysAQ=;
        b=ZlYeFbhcdOqxsy9Xn+IpP/aK2qGBawPcNUYUmCasGi2cRAHA5oGkRnkDGJfXZlOuc6
         bA3RCaURTGhAuhT3TtoFTd21+lIips8aJOuZPfCbs0BaBKQp5m31GYUDpPXW5B8TwHHn
         JItzzcoM63+8cFAzpgar0oFzKYpp+B0JMri+LXEy3UD/l9lSyWqBXmJJjG6LB3+6UqqU
         DpmR+KOV9XlVsDA9yI/lPzSxx052n7jQUL8Qs+yUFjq2Gxvtah3Nt7NyQsUTOyXURUOe
         oyzi71oa6QGObR2g+SnyboBM4OrWeleM4g9sEz4FljQ0ykRyp6IUyzI/7xWFuSoRCBtc
         CNWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793703228; x=1794308028;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MK9NWPvS6d1n21gUZXzgThjSx26OkyuSUa6tZ9qysAQ=;
        b=h8LmOuMxN2XoPKF/M09vNTOXjC/FzYVeuoDwkqipgek4QC+UVHMH1bZd4TJ0iSwLA7
         C9C+MZ8mlyRcBXT5ggxpgS2DWtGbLJEKO/q67jWLgHtMfdxI/R9RUaustnRCpPiRb/OV
         FaWtWMqn1jleVQidfIJScyvBfz00II7qQHILUHd1kEC87LIkl29/1BiWAcmipVF437OI
         P843Ib2IRCVpkzV1dqyB7wZLRs7Hdsom4R5Ki77LefMgHhKnfEsQ4qLuCfvODMK9Kg4h
         x2POdyF3nGz2v0IGbXgMd8fkT/ZPLLzj/Ifu3tI81VSAQUglkgiQ3tat3ZMJwWKgdI2C
         aCtg==
X-Forwarded-Encrypted: i=1; AKwUvBxHWG19e463lL8ssasZ0SqusBTN4mTmcvVSKLGcZArcrSf8PlcifshufYPD67iRYAFNHv/5LX2r9g==@kvack.org
X-Gm-Message-State: APuU4Z/hRPET6Gwwq/D/mqHIg9pgBQ8ovuaF4ezQXP5+LQkfvd/zbwiN
	96kfJGt6M09aMISIFyfni+mNBqe2quU01a8dEcSJLmPQrwc5CgbcA7DHj9okIdDSUI4=
X-Gm-Gg: AYBFou1q6kmWzHndGWhtjoNCQ8kd1A2LERBEM697XNMOSeTqa5jI6QScQTMCGBXgFf0
	/+j9iNmUCTm1CPMJtZ9yB/ixBCGvvrKpg9KKQ59x5gXhjNdCmd3/k2qG7AAKENhYkQzYKpbnRLJ
	wY4lYfiTxseh7FWQ+vkfSFlzaPNYUrCSeGkOky9zIr3LMpU5PcYE3rJBvLwClGKmwtIaJpX5MBU
	5IsLIlewgggd3d8D/055y+A3ScG2yEoIJe9ATuCGDcSVMZZswZMSdjdeuZka+L7HdC1IsEIQJRH
	vmQfsZzY49KPbE36mSGnWlT3bjOLzUaKCzH8f5ReDgnIhC2ekqIta/oRah4Wr42mFdmc3frMu9D
	zytRVRgnHbPKbfNc4PBQXxyDw5TytWMJHrGpIQJ7vJzJuSHIIfuYnhQgraVda9Atn6/7q3WgUqx
	UZMfZL9bQCWYKPZ3uRXmmoJ0Rpfp84tzncEampRnc3POvTa4ToO+dwY7fKNuWwPbAq4MdS0cOIN
	/sjxVnTdmGur6K4nUZyhOXX3x1de4+UplQRonqzkHWrIUkXG3v169eeKKjkt/6Z2JQjUdUwOhQZ
	PJS/1H/s1fa+7h1AmjtX8p6K/yW6wUm4g0PZDflJVVYi
X-Received: by 2002:a05:600c:8b04:b0:4a1:fb01:13 with SMTP id 5b1f17b1804b1-4ac17a3683bmr296846775e9.18.1793703228040;
        Tue, 03 Nov 2026 02:53:48 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2aa5781c9sm52120315e9.8.2026.11.03.02.53.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 02:53:47 -0800 (PST)
Message-ID: <533f3f57-dc95-4a97-abb0-14b88a7e1018@gmail.com>
Date: Tue, 3 Nov 2026 11:53:46 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] mm/mremap: reaccount on unmap failure only if
 accounted
To: Josef Bacik <josef@toxicpanda.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org
References: <20261102-b4-mremap-pre-split-v2-0-d281dd11ad7d@toxicpanda.com>
 <20261102-b4-mremap-pre-split-v2-3-d281dd11ad7d@toxicpanda.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261102-b4-mremap-pre-split-v2-3-d281dd11ad7d@toxicpanda.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6802F40005
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: kj7yqcdqikgjqzka95inbgof5wm79ndp
X-Rspam-User: 
X-HE-Tag: 1793703229-369412
X-HE-Meta: U2FsdGVkX19GXISa8VpZ3GqIgPfotB/MDJjtf+4Tc2Tkqj82ZyLUW7o/Zur8uZVNZ73Ik1tqQ5QaFHHzaqGuvXoap0eoyElulukODFhP0WFg9F+BP2MgmY3jO9kdAiKfoxxv1qmoqSqNol7ttY94yeoD3JTpJnkg5HOExZoLBolXOsogjB839O2zZCdfOIT9iL3jqSkErFAG7x8agOk86itjyNMXaEb53tPk2YNphAaakVgedGUT5kqGXjHTz6lEcnXHPCunf6KBmksB0AL5b/cx6a7fh0vQgGFTbrSva93OllDoU6Fd8avhLKRtD4emu2xooqB7Ki4WTIjzxCzhjH4YI6cO2OL2Cfk8NMreyEbzBD9spH2hY6iGqXQL6lBfOw3ncP5lhaO5rSF6gB5P0rAdFLmU3mrnZYXl3VT87yyjMsoWrumzgaGAOhj9jIhpGvt8bChucJ+wrauTOGCJDOVs66YAtCsaYNq9gSHqwrkQEcWw5kvS4mZOwEU8BYRGkRbygwhbCScsXky9yyZjQ6USPzS96ZPa1R/KNYluTDFIb6v4iSKGS1vlIoPhC5wc6+xaa+600dTwS8iJLQmYir75MjrnpC/ptRs/OJWMsONcaNLSOej2qq2/2mW3sJa+zeL8OJ28tjSIDnvfuWuQr4Ms+wZDlc8HIXZxrV7w8ucIVi96ksS3h/7dOXX6/9B0i9V/tdsyTOKtYotdNeJTKCnQUNfNnIIjqGkFaYla2skJkOuLZq5P3EoLVPceEuloLR0xcB5zfO503EaKRxsrhVJP9s4uM336KKzrldyVW9vp/LBiuu3oTSBF3/wtYTeu5soGXAN2DNuuaHuxgqLt1XmMcA2OgxXqPqgwVRT8MDhZ62uyOFKC2Iurqy2O4H4ih9kvdQeb8Kc2ybDSjrzAOqNnZjjhbUJNyo+KFGkbApyV0botY9vzLvOcLiLBjqa030Zglj1m33oxnyO0aIu
 ztUpIAG8
 LxhFOlcHVg9H/R3cyU6HKOpw5te5xtuTRrUrcdL8/irLJGqNdx8euOS84zVamNg/fH+MK4Qe5HodJzK75nkdp8eyvBXvidmXMy6VjdGs7iNvpeBLrszUw+1HeLPIlp5mid3aiXorlKvmaicwRCKA5fLpFuh07Psv3DpVoD8jNNL4cMgNQ6CP1R0tzKZtXFaTNtgKmzj28Mc+HdQj+df7JsIh0ezHkHj/ROcJHFYP5+38HHj8UKpN3JvlR6FaPlBa+jW969kDJsmvbucYwthW34wzLKQaTI7NdQPeqSDg/EZUsVX6Vd0rum+GHASjSiE4BbWTahS2LPXtbUfdwlutPdK4mP2nmci47EIK3rDynWiGMO+FJSCY3RroRKWqhzwxFIwLDpJBze30tXL9iqIgdQFDUOT9i+TOOyrypaXAgVwDv1+XmYCWqt+k/kX6f29qdaIlRT5/d1MfNW/964iojJqhMuykTmmsWOx8qbMsKyAD8IrhiJxYSkgoyRvp1/FkOIk2Gzq8fck9VaBD1VQfeuiPKbZnrGfBwDb2gy/NVFvLw6R4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/3/26 12:45 AM, Josef Bacik wrote:
> When the unmap of the source range fails at the end of an mremap() move,
> the length of the range is charged to vm_committed_as even if the VMA was
> never accounted, for example a MAP_SHARED or MAP_NORESERVE mapping. Nothing
> ever uncharges these pages, so each such failure permanently inflates the
> committed memory count.
> 
> This was reproduced with fault injection: each failure on a shmem mapping
> left Committed_AS higher by the size of the moved range after everything
> was unmapped.
> 
> Fix by charging the range again only when accountable_move is set.
> 
> Fixes: b714ccb02a76 ("mm/mremap: complete refactor of move_vma()")
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

