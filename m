Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0597C47BCF
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 09:26:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F6E46B0088; Tue,  6 Jan 2026 04:26:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A46B6B008A; Tue,  6 Jan 2026 04:26:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B1536B0093; Tue,  6 Jan 2026 04:26:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 763016B0088
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 04:26:51 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 223B31B350
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 09:26:51 +0000 (UTC)
X-FDA: 84301009422.04.EC96CAC
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf23.hostedemail.com (Postfix) with ESMTP id 06E56140002
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 09:26:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bnkm0IHA;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767691609; a=rsa-sha256;
	cv=none;
	b=tUddVZ3KGjKz/2yCDxpCo9kHqy6sbFW9gsVUtSY8BjI47s95DP0nYdkTAlpswxYjT+gbot
	9Oe6DZhq1sO5niYGY/E0fei1Nkas79ARGOuH5NS88zTF53XmkGB1UfExzUnqBE8YHwE/TZ
	dj372WYzTanbUWBkIy7oVuGDkk3yAYU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bnkm0IHA;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767691609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ThahM5kzCyF/bcf5aqITnXQU9yOqrJhpyOse64okuuA=;
	b=iGbnwp0D4S1DwztlQvyKf7/XfkSMPlLETXGUFLTzgdZs4IhMH01KI7HcuFxbcG0GuJNfSn
	Pi1MunXjilowqNjEOo7xxG++OXZSDBPgTFALZ4io0GmJHpYJc0iDTA3OBRQe0VTR3XfB7N
	AE8OKZlUTGh3hj+dK4ku7iF8k4Qshoc=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-47d3ffa6720so7217425e9.0
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 01:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767691607; x=1768296407; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ThahM5kzCyF/bcf5aqITnXQU9yOqrJhpyOse64okuuA=;
        b=bnkm0IHAPZ7isXMY2Iozm4TthnxNbjyOUhRU8G8TAxVzINJY/MfDdmnsJaxIEoGUgW
         nuIJ1OMraSU1+xzCekqEz8j7PPQkv0mf+RkFdVt7hR34RC8Yc5m5vOEltxOiLf3htIO4
         EjLnJQAwh4+ZisWohYfbzNSQ4W8pG+1zSk9CMQUJKDo+m7geDEZiBMKohl9vE8442pf4
         F6XSA+c40+83Judy2aNtIF7/SwxmMciSabrmIoykM7HqDfpa8G2B5O1AfayuVeYsiEUG
         BtP/b4DgqfcdQmI3+E1lTpGFz6/MiwdNd+saSTlBnTJhmVOzE7OLVXpEx1Pxzzm5gTwf
         FWnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767691607; x=1768296407;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ThahM5kzCyF/bcf5aqITnXQU9yOqrJhpyOse64okuuA=;
        b=D+/m14YLZzBjEmaGyN5HQO006vn+WgVE/RrwJ+O7+hlATnCjNexRjBDv28h0fJwcOt
         4lF/n0HhOWVrVUQYePJl0PHW5MDhTv0+h/n76iG5I9Av9VMXi9HgkQNHq909Bsbu8uSJ
         zWQgLN6/VuWqK6CgN7+kZR0UbffmZwVzZQMMyYChi4/4uVeJLmEgIItubO0KMOyE2BNX
         snbrLR3MyPB0fycxMep6YoRzr1UFJxIDakqXtsLK51O7G9qucR5nuvKi8gQk7xc3u+3j
         1Z/iUVTzyhC2K2bF9fsjKn38KjFHqdZomAaK1ZRjNB5E3kSIYuj/C/k0MFkPOlDnN+pD
         hGtQ==
X-Forwarded-Encrypted: i=1; AJvYcCVEVBPSRPw4wf4PNPZh+LCWlFjGCj7m+O7/IJalgv3SweGr+opplAWt6EOLO+fn03KS2mcclefb6A==@kvack.org
X-Gm-Message-State: AOJu0YyC183cwh5OUOmI7FeUSOoeqFuv3aOVf3HkFDOQSW9mzuw+dHup
	Cf4kL6A7bYusgOM/weYmETTo3o5AoIlM1MAN9Hgj11avPpXC5PHr4s89R+oEISG70Pw=
X-Gm-Gg: AY/fxX7QeREnaWG0WLgbP3THF6bolr8qv+9vmOXkjUOqCtH0DhSajQXiYx5p+L7haEC
	IhrqOh1RTfiBTzgeLRQalqwWcAkVEkZbfnkBo5IEG/sz54Pw1tOfklAB3djZ7K1jxGSE64/niOS
	472iWkxpGEgMPhsJ4gatCqNjsJEHbE+CzDTYcpwyEewd5VjW15SShTskEfAhPg2RILwN4wxBqeI
	F29BpVV4DR1f7v+S+CO3GZiWIwXCQPSmDkK+hO1eqxxQ4EKzDr4zc+Gwfhjbms8AFOl8+O5ZizG
	OW67+X71OUh3ngGQ2tYufbMW/M+a+CrXJCxG1vAiwGszUmyG9gK/QqWR4JGoDFKEW5VXj4wnbdD
	GMbvbMrS/j5HXhcTDPvXNr8nCIIs31bg5CEssplSJNQVzkVaL8AetmtePsB7L9G+EUXYzmUBwVq
	7qWOBYax23kaRJnN92rRWKX6V6
X-Google-Smtp-Source: AGHT+IFA2sUx7cpb1VtQXR82cWPP/ZiEyOCYDZLzHkQtueqm0gxbr/csKzRMDLoxbmlB7+GJ3HwwMw==
X-Received: by 2002:a05:600c:190e:b0:47d:3ead:7440 with SMTP id 5b1f17b1804b1-47d7f0a3534mr25549885e9.32.1767691607267;
        Tue, 06 Jan 2026 01:26:47 -0800 (PST)
Received: from localhost (109-81-90-116.rct.o2.cz. [109.81.90.116])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5ee5eesm3259137f8f.34.2026.01.06.01.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 01:26:46 -0800 (PST)
Date: Tue, 6 Jan 2026 10:26:45 +0100
From: Michal Hocko <mhocko@suse.com>
To: =?utf-8?B?bWluZ3podS53YW5nKOeOi+aYjuePoCk=?= <mingzhu.wang@transsion.com>
Cc: "kees@kernel.org" <kees@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"david@redhat.com" <david@redhat.com>,
	"dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>,
	"mgorman@suse.de" <mgorman@suse.de>,
	"vbabka@suse.cz" <vbabka@suse.cz>,
	"rppt@kernel.org" <rppt@kernel.org>,
	"surenb@google.com" <surenb@google.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Jiazi Li <jqqlijiazi@gmail.com>
Subject: Re: [PATCH RESEND] kernel/fork: Update obsolete use_mm references to
 kthread_use_mm
Message-ID: <aVzVVTS3gjtz4XNB@tiehlicka>
References: <KUZPR04MB89656F6F10537974E46766E08F87A@KUZPR04MB8965.apcprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <KUZPR04MB89656F6F10537974E46766E08F87A@KUZPR04MB8965.apcprd04.prod.outlook.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 06E56140002
X-Rspamd-Server: rspam10
X-Stat-Signature: 4wtbdhu3pd64eburpus5fa5k1jgptmn9
X-HE-Tag: 1767691608-375848
X-HE-Meta: U2FsdGVkX19YadeiNbsVTRGYQuXedOQOYlh0pkfTZZk+wMOkekuW9rIQAzpIaCDGr6sO3gXKP5K6jWKEe3VODWRl5urEyInJenfQqSpxGDyCSBFwzoOwQUXgYSQBUTNOxjQZ8NMU7nurIByk7R4gVBojJd62fluA06mVJw7umLuZdUvjpwDCq0afPP330qsW1KQ23hIsactveyB4WK7FqdoXseJ6E6ohW4M/N6gyqrUH/K8qvUZJCpH+G40IfKyLJP6hwx19Lw5pbxCq2Q//dMLEYODFRbGY9ynGAswCPm/wH3RxEKXfgTKU/6UYukFKIfRfwBubUyYJEO7uvyKJDuBsDlfDeQMhkrpQ7wVF6FmFJw82CmXD+y328nOMaltpw9jbmzHsW5zjJfaC7CvawJ27t5wp3+11NJLDk+NqoHmakrOvsBWTtlLtWb32bx9HEVp2IDjC9LoJ/wuCJXG08/yvF+rgwHHd18+Q/zw89FCn8BWeeA6+Nd8F6NvDlYfU6hPIk7AoApL0drbvYszLPul7u9vsIz42lJ9h3eQfTIyJWcL2bQjtrrkTRyHQuFbPk+nqT6XlRuQQFdSsWkZsO6/w/L/v9c4isZpcBQp2x4rZs73yS45IMwSOwHr4apvcn4e1TP9S4c/vrYQMxFj2E1nV8L/1UweqD9rpaweZXOVfEwbbKL0ccgL5VPiWhb2bj3qBBsqJTulwyrS1m5IinYAD6Z3e+j77Ko1ERZhALjFfHjUUMkyh9DDwzWdrgZXkG7izbOH6WNVMWCr7nE9E8kzeq8+BCsz09t1YxHOFHHt7/O+B3Ddc7csUebx7Azy5hJP220OuFQS99g42aVmZmPdRCNQGb/fk5Cf9PatneiFM5YQgtmm3N7oIl8myuvxWmSoesZHe2e+aba2yAfgmK8xKvOvV4obvqihusV0Reu1ZFHCocFE03Z9geit6U79f4FSGaT73+WHpkduT16Y
 d8xUxGTP
 HDdZFPLTFbcd3JhQhuPXxkSV+SMZYKiSNm1yrQywQsi6+PTi6hPn4EpzqZwaMDb+XBWwX+7LDW4bKUdeEWN5CkI0YuTai83Hy6G/jtmVvzvYtElvqx5twW6CErjDJIlo7nfuemZ54gh67n48eCrBgVYk86Mqjbq21UDkjZxbWVSRidxEGFXHrIgHP7kkjqHgBoEzvikcX9v7OLKmI4Oyzs4+vBXBRKmp4OGN3nT0JLlhDq2/3m/S7M9KR+Yg2Z7Z+XKVwLv2w31MXvllBIRj9wXZ5/C88r6fZ5kb8VeT/5wIgFqLUbUzOy2F7qDWsFjnvdlVgW46OGNdRX0nDL1BjC1I87HxfRpNaucpuhpehTaTYSRWfDlNWIZtnX2Anz9vd/Fjfhc8itIQuofJJHOumuzaQtiDROZaTH4NYjV5wqG3AQ947ddvXbY0c/X0TMIzhVtLi7ION71H4+Xuq/Nx3IlfMwDVT6wmg0tTi49r3fIF6bG8SwYDw/KC761wXKA8nSXtNwfWtbDE3KAaXp3z3r+LET1qzPUUoVkGfUnnRN8wn3/kT9GlBuCwhFQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 06-01-26 07:05:28, mingzhu.wang(王明珠) wrote:
> The comment for get_task_mm() in kernel/fork.c incorrectly references the deprecated function `use_mm()`, which has been renamed to `kthread_use_mm()` in kernel/kthread.c.
> This patch updates the documentation to reflect the current function names, ensuring accuracy when developers refer to the kernel thread memory context API.
> No functional changes were introduced.
> 
> Signed-off-by: mingzhu.wang <mingzhu.wang@transsion.com>
> ---
>  kernel/fork.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c index c4ada32598bd..64e228c541bc 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1312,7 +1312,7 @@ struct file *get_task_exe_file(struct task_struct *task)
>   * @task: The task.
>   *
>   * Returns %NULL if the task has no mm.  Checks PF_KTHREAD (meaning
> - * this kernel workthread has transiently adopted a user mm with use_mm,
> + * this kernel workthread has transiently adopted a user mm with 
> + kthread_use_mm,

Please do not wrap the line here.

>   * to do its AIO) is not set and if so returns a reference to it, after
>   * bumping up the use count.  User must release the mm via mmput()
>   * after use.  Typically used by /proc and ptrace.
> --
> 2.34.1

-- 
Michal Hocko
SUSE Labs

