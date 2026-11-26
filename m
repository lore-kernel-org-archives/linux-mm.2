Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90B49606A321
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 02:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MgkliDEz
Received: by kanga.kvack.org (Postfix)
	id B07CE6B0B53; Wed, 25 Nov 2026 21:04:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABCD16B0B55; Wed, 25 Nov 2026 21:04:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D3AB6B0B56; Wed, 25 Nov 2026 21:04:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7198D6B0B53
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:04:27 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E1C56120249
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:04:26 +0000 (UTC)
X-FDA: 85475625732.15.AA2A1D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4AC92C0005
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:04:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MgkliDEz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795658665;
	b=AKpcs0ppxJVDFKhboC08bO+VVTeTYmlZw5egB6b3llG/4y7c62MNFGEvpILSMKUm7kuQ0s
	U2VMRQ3+14yXfeUOyyGMDCpzWvg9dDmYbpB8KckbRFRCjuLFqirq3ZlGlPnmzJNZfGjlkv
	qAb3SAb8kt6+Ehaq3PNucd+KqoCyFEc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795658665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=liXpri4l+8f0qFYwYuywNL9hfYgq5mI2uGuMxDVOQ14=;
	b=iauZWsXOyNEH1bu9suNhtDC24UqMyscMgDoaX4wEeeR7Tx3AV7T1EoIC6noTsKWUckk7Cb
	irKD/YtgCEEPftZOIEPxZRLvUFQk19pnUqDKCOVfTn6AsVsbA4XItrLPCu5kA2zJsyDo/q
	JrzsSiYXEqXmKTDgTheWJcZycTns1nU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MgkliDEz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A9CC1623F8;
	Thu, 26 Nov 2026 02:04:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A8E1F000C6;
	Thu, 26 Nov 2026 02:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795658664;
	bh=liXpri4l+8f0qFYwYuywNL9hfYgq5mI2uGuMxDVOQ14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MgkliDEzz48SDtPEkoj1EzzSbv+0i+SwDuizIFFidXAbXKbaN9ogCauoDp4szR61n
	 pld4i/EA5lgSprrlPKu3sipbIAtN0nQkVhPi8saJ6u8AqX8sETALWfR3ff00XbzUHW
	 Q2UtEe7/QFvLqF6YzOGZCKQ7GonA7VIrhH2ekXFjambZEJ5akMBR99FQtHRn0b3OI3
	 Tbs1rQnNUF1ac0fSfPel71yx8RhtNY17o5XmklfN87u/1MVxSF7E4K/GckW3+FlfDJ
	 uMeF29fDjLSLXyA2qzBchiqFi/DFfQOSZWlACZXV/CVhBq9+ITmKpDDFHqiHDCl4+3
	 9opDI4xUrvhpw==
From: SJ Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 00/27] mm/damon: let users report their data attribute findings
Date: Wed, 25 Nov 2026 18:04:15 -0800
Message-ID: <20261126020416.87656-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CALa+Y14BNfdWH3yBY+ky1+Sb0YvRzW=gRcKKyGWWaBQkysPUkA@mail.gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xck9hh1n3x4xtf7kar1nmoxfdwtep63t
X-Rspamd-Queue-Id: 4AC92C0005
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795658665-223173
X-HE-Meta: U2FsdGVkX190GhKO0e2GFOPB7DuF/Z+6UiB6ng0CpBCgs6Ca7jJLgfhP5znes2++vNdId7sfQ9fGmszV40XpJfGjqDyEW3LH60dkVCO3p2k0FhH30FtLMHiRn7qQF/vNeY9mAt+nefP13djdM57GEKQZNzOJ2fJahOH8aqjQvOEq3fkTVMxEeZSCWb1BAzAVR01JTxRi6/VdiXZKG71PX1zLMkLAEuH0RF7XUVWIm2wU4IpH7eqoeprbJDRtNLE7tRu3UjjKEX8pqYUETG6w93VodluthYYwL+fs+Va0mg/jLR8vk8m51yW6Vl/AK3Jv+s1+T3v5LAZX6lCWa/gEPM0wt3OUjyDmvg1zxxAQdgVuHNIHTqzGvFN4FDvfX+Awf06+XycRC1oYAQi2GoxAbM4pgHzFbQ9FtmaJA7BOt2UnKClQ8YRy7nf9u7Gi7s2T415ORiAsR8WIp3PpgkN0nksO8UacV1pM8pTxe+9VYnO5ifPJa4yNlbUfDVvTX/DNGIrhRKTLf9AbQN4z3lu68kJcy+WZk5SBbXdA4QPZBpKNu8Z2RRaH3ttZOxNzCuh7ZO2QEkT65WaBoiDeS5kvBbYh5V8tWOou4tfX1LWdy4uOlphnj5koGmZ6Dt5b42NpOYKXXQ9CQ/FX/tuda0xBwdg+K/PF6FaDOJRstCSMgyxyp+IVZ1+UGnzzF+rdESk/GND/RPGib14F5OQhVZew+xo3XEsqU98rsjULeyPF31KlskgeVc4tceHt0BLj57DvXt/pMJ/mHc06xUtPsfufh++cRQw3xz0M1br4YXBcLY92t1b9AR4UOMuhwBcyDOfIT2EYwXF7jIwI8EzJdwQh1feaVYWkxhU18AWsqAdy9OXxun2GYGUJIPvdldV5JOxf7qwiHhzLp74Dz58uy9qTl22SZNZkQSatCoe11Jjom4YFCABjS1FhEjUOpkAUxJf5csTKaTrBGwtWzP1k+jd
 s+rrkAWK
 sFiN/BAbet28fwNk6a35qCktRqQp5XjRElfSgWOCWc1Im54d9dg0OBnXUM9h5LFxImrhk3nzoLp9VMCA7zJM2nEkZEnUTenmudvlgxo04Y+GLKe1PP0im5J2oXo9arjzqTXae1XxiX6GZ4FIMq8fOcNXqfbUs95TMyt49IyqZQpJlLRSR3c+T+If4Ju3O0UwJsSXn9IxODi/5d8hU1OEcpderA9u/fXdX+QU+ye4LuZpAMQpfDVO5DHm2+E7wDvusRFBQot38pz5RNku3AxYoYwlbRlQDooNN0hTS4Zl3iBKofYIbjiJWAuo5V0WVcS97A3GJqqRC94Q6Fx354YjJkUurhy/PcXpeN3FY0nrsAyZKhesyWYlb79+jOq83+6Qmwsh8HmrQ4nAwFrIc3PS5GyOq5EM/4HU2Igv5GwVwOinqDVN0x9Dvy2GHbfOofN2Knm9Wom2b5oDCKlFQmsC2DDxENhoxZHyxBiStEZWNgUbCLzQMcAVYjDGotxeLxp3acV3LhHkkizWfe4tu+1DY6r+AkQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Ravi,

On Wed, 25 Nov 2026 14:10:15 -0800 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> Hi SJ,
> 
> I tested v2 as it is in mm-new, and wanted to share what I saw.

Thank you for sharing!

[...]
> 2. As the submit rate goes up, two things go wrong:
>    - with matching=Y, the probe misses the report more and more
>      often, although it is always there;
>    - with matching=N, the probe matches more and more often, although
>      it should never match.
> 3. Empty and inverted reports are accepted.  They never match, but
>    they take queue slots, and enough of them push the valid report
>    out.
> 4. On a vaddr context the filter is accepted but has no effect.
> 
> Where it comes from
> 
> Case 2: a busy report queue (13/27, 14/27)
> 
> When a lookup finds the report queue locked, for example by a submit,
> it answers "not found" rather than "don't know".  For matching=Y that
> is a miss; for matching=N it is a match.  The more writers, the busier
> the queue, and the more samples go wrong.

This is the expected result.  The implementation is more strict for type
matching.  If it is unclear, it says the type is not matched.

For example, if filter type is PGIDLE_SET and we cannot confirm it, it is
treated as not PGIDLE_SET.  For example, DAMON could fail at confirming that if
it was unable to get the folio for the probing memory due to some races.

> 
> The right answer here is 100 % of samples for matching=Y and 0 % for
> matching=N.  What I measured (the last column is the share of submits
> refused as busy):
> 
>   writers               matching=Y   matching=N   refused submits
>   1, one submit per ms     99.5 %        0.5 %          0.1 %
>   1, back to back          45.5 %       55.3 %          0.2 %
>   4, back to back          49.0 %       51.3 %         60.2 %
>   16, back to back         15.6 %       84.9 %         79.9 %
> 
> The numbers vary somewhat between boots; the trend does not.
> 
> Could a lookup that finds the queue busy skip that sample instead of
> counting it as a miss?

I agree that could reduce the error rate.  But I concern if it could make the
behavior inconsistent.

In my humble opinion, , the user could work around this issue by not submitting
the report too frequently.

But the more important question is, if the user really need to do this kind of
frequent report submissions.  I have no clue at the moment.  If it turns out
so, we could improve kernel side.

One straightforward way would be introducing a complenting type.  For example,
we introduced PGIDLE_UNSET to complement PGILDE_SET.  We could add something
similar for REPORT_MADE, say, REPORT_UNMADE.

Yet more possible kernel side improvement would be making the report queue
synchronization be more robust to contentions.

> 
> Cases 3 and 4: input checks
> 
> Two smaller things, both about inputs that are accepted but cannot
> work:
> 
> - Submit accepts a report whose start equals its end, or is above it
>   (22/27, 23/27).  It never matches but takes a queue slot: with 1000
>   of them after a valid report, the valid one is found in only 4 % of
>   samples.  Return -EINVAL for these?
> - A vaddr context accepts a REPORT_MADE filter (16/27), but the vaddr
>   operations never evaluate it.  Refuse it for non-paddr contexts for
>   now?

I agree this could be confusing.  In a sense, that said, those are working as
documented.  There is no documentation saying addr_start should be less than
addr_end.  DAMOS filter design documentation mentions "support of the filter
types depends on the DAMON operations set".  And the probe filter design
documentation says "The filters work the same as DAMOS filters".

I personally tend to prefer keeping code simple over making good user
experience, as long as it is not causing critical issues like crashes and/or
leaks.

If it turns out to really confuse users to be real problematic, we could add
documents or make code changes.

> 
> A minor nit in the cover letter: the loop
> "echo submit > producer_state" runs in producers/, so it fails with
> "Permission denied".  It should be "echo submit > 0/producer_state".

Good finding, thank you.  Maybe we could ask Andrew to fix this up, but this
might be too minor thing that readers could easily find out themselves...?

Thank you again for your review and testing, Ravi!


Thanks,
SJ

[...]

