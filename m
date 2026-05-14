Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EBCBCD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 08:02:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B0BB6B0088; Thu, 14 May 2026 04:02:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 039936B008A; Thu, 14 May 2026 04:02:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6AFD6B008C; Thu, 14 May 2026 04:02:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D10386B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 04:02:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 70AC814029F
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:02:00 +0000 (UTC)
X-FDA: 84765282000.03.4E0EAA2
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	by imf02.hostedemail.com (Postfix) with ESMTP id 799E880002
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:01:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="uFnK/cx+";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of elver@google.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=elver@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778745718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R3rMcHi+SRGerVbM0q8doN39gwMZLkcDzykkfyfOtI8=;
	b=N8dNSxFjrqU8S1XzUfAMaHmiNYwHaKFzRbwQK3CshGICLbcd3mH4pKwMzyNCafKukhvIvg
	BFZcqHeEXhWszNmy/e5rOep90Lba9Z7dUP9FIC5rvL+dk00q/TBsj9vmgl7eQWkEqM42xa
	5SkGHyKSRVNXGdfv/YNh+kzezfHa2es=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778745718; a=rsa-sha256;
	cv=pass;
	b=ECYFCEwxgOwzamlSsx8EMX4oeea3WdRuGlIxD7QrVV2xFUT29shsM99f9KMCPTIxetOEUP
	dTxbJtkUkJrzy7xeoumyVZosVroTh0DjaCdXL++8/+MItMNohxG7oTeQnmxNIBUWHKhKKy
	1gjq9DyZkG1ARZIG7rraQEvexjqQcEo=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="uFnK/cx+";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of elver@google.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=elver@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-133466cf955so2007261c88.0
        for <linux-mm@kvack.org>; Thu, 14 May 2026 01:01:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778745717; cv=none;
        d=google.com; s=arc-20240605;
        b=V5w44PFk7OVdWLoE1Ri0uOVPUfLosfHjY0+G8IV23ISmVRNp/AXVKU0g94seD8GWwo
         JSKuVBx5b+hjzXGiyHRXqrAYarUGA1Lm1YOAfB1ePDoej08Su+N3xmBElyY5Z8PoIRvf
         K5FD6PB8NSCUMKlsBVSvgGBYsMjSprgsmME88A5tmrTCvQ2U2fMN1dx5SOzsEe3Snjqz
         NOVEUYnKlWy8XI3NqfwL7R94SdqB+BC4HH+m4y84i0B3PzJ2d9teC8CSNgtBaucqJM59
         r7bj3hU+/YBpr8O7m8OqHFPx5ccYwEBP15Uasw28ltT1PYyaxrLZLhwqpffPTJemdJni
         ZNUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=R3rMcHi+SRGerVbM0q8doN39gwMZLkcDzykkfyfOtI8=;
        fh=fwOBllu341+QVq/9N+auFUdLS6RRNRTlxBZXZukleTg=;
        b=DlhPmvmNaUfLVnIe7Eg5CJqon1/ivPrAMHILf1xEKMnLsJsbzOKBTdW2dahENlRzsv
         ZHCjmlVxqyQUYZFpzzsVCCeR0GFORfwzqvfnRGdnSBZo2nCnfeX7B6IM85EMAol36KkL
         2d2KpQyqv5x9U7l0fRb/88tuP3pZt1Xf0omKJrVWD+umdNmKu1azTPW/M2iuxzs/Mgcn
         IhMiL6CVB4nU8ELQFdtFyLF9Z8CCE70DeLvP/voKqK4xXYwEvH2/lztI+7WCR2TCeAkV
         +ebS6/VhLYbNauEfV/fD+goZi9R09PisWQ0hPlj5+0hf8oP3gZESphUSphKGAqx1dw41
         2bww==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778745717; x=1779350517; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=R3rMcHi+SRGerVbM0q8doN39gwMZLkcDzykkfyfOtI8=;
        b=uFnK/cx+qgMz+DMDZ/YNA6A8CW0jtgsdSKkAXfcf5Q/78L0LwbhsddvYP6kE8OWoEM
         IqovhkbT3gG4GdJmzd0z8rHfu4U+Y8SSJyUSTcBwUCCOVfR63P+6vBicfClMEzb08Iql
         jHKm7XOyRznX2yB7vp26gVLfog9qQeRRATXh/h6mT2BXEIGGLIf/2WLrufvkoVU08clm
         7Ap/fFNBRG2/7qUeyDvEsETmxqH7sbiVPmKGtv3efvyI2/+bjEwjFxXMay6QSoV6Fh5b
         9/18ZDNcUfsgxJywwL6nuMB8A+OO3ljYxjBkiC+ACUcvXz3uMOzg4TVL/5/ffj6JqHp/
         Uslg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778745717; x=1779350517;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R3rMcHi+SRGerVbM0q8doN39gwMZLkcDzykkfyfOtI8=;
        b=aWI6zjktrAjkeANzZezgw324uZIFa+fNd2KfMmTOLc3WOzmM47LStuuANoQzNzPwLx
         pVwIyCRzUo2b8C0sGNnILkVfvE659dYFSSJhEW5ZS4kJ000qnKJ4WGCH0jZ7E1Tq467d
         JkhtLcipPggeH3NCejGLIkcuvaOO1RR5jgKN4TFWWn/n0m7U2jPjKaF+0Io6GQjOmGKG
         /mHsa7qzJPARj/MuG7y1Q/KFOBDyY7IFOZd6n5OmIOOx5Cm09qlQCmI3OCA7xvDP0MZj
         99dcFpKu4ZcqgLXVAFJc0DfWfAXjFt6N1NrD1ngMXmE45730q1vgTPXNxj4AUlZA0Nil
         vWjQ==
X-Forwarded-Encrypted: i=1; AFNElJ/LnvSNKhNBudY60nGZ3yTXLUKm4kkXj8BIZv0BLwezCimsThhGwX2wSG2i+aikNMaMQP7j8i14LQ==@kvack.org
X-Gm-Message-State: AOJu0YzOcju+LB1/VkaLKFR7nz32hNoMzJAbHRogBjL2J/hJtJKIRsvF
	tXi18IV7NNfBgpSNKE4DpIOBQC2auElVq+gUOnxs8Z0CyirQi3TPWniB3VvYZOAZr4NkWRsR0v+
	c8ZXCJOu0rqt+kF81e6A2CYKOZyrizqBkQ/n+5QZx
X-Gm-Gg: Acq92OGCGbAvpXnhUd84Z/UE+/k+zaX7i8zmujnyB3o4TC8oqrNAxxn1dMSkWp21Pwq
	BHK5++kvh2n95mpz9nLvO09OpqudATrbd86j2oe+VuE9KMG2ujZKaLtgnpBJk2oUckPnWKS1IgA
	KUkMwRDuU8dDtCDqI4kf5hJ0VHOPPanQXqTWpKW9XEiYMXZU7T4MpHdZwetGIBXZ2FWJLJul5nW
	QKzHGwSfM2h617H2mmzGzYWxIC8cCxJAynKGYZqpTsw8EIPZ4voDniPwI9V9mPMrD2IBPyCIvQD
	td9VDlQyx2gyIpTNg38U2SOhy/eQQYtAJpQvvNiBdvXp8s8DfQ==
X-Received: by 2002:a05:7022:b89:b0:12c:5e48:4c01 with SMTP id
 a92af1059eb24-1342ee3e06cmr4229857c88.1.1778745716497; Thu, 14 May 2026
 01:01:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260514050455.2954509-1-justin.he@arm.com> <20260514050455.2954509-7-justin.he@arm.com>
In-Reply-To: <20260514050455.2954509-7-justin.he@arm.com>
From: Marco Elver <elver@google.com>
Date: Thu, 14 May 2026 10:01:19 +0200
X-Gm-Features: AVHnY4LXtb13xHae_HjNLF3uu8TPNuAYGsyBqY2dhhK2QMuCmkBsOtE8ngXwGcI
Message-ID: <CANpmjNNAb0apuxu4+tdihHr6PDmdYK5L7Fhg_3SxrVG3UV3_3A@mail.gmail.com>
Subject: Re: [PATCH 6/7] hw_breakpoint_test: fix test_many_cpus failure on
 large systems
To: Jia He <justin.he@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kunit-dev@googlegroups.com, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Brendan Higgins <brendan.higgins@linux.dev>, 
	David Gow <david@davidgow.net>, Rae Moar <raemoar63@gmail.com>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Petr Mladek <pmladek@suse.com>, Kees Cook <kees@kernel.org>, David Disseldorp <ddiss@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 799E880002
X-Rspamd-Server: rspam04
X-Stat-Signature: 6g6mr95ouuzi6ykkdz1h9adgcjfomq1u
X-HE-Tag: 1778745718-641023
X-HE-Meta: U2FsdGVkX1+GO1QVYL7uG6Mhx7Q8r84U61Pc84ph0KucUssuq+Lh72hjkrMrG9+zNiLwvA8jHMwafOthzZT0fzA+q6V2tcJW2XDUE6P4whDLVAcRJead1TLm0Kllf8FMp3mSaRcGbSn9MN5RhAYU7CSfXXO2Up5nLwhmZFhIVAnWXjy2NsAksxUcxbShkOpUt5v/QLs6IZb2PnGyIyUOA+ZbG2Gr1LS5clyLrSEZKzbLOwT76SuHRri78hiM9Pry9ttj8jX381LPqztmSVbHlS4oA/XgV0wNkDO6biAWsJPR1oP5uZe7uorXmQsjQoihLKq7rX0Yw1sMrmyq6JXTeJpLkaSMvI3VAOacftp5gX3x6XYPIkGkpxEr8RxwFl+UkQ76IVJ7g4kYZi+X1n7d4JUIiC0zVRCqOQ0v0Abukbf67ism+lXQrnXXVYe4i45omxfq0X258JwXMwrJrqhlZtCmtKpidniy5kUBgFA0yV9WHiEWhjHvC1iabx35hcBzn53JLkBRRWpIk67dWM082yBLoQAoxnvS7zZa4JspaxXMA+DIsPAdELMwb/WEmJlu9GGjxKXsW/kPh7UaoR/rXC5z5MCeLKXZkmtyrlk7OxfwgdBrJ0WGT1fqKzuFSNiiwxKVHrOE//7GsIpF4RDUrSw9cI+dzBxmBNa1l5aq7UvNNAXY+TqEDhsiocuTMJ9WRmujvLOUJyteu6mCL9O9y+C+ZLaKGCH2/Rh3s3u3Uo3kcwnRa4zOCNZqXtfO6bgQMrQZk4Sc75Z/n3oB/+sxoP6WraKCuLd8LFWPvsKR2ihk1KaE86tAA30yo6Fd8kFzvGU1+7h0WZ0tVJQHvByAX+fVzI+Hdg5fAUzRSE/r4wBcEC3T53a4bLwl9zu9L/9jMox7geD1olY7Vg8g21jyax7RUWdXpK3Zaa4dNRbbYAx8s98cuFb4MIJkMHF4ugDdjGeeFuU2uVVk2Avm+Gf
 lqJ/z6Ds
 FR9IbCclf5mRoacciONpks9Lfki+id03PLSMZdVYGUzZT+l8WS2axKjn7VQIde3bW8xfbm+jaoL6PQLYUBPgBvxqvwIKWxcVspJlfw8kx0oSzLhL4GZFo1zzNyMPgGkewbnwdde6CxlgscCq3ZZLsSomBDuha3nG0j5o+Mp1iRF1rddBG8uPNBC4qGH2ecia4mEt0Ss440kG0WFiC1T47DFoS2genHiQ5dxI6BKWE/0WEbfvQyQJTAiEZ+LaDGd1Rkr2K2gsbwtoJ9F/9iRR12SJc9iYk4At5qDWnBchpt8eZy87jaS71XPUcH2ChmDb8AYI8chhJ4cwn9h7nDoHn64lw6RCaVzsAPfWCeXoygBu7qTxdTzt+a86UytpoiRP209Qa16owh1ykW/1GyNT4BU5ET0BJPZBLK4mcJFrhThoAZU5S4IVT6pYOAIIu5tQhALc56ebJ9zLqVV5ZoWuqQAY6SBVeh48WSrosgrU1BCuR8/eIaSgF5B+8YtkV1IGEg9V43esJ/L5nq6oVo8TUkWme15+zlA/ruLlzIRr9GCNR2Oa51EvEuwcCvwm+HJTy5TVFNzaesNt8O1+seHmT9AVJEvZAf+F9ImOe0ASvVStGKriwHb1Z8nyf4ZNAF2hIBU33
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 May 2026 at 07:08, Jia He <justin.he@arm.com> wrote:
>
> On systems with many CPUs (e.g. 128 cores x 4 HW breakpoint slots =
> 512 = MAX_TEST_BREAKPOINTS), test_many_cpus() advances idx to
> MAX_TEST_BREAKPOINTS after the last fill_bp_slots(). The subsequent
> register_test_bp() call hits WARN_ON(idx >= MAX_TEST_BREAKPOINTS),
> returns NULL, and the -ENOSPC expectation fails.
>
> Bail out of the loop when idx reaches the limit. Earlier iterations
> already validate the NOSPC path on other CPUs.
>
> To: Peter Zijlstra <peterz@infradead.org>
> To: Ingo Molnar <mingo@redhat.com>
> To: Arnaldo Carvalho de Melo <acme@kernel.org>
> To: Namhyung Kim <namhyung@kernel.org>
> To: Mark Rutland <mark.rutland@arm.com>
> To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> To: Jiri Olsa <jolsa@kernel.org>
> To: Ian Rogers <irogers@google.com>
> To: Adrian Hunter <adrian.hunter@intel.com>
> To: James Clark <james.clark@linaro.org>
> Cc: linux-perf-users@vger.kernel.org
>
> Signed-off-by: Jia He <justin.he@arm.com>

Reviewed-by: Marco Elver <elver@google.com>

> ---
>  kernel/events/hw_breakpoint_test.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/kernel/events/hw_breakpoint_test.c b/kernel/events/hw_breakpoint_test.c
> index 2cfeeecf8de9..943d040d2224 100644
> --- a/kernel/events/hw_breakpoint_test.c
> +++ b/kernel/events/hw_breakpoint_test.c
> @@ -137,6 +137,9 @@ static void test_many_cpus(struct kunit *test)
>         for_each_online_cpu(cpu) {
>                 bool do_continue = fill_bp_slots(test, &idx, cpu, NULL, 0);
>
> +               if (idx >= MAX_TEST_BREAKPOINTS)
> +                       break;
> +
>                 TEST_EXPECT_NOSPC(register_test_bp(cpu, NULL, idx));
>                 if (!do_continue)
>                         break;
> --
> 2.34.1
>

