Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 653CCCFA46F
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 10:19:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C425E6B00A0; Fri, 21 Nov 2025 05:19:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1A016B00A3; Fri, 21 Nov 2025 05:19:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B569C6B00A8; Fri, 21 Nov 2025 05:19:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A1A1B6B00A0
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 05:19:35 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2328DC0532
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:19:33 +0000 (UTC)
X-FDA: 84134217426.11.9A6C155
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf20.hostedemail.com (Postfix) with ESMTP id 387081C0009
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:19:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bSysSRdh;
	spf=pass (imf20.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763720371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fl8adCxt/vfUb1UBb4u8ooJLjtthQIoaUka2HLaP68s=;
	b=RgHB2d+ubYoNxxNmlFCSQQKD7j241u9Py0Odzeq0mFnPfU958iIah6oHy1kb2IPm/TkLu6
	YpGpDBxHg9cbv0KuTII1v0VE8KeJiIIt1LJiuSmn2jI147eo9RgkgKh3K2kalDRmUJaAQe
	TerZfkz8aQ0uxhwKuVY2OjcoaxEaMQQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763720371; a=rsa-sha256;
	cv=none;
	b=KKBwWTIIUtwgbYAgKS7hD/2bfO+Yb9xJ9+enBO4zGHDRn6KE+WZD4RLZnGaUtAZBFAcJIu
	xHRs4F6z3AjVWOmeT4DJWoShpp8tZloD/zW+oCel46pzjZMCD5Vkxa+2U8qDfGBhTVcnF/
	bw3JcuG5yospWTuBy0jYQj8gtynsYEc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bSysSRdh;
	spf=pass (imf20.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-42b3c5defb2so1158147f8f.2
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 02:19:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763720370; x=1764325170; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fl8adCxt/vfUb1UBb4u8ooJLjtthQIoaUka2HLaP68s=;
        b=bSysSRdh9mFuq7XFDvyd1GW0OFJllSBJ9aVyyJDyf1RF1dfR0sd8Hc21fS2ILmObAa
         6L47VjE8jX+MBPQLWqTR4kq1nRP6bPbzGVJ4UpldtJp9Rd1W5b54TY+zrKWxt4bMtuGY
         GZkwgH8HFS1gXLHkSBq/rkoNTLJppyh/+mJScDQsB+MKXFPrvZvim1mDEsTpFBHqfKuW
         ujr1h2RRgw3toRCutgpjk1AjlC++f5CBSBkcopVdcO6o4g76kQ0OppYqjAhrXO/op0gu
         kzJb6SXOuZssheGvnxJmkkAhffRjSVmQIqaO/DjYfT9iYADqceKJ83yfp5E8eb9hmraj
         dtvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763720370; x=1764325170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Fl8adCxt/vfUb1UBb4u8ooJLjtthQIoaUka2HLaP68s=;
        b=YlnChjpnKMq+QU5tkSZkpYmpP3Np3xx3L5VIN2TBbkgvMQfEDVrv8kTsrR41tNzFzw
         pbyZwpvwupBSJJzGZg0WL+68a80U+O96JgwFrLsv/bS9fy/HjR0vSOVTXO+l9LSwm9Ku
         JmbmgrNF3P5Ii0JqzH/5FKJUpf79dlRmNjKw3DC9eCDETrQejlO03bJy3WxjMfrlobT3
         YYLS9xiwI5gWCydhWzV7gkOMxGKRVpwWCjZzFYrS38DY3UXXOB1od/PUnyr8lMsmjBX7
         +OJ8c/KDvy2cIDvXchi5mzOQ4ddAg3Vof4LX7Dj914SVtiR88hG/rAbr6FZSWK4hacHH
         bLNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUa2D+HdwxEXnJYWmZwuMoO/a2hr1VZTV6DBTVuIqwfIwqfYP3vtUaA1jFyJWwfTdAgoX7Hah+v1A==@kvack.org
X-Gm-Message-State: AOJu0YxZtmIrHjEk6zbctDF4NktPClgyX7P8l0/pQHSoP7YClwS9TMmE
	VZfF/MHJaPOhgIFVZCSiNmuLMZDZHCg2VmSlPG64EpVnhoywD/c3WBg68kxqxOoBPnCJalx0s/u
	nbPFVwY+1Z9dDD28pFWgQHY5ROlejkFc=
X-Gm-Gg: ASbGncvgRyS0zE5vr2EJUAiFcYeFN3hWvfGXwXpU7F6DYxNCXx0AbbuSlviWl6dCSA3
	+03QCYKcxMdwAlD6A/SLLH0fncaj+PP5je4kKMhYEQ4VTPbuhgP0BDPQTuGBEcinynZhviyiXrz
	AKaUSYakBBGQFtkuJQ4w8d+nfDY/DEkL2pGXTYNnNdHxdro0pyDoEsOGRHfV2QpKI8ARM8f8IYN
	TQBRdaSYceseLHGK5mJ+4bXqxDQfqUjZDke5VkhnpdFvm74ZN18+ZbMWeMO/eTuAa/fAQck4rWd
	u71PMmY=
X-Google-Smtp-Source: AGHT+IElXislacnBtN7hewvgqu//kJZz8mvsu9CWWiM8tZh0FD85j97qmCMQhR832hy/Q0IDxyA49/2qxmcG6Wrm+Hg=
X-Received: by 2002:a05:6000:230f:b0:42b:4223:e62a with SMTP id
 ffacd0b85a97d-42cc1cbe219mr1670964f8f.23.1763720369386; Fri, 21 Nov 2025
 02:19:29 -0800 (PST)
MIME-Version: 1.0
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org>
In-Reply-To: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 21 Nov 2025 10:19:18 +0000
X-Gm-Features: AWmQ_bkegNQvtsPMtSlpKShw9LLIgMIywaubLhmu7lM9NyTfyuvQs32PA1us8kc
Message-ID: <CAKEwX=PQM_4Mp75R4yeQ=WoqOxj7EJK=FpgcemNSYDS3fLXQLw@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: Chris Li <chrisl@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, pratmal@google.com, sweettea@google.com, 
	gthelen@google.com, weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 387081C0009
X-Stat-Signature: 49zqb7cn178guquzdnqfrs5z8q6k8fof
X-Rspam-User: 
X-HE-Tag: 1763720371-631522
X-HE-Meta: U2FsdGVkX1/4JFbxvnR5WMax0q4wUWO4X0LIudzAQI+npnquyfqPykRz8HFJDVTsKbiK3FXBcxXY5U1FJ5ltuoPcMo/XriwMcN19clOBMb+4J4ZBSWuwzHg9ePzhXxxfxj3eulXWQlXOKpLqXj1XONmE+aXB2IC29JAp1MQln9Gz/JZuGjv0qCoYp8Ptdps6QcUEiOAl9wZkF9CwJgxhXsWdrZYO0xOeO4qmWDT9jS1JilUJygvO+D5P9DZF1paZlRes8JF1ZAACoJdFPTjEB8rdIQJJsw3A3IkQvNo6bCbtJD8g01Yxsu4aEYrqDtTsA3NoE9JwrSh39saskvaqIN/BQkStlUBCiUZqvMQtF/Og5QNLEyyQcosdjPpSp9Ul6QYBeqkPbLJrM1qAlR5vhQXqSFNORgLt2uwj8Qlm1oFULyAatpfduCogJVPdu2aIDYY4E2s7S1wA8QZxgIbkgi67z9Q3zp9CoIodw2LPDiF7OxGLfgfND/ep/z5oOjZ1kDcvdPrSIOmJRdweg1sPI/698PKtPF3OhQ5pFSs9hAXX0iHq8sKfXcRkpjSh9xz1fxXpKrAgIqZZ3MeQxPIAhR1uv2+R/lBj++IlH+91AHK9N5gV6pX9nnFxcrI+kpzamHBNZEIl81oJ3Jk6us0ehdCSgdX+8YFLHiznMbeQ2clIYwg4fpVRjhOm5GhnARTIoEbZw/zPbliHHy8UczzoX6FK9luc9gPmcXigp3YmO+3l15FZb5FX464KH8j413zxIsxbjpXLcfSlf+YuvX5c6YNSRZ3TIejfHNFlOh8ImXy6aXBhU3YKNmAzpKUuxtUb7p8rszMxDdtv2weQMJSMhtCLMgdboXoFpq/d8k6lmoa8/ikK8Esq23T2EIBxovmF6dbDbUj5uu/J65m8rtZnRwTm4oUvHL21+pfoHtaz7Qia3otDF67mdEuMSKsnneHBelbDwD8Vo8wlSjc9d2E
 x0GpHUuY
 cZE0dKMDbna5pvhY78iRr1bR4H3epuBsJDaXdUOLJ068bEpFSY+OJ1G2J/Ni6aYOt8dMuqjOEL+qTlHrObLjVA+6rFmiJkD4tE6nfHeKztI+AijAoRT1wiO7GQhGOPenhqGpjE1b4+EeJJPvWQzrSxEjupG3Y+02ucd+wytHCnknqrV/iUlCh0JVuZvhwO3PtVyLSgqjZ7XtQxTAdSc/vaeIw9ERUVmRk8W37qZZvrv39Z0ISzNNtl73CL/XHkv0DLuojsoAmu2JhFVuxk7CPZQBu3sZ9S4W3uS7N81IvfWAI9kCU6wFWry1ttl9lLHsMr7iRR+h1rsh/7dWsDJHqdQwpyO1xhC0pedK8avoCy2JoDaZfX/IM7CqJCg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 9:32=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote:
>
> The current zswap requires a backing swapfile. The swap slot used
> by zswap is not able to be used by the swapfile. That waste swapfile
> space.
>
> The ghost swapfile is a swapfile that only contains the swapfile header
> for zswap. The swapfile header indicate the size of the swapfile. There
> is no swap data section in the ghost swapfile, therefore, no waste of
> swapfile space.  As such, any write to a ghost swapfile will fail. To
> prevents accidental read or write of ghost swapfile, bdev of
> swap_info_struct is set to NULL. Ghost swapfile will also set the SSD
> flag because there is no rotation disk access when using zswap.

Would this also affect the swap slot allocation algorithm?

>
> The zswap write back has been disabled if all swapfiles in the system
> are ghost swap files.

I don't like this design:

1. Statically sizing the compression tier will be an operational
nightmare, for users that have to support a variety (and increasingly
bigger sized) types of hosts. It's one of the primary motivations of
the virtual swap line of work. We need to move towards a more dynamic
architecture for zswap, not the other way around, in order to reduce
both (human's) operational overhead, AND actual space overhead (i.e
only allocate (z)swap metadata on-demand).

2. This digs us in the hole of supporting a special infrastructure for
non-writeback cases. Now every future change to zswap's architecture
has to take this into account. It's not easy to turn this design into
something that can support writeback - you're stuck with either having
to do an expensive page table walk to update the PTEs, or shoving the
virtual swap layer inside zswap. Ugly.

3. And what does this even buy us? Just create a fake in-memory-only
swapfile (heck, you can use zram), disable writeback (which you can do
both at a cgroup and host-level), and call it a day.

Nacked-by: Nhat Pham <nphamcs@gmail.com>

