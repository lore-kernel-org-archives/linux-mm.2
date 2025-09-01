Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67BDDCA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 09:45:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A383B8E0018; Mon,  1 Sep 2025 05:45:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A10488E0013; Mon,  1 Sep 2025 05:45:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94D588E0018; Mon,  1 Sep 2025 05:45:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 848598E0013
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 05:45:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 49CB311A202
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:45:43 +0000 (UTC)
X-FDA: 83840199366.26.5895752
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf11.hostedemail.com (Postfix) with ESMTP id 070684000A
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:45:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=TWiCL4bw;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf11.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756719941; a=rsa-sha256;
	cv=none;
	b=xqt/CnHZtyT0oJJfxsmnt5CUQHkC8zh5CAHvudDtYwiqd97Vp8UFv9jVUgeLy44xDZLH8O
	1vQ3uUuFT225mVkQsyvmN80HUNNcwRijRmqlpWXBCxCDVKulZXy8fVzbaLpUcfOUezeZ6A
	19uCBM4/iznhHwnuASm12cQAK+8NEDM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=TWiCL4bw;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf11.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756719941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6t2ITYvNLE5WTPnsN43xygLJ/wnmWwmkkfyibPexe6Y=;
	b=QdDo79qdgoqfNbwDqQNklM4mjPHz6FeDtK9qomNx7a/F/jZZgQsKUDhIaBiDSa0GlV1hpN
	DHmBAkiNgtdMJ98Qmy3eq2nRHQmMMK0dU2hyByR/Jfi8JDujzKhFIPzY6/LODCyWLnmr6M
	lk2tTil/92o9mr58gAlWZeS7RgKpAYw=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b02c719a117so113358366b.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 02:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756719939; x=1757324739; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6t2ITYvNLE5WTPnsN43xygLJ/wnmWwmkkfyibPexe6Y=;
        b=TWiCL4bwATC+pbbK6HNLq5K8KFPxKYU+AKhk9cak7MkeVNm525VCLrpgWQPhAWkgLe
         7vegAXuPSphLuYZEuPPn8U9h3LVOJ+ZdV3YSGRTGE4HRtLLgBcWXpdx8laZqU7GRinXd
         +8VVQDoCMfPIkI9awrQ/I+rKKmnBNOF2pxKLpACWF6z/IB8jqYyyW7Ej99Pa5zot6iM+
         onbexj7tsRwTNXQlCFdYqBt/hKMggvvrnGGxsDC7ZrDif7wRUqNK7mhh5/8NgmEOY2Bt
         lApU+UdWqntCWEBJVvUJ6l6Bu4hL+gDPCQsggHvwDUywCubGfiXJ5hICTAxPHCLf0EOx
         8ciw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756719939; x=1757324739;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6t2ITYvNLE5WTPnsN43xygLJ/wnmWwmkkfyibPexe6Y=;
        b=Nlg3ezodQAXWuRb5iExFs42txd5SnkWkjZ4Rygv8z2YbXnTD7mAwQFemPFPL9vasws
         1KUyLEoHYinnK3EPbYEp5aI7dTTQgTR+Vl3Chh11NGOPK2Pf19Iadi5stJruvhpmmTB1
         4cJqOSvJ7Q6z/LFP9kabPpp19MmVmQbILwDEbN+yU311SQfkYSBstCmP9+1oRC72SJea
         5IlEUfza/1AKx6YuRmsRM3hw03c5VRvQmtSLpK11Q7UGhQjaul5u4UKPY9rDmS2uAOyB
         Z0wjdacc0AC4r76ezwhRn9wJRmMKbbNktkq0nLAQN8Xoum8PVKMZxqdyPpN0pVfo5V2T
         OUWg==
X-Forwarded-Encrypted: i=1; AJvYcCUaI4HJQ3F4TORbxbwBLwpXPhSHaSgxBUsokZeqvP905QYES9Lc5Km2tJzRwyuYXdaJ58QsjqsLQQ==@kvack.org
X-Gm-Message-State: AOJu0YyStqiCsGub7L1xV1UJ/C1w1FSU+joHuH2nAc/Mo88spZlKNS5H
	nLPckEQ9N8PA8rWD8n6PDPsfLTEC6+u5BzwoEdL/7y+8b2awqNwGy8r2l5YTcTRBzTxk4eFCPAA
	69ZfIpaa54ObyPwWV4wIIBMAWbFNg55EPpG9Bp8zLpw==
X-Gm-Gg: ASbGnct8NWjxVu53uv5vY8vOl4i7l9F1KHrIDbKkjq4tW2OimxV1vNBewqmrk8uyJhA
	ERWvzwxuqhxf8mGm1JUU0Sg2PqFx+RRsAyJm+2XO9ZKpHKZANm2RGuW4S0rG/KnMFO6Ll/pR6MI
	PdYvM3HhAj99HckdqzN5+5X3xMD4VDxB5jkPOxI93+fT1DPn/bZLvcVFx8oPE7TzlNbhw/sSiOY
	a6VSzXTrOGbSkelFAkAwyWWvMGIWA7jZ7k=
X-Google-Smtp-Source: AGHT+IG7cUupsgf9QyFp47qCVkb9CQwuGk68ny0b5Ceuv/evNVjr+pSVwxeV+0Uxnvw8DZ77eIdq32imbwuBG59+mEk=
X-Received: by 2002:a17:907:3f12:b0:afe:ea46:e808 with SMTP id
 a640c23a62f3a-b01d9793846mr587668866b.47.1756719939395; Mon, 01 Sep 2025
 02:45:39 -0700 (PDT)
MIME-Version: 1.0
References: <20250831093918.2815332-1-max.kellermann@ionos.com>
 <20250831093918.2815332-2-max.kellermann@ionos.com> <day257vhz3o7hepucfz5itjvdtp2k36hkqdg7hckqleb4jxyku@rs4rs3zhl4hn>
 <CAKPOu+-ZjNr9hEir8H=C5C9ZwbS7ynY4PrJuvnxa-V425A+U3Q@mail.gmail.com>
 <e3ec5583-adf0-44c3-99c9-5a388c43fb7d@redhat.com> <CAKPOu+9CiT-5P--6TZcyq=jHLDhCa8LDh1AYjKr69+0shO8UrQ@mail.gmail.com>
 <244b73d5-39dc-4bcc-a69c-8ae3010b40d9@redhat.com> <CAKPOu+_wQ9DDHOQDtFeXU7ZqwvwxYqXNqWeSP3zJpfC0Cm2YAA@mail.gmail.com>
 <adb9e55e-0023-44b7-bc88-ed95be8dc71c@suse.cz>
In-Reply-To: <adb9e55e-0023-44b7-bc88-ed95be8dc71c@suse.cz>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 1 Sep 2025 11:45:28 +0200
X-Gm-Features: Ac12FXxn_NF7uHHkLiMMFlqOfaTSrUR87f4Qa0DhgYVGwhIKOLTI7d0lR08TJLQ
Message-ID: <CAKPOu+8wK16XWCx1+7801tyE66uLBu79CySLFetCWbS3TnH3bQ@mail.gmail.com>
Subject: Re: [PATCH v2 01/12] mm/shmem: add `const` to lots of pointer parameters
To: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>, Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org, 
	axelrasmussen@google.com, yuanchu@google.com, willy@infradead.org, 
	hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 070684000A
X-Stat-Signature: hzk7kk3zx3kpt757uyhnxxf7gyy8jnmb
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756719940-165669
X-HE-Meta: U2FsdGVkX1/YN/m04/x0h311MP3UqqolCHFiLl4Cui7ug2lammmEim6ukCF88MJhRbct9dSV+iddq1WBvcRtWhiTRL3TafWuOaEf5QAnbXktm45W25IQXuhSYIABGEkNGLgiUnV52yKW2nyzWrs2DywA+7AuppTe2SKTnwvBTX/BPmJUW4ZOtknPQOl0t/hi8l39rMhuabvTNsq1Eg1j+iCDuNYlLmUMrGb1I6DOPxy9XESXubIYdzh89U2ei4Ozp/eq3yAtIxrfY7z/PkGg/1jhtN+cbHng/oIsX/pK30TrRsi0NJGqOjmF8zlLM0SsUw7c3xN9QJ4qbRd1Tz+4bV9u0hA9HuhvnnpkovBHFJMtVXTH2BvgxScmZK0On/psn2K8e/hFG+BXj6QDApJVeeYvmPEIJ6iXw+hXmer137D2X2Ow/DzVLwBzMjkiCLj68QIIPVRUvVyvkYA6l1IKcKaKw7+ZAKT4Gov9oItdW8k23UBYgX5ji5raYl8lWWI7C5gwUxUiTvF6a2+bvDqAE550/oSR+UA3LbJH7rAMvvMPn2PpIfu4EAnaeS3tpt1cECFZlYlsxrVm9tpsBEiHGhN9i0SHzZgbALKrSm0rghCe7f0hXAwbGYsn++UVZj4ziW8YZqZZVPc36ihqgN86Cbc3bcE9tTGkBAQZmc8Vxa5OVyAEvk/pFrLrBeMiKrWeG4CK959DEoUfQ/VIuNMiuzWyrz1QWe22aw1KRbWWGm8I53An5f6+mL/fh8NsL7+T5qKvAXaP7VxJW6ZifyZn/32A3r4rZrLgpAB1r5BSH/DWX+RaAa6HP64INa++5n0E6aRDpHfOTdpxA6+CCZiodH9qcHDt7axElTFCvKxe4wKp1YtqOMM6YmcRRkBbb6mkrmqZ5pCHHS0i86DzM1Do4lF1KzngX0Vy70uFmJLgIUmeno5QjuMGx56lOxEMC5EXGnsfyC9SCV5FJL8NH3S
 S4MT3naD
 vDQiEXyAGqp7vJiIyMEXwYZntJvvhndgUcDAqH+BWwJws7pCHBqGzpVmKBzWDzvFuKlaMnm9P6l9cy0fDyYtK2W4NaEeR6uyTktjkRNzruWukwEtABK/s5shzO/RrENV4jhwqKxZLQgk9ea/BZBVQAxGlAV/BneMVdZ0CWtu+X2P5wTh+UBZyMcEiw/EhgdLiUWgVD0pIWAOY1aSJIYK2CzVXyugM3GPR7ql3Wefq49DAs+/LoqqkHu3KMjz0kAaeWINH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 11:32=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
> > Sure, but first I need to know what is really needed. Reviews on LKML
> > are often contradictory, and it's easy to get pushed around from one
> > corner to the next.
> >
> > I just posted v4 with longer commit messages. I think that's a lot of
> > unnecessary noise that takes a lot of time to read, but oh well, if
> > that's what you guys really want...
>
> No I don't think we want a passive-aggressive malicious compliance.

What the .....
Your response is similar to what I mean with "getting pushed around".

You guys insist on verbose commit messages, or else it won't get
merged, you say. I don't agree, but when I yield to your requirements,
take the time to implement them, I get accused of being
"passive-aggressive" and "malicious".

Please be more respectful when handling code submissions.

