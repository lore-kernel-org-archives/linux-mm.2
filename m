Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4348606A897
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fpgNN4Up
Received: by kanga.kvack.org (Postfix)
	id 9CEE96B05BD; Fri, 13 Nov 2026 16:11:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97F516B05BE; Fri, 13 Nov 2026 16:11:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8958C6B05BF; Fri, 13 Nov 2026 16:11:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 63F3D6B05BD
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:11:00 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DC38880120
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:10:59 +0000 (UTC)
X-FDA: 85431340638.19.660ED1E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 46DFD40007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:10:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fpgNN4Up;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794604258;
	b=nwp7cz23rA/tEUBDaoMvykthENGOerlLyEXmmuYLgRIX2Is1uruGQKHde4Vz3SssSfrRUZ
	d/d+3/1CUpJswlPMIqRypmCPhN99FpJrDN65Rr6Yn2gTS5GvKKxCxocs/g40HmbcCvkgZt
	Tubi4TBwjZDlcuJ/HVz6h0rUBpRX2E8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fpgNN4Up;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794604258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=woAy0d8eRRcTuv2sX9SO2fVmGylcnK0pSyo3soQzkhs=;
	b=w5UjhxIBUwnotZskIFVpOvAAA+ls3R6V3vafEvFVXRDP0CS+2Fm4XiWQBeDpMSMf06NyJS
	b7Ks7kh7gXIFOaJQ9ibwYRF2nKWGfPsJE5/5AB2oZ0bwTzsm2xND5XfwydbXSDL+eHiGJd
	savCXdpfGi2njOTqeDswAxf6ufOpf0o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E5384465F;
	Fri, 13 Nov 2026 21:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9791F000C5;
	Fri, 13 Nov 2026 21:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794604257;
	bh=woAy0d8eRRcTuv2sX9SO2fVmGylcnK0pSyo3soQzkhs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fpgNN4UprwXgj/HxHbTVI/comjJrFyYaY1gAJjVko+aaQStJXe6gZ6xdtXsX7QKNv
	 ckbQO122b2CDerOrdG8MCuTM70zSzP3rsutrkoQ6cqUH4b/u5s5c/MmLrux5jG+HRc
	 5uyB6WAuTBizeTvbFfqT0QU+JnAXw0ZqUFh/7QI/uQ4UTQBvQEigzA/JuDo8iG8/gI
	 tO+2TUlQWL0CjRNdndg7xQooNKdwX/UgyWFonLENlUAXujlNRe5uOo6vOpNj1JQgJk
	 Jn8+16Qcnrc7FBJ2HcyxXAVcUrum3pbsVxDZvzpJrUicauqflHOwgIgHxCsep1Aiq1
	 z0vvlHVANazKQ==
Date: Fri, 13 Nov 2026 21:10:51 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/madvise: zap markers from guard regions
Message-ID: <avd8raDA-DooZ2gL@gremlin>
References: <20261113-disallow-uffd-guard-install-v2-1-9d0063c70542@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113-disallow-uffd-guard-install-v2-1-9d0063c70542@kernel.org>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 46DFD40007
X-Stat-Signature: se4xhyknzhfp1nkgbehox5ithdw94arw
X-Rspam-User: 
X-HE-Tag: 1794604258-234281
X-HE-Meta: U2FsdGVkX18RfaOPQpCAq5jdMj1RXV5iNfj8lhVKGKyoHxlKNpAIYOFLHZ+n79hN9x/Ac60Cepq1MJCUqwiTMyb02P+F6/QCMzFm3n9V2YHar5oqzAgXLiQ+zoi+FJM9U8uC/Mb+fQtG4vZBzLs1nNbo4u5r5mSZge2goyR71hy5lTTY9wf75/2R6aqpgTXswHOMyzWjJr1B+ghIHoLHzMV842e5YD02KTaoo+iWePcnMCEW9SSbr7Oc0hdzPFQmN8FHUtzXhNk9c02lKQ95D0kiXW1PphIwqSw/QKIA3BVT35+1tYQsD+3ebsEQLFS8DKkYDDwMqUjqrYCfWXJFeowv0VCwVRzIfHkkCbsIwgQo0gaXOoLw3DFHMsF+Q3u1vHRw8KGx+Fr7UMULeMnX1UR5tNtMpbm4/N2MtvaTnqW7BG9DaWLVIOzokQ/3kz264YKF+pDYgvyntm1j8NXiLsx7ISa/rpsr5THeQEnoZPzSYUfNr+/cV/7v7rxO1Ragep+djBO7rwnHtdJqilhbbmFNxS7hzo8/gjyoywSbBrlRkPLp/h2SLbBy9cQ4hHOe1OSPJyzH+re79DJWT74GQ+MLVnwREEb4YQ3fTvw6CXKyoOdQ1UhG632wf0fjPYUI7ovaE1MleRdqeXstTpGrmRJQ0nKpMfXdWOhYKYKY7oOWiNtqykuB07QsAe8NpB59FK0Sf3bCFZLWd3zybb0fPV74Inu1VJjH68bQVwPrb5yauaBMZIq///pqN8wGIJrr8ejOP6L6OpxmVfDFK1V53UNcne8zYau1eelR/zxqQSdJfO6yuc0j/s/ORGvzPDhMfmUsTzG09gIZJeSIMW6t3qrg31GJp2OYzdp7yvBmHczwS6/Tuxb/PgjjW2uMuxFES/yuI2/aQtUq+Wf77oYztdlSTb8tZ5WbPEpSBE16cZT0R5TGCr6FmxCflqW9nQql9wfxrrprj+3TiDGUDc2
 he+46FW/
 VJXxGo312OgAGKq1HvFyHj1iHMiogxLqhk3Yy5apnCnMWNbAacEYHrxgur8N+2oDZaXIJeiheLdKWnB16tGs0wElmumN5lBZocIMZNpUcdE10ongB1zactxwzzfkUmBz8wCLfABH6KvvidhrksmztdtSw2GJdR7qwUtblw5BYTRA0lT1bacV5mcVRYqMXnizVb0uHTpkqR5sqt5FJJvfvRWBgmwZSFBYstWC8Yi6auPytqA5rUKNHw57dXvaCGZ8oHlWD1pIHSsHFoFmem5pBljg/beN+5sPANq3ryPh1JF1LU2k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 09:04:45PM +0000, Lorenzo Stoakes (ARM) wrote:
> v2:
> * Updated to just zap everything as per David + Tal.

Sorry, forgot to mention that I had to drop the tags because of the new
approach.

Would appreciate people looking at the v2 fresh :)

Thanks!

>
> v1:
> https://lore.kernel.org/r/20261112-disallow-uffd-guard-install-v1-1-bcf8b1aaa72e@kernel.org

--
Cheers, Lorenzo

