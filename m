Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E590C44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 22:12:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 396756B00CF; Fri, 10 Jul 2026 18:12:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36DA76B00D0; Fri, 10 Jul 2026 18:12:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AB466B00D1; Fri, 10 Jul 2026 18:12:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F27E76B00CF
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:12:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 73A50169831
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 22:12:26 +0000 (UTC)
X-FDA: 84974266692.22.9AB0A17
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id CB65B16000D
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 22:12:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VJe81GYb;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783721544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2wQB/oFYBFS3GQeSmu/3oRAdk1WgygnNAOd7kwV5jaQ=;
	b=cl846ciYqEP5xa59VjqMJkYB5dJddsZD9oXaTpRNFwT0iZianDYffTQTCpGbpt52qP9fCI
	N9OMmy5PQ2jU9CsFPdDv/Hoi9TYjaR/3s8RDw+UBlERcJPTEzSuOwU0xSw7JfuvK/IDnLM
	1HIk+euVOlKsfi/IgMyNtX567SJo4O4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VJe81GYb;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783721544;
	b=uTHPEVRFPXSxQT2ikFjnQkaKg+12LBp7UWEDxSTKcjFz4RPYseEQh+YI7gNdNixSNp807L
	zSqIK54l21pwMyoQ1EjUv9iuvTXiwrs6o5WT22gHeQeEbkwmgfx8HCOxiD3F+KysBM+T8o
	nmQ1AyuUgaNTEFPu/eNSngGqFy2s9BA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 454966111A;
	Fri, 10 Jul 2026 22:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32471F000E9;
	Fri, 10 Jul 2026 22:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783721544;
	bh=2wQB/oFYBFS3GQeSmu/3oRAdk1WgygnNAOd7kwV5jaQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=VJe81GYbWd6zLU/0Oy3lq6fNYK/xvVwqq20qidN2/oL2icncQaYqK1Fe+uvqBiFrT
	 IBcwSe/+HNIab8r7fGPOpavS+7+qhyYVJipwSJrqT9iWJDM6ku4YDxNdGO4WQA2ORB
	 9VskKFPVtZ6W0Ang1vDmufbj4+l2UBAJGLgWU3LE=
Date: Fri, 10 Jul 2026 15:12:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, corbet@lwn.net,
 dakr@kernel.org, david@kernel.org, decui@microsoft.com,
 haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org, kys@microsoft.com,
 leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com, ljs@kernel.org,
 longli@microsoft.com, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
 vbabka@kernel.org, wei.liu@kernel.org, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v8 5/8] drm/nouveau: Use
 hmm_range_fault_unlocked_timeout() for SVM faults
Message-Id: <20260710151222.ddb35eab9c81a8720491464a@linux-foundation.org>
In-Reply-To: <178371881847.900500.8789369230260725500.stgit@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
	<178371881847.900500.8789369230260725500.stgit@skinsburskii>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CB65B16000D
X-Stat-Signature: k1uukmja1rbcftgew4ud1x3duwpm4adm
X-Rspam-User: 
X-HE-Tag: 1783721544-381292
X-HE-Meta: U2FsdGVkX19Ao13uyDP4GovLuvy/SNex1Yk82SfpJ2vbSQK7EQgGNV7RdeE4MVQ7dB8PIQgpTpNJX/YZ99FXzf0+ah9J+3dfeeM7n6CFYm/GL6J5dGIrCZ5dqx4tANQxOvOqk9L587O/6ehH6T56kdL7weqT1psJFADNqP944hL4Ic4fgk+0C5nEgAT9XnbARjH9OjJgB8qYAeSleTs+//YLEwhFcTRMpP8fVJaQtBkzoi0S5Kn9lCFvRKO1L3dIYVpQc18Aic1U57Y54Wh9MiY71lqdnXWFu8hJ8Unz2IXL9Xl+5cmCVD0XKQQoQPYhhj7GpqoAokSH0XkdElZaZNykaBDK/3roH5arpAVoee83d1IxTCEmxcjbJgCie1uI8Q6VT4/lj45iMdLyNr7dplzUNq1kj/YH7z3+xkqW5XuXCbaoHaTLlSUqaa/MYfaG+jZzZHy+GSdC0kKUDX4dU1Z73OnsL/YtV5BBhdDWCVAv4z4FwBataV42i+2Kuu60OHS6gK3ooL2DfqhpQ5zXIWC2gxb2L1FM2/OXt9RfEQ3SelPU2TFo45cMdrgDarWgaD3NGDtkSJPugNSdlXsnH3WGlyO+kUXd3CTVE7YRCQQQ+X4yO/iUan+Ig/jgQZCSawlwchPcpm4nELqg6mp0qL/ZPMBBRZiVw3fhn3QTuDcE9z/Dh1OsikWDTFp7Ru56NzvWtXaRbEBjdJiWIUPz8Vv9whTtzKytMrPz6/KAcdcDRuyzWcJfG0lwZZlErrn1tw/XCLRTYMbhoUOaElzc4N/Ah2doxthWI1U+0aFXIMgPrgK6DXX/PUabQJbINBxRY5DNXj1t6odWXIY/CWkEArXiNGNCchucujHN/utAhjaYrcWbKymcA9XFIaY4T6iAIegP9H7AweQhn8e53wEfh78JvaKwssSvOS80awvA8C6LNfCpfbgoZmj3w6Ucd/3ONNzNUp8iXXXf8XeJVpJ
 v0hdIdkd
 8fmzyLExpL/Duz+Hs66wuunELMlaIQ0PRYAjOCxYmfH2kKSWSktuCzN5Smmu3CmzEfJa0Aubfu0xZhHuQGwkTd8BKu4lPgP1NesWkZVB7Ipwx/Nuuv4wQlQA81IWvMSMOBO3EOCveX6k4CnDuYPnpE25wExCEgWsqZSPI7RCBgj3oToFSqdpWDms8OZtWV2j8BMX3jVvtJk94uJbMDFQrCITwNTV4+ldXy6UF/sTUkKL/kzBzwOFrU/DLJE88RYfeQhfB3Fd2K3hVbfWCexXNJhB8dUax9DUK4q7JJ2DoQ2MdWWwk0XTOqoKfdqtLpJJdVNJG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 14:26:58 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> @@ -683,15 +683,11 @@ static int nouveau_range_fault(struct nouveau_svmm *svmm,
>  			goto out;
>  		}
>  
> -		range.notifier_seq = mmu_interval_read_begin(range.notifier);
> -		mmap_read_lock(mm);
> -		ret = hmm_range_fault(&range);
> -		mmap_read_unlock(mm);
> -		if (ret) {
> -			if (ret == -EBUSY)
> -				continue;
> +		ret = hmm_range_fault_unlocked_timeout(&range,
> +						       max(timeout - jiffies,
> +							   1L));

"1UL" here?  I'd have expected min() to warn, as it likes to do.

