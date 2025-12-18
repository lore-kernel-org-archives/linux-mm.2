Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51296D68BD9
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 04:51:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97D566B0088; Wed, 17 Dec 2025 23:51:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92B2F6B0089; Wed, 17 Dec 2025 23:51:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82A506B008A; Wed, 17 Dec 2025 23:51:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 70BAF6B0088
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 23:51:10 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ED39C58B68
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 04:51:09 +0000 (UTC)
X-FDA: 84231367458.08.125261A
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf03.hostedemail.com (Postfix) with ESMTP id 20EB22000A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 04:51:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nEGfj59q;
	spf=pass (imf03.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766033468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p/fjAMH+GqdS7AFyxNmm90EtUDgKLoDH4Y6dQno02rU=;
	b=UtHhNtMVXTYmBuY2or22lgAfSMHPL9CHQiujn3cTP48+W1il5go6kOlvooIrv7hnfcqKlE
	iL3pt2aEV8A1U8TQ4p5FJx82Pk7HS6DTTOWhGVdSCtBSly4jbkr9DZ8jVeu15sb2/q5TF0
	fDGkWHBtT/73l7b+Nk9IZeSYeczwzDg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nEGfj59q;
	spf=pass (imf03.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766033468; a=rsa-sha256;
	cv=none;
	b=Uzk6fRsPfAoJceaacQhteCdzisiWDlDbhimcBW/DGfHxXLibhelRtLwEXSsOg4Gn10HBo8
	50LY/zbu7t4GgBfGl2eEArUDTzb7petdaBEbC9pJ7nqI84FVgWAOZZPHBL9dRWgZFS77k4
	HAlUijwJiUIXOMusxy32Hy0yOkh4y60=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8886fdf674bso3012106d6.2
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 20:51:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766033467; x=1766638267; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p/fjAMH+GqdS7AFyxNmm90EtUDgKLoDH4Y6dQno02rU=;
        b=nEGfj59qD2du5RAXhCB0WPh4gwmxIskj57o9EoZphACzHMQcJpSIQtWhwaW23e6AFa
         hLwxHDe9u5FkVayOERpTXG/05kfamTCbc5na0658nP8aibebTrpiuq1Tu5xd9nvZ26NI
         m3Eeq7IbUhTsxB2704B4/4kq6MBBIQG5Kv8ayYNwWvoYmd8tYVuTg7zsx9FWVuqSYcrd
         3nc3NSan/KDoTww7c5pNtu2socdRtLg/8Ox6pm6yDUDPk4HTR3NJY1cMWUI3fIXY/5kQ
         fCjQP8wy3een08TWtWmhHkwNNsskKPZZE8m1ejjz8EH0ReY7a8ynTKr2hrX9ReMBe5c4
         Rsyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766033467; x=1766638267;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=p/fjAMH+GqdS7AFyxNmm90EtUDgKLoDH4Y6dQno02rU=;
        b=oKTbiMg/UY0uF8LRdoxFtdqXrWI2wQjmAnTXuhP64R4rZigZp2tZP3TaZ+cyCFuvIR
         XNpAso2fuR03jdgrVJe5qjYQOm7h3wSvuhdeaE2VjLIsqhtziW1TiXHnc4QahE43SmQs
         lzzsxUWPNVDXO6z8/XtF9QFgTSvTog0RqF5iVZ1GYReyX+3n0MyHrICx4BeN2DURApkq
         TQN71+ct8fusiIL45E9cQ7bNilUdHBz3sEKJW0rTOM85qRX8itDkvDJlBDwI4qrYMeW1
         Y1gtQNwRJpnvam9mZQbJEka6qkkT63DYSho+XL241qYXvNBWTLsf4bzPmreg5ksDt8fP
         QddA==
X-Forwarded-Encrypted: i=1; AJvYcCUt5ZEjB+ahS4Bb2UXtCxCn6AvYhotpB7ZxjbDVqYEsePCeCty2YQXqa+O1x7j7LaI7WI86MuroaQ==@kvack.org
X-Gm-Message-State: AOJu0Yyq1Gtu0nuVWRMIVrOwo3YJ1dEHWqAgxGBE9ZDQ0fkIxL6ME661
	yK4yl4uvGCVnbpRE05UDVxkPXsaYeGuNpLAX7ou5ISqHpg90D2WsvJmqig9i/stHR0kYbsUekWO
	67EFALhOwqJxB/gMem+cz9ag2mB6rnNE=
X-Gm-Gg: AY/fxX6JpF46mT8qf4LTGdoWPHdCEJL0crJn3CIsc3fNICGjZKUnnuIBRFjb2qUpcqk
	M8f8MaK6StHmlMBQZtJhhbt3QIoPUTLeKkdOho3Ua8a19LzAPUimam57LLwNnmq3HTfd+sSVrjJ
	sXp7R0pN87BtMctq59RDO/uuCOpiEf+lWdTk4hKBF5zkAxUJKLLLw+cKvux04h8+/ZwT2apKmMz
	cdmQsXl1eYsIC6a7o1Jd3/4xEgtmg0ODCXQtd5RphvfrQo3azxWQ0s6YbF1eMOBszwATg==
X-Google-Smtp-Source: AGHT+IESHvvB1atonWJ1kLoKGpDSYHZRtDqeLr10Dg/fPX5OdpdXmm4DcSEfKpE5Qyjk4wg0qpAsj8wbLjqjC4sVbSY=
X-Received: by 2002:a05:6214:5e06:b0:888:8783:56a with SMTP id
 6a1803df08f44-88887830807mr233911546d6.49.1766033466886; Wed, 17 Dec 2025
 20:51:06 -0800 (PST)
MIME-Version: 1.0
References: <20240717071257.4141363-1-ryan.roberts@arm.com> <873458zzg9.fsf@linux.intel.com>
In-Reply-To: <873458zzg9.fsf@linux.intel.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 18 Dec 2025 12:50:54 +0800
X-Gm-Features: AQt7F2o2k4t0qBQRakEhfvbpSXVxQEeopZF5RsemRA27XRf-wUY3EYtQ308SMWU
Message-ID: <CAGsJ_4xhL89OSrqZitmdVPFDBbdU+AP-UeeHNoef3uRhnL8RLA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 0/4] Control folio sizes used for page cache memory
To: Andi Kleen <ak@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, David Hildenbrand <david@redhat.com>, Lance Yang <ioworker0@gmail.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Gavin Shan <gshan@redhat.com>, 
	Pankaj Raghav <kernel@pankajraghav.com>, Daniel Gomez <da.gomez@samsung.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: cky8t1ktk4orzfc3gk376bw58o9ynye4
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 20EB22000A
X-HE-Tag: 1766033467-419344
X-HE-Meta: U2FsdGVkX1+EbX0uA8mpH4+7VwYdgGKlV0jgXsI4WU3lAn8GUNW3xtx+/h/TQeecEKGKwX491WEUhPjD6oPihj/Z5YcLUWq8MjhMy3OT/3PsEHtuVzglgb8y3vK3bKJiw1hFFEdcjF4M0ebqE8p88dMn8Y6VZY9jv8aPt1ZNDSVw2XKUPSRs2I/ObLRxfSUR+6Zo+EG4gz1/rueqDKTOqxMYbSPKBogYV2vzTYZBptb8bHy+D/3BFcGIarnvdCS80waeUEV1o745nGaY/j31xrhODLycaEBhX6D8JkDW1NnJPvjxOrqDu0qweQDhcaa3zndmBI/9YSGhV8M3E+bsEzQBlBiS97hYE296rOZB9JHolTaj4TnDwzYhu8CIAbCyvxaEefPE2z70bNEdSgHiBcXTQR9SbejwO2+YI+oJEb9YnTc/7GDM5Iukg6Ec/H6524FBFoFvCDfowpP3zFmqU6F6ZteL//ffK8YoaxuCN+WM4x9sYqUqlXY6i3/XbBuQE9U14zqu0E0WnHC3YUmu/tl0d4t6VcorjrAtuCOc80TUPmOMYnUoctoBgJd99yzvK7AQTOuA4IQlmbzPzLtA/pndKu15ecZtITW2mfxM5A9TYPFhgx+wyZKvDZifpcESW5YSWrGzgg0TbSkog1TKpR1v1m/2zxwDehwhJIBf2Jd2OTdXn/PnBUmztvo7xFziAmE0qke8yiUOMVtCX3kv2AAVo69Qs+SqKYds2JWgfV8nx73SGWyPUAc/ohvPpccKJdp9SdTaQJhccenCvaHAWPRDUGL7bCSSUyznU5zQMaa8EEoGRi6l/W5mZofeW8ctonPOZDHaX0fUHwy/2PKQEaz76S+xjP6jPq6ctjHxkYwNoeoXUqFO7NpBEADWCrTwrLM1eY19Si8yymaL7OYmqmyywNp19wUrra89v583kORAXc3dD4z0w7JpfG9d7fTJNQXHmxgeVeNDYknLHZN
 l7D8zfyC
 DWBA/eqeKst89cUrDEDmSIDPgq59MV7TODNVB9j84eyb7+xwqHuwl1gxcuz5mg0tHupHykpsnJ54t7aXF9NdNEEy8WXX+SEzyWCkSLGCuHhXwGdsyD8JxpYT1gd7MALrr7mlMlWquBAoJuQFLFG2JgKFgl0R5sgeLPkQKC4a0L+oZiWoc4w1KNE0NC7KWUFYHolrzpzG1LqlOBgoXqMcUYp9pT3O9Muzk/tj8ZxLHQAMLH3sLogy/aVS5To1p6nnCMbMUfkP6GOu/IHciTZ9ajvhTKGQnMy7qi/28Ftj8XySmNYqzFKEgDGb9uCLpAGYMgHMHOcmBXwrOVyqW7gOdwR+FhTtoul7sSUJfYgdix2+w4eRyI0zOrmGgomsfQoOYi8zZe0B9tUcNPnlSie6LZGAJMfveYVfs0AcbPjc+ziNpFnarY/Sd6770eEQukCY5mKbpieMpSoVUbET0lwvXweDbJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 3:21=E2=80=AFAM Andi Kleen <ak@kernel.org> wrote:
>
> Ryan Roberts <ryan.roberts@arm.com> writes:
>
> > Hi All,
> >
> > This series is an RFC that adds sysfs and kernel cmdline controls to co=
nfigure
> > the set of allowed large folio sizes that can be used when allocating
> > file-memory for the page cache. As part of the control mechanism, it pr=
ovides
> > for a special-case "preferred folio size for executable mappings" marke=
r.
> >
> > I'm trying to solve 2 separate problems with this series:
> >
>
> What happened to this patchkit? I was looking into how to efficiently
> get larger pages for text transparently, and there doesn't seem
> to be anything better than such a heuristic?

I do feel that we need some controls over file folio sizes.

It could also be implemented using an eBPF-based approach, such as [1]?

[1] https://lore.kernel.org/linux-mm/20251026100159.6103-1-laoar.shao@gmail=
.com/

Thanks
Barry

