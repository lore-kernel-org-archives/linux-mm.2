Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F235EB365A
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 02:59:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79DBD6B00A8; Mon,  2 Mar 2026 21:59:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74B966B00A9; Mon,  2 Mar 2026 21:59:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64AD56B00AA; Mon,  2 Mar 2026 21:59:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 524B56B00A8
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:59:53 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D699B14035C
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 02:59:52 +0000 (UTC)
X-FDA: 84503247024.25.F9524AB
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf17.hostedemail.com (Postfix) with ESMTP id EDDCB40006
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 02:59:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=K+RILIw2;
	spf=pass (imf17.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.47 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772506791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BLlwYryI9nwoVTSN1bLvGrJJhFzGrsArbGvfJ+aDFLo=;
	b=xOo617HX6tUSWQmQ7SnDiPn/R2HpOKE8BXtcHjQlgkrghsv03/mH5IUJ/glePYRzYoJ5w6
	GTbmuSd1VMEj9F34sPGbbNfrRpFkeOoBbPvgmVq432jF6MfYST6krIGkUJM+p857D1DBEn
	3WNGNsfPOzJkaKYqc5FSb0r2rTrr5es=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772506791; a=rsa-sha256;
	cv=none;
	b=z8Om9n86U6nx81PtxCBZlxmgy4SDUS6c1CvJ+wMORH6TABwp98MKYobYdKTa4rGmjLNbjq
	iywl+t1h9Ob+zytfbs1qYr1KwZDrZXeUbHuVkIM3OWx3EvlN7oraqK1X2bhzYCVyDawwKP
	lWbOdrHDdXlBJYOCzeZfpdvKELM+3+A=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=K+RILIw2;
	spf=pass (imf17.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.47 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-35990245493so982643a91.2
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 18:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1772506790; x=1773111590; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BLlwYryI9nwoVTSN1bLvGrJJhFzGrsArbGvfJ+aDFLo=;
        b=K+RILIw2EBRDC/kHQbG+qZdSbbtTS8T2iyw9RV0/CUa72Sb11G4J5I7HnSplx/S2XX
         iAPxDxvhZ/8KXcyqz6SiL4T6LSnMU6m/gbflaaKvDOiL7GaB1qZVpPEKvecWDfcT0jVy
         8g3uGFf/YVxUCoRx2/uJz7V00HyA0Z3jI7aqI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772506790; x=1773111590;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BLlwYryI9nwoVTSN1bLvGrJJhFzGrsArbGvfJ+aDFLo=;
        b=oGCs6J4poCYwAesrdrBveLMpQAUSsQNNUO8Y/iN9tkNryn1TYKzzKwNW6IWnJCxLMV
         9Eg/HHloiwl93yBzbXWumQ/1KVH6L4JrOxz/vjVwqEqfKEam2PSMmIPV8BPH8UXB/KTW
         iIAvLlbMDAvI3x7ULiJZh28ZUGOZbNpfj3QTCPxUD5/EYrYKeDumocrmLdIM7kylRxAZ
         nYG6S7/ZgIvcoWRmycRd4FB55hDtpgJ+CExn9oP4Ti9QMAJ3Onph8+FWVIaGoUGSxoRC
         LhMVOOIK9xQsfIRqUyLN9yjk2tJaE4tZipFKwLD0YKJGBS+6mFi+W8CQ/gZ2Ke0+dgj3
         zS/A==
X-Forwarded-Encrypted: i=1; AJvYcCXnqiWbxB4YExe/4tcmzoCkkXG3qs4Ma6R3M+W6XMJ6u8BhFUWl6fEqCLXt4povmDJxdpv/W9Ezpg==@kvack.org
X-Gm-Message-State: AOJu0YwlE3ZvZ8raCYiUgBcO4T2uNj/d2QnTLEon+y73YtXadhCHjPeY
	Q9+Nvvc+J1jqUgf3WE4Zlv0PgCl0qB4VH16vcnAelkXHdQPAIgIGNt4QfZjH71B6nw==
X-Gm-Gg: ATEYQzzGqeuZAp1zdHcR6S6MSIvrCOBo/3enrjTLpyKYX+gqO0Z9i+XN3IrzIeQ2iIJ
	pdcmz8Mqoz338/7CWalvhf7rFQlYZE3LiYj1ocQBjdXoVsrAIviaA5uvEIiLPaSGiIEPPoedMMG
	3oVRozvD8XtAc6P4izPk20KmqtZcwsOc+YD8XVjIxSJXauHLeWoP9yRge501q/CSA01QuJbowd9
	6keZ67Q59/VsudNBQUqlCtPBqeJf8uJezvzY5xq6lDXGFE6XNyybAzfCG5hXkupV6eckhfEcDC9
	TLeLsqCbdj2B44rC2l8rApbEYlQFqYCmmdH7TDGvg5CIeaeWFFWQXsF+e/Tszl4gINbyFxaUxAQ
	fq223j9JsAhLtV5/lHWwrxb4HO+flTz2uqeLj2pmyrrUCdMihhawgoMoN66HGEeWzJz+F3QJXHp
	rEEEUuSD94Wz9Q49q3zV106AR5KDTwAiEUBwFkRNzExMMDEMQ5OijvCLQu4hl29k8=
X-Received: by 2002:a17:90b:57cc:b0:356:2872:9c5d with SMTP id 98e67ed59e1d1-35965cc5651mr14316591a91.24.1772506789686;
        Mon, 02 Mar 2026 18:59:49 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:25e4:df20:d043:afd2])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c70fa82c531sm13254150a12.24.2026.03.02.18.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 18:59:49 -0800 (PST)
Date: Tue, 3 Mar 2026 11:59:45 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-mm@kvack.org, Brian Geffon <bgeffon@google.com>
Subject: Re: [PATCH 1/5] zram: do not autocorrect bad recompression parameters
Message-ID: <bg7ivz7ajiuzdbpv3h6hbptxgmqk5fhwakw4rzk4sz3bczky5a@rde3y352n5ej>
References: <8a5d53d19a8dbd51d7d81d153676895163e0735e.1772180459.git.senozhatsky@chromium.org>
 <20260228120516.e5323a704d4a26bda041dd4e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260228120516.e5323a704d4a26bda041dd4e@linux-foundation.org>
X-Rspam-User: 
X-Stat-Signature: npjrkff1867ojroag7fn7z1ro6bas5np
X-Rspamd-Queue-Id: EDDCB40006
X-Rspamd-Server: rspam03
X-HE-Tag: 1772506790-237661
X-HE-Meta: U2FsdGVkX1/8zIYlQ2ZFrAzAJ3MDqNXERVFzg2Oqy4gNofXvCdbY/bCryW6VPMDfPqRHFagp83tfvmptClGP/8C7uLDrP9aWYbYIBC1E8+oSVboqbEu8gSsrmP9Kxgz94O//iiHg2bxQcqFCmQRbsZj89DuzIRgiLCmGIvZpQcL0CA4WJzqibrZ+FOYpO3Idxy5FrKy0NK91oK78f+w/IrcGBlmWFyT08iuG9PQwUKFjdJdor00cup94T1fvi93PdpxsRmpIGpYK94Bk2tYgeyg8IGNQ9eF0ZpfLe3nubcrcpVg2dbmxTHrmbpBBIitTgWNZDG/qo2iZe/6DotPKPsLIhGhBndQOG9P04dEtJCnJdvu8QodR2A+o1QT12gUL+z16M3tGAQa0YC7s7zz9HWw8hgIA66K+pKOioViWITzSWF93w3VjSYBLpdI7wI7eJUXUaCnat28+adjmF5FlyJtSM5McVgqMNiUJBMyKF1L3clziGhiA8ewRNIMGntZLejD5VinqLXUcUnxz2nPZJnZo8JPDglQTOIdmNTph2aAiQaUj7EpzKdEJ61YhUs+tgTe/4ucmfnil/aXQZ7Edg5z9cf3qyQZfx42F+pWlwx406UmyeIM1+Zx/Xxg9RORo9WTZgr3Vau1m3GGffQm56lRlipQL7B3lNbMxFpt42cVTs6tFAmaT4xt9eaAxwjEt7aFr5DUTPY+JwGPDrz2ohVZ1Gy1jXmI4z1Z0K1b+zjlgG97MCaXXhO5vkBKjDPPvpjSRopn8jy0TsBTSQZi6pigRLcyLrURLlzpe3u5pSynXQLLq1CZq9BB7iCua6pZC3r2cz4MdXRTGbhbrAGAhJrr8igq9NsbJ3t706K8bcg8o6QpP1lMhQ0/QyXB771BsxYuEgXhUcEDwi47UuzUx72W1OCJ6ijx4UiLljpUF5c+b/aapq0PHw+dWYFPWgfpYI5JndUHV9riEj4/4y8A
 rwc1cZVF
 7lVY8iTXGtizJabLkaGyAvvM00vWGdpXoCgaO1ZrWPL9EGAGaZNjz+F9nUuFD2QWGZG2bmKHmE+4NKb3npthXvKsgstqgJl92K4F50RzSozkOBvu31urPE7tUcJZfwnhEjlutJtTlZBSzuxWAHttH+eH7u0sRQHk86tP2NQWKYtn9D4k3tWH7jp9S5SxG7oJP7Mt2N/BRiYx3+MqA8TuaGacGmhWaU+PV1gA6g05LrBrAm/UqQTk27IOho1iCIwZ8y+XYN34d7siOq0yUtm1VZvjy/1+IxmwkHtv0gaHhGjdAPQCaHK0uKD/QzV+E+t1cZ8IKTb87+VwZ38/j0PIPG3ypihp7CwHNBswC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry for the delay.

On (26/02/28 12:05), Andrew Morton wrote:
> On Fri, 27 Feb 2026 17:21:07 +0900 Sergey Senozhatsky <senozhatsky@chromium.org> wrote:
> >
> 
> A nice [0/N] overview would be appropriate for a 5-patch series, please.

Well... I couldn't come up with a nice overview, let me try.


The series is based on internal discussions.  Minchan looked at
recompression recently and pointed out a few things that he thought
were confusing or unexpected/unintuitive, like the fact that zram
would autocorrect bad recompression priority parameter, or some
other assumptions that zram made.  I couldn't explain why it was
like that, and just agreed that it was confusing.  The final patch
in the series removes chained recompression, which also has some
unexpected behavior, so I just decided to simplify the code and
remove that feature.

