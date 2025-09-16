Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E34E1CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 15:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49D148E0003; Tue, 16 Sep 2025 11:34:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4747F8E0002; Tue, 16 Sep 2025 11:34:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38A5B8E0003; Tue, 16 Sep 2025 11:34:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2765E8E0002
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 11:34:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CB4EC1A01E6
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:34:12 +0000 (UTC)
X-FDA: 83895509544.01.A9BC3D5
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf20.hostedemail.com (Postfix) with ESMTP id D8C861C0019
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:34:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EDVkIMmL;
	spf=pass (imf20.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758036851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Z4miNrnhZPycrO3g5GYcNPXzP3TAxx99+7B000zkcI=;
	b=4fSBpfTTBMF/SN3xV8/FXz88YqR4MKnUrjF1JR28BNKvpJARk8LNjHLypqedecGt0ns0mP
	u24DJvFUMpo1sKMrUQ8c2lZauOx66JrnJUc46VEvIOmDpv6B0Hi921etUYVXTz0+ennGBb
	7kZZdEfSZvlJizaHpccQAiAHllW7IzU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EDVkIMmL;
	spf=pass (imf20.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758036851; a=rsa-sha256;
	cv=none;
	b=VY0gSqZkH/7jaYUMxRYl9B4IlHdaQgTgUrkOifjikRKQgdoKmOtGbwKnMiLqGgobZf58kG
	OHtVEDOJAenwIfIU49PViRscbFjkfWVMz5rHWfbgyARl5r9KbG0oIZ0sohXWh0KaNIqPYP
	P05VR6E1a+Nqt6Ij/RCN/4b2XHiHo84=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-570d0c280e4so5498156e87.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 08:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758036849; x=1758641649; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/Z4miNrnhZPycrO3g5GYcNPXzP3TAxx99+7B000zkcI=;
        b=EDVkIMmLS4ZevUcEBa2bFLMyA9/2FAa2fya8aIKNwCPMGHkGFkeZi9pghkC0nnkSCF
         8CFm3O6z3NXsz2/+CI0ttCRKcfLJVovqxzXztucV4gplVXOEPV9ql1lekE02FfbnAvlg
         TStUMlzMOvRminlvz9n+zoLxitojwalMon/vVBue7+9Aq30TIp+s1HnwKf9iNusVkyGW
         Y6tyglZV6Kj8CjtBY0ZRrxyLlom5u675Tb56+SGeMb1v3K8Hi3Cjjzj7k14/l0efGL6l
         iwd4wi1HHiu7ak8iZqGyQiQJcF4mnqIpP00cO5MY7ZyJKexdOWHA0BQsNE+QszPdQh8h
         na5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758036849; x=1758641649;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Z4miNrnhZPycrO3g5GYcNPXzP3TAxx99+7B000zkcI=;
        b=KTAEb9QZFQdu1axEP/EY51hgbKxcfsCAqnFSKlyvdAQhUQ2s6jja+XqkL6QaCQpze8
         kyf8kH7ped7KP0akb9RecqtqefzW5pnMHNaRM2sYTGh5BuLtF1v5kKfcAtxLyRJthB5t
         bj10GE3bblaVTPhHBnLJ+TUvNi/CGjwfy5NS8ACx9Rj95OD0Ha7QblrkDsxGDq1mzqOD
         D5EsHD82bNlYE5KxLkexcltmarDlgImBKuXstXQhJJCCOIwWg+f7pnLvpDTWXC8YTv9S
         9IBTKgBugYYZfm6gLdmjnr5vaJZj1/NHtCy/mueklZcBKflWZ0w3bUErGVB/X6r3n1P5
         7ccw==
X-Forwarded-Encrypted: i=1; AJvYcCUyWKU9Db8Ute2Gsb5KocWtQ5aZGGXoExTnJAuochBbtWOf6pyoGVhFsf4EW1bE2n74aUc27ED9Kg==@kvack.org
X-Gm-Message-State: AOJu0YyPpJUHfTB4eFxDPYvJSgRa0zuuefQzU4MD5aUCdJvr3qPVHFQ4
	0uaV330R3C8siYF/rAkM94Nr73AFvPgHPpyPwuc9dxvGsYJ0CrY05JG4NswTVBtN
X-Gm-Gg: ASbGncs4gB7TOmvkmsMKLD0fFY2bBNuDZKOJMqYjzAxJAhsj+LfPO7mSggb58Nt1yvK
	ljuTR+mZV9OeuIZnUUe3J2VusITIC4fyTn3LhPNbl2eaC8HJqZxIIg9PkjCPn2K8KszMNMT++dw
	0WSx54OPY2GIZga/ocXBniuOEgm+yLmM8epATfOD3O0ieO39kBdw3vTOaIs1kfmTvzVIwj1bnXb
	NsfIg7CfUhqnraXMly9Bq1coxadj6GP+Bw/PstzA24URu9UaHoAx0imB30c7/kmZqSuQypurv+R
	nwSPpPCXBH+6A9DIZ7+DMQjZlsBiNE+AvF3XxJWZQMiDArLDDwn/Hcfkw9ywWinEGw==
X-Google-Smtp-Source: AGHT+IGTaHnDatRG5zbicey/YhcGq7IWpIBYMJaruSO2Gk0m50zZsKryEJcShBMjgdMFvEhIKPMQdA==
X-Received: by 2002:a05:6512:681b:b0:570:b85:fb8 with SMTP id 2adb3069b0e04-5704f1cdc3bmr4166584e87.27.1758036848582;
        Tue, 16 Sep 2025 08:34:08 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-571d16e79d0sm3199279e87.86.2025.09.16.08.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 08:34:07 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 16 Sep 2025 17:34:06 +0200
To: Michal Hocko <mhocko@suse.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 10/10] mm/vmalloc: Update __vmalloc_node_range()
 documentation
Message-ID: <aMmDbgozQxcNyNMC@milan>
References: <20250915134041.151462-1-urezki@gmail.com>
 <20250915134041.151462-11-urezki@gmail.com>
 <aMhJHUfr_PupSZSW@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMhJHUfr_PupSZSW@tiehlicka>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D8C861C0019
X-Stat-Signature: pra5q9bu61f344u51dgntie5g5mcgr6y
X-HE-Tag: 1758036850-715531
X-HE-Meta: U2FsdGVkX19C3dRkmsEK9jRsgNcb2DTGQrSuLgGQXkJs+PhlQTSWOd1opGKLIZj7QzzgM8Wu2h/l8Jk3+gdjCsfDxNtcE9pTb8yVfaqDUqmIsKzpXRkmta2uRzoJLjnWBmsqr4BADzIdTpK9KYit6MsonGnVNOeg3DEYj9VC9x8eYiuaz7GuckmG81ie+aBfP4ozazjAnhl4WrEw6O6roYBja/kVx1WGiWZ/jQ74LER7ZgELL9XsSpRi9qXTDlhZihRHONP3QfJDcdmjKXxwsfHU+enpcOoY6cafavnCpSTqOvdgTXzWWE1O6wN+iHa30r8Lgm9cjhGuGkjDEmW17TuTxmTBVBzEQvcejpQ8vBbT7deNrG0qRULhAaVgBUq0mJLBmo/Vy73WAr1G//PmxLC/+samIiItMcRCaKgXsKvrwUMI1IhJ1FkThP/+LCtdBI+9lpIln9hRbmiFXXJwuv/eu844Gkg3AHqNakh8sbLWtzCRvkFw0X1U9pmV4+B2ZVVbHZ0UIAlJHjZOKq1CBOwIrFg43sgCBHJjJLLfhLZPLT8nOkjtkYjPGtNK+5RgEKQTN155eXsHsF1cRhYIozeqSftNM1+ikGUUtTak9sEz4gspaeAh6x8FQPjgQl57qtQ/Nh7ttpILxpLXfvgcBKCmox2kC3kJHieRiD7ONgI13ty4Jy78gfduxEl6YuceElE3N6xMcbxhO4RqxIHkbRKNpnEn/LbPKVa6CFUi/FFKuVY5zKM2iNliynReAiQ71jlNGv52EkWMNypOTPBiEw+9WNG2KfdbXlde2smo26p9kpHQ3WzsNJgDAQUqNcxk6aVHuM2MJU5V5nCbf2e4mpB46B+ldJ8o831k0EkDj5a4Z28NDitFFJ74rNJzjAQ9tbhxld4WZD/7n6N1vPZDY+W/QyVTnxhD73baxktoe66prgP/g05yJ3Ibk+naeciOfAkwePOM9+gmjZ1ZOxz
 KEly7XXZ
 1y1vY0vwfkobzwdennQ4idoFQ8RnVgNrPu4iPJSEPyH1T/1qXgazawyy77YL9c1CEQx/F/+l5ltx7W1SbwJiFCWVKaV6lmYYqqZeSbOl69ig1d9d/7u/vj83y9hR1GMYtCRdlu1wdXDjIXHC8BnB8tAhS2xXSlfixhpxmMnncVWRPhj3c9JLWMAnpAqseAZDe/Hqxrr8w7YEIDfmGhJZ/aYbRqcEUN7auPlejm3AQ9dlcha+ogMezsqUKPOYO8bKYpO9nmd/m3Rr6LpE51nnIDhwojaO82PW80x7bveqcEbristEe4thJDa0Q3hKl19ICwmo4vmw4LxJ3Jkqry4wdM4LCAWrU8TM0hKV37xGI15hIUWN7XaeSk0RPffzFw4/+nYH8PsA2agfDSGBSOB3oykPvjZ+qq6EF5Pc0aVXOiAwBCD/2DA/vND19I1xM/XAWy0CQmMNuGCobT4KEw5/vkKq+B0t5ztFO77zikvbRwakQ1MPraF0Q2fSUGxTG9nLkZ/l/Ejm/QXH1JqOs/a4HJx6ojuyFAyfBf3zFNhyWjs6+YSEn8vO8BLOQlIYZ6HlL+b2R
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 07:13:01PM +0200, Michal Hocko wrote:
> On Mon 15-09-25 15:40:40, Uladzislau Rezki wrote:
> > __vmalloc() function now supports non-blocking flags such as
> > GFP_ATOMIC and GFP_NOWAIT. Update the documentation accordingly.
> > 
> > Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> 
> I would just fold this into the patch which adds the support. We also
> need kvmalloc doc update.
> Anyway
> Acked-by: Michal Hocko <mhocko@suse.com>
> 
Thank you. Applied.

--
Uladzislau Rezki

