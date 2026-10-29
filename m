Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFA73606A326
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 10:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pbM7HBm0
Received: by kanga.kvack.org (Postfix)
	id F20D66B05B4; Thu, 29 Oct 2026 06:35:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF8416B05B5; Thu, 29 Oct 2026 06:35:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E36026B05B6; Thu, 29 Oct 2026 06:35:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B8EAC6B05B4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:35:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 581F2A0383
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:35:32 +0000 (UTC)
X-FDA: 85375307304.15.0089F10
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8003380002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:35:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=pbM7HBm0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793270130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G+dOdTKmIbVkiM3lsAF+c1rAUHzJmMdTQfVlB9f5eEM=;
	b=bgRs0oTbGa7zymywlR4ASnArWIyB6ZKTOM+MdRRA1hBuHqpEPjOcBE6IESnngOMARbEOgA
	k87yy8goUWUXKASPXicgbHeoT/GZGPFI5psIfYC/yleuMoB15R+7qDfcVbtrUQ+VAo+dhY
	cS5KA9/NbsGOnImdkFUyr/g3H2bk498=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=pbM7HBm0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793270130;
	b=c1BtpqXV4vcqTb4X9kXGMX0hUGoO7EskDeVTisBHW2dDed0xwAfjSdIC2E33XTQfl0QdZr
	UzZdgTZ/7SpZKyMH+YXsv0AMWsDpqqkLFlYJlCcAD1K3NcSxrmOi9MAyUXJ32vWIpsgmis
	dB3QV69cWRWqOsAgK3uwwGjBerk+sII=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48df0fa43c5so318877f8f.0
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793270129; x=1793874929; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G+dOdTKmIbVkiM3lsAF+c1rAUHzJmMdTQfVlB9f5eEM=;
        b=pbM7HBm0Ndiru11DD3yjOMTyyH7sX04bG6ik/4Zbw6u9sosP8a8iYr02nWOG0+2uZy
         iQItEpB8HV6pDBRacgl9rur0kt+a8SsY7km+haOTiGCJ2qSOUIHfr4k+obZ/G3UdgLoI
         C1IEogaoRxc1GDpbuYwS4tpuGN93eDHVVd7WAB0uppaYFRvqmbQ6VgML46XZIt8ERemI
         kp9qqbwoR9ZgyG/YyOz29i88APlVt7ww4CNGGpVgnOZF53K78SV5hjtGt0VEPoE2N7/A
         0DVO9p/ROGsxgT8q6l23r1AbAAx03pKD7Mhveb2PMqnkdOQQ1gRetCA5oghahx2gS78p
         nVmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793270129; x=1793874929;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G+dOdTKmIbVkiM3lsAF+c1rAUHzJmMdTQfVlB9f5eEM=;
        b=cZ4OT3lDbvB8OO3LvpLaw1WXVb2O1oN6RTOhc5iWldbP79Zxp8VNukbxRn5rdyT/5P
         /yGbFBfnLzTy4z5XcenAkLLlf8FhV5R2Vf58irpALw51B9rersWdK3MDYhZB05g+jE6S
         N99nozuLPZX8Y3pAKH0+Nsrf0UBgDpUKrx9i3HRf2krqX+ppsDQS8i/FHp8cLYTHIHo7
         oxM88CPyWLGzIQq4a9C2tJkQwAVltn05udy+LLNj3GfDvIkkDvIf4+vbNzssEQm1XZnW
         48TyHaIQD/vWNS5TmwpaDZ4K39Pzo/OFfTREkyIjKkP8XB7nHSUA0GPCPTlQwFRJbqeo
         Pdqg==
X-Gm-Message-State: AFq9FYItNBqaLjByMIrfLmC1spBYL3QijSFPbVlY3b6q+5+Cxtur/gKw
	DyHLsiF5vcP3csE1sq6OZ2aTaVlhUj8Xp8QHWJFBky1fwvEmZAUt0K3T
X-Gm-Gg: AYBFou0APuOAEhc1RH559ovUUqVx41ebXbzkptiT3o8LLPRZnALCXT+2y58vYyHmXzA
	ndiGfNhtnYE+Y2ZSbl9jzlvkTAhTRAJIgFuSsTTismhWfLCIYcDpC43haKjyjNn4+BG8HQUKM3b
	53O1IrIRfncyQe4zQF7GW01kDhqOMHn3NGj/S/fxZkERdMl5w5IMdLRAjmHliLzmkVdnKxU7/jL
	H0KK6fn7EibnvEDbvU1TZ04W54ll4hTOsZukihncReoxo+2Ref33qLLK3Kn6BmlcfCETbhjUknX
	bVY1MSdHdymsa7sLJgX1637CpiznfkDl9+OBYvhS7WwLRof8cmXcO5dR6Eo5h7lgGDEqWU5lJen
	73LTBAKTayzUlfiIvQ+y4YzGF2RYs3AHr7GREBH1eYk9npCCMRrFTwB93CMq91WGJpOvdz06/6t
	om3gxG0ooQKayNIORjuljY8I2JFYlz9g1LuunSwRQ3LL8Tj3THg2TFu8TJmEQ/Lc8thqExGhoXL
	qtCogfz9cr0yLhB7825RxVwEZNC4yZx9AQGSL8nLaCJCUF8EpL2bt4TusBl9AaAXwyW2sLsRj9R
	SXADcYcUrRY36m/EFNb2ZmJAGqoREWiBqxAp6S9SEk+aiQ==
X-Received: by 2002:a05:6000:2893:b0:48e:5e63:27fb with SMTP id ffacd0b85a97d-48e649b1219mr5739523f8f.20.1793270128547;
        Thu, 29 Oct 2026 03:35:28 -0700 (PDT)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecd8ddasm36580278f8f.48.2026.10.29.03.35.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 03:35:27 -0700 (PDT)
Message-ID: <3b80c557-ea63-4d32-8901-3f7939ff541c@gmail.com>
Date: Thu, 29 Oct 2026 11:35:26 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] selftests/mm: load xfs before checking for it in
 run_vmtests.sh
To: Qiliang Yuan <odys.yuan@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261029-bug-selftests-mm-run-vmtests-xfs-modprobe-v3-0-16ad772850ee@gmail.com>
 <20261029-bug-selftests-mm-run-vmtests-xfs-modprobe-v3-2-16ad772850ee@gmail.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261029-bug-selftests-mm-run-vmtests-xfs-modprobe-v3-2-16ad772850ee@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8003380002
X-Rspam-User: 
X-Stat-Signature: hhqtg8bmc83fcuha7uy1akawzmx5okzt
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793270130-375953
X-HE-Meta: U2FsdGVkX18JvHhE4wwqxIKo5kS0JE7OsH43Yc2yBgUKHzpbnk1TsJ6u/2JA3wO6Rj10+AWAjVXwzdZh179WnjCSMoOuGTyRVF/2v6C3++rGygqXIbqWBdSzUsV7c6yHMpsRiLTiLrYzyMXKqUrqEYtDveF6f5pjln6WDR3rDP0B2N3WY5hNM8V3vKK9R/vx6pyjNNYJc7k1UBDD9pPieQw2NXNdGgBDxbmNjxXr5M+1PNXranrdkwBK9SMlMlN1dWoQoAYjNLIhofhLECD583+4WYPW7RhAT8atXFa0jEOIszqYSDnMgCe5gnV0LKLydu38lHalQjZGtqoKZIh6ahencFQECgAfothZigWvIzQ3KkrRBbIOsnvoKE/js+No96TAocKDsXSu8/sfNvqXMO8Ur01Wq1r3FqR6aeOiimVCWb5SuOnvG0q/M0vsjrjyx9McblNfVTj8tgBHxs/Z/d2ARJtzupbFdMg/f8m0qK4OGHhztG4pfPfFs573AXIdxXthftqx/Gxx1IHRYqoQU5sc1IJo1DTuwXvZCHES5mGHiG++e/tMHQII1VtURdwdoUevej1HkPW0mxDFS8cmarLhjwLBNo+aPIHPPnkHqJOwpdhskxArNaxfKAytgL1PxTlC2eqg5riNr43uEI4SLxxSo7h6yzmzyJMMFvE+glvzDJ1a1NAU6Wloa/0SO7z7SPHTVSIRIam4PDXzKgjjramG8bVcj0sxzrF7O0qQEmtcpob/07f1YjRVM5HzZGbw9Pe1bEkwtrsDEBNv9DKIGTemMk9vzwwUgZuMnOy5pz0686RYKPbFQ+fQXzLpq37R8QtXdmmIcdpgGUbnslzmdDt79613pad7KHlzMW9pd260HqAhn5/1JRQI2zc1wYmRYZDt+hnGnx8nGfiseBfEO8WgJNHNGBzB73wXx+LLRwBNZBpZpy/hdehTvBztXS30AlL75t8L8j4y2QSxwL5
 6xq8OpYk
 uzX6BgJ05jAS/UHjkmmxUoL34CCrgEpRa6zX+gq7KFAW483plOm91QCvM7S2Mx9A3SNxDizElo5wqM2LHnFe6oro6qQ2EWahoucFszaXsk7rC3hLPvM8r+ANSnQ7XI2dj9X7IapwZ+ZlwvU+FmzbzBG8jAXmdEmI9db/ir4KW0RuDFFtmdtB9hjCBgHwzOR0XYq+99huMilat4av4RlOfa6iZIWq7RkhhN6vGejIRN4fpO5hTgqeRxtPHBq3SoByfP6VfdzGOd6G1jklDUPNWGBwDU/KtyKyG7iZ4XF4hp6SJd3yzV5XJ5CkXZwnbouSIRN5jFjcI6Ztsxj+vK9uynHg3vKPST/TlBnSXjHuHfH6tLdQIXGGfoF8n9gSXM+8Ji+HY4vu1hw3y9uzffnk3WEU26IjXDWroEbU8Md08iCTE3hlJChEmgt0IChjuUsgw1+PvAor62ZdOKpCxGM99/W0FOG9zMJmiEdoBlOGF0tZgbUHhpY3GJ0KyKIIwy47z+KOE+KFdqrPUDrCkJq+eCO5zD5uiPJRo9MDYp+yWZ7XLtssgtt5VZIxb+tHkyOs37h01VO00obU9+0rg20RKindAXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/29/26 7:24 AM, Qiliang Yuan wrote:
> run_vmtests.sh creates a loop-mounted XFS for "khugepaged all:file" and
> for the pagecache folio split cases of split_huge_page_test, since
> tmpfs does not give them large pagecache folios.
> 
> It only does so when xfs already shows up in /proc/filesystems. When
> xfs is built as a module that is not loaded yet, the check fails, no
> XFS is created, "khugepaged all:file" is reported as skipped and every
> pagecache folio split case of split_huge_page_test is skipped with "No
> large pagecache folio generated".
> 
> Load xfs with load_module() when it is not registered yet, so that it
> is unloaded again once the script is done. Match xfs as a whole word,
> as "selinuxfs" contains it too, as does "vxfs" on kernels before 7.3,
> and would otherwise skip the load and leave xfs to be loaded by
> mount(). "run_vmtests.sh -t thp" with xfs built as a module and not
> loaded:
> 
>                                         before    after
>   khugepaged all:file                  skipped      run
>   skipped split_huge_page_test cases        43        0
>   xfs loaded after the run                  no       no
>   xfs loaded after the run, with
>   selinuxfs or vxfs registered             yes       no
> 
> Fixes: fc4d182316bd ("mm: huge_memory: enable debugfs to split huge pages to any order")
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
> ---
>  tools/testing/selftests/mm/run_vmtests.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index e104a9c6fdefb..b422edc2e2664 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -412,7 +412,7 @@ CATEGORY="thp" run_test ./khugepaged -s 4 all:shmem
>  # Try to create XFS if not provided
>  if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
>      if test_selected "thp"; then
> -	if grep xfs /proc/filesystems &>/dev/null; then
> +	if grep -qw xfs /proc/filesystems || load_module xfs; then
>  	    XFS_IMG=$(mktemp /tmp/xfs_img_XXXXXX)
>  	    XFS_DIR=$(mktemp -d /tmp/xfs_dir_XXXXXX)
>  	    truncate -s 314572800 ${XFS_IMG}
> 


tested it on x86_64 in qemu with lockdep and DEBUG_VM, xfs as a module
and with SELinux on and off. LGTM so:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Tested-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

