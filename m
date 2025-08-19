Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E87BCA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 03:10:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B21618E000F; Mon, 18 Aug 2025 23:10:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF8E88E0006; Mon, 18 Aug 2025 23:10:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0EAF8E000F; Mon, 18 Aug 2025 23:10:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8DB4E8E0006
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 23:10:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 37DEF137B18
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 03:10:31 +0000 (UTC)
X-FDA: 83792029062.28.FA528DC
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf08.hostedemail.com (Postfix) with ESMTP id 527F716000F
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 03:10:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lXzMJXJ5;
	spf=pass (imf08.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755573029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nlF8oOFw6XxGZWbqs616E6b8Wbjg0aG0kr/OcFVHWbk=;
	b=OauB3IgV69aD7NYxFXwVk7Qv6//2ouTdwEyfewc3c4wwp1WbvEq7PovLD/iVNn4/8q/yla
	jBv5yMkh+2oXIXe6boQG2qNpn6s82nJ4noGFbW3slS1hzvD5rueb9RBGHG1A6eEXUiJ9wc
	RI5N1kR604whxmkjehVfgOdGqzxLD7o=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lXzMJXJ5;
	spf=pass (imf08.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755573029; a=rsa-sha256;
	cv=none;
	b=KcFv3SkDreDq9M2rz8yE5jBF7tReJWBZw13hizekVOVFjQDtH+Q8y93GGAmQfdQC+FBX9a
	D7Dgi3s7BW0q41MvjCWsdesyJ8q+O4U4Nuuo+AVEMX73sr2DcAaymjrp8CCTj0xtMWofyu
	SKbt8fauwGqT4cdaW5ufiSlGnQL3sCM=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-70a88ddb1a2so46852536d6.0
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 20:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755573028; x=1756177828; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nlF8oOFw6XxGZWbqs616E6b8Wbjg0aG0kr/OcFVHWbk=;
        b=lXzMJXJ53sTHKCdCaaeqipIf6agZZfDnQk3CKO6btygoEFgI/EBrDaXOHIKa/lG1FN
         rz3HdzgLA8ULhoXdeCr0qKaDnvIzk+MVzIscvSfhMgHUQD+QdlOE5ONt0y4IvEczd2dJ
         XS301S8eBDfjxzx/QVdTUcTDiXhp/UZbI2Gutq1St5neA12nfu8h4PdN+yZkPRA0uPgm
         HFrkfSkFPzgS52Xz24qB/sasz/NYdMVZD4YOq3MFaFF/1pefx+AFU9Zc6FyYc2+nHkgI
         gTcckZ9VOAk/BQd+aAqo3dn5i8Cnx7SgjPHOsE3L3Cm18XD2CafBa/mgtdJLi6HX9+mg
         RhJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755573028; x=1756177828;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nlF8oOFw6XxGZWbqs616E6b8Wbjg0aG0kr/OcFVHWbk=;
        b=CK/+5J3xIHAlfa+VKV3qfApIfvrCkNj4MYJ/MB36wa6veVucgfHJEb5D3CA2dtjwV+
         kOOwJYwiQbqIAqpGNGtPv4V6PlZ3pxyzukKjsXvefxKczFYXao6nxyxCJxnP9FcFJteI
         Gm5Jj+X9LinONbaKg9PrDEckPiwWy6i87AFYzYmOYmzMJJK3rAzdngLS1/zlIU6mpJAy
         qL0VFtKE7BR73JDgQVhtmXrCl3bUKXWnVWBu/Ppb0Zb2XA4+n70DWf5yC0dJeFGt9qeI
         wsfm6lxZNPptErl7LLLsRqPyAUX4cfIazbe4xHMS3ngO00QRxDo+ZPzk1zgig78n+fbt
         ipbw==
X-Forwarded-Encrypted: i=1; AJvYcCXRKHz1xJ4OR2Hns85kJueyHJ0Xn6FU1fuskHHGB9ss8dWwQaQiBGUW21yE+4N8sQIhdCpTS3riWA==@kvack.org
X-Gm-Message-State: AOJu0YyemMkgRU7TvIu6A5FKc1YIzWZPgCUkxh73liaVn65ktFbbgWsj
	bWf7uv5i8BM+QEWiBvc5UGaySQO65qbVid3oBTGHxBole/4fh8SMBh9yJIo0Al1Svem7Xbyz5Dd
	fv0yYouQf/bD9jbXqsxhF5C68PdC84N8=
X-Gm-Gg: ASbGncuOg4KMGwpLxWHQ75BVUwmnMpa3Bh4Ez91WDi0r60M/fSrVZDAc8ThJZf0D2wg
	7THp4WOitDpbwy94O37cDtXms0kv1qgDGlC6ngtFmBQWinnHPS6sAMCY4IKcbRqf5+sYeZmmNle
	0QDVWrG+ef098P/8fQ5LZqsArEtMXORRBXWpoGN1VJXyVmUYNBESMnOogwrMgIWi5z03mbC4zFV
	LZNLrDiBa+hHUpS3SQ=
X-Google-Smtp-Source: AGHT+IEjssY9TNgGBYwnGqAIFrlBD7U7+PHQXDd3di0Id42cdDzL0pUiM51hDPDptU10GrTwCxGXlg0VYTykSF0vkHQ=
X-Received: by 2002:ad4:5def:0:b0:704:85af:1973 with SMTP id
 6a1803df08f44-70c7f5589femr8632396d6.12.1755573028438; Mon, 18 Aug 2025
 20:10:28 -0700 (PDT)
MIME-Version: 1.0
References: <20250818055510.968-1-laoar.shao@gmail.com> <20250818055510.968-6-laoar.shao@gmail.com>
 <8e1ed2ae-bc2b-4ffc-81cd-61ad6878ad0d@gmail.com>
In-Reply-To: <8e1ed2ae-bc2b-4ffc-81cd-61ad6878ad0d@gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 19 Aug 2025 11:09:51 +0800
X-Gm-Features: Ac12FXzRz22-_pmy1O8cYb4B3Gq0gNgmyf9HCpPLwxhFVkyv90Hkfo4odtuh_e4
Message-ID: <CALOAHbCnBBOC_YVGNEEdYrLOBhAqOddA8WKDU88p8uZQStqSbQ@mail.gmail.com>
Subject: Re: [RFC PATCH v5 mm-new 5/5] selftest/bpf: add selftest for BPF
 based THP order seletection
To: Usama Arif <usamaarif642@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, hannes@cmpxchg.org, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, bpf@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 527F716000F
X-Rspam-User: 
X-Stat-Signature: 3snmt1ur7omry3pkpr8zh486h8pbjz9i
X-Rspamd-Server: rspam09
X-HE-Tag: 1755573029-694847
X-HE-Meta: U2FsdGVkX18GvmwnoGGZx9C1oSZQ/7eKdPq/TEY3T11PHFrTIX1mxklPnz/UDhkOiAi4Bitgl6BiL+B/eObakwZkXlh4iRZcZZ3G98e70NxZ1unQAkR81npg1eZZEMb0CHOMEDC7zS5UlVkBe3MnWo2v8vea9r19MIeyAWRoG3gfedaLLLv0TXJuykZdP7LCYDcyDoSbDuLaCJbGVlfrEL4RP1npZsnZjJwJnowPZ5+o3NeN9oWH4qR0bjNq2Lwkf5lohKEyYo6/hJdq+RbUUCEIXbzIBaSUGAdUJJiML5sZ42mfTm/KK+OJVaizm0RiKNEXmis+F//d4xylqyRHngAxpTTSJOLGJdk3UmHbhecqMo/LAeKdzJlV3nMWwuTVRJDX6CJBm4Az6eAbcGJobIcLPK+ITs3WDoouEFZgtT3Zk1HKvLwUhMvCSbHn7DBrGj1BHsoJP3UwxpBLIapdFik4LYbWctmDNkuGrPiNK3zk1m0nK01hB4WAASjNkifjpQAbVE/KVYMSjMk2FEjPLyoIEJ9A6KcfFQsBDJN6yZ0QFko6nDrKC0Zsn3K1x642mXHcEv+y5hgetx+2bgaw6crXooR7FzPAxR8nBAlRVei8mMQ5GAJ+L2yVe9H3jkUh1obLNqQlA2FtcuJebO7Ny3HsrtG01AezPWyyOJf4EMtiom7JciKHgytn+CZg+u5YvX0+rtlbeyH3tPbGdzBAMP7d2xzjMveTBkopwl2DxIbugJrs3Uz7MYEQFXpJVIzrfK8g6UzJlmlkA1JNeAHzlNJQzafU1eBfWEAaoalBfUCafSpwH6B6ncpEUHTLctoDwAzx5TtQlk39ttu2W+yGyBaaQg7zdwRa322pa2CyAXIM6eHe4wawoPKKb1thC6/RfRvJoebMNV3I/YBmRrSzowbKnj4KQpwG7eYVUVn0Z0ojZsD1YMSQTfrkfOzy1vOBfgIcZ9xTv6rTT2dj6c1
 jUnhdber
 Xu6z76NXJ8sb+A6M3QFdM+tgETOmU1WkAsaJauu/xr1FLFu07FLNCH+D4dyfvMzZXilULtSnQtNNCV5bEAOxMyIexU716SE3GXEJys4gV7l7vgwrkTZxNxYaITZW550uY4RFq+Wen6ml+5PYGjczlA9PTO2dqRHd2zxv64W9A14O7nvWu69ffUsTDkYEwkvDctWiiHlig35rx+2KgdevHOsxopiLtlYCVDD/YMXsFvuiHComQnnB7HCJ9SA2CetIFcCCfZEjRmaLqKVSE5GihwHymmDT4WYCcdLm3HcOxbAgbgwT41aV7TsTAw1CYj58KlJlNLrO4CZjFGCZnNWY50374s+kyurg4pNvmJKnIhqCOVqrcr7p+cah613VnUZhOzdSFG/8HyPUM7YOJ5EWEvJS73/AoYUwv4CQD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 10:00=E2=80=AFPM Usama Arif <usamaarif642@gmail.com=
> wrote:
>
>
>
> On 18/08/2025 06:55, Yafang Shao wrote:
> > This self-test verifies that PMD-mapped THP allocation is restricted in
> > page faults for tasks within a specific cgroup, while still permitting
> > THP allocation via khugepaged.
> >
> > Since THP allocation depends on various factors (e.g., system memory
> > pressure), using the actual allocated THP size for validation is
> > unreliable. Instead, we check the return value of get_suggested_order()=
,
> > which indicates whether the system intends to allocate a THP, regardles=
s of
> > whether the allocation ultimately succeeds.
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >  tools/testing/selftests/bpf/config            |   3 +
> >  .../selftests/bpf/prog_tests/thp_adjust.c     | 224 ++++++++++++++++++
> >  .../selftests/bpf/progs/test_thp_adjust.c     |  76 ++++++
> >  .../bpf/progs/test_thp_adjust_failure.c       |  25 ++
> >  4 files changed, 328 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/thp_adjust.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust_f=
ailure.c
> >
>
> I think would be good to add selftests to make sure the bpf programs are =
working
> after fork/exec as intended.

Good suggestion. I will add a self test for it.

--=20
Regards
Yafang

