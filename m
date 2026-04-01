Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D41A610F9310
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 00:01:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E8EE6B008C; Tue, 31 Mar 2026 20:01:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 899FD6B0095; Tue, 31 Mar 2026 20:01:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AF526B0096; Tue, 31 Mar 2026 20:01:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 686976B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:01:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ED6F58B677
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:01:13 +0000 (UTC)
X-FDA: 84608032026.27.CC51CA9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id CBC8140013
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:01:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CUXx78z6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775001672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/yIACZZNbKxvEvSXV6hgkSLm4+s/BqKQUkC3MQQEYTI=;
	b=m+iwgPRAsPyNFA7oTDsByulKioIdLLeKYtOcXeg7Nann05ljDl54bM40R3xVLP/U+rVai/
	YnAmZ8ocjBM7Wlj9aDDb3yHSCOvlMIeyXtUGbaxk7gMGX5HX0FOT3kgJufqHoQGeUrYl9U
	ygqAxvVm4IqKP7Xiid9vHDZyXQjxE6g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775001672; a=rsa-sha256;
	cv=none;
	b=mR1pPhsQuG5RxzsmZqDw8xnj90hUrIYsa3xzi/QD00ob0+ePDqlMFptJI0z8l4QbQLOwi9
	FcLhXrHAptDTwqyANIFBQ49z5vTlYV9m19w9YAI/MmgqaQbcaCZy9B3D7AQAG/5J4AsBZu
	t1ftcb/MaWZDolfDsTbTjeKalh0zFp8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CUXx78z6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 59DCE44344
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3904FC2BCB3
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775001670;
	bh=/yIACZZNbKxvEvSXV6hgkSLm4+s/BqKQUkC3MQQEYTI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=CUXx78z6jrbYQeGQOq2UkBVs8P9qGVYOcEf9LgC/yEAfxY3LGM0YiwM82Qa0ys0um
	 ZUxxKXydhxUiAKw4xbBLEQnSzi8OHKZuGGBVXMTkqkUT/1Qqe3tXZ/64n6ggJZ7MnX
	 exLUJiiN8df0tfpJCYmOCNWb/AaCuoYWacxWG8fRyTAZRpMTKFDX7f7fhNia9dauAi
	 t+PU8G0R7mzpSPIpuGJOkkSCSiZJXZHtGdDjTw6Xh8aUrc9RRZjSAQN+vS9+fxxz8K
	 ylDVd2waxy4n6UMUkEl2Xy7V8boB6RJVu2zK0hDf7l5pqTzLGjWrBG+OdTT2hcgVSq
	 ew3WyviLhIrCA==
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-89fc349b5ceso50228916d6.3
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 17:01:10 -0700 (PDT)
X-Gm-Message-State: AOJu0YxdWdaKmpTk5k7DcwO58e8kZeGlYs+C+fD32s+bKssceZmmj9KI
	3LzFkiL3eLMs3ikJsjwXc+7IS33g3CyfKP8GmahNrNafKfweANozK6rQQgqOLzgAGyLQhHMsjtJ
	TkOrtpbubr8P/LWB7fx78ClxINhyo2C0=
X-Received: by 2002:a05:6214:598f:b0:89d:b093:936f with SMTP id
 6a1803df08f44-8a43a55cc45mr26624496d6.52.1775001669278; Tue, 31 Mar 2026
 17:01:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com> <20260329-mglru-reclaim-v2-2-b53a3678513c@tencent.com>
In-Reply-To: <20260329-mglru-reclaim-v2-2-b53a3678513c@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 1 Apr 2026 08:00:57 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yfE1A_uTQG6Epo8jSGhxjgVd0nT24prer9JrneX_psYg@mail.gmail.com>
X-Gm-Features: AQROBzC7BQVTJg5Oc8VGI3TWk2qzL-mRPl3wA9ahPA4X1r_GC-ezPnp3FjdCTro
Message-ID: <CAGsJ_4yfE1A_uTQG6Epo8jSGhxjgVd0nT24prer9JrneX_psYg@mail.gmail.com>
Subject: Re: [PATCH v2 02/12] mm/mglru: rename variables related to aging and rotation
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, David Stevens <stevensd@google.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: CBC8140013
X-Stat-Signature: bj4cuhyxi4erzmn3y9r1iu88ha9hutgz
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775001671-134852
X-HE-Meta: U2FsdGVkX19ILepqY6eIG9zTQp4UkDpgfq4Z8qfiO6lC1N/3IfXo89Q5YXpls1c8STGtyM68r8m9C1IZ/W3Dye9dOocvKIE2ePAKDuyK992b8O0IEBsCsqQqVmmFCTCGiZq3LHy07BiU1gdFvTTiQlayN/7bHXCpnO/Er1C4aIIWt3f46ONmsQDnDEBqqDE4nFYWQQGdCWo96uWhtWY9lQ/jTkGlkn6slmXwoVShTN9xXUzZ1KMoA/NMe5VIQsY0ZQjUvYpM9i40dvvpYzj+r1OsPpV7Eb/U57Y5L5FMIG8vgdDNV+8dPzeWRXTgRUk2Fckc0n/MQu0/09mh5knQqGRmtwe7EYJkBtLv7z4cR/UoI/djjOpSJtO7d4GtjeFgcQL6X9mmJjotpSFziNmwuHWDR7OIyl+lzK+Lm36YlokPA4wCaAQL7AucDxPWLfBiefu9AUkeZMo8t3ARCXleqKJsEIWtnyhCDQi0E+InGSGhqRsTlZ30VKZVpsyVkX0I1nGEZjcRHkojLYQy+wXNV4qv0toH+MOkVTA4ns85USMZweGddMroH6STWw0AeMVcWui+/mw6LmY3nPTbr9MHbLDxcUZzXwZjtGwbr7hugqZt20iK2IFHdqt4RcME9HAHqd470KxfOFN3XvnaULb4Vh/0VS9voPiE6xVihHnzz/lnnIWo3E+bnSz7tTfUQGMV0Z/YBTVKFARCXYjYA8GI+xxOuMfq1HwoEjfxdtHaf+RTNlRw8m0h24eB4BP611A347ZIHZ43WGwiNm2HhIR54S0t4F87dYN/f7HF0XH+tQJizeQW8fH/geMJ1Fihtwafoq9HKL0s2CHUUbDEZGJBZWXtKAghd93Ted9J1wdXwLAM2ve1B8IBJeQQnUHB9791Ly2Y7giMUq/48Z7Bs0YSHSZn0sDS0KMc2Fn7q0Hq/Kbty99jfSx38cKe7r1KcWrBsYF3baViKBS5rHyl+4s
 yh6+PaTs
 X7ZFWb/kFM1/RNvev0kV4dcEJaPDLJenVcgFFLIL9azjqVRmaV9WwutTKU1V1YU8ai9ENMpNgegr8hvJaTU6qUhRMpQ7D+SUMSIqtxtEmUBGuYsIUCHc1SCc1hhy2R+uXZFkQ9tDYBYX/UpGtWsBVYz8DD6r7HIvgJnYtqw9fwH6LqAA4GF9GImad40mWi2wT/oCLjBoUlkbzcumEjvwUURFSdK9H4KmRguiKePO46XWDZXc+x3ZsTffKDl37WrTdT0yXwoHR2rigEPHniYvRUYlQHOa3Klgbv1LBliiqn5OBwA1AMY4l6ZNGTcILl0xvfkz5v/8/SZ6EySfTIuTeCN9VXOps0/5v+kc56B6Bz6bBqSJIlfQdiPIsaL/vbk4S5cOgRrWl7FXC5MuFZLCXeO21Qw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 29, 2026 at 3:52=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> The current variable name isn't helpful. Make the variable names more
> meaningful.
>
> Only naming change, no behavior change.
>
> Suggested-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

LGTM,
Reviewed-by: Barry Song <baohua@kernel.org>

