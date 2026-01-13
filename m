Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05F77D30CC1
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 20:04:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F9DA6B0092; Tue, 13 Jan 2026 15:04:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07DD86B0093; Tue, 13 Jan 2026 15:04:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0F8C6B0095; Tue, 13 Jan 2026 15:04:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C85316B0092
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:04:40 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9A4E61A0293
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 20:04:40 +0000 (UTC)
X-FDA: 84328018320.02.B16CCFA
Received: from relay.hostedemail.com (unirelay08 [10.200.18.71])
	by imf02.hostedemail.com (Postfix) with ESMTP id B9FAB8000D
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 20:04:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768334678; a=rsa-sha256;
	cv=pass;
	b=4+wiIUV6bYTxwhQcd32rww+cDlUTrIko9/aznNQt2c5C3Gx2bdTck6LZQ9/t3HtVrO/OM5
	1RrhH+yCXrhWNe2tY0gLixMQhmxQhHqhoVnnYfFmAcv4KD48CXgEnlP9o3Ku76qGBo9IX0
	B7MVK0zKzAuMo6fS151q6vuBrUv6ZJc=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768334678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=baxDXnLPq9jBBjhsf2/bGL+DnyACXuAEf1JTO7X2B2E=;
	b=N/ipWPNipTtZDd6Z1RnPE3SZfAxx2wQprY8l2BtOMz8HT/ZO0iB+tocMoVQNcK9m3I/7DU
	SGMegiu9n/O9qQ2YWg+1vFRcO8pR/iZb7j324MDa3/F6pACLmxLwSui2hx0AHTtUDQ3HZN
	SY/9SEV+6u8raw9kZOFTChkipIoT1nk=
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3C954140266
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 20:04:38 +0000 (UTC)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0906BC1522
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 20:04:38 +0000 (UTC)
X-FDA: 84328018236.13.2E57968
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf28.hostedemail.com (Postfix) with ESMTP id 64D8EC000B
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 20:04:36 +0000 (UTC)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768334676; a=rsa-sha256;
	cv=none;
	b=EJ7kSE4jfjAV3of9+3AaPuJgkNDzHoipvKr40GAhaOUcpBfp7mO5hmr+4En50GOXdDPPAx
	bIU21F058sDxCd+u+EfaMvCywHXwsU5IYh11ZU9sbyw09tCwFl5KUxraeMPf6cTa63QWqi
	7IjkZSn/SV9zSUTYE0QwZ8qWNSl9pp8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b="Cc/12zmg";
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf28.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768334676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=baxDXnLPq9jBBjhsf2/bGL+DnyACXuAEf1JTO7X2B2E=;
	b=T00RRBIgd044KqVrimW+U/q1AIkTBhDhQWgQbF2+w8PPCLDBFTCJWj6ojXH7uoLvozhlDT
	AxPPUkCEOSDCrJf01Pc/T8elzMD9CodSrCOTq0LtARhZyCb4TM/OyLbnniO2APEM3CizYu
	LcUpYZAGs6TDlntwpaU8PlIH8Um3GAk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1768334675;
	bh=baxDXnLPq9jBBjhsf2/bGL+DnyACXuAEf1JTO7X2B2E=;
	h=From:To:Cc:Subject:Date:From;
	b=Cc/12zmg4YBzrOIs25QxA9HXW/CEntqoDHzIJhMtYIDGYHWFqmIc6UpQQ4leZjZhf
	 AbwCCkb13zWIFTNE0RHNXKEMVJ/KCvf8R7O0U7DL94+/cktRnPr7HlpNRRu/zDInGD
	 vFPwX+uNNoZY2FGUAYLiaW4fZadIInh+7EXNRyWB1Ec33RW/q3+BNYP9F8OUErNLQP
	 m6GYChaSdnW4LXEnS/8qzuErNdX7DyM9b3girAUmmIgG9FOyY6SEuBCk2Vc27kqXja
	 v14Xe6s+odE1CGMVsvp1OepSeOMYgMfB0NyunYv4HnVkSWgboIycYg6a5YHm6l8Jnj
	 kaq86IEVyFtZg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4drKw34l6dzmFN;
	Tue, 13 Jan 2026 15:04:35 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>,
	Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>,
	christian.koenig@amd.com,
	Shakeel Butt <shakeel.butt@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: [PATCH v15 0/3] mm: Reduce latency of OOM killer task selection
Date: Tue, 13 Jan 2026 15:04:25 -0500
Message-Id: <20260113200428.30614-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HE-Meta: U2FsdGVkX18adCRNayfqAxSq+ZUZtOD5DxpUB1A+8X84xC+UdXycyCZkheFhHNmcqPYQBi7Dy7FYynu47M6W/WYRQcP7TeO7j7zT876Fzi1o8BD2bBvX7Y0objYhh/iiAg9wp18PgxK3fawe7yEQPbCJL/ndp7LnUqYstwPBQPEdapwvjX8n1bgkqoLRiQmiIQiPhYkNw0cyWOGF01KCMQadJbPChvkzVSgaf49pv30Jt30TzMPcjNC+IwnfTeFQL9k9X81BhD7NjmfiRxjOeFXsiNG4kXWqqnT4d8kHkmuuCjoyTcKT4sDdFi1qJyAJDCw53vOc+c/A9cbb6qYbAdSbcfyKfaVt3OHuLfXd2iHlBXw9Sd0jotOZPsXbcq/AeHe3bYlOTUDhBLO9Dq9lIYXWLrXJ+AAfTqGraY+3tdDvSPl1DyzHKUVaH4T3QPHdE/047N4bKtLkEmN661LM08jhIZ3b3lOtv891RC2uJOECo7Vh2HVEjc8BQ/NUJF0t1esIFBU++sPcsmDse9m2KBbFZOBDjyidZlQ3uA3DkHhe9w2BalNJ2QLPWm7L9RkTDmAtsACJp0kFoS3ZuMGyH/vJXCWGjPL8bMaKOxZAJEdgsKpes4AXL/uPxWSqAjPr1B0z5iy6EhbW5mOTeDsa5taTNLkV2NDScKOY5GoCs6m3uemcjTD6/fjXpFw2w7oinPncjPdIHHWW0u7Ga2fzuStSS6ItxaHlmUIqb29+OoKGOgpHXoKdYoiLCx6kCLD+0Nx1dxiBswqaMt1v6NSuMo7XRvhtbm1Beqha3JCD4si5wDnQ18ajszCOU99KsYVopTR/QrL85HeBfeJQQmeXJxSblTUg1kRItLaZ5aPGal4nCTsUrCTokuCa84duzfqa4NaLt7MIx94s58JAKiPKkAgOOpTpoKrOSJNeJKIkIwFpVA7JTnPzn/g6b+NPyNKN7t2b65RbvlIF9zQklPr
 WVZcxAtf
 TxmfNkSMzYo8lo8C+mwPxg7En4gbX6rp9YXhZUl1+N3TnUSM1YnnsXulCb5faEKIgPmOXBXK52DFJQAlOZYLWx1PNbfFffbVA55/DX36LtMCvhRDF1YabECt7D10TOSowAARAzVEVRlqrOCJAi8R883Oh+5EqjL3996YXNMkYO30irkMqJukSq/gjg8RfS4Qy770FQDYeFO1UVxjfzj0F7KbSnki37xMAC37FBfeOikv0TbgAIoDuCPn/9PMg84IRxkbgsVDreOpsxgoA66KWa1EmLfuysIy8KpgTyHfa1x/H+L/lJj8YF/3DZmqqBTPwiOLQkZq94Kk8NoB4XpWXnfLVgWbqANw4zcmsQbmOnDJIxA1l48dakrsLJ4JuYVpDTJ+PPMXQUJe5oryVoRdLfjnMJwFI8N0cEdJ+husiDrhVPMVil28EXne+AP1PNWAK7f30wOmQFCwoUZXUGWhLVG96yVPvtVeuLUoPDL8xvdSNq/TLnvQmBT4ZV8J+CRs4YMx8VtCPmBobDZ4i4DHVUHo4nKzvISloqn35jBZ0ZrYR/Id9n9TL3MmRq7Y9IEpd5DK29r028s0G8GSlEONx19MOkzN02TuwZZS3uOQIaHACgw33CtvpFInhBE0sROng5stTb0fIVYhU/avis0BWbxgnPLq6RrCa/3c6Wh+cB3ZgihMoLxGdRtTIQsqUa+Xoy+YOsGvaREoyH9Oy1CSjIH7VWsfiuIWGug3eJSpMnM/9CsjKuo4vVWGGtNc/yEVVo/FrVNwm2IOMxljyRCHfuvICY1zi0+sDOIxJ9LE94oIOpVY7EhQ6NG1iziPh7+4qQz4sY9WYwdic0NH5JJ/qNUaf8eFalznxwqSoceqX+8LcPMUg1jhk9xo8xp5YVLqdO4AoOvLD6u4/ck0YndFMwRo5kTEJUqd12QdMwBbtNJerTL+Pkl0NQEAJouN9vditR0YaBbNKDFRlKnikYzIDId6BZKcz
 lxmJ7s7L
 BU9ZEnCdoYxIZLgFZjB6qZ2/SSSvb/Ca9t8RkR/wTRjQkZJglmssz9sAMn2EKmPogacJZVKGdqfjHE/rnMaDHg==
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B9FAB8000D
X-Stat-Signature: c8f76orkxkx77ndgo5e5xocrkip6por8
X-Rspam-User: 
X-HE-Tag-Orig: 1768334676-28571
X-HE-Tag: 1768334678-773978
X-HE-Meta: U2FsdGVkX1/xXDsLehQ3j+lfSoqv0sI9Qt/RzNwLemA22/6m9XKCHLu6+GLLFsXNzcvLSx7rbcBi94VneK17kQAcnOc14bcRI7puSAVeJAWj0IrTwM4at6mccItF5VRuMs+jKwXDU1UcfFEfUFnuULjY0cFc3AzgUavZcD7FMScoZotUpZX+FAIgrBHENl7L7BZJztmrR+i07OaIZ9fpsRPgD72xrRjr1OU65Yx/PeYlYqiGbQFElOAww2edEmXr79BwrzZyywbRlb0YNUroPZ6RPOp0yBXgZeHVFzBGO9+lW/sqjSBSPvbxZO40DSXiFoabUbwRRTUp/ulLFHzctHBVNqKimWnDB6fVEiUQQB2CNblu8fxgUrEYbp6chWXWd3BpU4XAjzgDimx9swBJ5azletaAlX5UoROWwL2sI6Nre+4NH74UV1QQdoFD+QZsgLEtXh/cx0l4b5mDrsk2BSvG5BqW/NTahCatwDEWOzwFWs+yLkuhG27sirex4UvI7rCSBoM8AJXY8jQ4lhF9INWILKzRpmStd9OqAGcHVMHx0TNwBWqoJ6K9yPfuZ5yKkmMfVYvdjMWLluqWN++Al/xKOlK0+ZLlKkondfEz85g4Iuw+nuwkYk02b8SZsclasFf1a7qV39+Yyvo9SZ8KYtP1pmhYKr6JpySGtKuPBiPZ+hjqn1lMpo24xZMdc8EFgrQkUF2meg3oza0xifN/uv4OCrakp0f17Y7f9eRRuzk81gUwEngesFLUpc0PJbzOvSUzsCwvpBub8kkyvGN5O/6dSCsiz+hqs6AiMAGqRz8/kONxS1WdmF/9HKOFdtWth6j5mi90AKEYwn6V1VtgL0D1lUBB2gmIMPord19p+2Ajtm10Zq58jP2LklAI2lsIdl+0MnDo10lXdGFW1qsGThsp9GMvx5I9StvaDNQF1oiIbmALTmkFOqfhL3KYuaOGKPPKOfl29xHllK3fLoz
 Gk+hv0sx
 zboCRvFY6zVqG41AqGMhcXkQLnN4W6Yx7R6CUSpj3OVP6ersx1uyJWzFF4w0dcAg3iDdQWaiewVlQy94F6ZjB+QE1iXHldljFcANhx8uvBErb0+m5G7R6Fr1gam0Mb7YFmiRxJkNaBONZXOrOeozUssnLMOL15IQTe37mnTJeVnHekI1QbrU2yXmeZ2XDnSGKAdOIjiFrDh+43KODJ76XBhP69/5e0DBXWsJJqVCZuunwurRP6/QoRzXyE8bMKdVChTW99F4WUGLXVtI0WJz6I2OPo5J4e15rc+JT7eDz1QV9+mtnmBKYshjyyaZ6Fykn+xTm8Hnx9wWlsWq2LjJDCW4uzo3ERqO4/YQt2BqhI35RfTRLL1qvDEkAuFLdFyuXVxgyIpLUB1mhb42dadPy+XMsfC1eNsKjjUano2FvM185dmKUQ3j9v/2qxhVsrO+vHkzwtwUt/5nmpZYFU0wJe95gYopgKZB3aGpvBnR7PG4oVj8UwAZqZTtRczFFttIPVLCaGnu3j/hogl+Qfk5gXr5oGH/UhISZxt/Z569BL3rKuz12ZBNH/qTx/kju6HVkgdEHCJc1suZd1LvCRP/wJVb4JPu2HbN3f6INTN4RtPhBLnz9e3OHWRGmDGEfBmUG/bk4JYbsiLdLZUm9h8ismbmzEasnVYmcx3VdCZbZ3Nc63CYs3028myl/Jjxhgs25FG2qvO5RbzXauLS0Aj0H5HssGkpYkcjEPI5pHgakSl/mSOTyXQZef07pMblmO9pFJaVDl/X4cVM+6+P1VRU3U7PS1ad8H4JG5i9xeZuN6lVcuNoHEd365da7FYKRCZ1dyVDC/vPU2KJrQOFhHSiHwjYWDxO1oBekpvEq/MRQe0acoJXJV14UNeHwuZBWcssSBRGFLbhmrlXDKnJF+5YOfGdyaLMmOEHPV5YTSnVjKYwikAtkJqfvVjtSYeAeBdIrto9D93Fun2FQQYI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

This series use the hierarchical tree counter approximation (hpcc) to
implement the OOM killer task selection with a 2-pass algorithm. This is
a latency reduction improvement of the OOM killer task selection.

Testing the execution time of select_bad_process() with a single
tail -f /dev/zero:

    AMD EPYC 9654 96-Core (2 sockets)
    Within a KVM, configured with 256 logical cpus.

                                      | precise sum |   hpcc   |
    ----------------------------------|-------------|----------|
    nr_processes=40                   |    0.5 ms   |   0.3 ms |
    nr_processes=10000                |   80.0 ms   |   7.9 ms |

Notable changes for v15: This series becomes a OOM killer latency
improvement, rather than a bug fix.

This series is based on v6.19-rc4, on top of the following three
preparation series:

https://lore.kernel.org/linux-mm/20251224173358.647691-1-mathieu.desnoyers@efficios.com/T/#t
https://lore.kernel.org/linux-mm/20251224173810.648699-1-mathieu.desnoyers@efficios.com/T/#t
https://lore.kernel.org/linux-mm/20260113194734.28983-1-mathieu.desnoyers@efficios.com/T/#t

This series replaces v14, aimed at mm-new.

Thanks,

Matheu

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Martin Liu <liumartin@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: christian.koenig@amd.com
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R . Howlett" <liam.howlett@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-mm@kvack.org
Cc: linux-trace-kernel@vger.kernel.org
Cc: Yu Zhao <yuzhao@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>

Mathieu Desnoyers (3):
  lib: Introduce hierarchical per-cpu counters
  mm: Use hierarchical per-cpu counters for RSS tracking
  mm: Reduce latency of OOM killer task selection with 2-pass algorithm

 .../core-api/percpu-counter-tree.rst          |  75 ++
 fs/proc/base.c                                |   2 +-
 include/linux/mm.h                            |  46 +-
 include/linux/mm_types.h                      |  54 +-
 include/linux/oom.h                           |  11 +-
 include/linux/percpu_counter_tree.h           | 367 ++++++++++
 include/trace/events/kmem.h                   |   2 +-
 init/main.c                                   |   2 +
 kernel/fork.c                                 |  22 +-
 lib/Makefile                                  |   1 +
 lib/percpu_counter_tree.c                     | 679 ++++++++++++++++++
 mm/oom_kill.c                                 |  84 ++-
 12 files changed, 1296 insertions(+), 49 deletions(-)
 create mode 100644 Documentation/core-api/percpu-counter-tree.rst
 create mode 100644 include/linux/percpu_counter_tree.h
 create mode 100644 lib/percpu_counter_tree.c

-- 
2.39.5


