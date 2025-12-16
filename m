Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACC4AD5E38D
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 14:42:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE5916B0005; Tue, 16 Dec 2025 09:42:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D991F6B0089; Tue, 16 Dec 2025 09:42:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCFC36B008A; Tue, 16 Dec 2025 09:42:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BCC616B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 09:42:27 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3BF8CBAA41
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:42:27 +0000 (UTC)
X-FDA: 84225599934.05.00ACE01
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf01.hostedemail.com (Postfix) with ESMTP id 554EE4000B
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:42:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZanM3ZyW;
	spf=pass (imf01.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765896145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=USLUbCWIRItyPNRlR3PFuv3jyCNM5QnCHWwWE+UMMMU=;
	b=UbSLfRTjnGvU6UvUS7myyGk/VvoD76eLgIVLj0Y7eqoiGJbTaTWOkVYWe6aBKBM5fjJKrw
	ynsSZhqxcCp9c7XIeG7GVgDt3/SI48w/9z5s2fIEmmFdObEZ6B3xNrEFH67+uSwyvKjSvE
	oOtFsYWMyxRjVAJT1u5d6zXjTXG+QlQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZanM3ZyW;
	spf=pass (imf01.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765896145; a=rsa-sha256;
	cv=none;
	b=EnoYbOs+r4LYZRYbYe6FtQ1Qi3+z5IyJ9NRMFwUsDgPvSpy16PNTlbQPa6+3NFdWJPqrbL
	akGIoxvBICD5NhV6nZPDG8qze1683MjKX3IDmuuJpTopKsvAeTYLnZ3U92swk+h6Ct0kyd
	qv94UuuXJje90bXDcjgYm7hYy2HwlLY=
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-78d60c6cc17so35677007b3.0
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:42:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765896144; x=1766500944; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=USLUbCWIRItyPNRlR3PFuv3jyCNM5QnCHWwWE+UMMMU=;
        b=ZanM3ZyW56GmXNvNXD7Qcyd4T5VawVEiQeXU4KnG6jyW76m7Hrf3rQmnH1Mj0d9QpZ
         0X2+xCPx3UfKS1ONkNZ0B+uJOK0G5KSVa1PxtL5oh7VI13m1HHGcQ6brj8H3Wwa8eEcb
         Cw3abHpnc7Ptlyi99nZiGcrpple3tIkAWcolsyb+g+mOLIUT3WKa87q4vop4ByAnYU4o
         OpMHyHx+9ynVSiL3MMmyA5zXznOL3XsrggXxFP3HzspBIjbeYwby43baXiLZcag/EatK
         TmqVNKJ+A574ffAdlZWru+bkGpfDC/nnOPrVDwC59JTOcPhLkmBr3Z2HAycXUQqaedQM
         0rTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765896144; x=1766500944;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=USLUbCWIRItyPNRlR3PFuv3jyCNM5QnCHWwWE+UMMMU=;
        b=AoQA5+JkB8qj4WhDurO6SuViNQSw0dXEy0jxp2/LHZQN/APJ10jGdOjyMzhEFlywRm
         j6lOtOk/+MSQFG8CoKhL/1vgpAzP2p8Pn2q5jMqCgj7XLthZe2Dpr8ca+B6br2WlbH8N
         uF2qV04ALFvltEFDfJU1+VVVvuZs6l+p/K3qDYlUNKyH3vXZripKdP9i5VQRW6+KV9Sn
         doV1PpDsNvLMUnE5n+2e0oY8e42CTGxTQrFPtyz0w0HdbeZ7h4S5lmtY3mx0CqZwFuCl
         hceEBA6vO5kB1DSgTrfJPvCntcTd9nnCcaWVWIwogmu8qkosIr8Pwvwi8cF0uQtDgGDq
         JU7Q==
X-Forwarded-Encrypted: i=1; AJvYcCXBoi4YzKQv6z//9AqlVc5S149Fc7FFbdGiGW5toT51okKQgmtun5Qu0+mp4SXhYmc3lMqhp9vzzA==@kvack.org
X-Gm-Message-State: AOJu0Yx+OA/922vQyM+asXodZu/UbXIjjr+/g5wU+jAo4ZuPVcIQRTBJ
	UYtYzcbkfKyxgIezR7FdJ78sKmCxmQ3cIJWA1697p5pxoW6fJ5PwGAgg
X-Gm-Gg: AY/fxX4A0UPJTs39rIj6gBBNSRXnT1V21nT75VckT2LPKRT63unm5MLyQAf89XQoXa/
	CRE/k7bJxcHj6Ju9Nd9vMCUOf1Jal9G7HbMD5gO2qko1S8wh56liKOgjHMioV1+sQmsYAwWsBdc
	vQ5gjO1TvkdlXyyDvXHnwXuUYm0qt7/6i4YQ79IfOn1jbUZ3BySXHAiW/JlGmQe0xlfp2w8dJoZ
	bdbIo5umldnnlsAXq3ddwsEOS4afe5VfllqBLjIkHcve5c7SoZ9A8shG9j5Ej+oZ1yR1zb89+ZM
	69obIQujQi/jmo9IiWm6Fxq/CxcmTi2wcKExmMr03In3LqNOROqWHOUORbJ5rkAsm0UPuVBbjis
	LHSr7x2ItAgA94zX4VyC0/mkEHaziozYSKaTfnChb0/bOxQGVXBJj+A8M65gY/DHJd7kX0JzLk/
	qd6XK7yyrqQZfTktEwEBJd6bAwnMHGQDDd
X-Google-Smtp-Source: AGHT+IEZl2lVeXqzE0UP74LHQIIiykLzebLCX+ESaV5AxCCfllhU2dmNHVWzQGR/7YXawMevWUQ94A==
X-Received: by 2002:a05:690c:6c0a:b0:78a:7a68:e4f7 with SMTP id 00721157ae682-78e66b5b763mr108032787b3.20.1765896144307;
        Tue, 16 Dec 2025 06:42:24 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:4e::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78e748ce551sm39888797b3.6.2025.12.16.06.42.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 06:42:23 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Daniel Palmer <daniel@0x0f.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v3] mm/page_alloc: prevent reporting pcp->batch = 0
Date: Tue, 16 Dec 2025 06:42:21 -0800
Message-ID: <20251216144222.2982594-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aUFt6Q7TIbFV9v95@casper.infradead.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wd69qfc6wjna7w6zqo46p6nrdk99hmpt
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 554EE4000B
X-HE-Tag: 1765896145-806663
X-HE-Meta: U2FsdGVkX1/nZZHxoHmmm1kM1tFTok81SrKqNscSTqVsUO09PrZ59CpgELrJT52MB10rfHfQRQKY40CNyzIIPJ9DRpr9vw9LH3hkDgSrPuYxm2siu2JETwnR/VFAJeVHZSGJDqyC+NzUQ28oLhHavBkkS+oMLlBXnJBbPZdMCTWqHE2YVZtmDxCy9+e9ZflC6usq7TGFQEOAEA/J6yBxLvHAJmpteIY69kwPXMIZik8+7aHjLTVsQOEQjw6flUABYKvu5jv6FsQy0I78FagTHzqaVC28gdOHWvjsxoJ8dJilN2kjEL6nI8YWCl1QKeAepP5jKjp70PN1XzuDZ1glQ6JEt8+3VkKiO9naBvZnHYJSDn3HlOz3QuV6hSW6SaeGOT43kRHpZt7gAaO9rxN/IzIjHFZ4ha7fgfcvsNmCQ0rPgIIBbJ9fsFaG/RlMwp7as+phqvRUiZNUv1LldSDrf6qhPBv716Oe1lOE9WBg5NxyyXyooUgdA2i/P3OljkQKy7BgEIHlTODTYO1OIID0m2N9532QnHdKupS8nRQZ2jxf/HX0jcf7P1hY6flhkMkWVJE3Vy1w5v/T5d6Dfz0M3CLqQvPTO5ZLNkfuSyAhJtF8hD5OeY/LDSvxIaFT3bGvNgcl03bM4ss4VQjLDHvtNrjzU7QMqSJGrcjZeErlRIDJi+lcEE+KxHcCpzCc83wZ05bgsBeeIkHVbLaXCmaqTBOBFyuE1EBApYnCB3osaGGvSuNauaa9ojIFwHEL0UjDrvTDA6d5X68/nYyVoDtNzfvMzv1zy/7Hc5pveybGIGbyNt7sTkiSE6s7jYU8saqp31TWWAgJvLO8RfhgwazLxtfbSnwS/LgBKC+qfP2pwi2du4kp9d6l9z/uQEaXJjMOrXmyqFyZuAhdg6AlYUTKB6BIVy/ZfIsXokKR/5SPJ/bNWCnnEc8A8wr15il7WpXdwFcBoAIm9QrNUycZarg
 5c79bDH5
 dt9Dc7EDDumHgCcRSEM9ochyYG+9TlbOFEaoixF9Tt+6YXSZUQ49yVE93kUSCxoTGxoCuSOrgzH0TfD1CcOuSk9GVIgc2HaL27A0ZhqAc+oQCq/DWzQRw2UHcmuo7+uU89qckQDURtq+fmmvVUmujnCn8u/yd9VPpk7/yjaV5VdgTH/i5yycOmZMR4aqXKC3OLl7wXZujTzilsmWXfY34elHNsImgwOXUON0m2GZS58wsUvgB9slLWq8po+b68XdgsmXIG4UqTO3QWuGshRyoIGvrTLGYtyCz2c2elTrGBVt9kSjVm/CSCX+UXKyKgFEhtxum+GYpSDWuge3c/liQ9DR7fcl4GxMDZc0i4/pALqJSw8i+ypw02aNC6S0H2qgeWLYUI54dudUYMiuF3M1y8JvHuuXmMLhAbHz3bCd7tPMqkpXn0d1iwQC4UV3HwxcDMEtCD1BLBr6s89hXwrZrqgDiA6kBvamhcbgdXSRGvn9GTMnNd67DGXwnqxWn5JG+fEgxXu0SBEMwVcsRBXbIsEOaywAIPxVrMgqOJ4Qwl+IhvDPW+WLacYTtIbUwzcYnF4Oy9WcF4oZRn2IyBHLKD3H6bQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 16 Dec 2025 14:34:17 +0000 Matthew Wilcox <willy@infradead.org> wrote:

> On Tue, Dec 16, 2025 at 06:27:53AM -0800, Joshua Hahn wrote:
> >  	batch = min(zone_managed_pages(zone) >> 12, SZ_256K / PAGE_SIZE);
> > -	if (batch < 1)
> > +	if (batch <= 1)
> >  		batch = 1;
> >  
> 
> This seems like a no-op to me.  Did you send the right patch?

Hello Matthew,

Thank you for the quick catch, you're totally right. In the original patch [1]
it is also supposed to just return 1 there, but I think I got flustered when
I initially got the bug report and forgot to include that [2]. Sorry for the
mistake, I'll send out a new version with the correct fix.

Thanks again, I hope you have a great day!
Joshua

[1] https://lore.kernel.org/all/20251009192933.3756712-3-joshua.hahnjy@gmail.com/
[2] https://lore.kernel.org/all/20251212015330.1874521-1-joshua.hahnjy@gmail.com/

