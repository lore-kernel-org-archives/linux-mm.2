Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22217CA5FB1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 11:43:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B1626B0088; Wed, 30 Sep 2026 07:43:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1888D6B008A; Wed, 30 Sep 2026 07:43:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09E676B0093; Wed, 30 Sep 2026 07:43:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D59726B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:43:14 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6E45CA72DD
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:43:14 +0000 (UTC)
X-FDA: 85270242708.22.468997A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id B575540008
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:43:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UEqFEIN1;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790768592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9uMVOqMiTX1K2XJQJxXE/LwrK8qNT7KXfojMzsVrx8U=;
	b=GUWlKD5IjaAg4SkVEsAKFa62Kj5IlKyrzXWp51UQQNWoBbimZuTfRO2LFtFFRGWnAtOnai
	xvzRdxnOCKyaCKRy5ISPnXZCGCO1qQMj/ZBbadafNSrzYmOhm6+X0mhP86ov1oUkwCLpjT
	4MT9rwUGEQgrXjSesRiHNBa1QKoR+es=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UEqFEIN1;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790768592;
	b=WDpdHoZkdeMUWUfz7norz8+9D/8+JGHYY738DvfVmfBO/CGOuPbcZXUMpe5Nk3FDaFyKVg
	th6BklX3NGlLYqc9edPAt1LtFsvhI5SlQb7zH3mH9/lxD5hwrzhuobiszVKOPm86hoFb6u
	fkUowyOK7djTF4DVOwQZ41GA5ytcuGw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E18760008;
	Wed, 30 Sep 2026 11:43:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F051F000FF;
	Wed, 30 Sep 2026 11:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790768591;
	bh=9uMVOqMiTX1K2XJQJxXE/LwrK8qNT7KXfojMzsVrx8U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UEqFEIN12S69RdNlJmEU6fp0nKhSRNYo2596rxvjxQjmx2chUXZZo9T5Kr7lEEHGq
	 d53074fabPnHx0Ed7wzeOZvSrzDEhKFOeMprzqQxseYpQ8SM7G8hq5VL9Eqc3Q5NEz
	 ZUuZGVoVk1oYCpHTte4evrGtrM6DvnkAiuTfQWIfuyHETHInxUkKBPYAfYsbQHrJg3
	 WZqR2SBTQTSK+VdsJaAThusyW1cmH2rKwTuvE49eqDpsoviY9EFUc1e1GJnZCOb9l9
	 cXXviEcuLrkC6xBcgysrrfRB8GhwEtKQFh6CKxR8Ft2+934XQpBCsTmMG9PsH8dQGG
	 iQnFD6ZxPIHgA==
Message-ID: <7d120555-0c31-474f-893b-e5ee3466ead4@kernel.org>
Date: Wed, 30 Sep 2026 13:43:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mlock: fix zero-length request normalization and
 integer overflows
To: =?UTF-8?B?67CV7YOc7ISgL+y7tO2TqO2EsMK3QUntlZnrtoA=?= <ts930@dgu.ac.kr>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <179066531783.50175.13377521828379196177@dgu.ac.kr>
 <3a95d0e5-7969-4b0d-988a-ead62b06b6f5@kernel.org> <art6x0XpWcT2aUyy@gremlin>
 <CAFPGN2jPGhcWVqa3k16RWMaMR3TwKyhFbYYF4D3L6L85T8E96g@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAFPGN2jPGhcWVqa3k16RWMaMR3TwKyhFbYYF4D3L6L85T8E96g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zn9cgunqgatea93zwc8xumm1jixfkfon
X-Rspamd-Queue-Id: B575540008
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790768592-641558
X-HE-Meta: U2FsdGVkX1/MZnG2CQcMNBV/D2dv6Yn9UC8TjgpKEr4hcLkFnTjKtAUAaQDhB/gF7BatdnPUbCs6BPPs76QZMLENojGxFacGpPqESZe7BXeG1auawowetqf0sn0s6Ofy8lkXTUTqqWVvazZhL3NzYOG7qEmqb8Nr7HTAAVLjDSJDeg5nfhKiqGQvr+qfh2RtlDrL57r2u3CbBA4BsCibvFF7Ym2ZPpvX9hO2WuQbwIe0Nt2GacsuaqquLF7CV2tLNoY48nbdilhweaVMQhfyqbpmT9Uhl/NVufyRTjJzeIhvJdD97wGZ71S6synTFLShrEeNR05Q9uet7rBNhKr8Zt4SDs0RvvD4/GLdS4zLJO5DwgfiS6FbrDDgSmeuESqGujQhwJPplQj5Fo4M4KOOFWTCGbT4qZQbz1m0vrYcPULvF9wgYKovQ/iHkJVD39bpLpwuUo189ShNYBrmIlcsgOoheNK9xodSl30OUf5bTDyJKBIy9DEWUH3H/JMep1arnm/tLhvjcRYtZe2qhMphxlXk6NtXBTpdG4cun8FqiTklw6zi2dEPX2wJg+IJwqVD6cqatJVtJ0wQu/IbOLBji+OvFaCr36JuOF8Rpc8iP2YuflK2FVT+JdzJ9sX63FSmuk46poRsaPrHNs5kkVWCMEopmPfoXsIFp5GQkywy7M5aCblgkUIWv+3Ky2xpegnIFLi6lKSppQ6MpcGaEwXE8Il/b19XAmvfEBD2PjT8eLw8jDcp11LgQJtCfRqQZZ4yo4gIpC9aDlC2SU1RSVjt27mGZCvOKbVWLWDTKMR84WBErPagjiMNuR6SCuhnuvvTlmGP2yL80lkEdJZ5yqp+gMVi1lraLD9bFBkTO0DRBWCraLLjsDtqHPi9v8Sh2qsQwQSYC1qSckbPdbQRjokizLkY8JPgTaurCh4OxdtC23zpbsIePXzl5NIOAlp4DrgcfQ1HGKNDCzHE01NDCrD
 xzaloVp1
 P7eoMLygv6ANUu4jUzWGdSuEo7Fj7uwcl+BGg09V9K6sQmccQ7ytS2zP6rdXi9Q1nbj0Z248E/E/sZiwC+N/6HN6SXCX6TXLfWlMdNW5oi6LOZci8PHVoumOsb1zw4xLl6ad5wyHnwwojkID20+l07zASeVnV+q6nDd6octq8befD92kvBtxXDcLq1bEGFuOdKXKdSPYduMxC2Pwgm26ygUauyYIWcBwho8sl6De4IhHEsf2rswkvcKDjLZuDvKYGv2LOqAuCU2ae+qjuOVIoNuKfwjdZYfL5MeSd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/29/26 11:39, 박태선/컴퓨터·AI학부 wrote:
> Understood, and thank you for the feedback.
> 
> I sincerely apologize for the poor code quality and flawed helper
> design. I will be much more careful with commenting and ensure future
> contributions strictly adhere to kernel guidelines.
> 
> I will drop this patch.
> 
> For David's question regarding reproducers and user-visible issues, in
> case it is helpful if the core team addresses this later,
> here is what is observed from a small test program wrote checking
> /proc/self/smaps on an unpatched kernel:
> 
> $ ./test_mlock
> mlock(p, -1UL)    : ret=0, locked=0  (silent success without actually locking)
> mlock(p + 5, 0)   : ret=0, locked=1  (0-length request falsely locks 4KB page)
> munlock(p + 5, 0) : ret=0, locked=0  (0-length request falsely unlocks 4KB page)
> 
> Thank you all for your time and the review.

The CI seems to complain about test failures:


# ---------------------------------------------
# running sudo -u nobody sh -c ./on-fault-limit
# ---------------------------------------------
# TAP version 13
# 1..1
# ok 1 The map failed respecting mlock limits
# # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
# [PASS]
ok 1 sudo -u nobody sh -c ./on-fault-limit
# ---------------------------
# running ./mlock-random-test
# ---------------------------
# TAP version 13
# 1..2
# ok 1 test_mlock_within_limit
# Bail out! mlock2() succeeds? on 0x7ffff7d2a010(393216) mlock0x7ffff7d44a72(278478)
# # Planned tests != run tests (2 != 1)
# # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
# [FAIL]
not ok 2 mlock-random-test # exit=1


So is this patch doing more harm than good?

-- 
Cheers,

David

