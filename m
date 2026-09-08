Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72C60C79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 07:04:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BCD26B0095; Tue,  8 Sep 2026 03:04:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8949B6B0098; Tue,  8 Sep 2026 03:04:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D15B6B0099; Tue,  8 Sep 2026 03:04:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 61B006B0095
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:04:22 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DD050403EF
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:04:21 +0000 (UTC)
X-FDA: 85189706322.21.F7389B5
Received: from mta0.migadu.com (out-220.mta0.migadu.com [91.218.175.220])
	by imf25.hostedemail.com (Postfix) with ESMTP id BA726A0007
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:04:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=wyuan.org header.s=key1 header.b=YHq6NA4d;
	spf=pass (imf25.hostedemail.com: domain of wy@wyuan.org designates 91.218.175.220 as permitted sender) smtp.mailfrom=wy@wyuan.org;
	dmarc=pass (policy=quarantine) header.from=wyuan.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788851060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fxBDo1fPJj8sCgf99NiKDqLk3Hd1vAViyxx1K6IoNOU=;
	b=SFk9WsSBhQFEYaUQIDidqEG/FvfGj7xfh9al6yjftizSB1jnzd5f5AfDOFYj60OptJkcPW
	ubiJzB0BExEWVOjI5/fuEe6nk3AdaU1doSc3ZHmeSMUJYR1l0BlSyjG0L14gKxgR5/obBv
	iHrDm76qHE/yvOh8gqqRqSZpLWzIxqw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788851060;
	b=iE4/BC6q9kFhHy/uO8RIEKbkVqx++LxfHzbrnK7+p56z5POOq6H4wDUCy73P+v1bLmObyj
	FKKkq0dfqHiNJWqtAN2JTEecBRvRhRcTi1ciwIiBy2FnNoCh6jA+GBrnuuypyqUW2N0tr/
	mn/rqNsW7PwNrxMha94DPoJu75QDJKc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=wyuan.org header.s=key1 header.b=YHq6NA4d;
	spf=pass (imf25.hostedemail.com: domain of wy@wyuan.org designates 91.218.175.220 as permitted sender) smtp.mailfrom=wy@wyuan.org;
	dmarc=pass (policy=quarantine) header.from=wyuan.org
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=HzjFTUzM1h8cKJKoYfscrnzwWcTkdgUAux0H+g1d+hY=;
 c=simple/simple; d=wyuan.org;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788851058; v=1; x=1789455858;
 b=YHq6NA4dy1BvedmUYoV6pFx7iMGTguTfbNg1KKuWI5CWCwrL/N1G2vynZcVcCtWGiKRjakM0
 bisyRJmjjFKfJ/RiBuURiMMjdkR60ME+O28Kvi+5IsXZN+jUq9lPQiysnf0j60hzm3sYn2mwhP3
 Vyi9Pd3gwq1OHobwJoUPjUH1XGHQpnETOb2lr+KLkhXpU0K1AkXqOTVH1NlhQKolJclCVpQpaAB
 O9Lg8pm3xNSvumCZXJFtApjHVLMserY7FPe6+OA+JBuCH9d7DAoxUUxL8T2+KK8l6ANmaT0Qc/l
 lIt9N0iF3W1yCsaSGZzQzdgk1znu2SqPHfzbeYYRP2j8Q==
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id dade2e651a255ea7;
	Tue, 08 Sep 2026 07:04:07 +0000
X-Mizu-Trace-ID: dade2e651a255ea7
X-Migadu-Flow: FLOW_OUT
Date: Tue, 8 Sep 2026 15:04:02 +0800
From: Weijie Yuan <wy@wyuan.org>
To: "zhen.ni" <zhen.ni@easystack.cn>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 0/8] mm/page_owner: Add PID/TGID/COMM and cgroup
 filtering
Message-ID: <ap-zYt-1qCBGKZed@wyuan.org>
References: <20260903041819.1776630-1-zhen.ni@easystack.cn>
 <a6ce8684-116b-42f2-a88c-154eb86bad59@kernel.org>
 <a98bde94-d1fb-4246-b7c6-e64303d8388a@easystack.cn>
 <5d4c247c-b8ea-4d3f-b2b9-d442d372fd03@kernel.org>
 <6744bcdb-3456-4ba2-95a0-a58c354bfbfa@easystack.cn>
 <ap-qDThi-NQgVXVD@wyuan.org>
 <048d7470-a813-4252-a4f0-0ec29694f639@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <048d7470-a813-4252-a4f0-0ec29694f639@easystack.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BA726A0007
X-Stat-Signature: nmh79e8run88rabujfzi83kayz64dwwa
X-HE-Tag: 1788851059-901620
X-HE-Meta: U2FsdGVkX1+dhzHv0wbn6GbxHjvGR96XD1/difyYTe9rTiYovDYyjDEI2fmYEpc5Vh1M2GrW2ksC9+Ao9owSxFbsO5useeq0pCi3oCUTB+uEoOWaeBJDxPinNVQWIixf/KRWAKXYvCCHvutaQPIguwyqQ4+Iy78mBUjKMFaQ/kuWIPyLHZvek/hJw+AMv2qIGoXBVNL8eOXKg4XEI71yCso9VVQKPF6Mf7lVGYIwD8TZqTASNQ2Usz0/8D4t6PFjpXNtzvu0UzyJd22X7FtiJ05JGSSe2KhOWCZ3tW54pqTT4BJ1aoKO832DMrLduhXyBdG+I19lz+flYNQyn1D2uCxTsbLAHv8rnf1gMfFATIoZ1OiAeoCQoWWagv2nvuP5s+gDNONKNgjri+GBj33tHs1V3c+j/t6bezDQ/FVQmNqvTqKKo7M2QRmx7sqK4NQugFKsuCGn4aULsQ4Fhm6lpTS0NIKzzSrKhXqCofqpoMPP/HsM/Ez8DMq7atG2qsAr6ptKPzCb0bNmBYTsRTS2QzThZffKz2/jM3r0Wyt7Qg75wHlMJJgsr08J7RKW+VgcBuaEzp0cWhJsgxqQK1s6SoRjQ+1Z9DoNcleJRHQo6HjgKwO1UEMyZQKk0d+TfaR9sVEjvCcUVJVIO2OvaBjBaWIZcDI99dkO6xclzporXWy+JmYoJh7GoL7iUZuGm0Yg+HYoaaMoRSb4a7hj90IDD49DlhhoSzZHYA420w03Hyc/HrSRiFRvg4aIxpco0i/lVLUpJA2gf6JWuvvWBkj9iBUpDUxZtASxMZJW54z8YmrQpeDK528qQ2O6rMUDoAQ2hzHqdd0Y2RUebOfBdgLSDypGFJLjozojhC8nhESF9X9UfXiYJmv7zsVu2UCTztplwiwHrvdvZs1nL1z8GWGHS1hvnUjHqNK2/TrSWAeSqDDkuxBGMOnUS2TGCsg0F+CI3bJLyZIoJU9QrbXIcgt
 xnL/f4B+
 zd2hT+A41w7gGB/5PEjtiVAwQvJZXGUg564EPNADtaNGrRJiWQS3kafEP6Sodch/IjFvYpNVIlUzqeW/iRNf/ijw+GeqjWfyX8Kx+/oAhFtpeR7tRplHsKaftpDwJK+/vXym997HJULR1OwTedNpxOSF2SuTUbsuJkRJ6zzuawn+g5Dn2PDPalziOWAH86u6UAxkwR/TV2sJKRzSOXLR36+OxSvDptAFSPr1Wtcbv1IAyUa1PGOy/KDSvph2IyZdyxmOvtJ40NowjqySKGnPPgXR8koa6kPX6O12z6JuTBJkfuY+6jQfGpBwJi4pjvJjcroqALAixMJDFOw+JtfNzBIPpSxHQ2laE1bV/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 02:40:10PM +0800, zhen.ni wrote:
> 
> 
> 在 2026/9/8 14:24, Weijie Yuan 写道:
> >  From an outsider..
> > 
> > On Tue, Sep 08, 2026 at 10:41:23AM +0800, zhen.ni wrote:
> > > > 
> > > > Sorry but your whole reply reads like a LLM slop. It took a lot of
> > > > mental effor to actually try and engage with it.
> > > > 
> > > 
> > > This reply was written by me, and its viewpoints are not simply copied
> > > directly from an LLM. The LLM only assists with the wording.
> > 
> > So that's probably the reason. Your previous replies was indeed very
> > much like the output of an LLM. Even if the idea is your own, after
> > being "polished" by LLM, it's hard to read. I know English is not our
> > first language, and it's not that easy to speak like a native speaker.
> > But may I ask you did you read it before sending them out? I really
> > found this bunch of overly formal content a little painful to read.
> > 
> > So I suspect the LLM may have taken too much liberty in polishing your
> > text, to the point that your replies no longer read like something a
> > person would naturally write.
> > 
> > The "Summary and Plan" in your reply in v1, both in its formatting and
> > wording, looks quite similar to LLM-generated text to me. So I can
> > understand why Lorenzo asked whether you had used an LLM. Come on, we
> > all know what LLM writing looks like.
> > 
> > That said, I do not know exactly how you used the LLM on your original
> > text, so please forgive me if I have this wrong.
> > 
> > Thanks.
> > 
> I really can't distinguish the LLM flavor that clearly in English.

Yes, sometimes I can not as well. But I guess the native ones can.
So.. ;-)

> I'm sorry for causing some trouble.

That's fine. No need to say sorry.

I know and understand that we non-native speakers would rather not make
mistakes over these little language detail issues. But over-polishing
can end up having the opposite effect. Keeping some of your natural
writing style may actually be what the community prefers, especially
these AI days.

> My normal reply process is to first describe my ideas, then have the
> LLM check for logic and grammar issues, and do a round of polishing. I
> check the final draft once more to see if it has deviated from my
> ideas, and make corresponding revisions.

Sigh, so it is hard to know where to draw the line. Write more and learn
more about "human-like" writing, perhaps. :)

Thanks!

