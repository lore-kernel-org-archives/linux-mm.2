Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E205CD68BD5
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 09:15:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07AE96B00A2; Sun, 21 Dec 2025 04:15:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F40AA6B00A3; Sun, 21 Dec 2025 04:15:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4CFE6B00A4; Sun, 21 Dec 2025 04:15:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D434C6B00A2
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:15:41 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6A9948B7B2
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 09:15:41 +0000 (UTC)
X-FDA: 84242920482.28.292D81E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id C559E140008
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 09:15:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cv2Fm09G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766308539; a=rsa-sha256;
	cv=none;
	b=P0+T1RwCFFS2RRxVTr/Y6w89NGGrbYLTOn2f73Pd8+OQahpNg3zeOr5ymmF4XEPbjfwVg5
	9NdMTCje9oR6/NNghcfQTfSKyTVM+v5yE0HxQgcqqmUT2/FW6pYrfisxHjuJzq2YcDVAJf
	lGMtPTh0Es0/tJQqm7ogeUN4yznb+6U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cv2Fm09G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766308539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NKGvsEHukKuuyWxl85gwZWxBUvwb6DJfhn7C9pwHrYY=;
	b=QMG9fm5Dejauj3ujUKfuYIrmxpd2vSUXdeQWPDaPrIpEMWEECH5meaMPedwx4fU07x1+8N
	oAZxzVP90O5bWGjV3V9Pr9PFFtjY0GBxxpe1zo/ELYri6w5uq8aUwg9SmjlylTbB239Zop
	YnMQAdq4ooJ7YZ4DdEg2IOtZvYWr0Fs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 18E3F60007;
	Sun, 21 Dec 2025 09:15:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE692C4CEFB;
	Sun, 21 Dec 2025 09:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766308538;
	bh=b357hX9Xdp9bwQpTLLwjh3lWhYTvtLb8BnlVRU/osgM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Cv2Fm09GF7eALT3WIQbM1x9zuA1ec7ZvrD2y/x19aVuh4erT7QOl97VSGNP5iR95l
	 T9jB7VOn0ifuVzFaRjZfC5f7B4sqJo/g5CISq9vwCP80Jl+VeWT7AOxoZwDA/Xplry
	 aDxdUd+YXhRg6Lrhp0tPLba/9ttn5ICGNqeOASjQVzkIHiU7eUAdB27x+55aVvmV3c
	 7TffflSjiwv/9rgXkOhvNtpyhhwfbJOr4nBc1UIUk1EUmxBtqJ3EDagbI7BAm1qfes
	 Y9O6f7VPGGFDmTwOUibpJz1Gynudn6/elhIZroI/6GZSAMAy+eI4woYtJJSmbej916
	 l5HjWQ1+P3DsA==
Message-ID: <74414ade-63fb-47ff-adda-903949468b88@kernel.org>
Date: Sun, 21 Dec 2025 10:15:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] selftests/mm/charge_reserved_hugetlb.sh: add waits
 with timeout helper
To: Li Wang <liwang@redhat.com>, akpm@linux-foundation.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: Mark Brown <broonie@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Waiman Long <longman@redhat.com>
References: <20251221085810.3163919-1-liwang@redhat.com>
 <20251221085810.3163919-3-liwang@redhat.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251221085810.3163919-3-liwang@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C559E140008
X-Rspamd-Server: rspam10
X-Stat-Signature: y9us591ezgo8sn1nw3safa8ipo4xp1jh
X-HE-Tag: 1766308539-745630
X-HE-Meta: U2FsdGVkX1/2hCQ+RNVxJGJx+NiVgeJI8/GfCL4QBj8RPtP2q0OASj815BbokURaD4EGsip6mBwhKNYfyfQ8jMp8h3jlgrEArXGfWQlkh+WXOWSG2M7lgPGC7KOf1UStfTwwGAuYsRpGsHBQ5sMij4Qay+TrBBlZifby5VxsRStO0V/bIc3Iwe0yjpKWWqvAf0yRDUA5/T4OSoBooRWm+STK4ijQf1qit3msNnv7/89p9F5m8avbfd9pKlu5VmgZejTa2380tPl2H1fQvVlW7+iVxtMIZZoS3P+jlpfmJGvR/EA3x2GmjcH4XBzKTHwvvPNcTRCuIboqINkBimTRmDaLLMeGiWaqYxOqOJVWOpJwpjKj8oFDaeau/1gUlMjZPd5Jf3s6zi7Xbqjs1DTyjQJHF6/mWs6UuaCB/nzKHofhN67II3kWX5SIT3+DQpzma4FfsneCRUpfx6KCdHyAibVGEkhRYKCCOXGWpcG8xl0/9x2ZWXkNkQQCbvtBjWFZ5oicPyh1d1DyRFL7mGmT5f0+TYMb4BVoVSh2JZ75G7tSszop+tBbsZ7A5QZBykJBmp74ZMJLoD0McGiZsU1Z6IBqe0OmCeVEPtl1EwpdznQpd9sK3lHukilTKgpMjPUbuD1LME5p6Ru3/PP0V+buIUAK9LwjiY42gjoqUEGHjycjjJkjLsZXlQkZccGJmZitE4oNfLyVhbYf0ongxp5KA4NPQhAnANC2qw36SIgdeIGM4N8UqR4d7uCjMGWE4WnVql1CHA1/0pe1CmRCeUFPk56i+/BR1Pq2PZB5OQy2mtLkjdK7YP2AkONEUnaPKl/s2SUcDwfAeZ37uuZT32yM9bYSwQug4bCo2/v05/kkyyxlgnfeja+F6dacL3Zd6eYV7L+Z1CHVSbIoQVWz4efmHW7/SdLxHBfZouanYTrfq+CN9vtbV4xayZFx8HIT8ZmkeFcYWMm2aSUdCfO7T16
 P7SFa/m6
 pLwaG9Y6qiAnD3NiYq6t9NvNVQejaOjWnE8oi83QCxzoUp9xd56i/kEjRNy6VIWIFaE5Hzt8uvYlXusEJEgiv/VnegyCOQmikn8chORyGjndQyZwSMzFEaRhQ605VTrgAhHrAyrL6S2W0UnPjP1iIBrj5ZnaCW+cLNXvjZB62Fs7++5sT7SCCSWRlXDmxtcBu+2+Mzt5A+2FmkwL0FTStNJdSbiASzZ+i7l3WRU53DbFjmviDbjh4DZjz4kzcV+SNaJEeAnTd/af5MQNltG2LBYYdoVCSumYiHuv1JSnHR/w1NDEvukNGb2nPXoGiHydCVXT8+Toz7DzvkFZce7g400bHKQWHPgxQXnee
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/21/25 09:58, Li Wang wrote:
> The hugetlb cgroup usage wait loops in charge_reserved_hugetlb.sh were
> unbounded and could hang forever if the expected cgroup file value never
> appears (e.g. due to bugs, timing issues, or unexpected behavior).

Did you actually hit that in practice? Just wondering.

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
> This makes the waits consistent and adds a hard timeout (120 tries with
> 0.5s sleep) so the test fails instead of stalling indefinitely.
> 
> Signed-off-by: Li Wang <liwang@redhat.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Waiman Long <longman@redhat.com>
> ---
>   .../selftests/mm/charge_reserved_hugetlb.sh   | 47 ++++++++++---------
>   1 file changed, 26 insertions(+), 21 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
> index e1fe16bcbbe8..249a5776c074 100755
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
> @@ -112,41 +112,46 @@ function setup_cgroup() {
>     fi
>   }
>   
> +function wait_for_file_value() {
> +  local path="$1"
> +  local expect="$2"
> +  local max_tries="120"
> +
> +  local i cur

I would just move "cur" into the loop; I don't see a reason to print it 
on the error path when you printed the value on the last "Waiting" line?

	local cur="$(cat "$path")"

Also, not sure if you really need the "local i" here.

What if the path does not exist, do we want to catch that earlier and 
bail out instead of letting "cat" fail here?

> +  for ((i=1; i<=max_tries; i++)); do
> +    cur="$(cat "$path")"
> +    if [[ "$cur" == "$expect" ]]; then
> +      return 0
> +    fi
> +    echo "Waiting for $path to become '$expect' (current: '$cur') (try $i/$max_tries)"
> +    sleep 0.5

Any reason we don't go for the more intuitive "wait 1s" - max 60s wait?

> +  done


Nothing else jumped at me.

-- 
Cheers

David

