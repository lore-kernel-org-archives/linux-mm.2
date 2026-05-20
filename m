Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F4BECD5BA4
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 18:09:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A06236B00B0; Wed, 20 May 2026 14:09:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B73F6B00B1; Wed, 20 May 2026 14:09:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CDC76B00B2; Wed, 20 May 2026 14:09:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7DF866B00B0
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:09:44 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1C35A1C0028
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:09:44 +0000 (UTC)
X-FDA: 84788586288.27.B88342E
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1E33380003
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:09:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BbSg0kis;
	spf=pass (imf30.hostedemail.com: domain of jannh@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779300582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MNgLmqRXKp/1gy6uJDg1yDtsmTmobWAt7WR+onmMUoo=;
	b=xnVhS/5L2wFs3WyZYFCcilsdmtzKFeb6vAW98NCayh3PSY5f8lE4VpZW/wOiYY6QUWIM32
	4qwle6li4enQ2qtlNB3B+auzG+8jmCuLqjfM6ru8fxgObkcN9pvfOdaOVMqDTdKmGeSzL9
	F/c7wWCTM6O9WtMkcnbnKAXDrj4W5LQ=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BbSg0kis;
	spf=pass (imf30.hostedemail.com: domain of jannh@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779300582; a=rsa-sha256;
	cv=pass;
	b=Oqjj3pDyqSbN6oPghwDDd08ob2CTxk7OL1TSfhMiyCnsAaVPRWAVxkEBsqP+P10S6BF7o5
	CZ4c4LRDJ7n6ga6dY/fGWiDnfBIQBl9m/HNSTuQVbAdQoDZlPoYmvRlDoOe5N/nJLRWqSP
	g/17bCNf7eO6iBRHi/BYnmueY9ihGeQ=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-67bf769704eso247a12.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 11:09:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779300580; cv=none;
        d=google.com; s=arc-20240605;
        b=Ek8w81hWDyd05khKDjIBJntKdWPEglO5x3oVyGwmDpMim4TMWkGyFb2K227v1WG7Im
         nEQF0jMMyUEAcRnF05rQ42xoBRsavPTIfJRHFeafKc+/QNSousD87tt5UbQJzam6oObn
         55T+8VQ+1k7i6DtQJ+JUp7OFuTtzPAm/vKt8zC1LMAg5kgfnvNyay4f0Ce993/oq5n4w
         Y5qwhoy8amwvlmrL+Lx+kQ8/aUjFh1t/LtbZTChuWAhrBbiP9gksKbPPLslg4SdqHQpY
         hiVOJ+3F2fluPfrfU6KyFnmB3ji/BkaoN5NoZYvmUfzKDIZb5zA+MqFBg7VDR+ZwOuhU
         EG5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MNgLmqRXKp/1gy6uJDg1yDtsmTmobWAt7WR+onmMUoo=;
        fh=OA364RN2QmlQSFJcUshQpARBwty7kFvRxsYHqzeN0N8=;
        b=lZDbLyi86EzfQmT/BZuyn5oJFJ736Ft6TgmM4dqehwvTTM4nSnrorPLCgus559iEj0
         yvEUH++BQp6LkMZJ5EHTIj7KTFUu886x9aWdNuDLrkVGlQng3nUOoOwAVRhIxVTb/2J8
         evcubOlf1Te3FPn4Zx+lnlf6eytoJ7a+YVG+xQN6NdNSJCzxgQDCA5u4AWLG52rMMb6m
         Rtv+9ykCR46aCUKqimDL6HItJXZbfEYuKkdRt1KYmBiCFUhd1/vEZ0J03VMp5F7QHxa2
         +66RKjllRTDWE5IHLXoYhBEh8oRjPVXM7GCvuEEQdW9uveB3psZaNKsFTRHZTMKfSzqH
         rb4g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779300580; x=1779905380; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MNgLmqRXKp/1gy6uJDg1yDtsmTmobWAt7WR+onmMUoo=;
        b=BbSg0kis/tCU18XWYN22DGa2cxhdqB3jqDfkF3nfYA92qhXEAMQQXifiRB4+3QS3j2
         gjDijgjBcqSCEUP2BfDUBoY3l2IlIv/Ap0FRwzQdo5V3oEaZ8AB4kFr/QEggC3MW+qSn
         50eYzRHIgTpFyIcgFuCraDL1joyZs94Kbg9XkZ6uC/+sVFQKi88YhOBb2a67f0SnfMRL
         oC0Mb9t3VwBamV1Hdgp0XbS5ErSKZ3yvw6PCqZsn+JZL+AA9zOB+6zY8ki9ZTJlSsHXk
         NqJGRSc9In4uMdRAEILwOfaR0Ayilvtacf5bkhOQ0KEiIPjZ2n0ZecWd1WfSi6OljbmK
         cJaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779300580; x=1779905380;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MNgLmqRXKp/1gy6uJDg1yDtsmTmobWAt7WR+onmMUoo=;
        b=cHJ2/RRiMSIv6FtgoRxJKmmJeFdmlwsA1jeWJuyc8qA6k7K1puO9QUuiuP9lSk+xWX
         AHqgP/F91us1BhkkaPUdVkERh0QRG4lI62Js5/5ru5P2Focc3Hpqu8D558hS5L//Hag4
         T5Xpxh4zevUWd2IIY5dOGhduDKvE5VLSqxSkl0E6XdbfQgkMl9qGWBccB0vPw0WFIqkr
         /P+XHxxC0ODLRD368SDuRq2AikDm5Vzd3qQH71+UHbjUF4W+QhfOwVp034U6BLPc35Hg
         L3WlqdNZGP2+JmjKy3JRHNUQVF2SC6qGBwXkfisO0h0DsH7o9EvSO5SF98DxXwrts7rP
         jpcg==
X-Forwarded-Encrypted: i=1; AFNElJ9k327jsomT2ZfA0dEr9o3jDcNJ4F6+if0FSZVssmD1DNSSqoBJx+bEwEwq61VcWq3nM6vdUjLAeA==@kvack.org
X-Gm-Message-State: AOJu0YxkyETsgfRapnX1mNjuxsd7erXYLza7Avhcv3InlqZbtQ11Gj5e
	OO/RHWnue3O1TD3AE5qpKYFZ5Y/4ualBnRGpsOZEFisbIiLeB1gefbdDOiadO0hsIbhvABpsj2Z
	Rj96v6AeAvp6RdTxk5w2YTF3F16O2ApVW3d94zaUp
X-Gm-Gg: Acq92OEY5UAJjT9CfeRU6xR5O5EPOZKj2g3u1Cb5PVFAv+o5i7Dlyy4b2itq6jflOwU
	AtVRzktmLW1mjyFbipaVVcq4MAloskr4S94WT7JZ5DokjlaHubjONCe8N3eJ++KmNY7mfOmjJdS
	Nmt0Bkr38vxsP3knL0DM5dskmvivUN4PUsfWH0+u2kTo1kjJ5x7cnfhqkqr7H7E2VySMUxRMLiJ
	40+lASq9SPJAhdg7pYZTs3xw7BmZWJ5E19xPeN5OiI07swUR++B8zhrsJYqke9zsdr7lJxBCPnf
	wDc953OaX/c9bw3ILD+xlm+gGvrql3vdhrtYoSZohdgL+O7A7ccuPAx6D34=
X-Received: by 2002:a05:6402:3552:b0:678:93b4:1fd3 with SMTP id
 4fb4d7f45d1cf-688040d8553mr8706a12.6.1779300580030; Wed, 20 May 2026 11:09:40
 -0700 (PDT)
MIME-Version: 1.0
References: <20260520-work-task_exec_state-v2-0-9ea88ceb09e6@kernel.org>
 <CAG48ez0kVA+Rw+pHSi5-JLf9KTh8Y9Am04W567YS=imgk+b7tA@mail.gmail.com>
 <CAHk-=wh7CJo_GmRoByrMePPB6sDC2ienhEd8riq=xp0BLPYZYQ@mail.gmail.com> <CAHk-=wgfOvMTh8Tbkrk8ifHw_aA+vfacLs-NtULpqx1sN+y01g@mail.gmail.com>
In-Reply-To: <CAHk-=wgfOvMTh8Tbkrk8ifHw_aA+vfacLs-NtULpqx1sN+y01g@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Wed, 20 May 2026 20:09:03 +0200
X-Gm-Features: AVHnY4II5dLQv_5fIEHIShPoqpaJeB3rtVw_aLkv5fkCRlcCwBERcXOTLHEfkeM
Message-ID: <CAG48ez3WUjLY2iV2_BmJB1RX6vQ+5czYNJY5UP0KHZLvob_Ztg@mail.gmail.com>
Subject: Re: [PATCH RFC v2 0/5] ptrace: keep mm metadata accessible past exit_mm()
To: Linus Torvalds <torvalds@linuxfoundation.org>, Christian Brauner <brauner@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Qualys Security Advisory <qsa@qualys.com>, Kees Cook <kees@kernel.org>, 
	Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, 
	Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ihnizc5p74g8ji3sh3z56e9t31redn1k
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1E33380003
X-Rspam-User: 
X-HE-Tag: 1779300581-524500
X-HE-Meta: U2FsdGVkX1+qdIUwWIPadBzWkwCEmVpEP9MhRtsw8d0h/t5ZZLlDBGXsR5mpbiHxbU2SO8suS3dosFzxSTV0bJQwqD8RFiDaeYynHN5iIpIMBrWAeV5+2foGZKaMsFOd4wIeqgZRJgycZedm/zP9piFznL2/5psU2qwHxoF2UzZj0BJVtthbXlbktDhC73h06wxJqVRtcXdcCwNZ0U1qTpBkyqVnOfDKFMxMWEuTiTOTugo63tFE+linIjofsV6Ao2url8jdjTo1UmlzctsDX2kK0OzNQD4ulQojmAqH9tlE3ylBsoNT3RssFVlA1pKNP38r4M3AO2KOyZXPlD1DDPCXmhXcz9kOxm2xqT3qbwkygl+wnLbUZNUmfqdIwNliVqJNNApNm1WBpyGy4aLE61+4vyILO0AyteZSc7yaeuhNRDiQmvv09VWyxNw/ETqQUOFx+6/R8Qp8gs/T4CAg2OsEuy5Co2Bqm87uWlDuqGDo37/EXKKR18szimsVdiuJU33Nb0kETIX46UtxEo6LlwC8ylI6UHw1ncbzFSI2iEqSdq4+hbqzLfty51HlJ8TFpr/QC5gmBHXT7vfjxJS/fWvdbpinPsuDn1nNepYEWLLGPu2eDZV5WxCqSubdwRhrKEMAu002LNv/TVLLrPKVMS0OQtl0O75843x2PgxLAiPs/Ajq/64puMvt5B+KJN+yMKiJmZYKdqUcsRJLBA066/DyMf+L8AsdFjfQtSgUkACS24vIoo0KgplG9WDPeJDGYS7yUoQVLDWhjKO1E/wBOsqLKp7Bco+iwG8kHn/WbYwQHfUuByiSdRz1VO2Il+84MHRiL1bJQHFnCs7k1nm2QvpBOL+YuunLl1SANuWDBKaCe26ZP0nj7aTl7+aTa824u0CkzqZBth+ROdhx8g/IGXgxxkbhEHF6QTxJorgxpt33WVXsNmfRrzVNijhi28rGOetTNSZcDRH2k3Op+kX
 lutTMV7+
 AOOmCQAGVfNVNah+8wFbzthjC0KTMWI0MXOHmwVgSe5XmArGoK2lneCPknxTOKtS2faD9AGa1Q9U+1qzuOnmIHVT31keMsA9pGGYZYZP1VfNKV39HBDkIoFCA1pepkoe7JdS8/Ry9l0Z6LVj9jQ769i9nRraln5EUBqEVYGEpi5RXknNWQACucIZzCYqLXmS05EXYWfIWAs7XwpUDEC2za/30Hi8vXTvdMqoT+UMPNBoOBdqzMJCf6WQ2Yh/8/AJABg+zirEFiesOlsG+ZUXp6fQL/BcShFybRIRX9qfLkVhICQEIeh8rv/5TftJN+Y/qwqHe6hQetRnAzFIzeINbvSvn4LvxdNT9A7yPvex/IunfD1PxfXooYui07Wm6HZXbzyoL3gwIAX4bdUDNCVAfsx/xkjLj48s8onI4geD1BMogdig=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 7:01=E2=80=AFPM Linus Torvalds
<torvalds@linuxfoundation.org> wrote:
> On Wed, 20 May 2026 at 11:52, Linus Torvalds
> <torvalds@linuxfoundation.org> wrote:
> >
> > Right you are. How about just modifying the rule to saying that
> > prctl(PR_SET_DUMPABLE) just always creates a new exec_state for the
> > current thread?
>
> Obviously we could also make some clone() flag to do this, although
> I'd rather not expand on that interface..

This patch series always unshares state with alloc_task_exec_state()
on execve(), and never on clone(). I think compared to that, it would
be strictly better to also do alloc_task_exec_state() on clone()
without CLONE_VM for now, to preserve the existing semantics.

