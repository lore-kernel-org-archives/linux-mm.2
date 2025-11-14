Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B7AECE8D4F
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 16:32:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77B378E0020; Fri, 14 Nov 2025 11:32:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E8518E0005; Fri, 14 Nov 2025 11:32:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B14C8E0020; Fri, 14 Nov 2025 11:32:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 44FC98E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:32:38 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ED25812E142
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:32:37 +0000 (UTC)
X-FDA: 84109755954.08.5F2C777
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 452DD12000E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:32:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="N7e/jaZ+";
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763137956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dMDWDjt/Wz3SOVfdYzXQII4p8Eg1oPHKPYlKP/wq3Og=;
	b=CsMBYqqqHlypPftIZxF2LwfCujsuKaNpfpJTwmuaL/oLWDEi1Y1IBX/56oSlNF/nnayTjQ
	5Kbj6PEI64RinWtSu+NLDeOBDnT4GNjuEj0hHyvnZy/CPhTrLIoa7TfEJzQJZRBRALtnYs
	QqrwvITRsWWKMD1BYXE+2vSn7xmHXCI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="N7e/jaZ+";
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763137956; a=rsa-sha256;
	cv=none;
	b=izMi4x9nzgAz7o6iMH9iSxqyrLIrZXbnSMTPcwmMAVXCVnVCPxSqtxSs9C1p8IHvRIzEPu
	RwOsQker0o8ObG/VX8uAbaeIEulJbxAOBUCzxP0TP1Ux3OAww2f+RarOwj9ZBTlpXI+k4H
	SFIy9Gf8vLe188j6zs3XQVlW2oPGSdc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 540BB442E3;
	Fri, 14 Nov 2025 16:32:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0422BC4CEF8;
	Fri, 14 Nov 2025 16:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763137955;
	bh=VPIlJaSoX5ApbSW0ibgqxOo/U0FezlELx52crz4R/Qw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=N7e/jaZ+rMWOwEHCWLLgn6TMigcFke3ePmjNIwetydBBTKGd+F39vf5npz3H7ILEq
	 1B4TPnvmHW7mYSeZPzXCqQza7p6mwzOwSj8Pb3VNtz6bW0QAT/sfippM7ZBNKXQM0E
	 SYTCq5iaEJuOJmn3jqeBx9l59iFsODi39WZ1liTj25QMX7P6okhIqHvX8VhY3FH6/U
	 45xztb/IbpZEQDvTL8E2xOIcS822cEatwoJr4O+GRut/NBwbGi5yVPpWW30iakoBQD
	 Os6KkfwnXowUl1q7K/F1hw4shvEth2riUW5WKPyO/yRcK2ZkQZA2IVo/hNwla0nkqE
	 flvpsX0Db+vTQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  bhe@redhat.com,  rppt@kernel.org,
  jasonmiu@google.com,  arnd@arndb.de,  coxu@redhat.com,
  dave@vasilevsky.ca,  ebiggers@google.com,  graf@amazon.com,
  kees@kernel.org,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org
Subject: Re: [PATCH v1 02/13] kho: Convert __kho_abort() to return void
In-Reply-To: <20251114155358.2884014-3-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Fri, 14 Nov 2025 10:53:47 -0500")
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
	<20251114155358.2884014-3-pasha.tatashin@soleen.com>
Date: Fri, 14 Nov 2025 17:32:31 +0100
Message-ID: <mafs05xbc8ti8.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 452DD12000E
X-Stat-Signature: maehcwtk7wgdkj6dbmk83nb8krrna1pa
X-Rspam-User: 
X-HE-Tag: 1763137956-934859
X-HE-Meta: U2FsdGVkX19zSAhoQRDfpkfC/WjHn1Hc2RL0hsoIGGqWUrOuF0wn/VxjZaySlAPUG3eFxHKIjlxFhAW0jfUOV8qBNSxfBuY0/fFJ935i0TFiuqYqlo9aJlkg/OLEMWSau7IVnEQI84zh+f4Zf2zDrC8M999cZ0hT+RCVuDy96iTcS0xZflZT4boNlmbEToF6+w/ugZsbRu2ESAAmlDtncEwjeH5R6tTaSjmy9w3/VE7ZfDkHatJfKHjMruCDSs/4aX9nVtz470KoBkAcPpJpaznuVvoFNlPVRFpV491CedvNzOYFNyHwqgqN1cykuz4KPWZaPNtHw6ZFHJw4I9Z7imZO7JRJAaSTp9V8DUe0Xvy40vMVaw+Sut/3KZYqdsxE9AGLwcB2C0EdA1krfM6A9KWqOMQNul0H/lN/KPPyZCkGQyZBwxxKdF39sR8VaQmTWHmgf+VzZtppgQCsxglbAgecIyUBTD9U6reOnZLoZl1ArF4KUaWU2//2e+ihBFrYcduuXIBFg7UXcIAjDGoJrD9+mSrh18UlKiVKcIQjFp+Z/mcszp7CY0MXzz9SLZogOek80RQV61G3WavcXCa5nf+++VzrrDPmnxM0LIzf7h5cvLdvgHBACKASFWJnrS16nNpOIx4J5kf4I22Oqd1X0pd5y1tmzsxJQU82EjzKjzO1jHET7rSaHJ7Iv6BuMY0RHmlJ0JYeCEYMuUmEr9JpNy4VVT/eGDsSQUS96T+TKsFOxBmk2nEPV+OPg8u5waWlriwQ4w6rlE5Wx29cLXuT2T3PZ8jN5VVBUxnu/r6PpizJFv8PFOSwX3rWnsyJxNRUG6hrIKxTfP8YejKftnLY92E3ujapGwemmg2dqC525f2DYtQCFuAwWATzkHYc8/4xvrX5w4kKwWtUsvCR8xDnSk26LBCGg6rSFjbD49G3xG8lcWRvUHQEA/e6tTIi5+FJM0QpvBHKBE8oigEvdhB
 DPpsKRxg
 zUuR35BU0lh0LQXsGm3s/4l4RzgoEXWVFS99LqePWQYsmQOT/F7U++Fl7w8DJ/22RD7gmZLsSZAwiZyP6D9EQ8ogYlLNKkc2oOyQXrKc+df3lD0n9jG7uhEG1Q3R9sDGmiyjHLBNqUl+UVECpnS6T7w2E01edhpaJXopRu0BaK5D7v9oGIbTVIq36Qf3Ng1kdRY9JPVWeJrjOV8HsGGMkm4B6791CVetFatFolfmmXectHCss2gBkk9Uwr6/GJ9IzmIHZDULtIk6H78751a2RBdsJfBDifJUmYIsnbmA7Su9xS5A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14 2025, Pasha Tatashin wrote:

> The internal helper __kho_abort() always returns 0 and has no failure
> paths. Its return value is ignored by __kho_finalize and checked
> needlessly by kho_abort.
>
> Change the return type to void to reflect that this function cannot
> fail, and simplify kho_abort by removing dead error handling code.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

