Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A623CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 11:42:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 974286B00F6; Wed, 27 Aug 2025 07:42:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FC7B6B00F7; Wed, 27 Aug 2025 07:42:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79EA26B00F8; Wed, 27 Aug 2025 07:42:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24B696B00F6
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:41:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9671A1605BA
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:41:43 +0000 (UTC)
X-FDA: 83822347686.23.39DF856
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1659A4000A
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:41:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ECpororY;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756294901; a=rsa-sha256;
	cv=none;
	b=CQ1FPkZ1OzmjTNqmkqEBQv7KIu/vikl+/21YCndAyQ+yHVZD4qHCop7RjI6IXTUi7K5GaL
	+s8E1K3Yqu364T2fnErD7REvkVzhXWaz7/Qt90ZgOfHIzNLzZS9EZT7TPqAkqGmmucDoz9
	xv1KyQClSJXF3QQyFMFHvXCRLiwbn90=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ECpororY;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756294901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HV/xZcVuFLtiCGviUqTx61DCXk4F4wUkVDUlnEBoh2w=;
	b=g3xCd4ms6iR0mYtYV0NKHV9ulkwzHZS4yfcmbO7jyDOZ+SwLbQZ7vW5Xw44MVD8f0MM6s7
	OzB+tN1rYrbn51vPM6XpB7vHlkIk+hpamcr3xPBxRsXFkaE90ZTzXLzvikqmdIenpQgcSo
	92PpzaMOqNdu4vtvVVTYSY8PXzfWCCA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756294900;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HV/xZcVuFLtiCGviUqTx61DCXk4F4wUkVDUlnEBoh2w=;
	b=ECpororYtXtGU301sX4LlnSal0+IE0gXxzRTdR8c/pB7Hq2y0L3i+4Ie+iU5LAEpbocl+n
	K4mAwNyIXvW3WQ2fI5LOWuUyIB20M8qcMGcgpt6NDA0XHXScl/ZOn1y+YHJeXrcdnO95Vu
	e1HItWKPm0LPPWCMtYaAR4em4g+9lQo=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-462-HSU4zqRuNlahyVSRxyFOWw-1; Wed, 27 Aug 2025 07:41:39 -0400
X-MC-Unique: HSU4zqRuNlahyVSRxyFOWw-1
X-Mimecast-MFC-AGG-ID: HSU4zqRuNlahyVSRxyFOWw_1756294899
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-70dd4405514so47988096d6.1
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 04:41:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756294899; x=1756899699;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HV/xZcVuFLtiCGviUqTx61DCXk4F4wUkVDUlnEBoh2w=;
        b=Kzj0ApenPZTrgzmbmYp6CKCvLAkugt9lMlhBujQsmnmZPoMik2pfyhSZqStTLxeTyZ
         OitmA9rtBh/WRv7WXd3cyI6Rx6pnMM1IsQtOao0unxVW1QDp4SDgXo7wyVccBYISrlAA
         jG+ESy4vRA+JStjHYfoNJJqR+uJN26J7PljxNwOZ+GYV5MLxYJxT6T9lxVRqfRDDuP6T
         b7Iu5YIFsE/CzAb7ecM1+HKcdrm24H5ItEbfAbnA8tT56+mpNuUKHovBnHJUyqFZovmD
         Hmp9jmW13f9k0jsfhdZJXmDzqPeADCKkI4qH5cuJKss6KccAYDcvtq4nZi6B3pnVgtVA
         XunQ==
X-Forwarded-Encrypted: i=1; AJvYcCUxuQB3ZlnIn+GRkN9L7GIe3a5aEmj4Y6zK/0wXRdtxklbg73AvIMSVBZDy1AneqagPqiRIHujPIQ==@kvack.org
X-Gm-Message-State: AOJu0YyPbltBncrz2YhBrWv5bhryGvvR1ADE9AzroKotQbL3cHfsCrQh
	OeGXQqrs+Poif8AYCg5qoxlWrPmQ8jZn5RFgkXdB0Eb0hW3lIzaSOl8LInk9ewJgDXkPzNNeYG0
	fb731A+BO1cxEnANUEVZitp43Shw4JQSGq2vYSqYpWJos9O/ETXPpdh0K1mw+nAl3EA==
X-Gm-Gg: ASbGnctTT0c7mSKt0tRomraaiaxn60uAWmD0YDQS1aSkADkF0aPKVe5SRq+3hOyisJS
	3G/Am2F6j4dXqca/gvErzQuNwK4hd8s4JvfDqil1a42aCxq/6jCN8UMpYIxPHOL3byMuflfXifh
	N6/ya9kYvV8NV/37AKXC6Z7aIKmdpfSYknpk3wNKgYSHyIz0iwPaBqYpjMnzI+eCKK0kXOLTJPL
	31Hiz74lK2xDUGTGM6OfzXKNcGqAViL/QUj4RnXqBNP185GQyqJKNMl/N/t/IQ3vsfHBi2Eaaov
	Upjl8vLovweD3OSkAJOAutBkgrVh/DwneCI2Ax4nMktMkBccpGElTpXKhz7okg==
X-Received: by 2002:a05:6214:29c6:b0:70d:c4cf:66dd with SMTP id 6a1803df08f44-70dc4cf67ebmr95365646d6.20.1756294898605;
        Wed, 27 Aug 2025 04:41:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGoqMNOquK0NnYEjbH/c3aLrCrIDjWCu+uWNdYZocRBUoCUrVCE1pSdaq0vI+MQ/KgHE4I+OA==
X-Received: by 2002:a05:6214:29c6:b0:70d:c4cf:66dd with SMTP id 6a1803df08f44-70dc4cf67ebmr95365266d6.20.1756294898028;
        Wed, 27 Aug 2025 04:41:38 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70dde332f06sm14730336d6.38.2025.08.27.04.41.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 04:41:37 -0700 (PDT)
Message-ID: <87956f34-e6b0-4d03-b30e-56be4f6b84f1@redhat.com>
Date: Wed, 27 Aug 2025 13:41:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] selftests/mm: fix hugepages cleanup too early
To: Chunyu Hu <chuhu@redhat.com>, akpm@linux-foundation.org,
 shuah@kernel.org, linux-mm@kvack.org
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com
References: <20250827075209.2347015-1-chuhu@redhat.com>
 <20250827075209.2347015-2-chuhu@redhat.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250827075209.2347015-2-chuhu@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5WKUQP-cZWYl-qfgtPpI8WGTeusY57xXQRhf3C8ifWU_1756294899
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1659A4000A
X-Stat-Signature: d3k14f7cb64gs944ofa7jkbothmko6bf
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756294900-232957
X-HE-Meta: U2FsdGVkX1+9BCXCS75VhNBAct7bPDucoT3dfuTTZ3WndvLMKapsjQ2L/FcezUBAGkyxyGs7O2sSgpyw6CWhwxUVIy6t33J5PptAas1sv6y/aciF8sprnBQbY033esSTNAee+qI7+1fvWDbZSQp3uHqNukcPA25iSj+LoldmTpPa1HIbZ6FtShlSxpo63iEEMpekmAwJD+MtkoE1MhwYhuvP+9IJUpAnc+5JQ7be5YnGDo+WUTCPhVg103DMGnaclJW5fPUTr8c5qMiryLhuX4L51H66zp/KhYZh/JZm79ywK8yeMC8KDWX5nbiJ28gOOnb9E2wCPiWHBFKgUTOPxvCNH5jL4G4gHOzhHiMqP9goa/YSS+adzcjswjF+d6dxikmO7t+mz2kuM8Hkkechf+MxV9q29mBvqT7rR9TQYDR+9m+VXKB35pTxcOT57t35mDKLFKb0mLC0g7cnopE43i3yXL1b3Bu/yOLzwk/hgIwyuf8aaITr2Onxpr8pPRry9OCN3QBYRCP039IPcf6AN9KzrSOPiRdlJR1QKDudyn0CpwWqyLhjpzEAp8ghGIU3z+NyQWlKsNQSfdt32/VuYSlt6LzPMDBMovG7snrGLghbdW6lykVz3d+M8CB9ReW7iKCoTQB2D1mEwF4CTgfraS/vbxpsdrFuJsUlwNo6HTKfQaXzZOki60b1lVfrpOP8+nlAaDXFDU+GED3PRsGvCcpvonsGvoq5jMN+hn20hpwztWSLXQvs9vLnQy2d+IYOPyvzMwxNFx6qCrCVNxoZvtFGU4kqfo1jqGExcFyN8Wk7ZPglR2f/C0xDXB+tEoPEpHTRtn/rISnMVJ+OO8d7Sa81SW5xGprOV8kiuCYtnfH44A7HmV513wjduAlmON/23i8bFDZY8CogXu+m8hqfkk8Df/h7OHgpV3ftUBn+xOhQ67ygD08a8801uwV3YEW2EpWIm5xnN8uvY3UNIt1
 YqN7+zdj
 ijyHf0TrIlDf+A2VhDidDMZEsJjLYB5QnLSitQ4ruOvRZjvmZQCtTtY87fuyULf5ywR1bILYo43pJlt+kprhpfoHrOzuz3BcBO241NVHwMedj1Omu9bjWQCW/r+ArdiqGSFxRT0zLQ13dn5oZsTSfkdMNQ3WSaOjImt9/IA3VBj81Z9dzgEr68gt8HttejV2q8EEogJJYByxk8VO4CKVWXWuTdkWbkPzLmeRAONW5ASxXQY6gWplrXvZqwWv4b1Vl+aYhmb0YMl+hK6XBtfvHiiRN023wqwHT4HMJN4gddjwpAd4I2m46m8/E2ylyISEHi8N8o4Wjqxq2hwAuLe3S42lZv95coFRBp7ew7jwia6WIBAEsOMBXkg4OUkf2weB1Etydrhs3yzaH8lRDyeRXSjFxUEsdTReGUsjo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.08.25 09:52, Chunyu Hu wrote:
> The nr_hugepgs variable is used to keep the original nr_hugepages at the
> hugepage setup step at test beginning. After userfaultfd test, a cleaup is
> executed, both /sys/kernel/mm/hugepages/hugepages-*/nr_hugepages and
> /proc/sys//vm/nr_hugepages are reset to 'original' value before userfaultfd
> test starts.
> 
> Issue here is the value used to restore /proc/sys/vm/nr_hugepages is
> nr_hugepgs which is the initial value before the vm_runtests.sh runs, not
> the value before userfaultfd test starts. 'va_high_addr_swith.sh' tests
> runs after that will possibly see no hugepages available for test, and got
> EINVAL when mmap(HUGETLB), making the result invalid.
> 
> And before pkey tests, nr_hugepgs is changed to be used as a temp variable
> to save nr_hugepages before pkey test, and restore it after pkey tests
> finish. The original nr_hugepages value is not tracked anymore, so no way
> to restore it after all tests finish.
> 
> Add a new variable nr_hugepgs_origin to save the original nr_hugepages, and
> and restore it to nr_hugepages after all tests finish. And change to use
> the nr_hugepgs variable to save the /proc/sys/vm/nr_hugeages after hugepage
> setup, it's also the value before userfaultfd test starts, and the correct
> value to be restored after userfaultfd finishes. The va_high_addr_switch.sh
> broken will be resolved.
> 
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> ---
>   tools/testing/selftests/mm/run_vmtests.sh | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index 471e539d82b8..f1a7ad3ec6a7 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -172,13 +172,13 @@ fi
>   
>   # set proper nr_hugepages
>   if [ -n "$freepgs" ] && [ -n "$hpgsize_KB" ]; then
> -	nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
> +	nr_hugepgs_origin=$(cat /proc/sys/vm/nr_hugepages)

I'd call this "orig_nr_hugepgs".

But it's a shame that the naming is then out of sync with nr_size_hugepgs?


>   	needpgs=$((needmem_KB / hpgsize_KB))
>   	tries=2
>   	while [ "$tries" -gt 0 ] && [ "$freepgs" -lt "$needpgs" ]; do
>   		lackpgs=$((needpgs - freepgs))
>   		echo 3 > /proc/sys/vm/drop_caches
> -		if ! echo $((lackpgs + nr_hugepgs)) > /proc/sys/vm/nr_hugepages; then
> +		if ! echo $((lackpgs + nr_hugepgs_origin)) > /proc/sys/vm/nr_hugepages; then
>   			echo "Please run this test as root"
>   			exit $ksft_skip
>   		fi
> @@ -189,6 +189,7 @@ if [ -n "$freepgs" ] && [ -n "$hpgsize_KB" ]; then
>   		done < /proc/meminfo
>   		tries=$((tries - 1))
>   	done
> +	nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
>   	if [ "$freepgs" -lt "$needpgs" ]; then
>   		printf "Not enough huge pages available (%d < %d)\n" \
>   		       "$freepgs" "$needpgs"
> @@ -532,6 +533,10 @@ CATEGORY="page_frag" run_test ./test_page_frag.sh aligned
>   
>   CATEGORY="page_frag" run_test ./test_page_frag.sh nonaligned
>   
> +if [ "${HAVE_HUGEPAGES}" = 1 ]; then
> +	echo "$nr_hugepgs_origin" > /proc/sys/vm/nr_hugepages
> +fi

FWIW, I think the tests should maybe be doing that 
(save+configure+restore) themselves, like we do with THP settings through.

thp_save_settings()
thp_write_settings()

and friends.

This is not really something run_vmtests.sh should bother with.

A bigger rework, though ...

-- 
Cheers

David / dhildenb


