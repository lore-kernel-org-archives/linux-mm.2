Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76011EA3C23
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 10:48:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D86E06B0005; Thu,  9 Apr 2026 06:48:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5E656B0088; Thu,  9 Apr 2026 06:48:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9B416B008A; Thu,  9 Apr 2026 06:48:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BAA656B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 06:48:23 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 67B618BAB4
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:48:23 +0000 (UTC)
X-FDA: 84638693286.24.DF8861F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id AC794C0003
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:48:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ovA/s+7s";
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775731701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iRBkiBI2x82vMKsMNZjL7f2xn2orolYI+36FdSKj7bE=;
	b=u4EaMC88WoZBFtui2YgQz9tdiKn0NBCkNFKpMS9v0JyJYkkr9JyDWdUSPGKrVNEk0la3r9
	lQdfCaJEzIqhvfQm0bxgMon9JWr0HTEIYt37dZJbXIX3eec61T7V0TJu1bNA/ty0RndvzZ
	P4oKSAJZ910Ar4ZFTg+ttwIXJVM+Mts=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775731701; a=rsa-sha256;
	cv=none;
	b=WKvXgvC2A94uuJgwfW0THwI1wjAL52Zr9M8s9Z7uHdFRP6SuCpS3yFd+LB71FUl3lsm1n2
	KPMj8fFrkhKKo/8Z8IKRIBBbCUyLk8yqckjvOgfeXFCcv2dnCdY4OzAC9Yqk3eFmObwMh8
	RgqkglbextXKCJVmlrItn7CPvnNGoz4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ovA/s+7s";
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 985BD4183F;
	Thu,  9 Apr 2026 10:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB469C19424;
	Thu,  9 Apr 2026 10:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775731700;
	bh=Jx7gEXI9vJ/oyMVdgHUEoqOvId83JfYBNs7L/9ysO+w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ovA/s+7sTstzRC1cWBwDEAQ9EYOpR2DEwLICJDIAaYmEu5gPZKeeEhiNCt+tM3i3+
	 UsULDu5W9SYWMNSuC+skESNI45NKwkE+tKBm/pjACs8evI83EP4StmGwhQ6M5Hl5zr
	 AH9J8IlwAb2jJLXRtLYYBI8tMtlBBcQyfDHlKL0QVfFzNM5pzKj4lIctiSmMubmyps
	 6VZAd9xOKG0crUT334xKGfEDP8ajbOPGCujwnHTuwOL/bg1eM65Y3VYGtYc7Ud4ea4
	 KUTecHfl+4Jdbg1lUhBfvzeKDfaNkC8qcv3tnh/kEzj0jL1cSL9HBzlgBLuTRbap+s
	 Hky0OaOkF8XUg==
Date: Thu, 9 Apr 2026 13:48:13 +0300
From: Mike Rapoport <rppt@kernel.org>
To: CaoRuichuang <create0818@163.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	Liam.Howlett@oracle.com, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: mm: stop relying on killall in
 charge_reserved_hugetlb
Message-ID: <adeD7VijQIaT8gWU@kernel.org>
References: <20260405213126.1161-1-create0818@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260405213126.1161-1-create0818@163.com>
X-Rspamd-Queue-Id: AC794C0003
X-Stat-Signature: dx3mw73b7o163qk98x8no8y1zqrkxcck
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775731701-10626
X-HE-Meta: U2FsdGVkX1+BtRQFtOs36+NlbbQh29yVyBVhs/ljxZMlPqwl7GuXT9nwGyfdXzAGaFJJComM3SRCME+GslXU2v4oUJAfvIoxGM9TZgo2GefdSS1/CJqrlizzFrr6PZxpXD3LhHF2VnGqwFu6zUL1Col4h4U78v2u9VTcwqXPlmkAJB+EBabITBGc2nPX/I8ekWhEc9QqhdOZBF0ibjcbV13FHw+iJUmGxCyq2dNfNwsrCME6ai4k3BKgyzR/Vg8158X5gKcN8YqJURrP57uboUmbPmhASE0AF7ZgnboayGyCdYemZlThIdzf8In4GW5OOrLZAE8HOf22VvgJ+Rl2dLkoCm1JKpAT/JBLHSXbnGKNLF8XJ8zraNeKPk9ErUHxgum/6PoO2h9OD3e6ppo6mI1/muJS6zvXfs2E6Q7XzYJiHtiE2wUJnFzvTwg7T5AiJ7sjWkaORPr9c5On8/RA+OJfT8Kx8R0yXkLgYgpISAI9DhQ1wqQrwH1nZF5Kxi0xiCW+F20iIfuD3AsvLF8UbzyQeOAUEAYSNEUVbLS6DT79pWJpk8QRl1iML9wqqEL9618O8/QgKOpBZH1pxFBSZ/cEZO6x3UeRCNYJyIbXsQib+ClUNv+7YzUHX9JGCvengSyt5D4mBWhD3C9XDqQQCxhAt1KRKUPxZMNgoP5WEy+iZoGpWltBDCOM2V+GJn46KdcJmUaGcmGQryEknfR3OGeF+tYbPCROYsUN4zH3DDkyHF8ZaGYg15H5kGEEPiQD8UQApjFXlphsNK3h5osG8EeiWcVUYIXgyAtcP2cU4TVTt+rotO508Aw67jS5I0SblxKu5acYtT3f8+l4qL+TQWNYHxLaYNfoPY2o5mAvLU1LnTRqxuNDi+P/xZVPjI7deuGPtFs4fq611tctA0ak9x53umTK59qNdhBk6lYg0Xg1q1gCGTUrszylD65JE71uLZe0g7+XWUXtQXWRcTp
 DaeHgRHf
 YCJRf1MOZa2dLBl7qX66MGyHFfuHxcfQwtHeHd5qTE57JWko9HH0ZD5gsUN1+fa/Sd/8ViCAIASe9UqlOfS/LbMbaEMWFz6mRBVpoLArVbyNTWuCTyf6FSUsWUJ/swtqPBnHGACtxIzht7g6uNRMCymjjH+knwoV6lQo2Hwy2LO0biic6Fi4shR90iNYkjxD1nwwFK216gWDnanG3tjhgPaB6qFGqpjteA2nRvWH2KOnZSZOn7cvxQRhdWUcg4UblYrtJVyyv8aX+9+spXbnkzoO+cxcyJOeXgcZIpCEZibhVV+TNDRSLg3I7TnRpI2sVtMyzOm57+6F81ZE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Mon, Apr 06, 2026 at 05:31:26AM +0800, CaoRuichuang wrote:
> charge_reserved_hugetlb.sh tears down background writers with
> killall -2 --wait write_to_hugetlbfs. That depends on killall from
> psmisc, which is not installed on minimal Ubuntu images, so the test
> fails in cleanup with "killall: command not found".

Can't we just skip the test if killall is not available just like we skip
it if it's not run as root?

> Track the writer PIDs we start ourselves and signal them directly
> during cleanup instead. Make write_hugetlb_memory.sh exec
> write_to_hugetlbfs so the recorded PID names the long-lived test
> process, and redirect async output straight to the temporary log file
> instead of going through a tee pipeline.
> 
> Signed-off-by: CaoRuichuang <create0818@163.com>
> ---
>  .../selftests/mm/charge_reserved_hugetlb.sh   | 25 +++++++++++++++----
>  .../selftests/mm/write_hugetlb_memory.sh      |  2 +-
>  2 files changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
> index 447769657..757df4878 100755
> --- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
> +++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
> @@ -44,6 +44,8 @@ else
>  fi
>  export cgroup_path
>  
> +write_pids=()
> +
>  function cleanup() {
>    if [[ $cgroup2 ]]; then
>      echo $$ >$cgroup_path/cgroup.procs
> @@ -193,10 +195,12 @@ function write_hugetlbfs_and_get_usage() {
>      [[ "$private" == "-r" ]] && [[ "$expect_failure" != 1 ]]; then
>  
>      bash write_hugetlb_memory.sh "$size" "$populate" "$write" \
> -      "$cgroup" "$path" "$method" "$private" "-l" "$reserve" 2>&1 | tee $output &
> +      "$cgroup" "$path" "$method" "$private" "-l" "$reserve" \
> +      >"$output" 2>&1 &
>  
>      local write_result=$?
>      local write_pid=$!
> +    write_pids+=("$write_pid")
>  
>      until grep -q -i "DONE" $output; do
>        echo waiting for DONE signal.
> @@ -261,10 +265,21 @@ function write_hugetlbfs_and_get_usage() {
>  function cleanup_hugetlb_memory() {
>    set +e
>    local cgroup="$1"
> -  if [[ "$(pgrep -f write_to_hugetlbfs)" != "" ]]; then
> -    echo killing write_to_hugetlbfs
> -    killall -2 --wait write_to_hugetlbfs
> -    wait_for_hugetlb_memory_to_get_depleted $cgroup
> +  local write_pid
> +
> +  if (( ${#write_pids[@]} )); then
> +    for write_pid in "${write_pids[@]}"; do
> +      if kill -0 "$write_pid" 2>/dev/null; then
> +        echo killing write_to_hugetlbfs pid "$write_pid"
> +        kill -2 "$write_pid"
> +        wait "$write_pid"
> +      fi
> +    done
> +    write_pids=()
> +
> +    if [[ -n "$cgroup" ]]; then
> +      wait_for_hugetlb_memory_to_get_depleted "$cgroup"
> +    fi
>    fi
>    set -e
>  
> diff --git a/tools/testing/selftests/mm/write_hugetlb_memory.sh b/tools/testing/selftests/mm/write_hugetlb_memory.sh
> index 3d2d2eb9d..49164bbfc 100755
> --- a/tools/testing/selftests/mm/write_hugetlb_memory.sh
> +++ b/tools/testing/selftests/mm/write_hugetlb_memory.sh
> @@ -19,5 +19,5 @@ echo $$ > ${cgroup_path:-/dev/cgroup/memory}/"$cgroup"/cgroup.procs
>  echo "Method is $method"
>  
>  set +e
> -./write_to_hugetlbfs -p "$path" -s "$size" "$write" "$populate" -m "$method" \
> +exec ./write_to_hugetlbfs -p "$path" -s "$size" "$write" "$populate" -m "$method" \
>        "$private" "$want_sleep" "$reserve"
> -- 
> 2.39.5 (Apple Git-154)
> 

-- 
Sincerely yours,
Mike.

