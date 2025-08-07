Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D7BC87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 16:45:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D84F8E0002; Thu,  7 Aug 2025 12:45:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08A2E8E0001; Thu,  7 Aug 2025 12:45:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F08658E0002; Thu,  7 Aug 2025 12:45:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E3E628E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:45:43 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A00DEC0826
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 16:45:43 +0000 (UTC)
X-FDA: 83750537766.21.5BB5156
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6472280002
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 16:45:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ejy6su2w;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754585141; a=rsa-sha256;
	cv=none;
	b=Gnz1bPVcA6YusIS6c8IAWVkasedYkLK78BUmMo4BSNbagBbwN7fj2HvOgzJlMbPmqJQWxo
	iMHmJADUH9jip8F7nhoDjrlq/juZqG576VKG84nGLLcDjQyfA5hE46OWmj2BBo9yRjjQe/
	DgbXb/zIJ3OV7VuGkZpzUfB01T6F8yQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ejy6su2w;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754585141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mJ5oeu3kAg6HS4OVA9rb//xbi40No26cZ49UiO4tWTM=;
	b=RPf5kGT35ZrgViOHJ4LXjefuwL7vk+fjyQOtj6ljWC41QMAtoUISfd3tnWbDynltq7U14W
	JG98JKfcSNVIAp6yU7clI9BM6noS4KnjGfoop0jcTW7d/OksTL5UqjaPGSkVYarkrdg5a1
	EIljeTOFFVZwitsjjJjBg+5J0ojUuVo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754585140;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mJ5oeu3kAg6HS4OVA9rb//xbi40No26cZ49UiO4tWTM=;
	b=ejy6su2wN5ZJAfDkGH1leOaJEVgVzrb4zi82Z41vH2G4hzi55FGQMl3nxrntcIL6yT/bBd
	9MyjxCYjW2uPShkpKC/QxN4Cgs2iEP5KXuknvgo5DTyT8AdpxadIZjmN8K0bFxABQdLka6
	O06fJpBJOaWx9iHh8nmRQhb7CfoWiq4=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-xa_A5YhkOqKp37PhKmvVhw-1; Thu, 07 Aug 2025 12:45:39 -0400
X-MC-Unique: xa_A5YhkOqKp37PhKmvVhw-1
X-Mimecast-MFC-AGG-ID: xa_A5YhkOqKp37PhKmvVhw_1754585139
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-70e72e81fafso15969917b3.2
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 09:45:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754585139; x=1755189939;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mJ5oeu3kAg6HS4OVA9rb//xbi40No26cZ49UiO4tWTM=;
        b=YAJJLkzowOzu33Abfm+Vb5CeWFPcSJViZYOQpVNJfrHdZZIQZNYk87YezXbCdpgfMX
         QfLU5XKuGyHclrw3vuXJLGSBME0Rf6s7hdDVSkJFNS+5nZvZkwuMtS0oxCSsAvDSF0N2
         3y5c0Oh7U4WYacUrxuNoeNp1o2K+jYiMUkR9F6QHgg6uoUOtS64WnjzY2RnrWOQ3WzgS
         /0OlW15LLvX4vnKmKS849wwvk9yOmo9ADiO3mTE/DQDGQR7Mubx9nwDtbmbu6D7eonFl
         hOlRhdMgAFa5/e2/E7xEABNeh53vpoA7UwREXKYTRfaluzsGLMngmVt4Up/gEv9Qnlek
         ckjA==
X-Forwarded-Encrypted: i=1; AJvYcCXFWMlW+97bZiodJg/yMCMKzoADzyKvKOZS4iKNeBdAv8pwrMqYXqQXA4i62oSZnDVbIbBkKfqPNg==@kvack.org
X-Gm-Message-State: AOJu0YxNqqsxlhmyZs07x9m77/Q7RvdPYpLeFWkhVZMQgXph1adsvCsB
	mA3PTyVBy6+/uAUeqYA9SaLZR/1jrsuI7Z7dAJPvaHT9LG0uAHVK/ud8EEZ1bm6WAPskV8wN+vv
	dzRUzUsLDYXsOgN/P6Im/TE83fmpcRIIu83orSTPKtYTrVz2+5Bm7
X-Gm-Gg: ASbGncv4nVI2VUXazlFwq/tnFLc7Yxxv2oI/mU4WsiVExV1UluQtzWVmQtua2SvAaew
	f/YPrvZaYqsZsimlcPHzLMVlRvrx2Xme/J+4A2a7a1KLgPRgVZz9N+/BcIAtfoZ8PkFqRlI1+ro
	4eq2lpFdKM62SkRFAchrUzfQHGuTDXvn3f877V8AiK7rSyUKuyFEpq+2nCym6ooLKElnIcCCU3/
	jufTro3+p9BVRE77qybZ/9OQKHPho64s8pwe5wpeuQrQ7flVYFg7QjCU3/6BXGHIZ++qEZpmHsc
	rusqeJCgaIuGHqAar6jRyT2U3XY6ZJhbU360hJwCcUfwPBAU3Ua0tUvlT7x+nMha+z3SfmDav0v
	bEE+PZ9KiauZ7VWpro4vUIw==
X-Received: by 2002:a05:690c:2701:b0:70e:2d17:84b5 with SMTP id 00721157ae682-71bcc53c148mr93209367b3.0.1754585138998;
        Thu, 07 Aug 2025 09:45:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFgbSqJY7+1sIhtBagdJKAXgNAdJDwXw5O7GuTQuwI9yzsV33fmqqWR2xnGe9+z9PsGvblgNg==
X-Received: by 2002:a05:690c:2701:b0:70e:2d17:84b5 with SMTP id 00721157ae682-71bcc53c148mr93208937b3.0.1754585138431;
        Thu, 07 Aug 2025 09:45:38 -0700 (PDT)
Received: from x1.local (bras-base-aurron9134w-grc-11-174-89-135-171.dsl.bell.ca. [174.89.135.171])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71b83fd71afsm34285437b3.19.2025.08.07.09.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Aug 2025 09:45:36 -0700 (PDT)
Date: Thu, 7 Aug 2025 12:45:26 -0400
From: Peter Xu <peterx@redhat.com>
To: Ujwal Kundur <ujwal.kundur@gmail.com>
Cc: akpm@linux-foundation.org, shuah@kernel.org, jackmanb@google.com,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/1] selftests/mm/uffd: Refactor non-composite global
 vars into struct
Message-ID: <aJTYJjj1pCWr-q62@x1.local>
References: <20250501163827.2598-1-ujwal.kundur@gmail.com>
 <20250702152057.4067-1-ujwal.kundur@gmail.com>
 <aGf_W_ZgIf63dmAz@x1.local>
 <CALkFLLJua-LeS+S5GpiXORA-3wNSR0DTzbh2bvU=Vg-Uzd2VFA@mail.gmail.com>
 <CALkFLLLoXfTNtigbcyD4RdJfY+b5Rh5-5Zta1QM9dBQxZd19cQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALkFLLLoXfTNtigbcyD4RdJfY+b5Rh5-5Zta1QM9dBQxZd19cQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: l8T4q9P4L8X3ukj7GkFu1ARw6zvHrYHYgdWWjMsWTGA_1754585139
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6472280002
X-Stat-Signature: job5gbkbtetdyaju4gu9g3qxipo43x1f
X-Rspam-User: 
X-HE-Tag: 1754585141-576029
X-HE-Meta: U2FsdGVkX197jYV2f2I0KnQEgiFG9DdA1dPF9dqDyLnFAxxObS5EUyNZNurfDaEfn8Xbkmx+4lcCv+p9YvVq5E08qR/Ro6mH1Y9YCikCMur+tHUGwW0eZbCmbFlI2z3iHb8akHCzdzAS13UYNni2oYJYCu77sFh2vvLow7pYM4nEHKVhA8ia3mwcN7exjKOjx7BJQKmHehHnsvbT/1bp6Mk+LKZL8ODWGW7TNq4r1FKv5fzki1u2AOYbNcnIYH7csQmdeNja50blFqA2mEUnKTN53ucc/91ZEXPC74xnWhYuBu+9RqMwtaNmmvKBOHF0AZeBX5CbAQdGUlPjoIwgmumzhNXCw7jTBT0iepJsGDigyrMMZ4mPX5BUBqijrmhFvvt0LkGKEYdz4zR8H6PcFMkvixHeRuDZs0NRi7R/RTUskntohvYO1nMxDzbXG39F3mlstoQuGnrA6HdpKgy5EqhWHAMBF7u4c+2P/oxeecsR3CbZU45VW9XhMQ3Z7VkriHVXQ0GYyb1xRrZbfXx1eD53gvBh0kb75AonQ5cY+GS50uMD7+ahxIt0Z1xpF/xh8b15LaG4AyjtvteIrUEQuB/I6lmSYpkUZHC3oWy+JdcQPdalDcQMahjIJ3UtiTF2BXXsPkJBaL3/XvmHt3mWb8wxtY3XoOvI8fgmUVViZGskyxoNiShBPqeCOl1pLrsVIYYd+LHu9tKmwxSFq7sf5ajb64LMnmI8+Esg9qTXqRzXCOPnEZLwCbjy22QA/0ahSLS6zykdylTj03UxHqe38b52lUnH2LceAZaBoLrC5ZrTlAp5P5+Mt70Zm1Xr/YxfjANujz8JSzAW4NOdi7j8wUkrdz5wKcFY9CqfHHIevnE4FI05Fsv97ad3j8/4JxjFa/YJN18um032RG7365LyfUCj7VrrvR6aBnhl2Eq9AY4/Y3W1zixC3N1Mzz/6zZcBGbY6iFTr3lkGKhzyf8Q
 Le86W41V
 YxonWC7a+d6/PfiKwshed7E14aHRsIC5GQAKanbYDjFx4jJvm6xU5ixJOhLJ2rRw6R26IDHEp79WJ2zyQiQ2Rtzc80VXWoN9lG2qojujo2aXccapt1CqC9I8roKBE8I+nRv2f0oyaraWOZ1jwVG6ReOi3fBFi9PPzlf93NOhh5B/r8FyAnJ4Gevh6xeCOYvv0S2YJRbLkr4K2P10BM9CtRfn/zGa3b1GO3x+fNIOC/LasFpyNQPC1u3OkHR6ML2cLKRDJi6e9kofRwxtY5QmS+pSt2abfL0/xSU4gXpt/i56/gyekjceZUAPnyaM0y2iyJUXXqsv7HWMjeJhzZo4Y8PF6MFyJx6d7p9fj9pVu/ybFowc39zXR0873Dzx7/G+03ZeSLLiXCqxjMvW+8ok7TFZxRuoyrERUAD1Xaoiwn2S9uVKkJOxUNVCI+wV9Ott2/Po2YK47QaNDnVx0u6mquc+UPcJxdWO1qKbj8sLe1H7AZ7UQdLmIlC7mPQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 06, 2025 at 08:33:06PM +0530, Ujwal Kundur wrote:
> Ping -- please let me know if there's anything else I must address.
> I've ensured v6 still applies on mm-new.

You can try formally reposting your patch, instead of replying to old
versions.  It might be overlooked as discussions.

Thanks,

-- 
Peter Xu


