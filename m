Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80BE5EC1101
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 16:01:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEC2C6B0093; Mon, 23 Feb 2026 11:01:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCA0F6B0095; Mon, 23 Feb 2026 11:01:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE0276B0096; Mon, 23 Feb 2026 11:01:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B89866B0093
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:01:09 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5E9D6139C3D
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:01:09 +0000 (UTC)
X-FDA: 84476185458.12.5D15D8A
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	by imf16.hostedemail.com (Postfix) with ESMTP id EEB7118000F
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:01:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=baylibre-com.20230601.gappssmtp.com header.s=20230601 header.b=aJNhMFPM;
	spf=pass (imf16.hostedemail.com: domain of dlechner@baylibre.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=dlechner@baylibre.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771862467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HX29uEwlmShEjfFqkdwl8Eb5l/ZDj+DL2kVuvz05S4k=;
	b=uSADTc3LWrK1pRcY7IPjrqEov+jICtZNkQn7OQQToE6EC7OTh1AiT47netMpQR5/0QPnTt
	2YwPTzRdSwbQqqBpFwg+ZSGVr9bVWLQG3fU81XtuOANNqFx/UzbSVTMJXZnClRjgXLIyWY
	tJQxg0DuJ2zSP+ZMGMG+FJc8eNWU/gY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=baylibre-com.20230601.gappssmtp.com header.s=20230601 header.b=aJNhMFPM;
	spf=pass (imf16.hostedemail.com: domain of dlechner@baylibre.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=dlechner@baylibre.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771862467; a=rsa-sha256;
	cv=none;
	b=v89eMMSQFuSt7Jy0LOX2LCyjHr1J0DAn711g5p7rymPjQ5uYXMbfLm+GfvAe7v3fti9CfK
	ZaHmderQqshJLrybEIhGer8MZeUxBJvzUsbU9by3968XfMwJmw/NYz+GrrGLqmXcZgjw4e
	oGcezqRcG+oJ/uSPRhxkAd3yhI1LjD8=
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7d1890f7ee4so2720433a34.0
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 08:01:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1771862466; x=1772467266; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HX29uEwlmShEjfFqkdwl8Eb5l/ZDj+DL2kVuvz05S4k=;
        b=aJNhMFPM4uy9ls+QNf9VmW3+27kh1vhLsKYHRfqTDwNMrOSuIIe7n3WedgoQJ8ibQz
         7/dL9kU4MWg2P28+/5XK1OfoNeF5IDUEfI7wEjHmBSPPB760y91BS0aaimP7Bp8FaNPN
         oAskhA1B6IGKoC2o5VHU2F8v2KZbpn1P6XjkJ6srYpC+lAJirtZhAONNZD5ULTUAOEz7
         IiYuUkYJeHzl+A8hyuQYkO7AVoJZ+bLeXsOwGOvZfd8OItNVDWpPwvGfCZmWd9qSSYH9
         +FACNh3dRP8LmGAewJqUxmWwmRasxO7gTI1QNigDIHC3t55MBK6ZuqvjvDQEJgHRR+fb
         cpFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771862466; x=1772467266;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HX29uEwlmShEjfFqkdwl8Eb5l/ZDj+DL2kVuvz05S4k=;
        b=WNQr5ohhi5Twt+LP+HJCfd55lmTSoLEqQ9SgSrF3FcAfJb+Zd23/DIDiyYaGKSPr1A
         gufdJhOUaWr3qpb4H/CWACrvnzs08MVmpGlzQ+0qYqeWp5aP+eQw0fYt7axyo0R6HwtS
         NZSSvXGFlCqYdCTztSw5jOS7067IuHVcY6937yJTWm4JLtZB/fS5AWdQE6Z+2W8W89yJ
         8r/xMAEQAuVwaaPTBAGmf8vgdgg+KGdPnVXXC1wVhXK4GQ1KQ5GzjslQrqhyKrl3mP7p
         zXCULrh0B67iMW4ANXZ7+Q/fR86Pxpgf7S0ubqjPm2J9B7U0JSryol3lPhY20yb4ILVR
         +LPw==
X-Forwarded-Encrypted: i=1; AJvYcCVEVeJaPROUaQB6CyEbmyDFE+l051iULrUMYCJjibCN3E6tjjTH1kynmHwXaIAY0aqPh6+VCd2zxQ==@kvack.org
X-Gm-Message-State: AOJu0YzSNVnU2vZuBCf0Stui8jrd9sUDS+AAVroyUlWlk9ORksKg32wj
	ipymcgfelgbN9Nk3O8wsP5nXxApuYq74GMfQlTygZi2yxLhvi8Qn6V4AuyAf53hnelk=
X-Gm-Gg: AZuq6aJ1P2wM2Hb34xuWIpiFsyJq76wTJTYKvDsKqXW6FyyUJKBlaD9Poxyfi73Ev/n
	Ygm8Z/xOlqyrbUO88PRMAGP/uO7set402edPj6ZMfrnh+KjvJS0ZfcA4rcgITPCHYOqFMvOm/NL
	LbXng+iGSqbN/Qga8RsRtdukKgGvsD55+Kio3jdlEh+ipqk3uiNi2zmp0msJ+ql6NbXIbvsJxsS
	NKr/x/IKU6H1VccgfKylSkrdKt7Yu8cRiC7q8eNSWOQwSo2xa08gHgkg64lukBwqtAnBiaDqKXv
	MKe+RwveyyRVWmxAK6PypWJi1DJDEsBlyJ/YhLpz2Vsc2NbgoqHz7y6jkrOB0eHeynXUf7cCvwC
	ta9fQQLbSxjTa1rpcEFQOlwcjUS3t+dMaCiObKIDsMojxKncDnZ7y4drMTst6HMptTwEZV0dQvI
	/bj4J/uqYoNankLcyLyCR/EosYPPmQyScTu0nyKI4LeBgbZtaoaSQCPIccxJkOclz+8rcl4MHef
	quRcqPtcQ==
X-Received: by 2002:a05:6830:3153:b0:7d1:853c:83e3 with SMTP id 46e09a7af769-7d52bdf416bmr6177467a34.2.1771862465520;
        Mon, 23 Feb 2026 08:01:05 -0800 (PST)
Received: from ?IPV6:2600:8803:e7e4:500:e37:2309:3937:4469? ([2600:8803:e7e4:500:e37:2309:3937:4469])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d55b9a8498sm1062950a34.28.2026.02.23.08.01.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Feb 2026 08:01:05 -0800 (PST)
Message-ID: <47be2ff3-c25a-4aab-89fc-53921af8b0a9@baylibre.com>
Date: Mon, 23 Feb 2026 10:01:03 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/33] mm: vmstat: Prepare to protect against concurrent
 isolated cpuset change
To: Frederic Weisbecker <frederic@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Bjorn Helgaas <bhelgaas@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chen Ridong <chenridong@huawei.com>, Danilo Krummrich <dakr@kernel.org>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Gabriele Monaco <gmonaco@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
 Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>,
 Marco Crivellari <marco.crivellari@suse.com>, Michal Hocko
 <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 Paolo Abeni <pabeni@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Phil Auld <pauld@redhat.com>, "Rafael J . Wysocki" <rafael@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Simon Horman <horms@kernel.org>,
 Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
 Will Deacon <will@kernel.org>, cgroups@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org, netdev@vger.kernel.org
References: <20260101221359.22298-1-frederic@kernel.org>
 <20260101221359.22298-5-frederic@kernel.org>
Content-Language: en-US
From: David Lechner <dlechner@baylibre.com>
In-Reply-To: <20260101221359.22298-5-frederic@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EEB7118000F
X-Stat-Signature: 19fbeojottkf4de1ygza7fmsdmznnng9
X-HE-Tag: 1771862466-424992
X-HE-Meta: U2FsdGVkX19OowKyppRrWCvT4zFUlimd9qwOGsMFAtFJ8CMcmFfSG+fJP1UZxD6zbGoiXdExtZZogIvfYB655/Woztr+q55OI6lpqGeDOjaIhWneT1Kuf6e3Y53+x+TUbS4r06U5zidT3UiVvZDHD0WsOSO8p3mW8q2VCodttp5kRG2+lQliW2B9MOSYihIqxpkLS7ysnZjv7CXDlHQWMZ/63Aga7q3hdxLH5Y4vALBTK+CXf42e3GWJAKakaePkXII9rTjBTgkdjCxKSAQdQ9i5gt/FgGyO3sSglsEjeLGaKQqLat8RipMPcOiMGXENNb8xA60IzI/qeyPgyiKwogwvVNWFSnRblG21Uva3c3s83KM8fImKr3+PhODNLzZCV+6HxzC8dnzSU2F0shrx7hq87T8uSDEIcM/DQPGgSQGxS5njAaYQ3gkY9W217zmQ1oZYSy2U0vBGmL2fHtrQvtWe3Gkv+oQBG+Zg9WAd7pZwd67663DfTZ+HEuWEpuIiDkMwyda/bvL0R+Ycx1Gco8QH6jArLEm7GRFnwhOlH79jFMyLcl8GatKDSuAEWPf9vpOvXi6j+pUiDnBVn8+40CCdLQmBd7mqswsUpE3JoqP8sx5PuGTFlRA01SbkuSFI65mqGBozeWI0sgApuktjJGKwDa0x0TlU9rwX44pgxcCpk53VLB00OjCnhSNkodQ/TvGxxdalUeD3UAzAslOUwGKz6zNGBNMuB+IsWM1GlCpgaPqEGYqpd5hiXvktf0cjBOO/ggLvzSiyLhuDJiDGIG6HcgoAQc9IxxmLs251zHmQp7ynGr39t+IocdSc0VxUaUPiXcKrno2OcUC0cCEZg7G1ush+CTdPWHI/uwSRMBAQNsrJUaVDTvnuzcAAlaqxzg+H4apRvl7ir3ibpaYUDXrKM8EEkyXzlvVeHlg9aGqOeeQeJv0diQO51AdR8woytV5XE467VBTF9z37SDe
 ky0iE4Rg
 lQe+9RwiDR8VwyhNJQ7qKQHPjfEsRhPmQA4eHzUycrVNBTY6i8KJehhxEsbcI9atZH/Wd6M/pYPkCG0aK4iKEmhMeQlh4xrWUxEytlQcQo/C9CdUIUdkzOx8+eVXB/xpjVeyvCUpW333kYMrp5QKhd/6PQFt793dCHyCKRnc+jhy31eU/ktUiOHeUrEYrLZnj0qi6x1D1suAnid4qgNEcxQ4aZ/q9/qh/BVP4ideEIqvc/kNWncwZx/+I9MuRQj2aFDO77FrVviTMpjX7cO2/oDmKsO7rpDspwEKNhoXMOOhxNq4BBnPcSFpMrebkCz1DC5NWgmCHyRI2MIfgFyF6kYAr0HHrAzu7SN/XPhITAkCAxEsbJ8XcwnqOZNHKuDCQNCfFNj1Y7jmkx8E4kiy9cfC6oVn7nQWyoCH31vHuAa2K3teH7bVnrN4aL6JUz+bGWVEPx6TSh7QYfUouUtkWD0UP6Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/1/26 4:13 PM, Frederic Weisbecker wrote:
> The HK_TYPE_DOMAIN housekeeping cpumask will soon be made modifiable at
> runtime. In order to synchronize against vmstat workqueue to make sure
> that no asynchronous vmstat work is pending or executing on a newly made
> isolated CPU, target and queue a vmstat work under the same RCU read
> side critical section.
> 
> Whenever housekeeping will update the HK_TYPE_DOMAIN cpumask, a vmstat
> workqueue flush will also be issued in a further change to make sure
> that no work remains pending after a CPU has been made isolated.
> 
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> ---
>  mm/vmstat.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 65de88cdf40e..ed19c0d42de6 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -2144,11 +2144,13 @@ static void vmstat_shepherd(struct work_struct *w)
>  		 * infrastructure ever noticing. Skip regular flushing from vmstat_shepherd
>  		 * for all isolated CPUs to avoid interference with the isolated workload.
>  		 */
> -		if (cpu_is_isolated(cpu))
> -			continue;
> +		scoped_guard(rcu) {
> +			if (cpu_is_isolated(cpu))
> +				continue;

I think this might have introduced a bug - or at least an unintentional change
in the program flow.

scoped_guard() is implemented using a for loop. Now this continue statement will
only exit the scoped_guard() scope rather than continuing the outer for loop. This
means that cond_resched() will be called when it previously was not.

>  
> -		if (!delayed_work_pending(dw) && need_update(cpu))
> -			queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
> +			if (!delayed_work_pending(dw) && need_update(cpu))
> +				queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
> +		}
>  
>  		cond_resched();
>  	}


