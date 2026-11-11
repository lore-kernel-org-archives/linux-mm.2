Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 905EC606A327
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 18:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kuufHG+P
Received: by kanga.kvack.org (Postfix)
	id 8097A6B00EF; Wed, 11 Nov 2026 13:53:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B9116B05B0; Wed, 11 Nov 2026 13:53:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CFF26B05B1; Wed, 11 Nov 2026 13:53:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E5D76B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:53:46 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BDE261A03E5
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:53:45 +0000 (UTC)
X-FDA: 85423737210.23.88495BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id BD08940002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:53:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kuufHG+P;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794423223;
	b=rJurFZ5HFMi8uNZxlZESKRbRiB8rk2y9jyOyB1Ca/5VmKYeeO17ZR5tFDrICKoYek0S7lv
	l4XBxcJBl0frfx1LDoPXFD/vBYSQAulXCCxh1nKpRoY6bKFW96omK1ptw0HssmS7cF1cgu
	gzMwZMXUqBKOgGQREu71bSDWC+ScTWY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kuufHG+P;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794423223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PYzsGgod1v2dvJrVFGeY0BQ+HuOlbqzOMG61uDWBRg4=;
	b=xibjx/0xzGHl8mfhcE3b2D34N/dzNqfqcSrqTEdjUPgYfe+qJ5zh/6+V7Ppfq5wkAxkbuA
	1ZcaR88X1kmgsdzRIvdDpmCLAulQq5sb3V2k0ZjeCvmqTN8ESv+7Ih2opXNFgsk77G0++Y
	o7i3LvzStvp+RIzBG8jZEYJ5Thl9zIg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D75363285;
	Wed, 11 Nov 2026 18:53:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274D31F00A08;
	Wed, 11 Nov 2026 18:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794423222;
	bh=PYzsGgod1v2dvJrVFGeY0BQ+HuOlbqzOMG61uDWBRg4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kuufHG+PZt7gE5/bUwtIDSgCQyKQNoZnZNCoNyjfVvnb06r5ujSUAEeQarCPQfiIc
	 wZp4EBr4rq4cXFNltmxrf0SIaMjQ2uWMU9vpupTsy10coO1fjnoJXdfI2OATToYcax
	 o9LiayjACNwwHvtGSyMWZ6HLQfGhoxmaVtcqTacNG7gEeuA8nApxQFGRtoavID4QIJ
	 6Yx8fGtBNI6rNqFs+Mz96J983JITGWCDc5i5XQCtpGhhvciBxovheVzlsYm/Q31WQN
	 eex2bPQRDUwnvECITJWo8uGKjkc4tSfU483/Jx3tohwcOPHfU835+jhz7HXQ8/Yc78
	 FK1eFRwZVOnWA==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id CA3A4198003A;
	Wed, 11 Nov 2026 13:53:38 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Wed, 11 Nov 2026 13:53:40 -0500
X-ME-Sender: <xms:srn0ak_-aftocvvhwWq8K26WaFaTB70dZ5Kf8AAA7zrAGC9NZfJPAA>
    <xme:srn0andSnJHjOKAtahVGUVpWWcwI-R0xxszz6UxCFRla6R-kDpC6DfEXw75doH3ow
    xsAmbevugqDuJUhWL3-L5a-INtpVLscLoywoQUzznU8hU8ywz_xgVTz>
X-ME-Received: <xmr:srn0ao7W_LWkosI7Q3A2ZqQYxlu1B_thjIm0NMyjUHlCz2YhOO5EQQVjvo8>
X-ME-Proxy-Cause: dmFkZTEa1dvnx6ihvTibVGtAfbCVzvwaA0LvSEoEdkrti8I5hWXxtjO6pYb7xAtBYPXprf
    24I1jLpD1rG1ueNtQO7uHF5m0Cs2F5bIo86oBDf+1smmo5Eu06F9GBAj93UUsQfgjhfSjN
    Qov9F9ZcoPX+nbAdKEV3ue0niovWqmWzxUyLwn1Udo3iRU5q774aTYsG7Dd1DtxvXBMPjb
    31zhIFEGq1K7YkQ49uYelSH16y3gF8S0vKwZxZLVjWoYGod1m2+9ACDYXJ3mk6bofQMp54
    uJxqAU5j3HbIrd30UTRvV6lpcorhjFIL7huhuDpdoNAD8Sj8ZN9QUl2HKNwBvyKXfllKW5
    /+tDkfPISPKrmzIPgb5PIsge929BdCSHitecDptB5A8yL+CFkgQxR3MOXqd44baz+MbzXJ
    Yz1fhqvA8I7PHblTZZFFotsbmQtYGAGTExZHZ8SIQOXRXtV1IH18sSzschAv9HLc6/f134
    OaMMobfwqBkON2h/1fySfPxq2kCewuUBruhloon+eF6rEowyfpHrfEYgYEWv6CXAh6eGnQ
    v2kvbdJwCRtuy/6nO4TCikhtvfmLrr7kRA4vo/Wm5gmr58uSA11tO9Cd6EXQHtBrJcbuLJ
    IBluKQXFDBMdoL+ePqLGvJoU7Q09pc0IQCdDRfJWTlV/jCSeZTZww/KcbgAw
X-ME-Proxy: <xmx:srn0arNHmzBFe3B9B3P8wD-cROYNj2sGs8hOw2vUJmlY8AS5fx-mnA>
    <xmx:srn0ap6gtlXiXhN_ZM-G2c6YvVBX9kUZnK057PGCDKvtTxYDWa-nzA>
    <xmx:srn0aiyXdfFaPmoch8ftg6YGvgjFF_AqNkeGlnNtzn6gWBnt42vdNA>
    <xmx:srn0apT2TmtgD1k2Hmwu6CuitIyMt2U8pPR-YEjqE3MgU5tOthX16w>
    <xmx:srn0aq9HYBlk66VetoipOqdJluzifyRP37eZ989HEGwcufebdttc91ol>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Nov 2026 13:53:37 -0500 (EST)
Date: Wed, 11 Nov 2026 18:53:36 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>, n3rd <18670333770@163.com>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "ljs@kernel.org" <ljs@kernel.org>, 
	"ziy@nvidia.com" <ziy@nvidia.com>, Mike Rapoport <rppt@kernel.org>, 
	"peterx@redhat.com" <peterx@redhat.com>, "security@kernel.org" <security@kernel.org>, 
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: Re: [SECURITY] mm: khugepaged collapse_file() drops RWP PTE markers
Message-ID: <avS5QcRj85yAm9ll@thinkstation>
References: <606cae9e.bbec5.1a1c54f4f9f.Coremail.18670333770@163.com>
 <60541e98-b1f0-4f92-a155-8a29c0bb17dc@kernel.org>
 <44abb8ef-7711-4ad0-be9f-ca47206892a3@columbia.edu>
 <856cdf21-7982-475a-b244-a7ceff4eb6aa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <856cdf21-7982-475a-b244-a7ceff4eb6aa@kernel.org>
X-Stat-Signature: bsxrncxykw57xj1bwqe9bh6k73rqfx43
X-Rspamd-Queue-Id: BD08940002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794423223-510889
X-HE-Meta: U2FsdGVkX19o2+U4oZO9LDCQNzOIEsAN0MuWxqoQ0O/RcucsQiERgvsDCeWzBtDrTVTcCTbT+MiQbc/dr4byO7SOqKAnmBo9KbcnA0Gk9ViZvJElLSqmFTwff5gQr7sC99mzlOH7KdoB71P3hN7PbNHGh7vx9gfzuDGaaC+JsZPyZ5WGdjSxu59trKlIlUf3a+jBWJIl7K3aUs22S6MnKKSBgI1Dt8/FlnaZk9UkVeZ7lCBjAydY/D9aUBgdHc1wmVJn/2m2ISyPu4PTxGm5PEVHydNkyaMyn+uaG4da8DQU1caAkgJEuP5Iz7zH+gJTeaneUWYFgU0SEx9kHfSSXlaLcWTq9r5jbfT7ov0bppkoAAL3yJdpq7WBMUmjI/CnokyTx1vO90SLxOswHw2sPNpR0kSACDMcpqibi0DF4T3eJ2eGc9HbSUr15awrL0FFRkP6srdVqFw3DURZ/yMZ9fW1crIEcWuCYGtb3uJB+TW4DQHH5QtCrxgBYMkSVI2soS1UQzhDX0xPpDT17ineAbssu4bBw/g8y/jPYAHB6KWAYKpRg6tUW/XFrG+3YfwJm2a3rLrGRuSyZl4M8d1O+1vUSLtGViP3cW9wUSqjrEtZx0a6AYHhlvhU7d4eDRUxbTBYAGuvJmgZBA5780zGVF6Ntb/88oyQHkpgfsMDIiMkG0qAQl75pmCZZFLzp6DFBwBo+o2I6TsYOtE36DSIxNAOdViwmEkm70y85MBmBR1RozlYaTD3ivUs7ima6p1iOfkeiz/zQ6z81nt6SR/bKciBXJdgIFmpSWPLsTXOif4N5XFxj/F3KN3GJx5xsyubB8+4cnL0Q9SGoJqRPMOnxjVmZb7wgZNIIVdUWbbpEtpWfbdvTMwPhXUwRrI5xPU5C1OZp1GAJkvrsJOtXL5j9XUQhVZQ+OM5r5FlreIl5YzCnHfvo2qv1nKZgG1NpYxedojaH5A1OoZJP1wHdaJ
 tNriV6vB
 NQ+a3L2qrdHvQlwzfcNBef81gVpvfQi+uA5MlVMdFVC//isX+GetVfK5NFrVA/RzC7NIuFTT8BE9N8R8v/EonG/HCFxEiT4wQo1xO2MgbsvM9j+5Zl+I7x+rZpeIGoWuJFdTLd40280icyChp4BMM12bgMVnEPH9CjDLnyCjdXA6YznNsoS6OHKMyZakFaoc0NHhYAOXSlalSj9QD7meEkCnxgTetfNXO0WWLtvR3dvc6/71YEi/v+q6RyFIdz8kNCBYSt8D8yLrbHznJfFOK4N9OnjD8TOua2OUppe+4uFbatw8kNHVMeM+029jTXupmrxvUdVIemdus+8j2n5ZTG+Yup8D6fARJBhMzURjdcNEqisCAeF57OLmiPdqTkJK6hGK/FNBToRZ2VRcv3+5aePlTTea3zsQ0QKxS34K6r9kvNAgXM1qFqXAMXM+Du7U5itdrDOVqJqSW6eil+zR5iiiekyGYKnLpUu44
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 08:29:50AM +0100, David Hildenbrand (Arm) wrote:
> On 11/11/26 04:19, Tal Zussman wrote:
> > On 11/10/26 6:55 AM, David Hildenbrand (Arm) wrote:
> >> On 11/10/26 12:54, n3rd wrote:
> >>>
> >>> Hello,
> >>>
> >>> I am reporting a security bug in the Linux kernel.
> >>
> >> Stop sending uffd problems as security bugs. STOP IT NOW.
> >>
> >> Tal has a long list of uffd-related fixes he is about to send out. CCing him.
> >>
> > So this issue was originally on my list and I had a fix for it... but it was
> > REALLY ugly and a band-aid, so I dropped it.
> 
> Yeah, RWP is a mess.
> 
> > 
> > I think the real solution is to just add actual markers for RWP and solve
> > all of these issues at once... but that should be a separate series from my
> > batch of fixes (which I'll be sending shortly). Is there a reason RWP
> > markers weren't done in the first place that I'm missing?
> 
> Let's ask kiryl: why is it ok to drop RWP PTE bits during swapout, zap, collapse
> etc?
> 
> https://kernel.org/doc/html/latest/admin-guide/mm/userfaultfd.html?utm_source=chatgpt.com
> 
> states "Unlike WP (which persists via PTE_MARKER_UFFD_WP), there is no
> persistent RWP marker today. The user needs to re-arm the range with
> UFFDIO_RWPROTECT after any operation that explicitly frees PTEs."
> 
> But requiring the user to re-arm is rather questionable design if the kernel can
> just zap these page table entries.

There is no need to re-arm. 

Once the PTE is zapped, the next access faults, and userfaultfd already
has a mode for that fault: MINOR if the page is still in the page cache
or in swap, MISSING if it is gone. Register the range with RWP|MINOR and
the first access after collapse, shmem reclaim or MADV_DONTNEED arrives
as a minor fault. The monitor counts it as an access and resolves it
with UFFDIO_CONTINUE.

That is why there is no RWP marker: MINOR already covers it. WP needs a
marker because MINOR would trap reads as well, and a WP user does not
want those.

Anon has no MINOR mode, so there the bit stays wherever the page
survives: it is carried on swap and migration entries, and anon
collapse bails on uffd PTEs with SCAN_PTE_UFFD. MADV_DONTNEED frees the
page, so the next access is a MISSING fault.

The report registers RWP alone. That is the only setup where the access
after collapse goes unreported.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

