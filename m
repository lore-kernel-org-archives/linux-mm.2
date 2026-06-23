Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 431DECDB47C
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 12:19:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0E7E6B0088; Tue, 23 Jun 2026 08:19:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC00C6B008A; Tue, 23 Jun 2026 08:19:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD7366B008C; Tue, 23 Jun 2026 08:19:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA9D46B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:19:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 28DF71404AF
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:19:17 +0000 (UTC)
X-FDA: 84911082354.01.2494D6F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 88A68100012
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:19:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m2knUe1M;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782217155;
	b=DbMRd6pRpqxXPvAmQoQ2HbbMm0tcNSvV8hXEKSVoC9LXH8s1GWpfD/bDnYsD94IltKXwhK
	Dj1UsMcqKm3Kcd0gNc+/w1ZlegQpPeqg7nrNR8IVkZFIU/wSDEZh8MKgKxlluL/sx4p9m+
	eue1UKXENv+OlXxvoz7QhphNOqHcVxc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782217155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=okApS8kA1BHmpX9NtGOiC0KXJACuDAVb6ZoT6zw+Ygs=;
	b=lHInyiGVybSunvqujLQv5FxaYYx5UdudNf8NqO/s2McO48Xv9Xs7QuXd5qIqUyhJFOfSgx
	cGQmu/txdCwe8OcZMNS+xF1Rq2CEwVeFnrfm59gwGBucayNMbCcFhznRu/rzfLJoD/TWTs
	WEXN/7mSzVDJOgLkM3YLsi++BUfkerc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m2knUe1M;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B0294373A;
	Tue, 23 Jun 2026 12:19:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145E61F000E9;
	Tue, 23 Jun 2026 12:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782217154;
	bh=okApS8kA1BHmpX9NtGOiC0KXJACuDAVb6ZoT6zw+Ygs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=m2knUe1M/njq7jjIqMM0aYd0IQ1XadhqQ4jHEZXlizp3dwr2PJ2e3+wjZ0In7VD6r
	 +/Pkf7DTaEef2gEGsEyTvnu1KWETnlSwseXzQ0BP6nB7fOkEZ0SwRdHibAG9V3aLz2
	 xFqh4wBNAyd/83J23xxCJTz6i06Xw7goDbYaJT8QMTkdJ5XPeVBWESgp3K0viBLkPs
	 V30JcTeKkiT7nLtPEaHhjNVQGN/g9YjHKPZxpfJ4VxEiWx7GcEQQ8rtaegWUBuNW7l
	 N+9jFDja10LrcQIoov0l7Vbv4xErtjZ11aJ7GMV9bJefR1ifZ3PmI3k7E5MWLp5cge
	 wzrxfxhdONdbw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Mike Rapoport <rppt@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Pratyush Yadav <pratyush@kernel.org>,
  Andrew Morton <akpm@linux-foundation.org>,  Alexander Graf
 <graf@amazon.com>,  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/3] mm/memfd_luo: validate serialized_data before
 conversion
In-Reply-To: <20260623105201.3724592-2-tarunsahu@google.com> (Tarun Sahu's
	message of "Tue, 23 Jun 2026 10:51:59 +0000")
References: <20260623105201.3724592-1-tarunsahu@google.com>
	<20260623105201.3724592-2-tarunsahu@google.com>
Date: Tue, 23 Jun 2026 14:19:11 +0200
Message-ID: <2vxz5x39o3eo.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Stat-Signature: z6apo4hk8kik35ctq5hffstpr5s3zcqc
X-Rspamd-Queue-Id: 88A68100012
X-Rspamd-Server: rspam06
X-HE-Tag: 1782217155-532837
X-HE-Meta: U2FsdGVkX189B0IXsHQ6tv0BKKRojFwYCCnB56FjSeQW4Atxxv+I7Q5xf/k/O1Mm0TSfXQrUZ9GIWL5QCnMb2wvOTqIUVKH481LB6kOAdleJagGZjG/3YsT472MPBSmzGFpFEWOQz9ckcRnoVHCC3F7oDlFJtfzSCnazzGWY+hiXBuryPV00oS6SwsEFSTfCGgtgKeTSovEiVcVK3OmFxjroX7bS4ZtA80bJXyMvWwrWi7WO1G42S5PnI4Y8ziDe00Z+vmlkmJvISVoRc8EAYQYmC4fidJAHzlk9b5GHFJ6aBszgqtgrmv238rno4mabMGVLqOwjIAuQuybXUKZvQq+cPFanzeapfg4trpitXmMOHatV0GJtbFZXxOBmaCOL9cfZcvVf6rvrOM7YsX3h1ZeHmK+1QDoRO5KN7OFycovXIKMqwTE1akL6fPPAb8T30UL7gWsXWOjO3qqutcNke5QeLKo+1JLWb2wq44fqFb8Uo3/71HAlUeR9m6fGjYwRTuPXG1kv2ao8sjCp+pGPZw5m1byRWyQjuJblHngbObh8TyfRq75/PliE8EHDvhir4bB/kNx62iGujJ1VEP8HfSC2MZQDEbS/gvP6QwwbncPH+1xHPNP/xO4Gk8RnR3u8i/7TTEPgzD0ZPVjnhwj/tQCqAmVuLlSA/7mo7KzGw+M0nY9309E85t9UwlNcqYtp8TvI99UBUwqbihRvfHohkfJgqivZ/maoFc2V3KMyGpm2oYNUpSc1EdpXSX+EIOMsXZuv9GJHUOVXeijUq5UwdZTBTJ/SFE+leZrZZGiK5rVIrIvydlOmIPbpZIFN85nLt6y/eGBLos5uNOa2YS3AcYgjLI2Fwvn+jondaaMU9t6Mf40V4miSI7+YAONwG9RTrqKvhKKOpYOXxsBRO/WvIChKLBjy6xgeyF7sV/3ihmAcBUndrfbb/YHo29RPQkYFg8kJZO643FB/WsI3p/D
 wCx92YQO
 4N7dOTLDMHs/Mm80XLu5KU2WC9AzO1j5KBvlznGlnqSzk1hQRyy/oNwtOgFkZvKuriN+qKZoZ1+OiTV9K9LB0o6o785+vCi2tDjKAMldiiv1ZFY2aTjXfZVILxGnCoM/ShoMAFdPNK6rcGF4ZOAdT8UdlmwMOF2NUtt7PAXZCCUwBTtNUHo+TMuX2RX3jjWq8Y8viJlnKAf+tShHHeq+uZGMk48sQXNwixH1WCPY/K8mx6VW+O/2+tXtdi+mVTs9rZcEM4oCsmAM4vuZZSm3xCIthfqub7G+8s/gVPi/6IdfCsPFf2aHi5emyaafWH7Ar8hgraH4x30LxLNw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23 2026, Tarun Sahu wrote:

> In memfd_luo_finish() and memfd_luo_retrieve(), phys_to_virt() was called
> on args->serialized_data before checking if the physical address is valid.
> Since physical address 0 does not map to virtual NULL (due to direct
> mapping offsets), the subsequent check 'if (!ser)' was ineffective at
> catching a missing serialized_data, leading to unsafe dereferences later.
>
> Validate that args->serialized_data is non-zero before calling
> phys_to_virt().
>
> Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

