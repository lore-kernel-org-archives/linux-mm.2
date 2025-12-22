Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 954A6E6748D
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 10:06:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 054AB6B0088; Mon, 22 Dec 2025 05:06:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 002D36B0089; Mon, 22 Dec 2025 05:06:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E50A56B008A; Mon, 22 Dec 2025 05:06:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D2C756B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 05:06:09 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 87678BCA3F
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 10:06:09 +0000 (UTC)
X-FDA: 84246676458.26.8864ED4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id F3B2F8000C
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 10:06:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HI38sG+t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766397968; a=rsa-sha256;
	cv=none;
	b=FrkuGhdmfz2Wu9Lloq6Ch1ljzCBjtJjI+gmIUsQeJKffnbpXaPrlLOvX7mwDcOfnCgdIDO
	+1iE3u684uHm11qD/kYsaTZzzWUNve57B3jm/jzNEgOXfq67qK01Je7m5s+Brkr3/qbTFy
	PT7ENhv7gWEEtDpufX37cTiM9lQOWAU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HI38sG+t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766397968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+/Y1yOgR5PiAtmIgGX9L/SmSrrnAg227KwJhJozi1Tk=;
	b=ZoUKu7t5xQlg4krSIg5dUx1R801yooT/+XD0kTUYHtnEfHwAp4l/0lkRzft9xG1m0xTPrA
	Cd5sTFGtVQR/FmKG4+nRdDXDhGXGB5sMxBxck3fqWgzjJTb+9WLR/8yiDl0W+g768MQBb7
	lvHYDaeRWBYKdm8KvLcrOxS/zcP0huM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D2266013B;
	Mon, 22 Dec 2025 10:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0FFC4CEF1;
	Mon, 22 Dec 2025 10:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766397966;
	bh=eebHz6ssj2w0wto0mRjf/UfvVDz8o6LFYZj+RkpDE+g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HI38sG+tzHdHXWzV6JAYYcfwtG+HOZkEHEjLyqrsyxBrVqaXpBRvG0CIYBJU7rxBj
	 x63MmyJVvgzTXJrCkyxA033xaJESAh2jcupf620fhkrUCtYyUBYki0zkU2TCMFsmH4
	 ki15M8L7sM6oTZcbyRPAy/wDYnEG0ysR0TTpoS6E2hqy4unWVWIat17Fs+z8VNmpGa
	 ErOTaC7ruAPX0RjkyDrTeg1SjEyGW717rpv6ZChAplSxtvq47OFI2vh2Lrt0fZoLVP
	 T8vm1shliwcWwZJ7M7m6D3vyILr9dV4zC+e1hpXiPqRMp6L0HwuzSiol883B9U+5qZ
	 yVqptsfWnpUog==
Message-ID: <233fb781-49fb-4a45-aa5a-d2815018272d@kernel.org>
Date: Mon, 22 Dec 2025 11:06:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] selftests/mm/charge_reserved_hugetlb.sh: add waits
 with timeout helper
To: Li Wang <liwang@redhat.com>, akpm@linux-foundation.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: Mark Brown <broonie@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Waiman Long <longman@redhat.com>
References: <20251221122639.3168038-1-liwang@redhat.com>
 <20251221122639.3168038-4-liwang@redhat.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251221122639.3168038-4-liwang@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F3B2F8000C
X-Stat-Signature: jnwfkpruco9quh5xb3eb36rohah1zce1
X-HE-Tag: 1766397967-43942
X-HE-Meta: U2FsdGVkX19yBAALvYw/EUkjnD3zvhdYlPnN6v87PV0vH7fF2/rhflayUSx8C9lWdlUkcTT5pVBTefJxJAzRv1KI1R2c6OMLUySrBzAOKYvB/LYtuVxaCCMe3q7sQsOrAqrZYcEfb6lWJPSMpvVVfNZvk6Kzs81mxYhtHTE6kVdOIFgkXYODRsggrSy3gYhJ9NfPOYrSGbzXPIiooDSE4r8vHeh5PDipnQBNDrGdHwJaPq5d2c5SNB4yIlGwcNjWLS6zAuLLkktZlsxUT2Z8/mQwqTWZk3Fr64o+6Y4hjDYg7fUKyOvgTqcaXfy2H9CcpA2nhFVMwp6mn70BW1+SiXsEmilOVfgspbM8vM6I0Z3jCBpRSSQy0jW1AyjmNzDx/NXw7+6M/ARWGLGNcbmudgfnVv33bZij6OXQos/zpu9Y72svvWIHsGWLlTlzJp5lGWNiG/WDdUj5vDu8njorna1jR1tBoqwHODXhw7LIyJEiq9WMbQzrMqtbj/FCh+MKQWlqABeCYZgtoWfE526PuIGSxIznyikZ6BqXJc+wpgH3I+UsNDy1YsApPEQWEAqqZcJfe+Ad718xvrtakY0rl9UMNZ8RxE0ZsQUnOBNxVFasXMLorbapdfTmojYK/BL7FMFap3siJwe7+zorrpzZ7UILsFxtI2DEbBdqnwR/dUoEqAIB8H4LOuEZpH80BgpK/mHv42WhUHr4+8d92kdIgBovdEd2NFCKtnLCAVFCP+QhrHRBR3lIkdHIw8i8uqGsrD29UT6qugAPPgH11pig+Lnx+0h+3Zb8jkEmb3+yCX4xXM1CFiXFbNGCXKD4ZJEEa2VCfYa8Fh8m8DDkvhgc9iXt6mkamYHlFzxh8ZtUKjMP0Tl3zPweWcz16QTZyGIBvdflsIIfowHzUY4VwXdmEFHvfEeFFrsQbRXHMk5Rc7+kIR8roKAusaoh/YtPYx8ZhDZUHUaNlYQK5ctJgfU
 Nd9pBO+X
 Y6IKc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/21/25 13:26, Li Wang wrote:
> The hugetlb cgroup usage wait loops in charge_reserved_hugetlb.sh were
> unbounded and could hang forever if the expected cgroup file value never
> appears (e.g. due to write_to_hugetlbfs in Error mapping).
> 
> --- Error log ---
>    # uname -r
>    6.12.0-xxx.el10.aarch64+64k
> 
>    # ls /sys/kernel/mm/hugepages/hugepages-*
>    hugepages-16777216kB/  hugepages-2048kB/  hugepages-524288kB/
> 
>    #./charge_reserved_hugetlb.sh -cgroup-v2
>    # -----------------------------------------
>    ...
>    # nr hugepages = 10
>    # writing cgroup limit: 5368709120
>    # writing reseravation limit: 5368709120
>    ...
>    # write_to_hugetlbfs: Error mapping the file: Cannot allocate memory
>    # Waiting for hugetlb memory reservation to reach size 2684354560.
>    # 0
>    # Waiting for hugetlb memory reservation to reach size 2684354560.
>    # 0
>    # Waiting for hugetlb memory reservation to reach size 2684354560.
>    # 0
>    # Waiting for hugetlb memory reservation to reach size 2684354560.
>    # 0
>    # Waiting for hugetlb memory reservation to reach size 2684354560.
>    # 0
>    # Waiting for hugetlb memory reservation to reach size 2684354560.
>    # 0
>    ...
> 
> Introduce a small helper, wait_for_file_value(), and use it for:
>    - waiting for reservation usage to drop to 0,
>    - waiting for reservation usage to reach a given size,
>    - waiting for fault usage to reach a given size.
> 
> This makes the waits consistent and adds a hard timeout (60 tries with
> 1s sleep) so the test fails instead of stalling indefinitely.
> 
> Signed-off-by: Li Wang <liwang@redhat.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Waiman Long <longman@redhat.com>
> ---
>   .../selftests/mm/charge_reserved_hugetlb.sh   | 51 +++++++++++--------
>   1 file changed, 30 insertions(+), 21 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
> index fa6713892d82..447769657634 100755
> --- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
> +++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
> @@ -100,7 +100,7 @@ function setup_cgroup() {
>     echo writing cgroup limit: "$cgroup_limit"
>     echo "$cgroup_limit" >$cgroup_path/$name/hugetlb.${MB}MB.$fault_limit_file
>   
> -  echo writing reseravation limit: "$reservation_limit"
> +  echo writing reservation limit: "$reservation_limit"
>     echo "$reservation_limit" > \
>       $cgroup_path/$name/hugetlb.${MB}MB.$reservation_limit_file
>   
> @@ -112,41 +112,50 @@ function setup_cgroup() {
>     fi
>   }
>   
> +function wait_for_file_value() {
> +  local path="$1"
> +  local expect="$2"
> +  local max_tries=60
> +
> +  if [[ ! -r "$path" ]]; then
> +    echo "ERROR: cannot read '$path', missing or permission denied"
> +    return 1
> +  fi
> +
> +  for ((i=1; i<=max_tries; i++)); do
> +    local cur="$(cat "$path")"
> +    if [[ "$cur" == "$expect" ]]; then
> +      return 0
> +    fi
> +    echo "Waiting for $path to become '$expect' (current: '$cur') (try $i/$max_tries)"
> +    sleep 1
> +  done
> +
> +  echo "ERROR: timeout waiting for $path to become '$expect'"
> +  return 1
> +}
> +
>   function wait_for_hugetlb_memory_to_get_depleted() {
>     local cgroup="$1"
>     local path="$cgroup_path/$cgroup/hugetlb.${MB}MB.$reservation_usage_file"
> -  # Wait for hugetlbfs memory to get depleted.
> -  while [ $(cat $path) != 0 ]; do
> -    echo Waiting for hugetlb memory to get depleted.
> -    cat $path
> -    sleep 0.5
> -  done
> +
> +  wait_for_file_value "$path" "0"
>   }
>   
>   function wait_for_hugetlb_memory_to_get_reserved() {
>     local cgroup="$1"
>     local size="$2"
> -
>     local path="$cgroup_path/$cgroup/hugetlb.${MB}MB.$reservation_usage_file"
> -  # Wait for hugetlbfs memory to get written.
> -  while [ $(cat $path) != $size ]; do
> -    echo Waiting for hugetlb memory reservation to reach size $size.
> -    cat $path
> -    sleep 0.5
> -  done
> +
> +  wait_for_file_value "$path" "$size"
>   }
>   
>   function wait_for_hugetlb_memory_to_get_written() {
>     local cgroup="$1"
>     local size="$2"
> -
>     local path="$cgroup_path/$cgroup/hugetlb.${MB}MB.$fault_usage_file"
> -  # Wait for hugetlbfs memory to get written.
> -  while [ $(cat $path) != $size ]; do
> -    echo Waiting for hugetlb memory to reach size $size.
> -    cat $path
> -    sleep 0.5
> -  done
> +
> +  wait_for_file_value "$path" "$size"
>   }
>   
>   function write_hugetlbfs_and_get_usage() {

It would indeed be cleaner to propagate the error and make it clearer 
how we then cleanly abort the test.

But if it keeps working for the time beiing, fine with me

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

