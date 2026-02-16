Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B839E63F33
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 07:54:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54CE46B0005; Mon, 16 Feb 2026 02:54:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 524356B0088; Mon, 16 Feb 2026 02:54:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45B336B0089; Mon, 16 Feb 2026 02:54:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 30DA56B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 02:54:15 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C50031CE3C
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 07:54:04 +0000 (UTC)
X-FDA: 84449556408.29.37E345A
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf28.hostedemail.com (Postfix) with ESMTP id E87A7C0007
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 07:54:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aSKhHbnt;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771228443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I14tbVEH2syUi6Y61oy9PC2wsHETyhymJpQijnsyHLU=;
	b=yloLh+6y2DK9UsCzNhZTkzDYWfFZ4y7d+756Ci16DwTG2qELjNYBVMOosbR5o1sQfDxjhJ
	Ip3Ptq1blA7tu71C4HXcr1lQFgqP04gIKyJqdtmiih2vSKuIzEAyF0Upz7fG+e52h1Deux
	DUJvhVwPoGkoX9Oq93fheF1rThRjH94=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aSKhHbnt;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771228443; a=rsa-sha256;
	cv=none;
	b=ZtIHj4O8b6XmpRz8d6urT465JySQ2bD1wIsamR2zNvAh7M/o/3+2LTboHAEPjdXtlpriZc
	TxcIWncIAn1T6lPUj5u/5Ju2Rj/Q0fGB2SlowwiTgvgY8LYsO+SIIYdPfxZ06qbfcjF8kD
	Y1LBVJb0Go0eN3OZg4JOZxUJ3mPeBa4=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2ad22a5e245so7354765ad.2
        for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:54:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771228442; x=1771833242; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=I14tbVEH2syUi6Y61oy9PC2wsHETyhymJpQijnsyHLU=;
        b=aSKhHbnt1ZYfTsEWGJPXnkfNyzxjRdtIMSRO8zG4pA1kO4GTLZ+B0JqPJoIsqrrx/H
         NCYWLgPzxtyqyIUl47mxGGwQNCmJtVM2In3tT1T2HSRp5PVYKQbeq4WuyJAV3LJ7k8nF
         uHROihKVZnAg6FJNUxur2aE9IHo7IDUIxqCB877l7XNJc6M2qPsicKH9pvvYVPbQLBDW
         hntbSYWYHyosSErLuFVqLXXTrPI3vLwcp8bzwNwAxLFs3R0UCaOGBmzlrKDeFyEnc37v
         4UBOKir0G4JuAFZDjeKXSyMYu2U7O8P9jxOpCfDUTwZ8eqCHZHVIdcvycRPLjsmlho7f
         88vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771228442; x=1771833242;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I14tbVEH2syUi6Y61oy9PC2wsHETyhymJpQijnsyHLU=;
        b=YTffkmsfXl95ZsFCkl/KzDPWsEDs0reR6iY3FVCzB9g49w7Dcwp5Jk5bTLwKkOkZin
         +yN3IPaCUm5UuLbhKz4hAxDjtH9xnqKfaIUmzZULPlPOQHEEUg5ZknmzG6m8FHICHJke
         xXbMNUGFSZwS6/MlpI6gyvZoo9k9SfJEyTaPCQVADYkZh1tJ2lB21BPCMoLtjFJYtXKx
         i2gWq4QHSCP1z61KM3pOmHNVSUvkk35TT71/BFpr4N2hE/GAx3PyRHOTYHnYGR5FMy0T
         h3y3wBXiPx7yuWoTCqg6aq1MChH9V0zdeCYYv1xbKqTpajPWekDL1cmwiOv5oQTXfY/j
         mcIA==
X-Forwarded-Encrypted: i=1; AJvYcCWZdw8RSqJb6C31+9PQtSw6rYiyuLVitl+S7noQs2ZJ/hUCa48S44p/zlWTAUX7tPga0Ig+MWRkCQ==@kvack.org
X-Gm-Message-State: AOJu0YzvSFvS+Y0VbmsBLvQqAr/q1hOoL+0+cOCpWx3FEdkX3YslDnas
	ctj9DEOLcwrF6HpRWdKszJTb/2r/zq0/7iNvborwRJLS8Y8CVg4mi1RD
X-Gm-Gg: AZuq6aJLnccCBo5IKiVSwPuDXoXDRi72dyviXTDeksRDAJviQ+ju0ER7Bqutexat2PS
	UJeylNANW5uSXJTjTYv95tSfllM1g/V+KkQcPM8ZOCMQm/lhWi5CCrGws3chXpMdmbF/JKJZn3o
	n9nPE7GkKsizpUA2XExke9wbZq8XJ94qDM3V23B0udIHgNwwznmDhSO+8GNXRVinBuCWn1REFEh
	ABAx4MBSPtrRCOOOuRK+C9yjkuWo3KeiqLNjujK6TkaWIifqjOrfkZkLiYFUr5pFtF8LCpqvc/B
	aOI/R3UZoSD0/41w1wPU6qYXm3O7S52Nowv219Mt7MpwLC/A0XNNAiGUGx1lfg4J1PI64K0cNLw
	CdTqWtLP4+DgHTZFcb3M/NJZZmQk9CFilHUBo92eg3cBgyHSYY88NdD89LxV7ENPUcJFmHx6YPp
	IrIZ1Gtr+6p1pE7DSL1bGb9o4hMPL7uWhMYwvcttsgI9zhrO/Ia4txFx6JDclU0MxjPdFRUw==
X-Received: by 2002:a17:902:f788:b0:2a5:8c1c:744f with SMTP id d9443c01a7336-2ab505a3194mr114280125ad.40.1771228441729;
        Sun, 15 Feb 2026 23:54:01 -0800 (PST)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1aafb972sm58148685ad.88.2026.02.15.23.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Feb 2026 23:54:01 -0800 (PST)
Date: Mon, 16 Feb 2026 15:53:56 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Barry Song <21cnbao@gmail.com>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Carsten Grohmann <mail@carstengrohmann.de>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	linux-kernel@vger.kernel.org, "open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>, 
	Carsten Grohmann <carstengrohmann@gmx.de>
Subject: Re: [PATCH v3 3/3] mm, swap: merge common convention and simplify
 allocation helper
Message-ID: <aZLLaEXeVVB9277S@KASONG-MC4>
References: <20260216-hibernate-perf-v3-0-74e025091145@tencent.com>
 <20260216-hibernate-perf-v3-3-74e025091145@tencent.com>
 <CAGsJ_4xpoC78KhYj_b18aVzjGcFGfXnpt7uLGvg7w1B4Y5cc2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4xpoC78KhYj_b18aVzjGcFGfXnpt7uLGvg7w1B4Y5cc2g@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: E87A7C0007
X-Rspamd-Server: rspam07
X-Stat-Signature: mhh5opqx5kq8ft7b9parbc6i3dh3ty7k
X-HE-Tag: 1771228442-560009
X-HE-Meta: U2FsdGVkX18XMKEIgrIQbHax+kK8YDNCsXTc+qZ8fQtxqhwvDK4WfutDtRKH8ddZjordKDAk45TwaI0xO+zJBo3MmvHHq3tMHvucMVoF3jqd6zrjxxW61XV3MvltKU2GYnIe3xQzBgU6G14SKHPdObw63ccyz4QGgltJBFjU1xCIyqeBpPmftL5Eg6nMvDNAghSRi/hBFYdBbYCu5eUrZfBzeKUTKKX3BY2VnCdM0nuVwlIRM8Hk6P+fyhT/U/NYiBYpGOWcVAHaH1EvVpDUqTNUW8sVbFh0ieYaPCtICQpy7UmSzt2ncgH9I7pQ+xQfkn2332xLe+R70rKDRMLJvUKC8oAZE2/yaJ7Jkmy4TSISQHA4nE3JS9oRWCsp+FAO7cJ+FqOYYq3c9uVwSHaZsiyISQBTmrd0OjiHOI7wt+K5oPwV2DQy3d4s6et1ZO6xJ/NvFHWm8xBlxFmLNUUmiOk7KdxkRO9Vw4CgCSPsMmdTdQCh0aZrZkPNin3lyWF3I4WEh0kKlXrEF8EDu4BEFYD+MTqbwY/LG1UoKiDm8NediZi14ulKDHtawwubTsHUeRf2mZqeqAgtXUaW72LAoLRHb/YzxP27U6DDyWXLX8tB24miO7iJAZf0vnOKwu/QgvR3Rak7hLDJher6ERwVy/IDzNglDyxhpNT0HB+HqwFkF7S7YGUaWZdhdS9T5RgJeL9n5yxKmogzkj5yYM5GbINChyq/CPTgl+chxcOYi4UIcU8FPykbmwh0ns5joayX7Jt/n8pwPe6PN1NYl5uyTJZD0aoeuwecsRiu9Ci/BiTjOC2YcDDTHWK14MeBQQtVJwHhBNIcJH5R3lZ/AjyLMP6VhTVCUlg36wtYyNIwrS8P0GMS0OKJiQ9JQYluy1Vi95T1hROQ3TD1HC0jclIQCYGqpR+I9VrEH//aHFJZJqesMlKR2XNvwfF/oftde9RLfvRN0y9otVfnb2P9rKv
 WxgymAsE
 jiBo4FDlnmBchi7XixcsxCcGFN/GNQYFjkb47FjkrEQUxpIFGK3gEr8Kb5ANWLMWURrtOyd1NkvfraQFbcnVwYeLyX2Mm2dHCBKnAOb8lGQfcK752jyH3udW/srRN0spARYu+lY0tM/K21FBCZ47cFXQ70Q8M3B/ShOdKzk58sbhKU43IFzyRJGD1VxUDubQuJPGM02mN6Muw7W0BTrNdoXkm4+Lx5KQGG/LiFQBFVNLjvOnIfSbXyxJ7sS8nKAIUOHTGkDIq8c9U2GV4K+XdK6bhWjIFyP9gOVXCdWSyzKNms8Fd2dYfwygdW50n1KfJaOI826NJEaFtE4VAdGnUg7TVYjikFIJwY48ioucmKHaBCY1VjoxkdFhsXS1lZQiRHQyU5eJTVjrfCySuwQGHYa3A7ajMZ5P/j9dDlS6l65M57RHNNPSroYX4V7mmAbclDpPf+/S0VFemTR9p+J5W5jPrve0DsCcjgN2507Njp03bkEbDvmYJjNqCJy7r7K07pmil
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 03:34:54PM +0800, Barry Song wrote:
> On Mon, Feb 16, 2026 at 3:00 AM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Almost all callers of the cluster scan helper require the: lock -> check
> > usefulness/emptiness check -> allocate -> unlock routine. So merge them
> > into the same helper to simplify the code.
> 
> Previously, when !cluster_is_usable(ci, order), we only called
> swap_cluster_unlock(). Now we do more work in this path:
> 
> 
> out:
>         relocate_cluster(si, ci);
>         swap_cluster_unlock(ci);
>         if (si->flags & SWP_SOLIDSTATE) {
>                 this_cpu_write(percpu_swap_cluster.offset[order], next);
>                 this_cpu_write(percpu_swap_cluster.si[order], si);
>         } else {
>                 si->global_cluster->next[order] = next;
>         }
>         return found;
> 
> I assume this is what you want to do as well, but can we add
> some explanation here?

Yes, that's fine. alloc_swap_scan_cluster is suppose to update the
percpu offset cache so if the cluster is not usable, writing
SWAP_ENTRY_INVALID to invalidate the cache might even be helpful
for future scan. At lease not harmful, I'll add some explanation,
comments.

> 
> Also, it would be better to add a comment that
> alloc_swap_scan_cluster() expects ci->lock to be held on
> entry and releases ci->lock before returning.

Thanks for the suggestion, I even thought about renaming the helper
to indicate it will try update the percpu offset and release the lock.
But didn't have a better idea to naming and we also have
alloc_swap_scan_list, leave the name untouched seems more consistent.

I'll just add some comment then.

