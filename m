Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36BFECA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 09:27:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 811B68E002D; Mon,  1 Sep 2025 05:27:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C2498E0022; Mon,  1 Sep 2025 05:27:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B21D8E002D; Mon,  1 Sep 2025 05:27:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 542768E0022
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 05:27:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EA6455AF70
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:27:03 +0000 (UTC)
X-FDA: 83840152326.23.F67A9AB
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf26.hostedemail.com (Postfix) with ESMTP id AA8E814000E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:27:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=WhyHRKw1;
	spf=pass (imf26.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756718822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MNIeUEBbK9RQcYOVp0G3Wf/xu3aWLubcZd1r0MvEs58=;
	b=fJxKpDlKDI6Tz7wzYTI5inEaFi/U51seAwSDt8w4Q4kiLMqZ1X3nF6+6pqDEh/18+r+OH1
	ShwNLXctoSs+KkQG670Ua22hiZ8otEnq1my2KQsnQ8U6XPcCYYz8SEu5Jimt5MXVQ0wM4D
	n/lKp+rXP41cm8pKHMD5vSfEMxSH+kk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=WhyHRKw1;
	spf=pass (imf26.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756718822; a=rsa-sha256;
	cv=none;
	b=ZYAUsVWxorheRP/wpIUrIFRMpMkajqZMM6INPbQcBsl0NSmpsSJKYXR8hBgT8O72HPvP3L
	8cNcOOgUL61ttgQgJUFRGI+U9VhRZ1puZVnhX9tWTvUKdl15WM5SQKmbGzx4DRj9sxF4Ig
	5YvbKxs1bN5tP56BeJmrGY7ANEMB5sA=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b042ec947e4so105083766b.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 02:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756718820; x=1757323620; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MNIeUEBbK9RQcYOVp0G3Wf/xu3aWLubcZd1r0MvEs58=;
        b=WhyHRKw1LpGUXbMX8ps4/BDenpXS1mYLgG8JMQRNSpex0+C5lGchp/0GeaZLvgl2/c
         px+l4iGC6C1HrzSoNHGDPgbuGEtI/K+0mIHIB0KuW8TnIYfIX12vmf8meefJ3ntFQmHq
         b5bFAsArsqxFMpGSp1MpaJ6MF/eWrTL/aWaZwfud7MIfrkNIZXOu4CWCsuZ60jOdkO0l
         m3aeaEPNFHM76MYp/KkKDPezJYFTruTF7NLiJkzPSUpyHBzOy3tiETTzn+QbmoYOK1FF
         mz9aOwUJFnqIBjrYROZUL1JlVqGK8N4nv0+GHAQ/ojICNulQxUMisEQaq7b3cCZucK6q
         8acw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756718820; x=1757323620;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MNIeUEBbK9RQcYOVp0G3Wf/xu3aWLubcZd1r0MvEs58=;
        b=ugRPxqtUSx3sMKqGtuw1h5eL+gtzfx5aRXp10RDIJg7cMIzhQK9mntPHLrkvUvwFzg
         cHTHC8Fwj8m8IEFRtKCWmmU2GXtTJMeAEM1By3KdVVdu3s9IR7KpzT0HWOwC4hyevwY+
         0y1f6zh4rqYZGZSLgZbkJTNCwMZJqFMV71WzhRbWNGjoaFIr1nHxJ3I0hHJ059x8Wubk
         y6PZCcxao0D2mr178R7fd8/ILuTHYOvHCtieLyvY114XSi7ZyQE1TLrajPFjbZSxqMpZ
         LiXsfA+roo0Ijd4vxXNyYB1jG4H0ydiLTaYmHaSSviQXKxdlVUq6rlQAKWQ6Ff1YcXKz
         M/1w==
X-Forwarded-Encrypted: i=1; AJvYcCUBJf3qmsm2Ha0ILYth2mn0f7B1gd+ej7RLAft1+PcQLAQf8csmUXikxiGg8Fvr/oY13Uchfrxekw==@kvack.org
X-Gm-Message-State: AOJu0YxyJgq6F8gLe0sn2PgPcVF6K/jRAg/V0j7odonVkGLPZud5Atu8
	cQLD7NIFoT4zpqKJ1ZCDs6BVdOowxxIhKxf1B4xGWs9ZP8uz4QgOXmUKV8u7XM7RGwvyNDlQAqJ
	2irLX0X8CsnPWT9U3yg0Ih6iSJYOI7JwZherdJ95i5A==
X-Gm-Gg: ASbGncvRSlz4WGSN0+eMOkxbbkPA9hWCMm6E5X+FYkX0WeDCEAXFZJzy34mtXC3F6Me
	88kkp8zXNtEXcwjZyTuMOe1DSHWEe2XUt4pLgxsw85cl3S3AHXCNozonDhZKjycdkCikCYi04oy
	P6ZlGQkAcxDVjdlK2zXw5e3KjNj5PUZhx2ycXu1nMPAo5caqxWcd9+JLzPbXOoLhd2NqSBibAZK
	S3gldSi5HDe+kLrPWzGlnWxqLaC6KS8qB2eCYZ8+5KSiA==
X-Google-Smtp-Source: AGHT+IHPjYeMma2R8IKd8tuU0SSmI/fxLC5AjCUvrN9XhbYjrH2iskmxUuf502Yh0ewqk5GEbVaCznHnlu2wEtsxGvA=
X-Received: by 2002:a17:907:5c1:b0:afc:d3f1:aad5 with SMTP id
 a640c23a62f3a-b01d97a0be6mr693601366b.49.1756718820097; Mon, 01 Sep 2025
 02:27:00 -0700 (PDT)
MIME-Version: 1.0
References: <20250831093918.2815332-1-max.kellermann@ionos.com>
 <20250831093918.2815332-2-max.kellermann@ionos.com> <day257vhz3o7hepucfz5itjvdtp2k36hkqdg7hckqleb4jxyku@rs4rs3zhl4hn>
 <CAKPOu+-ZjNr9hEir8H=C5C9ZwbS7ynY4PrJuvnxa-V425A+U3Q@mail.gmail.com>
 <e3ec5583-adf0-44c3-99c9-5a388c43fb7d@redhat.com> <CAKPOu+9CiT-5P--6TZcyq=jHLDhCa8LDh1AYjKr69+0shO8UrQ@mail.gmail.com>
 <244b73d5-39dc-4bcc-a69c-8ae3010b40d9@redhat.com>
In-Reply-To: <244b73d5-39dc-4bcc-a69c-8ae3010b40d9@redhat.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 1 Sep 2025 11:26:48 +0200
X-Gm-Features: Ac12FXz6IHeh8Yfv6vNOMeXqRNe1GAYft_5waVwiI4C3GV_dXwn9QLUdaEOpeQI
Message-ID: <CAKPOu+_wQ9DDHOQDtFeXU7ZqwvwxYqXNqWeSP3zJpfC0Cm2YAA@mail.gmail.com>
Subject: Re: [PATCH v2 01/12] mm/shmem: add `const` to lots of pointer parameters
To: David Hildenbrand <david@redhat.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org, 
	axelrasmussen@google.com, yuanchu@google.com, willy@infradead.org, 
	hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: AA8E814000E
X-Rspam-User: 
X-Stat-Signature: zwiwbg9g64x7wpxr8yg8oszpj4xsihr5
X-Rspamd-Server: rspam09
X-HE-Tag: 1756718821-739784
X-HE-Meta: U2FsdGVkX199epdWr9/H3RUw6cQsQnTRoVdaXskhFUufg6VzNL7Kg/T7NZ/DPEALXJsYB9Bp+OPy+qsZXd1G2pJAmq1j/QP1hImRdoHuA6NxCV8v1Nk3LGzp2BnJR+SJ7wt3PGulw0l68PdzU5VNHnGhNs2pz88RRLCFLVBCSFb6XTFLjnBdv5UdS+ztO+kRJUZEZmPrCFM4l1FqSVy+EhlIW078trYhRYX2oB/mCu95WlsxDS0EEYQZY5ntJAio9JhrsT7eJvoIhtyuOv2AXPtizjXCxijSKSL2pVcvoPjXOa3TZC4vTSPqdz34W8C3tociA004aBRiqRtUM4WtEtTXy2gsVhGM02B7GiPYixf6SoPUH5sCNT+hZtzuQ7ofkFq0cS97mJQcczaq4w+CvWAMD/qvL4RKeXo1ndkAdWWPJqgPeQ5aBkNybJOi5vDRo2UUbWl/nqF1YTXkeME/+kYpsA3UMWOL04RLLAV/O0L1UanuURHGWFpKdG1eArKRSCjhbIL28rTDTVm9jVPRXiLAZdWxGJa9GcltOo9e1bJ7VR/d3bu3jvwufU+27va6Bmbw/FYpkcEJyAtf5U6Ioyp2k7/v6FMi2V6n+KR7qA8t/y1b7o10hXQrTSuO+7Cg04Te8AjPd83ijciaMYFWYbC2f3jmh9CrTV3z4d/7PQ1+nDWnFwFd4yUgdP6Ti5fJQUew8umNRlyktWGQIpMd8BPUBrOD7WOsiqP1BbvgdTJTLMZYLNCdGLRj4Tl9/HUGdH2Q01ub/uVI+Zpt4pzh/x2WDmdMbNIRMYkSBoNev1mQmkaYQ07gqCxc5YXIXivch7qz0knTKkUpbrmGcajhjIrC51VFznWqgMA7FDPtmZtMl62JqVVGxfyaMBXRTGZQCbtlPJFc5qv/vsV2kZztPT4sJF+NdQwSufZ294mVIehC8IE5e9PCL0oMMXEyrtHmDM1Dm8TnBGhlgsdtIwk
 TtFRiwiQ
 pqYpdn+0DkTRUA/93druJy77SaPlmC/PRxI4kNS+yW2lcWZbvv9nIvwadx5h4LzMFAxbhmch3lSNseoHtxdoW+YrTAZQcf2F9VzhM0WhQUFAyxw6spxodp/t48s0Brl3OsfFt6tfeZJPSk6aNL3ThyQZAeAeglJZ8XFbvmHRb1hfZHxSXIbtESUKESWbnZdRYkWJFPELbG/kV7RQqIwxJ1ElcOTuS148AN2f9PvVGL5SljBNY/wj8KTB7uPTUUhJKd9iqkuvn/hzOnidH/XYA2QbQZ/Bfo8t4abUc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 10:35=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
> We usually write complete sentences, and there is nothing wrong with
> repeating what the subject says.
>
> All the time it takes you to argue here would be better used improving
> your patch descriptions.

Sure, but first I need to know what is really needed. Reviews on LKML
are often contradictory, and it's easy to get pushed around from one
corner to the next.

I just posted v4 with longer commit messages. I think that's a lot of
unnecessary noise that takes a lot of time to read, but oh well, if
that's what you guys really want...

(In the days of LLMs, writing is almost free, but reading all that
redundant or generated garbage text becomes impossible. I think it is
harmful to have so much redundant text because time spent reading it
is time wasted. But that's just my opinion.)

