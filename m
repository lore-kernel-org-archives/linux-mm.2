Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD956CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 23:48:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B2598E0014; Tue,  7 Oct 2025 19:48:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2CB68E0005; Tue,  7 Oct 2025 19:48:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1B288E0014; Tue,  7 Oct 2025 19:48:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CCBAA8E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 19:48:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6E075868FD
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 23:48:54 +0000 (UTC)
X-FDA: 83972960988.11.C6A4871
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	by imf12.hostedemail.com (Postfix) with ESMTP id A303640002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 23:48:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HlxWKl6J;
	spf=pass (imf12.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759880932; a=rsa-sha256;
	cv=none;
	b=RN/pUm/YWtuItTLqBNnX7L1CfbucB04vRvwAesZnaruxbpJOcHI8g0NKH3fvFhIZidy1q/
	TiSXSOIgjvRozsLFcsjF6E/+HmS9ZXk02Yba5oUxLIZPMCwS83DnUg65ydwT5Wm8DmL1b5
	6ra8868NSYE3VqAHExVGbXr2sVI4hPk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HlxWKl6J;
	spf=pass (imf12.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759880932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KTrkGXnyKHFVa/Dswya3ynmDrTauPJRZ5aGaaq8QjdM=;
	b=AwEveAg2+fS+/fkeElmiju0Ur7G2FpkSQyLiX1eQjhNs7Z4z5SoaAYbNzj3QY33nYKR5v5
	8FrCtGNZH1UXFOP/X0JukitAvLkIpo0Eccg6W9V5982CPedaCld6XLQ1Sd0LguYh9TPhEl
	pP1W8BZXQdLtW7tLOkSDkJQmslJ8Pxg=
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-9379a062ca8so250213439f.2
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 16:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759880932; x=1760485732; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KTrkGXnyKHFVa/Dswya3ynmDrTauPJRZ5aGaaq8QjdM=;
        b=HlxWKl6Jusj2EChEx/8NXUouiziLtCDiyMJKz0TM3NWsXvDf5rbIe+To7MECWtxRpB
         alhVuCLTCrzAvkB7H7teig2RpHMn5VKPxhONkdI2TyKlDY04jyNDCKGuCm+brI4PyEhC
         qDQOkk6vUGvitgPpFg0rFLEdzakANb3nx9tL30J4Ppgyd2+BiGncTeuql+C68JqHErL8
         6gJYhSjPQvrc8RF81PY1/cnEIDvN0vGQa+3KZIfEqgExQxbAeDxwn3qB946YHc3rOtHH
         NAscx2gOXZCN7o3WadOF2apmuiPDUXlP1wsby34YTbn39vZ09oKKoVu/MfKyU4+8g+3V
         07JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759880932; x=1760485732;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KTrkGXnyKHFVa/Dswya3ynmDrTauPJRZ5aGaaq8QjdM=;
        b=q7xspEuF/aSiz5PH2UOr4iCcMzho74WEAwtGqdwMlwiGvj0c0m/iTECkHhg0gZJqLn
         4DhNkK3DJ74sVTG0BK+GibMbgXkHU16YORKc/6534Y6xFZ64adUKGx4bftxGLgoSqgM+
         cp/YAnZTxZzdgTLbP4sWq3anyXeNHo+dwpD6IHft9kA+CFzgZcXnbttMMAO5acx/KOlF
         P9vWbWYzlEI1b1X0PpcEXR0+NAitUWNh2VzL5r/vg63eMrgPCNddjfQc5jCjJlZCwdFR
         YwAgVc47+EsmWPl1YY5kGKWdOTvVXlBfUnnQx8Gpbpu8LGz/9C5OQWd6eEIw3yjYUYRy
         9K7Q==
X-Gm-Message-State: AOJu0YwkF1L9ParHiTPBUjnBtjnEKOhCb8+EwtyLhTLIk8lbP7HCSZ4r
	RMnKHfrFxmAHZXgXMymmklMrKkR2gSMnsZ2R4mj6jCUqZq3vtIpo0W3KweZr65jIfb1gryO/bDh
	vav24AhRxIulYtfpIqweZln4DD9tO1lI=
X-Gm-Gg: ASbGncvg+In/cv2ZE7pNuN6G3zfgYt7SOSIKigvpcmEi1F0nK96+47ZbD13JObtIINt
	8m8u6iTS+2/weruCazJY2P6Px+Tr52F+6gFr94l4zkQlUPbOkY2LlmnLZ6wPQUysOudZCwWahNW
	lqfU+HGfTA4h1Xi9pPdHGkglpsqOgpBvRZiohHJOeOkKx3RL1g4Q8SQAkteplwVGqNyZ6TQy5jd
	t4W+uJ2dFVbEiIxVsNCcZGTaKQAUoRN2MiV4NHqewx2gWGJG+FXY2UYgg==
X-Google-Smtp-Source: AGHT+IGj19t24JgCl5KO9V5v1EPwjahIu3R5hY3KOGEPtfgUylqfyLaq6Gthhlzw4D29h6T3Jq4pX4DjEtbtAWVOp6w=
X-Received: by 2002:a05:6602:3f03:b0:8eb:13e6:aed9 with SMTP id
 ca18e2360f4ac-93bd1966acamr130126539f.12.1759880931714; Tue, 07 Oct 2025
 16:48:51 -0700 (PDT)
MIME-Version: 1.0
References: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
 <20251007-swap-clean-after-swap-table-p1-v1-4-74860ef8ba74@tencent.com>
In-Reply-To: <20251007-swap-clean-after-swap-table-p1-v1-4-74860ef8ba74@tencent.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 7 Oct 2025 16:48:40 -0700
X-Gm-Features: AS18NWBEVi01jmt9rUQqVyEgBnbeYQcYv9BfSDryjudvNduK48EulZs4TumR5Z8
Message-ID: <CAKEwX=OfcTDH08VrTMFL-uQyBay11H=NccYWVo73XNHVVf7bEw@mail.gmail.com>
Subject: Re: [PATCH 4/4] mm/migrate, swap: drop usage of folio_index
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@redhat.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Ying Huang <ying.huang@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: ue6w7cjt6dkowz1aogor7u674ksx5cdx
X-Rspamd-Queue-Id: A303640002
X-Rspamd-Server: rspam09
X-HE-Tag: 1759880932-592637
X-HE-Meta: U2FsdGVkX194W51qSQtoeQYdr9L8QnvYSITUOGzgxE5x8IFxr22FqgVrXD6xgVAgMRGPcNlxdCKYvVc2vnWWI7RU4NcYW6HLuXFACoDHEpkNNG9SnD9iFiGJo3x+XU7zwIcEPFB8eX3OmIiMWyIUrd3XOUL709yY4VNGmcvD14Ui8QuqHCUGrmLC+RvqdznyEIwJrzT1y2CBVFvvnfuS5paTuYG2cbGoVHwJ50ugREEWzadTL0DXsOAzdwgt8qADWjtSruyueJ99LBWhygj0rmomAzeyTjCqA0g7h41EBxldpcTOuW/iWBGL7ndeTuYaKLlxnUcSHZGtLfIfEBc8+5nKeVNhYGcolk+f7EK9kWnNQmEWjeZfn+IWIeccTJOUQoK8F2vMsNp2WDWozM7d2+4u+hbeSatdpDPFUN05RT47M6YfPVg/n/mYStr1dLDyhCF9rR0CZ2DhxWA7nR+yhfF46TbN+265yvrd7NUh/69yCgvwRTwGoUL+T4vNSu+9OpRhWtlUyHyRf73Xb8wQUTtt2bnYS/BC6tNjUYX88DNQaQN/pPuecJLIl0IJHC9hzuKXZb9okz1WM2OD4e1FpnRXNds2Lqrc3YhXIY0I/nwtaGHKoGyvfi8CVKCR4rRiwq1zU2hwoaLSM+QHaEaTZ14kj9TUqdW7pNq3SBGJkl6vTz5SkuLclnet1rO0DRnBYNuj9+xemCEfhqlhxRaofH1aaVp1zQIqLGDpOJFEasopFpVRzFLld5bCf9PiSVHMrYc6j1P9tTcbjwsnAtJlFlVdjvWx96NMHXVY6OFEBYvdKcj3TA54bLAIf/xPxOgcZDd/QQLI1C3UkwgErEcb2ISIm7Qzd/WWTnlaXExj8fUEWFc2iLj4mtRTLvt5BGF6CvCFs6kun+N83GFy9QeBBQaA0AR4l9uCZWrIB9q2butYVgwEZQEgxd+lgmsDVcs/5WtkIguI5f+dOrsxqqu
 G+3Ip9M2
 px1eubnpEqvN4vNYXCBPo2OSdgiB5TckytPyXoTAHvQCJlo4ks0XEQEhWVoV69oRQEoaaaxuDSnvGT/xG0V3L4CMlKNWolIlD4ge4bZ60kfuwDT2XuebWXdCPra33bgex1inAOPVeUzZvzZ7LJp11rt30n2v66TNRqmJPPbXSZtQWBzcjDb7xyHuXr4ONfHO2RWER5Up0pN8gTCLlu1kStjuO3iqsADmjxW4unOF6z8lpn1EXMzzJZh1Hk+xEUUKeiKkJd3jY2kS1NIvD+h5IVOcwt8ndotBNrmW5+IfyVpMWSu4iZIJHh7DhA+nRYZyVuY+ptDHxrt9WSgLbS6VXT+mZitpITP87WI9w9fv+HZr6TiXlxxlpTwz6/HcpIRyIZGS0iabzNkbmCLACMNoqnNAXD13rUs5//QWq4cjetcKCXA+QjcodOIWGmwj2m4qCw5SvoaJGek7d3odzEIl5le/0TBNJr79LhKTu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 6, 2025 at 1:03=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> From: Kairui Song <kasong@tencent.com>
>
> This helper was used when swap cache was mixed with swap cache. Now they

mixed with page cache? ;)

With that nit fixed:

Acked-by: Nhat Pham <nphamcs@gmail.com>

