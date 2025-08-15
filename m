Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E1C4CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 06:43:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A249F8E01D9; Fri, 15 Aug 2025 02:43:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FD198E0002; Fri, 15 Aug 2025 02:43:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EAF88E01D9; Fri, 15 Aug 2025 02:43:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7C9B98E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:43:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2FA69138AF7
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 06:43:31 +0000 (UTC)
X-FDA: 83778050622.01.93B3BFC
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf30.hostedemail.com (Postfix) with ESMTP id 357C08000B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 06:43:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lT7bPXpf;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755240209;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RQ+FKPOPxHYzBg0qRiV9WQnD66XSjRAhVwtd58VUZ+w=;
	b=jBVHiWZfFcNF40j9Dq4AVbichuCjy0QriAuKMCfjuQ8yFIUuyiVeh2fIALk4ypAsI2wtjf
	ZIYkQFgBvT8saA+2WF7t9UMtJrr4dAaDp+F9EZKkuxe/ZyQu5RIyd0X48mqEpatdwJUyg5
	eKfntytZ29XWEKanYqEUD6c2BQHC3nY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lT7bPXpf;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755240209; a=rsa-sha256;
	cv=none;
	b=fWRGHuygbSGmSF3kLXJFuvsmdw0igzHB4HOygBRdATpVwDRtZbuZzBo7CV9Mzp0211Isfk
	JMOfzHH3zXQFxjQtR/W7RzDHkLSF7rouf7vNhQIyfvsgM9vpPTlyv1Wp145Vszz8diwjIa
	36e9ImG3tshJJi+qEJxb7CEhWW78Kng=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6188b73e6ddso3520180a12.3
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 23:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755240208; x=1755845008; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RQ+FKPOPxHYzBg0qRiV9WQnD66XSjRAhVwtd58VUZ+w=;
        b=lT7bPXpfWcm/frhNmYrjp5CQwPbOWghpKBMxXEcfg4F6LuJM/w2K/CFJM6X1WPUbQ9
         ZzknYlyEZuKV+l2X1sq3aRE5O0HbP73tnjFy77ggVLnL04YnknErQM+V8lFI7WWNlbnk
         PVOma2e7U9t+UrhlF8RycPe83IpAJIt58n/oY09X6wseTdeADIKjp9E8FobKiMtXGPIa
         RKe0e75/fQi/W3WEEGxugzLl8F75puVqKlYgcxJPxUjp7d0sVrRENHrTlER8q9LALWDu
         S/DElc//hu0C0rpLPePhZNH9YXBWwBtsvg2PMzVTqDHuo1U85ZFJw6m3HsxIan9mls5b
         6AQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755240208; x=1755845008;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RQ+FKPOPxHYzBg0qRiV9WQnD66XSjRAhVwtd58VUZ+w=;
        b=FNG1tDR8ZtpesTZ482xr1LIgWvWISFpFkAvNeQdRrJjccQWRfTHYI2ftx8uqDN7rxn
         0z5NiA5iONOO0XZCrptIed1T9CA4K3qEWZ1m5omuJnF4buglh5LQ4ommLRzrV0Mq/UKq
         Js0CO053YDQhwgO14l004jVaryYbNT0FN1qnLCSvW5TO6wOWQGQ3Uu7S+RcNlGM59r7c
         wHRPZIELKeoP47/mS7Naja73rh8DwhLJq94Dow5LNdHbspYL+dZ1ue8Pl1+XLPhiGqVL
         +knfuv5YqaQxxc3dr6WqDH62Tvmib64fhXPX/3QQhx6zpYK16ZgRh2DnJxpmPuYiHX9J
         897w==
X-Forwarded-Encrypted: i=1; AJvYcCVosPf1Dj1v+qPG4Fv5HOWOAFnGganj53Nrwq13vi4FpenPVUo/q8VhtfqsVLAvL/CjMaHTkw8GmQ==@kvack.org
X-Gm-Message-State: AOJu0YxKSE5Y6uIwWcjfxOpIYdNafoAKzksV8igDncwTDHchtosTGff1
	yvQLI4iGLPK2KAYnHFRk6p8ZTiqD/FuV+l8U4jZ2ZCST28LAjmFBPkBD
X-Gm-Gg: ASbGncv8wZ33NyouMebtw+OiNe+8+SIOkds0karRVRtA7MqYm4OK9lU/K/3QJbPjyWV
	8VWv7Ho4Hbmmtx53WEKftJkNh748834Jntx9iBDo5w5koj2MsiodASVxX6GkZfg7WjJaUt0tqBZ
	nIAuNaeKysHRTVwe3DxPR33cJKMUPmAMfpiXzdm9aDb9UUlVgLgYM0su2Fn7eCx0oCsXwTMX/H5
	NWrpN5AF7qVeR8A+91C2tPFG8tr5HJZh0O+zgHimLPaUL/Xf1deQ2BX5O3pBSq1/j3QYFdZDHMB
	Cnl1qgiapiytFmgYFtCtmyhW/96163tWU5BkkwqIhqgInyL1IiBlFSNqgRHiUKqniU/WE/zCB3H
	Rtf8/kWZz3+dVHc+n7DFw3Q==
X-Google-Smtp-Source: AGHT+IGPFk4+EoYus2GiJezFDslbVAG50BHI7St5CSnh5npe7++NmJQ+qpasnKnRTuGEMgD6zS98Qw==
X-Received: by 2002:a05:6402:2713:b0:618:1485:3749 with SMTP id 4fb4d7f45d1cf-618b056089fmr728966a12.18.1755240207429;
        Thu, 14 Aug 2025 23:43:27 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-618b01b5facsm727726a12.41.2025.08.14.23.43.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 14 Aug 2025 23:43:27 -0700 (PDT)
Date: Fri, 15 Aug 2025 06:43:26 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Ye Liu <liuye@kylinos.cn>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/page_alloc: simplify lowmem_reserve max calculation
Message-ID: <20250815064326.itngdnefuoihlk2j@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250815024509.37900-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250815024509.37900-1-ye.liu@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: ny4tz8acjjchb43y7oukekuu9ea63p6k
X-Rspam-User: 
X-Rspamd-Queue-Id: 357C08000B
X-Rspamd-Server: rspam05
X-HE-Tag: 1755240208-798696
X-HE-Meta: U2FsdGVkX19Apg1XwcGQ8GYLstg/lf7iGG1fcb8mwfzjq3hTTlvdpQb4cKqgmwFDY/kbuG5womcGiyBNJiESwb6rkUVOI6fDt+XMXjmKdL7oSkqHaUZiPb5cBnqAivPP8drTohd2Dni5i6Us0Yk7shsD0LkBOZMomQYwEg/9H4BcFb3v2bcoLoXoRmPhWm6APijWkApZbUsdWyEU7cCA8ZJeToxQCXSbEI+iXC9b/5bhjMFvH6c5XciIW8DoXQTw5IPsNjc711g9nuFb6gwqP+BPc7IuZ57fwdZ7fa2fqgS2msiAPDS+ssyLTnzA0+farVP1zEUDQR0rjHUkB0qPF9nU8D5IDpiQ6aMASUTY4mdgV4naSRaf+M8sz+5j8aeUmb9EewWj1mXoA76LHucw99GSIwqJhuhZHCQRvqMj8RL3rpWUGLB+RTQxXSCMVqR34t12C94pp8EVUnP36FV2BZzG+4gsJKK0vYFr55ZbH6cOSN5NSlwvqA2lzG6PCIvc0wPaasmzEf7uxQxpU8Godgr19wuWP7XmMMABmP4pkL8uXIjhqQ7pRMTxlNnkaiZ7Ejd0p5JKoxQ0RsDP8GfbFYdyKCfnGHEkX1baf8/w1uMKimm8Pe2FH+thRWfry02R0/svCZybFp/SNLkwtNFOeXLscnNmj6Kxg6fNxmvoEWELqCfXAHDyoK6I5MuQXyzMVNe90X/97Afvri8cDUw51uwHr/XwhOUijHI7eSXq81uaiKGtlmVlO3whCcSXslgF8+heZ0PDJmQUyoil2ml8ClcPGF4NhI7oq4FWRUqZYJo8SN0zc7hwo3w4QmeEH9l90ZPw/1Ilo2N850zSWhZeduTC9KpsSuEXZTpY0q9h27au3fLkVrBqM+OVsGUWgedDAs7aUHPe1+KR2jkfB3UexZcFah6o8ZhXIE7QsjrCZte6OFE9ZIwW5VmQT2vZOraDbm4qrZPnZBwMwdWXt37
 gRETYqsF
 uejJBfrmgyJJRgWm0Y5GkkQCrn+m7cw0RC0kT20d28mqyBm5STFknBgEGtFZgnIqmfwEBKHQMfl1jgat0cnPDvZ0JtkjdIeKopR438arZlT9bx0oNjgciO7Zs0zFwoiImuoJqCHtIaHU1BY3ZjHNU3jwu0+VnbgDcMWNkAkMBTd99YrR9c2Zd9ziOAnUygxaqxQBhVsetpUMR8XemE5jTBlpB+NNHiRW+mt2MRZtfEjFodxSefmP4mOmbaP+DKsTgjDTyqabbyU1lmr73YLK3EK9H6wtjTXw15c64WnH/2/4teG5ofmC5L+X5F/ngCsJd6ITXfxSfI3oFEBKOqwhQxayzv7iLQbrZPcsS9EHgOBuZVPTdbdj99+gFQKoBe5V6hMRQqfW3JKX8h7z7PNOONIMEMkgVHw7Eyec5XMKTthUj4HmVCS9qBrB72VL8/EK2j5KtvL3BErsY6AgilMy9WjHISmznnVlpG7Rg+NCbZxIJmukzHHUz2mPYLMLgrzRwQfys84od69DJnv2uWNHOVVBwTVsR0aC153ndhN74QOdylDm4Z3yZ3uIaFgP9wz0DL1EoxtGbBC0NFnQ8LWcc19mjeeKuBN0x/igcLXsBzsCPauzJR5HUmwH7p9Cosza6EaaPA4DxkO8oEL4KsTTvOv60qnvsb2MFkEimjI0EJ3m5+U/D0Kt2DR/Lzdl3Rm610HGqJ0nVsMTHhqivF9sR20RKdi89YNx0pg2y0mBSZ4aYjmMw07vXvgYcxlCGsYbXVsWY4wepLQbZg95C77yxiGXeIQK/pWIlZ3DE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 10:45:09AM +0800, Ye Liu wrote:
>From: Ye Liu <liuye@kylinos.cn>
>
>Use max() to find the maximum lowmem_reserve value and min_t() to
>cap it to managed_pages in calculate_totalreserve_pages(), instead
>of open-coding the comparisons. No functional change.
>
>Signed-off-by: Ye Liu <liuye@kylinos.cn>
>Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>Acked-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

