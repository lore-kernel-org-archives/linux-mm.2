Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A42F7C98304
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 05:35:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91A4E6B0088; Thu, 24 Sep 2026 01:35:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CAEF6B008A; Thu, 24 Sep 2026 01:35:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B9616B008C; Thu, 24 Sep 2026 01:35:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 548956B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 01:35:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B336A8022F
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:35:56 +0000 (UTC)
X-FDA: 85247544312.17.6E82E9D
Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	by imf09.hostedemail.com (Postfix) with ESMTP id D8C27140005
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:35:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NqmrKOV2;
	spf=pass (imf09.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 74.125.228.41 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790228154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZgV+zt06A+GVhiZtJGM9pKXkNiudT+kcv0q8qPUw5Lk=;
	b=Ic76PFp7i1xfBHJOIjmMrYMEFx7FrcmYqkWQI3vG+vYMfozG2g5Azq46RIBwZJw817ZFPL
	MPBh7d8VIJS4fNCuEPd9helhyAChnsDu5fxGDqlyhEskFwqYEm593Pdb/6VI46lOuLCCm2
	7RNbxpQ3UbRROlLV2wLRmmwarkFYiEc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790228154;
	b=cJ/9VhHR74Cn/qvHnHdK9cgjq+97Y7yLeU61m9r10HPFK12m5jg+3quKHcOJLI0hlsuxX6
	TSUlO/qFJd6LNvrVCUnyMGxuZs8PTLs3Lg54n+vazYZ5Vd/luTz0012zUZMG7JhxqYk+J3
	7fg628Tij/3uoCnp9BYvwU6NIck5CJw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NqmrKOV2;
	spf=pass (imf09.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 74.125.228.41 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pz2-f41.google.com with SMTP id d2e1a72fcca58-85469f204f6so843362b3a.2
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 22:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790228154; x=1790832954; darn=kvack.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZgV+zt06A+GVhiZtJGM9pKXkNiudT+kcv0q8qPUw5Lk=;
        b=NqmrKOV2pcxPWbzr7WcOrLHbH+waNDXa+PTJ8xVC9xG16IXQWGQ/wIpTuvbpOx+RsJ
         6hfJs+5rD6rBQGrllJ0S3kME7sTK/Qg4RzmcUY7XtauSr8lCivl7y6fGVKBp6SaGHZfF
         G+/IovBpUQUAGh29h17g3MT9OSmDWlJBwSzjZlWcUwlj32YzF/B6HPxNw1lQN/DGgwhB
         eO/wiDHdUPOMl3uASRptvEcBY0PRJcQZ0pejBCe/Z5NAtarLFgCe9vJHljRSLQof9HeT
         7pCZqLnuRKgtVbwzyQIppYoRsG3LwMHgG5Cz+S3fbLFD+U+DImVxegEd9V7Q9uo6ZVOu
         5fkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790228154; x=1790832954;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZgV+zt06A+GVhiZtJGM9pKXkNiudT+kcv0q8qPUw5Lk=;
        b=H6rk6zrZQ8kKwF6cSC6pXAkXI8uD3boZVnrjUx6QNnYh16X/cnfhiL/crTJXPwpo5Y
         rzos/SHzuZts4Eg3Ez5Pjjwa7aAT5xg2y36y+oT90MM12Rrjpng/8gUp09Xio6aeN/s5
         ufdYbv6MnTophedQulxVXOFyFt7BYGsL6lUHwrUJKJp3KjyT+r/BzZWcoTNTUVu07B2v
         fmi6UAii0a+UDxbNDbIXgt2wMI5mFUDrfnBGo90RGrlVy0Cmcd3DGc5D2WfLWI8yyEnF
         hB4Eq1nH7N8RthYRXaOL2kEloqEIiMpID2BSEwTePmKAnCU6f3U4udDQvTVLg0bTksKM
         rcCg==
X-Forwarded-Encrypted: i=1; AKwUvBx+VmwH1Sh7lt9DtSqHpIGU9jfK9d5/apWtWIeneg3T3hK1YNgp1sxAp3ccwvkcnj0w9ckEOF/kTg==@kvack.org
X-Gm-Message-State: AFuF++lQjFcXf3b8inR2U1qSPpiC2eW15QZ2frfB0SdRdstnmaLpHtVO
	5vKS7xSyqkmCbe0oofXYli8ncHewjJboZU3DjS2gr1DXuA7C3u5owx5/
X-Gm-Gg: AYBFou3YZA/rku8nEAVox7ZwhPXbaZbKdCuVHHAdo+yAMwD7r0oH63In2Vl5MGDNNz1
	gxb16ADN3fbo51weuUN2THsg5fYokGsr1II+NTnuegTYWXF/0bSRlQ9ooRJrBZM88mSLku8/zxU
	SUBjTrkpJFvFahgMOqFl9BhnYvhI9YFzy5644DRL1pVbiA962Rvv7f7eEVTZGe3nkk1vyKluBXi
	4aMlo0jEF6sIAcOzmojraQ3HEumnpIHbCnOxt+kw0WUhOMuXj3vKDQ+5yjSrhvwpSoDgsQ/cBKG
	VDhDp+3CjaPe5cjfosA+iQrGuFP+hrDhRGbgb4FVTEAF+9uOCejkbvDonxjlUW7cj/mb9RE1PbS
	+rb+tQvcQbAn2oWIZ3Jw3QCZ3OeycY5UGPjBGq+LtA+zknfLKEDoiyyyoMacYp/5MB8bV6A8X2C
	tyFQLndjumfMDS6DAKvgP8K9ygBAx+ByzTMi2a4O44yA7EYrlwoaNkFYXyi7x78cxlmhBLjBG0Y
	nlIXQstd9QXCtkpiFvaeWcBwoE+xYSL8Yhu8xNkBWMFjYoNfziPB4sFf+qH8TtusXwVsjoqjGHu
	yYw=
X-Received: by 2002:a05:6a00:330c:b0:86b:43f6:67c3 with SMTP id d2e1a72fcca58-87e99087d5cmr1123543b3a.18.1790228153413;
        Wed, 23 Sep 2026 22:35:53 -0700 (PDT)
Received: from localhost ([153.61.198.240])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87d1d5bfc87sm2268080b3a.25.2026.09.23.22.35.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2026 22:35:53 -0700 (PDT)
Content-Type: text/plain; charset=UTF-8
Date: Thu, 24 Sep 2026 05:35:52 +0000
Message-Id: <DLNAWZH4J2VL.35H5TXY9SPLM8@gmail.com>
Cc: "Hui Zhu" <zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next 2/2] samples/bpf: Add memcg async reclaim
 example
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Hui Zhu" <hui.zhu@linux.dev>, "Roman Gushchin"
 <roman.gushchin@linux.dev>, "JP Kobryn" <inwardvessel@gmail.com>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Andrii Nakryiko" <andrii@kernel.org>, "Eduard
 Zingerman" <eddyz87@gmail.com>, "Ihor Solodrai" <ihor.solodrai@linux.dev>,
 "Daniel Borkmann" <daniel@iogearbox.net>, "Kumar Kartikeya Dwivedi"
 <memxor@gmail.com>, "Martin KaFai Lau" <martin.lau@linux.dev>, "Song Liu"
 <song@kernel.org>, "Yonghong Song" <yonghong.song@linux.dev>, "Jiri Olsa"
 <jolsa@kernel.org>, "Emil Tsalapatis" <emil@etsalapatis.com>, "Shuah Khan"
 <shuah@kernel.org>, "David Hildenbrand" <david@kernel.org>, "Barry Song"
 <baohua@kernel.org>, "Geliang Tang" <geliang@kernel.org>, "David S. Miller"
 <davem@davemloft.net>, "Jakub Kicinski" <kuba@kernel.org>, "Jesper Dangaard
 Brouer" <hawk@kernel.org>, "John Fastabend" <john.fastabend@gmail.com>,
 "Stanislav Fomichev" <sdf@fomichev.me>, <linux-kernel@vger.kernel.org>,
 <bpf@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>
In-Reply-To: <de7adb6bafa3b808e29c0630f7ed9a2003e5e447.1790222105.git.zhuhui@kylinos.cn>
References: <cover.1790222105.git.zhuhui@kylinos.cn> <de7adb6bafa3b808e29c0630f7ed9a2003e5e447.1790222105.git.zhuhui@kylinos.cn>
X-Mailer: mkdraft (claude review draft; edit before sending)
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D8C27140005
X-Stat-Signature: 7o831y67fkhmdsnhmbxbr57oyaua8tw3
X-Rspam-User: 
X-HE-Tag: 1790228154-360911
X-HE-Meta: U2FsdGVkX1/V19Ul99mU9Qef2ksvWpXT2tnCqjwsz9TVQBxxN7lHMkPJUrNK6qE6bR/+csFmnpAzRyYmQhU6PsQGibHikyToMIx+m2mGDZ0G63gKWAmMT/MPZ/Qyr4Ghs4kbKaM8UciBsP+ylxZFGG9vaPsH17+nD1Ws5m0GJdyLGSqTFzaqlicpkYALnDJd5KWcZ0i+6hUTZsnc/LQYLYBFiwE8yAjvktun3frwwG2QBZqUINkkjUCBE92HHKHlmZuyksg5JC9TgbWJ9GPVsVKAe0Btr1ybkSs10OYSDdce+I3M0JiV/QPPSvAFDSwcnKvTPuVTGdOPHYBD3YVFtqADcPc/mbT/eIED1yTXNmvECsZ3wigSsShoaAFIRnc1MzuT7by5rVCF+G2f4R5/zHlj+5du4NbvUyPr9CE44nclYlsSAwBxWnE+i4cv/ScZi58+/t3ErUsG5qqzrGjPtk3M5q/R9pZP8IPG3Alkj43taocl0uHwXbsS4pweVpThGLXEJ23zwlCY5ic9Ui49trqGua6RB+giIjcqxJHxSl33INKX3PXfPS2tNiED6oRPggHOBX6Ng1cqLf9n2vs5XWJTMfXmYaKY2flJ74MayJjxWbzatjv08qIzCcBC74Pr6NFNlrIm0D3pgMlQAXBuvAsp+5vxmoe6xtlltDbyzZK0PeMw1F5+pTgg0Zq/FXtJxGcr4dQUqYixTudq9GrjVcaqmSKf8a4k5WBZWwQflLol2uBZgY3pmHhFJWxQzfsCOF4tUuRoqIa4T+x+ansa+BdtQCbuU92N8YZ+smlum5HdBvgFDO8ABP+I/tdrPvHMOHwcLj9H9NDIozTgUdX1iuW2mS/IdbvSDda4TFieWSF3LCTw/+9zujtfOPasqW+1TBMuk75x5Z1GaYywBnlSTOgvlVi/sUIxFU6SP5pt2ajZfbZd6LG0SzjbUaubtW/2BMjXplXy7PGBSY0S6SG
 OOOT8iAE
 dikHuK7/JOsb2Hzj162sD+dEAFpMe+sckVsrssghwzRzLwgpnoqkP/d4F48HZNW9w+eevoeJBYknA32QryBD7r2YfADSRtbZB7reIKacHH/y5JM+7GTQiSSTNFGXT70q1k3f3qRBygYN6RAdf/I09PRkt3GqaYb7koJCJZUh4tn11w+f7LUD6TnDtw2kIdXekaOXBBfF2OvcYeGqytb6wwSDXqUF0Ta3CPKoWZFf40YEErX20v8A3HpWbUo0KOXIwintZNQWZCODhKlrnsqkX/reOTJ8ahYKopTzuqBs+0xJGB0P5eVJyhZlaFXvu/lJrxjzKuK859ckjCOkCpQgsfuuQJl1xpFekr0Y1wrDfgl63JslFcI3KS2fgUxr+ii43a70yBFL9kMe2VqOpnaE5fI/tvWlyZs/0MxefbLe0YTs7yVTtgcoO3X30gPty4KQxnCq7HnTAePTT64AOefUGgst0dcOJYI1a5awBTeO1IVNckSAYQKr3nRi/wtPedxxwxhlxziADHcbW/InCkhnQELOaCNB6RtoRmF5z5pdWK21O2MzTji16hG2Jtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 12:04 PM Hui Zhu <hui.zhu@linux.dev> wrote:
> Add an example of BPF-driven async proactive reclaim, keeping the
> complex monitoring scenario out of the selftests. A BPF program arms a
> bpf_wq/timer chain that watches the workingset refaults (file and anon)
> of a monitor cgroup; when they grow past a threshold, a round of
> bpf_proactive_reclaim() batches reclaims a target cgroup, re-arming the
> work queue until the round budget is spent.
[...]
>  samples/bpf/memcg_async_reclaim.bpf.c  |  349 ++++++++
>  samples/bpf/memcg_async_reclaim.h      |   39 +
>  samples/bpf/memcg_async_reclaim_user.c | 1141 ++++++++++++++++++++++++
>  5 files changed, 1539 insertions(+), 1 deletion(-)

No. We're not adding new samples to samples/bpf.
1200 lines were overkill as a selftest. 1500 lines as a sample
are not better.
samples/bpf/ are dead. We do not add new things there.

pw-bot: cr

