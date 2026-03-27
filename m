Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9908110F2862
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 18:25:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F00306B008C; Fri, 27 Mar 2026 14:25:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED7336B0095; Fri, 27 Mar 2026 14:25:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E13CE6B0096; Fri, 27 Mar 2026 14:25:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D4A016B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:25:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5A67EBE986
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 18:25:46 +0000 (UTC)
X-FDA: 84592671492.26.924B900
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4F77A14000A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 18:25:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MwSdF4sS;
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774635944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lrNHzYm4qPXJNljf+cYBVncFGgCG3er6U/W9P+ONJIo=;
	b=cJIkKxK9VST3F9dCuoaBt1obVhnwlGlGgFY2wdkEiZKbIex3lMFcB8r0bVAfTb9QjAzrgS
	qNLEe6BYXwB8WiyY8mVN+6BshPlkPqUkVQFzx9LRM0jvv5++gGcllhW6rHQXwxL7tx33gy
	MOmHxfRdpESX9B4+gE2YW13Dq1kovAk=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MwSdF4sS;
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774635944; a=rsa-sha256;
	cv=pass;
	b=4b1c/1ITvVsh6GgtXqa+UvBUn6bdeSn8cxrgE4ksh3co5x04skKSFku5zMHAnsJoQtV8fI
	IMVzQbIbhSK0ELWkfj6x8FMR1+oZF0Isd/2OaZDwg38IpfryqOWgGDTyXsQzSNFFzjiL2i
	n1CQqIDBbQiNl1hYTGKgHjJJWHAn588=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-43b87970468so2308238f8f.3
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:25:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774635943; cv=none;
        d=google.com; s=arc-20240605;
        b=Ad5FF7KDVSfPDUm9sNPwyNP6klJD1f6ZldcmLpDT6saVUk0wtWoAhmzBEppA1DmqFl
         m+Jn4KhZL7J5Rb9IA9jib5hj2AMNebcjdNlYCTUc5IfZGX1rFGXij7zTKoZJCutT6B/3
         BgskYufIOrA8nm05JPtwwPWSM1VBcvaAIlEQLw+qEioUlBTBhFeEk7OF7dPNYDOYvjzJ
         XF8F5Pm5gjAAOffrj+PBDFBOoMdwWE95P4707l9Ui2NjxqpUe2YbOFKAvkHDr6uqMPvo
         lIqFdK8D2NFWw6y2Ysm7peuwQkGsP/hT5C/RJLri4FCP7ENocoDtYxz0UUnzqy3/UX05
         wxAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lrNHzYm4qPXJNljf+cYBVncFGgCG3er6U/W9P+ONJIo=;
        fh=DT/OlUJ+4E7JyNCezYUIqKLqXD6lJ+qJQ2flFgKFH8U=;
        b=juwyYcef5Lc1A1CixF06Na8kqWb4z4ZiVF90EVQJ0L3ziwLceagSJOlxNkj02NjL+m
         QiQVJkTObdBUWaaFfK7kuS0jhEOYenbUzcBrlQeg+9oFQRr/q0xjLKESaFhyMjKT5bho
         3QnDflL7s4xutGG3nIV4bSg5faPqAWtdQ8cgc73/Fyjir5kaHgE8V6UEGpIdiaNfPUPc
         Wvrwk0c4aHIdPOGPzKa9yXYn6kbFeC6QGPi1ZK/tKZhNPZPeJQMEYcDfK0W0s0v9rFhZ
         0dE43yar02rYif27Lp768su/7HuqW6xLsFJ9v8cOSLAhD5kdyJugr0+j7xB/QTAMH7Bx
         Cgkg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774635943; x=1775240743; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lrNHzYm4qPXJNljf+cYBVncFGgCG3er6U/W9P+ONJIo=;
        b=MwSdF4sS2VEEiiqLPQss3ttQRmoABafbfDhPl0GB8Ua7WYsywwPXWnUDKq4/3Gs4G+
         pPCQ7xI6jj3JkoDQ3d4kgT6vMAE0/ak6YiJ/pkOiEZddytHoCV3MAbVfTf9A6ii1r+9r
         JUwqBLVm7EX3WwwaellcoJ1ijuu2JLwAWbqTC0o4x43TUgVYpRMNQRgQ2M+XJb0u1+be
         aCpSzPnFeNFsFv1/WvFsgGrQfTe85Ar2NzmTZUyfiYvinbRu+lV+deGKLL78dVdmmuIg
         8AOGT3ParT/Lz2Ck7sIllaMFZjPgsp9+JYvjriA8nmXgebaBFuRFFBAfYNmaGlhr77SM
         bCTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774635943; x=1775240743;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lrNHzYm4qPXJNljf+cYBVncFGgCG3er6U/W9P+ONJIo=;
        b=cz8t5Xz3kMuI3+jMX3rFEZRjhGUh31hxvMAJQEca/ir27IAs73VRAt3ttwcdL2sabr
         VOYT+tBIpqjCT7cDWexgf3ELyr5FqL6uXtXOqAo2HJDMoE4CiQpUEJImAx/923IQ5WuF
         gqiLGWxsjHW4iGeNp7TZc2NXf3kgHy1HwaBtfyyHyhzhFHPDEH00Xt/CKcwc8z5o9C+H
         ycI8+tBQ0xSkw24v5H8P6CTM6QvvAsdDTMAmUACBeWj5luUM6m3Ng+CsyLLShU6ncnho
         AxOwlFJfjSQnSjoHeDJiKjQWxWylswagkiOYwh34lxzEBaFFO+wLg24s45vpDGjaUD/W
         gifw==
X-Forwarded-Encrypted: i=1; AJvYcCUAwDZXHJTtrFrOmh6OMyuAa9n6fHZnc7dnVEQYq4pfk9nSrqtiJlnjRKrlyXIPLS8zkMayVOjm0A==@kvack.org
X-Gm-Message-State: AOJu0YyFF9lp9zCnu58dXnOvg44bfHwjzEhKsbea+nwNLZDCCcR+xSpe
	J3ikNVNNR2uhPCggG1l1/kYGMPp+4wzKMH2890qbIWR9PkLQUhF43LH4PAYvZDbMU1ZWhHiJMS6
	l9lnJgR2GM2dK31y8Xo6hsX+MbsMKcpI=
X-Gm-Gg: ATEYQzw36f6hriHtAittM+8M4Lbm2Y4xB6CX6RUsSsna2MUKfkg3Ba762QzTzmNs6Bl
	9te61jDObCYgLSo6gWQewi4HStxtB+T20o9dmKbsGftOkUd5QNH+xfnuxp+i2pwy12n/7r/vZkm
	ZXKinxX5sBTSZkJw6xEbFK7VZNFu1m40uVSToGrXfuqVm8YG0O+u8ealqYHHLX3e/vwBMcpb7az
	6ZmGVGnWvEc2IuZX/MRwjGQolP5CUirj3oj7U1QvCmMxhRtYlgmoFsLTrpqgcpLWO5wwe76Tjnn
	/fq5oKzMTnvT7ZCz7YHVz/O3230KR6e85MabjffwSO9VV4UmfPc5S+H1+Nun
X-Received: by 2002:a05:6000:1883:b0:439:b791:f920 with SMTP id
 ffacd0b85a97d-43b9ea347fdmr6458348f8f.17.1774635942629; Fri, 27 Mar 2026
 11:25:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260326032658.96819-1-liwang@redhat.com> <20260326032658.96819-3-liwang@redhat.com>
In-Reply-To: <20260326032658.96819-3-liwang@redhat.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 27 Mar 2026 14:25:31 -0400
X-Gm-Features: AQROBzABEeMvL6H1sUXu4ojkCZzUjAhuivgyunfvA6vxdRHNvLE2VWA3mFOyn1g
Message-ID: <CAKEwX=P4kt93-5iG6o34bjG7jb7CAmSRBNvjKHfMTuFN7v8gQw@mail.gmail.com>
Subject: Re: [PATCH v5 2/8] selftests/cgroup: avoid OOM in test_swapin_nozswap
To: Li Wang <liwang@redhat.com>
Cc: akpm@linux-foundation.org, yosry@kernel.org, hannes@cmpxchg.org, 
	mhocko@kernel.org, mkoutny@suse.com, muchun.song@linux.dev, tj@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, longman@redhat.com, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4F77A14000A
X-Stat-Signature: x64cz5mnzd9rkiryff34ckwsn4oqcwhj
X-Rspam-User: 
X-HE-Tag: 1774635944-359986
X-HE-Meta: U2FsdGVkX19/Hbuz7Ykf9y2NhGOM6pa3Ak8Xtk7Snke/yL9Yym26gG9HqXU2so6IvQtTfk55cvzJmKd/f8zfkfGbDM5PF/g6BTpKjAKhF5hL+i+kR50+1TNnfHxQP6RQRmSEDC7y/wBec9HVVksoJq0ke1lFUDd9S3ykqdPvhOMVrSt4G+B894VquxDcEOBXd4sKDf1A94JpUl6xJHrlbo7CQhJtWFmf312DDQi0I+LrSwaKu+4JUt60GpVxWp3U9Fqt7EDu+C/2A9IfvIeCoq8WM5kZaqeJ5BUchoB3+zrD+ERzOsjlIPDieyNJBHfRmYTGxf2DUcxsfTFvH+C8ndYjkMG8Wlqsb8CmUOtdECarfsRcAwEZVsrXelyUd40QdQALZdB1OGvtMafORqbgAWznd0LRT8e7q3nK74gxjO1dtBV+TThn1NX6VTnYz0vek66ltauq2fr+cUR90ubnEaqrqE1GARMQnrravzZ77aGvqeKKUXqDhuYUKa7ijx9cqjk8V5XLXpUCEQatFOldzZFPjln4kkc3oR6PxQv9RwiAXogYfqKtjEBOHTLdsKxONIJmrnne6V6+uWZEQkA24EFA/Ykev4DKiBSIxcW0DPEbtwMFzrMwy85yvraiCXKWLA/ws2+cLCytobdkKOW0nDEsam931S+lj3p6Bb1j7/Sjfi0ytn2VY6oU8hKQDSylkyHUIYw3YSn57ML99dHfAqICdbSPNsTvXD0cqMEQlYVm6aLExHgZzo93j3kaENTEdTSCJExLtaEnG/utX6GJZ6pQo02vSfvTCIJmRKGp8EV0z8dFJHg3evPwlfQW/LSL4t/SWsrWwDRriTgIb3v8HLT3CutjGTDxFkWwRaxpGSOy3Qh2fVSF3ftNnHK5phIsOFBTF/5+hRiF3fZtmasGyZnHX/4ookqkcjqDDe0iSfzOToCX5Mye5nl9Kp5S07o/FxKgaK5CwDDPT/7fFA0
 OQvzMxXX
 VT2dnkzJIU4LsNcS/M8ZQ0Vg4LiBv2RWoDieKllFejvYvqErEUzXoA5jrHLpY+MU2gMtPDDUXLkUkYSEtZIjSk2fRdxuscgE/w46YrouIZzGKnq0HKqyNTonMAemvVImStiRveBhWS+1TVrmJszNjYi2WL9YGzg7V44dc9wHB4BHtKlz9FhdVO+CWYqgWd8EkW+Fwx6hy74EthAzMTcwnj68tYYFD50ddS7fLUA1HjUw1ncld/oNMl46DVExYCbjKLKba0gmu/7RTBEZUW8OxMEjM2qqjBKjKa165+BoR7l4FEtbY2+KltkpFwQ64lqRMmgAd5ToqLLPGQ9j9KBEaE6iexW2SHoUPISXXRHKW57CbQAr06aPaLPMLkWYZeL8c7yNpQu6nxjuLPo1fOJs1iR/WcI7HqleMW3+BVNIJYQpzSFT6xBzB13flL8xwU9B4yevMsfmbo7ZlcQoTSrTQsqJlpe7QcFqi7grHrYzJjZQhuQNC8iML9aCI7TVuo4UrF2NSgbZQzs88iX0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 11:27=E2=80=AFPM Li Wang <liwang@redhat.com> wrote:
>
> test_swapin_nozswap can hit OOM before reaching its assertions on some
> setups. The test currently sets memory.max=3D8M and then allocates/reads
> 32M with memory.zswap.max=3D0, which may over-constrain reclaim and kill
> the workload process.
>
> Replace hardcoded sizes with PAGE_SIZE-based values:
>   - control_allocation_size =3D PAGE_SIZE * 512
>   - memory.max =3D control_allocation_size * 3 / 4
>   - minimum expected swap =3D control_allocation_size / 4
>
> This keeps the test pressure model intact (allocate/read beyond memory.ma=
x to
> force swap-in/out) while making it more robust across different environme=
nts.
>
> The test intent is unchanged: confirm that swapping occurs while zswap re=
mains
> unused when memory.zswap.max=3D0.
>

Acked-by: Nhat Pham <nphamcs@gmail.com>

