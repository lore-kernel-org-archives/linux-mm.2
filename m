Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCF41CD343F
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 00:00:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C41C6B0088; Fri, 15 May 2026 20:00:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 374A36B008A; Fri, 15 May 2026 20:00:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28B1C6B008C; Fri, 15 May 2026 20:00:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 19DA56B0088
	for <linux-mm@kvack.org>; Fri, 15 May 2026 20:00:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B38271C05BB
	for <linux-mm@kvack.org>; Sat, 16 May 2026 00:00:42 +0000 (UTC)
X-FDA: 84771326724.27.3912E9A
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf26.hostedemail.com (Postfix) with ESMTP id 917D5140006
	for <linux-mm@kvack.org>; Sat, 16 May 2026 00:00:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=eBto5m2S;
	spf=pass (imf26.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.49 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778889640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uW71oVHB30vt4EIgGt8pF2rmJSEtvt4hUFu3tv0VEdo=;
	b=i+YZUslbNZ3EqELoUXF+Tg5nMqzngOQyLOhe4PMAANJGXFkWwzJn1v1aLCj6HYW7VxZl/R
	kC/+ZyoJtvU64Xog898RdFKB9M7IQantoctqGjYcVaK3NBgMbEbmqcclW8FJs6KS9s+jC8
	6uHJbNdtfV40DAQCsuqYKxEi8D6u3Nw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=eBto5m2S;
	spf=pass (imf26.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.49 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778889640; a=rsa-sha256;
	cv=none;
	b=yf4XKm7NQt8nh9Gmxvdarczkl/FcQqYTaJ4V8odFcAhVukqEbP71I5+ApPez5LmKRT+3k1
	aRAozaSFUv6D9HIBjNuTkXLDcobj+ZsfSyyK0dPT3py8VLAWVbVCZuL4VR2Qr84oJzr7u7
	rEJbF26Y8EB+yDfmOc7d5VSo3Clxp3Y=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-bd394f4a931so90798166b.2
        for <linux-mm@kvack.org>; Fri, 15 May 2026 17:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1778889639; x=1779494439; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uW71oVHB30vt4EIgGt8pF2rmJSEtvt4hUFu3tv0VEdo=;
        b=eBto5m2SD2OkncKmCEWaQx+xbOn1PYSn3WzmPBXftXGzEyBVWyCRD+eVZI1n7gu1bW
         CrrClkzfbPBTaKoYv0QoYLSdvsKmSPsV6Xi1+lJMiQDy+edISfQHFkBJbvoWKmSvLOCR
         JGDLTWpGt56COgo1bf3EWeimlwqdxNuyG+vcc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778889639; x=1779494439;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uW71oVHB30vt4EIgGt8pF2rmJSEtvt4hUFu3tv0VEdo=;
        b=ej18ALIWKkLL8pksczH+1dHhIajR6kQgEKKmqjNxxoZK9ZJbGKyWz9tVn9WeqXQ9m9
         erg8FPyzdbJP0frkrMolZXVTUuBQlQO+GAJUXpMxGpBxZdpSmrleh6lQLzxm6QnGohKI
         Kxw2UEDjEJ3SDszFTNgM6qEKC9vruxyg+CwEIb+JiEHE5+IJdJhHQSVhIjPHWkaimt5x
         C++2kGSaF0jN73KwnLOI6VAhJeCX530W3wJC6KYv4VXEaYWbHT9XPflOBuorndKlJ+wa
         gFDjp3WKd87YyDZ8ypPhz8CyFAkUB/4iUoQPDYHrLiNaxPYpV2w4OwGSh5YdEfH7VADI
         ddoA==
X-Forwarded-Encrypted: i=1; AFNElJ+a8QDPt5kaKyrvUqAOM9506R05bFg09Fhk38SiFTYZmK3+HdVh318SVPJJSgprK8Wlj86cp4UKIQ==@kvack.org
X-Gm-Message-State: AOJu0YzvJzXLY/v1Xi9vOcHtmmKgzAMk65VXA6F9Y9SovXoHMEVjcclN
	As8bg3X2iT7vhhdYyxePVzW/+Vo43VSIrWLvla1sQQvP3GtX31kBj4EDau+kuD5UM2+VqRx+1t6
	lybXiAlU=
X-Gm-Gg: Acq92OGHrVarGvLSKybUKhxlX7wtfeK5SLy/5VAvi/baPAoJ1sHiuvFWF5TVlECrLlQ
	5LWHiMnjsg9HHl2ynUKLecEuexGLmEA4mKh1JyI3ZdlZE80KDcv+EacL3htgOFpHIYGlyIgaePk
	CSAX+PA9Tm/KB5KaAEJAki2s16nkJ0nUX5kPf+wQ92N6ilvgRbAnlOzDhPr/XheSOkyjQnwmgra
	kJ1Loq93wkF1Zngag6GbpCNE2FlC1BSkmSYJotf5WjGRasJe1STN0Vpz904VI3FvJjXewgiQzcQ
	zEEUF7LKp1jEzy0xdlAXNJ9NHoC1OAAfAZfNz9bYR+UJgsUM32gkk/UB2Zn9MFnMrodaP1TTRqi
	oh/EWEe52l6c39gS506L+uhpIzqv9QE7VDBMhb8Vp+juJ1nHSRjauUTpQdXXwh2cl4+6jajNO59
	LRbng3Gt6CVnXk8cJucFb3Ti+M+0nLGFUZHeg9w/z3xc4jHdTpG64pu4p2e9UgdOTggdU/7dkL
X-Received: by 2002:a17:907:e151:10b0:bd3:66e:e4f6 with SMTP id a640c23a62f3a-bd5178aa22cmr271074366b.20.1778889638601;
        Fri, 15 May 2026 17:00:38 -0700 (PDT)
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com. [209.85.208.49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bd4f4ded6dfsm294957266b.39.2026.05.15.17.00.37
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 17:00:37 -0700 (PDT)
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-67cac5ece75so1045368a12.2
        for <linux-mm@kvack.org>; Fri, 15 May 2026 17:00:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8jnotfvGUz8WdyxykEOa4HrLIpsocFhNqtLd3xGT2Iv4GY652p/ytp5cXPG/RisMsn+105eXikLA==@kvack.org
X-Received: by 2002:a17:907:3cc2:b0:ba9:2611:31e6 with SMTP id
 a640c23a62f3a-bd51780c5bemr340822766b.6.1778889637242; Fri, 15 May 2026
 17:00:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260511214226.937793-1-minchan@kernel.org> <20260515-nachdenken-umbenannt-a90006a46e14@brauner>
 <agd--WZpeTq2iKFW@redhat.com> <agefLhQeWpvil14M@google.com> <CAHk-=wiHfzbufXD2nuc9BhOVp-pYEmnVUYeThKmfZRXLU0kJ7w@mail.gmail.com>
In-Reply-To: <CAHk-=wiHfzbufXD2nuc9BhOVp-pYEmnVUYeThKmfZRXLU0kJ7w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 15 May 2026 17:00:20 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjRbQhZPLfHFjikMNYyiF=ZwNCuQb-9b7-ssJJuvi2_6Q@mail.gmail.com>
X-Gm-Features: AVHnY4K1qAtNT0_ldZjhVwjRfx_9wYac0JueZzPmVNpMpI68VH0jl5IZDzRW2lM
Message-ID: <CAHk-=wjRbQhZPLfHFjikMNYyiF=ZwNCuQb-9b7-ssJJuvi2_6Q@mail.gmail.com>
Subject: Re: [PATCH v3] mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL
 flag
To: Minchan Kim <minchan@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Christian Brauner <brauner@kernel.org>, Jann Horn <jannh@google.com>, 
	akpm@linux-foundation.org, hca@linux.ibm.com, linux-s390@vger.kernel.org, 
	david@kernel.org, mhocko@suse.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, surenb@google.com, timmurray@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 917D5140006
X-Stat-Signature: 9rdh6triifdogjomegmzb8eotjjj4m7h
X-HE-Tag: 1778889640-491221
X-HE-Meta: U2FsdGVkX19kxpZ7X/zeuz1rYINe7777VgtVi7PyoBcrx27mr2SnO1ozderR1kY5Gqx7upNr5rMgCyij4CvGfjX3+qY+1/Kp22rrtmuH3ZImqucfvlYJD7d/hZD9Xw+2xbDLcDG6wcnywvqh65uD776f6BpY1cB2SYom4A2ltZ1eMjvhmu4Wi6IYl12BXL7nKH38b81CUc59fv5khPJ4vkPl7RyzoZpDZog7RLwiAoAoFWBN9hH8WjRSfp6GB7bBgXxATiW+4LfRVQ4wXNCt+UHmelHxl//zroNfD4s6Q6tGypa3okQ6HDF4ld8InTgKbkIaWkMfN4HPYa/WwjrNLYFjx/N7cNVOhhU0kY8hBc770c9gnBRafAENeR+QfWv93MTjvdYiikPEcy5+galGSUzeYFD96DOUp2KAI5KxGVQoIq6D5aRf/g4T2Fd8BjI88XeqvLhJTGLKvtFDvT+gUBslR5W+F8buvEAKd7Di5thyNdBR3lT+7SGDjgv3+hKWQpwhqhBx8DX0xxcY2I4eD+Gvp6tSTVpmFwrGRTLWbkNG2ccZh7kJV6aZyDJjk0HegJ6G6JLjoNDw9zOa13k1VHc7VX47S9mEzx1BsLE6xGpX81dcZEihJhmAZqGGUgpnAO/onrr2ZAGpwR+sP4EKOOmE1CMjhLA63u8abIdhPSGcmEu2xN88HNkD2wXZiThOXSVQm3MvAUwQMXYu8KsP0MVIu8mespPd0AJkbUqhZ92i2JEfygB7bjoybGUBUVvYgsQ/a8W3VLDUXgE/yPCZy9XfmFQw0CSjd8DYVdR7ZsPbPY7OVkKwLtTehjZrIU+WbBe8ejV9e7C8jHAdv7juZirNBRtKcc1QMW7lVlEduUC4H+OcQcSQh8TVUqvPRm3AjzYoRX5dYPHAxfQ0ekVSpBtgYjfMpVaLe+WRm5yZjFQUiYQ+hGlrKI62Y56eZwKNIKa2oTmo8sjseuaNH+8
 sAhZfi9W
 dmFrmLCCeP6fAzHsn0X9++C/JyJ2mSAz0YJJ+hPUH+1s+y1bCLIV5Ch0uNu+m+Fp8I+si0M6I+hE4tOMmnkl3qB5VVk3B9IGa1kgIsxJEAYzE6GKcx/KKZjwCwI0wg27oO4cJ957uIISByhEYNEO6txjNKrklJPLUzVpzVFo0+1GM0pCRJp+EnnYpkA98d/k3tSxXqs1M0pFS/OzwjVztG037gBIbtx5oCUHTC16hZscH+fvp9dSevc2Rs+4t/vAU7RS0LUG7RifLYz1rnR/c23L1pxqpFi5hUR+ua3fSdFnaNm4Vk2ybolm7xm56rrwcCrIJj1Di8rOhhlEPySx6KoaWy4wMX0GyWtoIxuTucB4nIlAXDFd3CBBfJ1Dj+1U3bGH+7lrJhzbRw1rGy9/n8tk6Qmx+C4IwQL9Gc/WXU7lnULMIKqHpyeFi00/+rOqPgs7gUIwGi4mWE+QcZ+7YCR8KxkhL2K4v6lz2Lu1ceDSZUzlMBYxmVHnBUC/rQcRRJ7qRk72BZSkuxDjRoUzCMl4CHmF8pFlY80Y1mkF7JX+aqtyyJbQaXk4zpXmKYI4OEWWkENQytlAK6wE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 15 May 2026 at 16:45, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Yes, yes, we'd need some sequence counter for when the mm changes due
> to execve, but *that* should be absolutely trivial.

I guess we already  have it in the form of "self_exec_id". So the
tuple <mm,self_exec_id> should basically guarantee it's the same mm as
it was at open time.

Except it's not updated at quite the right time. If it was done inside
the task lock when task->mm was actually set in exec_mmap(), it would
work as-is.

This isn't exactly what that 'self_exec_id' was designed for, but it
*is* a sequence number for the mm of a task. So if a 'mm' pointer
value gets reused, you can tell that it's not the same mm as it used
to be by looking at the exec_id.

And I think the only reason for it being done outside the task lock is
that the current use is all synchronous to the task itself, so locking
or location simply didn't matter.

But there's some mqueue signal handling thing that looks like it's
actually violating that situation and would race with execve().

            Linus

