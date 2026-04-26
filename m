Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1952DFF885C
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 14:04:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EEEF6B0005; Sun, 26 Apr 2026 10:04:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29FBD6B008A; Sun, 26 Apr 2026 10:04:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18E586B008C; Sun, 26 Apr 2026 10:04:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 085656B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 10:04:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 95260A0662
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:04:41 +0000 (UTC)
X-FDA: 84700877562.26.097D6ED
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8FB081C000E
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:04:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="UUPF+9k/";
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777212279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1F6flvtgSyxv7A2xaS+FqSzWg67V8xN6AktR/kycaPM=;
	b=jayswaAx9z3hjQmtmc069gQci6JN2MSqaHOe8XEcfHJ+dvsqkOSpPqGA4jMMUrFt/2z4HU
	UP4X4VN381om81lNAXGh1289qTiSP4fwaPo7CxY+mYNkvopKmPg0OfDg1z6Q7e9FM0RPpv
	OOCBeu4Ptr5iyrWxav4k/ilGb+Tng5Y=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="UUPF+9k/";
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777212279; a=rsa-sha256;
	cv=pass;
	b=P4xwOM8eqX0Rk83bk17L+rlrOKKfNVGSiL5Bs1Ud0Is+28Oh1lOj3gG96RauXxoYint+Ge
	xny3X/7e33+jAyaNs466toci3eQous8yoASUgl9E/QVuyMMDeFu1eqSeXrxUxvKgqgOsuP
	SwmTfbaL+KYq5AwNK1NCvslwCwtq8tU=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-baa8c78ac7fso781629566b.0
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 07:04:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777212278; cv=none;
        d=google.com; s=arc-20240605;
        b=R8dh7q6D++ibOe1sjq3k1gjFVW4YC19HhMzGQmiiCOePIdP+RLjn9uOd38EGJ8nurn
         zlqZWUShPZ2DQdklDXzY8twEGy4tV6ksJL8pfueF53aiKvYicfmgFYxJ1y1x89gea3KC
         gi2OXWtzxrRmWlB9PniMvsOa+29kQlGWaHVZYPNhhjnDVMf1BtTND5qpIlFcmo/X4VLX
         VcNDUj+47G4eT1lCDncEPIURcFtODdlJg42vbNandLLqH2aRssfKTiE8DuhzS3DC6UoR
         5TrGMpBTdmJOUg11ZKkv1+P7Jdo4JmwSmf201BKDqDRzext90gQeWxq65djHXeQPI7NU
         ZNZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1F6flvtgSyxv7A2xaS+FqSzWg67V8xN6AktR/kycaPM=;
        fh=ZOsxhH377R5SobWzuE0iuRdV7mPcqjBUBbobIg80sI8=;
        b=JFyiO57j716dOldTLFYgERIIzQqtZH4zWyVRCfAzrc0cBQom6TBOCfn2xpmdTT5YVa
         BPN3eu/PUQ6aGiXdMih2ic2j4Ed1Gi0uisrAh6DNTB+VOjutcuVHUaxe03jqKW8E0/Oi
         Y4ZflY67BwUUPQ0bOjJjuIuLkutUchiPUxlVlUU/MQmbgKBndyBhqxEw139Ye5uALIy6
         xg/GG9dqWkvaOVdeV5MF0aoysjUpViGn4lZXQX4paxPHMiltnIyF1/32PfnzWzt7CRt0
         X1FkqarB2bKF0OLZWW7jH+8PPaz9E2ShRxoD81i2tkxJhh19K5bK95xGJnpZDtyaRIhv
         X22Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777212278; x=1777817078; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1F6flvtgSyxv7A2xaS+FqSzWg67V8xN6AktR/kycaPM=;
        b=UUPF+9k/HVBLF+PkXBRgTT7x5O1KsApxyzZXyRxvAGye+pXIup6ipjyxzOVEbx9i9I
         rfuDLsFAuyS+U9gIDScwWQs9WsCiRHhPyWC+AN/qPVI+/KyMxxEYCU0ac8f51wSEvvXz
         d6Z8C5JWIjpjxkY8pfbomqlghESykUMBcnduhtFdtZhwN07z7bbkFh2OWtbEFKrwzioj
         hVYn7B7gcBYUJ5wm0ataL61p+46MwdXderGl8XP9br0FEccGNhWwi+44H5+DqPf29DED
         J0EBrsRNMpZXJ1WjmF4/JvEePkL5nsr/sm43Z1CKz6Ul+YJZUfKneDhQjgLC83lFA71M
         G2sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777212278; x=1777817078;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1F6flvtgSyxv7A2xaS+FqSzWg67V8xN6AktR/kycaPM=;
        b=tVwaqKlBqBXxUKrHpF+N8+zmu+8AR2RzGTE/gQBUgSsWzSKQuW3XUG/7TpHGEpahNC
         460W3wvbR7vxSQlgW6PD/YBaEFi6pf+UJmkKBVlC8kQ6sgt1GevHV64nA1BJ+atnOkJN
         KMASZqSFiiRiJVi9nRpTNWOoBDpX86mwIpIwaxzlaoWR2iJSyLq4rxjSXcCo6X8SvO5j
         InxKbFIVv3fZieVumTD57v1xIjFs+O1mo7j5EkdsV+F9pSIEe/jzRpjflrM0vndto4to
         DKU3Rr44u2i12/TJgOhPvTSfz+t62LaKl+g3rlgtLiV8+gA9dRbfW35gMjXUBjNhUM6e
         PJ2w==
X-Forwarded-Encrypted: i=1; AFNElJ94YuGl7GU3E/igbQ9G3Az34lKQDtBFaxVcxF+buYnGdtHYGLZwSs76NqNCCYHZbKaOvszq75DZjg==@kvack.org
X-Gm-Message-State: AOJu0Yzze9MC7bn7r+m2da2744GpckFz64A94fG6cNvpKaHz0XWOJZis
	+Asf0M5gs18r26h6zUq5PcDXsVIOpK3CcpCEy4/Vr/Mjvqu+hOTPH6NOz2qz5oTlatbGQRHgdsF
	jOvNubmIoF8krwZlP7yKIw8lU0mwpSLI=
X-Gm-Gg: AeBDies3H/KDKoi9gRdmOgW8C/h6N1f2nLT1P4QxKzTWpcA3tvYJfFgli2G4v2oyVSz
	eFxSsf44bgsyhyS/WF3dEdUGI60haUH337JtB5CtV1c7bq/HhYlt+S7vpixFKDWtjM5tw3UrXWE
	wnbNr6VCed5en+D8pnbSyEewc8/gMIjDniXEw9r4nXL4wHSgDpG6skVdsfRFfM3pYVEZVTu+vEg
	4gBd4tifEY+HNuL7fb5YE2tYuWtCd2/RChzHkxsjApZ5zGp3aHZTWlNNK/6VFtELMfBjeDDLuLw
	VAL1BYlUss0KEfFRYQjytN5XUGFx/IGQuaWfdY9BRGy1DfPtiHQ=
X-Received: by 2002:a17:907:8e0e:b0:ba2:140a:a48a with SMTP id
 a640c23a62f3a-ba41aa164b7mr2168523066b.26.1777212277565; Sun, 26 Apr 2026
 07:04:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAMgjq7DM6Sd5EYx=PLtYHBYk6gAPFupYg2a7nib2KrGBO=HtGw@mail.gmail.com>
 <20260425205759.1701-1-baohua@kernel.org> <CAMgjq7ADH89OVheesAPBUCK11pYmje4rXTLkxRW2nAw+8r54Jg@mail.gmail.com>
 <CAGsJ_4zjdOYEtuO6gNjABm7NDxW0skzBFNRNee-k2D6VwsYEQA@mail.gmail.com>
In-Reply-To: <CAGsJ_4zjdOYEtuO6gNjABm7NDxW0skzBFNRNee-k2D6VwsYEQA@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 26 Apr 2026 22:04:00 +0800
X-Gm-Features: AVHnY4LRf41kt3z3BhWSC-hTfEoRPdW4KkjUKK2cu3v7E5AYEzEQ6fdrLnNDvFk
Message-ID: <CAMgjq7ANpFH4rc24TZTaDoPE8zPvvipz2N-KG1grwXhgd5H15Q@mail.gmail.com>
Subject: Re: [PATCH v6 00/14] mm/mglru: improve reclaim loop and dirty folio handling
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, chenridong@huaweicloud.com, chrisl@kernel.org, 
	david@kernel.org, hannes@cmpxchg.org, kaleshsingh@google.com, 
	laoar.shao@gmail.com, lenohou@gmail.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, stevensd@google.com, surenb@google.com, 
	vernon2gm@gmail.com, wangzicheng@honor.com, weixugc@google.com, 
	yuanchu@google.com, yuzhao@google.com, zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8FB081C000E
X-Stat-Signature: nz4ei5uegg7y9hyro4o7sc5wcad651bt
X-HE-Tag: 1777212279-252097
X-HE-Meta: U2FsdGVkX19T2B7F74jwSbU6+bMzzHuqZqTqUXFBatA++UDs4rRu/Cnsiqz+7wOmAfHXKWr+eiwa2R0N5AjQkQB0V2YWA2FL+Xj7qnTm394z6kvd8akJhODBchYPy+Wzphl4xJWoutrtUfRZlq4kD4kLNJz3o6HwyYKPAUTddozMwppBJva1/vEL3BLE/7KcQ2moAOXCX2VZjUiQ/3qa6YHZVhi+4ce4sEPpNKFEvSS//XiQSzScniOajxqlYlt8nvmWoFgf0mkr4EIY26V9MMOvMCMrjMxBHG9ykbks5ozwNPxi9Q/MR9fwQe8ICNjgZ+PBZp/rUDFx9xKVGM6QLhCln6ePMN7CZPGdhncuzDZvtiFft+E4btxCZZDDTOAyepnWOfpiVORuQk5mymjzCgpeKQRUnnWKYnj/MEC9/MbEEj0WnQ3qfeW1LFukElCLqel3Fy5JHldEm+CbLRyufKJACcvpDwwojVVwDFGNxTb8ZjQOTdbTTstNsIAz0RL+/5gUpcfbXNpEGvvZaOAuZF93C2eMBT0ZZGU1jkQBUwNwPQYejdMc+73dQdA86saVsj/KnwwuX3ZtdKcxCpMrGr4ersam9Itccqq/WrCWq6l+javlEGNFhdUACTk4gdZjy41kEHUwID53gkOt+5/u/XRPvzCZ74MTT/dqD87wgaAi8rAPVLtfp32RwrKHcZxnP/pTVDs5+9Ln9chbpLyBeRVx2WJhVjnvvjPVNC+MUh244lbFRrREW5C9fIaKwEkqvkOkOuBIBsDXfLikyMEgfar5sIeOTarFrDx5tN67pgWfmsten5aEism+J371kGo/8ESUD0Yn5e5tBxSjLpr+8Ik7Ik1iZkmytP2eRj3rYi8B3VS21au/kXe377EHyaboc7zk4nnOlrrCQ+bAuGTkNLgy0HDJ7GRINRii2DlkKFv8aVA11xVgEpvTuL5gqAPdkWo4NH38lP+CBzZKqoY
 eAqyKFHY
 LmvBX1YGppor6/ouFcRU3/I5/+E7FaolcjhI2dqnhslHvyHPA/j6TWxuednRlpzESqxSI9U0PIBvjD7NnjVjayhdgUwhiGtrnr51+IksojLnuy70iYHiW92aISOTDCnG/GzKfaiwP35cnPtJa82oX/+oCvmjhU/+WtbvAZi1Ne6PVgtFKrYZeC5M+lZVh3DBWS6ZNZunnCIPiNPpkiL6rddsESqOeQykX3BHMRVTm7zo96JFlHJAkKPctvl2/kf46niCVBN8wk7YTnpAutST/OjcqUEwKH5UObFVViazjuCJDY+lqj4ANSddjO8hZtO+AVeczER+1SijqgZX0rhz/ckaP++oQU/eHlBWPkgkT2Iz8PEIT898zqup+EWaCy1I6SiG2smypFwmLnMQRzHpIVpin3bRbpf2JnVsS8zcArbPTUn2/4hGG9sb/eIobVYUoNurpsWHEDvSrtgel4ilXjiz2A9IpLrx74P+Tk5ORb+mq9YNGpAsfURoRAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 26, 2026 at 4:35=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
>
> Either approach is fine=E2=80=94use whichever works better for organizing=
 v7.
> My boss would definitely be happier with the latter, as it would better
> support and encourage more active engagement in upstream development.
> It=E2=80=99s rare these days to find a boss like this who is open-minded =
and
> insightful about upstream contributions, especially with everyone
> moving toward AI. :-)

Will attach your patch as a standalone one right next to patch 5 then,
the effect is not easy to hit I think, and shouldn't break any bisect.

I just ran a set of tests, just in case it has any unexpected
behavior, it seems identical to what we have in V5 with all my test cases:

FIO:
Before: 8968.76 MB/s
V5 (this series): 9005.89 MB/s
V6 (with your fix and nitpick from sashiko): 8995.63 MB/s

Build kernel:
Before: 2873.52
V5 (this series): 2816.44s
V6 (with your fix and nitpick from sashiko): 2811.88s

MySQL:
Before: 17303.414444 tps
V5 (this series): 17310.528750
V6 (with your fix and nitpick from sashiko): 17291.500000 tps

MongoDB with YCSB workoad b:
Before: 59227.33 ops/s
V6: 79928.53 ops/sec

Still matches the V5 cover letter and everything looks great, also
seems alright on my android phone. Will send V6 later.

>
> >
> > One related thought for a follow-up: scanned =3D=3D 0 from scan_folios(=
)
> > is essentially driven by get_nr_gens(lruvec, type) =3D=3D MIN_NR_GENS. =
So
> > when the type get_type_to_scan() picked is the one that's
> > gen-exhausted, maybe the right response is also to age that type
> > rather than fall back. Right now should_run_aging() only looks at the
> > combined evictable_min_seq, so the ctrl_err preferred type can
> > silently stay starved while we evict from the other one, that could be
> > an old issue we can fix later.
>
> Yep, I=E2=80=99ve been thinking about the same thing for quite a
> few days. This might also help address swappiness. On the
> other hand, it could lead to more aging, but it seems like
> a necessary trade-off if we want a simple solution that
> doesn=E2=80=99t require separate max_seq for file and anon to fix
> swappiness for mglru.
>
> I=E2=80=99m also trying another approach. For example, if the
> number of folios in the old generation is too low relative
> to swappiness, should_run_aging() could return true=E2=80=94similar
> to Yu=E2=80=99s earliest patch as below, but with a swappiness bias.
>
> + /*
> + * It's also ideal to spread pages out evenly, i.e., 1/(MIN_NR_GENS+1)
> + * of the total number of pages for each generation. A reasonable range
> + * for this average portion is [1/MIN_NR_GENS, 1/(MIN_NR_GENS+2)]. The
> + * aging cares about the upper bound of hot pages, while the eviction
> + * cares about the lower bound of cold pages.
> + */
> + if (young * MIN_NR_GENS > total)
> +        return true;
> + if (old * (MIN_NR_GENS + 2) < total)
> +        return true;
>
> Hopefully, the above can resolve the problem before we have to
> resort to separate max_seq, which would break the shared time
> axis between file and anon.
>
> Maybe I will send an RFC before LSF/MM/BPF if we have enough
> time.

Good idea, that can also be discussed there.

