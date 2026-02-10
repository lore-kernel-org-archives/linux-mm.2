Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2597EA8115
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 13:47:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 594616B0089; Tue, 10 Feb 2026 08:47:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 552486B008A; Tue, 10 Feb 2026 08:47:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 454A66B008C; Tue, 10 Feb 2026 08:47:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 374486B0089
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:47:50 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EBC865932F
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:47:49 +0000 (UTC)
X-FDA: 84428675058.22.406F9B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5ED1640005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:47:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="P9/T/C4+";
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770731268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AIqjsvjCj+pLH+AQ0hEHXNvRgeu87feFSoEl3S8co14=;
	b=LH1wpDiem0iT56jWN55OkEUKoRecY0Pa4mz0A1RBTG1z6ViPRYNpvjd1ziye+YDIKRj0Dw
	0Q+AlJXZK6FTiKeEchy9AZsHtE6Gg4FzncUKcqyuQIdG0P+HKVuuMQhKNHNwesTp1myvJK
	jaskN6TtjWzOu6xm/zMFmO08aQJeSYo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="P9/T/C4+";
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770731268; a=rsa-sha256;
	cv=none;
	b=RjIHC+eA/wNvl0CWU0LIbYzFL6uBq2fXx6si6f4e9HNv4MN9f//yCi72LJFwphpzjFe1jt
	1x75m9vO6owbbJT32tdQpy7QBaVe/JpUid1fRuOAxssJ9R09XugSjKUfcoOviR+Ap1zHCb
	QPpCQzCa5ehxjCsEWxZimAns4jYZ+aA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C6A9860097;
	Tue, 10 Feb 2026 13:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98671C16AAE;
	Tue, 10 Feb 2026 13:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770731267;
	bh=AIqjsvjCj+pLH+AQ0hEHXNvRgeu87feFSoEl3S8co14=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=P9/T/C4+DQWqHEIA1MoTbGMoBRNFLJrpXYIZhMdJAt0H7icjnSl5ziMckSUpLNGVS
	 awZahl3ejlwlNMkhPxFZwj5mFiQwMYumgnStxIOEG2fcvFjrvdwjfwHgWATzaJGoCA
	 JwGeanc1xWH4ih5RY6ijMUzN0PQVqQo2XR55ZrtV78CURLnLOlVXIObY75z1aRlaH+
	 xlghd96giFex5Apzl/bE5NKzCC2S+ThoHE+J6IZfZZirepUTJ0Nj4L9YucYI+cm7cD
	 Vt1etHebMXaRr2SbVKpwPfLABRl4h7YEiA2dSOe5m/h27Rd1ICT3JRSdqTxoxMcMqo
	 WXA5Cg13ZTZQA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  linux-mm@kvack.org,
  lsf-pc@lists.linux-foundation.org,  Mike Rapoport <rppt@kernel.org>,
  David Rientjes <rientjes@google.com>,  Muchun Song
 <muchun.song@linux.dev>,  Oscar Salvador <osalvador@suse.de>,  David
 Hildenbrand <david@kernel.org>,  Jason Gunthorpe <jgg@ziepe.ca>,
  Alexander Graf <graf@amazon.com>,  David Matlack <dmatlack@google.com>
Subject: Re: [LSF/MM/BPF TOPIC] HugeTLB file preservation across live update
In-Reply-To: <CA+CK2bCkLKrP6yvS=qpao1krfCbxUbj73bq8m8JnmKqtjp3tKQ@mail.gmail.com>
	(Pasha Tatashin's message of "Sat, 7 Feb 2026 11:21:45 -0500")
References: <2vxz1pixvk4m.fsf@kernel.org>
	<CA+CK2bCkLKrP6yvS=qpao1krfCbxUbj73bq8m8JnmKqtjp3tKQ@mail.gmail.com>
Date: Tue, 10 Feb 2026 14:47:44 +0100
Message-ID: <2vxzms1gsoan.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5ED1640005
X-Stat-Signature: t4ys1ofi6ysxqi7z8oer65gx7xmswajd
X-Rspam-User: 
X-HE-Tag: 1770731268-997815
X-HE-Meta: U2FsdGVkX1+M3x7Fkrq7z/Cl/gcGzeaOh47zlk8R5npoOR13xcQqErujxJDQQ8HXLLjnV7a1/Fd/b1bUUEYLNWFVkC7r1ZE6yta2Vl5wkjgns1J48EKisYVUVaW1jfG0+027Jot2JFiHnQm0JGKx9OkyH5tMk8hc50hHMA6YJIuRd6F1buEBYXzX1YKKCyHCIbZcAWJNUojsLMwpq0lpuA/8fmMWCJ4IxB0zHxcrzZbPFcey83B0IUde3F6A7Pu7behw3c9NKJZX9JCf0LXWFIJ6DTaKLhCDe4KrOBsWCP6yNRkwrl7DaJP0L8Ks02AOUvFzjlVQFkegVsw2jPR8G6Jy07wra2bX3iK/siDQ0y/KGz4vD/LZm074aCdfuZQ9NoowJgJgeoDkVhsRlrkU+9iLBJM39ZhRk3yDI/T96KgayFuNj5W88qQDYnP8xRdz4SbGNiHYtxpr5ou+nZ5F57OocHDRFnPiYW00iblysIMjR9OBS+/Us1dzJw/02oV466bJyoL6JeIjWIbQNZIdiNbM6CAAfaLvs34WoIpeFUnPemuaetrEBYWaCZgx3wuJJlg0inZmAdl+by23TzVJ6xN+m4okN9utqJoV2rI3U02uLQzbaxEYN6dukuBU8rV71dObRWjsrho75d15cxofO5SqQfTb6zE9MrID9xS82TvDfRvtCOpZXVihrCz217EF98sG7NPUdUzOZX5F96UVgNGN/MX/j9js8w/oxkCedH1CnZpKA4cR/KzaOb0AdM3dZa/gSxtGd2K4r0Jq0uw3t4zx7ArbIlf74Rq1sLJsJ+DaTBdwwhw2v9b4Hr/2wrezTvbnoI/cURQYxH/f+UnV8DJWXpCEjOfAtia3vKPuawkeUxeybV78MO+x1IKIhdeLsMLEDKcKwVA0goiweBGVQki4DQkLJCzNDLOVTU6bW19OigZqXcCeYtc/pP30c2jOB+USIf94lmz6ZIbUnCs
 Nm/sx3ZA
 CcWk0fFafGZ0Jb4FA8/UX4+Ae9KAMPlu8k18Q+8sfXYT6O6eVQYnFaNe2asOEqNU2YS1fgSc9fel7OgdxiSccNp88AFn7nNXUXEPyR56W/rPBODXrk2sCUK9uaUcVl2OX8vyTW3RZd1A2G/In04b3IO25sjBkha6ATLv8rkdm+rPLX6nOrlE5p7mdKKd1zdHalguz346j9nCin05wF8NOaOy2O2W3C6MQblFFcyosC8jITsJhlqxKLtMh9A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pasha,

On Sat, Feb 07 2026, Pasha Tatashin wrote:

> On Fri, Feb 6, 2026 at 12:48=E2=80=AFPM Pratyush Yadav <pratyush@kernel.o=
rg> wrote:
>>
[...]
>> Goals of the discussion
>> -----------------------
>>
>> This session will aim to present the topic, explain why it is needed,
>> show how the support works, and most importantly, collect feedback on
>> how to proceed with this work.
>>
>> PS: if any HugeTLB developers or maintainers are reading this, it would
>> be great to have your initial thoughts on the RFC [4] so I can present a
>> more polished patchset at the conference and make the most of the
>> discussion.
>
> Thank you Pratyush for proposing this topic. A few more thoughts:
> While the discussion should be about memfd+hugetlb support, the long
> term goal is to make this work as an enabler for guestmemfd+hugetlb
> preservation support.

Yes, I plan to use the HugeTLB work here as the backend for
guest_memfd+hugetlb preservation. I can discuss some ideas for that in
my talk if time permits. Or do you think that should be a separate talk?

[...]

--=20
Regards,
Pratyush Yadav

