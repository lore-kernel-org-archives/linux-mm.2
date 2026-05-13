Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBF8BCD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 03:10:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30F3C6B0093; Tue, 12 May 2026 23:10:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E6B86B0095; Tue, 12 May 2026 23:10:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 224576B0096; Tue, 12 May 2026 23:10:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10F446B0093
	for <linux-mm@kvack.org>; Tue, 12 May 2026 23:10:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C4F74C248C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:10:43 +0000 (UTC)
X-FDA: 84760919166.03.34C37F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0C7AE1C000B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:10:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=s5pS0SgF;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778641842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P7kKJFnLH5zWPMiI6tuQud3W3xRBv90gsCpSNsNjWOA=;
	b=VtInrDEXgbU/k8xQBAI4LNwA04zwmxGDKVhAhP/9sCODUKfa3plARco26ZbuEsBvZq5p5X
	FNYTNmH31hzVa6tiDufcAowCHryIYV1HYo4MaT09rrYyoUz2V3ikLdVhr5S1t93sLVnUTO
	cWQBWN1S/7wdhJ6rVW1G//kLn2Qgz3M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778641842; a=rsa-sha256;
	cv=none;
	b=AV+ERqXIVsck3Z33z+Ph2lmT2KRIf1NKbHJuK/K0QfN+pNbrmY1kaoYTsRUOY1G033Dyg/
	OLOHm6ItNnkw+/U6SfMr69u/7+iMaMYJAInpAmmGLc/d6fmJTCzmq3CmXBGlny0sbXOD8s
	JzXZ+9sXTQyx9lTyftbB/xyoYkggePk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=s5pS0SgF;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7AD2560121;
	Wed, 13 May 2026 03:10:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F97C2BCB0;
	Wed, 13 May 2026 03:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778641841;
	bh=vu0gwBDBN0+TJsY5BEup/tyag+dQOp0HKz2GTXrJUmY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=s5pS0SgFgTsKMvZSlWIJVsVVNwwQLETV3CkqJebs25P0NP6SKTAlrMLogWJ+5F5Ie
	 9bK7BSPaefeZ5fYVVhK4hmY8J3zk+FkHacbQeWQOl4NGtBQ/EMKPKFu6W6h6ZfNAAM
	 BwToAu8ocE3Dp5rVkVmy/sB0rxwHnSDeO1MGgKsc=
Date: Tue, 12 May 2026 20:10:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sayali Patil <sayalip@linux.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, Ritesh
 Harjani <ritesh.list@gmail.com>, David Hildenbrand <david@kernel.org>, Zi
 Yan <ziy@nvidia.com>, Michal Hocko <mhocko@kernel.org>, Oscar Salvador
 <osalvador@suse.de>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain
 <dev.jain@arm.com>, Liam.Howlett@oracle.com, linuxppc-dev@lists.ozlabs.org,
 Miaohe Lin <linmiaohe@huawei.com>, Venkat Rao Bagalkote
 <venkat88@linux.ibm.com>
Subject: Re: [PATCH v6 00/14] selftests/mm: fix failures and robustness
 improvements
Message-Id: <20260512201040.5783a643a3ba23f42777debd@linux-foundation.org>
In-Reply-To: <cover.1777877814.git.sayalip@linux.ibm.com>
References: <cover.1777877814.git.sayalip@linux.ibm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C7AE1C000B
X-Rspamd-Server: rspam04
X-Stat-Signature: tajx4e4ossr7ugm74x54kd3kpbbe5547
X-HE-Tag: 1778641841-815019
X-HE-Meta: U2FsdGVkX1/6Ivai/7/nmn11/z9ahnxOY12cw/75f6jWPpEQ18VUVpHt3oljoKePeJ9wveeUmasLBu10d+gJAM81ZdL6YY+37loKnJ2OeV9nOL3uijL7c4oikQ18/oldJJHU+4F7ixmODeJTQWzE8AvFHEyEeT07rcUbzI/P6A2pFmIc7dG1ldy0e4TxsbnSYmDjTl01kJ2NUxPSB2pVGzRswffGGGzNc8DOnyHJ5q+YuC888Fi9U8c4j+M4rQWzPA2bxVj9jbdYFsV7EybIqm7IfoPZxDLPAms4g8wbMfO8Aqh8e4TeYiPQM4DahfrdijSBVvRfs9CWnSugfw2GtLmE9NX9k1nQrDjP4FvWSRJncySJr5kgQSi6IOdlTo/6nR6Slw/iMeK7KdKc2KBoZD3yRGKwSha4L5jjpBC7/QQwK2RbHSDxFd05jPrLFjO9T4lTPgHDpzWwdvBOz5tD19H2UVXhAeXr1W05CjwmTOEkUyWuB9ARR09U7ST/YucXd77s/eBlZZGr5P2L58wwOKm32rfpvbjS1iaEIEjmStPBe53SEyDmmqy78qWUhEmAyrycc2kXqRtk6hB5vlX/ggTdpRtZJLAgPzBnP26/Qc0Ues2vq0fEVO41V+qR1M8F+5UxveLt1rRTL/cTJ4uTCcdkdyRduec5r6r1nDxamG0e9Hi/p0ZA/HeRsn83IAtBhLgh7PPMzHkt6PCkRrXqaNXZriL58XV/MvGARaCWkdTnCuaKB+kCmeEEyaT2ulW3osUOu9+72UYYES7ljyVI34Yja6uhHUgulEevO6w3L0WpqyiF1Cs5dfsiRjr6n3CsTppmPNk5cHWuFLhU6F/Dfkkr6S7ux+PEptYD93GHW3r6ZWy27jn9G+FV9ehFuPwyFvQPT3vEG4ULRBKAId2lnlB6MF07M0E/mXiN/fsUpNyFuBtysIz4O1lazJBJLwg+0IUV7bJYltosRZt5sHv
 AEg4A6Lo
 0OVKsHVzAKf8s0I/3iUirBmutOwMjn+v7wbbvCW2Z4PMp+NwTuWx7z9mkwNTvbIOAC/oEnX9KoPPlbH4WD3Bju/t1KnKf0I8sC7HWF4dEptxxa7zhxqisyqkhPMav0jwgeS+vWqP8q79oioRxwPI5Egm+8HB7VrMCprdyrFVQ/GiGUb1DwzEQzxIu9PoA1m/IzNhZzZTIWlEKQ0H9JNU21cYyU5ugFDliGeHioU0WjerE7n6p9o74erI+gu5p3HMbVDJCJ+h+7UEFNtryc9qn0dNn/Hqcvkb3YG0AsxequKxeVmZFkWNu9OkT8jfZH+xIAnohKHiyW1dMX52KakbwVaNlPlmiXgaYfmwSf3Jefq3nnaXTrhxBecURN9j9fseI34YMfRAbS0r1lFrIoeYIqvLtDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  4 May 2026 13:54:37 +0530 Sayali Patil <sayalip@linux.ibm.com> wrote:

> Powerpc systems with a 64K base page size exposed several issues while
> running mm selftests. Some tests assume specific hugetlb configurations,
> use incorrect interfaces, or fail instead of skipping when the required
> kernel features are not available.
> 
> This series fixes these issues and improves test robustness.

Thanks, I'll add this to mm.git for testing exposure.

Did you see the Sashiko results?  It all looks fairly nitpicky to me
but perhaps there's something you'd prefer to change?

	https://sashiko.dev/#/patchset/cover.1777877814.git.sayalip@linux.ibm.com

