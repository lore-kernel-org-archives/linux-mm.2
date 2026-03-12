Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FC43105A593
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 12:43:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40D2E6B009D; Thu, 12 Mar 2026 08:43:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F8996B009F; Thu, 12 Mar 2026 08:43:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FB2D6B00A2; Thu, 12 Mar 2026 08:43:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1FD476B009D
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:43:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B631A1396F3
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:43:45 +0000 (UTC)
X-FDA: 84537377610.04.4E3AA9B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2FD2BC0007
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:43:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eRUBf3dX;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773319424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fWBhCLBHGmJ8wtt0t/KRwm/Hep5/ScU15Z6q3+Nta4I=;
	b=cZKBtGGK6yaem6My+BevT/5Z8xzNCCDL8rWEorwaRqiOrVnyVr0mVO1GA3HjDWewxK0Nyq
	LYfI2JS0AkIwRfYvvxBzwcUsKNTf/jn/3lFI4TXR/u2OwcOr+UJvGYQIYphNWN4in78ESy
	nCpCMD1jnXMy4k6h2g5AnCV1ewKSnvU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eRUBf3dX;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773319424; a=rsa-sha256;
	cv=none;
	b=ORb7dEwRvu1xkezMtMv9+UnDvodOSUIBkar4nH6Vzq06xuZFOH+c9giPbW9mxo/K0ZhNhl
	uCrXCGoHbmSwHwdlKIShPmzNGtT0KTX1Fjtv9XBvEEBe2u/Kw2MaclzrWbd1zvS8OyAxpi
	h+VTW4kbQ/vEIsz6FQ7AiAp6DUfav5o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 69EF160054;
	Thu, 12 Mar 2026 12:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55DD1C4CEF7;
	Thu, 12 Mar 2026 12:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773319423;
	bh=8S9bNJmF6iH82u3xXOAn4AoJikaKrAnFf4WVKPEmGxk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eRUBf3dX6tDFd/wdJL0RAiR1hAauissEfjHzMqVRjfgm6+A8cJRjSAe1kA+dx/TfN
	 ufTmt8h43/s25vH+jIPrmSlRHhwv30uARgMBqTfJJ9yaXkPQkHPVqfyY8ppn7whChp
	 frS5QsFEy3F1KNz3/ylj/Cwi+KL7+0iGNFM2Yfr+kCfhPuT6FsDjoSfkZ1qQMntmhj
	 yN1Hb+b3I99HYlAnXrMkjez3roLSMj9i9rD9AB2BP4zwu027cv0ySlc33z8GT+3rNV
	 XARl5ZCnCHUgKcB5kbQa7s429uEUlEap6X6vSpvcQ2GM8OFLLW9JVLEQb9fOpVjodd
	 7ofK99QQPtwxw==
Message-ID: <536527d3-6ffb-409d-a119-93c13a87823d@kernel.org>
Date: Thu, 12 Mar 2026 13:43:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/13] selftests/mm: restore default nr_hugepages value
 during cleanup in charge_reserved_hugetlb.sh
To: Sayali Patil <sayalip@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Michal Hocko <mhocko@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>,
 Liam.Howlett@oracle.com, linuxppc-dev@lists.ozlabs.org
References: <cover.1773305677.git.sayalip@linux.ibm.com>
 <9d150c91d4fe18732f9a90234e6878b7bd7f61f7.1773305677.git.sayalip@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <9d150c91d4fe18732f9a90234e6878b7bd7f61f7.1773305677.git.sayalip@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2FD2BC0007
X-Stat-Signature: p5m68c9pyckwsn9nsabwjhhbqsq7sodu
X-Rspam-User: 
X-HE-Tag: 1773319423-59004
X-HE-Meta: U2FsdGVkX18p9rPFAJe+gT0OvKQne5LPH8+QntOVyhyXDKLXAOZO6ZX/foFsY/ePXeSrNcT305mJ1fTBv/9GxVtNNjUnPII+muO2G9YAIFTAo64rBZPyJJuCO8wb5hwJo+E0qqwOc6aA9THO77TGMHqQ4+Hke5Mf3JJz9kHs9qV79lIOItDwO/kM21SE1agvQARm/ILhpBNS9h6GWpv9Ps9xAjse7F2aMUA/o13SSSHlawICNOXEq0i67xXvHV/O6DapPPJTL0j1QtNhS74NMICX8Tzd5pm83/S8Do0cRNGgeKXjpgxvJbOdS1f2ICEy1GE0T+OhFyP/CsH3f5zk1vQ2aLcB6+EMWFkT7UchL+3a0I5n6gm5QuMGBS1oSDW88VweajH5nzDk7FPyHQ5n/joLQ6AJ3goSJsuaJcgBQy7YFtS9SBiMvOKC3MY+APECfNq4r7ziTPNmG7TcdqoCkdsyKI+jmddjKam7kCKmhvpQr+l3QS0JsHhpySVUDsC9Lu5SIrwcTwOJyNxcOkLa55cChDHP6FqoCQfUTSU1t04y6RASCVjfDK/D9ENHp4pRMuAEweQctxBExto+34FxzQRX4gwukDVlo2E9tvL8BodeFIJSH72mLR10fu9VD08xGcjB/lkFair/be7fdpVJjMVH3Ate44ARDOQjzjP8kvPEkdm2KcdUCKbnxd9HrxBDQWW6iLgYpluCRWQYSTn0ajq3bAlln4kI80Qw0CVUo3r8uH51k8QnzTO43siONMmxKuDfbJ4awDXtYo8SAhivFvpDlAZTShNRR5eM9TQ40ESlSGzWQD3BOxQ+31dw13eMT5HK2IdmpLqkHTWeNEqLlJyRP7/WEbVmaIGEApp5IyzwW0Sa1v3X1piup8b97ZjEbLqeB+UH2zTA5sAKJcHDlyu0yjtqrLJm8a/9In06YiCg17IKu2/qKuYQU97//GVgh9janPwtrwMNKx2hylP
 +1TsmtJe
 u9Hv4JqiBXkNl+j4m3x6JRqk6dnBfKgArYz2K0cpG+q8+MGVm+mioqI+BnyyICyirm/wGX1Z+hTNVR/M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/12/26 13:25, Sayali Patil wrote:
> During cleanup, the value of /proc/sys/vm/nr_hugepages is currently being
> set to 0.  At the end of the test, if all tests pass, the original
> nr_hugepages value is restored.  However, if any test fails, it remains
> set to 0.
> With this patch, we ensure that the original nr_hugepages value is
> restored during cleanup, regardless of whether the test passes or fails.
> 
> Fixes: 7d695b1c3695b ("selftests/mm: save and restore nr_hugepages value")
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
> ---
>  tools/testing/selftests/mm/charge_reserved_hugetlb.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
> index 447769657634..c9fe68b6fcf9 100755
> --- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
> +++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
> @@ -65,7 +65,7 @@ function cleanup() {
>    if [[ -e $cgroup_path/hugetlb_cgroup_test2 ]]; then
>      rmdir $cgroup_path/hugetlb_cgroup_test2
>    fi
> -  echo 0 >/proc/sys/vm/nr_hugepages
> +  echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages
>    echo CLEANUP DONE
>  }
>  

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

