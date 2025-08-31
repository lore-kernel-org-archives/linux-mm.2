Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69BE1CA0FF2
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 20:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A57988E0007; Sun, 31 Aug 2025 16:07:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2EFA8E0001; Sun, 31 Aug 2025 16:07:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96BCB8E0007; Sun, 31 Aug 2025 16:07:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 850938E0001
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 16:07:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2F9A213AA5F
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 20:07:09 +0000 (UTC)
X-FDA: 83838136578.28.D0519EB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4ED1B14000A
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 20:07:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MS8LM6Br;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756670827; a=rsa-sha256;
	cv=none;
	b=H0idVcOTQaNLVhPZH7EtdpEyHL8ASGK13W31ysj+8q8JVpsZwf/2yL565vawi+lmwyvvGP
	X+ZYulTgI1Ois39Jwkr5yxdRqoP8GaphzILUTC8uTpYr6sRvdA8xHdXfw9Kq766KKWQNdg
	Hjl4/nvrP2PJwztwk2vQcoHyUgTgGQE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MS8LM6Br;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756670827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wsnQHQtOjEsrk5LwzayKHsCA53X5jYtCABISMzMGcpY=;
	b=MjhxdLOhDVTmL7wk+eww1zJRfmyRJq2UpVxfzBeYR6Eg7NkFFE60Z4Ws1qexf2ePH0MwTC
	w6wlfEKWkBKOePAc8ygnD2qalMN9V3byE88yazV07BjJYLlipGJ/QnByAEvase1xrbZzKt
	TPSNlyh7hSaboiHgiBNq7MuH8qeHuK4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6726F601B5
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 20:07:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3680FC4CEF9
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 20:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756670826;
	bh=wsnQHQtOjEsrk5LwzayKHsCA53X5jYtCABISMzMGcpY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=MS8LM6Brjp3YWCX6+0c7otTaxb9ewRKJ3502T+vaFkPzThUGd3n23tlgj8iFbtQeI
	 oQcBBlO4sbGq9ksfwWjUJWV9BNLJ7TFkNVp6+G81ThOSz7oj4IC9b6y6YvlGVY0lpn
	 4fJNgOUtr2lamLh08xY3SusSDz+OJoUCBt12to59Qie7g9Qf9XllySPSxP9JY6nESi
	 5x7uQKuLeZRmFO71B+4RzB2DDKt/KpsEl5DTQj50eTrtrMbBN7Fhrzb57yggDKKNxr
	 tC/WJEWT3rS+uNG3kGNYRdHx3qh8Wyi5NBI5E7fhCbgG1IWZk6WJrFVGG6loD5UUmG
	 gGXwjn1gnWagQ==
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-71d60157747so28091667b3.0
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 13:07:06 -0700 (PDT)
X-Gm-Message-State: AOJu0YylG1/vdyV9WCejpMGPxJp6gFQ8CTHdxO2L2ZXJox6RvJUifr4T
	49O7//j72kv8PNeaJGnSypfKreNmFDZgw6GPyKOffYvau1EA1CIEjSL3z0dKC1JcnsAhRxp1gOw
	cbOUFAsdDSLynpKXAdnJOSD/6FBXiU0Pa0BSa+tmMyw==
X-Google-Smtp-Source: AGHT+IG3GaqCHReEFS8Kk0O0HYcyQ3az2zl3VkJpMwaXeWGUAfnqR1acr2/2mqUAcOK53WHBMmNZ7sBWNWn2cZcW6zA=
X-Received: by 2002:a05:690c:6704:b0:720:378:bed6 with SMTP id
 00721157ae682-7227655f628mr72942507b3.41.1756670825451; Sun, 31 Aug 2025
 13:07:05 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-8-ryncsn@gmail.com>
 <CACePvbXB-G5vhoEt87BZcjDZ8kZWo3mZtAZ60YbR_gcjnPz29w@mail.gmail.com>
 <CAMgjq7Aznd7=m6JTNGM4EyFj+6pqHTRBCo2hsQL-cKi0LZggOg@mail.gmail.com> <CAMgjq7AdauQ8=X0zeih2r21QoV=-WWj1hyBxLWRzq74n-C=-Ng@mail.gmail.com>
In-Reply-To: <CAMgjq7AdauQ8=X0zeih2r21QoV=-WWj1hyBxLWRzq74n-C=-Ng@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 31 Aug 2025 13:06:54 -0700
X-Gmail-Original-Message-ID: <CACePvbVJY9x05nW_jWd4PWox972OqMxi=YFP_wGbjHzXFyvY5Q@mail.gmail.com>
X-Gm-Features: Ac12FXzteZ0lmimyc9FHu-eqbCwqH9k6tlWXgsNJCJjhM-DO2tVOgzinsSJIxmQ
Message-ID: <CACePvbVJY9x05nW_jWd4PWox972OqMxi=YFP_wGbjHzXFyvY5Q@mail.gmail.com>
Subject: Re: [PATCH 7/9] mm, swap: remove contention workaround for swap cache
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org, kernel test robot <oliver.sang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 4ED1B14000A
X-Stat-Signature: ngndb1a8kw8uq8cqzsyhsrqbdifaninn
X-HE-Tag: 1756670827-355381
X-HE-Meta: U2FsdGVkX1//W/gNnJGkpjOTxulDjePe38G6IioIKdY4SpYRv+Ni2ATLydigIPRfTKv0DH7oyIl1SqrkXSckjZQHosEcMHUmR24O6EgYe6403QJ7eztWsauMqbADk5X1PU85us2xFuixU5w00JhEuzPyTqYkizWqgN4g7OfWkUqWFnximrcI2qYP1tDpQ2hejTL6N67AVh+XMCiG/FMNO52XvmuvQx9tPlaQn5I8nhiEeZnynG8y4F9Hve3kafi4K2WlD+OV+McfaSyJVBX6OZnDzKrAS0vCzCpDIz8ilOndzRswv3yv5LZztJ6hlB3pmFlIWm2YvTKzQ+Xv9rgU0bq6yd2e+JF35JXp7Ohz4QEGqE4duCYJVcRf9O+h+91ckTwxYmJxer0DjvX6sWjCjqvr5yg14ZbpmlD4MYY1EQQACs2Y6EFjtSeEwM+kxuTe8FVaLvmr3/wyL2WpnVykW919uJn6k9ijJo6dPysILwaI3vXN3IYaRCcIXFRnxACZVm/z8Elsmo/p/WF+VlAHvXol4IBfxesIaK5TEHrVfXr0pkLXdfd/7aZ/4awsRnGHGz0nwIx5gb5d10K8gEj/v/iXOSRhw02BFG37Hczn1azhha4PZsmLL3y9otRANwuXAZ/oMN+DJXXbVc+a4XuWlH2yUg/2hcLQcFE5PtSAgwDeWfBKSzXKyUj55ochKYYowmwrYT2QAEEeLHeGlfSYbE1gm8IP15ElCRzA2rOFuoXGIylYWT1E+OA2ulspxKo6SLgWSxRfqtx9Gc6QHWfF8dEDEz4nrOl4znmKAiLNKbBj0tYVBYy57smMgJDpXbsVNCdZs3E/zhX3zhAu97Z+J4hJv1x49AgmUnez4/ndz3CLB2S8IW8xPXPbA8f4CXJyMYUFhlzXNB9D/YYzJAMvdL95iB4k0pZf+uQ1LnPpqnSjiqUJBT3iyzLpn8py2mU/Ezas8VABZ0lgI6TuiSs
 RpE0y/k7
 lSr0Obbt98uSjVn2j7CGZeqPSS8RuLzGzWiGV0lR0cyd5o/x9xPRG8OMjhafw890OTjh0M4FpgH7wUt7HqMAQOOsLB1NFmWVTfUbhhAjUJSi3Ng2jwJnJWk6GEn+RBXL3Le+JngSs/7ndiukxmE7re/0kGDFJRU5paJ1cLRUnuMZRjRmq4QYSepf/pDXysWQT4ObLTiyixPBJZhW8LfuQ3jGh4rY88X5huz0rfUzrQgtJLc0+W8QNTGva4s7U1qOSbtBlKYuIp9bEoTfRsMWH8geoZe9O/i6GNEqwjLzL3L6Q9AcSmc2iWesThfN5jJFrF/BkCBPEYokwOMA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 31, 2025 at 8:55=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> So I tried to run some HDD test for many rounds, basically doing the
> test in the URL below manually. Test is done using nr_task =3D 8. The
> HDD swap partition size is 8G.
>
> Do the preparation following:
> https://github.com/intel/lkp-tests/blob/master/setup/swapin_setup
> (Make usemem hold 8G memory and push them to swap)
>
> And do the test with:
> https://github.com/intel/lkp-tests/blob/master/programs/swapin/run
> (Use SIGUSR1 to make usemem to read its memory and swapin)
>
> Before this patch:
> Test run 1:
> 1073741824 bytes / 878662493 usecs =3D 1193 KB/s
> 33019 usecs to free memory
> 1073741824 bytes / 891315681 usecs =3D 1176 KB/s
> 35144 usecs to free memory
> 1073741824 bytes / 898801090 usecs =3D 1166 KB/s
> 36305 usecs to free memory
> 1073741824 bytes / 925899753 usecs =3D 1132 KB/s
> 20498 usecs to free memory
> 1073741824 bytes / 927522592 usecs =3D 1130 KB/s
> 34397 usecs to free memory
> 1073741824 bytes / 928164994 usecs =3D 1129 KB/s
> 35908 usecs to free memory
> 1073741824 bytes / 929890294 usecs =3D 1127 KB/s
> 35014 usecs to free memory
> 1073741824 bytes / 929997808 usecs =3D 1127 KB/s
> 30491 usecs to free memory
> test done
>
> Test run 2:
> 1073741824 bytes / 771932432 usecs =3D 1358 KB/s
> 31194 usecs to free memory
> 1073741824 bytes / 788739551 usecs =3D 1329 KB/s
> 25714 usecs to free memory
> 1073741824 bytes / 795853979 usecs =3D 1317 KB/s
> 33809 usecs to free memory
> 1073741824 bytes / 798019211 usecs =3D 1313 KB/s
> 32019 usecs to free memory
> 1073741824 bytes / 798771141 usecs =3D 1312 KB/s
> 31689 usecs to free memory
> 1073741824 bytes / 800384757 usecs =3D 1310 KB/s
> 32622 usecs to free memory
> 1073741824 bytes / 800822764 usecs =3D 1309 KB/s
> 1073741824 bytes / 800882227 usecs =3D 1309 KB/s
> 32789 usecs to free memory
> 30577 usecs to free memory
> test done
>
> Test run 3:
> 1073741824 bytes / 775202370 usecs =3D 1352 KB/s
> 31832 usecs to free memory
> 1073741824 bytes / 777618372 usecs =3D 1348 KB/s
> 30172 usecs to free memory
> 1073741824 bytes / 778180006 usecs =3D 1347 KB/s
> 32482 usecs to free memory
> 1073741824 bytes / 778521023 usecs =3D 1346 KB/s
> 30188 usecs to free memory
> 1073741824 bytes / 779207791 usecs =3D 1345 KB/s
> 29364 usecs to free memory
> 1073741824 bytes / 780753200 usecs =3D 1343 KB/s
> 29860 usecs to free memory
> 1073741824 bytes / 781078362 usecs =3D 1342 KB/s
> 30449 usecs to free memory
> 1073741824 bytes / 781224993 usecs =3D 1342 KB/s
> 19557 usecs to free memory
> test done
>
>
> After this patch:
> Test run 1:
> 1073741824 bytes / 569803736 usecs =3D 1840 KB/s
> 29032 usecs to free memory
> 1073741824 bytes / 573718349 usecs =3D 1827 KB/s
> 30399 usecs to free memory
> 1073741824 bytes / 592070142 usecs =3D 1771 KB/s
> 31896 usecs to free memory
> 1073741824 bytes / 593484694 usecs =3D 1766 KB/s
> 30650 usecs to free memory
> 1073741824 bytes / 596693866 usecs =3D 1757 KB/s
> 31582 usecs to free memory
> 1073741824 bytes / 597359263 usecs =3D 1755 KB/s
> 26436 usecs to free memory
> 1073741824 bytes / 598339187 usecs =3D 1752 KB/s
> 30697 usecs to free memory
> 1073741824 bytes / 598674138 usecs =3D 1751 KB/s
> 29791 usecs to free memory
> test done
>
> Test run 2:
> 1073741824 bytes / 578821803 usecs =3D 1811 KB/s
> 28433 usecs to free memory
> 1073741824 bytes / 584262760 usecs =3D 1794 KB/s
> 28565 usecs to free memory
> 1073741824 bytes / 586118970 usecs =3D 1789 KB/s
> 27365 usecs to free memory
> 1073741824 bytes / 589159154 usecs =3D 1779 KB/s
> 42645 usecs to free memory
> 1073741824 bytes / 593487980 usecs =3D 1766 KB/s
> 28684 usecs to free memory
> 1073741824 bytes / 606025290 usecs =3D 1730 KB/s
> 28974 usecs to free memory
> 1073741824 bytes / 607547362 usecs =3D 1725 KB/s
> 33221 usecs to free memory
> 1073741824 bytes / 607882511 usecs =3D 1724 KB/s
> 31393 usecs to free memory
> test done
>
> Test run 3:
> 1073741824 bytes / 487637856 usecs =3D 2150 KB/s
> 28022 usecs to free memory
> 1073741824 bytes / 491211037 usecs =3D 2134 KB/s
> 28229 usecs to free memory
> 1073741824 bytes / 527698561 usecs =3D 1987 KB/s
> 30265 usecs to free memory
> 1073741824 bytes / 531719920 usecs =3D 1972 KB/s
> 30373 usecs to free memory
> 1073741824 bytes / 532555758 usecs =3D 1968 KB/s
> 30019 usecs to free memory
> 1073741824 bytes / 532942789 usecs =3D 1967 KB/s
> 29354 usecs to free memory
> 1073741824 bytes / 540793872 usecs =3D 1938 KB/s
> 32703 usecs to free memory
> 1073741824 bytes / 541343777 usecs =3D 1936 KB/s
> 33428 usecs to free memory
> test done
>
> It seems to match the ~33% swapin.throughput regression reported by
> the bot, it's about ~40% faster with this patch applied. I'll add this
> test result to V2.

Oh, wow you do have the HDD number, congrates. Now we can make the
claim with numbers.
I hope you did not cripple a HDD to get that number.

Thanks.

Chris

