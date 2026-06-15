Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60715CD8CA8
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 02:49:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A56656B0005; Sun, 14 Jun 2026 22:49:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A07616B008A; Sun, 14 Jun 2026 22:49:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F5B56B008C; Sun, 14 Jun 2026 22:49:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D6856B0005
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 22:49:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1EFD71660AF
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 02:49:33 +0000 (UTC)
X-FDA: 84880616226.09.CEFD59C
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id 217A91A0006
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 02:49:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZTaI3gZ4;
	spf=pass (imf19.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781491771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OdNFcwO3pIUwpCvp+zldQiEXMUiRSxo4K+xl6iYkrdw=;
	b=ZB8xqU6/Nuvkwa77Ktcouz+6W34bwzXZMQ5OQ447TEaZ8OLbj6M7ZJjTowmsYaLGBPWzh/
	pt7Xu8KKogZ5U0FAhvgUf0P2ZaaYgPmubQnrMNb/FzjvoQUXXIA30h8wdCxKnAYz/AnUt8
	wMoF+QNUUHxQSPASFuZCufGeG7duTtM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781491771;
	b=LkzVzVojKs9LTAV9+gOzFeqa16z/TjHXo8HitXmyr96FB5QQmNwnW/q4cjeXEB+9eY+IYT
	PXvh0Aa7QbJOkKZM3CFDHp/0aedv66pMex/7RwHY4a3KbBK1MlwyT2y22XAMlvi9pGSaVw
	sGtKczB/nc8rO9Oq1d7YFIAD2JDIb68=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZTaI3gZ4;
	spf=pass (imf19.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-490b64c8311so28765355e9.3
        for <linux-mm@kvack.org>; Sun, 14 Jun 2026 19:49:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781491769; cv=none;
        d=google.com; s=arc-20240605;
        b=OLdEK6olCbPoJYpnXB2EoCnWA0tFNFbfypSa//QVwy9gOiL2f/RQKuk+/zMjuijwQO
         Q9Ok8Sy5DDQrU1f/YmApDVaPCmBDrieB9GVIdStRtNfwlmjLYXQfh7oDXk7QIaK1NM4n
         DsblMpE2lm+Cd5xFUTXdp/dRpmqtht3skU3vAt+SxYlsrJ6VaGG7p1JWwi+hq9xwzaRg
         dwozF3Jn5MmO+CVLSev+YHr4y5ItcD96RnNN0OAJndtqfoLhIducJCXxS5ZHUfvR3n+O
         DOir27yPz45zWIhKE6B0axre3QynF8eN1kGWhjCnnRXIM2w12vRP5sM1u5W0eFAPEtWD
         Getw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OdNFcwO3pIUwpCvp+zldQiEXMUiRSxo4K+xl6iYkrdw=;
        fh=Gq4V1vUEuEHL4PeE8q048qIHbyLxtfyIjLYGzfA05QA=;
        b=LQXAy8SjOyTBG5+q2Y+tjqWdGANdkHyJWwDOXBBLGe8FU0ch9AgKzZelrQnewEu9Gz
         Jb4cv5W7A9hLWf1NZE3e9MyW6uKC067EghbZylSfkLPLKp4sYUdb2Wota/XaWa0Q3O3x
         RDzLp2O8VP9CdrzyYjbcMMsNr+DpM4LHR+r9Q06V5I/c8fDeeXN5ArgBXWn7OCYNzQGn
         yBD2LBqyLQy8qkIZbhf9GU0jKWyitZKDwgE/a4I7Kc/RxviON3NHR+w9ZuAwOIznVmY+
         h3BdbEFTlqEvG8cQ/mw7kgO80aNlQrmSdSDB9iK2qcRyJMmSbfMaNPmI8hpIwNVy9ssg
         WryA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781491769; x=1782096569; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OdNFcwO3pIUwpCvp+zldQiEXMUiRSxo4K+xl6iYkrdw=;
        b=ZTaI3gZ4mQ0oXd9V4bmpykSJSFgoW0i+U8nz7+qESCFZ3biLGQbZ4SU4Gd1dG/AoNR
         ttAfJu/+sc7bNM8Eyo424RKXYWSbAPW4cy+tZYg8QzfSiafoTzqgy9NXMQXu6JgCrh6J
         8EQAlWPN6GkTBEX8eNNIuUE+OITLoU7BKXXnZu2KlfRdRvoEpO/ySFVoJvQcz4LguC3b
         +DiaBiMgw7twVy7yFbN23fKh4EXGDpuNEb35dtmqvgSVO1x5tkCCdhw4Q8iN0Bri81fV
         9A7B6TJ9kPTuDVuHEU21/r25BBzWeuNoWW0gb+AyBS4LXeeFnQA3HKHzD4vXTnqAn/GF
         TkHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781491769; x=1782096569;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OdNFcwO3pIUwpCvp+zldQiEXMUiRSxo4K+xl6iYkrdw=;
        b=P7m+Nshdq5ZDBD/H2cvOZyVvvARfglMFiHoa4eQZRsk7MPJYAf5f8kYGnKp8hv454X
         QIl65DhR1OSNcINhb6brJbtlzJ5ghLkv71yIomu2MemMy38yByyWR8KWsmqz1h2tPMQn
         GpG7CqOJNm42mBl2nUxMEKYpB4SsMTuh6uVYG2c+kunFEW369rwI/h22vo65cK3K+9bZ
         tGDWbPSF14mo7HVw/VtfYeFJvkNG1hDfpTslE8F24isJ4N+ZQ7+xQYrUzWOI7AJ9qTai
         Kpm3Y9csurKOLYyST9PgJ5FVu+lgPNufCSiTlAl45jE/GZQ+vdC4na3MM07y4y5hosz/
         bbUA==
X-Forwarded-Encrypted: i=1; AFNElJ9Y+gRbUmKWd3dIjogZ9o/uy0svl7I2k+/nvn6cVuITaQSIxZMSm3kNvHvVvLb9cXAA9mgYOrQEYQ==@kvack.org
X-Gm-Message-State: AOJu0YzXxrUrys7/4pDtJpxJyOTOPP7IkYqyfX8VD73+mNX9q4kCdvUv
	rd2e+CYQQctzitvPSMZvQmCt3M9sKuy99PdLoyosLTE058+HDQzk8v6dIy5ZyVTRW8/YD10fyW8
	L5IuFTQGxCuBkaU98kStOyTUW8o3occ8=
X-Gm-Gg: Acq92OE7VANumEMKwRDq70m1wXZJ81PtLcYqzGmV6ZOchc+EXkfp/eakCvEJajwHsTy
	Xv9Td7GaXHq6OBBtS/+p/3P0mBmI+dvqZERgnjjk5fTGYFlyJftV2oVJ/MJvYbM+WBUYwO/GcFU
	onztcMNPN29e/mLUMF5rDWnqJE4Am9lEVvRTBhiZSf6a4lki7zhBTDXHSRUrcpPhXvpaceHIdCo
	Q35sD4BkrYrTcqfHWBaAcTZaXm1e0vpap/TX90Ukl/0rz0KXbCb28ytoefn5QB3to5A932H89bp
	8uI5BMDZBNotqn4w9VWmljhTMeA8ezGAahHP7Q==
X-Received: by 2002:a05:600c:4595:b0:490:c7dd:7cc2 with SMTP id
 5b1f17b1804b1-490ec4fbaa9mr164234075e9.24.1781491769572; Sun, 14 Jun 2026
 19:49:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260609113520.3507783-1-haowenchao22@gmail.com>
 <20260609113520.3507783-2-haowenchao22@gmail.com> <CAKEwX=NoNXqk6koBYMSjaQaiMfq-dRaBxuFpYdrZyByxs1g0xw@mail.gmail.com>
 <CAOptpSOHcbOrukxx_u73jhNyHcFNAg+BYKNqWxDcHqTM+k55_g@mail.gmail.com>
 <CAGsJ_4w+3RYwGqmNvrF9ragiFNW+_mHfooQ5pOwGDLTzLUNomQ@mail.gmail.com>
 <CAOptpSPseFH14dyyVQrvfLxqjSXFUyhoVg3GXsQh=7qktJ85Nw@mail.gmail.com>
 <CAKEwX=MjWMTV3KLUDtfmGDM7LiRXNO5au85==SwFqpSBAQ6Wzg@mail.gmail.com> <CAOptpSOHNA-wSqfCsB2-RhM6AzJpn4bzDf4dXPcQrSO9g1tx6Q@mail.gmail.com>
In-Reply-To: <CAOptpSOHNA-wSqfCsB2-RhM6AzJpn4bzDf4dXPcQrSO9g1tx6Q@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Sun, 14 Jun 2026 22:49:18 -0400
X-Gm-Features: AVVi8CffijpEIs1Mji5uyaNR0BSLbM3RBdOWORtkxJpolItiF_Cn2oxkZTBBC08
Message-ID: <CAKEwX=NmEVMoDcEbKCja6+FGpjd6k6MDpAzqaJSYFZ61we=Z2Q@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] mm/zsmalloc: encode class index in obj value for
 lockless class lookup
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Barry Song <baohua@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 217A91A0006
X-Rspam-User: 
X-Stat-Signature: 13bm8syiussgmrknt8r35npjjsky9mdb
X-Rspamd-Server: rspam08
X-HE-Tag: 1781491770-518908
X-HE-Meta: U2FsdGVkX1/s9bYkTXGYvn/QvONTxZ9Exl37kZVX3zCMweXn6gDeklu1GdOoXd4gvSwOhVrkoNNH4sQBdl/AJ388Gxwae5r3Agp568MS4imT98gJ/Iy//VlvgHnEHAJEbJnMDV1B1RP6LpDOfI1CsdeN4T19cDRwUgIot9tmkPvvgWXB3IIS9zjOTpsw+50Kwuut1ByyZ2Wf7pgvU9DCPOErkS0e+7SmbEKpvmoqqjjTONXKQEzBNgboiPMP5Z9jvFoNkOLdrO70OyQ7XlIyrLeUwWWwROMb/h1zh1JQMSSKJUKqOh+nIpWRliq0JoRn7RCGo82e0Nv8LatvhcJKIH/j3RCysq34CHXpdN7WJ5VGkRRU8vb3lY+6nw+luijY1KfHXGwT0UJyUeuw7CY+1/h+sIq97XKCF5jql8t5opAmLg6UwANxUDQqIH1UFjVppucKgFRMqvlCDrCNw6vyte1kOVoddW9YGbB5DYDgdnePefEbnl4lE/pdcconE2B+Uyoj33GgG59jTkI9hQFFw41u++SW6DNtB0ONB6TwLG6kdnwCnZCCSpa8oPkXRESevaIcGRngXjziWxEIiW3y9WTUlLqehO6wDIfcyH0i5Iq2Acsyohr1q0uqLXXQmZEtZEy44JEkWZNkiShjTv4HzqAi/OG5RYiB3ejFCEVTeuWzx3Z8RJcjDT7HjIc8Qwulbj8aY+HNHG2fupFx4S++MGAfGki6++V5bVbfPVwusyIqLJAGaElEq0+1e7cjhh3deCDdLF9+TSOS0saXcoeSKa0FjI0CF04N7CDH2Ve6QaMXPtGH6zSKAaqXI9KQn7l5nLAHgqwWtw/5ARFGJMcZc75gMPmNplJOM40og7Jw4aKvjf7xxWSNQ85KL4fUIXrICpwG/EYhS9W9zqV9jJTizGlXPnhXAtM7n6E3JD7yeX8GOEZ4dYE4aZX4M8PuqndUJjuSJcspgq9uRsRjh46
 a8nak7xZ
 PT2UXESjIGqHMYfXNB5eXncXvK2LBUL3TbBOqZyZBMnvwvOIQQy9TeBjdeOy+wDMoM9ViCp4cmfi3ZARY7BvLbQ2PHO1yll+QcacqIbaVFz98+V6oQdpWezmHRb5A0nJFtR417sPsdbTBl0Ut39484uRpDVL5YhWgn8SkW9IMoJBYkjeiXKdQRHRvHdDyDN3TqHm7MNETXLKhzWHEsUJNLRV3oTBDPYVFax0rpigxsBBD1p4XmEMAjrIESHAacctX1k3poWDTAE10f7wCAnPlcUQfGzs+kOCJks+Et5anE3gDY4eMrAr3yZq+ov8yOqxpfsY04w1I9BIQ7mlH/gQCwoJTtTRRefF1mg9gDVoa7QgMCNeROscYHjGQY1g/fbEj4CnFUoAMn5FlWH6wx6CHbP0Wx/xkLXbywEKYJI1bXFKfqilCKbAm90iiGyFlt0SQXxXCJ1XUY896BVHFXI0+JwzoJWudWccS0SreJEbUIsg0Tc/dV6dMxHXIZqqv2RwvR764GH3NCaJhVTM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 10:00=E2=80=AFPM Wenchao Hao <haowenchao22@gmail.co=
m> wrote:
>
>
> Thanks!  Since the rest of 1/4 is unchanged from v4 apart from the
> rename, would you be open to re-applying your Reviewed-by on the
> next spin?

Yeah feel free to keep my review tag.

