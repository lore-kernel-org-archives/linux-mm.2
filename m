Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B36ABCD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 17:07:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9B396B0005; Fri,  5 Jun 2026 13:07:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4B666B0088; Fri,  5 Jun 2026 13:07:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A61C06B008C; Fri,  5 Jun 2026 13:07:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 995E96B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:07:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 054311C106F
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:07:18 +0000 (UTC)
X-FDA: 84846489756.09.E371DD0
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf03.hostedemail.com (Postfix) with ESMTP id EEFED20012
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:07:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j7xBKeeq;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780679236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dMEpkIcziwMeCZ237oDCvxqwJICGIcA12vrOOtM6dG0=;
	b=hY6jot2mTwGj+ADy4t3OFCrB9Fd5SrBOibwyk5JGZqkUfdnyi1QWc60U/p5BwnLUXKJ8dm
	Gx57WUHobrWnoEs19aRhXwZdLGzVF5OQg+7lmbCYYOj5Fy5ZmlfzymqvYE66L6G2F2xkbM
	UX4pQPfRCiXpaDZvkRPZRMPtws/L6Ag=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j7xBKeeq;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780679236;
	b=MAko/7X/nlkgFp9cpNa+d3hGgkRiiTGvOMZeFAo48Sc44jTr93JkRJM4obj6jirKg79+dv
	wF5RSrsFiawOA8S3u5UEcDHFbBGfImVCluFZGicVrL+DqO+SxoZzpfjXWyRj4+L1nG4bKW
	rVvf4xv2JOSW66JJ4SJVMtfd1vKBYY0=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-490c0c92cffso12714075e9.2
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 10:07:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780679234; cv=none;
        d=google.com; s=arc-20240605;
        b=Q/MGW71wcUHEB4Zm3bNvdVPSnurjXLRwGvPZYTzdY+Sb4dPN/AobzbaxZ4ZkYgxOuY
         Mplgbq1OCa1M7FypkHkHVffSTE4ONT15KSj5KoQF7mGtz3VQlZT8GtcqFBs0wToe3ojC
         S6Pw8wFWq9F8jeiCQq2hqM9nA/mIxY5WgU5i+kC/AyI37kEFI+7gmy7Rf3CEFWjAPb2V
         WyVSknzDuwa9NQZC49fPynE5j/06CxYacreoiwcXFkwWRRJyqH2jYGgss5pUtaW8N7OF
         QgL0inxho8eQwSd6G2u4/kzECVwe8Co4itwoj/1eP8Dd6cQDw4qbKNqvvz8gD2eTRHDe
         RnYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dMEpkIcziwMeCZ237oDCvxqwJICGIcA12vrOOtM6dG0=;
        fh=Xy+TJjjU6nge1ItRR2MEz7tmE4IsgjXdb5r0tYQPhuU=;
        b=M4vOaBMvVFjodQ1icwFVXP61eyFlwXs1KAfChlUZz64yZ14XonAdCBZ7LLHDt13rA9
         GpUq0MLOvMWYzyjGW/UfHgS4HasPstVN92MwBQ8U4j7Kmj4MPy4+oEs6nQZFC6//tyr0
         WEuhG5ojoTyApmv6Pta9AB3uCw4yx1JK6NjeOYDG9uKa0ZdloQYc0PkrtI/14MFUEe3Z
         H3c4LMaKGmiJ8qRF0TfNJD9sBQ0A6zD653ksb9TLGJfrwTKIPfvQNk+BfQ9WJPGt3PTE
         Q5eAX7SQldXMPCBiWSdQeb3fOm0LU+8cBGSyDCPIqv4IiVKY1MvbL7s0D0yNqagfGjf6
         Drxw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780679234; x=1781284034; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dMEpkIcziwMeCZ237oDCvxqwJICGIcA12vrOOtM6dG0=;
        b=j7xBKeeqbL5CRSWfuJK8A6LWX4SyvhXAmTZFqXPeoxbJrsNSxgAMvuDtFA0DuEYIxk
         eoAGNlu0polywDFC9AaU4UtkgYndRxY4ty8ZyuWFSmAE6nPDCsN7qfiNujTl8ixOO3Ir
         BiH94RoeAZM8QpFLYnx1ID1PzDRDuhCM4kVdJydYEhzmJCNeVr/FdAndcMPRE8L+f+OE
         xD0s5gGKHljYzyzLv+fzoogZ156dt4DXjvokkLfy6VFfz5OBw6PVKREqJ4lxbri5VyE+
         p15Rpth0J7vSixsSYZ6mBwCQUiqft61iI4X4s6B17jq22U02XH54tPbr4R7o9JE9qmN4
         y15g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780679234; x=1781284034;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dMEpkIcziwMeCZ237oDCvxqwJICGIcA12vrOOtM6dG0=;
        b=dIb7EiUCfZi7goX35WWtruvwxOIWwFHt7QkMF5ospuAvixm32744KfZFVljB6msfEs
         xP6NXbw677kB44ECQOsmnUi7pEA5Pf0EedgFn7WzjWKvOyawXlmaQN/NTK6WJW4lXBSt
         BFXfmunqnZjRReov8/xbdpfuK2voy1WXXwJ1ZUHW+TWByy8skOMNblY9kGvkLPT8wzVm
         +8jQB9Qr9gR4bJQMyZK6NlUuxD65s3CRKDDLuIL9sJnvEqHN4A7JL3JI1PByRrn3pGr/
         BRzW6/jYXyzsK4B+J2U6lXggWGcA0jD0KWmADEdo659SKvepxi6dP/LJBy3DihnP55+r
         f8Cg==
X-Forwarded-Encrypted: i=1; AFNElJ9P5jQ1IHxG4yx7Z4dTVBH6HmxP7etEyBpA+L+rgGtg64i6ZRQd9PsI2wblH5RqJbhfAsK+NQjL2g==@kvack.org
X-Gm-Message-State: AOJu0Yx+XB93arHmLjv5MRzE8qgz+aSe2fV0+w/ytSkIfgMlJTvc8oBU
	2keMqrJnHOFVYMQx+hnSeGfYvGjqQjtVM4/Lq+N9gSA/jpKMBHFzR9WptntqoeZo984Ra8aiARA
	EY6bbos4rpoaaYkxYrh+sRv7FFTH7NM0=
X-Gm-Gg: Acq92OFhPI5m6iDRAH7Ey6IJVRoDTD/eaFJdAUcoKBtbmIXupKL+HHZJY6YQZ5IOTq9
	ycCdEQPwQZzFGDiy6Vs6FtThRgAFuipWAonln4iHS6az9KHINOJFmb9VPOgHOkhSir1ScXi+7rU
	796rCNKNRZ9yqc+9lQ30rMZVIoulcPilYrfJo1NGy/SJVkdqfSU+rdXJB2+dnV57TfGMojmiuY8
	TnkAz4jcVAW2klPpY71Zx6/aZ+mJFN92MIcON9xZwL2Fvn/FvgTz5HjHNf/vII7p9v0dEh08tTE
	5Irf6riJHfVWjvCFqWaSeH5rW8Oe3Klo61HFrE1ZTr97N7wByktebgecaJm0
X-Received: by 2002:a05:600d:8494:10b0:490:c2a3:3304 with SMTP id
 5b1f17b1804b1-490c2a333c7mr48350065e9.35.1780679234309; Fri, 05 Jun 2026
 10:07:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260601113449.3464734-1-hch@lst.de> <20260601113449.3464734-2-hch@lst.de>
In-Reply-To: <20260601113449.3464734-2-hch@lst.de>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 5 Jun 2026 10:07:02 -0700
X-Gm-Features: AVVi8CdLmvAoS0RMcYSASRcEhj9Pv3G4lDr6mflHi9oAfY5N64gbailnuIedE4Q
Message-ID: <CAKEwX=ObrYRK0cZ+DqkmKD8NGcWV_R72uv1Ab-L4+W6pNA5DQg@mail.gmail.com>
Subject: Re: [PATCH 1/8] shmem: provide a shmem_write_folio wrapper
To: Christoph Hellwig <hch@lst.de>
Cc: baoquan.he@linux.dev, akpm@linux-foundation.org, chrisl@kernel.org, 
	usama.arif@linux.dev, kasong@tencent.com, shikemeng@huaweicloud.com, 
	youngjun.park@lge.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EEFED20012
X-Stat-Signature: aka534a6a8osa39ea6rbgs4gtsbaetpr
X-Rspam-User: 
X-HE-Tag: 1780679235-763933
X-HE-Meta: U2FsdGVkX1/KPkuH2Wl6r5Jvks13NcfYJswg2mmbp60ESbN9paqSyH1XXl/WtYN6dJbMox8jVmkfAIQkxQH03xnbxEHnu2yZ0xTvpYy1LZf4uVVJBHzVE/u3ELHRG0D5hJaofTVJGqlODprwdwcVvYX49c7lOj+XtLOaObBqbqWyTg0RjB0cXQlPMldR35vu+8DS62PQFe7TUoWZ2coMJwO1m71BxRW0cmYlCeqXKVlgRrrB7nVbbs55BJYhSbV1o1gzsejEoaTTLl7fOKWIGE+R69cZg/jDoPCKOm0oMFjoik3d67b96Y1Hlb4ItJ4gJTJuu2iU+3EKFeMcShDoYtMXA6x4yUqheKI50W655MJluwoiD9IBLnj11sYEc5EL1h1QQmGZH51+iZ5PyGv4rU2BwmRAVzPhGq6CJTrpXL06qeD/6tLMNP5NbA6reDIKav1+Lxc/Y+i2ZTME7NMNMcYJ8xnzqgfAnnaYiYUdsXaBdWPbW/f7gSEQpa8VhmvNIFbEKvuqXMaArGrXFl6fA337BahY7u3UdXhNpoLaA5UCcdbJ4ICcT+zhaSyfmX+qu0xwJ5cWd7kdQYvyD0+wqG41i5zXVmTCTWI8ZAlDsBzIL1D3tEtSlpLPHFyNV7F2cOeqPXbxBu/UXy6Psdyxs4PyDB1+5cI8avv6FvyFVBAxxl6qW7uoesf3gLvkvPmVrzDo6DtBsYBdOhvQhTXAHpLCSmVJi/7ef2Op/zbXvaTq6GMmi8Wvv5tu4aME39hzZZK09SlCFf08TNnICH5oKEgaL3e5G6pGujCM7NP2lutgGwM2v8EUAnU/5auZA3yvZPkRAJ4afLLa33Tv74IByBxUeUg5iGxpGZD3kteSd/4iAEJKYA+ClymkGLDPuhkwCofeJTHW1AKLv4MsLkjrkgvBbsnMcgPTrWF6FCRXnNLY2CuB6r9aU1+WYQ8Q/oC/n11keVqPeHApF+pfTl2
 8Z7jg3e3
 /iGM+Kqr4ARPeJn6npm9PpoqQ9rQC02MXBY0ZVId0hGHz6MLeoS727P99PQCU9ct7tPhn2txHQvEAn+UIUPUWWpa0iVaboLGKpayQj6sQD7kaxdvkG09XfaJByVZzUGXoHHlYt4TBswQEbJsPqbiOi4GqsU7DgBmK3Di5C582BlsKifL4FU5RDAcNVaOW7OXEPKwqURvRHfJY4Q+vzGtlmyC25PwJzmH1GXGd5YTtuN4Sb1hB5ZB9sAg4HhkywS1VVIBL5kYkkjS6j4ni4IsFTu4+AVPh0TUtk/QLd7MTko4IOLQr6giPwG3GZ3fvP+knk3mQA/6pclzY/HOI7+DHPwMOzArqzXKkn8DZCJOApQ5zleMh1JM8pomj4qh+KE3JfeKNlLegsW9s6ELNMxRkPVCUx/Sig9W9/M36GnhzGOrRB3W4cU7kh2p9kHyAsII9ZdYogM5N1AIkwDIFV3Xv8aU++hCUR0RxvRW+1c70FNRri0XotrBbF8bWdpQQB3ReEsFd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 4:34=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrote=
:
>
> Provide a wrapper for the shmem abuses in drm to preparare for swap I/O
> refactoring by keepin swap_iocb handling entirely contained in mm/.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

