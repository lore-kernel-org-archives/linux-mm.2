Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36ACBD711D5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 03:54:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CA706B008A; Sun, 21 Dec 2025 22:54:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54DF06B008C; Sun, 21 Dec 2025 22:54:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4222B6B0092; Sun, 21 Dec 2025 22:54:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 28B9A6B008A
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 22:54:40 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DB3AC8B6DA
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:54:39 +0000 (UTC)
X-FDA: 84245740278.01.6EB9E89
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5C376C0007
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:54:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=clm6JfUb;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766375677; a=rsa-sha256;
	cv=none;
	b=Dck/1iIGQS4Kz0QvuSA6Chi8Ehyx1GomUk82Q3IXFZfIk9E12u7F5G+ltw6U8rEtRobjzK
	ZyhTPLodJjd1AvzqZP7T1/qe2JIMsZyuSM4O9ENDybbjt/7RaQ3pMlfEAvmANswFb+0i7i
	anddqptThyKamMPRPdAkLMSUSDIO0sY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=clm6JfUb;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766375677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aexSacJ2HGvmVmzFIcrBzfQkAfkUbRVOmqPiR6bm+do=;
	b=WDiLQ25ABoiLQTvLj5587T3/0zZQLt9iFdOXcdGkvJs00yQ/3XFWBY3CFo7qHXYYoQcCwD
	2+CEwr7lKfVpKIZ38cj9X9xqNcqId20/kfqDxYajqwtNec9RiC9wRs4LlN0WX3fsWn/2Gm
	zwgD7yNT+hQ9EDddLlu5VeQTm7HHbhw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766375676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aexSacJ2HGvmVmzFIcrBzfQkAfkUbRVOmqPiR6bm+do=;
	b=clm6JfUbdUjR+POjsoNDDFLB1KNpDjROuJVV7gppbEp1FaqcdUA2dhSebcyUneGITDUcxt
	vQdY9EA3eUjFochiMq/cIbeXg9gJSPzhYIsu5dTWjW7Vveqwd/i8ev9PN5Ebd7CDLH61Ek
	alNUI0+1WDe2vCon/zKC5PRfas2ILJU=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-488-K_E4QSpqPIiZZXfPD-7Ujg-1; Sun, 21 Dec 2025 22:54:35 -0500
X-MC-Unique: K_E4QSpqPIiZZXfPD-7Ujg-1
X-Mimecast-MFC-AGG-ID: K_E4QSpqPIiZZXfPD-7Ujg_1766375675
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4f35f31000cso47122261cf.2
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 19:54:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766375674; x=1766980474;
        h=in-reply-to:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aexSacJ2HGvmVmzFIcrBzfQkAfkUbRVOmqPiR6bm+do=;
        b=c54fxv3Q4R8D7yA56KLmDuqG/tQo+tfXijFRyEiDTCVlIqtsy4/XuqxVigAyYds2me
         1Xt2HbEgGk5X8dusPWS5l4CObd6/33VhOts70TddvqQ8EsCQe3/a4Xihh+F7qRyiBLM9
         5lSLuHeP9QsFq/FOtMZLD5Ce0RMDL/i9W1MyefVGuTMR0MhxQwqH2X8ulJZLTuyfIDiH
         SJgzxoj9OA0h/nH1x2eiLipUn9rCWNM+KzPowT/cYR173NK0t2q3zw//Kz6GPNWfXJmY
         9LcpYgi+4dYDYNy6mlBm16yp4gtyyYY47SRbFqfqAxQwakY3eX9rF4EoYQfle/5ZXtnt
         Weag==
X-Forwarded-Encrypted: i=1; AJvYcCUWravdnjMWIzAm189IB5ONJJQvWGFJVqFdunRZz/7C57hsXXyBqk/V4YDdlDcBHPlNJnxkeKmnGw==@kvack.org
X-Gm-Message-State: AOJu0YwwiBgEQ0eiR9Qtkdm7Emkwdxyv5sJ2UVUdJM2ST/RIfJTtksHF
	M1kIlW/Q8Z9g+ATNEOdZ7VZ7f4cx/yOAAfe2gxafNQftXT7N+1IiDph7gb1QV6sSqAkujSiXbzc
	a/e7mKrummyD1uuQzTGsQpjlpX66J73KhO0uN+ePpmKqsxr6ELJ8XFk3V6UFN
X-Gm-Gg: AY/fxX6lpgwUSI9BcajiXHLmi/y3PZWe2vcQh11Uc3iCBTFblzivG2O41LvWu33poBD
	7JKauLcaH0nR1nnIj13b5hmR9LnH2veLALSwGoQXK/uOPWGQfZkAmZbbmT8FO46FcRAhQvHVo3i
	rwVgLJvHmhEljfGfIwydi7yPj214hfPJm0mgVxfZseuB7leeleJ/ksRvt4PeKpvMA68KgXOx4bi
	6hGI2aDQNLlrF/ZJMqtwBHmH05fZaoH8BZzznQzUCHk+N01DUkxPURkmaQozCEWfxF9hzQzbZtT
	oCwet7cbwauKEn9jf6ewYLv6CQrJPJhLjOgcV1ouASONjUrDESFROiiQSDTUdIC9T4Q0odKQIAJ
	i7leQBgC7+1q2yj1jJZeOXJRC+sIQngs8FFD/AhO85HO3FNwzbQll3Wh5
X-Received: by 2002:a05:622a:4d06:b0:4f0:441:96be with SMTP id d75a77b69052e-4f4abd6097cmr149836901cf.51.1766375674518;
        Sun, 21 Dec 2025 19:54:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE1DvqDxCGvRuDgMVgjtZa5PZS/8klsiO8bQgTTA2+GnPo4JzwK7+97Heggw1P9K7vDcLSokw==
X-Received: by 2002:a05:622a:4d06:b0:4f0:441:96be with SMTP id d75a77b69052e-4f4abd6097cmr149836681cf.51.1766375674046;
        Sun, 21 Dec 2025 19:54:34 -0800 (PST)
Received: from ?IPV6:2601:600:947f:f020:85dc:d2b2:c5ee:e3c4? ([2601:600:947f:f020:85dc:d2b2:c5ee:e3c4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f4ac62e1e7sm68163471cf.21.2025.12.21.19.54.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Dec 2025 19:54:33 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <8ae01582-d813-40e3-be7a-50572b368b36@redhat.com>
Date: Sun, 21 Dec 2025 22:54:31 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] selftests/mm/charge_reserved_hugetlb.sh: add waits
 with timeout helper
To: Li Wang <liwang@redhat.com>, Waiman Long <llong@redhat.com>
Cc: akpm@linux-foundation.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 David Hildenbrand <david@kernel.org>, Mark Brown <broonie@kernel.org>,
 Shuah Khan <shuah@kernel.org>
References: <20251221122639.3168038-1-liwang@redhat.com>
 <20251221122639.3168038-4-liwang@redhat.com>
 <33d5bdc7-0fde-4a97-aa1a-f8565e196ccd@redhat.com>
 <CAEemH2ehOUyDqHhn5+Mu2B31dCpOhDv6AL7sEFU5Vt7nSST=Tw@mail.gmail.com>
In-Reply-To: <CAEemH2ehOUyDqHhn5+Mu2B31dCpOhDv6AL7sEFU5Vt7nSST=Tw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UTSujxGyYG3YarkNvgpyx59o6d25aQm3E_mtlz-aeks_1766375675
X-Mimecast-Originator: redhat.com
Content-Type: multipart/alternative;
 boundary="------------8g9DKHctJuTWw6zJzaN4uBFd"
Content-Language: en-US
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5C376C0007
X-Stat-Signature: 33amogkawryfqn1wcei7b1trghuba1df
X-Rspam-User: 
X-HE-Tag: 1766375677-154294
X-HE-Meta: U2FsdGVkX1+RlxeOF5Qgd646KHQXMMlo/NtFEMQQhvlUFcQSgLskB9iXErFoD3ZdO1MjjpVXWz7H7OGR20l1RdU0HJmysCLAeBf0fTcWU6SYZ2mzbICgn78qEz5Qia/b1ofpBbBqFzapp2Kstq226vibutO7FtB/TT2wtntqFLopdFUeqtxyliKwDo0Q53zl1caboNElBPYZYbcbzb1Co+r/u3xgjIotUbgr3omI+0wKQzW3VCFZl0Gl/MjDXkJcPihPUqo8NqT+LQ4xdMnbyBTaUng50qGJbPNNMlUKsv1hGF0Hr37F3QNFRZDB8FupR+Tbs7TOpR4+FuXYoVMNdhL/th2bpJWg0MIgi9yPZ6TmiJxVKNIxPOwPQRcxJz5uHHZVa0XjHx0kqlBqUSAagl4tNYyRmuWqC6q6EzFZeITaH8hMKOZSWRXiun3jlBhZoNXGNcsJfywTGoREmcTgpPhE8SS4fT8ubzR+HM1+zQsmFXKwj3RHzeXQFQu4F6nH8c6I3M1Zw6rnniD+XxsKjdSFeyuQH1TGOVMnSakAYXKVGs6IAawnbB/6cvQnWUJQq9f7yaDaYsFH8+eZWwQ16K9dItkv9+JrHx+apWYWP/sKA2scxqUZMvlA7GBVexLh0BJvRhqyt0BegMGpUZ9tCzMI15A6JsS1HYvWb1yqGf93iBaU6FB8xZaH6Rj+vAnG6Przz8WM4SsoYwLQmdOHMAZjRWW3ikKRM7R7M+UMBYFWewc5K4VJwyF9Lx/4FxltipcyPZc7DJd6G+zMs88V8tBfA5OB9TGQLol7xGMtkdXENSUk9NybCLNTAeFPm+WrwmGU1EN1x0r4Ycv+LVyM3CIF6kcRWJja2T+N3Wwzyeo6B1fFMH4py+Bfl8jD9rjURAEdsuCndV/naLM9LIGzLgbSblVZDAjUuOKOA+eGScK1I4MoTjP44oQEVEf/xuTQI+CHK5LlYVhdUsDQUfu
 lRHLiH2H
 rh59kEPFOtd3SFq6CFbKGzrv01KONNfVq65FASNqURvVzffFCDknClssX7iGn5/oIPJGhaOOXfPOT2okjXCnRHf8SBJr9wE+hUwbCcOLkc6joVUzlrtItwomARiKi6pRSNf0CZ08LAvabz1JZard7I+iUK7uOMMGePW7wThsW3ZpczV+3fKcBr1i/DrbqK0VcP1DIq/N9KdYSMaX2BzgqmgG2CL58s6KOcYHMXhYZJoYRSeNQcfhX+a+a+ftOjbwJdUKvAdsaHKGRiASqtSHfRLOaaKEKSkCrTtauBo34zyu/EJo047Gr8EHSjaQY+4TMw3XvNUIg7qr4U797dbDy8ZWjrVcz4QDtRC+Vftju48YOh9/x5PK8m5gVnxI6MupT7DK052DhwNMQXqvjFgSPcxzTaQBpeZ1Y2ZRwab4F3uJeQH6JjxibTzTxVcEyew372Za31TRid6Brc7ZR4Ek2bZ1AOi3g9LMXjAfPlXCYizwW27i7plOOn5SkMujsHNd9tnha5alVH9O/cO77UBVK/QqeKqpDsBEi0tyoK3P2Ab90sntIdLcTyd/K+hWWx96Z42VAJc0i5cn/251vOjL+7CzDkTySndMihUVP4cupXw+lZOYnxbyIY8c93TABySkpYUaJfIHfIAEwiKrA8WT+jerb6zdf6wT+txilrJ8XSKINTxYvPfIRbITdCeVdm65QWSwTrLtVkYNTUiJcu3/K7v4hI1v9GEdreX88CXI3Tuz/DfS5vfPbTimthzohPyZ8MYrDR+dTkbxiNslvsLrbrCpPIH9U4vaVI8tb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------8g9DKHctJuTWw6zJzaN4uBFd
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 12/21/25 7:56 PM, Li Wang wrote:
> On Mon, Dec 22, 2025 at 4:30 AM Waiman Long<llong@redhat.com> wrote:
>>
>> On 12/21/25 7:26 AM, Li Wang wrote:
>>> The hugetlb cgroup usage wait loops in charge_reserved_hugetlb.sh were
>>> unbounded and could hang forever if the expected cgroup file value never
>>> appears (e.g. due to write_to_hugetlbfs in Error mapping).
>>>
>>> --- Error log ---
>>>     # uname -r
>>>     6.12.0-xxx.el10.aarch64+64k
>>>
>>>     # ls /sys/kernel/mm/hugepages/hugepages-*
>>>     hugepages-16777216kB/  hugepages-2048kB/  hugepages-524288kB/
>>>
>>>     #./charge_reserved_hugetlb.sh -cgroup-v2
>>>     # -----------------------------------------
>>>     ...
>>>     # nr hugepages = 10
>>>     # writing cgroup limit: 5368709120
>>>     # writing reseravation limit: 5368709120
>>>     ...
>>>     # write_to_hugetlbfs: Error mapping the file: Cannot allocate memory
>>>     # Waiting for hugetlb memory reservation to reach size 2684354560.
>>>     # 0
>>>     # Waiting for hugetlb memory reservation to reach size 2684354560.
>>>     # 0
>>>     # Waiting for hugetlb memory reservation to reach size 2684354560.
>>>     # 0
>>>     # Waiting for hugetlb memory reservation to reach size 2684354560.
>>>     # 0
>>>     # Waiting for hugetlb memory reservation to reach size 2684354560.
>>>     # 0
>>>     # Waiting for hugetlb memory reservation to reach size 2684354560.
>>>     # 0
>>>     ...
>>>
>>> Introduce a small helper, wait_for_file_value(), and use it for:
>>>     - waiting for reservation usage to drop to 0,
>>>     - waiting for reservation usage to reach a given size,
>>>     - waiting for fault usage to reach a given size.
>>>
>>> This makes the waits consistent and adds a hard timeout (60 tries with
>>> 1s sleep) so the test fails instead of stalling indefinitely.
>>>
>>> Signed-off-by: Li Wang<liwang@redhat.com>
>>> Cc: David Hildenbrand<david@kernel.org>
>>> Cc: Mark Brown<broonie@kernel.org>
>>> Cc: Shuah Khan<shuah@kernel.org>
>>> Cc: Waiman Long<longman@redhat.com>
>>> ---
>>>    .../selftests/mm/charge_reserved_hugetlb.sh   | 51 +++++++++++--------
>>>    1 file changed, 30 insertions(+), 21 deletions(-)
>>>
>>> diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
>>> index fa6713892d82..447769657634 100755
>>> --- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
>>> +++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
>>> @@ -100,7 +100,7 @@ function setup_cgroup() {
>>>      echo writing cgroup limit: "$cgroup_limit"
>>>      echo "$cgroup_limit" >$cgroup_path/$name/hugetlb.${MB}MB.$fault_limit_file
>>>
>>> -  echo writing reseravation limit: "$reservation_limit"
>>> +  echo writing reservation limit: "$reservation_limit"
>>>      echo "$reservation_limit" > \
>>>        $cgroup_path/$name/hugetlb.${MB}MB.$reservation_limit_file
>>>
>>> @@ -112,41 +112,50 @@ function setup_cgroup() {
>>>      fi
>>>    }
>>>
>>> +function wait_for_file_value() {
>>> +  local path="$1"
>>> +  local expect="$2"
>>> +  local max_tries=60
>>> +
>>> +  if [[ ! -r "$path" ]]; then
>>> +    echo "ERROR: cannot read '$path', missing or permission denied"
>>> +    return 1
>>> +  fi
>>> +
>>> +  for ((i=1; i<=max_tries; i++)); do
>>> +    local cur="$(cat "$path")"
>>> +    if [[ "$cur" == "$expect" ]]; then
>>> +      return 0
>>> +    fi
>>> +    echo "Waiting for $path to become '$expect' (current: '$cur') (try $i/$max_tries)"
>>> +    sleep 1
>>> +  done
>>> +
>>> +  echo "ERROR: timeout waiting for $path to become '$expect'"
>>> +  return 1
>>> +}
>>> +
>>>    function wait_for_hugetlb_memory_to_get_depleted() {
>>>      local cgroup="$1"
>>>      local path="$cgroup_path/$cgroup/hugetlb.${MB}MB.$reservation_usage_file"
>>> -  # Wait for hugetlbfs memory to get depleted.
>>> -  while [ $(cat $path) != 0 ]; do
>>> -    echo Waiting for hugetlb memory to get depleted.
>>> -    cat $path
>>> -    sleep 0.5
>>> -  done
>>> +
>>> +  wait_for_file_value "$path" "0"
>>>    }
>>>
>>>    function wait_for_hugetlb_memory_to_get_reserved() {
>>>      local cgroup="$1"
>>>      local size="$2"
>>> -
>>>      local path="$cgroup_path/$cgroup/hugetlb.${MB}MB.$reservation_usage_file"
>>> -  # Wait for hugetlbfs memory to get written.
>>> -  while [ $(cat $path) != $size ]; do
>>> -    echo Waiting for hugetlb memory reservation to reach size $size.
>>> -    cat $path
>>> -    sleep 0.5
>>> -  done
>>> +
>>> +  wait_for_file_value "$path" "$size"
>>>    }
>>>
>>>    function wait_for_hugetlb_memory_to_get_written() {
>>>      local cgroup="$1"
>>>      local size="$2"
>>> -
>>>      local path="$cgroup_path/$cgroup/hugetlb.${MB}MB.$fault_usage_file"
>>> -  # Wait for hugetlbfs memory to get written.
>>> -  while [ $(cat $path) != $size ]; do
>>> -    echo Waiting for hugetlb memory to reach size $size.
>>> -    cat $path
>>> -    sleep 0.5
>>> -  done
>>> +
>>> +  wait_for_file_value "$path" "$size"
>>>    }
>>>
>>>    function write_hugetlbfs_and_get_usage() {
>> wait_for_file_value() now return 0 onr success and 1 on timeout.
>> However, none of the callers of the wait_for_hugetlb_memory* are
>> checking their return values and acting accordingly. Are we expecting
>> that the test will show failure because the waiting isn't completed or
>> should we explicitly exit with ksft_fail (1) value?
> Hmm, it seems the test shouldn't exit too early.
>
> As the wait_for_hugetlb_memory* is only trying 60s to examine the file
> value, if timeouted, we still need to keep going because the test requires
> CLEANUP work and exit/report from there.
>
> The key point of each subtest is to save the '$write_result' value and
> examine it
> which controls the whole test to exit.
>
> e.g.
>
> This is an intentional error test:
>
> # ./charge_reserved_hugetlb.sh -cgroup-v2
> CLEANUP DONE
> ...
> Writing to this path: /mnt/huge/test
> Writing this size: 2684354560
> Not populating.
> Not writing to memory.
> Using method=0
> Shared mapping.
> RESERVE mapping.
> Allocating using HUGETLBFS.
> write_to_hugetlbfs: Error mapping the file: Cannot allocate memory
> Waiting for /sys/fs/cgroup/hugetlb_cgroup_test/hugetlb.512MB.rsvd.current
> to become '2684354560' (current: '0') (try 1/60)
> Waiting for /sys/fs/cgroup/hugetlb_cgroup_test/hugetlb.512MB.rsvd.current
> to become '2684354560' (current: '0') (try 2/60)
> Waiting for /sys/fs/cgroup/hugetlb_cgroup_test/hugetlb.512MB.rsvd.current
> to become '2684354560' (current: '0') (try 3/60)
> Waiting for /sys/fs/cgroup/hugetlb_cgroup_test/hugetlb.512MB.rsvd.current
> to become '2684354560' (current: '0') (try 4/60)
> ...
> Waiting for /sys/fs/cgroup/hugetlb_cgroup_test/hugetlb.512MB.rsvd.current
> to become '2684354560' (current: '0') (try 60/60)
> ERROR: timeout waiting for
> /sys/fs/cgroup/hugetlb_cgroup_test/hugetlb.512MB.rsvd.current to
> become '2684354560'
> After write:
> hugetlb_usage=0
> reserved_usage=0
> 0
> 0
> Memory charged to hugtlb=0
> Memory charged to reservation=0
> expected (2684354560) != actual (0): Reserved memory not charged to
> reservation usage.
> CLEANUP DONE

Thank for running a test case. As long as the test will still report a 
failure, it will be fine with me. I just want to note that the return 
value value of wait_for_file_value() isn't currently used at all.

Cheers, Longman

--------------8g9DKHctJuTWw6zJzaN4uBFd
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <br>
    <div class="moz-cite-prefix">On 12/21/25 7:56 PM, Li Wang wrote:<br>
    </div>
    <blockquote type="cite"
cite="mid:CAEemH2ehOUyDqHhn5+Mu2B31dCpOhDv6AL7sEFU5Vt7nSST=Tw@mail.gmail.com">
      <pre wrap="" class="moz-quote-pre">On Mon, Dec 22, 2025 at 4:30 AM Waiman Long <a class="moz-txt-link-rfc2396E" href="mailto:llong@redhat.com">&lt;llong@redhat.com&gt;</a> wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">

On 12/21/25 7:26 AM, Li Wang wrote:
</pre>
        <blockquote type="cite">
          <pre wrap="" class="moz-quote-pre">The hugetlb cgroup usage wait loops in charge_reserved_hugetlb.sh were
unbounded and could hang forever if the expected cgroup file value never
appears (e.g. due to write_to_hugetlbfs in Error mapping).

--- Error log ---
   # uname -r
   6.12.0-xxx.el10.aarch64+64k

   # ls /sys/kernel/mm/hugepages/hugepages-*
   hugepages-16777216kB/  hugepages-2048kB/  hugepages-524288kB/

   #./charge_reserved_hugetlb.sh -cgroup-v2
   # -----------------------------------------
   ...
   # nr hugepages = 10
   # writing cgroup limit: 5368709120
   # writing reseravation limit: 5368709120
   ...
   # write_to_hugetlbfs: Error mapping the file: Cannot allocate memory
   # Waiting for hugetlb memory reservation to reach size 2684354560.
   # 0
   # Waiting for hugetlb memory reservation to reach size 2684354560.
   # 0
   # Waiting for hugetlb memory reservation to reach size 2684354560.
   # 0
   # Waiting for hugetlb memory reservation to reach size 2684354560.
   # 0
   # Waiting for hugetlb memory reservation to reach size 2684354560.
   # 0
   # Waiting for hugetlb memory reservation to reach size 2684354560.
   # 0
   ...

Introduce a small helper, wait_for_file_value(), and use it for:
   - waiting for reservation usage to drop to 0,
   - waiting for reservation usage to reach a given size,
   - waiting for fault usage to reach a given size.

This makes the waits consistent and adds a hard timeout (60 tries with
1s sleep) so the test fails instead of stalling indefinitely.

Signed-off-by: Li Wang <a class="moz-txt-link-rfc2396E" href="mailto:liwang@redhat.com">&lt;liwang@redhat.com&gt;</a>
Cc: David Hildenbrand <a class="moz-txt-link-rfc2396E" href="mailto:david@kernel.org">&lt;david@kernel.org&gt;</a>
Cc: Mark Brown <a class="moz-txt-link-rfc2396E" href="mailto:broonie@kernel.org">&lt;broonie@kernel.org&gt;</a>
Cc: Shuah Khan <a class="moz-txt-link-rfc2396E" href="mailto:shuah@kernel.org">&lt;shuah@kernel.org&gt;</a>
Cc: Waiman Long <a class="moz-txt-link-rfc2396E" href="mailto:longman@redhat.com">&lt;longman@redhat.com&gt;</a>
---
  .../selftests/mm/charge_reserved_hugetlb.sh   | 51 +++++++++++--------
  1 file changed, 30 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
index fa6713892d82..447769657634 100755
--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
+++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -100,7 +100,7 @@ function setup_cgroup() {
    echo writing cgroup limit: "$cgroup_limit"
    echo "$cgroup_limit" &gt;$cgroup_path/$name/hugetlb.${MB}MB.$fault_limit_file

-  echo writing reseravation limit: "$reservation_limit"
+  echo writing reservation limit: "$reservation_limit"
    echo "$reservation_limit" &gt; \
      $cgroup_path/$name/hugetlb.${MB}MB.$reservation_limit_file

@@ -112,41 +112,50 @@ function setup_cgroup() {
    fi
  }

+function wait_for_file_value() {
+  local path="$1"
+  local expect="$2"
+  local max_tries=60
+
+  if [[ ! -r "$path" ]]; then
+    echo "ERROR: cannot read '$path', missing or permission denied"
+    return 1
+  fi
+
+  for ((i=1; i&lt;=max_tries; i++)); do
+    local cur="$(cat "$path")"
+    if [[ "$cur" == "$expect" ]]; then
+      return 0
+    fi
+    echo "Waiting for $path to become '$expect' (current: '$cur') (try $i/$max_tries)"
+    sleep 1
+  done
+
+  echo "ERROR: timeout waiting for $path to become '$expect'"
+  return 1
+}
+
  function wait_for_hugetlb_memory_to_get_depleted() {
    local cgroup="$1"
    local path="$cgroup_path/$cgroup/hugetlb.${MB}MB.$reservation_usage_file"
-  # Wait for hugetlbfs memory to get depleted.
-  while [ $(cat $path) != 0 ]; do
-    echo Waiting for hugetlb memory to get depleted.
-    cat $path
-    sleep 0.5
-  done
+
+  wait_for_file_value "$path" "0"
  }

  function wait_for_hugetlb_memory_to_get_reserved() {
    local cgroup="$1"
    local size="$2"
-
    local path="$cgroup_path/$cgroup/hugetlb.${MB}MB.$reservation_usage_file"
-  # Wait for hugetlbfs memory to get written.
-  while [ $(cat $path) != $size ]; do
-    echo Waiting for hugetlb memory reservation to reach size $size.
-    cat $path
-    sleep 0.5
-  done
+
+  wait_for_file_value "$path" "$size"
  }

  function wait_for_hugetlb_memory_to_get_written() {
    local cgroup="$1"
    local size="$2"
-
    local path="$cgroup_path/$cgroup/hugetlb.${MB}MB.$fault_usage_file"
-  # Wait for hugetlbfs memory to get written.
-  while [ $(cat $path) != $size ]; do
-    echo Waiting for hugetlb memory to reach size $size.
-    cat $path
-    sleep 0.5
-  done
+
+  wait_for_file_value "$path" "$size"
  }

  function write_hugetlbfs_and_get_usage() {
</pre>
        </blockquote>
        <pre wrap="" class="moz-quote-pre">
wait_for_file_value() now return 0 onr success and 1 on timeout.
However, none of the callers of the wait_for_hugetlb_memory* are
checking their return values and acting accordingly. Are we expecting
that the test will show failure because the waiting isn't completed or
should we explicitly exit with ksft_fail (1) value?
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Hmm, it seems the test shouldn't exit too early.

As the wait_for_hugetlb_memory* is only trying 60s to examine the file
value, if timeouted, we still need to keep going because the test requires
CLEANUP work and exit/report from there.

The key point of each subtest is to save the '$write_result' value and
examine it
which controls the whole test to exit.

e.g.

This is an intentional error test:

# ./charge_reserved_hugetlb.sh -cgroup-v2
CLEANUP DONE
...
Writing to this path: /mnt/huge/test
Writing this size: 2684354560
Not populating.
Not writing to memory.
Using method=0
Shared mapping.
RESERVE mapping.
Allocating using HUGETLBFS.
write_to_hugetlbfs: Error mapping the file: Cannot allocate memory
Waiting for /sys/fs/cgroup/hugetlb_cgroup_test/hugetlb.512MB.rsvd.current
to become '2684354560' (current: '0') (try 1/60)
Waiting for /sys/fs/cgroup/hugetlb_cgroup_test/hugetlb.512MB.rsvd.current
to become '2684354560' (current: '0') (try 2/60)
Waiting for /sys/fs/cgroup/hugetlb_cgroup_test/hugetlb.512MB.rsvd.current
to become '2684354560' (current: '0') (try 3/60)
Waiting for /sys/fs/cgroup/hugetlb_cgroup_test/hugetlb.512MB.rsvd.current
to become '2684354560' (current: '0') (try 4/60)
...
Waiting for /sys/fs/cgroup/hugetlb_cgroup_test/hugetlb.512MB.rsvd.current
to become '2684354560' (current: '0') (try 60/60)
ERROR: timeout waiting for
/sys/fs/cgroup/hugetlb_cgroup_test/hugetlb.512MB.rsvd.current to
become '2684354560'
After write:
hugetlb_usage=0
reserved_usage=0
0
0
Memory charged to hugtlb=0
Memory charged to reservation=0
expected (2684354560) != actual (0): Reserved memory not charged to
reservation usage.
CLEANUP DONE
</pre>
    </blockquote>
    <p>Thank for running a test case. As long as the test will still
      report a failure, it will be fine with me. I just want to note
      that the return value value of <span style="white-space: pre-wrap">wait_for_file_value() isn't currently used at all.</span></p>
    <p><span style="white-space: pre-wrap">Cheers,
Longman</span></p>
  </body>
</html>

--------------8g9DKHctJuTWw6zJzaN4uBFd--


