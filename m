Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBEB9CC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 12:15:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D72716B0088; Thu, 15 Oct 2026 08:15:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFC496B008A; Thu, 15 Oct 2026 08:15:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEA476B008C; Thu, 15 Oct 2026 08:15:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9C6E86B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:15:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8452CA09FC
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 12:15:25 +0000 (UTC)
X-FDA: 85324755810.16.82F68DB
Received: from mta1.migadu.com (out-231.mta1.migadu.com [95.215.58.231])
	by imf20.hostedemail.com (Postfix) with ESMTP id 47CDA1C000A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 12:15:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sBTDHNfj;
	spf=pass (imf20.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.231 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792066523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dFQqDFSLWUX3qNLMd4CipfmTp+6GJjD9xzB+HPh8pJ8=;
	b=0JC8qaVjdWDMuKMrJIak+yzCwMlifBWmoFLHUcunmVaejMUhyyJPZmytZIY23HNJdfleMS
	zIa5pdr/eit0UdIRsCm13wobnLHQuF8dCeC2ELPMLBfo8cne3EQBE/8BJtawSj1KI3dsIf
	TxwQJr8uspdN2ULnMAu9RB//Vv3cfDM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sBTDHNfj;
	spf=pass (imf20.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.231 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792066523;
	b=Wv6Mw5FEj0GuOX+8Ctk2CgtR42VA/MJhSgQ2Ty1gjshkf4r1Tpv/mYkQr9VCMfQ3CcaBx4
	0ENAZM7SU2Rq8fTNOWxWv6MG8eOA9y0U+Pwj6CKW0ILTyYbVdXO/rbMrMbIwRyXrHSFR3C
	rnXlNdcLPIBAN7T6M7+UUk7rry4yaCM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dFQqDFSLWUX3qNLMd4CipfmTp+6GJjD9xzB+HPh8pJ8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792066521; v=1; x=1792671321;
 b=sBTDHNfjs/AylhQgBwEaBNy4rYnLjRFHmyT2SN2Lr2Ua5bNVmlqsnUdtPtFos0PskvnLsssU
 GZxq0kJp5Rcwqc3zSsiVE+G+Drt57KAdDVTgP8hOmONbE965jlWxiy34NmhuYIUE+ChuHeuK3gE
 KIKlpkL4KklkI2zHkPHSRHnk=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 03566d34a598d7b7;
	Thu, 15 Oct 2026 12:15:19 +0000
X-Mizu-Trace-ID: 03566d34a598d7b7
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (1.0)
Subject: Re: Sashiko change proposal
From: Roman Gushchin <roman.gushchin@linux.dev>
In-Reply-To: <atDBk7ZKfDtKQKTT@thinkstation>
Date: Thu, 15 Oct 2026 05:15:05 -0700
Cc: David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
 ackerleytng@google.com, akpm@linux-foundation.org, chriscli@google.com,
 hannes@cmpxchg.org, jack@suse.cz, liam@infradead.org, muchun.song@linux.dev,
 shakeelb@meta.com, sj@kernel.org, ziy@nvidia.com,
 Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Matthew Wilcox <willy@infradead.org>
Message-Id: <9139A421-50DE-45E1-99D5-4EFBD4225A98@linux.dev>
References: <atDBk7ZKfDtKQKTT@thinkstation>
To: Harry Yoo <harry@kernel.org>
X-Mailer: iPad Mail (23G90)
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 47CDA1C000A
X-Stat-Signature: hf4hw6zwqzpgttfsrkn1ft89yr6rcr73
X-HE-Tag: 1792066523-391951
X-HE-Meta: U2FsdGVkX19fHGYwx0C8BS41DoUx6HJoohpulL322mn0zVIfnLxqApUFbrlKYidhhInVlYyXTh0jzqAoqvJR8JHKzrJYExJrMoshohVfSDjsIwtdPsRiV4MVcRmjNi7fcuqmRIEsq+SrF/3OirI0NHmMFFNitPw4dliaAwD7iotVuGSIu5cNG/iX64gBp04RqUOMqMfYmi9Y8uwX1YJan3nWFcXnGwcUDTi3iukIBU+me7ruVtmggVosdVGt3ILQA/iwU9DsHWNUjgKAYCSl9JleZiba7/h1TtoWNQaHKWsq0MNmcz1ZeUze3fIYEYA8B6wjKoJNqA/K39qfgbGNrvFBX2SJOGKICeBbYEstPreaWt1WwsZyN8bCp7naDCnJFg2TJ8nAwvGjhzda5VQyt1lIGImtfwxSYKD4/gCE5jG8IjyNsL0ZPc1qkfNlu2BSq8jd/NeDCUwXtdqU6HvuVZwUA8ZY1iin9XqEct/uR+NrcMSGdNen55CHrhNkPWYNya90WkTmn2iISLoMsMEHRmwWwGQ4J62mzavjTx9WwgmFfrtyeqN1ecncOv/6qgj3nm3T1OtIX89XxVry6ird7o/uG4bJ83vUjLz8fLodoNPbQhW7DtwXrrlEVU7n9xkrOrbd8Sh5cBd5+1Cx8/Y6rU1HDezTA4Vhx/cfzHBi+RZJGoFGrUlG2pZvJc/WQDthWshseIw1/Y5z2Qf1CmdTQsLB4KN5eOtBY62zflD+rItwHjcOE6qMGRM+danRYzw/KG9PcMD4fT6M7A7ZB8gdYHrIDKhyRul3g8T/e32kz9T4LucXGEIsrglX6ZltM5dEQqHFeR2+ivCY47H2r7Ato851gzFEESVNngXqb73cFk+lMWfEGI5tLsfBcDCMQwbeLC2de316AB5ab6oNAeCcJMnx2vZ5WTiXEpNUR1/BcsF3ZV/+ZfEBZleQyFWEzWhGr2w46TBq/yJA2j5Md77
 OZkZnfU0
 rcf7gV1w7lTASv9XmCenl+/mMwztaiHsuOAGq1YccdIr8ha65nb3j8DZ8Za3bIjElRhD624AmMCkp3A6Teb3TEnI/eiMDOa+xJlNDN1UL7nPR3b0riK8ayHiQOto+AUvc/5DL1faD1GzVR34k3wZgteG5wluz6lJ+/IJKi0yqn7wyZ40ZQ/+9L85bUVVXgviiMGqEyMTWqzODsYw6O5vMXDxPLCoyo2oSa7U6Dhnfm/crABinKpBiqOzaooViuuyy1OKDvJPd+6VaMhEaHOEgC9HNQhn0Cc0A8mkp3hRgY899qa6gMWUaKfnVn2mqPf/R+cHNhSWvJpqWAYCD/cgSlWKvPsEzaRZepyIdFEAtLS0jg/fa8VxrLxTNrmOWGQsdymQNgtLt30cGWN3rZTii6riK7sJqapL37SumlZXFLxJaNIouLN4V8FF4IK9ucJQ8ueW23HRCZYFnqwQfQNZgl0BBoKMGoQZ8z8h9qKCA1dNNO/o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Oct 15, 2026, at 5:08=E2=80=AFAM, Harry Yoo <harry@kernel.org> wrote:
>=20
> =EF=BB=BFOn Thu, Oct 15, 2026 at 10:38:14AM +0200, David Hildenbrand (Arm)=
 wrote:
>> (CCing all people attending the mm-next call)
>>=20
>> Hi,
>>=20
>> After talking to Roman at MS, he just informed me that sashiko now has a n=
ew
>> feature combination:
>> - "embargo_hours": hours before review is public + emails sent
>> - Mechanism for signed-in maintainers to lift embargo immediately
>>=20
>> That solves the key issue I had with sashiko: people/agents re-spinning s=
tuff
>> too fast before a human at least had the chance to jump in first.
>>=20
>> I suggest the following sashiko change for linux-mm:
>>=20
>> diff --git a/projects/linux/mailing_lists.toml b/projects/linux/mailing_l=
ists.toml
>> index a9198de..ba123da 100644
>> --- a/projects/linux/mailing_lists.toml
>> +++ b/projects/linux/mailing_lists.toml
>> @@ -46,7 +46,6 @@ ignored_emails =3D ["patchwork@emeril.freedesktop.org"]=

>> ["linux-integrity@vger.kernel.org"]
>> ["linux-kernel@vger.kernel.org"]
>> ["linux-kselftest@vger.kernel.org"]
>> -["linux-mm@kvack.org"]
>> ["linux-nvme@lists.infradead.org"]
>> ["linux-omap@vger.kernel.org"]
>> ["linux-pm@vger.kernel.org"]
>> @@ -315,3 +314,7 @@ reply_to =3D ["author", "list", "recipients"]
>>=20
>> ["fsverity@lists.linux.dev"]
>> reply_to =3D ["author", "list", "recipients"]
>> +
>> +["linux-mm@kvack.org"]
>> +reply_to =3D ["author", "list", "recipients"]
>> +embargo_hours =3D 24
>>=20
>>=20
>> Which means:
>> - Embargo 24h
>> - Mails sent to everybody (author, list, CC list)
>> - No positive-review ("looks great") mails (default)
>> - No other static email addresses that receive a copy (default)
>> - No additional ignored author email addresses (default)
>>=20
>> I'd say we start with 24h and see how it goes.
>>=20
>> Thoughts?
>=20
> Acked-by: Harry Yoo (Meta) <harry@kernel.org>
>=20
> Quick question: when are maintainers supposed to lift embargo?

They don=E2=80=99t have to: it will be lifted automatically after 24h (or wh=
atever is configured).
But if you as a maintainer has an immediate comment to Sashiko=E2=80=99s rev=
iew or you=E2=80=99re ready to pick the change, you can lift it immediately.=

And of course maintainers can see review results immediately.


Thanks=

