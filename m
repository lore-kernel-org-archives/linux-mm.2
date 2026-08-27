Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B7C9C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 17:02:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3924B6B008A; Thu, 27 Aug 2026 13:02:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 343E86B008C; Thu, 27 Aug 2026 13:02:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 232C36B0099; Thu, 27 Aug 2026 13:02:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0C376B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:02:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0446C80143
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:02:52 +0000 (UTC)
X-FDA: 85147669026.15.AE30ECB
Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	by imf01.hostedemail.com (Postfix) with ESMTP id D88D640010
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:02:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="m yX0/GQ";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=HI4WaUrO;
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787850171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RaaPIMZeB2T5hMnyz0u2F3PP1cDWDmpQMQWXSASC5eg=;
	b=T83G0Dmfd0h/aRNHjbCa9RS9L5lIuNmV22mNQ6S6s+ihy75di2AAbsgFhsQuWbKhZhWjK3
	vXaE35ClrGh08U01SqN4ZFrZAGjMt+RfPP6iDqZAV+Fw9D0a/LQWk3XefMQbX33ifI4Qvl
	uFJK6lX5loMnwY4J830qghB2bX6+nng=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787850171;
	b=jIkhO01kO0OumpIAd1tff95SFjUXVtQugVodaPuD2w/biJVSo8VUeK2sRb5+6UYQAJx5bu
	0WH6xHjKXszB3rDcFINRUkhDo8CNQ9vz+sotxAz5JbccSHt5Q3iLRnoqOD+Q1ObyvcIEJV
	x3SOWz1ZhXvduiUew8suyaiJyNTJkdc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="m yX0/GQ";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=HI4WaUrO;
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.phl.internal (Postfix) with ESMTP id 2F82213801EF;
	Thu, 27 Aug 2026 13:02:50 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 27 Aug 2026 13:02:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1787850170; x=
	1787857370; bh=RaaPIMZeB2T5hMnyz0u2F3PP1cDWDmpQMQWXSASC5eg=; b=m
	yX0/GQ7HePz4bzgG1Gv/dTcg1UZluSBAEih0A7hqHRFHkg5QtEkzG2tl8je8/FXw
	QsB+yNs8zhGdjriusj9bcEyuyeTdTSDSKjYV77gLnyFRGgPwNK69liJbKauw73FD
	J1iEfT4dCc3TiE+GiNr8JAPsiLZm4cj2jngHVJyMtkHhZMqEaKTWg4y6hEscnk/r
	RsZwSVbIoaRVsOjdg3QFmFCrUUMaUJP84VEWmEeST+7xybrRNXfq2gn3SmxRpjaC
	zWptz1HON9y/Hz+58o4KA5YgvEnoNiaq55IuPVhyfb+f02TIkH8RngKiSsqJz6Iu
	2vsmuzq8Lcf1fG5iB94LA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787850170; x=1787857370; bh=RaaPIMZeB2T5hMnyz0u2F3PP1cDWDmpQMQW
	XSASC5eg=; b=HI4WaUrO64DRYwSFlxQTpqIT6MODUIaZ7sMXOCsov+CBVwKdMYG
	VsZy6TsWYqPJkZGBX2s2BopyjMYVZ9iUowWlqwPC8CKs1fbcOh7p4H1jyZ72lqez
	szMSDhzhMiHe1LydmmURZSCeYmxBxpm9ZigMnGZZOWx18PUmlNyxzad5TKdGGL4S
	6XH9KQoINmojZF1ZwPqzIgvt2+qLcDMhVSoU4Th6Cb6dTCR5tgVnc+Xrz/tRjxYp
	FydYOkWdFUxtAA4xTBhojDzKObm5KFGNRNG7HFD/X+bNi74zJaLtcm9eh+ZG9SFc
	URq6c3Z7UrDBVDoramjUoxmj4nmW/SQ7n/A==
X-ME-Sender: <xms:uG2QanlqGhlIiejEW7exXyXm-FGW8oGzNtT_QT77DL-6L4v3iMBI0w>
    <xme:uG2QapQc5dMTGdc0sbvK_EwoSzPkHxb_COD4kMBDopD0IYHHPs-AYQZ2hMkKJbKv6
    VY3pAgHRqbfGEtWvrxAtGOMVcCKztm7d30T-lY5AEyq2JNt0-9KAlRx>
X-ME-Received: <xmr:uG2QakyqFsCYGmtz-zqkjTxDl3rvmpE3WkgvZOG_VREx1mS5rk4zcp2mUxQ>
X-ME-Proxy-Cause: dmFkZTECvBFj4noXVxqIV/w9QY/YYN1+QqbknFxJP2iS0y3HzG7Mww8Bm4WPeuj3M5Px7E
    Vqlrc1OhMWq5ZBjwJxKvDS8Y7/oI5oZG9au3O4wsObaXhZHPYwb8lGOkb10tik0IIdFaiQ
    H8SU/Nplx8LgxPgiu6JVIpaiupqTt6OrIEzIIfYyQAvCTPl0g0s8t+QhGMNke8thlvDeBx
    pjo0BAArBZ+Orwex3MvK+qcneAm9b33PEvGXpdKFn8mJME/MplRa1AwN6m3/6IoOabO+f1
    2gUOqggbb0K6Kt9b5OEh0G0uK8TObvk/iFKHlBMT5iQfP7wL/F53E23ugA1kwb149nd7PW
    XbLtfwjVRvyB6S1HdwNVzSa5GyijZnxx+7KKqA82FRescFco1aUcRSCPavSSg/PnuZHuSD
    WGWt+rU1bBC5PaAN0MzBgXaxbP9yel3wA0xMA52Fm9LnL1MaW8MQe/kiSNO5g9bJAsI785
    AVn6dopBnGpPU31m80J6vChLqLlx1DXEUkAQs/jUBjPIEUKs8LlI/UXXAZS0Ssrezw2LSd
    BYL8Ey9/DkvAInufBO7EJPsmbxRvuU5pjJ/zQXUMi1j/2396RGsXjsoyPxGPcdMHweMswz
    ckiul6qKidG76c7f4aFX7+Wx9MJunEBzceMbn7cnctUGfiqP21dgUfPfZwlw
X-ME-Proxy: <xmx:uG2QajJ_8b7MNErOVlct-Njtf15mmnH92k6v640iHLCtay38dBv0Hw>
    <xmx:uG2QapMwFgW6u1dqJw6uL5I31QljURPjDeXa7e-DkW4dpr88ddA_Iw>
    <xmx:uG2QasN1PCbs5DgwPUkzO-pokdMaj7gHhS5IZyHpyLxndueJngm9Tw>
    <xmx:uG2QahIJfr3WDQEeQ9whsht7oxYBUqlZwklZ_6c3lRI0PqUVNnTwAw>
    <xmx:um2QatdxXNbum_t2ehNoSk4rIAkHBuZ6gaHCSe-8338ZGYS4GlLRx2G5>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Aug 2026 13:02:46 -0400 (EDT)
Date: Thu, 27 Aug 2026 18:02:45 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: kasong@tencent.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v3 02/18] mm/huge_memory: fix rejection of swap cache
 folios with a mapping
Message-ID: <apBtGfatUUecH6Lo@thinkstation>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-2-9b43f5163238@tencent.com>
 <50bb70bc-d442-43df-ab4f-a158c8b05ac7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50bb70bc-d442-43df-ab4f-a158c8b05ac7@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D88D640010
X-Stat-Signature: q4b1b8auqbxpistzkkf5zp1qj7zss6b9
X-HE-Tag: 1787850170-209481
X-HE-Meta: U2FsdGVkX1/Yi4p6NrKbBhPK5V322PoWKQUjSUhFBuV2mmIneLesChniWcemgDZiYPVM2F+zHny5NJ1UkdTPCtlBEwN63tt5OBbsozegJRRrWaYDjz0f6HB+UUk8x8nQJdyKBQoopplry7CuInZOMvUlmWJM9Xy0NocLMvw5fiEnMlHWR43yUtbvcObovqBAkZVFPO81KxyhINTBumhONBxO1WSt6r5m3trcdmwhEikgEjr19eANpn4N69VvYNMqm4yWbCreSrxBxOOq+3c+D0LizQg6IEFVWAU9sam0aC4lCqgil0N005qzVxDE9bdj+Kx3fVeD22bFfM0Px5UCazz6ivy+T6XUd9KGPonzLi+0UZOFhvuiJ1N/R9S3jjia+s7tOqaMaYb75qO8f/EMzktA5a30QizwhA1rSYWGr11HJ+vP3rrg6I8mcPDnza1pug7NXR+DgIkkuOatu614m5HoCpgRZoj+QXFLTSZYAJbetIBhUHLX1JZ3klhPzs8tKCHtzBwAjWAHzhBYdXm+cMJjJAA7kYWpAGke87cdym4Yo00sa9vfEh/X5tA7IaNu4ZdR0xXbDnh7kIKfEVIlYJcpWfAgK9Vh8GA0ts1V+Z9t/ROMYaFAtqdhdS1kzelgY9ta9TsmMr/9WXx/aC0Hf18SlDacgHph6oRp+o6oMBe/m3s117uXCihX5gqzKFuA7/guGvvrSXZlRXFbpL62HMm2O+NksVXCx+Ne7kAXiWecdDzwul8a18g3wZqLUBa3XVIdpoaZpvbcyQX6fCb2YIcIRFkNPbmQ23LgZAksr+BUGGndiLlxSQTZ3m+ATX0lqJ2SddW9/4WacaBS7OzE6gRoGDkFo+ZrRImpzeIpD5tl64lEg+vdbNIFo+pw8HEDkbZCQTjA09bBqWo4HjkClcsVaG0ktmWu1TRX0ykabS+ixsJTAIdo60z4e9UDFVyhfiJOF1e7FPjGeU+phj4
 fk5GLE+s
 i1BmYefau2taJAMSBncEz3LguremNWWm0/4Jfi62CHRE7oyUDR8HOqVOaerDTtB+Stcgb3H6eB2PQP2jbO+7wTW3nbnMEi0TmeM7gDPGpYNEfGqm0uRuXK6znW/iZWkERVQnCbxW6VbU5dLWt9pP1MWZF8z0+U/Fd74Wc5pLQXknTMXz5V0r+PKK77N71iLi/BOz/T+R+pVkEfZ3hiFz7VswocwjiV40gvsYKJri3Uv9IwD2lyAQ220+0+1fpct0Ue3gHFJVlJq52XgFX1IM1N5RTYeJb7JEueu5VcZJj1vaNFymTLazgLZIjVZ+4neKMvjYLq035LtUVY9kE+na/AEvrhRE4T7gnI+XA1dC01zFpkspSB/Ruv6qg/aHFAifBa6UqDCxm8AZYc/Es9bz+kwmjhNkNbHyHCwVc4oQo/MDOyjnuJciTSszgnfWLTtoEfg3l1j1I9djtb1ILopYCF2gWH5vjZxPM16FU5kyfvUtybUTjD/DVr4Kt7k17Fli1pLD1aBPHcCfqxkoEx7MtbiqjItp2ZAQ5XpjY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 06:00:33PM +0200, David Hildenbrand (Arm) wrote:
> On 8/20/26 20:55, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> > 
> > A folio in the swap cache cannot be split if it has a mapping (shmem).
> > The split code does a defensive check for this in
> > __folio_freeze_and_split_unmapped, after the folio ref has been frozen
> > and the NR_SHMEM_THPS/NR_FILE_THPS counters have been decremented. It
> > rejects the split and returns -EINVAL without unfreezing the folio or
> > restoring the counters. That error path is buggy: if it is ever taken,
> > it leaves the folio frozen and stuck, skews the counters, and fires
> > the VM_WARN_ON_ONCE_FOLIO for a state that is actually legitimate.
> > 
> > Check for this case up front in folio_check_splittable and return
> > -EBUSY before any state is modified, so the split routine always backs
> > out cleanly.
> > 
> > Also fix a bracket style issue that checkpatch.pl keeps complaining
> > about.
> > 
> > Fixes: 00527733d0dc ("mm/huge_memory: add two new (not yet used) functions for folio_split()")
> > Fixes: 714b056c8321 ("mm/huge_memory: convert VM_BUG* to VM_WARN* in __folio_split")
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/huge_memory.c | 27 ++++++++++++++++-----------
> >  1 file changed, 16 insertions(+), 11 deletions(-)
> > 
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index ced400f72d43..a6759a14e057 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -3878,6 +3878,9 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
> >  int folio_check_splittable(struct folio *folio, unsigned int new_order,
> >  			   enum split_type split_type)
> >  {
> > +	bool is_anon = folio_test_anon(folio);
> > +	bool is_swapcache = folio_test_swapcache(folio);
> 
> Both const please.

I see a lot of const everywhere in mm code now. I feel I missed the memo.
Do they make a difference? I was relying on "Compiler does its
job"(TM) for things like this before.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

