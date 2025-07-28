Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28D4DC87FC9
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 13:06:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C161A6B0093; Mon, 28 Jul 2025 09:06:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BED326B0095; Mon, 28 Jul 2025 09:06:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADBCF6B0096; Mon, 28 Jul 2025 09:06:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B83C6B0093
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 09:06:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 25B64C0251
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 13:06:56 +0000 (UTC)
X-FDA: 83713698432.14.D877878
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf01.hostedemail.com (Postfix) with ESMTP id 070A54001B
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 13:06:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="eb3/QgCY";
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753708014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e0cA9rfA0/RjVo/W7zMdajkdBMWZ2roOYs7qPdBTCbU=;
	b=PftkSTdSPKI43ob9HH9abdNv+sYiAGDEAkYmxIpuI9TLpbsXywaIgbJU80kCf4fVqQnUiN
	6MGNeg0edcDo8xH49CC7PfjugIIXB8rK2SvL6DGG3hDQDFiF2BHtidzFG8CHLrFBhk/i/H
	LlYMYpBTdjb5zphItpKmU6REnE4kFNk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753708014; a=rsa-sha256;
	cv=none;
	b=MvfoBga4b3V5HtDZHYfVHRrqmM0eYf4NWT2XEsKNVTxKTIl4cjmZdLqsVfB8fYprZIkFuX
	y5WxtaKTjtjBowNvbzCQ/kg5NawP1CztNUdG7x8BkHm4kqQ+oUfGVCtb5ow6fTYxgTAYHQ
	Y0nuo3NQrhXPsmTZf6ajhgvEfDY0M6k=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="eb3/QgCY";
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-60c9d8a169bso7023397a12.1
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 06:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1753708012; x=1754312812; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=e0cA9rfA0/RjVo/W7zMdajkdBMWZ2roOYs7qPdBTCbU=;
        b=eb3/QgCYXAY1I+WUOkeHN/o9wzok8iggeDvonWoBaWtQKEI4Oz0TFnj6XsTIbrUNeD
         BjWIspftXYWwMwUj9z67tTjBZ2FeAuLftxWa8elrCiC5vPL960oKTQwS0foEJgzmnNh9
         2vGMBLgd+VWzf+sodnEHBQ2nWoAzbp3ulzZ0BaP7auzm4h/gduRXd8PnW4vAiH7fd7zt
         but2Knr0GcNSxLcFioeZNBAPW6M1bMBGIsj8GfBFd1RG2Z9Fz0BLYsY6Xkzz2MKGhvNc
         2k4QCe1k7P5pHCmE8GthQHd8lj9bE747u7NiR5b5LEgzSU7Py/YO7769CniwihzH+8mt
         KD4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753708012; x=1754312812;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e0cA9rfA0/RjVo/W7zMdajkdBMWZ2roOYs7qPdBTCbU=;
        b=QJ06PQyMdSXgbgiwjAlOtKpgUXER1MqzRlGgw2NxahKzfgvQig68At1wMTQz1FFoS+
         x/HrGPL/T11JYy6aB9flwM7bDvHAmH4+n7uGXGj1Vmz72xVEnzXQJsDqG92teG0aKcM0
         DgxgUMkgMN5Es/BtkETQLRaFxP808QCXKLCCh9FHEkgJUA5CJzqo/sCOoWaiuGFL/D7J
         CcgulwU57V4nZ6aM+y8VYOSejyK1lggJ23Wi6seczjOCkprb8xm07JQ4udUUByxUGBf2
         gEULdqP+BCK1hIvYf3qMwy9XAfCszaU6snZfQczFh2aPzIxjNGtxgmH6DdeQagUJE+C0
         WsMA==
X-Forwarded-Encrypted: i=1; AJvYcCWIhLuBaTnQWf1UPD+L8NVAdv7OtAnGZu1oYOJieIfP9SOZsrtWhwnoMdZ+XKfkGzuSxQ5T9wr7xA==@kvack.org
X-Gm-Message-State: AOJu0YzNlIKUHriS2IdI0d38cFr7395csxPSPW3M+Yt26nUCAr8p0gGa
	cjCfJ3hZ4rJPb1g8deVqDyBQ/aj8fAjS5Ztldgo8GsHqRl0i1zEhEZuz8Q5jfWShFpw=
X-Gm-Gg: ASbGnctttKMMCw0R0MSObanmqkwMOOWDmfmcy7C8C2e/r/FMFwd9fBKq4CWzhLobW7V
	T+ZbjsZ4Lt/GJdsf15Nt5rO1G50ME97b/KCv81uGyNSgEfj7qIz/0lSuUEPW7axyx3v2heejPiP
	cgIr6dYZMLSs7HD006nBuSCwFzbavvOHnaRxmpJK9GB3lqNM3dRrrp1Hztv+t6Y6htDzQVPYSBZ
	Y42HggQhGm565tF8NP3uZANDYhEYMEqE/K9xf5svb9j2zAVWEwc2udLfr3iusEVawRY1rP38Efe
	ccsxNcfDEBK1qJ6rLuIjjMSeRRnPmybac+3d2oaMv3q7akfrHB+hwosNyUu1LjJDZfBH5N0/+FD
	VKj2TVPcobZF3jBwZSMo9xT9mC/0QsGuTnmc=
X-Google-Smtp-Source: AGHT+IG9NBHXdbyzLYH2o7xnbpc3Q/Pq7Orr4I2+N60CLFz7AZwPqB/BkF650wz8S6TPyC8dgZVLCg==
X-Received: by 2002:a05:6402:210e:b0:615:546a:932f with SMTP id 4fb4d7f45d1cf-615546a93e7mr1693570a12.18.1753708010755;
        Mon, 28 Jul 2025 06:06:50 -0700 (PDT)
Received: from localhost (109-81-20-172.rct.o2.cz. [109.81.20.172])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-6153143af17sm1824507a12.62.2025.07.28.06.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 06:06:50 -0700 (PDT)
Date: Mon, 28 Jul 2025 15:06:49 +0200
From: Michal Hocko <mhocko@suse.com>
To: Hannes Reinecke <hare@suse.de>
Cc: David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Hannes Reinecke <hare@kernel.org>
Subject: Re: [RFC] Disable auto_movable_ratio for selfhosted memmap
Message-ID: <aId16W4EaqjANtKR@tiehlicka>
References: <aIcxs2nk3RNWWbD6@localhost.localdomain>
 <aIc5XxgkbAwF6wqE@tiehlicka>
 <2f24e725-cddb-41c5-ba87-783930efb2aa@redhat.com>
 <aIc9DQ1PwsbiOQwc@tiehlicka>
 <79919ace-9cd2-4600-9615-6dc26ba19e19@redhat.com>
 <f859e5c3-7c96-4d97-a447-75070813450c@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f859e5c3-7c96-4d97-a447-75070813450c@suse.de>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 070A54001B
X-Stat-Signature: h79ou76qpccfyqy9dep6rfbqtq71depn
X-Rspam-User: 
X-HE-Tag: 1753708013-171837
X-HE-Meta: U2FsdGVkX1+Owiu8COTnEsJJRgSBdJ+A8UTUCJE+SaOvXZdGqT3hRcqa4xdYR2qkFPuhYSLCJ0wEuSHLHTAAohaegdQe2S3J285zKlEevYGaAvnIxquzC8Rn9irlQRdat4x9FfJlOfUEvHAyONjCV/YryGYC8w9ai+xzGJunJ4B4fEpxxEOytqWFuUYlTB/AojbBjEuliY8KCQlRO5AQNjIX6k5oOWmcZnCwodEALxqgIdnmFLaItXoDIBsUTnEnrv+mQTa1hozCVccWPliMl4TdqSg8IwluP4nlv8fvP+DzV0IItHxXxh5XO1YYnrZ+ggxdUwUP8pwY/tQ1MIpbKnd37V4ZfC0trEx+JDLZZXTX0Jzk2/Ypc/yrh2uDPIuxvHPQSH2on44Funetz9weXWRf8oAZmhzNAbHbSHDkQMIIFdE/Q7SkaHf/ceXVodUPiUHLzbt1qTglSn0G5IhW73oSZz8fLow3DCqUiBcoL8SvWnhzDgLw/Ectx5etTqXsHhxR47EzlkXuE4CuPc9dBJgVaflndJgzC8AWo0EtNIkdxV6VSYf2mFSYt7K0sujz+xG3Pll0j9cNpRdMPFaBVsLZiZdrwlL41c+ZBT7qw5+N3ySfs7fZhX4AqPLnCQKrOir3uHuPIpbIKxQORlO7HXHHNw16L73bfSuJeswHcbOhEaabrm6PMYKuXfJTzsYgCRBD02FSvVaQ+D9TqQddXXCGHXQ9ccO6t4YaNHTiBKuYo9Hn/I0z3xDhGUlu5A0qM7h5smyYtsRuHRF1YOaBAibs9qnz9x1fg4FIXmAFM2VmoKgLBKiEZsgCoOJ6+/VNGwrYG8b2sIZR+Wyg7aj5BY6nvKLO1AMmRCLrdeOzmbpljov9UddrVRU3Q+xr6guyzCZBP7MyQpC3F2uZE5/TdXwtxZdf4V22T9Aa1ICF4moeULKzxE+vg+59KGxqTgs8Exm43390n1Wmz9p1HQA
 njB9yCCH
 mrO61+9U9YgKyVOqQ8jDgH/AUmCU12IYWVvtAt5pCZwZRxseU0hdKcLwhvRC8twlL+f02stimawruftFcePU9b/88Ryhl/NQ/V0CMooazM6RJylaPofRtXrAPUFrzeGcs+9Po/OoiuQRPn/LDhZCP+h3VD9GjWGiwWUpxK5vom8OxKNvl/wmjY0ll1N9UYwtd8BJRQnTbc+UyasMKr7FexaHZyvEny+7U4jwqrKwOJxh23KvSjIp8JX2HpwSycrklE1GeBBGdj2G9Ha4TFu2XYlwJfkX3vaOWR16f6We/pR7CcUWxWg71YxLPm2rBYPS8WUI85UNPyWuan7RIKOYgdTFPBFiD3sX4l5CivIVSgADLtCI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 28-07-25 11:37:46, Hannes Reinecke wrote:
> On 7/28/25 11:10, David Hildenbrand wrote:
> And to make matters worse, we have two competing user-space programs:
> - udev
> - daxctl
> neither of which is (or can be made) aware of each other.
> This leads to races and/or inconsistencies.

Would it help if generic udev memory hotplug rule exclude anything that
is dax backed? Is there a way to check for that? Sorry if this is a
stupid question.

To me it sounds like daxctl should be the one to online the memory
excluseively and udev should just care about regular memory.

-- 
Michal Hocko
SUSE Labs

