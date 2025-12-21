Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF0E8E67482
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 20:30:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F4F26B0005; Sun, 21 Dec 2025 15:30:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49BF96B0089; Sun, 21 Dec 2025 15:30:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3705C6B008A; Sun, 21 Dec 2025 15:30:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 215EF6B0005
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 15:30:59 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 92DB41A097F
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 20:30:58 +0000 (UTC)
X-FDA: 84244622196.12.581D185
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8D33814000B
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 20:30:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fQJ5ZkQf;
	spf=pass (imf23.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766349056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oQHNqpP/7trjjClrcYJjGk8zMRaBkC2YosgJsTkpIiQ=;
	b=qcsmqol4TEd9hf6ysJpPM8r1cT1PANOWnOFUfpifl76J+l6ZSmD/oTYo4W047g04YDQqF6
	vuajyI5Zgp8aGUFBCh7x1pU+R+hS1vGzLn6SDQDmtcOTCSFB0HIzj3DYFGaR2Jlr6iLfKS
	pUXMZzkDLq/0OrRT2nbqnIEHi0iOxQE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fQJ5ZkQf;
	spf=pass (imf23.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766349056; a=rsa-sha256;
	cv=none;
	b=m4N1u/MIhY0X/q4ot8V+aW1El/LlzO/8O8/DqM7UCno+w7s7GR1/cXgPCHrlc8QN3HarS8
	a91xPxHGeYJHT7/chTQ85aJEkOyK+QQMnJvlnxGQecDM5H7bUau0PFL88kt8V0wE/ZDR+k
	mUeVDlEvo5IHUYJ+2q7rJeRK1i0NnNg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766349055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oQHNqpP/7trjjClrcYJjGk8zMRaBkC2YosgJsTkpIiQ=;
	b=fQJ5ZkQfZkzSeCXTyEyNi2GtfcVLeC/FNDplyYxgF2yvWLf4l8HyfC1IEr1NTOun1TLVBs
	+eJhrB6NTkRLX+NVQ1HAHHGBRBhb8VhKd6wmPPTjsl4x7cakDwCC68y7kI6ISBghl/7jY1
	BhMUgJBSOFamcu3iuJnLy6XF1ghCoTI=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-145-NfVc4AmIMKSIwwf313PcWQ-1; Sun, 21 Dec 2025 15:30:53 -0500
X-MC-Unique: NfVc4AmIMKSIwwf313PcWQ-1
X-Mimecast-MFC-AGG-ID: NfVc4AmIMKSIwwf313PcWQ_1766349053
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8b51db8ebd9so1076163385a.2
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 12:30:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766349053; x=1766953853;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oQHNqpP/7trjjClrcYJjGk8zMRaBkC2YosgJsTkpIiQ=;
        b=pwYCv3GLTZtfQmAxt/qrqsGkGl/CQjN3dX9WIht2/kgMkVqM1bJHm9qPDV5rqHidi4
         ehPs7PbnAplkUsVVWUb3sVvJm1xGSp1eAUa5HRqy65EKzFD3yzrwJJwcG9ZYNjG4vVWZ
         oMIza/5lkdJX8hA7hWfwdrwzBWZrFOEUZ4zhL9VCZdp8KSR1SyZTISk50Ch/41KrT9So
         l8xeG/f3nvTZ5C6iXyMuDvoQhcX+K745cTyj5OiSQTwN34EsEXKfGjzXULG152Z/ucb+
         AosE289g2rmutcUlIrhzNdTHTo580kakaAEwr4tGmf5g8knle3+GTxAENiG3QUmSgzR8
         0I3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWfX1TwKzSa9fZ7oimgtuJblIBNN3Y4+k/ig+bLoNfIAJIUEYBGJIzkY/uL41NuKSES8g2oHFkLFw==@kvack.org
X-Gm-Message-State: AOJu0YzyZcBNxFM4aJMx8w8Jl9T1SPPbAMVStvnxe0bSMZeNjXUdMDlG
	MwqIX+KzHIgfqLKEwVesqRf6dmnIH0rtX3yr+ItImzbgnimV6gcZAVmssOkMmzHvAips4AuMjSu
	VWAUtNsy2NY7Mq8wPa0EetoHLeHbwHAFaVGeu8NpgeqXBsQ009xeg
X-Gm-Gg: AY/fxX7Zk1MuohaAakTjIfNLfEqWVDtMc4ykCH6mRiN6/JB3IQF0pxXjH/5Y3iKTufY
	o8uz3WDjKQpBPylD7GKl3NzYpzuYhhO9O2LdEGWDdyEbwIvgc2dj2tFwTqBipVGzAmbTc05Tnk9
	jf2OUoLEMvWeduXvkwlH+qQ2M1ZweiTILA9ttiQr5F9JaLsp2FxuUeMLHUu0JD+EjHOEg+JJ69+
	mzTqdnPd/hkMH64HDMVCBpu5ddgUXjjXUONCQYk9/547F7cTkaTLgkGsx0d1QCqwyLRQYxqJrYM
	MOc32HnNcv+86Z91D+Qgy1BKo471gt8g0Kb8xgySX80MkDvTmUYVyLeO6Mz0Vtw1t2hw73H3v/n
	SJ94bzXs8EX3CWVJrIwy01EoVZFuygxhbOSo/WRWtonDG/b2K/R4Mrj35
X-Received: by 2002:a05:620a:4095:b0:8b2:7679:4d12 with SMTP id af79cd13be357-8c08f66bf33mr1473824885a.26.1766349053167;
        Sun, 21 Dec 2025 12:30:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG4ZSBwCOROzj1MDk+wseVq5r9oqA/aYULwmmkpJomMHdxkmKpX/uo/s0oZVSGAhDM9U0HtIw==
X-Received: by 2002:a05:620a:4095:b0:8b2:7679:4d12 with SMTP id af79cd13be357-8c08f66bf33mr1473822185a.26.1766349052724;
        Sun, 21 Dec 2025 12:30:52 -0800 (PST)
Received: from ?IPV6:2601:600:947f:f020:85dc:d2b2:c5ee:e3c4? ([2601:600:947f:f020:85dc:d2b2:c5ee:e3c4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c0970f5fcdsm674426985a.29.2025.12.21.12.30.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Dec 2025 12:30:52 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <33d5bdc7-0fde-4a97-aa1a-f8565e196ccd@redhat.com>
Date: Sun, 21 Dec 2025 15:30:50 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] selftests/mm/charge_reserved_hugetlb.sh: add waits
 with timeout helper
To: Li Wang <liwang@redhat.com>, akpm@linux-foundation.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>, Mark Brown <broonie@kernel.org>,
 Shuah Khan <shuah@kernel.org>
References: <20251221122639.3168038-1-liwang@redhat.com>
 <20251221122639.3168038-4-liwang@redhat.com>
In-Reply-To: <20251221122639.3168038-4-liwang@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6hMMen48dXktolM3esHw5pABSHgk8AkR9sZPFZYp4oI_1766349053
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: s311duxahh9sxm434iwm3duag51kpuqd
X-Rspam-User: 
X-Rspamd-Queue-Id: 8D33814000B
X-HE-Tag: 1766349055-43018
X-HE-Meta: U2FsdGVkX18cHNgHpv+sr+9fUpGvPdkg649VEMgL/POxuoDzhJfzZEgcUlf0KjDB1T1dpZyp9Q4dIija+82pcHllKNtt9GvlVdsq2VU+klDdtRSGvaj3NZZZr1FuI/sbehzTnvqkXHPhazR7NTlm6LU72tuIYW5LXscei40F3u9vvOxJsPFYjE6/LBJPBfvxQXUB17oWvW27JqYaumAim5e8acNUOlgk3MexAq95oFOU+HUoTQ5t6o/gKnmFjhj8mHr9h4OoQEHM05sqay1lAkUvv6tKBV1449GF8tDZTwrauM+ZuSGpSCN6E6o87N2Mk+kQxngi9W42OtpKAtCjprANtFfI9iW6Z/CK1OlRRJPua7RFKwhuTlJQEUwBMDAdISKwH5gDOiu6OmNNsS+NX69dfQmYlqAEEcF7nIS18MS3PGBPpOXR6PY1DxbRue66XTbaLFKS/b1goxdTchqSicQlLFFdSMETdwfpDGKwvC+Upia4FaiMLxCZrUMe8Qp0gE+3i2KTzDuGfzV+S/t6lHfBxbRQ1hx1DNcwP/eAj0gSqZOS62EVPGuZp+8mSCaJrQZ+68P2xvr9ApgRUDg8ANMAARSXgUvyrNRxnQj/naphSr3efutxYVB/hnauqpfE0q5znPNXPin57PAk3d/wOz5sVo8CUg5gSQir5z8R83W4WcXMpJYyLl9fBUshfHTFhcV23k3UWtPRyOmYnrYxWEci9l+1mggIMAtwiBLwxdH3jVUj4cpKtDoZBR+Q59mXWoVel3WRAxwzfVCr7V09QyBzCdiT4lsmSZqWJ+jTzb7dM+CXXc269tcnvv+ON2wJNz9EQ5/jqFSWM77BXiLiryX4iZuviBM5ANBLd2DnuxjlU9UT2/+HX48I9eiANhRea3RjDh0DgNGACjIzFTPW/hIL6PlvKFwtbfpa++lUfEryyQBtCOBIOfYIiBePYw39QWqu45oYeXXNADD5oQM
 oAYzhWYR
 6DYNmVIU9g/s0KsgNrBqJNMairUVfKUpY8amEqHeIdgjYsLj0anKpZtas1Vl8OGwTEqqrmLhNgq53tcI06au6SGdL+1Szrd1tcyVyed6yRBRLBywuQ+2BDBx1V9BFi0Wk7cZrQxv94IJda0s0YPEnbQaQC0knEDtHxThc72ZVxU0SmSfh6/Y4rI/zHdKb+l++bFj6uhBRrSX3O8SBWSLczYLlE8YdnygmYppaaGhltiw45Mzr0AjYo6+uPnhPpWUvoa74s+bZYppiqyEXqBmzJpsrdH0vvp1llRbmmJx4FkHkeakr6DNZPVk80j3hgYlFq23EjWApw1HdRW603vqTE+dJlv8gFfvhJO0XlYz/CbUAa1fRW72JlR2wgusFJfJTyxF3gn+yRHlVlZVowyup4iLPix+V747BbyI0hWkpsuucqBWmwRzJ2cfu+fxM5BC7VuI5g7lH+zcfINuZUOZnX4UAQpDk1bBagsbm1Eay4D8i81966gl70n9IqClyfW6e5HYN3wZWX8GX28Qw63r32RrnQKzAWLqv37S7DPD/YT08ZZr/krokwTyKK/vTJGhStwRX11HtOBgu3ws=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 12/21/25 7:26 AM, Li Wang wrote:
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

wait_for_file_value() now return 0 onr success and 1 on timeout. 
However, none of the callers of the wait_for_hugetlb_memory* are 
checking their return values and acting accordingly. Are we expecting 
that the test will show failure because the waiting isn't completed or 
should we explicitly exit with ksft_fail (1) value?

Cheers,
Longman


