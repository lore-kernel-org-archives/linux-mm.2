Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 793D2606A325
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 11:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=P2hok/IQ
Received: by kanga.kvack.org (Postfix)
	id 87CE56B05B3; Wed, 28 Oct 2026 07:25:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 806326B05B4; Wed, 28 Oct 2026 07:25:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71CCB6B05B5; Wed, 28 Oct 2026 07:25:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 50C326B05B3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:25:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D2969160C6F
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:25:33 +0000 (UTC)
X-FDA: 85371804546.07.72352B1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 12ED8A0005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:25:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="P2hok/IQ";
	spf=pass (imf25.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793186732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9mJ43myQfb09ZHFd92pajyUabxECeLaGrPpQgoogl/M=;
	b=ag2zyZd6NtgUsWY/00m1lHG8FIDWBsEMqUqesRuhXR+SVoAJzCJ6FWtRVt85uN8xQR9joy
	NtrVy0NCuw526gG5jPPAOIjtMby1A/11T21auMnNWCKuHyFKvqEoZSkp6gi6G1BxJK5hTP
	1t89IkQoz2k0D3/Gts54fQ7cFkmEtW8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793186732;
	b=rd4je8SgD2kZbig+JC+dLPDTXSG3vdAJtFWz4KDdqKziPWcsUqzxzdjvEtTzFMhA0Fhc4o
	CuCKom/PKMNPK77ahzaQLJMtkXR8kyjzjeeN6+rTCg00l+Y1VBq/Br3xYyJ7SH53Vh78VG
	OTUj3IgoFn6L3Qba9ZyVf25wpUG555E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="P2hok/IQ";
	spf=pass (imf25.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3329416A3;
	Wed, 28 Oct 2026 04:25:28 -0700 (PDT)
Received: from [192.168.29.156] (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B958B3F673;
	Wed, 28 Oct 2026 04:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793186731; bh=YKaulhQLxUfKWnBASX1S/dUGhwJrFBUH8NuOouts5+I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=P2hok/IQmwm8cB2bnDnrDcPeAaV73twbAWps9caSEi5dY2Jcd844rTaNBr92pszip
	 d/LDigAE/b9OTh414eXiZq1JnhVYqaRVz2PyIEus6hbpQG3OwnnX2NsX+NjmIMCxx+
	 FVgww7zQ2JJU5HdwtOCk7+2L5pU8iAEcRnD9k6Qc=
Message-ID: <abf93d06-e330-45f1-86b2-945d21d26f2f@arm.com>
Date: Wed, 28 Oct 2026 16:55:23 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/7] selftests/mm: check MADV_PAGEOUT file permissions
To: "Gregory Price (Meta)" <gourry@gourry.net>,
 linux-kselftest@vger.kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org
References: <20261019171206.3331374-1-gourry@gourry.net>
 <20261019171206.3331374-7-gourry@gourry.net>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20261019171206.3331374-7-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 12ED8A0005
X-Stat-Signature: tigehs3dm1x7eun5fn9yfuuy9azsy38d
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793186731-576734
X-HE-Meta: U2FsdGVkX1/r58xAt0h2BC1HdrwPpdq159tPMUsnWIpJgK0dBlcGCAQ1tnZJo4mR4f92fcOMVmNfFShIl74E+G8IAk2blSTMyVJLCrTTzDf5+o9ne/Mui0/LYyISBa4vNm5WArvI6/jSO0L3OooNHHzefNdek+2YpY+ojLJrwcpmdnevVZ3Cz63juiwymR2E21lxFfIMYeZfGcLpvrC+3XOIt4h9o3JM/KxmxKU91iQeLEkXncotZ8fAR2v9Q6dm1jg3bcOI8YkR+u79kuc6htl8X3LtAAATiwO5C9ANxhEwwrRP+nfgZK9CD/mhhdNeUUpmbyX0mTXZvDfkgrwpbmvlH3zW+R7oC4WYzsW4j+D2Anxq0ngXQCxmaErdtlMwJrDsIdxQioSTALAaLedMZoMupNuyzLo2cRnnbjjVn1xH2LxR8leyV5+06W9k9GRxN0BNrdZXywX4D4SjF15Pm+IoDvawutT1WMLZjAzZrl9k5/5s2rC/inG0poppujpSw9U82cifBNsR10noBA4nVg9JOtMgNiPA/WPzDJipxd8KiU52rLBDlTPHDLtfIurIFCaKlSQH5F/vFL5FazFVPfsjxq7Aj7k64VFQdz7lnbWxWr2qE92PLel57502FC6vKgw+plTA+bIdQfPT3LPm6MlEgxrBTcCHM3ubNLjpRvh53a97BBbJ2pi47O6nE2wpKbBQQ1e1WpTMgSVQYUdjEpk9Hf3wnQo4MqddoAkaRK0T5wsDN4o9UG1aiFrZ+M+aCiRiHMMQpEJmI0PDJf46/d1IdNutCv4zcfsnBIyHWPlPLKIJhLgpBaiwdEYRZjkRBfrX2SJE2q+a4/nBvUmEpX2CFvcPtP3NBjmYRXQW+SxkNaCISznIwjchdmSaj/X+TtpRlYQb8NIRYwhYfGQrnqceEwkgg5saQKZHF60wDE7luer9T6UIG3PCEU5jjnBWUjOGQ3vv5OfMjQTkJUP
 oN7WG+7v
 4E6qLA1m/4AI82NfGYYEdqhVUNDjex/7Su8M3kTmBLjkcFei62orsPk7wpw7iUT/Q6ZDlRz9mpHO7aTAFaceomqXgUbjvWn8VSYxwGBHCXlt1tABTJXNMa0DKHDEyKBWODcjAtb+LBAxMBnG4ay6pzQnofu87XMeGIVAYPm5wdiA7Btt6UzaYq3zNXW4+XsvjwiEfP7N6L8FJpGCDYzkFMp7i2qn1hdds2z1MaxGIs/TlpkROTPHAnFuJQ///nrvXB9l2UQ2iRM9BjcL6cmEXvIV1UroQqZ6HnDEReH1LIpnkXPo1FIk7rVB2LwDUw3nh6gEd7DoYQcBgEkcpMiQPXNkWHK3kDv+hiChPAUqQklU/O6pJRH+CR1JGL58pHaKPEnhe2F/8HQ3gAcQlvMuSLT8M0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/19/26 10:42 PM, Gregory Price (Meta) wrote:
> MADV_PAGEOUT only pages out file pages for a caller that owns the file or
> could open it for writing, per can_do_file_pageout(). Any other caller
> gets nothing from a shared file mapping, and only the anonymous COW pages
> from a private one.
> 
> main() now also checks once whether MADV_PAGEOUT can unmap a clean page
> of a file in /tmp, where the tests make their files. The tests below skip
> if it cannot, since none of them would show anything.
> 
> Check that the owner of a read-only file can page out a clean page of
> it. When started as root, the test hands the file to nobody and drops
> privileges, so that capabilities cannot stand in for ownership and
> nobody need not be able to write to /tmp.
> 
> Also check that an unauthorized caller leaves a shared file page mapped,
> and that it pages out the COW page of a private mapping but not the file
> page next to it. These need root to change credentials, and skip if that
> fails. The private mapping check also skips if MADV_PAGEOUT cannot swap.
> 
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
Thanks for the changes. It looks good to me.

Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>

