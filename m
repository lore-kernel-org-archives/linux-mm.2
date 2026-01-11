Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53649D25032
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 04:37:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27B236B0088; Sat, 10 Jan 2026 23:37:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2293B6B0089; Sat, 10 Jan 2026 23:37:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 127E96B008A; Sat, 10 Jan 2026 23:37:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 008A36B0088
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 23:37:55 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 679A1D03F2
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 04:37:55 +0000 (UTC)
X-FDA: 84318425310.26.1909299
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id 741B4180008
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 04:37:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bCJ9On7h;
	spf=pass (imf06.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768106273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RNTdXLWPuwQ2gqvJAF5I8RETChv7O8Xp8mYA5oOn2BQ=;
	b=SWayDTd29eclIsoBbzdQ48veWyrg6vdxbnKyEozSeVGHehf9ao1Ufy3SvjM9aMCJGKmZdH
	dQ7VbTCNr1sQULf/bUoY/DzD8+8NoswpRc1ALeHKpS0hWSnT2L6b4yS2YBP7pEFHy72rjn
	+R2/R50NwyHaITuBanl4ariNmSb1h60=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768106273; a=rsa-sha256;
	cv=none;
	b=c3qIyyUULZWKuaHSLOfnxkhdZB2ClH7vFbT8NzW5yjQbJuNS8TNVbsbOh7h6WnUXSpPtT+
	Wmu+/bZ2z6X5rIfP3EER1jExIu7B7MokhxWU6/qYd9RLGduBSJehAWsw/LkAM40Cx+olV7
	0rMgcXCxz0oFXuv+u/7N6JxFu6QKNhw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bCJ9On7h;
	spf=pass (imf06.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c3e921afad1so2292595a12.1
        for <linux-mm@kvack.org>; Sat, 10 Jan 2026 20:37:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768106272; x=1768711072; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RNTdXLWPuwQ2gqvJAF5I8RETChv7O8Xp8mYA5oOn2BQ=;
        b=bCJ9On7hF02PMqN9DTxZy6B6sWmO9QsZfdkaD0RyPuDgmv4J6CehvBlCyFqrMd/emD
         jCFuopFNP+kdigcDy4rS5eEOVvtBVVYs8FmTQAMgvfek7qDRTaAFTGgCNL00i2jbLWcy
         H9VxFem+CK4YklkmFGAgG4AVNKbg2m553HfVRnqj+yFMZnHpYD1DngpCGIdVMCD8FWVP
         eoJXBIqgu5Izz9h0tzDg7oYqbIBRW/zqDXgteKUH5ffBgc9IvgdZ4hZvdjCQBqf7N1YA
         LQG2SrHuhOO/qNy1i0OJwOJanf3HAJU8PdvnC2pjp3kv7z56dijX2RSKUgfl1vu/VUXK
         oA5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768106272; x=1768711072;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RNTdXLWPuwQ2gqvJAF5I8RETChv7O8Xp8mYA5oOn2BQ=;
        b=GudWuG0HJANwnd9Jw71gQxSO1igwn0/FXvAfSkxtq4lfyAy5BmyudJxt5qE5YPMUSA
         me4FcbAS+TueAlUfVTaz4dE27FKgzhX0C0893F1Aak2RSMLMamH7xoAQFyNpfq558HAc
         mSJnneJvSFKOvEYL32iNj9lPvTIEjw6BtvpDG568ByDcy+M1acmZ7pxh9RA3w+OZsy7O
         GDAt3cM1iebSh2ZyrXuqEQGj/KC0glq52SVmO4Wv+XyD8EpX6DdnS99RgbUov6DAl+Hu
         bIQ8oiNlhIcICgvqOJNjns6FR7qtMYLY5UX/orzkMi0dQjpqtw3OiWaibwpy9HxJXoTA
         Ehxw==
X-Gm-Message-State: AOJu0YyGyirgRcl5uTAck7dItzA1oTVUdrAwDbp2R4M4rV7c6XPXKo35
	PB3BH4s/COCBtvS/83nTexZ9YBNTJUKgumEXM2DYIA5rp3gikKXy/xST
X-Gm-Gg: AY/fxX5aKY9OABJAOQgZTbWn59MlIV/BT/CDza+o2x028H7MGodm8YkLVC1qmD7UGDb
	Sm5iIXrS5gbQizax95M7ytxtR/rJTCY8O1hjtp8OVeZNB7hN44Wjk26JX4MoT2Sq4LQth/qaL5P
	bSYUg6VJJLyVMnKa0LYrpQ+9MQdvQaHim0WppBXF/p2sPzs2E8Xmxtv6qPRYXEvBzW9BJwxLgDW
	Us3qD5iw0Qm/7tihjTUCHEDrzsFCVF7Xsr3rVnNCoRTtUbZRNx4Fd8IDdk7Bo0wlcImq+Pp2gB2
	3O2CCPR4iSlRJM5AkaqHTzX75/Acm06In9r0ku9XIO3oN2HUnLMm7PGYmKf0gc7f1TYuu3ql3k6
	yS16bLT7hd8UCyrqnH2I7BWtv97lAAOqnghjhFEKNvBcIuXBpe07qfFcAEqFFOnCSIeQCelsQOr
	mfMb9zy+1Rl2IsaL/5O/avAdvhrd0blcfzfLc=
X-Google-Smtp-Source: AGHT+IHUjVKIUncy/1zb6Wdvi6STOzA2v6PUBocX3XLH54HTDpNmKPMrWhTth1yxgQUS2bUbP5n5oA==
X-Received: by 2002:a05:6a21:3387:b0:35f:5fc4:d886 with SMTP id adf61e73a8af0-3898f9cf3d7mr13042946637.43.1768106272064;
        Sat, 10 Jan 2026 20:37:52 -0800 (PST)
Received: from [172.29.225.215] ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c4cbfc2f476sm165049a12.8.2026.01.10.20.37.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Jan 2026 20:37:51 -0800 (PST)
Message-ID: <7210e5e0-2a93-4d3b-a564-85c0fe117ef5@gmail.com>
Date: Sun, 11 Jan 2026 12:37:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: optimize stat output for 11% sys time reduce
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, linux-kernel@vger.kernel.org
References: <CAJxJ_jioPFeTL3og-5qO+Xu4UE7ohcGUSQuodNSfYuX32Xj=EQ@mail.gmail.com>
 <20260110042249.31960-1-jianyuew@nvidia.com>
 <20260110153342.7e689e794ce43a0a39c699fc@linux-foundation.org>
From: Jianyue Wu <wujianyue000@gmail.com>
In-Reply-To: <20260110153342.7e689e794ce43a0a39c699fc@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 741B4180008
X-Rspam-User: 
X-Stat-Signature: o16bqwmcftmqtcdto1zj343hirgt4y9h
X-HE-Tag: 1768106273-537155
X-HE-Meta: U2FsdGVkX19NR7Umr7LhkiYT3kbx2U/NqJKM4dztmYamqBm7+vswaQVTgZqB4cZPHKHngj+8WwonRldGp0T3Cnirk0WfYqtJYmkJCkRcSG7yroYkoPyqoc52aheF0otrjHjKB+BrmQ2vBy0VTopy3kIMFY+bIw/lIkVFglyQtn6VftRlpKuhbQqMzpSRm4JfI0R2AVNFGe2x7CkDJIwF0kHOCrOdzluzPn7z8KJyWrJ3jOmCMrTK6LLbBzdAtBANa9MhrhlnDbM2wt5pNUbuAQb+k7rkXbnghkwP1Z05iq6oizjx7wpPQY26MXPM4BFedXI6KkZJMRKQEko1IOl0eFX8h0Jj+7V6kH6AhuS7NwXK7UP4kxAY89vJP8G7Q0AXvZF7G64Za+O1RXTfFHTrQ+YqbtYxFqm5XWpOp3iZk3YYord5kUqD445ewb7uakJd5bkuAMIEtBRawU3OAqxxRNdlt63mpUYm24goR/midCy4sgVtfiQ6tLIq97FwkCuvE/x9N2HEPM1D5VMwrnq0NQkQwUG8EihceZueYbWBYHA5CEWWx08wAeflnMcde/S7I8W+7XBWy21dm3QcvSo0zMCJbKPWMzAZTXlUFd38F5GuR8gtIY/gyBAjZaA3EJiZGkUT2Qe/Po83Au4d7pRu0/9Os0JXYAhjw65228RrLarSCHizFDXcDZs5/cEy549is77eTV4vv2nMehzD7LrKJHOmmkLGOUgtkjQJUcOaRiDuFR81SkrtxMhyEmdyZr5LesngG4I/0ZoRHQbp/84Aokw6rCWUM8LLz1t7vJxdUOWe6Y3gg1pOXy0LU0WiVYVrEn5iAYN0dgTCfYfGOp7qkw6UZ41B4uFmwY+EhZRqk8xpDlYJbZ0lURSpE/G7vHmEbJOKgUCG7XtSm0utmEiEpi8qkPDuxEdtU0V9wIYFoRTg7nuSqzhcIu9ef0TYO0NTctw7GmqUESYU/TcZ1FR
 m5qjqOki
 oFL8Wjyta7cnuHmAxrSgvz39uhxYZbgUObWCv/jleGkm3UCFze+EFrSs4iPuLjrTmmtMY5Hs5gLM0sf/3GS5WX86lR2Yza2nhUGfFujr51uWesem7A53FqKM8NtmN2ZMLH/xIbfww9OqJqDvavDue2JHLkg43cwW2vIxUHrCLNOd1dV+lhJHfgXKjhaoSyu0B/QnqjbFNDO8mM6rGeTq867q4XwmiNwz4xQE8yP81AzH5x+2KOs9w9s/1E5zvPfE8AvuRippbzUtonSCuCXHghbsk6DYdD4a8xXUxX21lqeYzgFW7J0S+K6+sKKhHmFdImuVcifzFrEeEF6bzlWPqm8+CjoRWvRS2aIEi9l8VO3raBxVZnSuuB2k83CG+tTzJv04o3jukVqwRKpZqfHxlMkq1so1XVMg8xFsTTRcDbT4uQyooxMogOv3Bt9sc7eyrCt5Q/PTSYE6FlIvk082Emsa8jksa8brAqWh6vRXB0rvnM+1VVwv6Lh5mTYoVOKTIV3PKa02Lk9aQotVgHOnQ/ld1rA3v4iiPTLZV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/11/2026 7:33 AM, Andrew Morton wrote:
> On Sat, 10 Jan 2026 12:22:49 +0800 Jianyue Wu <wujianyue000@gmail.com> wrote:
>
>> Replace seq_printf/seq_buf_printf with lightweight helpers to avoid
>> printf parsing in memcg stats output.
>>
> I don't understand - your previous email led me to believe that the new
> BPF interface can be used to address this issue?

Yes, previously I think can directly use BPF interface to speedup. Later 
I think maybe this is still needed, as some platform didn't have BPF 
installed might still use these sysfs files.


