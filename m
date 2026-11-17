Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB82F606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 02:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kBnDPekR
Received: by kanga.kvack.org (Postfix)
	id 042C66B00EF; Mon, 16 Nov 2026 21:26:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01B136B05B0; Mon, 16 Nov 2026 21:26:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E74776B05B2; Mon, 16 Nov 2026 21:26:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C57226B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:26:25 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3D4E31C355D
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:26:25 +0000 (UTC)
X-FDA: 85443021930.14.92B0330
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 174B02000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:26:07 +0000 (UTC)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9AB2062765;
	Tue, 17 Nov 2026 02:26:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECCDA1F000C4;
	Tue, 17 Nov 2026 02:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794882367;
	bh=PwJJPpk0KtufegXyh+UDHeclSfuYI9J6g+cBDWGlDL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kBnDPekRMxV5Tz1ixrttniVUjQ/Y5abW8tNTlEf7fOi4ZaOX6Xysah5INbCB4LJdt
	 PNYnVRrO1c4KefQkUROFHa50Q/1Ng4uM2DQyk0BXX/yUL7xXEYZ0cCnszuKRxfXOhD
	 dnkI+MYADUej+9hL6Bn+Aqomi3Mex2xIbLGg5NxcZh+zWOwIn0X7NjPT7ey7EC7UA6
	 pq+1ibg0NnHaYLzC1fllDwWWjO0DTTClfja8fdc2g3XTjosIdnGN2cSulXKes5vZzM
	 8v063ap8izPeUogb1u7LU8Rcg/3G9K2FNsR+eiJeLhSep/qh3Z+MNGJnKV+fM5b3m4
	 MnnqolfjM2waA==
From: SJ Park <sj@kernel.org>
To: Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Mattathias Pinchover <mattathias.pinchover@uber.com>
Subject: Re: [PATCH 4/6] Docs/mm/damon/design: update for sz_ops_filter_passed_last
Date: Mon, 16 Nov 2026 18:25:59 -0800
Message-ID: <20261117022600.110435-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116-damon-sz-ops-b4-v1-4-1cffe7227e6d@uber.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HE-Tag: 1794882367-772186
X-HE-Meta: U2FsdGVkX1+Mr5kdnJ5tjGnnBRfTF6Om7e1AU+ZdIU8L+k/9OYYfbqYawPB7vNrc8pk60FWUZ7ndSH80m6Sbs8Rv8WaJbUdcYKPnhCMRqHrQpDFqlXKc/dEzKpwxBlNwx1/ZiwJL4U5gr62sDb8P08T980vaSQhINBnWkRXLNBmeIXMG4Un138TtgiJNhwpLHIp2gOHENTC6EQw0Tb+Hxf0E5w135xSEfTGuug/NDkW6jRvPaS5eqtaDkVu7KrIIoK8k8731so5rhB3/cCfmJyloh+muPVRfQUoIL6h0odxPrFx1DiQVOoIwMQMbcnWIXeJw2G2Yn5xNxhs5IGEFovSzSr7q0YKcqa7OF8a0KBUggtAxx8ZJZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 16 Nov 2026 19:10:07 +0000 Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org> wrote:

> From: Mattathias Pinchover <mattathias.pinchover@uber.com>
> 
> Update DAMON design document for the newly added DAMOS stat,
> sz_ops_filter_passed_last.  Also explain that, unlike other
> stats, it is not accumulated from the beginning of the scheme's
> execution but shows the value of the last apply interval.
> 
> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>
> ---
>  Documentation/mm/damon/design.rst | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
> index b676be697158..e40b8c1a3461 100644
> --- a/Documentation/mm/damon/design.rst
> +++ b/Documentation/mm/damon/design.rst
> @@ -876,6 +876,8 @@ scheme's execution.
>  - ``sz_tried``: Total size of regions that the scheme is tried to be applied.
>  - ``sz_ops_filter_passed``: Total bytes that passed operations set
>    layer-handled DAMOS filters.
> +- ``sz_ops_filter_passed_last``: Bytes that passed operations set
> +  layer-handled DAMOS filters in the last ``apply_interval``.
>  - ``nr_applied``: Total number of regions that the scheme is applied.
>  - ``sz_applied``: Total size of regions that the scheme is applied.
>  - ``qt_exceeds``: Total number of times the quota of the scheme has exceeded.
> @@ -903,6 +905,13 @@ to exclude anonymous pages and the region has only anonymous pages, or if the
>  action is ``pageout`` while all pages of the region are unreclaimable, applying
>  the action to the region will fail.
>  
> +Unlike other stats, ``sz_ops_filter_passed_last`` is not
> +accumulated from the beginning of the scheme's execution.  It is updated at the
> +end of each :ref:`apply_interval <damon_design_damos>` with the amount of
> +``sz_ops_filter_passed`` increase in the interval.  Hence it shows the size of
> +memory that passed the operations set layer-handled filters in the last
> +completed ``apply_interval``.
> +

I think the description is clear enough.  Could we drop this?  I concern if we
will have more non-accumulated stats but forget updating this in future.  We
could add this again if someone really get confused about this in future.

Other than that,

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

