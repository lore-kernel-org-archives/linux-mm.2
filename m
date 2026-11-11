Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08AEF606A336
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 18:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZQglmIQG
Received: by kanga.kvack.org (Postfix)
	id C94726B05B3; Wed, 11 Nov 2026 13:07:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C44F66B05B5; Wed, 11 Nov 2026 13:07:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B35796B05B6; Wed, 11 Nov 2026 13:07:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7BB376B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:07:04 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E0A29160379
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:07:03 +0000 (UTC)
X-FDA: 85423619526.04.A5E6432
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf28.hostedemail.com (Postfix) with ESMTP id F121EC0015
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:07:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ZQglmIQG;
	spf=pass (imf28.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794420422;
	b=XqtCZdu3cdOM2e70GmHgqOq31YdOdqPLs6JBrmoKAaO8bBGBmq+Dk6p3tlyTNtMSYR6IXg
	Eury/djSwYMDjhryBhs40gAMtMuUpFGNyB2CbXmCdegvLJF5CAl6OBjS9EZFjZXTFZvdWF
	utVI+XcU6V4OYo5GJ+hrVsXeEnribR8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ZQglmIQG;
	spf=pass (imf28.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794420422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5EkQQnjmN4v5cLrBthc4MAXsVOryIg+2+wQmH6Hq2Yc=;
	b=qVBReMtTqa3uwbHq/ooohtyiL1ce41K61TlFQovJOrcrs3hrfDf2MzIxYpSLzRiZ0NXH9i
	XokrKx9WKpGJ0X67NQ/A6vCLUccrMvCfFQg3Redupxmb2Uw941Kp3JQHGAidk2h0osBoRY
	wnHVswFcftp3L4vfOXOeM+db0MJCHjw=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48fd2e38825so2079414f8f.2
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:07:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794420420; x=1795025220; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5EkQQnjmN4v5cLrBthc4MAXsVOryIg+2+wQmH6Hq2Yc=;
        b=ZQglmIQG3d71sFi/Cznqwzuparb27HOvLLv3fuq/SKDvaZXr5X1l8Uzvg8xNBqrNs1
         nRjSryZ771mxsOcxOzFzCdPFAbv1w5zqt4GN1C3Rd/YlQ4Qt/F8fXBn0XA5ROcJUyPsl
         IH9UyCuJQvU3g7GWRpNQtEyUoF6sMZLhZPgox86KBndKTOjLddQ168WzTmH9qp4jZF+F
         rFBzoqr5XQrk89ZEtTftTUUHd3R6KmWAfoXdD1aNVT9W0lWr9mDP0LptQMRGc1wpYPNp
         94RnTr7CaEpL3VY9sh/txUwex6JJHWpCLRRX1eQzUDtnTn/kR2FeHk2IGPYTKxA1Okcx
         BgXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794420420; x=1795025220;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5EkQQnjmN4v5cLrBthc4MAXsVOryIg+2+wQmH6Hq2Yc=;
        b=ylzRLpcacDFXt6uFNgSqOF9Y3dak+6hd8qcV0P8S8Vzo2THZudruWr7KnsRaufQNhe
         wyhcTB2RsrCuZC9ZirsHLNVnTnOTJS17id6GskM9DRP4UgGuzyTxCr9oVc39XWqJAyMv
         kORitPqhLtz8Mde1TVdI8ON0ptPI6jlRzOAKHIp21Jg273x3F69hcukGtGNw6XW2F48g
         1TQHIvd7/9yiLBU9SSlLs0i+HCh4qz+ztH+Rmk4nQ6/KIJtwdaPt5Hth2usN7qMGNoWL
         AkvVz+KRQBLJ6jvDL70aPyC1RL9Kl1TDVO6QDvNgg9Ryg1+7whyg0LanE+WC4+3BL8a6
         sUeQ==
X-Forwarded-Encrypted: i=1; AL+hErFaQzUmv5/rCL/BUd1TVIsPPqlAHMTzDSEdHsIKyrPmn2+NmmHNOv1SZu/q1ZUcBDJlMerLgUmrSQ==@kvack.org
X-Gm-Message-State: APuU4Z+lHOXoZTHk/ZfWJFKuwz2EVrKMKQGuLu+5BoBfIvIhLoFPjEZc
	dvemQlyE4+zotaYxbghsfUd6qt6PiMC6K2tqtGaVv8vkObwHLiZxsQIr
X-Gm-Gg: AYBFou3QxHXwq40dRKSCvfSQBV7ipV36QSih9NyDqkbX8SeTKuuddDirmVJU4HYS5yX
	oimoyLFRFUKU7D4Xfhe0/EvI4neJmq8FuL7XfgcUA8pFse5s8+qsN/f3wL+FEI9foaNJ03wYpND
	QgIqZk+1fpG5haaoe6Ruhtyi6i6LP6ibGYBn6ggAoshhVEOtcG1cGITjzphaFX0aS/37m3l5seH
	8TQJJbBh5DCViStOEPvznQvWdZ6UOY8H7LbXeRfNJg9UZPnDy+nR6+1yaoOatoss+unsHL/Fw4c
	eTuWubM8YyccQwwamXQBwqp9v7mmf+ROV65cQ5Ejou8oTOECafiZtAOwUYhhoEl+uHsVcylCdzI
	73K/EBUdLc0zKJNpv9j5zkpM9/C+V95XyH9q6jWbS7FZpJfcrpgwX6dy7o3k0YaOx7Gmd/fi8fN
	IlenC9VVdqBsayoBKALoenUJcQSm/KizQIYI370tiIhhP6UZr0wmzIXCkSbExGoIsQ2U/Kv3Rsw
	ozGSiWUfEEvNyJT+CYhknNXqbFlt/ANhzLH6G0QYCDThEYwPMzPx5DK6IxAIbJHvWqW/RfDehc8
	+fepn2TL4o9m/C+sCU1/Qim77QsK+gE4YWSEkdm7QHke9CLda4itYT2IYcDUvF06FMHbHPW8aXQ
	8HxHVvSHUfuSMPA==
X-Received: by 2002:a05:6000:230d:b0:48e:3cec:b852 with SMTP id ffacd0b85a97d-499c7087c01mr6407400f8f.40.1794420420284;
        Wed, 11 Nov 2026 10:07:00 -0800 (PST)
Received: from [172.31.15.113] (6.red-83-60-147.dynamicip.rima-tde.net. [83.60.147.6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-498365cbbe5sm13633793f8f.42.2026.11.11.10.06.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 10:06:59 -0800 (PST)
Message-ID: <f782318f-5ecc-47a4-9bcd-98b7aa696731@gmail.com>
Date: Wed, 11 Nov 2026 19:06:58 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] hugetlbfs: report inode limits without a memory
 subpool
To: Hungyu Lin <dennylin0707@gmail.com>, muchun.song@linux.dev
Cc: osalvador@suse.de, david@kernel.org, akpm@linux-foundation.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, jm5905938@gmail.com
References: <20261111130145.96534-1-dennylin0707@gmail.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261111130145.96534-1-dennylin0707@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9aibxuyhsu3rne8s1dnzwiews6w7sxbg
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F121EC0015
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794420421-11808
X-HE-Meta: U2FsdGVkX18x0JCQjfB2JlURfq2TsD442pZi7CxqRWGslXCsPHgY9yk+mjOomm6ZbmEn36uuBHr6Fh0xGVZMaeQRENyFatWx5RThlOg3mmo3hiSzCWGyDJhbkEA0btz9UDrHn6ZAgMwaUCa8Ct1SLiR+K5mzbxVOhpFlW/jPJtVciYMuA1PSBJ80wTk7v/duK5+H9yNM1P7Hen/KSFFnm1tn3wazuyQI2i0AZ+vEDZ/zhOt98SfecZjgWig6BZsXCtg/yZSYkGNBq+Q3MakuoXiEtM+kbHKtWhF97CbYiFZKgcv9aHLcoNcbKjU+14+hz62XzAEeGREEkG20DtgH4RsE7nRmoQdBm0zzVY6WrJl149EuMNWOgqjqgvnrB279j9HDgFtsUv/Di3Jnz0e0h7BsYvD+E0Xf4dcCh3PwHtOz8vn8ooUd4KeJaLbXCWbRJnAtbP38E70VA4tjxdrKSN5LA2ysM2UgEstaPvGKTlDImzqxuFSiWIOd0CtY+Gh6waC8AqnJY7YItpHTqqd7cMitjhxjbyCZYAhPtQlvxNb+7EvL7C3lvnQBeSxV78uBp2L1k9AgPK431s+16p3M9XFY9xHpoPNehsl+y5rP3mmZ7eqkmB3oKqjE+bOIy5frDdkpBRxPInKYUV1y4vIzYsfKGdlABqxY29yeIr4Jf10+3torWNgFXQiy+ETJJVlJqZCUvh8ByRq0vOnvr2moNiOWdO0/qeGYGQG523YDOo/p1hzJJI24QRReTgsydC1Wm5O6du8jW6mvZMYc/KUqL4fR2EXdd2ktpkExeQet3kT5iZcJ2p7No1SVNuRY5wj6SbTeSgsQQeboxEjDEW3AKeBYfYeH7Ns5Z2roThThaVPOxily/O/gQCpbnKSib02eyri6ujhMJdKn/aMgug/Wy7ODhJ4C/XpD/mWCVccX3AikRNvRDnKU02qo5WKZGxkkDxjlU2EwSqLjNcaopo8
 VF3+/CAr
 W+Hd5BExhXOmXg1jqanY0gB7KxRaIi8wHFx7oNlaivPywZHk7EprISxucY1AvXuh+Cfzmp6PxOVYUCj44udCkYaJUJUvbm9++oys8tqYu5iiExstsT/kuTakp6ItHq8OGpkwtZZvgOUUEffgmeD1BihViTn/aGGzT08tZO4FJOUMpKIqoGjNqPDnJj9MJt56I9Gk3hukWPIjlCtaEb4uJ3JVemhtfv9ak8K71qMsoE2DrwIkC8wVcQ27p2++yDohpxL0ohOiApQUShk+4lwAc7i2hq66RgOCpcnXcCqgCrP88cRCkl9TuIhtAj2izorAyddn4aawMO/mp5QlPZ0x9EhMbw9ew/MjfJ/RjeJxB4+sMqLTcxF8KpQuJNMA/csNVjk5FkCcQWWHQtuChcH9fPiaPWvIdfGTVMzZvXUJW9IG9PeSUiYpoMg83BmiubXe3t0Ve1Q8oHIWzxynK3DCgPYeoqVf8OMeIqtIzoFZMBlZPs5InWSf81tmywA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 2:01 PM, Hungyu Lin wrote:
> A hugetlbfs mount can limit inodes with nr_inodes independently of size
> or min_size. hugetlbfs_statfs() only fills f_files and f_ffree when a
> memory subpool exists, so an inode-only limit is enforced but its inode
> counts are reported as zero.
> 
> For example, a fresh mount with nr_inodes=4 reports zero total and free
> inodes instead of 4 and 3. This hides the inode limit from tools such
> as df -i, even when creating another file fails with ENOSPC.
> 
> Report the inode counters when an inode limit is configured,
> independently of the memory subpool. Preserve the existing zero and -1
> results for unlimited inode counts.
> 
> Fixes: 74a8a65c5261 ("[PATCH] Fix hugetlbfs_statfs() reporting of block limits")
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
> Reviewed-by: Aveline Noir <jm5905938@gmail.com>
> Tested-by: Aveline Noir <jm5905938@gmail.com>

LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

