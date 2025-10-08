Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DC74CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 15:46:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF7F68E0040; Wed,  8 Oct 2025 11:46:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA2618E0002; Wed,  8 Oct 2025 11:46:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 990538E0040; Wed,  8 Oct 2025 11:46:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 87DE48E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 11:46:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2AEEBBA70C
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:46:05 +0000 (UTC)
X-FDA: 83975373090.18.5C98BBE
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4CA761A0010
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:46:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FzMoOBff;
	spf=pass (imf19.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759938363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MyHmjI+Pp+1EZQYG4RmZ+oWmdMUJujz0MvnC7rq6UVA=;
	b=31bjV1dJeQ+zmHTA8NfZpHztEeyhUZdbuFnRRKy4CL0u7sJAg+mOYBu0dUMiVi0WxCm4mM
	jE1iWhU9LymECxiNsyljqJk+8ZFb/CZ+g/4katMfJ8h8jPJ5msZEcILlI5VT9dfr4mOFc7
	5zTNjwSFDEtJlrvXS8Zf0MBWligBlPQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FzMoOBff;
	spf=pass (imf19.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759938363; a=rsa-sha256;
	cv=none;
	b=GZys/etOVU3yHAss0cmAfgOIpU0g53Wx+u7Hn9cu6hVNea6tkWTUg16fyZukucSoUgfWQk
	cGqkEIdbbeSq7FLNaKY3GRLDJQblJOHBc4rguPlII0RZW1fxNyEJrCeaX2ld+nxlcoZUx/
	EXcuXVS+7AXTJ6l1O1ip8kNsLL1BO0E=
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-911520e43edso303717039f.0
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 08:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759938362; x=1760543162; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MyHmjI+Pp+1EZQYG4RmZ+oWmdMUJujz0MvnC7rq6UVA=;
        b=FzMoOBffgS8U/PcdC7mY02PEgmu0N0i04hb81raPNibc0y78GvKETcoA31bU22HHfQ
         wTcV+FnbFOHMuKj/NqJ2oRU84lvDmtQhTDv7yVl8VtqySe61WLG2LfK0dEEQ8BtTXBv9
         laYFFaS7CeZrwH9XpiQyCXSUcMCIetur5mQTLl7/RSXiXyv+FfPSEJbITEmaFO5RbZ5E
         nh6TsjJVaSfhfhpVzO+gL5/hZstnT/WH3xHiWnpH7tNZ3YicZghu/I/qMqMAWFCEWVJy
         ZCRQbn8j28Kgbg8nnU7jxbIzmrxqTzCVnJXD7I1LimP3kqxLh6HOCSrj+9nTEIFtE1qF
         ZqcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759938362; x=1760543162;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MyHmjI+Pp+1EZQYG4RmZ+oWmdMUJujz0MvnC7rq6UVA=;
        b=luo0baQs+Cpb8Mi0Xg2HuuevKYl6R56A4HM8GJvcDSpJbV6u2srF5Sjvo9U9OkSz6z
         TDjGXOlyl0hvq5PDFMnwsgxPxeSLGtKtra1bKa1xtzSmD7Ne5y3EqlmAgHj3aaC25BIx
         OlEgHECvzeFnuWnUsXPUGMhNRFMeW3c3Wty0vLwdi9VFRpO8+PiY62tyM8Xs7lYp8tw4
         4/xxG+q09cU0z9nHT+dq6dfnsCj+Yg08inejiutuyhDCE84aCiR5Aww8quAPFoS9ueC5
         jh186M9WvfIstm1l1zNdaz0aChHCFNZcUrKVQ27uwhB9BXt9RKjyvfcfRmuDoTqsEGeZ
         gOVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVzOEgUjSrRfEX6SXhQ4nc3WxzkNhMtfkQ0ZmrMJz98GPRwK9d1OnEf5jl3wmifscUqoYMDu/StfA==@kvack.org
X-Gm-Message-State: AOJu0Yzuo+t8L3oUBwdzEi+5THi1g+w/AwImSmgvM85Db2jmZhUx+kwp
	X5TZ+jCUHbEAKJSIXz9oYmlcRmxkH1r7Qll82ilBlKDo0TgxVeoHw6twqONYv4REEALeSW/kS12
	t0LX8K8qxgg3/nJp+wYu7eWFGGG2MAfc=
X-Gm-Gg: ASbGnctCoosItSRIkrdN/FM8rlcne9DYPmBDa2xnyyjqJqeeoRisjJVX4tiU1jitzTv
	rgEHs4G8J6VwClt/XHcZ5hc5OGwWtBHAOWfhtTT8yeSjw0Yx8Q1Gto3wbLm03WuprRdLuB0WMkC
	/Qtsjmk6boguNqmv3I+m1hj+rfHJHGhFFRZ8yNOczwJ6n6hSbcftCnXRWxIE0JVIUymYAh9Y8AV
	nAFQps5IOuznP4W4jxlOnGTLD6X
X-Google-Smtp-Source: AGHT+IFDpgA15TDMxrEIdhDPUBzLl6q8kmft2wJ5V4tEM840WRm8RlBVABfwKbO7llkfJMYpVHKnB9gld3VrwW2meYE=
X-Received: by 2002:a05:6e02:440f:20b0:42f:8e88:faed with SMTP id
 e9e14a558f8ab-42f8e88fdd7mr8430765ab.7.1759938361936; Wed, 08 Oct 2025
 08:46:01 -0700 (PDT)
MIME-Version: 1.0
References: <20251003203851.43128-1-sj@kernel.org> <20251003203851.43128-2-sj@kernel.org>
In-Reply-To: <20251003203851.43128-2-sj@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 8 Oct 2025 08:45:51 -0700
X-Gm-Features: AS18NWD8AQK_m0J9OQQ2568NHQvCpLirccXoMfHk6y_3-THO678-BMip4zWDvSk
Message-ID: <CAKEwX=NOr96gbdEDJR8aTkwPfYzObEBq6W3Ow4-e8Q5k=v__MA@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm/zswap: remove unnecessary dlen writes for
 incompressible pages
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4CA761A0010
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: j986ja7954kn779sj6spn3ky13i5kxya
X-HE-Tag: 1759938363-941236
X-HE-Meta: U2FsdGVkX19wN2K0jR+NtrWMZ63y+wWA6U1W/Pp9r2GTaaKNlAB5RelKK6oCzpInk3dxWose3Sy9+qZPJS9LvPtaN1mxSOHpSDrqKLWWGmXW6jrt0lBHKMwozc0ln5xFl1a/GZyb0FKBq1/hu5PTb+PP5Q7bjzD8jl8Rhs2wceLg5wqtPQgXLuI55Ul77gzZJbKnq/rqjvfZImBLiisHfPYml2h3BnqS/VuDXGudeZF4uqCdRg0XzSTD5q7UVRonKvnMlzfP5hNGW/kMTzZK/cJCR7Vri0Yv1+7gJW7X2LG+z+T4i4SIEfZmw2AUOt49uBYZ4RBZ8q8mjd6cBozY/DiNVsq7+FsWYoX0QCtvyWJs4wBd99f9cB1ltPVLBzsf/bO9SuLxX5zS89UExrXkSO0hSgvMzNVEjtYunRjfCxGswctyLekfidY7AEzmPgu59s7MD67jD6/U7iABRuMJ4JyniSFA2yk6OZZtRUrW4RXfpn8xtEm+ub5KO2NnpUvrFxejLCFYgXLAziuztlrPu0T8KpM2u5w4fGkj1BmzB2jMoyGi84Gy8azs+n0ez1YGjWWGHuD5wbaOEjijcaNFnkYn3RATYra3Lh7k5hwOsYEbSIneU+68/xiyZTu4rAe6AoPb5kz3CWEkxsFLCv5NdnfufefMHbhcO3/NMASeS5SbE3NJRRcYxNKfrqQfI/7kFIhwSYx41wczGTFKFULsJN4/waA4WnzzuTtV+JUuZrQEdMNGhkMFucOrv/hZbmqDFhIqWQ1mTAD6Q/rL/sILg0NoMKhnbR1GGm+6rabdsvPb/x/poSRhXUFPQB8Bg0bFJBfBc4s/Dd1Lah9DZAAZ7+mNzTmkXRUA0S8U6Wac7LijxFnw2gMLxKFVsmjWA6CLbuR9cYRkpq3CJNB/KhatstLGLmaGVCrxmF7KVLsLI+kKBnHo2Rm7T7oB9pf2ahhZwfKRCUKHbpDH7FZzWUj
 1JOoLymg
 3+nVHGjyRGqgit15cSfPln1lfPoMWkR8nnSdwvJOTB1gcqCqpeeMWsbLqFa5H2yaSGjEkZ61IEMQVcIn7lvNHw9MhLoZw2BiD/rbi2LvFV3T1pzVwwsrYstnhGZZy3CjdvHljJ7w5EBZ5GWAIl/sns9E6WLa6cV4aRR+6+t2VMIp6UPcI2HmtYTh+YkeRsJhRhFiKjXdK/r7nfoymE48CnxhVIcTYyCFYPQ//b8Gp0zA44BhaSKSBncpuD0JjrT3qNetMqrOT5DB7NTm0OjG61Zi16TG6H/x7NAxdk6sUfQdK62CSWcijY/oQsl+5v9CHUOdHfHic6NRbkVjX5kC0ME23bRfFU0Ay0OcOXGJGT7VlcMCgfrrr7cPscPsffJCqEha6zSShNXobIS22j3nFHkQekg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 3, 2025 at 1:38=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote:
>
> Incompressible pages handling logic in zswap_compress() is setting
> 'dlen' as PAGE_SIZE twice.  Once before deciding whether to save the
> content as is, and once again after it is decided to save it as is.
> But the value of 'dlen' is used only if it is decided to save the
> content as is, so the first write is unnecessary.  It is not causing
> real user issues, but making code confusing to read.  Remove the
> unnecessary write operation.
>
> Signed-off-by: SeongJae Park <sj@kernel.org>

Acked-by: Nhat Pham <nphamcs@gmail.com>

