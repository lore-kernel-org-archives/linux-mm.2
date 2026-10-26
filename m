Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60B65606A324
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 15:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=sKnT8G9J
Received: by kanga.kvack.org (Postfix)
	id 752016B05B9; Mon, 26 Oct 2026 11:53:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 729166B05BD; Mon, 26 Oct 2026 11:53:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 618976B05BE; Mon, 26 Oct 2026 11:53:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 460066B05B9
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:53:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D088514056B
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:53:44 +0000 (UTC)
X-FDA: 85365222768.21.638AE5F
Received: from mail-pj2-f11.google.com (mail-pj2-f11.google.com [74.125.227.139])
	by imf21.hostedemail.com (Postfix) with ESMTP id 07FBE1C0004
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:53:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sKnT8G9J;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793030023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R9AlT6hvjH3cYXCRXYi2r0iIos0zgRK9lv/Md13+/KU=;
	b=Xtx8qYdz8Jf6YkQE14mNbrgr1EyspsaQ5Xf/sOhPUX2sGKZf5o2A10EgidRUcqjPRmWQqG
	z/EEBos21AztkBv6iT6w1XK5E+AUemSOP5+c29tsIhiV0qZ8rdbc9M4VaLpk8bpof8DsA5
	cnEI6UdRbYDC7xRPL5bwK2ltSJ9CjsA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sKnT8G9J;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793030023;
	b=GvOSm5cDKBrP34canN7JPUz9zSXBeha3bAi4UvVwrK7pptMzKFOsBFwIn+JG+B8KS6ndSY
	x0D96Q42qY9PZmZ0Xp8pNs3vAeJ3svCzbW2wuB5M3Lkas1K5pjzgr2LwUlSTRUtXX8/FSx
	q0fOfycSvN3YRd/R81qI+F7NZbzjfRc=
Received: by mail-pj2-f11.google.com with SMTP id d9443c01a7336-2ea993271f2so10684205ad.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793030022; x=1793634822; darn=kvack.org;
        h=message-id:date:mime-version:content-transfer-encoding:content-type
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R9AlT6hvjH3cYXCRXYi2r0iIos0zgRK9lv/Md13+/KU=;
        b=sKnT8G9JVhA84s0KlXnb2Cjid5BOKHDht8riUoX85O7sRS3HwDuoyOTIt/cD7H7Rnz
         LQXYBVh8wo0dixp7/H8OLybhpGjyNchTO3re/pyPm/MAPEuL+FrEh5dHSIY6DhPazyqE
         4Qy7NDT15xn7YQyINkS57DgCU2iSQjOkjDveTYfCMCOTiJuRywYXeVPDW1NyGBHjuslK
         jXFpOC716TuvahQCvFdJPUYY88Gj25I/vqBqGEbg1YmTh0iFe9KVs66VSwDCynzYit1k
         GZ02hsE5acLcAaKUX42+YN/I8ITUO3cLHhYs+MxMoZfZRu2Lyip37BNHRJ9++mk8CemY
         JsIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793030022; x=1793634822;
        h=message-id:date:mime-version:content-transfer-encoding:content-type
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R9AlT6hvjH3cYXCRXYi2r0iIos0zgRK9lv/Md13+/KU=;
        b=znayevc3Y+eZT/RWGIMMnRirFolUZbDbUA1aWQ+JPx9s2v+sBrc/vsmXKgO68MnplD
         uuvD0pdO6b+Gs9eO+bZAN6FgLbq3YNPzHDwoeOztZO2ndpJ1orlGjgH4b8jqHdRx5lwb
         HqaznJ4NL0fey/QHGoMi3CY5x1C/Yi0WH0qPKjpB8Bajuhxpxw0R13YhQJyGN+GH8jFz
         y/7KQMvZCKe5GaBwsqLUVCciUWd1+7n5euicwBgKTcwQAAHe1iHYGRKkEUzSX4BQxj1W
         1jF56MnXms7Um13vjsrJId8YlFf4FtOhDgN705EpO1pDoqY6YesZqu6u9B+Rdrg6KLRf
         u3Qg==
X-Forwarded-Encrypted: i=1; AKwUvBzGz7K8Khj5LxVgzaCKV/Ft/Y2Xgvc4cQV74XfpnYZc9XhWHpZRt7zUJXo3OIjG7KweTFfjQeZ9Sw==@kvack.org
X-Gm-Message-State: AFq9FYIxLLGv0Fj0lmkzfckDvDJoMbx13ECeL2Ne3MvsxEQpc24tX/Zi
	mpKdNuAvHDYuHJ32xJmT5/6brP91lHSQwJww66F4M+ugdjeCbJBcn8fH
X-Gm-Gg: AYBFou1KlbhbDzpRZNqnfR6mFMvwUTItlJr7993TqnLpIg4t9KKSUvu0Hz0DZ2UTV2l
	ZrxJeRqf4zFBsWmlwttWmSGberQ4RjrM8kIc07/GNMCioIeLT2ohvOvTgzngJStqBZSnphzDcLm
	xgi/kr43fKn6zdzEQQYDFEZ49/cm9hIaBa49XFhcB1HkV2WG54aLPwtoiQ8YMpW05491HrQxzXH
	2phMwmvgd1grH+ZRA+ZQuTnksQiZNWT53vW8mKfblIpIwSCL3PhCo+P46tdfjNYwCtCP00KtJpw
	NDEYU+PZ/1NLgIAHzYNva0wvVnMVGE2H7QERh/lDtl9kuMY1I7P3xJlCjCRn0d+3IfWFq/fo5/e
	Q+LYH+kGVPtPt2zUxgnbA6mX1adYV97FuSBjz0ZCzsEG0LgHS7MbkTU5NRh74kd7E48Ts0f93Ra
	Xq8WHRP3gb/xRAb/3njVSDes4GcqnrmXnmPP46UGpYEw4TLh9FbAD+uaJb9rkfQplcsJPqM6QLy
	kxGEAybTbvLcAYKpZ37A3o9i1eVssGKSAkib7dUhw1o7ewhDv3nVTcYE/olC/SjJgcHNTZv/8hP
	N+gDLG+4aWCgo15CyDd0dK+j28rX4kuDpBRIqS6PD3iSufEPjEenr/pptPlMupKAta6pOk+V6A=
	=
X-Received: by 2002:a17:902:ecc9:b0:2e6:c39:b25b with SMTP id d9443c01a7336-2ea9c6c835cmr57333975ad.14.1793030021722;
        Mon, 26 Oct 2026 08:53:41 -0700 (PDT)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea9b120095sm19328195ad.16.2026.10.26.08.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 08:53:41 -0700 (PDT)
From: Aveline Noir <jm5905938@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
 damon@lists.linux.dev, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] Docs/admin-guide/mm/damon/stat: fix pronoun agreement
In-Reply-To: <20261026143109.150059-1-sj@kernel.org>
References: <203ef50d11ae600ab06546d73a2290f291381551.camel@mailbox.org>
 <20261026143109.150059-1-sj@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Tue, 27 Oct 2026 02:50:54 +1100
Message-ID: <179302985414.2.4645643321689632441.damon-docs-reply-02-stat@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 07FBE1C0004
X-Stat-Signature: 4q1nk6frs6spj6r4pgnh3pxcmp91rgfm
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793030022-135176
X-HE-Meta: U2FsdGVkX1+EnYrOA94e7XH+/TiZMrZvEQ7JC69xsPYfo9XUrvNrahmhW8I6OvxDrrHoU2mmGkb1gyeXn57flmxaceqH5cAQxpRBPPIi4oUtnMOvutwNiqdxQHwKtzH+0ugDbqQ/spwTHVlIIoVxiqZsBPATOIKbHnXIYjgf+YhkWN0QNeK+TTEm1Ovu9jcLf/lCh2qObiLcu41ZngnCb+YbQTOklr6+eYtt0OF4QIpJii23N/uG0hiye8S8m3VjjZRHyMY/NHu5WbdY2x8EA8o8fxyssBtoelcWTQey3/Scv2+B9ha9thZFi0mwvwZNxSxHkcwTG8x6oa3dYHHAFqyZaxGHSSKGnhEDFKbwmzf85btSo0HlyWz1XEtgKWHLWhotRQl85TYIT8cuKkmZYRsT6TQHxVH02p16w5P3/Ds0oy4L4pxHW+scecGhbX7T3QgMuVGzhIL/5l58V/Y3mfuzXVzbY6wDEyo1qPFBmRQMxpV6Ksrl6rd7sKcrc+IpnQYBS6qQjp7M8cR6fNvlafCPQnMsiCxcgnI/4uDw5bGz/TeqxdRkqAy5xTI8ZfdtNOTKzPSGYmOY4Fb2bJN6wDkn6aOIUNh3ULGxEAXoRSCc4iiO3/gae3p/eou3ruTHzjOPIVu68G4FkzvdyY/Sq1FwjnKfyELjBWzYLs3DjDB6dwdwaZRFyTFPR0KUhSZ+foJmcWmbLsYC+QVY+RX5UvsBwdHQWWgXbSgun06eBe9NVrLd6gveNP0HRydZAB3ZbUepyZ5Oakdw14OSVvEKTdDu+W8AqVkrmUOdzT+4dsmLptEskJvxIBPLvNVIeFkNGOhY7fES2uyD1O5XcaGi0F+T3u/urBkQVqz7FebxXN4g5NUe1HZFoT0f7QOZwne2aVq+LlgWSWp8kSshUeE9N4MCmgisyK5lFAJErUGW8I6GEpZ4C7364Hx/7Lz43vIkNaSa2tgWLx14TSdIL9q
 bPV9ANpp
 FjzVZlo4xiJGY4Cded+4b7AuipsIj5KCJINbEBEvyplp3U7NYgFAwk6hGHmvPLxoUQTR/PjQHmVGKBjf6osmLwwcl1kuVl2pZy6B2urISD6jE2sUu5W9WYq4K5UZ1GoMQqAvpx9eIJr4+cqV7z2up7cMk5mstD99tEwZWFGYmTg+5ZCEEulMjTGfBFHOcHydUtMqoRp3PprQ30fGg3UL6n9ncgMrzNnhU3WPkTbE5We/uPWkx2tNnZuXG1zNtfLeYNUiMjf8959qtM4L7C2OzTyIKC26Df6kh8FONJoUK+NlB3gMrTVsoiNO7iLoANzOceqjXeaeLFMij7cCZ9FuOnZjyaIrQ88UEu0/308Uj6OpzttS8FVpjMzSvJjw+SqPPKJ1cLbsGMfllH9QBYZmETriIl/KQcFaRYUYF2hVm9VsNCzvk+DcOlZNlX9qftet2UAJbjMnESxlBPh5N0ONEy6r+6Z/OMmpwmdK1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ and Manuel,

On Mon, 26 Oct 2026 07:31:07 -0700, SJ Park wrote:

> Thanks.  Unless Aveline objects or add this part to the next revision of
> this patch, I will add this  when I apply this patch to damon/next.

Using "to" reads better to me too. Please fold Manuel's change in when
applying :)

Thanks for the reviews,
Aveline Noir

