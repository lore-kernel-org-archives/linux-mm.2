Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3C1DC43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 19:27:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E8676B009E; Tue,  7 Jul 2026 15:27:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BFB36B009F; Tue,  7 Jul 2026 15:27:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FB836B00A0; Tue,  7 Jul 2026 15:27:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 429226B009E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:27:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A94E8A052D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:27:56 +0000 (UTC)
X-FDA: 84962965752.01.734CE28
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	by imf03.hostedemail.com (Postfix) with ESMTP id BA9852000A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:27:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="NY4azb/n";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783452474;
	b=n+U0mn4PgFrZfPAFOIJQkJxbNmOw9aeu/Fa72wElXM+MlfKCfF2XEHR9g+LY8B/H+WenoD
	8ar9aGZwC5e1dD71VIhSjTuMdNQWVfN8H+1Eo/cqYTljzT+yxyczWhfSIZ/d4LbY+KixPt
	6e+B9eoTuzWUQPB1+ICV+y1x6c0K8rk=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="NY4azb/n";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783452474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x/zT/KOHuhKyboLsex+zTwqeUVBvuax5dVrmcGEe1rM=;
	b=EFv2FQgkCUQblYaEvbD0kYLcOuRhU5BVGxpO4ZGyLHAA1MXcXdTh5cDR1YyCdsQF8EBjaw
	qLLVu9I4bm6/wzhHSOjJ9oIrwjoV72ZcWEmP+XoFBHTTuQkLjonL/ZtPb49A3AO4/0sbXt
	7ttBpxBpQF72fkw6J9qOKbpzhc9BB48=
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-39b1eb7bde5so34833621fa.2
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 12:27:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783452473; cv=none;
        d=google.com; s=arc-20260327;
        b=msxnBP0jGfw6TXgI1mwiNYWCb164atsGKlEZCj8qIJub1hxPmSd/cnVsZjt7b8Cccz
         DRbA58LekGg+a+DPyvv2caYWs0GlJnFWpC5slLN4tzScFYuprck+1D+uNHoFCZ3RDelh
         +G3jcb+ApQAu1ftirZP9zML1bhY3IeqIrsFXFW6/SsTrCjIZKi0ghlsJwDRqZKrge6MZ
         w+9aJZBYYyaMYWyuzDnxciW1WRG1Wrzj2s/8O3PWhxk19b4iNRUNYbxQauL3TLlzNCXY
         jwGw8725vUgh36zX+9zTqWTK6BTKifDIELKGUeb3IDSSrp1+DmGYYbkoZ7jWEG6li9Ui
         m2eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=x/zT/KOHuhKyboLsex+zTwqeUVBvuax5dVrmcGEe1rM=;
        fh=a5IILOg8Z/eNidyW/RsKby25s1rJpJW1jLs5nPt9zcs=;
        b=icx6ZelFbTuQr9cEEnrVrA5+CipiDiLrleuwIcsNsyQRJZ3Lgvj2vloMFDtn3qNwqa
         E2IouGOOQEX5BfUY6avIPaBeHcJaqYtfT60pdAQ86yIQSKHQOj4hDWWWr3B0vl7Dthc0
         YOB6dCT0a9x6VEhC7Qb75cn3B8DAn9KZSCfosgHOT/AHwSTA01xftSOtbHUGaApAZGzl
         rg57CllmEQTpAzcWvBmivyJawAqgkuLg/VbJ8T8+4n52pXGhZyrv2yNMggnNNf4kfv0j
         naF6YTDeMUxza4DaHmzdBfd4t8rcNPz+YOvhsGmr8XmMkEc2hMY6+bmk8hmaFVQWstnq
         BETA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783452473; x=1784057273; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=x/zT/KOHuhKyboLsex+zTwqeUVBvuax5dVrmcGEe1rM=;
        b=NY4azb/n6dXO2Xs+ytzTP8JiKvH+VN9qiuwXLEFKLtX8xos23j8cYXp2fgNQDH/WKY
         f4vq5MjkBgsic543byTQKMybiw2X6QskSUAGsko5qF6meGMo7QbisMQvu1Uw0o+lObN8
         ksmrIhjr8LOwHA0sbmQWG8L+o9mmK60XdfmUeY9BD0WSLAExItz1RRJzunMguSwDcoJS
         wRe/G5hYs3KM30k3Y/eS9SZ968NPcnua/zmYbRzPx1NazcDYw5Hzzk5BlIvcx07wXE4o
         BJvZPsvNk/xVPxyPCEJ0SpGkvdTicTKYH5sqIYQuzWZp76q1chvHnbuDirk89H8nufc1
         0TXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783452473; x=1784057273;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x/zT/KOHuhKyboLsex+zTwqeUVBvuax5dVrmcGEe1rM=;
        b=JsmOt/ei0dLXKd/gf8Mv1O/6t1OyttDhVAUL8RTXHOokBntYYhErU7uXMbT2ecL8H8
         umr+mtjSV6EYAUo9etOTD8GFMUx4sLAMO60mkNDslh3xsfizjhb++Tjo1ziuH33SowwL
         9Eo040qAVWfuVzp5bVIidhJQps9kR5tt493Cc5wDnSPG/jdA7X5IqnFRfYwei/2UcAT+
         xepWk6uq3JAqC27358IQTe0SFGyUr95jCJIImNkMSwocOwCjXtyfjACArfpzCMNSbBS6
         YGaBv7jpQJUWU8MGwxc7JnEiy6Oao/s332EEq4/PPI/QfiuKrR/P6EUssdOf9mH74fFT
         yT7w==
X-Gm-Message-State: AOJu0Yzm3QbtF1iW0ZkhpyFA3j4SPwFo2koffdVlfsemAgFPzMkx/Ams
	UqT6f66AZQiM7kBOqeWC3lPw7Qa9OiWwoz933tHZ3tmEULKvKGTkWLQ4Y1tgl9LMNWD8gUUBYAT
	isv6uYtFODgI3G53DMe7uxLMwZLlE5Ho=
X-Gm-Gg: AfdE7cnNIOHIcEpAukQfGpXFt20cQy3c+lSgE7XNhCdDLif0CtYEkL2G2E9b1zXTSda
	mwT6kl0Tt35gmYCPE9bzMl6J6+NmSx/IZtG5StpfPDI+TQiCaPg6xsE/+zyueTJTdDd8H0hS99+
	1aJD1NAz6xdMI0POoN//Y9j4Pj+5ehgoF3KVONFvaCdIgHaA9mto3abk+/UKkynITuYwpp/Bmjc
	Bz8dEgqoBTajTAR/pXuhtOK7Gb5upSkTNnq44mJ4wZyJ8PjD5azR8FKB0N0MhDshr2NYAnlrJBf
	q5gFZztEZT09JbITbtypYvP3NNxx
X-Received: by 2002:a05:651c:3251:b0:39b:3adc:70f9 with SMTP id
 38308e7fff4ca-39c5fd1c331mr14492261fa.1.1783452472604; Tue, 07 Jul 2026
 12:27:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260707073215.72183-1-baoquan.he@linux.dev>
In-Reply-To: <20260707073215.72183-1-baoquan.he@linux.dev>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 7 Jul 2026 12:27:40 -0700
X-Gm-Features: AVVi8Cc-00RvfPoV3V1Mud8p8ql7s8DxJKRcgAojHF9ALpyEYvASnCDAK2BMBIY
Message-ID: <CAKEwX=OuikFwr-miW+HKfnk6djMU8ehiTQPnfchFCyVcfefDLg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] mm: store zswap entries in swap table (Pointer entry)
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, hannes@cmpxchg.org, 
	yosry@kernel.org, chengming.zhou@linux.dev, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, baohua@kernel.org, 
	youngjun.park@lge.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BA9852000A
X-Rspam-User: 
X-Stat-Signature: u169cu3su6ptdf6odn56xai6jchcak1w
X-Rspamd-Server: rspam03
X-HE-Tag: 1783452474-575162
X-HE-Meta: U2FsdGVkX1/VJxD54xW9Wjt8hQgBvRB64BWUxYyecFqCC7eQQQE+Y30+oIuQpdOoNUeB01ZPv6v7iPXKaW45xQc2efkxqgBNJf+YX4bLRw1kCc7bM3krjdasKHVwYwIM6Uz61c/V7ryBv32vz1K2XITcSbS0JalfWnWHr6KkuVTDtWKa3NssqxMyy8/Yl1o0ucJ3ylRuSH4y08hPyptsbu1aOuZwHy1b3do+G+0Xy9yknSeFnNuleZTb20WwmR4+gaeaWfznJwoQsWsD4YoKrS/AoC41Ja2+rytCZo9z86RaXqM2OEZ56RzTAkVgd7dbXxWg1LRCgHC/YQXUPA0i+l9zEhurptXVV5xZvkV/emKNaBX8SO4x0YoUFpanltEpHgkC6dodsNtGYdMGWr7w67CFFvAHcLGCIraGiEwtUWeFRg8B/myAxPt3OlEXteua19nKVFMwAMXbkbbpqshU3q/cqQn49+GHxBH0pGNqg/tfbQanjN0eRXdF3lS8Nss0VzAXnox19VecNitbc/rOLufwt5+90YItlpOgFZMN5EtCvEErwtKZnnmkbcGCEIqmW9L9xcJoSBa+h8UkdSMp7A2USS6KW+6I85Ui5M6emHSZZD5vJQl+UciltbepywmvanShcDv9ySlT31imU39heXFKN3BxMfEG0uamHQhog4SwWWe2XCnozgEyQ91El7lR/TSH7wHhyO8/HczsJG8f5wpmOmzc43o1ihhJLSCiU/o65jYEdZK4F/czG81nCFIsb5MKfIeVybMVX62lmveWyGDI4Jo8FbudS+TDq00PnJBsSRJrzBzyJnYs3v1AsyB8vBGW2qjgNCwl5xiO4pw3//OalDUyfbKHN8Y6JRoZsVtQb+sc3WVgHG2GxJkX8s9PZHyesYwLESqUOykwud5tsaYbPIO3hrth8TAqYFMXfxZMz0+O/t4QtiUrAUDKC4c/KA31Tb0L/MWMf0+ipQG
 xJdhz5ex
 OyjXZFJSM0mRcNk3Wm06a+I+/ZLjybE8KlpWXU8Hdo6LgXNNMpQQ6oUaNtTYbBGMdiysegi80DTdMsivSDat8+h7U0TWtll2JrHCXCLDExa9Ch44yKrjmHiNaQK1Dfb9NU2ucxJ5zglMPmkE8zqSKmaJI/5084+39CZp0CY+kWMvWJ2DyzYfSL1ksCFoqp7+LNnE43tPTHTNg5D4L47uCI4luj0GQHkILjV98l+QrxN3ci8MCKI4o6NrvZtMt4M6Pw8O71aBFq/j+Ld4suUjTaqL/WuqyxnSjFYUpa8mBF4JfEP0ctO1hHGRfhIwdWYVXaKlpKm3Eq1iJeynd/v6QYfA1wHK1RIu4GQf1yrKAOf0evgRy4H7eeJ4DQY8oiVURa0LByvC+xWPT/TlkhQgWItTdmUB0Rd+tcKljCHQugwzjVh2Mlg9MfoIQ4ILET6DhebllromUHzLPpdhZd7p2MOWM24HkXxTMhfHm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 7, 2026 at 12:32=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> w=
rote:
>
> Currently zswap uses a per-swap-device xarray to map swap offsets to
> zswap_entry pointers. This introduces an additional tree walk on every
> zswap entry access.
>
> This series replaces the xarray with a "Pointer" entry type stored
> directly in the swap cluster table. The new swp_tb_t variant embeds
> a zswap_entry pointer plus a entry count, eliminating the xarray and
> its lookup overhead entirely.
>

Have you had the chance to review the virtual swap work (latest
version in [1])? At a first glance, it bears a lot of similarity to
this.

We're envisioning this to be the future architecture for zswap :) Is
there anything that is missing that would satisfy your use case too?

[1]: https://lore.kernel.org/all/20260612193738.2183968-1-nphamcs@gmail.com=
/

