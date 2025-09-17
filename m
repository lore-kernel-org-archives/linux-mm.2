Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7A24CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 13:15:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 358ED8E0007; Wed, 17 Sep 2025 09:15:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3308F8E0003; Wed, 17 Sep 2025 09:15:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F7DD8E0007; Wed, 17 Sep 2025 09:15:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A9348E0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 09:15:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C43A886B81
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:15:47 +0000 (UTC)
X-FDA: 83898789534.24.889DED1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 36D7F40008
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:15:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BQ1hpiuH;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758114945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sMaYWZd0QLs8dADNvsyko+Va2gVPuy/Cx2c1y+avoxw=;
	b=XX7fTms1/vUTlz3lLY5cenJsgK6TgVgDyt0hThux5HSTRROSylTUb5EsfvwtudCrtIcgC0
	Z+iCnJaAZrWcdaUSFH6kk6wv4QQkbDH5HNyk6mwB9/h7XMNefZxogT9JtvMlXFZ4Oc5BqQ
	E/FVqWfgYbPX8Q6ufpkkHSEP6A7Mk1o=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BQ1hpiuH;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758114945; a=rsa-sha256;
	cv=none;
	b=Eo42cTzgUPKmnbHNvqOd59y/fSht9BHw+2n8Yo3IrQ781jXgaC+ek+ZbA/aoYOSZ4nS3bh
	QWvo1mubyvdQ2L5UL3nZvCtw1PTvd86GHw5lj3gm4C0JTqr/Yh1avRl4uMC/Oo/pb7JEyo
	7OR1wNMXgSC/DgaiCQCTAr7gH4VgPq0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758114944;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=sMaYWZd0QLs8dADNvsyko+Va2gVPuy/Cx2c1y+avoxw=;
	b=BQ1hpiuH1tnZr1+gYFZth1OurXjGbv/9iZWtn/BVeullsHKa+v0p7Uhs8jKof8oSgcmgCh
	AiRMco75VFP6M7emWoyyOW4rEcTY/SNuSDnrgAZpHofyz7KwO44/XqcCT5Gt9FmR2TVZ1K
	BPt+IdLApNbl/NRlWmQhqdPQyGB9iTQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-660-nJXwU2VUNk6uxYsPA5dieg-1; Wed, 17 Sep 2025 09:15:43 -0400
X-MC-Unique: nJXwU2VUNk6uxYsPA5dieg-1
X-Mimecast-MFC-AGG-ID: nJXwU2VUNk6uxYsPA5dieg_1758114942
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45f2c1556aeso13644745e9.3
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 06:15:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758114942; x=1758719742;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sMaYWZd0QLs8dADNvsyko+Va2gVPuy/Cx2c1y+avoxw=;
        b=gqcB80N2dru+yvOj7M/cn0+sqrmA9BHgr8VPwN3aXBx9XIi7QSc7oqtmYsUp0eLR/8
         YTF5wN/z9PtN4lM4qW+csg3Wv56sR+/BqgMQha93z7VT/PH9B60eERmhjgSyXT15WWH3
         48xv2y+MbFmzvJheNm1M8aSiaWxvcJWVyuki64b0zs/F7wejQWcK65FpOgbGBN5FS6ce
         E1A9ruK5GMqtgqsPeVP9d5TMMBn3jSCCz04EY5WUEqG5sS+kERexw3+343bAtK9MiS9d
         M5M8xECnD+aOoezMfXtfZosP2p1pz7O+pKIHpBcbtVccuFc59HLbDBPKBH2RPxqBPHi3
         Ugzw==
X-Forwarded-Encrypted: i=1; AJvYcCXae6coq3B/XykSPqGYYnOKrSGeFldJb0Gr0kTMtpUt/veR1WmvtFW0ACA3NfnzU4ET8wmW0xweZg==@kvack.org
X-Gm-Message-State: AOJu0YwCNWzzoPA8AhejFnv7GNm56x5BsZQaOMK50UraOl63yN4zWwnf
	kflZJF7xtlD1dS//b96qhii6iFthgncoJHeHpvdQN/cFvMwNbLpG2a3YiJHPEfuq5kXxOdLJyd6
	+HWebpiijKU71DPzSq74Jlk0VMtgurZYjVW00HBai0uQX71hgVkcA
X-Gm-Gg: ASbGncttRlkchY/tWknEaSjk8tZbXonrjKTKzJeMROmowFlc+OkHMEpydDC5V3fX945
	qRYElNFEWJAPdIZaAj28wuwdo8PYNQrpzQNNtqAbBYE4ckzXHjhhW5ElAYTyDpaVideWK0xAkiM
	hY241NrVn1VKykubBfdMRbKdt7mf9CW/M3wBoViI+Q/FZrnJxgXcgoHlMlERJILzlsHKTbHyNxT
	m96tLrBM3DG/X5BBQ4a1gyTVCRbWc+eAnoA2gQBopT7JhNmu+8b3KtXlZIkXTd3zD9EfcWsF8Jb
	pRKMlcXagXA2CpK1WDM2M1t6Kl37TKjtLEBhHyXvfLjxZOjkI7Po08TcckH+unRzu76DwA7ofds
	NmhTXDp5UD7z0CyhFMKzJUlv4RfzE1t0w7ZX//LewRjx4xDOcxFVbAoN2tSWllGL5
X-Received: by 2002:a05:600c:190e:b0:45d:d9ca:9f8a with SMTP id 5b1f17b1804b1-46206655f96mr16892075e9.27.1758114941963;
        Wed, 17 Sep 2025 06:15:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG5Y51KOhOPin9iG2x0kvp8G6Ghirpgs3Z4uYc/yCFUHCmxcF2Vmqpp3hWYWkOPTWgVv8s0pw==
X-Received: by 2002:a05:600c:190e:b0:45d:d9ca:9f8a with SMTP id 5b1f17b1804b1-46206655f96mr16891655e9.27.1758114941524;
        Wed, 17 Sep 2025 06:15:41 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f27:6d00:7b96:afc9:83d0:5bd? (p200300d82f276d007b96afc983d005bd.dip0.t-ipconnect.de. [2003:d8:2f27:6d00:7b96:afc9:83d0:5bd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46138694957sm41910465e9.4.2025.09.17.06.15.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 06:15:40 -0700 (PDT)
Message-ID: <26e38fe5-e6c4-4678-8056-95c0ff4350e6@redhat.com>
Date: Wed, 17 Sep 2025 15:15:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] selftests/mm: Added fork inheritance test for
 ksm_merging_pages counter
To: Donet Tom <donettom@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Wei Yang <richard.weiyang@gmail.com>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
References: <cover.1757946863.git.donettom@linux.ibm.com>
 <f07c901d4b6b1d1c15a8c1bbd324367d6135d0a3.1757946863.git.donettom@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <f07c901d4b6b1d1c15a8c1bbd324367d6135d0a3.1757946863.git.donettom@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YJbDpU3BXPMYVq3Gzt8sNBppI7YdmGfjY43BLU2rAUY_1758114942
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 36D7F40008
X-Stat-Signature: k9y5ikwwxzgu5645rjaqu55s3b3mtred
X-HE-Tag: 1758114945-179825
X-HE-Meta: U2FsdGVkX1+APSIi+Dec2L8rkXwknFTl7ps7b9dW+B+krMkFsHHU0QmDBz/3VNSsUMYaO1FsQvL3lVFhbGs/XSnXulVbR65eUjInzlT5zI5FQIOM/Hh7q9xkk3utn0FLfBWbJsH8xFqkQGZ5zBpiP9mWxbHDOhEZRI5nhyfdiO5PhU5kokSq076mG7YRi2HG/coCog0I15kqaHCZL+/0iZsOe74/Ca+tdltP7vrrC5mzAWSBedIQ/C22d21bk8cO7lY2/IwYtfDmvXkzKsT+x1hmxOiinZFtwq1JR6caL8rPxi2TbMhpKWxHRpBS0BlFda0Fyp7X8wZQBDRhcKNQ4ORchFfH2oFbMxIvYlPT3md97KETFDTV+E8iisQB6AGCQmJOqbTxm1Kvw+LnpiEUUH5vJyFPZqAX6DfLzE0BJkWoX+Yji/vvbm7BE0epmFZVpHyKJnpsDTU9KnP3kQ3SWGRt7Nf51gs3qsZMI3K9Lca873plEi3pXnyHKatKQgcwiZ18TWoDQFhO0x6s62uXld8UdsMlpvgVCzhgqjp56EweqVBVSJY+fMqCIDXcqcvxF3NZ5kd/KcF6E1I6n3oUxkePcsazD38R4rsPoG+0jcguOKPYuOVUq/kaxEDT+yV3zMbCqx+GIr0gsRDYvH1eP3JgiWJVp+VJnU1yNqTUdKCb9FpCMzoSu4XG46irZ/e2TSzMeltUSzOi1Czn3sU1/pwgkXSJXZWwbKPtaV6A6Ic9vy/Cfmjz+Q2hX8xWgkn/+0sIlRtAm8tHA0TnMtAsE+IPKew3SyZ9nAKk+jIcuUz7m8RHfE53GgTnO6/XRvm9e8VFfBEAmh9ehkm+zgkaFlUgDNJyYR2WTuN6Mxm7aS176qCnl3AO8J35LuHUJcnyVBH263IkimYrCGjDD0ry3Pr9JgJ4NvKckT02fJxBXCB2tlXbVfQR7dTrmc7aTyir9RuH92I/H+pBlr9gH9O
 DRFo9iiO
 o8CWIcMv7DrL3Sc83dRHJ+6mA4o3gTzs2xiH6ztvMQl+BdbDPSRL6fE+mzOBIpra/b9l8jRQg4ug6RiXAXtZ5iRRzH+/mCpGds80UMRJF0sOmRjTkS+Ej0wT5+ozmcxpbK12aemd0qFzjgR8TD1x+5Gdcme+1rpUgqRmnGR0n95QT2b27LpM43n+NNYh6CWBsWsz5nLOhpAy69KL5H+umwuKy4jwmuf8yeGS9AaM0YA9z/Ir8bISJ5vfib+9WMjPP14SkAT+On4Ha7c1opQP0TSs5AOTdj6hOhyAcMAkXwk0VE7hfz9UC0iq+votlyGrqgR9b/lUQAkAEYjdx+6FUxAb4hBuvq5eWKBHp4YuA/OB3qYyN50EMcoS9lDpjhgNenUYa8nWMpQsj/svCMRerUdvy2I15YYnKAmO64Te9hSWabX7ftmVCgj8shIQyIoZp88xMTmfMrC24WTcJkOYMZIBRUg1W/nTBFNpZUVupR7nGJuKNY3lepBiJXfiBrGIUuQai52R1THItJfWTI0SJu+Ov6R2yeZmxQRSD/6g5oWLKGEeSQJHAKxzMLA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.09.25 17:03, Donet Tom wrote:
> Added a new selftest to verify whether the `ksm_merging_pages` counter
> in `mm_struct` is not inherited by a child process after fork. This helps
> ensure correctness of KSM accounting across process creation.
> 
> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
> ---
>   .../selftests/mm/ksm_functional_tests.c       | 42 ++++++++++++++++++-
>   1 file changed, 41 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
> index 712f43c87736..645cefba2126 100644
> --- a/tools/testing/selftests/mm/ksm_functional_tests.c
> +++ b/tools/testing/selftests/mm/ksm_functional_tests.c
> @@ -602,6 +602,45 @@ static void test_prot_none(void)
>   	munmap(map, size);
>   }
>   
> +static void test_fork_ksm_merging_page_count(void)
> +{
> +	const unsigned int size = 2 * MiB;
> +	char *map;
> +	pid_t child_pid;
> +	int status;
> +
> +	ksft_print_msg("[RUN] %s\n", __func__);
> +
> +	map = mmap_and_merge_range(0xcf, size, PROT_READ | PROT_WRITE, KSM_MERGE_MADVISE);
> +	if (map == MAP_FAILED)
> +		return;
> +
> +	child_pid = fork();
> +	if (!child_pid) {
> +		init_global_file_handles();
> +		exit(ksm_get_self_merging_pages());
> +	} else if (child_pid < 0) {
> +		ksft_test_result_fail("fork() failed\n");
> +		return;

Probably
	goto out;

in all these fail cases

> +	}
> +
> +	if (waitpid(child_pid, &status, 0) < 0) {
> +		ksft_test_result_fail("waitpid() failed\n");
> +		return;
> +	}
> +
> +	status = WEXITSTATUS(status);
> +	if (status) {
> +		ksft_test_result_fail("ksm_merging_page in child: %d\n", status);
> +		return;
> +	}
> +
> +	ksft_test_result_pass("ksm_merging_pages is not inherited after fork\n");
> +

And have

	out:

here

With that:

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


