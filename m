Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C608FB44B5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 06:20:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 792406B0005; Fri, 24 Apr 2026 02:20:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76A526B008A; Fri, 24 Apr 2026 02:20:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6595C6B008C; Fri, 24 Apr 2026 02:20:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 544506B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:20:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B5F2B1C0899
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 06:20:18 +0000 (UTC)
X-FDA: 84692449716.23.97736DB
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf24.hostedemail.com (Postfix) with ESMTP id ACF97180004
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 06:20:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IsuTpdvN;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777011616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NHT+ZbrFQ1d6JCVRomWC8t8Safh9vXTXuXoPxJbXGH0=;
	b=D7jK5DMI6hqWIpFlSNx3DJ7ubueectD6QQONji5Lr1LaJZzqX3r2YX2E/zz6D6nOOm7kpu
	sDYrUCSiqTGkn4SHkubjlE3JQ5UIMp8cfr2d7ZYycqQeIYJGGRov8kOGovd1QqHeRXt/Dm
	WIdopSeCWggYdIgC//MHQMUDgpPBrU8=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IsuTpdvN;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777011616; a=rsa-sha256;
	cv=pass;
	b=Aa4LLrSzlvDoaeg+YkBXpC7tZLgT4+UZR72OSL9VDffIe/nk/3OSDzaUEswsjekS62RKVU
	he6XmXGojtQtehgSemLXlOxJvaimGMIj7BGov4ILV6RdLHwGDVn7OMiDwMw3R9NvOGsqWA
	0oSWFP4JpfmQBr7b7W67oAMgRZ3uyRw=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-66e8cf72a93so9018540a12.0
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:20:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777011615; cv=none;
        d=google.com; s=arc-20240605;
        b=P8lR0WL2ebPjnlcbURSd26sLyOP7VxwtlvxurSepeCGTzFbqtghbbZrsKED9plHUwM
         5gon1aQW+mikiCVP/XBGXyG3T/OYBtz0ve2wBTyLh7PxoHikMWQ7pBqv+m4FCNZIXPJm
         FLUWh+TK1w4GzZg3vz24i9rRRZ4OD02SfaMadWVHdi0a8ioVs6715fhCXomsd0NUZOYN
         SbvsQqRpw62IQCboiWkEDbwNC/DTjmd9ywa+Y+UTI0HZ0ZZeg5ttr8PDg3YP/Fa3SV/p
         O/RWDVNwepfJqy2yPsxGxyX/AyYawSlSWhSMeEUrXrh4BUMKA+PYZAqEoB8Rae8HV1Gq
         Vnpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NHT+ZbrFQ1d6JCVRomWC8t8Safh9vXTXuXoPxJbXGH0=;
        fh=4xvMlXCZDVDyluAammtuIyknvFFb8GJ9T6k2dLNufqk=;
        b=SNAdSzwYFiCEo94W5ic29Rr5RxHwG9DMZjY3ckH2LYoduISl3Ca6yfnaf91UDCzo5R
         NTnjkUBtZwdHmoiv41aZe9Ko0c0vUSnq0nEEiM/wRd2CGGWuNH09P4vALm31Y1d2eT6Z
         ZCpceEGm7atONfQ6pNowWd5Wtl2fmM6pjnTM8Iv/Qs3Jti7+QGiVbw0LTSTuWQMs3Jta
         YzL75NXS9ud9juX389CDi5fF6APXfVZv4LqxR0xjjp/ot14ZBLaUzMUUXVX6GROYM5i/
         rURsIUqEVbPIPnRjCftcNKrYOXFoifTI620O/F7YBP+6QnhJRDquzGOJMAnTxE0EnXjB
         Sljg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777011615; x=1777616415; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NHT+ZbrFQ1d6JCVRomWC8t8Safh9vXTXuXoPxJbXGH0=;
        b=IsuTpdvN+aa7Ycp3xaBHCUm/3LRfjo5wEHgbRIBXZTaskVRDYKa6gQVJhnu0eOjcP7
         bTTyjGXxFwNsRKyUO8Od7xryl1ThZrzdKN6sI3g53b3hzhroatP9TYJH8ESWHj+1fz2R
         GVVrbfc9Mf2qR0pxrB/T+oFSFuXTDfmzxnQARrYpLvPXkwfFQzfz9iGhuxuiJNZqsQr8
         eqFRzy6ftKCJTkxypK2KAJJtvaSx4HOfMup71ZaXN351rRkG2SsjTIigdNrqFZIAcnhs
         obvBiHZTTpe00qzTNcFo9MCW6BevOVb/o1GvE7pw2k7Rw0VHnBd4cQzkHyUnF6t9NhLJ
         6W7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777011615; x=1777616415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NHT+ZbrFQ1d6JCVRomWC8t8Safh9vXTXuXoPxJbXGH0=;
        b=k5b8+WB08GCVzt4olbkIGdrOCihaImhTJc7dmfiEg6xkZhdO+ah0K351NuDK3WQkHg
         fRsN4xCr6MLvlaPm/WoeKTZbRN5pwiS9WFNngPWycl72eGolf54xgbVS6Sz63GrctN3A
         FTH15NVZMjoHpYMZw2VrdyBwAcJXIuFVrKb3EYYDLDqHObgzw8EUK1VUyK/Iwc7jCo+e
         qhbB9M/OOJL/LT6Vgx3u6wBZOzeXK+xnHBe4mbzOxtNSE8Y8RMuqRPa3cFTOzwz9nC3O
         NnTrZr2ouy96NDooESRBO6ijpFgDW/xBpNolWygRQo0jmnD4QcLATelx5Xz2ZQA0mztm
         2FPg==
X-Forwarded-Encrypted: i=1; AFNElJ80VXBPGh++PZyK6R9gl0C8NY1KEwjOTmJowElKrO76iVaVmRxjJFMPLwZfVPsQB3+nKY1fiXixRw==@kvack.org
X-Gm-Message-State: AOJu0YxrsM0DZxH4iCnSlPyuM+23a5S7Q/ygiMzbupyhFz4z2aXPgbs8
	MqH5HWLY3lbMd9E3YTNfsAJi7r4Fx8f0RL77pselkUiT7mEHhYJDpSJwtlIvMaeVPWdPOIub6X/
	qIUVlgAG9RoOpGLUhq3zSzSCaNi65/ClKrLpc
X-Gm-Gg: AeBDievWngClRX9i0hgpVUkXuhbZ5mNGGlMvfEINz/K/0nqrAMkRPaROdGAC0/rf7JK
	Ff6QvKgdC0r47TiExxv7OZcjj2Xv9xnMuOV0DWwIqDHCV8SSgzT/Iv6yX8ZWWlBn5UEiQJP7pJX
	K6fJdP52FVnRGIU51SzvhkqFfK/j4kdGzawcWVVomSQDJUYPBfpHlx0H2K35/+LVanrXD3+yD18
	2qjbE9yWkuqNnnwlHYm/diIhRnXfKDfIfqnCTfALzQrGpCBMkitPomI7bC2LHJrWsd54nz1sQsj
	6jCA6l6Fd9r5oeJES4qYW7SknrcB6RusT1CD/UXPfrzLlsEQqQ==
X-Received: by 2002:a05:6402:28c8:b0:677:270f:6f4b with SMTP id
 4fb4d7f45d1cf-677270f7f6cmr3673799a12.1.1777011614631; Thu, 23 Apr 2026
 23:20:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260421020932.3212532-1-liuyibin@hygon.cn> <aeikm2e5Gh5reJ30@lucifer>
 <bc514883d6154420b3cfde4ab25a20c7@hygon.cn> <aejzSsiXZBK1emv7@lucifer>
 <a96c20b74b874248bc0cdc2b926a43fe@hygon.cn> <aerhh_tzSs5XapUz@casper.infradead.org>
In-Reply-To: <aerhh_tzSs5XapUz@casper.infradead.org>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Fri, 24 Apr 2026 08:20:01 +0200
X-Gm-Features: AQROBzCMZgHVIUyd2eInZGYwOMcnSg29XnDK8mRT8aosN_mcUyOqAAyW9pt2pWQ
Message-ID: <CAGudoHGnOMj7O0P0pttdgdhGnJq8+Nv3_91x8kEAT5wR_xDmgQ@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IOetlOWkjTog562U5aSNOiBbUEFUQ0hdIG1tOiBBZGQgUldIX1JNQVBfRVhDTFVERQ==?=
	=?UTF-8?B?IGZsYWcgdG8gZXhjbHVkZSBmaWxlcyBmcm9tIHJtYXAgc2hhcmluZw==?=
To: Matthew Wilcox <willy@infradead.org>
Cc: Yibin Liu <liuyibin@hygon.cn>, Lorenzo Stoakes <ljs@kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, 
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "brauner@kernel.org" <brauner@kernel.org>, 
	Jianyong Wu <wujianyong@hygon.cn>, Huangsj <huangsj@hygon.cn>, Yuan Zhong <zhongyuan@hygon.cn>, 
	"jack@suse.cz" <jack@suse.cz>, "jlayton@kernel.org" <jlayton@kernel.org>, 
	"chuck.lever@oracle.com" <chuck.lever@oracle.com>, "alex.aring@gmail.com" <alex.aring@gmail.com>, 
	"vbabka@kernel.org" <vbabka@kernel.org>, "jannh@google.com" <jannh@google.com>, 
	"pfalcato@suse.de" <pfalcato@suse.de>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ACF97180004
X-Stat-Signature: sr8d59e6jia871txgqoc4b44kobwpuhp
X-HE-Tag: 1777011616-419709
X-HE-Meta: U2FsdGVkX1+RqWC3ST3nF+JTwz/TjdMaMrNzLicTwVWBSgo3ydNsGB2dQbI0HH9qKRGTHoPm9xq0y6itW4zVJ2Py8Qor8gH2SnB2PC22YQvUajfZVkuFyLt2iSkebAE6pZ1EiqJGmM+AjLJmVKSt6CZIbzdE+Uz6ZuijLUXp9V44hT1ouPhwNbAfp3x9qN9Gcq2nqE2xl4KJGvVoFoTn2RLo20FbKFZh/KTEMBu81oMLVEa+iPz7PMfz1tLNTuJZ+RmNYfqH2DAeZKZ8f9H3qr/FQqBsybGbplcYaMrInDLFcNHolaxJggSSsb8p3FuEYsLi7VX+1EG/TrgpbPb4IIfccWjg0flI7Pc3kgmwi6WeMBxuxzdO9IeL6vnDb7KqaDmcrobf/n5B94fAthwzRSLL/OCDHfVz3gqPvbTa5EW3nKiJV2JGOZmjrlNO/aIzecQ02o+3OGUvX07AQMO4iVcBE6HKshWRJmWdiRMGJ72tXsIQ6UP43hs3tzvG2F299+8T3IWMhn4SUehzij6Q58WJ3Kq3/A7+7WoUfY9r0iroqa/e9na3Pjb5e93OyKPuPdyb47zOAHo3S8W2Lpjeyym17DoZfb9YE2MKayltSo5jT6+vjccnfHtszwlKfUZ5uztyW70qURHj/zzd9CrdP6oJTKsaFANdFaSlw16cjprzoLnfSD+OaqsxnWH/ft3TXrXPIMkXPavj67yh391teWhbX+HDhGKIlB7dULQ3t4SvD48yR8CbAsaimwAUlyB2gPLMo4Ru7RBGGPscRn2g/ppRNVw1ZXsZa2VdUbocsM0njUdJIi/oAS6/4A3wuzYpS/qcJYSSPnOrSJU3knTQkQv8bvpHcmPuhRC0L6AbVLOcOvB36OUmWUylQCgSOKfjDOY3fIIalLNDChFBvgzmpm8Byq+D0vrvxkYw5U9LcTSvbyBiTs0agCMT/OQyFGhjPATOO8E7pBiKbhAiD7D
 qNa2dIOo
 ipunv/Ui49Meshn9Gnzu9XQHlKO4jMi9EbYswq1+U3O6d5Gsqy4wtz85ZN/4qPw4EvKDYTWVFaT26cdOVaynjs4IYnYoeaxU0ntpJpIZv+Cbw+9C8Da1XedI5Gewi/s7nNzrnOXjge6sQpDjO4YRKVp797GSnqHUHXlGteYblFNollMMIi6H7MsbQ0PMAn2UOn+nseXeXrVnw8B61fDhPIk2vEahGzxbJtMQE3EzWKIBIAO2aLhidUPHBu9seiVlEqw0oim4a8Jndm+FYYuaZcpw5mEnWGWc118Ere6fuJDO+QHK3LCNX2O9yDc8GIqfAz0nbINk3NWfIRI0LPOPcptmXLZHVToZr8sWZmbMuZUiVDIQbUKOlXGS4JlBKSJtSkzPUD37TzMUF20xjWyGTOIF5fKoeG+kt+BnHhGbmGb811+UIJDt5SbNOHiQyH/pBO0JmRTg78+BHniwv/K9XSMSt7M63rObivzPwNSne9XRqxQhVko5heG6ORnnTH//3TQsIRKBiVEWXvYoK1PV9Diz0KM3AY6FdJwIU9mg9cKyeTNsCzvZX/Gn1qw71tBGU95y4TLjlCCQegM/+wi5B9ehBIv08qEeMD88GRSsplAuTS+Swtelj1c0tqNAnB5kq1zD1RQgBTlHlHVg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 5:20=E2=80=AFAM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Fri, Apr 24, 2026 at 01:08:35AM +0000, Yibin Liu wrote:
> > On an Intel Emerald Rapids server (112 cores), run the execl benchmark =
from
> > UnixBench with the command: ./Run -c 220 execl
> > Then perf top shows:
> >
> >   91.53%  [kernel]                    [k] osq_lock
> >    0.50%  [kernel]                    [k] rwsem_spin_on_owner
>
> OK, but does this represent a realistic workload?  It's pretty easy to
> construct workloads that hammer on particular locks; the question is
> whether it's a relevant performance bottleneck that customers care about.

This is a genuine problem when doing large-scale package building.
I'll say upfront I have extensive experience with this crap on
FreeBSD, I did not run it on Linux myself, but bear with me here --
while FreeBSD is in doubt a less scalable kernel, Linux demonstrated
to be suffering from the same problems.

Say you have a box with a core count of 100 and get it to work
building up to 100 packages at a time. Further, even if you use some
form of separation from file-system standpoint on userspace level, you
still want to share the common binaries to reduce memory + cache
footprint so you at least --bind them. Then you are susceptible to
contention issues at least on paper.

Granted, building a pig like chromium scales great because it is
written in c++ and almost all of the time is spent in userspace, with
forks and execs of the compiler highly spread out in time, in turn
putting very little pressure on the locks.

However, vast majority of packages is very tiny in comparison
(literally a few .c files) and this is where things go south as they
engage in exec frenzy, looking like a borderline microbenchmark. The
primary culprit is configure scripts, issuing an idiotic number of
back-to-back execs of short-lived processes (notably sed, but also
grep, rm and others). There is a lot of evil in makefiles as well.

I don't have numbers handy, but in case of the FreeBSD ports tree we
are talking about over 10 000 ports which on their own take few
seconds to build. Since these are largely single-threaded, if you have
package-building machinery which can saturate the box, you easily end
up with parallel builds matching your core count. And when they engage
in exec-frenzy for the duration, you may as well be microbenchmarking
it.

A sufficiently pessimized workload is indistinguishable from a
microbenchmark and this here is an example of one.

iow this is a real problem, but I don't have specific numbers for Linux.

