Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2596606A329
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 12:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AbFmM/nq
Received: by kanga.kvack.org (Postfix)
	id 0880D6B05B6; Mon, 26 Oct 2026 08:12:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05FEA6B05B7; Mon, 26 Oct 2026 08:12:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E90896B05B8; Mon, 26 Oct 2026 08:12:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BF1616B05B6
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:12:28 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 52605406F7
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:12:28 +0000 (UTC)
X-FDA: 85364665176.25.E5765A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7B5F0120002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:12:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AbFmM/nq";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793016746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6qj8m8z1wbRyIk6+/HP994xBD+OWRY6Idbk7+z+pqbQ=;
	b=vh8Rk8T/nUK0+GTmaRDGG1MU9U+GfYqXP5F8msy/oPTVnfbQ3R6TN+3r4r9GiJN3bijd02
	X1KmbpD8HmSn8DyknICTANfr6ieBpLSTmJUOvIYIzfEGPvaUqORIxBxzL1lEt0Gg7qqAa/
	H7/EznaLyfePN8KFi9bUTUVwJ3uJdsY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AbFmM/nq";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793016746;
	b=RVlOeMdYFwOR1Qx7RNmabGhnYOH8yZkIKXWjQ5VeP7fi8W7tECL/uYM4Dc6Hlptu0i2PU3
	dRxMPr2nznVDmVMP6IyLiXIKrG9zpBCy4y/yrRtR2WeyNalnKpjsgpjS2cr+m6agvcnHtb
	IV1O2ujZPhTkRd3Hz1IGUAxNdPP72yY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BC4F143E13;
	Mon, 26 Oct 2026 12:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6CFA1F031E3;
	Mon, 26 Oct 2026 12:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793016745;
	bh=6qj8m8z1wbRyIk6+/HP994xBD+OWRY6Idbk7+z+pqbQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AbFmM/nqEku80UT+Aw7V4iA4reTs6onG88eMdzcmBom8o9iffpHF/sioYmaT8MFxS
	 LtxEjSXM4LrFlC9dmF1WxtG5wWM5ScaShfstE/EfTPFnEroTAzaqvaVB/nvIHa3+AH
	 4zDgcBgJtT+PVaa/K+cc2GU+45UEeNZmfpm9XFddPWcMaaxD0yOcaxDjMtqh2b4rkZ
	 RJYozXPKbhWQCK5W3LEtL7Q4isI94VLRu+djE6ouv7LG3VcAcRDhr61UVV7ozu24bo
	 i7U7SJrXOA+NSjKiHxDwQk6QodHCsJc1KAfo8LO/Kpw2Ya3dK0XfB/CrLALFZbMXy6
	 R3tK7qaGprDsg==
Message-ID: <3be96a1c-7cfb-4cd0-a4fb-16209494d041@kernel.org>
Date: Mon, 26 Oct 2026 12:26:39 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/1] khugepaged: fix readahead lock inversion in
 collapse_file()
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lance Yang <lance.yang@linux.dev>, Pedro Falcato <pfalcato@suse.de>
Cc: akpm@linux-foundation.org, ziy@nvidia.com, liam@infradead.org,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, usama.arif@linux.dev, kas@kernel.org, jack@suse.cz,
 djwong@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 hch@lst.de, syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com,
 ngocthang2710.1999@gmail.com, willy@infradead.org, rppt@kernel.org,
 ljs@kernel.org
References: <20261016065920.4153-1-lance.yang@linux.dev>
 <27e5aadc-2d68-428f-a958-308e4a75c058@linux.alibaba.com>
 <atICp2NL8j2z7UFM@pedro-suse.tail5790ac.ts.net>
 <atIiR1NWNssDvgt6@pedro-suse.tail5790ac.ts.net>
 <6a005d89-df5b-4524-a4b9-c637cb15f1ee@linux.alibaba.com>
 <cd6637db-7b30-4cbc-b07f-c2a2b32480fa@linux.dev>
 <b1b3d8d7-7201-4b75-a0f0-af383d854279@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <b1b3d8d7-7201-4b75-a0f0-af383d854279@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7B5F0120002
X-Stat-Signature: j4f3z631q37nomtrnimum7ugtxjenype
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793016746-254701
X-HE-Meta: U2FsdGVkX1+9dFxEx1I1S+uAvvykZc+xlDx9ywwfAgxjsIlCOIWhPZnqLLNdgICbbNAbFhyO1xA0QBw3exhXyDto6ZHVK6/5yjDvwbvGcLwJ53Rda89sFo44O5UYZG6l4yirPQ1tulgnPQ9HDpocQUaaV2vtR8dHe1W/zH/8s2C6rX+kxWA6iNDZnkhTKnuwWkFWtiB5edCp/4W3H9XFaplZCCraYtk8pf+8BgSuMJUZdaN6AsNcAOY2dREe9yZGUq38EHxviRlwAL7qRSwN4NbdqO/bkG0GvwugzRqRjKcYttt0LceoyKP902dAzPi5OoJOFopPigapVFXrHgukK595+OdJfuq4RUU3DrkP6Vyn7XfLSoRpmKMoxxBLckAMdo0duZdiHrYLFKbIqmRJu5b1zY0J9o9J8+PfJr+TPTyaiO6JHgM4NFGS0d6BwsqzZ2uRSEr+kA+WxVoJYR4h6qmFJpHAQvZeXr0YiaflyXhZaibk8yrFCaMyF/3un6NLgkAbijlw5GoI9nWaiBSEmTNrknKabFxEFJ4LpZg9PdeQcwR5HdG9aKQf3rdDYKb9NI1b6hb2mzI7Mm1sMpK9QVl+X00djoxMeeXUONpx1JSb+YbEdeQWosHgS5mIwmYfBKwq6xviIsClro9+4KHmTseD/IHS+nO/G+Mwqh++UNtSn7HV043pcP2/8H2XhB6YVj75ZfDhJFYFmRZq8+2m5TxO9Oxad/xQyYHRsz+j3Ko3JX1aRrqaFFNzl48NzKhiYDUwruy/YPDuU3nslFVR0DExlqrqxiPPa+fVQtoCjzJRsBKTormyW3Ws52WrLVM9HfocDLl05gy7gQbuP1V6TLf+Y2Kxi797SvEHfhWBLkgWyVXpn8Nlf6W2rAAg3LGwsWxUoNDQ9Qm3/WlUdU1FJT5AMN6PCINc9aPB3cnt26lyapSNsGzHtAoUveIRdmUePjBrpw4ca6tJNZ/wXcQ
 vTaCyJD4
 lZZ/ESMX2u4MvclYa5Y2z/fT/Nh47clNHog0E5kbJQ1lOSFLcg7CzqXJwrizXtFe+rfYazqjBGgogk+qehHBsyZbIV6Kly65Ysc4PMeEdAueB0z4Wiiw40fgHBObvX72AcEnRhWZsqhiSSXqbwIWERCT/PG8J1K5hePo5p4JQILvPlnXLN/gQWWjBcw//GhtsIwWLenO3cIyxKkRgooBOf7MeCDH4YBaAkWFIg+p7ABOKlcKjj7Vs9iVyCtSMu7a498DA7dSE32el3QqUgzKIjCUa+q/+o8ubOpylD0TUJpYAxS5KMoHRAcVyGI54W8XVHOPRdGJpNat/UIpXc5g+YiMEISZerf6F+N6ZUCcsrY0XzNvt3eXdg3Mojs1F6hMsP46Ryu3cmMu5EpRep5M/SlyAPBLQoD+Nv1CgzdYEyI6PS011tWYEIg4SuTGGVlw0ybyd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/18/26 04:47, Baolin Wang wrote:
> 
> 
> On 10/17/26 3:41 PM, Lance Yang wrote:
>>
>>
>> On 2026/10/17 13:43, Baolin Wang wrote:
>>>
>>>
>>>
>>> OK.
>>>
>>>
>>> Sounds good.
>>>
>>>
>>> But why not add RA logic in collapse_pmd(), as we do for
>>> SCAN_PAGE_DIRTY_OR_WRITEBACK? There's already retry logic there, and this
>>> would also simplify the long collapse_file().
>>
>> That would be cleaner, yeah. Some older stable trees don't have that
>> outer retry loop, though ... I'd prefer to get the fix backported first,
>> then move the RA/retry logic out in a follow-up, wdyt?
> 
> IIRC, the approach to bug fixes is to fix bugs properly and cleanly for
> upstream, without being constrained by backporting requirements.
> 
> Anyway, I don't have a strong opinion on this. Let's also see what David prefers.

Let's get this fixed in a acceptable way in a reasonable timeframe; it's been
broken for too long. ... and follow up with bigger cleanups later.

@Lance is this version good to review for that purpose or are you planning a resend?

-- 
Cheers,

David

