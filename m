Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0230DF8D762
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 19:05:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06D4E6B00C2; Thu, 16 Apr 2026 15:05:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01F036B00C3; Thu, 16 Apr 2026 15:05:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4FA66B00C4; Thu, 16 Apr 2026 15:05:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D69606B00C2
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 15:05:20 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 833A51609A7
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 19:05:20 +0000 (UTC)
X-FDA: 84665347200.07.657CC46
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id C39C320009
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 19:05:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KrwA37Ic;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776366318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vdlny8ogQqNeQ6Ks7iCSyOpgcKVs8rY/+9EBGsb112U=;
	b=vSiJqSLKPD2Jy8JaTZZnnNt7A19GOTZArWfwENTHfJmP9jYdMqb9pMVFIw4TddmE8KNdVz
	7IO2HGUlonwuC85sNTiqKYniOG4EuPwGsJLrL886VCEjH8CuvLK8Ry2LFBamEQ4pjBY4/M
	jHgToURXs7aD626ye/o3csUlWK9c/Tg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776366318; a=rsa-sha256;
	cv=none;
	b=cOPbVY+/tpSTFh+staRYzrVE5eUKDOwYYSDIcqPC6ncJdSsR5TdAKGGWV28y09s67FDMJI
	hhwHgD3uGWSK2cnt79Yv98MdBaU6azYcHAFtmusyzwj1UT8XbNwB61E4kFXXiyfQYR9lNk
	+UcezH9scood+JTdEPRENUTWKY4mM/g=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KrwA37Ic;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 158746012B;
	Thu, 16 Apr 2026 19:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC8CC2BCAF;
	Thu, 16 Apr 2026 19:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776366317;
	bh=BVwAhr4AQZ753hUS4xumO1ngnC+z2GMDx3GaGG4coFQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KrwA37IcAQ4XiTwT67NcvXshXVUHjd43kOR5vVTcpWnKAU/xRxs+scpgCl2Sj2+o5
	 IaLdF+du9ChO2eTQRkZJjK4qVBs1xR5u0bv7S7BTKHgEmEqsi9ajl7DK7Bol5JJgey
	 l4J8FclH1BmscyqjrmqPUuaN7cSVi1jRj5O054Nvvp4gsAxhjN5eJl5cqofJi67+pc
	 jpJaN/drEd0wWFHdAB5nabVCJVGFDHEHHrsdS3sNpUQToo83GMBKji9aazwRfRUToU
	 iPZ8dPk52MkAQIb2QFICrDdnGCpMzA+F2eRgIFpU+3OKOgxk+gl5ShDORsbtvrRSx4
	 l8T52zzYIXRcQ==
Message-ID: <17ea54b2-d43f-49a9-9dd4-d2330a8daa92@kernel.org>
Date: Thu, 16 Apr 2026 21:05:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: Specify requirement for
 PROC_MEM_ALWAYS_FORCE=y
To: Mark Brown <broonie@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: Aishwarya TCV <aishwarya.tcv@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260416-selftests-mm-proc-mem-always-force-v1-1-3f5865153c67@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260416-selftests-mm-proc-mem-always-force-v1-1-3f5865153c67@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C39C320009
X-Rspamd-Server: rspam07
X-Stat-Signature: gmhihqg4w987xsnns6g1brcbt7air6on
X-Rspam-User: 
X-HE-Tag: 1776366318-322747
X-HE-Meta: U2FsdGVkX1/pwYS/C198OB8IpQzo8g5lVr+GwEKRhUTE3jhUksM/tnb4kk86b1X4HY9H+a0/0fe21bfAIMirUI+k7Ml5P+xATCIsgQBJX7HGwuHgVQCyX7/sl+OIaTHVzuEHKfSpHJcdjheEGmZKmkBAkGA7aYdKOzw7SNRQuMZR0WBKAsXCLmMKNMK2GGJxSSVLIi5lPBi0e4F3rc9AQKk9EfSk8pV3L0X8KOyyxUwM4N3BvEogW7Ih6XNLhvj1cL/o21QNok+r2wm3EpBXUvfq+nff84iAkO43E6Tpxi5mj6OkE1SP8/keiMO9ZKKwJe3IZTCTN0qHMIPU4zDee53wnj7C0azvb1FCzPB/gB1XJh0hmxInVcCYt/eWgrJDyIzycLijwmXqOiY8c2fk92jyxRTobMpW9wOw8mXd96ey1qnlLoaVUAj4DfV/paIUo3/E4dvJ902+y0C0daAUSqphyVtLL3a0Um0i8mte+JyuqutCxClVubBtg+oW/zpACbGRNCNKoo1qrk6ngm+nzfnnbmAoozXDEeBcaErmTjtqLjM/UvaItkcTHptjh+cCWoD0gyD0v5jp9lxvLaQCVtaHWXo9OaB1SADLfOE1hN8/kU+vGpsihtxvw/7G2/jvx9E5o7HSMiOAoYnduTpID7kH9bGl5hZ/w0tu/VNk8ZA1c/vz3agCmW5nxli2e/k1vZG2w+I4mpA+TmY2YLDOF5tf5w2joHzzavPnrdE9DZtgydn1JcSfG3rICQoDWy7qn2zLvaRAmXA9SCu3BCKxGN0KsbIr1aNqs4iL3yfvLZbLJ/BoCbTMXcDMgQeMHu653Xiup8V1xUiA7+1QWeLciCLCoI/5KjTXK0FOGZv+XadWszniRPxvcmaC+wBYKyhw3iU+KzKab/7Neu1dLC9x/j5DCQKP8+1hFMf4SH+pgWT/VsqttapXcX0HJDJPz6OQtoy/cKBjT5n0z5iUELb
 UvPD5PUh
 dE2GAs25NTUnvIsMBWsql2KWzAfii2qOsesRa5C0mlQKsnA2JEwz3y9/XRxDITd5hvPD6tFvaRPDGwOMHDPyyI5xvI7a/okSj+utQpzcDj04cxWsL9A4bPuc43kOezGDP4k+ZgNGInVWthKsRpWoTYUovRRevEG7/rniTinjmgvs81nyzKlhxoYxjlBfQ/6jkQZHhRFRWcyzkObz1WkEgdYVLRc0oYORa1wa57PHqsj0x7ztPOXf93Q384+o52TBU1gPaqX7GgYl3eWc4kxnIpCWWLyEugKTA0GG7KY8hOG7rCTmogGAFShGB3zLiyyxWNNoY1vQ+vFYQ7UKzoRLhh0CPCktKhCl9TeeaqH/KbvMZgZN0uQ2Qqy715DXihHH6LZpESPTGtwJpklw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/16/26 20:40, Mark Brown wrote:
> Several of the mm selftests made use of /proc/pid/mem as part of their
> operation but we do not specify this in the config fragment for them, at
> least mkdirty and ksm_functional_tests have this requirement.
> 
> This has been working fine in practice since PROC_MEM_ALWAYS_FORCE was the
> default setting but commit 599bbba5a36f ("proc: make PROC_MEM_FORCE_PTRACE
> the Kconfig default") that is no longer the case, meaning that tests run
> on kernels built based on defconfigs have started having the new more
> restrictive default and failing. Add PROC_MEM_ALWAYS_FORCE to the config
> fragment for the mm selftests.
> 
> Thanks to Aishwarya TCV for spotting the issue and identifying the commit
> that introduced it.
> 
> Reported-by: Aishwarya TCV <aishwarya.tcv@arm.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---

I guess we could teach most tests to SKIP if /proc/pid/mem is unusable.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

