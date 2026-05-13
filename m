Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86506CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 09:11:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D44036B0005; Wed, 13 May 2026 05:11:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCE1F6B008A; Wed, 13 May 2026 05:11:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B95BF6B008C; Wed, 13 May 2026 05:11:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A4C836B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:11:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 482F01A07F8
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:11:52 +0000 (UTC)
X-FDA: 84761829264.05.DE9B565
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf05.hostedemail.com (Postfix) with ESMTP id 44B2210000B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:11:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="dbSgT/lh";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of jackmanb@google.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=jackmanb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778663510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iL1VE3JAw0z9ArYGQdRAyJCMAXYUM0ge6pat/8Z8ryQ=;
	b=yIaFjHZBvfUToyRqcxjpruD769JnRkoEfb6oMD0aN14CclJy2Zr2Rw0X231k+ne8ZWYyE1
	q3neAunrLI2YvFRSOfniJH71Kw2ighswhwB913Hf5CnQ7VI5aWs/3iaUa/lWbW8UCmb7Fj
	LssCTAj6kFc1mrWgqwQ9KNirBIdE3Fw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778663510; a=rsa-sha256;
	cv=pass;
	b=RpgsqsoBt5i/BObmAJc1LDQ3AfsfDkw+V4MVGivbiJB6bXpGCN662KQjjbQjtT2FBzarOn
	lYUXm6M0N8IjNfOL1OHmZQxsvC914bIp7ETpu8S8UyPiIDx5MA7TS2s4UJ3MHf4Ppwee4S
	u1Q1ArJ5HfU/5+5YaorKpyW4dp5RmXY=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="dbSgT/lh";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of jackmanb@google.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=jackmanb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5a86d384ca6so160e87.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 02:11:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778663508; cv=none;
        d=google.com; s=arc-20240605;
        b=kWLwTvA2lzPkIiOOekpbIbbID/un0TAVuG7O4w+DATUBLzxp1IBHtdWn0C36oIGP5P
         2DxjbeaHYNUHyxPp9alJ0wvQxyT9zWfszi4VcW1AlV8pO8eRRDNQfQkzR/RMrm0P8v35
         JxAVRZgEkVi4YiWp1lvYXHcait17MBZiOrGiKL7tPSuPWGqIwwQ0bNBc3rKIdt4EfWrL
         g3wjJkJ1tdf5ltsk0+5L6gozqeAZpH0pB7GNtopALDFXdD0A0gz1zrHsyhWrMRgA4GyH
         94HwH2dTXCOXXP88Xk+nKDXN9FXeMs6VegmpHUTkP3RcktsqGkwhMquwkXh/2SVVT/du
         4sEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=iL1VE3JAw0z9ArYGQdRAyJCMAXYUM0ge6pat/8Z8ryQ=;
        fh=bKRdXi0WIU2yYflCMmTxzujuULk1SqJMhjMUoJ5cOiI=;
        b=ZQgjMfhsiJ/qSGTEH2BVxKIKg7AUIlYskUF709ZM0RydZeXW/i0yCemeWIFnb1hzCY
         YWG/n7gVO2EjCXCw7WIfEx5GMN38pdCBJkd1Ee6hr8Oetu45pCmgwqk29kDj8tvHtPLG
         ijWsF5EsTplKo8eJuCCODduwpxGxcVD1E5FeaWBIY0KT4bjSjM2Lmjkt3zp4yS/vcD71
         ZszrBzXIaZ2NVvl3gJ32Ci45eZ5Q6zENPCnmYTv9Ravh+JiUjBVTMIrbAuZkBO1XZOJe
         TjKxwhkJMWCHD4fL6F4+xvNMkuQqnLfrhPjoga5oV+RWgMrvnTlGJzu7ZsfxhAJTLcDG
         euWA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778663508; x=1779268308; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iL1VE3JAw0z9ArYGQdRAyJCMAXYUM0ge6pat/8Z8ryQ=;
        b=dbSgT/lhJrEyk/v9aSxsUGvuKB5ip7aTAmr08zyQZ8hyi6xK8Dlc6/JmG8R0escOiq
         ur85+3YrSyiVJaz5TE/jCIpsO4NVcMYbZxojAMc/u9AkIEG3oa3fgD8i2s9AUzMUd5us
         509bI0LmeRkDbPs0bI+35PS+FSM3fS7fzy7dBqGJMBVokte0tcrYTJQjRcNyXXK4bAnE
         LGu737mN68UQsXv/Y6pTZFdy/dvQTHhfvTY+jzNvGo0giN/lPK1NL+wLLC6mUlZCp9xa
         1Gdrn7m8JQz1VTEUVwQ5y5TO3xLMQXwp2qhKvO/1xegWgHYcEZwyCZabeou1/KPwPAGl
         wCEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778663508; x=1779268308;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iL1VE3JAw0z9ArYGQdRAyJCMAXYUM0ge6pat/8Z8ryQ=;
        b=DC1esQGXCt2ucP5r+0SXGeBosF6k9+H07M0K9nrwqWQm0IBgWFGCIr/oGqLEAGsO1Y
         aSi3KNmMSykEL5rRfrjGwSLoxuFAe1cOEzTuPaMZqPoHW0rblIBwd6hJ/wRXa/rs68aC
         tLZM2TMiKONhps6A3/7yRBTu9vWLFBt14Rc8uvcGwsYWnDNawwslKbO0YdZrlrKm2x0c
         zNEO5d1GYXoaeU9+YYCzTr8JfGvGUj+uPRi4iyo1z7SQR4yjNhBAHobd0LNFdEHcfy7G
         x+OQTOsEbHCXJpzkDcDHjsS+/A4exjcgNY7b9Q72QQUQa/i/UkzGxjA/k4/6pSB6mwzT
         LN5A==
X-Forwarded-Encrypted: i=1; AFNElJ/zMBaCkIBIHpxbo3Re8rBZ9ppe3BC2gM+nhGLcdzHzv134yEg3da5xW6bTNQd5ac+gAKIHa3blZg==@kvack.org
X-Gm-Message-State: AOJu0YxQXZHZ6ii4d0mJxRhdRpvQWS+tZK0rOfYKVZ/0JDHgIvTaLFD9
	ra3jW5gxAUC39MM3UZI0p/bqlc5gTUj25gYPxYZaOCzwb2ThKzyQRcT/POEpH2mLJJ+PPLR8KeO
	sGwQRFwQ2YlSO2Yj7ZPwdDNG/gfli4/N+VHBzRq3+
X-Gm-Gg: Acq92OHWIJs9iftbLBfd6aT/U/Ex5uIyaXgo1e9Uz9RqMVuaFHb8CkksJepvpqU9kIt
	XK+A4AzMOUN1vscBqJFK55bV3Diw9pCu0GDe4F5voK8I6ARbfrAKfk1Ms5IaqM/V1eixApI3JH+
	HDNJMHcHXiCDywUZJ+BSTwoFsY5DRq+77cR+zZki0bBKMft3YdWuYcbr/ifX5Pc/ZQikQfA8O69
	VpAQb0gAckdULZ55KTva+AcvJ9cPlZ+WND81NSAlDwKGviPYj+YFLF/thJCueDVNGV28nJ5CTyc
	+GzkG/Au9G4BcZv/NI5Gn/vgvUNslghqdQf4LgUPEHpsSbTA
X-Received: by 2002:a05:6512:1146:b0:5a4:462:a470 with SMTP id
 2adb3069b0e04-5a8f1a27ed7mr127165e87.7.1778663507927; Wed, 13 May 2026
 02:11:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260326-gfp64-v2-0-d916021cecdf@google.com> <DIGPS83BGEGA.5I7VLH8TV7XE@google.com>
 <20260512140532.f16379be75ab006f2cca4747@linux-foundation.org>
In-Reply-To: <20260512140532.f16379be75ab006f2cca4747@linux-foundation.org>
From: Brendan Jackman <jackmanb@google.com>
Date: Wed, 13 May 2026 11:11:34 +0200
X-Gm-Features: AVHnY4JkYKmjfMjoxQK2Kv5dUgGHN1tiwBYPl837ha0neUHazremeoJt4lAaHiI
Message-ID: <CA+i-1C0pUX33A6zPFzk-2UtiQgAZG3hss3-aNcf1RYauUuQUWA@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] treewide: fixup gfp_t printks
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Stanislaw Gruszka <stf_xl@wp.pl>, Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Allison Henderson <allison.henderson@oracle.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, 
	linux-wireless@vger.kernel.org, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
	rds-devel@oss.oracle.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 44B2210000B
X-Stat-Signature: ktjwy1emtwropz6ogzg16th9ra1ygxy4
X-Rspam-User: 
X-HE-Tag: 1778663510-235081
X-HE-Meta: U2FsdGVkX19DxdqmDnHw4SjXZKWw8euBbD7bvJMeR/cIi3u3vs7p5Lr4wuzwxQzCLOPF9ulsbMhnLkvp6vqkyotTADfvdeI9Myn1ZqEQpW8mPpwVc0NGbzHRzoPlOP8moQvx2XS28nxLotWD64nROzGZuszFLn5/hnWispPZIRH8+ZeDxcW60Vne6PnC/V3QCO+8LN9tehI5P7Bd25M1yz4uJuqMAFDtJjmhLtPZAdO+8Rr8A0SEjPAPmFBHNVibReu542Y0T51b+qPiNMH167C5WPfHPtIL3Oo9k6tdY87j4yo+y2/IjB9oyUW4jPI7acmkby/nhNhknQzpLXd7ZaJzFjUlAmZ8h2EPDS/+AbqWhtpBL6J14goQx+oGpIPG6swzRJUB/9COcHuPO2am+wLIrc2SBhqB4xe0cmkeQ/mZiInZdDE6b9lts8g12cjzXcSCTalq95BO6fz+RtnItw/gJeDdllhF+UqqJpVqE9KjwLUStBRCNLtriyh5yQZpScarAUyCFX9e/l0x6HNmLqK5LHsv9o5O8pWzFXcnYU75UKUUDcKnDiRYyC26aRHBXX9n1WNR25C8gcyhdhHaO8/1YeuaEwF7RWb4dNTg30uMTJP6szfv3xIw7VAo8tI9M2SiGtYWcSskDAUseRzA3ueove+69S+XIT6zfWD8lIhy4oBAbEWyVKoKbb5Qzhkd/FXQmpCukD2VWpREu7VuJwa3VrY2ZSm6XLlYyttuLMHIQP4EGHO1BHztWFtDtjc+7z6Le7xCgxmg5BAYe4v6OGqnCSyuxj8MCLyGhXQ16SUFWcbDvbAMI9cIpR6d/y61aJaUSJtCwqA0GUdU1qgSX0YgDJcV2Cnzh6gCdP9/8MAKhXOxYd/5w5/HhLLB2arUQDGjleRWkcjYK66qxn0f1iHkITzczCB5y2bTceheFF3DiVW3Z/FZpUrCB9wvQlPShLWiq8AOaSZFsiZkuK1
 Q+ernJm9
 8/R/piXJqW39wyNSZIPr+dbpaLjDlLO952c5U/92JXFqZWVRwqc4alTO+xp6FLH4BWrrULVEFJssDf75Aldxmsxk3b5jyzHYKbVDsVB3TadLfXW/wcyzAGLcCxsONVsQX/I81L4+QTt8VL4+Zascn7wr5N9DbVnlwUEPF6uuR1D6OOQC09kxYFEXh/z5BNfWH8sGowf1ZKwE+l0xBbU9kQWKmcftNA88/Na+I0lI+c6IVn9HBYu5wqt4Gg0e3L3RPFcb/rxyIbUZHW9/+4PIWTk4x5gWl7w24ILDb2k8G46CQp3FH/2sEUqH4LVISUi79g4qk9AGclqTUo6TiSWs4DGU0P1yK/o2Z4xHAqSTOQ8HQpWwGHBcsfoncYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 12 May 2026 at 23:05, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Tue, 12 May 2026 12:58:20 +0000 Brendan Jackman <jackmanb@google.com> wrote:
>
> > On Thu Mar 26, 2026 at 12:31 PM UTC, Brendan Jackman wrote:
> > > This patchset used to be about switching gfp_t to unsigned long. That is
> > > probably not gonna happen any more but while writing it I found these
> > > cleanups that seem worthwhile regardless.
> > >
> >
> > ...
> >
> > Any chance someone can take these?
>
> [2/4] is merged into the wireless tree (I assume) and the other three
> are in mm.git's mm-unstable branch.

Oh sorry, I just checked and I did actually receive the notification
when you queued it, I guess I just didn't parse it mentally.

