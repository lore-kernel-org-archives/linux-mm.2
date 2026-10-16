Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32EABCC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 00:15:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF5FC6B0096; Thu, 15 Oct 2026 20:15:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA6876B0098; Thu, 15 Oct 2026 20:15:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBCBF6B0099; Thu, 15 Oct 2026 20:15:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D9796B0096
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 20:15:35 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 12487160284
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:15:35 +0000 (UTC)
X-FDA: 85326570630.25.C0069C9
Received: from mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id 926E5A0004
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:15:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kHwhn3TT;
	spf=pass (imf25.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792109733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wd1Wxj5QPAszadD/w66JNWguamzlLyv1NQgm/n3YS0w=;
	b=XUz+0BPcKxSHFTP9/qFqApl0qhBf1jyE8p9i2Ibo6Mc1bO5Wlix7+EUFppnY0DUOWfZ8ki
	HUaCOR+dPbUHrZKABdiu/i91LJ5KyW6Nb7rG77mdmcV9LtD+5PJr+m1HlZ8ftZhrs5rxUp
	iQx6PeWKcIJDFWoKCmqU2u02u5f1ya0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kHwhn3TT;
	spf=pass (imf25.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792109733;
	b=NrlW9QMlYbQPlNyjvLzyX5YuewseuzQLckJqO9YMlfL+svWy6L6SjNceU0dLwCI1Xa/0Y1
	oumK068H7ft+FpnzTjrwC3KTPzsG1IXDzwoI+99Zps9KV/MgBvUv/suGFQaGSDJiKSzrs1
	qlQp5aKePMaIiYVtyWHIKez4uMtjzdk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=fRHNta5IWp2UqpYEmjHZX4ckr3pgslqTuleelR2tINY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792109730; v=1; x=1792714530;
 b=kHwhn3TTRDrw8hijKmGdfPWF3KhtAP+PxC6H7P6jjvvQpMqk9QJhblmeBaiE3T2jlzh2i7iN
 psWGAw3gKVKrikamzn3xWxj6N3eRHyR5J98myY2Q9EULsWFPXlBMYPcLZuK4qt7HgR1pruYm3ex
 IJn2LaWAc+Tk7VXNmkVrVorI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 04647efe529ff507;
	Fri, 16 Oct 2026 00:15:17 +0000
X-Mizu-Trace-ID: 04647efe529ff507
X-Migadu-Flow: FLOW_OUT
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Yosry Ahmed <yosry@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,  "linux-mm@kvack.org"
 <linux-mm@kvack.org>,  ackerleytng@google.com,  akpm@linux-foundation.org,
  chriscli@google.com,  hannes@cmpxchg.org,  harry@kernel.org,
  jack@suse.cz,  liam@infradead.org,  muchun.song@linux.dev,
  shakeelb@meta.com,  ziy@nvidia.com,  "Lorenzo Stoakes (Arm)"
 <ljs@kernel.org>,  Mike Rapoport <rppt@kernel.org>,  Vlastimil Babka
 <vbabka@kernel.org>,  Matthew Wilcox <willy@infradead.org>,  SeongJae Park
 <sj@kernel.org>
Subject: Re: Sashiko change proposal
In-Reply-To: <CAO9r8zM_TfD82vZ23zwsd_pPLMpe11_XQhPEp5NDyhoPKDizag@mail.gmail.com>
	(Yosry Ahmed's message of "Thu, 15 Oct 2026 15:38:34 -0700")
References: <5eae44a6-06c3-445c-9508-58b372c01b2c@kernel.org>
	<CAO9r8zM_TfD82vZ23zwsd_pPLMpe11_XQhPEp5NDyhoPKDizag@mail.gmail.com>
User-Agent: mu4e 1.12.15; emacs 30.2
Date: Fri, 16 Oct 2026 00:15:07 +0000
Message-ID: <7ia4bj8ufqlw.fsf@castle.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 926E5A0004
X-Stat-Signature: ixhz98nptqjm8cj7jt1resyk6ywxqb1w
X-HE-Tag: 1792109732-17111
X-HE-Meta: U2FsdGVkX18HhqUebeOhX0OBf7XSGGN5l54q7cStCR0Up04CFeIHa+cwx0FNNTd8BKipSncjlxIn37IsV4DMCZU/tKIEC2DQmUC+bm7fme+P+HgcLeJ8usuz6r3i8Qo49GIYE/9x0BAmCrB0GUVZstU30IXxFSO2vBvtJYFJhYV9uVob3HhPXqBuuJpyFrb6hRcNd7i155Qpp25c/7zK81tYNbi5crqGOMAdUFYb4L7//9wgrtWX7SmRylP/ZnEaZdb2PRLod3e6lTOrowBHKfHvxtZt69X5XUZ/aI+mN6nQ88vIzMhjNzYWi+EtiuS00q7wiDQl9I6zWK8dZQvd0sRYr5VRSbfJ6/t0g2APF5Y8J/v37OC5Ebm1s/aQ86vJrYfp6oF8PLGkJusFXhUGyhghpQPHoJilCR4BwtMQJw3d/TtUsWVrwJgzBO50Ygnxadldl80Arse5OAUubVOpAG/X+XXFycLdCOjiYhbuUce6FSqEmN+VTMBkyFs8KiDZaFI0pBlONcPKAMcEz7v0N4IKiN1js7I12KvB5TbuEJUsNv9BgZerNSWXXW7C9saICmoZr2J16KprJ4xJ9AYaSDEYk/mnnknV8l1OuSLuZQ5fDsquyWDr5Y4wzAYaLKQDcMc0DFfS4VKhYKZzbuA8Qn3G+mA80Q6P2XqwhTmoJlYQftNqsMbpNK6qmv9mkeJgtqfpkL/3lAcX11vBSKHJt8VbBsgZS8b89yYlwS14owWKJEOTnAvMpdalEKxhZULEKeEt8IZpTxSHCUCqvpf4jfV5yLFtcr4PPaL+TnR3lXH5ZVopakhiuskLfM1SsP4ic0YnWaUQhsdLNO2dGu0RgMcBrlluBL9WoyLukl9D3VuI5bsee6RBTmIVDSt0B9Cyk0vpwUBNXAu2XkvSH/7ibeIj50ri2HoUeZu8gKsDB3XI6JIBLgdj5oL6iQE1XLBSf04Qr7lEyufnG2VrcY+
 tB/ufw7X
 kdYbmG7fUYUe/luoRmwvoV+m6pd9FPbwCSWoFJcllLzX3Gg0ggFlQ8RclGV15IVx1CMBVE15RrtJ3JO1/EEUw8E9yJh/21thdcfJyp/+hAFG43G/XOZVAGbX0Mll8OqhmVgm3D8dGssXMo01cAWKJ9hd+t7KBr51zZtWT8Ty2lz+4g4/f71lwJaDQknuiLRziDB644rXRAgcY0NdeuFlAlDajaiMvyxTZyqYUYKOyrTvvDtyv1XzIIch7xQjC9UVh2yp1TFufj6bBVNI7C1l42uE0zt2N/geZuIILqsyFs3jAyjxQ7ImNe3+B7GbMTc3iwlTA+/jakJ09V3QWdHVq1EtQ9mmB86ghr9Kd6IxPpT2YunhTPUZQWux7wBRT1kGMjVttBMlyLbJdUAwYV2GQ7+zKf3dYux8P8KwpgXlU2jimKFT3WYmO6lMp1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yosry Ahmed <yosry@kernel.org> writes:

> On Thu, Oct 15, 2026 at 1:38=E2=80=AFAM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> (CCing all people attending the mm-next call)
>>
>> Hi,
>>
>> After talking to Roman at MS, he just informed me that sashiko now has a=
 new
>> feature combination:
>> - "embargo_hours": hours before review is public + emails sent
>> - Mechanism for signed-in maintainers to lift embargo immediately
>>
>> That solves the key issue I had with sashiko: people/agents re-spinning =
stuff
>> too fast before a human at least had the chance to jump in first.
>>
>> I suggest the following sashiko change for linux-mm:
>>
>> diff --git a/projects/linux/mailing_lists.toml b/projects/linux/mailing_=
lists.toml
>> index a9198de..ba123da 100644
>> --- a/projects/linux/mailing_lists.toml
>> +++ b/projects/linux/mailing_lists.toml
>> @@ -46,7 +46,6 @@ ignored_emails =3D ["patchwork@emeril.freedesktop.org"]
>>  ["linux-integrity@vger.kernel.org"]
>>  ["linux-kernel@vger.kernel.org"]
>>  ["linux-kselftest@vger.kernel.org"]
>> -["linux-mm@kvack.org"]
>>  ["linux-nvme@lists.infradead.org"]
>>  ["linux-omap@vger.kernel.org"]
>>  ["linux-pm@vger.kernel.org"]
>> @@ -315,3 +314,7 @@ reply_to =3D ["author", "list", "recipients"]
>>
>>  ["fsverity@lists.linux.dev"]
>>  reply_to =3D ["author", "list", "recipients"]
>> +
>> +["linux-mm@kvack.org"]
>> +reply_to =3D ["author", "list", "recipients"]
>> +embargo_hours =3D 24
>>
>>
>> Which means:
>> - Embargo 24h
>> - Mails sent to everybody (author, list, CC list)
>> - No positive-review ("looks great") mails (default)
>> - No other static email addresses that receive a copy (default)
>> - No additional ignored author email addresses (default)
>>
>> I'd say we start with 24h and see how it goes.
>>
>> Thoughts?
>
> Thanks for doing this, it's much more convenient to notice and respond
> to the review when Sashiko replies to the patches.
>
> FWIW, I prefer no 24hr embargo, seems to work well on the KVM side --
> but I will take what I can get :P
>
> Reviewed-by: Yosry Ahmed <yosry@kernel.org>

Is it time for me to pick up the change? David, I'll let you decide when
the discussion is done or just send me a PR, up to you.

Btw I hope to deploy the new Gemini 4 Argon model really soon and I
expect better review quality. Also a big prompts rework is in the
process with a simpler way to put in subjective things. It will be
called maintainers notes. For stuff like "don't send me typo fixes
patches" or "don't use struct page outside of X".

Thanks

